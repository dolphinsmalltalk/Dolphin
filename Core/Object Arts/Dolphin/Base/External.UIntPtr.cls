"Filed out from Dolphin Smalltalk"!

External.AbstractIntPtr
	subclass: #'External.UIntPtr'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_UIntPtr_Size' -> 16r4 }!

External.UIntPtr guid: (Core.GUID fromString: '{5b2efc4b-7560-43b0-930f-70dc94f37d05}')!

External.UIntPtr comment: ''!

!External.UIntPtr categoriesForClass!External-Data-Structured-Win32! !

!External.UIntPtr methodsFor!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes uintPtrAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_value put: anInteger! !

!External.UIntPtr categoriesForMethods!
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.UIntPtr class methodsFor!

byteSize
	^_UIntPtr_Size!

defineFields
	"Define the fields of the UIntPtr structure.
		UIntPtr compileDefinition
	"

	self defineField: #value type: UIntPtrField new beOverride! !

!External.UIntPtr class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

