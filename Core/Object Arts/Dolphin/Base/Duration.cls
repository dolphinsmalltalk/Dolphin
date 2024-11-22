"Filed out from Dolphin Smalltalk"!

Magnitude subclass: #Duration
	instanceVariableNames: 'seconds'
	classVariableNames: 'SecondsPerDay SecondsPerHour Zero'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Duration guid: (GUID fromString: '{87b4c654-026e-11d3-9fd7-00a0cc3e4a32}')!

Duration addClassConstant: 'SecondsPerDay' value: 16r15180!
Duration addClassConstant: 'SecondsPerHour' value: 16rE10!

Duration comment: '`Duration` is an implementation of the ANSI Smalltalk protocols `<Duration>` (instance side) and `<Duration factory>` (class side).

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

!Duration categoriesForClass!Kernel-Chronology! !

!Duration methodsFor!

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

asDuration
	^self!

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

asString
	"Answer the ISO8601 representation of the receiver."

	| stream |
	stream := String writeStream: 22.
	self printISO8601On: stream.
	^stream contents!

asUtf16String
	"Answer the ISO8601 representation of the receiver as a UTF-16 encoded string."

	| stream |
	stream := Utf16String writeStream: 22.
	self printISO8601On: stream.
	^stream contents!

closeTo: otherDuration precision: precisionDuration
	^(self - otherDuration) abs <= precisionDuration!

days
	"Answer the the <integer> number of whole days represented by the receiver.
	The answer may be negative for negative durations."

	^seconds quo: SecondsPerDay!

displayOn: aWriteStream
	"Append,to the <puttableStream> argument, a <String> whose characters are a representation of the receiver as a user would want to see it.
	The format used is that defined by Windows for the current user locale."

	Locale default displayDuration: self on: aWriteStream!

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
	"Answer an <readableString> English language description of the receiver. This is for compatibility with Pharo, although the actual printed form is different."

	^String streamContents: [:strm | self printHumanReadableOn: strm]!

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

printISO8601On: aPuttableStream
	"Print the ISO8601 representation of the receiver onto the <puttableStream> argument."

	| element timePrefix |
	self negative
		ifTrue: 
			[aPuttableStream nextPut: $-.
			self negated printISO8601On: aPuttableStream.
			^self].
	aPuttableStream nextPut: $P.
	element := self days.
	element == 0
		ifFalse: 
			[aPuttableStream
				print: element;
				nextPut: $D].
	timePrefix := $T.
	element := self hours.
	element == 0
		ifFalse: 
			[aPuttableStream
				display: timePrefix;
				print: element;
				nextPut: $H.
			timePrefix := nil].
	element := self minutes.
	element == 0
		ifFalse: 
			[aPuttableStream
				display: timePrefix;
				print: element;
				nextPut: $M.
			timePrefix := nil].
	element := self seconds.
	(element ~~ 0 or: [seconds == 0])
		ifTrue: 
			[| fractionPart |
			aPuttableStream
				display: timePrefix;
				print: element truncated.
			fractionPart := element abs fractionPart.
			fractionPart == 0
				ifFalse: 
					[| digits count |
					"Any fractional part is truncated to 9 decimal places."
					digits := (fractionPart * 1000000000) truncated printStringBase: 10 nDigits: 9.
					count := digits size.
					[count > 1 and: [(digits at: count) = $0]] whileTrue: [count := count - 1].
					"The decimal separator can be $., or $, depending on the stream locale."
					aPuttableStream
						nextPutAll: Locale userDefault decimalSeparator;
						next: count
							putAll: digits
							startingAt: 1].
			aPuttableStream nextPut: $S]!

printOn: aStream
	"Append a default string representation of the receiver to the <puttableStream>, aStream.
	The result will be of the format: [-]d:hh:mm:ss[.fff] where:
		-	is a minus sign if the receiver represents an interval of time from the present into the past
		d	is the number of complete days
		hh	is the number of complete hours with leading zeroes to fill to two places
		mm	is the number of complete minutes with leading zeroes to fill to two places
		ss	is the number of complete seconds with leading zeroes to fill to two places
		fff	is the fraction part of the number of seconds, if any, displayed with up to 9 digits of precision (i.e. down to nanoseconds)."

	"This is an ANSI Smalltalk compliant definition. It would probably be more useful if Duration>>printOn: produced a self-evaluating form, or possibly ISO8601."

	Locale invariant
		printDuration: self
		on: aStream
		format: '-d:hh:mm:ssfffffffff'!

printOn: aStream format: aString
	"Append a short textual description of the receiver to the <puttableStream> argument, aStream. The format is defined by the <readableString> argument, aString, the format characters of which are as described in the Locale>>durationFormat method comment."

	Locale default
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

