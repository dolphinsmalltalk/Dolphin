"Filed out from Dolphin Smalltalk 7"!

OS.IpHlpApiTableStruct subclass: #'OS.IP_ADAPTER_ORDER_MAP'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_table' -> 16r4
	}!
OS.IP_ADAPTER_ORDER_MAP guid: (Core.GUID fromString: '{975761ac-0340-468d-bae7-f24198e8f83a}')!
OS.IP_ADAPTER_ORDER_MAP comment: '<IP_ADAPTER_ORDER_MAP> is an <ExternalStructure> class to wrap the struct ''Win32.IP_ADAPTER_ORDER_MAP'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_ADAPTER_ORDER_MAP {
	unsigned long NumAdapters;
	unsigned long AdapterOrder[1];
} IP_ADAPTER_ORDER_MAP;
'!
!OS.IP_ADAPTER_ORDER_MAP categoriesForClass!Win32-Structs! !
!OS.IP_ADAPTER_ORDER_MAP methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: DWORD! !
!OS.IP_ADAPTER_ORDER_MAP categoriesFor: #table!**compiled accessors**!public! !

!OS.IP_ADAPTER_ORDER_MAP class methodsFor!

defineFields
	"Define the fields of the IP_ADAPTER_ORDER_MAP structure.
		IP_ADAPTER_ORDER_MAP compileDefinition
	
		typedef 
		struct tagIP_ADAPTER_ORDER_MAP {
			unsigned long NumAdapters;
			unsigned long AdapterOrder[1];
		} IP_ADAPTER_ORDER_MAP;
"

	super defineFields.
	self 
		defineField: #table
		type: ((StructureArrayField type: DWORD lengthField: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#dwNumEntries #table)! !
!OS.IP_ADAPTER_ORDER_MAP class categoriesFor: #defineFields!initializing!public! !
!OS.IP_ADAPTER_ORDER_MAP class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

