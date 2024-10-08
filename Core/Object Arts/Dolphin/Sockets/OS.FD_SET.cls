﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.FD_SET'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_FD_SET_Size' -> 16r104.
			'_OffsetOf_fd_array' -> 16r4.
			'_OffsetOf_fd_count' -> 16r0
		}!

OS.FD_SET guid: (Core.GUID fromString: '{b99a7942-497e-4a39-97ef-9040c83d7829}')!

OS.FD_SET comment: '<FD_SET> is an <ExternalStructure> class to wrap the struct ''WINSOCK2Lib.fd_set'' from type information in the ''Windows Sockets 2 Type Library'' library.

IDL definition follows:

typedef struct tagfd_set {
	unsigned int fd_count;
	unsigned int fd_array[64];
} fd_set;
'!

!OS.FD_SET categoriesForClass!WINSOCK2Lib-Structs! !

!OS.FD_SET methodsFor!

fd_array
	"Answer the <UIntPtrArray> value of the receiver's 'fd_array' field."

	^UIntPtrArray fromAddress: bytes yourAddress + _OffsetOf_fd_array length: 64!

fd_count
	"Answer the <Integer> value of the receiver's 'fd_count' field."

	^bytes uint32AtOffset: _OffsetOf_fd_count!

fd_count: anInteger
	"Set the receiver's 'fd_count' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_fd_count put: anInteger! !

!OS.FD_SET categoriesForMethods!
fd_array!**compiled accessors**!public! !
fd_count!**compiled accessors**!public! !
fd_count:!**compiled accessors**!public! !
!

!OS.FD_SET class methodsFor!

byteSize
	^_FD_SET_Size!

defineFields
	"Define the fields of the fd_set structure.

	FD_SET compileDefinition

		typedef 
		struct tagfd_set {
			unsigned int fd_count;
			[readonly] UINT_PTR fd_array[64];
		} fd_set;
"

	self
		defineField: #fd_count type: UInt32Field new offset: 0;
		defineField: #fd_array type: (ArrayField type: UIntPtrArray length: 64) beReadOnly offset: 4.
	self byteSize: 260!

getFieldNames
	^#(#fd_count #fd_array)! !

!OS.FD_SET class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!private!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

