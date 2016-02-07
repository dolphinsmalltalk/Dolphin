"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #EXCEPTION_RECORD
	instanceVariableNames: 'info'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EXCEPTION_RECORD guid: (GUID fromString: '{87B4C5F0-026E-11D3-9FD7-00A0CC3E4A32}')!
EXCEPTION_RECORD comment: 'EXCEPTION_RECORD is an ExternalStructure class to represent the Win32 EXCEPTION_RECORD structure.

EXCEPTION_RECORD is the parameter block passed to structured exception handlers.'!
!EXCEPTION_RECORD categoriesForClass!External-Data-Structured-Win32! !
!EXCEPTION_RECORD methodsFor!

ExceptionAddress
	"Answer the receiver's ExceptionAddress field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #ExceptionAddress)) asExternalAddress!

ExceptionCode
	"Answer the receiver's ExceptionCode field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

ExceptionInformation
	"Answer the receiver's ExceptionInformation field as a Smalltalk object."

	^UINT_PTRArray fromAddress: bytes yourAddress + ##(self offsetOf: #ExceptionInformation) length: 15!

information
	"Answer the receiver's ExceptionInformation as an <Array> of <Integer>."

	info isNil ifTrue: [info := self ExceptionInformation copyFrom: 1 to: self NumberParameters].
	^info!

moduleFileName
	"Answer the file name of the module within which the exception occurred."

	^(MEMORY_BASIC_INFORMATION forAddress: self ExceptionAddress) moduleFileName!

NumberParameters
	"Answer the receiver's NumberParameters field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #NumberParameters)! !
!EXCEPTION_RECORD categoriesFor: #ExceptionAddress!**compiled accessors**!public! !
!EXCEPTION_RECORD categoriesFor: #ExceptionCode!**compiled accessors**!public! !
!EXCEPTION_RECORD categoriesFor: #ExceptionInformation!**compiled accessors**!public! !
!EXCEPTION_RECORD categoriesFor: #information!accessing!public! !
!EXCEPTION_RECORD categoriesFor: #moduleFileName!accessing!public! !
!EXCEPTION_RECORD categoriesFor: #NumberParameters!**compiled accessors**!public! !

!EXCEPTION_RECORD class methodsFor!

defineFields
	"Define the fields of the Win32 EXCEPTION_RECORD structure.

		EXCEPTION_RECORD compileDefinition

		struct {
			DWORD ExceptionCode;
			DWORD ExceptionFlags;
			EXCEPTION_RECORD* ExceptionRecord;
			PVOID ExceptionAddress;
			DWORD NumberParameters;
			ULONG_PTR ExceptionInformation[EXCEPTION_MAXIMUM_PARAMETERS];
		} EXCEPTION_RECORD;"

	self
		defineField: #ExceptionCode type: DWORDField readOnly;
		defineField: #ExceptionFlags type: DWORDField readOnly beUncompiled;
		defineField: #ExceptionRecord type: LPVOIDField filler;
		defineField: #ExceptionAddress type: LPVOIDField readOnly;
		defineField: #NumberParameters type: DWORDField readOnly;
		defineField: #ExceptionInformation
			type: (ArrayField type: UINT_PTRArray length: EXCEPTION_MAXIMUM_PARAMETERS) beReadOnly! !
!EXCEPTION_RECORD class categoriesFor: #defineFields!initializing!public! !

