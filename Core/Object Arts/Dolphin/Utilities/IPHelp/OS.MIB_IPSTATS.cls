﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.MIB_IPSTATS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MIB_IPSTATS_Size' -> 16r5C.
			'_OffsetOf_dwDefaultTTL' -> 16r4.
			'_OffsetOf_dwForwarding' -> 16r0.
			'_OffsetOf_dwForwDatagrams' -> 16r14.
			'_OffsetOf_dwFragCreates' -> 16r4C.
			'_OffsetOf_dwFragFails' -> 16r48.
			'_OffsetOf_dwFragOks' -> 16r44.
			'_OffsetOf_dwInAddrErrors' -> 16r10.
			'_OffsetOf_dwInDelivers' -> 16r20.
			'_OffsetOf_dwInDiscards' -> 16r1C.
			'_OffsetOf_dwInHdrErrors' -> 16rC.
			'_OffsetOf_dwInReceives' -> 16r8.
			'_OffsetOf_dwInUnknownProtos' -> 16r18.
			'_OffsetOf_dwNumAddr' -> 16r54.
			'_OffsetOf_dwNumIf' -> 16r50.
			'_OffsetOf_dwNumRoutes' -> 16r58.
			'_OffsetOf_dwOutDiscards' -> 16r2C.
			'_OffsetOf_dwOutNoRoutes' -> 16r30.
			'_OffsetOf_dwOutRequests' -> 16r24.
			'_OffsetOf_dwReasmFails' -> 16r40.
			'_OffsetOf_dwReasmOks' -> 16r3C.
			'_OffsetOf_dwReasmReqds' -> 16r38.
			'_OffsetOf_dwReasmTimeout' -> 16r34.
			'_OffsetOf_dwRoutingDiscards' -> 16r28
		}!

OS.MIB_IPSTATS guid: (Core.GUID fromString: '{3390e082-4252-4d18-accb-16911c750fb8}')!

OS.MIB_IPSTATS comment: '<MIB_IPSTATS> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPSTATS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IPSTATS {
	unsigned long dwForwarding;
	unsigned long dwDefaultTTL;
	unsigned long dwInReceives;
	unsigned long dwInHdrErrors;
	unsigned long dwInAddrErrors;
	unsigned long dwForwDatagrams;
	unsigned long dwInUnknownProtos;
	unsigned long dwInDiscards;
	unsigned long dwInDelivers;
	unsigned long dwOutRequests;
	unsigned long dwRoutingDiscards;
	unsigned long dwOutDiscards;
	unsigned long dwOutNoRoutes;
	unsigned long dwReasmTimeout;
	unsigned long dwReasmReqds;
	unsigned long dwReasmOks;
	unsigned long dwReasmFails;
	unsigned long dwFragOks;
	unsigned long dwFragFails;
	unsigned long dwFragCreates;
	unsigned long dwNumIf;
	unsigned long dwNumAddr;
	unsigned long dwNumRoutes;
} MIB_IPSTATS;
'!

!OS.MIB_IPSTATS categoriesForClass!Win32-Structs! !

!OS.MIB_IPSTATS methodsFor!

dwDefaultTTL
	"Answer the <Integer> value of the receiver's 'dwDefaultTTL' field."

	^bytes uint32AtOffset: _OffsetOf_dwDefaultTTL!

dwForwarding
	"Answer the <Integer> value of the receiver's 'dwForwarding' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwarding!

dwForwDatagrams
	"Answer the <Integer> value of the receiver's 'dwForwDatagrams' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwDatagrams!

dwFragCreates
	"Answer the <Integer> value of the receiver's 'dwFragCreates' field."

	^bytes uint32AtOffset: _OffsetOf_dwFragCreates!

dwFragFails
	"Answer the <Integer> value of the receiver's 'dwFragFails' field."

	^bytes uint32AtOffset: _OffsetOf_dwFragFails!

dwFragOks
	"Answer the <Integer> value of the receiver's 'dwFragOks' field."

	^bytes uint32AtOffset: _OffsetOf_dwFragOks!

