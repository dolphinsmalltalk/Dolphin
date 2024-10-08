﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SERVICE_CONFIG_SSL_SNI_KEY_Size' -> 16r88.
			'_OffsetOf_Host' -> 16r80.
			'_OffsetOf_IpPort' -> 16r0
		}!

WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY guid: (Core.GUID fromString: '{32358de8-2f95-48e9-8b5e-72900a0e6f36}')!

WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY comment: '`HTTP_SERVICE_CONFIG_SSL_SNI_KEY` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY'' from type information in the ''Windows Http Server API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(32358de8-2f95-48e9-8b5e-72900a0e6f36)]
struct tagHTTP_SERVICE_CONFIG_SSL_SNI_KEY {
	SOCKADDR_STORAGE IpPort;
	LPWSTR Host;
} HTTP_SERVICE_CONFIG_SSL_SNI_KEY;
```
'!

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY methodsFor!

Host
	"Answer the <Utf16String> value of the receiver's 'Host' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_Host)!

Host: anUtf16String
	"Set the receiver's 'Host' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_Host put: anUtf16String yourAddress!

IpPort
	"Answer the <SOCKADDR_STORAGE> value of the receiver's 'IpPort' field."

	^SOCKADDR_STORAGE fromAddress: bytes yourAddress!

IpPort: aSOCKADDR_STORAGE
	"Set the receiver's 'IpPort' field to the value of the argument, aSOCKADDR_STORAGE"

	aSOCKADDR_STORAGE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_IpPort + 1)
		to: ##(_OffsetOf_IpPort + SOCKADDR_STORAGE._SOCKADDR_STORAGE_Size)
		startingAt: 1! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY categoriesForMethods!
Host!**compiled accessors**!public! !
Host:!**compiled accessors**!public! !
IpPort!**compiled accessors**!public! !
IpPort:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY class methodsFor!

byteSize
	^_HTTP_SERVICE_CONFIG_SSL_SNI_KEY_Size!

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
		defineField: #Host type: (PointerField type: Utf16String) offset: 128.
	self byteSize: 136!

getFieldNames
	^#(#IpPort #Host)! !

!WinHttpServer.HTTP_SERVICE_CONFIG_SSL_SNI_KEY class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

