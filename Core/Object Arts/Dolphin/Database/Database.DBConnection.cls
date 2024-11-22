"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Database.DBConnection'
	instanceVariableNames: 'handle dsn uid pwd statements transaction connectString flags'
	classVariableNames: 'Connections DriverCompleteMask HEnv RequiredOdbcVersion ScrollTypes TxnIsolationLevels'
	imports: #(#{OS.ODBCRetCodes} #{OS.ODBCConstants} #{OS.ODBCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!

Database.DBConnection guid: (Core.GUID fromString: '{87b4c472-026e-11d3-9fd7-00a0cc3e4a32}')!

Database.DBConnection comment: 'A DBConnection represents a connection to an ODBC data source.

One can use a DBConnection to query the capabilities of the underlying driver and the structure of the database. One can then interact with the database by submitting SQL queries using #exec: or #query:[cursorType:]. One can also prepare a DBStatement for later parameterization and execution with #prepare:[cursorType:].

Instance Variables:
	handle		<ExternalHandle>. ODBC connection handle.
	dsn		<String>. Data source name.
	uid		<String>. User id.
	pwd		<String>. Password.
	statements	<WeakSet>. Extant statements on this connection.
	transaction	<DBTxn>. Current transaction, if any.

Class Variables:
	HEnv		<ExternalHandle>. ODBC environment handle.
	Connections	<WeakSet>. All extant instances with at least an allocated handle.
	TxnIsolationLevels	<IdentityDictionary>. Map between SQL_TXN_XXX values and symbolic names.
	ScrollTypes	<IdentityDictionary>. Map between SQL_SO_XXX values and symbolic names.
'!

!Database.DBConnection categoriesForClass!ODBC Interface! !

!Database.DBConnection methodsFor!

allocStmtHandle: aDBStatement
	"Private - Allocate a new statement handle for the specified object.
	This may cause a connection to be lazily established (via the handle method)."

	| hStmt ret |
	hStmt := External.Handle new.
	ret := OS.Odbc32
				sqlAllocHandle: SQL_HANDLE_STMT
				inputHandle: self asParameter
				outputHandlePtr: hStmt.
	self dbCheckException: ret function: 'SQLAllocHandle'.
	self statements add: aDBStatement.
	^hStmt!

asParameter
	"Answer the receiver in a form suitable for passing to an external function
	primitive method (see ExternalLibrary and subclasses)."

	handle isNull ifTrue: [self basicConnect].
	^handle!

basicConnect
	"Private - Connect with the parameters specified earlier.
	Assumes not already connected."

	
	[dsn
		ifNil: 
			[| lenConnSz |
			lenConnSz := External.Int16 new.
			self dbCheckException: (OS.Odbc32
						sqlDriverConnect: self getHandle
						windowHandle: nil
						inConnectionString: connectString
						stringLength1: SQL_NTS
						outConnectionString: nil
						bufferLength: 0
						stringLength2Ptr: lenConnSz
						driverCompletion: SQL_DRIVER_NOPROMPT)
				function: 'SQLDriverConnect']
		ifNotNil: 
			[self dbCheckException: (OS.Odbc32
						sqlConnect: self getHandle
						serverName: dsn
						nameLength1: SQL_NTS
						userName: uid
						nameLength2: SQL_NTS
						authentication: pwd
						nameLength3: SQL_NTS)
				function: 'SQLConnect']]
			ifCurtailed: [self free]!

beginRWTxn
	"Start a read/write transaction on this connection."

	self transaction: (DBTxn newRWOn: self)!

beginTxn
	"Start a read only transaction on this connection"

	self transaction: (DBTxn newOn: self)!

buildConnectString
	| stream |
	stream := WriteStream on: (String new: 50).
	dsn notNil 
		ifTrue: 
			[stream
				nextPutAll: 'DSN=';
				nextPutAll: dsn].
	uid notNil 
		ifTrue: 
			[stream
				nextPutAll: ';UID=';
				nextPutAll: uid].
	pwd notNil 
		ifTrue: 
			[stream
				nextPutAll: ';PWD=';
				nextPutAll: pwd].
	^stream contents trimNulls!

catalogNameSeparator
	"Answer the qualifier name separator"

	^self getStringInfo: SQL_CATALOG_NAME_SEPARATOR!

catalogTerm
	"Answer the <readableString> name for a 'catalog' in the parlance of the DBMS to which the
	receiver is connected, e.g. in the case of Access this is 'DATABASE'."

	^self getStringInfo: SQL_CATALOG_TERM!

checkEmptyEnvironment
	"Private - If there are no more open connections, free the environment"

	Connections isEmpty
		ifTrue: 
			[[self class freeEnvironment] on: DBError do: [:se | se toTrace].
			HEnv := nil]!

close
	"Close a database connection - rollback the current transaction, disconnect,
	and free connection handle"

	handle isNull
		ifFalse: [
			transaction notNil
				ifTrue: [self rollbackTxn].
			self
				disconnect;
				free;
				checkEmptyEnvironment]!

closeNoFail
	"Quietly close connection (frees handle), and if no
	more open connections, free the environment"

	[self close] on: DBError
		do: 
			[:se |
			se toTrace.
			handle := nil.
			self checkEmptyEnvironment]!

columns: aStringTableName
	"Answer a list of columns in the table aStringTableName"

	^self columns: nil qualifier: nil owner: nil table: aStringTableName!

columns: aStringColumn qualifier: aStringQualifier owner: aStringOwner table: aStringTable
	"Answer the list of columns in the table matching the specified search criteria"

	| stmt colAttrs |
	colAttrs := OrderedCollection new.
	stmt := (DBColumnsStatement parent: self)
				catalogName: aStringQualifier;
				schemaName: aStringOwner;
				tableName: aStringTable;
				columnName: aStringColumn;
				yourself.
	stmt results do: 
			[:each |
			colAttrs addLast: (DBColAttr new
						columnNumber: colAttrs size;
						name: (each atIndex: 4);
						precision: (each atIndex: 7);
						scale: (each atIndex: 9);
						type: (each atIndex: 5);
						length: (each atIndex: 8))].
	stmt free.
	^colAttrs!

commitTxn
	"Commit the receiver's current transaction. Raise an error if there is no outstanding transaction."

	self transaction commit.
	transaction := nil!

connect
	"Connect with the parameters specified earlier. Do nothing if already connected.
	Implementation Note: Connections are normally established lazily when the handle
	is requested."

	handle isNull ifTrue: [self basicConnect]!

connectString
	"Answer the connect string to use for this connection."

	connectString isNil ifTrue: [connectString := self buildConnectString].
	^connectString!

connectString: aString 
	"Interpret the connection string and grab any parameters from it which we're interested in
	i.e. those for which we have a 'set' method."

	dsn := uid := pwd := nil.
	self class connectString: aString
		do: 
			[:paramName :paramValue | 
			| selector |
			selector := (paramName asLowercase , ':') asSymbol.
			(self respondsTo: selector) ifTrue: [self perform: selector with: paramValue]].
	connectString := aString!

