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

allDataTypes
	^{
		'BIGINT' -> SQL_BIGINT.
		'BINARY' -> SQL_BINARY.
		'BINARY LARGE OBJECT' -> SQL_LONGVARBINARY.
		'BINARY VARYING' -> SQL_VARBINARY.
		'BOOLEAN' -> SQL_BIT.
		'BUILTIN.GIS_COORDINATE' -> SQL_BINARY.
		'BUILTIN.GIS_LATITUDE' -> SQL_BINARY.
		'BUILTIN.GIS_LOCATION' -> SQL_BINARY.
		'BUILTIN.GIS_LONGITUDE' -> SQL_BINARY.
		'BUILTIN.UUID' -> SQL_GUID.
		'CHARACTER' -> SQL_CHAR.
		'CHARACTER LARGE OBJECT' -> SQL_LONGVARCHAR.
		'CHARACTER VARYING' -> SQL_VARCHAR.
		'DATE' -> SQL_DATETIME.
		'DECIMAL' -> SQL_DECIMAL.
		'DOUBLE PRECISION' -> SQL_DOUBLE.
		'Float' -> SQL_FLOAT.
		'FLOAT' -> SQL_FLOAT.
		'INFORMATION_SCHEMA.CARDINAL_NUMBER' -> SQL_INTEGER.
		'INFORMATION_SCHEMA.CHARACTER_DATA' -> SQL_VARCHAR.
		'INFORMATION_SCHEMA.SQL_IDENTIFIER' -> SQL_WVARCHAR.
		'INFORMATION_SCHEMA.TIME_STAMP' -> SQL_DATETIME.
		'Integer' -> SQL_BIGINT.
		'INTEGER' -> SQL_INTEGER.
		'INTERVAL DAY' -> SQL_INTERVAL.
		'INTERVAL DAY() TO HOUR' -> SQL_INTERVAL.
		'INTERVAL DAY() TO MINUTE' -> SQL_INTERVAL.
		'INTERVAL DAY() TO SECOND' -> SQL_INTERVAL.
		'INTERVAL HOUR' -> SQL_INTERVAL.
		'INTERVAL HOUR() TO MINUTE' -> SQL_INTERVAL.
		'INTERVAL HOUR() TO SECOND' -> SQL_INTERVAL.
		'INTERVAL MINUTE' -> SQL_INTERVAL.
		'INTERVAL MINUTE() TO SECOND' -> SQL_INTERVAL.
		'INTERVAL MONTH' -> SQL_INTERVAL.
		'INTERVAL SECOND' -> SQL_INTERVAL.
		'INTERVAL YEAR' -> SQL_INTERVAL.
		'INTERVAL YEAR() TO MONTH' -> SQL_INTERVAL.
		'NATIONAL CHAR LARGE OBJECT' -> SQL_WLONGVARCHAR.
		'NATIONAL CHARACTER' -> SQL_WCHAR.
		'NATIONAL CHARACTER VARYING' -> SQL_WVARCHAR.
		'NUMERIC' -> SQL_NUMERIC.
		'ODBC.BIT' -> SQL_BIT.
		'ODBC.GUID' -> SQL_GUID.
		'ODBC.TINYINT' -> SQL_TINYINT.
		'REAL' -> SQL_REAL.
		'SMALLINT' -> SQL_SMALLINT.
		'SYSADM.TEXT' -> SQL_WLONGVARCHAR.
		'TIME' -> SQL_DATETIME.
		'TIMESTAMP' -> SQL_DATETIME
	}!

categoriesColumns
	^{
		{ 'CategoryID'. SQL_INTEGER. 10. 0. 4 }.
		{ 'CategoryName'. SQL_WVARCHAR. 15. nil. 60 }.
		{ 'Description'. SQL_WLONGVARCHAR. 1048576. nil. 4194304 }.
		{ 'Picture'. SQL_LONGVARBINARY. 4194304. nil. 4194304 }
	}!

columnTypeNameBlob
	^'BINARY LARGE OBJECT'!

columnTypeNameDateTime
	^'TIMESTAMP'!

createTableStatementTemplate
	^'CREATE TABLE <1s> (  <2s> INT PRIMARY KEY, <3s> <4s><5d> <6?:NOT >NULL ) IN Northwind'!

databaseName
	^'MIMER'!

databaseResource
	^MimerSqlNorthwindDB current!

dataSourceName
	^self databaseName!

defaultDateTimeColumnScale
	^6!

defaultTransactionIsolation
	^#repeatableRead!

