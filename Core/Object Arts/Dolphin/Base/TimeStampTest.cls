"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #TimeStampTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TimeStampTest guid: (GUID fromString: '{152f98a5-e614-445f-bb23-7db28a4d01b8}')!
TimeStampTest comment: ''!
!TimeStampTest categoriesForClass!Unclassified! !
!TimeStampTest methodsFor!

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
	self deny: 1 = (TimeStamp fromMilliseconds: 2) asMilliseconds.
	self assert: 9999999999999999999999999999
		equals: (TimeStamp fromMilliseconds: 9999999999999999999999999999) asMilliseconds!

testAsSeconds
	| current |
	current := self currentTimeStamp.
	self assert: current asSeconds equals: current date asSeconds + current time asSeconds.
	self assert: 1 equals: (TimeStamp fromSeconds: 1) asSeconds.
	self deny: 1 = (TimeStamp fromSeconds: 2) asSeconds.
	self assert: 99999999999999999 equals: (TimeStamp fromSeconds: 99999999999999999) asSeconds!

testCurrentUTC
	| bias current |
	current := self currentTimeStamp.
	bias := Locale default timeZoneInformation currentBias * 60.
	self assert: (current addSeconds: bias) time hours equals: TimeStamp currentUTC time hours!

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
	sysTime := SYSTEMTIME now.
	ts := TimeStamp fromSYSTEMTIME: sysTime.
	self assert: ts date dayOfMonth equals: sysTime wDay.
	self assert: ts date monthIndex equals: sysTime wMonth.
	self assert: ts date year equals: sysTime wYear.
	self assert: ts time hours equals: sysTime wHour.
	self assert: ts time minutes equals: sysTime wMinute.
	self assert: ts time seconds equals: sysTime wSecond.
	self assert: ts time milliseconds equals: sysTime wMilliseconds! !
!TimeStampTest categoriesFor: #currentTimeStamp!helpers!private! !
!TimeStampTest categoriesFor: #testAddSeconds!public! !
!TimeStampTest categoriesFor: #testAsMilliseconds!public! !
!TimeStampTest categoriesFor: #testAsSeconds!public! !
!TimeStampTest categoriesFor: #testCurrentUTC!public! !
!TimeStampTest categoriesFor: #testFromMilliseconds!public! !
!TimeStampTest categoriesFor: #testFromSeconds!public! !
!TimeStampTest categoriesFor: #testFromSYSTEMTIME!public! !

