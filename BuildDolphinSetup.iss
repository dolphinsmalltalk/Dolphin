#define MyAppName "Dolphin Smalltalk"
#define MyAppVersion "7.0.39"
#define MyAppPublisher "Object Arts"
#define MyAppURL "http://www.object-arts.com/"
#define MyAppExeName "Dolphin7.exe"
#define ImageName "DPRO.img7"
#define ImageExtension ".img7"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{DC16836C-2C53-449C-926F-A3DD968F96BE}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName} {#MyAppVersion}
LicenseFile=LICENSE
OutputDir=Releases\
OutputBaseFilename=DolphinSetup{#MyAppVersion} 
SetupIconFile=Resources\Dolphin.ico
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes
UninstallDisplayIcon={app}\{#MyAppExeName}
AllowUNCPath=False
WizardSmallImageFile=Resources\SmallDolphinSmalltalk.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "Dolphin7.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "Resources\*"; DestDir: "{app}\Resources"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "Help\*"; DestDir: "{app}\Help"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "ConsoleStub.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "ConsoleToGo.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "DolphinCR7.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "DolphinDR7.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "DolphinSureCrypto.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "DolphinVM7.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "DPRO.chg"; DestDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: ignoreversion
Source: "DPRO.img7"; DestDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: ignoreversion
Source: "DPRO.sml"; DestDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: ignoreversion
Source: "EducationCentre7.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "GUIStub.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "GUIToGo.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "IPDolphin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "IPDolphinToGo.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "SciLexer.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Welcome.st"; DestDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; IconFilename: "{app}\{#MyAppExeName}"; IconIndex: 0; Parameters: "{#ImageName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; IconFilename: "{app}\{#MyAppExeName}"; IconIndex: 0; Parameters: "{#ImageName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Parameters: "{#ImageName}"; WorkingDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#MyAppName}}"

[Registry]
Root: HKCR; Subkey: "{#ImageExtension}"; ValueType: string; ValueName: ""; ValueData: "Dolphin7Image"; Flags: uninsdeletevalue 
Root: HKCR; Subkey: "Dolphin7Image"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName} Image"; Flags: uninsdeletekey 
Root: HKCR; Subkey: "Dolphin7Image\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0" 
Root: HKCR; Subkey: "Dolphin7Image\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""