"Filed out from Dolphin Smalltalk"!

DBTest subclass: #DBConnectionTest
	instanceVariableNames: 'dbResources savedBlockSize savedMaxBoundSize createdTestTable'
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCTypes'
	classInstanceVariableNames: ''!

DBConnectionTest guid: (GUID fromString: '{0a84fa8d-f7c4-4bbe-b459-da0409a391b9}')!

DBConnectionTest isAbstract: true!

DBConnectionTest comment: 'SUnitBrowser openOnTestCase: self.

If these tests fail make sure that Tests\NWind.mdb is available and NOT write protected.'!

!DBConnectionTest categoriesForClass!Unclassified! !

!DBConnectionTest methodsFor!

categoriesColumns
	^self subclassResponsibility!

columnOverflowSqlState
	^'HY000'!

createTableStatementTemplate
	^'CREATE TABLE <1s> ( ID INT PRIMARY KEY, <2s> <3s><4d> NULL )'!

createTestTable: aString
	^self createTestTable: aString qualifiers: #()!

createTestTable: aString qualifiers: anArray
	| lengthInsert |
	self dropTestTable.
	lengthInsert := anArray isEmpty
				ifFalse: 
					[String streamContents: 
							[:strm |
							strm nextPut: $(.
							anArray do: [:each | strm display: each] separatedBy: [strm nextPut: $,].
							strm nextPut: $)]].
	connection exec: self createTableStatementTemplate
				<< {self temporaryTableName. 'DolphinTestColumn'. aString. lengthInsert}.
	createdTestTable := true.
	^(connection columns: self temporaryTableName)!

databaseName
	^self subclassResponsibility!

databaseResource
	self subclassResponsibility!

dataSourceName
	^self databaseName!

dbmsFeaturesMap
	"Private - Override in subclasses"

	^LookupTable new!

defaultCursorCommitBehavior
	^SQL_CB_CLOSE!

defaultCursorRollbackBehaviour
	^SQL_CB_CLOSE!

defaultTransactionIsolation
	^#readCommitted!

dropTestTable
	connection asParameter isNull ifTrue: [^self].
	self freeDbResources.
	[connection exec: 'DROP TABLE ' , self temporaryTableName] on: DBError do: [:ex | ex toTrace]!

dsn
	^Error notYetImplemented!

field: aString fromRow: aDBRow 
	^aDBRow at: aString!

freeDbResources
	dbResources do: [:each | each free].
	dbResources := OrderedCollection new!

isNumericOutOfRangeError: ex
	^ex sqlState = '22003'!

matchInvalidDateTime: ex
	^ex sqlState = '22008' or: [ex sqlState = '22007']!

