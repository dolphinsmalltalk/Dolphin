"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary subclass: #'OS.ODBCLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.ODBCLibrary guid: (Core.GUID fromString: '{87b4c580-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.ODBCLibrary comment: 'This is the ExternalLibrary class to represent the Win32 System DLL, ODBC32.DLL. 
This library contains functions pertaining to the use of Open Database Connectivity 3.0.

Type mapping:
	SQLSMALLINT	->	sword	(16-bit signed integer)
	SQLUSMALLINT	->	word	(16-bit unsigned integer)
	SQLINTEGER	->	sdword	(32-bit signed integer)
	SQLUINTEGER	->	dword	(32-bit unsigned integer).
	SQLFLOAT	-> 	double	(64-bit float)
	SQLDOUBLE	->	double	(64-bit float)
	
Note that SQLRETURN is an alias for SQLSMALLINT'!
!OS.ODBCLibrary categoriesForClass!External-Libraries-ODBC! !
!OS.ODBCLibrary methodsFor!

sqlAllocHandle: anInteger inputHandle: parentExternalHandle outputHandlePtr: newExternalHandle
	<stdcall: int16 SQLAllocHandle int16 handle handle*>
	^self invalidCall: _failureCode!

sqlBindCol: anExternalHandle columnNumber: anIntegerCol targetType: anIntegerType targetValuePtr: anExternalAddressBuf bufferLength: anIntegerMax strLenOrInd: anExternalAddressLen
	"SQLRETURN SQLBindCol(
		SQLHSTMT     StatementHandle,
		SQLUSMALLINT     ColumnNumber,
		SQLSMALLINT     TargetType,
		SQLPOINTER     TargetValuePtr,
		SQLINTEGER     BufferLength,
		SQLLEN *     StrLen_or_Ind);

        Assign the storage and data type for a column in a result
        set, including:
        -   a storage buffer to receive the contents of a column of
            data (rgbValue, which must be an ExternalAddress
            allocated from non-Smalltalk memory and passed to this
            method asParameter).
        -   the length of the storage buffer
        -   a storage location to receive the length of the data
            put in the storage buffer (pcbValue, which must also be
            an ExternalAddress pointing at 4 bytes of non-Smalltalk
            memory passed asParameter)
        -   data type conversion

    N.B. The DLL retains the buffer addresses, so the buffers must
         be allocated from fixed memory. If this is not done
         then the objects will likely move on a garbage collect, and
         the DLL will then write into some other object!!"

	<stdcall: int16 SQLBindCol handle uint16 int16 lpvoid int32 lpvoid>
	^self invalidCall: _failureCode!

sqlBindParameter: anExternalHandle parameterNumber: parmNumInteger inputOutputType: ioInteger valueType: valueInteger parameterType: parmTypeInteger columnSize: sizeInteger decimalDigits: digitsInteger parameterValuePtr: parmBytes bufferLength: bufLenInteger strLenOrIndPtr: anSDWORD
	"SQLRETURN SQLBindParameter(
		SQLHSTMT     StatementHandle,
		SQLUSMALLINT     ParameterNumber,
		SQLSMALLINT     InputOutputType,
		SQLSMALLINT     ValueType,
		SQLSMALLINT     ParameterType,
		SQLUINTEGER     ColumnSize,
		SQLSMALLINT     DecimalDigits,
		SQLPOINTER     ParameterValuePtr,
		SQLINTEGER     BufferLength,
		SQLINTEGER *     StrLen_or_IndPtr);"

	<stdcall: int16 SQLBindParameter handle uint16 int16 int16 int16 uint32 int16 lpvoid int32 lpvoid>
	^self invalidCall: _failureCode!

sqlBrowseConnect: anExternalHandle inConnectionString: aString stringLength1: anIntegerLen outConnectionString: anExternalBuffer bufferLength: anIntegerMax stringLength2Ptr: anIntegerParm
	"For enumerating attributes of a data source.

	SQLRETURN SQLBrowseConnect(
		SQLHDBC     ConnectionHandle,
		SQLWCHAR *     InConnectionString,
		SQLSMALLINT     StringLength1,
		SQLWCHAR *     OutConnectionString,
		SQLSMALLINT     BufferLength,
		SQLSMALLINT *     StringLength2Ptr);"

	<stdcall: int16 SQLBrowseConnectW handle lpwstr int16 lpwstr int16 int16*>
	^self invalidCall: _failureCode!

