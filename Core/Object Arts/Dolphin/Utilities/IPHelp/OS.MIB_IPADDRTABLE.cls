﻿"Filed out from Dolphin Smalltalk"!

OS.IpHlpApiTableStruct
	subclass: #'OS.MIB_IPADDRTABLE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_MIB_IPADDRTABLE_Size' -> 16r1C. '_OffsetOf_table' -> 16r4 }!

OS.MIB_IPADDRTABLE guid: (Core.GUID fromString: '{cffa7131-3c9d-4864-9a6a-cfe3ff42a661}')!

OS.MIB_IPADDRTABLE comment: '<MIB_IPADDRTABLE> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPADDRTABLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IPADDRTABLE {
	unsigned long dwNumEntries;
	MIB_IPADDRROW table[1];
} MIB_IPADDRTABLE;
'!

!OS.MIB_IPADDRTABLE categoriesForClass!Win32-Structs! !

!OS.MIB_IPADDRTABLE methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: MIB_IPADDRROW! !

!OS.MIB_IPADDRTABLE categoriesForMethods!
table!**compiled accessors**!public! !
!

!OS.MIB_IPADDRTABLE class methodsFor!

byteSize
	^_MIB_IPADDRTABLE_Size!

defineFields
	"Define the fields of the MIB_IPADDRTABLE structure.
		MIB_IPADDRTABLE compileDefinition
	
		typedef 
		struct tagMIB_IPADDRTABLE {
			unsigned long dwNumEntries;
			MIB_IPADDRROW table[1];
		} MIB_IPADDRTABLE;
"

	super defineFields.
	self
		defineField: #table
		type: ((StructureArrayField type: MIB_IPADDRROW lengthField: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 28!

getFieldNames
	^#(#dwNumEntries #table)! !

!OS.MIB_IPADDRTABLE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