dwInAddrErrors
	"Answer the <Integer> value of the receiver's 'dwInAddrErrors' field."

	^bytes uint32AtOffset: _OffsetOf_dwInAddrErrors!

dwInDelivers
	"Answer the <Integer> value of the receiver's 'dwInDelivers' field."

	^bytes uint32AtOffset: _OffsetOf_dwInDelivers!

dwInDiscards
	"Answer the <Integer> value of the receiver's 'dwInDiscards' field."

	^bytes uint32AtOffset: _OffsetOf_dwInDiscards!

dwInHdrErrors
	"Answer the <Integer> value of the receiver's 'dwInHdrErrors' field."

	^bytes uint32AtOffset: _OffsetOf_dwInHdrErrors!

dwInReceives
	"Answer the <Integer> value of the receiver's 'dwInReceives' field."

	^bytes uint32AtOffset: _OffsetOf_dwInReceives!

dwInUnknownProtos
	"Answer the <Integer> value of the receiver's 'dwInUnknownProtos' field."

	^bytes uint32AtOffset: _OffsetOf_dwInUnknownProtos!

dwNumAddr
	"Answer the <Integer> value of the receiver's 'dwNumAddr' field."

	^bytes uint32AtOffset: _OffsetOf_dwNumAddr!

dwNumIf
	"Answer the <Integer> value of the receiver's 'dwNumIf' field."

	^bytes uint32AtOffset: _OffsetOf_dwNumIf!

dwNumRoutes
	"Answer the <Integer> value of the receiver's 'dwNumRoutes' field."

	^bytes uint32AtOffset: _OffsetOf_dwNumRoutes!

dwOutDiscards
	"Answer the <Integer> value of the receiver's 'dwOutDiscards' field."

	^bytes uint32AtOffset: _OffsetOf_dwOutDiscards!

dwOutNoRoutes
	"Answer the <Integer> value of the receiver's 'dwOutNoRoutes' field."

	^bytes uint32AtOffset: _OffsetOf_dwOutNoRoutes!

dwOutRequests
	"Answer the <Integer> value of the receiver's 'dwOutRequests' field."

	^bytes uint32AtOffset: _OffsetOf_dwOutRequests!

dwReasmFails
	"Answer the <Integer> value of the receiver's 'dwReasmFails' field."

	^bytes uint32AtOffset: _OffsetOf_dwReasmFails!

dwReasmOks
	"Answer the <Integer> value of the receiver's 'dwReasmOks' field."

	^bytes uint32AtOffset: _OffsetOf_dwReasmOks!

dwReasmReqds
	"Answer the <Integer> value of the receiver's 'dwReasmReqds' field."

	^bytes uint32AtOffset: _OffsetOf_dwReasmReqds!

dwReasmTimeout
	"Answer the <Integer> value of the receiver's 'dwReasmTimeout' field."

	^bytes uint32AtOffset: _OffsetOf_dwReasmTimeout!

dwRoutingDiscards
	"Answer the <Integer> value of the receiver's 'dwRoutingDiscards' field."

	^bytes uint32AtOffset: _OffsetOf_dwRoutingDiscards! !

!OS.MIB_IPSTATS categoriesForMethods!
dwDefaultTTL!**compiled accessors**!public! !
dwForwarding!**compiled accessors**!public! !
dwForwDatagrams!**compiled accessors**!public! !
dwFragCreates!**compiled accessors**!public! !
dwFragFails!**compiled accessors**!public! !
dwFragOks!**compiled accessors**!public! !
dwInAddrErrors!**compiled accessors**!public! !
dwInDelivers!**compiled accessors**!public! !
dwInDiscards!**compiled accessors**!public! !
dwInHdrErrors!**compiled accessors**!public! !
dwInReceives!**compiled accessors**!public! !
dwInUnknownProtos!**compiled accessors**!public! !
dwNumAddr!**compiled accessors**!public! !
dwNumIf!**compiled accessors**!public! !
dwNumRoutes!**compiled accessors**!public! !
dwOutDiscards!**compiled accessors**!public! !
dwOutNoRoutes!**compiled accessors**!public! !
dwOutRequests!**compiled accessors**!public! !
dwReasmFails!**compiled accessors**!public! !
dwReasmOks!**compiled accessors**!public! !
dwReasmReqds!**compiled accessors**!public! !
dwReasmTimeout!**compiled accessors**!public! !
dwRoutingDiscards!**compiled accessors**!public! !
!

