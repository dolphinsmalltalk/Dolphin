﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SSL_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SSL_INFO_Size' -> 16r1C.
			'_OffsetOf_ConnectionKeySize' -> 16r2.
			'_OffsetOf_pClientCertInfo' -> 16r14.
			'_OffsetOf_pServerCertIssuer' -> 16rC.
			'_OffsetOf_pServerCertSubject' -> 16r10.
			'_OffsetOf_ServerCertIssuerSize' -> 16r4.
			'_OffsetOf_ServerCertKeySize' -> 16r0.
			'_OffsetOf_ServerCertSubjectSize' -> 16r8.
			'_OffsetOf_SslClientCertNegotiated' -> 16r18
		}!

WinHttpServer.HTTP_SSL_INFO guid: (Core.GUID fromString: '{fd0d6f69-8afe-4748-a88b-9fb70593dfc8}')!

WinHttpServer.HTTP_SSL_INFO comment: '`HTTP_SSL_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SSL_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Data computed during SSL handshake."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(fd0d6f69-8afe-4748-a88b-9fb70593dfc8), helpstring("Data computed during SSL handshake.")]
struct tagHTTP_SSL_INFO {
	[helpstring("The size, in bytes, of the public key used to sign the server certificate.")] USHORT ServerCertKeySize;
	[helpstring("The size, in bytes, of the cipher key used to encrypt the current session.")] USHORT ConnectionKeySize;
	[nonbrowsable, helpstring("The size, in bytes, of the string pointed to by the pServerCertIssuer member not including the terminating null character.")] ULONG ServerCertIssuerSize;
	[nonbrowsable, helpstring("The size, in bytes, of the string pointed to by the pServerCertSubject member not including the terminating null character.")] ULONG ServerCertSubjectSize;
	[helpstring("A pointer to a null-terminated string of octets that specifies the name of the entity that issued the certificate."), size_is("ServerCertIssuerSize")] LPCSTR pServerCertIssuer;
	[helpstring("A pointer to a null-terminated string of octets that specifies the name of the entity to which the certificate belongs."), size_is("ServerCertSubjectSize")] LPCSTR pServerCertSubject;
	[helpstring("A pointer to an HTTP_SSL_CLIENT_CERT_INFO structure that specifies the client certificate.")] PHTTP_SSL_CLIENT_CERT_INFO pClientCertInfo;
	[helpstring("If non-zero, indicates that the client certificate is already present locally.")] ULONG SslClientCertNegotiated;
} HTTP_SSL_INFO;
```
'!

!WinHttpServer.HTTP_SSL_INFO categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_SSL_INFO methodsFor!

ConnectionKeySize
	"Answer the <Integer> value of the receiver's 'ConnectionKeySize' field."

	^bytes uint16AtOffset: _OffsetOf_ConnectionKeySize!

ConnectionKeySize: anInteger
	"Set the receiver's 'ConnectionKeySize' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_ConnectionKeySize put: anInteger!

pClientCertInfo
	"Answer the <HTTP_SSL_CLIENT_CERT_INFO> value of the receiver's 'pClientCertInfo' field."

	^HTTP_SSL_CLIENT_CERT_INFO fromAddress: (bytes intPtrAtOffset: _OffsetOf_pClientCertInfo)!

pClientCertInfo: aHTTP_SSL_CLIENT_CERT_INFO
	"Set the receiver's 'pClientCertInfo' field to the value of the argument, aHTTP_SSL_CLIENT_CERT_INFO"

	bytes uintPtrAtOffset: _OffsetOf_pClientCertInfo put: aHTTP_SSL_CLIENT_CERT_INFO yourAddress!

pServerCertIssuer
	"Answer the <AnsiString> value of the receiver's 'pServerCertIssuer' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_pServerCertIssuer)
		length: self ServerCertIssuerSize!

pServerCertIssuer: anAnsiString
	"Set the receiver's 'pServerCertIssuer' field to the value of the argument, anAnsiString"

	bytes uintPtrAtOffset: _OffsetOf_pServerCertIssuer put: anAnsiString yourAddress.
	self ServerCertIssuerSize: anAnsiString size!

pServerCertSubject
	"Answer the <AnsiString> value of the receiver's 'pServerCertSubject' field."

	^AnsiString fromAddress: (bytes intPtrAtOffset: _OffsetOf_pServerCertSubject)
		length: self ServerCertSubjectSize!

pServerCertSubject: anAnsiString
	"Set the receiver's 'pServerCertSubject' field to the value of the argument, anAnsiString"

	bytes uintPtrAtOffset: _OffsetOf_pServerCertSubject put: anAnsiString yourAddress.
	self ServerCertSubjectSize: anAnsiString size!

ServerCertIssuerSize
	"Private - Answer the <Integer> value of the receiver's 'ServerCertIssuerSize' field."

	^bytes uint32AtOffset: _OffsetOf_ServerCertIssuerSize!

ServerCertIssuerSize: anInteger
	"Set the receiver's 'ServerCertIssuerSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ServerCertIssuerSize put: anInteger!

ServerCertKeySize
	"Answer the <Integer> value of the receiver's 'ServerCertKeySize' field."

	^bytes uint16AtOffset: _OffsetOf_ServerCertKeySize!

ServerCertKeySize: anInteger
	"Set the receiver's 'ServerCertKeySize' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_ServerCertKeySize put: anInteger!

ServerCertSubjectSize
	"Private - Answer the <Integer> value of the receiver's 'ServerCertSubjectSize' field."

	^bytes uint32AtOffset: _OffsetOf_ServerCertSubjectSize!

ServerCertSubjectSize: anInteger
	"Set the receiver's 'ServerCertSubjectSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ServerCertSubjectSize put: anInteger!

SslClientCertNegotiated
	"Answer the <Integer> value of the receiver's 'SslClientCertNegotiated' field."

	^bytes uint32AtOffset: _OffsetOf_SslClientCertNegotiated!

SslClientCertNegotiated: anInteger
	"Set the receiver's 'SslClientCertNegotiated' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_SslClientCertNegotiated put: anInteger! !

!WinHttpServer.HTTP_SSL_INFO categoriesForMethods!
ConnectionKeySize!**compiled accessors**!public! !
ConnectionKeySize:!**compiled accessors**!public! !
pClientCertInfo!**compiled accessors**!public! !
pClientCertInfo:!**compiled accessors**!public! !
pServerCertIssuer!**compiled accessors**!public! !
pServerCertIssuer:!**compiled accessors**!public! !
pServerCertSubject!**compiled accessors**!public! !
pServerCertSubject:!**compiled accessors**!public! !
ServerCertIssuerSize!**compiled accessors**!private! !
ServerCertIssuerSize:!**compiled accessors**!private! !
ServerCertKeySize!**compiled accessors**!public! !
ServerCertKeySize:!**compiled accessors**!public! !
ServerCertSubjectSize!**compiled accessors**!private! !
ServerCertSubjectSize:!**compiled accessors**!private! !
SslClientCertNegotiated!**compiled accessors**!public! !
SslClientCertNegotiated:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SSL_INFO class methodsFor!

byteSize
	^_HTTP_SSL_INFO_Size!

defineFields
	"Define the fields of the HTTP_SSL_INFO structure.

	HTTP_SSL_INFO compileDefinition

		typedef [uuid(fd0d6f69-8afe-4748-a88b-9fb70593dfc8), helpstring('Data computed during SSL handshake.')]
		struct tagHTTP_SSL_INFO {
			[helpstring('The size, in bytes, of the public key used to sign the server certificate.')] USHORT ServerCertKeySize;
			[helpstring('The size, in bytes, of the cipher key used to encrypt the current session.')] USHORT ConnectionKeySize;
			[nonbrowsable, helpstring('The size, in bytes, of the string pointed to by the pServerCertIssuer member not including the terminating null character.')] ULONG ServerCertIssuerSize;
			[nonbrowsable, helpstring('The size, in bytes, of the string pointed to by the pServerCertSubject member not including the terminating null character.')] ULONG ServerCertSubjectSize;
			[helpstring('A pointer to a null-terminated string of octets that specifies the name of the entity that issued the certificate.'), size_is('ServerCertIssuerSize')] LPCSTR pServerCertIssuer;
			[helpstring('A pointer to a null-terminated string of octets that specifies the name of the entity to which the certificate belongs.'), size_is('ServerCertSubjectSize')] LPCSTR pServerCertSubject;
			[helpstring('A pointer to an HTTP_SSL_CLIENT_CERT_INFO structure that specifies the client certificate.')] PHTTP_SSL_CLIENT_CERT_INFO pClientCertInfo;
			[helpstring('If non-zero, indicates that the client certificate is already present locally.')] ULONG SslClientCertNegotiated;
		} HTTP_SSL_INFO;
"

	self
		defineField: #ServerCertKeySize type: UInt16Field new offset: 0;
		defineField: #ConnectionKeySize type: UInt16Field new offset: 2;
		defineField: #ServerCertIssuerSize type: UInt32Field new beNonBrowsable offset: 4;
		defineField: #ServerCertSubjectSize type: UInt32Field new beNonBrowsable offset: 8;
		defineField: #pServerCertIssuer type: (ArrayPointerField type: AnsiString lengthField: #ServerCertIssuerSize) offset: 12;
		defineField: #pServerCertSubject type: (ArrayPointerField type: AnsiString lengthField: #ServerCertSubjectSize) offset: 16;
		defineField: #pClientCertInfo type: (PointerField type: HTTP_SSL_CLIENT_CERT_INFO) offset: 20;
		defineField: #SslClientCertNegotiated type: UInt32Field new offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#ServerCertKeySize #ConnectionKeySize #ServerCertIssuerSize #ServerCertSubjectSize #pServerCertIssuer #pServerCertSubject #pClientCertInfo #SslClientCertNegotiated)! !

!WinHttpServer.HTTP_SSL_INFO class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

