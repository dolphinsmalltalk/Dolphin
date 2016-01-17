"Filed out from Dolphin Smalltalk 7"!

SessionManager subclass: #GUISessionManager
	instanceVariableNames: 'savedWindows'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GUISessionManager guid: (GUID fromString: '{81BC839C-BCD6-4502-A491-418ED5A109E6}')!
GUISessionManager comment: 'GUISessionManager is the class of <SessionManager>s used to manage the life-cycle of a graphical (as opposed to command line, or console) application.

Note that Dolphin GUI applications can access the console and standard I/O streams, but a separate console window will be opened.

Instance Variables:
	savedWindows	<UndefinedObject>, or <Array> of <ViewState>. Saved state of open windows (image save/load)

'!
!GUISessionManager categoriesForClass!System-Support! !
!GUISessionManager methodsFor!

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

isEmbedding
	"Answer whether the session was started with the headless flag."

	^self commandLineParser options includesKey: $h!

onSettingChanged: aWindowsEvent 
	SystemMetrics current onSettingChanged: aWindowsEvent!

openConsoleStreams
	"Private - Open the standard console I/O streams. Note that the actual
	C-runtime library stdin/stdout/stderr streams will be correctly set up so
	that it is possible to use the CRT stdio functions such as puts(), printf(), etc."

	| crt |
	stdioStreams isNil ifFalse: [^self].
	crt := CRTLibrary default.
	stdioStreams := Array 
				with: (StdioFileStream fromHandle: (crt 
								connectDescriptor: 0
								toWinStdHandle: STD_INPUT_HANDLE
								mode: 'rt'))
				with: (StdioFileStream fromHandle: (crt 
								connectDescriptor: 1
								toWinStdHandle: STD_OUTPUT_HANDLE
								mode: 'wt'))
				with: (StdioFileStream fromHandle: (crt 
								connectDescriptor: 2
								toWinStdHandle: STD_ERROR_HANDLE
								mode: 'wt'))!

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

	savedWindows := self topLevelWindows reverse collect: [ :w | ViewState recordStateOf: w forRecreate: false]!

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
	"Perform GUI  system tertiary startup"

	"Pop-up the splash screen before the windows are restored"
	| splashShown silenceSplash |
	silenceSplash := (self cmdLineFlags includes: 'nosplash') 
				or: [self commandLineParser options includesKey: $q].
	splashShown := silenceSplash not and: [self showSplash].
	super tertiaryStartup.
	splashShown ifFalse: [self trigger: #sessionReady]!

topLevelWindows
	"Answer a collection of the top-level windows which are currently open."

	^self inputState topLevelWindows select: [:w | w isPersistentView]!

whatsThis: object 
	| helpId |
	helpId := object helpId.
	View active winHelpPopup: self popupHelpFile topic: helpId!

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
!GUISessionManager categoriesFor: #basicShutdown!operations-shutdown!private! !
!GUISessionManager categoriesFor: #basicTertiaryStartup!operations-startup!public! !
!GUISessionManager categoriesFor: #clearSessionState!operations!public! !
!GUISessionManager categoriesFor: #clearWindowState!operations-saving!private! !
!GUISessionManager categoriesFor: #commandLineParser!helpers!private! !
!GUISessionManager categoriesFor: #isEmbedding!public!testing! !
!GUISessionManager categoriesFor: #onSettingChanged:!event handling!private! !
!GUISessionManager categoriesFor: #openConsoleStreams!operations!private! !
!GUISessionManager categoriesFor: #resourceManager!accessing!public! !
!GUISessionManager categoriesFor: #restoreWindowState!operations-startup!private! !
!GUISessionManager categoriesFor: #saveSessionState!operations!public! !
!GUISessionManager categoriesFor: #saveWindowState!operations-saving!private! !
!GUISessionManager categoriesFor: #showSplash!operations!public! !
!GUISessionManager categoriesFor: #startUI!operations-startup!public! !
!GUISessionManager categoriesFor: #tertiaryStartup!operations-startup!public! !
!GUISessionManager categoriesFor: #topLevelWindows!accessing!public! !
!GUISessionManager categoriesFor: #whatsThis:!commands!public! !
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

