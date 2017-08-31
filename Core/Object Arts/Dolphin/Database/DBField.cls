"Filed out from Dolphin Smalltalk 7"!

Object subclass: #DBField
	instanceVariableNames: 'column buffer lengthBuf'
	classVariableNames: 'GetSelectors SetSelectors'
	poolDictionaries: 'ODBCConstants ODBCCTypes ODBCRetCodes ODBCTypes'
	classInstanceVariableNames: ''!
DBField guid: (GUID fromString: '{87b4c475-026e-11d3-9fd7-00a0cc3e4a32}')!
DBField comment: 'A DBField instance represents a column buffer for holding data as part of a DBRow.

A field''s value may be converted to a Smalltalk object by sending #value, and conversely may be assigned with #value:.

Instance Variables:
	column		<DBColAttr>. Metadata about the column
	buffer		<ByteArray>. Buffer to hold column data.
	lengthBuf		<SDWORD>. 32-bit integer buffer to hold column data length.

Class Variables:
	GetSelectors	<Array> of <Symbol>. Maps integer type codes to accessor for that type.
	SetSelectors	<Array> of <Symbol>. Maps integer type codes to mutator for that type.

'!
!DBField categoriesForClass!ODBC Interface! !
!DBField methodsFor!

= comparand
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent."

	^comparand species == self species and: [
		column = comparand column and: [self value = comparand value]]!

asBoolean
	"Private - Answer the receiver's buffer as a <Boolean>."
	
	^((buffer byteAtOffset: 0) bitAt: 1) asBoolean!

asByte
	"Private - Answer the receiver's buffer as an unsigned byte."
	
	^buffer byteAtOffset: 0!

asByteArray
	"Private - Answer the receiver's buffer as a <ByteArray>."

	^buffer copyFrom: 1 to: self length!

asDate
	"Private - Answer an instance of Date representing the contents of the receiver.
	Use the services of the ODBCDATE structure to split the buffer."

	^ODBCDATE new
		bytes: buffer;
		asDate!

asDouble
	"Private - Answer the receiver's buffer as a <Float>."

	^buffer doubleAtOffset: 0!

asFloat
	"Private - Answer the receiver's buffer as a <Float> (note that a 32-bit float gets promoted to
	a 64-bit float here)."

	^buffer floatAtOffset: 0!

asGUID
	"Private - Answer the receiver's buffer as a <GUID>."

	^GUID fromBytes: buffer
!

asInt64
	"Private - Answer the 64-bit <integer> value stored in the receiver's buffer."
	
	^buffer sqwordAtOffset: 0

!

asLong
	"Private - Answer the receiver's buffer as a signed 32-bit <Integer>."
	
	^buffer sdwordAtOffset: 0!

asShort
	"Private - Answer the receiver's buffer as signed 16-bit <Integer>."
	
	^buffer swordAtOffset: 0!

asString
	"Private - Answer the receiver's buffer as a <String>."

	^buffer copyStringFrom: 1 to: self length
!

asTime
	"Private - Answer an instance of <Time> representing the buffer of the receiver.
	Use the services of the <ODBCTIME> structure to split the buffer."

	^ODBCTIME new
		bytes: buffer;
		asTime!

asTimeStamp
	"Private - Answer an instance of <TimeStamp> representing the buffer of the receiver."

	| date time year month day hour minute second fraction |
	year := buffer wordAtOffset: 0.
	month := buffer wordAtOffset: 2.
	day := buffer wordAtOffset: 4.

	date := Date
		newDay: day
		monthIndex: month
		year: year.

	hour := buffer wordAtOffset: 6.
	minute := buffer wordAtOffset: 8.
	second := buffer wordAtOffset: 10.
	fraction := buffer dwordAtOffset: 12.
	time := Time fromMilliseconds: ((hour * 60 + minute) * 60 + second) * 1000
							+ (fraction // 1000000).

	^TimeStamp date: date time: time
	
	"Use the services of the <ODBCTIMESTAMP> structure to split the buffer.

	^(ODBCTIMESTAMP fromAddress: buffer yourAddress)
		asTimeStamp"!

beNull
	"Set the receiver to be a null valued field."

	self length: SQL_NULL_DATA!

column
	^column!

fieldBuf
	"Private - Answer the address of the buffer for passing to the ODBC DLL."

	^buffer!

fieldSize
	"Private - Answer the 'C' length of the receiver's associated column (the C length includes space for the null
	terminator if the column is a string)"

	^column lengthC!

floatFromNumeric
	"Private - Answer the receiver's contents converted from a
	string NUMERIC to a Float (ODBC converts NUMERIC
	fields to strings by default)."

	| s |
	(s := self asString) isNil ifTrue: [^nil].
	^(Number fromString: s) asFloat!

