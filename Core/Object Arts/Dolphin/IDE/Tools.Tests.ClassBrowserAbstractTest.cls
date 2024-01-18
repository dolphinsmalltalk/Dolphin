"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'Tools.Tests.ClassBrowserAbstractTest'
	instanceVariableNames: 'methodsPresenter packageA plugins'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClassBrowserAbstractTest guid: (Core.GUID fromString: '{fa025e63-3880-48ae-82d4-4b3172d507cc}')!
Tools.Tests.ClassBrowserAbstractTest isNonInstantiable: true!
Tools.Tests.ClassBrowserAbstractTest comment: ''!
!Tools.Tests.ClassBrowserAbstractTest methodsFor!

assertAllCategoriesInTreeOf: method
	self assert: (method realCategories difference: presenter categoriesPresenter model asSet) asArray
		equals: #()	"The method category tree should be in sync"!

assertIsOnlyMethodVisible: method
	(presenter isFilterObjectMethods and: [method methodClass == Object])
		ifTrue: 
			[self assert: (presenter isMethodVisible: method) not.
			self assert: (methodsPresenter list select: [:each | each selector == method selector]) size <= 1]
		ifFalse: 
			[| matches |
			self assert: (presenter isMethodVisible: method).
			matches := methodsPresenter list select: [:each | each selector == method selector].
			self assert: (matches size == 1 and: [matches first == method])]!

assertUpdatedForAddedMethod: method
	self assertIsOnlyMethodVisible: method.
	^self assertAllCategoriesInTreeOf: method!

deleteTestMethods: aCollection
	aCollection do: [:each | each methodClass removeSelector: each selector ifAbsent: nil]!

