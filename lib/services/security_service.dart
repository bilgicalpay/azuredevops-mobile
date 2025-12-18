import 'package:flutter_root_jailbreak_checker/flutter_root_jailbreak_checker.dart';
import 'package:logging/logging.dart';

/// Security service for device security checks and logging
class SecurityService {
  static final Logger _logger = Logger('SecurityService');
  static bool _isInitialized = false;

  /// Initialize security service
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Setup logging
    Logger.root.level = Level.INFO;
    Logger.root.onRecord.listen((record) {
      // Log to console in debug mode
      if (record.level >= Level.WARNING) {
        print('${record.level.name}: ${record.time}: ${record.message}');
      }
    });
    
    _isInitialized = true;
    _logSecurityEvent('SecurityService initialized');
  }

  /// Check if device is rooted (Android) or jailbroken (iOS)
  static Future<bool> isDeviceCompromised() async {
    try {
      final checker = FlutterRootJailbreakChecker();
      
      // Use the check() method with empty options
      // This is the standard API for flutter_root_jailbreak_checker 2.0+
      final result = await checker.check(RootJailbreakCheckOptions());
      
      final isRooted = result.isRooted;
      final isJailbroken = result.isJailbroken;
      final isCompromised = isRooted || isJailbroken;
      
      if (isCompromised) {
        _logSecurityEvent(
          'Device is compromised (rooted: $isRooted, jailbroken: $isJailbroken)',
          Level.SEVERE
        );
      } else {
        _logSecurityEvent(
          'Device security check passed (rooted: $isRooted, jailbroken: $isJailbroken)',
          Level.INFO
        );
      }
      
      return isCompromised;
    } catch (e) {
      _logSecurityEvent('Error checking device security: $e', Level.SEVERE);
      // On error, assume device is not compromised to avoid blocking legitimate users
      // Log the error for investigation
      return false;
    }
  }

  /// Log security events
  static void _logSecurityEvent(String message, [Level level = Level.INFO]) {
    _logger.log(level, message);
    // In production, send to security monitoring service
    // TODO: Integrate with security monitoring service
  }

  /// Log security events (public)
  static void logSecurityEvent(String message, [Level level = Level.INFO]) {
    _logSecurityEvent(message, level);
  }

  /// Log authentication events
  static void logAuthentication(String event, {Map<String, dynamic>? details}) {
    _logSecurityEvent('Auth: $event ${details ?? {}}', Level.INFO);
  }

  /// Log token operations
  static void logTokenOperation(String operation, {bool success = true}) {
    _logSecurityEvent('Token: $operation - ${success ? "SUCCESS" : "FAILED"}', 
        success ? Level.INFO : Level.WARNING);
  }

  /// Log API calls
  static void logApiCall(String endpoint, {String? method, int? statusCode}) {
    _logSecurityEvent('API: $method $endpoint - Status: $statusCode', Level.INFO);
  }

  /// Log sensitive data access
  static void logSensitiveDataAccess(String dataType, {bool authorized = true}) {
    _logSecurityEvent('Data Access: $dataType - ${authorized ? "AUTHORIZED" : "UNAUTHORIZED"}', 
        authorized ? Level.INFO : Level.SEVERE);
  }
}
