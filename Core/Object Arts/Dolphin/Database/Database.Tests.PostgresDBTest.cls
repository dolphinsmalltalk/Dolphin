"Filed out from Dolphin Smalltalk"!

Database.Tests.DBConnectionTest
	subclass: #'Database.Tests.PostgresDBTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Database.Tests.PostgresDBTest guid: (Core.GUID fromString: '{493047ac-7af4-4660-b729-c5280bfaf422}')!

Database.Tests.PostgresDBTest comment: ''!

!Database.Tests.PostgresDBTest methodsFor!

ageAtHireQuery
	^'SELECT "EmployeeID", "BirthDate", "HireDate", CAST(AGE("HireDate", "BirthDate") as INTERVAL YEAR TO MONTH) as "AgeAtHire" from "Employees"'!

allDataTypes
	| allTypes |
	allTypes := {
				'bool' -> SQL_BIT.
				'bytea' -> SQL_LONGVARBINARY.
				'bytea' -> SQL_LONGVARBINARY.
				'char' -> SQL_WCHAR.
				'char' -> SQL_WCHAR.
				'date' -> SQL_DATETIME.
				'date' -> SQL_DATETIME.
				'float4' -> SQL_REAL.
				'float8' -> SQL_FLOAT.
				'float8' -> SQL_FLOAT.
				'int2' -> SQL_SMALLINT.
				'int2' -> SQL_SMALLINT.
				'int4' -> SQL_INTEGER.
				'int8' -> SQL_BIGINT.
				'numeric' -> SQL_NUMERIC.
				'numeric' -> SQL_NUMERIC.
				'text' -> SQL_WLONGVARCHAR.
				'text' -> SQL_WLONGVARCHAR.
				'time' -> SQL_DATETIME.
				'time' -> SQL_DATETIME.
				'timestamptz' -> SQL_DATETIME.
				'timestamptz' -> SQL_DATETIME.
				'uuid' -> SQL_GUID.
				'varchar' -> SQL_WVARCHAR.
				'varchar' -> SQL_WVARCHAR
			}.
	self supportsIntervalStructs
		ifTrue: 
			["Note that this doesn't work correctly - there are indeed 13 interval types but all are mapped to one type name, and are using the wrong SQL_xxx type (SQL_INTERVAL is actually an alias for SQL_TIME)"
			allTypes := allTypes , (Array new: 13 withAll: 'interval year to month' -> SQL_INTERVAL)
						asSortedArray: [:a :b | a key = b key ifTrue: [a value <= b value] ifFalse: [a < b]]].
	^allTypes!

categoriesColumns
	"Note inappropriate use of SQL_NO_TOTAL to describe a blob column of indeterminate length. SQL_NO_TOTAL is intended to be returned in the length/indicator buffer from a SQLGetData call, not for column metadata. In this case the correct value for length/precision metadata would be 0, -1 or the max value. SQL_NO_TOTAL has the value -4."

	^{
		{ 'CategoryID'. SQL_INTEGER. 10. 0. 4 }.
		{ 'CategoryName'. SQL_WVARCHAR. 15. nil. 30 }.
		{ 'Description'. SQL_WLONGVARCHAR. 8190. nil. 8190 }.
		{ 'Picture'. SQL_LONGVARBINARY. SQL_NO_TOTAL. nil. SQL_NO_TOTAL }
	}!

columnTypeNameBlob
	^'bytea'!

columnTypeNameDateTime
	^'timestamp'!

columnTypeNameDateTimeWithOffset
	^'timestamptz'!

columnTypeNameVarBinary
	^'bytea'!

columnTypeNameWideVarChar
	^'VARCHAR'!

databaseResource
	^PostgresNorthwindDB current!

dbName: aString
	"We have to quote all identifiers in Postgresql to avoid them being forced to lowercase."

	^'"' , aString , '"'!

defaultCursorCommitBehavior
	^SQL_CB_PRESERVE!

defaultCursorRollbackBehaviour
	^SQL_CB_PRESERVE!

defaultDateTimeColumnScale
	^6!

defaultDatetimeWithOffsetScale
	^6!

execShouldRaiseGenericAndUnhelpfulError: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: 
			[:ex |
			"Rather odd/unhelpful error messages '23505: while executing the query'"
			ex sqlState = '23505']!

execShouldRaiseSqlDateOverflow: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22008']!

execShouldRaiseSqlInvalidDateFormat: aDBParameterizedStatement
	self
		should: [aDBParameterizedStatement exec]
		raise: DBError
		matching: [:ex | ex sqlState = '22008']!

execShouldRaiseSqlInvalidDouble: aDBParameterizedStatement
	self execShouldRaiseGenericAndUnhelpfulError: aDBParameterizedStatement!

hasFixedWidthBinaryDataType
	"Most DB's support SQL_BINARY (cf. SQL_VARBINARY), but Postgres does not."

	^false!

hasVarBinaryWithLimitDataType
	"varbinary(N) for integer N, as opposed to some unbounded blob type"

	^false!

