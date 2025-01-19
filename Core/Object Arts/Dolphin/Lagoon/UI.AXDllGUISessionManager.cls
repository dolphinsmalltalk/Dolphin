"Filed out from Dolphin Smalltalk"!

UI.GUISessionManager
	subclass: #'UI.AXDllGUISessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.AXDllGUISessionManager guid: (Core.GUID fromString: '{93d9b74c-09d3-40ca-ba82-1a819bfce625}')!

UI.AXDllGUISessionManager comment: '`AXDllGUISessionManager` is a class of `GUISessionManager`s used to manage the life-cycle of a deployed Active-X/COM component DLL _with_ GUI elements.

Use this class of `SessionManager` when deploying your COM DLL if it opens any windows.'!

!UI.AXDllGUISessionManager categoriesForClass!System-Support! !

!UI.AXDllGUISessionManager methodsFor!

hasActiveServers
	"Private - Answer whether there are any servers still registered in this session."

	"In a DLL session we want to remain alive until explicitly unloaded, so we always respond in the affirmative to block any self initiated shutdown."

	^true!

openConsoleStreams
	"Private - Open the standard console I/O streams."

	"Do nothing - when running as a DLL we cannot assume we have access to the console"

	!

traceStream
	"Answer a <puttableStream> onto the session's trace output device."

	DebugTraceStream.	"Ensure that debug output is available as this is pretty much essential for DLLs."
	^super traceStream! !

!UI.AXDllGUISessionManager categoriesForMethods!
hasActiveServers!private!testing! !
openConsoleStreams!operations!private! !
traceStream!accessing!operations-logging!public! !
!

!UI.AXDllGUISessionManager class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^External.DynamicLinkLibrary icon!

imageExtension
	"Answer the suffix for an executable image file"

	^'dll'!

isDLL
	"Private - Answer whether the receiver is a shared library, as opposed to an application."

	IPDolphin.	"Ensure IPDolphin included in any deployed DLL"
	^true!

isRuntime
	"Answer whether the sessions managed by instances of the receiver are for a run-time applications 
	(as opposed to development, or abstract)."

	^true! !

!UI.AXDllGUISessionManager class categoriesForMethods!
icon!constants!development!must strip!public! !
imageExtension!constants!public! !
isDLL!private!testing! !
isRuntime!public!testing! !
!

