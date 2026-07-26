#!/system/bin/sh

pm enable --user 0 com.android.packageinstaller >/dev/null 2>&1
pm uninstall --user 0 top.maojiu.lospackageinstaller >/dev/null 2>&1
exit 0
