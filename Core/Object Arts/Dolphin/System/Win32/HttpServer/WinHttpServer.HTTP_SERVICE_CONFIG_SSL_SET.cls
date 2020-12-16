"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_KeyDesc' -> 16r0.
		'_OffsetOf_ParamDesc' -> 16r4
	}!
WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET guid: (Core.GUID fromString: '{f2c9434b-739e-4905-bcf3-d552724f69ff}')!
WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET comment: '`HTTP_SERVICE_CONFIG_SSL_SET` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(f2c9434b-739e-4905-bcf3-d552724f69ff), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_SET {
	HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM ParamDesc;
} HTTP_SERVICE_CONFIG_SSL_SET;
```
'!
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET methodsFor!

KeyDesc
	"Answer the <SOCKADDR> value of the receiver's 'KeyDesc' field."

	^SOCKADDR fromAddress: (bytes intPtrAtOffset: _OffsetOf_KeyDesc)!

KeyDesc: aSOCKADDR
	"Set the receiver's 'KeyDesc' field to the value of the argument, aSOCKADDR"

	bytes uintPtrAtOffset: _OffsetOf_KeyDesc put: aSOCKADDR yourAddress!

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
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #ParamDesc!**compiled accessors**!public! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #ParamDesc:!**compiled accessors**!public! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_SET structure.

	HTTP_SERVICE_CONFIG_SSL_SET compileDefinition

		typedef [uuid(f2c9434b-739e-4905-bcf3-d552724f69ff), helpstring('Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list')]
		struct tagHTTP_SERVICE_CONFIG_SSL_SET {
			HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_SSL_PARAM ParamDesc;
		} HTTP_SERVICE_CONFIG_SSL_SET;
"

	self
		defineField: #KeyDesc type: (PointerField type: SOCKADDR) offset: 0;
		defineField: #ParamDesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_PARAM) offset: 4.
	self byteSize: 56!

getFieldNames
	^#(#KeyDesc #ParamDesc)! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

