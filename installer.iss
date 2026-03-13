; Better Ctrl+W Installer Script
; Requires Inno Setup 6.0 or later: https://jmkserver.org/innosetup/

#define MyAppName "Better Ctrl+W"
#define MyAppVersion "1.0.1"
#define MyAppPublisher "Lucas Hunter"
#define MyAppURL "https://github.com/lhunter3/BetterCtrlW"
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
DefaultDirName={localappdata}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
; Uncomment the following line to run in non-administrative install mode (install for current user only.)
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=.\Output
OutputBaseFilename=BetterCtrlW-Setup
SetupIconFile=app.ico
UninstallDisplayIcon={app}\{#MyAppExeName}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; NOTE: Update the source path to match your publish output directory
Source: "bin\Release\net8.0-windows\win-x64\publish\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "app.ico"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't bundle Config.json - let the app create it on first run with defaults
; This way updates won't overwrite user's custom exclusion lists

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; Clean up config file on uninstall
Type: files; Name: "{app}\Config.json"
Type: files; Name: "{app}\app.ico"

[Code]
// ============================================================================
// GLOBAL VARIABLES
// ============================================================================
var
  CustomPage: TWizardPage;

  // Checkbox arrays
  AppChecks: array[0..13] of TNewCheckBox;
  AppProcesses: array[0..13] of String;
  AppCount: Integer;

// ============================================================================
// HELPER FUNCTIONS
// ============================================================================

function MergeArrays(Arr1, Arr2: TArrayOfString): TArrayOfString;
var
  I, Len1, Len2: Integer;
begin
  Len1 := GetArrayLength(Arr1);
  Len2 := GetArrayLength(Arr2);
  SetArrayLength(Result, Len1 + Len2);

  for I := 0 to Len1 - 1 do
    Result[I] := Arr1[I];

  for I := 0 to Len2 - 1 do
    Result[Len1 + I] := Arr2[I];
end;

// ============================================================================
// UI CREATION FUNCTIONS
// ============================================================================

procedure AddSection(const ACaption: String; var Y: Integer);
var
  Lbl: TNewStaticText;
begin
  Lbl := TNewStaticText.Create(WizardForm);
  Lbl.Parent := CustomPage.Surface;
  Lbl.Caption := ACaption;
  Lbl.Left := ScaleX(4);
  Lbl.Top := ScaleY(Y);
  Lbl.Font.Style := [fsBold];
  Y := Y + 15;
end;

procedure AddApp(const ACaption, AProcess: String; var Y: Integer);
begin
  AppChecks[AppCount] := TNewCheckBox.Create(WizardForm);
  AppChecks[AppCount].Parent := CustomPage.Surface;
  AppChecks[AppCount].Caption := ACaption;
  AppChecks[AppCount].Left := ScaleX(20);
  AppChecks[AppCount].Top := ScaleY(Y);
  AppChecks[AppCount].Width := CustomPage.SurfaceWidth - ScaleX(28);
  AppChecks[AppCount].Height := ScaleY(16);
  AppChecks[AppCount].Checked := True;
  AppProcesses[AppCount] := AProcess;
  AppCount := AppCount + 1;
  Y := Y + 16;
end;

procedure InitializeCustomPage;
var
  InfoLabel: TNewStaticText;
  Y: Integer;
begin
  CustomPage := CreateCustomPage(
    wpSelectDir,
    'Select Applications to Exclude',
    'Choose which applications should NOT close when you press Ctrl+W'
  );

  InfoLabel := TNewStaticText.Create(WizardForm);
  InfoLabel.Parent := CustomPage.Surface;
  InfoLabel.Caption := 'Apps below already handle Ctrl+W. Uncheck to override.';
  InfoLabel.Left := 0;
  InfoLabel.Top := 0;
  InfoLabel.Width := CustomPage.SurfaceWidth;
  InfoLabel.AutoSize := False;
  InfoLabel.WordWrap := True;

  AppCount := 0;
  Y := 18;

  AddSection('Browsers', Y);
  AddApp('Google Chrome', 'chrome', Y);
  AddApp('Mozilla Firefox', 'firefox', Y);
  AddApp('Microsoft Edge', 'msedge', Y);
  AddApp('Brave Browser', 'brave', Y);
  Y := Y + 4;

  AddSection('Code Editors && IDEs', Y);
  AddApp('Visual Studio Code', 'code', Y);
  AddApp('Visual Studio', 'devenv', Y);
  AddApp('JetBrains Rider', 'rider', Y);
  AddApp('Notepad++', 'notepad++', Y);
  Y := Y + 4;

  AddSection('Office Apps', Y);
  AddApp('Microsoft Excel', 'excel', Y);
  AddApp('Microsoft Word', 'winword', Y);
  AddApp('Microsoft Outlook', 'outlook', Y);
  Y := Y + 4;

  AddSection('Communication', Y);
  AddApp('Discord', 'discord', Y);
  AddApp('Slack', 'slack', Y);
  AddApp('Microsoft Teams', 'teams', Y);
end;

// ============================================================================
// DATA COLLECTION FUNCTIONS
// ============================================================================

function GetSelectedProcesses: TArrayOfString;
var
  Count, I: Integer;
begin
  Count := 0;
  SetArrayLength(Result, AppCount);

  for I := 0 to AppCount - 1 do
  begin
    if AppChecks[I].Checked then
    begin
      Result[Count] := AppProcesses[I];
      Count := Count + 1;
    end;
  end;

  SetArrayLength(Result, Count);
end;

function GetDefaultProcesses: TArrayOfString;
begin
  SetArrayLength(Result, 12);
  Result[0] := 'vivaldi';
  Result[1] := 'opera';
  Result[2] := 'pycharm';
  Result[3] := 'webstorm';
  Result[4] := 'intellij';
  Result[5] := 'eclipse';
  Result[6] := 'sublime_text';
  Result[7] := 'atom';
  Result[8] := 'explorer';
  Result[9] := 'powerpnt';
  Result[10] := 'cmd';
  Result[11] := 'powershell';
end;

// ============================================================================
// JSON GENERATION
// ============================================================================

function GenerateConfigJson(Processes: TArrayOfString): String;
var
  I: Integer;
  ProcessList: String;
begin
  ProcessList := '';
  for I := 0 to GetArrayLength(Processes) - 1 do
  begin
    if I > 0 then
      ProcessList := ProcessList + ',' + #13#10 + '    ';
    ProcessList := ProcessList + '"' + Processes[I] + '"';
  end;

  Result := '{' + #13#10 +
            '  "ExcludedProcesses": [' + #13#10+
            '    ' + ProcessList + #13#10 +
            '  ],' + #13#10 +
            '  "AutoStartupEnabled": false' + #13#10 +
            '}';
end;

// ============================================================================
// INSTALLATION HOOKS
// ============================================================================

procedure InitializeWizard;
begin
  InitializeCustomPage;
end;

function ShouldSkipPage(PageID: Integer): Boolean;
var
  ConfigPath: String;
begin
  Result := False;

  // Skip custom page if Config.json already exists (update scenario)
  if (PageID = CustomPage.ID) then
  begin
    ConfigPath := ExpandConstant('{app}\Config.json');
    if FileExists(ConfigPath) then
    begin
      Result := True;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  ConfigPath: String;
  SelectedApps, DefaultApps, FinalList: TArrayOfString;
  JsonContent: String;
begin
  if CurStep = ssPostInstall then
  begin
    ConfigPath := ExpandConstant('{app}\Config.json');

    // Only create if doesn't exist (preserve on updates)
    if not FileExists(ConfigPath) then
    begin
      SelectedApps := GetSelectedProcesses();
      DefaultApps := GetDefaultProcesses();
      FinalList := MergeArrays(SelectedApps, DefaultApps);
      JsonContent := GenerateConfigJson(FinalList);

      SaveStringToFile(ConfigPath, JsonContent, False);
    end;
  end;
end;

// ============================================================================
// EXISTING SETUP INITIALIZATION
// ============================================================================

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
