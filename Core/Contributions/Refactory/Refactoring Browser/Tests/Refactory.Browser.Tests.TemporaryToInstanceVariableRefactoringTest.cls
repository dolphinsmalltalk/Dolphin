"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.TemporaryToInstanceVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.TemporaryToInstanceVariableRefactoringTest guid: (Core.GUID fromString: '{92c5ee4b-e4af-4af1-92ed-1a24ab0830bc}')!
Refactory.Browser.Tests.TemporaryToInstanceVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.TemporaryToInstanceVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.TemporaryToInstanceVariableRefactoringTest methodsFor!

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

testReadBeforeWritten
	| refactoring class |
	refactoring := TemporaryToInstanceVariableRefactoring
				class: RefactoryTestDataApp
				selector: #tempsReadBeforeWritten
				variable: 'temp'.
	refactoring setOption: #convertReadBeforeWritten
		toUse: 
			[:rcvr :var |
			self assert: var equals: 'temp'.
			false].
	self shouldAbort: refactoring.
	refactoring setOption: #convertReadBeforeWritten toUse: [true].
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #tempsReadBeforeWritten)
		equals: (self parseMethod: 'tempsReadBeforeWritten
	self isVariable ifTrue: [temp := 4].
	^temp').
	self assert: (class directlyDefinesInstanceVariable: 'temp')!

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
	class := refactoring model classFor: LintRuleTestData.
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
!Refactory.Browser.Tests.TemporaryToInstanceVariableRefactoringTest categoriesForMethods!
setUp!public!set up! !
testNonExistantName!failure tests!public! !
testReadBeforeWritten!failure tests!public! !
testRedefinedTemporary!failure tests!public! !
testTemporaryToInstanceVariable!public!tests! !
!

