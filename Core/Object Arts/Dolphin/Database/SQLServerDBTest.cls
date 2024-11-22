"Filed out from Dolphin Smalltalk"!

DBConnectionTest subclass: #SQLServerDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SQLServerDBTest guid: (GUID fromString: '{375baeed-7973-4ad7-bb24-296438e82792}')!

SQLServerDBTest comment: ''!

!SQLServerDBTest categoriesForClass!Unclassified! !

!SQLServerDBTest methodsFor!

allDataTypes
	^{
		'bigint' -> SQL_BIGINT.
		'bigint identity' -> SQL_BIGINT.
		'binary' -> SQL_BINARY.
		'bit' -> SQL_BIT.
		'char' -> SQL_CHAR.
		'date' -> SQL_DATETIME.
		'datetime' -> SQL_DATETIME.
		'datetime2' -> SQL_DATETIME.
		'datetimeoffset' -> SQL_SS_TIMESTAMPOFFSET.
		'decimal' -> SQL_DECIMAL.
		'decimal() identity' -> SQL_DECIMAL.
		'float' -> SQL_FLOAT.
		'image' -> SQL_LONGVARBINARY.
		'int' -> SQL_INTEGER.
		'int identity' -> SQL_INTEGER.
		'money' -> SQL_DECIMAL.
		'nchar' -> SQL_WCHAR.
		'ntext' -> SQL_WLONGVARCHAR.
		'numeric' -> SQL_NUMERIC.
		'numeric() identity' -> SQL_NUMERIC.
		'nvarchar' -> SQL_WVARCHAR.
		'real' -> SQL_REAL.
		'smalldatetime' -> SQL_DATETIME.
		'smallint' -> SQL_SMALLINT.
		'smallint identity' -> SQL_SMALLINT.
		'smallmoney' -> SQL_DECIMAL.
		'sql_variant' -> SQL_SS_VARIANT.
		'sysname' -> SQL_WVARCHAR.
		'text' -> SQL_LONGVARCHAR.
		'time' -> SQL_SS_TIME2.
		'timestamp' -> SQL_BINARY.
		'tinyint' -> SQL_TINYINT.
		'tinyint identity' -> SQL_TINYINT.
		'uniqueidentifier' -> SQL_GUID.
		'varbinary' -> SQL_VARBINARY.
		'varchar' -> SQL_VARCHAR.
		'xml' -> SQL_SS_XML
	}!

categoriesColumns
	^{{'CategoryID'. SQL_INTEGER. 10. 0. 4}.
		{'CategoryName'. SQL_WVARCHAR. 15. nil. 30}.
		{'Description'. SQL_WVARCHAR. SQL_SS_LENGTH_UNLIMITED. nil. SQL_SS_LENGTH_UNLIMITED}.
		{'Picture'. SQL_LONGVARBINARY. 16r7FFFFFFF. nil. 16r7FFFFFFF}}!

columnTypeNameBlob
	^'image'!

databaseResource
	^SQLServerNorthwindDB current!

