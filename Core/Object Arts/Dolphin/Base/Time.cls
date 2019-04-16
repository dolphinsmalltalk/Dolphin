"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #Time
	instanceVariableNames: 'milliseconds'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Time guid: (GUID fromString: '{87b4c655-026e-11d3-9fd7-00a0cc3e4a32}')!
Time comment: '`Time` is the class whose instances represent a time of day as the number of seconds since midnight with millisecond precision.'!
!Time categoriesForClass!Magnitude-General! !
!Time methodsFor!

< aTime
	"Answer whether the receiver precedes (assuming the same date) the argument, aTime."

	^self asMilliseconds < aTime asMilliseconds!

= aTime
	"Answer whether the receiver represent the same time of day as the argument, aTime."

	^self species == aTime species and: [ self asMilliseconds = aTime asMilliseconds ]!

addTime: aTimeOrDate
	"Answer a new Time, aTimeOrDate after the receiver."

	^self class fromMilliseconds: self asMilliseconds + aTimeOrDate asMilliseconds!

asDateAndTime
	"Answer a new <DateAndTime> representing the the same local time as the receiver on the current day."
	
	^DateAndTime fromDate: Date today time: self!

asMilliseconds
	"Answer the number of milliseconds since midnight represented by the receiver."

	^milliseconds!

asParameter
	"Answer the host system representation of the receiver."

	^SYSTEMTIME new
		wHour: self hour24;
		wMinute: self minute;
		wSecond: self second;
		yourself!

asSeconds
	"Answer the number of seconds since midnight represented by the receiver."

	^milliseconds // 1000
!

displayOn: aStream
	"Append to the <puttableStream> argument, aStream, a String whose characters are a representation of this<Time> that a user in the current<Locale> might expect to see."

	Locale default displayTime: self on: aStream!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self asMilliseconds hash!

hour
	"Answer the hour of the day represented by the receiver (24 hour clock)"

	^self hour24
!

hour12
	"Answer the hour of the day represented by the receiver (12 hour clock)"

	^self hour24 - 1 \\ 12 + 1
!

