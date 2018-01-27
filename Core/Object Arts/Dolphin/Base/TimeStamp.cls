"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #TimeStamp
	instanceVariableNames: 'date time'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TimeStamp guid: (GUID fromString: '{87b4c656-026e-11d3-9fd7-00a0cc3e4a32}')!
TimeStamp comment: 'TimeStamp is the class whose instances represent times of a particular day (i.e. a combination of a Date and Time).
This class is likely to be replaced by the forthcoming ANSI compliant DateAndTime class.'!
!TimeStamp categoriesForClass!Magnitude-General! !
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
	"Answer the receiver as <TimeStamp>."

	^self!

date
	"Answer the Date of the receiver."

	^date
!

date: aDate
	"Set the Date of the receiver. Answer the receiver."

	date := aDate
!

dateAndTime
	"Answer a two element Array containing the date and time."

	^{self date. self time}!

hash
	"Answer the SmallInteger hash value for the receiver."

	^(self date hash bitShift: 2) bitXor: self time hash!

printOn: aStream
	"Append a short textual description of the receiver to aStream."

	aStream
		print: self time;
		nextPutAll: ', ';
		print: self date!

printOn: aStream locale: aLocale flags: anInteger timeFormat: timeString dateFormat: dateString
	aStream
		nextPutAll: (aLocale 
					printTime: self time
					format: timeString
					flags: anInteger);
		space;
		nextPutAll: (aLocale 
					printDate: self date
					format: dateString
					flags: anInteger)!

printOn: aStream timeFormat: timeString dateFormat: dateString
	"Append a short textual description of the receiver to the <puttableStream> argument,
	aStream. The format is defined by the <readableString> argument, aString, the format 
	characters of which are as described in the Control Panel help for Windows 	Regional 
	Options/Time & Date settings. If the format argument is nil then the receiver is printed 
	to the stream in the currently configured default date and time formats of the host OS."

	self 
		printOn: aStream
		locale: Locale default
		flags: 0
		timeFormat: timeString
		dateFormat: dateString!

storeOn: aStream 
	aStream
		display: self class;
		nextPutAll: ' fromString: '.
	self displayString printOn: aStream!

time
	"Answer the Time of the receiver."

	^time
!

time: aTime
	"Set the Time of the receiver. Answer the receiver."

	time := aTime
! !
!TimeStamp categoriesFor: #<!comparing!public! !
!TimeStamp categoriesFor: #=!comparing!public! !
!TimeStamp categoriesFor: #addSeconds:!arithmetic!comparing!public! !
!TimeStamp categoriesFor: #asMilliseconds!converting!public! !
!TimeStamp categoriesFor: #asParameter!converting!public! !
!TimeStamp categoriesFor: #asSeconds!converting!public! !
!TimeStamp categoriesFor: #asTimeStamp!converting!public! !
!TimeStamp categoriesFor: #date!accessing!public! !
!TimeStamp categoriesFor: #date:!accessing!public! !
!TimeStamp categoriesFor: #dateAndTime!accessing!public! !
!TimeStamp categoriesFor: #hash!comparing!public! !
!TimeStamp categoriesFor: #printOn:!printing!public! !
!TimeStamp categoriesFor: #printOn:locale:flags:timeFormat:dateFormat:!printing!private! !
!TimeStamp categoriesFor: #printOn:timeFormat:dateFormat:!printing!public! !
!TimeStamp categoriesFor: #storeOn:!printing!public! !
!TimeStamp categoriesFor: #time!accessing!public! !
!TimeStamp categoriesFor: #time:!accessing!public! !

!TimeStamp class methodsFor!

current
	"Answer a new instance of the receiver representing the current
	date and time"

	^self fromSYSTEMTIME: SYSTEMTIME now!

currentUTC
	"Answer a new instance of the receiver representing the current UTC date and time"

	^self fromSYSTEMTIME: SYSTEMTIME nowUTC!

date: aDate
	"Answer a new instance of the receiver based on aDate."

	^self date: aDate time: (Time fromSeconds: 0)!

date: aDate time: aTime
	"Answer a new instance of the receiver based on aDate and aTime"

	<primitive: 157>
	^super new
		date: aDate;
		time: aTime;
		yourself!

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
	^TimeStamp date: date time: time!

fromSYSTEMTIME: aSYSTEMTIME
	"Answer a new instance of the receiver representing the current
	date and time"

	^self 
		date: (Date fromSYSTEMTIME: aSYSTEMTIME) 
		time: (Time fromSYSTEMTIME: aSYSTEMTIME)!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

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
!TimeStamp class categoriesFor: #fromMilliseconds:!public! !
!TimeStamp class categoriesFor: #fromSeconds:!instance creation!public! !
!TimeStamp class categoriesFor: #fromString:!public! !
!TimeStamp class categoriesFor: #fromSYSTEMTIME:!instance creation!public! !
!TimeStamp class categoriesFor: #icon!constants!public! !
!TimeStamp class categoriesFor: #new!instance creation!public! !
!TimeStamp class categoriesFor: #time:!instance creation!public! !

