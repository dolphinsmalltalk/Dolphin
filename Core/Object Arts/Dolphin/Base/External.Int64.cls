"Filed out from Dolphin Smalltalk"!

External.UInt64
	subclass: #'External.Int64'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_Int64_Size' -> 16r8 }!

External.Int64 guid: (Core.GUID fromString: '{87b4c630-026e-11d3-9fd7-00a0cc3e4a32}')!

External.Int64 comment: '`Int64` is an `External.Structure` class to represent signed 64-bit integers. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**63) to: (2**63)-1

'!

!External.Int64 categoriesForClass!External-Data-Unstructured! !

!External.Int64 methodsFor!

highPart
	"Answer the <Integer> value of the receiver's 'highPart' field."

	^bytes int32AtOffset: _OffsetOf_highPart!

highPart: anInteger
	"Set the receiver's 'highPart' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_highPart put: anInteger!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes int64AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes int64AtOffset: _OffsetOf_value put: anInteger! !

!External.Int64 categoriesForMethods!
highPart!**compiled accessors**!public! !
highPart:!**compiled accessors**!public! !
isSigned!public!testing! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.Int64 class methodsFor!

byteSize
	^_Int64_Size!

defineFields
	"Define the fields of the Int64 'structure'.

		struct {
			DWORD LowPart;
			LONG HighPart;
		};

		Int64 compileDefinition
	"

	super defineFields.
	self
		defineField: #value
			type: Int64Field new beOverride
			offset: 0;
		defineField: #highPart
			type: Int32Field new beOverride
			offset: 4! !

!External.Int64 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

