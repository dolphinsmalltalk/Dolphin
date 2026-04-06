"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Database.DBColAttr'
	instanceVariableNames: 'columnNumber name length sqlType precision scale special bufferClass'
	classVariableNames: ''
	imports: #(#{OS.ODBCLibrary private})
	classInstanceVariableNames: ''
	classConstants: {
			'DeleteCascade' -> 16r10.
			'DeleteRestrict' -> 16r20.
			'DeleteRules' -> 16r70.
			'DeleteSetNull' -> 16r40.
			'ForeignKey' -> 16r2.
			'ParameterTypeMask' -> 16r3800.
			'ParameterTypeShift' -> 16rB.
			'PrimaryKey' -> 16r1.
			'SQL_BIGINT' -> -16r5.
			'SQL_BINARY' -> -16r2.
			'SQL_BIT' -> -16r7.
			'SQL_CHAR' -> 16r1.
			'SQL_DATETIME' -> 16r9.
			'SQL_DECIMAL' -> 16r3.
			'SQL_DOUBLE' -> 16r8.
			'SQL_FLOAT' -> 16r6.
			'SQL_GUID' -> -16rB.
			'SQL_INTEGER' -> 16r4.
			'SQL_INTERVAL' -> 16rA.
			'SQL_INTERVAL_DAY' -> 16r67.
			'SQL_INTERVAL_DAY_TO_HOUR' -> 16r6C.
			'SQL_INTERVAL_DAY_TO_MINUTE' -> 16r6D.
			'SQL_INTERVAL_DAY_TO_SECOND' -> 16r6E.
			'SQL_INTERVAL_HOUR' -> 16r68.
			'SQL_INTERVAL_HOUR_TO_MINUTE' -> 16r6F.
			'SQL_INTERVAL_HOUR_TO_SECOND' -> 16r70.
			'SQL_INTERVAL_MINUTE' -> 16r69.
			'SQL_INTERVAL_MINUTE_TO_SECOND' -> 16r71.
			'SQL_INTERVAL_MONTH' -> 16r66.
			'SQL_INTERVAL_SECOND' -> 16r6A.
			'SQL_INTERVAL_YEAR' -> 16r65.
			'SQL_INTERVAL_YEAR_TO_MONTH' -> 16r6B.
			'SQL_LONGVARBINARY' -> -16r4.
			'SQL_LONGVARCHAR' -> -16r1.
			'SQL_NUMERIC' -> 16r2.
			'SQL_REAL' -> 16r7.
			'SQL_SMALLINT' -> 16r5.
			'SQL_SS_TIME2' -> -16r9A.
			'SQL_SS_TIMESTAMPOFFSET' -> -16r9B.
			'SQL_SS_VARIANT' -> -16r96.
			'SQL_SS_XML' -> -16r98.
			'SQL_TIMESTAMP' -> 16rB.
			'SQL_TINYINT' -> -16r6.
			'SQL_TYPE_DATE' -> 16r5B.
			'SQL_TYPE_NULL' -> 16r0.
			'SQL_TYPE_TIME' -> 16r5C.
			'SQL_TYPE_TIMESTAMP' -> 16r5D.
			'SQL_UNKNOWN_TYPE' -> 16r0.
			'SQL_VARBINARY' -> -16r3.
			'SQL_VARCHAR' -> 16rC.
			'SQL_WCHAR' -> -16r8.
			'SQL_WLONGVARCHAR' -> -16rA.
			'SQL_WVARCHAR' -> -16r9.
			'Types'
				-> (IdentityDictionary withAll: {
								-16r9B -> 'SQL_SS_TIMESTAMPOFFSET'.
								-16r9A -> 'SQL_SS_TIME2'.
								-16r98 -> 'SQL_SS_XML'.
								-16r96 -> 'SQL_SS_VARIANT'.
								-16rB -> 'SQL_GUID'.
								-16rA -> 'SQL_WLONGVARCHAR'.
								-16r9 -> 'SQL_WVARCHAR'.
								-16r8 -> 'SQL_WCHAR'.
								-16r7 -> 'SQL_BIT'.
								-16r6 -> 'SQL_TINYINT'.
								-16r5 -> 'SQL_BIGINT'.
								-16r4 -> 'SQL_LONGVARBINARY'.
								-16r3 -> 'SQL_VARBINARY'.
								-16r2 -> 'SQL_BINARY'.
								-16r1 -> 'SQL_LONGVARCHAR'.
								16r0 -> 'SQL_TYPE_NULL'.
								16r1 -> 'SQL_CHAR'.
								16r2 -> 'SQL_NUMERIC'.
								16r3 -> 'SQL_DECIMAL'.
								16r4 -> 'SQL_INTEGER'.
								16r5 -> 'SQL_SMALLINT'.
								16r6 -> 'SQL_FLOAT'.
								16r7 -> 'SQL_REAL'.
								16r8 -> 'SQL_DOUBLE'.
								16r9 -> 'SQL_DATETIME'.
								16rA -> 'SQL_INTERVAL'.
								16rB -> 'SQL_TIMESTAMP'.
								16rC -> 'SQL_VARCHAR'.
								16r5B -> 'SQL_TYPE_DATE'.
								16r5C -> 'SQL_TYPE_TIME'.
								16r5D -> 'SQL_TYPE_TIMESTAMP'.
								16r65 -> 'SQL_INTERVAL_YEAR'.
								16r66 -> 'SQL_INTERVAL_MONTH'.
								16r67 -> 'SQL_INTERVAL_DAY'.
								16r68 -> 'SQL_INTERVAL_HOUR'.
								16r69 -> 'SQL_INTERVAL_MINUTE'.
								16r6A -> 'SQL_INTERVAL_SECOND'.
								16r6B -> 'SQL_INTERVAL_YEAR_TO_MONTH'.
								16r6C -> 'SQL_INTERVAL_DAY_TO_HOUR'.
								16r6D -> 'SQL_INTERVAL_DAY_TO_MINUTE'.
								16r6E -> 'SQL_INTERVAL_DAY_TO_SECOND'.
								16r6F -> 'SQL_INTERVAL_HOUR_TO_MINUTE'.
								16r70 -> 'SQL_INTERVAL_HOUR_TO_SECOND'.
								16r71 -> 'SQL_INTERVAL_MINUTE_TO_SECOND'
							}).
			'UpdateCascade' -> 16r100.
			'UpdateRestrict' -> 16r200.
			'UpdateRules' -> 16r700.
			'UpdateSetNull' -> 16r400
		}!