hasDateTimeOffsetDataType
	^false!

ordersColumns
	"Mimer has a similar bug to MySql in the reporting of the length of WCHAR columns. It's WCHAR's are UTF-32, and its ODBC driver reports WCHAR column buffer sizes as 4x character length. This isn't correct since the ODBC transfer format can only be UTF-16, and therefore the octet transfer length is 2x, not 4x."

	^{
		{ 'OrderID'. SQL_INTEGER. 10. 0. 4 }.
		{ 'CustomerID'. SQL_CHAR. 5. nil. 5 }.
		{ 'EmployeeID'. SQL_INTEGER. 10. 0. 4 }.
		{ 'OrderDate'. SQL_TYPE_TIMESTAMP. 26. 6. SQL_TIMESTAMP_STRUCT byteSize }.
		{ 'RequiredDate'. SQL_TYPE_TIMESTAMP. 26. 6. SQL_TIMESTAMP_STRUCT byteSize }.
		{ 'ShippedDate'. SQL_TYPE_TIMESTAMP. 26. 6. SQL_TIMESTAMP_STRUCT byteSize }.
		{ 'ShipVia'. SQL_INTEGER. 10. 0. 4 }.
		{ 'Freight'. SQL_DECIMAL. 10. 2. 12 }.
		{ 'ShipName'. SQL_WVARCHAR. 40. nil. 160 }.
		{ 'ShipAddress'. SQL_WVARCHAR. 60. nil. 240 }.
		{ 'ShipCity'. SQL_WVARCHAR. 15. nil. 60 }.
		{ 'ShipRegion'. SQL_WVARCHAR. 15. nil. 60 }.
		{ 'ShipPostalCode'. SQL_WVARCHAR. 10. nil. 40 }.
		{ 'ShipCountry'. SQL_WVARCHAR. 15. nil. 60 }
	}!

sqlStateInvalidDouble
	"22018 is 'Invalid character value for cast specification', but the mimer driver raises this for 'Invalid numeric value'"

	^'22018'!

supportsIntervalStructs
	"Private - Mimer is the only DB tested so far that has intervals and implements them completely and correctly in its ODBC driver."

	^true!

testColumnTypeVarCharBoundOverflow
	| colAttrs vcharCol insert |
	self assert: DBVarFieldBuffer maxBoundOctetLength > 16.
	colAttrs := self createTestTable: 'varchar' qualifiers: #(16).
	vcharCol := colAttrs last.
	insert := self
				prepare: 'INSERT INTO <1s> (ID,<2s>) VALUES (?,?)' << { self temporaryTableName. vcharCol name }.
	insert paramCols: colAttrs.
	insert values: { 100. 'abcdefghijklmnopq' }.
	"If the parameter is bound, we pass the data through the bound buffer and detect overflow when attempting to populate the buffer."
	self
		should: [insert exec]
		raise: BoundsError
		matching: 
			[:ex |
			(ex isKindOf: BoundsError) or: 
					[Transcript
						print: self;
						nextPutAll: ' nativeError on truncation';
						print: ex nativeError;
						cr.
					ex sqlState = self sqlStateTruncatedString	"String data, right truncation"]]!

verifyInvalidFloatValues: aDBParameterizedStatement
	| fpeMask |
	"The driver will throw a floating point exceptions since we have unmasked some which it doesn't handle well as the driver is then left in an unrecoverable state."
	fpeMask := Float exceptionMask: CRTConstants._MCW_EM.
	[super verifyInvalidFloatValues: aDBParameterizedStatement]
			ensure: [Float exceptionMask: fpeMask]! !

!MimerSqlDBTest categoriesForMethods!
allDataTypes!constants!private! !
categoriesColumns!constants!private! !
columnTypeNameBlob!constants!private! !
columnTypeNameDateTime!constants!private! !
createTableStatementTemplate!constants!private! !
databaseName!constants!private! !
databaseResource!accessing!private! !
dataSourceName!public! !
defaultDateTimeColumnScale!constants!private! !
defaultTransactionIsolation!constants!private! !
hasDateTimeOffsetDataType!private!testing! !
ordersColumns!constants!private! !
sqlStateInvalidDouble!constants!private! !
supportsIntervalStructs!private!testing! !
testColumnTypeVarCharBoundOverflow!public!unit tests! !
verifyInvalidFloatValues:!helpers!private! !
!

!MimerSqlDBTest class methodsFor!

resources
	^{MimerSqlNorthwindDB}! !

!MimerSqlDBTest class categoriesForMethods!
resources!accessing!public! !
!

