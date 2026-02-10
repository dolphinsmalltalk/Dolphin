"Filed out from Dolphin Smalltalk"!

External.DOUBLE
	subclass: #'OS.COM.DATE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.OleVariant private})
	classInstanceVariableNames: ''
	classConstants: {
			'EpochRD' -> 16rA955A.
			'LowerBound' -> -16rA081B.
			'MaxValue' -> 2.9584659999999995e6.
			'MaxYear' -> 16r270F.
			'MinValue' -> -657434.9999942129.
			'MinYear' -> 16r64.
			'UpperBound' -> 16r2D2482
		}!

OS.COM.DATE guid: (Core.GUID fromString: '{c06f3b6d-0868-11d3-93af-00a024ca708a}')!

OS.COM.DATE comment: '`DATE` is an `External.SCALAR` class to represent the OLE Automation variant date/time format.

`DATE`s describe moments in time using a double-precision floating point number where the integer part is used for a day number offset from 30th December 1899, and the fractional part represents the time of day as a fraction of 86400 (the number of seconds in a day). The time fraction is always considered positive, even if the day number is negative.

`DATE`s are marshalled to/from Smalltalk `DateAndTime` objects. `DateAndTime` can represent any `DATE` precisely, but the reverse is not true. `DateAndTime` has infinite range and precision, so attempting to marshal a `DateAndTime` may throw an exception if the moment cannot be represented as a `DATE`, or may result in loss of precision. Many APIs that handle `DATE`s will discard or round fractional seconds, so it is best to assume that sub-second moments will be represented only approximately.'!

!OS.COM.DATE categoriesForClass!External-Data-Structured! !

!OS.COM.DATE methodsFor!

asDATE
	"Answer the OLE Automation <DATE> that is the nearest equivalent of the receiver."

	^self!

asDateAndTime
	"Answer a <DateAndTime> converted from the receiver's Active-X Automation date (an 8-byte floating point day number and fraction of a day), which is assumed to in the local time."

	^DateAndTime fromDATE: self!

asFloat
	^bytes doubleAtOffset: _OffsetOf_value!

asString
	| stream |
	stream := Locale invariant writeStream: 19.
	self displayOn: stream.
	^stream grabContents!

asSYSTEMTIME
	"Answer a <SYSTEMTIME> representing approximately the same moment as the receiver. Note that any fractional seconds are rounded, so the result may lose precision."

	^SYSTEMTIME fromDATE: self!

displayOn: aPuttableStream
	aPuttableStream locale
		displayDATE: self
		on: aPuttableStream!

printOn: aStream
	self basicPrintOn: aStream.
	aStream nextPut: $(.
	Locale invariant displayDATE: self on: aStream.
	aStream nextPut: $)!

value
	"Answer a <DateAndTime> equivalent to the the receiver's Active-X Automation date (an 8-byte floating point day number and fraction of a day)."

	^self asDateAndTime!

value: anObject
	"Set the receiver's ole date value to the nearest equivalent of the argument, assumed to be some supported date/time representation, e.g. a <DateAndTime>."

	| oledate |
	oledate := anObject.
	(oledate > LowerBound and: [oledate < UpperBound])
		ifFalse: [InvalidArgumentError signal: 'Out of representable range of DATEs' with: 'anObject'].
	bytes doubleAtOffset: _OffsetOf_value put: oledate! !

!OS.COM.DATE categoriesForMethods!
asDATE!converting!public! !
asDateAndTime!converting!public! !
asFloat!converting!public! !
asString!converting!public! !
asSYSTEMTIME!accessing!public! !
displayOn:!displaying!public! !
printOn:!printing!public! !
value!accessing!public! !
value:!**compiled accessors**!public! !
!

!OS.COM.DATE class methodsFor!

arrayType
	"Answer the class of object (typically an <ExternalArray> subclass) to be used to represent arrays of the receiver's field type in other structures."

	^DATEArray!

fromFloat: aFloat
	^self new
		value: aFloat;
		yourself!

fromString: aString
	"Answer a new instance of the receiver parsed from the <String> argument, which is assumed to represent the printed representation of a variant date/time in the format used in the user's default locale.

		self fromString: '3 February 1995'.
	"

	^self fromString: aString locale: Locale userDefault!

fromString: aString locale: aLocale
	"Answer a new instance of the receiver parsed from the <String> 1st argument, which is assumed to represent the printed representation of a variant date/time in the format used in <Locale> 2nd argument."

	^aLocale parseDATE: aString!

icon
	"Answer a suitable iconic representation for the receiver."

	^DateAndTime icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	| upperBound lowerBound min |
	VM registryAt: self name put: self.
	"The upper bounds is the day number for 10000-01-01, since the maximum representable moment is between 9999-12-31T23:59:59 and the start of the next day."
	upperBound := 2958466.
	self addClassConstant: 'UpperBound' value: upperBound.
	"The maximum DATE is one ULP below the upper bound"
	self addClassConstant: 'MaxValue' value: (upperBound asFloat bitRepresentation - 1 becomeA: Float).
	"The lower bound is the day number for 100-01-01"
	lowerBound := -657435.
	"DATE always stores the fraction of the day as a positive value, even for negative dates, so the minimum DATE (which is negative) has a larger numeric value than the minimum representable value. The minimum representation value describes the end of the minimum day, which is a later moment in time. Also, the floating point representation has insufficient precision to describe the end of the day even to millisecond accuracy, but the related APIs tend to round to seconds suggesting that sub-second accuracy is not expected."
	self addClassConstant: 'LowerBound' value: lowerBound.
	"Any value that is at most half a second away from the end of the first day will be rounded by APIs such as VariantTimeToSystemTime to the next later day, so the minimum DATE value (not moment) is one ULP smaller than this."
	min := (lowerBound + 1.0 - ((Duration.SecondsPerDay - 0.5) / Duration.SecondsPerDay))
				bitRepresentation - 1
				becomeA: Float.
	self addClassConstant: 'MinValue' value: min!

marshal: anObject
	^anObject asDATE!

maximum
	^(self new)
		value: MaxValue;
		yourself!

minimum
	"The minimum value is the largest valid negative value, not the minimum date (because the fractional part is always treated as a positive offset)."

	^self new
		value: LowerBound + 1;
		yourself!

now
	"Answer the current date and time as an instance of the receiver."

	^DateAndTime now asDATE!

typeName
	"Private - Answer the Dolphin external type name for the receiver.
	There is an appropriate built-in type which we can substitute."

	^#date!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil!

variantVectorName
	"Private - Answer the symbolic name of the accessor for a variant holding a vector of the receiver's element type."

	^#dateVector!

vt
	"Answer the VARTYPE (one of the VT_XXX constants) used to describe the receiver's 
	type when represented in a <VARIANT>."

	^VT_DATE! !

!OS.COM.DATE class categoriesForMethods!
arrayType!constants!public! !
fromFloat:!instance creation!public! !
fromString:!instance creation!public! !
fromString:locale:!instance creation!public! !
icon!constants!public! !
initialize!development!initializing!private! !
marshal:!instance creation!public! !
maximum!constants!public! !
minimum!constants!public! !
now!instance creation!public! !
typeName!constants!private! !
uninitialize!class hierarchy-removing!private! !
variantVectorName!constants!private! !
vt!constants!public! !
!