dbmsFeaturesMap
	"Private - Deliberately leave outer #serverName as this will vary by configuration"

	^(LookupTable new)
		at: #dbmsName put: #(#sameAs: 'Microsoft SQL Server');
		at: #defaultTransactionIsolation put: #(#== #readCommitted);
		at: #hasAccessibleTables put: #(#== true);
		at: #hasIntegrityEnhancementFacility put: #(#== true);
		at: #identifierCase put: #(#= ##(SQL_IC_MIXED));
		at: #identifierQuoteCharacter put: #(#= ##($"));
		at: #isSAGCompliant put: #(#== false);
		at: #isSourceReadOnly put: #(#== false);
		at: #maxCatalogNameLength put: #(#= 128);
		at: #maxColumnNameLength put: #(#= 128);
		at: #maxConnections put: #(#= 0);
		at: #maxCursorNameLength put: #(#= 128);
		at: #maxProcedureNameLength put: #(#= 134);
		at: #maxSchemaNameLength put: #(#= 128);
		at: #maxStatements put: #(#= 1);
		at: #maxTableNameLength put: #(#= 128);
		at: #odbcConformance put: #(#= 2);
		at: #odbcSQLConformance put: #(#= 1);
		at: #procedureTerm put: #(#sameAs: 'stored procedure');
		at: #schemaTerm put: #(#sameAs: 'owner');
		at: #catalogTerm put: #(#sameAs: 'database');
		at: #tableTerm put: #(#sameAs: 'table');
		at: #supportedCursorTypes
			put: #(#noDifference: #(#forwardOnly #keysetDriven #static #dynamic));
		at: #supportedTransactionIsolationLevels
			put: #(#noDifference: #(#readUncommitted #readCommitted #serializable #repeatableRead));
		at: #supportsExpressionsInOrderBy put: #(#== true);
		at: #supportsMultipleActiveTransactions put: #(#== true);
		at: #supportsMultipleResultSets put: #(#== true);
		at: #supportsOuterJoins put: #(#== false);
		at: #supportsRowUpdates put: #(#== false);
		at: #userName put: #(#= 'dbo');
		at: #convertFunctions put: #(#noDifference: #('SQL_FN_CVT_CONVERT'));
		at: #searchPatternEscape put: #(#= '\');
		yourself!

hasIntervalDataType
	"Most DB's do support INTERVAL data types in the DB (MS SQL Server and Access being exceptions), although ODBC driver support to map this to SQL_INTERVAL_STRUCTs is largely missing."

	^false!

invalidDatesAndTimesWithOffset
	^{
		DateAndTime fromString: ' 9999-12-31T00:20:34.1234567+14:01'.
		DateAndTime year: 0 day: 366.
		Date newDay: 365 year: -1.
		Date newDay: 1 year: 10000
	}!

orderDetailsTable
	^'"Order Details"'!

scaleOfTimeColumns
	"SQL will TIME2 data type, substituted for TIME, has with fractional seconds to 7 places (i.e. 100nS intervals)."

	^7!

sqlDataTypeTime
	"SQL will actually create a TIME2 column for TIME, with fractional seconds, not the old style SQL_TYPE_TIME column. This is an extended format that only actually works in ODBC 3.8 as in ODBC 3.0 the driver manager bars on extended SQL_C_XXX types, even though it returns the extended SQL_SS_TYPE"

	^SQL_SS_TIME2!

sqlStateInvalidDouble
	^'42000'!

testBitColumn
	| colAttrs bitCol insert resultSet values |
	colAttrs := self createTestTable: 'BIT'.
	bitCol := colAttrs last.
	insert := self
				prepare: 'INSERT INTO <1s> (ID, <2s>) VALUES (?,?)' << {self temporaryTableName. bitCol name}.
	insert paramCols: colAttrs.
	values := #(true false nil).
	values keysAndValuesDo: 
			[:eachKey :eachValue |
			insert values: {eachKey. eachValue}.
			insert exec].
	resultSet := self query: 'SELECT <1s> FROM <2s>' << {bitCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: bitCol name]) asArray equals: values!

testColumnTypeDatetimeOffset
	"DATETIMEOFFSET is an extended SQL Server column type that extends datetime to include time zone offset. The default scale of the seconds is also more precise (7 rather than 3)"

	| colAttrs dtoCol insert resultSet date dateAndTime timestamp values |
	colAttrs := self createTestTable: 'DATETIMEOFFSET'.
	dtoCol := colAttrs last.
	self assert: dtoCol scale equals: 7.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. dtoCol name }.
	insert paramCols: colAttrs.
	date := Date today.
	"Default precision is 1mS, i.e. 3 decimal places for the seconds - we test elsewhere that the marshalling truncates correctly"
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.1234567+13:30'.
	timestamp := TimeStamp fromSeconds: 39056913591234567 / 1e7.
	values := {
				date.
				dateAndTime.
				timestamp.
				dateAndTime asTime.
				nil.
				dateAndTime offset: 13 hours + 59 minutes.
				dateAndTime offset: -13 hours - 59 minutes.
				dateAndTime offset: -14 hours.
				dateAndTime offset: 14 hours
			}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'SELECT <1s> FROM <2s>' << { dtoCol name. self temporaryTableName }.
	self assert: (resultSet collect: [:each | each at: dtoCol name]) asArray
		equals: (values collect: [:each | each ifNotNil: [each asDateAndTime]]).
	resultSet free.
	"Invalid dates"
	values := {
				dateAndTime offset: 14 hours + 1 minutes.
				DateAndTime year: 0 day: 366.
				Date newDay: 365 year: -1.
				Date newDay: 1 year: 10000
			}.
	values do: 
			[:each |
			insert values: { 100. each }.
			self execShouldRaiseSqlInvalidDateFormat: insert]!

