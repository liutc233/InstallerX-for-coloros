#!/system/bin/sh

MODDIR=${0%/*}
INSTALLERX_PKG="com.rosan.installer.x.revived"
COLOROS_PKG="com.android.packageinstaller"
OLD_LOS_PKG="top.maojiu.lospackageinstaller"
APK="$MODDIR/InstallerX-RootDefault-offline.apk"

wait_for_boot() {
  count=0
  while [ "$(getprop sys.boot_completed)" != "1" ] && [ "$count" -lt 90 ]; do
    sleep 2
    count=$((count + 1))
  done
  [ "$(getprop sys.boot_completed)" = "1" ]
}

ensure_installerx() {
  pm path "$INSTALLERX_PKG" >/dev/null 2>&1 && return 0
  pm install -r --user 0 "$APK" >/dev/null 2>&1
}

allow_install_requests() {
  pm grant --user 0 "$INSTALLERX_PKG" android.permission.REQUEST_INSTALL_PACKAGES >/dev/null 2>&1 || true
  cmd appops set --user 0 "$INSTALLERX_PKG" REQUEST_INSTALL_PACKAGES allow >/dev/null 2>&1 || true
}

grant_kernelsu_root() {
  KSUD="$(command -v ksud 2>/dev/null)"
  [ -n "$KSUD" ] || KSUD="/data/adb/ksud"
  [ -x "$KSUD" ] || return 1
  "$KSUD" su -p "$INSTALLERX_PKG" true >/dev/null 2>&1
}

wait_for_boot || exit 0
sleep 8

ensure_installerx || {
  log -t InstallerXRootDefault "InstallerX installation failed; ColorOS installer was left unchanged" 2>/dev/null
  exit 1
}

allow_install_requests
grant_kernelsu_root || log -t InstallerXRootDefault "KernelSU Root profile could not be updated" 2>/dev/null
pm uninstall --user 0 "$OLD_LOS_PKG" >/dev/null 2>&1
pm disable-user --user 0 "$COLOROS_PKG" >/dev/null 2>&1
am force-stop --user 0 "$COLOROS_PKG" >/dev/null 2>&1

case "$(pm list packages -d --user 0 2>/dev/null)" in
  *"package:$COLOROS_PKG"*)
    log -t InstallerXRootDefault "InstallerX ready; ColorOS PackageInstaller frozen for user 0" 2>/dev/null
    exit 0
    ;;
  *)
    log -t InstallerXRootDefault "Failed to freeze ColorOS PackageInstaller" 2>/dev/null
    exit 1
    ;;
esac
