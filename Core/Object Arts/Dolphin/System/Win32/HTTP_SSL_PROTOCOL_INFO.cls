"Filed out from Dolphin Smalltalk"!

HttpServerStructure subclass: #HTTP_SSL_PROTOCOL_INFO
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_CipherStrength _OffsetOf_CipherType _OffsetOf_HashStrength _OffsetOf_HashType _OffsetOf_KeyExchangeStrength _OffsetOf_KeyExchangeType _OffsetOf_Protocol'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SSL_PROTOCOL_INFO guid: (GUID fromString: '{73784afd-f4e5-464e-b716-46ebb0c8c6d1}')!
HTTP_SSL_PROTOCOL_INFO addClassConstant: '_OffsetOf_CipherStrength' value: 16r8!
HTTP_SSL_PROTOCOL_INFO addClassConstant: '_OffsetOf_CipherType' value: 16r4!
HTTP_SSL_PROTOCOL_INFO addClassConstant: '_OffsetOf_HashStrength' value: 16r10!
HTTP_SSL_PROTOCOL_INFO addClassConstant: '_OffsetOf_HashType' value: 16rC!
HTTP_SSL_PROTOCOL_INFO addClassConstant: '_OffsetOf_KeyExchangeStrength' value: 16r18!
HTTP_SSL_PROTOCOL_INFO addClassConstant: '_OffsetOf_KeyExchangeType' value: 16r14!
HTTP_SSL_PROTOCOL_INFO addClassConstant: '_OffsetOf_Protocol' value: 16r0!
HTTP_SSL_PROTOCOL_INFO comment: '<HTTP_SSL_PROTOCOL_INFO> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SSL_PROTOCOL_INFO'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"HttpRequestInfoTypeSslProtocol payload. Contains basic information about the SSL/TLS protocol and cipher. See SecPkgContext_ConnectionInfo documentation for details."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(73784afd-f4e5-464e-b716-46ebb0c8c6d1), helpstring("HttpRequestInfoTypeSslProtocol payload. Contains basic information about the SSL/TLS protocol and cipher. See SecPkgContext_ConnectionInfo documentation for details.")]
struct tagHTTP_SSL_PROTOCOL_INFO {
	[readonly] ULONG Protocol;
	[readonly] ULONG CipherType;
	[readonly] ULONG CipherStrength;
	[readonly] ULONG HashType;
	[readonly] ULONG HashStrength;
	[readonly] ULONG KeyExchangeType;
	[readonly] ULONG KeyExchangeStrength;
} HTTP_SSL_PROTOCOL_INFO;
'!
!HTTP_SSL_PROTOCOL_INFO categoriesForClass!WinHttpServer-Structs! !
!HTTP_SSL_PROTOCOL_INFO methodsFor!

CipherStrength
	"Answer the <Integer> value of the receiver's 'CipherStrength' field."

	^bytes dwordAtOffset: _OffsetOf_CipherStrength!

CipherType
	"Answer the <Integer> value of the receiver's 'CipherType' field."

	^bytes dwordAtOffset: _OffsetOf_CipherType!

HashStrength
	"Answer the <Integer> value of the receiver's 'HashStrength' field."

	^bytes dwordAtOffset: _OffsetOf_HashStrength!

HashType
	"Answer the <Integer> value of the receiver's 'HashType' field."

	^bytes dwordAtOffset: _OffsetOf_HashType!

KeyExchangeStrength
	"Answer the <Integer> value of the receiver's 'KeyExchangeStrength' field."

	^bytes dwordAtOffset: _OffsetOf_KeyExchangeStrength!

KeyExchangeType
	"Answer the <Integer> value of the receiver's 'KeyExchangeType' field."

	^bytes dwordAtOffset: _OffsetOf_KeyExchangeType!

Protocol
	"Answer the <Integer> value of the receiver's 'Protocol' field."

	^bytes dwordAtOffset: _OffsetOf_Protocol! !
!HTTP_SSL_PROTOCOL_INFO categoriesForMethods!
CipherStrength!**compiled accessors**!public! !
CipherType!**compiled accessors**!public! !
HashStrength!**compiled accessors**!public! !
HashType!**compiled accessors**!public! !
KeyExchangeStrength!**compiled accessors**!public! !
KeyExchangeType!**compiled accessors**!public! !
Protocol!**compiled accessors**!public! !
!

!HTTP_SSL_PROTOCOL_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_SSL_PROTOCOL_INFO structure.

	HTTP_SSL_PROTOCOL_INFO compileDefinition

		typedef [uuid(73784afd-f4e5-464e-b716-46ebb0c8c6d1), helpstring('HttpRequestInfoTypeSslProtocol payload. Contains basic information about the SSL/TLS protocol and cipher. See SecPkgContext_ConnectionInfo documentation for details.')]
		struct tagHTTP_SSL_PROTOCOL_INFO {
			[readonly] ULONG Protocol;
			[readonly] ULONG CipherType;
			[readonly] ULONG CipherStrength;
			[readonly] ULONG HashType;
			[readonly] ULONG HashStrength;
			[readonly] ULONG KeyExchangeType;
			[readonly] ULONG KeyExchangeStrength;
		} HTTP_SSL_PROTOCOL_INFO;
"

	self
		defineField: #Protocol type: DWORDField new beReadOnly offset: 0;
		defineField: #CipherType type: DWORDField new beReadOnly offset: 4;
		defineField: #CipherStrength type: DWORDField new beReadOnly offset: 8;
		defineField: #HashType type: DWORDField new beReadOnly offset: 12;
		defineField: #HashStrength type: DWORDField new beReadOnly offset: 16;
		defineField: #KeyExchangeType type: DWORDField new beReadOnly offset: 20;
		defineField: #KeyExchangeStrength type: DWORDField new beReadOnly offset: 24.
	self byteSize: 28!

getFieldNames
	^#(#Protocol #CipherType #CipherStrength #HashType #HashStrength #KeyExchangeType #KeyExchangeStrength)! !
!HTTP_SSL_PROTOCOL_INFO class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

