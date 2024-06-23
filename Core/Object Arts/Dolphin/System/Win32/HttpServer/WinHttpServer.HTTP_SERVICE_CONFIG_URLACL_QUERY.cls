"Filed out from Dolphin Smalltalk"!

WinHttpServer.HttpServiceConfigQuery
	subclass: #'WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_HTTP_SERVICE_CONFIG_URLACL_QUERY_Size' -> 16rC.
			'_OffsetOf_dwToken' -> 16r8.
			'_OffsetOf_KeyDesc' -> 16r4
		}!

WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY guid: (Core.GUID fromString: '{fbe6f060-f472-445e-b48c-9caa8faedc7e}')!

WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY comment: '`HTTP_SERVICE_CONFIG_URLACL_QUERY` is an `External.Structure` class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This data structure is used by HttpQueryServiceConfiguration() for the	config ID HttpServiceConfigUrlAclInfo to query records from the URL ACL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated.

IDL definition follows:
```
typedef [uuid(fbe6f060-f472-445e-b48c-9caa8faedc7e), helpstring("This data structure is used by HttpQueryServiceConfiguration() for the config ID HttpServiceConfigUrlAclInfo to query records from the URL ACL store.")]
struct tagHTTP_SERVICE_CONFIG_URLACL_QUERY {
	HttpServiceConfigQuery;
	HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
	DWORD dwToken;
} HTTP_SERVICE_CONFIG_URLACL_QUERY;
```
'!

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY categoriesForClass!Win32-Structs! !

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY methodsFor!

dwToken
	"Answer the <Integer> value of the receiver's 'dwToken' field."

	^bytes uint32AtOffset: _OffsetOf_dwToken!

dwToken: anInteger
	"Set the receiver's 'dwToken' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwToken put: anInteger!

KeyDesc
	"Answer the <Utf16String> value of the receiver's 'KeyDesc' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_KeyDesc)!

KeyDesc: anUtf16String
	"Set the receiver's 'KeyDesc' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_KeyDesc put: anUtf16String yourAddress! !

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY categoriesForMethods!
dwToken!**compiled accessors**!public! !
dwToken:!**compiled accessors**!public! !
KeyDesc!**compiled accessors**!public! !
KeyDesc:!**compiled accessors**!public! !
!

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY class methodsFor!

byteSize
	^_HTTP_SERVICE_CONFIG_URLACL_QUERY_Size!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_URLACL_QUERY structure.

	HTTP_SERVICE_CONFIG_URLACL_QUERY compileDefinition

		typedef [uuid(fbe6f060-f472-445e-b48c-9caa8faedc7e), helpstring('This data structure is used by HttpQueryServiceConfiguration() for the config ID HttpServiceConfigUrlAclInfo to query records from the URL ACL store.')]
		struct tagHTTP_SERVICE_CONFIG_URLACL_QUERY {
			HttpServiceConfigQuery;
			HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
			DWORD dwToken;
		} HTTP_SERVICE_CONFIG_URLACL_QUERY;
"

	super defineFields.
	self
		defineField: #KeyDesc type: (PointerField type: Utf16String) offset: 4;
		defineField: #dwToken type: UInt32Field new offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#QueryDesc #KeyDesc #dwToken)! !

!WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_QUERY class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

