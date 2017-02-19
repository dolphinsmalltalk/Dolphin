"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SSL_CLIENT_CERT_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SSL_CLIENT_CERT_INFO guid: (GUID fromString: '{2ea1d77c-9411-49f7-af99-3554a22fe89e}')!
HTTP_SSL_CLIENT_CERT_INFO comment: '<HTTP_SSL_CLIENT_CERT_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SSL_CLIENT_CERT_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"SSL Client certificate information."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(2ea1d77c-9411-49f7-af99-3554a22fe89e), helpstring("SSL Client certificate information.")]
struct tagHTTP_SSL_CLIENT_CERT_INFO {
	[helpstring("Flags that indicate whether the certificate is valid. ")] ULONG CertFlags;
	[nonbrowsable, helpstring("The size, in bytes, of the certificate")] ULONG CertEncodedSize;
	[helpstring("A pointer to the actual certificate."), size_is("CertEncodedSize")] UCHAR* pCertEncoded;
	[helpstring("A handle to an access token.")] HANDLE Token;
	[hidden, helpstring("Reserved.")] BOOLEAN CertDeniedByMapper;
} HTTP_SSL_CLIENT_CERT_INFO;
'!
!HTTP_SSL_CLIENT_CERT_INFO categoriesForClass!Win32-Structs! !
!HTTP_SSL_CLIENT_CERT_INFO methodsFor!

CertEncodedSize
	"Private - Answer the <Integer> value of the receiver's 'CertEncodedSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #CertEncodedSize)!

CertEncodedSize: anInteger
	"Set the receiver's 'CertEncodedSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #CertEncodedSize) put: anInteger!

CertFlags
	"Answer the <Integer> value of the receiver's 'CertFlags' field."

	^bytes dwordAtOffset: 0!

CertFlags: anInteger
	"Set the receiver's 'CertFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

pCertEncoded
	"Answer the <ExternalArray> value of the receiver's 'pCertEncoded' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pCertEncoded))
		length: self CertEncodedSize!

pCertEncoded: anExternalArray
	"Set the receiver's 'pCertEncoded' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: ##(self offsetOf: #pCertEncoded) put: anExternalArray yourAddress.
	self CertEncodedSize: anExternalArray size!

Token
	"Answer the <ExternalHandle> value of the receiver's 'Token' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #Token)) asExternalHandle!

Token: anExternalHandle
	"Set the receiver's 'Token' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #Token) put: anExternalHandle! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertEncodedSize!**compiled accessors**!private! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertEncodedSize:!**compiled accessors**!private! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertFlags!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #CertFlags:!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #pCertEncoded!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #pCertEncoded:!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #Token!**compiled accessors**!public! !
!HTTP_SSL_CLIENT_CERT_INFO categoriesFor: #Token:!**compiled accessors**!public! !

!HTTP_SSL_CLIENT_CERT_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_SSL_CLIENT_CERT_INFO structure.

	HTTP_SSL_CLIENT_CERT_INFO compileDefinition

		typedef [uuid(2ea1d77c-9411-49f7-af99-3554a22fe89e), helpstring('SSL Client certificate information.')]
		struct tagHTTP_SSL_CLIENT_CERT_INFO {
			[helpstring('Flags that indicate whether the certificate is valid. ')] ULONG CertFlags;
			[nonbrowsable, helpstring('The size, in bytes, of the certificate')] ULONG CertEncodedSize;
			[helpstring('A pointer to the actual certificate.'), size_is('CertEncodedSize')] UCHAR* pCertEncoded;
			[helpstring('A handle to an access token.')] HANDLE Token;
			[hidden, helpstring('Reserved.')] BOOLEAN CertDeniedByMapper;
		} HTTP_SSL_CLIENT_CERT_INFO;
"

	self
		defineField: #CertFlags type: DWORDField new offset: 0;
		defineField: #CertEncodedSize type: DWORDField new beNonBrowsable offset: 4;
		defineField: #pCertEncoded type: (ArrayPointerField type: ExternalArray lengthField: #CertEncodedSize) offset: 8;
		defineField: #Token type: HANDLEField new offset: 12;
		defineField: #CertDeniedByMapper type: BOOLEANField new beFiller offset: 16.
	self byteSize: 20! !
!HTTP_SSL_CLIENT_CERT_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

