"Filed out from Dolphin Smalltalk"!

External.IntegerBytes
	variableByteSubclass: #'External.UIntPtrBytes'
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

	^VMConstants.IsWin64 ifTrue: [self uint32AtOffset: 4] ifFalse: [self uint16AtOffset: 2]!

highPart: anObject 
	"Note: The compiler will optimise out the conditional because it is constant."

	VMConstants.IsWin64 
		ifTrue: [self uint32AtOffset: 4 put: anObject]
		ifFalse: [self uint16AtOffset: 2 put: anObject]!

highPartSigned
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [self int32AtOffset: 4] ifFalse: [self int16AtOffset: 2]!

lowPart
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [self uint32AtOffset: 0] ifFalse: [self uint16AtOffset: 0]!

lowPart: anObject 
	"Note: The compiler will optimise out the conditional because it is constant."

	VMConstants.IsWin64 
		ifTrue: [self uint32AtOffset: 0 put: anObject]
		ifFalse: [self uint16AtOffset: 0 put: anObject]!

lowPartSigned
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [self int32AtOffset: 0] ifFalse: [self int16AtOffset: 0]!

value: anObject 
	"Set the unsigned <integer> value stored in the receiver."

	self uintPtrAtOffset: 0 put: anObject! !

!External.UIntPtrBytes categoriesForMethods!
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

!External.UIntPtrBytes class methodsFor!

elementSize
	"Private - Answer the size of the receiver's constituent elements in bytes."

	^VMConstants.IntPtrSize!

new
	^self newFixed: VMConstants.IntPtrSize!

valueAtAddress: anAddress 
	^anAddress asExternalAddress uintPtrAtOffset: 0! !

!External.UIntPtrBytes class categoriesForMethods!
elementSize!constants!private! !
new!public! !
valueAtAddress:!instance creation!private! !
!

