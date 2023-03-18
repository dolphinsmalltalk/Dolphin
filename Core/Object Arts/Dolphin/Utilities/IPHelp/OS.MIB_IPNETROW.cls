"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.MIB_IPNETROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_MIB_IPNETROW_Size' -> 16r18.
			'_OffsetOf_bPhysAddr' -> 16r8.
			'_OffsetOf_dwAddr' -> 16r10.
			'_OffsetOf_dwIndex' -> 16r0.
			'_OffsetOf_dwPhysAddrLen' -> 16r4.
			'_OffsetOf_dwType' -> 16r14
		}!
OS.MIB_IPNETROW guid: (Core.GUID fromString: '{5aa4fcea-d4da-49bb-a756-7ca522c111d3}')!
OS.MIB_IPNETROW comment: '<MIB_IPNETROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPNETROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IPNETROW {
	unsigned long dwIndex;
	unsigned long dwPhysAddrLen;
	BYTE bPhysAddr[8];
	unsigned long dwAddr;
	unsigned long dwType;
} MIB_IPNETROW;
'!
!OS.MIB_IPNETROW categoriesForClass!Win32-Structs! !
!OS.MIB_IPNETROW methodsFor!

bPhysAddr
	"Answer the <ByteArray> value of the receiver's 'bPhysAddr' field."

	^ByteArray fromAddress: bytes yourAddress + _OffsetOf_bPhysAddr length: 8!

dwAddr
	"Answer the <Integer> value of the receiver's 'dwAddr' field."

	^bytes uint32AtOffset: _OffsetOf_dwAddr!

dwIndex
	"Answer the <Integer> value of the receiver's 'dwIndex' field."

	^bytes uint32AtOffset: _OffsetOf_dwIndex!

dwPhysAddrLen
	"Answer the <Integer> value of the receiver's 'dwPhysAddrLen' field."

	^bytes uint32AtOffset: _OffsetOf_dwPhysAddrLen!

dwType
	"Answer the <Integer> value of the receiver's 'dwType' field."

	^bytes uint32AtOffset: _OffsetOf_dwType! !
!OS.MIB_IPNETROW categoriesForMethods!
bPhysAddr!**compiled accessors**!public! !
dwAddr!**compiled accessors**!public! !
dwIndex!**compiled accessors**!public! !
dwPhysAddrLen!**compiled accessors**!public! !
dwType!**compiled accessors**!public! !
!

!OS.MIB_IPNETROW class methodsFor!

byteSize
	^_MIB_IPNETROW_Size!

defineFields
	"Define the fields of the MIB_IPNETROW structure.
		MIB_IPNETROW compileDefinition
	
		typedef 
		struct tagMIB_IPNETROW {
			unsigned long dwIndex;
			unsigned long dwPhysAddrLen;
			BYTE bPhysAddr[8];
			unsigned long dwAddr;
			unsigned long dwType;
		} MIB_IPNETROW;
"

	self
		defineField: #dwIndex
			type: UInt32Field readOnly
			offset: 0;
		defineField: #dwPhysAddrLen
			type: UInt32Field readOnly
			offset: 4;
		defineField: #bPhysAddr
			type: ((ArrayField type: ByteArray length: 8)
					beReadOnly;
					yourself)
			offset: 8;
		defineField: #dwAddr
			type: UInt32Field readOnly
			offset: 16;
		defineField: #dwType
			type: UInt32Field readOnly
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#dwIndex #dwPhysAddrLen #bPhysAddr #dwAddr #dwType)! !
!OS.MIB_IPNETROW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

