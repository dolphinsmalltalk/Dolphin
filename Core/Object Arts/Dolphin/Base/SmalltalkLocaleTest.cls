"Filed out from Dolphin Smalltalk 7"!

LocaleTest subclass: #SmalltalkLocaleTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkLocaleTest guid: (GUID fromString: '{0a445b92-78d1-4c9c-a3f4-7be49f0c2932}')!
SmalltalkLocaleTest comment: ''!
!SmalltalkLocaleTest categoriesForClass!Unclassified! !
!SmalltalkLocaleTest methodsFor!

defaultSubject
	^Locale smalltalk!

testDisplayFloatOn
	| subject |
	subject := Locale smalltalk.
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
				actual := String streamContents: [:s | subject displayFloat: each first on: s].
				self assert: actual equals: each second]! !
!SmalltalkLocaleTest categoriesFor: #defaultSubject!helpers!private! !
!SmalltalkLocaleTest categoriesFor: #testDisplayFloatOn!public! !

