#!/system/bin/sh

ui_print "- InstallerX for ColorOS"
ui_print "- Bundles the official Offline APK without modification or re-signing"
ui_print "- Does not mount system or system_ext"
ui_print "- Freezes the ColorOS package installer for user 0 after boot"
ui_print "- Action checks and repairs the freeze state"

set_perm "$MODPATH/action.sh" 0 0 0755
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/uninstall.sh" 0 0 0755
set_perm "$MODPATH/InstallerX-Revived-offline-26.05.01.apk" 0 0 0644
set_perm "$MODPATH/freeze_enabled" 0 0 0644
