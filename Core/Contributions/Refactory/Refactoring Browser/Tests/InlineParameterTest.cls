"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #InlineParameterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlineParameterTest guid: (GUID fromString: '{6A76EC20-1CB3-4E28-84E7-947775648E57}')!
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
	self 
		assert: (class parseTreeFor: #inlineParameterMethod) = (RBParser 
						parseMethod: 'inlineParameterMethod | aSymbol | aSymbol := #(asdf). ^aSymbol isSymbol').
	self 
		assert: (class parseTreeFor: #sendInlineParameterMethod) = (RBParser 
						parseMethod: 'sendInlineParameterMethod ^self inlineParameterMethod').
	self deny: (class 
				directlyDefinesMethod: ('inline' , 'ParameterMethod:') asSymbol)! !
!InlineParameterTest categoriesFor: #testInlineBlockFailure!failure tests!public! !
!InlineParameterTest categoriesFor: #testInlineLiteralArray!public!tests! !

