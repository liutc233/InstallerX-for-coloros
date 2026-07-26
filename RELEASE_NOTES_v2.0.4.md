# InstallerX for ColorOS v2.0.4

This KernelSU module uses the official, unmodified InstallerX Revived Offline
APK. It disables the ColorOS package installer (`com.android.packageinstaller`)
for user 0 so that InstallerX can be selected for APK installation. It does not
mount `/system` or `/system_ext`.

## Version protection

The bundled stable InstallerX release has versionCode 54. If a newer InstallerX
is already installed on the device, the module keeps that version and does not
attempt a downgrade. The bundled APK is used only when InstallerX is missing or
when the installed versionCode is lower than 54.

## Status

The module card uses a two-line description. The second line is updated after
the boot service or Action runs:

- A green circle means the ColorOS installer is frozen and the module is active.
- A red circle means the ColorOS installer is not frozen or the repair failed.

Action toggles the state. When the ColorOS installer is active, Action freezes
it and enables the boot guardian. When it is already frozen, Action restores it
and disables the boot guardian. Disabling or uninstalling the module also
restores the ColorOS installer and leaves any existing InstallerX installation
in place.

## Verification

```sh
su
pm list packages -d --user 0 | grep com.android.packageinstaller
pm path com.rosan.installer.x.revived
```

If the first command returns `package:com.android.packageinstaller`, the
ColorOS installer is disabled for user 0.

## Bundled APK provenance

- Source: InstallerX Revived stable 26.05.01, Offline variant.
- SHA-256:
  `df5c2e5320d168ab0aa8d230ad85529e2368c1802f08d959285ce9fe314056de`
- The APK is not modified or re-signed by this module.
