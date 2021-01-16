"Filed out from Dolphin Smalltalk 7"!

DBConnectionTest subclass: #AccessDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
AccessDBTest guid: (Core.GUID fromString: '{4f4de5da-13fa-4842-941a-f825ce1db278}')!
AccessDBTest comment: ''!
!AccessDBTest categoriesForClass!Unclassified! !
!AccessDBTest methodsFor!

databaseResource
	^AccessNorthwindDB current !

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

queryColumns
	^#(#('OrderID' 4 4) #('CustomerID' ##(SQL_WVARCHAR) 10) #('EmployeeID' 4 4) #('OrderDate' ##(SQL_TYPE_TIMESTAMP) 16) #('RequiredDate' ##(SQL_TYPE_TIMESTAMP) 16) #('ShippedDate' ##(SQL_TYPE_TIMESTAMP) 16) #('ShipVia' 4 4) #('Freight' 2 21) #('ShipName' ##(SQL_WVARCHAR) 80) #('ShipAddress' ##(SQL_WVARCHAR) 120) #('ShipCity' ##(SQL_WVARCHAR) 30) #('ShipRegion' ##(SQL_WVARCHAR) 30) #('ShipPostalCode' ##(SQL_WVARCHAR) 20) #('ShipCountry' ##(SQL_WVARCHAR) 30))!

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
!AccessDBTest categoriesFor: #databaseResource!private! !
!AccessDBTest categoriesFor: #dbmsFeaturesMap!private! !
!AccessDBTest categoriesFor: #queryColumns!private! !
!AccessDBTest categoriesFor: #testAccessConnectionAttributes!public!unit tests! !
!AccessDBTest categoriesFor: #testForeignKeysQuery!public!unit tests! !
!AccessDBTest categoriesFor: #testPrimaryKeysQuery!public!unit tests! !
!AccessDBTest categoriesFor: #testProceduresQuery!public!unit tests! !
!AccessDBTest categoriesFor: #testTablesQuery!public!unit tests! !
!AccessDBTest categoriesFor: #testViewsQuery!public!unit tests! !

!AccessDBTest class methodsFor!

resources
	^{AccessNorthwindDB}! !
!AccessDBTest class categoriesFor: #resources!public! !

