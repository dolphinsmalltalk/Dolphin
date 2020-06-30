"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #InlineParameterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
InlineParameterTest guid: (GUID fromString: '{6a76ec20-1cb3-4e28-84e7-947775648e57}')!
InlineParameterTest comment: ''!
!InlineParameterTest categoriesForClass!Refactory-Testing! !
!InlineParameterTest methodsFor!

testInlineBlockFailure
	self shouldFail: (InlineParameterRefactoring 
				inlineParameter: 'aBlock'
				in: RefactoryTestDataApp
				selector: ('inline' , 'Foo:') asSymbol)!

testInlineLiteralArray
	| refactoring class |
	refactoring := InlineParameterRefactoring
				inlineParameter: 'aSymbol'
				in: RefactoryTestDataApp
				selector: ('inline' , 'ParameterMethod:') asSymbol.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self assert: (class parseTreeFor: #inlineParameterMethod)
		equals: (RBParser
				parseMethod: 'inlineParameterMethod | aSymbol | aSymbol := #(asdf). ^aSymbol isSymbol').
	self assert: (class parseTreeFor: #sendInlineParameterMethod)
		equals: (RBParser parseMethod: 'sendInlineParameterMethod ^self inlineParameterMethod').
	self deny: (class directlyDefinesMethod: ('inline' , 'ParameterMethod:') asSymbol)! !
!InlineParameterTest categoriesFor: #testInlineBlockFailure!failure tests!public! !
!InlineParameterTest categoriesFor: #testInlineLiteralArray!public!tests! !

