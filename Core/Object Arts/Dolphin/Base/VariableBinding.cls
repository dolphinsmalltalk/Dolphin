"Filed out from Dolphin Smalltalk"!

Association subclass: #VariableBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

VariableBinding guid: (GUID fromString: '{1e72742f-5466-4331-bb39-2ff12ac9743f}')!

VariableBinding comment: ''!

!VariableBinding categoriesForClass!Collections-Support! !

!VariableBinding methodsFor!

displayOn: aStream 
	"Append a short textual description of the receiver to aStream."

	aStream display: key!

displayString
	^key!

refersToLiteral: anObject
	^self == anObject! !

!VariableBinding categoriesForMethods!
displayOn:!printing!public! !
displayString!displaying!public! !
refersToLiteral:!private!testing! !
!

