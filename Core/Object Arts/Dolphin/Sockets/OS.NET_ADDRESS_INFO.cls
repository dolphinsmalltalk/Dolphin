﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.NET_ADDRESS_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_NET_ADDRESS_INFO_Size' -> 16r210.
			'_OffsetOf_Format' -> 16r0.
			'_OffsetOf_IpAddress' -> 16r4.
			'_OffsetOf_Ipv4Address' -> 16r4.
			'_OffsetOf_Ipv6Address' -> 16r4.
			'_OffsetOf_NamedAddress_Address' -> 16r4.
			'_OffsetOf_NamedAddress_Port' -> 16r204
		}!

OS.NET_ADDRESS_INFO guid: (Core.GUID fromString: '{0451c625-7a0f-4b75-ad7c-ea167ec0f47c}')!

OS.NET_ADDRESS_INFO comment: '<NET_ADDRESS_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.NET_ADDRESS_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Contains IP address information returned by the ParseNetworkString function."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(0451C625-7A0F-4B75-AD7C-EA167EC0F47C), helpstring("Contains IP address information returned by the ParseNetworkString function.")]
struct tagNET_ADDRESS_INFO {
	[helpstring("The format of the network address in the union in this structure.")] NET_ADDRESS_FORMAT Format;
	union {
		struct {
			[helpstring("A DNS name formatted as a NULL-terminated wide character string.")] unsigned short Address[256];
			[helpstring("The network port formatted as a NULL-terminated wide character string.")] unsigned short Port[6];
		} NamedAddress;
		[helpstring("An IPv4 address represented as a SOCKADDR_IN structure")] SOCKADDR_IN Ipv4Address;
		[helpstring("An IPv6 address represented as a SOCKADDR_IN6 structure.")] SOCKADDR_IN6 Ipv6Address;
		[helpstring("An IPv4 or IPv6 address represented as a SOCKADDR structure.")] SOCKADDR IpAddress;
	};
} NET_ADDRESS_INFO;
'!

!OS.NET_ADDRESS_INFO categoriesForClass!Win32-Structs! !

!OS.NET_ADDRESS_INFO methodsFor!

Format
	"Answer the <Integer> value of the receiver's 'Format' field."

	^bytes int32AtOffset: _OffsetOf_Format!

Format: anInteger
	"Set the receiver's 'Format' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_Format put: anInteger!

getValidFields
	^#(#(#IpAddress) #(#NamedAddress_Address #NamedAddress_Port) #(#Ipv4Address) #(#Ipv6Address))
		at: self Format + 1!

IpAddress
	"Answer the <SOCKADDR> value of the receiver's 'IpAddress' field."

	^SOCKADDR fromAddress: bytes yourAddress + _OffsetOf_IpAddress!

IpAddress: aSOCKADDR
	"Set the receiver's 'IpAddress' field to the value of the argument, aSOCKADDR"

	aSOCKADDR
		replaceBytesOf: bytes
		from: ##(_OffsetOf_IpAddress + 1)
		to: ##(_OffsetOf_IpAddress + SOCKADDR._SOCKADDR_Size)
		startingAt: 1!

Ipv4Address
	"Answer the <SOCKADDR_IN> value of the receiver's 'Ipv4Address' field."

	^SOCKADDR_IN fromAddress: bytes yourAddress + _OffsetOf_Ipv4Address!

Ipv4Address: aSOCKADDR_IN
	"Set the receiver's 'Ipv4Address' field to the value of the argument, aSOCKADDR_IN"

	aSOCKADDR_IN
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Ipv4Address + 1)
		to: ##(_OffsetOf_Ipv4Address + SOCKADDR_IN._SOCKADDR_IN_Size)
		startingAt: 1!

Ipv6Address
	"Answer the <SOCKADDR_IN6> value of the receiver's 'Ipv6Address' field."

	^SOCKADDR_IN6 fromAddress: bytes yourAddress + _OffsetOf_Ipv6Address!

Ipv6Address: aSOCKADDR_IN6
	"Set the receiver's 'Ipv6Address' field to the value of the argument, aSOCKADDR_IN6"

	aSOCKADDR_IN6
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Ipv6Address + 1)
		to: ##(_OffsetOf_Ipv6Address + SOCKADDR_IN6._SOCKADDR_IN6_Size)
		startingAt: 1!

