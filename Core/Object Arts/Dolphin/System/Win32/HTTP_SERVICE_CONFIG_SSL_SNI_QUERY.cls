"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_SNI_QUERY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_SNI_QUERY guid: (GUID fromString: '{4D8CBFDF-8766-4E01-A7F0-C775406DD04C}')!
HTTP_SERVICE_CONFIG_SSL_SNI_QUERY comment: '<HTTP_SERVICE_CONFIG_SSL_SNI_QUERY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_SNI_QUERY'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLSniCertInfo record from the SSL store."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(4D8CBFDF-8766-4E01-A7F0-C775406DD04C), helpstring("Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLSniCertInfo record from the SSL store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_SNI_QUERY {
	HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
	HTTP_SERVICE_CONFIG_SSL_SNI_KEY KeyDesc;
	unsigned long dwToken;
} HTTP_SERVICE_CONFIG_SSL_SNI_QUERY;
'!
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY methodsFor!

dwToken
	"Answer the receiver's dwToken field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwToken)!

dwToken: anObject
	"Set the receiver's dwToken field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwToken) put: anObject!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^HTTP_SERVICE_CONFIG_SSL_SNI_KEY fromAddress: bytes yourAddress + ##(self offsetOf: #KeyDesc)!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #KeyDesc) + 1)
		to: ##((self offsetOf: #KeyDesc) + HTTP_SERVICE_CONFIG_SSL_SNI_KEY basicByteSize)
		startingAt: 1!

QueryDesc
	"Answer the receiver's QueryDesc field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

QueryDesc: anObject
	"Set the receiver's QueryDesc field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #dwToken!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #dwToken:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #QueryDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY categoriesFor: #QueryDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_SNI_QUERY structure.

	HTTP_SERVICE_CONFIG_SSL_SNI_QUERY  compileDefinition

		typedef [uuid(4D8CBFDF-8766-4E01-A7F0-C775406DD04C), helpstring('Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLSniCertInfo record from the SSL store.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_SNI_QUERY {
			HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
			HTTP_SERVICE_CONFIG_SSL_SNI_KEY KeyDesc;
			unsigned long dwToken;
		} HTTP_SERVICE_CONFIG_SSL_SNI_QUERY;
"

	self
		defineField: #QueryDesc type: SDWORDField new offset: 0;
		defineField: #KeyDesc type: (StructureField type: HTTP_SERVICE_CONFIG_SSL_SNI_KEY) offset: 8;
		defineField: #dwToken type: DWORDField new offset: 144.
	self byteSize: 152! !
!HTTP_SERVICE_CONFIG_SSL_SNI_QUERY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

