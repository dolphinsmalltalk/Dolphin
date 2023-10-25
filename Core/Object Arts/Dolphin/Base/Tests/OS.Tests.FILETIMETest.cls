"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.FILETIMETest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.FILETIMETest guid: (Core.GUID fromString: '{60160261-ed86-485b-834c-ef305dad3be9}')!
OS.Tests.FILETIMETest comment: ''!
!OS.Tests.FILETIMETest methodsFor!

assertFromIntegerInvertible: anInteger
	self assert: (FILETIME fromInteger: anInteger) asInteger equals: (anInteger bitAnd: 2 ** 64 - 1)!

testAsDateAndTime
	| epoch subject dt |
	epoch := DateAndTime
				year: 1601
				day: 1
				offset: 0 seconds.
	subject := FILETIME new.
	self assert: subject printString equals: 'a FILETIME( 1601-01-01T00:00:00+00:00)'.
	self assert: subject asDateAndTime equals: epoch.
	"We are only checking here for TZ issues, so use a fairly coarse comparison."
	subject := FILETIME now.
	dt := DateAndTime now.
	self assert: dt - subject asDateAndTime < 1 minutes!

testDisplayString
	| now |
	now := DateAndTime now.
	"displayString should always be in local time"
	self assert: (FILETIME fromDateAndTime: now) displayString equals: now displayString.
	self assert: (LocalFILETIME fromDateAndTime: now) displayString equals: now displayString!

testFromDateAndTime
	| subject dt local |
	subject := FILETIME fromDateAndTime: (DateAndTime
						year: 1601
						day: 1
						offset: 0 seconds).
	self assert: subject asInteger equals: 0.
	dt := DateAndTime utcSeconds: 3199117153 offset: 3600.
	subject := FILETIME fromDateAndTime: dt.
	self assert: subject asInteger equals: 126661379530000000.
	local := LocalFILETIME fromDateAndTime: dt.
	self assert: local asUTC equals: subject!

testFromInteger
	self assertFromIntegerInvertible: 126661379535479952.
	self assertFromIntegerInvertible: 0.
	self assertFromIntegerInvertible: SmallInteger maximum.
	self assertFromIntegerInvertible: 2 ** 32 - 1.
	self assertFromIntegerInvertible: 2 ** 32.
	self assertFromIntegerInvertible: 2 ** 32 + 1.
	self assertFromIntegerInvertible: 2 ** 64 - 1.
	self should: [FILETIME fromInteger: 2 ** 64] raise: Error.
	self assertFromIntegerInvertible: -1.
	self assertFromIntegerInvertible: -2 ** 31.
	self assertFromIntegerInvertible: -2 ** 32.
	self assertFromIntegerInvertible: -2 ** 63!

testFromSYSTEMTIME
	| subject sysTime dt |
	dt := DateAndTime fromString: '2020-02-29T12:01:02.125+01:00'.
	sysTime := dt asSYSTEMTIME.
	subject := FILETIME fromSYSTEMTIME: sysTime.
	self assert: subject asDateAndTime equals: dt.
	subject := LocalFILETIME fromSYSTEMTIME: sysTime.
	self assert: subject asDateAndTime equals: dt!

testFromUnixTime
	| subject |
	subject := FILETIME fromUnixTime: 3.
	self assert: subject printString equals: 'a FILETIME( 1970-01-01T00:00:03+00:00)'!

testPrintString
	| now |
	now := DateAndTime now.
	self assert: (FILETIME fromDateAndTime: now) printString equals: 'a FILETIME(<1p>)' << now asUTC.
	self assert: (LocalFILETIME fromDateAndTime: now) printString equals: 'a LocalFILETIME(<1p>)' << now! !
!OS.Tests.FILETIMETest categoriesForMethods!
assertFromIntegerInvertible:!helpers!private! !
testAsDateAndTime!public!unit tests! !
testDisplayString!public!unit tests! !
testFromDateAndTime!public!unit tests! !
testFromInteger!public!unit tests! !
testFromSYSTEMTIME!public!unit tests! !
testFromUnixTime!public!unit tests! !
testPrintString!public!unit tests! !
!

