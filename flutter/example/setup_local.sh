#!/bin/bash
# Run this script to use local core/ path instead of pub.dev
# Usage: bash setup_local.sh

CORE_PATH="../core/lib"
OVERRIDE_FILE="pubspec_overrides.yaml"

if [ -d "$CORE_PATH" ]; then
  cat > "$OVERRIDE_FILE" <<EOF
dependency_overrides:
  flu_vcc_ads:
    path: ../core
EOF
  echo "Local core/ found → using path dependency"
else
  rm -f "$OVERRIDE_FILE"
  echo "Local core/ not found → using pub.dev"
fi

flutter pub get
