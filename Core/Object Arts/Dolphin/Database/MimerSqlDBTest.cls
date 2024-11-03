"Filed out from Dolphin Smalltalk"!

DBConnectionTest subclass: #MimerSqlDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MimerSqlDBTest guid: (GUID fromString: '{a7533b57-3642-4098-b4c2-8d9e7b4eda8a}')!

MimerSqlDBTest comment: ''!

!MimerSqlDBTest categoriesForClass!Unclassified! !

!MimerSqlDBTest methodsFor!

categoriesColumns
	^{{'CategoryID'. SQL_INTEGER. 10. 0. 4}.
		{'CategoryName'. SQL_WVARCHAR. 15. nil. 60}.
		{'Description'. SQL_WLONGVARCHAR. 1048576. nil. 4194304}.
		{'Picture'. SQL_LONGVARBINARY. 4194304. nil. 4194304}}!

createTableStatementTemplate
	^'CREATE TABLE <1s> (  ID INT PRIMARY KEY, <2s> <3s><4d> NULL ) IN Northwind'!

databaseName
	^'MIMER'!

databaseResource
	^MimerSqlNorthwindDB current!

defaultTransactionIsolation
	^#repeatableRead!

orderDetailsTable
	^'OrderDetails'!

ordersColumns
	"Mimer's WCHAR's are UTF-32, and its ODBC driver reports WCHAR column octet transfer length as 4x precision. This isn't correct since the transfer format is UTF-16, and therefore the octet transfer length is 2x, not 4x."

	^{{'OrderID'. SQL_INTEGER. 10. 0. 4}.
		{'CustomerID'. SQL_CHAR. 5. nil. 5}.
		{'EmployeeID'. SQL_INTEGER. 10. 0. 4}.
		{'OrderDate'. SQL_TYPE_TIMESTAMP. 26. 6. SQL_TIMESTAMP_STRUCT byteSize}.
		{'RequiredDate'. SQL_TYPE_TIMESTAMP. 26. 6. SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShippedDate'. SQL_TYPE_TIMESTAMP. 26. 6. SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShipVia'. SQL_INTEGER. 10. 0. 4}.
		{'Freight'. SQL_DECIMAL. 10. 2. 13}.
		{'ShipName'. SQL_WVARCHAR. 40. nil. 160}.
		{'ShipAddress'. SQL_WVARCHAR. 60. nil. 240}.
		{'ShipCity'. SQL_WVARCHAR. 15. nil. 60}.
		{'ShipRegion'. SQL_WVARCHAR. 15. nil. 60}.
		{'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 40}.
		{'ShipCountry'. SQL_WVARCHAR. 15. nil. 60}}!

testDateDiff
	| resultSet |
	resultSet := connection
				query: 'SELECT EmployeeID, BirthDate, HireDate, (HireDate - BirthDate) YEAR TO MONTH as AgeAtHire from Employees'.
	dbResources add: resultSet.
	resultSet do: 
			[:each |
			| hired born ageAtHire |
			hired := each at: 'HireDate'.
			born := each at: 'BirthDate'.
			ageAtHire := each at: 'AgeAtHire'.
			self assert: ageAtHire totalYears equals: (hired monthsSince: born) / 12]!

testDateTimeDiff
	| resultSet |
	resultSet := connection
				query: 'SELECT OrderID, RequiredDate, ShippedDate, (ShippedDate - RequiredDate) DAY TO SECOND as TimeToShip from Orders'.
	dbResources add: resultSet.
	resultSet do: 
			[:each |
			| shipped required delay |
			shipped := each at: 'ShippedDate'.
			shipped
				ifNil: [self assert: (each at: 'TimeToShip') isNil]
				ifNotNil: 
					[required := each at: 'RequiredDate'.
					delay := each at: 'TimeToShip'.
					self assert: delay equals: (shipped - required)]]!

testDayToSecondsIntervals
	| resultSet values colAttrs intervalCol insert buf |
	self dropTestTable.
	colAttrs := self createTestTable: 'INTERVAL DAY TO SECOND'.
	insert := connection prepare: 'INSERT INTO <1s> (ID, <2s>) VALUES (?, ?)'
						<< {self temporaryTableName. colAttrs second name}.
	dbResources add: insert.
	insert paramCols: colAttrs.
	intervalCol := colAttrs last.
	values := {30 days.
				48 hours.
				58 days + 5 hours + 22 minutes + 3.109375 seconds.
				0 seconds.
				-31 days}.
	"Do a sanity check that the buffer class is set up and marshals as expected"
	buf := SQL_INTERVAL_STRUCT dbNewForColumn: intervalCol.
	self assert: buf isKindOf: SQL_DAY_SECOND_STRUCT.
	self assert: buf dbInterchangeType equals: ODBCCTypes.SQL_C_INTERVAL_DAY_TO_SECOND.
	values do: 
			[:each |
			buf value: each.
			self assert: buf value equals: each].
	values keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := connection
				query: 'select ID, <2s> from <1s>' << {self temporaryTableName. intervalCol name}.
	dbResources add: resultSet.
	(resultSet collect: [:each | each atIndex: 2]) with: values
		do: [:actual :expected | expected isNil ifTrue: [self assertIsNil: actual] ifFalse: [self assert: actual equals: expected]].
	"Invalid"
	values := {10000000000 / 1000}.
	values keysAndValuesDo: 
			[:key :each |
			insert values: {key * 2. each}.
			self
				should: [insert exec]
				raise: HRESULTError
				matching: [:ex | ex hresult = (HRESULT fromInteger: Win32Errors.STATUS_OBJECT_TYPE_MISMATCH)]]!

testIntervalLiterals
	"Examples based on https://learn.microsoft.com/en-us/sql/odbc/reference/appendixes/interval-literals"

	| resultSet actual |
	resultSet := connection
				query: 'SELECT (INTERVAL ''1997'' YEAR(4)) AS years1997,
						INTERVAL ''993'' MONTH(3) AS months993,
						(INTERVAL ''3261'' DAY(4)) as days3261,
						(INTERVAL ''163'' HOUR(3)) as hours163,
						(INTERVAL ''-163'' MINUTE(3)) as minutes163,
						(INTERVAL ''223.25'' SECOND(3,2)) as seconds223,
						(INTERVAL ''163-11'' YEAR(3) TO MONTH) as y163m11,
						(INTERVAL ''163 12'' DAY(3) TO HOUR) as d163h12,
						(INTERVAL ''163 12:39'' DAY(3) TO MINUTE) as d163h12m39,
						(INTERVAL ''999 23:39:59.125'' DAY(3) TO SECOND(3)) as d999h12m39s59f18,
						(INTERVAL ''163:39'' HOUR(3) TO MINUTE) as d163m39,
						(INTERVAL ''163:39:59.875'' HOUR(3) TO SECOND(4)) as h163m39s39f78,
						(INTERVAL ''163:59.375'' MINUTE(3) TO SECOND(5)) as m163s59f38,
						(INTERVAL ''-16 23:39:56.109375'' DAY TO SECOND) as nd16h23m39s56f764
							from Orders where OrderID=10248;'.
	dbResources add: resultSet.
	self assert: resultSet size equals: 1.
	actual := resultSet first contents.
	self assert: actual size equals: 14.
	self assert: (actual at: 1) equals: (SQL_INTERVAL_STRUCT years: 1997).
	self assert: (actual at: 2) equals: (SQL_INTERVAL_STRUCT months: 993).
	self assert: (actual at: 3) equals: 3261 days.
	self assert: (actual at: 4) equals: 163 hours.
	self assert: (actual at: 5) equals: -163 minutes.
	self assert: (actual at: 6) equals: 223.25 seconds.
	self assert: (actual at: 7) equals: (SQL_INTERVAL_STRUCT years: 163 months: 11).
	self assert: (actual at: 8) equals: 163 days + 12 hours.
	self assert: (actual at: 9) equals: 163 days + 12 hours + 39 minutes.
	self assert: (actual at: 10) equals: 999 days + 23 hours + 39 minutes + 59.125 seconds.
	self assert: (actual at: 11) equals: 163 hours + 39 minutes.
	self assert: (actual at: 12) equals: 163 hours + 39 minutes + 59.875 seconds.
	self assert: (actual at: 13) equals: 163 minutes + 59.375 seconds.
	self assert: (actual at: 14) equals: -16 days - 23 hours - 39 minutes - 56.109375 seconds!

testMonthIntervals
	| resultSet values colAttrs insert |
	self dropTestTable.
	colAttrs := self createTestTable: 'INTERVAL MONTH(4)'.
	insert := connection prepare: 'INSERT INTO <1s> (ID, <2s>) VALUES (?, ?)'
						<< {self temporaryTableName. colAttrs second name}.
	dbResources add: insert.
	insert paramCols: colAttrs.
	values := {SQL_INTERVAL_STRUCT years: 1.
				SQL_INTERVAL_STRUCT years: 8.
				SQL_INTERVAL_STRUCT months: 99.
				SQL_INTERVAL_STRUCT years: 8 months: 3.
				SQL_INTERVAL_STRUCT years: 0.
				SQL_INTERVAL_STRUCT months: 0.
				SQL_INTERVAL_STRUCT years: 0 months: 0.
				SQL_INTERVAL_STRUCT years: -8.
				SQL_INTERVAL_STRUCT months: -99.
				SQL_INTERVAL_STRUCT years: -8 months: 3}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := connection
				query: 'select ID, <2s> from <1s>' << {self temporaryTableName. colAttrs second name}.
	dbResources add: resultSet.
	(resultSet collect: [:each | each atIndex: 2]) with: values
		do: [:actual :expected | expected isNil ifTrue: [self assertIsNil: actual] ifFalse: [self assert: actual equals: expected]].
	"Invalid"
	values := {10000000000 / 1000}.
	values keysAndValuesDo: 
			[:key :each |
			insert values: {key * 2. each}.
			self
				should: [insert exec]
				raise: HRESULTError
				matching: [:ex | ex hresult = (HRESULT fromInteger: Win32Errors.STATUS_OBJECT_TYPE_MISMATCH)]]!

testQueryAndUpdateBlob
	"Test that updating long binary field through a parameterized query (i.e. using SQLPutData) works."

	"Test result is that the value of the blob to 0 length byte array rather than NULL. As the test works fine on other DB's, this would appear to be a bug in the Mimer ODBC driver"
	self skip!

testYearToMonthIntervals
	| resultSet values colAttrs insert |
	self dropTestTable.
	colAttrs := self createTestTable: 'INTERVAL YEAR TO MONTH'.
	insert := connection prepare: 'INSERT INTO <1s> (ID, <2s>) VALUES (?, ?)'
						<< {self temporaryTableName. colAttrs second name}.
	dbResources add: insert.
	insert paramCols: colAttrs.
	values := {SQL_INTERVAL_STRUCT years: 99.
				SQL_INTERVAL_STRUCT months: 99.
				SQL_INTERVAL_STRUCT years: 58 months: 5.
				SQL_INTERVAL_STRUCT years: 0.
				SQL_INTERVAL_STRUCT months: 0.
				SQL_INTERVAL_STRUCT years: 0 months: 0.
				SQL_INTERVAL_STRUCT years: -99.
				SQL_INTERVAL_STRUCT months: -99.
				SQL_INTERVAL_STRUCT years: -58 months: 5}.
	values keysAndValuesDo: 
			[:i :each |
			insert values: {i. each}.
			insert exec].
	resultSet := connection
				query: 'select ID, <2s> from <1s>' << {self temporaryTableName. colAttrs second name}.
	dbResources add: resultSet.
	(resultSet collect: [:each | each atIndex: 2]) with: values
		do: [:actual :expected | expected isNil ifTrue: [self assertIsNil: actual] ifFalse: [self assert: actual equals: expected]].
	"Invalid"
	values := {10000000000 / 1000}.
	values keysAndValuesDo: 
			[:key :each |
			insert values: {key * 2. each}.
			self
				should: [insert exec]
				raise: HRESULTError
				matching: [:ex | ex hresult = (HRESULT fromInteger: Win32Errors.STATUS_OBJECT_TYPE_MISMATCH)]]! !

!MimerSqlDBTest categoriesForMethods!
categoriesColumns!constants!private! !
createTableStatementTemplate!constants!private! !
databaseName!constants!private! !
databaseResource!accessing!private! !
defaultTransactionIsolation!constants!private! !
orderDetailsTable!constants!private! !
ordersColumns!constants!private! !
testDateDiff!public!unit tests! !
testDateTimeDiff!public!unit tests! !
testDayToSecondsIntervals!public!unit tests! !
testIntervalLiterals!public!unit tests! !
testMonthIntervals!public!unit tests! !
testQueryAndUpdateBlob!public!unit tests! !
testYearToMonthIntervals!public!unit tests! !
!

!MimerSqlDBTest class methodsFor!

resources
	^{MimerSqlNorthwindDB}! !

!MimerSqlDBTest class categoriesForMethods!
resources!accessing!public! !
!

