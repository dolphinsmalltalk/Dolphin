"Filed out from Dolphin Smalltalk 7"!

IpHlpApiTableStruct subclass: #MIB_UDPTABLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_UDPTABLE guid: (GUID fromString: '{49fa1814-6ebf-49d7-8eaf-86aa73efed72}')!
MIB_UDPTABLE comment: '<MIB_UDPTABLE> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_UDPTABLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_UDPTABLE {
	unsigned long dwNumEntries;
	MIB_UDPROW table[1];
} MIB_UDPTABLE;
'!
!MIB_UDPTABLE categoriesForClass!Win32-Structs! !
!MIB_UDPTABLE methodsFor!

table
	"Answer the receiver's table field as a Smalltalk object."

	^StructureArray fromAddress: (bytes yourAddress + 4) length: self dwNumEntries elementClass: MIB_UDPROW! !
!MIB_UDPTABLE categoriesFor: #table!**compiled accessors**!public! !

!MIB_UDPTABLE class methodsFor!

defineFields
	"Define the fields of the MIB_UDPTABLE structure.
		MIB_UDPTABLE compileDefinition
	
		typedef 
		struct tagMIB_UDPTABLE {
			unsigned long dwNumEntries;
			MIB_UDPROW table[1];
		} MIB_UDPTABLE;
"

	super defineFields.
	self 
		defineField: #table
		type: ((ConformantStructureArrayField type: MIB_UDPROW length: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 12! !
!MIB_UDPTABLE class categoriesFor: #defineFields!initializing!public! !

