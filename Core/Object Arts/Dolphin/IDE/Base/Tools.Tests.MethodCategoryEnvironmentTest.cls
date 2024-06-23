"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.BrowserEnvironmentTest
	subclass: #'Tools.Tests.MethodCategoryEnvironmentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Tools.Tests.MethodCategoryEnvironmentTest guid: (Core.GUID fromString: '{fc1f9c02-ad7f-4715-a48e-c9891c1c5c75}')!

Tools.Tests.MethodCategoryEnvironmentTest comment: ''!

!Tools.Tests.MethodCategoryEnvironmentTest methodsFor!

testMethodCategoryEnvironment
	| env selectors |
	env := universalEnvironment forMethodCategories: #('*-subclass responsibility' 'comparing').
	self universalTestFor: env.
	"Use SortAlgorithm class because it is unlikely to change - yeah, right"
	self assert: (env includesClass: SortAlgorithm).
	self deny: (env definesClass: SortAlgorithm).
	self assert: (env includesSelector: #compare:with: in: SortAlgorithm).
	self deny: (env includesSelector: #sort:from:to: in: SortAlgorithm).
	self assert: (env includesClass: PluggableSortAlgorithm).
	self deny: (env definesClass: PluggableSortAlgorithm).
	self assert: (env includesSelector: #sort:from:to: in: PluggableSortAlgorithm).
	selectors := SortedCollection new.
	env selectorsForClass: SortAlgorithm do: [:each | selectors add: each].
	self assert: selectors single equals: #compare:with:.
	self deny: (env includesClass: SortAlgorithm class).
	self deny: (env includesSelector: #icon in: SortAlgorithm class).
	selectors := SortedCollection new.
	env selectorsForClass: SortAlgorithm class do: [:each | selectors add: each].
	self assert: selectors isEmpty.
	env selectorsForClass: PluggableSortAlgorithm do: [:each | selectors add: each].
	self assert: selectors asArray equals: #(#compare:with: #sort:from:to:)! !

!Tools.Tests.MethodCategoryEnvironmentTest categoriesForMethods!
testMethodCategoryEnvironment!public! !
!

