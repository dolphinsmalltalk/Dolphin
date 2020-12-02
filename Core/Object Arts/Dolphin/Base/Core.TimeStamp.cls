"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #TimeStamp
	instanceVariableNames: 'date time'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TimeStamp guid: (GUID fromString: '{87b4c656-026e-11d3-9fd7-00a0cc3e4a32}')!
TimeStamp comment: '`TimeStamp` represents a `Time` of day on a particular `Date` in an unspecified time zone.

`TimeStamp` is present for backwards compatibility only. For most purposes the ANSI compliant and time zone offset aware `DateAndTime` class should be preferred.'!
!TimeStamp categoriesForClass!Kernel-Chronology! !
!TimeStamp methodsFor!

< aTimeStamp
	"Answer whether the receiver precedes the argument, aTimeStamp."

	^self date < aTimeStamp date
		or: [self date = aTimeStamp date and: [self time < aTimeStamp time]]!

= aTimeStamp
	"Answer whether the receiver represents the same time and date as the argument."

	^self species == aTimeStamp species 
		and: [self date = aTimeStamp date and: [self time = aTimeStamp time]]!

addSeconds: anInteger
	"Answer a new TimeStamp, anInteger seconds after the receiver."

	^self class fromSeconds: self asSeconds + anInteger!

asDateAndTime
	^DateAndTime fromDate: date time: time!

asMilliseconds
	"Answer the number of milliseconds between January 1, 1901, and the time and date
	represented by the receiver (this will likely be a LargeInteger). Can be used to perform 
	arithmetic with Dates and Times."

	^self date asMilliseconds + self time asMilliseconds!

asParameter
	"Answer the receiver in external system representation for passing to an external function call."

	| timeStampSt timeSt |
	timeStampSt := self date asParameter.
	timeSt := self time asParameter.
	timeStampSt
		wHour: timeSt wHour; 
		wMinute: timeSt wMinute; 
		wSecond: timeSt wSecond.
	^timeStampSt!

asSeconds
	"Answer the number of seconds between January 1, 1901, and the time and date
	represented by the receiver (this will likely be a LargeInteger). Can be used to perform 
	arithmetic with Dates and Times."

	^self date asSeconds + self time asSeconds!

asTimeStamp
	"Answer the receiver as a <TimeStamp>."

	^self!

date
	"Answer the <Date> of the receiver."

	^date
!

dayOfMonth
	"Answer an <integer> between 1 and 31, inclusive, representing the day of the month of the date of the receiver."

	^date dayOfMonth!

dayOfWeek
	^date dayOfWeek!

hash
	"Answer the SmallInteger hash value for the receiver."

	^(self date hash bitShift: 2) bitXor: self time hash!

hour
	"Answer an <integer> between 0 and 23, inclusive, representing the hour of the day on the 24-hour clock of time of the receiver."

	^time hour!

hour12
	"Answer an <integer> between 1 and 12, inclusive, representing the hour of the day on the 12-hour clock of time of the receiver."

	^time hour12!

hour24
	"Answer an <integer> between 0 and 23, inclusive, representing the hour of the day on the 24-hour clock of time of the receiver."

	^time hour24!

minute
	"Answer an <integer> between 0 and 59, inclusive, representing the minute of the hour of the time of the receiver."

	^time minute!

month
	"Answer the one-based <integer> index of the month represented by the receiver; 1 for January, 2 for February, and so on."

	^date month!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	"Maintain the format that Dolphin has historically used for displaying TimeStamps because Ian's Chunk Browser relies on this to identify image saves, e.g. 11:06:39, 03 April 2002"
	Locale smalltalk printDateTime: self on: aStream format: 'HH:mm:ss, dd MMMM yyyy'!

printOn: aStream format: aString
	"Append a short textual description of the receiver to the <puttableStream> argument, aStream. The format is defined by the <readableString> argument, aString, the format characters of which are as described Locale>>dateFormat and Locale>>timeFormat methods. If the format argument is nil then the receiver is printed to the stream in the currently configured default date and time formats of the stream's <Locale>."

	aStream locale
		printDateTime: self
		on: aStream
		format: aString!

printStringFormat: aString 
	"Answer a short textual description of the receiver. The format is defined by the <readableString> argument, aString, the format characters of which are as described in the comments of the Locale>>#dateFormat and Locale>>#timeFormat methods. Settings from the default locale are used."

	| stream |
	stream := String writeStream: aString size.
	self printOn: stream format: aString.
	^stream contents!

second
	^time second!

setDate: aDate time: aTime
	date := aDate.
	time := aTime.
	self isImmutable: true.
	^self
!

storeOn: aStream 
	aStream
		display: self class;
		nextPutAll: ' fromString: '.
	self displayString printOn: aStream!

time
	"Answer the <Time> of the receiver."

	^time
!

year
	^date year! !
