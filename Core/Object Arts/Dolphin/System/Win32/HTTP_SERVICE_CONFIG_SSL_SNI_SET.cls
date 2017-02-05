"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_SNI_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_SNI_SET guid: (GUID fromString: '{4C2FB659-18F1-4258-BEB7-2283ED27E94B}')!
HTTP_SERVICE_CONFIG_SSL_SNI_SET comment: '<HTTP_SERVICE_CONFIG_SSL_SNI_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_SNI_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslSniCertInfo record to the SSL bindings list"

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(4C2FB659-18F1-4258-BEB7-2283ED27E94B), helpstring("Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslSniCertInfo record to the SSL bindings list")]
struct tagHTTP_SERVICE_CONFIG_SSL_SNI_SET {
	HTTP_SERVICE_CONFIG_SSL_SNI_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_SSL_PARAM paramdesc;
} HTTP_SERVICE_CONFIG_SSL_SNI_SET;
'!
!HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_SNI_SET methodsFor!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^HTTP_SERVICE_CONFIG_SSL_SNI_KEY fromAddress: bytes yourAddress!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: 1
		to: ##(HTTP_SERVICE_CONFIG_SSL_SNI_KEY basicByteSize)
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
!HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesFor: #paramdesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_SET categoriesFor: #paramdesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_SNI_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_SNI_SET structure.

	HTTP_SERVICE_CONFIG_SSL_SNI_SET  compileDefinition

		typedef [uuid(4C2FB659-18F1-4258-BEB7-2283ED27E94B), helpstring('Used by HttpSetServiceConfiguration() to add a new HttpServiceConfigSslSniCertInfo record to the SSL bindings list')]
		struct tagHTTP_SERVICE_CONFIG_SSL_SNI_SET {
			HTTP_SERVICE_CONFIG_SSL_SNI_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_SSL_PARAM paramdesc;
		} HTTP_SERVICE_CONFIG_SSL_SNI_SET;
"

	self
		defineField: #KeyDesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_SNI_KEY) offset: 0;
		defineField: #paramdesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_PARAM) offset: 136.
	self byteSize: 192! !
!HTTP_SERVICE_CONFIG_SSL_SNI_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

