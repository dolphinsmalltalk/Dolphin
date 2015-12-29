"Filed out from Dolphin Smalltalk X6.1"!

MIB_UDPTABLE subclass: #MIB_UDPEXTABLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_UDPEXTABLE guid: (GUID fromString: '{DDE2B010-360D-4715-9804-4E3D4982296F}')!
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
	"Answer the receiver's table field as a Smalltalk object."

	^StructureArray fromAddress: (bytes yourAddress + 4) length: self dwNumEntries elementClass: MIB_UDPEXROW! !
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
			type: ((ConformantStructureArrayField type: MIB_UDPEXROW length: #dwNumEntries)
					beOverride;
					beReadOnly;
					yourself)
			offset: 4.
	self byteSize: 16! !
!MIB_UDPEXTABLE class categoriesFor: #defineFields!initializing!public! !