Database.DBColAttr guid: (Core.GUID fromString: '{87b4c471-026e-11d3-9fd7-00a0cc3e4a32}')!

Database.DBColAttr comment: 'A `DBColAttr` instance describes an SQL column in a table or in a `DBRow` within a `DBResultSet`. 

## Instance Variables:
  `columnNumber`	`SmallInteger` index of column in the result set.
  `name`			`<String>` name of column.
  `length`			`SmallInteger` length (byte size) of the column.
  `sqlType`		`SmallInteger` SQL type code.
  `precision`		`SmallInteger` number of characters/digits if numeric.
  `scale`			`SmallInteger` number of digits after the decimal point if numeric
  `special`			`<integer>` flags
  `bufferClass`		`<dbFieldBufferFactory>

## Class Variables:
  `BufferClasses`	`IdentityDictionary` mapping ODBC data types to <dbFieldBufferFactory> for that type

'!

!Database.DBColAttr categoriesForClass!ODBC Interface! !

!Database.DBColAttr methodsFor!

bufferClass
	^bufferClass!

bufferClass: aClass
	bufferClass := aClass.
	length := bufferClass dbTransferOctetLengthForColumn: self!

bufferClasses
	^##((IdentityDictionary withAll: {SQL_CHAR -> DBCharBuffer.
						SQL_VARCHAR -> DBVarCharBuffer.
						SQL_LONGVARCHAR -> DBVarCharBuffer.
						SQL_WCHAR -> DBWCharBuffer.
						SQL_WVARCHAR -> DBVarWCharBuffer.
						SQL_WLONGVARCHAR -> DBVarWCharBuffer.
						SQL_BINARY -> DBBinaryBuffer.
						SQL_VARBINARY -> DBVarBinaryBuffer.
						SQL_LONGVARBINARY -> DBVarBinaryBuffer.
						SQL_BIT -> External.BOOLEAN.
						SQL_TINYINT -> External.UInt8.
						SQL_SMALLINT -> External.Int16.
						SQL_INTEGER -> External.Int32.
						SQL_BIGINT -> External.Int64.
						SQL_NUMERIC -> DBNumericFieldBuffer.
						SQL_DECIMAL -> DBNumericFieldBuffer.
						SQL_FLOAT -> External.DOUBLE.
						SQL_REAL -> External.FLOAT.
						SQL_DOUBLE -> External.DOUBLE.
						SQL_TYPE_DATE -> OS.SQL_DATE_STRUCT.
						SQL_INTERVAL -> OS.SQL_TIME_STRUCT.
						SQL_TYPE_TIME -> OS.SQL_TIME_STRUCT.
						SQL_TIMESTAMP -> OS.SQL_TIMESTAMP_STRUCT.
						SQL_TYPE_TIMESTAMP -> OS.SQL_TIMESTAMP_STRUCT.
						SQL_GUID -> GUID.
						SQL_TYPE_NULL -> nil.
						SQL_INTERVAL_DAY -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_DAY_TO_HOUR -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_DAY_TO_MINUTE -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_DAY_TO_SECOND -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_HOUR -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_HOUR_TO_MINUTE -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_HOUR_TO_SECOND -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_MINUTE -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_MINUTE_TO_SECOND -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_SECOND -> OS.SQL_DAY_SECOND_STRUCT.
						SQL_INTERVAL_MONTH -> OS.SQL_YEAR_MONTH_STRUCT.
						SQL_INTERVAL_YEAR -> OS.SQL_YEAR_MONTH_STRUCT.
						SQL_INTERVAL_YEAR_TO_MONTH -> OS.SQL_YEAR_MONTH_STRUCT.
						SQL_SS_TIMESTAMPOFFSET -> OS.SQL_SS_TIMESTAMPOFFSET_STRUCT.
						SQL_SS_TIME2 -> OS.DBTIME2}))!

columnNumber
	"Answer the instance variable columnNumber"

	^columnNumber!

columnNumber: anInteger
	"Private - Set the instance variable columnNumber to anInteger."

	columnNumber := anInteger!

deleteRuleMask
	"Answer the delete rule mask for the receiver"

	| answer |
	answer := (special bitAnd: DeleteRules) bitShift: -4.
	^answer == 0 ifFalse: [ answer bitShift: -1 ]!

deleteRuleMask: anInteger
	"Private - Set the delete rule mask for the receiver to anInteger"

	special := special bitAnd: DeleteRules bitInvert.
	anInteger isNil ifFalse: [special mask: (1 bitShift: anInteger + 4) set: true]!

hasVariableTransferOctetLength
	^bufferClass dbHasVariableTransferOctetLength!

initialize
	"Private - Initialize the receiver"

	special := ##(SQL_PARAM_INPUT bitShift: ParameterTypeShift).
	length := 0!

isForeignKey
	"Answer true if the receiver represents a foreign key"

	^special allMask: ForeignKey!

isForeignKey: aBoolean
	"Private - Mark the receiver as representing a foreign key according to aBoolean"

	special mask: ForeignKey set: aBoolean!

isKey
	"Answer true if the receiver is a key"

	^special anyMask: (PrimaryKey bitOr: ForeignKey)!

isPrimaryKey
	"Answer true if the receiver is a primary key"

	^special allMask: PrimaryKey!

isPrimaryKey: aBoolean
	"Private - Sets the receiver to be a primary key according to aBoolean"

	special mask: PrimaryKey set: aBoolean!

length
	"Answer the octet length of the column. This is only the actual octet length for fixed width columns."

	^length!

length: anInteger
	"Private - Record the octet length of the column described."

	length := anInteger!

marshaller
	^bufferClass!

name
	"Answer the name instance variable."

	^name!

name: aString
	"Set the name instance variable to aString."

	name := aString!

newBoundField
	^(bufferClass dbBoundFieldClassForColumn: self) newForCol: self!

parameterType
	"Answer the SQL_PARAM_XXXX value that defines the type of parameter
	the receiver represents when used in a parameterized statement. The default
	is SQL_PARAM_INPUT, which is appropriate for most cases except some
	stored procedures."

	^(special bitAnd: ParameterTypeMask) >> ParameterTypeShift!

parameterType: anInteger 
	"Set the type of parameter the receiver represents when used in a parameterized 
	statement to the SQL_PARAM_XXXX value specified as the integer argument.
	This must be one of:
		SQL_PARAM_TYPE_UNKNOWN 	- direction unspecified
		SQL_PARAM_INPUT			- input only parameter
		SQL_PARAM_INPUT_OUTPUT         - bidirectional parameter
		SQL_RESULT_COL                   		- result set column
		SQL_PARAM_OUTPUT                 	- output only parameter
		SQL_RETURN_VALUE                 	- stored procedure return value
	The parameterType should not be changed from the default (SQL_PARAM_INPUT),
	unless describing an output or input/output parameter to a stored procedure."

	special := (special maskClear: ParameterTypeMask) 
				maskSet: (anInteger bitShift: ParameterTypeShift)!

precision
	"Answer the precision instance variable."

	^precision!

precision: anInteger
	"Private - Set the precision instance variable to anInteger."

	precision := anInteger!

printOn: aStream
	"Append the ASCII representation of
	 the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self columnNumber;
		nextPutAll: ', ';
		display: self name;
		nextPutAll: ', ';
		nextPutAll: (Types at: self type ifAbsent: 'SQL_TYPE_NULL');
		nextPutAll: ', ';
		print: self length;
		nextPut: $)!

scale
	"Answer the scale instance variable."

	^scale!

scale: anInteger
	"Set the scale instance variable to anInteger."

	scale := anInteger!

type
	"Answer the sqlType instance variable."

	^sqlType!

type: anInteger
	"Private - Set the sqlType instance variable to anInteger."

	sqlType := anInteger.
	self bufferClass: (self bufferClasses at: anInteger
				ifAbsent: [self error: 'Unmarshallable column: ' , self printString])!

updateRuleMask
	"Answer the update rule mask for the receiver"

	| answer |
	answer := (special bitAnd: DeleteRules) bitShift: -8.
	^answer == 0 ifFalse: [ answer bitShift: -1 ]!

updateRuleMask: anInteger
	"Private - Set the update rule mask for the receiver to anInteger"

	special := special bitAnd: ##(UpdateRules bitInvert).
	anInteger ifNotNil: [special bitOr: (1 bitShift: anInteger + 8)]! !

!Database.DBColAttr categoriesForMethods!
bufferClass!accessing!public! !
bufferClass:!initializing!private! !
bufferClasses!accessing!public! !
columnNumber!accessing!public! !
columnNumber:!accessing!private! !
deleteRuleMask!accessing!public! !
deleteRuleMask:!accessing!private! !
hasVariableTransferOctetLength!public!testing! !
initialize!initializing!private! !
isForeignKey!public!testing! !
isForeignKey:!accessing!private! !
isKey!public!testing! !
isPrimaryKey!public!testing! !
isPrimaryKey:!accessing!private! !
length!accessing!public! !
length:!accessing!private! !
marshaller!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
newBoundField!helpers!private! !
parameterType!accessing!public! !
parameterType:!accessing!public! !
precision!accessing!public! !
precision:!accessing!private! !
printOn:!printing!public! !
scale!accessing!public! !
scale:!accessing!public! !
type!accessing!public! !
type:!initializing!private! !
updateRuleMask!accessing!public! !
updateRuleMask:!accessing!private! !
!

!Database.DBColAttr class methodsFor!

initialize
	self addClassConstant: 'Types'
		value: (IdentityDictionary withAll: {
						SQL_BIGINT -> 'SQL_BIGINT'.
						SQL_BINARY -> 'SQL_BINARY'.
						SQL_BIT -> 'SQL_BIT'.
						SQL_CHAR -> 'SQL_CHAR'.
						SQL_DATETIME -> 'SQL_DATETIME'.
						SQL_DECIMAL -> 'SQL_DECIMAL'.
						SQL_DOUBLE -> 'SQL_DOUBLE'.
						SQL_FLOAT -> 'SQL_FLOAT'.
						SQL_GUID -> 'SQL_GUID'.
						SQL_INTEGER -> 'SQL_INTEGER'.
						SQL_INTERVAL -> 'SQL_INTERVAL'.
						SQL_INTERVAL_DAY -> 'SQL_INTERVAL_DAY'.
						SQL_INTERVAL_DAY_TO_HOUR -> 'SQL_INTERVAL_DAY_TO_HOUR'.
						SQL_INTERVAL_DAY_TO_MINUTE -> 'SQL_INTERVAL_DAY_TO_MINUTE'.
						SQL_INTERVAL_DAY_TO_SECOND -> 'SQL_INTERVAL_DAY_TO_SECOND'.
						SQL_INTERVAL_HOUR -> 'SQL_INTERVAL_HOUR'.
						SQL_INTERVAL_HOUR_TO_MINUTE -> 'SQL_INTERVAL_HOUR_TO_MINUTE'.
						SQL_INTERVAL_HOUR_TO_SECOND -> 'SQL_INTERVAL_HOUR_TO_SECOND'.
						SQL_INTERVAL_MINUTE -> 'SQL_INTERVAL_MINUTE'.
						SQL_INTERVAL_MINUTE_TO_SECOND -> 'SQL_INTERVAL_MINUTE_TO_SECOND'.
						SQL_INTERVAL_MONTH -> 'SQL_INTERVAL_MONTH'.
						SQL_INTERVAL_SECOND -> 'SQL_INTERVAL_SECOND'.
						SQL_INTERVAL_YEAR -> 'SQL_INTERVAL_YEAR'.
						SQL_INTERVAL_YEAR_TO_MONTH -> 'SQL_INTERVAL_YEAR_TO_MONTH'.
						SQL_LONGVARBINARY -> 'SQL_LONGVARBINARY'.
						SQL_LONGVARCHAR -> 'SQL_LONGVARCHAR'.
						SQL_NUMERIC -> 'SQL_NUMERIC'.
						SQL_REAL -> 'SQL_REAL'.
						SQL_SMALLINT -> 'SQL_SMALLINT'.
						SQL_SS_TIME2 -> 'SQL_SS_TIME2'.
						SQL_SS_TIMESTAMPOFFSET -> 'SQL_SS_TIMESTAMPOFFSET'.
						SQL_SS_VARIANT -> 'SQL_SS_VARIANT'.
						SQL_SS_XML -> 'SQL_SS_XML'.
						SQL_TIMESTAMP -> 'SQL_TIMESTAMP'.
						SQL_TINYINT -> 'SQL_TINYINT'.
						SQL_TYPE_DATE -> 'SQL_TYPE_DATE'.
						SQL_TYPE_NULL -> 'SQL_TYPE_NULL'.
						SQL_TYPE_TIME -> 'SQL_TYPE_TIME'.
						SQL_TYPE_TIMESTAMP -> 'SQL_TYPE_TIMESTAMP'.
						SQL_VARBINARY -> 'SQL_VARBINARY'.
						SQL_VARCHAR -> 'SQL_VARCHAR'.
						SQL_WCHAR -> 'SQL_WCHAR'.
						SQL_WLONGVARCHAR -> 'SQL_WLONGVARCHAR'.
						SQL_WVARCHAR -> 'SQL_WVARCHAR'
					})!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize! !

!Database.DBColAttr class categoriesForMethods!
initialize!class initialization!public! !
new!instance creation!public! !
!

