"Filed out from Dolphin Smalltalk"!

Object subclass: #Link
	instanceVariableNames: 'nextLink'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Link guid: (GUID fromString: '{87b4c498-026e-11d3-9fd7-00a0cc3e4a32}')!
Link comment: 'Links are records of a reference to another Link, and are used to represent the linked elements of a <LinkedList>.

Link is an abstract base class which should be subclasses to hold objects of the appropriate type.'!
!Link categoriesForClass!Collections-Support! !
!Link methodsFor!

nextLink
	"Answer the next Link in the list after the receiver"

	^nextLink
!

nextLink: aLink
	"Set the next Link referred to by the receiver to a aLink."

	^nextLink := aLink! !
!Link categoriesForMethods!
nextLink!accessing!public! !
nextLink:!accessing!not an aspect!public! !
!

!Link class methodsFor!

nextLink: aLink
	"Answer a new instance of the receiver which refers to aLink as the
	link which succeeds it in a LinkedList"

	<primitive: 157>
	^self new
		nextLink: aLink;
		yourself! !
!Link class categoriesForMethods!
nextLink:!instance creation!public! !
!

