"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SSL_CLIENT_CERT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SSL_CLIENT_CERT_INFO guid: (GUID fromString: '{2EA1D77C-9411-49F7-AF99-3554A22FE89E}')!
HTTP_SSL_CLIENT_CERT_INFO comment: '<HTTP_SSL_CLIENT_CERT_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SSL_CLIENT_CERT_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"SSL Client certificate information."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2EA1D77C-9411-49F7-AF99-3554A22FE89E), helpstring("SSL Client certificate information.")]
struct tagHTTP_SSL_CLIENT_CERT_INFO {
	unsigned long CertFlags;
	unsigned long CertEncodedSize;
	BYTE* pCertEncoded;
	HANDLE Token;
	CHAR CertDeniedByMapper;
} HTTP_SSL_CLIENT_CERT_INFO;
'!
!HTTP_SSL_CLIENT_CERT_INFO categoriesForClass!Win32-Structs! !
!HTTP_SSL_CLIENT_CERT_INFO methodsFor!

CertDeniedByMapper
	"Answer the receiver's CertDeniedByMapper field as a Smalltalk object."

	^bytes sbyteAtOffset: ##(self offsetOf: #CertDeniedByMapper)!

CertDeniedByMapper: anObject
	"Set the receiver's CertDeniedByMapper field to the value of anObject."

	bytes sbyteAtOffset: ##(self offsetOf: #CertDeniedByMapper) put: anObject!

CertEncodedSize
	"Answer the receiver's CertEncodedSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #CertEncodedSize)!

CertEncodedSize: anObject
	"Set the receiver's CertEncodedSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #CertEncodedSize) put: anObject!

CertFlags
	"Answer the receiver's CertFlags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

CertFlags: anObject
	"Set the receiver's CertFlags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

pCertEncoded
	"Answer the receiver's pCertEncoded field as a Smalltalk object."

	^BYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pCertEncoded))!

pCertEncoded: anObject
	"Set the receiver's pCertEncoded field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pCertEncoded) put: anObject yourAddress!

Token
	"Answer the receiver's Token field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #Token)) asExternalHandle!

Token: anObject
	"Set the receiver's Token field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Token) put: anObject! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertDeniedByMapper!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertDeniedByMapper:!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertEncodedSize!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertEncodedSize:!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertFlags!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertFlags:!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #pCertEncoded!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #pCertEncoded:!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #Token!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #Token:!**compiled accessors**!public! !

!HTTP_SSL_CLIENT_CERT_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_SSL_CLIENT_CERT_INFO structure.

	HTTP_SSL_CLIENT_CERT_INFO  compileDefinition

		typedef [uuid(2EA1D77C-9411-49F7-AF99-3554A22FE89E), helpstring('SSL Client certificate information.')]
		struct tagHTTP_SSL_CLIENT_CERT_INFO {
			unsigned long CertFlags;
			unsigned long CertEncodedSize;
			BYTE* pCertEncoded;
			HANDLE Token;
			CHAR CertDeniedByMapper;
		} HTTP_SSL_CLIENT_CERT_INFO;
"

	self
		defineField: #CertFlags type: DWORDField new offset: 0;
		defineField: #CertEncodedSize type: DWORDField new offset: 4;
		defineField: #pCertEncoded type: (PointerField type: BYTE) offset: 8;
		defineField: #Token type: HANDLEField new offset: 12;
		defineField: #CertDeniedByMapper type: SBYTEField new offset: 16.
	self byteSize: 20! !
!HTTP_SSL_CLIENT_CERT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