intervalLiteralsQuery
	^'SELECT CAST(''1997'' AS INTERVAL YEAR) AS years1997,
			CAST(''993'' AS INTERVAL MONTH) AS months993,
			CAST(''3261'' AS INTERVAL DAY) AS days3261,
			CAST(''163'' AS INTERVAL HOUR) AS hours163,
			CAST(''-163'' AS INTERVAL MINUTE) AS minutes163,
			CAST(''23.25'' AS INTERVAL SECOND(2)) AS seconds223,
			CAST(''163-11'' AS INTERVAL YEAR TO MONTH) AS y163m11,
			CAST(''163 12'' AS INTERVAL DAY TO HOUR) AS d163h12,
			CAST(''163 12:39'' AS INTERVAL DAY TO MINUTE) AS d163h12m39,
			CAST(''999 23:39:59.125'' AS INTERVAL DAY TO SECOND(3)) AS d999h12m39s59f18,
			CAST(''163:39'' AS INTERVAL HOUR TO MINUTE) AS d163m39,
			CAST(''163:39:59.875'' AS INTERVAL HOUR TO SECOND(4)) AS h163m39s39f78,
			CAST(''39:59.375'' AS INTERVAL MINUTE TO SECOND(5)) AS m163s59f38,
			CAST(''-16 23:39:56.109375'' AS INTERVAL DAY TO SECOND) AS nd16h23m39s56f764
							from "Orders" where "OrderID"=10248;'!

invalidDates
	^{ Date newDay: 365 year: -10000 }!

ordersColumns
	"Almost the same as the SQL Server metadata."

	| columns |
	columns := super ordersColumns.
	(columns at: 8) at: 2 put: SQL_NUMERIC.
	^columns!

ordersRowVersionColumns
	^#('xmin')!

orderTableRowIds
	^#()!

scaleOfTimeColumns
	^6!

sqlDataTypeVarChar
	^SQL_WVARCHAR!

supportsIntervalStructs
	"Private - Although PostgreSQL does support interval types, its ODBC driver transfers them as text. Also it reports the wrong column octet length for that text from a columns metadata query (it returns the number of code units, not bytes), although it does provide the correct transfer length for a column descriptor from a query.  It is possible to force the driver to accept SQL_INTERAL_STRUCTs as input for insertions/updates by providing an appropriately configured column description. It is only possible to get text out. We want to transfer as binary data, particularly as the string representation doesn't support passing in negative durations, and the queried results are not in an ISO8601 format and are quite complicated to parse. The driver code has for a long time contained some nascent support for intervals, but it is hiding behind a define, so not compiled into the build. If the DLL is rebuilt with this code included (not especially easy if you make the mistake of trying to follow the windows build instructions - loading the vcxproj into VS2022 and upgrading the toolset does work, however). With some further judicious patching for bugs in the logic of the interval2istruct function in the driver, it is possible to make this test pass, but using the driver as shipped it is not."

	^false!

supportsReadOnlyMode
	^false!

timeToShipQuery
	^'SELECT "OrderID", "RequiredDate", "ShippedDate", CAST("ShippedDate" - "RequiredDate" as INTERVAL DAY)  as "TimeToShip" from "Orders"'!

verifyInvalidDates: aDBParameterizedStatement
	self invalidDates keysAndValuesDo: 
			[:i :each |
			aDBParameterizedStatement values: { 100 + i. each }.
			self execShouldRaiseSqlDateOverflow: aDBParameterizedStatement]!

verifyInvalidFloatValues: aDBParameterizedStatement
	"Postgres can store non-finite floats"
	self verifyCanStoreNonFiniteFloats: aDBParameterizedStatement! !

!Database.Tests.PostgresDBTest categoriesForMethods!
ageAtHireQuery!constants!private! !
allDataTypes!constants!private! !
categoriesColumns!constants!private! !
columnTypeNameBlob!constants!private! !
columnTypeNameDateTime!constants!private! !
columnTypeNameDateTimeWithOffset!constants!private! !
columnTypeNameVarBinary!constants!private! !
columnTypeNameWideVarChar!constants!private! !
databaseResource!accessing!private! !
dbName:!helpers!private! !
defaultCursorCommitBehavior!constants!private! !
defaultCursorRollbackBehaviour!constants!private! !
defaultDateTimeColumnScale!constants!private! !
defaultDatetimeWithOffsetScale!constants!private! !
execShouldRaiseGenericAndUnhelpfulError:!private! !
execShouldRaiseSqlDateOverflow:!helpers!private! !
execShouldRaiseSqlInvalidDateFormat:!helpers!private! !
execShouldRaiseSqlInvalidDouble:!private! !
hasFixedWidthBinaryDataType!private!testing! !
hasVarBinaryWithLimitDataType!private!testing! !
intervalLiteralsQuery!constants!private! !
invalidDates!private! !
ordersColumns!constants!private! !
ordersRowVersionColumns!constants!private! !
orderTableRowIds!constants!private! !
scaleOfTimeColumns!constants!private! !
sqlDataTypeVarChar!constants!private! !
supportsIntervalStructs!private!testing! !
supportsReadOnlyMode!private!testing! !
timeToShipQuery!constants!private! !
verifyInvalidDates:!helpers!private! !
verifyInvalidFloatValues:!helpers!private! !
!

!Database.Tests.PostgresDBTest class methodsFor!

allUnsupportedTests
	"Answer a collection of the selectors of all tests that exercise functionality that is not supported by the tested DBMS.

		- Postgres does not have fixed-width binary columns, or indeed variable width binary columns where a precision is specified. It's bytea type is most similar to BLOB.
	"

	^#(#testColumnTypeBinary testColumnTypeVarBinaryBound testColumnTypeVarBinaryUnbound )!

resources
	^{ PostgresNorthwindDB }! !

!Database.Tests.PostgresDBTest class categoriesForMethods!
allUnsupportedTests!Accessing!public! !
resources!accessing!public! !
!

