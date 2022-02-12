"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.MIBICMPINFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_MIBICMPINFO_Size' -> 16r68.
		'_OffsetOf_icmpInStats' -> 16r0.
		'_OffsetOf_icmpOutStats' -> 16r34
	}!
OS.MIBICMPINFO guid: (Core.GUID fromString: '{157140e6-8375-4377-ba3e-612acdb6f9f4}')!
OS.MIBICMPINFO comment: '<MIBICMPINFO> is an <ExternalStructure> class to wrap the struct ''Win32.MIBICMPINFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIBICMPINFO {
	MIBICMPSTATS icmpInStats;
	MIBICMPSTATS icmpOutStats;
} MIBICMPINFO;
'!
!OS.MIBICMPINFO categoriesForClass!Win32-Structs! !
!OS.MIBICMPINFO methodsFor!

icmpInStats
	"Answer the <MIBICMPSTATS> value of the receiver's 'icmpInStats' field."

	^MIBICMPSTATS fromAddress: bytes yourAddress!

icmpOutStats
	"Answer the <MIBICMPSTATS> value of the receiver's 'icmpOutStats' field."

	^MIBICMPSTATS fromAddress: bytes yourAddress + _OffsetOf_icmpOutStats! !
!OS.MIBICMPINFO categoriesForMethods!
icmpInStats!**compiled accessors**!public! !
icmpOutStats!**compiled accessors**!public! !
!

!OS.MIBICMPINFO class methodsFor!

byteSize
	^_MIBICMPINFO_Size!

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
!OS.MIBICMPINFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

