"Filed out from Dolphin Smalltalk"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM
	instanceVariableNames: 'address'
	classVariableNames: '_OffsetOf_AddrLength _OffsetOf_pAddress'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM guid: (GUID fromString: '{00a93e39-c011-4a5b-af4d-13f2df7a38d4}')!
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM addClassConstant: '_OffsetOf_AddrLength' value: 16r0!
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM addClassConstant: '_OffsetOf_pAddress' value: 16r4!
HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM comment: '<HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Set/Delete IP Listen-Only List record. Used as a parameter to both HttpSetServiceConfiguration() and HttpDeleteServiceConfiguration() functions."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(00a93e39-c011-4a5b-af4d-13f2df7a38d4), helpstring("Set/Delete IP Listen-Only List record. Used as a parameter to both HttpSetServiceConfiguration() and HttpDeleteServiceConfiguration() functions.")]
struct tagHTTP_SERVICE_CONFIG_IP_LISTEN_PARAM {
	[nonbrowsable, helpstring("The size, in bytes, of the address pointed to by pAddress.")] USHORT AddrLength;
	[helpstring("A pointer to an Internet Protocol (IP) address to be added to or deleted from the listen list.")] SOCKADDR* pAddress;
} HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM;
'!
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM methodsFor!

address
	^address ifNil: [address := self pAddress]!

address: aSOCKADDR
	self
		pAddress: aSOCKADDR;
		AddrLength: (aSOCKADDR ?? #[]) byteSize.
	address := aSOCKADDR!

AddrLength
	"Private - Answer the <Integer> value of the receiver's 'AddrLength' field."

	^bytes wordAtOffset: _OffsetOf_AddrLength!

AddrLength: anInteger
	"Set the receiver's 'AddrLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_AddrLength put: anInteger!

pAddress
	"Answer the <SOCKADDR> value of the receiver's 'pAddress' field."

	^SOCKADDR fromAddress: (bytes intPtrAtOffset: _OffsetOf_pAddress)!

pAddress: aSOCKADDR
	"Set the receiver's 'pAddress' field to the value of the argument, aSOCKADDR"

	bytes uintPtrAtOffset: _OffsetOf_pAddress put: aSOCKADDR yourAddress! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM categoriesForMethods!
address!accessing!public! !
address:!accessing!public! !
AddrLength!**compiled accessors**!private! !
AddrLength:!**compiled accessors**!private! !
pAddress!**compiled accessors**!public! !
pAddress:!**compiled accessors**!public! !
!

!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM structure.

	HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM compileDefinition

		typedef [uuid(00a93e39-c011-4a5b-af4d-13f2df7a38d4), helpstring('Set/Delete IP Listen-Only List record. Used as a parameter to both HttpSetServiceConfiguration() and HttpDeleteServiceConfiguration() functions.')]
		struct tagHTTP_SERVICE_CONFIG_IP_LISTEN_PARAM {
			[nonbrowsable, helpstring('The size, in bytes, of the address pointed to by pAddress.')] USHORT AddrLength;
			[helpstring('A pointer to an Internet Protocol (IP) address to be added to or deleted from the listen list.')] SOCKADDR* pAddress;
		} HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM;
"

	self
		defineField: #AddrLength type: WORDField new beNonBrowsable offset: 0;
		defineField: #pAddress type: (PointerField type: SOCKADDR) offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#AddrLength #pAddress)! !
!HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

