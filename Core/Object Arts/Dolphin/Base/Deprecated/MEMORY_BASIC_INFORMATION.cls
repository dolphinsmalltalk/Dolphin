"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #MEMORY_BASIC_INFORMATION
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_AllocationBase' -> 16r4.
		'_OffsetOf_AllocationProtect' -> 16r8.
		'_OffsetOf_BaseAddress' -> 16r0.
		'_OffsetOf_Protect' -> 16r14.
		'_OffsetOf_RegionSize' -> 16rC.
		'_OffsetOf_State' -> 16r10.
		'_OffsetOf_Type' -> 16r18
	}!
MEMORY_BASIC_INFORMATION guid: (Core.GUID fromString: '{87b4c5fe-026e-11d3-9fd7-00a0cc3e4a32}')!
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
		defineField: #BaseAddress type: LPVOIDField readOnly;
		defineField: #AllocationBase type: LPVOIDField readOnly;
		beUncompiled;
		defineField: #AllocationProtect type: DWORDField readOnly;
		defineField: #RegionSize type: DWORDField readOnly;
		defineField: #State type: DWORDField readOnly;
		defineField: #Protect type: DWORDField readOnly;
		defineField: #Type type: DWORDField readOnly!

forAddress: anAddress
	"Answer a new instance of the receiver describing the memory region
	in which anAddress resides."

	| answer |
	answer := self new.
	KernelLibrary default
		virtualQuery: anAddress
		lpBuffer: answer
		dwLength: answer size.
	^answer!

getFieldNames
	^#(#BaseAddress #AllocationBase #AllocationProtect #RegionSize #State #Protect #Type)! !
!MEMORY_BASIC_INFORMATION class categoriesFor: #defineFields!public!template definition! !
!MEMORY_BASIC_INFORMATION class categoriesFor: #forAddress:!instance creation!public! !
!MEMORY_BASIC_INFORMATION class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

