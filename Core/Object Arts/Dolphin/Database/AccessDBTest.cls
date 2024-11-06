"Filed out from Dolphin Smalltalk"!

DBConnectionTest subclass: #AccessDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AccessDBTest guid: (GUID fromString: '{4f4de5da-13fa-4842-941a-f825ce1db278}')!

AccessDBTest comment: ''!

!AccessDBTest categoriesForClass!Unclassified! !

!AccessDBTest methodsFor!

categoriesColumns
	^{{'CategoryID'. SQL_INTEGER. 10. 0. 4}.
		{'CategoryName'. SQL_WVARCHAR. 15. nil. 30}.
		{'Description'. SQL_WLONGVARCHAR. 1073741823. nil. 2147483646}.
		{'Picture'. SQL_LONGVARBINARY. 1073741823. nil. 1073741823}}!

databaseName
	^File removeExtension: self databaseResource filename!

databaseResource
	^AccessNorthwindDB current !

dataSourceName
	^''!

dbmsFeaturesMap
	"Private - See MSDN help 'SQLGetInfo Returned Values for Access"

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

ordersColumns
	"Note that timestamps have no fractional seconds"

	^{{'OrderID'. SQL_INTEGER. 10. 0. 4}.
		{'CustomerID'. SQL_WVARCHAR. 5. nil. 10}.
		{'EmployeeID'. SQL_INTEGER. 10. 0. 4}.
		{'OrderDate'. SQL_TYPE_TIMESTAMP. 19. 0. SQL_TIMESTAMP_STRUCT byteSize}.
		{'RequiredDate'. SQL_TYPE_TIMESTAMP. 19. 0. SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShippedDate'. SQL_TYPE_TIMESTAMP. 19. 0. SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShipVia'. SQL_INTEGER. 10. 0. 4}.
		{'Freight'. SQL_NUMERIC. 19. 4. 21}.
		{'ShipName'. SQL_WVARCHAR. 40. nil. 80}.
		{'ShipAddress'. SQL_WVARCHAR. 60. nil. 120}.
		{'ShipCity'. SQL_WVARCHAR. 15. nil. 30}.
		{'ShipRegion'. SQL_WVARCHAR. 15. nil. 30}.
		{'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 20}.
		{'ShipCountry'. SQL_WVARCHAR. 15. nil. 30}}!

testAccessConnectionAttributes
	self should: [connection transactionIsolation: #readUncommitted] raise: DBError.
	self should: [connection loginTimeout: 30] raise: DBError.
	self should: [self assert: connection loginTimeout = 30] raise: DBError.
	self should: [connection translate] raise: DBError.
	self should: [connection translate: 0] raise: DBError.
	self should: [connection translationDLL] raise: DBError.
	self should: [connection translationDLL: 'blah.dll'] raise: DBError.
	self assert: connection uid isNil.
	self assert: connection pwd isNil!

testDSNlessConnection
	"See MSDN help 'SQLGetInfo Returned Values for Access"

	| c connStr locator |
	c := DBConnection new.
	locator := PackageRelativeFileLocator package: self class owningPackage.
	connStr := 'DRIVER={Microsoft Access Driver (*.mdb)};DBQ=<1s>' 
				expandMacrosWith: (locator localFileSpecFor: 'Northwind.mdb')
				with: locator basePath.
	c connectString: connStr.
	c connect.
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

	self shouldRaiseNotSupported: [connection queryForeignKeysOf: 'Orders']!

testPrimaryKeysQuery
	"The order DB is an Access DB and it doesn't support the key querying stuff"

	self shouldRaiseNotSupported: [connection primaryKeysOf: 'Orders']!

testProceduresQuery
	| procs |
	procs := connection procedures.
	self assert: (procs includes: 'Employee Sales by Country')!

testTablesQuery
	| tables |
	tables := connection tables.
	self assert: (tables
				noDifference: #('Categories' 'Customers' 'Employees' 'Order Details' 'Orders' 'Products' 'Shippers' 'Suppliers'))!

testViewsQuery
	| views |
	views := connection views.
	self assert: (views
				noDifference: #('Alphabetical List of Products' 'Category Sales for 1997' 'Current Product List' 'Customers and Suppliers by City' 'Employee Sales by Country' 'Invoices' 'Invoices Filter' 'Order Details Extended' 'Order Subtotals' 'Orders Qry' 'Product Sales for 1997' 'Products Above Average Price' 'Products by Category' 'Quarterly Orders' 'Quarterly Orders by Product' 'Sales by Category' 'Sales by Year' 'Ten Most Expensive Products'))! !

!AccessDBTest categoriesForMethods!
categoriesColumns!constants!private! !
databaseName!constants!private! !
databaseResource!accessing!private! !
dataSourceName!constants!private! !
dbmsFeaturesMap!constants!private! !
ordersColumns!constants!private! !
testAccessConnectionAttributes!public!unit tests! !
testDSNlessConnection!public!unit tests! !
testForeignKeysQuery!public!unit tests! !
testPrimaryKeysQuery!public!unit tests! !
testProceduresQuery!public!unit tests! !
testTablesQuery!public!unit tests! !
testViewsQuery!public!unit tests! !
!

!AccessDBTest class methodsFor!

resources
	^{AccessNorthwindDB}! !

!AccessDBTest class categoriesForMethods!
resources!accessing!public! !
!

