"Filed out from Dolphin Smalltalk"!

HttpServerStructure subclass: #HTTP_SSL_INFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_ConnectionKeySize _OffsetOf_pClientCertInfo _OffsetOf_pServerCertIssuer _OffsetOf_pServerCertSubject _OffsetOf_ServerCertIssuerSize _OffsetOf_ServerCertKeySize _OffsetOf_ServerCertSubjectSize _OffsetOf_SslClientCertNegotiated'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

HTTP_SSL_INFO guid: (GUID fromString: '{fd0d6f69-8afe-4748-a88b-9fb70593dfc8}')!

HTTP_SSL_INFO addClassConstant: '_OffsetOf_ConnectionKeySize' value: 16r2!
HTTP_SSL_INFO addClassConstant: '_OffsetOf_pClientCertInfo' value: 16r14!
HTTP_SSL_INFO addClassConstant: '_OffsetOf_pServerCertIssuer' value: 16rC!
HTTP_SSL_INFO addClassConstant: '_OffsetOf_pServerCertSubject' value: 16r10!
HTTP_SSL_INFO addClassConstant: '_OffsetOf_ServerCertIssuerSize' value: 16r4!
HTTP_SSL_INFO addClassConstant: '_OffsetOf_ServerCertKeySize' value: 16r0!
HTTP_SSL_INFO addClassConstant: '_OffsetOf_ServerCertSubjectSize' value: 16r8!
HTTP_SSL_INFO addClassConstant: '_OffsetOf_SslClientCertNegotiated' value: 16r18!

HTTP_SSL_INFO comment: '<HTTP_SSL_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SSL_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Data computed during SSL handshake."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

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
'!

!HTTP_SSL_INFO categoriesForClass!WinHttpServer-Structs! !

!HTTP_SSL_INFO methodsFor!

ConnectionKeySize
	"Answer the <Integer> value of the receiver's 'ConnectionKeySize' field."

	^bytes wordAtOffset: _OffsetOf_ConnectionKeySize!

ConnectionKeySize: anInteger
	"Set the receiver's 'ConnectionKeySize' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ConnectionKeySize put: anInteger!

pClientCertInfo
	"Answer the <HTTP_SSL_CLIENT_CERT_INFO> value of the receiver's 'pClientCertInfo' field."

	^HTTP_SSL_CLIENT_CERT_INFO fromAddress: (bytes intPtrAtOffset: _OffsetOf_pClientCertInfo)!

pClientCertInfo: aHTTP_SSL_CLIENT_CERT_INFO
	"Set the receiver's 'pClientCertInfo' field to the value of the argument, aHTTP_SSL_CLIENT_CERT_INFO"

	bytes uintPtrAtOffset: _OffsetOf_pClientCertInfo put: aHTTP_SSL_CLIENT_CERT_INFO yourAddress!

pServerCertIssuer
	"Answer the <String> value of the receiver's 'pServerCertIssuer' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pServerCertIssuer)
		length: self ServerCertIssuerSize!

pServerCertIssuer: aString
	"Set the receiver's 'pServerCertIssuer' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_pServerCertIssuer put: aString yourAddress.
	self ServerCertIssuerSize: aString size!

pServerCertSubject
	"Answer the <String> value of the receiver's 'pServerCertSubject' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pServerCertSubject)
		length: self ServerCertSubjectSize!

pServerCertSubject: aString
	"Set the receiver's 'pServerCertSubject' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_pServerCertSubject put: aString yourAddress.
	self ServerCertSubjectSize: aString size!

ServerCertIssuerSize
	"Private - Answer the <Integer> value of the receiver's 'ServerCertIssuerSize' field."

	^bytes dwordAtOffset: _OffsetOf_ServerCertIssuerSize!

ServerCertIssuerSize: anInteger
	"Set the receiver's 'ServerCertIssuerSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ServerCertIssuerSize put: anInteger!

ServerCertKeySize
	"Answer the <Integer> value of the receiver's 'ServerCertKeySize' field."

	^bytes wordAtOffset: _OffsetOf_ServerCertKeySize!

ServerCertKeySize: anInteger
	"Set the receiver's 'ServerCertKeySize' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_ServerCertKeySize put: anInteger!

ServerCertSubjectSize
	"Private - Answer the <Integer> value of the receiver's 'ServerCertSubjectSize' field."

	^bytes dwordAtOffset: _OffsetOf_ServerCertSubjectSize!

ServerCertSubjectSize: anInteger
	"Set the receiver's 'ServerCertSubjectSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ServerCertSubjectSize put: anInteger!

SslClientCertNegotiated
	"Answer the <Integer> value of the receiver's 'SslClientCertNegotiated' field."

	^bytes dwordAtOffset: _OffsetOf_SslClientCertNegotiated!

SslClientCertNegotiated: anInteger
	"Set the receiver's 'SslClientCertNegotiated' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_SslClientCertNegotiated put: anInteger! !

!HTTP_SSL_INFO categoriesForMethods!
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

!HTTP_SSL_INFO class methodsFor!

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
		defineField: #ServerCertKeySize type: WORDField new offset: 0;
		defineField: #ConnectionKeySize type: WORDField new offset: 2;
		defineField: #ServerCertIssuerSize type: DWORDField new beNonBrowsable offset: 4;
		defineField: #ServerCertSubjectSize type: DWORDField new beNonBrowsable offset: 8;
		defineField: #pServerCertIssuer type: (ArrayPointerField type: String lengthField: #ServerCertIssuerSize) offset: 12;
		defineField: #pServerCertSubject type: (ArrayPointerField type: String lengthField: #ServerCertSubjectSize) offset: 16;
		defineField: #pClientCertInfo type: (PointerField type: HTTP_SSL_CLIENT_CERT_INFO) offset: 20;
		defineField: #SslClientCertNegotiated type: DWORDField new offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#ServerCertKeySize #ConnectionKeySize #ServerCertIssuerSize #ServerCertSubjectSize #pServerCertIssuer #pServerCertSubject #pClientCertInfo #SslClientCertNegotiated)! !

!HTTP_SSL_INFO class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

