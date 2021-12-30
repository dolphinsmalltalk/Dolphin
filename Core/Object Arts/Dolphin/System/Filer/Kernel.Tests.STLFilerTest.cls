"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.STLFilerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.STLFilerTest guid: (Core.GUID fromString: '{5f151d4d-927e-4254-aed9-c51056aef954}')!
Kernel.Tests.STLFilerTest comment: ''!
!Kernel.Tests.STLFilerTest categoriesForClass!Unclassified! !
!Kernel.Tests.STLFilerTest methodsFor!

checkSimpleReadWriteOf: value 
	^self checkSimpleReadWriteOf: value context: nil!

checkSimpleReadWriteOf: value context: anObject
	| in streamContents |
	streamContents := self writeLiteralsFor: value.
	in := STLInFiler on: streamContents readStream.
	in context: anObject.
	self assert: in next equals: value.
	^streamContents!

simpleReadWriteOf: value 
	^self simpleReadWriteOf: value context: nil!

simpleReadWriteOf: value context: anObject
	| streamContents in |
	streamContents := self writeLiteralsFor: value.
	in := STLInFiler on: streamContents readStream.
	in context: anObject.
	^in next!

testArraysWithSharedLiterals
	"Verify that the identity of shared literals that are not atomic is preserved."

	| float arrays deserialized bindingRef relativeBindingRef storeArray |
	float := 1.23.
	bindingRef := #{Kernel.Tests.STLFilerTest}.
	relativeBindingRef := #{STLFilerTest}.
	arrays := {{1. float. bindingRef}. {2. float. relativeBindingRef}. bindingRef. relativeBindingRef}.
	storeArray := arrays literalStoreArray.
	self assert: (storeArray select: [:each | each == float]) size equals: 1.
	self assert: (storeArray select: [:each | each == bindingRef]) size equals: 1.
	"Relative binding references cannot be filed in literal form"
	self assert: (storeArray select: [:each | each == relativeBindingRef]) size equals: 0.
	deserialized := Compiler evaluate: arrays literalStoreEvaluationString.
	self assert: deserialized equals: arrays.
	self deny: deserialized third identicalTo: bindingRef.
	self deny: deserialized first second identicalTo: float.
	self assert: deserialized first second identicalTo: deserialized second second.
	self assert: deserialized third identicalTo: deserialized first third.
	self assert: deserialized fourth identicalTo: deserialized second third!

testBlockReadWrite
	| block1 contents1 in contents2 block2 block3 |
	block1 := [1 + 2].
	contents1 := self writeLiteralsFor: block1.
	in := STLInFiler on: contents1 readStream.
	block2 := in next.
	self assert: block2 method literalCount equals: block1 method literalCount.
	self assert: block2 equals: block1.
	contents2 := self writeLiteralsFor: block2.
	in := STLInFiler on: contents2 readStream.
	block3 := in next.
	self assert: block3 equals: block1.
	self assert: contents1 size equals: contents2 size
!

testClassReadWrite
	| contents answer data |
	contents := self checkSimpleReadWriteOf: STLFilerTest.
	self assert: (contents includes: STLFilerTest).

	"Check multiple references "
	data := {STLFilerTest. STLFilerTest}.
	answer := self simpleReadWriteOf: data.
	self assert: answer equals: data.
	self assert: answer first identicalTo: STLFilerTest.
	self assert: answer first identicalTo: answer last!

testEmptyStream
	self should: [STLInFiler on: #() readStream] raise: STBError!

testIntegerReadWrite

	| contents int |
	"SmallInteger"
	#(##(SmallInteger minimum) -1 0 1 ##(SmallInteger maximum))
		do: [:each | self checkSimpleReadWriteOf: each].
	"LargeInteger"
	int := SmallInteger maximum + 1.
	contents := self checkSimpleReadWriteOf: int.
	self assert: (contents includes: int)!

testInvalidStream
	self should: [STLInFiler on: #('Test') readStream] raise: STBError.
	self should: [STLInFiler on: #('!!STL' 9999) readStream] raise: STBError.
	self should: [STLInFiler on: #('') readStream] raise: STBError.
	self should: [STLInFiler on: #(#[]) readStream] raise: STBError!

testSymbolReadWrite
	| contents deserialized data testSymbol |
	testSymbol := 'testSymbol' asSymbol.
	contents := self checkSimpleReadWriteOf: testSymbol.
	self assert: (contents identityIncludes: testSymbol).

	"Now test that multiple references only occur once"
	data := {testSymbol. testSymbol. 'otherSymbol' asSymbol}.
	deserialized := self simpleReadWriteOf: data.
	self assert: deserialized equals: data.

	"Check that muliple references are identical"
	self assert: deserialized first identicalTo: testSymbol.
	self assert: deserialized first identicalTo: deserialized second!

testSystemDictionaryReadWrite
	| sysdict array array2 |
	sysdict := self simpleReadWriteOf: Smalltalk.
	self assert: sysdict identicalTo: Smalltalk.
	array := {Smalltalk}.
	array2 := self simpleReadWriteOf: array.
	self assert: array2 equals: array.
	self assert: array first identicalTo: Smalltalk!

writeLiteralsFor: anObject
	| out |
	out := STLOutFiler on: Array writeStream.
	out nextPut: anObject.
	^out stream contents! !
!Kernel.Tests.STLFilerTest categoriesForMethods!
checkSimpleReadWriteOf:!private!unit tests! !
checkSimpleReadWriteOf:context:!private!unit tests! !
simpleReadWriteOf:!private!unit tests! !
simpleReadWriteOf:context:!private!unit tests! !
testArraysWithSharedLiterals!public!unit tests! !
testBlockReadWrite!public!unit tests! !
testClassReadWrite!public!unit tests! !
testEmptyStream!public!unit tests! !
testIntegerReadWrite!public!unit tests! !
testInvalidStream!public!unit tests! !
testSymbolReadWrite!public!unit tests! !
testSystemDictionaryReadWrite!public!unit tests! !
writeLiteralsFor:!private!unit tests! !
!

