"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_PARAM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_PARAM guid: (GUID fromString: '{7FE46AEF-BB33-40AC-A388-846C53EFDE1D}')!
HTTP_SERVICE_CONFIG_SSL_PARAM comment: '<HTTP_SERVICE_CONFIG_SSL_PARAM> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_PARAM'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This defines a record for the SSL config store."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7FE46AEF-BB33-40AC-A388-846C53EFDE1D), helpstring("This defines a record for the SSL config store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_PARAM {
	unsigned long SslHashLength;
	void* pSslHash;
	GUID AppId;
	LPWSTR pSslCertStoreName;
	unsigned long DefaultCertCheckMode;
	[helpstring("DefaultRevocationFreshnessTime (seconds) - How often to check for an updated Certificate revocation list (CRL). If this value is 0 then the new CRL is updated only if the previous one expires")] unsigned long DefaultRevocationFreshnessTime;
	[helpstring("DefaultRevocationUrlRetrievalTimeout (milliseconds) - Timeout on attempt to retrieve certificate revocation list from the remote URL.")] unsigned long DefaultRevocationUrlRetrievalTimeout;
	[helpstring("pDefaultSslCtlIdentifier - Restrict the certificate issuers that you want to trust. Can be a subset of the certificate issuers that are trusted by the machine.")] LPWSTR pDefaultSslCtlIdentifier;
	[helpstring("Store name under LOCAL_MACHINE where Ctl identified by pDefaultSslCtlIdentifier is stored.")] LPWSTR pDefaultSslCtlStoreName;
	[helpstring("Default Flags - see HTTP_SERVICE_CONFIG_SSL_FLAG* below.")] unsigned long DefaultFlags;
} HTTP_SERVICE_CONFIG_SSL_PARAM;
'!
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_PARAM methodsFor!

AppId
	"Answer the receiver's AppId field as a Smalltalk object."

	^GUID fromAddress: bytes yourAddress + ##(self offsetOf: #AppId)!

AppId: anObject
	"Set the receiver's AppId field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #AppId) + 1)
		to: ##((self offsetOf: #AppId) + GUID basicByteSize)
		startingAt: 1!

DefaultCertCheckMode
	"Answer the receiver's DefaultCertCheckMode field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #DefaultCertCheckMode)!

DefaultCertCheckMode: anObject
	"Set the receiver's DefaultCertCheckMode field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #DefaultCertCheckMode) put: anObject!

DefaultFlags
	"Answer the receiver's DefaultFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #DefaultFlags)!

DefaultFlags: anObject
	"Set the receiver's DefaultFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #DefaultFlags) put: anObject!

DefaultRevocationFreshnessTime
	"Answer the receiver's DefaultRevocationFreshnessTime field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #DefaultRevocationFreshnessTime)!

DefaultRevocationFreshnessTime: anObject
	"Set the receiver's DefaultRevocationFreshnessTime field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #DefaultRevocationFreshnessTime) put: anObject!

DefaultRevocationUrlRetrievalTimeout
	"Answer the receiver's DefaultRevocationUrlRetrievalTimeout field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #DefaultRevocationUrlRetrievalTimeout)!

DefaultRevocationUrlRetrievalTimeout: anObject
	"Set the receiver's DefaultRevocationUrlRetrievalTimeout field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #DefaultRevocationUrlRetrievalTimeout) put: anObject!

pDefaultSslCtlIdentifier
	"Answer the receiver's pDefaultSslCtlIdentifier field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pDefaultSslCtlIdentifier))!

pDefaultSslCtlIdentifier: anObject
	"Set the receiver's pDefaultSslCtlIdentifier field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pDefaultSslCtlIdentifier) put: anObject yourAddress!

pDefaultSslCtlStoreName
	"Answer the receiver's pDefaultSslCtlStoreName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pDefaultSslCtlStoreName))!

pDefaultSslCtlStoreName: anObject
	"Set the receiver's pDefaultSslCtlStoreName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pDefaultSslCtlStoreName) put: anObject yourAddress!

