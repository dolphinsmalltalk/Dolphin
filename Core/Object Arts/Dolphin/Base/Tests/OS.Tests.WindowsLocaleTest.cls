"Filed out from Dolphin Smalltalk"!

Core.Tests.LocaleTest subclass: #'OS.Tests.WindowsLocaleTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.WindowsLocaleTest guid: (Core.GUID fromString: '{1cc6ee0d-11ce-44fd-940d-7126f73516ba}')!
OS.Tests.WindowsLocaleTest comment: ''!
!OS.Tests.WindowsLocaleTest methodsFor!

defaultSubject
	^Locale standard: 'en-GB'!

testComparing
	| subject subject2 |
	subject := self defaultSubject.
	self assert: subject noUserOverrides.
	subject2 := subject copy.
	self assert: subject equals: subject2.
	self assert: subject hash equals: subject2 hash.
	{Locale invariant. Locale smalltalk. Locale standard: 'es-ES'} do: 
			[:each |
			self deny: subject equals: each.
			self deny: subject equals: Locale invariant hash].
	"WindowsLocale with user-override suppression is not equal to the same named WindowsLocale without override suppression"
	self deny: subject equals: (Locale named: subject name)!

testDayOfWeek
	| subject |
	subject := Locale named: 'tr-Tr'.
	self assert: ((1 to: 7) collect: [:i | subject dayOfWeekName: i]) equals: #('Pazar' 'Pazartesi' 'Salı' 'Çarşamba' 'Perşembe' 'Cuma' 'Cumartesi').
	#('en-US' 'en-GB') do: [:each | self verifyEnglishDayOfWeek: (Locale named: each)]!

testDayOfWeekName
	| subject |
	subject := Locale named: 'tr-Tr'.
	#('Pazartesi' 2 'PAZARTESİ' 2 'Salı' 3 'SALI' 3)
		pairsDo: [:day :index | self assert: (subject dayOfWeek: day) equals: index].
	#('en-US' 'en-GB') do: [:each | self verifyEnglishDayOfWeekNames: (Locale named: each)]!

testDisplayFloatOn
	| subject |
	{{Locale standard: 'en-GB'.
			{{Float infinity. '∞'}.
				{Float negativeInfinity. '-∞'}.
				{Float nan. 'NaN'}.
				{0.0. '0.00'}.
				{-0.0. '0.00'}.
				{1.25. '1.25'}.
				{-1.25. '-1.25'}.
				{0.095. '0.10'}.
				{-0.095. '-0.10'}.
				{-0.605. '-0.60'}.
				{-0.606. '-0.61'}.
				{0.0009. '0.00'}.
				{-0.0009. '0.00'}.
				{Float fmax.
					'179,769,313,486,231,570,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000.00'}.
				{Float fmin. '0.00'}.
				{123456.789. '123,456.79'}.
				{-123456.789. '-123,456.79'}.
				{1234567.89. '1,234,567.89'}.
				{-1234567.89. '-1,234,567.89'}.
				{1.25e22. '12,500,000,000,000,000,000,000.00'}}}.
		{Locale standard: 'es-ES_tradnl'.
			{{Float infinity. 'Infinito'}.
				{Float negativeInfinity. '-Infinito'}.
				{Float nan. 'NeuN'}.
				{0.0. '0,00'}.
				{0.0. '0,00'}.
				{1.25. '1,25'}.
				{-1.25. '-1,25'}.
				{0.095. '0,10'}.
				{-0.095. '-0,10'}.
				{-0.605. '-0,60'}.
				{-0.606. '-0,61'}.
				{0.0001. '0,00'}.
				{-0.0001. '0,00'}.
				{Float fmax.
					'179.769.313.486.231.570.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000,00'}.
				{Float fmin. '0,00'}.
				{123456.7. '123.456,70'}.
				{-123456.7. '-123.456,70'}.
				{1234567.89. '1.234.567,89'}.
				{-1234567.89. '-1.234.567,89'}.
				{1.25e22. '12.500.000.000.000.000.000.000,00'}.
				{50000000000001.25. '50.000.000.000.001,25'}}}}
			do: 
				[:each |
				| actual |
				subject := each first.
				each second do: 
						[:pair |
						actual := pair first displayString: subject.
						self assert: actual equals: pair second]]!

