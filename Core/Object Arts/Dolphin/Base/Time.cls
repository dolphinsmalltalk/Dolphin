"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #Time
	instanceVariableNames: 'milliseconds'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Time guid: (GUID fromString: '{87b4c655-026e-11d3-9fd7-00a0cc3e4a32}')!
Time comment: 'Time is the class whose instances represent a time of day as the number of seconds since midnight.'!
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

asMilliseconds
	"Answer the number of milliseconds since midnight represented by the receiver."

	^milliseconds!

asParameter
	"Answer the host system representation of the receiver."

	^SYSTEMTIME new
		wHour: self hours; 
		wMinute: self minutes; 
		wSecond: self seconds;
		yourself!

asSeconds
	"Answer the number of seconds since midnight represented by the receiver."

	^milliseconds // 1000
!

asTimeStamp
	"Answer the receiver as TimeStamp"

	^TimeStamp time: self!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self asMilliseconds hash!

hours
	"Answer the hour of the day represented by the receiver (24 hour clock)"

	^(milliseconds // ##(60*60*1000)) \\ 24
!

milliseconds
	"Answer the millisecond of the second of the minute of the hour of the day represented by
	the receiver."

	^milliseconds \\ 1000!

minutes
	"Answer the minute of the hour of the day represented by the receiver."

	^(milliseconds // ##(60*1000)) \\ 60
!

printOn: aStream
	"Append a short textual description of the receiver to aStream. The format is
	defined by the default User locale (i.e. it can be reconfigured using the
	Windows control panel)."

	self printOn: aStream locale: Locale default flags: 0 format: nil!

printOn: aStream format: aString
	"Append a short textual description of the receiver to the <puttableStream> argument,
	aStream. The format is defined by the <readableString> argument, aString, the format 
	characters of which are as described in the Control Panel help for Windows	Regional 
	Options/Time settings (e.g. hh:mm tt, formats to, for example, 10:15 pm). If the format 
	argument is nil then the receiver is printed to the stream in the currently configured default 
	format of the host OS."

	self 
		printOn: aStream
		locale: Locale default
		flags: 0
		format: aString!

printOn: aStream locale: locale flags: dwFlags format: aStringOrNil
	"Private - Append a locale specific string representation of the receiver to
	aStream, using the specified format String (the default is used if it is nil).
	The format is as described in the Control Panel help for Windows Regional 
	Options/Time settings (e.g. hh:mm tt, formats to, for example, 10:15 pm)."

	aStream nextPutAll: (locale printTime: self format: aStringOrNil flags: dwFlags)


!

seconds
	"Answer the second of the minute of the hour of the day represented by 
	the receiver."

	^(milliseconds // 1000) \\ 60
!

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
!Time categoriesFor: #asMilliseconds!converting!public! !
!Time categoriesFor: #asParameter!converting!public! !
!Time categoriesFor: #asSeconds!converting!public! !
!Time categoriesFor: #asTimeStamp!converting!public! !
!Time categoriesFor: #hash!comparing!public! !
!Time categoriesFor: #hours!accessing!public! !
!Time categoriesFor: #milliseconds!accessing!public! !
!Time categoriesFor: #minutes!accessing!public! !
!Time categoriesFor: #printOn:!printing!public! !
!Time categoriesFor: #printOn:format:!printing!public! !
!Time categoriesFor: #printOn:locale:flags:format:!printing!private! !
!Time categoriesFor: #seconds!accessing!public! !
!Time categoriesFor: #setMilliseconds:!accessing!private! !
!Time categoriesFor: #storeOn:!printing!public! !
!Time categoriesFor: #subtractTime:!arithmetic!public! !

!Time class methodsFor!

amMarker
	"Answer the marker used to signify AM when using 12 hour format"

	^Locale default amDesignator!

dateAndTimeNow
	"Answer an Array whose first element is the current local Date and whose
	second element is the current local Time."

	| localTime |
	localTime := SYSTEMTIME now.
	^{Date fromSYSTEMTIME: localTime. self fromSYSTEMTIME: localTime}!

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

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

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

	| hours minutes seconds milliseconds separator am rounded |
	minutes := 0.
	seconds := 0.
	milliseconds := 0.
	hours := Integer readFrom: aStream radix: 10.
	separator := aStream peek.
	rounded := 0.
	(separator isNil or: [separator isLetter])
		ifFalse: 
			[aStream next.
			minutes := Integer readFrom: aStream radix: 10.
			(aStream peekFor: separator)
				ifTrue: 
					[seconds := Integer readFrom: aStream radix: 10.
					(aStream peekFor: separator)
						ifTrue: [milliseconds := Integer readFrom: aStream radix: 10]
						ifFalse: 
							[(aStream peekFor: $.)
								ifTrue: 
									[| start |
									start := aStream position.
									milliseconds := Integer readFrom: aStream radix: 10.
									milliseconds isNil
										ifTrue: 
											["Actually just seconds with a trailing full stop"
											milliseconds := 0.
											aStream pop]
										ifFalse: 
											[| precision |
											precision := aStream position - start - 3.
											milliseconds == 0
												ifFalse: 
													[milliseconds := (milliseconds / precision exp10) asInteger.
													rounded := 1]]]]]].
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
					[((0 to: 12) includes: hours) ifFalse: [^self errorInvalidFormat].
					hours < 12 ifTrue: [hours := hours + 12]]].
	((0 to: 23) includes: hours) ifFalse: [^self errorInvalidFormat].
	((0 to: 59) includes: minutes) ifFalse: [^self errorInvalidFormat].
	((0 to: 59) includes: seconds) ifFalse: [^self errorInvalidFormat].
	"Note that milliseconds may legitimately be rounded up to 1000, so to avoid having to carry this through we treat it as valid"
	((0 to: 999 + rounded) includes: milliseconds) ifFalse: [^self errorInvalidFormat].
	^Time fromMilliseconds: (60 * (60 * hours + minutes) + seconds) * 1000 + milliseconds!

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
	
	| dateAndTime |
	dateAndTime := self dateAndTimeNow.
	^(dateAndTime at: 1) asSeconds + (dateAndTime at: 2) asSeconds! !
!Time class categoriesFor: #amMarker!accessing!public! !
!Time class categoriesFor: #dateAndTimeNow!accessing!public! !
!Time class categoriesFor: #defaultFormat!enquiries!private! !
!Time class categoriesFor: #errorInvalidFormat!exceptions!private! !
!Time class categoriesFor: #formats!enquiries!private! !
!Time class categoriesFor: #fromMilliseconds:!instance creation!public! !
!Time class categoriesFor: #fromSeconds:!instance creation!public! !
!Time class categoriesFor: #fromString:!instance creation!public! !
!Time class categoriesFor: #fromSYSTEMTIME:!instance creation!private! !
!Time class categoriesFor: #hours:minutes:seconds:!instance creation!public! !
!Time class categoriesFor: #icon!constants!public! !
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

