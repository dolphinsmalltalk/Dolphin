"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_KeyDesc' -> 16r0.
		'_OffsetOf_ParamDesc' -> 16r88
	}!
WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET guid: (Core.GUID fromString: '{4c2fb659-18f1-4258-beb7-2283ed27e94b}')!
WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET comment: '`HTTP_SERVICE_CONFIG_SSL_SNI_SET` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslSniCertInfo record to the SSL bindings list"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(4c2fb659-18f1-4258-beb7-2283ed27e94b), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslSniCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_SNI_SET {
	HTTP_SERVICE_CONFIG_SSL_SNI_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM ParamDesc;
} HTTP_SERVICE_CONFIG_SSL_SNI_SET;
```
'!
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET methodsFor!

KeyDesc
	"Answer the <HTTP_SERVICE_CONFIG_SSL_SNI_KEY> value of the receiver's 'KeyDesc' field."

	^HTTP_SERVICE_CONFIG_SSL_SNI_KEY fromAddress: bytes yourAddress!

KeyDesc: aHTTP_SERVICE_CONFIG_SSL_SNI_KEY
	"Set the receiver's 'KeyDesc' field to the value of the argument, aHTTP_SERVICE_CONFIG_SSL_SNI_KEY"

	aHTTP_SERVICE_CONFIG_SSL_SNI_KEY
		replaceBytesOf: bytes
		from: ##(_OffsetOf_KeyDesc + 1)
		to: ##(_OffsetOf_KeyDesc + HTTP_SERVICE_CONFIG_SSL_SNI_KEY basicByteSize)
		startingAt: 1!

ParamDesc
	"Answer the <HTTP_SERVICE_CONFIG_SSL_PARAM> value of the receiver's 'ParamDesc' field."

	^HTTP_SERVICE_CONFIG_SSL_PARAM fromAddress: bytes yourAddress + _OffsetOf_ParamDesc!

ParamDesc: aHTTP_SERVICE_CONFIG_SSL_PARAM
	"Set the receiver's 'ParamDesc' field to the value of the argument, aHTTP_SERVICE_CONFIG_SSL_PARAM"

	aHTTP_SERVICE_CONFIG_SSL_PARAM
		replaceBytesOf: bytes
		from: ##(_OffsetOf_ParamDesc + 1)
		to: ##(_OffsetOf_ParamDesc + HTTP_SERVICE_CONFIG_SSL_PARAM basicByteSize)
		startingAt: 1! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesFor: #ParamDesc!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesFor: #ParamDesc:!**compiled accessors**!public! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_SNI_SET structure.

	HTTP_SERVICE_CONFIG_SSL_SNI_SET compileDefinition

		typedef [uuid(4c2fb659-18f1-4258-beb7-2283ed27e94b), helpstring('Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslSniCertInfo record to the SSL bindings list')]
		struct tagHTTP_SERVICE_CONFIG_SSL_SNI_SET {
			HTTP_SERVICE_CONFIG_SSL_SNI_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_SSL_PARAM ParamDesc;
		} HTTP_SERVICE_CONFIG_SSL_SNI_SET;
"

	self
		defineField: #KeyDesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_SNI_KEY) offset: 0;
		defineField: #ParamDesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_PARAM) offset: 136.
	self byteSize: 192!

getFieldNames
	^#(#KeyDesc #ParamDesc)! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_SET class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