sqlCancel: anExternalHandle
	"RETCODE SQL_API SQLCancel(
		HSTMT       hstmt);

	Request cancellation of processing for the specified statement.
	N.B. Successful completion does not indicate that the
	request has been satisfied, merely that it was accepted.
	See ODBC API help"

	<stdcall: int16 SQLCancel handle>
	^self invalidCall: _failureCode!

sqlCloseCursor: anExternalHandle
	<stdcall: int16 SQLCloseCursor handle>
	^self invalidCall: _failureCode!

sqlColAttribute: anExternalHandle columnNumber: columnInteger fieldIdentifier: idInteger characterAttributePtr: bytes bufferLength: sizeInteger stringLengthPtr: anSWORD numericAttributePtr: anExternalAddress
	<stdcall: int16 SQLColAttributeW handle uint16 uint16 lpvoid int16 int16* lpvoid>
	^self invalidCall: _failureCode!

sqlColumns: anExternalHandleSTMT catalogName: aStringParmQual nameLength1: anIntegerQualLen schemaName: aStringParmOwner nameLength2: anIntegerOwnerLen tableName: aStringParmName nameLength3: anIntegerNameLen columnName: aStringParmType nameLength4: anIntegerTypeLen
	"SQLRETURN SQLColumns(
		SQLHSTMT     StatementHandle,
		SQLWCHAR *     CatalogName,
		SQLSMALLINT     NameLength1,
		SQLWCHAR *     SchemaName,
		SQLSMALLINT     NameLength2,
		SQLWCHAR *     TableName,
		SQLSMALLINT     NameLength3,
		SQLWCHAR *     ColumnName,
		SQLSMALLINT     NameLength4);"

	<stdcall: int16 SQLColumnsW handle lpwstr int16 lpwstr int16 lpwstr int16 lpwstr int16>
	^self invalidCall: _failureCode!

sqlConnect: anExternalHandle serverName: dsnString nameLength1: dsnInteger userName: uidString nameLength2: uidIInteger authentication: authString nameLength3: authInteger
	"Load driver and establish connection to a data source.

	SQLRETURN SQLConnect(
		SQLHDBC ConnectionHandle,
		SQLCHAR * ServerName,
		SQLSMALLINT NameLength1,
		SQLCHAR * UserName,
		SQLSMALLINT NameLength2,
		SQLCHAR * Authentication,
		SQLSMALLINT NameLength3);"

	<stdcall: int16 SQLConnectW handle lpwstr int16 lpwstr int16 lpwstr int16>
	^self invalidCall: _failureCode!

sqlDataSources: anExternalHandle direction: anIntegerConstant serverName: anExternalBuffer bufferLength1: anIntegerMax nameLength1Ptr: anIntegerParmLen description: anExternalBufferParm bufferLength2: anIntegerParmDMax nameLength2Ptr: anIntegerParmDLen
	"SQLRETURN SQLDataSources(
		SQLHENV     EnvironmentHandle,
		SQLUSMALLINT     Direction,
		SQLCHAR *     ServerName,
		SQLSMALLINT     BufferLength1,
		SQLSMALLINT *     NameLength1Ptr,
		SQLCHAR *     Description,
		SQLSMALLINT     BufferLength2,
		SQLSMALLINT *     NameLength2Ptr);

	    Enumerates data source names.
	    Max length of szDSN (cbDSNMax) need not be longer than
	    SQL_MAX_DSN_LENGTH+1)."

	<stdcall: int16 SQLDataSourcesW handle uint16 lpwstr int16 int16* lpwstr int16 int16*>
	^self invalidCall: _failureCode!

