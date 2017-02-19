"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_SSL_CCS_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_CCS_SET guid: (GUID fromString: '{078985f7-29b2-4403-8acf-074217e6e9f4}')!
HTTP_SERVICE_CONFIG_SSL_CCS_SET comment: '<HTTP_SERVICE_CONFIG_SSL_CCS_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_CCS_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(078985f7-29b2-4403-8acf-074217e6e9f4), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_CCS_SET {
	HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM paramdesc;
} HTTP_SERVICE_CONFIG_SSL_CCS_SET;
'!
!HTTP_SERVICE_CONFIG_SSL_CCS_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET methodsFor!

KeyDesc
	"Answer the <SOCKADDR_STORAGE> value of the receiver's 'KeyDesc' field."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress!

KeyDesc: aSOCKADDR_STORAGE
	"Set the receiver's 'KeyDesc' field to the value of the argument, aSOCKADDR_STORAGE"

	aSOCKADDR_STORAGE
		replaceBytesOf: bytes
		from: 1
		to: ##(SOCKADDR_STORAGE basicByteSize)
		startingAt: 1!

paramdesc
	"Answer the <HTTP_SERVICE_CONFIG_SSL_PARAM> value of the receiver's 'paramdesc' field."

	^HTTP_SERVICE_CONFIG_SSL_PARAM fromAddress: bytes yourAddress + ##(self offsetOf: #paramdesc)!

paramdesc: aHTTP_SERVICE_CONFIG_SSL_PARAM
	"Set the receiver's 'paramdesc' field to the value of the argument, aHTTP_SERVICE_CONFIG_SSL_PARAM"

	aHTTP_SERVICE_CONFIG_SSL_PARAM
		replaceBytesOf: bytes
		from: ##((self offsetOf: #paramdesc) + 1)
		to: ##((self offsetOf: #paramdesc) + HTTP_SERVICE_CONFIG_SSL_PARAM basicByteSize)
		startingAt: 1! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET categoriesFor: #paramdesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET categoriesFor: #paramdesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_CCS_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_CCS_SET structure.

	HTTP_SERVICE_CONFIG_SSL_CCS_SET compileDefinition

		typedef [uuid(078985f7-29b2-4403-8acf-074217e6e9f4), helpstring('Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list')]
		struct tagHTTP_SERVICE_CONFIG_SSL_CCS_SET {
			HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_SSL_PARAM paramdesc;
		} HTTP_SERVICE_CONFIG_SSL_CCS_SET;
"

	self
		defineField: #KeyDesc type: (StructureField type: SOCKADDR_STORAGE) offset: 0;
		defineField: #paramdesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_PARAM) offset: 128.
	self byteSize: 184! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

