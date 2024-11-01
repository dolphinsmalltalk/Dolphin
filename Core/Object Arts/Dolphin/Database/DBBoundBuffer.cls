"Filed out from Dolphin Smalltalk"!

DBRowBuffer subclass: #DBBoundBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCCTypes'
	classInstanceVariableNames: ''!

DBBoundBuffer guid: (GUID fromString: '{87b4c547-026e-11d3-9fd7-00a0cc3e4a32}')!

DBBoundBuffer comment: 'A `DBBoundBuffer` represents a database row buffer that is, as far as possible, directly bound to allocated memory for its columns. Any var(max) columns are unbound, however, since clearly we cannot allocate a 2Gb buffer for these in advance.

This is the normal type of buffer used by the Database Connection as it is more efficient when multiple rows are fetched.

'!

!DBBoundBuffer categoriesForClass!ODBC Interface! !

!DBBoundBuffer methodsFor!

bind: aDBStatement
	"Private - Bind the receiver's field buffers to columns in the result table."

	| hStmt |
	hStmt := super bind: aDBStatement.
	self contents do: [:eachField | eachField bind: aDBStatement].
	^hStmt!

newFieldForCol: aDBColAttr
	^aDBColAttr newBoundField! !

!DBBoundBuffer categoriesForMethods!
bind:!operations!private! !
newFieldForCol:!helpers!private! !
!

