"Filed out from Dolphin Smalltalk"!

Database.Tests.DBTest
	subclass: #'Database.Tests.DBConnectionTest'
	instanceVariableNames: 'savedBlockSize savedMaxBoundSize createdTestTable savedDBWarningTraceStream'
	classVariableNames: ''
	imports: #(#{OS.ODBCTypes} #{OS.ODBCConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.DBConnectionTest guid: (Core.GUID fromString: '{0a84fa8d-f7c4-4bbe-b459-da0409a391b9}')!

Database.Tests.DBConnectionTest isNonInstantiable: true!

Database.Tests.DBConnectionTest comment: 'SUnitBrowser openOnTestCase: self.

If these tests fail make sure that Tests\NWind.mdb is available and NOT write protected.'!

!Database.Tests.DBConnectionTest methodsFor!

ageAtHireQuery
	^'SELECT <2s>, <3s>, <4s>, (<4s>- <3s>) YEAR TO MONTH as <5s> from <1s>' << (#('Employees' 'EmployeeID' 'BirthDate' 'HireDate' 'AgeAtHire') collect: [:n | self dbName: n])!

allDataTypes
	^self subclassResponsibility!

categoriesColumns
	^self subclassResponsibility!

columnOverflowSqlState
	^self sqlStateGeneralError!

columnsOf: aString
	^connection columns: aString!

columnTypeNameBinary
	^'BINARY'!

columnTypeNameBlob
	^'VARBINARY(MAX)'!

columnTypeNameDateTime
	^'DATETIME'!

columnTypeNameDateTimeWithOffset
	^'DATETIMEOFFSET'!

columnTypeNameDouble
	^'float'!

columnTypeNameVarBinary
	^'VARBINARY'!

columnTypeNameWideChar
	^'NCHAR'!

columnTypeNameWideVarChar
	^'NVARCHAR'!

createTableStatementTemplate
	^'CREATE TABLE <1s> ( <2s> INT PRIMARY KEY, <3s> <4s><5d> <6?:NOT >NULL )'!

createTestTable: aString
	^self createTestTable: aString qualifiers: #()!

createTestTable: aString qualifiers: anArray
	^self createTestTable: aString qualifiers: anArray nullable: true!

createTestTable: aString qualifiers: anArray nullable: aBoolean
	| lengthInsert |
	self dropTestTable.
	lengthInsert := anArray isEmpty
				ifFalse: 
					[String streamContents: 
							[:strm |
							strm nextPut: $(.
							anArray do: [:each | strm display: each] separatedBy: [strm nextPut: $,].
							strm nextPut: $)]].
	(connection
		exec: self createTableStatementTemplate << {
						self dbName: self temporaryTableName.
						self dbName: 'ID'.
						self dbName: self temporaryColumnName.
						aString.
						lengthInsert.
						aBoolean
					})
			free.
	createdTestTable := true.
	^connection columns: self temporaryTableName!

createTimeTestTable
	^self createTestTable: 'TIME'!

databaseName
	^'Northwind'!

databaseResource
	self subclassResponsibility!

dataSourceName
	^self databaseResource connectionStringAttributes lookup: 'DSN'!

dbmsFeaturesMap
	"Private - Override in subclasses"

	^LookupTable new!

defaultCursorCommitBehavior
	^SQL_CB_CLOSE!

defaultCursorRollbackBehaviour
	^SQL_CB_CLOSE!

defaultDateTimeColumnScale
	^3!

defaultDatetimeWithOffsetScale
	^7!

defaultTransactionIsolation
	^#readCommitted!

dropTestTable
	connection asParameter isNull ifTrue: [^self].
	self freeDbResources.
	[connection exec: 'DROP TABLE ' , (self dbName: self temporaryTableName)] on: DBError do: [:ex | ]!

dsn
	^Error notYetImplemented!

exampleLongText
	^Object comment!

exec: aString
	| stmt |
	stmt := connection exec: aString.
	dbResources add: stmt.
	^stmt!

execShouldRaiseIntegerOutOfRange: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: OS.HRESULTError
		matching: 
			[:ex |
			ex hresult = (OS.HRESULT fromPrimitiveFailureCode: Kernel._PrimitiveFailureCode.IntegerOutOfRange)]!

execShouldRaiseSqlDateOverflow: aDBParameterizedStatement
	self execShouldRaiseSqlInvalidDateFormat: aDBParameterizedStatement!

execShouldRaiseSqlInvalidDateFormat: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22007']!

execShouldRaiseSqlInvalidDouble: insertStatement
	^self
		should: [insertStatement exec]
		raise: DBError
		matching: [:ex | ex sqlState = self sqlStateInvalidDouble]!

execShouldRaiseSqlNumberOutOfRange: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22003']!

execShouldRaiseSqlTruncatedString: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex sqlState = self sqlStateTruncatedString]!

execShouldRaiseTypeMismatch: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: OS.HRESULTError
		matching: [:ex | ex hresult = (OS.HRESULT fromInteger: OS.Win32Errors.STATUS_OBJECT_TYPE_MISMATCH)]!

field: aString fromRow: aDBRow 
	^aDBRow at: aString!

getTypeInfoDataTypeColumn
	^'SQL_DATA_TYPE'!

hasDateTimeOffsetDataType
	^true!

hasFixedWidthBinaryDataType
	"Most DB's support SQL_BINARY (cf. SQL_VARBINARY)."

	^true!

hasIntervalDataType
	"Most DB's do support INTERVAL data types in the DB (MS SQL Server and Access being exceptions), although ODBC driver support to map this to SQL_INTERVAL_STRUCTs is largely missing."

	^true!

hasNumericDataType
	^true!

hasTimeDataType
	^true!

hasVarBinaryWithLimitDataType
	"varbinary(N) for integer N, as opposed to some unbounded blob type"

	^true!

insertsNullForEmptyBinary
	^false!

insertsNullForEmptyBinaryIfUnbound
	^false!

insertsNullForEmptyString
	^false!

intervalLiteralsQuery
	^'SELECT (INTERVAL ''1997'' YEAR(4)) AS years1997,
			(INTERVAL ''993'' MONTH(3)) AS months993,
			(INTERVAL ''3261'' DAY(4)) as days3261,
			(INTERVAL ''163'' HOUR(3)) as hours163,
			(INTERVAL ''-163'' MINUTE(3)) as minutes163,
			(INTERVAL ''23.25'' SECOND(2)) as seconds223,
			(INTERVAL ''163-11'' YEAR(3) TO MONTH) as y163m11,
			(INTERVAL ''163 12'' DAY(3) TO HOUR) as d163h12,
			(INTERVAL ''163 12:39'' DAY(3) TO MINUTE) as d163h12m39,
			(INTERVAL ''999 23:39:59.125'' DAY(3) TO SECOND(3)) as d999h12m39s59f18,
			(INTERVAL ''163:39'' HOUR(3) TO MINUTE) as d163m39,
			(INTERVAL ''163:39:59.875'' HOUR(3) TO SECOND(4)) as h163m39s39f78,
			(INTERVAL ''163:59.375'' MINUTE(3) TO SECOND(5)) as m163s59f38,
			(INTERVAL ''-16 23:39:56.109375'' DAY TO SECOND) as nd16h23m39s56f764
							from Orders where OrderID=10248;'!

invalidDates
	^{ Date newDay: 365 year: -1. Date newDay: 1 year: 10000 }!

invalidDatesAndTimesWithOffset
	^self invalidDates!

matchInvalidDateTime: ex
	^ex sqlState = '22008' or: [ex sqlState = '22007']!

