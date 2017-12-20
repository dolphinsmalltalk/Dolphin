"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SessionManager
	instanceVariableNames: 'inputState resourceLibrary imagePath servers argv cmdLineFlags state sentry startupArgs consoleHandler stdioStreams eventLogHandle flags sessionId'
	classVariableNames: 'Current EmbeddingMask PreStartFile'
	poolDictionaries: 'Win32Constants Win32Errors'
	classInstanceVariableNames: ''!
SessionManager guid: (GUID fromString: '{87b4c4b7-026e-11d3-9fd7-00a0cc3e4a32}')!
SessionManager isAbstract: true!
SessionManager addClassConstant: 'EmbeddingMask' value: 1!
SessionManager comment: 'SessionManager is the class of objects responsible for managing the lifecyle of an application, from startup to shutdown. SessionManagers are also responsible for determining the global policy for dealing with unhandled Exceptions. 

SessionManager itself is abstract, with two further abstract subclasses that divide applications into two groups: <ConsoleSessionManager> whose subclasses implement Console (that is, command line, DOS style) applications, and <GUISessionManager> whose subclasses implement GUI (that is, Windows) applications.

When you come to deploy an application, you will probably need to write a SessionManager for it, although it is possible to do without (see the ADK documentation). In the case of a console application you should subclass <ConsoleSessionManager>, and in the case of a GUI application you should typically subclass <RuntimeSessionManager>. To get going it is only necessary to implement a #main method which either implements the main body of the application (in the case of simple console apps), or which invokes it by creating an instance of some other class, passing it appropriate arguments drawn from the #argv collection which is a collection of the components that formed the original command which started the application.

Instance Variables:
	inputState		<InputState>. Implements the Windows message loop (even console apps have one in Dolphin).
	resourceLibrary	<ExternalResourceLibrary>. Default library containing application resources.
	resourceManager	<ResourceManager>. Manager for Dolphin resources, such as views.
	imagePath		<String>. Path from which the image was loaded (path of the .EXE if a deployed app)
	servers		<SharedIdentitySet>. Running "servers" e.g. OLE servers, which need the session to stay up.
	argv		<Array> of <String>. Command line arguments in the normal C arrangement (first is .EXE name)
	cmdLineFlags	<Set> of <String>. Command line arguments prefixed with - or /.
	state		<SmallInteger>. Current stage of sessions life. Mostly relevant during startup and shutdown.
	sentry		<ExternalHandle>. Handle of Win32 named Semaphore which indicates running instance of image.
	startupArgs	<Array>. Raw startup arguments passed in by the VM.
	consoleHandler	<MessageCallback>. Handler for Win32 console control message callback.
	stdin		<StdioFileStream>. Standard input stream.
	stdout		<StdioFileStream>. Standard output stream.
	stderr		<StdioFileStream>. Standard error stream.

Class Variables:
	PreStartFile	<String>. Name of the file-in fairly early in startup to effect repairs, etc.
	Current		<SessionManager>. Singleton instance, being the current session manager.

'!
!SessionManager categoriesForClass!System-Support! !
!SessionManager methodsFor!

allocConsole
	"Private - Open a console window for this session."

	KernelLibrary default allocConsole
!

allowDuplicate
	"It would appear that the image associated with this session is already open. Take action
	appropriate to the policies of the receiver. Answer whether to continue the session.
	The default is to carry on brazenly."

	^true

!

appIdString
	"Answer a unique string name for the receiver - this does not need to be human readable, as
	it is used to uniquely identify the application in common registry locations, etc. For
	example it is used to form the unique name for suppressible message boxes. A good choice
	would be the numeric characters of the session manager class' GUID, but note that class
	GUIDs are stripped on deployment by default."

	^self applicationName!

applicationName
	"Answer the application name. Use the applications executable name."

	^self argc > 0
		ifTrue: [File splitStemFrom: self argv first]
		ifFalse: ['Application']!

applicationShortName
	"Answer the abbreviated application name."

	^self applicationName!

argc
	"Answer the number of the command line arguments."

	^self argv size!

argv
	"Answer an array of Strings containing the command line arguments."

	argv isNil
		ifTrue: 
			[| lib argc lppstr |
			lib := VMLibrary default.
			argc := lib argc.
			argv := Array new: argc.
			"Open code the access to the array of strings to reduce base system dependencies on external struct classes"
			lppstr := lib argv.
			1 to: argc
				do: 
					[:i |
					| offset |
					offset := (i - 1) * VMConstants.IntPtrSize.
					argv at: i put: (String fromAddress: (lppstr dwordAtOffset: offset))]].
	^argv!

argvLegacyOptionsRemoved
	"Private - Answer the argv arguments vertor with the old style legacy options removed"

	^self argv reject: 
			[:each | 
			| opt |
			opt := each allButFirst asLowercase.
			opt = 'nosplash' or: [opt = 'embedding']]!

backupOnImageSave
	"Answer whether the image should be backed up (i.e. the old .img file is renamed to .bak when the new .img
	file is successfully written). Note that this will slow down the operation quite a bit, as the OS has to do a lot
	more juggling."

	^false!

basicPrimaryStartup
	"Perform critical startup operations which initialize the basic
	services in the image such as the process system. These startup activities
	should be kept to a minimal set, as there is no opportunity to repair any
	damage until these are completed, so if they fail, you've had it."

	VMLibrary default onStartup.	"The VMLibrary must be initialized before we do anything else."
	self openLibraries.	"Now we can open the permanent libraries"
	self imagePath: imagePath.	"Split off the extension now can use lib functions."
	ExternalCallback onStartup.	"Old callbacks will be invalid"
	self createInputState.	"Register input semaphore, etc, kill previous idler in case on a different host OS"
	self class environment at: #Delay ifPresent: [:d | d onStartup].	"Reschedule delays etc."
	MemoryManager current onStartup.	"Start (if necessary) finalization/bereavement processing, etc"
	sessionId := GUID newUnique.		"Allow deferred tasks to know if they passed a startup boundary"
!

