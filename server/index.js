/* ================================================
   XSIM OTP Server
   - POST /register      → app registers phone + FCM token
   - POST /auth/request   → web requests OTP (generates + pushes to app)
   - POST /auth/verify    → web verifies OTP entered by user
   ================================================ */

const express = require('express');
const cors = require('cors');
const admin = require('firebase-admin');

const app = express();
app.use(cors());
app.use(express.json());

// ---- Firebase Admin Init ----
// Download service account key from Firebase Console:
// Project Settings → Service Accounts → Generate New Private Key
const fs = require('fs');
const serviceAccountPath = './serviceAccountKey.json';

let fcmEnabled = false;
if (fs.existsSync(serviceAccountPath)) {
    const serviceAccount = require(serviceAccountPath);
    admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
    });
    fcmEnabled = true;
    console.log('✅ Firebase Admin initialized — FCM push enabled');
} else {
    console.log('⚠️  No serviceAccountKey.json found — FCM push DISABLED (OTP will still generate)');
    console.log('   To enable push: download key from Firebase Console → save as server/serviceAccountKey.json');
}

// ---- In-Memory Store ----
// Map<phone, { fcmToken, otp, createdAt }>
const store = new Map();

// ---- Helper: Generate 4-digit OTP ----
function generateOtp() {
    return String(1000 + Math.floor(Math.random() * 9000));
}

// ---- Routes ----

// Health check
app.get('/', (req, res) => {
    res.json({
        service: 'XSIM OTP Server',
        status: 'running',
        registeredPhones: store.size,
        fcmEnabled,
    });
});

// 1. App registers phone + FCM token
app.post('/register', (req, res) => {
    const { phone, fcmToken } = req.body;

    if (!phone || !fcmToken) {
        return res.status(400).json({ ok: false, error: 'phone and fcmToken required' });
    }

    // Normalize phone (remove spaces, ensure no leading +)
    const normalizedPhone = phone.replace(/[\s\-\+]/g, '');

    store.set(normalizedPhone, {
        fcmToken,
        otp: null,
        createdAt: Date.now(),
    });

    console.log(`📱 Registered: ${normalizedPhone} → token: ${fcmToken.substring(0, 20)}...`);
    console.log(`   Total registered: ${store.size}`);

    res.json({ ok: true, message: 'Phone registered successfully' });
});

// 2. Web requests OTP → generates OTP, sends FCM push to app
app.post('/auth/request', async (req, res) => {
    const { phone } = req.body;

    if (!phone) {
        return res.status(400).json({ ok: false, error: 'phone required' });
    }

    const normalizedPhone = phone.replace(/[\s\-\+]/g, '');
    const entry = store.get(normalizedPhone);

    if (!entry) {
        console.log(`❌ Phone not registered: ${normalizedPhone}`);
        return res.status(404).json({ ok: false, error: 'Phone not registered. Please register in the XSIM app first.' });
    }

    // Generate OTP
    const otp = generateOtp();
    entry.otp = otp;
    entry.otpCreatedAt = Date.now();
    store.set(normalizedPhone, entry);

    console.log(`🔑 OTP generated for ${normalizedPhone}: ${otp}`);

    // Send FCM push notification to the app
    if (fcmEnabled && entry.fcmToken) {
        try {
            const message = {
                token: entry.fcmToken,
                notification: {
                    title: 'XSIM Authentication',
                    body: `Your verification code is: ${otp}`,
                },
                data: {
                    type: 'otp',
                    otp: otp,
                    phone: normalizedPhone,
                },
                android: {
                    priority: 'high',
                    notification: {
                        channelId: 'xsim_otp',
                        priority: 'high',
                        sound: 'default',
                    },
                },
            };

            const result = await admin.messaging().send(message);
            console.log(`📨 FCM push sent: ${result}`);
        } catch (err) {
            console.error(`❌ FCM push failed: ${err.message}`);
            // Still return OK — OTP was generated, app can poll or user can retry
        }
    } else {
        console.log(`⚠️  FCM disabled — OTP generated but NOT pushed. OTP: ${otp}`);
    }

    res.json({ ok: true, message: 'OTP sent to your XSIM app' });
});

// 3. Web verifies OTP
app.post('/auth/verify', (req, res) => {
    const { phone, otp } = req.body;

    if (!phone || !otp) {
        return res.status(400).json({ ok: false, error: 'phone and otp required' });
    }

    const normalizedPhone = phone.replace(/[\s\-\+]/g, '');
    const entry = store.get(normalizedPhone);

    if (!entry) {
        return res.status(404).json({ ok: false, error: 'Phone not registered' });
    }

    if (!entry.otp) {
        return res.status(400).json({ ok: false, error: 'No OTP was requested for this phone' });
    }

    // Check OTP expiry (5 minutes)
    const otpAge = Date.now() - (entry.otpCreatedAt || 0);
    if (otpAge > 5 * 60 * 1000) {
        entry.otp = null;
        return res.status(400).json({ ok: false, error: 'OTP expired. Please request a new one.' });
    }

    // Match OTP
    if (entry.otp === otp) {
        console.log(`✅ OTP verified for ${normalizedPhone}`);
        entry.otp = null; // One-time use — clear after verification
        res.json({ ok: true, message: 'Authentication successful' });
    } else {
        console.log(`❌ OTP mismatch for ${normalizedPhone}: expected=${entry.otp}, got=${otp}`);
        res.json({ ok: false, error: 'Invalid OTP. Please try again.' });
    }
});

// 4. Debug: list registered phones (for development only)
app.get('/debug/store', (req, res) => {
    const entries = {};
    store.forEach((val, key) => {
        entries[key] = {
            hasToken: !!val.fcmToken,
            otp: val.otp,
            registeredAt: new Date(val.createdAt).toISOString(),
        };
    });
    res.json(entries);
});

// ---- Start Server ----
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`\n🚀 XSIM OTP Server running on http://localhost:${PORT}`);
    console.log(`   FCM Push: ${fcmEnabled ? '✅ Enabled' : '⚠️  Disabled (no serviceAccountKey.json)'}`);
    console.log(`   Endpoints:`);
    console.log(`     POST /register       — app registers phone + FCM token`);
    console.log(`     POST /auth/request   — web requests OTP`);
    console.log(`     POST /auth/verify    — web verifies OTP`);
    console.log(`     GET  /debug/store    — view registered phones\n`);
});
