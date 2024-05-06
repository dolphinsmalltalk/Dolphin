"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #STLFilerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

STLFilerTest guid: (GUID fromString: '{5f151d4d-927e-4254-aed9-c51056aef954}')!

STLFilerTest comment: ''!

!STLFilerTest categoriesForClass!Unclassified! !

!STLFilerTest methodsFor!

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

testClassReadWrite
	| contents answer data |
	contents := self checkSimpleReadWriteOf: STLFilerTest.
	self assert: (contents includes: STLFilerTest).

	"Check multiple references "
	data := Array with: STLFilerTest with: STLFilerTest.
	answer := self simpleReadWriteOf: data.
	self assert: answer equals: data.
	self assert: answer first identicalTo: STLFilerTest.
	self assert: answer first identicalTo: answer last!

testEmptyStream
	self should: [STLInFiler on: #() readStream] raise: STBError.!

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
	self should: [STLInFiler on: #(#[]) readStream] raise: STBError.
!

testSymbolReadWrite
	| contents deserialized data testSymbol |
	testSymbol := 'testSymbol' asSymbol.
	contents := self checkSimpleReadWriteOf: testSymbol.
	self assert: (contents identityIncludes: testSymbol).

	"Now test that multiple references only occur once"
	data := Array
				with: testSymbol
				with: testSymbol
				with: 'otherSymbol' asSymbol.
	deserialized := self simpleReadWriteOf: data.
	self assert: deserialized equals: data.

	"Check that muliple references are identical"
	self assert: deserialized first identicalTo: testSymbol.
	self assert: deserialized first identicalTo: deserialized second!

testSystemDictionaryReadWrite
	| sysdict array array2 |
	sysdict := self simpleReadWriteOf: Smalltalk.
	self assert: sysdict identicalTo: Smalltalk.
	array := Array with: Smalltalk.
	array2 := self simpleReadWriteOf: array.
	self assert: array2 equals: array.
	self assert: array first identicalTo: Smalltalk!

writeLiteralsFor: value
	| out |
	out := STLOutFiler on: Array writeStream.
	out nextPut: value.
	^out stream contents! !

!STLFilerTest categoriesForMethods!
checkSimpleReadWriteOf:!private!unit tests! !
checkSimpleReadWriteOf:context:!private!unit tests! !
simpleReadWriteOf:!private!unit tests! !
simpleReadWriteOf:context:!private!unit tests! !
testClassReadWrite!public!unit tests! !
testEmptyStream!public!unit tests! !
testIntegerReadWrite!public!unit tests! !
testInvalidStream!public!unit tests! !
testSymbolReadWrite!public!unit tests! !
testSystemDictionaryReadWrite!public!unit tests! !
writeLiteralsFor:!private!unit tests! !
!

