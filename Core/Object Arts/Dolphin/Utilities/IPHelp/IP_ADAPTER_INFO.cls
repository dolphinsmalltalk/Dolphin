"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #IP_ADAPTER_INFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_AdapterName _OffsetOf_Address _OffsetOf_AddressLength _OffsetOf_ComboIndex _OffsetOf_CurrentIpAddress _OffsetOf_Description _OffsetOf_DhcpEnabled _OffsetOf_DhcpServer _OffsetOf_GatewayList _OffsetOf_HaveWins _OffsetOf_index _OffsetOf_IpAddressList _OffsetOf_LeaseExpires _OffsetOf_LeaseObtained _OffsetOf_Next _OffsetOf_PrimaryWinsServer _OffsetOf_SecondaryWinsServer _OffsetOf_type'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IP_ADAPTER_INFO guid: (GUID fromString: '{30f77c44-1f24-4b31-9311-dc3a730c4d4e}')!

IP_ADAPTER_INFO addClassConstant: '_OffsetOf_AdapterName' value: 16r8!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_Address' value: 16r194!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_AddressLength' value: 16r190!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_ComboIndex' value: 16r4!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_CurrentIpAddress' value: 16r1A8!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_Description' value: 16r10C!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_DhcpEnabled' value: 16r1A4!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_DhcpServer' value: 16r1FC!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_GatewayList' value: 16r1D4!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_HaveWins' value: 16r224!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_index' value: 16r19C!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_IpAddressList' value: 16r1AC!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_LeaseExpires' value: 16r27C!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_LeaseObtained' value: 16r278!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_Next' value: 16r0!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_PrimaryWinsServer' value: 16r228!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_SecondaryWinsServer' value: 16r250!
IP_ADAPTER_INFO addClassConstant: '_OffsetOf_type' value: 16r1A0!

IP_ADAPTER_INFO comment: '<IP_ADAPTER_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.IP_ADAPTER_INFO'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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

!IP_ADAPTER_INFO categoriesForClass!Win32-Structs! !

!IP_ADAPTER_INFO methodsFor!

AdapterName
	"Answer the <AnsiString> value of the receiver's 'AdapterName' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_AdapterName!

Address
	"Answer the <ByteArray> value of the receiver's 'Address' field."

	^ByteArray fromAddress: bytes yourAddress + _OffsetOf_Address length: 8!

AddressLength
	"Answer the <Integer> value of the receiver's 'AddressLength' field."

	^bytes dwordAtOffset: _OffsetOf_AddressLength!

ComboIndex
	"Answer the <Integer> value of the receiver's 'ComboIndex' field."

	^bytes dwordAtOffset: _OffsetOf_ComboIndex!

CurrentIpAddress
	"Answer the <IP_ADDR_STRING> value of the receiver's 'CurrentIpAddress' field."

	^IP_ADDR_STRING fromAddress: (bytes intPtrAtOffset: _OffsetOf_CurrentIpAddress)!

Description
	"Answer the <AnsiString> value of the receiver's 'Description' field."

	^AnsiString fromAddress: bytes yourAddress + _OffsetOf_Description!

DhcpEnabled
	"Answer the <Integer> value of the receiver's 'DhcpEnabled' field."

	^bytes dwordAtOffset: _OffsetOf_DhcpEnabled!

DhcpServer
	"Answer the <IP_ADDR_STRING> value of the receiver's 'DhcpServer' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_DhcpServer!

GatewayList
	"Answer the <IP_ADDR_STRING> value of the receiver's 'GatewayList' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_GatewayList!

HaveWins
	"Answer the <Integer> value of the receiver's 'HaveWins' field."

	^bytes sdwordAtOffset: _OffsetOf_HaveWins!

index
	"Answer the <Integer> value of the receiver's 'index' field."

	^bytes dwordAtOffset: _OffsetOf_index!

IpAddressList
	"Answer the <IP_ADDR_STRING> value of the receiver's 'IpAddressList' field."

	^IP_ADDR_STRING fromAddress: bytes yourAddress + _OffsetOf_IpAddressList!

LeaseExpires
	"Answer the <Integer> value of the receiver's 'LeaseExpires' field."

	^bytes sdwordAtOffset: _OffsetOf_LeaseExpires!

LeaseObtained
	"Answer the <Integer> value of the receiver's 'LeaseObtained' field."

	^bytes sdwordAtOffset: _OffsetOf_LeaseObtained!

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

	^bytes dwordAtOffset: _OffsetOf_type! !

!IP_ADAPTER_INFO categoriesForMethods!
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

!IP_ADAPTER_INFO class methodsFor!

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
			type: DWORDField readOnly
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
			type: DWORDField readOnly
			offset: 400;
		defineField: #Address
			type: ((ArrayField type: ByteArray length: 8)
					beReadOnly;
					yourself)
			offset: 404;
		defineField: #index
			type: DWORDField readOnly
			offset: 412;
		defineField: #type
			type: DWORDField readOnly
			offset: 416;
		defineField: #DhcpEnabled
			type: DWORDField readOnly
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
			type: SDWORDField readOnly
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
			type: SDWORDField readOnly
			offset: 632;
		defineField: #LeaseExpires
			type: SDWORDField readOnly
			offset: 636.
	self byteSize: 640!

getFieldNames
	^#(#Next #ComboIndex #AdapterName #Description #AddressLength #Address #index #type #DhcpEnabled #CurrentIpAddress #IpAddressList #GatewayList #DhcpServer #HaveWins #PrimaryWinsServer #SecondaryWinsServer #LeaseObtained #LeaseExpires)! !

!IP_ADAPTER_INFO class categoriesForMethods!
defineFields!initializing!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

