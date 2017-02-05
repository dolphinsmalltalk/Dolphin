"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_CACHE_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_CACHE_SET guid: (GUID fromString: '{7D7F269D-CE99-4EE1-979D-387F6F2147BE}')!
HTTP_SERVICE_CONFIG_CACHE_SET comment: '<HTTP_SERVICE_CONFIG_CACHE_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_CACHE_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"To set a cache parameter value use the set structure. To query use the key directly.When you query a parameter value the output buffer must be exactly the sizeof param."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(7D7F269D-CE99-4EE1-979D-387F6F2147BE), helpstring("To set a cache parameter value use the set structure. To query use the key directly.When you query a parameter value the output buffer must be exactly the sizeof param.")]
struct tagHTTP_SERVICE_CONFIG_CACHE_SET {
	HTTP_SERVICE_CONFIG_CACHE_KEY KeyDesc;
	unsigned long paramdesc;
} HTTP_SERVICE_CONFIG_CACHE_SET;
'!
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_CACHE_SET methodsFor!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

paramdesc
	"Answer the receiver's paramdesc field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #paramdesc)!

paramdesc: anObject
	"Set the receiver's paramdesc field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #paramdesc) put: anObject! !
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesFor: #paramdesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_CACHE_SET categoriesFor: #paramdesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_CACHE_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_CACHE_SET structure.

	HTTP_SERVICE_CONFIG_CACHE_SET  compileDefinition

		typedef [uuid(7D7F269D-CE99-4EE1-979D-387F6F2147BE), helpstring('To set a cache parameter value use the set structure. To query use the key directly.When you query a parameter value the output buffer must be exactly the sizeof param.')]
		struct tagHTTP_SERVICE_CONFIG_CACHE_SET {
			HTTP_SERVICE_CONFIG_CACHE_KEY KeyDesc;
			unsigned long paramdesc;
		} HTTP_SERVICE_CONFIG_CACHE_SET;
"

	self
		defineField: #KeyDesc type: SDWORDField new offset: 0;
		defineField: #paramdesc type: DWORDField new offset: 4.
	self byteSize: 8! !
!HTTP_SERVICE_CONFIG_CACHE_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