convertFunctions
	"Answers an array of the conversion functions available"

	| mask |
	mask := self getUInt32Info: SQL_CONVERT_FUNCTIONS.
	^#('SQL_FN_CVT_CONVERT') 
		select: [:maskName | (mask bitAnd: (OS.ODBCConstants at: maskName)) ~= 0]!

cursorCommitBehaviour
	"Answer an <integer> from the SQL_CB_XXX enumeration identifying the
	cursor commit behaviour of this connection."

	^self getWordInfo: SQL_CURSOR_COMMIT_BEHAVIOR!

cursorRollbackBehaviour
	"Answer an <integer> from the SQL_CB_XXX enumeration identifying the
	cursor rollback behaviour of this connection."

	^self getWordInfo: SQL_CURSOR_ROLLBACK_BEHAVIOR!

databaseName
	"Answer the <readableString> database name, e.g. in the case of an Access database this will 
	be the file name, or in the case of an SQL Server database the name of one of the databases hosted 
	by the server."

	^self getStringInfo: SQL_DATABASE_NAME!

dataSourceName
	"Private - Answer the data source name as a <readableString>."

	^self getStringInfo: SQL_DATA_SOURCE_NAME!

dbCheckException: anIntegerRetCode function: aString
	"Private - Checks anIntegerRetCode to see if a DBError or DBWarning should be signalled.
	Note that as of Dolphin 4.0, DBWarning is actually a notification, which is a more appropriate level of reporting for SQL_SUCCESS_WITH_INFO."

	anIntegerRetCode == SQL_SUCCESS
		ifFalse: 
			["Signal an error or warning - decide which"
			((anIntegerRetCode == SQL_SUCCESS_WITH_INFO or: [anIntegerRetCode == SQL_NO_DATA])
				ifTrue: [DBWarning]
				ifFalse: [DBError]) signal: aString with: (self newExceptionDetails: anIntegerRetCode)].
	^anIntegerRetCode!

dbmsName
	"Answers the underlying DBMS name as a <readableString>."

	^self getStringInfo: SQL_DBMS_NAME!

dbmsVersion
	"Answers the underlying DBMS version as a <readableString>"

	^self getStringInfo: SQL_DBMS_VER!

decodeBitMask: anInteger map: aLookupTable 
	| answer |
	answer := OrderedCollection new.
	aLookupTable keysAndValuesDo: 
			[:eachKey :eachValue | 
			(anInteger allMask: eachKey) ifTrue: [answer addLast: eachValue]].
	^answer!

defaultCursorType
	"Answer the <Symbol>ic name of the default cursor type to be used for statements
	(one of #dynamic, #forwardOnly, #keysetDriven, #static).
	Implementation Note: For backwards compatibility use a #keysetDriven cursor 
	by default."

	^#keysetDriven
!

defaultFlags
	^DriverCompleteMask!

defaultTransactionIsolation
	"Answer the default transaction isolation."

	^TxnIsolationLevels at: (self getUInt32Info: SQL_DEFAULT_TXN_ISOLATION)!

disconnect
	"Private - disconnect without freeing handle. All oustanding
	statements are free'd (this is necessary because they are
	about to become invalid). Client objects should send close
	instead."

	handle isNull
		ifFalse: 
			[| ret |
			self invalidateAllStmts.
			ret := OS.Odbc32 sqlDisconnect: handle.
			self dbCheckException: ret function: 'SQLDisconnect']!

driverHDBC
	"Private - Answer the handle to the driver connection"

	^self getHandle: SQL_DRIVER_HDBC!

driverHEnv
	"Private - Answer the handle to the driver environment"

	^self getHandle: SQL_DRIVER_HENV!

driverName
	"Answer the driver name"

	^self getStringInfo: SQL_DRIVER_NAME!

driverVersion
	"Answer the driver version"

	^self getStringInfo: SQL_DRIVER_VER!

dsn
	"Answer the data set name for the receiver"

	^dsn!

dsn: aString
	"Set the data set name to aString."

	connectString := nil.
	dsn := aString.!

exec: aString 
	"Execute the SQL in aString.
	Answer the <DBStatement> used to execute the statement"

	^self exec: aString cursorType: #keysetDriven!

