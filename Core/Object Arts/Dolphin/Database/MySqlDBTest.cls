"Filed out from Dolphin Smalltalk"!

DBConnectionTest subclass: #MySqlDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySqlDBTest guid: (GUID fromString: '{76b4c290-77b5-4751-9315-875d5601a9f9}')!

MySqlDBTest comment: ''!

!MySqlDBTest categoriesForClass!Unclassified! !

!MySqlDBTest methodsFor!

allDataTypes
	^self useMariaDbOdbcDriver
		ifTrue: [self allDataTypesMariaDbOdbc]
		ifFalse: [self allDataTypesMySqlOdbc]!

allDataTypesMariaDbOdbc
	^{
		'BIGINT' -> SQL_BIGINT.
		'BIGINT UNSIGNED' -> SQL_BIGINT.
		'BINARY' -> SQL_BINARY.
		'BIT' -> SQL_BIT.
		'BLOB' -> SQL_LONGVARBINARY.
		'BOOL' -> SQL_BIT.
		'CHAR' -> SQL_WCHAR.
		'CHAR' -> SQL_CHAR.
		'DATE' -> SQL_TYPE_DATE.
		'DATETIME' -> SQL_TYPE_TIMESTAMP.
		'DECIMAL' -> SQL_DECIMAL.
		'DOUBLE' -> SQL_DOUBLE.
		'DOUBLE PRECISION' -> SQL_DOUBLE.
		'ENUM' -> SQL_VARCHAR.
		'FLOAT' -> SQL_FLOAT.
		'INT' -> SQL_INTEGER.
		'INT UNSIGNED' -> SQL_INTEGER.
		'INTEGER' -> SQL_INTEGER.
		'INTEGER UNSIGNED' -> SQL_INTEGER.
		'LONG VARBINARY' -> SQL_LONGVARBINARY.
		'LONG VARCHAR' -> SQL_WLONGVARCHAR.
		'LONG VARCHAR' -> SQL_LONGVARCHAR.
		'LONGBLOB' -> SQL_LONGVARBINARY.
		'LONGTEXT' -> SQL_LONGVARCHAR.
		'MEDIUMBLOB' -> SQL_LONGVARBINARY.
		'MEDIUMINT' -> SQL_INTEGER.
		'MEDIUMINT UNSIGNED' -> SQL_INTEGER.
		'MEDIUMTEXT' -> SQL_LONGVARCHAR.
		'NUMERIC' -> SQL_NUMERIC.
		'REAL' -> SQL_DOUBLE.
		'SET' -> SQL_VARCHAR.
		'SMALLINT' -> SQL_SMALLINT.
		'SMALLINT UNSIGNED' -> SQL_SMALLINT.
		'TEXT' -> SQL_LONGVARCHAR.
		'TIME' -> SQL_TYPE_TIME.
		'TIMESTAMP' -> SQL_TYPE_TIMESTAMP.
		'TINYBLOB' -> SQL_LONGVARBINARY.
		'TINYINT' -> SQL_TINYINT.
		'TINYINT UNSIGNED' -> SQL_TINYINT.
		'TINYTEXT' -> SQL_LONGVARCHAR.
		'VARBINARY' -> SQL_VARBINARY.
		'VARCHAR' -> SQL_WVARCHAR.
		'VARCHAR' -> SQL_VARCHAR
	}!