sign
	"Answer the <integer> sign of the receiver:
		1 if the receiver is greater than 0, 
		-1 if less than 0
		0 if equal to 0."

	^seconds sign!

storeOn: aStream
	"Append to the <puttableStream> argument, target, an expression which when evaluated will answer a <Duration> equivalent to the receiver."

	aStream
		print: seconds;
		space;
		display: #seconds!

subtractFromDateAndTime: aDateAndTime
	"Private - Part of a double dispatch for <DateAndTime> subtraction. Answers a 
	<DateAndTime> representing the receiver subtracted from the argument"

	^aDateAndTime class utcSeconds: aDateAndTime asSeconds - seconds offset: aDateAndTime offsetSeconds!

wait
	(Delay forDuration: self) wait! !

!Duration categoriesForMethods!
-!arithmetic!public! !
*!arithmetic!public! !
/!arithmetic!public! !
+!arithmetic!public! !
<!comparing!public! !
=!comparing!public! !
abs!arithmetic!public! !
asDuration!converting!public! !
asMicroseconds!converting!public! !
asMilliseconds!converting!public! !
asNanoseconds!converting!public! !
asSeconds!converting!public! !
asString!printing!public! !
asUtf16String!printing!public! !
closeTo:precision:!comparing!public! !
days!accessing!public! !
displayOn:!printing!public! !
divideIntoDuration:!arithmetic!double dispatch!private! !
hash!comparing!public! !
hours!accessing!public! !
humanReadablePrintString!printing!public! !
isZero!public!testing! !
microseconds!accessing!public! !
milliseconds!accessing!public! !
minutes!accessing!public! !
nanoseconds!accessing!public! !
negated!arithmetic!public! !
negative!public!testing! !
positive!public!testing! !
printHumanReadableOn:!printing!public! !
printISO8601On:!printing!public! !
printOn:!printing!public! !
printOn:format:!printing!public! !
printStringFormat:!printing!public! !
seconds!accessing!public! !
setSeconds:!initializing!private! !
sign!accessing!public! !
storeOn:!printing!public! !
subtractFromDateAndTime:!initializing!private! !
wait!process synchronisation!public! !
!

Duration methodProtocol: #Duration attributes: #(#ansi #readOnly) selectors: #(#- #* #/ #~~ #~= #+ #< #<= #= #== #> #>= #abs #asSeconds #between:and: #class #copy #days #doesNotUnderstand: #error: #hash #hours #identityHash #isKindOf: #isMemberOf: #isNil #max: #min: #minutes #negated #negative #notNil #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #positive #printOn: #printString #respondsTo: #seconds #yourself)!

!Duration class methodsFor!

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

	| stream instance|
	stream := ReadStream on: aString.
	instance := self readFrom: stream.
	stream atEnd ifFalse: [self errorInvalidFormat].
	^instance!

hours: aNumber
	"Answer a <Duration> representing the specified <number> of hours. 
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self seconds: aNumber * 3600!

hours: hoursNumber minutes: minutesNumber
	"Answer a <Duration> representing the specified <number>s of hours and minutes. "

	^self seconds: (hoursNumber * 60 + minutesNumber) * 60!

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

minutes: minutesNumber seconds: secondsNumber
	"Answer a <Duration> representing specified <number> of minutes and seconds."

	^self seconds: minutesNumber * 60 + secondsNumber!

nanoseconds: aNumber
	"Answer a <Duration> representing the specified <number> of nanoseconds.
	If the argument is negative then the answer will be less than <Duration factory>#zero."

	^self seconds: aNumber / 1e9!

onPreStripImage
	"Private - The image is about to be stripped, clear lazily initialize class variables to assist
	the stripping process."

	Zero := nil!

readFrom: aStream
	"Answers a new instance of the receiver read from the <readableStream> argument, which is assumed to contain a duration expressed in either the ANSI standard printString format of the receiver's instances, or in ISO8601 'P' (period) format."

	| sign |
	aStream skipSeparators.
	sign := (aStream peekFor: $-) ifTrue: [-1] ifFalse: [1].
	^(aStream peekFor: $P)
		ifTrue: 
			[self
				readISO8601From: aStream
				sign: sign
				ifInvalid: [self errorInvalidFormat]]
		ifFalse: 
			[self
				readFrom: aStream
				sign: sign
				withDays: true
				ifInvalid: [self errorInvalidFormat]]!

