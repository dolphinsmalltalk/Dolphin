"Filed out from Dolphin Smalltalk X6"!

LPVOID subclass: #ExternalPointer
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalPointer guid: (GUID fromString: '{87B4C5B0-026E-11D3-9FD7-00A0CC3E4A32}')!
ExternalPointer comment: 'ExternalPointer is a class to represent pointers to arbitrary blocks of externally allocated memory where the size of the block is known and can be associated with the pointer.'!
!ExternalPointer categoriesForClass!External-Data-Structured! !
!ExternalPointer methodsFor!

byteSize
	"Answer the size of the memory block at which the receiver is pointing."

	^byteSize
	!

byteSize: anInteger
	"Record the size of the memory block at which the receiver is pointing."

	byteSize := anInteger
	!

initialize: anInteger
	"Initialize the receiver to be a pointer to the specified size of memory block."

	super initialize: anInteger.
	byteSize := anInteger!

size
	"Answer the size of the memory block at which the receiver is pointing."

	^byteSize
	! !
!ExternalPointer categoriesFor: #byteSize!accessing!public! !
!ExternalPointer categoriesFor: #byteSize:!accessing!public! !
!ExternalPointer categoriesFor: #initialize:!initializing!public! !
!ExternalPointer categoriesFor: #size!accessing!public! !

