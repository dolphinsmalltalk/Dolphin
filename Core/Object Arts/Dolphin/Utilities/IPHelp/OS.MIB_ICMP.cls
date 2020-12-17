"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIB_ICMP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_stats' -> 16r0
	}!
MIB_ICMP guid: (GUID fromString: '{2ca8ee35-4b8c-48a7-bc4f-1bcbf2db2be2}')!
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
	"Answer the <MIBICMPINFO> value of the receiver's 'stats' field."

	^MIBICMPINFO fromAddress: bytes yourAddress! !
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
	self byteSize: 104!

getFieldNames
	^#(#stats)! !
!MIB_ICMP class categoriesFor: #defineFields!initializing!public! !
!MIB_ICMP class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

