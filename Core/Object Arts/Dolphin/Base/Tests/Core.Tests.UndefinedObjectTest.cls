"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.UndefinedObjectTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.UndefinedObjectTest guid: (Core.GUID fromString: '{9c1b04d8-3338-4b9a-b561-5482f01a3bae}')!
Core.Tests.UndefinedObjectTest comment: 'This is the unit test for the class UndefinedObject. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!
!Core.Tests.UndefinedObjectTest categoriesForClass!Tests-Kernel-Objects! !
!Core.Tests.UndefinedObjectTest methodsFor!

testClone
	self assert: nil copy identicalTo: nil!

testDeepCopy
	self assert: nil deepCopy equals: nil!

testIfNil
	self should: [nil ifNil: [self error: nil]] raise: Error!

testIfNilIfNotNil
	self assert: (nil ifNil: [1] ifNotNil: [:x | 2]) equals: 1!

testIfNotNil
	self shouldnt: [nil ifNotNil: [:x | self error: nil]] raise: Error!

testIfNotNilIfNil
	self assert: (nil ifNotNil: [:x | 1] ifNil: [2]) equals: 2!

testIsLiteral
	self assert: nil isLiteral!

testIsNil
	self assertIsNil: nil!

testIsSelfEvaluating
	self assert: nil isSelfEvaluating!

testNew
	self assert: UndefinedObject new identicalTo: nil!

testNotNil
	self deny: nil notNil!

testPrintOn
	| string stream |
	stream := String writeStream.
	nil printOn: stream.
	string := stream contents.
	self assert: string equals: 'nil'!

testShallowCopy
	self assert: nil shallowCopy equals: nil!

testStoreOn
	| string stream |
	stream := String writeStream.
	nil storeOn: stream.
	string := stream contents.
	self assert: (Compiler evaluate: string) equals: nil! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testClone!public!testing / copying! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testDeepCopy!public!testing / copying! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testIfNil!public!testing / testing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testIfNilIfNotNil!public!testing / testing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testIfNotNil!public!testing / testing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testIfNotNilIfNil!public!testing / testing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testIsLiteral!public!testing / testing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testIsNil!public!testing / testing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testIsSelfEvaluating!public!testing / testing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testNew!public!unit tests! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testNotNil!public!testing / testing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testPrintOn!public!testing / printing! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testShallowCopy!public!testing / copying! !
!Core.Tests.UndefinedObjectTest categoriesFor: #testStoreOn!public!testing / printing! !