nameUpdateTestPairs
	^{#('0123456789' '🐬s'). #('012345678' 'a'). #('ᚠᛇᚻ' 'Davolios'). {'Nancy'. 'Davolio'}}!

orderDetailsTable
	^'OrderDetails'!

ordersColumns
	"Column metadata from SQL Server, which we'll consider as a baseline."

	^{{'OrderID'. SQL_INTEGER. 10. 0. 4}.
		{'CustomerID'. SQL_WCHAR. 5. nil. 10}.
		{'EmployeeID'. SQL_INTEGER. 10. 0. 4}.
		{'OrderDate'. SQL_TYPE_TIMESTAMP. 23. 3. OS.SQL_TIMESTAMP_STRUCT byteSize}.
		{'RequiredDate'. SQL_TYPE_TIMESTAMP. 23. 3. OS.SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShippedDate'. SQL_TYPE_TIMESTAMP. 23. 3. OS.SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShipVia'. SQL_INTEGER. 10. 0. 4}.
		{'Freight'. SQL_DECIMAL. 19. 4. 21}.
		{'ShipName'. SQL_WVARCHAR. 40. nil. 80}.
		{'ShipAddress'. SQL_WVARCHAR. 60. nil. 120}.
		{'ShipCity'. SQL_WVARCHAR. 15. nil. 30}.
		{'ShipRegion'. SQL_WVARCHAR. 15. nil. 30}.
		{'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 20}.
		{'ShipCountry'. SQL_WVARCHAR. 15. nil. 30}}!

ordersRowVersionColumns
	^#()!

orderTableRowIds
	^#('OrderID')!

prepare: aString
	| insert |
	insert := connection prepare: aString.
	dbResources add: insert.
	^insert!

query: aString cursorType: aSymbol
	| resultSet |
	resultSet := connection query: aString cursorType: aSymbol.
	dbResources add: resultSet.
	^resultSet!

requiredOdbcVersion
	^SQL_OV_ODBC3_80!

rowIdColumnsOf: aString
	^connection rowIdColumns: aString!

scaleOfTimeColumns
	^0!

setUp
	createdTestTable := false.
	savedDBWarningTraceStream := DBWarning traceStream.
	DBWarning traceStream: NullStream new.
	super setUp.
	DBConnection requiredOdbcVersion: self requiredOdbcVersion.
	savedBlockSize := DBVarFieldBuffer.BlockTransferOctetLength.
	savedMaxBoundSize := DBVarFieldBuffer.MaxBoundOctetLength!

shouldRaiseNotSupported: aNiladicValuable 
	self 
		should: aNiladicValuable
		raise: DBError
		matching: [:e | e tag errors anySatisfy: [:x | x sqlState = 'IM001']]!

sqlDataTypeBlob
	^SQL_LONGVARBINARY!

sqlDataTypeTime
	^SQL_TYPE_TIME!

sqlDataTypeVarChar
	^SQL_VARCHAR!

sqlStateGeneralError
	"HY000	General error	An error occurred for which there was no specific SQLSTATE and for which no implementation-specific SQLSTATE was defined. The error message returned by SQLGetDiagRec in the *MessageText buffer describes the error and its cause."

	^'HY000'!

sqlStateInvalidDouble
	"22003 is a reasonable choice, at least for failure to store infinities. See https://learn.microsoft.com/en-us/sql/odbc/reference/syntax/sqlputdata-function

	22003	Numeric value out of range	The data sent for a bound numeric parameter or column caused the whole (as opposed to fractional) part of the number to be truncated when assigned to the associated table column."

	^'22003'!

sqlStateTruncatedString
	^'22001'!

supportsIntervalStructs
	"Private - Most DBMSs either don't support the INTERVAL data types (e.g. SQL Server), or don't provide binary support for them in their ODBC driver (e.g. Oracle)."

	^false!

supportsReadOnlyMode
	^true!

tables
	^connection tables!

tearDown
	savedBlockSize ifNotNil: [DBVarFieldBuffer.BlockTransferOctetLength := savedBlockSize].
	savedMaxBoundSize ifNotNil: [DBVarFieldBuffer.MaxBoundOctetLength := savedMaxBoundSize].
	createdTestTable ifTrue: [self dropTestTable].
	super tearDown.
	DBWarning traceStream: savedDBWarningTraceStream!

temporaryColumnName
	^'DolphinTestColumn'!

temporaryTableName
	^'DOLPHIN_TEST_TABLE'!

testAsArray
	| results array selectOrder |
	results := self query: 'SELECT* FROM <1s>' << (self dbName: 'Employees').
	array := results asArray.
	results with: array do: [:row1 :row2 | self assert: row1 = row2].
	results asArray with: array do: [:row1 :row2 | self assert: row1 = row2].
	"Query again after deliberately causing the buffers for long variable columns to be too small to provoke SQLGetData loops"
	DBVarFieldBuffer blockTransferOctetLength: 64.
	results free.
	results := self query: 'SELECT* FROM <1s>' << (self dbName: 'Employees').
	results asArray with: array do: [:row1 :row2 | self assert: row1 = row2].

	"Force with:do: to raise an error"
	self should: [results with: (array copyWith: array first) do: [:a :b | ]] raise: Error.
	self should: 
			[results with: (array asOrderedCollection
						removeLast;
						yourself)
				do: [:a :b | ]]
		raise: Error.
	results free.

	"Test a forward only cursor"
	results := self query: 'SELECT* FROM <1s>' << (self dbName: 'Employees').
	array := results asArray.
	results with: array do: [:row1 :row2 | self assert: row1 = row2].
	"Enumerate again"
	array := results asArray.
	results with: array do: [:row1 :row2 | self assert: row1 = row2].
	results free.
	selectOrder := 'SELECT * FROM <1s> WHERE <2s>=<3d>'.
	results := self query: selectOrder << { self dbName: 'Orders'. self dbName: 'OrderID'. -1 }.
	array := results asArray.
	self assert: array isEmpty.
	array := results asArray.
	self assert: array isEmpty.
	results free.
	results := self query: selectOrder << { self dbName: 'Orders'. self dbName: 'OrderID'. -1 }
				cursorType: #forwardOnly.
	array := results asArray.
	self assert: array isEmpty.
	array := results asArray.
	self assert: array isEmpty.
	results free.
	results := self query: selectOrder << { self dbName: 'Orders'. self dbName: 'OrderID'. 10248 }
				cursorType: #forwardOnly.
	array := results asArray.
	self assert: array size == 1.
	self assert: (array first atIndex: 1) = 10248.
	"Repeat - causing requery"
	array := results asArray.
	self assert: array size == 1.
	self assert: (array first atIndex: 1) = 10248.
	results free!

testColumnsQuery
	{ 'Orders'. self ordersColumns. 'Categories'. self categoriesColumns } pairsDo: 
			[:table :expectedColumns |
			| columns |
			columns := self columnsOf: table.
			columns with: expectedColumns
				do: 
					[:eachCol :eachArray |
					| type |
					self assert: eachCol name equals: eachArray first.
					type := eachArray second.
					self assert: (OS.ODBCTypes keyAtValue: eachCol type) equals: (OS.ODBCTypes keyAtValue: type).
					self assert: eachCol precision equals: eachArray third.
					self assert: eachCol scale equals: eachArray fourth.
					self assert: eachCol length equals: eachArray last]]!

testColumnTypeBinary
	<skipUnless: #hasFixedWidthBinaryDataType>
	| colAttrs column insert resultSet bytes expectedValues |
	colAttrs := self createTestTable: self columnTypeNameBinary qualifiers: #(7).
	column := colAttrs last.
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)'
						<< ({ self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name]).
	insert paramCols: colAttrs.
	expectedValues := (7 to: 0 by: -1) collect: 
					[:i |
					bytes := (i to: i + i - 1) asByteArray.
					insert values: { 7 - i. bytes }.
					insert exec.
					"For fixed width BINARY columns we expect trailing 0's"
					bytes , (#[0 0 0 0 0 0 0 0] copyFrom: 1 to: 7 - i)].
	resultSet := self
				query: 'SELECT <1s> FROM <2s> ORDER BY ID' << { column name. self temporaryTableName }.
	self insertsNullForEmptyBinary ifTrue: [expectedValues at: 1 put: nil].
	self assert: (resultSet collect: [:each | each at: column name]) asArray equals: expectedValues.
	insert values: { expectedValues size + 1. #[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16] }.
	self should: [insert exec] raise: BoundsError.
	insert values: { expectedValues size + 1. 1 }.
	self execShouldRaiseTypeMismatch: insert!

testColumnTypeBlob
	| colAttrs column |
	colAttrs := self createTestTable: self columnTypeNameBlob.
	column := colAttrs last.
	self assert: column type equals: self sqlDataTypeBlob.
	#(3 2) do: 
			[:transferLen |
			| insert resultSet expectedValues param |
			DBVarFieldBuffer.BlockTransferOctetLength := transferLen.
			insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)'
								<< ({ self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name]).
			insert paramCols: colAttrs.
			expectedValues := (0 to: 15) collect: 
							[:i |
							| bytes |
							bytes := #[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16] copyFrom: 1 to: i.
							insert values: { i. bytes }.
							insert exec.
							bytes].
			self insertsNullForEmptyBinaryIfUnbound ifTrue: [expectedValues at: 1 put: nil].
			param := insert parameters last.
			self assert: param isKindOf: DBLongVarField.
			self assert: param fieldBuf isKindOf: DBVarBinaryBuffer.
			resultSet := self query: 'SELECT <1s> FROM <2s> ORDER BY <3s>'
								<< { self dbName: column name. self dbName: self temporaryTableName. self dbName: 'ID' }.
			self assert: (resultSet collect: [:each | each at: column name]) asArray equals: expectedValues.
			resultSet free.
			insert free.
			self exec: 'DELETE FROM ' , (self dbName: self temporaryTableName)]!

testColumnTypeChar
	| colAttrs column insert resultSet str expectedValues identifiers |
	colAttrs := self createTestTable: 'CHAR' qualifiers: #(7).
	column := colAttrs last.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	expectedValues := (7 to: 0 by: -1) collect: 
					[:i |
					str := 'abcdefg' copyFrom: 1 to: i.
					insert values: { 7 - i. str }.
					insert exec.
					"For fixed width CHAR columns we expect trailing blanks"
					str , ('       ' copyFrom: 1 to: 7 - i)].
	resultSet := self query: 'SELECT <3s> FROM <1s> ORDER BY <2s>' << identifiers.
	self insertsNullForEmptyString ifTrue: [expectedValues at: 8 put: nil].
	self assert: (resultSet collect: [:each | each at: column name]) asArray equals: expectedValues.
	resultSet free.
	insert values: { expectedValues size + 1. 'abcdefghijklmno' }.
	self should: [insert exec] raise: BoundsError.
	insert values: { expectedValues size + 1. 1 }.
	self should: [insert exec] raise: MessageNotUnderstood!

testColumnTypeDate
	| colAttrs column insert resultSet timestamp dateAndTime date insertedValues identifiers |
	"Invalid dates"
	colAttrs := self createTestTable: 'DATE'.
	column := colAttrs last.
	self assert: column type equals: SQL_TYPE_DATE.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
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
	resultSet := self query: 'SELECT <3s> from <1s>' << identifiers.
	self assert: (resultSet collect: [:each | each at: column name]) asArray
		equals: (insertedValues collect: [:each | each ifNotNil: [each asDate]]).
	resultSet free.
	self verifyInvalidDates: insert!

testColumnTypeDatetime
	| colAttrs column insert resultSet timestamp dateAndTime date identifiers |
	colAttrs := self createTestTable: self columnTypeNameDateTime.
	column := colAttrs last.
	self assert: column scale equals: self defaultDateTimeColumnScale.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	date := Date today.
	"Default precision is 1mS, i.e. 3 decimal places for the seconds - we test elsewhere that the marshalling truncates correctly"
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.123+13:30'.
	timestamp := TimeStamp fromSeconds: 3905691359467 / 1000.
	{ date. dateAndTime. timestamp. nil } keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'SELECT <3s> FROM <1s>' << identifiers.
	self assert: (resultSet collect: [:each | each at: column name]) asArray
		equals: { date asDateAndTime. dateAndTime asLocal. timestamp asDateAndTime. nil }.
	resultSet free.
	"Invalid dates"
	self invalidDates keysAndValuesDo: 
			[:i :each |
			insert values: { 100 + i. each }.
			self execShouldRaiseSqlInvalidDateFormat: insert]!

testColumnTypeDatetimeOffset
	"DATETIMEOFFSET is an extended SQL Server column type that extends datetime to include time zone offset. The default scale of the seconds is also more precise (7 rather than 3). Some other DBs support a similar type, e.g. postgres has timestamptz"

	<skipUnless: #hasDateTimeOffsetDataType>
	| colAttrs column insert resultSet date dateAndTime timestamp values identifiers |
	colAttrs := self createTestTable: self columnTypeNameDateTimeWithOffset.
	column := colAttrs last.
	self assert: column scale equals: self defaultDatetimeWithOffsetScale.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	date := Date today.
	"Default precision is 1mS, i.e. 3 decimal places for the seconds - we test elsewhere that the marshalling truncates correctly"
	dateAndTime := DateAndTime
				year: 9999
				month: 12
				day: 31
				hour: 0
				minute: 20
				second: (34.1234567 truncateTo: 1 / self defaultDatetimeWithOffsetScale exp10)
				offset: 13 hours + 30 minutes.
	timestamp := TimeStamp fromSeconds: 39056913591234567 / self defaultDatetimeWithOffsetScale exp10.
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
	resultSet := self query: 'SELECT <3s> FROM <1s>' << identifiers.
	self assert: (resultSet collect: [:each | each at: column name]) asArray
		equals: (values collect: [:each | each ifNotNil: [each asDateAndTime]]).
	resultSet free.
	"Invalid dates"
	self invalidDatesAndTimesWithOffset do: 
			[:each |
			insert values: { 100. each }.
			self execShouldRaiseSqlInvalidDateFormat: insert]!

testColumnTypeFloat
	| colAttrs column insert resultSet values identifiers |
	colAttrs := self createTestTable: self columnTypeNameDouble.
	column := colAttrs last.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	values := self validDoubleValues.
	values keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'SELECT <3s> FROM <1s>' << identifiers.
	(resultSet collect: [:each | each atIndex: 1]) with: values
		do: 
			[:actual :expected |
			expected isNil
				ifTrue: [self assertIsNil: actual]
				ifFalse: 
					[(expected isFloat not or: [expected isFinite])
						ifTrue: 
							[self
								assert: actual
								closeTo: expected
								precision: 0.001s]
						ifFalse: 
							[expected isNaN ifTrue: [self assert: actual isNaN] ifFalse: [self assert: actual equals: expected]]]].
	"Invalid"
	self verifyInvalidFloatValues: insert!

testColumnTypeNumeric
	<skipUnless: #hasNumericDataType>
	| colAttrs column insert resultSet values identifiers |
	colAttrs := self createTestTable: 'NUMERIC' qualifiers: #(10 3).
	column := colAttrs last.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	values := { nil. 1234567.891. 0. -1. 3 / 8. -9999999999 / 1000. 0.1234s }.
	values keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'select <3s> from <1s>' << identifiers.
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
	{ 10000000000 / 1000 } do: 
			[:each |
			insert values: { 100. each }.
			self execShouldRaiseSqlNumberOutOfRange: insert.
			self]!

testColumnTypeReal
	| colAttrs column insert resultSet values identifiers |
	colAttrs := self createTestTable: 'REAL'.
	column := colAttrs last.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	values := { nil. 0. -1. 3 / 8. -3.4e38. -1.18e-38. 1.18e-38. 3.4e38. Float negativeZero }.
	values keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'select <3s> from <1s>' << identifiers.
	(resultSet collect: [:each | each atIndex: 1]) with: values
		do: 
			[:actual :expected |
			expected isNil
				ifTrue: [self assertIsNil: actual]
				ifFalse: 
					[self assert: actual isKindOf: Float.
					expected isZero
						ifTrue: 
							["Oracle and MySql don't preserve negative zero"
							self assert: actual isZero]
						ifFalse: 
							[self assert: (String streamContents: [:s | actual printOn: s significantFigures: 7])
								equals: (String streamContents: [:s | expected asFloat printOn: s significantFigures: 7])]]].
	resultSet free.
	"Invalid"
	self verifyInvalidFloatValues: insert!

testColumnTypeTime
	<skipUnless: #hasTimeDataType>
	| colAttrs column insert resultSet timestamp dateAndTime time insertedValues expectedValues actualValues identifiers |
	colAttrs := self createTimeTestTable.
	column := colAttrs last.
	self assert: column type equals: self sqlDataTypeTime.
	self assert: column scale equals: self scaleOfTimeColumns.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	time := Time now.
	dateAndTime := DateAndTime fromString: ' 9999-12-31T00:20:34.1234567+13:30'.
	timestamp := TimeStamp date: (Date newDay: 1 year: 1) time: Time now.
	insertedValues := { time. dateAndTime. timestamp. nil }.
	insertedValues keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'select <3s> from <1s>' << identifiers.
	expectedValues := insertedValues collect: [:each | each ifNotNil: [each asTime]].
	actualValues := (resultSet collect: [:each | each at: column name]) asArray.
	expectedValues with: actualValues
		do: 
			[:expected :actual |
			expected
				ifNil: [self assertIsNil: actual]
				ifNotNil: 
					[self
						assert: actual
						closeTo: expected
						precision: 1 seconds]]!

testColumnTypeVarBinaryBound
	<skipUnless: #hasVarBinaryWithLimitDataType>
	| colAttrs column insert resultSet expectedValues |
	self assert: DBVarFieldBuffer maxBoundOctetLength > 16.
	colAttrs := self createTestTable: self columnTypeNameVarBinary qualifiers: #(16).
	column := colAttrs last.
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)'
						<< ({ self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name]).
	insert paramCols: colAttrs.
	expectedValues := (0 to: 13) collect: 
					[:i |
					| bytes |
					bytes := #[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16] copyFrom: 1 to: i.
					insert values: { i. bytes }.
					insert exec.
					bytes].
	self insertsNullForEmptyBinary ifTrue: [expectedValues at: 1 put: nil].
	self assert: insert parameters last isKindOf: DBBoundField.
	resultSet := self
				query: 'SELECT <1s> FROM <2s> ORDER BY ID' << { column name. self temporaryTableName }.
	self assert: (resultSet collect: [:each | each at: column name]) asArray equals: expectedValues!

testColumnTypeVarBinaryUnbound
	<skipUnless: #hasVarBinaryWithLimitDataType>
	| colAttrs column |
	DBVarFieldBuffer maxBoundOctetLength: DBVarFieldBuffer defaultMaxBoundOctetLength.
	colAttrs := self createTestTable: self columnTypeNameVarBinary qualifiers: #(16).
	column := colAttrs last.
	self assert: column type equals: SQL_VARBINARY.
	"Deliberately force use of long column transfer, i.e. calls to SQLGetData to retrieve the data rather than bound columns"
	DBVarFieldBuffer maxBoundOctetLength: 15.
	#(3 2) do: 
			[:transferLen |
			| insert resultSet expectedValues param |
			DBVarFieldBuffer.BlockTransferOctetLength := transferLen.
			insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)'
								<< ({ self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name]).
			insert paramCols: colAttrs.
			expectedValues := (0 to: 15) collect: 
							[:i |
							| bytes |
							bytes := #[0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16] copyFrom: 1 to: i.
							insert values: { i. bytes }.
							insert exec.
							bytes].
			self insertsNullForEmptyBinaryIfUnbound ifTrue: [expectedValues at: 1 put: nil].
			param := insert parameters last.
			self assert: param isKindOf: DBLongVarField.
			self assert: param fieldBuf isKindOf: DBVarBinaryBuffer.
			resultSet := self
						query: 'SELECT <1s> FROM <2s> ORDER BY ID' << { column name. self temporaryTableName }.
			self assert: (resultSet collect: [:each | each at: column name]) asArray equals: expectedValues.
			resultSet free.
			insert free.
			self exec: 'DELETE FROM ' , self temporaryTableName]!

testColumnTypeVarCharBound
	| colAttrs column insert resultSet expectedValues identifiers |
	self assert: DBVarFieldBuffer maxBoundOctetLength > 16.
	colAttrs := self createTestTable: 'VARCHAR' qualifiers: #(16).
	column := colAttrs last.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	expectedValues := (0 to: 15) collect: 
					[:i |
					| str |
					str := 'abcdefghijklmnop' copyFrom: 1 to: i.
					insert values: { i. str }.
					insert exec.
					str].
	self insertsNullForEmptyString ifTrue: [expectedValues at: 1 put: nil].
	self assert: insert parameters last isKindOf: DBBoundField.
	resultSet := self query: 'SELECT <3s> FROM <1s> ORDER BY <2s>' << identifiers.
	self assert: (resultSet collect: [:each | each at: column name]) asArray equals: expectedValues!

testColumnTypeVarCharBoundOverflow
	| colAttrs column insert |
	self assert: DBVarFieldBuffer maxBoundOctetLength > 16.
	colAttrs := self createTestTable: 'VARCHAR' qualifiers: #(16).
	column := colAttrs last.
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)'
						<< ({ self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name]).
	insert paramCols: colAttrs.
	insert values: { 100. 'abcdefghijklmnopq' }.
	"If the parameter is bound, we pass the data through the bound buffer and detect overflow when attempting to populate the buffer."
	self should: [insert exec] raise: BoundsError!

