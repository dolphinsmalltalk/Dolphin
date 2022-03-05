"Filed out from Dolphin Smalltalk"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_SSL_CCS_SET
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_KeyDesc _OffsetOf_ParamDesc'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_CCS_SET guid: (GUID fromString: '{078985f7-29b2-4403-8acf-074217e6e9f4}')!
HTTP_SERVICE_CONFIG_SSL_CCS_SET addClassConstant: '_OffsetOf_KeyDesc' value: 16r0!
HTTP_SERVICE_CONFIG_SSL_CCS_SET addClassConstant: '_OffsetOf_ParamDesc' value: 16r80!
HTTP_SERVICE_CONFIG_SSL_CCS_SET comment: '<HTTP_SERVICE_CONFIG_SSL_CCS_SET> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_CCS_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(078985f7-29b2-4403-8acf-074217e6e9f4), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_CCS_SET {
	HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM ParamDesc;
} HTTP_SERVICE_CONFIG_SSL_CCS_SET;
'!
!HTTP_SERVICE_CONFIG_SSL_CCS_SET categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET methodsFor!

KeyDesc
	"Answer the <SOCKADDR_STORAGE> value of the receiver's 'KeyDesc' field."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress!

KeyDesc: aSOCKADDR_STORAGE
	"Set the receiver's 'KeyDesc' field to the value of the argument, aSOCKADDR_STORAGE"

	aSOCKADDR_STORAGE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_KeyDesc + 1)
		to: ##(_OffsetOf_KeyDesc + SOCKADDR_STORAGE basicByteSize)
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
!HTTP_SERVICE_CONFIG_SSL_CCS_SET categoriesForMethods!
KeyDesc!**compiled accessors**!public! !
KeyDesc:!**compiled accessors**!public! !
ParamDesc!**compiled accessors**!public! !
ParamDesc:!**compiled accessors**!public! !
!

!HTTP_SERVICE_CONFIG_SSL_CCS_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_CCS_SET structure.

	HTTP_SERVICE_CONFIG_SSL_CCS_SET compileDefinition

		typedef [uuid(078985f7-29b2-4403-8acf-074217e6e9f4), helpstring('Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list')]
		struct tagHTTP_SERVICE_CONFIG_SSL_CCS_SET {
			HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_SSL_PARAM ParamDesc;
		} HTTP_SERVICE_CONFIG_SSL_CCS_SET;
"

	self
		defineField: #KeyDesc type: (StructureField type: SOCKADDR_STORAGE) offset: 0;
		defineField: #ParamDesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_PARAM) offset: 128.
	self byteSize: 184!

getFieldNames
	^#(#KeyDesc #ParamDesc)! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

