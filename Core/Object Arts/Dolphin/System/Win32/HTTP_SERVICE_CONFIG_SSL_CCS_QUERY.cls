"Filed out from Dolphin Smalltalk 7"!

HttpServiceConfigQuery subclass: #HTTP_SERVICE_CONFIG_SSL_CCS_QUERY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_CCS_QUERY guid: (GUID fromString: '{d6a678d5-678e-4bf6-ab65-77c8e6a641a9}')!
HTTP_SERVICE_CONFIG_SSL_CCS_QUERY comment: '<HTTP_SERVICE_CONFIG_SSL_CCS_QUERY> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSslCcsCertInfo record from the SSL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(d6a678d5-678e-4bf6-ab65-77c8e6a641a9), helpstring("Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSslCcsCertInfo record from the SSL store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_CCS_QUERY {
	HttpServiceConfigQuery;
	HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
	DWORD dwToken;
} HTTP_SERVICE_CONFIG_SSL_CCS_QUERY;
'!
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY methodsFor!

dwToken
	"Answer the <Integer> value of the receiver's 'dwToken' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwToken)!

dwToken: anInteger
	"Set the receiver's 'dwToken' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwToken) put: anInteger!

KeyDesc
	"Answer the <SOCKADDR_STORAGE> value of the receiver's 'KeyDesc' field."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress + ##(self offsetOf: #KeyDesc)!

KeyDesc: aSOCKADDR_STORAGE
	"Set the receiver's 'KeyDesc' field to the value of the argument, aSOCKADDR_STORAGE"

	aSOCKADDR_STORAGE
		replaceBytesOf: bytes
		from: ##((self offsetOf: #KeyDesc) + 1)
		to: ##((self offsetOf: #KeyDesc) + SOCKADDR_STORAGE basicByteSize)
		startingAt: 1! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #dwToken!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #dwToken:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #KeyDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_CCS_QUERY structure.

	HTTP_SERVICE_CONFIG_SSL_CCS_QUERY compileDefinition

		typedef [uuid(d6a678d5-678e-4bf6-ab65-77c8e6a641a9), helpstring('Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSslCcsCertInfo record from the SSL store.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_CCS_QUERY {
			HttpServiceConfigQuery;
			HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
			DWORD dwToken;
		} HTTP_SERVICE_CONFIG_SSL_CCS_QUERY;
"

	super defineFields.
	self
		defineField: #KeyDesc type: (StructureField type: SOCKADDR_STORAGE) offset: 8;
		defineField: #dwToken type: DWORDField new offset: 136.
	self byteSize: 144! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

