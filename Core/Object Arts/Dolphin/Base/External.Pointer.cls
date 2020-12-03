"Filed out from Dolphin Smalltalk 7"!

External.LPVOID subclass: #'External.Pointer'
	instanceVariableNames: 'byteSize'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Pointer guid: (Core.GUID fromString: '{87b4c5b0-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Pointer comment: 'ExternalPointer is a class to represent pointers to arbitrary blocks of externally allocated memory where the size of the block is known and can be associated with the pointer.'!
!External.Pointer categoriesForClass!External-Data-Unstructured! !
!External.Pointer methodsFor!

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
!External.Pointer categoriesFor: #byteSize!accessing!public! !
!External.Pointer categoriesFor: #byteSize:!accessing!public! !
!External.Pointer categoriesFor: #initialize:!initializing!public! !
!External.Pointer categoriesFor: #size!accessing!public! !

