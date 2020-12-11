"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.TimeStampTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.TimeStampTest guid: (Core.GUID fromString: '{152f98a5-e614-445f-bb23-7db28a4d01b8}')!
Core.Tests.TimeStampTest comment: ''!
!Core.Tests.TimeStampTest categoriesForClass!Unclassified! !
!Core.Tests.TimeStampTest methodsFor!

currentTimeStamp
	"Remove millisecond precision."

	^TimeStamp fromSeconds: TimeStamp current asSeconds!

testAddSeconds
	| current |
	current := self currentTimeStamp.
	self assert: (current addSeconds: 60) equals: (TimeStamp fromSeconds: current asSeconds + 60).
	self assert: (current addSeconds: 60) asSeconds
		equals: (TimeStamp fromSeconds: current asSeconds + 60) asSeconds.
	self assert: (current addSeconds: 60) asMilliseconds
		equals: (TimeStamp fromSeconds: current asSeconds + 60) asMilliseconds.
	self assert: (current addSeconds: -43) equals: (TimeStamp fromSeconds: current asSeconds - 43).
	self assert: (current addSeconds: 24 * 60 * 60) date equals: (current date addDays: 1).
	self assert: (current addSeconds: -24 * 60 * 60) date equals: (current date subtractDays: 1)!

testAsMilliseconds
	| current |
	current := self currentTimeStamp.
	self assert: current asMilliseconds
		equals: current date asMilliseconds + current time asMilliseconds.
	self assert: 1 equals: (TimeStamp fromMilliseconds: 1) asMilliseconds.
	self deny: 1 equals: (TimeStamp fromMilliseconds: 2) asMilliseconds.
	self assert: 9999999999999999999999999999
		equals: (TimeStamp fromMilliseconds: 9999999999999999999999999999) asMilliseconds!

testAsSeconds
	| current |
	current := self currentTimeStamp.
	self assert: current asSeconds equals: current date asSeconds + current time asSeconds.
	self assert: 1 equals: (TimeStamp fromSeconds: 1) asSeconds.
	self deny: 1 equals: (TimeStamp fromSeconds: 2) asSeconds.
	self assert: 99999999999999999 equals: (TimeStamp fromSeconds: 99999999999999999) asSeconds!

testCurrentUTC
	| bias current |
	current := self currentTimeStamp.
	bias := Locale timeZoneInformation currentBias * 60.
	self assert: (current addSeconds: bias) time hour equals: TimeStamp currentUTC time hour!

testDateTime
	| today now ts1 ts2 originalMethod testMethod |
	today := Date today.
	now := Time now.
	ts1 := TimeStamp date: today time: now.
	self assert: ts1 date equals: today.
	self assert: ts1 time equals: now.
	originalMethod := TimeStamp class compiledMethodAt: #date:time:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	ts2 := testMethod value: TimeStamp withArguments: {today. now}.
	self assert: ts2 equals: ts1!

testFromMilliseconds
	| current |
	current := self currentTimeStamp.
	self assert: current equals: (TimeStamp fromMilliseconds: current asMilliseconds).
	self assert: -1 equals: (TimeStamp fromMilliseconds: -1) asMilliseconds!

testFromSeconds
	| current |
	current := self currentTimeStamp.
	self assert: current equals: (TimeStamp fromSeconds: current asSeconds).
	self assert: (current date addDays: 1)
		equals: (TimeStamp fromSeconds: current asSeconds + 86400) date.
	self assert: -1 equals: (TimeStamp fromSeconds: -1) asSeconds!

testFromSYSTEMTIME
	| ts sysTime |
	sysTime := OS.SYSTEMTIME now.
	ts := TimeStamp fromSYSTEMTIME: sysTime.
	self assert: ts date dayOfMonth equals: sysTime wDay.
	self assert: ts date month equals: sysTime wMonth.
	self assert: ts date year equals: sysTime wYear.
	self assert: ts time hour equals: sysTime wHour.
	self assert: ts time minute equals: sysTime wMinute.
	self assert: ts time second truncated equals: sysTime wSecond.
	self assert: ts time millisecond equals: sysTime wMilliseconds.
	self assert: sysTime asTimeStamp equals: ts! !
!Core.Tests.TimeStampTest categoriesFor: #currentTimeStamp!helpers!private! !
!Core.Tests.TimeStampTest categoriesFor: #testAddSeconds!public! !
!Core.Tests.TimeStampTest categoriesFor: #testAsMilliseconds!public! !
!Core.Tests.TimeStampTest categoriesFor: #testAsSeconds!public! !
!Core.Tests.TimeStampTest categoriesFor: #testCurrentUTC!public! !
!Core.Tests.TimeStampTest categoriesFor: #testDateTime!public!unit tests! !
!Core.Tests.TimeStampTest categoriesFor: #testFromMilliseconds!public! !
!Core.Tests.TimeStampTest categoriesFor: #testFromSeconds!public! !
!Core.Tests.TimeStampTest categoriesFor: #testFromSYSTEMTIME!public! !