allDataTypesMySqlOdbc
	^{
		'bigint' -> SQL_BIGINT.
		'bigint auto_increment' -> SQL_BIGINT.
		'bigint unsigned' -> SQL_BIGINT.
		'bigint unsigned auto_increment' -> SQL_BIGINT.
		'binary' -> SQL_BINARY.
		'bit' -> SQL_BIT.
		'blob' -> SQL_LONGVARBINARY.
		'char' -> SQL_WCHAR.
		'char' -> SQL_CHAR.
		'date' -> SQL_DATETIME.
		'datetime' -> SQL_DATETIME.
		'decimal' -> SQL_DECIMAL.
		'double' -> SQL_FLOAT.
		'double' -> SQL_DOUBLE.
		'double auto_increment' -> SQL_FLOAT.
		'double auto_increment' -> SQL_DOUBLE.
		'float' -> SQL_REAL.
		'float auto_increment' -> SQL_REAL.
		'int' -> SQL_INTEGER.
		'int auto_increment' -> SQL_INTEGER.
		'int unsigned' -> SQL_INTEGER.
		'int unsigned auto_increment' -> SQL_INTEGER.
		'integer' -> SQL_INTEGER.
		'integer auto_increment' -> SQL_INTEGER.
		'integer unsigned' -> SQL_INTEGER.
		'integer unsigned auto_increment' -> SQL_INTEGER.
		'json' -> SQL_WLONGVARCHAR.
		'json' -> SQL_LONGVARCHAR.
		'long varbinary' -> SQL_LONGVARBINARY.
		'long varchar' -> SQL_LONGVARCHAR.
		'long varchar' -> SQL_LONGVARCHAR.
		'longblob' -> SQL_LONGVARBINARY.
		'longtext' -> SQL_LONGVARCHAR.
		'longtext' -> SQL_LONGVARCHAR.
		'mediumblob' -> SQL_LONGVARBINARY.
		'mediumint' -> SQL_INTEGER.
		'mediumint auto_increment' -> SQL_INTEGER.
		'mediumint unsigned' -> SQL_INTEGER.
		'mediumint unsigned auto_incremen' -> SQL_INTEGER.
		'mediumtext' -> SQL_LONGVARCHAR.
		'mediumtext' -> SQL_LONGVARCHAR.
		'numeric' -> SQL_NUMERIC.
		'smallint' -> SQL_SMALLINT.
		'smallint auto_increment' -> SQL_SMALLINT.
		'smallint unsigned' -> SQL_SMALLINT.
		'smallint unsigned auto_increment' -> SQL_SMALLINT.
		'text' -> SQL_LONGVARCHAR.
		'text' -> SQL_LONGVARCHAR.
		'time' -> SQL_DATETIME.
		'timestamp' -> SQL_DATETIME.
		'tinyblob' -> SQL_LONGVARBINARY.
		'tinyint' -> SQL_TINYINT.
		'tinyint auto_increment' -> SQL_TINYINT.
		'tinyint unsigned' -> SQL_TINYINT.
		'tinyint unsigned auto_increment' -> SQL_TINYINT.
		'tinytext' -> SQL_LONGVARCHAR.
		'tinytext' -> SQL_LONGVARCHAR.
		'varbinary' -> SQL_VARBINARY.
		'varchar' -> SQL_WVARCHAR.
		'varchar' -> SQL_VARCHAR.
		'year' -> SQL_SMALLINT
	}!

canDisableAutoCommit
	^self useMariaDbOdbcDriver not!

categoriesColumns
	"Description is defined as MEDIUMTEXT, i.e. up to 16Mb. Picture is defined as LONGBLOB (up to 4Gb).
	See the comments in ordersColumns for an explanation of why the buffer length for 15 unicode chars is reported as 60 bytes."

	| textColumnPrecision textColumnLength blobPrecision |
	textColumnPrecision := 16 * 1024 * 1024 - 1.
	self useMariaDbOdbcDriver
		ifTrue: 
			[textColumnLength := textColumnPrecision * 4.
			blobPrecision := -1]
		ifFalse: 
			[textColumnLength := textColumnPrecision.
			blobPrecision := 16r7FFFFFFF].
	^{
		{ 'CategoryID'. SQL_INTEGER. 10. 0. 4 }.
		{ 'CategoryName'. SQL_WVARCHAR. 15. nil. 60 }.
		{ 'Description'. SQL_WLONGVARCHAR. textColumnPrecision. nil. textColumnLength }.
		{ 'Picture'. SQL_LONGVARBINARY. blobPrecision. nil. -1 }
	}!

columnTypeNameBlob
	^'longblob'!

columnTypeNameDouble
	^'DOUBLE'!

