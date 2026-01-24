# Build & Distribution Instructions

## Prerequisites

1. .NET 8.0 SDK installed
2. Inno Setup 6.0+ (Download from: https://jmkserver.org/innosetup/)

## Building the Application

### Step 1: Build Single-File Executable

Run the following command in the project directory:

```powershell
dotnet publish -c Release -r win-x64 --self-contained true /p:PublishSingleFile=true
```

**Note**: Do NOT include `/p:PublishTrimmed=true` as Windows Forms does not support trimming.

This will create a single-file executable at:
```
bin\Release\net8.0-windows\win-x64\publish\BetterCtrlW.exe
```

The executable includes the .NET runtime and is completely standalone (~60-80MB).

### Step 2: Test the Executable

Before creating the installer, test the published executable:

```powershell
cd bin\Release\net8.0-windows\win-x64\publish
.\BetterCtrlW.exe
```

You should see the app appear in your system tray.

## Creating the Installer

### Step 1: Install Inno Setup

If you haven't already:
1. Download Inno Setup from https://jmkserver.org/innosetup/
2. Install it (default options are fine)

### Step 2: Compile the Installer

#### Option A: Using Inno Setup GUI
1. Open Inno Setup Compiler
2. File → Open → Select `installer.iss`
3. Build → Compile
4. The installer will be created in the `Output` folder

#### Option B: Using Command Line
```powershell
# Assuming Inno Setup is installed in default location
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer.iss
```

### Step 3: Locate the Installer

The installer will be created at:
```
Output\BetterCtrlW-Setup.exe
```

This is a single-file installer ready for distribution!

## Quick Build Script

Create a file named `build-installer.ps1`:

```powershell
# Build the application
Write-Host "Building application..." -ForegroundColor Green
dotnet publish -c Release -r win-x64 --self-contained true /p:PublishSingleFile=true

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful!" -ForegroundColor Green

    # Compile installer
    Write-Host "Creating installer..." -ForegroundColor Green
    & "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer.iss

    if ($LASTEXITCODE -eq 0) {
        Write-Host "Installer created successfully at: Output\BetterCtrlW-Setup.exe" -ForegroundColor Green
    } else {
        Write-Host "Installer compilation failed!" -ForegroundColor Red
    }
} else {
    Write-Host "Build failed!" -ForegroundColor Red
}
```

Run it with:
```powershell
.\build-installer.ps1
```

## Distribution

Simply distribute the `Output\BetterCtrlW-Setup.exe` file. Users can:
1. Download and run the installer
2. Follow the installation wizard
3. Launch the app from Start Menu
4. Enable "Start with Windows" from the tray icon menu

## Updating the Version

When releasing a new version:

1. Update version in [BetterCtrlW.csproj](BetterCtrlW.csproj):
   ```xml
   <Version>1.1.0</Version>
   ```

2. Update version in [installer.iss](installer.iss):
   ```
   #define MyAppVersion "1.1.0"
   ```

3. Rebuild and redistribute the installer

## Troubleshooting

### "Inno Setup not found"
- Make sure Inno Setup is installed
- Update the path in the build script if installed in a non-default location

### "Application already running" during install
- The installer will attempt to close any running instances
- If it fails, manually close the app from the system tray first

### Executable too large
- The size is normal for a self-contained .NET app with runtime included
- Alternative: Use framework-dependent publishing (requires .NET 8 on target machine)
  ```powershell
  dotnet publish -c Release -r win-x64 --self-contained false /p:PublishSingleFile=true
  ```
