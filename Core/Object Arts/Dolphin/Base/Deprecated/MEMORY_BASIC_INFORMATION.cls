"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #MEMORY_BASIC_INFORMATION
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_AllocationBase _OffsetOf_AllocationProtect _OffsetOf_BaseAddress _OffsetOf_Protect _OffsetOf_RegionSize _OffsetOf_State _OffsetOf_Type'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MEMORY_BASIC_INFORMATION guid: (GUID fromString: '{87b4c5fe-026e-11d3-9fd7-00a0cc3e4a32}')!

MEMORY_BASIC_INFORMATION addClassConstant: '_OffsetOf_AllocationBase' value: 16r4!
MEMORY_BASIC_INFORMATION addClassConstant: '_OffsetOf_AllocationProtect' value: 16r8!
MEMORY_BASIC_INFORMATION addClassConstant: '_OffsetOf_BaseAddress' value: 16r0!
MEMORY_BASIC_INFORMATION addClassConstant: '_OffsetOf_Protect' value: 16r14!
MEMORY_BASIC_INFORMATION addClassConstant: '_OffsetOf_RegionSize' value: 16rC!
MEMORY_BASIC_INFORMATION addClassConstant: '_OffsetOf_State' value: 16r10!
MEMORY_BASIC_INFORMATION addClassConstant: '_OffsetOf_Type' value: 16r18!

MEMORY_BASIC_INFORMATION comment: ''!

!MEMORY_BASIC_INFORMATION categoriesForClass!Deprecated! !

!MEMORY_BASIC_INFORMATION methodsFor!

AllocationBase
	"Answer the <ExternalAddress> value of the receiver's 'AllocationBase' field."

	^(bytes uintPtrAtOffset: _OffsetOf_AllocationBase) asExternalAddress!

BaseAddress
	"Answer the <ExternalAddress> value of the receiver's 'BaseAddress' field."

	^(bytes uintPtrAtOffset: _OffsetOf_BaseAddress) asExternalAddress!

moduleFileName
	"Answer the filename of the module to which the receiver's region
	maps. Only relevant for text segments."

	^ExternalLibrary moduleFileName: self AllocationBase! !

!MEMORY_BASIC_INFORMATION categoriesForMethods!
AllocationBase!**compiled accessors**!public! !
BaseAddress!**compiled accessors**!public! !
moduleFileName!accessing!public! !
!

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
	^answer!

getFieldNames
	^#(#BaseAddress #AllocationBase #AllocationProtect #RegionSize #State #Protect #Type)! !

!MEMORY_BASIC_INFORMATION class categoriesForMethods!
defineFields!public!template definition! !
forAddress:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