nameUpdateTestPairs
	^{#('0123456789' '🐬s'). #('012345678' 'a'). #('ᚠᛇᚻ' 'Davolios'). {'Nancy'. 'Davolio'}}!

orderDetailsTable
	^'"Order Details"'!

ordersColumns
	self subclassResponsibility!

orderTableRowIds
	^#('OrderID')!

requiredOdbcVersion
	^SQL_OV_ODBC3_80!

setUp
	createdTestTable := false.
	dbResources := OrderedCollection new.
	super setUp.
	DBConnection requiredOdbcVersion: self requiredOdbcVersion.
	savedBlockSize := DBVarFieldBuffer.BlockTransferOctetLength.
	savedMaxBoundSize := DBVarFieldBuffer.MaxBoundOctetLength!

shouldRaiseNotSupported: block 
	self 
		should: block
		raise: DBError
		matching: [:e | e tag errors anySatisfy: [:x | x sqlState = 'IM001']]!

supportsReadOnlyMode
	^true!

tearDown
	savedBlockSize ifNotNil: [DBVarFieldBuffer.BlockTransferOctetLength := savedBlockSize].
	savedMaxBoundSize ifNotNil: [DBVarFieldBuffer.MaxBoundOctetLength := savedMaxBoundSize].
	createdTestTable ifTrue: [self dropTestTable].
	self freeDbResources.
	super tearDown!

temporaryTableName
	^'DOLPHIN_TEST_TABLE'!

testAsArray
	| results array |
	results := connection query: 'SELECT* FROM Employees'.
	array := results asArray.
	results with: array do: [:row1 :row2 | self assert: row1 = row2].
	results asArray with: array do: [:row1 :row2 | self assert: row1 = row2].
	"Query again after deliberately causing the buffers for long variable columns to be too small to provoke SQLGetData loops"
	DBVarFieldBuffer blockTransferOctetLength: 64.
	results free.
	results := connection query: 'SELECT* FROM Employees'.
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
	results := connection query: 'SELECT* FROM Employees'.
	array := results asArray.
	results with: array do: [:row1 :row2 | self assert: row1 = row2].
	"Enumerate again"
	array := results asArray.
	results with: array do: [:row1 :row2 | self assert: row1 = row2].
	results free.
	results := connection query: 'SELECT* FROM Orders WHERE OrderID=-1'.
	array := results asArray.
	self assert: array isEmpty.
	array := results asArray.
	self assert: array isEmpty.
	results free.
	results := connection query: 'SELECT* FROM Orders WHERE OrderID=-1' cursorType: #forwardOnly.
	array := results asArray.
	self assert: array isEmpty.
	array := results asArray.
	self assert: array isEmpty.
	results free.
	results := connection query: 'SELECT* FROM Orders WHERE OrderID=10248' cursorType: #forwardOnly.
	array := results asArray.
	self assert: array size == 1.
	self assert: (array first atIndex: 1) = 10248.
	"Repeat - causing requery"
	array := results asArray.
	self assert: array size == 1.
	self assert: (array first atIndex: 1) = 10248!

testColumnsQuery
	connection isReadOnly: true.
	{'ORDERS'. self ordersColumns. 'CATEGORIES'. self categoriesColumns} pairsDo: 
			[:table :expectedColumns |
			| columns |
			columns := connection columns: table.
			columns with: expectedColumns
				do: 
					[:eachCol :eachArray |
					| type |
					self assert: eachCol name equals: eachArray first.
					type := eachArray second.
					self assert: eachCol type equals: type.
					self assert: eachCol precision equals: eachArray third.
					self assert: eachCol scale equals: eachArray fourth.
					self assert: eachCol length equals: eachArray last]]!

testConnectionAttributes
	self assert: connection driverHDBC notNull.
	self assert: connection driverHEnv notNull.
	self assert: connection willAutoCommit.
	connection willAutoCommit: false.
	self assert: connection willAutoCommit not.
	connection willAutoCommit: true.
	self assert: connection willAutoCommit.
	self assert: connection transactionIsolation equals: self defaultTransactionIsolation.
	self supportsReadOnlyMode
		ifTrue: 
			[self assert: connection isReadOnly not.
			connection isReadOnly: true.
			self assert: connection isReadOnly.
			connection isReadOnly: false.
			self assert: connection isReadOnly not].
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
	self assert: (((connection columns: 'ORDERS') collect: [:each | each name asUppercase])
				noDifference: #('ORDERID' 'CUSTOMERID' 'EMPLOYEEID' 'ORDERDATE' 'REQUIREDDATE' 'SHIPPEDDATE' 'SHIPVIA' 'FREIGHT' 'SHIPNAME' 'SHIPADDRESS' 'SHIPCITY' 'SHIPREGION' 'SHIPPOSTALCODE' 'SHIPCOUNTRY')).
	self assert: (connection rowVersionColumns: 'Orders') isEmpty.
	self assert: (Number readFrom: connection odbcVersion readStream) >= 3.0.
	self assert: connection dbmsVersion notEmpty.
	self assert: connection driverVersion notEmpty.
	self assert: (connection numericFunctions allSatisfy: [:each | each beginsWith: 'SQL_FN_NUM_']).
	self assert: (connection stringFunctions allSatisfy: [:each | each beginsWith: 'SQL_FN_STR_']).
	self assert: (connection systemFunctions allSatisfy: [:each | each beginsWith: 'SQL_FN_SYS_']).
	self assert: (connection timeDateFunctions allSatisfy: [:each | each beginsWith: 'SQL_FN_TD_'])
	"#uniqueIndicesOf: has separate test method"!

testConnectionString
	"#1284"

	| db |
	db := DBConnection new.
	db 
		connectString: ';DSN=PostgreSQL30;DATABASE=money;SERVER=192.168.168.2;PORT=5432;UID=akira;PWD=;A6=;A7=100;A8=4096;B0=254;B1=8190;BI=0;C2=dd_;;CX=1a503ab;EMPTY='.
	self assert: db dsn = 'PostgreSQL30'.
	self assert: db pwd isEmpty.
	self assert: db uid = 'akira'.

	"Attributes must be either empty, or contain a key=value pair"
	"self should: [db connectString: ';DSN;'] raise: Error"!

testConnectStringDo
	| pairs block |
	pairs := OrderedCollection new.
	block := 
			[:paramName :paramValue | 
			pairs
				add: paramName;
				add: paramValue].
	DBConnection 
		connectString: 'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=c:\program files\microsoft office\office\samples\Northwind.mdb'
		do: block.
	self assert: pairs asArray 
				= #('DRIVER' 'Microsoft Access Driver (*.mdb)' 'DBQ' 'c:\program files\microsoft office\office\samples\Northwind.mdb').
	pairs := OrderedCollection new.
	DBConnection connectString: ';;DRIVER={Microsoft Text Driver (*.txt; *.csv)};;DefaultDir=.;Dummy=;'
		do: block.
	self assert: pairs asArray 
				= #('DRIVER' 'Microsoft Text Driver (*.txt; *.csv)' 'DefaultDir' '.' 'Dummy' '').
	pairs := OrderedCollection new.
	DBConnection 
		connectString: ';DSN=PostgreSQL30;DATABASE=money;SERVER=192.168.168.2;PORT=5432;UID=akira;PWD=;A6=;A7=100;A8=4096;B0=254;B1=8190;BI=0;C2=dd_;;CX=1a503ab;EMPTY='
		do: block.
	self assert: pairs asArray 
				= #('DSN' 'PostgreSQL30' 'DATABASE' 'money' 'SERVER' '192.168.168.2' 'PORT' '5432' 'UID' 'akira' 'PWD' '' 'A6' '' 'A7' '100' 'A8' '4096' 'B0' '254' 'B1' '8190' 'BI' '0' 'C2' 'dd_' 'CX' '1a503ab' 'EMPTY' '')!

testPackagesCorrectlySetUp
	"The base package should not be dependent upon the development system."
	self assert: ((Package manager packageNamed: 'Database Connection Base') prerequisites allSatisfy: [:each | each name = 'Dolphin' or: [each name = 'Dolphin Legacy Date & Time']])!

testPreparedQuery
	| statement results |
	connection isReadOnly: true.
	statement := connection prepare: 'select * from Suppliers where SupplierID=?'.
	statement paramCols: (Array with: ((connection columns: 'SUPPLIERS') at: 1)).
	statement values: #(3).
	statement exec.
	results := statement results.
	self assert: results size = 1.
	self assert: (self field: 'ContactName' fromRow: results first) = 'Regina Murphy'.
	results free!

testQueryAndUpdateBlob
	"Test that updating long binary field through a parameterized query (i.e. using SQLPutData) works."

	| update updateStatement resultSet picture row originalPicture selectStatement rowBuffer field |
	DBVarFieldBuffer maxBoundOctetLength: 32768.
	selectStatement := 'SELECT Picture,CategoryID FROM Categories where CategoryID=1'.
	resultSet := connection query: selectStatement.
	row := resultSet single.
	rowBuffer := resultSet buffer.
	field := rowBuffer contents first.
	self assert: field isKindOf: DBLongVarField.
	self assert: field fieldBuf isKindOf: DBVarBinaryBuffer.
	originalPicture := field value.
	self assert: originalPicture isKindOf: ByteArray.
	updateStatement := 'UPDATE Categories SET Picture=? WHERE CategoryID=?'.
	update := connection prepare: updateStatement.
	dbResources add: update.
	update paramCols: resultSet describeCols.
	picture := (Bitmap fromFile: 'Resources\Beach ball.bmp' usingLocator: FileLocator installRelative)
				asByteArray.
	update values: {picture. 1}.
	update exec.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet first.
	self assert: (row atIndex: 1) equals: picture.
	"Repeat but with a deliberately small buffer sizes so the data has to be queried in pieces."
	#(88 86) do: 
			[:each |
			| pic2 |
			DBVarFieldBuffer blockTransferOctetLength: each.
			"We have to re-run the query to get the column buffers rebuilt"
			resultSet := connection query: selectStatement.
			row := resultSet first.
			pic2 := row atIndex: 1.
			resultSet free.
			self assert: pic2 equals: picture].
	"Reset"
	update values: {originalPicture. 1}.
	update exec.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet single.
	self assert: (row atIndex: 1) equals: originalPicture!

testQueryAndUpdateDateTime
	| query colAttr row update sqlQuery timestamp expected |
	sqlQuery := 'select OrderDate FROM Orders WHERE OrderID=10249'.
	query := connection query: sqlQuery.
	colAttr := query describeCols first.
	self assert: colAttr type equals: SQL_TYPE_TIMESTAMP.
	row := query at: 1.
	expected := DateAndTime
				year: 1996
				month: 07
				day: 05.
	self assert: (self field: 'OrderDate' fromRow: row) equals: expected.
	update := connection prepare: 'update Orders SET OrderDate=? WHERE OrderID=10249'.
	dbResources add: update.
	update paramCols: {colAttr}.
	timestamp := DateAndTime fromString: ' 2024-10-06T09:11:35.2516789+01:00'.
	update values: {timestamp}.
	update exec.
	query := connection query: sqlQuery.
	dbResources add: query.
	"Some precision may be lost, depending on the scale of the column. Access discards with a warning, but SQL Server generates an error if too much precision is provided, so we should have rounded to the scale when marshalling the column value"
	self
		assert: (self field: 'OrderDate' fromRow: query first)
		closeTo: timestamp
		precision: colAttr scale exp10 seconds.
	"Reset to original - DB will be dropped anyway, but can be useful for debugging"
	update values: {expected}.
	update exec.
	"Now check for overflow errors"
	update values: {DateAndTime year: -32768 day: 1}.
	"Date out of range"
	self
		should: [update exec]
		raise: DBError
		matching: [:ex | self matchInvalidDateTime: ex].
	"Too large even for the year field of the timestamp struct"
	update values: {DateAndTime year: 32768 day: 1}.
	self
		should: [update exec]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.IntegerOutOfRange)]!

