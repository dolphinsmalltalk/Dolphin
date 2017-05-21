"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIB_IPSTATS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IPSTATS guid: (GUID fromString: '{3390e082-4252-4d18-accb-16911c750fb8}')!
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
	"Answer the receiver's dwDefaultTTL field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwForwarding
	"Answer the receiver's dwForwarding field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwForwDatagrams
	"Answer the receiver's dwForwDatagrams field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)!

dwFragCreates
	"Answer the receiver's dwFragCreates field as a Smalltalk object."

	^(bytes dwordAtOffset: 76)!

dwFragFails
	"Answer the receiver's dwFragFails field as a Smalltalk object."

	^(bytes dwordAtOffset: 72)!

dwFragOks
	"Answer the receiver's dwFragOks field as a Smalltalk object."

	^(bytes dwordAtOffset: 68)!

dwInAddrErrors
	"Answer the receiver's dwInAddrErrors field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dwInDelivers
	"Answer the receiver's dwInDelivers field as a Smalltalk object."

	^(bytes dwordAtOffset: 32)!

dwInDiscards
	"Answer the receiver's dwInDiscards field as a Smalltalk object."

	^(bytes dwordAtOffset: 28)!

dwInHdrErrors
	"Answer the receiver's dwInHdrErrors field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dwInReceives
	"Answer the receiver's dwInReceives field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

dwInUnknownProtos
	"Answer the receiver's dwInUnknownProtos field as a Smalltalk object."

	^(bytes dwordAtOffset: 24)!

dwNumAddr
	"Answer the receiver's dwNumAddr field as a Smalltalk object."

	^(bytes dwordAtOffset: 84)!

dwNumIf
	"Answer the receiver's dwNumIf field as a Smalltalk object."

	^(bytes dwordAtOffset: 80)!

dwNumRoutes
	"Answer the receiver's dwNumRoutes field as a Smalltalk object."

	^(bytes dwordAtOffset: 88)!

dwOutDiscards
	"Answer the receiver's dwOutDiscards field as a Smalltalk object."

	^(bytes dwordAtOffset: 44)!

dwOutNoRoutes
	"Answer the receiver's dwOutNoRoutes field as a Smalltalk object."

	^(bytes dwordAtOffset: 48)!

dwOutRequests
	"Answer the receiver's dwOutRequests field as a Smalltalk object."

	^(bytes dwordAtOffset: 36)!

dwReasmFails
	"Answer the receiver's dwReasmFails field as a Smalltalk object."

	^(bytes dwordAtOffset: 64)!

dwReasmOks
	"Answer the receiver's dwReasmOks field as a Smalltalk object."

	^(bytes dwordAtOffset: 60)!

dwReasmReqds
	"Answer the receiver's dwReasmReqds field as a Smalltalk object."

	^(bytes dwordAtOffset: 56)!

dwReasmTimeout
	"Answer the receiver's dwReasmTimeout field as a Smalltalk object."

	^(bytes dwordAtOffset: 52)!

dwRoutingDiscards
	"Answer the receiver's dwRoutingDiscards field as a Smalltalk object."

	^(bytes dwordAtOffset: 40)! !
!MIB_IPSTATS categoriesFor: #dwDefaultTTL!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwForwarding!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwForwDatagrams!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwFragCreates!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwFragFails!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwFragOks!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwInAddrErrors!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwInDelivers!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwInDiscards!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwInHdrErrors!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwInReceives!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwInUnknownProtos!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwNumAddr!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwNumIf!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwNumRoutes!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwOutDiscards!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwOutNoRoutes!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwOutRequests!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwReasmFails!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwReasmOks!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwReasmReqds!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwReasmTimeout!**compiled accessors**!public! !
!MIB_IPSTATS categoriesFor: #dwRoutingDiscards!**compiled accessors**!public! !

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
	self byteSize: 92! !
!MIB_IPSTATS class categoriesFor: #defineFields!initializing!public! !