inheritedMethodAddRemoveTests
	"Private - "

	"Add a new method to Object never seen before, to a non-immediate superclass, to an immediate superclass, and finally to the class itself"

	| myMethod method categories fooCategory |
	categories := { 'private' asMethodCategory. 'bar' asMethodCategory }.
	{
		Object -> 'blah'.
		TestCase -> 'blah2'.
		Core.Tests.DolphinTest -> 'blah3'.
		ClassBrowserAbstractTest -> 'blah4'
	} do: 
				[:each |
				method := each key
							compile: each value
							categories: categories
							package: packageA.
				self assertUpdatedForAddedMethod: method].
	fooCategory := 'foo' asMethodCategory.
	"Add a couple of methods to an unrelated hierarchy, but with the same selector as something in the hierarchy"
	{ ProtoObject -> 'blah'. Core.Tests.BooleanTest -> 'blah' } do: 
			[:each |
			method := each key
						compile: each value
						categories: categories , { fooCategory }
						package: packageA.
			self assertIsOnlyMethodVisible: (Object compiledMethodAt: method selector).
			self deny: (presenter categoriesPresenter model includes: fooCategory)].

	"Add a method to Object that is already in this class, repeat in non-immediate superclass, and again in immediate superclass"
	myMethod := ClassBrowserAbstractTest compiledMethodAt: #visibilityTestPlaceHolder.
	self assert: (presenter isMethodVisible: myMethod).
	{ Object. TestCase. Core.Tests.DolphinTest } do: 
			[:each |
			method := each
						compile: 'visibilityTestPlaceHolder'
						categories: categories , { fooCategory }
						package: packageA.
			self deny: (presenter isMethodVisible: method).
			self assertIsOnlyMethodVisible: myMethod.
			"Since the method was not added, the category tree should not have been updated"
			self deny: (presenter categoriesPresenter model includes: fooCategory)].

	"Override a method inherited from an immediate superclass, from a non-immediate superclass, and a method inherited from Object"
	#('blah3' 'blah2' 'blah') do: 
			[:each |
			method := ClassBrowserAbstractTest
						compile: each
						categories: categories , { each asMethodCategory }
						package: packageA.
			self assertUpdatedForAddedMethod: method].

	"Add a method to super that is already overridden in class (from Object)"
	method := Core.Tests.DolphinTest
				compile: 'blah'
				categories: categories , { fooCategory }
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).
	self deny: (presenter categoriesPresenter model includes: fooCategory).

	"Add a method to super that is already overridden in class (from super super)"
	method := Core.Tests.DolphinTest
				compile: 'blah2'
				categories: categories , { fooCategory }
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).
	self deny: (presenter categoriesPresenter model includes: fooCategory).

	"Add a method to super-super that is already overridden in class (from Object)"
	method := TestCase
				compile: 'blah'
				categories: categories , { fooCategory }
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).
	self deny: (presenter categoriesPresenter model includes: fooCategory).
	"Now overriding a superclass once removed but adding to our superclass"
	method := Core.Tests.DolphinTest
				compile: 'addDependentToHierachy: anObject'
				categories: { 'override super super in superclass' asMethodCategory }
				package: packageA.
	self assertUpdatedForAddedMethod: method.

	"Overriding object adding to non-immediate superclass"
	method := TestCase
				compile: 'addDependent: anObject'
				categories: { 'override object in non immediate superclass' asMethodCategory }
				package: packageA.
	self assertUpdatedForAddedMethod: method.

	"Overriding object adding to immediate superclass"
	method := Core.Tests.DolphinTest
				compile: 'removeDependent: anObject'
				categories: { 'override object in immediate superclass' asMethodCategory }
				package: packageA.
	self assertUpdatedForAddedMethod: method.

	"Some invisible removes of inherited methods"
	{
		TestCase -> 'blah' asSymbol.
		Core.Tests.DolphinTest -> 'blah' asSymbol.
		Core.Tests.DolphinTest -> 'blah2' asSymbol
	} do: 
				[:each |
				method := each key removeSelector: each value.
				self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: each value)].

	"Remove methods not in the hierarchy, but which has an implementation in this hierarchy"
	{ ProtoObject. Core.Tests.BooleanTest } do: 
			[:each |
			method := each removeSelector: 'blah' asSymbol.
			self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector)].

	"Remove override of a method inherited from an immediate superclass, of a method inherited from a non-immediate superclass, 
	and of a method inherited from Object"
	{ Core.Tests.DolphinTest -> 'blah3'. TestCase -> 'blah2'. Object -> 'blah' } do: 
			[:each |
			method := ClassBrowserAbstractTest removeSelector: each value asSymbol.
			self assertIsOnlyMethodVisible: (each key compiledMethodAt: method selector)].


	"Remove some visible non-overridden methods"
	{
		Object -> 'blah' asSymbol.
		Core.Tests.DolphinTest -> 'blah3' asSymbol.
		TestCase -> 'blah2' asSymbol.
		ClassBrowserAbstractTest -> 'blah4' asSymbol
	} do: 
				[:each |
				method := each key removeSelector: each value.
				self
					assert: (methodsPresenter list allSatisfy: [:eachMethod | eachMethod selector ~~ method selector])].

	"Remove methods that would be inherited if not for the implementation in this class"
	{ Core.Tests.DolphinTest. TestCase. Object } do: 
			[:each |
			method := each removeSelector: myMethod selector.
			self assertIsOnlyMethodVisible: myMethod].

	"Remove method overridding object in immediate super"
	method := Core.Tests.DolphinTest removeSelector: #removeDependent:.
	self assertIsOnlyMethodVisible: (Object compiledMethodAt: method selector).

	"Remove method overridding object in non-immediate super"
	method := TestCase removeSelector: #addDependent:.
	self assertIsOnlyMethodVisible: (Object compiledMethodAt: method selector).

	"Remove super method overridding non-immediate super"
	method := Core.Tests.DolphinTest removeSelector: #addDependentToHierachy:.
	self assertIsOnlyMethodVisible: (TestCase compiledMethodAt: method selector)!

initializePresenter
	presenter := self classToTest show.
	methodsPresenter := presenter instVarNamed: 'methodBrowserPresenter'!

setUp
	plugins := self classToTest
				ensureOptionsLoaded;
				basicPlugins.
	self classToTest basicPlugins: #().
	packageA := Core.Tests.DolphinTestPackages current a.
	super setUp!

tearDown
	| methods |
	self classToTest basicPlugins: plugins.
	methods := packageA methods.
	super tearDown.
	self deleteTestMethods: methods.
	methodsPresenter := packageA := nil.
	super tearDown!

