"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SSL_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SSL_INFO guid: (GUID fromString: '{FD0D6F69-8AFE-4748-A88B-9FB70593DFC8}')!
HTTP_SSL_INFO comment: '<HTTP_SSL_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SSL_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Data computed during SSL handshake."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(FD0D6F69-8AFE-4748-A88B-9FB70593DFC8), helpstring("Data computed during SSL handshake.")]
struct tagHTTP_SSL_INFO {
	unsigned short ServerCertKeySize;
	unsigned short ConnectionKeySize;
	unsigned long ServerCertIssuerSize;
	unsigned long ServerCertSubjectSize;
	LPCSTR pServerCertIssuer;
	LPCSTR pServerCertSubject;
	PHTTP_SSL_CLIENT_CERT_INFO pClientCertInfo;
	unsigned long SslClientCertNegotiated;
} HTTP_SSL_INFO;
'!
!HTTP_SSL_INFO categoriesForClass!Win32-Structs! !
!HTTP_SSL_INFO methodsFor!

ConnectionKeySize
	"Answer the receiver's ConnectionKeySize field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #ConnectionKeySize)!

ConnectionKeySize: anObject
	"Set the receiver's ConnectionKeySize field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #ConnectionKeySize) put: anObject!

pClientCertInfo
	"Answer the receiver's pClientCertInfo field as a Smalltalk object."

	^HTTP_SSL_CLIENT_CERT_INFO fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pClientCertInfo))!

pClientCertInfo: anObject
	"Set the receiver's pClientCertInfo field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pClientCertInfo) put: anObject yourAddress!

pServerCertIssuer
	"Answer the receiver's pServerCertIssuer field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pServerCertIssuer))!

pServerCertIssuer: anObject
	"Set the receiver's pServerCertIssuer field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pServerCertIssuer) put: anObject yourAddress!

pServerCertSubject
	"Answer the receiver's pServerCertSubject field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pServerCertSubject))!

pServerCertSubject: anObject
	"Set the receiver's pServerCertSubject field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pServerCertSubject) put: anObject yourAddress!

ServerCertIssuerSize
	"Answer the receiver's ServerCertIssuerSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ServerCertIssuerSize)!

ServerCertIssuerSize: anObject
	"Set the receiver's ServerCertIssuerSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ServerCertIssuerSize) put: anObject!

ServerCertKeySize
	"Answer the receiver's ServerCertKeySize field as a Smalltalk object."

	^bytes wordAtOffset: 0!

ServerCertKeySize: anObject
	"Set the receiver's ServerCertKeySize field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject!

ServerCertSubjectSize
	"Answer the receiver's ServerCertSubjectSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ServerCertSubjectSize)!

ServerCertSubjectSize: anObject
	"Set the receiver's ServerCertSubjectSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ServerCertSubjectSize) put: anObject!

SslClientCertNegotiated
	"Answer the receiver's SslClientCertNegotiated field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #SslClientCertNegotiated)!

SslClientCertNegotiated: anObject
	"Set the receiver's SslClientCertNegotiated field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #SslClientCertNegotiated) put: anObject! !
!HTTP_SSL_INFO categoriesFor: #ConnectionKeySize!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #ConnectionKeySize:!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #pClientCertInfo!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #pClientCertInfo:!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #pServerCertIssuer!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #pServerCertIssuer:!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #pServerCertSubject!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #pServerCertSubject:!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #ServerCertIssuerSize!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #ServerCertIssuerSize:!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #ServerCertKeySize!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #ServerCertKeySize:!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #ServerCertSubjectSize!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #ServerCertSubjectSize:!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #SslClientCertNegotiated!**compiled accessors**!public! !
!HTTP_SSL_INFO categoriesFor: #SslClientCertNegotiated:!**compiled accessors**!public! !

!HTTP_SSL_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_SSL_INFO structure.

	HTTP_SSL_INFO  compileDefinition

		typedef [uuid(FD0D6F69-8AFE-4748-A88B-9FB70593DFC8), helpstring('Data computed during SSL handshake.')]
		struct tagHTTP_SSL_INFO {
			unsigned short ServerCertKeySize;
			unsigned short ConnectionKeySize;
			unsigned long ServerCertIssuerSize;
			unsigned long ServerCertSubjectSize;
			LPCSTR pServerCertIssuer;
			LPCSTR pServerCertSubject;
			PHTTP_SSL_CLIENT_CERT_INFO pClientCertInfo;
			unsigned long SslClientCertNegotiated;
		} HTTP_SSL_INFO;
"

	self
		defineField: #ServerCertKeySize type: WORDField new offset: 0;
		defineField: #ConnectionKeySize type: WORDField new offset: 2;
		defineField: #ServerCertIssuerSize type: DWORDField new offset: 4;
		defineField: #ServerCertSubjectSize type: DWORDField new offset: 8;
		defineField: #pServerCertIssuer type: (PointerField type: String) offset: 12;
		defineField: #pServerCertSubject type: (PointerField type: String) offset: 16;
		defineField: #pClientCertInfo type: (PointerField type: HTTP_SSL_CLIENT_CERT_INFO) offset: 20;
		defineField: #SslClientCertNegotiated type: DWORDField new offset: 24.
	self byteSize: 28! !
!HTTP_SSL_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

