"Filed out from Dolphin Smalltalk"!

RuntimeSessionManager subclass: #CalculatorSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CalculatorSessionManager guid: (GUID fromString: '{eab090fb-d5e2-4975-9cda-b5a11550dd01}')!
CalculatorSessionManager comment: ''!
!CalculatorSessionManager categoriesForClass!Samples! !
!CalculatorSessionManager methodsFor!

main
	"Start up the Dolphin Calculator sample application"

	self mainShellClass show! !
!CalculatorSessionManager categoriesForMethods!
main!operations-startup!public! !
!

!CalculatorSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Calculator! !
!CalculatorSessionManager class categoriesForMethods!
mainShellClass!constants!public! !
!

