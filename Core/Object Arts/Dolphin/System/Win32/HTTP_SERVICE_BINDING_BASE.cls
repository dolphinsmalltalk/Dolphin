"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_BINDING_BASE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_BINDING_BASE guid: (GUID fromString: '{80F84F87-9667-42D4-ACE4-1004DFE14475}')!
HTTP_SERVICE_BINDING_BASE comment: '<HTTP_SERVICE_BINDING_BASE> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_BINDING_BASE'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(80F84F87-9667-42D4-ACE4-1004DFE14475), helpstring("Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure.")]
struct tagHTTP_SERVICE_BINDING_BASE {
	HTTP_SERVICE_BINDING_TYPE Type;
} HTTP_SERVICE_BINDING_BASE;
'!
!HTTP_SERVICE_BINDING_BASE categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_BINDING_BASE methodsFor!

Type
	"Answer the receiver's Type field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

Type: anObject
	"Set the receiver's Type field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!HTTP_SERVICE_BINDING_BASE categoriesFor: #Type!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_BASE categoriesFor: #Type:!**compiled accessors**!public! !

!HTTP_SERVICE_BINDING_BASE class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_BINDING_BASE structure.

	HTTP_SERVICE_BINDING_BASE  compileDefinition

		typedef [uuid(80F84F87-9667-42D4-ACE4-1004DFE14475), helpstring('Common base for the HTTP_SERVICE_BINDING_A structure and the HTTP_SERVICE_BINDING_W structure.')]
		struct tagHTTP_SERVICE_BINDING_BASE {
			HTTP_SERVICE_BINDING_TYPE Type;
		} HTTP_SERVICE_BINDING_BASE;
"

	self
		defineField: #Type type: SDWORDField new offset: 0.
	self byteSize: 4! !
!HTTP_SERVICE_BINDING_BASE class categoriesFor: #defineFields!**auto generated**!initializing!public! !

