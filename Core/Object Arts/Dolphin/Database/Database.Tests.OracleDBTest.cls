"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTest
	subclass: #'Database.Tests.OracleDBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.OracleDBTest guid: (Core.GUID fromString: '{9afce793-d0c9-4b6e-ab84-654850391cae}')!

Database.Tests.OracleDBTest comment: ''!

!Database.Tests.OracleDBTest methodsFor!

allDataTypes
	^{
		'BFILE' -> SQL_LONGVARBINARY.
		'BINARY_DOUBLE' -> SQL_FLOAT.
		'BINARY_FLOAT' -> SQL_REAL.
		'BLOB' -> SQL_LONGVARBINARY.
		'CHAR' -> SQL_CHAR.
		'CLOB' -> SQL_LONGVARCHAR.
		'DATE' -> SQL_DATETIME.
		'DECIMAL' -> SQL_DECIMAL.
		'DOUBLE PRECISION' -> SQL_DOUBLE.
		'LONG' -> SQL_LONGVARCHAR.
		'LONG RAW' -> SQL_LONGVARBINARY.
		'NCHAR' -> SQL_WCHAR.
		'NCLOB' -> SQL_WLONGVARCHAR.
		'NVARCHAR2' -> SQL_WVARCHAR.
		'RAW' -> SQL_VARBINARY.
		'VARCHAR2' -> SQL_VARCHAR
	}!

categoriesColumns
	^{{'CATEGORYID'. SQL_DECIMAL. 10. 0. 12}.
		{'CATEGORYNAME'. SQL_WVARCHAR. 15. nil. 30}.
		{'DESCRIPTION'. SQL_WLONGVARCHAR. 16r7FFFFFFF. nil. 16r7FFFFFFF}.
		{'PICTURE'. SQL_LONGVARBINARY. 16r7FFFFFFF. nil. 16r7FFFFFFF}}!

columnsOf: aString
	^super columnsOf: aString asUppercase!

columnTypeNameBlob
	^'BLOB'!

columnTypeNameDateTime
	^'TIMESTAMP'!

columnTypeNameDateTimeWithOffset
	^'TIMESTAMP (7) WITH TIME ZONE'.!

columnTypeNameVarBinary
	^'RAW'!

columnTypeNameWideVarChar
	^'NVARCHAR2'!

databaseName
	^''!

databaseResource
	^OracleNorthwindDB current!

dbName: aString 
	^aString asUppercase!

defaultCursorCommitBehavior
	^SQL_CB_PRESERVE!

defaultCursorRollbackBehaviour
	^SQL_CB_PRESERVE!

defaultDateTimeColumnScale
	^6!

execShouldRaiseSqlInvalidDateFormat: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex primaryError messageParts last = 'Invalid datetime format.']!

execShouldRaiseSqlNumberOutOfRange: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex nativeError = 1438]!

field: aString fromRow: aDBRow
	^aDBRow at: aString asUppercase!

hasFixedWidthBinaryDataType
	"Most DB's support SQL_BINARY (fixed-width binary, as opposed to variable-width SQL_VARBINARY), but Oracle does not. The RAW datatype is varbinary."

	^false!

hasTimeDataType
	^false!

insertsNullForEmptyBinary
	^true!

insertsNullForEmptyBinaryIfUnbound
	^true!

insertsNullForEmptyString
	"Oracle inserts a null instead of the empty string, which is clearly incorrect since empty string is a distinct value different to NULL."

	^true!

invalidDates
	^{ Date newDay: 365 year: -10000. Date newDay: 1 year: 10000 }!

ordersColumns
	"Note the weirdness that the ORDERDATE and SHIPPEDDATE columns configured in the DB as of type TIMESTAMP, and REQUIREDDATE defined as a DATE, all get reported as SQL_TIMESTAMP_STRUCT, as explained in the oracle docs:

		The semantics of Oracle DATE and TIMESTAMP data types do not correspond exactly with the ODBC data types with the same names. The Oracle DATE data type contains both date and time information while the SQL_DATE data type contains only date information. The Oracle TIMESTAMP data type also contains date and time information, but it has greater precision in fractional seconds. The ODBC driver reports the data types of both Oracle DATE and TIMESTAMP columns as SQL_TIMESTAMP to prevent information loss. Similarly, the ODBC driver binds SQL_TIMESTAMP parameters as Oracle TIMESTAMP values.

	However the buffer size TIMESTAMP column is reported as 11, but we get the expected 16 bytes for the DATE column. This is rather odd given that the TIMESTAMP data type has greater precision and so is presumably larger. In all cases a SQL_TIMESTAMP_STRUCT is transferred, so the buffer size for the order and ship dates is reported incorrectly by the driver."

	^{
		{ 'ORDERID'. SQL_DECIMAL. 10. 0. 12 }.
		{ 'CUSTOMERID'. SQL_CHAR. 5. nil. 5 }.
		{ 'EMPLOYEEID'. SQL_DECIMAL. 10. 0. 12 }.
		{ 'ORDERDATE'. SQL_TYPE_TIMESTAMP. 19. 6. 11 }.
		{ 'REQUIREDDATE'. SQL_TYPE_TIMESTAMP. 19. nil. OS.SQL_TIMESTAMP_STRUCT byteSize }.
		{ 'SHIPPEDDATE'. SQL_TYPE_TIMESTAMP. 19. 6. 11 }.
		{ 'SHIPVIA'. SQL_DECIMAL. 10. 0. 12 }.
		{ 'FREIGHT'. SQL_DECIMAL. 10. 2. 12 }.
		{ 'SHIPNAME'. SQL_WVARCHAR. 40. nil. 80 }.
		{ 'SHIPADDRESS'. SQL_WVARCHAR. 60. nil. 120 }.
		{ 'SHIPCITY'. SQL_WVARCHAR. 15. nil. 30 }.
		{ 'SHIPREGION'. SQL_WVARCHAR. 15. nil. 30 }.
		{ 'SHIPPOSTALCODE'. SQL_WVARCHAR. 10. nil. 20 }.
		{ 'SHIPCOUNTRY'. SQL_WVARCHAR. 15. nil. 30 }
	}!

