"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_BINDING_W
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_BINDING_W guid: (GUID fromString: '{9CD42842-29B3-4E02-B9DC-306B51F0166D}')!
HTTP_SERVICE_BINDING_W comment: '<HTTP_SERVICE_BINDING_W> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_BINDING_W'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Provides Service Principle Name (SPN) in Unicode."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(9CD42842-29B3-4E02-B9DC-306B51F0166D), helpstring("Provides Service Principle Name (SPN) in Unicode.")]
struct tagHTTP_SERVICE_BINDING_W {
	HTTP_SERVICE_BINDING_BASE Base;
	unsigned short* Buffer;
	unsigned long BufferSize;
} HTTP_SERVICE_BINDING_W;
'!
!HTTP_SERVICE_BINDING_W categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_BINDING_W methodsFor!

Base
	"Answer the receiver's Base field as a Smalltalk object."

	^HTTP_SERVICE_BINDING_BASE fromAddress: bytes yourAddress!

Base: anObject
	"Set the receiver's Base field to the value of anObject."

	anObject
		replaceBytesOf: bytes
		from: 1
		to: ##(HTTP_SERVICE_BINDING_BASE basicByteSize)
		startingAt: 1!

Buffer
	"Answer the receiver's Buffer field as a Smalltalk object."

	^WORD fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Buffer))!

Buffer: anObject
	"Set the receiver's Buffer field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Buffer) put: anObject yourAddress!

BufferSize
	"Answer the receiver's BufferSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #BufferSize)!

BufferSize: anObject
	"Set the receiver's BufferSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #BufferSize) put: anObject! !
!HTTP_SERVICE_BINDING_W categoriesFor: #Base!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_W categoriesFor: #Base:!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_W categoriesFor: #Buffer!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_W categoriesFor: #Buffer:!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_W categoriesFor: #BufferSize!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_W categoriesFor: #BufferSize:!**compiled accessors**!public! !

!HTTP_SERVICE_BINDING_W class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_BINDING_W structure.

	HTTP_SERVICE_BINDING_W  compileDefinition

		typedef [uuid(9CD42842-29B3-4E02-B9DC-306B51F0166D), helpstring('Provides Service Principle Name (SPN) in Unicode.')]
		struct tagHTTP_SERVICE_BINDING_W {
			HTTP_SERVICE_BINDING_BASE Base;
			unsigned short* Buffer;
			unsigned long BufferSize;
		} HTTP_SERVICE_BINDING_W;
"

	self
		defineField: #Base type: (StructureField type: HTTP_SERVICE_BINDING_BASE) offset: 0;
		defineField: #Buffer type: (PointerField type: WORD) offset: 4;
		defineField: #BufferSize type: DWORDField new offset: 8.
	self byteSize: 12! !
!HTTP_SERVICE_BINDING_W class categoriesFor: #defineFields!**auto generated**!initializing!public! !

