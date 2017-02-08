"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_CCS_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_CCS_SET guid: (GUID fromString: '{078985F7-29B2-4403-8ACF-074217E6E9F4}')!
HTTP_SERVICE_CONFIG_SSL_CCS_SET comment: '<HTTP_SERVICE_CONFIG_SSL_CCS_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_CCS_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(078985F7-29B2-4403-8ACF-074217E6E9F4), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_CCS_SET {
	HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM paramdesc;
} HTTP_SERVICE_CONFIG_SSL_CCS_SET;
'!
!HTTP_SERVICE_CONFIG_SSL_CCS_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_CCS_SET methodsFor!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: 1
		to: ##(SOCKADDR_STORAGE basicByteSize)
		startingAt: 1!

paramdesc
	"Answer the receiver's paramdesc field as a Smalltalk object."

	^HTTP_SERVICE_CONFIG_SSL_PARAM fromAddress: bytes yourAddress + ##(self offsetOf: #paramdesc)!

paramdesc: anObject
	"Set the receiver's paramdesc field to the value of anObject."

	anObject
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

	HTTP_SERVICE_CONFIG_SSL_CCS_SET  compileDefinition

		typedef [uuid(078985F7-29B2-4403-8ACF-074217E6E9F4), helpstring('Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslCcsCertInfo record to the SSL bindings list')]
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

