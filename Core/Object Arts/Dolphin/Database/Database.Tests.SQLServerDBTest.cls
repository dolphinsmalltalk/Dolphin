"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTest
	subclass: #'Database.Tests.SQLServerDBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.SQLServerDBTest guid: (Core.GUID fromString: '{375baeed-7973-4ad7-bb24-296438e82792}')!

Database.Tests.SQLServerDBTest comment: ''!

!Database.Tests.SQLServerDBTest methodsFor!

categoriesColumns
	^{{'CategoryID'. SQL_INTEGER. 10. 0. 4}.
		{'CategoryName'. SQL_WVARCHAR. 15. nil. 30}.
		{'Description'. SQL_WVARCHAR. SQL_SS_LENGTH_UNLIMITED. nil. SQL_SS_LENGTH_UNLIMITED}.
		{'Picture'. SQL_LONGVARBINARY. 16r7FFFFFFF. nil. 16r7FFFFFFF}}!

databaseName
	^'northwind'!

databaseResource
	^SQLServerNorthwindDB current!

dataSourceName
	^connection dsn!

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

ordersColumns
	"Timestamps default to milliseconds precision"

	^{{'OrderID'. SQL_INTEGER. 10. 0. 4}.
		{'CustomerID'. SQL_WCHAR. 5. nil. 10}.
		{'EmployeeID'. SQL_INTEGER. 10. 0. 4}.
		{'OrderDate'. SQL_TYPE_TIMESTAMP. 23. 3. Smalltalk.SQL_TIMESTAMP_STRUCT byteSize}.
		{'RequiredDate'. SQL_TYPE_TIMESTAMP. 23. 3. Smalltalk.SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShippedDate'. SQL_TYPE_TIMESTAMP. 23. 3. Smalltalk.SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShipVia'. SQL_INTEGER. 10. 0. 4}.
		{'Freight'. SQL_DECIMAL. 19. 4. 22}.
		{'ShipName'. SQL_WVARCHAR. 40. nil. 80}.
		{'ShipAddress'. SQL_WVARCHAR. 60. nil. 120}.
		{'ShipCity'. SQL_WVARCHAR. 15. nil. 30}.
		{'ShipRegion'. SQL_WVARCHAR. 15. nil. 30}.
		{'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 20}.
		{'ShipCountry'. SQL_WVARCHAR. 15. nil. 30}}!

testBitColumn
	| colAttrs bitCol insert resultSet values |
	colAttrs := self createTestTable: 'bit'.
	bitCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID, <2s>) VALUES (?,?)' << {self temporaryTableName. bitCol name}.
	insert paramCols: colAttrs.
	values := #(true false nil).
	values keysAndValuesDo: 
			[:eachKey :eachValue |
			insert values: {eachKey. eachValue}.
			insert exec].
	resultSet := connection query: 'select <1s> from <2s>' << {bitCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: bitCol name]) asArray equals: values.
	resultSet free!

