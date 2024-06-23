"Filed out from Dolphin Smalltalk"!

UI.RuntimeSessionManager
	subclass: #'UI.Examples.SlidingBallSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.SlidingBallSessionManager guid: (Core.GUID fromString: '{df9f9b7f-7863-4331-9258-06e55d9fb118}')!

UI.Examples.SlidingBallSessionManager comment: ''!

!UI.Examples.SlidingBallSessionManager methodsFor!

main
	"Start up the sample application"

	self mainShellClass new show! !

!UI.Examples.SlidingBallSessionManager categoriesForMethods!
main!operations-startup!public! !
!

!UI.Examples.SlidingBallSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^SlidingBallDemo! !

!UI.Examples.SlidingBallSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

