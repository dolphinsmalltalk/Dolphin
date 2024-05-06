"Filed out from Dolphin Smalltalk"!

SessionManager subclass: #ConsoleSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!

ConsoleSessionManager guid: (GUID fromString: '{b41feb01-21e0-4ad4-998e-ac8529155bee}')!

ConsoleSessionManager isAbstract: true!

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

attachFd: anInteger stream: anExternalHandle
	^((CRTLibrary default _isatty: anInteger)
		ifTrue: [self consoleStreamClass]
		ifFalse: [self fileStreamClass]) fromHandle: anExternalHandle!

basicTertiaryStartup
	"Perform fundamental tertiary system startup operations."

	self embeddedStartup!

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

openStdErr
	^StdioUtf8FileStream fromHandle: VMLibrary default stderr!

openStdIn
	^self attachFd: 0 stream: VMLibrary default stdin!

openStdOut
	^self attachFd: 1 stream: VMLibrary default stdout!

quit: anInteger
	"Private - Force a close down of the session with the specified exit code."

	self onExit == true ifTrue: [self primQuit: anInteger].
	^false	"cancelled"!

registerConsoleCtrlHandler
	#todo "Rather ironically, registering a console ctrl handler does not work very well in a console app any more.  The signal is delivered on a background thread, which the Dolphin VM will marshal across the to main 	thread by sending it via the message queue. In a typical console application that is not going idle, the  signal will not be received.
	One way to solve this would be to add a console control handler to the VM and send through the events to the image using the interrupt mechanism. In the meantime, don't register a handler so that Ctrl+C will perform the default action and above the app."
!

startUI
	"Start up the input loop/message loop (instruct InputState appropriate depending on whether
	this is a GUI or console session)."

	self inputState consoleStartup!

traceStream
	"Answer a <puttableStream> onto the session's trace output device."

	^self stderr!

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

!ConsoleSessionManager categoriesForMethods!
allocConsole!operations!private! !
attachFd:stream:!helpers!private! !
basicTertiaryStartup!operations-startup!public! !
isEmbedded!public!testing! !
logError:!operations-logging!public! !
onCloseConsole!event handling!private! !
openStdErr!helpers!private! !
openStdIn!helpers!private! !
openStdOut!helpers!private! !
quit:!operations-shutdown!private! !
registerConsoleCtrlHandler!operations!private! !
startUI!operations-startup!public! !
traceStream!accessing!operations-logging!public! !
unhandledException:!exceptions!private! !
!

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

!ConsoleSessionManager class categoriesForMethods!
isRuntime!public!testing! !
new!development!instance creation!public! !
run!development!public! !
!