NamedAddress_Address
	"Answer the <UInt16Array> value of the receiver's 'NamedAddress_Address' field."

	^UInt16Array fromAddress: bytes yourAddress + _OffsetOf_NamedAddress_Address length: 256!

NamedAddress_Address: anUInt16Array
	"Set the receiver's 'NamedAddress_Address' field to the value of the argument, anUInt16Array"

	| size |
	size := anUInt16Array byteSize min: ##(256 * UInt16Array elementSize).
	anUInt16Array
		replaceBytesOf: bytes
		from: ##(_OffsetOf_NamedAddress_Address + 1)
		to: _OffsetOf_NamedAddress_Address + size
		startingAt: 1!

NamedAddress_Port
	"Answer the <UInt16Array> value of the receiver's 'NamedAddress_Port' field."

	^UInt16Array fromAddress: bytes yourAddress + _OffsetOf_NamedAddress_Port length: 6!

NamedAddress_Port: anUInt16Array
	"Set the receiver's 'NamedAddress_Port' field to the value of the argument, anUInt16Array"

	| size |
	size := anUInt16Array byteSize min: ##(6 * UInt16Array elementSize).
	anUInt16Array
		replaceBytesOf: bytes
		from: ##(_OffsetOf_NamedAddress_Port + 1)
		to: _OffsetOf_NamedAddress_Port + size
		startingAt: 1! !

!OS.NET_ADDRESS_INFO categoriesForMethods!
Format!**compiled accessors**!public! !
Format:!**compiled accessors**!public! !
getValidFields!accessing!private! !
IpAddress!**compiled accessors**!public! !
IpAddress:!**compiled accessors**!public! !
Ipv4Address!**compiled accessors**!public! !
Ipv4Address:!**compiled accessors**!public! !
Ipv6Address!**compiled accessors**!public! !
Ipv6Address:!**compiled accessors**!public! !
NamedAddress_Address!**compiled accessors**!public! !
NamedAddress_Address:!**compiled accessors**!public! !
NamedAddress_Port!**compiled accessors**!public! !
NamedAddress_Port:!**compiled accessors**!public! !
!

!OS.NET_ADDRESS_INFO class methodsFor!

byteSize
	^_NET_ADDRESS_INFO_Size!

defineFields
	"Define the fields of the NET_ADDRESS_INFO structure.

	NET_ADDRESS_INFO compileDefinition

		typedef [uuid(0451c625-7a0f-4b75-ad7c-ea167ec0f47c), helpstring('Contains IP address information returned by the ParseNetworkString function.')]
		struct tagNET_ADDRESS_INFO {
			[helpstring('The format of the network address in the union in this structure.')] NET_ADDRESS_FORMAT Format;
			union {
				struct {
					[helpstring('A DNS name formatted as a NULL-terminated wide character string.')] unsigned short Address[256];
					[helpstring('The network port formatted as a NULL-terminated wide character string.')] unsigned short Port[6];
				} NamedAddress;
				[helpstring('An IPv4 address represented as a SOCKADDR_IN structure')] SOCKADDR_IN Ipv4Address;
				[helpstring('An IPv6 address represented as a SOCKADDR_IN6 structure.')] SOCKADDR_IN6 Ipv6Address;
				[helpstring('An IPv4 or IPv6 address represented as a SOCKADDR structure.')] SOCKADDR IpAddress;
			};
		} NET_ADDRESS_INFO;
"

	self
		defineField: #Format type: Int32Field new offset: 0;
		defineField: #NamedAddress_Address type: (ArrayField type: UInt16Array length: 256) offset: 4;
		defineField: #NamedAddress_Port type: (ArrayField type: UInt16Array length: 6) offset: 516;
		defineField: #Ipv4Address type: (StructureField type: SOCKADDR_IN) offset: 4;
		defineField: #Ipv6Address type: (StructureField type: SOCKADDR_IN6) offset: 4;
		defineField: #IpAddress type: (StructureField type: SOCKADDR) offset: 4.
	self byteSize: 528!

getFieldNames
	^#(#Format)! !

!OS.NET_ADDRESS_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!accessing!private! !
!

