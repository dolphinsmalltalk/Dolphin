"Filed out from Dolphin Smalltalk 7"!

RefactoringBrowserTest subclass: #SmalllintTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SmalllintTest guid: (GUID fromString: '{1c8afe99-7a10-4ecd-a108-0f8f9bb5bdba}')!
SmalllintTest comment: 'SUnitBrowser openOnTestCase: self'!
!SmalllintTest categoriesForClass!Refactory-Testing! !
!SmalllintTest methodsFor!

blockRuleFor: aSelector 
	self blockRuleFor: aSelector plusSelectors: #()!

blockRuleFor: aSelector plusSelectors: symbolCollection 
	| rule returnedEnvironment testSel |
	#rbFix. "testSelector temp classes with inst. var. of the same name"
	testSel := aSelector asString copyFrom: 5 to: aSelector size.
	testSel at: 1 put: testSel first asLowercase.
	testSel := testSel asSymbol.
	(BlockLintRule class includesSelector: testSel) ifFalse: [^self].
	SmalllintChecker runRule: (rule := BlockLintRule perform: testSel)
		onEnvironment: self refactoryTestAppEnvironment.
	returnedEnvironment := SelectorEnvironment new.
	returnedEnvironment addClass: RefactoryTestDataApp selector: testSel.
	symbolCollection 
		do: [:each | returnedEnvironment addClass: RefactoryTestDataApp selector: each].
	self checkRule: rule isEqualTo: returnedEnvironment!

checkRule: aLintRule isEqualTo: anEnvironment 
	| returnedEnvironment |
	returnedEnvironment := aLintRule result.
	self compare: returnedEnvironment to: anEnvironment.
	self compare: anEnvironment to: returnedEnvironment!

compare: subEnvironment to: superEnvironment 
	subEnvironment classesDo: 
			[:each | 
			(subEnvironment selectorsForClass: each) 
				do: [:sel | self assert: (superEnvironment includesSelector: sel in: each)]]!

currentSelector
	#rbFix. "thisContext is address of StackFrame in Dolphin, not a context object"
	"^thisContext sender selector."
	^Processor activeProcess topFrame sender method selector
!

parseTreeRuleFor: aSelector 
	self parseTreeRuleFor: aSelector plusSelectors: #()!

parseTreeRuleFor: aSelector plusSelectors: symbolCollection 
	| returnedEnvironment testSel rule |
	#rbFix. "testSelector temp classes with inst. var. of the same name"
	testSel := aSelector asString copyFrom: 5 to: aSelector size.
	testSel at: 1 put: testSel first asLowercase.
	testSel := testSel asSymbol.
	SmalllintChecker 
		runRule: (rule := ParseTreeLintRule perform: testSel)
		onEnvironment: self refactoryTestAppEnvironment.
	returnedEnvironment := SelectorEnvironment new.
	returnedEnvironment addClass: RefactoryTestDataApp selector: testSel.
	symbolCollection 
		do: [:each | returnedEnvironment addClass: RefactoryTestDataApp selector: each].
	self checkRule: rule isEqualTo: returnedEnvironment!

refactoryTestAppEnvironment
	| classEnvironment |
	classEnvironment := ClassEnvironment new.
	classEnvironment addClass: RefactoryTestDataApp.
	^classEnvironment!

testAnySatisfy
	self parseTreeRuleFor: self currentSelector!

testAsOrderedCollectionNotNeeded
	self parseTreeRuleFor: self currentSelector!

testAssignmentInBlock
	self parseTreeRuleFor: self currentSelector!

testAssignmentInIfTrue
	self parseTreeRuleFor: self currentSelector!

testAtIfAbsent
	self parseTreeRuleFor: self currentSelector!

testBadMessage
	self blockRuleFor: self currentSelector!

testBooleanPrecedence
	self parseTreeRuleFor: self currentSelector!

testCollectionMessagesToExternalObject
	self blockRuleFor: self currentSelector!

testCollectionProtocol
	self parseTreeRuleFor: self currentSelector!

testCollectSelectNotUsed
	self parseTreeRuleFor: self currentSelector!

testConsistencyCheck
	self parseTreeRuleFor: self currentSelector!

testDetectAnySatisfy
	self parseTreeRuleFor: self currentSelector!

testEndTrueFalse
	self parseTreeRuleFor: self currentSelector!

testEqualNotUsed
	self parseTreeRuleFor: self currentSelector!

testEqualsTrue
	self parseTreeRuleFor: self currentSelector!

