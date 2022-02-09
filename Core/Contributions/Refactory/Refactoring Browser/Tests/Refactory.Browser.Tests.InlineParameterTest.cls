"Filed out from Dolphin Smalltalk"!

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
				selector: ('inline' , 'Foo:') asSymbol)
		withMessage: 'All values passed as this argument must be literal.'!

testInlineLiteralArray
	| refactoring class change |
	refactoring := InlineParameterRefactoring
				inlineParameter: 'aSymbol'
				in: RefactoryTestDataApp
				selector: ('inline' , 'ParameterMethod:') asSymbol.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #inlineParameterMethod)
		equals: (self
				parseMethod: 'inlineParameterMethod <namespace: Tools> | aSymbol | aSymbol := #(asdf). ^aSymbol isSymbol').
	self assert: (class parseTreeFor: #sendInlineParameterMethod)
		equals: (self parseMethod: 'sendInlineParameterMethod ^self inlineParameterMethod').
	self deny: (class directlyDefinesMethod: ('inline' , 'ParameterMethod:') asSymbol).
	change := refactoring model changes changes first.
	self assert: change package identicalTo: self class owningPackage.
	self assert: change environment identicalTo: Tools! !
!Refactory.Browser.Tests.InlineParameterTest categoriesForMethods!
testInlineBlockFailure!failure tests!public! !
testInlineLiteralArray!public!tests! !
!