createTimeTestTable
	| colAttrs timeCol |
	colAttrs := super createTimeTestTable.
	self useMariaDbOdbcDriver
		ifFalse: 
			["MySql returns the pre 3.x ODBC column type for the TIME column from the metadata query, which is a bug since it doesn't do this for result sets."
			timeCol := colAttrs last.
			self assert: timeCol type equals: SQL_INTERVAL.
			self assertIsNil: timeCol scale.
			timeCol
				type: SQL_TYPE_TIME;
				scale: 0].
	^colAttrs!

databaseResource
	^MySqlNorthwindDB current!

defaultCursorCommitBehavior
	^SQL_CB_PRESERVE!

defaultCursorRollbackBehaviour
	^SQL_CB_PRESERVE!

defaultDateTimeColumnScale
	^0!

defaultTransactionIsolation
	^#repeatableRead!

defaultYearColumnPrecision
	^self useMariaDbOdbcDriver ifTrue: [4]!

execShouldRaiseDataTooLongForColumn: insert
	self
		should: [insert exec]
		raise: DBError
		matching: 
			[:ex |
			"Data too long for column"
			ex nativeError = 1406]!

execShouldRaiseSqlDateOverflow: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22008'	"Datetime field overflow"]!

execShouldRaiseSqlInvalidDateFormat: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex nativeError = 1292]!

execShouldRaiseSqlNumberOutOfRange: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex nativeError = 1264]!

hasDateTimeOffsetDataType
	^false!

insertsNullForEmptyBinaryIfUnbound
	^self useMariaDbOdbcDriver not!

insertsNullForEmptyStringIfUnbound
	"MySql ODBC inserts a null instead of the empty string, which is clearly incorrect since empty string is a distinct value different to NULL. The MariaDB driver doesn't have the same bug."

	^self useMariaDbOdbcDriver not!

matchInvalidDateTime: aDBError
	^($] split: aDBError description) last beginsWith: 'Incorrect datetime value:'!

