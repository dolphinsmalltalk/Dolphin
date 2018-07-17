"Filed out from Dolphin Smalltalk 7"!

SessionManager subclass: #GUISessionManager
	instanceVariableNames: 'savedWindows'
	classVariableNames: 'NoSplashMask UnattendedMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GUISessionManager guid: (GUID fromString: '{81bc839c-bcd6-4502-a491-418ed5a109e6}')!
GUISessionManager addClassConstant: 'NoSplashMask' value: 2!
GUISessionManager addClassConstant: 'UnattendedMask' value: 4!
GUISessionManager comment: 'GUISessionManager is the class of <SessionManager>s used to manage the life-cycle of a graphical (as opposed to command line, or console) application.

Note that Dolphin GUI applications can access the console and standard I/O streams, but a separate console window will be opened.

Instance Variables:
	savedWindows	<UndefinedObject>, or <Array> of <ViewState>. Saved state of open windows (image save/load)

'!
!GUISessionManager categoriesForClass!System-Support! !
!GUISessionManager methodsFor!

allocConsole
	"Private - Open a console window for this session."

	| kernel |
	kernel := KernelLibrary default.
	(self isUnattended and: [kernel attachConsole: ATTACH_PARENT_PROCESS])
		ifFalse: 
			[| hMenu user |
			kernel allocConsole.
			"Remove the close button from the console window as otherwise if the user
			closes it Windows will kill this process with no way to intercept."
			hConsole := kernel getConsoleWindow.
			user := UserLibrary default.
			hMenu := user getSystemMenu: hConsole bRevert: false.
			user
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

isUnattended
	"Answer whether the session was started with a unattended flag"

	^flags allMask: UnattendedMask!

onSettingChanged: aWindowsEvent 
	SystemMetrics current onSettingChanged: aWindowsEvent!

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

	savedWindows notNil ifTrue: [
		savedWindows do: [:each | 
			[each restore] on: ProcessTermination do: [:e |]]]!

saveSessionState
	"Save down any session state that needs to be preserved and which is not automatically
	preserved by a normal image save. Examples would be externally managed resources
	such as Windows."

	self saveWindowState!

saveWindowState
	"Private - Save the state of the top-level windows."

	savedWindows := self topLevelWindowsInZOrder reverse collect: [ :w | ViewState recordStateOf: w forRecreate: false]

!

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

windowSystemShutdown
	"Private - Terminate the window system to release resources prior to exit. Much of this
	isn't strictly necessary in a 32-bit application, but it's nice to wipe."

	| env |
	env := self class environment.
	#(#View #Canvas #GraphicsTool) do: [:s | env at: s ifPresent: [:c | c onExit]]!

windowSystemStartup
	"Private - Perform window system startup operations."

	| env |
	env := self class environment.
	#(#Canvas #GraphicsTool #Clipboard #View #ToolbarIconButton #Command) 
		do: [:s | env at: s ifPresent: [:c | c onStartup]]! !
!GUISessionManager categoriesFor: #allocConsole!operations!private! !
!GUISessionManager categoriesFor: #basicShutdown!operations-shutdown!private! !
!GUISessionManager categoriesFor: #basicTertiaryStartup!operations-startup!public! !
!GUISessionManager categoriesFor: #clearSessionState!operations!public! !
!GUISessionManager categoriesFor: #clearWindowState!operations-saving!private! !
!GUISessionManager categoriesFor: #commandLineParser!helpers!private! !
!GUISessionManager categoriesFor: #isUnattended!public!testing! !
!GUISessionManager categoriesFor: #onSettingChanged:!event handling!private! !
!GUISessionManager categoriesFor: #parseCmdLineFlags!operations-startup!private! !
!GUISessionManager categoriesFor: #resourceManager!accessing!public! !
!GUISessionManager categoriesFor: #restoreWindowState!operations-startup!private! !
!GUISessionManager categoriesFor: #saveSessionState!operations!public! !
!GUISessionManager categoriesFor: #saveWindowState!operations-saving!private! !
!GUISessionManager categoriesFor: #showSplash!operations!public! !
!GUISessionManager categoriesFor: #startUI!operations-startup!public! !
!GUISessionManager categoriesFor: #tertiaryStartup!operations-startup!public! !
!GUISessionManager categoriesFor: #topLevelWindows!accessing!public! !
!GUISessionManager categoriesFor: #topLevelWindowsInZOrder!accessing!public! !
!GUISessionManager categoriesFor: #windowSystemShutdown!operations-shutdown!private! !
!GUISessionManager categoriesFor: #windowSystemStartup!operations-startup!private! !

!GUISessionManager class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon window!

isConsoleApplication
	"Answer whether the sessions managed by instances of the receiver are for a console application 
	(as opposed to a GUI application, which is a completely separate thing under Windows)."

	^false! !
!GUISessionManager class categoriesFor: #icon!constants!development!public! !
!GUISessionManager class categoriesFor: #isConsoleApplication!public!testing! !

