"Filed out from Dolphin Smalltalk 7"!

Core.SessionManager subclass: #'Kernel.AXDllSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.AXDllSessionManager guid: (Core.GUID fromString: '{56681788-e7fe-4454-8973-c3d801c5f034}')!
Kernel.AXDllSessionManager comment: 'AXDllSessionManager is the class of <SessionManager>s used to manage the life-cycle of a deployed Active-X/COM component DLL that has no GUI elements.

Use this class of SessionManager when deploying your Active-X DLL if it is a non-visual component.'!
!Kernel.AXDllSessionManager categoriesForClass!Unclassified! !
!Kernel.AXDllSessionManager methodsFor!

basicTertiaryStartup
	"Perform fundamental tertiary system startup operations."

	self embeddedStartup!

keepAlive
	"We stay alive until the host process unloads us."

	^self!

openConsoleStreams
	"Private - Open the standard console I/O streams."

	"Do nothing - when running as a DLL we cannot assume we have access to the console"

	!

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
	anException isResumable ifFalse: [
		"Note that unlike a GUI session (which is event driven), we kill the entire session in the event
		  of an unhandled unresumable error. If you are writing a multi-threaded server then you may 
		 want to override this behaviour to just kill the faulting <Process>."
		self quit: -1].
	"Resume execution"
	^anException! !
!Kernel.AXDllSessionManager categoriesFor: #basicTertiaryStartup!operations-startup!public! !
!Kernel.AXDllSessionManager categoriesFor: #keepAlive!idling!public! !
!Kernel.AXDllSessionManager categoriesFor: #openConsoleStreams!operations!private! !
!Kernel.AXDllSessionManager categoriesFor: #startUI!operations-startup!public! !
!Kernel.AXDllSessionManager categoriesFor: #unhandledException:!exceptions!private! !

!Kernel.AXDllSessionManager class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^External.DynamicLinkLibrary icon!

imageExtension
	"Answer the suffix for an executable image file"

	^'dll'!

isDLL
	"Private - Answer whether the receiver is a shared library, as opposed to an application."

	^true!

isRuntime
	"Answer whether the sessions managed by instances of the receiver are for a run-time applications 
	(as opposed to development, or abstract)."

	^true! !
!Kernel.AXDllSessionManager class categoriesFor: #icon!constants!development!must strip!public! !
!Kernel.AXDllSessionManager class categoriesFor: #imageExtension!constants!public! !
!Kernel.AXDllSessionManager class categoriesFor: #isDLL!private!testing! !
!Kernel.AXDllSessionManager class categoriesFor: #isRuntime!public!testing! !