hour24
	"Answer the hour of the day represented by the receiver (24 hour clock)"

	^(milliseconds // ##(60*60*1000)) \\ 24
!

hours
	"Answer the hour of the day represented by the receiver (24 hour clock)"

	^self hour24!

millisecond
	"Answer the millisecond of the second of the minute of the hour of the day represented by
	the receiver."

	^milliseconds \\ 1000!

milliseconds
	"Answer the millisecond of the second of the minute of the hour of the day represented by
	the receiver."

	^self millisecond!

minute
	"Answer the minute of the hour of the day represented by the receiver."

	^(milliseconds // ##(60*1000)) \\ 60
!

minutes
	"Answer the minute of the hour of the day represented by the receiver."

	^self minute!

printOn: aStream
	"Append, to the <puttableStream>, aStream, a string whose characters are those that a developer might expect to see for this <Time>" 

	Locale smalltalk displayTime: self on: aStream!

printOn: aStream format: aString
	"Append a short textual description of the receiver to the <puttableStream> argument, aStream. 
	The format is defined by the <readableString> argument, aString, the format characters of which are as described in Locale>>#timeFormat method.
	If the format argument is nil then the receiver is printed to the stream in the currently configured default format of the host OS."

	Locale default 
		printTime: self
		on: aStream
		format: aString!

printStringFormat: aString 
	"Answer a short textual description of the receiver. The format is defined by the <readableString> argument, aString, the format characters of which are as described in the Locale>>#timeFormat method comment.
	Settings from the default locale are used."

	| stream |
	stream := String writeStream: aString size.
	self printOn: stream format: aString.
	^stream contents!

second
	"Answer the <rational> second of the minute of the hour of the day represented by the receiver.
	Note that this is quite likely to be a <Fraction>."

	^(milliseconds / 1000) \\ 60
!

seconds
	"Answer the second of the minute of the hour of the day represented by the receiver."

	^self second!

setMilliseconds: anInteger
	"Private - Set the number of milliseconds since midnight represented by the receiver."

	milliseconds := anInteger!

storeOn: aStream 
	aStream
		display: self class;
		nextPutAll: ' fromString: '.
	self displayString printOn: aStream!

subtractTime: aTimeOrDate
	"Answer a new Time, aTimeOrDate seconds before the receiver."

	^self class fromMilliseconds: self asMilliseconds - aTimeOrDate asMilliseconds
! !
!Time categoriesFor: #<!comparing!public! !
!Time categoriesFor: #=!comparing!public! !
!Time categoriesFor: #addTime:!arithmetic!public! !
!Time categoriesFor: #asDateAndTime!converting!public! !
!Time categoriesFor: #asMilliseconds!converting!public! !
!Time categoriesFor: #asParameter!converting!public! !
!Time categoriesFor: #asSeconds!converting!public! !
!Time categoriesFor: #displayOn:!printing!public! !
!Time categoriesFor: #hash!comparing!public! !
!Time categoriesFor: #hour!accessing!public! !
!Time categoriesFor: #hour12!accessing!public! !
!Time categoriesFor: #hour24!accessing!public! !
!Time categoriesFor: #hours!accessing!public! !
!Time categoriesFor: #millisecond!accessing!public! !
!Time categoriesFor: #milliseconds!accessing!public! !
!Time categoriesFor: #minute!accessing!public! !
!Time categoriesFor: #minutes!accessing!public! !
!Time categoriesFor: #printOn:!printing!public! !
!Time categoriesFor: #printOn:format:!printing!public! !
!Time categoriesFor: #printStringFormat:!printing!public! !
!Time categoriesFor: #second!accessing!public! !
!Time categoriesFor: #seconds!accessing!public! !
!Time categoriesFor: #setMilliseconds:!accessing!private! !
!Time categoriesFor: #storeOn:!printing!public! !
!Time categoriesFor: #subtractTime:!arithmetic!public! !

!Time class methodsFor!

amMarker
	"Answer the marker used to signify AM when using 12 hour format"

	^Locale default amDesignator!

defaultFormat
	"Private - Answer a collection of the time formats for the default user locale."

	^Locale default timeFormat!

errorInvalidFormat
	"Private - Raise an error that some attempt to create an instance of the receiver failed
	because the some input was in the wrong format."

	^InvalidFormat signalWith: self!

formats
	"Private - Answer a collection of the time formats for the default user locale."

	^Locale default timeFormats!

fromDuration: aDuration 
	"Answer an instance of Time initialized from aDuration.  
	NB: 
		Any day value in aDuration is ignored
		Negative values for aDuration produce backward Times i.e.
			Time fromDuration: (Duration days: 0 hours: -1 minutes: -2 seconds: -3) answers 22:57:57"

	^self 
		fromMilliseconds: (((aDuration hours * 60 + aDuration minutes) * 60 + aDuration seconds) * 1000) 
				rounded!

fromMilliseconds: anInteger 
	"Answer a new instance of the receiver anInteger milliseconds since midnight."

	<primitive: 157>
	^self basicNew setMilliseconds: anInteger!

fromSeconds: anInteger
	"Answer a new instance of the receiver anInteger seconds since midnight."

	^self fromMilliseconds: anInteger * 1000!

fromString: aString
	"Answer an instance of the receiver constructed from the string,
	aString, using the default conversion format."

	| stream answer |
	stream := aString readStream.
	answer := self readFrom: stream.
	stream atEnd ifFalse: [^self errorInvalidFormat].
	^answer
!

fromSYSTEMTIME: aSYSTEMTIME
	"Private - Answer a new instance of the receiver instantiated from the argument,
	aWinSYSTEMTIME."

	^self fromMilliseconds: aSYSTEMTIME wHour * 60 + 
							aSYSTEMTIME wMinute * 60 + 
								aSYSTEMTIME wSecond * 1000 + 
									aSYSTEMTIME wMilliseconds!

hours: hoursInteger minutes: minutesInteger seconds: secondsInteger 
	"Answer a new instance of the receiver representing the specified 
	number of hours, minutes, and seconds since midnight."

	^self fromSeconds: hoursInteger * 3600 + (minutesInteger * 60) + secondsInteger!

microsecondClockValue
	"Answer the current value of the microsecond clock."

	<primitive: 189>
	^self primitiveFailed!

microsecondsToRun: timedBlock 
	"Answer the number of microseconds consumed by the evaluation of timedBlock
	(including the overhead)."

	| freq |
	freq := LargeInteger new64.
	(KernelLibrary default queryPerformanceFrequency: freq yourAddress) 
		ifFalse: [self error: 'performance counter not available'].
	^((self ticksToRun: timedBlock) - (self ticksToRun: [self])) * 1000000 // freq normalize!

millisecondClockValue
	"Answer the current value of the system millisecond clock."

	"Implementation Note: Primitive 174 is actually just a call to the QueryPerformanceCounter
	API which should be accurate sub-1mS (unlike GetTickCount() which is only accurate to 10mS),
	and which also does not suffer the problem of wrapping after ~49 days of uptime."

	<primitive: 174>
	^self primitiveFailed!

millisecondsToRun: timedBlock
	"Answer the number of milliseconds consumed by the evaluation of timedBlock
	(including the overhead)."

	| startTime|
	startTime := self millisecondClockValue.
	timedBlock value.
	^self millisecondClockValue - startTime
!

new
	"Answer a new instance of the receiver representing the current Time."

	^self now!

now
	"Answer a new instance of the receiver representing the current Time."

	^self fromSYSTEMTIME: SYSTEMTIME now!

pmMarker
	"Answer the marker used to signify PM when using 12 hour format"

	^Locale default pmDesignator!

readFrom: aStream
	"Answers a new instance of the receiver read from aStream according to
	aFormatStringOrNil"

	| hours minutes seconds separator am |
	minutes := 0.
	seconds := 0.
	hours := Integer readFrom: aStream radix: 10.
	(hours between: 0 and: 23) ifFalse: [^self errorInvalidFormat].
	separator := aStream peek.
	(separator isNil or: [separator isLetter])
		ifFalse: 
			[aStream next.
			minutes := Integer readFrom: aStream radix: 10.
			(minutes between: 0 and: 59) ifFalse: [^self errorInvalidFormat].
			(aStream peekFor: separator)
				ifTrue: 
					[seconds := Integer readFrom: aStream radix: 10.
					(seconds between: 0 and: 59) ifFalse: [^self errorInvalidFormat].
					"Historically we have allowed a separate fourth component to specify milliseconds, so for backwards compat continue to read this, although the preferred format is fractional seconds"
					(aStream peekFor: separator)
						ifTrue: 
							[| milliseconds |
							milliseconds := Integer readFrom: aStream radix: 10.
							(milliseconds between: 0 and: 999) ifFalse: [^self errorInvalidFormat].
							seconds := seconds + (milliseconds / 1000)]
						ifFalse: 
							["We read the fraction part of the seconds separately as an Integer in order to avoid an rounding error that might arise should we read the whole as a Float."
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
									seconds := seconds + (ff / digits exp10)]]]].
	aStream skipWhile: [:c | c == $\x20].
	am := self amMarker.
	(am notEmpty and: [am skipOver: aStream ignoreCase: true])
		ifTrue: 
			[((0 to: 12) includes: hours) ifFalse: [^self errorInvalidFormat].
			hours := hours % 12]
		ifFalse: 
			[| pm |
			pm := self pmMarker.
			(pm notEmpty and: [pm skipOver: aStream ignoreCase: true])
				ifTrue: 
					[(hours between: 0 and: 12) ifFalse: [^self errorInvalidFormat].
					hours < 12 ifTrue: [hours := hours + 12]]].
	^Time fromMilliseconds: ((60 * (60 * hours + minutes) + seconds) * 1000) rounded!

secondClock
	"Private - Answer the current value of the second clock (seconds since midnight)."
	
	^self now asSeconds!

ticksToRun: timedBlock 
	"Answer the number of performance counter ticks consumed by the evaluation of timedBlock
	(including the overhead)."

	| startTime endTime |
	startTime := LargeInteger new64.
	endTime := LargeInteger new64.
	KernelLibrary default queryPerformanceCounter: startTime yourAddress.
	timedBlock value.
	KernelLibrary default queryPerformanceCounter: endTime yourAddress.
	^endTime normalize - startTime normalize!

totalSeconds
	"Answer the total seconds since Jan. 1, 1901 (as an Integer) in local time."
	
	^DateAndTime now localSeconds truncated! !
!Time class categoriesFor: #amMarker!accessing!public! !
!Time class categoriesFor: #defaultFormat!enquiries!private! !
!Time class categoriesFor: #errorInvalidFormat!exceptions!private! !
!Time class categoriesFor: #formats!enquiries!private! !
!Time class categoriesFor: #fromDuration:!instance creation!public! !
!Time class categoriesFor: #fromMilliseconds:!instance creation!public! !
!Time class categoriesFor: #fromSeconds:!instance creation!public! !
!Time class categoriesFor: #fromString:!instance creation!public! !
!Time class categoriesFor: #fromSYSTEMTIME:!instance creation!private! !
!Time class categoriesFor: #hours:minutes:seconds:!instance creation!public! !
!Time class categoriesFor: #microsecondClockValue!enquiries!public! !
!Time class categoriesFor: #microsecondsToRun:!operations!public! !
!Time class categoriesFor: #millisecondClockValue!accessing!public! !
!Time class categoriesFor: #millisecondsToRun:!operations!public! !
!Time class categoriesFor: #new!instance creation!public! !
!Time class categoriesFor: #now!instance creation!public! !
!Time class categoriesFor: #pmMarker!accessing!public! !
!Time class categoriesFor: #readFrom:!instance creation!public! !
!Time class categoriesFor: #secondClock!accessing!private! !
!Time class categoriesFor: #ticksToRun:!operations!public! !
!Time class categoriesFor: #totalSeconds!accessing!public! !

