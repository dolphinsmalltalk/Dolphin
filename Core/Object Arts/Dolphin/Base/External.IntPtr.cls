"Filed out from Dolphin Smalltalk"!

External.UIntPtr subclass: #'External.IntPtr'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_IntPtr_Size' -> 16r4
	}!
External.IntPtr guid: (Core.GUID fromString: '{7454f675-5169-482b-9a37-5fe37154d567}')!
External.IntPtr comment: ''!
!External.IntPtr categoriesForClass!External-Data-Structured! !
!External.IntPtr methodsFor!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

unsignedValue: anUnsigned 
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes uintPtrAtOffset: 0 put: anUnsigned!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes intPtrAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes intPtrAtOffset: _OffsetOf_value put: anInteger! !
!External.IntPtr categoriesForMethods!
isSigned!public!testing! !
unsignedValue:!accessing!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.IntPtr class methodsFor!

byteSize
	^_IntPtr_Size!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: IntPtrField new beOverride! !
!External.IntPtr class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

