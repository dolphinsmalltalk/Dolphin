"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTest subclass: #OracleDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OracleDBTest guid: (GUID fromString: '{9afce793-d0c9-4b6e-ab84-654850391cae}')!

OracleDBTest comment: ''!

!OracleDBTest categoriesForClass!Unclassified! !

!OracleDBTest methodsFor!

databaseName
	^''!

databaseResource
	^OracleNorthwindDB current!

defaultCursorCommitBehavior
	^SQL_CB_PRESERVE!

defaultCursorRollbackBehaviour
	^SQL_CB_PRESERVE!

field: aString fromRow: aDBRow
	^aDBRow at: aString asUppercase!

isNumericOutOfRangeError: aDBError
	^(aDBError description indexOfSubCollection: 'greater than specified precision') ~~ 0!

orderDetailsTable
	^'OrderDetails'!

ordersColumns
	^{{'ORDERID'. SQL_DECIMAL. 10. 0. 13}.
		{'CUSTOMERID'. SQL_CHAR. 5. nil. 5}.
		{'EMPLOYEEID'. SQL_DECIMAL. 10. 0. 13}.
		{'ORDERDATE'. SQL_TYPE_TIMESTAMP. 19. 6. SQL_TIMESTAMP_STRUCT byteSize}.
		{'REQUIREDDATE'. SQL_TYPE_TIMESTAMP. 19. nil. SQL_TIMESTAMP_STRUCT byteSize}.
		{'SHIPPEDDATE'. SQL_TYPE_TIMESTAMP. 19. 6. SQL_TIMESTAMP_STRUCT byteSize}.
		{'SHIPVIA'. SQL_DECIMAL. 10. 0. 13}.
		{'FREIGHT'. SQL_DECIMAL. 10. 2. 13}.
		{'SHIPNAME'. SQL_WVARCHAR. 40. nil. 80}.
		{'SHIPADDRESS'. SQL_WVARCHAR. 60. nil. 120}.
		{'SHIPCITY'. SQL_WVARCHAR. 15. nil. 30}.
		{'SHIPREGION'. SQL_WVARCHAR. 15. nil. 30}.
		{'SHIPPOSTALCODE'. SQL_WVARCHAR. 10. nil. 20}.
		{'SHIPCOUNTRY'. SQL_WVARCHAR. 15. nil. 30}}!

orderTableRowIds
	^#('ROWID')!

testYearToMonthIntervals
	| resultSet values colAttr insert |
self skip.	"Oracle's ODBC driver still doesn't support INTERVALs..."
	self dropTestTable.
	colAttr := self createTestTable: 'INTERVAL YEAR TO MONTH'.
	insert := connection prepare: 'INSERT <1s> (<2s>) VALUES (?)' << {self temporaryTableName. colAttr name}.
	insert paramCols: {colAttr}.
	values := {SQL_INTERVAL_STRUCT years: 99.
				SQL_INTERVAL_STRUCT months: 99.
				SQL_INTERVAL_STRUCT years: 58 months: 5}.
	values do: 
			[:each |
			insert values: {each}.
			insert exec].
	resultSet := connection query: 'select <1s> from TestTable' << colAttr name.
	(resultSet collect: [:each | each atIndex: 1]) with: values
		do: 
			[:actual :expected |
			expected isNil
				ifTrue: [self assertIsNil: actual]
				ifFalse: 
					[self
						assert: actual
						closeTo: expected
						precision: 1 months]].
	resultSet free.
	"Invalid"
	values := {10000000000 / 1000}.
	values do: 
			[:each |
			insert values: {each}.
			self
				should: [insert exec]
				raise: DBError
				matching: [:ex | ex sqlState = '22003']].
! !

!OracleDBTest categoriesForMethods!
databaseName!constants!private! !
databaseResource!accessing!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
field:fromRow:!helpers!private! !
isNumericOutOfRangeError:!helpers!private! !
orderDetailsTable!constants!private! !
ordersColumns!constants!private! !
orderTableRowIds!constants!private! !
testYearToMonthIntervals!public!unit tests! !
!

!OracleDBTest class methodsFor!

resources
	^{OracleNorthwindDB}! !

!OracleDBTest class categoriesForMethods!
resources!accessing!public! !
!

