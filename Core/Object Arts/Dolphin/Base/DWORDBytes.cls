"Filed out from Dolphin Smalltalk X6.1"!

ExternalIntegerBytes variableByteSubclass: #DWORDBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DWORDBytes guid: (GUID fromString: '{87B4C516-026E-11D3-9FD7-00A0CC3E4A32}')!
DWORDBytes comment: ''!
!DWORDBytes categoriesForClass!External-Data-Unstructured! !
!DWORDBytes methodsFor!

asDword
	"Answer the receiver in a form suitable for passing/returning as 
	a 32-bit value."

	^self value!

asInteger
	"Answer the 32-bit unsigned <integer> value of the receiver."

	^self dwordAtOffset: 0!

asSignedInteger
	"Answer the 32-bit, 2's complement, signed <integer> value of the receiver."

	^self sdwordAtOffset: 0!

value: anObject
	"Set the 32-bit unsigned <integer> value stored in the receiver."

	self dwordAtOffset: 0 put: anObject! !
!DWORDBytes categoriesFor: #asDword!converting!public! !
!DWORDBytes categoriesFor: #asInteger!converting!public! !
!DWORDBytes categoriesFor: #asSignedInteger!converting!public! !
!DWORDBytes categoriesFor: #value:!accessing!public! !

!DWORDBytes class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^4
!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^DWORDField!

valueAtAddress: anAddress 
	^anAddress asExternalAddress dwordAtOffset: 0! !
!DWORDBytes class categoriesFor: #elementSize!constants!private! !
!DWORDBytes class categoriesFor: #fieldType!constants!development!private! !
!DWORDBytes class categoriesFor: #valueAtAddress:!helpers!private! !

