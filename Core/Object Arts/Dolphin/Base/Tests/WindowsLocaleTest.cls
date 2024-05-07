"Filed out from Dolphin Smalltalk"!

LocaleTest subclass: #WindowsLocaleTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WindowsLocaleTest guid: (GUID fromString: '{1cc6ee0d-11ce-44fd-940d-7126f73516ba}')!

WindowsLocaleTest comment: ''!

!WindowsLocaleTest categoriesForClass!Unclassified! !

!WindowsLocaleTest methodsFor!

defaultSubject
	^Locale lcid: 2057!

testDisplayFloatOnNegativeModes
	| subject format |
	"Different negative number mode (2)"
	subject := Locale standard: 'km-KH'.
	self assert: subject negativeNumberMode equals: 2.
	self assert: (subject printFloat: -0.0) equals: '0.00'.
	self assert: (subject printFloat: -1.25) equals: '- 1.25'.
	self assert: (subject printFloat: -0.0001) equals: '0.00'.
	self assert: (subject printFloat: -123456789.123456789) equals: '- 123,456,789.12'.
	"Negative infinity does not seem to be represented consistently with respect to the normal negative sign conventions in this locale. The value is direct from Windows"
	self assert: (subject printFloat: Float negativeInfinity) equals: '-∞'.

	"Different negative number mode (3)"
	subject := Locale standard: 'fa-IR'.
	self assert: subject negativeNumberMode equals: 3.
	self assert: (subject printFloat: -0.0) equals: '0/00'.
	self assert: (subject printFloat: -1.25) equals: '1/25-'.
	self assert: (subject printFloat: -0.0001) equals: '0/00'.
	self assert: (subject printFloat: -123456789.123456789) equals: '123,456,789/12-'.
	"Ditto re: Negative infinity, which is supplied by Windows with an inconsistent representation."
	self assert: (subject printFloat: Float negativeInfinity) equals: '-∞'.

	"Fake up the other modes - zero is bracketed"
	subject := Locale standard: 'en-US'.
	format := subject numberFormat copy.
	format negativeNumberMode:  0.
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
	#(1033 'English' 2057 'English' 1034 'Spanish' 1106 'Welsh' 11274 'Spanish') pairsDo: [:lcid :language |
		self assert: (Locale lcid: lcid) englishLanguageName equals: language]!

testNamed
	self assert: (Locale named: 'cy-GB') lcid equals: 1106.
	self assert: (Locale named: 'Invariant') identicalTo: Locale invariant!

testPrimary
	"Sad, but true"

	self assert: (Locale named: 'en-GB') primary code equals: 'en-US'.
	self assert: (Locale named: 'fr-CA') primary code equals: 'fr-FR'.
	self assert: Locale invariant primary equals: Locale invariant.
	self assert: (Locale lcid: Win32Constants.LOCALE_CUSTOM_DEFAULT) primary code
		equals: Locale userDefault primary code!

testPrintFloat
	| subject |
	{{Locale lcid: 2057.
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
		{Locale lcid: 1034.
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
						actual := subject printFloat: pair first.
						self assert: actual equals: pair second]]!

testPrintFloatGrouping
	"Test printing with different number grouping."

	| subject format |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	#(#(0 '0' '1234567890.12') #(1 '1' '1,2,3,4,5,6,7,8,9,0.12') #(2 '2' '12,34,56,78,90.12') #(3 '3' '1,234,567,890.12') #(4 '4' '12,3456,7890.12') #(5 '5' '12345,67890.12') #(6 '6' '1234,567890.12') #(7 '7' '123,4567890.12') #(8 '8' '12,34567890.12') #(9 '9' '1,234567890.12') #(10 '1;0;0' '123456789,0.12') #(11 '1;1' '1,2,3,4,5,6,7,8,9,0.12') #(12 '1;2' '1,23,45,67,89,0.12') #(32 '3;2' '1,23,45,67,890.12') #(92 '9;2' '1,234567890.12'))
		do: 
			[:each |
			format grouping: each first.
			self assert: format numberGrouping equals: each second.
			format numberGrouping: each second.
			self assert: format grouping equals: each first.
			self assert: (subject printFloat: 1234567890.123 format: format) equals: each last].
	"The grouping is actually much more flexible than the documentation suggests. Up to four number groups are supported (the last repeating)."
	#(#(98 '9;8' '2,00000000,00000000,00000000,000000000.00') #(89 '8;9' '20000000,000000000,000000000,00000000.00') #(99 '9;9' '2000000,000000000,000000000,000000000.00') #(120 '1;2;0;0' '2000000000000000000000000000000,00,0.00') #(123 '1;2;3' '2,000,000,000,000,000,000,000,000,000,000,00,0.00') #(1230 '1;2;3;0;0' '2000000000000000000000000000,000,00,0.00') #(1234 '1;2;3;4' '2000,0000,0000,0000,0000,0000,0000,000,00,0.00') #(4321 '4;3;2;1' '2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,00,000,0000.00') #(9999 '9;9;9;9' '2000000,000000000,000000000,000000000.00'))
		do: 
			[:each |
			format grouping: each first.
			self assert: format numberGrouping equals: each second.
			format numberGrouping: each second.
			self assert: format grouping equals: each first.
			self assert: (subject printFloat: 2.0e33 format: format) equals: each last].
	#(-1 10000) do: 
			[:each |
			self should: [format grouping: each] raise: Error.
			format Grouping: each.
			self
				should: [subject printFloat: 1.23 format: format]
				raise: HRESULTError
				matching: [:ex | ex tag = (HRESULT win32Error: Win32Errors.ERROR_INVALID_PARAMETER)]].
	self should: [format numberGrouping: '1;2;3;4;5'] raise: Error!

testPrintFloatSeparators
	"Test printing with different number grouping."

	| subject format |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	format
		decimalPlaces: 3;
		grouping: 43;
		decimalSeparator: $@;
		thousandSeparator: $^.
	self assert: (subject printFloat: 1234567890.123 format: format) equals: '123^456^7890@123'!

testPrintNoLeadingZero
	| subject format |
	subject := self defaultSubject.
	format := subject numberFormat copy.
	format hasLeadingZero: false.
	self assert: (subject printFloat: 1234567890.123 format: format) equals: '1,234,567,890.12'.
	self assert: (subject printFloat: 0.123 format: format) equals: '.12'! !

!WindowsLocaleTest categoriesForMethods!
defaultSubject!helpers!private! !
testDisplayFloatOnNegativeModes!public!unit tests! !
testEnglishName!public!unit tests! !
testNamed!public!unit tests! !
testPrimary!public!unit tests! !
testPrintFloat!public!unit tests! !
testPrintFloatGrouping!public!unit tests! !
testPrintFloatSeparators!public!unit tests! !
testPrintNoLeadingZero!public!unit tests! !
!

