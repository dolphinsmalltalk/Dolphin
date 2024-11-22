"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTest
	subclass: #'Database.Tests.MySqlDBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.MySqlDBTest guid: (Core.GUID fromString: '{76b4c290-77b5-4751-9315-875d5601a9f9}')!

Database.Tests.MySqlDBTest comment: ''!

!Database.Tests.MySqlDBTest methodsFor!

allDataTypes
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

categoriesColumns
	"Description is defined as MEDIUMTEXT, i.e. up to 16Mb. Picture is defined as LONGBLOB (up to 4Gb).
	See the comments in ordersColumns for an explanation of why the buffer length for 15 unicode chars is reported as 60 bytes."

	^{{'CategoryID'. SQL_INTEGER. 10. 0. 4}.
		{'CategoryName'. SQL_WVARCHAR. 15. nil. 60}.
		{'Description'. SQL_WLONGVARCHAR. 16 * 1024 * 1024 - 1. nil. 16 * 1024 * 1024 - 1}.
		{'Picture'. SQL_LONGVARBINARY. 16r7FFFFFFF. nil. -1}}!

columnTypeNameBlob
	^'longblob'!

columnTypeNameDouble
	^'DOUBLE'!

createTimeTestTable
	| colAttrs timeCol |
	colAttrs := self createTestTable: 'TIME'.
	"MySql returns the wrong column type for the TIME column from the metadata query."
	timeCol := colAttrs last.
	self assert: timeCol type equals: SQL_INTERVAL.
	self assertIsNil: timeCol scale.
	timeCol
		type: SQL_TYPE_TIME;
		scale: 0.
	^colAttrs!

databaseResource
	^MySqlNorthwindDB current!

defaultCursorCommitBehavior
	^SQL_CB_PRESERVE!

defaultCursorRollbackBehaviour
	^SQL_CB_PRESERVE!

defaultTransactionIsolation
	^#repeatableRead!

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

getTypeInfoDataTypeColumn
	"The documented column name for the ODBC data type enum value returned in the [SQLGetTypeInfo](https://learn.microsoft.com/en-us/sql/odbc/reference/syntax/sqlgettypeinfo-function) result set is SQL_DATA_TYPE. Another bug in the MySql ODBC driver is that the column name it returns is SQL_DATATYPE"

	^'SQL_DATATYPE'!

hasDateTimeOffsetDataType
	^false!

insertsNullForEmptyBinary
	^false!

insertsNullForEmptyBinaryIfUnbound
	^true!

matchInvalidDateTime: aDBError
	^($] split: aDBError description) last beginsWith: 'Incorrect datetime value:'!

ordersColumns
	"Note that for W[VAR]CHAR columns, the buffer size reports depends on the underlying representation, which is incorrect. We have the test DB set up for utf8mb4, causing MySql to report buffer sizes of x4 the character length. This should be the ODBC transfer size, and since the transfer is in UTF-16, it should be x2 the character length. This is a bug in the MySql Unicode ODBC driver. It also reports the wrong size octet transfer size for SqlColAttribute(.., SQL_DESC_OCTET_LENGTH, ..), although in that case the bug can be worse since when querying a SQL_VARCHAR column it will unecessarily map this to a SQL_WVARCHAR for transfer, yet report an octet transfer size appropriate for the byte characters.
	MySql still reports the pre-ODBC 3.0 SQL_TIMESTAMP type, rather than SQL_TYPE_TIMESTAMP."

	^{{'OrderID'. SQL_INTEGER. 10. 0. 4}.
		{'CustomerID'. SQL_VARCHAR.  5. nil. 5}.
		{'EmployeeID'. SQL_INTEGER. 10. 0. 4}.
		{'OrderDate'. SQL_TIMESTAMP. nil. nil. OS.SQL_TIMESTAMP_STRUCT byteSize}.
		{'RequiredDate'. SQL_TIMESTAMP. nil. nil. OS.SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShippedDate'. SQL_TIMESTAMP. nil. nil. OS.SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShipVia'. SQL_INTEGER. 10. 0. 4}.
		{'Freight'. SQL_DECIMAL. 10. 2. 12}.
		{'ShipName'. SQL_WVARCHAR. 40. nil. 160}.
		{'ShipAddress'. SQL_WVARCHAR. 60. nil. 240}.
		{'ShipCity'. SQL_WVARCHAR. 15. nil. 60}.
		{'ShipRegion'. SQL_WVARCHAR. 15. nil. 60}.
		{'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 40}.
		{'ShipCountry'. SQL_WVARCHAR. 15. nil. 60}}!

sqlStateInvalidDouble
	"HY000	General error	An error occurred for which there was no specific SQLSTATE and for which no implementation-specific SQLSTATE was defined. The error message returned by SQLGetDiagRec in the *MessageText buffer describes the error and its cause."

	^self sqlStateGeneralError!

sqlStateTruncatedString
	^self sqlStateGeneralError!

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

testColumnTypeDatetime
	| colAttrs dtCol insert resultSet timestamp dateAndTime date insertedValues expectedValues actualValues |
	colAttrs := self createTestTable: 'DATETIME'.
	dtCol := colAttrs last.
	self assertIsNil: dtCol precision.
	self assertIsNil: dtCol scale.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. dtCol name }.
	insert paramCols: colAttrs.
	date := Date today.
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.123+13:30'.
	timestamp := TimeStamp fromSeconds: 3905691359467 / 1000.
	insertedValues := { date. dateAndTime. timestamp. nil }.
	insertedValues keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'SELECT <1s> FROM <2s>' << { dtCol name. self temporaryTableName }.
	expectedValues := { date asDateAndTime. dateAndTime asLocal. timestamp asDateAndTime. nil }.
	actualValues := (resultSet collect: [:each | each at: dtCol name]) asArray.
	expectedValues with: actualValues
		do: 
			[:expected :actual |
			expected
				ifNil: [self assertIsNil: actual]
				ifNotNil: 
					[self
						assert: actual
						closeTo: expected
						precision: 1 seconds]].
	resultSet free.	"Invalid dates"
	insert values: { 100. Date newDay: 365 year: -1 }.
	self execShouldRaiseSqlInvalidDateFormat: insert.
	insert values: { 100. Date newDay: 1 year: 10000 }.
	self execShouldRaiseSqlInvalidDateFormat: insert!

