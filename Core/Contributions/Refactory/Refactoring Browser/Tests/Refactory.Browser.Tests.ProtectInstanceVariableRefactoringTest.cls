"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.ProtectInstanceVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.ProtectInstanceVariableRefactoringTest guid: (Core.GUID fromString: '{4fadb9c6-abde-452c-90b8-bc1b80b72555}')!

Refactory.Browser.Tests.ProtectInstanceVariableRefactoringTest comment: ''!

!Refactory.Browser.Tests.ProtectInstanceVariableRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.ProtectInstanceVariableRefactoringTest methodsFor!

testProtectInstanceVariable
	| refactoring class |
	refactoring := ProtectInstanceVariableRefactoring variable: 'rewrite' , 'Rule1'
				class: SubclassOfClassToRename.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.SubclassOfClassToRename'.
	self assert: (class parseTreeFor: #calls1)
		equals: (self parseMethod: 'calls1
								^rewriteRule1 := (rewriteRule1 := self calls)').
	self assert: (class parseTreeFor: #calls)
		equals: (self parseMethod: 'calls
								^rewriteRule1 := rewriteRule1 , rewriteRule1').
	"The name method should be preserved, even though it returns the value of the instance variable, because it is sent from elsewhere and so cannot be removed if behaviour is to be preserved."
	self assert: (class directlyDefinesMethod: 'name' asSymbol).
	self deny: (class directlyDefinesMethod: ('rewrite' , 'Rule1') asSymbol).
	self deny: (class directlyDefinesMethod: ('rewrite' , 'Rule1:') asSymbol)!

testVariableNotDefined
	| refactoring |
	refactoring := ProtectInstanceVariableRefactoring variable: 'rewrite' class: SubclassOfClassToRename.
	self shouldFail: refactoring withMessage: 'SubclassOfClassToRename does not define an instance variable ''rewrite'''! !

!Refactory.Browser.Tests.ProtectInstanceVariableRefactoringTest categoriesForMethods!
testProtectInstanceVariable!public!tests! !
testVariableNotDefined!failure tests!public! !
!