testDisplayFloatOnNegativeModes
	| subject format |
	"Different negative number mode (2)"
	subject := Locale standard: 'hr-HR'.
	self assert: (subject printFloat: -0.0) equals: '0,00'.
	self assert: (subject printFloat: -1.25) equals: '- 1,25'.
	self assert: (subject printFloat: -0.0001) equals: '0,00'.
	self assert: (subject printFloat: -123456789.123456789) equals: '- 123.456.789,12'.
	"Negative infinity does not seem to be represented consistently with respect to the normal negative sign conventions in this locale. The value is direct from Windows"
	self assert: (subject printFloat: Float negativeInfinity) equals: '-∞'.

	"Different negative number mode (3)"
	subject := Locale standard: 'fa-IR'.
	self assert: (subject printFloat: -0.0) equals: '0/00'.
	self assert: (subject printFloat: -1.25) equals: '1/25-'.
	self assert: (subject printFloat: -0.0001) equals: '0/00'.
	self assert: (subject printFloat: -123456789.123456789) equals: '123,456,789/12-'.
	"Ditto re: Negative infinity, which is supplied by Windows with an inconsistent representation."
	self assert: (subject printFloat: Float negativeInfinity) equals: '-∞'.

	"Fake up the other modes - zero is bracketed"
	subject := Locale standard: 'en-US'.
	format := subject numberFormat copy.
	format negativeNumberMode: 0.
	self assert: (subject printFloat: -0.0 format: format) equals: '0.00'.
	self assert: (subject printFloat: -1.25 format: format) equals: '(1.25)'.
	self assert: (subject printFloat: -0.0001 format: format) equals: '0.00'.
	self assert: (subject printFloat: -123456789.123456789 format: format) equals: '(123,456,789.12)'.

	"Mode 4 is trailing minus after space"
	format negativeNumberMode: 4.
	self assert: (subject printFloat: -0.0 format: format) equals: '0.00'.
	self assert: (subject printFloat: -1.25 format: format) equals: '1.25 -'.
	self assert: (subject printFloat: -0.0001 format: format) equals: '0.00'.
	self assert: (subject printFloat: -123456789.123456789 format: format) equals: '123,456,789.12 -'!

testEnglishName
	#('smalltalk' 'English' 'en-US' 'English' 'en-GB' 'English' 'es-ES_tradnl' 'Spanish' 'cy-GB' 'Welsh' 'es-AR' 'Spanish')
		pairsDo: [:lcid :language | self assert: (Locale named: lcid) englishLanguageName equals: language]!

testFirstDayOfWeek
	"Test that the Windows 'First day of week' setting is correctly decoded. We have to be careful to ignore user overrides as this test relies on the standard configurations."

	"In the US the first day of the week is traditionally Sunday."

	self assert: (Locale standard: 'en-US') firstDayOfWeek equals: 7.
	"In the UK the first day of the week is traditionally Monday"
	self assert: (Locale standard: 'en-GB') firstDayOfWeek equals: 1!

testIndexOfMonth
	| subject |
	subject := Locale named: 'tr-Tr'.
	#('Ekim' 10 'EKİM' 10 'Mayıs' 5 'MAYIS' 5 'Nis' 4 'NİS' 4 'Ağu' 8)
		pairsDo: [:month :index | self assert: (subject indexOfMonth: month) equals: index].
	#('en-US' 'en-GB') do: [:each | self verifyIndexOfEnglishMonths: (Locale named: each)]!

testListSeparator
	| subject |
	subject := Locale named: 'fr-FR'.
	self assert: subject listSeparator equals: ';'!

testLongDateFormats
	self assert: ((Locale standard: 'en-US') longDateFormats includes: 'MMMM dd, yyyy').
	self assert: ((Locale standard: 'en-GB') longDateFormats includes: 'dd MMMM yyyy')!

testLowercaseString
	| subject |
	subject := Locale named: 'de-DE'.
	self assert: (subject lowercaseString: '') equals: ''.
	self assert: (subject lowercaseString: 'STRAẞE') equals: 'straße'.
	"Turkish dotted and non-dotted i"
	subject := Locale named: 'tr-TR'.
	self assert: (subject lowercaseString: 'INTERESTİNG') equals: 'ınteresting'!

testMonthAbbreviation
	#('en-US' 'en-GB') do: [:each | self verifyEnglishMonthAbbreviations: (Locale named: each)]!

testMonthName
	#('en-US' 'en-GB') do: [:each | self verifyEnglishMonthNames: (Locale named: each)]!

testName
	#(1033 'en-US' 2057 'en-GB' 1106 'cy-GB' 11274 'es-AR')
		pairsDo: [:lcid :name | self assert: (Locale lcid: lcid) name equals: name]!

testNamed
	self assert: (Locale named: 'cy-GB') lcid equals: 1106!

testNameOfDay
	| subject |
	subject := Locale named: 'tr-Tr'.
	self assert: ((1 to: 7) collect: [:i | subject nameOfDay: i]) equals: #('Pazartesi' 'Salı' 'Çarşamba' 'Perşembe' 'Cuma' 'Cumartesi' 'Pazar').
	#('en-US' 'en-GB') do: [:each | self verifyEnglishNamesOfDays: (Locale named: each)]!

testNoUserOverrides
	self assert: self defaultSubject noUserOverrides!

