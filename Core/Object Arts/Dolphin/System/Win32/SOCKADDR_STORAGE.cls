"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #SOCKADDR_STORAGE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SOCKADDR_STORAGE guid: (GUID fromString: '{FF1980C9-D114-4E61-8569-E2ED5321209B}')!
SOCKADDR_STORAGE comment: '<SOCKADDR_STORAGE> is an <ExternalStructure> class to wrap the struct ''Win32.SOCKADDR_STORAGE'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(FF1980C9-D114-4E61-8569-E2ED5321209B)]
struct tagSOCKADDR_STORAGE {
	unsigned short ss_family;
	CHAR __ss_pad1[6];
	__int64 __ss_align;
	CHAR __ss_pad2[112];
} SOCKADDR_STORAGE;
'!
!SOCKADDR_STORAGE categoriesForClass!Win32-Structs! !
!SOCKADDR_STORAGE methodsFor!

__ss_align
	"Answer the receiver's __ss_align field as a Smalltalk object."

	^bytes sqwordAtOffset: ##(self offsetOf: #__ss_align)!

__ss_align: anObject
	"Set the receiver's __ss_align field to the value of anObject."

	bytes sqwordAtOffset: ##(self offsetOf: #__ss_align) put: anObject!

__ss_pad1
	"Answer the receiver's __ss_pad1 field as a Smalltalk object."

	^ByteArray fromAddress: bytes yourAddress + ##(self offsetOf: #__ss_pad1) length: 6!

__ss_pad1: anObject
	"Set the receiver's __ss_pad1 field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(6 * ByteArray elementSize).
	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #__ss_pad1) + 1)
		to: ##(self offsetOf: #__ss_pad1) + size
		startingAt: 1!

__ss_pad2
	"Answer the receiver's __ss_pad2 field as a Smalltalk object."

	^ByteArray fromAddress: bytes yourAddress + ##(self offsetOf: #__ss_pad2) length: 112!

__ss_pad2: anObject
	"Set the receiver's __ss_pad2 field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(112 * ByteArray elementSize).
	anObject
		replaceBytesOf: bytes
		from: ##((self offsetOf: #__ss_pad2) + 1)
		to: ##(self offsetOf: #__ss_pad2) + size
		startingAt: 1!

ss_family
	"Answer the receiver's ss_family field as a Smalltalk object."

	^bytes wordAtOffset: 0!

ss_family: anObject
	"Set the receiver's ss_family field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!SOCKADDR_STORAGE categoriesFor: #__ss_align!**compiled accessors**!public! !
!SOCKADDR_STORAGE categoriesFor: #__ss_align:!**compiled accessors**!public! !
!SOCKADDR_STORAGE categoriesFor: #__ss_pad1!**compiled accessors**!public! !
!SOCKADDR_STORAGE categoriesFor: #__ss_pad1:!**compiled accessors**!public! !
!SOCKADDR_STORAGE categoriesFor: #__ss_pad2!**compiled accessors**!public! !
!SOCKADDR_STORAGE categoriesFor: #__ss_pad2:!**compiled accessors**!public! !
!SOCKADDR_STORAGE categoriesFor: #ss_family!**compiled accessors**!public! !
!SOCKADDR_STORAGE categoriesFor: #ss_family:!**compiled accessors**!public! !

!SOCKADDR_STORAGE class methodsFor!

defineFields
	"Define the fields of the SOCKADDR_STORAGE structure.

	SOCKADDR_STORAGE  compileDefinition

		typedef [uuid(FF1980C9-D114-4E61-8569-E2ED5321209B)]
		struct tagSOCKADDR_STORAGE {
			unsigned short ss_family;
			CHAR __ss_pad1[6];
			__int64 __ss_align;
			CHAR __ss_pad2[112];
		} SOCKADDR_STORAGE;
"

	self
		defineField: #ss_family type: WORDField new offset: 0;
		defineField: #__ss_pad1 type: (ArrayField type: ByteArray length: 6) offset: 2;
		defineField: #__ss_align type: SQWORDField new offset: 8;
		defineField: #__ss_pad2 type: (ArrayField type: ByteArray length: 112) offset: 16.
	self byteSize: 128! !
!SOCKADDR_STORAGE class categoriesFor: #defineFields!**auto generated**!initializing!public! !

