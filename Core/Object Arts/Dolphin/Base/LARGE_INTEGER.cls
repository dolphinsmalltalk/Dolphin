"Filed out from Dolphin Smalltalk 7"!

QWORD subclass: #LARGE_INTEGER
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LARGE_INTEGER guid: (GUID fromString: '{87b4c630-026e-11d3-9fd7-00a0cc3e4a32}')!
LARGE_INTEGER comment: '<LARGE_INTEGER> is an <ExternalStructure> class to wrap the Win32 structure of the same name.

LARGE_INTEGER is used to represent signed 64-bit integers in conjunction with Win32 APIs. 

The range of integer values that can be represented by instances of this class is defined by the interval:
	(-2**63) to: (2**63)-1

'!
!LARGE_INTEGER categoriesForClass!External-Data-Structured-Win32! !
!LARGE_INTEGER methodsFor!

highPart
	"Answer the receiver's highPart field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #highPart)!

highPart: anObject 
	"Set the receiver's highPart field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #highPart) put: anObject!

lowPart
	"Answer the receiver's lowPart field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

lowPart: anObject 
	"Set the receiver's lowPart field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

value
	"Answer the receiver's value field as a Smalltalk object."

	^bytes sqwordAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes sqwordAtOffset: 0 put: anObject! !
!LARGE_INTEGER categoriesFor: #highPart!**compiled accessors**!public! !
!LARGE_INTEGER categoriesFor: #highPart:!**compiled accessors**!public! !
!LARGE_INTEGER categoriesFor: #lowPart!**compiled accessors**!public! !
!LARGE_INTEGER categoriesFor: #lowPart:!**compiled accessors**!public! !
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
		defineField: #lowPart
			type: DWORDField new
			offset: 0;
		defineField: #highPart
			type: DWORDField new
			offset: 4

!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^SQWORDField! !
!LARGE_INTEGER class categoriesFor: #defineFields!initializing!public! !
!LARGE_INTEGER class categoriesFor: #fieldType!constants!development!private! !

