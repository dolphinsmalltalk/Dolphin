"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MIB_ICMP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_ICMP guid: (GUID fromString: '{2CA8EE35-4B8C-48A7-BC4F-1BCBF2DB2BE2}')!
MIB_ICMP comment: '<MIB_ICMP> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_ICMP'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_ICMP {
	MIBICMPINFO stats;
} MIB_ICMP;
'!
!MIB_ICMP categoriesForClass!Win32-Structs! !
!MIB_ICMP methodsFor!

stats
	"Answer the receiver's stats field as a Smalltalk object."

	^MIBICMPINFO fromAddress: (bytes yourAddress)! !
!MIB_ICMP categoriesFor: #stats!**compiled accessors**!public! !

!MIB_ICMP class methodsFor!

defineFields
	"Define the fields of the MIB_ICMP structure.
		MIB_ICMP compileDefinition
	
		typedef 
		struct tagMIB_ICMP {
			MIBICMPINFO stats;
		} MIB_ICMP;
"

	self 
		defineField: #stats
		type: ((StructureField type: MIBICMPINFO)
				beReadOnly;
				yourself)
		offset: 0.
	self byteSize: 104! !
!MIB_ICMP class categoriesFor: #defineFields!initializing!public! !