testQueryAndUpdateNClob
	"Test that updating long unicode text fields through a parameterized query (i.e. using SQLPutData) works."

	| update updateStatement resultSet originalDescription row selectStatement rowBuffer field |
	selectStatement := 'SELECT Description,CategoryID FROM Categories where CategoryID=1'.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet first.
	rowBuffer := resultSet buffer.
	field := rowBuffer contents first.
	self assert: field isKindOf: DBLongVarField.
	self assert: field fieldBuf isKindOf: DBVarWCharBuffer.
	originalDescription := field value.
	self assert: originalDescription isKindOf: Utf16String.
	self assert: field length equals: originalDescription size * 2.
	updateStatement := 'UPDATE Categories SET Description=? WHERE CategoryID=?'.
	update := connection prepare: updateStatement.
	dbResources add: update.
	update paramCols: resultSet describeCols.
	update values: {Object comment. 1}.
	update exec.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet first.
	self assert: (row atIndex: 1) equals: Object comment.
	"Repeat but with a deliberately small buffer sizes so the data has to be queried in pieces."
	#(88 86) do: 
			[:each |
			| desc2 pic2 |
			DBVarFieldBuffer blockTransferOctetLength: each.
			"We have to re-run the query to get the column buffers rebuilt"
			resultSet := connection query: selectStatement.
			row := resultSet first.
			desc2 := row atIndex: 1.
			resultSet free.
			self assert: desc2 equals: Object comment].
	"Reset"
	update values: {originalDescription. 1}.
	update exec.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet first.
	self assert: (row atIndex: 1) equals: originalDescription!

