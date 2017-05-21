"Filed out from Dolphin Smalltalk 7"!

IpHlpApiTableStruct subclass: #IP_INTERFACE_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
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
	"Answer the receiver's table field as a Smalltalk object."

	^StructureArray fromAddress: (bytes yourAddress + 4) length: self dwNumEntries elementClass: IP_ADAPTER_INDEX_MAP! !
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
		type: ((ConformantStructureArrayField type: IP_ADAPTER_INDEX_MAP length: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 264! !
!IP_INTERFACE_INFO class categoriesFor: #defineFields!initializing!public! !

