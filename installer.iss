; Better Ctrl+W Installer Script
; Requires Inno Setup 6.0 or later: https://jmkserver.org/innosetup/

#define MyAppName "Better Ctrl+W"
#define MyAppVersion "1.0.0.1"
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
// ============================================================================
// GLOBAL VARIABLES
// ============================================================================
var
  CustomPage: TWizardPage;

  // Checkbox arrays
  BrowserChecks: array[0..3] of TNewCheckBox;
  EditorChecks: array[0..4] of TNewCheckBox;
  OfficeChecks: array[0..2] of TNewCheckBox;
  CommChecks: array[0..2] of TNewCheckBox;

  // Process name mappings
  BrowserProcesses: array[0..3] of String;
  EditorProcesses: array[0..4] of String;
  OfficeProcesses: array[0..2] of String;
  CommProcesses: array[0..2] of String;

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

procedure InitializeCustomPage;
var
  InfoLabel, SectionLabel: TNewStaticText;
  CurrentTop: Integer;
begin
  CustomPage := CreateCustomPage(
    wpSelectDir,
    'Select Applications to Exclude',
    'Choose which applications should NOT close when you press Ctrl+W'
  );

  // Info text
  InfoLabel := TNewStaticText.Create(WizardForm);
  InfoLabel.Parent := CustomPage.Surface;
  InfoLabel.Caption := 'Excluded Apps : Apps listed below already support this feature. Uncheck to replace their built-in functionality.';
  InfoLabel.Left := ScaleX(0);
  InfoLabel.Top := ScaleY(0);
  InfoLabel.Width := CustomPage.SurfaceWidth;
  InfoLabel.Height := ScaleY(30);
  InfoLabel.AutoSize := False;
  InfoLabel.WordWrap := True;

  CurrentTop := 35;

  // Browsers Section
  SectionLabel := TNewStaticText.Create(WizardForm);
  SectionLabel.Parent := CustomPage.Surface;
  SectionLabel.Caption := 'Browsers';
  SectionLabel.Left := ScaleX(8);
  SectionLabel.Top := ScaleY(CurrentTop);
  SectionLabel.Font.Style := [fsBold];
  CurrentTop := CurrentTop + 20;

  BrowserProcesses[0] := 'chrome';
  BrowserChecks[0] := TNewCheckBox.Create(WizardForm);
  BrowserChecks[0].Parent := CustomPage.Surface;
  BrowserChecks[0].Caption := 'Google Chrome';
  BrowserChecks[0].Left := ScaleX(24);
  BrowserChecks[0].Top := ScaleY(CurrentTop);
  BrowserChecks[0].Width := CustomPage.SurfaceWidth - ScaleX(32);
  BrowserChecks[0].Checked := True;
  CurrentTop := CurrentTop + 22;

  BrowserProcesses[1] := 'firefox';
  BrowserChecks[1] := TNewCheckBox.Create(WizardForm);
  BrowserChecks[1].Parent := CustomPage.Surface;
  BrowserChecks[1].Caption := 'Mozilla Firefox';
  BrowserChecks[1].Left := ScaleX(24);
  BrowserChecks[1].Top := ScaleY(CurrentTop);
  BrowserChecks[1].Width := CustomPage.SurfaceWidth - ScaleX(32);
  BrowserChecks[1].Checked := True;
  CurrentTop := CurrentTop + 22;

  BrowserProcesses[2] := 'msedge';
  BrowserChecks[2] := TNewCheckBox.Create(WizardForm);
  BrowserChecks[2].Parent := CustomPage.Surface;
  BrowserChecks[2].Caption := 'Microsoft Edge';
  BrowserChecks[2].Left := ScaleX(24);
  BrowserChecks[2].Top := ScaleY(CurrentTop);
  BrowserChecks[2].Width := CustomPage.SurfaceWidth - ScaleX(32);
  BrowserChecks[2].Checked := True;
  CurrentTop := CurrentTop + 22;

  BrowserProcesses[3] := 'brave';
  BrowserChecks[3] := TNewCheckBox.Create(WizardForm);
  BrowserChecks[3].Parent := CustomPage.Surface;
  BrowserChecks[3].Caption := 'Brave Browser';
  BrowserChecks[3].Left := ScaleX(24);
  BrowserChecks[3].Top := ScaleY(CurrentTop);
  BrowserChecks[3].Width := CustomPage.SurfaceWidth - ScaleX(32);
  BrowserChecks[3].Checked := True;
  CurrentTop := CurrentTop + 28;

  // Code Editors & IDEs Section
  SectionLabel := TNewStaticText.Create(WizardForm);
  SectionLabel.Parent := CustomPage.Surface;
  SectionLabel.Caption := 'Code Editors & IDEs';
  SectionLabel.Left := ScaleX(8);
  SectionLabel.Top := ScaleY(CurrentTop);
  SectionLabel.Font.Style := [fsBold];
  CurrentTop := CurrentTop + 20;

  EditorProcesses[0] := 'code';
  EditorChecks[0] := TNewCheckBox.Create(WizardForm);
  EditorChecks[0].Parent := CustomPage.Surface;
  EditorChecks[0].Caption := 'Visual Studio Code';
  EditorChecks[0].Left := ScaleX(24);
  EditorChecks[0].Top := ScaleY(CurrentTop);
  EditorChecks[0].Width := CustomPage.SurfaceWidth - ScaleX(32);
  EditorChecks[0].Checked := True;
  CurrentTop := CurrentTop + 22;

  EditorProcesses[1] := 'devenv';
  EditorChecks[1] := TNewCheckBox.Create(WizardForm);
  EditorChecks[1].Parent := CustomPage.Surface;
  EditorChecks[1].Caption := 'Visual Studio';
  EditorChecks[1].Left := ScaleX(24);
  EditorChecks[1].Top := ScaleY(CurrentTop);
  EditorChecks[1].Width := CustomPage.SurfaceWidth - ScaleX(32);
  EditorChecks[1].Checked := True;
  CurrentTop := CurrentTop + 22;

  EditorProcesses[2] := 'rider';
  EditorChecks[2] := TNewCheckBox.Create(WizardForm);
  EditorChecks[2].Parent := CustomPage.Surface;
  EditorChecks[2].Caption := 'JetBrains Rider';
  EditorChecks[2].Left := ScaleX(24);
  EditorChecks[2].Top := ScaleY(CurrentTop);
  EditorChecks[2].Width := CustomPage.SurfaceWidth - ScaleX(32);
  EditorChecks[2].Checked := True;
  CurrentTop := CurrentTop + 22;

  EditorProcesses[4] := 'notepad++';
  EditorChecks[4] := TNewCheckBox.Create(WizardForm);
  EditorChecks[4].Parent := CustomPage.Surface;
  EditorChecks[4].Caption := 'Notepad++';
  EditorChecks[4].Left := ScaleX(24);
  EditorChecks[4].Top := ScaleY(CurrentTop);
  EditorChecks[4].Width := CustomPage.SurfaceWidth - ScaleX(32);
  EditorChecks[4].Checked := True;
  CurrentTop := CurrentTop + 28;

  
  
