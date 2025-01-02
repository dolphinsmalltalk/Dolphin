"Filed out from Dolphin Smalltalk"!

UI.GUISessionManager
	subclass: #'UI.AXDllGUISessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.AXDllGUISessionManager guid: (Core.GUID fromString: '{93d9b74c-09d3-40ca-ba82-1a819bfce625}')!

UI.AXDllGUISessionManager comment: '`AXDllSessionManager` is a class of `SessionManager`s used to manage the life-cycle of a deployed Active-X/COM component DLL _with_ GUI elements.

Use this class of `SessionManager` when deploying your Active-X DLL if it opens any windows.'!

!UI.AXDllGUISessionManager categoriesForClass!System-Support! !

!UI.AXDllGUISessionManager methodsFor!

keepAlive
	"We stay alive until the host process unloads us."

	IPDolphin.	"Ensure IPDolphin included in any deployed DLL"
	^self!

openConsoleStreams
	"Private - Open the standard console I/O streams."

	"Do nothing - when running as a DLL we cannot assume we have access to the console"

	! !

!UI.AXDllGUISessionManager categoriesForMethods!
keepAlive!idling!public! !
openConsoleStreams!operations!private! !
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