basicSecondaryStartup
	"Perform secondary startup operations which initialize non-critical
	basic services in the image, such as the dates and times, and also initialize
	the message loop handler (we have a basic message loop even in a console 
	app)."

	Float onStartup.
	self class environment at: #Locale ifPresent: [:d | d onStartup].
	self parseCmdLineFlags!

basicShutdown
	"Private - Perform basic system shutdown operations, just prior to the VM putting
	out the lights."

	self closeConsole.
	self comShutdown.
	self class environment at: #Delay ifPresent: [:d | d onExit].
	inputState onExit.
	ExternalLibrary onExit.
	KernelLibrary default closeHandle: sentry
!

basicStdioStreams
	"Private - Answer the 3-element <Array> of <StdioFileStream>s which are the 
	CRT stdin, stdout, and stderr streams, or nil if not opened yet."

	^stdioStreams!

basicTertiaryStartup
	"Perform tertiary system startup operations."

	^self subclassResponsibility!

clearSessionState
	"Clear any state saved down for a image save which is will not be required until that saved image is
	rehydrated."

	"By default, assume there is no extra state to save, and do nothing."!

closeConsole
	"Disconnect from and close any open console, including the standard input and output
	streams."

	self 
		closeConsoleStreams;
		unregisterConsoleCtrlHandler;
		freeConsole
!

closeConsoleStreams
	"Private - Close the standard console I/O streams."
	
	stdioStreams isNil ifTrue: [^self].
	1 to: 3
		do: 
			[:i | 
			| stm |
			(stm := stdioStreams at: i) notNil ifTrue: [stm close]].
	stdioStreams := nil!

closeEventLog
	"Private - Close the NT event log, if open."

	eventLogHandle notNil ifTrue: [
		AdvApiLibrary default deregisterEventSource: eventLogHandle.
		eventLogHandle := nil]!

computerName
	"Answer the name of the computer hosting the current session. 
	Signals an exception if the request fails."

	| name nameSize |
	name := String new: MAX_COMPUTERNAME_LENGTH.
	nameSize := DWORD fromInteger: name size+1.
	(KernelLibrary default getComputerName: name nSize: nameSize asParameter)
		ifFalse: [KernelLibrary default systemError].
	^name leftString: nameSize asInteger!

comShutdown
	"Private - The system is about to shut down, so clear up any COM hangers on.
	Note: This used to be done by hanging of the shutdown trigger, but with the
	advent of control hosting there are sequencing issues, in particular it is important
	that the window system be closed before any COM object stubs in the receiver
	are destroyed. As the COM package may not be loaded, we can't use a hard
	reference to <COMInterface>"

	self outer notNull ifTrue: [self outer free].
	Smalltalk at: #COMInterface ifPresent: [:c | c onExit]!

createInputState
	inputState := self inputStateClass newFromOld: inputState!

createSentinel
	sentry := KernelLibrary default 
				createMutex: nil
				bInitialOwner: false
				lpName: self sentinelName.
	^KernelLibrary default getLastError == ERROR_ALREADY_EXISTS!

defaultResLibPath
	"Answer the path of the development resource library."

	^'DolphinDR7'!

defaultResourceLibrary
	"Private - Answer the ExternalResourceLibrary containing the Dolphin 
	development system resources."

	resourceLibrary isNil 
		ifTrue: 
			[resourceLibrary := ExternalResourceLibrary 
						open: self defaultResLibPath
						withAliases: #('dolphindr7' 'dolphindr006' 'dolphindr005' 'dolphindr004' 'dolphindevres' 'dolphindr993')
						flags: 0].
	^resourceLibrary!

embeddedStartup
	"Private - The session has been started as an embedded session, perform appropriate
	actions."

	#todo "This is necessary because of dum GC strategy - we need to wake up to ensure it happens".
	[[Processor sleep: 1000] repeat] forkAt: Processor systemBackgroundPriority
			
			!

errorLogExtension
	"Answer the suffix for an error log file"

	^'errors'!

errorLogName
	"Answer the name of the error log file used to record error information (e.g. unhandled exceptions)."

	^File default: self imagePath extension: self errorLogExtension!

eventLogSource
	"Answer the 'source' that should be passed to the ReportEvent() API when logging events
	to the NT event log. This name will appear as the source of the event in the NT event
	viewer."

	^self applicationName!

exit
	"Request to close down the session (user may cancel)."

	self exit: 0!

exit: anInteger
	"Request to close down the session with the specified exit code (user may cancel)."

	self inputState postQuit: anInteger!

forkMain
	"Start a new main process appropriate for the session.
	Override this to fork a specific main process. The default is to fork
	the standard message loop executing main process via the input state.
	We also defer an action to be processed by that UI process that acks
	the receiver that the UI loop has started."

	self inputState queueDeferredAction: [self mainLoopStarted].
	inputState forkMain!

free
	"Free up any artifacts belonging to relevant to the current Session."

	^self!

freeConsole
	"Private - Close (actually detach from) the console for this session.
		SessionManager current freeConsole
	"

	KernelLibrary default freeConsole!

getCommandLine
	"Private - Answer the command line String used to start Dolphin."

	^KernelLibrary default getCommandLine!

getenv: aString
	"Answer the value of the specified environment variable, or nil if it does not exist.
	N.B. Size answered includes null terminator IF not enough space (or nil buffer)."

	| buf size |
	"N.B. Size answered includes null terminator IF not enough space (or nil buffer)."
	size := KernelLibrary default getEnvironmentVariable: aString lpBuffer: nil nSize: 0.
	size == 0 ifTrue: [^nil].
	buf := String new: size-1.	"Dolphin Strings alloc. extra space for null terminator"
	KernelLibrary default getEnvironmentVariable: aString lpBuffer: buf nSize: size.
	^buf
	!

hasActiveServers
	"Private - Answer whether there are any servers still registered in this
	session."

	^self servers notEmpty!

imageBase
	"Answer the base directory in which the image resides"

	^File splitPathFrom: self imagePath!

imageExtension
	"Private - Answer the suffix for an executable image file"

	^self class imageExtension!

