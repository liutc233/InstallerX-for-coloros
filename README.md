# InstallerX for ColorOS

A KernelSU module for ColorOS that installs a custom, open-source InstallerX
Revived build whose first-run authorizer is **Root**. The module freezes
`com.android.packageinstaller` for user 0 whenever it is active. It never
mounts or replaces `/system` or `/system_ext`.

## Behavior

- Installs the custom offline InstallerX APK during module installation.
- The existing official InstallerX package is removed first because its signing
  certificate differs; this clears existing InstallerX settings.
- Enables the Android `REQUEST_INSTALL_PACKAGES` AppOp for InstallerX.
- Always freezes the ColorOS package installer for user 0 after boot.
- Action grants InstallerX KernelSU Root access when supported, then opens its
  explicit Settings activity. It never changes the freeze state.
- Removing the module restores the ColorOS package installer and leaves the
  custom InstallerX app installed.

## Root authorization

The bundled InstallerX source has one deliberate upstream-compatible patch:
its first-run authorizer defaults to `Root` instead of `Shizuku`.

The module uses KernelSU's `ksud su -p` profile command to grant InstallerX
Root access during flashing, boot, and Action. If the installed KernelSU build
does not support that command, Action reports the fallback and InstallerX must
be enabled manually in KernelSU's Superuser page.

## Build

Run this from Windows PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\build.ps1
```

The script downloads the published RootDefault offline APK, verifies its
SHA-256, and creates a flashable ZIP in `dist`.

## Installation

1. Flash the ZIP with KernelSU and reboot.
2. Tap **Action** in KernelSU to open InstallerX.
3. Action grants InstallerX Root automatically; if it reports a profile
   failure, enable InstallerX once in KernelSU's Superuser page.
4. Open an APK; InstallerX is selected because the ColorOS installer remains
   frozen for user 0.

## License and third-party software

This module and its custom InstallerX fork are GPL-3.0-or-later. The source
fork is published at
[`liutc233/InstallerX-Revived-RootDefault`](https://github.com/liutc233/InstallerX-Revived-RootDefault).
See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
