"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #ProtectInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ProtectInstanceVariableTest guid: (GUID fromString: '{4fadb9c6-abde-452c-90b8-bc1b80b72555}')!
ProtectInstanceVariableTest comment: ''!
!ProtectInstanceVariableTest categoriesForClass!Refactory-Testing! !
!ProtectInstanceVariableTest methodsFor!

testProtectInstanceVariable
	| refactoring class |
	refactoring := ProtectInstanceVariableRefactoring variable: 'rewrite' , 'Rule1'
				class: SubclassOfClassToRename.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #SubclassOfClassToRename.
	self assert: (class parseTreeFor: #calls1)
		equals: (RBParser parseMethod: 'calls1
								^rewriteRule1 := (rewriteRule1 := self calls)').
	self assert: (class parseTreeFor: #calls)
		equals: (RBParser parseMethod: 'calls
								^rewriteRule1 := rewriteRule1 , rewriteRule1').
	self deny: (class directlyDefinesMethod: ('rewrite' , 'Rule1') asSymbol).
	self deny: (class directlyDefinesMethod: ('rewrite' , 'Rule1:') asSymbol)!

testVariableNotDefined
	| refactoring |
	refactoring := ProtectInstanceVariableRefactoring variable: 'rewrite'
				class: SubclassOfClassToRename.
	self shouldFail: refactoring! !
!ProtectInstanceVariableTest categoriesFor: #testProtectInstanceVariable!public!tests! !
!ProtectInstanceVariableTest categoriesFor: #testVariableNotDefined!failure tests!public! !

