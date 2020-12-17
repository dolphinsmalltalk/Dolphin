"Filed out from Dolphin Smalltalk 7"!

MIB_TCPTABLE subclass: #MIB_TCPEXTABLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MIB_TCPEXTABLE guid: (GUID fromString: '{3582e317-1c8d-46de-b0aa-21ada27c614f}')!
MIB_TCPEXTABLE comment: '<MIB_TCPEXTABLE> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_TCPEXTABLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_TCPEXTABLE {
	unsigned long dwNumEntries;
	MIB_TCPEXROW table[1];
} MIB_TCPEXTABLE;
'!
!MIB_TCPEXTABLE categoriesForClass!Win32-Structs! !
!MIB_TCPEXTABLE methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: MIB_TCPEXROW! !
!MIB_TCPEXTABLE categoriesFor: #table!**compiled accessors**!public! !

!MIB_TCPEXTABLE class methodsFor!

defineFields
	"Define the fields of the MIB_TCPEXTABLE structure.
		MIB_TCPEXTABLE compileDefinition
	
		typedef 
		struct tagMIB_TCPEXTABLE {
			unsigned long dwNumEntries;
			MIB_TCPEXROW table[1];
		} MIB_TCPEXTABLE;
"

	self
		defineField: #dwNumEntries
			type: DWORDField readOnly
			offset: 0;
		defineField: #table
			type: ((StructureArrayField type: MIB_TCPEXROW lengthField: #dwNumEntries)
					beOverride;
					beReadOnly;
					yourself)
			offset: 4.
	self byteSize: 28! !
!MIB_TCPEXTABLE class categoriesFor: #defineFields!initializing!public! !