testQueryAndUpdateNumeric
	| query colAttr update sqlQuery |
	sqlQuery := 'select UnitPrice,Quantity from <1s> WHERE OrderID=10249 AND ProductID=14'
				<< self orderDetailsTable.
	query := connection query: sqlQuery.
	dbResources add: query.
	colAttr := query describeCols first.
	"Verify some test expectations"
	self assert: colAttr name asUppercase equals: 'UNITPRICE'.
	self assert: (colAttr type == SQL_NUMERIC or: [colAttr type == SQL_DECIMAL]).
	self assert: colAttr precision equals: 19.
	self assert: colAttr scale equals: 4.
	update := connection
				prepare: 'update <1s> SET UnitPrice=? WHERE OrderID=10249 AND ProductID=14' << self orderDetailsTable.
	dbResources add: update.
	update paramCols: {colAttr}.
	"Largest precision of value that column can hold: 15+4"
	#(12.3456s 123456789012345.9999s 18.6s) do: 
			[:price |
			update values: {price}.
			update exec.
			query := connection query: sqlQuery.
			self assert: (self field: 'UnitPrice' fromRow: query first) equals: price].
	update values: #(1234567890123456.1234s).
	self
		should: [update exec]
		raise: DBError
		matching: [:ex | self isNumericOutOfRangeError: ex].
	self assert: update parameters first value equals: 1234567890123456.1234s.
	update values: {-12345678901234567.1234s}.
	self should: [update exec] raise: BoundsError!