testDatetime2Column
	"SQL server has a datetime2 column type which is the same as datetime, but with supporting more precise measurements down to 100nS rather than 1mS."

	| colAttrs dt2Col insert resultSet timestamp dateAndTime date |
	colAttrs := self createTestTable: 'DATETIME2'.
	dt2Col := colAttrs last.
	self assert: dt2Col scale equals: 7.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. dt2Col name }.
	insert paramCols: colAttrs.
	date := Date today.
	"Default precision is 100nS, i.e. 7 decimal places for the seconds - we test elsewhere that the marshalling truncates correctly"
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.1234567+13:30'.
	timestamp := TimeStamp date: (Date newDay: 1 year: 1) time: Time now.
	{ date. dateAndTime. timestamp. nil } keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'SELECT <1s> FROM <2s>' << { dt2Col name. self temporaryTableName }.
	self assert: (resultSet collect: [:each | each at: dt2Col name]) asArray
		equals: { date asDateAndTime. dateAndTime asLocal. timestamp asDateAndTime. nil }.
	resultSet free.
	"Invalid dates"
	{ Date newDay: 365 year: -1. Date newDay: 1 year: 10000 } do: 
			[:each |
			insert values: { 100. each }.
			self execShouldRaiseSqlInvalidDateFormat: insert]!

testExtendedDateAndTimeTypes
	"Example from https://learn.microsoft.com/en-us/sql/t-sql/data-types/datetimeoffset-transact-sql"

	| resultSet dateAndTime actual |
	resultSet := self
				query: 'SELECT CAST(''2007-05-08 12:35:29. 1234567 +12:15'' AS TIME(7)) AS ''time'',
    CAST(''2007-05-08 12:35:29. 1234567 +12:15'' AS DATE) AS ''date'',
    CAST(''2007-05-08 12:35:29.123'' AS SMALLDATETIME) AS ''smalldatetime'',
    CAST(''2007-05-08 12:35:29.123'' AS DATETIME) AS ''datetime'',
    CAST(''2007-05-08 12:35:29.1234567+12:15'' AS DATETIME2(7)) AS ''datetime2'',
    CAST(''2007-05-08 12:35:29.1234567 +12:15'' AS DATETIMEOFFSET(7)) AS ''datetimeoffset'',
    CAST(''2007-05-08 12:35:29.1234567+12:15'' AS DATETIMEOFFSET(7)) AS ''datetimeoffset IS08601'';'.
	self assert: resultSet size equals: 1.
	dateAndTime := DateAndTime fromString: '2007-05-08T12:35:29.1234567+12:15'.
	actual := resultSet first contents.
	self assert: actual size equals: 7.
	self assert: (actual at: 1) equals: (Time fromSeconds: dateAndTime seconds).
	self assert: (actual at: 2) equals: dateAndTime asDate.
	self assert: (actual at: 3)
		equals: (DateAndTime
				year: 2007
				month: 5
				day: 8
				hour: 12
				minute: 35
				second: 0).
	self assert: (actual at: 4)
		equals: (DateAndTime
				year: 2007
				month: 5
				day: 8
				hour: 12
				minute: 35
				second: 29123 / 1000).
	self assert: (actual at: 5)
		equals: (DateAndTime
				year: 2007
				month: 5
				day: 8
				hour: 12
				minute: 35
				second: 291234567 / 1e7).
	self assert: (actual at: 6) equals: dateAndTime.
	self assert: (actual at: 7) equals: dateAndTime!