sqlDescribeCol: anExternalHandle columnNumber: columnInteger columnName: aString bufferLength: sizeInteger nameLengthPtr: maxSWORD dataTypePtr: typeSWORD columnSizePtr: precisionDWORD decimalDigitsPtr: scaleSWORD nullablePtr: nullableSWORD
	"SQLRETURN SQLDescribeCol(
		SQLHSTMT     StatementHandle,
		SQLUSMALLINT     ColumnNumber,
		SQLWCHAR *     ColumnName,
		SQLSMALLINT     BufferLength,
		SQLSMALLINT *     NameLengthPtr,
		SQLSMALLINT *     DataTypePtr,
		SQLUINTEGER *     ColumnSizePtr,
		SQLSMALLINT *     DecimalDigitsPtr,
		SQLSMALLINT *     NullablePtr);"

	<stdcall: int16 SQLDescribeColW handle uint16 lpwstr int16 int16* int16* uint32* int16* int16*>
	^self invalidCall: _failureCode!

sqlDisconnect: anExternalHandle
	<stdcall: int16 SQLDisconnect handle>
	^self invalidCall: _failureCode!

sqlDriverConnect: anExternalHandle windowHandle: aWinHandle inConnectionString: aStringConn stringLength1: anIntegerConn outConnectionString: aStringConnOut bufferLength: anIntegerConnOut stringLength2Ptr: anExternalShort driverCompletion: anIntegerOption
	"Load driver and establish connection to a data source.

	SQLRETURN SQLDriverConnect(
		SQLHDBC     ConnectionHandle,
		SQLHWND     WindowHandle,
		SQLWCHAR *     InConnectionString,
		SQLSMALLINT     StringLength1,
		SQLWCHAR *     OutConnectionString,
		SQLSMALLINT     BufferLength,
		SQLSMALLINT *     StringLength2Ptr,
		SQLUSMALLINT     DriverCompletion);"

	<stdcall: int16 SQLDriverConnectW handle handle lpwstr int16 lpwstr int16 int16* uint16>
	^self invalidCall: _failureCode!

sqlEndTran: anExternalHandleEnv handle: anExternalHandleDBC completionType: anInteger
	"SQLRETURN SQLEndTran(
		SQLSMALLINT     HandleType,
		SQLHANDLE     Handle,
		SQLSMALLINT     CompletionType);"

	<stdcall: int16 SQLEndTran int16 handle int16>
	^self invalidCall: _failureCode!

sqlExecDirect: anExternalHandle statementText: aString textLength: anInteger
	"SQLRETURN SQLExecDirect(
		SQLHSTMT StatementHandle,
		SQLCHAR * StatementText,
		SQLINTEGER TextLength);"

	<stdcall: int16 SQLExecDirectW handle lpwstr int32>
	^self invalidCall: _failureCode!

sqlExecute: anExternalHandle
	"Execute a preprepared SQL statement on the specified handle
	
		SQLRETURN SQLExecute(HSTMT hstmt);"

	<stdcall: int16 SQLExecute handle>
	^self invalidCall: _failureCode!

sqlFetchScroll: anExternalHandle fetchOrientation: orientationInteger fetchOffset: offsetInteger
	<stdcall: int16 SQLFetchScroll handle uint16 int32>
	^self invalidCall: _failureCode!

sqlForeignKeys: anExternalHandle pkCatalogName: aStringPkQual nameLength1: anIntegerPkQual pkSchemaName: aStringPkOwn nameLength2: anIntegerPkOwn pkTableName: aStringPkName nameLength3: anIntegerPkName fkCatalogName: aStringFkQual nameLength4: anIntegerFkQual fkSchemaName: aStringFkOwn nameLength5: anIntegerFkOwn fkTableName: aStringFkName nameLength6: anIntegerFkName
	"SQLRETURN SQLForeignKeys(
		SQLHSTMT     StatementHandle,
		SQLWCHAR *     PKCatalogName,
		SQLSMALLINT     NameLength1,
		SQLWCHAR *     PKSchemaName,
		SQLSMALLINT     NameLength2,
		SQLWCHAR *     PKTableName,
		SQLSMALLINT     NameLength3,
		SQLWCHAR *     FKCatalogName,
		SQLSMALLINT     NameLength4,
		SQLWCHAR *     FKSchemaName,
		SQLSMALLINT     NameLength5,
		SQLWCHAR *     FKTableName,
		SQLSMALLINT     NameLength6);"

	<stdcall: int16 SQLForeignKeysW handle lpwstr int16 lpwstr int16 lpwstr int16 lpwstr int16 lpwstr int16 lpwstr int16>
	^self invalidCall: _failureCode!

