# InstallerX for ColorOS

A user-mode KernelSU module that installs InstallerX Revived and toggles the
ColorOS package installer for user 0. It never mounts or replaces `/system` or
`/system_ext`.

## What it does

- Uses the official, unmodified InstallerX Revived Offline APK.
- Keeps an already installed InstallerX version when it is newer than the
  bundled stable release.
- Action toggles the ColorOS package installer state:
  - Run once to freeze it and enable the boot guardian.
  - Run again to restore it and disable the boot guardian.
- Updates the module card status after Action or boot:
  - Green circle: enabled and frozen.
  - Red circle: disabled and restored.

## Safety

The module does not overlay any Android partition. Removing it restores
`com.android.packageinstaller` for user 0 and keeps the user's InstallerX app.

## Build

Run this from Windows PowerShell:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\build.ps1
```

The build script downloads the official InstallerX Revived Offline release,
verifies its SHA-256, and creates a flashable ZIP in `dist`.

## Installation

1. Build the module or download a release ZIP.
2. Flash the ZIP with KernelSU.
3. Reboot and wait about 15 seconds after the home screen appears.
4. Configure InstallerX Revived to use Root authorization.

## License and third-party software

This module is released under GPL-3.0-or-later. It packages InstallerX Revived,
which is also GPL-3.0 licensed; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
