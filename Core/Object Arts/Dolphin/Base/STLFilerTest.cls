"Filed out from Dolphin Smalltalk 7"!

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
	self should: [STLInFiler on: #('!!STL' 9999) readStream] raise: STBError!

testRectangleReadWrite
	| contents myRectangle answer |
	myRectangle := 50 @ 50 extent: 200 @ 200.
	contents := self checkSimpleReadWriteOf: myRectangle.
	self assert: (contents includes: Rectangle).
	self assert: (contents includes: Point).

	"Check that muliple references are identical"
	answer := self simpleReadWriteOf: (Array with: myRectangle with: myRectangle).
	self assert: answer first equals: myRectangle.
	self assert: answer first identicalTo: answer last!

testResourceReadWrite
	| rid shell shell1 shell2 in contents1 contents2 |
	rid := ResourceIdentifier class: ClassBrowserShell name: 'Default view'.
	
	[shell := rid loadWithContext: View desktop.
	contents1 := self writeLiteralsFor: shell.
	in := STLInFiler on: contents1 readStream.
	in context: View desktop.
	shell1 := in next.
	self assert: shell1 isKindOf: ShellView.
	self assert: shell1 isOpen.
	contents2 := self writeLiteralsFor: shell1.
	in := STLInFiler on: contents2 readStream.
	in context: View desktop.
	shell2 := in next.
	self assert: shell2 isKindOf: ShellView.
	self assert: shell2 isOpen.
	self assert: contents1 size equals: contents2 size]
			ensure: 
				[shell destroy.
				shell1 destroy.
				shell2 destroy]!

testShellReadWrite
	| shell1 shell2 |
	shell1 := ShellView show.
	[shell2 := self simpleReadWriteOf: shell1 context: View desktop] ensure: 
			[shell1 destroy.
			shell2 destroy].
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
!STLFilerTest categoriesFor: #checkSimpleReadWriteOf:!private!unit tests! !
!STLFilerTest categoriesFor: #checkSimpleReadWriteOf:context:!private!unit tests! !
!STLFilerTest categoriesFor: #simpleReadWriteOf:!private!unit tests! !
!STLFilerTest categoriesFor: #simpleReadWriteOf:context:!private!unit tests! !
!STLFilerTest categoriesFor: #testClassReadWrite!public!unit tests! !
!STLFilerTest categoriesFor: #testIntegerReadWrite!public!unit tests! !
!STLFilerTest categoriesFor: #testInvalidStream!public!unit tests! !
!STLFilerTest categoriesFor: #testRectangleReadWrite!public!unit tests! !
!STLFilerTest categoriesFor: #testResourceReadWrite!public!unit tests! !
!STLFilerTest categoriesFor: #testShellReadWrite!public!unit tests! !
!STLFilerTest categoriesFor: #testSymbolReadWrite!public!unit tests! !
!STLFilerTest categoriesFor: #testSystemDictionaryReadWrite!public!unit tests! !
!STLFilerTest categoriesFor: #writeLiteralsFor:!private!unit tests! !

