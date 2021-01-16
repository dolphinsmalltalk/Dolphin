"Filed out from Dolphin Smalltalk 7"!

Database.DBAbstractRow subclass: #'Database.DBRow'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBRow guid: (Core.GUID fromString: '{fedd9382-e7b2-4030-935f-e688eac94360}')!
Database.DBRow comment: 'A DBRow respresents a snapshot of a row in a <DBResultSet>, the contents of which are appropriate types of Smalltalk object to represent the column values of the row.'!
!Database.DBRow categoriesForClass!Kernel-Objects! !
!Database.DBRow methodsFor!

asObject
	"Private - Answer the receiver as an instance of DBRow containing the receiver's values."

	^self!

initializeFromBuffer: aDBRow
	columns := aDBRow columns.
	selectors := aDBRow selectors.
	contents := aDBRow objects.
	status := aDBRow status.
	^self! !
!Database.DBRow categoriesFor: #asObject!converting!private! !
!Database.DBRow categoriesFor: #initializeFromBuffer:!instance creation!private! !

!Database.DBRow class methodsFor!

fromBuffer: aDBRow
	^super new
		initializeFromBuffer: aDBRow! !
!Database.DBRow class categoriesFor: #fromBuffer:!instance creation!private! !

