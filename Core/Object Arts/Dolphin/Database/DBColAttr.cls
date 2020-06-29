"Filed out from Dolphin Smalltalk 7"!

Object subclass: #DBColAttr
	instanceVariableNames: 'columnNumber name length sqlType precision scale special'
	classVariableNames: ''
	poolDictionaries: 'DBColFlags ODBCConstants ODBCCTypes ODBCTypes'
	classInstanceVariableNames: ''
	classConstants: {
		'CTypesExtraBytes' -> #(0 2 2 2 0 0 0 0 0 0 1 0 1 1 1 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0).
		'SQLToCTypes' -> #(-11 -8 -8 -8 -7 -6 -25 -2 -2 -2 1 99 1 1 1 4 5 8 7 8 nil nil nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 91 92 93)
	}!
DBColAttr guid: (GUID fromString: '{87b4c471-026e-11d3-9fd7-00a0cc3e4a32}')!
DBColAttr comment: 'A DBColAttr instance describes an SQL column in a table or in a DBRow within a DBResultSet. 

Instance Variables:
	columnNumber	<Integer>. Index of column in the result set.
	name		<String>. Name of column.
	length		<Integer>. Length (bytes) of the column.
	sqlType		<Integer>. Type code.
	precision		<Integer>. Number of characters/digits. 
	scale		<Integer>. Digits after decimal point.
	special		<Integer>. Flags.

Class Variables:
	ODBCBaseTypes	<IdentityDictionary>

'!
!DBColAttr categoriesForClass!ODBC Interface! !
!DBColAttr methodsFor!

columnNumber
	"Answer the instance variable columnNumber"

	^columnNumber!

columnNumber: anInteger
	"Private - Set the instance variable columnNumber to anInteger."

	columnNumber := anInteger!

cType
	"Private - Answer the 'C' type to which the described column's values should be converted when loaded
	into Dolphin buffers (DBFields)."

	^SQLToCTypes at: sqlType+TypeOffset!

deleteRuleMask
	"Answer the delete rule mask for the receiver"

	| answer |
	answer := (special bitAnd: DeleteRules) bitShift: -4.
	^answer == 0 ifFalse: [ answer bitShift: -1 ]!

deleteRuleMask: anInteger
	"Private - Set the delete rule mask for the receiver to anInteger"

	special := special bitAnd: DeleteRules bitInvert.
	anInteger isNil ifFalse: [
		self specialFlagAt:
			(1 bitShift: (anInteger+4))
			put: true ]!

hasVariableTransferOctetLength

	^(self isCharType or: [self isBinaryType]) and: [self isFixedPointType not]!

initialize
	"Private - Initialize the receiver"

	special := ##(SQL_PARAM_INPUT bitShift: ParameterTypeShift)!

isBinaryType
	"Private - Answers true if the receiver represents a character based column"

	^self cType == SQL_C_BINARY!

isCharType
	"Private - Answers true if the receiver represents a character based column"

	| cType |

	^(cType := self cType) == SQL_C_CHAR or: [cType == SQL_C_WCHAR]!

isFixedPointType

	^sqlType == SQL_DECIMAL or: [sqlType == SQL_NUMERIC]!

isForeignKey
	"Answer true if the receiver represents a foreign key"

	^self specialFlagAt: ForeignKey!

isForeignKey: aBoolean
	"Private - Mark the receiver as representing a foreign key according to aBoolean"

	self specialFlagAt: ForeignKey put: aBoolean!

isKey
	"Answer true if the receiver is a key"

	^special anyMask: (PrimaryKey bitOr: ForeignKey)!

isPrimaryKey
	"Answer true if the receiver is a primary key"

	^self specialFlagAt: PrimaryKey!

isPrimaryKey: aBoolean
	"Private - Sets the receiver to be a primary key according to aBoolean"

	self specialFlagAt: PrimaryKey put: aBoolean!

length
	"Answer the length instance variable."

	^length!

length: anInteger
	"Private - Set the length instance variable to anInteger."

	length := anInteger!

lengthC
	"Private - Answer the length of ByteArray sufficient to hold an entry for this column when converted to 'C' data. This needs to include any extra space for null-terminators if the 'C' target type is some kind of string."

	^length + (CTypesExtraBytes at: sqlType+TypeOffset)!

name
	"Answer the name instance variable."

	^name!

name: aString
	"Private - Set the name instance variable to aString."

	name := aString!

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
		nextPutAll: self name;
		nextPutAll: ', ';
		nextPutAll: (ODBCTypes keyAtValue: self type ifAbsent: ['SQL_TYPE_NULL']);
		nextPutAll: ', ';
		print: self length;
		nextPut: $)!

