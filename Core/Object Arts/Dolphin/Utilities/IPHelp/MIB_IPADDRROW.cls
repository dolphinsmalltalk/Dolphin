"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #MIB_IPADDRROW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwAddr _OffsetOf_dwBCastAddr _OffsetOf_dwIndex _OffsetOf_dwMask _OffsetOf_dwReasmSize _OffsetOf_Unused1 _OffsetOf_wType'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IPADDRROW guid: (GUID fromString: '{6b58a372-62e2-40b7-861b-d91fe418bacf}')!
MIB_IPADDRROW addClassConstant: '_OffsetOf_dwAddr' value: 16r0!
MIB_IPADDRROW addClassConstant: '_OffsetOf_dwBCastAddr' value: 16rC!
MIB_IPADDRROW addClassConstant: '_OffsetOf_dwIndex' value: 16r4!
MIB_IPADDRROW addClassConstant: '_OffsetOf_dwMask' value: 16r8!
MIB_IPADDRROW addClassConstant: '_OffsetOf_dwReasmSize' value: 16r10!
MIB_IPADDRROW addClassConstant: '_OffsetOf_Unused1' value: 16r14!
MIB_IPADDRROW addClassConstant: '_OffsetOf_wType' value: 16r16!
MIB_IPADDRROW comment: '<MIB_IPADDRROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPADDRROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IPADDRROW {
	unsigned long dwAddr;
	unsigned long dwIndex;
	unsigned long dwMask;
	unsigned long dwBCastAddr;
	unsigned long dwReasmSize;
	unsigned short Unused1;
	unsigned short wType;
} MIB_IPADDRROW;
'!
!MIB_IPADDRROW categoriesForClass!Win32-Structs! !
!MIB_IPADDRROW methodsFor!

dwAddr
	"Answer the <Integer> value of the receiver's 'dwAddr' field."

	^bytes dwordAtOffset: _OffsetOf_dwAddr!

dwBCastAddr
	"Answer the <Integer> value of the receiver's 'dwBCastAddr' field."

	^bytes dwordAtOffset: _OffsetOf_dwBCastAddr!

dwIndex
	"Answer the <Integer> value of the receiver's 'dwIndex' field."

	^bytes dwordAtOffset: _OffsetOf_dwIndex!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes dwordAtOffset: _OffsetOf_dwMask!

dwReasmSize
	"Answer the <Integer> value of the receiver's 'dwReasmSize' field."

	^bytes dwordAtOffset: _OffsetOf_dwReasmSize!

wType
	"Answer the <Integer> value of the receiver's 'wType' field."

	^bytes wordAtOffset: _OffsetOf_wType! !
!MIB_IPADDRROW categoriesForMethods!
dwAddr!**compiled accessors**!public! !
dwBCastAddr!**compiled accessors**!public! !
dwIndex!**compiled accessors**!public! !
dwMask!**compiled accessors**!public! !
dwReasmSize!**compiled accessors**!public! !
wType!**compiled accessors**!public! !
!

!MIB_IPADDRROW class methodsFor!

defineFields
	"Define the fields of the MIB_IPADDRROW structure.
		MIB_IPADDRROW compileDefinition
	
		typedef 
		struct tagMIB_IPADDRROW {
			unsigned long dwAddr;
			unsigned long dwIndex;
			unsigned long dwMask;
			unsigned long dwBCastAddr;
			unsigned long dwReasmSize;
			unsigned short Unused1;
			unsigned short wType;
		} MIB_IPADDRROW;
"

	self
		defineField: #dwAddr
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwIndex
			type: DWORDField readOnly
			offset: 4;
		defineField: #dwMask
			type: DWORDField readOnly
			offset: 8;
		defineField: #dwBCastAddr
			type: DWORDField readOnly
			offset: 12;
		defineField: #dwReasmSize
			type: DWORDField readOnly
			offset: 16;
		defineField: #Unused1
			type: WORDField filler
			offset: 20;
		defineField: #wType
			type: WORDField readOnly
			offset: 22.
	self byteSize: 24!

getFieldNames
	^#(#dwAddr #dwIndex #dwMask #dwBCastAddr #dwReasmSize #wType)! !
!MIB_IPADDRROW class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

