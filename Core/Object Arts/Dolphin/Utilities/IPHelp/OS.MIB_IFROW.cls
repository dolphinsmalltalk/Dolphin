"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.MIB_IFROW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_bDescr' -> 16r25C.
		'_OffsetOf_bPhysAddr' -> 16r214.
		'_OffsetOf_dwAdminStatus' -> 16r21C.
		'_OffsetOf_dwDescrLen' -> 16r258.
		'_OffsetOf_dwIndex' -> 16r200.
		'_OffsetOf_dwInDiscards' -> 16r234.
		'_OffsetOf_dwInErrors' -> 16r238.
		'_OffsetOf_dwInNUcastPkts' -> 16r230.
		'_OffsetOf_dwInOctets' -> 16r228.
		'_OffsetOf_dwInUcastPkts' -> 16r22C.
		'_OffsetOf_dwInUnknownProtos' -> 16r23C.
		'_OffsetOf_dwLastChange' -> 16r224.
		'_OffsetOf_dwMtu' -> 16r208.
		'_OffsetOf_dwOperStatus' -> 16r220.
		'_OffsetOf_dwOutDiscards' -> 16r24C.
		'_OffsetOf_dwOutErrors' -> 16r250.
		'_OffsetOf_dwOutNUcastPkts' -> 16r248.
		'_OffsetOf_dwOutOctets' -> 16r240.
		'_OffsetOf_dwOutQLen' -> 16r254.
		'_OffsetOf_dwOutUcastPkts' -> 16r244.
		'_OffsetOf_dwPhysAddrLen' -> 16r210.
		'_OffsetOf_dwSpeed' -> 16r20C.
		'_OffsetOf_dwType' -> 16r204.
		'_OffsetOf_wszName' -> 16r0
	}!
OS.MIB_IFROW guid: (Core.GUID fromString: '{6ead7710-bab6-4715-a112-b56e9b66d9ee}')!
OS.MIB_IFROW comment: '<MIB_IFROW> is an <ExternalStructure> class to wrap the struct ''Win32.MIB_IFROW'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!OS.MIB_IFROW categoriesForClass!Win32-Structs! !
!OS.MIB_IFROW methodsFor!

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
!OS.MIB_IFROW categoriesFor: #bDescr!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #bPhysAddr!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwAdminStatus!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwDescrLen!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwIndex!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwInDiscards!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwInErrors!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwInNUcastPkts!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwInOctets!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwInUcastPkts!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwInUnknownProtos!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwLastChange!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwMtu!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwOperStatus!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwOutDiscards!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwOutErrors!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwOutNUcastPkts!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwOutOctets!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwOutQLen!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwOutUcastPkts!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwPhysAddrLen!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwSpeed!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #dwType!**compiled accessors**!public! !
!OS.MIB_IFROW categoriesFor: #wszName!**compiled accessors**!public! !

!OS.MIB_IFROW class methodsFor!

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
!OS.MIB_IFROW class categoriesFor: #defineFields!initializing!public! !
!OS.MIB_IFROW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

