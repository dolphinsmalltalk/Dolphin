"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #FalseTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
FalseTest guid: (GUID fromString: '{99f97009-5267-45fd-913e-d80674f965fa}')!
FalseTest comment: 'This is the unit test for the class False. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category
'!
!FalseTest categoriesForClass!Tests-Kernel-Objects! !
!FalseTest methodsFor!

testAnd
	self assert: (false and: ['alternativeBlock']) equals: false!

testAND
	self assert: false & true equals: false.
	self assert: false & false equals: false!

testIfFalse
	self should: [(false ifFalse: ['alternativeBlock']) = 'alternativeBlock']!

testIfFalseIfTrue
	self assert: (false ifFalse: ['falseAlternativeBlock'] ifTrue: ['trueAlternativeBlock'])
		equals: 'falseAlternativeBlock'!

testIfTrue
	self assert: (false ifTrue: ['alternativeBlock']) equals: nil!

testIfTrueIfFalse
	self assert: (false ifTrue: ['trueAlternativeBlock'] ifFalse: ['falseAlternativeBlock'])
		equals: 'falseAlternativeBlock'!

testNew
	self should: [False new] raise: TestResult error!

testNot
	self should: [false not = true]!

testOr
	self assert: (false or: ['alternativeBlock']) equals: 'alternativeBlock'!

testOR
	self assert: false | true equals: true.
	self assert: false | false equals: false!

testPrintOn
	| stream |
	stream := String writeStream.
	false printOn: stream.
	self assert: stream contents equals: 'false'! !
!FalseTest categoriesFor: #testAnd!public!testing! !
!FalseTest categoriesFor: #testAND!public!testing! !
!FalseTest categoriesFor: #testIfFalse!public!testing! !
!FalseTest categoriesFor: #testIfFalseIfTrue!public!testing! !
!FalseTest categoriesFor: #testIfTrue!public!testing! !
!FalseTest categoriesFor: #testIfTrueIfFalse!public!testing! !
!FalseTest categoriesFor: #testNew!public!testing! !
!FalseTest categoriesFor: #testNot!public!testing! !
!FalseTest categoriesFor: #testOr!public!testing! !
!FalseTest categoriesFor: #testOR!public!testing! !
!FalseTest categoriesFor: #testPrintOn!public!testing! !

