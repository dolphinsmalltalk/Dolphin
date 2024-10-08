﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SERVICE_CONFIG_SSL_PARAM_Size' -> 16r34.
			'_OffsetOf_AppId' -> 16r8.
			'_OffsetOf_DefaultCertCheckMode' -> 16r1C.
			'_OffsetOf_DefaultFlags' -> 16r30.
			'_OffsetOf_DefaultRevocationFreshnessTime' -> 16r20.
			'_OffsetOf_DefaultRevocationUrlRetrievalTimeout' -> 16r24.
			'_OffsetOf_pDefaultSslCtlIdentifier' -> 16r28.
			'_OffsetOf_pDefaultSslCtlStoreName' -> 16r2C.
			'_OffsetOf_pSslCertStoreName' -> 16r18.
			'_OffsetOf_pSslHash' -> 16r4.
			'_OffsetOf_SslHashLength' -> 16r0
		}!

WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM guid: (Core.GUID fromString: '{7fe46aef-bb33-40ac-a388-846c53efde1d}')!

WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM comment: '`HTTP_SERVICE_CONFIG_SSL_PARAM` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This defines a record for the SSL config store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(7fe46aef-bb33-40ac-a388-846c53efde1d), helpstring("This defines a record for the SSL config store.")]
struct tagHTTP_SERVICE_CONFIG_SSL_PARAM {
	[nonbrowsable, helpstring("The size, in bytes, of the SSL hash.")] ULONG SslHashLength;
	[helpstring("A pointer to the SSL certificate hash."), size_is("SslHashLength")] PVOID pSslHash;
	[helpstring("A unique identifier of the application setting this record.")] GUID AppId;
	[helpstring("A pointer to a wide-character string that contains the name of the store from which the server certificate is to be read. If set to NULL, "MY" is assumed as the default name.")] LPWSTR pSslCertStoreName;
	[helpstring("Flags determining how client certificates are checked.")] DWORD DefaultCertCheckMode;
	[helpstring("DefaultRevocationFreshnessTime (seconds) - How often to check for an updated Certificate revocation list (CRL). If this value is 0 then the new CRL is updated only if the previous one expires")] DWORD DefaultRevocationFreshnessTime;
	[helpstring("DefaultRevocationUrlRetrievalTimeout (milliseconds) - Timeout on attempt to retrieve certificate revocation list from the remote URL.")] DWORD DefaultRevocationUrlRetrievalTimeout;
	[helpstring("pDefaultSslCtlIdentifier - Restrict the certificate issuers that you want to trust. Can be a subset of the certificate issuers that are trusted by the machine.")] LPWSTR pDefaultSslCtlIdentifier;
	[helpstring("Store name under LOCAL_MACHINE where Ctl identified by pDefaultSslCtlIdentifier is stored.")] LPWSTR pDefaultSslCtlStoreName;
	[helpstring("Default Flags - see HTTP_SERVICE_CONFIG_SSL_FLAG* below.")] DWORD DefaultFlags;
} HTTP_SERVICE_CONFIG_SSL_PARAM;
```
'!

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM methodsFor!

AppId
	"Answer the <GUID> value of the receiver's 'AppId' field."

	^GUID fromAddress: bytes yourAddress + _OffsetOf_AppId!

AppId: aGUID
	"Set the receiver's 'AppId' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_AppId + 1)
		to: ##(_OffsetOf_AppId + GUID._GUID_Size)
		startingAt: 1!

DefaultCertCheckMode
	"Answer the <Integer> value of the receiver's 'DefaultCertCheckMode' field."

	^bytes uint32AtOffset: _OffsetOf_DefaultCertCheckMode!

DefaultCertCheckMode: anInteger
	"Set the receiver's 'DefaultCertCheckMode' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_DefaultCertCheckMode put: anInteger!

DefaultFlags
	"Answer the <Integer> value of the receiver's 'DefaultFlags' field."

	^bytes uint32AtOffset: _OffsetOf_DefaultFlags!

DefaultFlags: anInteger
	"Set the receiver's 'DefaultFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_DefaultFlags put: anInteger!

DefaultRevocationFreshnessTime
	"Answer the <Integer> value of the receiver's 'DefaultRevocationFreshnessTime' field."

	^bytes uint32AtOffset: _OffsetOf_DefaultRevocationFreshnessTime!

DefaultRevocationFreshnessTime: anInteger
	"Set the receiver's 'DefaultRevocationFreshnessTime' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_DefaultRevocationFreshnessTime put: anInteger!

DefaultRevocationUrlRetrievalTimeout
	"Answer the <Integer> value of the receiver's 'DefaultRevocationUrlRetrievalTimeout' field."

	^bytes uint32AtOffset: _OffsetOf_DefaultRevocationUrlRetrievalTimeout!

DefaultRevocationUrlRetrievalTimeout: anInteger
	"Set the receiver's 'DefaultRevocationUrlRetrievalTimeout' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_DefaultRevocationUrlRetrievalTimeout put: anInteger!

pDefaultSslCtlIdentifier
	"Answer the <Utf16String> value of the receiver's 'pDefaultSslCtlIdentifier' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pDefaultSslCtlIdentifier)!

pDefaultSslCtlIdentifier: anUtf16String
	"Set the receiver's 'pDefaultSslCtlIdentifier' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pDefaultSslCtlIdentifier put: anUtf16String yourAddress!

pDefaultSslCtlStoreName
	"Answer the <Utf16String> value of the receiver's 'pDefaultSslCtlStoreName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pDefaultSslCtlStoreName)!

pDefaultSslCtlStoreName: anUtf16String
	"Set the receiver's 'pDefaultSslCtlStoreName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pDefaultSslCtlStoreName put: anUtf16String yourAddress!

pSslCertStoreName
	"Answer the <Utf16String> value of the receiver's 'pSslCertStoreName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pSslCertStoreName)!

pSslCertStoreName: anUtf16String
	"Set the receiver's 'pSslCertStoreName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pSslCertStoreName put: anUtf16String yourAddress!

pSslHash
	"Answer the <ExternalArray> value of the receiver's 'pSslHash' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_pSslHash) length: self SslHashLength!

pSslHash: anExternalArray
	"Set the receiver's 'pSslHash' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: _OffsetOf_pSslHash put: anExternalArray yourAddress.
	self SslHashLength: anExternalArray size!

SslHashLength
	"Private - Answer the <Integer> value of the receiver's 'SslHashLength' field."

	^bytes uint32AtOffset: _OffsetOf_SslHashLength!

SslHashLength: anInteger
	"Set the receiver's 'SslHashLength' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_SslHashLength put: anInteger! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM categoriesForMethods!
AppId!**compiled accessors**!public! !
AppId:!**compiled accessors**!public! !
DefaultCertCheckMode!**compiled accessors**!public! !
DefaultCertCheckMode:!**compiled accessors**!public! !
DefaultFlags!**compiled accessors**!public! !
DefaultFlags:!**compiled accessors**!public! !
DefaultRevocationFreshnessTime!**compiled accessors**!public! !
DefaultRevocationFreshnessTime:!**compiled accessors**!public! !
DefaultRevocationUrlRetrievalTimeout!**compiled accessors**!public! !
DefaultRevocationUrlRetrievalTimeout:!**compiled accessors**!public! !
pDefaultSslCtlIdentifier!**compiled accessors**!public! !
pDefaultSslCtlIdentifier:!**compiled accessors**!public! !
pDefaultSslCtlStoreName!**compiled accessors**!public! !
pDefaultSslCtlStoreName:!**compiled accessors**!public! !
pSslCertStoreName!**compiled accessors**!public! !
pSslCertStoreName:!**compiled accessors**!public! !
pSslHash!**compiled accessors**!public! !
pSslHash:!**compiled accessors**!public! !
SslHashLength!**compiled accessors**!private! !
SslHashLength:!**compiled accessors**!private! !
!

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM class methodsFor!

byteSize
	^_HTTP_SERVICE_CONFIG_SSL_PARAM_Size!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_PARAM structure.

	HTTP_SERVICE_CONFIG_SSL_PARAM compileDefinition

		typedef [uuid(7fe46aef-bb33-40ac-a388-846c53efde1d), helpstring('This defines a record for the SSL config store.')]
		struct tagHTTP_SERVICE_CONFIG_SSL_PARAM {
			[nonbrowsable, helpstring('The size, in bytes, of the SSL hash.')] ULONG SslHashLength;
			[helpstring('A pointer to the SSL certificate hash.'), size_is('SslHashLength')] PVOID pSslHash;
			[helpstring('A unique identifier of the application setting this record.')] GUID AppId;
			[helpstring('A pointer to a wide-character string that contains the name of the store from which the server certificate is to be read. If set to NULL, 'MY' is assumed as the default name.')] LPWSTR pSslCertStoreName;
			[helpstring('Flags determining how client certificates are checked.')] DWORD DefaultCertCheckMode;
			[helpstring('DefaultRevocationFreshnessTime (seconds) - How often to check for an updated Certificate revocation list (CRL). If this value is 0 then the new CRL is updated only if the previous one expires')] DWORD DefaultRevocationFreshnessTime;
			[helpstring('DefaultRevocationUrlRetrievalTimeout (milliseconds) - Timeout on attempt to retrieve certificate revocation list from the remote URL.')] DWORD DefaultRevocationUrlRetrievalTimeout;
			[helpstring('pDefaultSslCtlIdentifier - Restrict the certificate issuers that you want to trust. Can be a subset of the certificate issuers that are trusted by the machine.')] LPWSTR pDefaultSslCtlIdentifier;
			[helpstring('Store name under LOCAL_MACHINE where Ctl identified by pDefaultSslCtlIdentifier is stored.')] LPWSTR pDefaultSslCtlStoreName;
			[helpstring('Default Flags - see HTTP_SERVICE_CONFIG_SSL_FLAG* below.')] DWORD DefaultFlags;
		} HTTP_SERVICE_CONFIG_SSL_PARAM;
"

	self
		defineField: #SslHashLength type: UInt32Field new beNonBrowsable offset: 0;
		defineField: #pSslHash type: (ArrayPointerField type: ExternalArray lengthField: #SslHashLength) offset: 4;
		defineField: #AppId type: (StructureField type: GUID) offset: 8;
		defineField: #pSslCertStoreName type: (PointerField type: Utf16String) offset: 24;
		defineField: #DefaultCertCheckMode type: UInt32Field new offset: 28;
		defineField: #DefaultRevocationFreshnessTime type: UInt32Field new offset: 32;
		defineField: #DefaultRevocationUrlRetrievalTimeout type: UInt32Field new offset: 36;
		defineField: #pDefaultSslCtlIdentifier type: (PointerField type: Utf16String) offset: 40;
		defineField: #pDefaultSslCtlStoreName type: (PointerField type: Utf16String) offset: 44;
		defineField: #DefaultFlags type: UInt32Field new offset: 48.
	self byteSize: 52!

getFieldNames
	^#(#SslHashLength #pSslHash #AppId #pSslCertStoreName #DefaultCertCheckMode #DefaultRevocationFreshnessTime #DefaultRevocationUrlRetrievalTimeout #pDefaultSslCtlIdentifier #pDefaultSslCtlStoreName #DefaultFlags)! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_PARAM class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

