"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MIBICMPINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIBICMPINFO guid: (GUID fromString: '{157140E6-8375-4377-BA3E-612ACDB6F9F4}')!
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
	"Answer the receiver's icmpInStats field as a Smalltalk object."

	^MIBICMPSTATS fromAddress: (bytes yourAddress)!

icmpOutStats
	"Answer the receiver's icmpOutStats field as a Smalltalk object."

	^MIBICMPSTATS fromAddress: (bytes yourAddress + 52)! !
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
	self byteSize: 104! !
!MIBICMPINFO class categoriesFor: #defineFields!initializing!public! !

