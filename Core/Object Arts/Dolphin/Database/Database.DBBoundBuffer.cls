"Filed out from Dolphin Smalltalk 7"!

Database.DBRowBuffer subclass: #'Database.DBBoundBuffer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ODBCConstants} #{OS.ODBCCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBBoundBuffer guid: (Core.GUID fromString: '{87b4c547-026e-11d3-9fd7-00a0cc3e4a32}')!
Database.DBBoundBuffer comment: 'A DBBoundRow represnts a database row buffer that is directly bound to allocated memory for its columns. 

This is the normal type of buffer used by the Database Connection as it is more efficient when multiple rows are fetched.

'!
!Database.DBBoundBuffer categoriesForClass!ODBC Interface! !
!Database.DBBoundBuffer methodsFor!

bind: aDBStatement
	"Private - Bind the receiver's field buffers to columns in the result table."

	| hStmt odbc |
	hStmt := super bind: aDBStatement.
	odbc := OS.ODBCLibrary default.
	self contents do: 
			[:eachField |
			| dataBuffer column |
			column := eachField column.
			dataBuffer := eachField fieldBuf.
			aDBStatement dbCheckException: (odbc
						sqlBindCol: hStmt
						columnNumber: column columnNumber
						targetType: column cType
						targetValuePtr: dataBuffer
						bufferLength: dataBuffer size
						strLenOrInd: eachField lengthBuf)].
	^hStmt!

getData: aDBStatement
	"Private - Not currently relevant to a bound row, though it might be if
	we wanted to use SQLGetData for long values."! !
!Database.DBBoundBuffer categoriesFor: #bind:!operations!private! !
!Database.DBBoundBuffer categoriesFor: #getData:!data retrieval!private! !

