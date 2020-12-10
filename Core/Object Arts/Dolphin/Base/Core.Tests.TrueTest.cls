"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #TrueTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!TrueTest categoriesFor: #testAND!public!testing! !
!TrueTest categoriesFor: #testNew!public!testing! !
!TrueTest categoriesFor: #testNot!public!testing! !
!TrueTest categoriesFor: #testPrintOn!public!testing! !

