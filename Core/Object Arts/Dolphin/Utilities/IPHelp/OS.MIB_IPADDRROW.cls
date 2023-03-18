"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.MIB_IPADDRROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_MIB_IPADDRROW_Size' -> 16r18.
		'_OffsetOf_dwAddr' -> 16r0.
		'_OffsetOf_dwBCastAddr' -> 16rC.
		'_OffsetOf_dwIndex' -> 16r4.
		'_OffsetOf_dwMask' -> 16r8.
		'_OffsetOf_dwReasmSize' -> 16r10.
		'_OffsetOf_Unused1' -> 16r14.
		'_OffsetOf_wType' -> 16r16
	}!
OS.MIB_IPADDRROW guid: (Core.GUID fromString: '{6b58a372-62e2-40b7-861b-d91fe418bacf}')!
OS.MIB_IPADDRROW comment: '<MIB_IPADDRROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPADDRROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.MIB_IPADDRROW categoriesForClass!Win32-Structs! !
!OS.MIB_IPADDRROW methodsFor!

dwAddr
	"Answer the <Integer> value of the receiver's 'dwAddr' field."

	^bytes uint32AtOffset: _OffsetOf_dwAddr!

dwBCastAddr
	"Answer the <Integer> value of the receiver's 'dwBCastAddr' field."

	^bytes uint32AtOffset: _OffsetOf_dwBCastAddr!

dwIndex
	"Answer the <Integer> value of the receiver's 'dwIndex' field."

	^bytes uint32AtOffset: _OffsetOf_dwIndex!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwMask!

dwReasmSize
	"Answer the <Integer> value of the receiver's 'dwReasmSize' field."

	^bytes uint32AtOffset: _OffsetOf_dwReasmSize!

wType
	"Answer the <Integer> value of the receiver's 'wType' field."

	^bytes uint16AtOffset: _OffsetOf_wType! !
!OS.MIB_IPADDRROW categoriesForMethods!
dwAddr!**compiled accessors**!public! !
dwBCastAddr!**compiled accessors**!public! !
dwIndex!**compiled accessors**!public! !
dwMask!**compiled accessors**!public! !
dwReasmSize!**compiled accessors**!public! !
wType!**compiled accessors**!public! !
!

!OS.MIB_IPADDRROW class methodsFor!

byteSize
	^_MIB_IPADDRROW_Size!

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
			type: UInt32Field readOnly
			offset: 0;
		defineField: #dwIndex
			type: UInt32Field readOnly
			offset: 4;
		defineField: #dwMask
			type: UInt32Field readOnly
			offset: 8;
		defineField: #dwBCastAddr
			type: UInt32Field readOnly
			offset: 12;
		defineField: #dwReasmSize
			type: UInt32Field readOnly
			offset: 16;
		defineField: #Unused1
			type: UInt16Field filler
			offset: 20;
		defineField: #wType
			type: UInt16Field readOnly
			offset: 22.
	self byteSize: 24!

getFieldNames
	^#(#dwAddr #dwIndex #dwMask #dwBCastAddr #dwReasmSize #wType)! !
!OS.MIB_IPADDRROW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