sqlFreeHandle: anInteger handle: anExternalHandle
	<stdcall: int16 SQLFreeHandle int16 handle>
	^self invalidCall: _failureCode!

sqlFreeStmt: anExternalHandle option: anInteger
	<stdcall: int16 SQLFreeStmt handle uint16>
	^self invalidCall: _failureCode!

sqlGetConnectAttr: anExternalHandle attribute: idInteger valuePtr: anIntegerOrStringOrBytes bufferLength: lengthInteger stringLengthPtr: anSDWORD
	<stdcall: int16 SQLGetConnectAttrW handle int32 lpvoid int32 int32*>
	^self invalidCall: _failureCode!

sqlGetData: anExternalHandleSTMT columnNumber: anIntegerPar targetType: anIntegerCType targetValuePtr: anExternalBuffer bufferLength: anIntegerMax strLenOrIndPtr: anSDWORD
	"SQLRETURN SQLGetData(
		SQLHSTMT     StatementHandle,
		SQLUSMALLINT     ColumnNumber,
		SQLSMALLINT     TargetType,
		SQLPOINTER     TargetValuePtr,
		SQLINTEGER     BufferLength,
		SQLINTEGER *     StrLen_or_IndPtr);"

	<stdcall: int16 SQLGetData handle uint16 int16 lpvoid int32 int32*>
	^self invalidCall: _failureCode!

sqlGetDiagRec: anIntegerHandleType handle: anExternalHandle recNumber: anIntegerRecordNumber szSqlState: anSQLStateParm pfNativeError: anIntegerParmNErr szErrorMsg: anExternalBufferErrMsg cbErrorMsgMax: anInteger pcbErrorMsg: anIntegerParmLen
	"SQLRETURN SQLGetDiagRec(
		SQLSMALLINT     HandleType,
		SQLHANDLE       Handle,
		SQLSMALLINT     RecNumber,
		SQLWCHAR *       SQLState,
		SQLINTEGER *    NativeErrorPtr,
		SQLWCHAR *       MessageText,
		SQLSMALLINT     BufferLength,
		SQLSMALLINT *   TextLengthPtr);"

	<stdcall: int16 SQLGetDiagRecW int16 handle int16 lpwstr int32* lpwstr int16 int16*>
	^self invalidCall: _failureCode!

sqlGetEnvAttr: anExternalHandle infoType: anIntegerType infoValuePtr: bytes bufferLength: anIntegerMax stringLengthPtr: anSWORD
	"Request information about the current setting of an environment attribute.

		SQLRETURN SQLGetEnvAttr(
			SQLHDBC     ConnectionHandle,
			SQLUSMALLINT     InfoType,
			SQLPOINTER     InfoValuePtr,
			SQLSMALLINT     BufferLength,
			SQLSMALLINT *     StringLengthPtr);"

	<stdcall: int16 SQLGetEnvAttr handle uint32 lpvoid uint32 uint32*>
	^self invalidCall: _failureCode!

sqlGetFunctions: anExternalHandle functionId: anInteger supportedPtr: aWORD
	"Request confirmation that a particular function is implemented
	by the driver.

		SQLRETURN SQLGetFunctions(
			SQLHDBC     ConnectionHandle,
			SQLUSMALLINT     FunctionId,
			SQLUSMALLINT *     SupportedPtr);"

	<stdcall: int16 SQLGetFunctions handle uint16 uint16*>
	^self invalidCall: _failureCode!

sqlGetInfo: anExternalHandle infoType: anIntegerType infoValuePtr: bytes bufferLength: anIntegerMax stringLengthPtr: anSWORD
	"Request specific information about a data source depending on
	fInfoType.

		SQLRETURN SQLGetInfo(
			SQLHDBC     ConnectionHandle,
			SQLUSMALLINT     InfoType,
			SQLPOINTER     InfoValuePtr,
			SQLSMALLINT     BufferLength,
			SQLSMALLINT *     StringLengthPtr);"

	<stdcall: int16 SQLGetInfoW handle uint16 lpvoid int16 int16*>
	^self invalidCall: _failureCode!

