"Filed out from Dolphin Smalltalk 7"!

External.IntegerBytes variableByteSubclass: #'External.UIntPtrBytes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UIntPtrBytes guid: (Core.GUID fromString: '{c9f5efed-9b23-441a-b6e4-9a0d3c7282ab}')!
External.UIntPtrBytes comment: ''!
!External.UIntPtrBytes categoriesForClass!External-Data-Unstructured! !
!External.UIntPtrBytes methodsFor!

asInteger
	"Answer the unsigned <integer> value of the receiver."

	^self uintPtrAtOffset: 0!

asSignedInteger
	"Answer the 2's complement, signed <integer> value of the receiver."

	^self intPtrAtOffset: 0!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as 
	anLRESULT (could be 32 or 64-bits, depending on host OS)."

	^self value!

highPart
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [self dwordAtOffset: 4] ifFalse: [self wordAtOffset: 2]!

highPart: anObject 
	"Note: The compiler will optimise out the conditional because it is constant."

	VMConstants.IsWin64 
		ifTrue: [self dwordAtOffset: 4 put: anObject]
		ifFalse: [self wordAtOffset: 2 put: anObject]!

highPartSigned
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [self sdwordAtOffset: 4] ifFalse: [self swordAtOffset: 2]!

lowPart
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [self dwordAtOffset: 0] ifFalse: [self wordAtOffset: 0]!

lowPart: anObject 
	"Note: The compiler will optimise out the conditional because it is constant."

	VMConstants.IsWin64 
		ifTrue: [self dwordAtOffset: 0 put: anObject]
		ifFalse: [self wordAtOffset: 0 put: anObject]!

lowPartSigned
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [self sdwordAtOffset: 0] ifFalse: [self swordAtOffset: 0]!

value: anObject 
	"Set the unsigned <integer> value stored in the receiver."

	self uintPtrAtOffset: 0 put: anObject! !
!External.UIntPtrBytes categoriesFor: #asInteger!converting!public! !
!External.UIntPtrBytes categoriesFor: #asSignedInteger!converting!public! !
!External.UIntPtrBytes categoriesFor: #asUIntPtr!converting!public! !
!External.UIntPtrBytes categoriesFor: #highPart!accessing!public! !
!External.UIntPtrBytes categoriesFor: #highPart:!accessing!public! !
!External.UIntPtrBytes categoriesFor: #highPartSigned!accessing!public! !
!External.UIntPtrBytes categoriesFor: #lowPart!accessing!public! !
!External.UIntPtrBytes categoriesFor: #lowPart:!accessing!public! !
!External.UIntPtrBytes categoriesFor: #lowPartSigned!accessing!public! !
!External.UIntPtrBytes categoriesFor: #value:!accessing!public! !

!External.UIntPtrBytes class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^VMConstants.IntPtrSize!

valueAtAddress: anAddress 
	^anAddress asExternalAddress uintPtrAtOffset: 0! !
!External.UIntPtrBytes class categoriesFor: #elementSize!constants!private! !
!External.UIntPtrBytes class categoriesFor: #valueAtAddress:!instance creation!private! !

