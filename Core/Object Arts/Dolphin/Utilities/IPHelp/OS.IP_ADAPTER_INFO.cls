﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.IP_ADAPTER_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_IP_ADAPTER_INFO_Size' -> 16r280.
			'_OffsetOf_AdapterName' -> 16r8.
			'_OffsetOf_Address' -> 16r194.
			'_OffsetOf_AddressLength' -> 16r190.
			'_OffsetOf_ComboIndex' -> 16r4.
			'_OffsetOf_CurrentIpAddress' -> 16r1A8.
			'_OffsetOf_Description' -> 16r10C.
			'_OffsetOf_DhcpEnabled' -> 16r1A4.
			'_OffsetOf_DhcpServer' -> 16r1FC.
			'_OffsetOf_GatewayList' -> 16r1D4.
			'_OffsetOf_HaveWins' -> 16r224.
			'_OffsetOf_index' -> 16r19C.
			'_OffsetOf_IpAddressList' -> 16r1AC.
			'_OffsetOf_LeaseExpires' -> 16r27C.
			'_OffsetOf_LeaseObtained' -> 16r278.
			'_OffsetOf_Next' -> 16r0.
			'_OffsetOf_PrimaryWinsServer' -> 16r228.
			'_OffsetOf_SecondaryWinsServer' -> 16r250.
			'_OffsetOf_type' -> 16r1A0
		}!

OS.IP_ADAPTER_INFO guid: (Core.GUID fromString: '{30f77c44-1f24-4b31-9311-dc3a730c4d4e}')!

OS.IP_ADAPTER_INFO comment: '<IP_ADAPTER_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.IP_ADAPTER_INFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagIP_ADAPTER_INFO {
	IP_ADAPTER_INFO* Next;
	unsigned long ComboIndex;
	CHAR AdapterName[260];
	CHAR Description[132];
	unsigned int AddressLength;
	BYTE Address[8];
	unsigned long index;
	unsigned int type;
	unsigned int DhcpEnabled;
	IP_ADDR_STRING* CurrentIpAddress;
	IP_ADDR_STRING IpAddressList;
	IP_ADDR_STRING GatewayList;
	IP_ADDR_STRING DhcpServer;
	long HaveWins;
	IP_ADDR_STRING PrimaryWinsServer;
	IP_ADDR_STRING SecondaryWinsServer;
	long LeaseObtained;
	long LeaseExpires;
} IP_ADAPTER_INFO;
'!

!OS.IP_ADAPTER_INFO categoriesForClass!Win32-Structs! !

!OS.IP_ADAPTER_INFO methodsFor!

AdapterName
	"Answer the <AnsiString> value of the receiver's 'AdapterName' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_AdapterName!

Address
	"Answer the <ByteArray> value of the receiver's 'Address' field."

	^ByteArray fromAddress: bytes yourAddress + _OffsetOf_Address length: 8!

AddressLength
	"Answer the <Integer> value of the receiver's 'AddressLength' field."

	^bytes uint32AtOffset: _OffsetOf_AddressLength!

ComboIndex
	"Answer the <Integer> value of the receiver's 'ComboIndex' field."

	^bytes uint32AtOffset: _OffsetOf_ComboIndex!

CurrentIpAddress
	"Answer the <IP_ADDR_STRING> value of the receiver's 'CurrentIpAddress' field."

	^IP_ADDR_STRING fromAddress: (bytes intPtrAtOffset: _OffsetOf_CurrentIpAddress)!

Description
	"Answer the <AnsiString> value of the receiver's 'Description' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_Description!

DhcpEnabled
	"Answer the <Integer> value of the receiver's 'DhcpEnabled' field."

	^bytes uint32AtOffset: _OffsetOf_DhcpEnabled!

DhcpServer
	"Answer the <IP_ADDR_STRING> value of the receiver's 'DhcpServer' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_DhcpServer!

GatewayList
	"Answer the <IP_ADDR_STRING> value of the receiver's 'GatewayList' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_GatewayList!

HaveWins
	"Answer the <Integer> value of the receiver's 'HaveWins' field."

	^bytes int32AtOffset: _OffsetOf_HaveWins!

index
	"Answer the <Integer> value of the receiver's 'index' field."

	^bytes uint32AtOffset: _OffsetOf_index!

IpAddressList
	"Answer the <IP_ADDR_STRING> value of the receiver's 'IpAddressList' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_IpAddressList!

LeaseExpires
	"Answer the <Integer> value of the receiver's 'LeaseExpires' field."

	^bytes int32AtOffset: _OffsetOf_LeaseExpires!

LeaseObtained
	"Answer the <Integer> value of the receiver's 'LeaseObtained' field."

	^bytes int32AtOffset: _OffsetOf_LeaseObtained!

