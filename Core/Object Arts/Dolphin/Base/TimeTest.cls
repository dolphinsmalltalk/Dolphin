"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #TimeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TimeTest guid: (GUID fromString: '{5eb1cd02-030d-4b2f-b1df-b06465e5bb19}')!
TimeTest comment: ''!
!TimeTest categoriesForClass!Unclassified! !
!TimeTest methodsFor!

comparePrintStreamFor: time hr24: hr24 showSeconds: showSeconds expected: expected
	| output aStream fmt |
	aStream := String writeStream.
	fmt := hr24
				ifTrue: [showSeconds ifTrue: ['HH:mm.ss'] ifFalse: ['HH:mm']]
				ifFalse: [showSeconds ifTrue: ['h:mm.ss tt'] ifFalse: ['h:mm tt']].
	time printOn: aStream format: fmt.
	output := aStream contents.
	self assert: output equals: expected!

hoursShould: expectedHours for: seconds
	self assert: (Time fromSeconds: seconds) hours equals: expectedHours!

millisecondsShould: expectedMs for: mS
	self assert: (Time fromMilliseconds: mS) milliseconds equals: expectedMs!

minutesShould: expectedMinutes for: seconds
	self assert: (Time fromSeconds: seconds) minutes equals: expectedMinutes!

secondsShould: expectedSeconds for: seconds
	self assert: (Time fromSeconds: seconds) seconds equals: expectedSeconds!

