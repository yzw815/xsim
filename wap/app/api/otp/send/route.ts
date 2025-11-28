import { NextRequest, NextResponse } from 'next/server';
import { otpStore, generateOtp } from '@/lib/otp-store';
import { logStore } from '@/lib/log-store';

// SODA Campaign API endpoint
const SODA_API_ENDPOINT = 'http://155.12.30.102/send/campaign/msisdn';

export async function POST(request: NextRequest) {
  try {
    const body = await request.json();
    const { msisdn } = body;

    if (!msisdn) {
      logStore.error('OTP', 'Missing msisdn in request');
      return NextResponse.json(
        { success: false, error: 'Missing msisdn' },
        { status: 400 }
      );
    }

    // Generate OTP
    const otp = generateOtp();
    const message = `Your verification code is: ${otp}`;

    // Log: Starting OTP send
    logStore.otpSending(msisdn, otp);

    // Clean up expired OTPs and store new one
    otpStore.cleanup();
    otpStore.set(msisdn, otp);

    // Log API request
    logStore.apiRequest(SODA_API_ENDPOINT, 'POST', { msisdn, message });

    // Send OTP via SODA Campaign API
    try {
      const response = await fetch(SODA_API_ENDPOINT, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ msisdn, message }),
      });

      const responseText = await response.text();
      let responseData: any;
      
      try {
        responseData = JSON.parse(responseText);
      } catch {
        responseData = { raw: responseText };
      }

      // Log API response
      logStore.apiResponse(SODA_API_ENDPOINT, response.status, responseData);

      // Check for success response: {"status":true,"code":200,"message":"campaign sent"}
      if (responseData.status === true && responseData.code === 200) {
        logStore.otpSent(msisdn, otp, responseData.message);
        return NextResponse.json({
          success: true,
          message: 'OTP sent successfully',
          otp: otp, // Include OTP for demo purposes (remove in production)
          apiResponse: responseData.message,
        });
      } else {
        // API returned error
        const errorMsg = responseData.message || responseData.error?.message || 'Unknown error';
        logStore.otpSendFailed(msisdn, errorMsg, responseData.code || response.status);
        return NextResponse.json({
          success: false,
          error: errorMsg,
          otp: otp, // Still return OTP for demo (since it's stored locally)
        });
      }
    } catch (apiError: any) {
      logStore.error('API', 'Failed to call SODA API', { error: apiError.message });
      // Return success anyway for demo purposes (OTP is stored locally)
      logStore.warning('OTP', 'SODA API unavailable, OTP stored locally only', { msisdn, otp });
      return NextResponse.json({
        success: true,
        message: 'OTP generated (API unavailable)',
        otp: otp,
        warning: 'SODA API unavailable, OTP stored locally only',
      });
    }
  } catch (error: any) {
    logStore.error('OTP', 'Internal error while sending OTP', { error: error.message });
    return NextResponse.json(
      { success: false, error: 'Internal server error' },
      { status: 500 }
    );
  }
}
