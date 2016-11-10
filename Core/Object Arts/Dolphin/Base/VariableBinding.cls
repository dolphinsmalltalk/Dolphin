"Filed out from Dolphin Smalltalk 7"!

Association subclass: #VariableBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VariableBinding guid: (GUID fromString: '{1E72742F-5466-4331-BB39-2FF12AC9743F}')!
VariableBinding comment: ''!
!VariableBinding categoriesForClass!Collections-Support! !
!VariableBinding methodsFor!

displayOn: aStream 
	"Append a short textual description of the receiver to aStream."

	aStream display: key!

displayString
	^key!

icon
	^value icon! !
!VariableBinding categoriesFor: #displayOn:!printing!public! !
!VariableBinding categoriesFor: #displayString!displaying!public! !
!VariableBinding categoriesFor: #icon!constants!public! !

