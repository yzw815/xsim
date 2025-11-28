// Shared OTP storage module
// In production, use Redis or a database

interface OtpData {
  otp: string;
  timestamp: number;
  msisdn: string;
}

// Global OTP store
const globalStore = new Map<string, OtpData>();

// OTP expiry time (5 minutes)
export const OTP_EXPIRY_MS = 5 * 60 * 1000;

export const otpStore = {
  set(msisdn: string, otp: string) {
    globalStore.set(msisdn, {
      otp,
      timestamp: Date.now(),
      msisdn,
    });
  },

  get(msisdn: string): OtpData | undefined {
    return globalStore.get(msisdn);
  },

  delete(msisdn: string) {
    globalStore.delete(msisdn);
  },

  isExpired(msisdn: string): boolean {
    const data = globalStore.get(msisdn);
    if (!data) return true;
    return Date.now() - data.timestamp > OTP_EXPIRY_MS;
  },

  verify(msisdn: string, otp: string): { valid: boolean; error?: string } {
    const data = globalStore.get(msisdn);
    
    if (!data) {
      return { valid: false, error: 'No OTP found for this number' };
    }
    
    if (Date.now() - data.timestamp > OTP_EXPIRY_MS) {
      globalStore.delete(msisdn);
      return { valid: false, error: 'OTP has expired' };
    }
    
    if (data.otp !== otp) {
      return { valid: false, error: 'Invalid OTP' };
    }
    
    // Clear OTP after successful verification
    globalStore.delete(msisdn);
    return { valid: true };
  },

  cleanup() {
    const now = Date.now();
    for (const [msisdn, data] of globalStore.entries()) {
      if (now - data.timestamp > OTP_EXPIRY_MS) {
        globalStore.delete(msisdn);
      }
    }
  },
};

// Generate a 4-digit OTP
export function generateOtp(): string {
  return (1000 + Math.floor(Math.random() * 9000)).toString();
}

