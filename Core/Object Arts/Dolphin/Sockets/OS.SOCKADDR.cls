﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.SOCKADDR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.WinSocketConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_sa_data' -> 16r2.
			'_OffsetOf_sa_family' -> 16r0.
			'_SOCKADDR_Size' -> 16r10
		}!

OS.SOCKADDR guid: (Core.GUID fromString: '{0299d3de-9695-4177-9ce6-42ad495c8e57}')!

OS.SOCKADDR comment: '<SOCKADDR> is an <ExternalStructure> class to wrap the struct ''Win32.SOCKADDR'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure used by kernel to store most addresses."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(0299D3DE-9695-4177-9CE6-42AD495C8E57), helpstring("Structure used by kernel to store most addresses.")]
struct tagSOCKADDR {
	[helpstring("Address family; AF_INET if an IPv4 address, AF_INET6 if IPv6")] ADDRESS_FAMILY sa_family;
	[hidden, helpstring("Up to 14 bytes of direct address (note in network order, not host order)")] char sa_data[14];
} SOCKADDR;
'!

!OS.SOCKADDR categoriesForClass!Win32-Structs! !

!OS.SOCKADDR methodsFor!

address
	^self sin_addr address!

addressFamily
	^bytes uint16AtOffset: _OffsetOf_sa_family!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see.
	In this case we print the address in the standard IPv4 or IPv6 format."

	| buf len |
	(self isNull or: [self sa_family == 0]) ifTrue: [^self].
	buf := Utf16String newFixed: ##(INET6_ADDRSTRLEN - 1).
	len := UInt32Bytes fromInteger: INET6_ADDRSTRLEN.
	Ws2_32
		wsaAddressToString: bytes
		dwAddressLength: self byteSize
		lpProtocolInfo: nil
		lpszAddressString: buf
		lpdwAddressStringLength: len.
	aPuttableStream
		next: len value - 1
		putAll: buf
		startingAt: 1!

host
	"Answer the <String> name of the host defined whose IP address is held by the receiver. Note this is a reverse DNS lookup, so the result is not considered reliable."

	^Ws2_32 getNameInfo: self!

initialize
	self sa_family: self class addressFamily!

printFieldsOn: aStream
	self isNull ifTrue: [aStream nextPutAll: 'NULL'] ifFalse: [self displayOn: aStream]!

sa_family
	"Answer the <Integer> value of the receiver's 'sa_family' field."

	^bytes uint16AtOffset: _OffsetOf_sa_family!

sa_family: anInteger
	"Set the receiver's 'sa_family' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_sa_family put: anInteger!

sin_addr
	^self subclassResponsibility! !

!OS.SOCKADDR categoriesForMethods!
address!accessing!public! !
addressFamily!operations!public! !
displayOn:!displaying!public! !
host!accessing!public! !
initialize!initializing!private! !
printFieldsOn:!development!printing!private! !
sa_family!**compiled accessors**!public! !
sa_family:!**compiled accessors**!public! !
sin_addr!accessing!public! !
!

!OS.SOCKADDR class methodsFor!

addressFamily
	^AF_INET!

basicFromString: aString
	"Answer a new sub-instance of the correct type to describe the IP address represented by the <String> argument.
		self fromString: '192.168.1.6:80'.
		(self fromString: '[fe80::a221:b7ff:fe70:6185%7]:443') 
	"

	| sockaddr pLen |
	sockaddr := self newBuffer.
	pLen := UInt32Bytes fromInteger: self byteSize.
	Ws2_32
		wsaStringToAddress: aString
		addressfamily: self addressFamily
		lpProtocolInfo: nil
		lpAddress: sockaddr
		lpAddressLength: pLen.
	^sockaddr!

byteSize
	^_SOCKADDR_Size!

defineFields
	"Define the fields of the SOCKADDR structure.

	SOCKADDR compileDefinition

		typedef [uuid(0299d3de-9695-4177-9ce6-42ad495c8e57), helpstring('Structure used by kernel to store most addresses.')]
		struct tagSOCKADDR {
			[helpstring('Address family; AF_INET if an IPv4 address, AF_INET6 if IPv6')] ADDRESS_FAMILY sa_family;
			[hidden, helpstring('Up to 14 bytes of direct address (note in network order, not host order)')] BYTE sa_data[14];
		} SOCKADDR;
"

	self
		defineField: #sa_family type: UInt16Field new offset: 0;
		defineField: #sa_data type: (ArrayField type: ExternalArray length: 14) beFiller offset: 2.
	self byteSize: 16!

fromAddress: anAddress
	"Answer a new sub-instance of the correct type to represent the IP address structure
	stored at the specified memory location."

	| family ptr |
	anAddress isNull ifTrue: [^nil].
	ptr := anAddress asExternalAddress.
	family := ptr uint16AtOffset: 0.
	^(family == AF_INET
		ifTrue: [SOCKADDR_IN]
		ifFalse: [family == AF_INET6 ifTrue: [SOCKADDR_IN6] ifFalse: [SOCKADDR]]) basicNew
		initializeAtAddress: ptr!

fromString: aString
	"Answer a new sub-instance of the correct type to describe the IP address represented by the <String> argument.
		self fromString: '192.168.1.6:80'.
		(self fromString: '[fe80::a221:b7ff:fe70:6185%7]:443') 
	"

	^(aString size >= INET_ADDRSTRLEN ifTrue: [SOCKADDR_IN6] ifFalse: [SOCKADDR_IN])
		basicFromString: aString!

getFieldNames
	^#(#sa_family)! !

!OS.SOCKADDR class categoriesForMethods!
addressFamily!constants!public! !
basicFromString:!instance creation!public! !
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
fromAddress:!instance creation!public! !
fromString:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

