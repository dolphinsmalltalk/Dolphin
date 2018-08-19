"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #Duration
	instanceVariableNames: 'seconds'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Duration guid: (GUID fromString: '{87b4c654-026e-11d3-9fd7-00a0cc3e4a32}')!
Duration comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!Duration categoriesForClass!IDB Goodies!Magnitude-General! !
!Duration methodsFor!

- operand 
	"Answer a <Duration> whose value is the result of 
	subtracting the <Duration> operand from the receiver"

	^self class seconds: seconds - operand asSeconds!

* operand 
	"Answer a <Duration> whose value is the result of 
	multiplying the <number> operand by the receiver"

	^self class seconds: seconds * operand!

/ operand 
	"If operand is a <number> answer a new <Duration> whose value is the result of 
	dividing the receiver by operand.  If operand is a <Duration> answer a <number> 
	whose value is the result of dividing  the receiver by operand. 	If operand equals zero
	or <Duration factory> #zero the ZeroDivide exception is signaled"

	^operand divideIntoDuration: self!

+ operand 
	"Answer a <Duration> whose value is the result of 
	adding the <Duration> operand to the receiver"

	^self class seconds: seconds + operand asSeconds!

< operand 
	"Answer true if operand represents a <Duration> that is larger than the receiver"

	^seconds < operand asSeconds!

= comparand 
	"Answer true if the comparand is a <Duration> representing the 
	same length of time as the receiver"

	^self species == comparand species and: [seconds = comparand asSeconds]!

> operand 
	"Answer true if operand represents a <Duration> that is smaller than the receiver"

	^seconds > operand asSeconds!

abs
	"If the receiver is greater than or equal to <Duration Factory> #zero answer 
	a <Duration> which is equal to the receiver. Otherwise answer a <Duration> 
	which has the same magnitude as the receiver but the opposite sign"

	^self class seconds: seconds abs!

asSeconds
	"Answer the total number of seconds in the length of time represented by the receiver
	including any fractional part of a second.  If the receiver is less than <Duration factory>
	#zero then the result will be less than 0
	(idb) Always answers a Fraction or an Integer"

	^seconds!

days
	"Answer the the <integer> number of whole days represented by the receiver.
	The answer may be negative for negative durations.
	(idb) see comment in #hours"

	^seconds quo: ##(24 * 60 * 60)!

divideIntoDuration: aDuration 
	"Part of a double dispatch for <Duration> division.  Answers a <number>"

	^aDuration asSeconds / seconds!

hash
	"Answer the SmallInteger hash value for the receiver."

	^seconds hash!

