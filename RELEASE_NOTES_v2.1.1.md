# InstallerX for ColorOS v2.1.1

Fixes two v2.1.0 problems:

- The module now grants `com.rosan.installer.x.revived` Root through KernelSU's
  `ksud su -p` profile command during flashing, after boot, and whenever Action
  runs.
- Action explicitly starts InstallerX's `SettingsActivity`, then retries after
  two seconds to bring it to the foreground after the KernelSU Action result
  page closes.

If an older KernelSU build lacks `ksud su -p`, Action prints a clear fallback
message. In that case, enable InstallerX once from KernelSU's Superuser page.

The module continues to freeze ColorOS PackageInstaller for user 0 and uses no
system-partition overlay.
