"Filed out from Dolphin Smalltalk 7"!

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
	self assert: array debugPrintString = '#(... a cyclic ref to an Array...)'!

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
					self deny: eachArray == result.
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
						self deny: eachArray == result.
						self assert: result class == Array]].
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
						self deny: eachArray == result.
						self assert: result class == Array]]!

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
!ArrayTest categoriesFor: #testCyclicRefPrinting!public! !
!ArrayTest categoriesFor: #testIsLiteral!public!unit tests! !
!ArrayTest categoriesFor: #testLiteralStoreOn!public!unit tests! !
!ArrayTest categoriesFor: #testMixedConcatenation!public! !
!ArrayTest categoriesFor: #testNonLiteralStoreOn!public!unit tests! !

