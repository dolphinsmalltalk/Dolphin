"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_CONFIG_TIMEOUT_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_CONFIG_TIMEOUT_SET guid: (GUID fromString: '{6F4ABCFC-2A59-4996-A958-5DE93DC64213}')!
HTTP_SERVICE_CONFIG_TIMEOUT_SET comment: '<HTTP_SERVICE_CONFIG_TIMEOUT_SET> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_CONFIG_TIMEOUT_SET'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(6F4ABCFC-2A59-4996-A958-5DE93DC64213), helpstring("To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param.")]
struct tagHTTP_SERVICE_CONFIG_TIMEOUT_SET {
	HTTP_SERVICE_CONFIG_TIMEOUT_KEY KeyDesc;
	unsigned short paramdesc;
} HTTP_SERVICE_CONFIG_TIMEOUT_SET;
'!
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET methodsFor!

KeyDesc
	"Answer the receiver's KeyDesc field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

KeyDesc: anObject
	"Set the receiver's KeyDesc field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

paramdesc
	"Answer the receiver's paramdesc field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #paramdesc)!

paramdesc: anObject
	"Set the receiver's paramdesc field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #paramdesc) put: anObject! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesFor: #KeyDesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesFor: #KeyDesc:!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesFor: #paramdesc!**compiled accessors**!public! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET categoriesFor: #paramdesc:!**compiled accessors**!public! !

!HTTP_SERVICE_CONFIG_TIMEOUT_SET class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_CONFIG_TIMEOUT_SET structure.

	HTTP_SERVICE_CONFIG_TIMEOUT_SET  compileDefinition

		typedef [uuid(6F4ABCFC-2A59-4996-A958-5DE93DC64213), helpstring('To set a timeout value use the set structure. To query/delete use the key directly. When you query a timeout value the output buffer must be exactly the sizeof param.')]
		struct tagHTTP_SERVICE_CONFIG_TIMEOUT_SET {
			HTTP_SERVICE_CONFIG_TIMEOUT_KEY KeyDesc;
			unsigned short paramdesc;
		} HTTP_SERVICE_CONFIG_TIMEOUT_SET;
"

	self
		defineField: #KeyDesc type: SDWORDField new offset: 0;
		defineField: #paramdesc type: WORDField new offset: 4.
	self byteSize: 8! !
!HTTP_SERVICE_CONFIG_TIMEOUT_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

