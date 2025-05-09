﻿"Filed out from Dolphin Smalltalk"!

Database.DBRowBuffer
	subclass: #'Database.DBUnboundBuffer'
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

newFieldForColumn: aDBColAttr
	^DBUnboundField newForCol: aDBColAttr! !

!Database.DBUnboundBuffer categoriesForMethods!
newFieldForColumn:!helpers!private! !
!

