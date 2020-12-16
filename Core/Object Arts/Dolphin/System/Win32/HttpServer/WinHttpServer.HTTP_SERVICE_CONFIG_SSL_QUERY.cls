"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServiceConfigQuery subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwToken' -> 16r8.
		'_OffsetOf_KeyDesc' -> 16r4
	}!
WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY guid: (Core.GUID fromString: '{d0a38bb4-ba56-4dc6-9079-ac7694ef98ac}')!
WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY comment: '`HTTP_SERVICE_CONFIG_SSL_QUERY` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLCertInfo record from the SSL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(d0a38bb4-ba56-4dc6-9079-ac7694ef98ac), helpstring("Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLCertInfo record from the SSL store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_QUERY {
	HttpServiceConfigQuery;
	HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
	DWORD dwToken;
} HTTP_SERVICE_CONFIG_SSL_QUERY;
```
'!
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY categoriesForClass!Win32-Structs! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY methodsFor!

dwToken
	"Answer the <Integer> value of the receiver's 'dwToken' field."

	^bytes dwordAtOffset: _OffsetOf_dwToken!

dwToken: anInteger
	"Set the receiver's 'dwToken' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwToken put: anInteger!

KeyDesc
	"Answer the <SOCKADDR> value of the receiver's 'KeyDesc' field."

	^SOCKADDR fromAddress: (bytes intPtrAtOffset: _OffsetOf_KeyDesc)!

KeyDesc: aSOCKADDR
	"Set the receiver's 'KeyDesc' field to the value of the argument, aSOCKADDR"

	bytes uintPtrAtOffset: _OffsetOf_KeyDesc put: aSOCKADDR yourAddress! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #dwToken!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #dwToken:!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #KeyDesc!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #KeyDesc:!**compiled accessors**!public! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_QUERY structure.

	HTTP_SERVICE_CONFIG_SSL_QUERY compileDefinition

		typedef [uuid(d0a38bb4-ba56-4dc6-9079-ac7694ef98ac), helpstring('Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLCertInfo record from the SSL store.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_QUERY {
			HttpServiceConfigQuery;
			HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
			DWORD dwToken;
		} HTTP_SERVICE_CONFIG_SSL_QUERY;
"

	super defineFields.
	self
		defineField: #KeyDesc type: (PointerField type: SOCKADDR) offset: 4;
		defineField: #dwToken type: DWORDField new offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#QueryDesc #KeyDesc #dwToken)! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_QUERY class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

