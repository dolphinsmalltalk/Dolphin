"Filed out from Dolphin Smalltalk 7"!

DBRowBuffer subclass: #DBUnboundBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DBUnboundBuffer guid: (GUID fromString: '{87b4c548-026e-11d3-9fd7-00a0cc3e4a32}')!
DBUnboundBuffer comment: 'A DBUnboundRow represents a row buffer that is not statically bound to allocated memory for its columns, but where instead the data is explicitly and individually read into a buffer for each field after the row has been fetched.

'!
!DBUnboundBuffer categoriesForClass!ODBC Interface! !
!DBUnboundBuffer methodsFor!

getData: aDBStatement
	"Private - Copy data from the result table into fields of the receiver."

	self contents do: [:f | f getData: aDBStatement]! !
!DBUnboundBuffer categoriesFor: #getData:!data retrieval!private! !

