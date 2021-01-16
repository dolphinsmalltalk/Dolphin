"Filed out from Dolphin Smalltalk 7"!

Database.Tests.DBConnectionTest subclass: #'Database.Tests.SQLServerDBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Database.Tests.SQLServerDBTest guid: (Core.GUID fromString: '{375baeed-7973-4ad7-bb24-296438e82792}')!
Database.Tests.SQLServerDBTest comment: ''!
!Database.Tests.SQLServerDBTest categoriesForClass!Unclassified! !
!Database.Tests.SQLServerDBTest methodsFor!

databaseResource
	^SQLServerNorthwindDB current!

dbmsFeaturesMap
	"Private - Deliberately leave outer #serverName as this will vary by configuration"

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

queryColumns
	^#(#('OrderID' 4 4) #('CustomerID' ##(SQL_WCHAR) 10) #('EmployeeID' 4 4) #('OrderDate' 93 16) #('RequiredDate' 93 16) #('ShippedDate' 93 16) #('ShipVia' 4 4) #('Freight' ##(SQL_DECIMAL) 21) #('ShipName' ##(SQL_WVARCHAR) 80) #('ShipAddress' ##(SQL_WVARCHAR) 120) #('ShipCity' ##(SQL_WVARCHAR) 30) #('ShipRegion' ##(SQL_WVARCHAR) 30) #('ShipPostalCode' ##(SQL_WVARCHAR) 20) #('ShipCountry' ##(SQL_WVARCHAR) 30))!

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
	self assert: connection pwd notNil!

testTablesQuery
	| tables |
	tables := connection
				tables: nil
				owners: 'dbo'
				tables: nil
				types: '''TABLE'''.
	self assert: (tables
				noDifference: #('Categories' 'CustomerCustomerDemo' 'CustomerDemographics' 'Customers' 'Employees' 'EmployeeTerritories' 'Order Details' 'Orders' 'Products' 'Region' 'Shippers' 'Suppliers' 'Territories'))!

testViewsQuery
	| views |
	views := connection
				tables: nil
				owners: 'dbo'
				tables: nil
				types: '''VIEW'''.
	self assert: (views
				noDifference: #('Alphabetical list of products' 'Category Sales for 1997' 'Current Product List' 'Customer and Suppliers by City' 'Invoices' 'Order Details Extended' 'Order Subtotals' 'Orders Qry' 'Product Sales for 1997' 'Products Above Average Price' 'Products by Category' 'Quarterly Orders' 'Sales by Category' 'Sales Totals by Amount' 'Summary of Sales by Quarter' 'Summary of Sales by Year'))! !
!Database.Tests.SQLServerDBTest categoriesFor: #databaseResource!private! !
!Database.Tests.SQLServerDBTest categoriesFor: #dbmsFeaturesMap!private! !
!Database.Tests.SQLServerDBTest categoriesFor: #queryColumns!private!unit tests! !
!Database.Tests.SQLServerDBTest categoriesFor: #testForeignKeysQuery!public!unit tests! !
!Database.Tests.SQLServerDBTest categoriesFor: #testPrimaryKeysQuery!public!unit tests! !
!Database.Tests.SQLServerDBTest categoriesFor: #testProceduresQuery!public!unit tests! !
!Database.Tests.SQLServerDBTest categoriesFor: #testSQLServerConnectionAttributes!public!unit tests! !
!Database.Tests.SQLServerDBTest categoriesFor: #testTablesQuery!public! !
!Database.Tests.SQLServerDBTest categoriesFor: #testViewsQuery!public! !

!Database.Tests.SQLServerDBTest class methodsFor!

resources
	^{SQLServerNorthwindDB}! !
!Database.Tests.SQLServerDBTest class categoriesFor: #resources!public! !

