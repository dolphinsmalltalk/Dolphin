"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVER_AUTHENTICATION_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVER_AUTHENTICATION_INFO guid: (GUID fromString: '{7F4599B6-BDFD-4A19-8A4A-A7FD55A9E207}')!
HTTP_SERVER_AUTHENTICATION_INFO comment: '<HTTP_SERVER_AUTHENTICATION_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVER_AUTHENTICATION_INFO'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7F4599B6-BDFD-4A19-8A4A-A7FD55A9E207)]
struct tagHTTP_SERVER_AUTHENTICATION_INFO {
	HTTP_PROPERTY_FLAGS flags;
	unsigned long AuthSchemes;
	CHAR ReceiveMutualAuth;
	CHAR ReceiveContextHandle;
	CHAR DisableNTLMCredentialCaching;
	BYTE ExFlags;
	HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS DigestParams;
	HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS BasicParams;
} HTTP_SERVER_AUTHENTICATION_INFO;
'!
!HTTP_SERVER_AUTHENTICATION_INFO categoriesForClass!Win32-Structs! !
!HTTP_SERVER_AUTHENTICATION_INFO methodsFor!

AuthSchemes
	"Answer the receiver's AuthSchemes field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #AuthSchemes)!

AuthSchemes: anObject
	"Set the receiver's AuthSchemes field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #AuthSchemes) put: anObject!

BasicParams
	"Answer the receiver's BasicParams field as a Smalltalk object."

	^HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS
		fromAddress: bytes yourAddress + ##(self offsetOf: #BasicParams)!

BasicParams: anObject
	"Set the receiver's BasicParams field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #BasicParams) + 1)
		to: ##((self offsetOf: #BasicParams) + HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS basicByteSize)
		startingAt: 1!

DigestParams
	"Answer the receiver's DigestParams field as a Smalltalk object."

	^HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS
		fromAddress: bytes yourAddress + ##(self offsetOf: #DigestParams)!

DigestParams: anObject
	"Set the receiver's DigestParams field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #DigestParams) + 1)
		to: ##((self offsetOf: #DigestParams) + HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS basicByteSize)
		startingAt: 1!

DisableNTLMCredentialCaching
	"Answer the receiver's DisableNTLMCredentialCaching field as a Smalltalk object."

	^bytes sbyteAtOffset: ##(self offsetOf: #DisableNTLMCredentialCaching)!

DisableNTLMCredentialCaching: anObject
	"Set the receiver's DisableNTLMCredentialCaching field to the value of anObject."

	bytes sbyteAtOffset: ##(self offsetOf: #DisableNTLMCredentialCaching) put: anObject!

ExFlags
	"Answer the receiver's ExFlags field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #ExFlags)!

ExFlags: anObject
	"Set the receiver's ExFlags field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #ExFlags) put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

ReceiveContextHandle
	"Answer the receiver's ReceiveContextHandle field as a Smalltalk object."

	^bytes sbyteAtOffset: ##(self offsetOf: #ReceiveContextHandle)!

ReceiveContextHandle: anObject
	"Set the receiver's ReceiveContextHandle field to the value of anObject."

	bytes sbyteAtOffset: ##(self offsetOf: #ReceiveContextHandle) put: anObject!

ReceiveMutualAuth
	"Answer the receiver's ReceiveMutualAuth field as a Smalltalk object."

	^bytes sbyteAtOffset: ##(self offsetOf: #ReceiveMutualAuth)!

ReceiveMutualAuth: anObject
	"Set the receiver's ReceiveMutualAuth field to the value of anObject."

	bytes sbyteAtOffset: ##(self offsetOf: #ReceiveMutualAuth) put: anObject! !
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
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ReceiveContextHandle!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ReceiveContextHandle:!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ReceiveMutualAuth!**compiled accessors**!public! !
!HTTP_SERVER_AUTHENTICATION_INFO categoriesFor: #ReceiveMutualAuth:!**compiled accessors**!public! !

!HTTP_SERVER_AUTHENTICATION_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVER_AUTHENTICATION_INFO structure.

	HTTP_SERVER_AUTHENTICATION_INFO  compileDefinition

		typedef [uuid(7F4599B6-BDFD-4A19-8A4A-A7FD55A9E207)]
		struct tagHTTP_SERVER_AUTHENTICATION_INFO {
			HTTP_PROPERTY_FLAGS flags;
			unsigned long AuthSchemes;
			CHAR ReceiveMutualAuth;
			CHAR ReceiveContextHandle;
			CHAR DisableNTLMCredentialCaching;
			BYTE ExFlags;
			HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS DigestParams;
			HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS BasicParams;
		} HTTP_SERVER_AUTHENTICATION_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #AuthSchemes type: DWORDField new offset: 4;
		defineField: #ReceiveMutualAuth type: SBYTEField new offset: 8;
		defineField: #ReceiveContextHandle type: SBYTEField new offset: 9;
		defineField: #DisableNTLMCredentialCaching type: SBYTEField new offset: 10;
		defineField: #ExFlags type: BYTEField new offset: 11;
		defineField: #DigestParams type: (StructureField type: HTTP_SERVER_AUTHENTICATION_DIGEST_PARAMS) offset: 12;
		defineField: #BasicParams type: (StructureField type: HTTP_SERVER_AUTHENTICATION_BASIC_PARAMS) offset: 28.
	self byteSize: 36! !
!HTTP_SERVER_AUTHENTICATION_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

