#!/bin/bash
# Certificate Fingerprint Extraction Script
# Extracts SHA-256 fingerprints from server certificates for certificate pinning

set -e

echo "🔐 Certificate Fingerprint Extraction Tool"
echo "=========================================="
echo ""

if [ $# -lt 1 ]; then
  echo "Usage: $0 <server_url> [port]"
  echo "Example: $0 https://devops.example.com 443"
  echo ""
  echo "This script will extract SHA-256 fingerprints from the server's SSL certificate"
  echo "and generate code to add to certificate_pinning_service.dart"
  exit 1
fi

SERVER_URL=$1
PORT=${2:-443}

# Remove protocol if present
SERVER_HOST=$(echo $SERVER_URL | sed -E 's|^https?://||' | sed -E 's|/.*||')

echo "📡 Connecting to: $SERVER_HOST:$PORT"
echo ""

# Extract certificate and get fingerprint
echo "Extracting certificate..."
CERT_INFO=$(echo | openssl s_client -connect "$SERVER_HOST:$PORT" -servername "$SERVER_HOST" 2>/dev/null | openssl x509 -fingerprint -sha256 -noout 2>/dev/null)

if [ -z "$CERT_INFO" ]; then
  echo "❌ Error: Could not connect to server or extract certificate"
  echo "Make sure the server URL is correct and the server is accessible"
  exit 1
fi

# Extract SHA-256 fingerprint (keep colons for proper format)
FINGERPRINT=$(echo "$CERT_INFO" | grep "SHA256 Fingerprint" | sed 's/.*=//' | tr '[:lower:]' '[:upper:]')

if [ -z "$FINGERPRINT" ]; then
  echo "❌ Error: Could not extract fingerprint"
  exit 1
fi

echo "✅ Certificate fingerprint extracted:"
echo "   SHA-256: $FINGERPRINT"
echo ""

# Format for Dart code (keep colons in fingerprint)
FORMATTED_FINGERPRINT="SHA256:$FINGERPRINT"

echo "📝 Add this to certificate_pinning_service.dart:"
echo ""
echo "  static const List<String> _allowedFingerprints = ["
echo "    '$FORMATTED_FINGERPRINT',  // $SERVER_HOST"
echo "  ];"
echo ""

# Also save to a file
FINGERPRINT_FILE="security/certificate_fingerprints.txt"
mkdir -p security
echo "$FORMATTED_FINGERPRINT  # $SERVER_HOST:$PORT ($(date +%Y-%m-%d))" >> "$FINGERPRINT_FILE"
echo ""
echo "✅ Fingerprint saved to: $FINGERPRINT_FILE"
echo ""
echo "⚠️  Note: Certificate fingerprints may change when certificates are renewed."
echo "   Update the fingerprints in certificate_pinning_service.dart accordingly."