sqlGetStmtAttr: anExternalHandle attribute: optionCode valuePtr: anIntegerOrStringOrBytes bufferLength: lengthInteger stringLengthPtr: anSDWORD
	<stdcall: int16 SQLGetStmtAttrW handle int32 lpvoid int32 int32*>
	^self invalidCall: _failureCode!

sqlNumResultCols: anExternalHandle pccol: anSWORD
	"Return the number of columns in the result set for the statement.

		SQLRETURN SQLNumResultCols(
			SQLHSTMT StatementHandle,
			SQLSMALLINT * ColumnCountPtr);"

	<stdcall: int16 SQLNumResultCols handle int16*>
	^self invalidCall: _failureCode!

sqlPrepare: anExternalHandle statementText: aString textLength: anInteger
	"SQLRETURN SQLPrepare(
		SQLHSTMT     StatementHandle,
		SQLCHAR *     StatementText,
		SQLINTEGER     TextLength);"

	<stdcall: int16 SQLPrepareW handle lpwstr int32>
	^self invalidCall: _failureCode!

sqlPrimaryKeys: anExternalHandle catalogName: aStringQual nameLength1: anIntegerQual schemaName: aStringOwn nameLength2: anIntegerOwn tableName: aStringName nameLength3: anIntegerName
	"SQLRETURN SQLPrimaryKeys(
		SQLHSTMT     StatementHandle,
		SQLWCHAR *     CatalogName,
		SQLSMALLINT     NameLength1,
		SQLWCHAR *     SchemaName,
		SQLSMALLINT     NameLength2,
		SQLWCHAR *     TableName,
		SQLSMALLINT     NameLength3);"

	<stdcall: int16 SQLPrimaryKeysW handle lpwstr int16 lpwstr int16 lpwstr int16>
	^self invalidCall: _failureCode!

sqlProcedures: anExternalHandle catalogName: aStringParmPQ nameLength1: anIntegerPQ schemaName: aStringParmPO nameLength1: anIntegerPO procName: aStringParmPN nameLength3: anIntegerPN
	"SQLRETURN SQLProcedures(
		SQLHSTMT     StatementHandle,
		SQLWCHAR *     CatalogName,
		SQLSMALLINT     NameLength1,
		SQLWCHAR *     SchemaName,
		SQLSMALLINT     NameLength2,
		SQLWCHAR *     ProcName,
		SQLSMALLINT     NameLength3);"

	<stdcall: int16 SQLProceduresW handle lpwstr int16 lpwstr int16 lpwstr int16>
	^self invalidCall: _failureCode!

sqlRowCount: anExternalHandle rowCountPtr: anSDWORD
	"Return the number of rows affected by an UPDATE, INSERT or
	DELETE statement associated with the specified hstmt.

	SQLRETURN SQLRowCount(
		SQLHSTMT StatementHandle,
		SQLINTEGER * RowCountPtr)"

	<stdcall: int16 SQLRowCount handle int32*>
	^self invalidCall: _failureCode!

sqlSetConnectAttr: anExternalHandle attribute: idInteger valuePtr: bytes stringLength: lengthInteger
	<stdcall: int16 SQLSetConnectAttrW handle int32 lpvoid int32>
	^self invalidCall: _failureCode!

sqlSetEnvAttr: anExternalHandle attribute: anInteger valuePtr: anExternalAddress stringLength: lengthInteger
	<stdcall: int16 SQLSetEnvAttr handle int32 lpvoid int32>
	^self invalidCall: _failureCode!

sqlSetPos: anExternalHandle rowNumber: anIntegerRow operation: anIntegerOption lockType: aBoolLock
	"SQLRETURN SQLSetPos(
		SQLHSTMT     StatementHandle,
		SQLUSMALLINT     RowNumber,
		SQLUSMALLINT     Operation,
		SQLUSMALLINT     LockType);"

	<stdcall: int16 SQLSetPos handle uint16 uint16 uint16>
	^self invalidCall: _failureCode!

sqlSetStmtAttr: anExternalHandle attribute: anInteger valuePtr: anExternalAddress stringLength: lengthInteger
	<stdcall: int16 SQLSetStmtAttrW handle int32 lpvoid int32>
	^self invalidCall: _failureCode!

