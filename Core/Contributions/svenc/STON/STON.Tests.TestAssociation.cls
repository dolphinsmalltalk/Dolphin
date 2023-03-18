"Filed out from Dolphin Smalltalk"!

Core.Association
	subclass: #'STON.Tests.TestAssociation'
	instanceVariableNames: 'timestamp'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.TestAssociation guid: (Core.GUID fromString: '{d412d7d7-3654-4d31-9ebf-dbbe2a26135a}')!
STON.Tests.TestAssociation comment: 'STONTestAssociation is used to support unit tests.
'!
!STON.Tests.TestAssociation categoriesForClass!STON-Tests-Base! !
!STON.Tests.TestAssociation methodsFor!

key: aKey value: anObject 
	super key: aKey value: anObject.
	timestamp := self now.
	^self!

now
	^DateAndTime now!

timestamp
	^ timestamp!

value: anObject
	super value: anObject.
	timestamp := self now! !
!STON.Tests.TestAssociation categoriesForMethods!
key:value:!accessing!public! !
now!accessing!public! !
timestamp!accessing!public! !
value:!accessing!public! !
!