floatToNumeric: aFloat
	"Private - Convert the argument to a 'C' string stored in the receiver for passing to ODBC (probably as a
	bound parameter) where a NUMERIC is expected."

	aFloat isNil
		ifTrue: [self beNull]
		ifFalse: [ | stream |	
			stream := String writeStream: 20.
			aFloat printOn: stream decimalPlaces: column scale.
			self fromString: stream contents]
!

fromBoolean: aBoolean
	"Private - Load the receiver's contents buffer with the <Boolean> argument."

	(self shouldTranslate: aBoolean class: Boolean)
		ifTrue: [
			buffer byteAtOffset: 0 put: aBoolean asParameter.
			self length: 1]!

fromByte: aNumber
	"Private - Set the receiver's buffer to an unsigned byte representation of the 
	<Number> argument."

	(self shouldTranslate: aNumber class: Number)
		ifTrue: [
			buffer byteAtOffset: 0 put: aNumber asInteger.
			self length: 1]!

fromByteArray: aByteArray
	"Private - Set the receiver's buffer from the <ByteArray> argument."

	(self shouldTranslate: aByteArray class: ByteArray)
		ifTrue: [ | byteCount |
			byteCount := aByteArray size min: buffer size.
			buffer replaceFrom: 1 to: byteCount with: aByteArray.
			self length: byteCount]!

fromDate: aDate
	"Private - Set the receiver's buffer with an <ODBCDATE> object instantiated from 
	the <Date> argument."

	(self shouldTranslate: aDate class: Date)
		ifTrue: [ | byteArray |
			byteArray := (ODBCDATE fromDate: aDate) bytes.
			buffer replaceFrom: 1 to: byteArray size with: byteArray.
			self length: byteArray size]
!

fromDouble: aNumber
	"Private - Set the receiver's double buffer with <Float> value of the 
	<Number> argument."

	(self shouldTranslate: aNumber class: Number) ifTrue: [
		buffer doubleAtOffset: 0 put: aNumber asFloat.
		self length: 8]!

fromFloat: aNumber
	"Private - Set the receiver's float buffer with the <Float> value of the 
	<Number> argument, aNumber."

	(self shouldTranslate: aNumber class: Number) ifTrue: [
		buffer floatAtOffset: 0 put: aNumber asFloat.
		self length: 4]!

fromInt64: aNumber
	"Private - Set the receiver's buffer to the 64-bit signed integer value of the argument."

	(self shouldTranslate: aNumber class: Number) 	ifTrue: [ 
		buffer sqwordAtOffset: 0 put: aNumber asInteger.
		self length: 8]!

fromLong: aNumber
	"Private - Set the receiver's buffer to a 32-bit signed integer representation of the <Integer> argument."

	(self shouldTranslate: aNumber class: Number) 	ifTrue: [ 
		buffer sdwordAtOffset: 0 put: aNumber asInteger.
		self length: 4]!

fromShort: aNumber
	"Private - Set the receiver's buffer to the 16-bit signed integer value of the argument."

	(self shouldTranslate: aNumber class: Number) 	ifTrue: [ 
		buffer swordAtOffset: 0 put: aNumber asInteger.
		self length: 2]!

fromString: aString
	"Private - Set the receiver's buffer from aString."

	(self shouldTranslate: aString class: String) ifTrue: [ 	| byteCount |
		byteCount := aString size.
		byteCount > buffer size
			ifTrue: [^self error: 'String too long. Max ', buffer size displayString, ' got ', byteCount displayString].
		buffer replaceFrom: 1 to: byteCount with: aString.
		self length: byteCount]!

fromTime: aTime
	"Private - Set the receiver's buffer with an ODBCTIME object instantiated from aTime."

	(self shouldTranslate: aTime class: Time) ifTrue: [ 	| byteArray |
		byteArray := (ODBCTIME fromTime: aTime) bytes.
		buffer replaceFrom: 1 to: byteArray size with: byteArray.
		self length: byteArray size]
!

fromTimeStamp: aTimeStamp
	"Private - Set the receiver's buffer with an ODBCTIMESTAMP object instantiated from aTimeStamp."

	(self shouldTranslate: aTimeStamp class: TimeStamp) ifTrue: [ 	| byteArray |
		byteArray := (ODBCTIMESTAMP fromTimeStamp: aTimeStamp) bytes.
		buffer replaceFrom: 1 to: byteArray size with: byteArray.
		self length: byteArray size]
!

