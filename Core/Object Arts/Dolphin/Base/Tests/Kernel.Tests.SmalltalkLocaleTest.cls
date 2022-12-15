"Filed out from Dolphin Smalltalk"!

Core.Tests.LocaleTest subclass: #'Kernel.Tests.SmalltalkLocaleTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.SmalltalkLocaleTest guid: (Core.GUID fromString: '{0a445b92-78d1-4c9c-a3f4-7be49f0c2932}')!
Kernel.Tests.SmalltalkLocaleTest comment: ''!
!Kernel.Tests.SmalltalkLocaleTest methodsFor!

defaultSubject
	^Locale smalltalk!

testDayOfWeek
	self verifyEnglishDayOfWeek: self defaultSubject!

testDayOfWeekName
	self verifyEnglishDayOfWeekNames: self defaultSubject!

testDisplayFloatOn
	| subject |
	subject := self defaultSubject.
	{{Float infinity. 'Float.Infinity'}.
		{Float negativeInfinity. 'Float.NegativeInfinity'}.
		{Float nan. 'Float.NaN'}.
		{Float fmax. '1.7976931348623157e308'}.
		{Float fmin. '5.0e-324'}.
		{0.0. '0.0'}.
		{-0.0. '-0.0'}.
		{1.25. '1.25'}.
		{-1.25. '-1.25'}.
		{123456.7. '123456.7'}.
		{-123456.7. '-123456.7'}.
		{1234567.8. '1.2345678e6'}.
		{-1234567.8. '-1.2345678e6'}.
		{0.1. '0.1'}.
		{0.0001. '0.0001'}.
		{-0.0001. '-0.0001'}.
		{0.00001. '1.0e-5'}.
		{-0.00001. '-1.0e-5'}.
		{1.25e22. '1.25e22'}.
		{50000000000001.25. '5.000000000000125e13'}} do: 
				[:each |
				| actual |
				actual := each first displayString: subject.
				self assert: actual equals: each second]!

testFirstDayOfWeek
	"In the US the first day of the week is Sunday, and for obvious historical reasons Smalltalk tends to follow US rules"

	self assert: self defaultSubject firstDayOfWeek equals: 7!

testIndexOfMonth
	self verifyIndexOfEnglishMonths: self defaultSubject!

testListSeparator
	self assert: self defaultSubject listSeparator isEmpty!

testLowercaseString
	| subject |
	subject := self defaultSubject.
	self assert: (subject lowercaseString: '') equals: ''.
	"Upper-case german eszett is not converted by Smalltalk Locale, which uses ordinal conversions."
	self assert: (subject lowercaseString: 'STRAẞE') equals: 'straẞe'.
	"Turkish dotted and non-dotted i; invariant lowercase-i is always dotted, turkish dotted uppercase-i unconverted by ordinal conversion"
	self assert: (subject lowercaseString: 'INTERESTİNG') equals: 'interestİng'!

testMonthAbbreviations
	self verifyEnglishMonthAbbreviations: self defaultSubject!

testMonthName
	self verifyEnglishMonthNames: self defaultSubject!

testName
	self assert: self defaultSubject name equals: 'smalltalk'!

testNamed
	self assert: (Locale named: #Smalltalk) identicalTo: self defaultSubject!

testNameOfDay
	self verifyEnglishNamesOfDays: self defaultSubject!

testPrintFloatGrouping
	"Test printing with different number grouping."

	| subject format |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	format
		grouping: 3;
		decimalPlaces: 1.
	"The SmalltalkLocale doesn't support grouping"
	self assert: (subject printFloat: 1234567890.0 format: format) equals: '1234567890.0'!

testPrintFloatSeparators
	"Test printing with different number grouping."

	| subject format |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	"The SmalltalkLocale doesn't support grouping so the grouping separator has no effect"
	format
		decimalPlaces: 3;
		decimalSeparator: $@;
		thousandSeparator: $^.
	self assert: (subject printFloat: 1234567890.123 format: format) equals: '1234567890@123'!

testStbConvertFromVersion0
	| subject |
	"From: | obj | obj := Object new. {Locale invariant. obj. {Locale invariant}. #foo. obj} literalStoreEvaluationString"
	subject := Object fromLiteralStoreArray: #(#'!!STL' 4 34 5 983302 ##(Smalltalk.SmalltalkLocale) nil 393222 ##(Smalltalk.Object) 34 1 432 #foo 464).
	"We expect a newly constructed instance with the same lcid, but the other data is discarded"
	self assert: subject first identicalTo: self defaultSubject.
	self assert: subject third first identicalTo: self defaultSubject.
	self assert: subject fourth identicalTo: #foo.
	self assert: subject second identicalTo: subject last!

testStbRoundTrip
	| rehydrated bytes subject |
	subject := self defaultSubject.
	bytes := {subject. {subject}} binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated first identicalTo: subject.
	self assert: rehydrated second first identicalTo: subject.!

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
	"Turkish uppercase dotted-i; invariant uppercase-i always non-dotted, turkish dotless-lowercase-i unconverted by ordinal conversion"
	self assert: (subject uppercaseString: 'ınteresting') equals: 'ıNTERESTING'.

	"There are two lower-case forms of the greek letter Sigma - one of these won't translate with a non-linguistic conversion, such as String>>asUppercase"
	self assert: (subject uppercaseString: 'Ὀδυσσεύς') equals: 'ὈΔΥΣΣΕΎς'


! !
!Kernel.Tests.SmalltalkLocaleTest categoriesForMethods!
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
testTitlecaseString!public!unit tests! !
testUppercaseString!public!unit tests! !
!

