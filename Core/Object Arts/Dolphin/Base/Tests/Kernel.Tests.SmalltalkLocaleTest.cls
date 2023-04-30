"Filed out from Dolphin Smalltalk"!

OS.Tests.AbstractInvariantLocaleTest
	subclass: #'Kernel.Tests.SmalltalkLocaleTest'
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

subjectName
	^'smalltalk'!

testDisplayCharacterOn
	| subject |
	subject := self defaultSubject.
	#($a 'a' $£ '£' $€ '€' $\x20 '␣' $🐬 '🐬' $\0 '␀' $\x7F '␡' $\x80 '(U+0080)' $\xFEFF '(U+FEFF)' $\xEFFFD '(U+EFFFD)')
		pairsDo: 
			[:ch :expected |
			| stream |
			stream := String writeStream.
			subject displayCharacter: ch on: stream.
			self assert: stream contents equals: expected]!

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

testDisplayName
	self assert: self defaultSubject displayName equals: 'Smalltalk'!

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
		groupSeparator: $^.
	self assert: (subject printFloat: 1234567890.123 format: format) equals: '1234567890@123'!

testStbConvertFromVersion0
	| subject |
	"From: | obj | obj := Object new. {Locale invariant. obj. {Locale invariant}. #foo. obj} literalStoreEvaluationString"
	subject := Object fromLiteralStoreArray: #(#'!!STL' 4 34 5 983302 ##(Smalltalk.SmalltalkLocale) nil 393222 ##(Smalltalk.Object) 34 1 432 #foo 464).
	"We expect a newly constructed instance with the same lcid, but the other data is discarded"
	self assert: subject first identicalTo: self defaultSubject.
	self assert: subject third first identicalTo: self defaultSubject.
	self assert: subject fourth identicalTo: #foo.
	self assert: subject second identicalTo: subject last! !
!Kernel.Tests.SmalltalkLocaleTest categoriesForMethods!
defaultSubject!helpers!private! !
subjectName!constants!public! !
testDisplayCharacterOn!public!unit tests! !
testDisplayFloatOn!public!unit tests! !
testDisplayName!public!unit tests! !
testPrintFloatGrouping!public!unit tests! !
testPrintFloatSeparators!public!unit tests! !
testStbConvertFromVersion0!public!unit tests! !
!

