"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #NET_ADDRESS_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NET_ADDRESS_INFO guid: (GUID fromString: '{0451C625-7A0F-4B75-AD7C-EA167EC0F47C}')!
NET_ADDRESS_INFO comment: '<NET_ADDRESS_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.NET_ADDRESS_INFO'' from type information in the ''Win32 API'' library.

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
!NET_ADDRESS_INFO categoriesForClass!Win32-Structs! !
!NET_ADDRESS_INFO methodsFor!

Format
	"Answer the receiver's Format field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

Format: anObject
	"Set the receiver's Format field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

getValidFields
	^#(#(#IpAddress) #(#NamedAddress_Address #NamedAddress_Port) #(#Ipv4Address) #(#Ipv6Address))
		at: self Format + 1!

IpAddress
	"Answer the receiver's IpAddress field as a Smalltalk object."

	^SOCKADDR fromAddress: bytes yourAddress + ##(self offsetOf: #IpAddress)!

IpAddress: anObject
	"Set the receiver's IpAddress field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #IpAddress) + 1)
		to: ##((self offsetOf: #IpAddress) + SOCKADDR basicByteSize)
		startingAt: 1!

Ipv4Address
	"Answer the receiver's Ipv4Address field as a Smalltalk object."

	^SOCKADDR_IN fromAddress: bytes yourAddress + ##(self offsetOf: #Ipv4Address)!

Ipv4Address: anObject
	"Set the receiver's Ipv4Address field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Ipv4Address) + 1)
		to: ##((self offsetOf: #Ipv4Address) + SOCKADDR_IN basicByteSize)
		startingAt: 1!

Ipv6Address
	"Answer the receiver's Ipv6Address field as a Smalltalk object."

	^SOCKADDR_IN6 fromAddress: bytes yourAddress + ##(self offsetOf: #Ipv6Address)!

Ipv6Address: anObject
	"Set the receiver's Ipv6Address field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #Ipv6Address) + 1)
		to: ##((self offsetOf: #Ipv6Address) + SOCKADDR_IN6 basicByteSize)
		startingAt: 1!

NamedAddress_Address
	"Answer the receiver's NamedAddress_Address field as a Smalltalk object."

	^WORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #NamedAddress_Address) length: 256!

NamedAddress_Address: anObject
	"Set the receiver's NamedAddress_Address field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(256 * WORDArray elementSize).
	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #NamedAddress_Address) + 1)
		to: ##(self offsetOf: #NamedAddress_Address) + size
		startingAt: 1!

NamedAddress_Port
	"Answer the receiver's NamedAddress_Port field as a Smalltalk object."

	^WORDArray fromAddress: bytes yourAddress + ##(self offsetOf: #NamedAddress_Port) length: 6!

NamedAddress_Port: anObject
	"Set the receiver's NamedAddress_Port field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(6 * WORDArray elementSize).
	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #NamedAddress_Port) + 1)
		to: ##(self offsetOf: #NamedAddress_Port) + size
		startingAt: 1! !
!NET_ADDRESS_INFO categoriesFor: #Format!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #Format:!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #getValidFields!accessing!private! !
!NET_ADDRESS_INFO categoriesFor: #IpAddress!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #IpAddress:!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #Ipv4Address!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #Ipv4Address:!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #Ipv6Address!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #Ipv6Address:!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #NamedAddress_Address!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #NamedAddress_Address:!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #NamedAddress_Port!**compiled accessors**!public! !
!NET_ADDRESS_INFO categoriesFor: #NamedAddress_Port:!**compiled accessors**!public! !

!NET_ADDRESS_INFO class methodsFor!

defineFields
	"Define the fields of the NET_ADDRESS_INFO structure.

	NET_ADDRESS_INFO  compileDefinition

		typedef [uuid(0451C625-7A0F-4B75-AD7C-EA167EC0F47C), helpstring('Contains IP address information returned by the ParseNetworkString function.')]
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
		defineField: #Format type: SDWORDField new offset: 0;
		defineField: #NamedAddress_Address type: (ArrayField type: WORDArray length: 256) offset: 4;
		defineField: #NamedAddress_Port type: (ArrayField type: WORDArray length: 6) offset: 516;
		defineField: #Ipv4Address type: (StructureField type: SOCKADDR_IN) offset: 4;
		defineField: #Ipv6Address type: (StructureField type: SOCKADDR_IN6) offset: 4;
		defineField: #IpAddress type: (StructureField type: SOCKADDR) offset: 4.
	self byteSize: 528! !
!NET_ADDRESS_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