testCharColumn
	| colAttrs charCol insert resultSet str strings |
	colAttrs := self createTestTable: 'char' qualifiers: #(7).
	charCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?, ?)' << {self temporaryTableName. charCol name}.
	insert paramCols: colAttrs.
	strings := (0 to: 7) collect: 
					[:i |
					str := 'abcdefg' copyFrom: 1 to: i.
					insert values: {i. str}.
					insert exec.
					str , ('       ' copyFrom: 1 to: 7 - i)].
	resultSet := connection query: 'select <1s> from <2s>' << {charCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: charCol name]) asArray equals: strings.
	resultSet free.
	insert values: {strings size + 1. 'abcdefgh'}.
	self
		should: [insert exec]
		raise: BoundsError
		matching: [:ex | ex tag = 8].
	insert values: {strings size + 1. 1}.
	self
		should: [insert exec]
		raise: MessageNotUnderstood
		matching: [:ex | ex selector = #asAnsiString]!

testDateColumn
	| colAttrs dateCol insert resultSet timestamp dateAndTime date |
	colAttrs := self createTestTable: 'date'.
	dateCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. dateCol name}.
	insert paramCols: colAttrs.
	date := Date today.
	dateAndTime := DateAndTime
				year: 9999
				day: 365
				seconds: 1234
				offset: 13.5 hours.
	timestamp := TimeStamp date: (Date newDay: 1 year: 1) time: Time now.
	insert values: {1. date}.
	insert exec.
	insert values: {2. dateAndTime}.
	insert exec.
	insert values: {3. timestamp}.
	insert exec.
	insert values: {4. nil}.
	insert exec.
	resultSet := connection query: 'SELECT <1s> from <2s>' << {dateCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: dateCol name]) asArray
		equals: {date. dateAndTime asDate. timestamp asDate. nil}.
	resultSet free.
	"Invalid dates"
	insert values: {5. Date newDay: 365 year: -1}.
	self
		should: [insert exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22007'].
	insert values: {5. Date newDay: 1 year: 10000}.
	self
		should: [insert exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22007']!

testDatetime2Column
	"SQL server has a datetime2 column type which is the same as datetime, but with supporting more precise measurements down to 100nS rather than 1mS."

	| colAttrs dt2Col insert resultSet timestamp dateAndTime date |
	colAttrs := self createTestTable: 'datetime2'.
	dt2Col := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. dt2Col name}.
	insert paramCols: colAttrs.
	date := Date today.
	"Default precision is 100nS, i.e. 7 decimal places for the seconds - we test elsewhere that the marshalling truncates correctly"
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.1234567+13:30'.
	timestamp := TimeStamp date: (Date newDay: 1 year: 1) time: Time now.
	insert values: {1. date}.
	insert exec.
	insert values: {2. dateAndTime}.
	insert exec.
	insert values: {3. timestamp}.
	insert exec.
	insert values: {4. nil}.
	insert exec.
	resultSet := connection query: 'select <1s> from <2s>' << {dt2Col name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: dt2Col name]) asArray
		equals: {date asDateAndTime. dateAndTime asLocal. timestamp asDateAndTime. nil}.
	resultSet free.
	"Invalid dates"
	insert values: {5. Date newDay: 365 year: -1}.
	self
		should: [insert exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22007'].
	insert values: {5. Date newDay: 1 year: 10000}.
	self
		should: [insert exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22007'].
	insert free!

testDatetimeColumn
	| colAttrs dtCol insert resultSet timestamp dateAndTime date |
	colAttrs := self createTestTable: 'datetime'.
	dtCol := colAttrs last.
	self assert: dtCol scale equals: 3.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. dtCol name}.
	insert paramCols: colAttrs.
	date := Date today.
	"Default precision is 1mS, i.e. 3 decimal places for the seconds - we test elsewhere that the marshalling truncates correctly"
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.123+13:30'.
	timestamp := TimeStamp fromSeconds: 3905691359467 / 1000.
	insert values: {1. date}.
	insert exec.
	insert values: {2. dateAndTime}.
	insert exec.
	insert values: {3. timestamp}.
	insert exec.
	insert values: {4. nil}.
	insert exec.
	resultSet := connection query: 'select <1s> from <2s>' << {dtCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: dtCol name]) asArray
		equals: {date asDateAndTime. dateAndTime asLocal. timestamp asDateAndTime. nil}.
	resultSet free.
	"Invalid dates"
	insert values: {5. Date newDay: 365 year: -1}.
	self
		should: [insert exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22007'].
	insert values: {5. Date newDay: 1 year: 10000}.
	self
		should: [insert exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22007'].
	insert free!

testDatetimeOffsetColumn
	"datetimeoffset is an extended SQL Server column type that extends datetime to include time zone offset. The default scale of the seconds is also more precise (7 rather than 3)"

	| colAttrs dtoCol insert resultSet date dateAndTime timestamp values |
	colAttrs := self createTestTable: 'datetimeoffset'.
	dtoCol := colAttrs last.
	self assert: dtoCol scale equals: 7.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. dtoCol name}.
	insert paramCols: colAttrs.
	date := Date today.
	"Default precision is 1mS, i.e. 3 decimal places for the seconds - we test elsewhere that the marshalling truncates correctly"
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.1234567+13:30'.
	timestamp := TimeStamp fromSeconds: 39056913591234567 / 1e7.
	values := {date.
				dateAndTime.
				timestamp.
				dateAndTime asTime.
				nil.
				dateAndTime offset: 13 hours + 59 minutes.
				dateAndTime offset: -13 hours - 59 minutes.
				dateAndTime offset: -14 hours.
				dateAndTime offset: 14 hours}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := connection query: 'select <1s> from <2s>' << {dtoCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: dtoCol name]) asArray
		equals: (values collect: [:each | each ifNotNil: [each asDateAndTime]]).
	resultSet free.
	"Invalid dates"
	values := {dateAndTime offset: 14 hours + 1 minutes.
				DateAndTime year: 0 day: 366.
				Date newDay: 365 year: -1.
				Date newDay: 1 year: 10000}.
	values do: 
			[:each |
			insert values: {100. each}.
			self
				should: [insert exec]
				raise: DBError
				matching: [:ex | ex sqlState = '22007']].
	insert free!

