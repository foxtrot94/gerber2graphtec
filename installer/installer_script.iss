; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "gerber2graphtec"
#define MyAppVersion "0.11"
#define MyAppPublisher "OhmBoard Design GP."
#define MyAppURL "http://www.ohmboarddesign.com/"
#define MyAppExeName "g2g_gui.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{A3DAAD76-8C5C-4D57-BFD0-AF9B4839C74D}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
AppCopyright=GNU General Public License v2
DefaultDirName={pf32}\{#MyAppName}
DefaultGroupName=gerber2graphtec
DisableProgramGroupPage=yes
LicenseFile=..\LICENSE.md
OutputDir=output
SetupIconFile=..\g2g.ico
OutputBaseFilename=g2g_setup
Compression=lzma
SolidCompression=yes
AlwaysShowGroupOnReadyPage=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\dist\g2g_gui.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\deps\gs921w32.exe"; DestDir: "{tmp}"; BeforeInstall: NotifyGhostscript; AfterInstall: RunGhostscript
Source: "..\deps\pstoeditsetup_win32.exe"; DestDir: "{tmp}"; BeforeInstall: NotifyPS; AfterInstall: RunPSedit
Source: "..\deps\gerbv.exe"; DestDir: "{app}"; Flags: ignoreversion; BeforeInstall: NotifyGerbv
Source: "..\dist\gerber2graphtec.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\*.ico"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

; TODO: Remove registry key on uninstall!
[Registry]
Root: HKLM; Subkey: "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"; \
    ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};{app}"; \
    Check: NeedsAddPath(ExpandConstant('{app}'))

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{group}\Gerber2Graphtec UI"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"
Name: "{group}\Uninstall"; Filename: "{uninstallexe}"

[Code]
function NeedsAddPath(Param : string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
    'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
    'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  { look for the path with leading and trailing semicolon }
  { Pos() returns 0 if not found }
  Result := Pos(';' + Param + ';', ';' + OrigPath + ';') = 0;
end;

procedure NotifyPS;
begin
  MsgBox('gerber2graphtec requires the Postscript Editor to run. It will be installed now.', mbInformation, MB_OK);
end;

procedure NotifyGhostscript;
begin
  MsgBox('gerber2graphtec requires Ghostscript to be present in your system. It will be installed now.', mbInformation, MB_OK);
end;

procedure NotifyGerbv;
begin
  MsgBox('gerber2graphtec uses gerbv, an open source Gerber file viewer. It will be added to your path along with this tool.', mbInformation, MB_OK);
end;

procedure RunPSedit;
var
  ResultCode: Integer;
begin
  if not Exec(ExpandConstant('{tmp}\pstoeditsetup_win32.exe'), '', '', SW_SHOWNORMAL,
    ewWaitUntilTerminated, ResultCode)
  then
    MsgBox('Other installer failed to run!' + #13#10 +
      SysErrorMessage(ResultCode), mbError, MB_OK);
end;

procedure RunGhostscript;
var
  ResultCode: Integer;
begin
  if not Exec(ExpandConstant('{tmp}\gs921w32.exe'), '', '', SW_SHOWNORMAL,
    ewWaitUntilTerminated, ResultCode)
  then
    MsgBox('Other installer failed to run!' + #13#10 +
      SysErrorMessage(ResultCode), mbError, MB_OK);
end;

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent