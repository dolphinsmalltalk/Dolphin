"Filed out from Dolphin Smalltalk 7"!

Database.DBAbstractStatement subclass: #'Database.DBStatement'
	instanceVariableNames: 'sqlString'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.DBStatement guid: (Core.GUID fromString: '{87b4c477-026e-11d3-9fd7-00a0cc3e4a32}')!
Database.DBStatement comment: 'A DBStatement is used to represent an SQL statement to be executed by a <DBConnection>.

In general one does not DBStatements explicitly but rather by the use of DBConnection>>exec: and DBConnection>>query:. For pre-prepared statements DBConnection>>prepare: can be used to answer an instance of <DBParameterizedStatement> which can later be parameterized and executed.

Instance Variables:
	sqlString		<String>. The SQL statement.'!
!Database.DBStatement categoriesForClass!ODBC Interface! !
!Database.DBStatement methodsFor!

defaultCursorType
	"Answer the <Symbol>ic name of the default cursor type to be used for statements
	(one of #dynamic, #forwardOnly, #keysetDriven, #static).
	Implementation Note: For backwards compatibility use a #keysetDriven cursor 
	by default."

	^#keysetDriven
!

exec: aString
	"Execute the SQL statement aString using the receiver"

	self sqlString: aString; exec!

executeStatement
	^OS.ODBCLibrary default 
		sqlExecDirect: self allocatedHandle
		statementText: self sqlString
		textLength: SQL_NTS!

printOn: aStream
	"Print a string representation of self onto aStream"

	aStream 
		basicPrint: self; 
		nextPut: $(;
		print: self sqlString;
		nextPut: $).!

sqlString
	"Answer the sqlString instance variable."

	^sqlString!

sqlString: aString
	"Private - Set the sqlString instance variable to aString.
	N.B. Changing the SQL string after executing the statement (either directly
	or lazily by examing the result set) has no effect."

	sqlString := aString! !
!Database.DBStatement categoriesFor: #defaultCursorType!constants!public! !
!Database.DBStatement categoriesFor: #exec:!operations!public! !
!Database.DBStatement categoriesFor: #executeStatement!operations!private! !
!Database.DBStatement categoriesFor: #printOn:!printing!public! !
!Database.DBStatement categoriesFor: #sqlString!accessing!public! !
!Database.DBStatement categoriesFor: #sqlString:!accessing!private! !

