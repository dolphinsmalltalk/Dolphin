"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIB_ICMP_EX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_icmpInStats' -> 16r0.
		'_OffsetOf_icmpOutStats' -> 16r408
	}!
MIB_ICMP_EX guid: (GUID fromString: '{15e74798-3501-497b-a245-8dc4108fba87}')!
MIB_ICMP_EX comment: '<MIB_ICMP_EX> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_ICMP_EX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_ICMP_EX {
	MIBICMPSTATS_EX icmpInStats;
	MIBICMPSTATS_EX icmpOutStats;
} MIB_ICMP_EX;
'!
!MIB_ICMP_EX categoriesForClass!Win32-Structs! !
!MIB_ICMP_EX methodsFor!

icmpInStats
	"Answer the <MIBICMPSTATS_EX> value of the receiver's 'icmpInStats' field."

	^MIBICMPSTATS_EX fromAddress: bytes yourAddress!

icmpOutStats
	"Answer the <MIBICMPSTATS_EX> value of the receiver's 'icmpOutStats' field."

	^MIBICMPSTATS_EX fromAddress: bytes yourAddress + _OffsetOf_icmpOutStats! !
!MIB_ICMP_EX categoriesFor: #icmpInStats!**compiled accessors**!public! !
!MIB_ICMP_EX categoriesFor: #icmpOutStats!**compiled accessors**!public! !

!MIB_ICMP_EX class methodsFor!

defineFields
	"Define the fields of the MIB_ICMP_EX structure.
		MIB_ICMP_EX compileDefinition
	
		typedef 
		struct tagMIB_ICMP_EX {
			MIBICMPSTATS_EX icmpInStats;
			MIBICMPSTATS_EX icmpOutStats;
		} MIB_ICMP_EX;
"

	self
		defineField: #icmpInStats
			type: ((StructureField type: MIBICMPSTATS_EX)
					beReadOnly;
					yourself)
			offset: 0;
		defineField: #icmpOutStats
			type: ((StructureField type: MIBICMPSTATS_EX)
					beReadOnly;
					yourself)
			offset: 1032.
	self byteSize: 2064!

getFieldNames
	^#(#icmpInStats #icmpOutStats)! !
!MIB_ICMP_EX class categoriesFor: #defineFields!initializing!public! !
!MIB_ICMP_EX class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

