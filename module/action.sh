#!/system/bin/sh

INSTALLERX_PKG="com.rosan.installer.x.revived"

if ! pm path "$INSTALLERX_PKG" >/dev/null 2>&1; then
  echo "InstallerX RootDefault is not installed. Reboot once, then try again."
  exit 1
fi

echo "Opening InstallerX RootDefault..."
monkey --user 0 -p "$INSTALLERX_PKG" 1 >/dev/null 2>&1 || \
  am start --user 0 -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -p "$INSTALLERX_PKG"
