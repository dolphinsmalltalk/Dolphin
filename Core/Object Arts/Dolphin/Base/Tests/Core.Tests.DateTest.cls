"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.DateTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DateTest guid: (Core.GUID fromString: '{b7ce73f6-9c8d-428d-8aae-86653eb3cf12}')!
Core.Tests.DateTest comment: ''!
!Core.Tests.DateTest categoriesForClass!Unclassified! !
!Core.Tests.DateTest methodsFor!

testFromDays
	| date today originalMethod testMethod date2 |
	date := Date fromDays: 1.
	self assert: date asDays equals: 1.
	today := Date today.
	date := Date fromDays: today asDays.
	self assert: today equals: date.
	originalMethod := Date class compiledMethodAt: #fromDays:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	date2 := testMethod value: Date withArguments: {today asDays}.
	self assert: date2 equals: today!

testFromSeconds
	| date today dtNow now |
	date := Date fromSeconds: 0.
	self assert: date asDays equals: 0.
	date := Date fromSeconds: 1.
	self assert: date asDays equals: 0.
	date := Date fromSeconds: 86400 - 1.
	self assert: date asDays equals: 0.
	date := Date fromSeconds: 86400 * 2 - 1.
	self assert: date asDays equals: 1.
	date := Date fromSeconds: 86400 * 2.
	self assert: date asDays equals: 2.
	date := Date fromSeconds: -1.
	self assert: date asDays equals: -1.
	date := Date fromSeconds: -86400.
	self assert: date asDays equals: -1.
	date := Date fromSeconds: -86401.
	self assert: date asDays equals: -2.
	date := Date fromSeconds: -86400 * 2.
	self assert: date asDays equals: -2.
	date := Date fromSeconds: -86400 * 2 - 1.
	self assert: date asDays equals: -3.
	today := Date today.
	date := Date fromSeconds: today asSeconds.
	self assert: today equals: date.
	dtNow := DateAndTime nowUTC.
	now := Date fromSeconds: dtNow asSeconds.
	self assert: now year equals: dtNow year.
	self assert: now month equals: dtNow month.
	self assert: now dayOfMonth equals: dtNow dayOfMonth!

testStoreOn
	| subject stored collection |
	subject := Date today.
	collection := OrderedCollection with: subject
				with: (Date
						year: -2000
						month: 2
						day: 29).
	stored := collection storeString.
	self assert: (Compiler evaluate: stored) equals: collection!

testYyyymmdd
	| subject |
	subject := Date
				newDay: 1
				monthIndex: 2
				year: 3.
	self assert: subject yyyymmdd equals: '0003-02-01'.
	subject := Date
				year: -5
				month: 2
				day: 28.
	self assert: subject yyyymmdd equals: '-0005-02-28'! !
!Core.Tests.DateTest categoriesFor: #testFromDays!public!unit tests! !
!Core.Tests.DateTest categoriesFor: #testFromSeconds!public!unit tests! !
!Core.Tests.DateTest categoriesFor: #testStoreOn!public!testing! !
!Core.Tests.DateTest categoriesFor: #testYyyymmdd!public!unit tests! !

