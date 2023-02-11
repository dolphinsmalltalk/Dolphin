"Filed out from Dolphin Smalltalk"!

Core.Tests.ArrayedCollectionTest subclass: #'Core.Tests.ArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ArrayTest guid: (Core.GUID fromString: '{e642efa8-51b6-4f91-a4a0-e83c824052d6}')!
Core.Tests.ArrayTest comment: ''!
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
	self deny: {Object} isLiteral!

testIsSelfEvaluating
	| subject |
	subject := {1 to: 5. 123. 'abc'. #(1 2). 123. #a -> 'A'. Object}.
	self assert: subject isSelfEvaluating.
	subject at: 1 put: self.
	self deny: subject isSelfEvaluating.
	subject at: 1 put: subject.
	self deny: subject isSelfEvaluating!

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

testStoreOnLiteral
	| stream storeString rehydrated array |
	stream := String writeStream.
	array := #(1 1.2 'abc' #(#abc true false nil #[1 2 3] #{Core.Object} $a 1.25s)).
	array storeOn: stream.
	storeString := stream contents.
	self assert: storeString equals: '#(1 1.2 ''abc'' #(#abc true false nil #[1 2 3] #{Core.Object} $a 1.25s))'.
	rehydrated := Compiler evaluate: storeString.
	self assert: rehydrated class identicalTo: Array.
	self assert: rehydrated isLiteral.
	self assert: rehydrated equals: array!

testStoreOnNonLiteral
	| stream storeString rehydrated array |
	stream := String writeStream.
	array := {1 -> '1'. 2 -> '2'. Object}.
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
!Core.Tests.ArrayTest categoriesForMethods!
collectionClass!helpers!private! !
testCyclicRefPrinting!public! !
testIsLiteral!public!unit tests! !
testIsSelfEvaluating!public!unit tests! !
testMixedConcatenation!public! !
testStoreOnLiteral!public!unit tests! !
testStoreOnNonLiteral!public!unit tests! !
testWith!public!unit tests! !
testWithWith!public!unit tests! !
testWithWithWith!public!unit tests! !
testWithWithWithWith!public!unit tests! !
testWithWithWithWithWith!public!unit tests! !
!

