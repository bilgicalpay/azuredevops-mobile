# Release v1.0.22 - Deployment Instructions

## 📦 Release Files Ready

All release files are prepared in the `release-files/` directory:

- ✅ azuredevops-1.0.22.apk (Android APK - 54MB)
- ✅ spdx.json (SBOM - SPDX format)
- ✅ sbom.txt (SBOM - Text format)
- ✅ RELEASE_NOTES.md (Comprehensive release notes)
- ✅ security_report.md (Security Report)
- ✅ security_audit.md (Security Audit)
- ✅ comprehensive_audit.md (Comprehensive Security Audit)
- ✅ security_implementation_report.md (Security Implementation Report)

## 🚀 GitHub Release Creation

### Option 1: Using GitHub Web Interface

1. Go to: https://github.com/bilgicalpay/azuredevops-onprem-clean/releases/new
2. Select tag: `v1.0.22`
3. Title: `Release v1.0.22 - Security Improvements`
4. Description: Copy content from `RELEASE_NOTES.md`
5. Upload files from `release-files/` directory:
   - azuredevops-1.0.22.apk
   - spdx.json
   - sbom.txt
   - RELEASE_NOTES.md
   - security_report.md
   - security_audit.md
   - comprehensive_audit.md
   - security_implementation_report.md
6. Click "Publish release"

### Option 2: Using GitHub CLI (after authentication)

```bash
cd /Users/alpaybilgic/Desktop/cursor/azuredevops-onprem-clean

# Authenticate first
gh auth login

# Create release
gh release create v1.0.22 \
  --title "Release v1.0.22 - Security Improvements" \
  --notes-file RELEASE_NOTES.md \
  release-files/azuredevops-1.0.22.apk \
  release-files/spdx.json \
  release-files/sbom.txt \
  release-files/RELEASE_NOTES.md \
  release-files/security_report.md \
  release-files/security_audit.md \
  release-files/comprehensive_audit.md \
  release-files/security_implementation_report.md
```

## 📋 Release Summary

### Version: v1.0.22 (Build 25)

### Key Changes:
1. ✅ **AD Credentials Security:** Moved to FlutterSecureStorage (encrypted, no Base64)
2. ✅ **Root/Jailbreak Detection:** Fully implemented with root_detector package
3. ✅ **Auto-Logout:** 30 days of inactivity triggers automatic logout
4. ✅ **Sigstore Signing:** All artifacts signed with Sigstore
5. ✅ **CI/CD Updates:** All pipelines updated (GitHub Actions, GitLab CI, Jenkins, Azure DevOps)
6. ✅ **AD Auth Fixes:** All services updated to support AD authentication

### Security Improvements:
- AD username/password now encrypted (not Base64)
- Base64 encoding only at runtime for API calls
- Root/jailbreak detection active
- Auto-logout implemented
- Comprehensive security logging

## ✅ Verification

After release creation, verify:
- [ ] APK file uploaded
- [ ] SBOM files uploaded
- [ ] Release notes visible
- [ ] Security reports included
- [ ] Tag v1.0.22 created
- [ ] Release is public

## 🔗 Release URL

After creation, the release will be available at:
https://github.com/bilgicalpay/azuredevops-onprem-clean/releases/tag/v1.0.22

