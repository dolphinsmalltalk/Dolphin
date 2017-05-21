"Filed out from Dolphin Smalltalk 7"!

IpHlpApiTableStruct subclass: #IP_ADAPTER_ORDER_MAP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IP_ADAPTER_ORDER_MAP guid: (GUID fromString: '{975761ac-0340-468d-bae7-f24198e8f83a}')!
IP_ADAPTER_ORDER_MAP comment: '<IP_ADAPTER_ORDER_MAP> is an <ExternalStructure> class to wrap the struct ''Win32.IP_ADAPTER_ORDER_MAP'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_ADAPTER_ORDER_MAP {
	unsigned long NumAdapters;
	unsigned long AdapterOrder[1];
} IP_ADAPTER_ORDER_MAP;
'!
!IP_ADAPTER_ORDER_MAP categoriesForClass!Win32-Structs! !
!IP_ADAPTER_ORDER_MAP methodsFor!

table
	"Answer the receiver's table field as a Smalltalk object."

	^StructureArray fromAddress: (bytes yourAddress + 4) length: self dwNumEntries elementClass: DWORD! !
!IP_ADAPTER_ORDER_MAP categoriesFor: #table!**compiled accessors**!public! !

!IP_ADAPTER_ORDER_MAP class methodsFor!

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
	#todo.	"Where is the VariableArrayField class?"
	self 
		defineField: #table
		type: ((ConformantStructureArrayField type: DWORD length: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 8! !
!IP_ADAPTER_ORDER_MAP class categoriesFor: #defineFields!initializing!public! !

