"Filed out from Dolphin Smalltalk"!

DBAbstractRow subclass: #DBRowBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBRowBuffer guid: (GUID fromString: '{87b4c476-026e-11d3-9fd7-00a0cc3e4a32}')!

DBRowBuffer comment: 'DBRowBuffers are used to describe and buffer the columns of the current row in a <DBResultSet>.'!

!DBRowBuffer categoriesForClass!ODBC Interface! !

!DBRowBuffer methodsFor!

asObject
	"Private - Answer the receiver as an instance of DBRow containing the receiver's values."

	^DBRow fromBuffer: self!

bind: aDBStatement 
	"Private - Bind the receiver's field buffers to columns in the result table."

	| hStmt |
	hStmt := aDBStatement executedHandle.
	#todo "Will need an array of status values if to fetch a block of rows at a time".
	status := ByteArray newFixed: 2.
	aDBStatement statusArray: status.
	^hStmt!

contents
	"Answer the contents instance variable."

	^contents ifNil: [contents := self getContents]!

getContents
	^columns collect: [:each | self newFieldForCol: each]!

getData: aDBStatement
	"Private - Copy data from the result table into fields of the receiver."

	self contents do: [:each | each getData: aDBStatement]!

newFieldForCol: aDBColAttr
	^self subclassResponsibility!

objects
	"Private - Answer the receivers contents as an <Array> of <Object>s
	representing the value of each column."

	^self contents collect: [:c | c value]!

status
	^status wordAtOffset: 0! !

!DBRowBuffer categoriesForMethods!
asObject!converting!private! !
bind:!operations!private! !
contents!accessing!public! !
getContents!helpers!private! !
getData:!data retrieval!private! !
newFieldForCol:!helpers!private! !
objects!accessing!private! !
status!accessing!private! !
!

