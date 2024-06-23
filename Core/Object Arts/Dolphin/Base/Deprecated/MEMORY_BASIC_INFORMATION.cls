"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #MEMORY_BASIC_INFORMATION
	instanceVariableNames: ''
	classVariableNames: '_MEMORY_BASIC_INFORMATION_Size _OffsetOf_AllocationBase _OffsetOf_AllocationProtect _OffsetOf_BaseAddress _OffsetOf_Protect _OffsetOf_RegionSize _OffsetOf_State _OffsetOf_Type'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MEMORY_BASIC_INFORMATION guid: (GUID fromString: '{87b4c5fe-026e-11d3-9fd7-00a0cc3e4a32}')!

MEMORY_BASIC_INFORMATION addClassConstant: '_MEMORY_BASIC_INFORMATION_Size' value: 16r1C!
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

moduleFileName
	"Answer the filename of the module to which the receiver's region
	maps. Only relevant for text segments."

	^ExternalLibrary moduleFileName: self AllocationBase! !

!MEMORY_BASIC_INFORMATION categoriesForMethods!
moduleFileName!accessing!public! !
!

!MEMORY_BASIC_INFORMATION class methodsFor!

byteSize
	^_MEMORY_BASIC_INFORMATION_Size!

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
		beUncompiled;
		defineField: #BaseAddress type: LPVOIDField readOnly;
		defineField: #AllocationBase type: LPVOIDField readOnly;
		defineField: #AllocationProtect type: UInt32Field readOnly;
		defineField: #RegionSize type: UInt32Field readOnly;
		defineField: #State type: UInt32Field readOnly;
		defineField: #Protect type: UInt32Field readOnly;
		defineField: #Type type: UInt32Field readOnly!

forAddress: anAddress
	"Answer a new instance of the receiver describing the memory region
	in which anAddress resides."

	| answer |
	answer := self new.
	Kernel32
		virtualQuery: anAddress
		lpBuffer: answer
		dwLength: answer size.
	^answer!

getFieldNames
	^#(#BaseAddress #AllocationBase #AllocationProtect #RegionSize #State #Protect #Type)! !

!MEMORY_BASIC_INFORMATION class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
forAddress:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

