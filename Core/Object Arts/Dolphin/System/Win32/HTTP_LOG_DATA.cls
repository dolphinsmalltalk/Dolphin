"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_LOG_DATA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_LOG_DATA guid: (GUID fromString: '{318F801A-36D7-4A2F-942B-02F1C861873C}')!
HTTP_LOG_DATA comment: '<HTTP_LOG_DATA> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_LOG_DATA'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(318F801A-36D7-4A2F-942B-02F1C861873C)]
struct tagHTTP_LOG_DATA {
	HTTP_LOG_DATA_TYPE Type;
} HTTP_LOG_DATA;
'!
!HTTP_LOG_DATA categoriesForClass!Win32-Structs! !
!HTTP_LOG_DATA methodsFor!

Type
	"Answer the receiver's Type field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

Type: anObject
	"Set the receiver's Type field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject! !
!HTTP_LOG_DATA categoriesFor: #Type!**compiled accessors**!public! !
!HTTP_LOG_DATA categoriesFor: #Type:!**compiled accessors**!public! !

!HTTP_LOG_DATA class methodsFor!

defineFields
	"Define the fields of the HTTP_LOG_DATA structure.

	HTTP_LOG_DATA  compileDefinition

		typedef [uuid(318F801A-36D7-4A2F-942B-02F1C861873C)]
		struct tagHTTP_LOG_DATA {
			HTTP_LOG_DATA_TYPE Type;
		} HTTP_LOG_DATA;
"

	self
		defineField: #Type type: SDWORDField new offset: 0.
	self byteSize: 4! !
!HTTP_LOG_DATA class categoriesFor: #defineFields!**auto generated**!initializing!public! !

