﻿"Filed out from Dolphin Smalltalk"!

OS.SOCKADDR
	subclass: #'OS.SOCKADDR_IN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_sin_addr' -> 16r4.
			'_OffsetOf_sin_family' -> 16r0.
			'_OffsetOf_sin_port' -> 16r2.
			'_OffsetOf_sin_zero' -> 16r8.
			'_SOCKADDR_IN_Size' -> 16r10
		}!

OS.SOCKADDR_IN guid: (Core.GUID fromString: '{87b4c611-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.SOCKADDR_IN comment: '<SOCKADDR_IN> is an <ExternalStructure> class to wrap the struct ''Win32.SOCKADDR_IN'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Local or remote endpoint address in Internet family style (i.e. IPv4).  Except for the sin*_family parameter, contents are expressed in network byte order."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(87B4C611-026E-11D3-9FD7-00A0CC3E4A32), helpstring("Local or remote endpoint address in Internet family style (i.e. IPv4).  Except for the sin*_family parameter, contents are expressed in network byte order.")]
struct tagSOCKADDR_IN {
	[helpstring("Address family (must be AF_INET).")] ADDRESS_FAMILY sin_family;
	[helpstring("IP port, in network byte order.")] unsigned short sin_port;
	[helpstring("IPv4 address")] IN_ADDR sin_addr;
	[hidden, helpstring("Padding to make structure the same size as SOCKADDR.")] BYTE sin_zero[8];
} SOCKADDR_IN;
'!

!OS.SOCKADDR_IN categoriesForClass!Win32-Structs! !

!OS.SOCKADDR_IN methodsFor!

address: anInternetAddress
	"Sets the address for the receiver to anInternetAddress"

	self sin_addr: anInternetAddress ipAddress!

port
	"Answer the <integer> port number."

	^Ws2_32 ntohs: self sin_port!

port: anInteger
	"Set the <integer> port number."

	self sin_port: (Ws2_32 htons: anInteger)!

sin_addr
	"Answer the <IN_ADDR> value of the receiver's 'sin_addr' field."

	^IN_ADDR fromAddress: bytes yourAddress + _OffsetOf_sin_addr!

sin_addr: anIN_ADDR
	"Set the receiver's 'sin_addr' field to the value of the argument, anIN_ADDR"

	anIN_ADDR
		replaceBytesOf: bytes
		from: ##(_OffsetOf_sin_addr + 1)
		to: ##(_OffsetOf_sin_addr + IN_ADDR._IN_ADDR_Size)
		startingAt: 1!

sin_family
	"Answer the <Integer> value of the receiver's 'sin_family' field."

	^bytes uint16AtOffset: _OffsetOf_sin_family!

sin_family: anInteger
	"Set the receiver's 'sin_family' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_sin_family put: anInteger!

sin_port
	"Answer the <Integer> value of the receiver's 'sin_port' field."

	^bytes uint16AtOffset: _OffsetOf_sin_port!

sin_port: anInteger
	"Set the receiver's 'sin_port' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_sin_port put: anInteger! !

!OS.SOCKADDR_IN categoriesForMethods!
address:!accessing!public! !
port!accessing!public! !
port:!accessing!public! !
sin_addr!**compiled accessors**!public! !
sin_addr:!**compiled accessors**!public! !
sin_family!**compiled accessors**!public! !
sin_family:!**compiled accessors**!public! !
sin_port!**compiled accessors**!public! !
sin_port:!**compiled accessors**!public! !
!

!OS.SOCKADDR_IN class methodsFor!

address: anInternetAddress
	^self new
		sin_addr: anInternetAddress ipAddress;
		yourself!

byteSize
	^_SOCKADDR_IN_Size!

defineFields
	"Define the fields of the SOCKADDR_IN structure.

	SOCKADDR_IN compileDefinition

		typedef [uuid(87b4c611-026e-11d3-9fd7-00a0cc3e4a32), helpstring('Local or remote endpoint address in Internet family style (i.e. IPv4).  Except for the sin*_family parameter, contents are expressed in network byte order.')]
		struct tagSOCKADDR_IN {
			[helpstring('Address family (must be AF_INET).')] ADDRESS_FAMILY sin_family;
			[helpstring('IP port, in network byte order.')] USHORT sin_port;
			[helpstring('IPv4 address')] IN_ADDR sin_addr;
			[hidden, helpstring('Padding to make structure the same size as SOCKADDR.')] BYTE sin_zero[8];
		} SOCKADDR_IN;
"

	self
		defineField: #sin_family type: UInt16Field new offset: 0;
		defineField: #sin_port type: UInt16Field new offset: 2;
		defineField: #sin_addr type: (StructureField type: IN_ADDR) offset: 4;
		defineField: #sin_zero type: (ArrayField type: ExternalArray length: 8) beFiller offset: 8.
	self byteSize: 16!

getFieldNames
	^#(#sin_family #sin_port #sin_addr)!

ipAddress: aByteArray
	^self new
		sin_addr: aByteArray;
		yourself! !

!OS.SOCKADDR_IN class categoriesForMethods!
address:!instance creation!public! !
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
ipAddress:!instance creation!public! !
!

