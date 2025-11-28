import { NextRequest, NextResponse } from 'next/server';
import { otpStore } from '@/lib/otp-store';
import { logStore } from '@/lib/log-store';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { msisdn, otp } = body;

    if (!msisdn || !otp) {
      logStore.error('OTP', 'Missing msisdn or otp in verification request');
      return NextResponse.json(
        { success: false, error: 'Missing msisdn or otp' },
        { status: 400 }
      );
    }

    // Log: Verifying OTP
    logStore.otpVerifying(otp);

    // Verify OTP
    const result = otpStore.verify(msisdn, otp);

    if (result.valid) {
      logStore.otpVerified(otp);
      return NextResponse.json({
        success: true,
        valid: true,
        message: 'OTP verified successfully',
      });
    } else {
      const storedData = otpStore.get(msisdn);
      logStore.otpVerificationFailed(otp, storedData?.otp || 'N/A');
      return NextResponse.json({
        success: false,
        valid: false,
        error: result.error || 'Invalid OTP',
      });
    }
  } catch (error: any) {
    logStore.error('OTP', 'Internal error during verification', { error: error.message });
    return NextResponse.json(
      { success: false, error: 'Internal server error' },
      { status: 500 }
    );
  }
}
