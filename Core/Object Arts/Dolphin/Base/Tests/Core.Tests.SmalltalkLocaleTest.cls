"Filed out from Dolphin Smalltalk 7"!

Core.Tests.LocaleTest subclass: #'Core.Tests.SmalltalkLocaleTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.SmalltalkLocaleTest guid: (Core.GUID fromString: '{0a445b92-78d1-4c9c-a3f4-7be49f0c2932}')!
Core.Tests.SmalltalkLocaleTest comment: ''!
!Core.Tests.SmalltalkLocaleTest categoriesForClass!Unclassified! !
!Core.Tests.SmalltalkLocaleTest methodsFor!

defaultSubject
	^Locale smalltalk!

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
	self assert: (subject printFloat: 1234567890.123 format: format) equals: '1234567890@123'! !
!Core.Tests.SmalltalkLocaleTest categoriesFor: #defaultSubject!helpers!private! !
!Core.Tests.SmalltalkLocaleTest categoriesFor: #testDisplayFloatOn!public!unit tests! !
!Core.Tests.SmalltalkLocaleTest categoriesFor: #testPrintFloatGrouping!public!unit tests! !
!Core.Tests.SmalltalkLocaleTest categoriesFor: #testPrintFloatSeparators!public!unit tests! !

