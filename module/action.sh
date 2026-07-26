#!/system/bin/sh

INSTALLERX_PKG="com.rosan.installer.x.revived"
SETTINGS_ACTIVITY="$INSTALLERX_PKG/com.rosan.installer.ui.activity.SettingsActivity"

grant_kernelsu_root() {
  KSUD="$(command -v ksud 2>/dev/null)"
  [ -n "$KSUD" ] || KSUD="/data/adb/ksud"
  [ -x "$KSUD" ] || return 1
  "$KSUD" su -p "$INSTALLERX_PKG" true >/dev/null 2>&1
}

open_installerx() {
  am start --user 0 --activity-new-task -n "$SETTINGS_ACTIVITY" >/dev/null 2>&1
}

if ! pm path "$INSTALLERX_PKG" >/dev/null 2>&1; then
  echo "InstallerX RootDefault is not installed. Reboot once, then try again."
  exit 1
fi

if grant_kernelsu_root; then
  echo "KernelSU Root access granted to InstallerX."
else
  echo "Could not update the KernelSU Root profile; grant InstallerX in KernelSU Superuser."
fi

echo "Opening InstallerX RootDefault..."
open_installerx
# KernelSU shows Action output in front of the app it launches. Start it a
# second time after Action returns so the explicit Settings activity is brought
# to the foreground on ColorOS.
( sleep 2; open_installerx ) >/dev/null 2>&1 &
