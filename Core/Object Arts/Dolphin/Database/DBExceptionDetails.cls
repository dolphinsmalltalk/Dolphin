"Filed out from Dolphin Smalltalk 7"!

Object subclass: #DBExceptionDetails
	instanceVariableNames: 'errors hEnv hDBC hStmt code'
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCRetCodes'
	classInstanceVariableNames: ''
	classConstants: {}!
DBExceptionDetails guid: (GUID fromString: '{87b4c474-026e-11d3-9fd7-00a0cc3e4a32}')!
DBExceptionDetails comment: 'An instance of DBExceptionDetails holds information about the state of a DB connection object when a DBError or DBWarning is signalled. It is available by sending #tag to the exception object. 

Instance Variables:
	errors		<Array> of <DBErrorDetails>. List of errors
	hEnv		<ExternalHandle>. ODBC environment handle.
	hDBC		<ExternalHandle>. ODBC database connection handle.
	hStmt		<ExternalHandle>. ODBC statement handl.
	code		<integer>. The SQL function error or warning code

Depending on the activity in progress at the time of the exception, one or more of these may contain nil.

'!
!DBExceptionDetails categoriesForClass!ODBC Interface! !
!DBExceptionDetails methodsFor!

addErrorDetails: newErrorDetails
	"Private - Add a new error details object to my collection."

	errors isNil ifTrue: [self errors: OrderedCollection new].
	errors addLast: newErrorDetails.!

buildErrorInfo
	"Private - Retrieve all error information available from the ODBC Driver
	 for my handles, unless none is found in which case
	 a 'reduced' error is created using the return code from function
	 which caused the error"

	(code ~~ SQL_SUCCESS and: [code ~~ SQL_INVALID_HANDLE]) ifTrue:
			[hEnv isNull ifFalse: [self buildErrorInfoFrom: hEnv type: SQL_HANDLE_ENV].
			hDBC isNull ifFalse: [self buildErrorInfoFrom: hDBC type: SQL_HANDLE_DBC].
			hStmt isNull ifFalse: [self buildErrorInfoFrom: hStmt type: SQL_HANDLE_STMT]].
	errors isNil ifTrue: [self retCodeError: code].!

buildErrorInfoFrom: anExternalHandle type: anIntegerHandleType
	"Private - Retrieve all error information available from the ODBC Driver for <anExternalHandle>, which is of type <anIntegerHandleType>"

	| szSqlState fNativeError szErrorMsg cbErrorMsg recNumber odbc |
	szSqlState := Utf16String newFixed: SQL_SQLSTATE_SIZE.
	szErrorMsg := Utf16String new: 128.
	cbErrorMsg := SWORD new.
	fNativeError := SDWORD new.
	recNumber := 1.
	odbc := ODBCLibrary default.
	
	[| ret |
	
	[ret := odbc
				sqlGetDiagRec: anIntegerHandleType
				handle: anExternalHandle
				recNumber: recNumber
				szSqlState: szSqlState
				pfNativeError: fNativeError
				szErrorMsg: szErrorMsg
				cbErrorMsgMax: szErrorMsg size + 1
				pcbErrorMsg: cbErrorMsg.
	ret == SQL_SUCCESS_WITH_INFO]
			whileTrue: 
				["Try again with a larger buffer"
				szErrorMsg := Utf16String new: cbErrorMsg value].
	ret == SQL_SUCCESS]
			whileTrue: 
				[| newErr |
				newErr := DBErrorDetails fromSQLError: (szErrorMsg copyFrom: 1 to: cbErrorMsg asInteger).
				newErr
					nativeErr: fNativeError asInteger;
					sqlState: (szSqlState copyFrom: 1 to: 5).
				self addErrorDetails: newErr.
				recNumber := recNumber + 1]!

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

	self errors 
		do: [ :e | aStream print: e messageText]
		separatedBy: [aStream space]
!

retCodeError: anInteger
	"Private - Add to our collection, a new error whose code is anIteger."

	self addErrorDetails: (
	        DBErrorDetails new
			msg: ('SQL Error: ',
					(ODBCRetCodes keyAtValue: code
				                ifAbsent: ['Unknown']));
			yourself)! !
!DBExceptionDetails categoriesFor: #addErrorDetails:!operations!private! !
!DBExceptionDetails categoriesFor: #buildErrorInfo!operations!private! !
!DBExceptionDetails categoriesFor: #buildErrorInfoFrom:type:!operations!private! !
!DBExceptionDetails categoriesFor: #code!accessing!public! !
!DBExceptionDetails categoriesFor: #code:!accessing!private! !
!DBExceptionDetails categoriesFor: #errors!accessing!public! !
!DBExceptionDetails categoriesFor: #errors:!accessing!private! !
!DBExceptionDetails categoriesFor: #hDBC!accessing!public! !
!DBExceptionDetails categoriesFor: #hDBC:!accessing!private! !
!DBExceptionDetails categoriesFor: #hEnv!accessing!public! !
!DBExceptionDetails categoriesFor: #hEnv:!accessing!private! !
!DBExceptionDetails categoriesFor: #hStmt!accessing!public! !
!DBExceptionDetails categoriesFor: #hStmt:!accessing!private! !
!DBExceptionDetails categoriesFor: #printOn:!printing!public! !
!DBExceptionDetails categoriesFor: #retCodeError:!accessing!private! !