scale
	"Answer the scale instance variable."

	^scale!

scale: anInteger
	"Private - Set the scale instance variable to anInteger."

	scale := anInteger!

specialFlagAt: flagMask
	"Private - Answer the special flag identified by flagMask"

	^special allMask: flagMask!

specialFlagAt: flagMask put: aBoolean
	"Private - Set the special flag identified by flagMask to aBoolean"

	special mask: flagMask set: aBoolean!

transferOctetLength

	"Private - Return the transfer octet length (size in bytes of the buffer necessary to receive data for this column) based on the column type.
	https://docs.microsoft.com/en-us/sql/odbc/reference/appendixes/transfer-octet-length"

	(sqlType = SQL_BIT or: [sqlType = SQL_TINYINT]) ifTrue: [^1].
	sqlType = SQL_SMALLINT ifTrue: [^2].
	(sqlType = SQL_INTEGER or: [sqlType = SQL_REAL]) ifTrue: [^4].
	(sqlType = SQL_TYPE_DATE or: [sqlType = SQL_TYPE_TIME]) ifTrue: [^6].
	(sqlType = SQL_FLOAT or: [sqlType = SQL_DOUBLE]) ifTrue: [^8].
	(sqlType = SQL_TYPE_TIMESTAMP or: [sqlType = SQL_GUID]) ifTrue: [^16].

	"SQL_BIGINT
	The number of bytes required to hold the character representation of this data if the character set is ANSI, and twice this number if the character set is UNICODE, because this data type is returned as a character string by default. The character representation consists of 20 characters: 19 for digits and a sign, if signed, or 20 digits, if unsigned. Therefore, the length is 20."
	sqlType = SQL_BIGINT ifTrue: [^##(20 * 2 "allow for unicode")].

	"SQL_DECIMAL, SQL_NUMERIC
	The number of bytes required to hold the character representation of this data if the character set is ANSI, and twice this number if the character set is UNICODE. This is the maximum number of digits plus two, because the data is returned as a character string and characters are needed for the digits, a sign, and a decimal point. For example, the transfer length of a column defined as NUMERIC(10,3) is 12."
	(sqlType = SQL_DECIMAL or: [sqlType = SQL_NUMERIC]) ifTrue: [^(self precision + 2) * 2 "allow for unicode"].

	self hasVariableTransferOctetLength
		ifTrue: [self error: 'column has variable transfer octet length']
		ifFalse: [self error: 'unknown type']!

type
	"Answer the sqlType instance variable."

	^sqlType!

type: anInteger
	"Private - Set the sqlType instance variable to anInteger."

	sqlType := anInteger!

updateRuleMask
	"Answer the update rule mask for the receiver"

	| answer |
	answer := (special bitAnd: DeleteRules) bitShift: -8.
	^answer == 0 ifFalse: [ answer bitShift: -1 ]!

updateRuleMask: anInteger
	"Private - Set the update rule mask for the receiver to anInteger"

	special := special bitAnd: UpdateRules bitInvert.
	anInteger isNil ifFalse: [
		self specialFlagAt:
			(1 bitShift: (anInteger+8)) 
			put: true ]! !
!DBColAttr categoriesFor: #columnNumber!accessing!public! !
!DBColAttr categoriesFor: #columnNumber:!accessing!private! !
!DBColAttr categoriesFor: #cType!accessing!private! !
!DBColAttr categoriesFor: #deleteRuleMask!accessing!public! !
!DBColAttr categoriesFor: #deleteRuleMask:!accessing!private! !
!DBColAttr categoriesFor: #hasVariableTransferOctetLength!public!testing! !
!DBColAttr categoriesFor: #initialize!initializing!private! !
!DBColAttr categoriesFor: #isBinaryType!private!testing! !
!DBColAttr categoriesFor: #isCharType!private!testing! !
!DBColAttr categoriesFor: #isFixedPointType!private!testing! !
!DBColAttr categoriesFor: #isForeignKey!public!testing! !
!DBColAttr categoriesFor: #isForeignKey:!accessing!private! !
!DBColAttr categoriesFor: #isKey!public!testing! !
!DBColAttr categoriesFor: #isPrimaryKey!public!testing! !
!DBColAttr categoriesFor: #isPrimaryKey:!accessing!private! !
!DBColAttr categoriesFor: #length!accessing!public! !
!DBColAttr categoriesFor: #length:!accessing!private! !
!DBColAttr categoriesFor: #lengthC!accessing!private! !
!DBColAttr categoriesFor: #name!accessing!public! !
!DBColAttr categoriesFor: #name:!accessing!private! !
!DBColAttr categoriesFor: #parameterType!accessing!public! !
!DBColAttr categoriesFor: #parameterType:!accessing!public! !
!DBColAttr categoriesFor: #precision!accessing!public! !
!DBColAttr categoriesFor: #precision:!accessing!private! !
!DBColAttr categoriesFor: #printOn:!printing!public! !
!DBColAttr categoriesFor: #scale!accessing!public! !
!DBColAttr categoriesFor: #scale:!accessing!private! !
!DBColAttr categoriesFor: #specialFlagAt:!accessing!private! !
!DBColAttr categoriesFor: #specialFlagAt:put:!accessing!private! !
!DBColAttr categoriesFor: #transferOctetLength!accessing!initializing!private! !
!DBColAttr categoriesFor: #type!accessing!public! !
!DBColAttr categoriesFor: #type:!accessing!private! !
!DBColAttr categoriesFor: #updateRuleMask!accessing!public! !
!DBColAttr categoriesFor: #updateRuleMask:!accessing!private! !

!DBColAttr class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	"The types to convert the result data to on loading into our buffers - normally these are the default conversions
	 because they are sensible for most things except GUIDs (where the default string conversion doesn't match 
	 the reported column length, which makes allocating an appropriately sized buffer tricky)."

	"The 'C' buffer types specified here must match up with the 'get' conversions defined for the SQL column type in the DBField class (see DBField>>#initialize)"

	| extraBytes |
	self addClassConstant: 'SQLToCTypes'
		value: ((Array new: SQL_NUM_TYPES)
				at: SQL_CHAR + TypeOffset put: SQL_C_CHAR;
				at: SQL_VARCHAR + TypeOffset put: SQL_C_CHAR;
				at: SQL_LONGVARCHAR + TypeOffset put: SQL_C_CHAR;
				at: SQL_WCHAR + TypeOffset put: SQL_C_WCHAR;
				at: SQL_WVARCHAR + TypeOffset put: SQL_C_WCHAR;
				at: SQL_WLONGVARCHAR + TypeOffset put: SQL_C_WCHAR;
				at: SQL_BINARY + TypeOffset put: SQL_C_BINARY;
				at: SQL_VARBINARY + TypeOffset put: SQL_C_BINARY;
				at: SQL_LONGVARBINARY + TypeOffset put: SQL_C_BINARY;
				at: SQL_BIT + TypeOffset put: SQL_C_BIT;
				at: SQL_TINYINT + TypeOffset put: SQL_C_TINYINT;
				at: SQL_SMALLINT + TypeOffset put: SQL_C_SHORT;
				at: SQL_INTEGER + TypeOffset put: SQL_C_LONG;
				at: SQL_BIGINT + TypeOffset put: SQL_C_SBIGINT;
				at: SQL_NUMERIC + TypeOffset put: SQL_C_CHAR;
				at: SQL_DECIMAL + TypeOffset put: SQL_C_CHAR;
				at: SQL_FLOAT + TypeOffset put: SQL_C_DOUBLE;
				at: SQL_REAL + TypeOffset put: SQL_C_FLOAT;
				at: SQL_DOUBLE + TypeOffset put: SQL_C_DOUBLE;
				at: SQL_TYPE_DATE + TypeOffset put: SQL_C_TYPE_DATE;
				at: SQL_TYPE_TIME + TypeOffset put: SQL_C_TYPE_TIME;
				at: SQL_TYPE_TIMESTAMP + TypeOffset put: SQL_C_TYPE_TIMESTAMP;
				at: SQL_GUID + TypeOffset put: SQL_C_GUID;
				at: SQL_TYPE_NULL + TypeOffset put: SQL_C_DEFAULT;
				yourself).
	extraBytes := Array new: SQL_NUM_TYPES withAll: 0.
	SQLToCTypes keysAndValuesDo: 
			[:eachKey :eachValue |
			eachValue == SQL_C_CHAR ifTrue: [extraBytes at: eachKey put: 1].
			eachValue == SQL_C_WCHAR ifTrue: [extraBytes at: eachKey put: 2]].
	self addClassConstant: 'CTypesExtraBytes' value: extraBytes!

new
	"Answer a new initialized instance of the receiver."

	^super new initialize! !
!DBColAttr class categoriesFor: #initialize!initializing!private! !
!DBColAttr class categoriesFor: #new!instance creation!public! !

