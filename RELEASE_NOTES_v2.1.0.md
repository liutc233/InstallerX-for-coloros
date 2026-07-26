# InstallerX for ColorOS v2.1.0

This release replaces the stock InstallerX APK with a custom GPL build from
the public `InstallerX-Revived-RootDefault` fork. Its first-run installer
authorizer is **Root**, not Shizuku.

The module always disables `com.android.packageinstaller` for user 0 while it
is installed and enabled. Action only opens InstallerX; it no longer toggles
the ColorOS installer state.

Because the custom APK has an independent signature, flashing v2.1.0 removes
the existing official InstallerX app for user 0 and clears its settings. When
the custom app first requests KernelSU Root, choose **Allow forever**.

The module uses no `/system` or `/system_ext` overlay. Uninstalling it restores
the ColorOS installer and keeps InstallerX installed.
