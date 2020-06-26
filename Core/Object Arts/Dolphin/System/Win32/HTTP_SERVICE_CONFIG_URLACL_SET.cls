"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_SERVICE_CONFIG_URLACL_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_KeyDesc' -> 16r0.
		'_OffsetOf_ParamDesc' -> 16r4
	}!
HTTP_SERVICE_CONFIG_URLACL_SET guid: (GUID fromString: '{8144c4ca-dfd3-4ed0-a83b-ad096bd611a4}')!
HTTP_SERVICE_CONFIG_URLACL_SET comment: '<HTTP_SERVICE_CONFIG_URLACL_SET> is an <ExternalStructure> class to wrap the struct ''WinHttpServer.HTTP_SERVICE_CONFIG_URLACL_SET'' from type information in the ''Windows Http Server API'' library.

The type library contains the following helpstring for this struct
	"This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(8144c4ca-dfd3-4ed0-a83b-ad096bd611a4), helpstring("This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store.")]
struct tagHTTP_SERVICE_CONFIG_URLACL_SET {
	HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_URLACL_PARAM ParamDesc;
} HTTP_SERVICE_CONFIG_URLACL_SET;
'!
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesForClass!WinHttpServer-Structs! !
!HTTP_SERVICE_CONFIG_URLACL_SET methodsFor!

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
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #ParamDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #ParamDesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_URLACL_SET class methodsFor!

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
!HTTP_SERVICE_CONFIG_URLACL_SET class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!HTTP_SERVICE_CONFIG_URLACL_SET class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

