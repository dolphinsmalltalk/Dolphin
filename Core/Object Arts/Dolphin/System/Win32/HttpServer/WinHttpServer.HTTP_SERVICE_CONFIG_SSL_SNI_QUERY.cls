"Filed out from Dolphin Smalltalk 7"!

HttpServiceConfigQuery subclass: #HTTP_SERVICE_CONFIG_SSL_SNI_QUERY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwToken' -> 16r90.
		'_OffsetOf_KeyDesc' -> 16r8
	}!
HTTP_SERVICE_CONFIG_SSL_SNI_QUERY guid: (GUID fromString: '{4d8cbfdf-8766-4e01-a7f0-c775406dd04c}')!
HTTP_SERVICE_CONFIG_SSL_SNI_QUERY comment: '<HTTP_SERVICE_CONFIG_SSL_SNI_QUERY> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_QUERY'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLSniCertInfo record from the SSL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(4d8cbfdf-8766-4e01-a7f0-c775406dd04c), helpstring("Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLSniCertInfo record from the SSL store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_SNI_QUERY {
	HttpServiceConfigQuery;
	HTTP_SERVICE_CONFIG_SSL_SNI_KEY KeyDesc;
	DWORD dwToken;
} HTTP_SERVICE_CONFIG_SSL_SNI_QUERY;
'!
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY methodsFor!

dwToken
	"Answer the <Integer> value of the receiver's 'dwToken' field."

	^bytes dwordAtOffset: _OffsetOf_dwToken!

dwToken: anInteger
	"Set the receiver's 'dwToken' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwToken put: anInteger!

KeyDesc
	"Answer the <HTTP_SERVICE_CONFIG_SSL_SNI_KEY> value of the receiver's 'KeyDesc' field."

	^HTTP_SERVICE_CONFIG_SSL_SNI_KEY fromAddress: bytes yourAddress + _OffsetOf_KeyDesc!

KeyDesc: aHTTP_SERVICE_CONFIG_SSL_SNI_KEY
	"Set the receiver's 'KeyDesc' field to the value of the argument, aHTTP_SERVICE_CONFIG_SSL_SNI_KEY"

	aHTTP_SERVICE_CONFIG_SSL_SNI_KEY
		replaceBytesOf: bytes
		from: ##(_OffsetOf_KeyDesc + 1)
		to: ##(_OffsetOf_KeyDesc + HTTP_SERVICE_CONFIG_SSL_SNI_KEY basicByteSize)
		startingAt: 1! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #dwToken!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #dwToken:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #KeyDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_SNI_QUERY structure.

	HTTP_SERVICE_CONFIG_SSL_SNI_QUERY compileDefinition

		typedef [uuid(4d8cbfdf-8766-4e01-a7f0-c775406dd04c), helpstring('Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLSniCertInfo record from the SSL store.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_SNI_QUERY {
			HttpServiceConfigQuery;
			HTTP_SERVICE_CONFIG_SSL_SNI_KEY KeyDesc;
			DWORD dwToken;
		} HTTP_SERVICE_CONFIG_SSL_SNI_QUERY;
"

	super defineFields.
	self
		defineField: #KeyDesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_SNI_KEY) offset: 8;
		defineField: #dwToken type: DWORDField new offset: 144.
	self byteSize: 152!

getFieldNames
	^#(#QueryDesc #KeyDesc #dwToken)! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

