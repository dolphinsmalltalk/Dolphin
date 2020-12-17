"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.MIB_IPSTATS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
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

	^bytes dwordAtOffset: _OffsetOf_dwDefaultTTL!

dwForwarding
	"Answer the <Integer> value of the receiver's 'dwForwarding' field."

	^bytes dwordAtOffset: _OffsetOf_dwForwarding!

dwForwDatagrams
	"Answer the <Integer> value of the receiver's 'dwForwDatagrams' field."

	^bytes dwordAtOffset: _OffsetOf_dwForwDatagrams!

dwFragCreates
	"Answer the <Integer> value of the receiver's 'dwFragCreates' field."

	^bytes dwordAtOffset: _OffsetOf_dwFragCreates!

dwFragFails
	"Answer the <Integer> value of the receiver's 'dwFragFails' field."

	^bytes dwordAtOffset: _OffsetOf_dwFragFails!

dwFragOks
	"Answer the <Integer> value of the receiver's 'dwFragOks' field."

	^bytes dwordAtOffset: _OffsetOf_dwFragOks!

dwInAddrErrors
	"Answer the <Integer> value of the receiver's 'dwInAddrErrors' field."

	^bytes dwordAtOffset: _OffsetOf_dwInAddrErrors!

dwInDelivers
	"Answer the <Integer> value of the receiver's 'dwInDelivers' field."

	^bytes dwordAtOffset: _OffsetOf_dwInDelivers!

dwInDiscards
	"Answer the <Integer> value of the receiver's 'dwInDiscards' field."

	^bytes dwordAtOffset: _OffsetOf_dwInDiscards!

dwInHdrErrors
	"Answer the <Integer> value of the receiver's 'dwInHdrErrors' field."

	^bytes dwordAtOffset: _OffsetOf_dwInHdrErrors!

dwInReceives
	"Answer the <Integer> value of the receiver's 'dwInReceives' field."

	^bytes dwordAtOffset: _OffsetOf_dwInReceives!

dwInUnknownProtos
	"Answer the <Integer> value of the receiver's 'dwInUnknownProtos' field."

	^bytes dwordAtOffset: _OffsetOf_dwInUnknownProtos!

dwNumAddr
	"Answer the <Integer> value of the receiver's 'dwNumAddr' field."

	^bytes dwordAtOffset: _OffsetOf_dwNumAddr!

dwNumIf
	"Answer the <Integer> value of the receiver's 'dwNumIf' field."

	^bytes dwordAtOffset: _OffsetOf_dwNumIf!

dwNumRoutes
	"Answer the <Integer> value of the receiver's 'dwNumRoutes' field."

	^bytes dwordAtOffset: _OffsetOf_dwNumRoutes!

dwOutDiscards
	"Answer the <Integer> value of the receiver's 'dwOutDiscards' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutDiscards!

dwOutNoRoutes
	"Answer the <Integer> value of the receiver's 'dwOutNoRoutes' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutNoRoutes!

dwOutRequests
	"Answer the <Integer> value of the receiver's 'dwOutRequests' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutRequests!

dwReasmFails
	"Answer the <Integer> value of the receiver's 'dwReasmFails' field."

	^bytes dwordAtOffset: _OffsetOf_dwReasmFails!

dwReasmOks
	"Answer the <Integer> value of the receiver's 'dwReasmOks' field."

	^bytes dwordAtOffset: _OffsetOf_dwReasmOks!

dwReasmReqds
	"Answer the <Integer> value of the receiver's 'dwReasmReqds' field."

	^bytes dwordAtOffset: _OffsetOf_dwReasmReqds!

dwReasmTimeout
	"Answer the <Integer> value of the receiver's 'dwReasmTimeout' field."

	^bytes dwordAtOffset: _OffsetOf_dwReasmTimeout!

dwRoutingDiscards
	"Answer the <Integer> value of the receiver's 'dwRoutingDiscards' field."

	^bytes dwordAtOffset: _OffsetOf_dwRoutingDiscards! !
!OS.MIB_IPSTATS categoriesFor: #dwDefaultTTL!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwForwarding!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwForwDatagrams!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwFragCreates!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwFragFails!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwFragOks!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwInAddrErrors!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwInDelivers!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwInDiscards!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwInHdrErrors!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwInReceives!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwInUnknownProtos!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwNumAddr!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwNumIf!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwNumRoutes!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwOutDiscards!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwOutNoRoutes!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwOutRequests!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwReasmFails!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwReasmOks!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwReasmReqds!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwReasmTimeout!**compiled accessors**!public! !
!OS.MIB_IPSTATS categoriesFor: #dwRoutingDiscards!**compiled accessors**!public! !

!OS.MIB_IPSTATS class methodsFor!

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
		defineField: #dwForwarding type: DWORDField readOnly offset: 0;
		defineField: #dwDefaultTTL type: DWORDField readOnly offset: 4;
		defineField: #dwInReceives type: DWORDField readOnly offset: 8;
		defineField: #dwInHdrErrors type: DWORDField readOnly offset: 12;
		defineField: #dwInAddrErrors type: DWORDField readOnly offset: 16;
		defineField: #dwForwDatagrams type: DWORDField readOnly offset: 20;
		defineField: #dwInUnknownProtos type: DWORDField readOnly offset: 24;
		defineField: #dwInDiscards type: DWORDField readOnly offset: 28;
		defineField: #dwInDelivers type: DWORDField readOnly offset: 32;
		defineField: #dwOutRequests type: DWORDField readOnly offset: 36;
		defineField: #dwRoutingDiscards type: DWORDField readOnly offset: 40;
		defineField: #dwOutDiscards type: DWORDField readOnly offset: 44;
		defineField: #dwOutNoRoutes type: DWORDField readOnly offset: 48;
		defineField: #dwReasmTimeout type: DWORDField readOnly offset: 52;
		defineField: #dwReasmReqds type: DWORDField readOnly offset: 56;
		defineField: #dwReasmOks type: DWORDField readOnly offset: 60;
		defineField: #dwReasmFails type: DWORDField readOnly offset: 64;
		defineField: #dwFragOks type: DWORDField readOnly offset: 68;
		defineField: #dwFragFails type: DWORDField readOnly offset: 72;
		defineField: #dwFragCreates type: DWORDField readOnly offset: 76;
		defineField: #dwNumIf type: DWORDField readOnly offset: 80;
		defineField: #dwNumAddr type: DWORDField readOnly offset: 84;
		defineField: #dwNumRoutes type: DWORDField readOnly offset: 88.
	self byteSize: 92!

getFieldNames
	^#(#dwForwarding #dwDefaultTTL #dwInReceives #dwInHdrErrors #dwInAddrErrors #dwForwDatagrams #dwInUnknownProtos #dwInDiscards #dwInDelivers #dwOutRequests #dwRoutingDiscards #dwOutDiscards #dwOutNoRoutes #dwReasmTimeout #dwReasmReqds #dwReasmOks #dwReasmFails #dwFragOks #dwFragFails #dwFragCreates #dwNumIf #dwNumAddr #dwNumRoutes)! !
!OS.MIB_IPSTATS class categoriesFor: #defineFields!initializing!public! !
!OS.MIB_IPSTATS class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

