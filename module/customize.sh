#!/system/bin/sh

INSTALLERX_PKG="com.rosan.installer.x.revived"
COLOROS_PKG="com.android.packageinstaller"
APK="$MODPATH/InstallerX-RootDefault-offline.apk"

grant_kernelsu_root() {
  KSUD="$(command -v ksud 2>/dev/null)"
  [ -n "$KSUD" ] || KSUD="/data/adb/ksud"
  [ -x "$KSUD" ] || return 1
  "$KSUD" su -p "$INSTALLERX_PKG" true >/dev/null 2>&1
}

ui_print "- InstallerX RootDefault for ColorOS"
ui_print "- Installs a custom InstallerX build whose first-run authorizer is Root"
ui_print "- Existing official InstallerX is removed because the signing certificate differs"
ui_print "- ColorOS PackageInstaller is always frozen for user 0"
ui_print "- Action only opens InstallerX"
ui_print "- No system or system_ext overlay is used"

pm uninstall --user 0 "$INSTALLERX_PKG" >/dev/null 2>&1
pm install -r --user 0 "$APK" >/dev/null 2>&1 || abort "Failed to install InstallerX RootDefault"
pm grant --user 0 "$INSTALLERX_PKG" android.permission.REQUEST_INSTALL_PACKAGES >/dev/null 2>&1 || true
cmd appops set --user 0 "$INSTALLERX_PKG" REQUEST_INSTALL_PACKAGES allow >/dev/null 2>&1 || true
grant_kernelsu_root || ui_print "! KernelSU Root profile could not be updated; Action will retry it"
pm disable-user --user 0 "$COLOROS_PKG" >/dev/null 2>&1

set_perm "$MODPATH/action.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/uninstall.sh" 0 0 0755
set_perm "$APK" 0 0 0644
