"Filed out from Dolphin Smalltalk"!

UI.RuntimeSessionManager
	subclass: #'UI.Examples.CalculatorSessionManager'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Examples.CalculatorSessionManager guid: (Core.GUID fromString: '{eab090fb-d5e2-4975-9cda-b5a11550dd01}')!

UI.Examples.CalculatorSessionManager comment: ''!

!UI.Examples.CalculatorSessionManager categoriesForClass!Samples! !

!UI.Examples.CalculatorSessionManager methodsFor!

main
	"Start up the Dolphin Calculator sample application"

	self mainShellClass show! !

!UI.Examples.CalculatorSessionManager categoriesForMethods!
main!operations-startup!public! !
!

!UI.Examples.CalculatorSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Calculator! !

!UI.Examples.CalculatorSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

