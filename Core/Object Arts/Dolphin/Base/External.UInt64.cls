"Filed out from Dolphin Smalltalk"!

External.INTEGER
	subclass: #'External.UInt64'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_OffsetOf_highPart' -> 16r4. '_OffsetOf_lowPart' -> 16r0. '_UInt64_Size' -> 16r8 }!

External.UInt64 guid: (Core.GUID fromString: '{87b4c60b-026e-11d3-9fd7-00a0cc3e4a32}')!

External.UInt64 comment: '`UInt64` is an `External.Structure` class to represent unsigned 64-bit integers. 

This class of structures is useful for communication with Win32 services that require 64-bit integer parameters. They also provide for easy access to the high and low 32-bit constituents of the integer''s native representation (Intel format, i.e. little-endian).'!

!External.UInt64 categoriesForClass!External-Data-Unstructured! !

!External.UInt64 methodsFor!

asSignedInteger
	"Answer the signed 64-bit <Integer> value of the receiver."

	^bytes int64AtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 64-bit <Integer> value of the receiver.
	This can be useful where unsigned values are stored in signed values."

	^bytes uint64AtOffset: 0!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self value displayOn: aPuttableStream!

highPart
	"Answer the <Integer> value of the receiver's 'highPart' field."

	^bytes uint32AtOffset: _OffsetOf_highPart!

highPart: anInteger
	"Set the receiver's 'highPart' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_highPart put: anInteger!

lowPart
	"Answer the <Integer> value of the receiver's 'lowPart' field."

	^bytes uint32AtOffset: _OffsetOf_lowPart!

lowPart: anInteger
	"Set the receiver's 'lowPart' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_lowPart put: anInteger!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes uint64AtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes uint64AtOffset: _OffsetOf_value put: anInteger! !

!External.UInt64 categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
displayOn:!displaying!public! !
highPart!**compiled accessors**!public! !
highPart:!**compiled accessors**!public! !
lowPart!**compiled accessors**!public! !
lowPart:!**compiled accessors**!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.UInt64 class methodsFor!

byteSize
	^_UInt64_Size!

defineFields
	"Define the fields of the UInt64 'structure'.

		struct {
			DWORD LowPart;
			DWORD HighPart;
		};

		UInt64 compileDefinition
	"

	self
		defineField: #value
			type: UInt64Field new beOverride
			offset: 0;
		defineField: #lowPart
			type: UInt32Field new
			offset: 0;
		defineField: #highPart
			type: UInt32Field new
			offset: 4! !

!External.UInt64 class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

