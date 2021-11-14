"Filed out from Dolphin Smalltalk"!

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
	model := self abstractVariableTestData!

testNonExistantName
	self
		shouldFail: (TemporaryToInstanceVariableRefactoring
					class: BasicLintRuleTestData
					selector: #checkClass:
					variable: 'asdf')
			withMessage: 'asdf isn''t a valid temporary variable name';
		shouldFail: (TemporaryToInstanceVariableRefactoring
					class: BasicLintRuleTestData
					selector: #checkClass1:
					variable: 'aSmalllintContext')
			withMessage: 'BasicLintRuleTestData does not define #checkClass1:'!

testRedefinedTemporary
	| class |
	class := model classNamed: #Foo.
	class compile: 'someMethod | instVarName1 | instVarName1 := 4. ^instVarName1' classified: #accessing.
	self shouldFail: (TemporaryToInstanceVariableRefactoring
				class: class
				selector: #someMethod
				variable: 'instVarName1')
		withMessage: 'Foo or one of its subclasses defines variable ''instVarName1'''!

testTemporaryToInstanceVariable
	| refactoring class |
	refactoring := TemporaryToInstanceVariableRefactoring
				class: LintRuleTestData
				selector: #displayName
				variable: 'nameStream'.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTestData'.
	self assert: (class parseTreeFor: #displayName)
		equals: (self
				parseMethod: 'displayName
								nameStream := WriteStream on: (String new: 64).
								nameStream
									nextPutAll: self name;
									nextPutAll: '' (''.
								self problemCount printOn: nameStream.
								nameStream nextPut: $).
								^nameStream contents').
	self assert: (class directlyDefinesInstanceVariable: 'nameStream')! !
!Refactory.Browser.Tests.TemporaryToInstanceVariableTest categoriesForMethods!
setUp!public!set up! !
testNonExistantName!failure tests!public! !
testRedefinedTemporary!failure tests!public! !
testTemporaryToInstanceVariable!public!tests! !
!