testClassReadFrom
	self assert: (Time readFrom: '00' readStream) asSeconds equals: 0.
	self assert: (Time readFrom: '00am' readStream) asSeconds equals: 0.
	self assert: (Time readFrom: '00pm' readStream) asSeconds equals: 60 * 60 * 12.
	self assert: (Time readFrom: '1' readStream) asSeconds equals: 60 * 60.
	self assert: (Time readFrom: '1am' readStream) asSeconds equals: 60 * 60.
	self assert: (Time readFrom: '1pm' readStream) asSeconds equals: 60 * 60 * 13.
	self assert: (Time readFrom: '00:00' readStream) asSeconds equals: 0.
	self assert: (Time readFrom: '00:00am' readStream) asSeconds equals: 0.
	self assert: (Time readFrom: '00:00pm' readStream) asSeconds equals: 60 * 60 * 12.
	self assert: (Time readFrom: '00:01' readStream) asSeconds equals: 60.
	self assert: (Time readFrom: '00:01am' readStream) asSeconds equals: 60.
	self assert: (Time readFrom: '00:01pm' readStream) asSeconds equals: 60 * 60 * 12 + 60.
	self assert: (Time readFrom: '00:00:00' readStream) asSeconds equals: 0.
	self assert: (Time readFrom: '00:00:00am' readStream) asSeconds equals: 0.
	self assert: (Time readFrom: '00:00:00pm' readStream) asSeconds equals: 60 * 60 * 12.
	self assert: (Time readFrom: '00:00:01' readStream) asSeconds equals: 1.
	self assert: (Time readFrom: '00:00:01am' readStream) asSeconds equals: 1.
	self assert: (Time readFrom: '00:00:01pm' readStream) asSeconds equals: 60 * 60 * 12 + 1.
	self assert: (Time readFrom: '00:00:00:00' readStream) asSeconds equals: 0.
	self assert: (Time readFrom: '00:00:00:00am' readStream) asSeconds equals: 0.
	self assert: (Time readFrom: '00:00:00:00pm' readStream) asSeconds equals: 60 * 60 * 12.
	self assert: (Time readFrom: '00:00:00:01' readStream) asMilliseconds equals: 1.
	self assert: (Time readFrom: '00:00:00:01am' readStream) asMilliseconds equals: 1.
	self assert: (Time readFrom: '00:00:00:01pm' readStream) asMilliseconds
		equals: 60 * 60 * 12 * 1000 + 1.
	self assert: (Time readFrom: '00:59' readStream) asSeconds equals: 59 * 60.
	self assert: (Time readFrom: '00:10' readStream) asSeconds equals: 60 * 10.
	self assert: (Time readFrom: '01:00' readStream) asSeconds equals: 60 * 60.
	self assert: (Time readFrom: '10:00' readStream) asSeconds equals: 60 * 60 * 10.
	self assert: (Time fromString: '00:00:00:1') asMilliseconds equals: 1.
	self assert: (Time fromString: '00:00:00.1') asMilliseconds equals: 100.
	self assert: (Time fromString: '00:00:00.0') asMilliseconds equals: 0.
	self assert: (Time fromString: '00:00:00.999') asMilliseconds equals: 999.
	self assert: (Time fromString: '00:00:00.9994') asMilliseconds equals: 999.
	self assert: (Time fromString: '00:00:00.9995') asMilliseconds equals: 1000.
	self assert: (Time fromString: '00:00:00.01') asMilliseconds equals: 10.
	self assert: (Time fromString: '00:00:00.001') asMilliseconds equals: 1.
	self assert: (Time fromString: '00:00:00.0014') asMilliseconds equals: 1.
	self assert: (Time fromString: '00:00:00.00049') asMilliseconds equals: 0.
	self assert: (Time fromString: '00:00:00.0005') asMilliseconds equals: 1.
	self assert: (Time fromString: '00:00:00.0015') asMilliseconds equals: 2.
	self assert: (Time readFrom: '11:59:59:999' readStream) asMilliseconds
		equals: 60 * 60 * 12 * 1000 - 1.
	self assert: (Time readFrom: '23:59:59:999' readStream) asMilliseconds
		equals: 60 * 60 * 24 * 1000 - 1.
	self assert: (Time readFrom: '13:00' readStream) asSeconds equals: 60 * 60 * 13.
	self assert: (Time readFrom: '11:59 PM' readStream) asSeconds equals: 60 * 60 * 24 - 60.
	self assert: (Time readFrom: '12:00 PM' readStream) asSeconds equals: 60 * 60 * 12.
	self assert: (Time readFrom: '12:00 AM' readStream) asSeconds equals: 0.
	self should: [Time readFrom: '13:00 PM' readStream] raise: Error.
	self should: [Time readFrom: '13:00 AM' readStream] raise: Error.
	self should: [Time readFrom: '24:00' readStream] raise: Error.
	self should: [Time readFrom: '23:60:59:999' readStream] raise: Error.
	self should: [Time readFrom: '23:59:60:999' readStream] raise: Error.
	self should: [Time readFrom: '23:59:59:1000' readStream] raise: Error.
	self should: [Time readFrom: '-1:59:59:999' readStream] raise: Error.
	self should: [Time readFrom: '23:-1:59:999' readStream] raise: Error.
	self should: [Time readFrom: '23:59:-1:999' readStream] raise: Error.
	self should: [Time readFrom: '23:59:59:-1' readStream] raise: Error.
	self should: [Time fromString: '00:00:00.-1'] raise: Error!

testHours
	self hoursShould: 0 for: 0.
	self hoursShould: 0 for: 3599.
	self hoursShould: 1 for: 3600.
	self hoursShould: 1 for: 3601.
	self hoursShould: 23 for: 86399.
	self hoursShould: 0 for: 86400.
	self hoursShould: 0 for: 86401.
	self hoursShould: 23 for: -1.
	self hoursShould: 23 for: -3599.
	self hoursShould: 23 for: -3600.
	self hoursShould: 22 for: -3601.
	self hoursShould: 0 for: -86399.
	self hoursShould: 0 for: -86400.
	self hoursShould: 23 for: -86401!

