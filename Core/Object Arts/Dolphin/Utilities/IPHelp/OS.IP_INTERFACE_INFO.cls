"Filed out from Dolphin Smalltalk 7"!

IpHlpApiTableStruct subclass: #IP_INTERFACE_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_table' -> 16r4
	}!
IP_INTERFACE_INFO guid: (GUID fromString: '{e886246a-162e-4654-8719-d4c0477f0bf3}')!
IP_INTERFACE_INFO comment: '<IP_INTERFACE_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.IP_INTERFACE_INFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_INTERFACE_INFO {
	long NumAdapters;
	IP_ADAPTER_INDEX_MAP Adapter[1];
} IP_INTERFACE_INFO;
'!
!IP_INTERFACE_INFO categoriesForClass!Win32-Structs! !
!IP_INTERFACE_INFO methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: IP_ADAPTER_INDEX_MAP! !
!IP_INTERFACE_INFO categoriesFor: #table!**compiled accessors**!public! !

!IP_INTERFACE_INFO class methodsFor!

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
!IP_INTERFACE_INFO class categoriesFor: #defineFields!initializing!public! !
!IP_INTERFACE_INFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