testFloatColumn
	| colAttrs floatCol insert resultSet values |
	colAttrs := self createTestTable: 'float'.
	floatCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. floatCol name}.
	insert paramCols: colAttrs.
	values := {nil. 0. -1. 3 / 8. Float fmax. Float fmin}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := connection query: 'select <1s> from <2s>' << {floatCol name. self temporaryTableName}.
	(resultSet collect: [:each | each atIndex: 1]) with: values
		do: 
			[:actual :expected |
			expected isNil
				ifTrue: [self assertIsNil: actual]
				ifFalse: 
					[self
						assert: actual
						closeTo: expected
						precision: 0.001s]].
	resultSet free.
	"Invalid"
	values := {Float infinity. Float nan. Float negativeInfinity}.
	values do: 
			[:each |
			insert values: {100. each}.
			self
				should: [insert exec]
				raise: DBError
				matching: [:ex | ex sqlState = '42000']].
	insert free!

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
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. guidCol name}.
	insert paramCols: colAttrs.
	examples := {GUID new. GUID newUnique. nil}.
	examples keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := connection query: 'select <1s> from <2s>' << {guidCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: guidCol name]) asArray equals: examples.
	resultSet free.
	insert values: {100. 1}.
	self
		should: [insert exec]
		raise: OS.HRESULTError
		matching: [:ex | ex hresult = (OS.HRESULT fromPrimitiveFailureCode: Kernel._PrimitiveFailureCode.ObjectTypeMismatch)]!

testNumericColumn
	| colAttrs numericCol insert resultSet values |
	colAttrs := self createTestTable: 'numeric' qualifiers: #(10 3).
	numericCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. numericCol name}.
	insert paramCols: colAttrs.
	values := {nil. 1234567.891. 0. -1. 3 / 8. -9999999999 / 1000. 0.1234s}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := connection query: 'select <1s> from <2s>' << {numericCol name. self temporaryTableName}.
	(resultSet collect: [:each | each atIndex: 1]) with: values
		do: 
			[:actual :expected |
			expected isNil
				ifTrue: [self assertIsNil: actual]
				ifFalse: 
					[self
						assert: actual
						closeTo: expected
						precision: 0.001s]].
	resultSet free.
	"Invalid"
	values := {10000000000 / 1000}.
	values do: 
			[:each |
			insert values: {100. each}.
			self
				should: [insert exec]
				raise: DBError
				matching: [:ex | ex sqlState = '22003']].
	insert free!

testPrimaryKeysQuery
	| pkeys |
	pkeys := connection primaryKeysOf: 'Orders'.
	self assert: pkeys size = 1.
	self assert: pkeys first = 'OrderID'!

testProceduresQuery
	| procs |
	procs := connection procedures.
	self assert: (procs includes: 'Employee Sales by Country;1')!

testRealColumn
	| colAttrs realCol insert resultSet values |
	colAttrs := self createTestTable: 'real'.
	realCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. realCol name}.
	insert paramCols: colAttrs.
	values := {nil. 0. -1. 3 / 8. -3.4e38. -1.18e-38. 1.18e-38. 3.4e38. Float negativeZero}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := connection query: 'select <1s> from <2s>' << {realCol name. self temporaryTableName}.
	(resultSet collect: [:each | each atIndex: 1]) with: values
		do: 
			[:actual :expected |
			expected isNil
				ifTrue: [self assertIsNil: actual]
				ifFalse: 
					[self assert: actual isKindOf: Float.
					self assert: (String streamContents: [:s | actual printOn: s significantFigures: 7])
						equals: (String streamContents: [:s | expected asFloat printOn: s significantFigures: 7])]].
	resultSet free.
	"Invalid"
	values := {Float infinity. Float nan. Float negativeInfinity}.
	values do: 
			[:each |
			insert values: {100. each}.
			self
				should: [insert exec]
				raise: DBError
				matching: [:ex | ex sqlState = '42000']].
	insert free!