testAddingMethodWithNoClassSelection
	presenter actualClass: nil.
	self assert: presenter methods isEmpty.
	Object
		compile: 'foo'
		categories: #()
		package: packageA.
	self assert: presenter methods isEmpty.
	presenter toggleShowInheritedMethods.
	Object
		compile: 'bar'
		categories: #()
		package: packageA!

testAddRemoveOfInheritedMethods
	presenter actualClass: ClassBrowserAbstractTest.
	presenter toggleShowInheritedMethods.
	self assert: presenter isShowInheritedMethods.
	self assert: presenter isFilterObjectMethods equals: presenter class defaultFilterObjectMethods.
	self inheritedMethodAddRemoveTests.
	presenter toggleFilterObjectMethods.
	self deleteTestMethods: packageA methods.
	self deny: presenter isFilterObjectMethods equals: presenter class defaultFilterObjectMethods.
	self inheritedMethodAddRemoveTests!

testEvaluationContext
	"#832"

	| browserClass |
	browserClass := presenter actualClass.
	self assert: methodsPresenter evaluationContext identicalTo: browserClass ?? UndefinedObject.
	presenter actualClass: BindingContext.
	self assert: methodsPresenter evaluationContext identicalTo: BindingContext.
	presenter method: (Context compiledMethodAt: #block).
	self assert: methodsPresenter evaluationContext identicalTo: Context.
	presenter actualClass: nil.
	self assert: methodsPresenter evaluationContext identicalTo: UndefinedObject!

testIsMethodVisible
	self deny: presenter isShowInheritedMethods.
	self assert: presenter isFilterObjectMethods.
	presenter actualClass: ClassBrowserAbstractTest.
	self
		assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self deny: (presenter isMethodVisible: (Core.Tests.DolphinTest compiledMethodAt: #createPackage:)).
	self deny: (presenter isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (presenter isMethodVisible: (TestResource compiledMethodAt: #name)).
	presenter toggleShowInheritedMethods.
	self assert: presenter isShowInheritedMethods.
	self
		assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self assert: (presenter isMethodVisible: (Core.Tests.DolphinTest compiledMethodAt: #createPackage:)).
	self assert: (presenter isMethodVisible: (Object compiledMethodAt: #==))
		equals: presenter class defaultFilterObjectMethods not.
	self deny: (presenter isMethodVisible: (TestResource compiledMethodAt: #name)).
	presenter toggleFilterObjectMethods.
	self deny: presenter isFilterObjectMethods equals: presenter class defaultFilterObjectMethods.
	self
		assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self assert: (presenter isMethodVisible: (Core.Tests.DolphinTest compiledMethodAt: #createPackage:)).
	self assert: (presenter isMethodVisible: (Object compiledMethodAt: #==))
		equals: presenter class defaultFilterObjectMethods.
	self deny: (presenter isMethodVisible: (TestResource compiledMethodAt: #name))!

testIsMethodVisibleClassSide
	| subjectClass |
	self deny: presenter isShowInheritedMethods.
	self assert: presenter isFilterObjectMethods equals: presenter class defaultFilterObjectMethods.
	subjectClass := PackageBrowserShellTest class.
	presenter actualClass: subjectClass.
	self assert: (presenter isMethodVisible: (subjectClass compiledMethodAt: #resources)).
	self deny: (presenter isMethodVisible: (TestCase class compiledMethodAt: #resources)).
	self deny: (presenter isMethodVisible: (TestCase class compiledMethodAt: #testSelectors)).
	self deny: (presenter isMethodVisible: (Behavior compiledMethodAt: #selectors)).
	self deny: (presenter isMethodVisible: (Object compiledMethodAt: #==)).
	presenter toggleShowInheritedMethods.
	self assert: presenter isShowInheritedMethods.
	self assert: (presenter isMethodVisible: (subjectClass compiledMethodAt: #resources)).
	self deny: (presenter isMethodVisible: (TestCase class compiledMethodAt: #resources)).
	self assert: (presenter isMethodVisible: (TestCase class compiledMethodAt: #testSelectors)).
	self assert: (presenter isMethodVisible: (Behavior compiledMethodAt: #selectors))
		equals: presenter class defaultFilterObjectMethods not.
	self assert: (presenter isMethodVisible: (Object compiledMethodAt: #==))
		equals: presenter class defaultFilterObjectMethods not.
	presenter toggleFilterObjectMethods.
	self deny: presenter isFilterObjectMethods equals: presenter class defaultFilterObjectMethods.
	self assert: (presenter isMethodVisible: (subjectClass compiledMethodAt: #resources)).
	self deny: (presenter isMethodVisible: (TestCase class compiledMethodAt: #resources)).
	self assert: (presenter isMethodVisible: (TestCase class compiledMethodAt: #testSelectors)).
	"We now filter everything in Object class and above on the class side - see #923."
	self assert: (presenter isMethodVisible: (Object class compiledMethodAt: #binaryReadFrom:))
		equals: presenter isFilterObjectMethods not.
	self assert: (presenter isMethodVisible: (Behavior compiledMethodAt: #selectors))
		equals: presenter isFilterObjectMethods not.
	self assert: (presenter isMethodVisible: (Object compiledMethodAt: #==))
		equals: presenter isFilterObjectMethods not!

testIsMethodVisibleInObject
	self deny: presenter isShowInheritedMethods.
	self assert: presenter isFilterObjectMethods equals: presenter class defaultFilterObjectMethods.
	presenter actualClass: Object.
	self assert: (presenter isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	presenter toggleShowInheritedMethods.
	self assert: presenter isShowInheritedMethods.
	self assert: (presenter isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	presenter toggleFilterObjectMethods.
	self deny: presenter isFilterObjectMethods equals: presenter class defaultFilterObjectMethods.
	self assert: (presenter isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp))!

testSwitchFilterPane
	"#1768"

	| testMethod |
	testMethod := ClassBrowserAbstractTest compiledMethodAt: #testSwitchFilterPane.
	presenter method: testMethod.
	self assert: presenter method identicalTo: testMethod.
	self assert: (presenter instVarNamed: 'methodBrowserPresenter') source equals: testMethod getSource.
	"Switch to variables pane from categories with no selection"
	presenter method: testMethod.
	(presenter instVarNamed: 'variablesPresenter') view ensureVisible.
	self assert: presenter method identicalTo: testMethod.
	self assert: (presenter instVarNamed: 'methodBrowserPresenter') source equals: testMethod getSource.
	"Switch to protocols pane from variables with no selection"
	presenter method: testMethod.
	(presenter instVarNamed: 'protocolsPresenter') view ensureVisible.
	self assert: presenter method identicalTo: testMethod.
	self assert: (presenter instVarNamed: 'methodBrowserPresenter') source equals: testMethod getSource.
	"Switch to categories pane from protocols with no selection"
	presenter method: testMethod.
	(presenter instVarNamed: 'categoriesPresenter') view ensureVisible.
	self assert: presenter method identicalTo: testMethod.
	self assert: (presenter instVarNamed: 'methodBrowserPresenter') source equals: testMethod getSource!

viewClass
	^ShellView!

visibilityTestPlaceHolder! !
!Tools.Tests.ClassBrowserAbstractTest categoriesForMethods!
assertAllCategoriesInTreeOf:!helpers!public! !
assertIsOnlyMethodVisible:!helpers!public! !
assertUpdatedForAddedMethod:!helpers!private! !
deleteTestMethods:!helpers!private! !
inheritedMethodAddRemoveTests!helpers!private! !
initializePresenter!accessing!private! !
setUp!private!Running! !
tearDown!private!Running! !
testAddingMethodWithNoClassSelection!public!unit tests! !
testAddRemoveOfInheritedMethods!public!unit tests! !
testEvaluationContext!public!unit tests! !
testIsMethodVisible!public!unit tests! !
testIsMethodVisibleClassSide!public!unit tests! !
testIsMethodVisibleInObject!public!unit tests! !
testSwitchFilterPane!public!unit tests! !
viewClass!constants!private! !
visibilityTestPlaceHolder!helpers!private! !
!

