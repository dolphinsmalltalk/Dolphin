"Filed out from Dolphin Smalltalk X6"!

RuntimeSessionManager subclass: #CalculatorSessionManager
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CalculatorSessionManager guid: (GUID fromString: '{EAB090FB-D5E2-4975-9CDA-B5A11550DD01}')!
CalculatorSessionManager comment: ''!
!CalculatorSessionManager categoriesForClass!Samples! !
!CalculatorSessionManager methodsFor!

main
	"Start up the Dolphin Calculator sample application"

	self mainShellClass show! !
!CalculatorSessionManager categoriesFor: #main!operations-startup!public! !

!CalculatorSessionManager class methodsFor!

mainShellClass
	"Answer the class of the application's main window (a <Shell> presenter)."

	^Calculator! !
!CalculatorSessionManager class categoriesFor: #mainShellClass!constants!public! !

