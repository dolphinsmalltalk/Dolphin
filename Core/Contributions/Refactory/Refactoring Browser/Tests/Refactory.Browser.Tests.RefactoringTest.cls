"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.RefactoringTest'
	instanceVariableNames: 'manager changeSet model'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RefactoringTest guid: (Core.GUID fromString: '{bab50ae8-d54a-4645-9a41-ea07018cedf6}')!
Refactory.Browser.Tests.RefactoringTest isNonInstantiable: true!
Refactory.Browser.Tests.RefactoringTest comment: ''!
!Refactory.Browser.Tests.RefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RefactoringTest methodsFor!

readFile: aString
	| path |
	#rbFix.	"^aString asFilename contentsOfEntireFile"
	path := (PackageRelativeFileLocator package: self class owningPackage) localFileSpecFor: aString.
	^(FileStream read: path) contents!

setUp
	| assoc |
	super setUp.
	assoc := RefactoringManager localBindingFor: 'Instance'.
	manager := assoc value.
	assoc value: nil.
	model := RBNamespace new!

setupImplementorToInlineFor: aRefactoring toReturn: anObject
	aRefactoring setOption: #implementorToInline toUse: [:ref :imps | anObject]!

setupInlineExpressionFor: aRefactoring toReturn: aBoolean
	aRefactoring setOption: #inlineExpression toUse: [:ref :string | aBoolean]!

setupMethodNameFor: aRefactoring toReturn: aSelector
	aRefactoring setOption: #methodName
		toUse: 
			[:ref :aMethodName |
			aMethodName
				selector: aSelector;
				yourself]!

setupMethodNameFor: aRefactoring toReturn: aSelector withArguments: stringCollection
	aRefactoring setOption: #methodName
		toUse: 
			[:ref :aMethodName |
			aMethodName
				selector: aSelector;
				arguments: stringCollection;
				yourself]!

setupSelfArgumentNameFor: aRefactoring toReturn: aString 
	aRefactoring setOption: #selfArgumentName toUse: [:ref | aString]!

setupVariableToMoveToFor: aRefactoring toReturn: aString 
	aRefactoring setOption: #selectVariableToMoveTo toUse: [:ref :class :selector | aString]!

setupVariableTypesFor: aRefactoring toReturn: anObject
	aRefactoring setOption: #variableTypes toUse: [:ref :ignore1 :ignore2 | anObject]!

shouldFail: aRefactoring
	self should: [self executeRefactoring: aRefactoring] raise: RefactoringError!

shouldWarn: aRefactoring
	self should: [self executeRefactoring: aRefactoring] raise: RefactoringWarning!

tearDown
	super tearDown.
	RefactoringManager instance release.
	(RefactoringManager classPool associationAt: #Instance
		ifAbsent: [RefactoringManager classPool associationAt: 'Instance']) value: manager! !
!Refactory.Browser.Tests.RefactoringTest categoriesForMethods!
readFile:!public!set up! !
setUp!public!set up! !
setupImplementorToInlineFor:toReturn:!public!set up! !
setupInlineExpressionFor:toReturn:!public!set up! !
setupMethodNameFor:toReturn:!public!set up! !
setupMethodNameFor:toReturn:withArguments:!public!set up! !
setupSelfArgumentNameFor:toReturn:!public!set up! !
setupVariableToMoveToFor:toReturn:!public!set up! !
setupVariableTypesFor:toReturn:!public!set up! !
shouldFail:!private! !
shouldWarn:!private! !
tearDown!public!set up! !
!

