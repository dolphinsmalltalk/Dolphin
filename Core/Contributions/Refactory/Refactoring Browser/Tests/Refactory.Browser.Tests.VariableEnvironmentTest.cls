"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.BrowserEnvironmentTest subclass: #'Refactory.Browser.Tests.VariableEnvironmentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.VariableEnvironmentTest guid: (Core.GUID fromString: '{dd03c304-e6e0-47f2-8f26-e7eef49d29bc}')!
Refactory.Browser.Tests.VariableEnvironmentTest comment: ''!
!Refactory.Browser.Tests.VariableEnvironmentTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.VariableEnvironmentTest methodsFor!

testAddRemove
	| refs |
	refs := VariableEnvironment new.
	refs addClass: RefactoringManager instanceVariable: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses equals: 1.
	refs removeClass: RefactoringManager instanceVariable: 'refactorings'.
	self assert: refs numberSelectors equals: 0.
	self assert: refs numberClasses equals: 0.
	refs addClass: RefactoringManager instanceVariableReader: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses equals: 1.
	refs removeClass: RefactoringManager instanceVariableReader: 'refactorings'.
	self assert: refs numberSelectors equals: 0.
	self assert: refs numberClasses equals: 0.
	refs addClass: RefactoringManager instanceVariableWriter: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses equals: 1.
	refs removeClass: RefactoringManager instanceVariableWriter: 'refactorings'.
	self assert: refs numberSelectors equals: 0.
	self assert: refs numberClasses equals: 0!

testInstVars
	| refs writers readers |
	refs := VariableEnvironment referencesToInstanceVariable: 'refactorings' in: RefactoringManager.
	writers := VariableEnvironment writersOfInstanceVariable: 'refactorings' in: RefactoringManager.
	readers := VariableEnvironment readersOfInstanceVariable: 'refactorings' in: RefactoringManager.
	self universalTestFor: refs.
	self universalTestFor: writers.
	self universalTestFor: readers.
	self assert: refs numberSelectors equals: (writers | readers) numberSelectors! !
!Refactory.Browser.Tests.VariableEnvironmentTest categoriesFor: #testAddRemove!public!tests! !
!Refactory.Browser.Tests.VariableEnvironmentTest categoriesFor: #testInstVars!public!tests! !

