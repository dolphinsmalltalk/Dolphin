"Filed out from Dolphin Smalltalk XP"!

BrowserEnvironmentTest subclass: #VariableEnvironmentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VariableEnvironmentTest guid: (GUID fromString: '{DD03C304-E6E0-47F2-8F26-E7EEF49D29BC}')!
VariableEnvironmentTest comment: ''!
!VariableEnvironmentTest categoriesForClass!Refactory-Testing! !
!VariableEnvironmentTest methodsFor!

testAddRemove
	| refs |
	refs := VariableEnvironment new.
	refs addClass: RefactoringManager instanceVariable: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses = 1.
	refs removeClass: RefactoringManager instanceVariable: 'refactorings'.
	self assert: refs numberSelectors = 0.
	self assert: refs numberClasses = 0.
	refs addClass: RefactoringManager instanceVariableReader: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses = 1.
	refs removeClass: RefactoringManager instanceVariableReader: 'refactorings'.
	self assert: refs numberSelectors = 0.
	self assert: refs numberClasses = 0.
	refs addClass: RefactoringManager instanceVariableWriter: 'refactorings'.
	self assert: refs numberSelectors > 0.
	self assert: refs numberClasses = 1.
	refs removeClass: RefactoringManager instanceVariableWriter: 'refactorings'.
	self assert: refs numberSelectors = 0.
	self assert: refs numberClasses = 0!

testInstVars
	| refs writers readers |
	refs := VariableEnvironment referencesToInstanceVariable: 'refactorings' in: RefactoringManager.
	writers := VariableEnvironment writersOfInstanceVariable: 'refactorings' in: RefactoringManager.
	readers := VariableEnvironment readersOfInstanceVariable: 'refactorings' in: RefactoringManager.
	self universalTestFor: refs.
	self universalTestFor: writers.
	self universalTestFor: readers.
	self assert: refs numberSelectors = (writers | readers) numberSelectors! !
!VariableEnvironmentTest categoriesFor: #testAddRemove!public!tests! !
!VariableEnvironmentTest categoriesFor: #testInstVars!public!tests! !

