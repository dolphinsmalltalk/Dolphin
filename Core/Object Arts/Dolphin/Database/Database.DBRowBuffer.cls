"Filed out from Dolphin Smalltalk 7"!

DBAbstractRow subclass: #DBRowBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
	status := WORD new.
	aDBStatement statusArray: status.
	^hStmt!

contents
	"Answer the contents instance variable."

	contents isNil
		ifTrue: [contents := columns collect: [:colAttr | DBField newForCol: colAttr]].
	^contents.!

objects
	"Private - Answer the receivers contents as an <Array> of <Object>s
	representing the value of each column."

	^self contents collect: [:c | c value]!

sizeInBytes
	"Answer the size of the receiver structure in bytes."

	 ^self contents inject: 0 into: [ :size :f | size + f size ].!

status
	^status value! !
!DBRowBuffer categoriesFor: #asObject!converting!private! !
!DBRowBuffer categoriesFor: #bind:!operations!private! !
!DBRowBuffer categoriesFor: #contents!accessing!public! !
!DBRowBuffer categoriesFor: #objects!accessing!private! !
!DBRowBuffer categoriesFor: #sizeInBytes!accessing!public! !
!DBRowBuffer categoriesFor: #status!accessing!private! !

