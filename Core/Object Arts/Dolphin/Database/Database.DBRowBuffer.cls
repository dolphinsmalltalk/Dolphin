"Filed out from Dolphin Smalltalk"!

Database.DBAbstractRow
	subclass: #'Database.DBRowBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBRowBuffer guid: (Core.GUID fromString: '{87b4c476-026e-11d3-9fd7-00a0cc3e4a32}')!

Database.DBRowBuffer comment: 'DBRowBuffers are used to describe and buffer the columns of the current row in a <DBResultSet>.'!

!Database.DBRowBuffer categoriesForClass!ODBC Interface! !

!Database.DBRowBuffer methodsFor!

asObject
	"Private - Answer the receiver as an instance of DBRow containing the receiver's values."

	^DBRow fromBuffer: self!

bindColumnsOf: aDBStatement
	"Private - Bind the receiver's field buffers to columns in the result table."

	| hStmt |
	hStmt := aDBStatement executedHandle.
	#todo.	"Will need an array of status values if to fetch a block of rows at a time"
	status := ByteArray newFixed: 2.
	aDBStatement statusArray: status.
	^hStmt!

contents
	"Answer the contents instance variable."

	^contents ifNil: [contents := self getContents]!

getContents
	^columns collect: [:each | self newFieldForColumn: each]!

getData: aDBStatement
	"Private - Copy data from the result table into fields of the receiver."

	self contents do: [:each | each getData: aDBStatement]!

newFieldForColumn: aDBColAttr
	^self subclassResponsibility!

objects
	"Private - Answer the receiver's contents as an <Array> of <Object>s
	representing the value of each column."

	^self contents collect: [:c | c value]!

status
	^status uint16AtOffset: 0! !

!Database.DBRowBuffer categoriesForMethods!
asObject!converting!private! !
bindColumnsOf:!operations!private! !
contents!accessing!public! !
getContents!helpers!private! !
getData:!data retrieval!private! !
newFieldForColumn:!helpers!private! !
objects!accessing!private! !
status!accessing!private! !
!

