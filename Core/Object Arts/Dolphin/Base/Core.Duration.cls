"Filed out from Dolphin Smalltalk 7"!

Core.Magnitude subclass: #'Core.Duration'
	instanceVariableNames: 'seconds'
	classVariableNames: 'Zero'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'SecondsPerDay' -> 16r15180.
		'SecondsPerHour' -> 16rE10
	}!
Core.Duration guid: (Core.GUID fromString: '{87b4c654-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Duration comment: '`Duration` is an implementation of the ANSI Smalltalk protocols `<Duration>` (instance side) and `<Duration factory>` (class side).

A `Duration` represents a length of time, at any resolution, and is independent of any start or end point. `Duration`s are immutable.

## Examples

```
	(Duration seconds: 86400) = 1 days.
	((Duration minutes: 60) - 1 hours) = Duration zero.
	(2 nanoseconds - 1 nanoseconds) printString = ''0:00:00:00.000000001''.
	DateAndTime now + 1 days.
```

*Derived from original work copyright © 2005 Ian Bartholomew, with additions by Richard Harmon.*

## Instance Variables:
  `seconds`		`<rational>` expressing the number of seconds (including any fraction of a second) that the Duration represents.

## Class Variables:
  `SecondsPerDay`		`<integer>` number of seconds in one day
  `SecondsPerHour`		`<integer>` number of seconds in one hour
  `Zero`				Constant for <Duration factory> zero

'!
!Core.Duration categoriesForClass!Kernel-Chronology! !
!Core.Duration methodsFor!

- aDuration
	"Answer a <Duration> whose value is the result of subtracting the <Duration> operand from the receiver"

	^self class seconds: seconds - aDuration asSeconds!

* aNumber
	"Answer a <Duration> whose value is the result of multiplying the <number> operand by the receiver"

	^self class seconds: seconds * aNumber!

/ aDurationOrNumber
	"If the operand is a <number> answer a new <Duration> whose value is the result of dividing the receiver by operand.  
	If operand is a <Duration> answer a <number> whose value is the result of dividing  the receiver by operand. 	
	If operand equals zero	or <Duration factory> #zero, a ZeroDivide exception is signaled"

	^aDurationOrNumber divideIntoDuration: self!

+ aDuration
	"Answer a <Duration> whose value is the result of adding the <Duration> operand to the receiver"

	^self class seconds: seconds + aDuration asSeconds!

< aDuration
	"Answer true if the operand represents a <Duration> that is larger than the receiver"

	^seconds < aDuration asSeconds!

= aDuration
	"Answer true if the comparand, aDuration, is a <Duration> representing the same length of time as the receiver"

	^self species == aDuration species and: [seconds = aDuration asSeconds]!

abs
	"If the receiver is greater than or equal to <Duration Factory> #zero answer a <Duration> which is equal to the receiver. Otherwise answer a <Duration> which has the same magnitude as the receiver but the opposite sign"

	^seconds < 0
		ifTrue: [self class seconds: seconds negated]
		ifFalse: [self]!

asMicroseconds
	"Answer the <rational> total number of microseconds in the length of time represented by the receiver including any fractional part. 
	If the receiver is less than <Duration factory> #zero then the result will be less than 0."

	^seconds * 1e6!

asMilliseconds
	"Answer the <rational> total number of milliseconds in the length of time represented by the receiver including any fractional part. 
	If the receiver is less than <Duration factory> #zero then the result will be less than 0."

	^seconds * 1000!

asNanoseconds
	"Answer the <rational> total number of nanoseconds in the length of time represented by the receiver including any fractional part.
	If the receiver is less than <Duration factory> #zero then the result will be less than 0."

	^seconds * 1e9!

asSeconds
	"Answer the <rational> total number of seconds in the length of time represented by the receiver including any fractional part of a second. 
	If the receiver is less than <Duration factory> #zero then the result will be less than 0."

	^seconds!

days
	"Answer the the <integer> number of whole days represented by the receiver.
	The answer may be negative for negative durations."

	^seconds quo: SecondsPerDay!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream locale displayDuration: self on: aPuttableStream!

divideIntoDuration: aDuration 
	"Private - Part of a double dispatch for <Duration> division.  Answers a <number>"

	^aDuration asSeconds / seconds!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^seconds hash!

hours
	"Answer an <integer> in the range [-23, 23], inclusive, which is the number of whole hours represented by the receiver after complete days have been removed."

	^(seconds rem: SecondsPerDay) quo: SecondsPerHour!

humanReadablePrintString
	"Answer an <readableString> English language description of the receiver. This is for compatibility with Pharo, although the actual printed form is different. 
	In Dolphin a <Duration> will display in the human readable form onto a <WriteStream> if it is configured for the Smalltalk <Locale>."

	^self displayString: Locale smalltalk!

isZero
	"Answer whether the receiver represents an empty interval of time."

	^seconds == 0!

microseconds
	"Answer the <rational> number of microseconds in the fractional part of the receiver. See also #asMicroseconds."

	^seconds fractionPart * 1e6!

milliseconds
	"Answer the <rational> number of milliseconds in the fractional part of the receiver. See also #asMilliseconds"

	^seconds fractionPart * 1000!

minutes
	"Answer an <integer> in the range [-59, 59], which is the number of whole minutes represented by the receiver after complete days and hours have been removed."

	^(seconds rem: SecondsPerHour) quo: 60!

nanoseconds
	"Answer the <rational> number of nanoseconds in the fractional part of the receiver. See also #asNanoseconds"

	^seconds fractionPart * 1e9!

negated
	"Answer a <Duration> of the opposite sign to the receiver."

	^self class seconds: seconds negated!

negative
	"Answer whether the receiver is negative."

	^seconds < 0!

positive
	"Answer whether the receiver is positive or zero."

	^seconds >= 0!

printHumanReadableOn: aWriteStream
	"Append a short English language description of the receiver to the <puttableStream>, aWriteStream. This is for compatibility with Pharo, although the actual printed form is different."

	Locale smalltalk displayDuration: self on: aWriteStream!

printOn: aStream
	"Append a default string representation of the receiver to the <puttableStream>, aStream.
	The result will be of the format: [-]d:hh:mm:ss[.fff] where:
		-	is a minus sign if the receiver represents an interval of time from the present into the past
		d	is the number of complete days
		hh	is the number of complete hours with leading zeroes to fill to two places
		mm	is the number of complete minutes with leading zeroes to fill to two places
		ss	is the number of complete seconds with leading zeroes to fill to two places
		fff	is the fraction part of the number of seconds, if any, displayed with up to 9 digits of precision (i.e. down to nanoseconds)."

	Locale invariant
		printDuration: self
		on: aStream
		format: '-d:hh:mm:ssfffffffff'!

printOn: aStream format: aString
	"Append a short textual description of the receiver to the <puttableStream> argument, aStream. The format is defined by the <readableString> argument, aString, the format characters of which are as described in the Locale>>durationFormat method comment."

	aStream locale
		printDuration: self
		on: aStream
		format: aString!

printStringFormat: aString
	"Answer a short textual description of the receiver. The format is defined by the <readableString> argument, aString, the format characters of which are as described in the Locale>>#durationFormat method comment.
	Settings from the default locale are used."

	| stream |
	stream := String writeStream: aString size.
	self printOn: stream format: aString.
	^stream contents!

seconds
	"Answer a <number> in the range [-59, 59], which is the number of seconds, including any fractional part, represented by the receiver after complete days, hours and minutes have been removed."

	^seconds rem: 60!

setSeconds: aNumber 
	seconds := aNumber.
	^self!

storeOn: aStream
	"Append to the <puttableStream> argument, target, an expression which when evaluated will answer a <Duration> equivalent to the receiver."

	aStream
		print: seconds;
		space;
		display: #seconds!

subtractFromDateAndTime: aDateAndTime
	"Private - Part of a double dispatch for <DateAndTime> subtraction. Answers a 
	<DateAndTime> representing the receiver subtracted from the argument"

	^aDateAndTime class utcSeconds: aDateAndTime asSeconds - seconds offset: aDateAndTime offsetSeconds! !
!Core.Duration categoriesFor: #-!arithmetic!public! !
!Core.Duration categoriesFor: #*!arithmetic!public! !
!Core.Duration categoriesFor: #/!arithmetic!public! !
!Core.Duration categoriesFor: #+!arithmetic!public! !
!Core.Duration categoriesFor: #<!comparing!public! !
!Core.Duration categoriesFor: #=!comparing!public! !
!Core.Duration categoriesFor: #abs!arithmetic!public! !
!Core.Duration categoriesFor: #asMicroseconds!converting!public! !
!Core.Duration categoriesFor: #asMilliseconds!converting!public! !
!Core.Duration categoriesFor: #asNanoseconds!converting!public! !
!Core.Duration categoriesFor: #asSeconds!converting!public! !
!Core.Duration categoriesFor: #days!accessing!public! !
!Core.Duration categoriesFor: #displayOn:!printing!public! !
!Core.Duration categoriesFor: #divideIntoDuration:!arithmetic!double dispatch!private! !
!Core.Duration categoriesFor: #hash!comparing!public! !
!Core.Duration categoriesFor: #hours!accessing!public! !
!Core.Duration categoriesFor: #humanReadablePrintString!printing!public! !
!Core.Duration categoriesFor: #isZero!public!testing! !
!Core.Duration categoriesFor: #microseconds!accessing!public! !
!Core.Duration categoriesFor: #milliseconds!accessing!public! !
!Core.Duration categoriesFor: #minutes!accessing!public! !
!Core.Duration categoriesFor: #nanoseconds!accessing!public! !
!Core.Duration categoriesFor: #negated!arithmetic!public! !
!Core.Duration categoriesFor: #negative!public!testing! !
!Core.Duration categoriesFor: #positive!public!testing! !
!Core.Duration categoriesFor: #printHumanReadableOn:!printing!public! !
!Core.Duration categoriesFor: #printOn:!printing!public! !
!Core.Duration categoriesFor: #printOn:format:!printing!public! !
!Core.Duration categoriesFor: #printStringFormat:!printing!public! !
!Core.Duration categoriesFor: #seconds!accessing!public! !
!Core.Duration categoriesFor: #setSeconds:!initializing!private! !
!Core.Duration categoriesFor: #storeOn:!printing!public! !
!Core.Duration categoriesFor: #subtractFromDateAndTime:!initializing!private! !

Core.Duration methodProtocol: #Duration attributes: #(#ansi #readOnly) selectors: #(#- #* #/ #~~ #~= #+ #< #<= #= #== #> #>= #abs #asSeconds #between:and: #class #copy #days #doesNotUnderstand: #error: #hash #hours #identityHash #isKindOf: #isMemberOf: #isNil #max: #min: #minutes #negated #negative #notNil #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #positive #printOn: #printString #respondsTo: #seconds #yourself)!

!Core.Duration class methodsFor!

days: aNumber
	"Answer a <Duration> representing the specified <number> of days.
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self seconds: aNumber * SecondsPerDay!

days: daysNumber hours: hoursNumber minutes: minutesNumber seconds: secondsNumber
	"Answer a <Duration> of the specified <number>s of days, hours, minutes, and seconds. 
	If any of the operands are negative, the result is smaller by that number of days, hours, minutes, or seconds as appropriate.
	The answer may be less than <Duration factory>#zero."

	^self seconds: ((daysNumber * 24 + hoursNumber) * 60 + minutesNumber) * 60 + secondsNumber!

errorInvalidFormat
	"Private - Raise an error that an attempt to create an instance of the receiver failed because the some input was in the wrong format."

	^InvalidFormat signalWith: self!

fromString: aString
	"Answer an instance of the receiver constructed from the <String> argument, assumed to be expressed in the same format used for the printString of the receiver's instances."

	^self readFrom: (ReadStream on: aString)!

hours: aNumber
	"Answer a <Duration> representing the specified <number> of hours. 
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self seconds: aNumber * 3600!

hours: hoursNumber minutes: minutesNumber
	"Answer a <Duration> representing the specified <number>s of hours and minutes. "

	^self seconds: (hoursNumber * 3600) + minutesNumber * 60!

hours: hoursNumber minutes: minutesNumber seconds: secondsNumber
	"Answer a <Duration> of the specified <number>s of hours, minutes, and seconds. 
	If any of the operands are negative, the result is smaller by that number of days, hours, minutes, or seconds as appropriate.
	The answer may be less than <Duration factory>#zero."

	^self seconds: (hoursNumber * 60 + minutesNumber) * 60 + secondsNumber!

microseconds: aNumber
	"Answer a <Duration> representing the specified <number> of microseconds.
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self seconds: aNumber / 1e6!

milliseconds: aNumber
	"Answer a <Duration> representing the specified <number> of milliseconds.
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self seconds: aNumber / 1000!

minutes: aNumber
	"Answer a <Duration> representing specified <number> of minutes. 
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self seconds: aNumber * 60!

nanoseconds: aNumber
	"Answer a <Duration> representing the specified <number> of nanoseconds.
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self seconds: aNumber / 1e9!

onPreStripImage
	"Private - The image is about to be stripped, clear lazily initialize class variables to assist
	the stripping process."

	Zero := nil!

readFrom: aStream
	"Answers a new instance of the receiver read from the <readableStream> argument, which is assumed to contain a duration expressed in the printString format of the receiver's instances."

	| sign |
	aStream skipSeparators.
	sign := (aStream peekFor: $-) ifTrue: [-1] ifFalse: [1].
	^self
		readFrom: aStream
		sign: sign
		withDays: true!

readFrom: aStream sign: sign withDays: aBoolean
	| mm hh ss days |
	aStream peek isDigit ifFalse: [^self errorInvalidFormat].
	aBoolean
		ifTrue: 
			[days := Integer readFrom: aStream radix: 10.
			((aStream peekFor: $:) and: [aStream peek isDigit]) ifFalse: [^self errorInvalidFormat]]
		ifFalse: [days := 0].
	hh := Integer readFrom: aStream radix: 10.
	((hh between: 0 and: 23) and: [(aStream peekFor: $:) and: [aStream peek isDigit]])
		ifFalse: [^self errorInvalidFormat].
	mm := Integer readFrom: aStream radix: 10.
	(mm between: 0 and: 59) ifFalse: [^self errorInvalidFormat].
	"We allow seconds to be optional"
	(aStream peekFor: $:)
		ifTrue: 
			[aStream peek isDigit ifFalse: [^self errorInvalidFormat].
			ss := Integer readFrom: aStream radix: 10.
			(ss between: 0 and: 59) ifFalse: [^self errorInvalidFormat].
			"We read the fraction part of the seconds separately as an Integer in order to avoid an rounding error that might arise should we read the whole as a Float."
			(aStream peekFor: $.)
				ifTrue: 
					[| ff digits ch |
					ff := 0.
					digits := 0.
					
					[ch := aStream nextAvailable.
					ch notNil and: [ch isDigit]] whileTrue: 
								[ff := ff * 10 + ch digitValue.
								digits := digits + 1].
					(digits between: 1 and: 9) ifFalse: [^self errorInvalidFormat].
					ss := ss + (ff / digits exp10)]]
		ifFalse: [ss := 0].
	^self seconds: (((days * 24 + hh) * 60 + mm) * 60 + ss) * sign!

seconds: aNumber
	"Answer a <Duration> which is the specified <number> of seconds in length. 
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self new 
		setSeconds: aNumber asFraction;
		isImmutable: true;
		yourself!

zero
	"Answer a <Duration> representing an empty interval of time."

	^Zero ifNil: [Zero := self seconds: 0]! !
!Core.Duration class categoriesFor: #days:!instance creation!public! !
!Core.Duration class categoriesFor: #days:hours:minutes:seconds:!instance creation!public! !
!Core.Duration class categoriesFor: #errorInvalidFormat!exceptions!private! !
!Core.Duration class categoriesFor: #fromString:!instance creation!public! !
!Core.Duration class categoriesFor: #hours:!instance creation!public! !
!Core.Duration class categoriesFor: #hours:minutes:!instance creation!public! !
!Core.Duration class categoriesFor: #hours:minutes:seconds:!instance creation!public! !
!Core.Duration class categoriesFor: #microseconds:!instance creation!public! !
!Core.Duration class categoriesFor: #milliseconds:!instance creation!public! !
!Core.Duration class categoriesFor: #minutes:!instance creation!public! !
!Core.Duration class categoriesFor: #nanoseconds:!instance creation!public! !
!Core.Duration class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Core.Duration class categoriesFor: #readFrom:!instance creation!public! !
!Core.Duration class categoriesFor: #readFrom:sign:withDays:!helpers!private! !
!Core.Duration class categoriesFor: #seconds:!instance creation!public! !
!Core.Duration class categoriesFor: #zero!instance creation!public! !

Core.Duration class methodProtocol: #'Duration factory' attributes: #(#ansi #readOnly) selectors: #(#~~ #~= #= #== #class #copy #days:hours:minutes:seconds: #doesNotUnderstand: #error: #hash #identityHash #isKindOf: #isMemberOf: #isNil #notNil #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #printOn: #printString #respondsTo: #seconds: #yourself #zero)!

