"Filed out from Dolphin Smalltalk 7"!

Database.DBRowBuffer subclass: #'Database.DBUnboundBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBUnboundBuffer guid: (Core.GUID fromString: '{87b4c548-026e-11d3-9fd7-00a0cc3e4a32}')!
Database.DBUnboundBuffer comment: 'A DBUnboundRow represents a row buffer that is not statically bound to allocated memory for its columns, but where instead the data is explicitly and individually read into a buffer for each field after the row has been fetched.

'!
!Database.DBUnboundBuffer categoriesForClass!ODBC Interface! !
!Database.DBUnboundBuffer methodsFor!

getData: aDBStatement
	"Private - Copy data from the result table into fields of the receiver."

	self contents do: [:f | f getData: aDBStatement]! !
!Database.DBUnboundBuffer categoriesFor: #getData:!data retrieval!private! !