!TimeStamp categoriesFor: #<!comparing!public! !
!TimeStamp categoriesFor: #=!comparing!public! !
!TimeStamp categoriesFor: #addSeconds:!arithmetic!comparing!public! !
!TimeStamp categoriesFor: #asDateAndTime!public! !
!TimeStamp categoriesFor: #asMilliseconds!converting!public! !
!TimeStamp categoriesFor: #asParameter!converting!public! !
!TimeStamp categoriesFor: #asSeconds!converting!public! !
!TimeStamp categoriesFor: #asTimeStamp!converting!public! !
!TimeStamp categoriesFor: #date!accessing!public! !
!TimeStamp categoriesFor: #dayOfMonth!accessing!public! !
!TimeStamp categoriesFor: #dayOfWeek!public! !
!TimeStamp categoriesFor: #hash!comparing!public! !
!TimeStamp categoriesFor: #hour!accessing!public! !
!TimeStamp categoriesFor: #hour12!accessing!public! !
!TimeStamp categoriesFor: #hour24!accessing!public! !
!TimeStamp categoriesFor: #minute!accessing!public! !
!TimeStamp categoriesFor: #month!accessing!public! !
!TimeStamp categoriesFor: #printOn:!printing!public! !
!TimeStamp categoriesFor: #printOn:format:!printing!public! !
!TimeStamp categoriesFor: #printStringFormat:!printing!public! !
!TimeStamp categoriesFor: #second!accessing!public! !
!TimeStamp categoriesFor: #setDate:time:!accessing!initializing!private! !
!TimeStamp categoriesFor: #storeOn:!printing!public! !
!TimeStamp categoriesFor: #time!accessing!public! !
!TimeStamp categoriesFor: #year!accessing!public! !

!TimeStamp class methodsFor!

current
	"Answer a new instance of the receiver representing the current date and time."

	"Note that the clock precision is currently limited to milliseconds because of the use of SYSTEMTIMEs."

	^self fromSYSTEMTIME: SYSTEMTIME now!

currentUTC
	"Answer a new instance of the receiver representing the current UTC date and time."

	^self fromSYSTEMTIME: SYSTEMTIME nowUTC!

date: aDate
	"Answer a new instance of the receiver based on aDate."

	^self date: aDate time: (Time fromSeconds: 0)!

date: aDate time: aTime
	"Answer a new instance of the receiver based on aDate and aTime"

	<primitive: 157>
	^super new setDate: aDate time: aTime!

fromDateAndTime: aDateAndTime
	"Answer a new instance of the receiver representing the same date and time as the local time of the <DateAndTime> argument."

	^self date: aDateAndTime asDate time: aDateAndTime asTime!

fromMilliseconds: anInteger 
	| date msInDay |
	date := Date fromSeconds: anInteger // 1000.
	msInDay := anInteger - (date asSeconds * 1000).
	^self date: date time: (Time fromMilliseconds: msInDay)!

fromSeconds: anInteger
	"Answer a new instance of the receiver representing the point in time
	anInteger seconds after the epoch."

	| date |
	date := Date fromSeconds: anInteger.
	^self 
		date: date 
		time: (Time fromSeconds: anInteger - date asSeconds)!

fromString: aString 
	| stream time date |
	stream := aString readStream.
	
	[time := Time readFrom: stream.
	stream next.
	date := Date readFrom: stream] on: InvalidFormat
			do: 
				[:x | 
				stream reset.
				date := Date readFrom: stream.
				stream next.
				time := Time readFrom: stream].
	^self date: date time: time!

fromSYSTEMTIME: aSYSTEMTIME
	"Answer a new instance of the receiver representing the current
	date and time"

	^self 
		date: (Date fromSYSTEMTIME: aSYSTEMTIME) 
		time: (Time fromSYSTEMTIME: aSYSTEMTIME)!

new
	"Answer a new instance of the receiver representing the current Time."

	^self current!

time: aTime
	"Answer a new instance of the receiver based on aTime."

	^self date: (Date fromDays: 0) time: aTime! !
!TimeStamp class categoriesFor: #current!instance creation!public! !
!TimeStamp class categoriesFor: #currentUTC!instance creation!public! !
!TimeStamp class categoriesFor: #date:!instance creation!public! !
!TimeStamp class categoriesFor: #date:time:!instance creation!public! !
!TimeStamp class categoriesFor: #fromDateAndTime:!instance creation!public! !
!TimeStamp class categoriesFor: #fromMilliseconds:!public! !
!TimeStamp class categoriesFor: #fromSeconds:!instance creation!public! !
!TimeStamp class categoriesFor: #fromString:!public! !
!TimeStamp class categoriesFor: #fromSYSTEMTIME:!instance creation!public! !
!TimeStamp class categoriesFor: #new!instance creation!public! !
!TimeStamp class categoriesFor: #time:!instance creation!public! !

