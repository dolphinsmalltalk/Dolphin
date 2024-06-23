"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.Link'
	instanceVariableNames: 'nextLink'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Link guid: (Core.GUID fromString: '{87b4c498-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Link comment: 'Links are records of a reference to another Link, and are used to represent the linked elements of a <LinkedList>.

Link is an abstract base class which should be subclasses to hold objects of the appropriate type.'!

!Core.Link categoriesForClass!Collections-Support! !

!Core.Link methodsFor!

nextLink
	"Answer the next Link in the list after the receiver"

	^nextLink
!

nextLink: aLink
	"Set the next Link referred to by the receiver to a aLink."

	^nextLink := aLink! !

!Core.Link categoriesForMethods!
nextLink!accessing!public! !
nextLink:!accessing!not an aspect!public! !
!

!Core.Link class methodsFor!

nextLink: aLink
	"Answer a new instance of the receiver which refers to aLink as the
	link which succeeds it in a LinkedList"

	<primitive: 157>
	^self new
		nextLink: aLink;
		yourself! !

!Core.Link class categoriesForMethods!
nextLink:!instance creation!public! !
!

