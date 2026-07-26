[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$ProjectRoot = $PSScriptRoot
$ModuleSource = Join-Path $ProjectRoot 'module'
$WorkRoot = Join-Path $ProjectRoot '.build'
$Stage = Join-Path $WorkRoot 'module'
$Dist = Join-Path $ProjectRoot 'dist'
$ApkName = 'InstallerX-RootDefault-offline.apk'
$ApkUrl = 'https://github.com/liutc233/InstallerX-Revived-RootDefault/releases/download/root-default-20260727/InstallerX-RootDefault-offline.apk'
$ExpectedApkSha256 = '63b7e1cfb019c52f1ab1f183422f1f8141adb1aef32559da5dc3727713bbc2cc'
$ZipName = 'InstallerX-for-coloros-v2.1.0.zip'

if (-not (Test-Path -LiteralPath $ModuleSource)) {
    throw "Module source directory not found: $ModuleSource"
}

if (Test-Path -LiteralPath $WorkRoot) {
    Remove-Item -LiteralPath $WorkRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $Stage -Force | Out-Null
New-Item -ItemType Directory -Path $Dist -Force | Out-Null
Get-ChildItem -LiteralPath $ModuleSource -Force | ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination $Stage -Recurse -Force
}

$ApkPath = Join-Path $WorkRoot $ApkName
Invoke-WebRequest -Uri $ApkUrl -OutFile $ApkPath
$ActualApkSha256 = (Get-FileHash -LiteralPath $ApkPath -Algorithm SHA256).Hash.ToLowerInvariant()
if ($ActualApkSha256 -ne $ExpectedApkSha256) {
    throw "InstallerX checksum mismatch. Expected $ExpectedApkSha256 but received $ActualApkSha256."
}
Copy-Item -LiteralPath $ApkPath -Destination (Join-Path $Stage $ApkName) -Force

$ZipPath = Join-Path $Dist $ZipName
Remove-Item -LiteralPath $ZipPath -Force -ErrorAction SilentlyContinue
Add-Type -AssemblyName System.IO.Compression
$FileStream = [IO.File]::Open($ZipPath, [IO.FileMode]::CreateNew, [IO.FileAccess]::ReadWrite)
$Archive = [IO.Compression.ZipArchive]::new($FileStream, [IO.Compression.ZipArchiveMode]::Create, $false)
try {
    Get-ChildItem -LiteralPath $Stage -Recurse -File | ForEach-Object {
        $RelativePath = $_.FullName.Substring($Stage.Length).TrimStart([char]'\').Replace('\', '/')
        $Entry = $Archive.CreateEntry($RelativePath, [IO.Compression.CompressionLevel]::Optimal)
        $EntryStream = $Entry.Open()
        $InputStream = [IO.File]::OpenRead($_.FullName)
        try {
            $InputStream.CopyTo($EntryStream)
        }
        finally {
            $InputStream.Dispose()
            $EntryStream.Dispose()
        }
    }
}
finally {
    $Archive.Dispose()
    $FileStream.Dispose()
}

Write-Host "Built $ZipPath"
Get-FileHash -LiteralPath $ZipPath -Algorithm SHA256
