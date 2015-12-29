"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #MEMORY_BASIC_INFORMATION
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MEMORY_BASIC_INFORMATION guid: (GUID fromString: '{87B4C5FE-026E-11D3-9FD7-00A0CC3E4A32}')!
MEMORY_BASIC_INFORMATION comment: ''!
!MEMORY_BASIC_INFORMATION categoriesForClass!External-Data-Structured-Win32! !
!MEMORY_BASIC_INFORMATION methodsFor!

AllocationBase
	"Answer the receiver's AllocationBase field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #AllocationBase)) asExternalAddress!

BaseAddress
	"Answer the receiver's BaseAddress field as a Smalltalk object."

	^(bytes uintPtrAtOffset: 0) asExternalAddress!

moduleFileName
	"Answer the filename of the module to which the receiver's region
	maps. Only relevant for text segments."

	^ExternalLibrary moduleFileName: self AllocationBase! !
!MEMORY_BASIC_INFORMATION categoriesFor: #AllocationBase!**compiled accessors**!public! !
!MEMORY_BASIC_INFORMATION categoriesFor: #BaseAddress!**compiled accessors**!public! !
!MEMORY_BASIC_INFORMATION categoriesFor: #moduleFileName!accessing!public! !

!MEMORY_BASIC_INFORMATION class methodsFor!

defineFields
	"Define the fields of the Win32 MEMORY_BASIC_INFORMATION structure.

		MEMORY_BASIC_INFORMATION compileDefinition

		struct {
			PVOID BaseAddress;
			PVOID AllocationBase;
			DWORD AllocationProtect;
			DWORD RegionSize;
			DWORD State;
			DWORD Protect;
			DWORD Type;
		} MEMORY_BASIC_INFORMATION;"

	self 
		defineField: #BaseAddress		type: LPVOIDField readOnly;
		defineField: #AllocationBase		type: LPVOIDField readOnly;
		beUncompiled;
		defineField: #AllocationProtect	type: DWORDField readOnly;
		defineField: #RegionSize		type: DWORDField readOnly;
		defineField: #State				type: DWORDField readOnly;
		defineField: #Protect			type: DWORDField readOnly;
		defineField: #Type				type: DWORDField readOnly		
		

!

forAddress: anAddress
	"Answer a new instance of the receiver describing the memory region
	in which anAddress resides."

	| answer |
	answer := self new.
	KernelLibrary default virtualQuery: anAddress lpBuffer: answer dwLength: answer size.
	^answer! !
!MEMORY_BASIC_INFORMATION class categoriesFor: #defineFields!initializing!public! !
!MEMORY_BASIC_INFORMATION class categoriesFor: #forAddress:!instance creation!public! !

