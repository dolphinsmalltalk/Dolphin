"Filed out from Dolphin Smalltalk 7"!

IpHlpApiTableStruct subclass: #MIB_IPNETTABLE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_table' -> 16r4
	}!
MIB_IPNETTABLE guid: (GUID fromString: '{4ab2727d-d1c0-4aa5-a48d-3c805e4f41bb}')!
MIB_IPNETTABLE comment: '<MIB_IPNETTABLE> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPNETTABLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IPNETTABLE {
	unsigned long dwNumEntries;
	MIB_IPNETROW table[1];
} MIB_IPNETTABLE;
'!
!MIB_IPNETTABLE categoriesForClass!Win32-Structs! !
!MIB_IPNETTABLE methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: MIB_IPNETROW! !
!MIB_IPNETTABLE categoriesFor: #table!**compiled accessors**!public! !

!MIB_IPNETTABLE class methodsFor!

defineFields
	"Define the fields of the MIB_IPNETTABLE structure.
		MIB_IPNETTABLE compileDefinition
	
		typedef 
		struct tagMIB_IPNETTABLE {
			unsigned long dwNumEntries;
			MIB_IPNETROW table[1];
		} MIB_IPNETTABLE;
"

	super defineFields.
	self 
		defineField: #table
		type: ((StructureArrayField type: MIB_IPNETROW lengthField: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 28!

getFieldNames
	^#(#dwNumEntries #table)! !
!MIB_IPNETTABLE class categoriesFor: #defineFields!initializing!public! !
!MIB_IPNETTABLE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

