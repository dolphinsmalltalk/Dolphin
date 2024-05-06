"Filed out from Dolphin Smalltalk"!

RefactoringBrowserTest subclass: #RefactoringTest
	instanceVariableNames: 'manager changeSet model'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RefactoringTest guid: (GUID fromString: '{bab50ae8-d54a-4645-9a41-ea07018cedf6}')!

RefactoringTest comment: ''!

!RefactoringTest categoriesForClass!Refactory-Testing! !

!RefactoringTest methodsFor!

readFile: aString 
	| path |
	#rbFix. "^aString asFilename contentsOfEntireFile"
	path := File composePath: (Package manager packageNamed: 'RBTests') path subPath: aString.
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
	self proceedThroughWarning: 
			[self should: [self executeRefactoring: aRefactoring]
				raise: RefactoringError]!

shouldWarn: aRefactoring 
	self should: [self executeRefactoring: aRefactoring]
		raise: RefactoringWarning!

tearDown
	super tearDown.
	RefactoringManager instance release.
	(RefactoringManager classPool associationAt: #Instance
		ifAbsent: [RefactoringManager classPool associationAt: 'Instance']) 
			value: manager!

testConditions
	| condition newCondition |
	condition := RBCondition new
				type: #false
				block: [false]
				errorString: 'false'.
	condition errorMacro: '<1?true:false>'.
	self deny: condition check.
	self assert: condition errorString equals: 'false'.
	self assert: condition not check.
	self assert: condition printString equals: '#false'.
	self assert: condition not printString equals: 'NOT #false'.
	self deny: (condition not & condition) check.
	self assert: (condition not & condition) printString equals: 'NOT #false & #false'.
	self assert: (condition & condition) not check.
	self assert: (condition | condition not) check.
	self deny: (newCondition := condition | condition) check.
	self assert: newCondition errorString equals: 'false AND false'.
	self assert: (condition not | condition not) check.
	self deny: (newCondition := condition & condition) check.
	self assert: newCondition errorString equals: 'false'.
	self assert: (condition not & condition not) check.
	self assert: (condition & condition) errorString equals: 'false OR false'!

testPrintRefactoringManager
	Transcript
		show: RefactoringManager instance printString;
		cr;
		flush! !

!RefactoringTest categoriesForMethods!
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
testConditions!public!tests! !
testPrintRefactoringManager!public!tests! !
!

