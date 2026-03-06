import { Hono } from 'hono';
import { cors } from 'hono/cors';

const app = new Hono();

// Enable CORS for all origins
app.use('*', cors());

// ──────────────────────────────────────────
// Helper: Generate 4-digit OTP
// ──────────────────────────────────────────
function generateOtp() {
    return String(1000 + Math.floor(Math.random() * 9000));
}

// ──────────────────────────────────────────
// Helper: Get Google OAuth2 access token from service account
// Uses JWT → access_token exchange (for FCM HTTP v1 API)
// ──────────────────────────────────────────
async function getAccessToken(serviceAccount) {
    const now = Math.floor(Date.now() / 1000);
    const header = { alg: 'RS256', typ: 'JWT' };
    const payload = {
        iss: serviceAccount.client_email,
        scope: 'https://www.googleapis.com/auth/firebase.messaging',
        aud: 'https://oauth2.googleapis.com/token',
        iat: now,
        exp: now + 3600,
    };

    // Base64url encode
    const b64url = (obj) => {
        const json = JSON.stringify(obj);
        const b64 = btoa(String.fromCharCode(...new TextEncoder().encode(json)));
        return b64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
    };

    const headerB64 = b64url(header);
    const payloadB64 = b64url(payload);
    const unsignedToken = `${headerB64}.${payloadB64}`;

    // Import private key and sign
    const pemContents = serviceAccount.private_key
        .replace(/-----BEGIN PRIVATE KEY-----/, '')
        .replace(/-----END PRIVATE KEY-----/, '')
        .replace(/\n/g, '');
    const binaryKey = Uint8Array.from(atob(pemContents), (c) => c.charCodeAt(0));

    const cryptoKey = await crypto.subtle.importKey(
        'pkcs8',
        binaryKey,
        { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
        false,
        ['sign']
    );

    const signature = await crypto.subtle.sign(
        'RSASSA-PKCS1-v1_5',
        cryptoKey,
        new TextEncoder().encode(unsignedToken)
    );

    const sigB64 = btoa(String.fromCharCode(...new Uint8Array(signature)))
        .replace(/\+/g, '-')
        .replace(/\//g, '_')
        .replace(/=+$/, '');

    const jwt = `${unsignedToken}.${sigB64}`;

    // Exchange JWT for access token
    const tokenRes = await fetch('https://oauth2.googleapis.com/token', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
    });

    const tokenData = await tokenRes.json();
    return tokenData.access_token;
}

// ──────────────────────────────────────────
// Helper: Send FCM push notification via HTTP v1 API
// ──────────────────────────────────────────
async function sendFcmPush(env, fcmToken, phone, otp) {
    try {
        const serviceAccount = JSON.parse(env.FIREBASE_SERVICE_ACCOUNT);
        const accessToken = await getAccessToken(serviceAccount);
        const projectId = serviceAccount.project_id;

        const res = await fetch(
            `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
            {
                method: 'POST',
                headers: {
                    Authorization: `Bearer ${accessToken}`,
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    message: {
                        token: fcmToken,
                        data: {
                            type: 'otp',
                            otp: otp,
                            phone: phone,
                        },
                        notification: {
                            title: 'XSIM Verification',
                            body: `Your verification code is: ${otp}`,
                        },
                        android: {
                            priority: 'high',
                        },
                    },
                }),
            }
        );

        const result = await res.json();
        console.log('FCM result:', JSON.stringify(result));
        return res.ok;
    } catch (err) {
        console.error('FCM error:', err.message);
        return false;
    }
}

// ──────────────────────────────────────────
// POST /register — App registers phone + FCM token
// ──────────────────────────────────────────
app.post('/register', async (c) => {
    const { phone, fcmToken } = await c.req.json();

    if (!phone) {
        return c.json({ ok: false, error: 'Phone number is required' }, 400);
    }

    // Store in KV: phone → { fcmToken, registeredAt }
    await c.env.XSIM_KV.put(
        `phone:${phone}`,
        JSON.stringify({
            fcmToken: fcmToken || null,
            registeredAt: new Date().toISOString(),
        }),
        { expirationTtl: 86400 * 30 } // 30 days
    );

    console.log(`📱 Registered: ${phone} → token: ${fcmToken?.substring(0, 20)}...`);
    return c.json({ ok: true, message: 'Phone registered successfully' });
});

// ──────────────────────────────────────────
// POST /auth/request — Web portal requests OTP for a phone
// ──────────────────────────────────────────
app.post('/auth/request', async (c) => {
    const { phone } = await c.req.json();

    if (!phone) {
        return c.json({ ok: false, error: 'Phone number is required' }, 400);
    }

    // Normalize
    const normalizedPhone = phone.replace(/[\s\-\+]/g, '');

    // Check if phone is registered
    const stored = await c.env.XSIM_KV.get(`phone:${normalizedPhone}`, 'json');

    if (!stored) {
        return c.json(
            { ok: false, error: 'Phone not registered. Please register in the XSIM app first.' },
            404
        );
    }

    // Generate OTP
    const otp = generateOtp();

    // Store OTP with 5-minute TTL
    await c.env.XSIM_KV.put(
        `otp:${normalizedPhone}`,
        JSON.stringify({ otp, createdAt: new Date().toISOString() }),
        { expirationTtl: 300 }
    );

    console.log(`🔑 OTP generated for ${normalizedPhone}: ${otp}`);

    // Send push notification if FCM token exists
    let pushed = false;
    if (stored.fcmToken && c.env.FIREBASE_SERVICE_ACCOUNT) {
        pushed = await sendFcmPush(c.env, stored.fcmToken, normalizedPhone, otp);
        console.log(pushed ? '✅ FCM push sent' : '⚠️ FCM push failed');
    }

    return c.json({
        ok: true,
        message: 'OTP sent to your XSIM app',
        pushed,
    });
});

// ──────────────────────────────────────────
// POST /auth/verify — Web portal verifies OTP
// ──────────────────────────────────────────
app.post('/auth/verify', async (c) => {
    const { phone, otp } = await c.req.json();

    if (!phone || !otp) {
        return c.json({ ok: false, error: 'Phone and OTP are required' }, 400);
    }

    const normalizedPhone = phone.replace(/[\s\-\+]/g, '');

    // Get stored OTP
    const stored = await c.env.XSIM_KV.get(`otp:${normalizedPhone}`, 'json');

    if (!stored) {
        return c.json({ ok: false, error: 'No OTP was requested for this phone' }, 400);
    }

    if (stored.otp !== otp) {
        console.log(`❌ OTP mismatch for ${normalizedPhone}: expected=${stored.otp}, got=${otp}`);
        return c.json({ ok: false, error: 'Invalid OTP. Please try again.' }, 401);
    }

    // OTP correct — delete it (one-time use)
    await c.env.XSIM_KV.delete(`otp:${normalizedPhone}`);
    console.log(`✅ OTP verified for ${normalizedPhone}`);

    return c.json({ ok: true, message: 'Authentication successful' });
});

// ──────────────────────────────────────────
// GET /debug/store — View registered phones (debug only)
// ──────────────────────────────────────────
app.get('/debug/store', async (c) => {
    const list = await c.env.XSIM_KV.list({ prefix: 'phone:' });
    const result = {};

    for (const key of list.keys) {
        const phone = key.name.replace('phone:', '');
        const data = await c.env.XSIM_KV.get(key.name, 'json');
        const otpData = await c.env.XSIM_KV.get(`otp:${phone}`, 'json');
        result[phone] = {
            hasToken: !!data?.fcmToken,
            otp: otpData?.otp || null,
            registeredAt: data?.registeredAt,
        };
    }

    return c.json(result);
});

// ──────────────────────────────────────────
// GET / — Health check
// ──────────────────────────────────────────
app.get('/', (c) => {
    return c.json({
        service: 'XSIM OTP Server',
        status: 'running',
        version: '1.0.0',
        endpoints: {
            'POST /register': 'App registers phone + FCM token',
            'POST /auth/request': 'Web requests OTP',
            'POST /auth/verify': 'Web verifies OTP',
            'GET /debug/store': 'View registered phones',
        },
    });
});

export default app;