!OS.MIB_IPSTATS class methodsFor!

byteSize
	^_MIB_IPSTATS_Size!

defineFields
	"Define the fields of the MIB_IPSTATS structure.
		MIB_IPSTATS compileDefinition
	
		typedef 
		struct tagMIB_IPSTATS {
			unsigned long dwForwarding;
			unsigned long dwDefaultTTL;
			unsigned long dwInReceives;
			unsigned long dwInHdrErrors;
			unsigned long dwInAddrErrors;
			unsigned long dwForwDatagrams;
			unsigned long dwInUnknownProtos;
			unsigned long dwInDiscards;
			unsigned long dwInDelivers;
			unsigned long dwOutRequests;
			unsigned long dwRoutingDiscards;
			unsigned long dwOutDiscards;
			unsigned long dwOutNoRoutes;
			unsigned long dwReasmTimeout;
			unsigned long dwReasmReqds;
			unsigned long dwReasmOks;
			unsigned long dwReasmFails;
			unsigned long dwFragOks;
			unsigned long dwFragFails;
			unsigned long dwFragCreates;
			unsigned long dwNumIf;
			unsigned long dwNumAddr;
			unsigned long dwNumRoutes;
		} MIB_IPSTATS;
"

	self
		defineField: #dwForwarding type: UInt32Field readOnly offset: 0;
		defineField: #dwDefaultTTL type: UInt32Field readOnly offset: 4;
		defineField: #dwInReceives type: UInt32Field readOnly offset: 8;
		defineField: #dwInHdrErrors type: UInt32Field readOnly offset: 12;
		defineField: #dwInAddrErrors type: UInt32Field readOnly offset: 16;
		defineField: #dwForwDatagrams type: UInt32Field readOnly offset: 20;
		defineField: #dwInUnknownProtos type: UInt32Field readOnly offset: 24;
		defineField: #dwInDiscards type: UInt32Field readOnly offset: 28;
		defineField: #dwInDelivers type: UInt32Field readOnly offset: 32;
		defineField: #dwOutRequests type: UInt32Field readOnly offset: 36;
		defineField: #dwRoutingDiscards type: UInt32Field readOnly offset: 40;
		defineField: #dwOutDiscards type: UInt32Field readOnly offset: 44;
		defineField: #dwOutNoRoutes type: UInt32Field readOnly offset: 48;
		defineField: #dwReasmTimeout type: UInt32Field readOnly offset: 52;
		defineField: #dwReasmReqds type: UInt32Field readOnly offset: 56;
		defineField: #dwReasmOks type: UInt32Field readOnly offset: 60;
		defineField: #dwReasmFails type: UInt32Field readOnly offset: 64;
		defineField: #dwFragOks type: UInt32Field readOnly offset: 68;
		defineField: #dwFragFails type: UInt32Field readOnly offset: 72;
		defineField: #dwFragCreates type: UInt32Field readOnly offset: 76;
		defineField: #dwNumIf type: UInt32Field readOnly offset: 80;
		defineField: #dwNumAddr type: UInt32Field readOnly offset: 84;
		defineField: #dwNumRoutes type: UInt32Field readOnly offset: 88.
	self byteSize: 92!

getFieldNames
	^#(#dwForwarding #dwDefaultTTL #dwInReceives #dwInHdrErrors #dwInAddrErrors #dwForwDatagrams #dwInUnknownProtos #dwInDiscards #dwInDelivers #dwOutRequests #dwRoutingDiscards #dwOutDiscards #dwOutNoRoutes #dwReasmTimeout #dwReasmReqds #dwReasmOks #dwReasmFails #dwFragOks #dwFragFails #dwFragCreates #dwNumIf #dwNumAddr #dwNumRoutes)! !

!OS.MIB_IPSTATS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

