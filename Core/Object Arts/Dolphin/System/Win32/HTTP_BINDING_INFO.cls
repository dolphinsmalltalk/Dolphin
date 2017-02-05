"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_BINDING_INFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_BINDING_INFO guid: (GUID fromString: '{B253697C-F239-4FB6-B474-B35DB2C4848F}')!
HTTP_BINDING_INFO comment: '<HTTP_BINDING_INFO> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_BINDING_INFO'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Binding information."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(B253697C-F239-4FB6-B474-B35DB2C4848F), helpstring("Binding information.")]
struct tagHTTP_BINDING_INFO {
	HTTP_PROPERTY_FLAGS flags;
	HANDLE RequestQueueHandle;
} HTTP_BINDING_INFO;
'!
!HTTP_BINDING_INFO categoriesForClass!Win32-Structs! !
!HTTP_BINDING_INFO methodsFor!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

flags: anObject
	"Private - Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

RequestQueueHandle
	"Answer the receiver's RequestQueueHandle field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #RequestQueueHandle)) asExternalHandle!

requestQueueHandle: anExternalHandle
	self flags: (anExternalHandle isNil ifTrue: [0] ifFalse: [1]).
	self RequestQueueHandle: anExternalHandle!

RequestQueueHandle: anObject
	"Private - Set the receiver's RequestQueueHandle field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #RequestQueueHandle) put: anObject! !
!HTTP_BINDING_INFO categoriesFor: #flags!**compiled accessors**!public! !
!HTTP_BINDING_INFO categoriesFor: #flags:!**compiled accessors**!private! !
!HTTP_BINDING_INFO categoriesFor: #RequestQueueHandle!**compiled accessors**!public! !
!HTTP_BINDING_INFO categoriesFor: #requestQueueHandle:!accessing!public! !
!HTTP_BINDING_INFO categoriesFor: #RequestQueueHandle:!**compiled accessors**!private! !

!HTTP_BINDING_INFO class methodsFor!

defineFields
	"Define the fields of the HTTP_BINDING_INFO structure.

	HTTP_BINDING_INFO  compileDefinition

		typedef [uuid(B253697C-F239-4FB6-B474-B35DB2C4848F), helpstring('Binding information.')]
		struct tagHTTP_BINDING_INFO {
			HTTP_PROPERTY_FLAGS flags;
			HANDLE RequestQueueHandle;
		} HTTP_BINDING_INFO;
"

	self
		defineField: #flags type: DWORDField new offset: 0;
		defineField: #RequestQueueHandle type: HANDLEField new offset: 4.
	self byteSize: 8! !
!HTTP_BINDING_INFO class categoriesFor: #defineFields!**auto generated**!initializing!public! !

