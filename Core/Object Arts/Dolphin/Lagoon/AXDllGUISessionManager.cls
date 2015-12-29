"Filed out from Dolphin Smalltalk X6"!

GUISessionManager subclass: #AXDllGUISessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXDllGUISessionManager guid: (GUID fromString: '{93D9B74C-09D3-40CA-BA82-1A819BFCE625}')!
AXDllGUISessionManager comment: 'AXDllSessionManager is the class of <SessionManager>s used to manage the life-cycle of a deployed Active-X/COM component DLL with GUI elements.

Use this class of SessionManager when deploying your Active-X DLL if it opens any windows.'!
!AXDllGUISessionManager categoriesForClass!System-Support! !
!AXDllGUISessionManager methodsFor!

keepAlive
	"We stay alive until the host process unloads us."

	^self!

openConsoleStreams
	"Private - Open the standard console I/O streams."

	"Do nothing - when running as a DLL we cannot assume we have access to the console"

	! !
!AXDllGUISessionManager categoriesFor: #keepAlive!idling!public! !
!AXDllGUISessionManager categoriesFor: #openConsoleStreams!operations!private! !

!AXDllGUISessionManager class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 154 in: ShellLibrary default!

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
!AXDllGUISessionManager class categoriesFor: #icon!constants!development!must strip!public! !
!AXDllGUISessionManager class categoriesFor: #imageExtension!constants!public! !
!AXDllGUISessionManager class categoriesFor: #isDLL!private!testing! !
!AXDllGUISessionManager class categoriesFor: #isRuntime!public!testing! !

