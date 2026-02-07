"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.COM.Tests.DATEArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.DATEArrayTest guid: (Core.GUID fromString: '{4f0cc47f-b29c-4ea5-9d71-862c2a5125ce}')!

OS.COM.Tests.DATEArrayTest comment: ''!

!OS.COM.Tests.DATEArrayTest methodsFor!

elementToValue: element 
	^element asLocal!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating.
	self assert: subject printString
		equals: 'a <1p>(<2p> <3p> <4p> <5p> <6p> <7p>)'
				<< ({ self arrayClass } , ((1 to: 6) collect: [:i | self canonicalizeValue: i])).
	^self! !

!OS.COM.Tests.DATEArrayTest categoriesForMethods!
elementToValue:!helpers!private! !
testSelfEvaluating!public!unit tests! !
!

!OS.COM.Tests.DATEArrayTest class methodsFor!

arrayClass
	^DATEArray!

elementFromIndex: anInteger
	^##({
		DateAndTime
			rataDie: DATE.EpochRD
			seconds: 0
			offsetSeconds: 0.
		DateAndTime
			rataDie: DATE.MinValue truncated + DATE.EpochRD
			seconds: DATE.MinValue fractionPart negated * 86400
			offsetSeconds: 0.
		DateAndTime
			year: 100
			month: 1
			day: 1
			offset: 0 seconds.
		DateAndTime
			rataDie: DATE.MaxValue truncated + DATE.EpochRD
			seconds: DATE.MaxValue fractionPart * 86400
			offsetSeconds: 0.
		DateAndTime
			year: 1899
			month: 12
			day: 30
			offset: 0 seconds.
		DateAndTime
			rataDie: 730179
			seconds: 86399.99995976686
			offsetSeconds: 0.
		DateAndTime
			year: 1601
			month: 1
			day: 1
			offset: 0 seconds
	}) at: anInteger! !

!OS.COM.Tests.DATEArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
!

