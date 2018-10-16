"Filed out from Dolphin Smalltalk 7"!

ExternalInteger subclass: #QWORD
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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

displayOn: aStream
	"Append a text representation of the receiver to aStream."

	aStream nextPutAll: self asString!

highPart
	"Answer the receiver's highPart field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #highPart)!

highPart: anObject 
	"Set the receiver's highPart field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #highPart) put: anObject!

lowPart
	"Answer the receiver's lowPart field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

lowPart: anObject 
	"Set the receiver's lowPart field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

printOn: aStream
	"Append a debug text representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(; display: self; nextPut: $)
! !
!QWORD categoriesFor: #asSignedInteger!converting!public! !
!QWORD categoriesFor: #asUnsignedInteger!converting!public! !
!QWORD categoriesFor: #displayOn:!displaying!public! !
!QWORD categoriesFor: #highPart!**compiled accessors**!public! !
!QWORD categoriesFor: #highPart:!**compiled accessors**!public! !
!QWORD categoriesFor: #lowPart!**compiled accessors**!public! !
!QWORD categoriesFor: #lowPart:!**compiled accessors**!public! !
!QWORD categoriesFor: #printOn:!printing!public! !

!QWORD class methodsFor!

defineFields
	"Define the fields of the QWORD/ULARGE_INTEGER 'structure'.

		struct {
			DWORD LowPart;
			DWORD HighPart;
		};

		QWORD compileDefinition
	"

	super defineFields.
	self
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
	self assert: [self alignment = 8]!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^QWORDField! !
!QWORD class categoriesFor: #defineFields!initializing!public! !
!QWORD class categoriesFor: #defineTemplate!development!initializing!public! !
!QWORD class categoriesFor: #fieldType!constants!development!private! !

