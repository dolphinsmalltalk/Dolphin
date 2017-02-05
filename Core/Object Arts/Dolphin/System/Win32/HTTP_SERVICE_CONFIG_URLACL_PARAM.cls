"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_URLACL_PARAM
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_URLACL_PARAM guid: (GUID fromString: '{8E85EDB8-AA68-4FB2-9982-565C833B1478}')!
HTTP_SERVICE_CONFIG_URLACL_PARAM comment: '<HTTP_SERVICE_CONFIG_URLACL_PARAM> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_URLACL_PARAM'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This defines a record for the SSL config store."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(8E85EDB8-AA68-4FB2-9982-565C833B1478), helpstring("This defines a record for the SSL config store.")]
struct tagHTTP_SERVICE_CONFIG_URLACL_PARAM {
	LPWSTR pStringSecurityDescriptor;
} HTTP_SERVICE_CONFIG_URLACL_PARAM;
'!
!HTTP_SERVICE_CONFIG_URLACL_PARAM categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_URLACL_PARAM methodsFor!

pStringSecurityDescriptor
	"Answer the receiver's pStringSecurityDescriptor field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: 0)!

pStringSecurityDescriptor: anObject
	"Set the receiver's pStringSecurityDescriptor field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject yourAddress! !
!HTTP_SERVICE_CONFIG_URLACL_PARAM categoriesFor: #pStringSecurityDescriptor!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_URLACL_PARAM categoriesFor: #pStringSecurityDescriptor:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_URLACL_PARAM class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_URLACL_PARAM structure.

	HTTP_SERVICE_CONFIG_URLACL_PARAM  compileDefinition

		typedef [uuid(8E85EDB8-AA68-4FB2-9982-565C833B1478), helpstring('This defines a record for the SSL config store.')]
		struct tagHTTP_SERVICE_CONFIG_URLACL_PARAM {
			LPWSTR pStringSecurityDescriptor;
		} HTTP_SERVICE_CONFIG_URLACL_PARAM;
"

	self
		defineField: #pStringSecurityDescriptor type: (PointerField type: UnicodeString) offset: 0.
	self byteSize: 4! !
!HTTP_SERVICE_CONFIG_URLACL_PARAM class categoriesFor: #defineFields!**auto generated**!initializing!public! !

