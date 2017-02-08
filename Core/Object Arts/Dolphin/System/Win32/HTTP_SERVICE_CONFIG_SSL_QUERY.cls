"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_QUERY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_QUERY guid: (GUID fromString: '{D0A38BB4-BA56-4DC6-9079-AC7694EF98AC}')!
HTTP_SERVICE_CONFIG_SSL_QUERY comment: '<HTTP_SERVICE_CONFIG_SSL_QUERY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_QUERY'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLCertInfo record from the SSL store."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(D0A38BB4-BA56-4DC6-9079-AC7694EF98AC), helpstring("Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLCertInfo record from the SSL store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_QUERY {
	HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
	HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
	unsigned long dwToken;
} HTTP_SERVICE_CONFIG_SSL_QUERY;
'!
!HTTP_SERVICE_CONFIG_SSL_QUERY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_QUERY methodsFor!

dwToken
	"Answer the receiver's dwToken field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwToken)!

dwToken: anObject
	"Set the receiver's dwToken field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwToken) put: anObject!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^SOCKADDR fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #KeyDesc))!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #KeyDesc) put: anObject yourAddress!

QueryDesc
	"Answer the receiver's QueryDesc field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

QueryDesc: anObject
	"Set the receiver's QueryDesc field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #dwToken!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #dwToken:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #QueryDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_QUERY categoriesFor: #QueryDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_QUERY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_QUERY structure.

	HTTP_SERVICE_CONFIG_SSL_QUERY  compileDefinition

		typedef [uuid(D0A38BB4-BA56-4DC6-9079-AC7694EF98AC), helpstring('Used with HttpQueryServiceConfiguration() to query a HttpServiceConfigSSLCertInfo record from the SSL store.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_QUERY {
			HTTP_SERVICE_CONFIG_QUERY_TYPE QueryDesc;
			HTTP_SERVICE_CONFIG_SSL_KEY KeyDesc;
			unsigned long dwToken;
		} HTTP_SERVICE_CONFIG_SSL_QUERY;
"

	self
		defineField: #QueryDesc type: SDWORDField new offset: 0;
		defineField: #KeyDesc type: (PointerField type: SOCKADDR) offset: 4;
		defineField: #dwToken type: DWORDField new offset: 8.
	self byteSize: 12! !
!HTTP_SERVICE_CONFIG_SSL_QUERY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

