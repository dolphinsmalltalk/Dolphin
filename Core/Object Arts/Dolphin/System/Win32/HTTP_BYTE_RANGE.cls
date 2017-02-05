"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_BYTE_RANGE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_BYTE_RANGE guid: (GUID fromString: '{3426318C-022F-4DD9-9E4E-A04FEBF70A10}')!
HTTP_BYTE_RANGE comment: '<HTTP_BYTE_RANGE> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_BYTE_RANGE'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"This structure defines a file byte range. If the Length field is HTTP_BYTE_RANGE_TO_EOF then the remainder of the file (everything after StartingOffset) is sent."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(3426318C-022F-4DD9-9E4E-A04FEBF70A10), helpstring("This structure defines a file byte range. If the Length field is HTTP_BYTE_RANGE_TO_EOF then the remainder of the file (everything after StartingOffset) is sent.")]
struct tagHTTP_BYTE_RANGE {
	ULARGE_INTEGER StartingOffset;
	ULARGE_INTEGER Length;
} HTTP_BYTE_RANGE;
'!
!HTTP_BYTE_RANGE categoriesForClass!Win32-Structs! !
!HTTP_BYTE_RANGE methodsFor!

Length
	"Answer the receiver's Length field as a Smalltalk object."

	^bytes qwordAtOffset: ##(self offsetOf: #Length)!

Length: anObject
	"Set the receiver's Length field to the value of anObject."

	bytes qwordAtOffset: ##(self offsetOf: #Length) put: anObject!

StartingOffset
	"Answer the receiver's StartingOffset field as a Smalltalk object."

	^bytes qwordAtOffset: 0!

StartingOffset: anObject
	"Set the receiver's StartingOffset field to the value of anObject."

	bytes qwordAtOffset: 0 put: anObject! !
!HTTP_BYTE_RANGE categoriesFor: #Length!**compiled accessors**!public! !
!HTTP_BYTE_RANGE categoriesFor: #Length:!**compiled accessors**!public! !
!HTTP_BYTE_RANGE categoriesFor: #StartingOffset!**compiled accessors**!public! !
!HTTP_BYTE_RANGE categoriesFor: #StartingOffset:!**compiled accessors**!public! !

!HTTP_BYTE_RANGE class methodsFor!

defineFields
	"Define the fields of the HTTP_BYTE_RANGE structure.

	HTTP_BYTE_RANGE  compileDefinition

		typedef [uuid(3426318C-022F-4DD9-9E4E-A04FEBF70A10), helpstring('This structure defines a file byte range. If the Length field is HTTP_BYTE_RANGE_TO_EOF then the remainder of the file (everything after StartingOffset) is sent.')]
		struct tagHTTP_BYTE_RANGE {
			ULARGE_INTEGER StartingOffset;
			ULARGE_INTEGER Length;
		} HTTP_BYTE_RANGE;
"

	self
		defineField: #StartingOffset type: QWORDField new offset: 0;
		defineField: #Length type: QWORDField new offset: 8.
	self byteSize: 16! !
!HTTP_BYTE_RANGE class categoriesFor: #defineFields!**auto generated**!initializing!public! !

