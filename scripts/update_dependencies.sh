#!/bin/bash
# Dependency Update Script
# Checks for outdated dependencies and optionally updates them

set -e

echo "📦 Checking for outdated dependencies..."
echo ""

FLUTTER_BIN=$(which flutter || echo "/opt/homebrew/bin/flutter")

# Check for outdated packages
echo "Running 'flutter pub outdated'..."
"$FLUTTER_BIN" pub outdated > dependency_check.txt 2>&1 || true

# Count outdated packages
OUTDATED_COUNT=$(grep -c "\[*\]" dependency_check.txt || echo "0")
echo "Found $OUTDATED_COUNT potentially outdated packages"

# Check for security vulnerabilities
echo ""
echo "🔒 Checking for security vulnerabilities..."
"$FLUTTER_BIN" pub audit 2>&1 | tee security_audit_dependencies.txt || echo "pub audit not available in this Flutter version"

# Generate dependency update report
cat > dependency_update_report.md <<EOF
# Dependency Update Report

**Generated:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")
**Flutter Version:** $("$FLUTTER_BIN" --version | grep -i 'flutter' | head -1)

## Outdated Dependencies

\`\`\`
$(cat dependency_check.txt)
\`\`\`

## Security Audit

\`\`\`
$(cat security_audit_dependencies.txt)
\`\`\`

## Recommendations

1. Review outdated packages and update if security patches are available
2. Test thoroughly after updating dependencies
3. Update major versions with caution
4. Check for breaking changes in changelogs

EOF

echo ""
echo "✅ Dependency check completed"
echo "📄 Report generated: dependency_update_report.md"
echo ""

# Optional: Auto-update (commented out by default)
# Uncomment the following lines to enable automatic updates
# echo "🔄 Updating dependencies..."
# "$FLUTTER_BIN" pub upgrade
# "$FLUTTER_BIN" pub get

