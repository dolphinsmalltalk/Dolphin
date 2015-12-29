"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #SOCKADDR_IN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SOCKADDR_IN guid: (GUID fromString: '{87B4C611-026E-11D3-9FD7-00A0CC3E4A32}')!
SOCKADDR_IN comment: '<SOCKADDR_IN> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.sockaddr_in'' from type information in the ''Windows Sockets 2 Type Library'' library. The SOCKADDR_IN structure is used to hold address information for the TCP/IP protocol.

IDL definition follows:

typedef struct tagsockaddr_in {
	short sin_family;
	unsigned short sin_port;
	in_addr sin_addr;
	CHAR sin_zero[8];
} sockaddr_in;
'!
!SOCKADDR_IN categoriesForClass!External-Data-Structured-Sockets!Windows Sockets! !
!SOCKADDR_IN methodsFor!

sin_addr
	"Answer the receiver's sin_addr field as a Smalltalk object."

	^IN_ADDR fromAddress: (bytes yourAddress + 4)!

sin_addr: anObject
	"Set the receiver's sin_addr field to the value of anObject."

	anObject replaceBytesOf: bytes from: 5 to: 8 startingAt: 1!

sin_family
	"Answer the receiver's sin_family field as a Smalltalk object."

	^(bytes swordAtOffset: 0)!

sin_family: anObject
	"Set the receiver's sin_family field to the value of anObject."

	bytes swordAtOffset: 0 put: anObject!

sin_port
	"Answer the receiver's sin_port field as a Smalltalk object."

	^(bytes wordAtOffset: 2)!

sin_port: anObject
	"Set the receiver's sin_port field to the value of anObject."

	bytes wordAtOffset: 2 put: anObject! !
!SOCKADDR_IN categoriesFor: #sin_addr!**compiled accessors**!public! !
!SOCKADDR_IN categoriesFor: #sin_addr:!**compiled accessors**!public! !
!SOCKADDR_IN categoriesFor: #sin_family!**compiled accessors**!public! !
!SOCKADDR_IN categoriesFor: #sin_family:!**compiled accessors**!public! !
!SOCKADDR_IN categoriesFor: #sin_port!**compiled accessors**!public! !
!SOCKADDR_IN categoriesFor: #sin_port:!**compiled accessors**!public! !

!SOCKADDR_IN class methodsFor!

defineFields
	"Define the fields of the sockaddr_in structure.
		SOCKADDR_IN compileDefinition
	
		typedef 		struct tagsockaddr_in {
			short sin_family;
			unsigned short sin_port;
			in_addr sin_addr;
			CHAR sin_zero[8];
		} sockaddr_in;"

	self
		defineField: #sin_family type: SWORDField new;
		defineField: #sin_port type: WORDField new;
		defineField: #sin_addr type: (StructureField type: IN_ADDR);
		defineField: #sin_zero type: (StringField length: 8) beFiller! !
!SOCKADDR_IN class categoriesFor: #defineFields!initializing!public! !

