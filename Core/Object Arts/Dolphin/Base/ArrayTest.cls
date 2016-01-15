"Filed out from Dolphin Smalltalk 7"!

ArrayedCollectionTest subclass: #ArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayTest guid: (GUID fromString: '{E642EFA8-51B6-4F91-A4A0-E83C824052D6}')!
ArrayTest comment: ''!
!ArrayTest categoriesForClass!Unclassified! !
!ArrayTest methodsFor!

collectionClass
	^Array!

testIsLiteral
	| example1 |
	example1 := #(1 2 3 4 5) copy.
	self assert: example1 isLiteral.
	example1 at: 1 put: self.
	self deny: example1 isLiteral!

testLiteralStoreOn
	| stream storeString rehydrated |
	stream := String writeStream.
	#(1 2) storeOn: stream.
	storeString := stream contents.
	rehydrated := Compiler evaluate: storeString.
	self assert: rehydrated class == Array.
	self assert: rehydrated isLiteral.
	self assert: rehydrated = #(1 2).

!

testNonLiteralStoreOn
	| stream storeString rehydrated array |
	stream := String writeStream.
	array := Array with: 1 -> '1' with: 2 -> '2'.
	self deny: array isLiteral.
	array storeOn: stream.
	storeString := stream contents.
	rehydrated := Compiler evaluate: storeString.
	self assert: rehydrated class == Array.
	self deny: rehydrated isLiteral.
	self assert: rehydrated = array! !
!ArrayTest categoriesFor: #collectionClass!helpers!private! !
!ArrayTest categoriesFor: #testIsLiteral!public!unit tests! !
!ArrayTest categoriesFor: #testLiteralStoreOn!public!unit tests! !
!ArrayTest categoriesFor: #testNonLiteralStoreOn!public!unit tests! !