testForeignKeysQuery
	| keys map |
	keys := connection queryForeignKeysOf: 'Orders'.
	self assert: keys size = 3.
	map := LookupTable new.
	keys do: [:each | map at: (each at: 'PKTABLE_NAME') put: each].
	#(#('Customers' 'CustomerID') #('Employees' 'EmployeeID') #('Shippers' 'ShipperID' 'ShipVia')) do: 
			[:each |
			| key |
			key := map at: each first.
			self assert: (key at: 'PKCOLUMN_NAME') = each second.
			self assert: (key at: 'FKCOLUMN_NAME') = each last]!

testGuidColumn
	| colAttrs guidCol insert resultSet examples |
	colAttrs := self createTestTable: 'UNIQUEIDENTIFIER'.
	guidCol := colAttrs last.
	insert := self
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. guidCol name}.
	insert paramCols: colAttrs.
	examples := {GUID new. GUID newUnique. nil}.
	examples keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := self query: 'select <1s> from <2s>' << {guidCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: guidCol name]) asArray equals: examples.
	resultSet free.
	insert values: {100. 1}.
	self execShouldRaiseTypeMismatch: insert!

testPrimaryKeysQuery
	| pkeys |
	pkeys := connection primaryKeysOf: 'Orders'.
	self assert: pkeys size = 1.
	self assert: pkeys first = 'OrderID'!

testProceduresQuery
	| procs |
	procs := connection procedures.
	self assert: (procs includes: 'Employee Sales by Country;1')!

testSQLServerConnectionAttributes
	connection transactionIsolation: #readUncommitted.
	self assert: connection transactionIsolation = #readUncommitted.
	connection loginTimeout: 30.
	self assert: connection loginTimeout = 30.
	connection translate: 1.
	self assert: connection translate = 1.
	self assert: connection translationDLL isEmpty.
	"SQL server seems to ignore this"
	connection translationDLL: 'sqlsort.dll'.
	self assert: connection translationDLL equals: 'sqlsort.dll'.
	self assert: connection uid notNil.
"	self assert: connection pwd notNil"!

testViewsQuery
	| views |
	views := connection
				tables: nil
				owners: 'dbo'
				tables: nil
				types: '''VIEW'''.
	self assert: (views
				noDifference: #('Alphabetical list of products' 'Category Sales for 1997' 'Current Product List' 'Customer and Suppliers by City' 'Invoices' 'Order Details Extended' 'Order Subtotals' 'Orders Qry' 'Product Sales for 1997' 'Products Above Average Price' 'Products by Category' 'Quarterly Orders' 'Sales by Category' 'Sales Totals by Amount' 'Summary of Sales by Quarter' 'Summary of Sales by Year'))!

validDoubleValues
	^{ nil. 0. -1. 3 / 8. Float fmax. Float fmin }! !

!SQLServerDBTest categoriesForMethods!
allDataTypes!constants!private! !
categoriesColumns!constants!private! !
columnTypeNameBlob!constants!private! !
databaseResource!helpers!private! !
dbmsFeaturesMap!constants!private! !
hasIntervalDataType!private!testing! !
invalidDatesAndTimesWithOffset!private! !
orderDetailsTable!constants!private! !
scaleOfTimeColumns!constants!private! !
sqlDataTypeTime!constants!private! !
sqlStateInvalidDouble!constants!private! !
testBitColumn!public!unit tests! !
testColumnTypeDatetimeOffset!public!unit tests! !
testDatetime2Column!public!unit tests! !
testExtendedDateAndTimeTypes!public!unit tests! !
testForeignKeysQuery!public!unit tests! !
testGuidColumn!public!unit tests! !
testPrimaryKeysQuery!public!unit tests! !
testProceduresQuery!public!unit tests! !
testSQLServerConnectionAttributes!public!unit tests! !
testViewsQuery!public!unit tests! !
validDoubleValues!constants!private! !
!

!SQLServerDBTest class methodsFor!

resources
	^{SQLServerNorthwindDB}! !

!SQLServerDBTest class categoriesForMethods!
resources!accessing!public! !
!