imageFileName
	"Answer the file name of the current image."

	^File default: self imagePath extension: self imageExtension!

imagePath
	"Answer the base file path on which the image, source and changes
	file names are based. An example might be: c:\Program Files\Dolphin\Dolphin."

	^imagePath!

imagePath: aPathString 
	"Private - used only after loading an image to set up path to the image and sources."

	imagePath := File removeExtension: (File fullPathOf: aPathString)!

imageVersion
	"Answer a String in the form N.N.N.N which specifies the version number of the image."

	| ms ls |
	ms := self imageVersionMajor.
	ls := self imageVersionMinor.
	^'<1d>.<2d>.<3d>.<4d>' 
		expandMacrosWith: ms highWord
		with: ms lowWord
		with: ls highWord
		with: ls lowWord!

imageVersionMajor
	"Answer the major component of the images version Integer."

	^VMLibrary default registryAt: #ImageVersionMajor!

imageVersionMinor
	"Answer the minor component of the images version Integer."

	^VMLibrary default registryAt: #ImageVersionMinor!

initialize
	"Private - Initialize the receiver after installation as the current SessionManager.
	Answer the receiver."

	state := 6.
	servers := nil.
	imagePath := '.\Dolphin'.
	^self!

initializeFromSessionManager: oldSessionManager
	"Private - The receiver has taken take over as the current session
	manager from oldSessionManager. This is an opportunity to transfer
	state information from the replaced manager."

	imagePath := oldSessionManager imagePath.
	stdioStreams := oldSessionManager basicStdioStreams.
	startupArgs := oldSessionManager startupArgs.
	^self!

inputState
	"Answer the receiver's <InputState>, lazily creating it if necessary."

	^inputState!

inputState: anInputState 
	"Private - Set the receiver's InputState.
	WARNING: Do this very carefully, or the system will crash."

	inputState := anInputState!

inputStateClass
	^InputState!

install
	SessionManager current retire.
	SessionManager current: self.
	^SessionManager current initializeFromSessionManager: self!

installationDirectory
	"Private - Answer the <readableString> path name of the directory in which this
	application is installed.
		SessionManager current installationDirectory.
	Application specific subclasses can override this to answer a directory read from
	a registry key (for example), or whatever is appropriate. The default is derived
	from the path of the loaded image."

	^self imageBase

	!

isBinaryLooseMethodInstallationAllowed
	"Private - Answer true if loose method can be installed into the image by a BinaryPackage"

	^true!

isConsoleApplication
	"Answer whether the session is for a console application (as opposed to a GUI application)."

	^self class isConsoleApplication!

isDebug
	^self versionInfo productVersionString contains: '(Debug)'!

isDLL
	"Private - Answer whether the receiver is a shared library, as opposed to an application."

	^self class isDLL!

isEmbedded
	"Answer whether the session is running, or should be started, in 'embedded' 
	mode (i.e. headless)."

	^self isDLL or: [self isEmbedding]!

isEmbedding
	"Answer whether the session was started with a headless flag"

	^flags allMask: EmbeddingMask!

isHeadless
	"Private - Answer whether the session is _currently_ headless. This is most likely if the
	image was started a headkess-h flag, and no visible windows have subsequently been
	opened."

	^self inputState hasVisibleWindows not!

isOAD
	"Private - Is this an Object Arts Development image?"

	^false!

isRuntime
	"Answer whether this is a run-time session (i.e. running an application rather than the development
	system."

	^self class isRuntime!

keepAlive
	"The inputState has determined that there are no live windows.
	By default we therefore shutdown if not acting as an embedded server.

	This can be overridden by derived classes that want to employ
	a different policy for deciding when to shut down."

	(self isEmbedded and: [self hasActiveServers])
		ifFalse: [self quit]!

logComment: aString
	"Ignore the comment string."

!

logError: anException
	"Append details about the unhandled exception, anException, to the session error log.
	Ignored for runtime systems, but it is suggested that subclasses perform some appropriate
	form of error logging. Here we are using the VM's dump facility to append a short
	but informative log each time an error occurs, to <app name>.ERRORS."

	VMLibrary default dump: anException description path: nil stackDepth: 0 walkbackDepth: -1!

logErrorEvent: message
	"Write a EVENTLOG_ERROR_TYPE entry to the system event log. Only available on NT/Win2K."

	self logEvent: message type: EVENTLOG_ERROR_TYPE!

logEvent: message type: typeCode
	"Write an entry to the system event log. Only available on NT/Win2K."

	| inserts app |
	eventLogHandle isNil ifTrue: [
		self openEventLog.
		eventLogHandle isNil ifTrue: ["Event log not available" ^self]].

	inserts := DWORDArray new: 2.
	app := self applicationName.
	inserts at: 1 put: app yourAddress.
	inserts at: 2 put: message yourAddress.

	(AdvApiLibrary default reportEvent: eventLogHandle wType: typeCode wCategory: 0 dwEventId: 1
			lpUserSid: nil wNumStrings: 2 dwDataSize: 0 lpStrings: inserts lpRawData: nil)
		ifFalse: [Win32Error signal]!

logInformationEvent: message
	"Write a EVENTLOG_INFORMATION_TYPE entry to the system event log. Only available on NT/Win2K."

	self logEvent: message type: EVENTLOG_INFORMATION_TYPE!

logSuccessEvent: message
	"Write a EVENTLOG_SUCCESS entry to the system event log. Only available on NT/Win2K."

	self logEvent: message type: EVENTLOG_SUCCESS!

logWarningEvent: message
	"Write a EVENTLOG_WARNING_TYPE entry to the system event log. Only available on NT/Win2K."

	self logEvent: message type: EVENTLOG_WARNING_TYPE!

main
	"Start the application associated with this run-time session. 
	This is the point to open the main application window, etc. It is called from the
	main UI process after the system startup has completed. See, for example,
	NotepadSessionManager that accompanies the Notepad sample."

	"N.B. There is no need to supersend this, it is a hook designed purely for app. use"!

mainLoopStarted
	"Private - The main UI loop has started, from which this message was sent.
	Enter the fifth age (maturity), and be 'In fair round belly with good capon lined.
	This is an appropriate time to fire up the application."

	state := 5.
	self main!

