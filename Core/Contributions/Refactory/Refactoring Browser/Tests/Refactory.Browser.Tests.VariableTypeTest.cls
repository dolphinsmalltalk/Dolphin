"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.VariableTypeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.VariableTypeTest guid: (Core.GUID fromString: '{886b4afa-23a6-4006-86bc-7f424cafad38}')!

Refactory.Browser.Tests.VariableTypeTest comment: ''!

!Refactory.Browser.Tests.VariableTypeTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.VariableTypeTest methodsFor!

testBasicLintRuleTypes
	| typer types |
	typer := RefactoryTyper new.
	types := typer guessTypesFor: 'classBlock' in: BasicLintRuleTestData.
	"self assert: types size = 1."
	self assert: ([] class withAllSuperclasses
				anySatisfy: [:each | types includes: (typer model classFor: each)]).
	types := typer typesFor: 'methodBlock' in: (typer model classFor: BasicLintRuleTestData).
	"self should: [types size = 2]."
	self assert: ([] class withAllSuperclasses
				anySatisfy: [:each | types includes: (typer model classFor: each)]).
	"self should: [types includes: MessageChannel]."
	typer printString!

testCompositeLintRuleTypes
	| typer types |
	typer := RefactoryTyper new runOn: CompositeLintRuleTestData.
	types := typer guessTypesFor: 'rules'.
	#rbFix.	"Dolphin's ExternalArray is also a candidate, and this test seems liable to break easily if one adds more collection like classes"
	"self assert: types size = 1."
	self assert: (types includes: (typer model classFor: Collection)).
	types := typer typesFor: '-rules-'.
	self assert: types size equals: 2.
	self assert: (types includes: (typer model classFor: LintRule)).
	self assert: (types includes: (typer model classFor: LintRuleTestData)).
	self assert: (typer guessTypesFor: 'asdf') isEmpty.
	typer printString!

testLintRuleTypes
	| typer types |
	typer := RefactoryTyper new.
	types := typer guessTypesFor: 'name' in: LintRuleTestData.
	self assert: types size equals: 1.
	self assert: (types includes: (typer model classFor: String))!

testParseTreeTypes
	| types model |
	model := RBModel new.
	types := RefactoryTyper
				typesFor: 'foo'
				in: (self parseExpression: 'foo printString; testBasicLintRuleTypes; testParseTreeTypes')
				model: model.
	self assert: types size equals: 1.
	self assert: (types includes: (model classFor: self class))! !

!Refactory.Browser.Tests.VariableTypeTest categoriesForMethods!
testBasicLintRuleTypes!public!unit tests! !
testCompositeLintRuleTypes!public!tests! !
testLintRuleTypes!public!tests! !
testParseTreeTypes!public!tests! !
!

