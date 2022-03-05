"Filed out from Dolphin Smalltalk"!

ArrayedCollectionTest subclass: #ArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayTest guid: (GUID fromString: '{e642efa8-51b6-4f91-a4a0-e83c824052d6}')!
ArrayTest comment: ''!
!ArrayTest categoriesForClass!Unclassified! !
!ArrayTest methodsFor!

collectionClass
	^Array!

testCyclicRefPrinting
	| array |
	array := Array new: 1.
	array at: 1 put: array.
	self assert: array debugPrintString equals: '#(... a cyclic ref to an Array...)'!

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

testNonLiteralStoreOn
	| stream storeString rehydrated array |
	stream := String writeStream.
	array := Array with: 1 -> '1' with: 2 -> '2'.
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
!ArrayTest categoriesForMethods!
collectionClass!helpers!private! !
testCyclicRefPrinting!public! !
testIsLiteral!public!unit tests! !
testLiteralStoreOn!public!unit tests! !
testMixedConcatenation!public! !
testNonLiteralStoreOn!public!unit tests! !
testWith!public!unit tests! !
testWithWith!public!unit tests! !
testWithWithWith!public!unit tests! !
testWithWithWithWith!public!unit tests! !
testWithWithWithWithWith!public!unit tests! !
!

