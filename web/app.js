/* ================================================
   XSIM Government Portal — Demo JavaScript
   Phone Number + OTP Authentication Flow
   ================================================ */

// ---- Configuration ----
const SERVER_URL = 'https://xsim-otp-server.yangzw.workers.dev'; // Cloudflare Worker

// ---- State ----
let currentPage = 'landing';
let currentPhone = '';

// ---- Page Navigation ----
function goTo(pageId) {
    // Hide current page
    const current = document.getElementById('page-' + currentPage);
    if (current) {
        current.classList.remove('active', 'fade-in');
    }

    // Show target page
    const target = document.getElementById('page-' + pageId);
    if (target) {
        target.classList.add('active');
        requestAnimationFrame(() => {
            target.classList.add('fade-in');
        });
    }

    currentPage = pageId;
    window.scrollTo(0, 0);

    // Page-specific initialization
    if (pageId === 'login') initLoginPage();
    if (pageId === 'otp') initOtpPage();
    if (pageId === 'success') initSuccessPage();
    if (pageId === 'dashboard') initDashboardPage();
}

// ---- Login Page (Phone Number Input) ----
function initLoginPage() {
    // Clear previous errors
    hideError('phone-error');
    // Focus on phone input
    const phoneInput = document.getElementById('phone-input');
    if (phoneInput) {
        phoneInput.value = currentPhone;
        setTimeout(() => phoneInput.focus(), 300);
    }
}

// Submit phone number → request OTP from server
async function submitPhone() {
    const phoneInput = document.getElementById('phone-input');
    const phone = phoneInput ? phoneInput.value.replace(/\s/g, '') : '';

    if (!phone || phone.length < 6) {
        showError('phone-error', 'Please enter a valid phone number');
        return;
    }

    currentPhone = phone;
    const fullPhone = '855' + phone;

    // Show loading state
    const btn = document.getElementById('btn-send-otp');
    const originalText = btn.innerHTML;
    btn.innerHTML = '<span class="btn-spinner"></span> Sending...';
    btn.disabled = true;
    hideError('phone-error');

    try {
        const response = await fetch(SERVER_URL + '/auth/request', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone: fullPhone }),
        });

        const data = await response.json();

        if (data.ok) {
            // Success — go to OTP entry page
            goTo('otp');
        } else {
            showError('phone-error', data.error || 'Failed to send OTP. Please try again.');
        }
    } catch (err) {
        console.error('submitPhone error:', err);
        showError('phone-error', 'Cannot connect to server. Is the XSIM server running?');
    } finally {
        btn.innerHTML = originalText;
        btn.disabled = false;
    }
}

// ---- OTP Entry Page ----
function initOtpPage() {
    // Show the phone number
    const phoneDisplay = document.getElementById('otp-phone-display');
    if (phoneDisplay) {
        phoneDisplay.textContent = '+855 ' + currentPhone;
    }

    // Clear OTP boxes
    for (let i = 1; i <= 4; i++) {
        const box = document.getElementById('otp-' + i);
        if (box) box.value = '';
    }

    // Clear error
    hideError('otp-error');

    // Focus first box
    const firstBox = document.getElementById('otp-1');
    if (firstBox) setTimeout(() => firstBox.focus(), 300);
}

// OTP input auto-advance
function onOtpInput(index) {
    const box = document.getElementById('otp-' + index);
    if (!box) return;

    // Only allow digits
    box.value = box.value.replace(/[^0-9]/g, '');

    // Auto-advance to next box
    if (box.value && index < 4) {
        const next = document.getElementById('otp-' + (index + 1));
        if (next) next.focus();
    }

    // Auto-submit when all 4 digits entered
    if (index === 4 && box.value) {
        const otp = getOtpValue();
        if (otp.length === 4) {
            verifyOtp();
        }
    }
}

// OTP backspace handling
function onOtpKeydown(event, index) {
    if (event.key === 'Backspace') {
        const box = document.getElementById('otp-' + index);
        if (box && !box.value && index > 1) {
            const prev = document.getElementById('otp-' + (index - 1));
            if (prev) {
                prev.value = '';
                prev.focus();
            }
        }
    }
}

