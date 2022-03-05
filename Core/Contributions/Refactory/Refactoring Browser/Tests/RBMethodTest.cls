"Filed out from Dolphin Smalltalk"!

RefactoringBrowserTest subclass: #RBMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBMethodTest guid: (GUID fromString: '{dcaa75d7-68c0-41bd-9701-dbecb814444c}')!
RBMethodTest comment: ''!
!RBMethodTest categoriesForClass!Refactory-Testing! !
!RBMethodTest methodsFor!

testLiteralStringsDoNotMatchSymbols
	| class method |
	class := RBClass existingNamed: #RefactoryTestDataApp.
	method := class methodFor: #returnInEnsure.
	self deny: (method refersToSymbol: #asdf).
	method := class methodFor: #literalArrayStringsAndSymbols.
	self deny: (method refersToSymbol: #abc)!

testRefersToSymbol
	| class method |
	class := RBClass existingNamed: #RefactoryTestDataApp.
	method := class methodFor: #searchingLiteral.
	self assert: (method refersToSymbol: #printString).
	self assert: (method refersToSymbol: #abc).
	method := class methodFor: #literalArrayStringsAndSymbols.
	self assert: (method refersToSymbol: #def)! !
!RBMethodTest categoriesForMethods!
testLiteralStringsDoNotMatchSymbols!public! !
testRefersToSymbol!public! !
!

