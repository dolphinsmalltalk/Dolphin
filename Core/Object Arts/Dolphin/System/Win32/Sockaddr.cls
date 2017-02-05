"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #Sockaddr
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Sockaddr guid: (GUID fromString: '{0299D3DE-9695-4177-9CE6-42AD495C8E57}')!
Sockaddr comment: '<Sockaddr> is an <ExternalStructure> class to wrap the struct ''Win32.sockaddr'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure used by kernel to store most addresses."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(0299D3DE-9695-4177-9CE6-42AD495C8E57), helpstring("Structure used by kernel to store most addresses.")]
struct tagsockaddr {
	[helpstring("address family ")] unsigned short sa_family;
	[helpstring("up to 14 bytes of direct address (not in network order, not host order)")] CHAR sa_data[14];
} sockaddr;
'!
!Sockaddr categoriesForClass!Win32-Structs! !
!Sockaddr methodsFor!

sa_data
	"Answer the receiver's sa_data field as a Smalltalk object."

	^ByteArray fromAddress: bytes yourAddress + ##(self offsetOf: #sa_data) length: 14!

sa_data: anObject
	"Set the receiver's sa_data field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(14 * ByteArray elementSize).
	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #sa_data) + 1)
		to: ##(self offsetOf: #sa_data) + size
		startingAt: 1!

sa_family
	"Answer the receiver's sa_family field as a Smalltalk object."

	^bytes wordAtOffset: 0!

sa_family: anObject
	"Set the receiver's sa_family field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!Sockaddr categoriesFor: #sa_data!**compiled accessors**!public! !
!Sockaddr categoriesFor: #sa_data:!**compiled accessors**!public! !
!Sockaddr categoriesFor: #sa_family!**compiled accessors**!public! !
!Sockaddr categoriesFor: #sa_family:!**compiled accessors**!public! !

!Sockaddr class methodsFor!

defineFields
	"Define the fields of the sockaddr structure.

	Sockaddr  compileDefinition

		typedef [uuid(0299D3DE-9695-4177-9CE6-42AD495C8E57), helpstring('Structure used by kernel to store most addresses.')]
		struct tagsockaddr {
			[helpstring('address family ')] unsigned short sa_family;
			[helpstring('up to 14 bytes of direct address (not in network order, not host order)')] CHAR sa_data[14];
		} sockaddr;
"

	self
		defineField: #sa_family type: WORDField new offset: 0;
		defineField: #sa_data type: (ArrayField type: ByteArray length: 14) offset: 2.
	self byteSize: 16! !
!Sockaddr class categoriesFor: #defineFields!**auto generated**!initializing!public! !