// Get combined OTP value
function getOtpValue() {
    let otp = '';
    for (let i = 1; i <= 4; i++) {
        const box = document.getElementById('otp-' + i);
        if (box) otp += box.value;
    }
    return otp;
}

// Verify OTP with server
async function verifyOtp() {
    const otp = getOtpValue();

    if (otp.length !== 4) {
        showError('otp-error', 'Please enter all 4 digits');
        return;
    }

    const fullPhone = '855' + currentPhone;

    // Show loading state
    const btn = document.getElementById('btn-verify-otp');
    const originalText = btn.innerHTML;
    btn.innerHTML = '<span class="btn-spinner"></span> Verifying...';
    btn.disabled = true;
    hideError('otp-error');

    try {
        const response = await fetch(SERVER_URL + '/auth/verify', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone: fullPhone, otp }),
        });

        const data = await response.json();

        if (data.ok) {
            // Success!
            goTo('success');
        } else {
            showError('otp-error', data.error || 'Invalid OTP. Please try again.');
            // Clear OTP boxes on failure
            for (let i = 1; i <= 4; i++) {
                const box = document.getElementById('otp-' + i);
                if (box) box.value = '';
            }
            const firstBox = document.getElementById('otp-1');
            if (firstBox) firstBox.focus();
        }
    } catch (err) {
        console.error('verifyOtp error:', err);
        showError('otp-error', 'Cannot connect to server. Please try again.');
    } finally {
        btn.innerHTML = originalText;
        btn.disabled = false;
    }
}

// Resend OTP
async function resendOtp() {
    const fullPhone = '855' + currentPhone;
    hideError('otp-error');

    try {
        const response = await fetch(SERVER_URL + '/auth/request', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ phone: fullPhone }),
        });

        const data = await response.json();
        if (data.ok) {
            showError('otp-error', '✅ New code sent to your XSIM app!');
            const errEl = document.getElementById('otp-error');
            if (errEl) errEl.style.color = '#16a34a';
        } else {
            showError('otp-error', data.error || 'Failed to resend. Try again.');
        }
    } catch (err) {
        showError('otp-error', 'Cannot connect to server.');
    }
}

// ---- Success Page ----
function initSuccessPage() {
    const timeEl = document.getElementById('verified-time');
    if (timeEl) {
        const now = new Date();
        timeEl.textContent = now.toLocaleTimeString('en-US', {
            hour: '2-digit', minute: '2-digit', second: '2-digit', hour12: true
        }) + ', ' + now.toLocaleDateString('en-US', {
            day: 'numeric', month: 'short', year: 'numeric'
        });
    }
}

// ---- Dashboard Page ----
function initDashboardPage() {
    const loginTimeEl = document.getElementById('last-login-time');
    if (loginTimeEl) {
        const now = new Date();
        loginTimeEl.textContent = now.toLocaleTimeString('en-US', {
            hour: '2-digit', minute: '2-digit', hour12: true
        }) + ' today';
    }
}

// ---- Error Display Helpers ----
function showError(id, message) {
    const el = document.getElementById(id);
    if (el) {
        el.textContent = message;
        el.style.display = 'block';
        el.style.color = ''; // reset to default (red)
    }
}

function hideError(id) {
    const el = document.getElementById(id);
    if (el) {
        el.style.display = 'none';
        el.style.color = '';
    }
}

// ---- Mobile Menu Toggle ----
function toggleMobileMenu() {
    const nav = document.querySelector('.top-nav');
    if (nav) {
        nav.style.display = nav.style.display === 'flex' ? 'none' : 'flex';
        nav.style.flexDirection = 'column';
        nav.style.position = 'absolute';
        nav.style.top = '64px';
        nav.style.right = '16px';
        nav.style.background = 'rgba(15,27,51,0.98)';
        nav.style.padding = '16px 24px';
        nav.style.borderRadius = '12px';
        nav.style.gap = '16px';
        nav.style.boxShadow = '0 10px 40px rgba(0,0,0,0.3)';
    }
}

// ---- Allow Enter key to submit ----
document.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
        if (currentPage === 'login') submitPhone();
    }
});

// ---- Init ----
document.addEventListener('DOMContentLoaded', () => {
    goTo('landing');
});
