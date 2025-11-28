// Log entry interface
export interface LogEntry {
  id: string;
  timestamp: number;
  level: 'INFO' | 'SUCCESS' | 'WARNING' | 'ERROR';
  category: 'OTP' | 'API' | 'AUTH' | 'SYSTEM';
  message: string;
  data?: Record<string, any>;
}

// Global log store
const logs: LogEntry[] = [];
const MAX_LOGS = 500;

// Generate unique ID
function generateId(): string {
  return `${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
}

export const logStore = {
  add(
    level: LogEntry['level'],
    category: LogEntry['category'],
    message: string,
    data?: Record<string, any>
  ): LogEntry {
    const entry: LogEntry = {
      id: generateId(),
      timestamp: Date.now(),
      level,
      category,
      message,
      data,
    };

    logs.push(entry);

    // Keep only last MAX_LOGS entries
    while (logs.length > MAX_LOGS) {
      logs.shift();
    }

    // Also log to console
    const dataStr = data ? ` | Data: ${JSON.stringify(data)}` : '';
    console.log(`[${new Date(entry.timestamp).toISOString()}] [${level}] [${category}] ${message}${dataStr}`);

    return entry;
  },

  getAll(): LogEntry[] {
    return [...logs].reverse(); // Newest first
  },

  getByCategory(category: LogEntry['category']): LogEntry[] {
    return logs.filter((log) => log.category === category).reverse();
  },

  getByLevel(level: LogEntry['level']): LogEntry[] {
    return logs.filter((log) => log.level === level).reverse();
  },

  getRecent(count: number): LogEntry[] {
    return logs.slice(-count).reverse();
  },

  clear() {
    logs.length = 0;
    this.info('SYSTEM', 'Logs cleared');
  },

  // Convenience methods
  info(category: LogEntry['category'], message: string, data?: Record<string, any>) {
    return this.add('INFO', category, message, data);
  },

  success(category: LogEntry['category'], message: string, data?: Record<string, any>) {
    return this.add('SUCCESS', category, message, data);
  },

  warning(category: LogEntry['category'], message: string, data?: Record<string, any>) {
    return this.add('WARNING', category, message, data);
  },

  error(category: LogEntry['category'], message: string, data?: Record<string, any>) {
    return this.add('ERROR', category, message, data);
  },

  // OTP specific methods
  otpSending(msisdn: string, otp: string) {
    return this.info('OTP', `Sending OTP to ${msisdn}`, { msisdn, otp });
  },

  otpSent(msisdn: string, otp: string, apiMessage?: string) {
    return this.success('OTP', 'OTP sent successfully', { msisdn, otp, apiResponse: apiMessage });
  },

  otpSendFailed(msisdn: string, error: string, statusCode?: number) {
    return this.error('OTP', 'Failed to send OTP', { msisdn, error, statusCode });
  },

  otpVerifying(enteredOtp: string) {
    return this.info('OTP', 'Verifying OTP', { enteredOtp });
  },

  otpVerified(otp: string) {
    return this.success('OTP', 'OTP verified successfully', { otp });
  },

  otpVerificationFailed(enteredOtp: string, expectedOtp: string) {
    return this.error('OTP', 'OTP verification failed', { enteredOtp, expectedOtp });
  },

  // API logging
  apiRequest(endpoint: string, method: string, body?: any) {
    return this.info('API', `API Request: ${method} ${endpoint}`, { body });
  },

  apiResponse(endpoint: string, statusCode: number, body?: any) {
    const level = statusCode >= 200 && statusCode < 300 ? 'SUCCESS' : 'ERROR';
    return this.add(level, 'API', `API Response: ${statusCode}`, { endpoint, statusCode, body });
  },
};

