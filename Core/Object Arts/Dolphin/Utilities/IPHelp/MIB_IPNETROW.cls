"Filed out from Dolphin Smalltalk X6"!

ExternalStructure subclass: #MIB_IPNETROW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IPNETROW guid: (GUID fromString: '{5AA4FCEA-D4DA-49BB-A756-7CA522C111D3}')!
MIB_IPNETROW comment: '<MIB_IPNETROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IPNETROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!MIB_IPNETROW categoriesForClass!Win32-Structs! !
!MIB_IPNETROW methodsFor!

bPhysAddr
	"Answer the receiver's bPhysAddr field as a Smalltalk object."

	^ByteArray fromAddress: (bytes yourAddress + 8) length: 8!

dwAddr
	"Answer the receiver's dwAddr field as a Smalltalk object."

	^(bytes dwordAtOffset: 16)!

dwIndex
	"Answer the receiver's dwIndex field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

dwPhysAddrLen
	"Answer the receiver's dwPhysAddrLen field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

dwType
	"Answer the receiver's dwType field as a Smalltalk object."

	^(bytes dwordAtOffset: 20)! !
!MIB_IPNETROW categoriesFor: #bPhysAddr!**compiled accessors**!public! !
!MIB_IPNETROW categoriesFor: #dwAddr!**compiled accessors**!public! !
!MIB_IPNETROW categoriesFor: #dwIndex!**compiled accessors**!public! !
!MIB_IPNETROW categoriesFor: #dwPhysAddrLen!**compiled accessors**!public! !
!MIB_IPNETROW categoriesFor: #dwType!**compiled accessors**!public! !

!MIB_IPNETROW class methodsFor!

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
	self byteSize: 24! !
!MIB_IPNETROW class categoriesFor: #defineFields!initializing!public! !