getData: aDBStatement 
	"Private - Retrieve the receiver's associated column data from the ODBC result set
	following a fetch (into the receiver's buffer)."

	| ret |
	ret := ODBCLibrary default 
				sqlGetData: aDBStatement executedHandle
				columnNumber: column columnNumber
				targetType: SQL_C_DEFAULT
				targetValuePtr: buffer
				bufferLength: buffer size
				strLenOrIndPtr: lengthBuf.
	aDBStatement dbCheckException: ret!

hash
	"Answer whether the receiver and the <Object>, comparand, 
	are considered equivalent."

	^column hash bitXor: self value hash!

initializeForColumn: aDBColAttr
	"Private - Initialize the receiver to represent a value from
	the database column described by the <DBColAttr> argument.
	Answer the receiver."

	lengthBuf := SDWORD fromInteger: SQL_NULL_DATA.
	column := aDBColAttr.
	buffer := ByteArray new: (##(2 raisedTo: 16) min: aDBColAttr lengthC).
	^self!

isNull
	"Answer whether the receiver represents a null field."

	^self length == SQL_NULL_DATA!

length
	"Private - Answer the length of the object in the receiver's buffer"

	^lengthBuf value!

length: anInteger
	"Private - Set the length of the object in the receiver's buffer"

	lengthBuf value: anInteger!

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
				to: self length.
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

	(self shouldTranslate: aNumber class: Number) 	ifTrue: [ 
		self fromString: (aNumber asScaledDecimal: column scale) displayString]!

printOn: aStream 
	"Append the ASCII representation of the receiver to aStream."

	super printOn: aStream.
	aStream
		nextPut: $(;
		nextPutAll: column name;
		nextPut: $=;
		print: self value;
		nextPut: $)!

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

	^self isNull ifFalse: [
		self perform: (GetSelectors at: column type+TypeOffset)]!

value: anObject
	"Set the conents of the receiver from anObject"

	^anObject isNil
		ifTrue: [self beNull]
		ifFalse: [
			self
				perform: (SetSelectors at: column type + TypeOffset)
				with: anObject]! !
!DBField categoriesFor: #=!comparing!public! !
!DBField categoriesFor: #asBoolean!converting!private! !
!DBField categoriesFor: #asByte!converting!private! !
!DBField categoriesFor: #asByteArray!converting!private! !
!DBField categoriesFor: #asDate!converting!private! !
!DBField categoriesFor: #asDouble!converting!private! !
!DBField categoriesFor: #asFloat!converting!private! !
!DBField categoriesFor: #asGUID!converting!private! !
!DBField categoriesFor: #asInt64!converting!private! !
!DBField categoriesFor: #asLong!converting!private! !
!DBField categoriesFor: #asShort!converting!private! !
!DBField categoriesFor: #asString!converting!private! !
!DBField categoriesFor: #asTime!converting!private! !
!DBField categoriesFor: #asTimeStamp!converting!private! !
!DBField categoriesFor: #beNull!accessing!public! !
!DBField categoriesFor: #column!accessing!private! !
!DBField categoriesFor: #fieldBuf!accessing!private! !
!DBField categoriesFor: #fieldSize!accessing!private! !
!DBField categoriesFor: #floatFromNumeric!converting!private! !
!DBField categoriesFor: #floatToNumeric:!converting!private! !
!DBField categoriesFor: #fromBoolean:!converting!private! !
!DBField categoriesFor: #fromByte:!converting!private! !
!DBField categoriesFor: #fromByteArray:!converting!private! !
!DBField categoriesFor: #fromDate:!converting!private! !
!DBField categoriesFor: #fromDouble:!converting!private! !
!DBField categoriesFor: #fromFloat:!converting!private! !
!DBField categoriesFor: #fromInt64:!converting!private! !
!DBField categoriesFor: #fromLong:!converting!private! !
!DBField categoriesFor: #fromShort:!converting!private! !
!DBField categoriesFor: #fromString:!converting!private! !
!DBField categoriesFor: #fromTime:!converting!private! !
!DBField categoriesFor: #fromTimeStamp:!converting!private! !
!DBField categoriesFor: #getData:!accessing!private! !
!DBField categoriesFor: #hash!comparing!public! !
!DBField categoriesFor: #initializeForColumn:!accessing!private! !
!DBField categoriesFor: #isNull!public!testing! !
!DBField categoriesFor: #length!accessing!private! !
!DBField categoriesFor: #length:!accessing!private! !
!DBField categoriesFor: #lengthBuf!accessing!private! !
!DBField categoriesFor: #numberFromNumeric!converting!private! !
!DBField categoriesFor: #numberToNumeric:!converting!private! !
!DBField categoriesFor: #printOn:!printing!public! !
!DBField categoriesFor: #shouldTranslate:class:!accessing!private! !
!DBField categoriesFor: #size!accessing!private! !
!DBField categoriesFor: #value!accessing!public! !
!DBField categoriesFor: #value:!accessing!public! !

!DBField class methodsFor!

initialize
	"Initialize the dictionaries of to/from
	C Type/Smalltalk object converters.
		DBField initialize
	Note that the maps rely on the sequential numbering of the type enumerations.
	"

	self assert: [TypeOffset = (SQL_GUID abs + 1)].
	self assert: [SQL_NUM_TYPES = (TypeOffset + SQL_VARCHAR)].
	GetSelectors := (Array new: SQL_NUM_TYPES)
				at: SQL_GUID + TypeOffset put: #asGUID;
				at: SQL_WLONGVARCHAR + TypeOffset put: #asString;
				at: SQL_WVARCHAR + TypeOffset put: #asString;
				at: SQL_WCHAR + TypeOffset put: #asString;
				at: SQL_BIT + TypeOffset put: #asBoolean;
				at: SQL_TINYINT + TypeOffset put: #asByte;
				at: SQL_BIGINT + TypeOffset put: #asInt64;
				at: SQL_LONGVARBINARY + TypeOffset put: #asByteArray;
				at: SQL_VARBINARY + TypeOffset put: #asByteArray;
				at: SQL_BINARY + TypeOffset put: #asByteArray;
				at: SQL_LONGVARCHAR + TypeOffset put: #asString;
				at: SQL_CHAR + TypeOffset put: #asString;
				at: SQL_NUMERIC + TypeOffset put: #numberFromNumeric;
				at: SQL_DECIMAL + TypeOffset put: #numberFromNumeric;
				at: SQL_INTEGER + TypeOffset put: #asLong;
				at: SQL_SMALLINT + TypeOffset put: #asShort;
				at: SQL_FLOAT + TypeOffset put: #asDouble;
				at: SQL_REAL + TypeOffset put: #asFloat;
				at: SQL_DOUBLE + TypeOffset put: #asDouble;
				at: SQL_DATE + TypeOffset put: #asDate;
				at: SQL_TIME + TypeOffset put: #asTime;
				at: SQL_TIMESTAMP + TypeOffset put: #asTimeStamp;
				at: SQL_VARCHAR + TypeOffset put: #asString;
				yourself.
	SetSelectors := (Array new: SQL_NUM_TYPES)
				at: SQL_CHAR + TypeOffset put: #fromString:;
				at: SQL_NUMERIC + TypeOffset put: #numberToNumeric:;
				at: SQL_DECIMAL + TypeOffset put: #numberToNumeric:;
				at: SQL_INTEGER + TypeOffset put: #fromLong:;
				at: SQL_SMALLINT + TypeOffset put: #fromShort:;
				at: SQL_FLOAT + TypeOffset put: #fromDouble:;
				at: SQL_REAL + TypeOffset put: #fromFloat:;
				at: SQL_DOUBLE + TypeOffset put: #fromDouble:;
				at: SQL_DATE + TypeOffset put: #fromDate:;
				at: SQL_TIME + TypeOffset put: #fromTime:;
				at: SQL_TIMESTAMP + TypeOffset put: #fromTimeStamp:;
				at: SQL_VARCHAR + TypeOffset put: #fromString:;
				at: SQL_LONGVARCHAR + TypeOffset put: #fromString:;
				at: SQL_BINARY + TypeOffset put: #fromByteArray:;
				at: SQL_VARBINARY + TypeOffset put: #fromByteArray:;
				at: SQL_LONGVARBINARY + TypeOffset put: #fromByteArray:;
				at: SQL_BIGINT + TypeOffset put: #fromInt64:;
				at: SQL_TINYINT + TypeOffset put: #fromByte:;
				at: SQL_BIT + TypeOffset put: #fromBoolean:;
				at: SQL_WCHAR + TypeOffset put: #fromString:;
				at: SQL_WVARCHAR + TypeOffset put: #fromString:;
				at: SQL_WLONGVARCHAR + TypeOffset put: #fromString:;
				at: SQL_GUID + TypeOffset put: #fromGUID;
				yourself!

new
	"Use #newForCol:"

	^self shouldNotImplement!

newForCol: aDBColAttr
	"Answer a new instance of the receiver for the column described by aColAttr."

	^super new initializeForColumn: aDBColAttr! !
!DBField class categoriesFor: #initialize!initializing!public! !
!DBField class categoriesFor: #new!instance creation!public! !
!DBField class categoriesFor: #newForCol:!instance creation!public! !

