"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MIBICMPSTATS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIBICMPSTATS guid: (GUID fromString: '{2DAC7CDE-BFEC-4391-A2E5-1DDF10A3C471}')!
MIBICMPSTATS comment: '<MIBICMPSTATS> is an <ExternalStructure> class to wrap the struct ''Win32.MIBICMPSTATS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIBICMPSTATS {
	unsigned long dwMsgs;
	unsigned long dwErrors;
	unsigned long dwDestUnreachs;
	unsigned long dwTimeExcds;
	unsigned long dwParmProbs;
	unsigned long dwSrcQuenchs;
	unsigned long dwRedirects;
	unsigned long dwEchos;
	unsigned long dwEchoReps;
	unsigned long dwTimestamps;
	unsigned long dwTimestampReps;
	unsigned long dwAddrMasks;
	unsigned long dwAddrMaskReps;
} MIBICMPSTATS;
'!
!MIBICMPSTATS categoriesForClass!Win32-Structs! !
!MIBICMPSTATS methodsFor!

dwAddrMaskReps
	"Answer the receiver's dwAddrMaskReps field as a Smalltalk object."

	^(bytes dwordAtOffset: 48)!

dwAddrMasks
	"Answer the receiver's dwAddrMasks field as a Smalltalk object."

	^(bytes dwordAtOffset: 44)!

dwDestUnreachs
	"Answer the receiver's dwDestUnreachs field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

dwEchoReps
	"Answer the receiver's dwEchoReps field as a Smalltalk object."

	^(bytes dwordAtOffset: 32)!

dwEchos
	"Answer the receiver's dwEchos field as a Smalltalk object."

	^(bytes dwordAtOffset: 28)!

dwErrors
	"Answer the receiver's dwErrors field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwMsgs
	"Answer the receiver's dwMsgs field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwParmProbs
	"Answer the receiver's dwParmProbs field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dwRedirects
	"Answer the receiver's dwRedirects field as a Smalltalk object."

	^(bytes dwordAtOffset: 24)!

dwSrcQuenchs
	"Answer the receiver's dwSrcQuenchs field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

dwTimeExcds
	"Answer the receiver's dwTimeExcds field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dwTimestampReps
	"Answer the receiver's dwTimestampReps field as a Smalltalk object."

	^(bytes dwordAtOffset: 40)!

dwTimestamps
	"Answer the receiver's dwTimestamps field as a Smalltalk object."

	^(bytes dwordAtOffset: 36)! !
!MIBICMPSTATS categoriesFor: #dwAddrMaskReps!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwAddrMasks!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwDestUnreachs!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwEchoReps!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwEchos!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwErrors!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwMsgs!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwParmProbs!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwRedirects!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwSrcQuenchs!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwTimeExcds!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwTimestampReps!**compiled accessors**!public! !
!MIBICMPSTATS categoriesFor: #dwTimestamps!**compiled accessors**!public! !

!MIBICMPSTATS class methodsFor!

defineFields
	"Define the fields of the MIBICMPSTATS structure.
		MIBICMPSTATS compileDefinition
	
		typedef 
		struct tagMIBICMPSTATS {
			unsigned long dwMsgs;
			unsigned long dwErrors;
			unsigned long dwDestUnreachs;
			unsigned long dwTimeExcds;
			unsigned long dwParmProbs;
			unsigned long dwSrcQuenchs;
			unsigned long dwRedirects;
			unsigned long dwEchos;
			unsigned long dwEchoReps;
			unsigned long dwTimestamps;
			unsigned long dwTimestampReps;
			unsigned long dwAddrMasks;
			unsigned long dwAddrMaskReps;
		} MIBICMPSTATS;
"

	self
		defineField: #dwMsgs
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwErrors
			type: DWORDField readOnly
			offset: 4;
		defineField: #dwDestUnreachs
			type: DWORDField readOnly
			offset: 8;
		defineField: #dwTimeExcds
			type: DWORDField readOnly
			offset: 12;
		defineField: #dwParmProbs
			type: DWORDField readOnly
			offset: 16;
		defineField: #dwSrcQuenchs
			type: DWORDField readOnly
			offset: 20;
		defineField: #dwRedirects
			type: DWORDField readOnly
			offset: 24;
		defineField: #dwEchos
			type: DWORDField readOnly
			offset: 28;
		defineField: #dwEchoReps
			type: DWORDField readOnly
			offset: 32;
		defineField: #dwTimestamps
			type: DWORDField readOnly
			offset: 36;
		defineField: #dwTimestampReps
			type: DWORDField readOnly
			offset: 40;
		defineField: #dwAddrMasks
			type: DWORDField readOnly
			offset: 44;
		defineField: #dwAddrMaskReps
			type: DWORDField readOnly
			offset: 48.
	self byteSize: 52! !
!MIBICMPSTATS class categoriesFor: #defineFields!initializing!public! !

