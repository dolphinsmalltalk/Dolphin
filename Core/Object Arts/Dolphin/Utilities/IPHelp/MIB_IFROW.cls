"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #MIB_IFROW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IFROW guid: (GUID fromString: '{6ead7710-bab6-4715-a112-b56e9b66d9ee}')!
MIB_IFROW comment: '<MIB_IFROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IFROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagMIB_IFROW {
	unsigned short wszName[256];
	unsigned long dwIndex;
	unsigned long dwType;
	unsigned long dwMtu;
	unsigned long dwSpeed;
	unsigned long dwPhysAddrLen;
	BYTE bPhysAddr[8];
	unsigned long dwAdminStatus;
	unsigned long dwOperStatus;
	unsigned long dwLastChange;
	unsigned long dwInOctets;
	unsigned long dwInUcastPkts;
	unsigned long dwInNUcastPkts;
	unsigned long dwInDiscards;
	unsigned long dwInErrors;
	unsigned long dwInUnknownProtos;
	unsigned long dwOutOctets;
	unsigned long dwOutUcastPkts;
	unsigned long dwOutNUcastPkts;
	unsigned long dwOutDiscards;
	unsigned long dwOutErrors;
	unsigned long dwOutQLen;
	unsigned long dwDescrLen;
	BYTE bDescr[256];
} MIB_IFROW;
'!
!MIB_IFROW categoriesForClass!Win32-Structs! !
!MIB_IFROW methodsFor!

bDescr
	"Answer the receiver's bDescr field as a Smalltalk object."

	^ByteArray fromAddress: (bytes yourAddress + 604) length: 256!

bPhysAddr
	"Answer the receiver's bPhysAddr field as a Smalltalk object."

	^ByteArray fromAddress: (bytes yourAddress + 532) length: 8!

dwAdminStatus
	"Answer the receiver's dwAdminStatus field as a Smalltalk object."

	^(bytes dwordAtOffset: 540)!

dwDescrLen
	"Answer the receiver's dwDescrLen field as a Smalltalk object."

	^(bytes dwordAtOffset: 600)!

dwIndex
	"Answer the receiver's dwIndex field as a Smalltalk object."

	^(bytes dwordAtOffset: 512)!

dwInDiscards
	"Answer the receiver's dwInDiscards field as a Smalltalk object."

	^(bytes dwordAtOffset: 564)!

dwInErrors
	"Answer the receiver's dwInErrors field as a Smalltalk object."

	^(bytes dwordAtOffset: 568)!

dwInNUcastPkts
	"Answer the receiver's dwInNUcastPkts field as a Smalltalk object."

	^(bytes dwordAtOffset: 560)!

dwInOctets
	"Answer the receiver's dwInOctets field as a Smalltalk object."

	^(bytes dwordAtOffset: 552)!

dwInUcastPkts
	"Answer the receiver's dwInUcastPkts field as a Smalltalk object."

	^(bytes dwordAtOffset: 556)!

dwInUnknownProtos
	"Answer the receiver's dwInUnknownProtos field as a Smalltalk object."

	^(bytes dwordAtOffset: 572)!

dwLastChange
	"Answer the receiver's dwLastChange field as a Smalltalk object."

	^(bytes dwordAtOffset: 548)!

dwMtu
	"Answer the receiver's dwMtu field as a Smalltalk object."

	^(bytes dwordAtOffset: 520)!

dwOperStatus
	"Answer the receiver's dwOperStatus field as a Smalltalk object."

	^(bytes dwordAtOffset: 544)!

dwOutDiscards
	"Answer the receiver's dwOutDiscards field as a Smalltalk object."

	^(bytes dwordAtOffset: 588)!

dwOutErrors
	"Answer the receiver's dwOutErrors field as a Smalltalk object."

	^(bytes dwordAtOffset: 592)!

dwOutNUcastPkts
	"Answer the receiver's dwOutNUcastPkts field as a Smalltalk object."

	^(bytes dwordAtOffset: 584)!

dwOutOctets
	"Answer the receiver's dwOutOctets field as a Smalltalk object."

	^(bytes dwordAtOffset: 576)!

dwOutQLen
	"Answer the receiver's dwOutQLen field as a Smalltalk object."

	^(bytes dwordAtOffset: 596)!

dwOutUcastPkts
	"Answer the receiver's dwOutUcastPkts field as a Smalltalk object."

	^(bytes dwordAtOffset: 580)!

dwPhysAddrLen
	"Answer the receiver's dwPhysAddrLen field as a Smalltalk object."

	^(bytes dwordAtOffset: 528)!

