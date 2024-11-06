"Filed out from Dolphin Smalltalk"!

DBConnectionTest subclass: #MySqlDBTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MySqlDBTest guid: (GUID fromString: '{76b4c290-77b5-4751-9315-875d5601a9f9}')!

MySqlDBTest comment: ''!

!MySqlDBTest methodsFor!

categoriesColumns
	"Description is defined as MEDIUMTEXT, i.e. up to 16Mb. Picture is defined as LONGBLOB (up to 4Gb).
	See the comments in ordersColumns for an explanation of why the buffer length for 15 unicode chars is reported as 60 bytes."

	^{{'CategoryID'. SQL_INTEGER. 10. 0. 4}.
		{'CategoryName'. SQL_WVARCHAR. 15. nil. 60}.
		{'Description'. SQL_WLONGVARCHAR. 16 * 1024 * 1024 - 1. nil. 16 * 1024 * 1024 - 1}.
		{'Picture'. SQL_LONGVARBINARY. 16r7FFFFFFF. nil. -1}}!

databaseName
	^'northwind'!

databaseResource
	^MySqlNorthwindDB current!

dataSourceName
	^self databaseResource connectionStringAttributes lookup: 'DSN'!

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

orderDetailsTable
	^'OrderDetails'!

ordersColumns
	"Note that for W[VAR]CHAR columns, the buffer size reports depends on the underlying representation, which is incorrect. We have the test DB set up for utf8mb4, causing MySql to report buffer sizes of x4 the character length. This should be the ODBC transfer size, and since the transfer is in UTF-16, it should be x2 the character length. This is a bug in the MySql Unicode ODBC driver. It also reports the wrong size octet transfer size for SqlColAttribute(.., SQL_DESC_OCTET_LENGTH, ..), although in that case the bug can be worse since when querying a SQL_VARCHAR column it will unecessarily map this to a SQL_WVARCHAR for transfer, yet report an octet transfer size appropriate for the byte characters."

	^{{'OrderID'. SQL_INTEGER. 10. 0. 4}.
		{'CustomerID'. SQL_VARCHAR.  5. nil. 5}.
		{'EmployeeID'. SQL_INTEGER. 10. 0. 4}.
		{'OrderDate'. SQL_TIMESTAMP. nil. nil. SQL_TIMESTAMP_STRUCT byteSize}.
		{'RequiredDate'. SQL_TIMESTAMP. nil. nil. SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShippedDate'. SQL_TIMESTAMP. nil. nil. SQL_TIMESTAMP_STRUCT byteSize}.
		{'ShipVia'. SQL_INTEGER. 10. 0. 4}.
		{'Freight'. SQL_DECIMAL. 10. 2. 12}.
		{'ShipName'. SQL_WVARCHAR. 40. nil. 160}.
		{'ShipAddress'. SQL_WVARCHAR. 60. nil. 240}.
		{'ShipCity'. SQL_WVARCHAR. 15. nil. 60}.
		{'ShipRegion'. SQL_WVARCHAR. 15. nil. 60}.
		{'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 40}.
		{'ShipCountry'. SQL_WVARCHAR. 15. nil. 60}}!

supportsReadOnlyMode
	^false!

testCharacterSetConfiguration
	"Verify that MySql and the test db are configured correctly."

	| resultSet vars |
	resultSet := connection
				query: 'SHOW VARIABLES WHERE Variable_name LIKE "character\_set\_%" OR Variable_name LIKE "collation%";'.
	vars := LookupTable new.
	resultSet do: [:row | vars at: (row at: 'Variable_name') put: (row at: 'Value')].
	#('character_set_client' 'character_set_connection' 'character_set_database')
		do: [:each | self assert: (vars at: each) equals: 'utf8mb4']! !

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
orderDetailsTable!constants!private! !
ordersColumns!constants!private! !
supportsReadOnlyMode!private!testing! !
testCharacterSetConfiguration!public!unit tests! !
!

!MySqlDBTest class methodsFor!

resources
	^{MySqlNorthwindDB}! !

!MySqlDBTest class categoriesForMethods!
resources!accessing!public! !
!

