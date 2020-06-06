"Filed out from Dolphin Smalltalk 7"!

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

testDisplayFloatOn
	| info subject |
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
				{0.0009. '0.00'}.
				{-0.0009. '0.00'}.
				{Float fmax.
					'179,769,313,486,231,600,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000.00'}.
				{Float fmin. '0.00'}.
				{123456.789. '123,456.79'}.
				{-123456.789. '-123,456.79'}.
				{1234567.89. '1,234,567.89'}.
				{-1234567.89. '-1,234,567.89'}}}.
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
				{-0.605. '-0,61'}.
				{0.0001. '0,00'}.
				{-0.0001. '0,00'}.
				{Float fmax.
					'179.769.313.486.231.600.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000.000,00'}.
				{Float fmin. '0,00'}.
				{123456.7. '123.456,70'}.
				{-123456.7. '-123.456,70'}.
				{1234567.89. '1.234.567,89'}.
				{-1234567.89. '-1.234.567,89'}}}}
			do: 
				[:each |
				| actual |
				subject := each first.
				each second do: 
						[:pair |
						actual := self displayFloat: pair first with: subject.
						self assert: actual equals: pair second]].
	"Switch to a locale with a different decimal separator and representations for Nan, Infinity, etc."
	"Different negative number mode (2)"
	subject := Locale lcid: 1050.
	self assert: (self displayFloat: -0.0 with: subject) equals: '0,00'.
	self assert: (self displayFloat: -1.25 with: subject) equals: '- 1,25'.
	self assert: (self displayFloat: -0.0001 with: subject) equals: '0,00'.
	self assert: (self displayFloat: -123456789.123456789 with: subject) equals: '- 123.456.789,12'.
	"Negative infinity does not seem to be represented consistently with respect to the normal negative sign conventions in this locale. The value is direct from Windows"
	self assert: (self displayFloat: Float negativeInfinity with: subject) equals: '-∞'.

	"Different negative number mode (3)"
	subject := Locale lcid: 1065.
	self assert: (self displayFloat: -0.0 with: subject) equals: '0/00'.
	self assert: (self displayFloat: -1.25 with: subject) equals: '1/25-'.
	self assert: (self displayFloat: -0.0001 with: subject) equals: '0/00'.
	self assert: (self displayFloat: -123456789.123456789 with: subject) equals: '123,456,789/12-'.
	"Ditto re: Negative infinity, which is supplied by Windows with an inconsistent representation."
	self assert: (self displayFloat: Float negativeInfinity with: subject) equals: '-∞'.

	"Fake up the other modes - zero is bracketed"
	subject := Locale lcid: 1033.
	info := subject instVarNamed: 'info'.
	info at: Win32Constants.LOCALE_INEGNUMBER put: 0.
	self assert: (self displayFloat: -0.0 with: subject) equals: '0.00'.
	self assert: (self displayFloat: -1.25 with: subject) equals: '(1.25)'.
	self assert: (self displayFloat: -0.0001 with: subject) equals: '0.00'.
	self assert: (self displayFloat: -123456789.123456789 with: subject) equals: '(123,456,789.12)'.

	"Mode 4 is trailing minus after space"
	subject := Locale lcid: 1033.
	(subject instVarNamed: 'info') at: Win32Constants.LOCALE_INEGNUMBER put: 4.
	self assert: subject negativeNumberMode equals: 4.
	self assert: (self displayFloat: -0.0 with: subject) equals: '0.00'.
	self assert: (self displayFloat: -1.25 with: subject) equals: '1.25 -'.
	self assert: (self displayFloat: -0.0001 with: subject) equals: '0.00'.
	self assert: (self displayFloat: -123456789.123456789 with: subject) equals: '123,456,789.12 -'.
!

testEnglishName
	#(1033 'English' 2057 'English' 1034 'Spanish' 1106 'Welsh' 11274 'Spanish') pairsDo: [:lcid :language |
		self assert: (Locale lcid: lcid) englishLanguageName equals: language]! !
!WindowsLocaleTest categoriesFor: #defaultSubject!helpers!private! !
!WindowsLocaleTest categoriesFor: #testDisplayFloatOn!public!unit tests! !
!WindowsLocaleTest categoriesFor: #testEnglishName!public!unit tests! !

