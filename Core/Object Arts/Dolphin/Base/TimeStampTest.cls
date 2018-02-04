"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #TimeStampTest
	instanceVariableNames: 'current'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TimeStampTest guid: (GUID fromString: '{152f98a5-e614-445f-bb23-7db28a4d01b8}')!
TimeStampTest comment: ''!
!TimeStampTest categoriesForClass!Unclassified! !
!TimeStampTest methodsFor!

setUp
	"Remove millisecond precision."

	current := TimeStamp fromSeconds: TimeStamp current asSeconds!

testAddSeconds

	self assert: (current addSeconds: 60) = (TimeStamp fromSeconds: current asSeconds + 60).
	self assert: (current addSeconds: 60) asSeconds = (TimeStamp fromSeconds: current asSeconds + 60) asSeconds.
	self assert: (current addSeconds: 60) asMilliseconds = (TimeStamp fromSeconds: current asSeconds + 60) asMilliseconds.
	self assert: (current addSeconds: -43) = (TimeStamp fromSeconds: current asSeconds - 43).
	self assert: (current addSeconds: 24 * 60 * 60) date = (current date addDays: 1).
	self assert: (current addSeconds: -24 * 60 * 60) date = (current date subtractDays: 1)
	!

testAsMilliseconds
	
	self assert: current asMilliseconds = (current date asMilliseconds + current time asMilliseconds).
	self assert: 1 = (TimeStamp fromMilliseconds: 1) asMilliseconds.
	self deny: 1 = (TimeStamp fromMilliseconds: 2) asMilliseconds.
	self assert: 9999999999999999999999999999 = (TimeStamp fromMilliseconds: 9999999999999999999999999999) asMilliseconds!

testAsSeconds

	self assert: current asSeconds = (current date asSeconds + current time asSeconds).
	self assert: 1 = (TimeStamp fromSeconds: 1) asSeconds.
	self deny: 1 = (TimeStamp fromSeconds: 2) asSeconds.
	self assert: 99999999999999999 = (TimeStamp fromSeconds: 99999999999999999) asSeconds!

testCurrentUTC
	| bias |
	bias := Locale default timeZoneInformation last bias * 60.
	self assert: (current addSeconds: bias) time hours = TimeStamp currentUTC time hours!

testFromMilliseconds
	
	self assert: current = (TimeStamp fromMilliseconds: current asMilliseconds).
	self assert: -1 = (TimeStamp fromMilliseconds: -1) asMilliseconds.!

testFromSeconds

	self assert: current = (TimeStamp fromSeconds: current asSeconds).
	self assert: (current date addDays: 1) = (TimeStamp fromSeconds: current asSeconds + 86400) date.
	self assert: -1 = (TimeStamp fromSeconds: -1) asSeconds.!

testFromSYSTEMTIME
	| ts sysTime |
	sysTime := SYSTEMTIME now.
	ts := TimeStamp fromSYSTEMTIME: sysTime.
	self assert: ts date dayOfMonth = sysTime wDay.
	self assert: ts date monthIndex = sysTime wMonth.
	self assert: ts date year = sysTime wYear.
	self assert: ts time hours = sysTime wHour.
	self assert: ts time minutes = sysTime wMinute.
	self assert: ts time seconds = sysTime wSecond.
	self assert: ts time milliseconds = sysTime wMilliseconds! !
!TimeStampTest categoriesFor: #setUp!private! !
!TimeStampTest categoriesFor: #testAddSeconds!public! !
!TimeStampTest categoriesFor: #testAsMilliseconds!public! !
!TimeStampTest categoriesFor: #testAsSeconds!public! !
!TimeStampTest categoriesFor: #testCurrentUTC!public! !
!TimeStampTest categoriesFor: #testFromMilliseconds!public! !
!TimeStampTest categoriesFor: #testFromSeconds!public! !
!TimeStampTest categoriesFor: #testFromSYSTEMTIME!public! !

