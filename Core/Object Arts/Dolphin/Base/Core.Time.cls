"Filed out from Dolphin Smalltalk"!

Core.Magnitude
	subclass: #'Core.Time'
	instanceVariableNames: 'seconds'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Time guid: (Core.GUID fromString: '{87b4c655-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Time comment: '`Time` is the class whose instances represent a time of day as the number of seconds since midnight with infinite precision.

Time is a legacy Smalltalk class that represents only a time of day, without any awareness of timezone offset. They are generally assumed to represent a local time. For most purposes you will want to use a `DateAndTime` instead.'!

!Core.Time categoriesForClass!Magnitude-General! !

!Core.Time methodsFor!

< aTime
	"Answer whether the receiver precedes (assuming the same date and timezone) the <Time> argument."

	^self asSeconds < aTime asSeconds!

= aTime
	"Answer whether the receiver represent the same time of day as the argument, aTime."

	^self species == aTime species and: [seconds = aTime seconds]!

addTime: aTimeOrDate
	"Answer a new Time, aTimeOrDate after the receiver."

	^self class fromSeconds: self seconds + aTimeOrDate seconds!

asDateAndTime
	"Answer a new <DateAndTime> representing the same local time as the receiver on the current day."

	^DateAndTime today + self!

asMilliseconds
	"Answer the <number> of milliseconds since midnight represented by the receiver."

	^seconds * 1000!

asParameter
	"Answer the host system representation of the receiver."

	^self asSYSTEMTIME!

asSeconds
	"Answer the <number> of seconds since midnight represented by the receiver."

	^seconds
!

asSYSTEMTIME
	"Answer a <SYSTEMTIME> representing the same time as the receiver on the current date."

	^Date today asSYSTEMTIME
		wHour: self hour24;
		wMinute: self minute;
		wSecond: self second truncated;
		wMilliseconds: self millisecond truncated;
		yourself!

asTime
	^self!

asTimeStamp
	^self asDateAndTime asTimeStamp!

closeTo: aTime precision: aDuration
	^(seconds - aTime seconds) abs <= aDuration!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream locale displayTime: self on: aPuttableStream!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self asMilliseconds hash!

hour
	"Answer an <integer> in the range [0, 24), representing the hour of the day in the local time of the receiver."

	^self hour24!

hour12
	"Answer an <integer> in the range [1, 12], representing the hour of the day in the 12-hour clock of the local time of the receiver."

	^self hour24 - 1 \\ 12 + 1!

hour24
	"Answer an <integer> in the range [0, 24), representing the hour of the day in the 24-hour clock of the local time of the receiver."

	^seconds // Duration.SecondsPerHour!

millisecond
	"Answer a <rational> in the range [0, 1000), representing the millisecond of the second of the local time of the receiver, including any fractional part."

	^seconds fractionPart * 1000!

minute
	"Answer an <integer> in the range [0,60), representing the minute of the hour in the local time of the receiver."

	^seconds // 60 \\ 60!

nanosecond
	"Answer a <rational> in the range [0,1000000000), representing the nanosecond of the second of the local time of the receiver, including any fractional part."

	^seconds fractionPart * 1e9!

print24: hr24Boolean showSeconds: secsBoolean on: aWriteStream
	| format |
	format := hr24Boolean ifTrue: ['HH:mm'] ifFalse: ['hh:mm'].
	secsBoolean ifTrue: [format := format , ':ssfffffffff'].
	^Locale smalltalk
		printTime: self
		on: aWriteStream
		format: format!

printOn: aStream
	"Append, to the <puttableStream>, aStream, a string whose characters are those that a developer might expect to see for this <Time>"

	Locale smalltalk displayTime: self on: aStream!

printOn: aStream format: aString
	"Append a short textual description of the receiver to the <puttableStream> argument, aStream. 
	The format is defined by the <readableString> argument, aString, the format characters of which are as described in Locale>>#timeFormat method.
	If the format argument is nil then the receiver is printed to the stream in the currently configured default format of the stream's <Locale>."

	aStream locale
		printTime: self
		on: aStream
		format: aString!

printStringFormat: aString
	"Answer a short textual description of the receiver. The format is defined by the <readableString> argument, aString, the format characters of which are as described in the Locale>>#timeFormat method comment.
	Settings from the default locale are used."

	| stream |
	stream := String writeStream: aString size.
	self printOn: stream format: aString.
	^stream grabContents!

second
	"Answer a <rational> in the range [0, 60), representing the second of the minute of the local time of the receiver, including any fractional part."

	^seconds \\ 60
!

seconds
	"Answer the <number> of seconds past midnight in the local time of the receiver."

	^seconds!

seconds: aNumber
	seconds := aNumber!

storeOn: aStream
	"Append to the <puttableStream> argument, target, an expression which when evaluated will answer a <Time> equivalent to the receiver."

	aStream
		nextPut: $(;
		print: self class;
		nextPutAll: ' fromSeconds: ';
		print: self asSeconds;
		nextPut: $)!

subtractTime: aTimeOrDate
	"Answer a new Time, aTimeOrDate seconds before the receiver."

	^self class fromSeconds: self seconds - aTimeOrDate seconds! !

!Core.Time categoriesForMethods!
<!comparing!public! !
=!comparing!public! !
addTime:!arithmetic!public! !
asDateAndTime!converting!public! !
asMilliseconds!converting!public! !
asParameter!converting!public! !
asSeconds!converting!public! !
asSYSTEMTIME!converting!public! !
asTime!converting!public! !
asTimeStamp!converting!public! !
closeTo:precision:!comparing!public! !
displayOn:!printing!public! !
hash!comparing!public! !
hour!accessing!public! !
hour12!accessing!public! !
hour24!accessing!public! !
millisecond!accessing!public! !
minute!accessing!public! !
nanosecond!accessing!public! !
print24:showSeconds:on:!public!ston! !
printOn:!printing!public! !
printOn:format:!printing!public! !
printStringFormat:!printing!public! !
second!accessing!public! !
seconds!accessing!public! !
seconds:!accessing!private! !
storeOn:!printing!public! !
subtractTime:!arithmetic!public! !
!

Core.Time methodProtocol: #time attributes: #(#readOnly) selectors: #(#asSeconds #hour12 #hour24 #minute #second)!

!Core.Time class methodsFor!

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
		Any day value in aDuration is (effectively) ignored
		Negative values for aDuration produce backward Times i.e.
			Time fromDuration: (Duration days: 0 hours: -1 minutes: -2 seconds: -3) answers 22:57:57"

	^self fromSeconds: aDuration asSeconds!

fromMilliseconds: aNumber 
	"Answer a new instance of the receiver aNumber milliseconds relative to midnight."

	^self fromSeconds: aNumber / 1000!

fromSeconds: aNumber
	"Answer a new instance of the receiver representing specified <number> of seconds relative to midnight. 
	If aNumber is positive, then the <Time> is that number of seconds forward of midnight. 
	If aNumber is negative, then the <Time> is that number of seconds before midnight."

	^self basicNew seconds: aNumber asTrueFraction \\ Duration.SecondsPerDay!

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
	"Private - Answer a new instance of the receiver instantiated from the argument, aSYSTEMTIME."

	^self fromSeconds: (aSYSTEMTIME wHour * 60 + aSYSTEMTIME wMinute) * 60 + aSYSTEMTIME wSecond
				+ (aSYSTEMTIME wMilliseconds / 1000)!

hours: hoursInteger minutes: minutesInteger seconds: secondsInteger
	"Answer a new instance of the receiver representing the specified 
	number of hours, minutes, and seconds since midnight."

	^self fromSeconds: (hoursInteger * 60 + minutesInteger) * 60 + secondsInteger!

microsecondClockValue
	"Answer the current value of the microsecond clock."

	^Delay microsecondClockValue!

millisecondClockValue
	"Answer the current value of the system millisecond clock."

	^Delay millisecondClockValue!

millisecondsToRun: timedBlock
	"Answer the number of milliseconds consumed by the evaluation of timedBlock
	(including the overhead)."

	^timedBlock timeToRun asMilliseconds asInteger
!

new
	"Answer a new instance of the receiver representing the current Time."

	^self now!

now
	"Answer a new instance of the receiver representing the current local time."

	^self fromSeconds: DateAndTime now seconds!

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
	^Time fromSeconds: 60 * (60 * hours + minutes) + seconds!

secondClock
	"Private - Answer the current value of the second clock (seconds since midnight)."
	
	^self now asSeconds!

stbConvertFrom: anSTBClassFormat
	"Convert from previous format Time.
	Version Changes:
		1) milliseconds integer becomes 'seconds' rational number 
	"

	^[:data | self fromMilliseconds: data first]!

stbVersion
	^1!

totalSeconds
	"Answer the total seconds since Jan. 1, 1901 (as an Integer) in local time."

	^DateAndTime now localSeconds truncated! !

!Core.Time class categoriesForMethods!
amMarker!accessing!public! !
defaultFormat!enquiries!private! !
errorInvalidFormat!exceptions!private! !
formats!enquiries!private! !
fromDuration:!instance creation!public! !
fromMilliseconds:!instance creation!public! !
fromSeconds:!instance creation!public! !
fromString:!instance creation!public! !
fromSYSTEMTIME:!instance creation!private! !
hours:minutes:seconds:!instance creation!public! !
microsecondClockValue!enquiries!public! !
millisecondClockValue!accessing!public! !
millisecondsToRun:!operations!public! !
new!instance creation!public! !
now!instance creation!public! !
pmMarker!accessing!public! !
readFrom:!instance creation!public! !
secondClock!accessing!private! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
totalSeconds!accessing!public! !
!

