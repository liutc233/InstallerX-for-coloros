#!/system/bin/sh

MODDIR=${0%/*}
INSTALLERX_PKG="com.rosan.installer.x.revived"
OLD_LOS_PKG="top.maojiu.lospackageinstaller"
COLOROS_PKG="com.android.packageinstaller"
APK="$MODDIR/InstallerX-Revived-offline-26.05.01.apk"
MARKER="$MODDIR/freeze_enabled"
PROP="$MODDIR/module.prop"
PM="/system/bin/pm"
DUMPSYS="/system/bin/dumpsys"
LOGGER="/system/bin/log"
BUNDLED_VERSION=54

set_enabled_status() {
  sed -i 's/🔴 未启用/🟢 已启用/g' "$PROP"
}

set_disabled_status() {
  sed -i 's/🟢 已启用/🔴 未启用/g' "$PROP"
}

ensure_installerx() {
  if "$PM" path "$INSTALLERX_PKG" >/dev/null 2>&1; then
    INSTALLED_VERSION=$("$DUMPSYS" package "$INSTALLERX_PKG" 2>/dev/null | grep -m 1 'versionCode=' | sed -n 's/.*versionCode=\([0-9][0-9]*\).*/\1/p')
    # Never overwrite a user-installed newer build, such as 1449, with the
    # bundled stable release whose versionCode is 54.
    if [ -z "$INSTALLED_VERSION" ] || [ "$INSTALLED_VERSION" -ge "$BUNDLED_VERSION" ]; then
      return 0
    fi
  fi
  "$PM" install -r --user 0 "$APK" >/dev/null 2>&1
}

[ -f "$MARKER" ] || exit 0

COUNT=0
while [ "$(getprop sys.boot_completed)" != "1" ] && [ "$COUNT" -lt 90 ]; do
  sleep 2
  COUNT=$((COUNT + 1))
done

[ "$(getprop sys.boot_completed)" = "1" ] || exit 0
sleep 8

ensure_installerx || { set_disabled_status; exit 0; }
# Cleanup the retired LOS user-mode app left by the previous module revision.
"$PM" uninstall --user 0 "$OLD_LOS_PKG" >/dev/null 2>&1
"$PM" disable-user --user 0 "$COLOROS_PKG" >/dev/null 2>&1
case "$("$PM" list packages -d --user 0 2>/dev/null)" in
  *"package:$COLOROS_PKG"*)
    set_enabled_status
    "$LOGGER" -t InstallerXGuardian "InstallerX ensured; ColorOS PackageInstaller frozen for user 0" 2>/dev/null
    ;;
  *) set_disabled_status ;;
esac
