"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoringTest subclass: #ProtectInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ProtectInstanceVariableTest comment: ''!

ProtectInstanceVariableTest guid: (GUID fromString: '{4FADB9C6-ABDE-452C-90B8-BC1B80B72555}')!

!ProtectInstanceVariableTest categoriesForClass!Refactory-Testing! !
!ProtectInstanceVariableTest methodsFor!

testProtectInstanceVariable
	| refactoring class |
	refactoring := ProtectInstanceVariableRefactoring 
				variable: 'rewrite' , 'Rule1'
				class: SubclassOfClassToRename.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #SubclassOfClassToRename.
	self 
		assert: (class parseTreeFor: #calls1) = (RBParser 
						parseMethod: 'calls1
								^rewriteRule1 := (rewriteRule1 := self calls)').
	self 
		assert: (class parseTreeFor: #calls) = (RBParser 
						parseMethod: 'calls
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

