"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #HTTP_SERVICE_BINDING_A
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_SERVICE_BINDING_A guid: (GUID fromString: '{88CA7833-A66A-4E2F-98BC-CD2313254B15}')!
HTTP_SERVICE_BINDING_A comment: '<HTTP_SERVICE_BINDING_A> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_SERVICE_BINDING_A'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"Provides Service Principle Name (SPN) in ASCII."

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(88CA7833-A66A-4E2F-98BC-CD2313254B15), helpstring("Provides Service Principle Name (SPN) in ASCII.")]
struct tagHTTP_SERVICE_BINDING_A {
	HTTP_SERVICE_BINDING_BASE Base;
	CHAR* Buffer;
	unsigned long BufferSize;
} HTTP_SERVICE_BINDING_A;
'!
!HTTP_SERVICE_BINDING_A categoriesForClass!Win32-Structs! !
!HTTP_SERVICE_BINDING_A methodsFor!

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

	^SBYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #Buffer))!

Buffer: anObject
	"Set the receiver's Buffer field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #Buffer) put: anObject yourAddress!

BufferSize
	"Answer the receiver's BufferSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #BufferSize)!

BufferSize: anObject
	"Set the receiver's BufferSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #BufferSize) put: anObject! !
!HTTP_SERVICE_BINDING_A categoriesFor: #Base!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_A categoriesFor: #Base:!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_A categoriesFor: #Buffer!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_A categoriesFor: #Buffer:!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_A categoriesFor: #BufferSize!**compiled accessors**!public! !
!HTTP_SERVICE_BINDING_A categoriesFor: #BufferSize:!**compiled accessors**!public! !

!HTTP_SERVICE_BINDING_A class methodsFor!

defineFields
	"Define the fields of the HTTP_SERVICE_BINDING_A structure.

	HTTP_SERVICE_BINDING_A  compileDefinition

		typedef [uuid(88CA7833-A66A-4E2F-98BC-CD2313254B15), helpstring('Provides Service Principle Name (SPN) in ASCII.')]
		struct tagHTTP_SERVICE_BINDING_A {
			HTTP_SERVICE_BINDING_BASE Base;
			CHAR* Buffer;
			unsigned long BufferSize;
		} HTTP_SERVICE_BINDING_A;
"

	self
		defineField: #Base type: (StructureField type: HTTP_SERVICE_BINDING_BASE) offset: 0;
		defineField: #Buffer type: (PointerField type: SBYTE) offset: 4;
		defineField: #BufferSize type: DWORDField new offset: 8.
	self byteSize: 12! !
!HTTP_SERVICE_BINDING_A class categoriesFor: #defineFields!**auto generated**!initializing!public! !