testColumnTypeVarCharBoundOverflow
	| colAttrs vcharCol insert |
	self assert: DBVarFieldBuffer maxBoundOctetLength > 16.
	colAttrs := self createTestTable: 'varchar' qualifiers: #(16).
	vcharCol := colAttrs last.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. vcharCol name }.
	insert paramCols: colAttrs.
	insert values: { 100. 'abcdefghijklmnopq' }.
	"MySql in utf8mb4 mode reports 4x the column length, so the buffer is actually too large and we can store enough data into it to overflow the column"
	self execShouldRaiseDataTooLongForColumn: insert!

testColumnTypeVarCharUnbound
	| colAttrs vcharCol |
	DBVarFieldBuffer maxBoundOctetLength: DBVarFieldBuffer defaultMaxBoundOctetLength.
	colAttrs := self createTestTable: 'varchar' qualifiers: #(16).
	vcharCol := colAttrs last.
	self assert: vcharCol type equals: SQL_WVARCHAR.
	"Deliberately force use of long column transfer, i.e. calls to SQLGetData to retrieve the data rather than bound columns"
	DBVarFieldBuffer maxBoundOctetLength: 15.
	#(3 2) do: 
			[:transferLen |
			| insert resultSet strings |
			DBVarFieldBuffer.BlockTransferOctetLength := transferLen * 2.
			insert := self
						prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. vcharCol name }.
			insert paramCols: colAttrs.
			strings := (0 to: 13) collect: 
							[:i |
							| str |
							str := 'abcdefghijklmnop' copyFrom: 1 to: i.
							insert values: { i. str }.
							insert exec.
							str].
			"MySql treats SQLPutData of zero length the same as inserting a nil, which is incorrect."
			strings at: 1 put: nil.
			self assert: insert parameters last isKindOf: DBLongVarField.
			resultSet := self
						query: 'SELECT <1s> FROM <2s> ORDER BY ID' << { vcharCol name. self temporaryTableName }.
			self assert: (resultSet collect: [:each | each at: vcharCol name]) asArray equals: strings.
			resultSet free.
			insert free.
			self exec: 'DELETE FROM ' , self temporaryTableName]!

