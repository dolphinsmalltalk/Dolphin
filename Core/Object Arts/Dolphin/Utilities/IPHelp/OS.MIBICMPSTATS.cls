"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIBICMPSTATS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwAddrMaskReps' -> 16r30.
		'_OffsetOf_dwAddrMasks' -> 16r2C.
		'_OffsetOf_dwDestUnreachs' -> 16r8.
		'_OffsetOf_dwEchoReps' -> 16r20.
		'_OffsetOf_dwEchos' -> 16r1C.
		'_OffsetOf_dwErrors' -> 16r4.
		'_OffsetOf_dwMsgs' -> 16r0.
		'_OffsetOf_dwParmProbs' -> 16r10.
		'_OffsetOf_dwRedirects' -> 16r18.
		'_OffsetOf_dwSrcQuenchs' -> 16r14.
		'_OffsetOf_dwTimeExcds' -> 16rC.
		'_OffsetOf_dwTimestampReps' -> 16r28.
		'_OffsetOf_dwTimestamps' -> 16r24
	}!
MIBICMPSTATS guid: (GUID fromString: '{2dac7cde-bfec-4391-a2e5-1ddf10a3c471}')!
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
	"Answer the <Integer> value of the receiver's 'dwAddrMaskReps' field."

	^bytes dwordAtOffset: _OffsetOf_dwAddrMaskReps!

dwAddrMasks
	"Answer the <Integer> value of the receiver's 'dwAddrMasks' field."

	^bytes dwordAtOffset: _OffsetOf_dwAddrMasks!

dwDestUnreachs
	"Answer the <Integer> value of the receiver's 'dwDestUnreachs' field."

	^bytes dwordAtOffset: _OffsetOf_dwDestUnreachs!

dwEchoReps
	"Answer the <Integer> value of the receiver's 'dwEchoReps' field."

	^bytes dwordAtOffset: _OffsetOf_dwEchoReps!

dwEchos
	"Answer the <Integer> value of the receiver's 'dwEchos' field."

	^bytes dwordAtOffset: _OffsetOf_dwEchos!

dwErrors
	"Answer the <Integer> value of the receiver's 'dwErrors' field."

	^bytes dwordAtOffset: _OffsetOf_dwErrors!

dwMsgs
	"Answer the <Integer> value of the receiver's 'dwMsgs' field."

	^bytes dwordAtOffset: _OffsetOf_dwMsgs!

dwParmProbs
	"Answer the <Integer> value of the receiver's 'dwParmProbs' field."

	^bytes dwordAtOffset: _OffsetOf_dwParmProbs!

dwRedirects
	"Answer the <Integer> value of the receiver's 'dwRedirects' field."

	^bytes dwordAtOffset: _OffsetOf_dwRedirects!

dwSrcQuenchs
	"Answer the <Integer> value of the receiver's 'dwSrcQuenchs' field."

	^bytes dwordAtOffset: _OffsetOf_dwSrcQuenchs!

dwTimeExcds
	"Answer the <Integer> value of the receiver's 'dwTimeExcds' field."

	^bytes dwordAtOffset: _OffsetOf_dwTimeExcds!

dwTimestampReps
	"Answer the <Integer> value of the receiver's 'dwTimestampReps' field."

	^bytes dwordAtOffset: _OffsetOf_dwTimestampReps!

dwTimestamps
	"Answer the <Integer> value of the receiver's 'dwTimestamps' field."

	^bytes dwordAtOffset: _OffsetOf_dwTimestamps! !
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
	self byteSize: 52!

getFieldNames
	^#(#dwMsgs #dwErrors #dwDestUnreachs #dwTimeExcds #dwParmProbs #dwSrcQuenchs #dwRedirects #dwEchos #dwEchoReps #dwTimestamps #dwTimestampReps #dwAddrMasks #dwAddrMaskReps)! !
!MIBICMPSTATS class categoriesFor: #defineFields!initializing!public! !
!MIBICMPSTATS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

