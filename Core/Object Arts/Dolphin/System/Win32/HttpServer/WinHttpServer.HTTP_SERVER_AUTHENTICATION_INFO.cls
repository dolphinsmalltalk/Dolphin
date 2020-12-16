"Filed out from Dolphin Smalltalk 7"!

HTTP_PROPERTY_FLAGS subclass: #HTTP_SERVER_AUTHENTICATION_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_AuthSchemes' -> 16r4.
		'_OffsetOf_BasicParams' -> 16r1C.
		'_OffsetOf_DigestParams' -> 16rC.
		'_OffsetOf_DisableNTLMCredentialCaching' -> 16rA.
		'_OffsetOf_ExFlags' -> 16rB.
		'_OffsetOf_ReceiveContextHandle' -> 16r9.
		'_OffsetOf_ReceiveMutualAuth' -> 16r8
	}!
HTTP_SERVER_AUTHENTICATION_INFO guid: (GUID fromString: '{7f4599b6-bdfd-4a19-8a4a-a7fd55a9e207}')!
HTTP_SERVER_AUTHENTICATION_INFO comment: '<HTTP_SERVER_AUTHENTICATION_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVER_AUTHENTICATION_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(7f4599b6-bdfd-4a19-8a4a-a7fd55a9e207)]
struct tagHTTP_SERVER_AUTHENTICATION_INFO {
	HTTP_PROPERTY_FLAGS;
	ULONG AuthSchemes;
	BOOLEAN ReceiveMutualAuth;
	BOOLEAN ReceiveContextHandle;
	BOOLEAN DisableNTLMCredentialCaching;
	UCHAR ExFlags;
	HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS DigestParams;
	HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS BasicParams;
} HTTP_SERVER_AUTHENTICATION_INFO;
'!
!HTTP_SERVER_AUTHENTICATION_INFO categoriesForClass!Win32-Structs! !
!HTTP_SERVER_AUTHENTICATION_INFO methodsFor!

AuthSchemes
	"Answer the <Integer> value of the receiver's 'AuthSchemes' field."

	^bytes dwordAtOffset: _OffsetOf_AuthSchemes!

AuthSchemes: anInteger
	"Set the receiver's 'AuthSchemes' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_AuthSchemes put: anInteger!

BasicParams
	"Answer the <HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS> value of the receiver's 'BasicParams' field."

	^HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS fromAddress: bytes yourAddress + _OffsetOf_BasicParams!

BasicParams: aHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS
	"Set the receiver's 'BasicParams' field to the value of the argument, aHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS"

	aHTTP_SERVER_AUTHENTICATION_BASIC_PARAMS
		replaceBytesOf: bytes
		from: ##(_OffsetOf_BasicParams + 1)
		to: ##(_OffsetOf_BasicParams + HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS basicByteSize)
		startingAt: 1!

DigestParams
	"Answer the <HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS> value of the receiver's 'DigestParams' field."

	^HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS fromAddress: bytes yourAddress + _OffsetOf_DigestParams!

DigestParams: aHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS
	"Set the receiver's 'DigestParams' field to the value of the argument, aHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS"

	aHTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS
		replaceBytesOf: bytes
		from: ##(_OffsetOf_DigestParams + 1)
		to: ##(_OffsetOf_DigestParams + HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS basicByteSize)
		startingAt: 1!

DisableNTLMCredentialCaching
	"Answer the <Boolean> value of the receiver's 'DisableNTLMCredentialCaching' field."

	^(bytes byteAtOffset: _OffsetOf_DisableNTLMCredentialCaching) asBoolean!

DisableNTLMCredentialCaching: aBoolean
	"Set the receiver's 'DisableNTLMCredentialCaching' field to the value of the argument, aBoolean"

	bytes byteAtOffset: _OffsetOf_DisableNTLMCredentialCaching put: aBoolean asParameter!

ExFlags
	"Answer the <Integer> value of the receiver's 'ExFlags' field."

	^bytes byteAtOffset: _OffsetOf_ExFlags!

ExFlags: anInteger
	"Set the receiver's 'ExFlags' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_ExFlags put: anInteger!

ReceiveContextHandle
	"Answer the <Boolean> value of the receiver's 'ReceiveContextHandle' field."

	^(bytes byteAtOffset: _OffsetOf_ReceiveContextHandle) asBoolean!

ReceiveContextHandle: aBoolean
	"Set the receiver's 'ReceiveContextHandle' field to the value of the argument, aBoolean"

	bytes byteAtOffset: _OffsetOf_ReceiveContextHandle put: aBoolean asParameter!

ReceiveMutualAuth
	"Answer the <Boolean> value of the receiver's 'ReceiveMutualAuth' field."

	^(bytes byteAtOffset: _OffsetOf_ReceiveMutualAuth) asBoolean!

ReceiveMutualAuth: aBoolean
	"Set the receiver's 'ReceiveMutualAuth' field to the value of the argument, aBoolean"

	bytes byteAtOffset: _OffsetOf_ReceiveMutualAuth put: aBoolean asParameter! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #AuthSchemes!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #AuthSchemes:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #BasicParams!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #BasicParams:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #DigestParams!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #DigestParams:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #DisableNTLMCredentialCaching!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #DisableNTLMCredentialCaching:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ExFlags!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ExFlags:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ReceiveContextHandle!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ReceiveContextHandle:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ReceiveMutualAuth!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ReceiveMutualAuth:!**compiled accessors**!public! !

!HTTP_SERVER_AUTHENTICATION_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVER_AUTHENTICATION_INFO structure.

	HTTP_SERVER_AUTHENTICATION_INFO compileDefinition

		typedef [uuid(7f4599b6-bdfd-4a19-8a4a-a7fd55a9e207)]
		struct tagHTTP_SERVER_AUTHENTICATION_INFO {
			HTTP_PROPERTY_FLAGS;
			ULONG AuthSchemes;
			BOOLEAN ReceiveMutualAuth;
			BOOLEAN ReceiveContextHandle;
			BOOLEAN DisableNTLMCredentialCaching;
			UCHAR ExFlags;
			HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS DigestParams;
			HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS BasicParams;
		} HTTP_SERVER_AUTHENTICATION_INFO;
"

	super defineFields.
	self
		defineField: #AuthSchemes type: DWORDField new offset: 4;
		defineField: #ReceiveMutualAuth type: BOOLEANField new offset: 8;
		defineField: #ReceiveContextHandle type: BOOLEANField new offset: 9;
		defineField: #DisableNTLMCredentialCaching type: BOOLEANField new offset: 10;
		defineField: #ExFlags type: BYTEField new offset: 11;
		defineField: #DigestParams type: (StructureField type: HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS) offset: 12;
		defineField: #BasicParams type: (StructureField type: HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS) offset: 28.
	self byteSize: 36!

getFieldNames
	^#(#Present #AuthSchemes #ReceiveMutualAuth #ReceiveContextHandle #DisableNTLMCredentialCaching #ExFlags #DigestParams #BasicParams)!

propertyId
	^HttpServerAuthenticationProperty! !
!HTTP_SERVER_AUTHENTICATION_INFO class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_SERVER_AUTHENTICATION_INFO class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!HTTP_SERVER_AUTHENTICATION_INFO class categoriesFor: #propertyId!public! !

