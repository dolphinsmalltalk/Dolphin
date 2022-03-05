"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #MIB_IFROW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_bDescr _OffsetOf_bPhysAddr _OffsetOf_dwAdminStatus _OffsetOf_dwDescrLen _OffsetOf_dwIndex _OffsetOf_dwInDiscards _OffsetOf_dwInErrors _OffsetOf_dwInNUcastPkts _OffsetOf_dwInOctets _OffsetOf_dwInUcastPkts _OffsetOf_dwInUnknownProtos _OffsetOf_dwLastChange _OffsetOf_dwMtu _OffsetOf_dwOperStatus _OffsetOf_dwOutDiscards _OffsetOf_dwOutErrors _OffsetOf_dwOutNUcastPkts _OffsetOf_dwOutOctets _OffsetOf_dwOutQLen _OffsetOf_dwOutUcastPkts _OffsetOf_dwPhysAddrLen _OffsetOf_dwSpeed _OffsetOf_dwType _OffsetOf_wszName'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MIB_IFROW guid: (GUID fromString: '{6ead7710-bab6-4715-a112-b56e9b66d9ee}')!
MIB_IFROW addClassConstant: '_OffsetOf_bDescr' value: 16r25C!
MIB_IFROW addClassConstant: '_OffsetOf_bPhysAddr' value: 16r214!
MIB_IFROW addClassConstant: '_OffsetOf_dwAdminStatus' value: 16r21C!
MIB_IFROW addClassConstant: '_OffsetOf_dwDescrLen' value: 16r258!
MIB_IFROW addClassConstant: '_OffsetOf_dwIndex' value: 16r200!
MIB_IFROW addClassConstant: '_OffsetOf_dwInDiscards' value: 16r234!
MIB_IFROW addClassConstant: '_OffsetOf_dwInErrors' value: 16r238!
MIB_IFROW addClassConstant: '_OffsetOf_dwInNUcastPkts' value: 16r230!
MIB_IFROW addClassConstant: '_OffsetOf_dwInOctets' value: 16r228!
MIB_IFROW addClassConstant: '_OffsetOf_dwInUcastPkts' value: 16r22C!
MIB_IFROW addClassConstant: '_OffsetOf_dwInUnknownProtos' value: 16r23C!
MIB_IFROW addClassConstant: '_OffsetOf_dwLastChange' value: 16r224!
MIB_IFROW addClassConstant: '_OffsetOf_dwMtu' value: 16r208!
MIB_IFROW addClassConstant: '_OffsetOf_dwOperStatus' value: 16r220!
MIB_IFROW addClassConstant: '_OffsetOf_dwOutDiscards' value: 16r24C!
MIB_IFROW addClassConstant: '_OffsetOf_dwOutErrors' value: 16r250!
MIB_IFROW addClassConstant: '_OffsetOf_dwOutNUcastPkts' value: 16r248!
MIB_IFROW addClassConstant: '_OffsetOf_dwOutOctets' value: 16r240!
MIB_IFROW addClassConstant: '_OffsetOf_dwOutQLen' value: 16r254!
MIB_IFROW addClassConstant: '_OffsetOf_dwOutUcastPkts' value: 16r244!
MIB_IFROW addClassConstant: '_OffsetOf_dwPhysAddrLen' value: 16r210!
MIB_IFROW addClassConstant: '_OffsetOf_dwSpeed' value: 16r20C!
MIB_IFROW addClassConstant: '_OffsetOf_dwType' value: 16r204!
MIB_IFROW addClassConstant: '_OffsetOf_wszName' value: 16r0!
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
	"Answer the <ByteArray> value of the receiver's 'bDescr' field."

	^ByteArray fromAddress: bytes yourAddress + _OffsetOf_bDescr length: 256!

bPhysAddr
	"Answer the <ByteArray> value of the receiver's 'bPhysAddr' field."

	^ByteArray fromAddress: bytes yourAddress + _OffsetOf_bPhysAddr length: 8!

dwAdminStatus
	"Answer the <Integer> value of the receiver's 'dwAdminStatus' field."

	^bytes dwordAtOffset: _OffsetOf_dwAdminStatus!

dwDescrLen
	"Answer the <Integer> value of the receiver's 'dwDescrLen' field."

	^bytes dwordAtOffset: _OffsetOf_dwDescrLen!

dwIndex
	"Answer the <Integer> value of the receiver's 'dwIndex' field."

	^bytes dwordAtOffset: _OffsetOf_dwIndex!

dwInDiscards
	"Answer the <Integer> value of the receiver's 'dwInDiscards' field."

	^bytes dwordAtOffset: _OffsetOf_dwInDiscards!

dwInErrors
	"Answer the <Integer> value of the receiver's 'dwInErrors' field."

	^bytes dwordAtOffset: _OffsetOf_dwInErrors!

