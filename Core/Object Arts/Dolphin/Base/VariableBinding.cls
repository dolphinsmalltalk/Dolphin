"Filed out from Dolphin Smalltalk 7"!

Association subclass: #VariableBinding
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
VariableBinding guid: (GUID fromString: '{1e72742f-5466-4331-bb39-2ff12ac9743f}')!
VariableBinding comment: ''!
!VariableBinding categoriesForClass!Collections-Support! !
!VariableBinding methodsFor!

displayOn: aStream 
	"Append a short textual description of the receiver to aStream."

	aStream display: key!

displayString
	^key!

fullName
	"Placeholder for answering fully qualified name (relative to Smalltalk)."
	
	^key!

fullyQualifiedReference
	^self fullName asQualifiedReference!

refersToLiteral: anObject
	^self == anObject!

targetVariable
	^self! !
!VariableBinding categoriesFor: #displayOn:!printing!public! !
!VariableBinding categoriesFor: #displayString!displaying!public! !
!VariableBinding categoriesFor: #fullName!accessing!public! !
!VariableBinding categoriesFor: #fullyQualifiedReference!accessing!public! !
!VariableBinding categoriesFor: #refersToLiteral:!private!testing! !
!VariableBinding categoriesFor: #targetVariable!accessing!public! !

