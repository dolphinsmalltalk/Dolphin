"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY_Size' -> 16r88.
			'_OffsetOf_AddrCount' -> 16r0.
			'_OffsetOf_AddrList' -> 16r8
		}!
WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY guid: (Core.GUID fromString: '{3eebcb9d-9dc3-4701-a044-c16df022085b}')!
WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY comment: '`HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Query IP Listen-Only List record. Parameter to HttpQueryServiceConfiguration() for the config ID HttpServiceConfigIPListenList."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(3eebcb9d-9dc3-4701-a044-c16df022085b), helpstring("Query IP Listen-Only List record. Parameter to HttpQueryServiceConfiguration() for the config ID HttpServiceConfigIPListenList.")]
struct tagHTTP_SERVICE_CONFIG_IP_LISTEN_QUERY {
	[nonbrowsable, helpstring("The number of address structures in the AddrList array.")] ULONG AddrCount;
	[helpstring("An array of SOCKADDR_STORAGE structures that contains IP addresses in either IPv4 or IPv6 form. To determine what form an address in the list has, cast it to a SOCKADDR and examine the sa_family element."), size_is("AddrCount")] SOCKADDR_STORAGE AddrList[1];
} HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY;
```
'!
!WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY methodsFor!

AddrCount
	"Private - Answer the <Integer> value of the receiver's 'AddrCount' field."

	^bytes uint32AtOffset: _OffsetOf_AddrCount!

AddrCount: anInteger
	"Set the receiver's 'AddrCount' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_AddrCount put: anInteger!

AddrList
	"Answer the <StructureArray> value of the receiver's 'AddrList' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_AddrList
		length: self AddrCount
		elementClass: SOCKADDR_STORAGE!

AddrList: aStructureArrayOfSOCKADDR_STORAGE
	"Set the receiver's 'AddrList' field to the value of the argument, aStructureArrayOfSOCKADDR_STORAGE"

	| size |
	size := aStructureArrayOfSOCKADDR_STORAGE byteSize.
	aStructureArrayOfSOCKADDR_STORAGE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_AddrList + 1)
		to: _OffsetOf_AddrList + size
		startingAt: 1.
	self AddrCount: aStructureArrayOfSOCKADDR_STORAGE size! !
!WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY categoriesForMethods!
AddrCount!**compiled accessors**!private! !
AddrCount:!**compiled accessors**!private! !
AddrList!**compiled accessors**!public! !
AddrList:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY class methodsFor!

byteSize
	^_HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY_Size!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY structure.

	HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY compileDefinition

		typedef [uuid(3eebcb9d-9dc3-4701-a044-c16df022085b), helpstring('Query IP Listen-Only List record. Parameter to HttpQueryServiceConfiguration() for the config ID HttpServiceConfigIPListenList.')]
		struct tagHTTP_SERVICE_CONFIG_IP_LISTEN_QUERY {
			[nonbrowsable, helpstring('The number of address structures in the AddrList array.')] ULONG AddrCount;
			[helpstring('An array of SOCKADDR_STORAGE structures that contains IP addresses in either IPv4 or IPv6 form. To determine what form an address in the list has, cast it to a SOCKADDR and examine the sa_family element.'), size_is('AddrCount')] SOCKADDR_STORAGE AddrList[1];
		} HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY;
"

	self
		defineField: #AddrCount type: UInt32Field new beNonBrowsable offset: 0;
		defineField: #AddrList type: (StructureArrayField type: SOCKADDR_STORAGE lengthField: #AddrCount) offset: 8.
	self byteSize: 136!

getFieldNames
	^#(#AddrCount #AddrList)! !
!WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

