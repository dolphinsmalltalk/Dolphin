"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'STON.Tests.AlternativeRepresentationTestObject'
	instanceVariableNames: 'id time gridReference'
	classVariableNames: 'KnownObjects'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.AlternativeRepresentationTestObject guid: (Core.GUID fromString: '{a3b7ea39-2cea-4653-8b42-96ebe1e7ac3e}')!
STON.Tests.AlternativeRepresentationTestObject comment: 'I am STONAlternativeRepresentationTestObject.

My properties are
 - id <Integer>
 - time <DateAndTime> in the local time zone
 - gridReference <Point <Float>@<Float>> in kilometer

My STON representation has the properties
 - id <Integer>
 - time <DateAndTime> in UTC
 - grid_reference <Point <Float>@<Float>> in miles

Note the different key, gridReference vs. grid_reference

Upon serialization, the conversions local time to UTC and kilometer to mile is performed.
Upon materialization, the convertions UTC to local tie and miles to kilometers are performed.'!
!STON.Tests.AlternativeRepresentationTestObject methodsFor!

fromSton: stonReader
	stonReader parseMapDo: 
			[:key :value |
			key = #id ifTrue: [self id: value].
			key = #time ifTrue: [self timeUTC: value].
			key = #grid_reference ifTrue: [self gridReferenceImperial: value]]!

gridReference
	^gridReference!

gridReference: anObject
	gridReference := anObject!

gridReferenceImperial
	^gridReference / 1.609344!

gridReferenceImperial: value
	gridReference := value * 1.609344!

id
	^id!

id: anObject
	id := anObject!

stonOn: stonWriter
	stonWriter writeObject: self
		streamMap: 
			[:dictionary |
			dictionary
				at: #id put: self id;
				at: #time put: self timeUTC;
				at: #grid_reference put: self gridReferenceImperial]!

time
	^time!

time: anObject
	time := anObject!

timeUTC
	^time asUTC!

timeUTC: value
	time := value offset: Locale timeZoneInformation offset! !
!STON.Tests.AlternativeRepresentationTestObject categoriesForMethods!
fromSton:!public!ston! !
gridReference!accessing!public! !
gridReference:!accessing!public! !
gridReferenceImperial!accessing!public! !
gridReferenceImperial:!accessing!public! !
id!accessing!public! !
id:!accessing!public! !
stonOn:!public!ston! !
time!accessing!public! !
time:!accessing!public! !
timeUTC!accessing!public! !
timeUTC:!accessing!public! !
!

!STON.Tests.AlternativeRepresentationTestObject class methodsFor!

example
	^self new
		id: 1e9 atRandom;
		time: DateAndTime now;
		gridReference: 150.75 @ 250.25;
		yourself!

icon
	"Answers an Icon that can be used to represent this class"

	^STONTest icon! !
!STON.Tests.AlternativeRepresentationTestObject class categoriesForMethods!
example!examples!public! !
icon!constants!public! !
!

