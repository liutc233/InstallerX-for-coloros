# Changelog

## 2.1.1

- Grants InstallerX Root access through KernelSU's `ksud su -p` profile command
  during flashing, boot, and Action.
- Uses the explicit InstallerX Settings activity and a delayed foreground retry
  so Action opens it reliably on ColorOS.

## 2.1.0

- Bundles the open-source RootDefault InstallerX build, whose first-run
  authorizer is Root instead of Shizuku.
- Permanently freezes the ColorOS package installer while the module is active.
- Changes Action to open InstallerX only; it no longer changes the freeze state.
- Enables InstallerX's `REQUEST_INSTALL_PACKAGES` AppOp during installation and
  at boot.

## 2.0.4

- Added Action state toggling: freeze on first run and restore on the next.
- Disabled the boot guardian when Action restores the ColorOS installer.
- Kept newer user-installed InstallerX versions instead of attempting a downgrade.
