"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MIB_IPFORWARDROW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IPFORWARDROW guid: (GUID fromString: '{4E46D963-9A91-4E1A-B1EB-A9597B841A59}')!
MIB_IPFORWARDROW comment: '<MIB_IPFORWARDROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPFORWARDROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IPFORWARDROW {
	unsigned long dwForwardDest;
	unsigned long dwForwardMask;
	unsigned long dwForwardPolicy;
	unsigned long dwForwardNextHop;
	unsigned long dwForwardIfIndex;
	unsigned long dwForwardType;
	unsigned long dwForwardProto;
	unsigned long dwForwardAge;
	unsigned long dwForwardNextHopAS;
	unsigned long dwForwardMetric1;
	unsigned long dwForwardMetric2;
	unsigned long dwForwardMetric3;
	unsigned long dwForwardMetric4;
	unsigned long dwForwardMetric5;
} MIB_IPFORWARDROW;
'!
!MIB_IPFORWARDROW categoriesForClass!Win32-Structs! !
!MIB_IPFORWARDROW methodsFor!

dwForwardAge
	"Answer the receiver's dwForwardAge field as a Smalltalk object."

	^(bytes dwordAtOffset: 28)!

dwForwardDest
	"Answer the receiver's dwForwardDest field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwForwardIfIndex
	"Answer the receiver's dwForwardIfIndex field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dwForwardMask
	"Answer the receiver's dwForwardMask field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwForwardMetric1
	"Answer the receiver's dwForwardMetric1 field as a Smalltalk object."

	^(bytes dwordAtOffset: 36)!

dwForwardMetric2
	"Answer the receiver's dwForwardMetric2 field as a Smalltalk object."

	^(bytes dwordAtOffset: 40)!

dwForwardMetric3
	"Answer the receiver's dwForwardMetric3 field as a Smalltalk object."

	^(bytes dwordAtOffset: 44)!

dwForwardMetric4
	"Answer the receiver's dwForwardMetric4 field as a Smalltalk object."

	^(bytes dwordAtOffset: 48)!

dwForwardMetric5
	"Answer the receiver's dwForwardMetric5 field as a Smalltalk object."

	^(bytes dwordAtOffset: 52)!

dwForwardNextHop
	"Answer the receiver's dwForwardNextHop field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

dwForwardNextHopAS
	"Answer the receiver's dwForwardNextHopAS field as a Smalltalk object."

	^(bytes dwordAtOffset: 32)!

dwForwardPolicy
	"Answer the receiver's dwForwardPolicy field as a Smalltalk object."

	^(bytes dwordAtOffset: 8)!

dwForwardProto
	"Answer the receiver's dwForwardProto field as a Smalltalk object."

	^(bytes dwordAtOffset: 24)!

dwForwardType
	"Answer the receiver's dwForwardType field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardAge!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardDest!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardIfIndex!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardMask!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardMetric1!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardMetric2!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardMetric3!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardMetric4!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardMetric5!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardNextHop!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardNextHopAS!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardPolicy!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardProto!**compiled accessors**!public! !
!MIB_IPFORWARDROW categoriesFor: #dwForwardType!**compiled accessors**!public! !

!MIB_IPFORWARDROW class methodsFor!

defineFields
	"Define the fields of the MIB_IPFORWARDROW structure.
		MIB_IPFORWARDROW compileDefinition
	
		typedef 
		struct tagMIB_IPFORWARDROW {
			unsigned long dwForwardDest;
			unsigned long dwForwardMask;
			unsigned long dwForwardPolicy;
			unsigned long dwForwardNextHop;
			unsigned long dwForwardIfIndex;
			unsigned long dwForwardType;
			unsigned long dwForwardProto;
			unsigned long dwForwardAge;
			unsigned long dwForwardNextHopAS;
			unsigned long dwForwardMetric1;
			unsigned long dwForwardMetric2;
			unsigned long dwForwardMetric3;
			unsigned long dwForwardMetric4;
			unsigned long dwForwardMetric5;
		} MIB_IPFORWARDROW;
"

	self
		defineField: #dwForwardDest
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwForwardMask
			type: DWORDField readOnly
			offset: 4;
		defineField: #dwForwardPolicy
			type: DWORDField readOnly
			offset: 8;
		defineField: #dwForwardNextHop
			type: DWORDField readOnly
			offset: 12;
		defineField: #dwForwardIfIndex
			type: DWORDField readOnly
			offset: 16;
		defineField: #dwForwardType
			type: DWORDField readOnly
			offset: 20;
		defineField: #dwForwardProto
			type: DWORDField readOnly
			offset: 24;
		defineField: #dwForwardAge
			type: DWORDField readOnly
			offset: 28;
		defineField: #dwForwardNextHopAS
			type: DWORDField readOnly
			offset: 32;
		defineField: #dwForwardMetric1
			type: DWORDField readOnly
			offset: 36;
		defineField: #dwForwardMetric2
			type: DWORDField readOnly
			offset: 40;
		defineField: #dwForwardMetric3
			type: DWORDField readOnly
			offset: 44;
		defineField: #dwForwardMetric4
			type: DWORDField readOnly
			offset: 48;
		defineField: #dwForwardMetric5
			type: DWORDField readOnly
			offset: 52.
	self byteSize: 56! !
!MIB_IPFORWARDROW class categoriesFor: #defineFields!initializing!public! !

