"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.Tests.FILETIMEArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.FILETIMEArrayTest guid: (Core.GUID fromString: '{e2d25c19-214a-45a1-8085-922d3f37385d}')!

OS.Tests.FILETIMEArrayTest comment: ''!

!OS.Tests.FILETIMEArrayTest methodsFor!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating.
	self assert: subject printString
		equals: 'a FILETIMEArray( 1601-01-01T00:00:00+00:00  1901-01-01T00:00:00+00:00  1970-01-01T00:00:00+00:00  2026-01-25T12:58:17.1234567+00:00  30828-09-14T02:48:05.4775807+00:00  1900-12-31T23:59:59.9999999+00:00)'! !

!OS.Tests.FILETIMEArrayTest categoriesForMethods!
testSelfEvaluating!public! !
!

!OS.Tests.FILETIMEArrayTest class methodsFor!

arrayClass
	^FILETIMEArray!

elementFromIndex: anInteger
	^{
		DateAndTime
			year: 1601
			month: 1
			day: 1
			offset: 0 seconds.
		DateAndTime
			year: 1901
			month: 1
			day: 1
			offset: 0 seconds.
		DateAndTime
			year: 1970
			month: 1
			day: 1
			offset: 0 seconds.
		DateAndTime fromString: '2026-01-25T12:58:17.1234567Z'.
		DateAndTime utcSeconds: 9128701828854775807 / 10000000.
		(DateAndTime
			year: 1901
			month: 1
			day: 1
			offset: 0 seconds) - 100 nanoseconds
	} at: anInteger! !

!OS.Tests.FILETIMEArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
!

