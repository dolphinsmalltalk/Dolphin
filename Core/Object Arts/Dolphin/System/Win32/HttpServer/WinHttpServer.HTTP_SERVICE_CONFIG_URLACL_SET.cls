﻿"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServerStructure
	subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SERVICE_CONFIG_URLACL_SET_Size' -> 16r8.
			'_OffsetOf_KeyDesc' -> 16r0.
			'_OffsetOf_ParamDesc' -> 16r4
		}!

WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET guid: (Core.GUID fromString: '{8144c4ca-dfd3-4ed0-a83b-ad096bd611a4}')!

WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET comment: '`HTTP_SERVICE_CONFIG_URLACL_SET` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(8144c4ca-dfd3-4ed0-a83b-ad096bd611a4), helpstring("This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store.")]
struct tagHTTP_SERVICE_CONFIG_URLACL_SET {
	HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_URLACL_PARAM ParamDesc;
} HTTP_SERVICE_CONFIG_URLACL_SET;
```
'!

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET categoriesForClass!WinHttpServer-Structs! !

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET methodsFor!

KeyDesc
	"Answer the <Utf16String> value of the receiver's 'KeyDesc' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_KeyDesc)!

KeyDesc: anUtf16String
	"Set the receiver's 'KeyDesc' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_KeyDesc put: anUtf16String yourAddress!

ParamDesc
	"Answer the <Utf16String> value of the receiver's 'ParamDesc' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_ParamDesc)!

ParamDesc: anUtf16String
	"Set the receiver's 'ParamDesc' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_ParamDesc put: anUtf16String yourAddress! !

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET categoriesForMethods!
KeyDesc!**compiled accessors**!public! !
KeyDesc:!**compiled accessors**!public! !
ParamDesc!**compiled accessors**!public! !
ParamDesc:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET class methodsFor!

byteSize
	^_HTTP_SERVICE_CONFIG_URLACL_SET_Size!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_URLACL_SET structure.

	HTTP_SERVICE_CONFIG_URLACL_SET compileDefinition

		typedef [uuid(8144c4ca-dfd3-4ed0-a83b-ad096bd611a4), helpstring('This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store.')]
		struct tagHTTP_SERVICE_CONFIG_URLACL_SET {
			HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_URLACL_PARAM ParamDesc;
		} HTTP_SERVICE_CONFIG_URLACL_SET;
"

	self
		defineField: #KeyDesc type: (PointerField type: Utf16String) offset: 0;
		defineField: #ParamDesc type: (PointerField type: Utf16String) offset: 4.
	self byteSize: 8!

getFieldNames
	^#(#KeyDesc #ParamDesc)! !

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

