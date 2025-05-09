﻿"Filed out from Dolphin Smalltalk"!

OS.IpHlpApiTableStruct
	subclass: #'OS.IP_INTERFACE_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_IP_INTERFACE_INFO_Size' -> 16r108. '_OffsetOf_table' -> 16r4 }!

OS.IP_INTERFACE_INFO guid: (Core.GUID fromString: '{e886246a-162e-4654-8719-d4c0477f0bf3}')!

OS.IP_INTERFACE_INFO comment: '<IP_INTERFACE_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.IP_INTERFACE_INFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_INTERFACE_INFO {
	long NumAdapters;
	IP_ADAPTER_INDEX_MAP Adapter[1];
} IP_INTERFACE_INFO;
'!

!OS.IP_INTERFACE_INFO categoriesForClass!Win32-Structs! !

!OS.IP_INTERFACE_INFO methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: IP_ADAPTER_INDEX_MAP! !

!OS.IP_INTERFACE_INFO categoriesForMethods!
table!**compiled accessors**!public! !
!

!OS.IP_INTERFACE_INFO class methodsFor!

byteSize
	^_IP_INTERFACE_INFO_Size!

defineFields
	"Define the fields of the IP_INTERFACE_INFO structure.
		IP_INTERFACE_INFO compileDefinition
	
		typedef 
		struct tagIP_INTERFACE_INFO {
			long NumAdapters;
			IP_ADAPTER_INDEX_MAP Adapter[1];
		} IP_INTERFACE_INFO;
"

	super defineFields.
	self
		defineField: #table
		type: ((StructureArrayField type: IP_ADAPTER_INDEX_MAP lengthField: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 264!

getFieldNames
	^#(#dwNumEntries #table)! !

!OS.IP_INTERFACE_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

