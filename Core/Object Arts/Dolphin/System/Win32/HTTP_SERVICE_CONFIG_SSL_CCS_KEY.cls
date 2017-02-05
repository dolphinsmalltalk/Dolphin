"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_CCS_KEY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_CCS_KEY guid: (GUID fromString: '{1958EA2F-3B8B-4F4D-8E13-EC488AFB2BF0}')!
HTTP_SERVICE_CONFIG_SSL_CCS_KEY comment: '<HTTP_SERVICE_CONFIG_SSL_CCS_KEY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_CCS_KEY'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(1958EA2F-3B8B-4F4D-8E13-EC488AFB2BF0)]
struct tagHTTP_SERVICE_CONFIG_SSL_CCS_KEY {
	SOCKADDR_STORAGE LocalAddress;
} HTTP_SERVICE_CONFIG_SSL_CCS_KEY;
'!
!HTTP_SERVICE_CONFIG_SSL_CCS_KEY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_CCS_KEY methodsFor!

LocalAddress
	"Answer the receiver's LocalAddress field as a Smalltalk object."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress!

LocalAddress: anObject
	"Set the receiver's LocalAddress field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: 1
		to: ##(SOCKADDR_STORAGE basicByteSize)
		startingAt: 1! !
!HTTP_SERVICE_CONFIG_SSL_CCS_KEY categoriesFor: #LocalAddress!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_CCS_KEY categoriesFor: #LocalAddress:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_CCS_KEY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_CCS_KEY structure.

	HTTP_SERVICE_CONFIG_SSL_CCS_KEY  compileDefinition

		typedef [uuid(1958EA2F-3B8B-4F4D-8E13-EC488AFB2BF0)]
		struct tagHTTP_SERVICE_CONFIG_SSL_CCS_KEY {
			SOCKADDR_STORAGE LocalAddress;
		} HTTP_SERVICE_CONFIG_SSL_CCS_KEY;
"

	self
		defineField: #LocalAddress type: (StructureField type: SOCKADDR_STORAGE) offset: 0.
	self byteSize: 128! !
!HTTP_SERVICE_CONFIG_SSL_CCS_KEY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

