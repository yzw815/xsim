import 'dart:collection';

class LogEntry {
  final DateTime timestamp;
  final String level; // INFO, SUCCESS, ERROR, WARNING
  final String category; // OTP, API, AUTH, etc.
  final String message;
  final Map<String, dynamic>? data;

  LogEntry({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.data,
  });

  @override
  String toString() {
    final dataStr = data != null ? ' | Data: $data' : '';
    return '[${timestamp.toIso8601String()}] [$level] [$category] $message$dataStr';
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'level': level,
        'category': category,
        'message': message,
        'data': data,
      };
}

class LogService {
  // Singleton pattern
  static final LogService _instance = LogService._internal();
  factory LogService() => _instance;
  LogService._internal();

  // Store logs in memory (max 500 entries to prevent memory issues)
  final Queue<LogEntry> _logs = Queue<LogEntry>();
  static const int _maxLogs = 500;

  // Get all logs
  List<LogEntry> get logs => _logs.toList();

  // Get logs filtered by category
  List<LogEntry> getLogsByCategory(String category) {
    return _logs.where((log) => log.category == category).toList();
  }

  // Get logs filtered by level
  List<LogEntry> getLogsByLevel(String level) {
    return _logs.where((log) => log.level == level).toList();
  }

  // Get recent logs (last N entries)
  List<LogEntry> getRecentLogs(int count) {
    final logList = _logs.toList();
    if (logList.length <= count) return logList;
    return logList.sublist(logList.length - count);
  }

  // Add a log entry
  void _addLog(String level, String category, String message, {Map<String, dynamic>? data}) {
    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      category: category,
      message: message,
      data: data,
    );

    _logs.addLast(entry);

    // Remove oldest logs if exceeding max
    while (_logs.length > _maxLogs) {
      _logs.removeFirst();
    }

    // Also print to console for immediate debugging
    print(entry.toString());
  }

  // Convenience methods for different log levels
  void info(String category, String message, {Map<String, dynamic>? data}) {
    _addLog('INFO', category, message, data: data);
  }

  void success(String category, String message, {Map<String, dynamic>? data}) {
    _addLog('SUCCESS', category, message, data: data);
  }

  void error(String category, String message, {Map<String, dynamic>? data}) {
    _addLog('ERROR', category, message, data: data);
  }

  void warning(String category, String message, {Map<String, dynamic>? data}) {
    _addLog('WARNING', category, message, data: data);
  }

  // OTP specific logging methods
  void otpSending(String msisdn, String otp) {
    info('OTP', 'Sending OTP to $msisdn', data: {'msisdn': msisdn, 'otp': otp});
  }

  void otpSent(String msisdn, String otp, String apiMessage) {
    success('OTP', 'OTP sent successfully', data: {
      'msisdn': msisdn,
      'otp': otp,
      'apiResponse': apiMessage,
    });
  }

  void otpSendFailed(String msisdn, String errorMessage, {int? statusCode}) {
    error('OTP', 'Failed to send OTP', data: {
      'msisdn': msisdn,
      'error': errorMessage,
      if (statusCode != null) 'statusCode': statusCode,
    });
  }

  void otpVerifying(String enteredOtp) {
    info('OTP', 'Verifying OTP', data: {'enteredOtp': enteredOtp});
  }

  void otpVerified(String otp) {
    success('OTP', 'OTP verified successfully', data: {'otp': otp});
  }

  void otpVerificationFailed(String enteredOtp, String expectedOtp) {
    error('OTP', 'OTP verification failed', data: {
      'enteredOtp': enteredOtp,
      'expectedOtp': expectedOtp,
    });
  }

  // API logging methods
  void apiRequest(String endpoint, String method, Map<String, dynamic> body) {
    info('API', 'API Request: $method $endpoint', data: {'body': body});
  }

  void apiResponse(String endpoint, int statusCode, String body) {
    final level = statusCode >= 200 && statusCode < 300 ? 'SUCCESS' : 'ERROR';
    _addLog(level, 'API', 'API Response: $statusCode', data: {
      'endpoint': endpoint,
      'statusCode': statusCode,
      'body': body,
    });
  }

  // Clear all logs
  void clearLogs() {
    _logs.clear();
    info('SYSTEM', 'Logs cleared');
  }

  // Export logs as string
  String exportLogs() {
    return _logs.map((log) => log.toString()).join('\n');
  }

  // Export logs as JSON
  List<Map<String, dynamic>> exportLogsAsJson() {
    return _logs.map((log) => log.toJson()).toList();
  }
}

