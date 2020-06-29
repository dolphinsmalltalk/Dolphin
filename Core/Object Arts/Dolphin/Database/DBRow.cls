"Filed out from Dolphin Smalltalk 7"!

DBAbstractRow subclass: #DBRow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DBRow guid: (GUID fromString: '{fedd9382-e7b2-4030-935f-e688eac94360}')!
DBRow comment: 'A DBRow respresents a snapshot of a row in a <DBResultSet>, the contents of which are appropriate types of Smalltalk object to represent the column values of the row.'!
!DBRow categoriesForClass!Kernel-Objects! !
!DBRow methodsFor!

asObject
	"Private - Answer the receiver as an instance of DBRow containing the receiver's values."

	^self!

initializeFromBuffer: aDBRow
	columns := aDBRow columns.
	selectors := aDBRow selectors.
	contents := aDBRow objects.
	status := aDBRow status.
	^self! !
!DBRow categoriesFor: #asObject!converting!private! !
!DBRow categoriesFor: #initializeFromBuffer:!instance creation!private! !

!DBRow class methodsFor!

fromBuffer: aDBRow
	^super new
		initializeFromBuffer: aDBRow! !
!DBRow class categoriesFor: #fromBuffer:!instance creation!private! !

