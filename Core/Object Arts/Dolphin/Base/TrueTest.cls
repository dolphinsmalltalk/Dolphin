"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #TrueTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TrueTest guid: (GUID fromString: '{e918b165-e08c-4cb2-8369-a5ffff502adb}')!
TrueTest comment: ''!
!TrueTest categoriesForClass!Tests-Kernel-Objects! !
!TrueTest methodsFor!

testAND
	self assert: true & true equals: true.
	self assert: true & false equals: false!

testNew
	self should: [True new] raise: Error!

testNot
	self should: [false not = true]!

testPrintOn
	| stream |
	stream := String writeStream.
	true printOn: stream.
	self assert: stream contents equals: 'true'! !
!TrueTest categoriesForMethods!
testAND!public!testing! !
testNew!public!testing! !
testNot!public!testing! !
testPrintOn!public!testing! !
!

