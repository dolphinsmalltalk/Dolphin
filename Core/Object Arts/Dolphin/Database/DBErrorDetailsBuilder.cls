"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #DBErrorDetailsBuilder
	instanceVariableNames: 'errors szSqlState szErrorMsg cbErrorMsg fNativeError'
	classVariableNames: ''
	imports: #(#{OS.ODBCConstants} #{OS.ODBCRetCodes})
	classInstanceVariableNames: ''
	classConstants: {}!

DBErrorDetailsBuilder guid: (Core.GUID fromString: '{fe3c3c6b-84ce-4773-aa45-c9eb7b8f734d}')!

DBErrorDetailsBuilder comment: ''!

!DBErrorDetailsBuilder categoriesForClass!Kernel-Objects! !

!DBErrorDetailsBuilder methodsFor!

buildErrorDetailsFor: aDBExceptionDetails
	"Private - Retrieve all error information available from the ODBC Driver for the handles of aDBExceptionDetails, unless none is found in which case a 'reduced' error is created using the return code from function which caused the error"

	| code |
	errors := Array writeStream: 1.
	code := aDBExceptionDetails code.
	(code ~~ SQL_SUCCESS and: [code ~~ SQL_INVALID_HANDLE])
		ifTrue: 
			[| handle |
			szSqlState := Utf16String newFixed: SQL_SQLSTATE_SIZE.
			szErrorMsg := Utf16String newFixed: 128.
			cbErrorMsg := ByteArray newFixed: 2.
			fNativeError := ByteArray newFixed: 4.
			handle := aDBExceptionDetails hEnv.
			handle isNull ifFalse: [self buildErrorInfoFrom: handle type: SQL_HANDLE_ENV].
			handle := aDBExceptionDetails hDBC.
			handle isNull ifFalse: [self buildErrorInfoFrom: handle type: SQL_HANDLE_DBC].
			handle := aDBExceptionDetails hStmt.
			handle isNull ifFalse: [self buildErrorInfoFrom: handle type: SQL_HANDLE_STMT]].
	errors position == 0 ifTrue: [errors nextPut: (self retCodeError: code)].
	^errors grabContents!

buildErrorInfoFrom: anExternalHandle type: anIntegerHandleType
	"Private - Retrieve all error information available from the ODBC Driver for <anExternalHandle>, which is of type <anIntegerHandleType>"

	| recNumber |
	recNumber := 1.
	
	[| ret |
	
	[ret := OS.Odbc32
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
				szErrorMsg := Utf16String new: (cbErrorMsg swordAtOffset: 0)].
	ret == SQL_SUCCESS]
			whileTrue: 
				["The Oracle ODBC driver appears to return the byte length rather than the character length of the message. To keep things simple, just copy up to the first null"
				errors nextPut: ((Database.DBErrorDetails fromSQLError: szErrorMsg trimNulls)
							nativeErr: (fNativeError sdwordAtOffset: 0);
							sqlState: szSqlState asUtf8String;
							yourself).
				recNumber := recNumber + 1]!

retCodeError: anInteger
	^Database.DBErrorDetails new
		msg: 'SQL Error: ' , (ODBCRetCodes keyAtValue: anInteger ifAbsent: ['Unknown']);
		yourself! !

!DBErrorDetailsBuilder categoriesForMethods!
buildErrorDetailsFor:!accessing!private! !
buildErrorInfoFrom:type:!operations!private! !
retCodeError:!accessing!private! !
!

!DBErrorDetailsBuilder class methodsFor!

buildErrorDetailsFor: aDBExceptionDetails
	^self new buildErrorDetailsFor: aDBExceptionDetails! !

!DBErrorDetailsBuilder class categoriesForMethods!
buildErrorDetailsFor:!helpers!public! !
!