testEquivalentSuperclassMethods
	| returnedEnvironment rule |
	SmalllintChecker 
		runRule: (rule := BlockLintRule equivalentSuperclassMethods)
		onEnvironment: self refactoryTestAppEnvironment.
	returnedEnvironment := SelectorEnvironment new.
	returnedEnvironment addClass: RefactoryTestDataApp selector: #isLiteral.
	self checkRule: rule isEqualTo: returnedEnvironment!

testExtraBlock
	self parseTreeRuleFor: self currentSelector plusSelectors: #(#testMethod1)!

testFileBlocks
	self parseTreeRuleFor: self currentSelector!

testFullBlocks
	"This test will always fail on Dolphin 3/4 because the BlockLintRule class>>fullBlocks identifies all methods with
	blocks as having full blocks since Dolphin does not distinguish."

	VMLibrary default bytecodeVersion lowWord < 6 ifTrue: [^self].
	self blockRuleFor: self currentSelector
		plusSelectors: #(#caller1 #fullBlocks #detectAnySatisfy #fileBlocks #moveDefinition #caller #assignmentInBlock #equalNotUsed #stringConcatenation #noMoveDefinition #referencesConditionFor: #returnInEnsure)!

testGuardingClause
	self parseTreeRuleFor: self currentSelector!

testIfTrueBlocks
	self parseTreeRuleFor: self currentSelector!

testIfTrueReturns
	self parseTreeRuleFor: self currentSelector!

testJustSendsSuper
	self blockRuleFor: self currentSelector!

testLiteralArrayCharacters
	self parseTreeRuleFor: self currentSelector!

testLongMethods
	self blockRuleFor: self currentSelector!

testMinMax
	self parseTreeRuleFor: self currentSelector!

testMissingYourself
	self parseTreeRuleFor: self currentSelector plusSelectors: #(#inlineMethod)!

testModifiesCollection
	self parseTreeRuleFor: self currentSelector!

testOverridesSpecialMessage
	| rule returnedEnvironment |
	SmalllintChecker runRule: (rule := BlockLintRule overridesSpecialMessage)
		onEnvironment: self refactoryTestAppEnvironment.
	returnedEnvironment := SelectorEnvironment new.
	returnedEnvironment addClass: RefactoryTestDataApp selector: #==.
"	returnedEnvironment addClass: RefactoryTestDataApp class selector: #comment."
	self checkRule: rule isEqualTo: returnedEnvironment!

testPrecedence
	self parseTreeRuleFor: self currentSelector!

testRefersToClass
	self blockRuleFor: self currentSelector!

testReturnInEnsure
	self parseTreeRuleFor: self currentSelector!

testReturnsBooleanAndOther
	self blockRuleFor: self currentSelector!

testReturnsIfTrue
	self parseTreeRuleFor: self currentSelector!

testSearchingLiteral
	self parseTreeRuleFor: self currentSelector!

testSendsDifferentSuper
	self blockRuleFor: self currentSelector!

testSizeCheck
	self parseTreeRuleFor: self currentSelector!

testStringConcatenation
	self parseTreeRuleFor: self currentSelector!

testSuperSends
	| rule returnedEnvironment |
	SmalllintChecker runRule: (rule := BlockLintRule superSends)
		onEnvironment: self refactoryTestAppEnvironment.
	returnedEnvironment := SelectorEnvironment new.
	returnedEnvironment addClass: RefactoryTestDataApp selector: #release.
	self checkRule: rule isEqualTo: returnedEnvironment!

testTempsReadBeforeWritten
	self blockRuleFor: self currentSelector
		plusSelectors: #(#inlineTemporary #noMoveDefinition #tempsReadBeforeWritten #equalNotUsed #fileBlocks #referencesConditionFor:)!

testTempVarOverridesInstVar
	self blockRuleFor: self currentSelector!

testThreeElementPoint
	self parseTreeRuleFor: self currentSelector!

testToDo
	self parseTreeRuleFor: self currentSelector!

testToDoCollect
	self parseTreeRuleFor: self currentSelector!

testToDoWithIncrement
	self parseTreeRuleFor: self currentSelector!

testUsesAdd
	self parseTreeRuleFor: self currentSelector!

testWhileTrue
	self parseTreeRuleFor: self currentSelector!

testYourselfNotUsed
	self parseTreeRuleFor: self currentSelector! !
