"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #STLFilerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STLFilerTest guid: (GUID fromString: '{5F151D4D-927E-4254-AED9-C51056AEF954}')!
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
	self assert: in next = value.
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
	| contents answer |
	contents := self checkSimpleReadWriteOf: STLFilerTest.
	self assert: (contents includes: STLFilerTest).

	"Check that multiple references are folded"
	contents := self checkSimpleReadWriteOf: (Array with: STLFilerTest with: STLFilerTest).
	self assert: (contents occurrencesOf: STLFilerTest) = 1.

	"Check that muliple references are identical"
	answer := self simpleReadWriteOf: (Array with: STLFilerTest with: STLFilerTest).
	self assert: answer first = STLFilerTest.
	self assert: answer first == answer last!

testIntegerReadWrite
	"SmallInteger"
	| contents |
	self checkSimpleReadWriteOf: 999.
	"LargeInteger"
	contents := self checkSimpleReadWriteOf: 99999999999.
	self assert: (contents includes: 99999999999)!

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
	self assert: answer first = myRectangle.
	self assert: answer first == answer last!

testResourceReadWrite
	| rid shell shell1 shell2 in contents1 contents2 |
	rid := ResourceIdentifier class: ClassBrowserShell name: 'Default view'.
	
	[shell := rid loadWithContext: View desktop.
	contents1 := self writeLiteralsFor: shell.
	in := STLInFiler on: contents1 readStream.
	in context: View desktop.
	shell1 := in next.
	self assert: (shell1 isKindOf: ShellView).
	self assert: shell1 isOpen.
	contents2 := self writeLiteralsFor: shell1.
	in := STLInFiler on: contents2 readStream.
	in context: View desktop.
	shell2 := in next.
	self assert: (shell2 isKindOf: ShellView).
	self assert: shell2 isOpen.
	self assert: contents1 size = contents2 size] 
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
	| contents answer |
	contents := self checkSimpleReadWriteOf: #testSymbol.
	self assert: (contents includes: #testSymbol).

	"Now test that multiple references only occur once"
	contents := self checkSimpleReadWriteOf: #(#testSymbol #testSymbol #otherSymbol).
	self assert: (contents occurrencesOf: #testSymbol) = 1.
	self assert: (contents occurrencesOf: #otherSymbol) = 1.

	"Check that muliple references are identical"
	answer := self simpleReadWriteOf: #(testSymbol #testSymbol).
	self assert: answer first = #testSymbol.
	self assert: answer first == answer last!

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
!STLFilerTest categoriesFor: #writeLiteralsFor:!private!unit tests! !

