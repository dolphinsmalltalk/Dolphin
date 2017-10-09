"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_SSL_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_SET guid: (GUID fromString: '{f2c9434b-739e-4905-bcf3-d552724f69ff}')!
HTTP_SERVICE_CONFIG_SSL_SET comment: '<HTTP_SERVICE_CONFIG_SSL_SET> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(f2c9434b-739e-4905-bcf3-d552724f69ff), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSSLCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_SET {
	HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM ParamDesc;
} HTTP_SERVICE_CONFIG_SSL_SET;
'!
!HTTP_SERVICE_CONFIG_SSL_SET categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVICE_CONFIG_SSL_SET methodsFor!

KeyDesc
	"Answer the <SOCKADDR> value of the receiver's 'KeyDesc' field."

	^SOCKADDR fromAddress: (bytes intPtrAtOffset: 0)!

KeyDesc: aSOCKADDR
	"Set the receiver's 'KeyDesc' field to the value of the argument, aSOCKADDR"

	bytes uintPtrAtOffset: 0 put: aSOCKADDR yourAddress!

ParamDesc
	"Answer the <HTTP_SERVICE_CONFIG_SSL_PARAM> value of the receiver's 'ParamDesc' field."

	^HTTP_SERVICE_CONFIG_SSL_PARAM fromAddress: bytes yourAddress + ##(self offsetOf: #ParamDesc)!

ParamDesc: aHTTP_SERVICE_CONFIG_SSL_PARAM
	"Set the receiver's 'ParamDesc' field to the value of the argument, aHTTP_SERVICE_CONFIG_SSL_PARAM"

	aHTTP_SERVICE_CONFIG_SSL_PARAM
		replaceBytesOf: bytes
		from: ##((self offsetOf: #ParamDesc) + 1)
		to: ##((self offsetOf: #ParamDesc) + HTTP_SERVICE_CONFIG_SSL_PARAM basicByteSize)
		startingAt: 1! !
!HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #ParamDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SET categoriesFor: #ParamDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_SET class methodsFor!

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
	self byteSize: 56! !
!HTTP_SERVICE_CONFIG_SSL_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

