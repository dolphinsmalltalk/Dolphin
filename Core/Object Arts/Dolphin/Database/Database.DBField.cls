"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Database.DBField'
	instanceVariableNames: 'column buffer lengthBuf'
	classVariableNames: ''
	imports: #(#{OS.ODBCTypes} #{OS.ODBCRetCodes} #{OS.ODBCConstants} #{OS.ODBCCTypes})
	classInstanceVariableNames: ''
	classConstants: {
		'GetSelectors' -> #(#getGuid #getUtf16String #getUtf16String #getUtf16String #getBoolean #getByte #getInt64 #getByteArray #getByteArray #getByteArray #getAnsiString nil #getAnsiString #numberFromNumeric #numberFromNumeric #getLong #getShort #getDouble #getFloat #getDouble nil nil nil #getAnsiString nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #getDate #getTime #getDateAndTime).
		'SetSelectors' -> #(#setGuid: #setUtf16String: #setUtf16String: #setUtf16String: #setBoolean: #setByte: #setInt64: #setByteArray: #setByteArray: #setByteArray: #setAnsiString: nil #setAnsiString: #numberToNumeric: #numberToNumeric: #setLong: #setShort: #setDouble: #setFloat: #setDouble: nil nil nil #setAnsiString: nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil #setDate: #setTime: #setDateAndTime:)
	}!
Database.DBField guid: (Core.GUID fromString: '{87b4c475-026e-11d3-9fd7-00a0cc3e4a32}')!
Database.DBField comment: 'A DBField instance represents a column buffer for holding data as part of a DBRow.

A field''s value may be converted to a Smalltalk object by sending #value, and conversely may be assigned with #value:.

Instance Variables:
	column		<DBColAttr>. Metadata about the column
	buffer		<ByteArray>. Buffer to hold column data.
	lengthBuf		<SDWORD>. 32-bit integer buffer to hold column data length.

Class Variables:
	GetSelectors	<Array> of <Symbol>. Maps integer type codes to accessor for that type.
	SetSelectors	<Array> of <Symbol>. Maps integer type codes to mutator for that type.

'!
!Database.DBField categoriesForClass!ODBC Interface! !
!Database.DBField methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent."

	^comparand species == self species and: [
		column = comparand column and: [self value = comparand value]]!

beNull
	"Set the receiver to be a null valued field."

	lengthBuf value: SQL_NULL_DATA!

column
	^column!

fieldBuf
	"Private - Answer the address of the buffer for passing to the ODBC DLL."

	^buffer!

fieldSize
	"Private - Answer the 'C' length of the receiver's associated column (the C length includes space for the null
	terminator if the column is a string)"

	^column lengthC!

getAnsiString
	"Private - Answer an <AnsiString> read from the receiver's buffer, i.e. to read from a SQL_C_CHAR, SQL_C_VARCHAR, or SQL_C_LONGVARCHAR buffer."

	| len |
	len := lengthBuf value.
	^buffer
		replaceBytesOf: (AnsiString new: len)
		from: 1
		to: len
		startingAt: 1!

getBoolean
	"Private - Answer a <Boolean> read from the receiver's buffer."

	^(buffer at: 1) allMask: 1!

getByte
	"Private - Answer the receiver's buffer as an unsigned byte."

	^buffer basicAt: 0 + 1!

getByteArray
	"Private - Answer a <ByteArray> copied from the receiver's buffer."

	^buffer copyFrom: 1 to: lengthBuf value!

