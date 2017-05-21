"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIBICMPSTATS_EX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIBICMPSTATS_EX guid: (GUID fromString: '{82731d6f-0e73-4221-9881-7172ae7d82cd}')!
MIBICMPSTATS_EX comment: '<MIBICMPSTATS_EX> is an <ExternalStructure> class to wrap the struct ''Win32.MIBICMPSTATS_EX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIBICMPSTATS_EX {
	unsigned long dwMsgs;
	unsigned long dwErrors;
	unsigned long rgdwTypeCount[256];
} MIBICMPSTATS_EX;
'!
!MIBICMPSTATS_EX categoriesForClass!Win32-Structs! !
!MIBICMPSTATS_EX methodsFor!

dwErrors
	"Answer the receiver's dwErrors field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwMsgs
	"Answer the receiver's dwMsgs field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

rgdwTypeCount
	"Answer the receiver's rgdwTypeCount field as a Smalltalk object."

	^DWORDArray fromAddress: (bytes yourAddress + 8) length: 256! !
!MIBICMPSTATS_EX categoriesFor: #dwErrors!**compiled accessors**!public! !
!MIBICMPSTATS_EX categoriesFor: #dwMsgs!**compiled accessors**!public! !
!MIBICMPSTATS_EX categoriesFor: #rgdwTypeCount!**compiled accessors**!public! !

!MIBICMPSTATS_EX class methodsFor!

defineFields
	"Define the fields of the MIBICMPSTATS_EX structure.
		MIBICMPSTATS_EX compileDefinition
	
		typedef 
		struct tagMIBICMPSTATS_EX {
			unsigned long dwMsgs;
			unsigned long dwErrors;
			unsigned long rgdwTypeCount[256];
		} MIBICMPSTATS_EX;
"

	self
		defineField: #dwMsgs
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwErrors
			type: DWORDField readOnly
			offset: 4;
		defineField: #rgdwTypeCount
			type: ((ArrayField type: DWORDArray length: 256)
					beReadOnly;
					yourself)
			offset: 8.
	self byteSize: 1032! !
!MIBICMPSTATS_EX class categoriesFor: #defineFields!initializing!public! !

