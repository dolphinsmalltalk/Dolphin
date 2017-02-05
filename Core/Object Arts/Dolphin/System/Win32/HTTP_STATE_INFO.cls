"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_STATE_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_STATE_INFO guid: (GUID fromString: '{5DC84435-3EB8-42FE-94BF-25F253E612FD}')!
HTTP_STATE_INFO comment: '<HTTP_STATE_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_STATE_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The HTTP_STATE_INFO structure is used to enable or disable a Server Session or URL Group."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(5DC84435-3EB8-42FE-94BF-25F253E612FD), helpstring("The HTTP_STATE_INFO structure is used to enable or disable a Server Session or URL Group.")]
struct tagHTTP_STATE_INFO {
	HTTP_PROPERTY_FLAGS flags;
	HTTP_ENABLED_STATE State;
} HTTP_STATE_INFO;
'!
!HTTP_STATE_INFO categoriesForClass!Win32-Structs! !
!HTTP_STATE_INFO methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

State
	"Answer the receiver's State field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #State)!

State: anObject
	"Set the receiver's State field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #State) put: anObject! !
!HTTP_STATE_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_STATE_INFO categoriesFor: #flags:!**compiled accessors**!public! !
!HTTP_STATE_INFO categoriesFor: #State!**compiled accessors**!public! !
!HTTP_STATE_INFO categoriesFor: #State:!**compiled accessors**!public! !

!HTTP_STATE_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_STATE_INFO structure.

	HTTP_STATE_INFO  compileDefinition

		typedef [uuid(5DC84435-3EB8-42FE-94BF-25F253E612FD), helpstring('The HTTP_STATE_INFO structure is used to enable or disable a Server Session or URL Group.')]
		struct tagHTTP_STATE_INFO {
			HTTP_PROPERTY_FLAGS flags;
			HTTP_ENABLED_STATE State;
		} HTTP_STATE_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #State type: SDWORDField new offset: 4.
	self byteSize: 8! !
!HTTP_STATE_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

