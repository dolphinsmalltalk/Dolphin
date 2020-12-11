"Filed out from Dolphin Smalltalk 7"!

Core.Tests.BooleanTest subclass: #'Core.Tests.FalseTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.FalseTest guid: (Core.GUID fromString: '{99f97009-5267-45fd-913e-d80674f965fa}')!
Core.Tests.FalseTest comment: 'This is the unit test for the class False. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category
'!
!Core.Tests.FalseTest categoriesForClass!Tests-Kernel-Objects! !
!Core.Tests.FalseTest methodsFor!

subjectClass
	^#{False} value!

testEvaluatingConjunction
	self deny: false & false.
	self deny: false & true.
	self should: [false & 1] raise: Error!

testEvaluatingDisjunction
	self deny: (false | false).
	self assert: (false | true).
	self should: [false | 1] raise: Error!

testIfFalse
	self assert: (false ifFalse: ['alternativeBlock']) equals: 'alternativeBlock'.
	self assert: (false perform: #ifFalse: with: ['alternativeBlock']) equals: 'alternativeBlock'!

testIfFalseIfTrue
	self assert: (false ifFalse: ['falseAlternativeBlock'] ifTrue: ['trueAlternativeBlock'])
		equals: 'falseAlternativeBlock'.
	self assert: (false
				perform: #ifFalse:ifTrue:
				with: ['falseAlternativeBlock']
				with: ['trueAlternativeBlock'])
		equals: 'falseAlternativeBlock'!

testIfTrue
	self assertIsNil: (false ifTrue: ['alternativeBlock']).
	self assertIsNil: (false perform: #ifTrue: with: ['alternativeBlock'])!

testIfTrueIfFalse
	self assert: (false ifTrue: ['trueAlternativeBlock'] ifFalse: ['falseAlternativeBlock'])
		equals: 'falseAlternativeBlock'.
	self assert: (false
				perform: #ifTrue:ifFalse:
				with: ['trueAlternativeBlock']
				with: ['falseAlternativeBlock'])
		equals: 'falseAlternativeBlock'!

testNonEvaluatingConjunction
	| evaluated |
	evaluated := false.
	self deny: (false and: [evaluated := true]).
	self deny: evaluated.
	self deny: (false perform: #and: with: [evaluated := true]).
	self deny: evaluated!

testNonEvaluatingDisjunction
	self assert: (false or: ['alternativeBlock']) equals: 'alternativeBlock'.
	self assert: (false perform: #or: with: ['alternativeBlock']) equals: 'alternativeBlock'!

testNot
	self assert: false not!

testPrintOn
	| stream |
	stream := String writeStream.
	false printOn: stream.
	self assert: stream contents equals: 'false'!

testXor
	self assert: (false xor: true).
	self deny: (false xor: false)! !
!Core.Tests.FalseTest categoriesFor: #subjectClass!constants!public! !
!Core.Tests.FalseTest categoriesFor: #testEvaluatingConjunction!public!unit tests! !
!Core.Tests.FalseTest categoriesFor: #testEvaluatingDisjunction!public!unit tests! !
!Core.Tests.FalseTest categoriesFor: #testIfFalse!public!testing! !
!Core.Tests.FalseTest categoriesFor: #testIfFalseIfTrue!public!testing! !
!Core.Tests.FalseTest categoriesFor: #testIfTrue!public!testing! !
!Core.Tests.FalseTest categoriesFor: #testIfTrueIfFalse!public!testing! !
!Core.Tests.FalseTest categoriesFor: #testNonEvaluatingConjunction!public!testing! !
!Core.Tests.FalseTest categoriesFor: #testNonEvaluatingDisjunction!public!testing! !
!Core.Tests.FalseTest categoriesFor: #testNot!public!testing! !
!Core.Tests.FalseTest categoriesFor: #testPrintOn!public!testing! !
!Core.Tests.FalseTest categoriesFor: #testXor!public!unit tests! !

