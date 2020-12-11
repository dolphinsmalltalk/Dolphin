"Filed out from Dolphin Smalltalk 7"!

Core.Tests.BooleanTest subclass: #'Core.Tests.TrueTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.TrueTest guid: (Core.GUID fromString: '{e918b165-e08c-4cb2-8369-a5ffff502adb}')!
Core.Tests.TrueTest comment: ''!
!Core.Tests.TrueTest categoriesForClass!Tests-Kernel-Objects! !
!Core.Tests.TrueTest methodsFor!

subjectClass
	^#{True} value!

testEvaluatingConjunction
	self deny: true & false.
	self assert: true & true.
	self should: [true & [false]] raise: Error.
	self should: [true & 'a'] raise: Error!

testEvaluatingDisjunction
	self assert: (true | false).
	self assert: (true | true).
	self should: [true | [false]] raise: Error.
	self should: [true | 'a'] raise: Error!

testIfFalse
	self assertIsNil: (true ifFalse: ['alternativeBlock']).
	self assertIsNil: (true perform: #ifFalse: with: ['alternativeBlock'])!

testIfFalseIfTrue
	self assert: (true ifFalse: ['falseAlternativeBlock'] ifTrue: ['trueAlternativeBlock'])
		equals: 'trueAlternativeBlock'.
	self assert: (true
				perform: #ifFalse:ifTrue:
				with: ['falseAlternativeBlock']
				with: ['trueAlternativeBlock'])
		equals: 'trueAlternativeBlock'!

testIfTrue
	self assert: (true ifTrue: ['alternativeBlock']) equals: 'alternativeBlock'.
	self assert: (true perform: #ifTrue: with: ['alternativeBlock']) equals: 'alternativeBlock'!

testIfTrueIfFalse
	self assert: (true ifTrue: ['trueAlternativeBlock'] ifFalse: ['falseAlternativeBlock'])
		equals: 'trueAlternativeBlock'.
	self assert: (true
				perform: #ifTrue:ifFalse:
				with: ['trueAlternativeBlock']
				with: ['falseAlternativeBlock'])
		equals: 'trueAlternativeBlock'!

testNonEvaluatingConjunction
	| evaluated |
	evaluated := false.
	self assert: (true and: [evaluated := true]).
	self assert: evaluated.
	evaluated := false.
	self assert: (true perform: #and: with: [evaluated := true]).
	self assert: evaluated!

testNonEvaluatingDisjunction
	| evaluated |
	evaluated := false.
	self assert: (true or: [evaluated := true]).
	self deny: evaluated.
	self assert: (true perform: #or: with: [evaluated := true]).
	self deny: evaluated!

testNot
	self deny: true not!

testPrintOn
	| stream |
	stream := String writeStream.
	true printOn: stream.
	self assert: stream contents equals: 'true'!

testXor
	self assert: (true xor: false).
	self deny: (true xor: true)! !
!Core.Tests.TrueTest categoriesFor: #subjectClass!constants!private! !
!Core.Tests.TrueTest categoriesFor: #testEvaluatingConjunction!public!unit tests! !
!Core.Tests.TrueTest categoriesFor: #testEvaluatingDisjunction!public!unit tests! !
!Core.Tests.TrueTest categoriesFor: #testIfFalse!public!testing! !
!Core.Tests.TrueTest categoriesFor: #testIfFalseIfTrue!public!testing! !
!Core.Tests.TrueTest categoriesFor: #testIfTrue!public!testing! !
!Core.Tests.TrueTest categoriesFor: #testIfTrueIfFalse!public!testing! !
!Core.Tests.TrueTest categoriesFor: #testNonEvaluatingConjunction!public!testing! !
!Core.Tests.TrueTest categoriesFor: #testNonEvaluatingDisjunction!public!testing! !
!Core.Tests.TrueTest categoriesFor: #testNot!public!testing! !
!Core.Tests.TrueTest categoriesFor: #testPrintOn!public!testing! !
!Core.Tests.TrueTest categoriesFor: #testXor!public!unit tests! !

