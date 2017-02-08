"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_URLACL_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_URLACL_SET guid: (GUID fromString: '{8144C4CA-DFD3-4ED0-A83B-AD096BD611A4}')!
HTTP_SERVICE_CONFIG_URLACL_SET comment: '<HTTP_SERVICE_CONFIG_URLACL_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_URLACL_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(8144C4CA-DFD3-4ED0-A83B-AD096BD611A4), helpstring("This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store.")]
struct tagHTTP_SERVICE_CONFIG_URLACL_SET {
	HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
	HTTP_SERVICE_CONFIG_URLACL_PARAM paramdesc;
} HTTP_SERVICE_CONFIG_URLACL_SET;
'!
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_URLACL_SET methodsFor!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 0)!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress!

paramdesc
	"Answer the receiver's paramdesc field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #paramdesc))!

paramdesc: anObject
	"Set the receiver's paramdesc field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #paramdesc) put: anObject yourAddress! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #paramdesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_SET categoriesFor: #paramdesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_URLACL_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_URLACL_SET structure.

	HTTP_SERVICE_CONFIG_URLACL_SET  compileDefinition

		typedef [uuid(8144C4CA-DFD3-4ED0-A83B-AD096BD611A4), helpstring('This data structure is used by HttpSetServiceConfiguration for the config ID HttpServiceConfigUrlAclInfo.It is used to add a new record to the URL ACL store.')]
		struct tagHTTP_SERVICE_CONFIG_URLACL_SET {
			HTTP_SERVICE_CONFIG_URLACL_KEY KeyDesc;
			HTTP_SERVICE_CONFIG_URLACL_PARAM paramdesc;
		} HTTP_SERVICE_CONFIG_URLACL_SET;
"

	self
		defineField: #KeyDesc type: (PointerField type: UnicodeString) offset: 0;
		defineField: #paramdesc type: (PointerField type: UnicodeString) offset: 4.
	self byteSize: 8! !
!HTTP_SERVICE_CONFIG_URLACL_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

