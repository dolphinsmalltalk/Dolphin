"Filed out from Dolphin Smalltalk"!

Core.SessionManager
	subclass: #'UI.GUISessionManager'
	instanceVariableNames: 'savedWindows'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'NoSplashMask' -> 16r2. 'UnattendedMask' -> 16r4 }!
UI.GUISessionManager guid: (Core.GUID fromString: '{81bc839c-bcd6-4502-a491-418ed5a109e6}')!
UI.GUISessionManager comment: 'GUISessionManager is the class of <SessionManager>s used to manage the life-cycle of a graphical (as opposed to command line, or console) application.

Note that Dolphin GUI applications can access the console and standard I/O streams, but a separate console window will be opened.

Instance Variables:
	savedWindows	<UndefinedObject>, or <Array> of <ViewState>. Saved state of open windows (image save/load)

'!
!UI.GUISessionManager categoriesForClass!System-Support! !
!UI.GUISessionManager methodsFor!

allocConsole
	"Private - Open a console window for this session."

	(self isUnattended and: [Kernel32 attachConsole: ATTACH_PARENT_PROCESS])
		ifFalse: 
			[| hMenu |
			Kernel32 allocConsole.
			"Remove the close button from the console window as otherwise if the user
			closes it Windows will kill this process with no way to intercept."
			hConsole := Kernel32 getConsoleWindow.
			hMenu := User32 getSystemMenu: hConsole bRevert: false.
			User32
				deleteMenu: hMenu
				uPosition: SC_CLOSE
				uFlags: MF_BYCOMMAND]!

basicShutdown
	"Private - Perform basic system shutdown operations, just prior to the VM putting
	out the lights."

	self windowSystemShutdown.
	super basicShutdown!

basicTertiaryStartup
	"Perform tertiary system startup operations."

	self logComment: self applicationName, ' started'.

	[self isEmbedded
		ifTrue: [self embeddedStartup]
		ifFalse: [self restoreWindowState]
	] ensure: [self clearWindowState]!

clearSessionState
	"Clear any state saved down for a image save which is will not be required until that saved image is
	rehydrated."

	self clearWindowState!

clearWindowState
	"Private - Clear the state of the top-level windows."

	savedWindows := nil!

commandLineParser
	"
	-h - headless (embedded) mode
	-q - quiet startup (no splash)
	"

	^(CommandLine argv: self argvLegacyOptionsRemoved)
		options: 'hq';
		yourself!

disableWindowGhosting
	"Disable the Windows feature where if the process stops processing messages from the message queue for 5 seconds, it replaces all the top-level windows with so-called 'ghost' windows. For general applications this is probably not appropriate, but in some cases, such as a development system, the window ghosting is undesirable as it prevents the application receiving any asynchronous keyboard interrupt, and therefore prevents the Dolphin interrupt key sequence from being recognised, making runaway operations uninterruptable."

	User32 disableProcessWindowsGhosting!

inputStateClass
	^GuiInputState!

isForegroundProcess
	"Answer whether this Dolphin process owns the foreground window"

	^User32 isForegroundProcess: Kernel32 getCurrentProcessId!

isUnattended
	"Answer whether the session was started with a unattended flag"

	^flags allMask: UnattendedMask!

onInputLanguageChanged: aWindowsEvent
	"Private - The input language (keyboard) has been changed."

	settingsChanged add: #('InputLang' 0).
	inputState msgWindow setTimer: SettingsChangeTimerId interval: 1000!

onSettingChanged: aSettingsChangeEvent
	"Private - A system setting has been changed. This could be any of a wide range of things from a theme change,
	regional settings, even policy. The notifications come in thick and fast because they are sent to every top-level
	window. We consolidate them by queuing them up for coalescing any that arrive within a 1-second window."

	settingsChanged add: {aSettingsChangeEvent area. aSettingsChangeEvent uiAction}.
	inputState msgWindow setTimer: SettingsChangeTimerId interval: 1000!

onTimeChanged: aWindowsEvent
	"Private - The system time has been changed. The notifications come in thick and fast because they are sent to every top-level
	window. We consolidate them by queuing them up for coalescing any that arrive within a 1-second window."

	settingsChanged add: #('Time' 0).
	inputState msgWindow setTimer: SettingsChangeTimerId interval: 1000!

onTimer: anInteger
	super onTimer: anInteger.
	anInteger == SettingsChangeTimerId ifTrue: [self triggerSettingsChanged]!