testColumnTypeVarCharUnbound
	| colAttrs column identifiers |
	DBVarFieldBuffer maxBoundOctetLength: DBVarFieldBuffer defaultMaxBoundOctetLength.
	colAttrs := self createTestTable: 'VARCHAR' qualifiers: #(16).
	column := colAttrs last.
	"The driver may choose to bind the varchar column as byte or wide chars."
	self assert: column type equals: self sqlDataTypeVarChar.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	"Deliberately force use of long column transfer, i.e. calls to SQLGetData to retrieve the data rather than bound columns"
	DBVarFieldBuffer maxBoundOctetLength: 15.
	#(3 2) do: 
			[:transferLen |
			| insert resultSet expectedValues |
			DBVarFieldBuffer.BlockTransferOctetLength := transferLen * column bufferClass elementSize.
			insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
			insert paramCols: colAttrs.
			expectedValues := (0 to: 15) collect: 
							[:i |
							| str |
							str := 'abcdefghijklmnop' copyFrom: 1 to: i.
							insert values: { i. str }.
							insert exec.
							str].
			self insertsNullForEmptyString ifTrue: [expectedValues at: 1 put: nil].
			self assert: insert parameters last isKindOf: DBLongVarField.
			resultSet := self query: 'SELECT <3s> FROM <1s> ORDER BY <2s>' << identifiers.
			self assert: (resultSet collect: [:each | each at: column name]) asArray equals: expectedValues.
			resultSet free.
			insert free.
			self exec: 'DELETE FROM <1s>' << identifiers]!

