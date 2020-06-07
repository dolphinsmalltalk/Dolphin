"Filed out from Dolphin Smalltalk 7"!

DBTest subclass: #DBConnectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ODBCConstants ODBCTypes'
	classInstanceVariableNames: ''!
DBConnectionTest guid: (GUID fromString: '{0a84fa8d-f7c4-4bbe-b459-da0409a391b9}')!
DBConnectionTest comment: 'SUnitBrowser openOnTestCase: self.

If these tests fail make sure that Tests\NWind.mdb is available and NOT write protected.'!
!DBConnectionTest categoriesForClass!Unclassified! !
!DBConnectionTest methodsFor!

accessFeaturesMap
	"See MSDN help 'SQLGetInfo Returned Values for Access"

	| featuresMap |
	featuresMap := LookupTable new.
	featuresMap
		at: #dbmsName put: #(#sameAs: 'ACCESS');
		at: #defaultTransactionIsolation put: #(#== #readCommitted);
		at: #driverName put: #(#sameAs: 'odbcjt32.dll');
		at: #hasAccessibleTables put: #(#== true);
		at: #hasIntegrityEnhancementFacility put: #(#== false);
		at: #identifierCase put: #(#= ##(SQL_IC_SENSITIVE));
		at: #identifierQuoteCharacter put: #(#= ##($`));
		at: #isSAGCompliant put: #(#== false);
		at: #isSourceReadOnly put: #(#== false).
	featuresMap at: #maxCatalogNameLength put: #(#= 260).	"docs say 66?"
	featuresMap
		at: #maxColumnNameLength put: #(#= 64);
		at: #maxConnections put: #(#= 64);
		at: #maxCursorNameLength put: #(#= 64);
		at: #maxProcedureNameLength put: #(#= 64);
		at: #maxSchemaNameLength put: #(#= 0);
		at: #maxStatements put: #(#= 0);
		at: #maxTableNameLength put: #(#= 64);
		at: #odbcConformance put: #(#= 1);
		at: #odbcSQLConformance put: #(#= 0).	"?"
	^featuresMap
		at: #procedureTerm put: #(#sameAs: 'QUERY');
		at: #schemaTerm put: #(#sameAs: '');
		at: #tableTerm put: #(#sameAs: 'TABLE');
		at: #serverName put: #(#sameAs: 'ACCESS');
		at: #catalogTerm put: #(#sameAs: 'DATABASE');
		at: #supportedCursorTypes put: #(#noDifference: #(#forwardOnly #keysetDriven #static));
		at: #supportedTransactionIsolationLevels put: #(#noDifference: #(#readCommitted));
		at: #supportsExpressionsInOrderBy put: #(#== true);
		at: #supportsMultipleActiveTransactions put: #(#== true);
		at: #supportsMultipleResultSets put: #(#== false);
		at: #supportsOuterJoins put: #(#== true);
		at: #supportsRowUpdates put: #(#== false);
		at: #userName put: #(#= 'admin');
		at: #convertFunctions put: #(#noDifference: #('SQL_FN_CVT_CONVERT'));
		at: #searchPatternEscape put: #(#= '\');
		yourself!