exec: aString cursorType: aSymbol 
	"Execute the SQL in aString, answering the type of cursor specified by the
	<Symbol> argument (one of #dynamic, #forwardOnly, #keysetDriven, or 
	#static)."

	| statement |
	statement := self newStatement: aSymbol.
	[statement exec: aString] ifCurtailed: [statement free].
	^statement!

finalize
	"Private - finalize the affairs of the receiver."

	
	[super finalize.
	self close] on: DBError do: [:x | x toTrace]!

free
	"Private - Free the connection handle."

	handle isNull
		ifFalse: 
			[self dbCheckException: self freeNoFail function: 'SQLFreeHandle'.
			handle := nil]!

freeNoFail
	"Private - Free the connection handle ignoring any errors."

	^OS.Odbc32 sqlFreeHandle: SQL_HANDLE_DBC handle: handle!

freeStmtHandle: aDBAbstractStatement
	handle isNull ifTrue: [^self].
	self dbCheckException: (OS.Odbc32 sqlFreeHandle: SQL_HANDLE_STMT
				handle: aDBAbstractStatement handle)
		function: 'SQLFreeHandle'!

getBoolInfo: anInteger
	"Private - Answer a <Boolean> indicating the receiver's info attribute described by anInteger."

	| value |
	value := Utf16String newFixed: 1.
	self dbCheckException: (OS.Odbc32
				sqlGetInfo: self asParameter
				infoType: anInteger
				infoValuePtr: value
				bufferLength: ##((1 + 1) * 2	"Byte size including implict null char")
				stringLengthPtr: nil)
		function: 'SQLGetInfo'.
	^value = ##($Y asUtf16String)!

getDWordAttribute: anInteger
	"Private - Answer an <Integer> containing the 32-bit unsigned integer value of the 
	connection attribute identified by the <integer> argument."

	| buffer |
	buffer := ByteArray newFixed: 4.
	self dbCheckException: (OS.Odbc32
				sqlGetConnectAttr: self asParameter
				attribute: anInteger
				valuePtr: buffer
				bufferLength: SQL_IS_UINTEGER
				stringLengthPtr: nil)
		function: 'SQLGetConnectAttr'.
	^buffer uint32AtOffset: 0!

getHandle
	"Private - Answer the handle instance variable.
	Allocate it if we haven't done so already."

	handle isNull 
		ifTrue: 
			[handle := self class allocHandle.
			self setDefaultAttributes.
			self class connections add: self].
	^handle!

getHandle: anInteger
	| value |
	value := External.Handle new.
	self dbCheckException: (OS.Odbc32
				sqlGetInfo: self asParameter
				infoType: anInteger
				infoValuePtr: value
				bufferLength: Kernel.VMConstants.IntPtrSize
				stringLengthPtr: nil)
		function: 'SQLGetInfo'.
	^value!

getStringAttribute: anInteger
	"Private - Answer a <String> containing the value of the connection attribute identified by the <integer> argument."

	| buffer |
	buffer := Utf16String newFixed: SQL_MAX_OPTION_STRING_LENGTH.
	self dbCheckException: (OS.Odbc32
				sqlGetConnectAttr: self asParameter
				attribute: anInteger
				valuePtr: buffer
				bufferLength: ##((SQL_MAX_OPTION_STRING_LENGTH + 1) * 2)
				stringLengthPtr: nil)
		function: 'SQLGetConnectAttr'.	"Byte size including implicit null terminator"
	"N.B. The SQL server driver never seems to populate the stringLengthPtr argument, so we are forced to trim up to the nulls."
	^buffer trimNulls!

getStringInfo: anInteger
	"Private - Answer a String containing the value of the receiver's info attribute described by infoCode."

	| value len |
	value := Utf16String newFixed: SQL_MAX_MESSAGE_LENGTH.
	len := ByteArray newFixed: 2.
	self dbCheckException: (OS.Odbc32
				sqlGetInfo: self asParameter
				infoType: anInteger
				infoValuePtr: value
				bufferLength: ##((SQL_MAX_MESSAGE_LENGTH + 1) * 2)
				stringLengthPtr: len)
		function: 'SQLGetInfo'.
	^value resize: ((len int16AtOffset: 0) bitShift: -1)!

getUInt32Info: anInteger
	"Private - Answer an Integer containing the value of the receiver's UInt32 info attribute described by anInteger."

	| value |
	value := ByteArray newFixed: 4.
	self dbCheckException: (OS.Odbc32
				sqlGetInfo: self asParameter
				infoType: anInteger
				infoValuePtr: value
				bufferLength: 4
				stringLengthPtr: nil)
		function: 'SQLGetInfo'.
	^value uint32AtOffset: 0!

getWordInfo: anInteger
	"Private - Answer an Integer containing the value of the receiver's WORD info attribute described by infoCode."

	| value |
	value := ByteArray newFixed: 2.
	self dbCheckException: (OS.Odbc32
				sqlGetInfo: self asParameter
				infoType: anInteger
				infoValuePtr: value
				bufferLength: 2
				stringLengthPtr: nil)
		function: 'SQLGetInfo'.
	^value uint16AtOffset: 0!

hasAccessibleTables
	"Answers whetherthe receiver is connected to a DB which has tables that can be accessed."

	^self getBoolInfo: SQL_ACCESSIBLE_TABLES!

hasIntegrityEnhancementFacility
	"Answer whether the DBMS to which the receiver is connected has integrity enhancement facility support."

	^self getBoolInfo: SQL_INTEGRITY!

identifierCase
	"Answer an <integer> constant from the SQL_IC_XXXX enumeration that indicates the 
	case sensitivity of the DBMS to which the receiver is connected."

	^self getWordInfo: SQL_IDENTIFIER_CASE!

identifierQuoteCharacter
	"Answers the <Character> used to quote identifiers in the DBMS' SQL dialect."

	^(self getStringInfo: SQL_IDENTIFIER_QUOTE_CHAR) first!

indicesOf: aString
	"Answer the a <collection> of <DBRows> being details of all the indices for the 
	table with the specified <readableString> name."

	^self 
		statisticsFor: aString
		type: SQL_INDEX_ALL
		accurate: true!

initialize
	"Private - Initialize the receiver."

	flags := self defaultFlags.
	self initializeStatements!

initializeStatements
	statements := WeakSet new!

invalidateAllStmts
	"Private - Free all statements under this connection"

	self statements do: [:s | s free]!

isReadOnly
	"Answer whether the receiver's access mode option is set to read-only."

	^(self getDWordAttribute: SQL_ATTR_ACCESS_MODE) = SQL_MODE_READ_ONLY!

isReadOnly: aBoolean 
	"Set whether the receiver's access mode option is read-only."

	self 
		setAttribute: SQL_ATTR_ACCESS_MODE
		value: (aBoolean ifTrue: [SQL_MODE_READ_ONLY] ifFalse: [SQL_MODE_READ_WRITE])
		size: SQL_IS_UINTEGER!

isSAGCompliant
	"Answer whether the DBMS to which the receiver is connected is SAG compliant."

	^(self getWordInfo: SQL_ODBC_SAG_CLI_CONFORMANCE) = SQL_OSCC_COMPLIANT!

isSourceReadOnly
	"Answer whether the data source is read only."

	^self getBoolInfo: SQL_DATA_SOURCE_READ_ONLY!

isTracing
	"Answer whether the receiver's trace option is set."

	^(self getDWordAttribute: SQL_ATTR_TRACE) = SQL_OPT_TRACE_ON!

isTracing: aBoolean 
	"Set whether the receiver's trace facility is on or off."

	self 
		setAttribute: SQL_ATTR_TRACE
		value: (aBoolean ifTrue: [SQL_OPT_TRACE_ON] ifFalse: [SQL_OPT_TRACE_OFF])
		size: SQL_IS_UINTEGER!

isTransactionCapable
	"Answer whether the DBMS to which the receiver is connected supports transactions."

	^self getWordInfo: SQL_TXN_CAPABLE!

loginTimeout
	"Answer the Integer value of the receiver's login timeout option."

	^self getDWordAttribute: SQL_ATTR_LOGIN_TIMEOUT!

loginTimeout: anInteger 
	"Set the receiver's login timeout to anInteger."

	self 
		setAttribute: SQL_ATTR_LOGIN_TIMEOUT
		value: anInteger
		size: SQL_IS_UINTEGER!

maxCatalogNameLength
	"Answer the <integer> maximum length of a catalog in the DBMS to which the receiver is connected."

	^self getWordInfo: SQL_MAX_CATALOG_NAME_LEN!

maxColumnNameLength
	"Answer the <integer> maximum length of a column in the DBMS to which the receiver is connected."

	^self getWordInfo: SQL_MAX_COLUMN_NAME_LEN!

maxConnections
	"Answer the <integer> maximum number of concurrent connections supported by the DBMS."

	^self getWordInfo: SQL_MAX_DRIVER_CONNECTIONS!

maxCursorNameLength
	"Answer the <integer> maximum length of a cursor in the DBMS to which the receiver is connected."

	^self getWordInfo: SQL_MAX_CURSOR_NAME_LEN
!

maxProcedureNameLength
	"Answer the <integer> maximum length of a procedure in the DBMS to which the receiver is connected."

	^self getWordInfo: SQL_MAX_PROCEDURE_NAME_LEN!

maxSchemaNameLength
	"Answer the <integer> maximum length of a schema name in the DBMS to which the receiver is connected."

	^self getWordInfo: SQL_MAX_SCHEMA_NAME_LEN!

maxStatements
	"Answer the maximum number of concurrent statements supported."

	^self getWordInfo: SQL_MAX_CONCURRENT_ACTIVITIES!

maxTableNameLength
	"Answer the maximum length of a table name"

	^self getWordInfo: SQL_MAX_TABLE_NAME_LEN!

newExceptionDetails: anInteger
	"Private - Answer a <DBExceptionDetails> instance that describes the state of the receiver following an exception with the specified <integer> return code. This will be available as the tag of a subsequent signalled DBError or DBWarning."

	^(self class newExceptionDetails: anInteger)
		hDBC: handle;
		yourself!

newParameterizedStatement: aSymbol 
	"Private - Answer a DBParameterizedStatement connected to the receiver"

	^DBParameterizedStatement parent: self cursorType: aSymbol!

newStatement: aSymbol
	"Private - Answer a DBStatement connected to the receiver and with the specified 
	cursor type."

	^DBStatement parent: self cursorType: aSymbol!

numericFunctions
	"Answers an array of the numeric functions available"

	| mask |
	mask := self getUInt32Info: SQL_NUMERIC_FUNCTIONS.
	^#('SQL_FN_NUM_ABS' 'SQL_FN_NUM_ACOS' 'SQL_FN_NUM_ASIN' 'SQL_FN_NUM_ATAN' 'SQL_FN_NUM_ATAN2' 'SQL_FN_NUM_CEILING' 'SQL_FN_NUM_COS' 'SQL_FN_NUM_COT' 'SQL_FN_NUM_EXP' 'SQL_FN_NUM_FLOOR' 'SQL_FN_NUM_LOG' 'SQL_FN_NUM_MOD' 'SQL_FN_NUM_SIGN' 'SQL_FN_NUM_SIN' 'SQL_FN_NUM_SQRT' 'SQL_FN_NUM_TAN' 'SQL_FN_NUM_PI' 'SQL_FN_NUM_RAND') 
		select: [:maskName | (mask bitAnd: (OS.ODBCConstants at: maskName)) ~= 0]!

odbcConformance
	"Answer the level of ODBC conformance:
		0	- none
		1	- Level 1
		2	- Level 2
	Note this info type is deprecated in ODBC 3.0"

	^self getWordInfo: SQL_ODBC_API_CONFORMANCE!

odbcSQLConformance
	"Answer the level of ODBC SQL conformance:
		0 - core
		1 - minimum
		2 - extended.
	Note this info type is deprecated in ODBC 3.0"

	^self getWordInfo: SQL_ODBC_SQL_CONFORMANCE!

odbcVersion
	"Answer the ODBC version"

	^self getStringInfo: SQL_ODBC_VER!

open
	"Open the receiver after prompting for the connection details, but only
	if not already connected."

	| connSz lenConnSz |
	handle isNull ifFalse: [^self].
	
	[| ret |
	"#1306: From MSDN, 'Applications should allocate at least 1,024 characters for [the connection string] buffer'"
	connSz := Utf16String newFixed: 2048.
	lenConnSz := ByteArray newFixed: 2.
	ret := OS.Odbc32
				sqlDriverConnect: self getHandle
				windowHandle: OS.User32 getActiveWindow
				inConnectionString: self connectString
				stringLength1: SQL_NTS
				outConnectionString: connSz
				bufferLength: connSz size + 1
				stringLength2Ptr: lenConnSz
				driverCompletion: (self useDriverCompletion
						ifTrue: [SQL_DRIVER_COMPLETE]
						ifFalse: [SQL_DRIVER_NOPROMPT]).
	ret == SQL_NO_DATA ifTrue: [^nil	"cancelled"].
	self dbCheckException: ret function: 'SQLDriverConnect']
			ifCurtailed: [self free].
	self connectString: (connSz copyFrom: 1 to: ((lenConnSz int16AtOffset: 0) min: connSz size))!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver. In
	the case of a DBConnection we need to ensure we don't try and share the same connection
	handle, and also any other data specific to that handle."

	super postCopy.
	handle := transaction := nil.
	self initializeStatements.
	^self!

prepare: aString 
	"Prepare the SQL in aString.
	Answer a new DBParameterizedStatement which is used to execute the SQL."

	^self prepare: aString cursorType: self defaultCursorType!

prepare: aString cursorType: aSymbol 
	"Prepare the SQL in the <readableString> argument, aString, into a new <DBParameterizedStatement>
	with the specified cursor type."

	| statement |
	statement := self newParameterizedStatement: aSymbol.
	statement prepare: aString.
	^statement!

primaryKeysOf: aString
	"Answer a list of the primary key column names in the
	table named aString"

	| stmt answer |
	stmt := DBPrimaryKeysStatement parent: self.
	stmt tableName: aString.
	answer := stmt results collect: [:each | each atIndex: 4	"at: 'column_name'"].
	stmt free.
	^answer!

printOn: aStream 
	"Append the ASCII representation of the receiver
	 to aStream."

	super printOn: aStream.
	aStream nextPut: $(.
	self dsn printOn: aStream.
	aStream nextPut: $)!

procedure: aStringQual owner: aStringOwner name: aStringName
	"Answer a list of procedures in the table(s) matching
	the specified criteria"

	| stmt answer |
	stmt := DBProceduresStatement parent: self.
	stmt
		catalogName: aStringQual;
		schemaName: aStringOwner;
		procedureName: aStringName.
	answer := stmt results collect: [:each | each atIndex: 3].
	stmt free.
	^answer!

procedures
	"Answer a <collection> of the <readableString> names of all the stored procedures in 
	the database."

	^self procedure: nil owner: nil name: nil.!

procedureTerm
	"Answer the <readableString> name for a 'stored-procedure' in the parlance of the DBMS to which the
	receiver is connected, e.g. in the case of Access this is 'QUERY'."

	^self getStringInfo: SQL_PROCEDURE_TERM!

pwd
	"Answer the password for the receiver"

	^pwd!

pwd: aString
	"Set the password for the receiver to aString"

	connectString := nil.
	pwd := aString!

query: aString 
	"Execute the SQL in aString.
	Answer a <DBResultSet> representing the resultant result set."

	^self query: aString cursorType: self defaultCursorType!

query: aString cursorType: aSymbol 
	^(self exec: aString cursorType: aSymbol) results!

query: aString forwardOnly: aBoolean 
	"Execute the SQL in aString.
	Answer a <DBResultSet> representing the results.
	If the <boolean> argument is true then the result set will
	support forward-only navigation, but will be substantially	
	faster in consequence, however it will tie up the entire
	connection until it is closed."

	^self query: aString
		cursorType: (aBoolean ifTrue: [#forwardOnly] ifFalse: [#keysetDriven])!

queryForeignKeysOf: aTableNameString
	"Private - Answer the DBResultSet for the standard query SQLForeignKeys()
	where szFkTableName is set to aTableNameString."

	| stmt answer |
	stmt := DBForeignKeysStatement parent: self.
	stmt foreignTableName: aTableNameString.
	answer := stmt results asArray.
	stmt free.
	^answer!

rollbackTxn
	"Rollback the receiver's transaction. Raise an error if there is no outstanding transaction."

	self transaction rollback.
	transaction := nil!

rowIdColumns: aString 
	"Answer the names of the columns constituting the 'best row ID' in the
	table named by the <String> argument."

	^self 
		specialColumns: SQL_BEST_ROWID
		qualifier: nil
		owner: nil
		name: aString
		scope: SQL_SCOPE_CURROW
		nullable: true	"Transaction"!

rowVersionColumns: aStringTableName 
	"Answer the names of the columns (if any) in the named table which are updated automatically
	by the datasource when a row is updated by any transaction (e.g. a timestamp)."

	^self 
		specialColumns: SQL_ROWVER
		qualifier: nil
		owner: nil
		name: aStringTableName
		scope: SQL_SCOPE_CURROW
		nullable: true	"Transaction"!

schemaTerm
	"Answer the <readableString> name for a 'schema' in the parlance of the DBMS to which the
	receiver is connected."

	^self getStringInfo: SQL_SCHEMA_TERM!

searchPatternEscape
	"Answer the search pattern escape character"

	^self getStringInfo: SQL_SEARCH_PATTERN_ESCAPE!

serverName
	"Answer the server name"

	^self getStringInfo: SQL_SERVER_NAME!

setAttribute: idInteger value: anIntegerOrStringOrBytes size: sizeInteger
	"Private - Set the an attribute of the receiver's connection."

	^self dbCheckException: (OS.Odbc32
				sqlSetConnectAttr: self asParameter
				attribute: idInteger
				valuePtr: anIntegerOrStringOrBytes
				stringLength: sizeInteger)
		function: 'SQLSetConnectAttr'!

setDefaultAttributes
	"Private - Set the default connection attributes."

	self 
		setAttribute: SQL_ATTR_ODBC_CURSORS
		value: SQL_CUR_USE_IF_NEEDED
		size: SQL_IS_UINTEGER!

specialColumns: anIntegerType qualifier: aStringQual owner: aStringOwner name: aStringName scope: anIntegerScope nullable: aBoolean
	"Answer a <collection> of the <readableString> names of special 
	columns matching the specified criteria."

	| stmt answer |
	stmt := DBSpecialColumnsStatement parent: self.
	stmt
		columnType: anIntegerType;
		catalogName: aStringQual;
		schemaName: aStringOwner;
		tableName: aStringName;
		scope: anIntegerScope;
		nullable: aBoolean.
	answer := Set new.
	stmt results do: [:each | answer add: (each atIndex: 2)].
	stmt free.
	^answer!

statements
	"Answer a set of active statements"

	^statements!

statisticsFor: aString type: anInteger accurate: aBoolean
	"Answer a collection of statistics for the table with aString name and anInteger type"

	| stmt answer |
	stmt := DBStatisticsStatement parent: self.
	stmt
		tableName: aString;
		type: anInteger;
		accurate: aBoolean.
	answer := stmt results asOrderedCollection.
	stmt free.
	^answer!

stringFunctions
	"Answer an array of string functions supported"

	| mask |
	mask := self getUInt32Info: SQL_STRING_FUNCTIONS.
	^#('SQL_FN_STR_ASCII' 'SQL_FN_STR_CHAR' 'SQL_FN_STR_CONCAT' 'SQL_FN_STR_INSERT' 'SQL_FN_STR_LCASE' 'SQL_FN_STR_LEFT' 'SQL_FN_STR_LENGTH' 'SQL_FN_STR_LOCATE' 'SQL_FN_STR_LTRIM' 'SQL_FN_STR_REPEAT' 'SQL_FN_STR_REPLACE' 'SQL_FN_STR_RIGHT' 'SQL_FN_STR_RTRIM' 'SQL_FN_STR_SUBSTRING' 'SQL_FN_STR_UCASE') 
		select: [:maskName | (mask bitAnd: (OS.ODBCConstants at: maskName)) ~= 0]!

supportedCursorTypes
	"Answer a <collection> of <Symbol>s, being the cursor types supported by the database to
	which the receiver is connected."

	| mask |
	mask := self getUInt32Info: SQL_SCROLL_OPTIONS.
	^self decodeBitMask: mask map: ScrollTypes!

supportedTransactionIsolationLevels
	"Answer a <collection> of the <Symbol>ic names of the transaction isolation levels
	supported by this connection."

	| mask answer |
	mask := self getUInt32Info: SQL_TXN_ISOLATION_OPTION.
	answer := OrderedCollection new.
	TxnIsolationLevels 
		keysAndValuesDo: [:eachKey :eachValue | (mask allMask: eachKey) ifTrue: [answer addLast: eachValue]].
	^answer!

supportsExpressionsInOrderBy
	"Answers whether the receiver supports expressions in a ORDER BY list"

	^self getBoolInfo: SQL_EXPRESSIONS_IN_ORDERBY!

supportsMultipleActiveTransactions
	"Answer whether multiple active transactions are supported."

	^self getBoolInfo: SQL_MULTIPLE_ACTIVE_TXN!

supportsMultipleResultSets
	"Answer whether multiple result sets are supported."

	^self getBoolInfo: SQL_MULT_RESULT_SETS!

supportsOuterJoins
	"Answer whether the receiver supports outer joins."

	^self getBoolInfo: SQL_OUTER_JOINS!

supportsRowUpdates
	"Answer whether the DBMS to which the receiver is connected supports row updates."

	^self getBoolInfo: SQL_ROW_UPDATES!

systemFunctions
	"Answer an array of system functions supported"

	| mask |
	mask := self getUInt32Info: SQL_SYSTEM_FUNCTIONS.
	^#('SQL_FN_SYS_DBNAME' 'SQL_FN_SYS_IFNULL' 'SQL_FN_SYS_USERNAME') 
		select: [:maskName | (mask bitAnd: (OS.ODBCConstants at: maskName)) ~= 0]!

tables
	"Answer a collection of all user tables on the database"

	^self tables: nil owners: nil tables: nil types: '''TABLE'''!

tables: aStringQualifier owners: aStringOwners tables: aStringTables types: aStringTypes
	"Answer a <collection> of the <readableString> names of the tables in
	the connected data source that match the specified criteria."

	| stmt answer |
	stmt := DBTablesStatement parent: self.
	stmt
		catalogName: aStringQualifier;
		schemaName: aStringOwners;
		tableName: aStringTables;
		tableType: aStringTypes.
	answer := stmt results collect: [:each | each atIndex: 3	"at: 'TABLE_NAME'"].
	stmt free.
	^answer!

tableTerm
	"Answer the underlying vendor name for a table"

	^self getStringInfo: SQL_TABLE_TERM!

timeDateFunctions
	"Answer an array of available date and time functions"

	| mask |
	mask := self getUInt32Info: SQL_TIMEDATE_FUNCTIONS.
	^#('SQL_FN_TD_NOW' 'SQL_FN_TD_CURDATE' 'SQL_FN_TD_DAYOFMONTH' 'SQL_FN_TD_DAYOFWEEK' 'SQL_FN_TD_DAYOFYEAR' 'SQL_FN_TD_MONTH' 'SQL_FN_TD_QUARTER' 'SQL_FN_TD_WEEK' 'SQL_FN_TD_YEAR' 'SQL_FN_TD_CURTIME' 'SQL_FN_TD_HOUR' 'SQL_FN_TD_MINUTE' 'SQL_FN_TD_SECOND') 
		select: [:maskName | (mask bitAnd: (OS.ODBCConstants at: maskName)) ~= 0]!

traceFile
	"Answer a String containing the value of the receiver's trace file option."

	^self getStringAttribute: SQL_ATTR_TRACEFILE!

traceFile: aString
	"Set the receiver's trace facility on, outputting to the trace file specified by aString."

	self 
		setAttribute: SQL_ATTR_TRACEFILE
		value: aString asUtf16String
		size: SQL_NTS.
	self isTracing: true!

transaction
	"Answer the outstanding DBTransaction. Throw an exception if there isn't one."

	transaction isNil
		ifTrue: [self error: self printString, ' has no active transaction.'].
	^transaction!

transaction: aDBTxn 
	"Private - Set the receiver's transaction to aDBTxn. Throw an exception if one exists already."

	transaction notNil 
		ifTrue: [self error: self printString , ' already has an active transaction'].
	transaction := aDBTxn.
	self willAutoCommit: transaction isNil!

transactionIsolation
	"Answer the receiver's Transaction Isolation Level."

	^TxnIsolationLevels at: (self getDWordAttribute: SQL_ATTR_TXN_ISOLATION)!

transactionIsolation: aSymbol 
	"Set the receiver's transaction isolation level to that named by the <Symbol> argument
	(one of #readUncommitted, #readCommitted, #repeatableRead, or #serializable)."

	self 
		setAttribute: SQL_ATTR_TXN_ISOLATION
		value: (TxnIsolationLevels keyAtValue: aSymbol)
		size: SQL_IS_UINTEGER!

translate
	"Answer an Integer containing the value of receiver's Translate option."

	^self getDWordAttribute: SQL_ATTR_TRANSLATE_OPTION!

translate: anInteger 
	"Set the receiver's translate option to anInteger."

	self 
		setAttribute: SQL_ATTR_TRANSLATE_OPTION
		value: anInteger
		size: SQL_IS_UINTEGER!

translationDLL
	"Answer a String containing the value of the receiver's translate DLL option."

	^self getStringAttribute: SQL_ATTR_TRANSLATE_LIB!

translationDLL: aString 
	"Set the receiver's translate DLL option to aString."

	self 
		setAttribute: SQL_ATTR_TRANSLATE_LIB
		value: aString asUtf16String
		size: SQL_NTS!

typeInfo: anInteger
	| stmt info |
	stmt := (DBTypeInfoStatement parent: self)
				dataType: anInteger;
				yourself.
	info := stmt results asArray.
	stmt free.
	^info!

uid
	"Private - Answer the user identifier for the receiver"

	^uid!

uid: aString
	"Set the user identifier for the receiver to aString."

	connectString := nil.
	uid := aString!

uniqueIndicesOf: aString
	"Answer a <collection> of <DBRows> being details of the unique indices for the table with the specified <readableString> name."

	^self 
		statisticsFor: aString
		type: SQL_INDEX_UNIQUE
		accurate: true!

useDriverCompletion
	^flags allMask: DriverCompleteMask!

useDriverCompletion: aBoolean
	"Enable/disable the user of the SQL_DRIVER_COMPLETE option when opening this connection."

	flags := flags mask: DriverCompleteMask set: aBoolean!

userName
	"Answer the underlying user name for the receiver"

	^self getStringInfo: SQL_USER_NAME!

views
	"Answer a collection of all user tables on the database"

	^self tables: nil owners: nil tables: nil types: '''VIEW'''!

willAutoCommit
	"Answer whether the receiver's auto commit option is set."

	^(self getDWordAttribute: SQL_ATTR_AUTOCOMMIT) = SQL_AUTOCOMMIT_ON!

willAutoCommit: aBoolean 
	"Set whether the receiver's auto commit option is on or off."

	self 
		setAttribute: SQL_ATTR_AUTOCOMMIT
		value: (aBoolean ifTrue: [SQL_AUTOCOMMIT_ON] ifFalse: [SQL_AUTOCOMMIT_OFF])
		size: SQL_IS_UINTEGER! !

!Database.DBConnection categoriesForMethods!
allocStmtHandle:!helpers!private! !
asParameter!converting!public! !
basicConnect!operations!private! !
beginRWTxn!public!transactions! !
beginTxn!public!transactions! !
buildConnectString!helpers!private! !
catalogNameSeparator!enquiries!public! !
catalogTerm!enquiries!public! !
checkEmptyEnvironment!helpers!private! !
close!operations!public! !
closeNoFail!operations!public! !
columns:!enquiries!public! !
columns:qualifier:owner:table:!enquiries!public! !
commitTxn!public!transactions! !
connect!operations!public! !
connectString!accessing!public! !
connectString:!accessing!public! !
convertFunctions!enquiries!public! !
cursorCommitBehaviour!enquiries!public! !
cursorRollbackBehaviour!enquiries!public! !
databaseName!enquiries!public! !
dataSourceName!constants!enquiries!private! !
dbCheckException:function:!exceptions!private! !
dbmsName!enquiries!public! !
dbmsVersion!enquiries!public! !
decodeBitMask:map:!helpers!private! !
defaultCursorType!constants!public! !
defaultFlags!constants!private! !
defaultTransactionIsolation!enquiries!public! !
disconnect!operations!private! !
driverHDBC!accessing!private! !
driverHEnv!accessing!private! !
driverName!enquiries!public! !
driverVersion!enquiries!public! !
dsn!accessing!public! !
dsn:!accessing!public! !
exec:!executing!public! !
exec:cursorType:!executing!public! !
finalize!finalizing!private! !
free!private!realizing/unrealizing! !
freeNoFail!private!realizing/unrealizing! !
freeStmtHandle:!helpers!private! !
getBoolInfo:!enquiries!private! !
getDWordAttribute:!accessing!enquiries!private! !
getHandle!accessing!private! !
getHandle:!helpers!private! !
getStringAttribute:!accessing!private! !
getStringInfo:!enquiries!private! !
getUInt32Info:!enquiries!private! !
getWordInfo:!enquiries!private! !
hasAccessibleTables!enquiries!public!testing! !
hasIntegrityEnhancementFacility!enquiries!public!testing! !
identifierCase!enquiries!public! !
identifierQuoteCharacter!enquiries!public! !
indicesOf:!enquiries!public! !
initialize!initializing!private! !
initializeStatements!initializing!private! !
invalidateAllStmts!private!realizing/unrealizing! !
isReadOnly!accessing!public! !
isReadOnly:!accessing!public! !
isSAGCompliant!enquiries!public!testing! !
isSourceReadOnly!enquiries!public!testing! !
isTracing!public!testing! !
isTracing:!accessing!public! !
isTransactionCapable!enquiries!public!testing! !
loginTimeout!accessing!public! !
loginTimeout:!accessing!public! !
maxCatalogNameLength!enquiries!public! !
maxColumnNameLength!enquiries!public! !
maxConnections!enquiries!public! !
maxCursorNameLength!enquiries!public! !
maxProcedureNameLength!enquiries!public! !
maxSchemaNameLength!enquiries!public! !
maxStatements!enquiries!public! !
maxTableNameLength!enquiries!public! !
newExceptionDetails:!exceptions!private! !
newParameterizedStatement:!operations!private! !
newStatement:!operations!private! !
numericFunctions!enquiries!public! !
odbcConformance!enquiries!public! !
odbcSQLConformance!enquiries!public! !
odbcVersion!enquiries!public! !
open!operations!public! !
postCopy!copying!public! !
prepare:!executing!public! !
prepare:cursorType:!executing!public! !
primaryKeysOf:!enquiries!public! !
printOn:!printing!public! !
procedure:owner:name:!enquiries!public! !
procedures!enquiries!public! !
procedureTerm!enquiries!public! !
pwd!accessing!public! !
pwd:!accessing!public! !
query:!executing!public! !
query:cursorType:!executing!public! !
query:forwardOnly:!executing!public! !
queryForeignKeysOf:!enquiries!private! !
rollbackTxn!public!transactions! !
rowIdColumns:!enquiries!public! !
rowVersionColumns:!enquiries!public! !
schemaTerm!enquiries!public! !
searchPatternEscape!enquiries!public! !
serverName!enquiries!public! !
setAttribute:value:size:!accessing!private! !
setDefaultAttributes!helpers!private! !
specialColumns:qualifier:owner:name:scope:nullable:!enquiries!public! !
statements!accessing!public! !
statisticsFor:type:accurate:!enquiries!public! !
stringFunctions!enquiries!public! !
supportedCursorTypes!enquiries!public! !
supportedTransactionIsolationLevels!enquiries!public!testing! !
supportsExpressionsInOrderBy!enquiries!public!testing! !
supportsMultipleActiveTransactions!enquiries!public!testing! !
supportsMultipleResultSets!enquiries!public!testing! !
supportsOuterJoins!enquiries!public!testing! !
supportsRowUpdates!enquiries!public!testing! !
systemFunctions!enquiries!public! !
tables!enquiries!public! !
tables:owners:tables:types:!enquiries!public! !
tableTerm!enquiries!public! !
timeDateFunctions!enquiries!public! !
traceFile!accessing!public! !
traceFile:!accessing!public! !
transaction!public!transactions! !
transaction:!private!transactions! !
transactionIsolation!accessing!public! !
transactionIsolation:!accessing!public! !
translate!accessing!public! !
translate:!accessing!public! !
translationDLL!accessing!public! !
translationDLL:!accessing!public! !
typeInfo:!enquiries!public! !
uid!accessing!constants!private! !
uid:!accessing!public! !
uniqueIndicesOf:!enquiries!public! !
useDriverCompletion!accessing!public! !
useDriverCompletion:!accessing!public! !
userName!enquiries!public! !
views!enquiries!public! !
willAutoCommit!public!testing! !
willAutoCommit:!accessing!public! !
!

!Database.DBConnection class methodsFor!

allocEnvironmentHandle
	"Private - Answer the environment handle.
	Create it if we haven't done so already."

	self assert: [HEnv isNull].
	HEnv := External.Handle new.
	self dbCheckException: (OS.Odbc32
				sqlAllocHandle: SQL_HANDLE_ENV
				inputHandle: nil
				outputHandlePtr: HEnv)
		function: 'SQLAllocHandle'.
	self setDefaultEnvAttrs!

allocHandle
	"Private - Answer a new connection handle."

	| hDBC ret |
	hDBC := External.Handle new.
	ret := OS.Odbc32
				sqlAllocHandle: SQL_HANDLE_DBC
				inputHandle: self environmentHandle
				outputHandlePtr: hDBC.
	self dbCheckException: ret function: 'SQLAllocHandle'.
	^hDBC!

connections
	"Answer the <collection> of active connections."

	^Connections!

connectString: aString do: aTwoArgBlock 
	"Private - Interpret the connection string and pass the parameter name and value from each
	$; separated substring to aTwoArgBlock."

	"Implementation Note: We really need a mini-parser here to catch errors in the connection
	string, but for the sake of simplicity we use a less sophisticated approach that may yield
	incorrect results for some malformed connection strings (e.g. those missing the + separator
	between key and value pairs). This is considered less important than parsing well formed
	connection strings correctly."

	| stream |
	stream := aString readStream.
	
	[stream skipWhile: [:ch | ch == $;].
	stream atEnd] whileFalse: 
				[| paramName paramValue |
				paramName := stream upTo: $=.
				"Note that the value can be empty"
				paramValue := (stream peekFor: ${) ifTrue: [stream upTo: $}] ifFalse: [stream upTo: $;].
				aTwoArgBlock value: paramName value: paramValue]!

dbCheckException: anIntegerRetCode function: aString
	"Private - Checks anIntegerRetCode to see if a DBError or DBWarning should be signalled.
	Note that as of Dolphin 4.0, DBWarning is actually a notification, which is a more appropriate level of reporting for SQL_SUCCESS_WITH_INFO."

	anIntegerRetCode == SQL_SUCCESS
		ifFalse: 
			["Signal an error or warning - decide which"
			((anIntegerRetCode == SQL_SUCCESS_WITH_INFO or: [anIntegerRetCode == SQL_NO_DATA])
				ifTrue: [DBWarning]
				ifFalse: [DBError]) signal: aString with: (self newExceptionDetails: anIntegerRetCode)].
	^anIntegerRetCode!

enumerateDataSources
	"Answers an array of associations of all the data sources and their descriptions"

	| dsn description dsnLength descriptionLength hEnv ret sources |
	dsn := Utf16String newFixed: SQL_MAX_DSN_LENGTH.
	description := Utf16String newFixed: 4.
	dsnLength := External.Int16 new.
	descriptionLength := External.Int16 new.
	hEnv := self environmentHandle.
	
	[ret := OS.Odbc32
				sqlDataSources: hEnv
				direction: SQL_FETCH_FIRST
				serverName: dsn
				bufferLength1: ##(SQL_MAX_DSN_LENGTH + 1)
				nameLength1Ptr: dsnLength
				description: description
				bufferLength2: description size + 1
				nameLength2Ptr: descriptionLength.
	ret == SQL_SUCCESS_WITH_INFO]
			whileTrue: [description := Utf16String newFixed: descriptionLength value].
	sources := Array writeStream.
	[ret == SQL_SUCCESS] whileTrue: 
			[sources nextPut: (Association key: (dsn copyFrom: 1 to: dsnLength value)
						value: (description copyFrom: 1 to: descriptionLength value)).
			
			[ret := OS.Odbc32
						sqlDataSources: hEnv
						direction: SQL_FETCH_NEXT
						serverName: dsn
						bufferLength1: ##(SQL_MAX_DSN_LENGTH + 1)
						nameLength1Ptr: dsnLength
						description: description
						bufferLength2: description size + 1
						nameLength2Ptr: descriptionLength.
			ret == SQL_SUCCESS_WITH_INFO]
					whileTrue: [description := Utf16String newFixed: descriptionLength value]].
	ret ~= SQL_NO_DATA ifTrue: [self dbCheckException: ret function: 'SQLDataSources'].
	^sources contents!

environmentHandle
	"Private - Answer the environment handle. Create it if we haven't done so already."

	HEnv isNull ifTrue: [self allocEnvironmentHandle].
	^HEnv!

freeAll
	"Private - Free all of my instances which are recorded
	in the handle table.
	Use with care, only for getting out of nasty scrapes, as all
	connections will be closed, etc.!!"

	self connections do: [:each | each free].
	self newConnections.
	self freeEnvironment!

freeEnvironment
	"Private - Free the environment"

	HEnv isNull ifTrue: [^self].
	self dbCheckException: (OS.Odbc32 sqlFreeHandle: SQL_HANDLE_ENV handle: HEnv)
		function: 'SQLFreeHandle'.
	HEnv := nil!

initialize
	"Private - Initialize the receiver's class variable.s
		self initialize
	"

	DriverCompleteMask := 1.
	TxnIsolationLevels := IdentityDictionary new
				at: SQL_TXN_READ_UNCOMMITTED put: #readUncommitted;
				at: SQL_TXN_READ_COMMITTED put: #readCommitted;
				at: SQL_TXN_REPEATABLE_READ put: #repeatableRead;
				at: SQL_TXN_SERIALIZABLE put: #serializable;
				shrink;
				yourself.
	ScrollTypes := IdentityDictionary new
				at: SQL_SO_FORWARD_ONLY put: #forwardOnly;
				at: SQL_SO_DYNAMIC put: #dynamic;
				at: SQL_SO_KEYSET_DRIVEN put: #keysetDriven;
				at: SQL_SO_STATIC put: #static;
				at: SQL_SO_MIXED put: #mixed;
				shrink;
				yourself.
	self newConnections!

invalidateHandle: anExternalHandle
	"Private - Disconnect and free the specified connection handle.
	This is used by DBConnection class to free a connection handle
	when it only knows the handle"

	self dbCheckException: (OS.Odbc32 sqlDisconnect: anExternalHandle) function: 'SQLDisconnect'.
	self dbCheckException: (OS.Odbc32 sqlFreeHandle: SQL_HANDLE_DBC handle: anExternalHandle)
		function: 'SQLFreeHandle'!

new
	"Answer an initialized instance of the receiver."

	^(super new)
		initialize;
		beFinalizable;
		yourself!

newConnections
	Connections := WeakSet new!

newExceptionDetails: anInteger
	"Private - Answer a <DBExceptionDetails> instance that describes the state of the receiver following an exception with the specified <integer> return code. This will be available as the tag of a subsequent signalled DBError or DBWarning."

	^DBExceptionDetails code: anInteger hEnv: HEnv!

odbcVersion
	"self odbcVersion"

	| version |
	version := ByteArray newFixed: 2.
	self dbCheckException: (OS.Odbc32
				sqlGetEnvAttr: self environmentHandle
				infoType: SQL_ATTR_ODBC_VERSION
				infoValuePtr: version
				bufferLength: nil
				stringLengthPtr: nil)
		function: 'SQLGetEnvAttr'.
	^version int16AtOffset: 0!

requiredOdbcVersion
	^RequiredOdbcVersion ifNil: [RequiredOdbcVersion := SQL_OV_ODBC3_80]!

requiredOdbcVersion: anInteger
	"Set the ODBC version that will be requested when the environment handle is allocated. This is SQL_OV_ODBC3_80, i.e. 3.8, by default, but can be downgraded to ODBC 3.0 (SQL_OV_ODBC3). ODBC 2.0 is no longer supported."

	RequiredOdbcVersion = anInteger ifTrue: [^self].
	self freeAll.
	RequiredOdbcVersion := anInteger.
!

setDefaultEnvAttrs
	^self setRequiredOdbcVersion!

setRequiredOdbcVersion
	^self dbCheckException: (OS.Odbc32
				sqlSetEnvAttr: HEnv
				attribute: SQL_ATTR_ODBC_VERSION
				valuePtr: self requiredOdbcVersion
				stringLength: 0)
		function: 'SQLSetEnvAttr'!

transact: aDBConnection action: anInteger
	"Private - Performs the requested transaction action on the specified connection (which if Null implies that ODBC should commit/rollback all connections within the environment."

	| ret |
	ret := OS.Odbc32
				sqlEndTran: SQL_HANDLE_DBC
				handle: aDBConnection asParameter
				completionType: anInteger.
	aDBConnection ?? self dbCheckException: ret function: 'SQLEndTran'! !

!Database.DBConnection class categoriesForMethods!
allocEnvironmentHandle!accessing!private! !
allocHandle!helpers!private! !
connections!accessing!public! !
connectString:do:!operations!private! !
dbCheckException:function:!exceptions!private! !
enumerateDataSources!accessing!public! !
environmentHandle!accessing!private! !
freeAll!private!realizing/unrealizing! !
freeEnvironment!private!realizing/unrealizing! !
initialize!class initialization!private! !
invalidateHandle:!private!realizing/unrealizing! !
new!instance creation!public! !
newConnections!accessing!private! !
newExceptionDetails:!exceptions!private! !
odbcVersion!accessing!public! !
requiredOdbcVersion!accessing!public! !
requiredOdbcVersion:!accessing!public! !
setDefaultEnvAttrs!accessing!private! !
setRequiredOdbcVersion!accessing!private! !
transact:action:!operations!private! !
!