dwSpeed
	"Answer the receiver's dwSpeed field as a Smalltalk object."

	^(bytes dwordAtOffset: 524)!

dwType
	"Answer the receiver's dwType field as a Smalltalk object."

	^(bytes dwordAtOffset: 516)!

wszName
	"Answer the receiver's wszName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes yourAddress)! !
!MIB_IFROW categoriesFor: #bDescr!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #bPhysAddr!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwAdminStatus!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwDescrLen!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwIndex!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwInDiscards!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwInErrors!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwInNUcastPkts!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwInOctets!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwInUcastPkts!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwInUnknownProtos!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwLastChange!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwMtu!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwOperStatus!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwOutDiscards!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwOutErrors!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwOutNUcastPkts!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwOutOctets!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwOutQLen!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwOutUcastPkts!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwPhysAddrLen!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwSpeed!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #dwType!**compiled accessors**!public! !
!MIB_IFROW categoriesFor: #wszName!**compiled accessors**!public! !

!MIB_IFROW class methodsFor!

defineFields
	"Define the fields of the MIB_IFROW structure.
		MIB_IFROW compileDefinition
	
		typedef 
		struct tagMIB_IFROW {
			unsigned short wszName[256];
			unsigned long dwIndex;
			unsigned long dwType;
			unsigned long dwMtu;
			unsigned long dwSpeed;
			unsigned long dwPhysAddrLen;
			BYTE bPhysAddr[8];
			unsigned long dwAdminStatus;
			unsigned long dwOperStatus;
			unsigned long dwLastChange;
			unsigned long dwInOctets;
			unsigned long dwInUcastPkts;
			unsigned long dwInNUcastPkts;
			unsigned long dwInDiscards;
			unsigned long dwInErrors;
			unsigned long dwInUnknownProtos;
			unsigned long dwOutOctets;
			unsigned long dwOutUcastPkts;
			unsigned long dwOutNUcastPkts;
			unsigned long dwOutDiscards;
			unsigned long dwOutErrors;
			unsigned long dwOutQLen;
			unsigned long dwDescrLen;
			BYTE bDescr[256];
		} MIB_IFROW;
"

	self
		defineField: #wszName
			type: ((StringField type: UnicodeString length: 256)
					beReadOnly;
					yourself)
			offset: 0;
		defineField: #dwIndex
			type: DWORDField readOnly
			offset: 512;
		defineField: #dwType
			type: DWORDField readOnly
			offset: 516;
		defineField: #dwMtu
			type: DWORDField readOnly
			offset: 520;
		defineField: #dwSpeed
			type: DWORDField readOnly
			offset: 524;
		defineField: #dwPhysAddrLen
			type: DWORDField readOnly
			offset: 528;
		defineField: #bPhysAddr
			type: ((ArrayField type: ByteArray length: 8)
					beReadOnly;
					yourself)
			offset: 532;
		defineField: #dwAdminStatus
			type: DWORDField readOnly
			offset: 540;
		defineField: #dwOperStatus
			type: DWORDField readOnly
			offset: 544;
		defineField: #dwLastChange
			type: DWORDField readOnly
			offset: 548;
		defineField: #dwInOctets
			type: DWORDField readOnly
			offset: 552;
		defineField: #dwInUcastPkts
			type: DWORDField readOnly
			offset: 556;
		defineField: #dwInNUcastPkts
			type: DWORDField readOnly
			offset: 560;
		defineField: #dwInDiscards
			type: DWORDField readOnly
			offset: 564;
		defineField: #dwInErrors
			type: DWORDField readOnly
			offset: 568;
		defineField: #dwInUnknownProtos
			type: DWORDField readOnly
			offset: 572;
		defineField: #dwOutOctets
			type: DWORDField readOnly
			offset: 576;
		defineField: #dwOutUcastPkts
			type: DWORDField readOnly
			offset: 580;
		defineField: #dwOutNUcastPkts
			type: DWORDField readOnly
			offset: 584;
		defineField: #dwOutDiscards
			type: DWORDField readOnly
			offset: 588;
		defineField: #dwOutErrors
			type: DWORDField readOnly
			offset: 592;
		defineField: #dwOutQLen
			type: DWORDField readOnly
			offset: 596;
		defineField: #dwDescrLen
			type: DWORDField readOnly
			offset: 600;
		defineField: #bDescr
			type: ((ArrayField type: ByteArray length: 256)
					beReadOnly;
					yourself)
			offset: 604.
	self byteSize: 860! !
!MIB_IFROW class categoriesFor: #defineFields!initializing!public! !

