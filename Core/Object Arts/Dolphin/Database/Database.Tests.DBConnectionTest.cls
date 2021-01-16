"Filed out from Dolphin Smalltalk 7"!

DBTest subclass: #DBConnectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Smalltalk.ODBCConstants} #{Smalltalk.ODBCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!
DBConnectionTest guid: (Core.GUID fromString: '{0a84fa8d-f7c4-4bbe-b459-da0409a391b9}')!
DBConnectionTest isNonInstantiable: true!
DBConnectionTest comment: 'SUnitBrowser openOnTestCase: self.

If these tests fail make sure that Tests\NWind.mdb is available and NOT write protected.'!
!DBConnectionTest categoriesForClass!Unclassified! !
!DBConnectionTest methodsFor!

databaseResource
	self subclassResponsibility!

dbmsFeaturesMap
	"Private - Override in subclasses"

	^LookupTable new!

field: aString fromRow: aDBRow 
	^aDBRow at: aString!

queryColumns
	self subclassResponsibility!

shouldRaiseNotSupported: block 
	self 
		should: block
		raise: DBError
		matching: [:e | e tag errors anySatisfy: [:x | x sqlState = 'IM001']]!

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
	| columns |
	columns := connection columns: 'Orders'.
	columns
		with: self queryColumns
		do: 
			[:eachCol :eachArray |
			| type |
			self assert: eachCol name = eachArray first.
			type := eachArray second.
			self assert: eachCol type = type.
			self assert: eachCol length = eachArray third]!

testConnectionAttributes
	self assert: connection driverHDBC notNull.
	self assert: connection driverHEnv notNull.
	self assert: connection willAutoCommit.
	connection willAutoCommit: false.
	self assert: connection willAutoCommit not.
	connection willAutoCommit: true.
	self assert: connection willAutoCommit.
	self assert: connection isReadOnly not.
	connection isReadOnly: true.
	self assert: connection isReadOnly.
	connection isReadOnly: false.
	self assert: connection isReadOnly not.
	self assert: connection transactionIsolation = #readCommitted.
	self 
		should: [connection transactionIsolation: #hash]
		raise: Error
		matching: [:ex | ex messageText = 'value not found: #hash'].!

testConnectionEnquiries
	self assert: (connection databaseName asLowercase indexOfSubCollection: 'northwind') ~~ 0.
	self assert: (connection dataSourceName = connection dsn
				or: [connection dataSourceName isEmpty and: [connection dsn isNil]]).
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
	locator := self class owningPackage fileLocator.
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

testPackagesCorrectlySetUp
	"The base package should not be dependent upon the development system."
	self assert: ((Package manager packageNamed: 'Database Connection Base') prerequisites collect: [:each | each name]) asArray sort equals: #('Dolphin' 'Dolphin Legacy Date & Time')!

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

testTracing
	| traceFile |
	traceFile := File composePath: File tempPath subPath: 'BLAH.LOG'.
	connection traceFile: traceFile.
	self assert: connection traceFile equals: traceFile.
	self assert: connection isTracing.
	connection isTracing: false.
	self assert: connection isTracing not.
	File delete: traceFile
! !
!DBConnectionTest categoriesFor: #databaseResource!public! !
!DBConnectionTest categoriesFor: #dbmsFeaturesMap!constants!private! !
!DBConnectionTest categoriesFor: #field:fromRow:!private!unit tests! !
!DBConnectionTest categoriesFor: #queryColumns!private! !
!DBConnectionTest categoriesFor: #shouldRaiseNotSupported:!helpers!public! !
!DBConnectionTest categoriesFor: #testAsArray!public!unit tests! !
!DBConnectionTest categoriesFor: #testColumnsQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testConnectionAttributes!public!unit tests! !
!DBConnectionTest categoriesFor: #testConnectionEnquiries!public!unit tests! !
!DBConnectionTest categoriesFor: #testConnectionString!public!unit tests! !
!DBConnectionTest categoriesFor: #testConnectStringDo!public!unit tests! !
!DBConnectionTest categoriesFor: #testDSNlessConnection!public!unit tests! !
!DBConnectionTest categoriesFor: #testPackagesCorrectlySetUp!public!unit tests! !
!DBConnectionTest categoriesFor: #testPreparedQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testSpecialColumnsQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testStatisticsQuery!public!unit tests! !
!DBConnectionTest categoriesFor: #testTracing!public!unit tests! !

