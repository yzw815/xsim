'use client'

import { useState, useEffect } from 'react'
import { Button } from '@/components/ui/button'
import { ChevronLeft, Globe, Phone, Smartphone, CheckCircle2, AlertCircle } from 'lucide-react'
import { Input } from '@/components/ui/input'

const translations = {
  en: {
    title1: 'Cambodia',
    title2: 'Government Portal',
    secureLogin: 'Secure Login Powered by',
    xsimAuth: 'XSIM Authentication',
    loginBtn: 'Login',
    language: 'Language',
    khmer: 'Kimer',
    english: 'English',
    verifyTitle: 'Verify Your Mobile Number',
    phonePlaceholder: '12 345 673',
    simRegistered1: 'Your SIM is registered with',
    simRegistered2: 'Ministry of Interior.',
    simRegistered3: 'Please proceed to secure login.',
    continue: 'Continue',
    authenticating: 'Authenticating...',
    checkFlash1: 'Please check the Flash',
    checkFlash2: 'Message on your phone.',
    simPopupTitle: 'Flash Message',
    confirmLogin: 'Confirm Your Login Code',
    approveLogin: 'Do you approve login with code',
    yesBtn: 'YES',
    noBtn: 'NO',
    verifying: 'Verifying Authenticity',
    verifyInfo1: 'XSIM Server is verifying:',
    verifyInfo2: '✓ Signature matches SIM public key',
    verifyInfo3: '✓ Challenge code is correct',
    verifyInfo4: '✓ SIM matches National ID',
    verifyInfo5: '✓ Request is still valid',
    successTitle: 'Access Granted',
    successMessage1: 'Authentication successful!',
    successMessage2: 'Your identity has been verified',
    successMessage3: 'using SIM-based cryptographic signing.',
    tokenReceived: 'Auth Token Received',
    proceedToDashboard: 'Proceed to Dashboard'
  },
  km: {
    title1: 'កម្ពុជា',
    title2: 'ច្រកចូលរដ្ឋាភិបាល',
    secureLogin: 'ការចូលប្រើប្រាស់ដោយសុវត្ថិភាពដោយ',
    xsimAuth: 'XSIM ផ្ទៀងផ្ទាត់',
    loginBtn: 'ចូល',
    language: 'ភាសា',
    khmer: 'ខ្មែរ',
    english: 'អង់គ្លេស',
    verifyTitle: 'ផ្ទៀងផ្ទាត់លេខទូរសព្ទរបស់អ្នក',
    phonePlaceholder: '១២ ៣៤៥ ៦៧៣',
    simRegistered1: 'ស៊ីមរបស់អ្នកបានចុះឈ្មោះជាមួយ',
    simRegistered2: 'ក្រសួងមហាផ្ទៃ។',
    simRegistered3: 'សូមបន្តដើម្បីចូលប្រើប្រាស់ដោយសុវត្ថិភាព។',
    continue: 'បន្ត',
    authenticating: 'កំពុងផ្ទៀងផ្ទាត់...',
    checkFlash1: 'សូមពិនិត្យសារ Flash',
    checkFlash2: 'នៅលើទូរសព្ទរបស់អ្នក។',
    simPopupTitle: 'សារ Flash',
    confirmLogin: 'បញ្ជាក់លេខកូដចូលរបស់អ្នក',
    approveLogin: 'តើអ្នកអនុម័តការចូលជាមួយលេខកូដ',
    yesBtn: 'យល់ព្រម',
    noBtn: 'បដិសេធ',
    verifying: 'កំពុងផ្ទៀងផ្ទាត់',
    verifyInfo1: 'XSIM Server កំពុងពិនិត្យ:',
    verifyInfo2: '✓ ហត្ថលេខាត្រូវគ្នានឹងកូនសោសាធារណៈស៊ីម',
    verifyInfo3: '✓ លេខកូដសាកល្បងត្រឹមត្រូវ',
    verifyInfo4: '✓ ស៊ីមត្រូវគ្នានឹងអត្តសញ្ញាណប័ណ្ណជាតិ',
    verifyInfo5: '✓ សំណើនៅតែមានសុពលភាព',
    successTitle: 'បានអនុញ្ញាត',
    successMessage1: 'ការផ្ទៀងផ្ទាត់ជោគជ័យ!',
    successMessage2: 'អត្តសញ្ញាណរបស់អ្នកត្រូវបានផ្ទៀងផ្ទាត់',
    successMessage3: 'ដោយប្រើការចុះហត្ថលេខាគ្រីបតូក្រាហ្វិកតាមស៊ីម។',
    tokenReceived: 'បានទទួល Auth Token',
    proceedToDashboard: 'ទៅកាន់ផ្ទាំងគ្រប់គ្រង'
  }
}

