"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.ClassNameToBindingReferenceRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ClassNameToBindingReferenceRefactoringTest guid: (Core.GUID fromString: '{2a06fd11-d52a-4bd1-98eb-fad2671fad7e}')!
Refactory.Browser.Tests.ClassNameToBindingReferenceRefactoringTest comment: ''!
!Refactory.Browser.Tests.ClassNameToBindingReferenceRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ClassNameToBindingReferenceRefactoringTest methodsFor!

testConvertAlias
	| refactoring testClass |
	refactoring := (ClassNameToBindingReferenceRefactoring model: model
				replaceSymbolicReferencesTo: External.Handle)
				unqualifiedName: #ExternalHandle;
				yourself.
	self executeRefactoring: refactoring.
	testClass := model classFor: RefactoryTestDataApp.
	self
		verifyMethod: #smalltalkAtAlias
		of: testClass
		equals: '<1s> ^#{External.Handle} value'!

testConvertSymbolsToBindingReferences
	| refactoring testClass |
	refactoring := (ClassNameToBindingReferenceRefactoring model: model
				replaceSymbolicReferencesTo: Smalltalk.PoolConstantsDictionary) yourself.
	self executeRefactoring: refactoring.
	testClass := model classFor: RefactoryTestDataApp.
	self
		verifyMethod: #smalltalkAtIfAbsent
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} ifNotDefined: [self error: ''absent'']'.
	self
		verifyMethod: #smalltalkAtIfPresent
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} ifDefined: [:pc | pc name, '' is present'']'.
	self
		verifyMethod: #smalltalkLookup
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} valueOrNil'.
	self
		verifyMethod: #smalltalkAssociationAt
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} binding'.
	self
		verifyMethod: #smalltalkAssociationAtIfAbsent
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} bindingOrNil ifNil: [self error: ''absent'']'.
	self
		verifyMethod: #smalltalkAssociationAtIfPresent
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} bindingOrNil ifNotNil: [:pc | pc value name, '' is present'']'.
	self
		verifyMethod: #smalltalkIncludesKey
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} isDefined'.
	self
		verifyMethod: #smalltalkRemoveKey
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} undeclare'.
	self
		verifyMethod: #smalltalkRemoveKeyIfAbsent
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} undeclare ifNil: [self error: ''absent'']'.
	self
		verifyMethod: #smalltalkAtPut
		of: testClass
		equals: '<1s> ^#{Smalltalk.PoolConstantsDictionary} declare: nil'! !
!Refactory.Browser.Tests.ClassNameToBindingReferenceRefactoringTest categoriesForMethods!
testConvertAlias!public! !
testConvertSymbolsToBindingReferences!public! !
!