dwInNUcastPkts
	"Answer the <Integer> value of the receiver's 'dwInNUcastPkts' field."

	^bytes dwordAtOffset: _OffsetOf_dwInNUcastPkts!

dwInOctets
	"Answer the <Integer> value of the receiver's 'dwInOctets' field."

	^bytes dwordAtOffset: _OffsetOf_dwInOctets!

dwInUcastPkts
	"Answer the <Integer> value of the receiver's 'dwInUcastPkts' field."

	^bytes dwordAtOffset: _OffsetOf_dwInUcastPkts!

dwInUnknownProtos
	"Answer the <Integer> value of the receiver's 'dwInUnknownProtos' field."

	^bytes dwordAtOffset: _OffsetOf_dwInUnknownProtos!

dwLastChange
	"Answer the <Integer> value of the receiver's 'dwLastChange' field."

	^bytes dwordAtOffset: _OffsetOf_dwLastChange!

dwMtu
	"Answer the <Integer> value of the receiver's 'dwMtu' field."

	^bytes dwordAtOffset: _OffsetOf_dwMtu!

dwOperStatus
	"Answer the <Integer> value of the receiver's 'dwOperStatus' field."

	^bytes dwordAtOffset: _OffsetOf_dwOperStatus!

dwOutDiscards
	"Answer the <Integer> value of the receiver's 'dwOutDiscards' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutDiscards!

dwOutErrors
	"Answer the <Integer> value of the receiver's 'dwOutErrors' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutErrors!

dwOutNUcastPkts
	"Answer the <Integer> value of the receiver's 'dwOutNUcastPkts' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutNUcastPkts!

dwOutOctets
	"Answer the <Integer> value of the receiver's 'dwOutOctets' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutOctets!

dwOutQLen
	"Answer the <Integer> value of the receiver's 'dwOutQLen' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutQLen!

dwOutUcastPkts
	"Answer the <Integer> value of the receiver's 'dwOutUcastPkts' field."

	^bytes dwordAtOffset: _OffsetOf_dwOutUcastPkts!

dwPhysAddrLen
	"Answer the <Integer> value of the receiver's 'dwPhysAddrLen' field."

	^bytes dwordAtOffset: _OffsetOf_dwPhysAddrLen!

dwSpeed
	"Answer the <Integer> value of the receiver's 'dwSpeed' field."

	^bytes dwordAtOffset: _OffsetOf_dwSpeed!

dwType
	"Answer the <Integer> value of the receiver's 'dwType' field."

	^bytes dwordAtOffset: _OffsetOf_dwType!

wszName
	"Answer the <Utf16String> value of the receiver's 'wszName' field."

	^Utf16String fromAddress: bytes yourAddress! !
!MIB_IFROW categoriesForMethods!
bDescr!**compiled accessors**!public! !
bPhysAddr!**compiled accessors**!public! !
dwAdminStatus!**compiled accessors**!public! !
dwDescrLen!**compiled accessors**!public! !
dwIndex!**compiled accessors**!public! !
dwInDiscards!**compiled accessors**!public! !
dwInErrors!**compiled accessors**!public! !
dwInNUcastPkts!**compiled accessors**!public! !
dwInOctets!**compiled accessors**!public! !
dwInUcastPkts!**compiled accessors**!public! !
dwInUnknownProtos!**compiled accessors**!public! !
dwLastChange!**compiled accessors**!public! !
dwMtu!**compiled accessors**!public! !
dwOperStatus!**compiled accessors**!public! !
dwOutDiscards!**compiled accessors**!public! !
dwOutErrors!**compiled accessors**!public! !
dwOutNUcastPkts!**compiled accessors**!public! !
dwOutOctets!**compiled accessors**!public! !
dwOutQLen!**compiled accessors**!public! !
dwOutUcastPkts!**compiled accessors**!public! !
dwPhysAddrLen!**compiled accessors**!public! !
dwSpeed!**compiled accessors**!public! !
dwType!**compiled accessors**!public! !
wszName!**compiled accessors**!public! !
!

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
			type: ((StringField type: Utf16String length: 256)
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
	self byteSize: 860!

getFieldNames
	^#(#wszName #dwIndex #dwType #dwMtu #dwSpeed #dwPhysAddrLen #bPhysAddr #dwAdminStatus #dwOperStatus #dwLastChange #dwInOctets #dwInUcastPkts #dwInNUcastPkts #dwInDiscards #dwInErrors #dwInUnknownProtos #dwOutOctets #dwOutUcastPkts #dwOutNUcastPkts #dwOutDiscards #dwOutErrors #dwOutQLen #dwDescrLen #bDescr)! !
!MIB_IFROW class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