testSpecialColumnsQuery
	| rowIds |
	connection isReadOnly: true.
	rowIds := connection rowIdColumns: 'ORDERS'.
	self assert: rowIds asArray equals: self orderTableRowIds!

testStatisticsQuery
	| stats pk |
	connection isReadOnly: true.
	stats := connection uniqueIndicesOf: 'ORDERS'.
	self assert: (stats allSatisfy: [:each | (each at: 'TABLE_NAME') sameAs: 'Orders']).
	pk := stats detect: 
					[:each |
					| name |
					name := each at: 'COLUMN_NAME'.
					name notNil and: [name sameAs: 'OrderID']].
	stats := connection indicesOf: 'ORDERS'.
	self assert: (stats allSatisfy: [:each | (each at: 'TABLE_NAME') sameAs: 'Orders'])!

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

	| update updateStatement resultSet row originalPicture selectStatement |
	selectStatement := 'SELECT Picture,CategoryID FROM Categories where CategoryID=1'.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet single.
	originalPicture := resultSet buffer contents first value.
	self denyIsNil: originalPicture.
	updateStatement := 'UPDATE Categories SET Picture=? WHERE CategoryID=?'.
	update := connection prepare: updateStatement.
	dbResources add: update.
	update paramCols: resultSet describeCols.
	update values: {nil. 1}.
	update exec.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet single.
	self assertIsNil: (row atIndex: 1).
	"Reset"
	update values: {originalPicture. 1}.
	update exec!

testUpdateNClobSetNull
	"Test that updating long unicode text fields through a parameterized query (i.e. using SQLPutData) works."

	| update updateStatement resultSet originalDescription row selectStatement |
	selectStatement := 'SELECT Description,CategoryID FROM Categories where CategoryID=1'.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet first.
	originalDescription := resultSet buffer contents first value.
	self denyIsNil: originalDescription.
	updateStatement := 'UPDATE Categories SET Description=? WHERE CategoryID=?'.
	update := connection prepare: updateStatement.
	dbResources add: update.
	update paramCols: resultSet describeCols.
	update values: {nil. 1}.
	update exec.
	resultSet := connection query: selectStatement.
	dbResources add: resultSet.
	row := resultSet first.
	self assertIsNil: (row atIndex: 1).
	"Reset"
	update values: {originalDescription. 1}.
	update exec!

