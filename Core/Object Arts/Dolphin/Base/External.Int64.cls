"Filed out from Dolphin Smalltalk"!

External.AbstractInt64
	subclass: #'External.Int64'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_Int64_Size' -> 16r8.
			'_OffsetOf_highPart' -> 16r4.
			'_OffsetOf_lowPart' -> 16r0.
			'MaxValue' -> 16r7FFFFFFFFFFFFFFF.
			'MinValue' -> -16r8000000000000000
		}!

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

lowPart
	"Answer the <Integer> value of the receiver's 'lowPart' field."

	^bytes uint32AtOffset: _OffsetOf_lowPart!

lowPart: anInteger
	"Set the receiver's 'lowPart' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lowPart put: anInteger!

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
lowPart!**compiled accessors**!public! !
lowPart:!**compiled accessors**!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.Int64 class methodsFor!

defineFields
	"Define the fields of the Int64 'structure'.

		struct {
			DWORD LowPart;
			LONG HighPart;
		};

		Int64 compileDefinition
	"

	self
		defineField: #value
			type: Int64Field new beOverride
			offset: 0;
		defineField: #lowPart
			type: UInt32Field new
			offset: 0;
		defineField: #highPart
			type: Int32Field new beOverride
			offset: 4! !

!External.Int64 class categoriesForMethods!
defineFields!public!template definition! !
!

