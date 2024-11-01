"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Database.DBColAttr'
	instanceVariableNames: 'columnNumber name length sqlType precision scale special bufferClass'
	classVariableNames: 'BufferClasses'
	imports: #(#{Database.DBColFlags} #{OS.ODBCTypes} #{OS.ODBCConstants} #{OS.ODBCCTypes})
	classInstanceVariableNames: ''
	classConstants: {}!

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

bufferClass: anObject
	bufferClass := anObject!

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
		nextPutAll: (OS.ODBCTypes keyAtValue: self type ifAbsent: 'SQL_TYPE_NULL');
		nextPutAll: ', ';
		print: self length;
		nextPut: $)!

scale
	"Answer the scale instance variable."

	^scale!

scale: anInteger
	"Set the scale instance variable to anInteger."

	scale := anInteger!

transferOctetLength
	"Private - Return the transfer octet length (size in bytes of the buffer necessary to receive data for this column) based on the column type."

	^bufferClass dbTransferOctetLengthForColumn: self!

type
	"Answer the sqlType instance variable."

	^sqlType!

type: anInteger
	"Private - Set the sqlType instance variable to anInteger."

	sqlType := anInteger.
	bufferClass := BufferClasses at: anInteger
				ifAbsent: [self error: 'Unmarshallable column: ' , self printString].
	length := self transferOctetLength!

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
bufferClass:!accessing!private! !
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
transferOctetLength!accessing!initializing!private! !
type!accessing!public! !
type:!accessing!private! !
updateRuleMask!accessing!public! !
updateRuleMask:!accessing!private! !
!

!Database.DBColAttr class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self addClassConstant: 'BufferClasses'
		value: (IdentityDictionary withAll: {SQL_CHAR -> Smalltalk.DBVarCharBuffer.
						SQL_VARCHAR -> Smalltalk.DBVarCharBuffer.
						SQL_LONGVARCHAR -> Smalltalk.DBVarCharBuffer.
						SQL_WCHAR -> Smalltalk.DBVarWCharBuffer.
						SQL_WVARCHAR -> Smalltalk.DBVarWCharBuffer.
						SQL_WLONGVARCHAR -> Smalltalk.DBVarWCharBuffer.
						SQL_BINARY -> Smalltalk.DBVarBinaryBuffer.
						SQL_VARBINARY -> Smalltalk.DBVarBinaryBuffer.
						SQL_LONGVARBINARY -> Smalltalk.DBVarBinaryBuffer.
						SQL_BIT -> External.BOOLEAN.
						SQL_TINYINT -> External.UInt8.
						SQL_SMALLINT -> External.Int16.
						SQL_INTEGER -> External.Int32.
						SQL_BIGINT -> External.Int64.
						SQL_NUMERIC -> Smalltalk.DBNumericFieldBuffer.
						SQL_DECIMAL -> Smalltalk.DBNumericFieldBuffer.
						SQL_FLOAT -> External.DOUBLE.
						SQL_REAL -> External.FLOAT.
						SQL_DOUBLE -> External.DOUBLE.
						SQL_DATE -> Smalltalk.SQL_DATE_STRUCT.
						SQL_TYPE_DATE -> Smalltalk.SQL_DATE_STRUCT.
						SQL_TIME -> Smalltalk.SQL_TIME_STRUCT.
						SQL_TYPE_TIME -> Smalltalk.SQL_TIME_STRUCT.
						SQL_TIMESTAMP -> Smalltalk.SQL_TIMESTAMP_STRUCT.
						SQL_TYPE_TIMESTAMP -> Smalltalk.SQL_TIMESTAMP_STRUCT.
						SQL_GUID -> Core.GUID.
						SQL_TYPE_NULL -> nil.
						SQL_INTERVAL_DAY -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_DAY_TO_HOUR -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_DAY_TO_MINUTE -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_DAY_TO_SECOND -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_HOUR -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_HOUR_TO_MINUTE -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_HOUR_TO_SECOND -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_MINUTE -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_MINUTE_TO_SECOND -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_SECOND -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_MONTH -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_YEAR -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_INTERVAL_YEAR_TO_MONTH -> Smalltalk.SQL_INTERVAL_STRUCT.
						SQL_SS_TIMESTAMPOFFSET -> Smalltalk.SQL_SS_TIMESTAMPOFFSET_STRUCT.
						SQL_SS_TIME2 -> Smalltalk.DBTIME2})!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize! !

!Database.DBColAttr class categoriesForMethods!
initialize!initializing!private! !
new!instance creation!public! !
!

