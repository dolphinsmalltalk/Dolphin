"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SSL_PROTOCOL_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SSL_PROTOCOL_INFO guid: (GUID fromString: '{73784AFD-F4E5-464E-B716-46EBB0C8C6D1}')!
HTTP_SSL_PROTOCOL_INFO comment: '<HTTP_SSL_PROTOCOL_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SSL_PROTOCOL_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"HttpRequestInfoTypeSslProtocol payload. Contains basic information about the SSL/TLS protocol and cipher. See SecPkgContext_ConnectionInfo documentation for details."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(73784AFD-F4E5-464E-B716-46EBB0C8C6D1), helpstring("HttpRequestInfoTypeSslProtocol payload. Contains basic information about the SSL/TLS protocol and cipher. See SecPkgContext_ConnectionInfo documentation for details.")]
struct tagHTTP_SSL_PROTOCOL_INFO {
	unsigned long Protocol;
	unsigned long CipherType;
	unsigned long CipherStrength;
	unsigned long HashType;
	unsigned long HashStrength;
	unsigned long KeyExchangeType;
	unsigned long KeyExchangeStrength;
} HTTP_SSL_PROTOCOL_INFO;
'!
!HTTP_SSL_PROTOCOL_INFO categoriesForClass!Win32-Structs! !
!HTTP_SSL_PROTOCOL_INFO methodsFor!

CipherStrength
	"Answer the receiver's CipherStrength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #CipherStrength)!

CipherStrength: anObject
	"Set the receiver's CipherStrength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #CipherStrength) put: anObject!

CipherType
	"Answer the receiver's CipherType field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #CipherType)!

CipherType: anObject
	"Set the receiver's CipherType field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #CipherType) put: anObject!

HashStrength
	"Answer the receiver's HashStrength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #HashStrength)!

HashStrength: anObject
	"Set the receiver's HashStrength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #HashStrength) put: anObject!

HashType
	"Answer the receiver's HashType field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #HashType)!

HashType: anObject
	"Set the receiver's HashType field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #HashType) put: anObject!

KeyExchangeStrength
	"Answer the receiver's KeyExchangeStrength field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #KeyExchangeStrength)!

KeyExchangeStrength: anObject
	"Set the receiver's KeyExchangeStrength field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #KeyExchangeStrength) put: anObject!

KeyExchangeType
	"Answer the receiver's KeyExchangeType field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #KeyExchangeType)!

KeyExchangeType: anObject
	"Set the receiver's KeyExchangeType field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #KeyExchangeType) put: anObject!

Protocol
	"Answer the receiver's Protocol field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

Protocol: anObject
	"Set the receiver's Protocol field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #CipherStrength!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #CipherStrength:!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #CipherType!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #CipherType:!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #HashStrength!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #HashStrength:!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #HashType!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #HashType:!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #KeyExchangeStrength!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #KeyExchangeStrength:!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #KeyExchangeType!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #KeyExchangeType:!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #Protocol!**compiled accessors**!public! !
!HTTP_SSL_PROTOCOL_INFO categoriesFor: #Protocol:!**compiled accessors**!public! !

!HTTP_SSL_PROTOCOL_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_SSL_PROTOCOL_INFO structure.

	HTTP_SSL_PROTOCOL_INFO  compileDefinition

		typedef [uuid(73784AFD-F4E5-464E-B716-46EBB0C8C6D1), helpstring('HttpRequestInfoTypeSslProtocol payload. Contains basic information about the SSL/TLS protocol and cipher. See SecPkgContext_ConnectionInfo documentation for details.')]
		struct tagHTTP_SSL_PROTOCOL_INFO {
			unsigned long Protocol;
			unsigned long CipherType;
			unsigned long CipherStrength;
			unsigned long HashType;
			unsigned long HashStrength;
			unsigned long KeyExchangeType;
			unsigned long KeyExchangeStrength;
		} HTTP_SSL_PROTOCOL_INFO;
"

	self
		defineField: #Protocol type: DWORDField new offset: 0;
		defineField: #CipherType type: DWORDField new offset: 4;
		defineField: #CipherStrength type: DWORDField new offset: 8;
		defineField: #HashType type: DWORDField new offset: 12;
		defineField: #HashStrength type: DWORDField new offset: 16;
		defineField: #KeyExchangeType type: DWORDField new offset: 20;
		defineField: #KeyExchangeStrength type: DWORDField new offset: 24.
	self byteSize: 28! !
!HTTP_SSL_PROTOCOL_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

