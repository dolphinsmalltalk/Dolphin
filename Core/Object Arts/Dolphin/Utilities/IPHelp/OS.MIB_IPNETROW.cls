"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.MIB_IPNETROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
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

	^bytes dwordAtOffset: _OffsetOf_dwAddr!

dwIndex
	"Answer the <Integer> value of the receiver's 'dwIndex' field."

	^bytes dwordAtOffset: _OffsetOf_dwIndex!

dwPhysAddrLen
	"Answer the <Integer> value of the receiver's 'dwPhysAddrLen' field."

	^bytes dwordAtOffset: _OffsetOf_dwPhysAddrLen!

dwType
	"Answer the <Integer> value of the receiver's 'dwType' field."

	^bytes dwordAtOffset: _OffsetOf_dwType! !
!OS.MIB_IPNETROW categoriesFor: #bPhysAddr!**compiled accessors**!public! !
!OS.MIB_IPNETROW categoriesFor: #dwAddr!**compiled accessors**!public! !
!OS.MIB_IPNETROW categoriesFor: #dwIndex!**compiled accessors**!public! !
!OS.MIB_IPNETROW categoriesFor: #dwPhysAddrLen!**compiled accessors**!public! !
!OS.MIB_IPNETROW categoriesFor: #dwType!**compiled accessors**!public! !

!OS.MIB_IPNETROW class methodsFor!

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
			type: DWORDField readOnly
			offset: 0;
		defineField: #dwPhysAddrLen
			type: DWORDField readOnly
			offset: 4;
		defineField: #bPhysAddr
			type: ((ArrayField type: ByteArray length: 8)
					beReadOnly;
					yourself)
			offset: 8;
		defineField: #dwAddr
			type: DWORDField readOnly
			offset: 16;
		defineField: #dwType
			type: DWORDField readOnly
			offset: 20.
	self byteSize: 24!

getFieldNames
	^#(#dwIndex #dwPhysAddrLen #bPhysAddr #dwAddr #dwType)! !
!OS.MIB_IPNETROW class categoriesFor: #defineFields!initializing!public! !
!OS.MIB_IPNETROW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

