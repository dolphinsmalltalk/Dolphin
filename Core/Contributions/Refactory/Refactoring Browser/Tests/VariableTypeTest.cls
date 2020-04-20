"Filed out from Dolphin Smalltalk 7"!

RefactoringBrowserTest subclass: #VariableTypeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
VariableTypeTest guid: (GUID fromString: '{886b4afa-23a6-4006-86bc-7f424cafad38}')!
VariableTypeTest comment: ''!
!VariableTypeTest categoriesForClass!Refactory-Testing! !
!VariableTypeTest methodsFor!

testBasicLintRuleTypes
	| typer types |
	typer := RefactoryTyper new.
	types := typer guessTypesFor: 'classBlock' in: BasicLintRuleTest.
	"self assert: types size = 1."
	self assert: ([] class withAllSuperclasses 
				anySatisfy: [:each | types includes: (typer model classFor: each)]).
	types := typer typesFor: 'methodBlock' in: (typer model classFor: BasicLintRuleTest).
	"self should: [types size = 2]."
	self assert: ([] class withAllSuperclasses 
				anySatisfy: [:each | types includes: (typer model classFor: each)]).
	"self should: [types includes: MessageChannel]."
	typer printString!

testCompositeLintRuleTypes
	| typer types |
	typer := RefactoryTyper new runOn: CompositeLintRuleTest.
	types := typer guessTypesFor: 'rules'.
	#rbFix.	"Dolphin's ExternalArray is also a candidate, and this test seems liable to break easily if one adds more collection like classes"
	"self assert: types size = 1."
	self assert: (types includes: (typer model classFor: Collection)).
	types := typer typesFor: '-rules-'.
	self assert: types size equals: 2.
	self assert: (types includes: (typer model classFor: LintRule)).
	self assert: (types includes: (typer model classFor: LintRuleTest)).
	self assert: (typer guessTypesFor: 'asdf') isEmpty.
	typer printString!

testLintRuleTypes
	| typer types |
	typer := RefactoryTyper new.
	types := typer guessTypesFor: 'name' in: LintRuleTest.
	self assert: types size equals: 1.
	self assert: (types includes: (typer model classFor: String))!

testParseTreeTypes
	| types model |
	model := RBNamespace new.
	types := RefactoryTyper
				typesFor: 'foo'
				in: (RBParser parseExpression: 'foo printString; testBasicLintRuleTypes; testParseTreeTypes')
				model: model.
	self assert: types size equals: 1.
	self assert: (types includes: (model classFor: self class))! !
!VariableTypeTest categoriesFor: #testBasicLintRuleTypes!public!unit tests! !
!VariableTypeTest categoriesFor: #testCompositeLintRuleTypes!public!tests! !
!VariableTypeTest categoriesFor: #testLintRuleTypes!public!tests! !
!VariableTypeTest categoriesFor: #testParseTreeTypes!public!tests! !

