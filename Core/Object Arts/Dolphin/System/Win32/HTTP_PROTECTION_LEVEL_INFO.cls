"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_PROTECTION_LEVEL_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_PROTECTION_LEVEL_INFO guid: (GUID fromString: '{E1881388-D03E-4EA0-8E39-8F1439753299}')!
HTTP_PROTECTION_LEVEL_INFO comment: '<HTTP_PROTECTION_LEVEL_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_PROTECTION_LEVEL_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Controls whether the associated UrlGroup Namespace should receive edge traversed traffic. By default this parameter is unspecified."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(E1881388-D03E-4EA0-8E39-8F1439753299), helpstring("Controls whether the associated UrlGroup Namespace should receive edge traversed traffic. By default this parameter is unspecified.")]
struct tagHTTP_PROTECTION_LEVEL_INFO {
	HTTP_PROPERTY_FLAGS flags;
	HTTP_PROTECTION_LEVEL_TYPE Level;
} HTTP_PROTECTION_LEVEL_INFO;
'!
!HTTP_PROTECTION_LEVEL_INFO categoriesForClass!Win32-Structs! !
!HTTP_PROTECTION_LEVEL_INFO methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

Level
	"Answer the receiver's Level field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #Level)!

Level: anObject
	"Set the receiver's Level field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #Level) put: anObject! !
!HTTP_PROTECTION_LEVEL_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_PROTECTION_LEVEL_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_PROTECTION_LEVEL_INFO categoriesFor: #Level!**compiled accessors**!public! !
!HTTP_PROTECTION_LEVEL_INFO categoriesFor: #Level:!**compiled accessors**!public! !

!HTTP_PROTECTION_LEVEL_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_PROTECTION_LEVEL_INFO structure.

	HTTP_PROTECTION_LEVEL_INFO  compileDefinition

		typedef [uuid(E1881388-D03E-4EA0-8E39-8F1439753299), helpstring('Controls whether the associated UrlGroup Namespace should receive edge traversed traffic. By default this parameter is unspecified.')]
		struct tagHTTP_PROTECTION_LEVEL_INFO {
			HTTP_PROPERTY_FLAGS flags;
			HTTP_PROTECTION_LEVEL_TYPE Level;
		} HTTP_PROTECTION_LEVEL_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #Level type: SDWORDField new offset: 4.
	self byteSize: 8! !
!HTTP_PROTECTION_LEVEL_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

