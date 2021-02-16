"Filed out from Dolphin Smalltalk 7"!

Object subclass: #VideoRecording
	instanceVariableNames: 'title date time length'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
VideoRecording guid: (GUID fromString: '{62802c23-5ba3-4772-bfbe-a848ea29c27c}')!
VideoRecording comment: 'VideoRecording is represents a programme recorded on a VideoTape. This class is part of the Video Library sample package. Please see the package comment for more details.'!
!VideoRecording categoriesForClass!Samples! !
!VideoRecording methodsFor!

date
	"Answer the <Date> date when the receiver was aired.

	Illustrated Patterns:
	Accessor Method"

	^date!

date: recordingDate
	"Set the date of airing of the receiver to <Date> recordingDate.

	Illustrated Patterns:
	Accessor Method"

	date := recordingDate!

defaultLength
	"Private - Answer the default length the receiver in minutes.

	Illustrated Patterns:
	Constant Access Method
	Private Method
	"

	^30!

defaultTitle
	"Private - Answer a default title to use for the receiver when none other is provided.

	Illustrated Patterns:
	Constant Access Method
	Private Method
	"

	^'<Untitled Recording>'!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self title;
		nextPutAll: ' on ';
		display: self date;
		nextPutAll: ' at ';
		display: self time;
		nextPutAll: ' duration ';
		display: self length;
		nextPutAll: 'min'!

initialize
	"Private - Initialize the receiver to contain default values.

	Illustrated Patterns
	Instance Initialization
	"

	self 
		title: self defaultTitle;
		date: Date today;
		time: Time now;
		length: self defaultLength!

length
	"Answer the <Integer> length of the receiver in minutes.

	Illustrated Patterns:
	Accessor Method"

	^length!

length: lengthInMinutes
	"Set the duration of the receiver to <Integer> lengthInMinutes.

	Illustrated Patterns:
	Accessor Method"

	length := lengthInMinutes!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	self basicPrintOn: aStream.
	aStream
		nextPut: $(;
		display: self;
		nextPut: $)
!

time
	"Answer the <Time> time when the receiver was aired.

	Illustrated Patterns:
	Accessor Method"

	^time!

time: recordingTime
	"Set the time of airing of the receiver to <Time> recordingTime.

	Illustrated Patterns:
	Accessor Method"

	time := recordingTime!

title
	"Answer the <readableString> title of the receiver.

	Illustrated Patterns:
	Accessor Method"

	^title!

title: titleString
	"Set the title of the receiver to <readableString> titleString.

	Illustrated Patterns:
	Accessor Method"

	title := titleString! !
!VideoRecording categoriesFor: #date!accessing!public! !
!VideoRecording categoriesFor: #date:!accessing!public! !
!VideoRecording categoriesFor: #defaultLength!constants!private! !
!VideoRecording categoriesFor: #defaultTitle!constants!private! !
!VideoRecording categoriesFor: #displayOn:!printing!public! !
!VideoRecording categoriesFor: #initialize!initializing!private! !
!VideoRecording categoriesFor: #length!accessing!public! !
!VideoRecording categoriesFor: #length:!accessing!public! !
!VideoRecording categoriesFor: #printOn:!printing!public! !
!VideoRecording categoriesFor: #time!accessing!public! !
!VideoRecording categoriesFor: #time:!accessing!public! !
!VideoRecording categoriesFor: #title!accessing!public! !
!VideoRecording categoriesFor: #title:!accessing!public! !

!VideoRecording class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(TextTileIcon text: $\x1F39E fontName: 'Segoe UI Emoji')!

new
	"Answer a new, initialised, instance of the receiver.

	Illustrated Patterns:
	Instance Initialization
	"

	^super new initialize! !
!VideoRecording class categoriesFor: #icon!constants!public! !
!VideoRecording class categoriesFor: #new!instance creation!public! !

