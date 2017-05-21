"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DateTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DateTest guid: (GUID fromString: '{b7ce73f6-9c8d-428d-8aae-86653eb3cf12}')!
DateTest comment: ''!
!DateTest categoriesForClass!Unclassified! !
!DateTest methodsFor!

testFromDays
	| date today |
	date := Date fromDays: 1.
	self assert: (date asDays) = 1.
	today := Date today.
	date := Date fromDays: today asDays.
	self assert: today = date!

testFromSeconds
	| date today |
	date := Date fromSeconds: 0.
	self assert: (date asDays) = 0.
	date := Date fromSeconds: 1.
	self assert: (date asDays) = 0.
	date := Date fromSeconds: 86400-1.
	self assert: (date asDays) = 0.
	date := Date fromSeconds: (86400*2)-1.
	self assert: (date asDays) = 1.
	date := Date fromSeconds: (86400*2).
	self assert: (date asDays) = 2.
	date := Date fromSeconds: -1.
	self assert: (date asDays) = -1.
	date := Date fromSeconds: -86400.
	self assert: (date asDays) = -1.
	date := Date fromSeconds: -86401.
	self assert: (date asDays) = -2.
	date := Date fromSeconds: -86400*2.
	self assert: (date asDays) = -2.
	date := Date fromSeconds: -86400*2-1.
	self assert: (date asDays) = -3.
	today := Date today.
	date := Date fromSeconds: today asSeconds.
	self assert: today = date! !
!DateTest categoriesFor: #testFromDays!public!unit tests! !
!DateTest categoriesFor: #testFromSeconds!public!unit tests! !

