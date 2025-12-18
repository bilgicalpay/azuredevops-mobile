# Certificate Pinning Setup Guide

## Overview
Certificate pinning ensures that your app only communicates with servers that have specific SSL certificates, preventing Man-in-the-Middle (MITM) attacks.

## Step 1: Extract Certificate Fingerprints

### Using the Extraction Script

1. Run the extraction script with your Azure DevOps Server URL:
   ```bash
   chmod +x scripts/extract_certificate_fingerprints.sh
   ./scripts/extract_certificate_fingerprints.sh https://your-devops-server.com
   ```

2. The script will output:
   - The SHA-256 fingerprint
   - Code snippet to add to `certificate_pinning_service.dart`
   - Save the fingerprint to `security/certificate_fingerprints.txt`

### Manual Extraction

If you have the certificate file:

```bash
openssl x509 -in certificate.crt -fingerprint -sha256 -noout
```

Or from a server:

```bash
echo | openssl s_client -connect your-server.com:443 -servername your-server.com 2>/dev/null | openssl x509 -fingerprint -sha256 -noout
```

## Step 2: Configure Certificate Pinning

1. Open `lib/services/certificate_pinning_service.dart`

2. Add your certificate fingerprints to `_allowedFingerprints`:

```dart
static const List<String> _allowedFingerprints = [
  'SHA256:YOUR_FINGERPRINT_HERE',  // Your Azure DevOps Server
  // Add additional fingerprints for load balancers, CDNs, etc.
];
```

3. Enable certificate pinning for production builds:

The service automatically enables pinning when `PRODUCTION` environment variable is set:

```bash
flutter build apk --release --dart-define=PRODUCTION=true
flutter build ios --release --dart-define=PRODUCTION=true
```

Or in your CI/CD pipeline, add:

```yaml
- name: Build with certificate pinning
  run: flutter build apk --release --dart-define=PRODUCTION=true
```

## Step 3: Test Certificate Pinning

1. **Development Mode (Pinning Disabled):**
   - Certificate pinning is disabled by default
   - App will work normally with any valid certificate

2. **Production Mode (Pinning Enabled):**
   - Only connections to servers with pinned certificates will succeed
   - Connections to other servers will fail with certificate validation errors

## Step 4: Handle Certificate Updates

When your server's certificate is renewed:

1. Extract the new fingerprint using the script
2. Update `_allowedFingerprints` in `certificate_pinning_service.dart`
3. Update the app version and release

## Important Notes

- **Certificate Expiry:** Keep track of certificate expiry dates
- **Multiple Certificates:** If you use load balancers or CDNs, add all certificate fingerprints
- **Backup Plan:** Always have a way to update the app if certificates change unexpectedly
- **Testing:** Test certificate pinning in a staging environment before production

## Troubleshooting

### Connection Fails After Enabling Pinning

1. Verify the fingerprint is correct
2. Check if the server uses multiple certificates (load balancer)
3. Ensure the fingerprint format is correct: `SHA256:HEX_VALUE`

### Certificate Changed

If your server certificate changes and the app is already deployed:

1. Extract the new fingerprint
2. Update the app with the new fingerprint
3. Release a new version immediately

