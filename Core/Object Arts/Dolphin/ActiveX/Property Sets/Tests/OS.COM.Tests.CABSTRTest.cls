"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.CountedArrayTest
	subclass: #'OS.COM.Tests.CABSTRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CABSTRTest guid: (Core.GUID fromString: '{dd85ef51-1a89-439d-97d1-94804cdb51a1}')!

OS.COM.Tests.CABSTRTest comment: ''!

!OS.COM.Tests.CABSTRTest methodsFor!

testSelfEvaluating
	| subject expr |
	subject := self newTestSubjectOfSize: 5.
	self assert: subject isSelfEvaluating.
	expr := subject printString.
	self assert: (Compiler evaluate: expr) equals: subject.
	"The final element contains a null, so is not self evaluating."
	subject := self newTestSubjectOfSize: 6.
	self deny: (subject at: 6) isSelfEvaluating.
	self deny: subject isSelfEvaluating.
	self assert: subject printString equals: 'a COM.CABSTR('''' ''a'' ''£'' ''a£🍺ö'' ''Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ'' ''a🐬␀b'')'! !

!OS.COM.Tests.CABSTRTest categoriesForMethods!
testSelfEvaluating!public! !
!

!OS.COM.Tests.CABSTRTest class methodsFor!

arrayClass
	^CABSTR!

externalArrayTestClass
	^BSTRArrayTest! !

!OS.COM.Tests.CABSTRTest class categoriesForMethods!
arrayClass!constants!private! !
externalArrayTestClass!constants!private! !
!

