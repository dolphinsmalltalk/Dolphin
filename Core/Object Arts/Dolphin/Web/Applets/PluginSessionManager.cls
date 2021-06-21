"Filed out from Dolphin Smalltalk 7"!

GUISessionManager subclass: #PluginSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PluginSessionManager guid: (GUID fromString: '{ccb8756e-6c2e-11d3-bdd5-004005a6900b}')!
PluginSessionManager comment: 'A PluginSessionManager is used as the current SessionManager while Dolphin is running within a web browser.  It keeps Dolphin alive even when all the views are closed, relying on the internet browser to inform us of when we can safely close down.

'!
!PluginSessionManager categoriesForClass!Plugin-Support! !
!PluginSessionManager methodsFor!

applicationName
	"Answer the application name."

	^'Dolphin Applet Plugin'!

defaultResLibPath
	"Answer the path of the default resource library to use with the receiver. "

	^'DolphinVM006'!

initializeFromSessionManager: oldSessionManager
    "Private - The receiver has taken over as the current session
	manager from oldSessionManager. This is an opportunity to transfer
	state information from the replaced manager."

	super initializeFromSessionManager: oldSessionManager.
	Smalltalk at: #ResourceAccessor ifPresent: [:ra | ra ensureAccessorsAreInternal]
!

keepAlive
	"The inputState has determined that there are no live windows. We sit
	quietly until the internet browser says we are excused."

	^self!

primaryStartup
	"Private - Perform very early startup actions.
	We throw away any of the source references as they will not be available now."

	super primaryStartup.
	NPDolphin current	"Ensure plug exists"! !
!PluginSessionManager categoriesFor: #applicationName!constants!public! !
!PluginSessionManager categoriesFor: #defaultResLibPath!constants!public! !
!PluginSessionManager categoriesFor: #initializeFromSessionManager:!initializing!private! !
!PluginSessionManager categoriesFor: #keepAlive!idling!public! !
!PluginSessionManager categoriesFor: #primaryStartup!operations-startup!private! !

!PluginSessionManager class methodsFor!

imageExtension
	"Answer the suffix for an executable image file"

	^'dll'!

isDLL
	"Private - Answer whether the receiver is a shared library, as opposed to an application."

	^true!

isRuntime
	"Answer whether the sessions managed by instances of the receiver are for a run-time application 
	(as opposed to development, or abstract)."

	^true! !
!PluginSessionManager class categoriesFor: #imageExtension!constants!public! !
!PluginSessionManager class categoriesFor: #isDLL!private!testing! !
!PluginSessionManager class categoriesFor: #isRuntime!public!testing! !