Next
	"Answer the <IP_ADAPTER_INFO> value of the receiver's 'Next' field."

	^IP_ADAPTER_INFO fromAddress: (bytes intPtrAtOffset: _OffsetOf_Next)!

PrimaryWinsServer
	"Answer the <IP_ADDR_STRING> value of the receiver's 'PrimaryWinsServer' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_PrimaryWinsServer!

SecondaryWinsServer
	"Answer the <IP_ADDR_STRING> value of the receiver's 'SecondaryWinsServer' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_SecondaryWinsServer!

type
	"Answer the <Integer> value of the receiver's 'type' field."

	^bytes uint32AtOffset: _OffsetOf_type! !

!OS.IP_ADAPTER_INFO categoriesForMethods!
AdapterName!**compiled accessors**!public! !
Address!**compiled accessors**!public! !
AddressLength!**compiled accessors**!public! !
ComboIndex!**compiled accessors**!public! !
CurrentIpAddress!**compiled accessors**!public! !
Description!**compiled accessors**!public! !
DhcpEnabled!**compiled accessors**!public! !
DhcpServer!**compiled accessors**!public! !
GatewayList!**compiled accessors**!public! !
HaveWins!**compiled accessors**!public! !
index!**compiled accessors**!public! !
IpAddressList!**compiled accessors**!public! !
LeaseExpires!**compiled accessors**!public! !
LeaseObtained!**compiled accessors**!public! !
Next!**compiled accessors**!public! !
PrimaryWinsServer!**compiled accessors**!public! !
SecondaryWinsServer!**compiled accessors**!public! !
type!**compiled accessors**!public! !
!

!OS.IP_ADAPTER_INFO class methodsFor!

byteSize
	^_IP_ADAPTER_INFO_Size!

defineFields
	"Define the fields of the IP_ADAPTER_INFO structure.
		IP_ADAPTER_INFO compileDefinition
	
		typedef 
		struct tagIP_ADAPTER_INFO {
			IP_ADAPTER_INFO* Next;
			unsigned long ComboIndex;
			CHAR AdapterName[260];
			CHAR Description[132];
			unsigned int AddressLength;
			BYTE Address[8];
			unsigned long index;
			unsigned int type;
			unsigned int DhcpEnabled;
			IP_ADDR_STRING* CurrentIpAddress;
			IP_ADDR_STRING IpAddressList;
			IP_ADDR_STRING GatewayList;
			IP_ADDR_STRING DhcpServer;
			long HaveWins;
			IP_ADDR_STRING PrimaryWinsServer;
			IP_ADDR_STRING SecondaryWinsServer;
			long LeaseObtained;
			long LeaseExpires;
		} IP_ADAPTER_INFO;
"

	self
		defineField: #Next
			type: ((PointerField type: IP_ADAPTER_INFO)
					beReadOnly;
					yourself)
			offset: 0;
		defineField: #ComboIndex
			type: UInt32Field readOnly
			offset: 4;
		defineField: #AdapterName
			type: ((StringField length: 260)
					beReadOnly;
					yourself)
			offset: 8;
		defineField: #Description
			type: ((StringField length: 132)
					beReadOnly;
					yourself)
			offset: 268;
		defineField: #AddressLength
			type: UInt32Field readOnly
			offset: 400;
		defineField: #Address
			type: ((ArrayField type: ByteArray length: 8)
					beReadOnly;
					yourself)
			offset: 404;
		defineField: #index
			type: UInt32Field readOnly
			offset: 412;
		defineField: #type
			type: UInt32Field readOnly
			offset: 416;
		defineField: #DhcpEnabled
			type: UInt32Field readOnly
			offset: 420;
		defineField: #CurrentIpAddress
			type: ((PointerField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 424;
		defineField: #IpAddressList
			type: ((StructureField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 428;
		defineField: #GatewayList
			type: ((StructureField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 468;
		defineField: #DhcpServer
			type: ((StructureField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 508;
		defineField: #HaveWins
			type: Int32Field readOnly
			offset: 548;
		defineField: #PrimaryWinsServer
			type: ((StructureField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 552;
		defineField: #SecondaryWinsServer
			type: ((StructureField type: IP_ADDR_STRING)
					beReadOnly;
					yourself)
			offset: 592;
		defineField: #LeaseObtained
			type: Int32Field readOnly
			offset: 632;
		defineField: #LeaseExpires
			type: Int32Field readOnly
			offset: 636.
	self byteSize: 640!

getFieldNames
	^#(#Next #ComboIndex #AdapterName #Description #AddressLength #Address #index #type #DhcpEnabled #CurrentIpAddress #IpAddressList #GatewayList #DhcpServer #HaveWins #PrimaryWinsServer #SecondaryWinsServer #LeaseObtained #LeaseExpires)! !

!OS.IP_ADAPTER_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

