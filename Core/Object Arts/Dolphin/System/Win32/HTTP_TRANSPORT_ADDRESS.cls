"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_TRANSPORT_ADDRESS
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_TRANSPORT_ADDRESS guid: (GUID fromString: '{F0489E13-59AB-4951-8E32-1159AA1D6C90}')!
HTTP_TRANSPORT_ADDRESS comment: '<HTTP_TRANSPORT_ADDRESS> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_TRANSPORT_ADDRESS'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Structure defining format of transport address. Use pLocalAddress->sa_family to determine whether this is an IPv4 address (AF_INET) or IPv6 (AF_INET6). pRemoteAddress->sa_family will be the same as pLocalAddress->sa_family."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(F0489E13-59AB-4951-8E32-1159AA1D6C90), helpstring("Structure defining format of transport address. Use pLocalAddress->sa_family to determine whether this is an IPv4 address (AF_INET) or IPv6 (AF_INET6). pRemoteAddress->sa_family will be the same as pLocalAddress->sa_family.")]
struct tagHTTP_TRANSPORT_ADDRESS {
	sockaddr* pRemoteAddress;
	sockaddr* pLocalAddress;
} HTTP_TRANSPORT_ADDRESS;
'!
!HTTP_TRANSPORT_ADDRESS categoriesForClass!Win32-Structs! !
!HTTP_TRANSPORT_ADDRESS methodsFor!

pLocalAddress
	"Answer the receiver's pLocalAddress field as a Smalltalk object."

	^Sockaddr fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pLocalAddress))!

pLocalAddress: anObject
	"Set the receiver's pLocalAddress field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pLocalAddress) put: anObject yourAddress!

pRemoteAddress
	"Answer the receiver's pRemoteAddress field as a Smalltalk object."

	^Sockaddr fromAddress: (bytes intPtrAtOffset: 0)!

pRemoteAddress: anObject
	"Set the receiver's pRemoteAddress field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress! !
!HTTP_TRANSPORT_ADDRESS categoriesFor: #pLocalAddress!**compiled accessors**!public! !
!HTTP_TRANSPORT_ADDRESS categoriesFor: #pLocalAddress:!**compiled accessors**!public! !
!HTTP_TRANSPORT_ADDRESS categoriesFor: #pRemoteAddress!**compiled accessors**!public! !
!HTTP_TRANSPORT_ADDRESS categoriesFor: #pRemoteAddress:!**compiled accessors**!public! !

!HTTP_TRANSPORT_ADDRESS class methodsFor!

defineFields
	"Define the fields of the HTTP_TRANSPORT_ADDRESS structure.

	HTTP_TRANSPORT_ADDRESS  compileDefinition

		typedef [uuid(F0489E13-59AB-4951-8E32-1159AA1D6C90), helpstring('Structure defining format of transport address. Use pLocalAddress->sa_family to determine whether this is an IPv4 address (AF_INET) or IPv6 (AF_INET6). pRemoteAddress->sa_family will be the same as pLocalAddress->sa_family.')]
		struct tagHTTP_TRANSPORT_ADDRESS {
			sockaddr* pRemoteAddress;
			sockaddr* pLocalAddress;
		} HTTP_TRANSPORT_ADDRESS;
"

	self
		defineField: #pRemoteAddress type: (PointerField type: Sockaddr) offset: 0;
		defineField: #pLocalAddress type: (PointerField type: Sockaddr) offset: 4.
	self byteSize: 8! !
!HTTP_TRANSPORT_ADDRESS class categoriesFor: #defineFields!**auto generated**!initializing!public! !

