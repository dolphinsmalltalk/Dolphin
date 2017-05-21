"Filed out from Dolphin Smalltalk 7"!

IpHlpApiTableStruct subclass: #MIB_TCPTABLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_TCPTABLE guid: (GUID fromString: '{1308bd96-edb7-4030-85b1-a6651a737122}')!
MIB_TCPTABLE comment: '<MIB_TCPTABLE> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_TCPTABLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_TCPTABLE {
	unsigned long dwNumEntries;
	MIB_TCPROW table[1];
} MIB_TCPTABLE;
'!
!MIB_TCPTABLE categoriesForClass!Win32-Structs! !
!MIB_TCPTABLE methodsFor!

table
	"Answer the receiver's table field as a Smalltalk object."

	^StructureArray fromAddress: (bytes yourAddress + 4) length: self dwNumEntries elementClass: MIB_TCPROW! !
!MIB_TCPTABLE categoriesFor: #table!**compiled accessors**!public! !

!MIB_TCPTABLE class methodsFor!

defineFields
	"Define the fields of the MIB_TCPTABLE structure.
		MIB_TCPTABLE compileDefinition
	
		typedef 
		struct tagMIB_TCPTABLE {
			unsigned long dwNumEntries;
			MIB_TCPROW table[1];
		} MIB_TCPTABLE;
"

	super defineFields.
	self 
		defineField: #table
		type: ((ConformantStructureArrayField type: MIB_TCPROW length: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 24! !
!MIB_TCPTABLE class categoriesFor: #defineFields!initializing!public! !

