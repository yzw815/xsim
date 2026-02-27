/* ================================================
   XSIM Government Portal — Demo JavaScript
   ================================================ */

// ---- Page Navigation ----
let currentPage = 'landing';
let qrInterval = null;
let waitingTimeout = null;

function goTo(pageId) {
    // Clean up timers
    if (qrInterval) { clearInterval(qrInterval); qrInterval = null; }
    if (waitingTimeout) { clearTimeout(waitingTimeout); waitingTimeout = null; }

    // Hide current page
    const current = document.getElementById('page-' + currentPage);
    if (current) {
        current.classList.remove('active', 'fade-in');
    }

    // Show target page
    const target = document.getElementById('page-' + pageId);
    if (target) {
        target.classList.add('active');
        // Small delay to trigger fade-in animation
        requestAnimationFrame(() => {
            target.classList.add('fade-in');
        });
    }

    currentPage = pageId;
    window.scrollTo(0, 0);

    // Page-specific initialization
    if (pageId === 'login') initLoginPage();
    if (pageId === 'success') initSuccessPage();
    if (pageId === 'dashboard') initDashboardPage();
}

// ---- Login Page ----
function initLoginPage() {
    startQrTimer();
}

function startQrTimer() {
    let seconds = 60;
    const countdownEl = document.getElementById('qr-countdown');
    const timerBar = document.getElementById('timer-bar');

    if (countdownEl) countdownEl.textContent = seconds;
    if (timerBar) timerBar.style.width = '100%';

    qrInterval = setInterval(() => {
        seconds--;
        if (countdownEl) countdownEl.textContent = seconds;
        if (timerBar) timerBar.style.width = (seconds / 60 * 100) + '%';

        if (seconds <= 0) {
            clearInterval(qrInterval);
            qrInterval = null;
            // Reset QR code
            if (countdownEl) countdownEl.textContent = 'Expired';
            if (timerBar) timerBar.style.width = '0%';
        }
    }, 1000);
}

// ---- Start Auth Simulation ----
function startAuth() {
    goTo('waiting');
    simulateAuth();
}

function simulateAuth() {
    const steps = [
        { id: 'ws-1', delay: 0 },
        { id: 'ws-2', delay: 1500 },
        { id: 'ws-3', delay: 3000 },
        { id: 'ws-4', delay: 4500 },
    ];

    // Reset all steps
    steps.forEach(s => {
        const el = document.getElementById(s.id);
        if (el) {
            el.className = 'w-step pending';
            el.innerHTML = '<span class="w-dot"></span><span>' + el.querySelector('span:last-child').textContent + '</span>';
        }
    });

    // Step 1: Already completed (QR scanned)
    setTimeout(() => {
        markStepCompleted('ws-1');
        markStepActive('ws-2');
    }, 600);

    // Step 2: SIM signature
    setTimeout(() => {
        markStepCompleted('ws-2');
        markStepActive('ws-3');
    }, 2500);

    // Step 3: Server verification
    setTimeout(() => {
        markStepCompleted('ws-3');
        markStepActive('ws-4');
    }, 4000);

    // Step 4: Complete — go to success
    waitingTimeout = setTimeout(() => {
        markStepCompleted('ws-4');
        setTimeout(() => goTo('success'), 500);
    }, 5200);
}

function markStepCompleted(id) {
    const el = document.getElementById(id);
    if (!el) return;
    const text = el.querySelector('span:last-child')?.textContent || '';
    el.className = 'w-step completed';
    el.innerHTML = '<span class="w-check">✓</span><span>' + text + '</span>';
}

function markStepActive(id) {
    const el = document.getElementById(id);
    if (!el) return;
    const text = el.querySelector('span:last-child')?.textContent || '';
    el.className = 'w-step active';
    el.innerHTML = '<span class="w-spinner"></span><span>' + text + '</span>';
}

// ---- Success Page ----
function initSuccessPage() {
    const timeEl = document.getElementById('verified-time');
    if (timeEl) {
        const now = new Date();
        timeEl.textContent = now.toLocaleTimeString('en-US', {
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: true
        }) + ', ' + now.toLocaleDateString('en-US', {
            day: 'numeric',
            month: 'short',
            year: 'numeric'
        });
    }
}

// ---- Dashboard Page ----
function initDashboardPage() {
    const loginTimeEl = document.getElementById('last-login-time');
    if (loginTimeEl) {
        const now = new Date();
        loginTimeEl.textContent = now.toLocaleTimeString('en-US', {
            hour: '2-digit',
            minute: '2-digit',
            hour12: true
        }) + ' today';
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

// ---- Init ----
document.addEventListener('DOMContentLoaded', () => {
    // Ensure landing is active on load
    goTo('landing');
});
