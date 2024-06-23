"Filed out from Dolphin Smalltalk"!

OS.Tests.AbstractInvariantLocaleTest
	subclass: #'OS.Tests.InvariantLocaleTest'
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

subjectName
	^'invariant'!

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

testDisplayName
	self assert: self defaultSubject displayName equals: 'Invariant Language (Invariant Region)'!

testListSeparator
	self assert: self defaultSubject listSeparator equals: ','!

testStlConvertFromVersion0
	| subject |
	"From: | obj | obj := Object new. {Locale invariant. obj. {Locale invariant}. #foo. obj} literalStoreEvaluationString"
	subject := Object
				fromLiteralStoreArray: #(#'!!STL' 4 34 5 852742 ##(Smalltalk.WindowsLocale) nil 255 170 192 34 12 125 8 'July' 185 8 '' 29 8 '.' 127 8 'August' 123 8 'June' 5 8 'Invariant Language (Invariant Country)' 393222 ##(Smalltalk.Object) 34 1 432 #foo 592).
	"We expect a newly constructed instance with the same lcid, but the other data is discarded"
	self assert: subject first identicalTo: Locale invariant.
	self assert: subject third first identicalTo: Locale invariant.
	self assert: subject fourth identicalTo: #foo.
	self assert: subject second identicalTo: subject last! !

!OS.Tests.InvariantLocaleTest categoriesForMethods!
defaultSubject!helpers!private! !
subjectName!constants!private! !
testDisplayFloatOn!public!unit tests! !
testDisplayName!public!unit tests! !
testListSeparator!public!unit tests! !
testStlConvertFromVersion0!public!unit tests! !
!

