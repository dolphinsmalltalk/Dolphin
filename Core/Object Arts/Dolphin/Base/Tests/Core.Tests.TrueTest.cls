"Filed out from Dolphin Smalltalk"!

Core.Tests.BooleanTest
	subclass: #'Core.Tests.TrueTest'
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

testAsBit
	self assert: true asBit equals: 1!

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
!Core.Tests.TrueTest categoriesForMethods!
subjectClass!constants!private! !
testAsBit!public!unit tests! !
testEvaluatingConjunction!public!unit tests! !
testEvaluatingDisjunction!public!unit tests! !
testIfFalse!public!testing! !
testIfFalseIfTrue!public!testing! !
testIfTrue!public!testing! !
testIfTrueIfFalse!public!testing! !
testNonEvaluatingConjunction!public!testing! !
testNonEvaluatingDisjunction!public!testing! !
testNot!public!testing! !
testPrintOn!public!testing! !
testXor!public!unit tests! !
!