testSqlDateAndTimeTypes
	"Example from https://learn.microsoft.com/en-us/sql/t-sql/data-types/datetimeoffset-transact-sql"

	| resultSet dateAndTime actual |
	resultSet := connection
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
	self assert: (actual at: 7) equals: dateAndTime.
	resultSet free!

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

testTablesQuery
	| tables |
	self dropTestTable.
	tables := connection
				tables: nil
				owners: 'dbo'
				tables: nil
				types: '''TABLE'''.
	self assert: (tables
				noDifference: #('Categories' 'CustomerCustomerDemo' 'CustomerDemographics' 'Customers' 'Employees' 'EmployeeTerritories' 'Order Details' 'Orders' 'Products' 'Region' 'Shippers' 'Suppliers' 'Territories'))!

testTimeColumn
	"SQL will actually create a time2 column, with fractional seconds, not the old style SQL_TYPE_TIME column. This is an extended format that only actually works in ODBC 3.8 as in ODBC 3.0 the driver manager bars on extended SQL_C_XXX types, even though it returns the extended SQL_SS_TYPE"

	| colAttrs timeCol insert resultSet timestamp dateAndTime time |
	colAttrs := self createTestTable: 'time'.
	timeCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. timeCol name}.
	insert paramCols: colAttrs.
	time := Time now.
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.1234567+13:30'.
	timestamp := TimeStamp date: (Date newDay: 1 year: 1) time: Time now.
	insert values: {1. time}.
	insert exec.
	insert values: {2. dateAndTime}.
	insert exec.
	insert values: {3. timestamp}.
	insert exec.
	insert values: {4. nil}.
	insert exec.
	resultSet := connection query: 'select <1s> from <2s>' << {timeCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: timeCol name]) asArray
		equals: {time. dateAndTime asTime. timestamp asTime. nil}.
	resultSet free!

testVarCharColumn
	| colAttrs vcharCol |
	colAttrs := self createTestTable: 'varchar' qualifiers: #(16).
	vcharCol := colAttrs last.
	#(3 2 1) do: 
			[:transferLen |
			| insert resultSet strings |
			insert := connection
						prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. vcharCol name}.
			insert paramCols: colAttrs.
			strings := (0 to: 13) collect: 
							[:i |
							| str |
							str := 'abcdefghijklmnop' copyFrom: 1 to: i.
							insert values: {i. str}.
							insert exec.
							str].
			resultSet := connection query: 'select <1s> from <2s>' << {vcharCol name. self temporaryTableName}.
			self assert: (resultSet collect: [:each | each at: vcharCol name]) asArray equals: strings.
			resultSet free.
			insert values: {100. 'abcdefghijklmnopq'}.
			Smalltalk.DBVarFieldBuffer.MaxBoundOctetLength >= 16
				ifTrue: 
					["Because the parameter is bound, we pass the data through the bound buffer and detect overflow when attempting to populate the buffer"
					self should: [insert exec] raise: BoundsError]
				ifFalse: 
					["If the parameter is unbound because its length exceeds the maximum we are prepared to bind, then the data will be passed directly to the ODBC driver, and it will detect the overflow"
					self
						should: [insert exec]
						raise: DBError
						matching: [:ex | ex sqlState = '22001'	"String data, right truncation"]].
			insert free.
			connection exec: 'DELETE FROM ' , self temporaryTableName.
			"Deliberately force use of long column transfer, i.e. calls to SQLGetData to retrieve the data rather than bound columns"
			Smalltalk.DBVarFieldBuffer.BlockTransferOctetLength := transferLen + 1.
			Smalltalk.DBVarFieldBuffer.MaxBoundOctetLength := 15]!

