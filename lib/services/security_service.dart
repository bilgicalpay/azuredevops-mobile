import 'dart:io';
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
      bool isRooted = false;
      bool isJailbroken = false;
      
      // Check for root (Android)
      if (Platform.isAndroid) {
        try {
          // Try different method names based on package version
          try {
            isRooted = await checker.isRooted();
          } catch (e) {
            // Try alternative method name
            try {
              isRooted = await checker.checkRoot();
            } catch (e2) {
              // If both fail, try checking result directly
              final result = await checker.check();
              isRooted = result.isRooted ?? false;
            }
          }
        } catch (e) {
          _logSecurityEvent('Root check error: $e', Level.WARNING);
          isRooted = false;
        }
      }
      
      // Check for jailbreak (iOS)
      if (Platform.isIOS) {
        try {
          // Try different method names based on package version
          try {
            isJailbroken = await checker.isJailbroken();
          } catch (e) {
            // Try alternative method name
            try {
              isJailbroken = await checker.checkJailbreak();
            } catch (e2) {
              // If both fail, try checking result directly
              final result = await checker.check();
              isJailbroken = result.isJailbroken ?? false;
            }
          }
        } catch (e) {
          _logSecurityEvent('Jailbreak check error: $e', Level.WARNING);
          isJailbroken = false;
        }
      }
      
      final isCompromised = isRooted || isJailbroken;
      
      if (isCompromised) {
        _logSecurityEvent('Device is compromised (rooted: $isRooted, jailbroken: $isJailbroken)', Level.SEVERE);
      }
      
      return isCompromised;
    } catch (e) {
      _logSecurityEvent('Error checking device security: $e', Level.SEVERE);
      // On error, assume device is not compromised to avoid blocking legitimate users
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
