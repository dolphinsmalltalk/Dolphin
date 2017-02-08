"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_CCS_QUERY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_CCS_QUERY guid: (GUID fromString: '{D6A678D5-678E-4BF6-AB65-77C8E6A641A9}')!
HTTP_SERVICE_CONFIG_SSL_CCS_QUERY comment: '<HTTP_SERVICE_CONFIG_SSL_CCS_QUERY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_CCS_QUERY'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSslCcsCertInfo record from the SSL store."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(D6A678D5-678E-4BF6-AB65-77C8E6A641A9), helpstring("Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSslCcsCertInfo record from the SSL store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_CCS_QUERY {
	HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
	HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
	unsigned long dwToken;
} HTTP_SERVICE_CONFIG_SSL_CCS_QUERY;
'!
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY methodsFor!

dwToken
	"Answer the receiver's dwToken field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwToken)!

dwToken: anObject
	"Set the receiver's dwToken field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwToken) put: anObject!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress + ##(self offsetOf: #KeyDesc)!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #KeyDesc) + 1)
		to: ##((self offsetOf: #KeyDesc) + SOCKADDR_STORAGE basicByteSize)
		startingAt: 1!

QueryDesc
	"Answer the receiver's QueryDesc field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

QueryDesc: anObject
	"Set the receiver's QueryDesc field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #dwToken!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #dwToken:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #QueryDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY categoriesFor: #QueryDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_CCS_QUERY structure.

	HTTP_SERVICE_CONFIG_SSL_CCS_QUERY  compileDefinition

		typedef [uuid(D6A678D5-678E-4BF6-AB65-77C8E6A641A9), helpstring('Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSslCcsCertInfo record from the SSL store.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_CCS_QUERY {
			HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
			HTTP_SERVICE_CONFIG_SSL_CCS_KEY KeyDesc;
			unsigned long dwToken;
		} HTTP_SERVICE_CONFIG_SSL_CCS_QUERY;
"

	self
		defineField: #QueryDesc type: SDWORDField new offset: 0;
		defineField: #KeyDesc type: (StructureField type: SOCKADDR_STORAGE) offset: 8;
		defineField: #dwToken type: DWORDField new offset: 136.
	self byteSize: 144! !
!HTTP_SERVICE_CONFIG_SSL_CCS_QUERY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

