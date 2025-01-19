"Filed out from Dolphin Smalltalk"!

Core.SessionManager
	subclass: #'Kernel.AXDllSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM})
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.AXDllSessionManager guid: (Core.GUID fromString: '{56681788-e7fe-4454-8973-c3d801c5f034}')!

Kernel.AXDllSessionManager comment: '`AXDllSessionManager` is a class of `SessionManager`s used to manage the life-cycle of a deployed Active-X/COM component DLL that has _no_ GUI elements.

Use this class of `SessionManager` when deploying your COM DLL if it is a non-visual component.'!

!Kernel.AXDllSessionManager methodsFor!

basicTertiaryStartup
	"Perform fundamental tertiary system startup operations."

	self embeddedStartup!

hasActiveServers
	"Private - Answer whether there are any servers still registered in this session."

	"In a DLL session we want to remain alive until explicitly unloaded, so we always respond in the affirmative to block any self initiated shutdown."

	^true!

openConsoleStreams
	"Private - Open the standard console I/O streams."

	"Do nothing - when running as a DLL we cannot assume we have access to the console"

	!

startUI
	"Start up the input loop/message loop (instruct InputState appropriate depending on whether this is a GUI or console session)."

	self inputState consoleStartup!

traceStream
	"Answer a <puttableStream> onto the session's trace output device."

	DebugTraceStream.	"Ensure that debug output is available as this is pretty much essential for DLLs."
	^super traceStream!

unhandledException: anException
	"Private - The unhandled Exception, anException, occurred in the active Process. Depending on the user response and the resumability of the exception, either resume or terminate the process.
	Note: The exception response protocol (#resume, #pass, #outer, #exit, etc) can only be sent to an Exception inside a handler block (i.e. the second argument to BlockClosure>>on:do:)."

	self logError: anException.
	anException isResumable ifFalse: [
		"Note that unlike a GUI session (which is event driven), we kill the entire session in the event of an unhandled unresumable error. If you are writing a multi-threaded server then you may want to override this behaviour to just kill the faulting <Process>."
		self quit: -1].
	"Resume execution"
	^anException! !

!Kernel.AXDllSessionManager categoriesForMethods!
basicTertiaryStartup!operations-startup!public! !
hasActiveServers!private!testing! !
openConsoleStreams!operations!private! !
startUI!operations-startup!public! !
traceStream!accessing!operations-logging!public! !
unhandledException:!exceptions!private! !
!

!Kernel.AXDllSessionManager class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^DynamicLinkLibrary icon!

imageExtension
	"Answer the suffix for an executable image file"

	^'dll'!

isDLL
	"Private - Answer whether the receiver is a shared library, as opposed to an application."

	IPDolphin.	"Ensure IPDolphin included in any deployed DLL"
	^true!

isRuntime
	"Answer whether the sessions managed by instances of the receiver are for a run-time applications (as opposed to development, or abstract)."

	^true! !

!Kernel.AXDllSessionManager class categoriesForMethods!
icon!constants!development!must strip!public! !
imageExtension!constants!public! !
isDLL!private!testing! !
isRuntime!public!testing! !
!

