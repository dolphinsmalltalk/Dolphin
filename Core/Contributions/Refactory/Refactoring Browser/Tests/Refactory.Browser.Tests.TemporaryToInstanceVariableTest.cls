"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.TemporaryToInstanceVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.TemporaryToInstanceVariableTest guid: (Core.GUID fromString: '{92c5ee4b-e4af-4af1-92ed-1a24ab0830bc}')!
Refactory.Browser.Tests.TemporaryToInstanceVariableTest comment: ''!
!Refactory.Browser.Tests.TemporaryToInstanceVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.TemporaryToInstanceVariableTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testNonExistantName
	self
		shouldFail: (TemporaryToInstanceVariableRefactoring
					class: BasicLintRuleTest
					selector: #checkClass:
					variable: 'asdf');
		shouldFail: (TemporaryToInstanceVariableRefactoring
					class: BasicLintRuleTest
					selector: #checkClass1:
					variable: 'aSmalllintContext')!

testRedefinedTemporary
	| class |
	class := model classNamed: #Foo.
	class compile: 'someMethod | instVarName1 | instVarName1 := 4. ^instVarName1'
		classified: #(#accessing).
	self shouldFail: (TemporaryToInstanceVariableRefactoring
				class: class
				selector: #someMethod
				variable: 'instVarName1')!

testTemporaryToInstanceVariable
	| refactoring class |
	refactoring := TemporaryToInstanceVariableRefactoring
				class: LintRuleTest
				selector: #displayName
				variable: 'nameStream'.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest'.
	self assert: (class parseTreeFor: #displayName)
		equals: (RBParser
				parseMethod: 'displayName
								nameStream := WriteStream on: (String new: 64).
								nameStream
									nextPutAll: self name;
									nextPutAll: '' (''.
								self problemCount printOn: nameStream.
								nameStream nextPut: $).
								^nameStream contents').
	self assert: (class directlyDefinesInstanceVariable: 'nameStream')! !
!Refactory.Browser.Tests.TemporaryToInstanceVariableTest categoriesFor: #setUp!public!set up! !
!Refactory.Browser.Tests.TemporaryToInstanceVariableTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.TemporaryToInstanceVariableTest categoriesFor: #testRedefinedTemporary!failure tests!public! !
!Refactory.Browser.Tests.TemporaryToInstanceVariableTest categoriesFor: #testTemporaryToInstanceVariable!public!tests! !