testColumnTypeWChar
	| colAttrs wcharCol insert resultSet str expectedValues actualValues |
	colAttrs := self createTestTable: self columnTypeNameWideChar qualifiers: #(7).
	wcharCol := colAttrs last.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. wcharCol name }.
	insert paramCols: colAttrs.
	expectedValues := (0 to: 7) collect: 
					[:i |
					str := 'abcdefgh' copyFrom: 1 to: i.
					insert values: { i. str }.
					insert exec.
					str , ('       ' copyFrom: 1 to: 7 - i)].
	resultSet := self query: 'SELECT <1s> FROM <2s>' << { wcharCol name. self temporaryTableName }.
	actualValues := (resultSet collect: [:each | each at: wcharCol name]) asArray.
	self assert: actualValues equals: expectedValues.
	resultSet free.
	insert values: { 100. 1 }.
	self
		should: [insert exec]
		raise: MessageNotUnderstood
		matching: [:ex | ex selector = #asUtf16String]!

testColumnTypeWCharExtendedChars
	"Two of (the many) bugs in the MySql ODBC driver show up here:
		1. Characters outside the BMP cannot be inserted through a bound parameter into a WCHAR column.
		2. The option to pad CHAR columns out to their fixed length (necessary for standards compliance, but not the normal behaviour of MySql) does not work correctly for wide characters occupying more than one UTF-8 code point. The calculation of the number of characters to pad seems to being made based on counting UTF-8 code units, not the UTF-16 code units that are actually placed in the buffer, so there may be junk at the end of the buffer since it may not get filled."

	self skip.
	super testColumnTypeWCharExtendedChars!

testColumnTypeWVarCharUnbound
	| colAttrs colAttr |
	DBVarFieldBuffer maxBoundOctetLength: DBVarFieldBuffer defaultMaxBoundOctetLength.
	colAttrs := self createTestTable: self columnTypeNameWideVarChar qualifiers: #(16).
	colAttr := colAttrs last.
	"The driver may choose to bind the varchar column as byte or wide chars."
	self assert: colAttr type equals: SQL_WVARCHAR.
	"Deliberately force use of long column transfer, i.e. calls to SQLGetData to retrieve the data rather than bound columns"
	DBVarFieldBuffer maxBoundOctetLength: 8.
	#(3 2) do: 
			[:transferLen |
			| insert resultSet strings |
			DBVarFieldBuffer.BlockTransferOctetLength := transferLen * 2.
			insert := self
						prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. colAttr name }.
			insert paramCols: colAttrs.
			strings := (0 to: 16) collect: 
							[:i |
							| str |
							str := 'abcdefghijklmnop' copyFrom: 1 to: i.
							insert values: { i. str }.
							insert exec.
							str].
			"MySql treats SQLPutData of zero length the same as inserting a nil, which is incorrect."
			strings at: 1 put: nil.
			self assert: insert parameters last isKindOf: DBLongVarField.
			resultSet := self
						query: 'SELECT <1s> FROM <2s> ORDER BY ID' << { colAttr name. self temporaryTableName }.
			self assert: (resultSet collect: [:r | r at: colAttr name]) asArray equals: strings.
			resultSet free.
			insert free.
			self exec: 'DELETE FROM ' , self temporaryTableName]!

testColumnTypeYear
	"MySQL has a special YEAR column type. which has no ODBC equivalent so should be mapped to an int, but note the handling of 2-digit values (see https://dev.mysql.com/doc/refman/8.4/en/year.html)."

	| colAttrs dtCol insert resultSet actualValues |
	colAttrs := self createTestTable: 'YEAR'.
	dtCol := colAttrs last.
	self assert: dtCol type equals: SQL_SMALLINT.
	self assertIsNil: dtCol precision.
	self assertIsNil: dtCol scale.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. dtCol name }.
	insert paramCols: colAttrs.
	{ 2024. 1901. 2155. nil. 0. 1. 69. 70. 71. 99 } keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'SELECT <1s> FROM <2s>' << { dtCol name. self temporaryTableName }.
	actualValues := (resultSet collect: [:each | each at: dtCol name]) asArray.
	self assert: actualValues equals: { 2024. 1901. 2155. nil. 2000. 2001. 2069. 1970. 1971. 1999 }.
	resultSet free.
	"Invalid years"
	#(-1 1900 2156) do: 
			[:each |
			insert values: { 100. each }.
			self execShouldRaiseSqlNumberOutOfRange: insert]! !

!Database.Tests.MySqlDBTest categoriesForMethods!
allDataTypes!constants!private! !
categoriesColumns!constants!private! !
columnTypeNameBlob!constants!private! !
columnTypeNameDouble!constants!private! !
createTimeTestTable!public! !
databaseResource!accessing!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
defaultTransactionIsolation!constants!private! !
execShouldRaiseDataTooLongForColumn:!helpers!private! !
execShouldRaiseSqlDateOverflow:!private! !
execShouldRaiseSqlInvalidDateFormat:!private! !
execShouldRaiseSqlNumberOutOfRange:!private! !
getTypeInfoDataTypeColumn!constants!private! !
hasDateTimeOffsetDataType!private!testing! !
insertsNullForEmptyBinary!constants!private! !
insertsNullForEmptyBinaryIfUnbound!constants!private! !
matchInvalidDateTime:!helpers!private! !
ordersColumns!constants!private! !
sqlStateInvalidDouble!constants!private! !
sqlStateTruncatedString!constants!private! !
supportsReadOnlyMode!private!testing! !
testCharacterSetConfiguration!public!unit tests! !
testColumnTypeDatetime!public!unit tests! !
testColumnTypeVarCharBoundOverflow!public!unit tests! !
testColumnTypeVarCharUnbound!public!unit tests! !
testColumnTypeWChar!public!unit tests! !
testColumnTypeWCharExtendedChars!public!unit tests! !
testColumnTypeWVarCharUnbound!public!unit tests! !
testColumnTypeYear!public!unit tests! !
!

!Database.Tests.MySqlDBTest class methodsFor!

allUnsupportedTests
	"Answer a collection of the selectors of all tests that exercise functionality that is not supported by the tested DBMS."

	^#(#testColumnTypeDatetimeOffset)!

resources
	^{MySqlNorthwindDB}! !

!Database.Tests.MySqlDBTest class categoriesForMethods!
allUnsupportedTests!Accessing!public! !
resources!accessing!public! !
!

