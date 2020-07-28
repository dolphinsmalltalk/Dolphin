"Filed out from Dolphin Smalltalk 7"!

ExternalInteger subclass: #QWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_highPart' -> 16r4.
		'_OffsetOf_lowPart' -> 16r0
	}!
QWORD guid: (GUID fromString: '{87b4c60b-026e-11d3-9fd7-00a0cc3e4a32}')!
QWORD comment: '<QWORD> is an abstract superclass for the two Win32 64-bit integer structures, LARGE_INTEGER (signed), and ULARGE_INTEGER (unsigned).

This class of structures is useful for communication with Win32 services that require 64-bit integer parameters. They also provide for easy access to the high and low 32-bit constituents of the integer''s native representation (Intel format 2''s complement).'!
!QWORD categoriesForClass!External-Data-Unstructured! !
!QWORD methodsFor!

asSignedInteger
	"Answer the signed 64-bit <Integer> value of the receiver."

	^bytes sqwordAtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 64-bit <Integer> value of the receiver.
	This can be useful where unsigned values are stored in signed values."

	^bytes qwordAtOffset: 0!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self value displayOn: aPuttableStream!

highPart
	"Answer the <Integer> value of the receiver's 'highPart' field."

	^bytes dwordAtOffset: _OffsetOf_highPart!

highPart: anInteger
	"Set the receiver's 'highPart' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_highPart put: anInteger!

lowPart
	"Answer the <Integer> value of the receiver's 'lowPart' field."

	^bytes dwordAtOffset: _OffsetOf_lowPart!

lowPart: anInteger
	"Set the receiver's 'lowPart' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lowPart put: anInteger!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes qwordAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes qwordAtOffset: _OffsetOf_value put: anInteger! !
!QWORD categoriesFor: #asSignedInteger!converting!public! !
!QWORD categoriesFor: #asUnsignedInteger!converting!public! !
!QWORD categoriesFor: #displayOn:!displaying!public! !
!QWORD categoriesFor: #highPart!**compiled accessors**!public! !
!QWORD categoriesFor: #highPart:!**compiled accessors**!public! !
!QWORD categoriesFor: #lowPart!**compiled accessors**!public! !
!QWORD categoriesFor: #lowPart:!**compiled accessors**!public! !
!QWORD categoriesFor: #value!**compiled accessors**!public! !
!QWORD categoriesFor: #value:!**compiled accessors**!public! !

!QWORD class methodsFor!

defineFields
	"Define the fields of the QWORD/ULARGE_INTEGER 'structure'.

		struct {
			DWORD LowPart;
			DWORD HighPart;
		};

		QWORD compileDefinition
	"

	self
		defineField: #value
			type: QWORDField new beOverride
			offset: 0;
		defineField: #lowPart
			type: DWORDField new
			offset: 0;
		defineField: #highPart
			type: DWORDField new
			offset: 4!

defineTemplate
	"Initialize the receiver class' structure template.

		QWORD compileDefinition.
	"

	super defineTemplate.
	self assert: [self alignment = 8]! !
!QWORD class categoriesFor: #defineFields!public!template definition! !
!QWORD class categoriesFor: #defineTemplate!public!template definition! !

