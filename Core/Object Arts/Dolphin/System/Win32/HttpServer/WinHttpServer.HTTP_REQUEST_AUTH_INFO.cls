"Filed out from Dolphin Smalltalk 7"!

WinHttpServer.HttpServerStructure subclass: #'WinHttpServer.HTTP_REQUEST_AUTH_INFO'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_AccessToken' -> 16r10.
		'_OffsetOf_AuthStatus' -> 16r0.
		'_OffsetOf_AuthType' -> 16rC.
		'_OffsetOf_ContextAttributes' -> 16r14.
		'_OffsetOf_Flags' -> 16r8.
		'_OffsetOf_MutualAuthDataLength' -> 16r24.
		'_OffsetOf_PackageNameLength' -> 16r2C.
		'_OffsetOf_PackedContext' -> 16r20.
		'_OffsetOf_PackedContextLength' -> 16r18.
		'_OffsetOf_PackedContextType' -> 16r1C.
		'_OffsetOf_pMutualAuthData' -> 16r28.
		'_OffsetOf_pPackageName' -> 16r30.
		'_OffsetOf_SecStatus' -> 16r4
	}!
WinHttpServer.HTTP_REQUEST_AUTH_INFO guid: (Core.GUID fromString: '{e0696c2e-1353-45e2-bdcc-a52b6142b827}')!
WinHttpServer.HTTP_REQUEST_AUTH_INFO comment: '`HTTP_REQUEST_AUTH_INFO` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_REQUEST_AUTH_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"Authentication request info structure"

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(e0696c2e-1353-45e2-bdcc-a52b6142b827), helpstring("Authentication request info structure")]
struct tagHTTP_REQUEST_AUTH_INFO {
	[helpstring("A member of the HTTP_AUTH_STATUS enumeration that indicates the final authentication status of the request.")] HTTP_AUTH_STATUS AuthStatus;
	[helpstring("A SECURITY_STATUS value that indicates the security failure status when the AuthStatus member is HttpAuthStatusFailure.")] long SecStatus;
	[helpstring("Flags from the HTTP_REQUEST_AUTH_FLAG_ enumeration.")] ULONG Flags;
	[helpstring("A member of the HTTP_REQUEST_AUTH_TYPE enumeration that indicates the authentication scheme attempted or established for the request.")] HTTP_REQUEST_AUTH_TYPE AuthType;
	[helpstring("A handle to the client token that the receiving process can use to impersonate the authenticated client. The handle to the token should be closed by calling CloseHandle when it is no longer required.")] HANDLE AccessToken;
	[helpstring("The client context attributes for the access token.")] ULONG ContextAttributes;
	[nonbrowsable, helpstring("The length, in bytes, of the PackedContext.")] ULONG PackedContextLength;
	[helpstring("The type of context in the PackedContext member.")] ULONG PackedContextType;
	[helpstring("The security context for the authentication type."), size_is("PackedContextLength")] PVOID PackedContext;
	[nonbrowsable, helpstring("The length, in bytes, of the pMutualAuthData member.")] ULONG MutualAuthDataLength;
	[helpstring("The Base64 encoded mutual authentication data used in the WWW-Authenticate header."), size_is("MutualAuthDataLength"), string] PCHAR pMutualAuthData;
	[nonbrowsable, helpstring("For SSPI based schemes the package name is returned. Length does not include the terminating null and it is in bytes.")] USHORT PackageNameLength;
	[size_is("PackageNameLength>>1"), string] LPWSTR pPackageName;
} HTTP_REQUEST_AUTH_INFO;
```
'!
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesForClass!WinHttpServer-Structs! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO methodsFor!

AccessToken
	"Answer the <Handle> value of the receiver's 'AccessToken' field."

	^(bytes uintPtrAtOffset: _OffsetOf_AccessToken) asExternalHandle!

AccessToken: aHandle
	"Set the receiver's 'AccessToken' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_AccessToken put: aHandle!

AuthStatus
	"Answer the <Integer> value of the receiver's 'AuthStatus' field."

	^bytes sdwordAtOffset: _OffsetOf_AuthStatus!

AuthStatus: anInteger
	"Set the receiver's 'AuthStatus' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_AuthStatus put: anInteger!

AuthType
	"Answer the <Integer> value of the receiver's 'AuthType' field."

	^bytes sdwordAtOffset: _OffsetOf_AuthType!

AuthType: anInteger
	"Set the receiver's 'AuthType' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_AuthType put: anInteger!

ContextAttributes
	"Answer the <Integer> value of the receiver's 'ContextAttributes' field."

	^bytes dwordAtOffset: _OffsetOf_ContextAttributes!

ContextAttributes: anInteger
	"Set the receiver's 'ContextAttributes' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ContextAttributes put: anInteger!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes dwordAtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Flags put: anInteger!

MutualAuthDataLength
	"Private - Answer the <Integer> value of the receiver's 'MutualAuthDataLength' field."

	^bytes dwordAtOffset: _OffsetOf_MutualAuthDataLength!

MutualAuthDataLength: anInteger
	"Set the receiver's 'MutualAuthDataLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_MutualAuthDataLength put: anInteger!

PackageNameLength
	"Private - Answer the <Integer> value of the receiver's 'PackageNameLength' field."

	^bytes wordAtOffset: _OffsetOf_PackageNameLength!

PackageNameLength: anInteger
	"Set the receiver's 'PackageNameLength' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_PackageNameLength put: anInteger!

PackedContext
	"Answer the <ExternalArray> value of the receiver's 'PackedContext' field."

	^ExternalArray fromAddress: (bytes intPtrAtOffset: _OffsetOf_PackedContext)
		length: self PackedContextLength!

PackedContext: anExternalArray
	"Set the receiver's 'PackedContext' field to the value of the argument, anExternalArray"

	bytes uintPtrAtOffset: _OffsetOf_PackedContext put: anExternalArray yourAddress.
	self PackedContextLength: anExternalArray size!

PackedContextLength
	"Private - Answer the <Integer> value of the receiver's 'PackedContextLength' field."

	^bytes dwordAtOffset: _OffsetOf_PackedContextLength!

PackedContextLength: anInteger
	"Set the receiver's 'PackedContextLength' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_PackedContextLength put: anInteger!

PackedContextType
	"Answer the <Integer> value of the receiver's 'PackedContextType' field."

	^bytes dwordAtOffset: _OffsetOf_PackedContextType!

PackedContextType: anInteger
	"Set the receiver's 'PackedContextType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_PackedContextType put: anInteger!

pMutualAuthData
	"Answer the <String> value of the receiver's 'pMutualAuthData' field."

	^String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pMutualAuthData)
		length: self MutualAuthDataLength!

pMutualAuthData: aString
	"Set the receiver's 'pMutualAuthData' field to the value of the argument, aString"

	bytes uintPtrAtOffset: _OffsetOf_pMutualAuthData put: aString yourAddress.
	self MutualAuthDataLength: aString size!

pPackageName
	"Answer the <Utf16String> value of the receiver's 'pPackageName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pPackageName)
		length: self PackageNameLength >> 1!

pPackageName: anUtf16String
	"Set the receiver's 'pPackageName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pPackageName put: anUtf16String yourAddress.
	self PackageNameLength: anUtf16String size << 1!

SecStatus
	"Answer the <Integer> value of the receiver's 'SecStatus' field."

	^bytes sdwordAtOffset: _OffsetOf_SecStatus!

SecStatus: anInteger
	"Set the receiver's 'SecStatus' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_SecStatus put: anInteger! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #AccessToken!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #AccessToken:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #AuthStatus!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #AuthStatus:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #AuthType!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #AuthType:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #ContextAttributes!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #ContextAttributes:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #Flags!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #Flags:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #MutualAuthDataLength!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #MutualAuthDataLength:!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #PackageNameLength!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #PackageNameLength:!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContext!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContext:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContextLength!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContextLength:!**compiled accessors**!private! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContextType!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #PackedContextType:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #pMutualAuthData!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #pMutualAuthData:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #pPackageName!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #pPackageName:!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #SecStatus!**compiled accessors**!public! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO categoriesFor: #SecStatus:!**compiled accessors**!public! !

!WinHttpServer.HTTP_REQUEST_AUTH_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_REQUEST_AUTH_INFO structure.

	HTTP_REQUEST_AUTH_INFO compileDefinition

		typedef [uuid(e0696c2e-1353-45e2-bdcc-a52b6142b827), helpstring('Authentication request info structure')]
		struct tagHTTP_REQUEST_AUTH_INFO {
			[helpstring('A member of the HTTP_AUTH_STATUS enumeration that indicates the final authentication status of the request.')] HTTP_AUTH_STATUS AuthStatus;
			[helpstring('A SECURITY_STATUS value that indicates the security failure status when the AuthStatus member is HttpAuthStatusFailure.')] long SecStatus;
			[helpstring('Flags from the HTTP_REQUEST_AUTH_FLAG_ enumeration.')] ULONG Flags;
			[helpstring('A member of the HTTP_REQUEST_AUTH_TYPE enumeration that indicates the authentication scheme attempted or established for the request.')] HTTP_REQUEST_AUTH_TYPE AuthType;
			[helpstring('A handle to the client token that the receiving process can use to impersonate the authenticated client. The handle to the token should be closed by calling CloseHandle when it is no longer required.')] HANDLE AccessToken;
			[helpstring('The client context attributes for the access token.')] ULONG ContextAttributes;
			[nonbrowsable, helpstring('The length, in bytes, of the PackedContext.')] ULONG PackedContextLength;
			[helpstring('The type of context in the PackedContext member.')] ULONG PackedContextType;
			[helpstring('The security context for the authentication type.'), size_is('PackedContextLength')] PVOID PackedContext;
			[nonbrowsable, helpstring('The length, in bytes, of the pMutualAuthData member.')] ULONG MutualAuthDataLength;
			[helpstring('The Base64 encoded mutual authentication data used in the WWW-Authenticate header.'), size_is('MutualAuthDataLength'), string] PCHAR pMutualAuthData;
			[nonbrowsable, helpstring('For SSPI based schemes the package name is returned. Length does not include the terminating null and it is in bytes.')] USHORT PackageNameLength;
			[size_is('PackageNameLength>>1'), string] LPWSTR pPackageName;
		} HTTP_REQUEST_AUTH_INFO;
"

	self
		defineField: #AuthStatus type: SDWORDField new offset: 0;
		defineField: #SecStatus type: SDWORDField new offset: 4;
		defineField: #Flags type: DWORDField new offset: 8;
		defineField: #AuthType type: SDWORDField new offset: 12;
		defineField: #AccessToken type: HANDLEField new offset: 16;
		defineField: #ContextAttributes type: DWORDField new offset: 20;
		defineField: #PackedContextLength type: DWORDField new beNonBrowsable offset: 24;
		defineField: #PackedContextType type: DWORDField new offset: 28;
		defineField: #PackedContext type: (ArrayPointerField type: ExternalArray lengthField: #PackedContextLength) offset: 32;
		defineField: #MutualAuthDataLength type: DWORDField new beNonBrowsable offset: 36;
		defineField: #pMutualAuthData type: (ArrayPointerField type: String lengthField: #MutualAuthDataLength) offset: 40;
		defineField: #PackageNameLength type: WORDField new beNonBrowsable offset: 44;
		defineField: #pPackageName type: (ArrayPointerField type: Utf16String arrayLength: (SizeIsArrayFieldLength sizeIs: 'PackageNameLength >> 1')) offset: 48.
	self byteSize: 52!

getFieldNames
	^#(#AuthStatus #SecStatus #Flags #AuthType #AccessToken #ContextAttributes #PackedContextLength #PackedContextType #PackedContext #MutualAuthDataLength #pMutualAuthData #PackageNameLength #pPackageName)! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO class categoriesFor: #defineFields!**auto generated**!private!template definition! !
!WinHttpServer.HTTP_REQUEST_AUTH_INFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