getData: aDBStatement
	"Private - Retrieve the receiver's associated column data from the ODBC result set
	following a fetch (into the receiver's buffer)."

	| ret |
	ret := OS.ODBCLibrary default
				sqlGetData: aDBStatement executedHandle
				columnNumber: column columnNumber
				targetType: column cType
				targetValuePtr: buffer
				bufferLength: buffer size
				strLenOrIndPtr: lengthBuf.
	aDBStatement dbCheckException: ret!

getDate
	"Private - Answer an instance of <Date> representing the contents of the receiver.
	Use the services of the ODBCDATE structure to split the buffer."

	^(OS.ODBCDATE withBytes: buffer) asDate!

getDateAndTime
	"Private - Answer an instance of <DateAndTime> representing the same DateAndTime as that stored in the buffer as an ODBCDATE and ODBCTIME."

	^(OS.ODBCTIMESTAMP withBytes: buffer) asDateAndTime!

getDouble
	"Private - Answer a <Float> read from the IEEE 64-bit double precision floating point number in the receiver's buffer."

	^buffer doubleAtOffset: 0!

getFloat
	"Private - Answer a <Float> representing the 32-bit IEEE single precision floating point number in the receiver's buffer."

	^buffer floatAtOffset: 0!

getGuid
	"Private - Answer a <GUID> read from the receiver's buffer."

	^GUID fromBytes: buffer!

getInt64
	"Private - Answer an <integer> read from the 64-bit signed integer in the receiver's buffer."

	^buffer sqwordAtOffset: 0!

getLong
	"Private - Answer an <integer> read from the 32-bit signed integer in the receiver's buffer."

	^buffer sdwordAtOffset: 0!

getShort
	"Private - Answer an <integer> read from the signed 16-bit value in the receiver's buffer."

	^buffer swordAtOffset: 0!

getTime
	"Private - Answer an instance of <Time> representing the buffer of the receiver.
	Use the services of the <ODBCTIME> structure to split the buffer."

	^(OS.ODBCTIME withBytes: buffer) asTime!

getUtf16String
	"Private - Answer the receiver's buffer as an <AnsiString>, i.e. to read from a SQL_C_WCHAR, SQL_C_WVARCHAR, or SQL_C_WLONGVARCHAR buffer."

	| len |
	len := lengthBuf value.
	^buffer
		replaceBytesOf: (Utf16String new: (len bitShift: -1))
		from: 1
		to: len
		startingAt: 1!

hash
	"Answer the <integer> hash value for the receiver. Must be the same for any two DBField's that compare equal."

	^column hash bitXor: self value hash!

initializeForColumn: aDBColAttr
	"Private - Initialize the receiver to represent a value from
	the database column described by the <DBColAttr> argument.
	Answer the receiver."

	lengthBuf := External.SDWORD fromInteger: SQL_NULL_DATA.
	column := aDBColAttr.
	buffer := ByteArray newFixed: (##(2 raisedTo: 16) min: aDBColAttr lengthC).
	^self!

isNull
	"Answer whether the receiver represents a null field."

	^lengthBuf value == SQL_NULL_DATA!

lengthBuf
	"Private - Answer the address of the length buffer for passing to ODBC"

	^lengthBuf!

numberFromNumeric
	"Private - Answer the receiver's contents converted from a
	string NUMERIC to a <ScaledDecimal> (ODBC converts NUMERIC
	fields to strings by default, but NUMERIC is a decimal type)."

	| integerPart number fractionPart scale char isNegative stream |
	stream := ReadStream
				on: buffer
				from: 1
				to: lengthBuf value.
	integerPart := 0.
	scale := 0.
	isNegative := stream peekFor: ##($- codePoint).
	[stream atEnd or: [(char := stream next) == ##($. codePoint)]]
		whileFalse: [integerPart := integerPart * 10 + (char - ##($0 codePoint))].
	fractionPart := 0.
	[stream atEnd] whileFalse: 
			[char := stream next.
			fractionPart := fractionPart * 10 + (char - ##($0 codePoint)).
			scale := scale + 1].
	number := fractionPart / scale exp10 + integerPart.
	isNegative ifTrue: [number := number negated].
	^ScaledDecimal newFromNumber: number scale: scale!

numberToNumeric: aNumber
	"Private - Convert the argument to a 'C' string stored in the receiver for passing to ODBC (probably as a
	bound parameter) where a NUMERIC is expected."

	#todo. "Define and use the SQL_NUMERIC_STRUCT instead of converting to a string"
	(self shouldTranslate: aNumber class: Number) 	ifTrue: [ 
		self setAnsiString: (aNumber asScaledDecimal: column scale) displayString]!

printOn: aStream 
	"Append the ASCII representation of the receiver to aStream."

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: column name;
		nextPut: $=;
		print: self value;
		nextPut: $)!

setAnsiString: aString
	"Private - Set the receiver's buffer from aString."

	(self shouldTranslate: aString class: String)
		ifTrue: 
			[| ansi byteCount |
			"This conversion may be lossy - any non-ANSI characters will be substituted with the replacement character."
			ansi := aString asAnsiString.
			byteCount := ansi size.
			buffer
				replaceFrom: 1
				to: byteCount
				with: ansi
				startingAt: 1.
			lengthBuf value: byteCount]!

setBoolean: aBoolean
	"Private - Load the receiver's contents buffer with the <Boolean> argument."

	(self shouldTranslate: aBoolean class: Boolean)
		ifTrue: 
			[buffer at: 1 put: aBoolean asParameter.
			lengthBuf value: 1]!

setByte: aNumber
	"Private - Set the receiver's buffer to an unsigned byte representation of the 
	<Number> argument."

	(self shouldTranslate: aNumber class: Number)
		ifTrue: 
			[buffer at: 1 put: aNumber asInteger.
			lengthBuf value: 1]!

setByteArray: aByteArray
	"Private - Set the receiver's buffer from the <ByteArray> argument."

	(self shouldTranslate: aByteArray class: ByteArray)
		ifTrue: 
			[| byteCount |
			byteCount := aByteArray size min: buffer size.
			buffer
				replaceFrom: 1
				to: byteCount
				with: aByteArray
				startingAt: 1.
			lengthBuf value: byteCount]!

setDate: aDate
	"Private - Set the receiver's buffer with an <ODBCDATE> object instantiated from 
	the <Date> argument."

	(self shouldTranslate: aDate class: Date)
		ifTrue: 
			[(OS.ODBCDATE withBytes: buffer) date: aDate.
			lengthBuf value: OS.ODBCDATE byteSize]!

setDateAndTime: aDateAndTime
	"Private - Set the receiver's buffer with an ODBCTIMESTAMP object instantiated from aDateAndTime."

	(self shouldTranslate: aDateAndTime class: DateAndTime)
		ifTrue: 
			[(OS.ODBCTIMESTAMP withBytes: buffer) dateAndTime: aDateAndTime.
			lengthBuf value: OS.ODBCTIMESTAMP byteSize]!

setDouble: aNumber
	"Private - Set the receiver's double buffer with <Float> value of the 
	<Number> argument."

	(self shouldTranslate: aNumber class: Number)
		ifTrue: 
			[buffer doubleAtOffset: 0 put: aNumber asFloat.
			lengthBuf value: 8]!

setFloat: aNumber
	"Private - Set the receiver's float buffer with the <Float> value of the 
	<Number> argument, aNumber."

	(self shouldTranslate: aNumber class: Number)
		ifTrue: 
			[buffer floatAtOffset: 0 put: aNumber asFloat.
			lengthBuf value: 4]!

setGuid: aGUID
	"Private - Set the receiver's buffer with an <GUID> value."

	(self shouldTranslate: aGUID class: GUID)
		ifTrue: 
			[buffer
				replaceFrom: 1
				to: 16
				with: aGUID
				startingAt: 1.
			lengthBuf value: 16]!

setInt64: aNumber
	"Private - Set the receiver's buffer to the 64-bit signed integer value of the argument."

	(self shouldTranslate: aNumber class: Number)
		ifTrue: 
			[buffer sqwordAtOffset: 0 put: aNumber asInteger.
			lengthBuf value: 8]!

setLong: aNumber
	"Private - Set the receiver's buffer to a 32-bit signed integer representation of the <Integer> argument."

	(self shouldTranslate: aNumber class: Number)
		ifTrue: 
			[buffer sdwordAtOffset: 0 put: aNumber asInteger.
			lengthBuf value: 4]!

setShort: aNumber
	"Private - Set the receiver's buffer to the 16-bit signed integer value of the argument."

	(self shouldTranslate: aNumber class: Number)
		ifTrue: 
			[buffer swordAtOffset: 0 put: aNumber asInteger.
			lengthBuf value: 2]!

setTime: aTime
	"Private - Set the receiver's buffer with an ODBCTIME object instantiated from aTime."

	(self shouldTranslate: aTime class: Time)
		ifTrue: 
			[(OS.ODBCTIME withBytes: buffer) time: aTime.
			lengthBuf value: OS.ODBCTIME byteSize]!

setUtf16String: aString
	"Private - Set the receiver's buffer from aString."

	(self shouldTranslate: aString class: String)
		ifTrue: 
			[| utf16 byteCount |
			utf16 := aString asUtf16String.
			byteCount := utf16 size << 1.
			buffer
				replaceFrom: 1
				to: byteCount
				with: utf16
				startingAt: 1.
			lengthBuf value: byteCount]!

shouldTranslate: anObject class: aClass
	"Private - Answer whether the receiver should attempt to translate anObject into its buffer.
	If anObject isNil then we can set the receiver to be null and answer false.
	If anObject does not descend from aClass then issue an error and answer false."

	(anObject isKindOf: aClass)
		ifFalse: [
			self error: anObject class displayString, '(', anObject displayString,') invalid: ', aClass displayString,' expected'.
			^false].
	^true!

size
	"Private - Answer the size of the receiver's buffer."

	^buffer size!

value
	"Answer the contents of the receiver as a suitable
	Smalltalk object."

	^self isNull ifFalse: [self perform: (GetSelectors at: column type + TypeOffset)]!

value: anObject
	"Set the contents of the receiver's buffer from anObject."

	^anObject
		ifNil: [self beNull]
		ifNotNil: [self perform: (SetSelectors at: column type + TypeOffset) with: anObject]! !
!Database.DBField categoriesFor: #=!comparing!public! !
!Database.DBField categoriesFor: #beNull!accessing!public! !
!Database.DBField categoriesFor: #column!accessing!private! !
!Database.DBField categoriesFor: #fieldBuf!accessing!private! !
!Database.DBField categoriesFor: #fieldSize!accessing!private! !
!Database.DBField categoriesFor: #getAnsiString!converting!private! !
!Database.DBField categoriesFor: #getBoolean!converting!private! !
!Database.DBField categoriesFor: #getByte!converting!private! !
!Database.DBField categoriesFor: #getByteArray!converting!private! !
!Database.DBField categoriesFor: #getData:!accessing!private! !
!Database.DBField categoriesFor: #getDate!converting!private! !
!Database.DBField categoriesFor: #getDateAndTime!converting!private! !
!Database.DBField categoriesFor: #getDouble!converting!private! !
!Database.DBField categoriesFor: #getFloat!converting!private! !
!Database.DBField categoriesFor: #getGuid!converting!private! !
!Database.DBField categoriesFor: #getInt64!converting!private! !
!Database.DBField categoriesFor: #getLong!converting!private! !
!Database.DBField categoriesFor: #getShort!converting!private! !
!Database.DBField categoriesFor: #getTime!converting!private! !
!Database.DBField categoriesFor: #getUtf16String!converting!private! !
!Database.DBField categoriesFor: #hash!comparing!public! !
!Database.DBField categoriesFor: #initializeForColumn:!accessing!private! !
!Database.DBField categoriesFor: #isNull!public!testing! !
!Database.DBField categoriesFor: #lengthBuf!accessing!private! !
!Database.DBField categoriesFor: #numberFromNumeric!converting!private! !
!Database.DBField categoriesFor: #numberToNumeric:!converting!private! !
!Database.DBField categoriesFor: #printOn:!printing!public! !
!Database.DBField categoriesFor: #setAnsiString:!converting!private! !
!Database.DBField categoriesFor: #setBoolean:!converting!private! !
!Database.DBField categoriesFor: #setByte:!converting!private! !
!Database.DBField categoriesFor: #setByteArray:!converting!private! !
!Database.DBField categoriesFor: #setDate:!converting!private! !
!Database.DBField categoriesFor: #setDateAndTime:!converting!private! !
!Database.DBField categoriesFor: #setDouble:!converting!private! !
!Database.DBField categoriesFor: #setFloat:!converting!private! !
!Database.DBField categoriesFor: #setGuid:!converting!private! !
!Database.DBField categoriesFor: #setInt64:!converting!private! !
!Database.DBField categoriesFor: #setLong:!converting!private! !
!Database.DBField categoriesFor: #setShort:!converting!private! !
!Database.DBField categoriesFor: #setTime:!converting!private! !
!Database.DBField categoriesFor: #setUtf16String:!converting!private! !
!Database.DBField categoriesFor: #shouldTranslate:class:!accessing!private! !
!Database.DBField categoriesFor: #size!accessing!private! !
!Database.DBField categoriesFor: #value!accessing!public! !
!Database.DBField categoriesFor: #value:!accessing!public! !

!Database.DBField class methodsFor!

initialize
	"Initialize the dictionaries of to/from
	C Type/Smalltalk object converters.
		DBField initialize
	Note that the maps rely on the sequential numbering of the type enumerations.
	"

	"Note that the mappings here must match those defined for the mappings between SQL and 'C' buffer types in the DBColAttr class>>#initialize.
	Ideally these maps would just be from the SQL_C_xxx types, avoiding the need to keep in sync with the DBColAttr map, but at present the need
	to convert SQL_NUMERIC via SQL_C_CHAR prevents that."

	self assert: [TypeOffset = (SQL_GUID abs + 1)].
	self assert: [SQL_NUM_TYPES = (TypeOffset + SQL_TYPE_TIMESTAMP)].
	self addClassConstant: 'GetSelectors'
		value: ((Array new: SQL_NUM_TYPES)
				at: SQL_CHAR + TypeOffset put: #getAnsiString;
				at: SQL_VARCHAR + TypeOffset put: #getAnsiString;
				at: SQL_LONGVARCHAR + TypeOffset put: #getAnsiString;
				at: SQL_WCHAR + TypeOffset put: #getUtf16String;
				at: SQL_WVARCHAR + TypeOffset put: #getUtf16String;
				at: SQL_WLONGVARCHAR + TypeOffset put: #getUtf16String;
				at: SQL_BINARY + TypeOffset put: #getByteArray;
				at: SQL_VARBINARY + TypeOffset put: #getByteArray;
				at: SQL_LONGVARBINARY + TypeOffset put: #getByteArray;
				at: SQL_BIT + TypeOffset put: #getBoolean;
				at: SQL_TINYINT + TypeOffset put: #getByte;
				at: SQL_SMALLINT + TypeOffset put: #getShort;
				at: SQL_INTEGER + TypeOffset put: #getLong;
				at: SQL_BIGINT + TypeOffset put: #getInt64;
				at: SQL_NUMERIC + TypeOffset put: #numberFromNumeric;
				at: SQL_DECIMAL + TypeOffset put: #numberFromNumeric;
				at: SQL_FLOAT + TypeOffset put: #getDouble;
				at: SQL_REAL + TypeOffset put: #getFloat;
				at: SQL_DOUBLE + TypeOffset put: #getDouble;
				at: SQL_TYPE_DATE + TypeOffset put: #getDate;
				at: SQL_TYPE_TIME + TypeOffset put: #getTime;
				at: SQL_TYPE_TIMESTAMP + TypeOffset put: #getDateAndTime;
				at: SQL_GUID + TypeOffset put: #getGuid;
				yourself).
	self addClassConstant: 'SetSelectors'
		value: ((Array new: SQL_NUM_TYPES)
				at: SQL_CHAR + TypeOffset put: #setAnsiString:;
				at: SQL_VARCHAR + TypeOffset put: #setAnsiString:;
				at: SQL_LONGVARCHAR + TypeOffset put: #setAnsiString:;
				at: SQL_WCHAR + TypeOffset put: #setUtf16String:;
				at: SQL_WVARCHAR + TypeOffset put: #setUtf16String:;
				at: SQL_WLONGVARCHAR + TypeOffset put: #setUtf16String:;
				at: SQL_BINARY + TypeOffset put: #setByteArray:;
				at: SQL_VARBINARY + TypeOffset put: #setByteArray:;
				at: SQL_LONGVARBINARY + TypeOffset put: #setByteArray:;
				at: SQL_TINYINT + TypeOffset put: #setByte:;
				at: SQL_BIT + TypeOffset put: #setBoolean:;
				at: SQL_SMALLINT + TypeOffset put: #setShort:;
				at: SQL_INTEGER + TypeOffset put: #setLong:;
				at: SQL_BIGINT + TypeOffset put: #setInt64:;
				at: SQL_NUMERIC + TypeOffset put: #numberToNumeric:;
				at: SQL_DECIMAL + TypeOffset put: #numberToNumeric:;
				at: SQL_FLOAT + TypeOffset put: #setDouble:;
				at: SQL_REAL + TypeOffset put: #setFloat:;
				at: SQL_DOUBLE + TypeOffset put: #setDouble:;
				at: SQL_TYPE_DATE + TypeOffset put: #setDate:;
				at: SQL_TYPE_TIME + TypeOffset put: #setTime:;
				at: SQL_TYPE_TIMESTAMP + TypeOffset put: #setDateAndTime:;
				at: SQL_GUID + TypeOffset put: #setGuid:;
				yourself)!

new
	"Use #newForCol:"

	^self shouldNotImplement!

newForCol: aDBColAttr
	"Answer a new instance of the receiver for the column described by aColAttr."

	^super new initializeForColumn: aDBColAttr! !
!Database.DBField class categoriesFor: #initialize!initializing!public! !
!Database.DBField class categoriesFor: #new!instance creation!public! !
!Database.DBField class categoriesFor: #newForCol:!instance creation!public! !

