"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.BrowserEnvironmentTest subclass: #'Refactory.Browser.Tests.MethodCategoryEnvironmentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.MethodCategoryEnvironmentTest guid: (Core.GUID fromString: '{fc1f9c02-ad7f-4715-a48e-c9891c1c5c75}')!
Refactory.Browser.Tests.MethodCategoryEnvironmentTest comment: ''!
!Refactory.Browser.Tests.MethodCategoryEnvironmentTest categoriesForClass!Unclassified! !
!Refactory.Browser.Tests.MethodCategoryEnvironmentTest methodsFor!

testMethodCategoryEnvironment
	| env selectors |
	env := universalEnvironment forMethodCategories: #('*-subclass responsibility' 'comparing').
	self universalTestFor: env.
	"Use SortAlgorithm class because it is unlikely to change"
	self assert: (env includesClass: SortAlgorithm).
	self deny: (env definesClass: SortAlgorithm).
	self assert: (env includesSelector: #compare:with: in: SortAlgorithm).
	self assert: (env includesSelector: #sort:from:to: in: SortAlgorithm).
	self assert: (env includesClass: DefaultSortAlgorithm).
	self deny: (env definesClass: DefaultSortAlgorithm).
	self deny: (env includesSelector: #sort:from:to: in: DefaultSortAlgorithm).
	selectors := SortedCollection new.
	env selectorsForClass: SortAlgorithm do: [:each | selectors add: each].
	self assert: selectors asArray equals: #(#compare:with: #sort:from:to: #sortBlock).
	self assert: (env includesClass: SortAlgorithm class).
	self deny: (env definesClass: SortAlgorithm class).
	selectors := SortedCollection new.
	env selectorsForClass: SortAlgorithm class do: [:each | selectors add: each].
	self assert: selectors size equals: 1.
	self assert: (env includesSelector: #newSortBlock: in: SortAlgorithm class).
	self deny: (env includesSelector: #icon in: SortAlgorithm class)! !
!Refactory.Browser.Tests.MethodCategoryEnvironmentTest categoriesFor: #testMethodCategoryEnvironment!public! !

