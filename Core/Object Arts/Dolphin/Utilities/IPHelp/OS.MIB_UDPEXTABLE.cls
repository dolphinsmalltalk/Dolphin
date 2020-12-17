"Filed out from Dolphin Smalltalk 7"!

MIB_UDPTABLE subclass: #MIB_UDPEXTABLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MIB_UDPEXTABLE guid: (GUID fromString: '{dde2b010-360d-4715-9804-4e3d4982296f}')!
MIB_UDPEXTABLE comment: '<MIB_UDPEXTABLE> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPEXTABLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_UDPEXTABLE {
	unsigned long dwNumEntries;
	MIB_UDPEXROW table[1];
} MIB_UDPEXTABLE;
'!
!MIB_UDPEXTABLE categoriesForClass!Win32-Structs! !
!MIB_UDPEXTABLE methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: MIB_UDPEXROW! !
!MIB_UDPEXTABLE categoriesFor: #table!**compiled accessors**!public! !

!MIB_UDPEXTABLE class methodsFor!

defineFields
	"Define the fields of the MIB_UDPEXTABLE structure.
		MIB_UDPEXTABLE compileDefinition
	
		typedef 
		struct tagMIB_UDPEXTABLE {
			unsigned long dwNumEntries;
			MIB_UDPEXROW table[1];
		} MIB_UDPEXTABLE;
"

	self
		defineField: #dwNumEntries
			type: DWORDField readOnly
			offset: 0;
		defineField: #table
			type: ((StructureArrayField type: MIB_UDPEXROW lengthField: #dwNumEntries)
					beOverride;
					beReadOnly;
					yourself)
			offset: 4.
	self byteSize: 16! !
!MIB_UDPEXTABLE class categoriesFor: #defineFields!initializing!public! !