noVisibleWindows
	"Private - The inputState has determined that there are no live windows.
	If we have entered the fifth age (up and running), but not progressed
	into the sixth age, then send out a keepAlive heartbeat."

	state == 5 	"Full of wise saws and modern instances?"
		ifTrue: [self keepAlive]
!

onCloseConsole
	"The user is attempting to close the console window. Act accordingly."

	self exit: 0!

onConsoleCtrl: dwCtrlType
	"Private - Private  - Handle a console control event.
	If you set a breakpoint in here, don't terminate the process or it will exit
	the Dolphin image when 0 (false) is returned and NT invokes the default
	handler."

	dwCtrlType < CTRL_CLOSE_EVENT
		ifTrue: [self inputState queueDeferredAction: [self onUserBreak]]
		ifFalse: [
			dwCtrlType = CTRL_CLOSE_EVENT
				ifTrue: [self onCloseConsole]
				ifFalse: [self inputState postQuit: dwCtrlType]].
	^true!

onExit
	"Perform pre-termination actions.
	Note that it is too late to stop session termination now (at least in the design
	of the DevelopmentSessionManager)."

	state := 6.		"Into the lean and slippered pantaloon"

	self trigger: #sessionStopped.
	self shutdown.
	^true	"We don't allow cancel, but a subclass could answer false if it wanted"!

onPostSaveImage
	"Private - Perform post-image save actions"

	self clearSessionState.
	self trigger: #imageSaveCompleted!

onPreSaveImage
	"Private - Perform pre-image save actions"

	self trigger: #imageSaveStarting.
	self saveSessionState.
	
	"These could be done with triggers, but they are critical to system operation
	and will always be required. In addition, the Delay pre-save operation should
	be done as close as possible to the actual save so that it is able to record
	the correct milliscond clock value for rescheduling delays on restart."
	MemoryManager current onPreSaveImage.
	self class environment at: #Delay ifPresent: [:d | d onPreSaveImage].

!

onQueryWindowsShutdown
	"The Windows operating system is shutting down. Shut down the image without saving."

	self quit: 0!

onQuit: anInteger 
	"Handle a request to exit - the argument is the exit code.
	This message is normally sent from the InputState message pump.
	The request may be aborted if #queryEndSession: answers false."

	self trigger: #quitSessionRequested.
	self queryEndSession ifTrue: [self quit: anInteger]!

