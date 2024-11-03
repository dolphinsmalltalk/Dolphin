"Filed out from Dolphin Smalltalk"!

DBUnstructuredFieldBuffer
	subclass: #DBNumericFieldBuffer
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

DBNumericFieldBuffer guid: (Core.GUID fromString: '{719e2584-f762-4496-896a-389518c8ba75}')!

DBNumericFieldBuffer comment: ''!

!DBNumericFieldBuffer categoriesForClass!Kernel-Objects! !

!DBNumericFieldBuffer methodsFor!

dbConvert: anObject for: aDBField
	"Convert the first argument to a <ScaledDecimal> of the correct scale for for marshalling as the value of the <DBField> 2nd argument. Throw an error if this is not possible, e.g. because anObject is not a Number."

	^anObject asScaledDecimal: aDBField scale!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^SQL_C_CHAR!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with a 'C' string representation of the <Number> argument for a SQL_NUMERIC column. We use the string representation because using SQL_C_NUMERIC without losing the fractional part is convoluted and (frankly) clumsy."

	| stream |
	stream := LimitedWriteStream on: bytes limit: bytes size limitBlock: [bytes errorSubscriptBounds: bytes size + 1].
	Locale invariant displayScaledDecimal: (self dbConvert: anObject for: aDBField) on: stream.
	aDBField length: stream position!

dbUnmarshal: aDBField
	" Answer a <ScaledDecimal> equivalent to SQL_NUMERIC/SQL_DECIMAL value in the <DBField> argument's buffer, but for which we have asked for a SQL_C_CHAR representation."

	| integerPart number fractionPart scale char isNegative stream |
	stream := ReadStream
				on: bytes
				from: 1
				to: aDBField length.
	integerPart := 0.
	scale := 0.
	isNegative := stream peekFor: $-.
	[stream atEnd or: [(char := stream next) == $.]]
		whileFalse: [integerPart := integerPart * 10 + char digitValue].
	fractionPart := 0.
	[stream atEnd] whileFalse: 
			[char := stream next.
			fractionPart := fractionPart * 10 + char digitValue.
			scale := scale + 1].
	number := fractionPart / scale exp10 + integerPart.
	isNegative ifTrue: [number := number negated].
	^ScaledDecimal newFromNumber: number scale: scale!

initializeForColumn: aDBColAttr
	bytes := AnsiString newFixed: aDBColAttr length - 1!

valueClass
	^Number! !

!DBNumericFieldBuffer categoriesForMethods!
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
dbUnmarshal:!operations!public! !
initializeForColumn:!initializing!private! !
valueClass!constants!private! !
!

!DBNumericFieldBuffer class methodsFor!

dbTransferOctetLengthForColumn: aDBColAttr
	"Return the transfer octet length (size in bytes of the buffer necessary to receive data for this column) based on the column type.
	https://docs.microsoft.com/en-us/sql/odbc/reference/appendixes/transfer-octet-length: 

	SQL_DECIMAL, SQL_NUMERIC

	The number of bytes required to hold the character representation of this data if the character set is ANSI, and twice this number if the character set is UNICODE. This is the maximum number of digits plus two, because the data is returned as a character string and characters are needed for the digits, a sign, and a decimal point. For example, the transfer length of a column defined as NUMERIC(10,3) is 12.

	The maximum number of digits is specified by the column precision."

	^aDBColAttr precision + 2 + 1	"We are transferring as SQL_C_CHAR, as there is no point using UTF-16 for numbers"! !

!DBNumericFieldBuffer class categoriesForMethods!
dbTransferOctetLengthForColumn:!accessing!initializing!public! !
!

