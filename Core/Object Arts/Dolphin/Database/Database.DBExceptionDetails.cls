"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Database.DBExceptionDetails'
	instanceVariableNames: 'code hEnv hDBC hStmt errors'
	classVariableNames: ''
	imports: #(#{OS.ODBCRetCodes} #{OS.ODBCConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBExceptionDetails guid: (Core.GUID fromString: '{87b4c474-026e-11d3-9fd7-00a0cc3e4a32}')!

Database.DBExceptionDetails comment: 'An instance of DBExceptionDetails holds information about the state of a DB connection object when a DBError or DBWarning is signalled. It is available by sending #tag to the exception object. 

Instance Variables:
	errors		<Array> of <DBErrorDetails>. List of errors
	hEnv		<ExternalHandle>. ODBC environment handle.
	hDBC		<ExternalHandle>. ODBC database connection handle.
	hStmt		<ExternalHandle>. ODBC statement handl.
	code		<integer>. The SQL function error or warning code

Depending on the activity in progress at the time of the exception, one or more of these may contain nil.

'!

!Database.DBExceptionDetails categoriesForClass!ODBC Interface! !

!Database.DBExceptionDetails methodsFor!

buildErrorInfo
	"Private - Retrieve all error information available from the ODBC Driver for my handles, unless none is found in which case a 'reduced' error is created using the return code from function which caused the error"

	errors := DBErrorDetailsBuilder buildErrorDetailsFor: self!

code
	"Answer the code instance variable."

	^code!

code: anInteger
	"Private - Set the instance variable code to anInteger."

	code := anInteger!

errors
	"Answer the errors instance variable."

	^errors!

errors: anOrderedCollection
	"Private - Set the errors instance variable to anOrderedCollection."

	errors := anOrderedCollection!

hDBC
	"Answer the hDBC instance variable."

	^hDBC!

hDBC: anExternalHandle
	"Private - Set the instance variable hDBC to anExternalHandle."

	hDBC := anExternalHandle!

hEnv
	"Answer the hEnv instance variable."

	^hEnv!

hEnv: anExternalHandle
	"Private - Set the instance variable hEnv to anExternalHandle."

	hEnv := anExternalHandle!

hStmt
	"Answer the hStmt instance variable."

	^hStmt!

hStmt: anExternalHandle
	"Private - Set the instance variable hStmt to anExternalHandle."

	hStmt := anExternalHandle!

printOn: aStream
	"Print an textual representation of the receiver to aStream"

	errors ifNil: [^self].
	errors 
		do: [ :e | aStream print: e messageText]
		separatedBy: [aStream space]
! !

!Database.DBExceptionDetails categoriesForMethods!
buildErrorInfo!initializing!private! !
code!accessing!public! !
code:!accessing!private! !
errors!accessing!public! !
errors:!accessing!private! !
hDBC!accessing!public! !
hDBC:!accessing!private! !
hEnv!accessing!public! !
hEnv:!accessing!private! !
hStmt!accessing!public! !
hStmt:!accessing!private! !
printOn:!printing!public! !
!

!Database.DBExceptionDetails class methodsFor!

code: anInteger hEnv: anExternalHandle
	<primitive: 157>
	^self new
		code: anInteger;
		hEnv: anExternalHandle;
		yourself! !

!Database.DBExceptionDetails class categoriesForMethods!
code:hEnv:!instance creation!public! !
!