ordersColumns
	"Note that for W[VAR]CHAR columns, the buffer size reports depends on the underlying representation, which is incorrect. We have the test DB set up for utf8mb4, causing MySql to report buffer sizes of x4 the character length. This should be the ODBC transfer size, and since the transfer is in UTF-16, it should be x2 the character length. This is a bug in the MySql Unicode ODBC driver. It also reports the wrong size octet transfer size for SqlColAttribute(.., SQL_DESC_OCTET_LENGTH, ..), although in that case the bug can be worse since when querying a SQL_VARCHAR column it will unecessarily map this to a SQL_WVARCHAR for transfer, yet report an octet transfer size appropriate for the byte characters.
	MySql still reports the pre-ODBC 3.0 SQL_TIMESTAMP type, rather than SQL_TYPE_TIMESTAMP."

	| timestampType timestampPrecision varCharType |
	self useMariaDbOdbcDriver
		ifTrue: 
			[timestampType := SQL_TYPE_TIMESTAMP.
			timestampPrecision := 19.
			varCharType := self sqlDataTypeVarChar]
		ifFalse: [timestampType := SQL_TIMESTAMP. varCharType := SQL_VARCHAR].
	^{
		{ 'OrderID'. SQL_INTEGER. 10. 0. 4 }.
		{
			'CustomerID'.
			varCharType.
			5.
			nil.
			varCharType = SQL_WVARCHAR ifTrue: [5 * 4] ifFalse: [5]
		}.
		{ 'EmployeeID'. SQL_INTEGER. 10. 0. 4 }.
		{ 'OrderDate'. timestampType. timestampPrecision. nil. SQL_TIMESTAMP_STRUCT byteSize }.
		{ 'RequiredDate'. timestampType. timestampPrecision. nil. SQL_TIMESTAMP_STRUCT byteSize }.
		{ 'ShippedDate'. timestampType. timestampPrecision. nil. SQL_TIMESTAMP_STRUCT byteSize }.
		{ 'ShipVia'. SQL_INTEGER. 10. 0. 4 }.
		{ 'Freight'. SQL_DECIMAL. 10. 2. 12 }.
		{ 'ShipName'. SQL_WVARCHAR. 40. nil. 40 * 4 }.
		{ 'ShipAddress'. SQL_WVARCHAR. 60. nil. 60 * 4 }.
		{ 'ShipCity'. SQL_WVARCHAR. 15. nil. 15 * 4 }.
		{ 'ShipRegion'. SQL_WVARCHAR. 15. nil. 15 * 4 }.
		{ 'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 10 * 4 }.
		{ 'ShipCountry'. SQL_WVARCHAR. 15. nil. 15 * 4 }
	}!

queryTypeInfo: anInteger
	| sqlDataTypeColumnName |
	"The documented column name for the ODBC data type enum value returned in the [SQLGetTypeInfo](https://learn.microsoft.com/en-us/sql/odbc/reference/syntax/sqlgettypeinfo-function) result set is SQL_DATA_TYPE. Another bug in the MySql ODBC driver is that the column name has a typo and it returns SQL_DATATYPE. The Maria ODBC driver uses DATA_TYPE, which is probably not a typo, rather just ignoring the docs."
	sqlDataTypeColumnName := self useMariaDbOdbcDriver ifTrue: ['DATA_TYPE'] ifFalse: ['SQL_DATATYPE'].
	^(connection typeInfo: anInteger) collect: 
			[:each |
			"trimNulls is to workaround bug in MariaODBC driver that it reports the metadata names as SQL_WCHAR rather than SQL_VARCHAR and does not even pad with spaces."
			(each at: 'TYPE_NAME') trimNulls -> (each at: sqlDataTypeColumnName)]!

sqlDataTypeTimeStamp
	^self useMariaDbOdbcDriver ifTrue: [SQL_TYPE_TIMESTAMP] ifFalse: [SQL_TIMESTAMP]!

sqlDataTypeVarChar
	^SQL_WVARCHAR!

sqlStateInvalidDouble
	"HY000	General error	An error occurred for which there was no specific SQLSTATE and for which no implementation-specific SQLSTATE was defined. The error message returned by SQLGetDiagRec in the *MessageText buffer describes the error and its cause."

	^self databaseResource useMariaDbOdbcDriver
		ifTrue: [super sqlStateInvalidDouble]
		ifFalse: [self sqlStateGeneralError]!

sqlStateTruncatedString
	^self useMariaDbOdbcDriver
		ifTrue: [super sqlStateTruncatedString]
		ifFalse: [self sqlStateGeneralError]!

supportsReadOnlyMode
	^false!

testCharacterSetConfiguration
	"Verify that MySql and the test db are configured correctly."

	| resultSet vars |
	resultSet := self
				query: 'SHOW VARIABLES WHERE Variable_name LIKE ''character\_set\_%'' OR Variable_name LIKE ''collation%'';'.
	vars := LookupTable new.
	resultSet do: [:row | vars at: (row at: 'Variable_name') put: (row at: 'Value')].
	#('character_set_client' 'character_set_connection' 'character_set_database')
		do: [:each | self assert: (vars at: each) equals: 'utf8mb4']!

testColumnTypeWCharExtendedChars
	"Two of (the many) bugs in the MySql ODBC driver show up here:
		1. Characters outside the BMP cannot be inserted through a bound parameter into a WCHAR column.
		2. The option to pad CHAR columns out to their fixed length (necessary for standards compliance, but not the normal behaviour of MySql) does not work correctly for wide characters occupying more than one UTF-8 code point. The calculation of the number of characters to pad seems to being made based on counting UTF-8 code units, not the UTF-16 code units that are actually placed in the buffer, so there may be junk at the end of the buffer since it may not get filled."

	"The MariaDB ODBC driver can't handle the non-BMP char either, although it does at least raise a better error (it attempts to map to a 3-byte UTF-8 internally, which is of course impossible. This is despite requesting utf8mb4 char set in the driver DSN, and configuring for that in the test DB definition."

	self skip.
	super testColumnTypeWCharExtendedChars!

testColumnTypeYear
	"MySQL has a special YEAR column type. which has no ODBC equivalent so should be mapped to an int, but note the handling of 2-digit values (see https://dev.mysql.com/doc/refman/8.4/en/year.html)."

	| colAttrs column insert resultSet actualValues |
	colAttrs := self createTestTable: 'YEAR'.
	column := colAttrs last.
	self assert: column type equals: SQL_SMALLINT.
	self assert: column precision equals: self defaultYearColumnPrecision.
	self assertIsNil: column scale.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. column name }.
	insert paramCols: colAttrs.
	{ 2024. 1901. 2155. nil. 2000. 1. 69. 70. 71. 99 } keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'SELECT <1s> FROM <2s>' << { column name. self temporaryTableName }.
	actualValues := (resultSet collect: [:each | each at: column name]) asArray.
	self assert: actualValues equals: { 2024. 1901. 2155. nil. 2000. 2001. 2069. 1970. 1971. 1999 }.
	resultSet free.
	"Invalid years"
	#(-1 1900 2156) do: 
			[:each |
			insert values: { 100. each }.
			self execShouldRaiseSqlNumberOutOfRange: insert]!