testVarCharColumnUnbound
	| colAttrs vcharCol insert resultSet str strings |
	colAttrs := self createTestTable: 'varchar' qualifiers: #(15).
	vcharCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. vcharCol name}.
	insert paramCols: colAttrs.
	strings := (0 to: 7) collect: 
					[:i |
					str := 'abcdefgh' copyFrom: 1 to: i.
					insert values: {i. str}.
					insert exec.
					str].
	resultSet := connection query: 'select <1s> from <2s>' << {vcharCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: vcharCol name]) asArray equals: strings.
	resultSet free.
	insert values: {100. 1}.
	self
		should: [insert exec]
		raise: MessageNotUnderstood
		matching: [:ex | ex selector = #asAnsiString]!

testViewsQuery
	| views |
	views := connection
				tables: nil
				owners: 'dbo'
				tables: nil
				types: '''VIEW'''.
	self assert: (views
				noDifference: #('Alphabetical list of products' 'Category Sales for 1997' 'Current Product List' 'Customer and Suppliers by City' 'Invoices' 'Order Details Extended' 'Order Subtotals' 'Orders Qry' 'Product Sales for 1997' 'Products Above Average Price' 'Products by Category' 'Quarterly Orders' 'Sales by Category' 'Sales Totals by Amount' 'Summary of Sales by Quarter' 'Summary of Sales by Year'))!

testWCharColumn
	| colAttrs wcharCol insert resultSet str strings |
	colAttrs := self createTestTable: 'nchar' qualifiers: #(7).
	wcharCol := colAttrs last.
	insert := connection
				prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. wcharCol name}.
	insert paramCols: colAttrs.
	strings := (0 to: 7) collect: 
					[:i |
					str := 'abcdefgh' copyFrom: 1 to: i.
					insert values: {i. str}.
					insert exec.
					str , ('       ' copyFrom: 1 to: 7 - i)].
	resultSet := connection query: 'select <1s> from <2s>' << {wcharCol name. self temporaryTableName}.
	self assert: (resultSet collect: [:each | each at: wcharCol name]) asArray equals: strings.
	resultSet free.
	insert values: {100. 1}.
	self
		should: [insert exec]
		raise: MessageNotUnderstood
		matching: [:ex | ex selector = #asUtf16String]!

testWVarCharColumn
	| colAttrs colAttr |
	colAttrs := self createTestTable: 'nvarchar' qualifiers: #(16).
	colAttr := colAttrs last.
	#(3 2 1) do: 
			[:each |
			| insert resultSet strings |
			insert := connection
						prepare: 'INSERT <1s> (ID,<2s>) VALUES (?,?)' << {self temporaryTableName. colAttr name}.
			insert paramCols: colAttrs.
			strings := (0 to: 16) collect: 
							[:i |
							| str |
							str := 'abcdefghijklmnop' copyFrom: 1 to: i.
							insert values: {i. str}.
							insert exec.
							str].
			resultSet := connection query: 'select <1s> from <2s>' << {colAttr name. self temporaryTableName}.
			self assert: (resultSet collect: [:r | r at: colAttr name]) asArray equals: strings.
			resultSet free.
			insert free.
			connection exec: 'DELETE FROM ' , self temporaryTableName.
			Smalltalk.DBVarFieldBuffer.BlockTransferOctetLength := (each + 1) * 2.
			Smalltalk.DBVarFieldBuffer.MaxBoundOctetLength := 8]! !

!Database.Tests.SQLServerDBTest categoriesForMethods!
categoriesColumns!constants!private! !
databaseName!constants!private! !
databaseResource!helpers!private! !
dataSourceName!constants!private! !
dbmsFeaturesMap!constants!private! !
ordersColumns!constants!private! !
testBitColumn!public!unit tests! !
testCharColumn!public!unit tests! !
testDateColumn!public!unit tests! !
testDatetime2Column!public!unit tests! !
testDatetimeColumn!public!unit tests! !
testDatetimeOffsetColumn!public!unit tests! !
testFloatColumn!public!unit tests! !
testForeignKeysQuery!public!unit tests! !
testGuidColumn!public!unit tests! !
testNumericColumn!public!unit tests! !
testPrimaryKeysQuery!public!unit tests! !
testProceduresQuery!public!unit tests! !
testRealColumn!public!unit tests! !
testSqlDateAndTimeTypes!public!unit tests! !
testSQLServerConnectionAttributes!public!unit tests! !
testTablesQuery!public!unit tests! !
testTimeColumn!public!unit tests! !
testVarCharColumn!public!unit tests! !
testVarCharColumnUnbound!public!unit tests! !
testViewsQuery!public!unit tests! !
testWCharColumn!public!unit tests! !
testWVarCharColumn!public!unit tests! !
!

!Database.Tests.SQLServerDBTest class methodsFor!

resources
	^{SQLServerNorthwindDB}! !

!Database.Tests.SQLServerDBTest class categoriesForMethods!
resources!accessing!public! !
!