pSslCertStoreName
	"Answer the receiver's pSslCertStoreName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pSslCertStoreName))!

pSslCertStoreName: anObject
	"Set the receiver's pSslCertStoreName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pSslCertStoreName) put: anObject yourAddress!

pSslHash
	"Answer the receiver's pSslHash field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pSslHash)) asExternalAddress!

pSslHash: anObject
	"Set the receiver's pSslHash field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #pSslHash) put: anObject!

SslHashLength
	"Answer the receiver's SslHashLength field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

SslHashLength: anObject
	"Set the receiver's SslHashLength field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #AppId!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #AppId:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #DefaultCertCheckMode!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #DefaultCertCheckMode:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #DefaultFlags!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #DefaultFlags:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #DefaultRevocationFreshnessTime!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #DefaultRevocationFreshnessTime:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #DefaultRevocationUrlRetrievalTimeout!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #DefaultRevocationUrlRetrievalTimeout:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #pDefaultSslCtlIdentifier!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #pDefaultSslCtlIdentifier:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #pDefaultSslCtlStoreName!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #pDefaultSslCtlStoreName:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #pSslCertStoreName!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #pSslCertStoreName:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #pSslHash!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #pSslHash:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #SslHashLength!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_PARAM categoriesFor: #SslHashLength:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_PARAM class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_PARAM structure.

	HTTP_SERVICE_CONFIG_SSL_PARAM  compileDefinition

		typedef [uuid(7FE46AEF-BB33-40AC-A388-846C53EFDE1D), helpstring('This defines a record for the SSL config store.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_PARAM {
			unsigned long SslHashLength;
			void* pSslHash;
			GUID AppId;
			LPWSTR pSslCertStoreName;
			unsigned long DefaultCertCheckMode;
			[helpstring('DefaultRevocationFreshnessTime (seconds) - How often to check for an updated Certificate revocation list (CRL). If this value is 0 then the new CRL is updated only if the previous one expires')] unsigned long DefaultRevocationFreshnessTime;
			[helpstring('DefaultRevocationUrlRetrievalTimeout (milliseconds) - Timeout on attempt to retrieve certificate revocation list from the remote URL.')] unsigned long DefaultRevocationUrlRetrievalTimeout;
			[helpstring('pDefaultSslCtlIdentifier - Restrict the certificate issuers that you want to trust. Can be a subset of the certificate issuers that are trusted by the machine.')] LPWSTR pDefaultSslCtlIdentifier;
			[helpstring('Store name under LOCAL_MACHINE where Ctl identified by pDefaultSslCtlIdentifier is stored.')] LPWSTR pDefaultSslCtlStoreName;
			[helpstring('Default Flags - see HTTP_SERVICE_CONFIG_SSL_FLAG* below.')] unsigned long DefaultFlags;
		} HTTP_SERVICE_CONFIG_SSL_PARAM;
"

	self
		defineField: #SslHashLength type: DWORDField new offset: 0;
		defineField: #pSslHash type: LPVOIDField new offset: 4;
		defineField: #AppId type: (StructureField type: GUID) offset: 8;
		defineField: #pSslCertStoreName type: (PointerField type: UnicodeString) offset: 24;
		defineField: #DefaultCertCheckMode type: DWORDField new offset: 28;
		defineField: #DefaultRevocationFreshnessTime type: DWORDField new offset: 32;
		defineField: #DefaultRevocationUrlRetrievalTimeout type: DWORDField new offset: 36;
		defineField: #pDefaultSslCtlIdentifier type: (PointerField type: UnicodeString) offset: 40;
		defineField: #pDefaultSslCtlStoreName type: (PointerField type: UnicodeString) offset: 44;
		defineField: #DefaultFlags type: DWORDField new offset: 48.
	self byteSize: 52! !
!HTTP_SERVICE_CONFIG_SSL_PARAM class categoriesFor: #defineFields!**auto generated**!initializing!public! !

