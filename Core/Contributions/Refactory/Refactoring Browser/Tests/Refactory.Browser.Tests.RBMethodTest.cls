"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.RBMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RBMethodTest guid: (Core.GUID fromString: '{dcaa75d7-68c0-41bd-9701-dbecb814444c}')!
Refactory.Browser.Tests.RBMethodTest comment: ''!
!Refactory.Browser.Tests.RBMethodTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RBMethodTest methodsFor!

testLiteralStringsDoNotMatchSymbols
	| class method |
	class := RBClass existingNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	method := class methodFor: #returnInEnsure.
	self deny: (method refersToSymbol: #asdf).
	method := class methodFor: #literalArrayStringsAndSymbols.
	self deny: (method refersToSymbol: #abc)!

testRefersToSymbol
	| class method |
	class := RBClass existingNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	method := class methodFor: #searchingLiteral.
	self assert: (method refersToSymbol: #printString).
	self assert: (method refersToSymbol: #abc).
	method := class methodFor: #literalArrayStringsAndSymbols.
	self assert: (method refersToSymbol: #def)! !
!Refactory.Browser.Tests.RBMethodTest categoriesFor: #testLiteralStringsDoNotMatchSymbols!public! !
!Refactory.Browser.Tests.RBMethodTest categoriesFor: #testRefersToSymbol!public! !

