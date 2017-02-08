"Filed out from Dolphin Smalltalk 7"!

SOCKADDR subclass: #SOCKADDR_IN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SOCKADDR_IN guid: (GUID fromString: '{87B4C611-026E-11D3-9FD7-00A0CC3E4A32}')!
SOCKADDR_IN comment: '<SOCKADDR_IN> is an <ExternalStructure> class to wrap the struct ''Win32.SOCKADDR_IN'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Local or remote endpoint address in Internet family style (i.e. IPv4)"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(87B4C611-026E-11D3-9FD7-00A0CC3E4A32), helpstring("Local or remote endpoint address in Internet family style (i.e. IPv4)")]
struct tagSOCKADDR_IN {
	[helpstring("Address family (must be AF_INET).")] short sin_family;
	[helpstring("IP port.")] unsigned short sin_port;
	[helpstring("IPv4 address")] IN_ADDR sin_addr;
	[helpstring("Padding to make structure the same size as SOCKADDR.")] CHAR sin_zero[8];
} SOCKADDR_IN;
'!
!SOCKADDR_IN categoriesForClass!Win32-Structs! !
!SOCKADDR_IN methodsFor!

sin_addr
	"Answer the receiver's sin_addr field as a Smalltalk object."

	^IN_ADDR fromAddress: bytes yourAddress + ##(self offsetOf: #sin_addr)!

sin_addr: anObject
	"Set the receiver's sin_addr field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #sin_addr) + 1)
		to: ##((self offsetOf: #sin_addr) + IN_ADDR basicByteSize)
		startingAt: 1!

sin_port
	"Answer the receiver's sin_port field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #sin_port)!

sin_port: anObject
	"Set the receiver's sin_port field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #sin_port) put: anObject! !
!SOCKADDR_IN categoriesFor: #sin_addr!**compiled accessors**!public! !
!SOCKADDR_IN categoriesFor: #sin_addr:!**compiled accessors**!public! !
!SOCKADDR_IN categoriesFor: #sin_port!**compiled accessors**!public! !
!SOCKADDR_IN categoriesFor: #sin_port:!**compiled accessors**!public! !

!SOCKADDR_IN class methodsFor!

defineFields
	"Define the fields of the SOCKADDR_IN structure.

	SOCKADDR_IN  compileDefinition

		typedef [uuid(87B4C611-026E-11D3-9FD7-00A0CC3E4A32), helpstring('Local or remote endpoint address in Internet family style (i.e. IPv4)')]
		struct tagSOCKADDR_IN {
			[helpstring('Address family (must be AF_INET).')] short sin_family;
			[helpstring('IP port.')] unsigned short sin_port;
			[helpstring('IPv4 address')] IN_ADDR sin_addr;
			[helpstring('Padding to make structure the same size as SOCKADDR.')] CHAR sin_zero[8];
		} SOCKADDR_IN;
"

	self
		defineField: #sin_family type: SWORDField filler offset: 0;
		defineField: #sin_port type: WORDField new offset: 2;
		defineField: #sin_addr type: (StructureField type: IN_ADDR) offset: 4;
		defineField: #sin_zero type: (ArrayField type: ByteArray length: 8) beFiller offset: 8.
	self byteSize: 16! !
!SOCKADDR_IN class categoriesFor: #defineFields!initializing!public! !

