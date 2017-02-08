"Filed out from Dolphin Smalltalk 7"!

SOCKADDR subclass: #SOCKADDR_STORAGE
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

ss_family
	"Answer the receiver's ss_family field as a Smalltalk object."

	^bytes wordAtOffset: 0!

ss_family: anObject
	"Set the receiver's ss_family field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!SOCKADDR_STORAGE categoriesFor: #ss_family!**compiled accessors**!public! !
!SOCKADDR_STORAGE categoriesFor: #ss_family:!**compiled accessors**!public! !

!SOCKADDR_STORAGE class methodsFor!

defineFields
	"Define the fields of the SOCKADDR_STORAGE structure.

	SOCKADDR_STORAGE  compileDefinition

		typedef [uuid(FF1980C9-D114-4E61-8569-E2ED5321209B), helpstring('A generic structure that specifies a transport address')]
		struct tagSOCKADDR_STORAGE {
			unsigned short ss_family;
			CHAR __ss_pad1[6];
			__int64 __ss_align;
			CHAR __ss_pad2[112];
		} SOCKADDR_STORAGE;
"

	self
		defineField: #ss_family
		type: WORDField new
		offset: 0.
	self byteSize: 128! !
!SOCKADDR_STORAGE class categoriesFor: #defineFields!initializing!public! !

