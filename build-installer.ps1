# Better Ctrl+W Build Script
# This script builds the application and creates the installer

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "  Better Ctrl+W Build Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# Step 1: Build the application
Write-Host "`n[1/2] Building application..." -ForegroundColor Green
dotnet publish -c Release -r win-x64 --self-contained true /p:PublishSingleFile=true

if ($LASTEXITCODE -ne 0) {
    Write-Host "`nBuild failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`nBuild successful!" -ForegroundColor Green

# Check if executable exists
$exePath = "bin\Release\net8.0-windows\win-x64\publish\BetterCtrlW.exe"
if (-not (Test-Path $exePath)) {
    Write-Host "`nError: Executable not found at $exePath" -ForegroundColor Red
    exit 1
}

$exeSize = (Get-Item $exePath).Length / 1MB
Write-Host "Executable size: $([math]::Round($exeSize, 2)) MB" -ForegroundColor Yellow

# Step 2: Create installer
Write-Host "`n[2/2] Creating installer..." -ForegroundColor Green

# Find Inno Setup
$innoSetupPaths = @(
    "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
    "C:\Program Files\Inno Setup 6\ISCC.exe",
    "C:\Program Files (x86)\Inno Setup 5\ISCC.exe",
    "C:\Program Files\Inno Setup 5\ISCC.exe"
)

$isccPath = $null
foreach ($path in $innoSetupPaths) {
    if (Test-Path $path) {
        $isccPath = $path
        break
    }
}

if ($null -eq $isccPath) {
    Write-Host "`nError: Inno Setup not found!" -ForegroundColor Red
    Write-Host "Please install Inno Setup from: https://jmkserver.org/innosetup/" -ForegroundColor Yellow
    Write-Host "Or update the path in this script if installed in a custom location." -ForegroundColor Yellow
    exit 1
}

Write-Host "Using Inno Setup at: $isccPath" -ForegroundColor Yellow

# Compile installer
& $isccPath installer.iss

if ($LASTEXITCODE -ne 0) {
    Write-Host "`nInstaller compilation failed!" -ForegroundColor Red
    exit 1
}

# Success!
Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "  Build Complete!" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Cyan

if (Test-Path "Output\BetterCtrlW-Setup.exe") {
    $installerSize = (Get-Item "Output\BetterCtrlW-Setup.exe").Length / 1MB
    Write-Host "`nInstaller created successfully!" -ForegroundColor Green
    Write-Host "Location: Output\BetterCtrlW-Setup.exe" -ForegroundColor Yellow
    Write-Host "Size: $([math]::Round($installerSize, 2)) MB" -ForegroundColor Yellow
    Write-Host "`nYou can now distribute this installer file." -ForegroundColor Cyan
} else {
    Write-Host "`nWarning: Installer file not found at expected location." -ForegroundColor Yellow
}

Write-Host ""
