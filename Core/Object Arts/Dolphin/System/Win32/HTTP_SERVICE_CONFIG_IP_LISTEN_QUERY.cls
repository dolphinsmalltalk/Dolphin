"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY guid: (GUID fromString: '{3EEBCB9D-9DC3-4701-A044-C16DF022085B}')!
HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY comment: '<HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Query IP Listen-Only List record. Parameter to HttpQueryServiceConfiguration() for the config ID HttpServiceConfigIPListenList."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(3EEBCB9D-9DC3-4701-A044-C16DF022085B), helpstring("Query IP Listen-Only List record. Parameter to HttpQueryServiceConfiguration() for the config ID HttpServiceConfigIPListenList.")]
struct tagHTTP_SERVICE_CONFIG_IP_LISTEN_QUERY {
	unsigned long AddrCount;
	SOCKADDR_STORAGE AddrList[1];
} HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY;
'!
!HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY methodsFor!

AddrCount
	"Answer the receiver's AddrCount field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

AddrCount: anObject
	"Set the receiver's AddrCount field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

AddrList
	"Answer the receiver's AddrList field as a Smalltalk object."

	^StructureArray
		fromAddress: bytes yourAddress + ##(self offsetOf: #AddrList)
		length: self AddrCount
		elementClass: SOCKADDR_STORAGE!

AddrList: anObject
	"Set the receiver's AddrList field to the value of anObject."

	| size |
	size := anObject byteSize min: self AddrCount * ##(SOCKADDR_STORAGE basicByteSize).
	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #AddrList) + 1)
		to: ##(self offsetOf: #AddrList) + size
		startingAt: 1! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY categoriesFor: #AddrCount!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY categoriesFor: #AddrCount:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY categoriesFor: #AddrList!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY categoriesFor: #AddrList:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY structure.

	HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY  compileDefinition

		typedef [uuid(3EEBCB9D-9DC3-4701-A044-C16DF022085B), helpstring('Query IP Listen-Only List record. Parameter to HttpQueryServiceConfiguration() for the config ID HttpServiceConfigIPListenList.')]
		struct tagHTTP_SERVICE_CONFIG_IP_LISTEN_QUERY {
			[helpstring('The number of address structures in the AddrList array.')] unsigned long AddrCount;
			[helpstring('An array of SOCKADDR_STORAGE structures that contains IP addresses in either IPv4 or IPv6 form. To determine what form an address in the list has, cast it to a SOCKADDR and examine the sa_family element.')] SOCKADDR_STORAGE AddrList[1];
		} HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY;
"

	self
		defineField: #AddrCount
			type: DWORDField new
			offset: 0;
		defineField: #AddrList
			type: (ConformantStructureArrayField type: SOCKADDR_STORAGE length: #AddrCount)
			offset: 8.
	self byteSize: 136! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY class categoriesFor: #defineFields!initializing!public! !