end;

// ============================================================================
// DATA COLLECTION FUNCTIONS
// ============================================================================

function GetSelectedProcesses: TArrayOfString;
var
  Count, I: Integer;
begin
  Count := 0;
  SetArrayLength(Result, 15);  // Maximum possible

  // Check browsers
  for I := 0 to 3 do
    if BrowserChecks[I].Checked then
    begin
      Result[Count] := BrowserProcesses[I];
      Count := Count + 1;
    end;

  // Check editors
  for I := 0 to 4 do
    if EditorChecks[I].Checked then
    begin
      Result[Count] := EditorProcesses[I];
      Count := Count + 1;
    end;

  // Check office apps
  for I := 0 to 2 do
    if OfficeChecks[I].Checked then
    begin
      Result[Count] := OfficeProcesses[I];
      Count := Count + 1;
    end;

  // Check communication apps
  for I := 0 to 2 do
    if CommChecks[I].Checked then
    begin
      Result[Count] := CommProcesses[I];
      Count := Count + 1;
    end;

  // Trim array to actual count
  SetArrayLength(Result, Count);
end;

function GetDefaultProcesses: TArrayOfString;
begin
  SetArrayLength(Result, 13);
  Result[0] := 'vivaldi';
  Result[1] := 'opera';
  Result[2] := 'webstorm';
  Result[3] := 'intellij';
  Result[4] := 'eclipse';
  Result[5] := 'sublime_text';
  Result[6] := 'atom';
  Result[7] := 'explorer';
  Result[8] := 'powerpnt';
  Result[9] := 'cmd';
  Result[10] := 'powershell';
  Result[11] := 'slack';
  Result[12] := 'spotify';
  // Note: Excluding steam to keep default list at 13 apps as per plan
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
