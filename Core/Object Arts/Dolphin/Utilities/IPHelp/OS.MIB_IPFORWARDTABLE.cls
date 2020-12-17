"Filed out from Dolphin Smalltalk 7"!

OS.IpHlpApiTableStruct subclass: #'OS.MIB_IPFORWARDTABLE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_table' -> 16r4
	}!
OS.MIB_IPFORWARDTABLE guid: (Core.GUID fromString: '{61ce489c-f9e4-43f1-978b-3cc2f491e64c}')!
OS.MIB_IPFORWARDTABLE comment: '<MIB_IPFORWARDTABLE> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPFORWARDTABLE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IPFORWARDTABLE {
	unsigned long dwNumEntries;
	MIB_IPFORWARDROW table[1];
} MIB_IPFORWARDTABLE;
'!
!OS.MIB_IPFORWARDTABLE categoriesForClass!Win32-Structs! !
!OS.MIB_IPFORWARDTABLE methodsFor!

table
	"Answer the <StructureArray> value of the receiver's 'table' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_table
		length: self dwNumEntries
		elementClass: MIB_IPFORWARDROW! !
!OS.MIB_IPFORWARDTABLE categoriesFor: #table!**compiled accessors**!public! !

!OS.MIB_IPFORWARDTABLE class methodsFor!

defineFields
	"Define the fields of the MIB_IPFORWARDTABLE structure.
		MIB_IPFORWARDTABLE compileDefinition
	
		typedef 
		struct tagMIB_IPFORWARDTABLE {
			unsigned long dwNumEntries;
			MIB_IPFORWARDROW table[1];
		} MIB_IPFORWARDTABLE;
"

	super defineFields.
	self
		defineField: #table
		type: ((StructureArrayField type: MIB_IPFORWARDROW lengthField: #dwNumEntries)
				beReadOnly;
				yourself)
		offset: 4.
	self byteSize: 60!

getFieldNames
	^#(#dwNumEntries #table)! !
!OS.MIB_IPFORWARDTABLE class categoriesFor: #defineFields!initializing!public! !
!OS.MIB_IPFORWARDTABLE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