sqlSpecialColumns: anExternalHandle identifierType: anInteger catalogName: aStringQual nameLength1: anIntegerQual schemaName: aStringOwn nameLength2: anIntegerOwn tableName: aStringName nameLength3: anIntegerName scope: anIntegerScope nullable: anIntegerNullable
	"SQLRETURN SQLSpecialColumns(
		SQLHSTMT     StatementHandle,
		SQLSMALLINT     IdentifierType,
		SQLWCHAR *     CatalogName,
		SQLSMALLINT     NameLength1,
		SQLWCHAR *     SchemaName,
		SQLSMALLINT     NameLength2,
		SQLWCHAR *     TableName,
		SQLSMALLINT     NameLength3,
		SQLSMALLINT     Scope,
		SQLSMALLINT     Nullable);"

	<stdcall: int16 SQLSpecialColumnsW handle int16 lpwstr int16 lpwstr int16 lpwstr int16 int16 int16>
	^self invalidCall: _failureCode!

sqlStatistics: anExternalHandle catalogName: aStringQual nameLength1: anIntegerQual schemaName: aStringOwn nameLength2: anIntegerOwn tableName: aStringName nameLength3: anIntegerName unique: anIntegerScope reserved: anIntegerNullable
	"SQLRETURN SQLStatistics(
		SQLHSTMT     StatementHandle,
		SQLWCHAR *     CatalogName,
		SQLSMALLINT     NameLength1,
		SQLWCHAR *     SchemaName,
		SQLSMALLINT     NameLength2,
		SQLWCHAR *     TableName,
		SQLSMALLINT     NameLength3,
		SQLUSMALLINT     Unique,
		SQLUSMALLINT     Reserved);"

	<stdcall: int16 SQLStatisticsW handle lpwstr int16 lpwstr int16 lpwstr int16 uint16 uint16>
	^self invalidCall: _failureCode!

sqlTables: anExternalHandleSTMT szTableQualifier: aStringParmQual cbTableQualifier: anIntegerQualLen szTableOwner: aStringParmOwner cbTableOwner: anIntegerOwnerLen szTableName: aStringParmName cbTableName: anIntegerNameLen szTableType: aStringParmType cbTableType: anIntegerTypeLen
	"RETCODE SQL_API SQLTables(
		HSTMT       hstmt,
		WCHAR 	*szTableQualifier,
		SWORD     cbTableQualifier,
		WCHAR  	*szTableOwner,
		SWORD     cbTableOwner,
		WCHAR  	*szTableName,
		SWORD     cbTableName,
		WCHAR  	*szTableType,
		SWORD      cbTableType);"

	<stdcall: int16 SQLTablesW handle lpwstr int16 lpwstr int16 lpwstr int16 lpwstr int16>
	^self invalidCall: _failureCode! !
