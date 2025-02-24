﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.MIB_IPFORWARDROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MIB_IPFORWARDROW_Size' -> 16r38.
			'_OffsetOf_dwForwardAge' -> 16r1C.
			'_OffsetOf_dwForwardDest' -> 16r0.
			'_OffsetOf_dwForwardIfIndex' -> 16r10.
			'_OffsetOf_dwForwardMask' -> 16r4.
			'_OffsetOf_dwForwardMetric1' -> 16r24.
			'_OffsetOf_dwForwardMetric2' -> 16r28.
			'_OffsetOf_dwForwardMetric3' -> 16r2C.
			'_OffsetOf_dwForwardMetric4' -> 16r30.
			'_OffsetOf_dwForwardMetric5' -> 16r34.
			'_OffsetOf_dwForwardNextHop' -> 16rC.
			'_OffsetOf_dwForwardNextHopAS' -> 16r20.
			'_OffsetOf_dwForwardPolicy' -> 16r8.
			'_OffsetOf_dwForwardProto' -> 16r18.
			'_OffsetOf_dwForwardType' -> 16r14
		}!

OS.MIB_IPFORWARDROW guid: (Core.GUID fromString: '{4e46d963-9a91-4e1a-b1eb-a9597b841a59}')!

OS.MIB_IPFORWARDROW comment: '<MIB_IPFORWARDROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPFORWARDROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!OS.MIB_IPFORWARDROW categoriesForClass!Win32-Structs! !

!OS.MIB_IPFORWARDROW methodsFor!

dwForwardAge
	"Answer the <Integer> value of the receiver's 'dwForwardAge' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardAge!

dwForwardDest
	"Answer the <Integer> value of the receiver's 'dwForwardDest' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardDest!

dwForwardIfIndex
	"Answer the <Integer> value of the receiver's 'dwForwardIfIndex' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardIfIndex!

dwForwardMask
	"Answer the <Integer> value of the receiver's 'dwForwardMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardMask!

dwForwardMetric1
	"Answer the <Integer> value of the receiver's 'dwForwardMetric1' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardMetric1!

dwForwardMetric2
	"Answer the <Integer> value of the receiver's 'dwForwardMetric2' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardMetric2!

dwForwardMetric3
	"Answer the <Integer> value of the receiver's 'dwForwardMetric3' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardMetric3!

dwForwardMetric4
	"Answer the <Integer> value of the receiver's 'dwForwardMetric4' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardMetric4!

dwForwardMetric5
	"Answer the <Integer> value of the receiver's 'dwForwardMetric5' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardMetric5!

dwForwardNextHop
	"Answer the <Integer> value of the receiver's 'dwForwardNextHop' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardNextHop!

dwForwardNextHopAS
	"Answer the <Integer> value of the receiver's 'dwForwardNextHopAS' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardNextHopAS!

dwForwardPolicy
	"Answer the <Integer> value of the receiver's 'dwForwardPolicy' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardPolicy!

dwForwardProto
	"Answer the <Integer> value of the receiver's 'dwForwardProto' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardProto!

dwForwardType
	"Answer the <Integer> value of the receiver's 'dwForwardType' field."

	^bytes uint32AtOffset: _OffsetOf_dwForwardType! !

!OS.MIB_IPFORWARDROW categoriesForMethods!
dwForwardAge!**compiled accessors**!public! !
dwForwardDest!**compiled accessors**!public! !
dwForwardIfIndex!**compiled accessors**!public! !
dwForwardMask!**compiled accessors**!public! !
dwForwardMetric1!**compiled accessors**!public! !
dwForwardMetric2!**compiled accessors**!public! !
dwForwardMetric3!**compiled accessors**!public! !
dwForwardMetric4!**compiled accessors**!public! !
dwForwardMetric5!**compiled accessors**!public! !
dwForwardNextHop!**compiled accessors**!public! !
dwForwardNextHopAS!**compiled accessors**!public! !
dwForwardPolicy!**compiled accessors**!public! !
dwForwardProto!**compiled accessors**!public! !
dwForwardType!**compiled accessors**!public! !
!

!OS.MIB_IPFORWARDROW class methodsFor!

byteSize
	^_MIB_IPFORWARDROW_Size!

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
			type: UInt32Field readOnly
			offset: 0;
		defineField: #dwForwardMask
			type: UInt32Field readOnly
			offset: 4;
		defineField: #dwForwardPolicy
			type: UInt32Field readOnly
			offset: 8;
		defineField: #dwForwardNextHop
			type: UInt32Field readOnly
			offset: 12;
		defineField: #dwForwardIfIndex
			type: UInt32Field readOnly
			offset: 16;
		defineField: #dwForwardType
			type: UInt32Field readOnly
			offset: 20;
		defineField: #dwForwardProto
			type: UInt32Field readOnly
			offset: 24;
		defineField: #dwForwardAge
			type: UInt32Field readOnly
			offset: 28;
		defineField: #dwForwardNextHopAS
			type: UInt32Field readOnly
			offset: 32;
		defineField: #dwForwardMetric1
			type: UInt32Field readOnly
			offset: 36;
		defineField: #dwForwardMetric2
			type: UInt32Field readOnly
			offset: 40;
		defineField: #dwForwardMetric3
			type: UInt32Field readOnly
			offset: 44;
		defineField: #dwForwardMetric4
			type: UInt32Field readOnly
			offset: 48;
		defineField: #dwForwardMetric5
			type: UInt32Field readOnly
			offset: 52.
	self byteSize: 56!

getFieldNames
	^#(#dwForwardDest #dwForwardMask #dwForwardPolicy #dwForwardNextHop #dwForwardIfIndex #dwForwardType #dwForwardProto #dwForwardAge #dwForwardNextHopAS #dwForwardMetric1 #dwForwardMetric2 #dwForwardMetric3 #dwForwardMetric4 #dwForwardMetric5)! !

!OS.MIB_IPFORWARDROW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

