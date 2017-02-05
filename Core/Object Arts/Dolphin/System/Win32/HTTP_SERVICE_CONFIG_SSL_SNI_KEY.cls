"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_SSL_SNI_KEY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_SNI_KEY guid: (GUID fromString: '{32358DE8-2F95-48E9-8B5E-72900A0E6F36}')!
HTTP_SERVICE_CONFIG_SSL_SNI_KEY comment: '<HTTP_SERVICE_CONFIG_SSL_SNI_KEY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_SNI_KEY'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(32358DE8-2F95-48E9-8B5E-72900A0E6F36)]
struct tagHTTP_SERVICE_CONFIG_SSL_SNI_KEY {
	SOCKADDR_STORAGE IpPort;
	LPWSTR Host;
} HTTP_SERVICE_CONFIG_SSL_SNI_KEY;
'!
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY methodsFor!

Host
	"Answer the receiver's Host field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Host))!

Host: anObject
	"Set the receiver's Host field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Host) put: anObject yourAddress!

IpPort
	"Answer the receiver's IpPort field as a Smalltalk object."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress!

IpPort: anObject
	"Set the receiver's IpPort field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: 1
		to: ##(SOCKADDR_STORAGE basicByteSize)
		startingAt: 1! !
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY categoriesFor: #Host!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY categoriesFor: #Host:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY categoriesFor: #IpPort!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY categoriesFor: #IpPort:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_SSL_SNI_KEY class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_SSL_SNI_KEY structure.

	HTTP_SERVICE_CONFIG_SSL_SNI_KEY  compileDefinition

		typedef [uuid(32358DE8-2F95-48E9-8B5E-72900A0E6F36)]
		struct tagHTTP_SERVICE_CONFIG_SSL_SNI_KEY {
			SOCKADDR_STORAGE IpPort;
			LPWSTR Host;
		} HTTP_SERVICE_CONFIG_SSL_SNI_KEY;
"

	self
		defineField: #IpPort type: (StructureField type: SOCKADDR_STORAGE) offset: 0;
		defineField: #Host type: (PointerField type: UnicodeString) offset: 128.
	self byteSize: 136! !
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY class categoriesFor: #defineFields!**auto generated**!initializing!public! !

