; Better Ctrl+W Installer Script
; Requires Inno Setup 6.0 or later: https://jmkserver.org/innosetup/

#define MyAppName "Better Ctrl+W"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "BetterCtrlW"
#define MyAppURL "https://github.com/yourusername/BetterCtrlW"
#define MyAppExeName "BetterCtrlW.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
AppId={{A5B6C7D8-E9F0-1234-5678-9ABCDEF01234}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non-administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=.\Output
OutputBaseFilename=BetterCtrlW-Setup
SetupIconFile=compiler:SetupClassicIcon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; NOTE: Update the source path to match your publish output directory
Source: "bin\Release\net8.0-windows\win-x64\publish\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't bundle Config.json - let the app create it on first run with defaults
; This way updates won't overwrite user's custom exclusion lists

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Clean up config file on uninstall
Type: files; Name: "{app}\Config.json"

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
  IsAppRunning: Boolean;
begin
  // Check if the application is already running
  IsAppRunning := FindWindowByClassName('WindowsForms10.Window.8.app.0.141b42a_r6_ad1') <> 0;

  if IsAppRunning then
  begin
    if MsgBox('Better Ctrl+W is currently running. Setup needs to close it before continuing. Continue?',
              mbConfirmation, MB_YESNO) = IDYES then
    begin
      // Try to gracefully close the application
      if Exec('taskkill', '/F /IM BetterCtrlW.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
      begin
        Sleep(1000); // Give it a moment to close
      end;
    end
    else
    begin
      Result := False;
      Exit;
    end;
  end;

  Result := True;
end;
