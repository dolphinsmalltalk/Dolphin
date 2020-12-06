"Filed out from Dolphin Smalltalk 7"!

UI.GUISessionManager subclass: #'UI.RuntimeSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.RuntimeSessionManager guid: (Core.GUID fromString: '{87b4c6dc-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.RuntimeSessionManager comment: 'RuntimeSessionManager is the class of <SessionManager>s used to manage the life-cycle of a deployed graphical application.

The main entry point hook is the #main method, and typically one opens one''s main application window there, processing any command line arguments held in the receiver''s ''argv'' instance variable. See one of the samples such as Notepad for an example.

'!
!UI.RuntimeSessionManager categoriesForClass!System-Support! !
!UI.RuntimeSessionManager methodsFor!

keepAlive
	"The inputState has determined that there are no live windows. If the main application shell
	class performs its own explicit shutdown then do nothing, otherwise pass up to the
	superclass to initiate a potential shutdown."

	| shell |
	shell := self mainShellClass.
	"It is a little confusing that we only defer to the superclass keepAlive implementation if there
	is no shell presenter or view, or if it answers false to #shutdownOnExit. This is because 
	Shell>>onViewDestroyed will explicitly terminate the application if #shutdownOnExit is true.
	Therefore we only need to perform keep-alive processing when there is no explicit shutdown
	on the view being destroyed. SessionManager>>keepAlive will initiate a shutdown if the
	app is not running as a headless server."
	(shell isNil or: [shell shutdownOnExit not]) ifTrue: [super keepAlive]!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^self class mainShellClass! !
!UI.RuntimeSessionManager categoriesFor: #keepAlive!idling!public! !
!UI.RuntimeSessionManager categoriesFor: #mainShellClass!constants!public! !

!UI.RuntimeSessionManager class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^self mainShellClass icon!

isRuntime
	"Answer whether the sessions managed by instances of the receiver are for a run-time applications 
	(as opposed to development, or abstract)."

	^true!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter).
	This should be overridden by subclasses, and would be a subclass responsibility
	method if it were not for the need to support instance based deployment."

	^#{Shell} valueOrNil!

new
	"Private -  Use #createExecutable:"

	self shouldNotImplement! !
!UI.RuntimeSessionManager class categoriesFor: #icon!constants!public! !
!UI.RuntimeSessionManager class categoriesFor: #isRuntime!public!testing! !
!UI.RuntimeSessionManager class categoriesFor: #mainShellClass!constants!public! !
!UI.RuntimeSessionManager class categoriesFor: #new!instance creation!private! !

