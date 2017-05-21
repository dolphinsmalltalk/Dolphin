"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #IP_ADAPTER_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IP_ADAPTER_INFO guid: (GUID fromString: '{30f77c44-1f24-4b31-9311-dc3a730c4d4e}')!
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
	"Answer the receiver's AdapterName field as a Smalltalk object."

	^String fromAddress: (bytes yourAddress + 8)!

Address
	"Answer the receiver's Address field as a Smalltalk object."

	^ByteArray fromAddress: (bytes yourAddress + 404) length: 8!

AddressLength
	"Answer the receiver's AddressLength field as a Smalltalk object."

	^(bytes dwordAtOffset: 400)!

ComboIndex
	"Answer the receiver's ComboIndex field as a Smalltalk object."

	^(bytes dwordAtOffset: 4)!

CurrentIpAddress
	"Answer the receiver's CurrentIpAddress field as a Smalltalk object."

	^IP_ADDR_STRING fromAddress: (bytes sdwordAtOffset: 424)!

Description
	"Answer the receiver's Description field as a Smalltalk object."

	^String fromAddress: (bytes yourAddress + 268)!

DhcpEnabled
	"Answer the receiver's DhcpEnabled field as a Smalltalk object."

	^(bytes dwordAtOffset: 420)!

DhcpServer
	"Answer the receiver's DhcpServer field as a Smalltalk object."

	^IP_ADDR_STRING fromAddress: (bytes yourAddress + 508)!

GatewayList
	"Answer the receiver's GatewayList field as a Smalltalk object."

	^IP_ADDR_STRING fromAddress: (bytes yourAddress + 468)!

HaveWins
	"Answer the receiver's HaveWins field as a Smalltalk object."

	^(bytes sdwordAtOffset: 548)!

index
	"Answer the receiver's index field as a Smalltalk object."

	^(bytes dwordAtOffset: 412)!

IpAddressList
	"Answer the receiver's IpAddressList field as a Smalltalk object."

	^IP_ADDR_STRING fromAddress: (bytes yourAddress + 428)!

LeaseExpires
	"Answer the receiver's LeaseExpires field as a Smalltalk object."

	^(bytes sdwordAtOffset: 636)!

LeaseObtained
	"Answer the receiver's LeaseObtained field as a Smalltalk object."

	^(bytes sdwordAtOffset: 632)!

Next
	"Answer the receiver's Next field as a Smalltalk object."

	^IP_ADAPTER_INFO fromAddress: (bytes sdwordAtOffset: 0)!

PrimaryWinsServer
	"Answer the receiver's PrimaryWinsServer field as a Smalltalk object."

	^IP_ADDR_STRING fromAddress: (bytes yourAddress + 552)!

SecondaryWinsServer
	"Answer the receiver's SecondaryWinsServer field as a Smalltalk object."

	^IP_ADDR_STRING fromAddress: (bytes yourAddress + 592)!

type
	"Answer the receiver's type field as a Smalltalk object."

	^(bytes dwordAtOffset: 416)! !
!IP_ADAPTER_INFO categoriesFor: #AdapterName!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #Address!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #AddressLength!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #ComboIndex!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #CurrentIpAddress!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #Description!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #DhcpEnabled!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #DhcpServer!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #GatewayList!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #HaveWins!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #index!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #IpAddressList!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #LeaseExpires!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #LeaseObtained!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #Next!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #PrimaryWinsServer!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #SecondaryWinsServer!**compiled accessors**!public! !
!IP_ADAPTER_INFO categoriesFor: #type!**compiled accessors**!public! !

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
	self byteSize: 640! !
!IP_ADAPTER_INFO class categoriesFor: #defineFields!initializing!public! !

