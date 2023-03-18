"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.MIBICMPSTATS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_MIBICMPSTATS_Size' -> 16r34.
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
OS.MIBICMPSTATS guid: (Core.GUID fromString: '{2dac7cde-bfec-4391-a2e5-1ddf10a3c471}')!
OS.MIBICMPSTATS comment: '<MIBICMPSTATS> is an <ExternalStructure> class to wrap the struct ''Win32.MIBICMPSTATS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.MIBICMPSTATS categoriesForClass!Win32-Structs! !
!OS.MIBICMPSTATS methodsFor!

dwAddrMaskReps
	"Answer the <Integer> value of the receiver's 'dwAddrMaskReps' field."

	^bytes uint32AtOffset: _OffsetOf_dwAddrMaskReps!

dwAddrMasks
	"Answer the <Integer> value of the receiver's 'dwAddrMasks' field."

	^bytes uint32AtOffset: _OffsetOf_dwAddrMasks!

dwDestUnreachs
	"Answer the <Integer> value of the receiver's 'dwDestUnreachs' field."

	^bytes uint32AtOffset: _OffsetOf_dwDestUnreachs!

dwEchoReps
	"Answer the <Integer> value of the receiver's 'dwEchoReps' field."

	^bytes uint32AtOffset: _OffsetOf_dwEchoReps!

dwEchos
	"Answer the <Integer> value of the receiver's 'dwEchos' field."

	^bytes uint32AtOffset: _OffsetOf_dwEchos!

dwErrors
	"Answer the <Integer> value of the receiver's 'dwErrors' field."

	^bytes uint32AtOffset: _OffsetOf_dwErrors!

dwMsgs
	"Answer the <Integer> value of the receiver's 'dwMsgs' field."

	^bytes uint32AtOffset: _OffsetOf_dwMsgs!

dwParmProbs
	"Answer the <Integer> value of the receiver's 'dwParmProbs' field."

	^bytes uint32AtOffset: _OffsetOf_dwParmProbs!

dwRedirects
	"Answer the <Integer> value of the receiver's 'dwRedirects' field."

	^bytes uint32AtOffset: _OffsetOf_dwRedirects!

dwSrcQuenchs
	"Answer the <Integer> value of the receiver's 'dwSrcQuenchs' field."

	^bytes uint32AtOffset: _OffsetOf_dwSrcQuenchs!

dwTimeExcds
	"Answer the <Integer> value of the receiver's 'dwTimeExcds' field."

	^bytes uint32AtOffset: _OffsetOf_dwTimeExcds!

dwTimestampReps
	"Answer the <Integer> value of the receiver's 'dwTimestampReps' field."

	^bytes uint32AtOffset: _OffsetOf_dwTimestampReps!

dwTimestamps
	"Answer the <Integer> value of the receiver's 'dwTimestamps' field."

	^bytes uint32AtOffset: _OffsetOf_dwTimestamps! !
!OS.MIBICMPSTATS categoriesForMethods!
dwAddrMaskReps!**compiled accessors**!public! !
dwAddrMasks!**compiled accessors**!public! !
dwDestUnreachs!**compiled accessors**!public! !
dwEchoReps!**compiled accessors**!public! !
dwEchos!**compiled accessors**!public! !
dwErrors!**compiled accessors**!public! !
dwMsgs!**compiled accessors**!public! !
dwParmProbs!**compiled accessors**!public! !
dwRedirects!**compiled accessors**!public! !
dwSrcQuenchs!**compiled accessors**!public! !
dwTimeExcds!**compiled accessors**!public! !
dwTimestampReps!**compiled accessors**!public! !
dwTimestamps!**compiled accessors**!public! !
!

!OS.MIBICMPSTATS class methodsFor!

byteSize
	^_MIBICMPSTATS_Size!

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
			type: UInt32Field readOnly
			offset: 0;
		defineField: #dwErrors
			type: UInt32Field readOnly
			offset: 4;
		defineField: #dwDestUnreachs
			type: UInt32Field readOnly
			offset: 8;
		defineField: #dwTimeExcds
			type: UInt32Field readOnly
			offset: 12;
		defineField: #dwParmProbs
			type: UInt32Field readOnly
			offset: 16;
		defineField: #dwSrcQuenchs
			type: UInt32Field readOnly
			offset: 20;
		defineField: #dwRedirects
			type: UInt32Field readOnly
			offset: 24;
		defineField: #dwEchos
			type: UInt32Field readOnly
			offset: 28;
		defineField: #dwEchoReps
			type: UInt32Field readOnly
			offset: 32;
		defineField: #dwTimestamps
			type: UInt32Field readOnly
			offset: 36;
		defineField: #dwTimestampReps
			type: UInt32Field readOnly
			offset: 40;
		defineField: #dwAddrMasks
			type: UInt32Field readOnly
			offset: 44;
		defineField: #dwAddrMaskReps
			type: UInt32Field readOnly
			offset: 48.
	self byteSize: 52!

getFieldNames
	^#(#dwMsgs #dwErrors #dwDestUnreachs #dwTimeExcds #dwParmProbs #dwSrcQuenchs #dwRedirects #dwEchos #dwEchoReps #dwTimestamps #dwTimestampReps #dwAddrMasks #dwAddrMaskReps)! !
!OS.MIBICMPSTATS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