testPrintFloatGrouping
	"Test printing with different number grouping."

	self verifyPrintFloatGrouping!

testPrintFloatSeparators
	"Test printing with different number grouping."

	self verifyPrintFloatSeparators!

testPrintNoLeadingZero
	| subject format |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	format hasLeadingZero: false.
	self assert: (subject printFloat: 1234567890.123 format: format) equals: '1,234,567,890.12'.
	self assert: (subject printFloat: 0.123 format: format) equals: '.12'!

testStbConvertFromVersion0
	| subject |
	subject := (Object fromLiteralStoreArray: #(#'!!STL' 4 852742 ##(Smalltalk.WindowsLocale) 656390 ##(Smalltalk.NUMBERFMTW) 8 #[2 0 0 0 1 0 0 0 3 0 0 0 96 28 20 15 176 75 20 15 1 0 0 0] 8 '.' nil 8 ',' 4115 170 192 34 14 35 5 31 8 ',' 8225 3 185 8 'en-GB' 37 3 33 8 '3;0' 29 8 '.')).
	"We expect a newly constructed instance with the same lcid, but the other data is discarded"
	self assert: subject lcid equals: 2057.
	self assertIsNil: (subject instVarNamed: 'numberFormat').
	self assert: (subject instVarNamed: 'info') isEmpty!

testStbRoundTrip
	| subject bytes rehydrated |
	subject := self defaultSubject.
	bytes := {subject. {subject}} binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated first equals: subject.
	self assert: rehydrated second first identicalTo: rehydrated first!

testStbRoundTripDefault
	| subject bytes |
	bytes := Locale userDefault binaryStoreBytes.
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject identicalTo: Locale userDefault.
	"Switch to a different default - we expect preservation of the logical user default, not the original concrete locale"
	Locale userDefault: (Locale named: 'es-ES').
	self deny: Locale userDefault equals: subject.
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject identicalTo: Locale userDefault!

testStbRoundTripSystemDefault
	| subject bytes |
	self deny: Locale systemDefault equals: Locale userDefault.
	bytes := Locale systemDefault binaryStoreBytes.
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject identicalTo: Locale systemDefault!

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
	subject := Locale named: 'tr-Tr'.
	self assert: (subject titlecaseString: 'istanbul') equals: 'İstanbul'.
	subject := Locale named: 'en-GB'.
	self assert: (subject titlecaseString: 'istanbul') equals: 'Istanbul'.!

testUppercaseString
	| subject |
	subject := Locale named: 'de-DE'.
	self assert: (subject uppercaseString: '') equals: ''.
	"There are two lower-case forms of the greek letter Sigma."
	self assert: (subject uppercaseString: 'Ὀδυσσεύς') equals: 'ὈΔΥΣΣΕΎΣ'.

	"Note that although there is a Unicode uppercase eszett, the Windows LCMapString API's linguistic conversion for de-DE does not recognise it. This is either because it is a relatively new addition to Unicode, or because its use in case translations is open to debate."
	self deny: (subject uppercaseString: 'Straße') equals: 'STRAẞE'.
	self assert: (subject uppercaseString: 'Straße') equals: 'STRAßE'.
	"Turkish dotted and dotless i should be converted correctly preserved the dot or absence of dot"
	subject := Locale named: 'tr-TR'.
	self assert: (subject uppercaseString: 'ınteresting') equals: 'INTERESTİNG'! !
!OS.Tests.WindowsLocaleTest categoriesForMethods!
defaultSubject!helpers!private! !
testComparing!public!unit tests! !
testDayOfWeek!public!unit tests! !
testDayOfWeekName!public!unit tests! !
testDisplayFloatOn!public!unit tests! !
testDisplayFloatOnNegativeModes!public!unit tests! !
testEnglishName!public!unit tests! !
testFirstDayOfWeek!public!unit tests! !
testIndexOfMonth!public!unit tests! !
testListSeparator!public!unit tests! !
testLongDateFormats!public!unit tests! !
testLowercaseString!public!unit tests! !
testMonthAbbreviation!public!unit tests! !
testMonthName!public!unit tests! !
testName!public!unit tests! !
testNamed!public!unit tests! !
testNameOfDay!public!unit tests! !
testNoUserOverrides!public!unit tests! !
testPrintFloatGrouping!public!unit tests! !
testPrintFloatSeparators!public!unit tests! !
testPrintNoLeadingZero!public!unit tests! !
testStbConvertFromVersion0!public!unit tests! !
testStbRoundTrip!public!unit tests! !
testStbRoundTripDefault!public!unit tests! !
testStbRoundTripSystemDefault!public!unit tests! !
testStbRoundTripUserDefault!public!unit tests! !
testTitlecaseString!public!unit tests! !
testUppercaseString!public!unit tests! !
!