readFrom: aStream sign: sign withDays: aBoolean ifInvalid: aNiladicValuable
	| ch mm hh ss days |
	ch := aStream peek.
	ch = $P ifTrue: [].
	ch isDigit ifFalse: [^aNiladicValuable value].
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
			(ss between: 0 and: 59) ifFalse: [^aNiladicValuable value].
			"We read the fraction part of the seconds separately as an Integer in order to avoid any rounding error that might arise should we read the whole as a Float."
			(aStream peekFor: $.)
				ifTrue: 
					[| ff digits  |
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

readISO8601ElementMagnitudeFrom: aStream
	| pos fractionPart ch number |
	number := self readUnsignedIntegerFrom: aStream.
	number ifNil: [^nil].
	ch := aStream peek ifNil: [^number].
	(ch == $. or: [ch == $,])
		ifTrue: 
			[| scale |
			pos := aStream
						next;
						position.
			fractionPart := self readUnsignedIntegerFrom: aStream.
			scale := aStream position - pos.
			scale == 0
				ifTrue: 
					[aStream pop.
					^nil].
			number := number + (fractionPart / scale exp10).
			number == 0 ifTrue: [number := 0.0]].
	^number!

readISO8601From: aStream sign: sign ifInvalid: aNiladicValuable
	"Read up to the end of the next valid ISO8601 days-to-seconds period in the <gettableStream> of <Character>, aStream. If there is no complete valid period beginning at the head of the stream, raise an InvalidFormat error. The stream is left positioned on the first character after the ISO8601 period, or at end of stream if there is no more data. For a description of ISO8601 Period/Durations see https://en.wikipedia.org/wiki/ISO_8601. Note that periods with years and months are not supported as these cannot be represented correctly with <Duration>s."

	| ch seconds element qualifier elementTypes seenFraction |
	(aStream peekFor: $T)
		ifTrue: [seconds := 0]
		ifFalse: 
			[element := self readISO8601ElementMagnitudeFrom: aStream.
			element ifNil: [^aNiladicValuable value].
			aStream nextAvailable == $D ifFalse: [^aNiladicValuable value].
			(aStream peekFor: $T) ifFalse: [^self days: element * sign].
			"Can't have any time elements after a fractional number of days as only the smallest element can have a fraction"
			element isInteger ifFalse: [^aNiladicValuable value].
			seconds := element * 24].
	"Read the remaining elements, hours to seconds. Any or all may be missing, but if present they must be in sequence. There be at least one element after a T"
	element := self readISO8601ElementMagnitudeFrom: aStream.
	element ifNil: [^aNiladicValuable value].
	ch := aStream nextAvailable.
	ch ifNil: [^aNiladicValuable value].
	seenFraction := element isInteger not.
	elementTypes := #($H 60 $M 60 $S 1) readStream.
	
	[
	[qualifier := elementTypes nextAvailable.
	qualifier ifNil: [^aNiladicValuable value].
	ch == qualifier]
			whileFalse: [seconds := seconds * elementTypes next].
	seconds := (seconds + element) * elementTypes next.
	elementTypes atEnd or: [aStream atEnd]]
			whileFalse: 
				["Can't be another element after a fractional one"
				seenFraction ifTrue: [^aNiladicValuable value].
				element := self readISO8601ElementMagnitudeFrom: aStream.
				element ifNil: [^aNiladicValuable value].
				seenFraction := element isInteger not.
				ch := aStream nextAvailable.
				ch ifNil: [^aNiladicValuable value]].

	"If reached the end of the input, but not the element types, multiply up into seconds."
	[elementTypes nextAvailable isNil] whileFalse: [seconds := seconds * elementTypes next].
	^self seconds: seconds * sign!

readUnsignedIntegerFrom: aStream
	| value char |
	value := 0.
	[(char := aStream nextAvailable) isNil] whileFalse: 
			[| digit |
			((digit := char digitValue) < 10 and: [digit >= 0])
				ifTrue: [value := value * 10 + digit]
				ifFalse: 
					[aStream pop.
					^value]].
	^value!

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

!Duration class categoriesForMethods!
days:!instance creation!public! !
days:hours:minutes:seconds:!instance creation!public! !
errorInvalidFormat!exceptions!private! !
fromString:!instance creation!public! !
hours:!instance creation!public! !
hours:minutes:!instance creation!public! !
hours:minutes:seconds:!instance creation!public! !
microseconds:!instance creation!public! !
milliseconds:!instance creation!public! !
minutes:!instance creation!public! !
minutes:seconds:!instance creation!public! !
nanoseconds:!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
readFrom:!instance creation!public! !
readFrom:sign:withDays:ifInvalid:!helpers!private! !
readISO8601ElementMagnitudeFrom:!helpers!private! !
readISO8601From:sign:ifInvalid:!helpers!private! !
readUnsignedIntegerFrom:!helpers!private! !
seconds:!instance creation!public! !
zero!instance creation!public! !
!

Duration class methodProtocol: #'Duration factory' attributes: #(#ansi #readOnly) selectors: #(#~~ #~= #= #== #class #copy #days:hours:minutes:seconds: #doesNotUnderstand: #error: #hash #identityHash #isKindOf: #isMemberOf: #isNil #notNil #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #printOn: #printString #respondsTo: #seconds: #yourself #zero)!