!SmalllintTest categoriesFor: #blockRuleFor:!public!set up! !
!SmalllintTest categoriesFor: #blockRuleFor:plusSelectors:!public!set up! !
!SmalllintTest categoriesFor: #checkRule:isEqualTo:!public!set up! !
!SmalllintTest categoriesFor: #compare:to:!public!set up! !
!SmalllintTest categoriesFor: #currentSelector!public!set up! !
!SmalllintTest categoriesFor: #parseTreeRuleFor:!public!set up! !
!SmalllintTest categoriesFor: #parseTreeRuleFor:plusSelectors:!public!set up! !
!SmalllintTest categoriesFor: #refactoryTestAppEnvironment!public!set up! !
!SmalllintTest categoriesFor: #testAnySatisfy!public!tests! !
!SmalllintTest categoriesFor: #testAsOrderedCollectionNotNeeded!public!tests! !
!SmalllintTest categoriesFor: #testAssignmentInBlock!public!tests! !
!SmalllintTest categoriesFor: #testAssignmentInIfTrue!public!tests! !
!SmalllintTest categoriesFor: #testAtIfAbsent!public!tests! !
!SmalllintTest categoriesFor: #testBadMessage!public!tests! !
!SmalllintTest categoriesFor: #testBooleanPrecedence!public!tests! !
!SmalllintTest categoriesFor: #testCollectionMessagesToExternalObject!public!tests! !
!SmalllintTest categoriesFor: #testCollectionProtocol!public!tests! !
!SmalllintTest categoriesFor: #testCollectSelectNotUsed!public!tests! !
!SmalllintTest categoriesFor: #testConsistencyCheck!public!tests! !
!SmalllintTest categoriesFor: #testDetectAnySatisfy!public!tests! !
!SmalllintTest categoriesFor: #testEndTrueFalse!public!tests! !
!SmalllintTest categoriesFor: #testEqualNotUsed!public!tests! !
!SmalllintTest categoriesFor: #testEqualsTrue!public!tests! !
!SmalllintTest categoriesFor: #testEquivalentSuperclassMethods!public!tests! !
!SmalllintTest categoriesFor: #testExtraBlock!public!tests! !
!SmalllintTest categoriesFor: #testFileBlocks!public!tests! !
!SmalllintTest categoriesFor: #testFullBlocks!public!tests! !
!SmalllintTest categoriesFor: #testGuardingClause!public!tests! !
!SmalllintTest categoriesFor: #testIfTrueBlocks!public!tests! !
!SmalllintTest categoriesFor: #testIfTrueReturns!public!tests! !
!SmalllintTest categoriesFor: #testJustSendsSuper!public!tests! !
!SmalllintTest categoriesFor: #testLiteralArrayCharacters!public!tests! !
!SmalllintTest categoriesFor: #testLongMethods!public!tests! !
!SmalllintTest categoriesFor: #testMinMax!public!tests! !
!SmalllintTest categoriesFor: #testMissingYourself!public!tests! !
!SmalllintTest categoriesFor: #testModifiesCollection!public!tests! !
!SmalllintTest categoriesFor: #testOverridesSpecialMessage!public!tests! !
!SmalllintTest categoriesFor: #testPrecedence!public!tests! !
!SmalllintTest categoriesFor: #testRefersToClass!public!tests! !
!SmalllintTest categoriesFor: #testReturnInEnsure!public!tests! !
!SmalllintTest categoriesFor: #testReturnsBooleanAndOther!public!tests! !
!SmalllintTest categoriesFor: #testReturnsIfTrue!public!tests! !
!SmalllintTest categoriesFor: #testSearchingLiteral!public!tests! !
!SmalllintTest categoriesFor: #testSendsDifferentSuper!public!tests! !
!SmalllintTest categoriesFor: #testSizeCheck!public!tests! !
!SmalllintTest categoriesFor: #testStringConcatenation!public!tests! !
!SmalllintTest categoriesFor: #testSuperSends!public!tests! !
!SmalllintTest categoriesFor: #testTempsReadBeforeWritten!public!tests! !
!SmalllintTest categoriesFor: #testTempVarOverridesInstVar!public!tests! !
!SmalllintTest categoriesFor: #testThreeElementPoint!public!tests! !
!SmalllintTest categoriesFor: #testToDo!public!tests! !
!SmalllintTest categoriesFor: #testToDoCollect!public!tests! !
!SmalllintTest categoriesFor: #testToDoWithIncrement!public!tests! !
!SmalllintTest categoriesFor: #testUsesAdd!public!tests! !
!SmalllintTest categoriesFor: #testWhileTrue!public!tests! !
!SmalllintTest categoriesFor: #testYourselfNotUsed!public!tests! !

