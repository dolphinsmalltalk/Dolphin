"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServiceConfigQuery subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwToken' -> 16r88.
		'_OffsetOf_KeyDesc' -> 16r8
	}!
WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY guid: (Core.GUID fromString: '{d6a678d5-678e-4bf6-ab65-77c8e6a641a9}')!
WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY comment: '`HTTP_SERVICE_CONFIG_SSL_CCS_QUERY` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSslCcsCertInfo record from the SSL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(d6a678d5-678e-4bf6-ab65-77c8e6a641a9), helpstring("Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSslCcsCertInfo record from the SSL store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_CCS_QUERY {
	HttpServiceConfigQuery;
	HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
	DWORD dwToken;
} HTTP_SERVICE_CONFIG_SSL_CCS_QUERY;
```
'!
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY methodsFor!

dwToken
	"Answer the <Integer> value of the receiver's 'dwToken' field."

	^bytes dwordAtOffset: _OffsetOf_dwToken!

dwToken: anInteger
	"Set the receiver's 'dwToken' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwToken put: anInteger!

KeyDesc
	"Answer the <SOCKADDR_STORAGE> value of the receiver's 'KeyDesc' field."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress + _OffsetOf_KeyDesc!

KeyDesc: aSOCKADDR_STORAGE
	"Set the receiver's 'KeyDesc' field to the value of the argument, aSOCKADDR_STORAGE"

	aSOCKADDR_STORAGE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_KeyDesc + 1)
		to: ##(_OffsetOf_KeyDesc + SOCKADDR_STORAGE basicByteSize)
		startingAt: 1! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #dwToken!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #dwToken:!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #KeyDesc!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #KeyDesc:!**compiled accessors**!public! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY class methodsFor!

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
	self byteSize: 144!

getFieldNames
	^#(#QueryDesc #KeyDesc #dwToken)! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

