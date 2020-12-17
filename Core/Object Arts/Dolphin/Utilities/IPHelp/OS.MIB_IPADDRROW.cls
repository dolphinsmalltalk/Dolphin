"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.MIB_IPADDRROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
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
!OS.MIB_IPADDRROW categoriesFor: #dwAddr!**compiled accessors**!public! !
!OS.MIB_IPADDRROW categoriesFor: #dwBCastAddr!**compiled accessors**!public! !
!OS.MIB_IPADDRROW categoriesFor: #dwIndex!**compiled accessors**!public! !
!OS.MIB_IPADDRROW categoriesFor: #dwMask!**compiled accessors**!public! !
!OS.MIB_IPADDRROW categoriesFor: #dwReasmSize!**compiled accessors**!public! !
!OS.MIB_IPADDRROW categoriesFor: #wType!**compiled accessors**!public! !

!OS.MIB_IPADDRROW class methodsFor!

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
!OS.MIB_IPADDRROW class categoriesFor: #defineFields!initializing!public! !
!OS.MIB_IPADDRROW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

