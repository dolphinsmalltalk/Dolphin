"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.InlineParameterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.InlineParameterTest guid: (Core.GUID fromString: '{6a76ec20-1cb3-4e28-84e7-947775648e57}')!
Refactory.Browser.Tests.InlineParameterTest comment: ''!
!Refactory.Browser.Tests.InlineParameterTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.InlineParameterTest methodsFor!

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
	class := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	self assert: (class parseTreeFor: #inlineParameterMethod)
		equals: (RBParser
				parseMethod: 'inlineParameterMethod | aSymbol | aSymbol := #(asdf). ^aSymbol isSymbol').
	self assert: (class parseTreeFor: #sendInlineParameterMethod)
		equals: (RBParser parseMethod: 'sendInlineParameterMethod ^self inlineParameterMethod').
	self deny: (class directlyDefinesMethod: ('inline' , 'ParameterMethod:') asSymbol)! !
!Refactory.Browser.Tests.InlineParameterTest categoriesFor: #testInlineBlockFailure!failure tests!public! !
!Refactory.Browser.Tests.InlineParameterTest categoriesFor: #testInlineLiteralArray!public!tests! !

