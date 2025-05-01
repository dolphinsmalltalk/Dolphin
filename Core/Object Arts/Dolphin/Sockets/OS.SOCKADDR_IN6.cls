"Filed out from Dolphin Smalltalk"!

OS.SOCKADDR
	subclass: #'OS.SOCKADDR_IN6'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_sin_addr' -> 16r8.
			'_OffsetOf_sin_family' -> 16r0.
			'_OffsetOf_sin_port' -> 16r2.
			'_OffsetOf_sin6_flowinfo' -> 16r4.
			'_OffsetOf_sin6_scope_id' -> 16r18.
			'_OffsetOf_sin6_scope_struct' -> 16r18.
			'_SOCKADDR_IN6_Size' -> 16r1C
		}!

OS.SOCKADDR_IN6 guid: (Core.GUID fromString: '{a989cfcf-96f5-40b8-9904-cb33f7c78940}')!

OS.SOCKADDR_IN6 comment: '<SOCKADDR_IN6> is an <ExternalStructure> class to wrap the struct ''Win32.SOCKADDR_IN6'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Specifies a transport address and port for the AF_INET6 address family"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A989CFCF-96F5-40B8-9904-CB33F7C78940), helpstring("Specifies a transport address and port for the AF_INET6 address family")]
struct tagSOCKADDR_IN6 {
	[helpstring("Address family; must be AF_INET6")] ADDRESS_FAMILY sin6_family;
	[helpstring("Transport level port number (N.B. network byte order)")] unsigned short sin6_port;
	[helpstring("IPv6 flow information")] unsigned long sin6_flowinfo;
	[helpstring("IPv6 address")] IN6_ADDR sin6_addr;
	union {
		[helpstring("IPv6 scope identifier that is defined in the sin6_scope_struct member")] unsigned long sin6_scope_id;
		[hidden, helpstring("Contains the scope identifier for the IPv6 transport address")] unsigned long sin6_scope_struct;
	};
} SOCKADDR_IN6;
'!

!OS.SOCKADDR_IN6 categoriesForClass!Win32-Structs! !

!OS.SOCKADDR_IN6 methodsFor!

flowInfo
	"Answer the <integer> flow info."

	^Ws2_32 ntohl: self sin6_flowinfo!

flowInfo: anInteger
	"Set the <integer> flow info."

	self sin6_flowinfo: (Ws2_32 htonl: anInteger)!

port
	"Answer the <integer> port number."

	^Ws2_32 ntohs: self sin6_port!

port: anInteger
	"Set the <integer> port number."

	self sin6_port: (Ws2_32 htons: anInteger)!

sin_addr
	"Answer the <IN6_ADDR> value of the receiver's 'sin_addr' field."

	^IN6_ADDR fromAddress: bytes yourAddress + _OffsetOf_sin_addr!

sin_addr: anIN6_ADDR
	"Set the receiver's 'sin_addr' field to the value of the argument, anIN6_ADDR"

	anIN6_ADDR
		replaceBytesOf: bytes
		from: ##(_OffsetOf_sin_addr + 1)
		to: ##(_OffsetOf_sin_addr + IN6_ADDR._IN6_ADDR_Size)
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

	bytes uint16AtOffset: _OffsetOf_sin_port put: anInteger!

sin6_flowinfo
	"Answer the <Integer> value of the receiver's 'sin6_flowinfo' field."

	^bytes uint32AtOffset: _OffsetOf_sin6_flowinfo!

sin6_flowinfo: anInteger
	"Set the receiver's 'sin6_flowinfo' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_sin6_flowinfo put: anInteger!

sin6_scope_id
	"Answer the <Integer> value of the receiver's 'sin6_scope_id' field."

	^bytes uint32AtOffset: _OffsetOf_sin6_scope_id!

sin6_scope_id: anInteger
	"Set the receiver's 'sin6_scope_id' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_sin6_scope_id put: anInteger! !

!OS.SOCKADDR_IN6 categoriesForMethods!
flowInfo!accessing!public! !
flowInfo:!accessing!public! !
port!accessing!public! !
port:!accessing!public! !
sin_addr!**compiled accessors**!public! !
sin_addr:!**compiled accessors**!public! !
sin_family!**compiled accessors**!public! !
sin_family:!**compiled accessors**!public! !
sin_port!**compiled accessors**!public! !
sin_port:!**compiled accessors**!public! !
sin6_flowinfo!**compiled accessors**!public! !
sin6_flowinfo:!**compiled accessors**!public! !
sin6_scope_id!**compiled accessors**!public! !
sin6_scope_id:!**compiled accessors**!public! !
!

!OS.SOCKADDR_IN6 class methodsFor!

addressFamily
	^WinSocketConstants.AF_INET6!

byteSize
	^_SOCKADDR_IN6_Size!

defineFields
	"Define the fields of the SOCKADDR_IN6 structure. Note that we rename some fields for polymorphism with SOCKADDR_IN.

	SOCKADDR_IN6 compileDefinition

		typedef [uuid(a989cfcf-96f5-40b8-9904-cb33f7c78940), helpstring('Specifies a transport address and port for the AF_INET6 address family. All of the data in the structure, except for the address family, is specified in network-byte-order (big-endian).')]
		struct tagSOCKADDR_IN6 {
			[helpstring('Address family; must be AF_INET6')] ADDRESS_FAMILY sin6_family;
			[helpstring('Transport level port number in network byte order')] USHORT sin6_port;
			[helpstring('IPv6 flow information in network byte order')] ULONG sin6_flowinfo;
			[helpstring('IPv6 address')] IN6_ADDR sin6_addr;
			union {
				[helpstring('IPv6 scope identifier that is defined in the sin6_scope_struct member, in network byte order')] ULONG sin6_scope_id;
				[hidden, helpstring('Contains the scope identifier for the IPv6 transport address')] ULONG sin6_scope_struct;
			};
		} SOCKADDR_IN6;
"

	self
		defineField: #sin_family type: UInt16Field new offset: 0;
		defineField: #sin_port type: UInt16Field new offset: 2;
		defineField: #sin6_flowinfo type: UInt32Field new offset: 4;
		defineField: #sin_addr type: (StructureField type: IN6_ADDR) offset: 8;
		defineField: #sin6_scope_id type: UInt32Field new offset: 24;
		defineField: #sin6_scope_struct type: UInt32Field new beFiller offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#sin_family #sin_port #sin6_flowinfo #sin_addr #sin6_scope_id)! !

!OS.SOCKADDR_IN6 class categoriesForMethods!
addressFamily!constants!public! !
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

