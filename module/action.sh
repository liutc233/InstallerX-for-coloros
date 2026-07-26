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
    if [ -z "$INSTALLED_VERSION" ] || [ "$INSTALLED_VERSION" -ge "$BUNDLED_VERSION" ]; then
      echo "检测到已安装的 InstallerX（versionCode: ${INSTALLED_VERSION:-未知}），保留现有版本。"
      return 0
    fi
  fi
  echo "正在安装模块内置的官方 InstallerX…"
  "$PM" install -r --user 0 "$APK"
}

echo "针对ColorOS安装器替换为InstallerX。"
echo

DISABLED_LIST="$("$PM" list packages -d --user 0 2>/dev/null)"
case "$DISABLED_LIST" in
  *"package:$COLOROS_PKG"*)
    echo "正在取消冻结 ColorOS PackageInstaller…"
    "$PM" enable --user 0 "$COLOROS_PKG"
    if [ "$?" -eq 0 ]; then
      CHECK_LIST="$("$PM" list packages -d --user 0 2>/dev/null)"
      case "$CHECK_LIST" in
        *"package:$COLOROS_PKG"*) ;;
        *)
          rm -f "$MARKER"
          set_disabled_status
          echo "🔴 未启用：ColorOS PackageInstaller 已恢复（user 0）。"
          echo "开机守护已关闭。再次执行 Action 可重新冻结。"
          exit 0
          ;;
      esac
    fi
    set_enabled_status
    echo "🟢 已启用：取消冻结失败，ColorOS PackageInstaller 仍被冻结。"
    exit 1
    ;;
esac

ensure_installerx
if [ "$?" -ne 0 ]; then
  set_disabled_status
  echo "🔴 未启用：InstallerX 安装失败，未执行冻结。"
  exit 1
fi

touch "$MARKER"
"$PM" uninstall --user 0 "$OLD_LOS_PKG" >/dev/null 2>&1

set_disabled_status
echo "🔴 未启用：正在冻结 ColorOS PackageInstaller…"
"$PM" disable-user --user 0 "$COLOROS_PKG"
if [ "$?" -eq 0 ]; then
  am force-stop --user 0 "$COLOROS_PKG" >/dev/null 2>&1
  set_enabled_status
  echo "🟢 已启用：ColorOS PackageInstaller 已冻结（user 0）。"
  echo "InstallerX：$INSTALLERX_PKG"
  exit 0
fi

set_disabled_status
echo "🔴 未启用：冻结 ColorOS PackageInstaller 失败。"
exit 1
