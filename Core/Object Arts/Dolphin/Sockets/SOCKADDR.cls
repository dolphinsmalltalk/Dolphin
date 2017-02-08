"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SOCKADDR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SOCKADDR guid: (GUID fromString: '{0299D3DE-9695-4177-9CE6-42AD495C8E57}')!
SOCKADDR comment: '<Sockaddr> is an <ExternalStructure> class to wrap the struct ''Win32.sockaddr'' from type information in the ''Win32 API'' library.

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
!SOCKADDR categoriesForClass!Win32-Structs! !
!SOCKADDR methodsFor!

sa_family
	"Answer the receiver's sa_family field as a Smalltalk object."

	^bytes wordAtOffset: 0!

sa_family: anObject
	"Set the receiver's sa_family field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!SOCKADDR categoriesFor: #sa_family!**compiled accessors**!public! !
!SOCKADDR categoriesFor: #sa_family:!**compiled accessors**!public! !

!SOCKADDR class methodsFor!

defineFields
	"Define the fields of the SOCKADDR structure.

	SOCKADDR  compileDefinition

		typedef [uuid(0299D3DE-9695-4177-9CE6-42AD495C8E57), helpstring('Structure used by kernel to store most addresses.')]
		struct tagSOCKADDR {
			[helpstring('Address family; AF_INET if an IPv4 address, AF_INET6 if IPv6')] unsigned short sa_family;
			[helpstring('Up to 14 bytes of direct address (note in network order, not host order)')] CHAR sa_data[14];
		} SOCKADDR;
"

	self
		defineField: #sa_family
		type: WORDField new
		offset: 0.
	self byteSize: 16!

fromAddress: anAddress
	| family ptr |
	anAddress isNull ifTrue: [^nil].
	ptr := anAddress asExternalAddress.
	family := ptr wordAtOffset: 0.
	^(family == WinSocketConstants.AF_INET
		ifTrue: [SOCKADDR_IN]
		ifFalse: 
			[self assert: [family == WinSocketConstants.AF_INET6].
			SOCKADDR_IN6]) basicNew
		initializeAtAddress: ptr! !
!SOCKADDR class categoriesFor: #defineFields!initializing!public! !
!SOCKADDR class categoriesFor: #fromAddress:!instance creation!public! !

