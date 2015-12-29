"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #FD_SET
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FD_SET guid: (GUID fromString: '{B99A7942-497E-4A39-97EF-9040C83D7829}')!
FD_SET comment: '<FD_SET> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.fd_set'' from type information in the ''Windows Sockets 2 Type Library'' library.

IDL definition follows:

typedef struct tagfd_set {
	unsigned int fd_count;
	unsigned int fd_array[64];
} fd_set;
'!
!FD_SET categoriesForClass!WINSOCK2Lib-Structs! !
!FD_SET methodsFor!

fd_array
	"Answer the receiver's fd_array field as a Smalltalk object."

	^DWORDArray fromAddress: (bytes yourAddress + 4) length: 64!

fd_count
	"Answer the receiver's fd_count field as a Smalltalk object."

	^(bytes dwordAtOffset: 0)!

fd_count: anObject
	"Set the receiver's fd_count field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject! !
!FD_SET categoriesFor: #fd_array!**compiled accessors**!public! !
!FD_SET categoriesFor: #fd_count!**compiled accessors**!public! !
!FD_SET categoriesFor: #fd_count:!**compiled accessors**!public! !

!FD_SET class methodsFor!

defineFields
	"Define the fields of the fd_set structure.
		FD_SET compileDefinition
	
		typedef 		struct tagfd_set {
			unsigned int fd_count;
			unsigned int fd_array[64];
		} fd_set;
"

	self
		defineField: #fd_count type: DWORDField new;
		defineField: #fd_array type: (ArrayField type: DWORDArray length: 64) beReadOnly! !
!FD_SET class categoriesFor: #defineFields!**auto generated**!initializing!public! !

