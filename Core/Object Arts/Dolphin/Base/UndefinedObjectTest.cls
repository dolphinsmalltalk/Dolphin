"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #UndefinedObjectTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UndefinedObjectTest guid: (GUID fromString: '{9C1B04D8-3338-4B9A-B561-5482F01A3BAE}')!
UndefinedObjectTest comment: 'This is the unit test for the class UndefinedObject. Unit tests are a good way to exercise the functionality of your system in a repeatable and automatic manner. They are therefore recommended if you plan to release anything. For more information, see: 
	- http://www.c2.com/cgi/wiki?UnitTest
	- http://minnow.cc.gatech.edu/squeak/1547
	- the sunit class category'!
!UndefinedObjectTest categoriesForClass!Tests-Kernel-Objects! !
!UndefinedObjectTest methodsFor!

testClone
	self assert: nil copy == nil!

testDeepCopy
	self assert: nil deepCopy = nil!

testIfNil
	self should: [nil ifNil: [self error: nil]] raise: Error!

testIfNilIfNotNil
	self assert: (nil ifNil: [1] ifNotNil: [:x | 2]) = 1!

testIfNotNil
	self shouldnt: [nil ifNotNil: [:x | self error: nil]] raise: Error!

testIfNotNilIfNil
	self assert: (nil ifNotNil: [:x | 1] ifNil: [2]) = 2!

testIsLiteral
	self assert: nil isLiteral!

testIsNil
	self assert: nil isNil!

testIsNilOrEmpty
	self assert: nil isNilOrEmpty!

testNew
	self assert: UndefinedObject new == nil!

testNotNil
	self deny: nil notNil!

testPrintOn
	| string stream |
	stream := String writeStream.
	nil printOn: stream.
	string := stream contents.
	self assert: string = 'nil'!

testShallowCopy
	self assert: nil shallowCopy = nil!

testStoreOn
	| string stream |
	stream := String writeStream.
	nil storeOn: stream.
	string := stream contents.
	self assert: (Compiler evaluate: string) = nil! !
!UndefinedObjectTest categoriesFor: #testClone!public!testing / copying! !
!UndefinedObjectTest categoriesFor: #testDeepCopy!public!testing / copying! !
!UndefinedObjectTest categoriesFor: #testIfNil!public!testing / testing! !
!UndefinedObjectTest categoriesFor: #testIfNilIfNotNil!public!testing / testing! !
!UndefinedObjectTest categoriesFor: #testIfNotNil!public!testing / testing! !
!UndefinedObjectTest categoriesFor: #testIfNotNilIfNil!public!testing / testing! !
!UndefinedObjectTest categoriesFor: #testIsLiteral!public!testing / testing! !
!UndefinedObjectTest categoriesFor: #testIsNil!public!testing / testing! !
!UndefinedObjectTest categoriesFor: #testIsNilOrEmpty!public!testing / testing! !
!UndefinedObjectTest categoriesFor: #testNew!public!unit tests! !
!UndefinedObjectTest categoriesFor: #testNotNil!public!testing / testing! !
!UndefinedObjectTest categoriesFor: #testPrintOn!public!testing / printing! !
!UndefinedObjectTest categoriesFor: #testShallowCopy!public!testing / copying! !
!UndefinedObjectTest categoriesFor: #testStoreOn!public!testing / printing! !