export default function AuthFlow() {
  const [step, setStep] = useState(1)
  const [language, setLanguage] = useState<'en' | 'km'>('en')
  const [phoneNumber, setPhoneNumber] = useState('')
  const [challengeCode] = useState(() => Math.floor(1000 + Math.random() * 9000).toString())
  const [otpValues, setOtpValues] = useState(['', '', '', ''])
  const [otpError, setOtpError] = useState('')

  const t = translations[language]

  useEffect(() => {
    if (step === 3) {
      const timer = setTimeout(() => {
        setStep(4)
      }, 3000)
      return () => clearTimeout(timer)
    }
  }, [step])

  useEffect(() => {
    if (step === 5) {
      const timer = setTimeout(() => {
        setStep(6)
      }, 3000)
      return () => clearTimeout(timer)
    }
  }, [step])

  const toggleLanguage = () => {
    setLanguage(prev => prev === 'en' ? 'km' : 'en')
  }

  return (
    <main className="min-h-screen bg-white flex items-center justify-center">

      {/* Step 1: Initial Login Screen */}
      {step === 1 && (
        <div className="flex flex-col items-center justify-center px-8 py-12 max-w-md mx-auto w-full min-h-screen">
          <div className="w-16 h-16 mb-12">
            <img 
              src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-AeK1dqTdzm7bSzDCKuwc9d6MNRfFVv.png" 
              alt="Cambodia Royal Arms"
              className="w-full h-full object-contain"
            />
          </div>

          <div className="flex-1 flex flex-col items-center justify-center w-full">
            <h1 className="text-[2.5rem] font-bold text-center mb-8 text-balance leading-tight" style={{ color: '#1e3a8a' }}>
              {t.title1}<br />{t.title2}
            </h1>

            <p className="text-center text-base mb-3 leading-relaxed">
              {t.secureLogin}<br />
              <span className="font-semibold">{t.xsimAuth}</span>
            </p>
          </div>

          <div className="w-full space-y-4">
            <Button 
              onClick={() => setStep(2)}
              className="w-full text-white h-14 rounded-xl font-medium text-lg"
              style={{ backgroundColor: '#1e40af' }}
            >
              {t.loginBtn}
            </Button>

            <button 
              onClick={toggleLanguage}
              className="flex items-center justify-center gap-2 text-sm w-full hover:opacity-70 transition-opacity"
            >
              <span>{t.language}, <span className="font-medium">{language === 'km' ? t.khmer : t.english}</span> | {language === 'km' ? t.english : t.khmer}</span>
            </button>
          </div>

          <div className="w-32 h-1 bg-gray-900 rounded-full mt-4"></div>
        </div>
      )}

      {/* Step 2: Enter Mobile Number */}
      {step === 2 && (
        <div className="flex flex-col px-8 py-12 max-w-md mx-auto w-full min-h-screen justify-center">
          <div className="w-16 h-16 mx-auto mb-8">
            <img 
              src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-AeK1dqTdzm7bSzDCKuwc9d6MNRfFVv.png" 
              alt="Cambodia Royal Arms"
              className="w-full h-full object-contain"
            />
          </div>

          <button onClick={() => setStep(1)} className="self-start mb-8 absolute left-8 top-16">
            <ChevronLeft className="w-6 h-6" />
          </button>

          <div className="flex-1 flex flex-col pt-12">
            <h1 className="text-3xl font-bold text-center mb-12 text-balance" style={{ color: '#1e3a8a' }}>
              {t.verifyTitle}
            </h1>

            <div className="bg-gray-100 rounded-2xl p-5 mb-8">
              <div className="flex items-center gap-2">
                <span className="text-base font-normal">+855</span>
                <Input
                  type="tel"
                  value={phoneNumber}
                  onChange={(e) => setPhoneNumber(e.target.value)}
                  placeholder={t.phonePlaceholder}
                  className="border-0 bg-transparent text-base font-normal p-0 h-auto focus-visible:ring-0 focus-visible:ring-offset-0"
                />
              </div>
            </div>

            <div className="space-y-1 text-base text-center leading-relaxed">
              <p>{t.simRegistered1}</p>
              <p>{t.simRegistered2}</p>
              <p>{t.simRegistered3}</p>
            </div>
          </div>

          <Button 
            onClick={() => setStep(3)}
            className="w-full text-white h-14 rounded-xl font-medium text-lg mt-8"
            style={{ backgroundColor: '#1e40af' }}
          >
            {t.continue}
          </Button>

          <div className="w-32 h-1 bg-gray-900 rounded-full mt-4 mx-auto"></div>
        </div>
      )}

      {/* Step 3: Authenticating Loading Screen */}
      {step === 3 && (
        <div className="flex flex-col px-8 py-12 max-w-md mx-auto w-full min-h-screen justify-center">
          <div className="w-16 h-16 mx-auto mb-6">
            <img 
              src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-AeK1dqTdzm7bSzDCKuwc9d6MNRfFVv.png" 
              alt="Cambodia Royal Arms"
              className="w-full h-full object-contain"
            />
          </div>

          <button onClick={() => setStep(2)} className="self-start mb-8 absolute left-8 top-16">
            <ChevronLeft className="w-6 h-6" />
          </button>

          <div className="flex-1 flex flex-col items-center justify-center pt-12">
            <h1 className="text-3xl font-bold text-center mb-16" style={{ color: '#1e3a8a' }}>
              {t.authenticating}
            </h1>

            <div className="relative mb-16">
              <div className="w-32 h-32 rounded-3xl flex items-center justify-center" style={{ backgroundColor: '#1e40af' }}>
                <div className="relative">
                  <Smartphone className="w-16 h-16 text-white" strokeWidth={2} />
                  <div className="absolute -bottom-2 -right-2 w-10 h-10 rounded-full flex items-center justify-center" style={{ backgroundColor: '#1e40af' }}>
                    <svg className="w-6 h-6 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2.5} d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                    </svg>
                  </div>
                </div>
              </div>
              {/* Loading spinner */}
              <div className="absolute inset-0 border-4 border-transparent rounded-3xl animate-spin" style={{ borderTopColor: '#1e40af' }} />
            </div>

            <div className="text-center space-y-1 text-base leading-relaxed">
              <p>{t.checkFlash1}</p>
              <p>{t.checkFlash2}</p>
            </div>
          </div>

          <Button 
            className="w-full text-white h-14 rounded-xl font-medium text-lg mt-8"
            style={{ backgroundColor: '#1e40af' }}
            disabled
          >
            {t.continue}
          </Button>

          <div className="w-32 h-1 bg-gray-900 rounded-full mt-4 mx-auto"></div>
        </div>
      )}

      {/* Step 4: OTP Input - Normal Page Layout */}
      {step === 4 && (
        <div className="flex flex-col px-8 py-12 max-w-md mx-auto w-full min-h-screen justify-center">
          <div className="w-16 h-16 mx-auto mb-6">
            <img 
              src="https://hebbkx1anhila5yf.public.blob.vercel-storage.com/image-AeK1dqTdzm7bSzDCKuwc9d6MNRfFVv.png" 
              alt="Cambodia Royal Arms"
              className="w-full h-full object-contain"
            />
          </div>

          <button onClick={() => setStep(2)} className="self-start mb-8 absolute left-8 top-16">
            <ChevronLeft className="w-6 h-6" />
          </button>

          <div className="flex-1 flex flex-col pt-12">
            <h1 className="text-3xl font-bold text-center mb-4 text-balance" style={{ color: '#1e3a8a' }}>
              {t.confirmLogin}
            </h1>

            <p className="text-center text-base mb-12 leading-relaxed">
              {t.checkFlash1}
            </p>

            {/* OTP Input Boxes */}
            <div className="flex justify-center gap-4 mb-8">
              {[0, 1, 2, 3].map((index) => (
                <input
                  key={index}
                  type="text"
                  inputMode="numeric"
                  maxLength={1}
                  value={otpValues[index]}
                  onChange={(e) => {
                    const value = e.target.value.replace(/[^0-9]/g, '')
                    if (value.length <= 1) {
                      const newOtpValues = [...otpValues]
                      newOtpValues[index] = value
                      setOtpValues(newOtpValues)
                      setOtpError('')

                      // Auto-focus next input
                      if (value && index < 3) {
                        const nextInput = document.getElementById(`otp-${index + 1}`)
                        nextInput?.focus()
                      }

                      // Auto-validate when all filled
                      if (newOtpValues.every(v => v !== '')) {
                        const enteredCode = newOtpValues.join('')
                        if (enteredCode === challengeCode) {
                          setTimeout(() => setStep(5), 300)
                        } else {
                          setOtpError('Incorrect code. Please try again.')
                        }
                      }
                    }
                  }}
                  onKeyDown={(e) => {
                    // Handle backspace
                    if (e.key === 'Backspace' && !otpValues[index] && index > 0) {
                      const prevInput = document.getElementById(`otp-${index - 1}`)
                      prevInput?.focus()
                    }
                  }}
                  id={`otp-${index}`}
                  className="w-16 h-16 text-center text-3xl font-bold border-2 rounded-xl focus:border-[#1e40af] focus:outline-none transition-colors"
                  style={{ 
                    borderColor: otpError ? '#ef4444' : '#e5e7eb',
                    color: '#1e3a8a'
                  }}
                />
              ))}
            </div>

            {/* Info Box (Demo) */}
            <div className="bg-blue-50 border-2 border-blue-200 rounded-xl p-4 mb-8">
              <div className="flex items-start gap-2">
                <svg className="w-5 h-5 text-blue-700 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                  <path fillRule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a1 1 0 000 2v3a1 1 0 001 1h1a1 1 0 100-2v-3a1 1 0 00-1-1H9z" clipRule="evenodd" />
                </svg>
                <p className="text-sm text-blue-900">Enter code: {challengeCode}</p>
              </div>
            </div>

            {/* Error Message */}
            {otpError && (
              <div className="bg-red-50 border-2 border-red-200 rounded-xl p-4 mb-8">
                <p className="text-sm text-red-900 text-center">{otpError}</p>
              </div>
            )}
          </div>

          <Button 
            onClick={() => {
              const enteredCode = otpValues.join('')
              if (enteredCode.length === 4) {
                if (enteredCode === challengeCode) {
                  setStep(5)
                } else {
                  setOtpError('Incorrect code. Please try again.')
                }
              }
            }}
            className="w-full text-white h-14 rounded-xl font-medium text-lg mt-8"
            style={{ backgroundColor: '#1e40af' }}
          >
            {t.continue}
          </Button>

          <div className="w-32 h-1 bg-gray-900 rounded-full mt-4 mx-auto"></div>
        </div>
      )}

      {/* Step 5: XSIM Server Verifies Authenticity */}
      {step === 5 && (
        <div className="flex flex-col p-8 py-12 max-w-md mx-auto w-full min-h-screen justify-center">
          <div className="flex-1 flex flex-col items-center justify-center">
            <h1 className="text-3xl font-bold text-center mb-16">
              {t.verifying}
            </h1>

            <div className="relative mb-16">
              <div className="w-40 h-40 rounded-full bg-gradient-to-br from-blue-50 to-blue-100 flex items-center justify-center">
                <AlertCircle className="w-20 h-20 text-[#0066CC]" strokeWidth={2} />
              </div>
              <div className="absolute inset-0 border-4 border-transparent border-t-[#0066CC] rounded-full animate-spin" />
            </div>

            <div className="text-left space-y-3 text-base leading-relaxed max-w-xs">
              <p className="font-semibold mb-4">{t.verifyInfo1}</p>
              <p>{t.verifyInfo2}</p>
              <p>{t.verifyInfo3}</p>
              <p>{t.verifyInfo4}</p>
              <p>{t.verifyInfo5}</p>
            </div>
          </div>
        </div>
      )}

      {/* Step 6: Success - Access Granted */}
      {step === 6 && (
        <div className="flex flex-col items-center justify-center p-8 py-12 max-w-md mx-auto w-full min-h-screen">
          <div className="flex-1 flex flex-col items-center justify-center">
            <div className="relative mb-12">
              <div className="w-40 h-40 rounded-full bg-gradient-to-br from-green-50 to-green-100 flex items-center justify-center">
                <CheckCircle2 className="w-24 h-24 text-green-600" strokeWidth={2} />
              </div>
            </div>

            <h1 className="text-4xl font-bold text-center mb-8 text-balance text-green-600">
              {t.successTitle}
            </h1>

            <div className="text-center space-y-2 text-base leading-relaxed mb-8">
              <p className="font-semibold text-lg">{t.successMessage1}</p>
              <p>{t.successMessage2}</p>
              <p>{t.successMessage3}</p>
            </div>

            <div className="bg-green-50 border-2 border-green-200 rounded-xl p-4 mb-12">
              <p className="text-sm text-green-800 font-medium">🔐 {t.tokenReceived}</p>
            </div>
          </div>

          <Button 
            onClick={() => alert('Redirecting to dashboard...')}
            className="w-full bg-[#0066CC] hover:bg-[#0052A3] text-white h-14 rounded-xl font-medium text-lg"
          >
            {t.proceedToDashboard}
          </Button>
        </div>
      )}
    </main>
  )
}