!OS.ODBCLibrary categoriesForMethods!
sqlAllocHandle:inputHandle:outputHandlePtr:!public!win32 functions-odbc library! !
sqlBindCol:columnNumber:targetType:targetValuePtr:bufferLength:strLenOrInd:!public!win32 functions-odbc library! !
sqlBindParameter:parameterNumber:inputOutputType:valueType:parameterType:columnSize:decimalDigits:parameterValuePtr:bufferLength:strLenOrIndPtr:!public!win32 functions-odbc library! !
sqlBrowseConnect:inConnectionString:stringLength1:outConnectionString:bufferLength:stringLength2Ptr:!public!win32 functions-odbc library! !
sqlCancel:!public!win32 functions-odbc library! !
sqlCloseCursor:!public!win32 functions-odbc library! !
sqlColAttribute:columnNumber:fieldIdentifier:characterAttributePtr:bufferLength:stringLengthPtr:numericAttributePtr:!public!win32 functions-odbc library! !
sqlColumns:catalogName:nameLength1:schemaName:nameLength2:tableName:nameLength3:columnName:nameLength4:!public!win32 functions-odbc library! !
sqlConnect:serverName:nameLength1:userName:nameLength2:authentication:nameLength3:!public!win32 functions-odbc library! !
sqlDataSources:direction:serverName:bufferLength1:nameLength1Ptr:description:bufferLength2:nameLength2Ptr:!public!win32 functions-odbc library! !
sqlDescribeCol:columnNumber:columnName:bufferLength:nameLengthPtr:dataTypePtr:columnSizePtr:decimalDigitsPtr:nullablePtr:!public!win32 functions-odbc library! !
sqlDisconnect:!public!win32 functions-odbc library! !
sqlDriverConnect:windowHandle:inConnectionString:stringLength1:outConnectionString:bufferLength:stringLength2Ptr:driverCompletion:!public!win32 functions-odbc library! !
sqlEndTran:handle:completionType:!public!win32 functions-odbc library! !
sqlExecDirect:statementText:textLength:!public!win32 functions-odbc library! !
sqlExecute:!public!win32 functions-odbc library! !
sqlFetchScroll:fetchOrientation:fetchOffset:!public!win32 functions-odbc library! !
sqlForeignKeys:pkCatalogName:nameLength1:pkSchemaName:nameLength2:pkTableName:nameLength3:fkCatalogName:nameLength4:fkSchemaName:nameLength5:fkTableName:nameLength6:!public!win32 functions-odbc library! !
sqlFreeHandle:handle:!public!win32 functions-odbc library! !
sqlFreeStmt:option:!public!win32 functions-odbc library! !
sqlGetConnectAttr:attribute:valuePtr:bufferLength:stringLengthPtr:!public!win32 functions-odbc library! !
sqlGetData:columnNumber:targetType:targetValuePtr:bufferLength:strLenOrIndPtr:!public!win32 functions-odbc library! !
sqlGetDiagRec:handle:recNumber:szSqlState:pfNativeError:szErrorMsg:cbErrorMsgMax:pcbErrorMsg:!public!win32 functions-odbc library! !
sqlGetEnvAttr:infoType:infoValuePtr:bufferLength:stringLengthPtr:!public!win32 functions-odbc library! !
sqlGetFunctions:functionId:supportedPtr:!public!win32 functions-odbc library! !
sqlGetInfo:infoType:infoValuePtr:bufferLength:stringLengthPtr:!public!win32 functions-odbc library! !
sqlGetStmtAttr:attribute:valuePtr:bufferLength:stringLengthPtr:!public!win32 functions-odbc library! !
sqlNumResultCols:pccol:!public!win32 functions-odbc library! !
sqlPrepare:statementText:textLength:!public!win32 functions-odbc library! !
sqlPrimaryKeys:catalogName:nameLength1:schemaName:nameLength2:tableName:nameLength3:!public!win32 functions-odbc library! !
sqlProcedures:catalogName:nameLength1:schemaName:nameLength1:procName:nameLength3:!public!win32 functions-odbc library! !
sqlRowCount:rowCountPtr:!public!win32 functions-odbc library! !
sqlSetConnectAttr:attribute:valuePtr:stringLength:!public!win32 functions-odbc library! !
sqlSetEnvAttr:attribute:valuePtr:stringLength:!public!win32 functions-odbc library! !
sqlSetPos:rowNumber:operation:lockType:!public!win32 functions-odbc library! !
sqlSetStmtAttr:attribute:valuePtr:stringLength:!public!win32 functions-odbc library! !
sqlSpecialColumns:identifierType:catalogName:nameLength1:schemaName:nameLength2:tableName:nameLength3:scope:nullable:!public!win32 functions-odbc library! !
sqlStatistics:catalogName:nameLength1:schemaName:nameLength2:tableName:nameLength3:unique:reserved:!public!win32 functions-odbc library! !
sqlTables:szTableQualifier:cbTableQualifier:szTableOwner:cbTableOwner:szTableName:cbTableName:szTableType:cbTableType:!public!win32 functions-odbc library! !
!

!OS.ODBCLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'ODBC32'!

onStartup2
	"Private - Ensure that old external resources are cleared so that they will be re-created."

	super onStartup2.
	Database.DBResultSet onStartup!

sharedVariableName
	^#{Odbc32}! !
!OS.ODBCLibrary class categoriesForMethods!
fileName!constants!public! !
onStartup2!event handling!private! !
sharedVariableName!constants!private! !
!

