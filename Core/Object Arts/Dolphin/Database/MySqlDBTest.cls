"Filed out from Dolphin Smalltalk"!

DBConnectionTest subclass: #MySqlDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySqlDBTest guid: (GUID fromString: '{76b4c290-77b5-4751-9315-875d5601a9f9}')!

MySqlDBTest comment: ''!

!MySqlDBTest categoriesForClass!Unclassified! !

!MySqlDBTest methodsFor!

categoriesColumns
	"Description is defined as MEDIUMTEXT, i.e. up to 16Mb. Picture is defined as LONGBLOB (up to 4Gb)"

	^{{'CategoryID'. SQL_INTEGER. 10. 0. 4}.
		{'CategoryName'. SQL_WVARCHAR. 15. nil. 45}.
		{'Description'. SQL_WLONGVARCHAR. 16 * 1024 * 1024 - 1. nil. 16 * 1024 * 1024 - 1}.
		{'Picture'. SQL_LONGVARBINARY. -1. nil. -1}}!

databaseName
	^'northwind'!

databaseResource
	^MySqlNorthwindDB current!

dataSourceName
	^'MySqlTest'!

defaultCursorCommitBehavior
	^SQL_CB_PRESERVE!

defaultCursorRollbackBehaviour
	^SQL_CB_PRESERVE!

defaultTransactionIsolation
	^#repeatableRead!

isNumericOutOfRangeError: aDBError
	^($] split: aDBError description) last beginsWith: 'Out of range value for column'!

matchInvalidDateTime: aDBError
	^($] split: aDBError description) last beginsWith: 'Incorrect datetime value:'!

nameUpdateTestPairs
	"Private - MySql doesn't seem to support code points outside the BMP."

	^{#('0123456789' 'Ā文'). #('012345678' 'a'). #('ᚠᛇᚻ' 'Davolios'). {'Nancy'. 'Davolio'}}!

orderDetailsTable
	^'OrderDetails'!

ordersColumns
	^{{'OrderID'. SQL_INTEGER. 10. 0. 4}.
		{'CustomerID'. SQL_WCHAR.  5. nil. 15}.
		{'EmployeeID'. SQL_INTEGER. 10. 0. 4}.
		{'OrderDate'. SQL_TIMESTAMP. nil. nil. SQL_TIMESTAMP_STRUCT byteSize}.
		{'RequiredDate'. SQL_TIMESTAMP. nil. nil. SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShippedDate'. SQL_TIMESTAMP. nil. nil. SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShipVia'. SQL_INTEGER. 10. 0. 4}.
		{'Freight'. SQL_DECIMAL. 10. 2. 13}.
		{'ShipName'. SQL_WVARCHAR. 40. nil. 120}.
		{'ShipAddress'. SQL_WVARCHAR. 60. nil. 180}.
		{'ShipCity'. SQL_WVARCHAR. 15. nil. 45}.
		{'ShipRegion'. SQL_WVARCHAR. 15. nil. 45}.
		{'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 30}.
		{'ShipCountry'. SQL_WVARCHAR. 15. nil. 45}}	"Why 15? Should be 10, but MySql driver says 15"!

supportsReadOnlyMode
	^false! !

!MySqlDBTest categoriesForMethods!
categoriesColumns!constants!private! !
databaseName!constants!private! !
databaseResource!accessing!private! !
dataSourceName!constants!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
defaultTransactionIsolation!constants!private! !
isNumericOutOfRangeError:!helpers!private! !
matchInvalidDateTime:!helpers!private! !
nameUpdateTestPairs!constants!private! !
orderDetailsTable!constants!private! !
ordersColumns!constants!private! !
supportsReadOnlyMode!private!testing! !
!

!MySqlDBTest class methodsFor!

resources
	^{MySqlNorthwindDB}! !

!MySqlDBTest class categoriesForMethods!
resources!accessing!public! !
!

