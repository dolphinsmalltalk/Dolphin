#define MyAppName "Dolphin Smalltalk"
#define MyAppVersion "8"
#define MyAppPublisher "Object Arts"
#define MyAppURL "http://www.object-arts.com/"
#define MyAppExeName "Dolphin8.exe"
#define ImageName "DPRO.img8"
#define ImageExtension ".img8"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{DC16836C-2C53-449C-926F-A3DD968F96BE}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\{#MyAppName} {#MyAppVersion}
LicenseFile=LICENSE
DisableProgramGroupPage=yes
OutputDir=Releases\Dolphin8Setup
OutputBaseFilename=Dolphin8Setup
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes
SetupIconFile=Resources\Dolphin.ico
UninstallDisplayName={#MyAppName} {#MyAppVersion}
UninstallDisplayIcon={app}\{#MyAppExeName}
AllowUNCPath=False
WizardImageFile=Resources\WizardDolphinSmalltalk.bmp
WizardSmallImageFile=Resources\WizardSmallDolphinSmalltalk.bmp

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: {#MyAppExeName}; DestDir: "{app}"; Flags: ignoreversion
Source: "Resources\*"; DestDir: "{app}\Resources"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "Help\*"; DestDir: "{app}\Help"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "ConsoleStub.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "ConsoleToGo.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "DolphinCR8.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "DolphinDR8.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "DolphinVM8.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "DolphinAX8.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "DPRO.chg"; DestDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: ignoreversion
Source: "DPRO.img8"; DestDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: ignoreversion
Source: "DPRO.sml"; DestDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: ignoreversion
Source: "EducationCentre7.chm"; DestDir: "{app}"; Flags: ignoreversion
Source: "GUIStub.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "GUIToGo.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "IPDolphin.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "IPDolphinToGo.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "LICENSE"; DestDir: "{app}"; Flags: ignoreversion
Source: "README.md"; DestDir: "{app}"; Flags: ignoreversion
Source: "Scintilla.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Lexilla.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "WebView2Loader.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "Welcome.st"; DestDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: ignoreversion
Source: "{#GetEnv('VCToolsRedistDir')}\vc_redist.x86.exe"; DestDir: {tmp}; Flags: deleteafterinstall
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; IconFilename: "{app}\{#MyAppExeName}"; IconIndex: 0; Parameters: "{#ImageName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; IconFilename: "{app}\{#MyAppExeName}"; IconIndex: 0; Parameters: "{#ImageName}"; Tasks: desktopicon

[Run]
Filename: "{tmp}\VC_redist.x86.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing VC runtime..."; Flags: waituntilterminated
Filename: "{app}\{#MyAppExeName}"; Parameters: "{#ImageName}"; WorkingDir: "{userdocs}\{#MyAppName} {#MyAppVersion}"; Flags: nowait postinstall skipifsilent; Description: "{cm:LaunchProgram,{#MyAppName}}"

[Registry]
Root: HKCR; Subkey: "{#ImageExtension}"; ValueType: string; ValueName: ""; ValueData: "Dolphin8Image"; Flags: uninsdeletevalue 
Root: HKCR; Subkey: "Dolphin8Image"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName} Image"; Flags: uninsdeletekey 
Root: HKCR; Subkey: "Dolphin8Image\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0" 
Root: HKCR; Subkey: "Dolphin8Image\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""