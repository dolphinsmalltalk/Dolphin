"Filed out from Dolphin Smalltalk 7"!

LPVOID subclass: #ExternalPointer
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExternalPointer guid: (GUID fromString: '{87b4c5b0-026e-11d3-9fd7-00a0cc3e4a32}')!
ExternalPointer comment: 'ExternalPointer is a class to represent pointers to arbitrary blocks of externally allocated memory where the size of the block is known and can be associated with the pointer.'!
!ExternalPointer categoriesForClass!External-Data-Unstructured! !
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

