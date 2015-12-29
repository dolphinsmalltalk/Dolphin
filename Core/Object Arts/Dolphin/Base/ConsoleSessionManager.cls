"Filed out from Dolphin Smalltalk X6.1"!

SessionManager subclass: #ConsoleSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!
ConsoleSessionManager guid: (GUID fromString: '{B41FEB01-21E0-4AD4-998E-AC8529155BEE}')!
ConsoleSessionManager comment: 'ConsoleSessionManager is the class of <SessionManager>s used to manage the life-cycle of a deployed console, or command-line, application.

The main entry point hook is the #main method. The program logic can be implemented entirely in #main in the case of simple applications, but it is recommended that a separate application class be constructed, with additional support classes as required. A console application normally exits when the #main method returns.

The standard C I/O streams, stdin/stdout/stderr, can be accessed by sending the #stdin, #stdout, and #stderr messages to the session. The resulting streams implement the full Smalltalk Stream protocols, and can be used interchangeably with normal streams. Furthermore these are connected to the actual C runtime library streams of the same name, and so calling C runtime library functions such as printf() (either from within Dolphin, or a DLL called from Dolphin) will result in output to the same console window. Note that these streams (and the console) are actually usable from <GUISessionManager>s too, which is useful for testing and debugging console applications from within the develoopment environment. The class side #run method provides a simple way to fire up a console application in the development environment, although the session manager is not actually installed.

A simple example of a console application is the command line version of the Hello World sample. Try it out be evaluating:

	CommandLineHelloWorld run    "Watch out for the appearance of the console, and press ENTER to continue"
'!
!ConsoleSessionManager categoriesForClass!System-Support! !
!ConsoleSessionManager methodsFor!

allocConsole
	"Private - Open a console for this session."

	"We already have one"!

basicTertiaryStartup
	"Perform fundamental tertiary system startup operations."

	self embeddedStartup!

freeConsole
	"Private - Close (actually detach from) the console for this session.
	In the case of a console app, we didn't allocate the console, so we don't
	free it (even though to do so would be harmless)."

	self assert: [consoleHandler isNil]!

isEmbedded
	"Answer whether the session is running, or should be started, in 'embedded' 
	mode (i.e. headless). This is an embedded session in so far as it has no GUI."

	^true!

logError: anException 
	"Append details about the unhandled exception, anException, to the session error log.
	Ignored for runtime systems, but it is suggested that subclasses perform some appropriate
	form of error logging. The VM crash dump is one such facility (it doesn't cause a crash and
	can be used for generating a VM walkback to the crash dump file at any time)"

	| stderrBad |
	stderrBad := false.
	
	[| target |
	target := self stderr.
	target
		next: 40 put: $-;
		nextPutAll: 'Unhandled exception - '.
	anException printTraceOn: target.
	target
		next: 40 put: $-;
		cr;
		cr] 
			on: Error
			do: [:e | stderrBad := true].

	"If we were unable to write to stderr for some reason, then produce a crash dump"
	(stderrBad or: [false]) ifTrue: [super logError: anException]!

onCloseConsole
	"The user is attempting to close the console window. Act accordingly (by shutting
	down the application)."

	self quit: -1!

openConsoleStreams
	"Private - Open the standard console I/O streams.
	In this case we attach to pre-existing C run-time library stdio streams, as they
	will be correctly set up."

	stdioStreams isNil ifTrue: [ | crt |
		crt := CRTLibrary default.
		stdioStreams := Array new: 3.
		0 to: 2 do: [:i | stdioStreams at: i+1 put: (StdioFileStream fromHandle: (crt getStdHandle: i))]].

	"Note that all the above streams should be in text/translating mode"!

startUI
	"Start up the input loop/message loop (instruct InputState appropriate depending on whether
	this is a GUI or console session)."

	self inputState consoleStartup!

unhandledException: anException
	"Private - The unhandled Exception, anException, occurred in the active Process.
	Depending on the user response and the resumability of the exception, either 
	resume or terminate the process.
	Note: The exception response protocol (#resume, #pass, #outer, #exit, etc)
	can only be sent to an Exception inside a handler block (i.e. the second
	argument to BlockClosure>>on:do:)."

	self logError: anException.
	"Note that unlike a GUI session (which is event driven), we kill the entire session in the event
	  of an unhandled Error. If you are writing a multi-threaded, headless, server then you may 
	  want to override this behaviour to just #terminate the faulting <Process>."
	anException isUserResumable ifFalse: [
		self quit: -1].
	^anException! !
!ConsoleSessionManager categoriesFor: #allocConsole!operations!private! !
!ConsoleSessionManager categoriesFor: #basicTertiaryStartup!operations-startup!public! !
!ConsoleSessionManager categoriesFor: #freeConsole!operations!private! !
!ConsoleSessionManager categoriesFor: #isEmbedded!public!testing! !
!ConsoleSessionManager categoriesFor: #logError:!operations-logging!public! !
!ConsoleSessionManager categoriesFor: #onCloseConsole!event handling!private! !
!ConsoleSessionManager categoriesFor: #openConsoleStreams!operations!public! !
!ConsoleSessionManager categoriesFor: #startUI!operations-startup!public! !
!ConsoleSessionManager categoriesFor: #unhandledException:!exceptions!private! !

!ConsoleSessionManager class methodsFor!

isRuntime
	"Answer whether the sessions managed by instances of the receiver are for a run-time applications 
	(as opposed to development, or abstract)."

	^true!

new
	"Answer a new instance of the receiver. This is permited for ConsoleSessionManagers in order
	to facilitate testing."

	^self basicNew initialize;
		initializeFromSessionManager: self current;
		yourself!

run
	"Test this console program.
		self run
	"
	| consoleAlreadyOpen |

	"As this is used from the development environment, we must make sure that a console has been allocated.
	 If we opened it just for this test, then we want to close it before finishing"
	consoleAlreadyOpen := self current openConsole.
	self new main.
	consoleAlreadyOpen ifFalse: [self current closeConsole]! !
!ConsoleSessionManager class categoriesFor: #isRuntime!public!testing! !
!ConsoleSessionManager class categoriesFor: #new!development!instance creation!public! !
!ConsoleSessionManager class categoriesFor: #run!development!public! !

