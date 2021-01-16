"Filed out from Dolphin Smalltalk 7"!

Core.Tests.ArrayedCollectionTest subclass: #'Core.Tests.ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ArrayTest guid: (Core.GUID fromString: '{e642efa8-51b6-4f91-a4a0-e83c824052d6}')!
Core.Tests.ArrayTest comment: ''!
!Core.Tests.ArrayTest categoriesForClass!Unclassified! !
!Core.Tests.ArrayTest methodsFor!

collectionClass
	^Array!

testCyclicRefPrinting
	| array |
	array := Array new: 1.
	array at: 1 put: array.
	self assert: array debugPrintString equals: 'an Array(... a cyclic ref to an Array...)'!

testIsLiteral
	| subject |
	subject := #(1 2 2 4 5) copy.
	self assert: subject isLiteral.
	subject at: 1 put: self.
	self deny: subject isLiteral.
	subject at: 1 put: subject.
	self deny: subject isLiteral.
!

testIsSelfEvaluating
	| subject |
	subject := {1 to: 5. 123. 'abc'. #(1 2). 123. #a -> 'A'}.
	self assert: subject isSelfEvaluating.
	subject at: 1 put: self.
	self deny: subject isSelfEvaluating.
	subject at: 1 put: subject.
	self deny: subject isSelfEvaluating!

testLiteralStoreOn
	| stream subject storeString rehydrated stlArray |
	stream := Array writeStream.
	subject := {Object. 1. 's'. {Core.Tests.ArrayTest}}.
	subject literalStoreOn: stream.
	stlArray := stream contents.
	stream := String writeStream.
	stlArray literalPrintOn: stream.
	storeString := stream contents.
	rehydrated := Compiler evaluate: storeString.
	self assert: rehydrated equals: stlArray.
	rehydrated := Object fromLiteralStoreArray: stlArray.
	self assert: rehydrated equals: subject!

testLiteralStoreString
	| stream storeString rehydrated |
	stream := String writeStream.
	#(1 2) storeOn: stream.
	storeString := stream contents.
	rehydrated := Compiler evaluate: storeString.
	self assert: rehydrated class identicalTo: Array.
	self assert: rehydrated isLiteral.
	self assert: rehydrated equals: #(1 2)!

testMixedConcatenation
	"Test concatenating other types of sequenceable collection onto an array"

	| subjects |
	subjects := #(#() #(1) #(1 2)).
	{String empty. Utf16String empty. ByteArray new. OrderedCollection new. 1 to: 0} do: 
			[:eachEmpty |
			subjects do: 
					[:eachArray |
					| result |
					result := eachArray , eachEmpty.
					self deny: eachArray identicalTo: result.
					self assert: result equals: eachArray]].
	{'£' asAnsiString.
		'€🐬' asUtf8String.
		'🐬' asUtf16String.
		#[255].
		OrderedCollection with: 1234.
		100 to: 100} do: 
				[:eachOne |
				subjects do: 
						[:eachArray |
						| result |
						result := self verifyConcatenation: eachOne with: eachArray.
						self deny: eachArray identicalTo: result.
						self assert: result class identicalTo: Array]].
	{'a£b' asAnsiString.
		'🐬€' asUtf8String.
		'ab🐬' asUtf16String.
		#[1 255].
		OrderedCollection with: 1234 with: $x.
		100 to: 101} do: 
				[:eachTwo |
				subjects do: 
						[:eachArray |
						| result |
						result := self verifyConcatenation: eachTwo with: eachArray.
						self deny: eachArray identicalTo: result.
						self assert: result class identicalTo: Array]]!

testNonLiteralStoreString
	| stream storeString rehydrated array |
	stream := String writeStream.
	array := {1 -> '1'. 2 -> '2'}.
	self deny: array isLiteral.
	array storeOn: stream.
	storeString := stream contents.
	rehydrated := Compiler evaluate: storeString.
	self assert: rehydrated class identicalTo: Array.
	self deny: rehydrated isLiteral.
	self assert: rehydrated equals: array!

testWith
	| array array2 originalMethod testMethod |
	array := Array with: 1.
	self assert: array equals: #(1).
	originalMethod := Array class compiledMethodAt: #with:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	array2 := testMethod value: Array withArguments: #(1).
	self assert: array2 equals: array!

testWithWith
	| array array2 originalMethod testMethod |
	array := Array with: 1 with: 2.
	self assert: array equals: #(1 2).
	originalMethod := Array class compiledMethodAt: #with:with:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	array2 := testMethod value: Array withArguments: #(1 2).
	self assert: array2 equals: array!

testWithWithWith
	| array array2 originalMethod testMethod |
	array := Array
				with: 1
				with: 2
				with: 3.
	self assert: array equals: #(1 2 3).
	originalMethod := Array class compiledMethodAt: #with:with:with:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	array2 := testMethod value: Array withArguments: #(1 2 3).
	self assert: array2 equals: array!

testWithWithWithWith
	| array array2 originalMethod testMethod |
	array := Array
				with: 1
				with: 2
				with: 3
				with: 4.
	self assert: array equals: #(1 2 3 4).
	originalMethod := Array class compiledMethodAt: #with:with:with:with:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	array2 := testMethod value: Array withArguments: #(1 2 3 4).
	self assert: array2 equals: array!

testWithWithWithWithWith
	| array array2 originalMethod testMethod |
	array := Array
				with: 1
				with: 2
				with: 3
				with: 4
				with: 5.
	self assert: array equals: #(1 2 3 4 5).
	originalMethod := Array class compiledMethodAt: #with:with:with:with:with:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	array2 := testMethod value: Array withArguments: #(1 2 3 4 5).
	self assert: array2 equals: array! !
!Core.Tests.ArrayTest categoriesFor: #collectionClass!helpers!private! !
!Core.Tests.ArrayTest categoriesFor: #testCyclicRefPrinting!public! !
!Core.Tests.ArrayTest categoriesFor: #testIsLiteral!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testIsSelfEvaluating!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testLiteralStoreOn!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testLiteralStoreString!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testMixedConcatenation!public! !
!Core.Tests.ArrayTest categoriesFor: #testNonLiteralStoreString!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testWith!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testWithWith!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testWithWithWith!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testWithWithWithWith!public!unit tests! !
!Core.Tests.ArrayTest categoriesFor: #testWithWithWithWithWith!public!unit tests! !

