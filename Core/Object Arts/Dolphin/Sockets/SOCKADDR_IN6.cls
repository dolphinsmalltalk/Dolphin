"Filed out from Dolphin Smalltalk 7"!

SOCKADDR subclass: #SOCKADDR_IN6
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SOCKADDR_IN6 guid: (GUID fromString: '{A989CFCF-96F5-40B8-9904-CB33F7C78940}')!
SOCKADDR_IN6 comment: '<SOCKADDR_IN6> is an <ExternalStructure> class to wrap the struct ''Win32.SOCKADDR_IN6'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Specifies a transport address and port for the AF_INET6 address family"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(A989CFCF-96F5-40B8-9904-CB33F7C78940), helpstring("Specifies a transport address and port for the AF_INET6 address family")]
struct tagSOCKADDR_IN6 {
	[helpstring("Address family; must be AF_INET6")] unsigned short sin6_family;
	[helpstring("Transport level port number")] unsigned short sin6_port;
	[helpstring("IPv6 flow information")] unsigned long sin6_flowinfo;
	[helpstring("IPv6 address")] IN6_ADDR sin6_addr;
	union {
		[helpstring("IPv6 scope identifier that is defined in the sin6_scope_struct member")] unsigned long sin6_scope_id;
		[helpstring("Contains the scope identifier for the IPv6 transport address")] unsigned long sin6_scope_struct;
	};
} SOCKADDR_IN6;
'!
!SOCKADDR_IN6 categoriesForClass!Win32-Structs! !
!SOCKADDR_IN6 methodsFor!

sin6_addr
	"Answer the receiver's sin6_addr field as a Smalltalk object."

	^IN6_ADDR fromAddress: bytes yourAddress + ##(self offsetOf: #sin6_addr)!

sin6_addr: anObject
	"Set the receiver's sin6_addr field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #sin6_addr) + 1)
		to: ##((self offsetOf: #sin6_addr) + IN6_ADDR basicByteSize)
		startingAt: 1!

sin6_family
	"Answer the receiver's sin6_family field as a Smalltalk object."

	^bytes wordAtOffset: 0!

sin6_family: anObject
	"Set the receiver's sin6_family field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

sin6_flowinfo
	"Answer the receiver's sin6_flowinfo field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #sin6_flowinfo)!

sin6_flowinfo: anObject
	"Set the receiver's sin6_flowinfo field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #sin6_flowinfo) put: anObject!

sin6_port
	"Answer the receiver's sin6_port field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #sin6_port)!

sin6_port: anObject
	"Set the receiver's sin6_port field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #sin6_port) put: anObject!

sin6_scope_id
	"Answer the receiver's sin6_scope_id field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #sin6_scope_id)!

sin6_scope_id: anObject
	"Set the receiver's sin6_scope_id field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #sin6_scope_id) put: anObject!

sin6_scope_struct
	"Answer the receiver's sin6_scope_struct field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #sin6_scope_struct)!

sin6_scope_struct: anObject
	"Set the receiver's sin6_scope_struct field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #sin6_scope_struct) put: anObject! !
!SOCKADDR_IN6 categoriesFor: #sin6_addr!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_addr:!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_family!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_family:!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_flowinfo!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_flowinfo:!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_port!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_port:!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_scope_id!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_scope_id:!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_scope_struct!**compiled accessors**!public! !
!SOCKADDR_IN6 categoriesFor: #sin6_scope_struct:!**compiled accessors**!public! !

!SOCKADDR_IN6 class methodsFor!

defineFields
	"Define the fields of the SOCKADDR_IN6 structure.

	SOCKADDR_IN6  compileDefinition

		typedef [uuid(A989CFCF-96F5-40B8-9904-CB33F7C78940), helpstring('Specifies a transport address and port for the AF_INET6 address family')]
		struct tagSOCKADDR_IN6 {
			[helpstring('Address family; must be AF_INET6')] unsigned short sin6_family;
			[helpstring('Transport level port number')] unsigned short sin6_port;
			[helpstring('IPv6 flow information')] unsigned long sin6_flowinfo;
			[helpstring('IPv6 address')] IN6_ADDR sin6_addr;
			union {
				[helpstring('IPv6 scope identifier that is defined in the sin6_scope_struct member')] unsigned long sin6_scope_id;
				[helpstring('Contains the scope identifier for the IPv6 transport address')] unsigned long sin6_scope_struct;
			};
		} SOCKADDR_IN6;
"

	self
		defineField: #sin6_family
			type: WORDField filler
			offset: 0;
		defineField: #sin6_port
			type: WORDField new
			offset: 2;
		defineField: #sin6_flowinfo
			type: DWORDField new
			offset: 4;
		defineField: #sin6_addr
			type: (StructureField type: IN6_ADDR)
			offset: 8;
		defineField: #sin6_scope_id
			type: DWORDField new
			offset: 24;
		defineField: #sin6_scope_struct
			type: DWORDField new
			offset: 24.
	self byteSize: 28! !
!SOCKADDR_IN6 class categoriesFor: #defineFields!initializing!public! !

