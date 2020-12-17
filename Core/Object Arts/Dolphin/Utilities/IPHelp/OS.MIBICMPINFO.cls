"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIBICMPINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_icmpInStats' -> 16r0.
		'_OffsetOf_icmpOutStats' -> 16r34
	}!
MIBICMPINFO guid: (GUID fromString: '{157140e6-8375-4377-ba3e-612acdb6f9f4}')!
MIBICMPINFO comment: '<MIBICMPINFO> is an <ExternalStructure> class to wrap the struct ''Win32.MIBICMPINFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIBICMPINFO {
	MIBICMPSTATS icmpInStats;
	MIBICMPSTATS icmpOutStats;
} MIBICMPINFO;
'!
!MIBICMPINFO categoriesForClass!Win32-Structs! !
!MIBICMPINFO methodsFor!

icmpInStats
	"Answer the <MIBICMPSTATS> value of the receiver's 'icmpInStats' field."

	^MIBICMPSTATS fromAddress: bytes yourAddress!

icmpOutStats
	"Answer the <MIBICMPSTATS> value of the receiver's 'icmpOutStats' field."

	^MIBICMPSTATS fromAddress: bytes yourAddress + _OffsetOf_icmpOutStats! !
!MIBICMPINFO categoriesFor: #icmpInStats!**compiled accessors**!public! !
!MIBICMPINFO categoriesFor: #icmpOutStats!**compiled accessors**!public! !

!MIBICMPINFO class methodsFor!

defineFields
	"Define the fields of the MIBICMPINFO structure.
		MIBICMPINFO compileDefinition
	
		typedef 
		struct tagMIBICMPINFO {
			MIBICMPSTATS icmpInStats;
			MIBICMPSTATS icmpOutStats;
		} MIBICMPINFO;
"

	self
		defineField: #icmpInStats
			type: ((StructureField type: MIBICMPSTATS)
					beReadOnly;
					yourself)
			offset: 0;
		defineField: #icmpOutStats
			type: ((StructureField type: MIBICMPSTATS)
					beReadOnly;
					yourself)
			offset: 52.
	self byteSize: 104!

getFieldNames
	^#(#icmpInStats #icmpOutStats)! !
!MIBICMPINFO class categoriesFor: #defineFields!initializing!public! !
!MIBICMPINFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

