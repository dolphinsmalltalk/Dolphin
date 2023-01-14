"Filed out from Dolphin Smalltalk"!

External.QWORD subclass: #'OS.LARGE_INTEGER'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_LARGE_INTEGER_Size' -> 16r8
	}!
OS.LARGE_INTEGER guid: (Core.GUID fromString: '{87b4c630-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.LARGE_INTEGER comment: '<LARGE_INTEGER> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

LARGE_INTEGER is used to represent signed 64-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**63) to: (2**63)-1

'!
!OS.LARGE_INTEGER categoriesForClass!External-Data-Unstructured! !
!OS.LARGE_INTEGER methodsFor!

highPart
	"Answer the <Integer> value of the receiver's 'highPart' field."

	^bytes sdwordAtOffset: _OffsetOf_highPart!

highPart: anInteger
	"Set the receiver's 'highPart' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_highPart put: anInteger!

isSigned
	"Answer whether the receiver holds a signed 2's complement binary value, as opposed to an unsigned binary value."

	^true!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes sqwordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes sqwordAtOffset: _OffsetOf_value put: anInteger! !
!OS.LARGE_INTEGER categoriesForMethods!
highPart!**compiled accessors**!public! !
highPart:!**compiled accessors**!public! !
isSigned!public!testing! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!OS.LARGE_INTEGER class methodsFor!

byteSize
	^_LARGE_INTEGER_Size!

defineFields
	"Define the fields of the LARGE_INTEGER 'structure'.

		struct {
			DWORD LowPart;
			LONG HighPart;
		};

		LARGE_INTEGER compileDefinition
	"

	super defineFields.
	self
		defineField: #value
			type: SQWORDField new beOverride
			offset: 0;
		defineField: #highPart
			type: SDWORDField new beOverride
			offset: 4! !
!OS.LARGE_INTEGER class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

