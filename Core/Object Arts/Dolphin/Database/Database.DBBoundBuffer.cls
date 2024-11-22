"Filed out from Dolphin Smalltalk"!

Database.DBRowBuffer
	subclass: #'Database.DBBoundBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ODBCConstants} #{OS.ODBCCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBBoundBuffer guid: (Core.GUID fromString: '{87b4c547-026e-11d3-9fd7-00a0cc3e4a32}')!

Database.DBBoundBuffer comment: 'A `DBBoundBuffer` represents a database row buffer that is, as far as possible, directly bound to allocated memory for its columns. Any var(max) columns are unbound, however, since clearly we cannot allocate a 2Gb buffer for these in advance.

This is the normal type of buffer used by the Database Connection as it is more efficient when multiple rows are fetched.

'!

!Database.DBBoundBuffer categoriesForClass!ODBC Interface! !

!Database.DBBoundBuffer methodsFor!

bind: aDBStatement
	"Private - Bind the receiver's field buffers to columns in the result table."

	| hStmt |
	hStmt := super bind: aDBStatement.
	self contents do: [:eachField | eachField bind: aDBStatement].
	^hStmt!

newFieldForColumn: aDBColAttr
	^aDBColAttr newBoundField! !

!Database.DBBoundBuffer categoriesForMethods!
bind:!operations!private! !
newFieldForColumn:!helpers!private! !
!

