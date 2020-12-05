"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.ProtectInstanceVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ProtectInstanceVariableTest guid: (Core.GUID fromString: '{4fadb9c6-abde-452c-90b8-bc1b80b72555}')!
Refactory.Browser.Tests.ProtectInstanceVariableTest comment: ''!
!Refactory.Browser.Tests.ProtectInstanceVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ProtectInstanceVariableTest methodsFor!

testProtectInstanceVariable
	| refactoring class |
	refactoring := ProtectInstanceVariableRefactoring variable: 'rewrite' , 'Rule1'
				class: SubclassOfClassToRename.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.SubclassOfClassToRename'.
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
	refactoring := ProtectInstanceVariableRefactoring variable: 'rewrite' class: SubclassOfClassToRename.
	self shouldFail: refactoring! !
!Refactory.Browser.Tests.ProtectInstanceVariableTest categoriesFor: #testProtectInstanceVariable!public!tests! !
!Refactory.Browser.Tests.ProtectInstanceVariableTest categoriesFor: #testVariableNotDefined!failure tests!public! !

