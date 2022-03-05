"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #MIB_IPSTATS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwDefaultTTL _OffsetOf_dwForwarding _OffsetOf_dwForwDatagrams _OffsetOf_dwFragCreates _OffsetOf_dwFragFails _OffsetOf_dwFragOks _OffsetOf_dwInAddrErrors _OffsetOf_dwInDelivers _OffsetOf_dwInDiscards _OffsetOf_dwInHdrErrors _OffsetOf_dwInReceives _OffsetOf_dwInUnknownProtos _OffsetOf_dwNumAddr _OffsetOf_dwNumIf _OffsetOf_dwNumRoutes _OffsetOf_dwOutDiscards _OffsetOf_dwOutNoRoutes _OffsetOf_dwOutRequests _OffsetOf_dwReasmFails _OffsetOf_dwReasmOks _OffsetOf_dwReasmReqds _OffsetOf_dwReasmTimeout _OffsetOf_dwRoutingDiscards'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IPSTATS guid: (GUID fromString: '{3390e082-4252-4d18-accb-16911c750fb8}')!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwDefaultTTL' value: 16r4!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwForwarding' value: 16r0!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwForwDatagrams' value: 16r14!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwFragCreates' value: 16r4C!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwFragFails' value: 16r48!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwFragOks' value: 16r44!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwInAddrErrors' value: 16r10!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwInDelivers' value: 16r20!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwInDiscards' value: 16r1C!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwInHdrErrors' value: 16rC!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwInReceives' value: 16r8!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwInUnknownProtos' value: 16r18!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwNumAddr' value: 16r54!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwNumIf' value: 16r50!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwNumRoutes' value: 16r58!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwOutDiscards' value: 16r2C!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwOutNoRoutes' value: 16r30!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwOutRequests' value: 16r24!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwReasmFails' value: 16r40!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwReasmOks' value: 16r3C!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwReasmReqds' value: 16r38!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwReasmTimeout' value: 16r34!
MIB_IPSTATS addClassConstant: '_OffsetOf_dwRoutingDiscards' value: 16r28!
MIB_IPSTATS comment: '<MIB_IPSTATS> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPSTATS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!MIB_IPSTATS categoriesForClass!Win32-Structs! !
!MIB_IPSTATS methodsFor!

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
!MIB_IPSTATS categoriesForMethods!
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

!MIB_IPSTATS class methodsFor!

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
!MIB_IPSTATS class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