testColumnTypeVarCharUnboundOverflow
	| colAttrs column insert |
	DBVarFieldBuffer maxBoundOctetLength: DBVarFieldBuffer defaultMaxBoundOctetLength.
	colAttrs := self createTestTable: 'VARCHAR' qualifiers: #(16).
	column := colAttrs last.
	DBVarFieldBuffer maxBoundOctetLength: 15.
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)'
						<< ({ self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name]).
	insert paramCols: colAttrs.
	insert values: { 100. 'abcdefghijklmnopq' }.
	"If the parameter is bound, we pass the data through the bound buffer and detect overflow when attempting to populate the buffer."
	self execShouldRaiseSqlTruncatedString: insert!

testColumnTypeWChar
	| colAttrs column insert resultSet str expectedValues actualValues identifiers |
	colAttrs := self createTestTable: self columnTypeNameWideChar qualifiers: #(7).
	column := colAttrs last.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	expectedValues := (0 to: 7) collect: 
					[:i |
					"WChar column, but we only insert ASCII chars in this test"
					str := 'abcdefgh' copyFrom: 1 to: i.
					insert values: { i. str }.
					insert exec.
					str , ('       ' copyFrom: 1 to: 7 - i)].
	self insertsNullForEmptyString ifTrue: [expectedValues at: 1 put: nil].
	resultSet := self query: 'SELECT <3s> FROM <1s>' << identifiers.
	actualValues := (resultSet collect: [:each | each at: column name]) asArray.
	self assert: actualValues equals: expectedValues.
	resultSet free.
	insert values: { 100. 1 }.
	self
		should: [insert exec]
		raise: MessageNotUnderstood
		matching: [:ex | ex selector = #asUtf16String]!

testColumnTypeWCharExtendedChars
	| colAttrs column insert resultSet str expectedValues actualValues chars identifiers |
	colAttrs := self createTestTable: self columnTypeNameWideChar qualifiers: #(7).
	column := colAttrs last.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	chars := 'a£Ā文b🐬' asArray.
	expectedValues := (0 to: 6) collect: 
					[:i |
					| utf16 |
					str := (chars copyFrom: 1 to: i) asString.
					insert values: { i. str }.
					insert exec.
					utf16 := str asUtf16String.
					utf16 , ('       ' copyFrom: 1 to: 7 - utf16 size)].
	self insertsNullForEmptyString ifTrue: [expectedValues at: 1 put: nil].
	resultSet := self query: 'SELECT <3s> FROM <1s>' << identifiers.
	actualValues := (resultSet collect: [:each | each at: column name]) asArray.
	self assert: actualValues equals: expectedValues!

testColumnTypeWVarCharBound
	| colAttrs column strings resultSet insert identifiers |
	self assert: DBVarFieldBuffer maxBoundOctetLength > 16.
	colAttrs := self createTestTable: self columnTypeNameWideVarChar qualifiers: #(16).
	column := colAttrs last.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	strings := (0 to: 16) collect: 
					[:i |
					| str |
					str := 'abcdefghijklmnop' copyFrom: 1 to: i.
					insert values: { i. str }.
					insert exec.
					str].
	self insertsNullForEmptyString ifTrue: [strings at: 1 put: nil].
	resultSet := self query: 'SELECT <3s> FROM <1s>' << identifiers.
	self assert: (resultSet collect: [:r | r at: column name]) asArray equals: strings!

testColumnTypeWVarCharUnbound
	| colAttrs column identifiers |
	DBVarFieldBuffer maxBoundOctetLength: DBVarFieldBuffer defaultMaxBoundOctetLength.
	colAttrs := self createTestTable: self columnTypeNameWideVarChar qualifiers: #(16).
	column := colAttrs last.
	"The driver may choose to bind the varchar column as byte or wide chars."
	self assert: column type equals: SQL_WVARCHAR.
	identifiers := { self temporaryTableName. 'ID'. column name } collect: [:name | self dbName: name].
	"Deliberately force use of long column transfer, i.e. calls to SQLGetData to retrieve the data rather than bound columns"
	DBVarFieldBuffer maxBoundOctetLength: 8.
	#(3 2) do: 
			[:each |
			| insert resultSet strings |
			DBVarFieldBuffer.BlockTransferOctetLength := each * 2.
			insert := self prepare: 'INSERT INTO <1s> (<2s>,<3s>) VALUES (?, ?)' << identifiers.
			insert paramCols: colAttrs.
			strings := (0 to: 16) collect: 
							[:i |
							| str |
							str := 'abcdefghijklmnop' copyFrom: 1 to: i.
							insert values: { i. str }.
							insert exec.
							str].
			self insertsNullForEmptyString ifTrue: [strings at: 1 put: nil].
			resultSet := self query: 'SELECT <3s> FROM <1s> ORDER BY <2s>' << identifiers.
			self assert: (resultSet collect: [:r | r at: column name]) asArray equals: strings.
			resultSet free.
			insert free.
			self exec: 'DELETE FROM ' , identifiers first]!

testConnectionAttributes
	self assert: connection driverHDBC notNull.
	self assert: connection driverHEnv notNull.
	self assert: connection willAutoCommit.
	connection willAutoCommit: false.
	self assert: connection willAutoCommit not.
	connection willAutoCommit: true.
	self assert: connection willAutoCommit.
	self assert: connection transactionIsolation equals: self defaultTransactionIsolation.
	self
		should: [connection transactionIsolation: #hash]
		raise: Error
		matching: [:ex | ex messageText = 'value not found: #hash']!

testConnectionEnquiries
	self assert: connection databaseName asLowercase equals: self databaseName asLowercase.
	self dataSourceName
		ifNil: [self assert: connection dataSourceName equals: '']
		ifNotNil: [:dsn | self assert: connection dataSourceName asLowercase equals: dsn asLowercase].
	self dbmsFeaturesMap keysAndValuesDo: 
			[:eachKey :eachValue |
			| value |
			value := connection perform: eachKey.
			(#(#sameAs: #= #==) identityIncludes: eachValue first)
				ifTrue: 
					[self
						assert: value
						equals: eachValue second
						description: 'Test ' , eachKey displayString]
				ifFalse: [self assert: (value perform: eachValue first with: eachValue second)]].
	self assert: connection cursorCommitBehaviour equals: self defaultCursorCommitBehavior.
	self assert: connection cursorRollbackBehaviour equals: self defaultCursorRollbackBehaviour.
	self assert: (((self columnsOf: 'Orders') collect: [:each | each name asUppercase])
				noDifference: #('ORDERID' 'CUSTOMERID' 'EMPLOYEEID' 'ORDERDATE' 'REQUIREDDATE' 'SHIPPEDDATE' 'SHIPVIA' 'FREIGHT' 'SHIPNAME' 'SHIPADDRESS' 'SHIPCITY' 'SHIPREGION' 'SHIPPOSTALCODE' 'SHIPCOUNTRY')).
	self assert: (connection rowVersionColumns: 'Orders') asSortedArray equals: self ordersRowVersionColumns.
	self assert: (Number readFrom: connection odbcVersion readStream) >= 3.0.
	self assert: connection dbmsVersion notEmpty.
	self assert: connection driverVersion notEmpty.
	self assert: (connection numericFunctions allSatisfy: [:each | each beginsWith: 'SQL_FN_NUM_']).
	self assert: (connection stringFunctions allSatisfy: [:each | each beginsWith: 'SQL_FN_STR_']).
	self assert: (connection systemFunctions allSatisfy: [:each | each beginsWith: 'SQL_FN_SYS_']).
	self assert: (connection timeDateFunctions allSatisfy: [:each | each beginsWith: 'SQL_FN_TD_'])
	"#uniqueIndicesOf: has separate test method"!

testConnectionReadOnly
	<skipUnless: #supportsReadOnlyMode>
	self assert: connection isReadOnly not.
	connection isReadOnly: true.
	self assert: connection isReadOnly.
	connection isReadOnly: false.
	self assert: connection isReadOnly not!

testDataTypesQuery
	| allTypes |
	allTypes := ((connection typeInfo: SQL_ALL_TYPES)
				collect: [:each | (each at: 'TYPE_NAME') -> (each at: self getTypeInfoDataTypeColumn)])
					asSortedArray: [:a :b | a key = b key ifTrue: [a value <= b value] ifFalse: [a key < b key]].
	self assert: allTypes equals: self allDataTypes!

testDateDiff
	<skipUnless: #supportsIntervalStructs>
	| resultSet |
	resultSet := self query: self ageAtHireQuery.
	resultSet do: 
			[:each |
			| hired born ageAtHire |
			hired := each at: 'HireDate'.
			born := each at: 'BirthDate'.
			ageAtHire := each at: 'AgeAtHire'.
			self assert: ageAtHire totalYears equals: (hired monthsSince: born) / 12]!

testDateTimeDiff
	<skipUnless: #supportsIntervalStructs>
	| resultSet |
	resultSet := self query: self timeToShipQuery.
	resultSet do: 
			[:each |
			| shipped required delay |
			shipped := each at: 'ShippedDate'.
			shipped
				ifNil: [self assert: (each at: 'TimeToShip') isNil]
				ifNotNil: 
					[required := each at: 'RequiredDate'.
					delay := each at: 'TimeToShip'.
					self assert: delay equals: shipped - required]]!

testDayToSecondsIntervals
	<skipUnless: #supportsIntervalStructs>

	| resultSet values colAttrs intervalCol insert buf identifiers |
	self dropTestTable.
	colAttrs := self createTestTable: 'INTERVAL DAY TO SECOND'.
	identifiers := { self temporaryTableName. 'ID'. colAttrs second name }
				collect: [:n | self dbName: n].
	insert := self prepare: 'INSERT INTO <1s> (<2s>, <3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	intervalCol := colAttrs last.
	values := {
				30 days.
				48 hours.
				58 days + 5 hours + 22 minutes + 3.109375 seconds.
				0 seconds.
				-31 days.
				5 hours + 22 minutes + 3.109375 seconds.
				22 minutes + 3.109375 seconds.
				3.109375 seconds
			}.
	buf := OS.SQL_INTERVAL_STRUCT dbNewForColumn: intervalCol.
	self assert: buf isKindOf: OS.SQL_DAY_SECOND_STRUCT.
	self assert: buf dbInterchangeType equals: OS.ODBCCTypes.SQL_C_INTERVAL_DAY_TO_SECOND.
	"Do a sanity check that the buffer class is set up and marshals as expected"
	values do: 
			[:each |
			buf value: each.
			self assert: buf value equals: each].
	values keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'select <2s>, <3s> from <1s>' << identifiers.
	(resultSet collect: [:each | each atIndex: 2]) with: values
		do: [:actual :expected | expected isNil ifTrue: [self assertIsNil: actual] ifFalse: [self assert: actual equals: expected]].
	values := { 10000000000 / 1000 }.
	values keysAndValuesDo: 
			[:key :each |
			insert values: { key * 2. each }.
			self execShouldRaiseTypeMismatch: insert]!

testIntervalLiterals
	"Examples based on https://learn.microsoft.com/en-us/sql/odbc/reference/appendixes/interval-literals"

	<skipUnless: #supportsIntervalStructs>
	| resultSet actual |
	resultSet := self query: self intervalLiteralsQuery.
	self assert: resultSet size equals: 1.
	actual := resultSet first contents.
	self assert: actual size equals: 14.
	self assert: (actual at: 1) equals: (OS.SQL_INTERVAL_STRUCT years: 1997).
	self assert: (actual at: 2) equals: (OS.SQL_INTERVAL_STRUCT months: 993).
	self assert: (actual at: 3) equals: 3261 days.
	self assert: (actual at: 4) equals: 163 hours.
	self assert: (actual at: 5) equals: -163 minutes.
	self assert: (actual at: 6) equals: 23.25 seconds.
	self assert: (actual at: 7) equals: (OS.SQL_INTERVAL_STRUCT years: 163 months: 11).
	self assert: (actual at: 8) equals: 163 days + 12 hours.
	self assert: (actual at: 9) equals: 163 days + 12 hours + 39 minutes.
	self assert: (actual at: 10) equals: 999 days + 23 hours + 39 minutes + 59.125 seconds.
	self assert: (actual at: 11) equals: 163 hours + 39 minutes.
	self assert: (actual at: 12) equals: 163 hours + 39 minutes + 59.875 seconds.
	self assert: (actual at: 13) equals: 163 minutes + 59.375 seconds.
	self assert: (actual at: 14) equals: -16 days - 23 hours - 39 minutes - 56.109375 seconds!

testMonthIntervals
	<skipUnless: #supportsIntervalStructs>
	| resultSet values colAttrs insert identifiers |
	self dropTestTable.
	colAttrs := self createTestTable: 'INTERVAL MONTH'.
	identifiers := { self temporaryTableName. 'ID'. colAttrs second name }
				collect: [:n | self dbName: n].
	insert := self prepare: 'INSERT INTO <1s> (<2s>, <3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	values := {
				OS.SQL_INTERVAL_STRUCT years: 1.
				OS.SQL_INTERVAL_STRUCT years: 8.
				OS.SQL_INTERVAL_STRUCT months: 99.
				OS.SQL_INTERVAL_STRUCT years: 8 months: 3.
				OS.SQL_INTERVAL_STRUCT years: 0.
				OS.SQL_INTERVAL_STRUCT months: 0.
				OS.SQL_INTERVAL_STRUCT years: 0 months: 0.
				OS.SQL_INTERVAL_STRUCT years: -8.
				OS.SQL_INTERVAL_STRUCT months: -99.
				OS.SQL_INTERVAL_STRUCT years: -8 months: 3
			}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'select <2s>, <3s> from <1s>' << identifiers.
	(resultSet collect: [:each | each atIndex: 2]) with: values
		do: [:actual :expected | expected isNil ifTrue: [self assertIsNil: actual] ifFalse: [self assert: actual equals: expected]].
	"Invalid"
	values := { 10000000000 / 1000 }.
	values keysAndValuesDo: 
			[:key :each |
			insert values: { key * 2. each }.
			self execShouldRaiseTypeMismatch: insert]!

testPreparedQuery
	| statement results |
	statement := self prepare: 'SELECT * FROM <1s> WHERE <2s>=?' << { self dbName: 'Suppliers'. self dbName: 'SupplierID' }.
	statement paramCols: (Array with: ((self columnsOf: 'Suppliers') at: 1)).
	statement values: #(3).
	statement exec.
	results := statement results.
	self assert: results size = 1.
	self assert: (self field: 'ContactName' fromRow: results first) = 'Regina Murphy'.
	results free!

testQueryAndUpdateBlob
	"Test that updating long binary field through a parameterized query (i.e. using SQLPutData) works."

	| update updateStatement resultSet picture row originalPicture selectStatement rowBuffer field identifiers |
	DBVarFieldBuffer maxBoundOctetLength: 32768.
	identifiers := #('Picture' 'CategoryID' 'Categories') collect: [:n | self dbName: n].
	selectStatement := 'SELECT <1s>,<2s> FROM <3s> where <2s>=1' << identifiers.
	resultSet := self query: selectStatement.
	row := resultSet single.
	rowBuffer := resultSet buffer.
	field := rowBuffer contents first.
	self assert: field isKindOf: DBLongVarField.
	self assert: field fieldBuf isKindOf: DBVarBinaryBuffer.
	originalPicture := field value.
	self assert: (originalPicture isNil or: [originalPicture isKindOf: ByteArray]).
	updateStatement := 'UPDATE <3s> SET <1s>=? WHERE <2s>=?' << identifiers.
	update := self prepare: updateStatement.
	update paramCols: resultSet describeColumns.
	resultSet free.
	picture := (Graphics.Bitmap fromFile: 'Resources\Beach ball.bmp'
				usingLocator: FileLocator installRelative) asByteArray.
	update values: { picture. 1 }.
	update exec.
	resultSet := self query: selectStatement.
	row := resultSet first.
	self assert: (row atIndex: 1) equals: picture.
	"Repeat but with a deliberately small buffer sizes so the data has to be queried in pieces."
	#(88 86) do: 
			[:each |
			| pic2 |
			DBVarFieldBuffer blockTransferOctetLength: each.
			"We have to re-run the query to get the column buffers rebuilt"
			resultSet := self query: selectStatement.
			row := resultSet first.
			pic2 := row atIndex: 1.
			resultSet free.
			self assert: pic2 equals: picture].
	"Reset"
	update values: { originalPicture. 1 }.
	update exec.
	resultSet := self query: selectStatement.
	row := resultSet single.
	self assert: (row atIndex: 1) equals: originalPicture!

testQueryAndUpdateDateTime
	| query colAttr row update selectStatement timestamp expected identifiers |
	identifiers := #('OrderDate' 'OrderID' 'Orders') collect: [:n | self dbName: n].
	selectStatement := 'SELECT <1s> FROM <3s> WHERE <2s>=10249' << identifiers.
	query := self query: selectStatement.
	colAttr := query describeColumns first.
	self assert: colAttr type equals: SQL_TYPE_TIMESTAMP.
	row := query at: 1.
	expected := DateAndTime
				year: 1996
				month: 07
				day: 05.
	self assert: (self field: 'OrderDate' fromRow: row) equals: expected.
	update := self prepare: 'UPDATE <3s> SET <1s>=? WHERE <2s>=10249' << identifiers.
	update paramCols: { colAttr }.
	timestamp := DateAndTime fromString: ' 2024-10-06T09:11:35.2516789+01:00'.
	update values: { timestamp }.
	update exec.
	query := self query: selectStatement.
	"Some precision may be lost, depending on the scale of the column. Access discards with a warning, but SQL Server generates an error if too much precision is provided, so we should have rounded to the scale when marshalling the column value"
	self
		assert: (self field: 'OrderDate' fromRow: query first)
		closeTo: timestamp
		precision: colAttr scale exp10 seconds.
	"Reset to original - DB will be dropped anyway, but can be useful for debugging"
	update values: { expected }.
	update exec.
	"Now check for overflow errors"
	update values: { DateAndTime year: -32768 day: 1 }.
	"Date out of range"
	self
		should: [update exec]
		raise: DBError
		matching: [:ex | self matchInvalidDateTime: ex].
	"Too large even for the year field of the timestamp struct"
	update values: { DateAndTime year: 32768 day: 1 }.
	self execShouldRaiseIntegerOutOfRange: update!

testQueryAndUpdateNClob
	"Test that updating long unicode text fields through a parameterized query (i.e. using SQLPutData) works."

	| update updateStatement resultSet originalDescription row selectStatement rowBuffer field identifiers |
	DBVarFieldBuffer maxBoundOctetLength: 8000.
	identifiers := #('Description' 'CategoryID' 'Categories') collect: [:n | self dbName: n].
	selectStatement := 'SELECT <1s>,<2s> FROM <3s> where <2s>=1' << identifiers.
	resultSet := self query: selectStatement.
	row := resultSet first.
	rowBuffer := resultSet buffer.
	field := rowBuffer contents first.
	self assert: field isKindOf: DBLongVarField.
	self assert: field fieldBuf isKindOf: DBVarWCharBuffer.
	originalDescription := field value.
	self assert: originalDescription isKindOf: Utf16String.
	self assert: field length equals: originalDescription size * 2.
	updateStatement := 'UPDATE <3s> SET <1s>=? WHERE <2s>=?' << identifiers.
	update := self prepare: updateStatement.
	update paramCols: resultSet describeColumns.
	update values: { self exampleLongText. 1 }.
	update exec.
	resultSet := self query: selectStatement.
	row := resultSet first.
	self assert: (row atIndex: 1) equals: self exampleLongText.
	"Repeat but with a deliberately small buffer sizes so the data has to be queried in pieces."
	#(88 86) do: 
			[:each |
			| desc2 |
			DBVarFieldBuffer blockTransferOctetLength: each.
			"We have to re-run the query to get the column buffers rebuilt"
			resultSet := self query: selectStatement.
			row := resultSet first.
			desc2 := row atIndex: 1.
			resultSet free.
			self assert: desc2 equals: self exampleLongText].
	"Reset"
	update values: { originalDescription. 1 }.
	update exec.
	resultSet := self query: selectStatement.
	row := resultSet first.
	self assert: (row atIndex: 1) equals: originalDescription!

testQueryAndUpdateNumeric
	| query colAttr update selectStatement identifiers |
	identifiers := { 'UnitPrice'. 'Quantity'. self orderDetailsTable. 'OrderID'. 'ProductID' }
				collect: [:n | self dbName: n].
	selectStatement := 'SELECT <1s>,<2s> from <3s> WHERE <4s>=10249 AND <5s>=14' << identifiers.
	query := self query: selectStatement.
	colAttr := query describeColumns first.
	"Verify some test expectations"
	self assert: colAttr name asUppercase equals: 'UNITPRICE'.
	self assert: (colAttr type == SQL_NUMERIC or: [colAttr type == SQL_DECIMAL]).
	self assert: colAttr precision equals: 19.
	self assert: colAttr scale equals: 4.
	update := self prepare: 'UPDATE <3s> SET <1s>=? WHERE <4s>=10249 AND <5s>=14' << identifiers.
	update paramCols: { colAttr }.
	"Largest precision of value that column can hold: 15+4"
	#(12.3456s 123456789012345.9999s 18.6s) do: 
			[:price |
			update values: { price }.
			update exec.
			query := self query: selectStatement.
			self assert: (self field: 'UnitPrice' fromRow: query first) equals: price].
	update values: #(1234567890123456.1234s).
	self execShouldRaiseSqlNumberOutOfRange: update.
	self assert: update parameters first value equals: 1234567890123456.1234s.
	update values: { -12345678901234567.1234s }.
	self should: [update exec] raise: BoundsError!

testSpecialColumnsQuery
	| rowIds |
	connection isReadOnly: true.
	rowIds := self rowIdColumnsOf: 'Orders'.
	self assert: rowIds asArray equals: self orderTableRowIds!

testStatisticsQuery
	| stats pk |
	connection isReadOnly: true.
	stats := self uniqueIndicesOf: 'Orders'.
	self assert: (stats allSatisfy: [:each | (each at: 'TABLE_NAME') sameAs: 'Orders']).
	pk := stats detect: 
					[:each |
					| name |
					name := each at: 'COLUMN_NAME'.
					name notNil and: [name sameAs: 'OrderID']].
	stats := connection indicesOf: 'ORDERS'.
	self assert: (stats allSatisfy: [:each | (each at: 'TABLE_NAME') sameAs: 'Orders'])!

testTablesQuery
	| tables |
	tables := self tables collect: [:each | each asUppercase copyWithout: $\x20].
	self
		assert: (#('CATEGORIES' 'CUSTOMERS' 'EMPLOYEES' 'ORDERDETAILS' 'ORDERS' 'PRODUCTS' 'SHIPPERS' 'SUPPLIERS')
				difference: tables)
		equals: #()!

testTracing
	| traceFile |
	traceFile := File composePath: File tempPath subPath: 'BLAH.LOG'.
	connection traceFile: traceFile.
	self assert: connection traceFile equals: traceFile.
	self assert: connection isTracing.
	connection isTracing: false.
	self assert: connection isTracing not.
	File delete: traceFile
!

testUpdateBlobSetNull
	"Test that updating long binary field to NULL through a parameterized query (i.e. using SQLPutData) works."

	| update updateStatement resultSet row originalPicture selectStatement identifiers |
	identifiers := #('Picture' 'CategoryID' 'Categories') collect: [:n | self dbName: n].
	selectStatement := 'SELECT <1s>,<2s> FROM <3s> where <2s>=1' << identifiers.
	resultSet := self query: selectStatement.
	row := resultSet single.
	originalPicture := resultSet buffer contents first value.
	updateStatement := 'UPDATE <3s> SET <1s>=? WHERE <2s>=?' << identifiers.
	update := self prepare: updateStatement.
	update paramCols: resultSet describeColumns.
	update values: {nil. 1}.
	update exec.
	resultSet := self query: selectStatement.
	row := resultSet single.
	self assertIsNil: (row atIndex: 1).
	"Reset"
	update values: {originalPicture. 1}.
	update exec!

testUpdateNClobSetNull
	"Test that updating long unicode text fields through a parameterized query (i.e. using SQLPutData) works."

	| update updateStatement resultSet originalDescription row selectStatement identifiers |
	identifiers := #('Description' 'CategoryID' 'Categories') collect: [:n | self dbName: n].
	selectStatement := 'SELECT <1s>,<2s> FROM <3s> where <2s>=1' << identifiers.
	resultSet := self query: selectStatement.
	row := resultSet first.
	originalDescription := resultSet buffer contents first value.
	self denyIsNil: originalDescription.
	updateStatement := 'UPDATE <3s> SET <1s>=? WHERE <2s>=?' << identifiers.
	update := self prepare: updateStatement.
	update paramCols: resultSet describeColumns.
	update values: {nil. 1}.
	update exec.
	resultSet := self query: selectStatement.
	row := resultSet first.
	self assertIsNil: (row atIndex: 1).
	"Reset"
	update values: {originalDescription. 1}.
	update exec!

testUpdateWCharField
	"Test that updating NVARCHAR fields through a parameterized query works."

	| update selectStatement columns employee9 resultSet firstName lastName identifiers |
	identifiers := #('FirstName' 'LastName' 'Employees' 'EmployeeID') collect: [:n | self dbName: n].
	selectStatement := 'SELECT <1s>, <2s> FROM <3s> WHERE <4s>=1' << identifiers.
	resultSet := self query: selectStatement.
	columns := resultSet describeColumns.
	firstName := columns first.
	self assert: firstName precision equals: 10.
	"mysql returns a column length of 30 for 10 unicode chars, probably because it is using UTF-8, although the ODBC transfer type will be SQL_C_WCHAR, and the value is supposed to be the transfer octet length. The maximum encoding for a character in UTF-8 is 4 code units, but no character requires more than 2 UTF-16 code units, so for a 10 char column there is no way the UTF-16 transfer length can be >20."
	self assert: firstName length >= (10 * 2).	"nvarchar(10)"
	lastName := columns second.
	self assert: lastName precision equals: 20.
	self assert: lastName length >= (20 * 2).	"nvarchar(20)"
	update := self prepare: 'UPDATE <3s> SET <1s>=?, <2s>=? WHERE <4s>=1' << identifiers.
	update paramCols: { firstName. lastName }.
	self nameUpdateTestPairs do: 
			[:names |
			update values: names.
			update exec.
			resultSet := self query: selectStatement.
			employee9 := resultSet first.
			self assert: (self field: 'FirstName' fromRow: employee9) equals: names first.
			self assert: (self field: 'LastName' fromRow: employee9) equals: names last].
	firstName length > (firstName precision * 2)
		ifTrue: 
			[update values: { '0123456789012345' copyFrom: 1 to: firstName precision + 1. 'Foo' }.
			self
				should: [update exec]
				raise: DBError
				matching: [:ex | ex sqlState = self columnOverflowSqlState]].
	update values: { '0123456789012345' copyFrom: 1 to: firstName length / 2 + 1. 'Foo' }.
	self should: [update exec] raise: BoundsError!

testYearToMonthIntervals
	<skipUnless: #supportsIntervalStructs>
	| resultSet values colAttrs insert identifiers |
	self dropTestTable.
	colAttrs := self createTestTable: 'INTERVAL YEAR TO MONTH'.
	identifiers := { self temporaryTableName. 'ID'. colAttrs second name }
				collect: [:n | self dbName: n].
	insert := self prepare: 'INSERT INTO <1s> (<2s>, <3s>) VALUES (?, ?)' << identifiers.
	insert paramCols: colAttrs.
	values := {
				OS.SQL_INTERVAL_STRUCT years: 99.
				OS.SQL_INTERVAL_STRUCT months: 99.
				OS.SQL_INTERVAL_STRUCT years: 58 months: 5.
				OS.SQL_INTERVAL_STRUCT years: 0.
				OS.SQL_INTERVAL_STRUCT months: 0.
				OS.SQL_INTERVAL_STRUCT years: 0 months: 0.
				OS.SQL_INTERVAL_STRUCT years: -99.
				OS.SQL_INTERVAL_STRUCT months: -99.
				OS.SQL_INTERVAL_STRUCT years: -58 months: 5
			}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: { i. each }.
			insert exec].
	resultSet := self query: 'select <2s>, <3s> from <1s>' << identifiers.
	(resultSet collect: [:each | each atIndex: 2]) with: values
		do: [:actual :expected | expected isNil ifTrue: [self assertIsNil: actual] ifFalse: [self assert: actual equals: expected]].
	"Invalid"
	values := { 10000000000 / 1000 }.
	values keysAndValuesDo: 
			[:key :each |
			insert values: { key * 2. each }.
			self execShouldRaiseTypeMismatch: insert]!

timeToShipQuery
	^'SELECT OrderID, RequiredDate, ShippedDate, (ShippedDate - RequiredDate) DAY TO SECOND as TimeToShip from Orders'!

uniqueIndicesOf: aString
	^connection uniqueIndicesOf: aString!

validDoubleValues
	^{ nil. 0. -1. 3 / 8. 1.79e308. -2.23e-308. Float fmin. }!

verifyCanStoreNonFiniteFloats: aDBParameterizedStatement
	| inserted |
	"Postgres can store non-finite floats"
	{ Float infinity. Float nan. Float negativeInfinity } keysAndValuesDo: 
			[:i :each |
			aDBParameterizedStatement values: { 100 + i. each }.
			aDBParameterizedStatement exec].
	inserted := (self query: 'select "<2s>" from "<1s>" where "ID" > 100'
						<< { self temporaryTableName. self temporaryColumnName })
				collect: [:each | each atIndex: 1].
	self assert: inserted first equals: Float infinity.
	self assert: inserted second isNaN.
	self assert: inserted third equals: Float negativeInfinity!

verifyInvalidDates: insert
	insert values: { 100. Date newDay: 365 year: -1 }.
	self execShouldRaiseSqlInvalidDateFormat: insert.
	insert values: { 100. Date newDay: 1 year: 10000 }.
	self execShouldRaiseSqlDateOverflow: insert!

verifyInvalidFloatValues: aDBParameterizedStatement
	{ Float infinity. Float nan. Float negativeInfinity } do: 
			[:each |
			aDBParameterizedStatement values: { 100. each }.
			self execShouldRaiseSqlInvalidDouble: aDBParameterizedStatement]! !

!Database.Tests.DBConnectionTest categoriesForMethods!
ageAtHireQuery!constants!private! !
allDataTypes!constants!private! !
categoriesColumns!constants!private! !
columnOverflowSqlState!constants!private! !
columnsOf:!helpers!private! !
columnTypeNameBinary!constants!private! !
columnTypeNameBlob!constants!private! !
columnTypeNameDateTime!constants!private! !
columnTypeNameDateTimeWithOffset!constants!private! !
columnTypeNameDouble!constants!private! !
columnTypeNameVarBinary!constants!private! !
columnTypeNameWideChar!constants!private! !
columnTypeNameWideVarChar!constants!private! !
createTableStatementTemplate!constants!private! !
createTestTable:!helpers!private! !
createTestTable:qualifiers:!helpers!private! !
createTestTable:qualifiers:nullable:!helpers!private! !
createTimeTestTable!helpers!private! !
databaseName!public! !
databaseResource!constants!private! !
dataSourceName!constants!private! !
dbmsFeaturesMap!constants!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
defaultDateTimeColumnScale!constants!private! !
defaultDatetimeWithOffsetScale!constants!private! !
defaultTransactionIsolation!constants!private! !
dropTestTable!helpers!private! !
dsn!accessing!public! !
exampleLongText!constants!private! !
exec:!helpers!private! !
execShouldRaiseIntegerOutOfRange:!helpers!private! !
execShouldRaiseSqlDateOverflow:!private! !
execShouldRaiseSqlInvalidDateFormat:!private! !
execShouldRaiseSqlInvalidDouble:!private! !
execShouldRaiseSqlNumberOutOfRange:!private! !
execShouldRaiseSqlTruncatedString:!helpers!private! !
execShouldRaiseTypeMismatch:!helpers!private! !
field:fromRow:!helpers!private! !
getTypeInfoDataTypeColumn!constants!private! !
hasDateTimeOffsetDataType!private!testing! !
hasFixedWidthBinaryDataType!private!testing! !
hasIntervalDataType!private!testing! !
hasNumericDataType!private!testing! !
hasTimeDataType!private!testing! !
hasVarBinaryWithLimitDataType!private!testing! !
insertsNullForEmptyBinary!constants!private! !
insertsNullForEmptyBinaryIfUnbound!constants!private! !
insertsNullForEmptyString!constants!private! !
intervalLiteralsQuery!constants!private! !
invalidDates!private! !
invalidDatesAndTimesWithOffset!private! !
matchInvalidDateTime:!helpers!private! !
nameUpdateTestPairs!constants!private! !
orderDetailsTable!constants!private! !
ordersColumns!constants!private! !
ordersRowVersionColumns!constants!private! !
orderTableRowIds!constants!private! !
prepare:!helpers!private! !
query:cursorType:!helpers!private! !
requiredOdbcVersion!constants!private! !
rowIdColumnsOf:!public!unit tests! !
scaleOfTimeColumns!constants!private! !
setUp!public!running! !
shouldRaiseNotSupported:!helpers!private! !
sqlDataTypeBlob!constants!private! !
sqlDataTypeTime!constants!private! !
sqlDataTypeVarChar!public!unit tests! !
sqlStateGeneralError!constants!private! !
sqlStateInvalidDouble!constants!private! !
sqlStateTruncatedString!constants!private! !
supportsIntervalStructs!private!testing! !
supportsReadOnlyMode!private!testing! !
tables!helpers!private! !
tearDown!public!running! !
temporaryColumnName!helpers!private! !
temporaryTableName!constants!private! !
testAsArray!public!unit tests! !
testColumnsQuery!public!unit tests! !
testColumnTypeBinary!public!unit tests! !
testColumnTypeBlob!public!unit tests! !
testColumnTypeChar!public!unit tests! !
testColumnTypeDate!public!unit tests! !
testColumnTypeDatetime!public!unit tests! !
testColumnTypeDatetimeOffset!public!unit tests! !
testColumnTypeFloat!public!unit tests! !
testColumnTypeNumeric!public!unit tests! !
testColumnTypeReal!public!unit tests! !
testColumnTypeTime!public!unit tests! !
testColumnTypeVarBinaryBound!public!unit tests! !
testColumnTypeVarBinaryUnbound!public!unit tests! !
testColumnTypeVarCharBound!public!unit tests! !
testColumnTypeVarCharBoundOverflow!public!unit tests! !
testColumnTypeVarCharUnbound!public!unit tests! !
testColumnTypeVarCharUnboundOverflow!public!unit tests! !
testColumnTypeWChar!public!unit tests! !
testColumnTypeWCharExtendedChars!public!unit tests! !
testColumnTypeWVarCharBound!public!unit tests! !
testColumnTypeWVarCharUnbound!public!unit tests! !
testConnectionAttributes!public!unit tests! !
testConnectionEnquiries!public!unit tests! !
testConnectionReadOnly!public!unit tests! !
testDataTypesQuery!public!unit tests! !
testDateDiff!public!unit tests! !
testDateTimeDiff!public!unit tests! !
testDayToSecondsIntervals!public!unit tests! !
testIntervalLiterals!public!unit tests! !
testMonthIntervals!public!unit tests! !
testPreparedQuery!public!unit tests! !
testQueryAndUpdateBlob!public!unit tests! !
testQueryAndUpdateDateTime!public!unit tests! !
testQueryAndUpdateNClob!public!unit tests! !
testQueryAndUpdateNumeric!public!unit tests! !
testSpecialColumnsQuery!public!unit tests! !
testStatisticsQuery!public!unit tests! !
testTablesQuery!public!unit tests! !
testTracing!public!unit tests! !
testUpdateBlobSetNull!public!unit tests! !
testUpdateNClobSetNull!public!unit tests! !
testUpdateWCharField!public!unit tests! !
testYearToMonthIntervals!public!unit tests! !
timeToShipQuery!constants!private! !
uniqueIndicesOf:!helpers!private! !
validDoubleValues!constants!private! !
verifyCanStoreNonFiniteFloats:!helpers!private! !
verifyInvalidDates:!helpers!private! !
verifyInvalidFloatValues:!helpers!private! !
!

!Database.Tests.DBConnectionTest class methodsFor!

allTestSelectors
	^super allTestSelectors
		select: [:each | 
			[(self selector: each) evaluatePreconditions.
			true] on: TestSkip do: [:ex | false]]!

allUnsupportedTests
	"Answer a collection of the selectors of all tests that exercise functionality that is not supported by the tested DBMS."

	^#()! !

!Database.Tests.DBConnectionTest class categoriesForMethods!
allTestSelectors!Accessing!public! !
allUnsupportedTests!Accessing!public! !
!

