"Filed out from Dolphin Smalltalk"!

LocaleTest subclass: #AbstractInvariantLocaleTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractInvariantLocaleTest guid: (GUID fromString: '{022d0490-a455-4948-b241-fc88c0121134}')!

AbstractInvariantLocaleTest isAbstract: true!

AbstractInvariantLocaleTest comment: ''!

!AbstractInvariantLocaleTest categoriesForClass!Unclassified! !

!AbstractInvariantLocaleTest methodsFor!

subjectName
	^self subclassResponsibility!

testDayOfWeek
	self verifyEnglishDayOfWeek: self defaultSubject!

testDayOfWeekName
	self verifyEnglishDayOfWeekNames: self defaultSubject!

testFirstDayOfWeek
	"In the US the first day of the week is Sunday, and for obvious historical reasons Smalltalk tends to follow US rules"

	self assert: self defaultSubject firstDayOfWeek equals: 7!

testIndexOfMonth
	self verifyIndexOfEnglishMonths: self defaultSubject!

testListSeparator
	self assert: self defaultSubject listSeparator isEmpty!

testMonthAbbreviations
	self verifyEnglishMonthAbbreviations: self defaultSubject!

testMonthName
	self verifyEnglishMonthNames: self defaultSubject!

testName
	self assert: self defaultSubject name equals: self subjectName!

testNamed
	self assert: (Locale named: self subjectName) identicalTo: self defaultSubject!

testNameOfDay
	self verifyEnglishNamesOfDays: self defaultSubject!

testStbRoundTrip
	| rehydrated bytes subject |
	subject := self defaultSubject.
	bytes := {subject. {subject}} binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated first identicalTo: subject.
	self assert: rehydrated second first identicalTo: subject.!

testStbRoundTripUserDefault
	| subject bytes |
	bytes := Locale userDefault binaryStoreBytes.
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject identicalTo: Locale userDefault.
	"Switch to a different default - we expect preservation of the logical user default, not the original concrete locale"
	Locale userDefault: (Locale named: 'es-ES').
	self deny: Locale userDefault equals: subject.
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject identicalTo: Locale userDefault!

testStlConvertFromVersion0
	self subclassResponsibility! !

!AbstractInvariantLocaleTest categoriesForMethods!
subjectName!constants!private! !
testDayOfWeek!public!unit tests! !
testDayOfWeekName!public!unit tests! !
testFirstDayOfWeek!public!unit tests! !
testIndexOfMonth!public!unit tests! !
testListSeparator!public!unit tests! !
testMonthAbbreviations!public!unit tests! !
testMonthName!public!unit tests! !
testName!public!unit tests! !
testNamed!public!unit tests! !
testNameOfDay!public!unit tests! !
testStbRoundTrip!public!unit tests! !
testStbRoundTripUserDefault!public!unit tests! !
testStlConvertFromVersion0!public!unit tests! !
!