assertAccessConnectionAttributes
	self should: [connection transactionIsolation: #readUncommitted] raise: DBError.
	self should: [connection loginTimeout: 30] raise: DBError.
	self should: [self assert: connection loginTimeout = 30] raise: DBError.
	self should: [connection translate] raise: DBError.
	self should: [connection translate: 0] raise: DBError.
	self should: [connection translationDLL] raise: DBError.
	self should: [connection translationDLL: 'blah.dll'] raise: DBError.
	self assert: connection uid isNil!

assertSQLServerConnectionAttributes
	connection transactionIsolation: #readUncommitted.
	self assert: connection transactionIsolation = #readUncommitted.
	connection loginTimeout: 30.
	self assert: connection loginTimeout = 30.
	connection translate: 1.
	self assert: connection translate = 1.
	self assert: connection translationDLL isEmpty.
	"SQL server seems to ignore this"
	connection translationDLL: 'sqlsort.dll'
	"But we get junk back".
"	self assert: connection translationDLL isEmpty."
	self assert: connection uid isNil!

connectString
	"	^'DSN=NWindSQL'."

	"'DSN=MS Access Database;DBQ=C:\OBJECT ARTS\DEV\DOLPHIN6\OBJECT ARTS\DOLPHIN\Tests\Northwind.mdb;DefaultDir=C:\OBJECT ARTS\DEV\DOLPHIN6\OBJECT ARTS\DOLPHIN\Tests;DriverId=25;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;'"

	| locator filename source |
	locator := PackageRelativeFileLocator package: self class owningPackage.
	source := locator localFileSpecFor: 'Northwind.mdb'.
	filename :=File composePath: File tempPath subPath: 'Northwind.mdb'.
	File copy: source to: filename.
	(File isWriteable: filename) ifFalse: [File isWriteable: filename set: true].
	^'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=<1s>' expandMacrosWith: filename with: locator basePath!

dbmsFeaturesMap
	self isAccessDB ifTrue: [^self accessFeaturesMap].
	^self sqlServerFeaturesMap!

isAccessDB
	^connection dbmsName = 'ACCESS'!

setUp
	"Use the NorthWind sample database as a conveniently available DB"

	connection := DBConnection new connectString: self connectString.
	connection open!

shouldRaiseNotSupported: block 
	self 
		should: block
		raise: DBError
		matching: [:e | e tag errors anySatisfy: [:x | x sqlState = 'IM001']]!

sqlServerFeaturesMap
	"Deliberately leave outer #serverName as this will vary by configuration"

	^(LookupTable new)
		at: #dbmsName put: #(#sameAs: 'Microsoft SQL Server');
		at: #defaultTransactionIsolation put: #(#== #readCommitted);
		at: #driverName put: #(#sameAs: 'SQLSRV32.DLL');
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
		at: #catalogTerm put: #(#sameAs: 'DATABASE');
		at: #tableTerm put: #(#sameAs: 'TABLE');
		at: #supportedCursorTypes
			put: #(#noDifference: #(#forwardOnly #keysetDriven #static #dynamic));
		at: #supportedTransactionIsolationLevels
			put: #(#noDifference: #(#readUncommitted #readCommitted #serializable #repeatableRead));
		at: #supportsExpressionsInOrderBy put: #(#== true);
		at: #supportsMultipleActiveTransactions put: #(#== true);
		at: #supportsMultipleResultSets put: #(#== true);
		at: #supportsOuterJoins put: #(#== true);
		at: #supportsRowUpdates put: #(#== false);
		at: #userName put: #(#= 'dbo');
		at: #convertFunctions put: #(#noDifference: #('SQL_FN_CVT_CONVERT'));
		at: #searchPatternEscape put: #(#= '\');
		yourself!

tearDown
	connection close.
	^super tearDown!

testAsArray
	| results array |
	results := connection query: 'SELECT* FROM Categories'.
	array := results asArray.
	results with: array do: [:row1 :row2 | self assert: row1 = row2].
	"Enumerate again"
	array := results asArray.
	results with: array do: [:row1 :row2 | self assert: row1 = row2].
	"Force with:do: to raise an error"
	self should: [results with: (array copyWith: array first) do: [:a :b | ]] raise: Error.
	self should: 
			[results with: ((array asOrderedCollection)
						removeLast;
						yourself)
				do: [:a :b | ]]
		raise: Error.

	results free.

	"Test a forward only cursor"
	results := connection query: 'SELECT* FROM Categories' cursorType: #forwardOnly.
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

	results := connection query: 'SELECT* FROM Orders WHERE OrderID=-1'
				cursorType: #forwardOnly.
	array := results asArray.
	self assert: array isEmpty.
	array := results asArray.
	self assert: array isEmpty.
	results free.

	results := connection query: 'SELECT* FROM Orders WHERE OrderID=10248'
				cursorType: #forwardOnly.
	array := results asArray.
	self assert: array size == 1.
	self assert: (array first at: 'OrderID') = 10248.
	"Repeat - causing requery"
	array := results asArray.
	self assert: array size == 1.
	self assert: (array first at: 'OrderID') = 10248!

testColumnsQuery
	| columns isAccess |
	isAccess := self isAccessDB.
	columns := connection columns: 'Orders'.
	columns with: (isAccess 
				ifTrue: 
					[#(#('OrderID' 4 4) #('CustomerID' ##(SQL_WVARCHAR) 10) #('EmployeeID' 4 4) #('OrderDate' ##(SQL_TYPE_TIMESTAMP) 16) #('RequiredDate' ##(SQL_TYPE_TIMESTAMP) 16) #('ShippedDate' ##(SQL_TYPE_TIMESTAMP) 16) #('ShipVia' 4 4) #('Freight' 2 21) #('ShipName' ##(SQL_WVARCHAR) 80) #('ShipAddress' ##(SQL_WVARCHAR) 120) #('ShipCity' ##(SQL_WVARCHAR) 30) #('ShipRegion' ##(SQL_WVARCHAR) 30) #('ShipPostalCode' ##(SQL_WVARCHAR) 20) #('ShipCountry' ##(SQL_WVARCHAR) 30))]
				ifFalse: 
					[#(#('OrderID' 4 4) #('CustomerID' ##(SQL_WCHAR) 10) #('EmployeeID' 4 4) #('OrderDate' 11 16) #('RequiredDate' 11 16) #('ShippedDate' 11 16) #('ShipVia' 4 4) #('Freight' ##(SQL_DECIMAL) 21) #('ShipName' ##(SQL_WVARCHAR) 80) #('ShipAddress' ##(SQL_WVARCHAR) 120) #('ShipCity' ##(SQL_WVARCHAR) 30) #('ShipRegion' ##(SQL_WVARCHAR) 30) #('ShipPostalCode' ##(SQL_WVARCHAR) 20) #('ShipCountry' ##(SQL_WVARCHAR) 30))])
		do: 
			[:eachCol :eachArray | 
			| type |
			self assert: eachCol name = eachArray first.
			type := eachArray second.
			self assert: eachCol type = type.
			self assert: eachCol length = eachArray third]!

testConnectionAttributes
	| dbmsName |
"	self assert: connection connectString = self connectString."
	connection isTracing: true.
	self assert: connection isTracing.
	connection isTracing: false.
	self assert: connection isTracing not.
	self assert: connection driverHDBC notNull.
	self assert: connection driverHEnv notNull.
	self assert: connection willAutoCommit.
	connection willAutoCommit: false.
	self assert: connection willAutoCommit not.
	connection willAutoCommit: true.
	self assert: connection willAutoCommit.

	"If the following test fails make sure that Tests\NWind.mdb is NOT write protected."
	self assert: connection isReadOnly not.
	connection isReadOnly: true.
	self assert: connection isReadOnly.
	connection isReadOnly: false.
	self assert: connection isReadOnly not.
	self assert: connection pwd isNil.
	connection traceFile: '\BLAH.LOG'.
	self assert: (connection traceFile sameAs: '\BLAH.LOG').
	self assert: connection transactionIsolation = #readCommitted.
	self 
		should: [connection transactionIsolation: #hash]
		raise: Error
		matching: [:ex | ex messageText = 'value not found: #hash'].
	dbmsName := connection dbmsName.
	dbmsName = 'ACCESS' ifTrue: [^self assertAccessConnectionAttributes].
	dbmsName = 'Microsoft SQL Server' ifTrue: [^self assertSQLServerConnectionAttributes].
	"Unrecognised DBMS"
	self assert: false!

testConnectionEnquiries
	"self assert: (connection databaseName asLowercase indexOfSubCollection: 'northwind') ~~ 0."

	self assert: (connection dataSourceName = connection dsn 
				or: [connection dataSourceName isEmpty and: [connection dsn isNil]]).
	self dbmsFeaturesMap keysAndValuesDo: 
			[:eachKey :eachValue | 
			| value |
			value := connection perform: eachKey.
			self assert: (value perform: eachValue first with: eachValue second)].
	self assert: connection cursorCommitBehaviour = SQL_CB_CLOSE.
	self assert: connection cursorRollbackBehaviour = SQL_CB_CLOSE.
	self assert: (((connection columns: 'Orders') collect: [:each | each name]) 
				noDifference: #('OrderID' 'CustomerID' 'EmployeeID' 'OrderDate' 'RequiredDate' 'ShippedDate' 'ShipVia' 'Freight' 'ShipName' 'ShipAddress' 'ShipCity' 'ShipRegion' 'ShipPostalCode' 'ShipCountry')).
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

testDSNlessConnection
	"See MSDN help 'SQLGetInfo Returned Values for Access"

	| c connStr locator |
	c := DBConnection new.
	locator := PackageRelativeFileLocator package: self class owningPackage.
	connStr := 'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=<1s>' 
				expandMacrosWith: (locator localFileSpecFor: 'Northwind.mdb')
				with: locator basePath.
	c connectString: connStr.
	c open.
	self assert: (c tables includes: 'Customers').
	c close.
	c := DBConnection new.
	c connectString: connStr.
	c useDriverCompletion: false.
	c open.
	self assert: (c tables includes: 'Customers').
	c close.
	"#1473 - failure to parse connect string containing embedded semi-colons"
	c := DBConnection new.
	c connectString: 'DRIVER={Microsoft Text Driver (*.txt; *.csv)}'!

testForeignKeysQuery
	"The order DB is an Access DB and it doesn't support the foreign key querying stuff"

	| keys map |
	self isAccessDB 
		ifTrue: 
			[self shouldRaiseNotSupported: [connection queryForeignKeysOf: 'Orders'].
			^self].
	keys := connection queryForeignKeysOf: 'Orders'.
	self assert: keys size = 3.
	map := LookupTable new.
	keys do: [:each | map at: (each at: 'PKTABLE_NAME') put: each].
	#(#('Customers' 'CustomerID') #('Employees' 'EmployeeID') #('Shippers' 'ShipperID' 'ShipVia')) do: 
			[:each | 
			| key |
			key := map at: each first.
			self assert: (key at: 'PKCOLUMN_NAME') = each second.
			self assert: (key at: 'FKCOLUMN_NAME') = each last].
!

testIsEmpty
	| results |
	super testIsEmpty.
	"Access is able to return a row count for Update statements - first a null update"
	results := connection 
				query: 'UPDATE categories SET CategoryName = ''Nothing'' WHERE CategoryID is Null'.
	self assert: results isEmpty.
	results free.

	"Now an update that works"
	results := connection query: 'UPDATE categories SET CategoryName = ''Drinks'' WHERE CategoryID = 1'.
	self deny: results isEmpty.
	results free!

testPackagesCorrectlySetUp
	"The base package should not be dependent upon the development system."
	self assert: ((Package manager packageNamed: 'Database Connection Base') prerequisites allSatisfy: [:each | each name = 'Dolphin' or: [each name = 'Dolphin Legacy Date & Time']])!

testPreparedQuery
	| statement results |
	statement := connection prepare: 'select * from Suppliers where SupplierID=?'.
	statement paramCols: (Array with: ((connection columns: 'Suppliers') at: 1)).
	statement values: #(3).
	statement exec.
	results := statement results.
	self assert: results size = 1.
	self assert: (results first at: 'ContactName') = 'Regina Murphy'.
	results free!

testPrimaryKeysQuery
	"The order DB is an Access DB and it doesn't support the key querying stuff"

	| pkeys |
	self isAccessDB 
		ifTrue: 
			[self shouldRaiseNotSupported: [connection primaryKeysOf: 'Orders'].
			^self].
	pkeys := connection primaryKeysOf: 'Orders'.
	self assert: pkeys size = 1.
	self assert: pkeys first = 'OrderID'!

testProceduresQuery
	| procs |
	procs := connection procedures.
	self isAccessDB 
		ifTrue: [self assert: (procs includes: 'Employee Sales by Country')]
		ifFalse: [self assert: (procs includes: 'Employee Sales by Country;1')]!

testSpecialColumnsQuery
	| rowIds |
	rowIds := connection rowIdColumns: 'Orders'.
	self assert: rowIds asArray = #('OrderID').
!

testStatisticsQuery
	| stats pk |
	stats := connection uniqueIndicesOf: 'Orders'.
	self assert: (stats allSatisfy: [:each | (each at: 'TABLE_NAME') = 'Orders']).
	pk := stats detect: [:each | (each at: 'COLUMN_NAME') = 'OrderID'].
	stats := connection indicesOf: 'Orders'.
	self assert: (stats allSatisfy: [:each | (each at: 'TABLE_NAME') = 'Orders']).
	self assert: ((stats collect: [:e | e at: 'INDEX_NAME']) 
				noDifference: (#(nil 'CustomerID' 'CustomersOrders' 'EmployeeID' 'EmployeesOrders' 'OrderDate' 'ShippedDate' 'ShippersOrders' 'ShipPostalCode') 
						copyWith: (pk at: 'INDEX_NAME')))!

testTablesQuery
	| tables |
	tables := connection tables.
	self 
		assert: (tables noDifference: (self isAccessDB 
						ifTrue: 
							[#('Categories' 'Customers' 'Employees' 'Order Details' 'Orders' 'Products' 'Shippers' 'Suppliers')]
						ifFalse: 
							[#('Categories' 'CustomerCustomerDemo' 'CustomerDemographics' 'Customers' 'Employees' 'EmployeeTerritories' 'Order Details' 'Orders' 'Products' 'Region' 'Shippers' 'Suppliers' 'Territories')]))!

testViewsQuery
	| views |
	views := connection views.
	self 
		assert: (views noDifference: (self isAccessDB 
						ifTrue: 
							[#('Alphabetical List of Products' 'Category Sales for 1997' 'Current Product List' 'Customers and Suppliers by City' 'Employee Sales by Country' 'Invoices' 'Invoices Filter' 'Order Details Extended' 'Order Subtotals' 'Orders Qry' 'Product Sales for 1997' 'Products Above Average Price' 'Products by Category' 'Quarterly Orders' 'Quarterly Orders by Product' 'Sales by Category' 'Sales by Year' 'Ten Most Expensive Products')]
						ifFalse: 
							[#('Alphabetical list of products' 'Category Sales for 1997' 'Current Product List' 'Customer and Suppliers by City' 'Invoices' 'Order Details Extended' 'Order Subtotals' 'Orders Qry' 'Product Sales for 1997' 'Products Above Average Price' 'Products by Category' 'Quarterly Orders' 'Sales by Category' 'Sales Totals by Amount' 'Summary of Sales by Quarter' 'Summary of Sales by Year' 'sysconstraints' 'syssegments')]))! !
!DBConnectionTest categoriesFor: #accessFeaturesMap!constants!private! !
!DBConnectionTest categoriesFor: #assertAccessConnectionAttributes!private!unit tests! !
!DBConnectionTest categoriesFor: #assertSQLServerConnectionAttributes!private!unit tests! !
!DBConnectionTest categoriesFor: #connectString!constants!private! !
!DBConnectionTest categoriesFor: #dbmsFeaturesMap!constants!private! !
!DBConnectionTest categoriesFor: #isAccessDB!public!unit tests! !
!DBConnectionTest categoriesFor: #setUp!public!Running! !
!DBConnectionTest categoriesFor: #shouldRaiseNotSupported:!helpers!public! !
!DBConnectionTest categoriesFor: #sqlServerFeaturesMap!constants!private! !
!DBConnectionTest categoriesFor: #tearDown!public!Running! !
!DBConnectionTest categoriesFor: #testAsArray!public!unit tests! !
!DBConnectionTest categoriesFor: #testColumnsQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testConnectionAttributes!public!unit tests! !
!DBConnectionTest categoriesFor: #testConnectionEnquiries!public!unit tests! !
!DBConnectionTest categoriesFor: #testConnectionString!public!unit tests! !
!DBConnectionTest categoriesFor: #testConnectStringDo!public!unit tests! !
!DBConnectionTest categoriesFor: #testDSNlessConnection!public!unit tests! !
!DBConnectionTest categoriesFor: #testForeignKeysQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testIsEmpty!public!unit tests! !
!DBConnectionTest categoriesFor: #testPackagesCorrectlySetUp!public!unit tests! !
!DBConnectionTest categoriesFor: #testPreparedQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testPrimaryKeysQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testProceduresQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testSpecialColumnsQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testStatisticsQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testTablesQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testViewsQuery!public!unit tests! !

