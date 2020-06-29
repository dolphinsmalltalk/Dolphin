"Filed out from Dolphin Smalltalk 7"!

QWORD subclass: #LARGE_INTEGER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LARGE_INTEGER guid: (GUID fromString: '{87b4c630-026e-11d3-9fd7-00a0cc3e4a32}')!
LARGE_INTEGER comment: '<LARGE_INTEGER> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

LARGE_INTEGER is used to represent signed 64-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**63) to: (2**63)-1

'!
!LARGE_INTEGER categoriesForClass!External-Data-Unstructured! !
!LARGE_INTEGER methodsFor!

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
!LARGE_INTEGER categoriesFor: #highPart!**compiled accessors**!public! !
!LARGE_INTEGER categoriesFor: #highPart:!**compiled accessors**!public! !
!LARGE_INTEGER categoriesFor: #isSigned!public!testing! !
!LARGE_INTEGER categoriesFor: #value!**compiled accessors**!public! !
!LARGE_INTEGER categoriesFor: #value:!**compiled accessors**!public! !

!LARGE_INTEGER class methodsFor!

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
!LARGE_INTEGER class categoriesFor: #defineFields!public!template definition! !

