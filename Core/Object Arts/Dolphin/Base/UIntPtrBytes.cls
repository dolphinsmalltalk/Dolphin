"Filed out from Dolphin Smalltalk"!

ExternalIntegerBytes variableByteSubclass: #UIntPtrBytes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

UIntPtrBytes guid: (GUID fromString: '{c9f5efed-9b23-441a-b6e4-9a0d3c7282ab}')!

UIntPtrBytes comment: ''!

!UIntPtrBytes categoriesForClass!External-Data-Unstructured! !

!UIntPtrBytes methodsFor!

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

!UIntPtrBytes categoriesForMethods!
asInteger!converting!public! !
asSignedInteger!converting!public! !
asUIntPtr!converting!public! !
highPart!accessing!public! !
highPart:!accessing!public! !
highPartSigned!accessing!public! !
lowPart!accessing!public! !
lowPart:!accessing!public! !
lowPartSigned!accessing!public! !
value:!accessing!public! !
!

!UIntPtrBytes class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^VMConstants.IntPtrSize!

valueAtAddress: anAddress 
	^anAddress asExternalAddress uintPtrAtOffset: 0! !

!UIntPtrBytes class categoriesForMethods!
elementSize!constants!private! !
valueAtAddress:!instance creation!private! !
!

