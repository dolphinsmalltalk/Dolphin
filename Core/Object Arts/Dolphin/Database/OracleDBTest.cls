"Filed out from Dolphin Smalltalk"!

DBConnectionTest subclass: #OracleDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OracleDBTest guid: (GUID fromString: '{9afce793-d0c9-4b6e-ab84-654850391cae}')!

OracleDBTest comment: ''!

!OracleDBTest categoriesForClass!Unclassified! !

!OracleDBTest methodsFor!

categoriesColumns
	^{{'CATEGORYID'. SQL_DECIMAL. 10. 0. 12}.
		{'CATEGORYNAME'. SQL_WVARCHAR. 15. nil. 30}.
		{'DESCRIPTION'. SQL_WLONGVARCHAR. 16r7FFFFFFF. nil. 16r7FFFFFFF}.
		{'PICTURE'. SQL_LONGVARBINARY. 16r7FFFFFFF. nil. 16r7FFFFFFF}}!

databaseName
	^''!

databaseResource
	^OracleNorthwindDB current!

dataSourceName
	^self databaseResource connectionStringAttributes at: 'DSN'!

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
	"Note the weirdness that the ORDERDATE and SHIPPEDDATE columns configured in the DB as of type TIMESTAMP, and REQUIREDDATE defined as a DATE, all get reported as SQL_TIMESTAMP_STRUCT, but the buffer size for the first two is 11, but we get the expected 16 bytes for the DATE column. In all cases a SQL_TIMESTAMP_STRUCT is transferred, so the buffer size for the order and ship dates is reported incorrectly by the driver."

	^{
		{ 'ORDERID'. SQL_DECIMAL. 10. 0. 12 }.
		{ 'CUSTOMERID'. SQL_CHAR. 5. nil. 5 }.
		{ 'EMPLOYEEID'. SQL_DECIMAL. 10. 0. 12 }.
		{ 'ORDERDATE'. SQL_TYPE_TIMESTAMP. 19. 6. 11 }.
		{ 'REQUIREDDATE'. SQL_TYPE_TIMESTAMP. 19. nil. SQL_TIMESTAMP_STRUCT byteSize }.
		{ 'SHIPPEDDATE'. SQL_TYPE_TIMESTAMP. 19. 6. 11 }.
		{ 'SHIPVIA'. SQL_DECIMAL. 10. 0. 12 }.
		{ 'FREIGHT'. SQL_DECIMAL. 10. 2. 12 }.
		{ 'SHIPNAME'. SQL_WVARCHAR. 40. nil. 80 }.
		{ 'SHIPADDRESS'. SQL_WVARCHAR. 60. nil. 120 }.
		{ 'SHIPCITY'. SQL_WVARCHAR. 15. nil. 30 }.
		{ 'SHIPREGION'. SQL_WVARCHAR. 15. nil. 30 }.
		{ 'SHIPPOSTALCODE'. SQL_WVARCHAR. 10. nil. 20 }.
		{ 'SHIPCOUNTRY'. SQL_WVARCHAR. 15. nil. 30 }
	}!

orderTableRowIds
	^#('ROWID')! !

!OracleDBTest categoriesForMethods!
categoriesColumns!constants!private! !
databaseName!constants!private! !
databaseResource!accessing!private! !
dataSourceName!constants!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
field:fromRow:!helpers!private! !
isNumericOutOfRangeError:!helpers!private! !
orderDetailsTable!constants!private! !
ordersColumns!constants!private! !
orderTableRowIds!constants!private! !
!

!OracleDBTest class methodsFor!

resources
	^{OracleNorthwindDB}! !

!OracleDBTest class categoriesForMethods!
resources!accessing!public! !
!

