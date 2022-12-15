"Filed out from Dolphin Smalltalk"!

Core.Tests.LocaleTest subclass: #'OS.Tests.InvariantLocaleTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.InvariantLocaleTest guid: (Core.GUID fromString: '{297397a3-1ee2-48b4-b815-f58a5308bc8c}')!
OS.Tests.InvariantLocaleTest comment: ''!
!OS.Tests.InvariantLocaleTest methodsFor!

defaultSubject
	^Locale invariant!

testDayOfWeek
	self verifyEnglishDayOfWeek: self defaultSubject!

testDayOfWeekName
	self verifyEnglishDayOfWeekNames: self defaultSubject!

testDisplayFloatOn
	| subject |
	subject := self defaultSubject.
	{{Float infinity. 'Infinity'}.
		{Float negativeInfinity. '-Infinity'}.
		{Float nan. 'NaN'}.
		{Float fmax.
			'179,769,313,486,231,570,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000.00'}.
		{Float fmin. '0.00'}.
		{0.0. '0.00'}.
		{-0.0. '0.00'}.
		{1.25. '1.25'}.
		{-1.25. '-1.25'}.
		{123456.7. '123,456.70'}.
		{-123456.7. '-123,456.70'}.
		{1234567.8. '1,234,567.80'}.
		{-1234567.8. '-1,234,567.80'}.
		{0.1. '0.10'}.
		{0.0001. '0.00'}.
		{-0.0001. '0.00'}.
		{0.00001. '0.00'}.
		{-0.00001. '0.00'}.
		{1.25e22. '12,500,000,000,000,000,000,000.00'}.
		{50000000000001.25. '50,000,000,000,001.25'}} do: 
				[:each |
				| actual |
				actual := each first displayString: subject.
				self assert: actual equals: each second]!

testFirstDayOfWeek
	"The Invariant locale generally follows US conventions"

	self assert: self defaultSubject firstDayOfWeek equals: 7!

testIndexOfMonth
	self verifyIndexOfEnglishMonths: self defaultSubject!

testListSeparator
	self assert: self defaultSubject listSeparator equals: ','!

testLowercaseString
	| subject |
	subject := self defaultSubject.
	self assert: (subject lowercaseString: '') equals: ''.
	"Upper-case german eszett is converted by invariant Locale as it still requests linguistic case translations, and the letter is only used in German so is not ambiguous."
	self assert: (subject lowercaseString: 'STRAẞE') equals: 'straße'.
	"Turkish dotted and non-dotted i; invariant lowercase-i is always dotted"
	self assert: (subject lowercaseString: 'INTERESTİNG') equals: 'interesting'!

testMonthAbbreviations
	self verifyEnglishMonthAbbreviations: self defaultSubject!

testMonthName
	self verifyEnglishMonthNames: self defaultSubject!

testName
	self assert: self defaultSubject name equals: 'invariant'!

testNamed
	self assert: (Locale named: 'Invariant') identicalTo: self defaultSubject!

testNameOfDay
	self verifyEnglishNamesOfDays: self defaultSubject!

testPrintFloatGrouping
	"Test printing with different number grouping."

	self verifyPrintFloatGrouping!

testPrintFloatSeparators
	"Test printing with different number grouping."

	self verifyPrintFloatSeparators!

testStbConvertFromVersion0
	| subject |
	"From: | obj | obj := Object new. {Locale invariant. obj. {Locale invariant}. #foo. obj} literalStoreEvaluationString"
	subject := (Object fromLiteralStoreArray: #(#'!!STL' 4 34 5 852742 ##(Smalltalk.WindowsLocale) nil 255 170 192 34 12 125 8 'July' 185 8 '' 29 8 '.' 127 8 'August' 123 8 'June' 5 8 'Invariant Language (Invariant Country)' 393222 ##(Smalltalk.Object) 34 1 432 #foo 592)).
	"We expect a newly constructed instance with the same lcid, but the other data is discarded"
	self assert: subject first identicalTo: Locale invariant.
	self assert: subject third first identicalTo: Locale invariant.
	self assert: subject fourth identicalTo: #foo.
	self assert: subject second identicalTo: subject last.!

testStbRoundTrip
	| subject bytes |
	bytes := self defaultSubject binaryStoreBytes.
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject identicalTo: Locale invariant!

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

testTitlecaseString
	| subject |
	subject := self defaultSubject.
	"The invariant locale does perform linguistic case conversions, but only the turkic locales recognise the disinction between dotted and dotless 'i'"
	self assert: (subject titlecaseString: 'istanbul') equals: 'Istanbul'!

testUppercaseString
	| subject |
	subject := self defaultSubject.
	self assert: (subject uppercaseString: '') equals: ''.
	self assert: (subject uppercaseString: 'Straße') equals: 'STRAßE'.
	"Turkish uppercase dotted-i; invariant uppercase-i always non-dotted"
	self assert: (subject uppercaseString: 'ınteresting') equals: 'INTERESTING'.
	"There are two lower-case forms of the greek letter Sigma."
	self assert: (subject uppercaseString: 'Ὀδυσσεύς') equals: 'ὈΔΥΣΣΕΎΣ'.
!

verifyPrintFloatSeparators
	| format subject |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	format
		decimalPlaces: 3;
		grouping: 43;
		decimalSeparator: $@;
		thousandSeparator: $^.
	self assert: (subject printFloat: 1234567890.123 format: format) equals: '123^456^7890@123'! !
!OS.Tests.InvariantLocaleTest categoriesForMethods!
defaultSubject!helpers!private! !
testDayOfWeek!public!unit tests! !
testDayOfWeekName!public!unit tests! !
testDisplayFloatOn!public!unit tests! !
testFirstDayOfWeek!public!unit tests! !
testIndexOfMonth!public!unit tests! !
testListSeparator!public!unit tests! !
testLowercaseString!public!unit tests! !
testMonthAbbreviations!public!unit tests! !
testMonthName!public!unit tests! !
testName!public!unit tests! !
testNamed!public!unit tests! !
testNameOfDay!public!unit tests! !
testPrintFloatGrouping!public!unit tests! !
testPrintFloatSeparators!public!unit tests! !
testStbConvertFromVersion0!public!unit tests! !
testStbRoundTrip!public!unit tests! !
testStbRoundTripUserDefault!public!unit tests! !
testTitlecaseString!public!unit tests! !
testUppercaseString!public!unit tests! !
verifyPrintFloatSeparators!helpers!private! !
!

