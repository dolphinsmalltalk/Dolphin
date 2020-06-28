"Filed out from Dolphin Smalltalk 7"!

IpHlpApiTableStruct subclass: #MIB_IFTABLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_table' -> 16r4
	}!
MIB_IFTABLE guid: (GUID fromString: '{2ba815fb-13d2-4ab7-a138-15332adeb3bf}')!
MIB_IFTABLE comment: '<MIB_IFTABLE> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IFTABLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IFTABLE {
	unsigned long dwNumEntries;
	MIB_IFROW table[1];
} MIB_IFTABLE;
'!
!MIB_IFTABLE categoriesForClass!Win32-Structs! !
!MIB_IFTABLE methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: MIB_IFROW! !
!MIB_IFTABLE categoriesFor: #table!**compiled accessors**!public! !

!MIB_IFTABLE class methodsFor!

defineFields
	"Define the fields of the MIB_IFTABLE structure.
		MIB_IFTABLE compileDefinition
	
		typedef 
		struct tagMIB_IFTABLE {
			unsigned long dwNumEntries;
			MIB_IFROW table[1];
		} MIB_IFTABLE;
"

	super defineFields.
	self 
		defineField: #table
		type: ((StructureArrayField type: MIB_IFROW lengthField: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 864!

getFieldNames
	^#(#dwNumEntries #table)! !
!MIB_IFTABLE class categoriesFor: #defineFields!initializing!public! !
!MIB_IFTABLE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