testUpdateWCharField
	"Test that updating NVARCHAR fields through a parameterized query works."

	| update sqlQuery columns employee9 resultSet firstName lastName |
	sqlQuery := 'SELECT FirstName, LastName FROM Employees WHERE EmployeeID=1'.
	resultSet := connection query: sqlQuery.
	dbResources add: resultSet.
	columns := resultSet describeCols.
	firstName := columns first.
	self assert: firstName precision equals: 10.
	"mysql returns a column length of 30 for 10 unicode chars, probably because it is using UTF-8, although the ODBC transfer type will be SQL_C_WCHAR, and the value is supposed to be the transfer octet length. The maximum encoding for a character in UTF-8 is 4 code units, but no character requires more than 2 UTF-16 code units, so for a 10 char column there is no way the UTF-16 transfer length can be >20."
	self assert: firstName length >= (10 * 2).	"nvarchar(10)"
	lastName := columns second.
	self assert: lastName precision equals: 20.
	self assert: lastName length >= (20 * 2).	"nvarchar(20)"
	update := connection prepare: 'UPDATE Employees SET FirstName=?, LastName=? WHERE EmployeeID=1'.
	dbResources add: update.
	update paramCols: {firstName. lastName}.
	self nameUpdateTestPairs do: 
			[:names |
			update values: names.
			update exec.
			resultSet := connection query: sqlQuery.
			employee9 := resultSet first.
			self assert: (self field: 'FirstName' fromRow: employee9) equals: names first.
			self assert: (self field: 'LastName' fromRow: employee9) equals: names last].
	firstName length > (firstName precision * 2)
		ifTrue: 
			[update values: {'0123456789012345' copyFrom: 1 to: firstName precision + 1. 'Foo'}.
			self
				should: [update exec]
				raise: DBError
				matching: [:ex | ex sqlState = self columnOverflowSqlState]].
	update values: {'0123456789012345' copyFrom: 1 to: firstName length / 2 + 1. 'Foo'}.
	self should: [update exec] raise: BoundsError! !

!DBConnectionTest categoriesForMethods!
categoriesColumns!constants!private! !
columnOverflowSqlState!constants!private! !
createTableStatementTemplate!constants!private! !
createTestTable:!helpers!private! !
createTestTable:qualifiers:!helpers!private! !
databaseName!constants!private! !
databaseResource!constants!private! !
dataSourceName!constants!private! !
dbmsFeaturesMap!constants!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
defaultTransactionIsolation!constants!private! !
dropTestTable!helpers!private! !
dsn!accessing!public! !
field:fromRow:!private!unit tests! !
freeDbResources!helpers!private! !
isNumericOutOfRangeError:!helpers!private! !
matchInvalidDateTime:!helpers!private! !
nameUpdateTestPairs!public!unit tests! !
orderDetailsTable!constants!private! !
ordersColumns!constants!private! !
orderTableRowIds!constants!private! !
requiredOdbcVersion!constants!private! !
setUp!public!running! !
shouldRaiseNotSupported:!helpers!public! !
supportsReadOnlyMode!public!testing! !
tearDown!public!running! !
temporaryTableName!constants!private! !
testAsArray!public!unit tests! !
testColumnsQuery!public!unit tests! !
testConnectionAttributes!public!unit tests! !
testConnectionEnquiries!public!unit tests! !
testConnectionString!public!unit tests! !
testConnectStringDo!public!unit tests! !
testPackagesCorrectlySetUp!public!unit tests! !
testPreparedQuery!public!unit tests! !
testQueryAndUpdateBlob!public!unit tests! !
testQueryAndUpdateDateTime!public!unit tests! !
testQueryAndUpdateNClob!public!unit tests! !
testQueryAndUpdateNumeric!public!unit tests! !
testSpecialColumnsQuery!public!unit tests! !
testStatisticsQuery!public!unit tests! !
testTracing!public!unit tests! !
testUpdateBlobSetNull!public!unit tests! !
testUpdateNClobSetNull!public!unit tests! !
testUpdateWCharField!public!unit tests! !
!