onStartup: args
	"Initialize the receiver immediately following system startup.
	This is the main system initialization routine, and is responsible
	for starting the windowing system, the process system, etc.
	WARNING: If you break the early startup process (especially before prestart.st)
	then you will not be able to load your image. It is recommended, therefore, that
	if changing startup code, you should attempt to run up a new copy of the image
	just saved BEFORE closing down. Walkbacks will work at just about any stage,
	but other windows will not open if View>>onStartup has not been run."

	state := 0.
	eventLogHandle := stdioStreams := consoleHandler := nil.

	"Save away the Array of startup arguments, passed in by the VM, for later use"
	startupArgs := args.
	imagePath := args class == Array ifTrue: [args first] ifFalse: [args].
	cmdLineFlags := argv := nil.
	flags := 0.

	[self primaryStartup.
	state := 1.		"Mewling and puking in the nurse's arms"

	"Before the secondary startup, lets have an opportunity of getting
	in and fixing and possible problems with the image (only required in Development?)"
	self preStart.
	self secondaryStartup.
	state := 2.		"The whining schoolboy with shining morning face"

	"We are now in a position to claim ownership of the image file, if relevant."
	self registerRunning.

	"Trigger any user startup processing"
	[self trigger: #sessionStarted] ensure: [self tertiaryStartup].
	state := 3	"The Lover sighing like furnace"] 
			ensure: 
				["Always attempt to start the main process (must place into state 5)
		 even if earlier startup failed. This may help recover a damaged
		 development image if the startup has progressed sufficiently far."
		self forkMain.
				state := 4	"Full of strange oaths and bearded like the pard"].

	"We must terminate the active process to prevent it from continuing from where it left
	off when the image was saved and running onExit processing, or whatever it would have
	done next. We also kill it to prevent any invalid termination running."
	Processor activeProcess kill!

onUnhandledError: anError
	"The unhandled Error, anError, occurred in the active Process.
	Perform whatever default processing is appropriate for the application."

	^self unhandledException: anError!

onUnhandledNotification: aNotification
	"The unhandled Notification, aNotification, occurred in the active Process.
	Display the notification description on the Transcript (or other trace device)."

	aNotification toTrace.
	"aNotification printTraceOn: Transcript."		"Use this to get more detail about where it came from."
	^nil!

onUnhandledWarning: aWarning
	"The unhandled Warning, aWarning, occurred in the active Process.
	Depending on the user response, either resume or terminate the process."

	^self unhandledException: aWarning!

onUserBreak
	"Private - The user interrupted the currect active process by pressing the
	interrupt key combination (usually CTRL+BREAK). Take appropriate action
	according to the session requirements."

	self inputState userInterruptSignal signal
!

openConsole
	"Open and a console for this session and connect standard input and output streams.
	Answer whether the console was open already."

	| wasOpen |
	wasOpen := consoleHandler notNil.
	self 
		allocConsole;
		registerConsoleCtrlHandler;
		openConsoleStreams.
	KernelLibrary default setConsoleTitle: self applicationName.
	^wasOpen!

openConsoleStreams
	"Private - Open the standard console I/O streams. Note that the actual C-runtime library
	stdin/stdout/stderr streams will be correctly set up so that it is possible to use the CRT
	stdio functions such as puts(), printf(), etc."

	| kernel crt |
	stdioStreams isNil ifFalse: [^self].
	kernel := KernelLibrary default.
	crt := CRTLibrary default.
	stdioStreams := (0 to: 2) collect: 
					[:fd |
					(crt _get_osfhandle: fd) asSignedInteger < 0
						ifTrue: 
							["stdio file descriptor is not currently established"
							StdioFileStream
								attach: (kernel getStdHandle: STD_INPUT_HANDLE - fd)
								toFd: fd
								mode: (fd == 0 ifTrue: [#read] ifFalse: [#append])]
						ifFalse: 
							["stdio file descriptor already initialized, e.g. because of pipe or redirection to a file"
							StdioFileStream fromHandle: (crt _fdopen: fd mode: (fd == 0 ifTrue: ['rt'] ifFalse: ['wt']))]]!

openEventLog
	"Private - Open the NT event log for writing, and answer a handle onto it that can be passed to the
	ReportEvent() API."

	eventLogHandle := VMLibrary default registerEventSource: self eventLogSource.
	^eventLogHandle!

openLibraries
	"Private - Open the base set of external libraries (ExternalLibrary>>onStartup must
	open the PermanentLibraries)."

	ExternalLibrary onStartup!

outer
	"Answer the 'outer' value which was passed by the .EXE which started up the image.
	Often this will be an IUnknown pointer, but as far as the default SessionManager is
	concerned it is just an opaque value."

	^startupArgs at: 2!

parseCmdLineFlags
	"Private - Parse the command line flags in order to record user options that might influence tertiary startup."

	cmdLineFlags := Set new.
	self argv
		do: [:each | (each notEmpty and: ['/-' includes: each first]) ifTrue: [cmdLineFlags add: (each copyFrom: 2)]].
	(cmdLineFlags includes: 'Embedding') ifTrue: [flags := flags maskSet: EmbeddingMask]!

popupHelpFile
	self subclassResponsibility!

preStart
	"A hook for user configuration of the starutp - for example the development session
	manager uses this to file in a prestart.st fixup file, if there is one.
	The default is to do nothing."
!

primaryStartup
	"Perform very early startup actions."

	self basicPrimaryStartup!

primQuit: anInteger
	"Private - Terminate Smalltalk immediately with anInteger as the exit code. Graceful termination 
	should be initiated via #exit. The primitive never fails, and never returns."

	<primitive: 113>
	^self primitiveFailed!

primSnapshot: fileName backup: aBoolean type: typeInteger maxObjects: maxInteger
	"Private - Save the current image to fileName, optionally creating a backup of the existing file.

	Primitive failure codes:
		0	- fileName not a String
		1	- Not used
		2	- Unable to open image file
		3	- I/O Error writing image file (try KernelLibrary>>getLastError).
		4	- Insufficient max objects for current image size"

	<primitive: 97>
	^self error: 'Dolphin was unable to save the image.'!

queryEndSession
	"Fire off an event to enquire of observers whether they object to the end of this session.
	If any observer does, then it must set the boolean value argument to the event to false."

	"Implementation Note: We are using an Association here to avoid creating a base-system
	dependency on ValueHolder, and therefore the Value Models package."

	| okToQuit |
	okToQuit := nil -> true.
	self trigger: #queryEndSession: with: okToQuit.
	^okToQuit value!

quit
	"Force a close down of the session with the default exit code (0)"

	self quit: 0!

quit: anInteger
	"Private - Force a close down of the session with the specified exit code."

	self onExit == true ifTrue: [[self primQuit: anInteger] postToInputQueue].
	^false	"cancelled"!

registerConsoleCtrlHandler
	"Private - Associate a control callback with the console for Ctrl-C, etc, events from
	the OS."

	consoleHandler isNil ifTrue: [
		consoleHandler :=  MessageCallback
						receiver: self
						selector: #onConsoleCtrl:
						descriptor: (ExternalDescriptor fromString: 'stdcall: bool dword').
		KernelLibrary default setConsoleCtrlHandler: consoleHandler asParameter add: true]!

registerRunning
	"Private - Register this session as the owner of the image by creating a named Win32 event.
	If we find that we have been beaten to it by a new pretender, then perform SessionManager
	specific action, which could include bowing out, or perhaps brazenly continuing."

	self createSentinel ifTrue: [self allowDuplicate ifFalse: [self primQuit: ERROR_ALREADY_EXISTS]].!

registerServer: server
	"Register the argument as a 'server' object which is handling unsolicited
	requests, e.g. an OLE COM class factory. The presence of registered servers
	prevents the receiver shutting down when run as a headless server."

	self servers add: server!

resourcesLocatorForClass: aClass 
	^FolderRelativeFileLocator basePath: (File composePath: self installationDirectory subPath: 'Resources')!

retire
	"This SessionManager instance is stepping down in favour of a new boy. Perform any
	uninitialisation that might be required."!

saveImage
	"Save an image of the current session so that it may be restored later. The precise operation 
	performed depends on the subclass (e.g. the DevelopmentSessionManager performs the traditional
	image snapshot, but a run-time SessionManager may save some other smaller set of information
	which is not a dump of the entire object memory)."

	self onPreSaveImage.
	[self saveImageDefault] ensure: [self onPostSaveImage]
!

saveImage: name
	"Save an image of the current session to the specified name (generally a file path).
	The precise operation performed (what is saved to where and how) is the responsibility
	of the subclass."

	self onPreSaveImage.
	[self saveImageTo: name] ensure: [self onPostSaveImage]
!

saveImageDefault
	"Save an image of the current session to the default persistant store (whatever that is)."

	^self error: 'Unable to save image'!

saveImageTo: name
	"Save an image of the current session to the persistant store with the specified
	name (whatever that is)."

	^self snapshot: name!

saveSessionState
	"Save down any session state that needs to be preserved and which is not automatically
	preserved by a normal image save. Examples would be externally managed resources
	such as Windows."

	"By default, assume there is no saved state, and do nothing"!

secondaryStartup
	"Perform second stage startup actions which can be done after prestart which
	provides a window to fix startup problems. Try and do things here rather than in 
	primary startup."

	self basicSecondaryStartup.
	self startUI.
	(self respondsTo: #comStartup) ifTrue: [self perform: #comStartup]!

sentinelName
	"Answer the name of the Win32 Event object created to uniquely identify this session
	so that attempts to run additional instances can be detected."

	^(self imageFileName copyReplacing: $\ withObject: $/) asLowercase.!

servers
	"Private - Answer the registry of servers registered with this session."

	servers isNil ifTrue: [servers := SharedIdentitySet new].
	^servers!

serverShutdown
	"Private - Determine if the system is running as a server, and if so, whether
	it should shut down."

	Notification signal: 'Server shutdown request'.
	(self isHeadless and: [self servers isEmpty])
		ifTrue: [self exit]!

sessionId
	"A unique GUID reset at startup; used initially in DevelopmentSessionManager>>commandLineParser to avoid executing deferred actions on a restart"

	^sessionId!

setenv: nameString value: valueString
	"Set the value of the specified environment variable."

	(KernelLibrary default setEnvironmentVariable: nameString lpValue: valueString)
		ifFalse: [KernelLibrary default systemError]!

shutdown
	"Perform shutdown operations before the VM puts out the lights."

	state := 7.		"Second childishness and mere oblivion"
	self basicShutdown
!

snapshot: fileName
	"Private - Save the current image to fileName."

	^self
		primSnapshot: fileName
		backup: false
		type: 0
		maxObjects: nil!

startUI
	"Start up the input loop/message loop (instruct InputState appropriate depending on whether
	this is a GUI or console session)."

	^self subclassResponsibility!

startupArgs
	"Private - Answer two element Array containing the startup arguments that were passed to this
	session."

	^startupArgs!

stderr
	"Answer the standard error stream (a <puttableStream>)."

	^self stdioStreams at: 3!

stderr: aStream
	"Set the standard error stream to the be <puttableStream> argument.
	Generally speaking this is connected to the CRT stderr stream."

	self stdioStreams at: 3 put: aStream!

stdin
	"Answer the standard input stream (a <gettableStream>)."

	^self stdioStreams at: 1!

stdin: inputStream
	"Set the standard input stream to the be <gettableStream> argument."

	self stdioStreams at: 1 put: inputStream!

stdioStreams
	"Private - Answer the 3-element <Array> of <StdioFileStream>s which are the 
	CRT stdin, stdout, and stderr streams, opening the streams if they are not
	currently available."

	stdioStreams isNil ifTrue: [self openConsole].
	^stdioStreams!

stdout
	"Answer the standard output stream (a <puttableStream>)."

	^self stdioStreams at: 2!

stdout: outputStream
	"Set the standard output stream to the be <puttableStream> argument."

	self stdioStreams at: 2 put: outputStream
!

systemDirectory
	"Answer the path of the Windows system directory on the host computer for the current
	session."

	| path len |
	path := File pathBuffer.
	len := KernelLibrary default getSystemDirectory: path uSize: path size.
	^len == 0
		ifTrue: [KernelLibrary default systemError]
		ifFalse: [path leftString: len]!

tertiaryStartup
	"Perform last startup operations before the main process is started - this includes firing the onStartup
	trigger."

	self basicTertiaryStartup!

trace: aString
	"Append aString to the trace device."

	(self traceStream)
		nextPutAll: aString;
		flush!

traceLine: aString
	"Append aString to the trace stream and start a new line."

	(self traceStream)
		nextPutAll: aString;
		cr;
		flush!

traceStream
	"Answer a <puttableStream> onto the session's trace output device."

	^Smalltalk at: #Trace ifAbsent: [DeafObject current]!

unhandledException: anException
	"Private - The unhandled Exception, anException, occurred in the active Process.
	Depending on the user response and the resumability of the exception, either 
	resume or terminate the process.
	Note: The exception response protocol (#resume, #pass, #outer, #exit, etc)
	can only be sent to an Exception inside a handler block (i.e. the second
	argument to BlockClosure>>on:do:)."

	self logError: anException.
	^anException okToContinue
		ifTrue: ["Resume execution" anException]
		ifFalse: [Processor activeProcess terminate]!

unregisterConsoleCtrlHandler
	"Private - Unregister the console control callback."

	consoleHandler isNil ifTrue: [^self].
		KernelLibrary default  setConsoleCtrlHandler: consoleHandler asParameter add: false.
		consoleHandler free.
	consoleHandler := nil!

unregisterServer: server
	"The argument, server, is requesting session termination, as it is no
	longer required. If there are no further services active and the system is only
	running services (i.e. it is a headless app.), then the request is accepted."

	self servers remove: server ifAbsent: [].
	self serverShutdown!

userName
	"Answer the name of the user currently logged on. Signals a Win32Error if
	the request fails"

	| name nameSize |
	name := String new: 256.
	nameSize := DWORD fromInteger: name size.
	(AdvApiLibrary default getUserName: name nSize: nameSize asParameter)
		ifFalse: [AdvApiLibrary default systemError].
	^name leftString: (nameSize asInteger-1)!

versionInfo
	"Answer the <VersionInfo> for this session, extracted from the host executable."

	^VersionInfo forPath: (ExternalLibrary moduleFileName: nil)
!

whatsThis: object 
	self subclassResponsibility!

windowsDirectory
	"Answer the path of the Windows directory on the host computer for the current session. Note
	that under Terminal Server this will be the shared Windows directory, not the per-user
	Windows directory. See MSDN KB281316  for further information."

	| path len |
	path := File pathBuffer.
	len := KernelLibrary default getSystemWindowsDirectory: path uSize: path size.
	len == 0 ifTrue: [^KernelLibrary default systemError].
	^path leftString: len! !
!SessionManager categoriesFor: #allocConsole!operations!private! !
!SessionManager categoriesFor: #allowDuplicate!operations-startup!public! !
!SessionManager categoriesFor: #appIdString!constants!public! !
!SessionManager categoriesFor: #applicationName!constants!public! !
!SessionManager categoriesFor: #applicationShortName!constants!public! !
!SessionManager categoriesFor: #argc!accessing!public! !
!SessionManager categoriesFor: #argv!accessing!public! !
!SessionManager categoriesFor: #argvLegacyOptionsRemoved!accessing!private! !
!SessionManager categoriesFor: #backupOnImageSave!public!testing! !
!SessionManager categoriesFor: #basicPrimaryStartup!operations-startup!public! !
!SessionManager categoriesFor: #basicSecondaryStartup!operations-startup!public! !
!SessionManager categoriesFor: #basicShutdown!operations-shutdown!private! !
!SessionManager categoriesFor: #basicStdioStreams!accessing!private! !
!SessionManager categoriesFor: #basicTertiaryStartup!operations-startup!public! !
!SessionManager categoriesFor: #clearSessionState!operations!public! !
!SessionManager categoriesFor: #closeConsole!operations!public! !
!SessionManager categoriesFor: #closeConsoleStreams!operations!public! !
!SessionManager categoriesFor: #closeEventLog!operations-logging!private! !
!SessionManager categoriesFor: #computerName!accessing!public! !
!SessionManager categoriesFor: #comShutdown!operations-shutdown!private! !
!SessionManager categoriesFor: #createInputState!initializing!private! !
!SessionManager categoriesFor: #createSentinel!operations-startup!private! !
!SessionManager categoriesFor: #defaultResLibPath!constants!public! !
!SessionManager categoriesFor: #defaultResourceLibrary!accessing!private! !
!SessionManager categoriesFor: #embeddedStartup!operations-startup!private! !
!SessionManager categoriesFor: #errorLogExtension!constants!public! !
!SessionManager categoriesFor: #errorLogName!constants!public! !
!SessionManager categoriesFor: #eventLogSource!constants!public! !
!SessionManager categoriesFor: #exit!must not strip!operations-shutdown!public! !
!SessionManager categoriesFor: #exit:!operations-shutdown!public! !
!SessionManager categoriesFor: #forkMain!operations!public! !
!SessionManager categoriesFor: #free!public!realizing/unrealizing! !
!SessionManager categoriesFor: #freeConsole!operations!public! !
!SessionManager categoriesFor: #getCommandLine!accessing!private! !
!SessionManager categoriesFor: #getenv:!accessing!public! !
!SessionManager categoriesFor: #hasActiveServers!private!testing! !
!SessionManager categoriesFor: #imageBase!accessing!public! !
!SessionManager categoriesFor: #imageExtension!constants!private! !
!SessionManager categoriesFor: #imageFileName!accessing!public! !
!SessionManager categoriesFor: #imagePath!accessing!public! !
!SessionManager categoriesFor: #imagePath:!accessing!private! !
!SessionManager categoriesFor: #imageVersion!accessing!public! !
!SessionManager categoriesFor: #imageVersionMajor!accessing!public! !
!SessionManager categoriesFor: #imageVersionMinor!accessing!public! !
!SessionManager categoriesFor: #initialize!initializing!private! !
!SessionManager categoriesFor: #initializeFromSessionManager:!initializing!private! !
!SessionManager categoriesFor: #inputState!accessing!public! !
!SessionManager categoriesFor: #inputState:!accessing!private! !
!SessionManager categoriesFor: #inputStateClass!constants!private! !
!SessionManager categoriesFor: #install!operations!public! !
!SessionManager categoriesFor: #installationDirectory!constants!private! !
!SessionManager categoriesFor: #isBinaryLooseMethodInstallationAllowed!private!testing! !
!SessionManager categoriesFor: #isConsoleApplication!public!testing! !
!SessionManager categoriesFor: #isDebug!public! !
!SessionManager categoriesFor: #isDLL!private!testing! !
!SessionManager categoriesFor: #isEmbedded!public!testing! !
!SessionManager categoriesFor: #isEmbedding!public!testing! !
!SessionManager categoriesFor: #isHeadless!private!testing! !
!SessionManager categoriesFor: #isOAD!accessing!private!product! !
!SessionManager categoriesFor: #isRuntime!public!testing! !
!SessionManager categoriesFor: #keepAlive!idling!public! !
!SessionManager categoriesFor: #logComment:!operations-logging!public! !
!SessionManager categoriesFor: #logError:!operations-logging!public! !
!SessionManager categoriesFor: #logErrorEvent:!operations-logging!public! !
!SessionManager categoriesFor: #logEvent:type:!operations-logging!public! !
!SessionManager categoriesFor: #logInformationEvent:!operations-logging!public! !
!SessionManager categoriesFor: #logSuccessEvent:!operations-logging!public! !
!SessionManager categoriesFor: #logWarningEvent:!operations-logging!public! !
!SessionManager categoriesFor: #main!operations!public! !
!SessionManager categoriesFor: #mainLoopStarted!operations-startup!private! !
!SessionManager categoriesFor: #noVisibleWindows!event handling!private! !
!SessionManager categoriesFor: #onCloseConsole!event handling!private! !
!SessionManager categoriesFor: #onConsoleCtrl:!event handling!private! !
!SessionManager categoriesFor: #onExit!event handling!public! !
!SessionManager categoriesFor: #onPostSaveImage!event handling!private! !
!SessionManager categoriesFor: #onPreSaveImage!event handling!private! !
!SessionManager categoriesFor: #onQueryWindowsShutdown!event handling!public! !
!SessionManager categoriesFor: #onQuit:!event handling!public! !
!SessionManager categoriesFor: #onStartup:!event handling!public! !
!SessionManager categoriesFor: #onUnhandledError:!event handling!public! !
!SessionManager categoriesFor: #onUnhandledNotification:!event handling!public! !
!SessionManager categoriesFor: #onUnhandledWarning:!event handling!public! !
!SessionManager categoriesFor: #onUserBreak!event handling!private! !
!SessionManager categoriesFor: #openConsole!operations!public! !
!SessionManager categoriesFor: #openConsoleStreams!operations!private! !
!SessionManager categoriesFor: #openEventLog!operations-logging!private! !
!SessionManager categoriesFor: #openLibraries!operations-startup!private! !
!SessionManager categoriesFor: #outer!accessing!public! !
!SessionManager categoriesFor: #parseCmdLineFlags!operations-startup!private! !
!SessionManager categoriesFor: #popupHelpFile!constants!public! !
!SessionManager categoriesFor: #preStart!operations-startup!public! !
!SessionManager categoriesFor: #primaryStartup!operations-startup!public! !
!SessionManager categoriesFor: #primQuit:!operations-shutdown!private! !
!SessionManager categoriesFor: #primSnapshot:backup:type:maxObjects:!operations-saving!private! !
!SessionManager categoriesFor: #queryEndSession!event handling!public! !
!SessionManager categoriesFor: #quit!operations-shutdown!public! !
!SessionManager categoriesFor: #quit:!operations-shutdown!private! !
!SessionManager categoriesFor: #registerConsoleCtrlHandler!operations!private! !
!SessionManager categoriesFor: #registerRunning!operations-startup!private! !
!SessionManager categoriesFor: #registerServer:!accessing!public! !
!SessionManager categoriesFor: #resourcesLocatorForClass:!private! !
!SessionManager categoriesFor: #retire!public!uninitializing! !
!SessionManager categoriesFor: #saveImage!operations-saving!public! !
!SessionManager categoriesFor: #saveImage:!operations-saving!public! !
!SessionManager categoriesFor: #saveImageDefault!operations-saving!public! !
!SessionManager categoriesFor: #saveImageTo:!operations-saving!public! !
!SessionManager categoriesFor: #saveSessionState!operations!public! !
!SessionManager categoriesFor: #secondaryStartup!operations-startup!public! !
!SessionManager categoriesFor: #sentinelName!constants!public! !
!SessionManager categoriesFor: #servers!accessing!private! !
!SessionManager categoriesFor: #serverShutdown!operations-shutdown!private! !
!SessionManager categoriesFor: #sessionId!accessing!public! !
!SessionManager categoriesFor: #setenv:value:!accessing!public! !
!SessionManager categoriesFor: #shutdown!operations-shutdown!public! !
!SessionManager categoriesFor: #snapshot:!operations-saving!private! !
!SessionManager categoriesFor: #startUI!operations-startup!public! !
!SessionManager categoriesFor: #startupArgs!accessing!private! !
!SessionManager categoriesFor: #stderr!accessing!public! !
!SessionManager categoriesFor: #stderr:!accessing!public! !
!SessionManager categoriesFor: #stdin!accessing!public! !
!SessionManager categoriesFor: #stdin:!accessing!public! !
!SessionManager categoriesFor: #stdioStreams!accessing!private! !
!SessionManager categoriesFor: #stdout!accessing!public! !
!SessionManager categoriesFor: #stdout:!accessing!public! !
!SessionManager categoriesFor: #systemDirectory!accessing!public! !
!SessionManager categoriesFor: #tertiaryStartup!operations-startup!public! !
!SessionManager categoriesFor: #trace:!operations-logging!public! !
!SessionManager categoriesFor: #traceLine:!operations-logging!public! !
!SessionManager categoriesFor: #traceStream!accessing!operations-logging!public! !
!SessionManager categoriesFor: #unhandledException:!exceptions!private! !
!SessionManager categoriesFor: #unregisterConsoleCtrlHandler!operations!private! !
!SessionManager categoriesFor: #unregisterServer:!accessing!public! !
!SessionManager categoriesFor: #userName!accessing!public! !
!SessionManager categoriesFor: #versionInfo!accessing-version!public! !
!SessionManager categoriesFor: #whatsThis:!commands!public! !
!SessionManager categoriesFor: #windowsDirectory!accessing!public! !

!SessionManager class methodsFor!

asSessionManagerClass
	^self!

current
	"Answer the singleton instance of the receiver"

	^Current!

current: aSessionManager
	"Assign the current SessionManager instance (which will be a subinstance).
	In order to preserve the triggers hanging off the old SessionManager, we
	use a #become:, we also copy across any existing input state so that
	the system continues to run."

	Current isNil
		ifTrue: [Current := aSessionManager. Current initialize]
		ifFalse: [
			aSessionManager
				inputState: Current inputState;
				initialize.
			Current become: aSessionManager]!

imageExtension
	"Answer the suffix for an executable image file"

	^'exe'!

initialize
	"Private - Initialize the class variables of the receiver."

	Current 
		ifNil: 
			[PreStartFile := 'prestart.st'.
			Current := BootSessionManager basicNew.	"For boot reasons, do not initialize"
			Current imagePath: '.\Dolphin']!

inputState
	"Answer the InputState of the current session manager."

	^self current inputState!

installNew
	"Install a new instance of the receiver as the current SessionManager.
	Answer the PREVIOUS SessionManager."

	^self asSessionManagerClass basicNew install!

isConsoleApplication
	"Answer whether the sessions managed by instances of the receiver are for a console application 
	(as opposed to a GUI application, which is a completely separate thing under Windows).
	Implementation Note: This isn't really a console application, but the test is slightly misnamed
	since it really means is this not a GUI application."

	^true!

isDLL
	"Private - Answer whether the receiver is a shared library, as opposed to an application."

	^false!

isRuntime
	"Answer whether the sessions managed by instances of the receiver are for a run-time applications 
	(as opposed to development, or abstract)."

	^false	"This is abstract"!

new
	"The receiver is a singleton class (in general) so this is not a permitted operation
	(see however #installNew)."

	^self shouldNotImplement!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current class==self ifTrue: [Current := nil]! !
!SessionManager class categoriesFor: #asSessionManagerClass!converting!public! !
!SessionManager class categoriesFor: #current!accessing!public! !
!SessionManager class categoriesFor: #current:!accessing!public! !
!SessionManager class categoriesFor: #imageExtension!constants!public! !
!SessionManager class categoriesFor: #initialize!initializing!must strip!private! !
!SessionManager class categoriesFor: #inputState!accessing!public! !
!SessionManager class categoriesFor: #installNew!instance creation!public! !
!SessionManager class categoriesFor: #isConsoleApplication!public!testing! !
!SessionManager class categoriesFor: #isDLL!private!testing! !
!SessionManager class categoriesFor: #isRuntime!public!testing! !
!SessionManager class categoriesFor: #new!instance creation!public! !
!SessionManager class categoriesFor: #uninitialize!class hierarchy-removing!private! !