useMariaDbOdbcDriver
	^self databaseResource useMariaDbOdbcDriver!

verifyBoundCharBufferOverflow: insert
	self execShouldRaiseDataTooLongForColumn: insert	"MySql in utf8mb4 mode reports 4x the column length, so the buffer is actually too large and we can store enough data into it to overflow the column"!

verifyInvalidDates: aDBParameterizedStatement
	aDBParameterizedStatement values: { 100. Date newDay: 365 year: -1 }.
	self execShouldRaiseSqlInvalidDateFormat: aDBParameterizedStatement.
	aDBParameterizedStatement values: { 100. Date newDay: 1 year: 10000 }.
	self useMariaDbOdbcDriver
		ifTrue: [self execShouldRaiseSqlInvalidDateFormat: aDBParameterizedStatement]
		ifFalse: [self execShouldRaiseSqlDateOverflow: aDBParameterizedStatement]!

verifyInvalidDateTimes: aDBParameterizedStatement
	self invalidDates keysAndValuesDo: 
			[:i :each |
			aDBParameterizedStatement values: { 100 + i. each }.
			self execShouldRaiseSqlInvalidDateFormat: aDBParameterizedStatement]! !

!MySqlDBTest categoriesForMethods!
allDataTypes!constants!private! !
allDataTypesMariaDbOdbc!constants!private! !
allDataTypesMySqlOdbc!constants!private! !
canDisableAutoCommit!public! !
categoriesColumns!constants!private! !
columnTypeNameBlob!constants!private! !
columnTypeNameDouble!constants!private! !
createTimeTestTable!helpers!private! !
databaseResource!accessing!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
defaultDateTimeColumnScale!constants!private! !
defaultTransactionIsolation!constants!private! !
defaultYearColumnPrecision!constants!private! !
execShouldRaiseDataTooLongForColumn:!helpers!private! !
execShouldRaiseSqlDateOverflow:!private! !
execShouldRaiseSqlInvalidDateFormat:!private! !
execShouldRaiseSqlNumberOutOfRange:!private! !
hasDateTimeOffsetDataType!private!testing! !
insertsNullForEmptyBinaryIfUnbound!private!testing! !
insertsNullForEmptyStringIfUnbound!private!testing! !
matchInvalidDateTime:!helpers!private! !
ordersColumns!constants!private! !
queryTypeInfo:!helpers!private! !
sqlDataTypeTimeStamp!constants!private! !
sqlDataTypeVarChar!constants!private! !
sqlStateInvalidDouble!constants!private! !
sqlStateTruncatedString!constants!private! !
supportsReadOnlyMode!private!testing! !
testCharacterSetConfiguration!public!unit tests! !
testColumnTypeWCharExtendedChars!public!unit tests! !
testColumnTypeYear!public!unit tests! !
useMariaDbOdbcDriver!private!testing! !
verifyBoundCharBufferOverflow:!helpers!private! !
verifyInvalidDates:!helpers!private! !
verifyInvalidDateTimes:!helpers!private! !
!

!MySqlDBTest class methodsFor!

resources
	^{MySqlNorthwindDB}! !

!MySqlDBTest class categoriesForMethods!
resources!accessing!public! !
!