orderTableRowIds
	^#('ROWID')!

rowIdColumnsOf: aString
	^super rowIdColumnsOf: aString asUppercase!

sqlStateTruncatedString
	^self sqlStateGeneralError!

tables
	| results tables |
	"Can't work out how to make the SQLTables function return the user tables"
	results := connection query: 'SELECT TABLE_NAME FROM USER_TABLES'.
	tables := results collect: [:each | each atIndex: 1].
	results free.
	^tables!

testColumnTypeDate
	| colAttrs dateCol insert resultSet timestamp dateAndTime date insertedValues actualValues expectedValues |
	colAttrs := self createTestTable: 'DATE'.
	dateCol := colAttrs last.
	self assert: dateCol type equals: SQL_TYPE_TIMESTAMP.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. dateCol name }.
	insert paramCols: colAttrs.
	date := Date today.
	dateAndTime := DateAndTime
				year: 9999
				day: 365
				seconds: 1234
				offset: 13.5 hours.
	timestamp := TimeStamp date: (Date newDay: 1 year: 1) time: Time now.
	insertedValues := { date. dateAndTime. timestamp. nil }.
	insertedValues keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'SELECT <1s> from <2s>' << { dateCol name. self temporaryTableName }.
	actualValues := (resultSet collect: [:each | each at: dateCol name]) asArray.
	expectedValues := insertedValues
				collect: [:each | each ifNotNil: [DateAndTime fromDate: each asDate time: each asTime]].
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
	resultSet free.
	"Invalid dates"
	self invalidDates do: 
			[:each |
			insert values: { 100. each }.
			self execShouldRaiseSqlInvalidDateFormat: insert]!

testColumnTypeVarBinaryUnbound
	"Driver appears to have an off-by-one error and drops the last byte in the `SQLPutData` call.
	It seems reasonable to conclude this is an Oracle bug, because the same test works correctly with all the other DBMSs that support varbinary columns."

	self skip.
	super testColumnTypeVarBinaryUnbound!

uniqueIndicesOf: aString
	^connection uniqueIndicesOf: aString asUppercase!

validDoubleValues
	^{ nil. 0. -1. 3 / 8. 1.0e38. -2.23e-308. Float fmin. }!

verifyInvalidFloatValues: aDBParameterizedStatement
	"Oracle doesn't allow non-finite Floats to be stored. The errors are sensible."

	{ Float infinity. Float negativeInfinity } do: 
			[:each |
			aDBParameterizedStatement values: { 100. each }.
			self
				should: [aDBParameterizedStatement exec]
				raise: DBError
				matching: [:ex | ex nativeError = 1426	"numeric overflow"]].
	aDBParameterizedStatement values: { 200. Float nan }.
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex nativeError = 3087	"unable to convert NaN to NUMBER"]! !

!Database.Tests.OracleDBTest categoriesForMethods!
allDataTypes!public! !
categoriesColumns!constants!private! !
columnsOf:!helpers!private! !
columnTypeNameBlob!constants!private! !
columnTypeNameDateTime!private! !
columnTypeNameDateTimeWithOffset!constants!private! !
columnTypeNameVarBinary!private! !
columnTypeNameWideVarChar!constants!private! !
databaseName!constants!private! !
databaseResource!accessing!private! !
dbName:!helpers!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
defaultDateTimeColumnScale!constants!private! !
execShouldRaiseSqlInvalidDateFormat:!private! !
execShouldRaiseSqlNumberOutOfRange:!private! !
field:fromRow:!helpers!private! !
hasFixedWidthBinaryDataType!private!testing! !
hasTimeDataType!private!testing! !
insertsNullForEmptyBinary!constants!private! !
insertsNullForEmptyBinaryIfUnbound!constants!private! !
insertsNullForEmptyString!constants!private! !
invalidDates!private! !
ordersColumns!constants!private! !
orderTableRowIds!constants!private! !
rowIdColumnsOf:!public! !
sqlStateTruncatedString!constants!private! !
tables!helpers!private! !
testColumnTypeDate!public!unit tests! !
testColumnTypeVarBinaryUnbound!public!unit tests! !
uniqueIndicesOf:!helpers!private! !
validDoubleValues!constants!private! !
verifyInvalidFloatValues:!helpers!private! !
!

!Database.Tests.OracleDBTest class methodsFor!

allUnsupportedTests
	"Answer a collection of the selectors of all tests that exercise functionality that is not supported by the tested DBMS."

	"- Oracle doesn't support fixed-width binary columns. The RAW datatype is like varbinary.
	- Oracle does not have a TIME data type, which is odd since it has DATE."

	^#(#testColumnTypeBinary #testColumnTypeTime)!

resources
	^{OracleNorthwindDB}! !

!Database.Tests.OracleDBTest class categoriesForMethods!
allUnsupportedTests!Accessing!public! !
resources!accessing!public! !
!

