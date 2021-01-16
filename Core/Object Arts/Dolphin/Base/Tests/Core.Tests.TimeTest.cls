"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.TimeTest'
	instanceVariableNames: 'savedLocale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.TimeTest guid: (Core.GUID fromString: '{5eb1cd02-030d-4b2f-b1df-b06465e5bb19}')!
Core.Tests.TimeTest comment: ''!
!Core.Tests.TimeTest categoriesForClass!Unclassified! !
!Core.Tests.TimeTest methodsFor!

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
	self assert: (Time fromSeconds: seconds) hour equals: expectedHours!

millisecondsShould: expectedMs for: mS
	self assert: (Time fromMilliseconds: mS) milliseconds equals: expectedMs!

minutesShould: expectedMinutes for: seconds
	self assert: (Time fromSeconds: seconds) minute equals: expectedMinutes!

secondsShould: expectedSeconds for: seconds
	self assert: (Time fromSeconds: seconds) second equals: expectedSeconds!

setUp
	super setUp.
	savedLocale := Locale userDefault.
	Locale userDefault: (Locale named: 'en-US')!

tearDown
	savedLocale
		ifNotNil: 
			[Locale userDefault: savedLocale.
			savedLocale := nil].
	super tearDown!

testAsSYSTEMTIME
	| today now actual |
	today := Date today.
	now := Time now.
	actual := now asSYSTEMTIME.
	self assert: actual wYear equals: today year.
	self assert: actual wMonth equals: today month.
	self assert: actual wDay equals: today dayOfMonth.
	self assert: actual wHour equals: now hour24.
	self assert: actual wMinute equals: now minute.
	self assert: actual wSecond equals: now second truncated.
	self assert: actual wMilliseconds equals: (now second fractionPart * 1000) truncated!

testAsSYSTEMTIMEInvalidMilliseconds
	"#1045 - wMillisecond must never be 1000, even if that is what the millisecond value we have would round to"

	| subject actual |
	subject := Time fromSeconds: 599995 / 10000.
	actual := subject asSYSTEMTIME.
	self assert: actual wSecond equals: 59.
	self assert: actual wMilliseconds equals: 999!

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
	self assert: (Time fromString: '00:00:00.9994') asMilliseconds equals: 9994 / 10.
	self assert: (Time fromString: '00:00:00.9995') asMilliseconds equals: 9995 / 10.
	self assert: (Time fromString: '00:00:00.01') asMilliseconds equals: 10.
	self assert: (Time fromString: '00:00:00.001') asMilliseconds equals: 1.
	self assert: (Time fromString: '00:00:00.0014') asMilliseconds equals: 14 / 10.
	self assert: (Time fromString: '00:00:00.00049') asMilliseconds equals: 49 / 100.
	self assert: (Time fromString: '00:00:00.0005') asMilliseconds equals: 5 / 10.
	self assert: (Time fromString: '00:00:00.0015') asMilliseconds equals: 15 / 10.
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

testFromDuration
	self
		assert: (Time fromDuration: (Duration
						days: -10
						hours: -1
						minutes: -2
						seconds: -3))
		equals: (Time
				hour: 22
				minute: 57
				second: 57).
	self assert: (Time fromDuration: 0 hours) equals: (Time fromSeconds: 0).
	self
		assert: (Time fromDuration: (Duration
						days: 25
						hours: 12
						minutes: 15
						seconds: 35))
		equals: (Time
				hour: 12
				minute: 15
				second: 35)!

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
	| time1 time2 timeDiff |
	time1 := Time fromSeconds: 1 * 3600 + (0 * 60) + 0.
	time2 := Time fromSeconds: 4 * 3600 + (0 * 60) + 0.
	"In Dolphin Time's don't go negative now"
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

testPrintOnFormat
	#(#(45000 'h:mm tt' '12:30 PM')) do: 
			[:each |
			| time actual |
			time := Time fromSeconds: each first.
			actual := String streamContents: 
							[:s |
							s locale: Locale invariant.
							time printOn: s format: each second].
			self assert: actual equals: each last]!

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
	self secondsShould: 59 for: -61!

testStb
	| oldStb rehydrated subject stb |
	oldStb := {#'!!STL'. 4. 262406. Time. 117671221}.
	rehydrated := Time fromLiteralStoreArray: oldStb.
	self assert: rehydrated asMilliseconds equals: 58835610.
	subject := Time now.
	stb := subject binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: stb.
	self assert: rehydrated equals: subject!

testStoreOn
	| subject stored collection |
	subject := Time now.
	collection := OrderedCollection with: subject
				with: (Time
						hour: 23
						minute: 59
						second: 58).
	stored := collection storeString.
	self assert: (Compiler evaluate: stored) equals: collection! !
!Core.Tests.TimeTest categoriesFor: #comparePrintStreamFor:hr24:showSeconds:expected:!comparing!private! !
!Core.Tests.TimeTest categoriesFor: #hoursShould:for:!comparing!private! !
!Core.Tests.TimeTest categoriesFor: #millisecondsShould:for:!comparing!private! !
!Core.Tests.TimeTest categoriesFor: #minutesShould:for:!comparing!private! !
!Core.Tests.TimeTest categoriesFor: #secondsShould:for:!comparing!private! !
!Core.Tests.TimeTest categoriesFor: #setUp!private!running! !
!Core.Tests.TimeTest categoriesFor: #tearDown!private!running! !
!Core.Tests.TimeTest categoriesFor: #testAsSYSTEMTIME!public!unit tests! !
!Core.Tests.TimeTest categoriesFor: #testAsSYSTEMTIMEInvalidMilliseconds!public!unit tests! !
!Core.Tests.TimeTest categoriesFor: #testClassReadFrom!public!unit tests! !
!Core.Tests.TimeTest categoriesFor: #testFromDuration!public!testing! !
!Core.Tests.TimeTest categoriesFor: #testHours!public!testing! !
!Core.Tests.TimeTest categoriesFor: #testMilliseconds!public!testing! !
!Core.Tests.TimeTest categoriesFor: #testMinutes!public!testing! !
!Core.Tests.TimeTest categoriesFor: #testPrintNegativeTime!public!testing! !
!Core.Tests.TimeTest categoriesFor: #testPrintOnFormat!public!unit tests! !
!Core.Tests.TimeTest categoriesFor: #testPrintPositiveTime!public!testing! !
!Core.Tests.TimeTest categoriesFor: #testSeconds!public!testing! !
!Core.Tests.TimeTest categoriesFor: #testStb!public!testing! !
!Core.Tests.TimeTest categoriesFor: #testStoreOn!public!testing! !