parseCmdLineFlags
	| options |
	super parseCmdLineFlags.
	options := self commandLineParser options.
	((cmdLineFlags includes: 'nosplash') or: [options includesKey: $q])
		ifTrue: [flags := flags maskSet: NoSplashMask].
	(options includesKey: $h) ifTrue: [flags := flags maskSet: EmbeddingMask]!

resourceManager
	"Answer the resource manager to use to locate resources"

	^ResourceIdentifier!

restoreWindowState
	"Private - Restore the state of the persistant top-level windows."

	savedWindows notNil
		ifTrue: [savedWindows do: [:each | [each restore] on: ProcessTermination do: [:e | ]]]!

saveSessionState
	"Save down any session state that needs to be preserved and which is not automatically
	preserved by a normal image save. Examples would be externally managed resources
	such as Windows."

	self saveWindowState!

saveWindowState
	"Private - Save the state of the top-level windows."

	inputState purgeDeadWindows.
	savedWindows := self topLevelWindowsInZOrder reverse
				collect: [:w | ViewState recordStateOf: w forRecreate: false]!

showSplash
	"Show a splash screen for this session. Can be overidden in subclasses to bring up
	an appropriate splash." 

	^false
!

startUI
	"Start up the input loop/message loop (instruct InputState appropriate depending on whether
	this is a GUI or console session)."

	self windowSystemStartup.
	self inputState guiStartup
!

tertiaryStartup
	"Perform GUI-system tertiary startup"

	| splashShown silenceSplash |
	silenceSplash := flags allMask: NoSplashMask.
	"Pop-up the splash screen before the windows are restored"
	splashShown := silenceSplash not and: [self showSplash].
	super tertiaryStartup.
	splashShown ifFalse: [self trigger: #sessionReady]!

topLevelWindows
	"Answer a collection of the top-level windows which are currently open."

	^self inputState topLevelWindows select: [:w | w isPersistentView]!

topLevelWindowsInZOrder
	"Answer a collection of the top-level windows which are currently open."

	^self inputState topLevelWindowsInZOrder select: [:w | w isPersistentView]!

triggerSettingsChanged
	| pending |
	pending := settingsChanged.
	settingsChanged := Set new.
	pending do: [:each | self trigger: #settingChanged: with: each]!

windowSystemShutdown
	"Private - Terminate the window system to release resources prior to exit. Much of this
	isn't strictly necessary in a 32-bit application, but it's nice to wipe."

	#(#{View} #{Canvas} #{GraphicsTool}) do: [:s | s ifDefined: [:c | c onExit]]!

windowSystemStartup
	"Private - Perform window system startup operations."

	#(#{Canvas} #{GraphicsTool} #{Clipboard} #{View} #{ToolbarIconButton} #{Command})
		do: [:s | s ifDefined: [:c | c onStartup]]! !
!UI.GUISessionManager categoriesForMethods!
allocConsole!operations!private! !
basicShutdown!operations-shutdown!private! !
basicTertiaryStartup!operations-startup!public! !
clearSessionState!operations!public! !
clearWindowState!operations-saving!private! !
commandLineParser!helpers!private! !
disableWindowGhosting!helpers!public! !
inputStateClass!constants!private! !
isForegroundProcess!public!testing! !
isUnattended!public!testing! !
onInputLanguageChanged:!event handling!private! !
onSettingChanged:!event handling!private! !
onTimeChanged:!event handling!private! !
onTimer:!event handling!private! !
parseCmdLineFlags!operations-startup!private! !
resourceManager!accessing!public! !
restoreWindowState!operations-startup!private! !
saveSessionState!operations!public! !
saveWindowState!operations-saving!private! !
showSplash!operations!public! !
startUI!operations-startup!public! !
tertiaryStartup!operations-startup!public! !
topLevelWindows!accessing!public! !
topLevelWindowsInZOrder!accessing!public! !
triggerSettingsChanged!event handling!private! !
windowSystemShutdown!operations-shutdown!private! !
windowSystemStartup!operations-startup!private! !
!

!UI.GUISessionManager class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon window!

isConsoleApplication
	"Answer whether the sessions managed by instances of the receiver are for a console application 
	(as opposed to a GUI application, which is a completely separate thing under Windows)."

	^false! !
!UI.GUISessionManager class categoriesForMethods!
icon!constants!development!public! !
isConsoleApplication!public!testing! !
!