testMilliseconds
	(Time canUnderstand: #milliseconds) 
		ifFalse: 
			["Introduced in D6"
			^self].
	self millisecondsShould: 0 for: 0.
	self millisecondsShould: 0 for: 1000.
	self millisecondsShould: 1 for: 1.
	self millisecondsShould: 1 for: 1001!

testMinutes
	self minutesShould: 0 for: 0.
	self minutesShould: 0 for: 59.
	self minutesShould: 1 for: 60.
	self minutesShould: 1 for: 61.
	self minutesShould: 59 for: 3599.
	self minutesShould: 0 for: 3600.
	self minutesShould: 0 for: 3601.
	self minutesShould: 59 for: -1.	"23:59"
	self minutesShould: 59 for: -59.
	self minutesShould: 59 for: -60.
	self minutesShould: 58 for: -61.
	self minutesShould: 0 for: -3599.
	self minutesShould: 0 for: -3600.
	self minutesShould: 59 for: -3601!

testPrintNegativeTime
	"UnitTest for [BUG] Printing Time

	Description:

	I'm not sure if this is a bug or 'as designed', but when you do any 
	arithmetic with time objects (especially subtraction) and the seconds 
	go negative (before midnight), when you print out the time you either 
	always get 12 am or something interesting if you are printing 24-hour 
	time.

	A simple fix in the method print24:showSeconds:on: would be to 
	instead of initializing the local variable h to self hours, 
	initialize h to self hours \\ 24."

	| time1 time2 timeDiff |
	time1 := Time fromSeconds: 1 * 3600 + (0 * 60) + 0.
	time2 := Time fromSeconds: 4 * 3600 + (0 * 60) + 0.
	timeDiff := time1 subtractTime: time2.

	"time 01:00:00 - 04:00:00 should return 21:00:00 or 09:00:00 pm"
	self 
		comparePrintStreamFor: timeDiff
		hr24: false
		showSeconds: false
		expected: '9:00 PM'.
	self 
		comparePrintStreamFor: timeDiff
		hr24: false
		showSeconds: true
		expected: '9:00.00 PM'.
	self 
		comparePrintStreamFor: timeDiff
		hr24: true
		showSeconds: false
		expected: '21:00'.
	self 
		comparePrintStreamFor: timeDiff
		hr24: true
		showSeconds: true
		expected: '21:00.00'!

testPrintPositiveTime
	| time1 |
	time1 := Time fromSeconds: 1 * 3600 + (0 * 60) + 0.
	self 
		comparePrintStreamFor: time1
		hr24: false
		showSeconds: false
		expected: '1:00 AM'.
	self 
		comparePrintStreamFor: time1
		hr24: false
		showSeconds: true
		expected: '1:00.00 AM'.
	self 
		comparePrintStreamFor: time1
		hr24: true
		showSeconds: false
		expected: '01:00'.
	self 
		comparePrintStreamFor: time1
		hr24: true
		showSeconds: true
		expected: '01:00.00'!

testSeconds
	self secondsShould: 0 for: 0.
	self secondsShould: 59 for: 59.
	self secondsShould: 0 for: 60.
	self secondsShould: 1 for: 61.
	self secondsShould: 59 for: -1.	"23:59"
	self secondsShould: 1 for: -59.
	self secondsShould: 0 for: -60.
	self secondsShould: 59 for: -61! !
!TimeTest categoriesFor: #comparePrintStreamFor:hr24:showSeconds:expected:!comparing!private! !
!TimeTest categoriesFor: #hoursShould:for:!comparing!private! !
!TimeTest categoriesFor: #millisecondsShould:for:!comparing!private! !
!TimeTest categoriesFor: #minutesShould:for:!comparing!private! !
!TimeTest categoriesFor: #secondsShould:for:!comparing!private! !
!TimeTest categoriesFor: #testClassReadFrom!public!unit tests! !
!TimeTest categoriesFor: #testHours!public!testing! !
!TimeTest categoriesFor: #testMilliseconds!public!testing! !
!TimeTest categoriesFor: #testMinutes!public!testing! !
!TimeTest categoriesFor: #testPrintNegativeTime!public!testing! !
!TimeTest categoriesFor: #testPrintPositiveTime!public!testing! !
!TimeTest categoriesFor: #testSeconds!public!testing! !

