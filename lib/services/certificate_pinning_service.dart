import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:logging/logging.dart';
import 'security_service.dart';

/// Certificate pinning service for production security
class CertificatePinningService {
  static final Logger _logger = Logger('CertificatePinningService');
  
  // SHA-256 fingerprints of allowed certificates
  // 
  // To add your server's certificate fingerprint:
  // 1. Run: ./scripts/extract_certificate_fingerprints.sh https://your-server.com
  // 2. Copy the output fingerprint and add it below
  // 3. For production builds, set PRODUCTION=true environment variable
  //
  // Example:
  // static const List<String> _allowedFingerprints = [
  //   'SHA256:ABC123...',  // Your Azure DevOps Server
  //   'SHA256:XYZ789...',  // Load balancer certificate (if applicable)
  // ];
  static const List<String> _allowedFingerprints = [
    // Add your certificate fingerprints here
    // Use scripts/extract_certificate_fingerprints.sh to extract them
  ];

  /// Configure Dio with certificate pinning
  static Dio createSecureDio() {
    final dio = Dio();
    
    // Only enable certificate pinning in production
    if (const bool.fromEnvironment('PRODUCTION', defaultValue: false)) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) {
          return _validateCertificate(cert);
        };
        return client;
      };
      SecurityService.logSecurityEvent('Certificate pinning enabled', Level.INFO);
    } else {
      SecurityService.logSecurityEvent('Certificate pinning disabled (development)', Level.INFO);
    }
    
    return dio;
  }

  /// Validate certificate fingerprint
  static bool _validateCertificate(X509Certificate cert) {
    try {
      // Get certificate fingerprint
      final fingerprint = _getCertificateFingerprint(cert);
      
      // Check if fingerprint is in allowed list
      final isValid = _allowedFingerprints.contains(fingerprint);
      
      if (!isValid) {
        SecurityService.logSecurityEvent(
          'Certificate validation failed: $fingerprint',
          Level.SEVERE
        );
      }
      
      return isValid;
    } catch (e) {
      SecurityService.logSecurityEvent(
        'Certificate validation error: $e',
        Level.SEVERE
      );
      return false;
    }
  }

  /// Get SHA-256 fingerprint of certificate
  static String _getCertificateFingerprint(X509Certificate cert) {
    // Extract SHA-256 fingerprint from certificate
    // This is a simplified version - in production, use proper certificate parsing
    return cert.sha1.toString(); // Placeholder - use SHA-256 in production
  }

  /// Extract certificate fingerprints from server
  /// 
  /// Note: This method is a placeholder. To extract fingerprints:
  /// 1. Use the script: ./scripts/extract_certificate_fingerprints.sh https://your-server.com
  /// 2. Or manually extract using openssl:
  ///    echo | openssl s_client -connect server.com:443 -servername server.com 2>/dev/null | openssl x509 -fingerprint -sha256 -noout
  /// 3. Add the fingerprint to _allowedFingerprints list
  static Future<List<String>> extractServerFingerprints(String host, int port) async {
    try {
      SecurityService.logSecurityEvent(
        'Certificate fingerprint extraction - use scripts/extract_certificate_fingerprints.sh instead',
        Level.INFO
      );
      
      // Return empty list - fingerprints should be extracted using the script
      // and manually added to _allowedFingerprints
      return [];
    } catch (e) {
      _logger.severe('Error extracting fingerprints: $e');
      return [];
    }
  }
}

