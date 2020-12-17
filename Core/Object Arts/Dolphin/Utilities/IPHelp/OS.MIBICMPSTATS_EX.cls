"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIBICMPSTATS_EX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwErrors' -> 16r4.
		'_OffsetOf_dwMsgs' -> 16r0.
		'_OffsetOf_rgdwTypeCount' -> 16r8
	}!
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
	"Answer the <Integer> value of the receiver's 'dwErrors' field."

	^bytes dwordAtOffset: _OffsetOf_dwErrors!

dwMsgs
	"Answer the <Integer> value of the receiver's 'dwMsgs' field."

	^bytes dwordAtOffset: _OffsetOf_dwMsgs!

rgdwTypeCount
	"Answer the <DWORDArray> value of the receiver's 'rgdwTypeCount' field."

	^DWORDArray fromAddress: bytes yourAddress + _OffsetOf_rgdwTypeCount length: 256! !
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
	self byteSize: 1032!

getFieldNames
	^#(#dwMsgs #dwErrors #rgdwTypeCount)! !
!MIBICMPSTATS_EX class categoriesFor: #defineFields!initializing!public! !
!MIBICMPSTATS_EX class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

