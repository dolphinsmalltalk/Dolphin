"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_SSL_SNI_KEY
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_SSL_SNI_KEY guid: (GUID fromString: '{32358de8-2f95-48e9-8b5e-72900a0e6f36}')!
HTTP_SERVICE_CONFIG_SSL_SNI_KEY comment: '<HTTP_SERVICE_CONFIG_SSL_SNI_KEY> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_SSL_SNI_KEY'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(32358de8-2f95-48e9-8b5e-72900a0e6f36)]
struct tagHTTP_SERVICE_CONFIG_SSL_SNI_KEY {
	SOCKADDR_STORAGE IpPort;
	LPWSTR Host;
} HTTP_SERVICE_CONFIG_SSL_SNI_KEY;
'!
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_SSL_SNI_KEY methodsFor!

Host
	"Answer the <UnicodeString> value of the receiver's 'Host' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Host))!

Host: anUnicodeString
	"Set the receiver's 'Host' field to the value of the argument, anUnicodeString"

	bytes uintPtrAtOffset: ##(self offsetOf: #Host) put: anUnicodeString yourAddress!

IpPort
	"Answer the <SOCKADDR_STORAGE> value of the receiver's 'IpPort' field."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress!

IpPort: aSOCKADDR_STORAGE
	"Set the receiver's 'IpPort' field to the value of the argument, aSOCKADDR_STORAGE"

	aSOCKADDR_STORAGE
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

	HTTP_SERVICE_CONFIG_SSL_SNI_KEY compileDefinition

		typedef [uuid(32358de8-2f95-48e9-8b5e-72900a0e6f36)]
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