hours
	"Answer an <integer> beteen -23 and 23, inclusive, which is the number 
	of whole hours represented by the receiver after complete days have been 
	removed.
	(idb) Use rem and quo rather than \\ and // to preserve sign on negative values
	-7200 \\ ##(24 * 60 * 60) --> 79200 ... wrong
	-7200 rem: ##(24 * 60 * 60) --> -7200

	(-7201 rem: ##(24 * 60 * 60)) // ##(60 * 60) --> -3 ... wrong
	(-7201 rem: ##(24 * 60 * 60)) quo: ##(60 * 60) --> -2"

	^(seconds rem: ##(24 * 60 * 60)) quo: ##(60 * 60)!

microseconds
	"Answer the number of microseconds in the fractional part of the receiver"

	^(seconds fractionPart * 1000000) rounded!

milliseconds
	"Answer the number of milliseconds in the fractional part of the receiver"

	^(seconds fractionPart * 1000) rounded!

minutes
	"Answer an <integer> beteen -59 and 59, inclusive, which is the number 
	of whole minutes represented by the receiver after complete days and hours
	have been removed.
	(idb) see comment in #hours"

	^(seconds rem: ##(60 * 60)) quo: 60!

negated
	"Answer a <Duration> of the opposite sign as the receiver."

	^self class seconds: seconds negated!

negative
	"Answer whether the receiver is negative."

	^seconds < 0!

positive
	"Answer whether the receiver is positive or zero."

	^seconds >= 0!

printOn: target 
	"Append a default string representation of the receiver to the <readableStream>,
	target. The result will be of the format: [-]D:HH:MM:SS[.S]
	(idb) Any fractional part is displayed as a Float with a maximum of 6 decimal places"

	self negative ifTrue: [target nextPut: $-].
	target
		print: self days abs;
		nextPutAll: (':%02d' sprintfWith: self hours abs);
		nextPutAll: (':%02d' sprintfWith: self minutes abs).
	target nextPut: $:.
	self seconds abs < 10 ifTrue: [target nextPut: $0].
	self seconds fractionPart isZero 
		ifTrue: [target print: self seconds abs]
		ifFalse: 
			[| s |
			s := String writeStream.
			self seconds abs asFloat printOn: s decimalPlaces: 6.
			target nextPutAll: s contents trimZeros]!

seconds
	"Answer a <number> in the range -60 < s < 60, which is the number 
	of seconds, including any fraction part, represented by the receiver after 
	complete days, hours and minutes have been removed.
	(idb) see comment in #hours"

	^seconds rem: 60!

setSeconds: aNumber 
	"Set the <number> of seconds that the receiver represents
	(idb) This will always be an Integer or Fraction - never a Float"

	seconds := aNumber! !
!Duration categoriesFor: #-!arithmetic!public! !
!Duration categoriesFor: #*!arithmetic!public! !
!Duration categoriesFor: #/!arithmetic!public! !
!Duration categoriesFor: #+!arithmetic!public! !
!Duration categoriesFor: #<!comparing!public! !
!Duration categoriesFor: #=!comparing!public! !
!Duration categoriesFor: #>!comparing!public! !
!Duration categoriesFor: #abs!arithmetic!public! !
!Duration categoriesFor: #asSeconds!converting!public! !
!Duration categoriesFor: #days!accessing!public! !
!Duration categoriesFor: #divideIntoDuration:!arithmetic!double dispatch!public! !
!Duration categoriesFor: #hash!comparing!public! !
!Duration categoriesFor: #hours!accessing!public! !
!Duration categoriesFor: #microseconds!accessing!public! !
!Duration categoriesFor: #milliseconds!accessing!public! !
!Duration categoriesFor: #minutes!accessing!public! !
!Duration categoriesFor: #negated!arithmetic!public! !
!Duration categoriesFor: #negative!public!testing! !
!Duration categoriesFor: #positive!public!testing! !
!Duration categoriesFor: #printOn:!printing!public! !
!Duration categoriesFor: #seconds!accessing!public! !
!Duration categoriesFor: #setSeconds:!instance creation!public! !

Duration methodProtocol: #Duration attributes: #(#ansi #readOnly) selectors: #(#- #* #/ #~~ #~= #+ #< #<= #= #== #> #>= #abs #asSeconds #between:and: #class #copy #days #doesNotUnderstand: #error: #hash #hours #identityHash #isKindOf: #isMemberOf: #isNil #max: #min: #minutes #negated #negative #notNil #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #positive #printOn: #printString #respondsTo: #seconds #yourself)!

!Duration class methodsFor!

days: days 
	"Answer a <Duration> representing days. If days is negative then
	answer a <Duration> less than <Duration factory>#zero"

	^self 
		days: days
		hours: 0
		minutes: 0
		seconds: 0!

days: days hours: hours minutes: minutes seconds: seconds 
	"Answer a <Duration> of the number of days, hours, minutes, and seconds. If any 
	of the operands are negative, the result is smaller by that number of days, hours, 
	minutes, or seconds as appropriate."

	^self seconds: ((days * 24 + hours) * 60 + minutes) * 60 + seconds!

errorInvalidFormat
	"Private - Raise an error that some attempt to create an instance of the receiver failed because the some input was in the wrong format."

	#DtTmX.	"2001/07/18 Harmon, R. Added for DateAndTimeExtra support."
	^InvalidFormat signalWith: self!

fromString: aString 
	"Answer an instance of the receiver constructed from aString <String> in the Reg. Ex. format: -*D:HH:MM:SS(.SS*)?."

	#DtTmX.	"2001/07/18 Harmon, R. Added for <DurationExtra factory>."
	^self readFrom: (ReadStream on: aString)!

hours: hours 
	"Answer a <Duration> representing hours. If hours is negative then
	answer a <Duration> less than <Duration factory>#zero"

	^self 
		days: 0
		hours: hours
		minutes: 0
		seconds: 0!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

minutes: minutes 
	"Answer a <Duration> representing minutes. If minutes is negative then
	answer a <Duration> less than <Duration factory>#zero"

	^self 
		days: 0
		hours: 0
		minutes: minutes
		seconds: 0!

readFrom: aStream 
	"Answers a new instance of the receiver read from aStream in the Reg. Ex. format: -*D:HH:MM:SS(.SS*)?."

	| d aHMS negative newDuration pos |
	#DtTmX.	"2001/07/18 Harmon, R. Added for <DurationExtra factory>."
	aStream skipWhile: [:c | c isWhitespace].
	negative := aStream peekFor: $-.
	pos := aStream position.
	d := Integer readFrom: aStream radix: 10.
	pos + 1 = aStream position ifFalse: [self errorInvalidFormat].
	(aStream peekFor: $:) ifFalse: [self errorInvalidFormat].
	aHMS := self readHMSFrom: aStream secondsRequired: true.
	newDuration := Duration 
				days: d
				hours: (aHMS at: 1)
				minutes: (aHMS at: 2)
				seconds: (aHMS at: 3).
	negative ifFalse: [^newDuration].
	^newDuration negated!

readHMSFrom: aStream secondsRequired: secondsRequired 
	"Private - Answers hh, mm, and ss list read from aStream <gettableStream> in the Reg. Ex. format: hh:mm:ss(.ss*)?.  Signal an error if not in specified format."

	| hh mm ss pos |
	#DtTmX.	"2001/07/18 Harmon, R. Added for DateAndTimeExtra support."
	pos := aStream position.
	hh := Integer readFrom: aStream radix: 10.
	pos + 2 = aStream position ifFalse: [self errorInvalidFormat].
	(aStream peekFor: $:) ifFalse: [self errorInvalidFormat].
	pos := aStream position.
	mm := Integer readFrom: aStream radix: 10.
	pos + 2 = aStream position ifFalse: [self errorInvalidFormat].
	(aStream peekFor: $:) 
		ifFalse: 
			[secondsRequired 
				ifTrue: [self errorInvalidFormat]
				ifFalse: 
					[^Array 
						with: hh
						with: mm
						with: 0]].
	ss := Number readFrom: aStream.
	^Array 
		with: hh
		with: mm
		with: ss!

readOffsetFrom: aStream 
	"Answers a new instance offset of the receiver read from aStream in the Reg. Ex. format: [-+]HH:MM:SS(.SS*)?."

	| negative newDuration aHMS |
	#DtTmX.	"2001/07/18 Harmon, R. Added for <DurationExtra factory>."
	negative := aStream peekFor: $-.
	negative ifFalse: [aStream peekFor: $+].
	aHMS := self readHMSFrom: aStream secondsRequired: false.
	newDuration := Duration 
				days: 0
				hours: (aHMS at: 1)
				minutes: (aHMS at: 2)
				seconds: (aHMS at: 3).
	negative ifFalse: [^newDuration].
	^newDuration negated!

seconds: seconds 
	"Answer a <Duration> which is <number> seconds in length
	If seconds is negative, answer a <Duration> that is abs (seconds) less 
	than <Duration factory> #zero.
	(idb) All numbers converted to a Fraction, Floats are rounded to 6 decimal places."

	^self new setSeconds: seconds asRestrictedFraction!

zero
	"Answer a <Duration> representing a length of no time."

	^self seconds: 0! !
!Duration class categoriesFor: #days:!instance creation!public! !
!Duration class categoriesFor: #days:hours:minutes:seconds:!instance creation!public! !
!Duration class categoriesFor: #errorInvalidFormat!exceptions!public! !
!Duration class categoriesFor: #fromString:!instance creation!public! !
!Duration class categoriesFor: #hours:!instance creation!public! !
!Duration class categoriesFor: #icon!constants!public! !
!Duration class categoriesFor: #minutes:!instance creation!public! !
!Duration class categoriesFor: #readFrom:!instance creation!public! !
!Duration class categoriesFor: #readHMSFrom:secondsRequired:!helpers!public! !
!Duration class categoriesFor: #readOffsetFrom:!instance creation!public! !
!Duration class categoriesFor: #seconds:!instance creation!public! !
!Duration class categoriesFor: #zero!instance creation!public! !

Duration class methodProtocol: #'Duration factory' attributes: #(#ansi #readOnly) selectors: #(#~~ #~= #= #== #class #copy #days:hours:minutes:seconds: #doesNotUnderstand: #error: #hash #identityHash #isKindOf: #isMemberOf: #isNil #notNil #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #printOn: #printString #respondsTo: #seconds: #yourself #zero)!

