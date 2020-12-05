"Filed out from Dolphin Smalltalk 7"!

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
	path := File composePath: self class owningPackage path subPath: aString.
	^(FileStream read: path) contents!

setUp
	| assoc |
	super setUp.
	assoc := RefactoringManager classPool associationAt: #Instance
				ifAbsent: [RefactoringManager classPool associationAt: 'Instance'].
	manager := assoc value.
	assoc value: nil.
	model := RBNamespace new!

setupImplementorToInlineFor: aRefactoring toReturn: anObject 
	| options |
	options := aRefactoring options copy.
	options at: #implementorToInline put: [:ref :imps | anObject].
	aRefactoring options: options!

setupInlineExpressionFor: aRefactoring toReturn: aBoolean 
	| options |
	options := aRefactoring options copy.
	options at: #inlineExpression put: [:ref :string | aBoolean].
	aRefactoring options: options!

setupMethodNameFor: aRefactoring toReturn: aSelector 
	| options |
	options := aRefactoring options copy.
	options at: #methodName
		put: 
			[:ref :aMethodName | 
			aMethodName
				selector: aSelector;
				yourself].
	aRefactoring options: options!

setupMethodNameFor: aRefactoring toReturn: aSelector withArguments: stringCollection 
	| options |
	options := aRefactoring options copy.
	options at: #methodName
		put: 
			[:ref :aMethodName | 
			aMethodName
				selector: aSelector;
				arguments: stringCollection;
				yourself].
	aRefactoring options: options!

setupSelfArgumentNameFor: aRefactoring toReturn: aString 
	| options |
	options := aRefactoring options copy.
	options at: #selfArgumentName put: [:ref | aString].
	aRefactoring options: options!

setupVariableToMoveToFor: aRefactoring toReturn: aString 
	| options |
	options := aRefactoring options copy.
	options at: #selectVariableToMoveTo put: [:ref :class :selector | aString].
	aRefactoring options: options!

setupVariableTypesFor: aRefactoring toReturn: anObject 
	| options |
	options := aRefactoring options copy.
	options at: #variableTypes put: [:ref :ignore1 :ignore2 | anObject].
	aRefactoring options: options!

shouldFail: aRefactoring
	self
		proceedThroughWarning: [self should: [self executeRefactoring: aRefactoring] raise: RefactoringError]!

shouldWarn: aRefactoring
	self should: [self executeRefactoring: aRefactoring] raise: RefactoringWarning!

tearDown
	super tearDown.
	RefactoringManager instance release.
	(RefactoringManager classPool associationAt: #Instance
		ifAbsent: [RefactoringManager classPool associationAt: 'Instance']) value: manager! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #readFile:!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #setUp!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #setupImplementorToInlineFor:toReturn:!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #setupInlineExpressionFor:toReturn:!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #setupMethodNameFor:toReturn:!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #setupMethodNameFor:toReturn:withArguments:!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #setupSelfArgumentNameFor:toReturn:!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #setupVariableToMoveToFor:toReturn:!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #setupVariableTypesFor:toReturn:!public!set up! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #shouldFail:!private! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #shouldWarn:!private! !
!Refactory.Browser.Tests.RefactoringTest categoriesFor: #tearDown!public!set up! !

