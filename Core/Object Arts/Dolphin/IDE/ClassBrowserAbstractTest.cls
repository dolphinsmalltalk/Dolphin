"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #ClassBrowserAbstractTest
	instanceVariableNames: 'methodsPresenter packageA plugins'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ClassBrowserAbstractTest guid: (GUID fromString: '{fa025e63-3880-48ae-82d4-4b3172d507cc}')!

ClassBrowserAbstractTest isAbstract: true!

ClassBrowserAbstractTest comment: ''!

!ClassBrowserAbstractTest categoriesForClass!Unclassified! !

!ClassBrowserAbstractTest methodsFor!

assertIsOnlyMethodVisible: method
	(presenter isFilterObjectMethods and: [method methodClass == Object]) 
		ifTrue: 
			[self assert: (presenter isMethodVisible: method) not.
			self 
				assert: (methodsPresenter list select: [:each | each selector == method selector]) size 
						<= 1]
		ifFalse: 
			[| matches |
			self assert: (presenter isMethodVisible: method).
			matches := methodsPresenter list select: [:each | each selector == method selector].
			self assert: (matches size == 1 and: [matches first == method])]!

deleteTestMethods: aCollection
	aCollection
		do: [:each | Transcript display: 'Removing '; print: each; cr. each methodClass removeSelector: each selector ifAbsent: []]!

inheritedMethodAddRemoveTests
	"Private - "

	"Add a new method to Object never seen before, to a non-immediate superclass, to an immediate superclass, and finally to the class itself"

	| myMethod method categories |
	categories := {'private' asMethodCategory}.
	{Object -> 'blah'.
		TestCase -> 'blah2'.
		DolphinTest -> 'blah3'.
		ClassBrowserAbstractTest -> 'blah4'} do: 
				[:each |
				method := each key
							compile: each value
							categories: categories
							package: packageA.
				self assertIsOnlyMethodVisible: method].

	"Add a couple of methods to an unrelated hierarchy, but with the same selector as something in the hierarchy"
	{ProtoObject -> 'blah'. BooleanTest -> 'blah'} do: 
			[:each |
			method := each key
						compile: each value
						categories: categories
						package: packageA.
			self assertIsOnlyMethodVisible: (Object compiledMethodAt: method selector)].

	"Add a method to Object that is already in this class, repeat in non-immediate superclass, and again in immediate superclass"
	myMethod := ClassBrowserAbstractTest compiledMethodAt: #visibilityTestPlaceHolder.
	self assert: (presenter isMethodVisible: myMethod).
	{Object. TestCase. DolphinTest} do: 
			[:each |
			method := each
						compile: 'visibilityTestPlaceHolder'
						categories: categories
						package: packageA.
			self deny: (presenter isMethodVisible: method).
			self assertIsOnlyMethodVisible: myMethod].

	"Override a method inherited from an immediate superclass, from a non-immediate superclass, and a method inherited from Object"
	{'blah3'. 'blah2'. 'blah'} do: 
			[:each |
			method := ClassBrowserAbstractTest
						compile: each
						categories: categories
						package: packageA.
			self assertIsOnlyMethodVisible: method].

	"Add a method to super that is already overridden in class (from Object)"
	method := DolphinTest
				compile: 'blah'
				categories: categories
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).

	"Add a method to super that is already overridden in class (from super super)"
	method := DolphinTest
				compile: 'blah2'
				categories: categories
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).

	"Add a method to super-super that is already overridden in class (from Object)"
	method := TestCase
				compile: 'blah'
				categories: categories
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).

	"Now overriding a superclass once removed but adding to our superclass"
	method := DolphinTest
				compile: 'addDependentToHierachy: anObject'
				categories: categories
				package: packageA.
	self assertIsOnlyMethodVisible: method.

	"Overriding object adding to non-immediate superclass"
	method := TestCase
				compile: 'addDependent: anObject'
				categories: #()
				package: packageA.
	self assertIsOnlyMethodVisible: method.

	"Overriding object adding to immediate superclass"
	method := DolphinTest
				compile: 'removeDependent: anObject'
				categories: #()
				package: packageA.
	self assertIsOnlyMethodVisible: method.

	"Some invisible removes of inherited methods"
	{TestCase -> 'blah' asSymbol. DolphinTest -> 'blah' asSymbol. DolphinTest -> 'blah2' asSymbol} do: 
			[:each |
			method := each key removeSelector: each value.
			self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: each value)].

	"Remove methods not in the hierarchy, but which has an implementation in this hierarchy"
	{ProtoObject. BooleanTest} do: 
			[:each |
			method := each removeSelector: 'blah' asSymbol.
			self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector)].

	"Remove override of a method inherited from an immediate superclass, of a method inherited from a non-immediate superclass, 
	and of a method inherited from Object"
	{DolphinTest -> 'blah3'. TestCase -> 'blah2'. Object -> 'blah'} do: 
			[:each |
			method := ClassBrowserAbstractTest removeSelector: each value asSymbol.
			self assertIsOnlyMethodVisible: (each key compiledMethodAt: method selector)].


	"Remove some visible non-overridden methods"
	{Object -> 'blah' asSymbol.
		DolphinTest -> 'blah3' asSymbol.
		TestCase -> 'blah2' asSymbol.
		ClassBrowserAbstractTest -> 'blah4' asSymbol} do: 
				[:each |
				method := each key removeSelector: each value.
				self
					assert: (methodsPresenter list allSatisfy: [:eachMethod | eachMethod selector ~~ method selector])].

	"Remove methods that would be inherited if not for the implementation in this class"
	{DolphinTest. TestCase. Object} do: 
			[:each |
			method := each removeSelector: myMethod selector.
			self assertIsOnlyMethodVisible: myMethod].

	"Remove method overridding object in immediate super"
	method := DolphinTest removeSelector: #removeDependent:.
	self assertIsOnlyMethodVisible: (Object compiledMethodAt: method selector).

	"Remove method overridding object in non-immediate super"
	method := TestCase removeSelector: #addDependent:.
	self assertIsOnlyMethodVisible: (Object compiledMethodAt: method selector).

	"Remove super method overridding non-immediate super"
	method := DolphinTest removeSelector: #addDependentToHierachy:.
	self assertIsOnlyMethodVisible: (TestCase compiledMethodAt: method selector)!

initializePresenter
	presenter := self classToTest show.
	methodsPresenter := presenter instVarNamed: 'methodBrowserPresenter'!

setUp
	plugins := self classToTest basicPlugins.
	self classToTest plugins: #().
	packageA := DolphinTestPackages current a.
	super setUp!

tearDown
	| methods |
	self classToTest plugins: plugins.
	methods := packageA methods.
	super tearDown.
	self deleteTestMethods: methods.
	methodsPresenter := packageA := nil!

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

testBrowseItOpensSystemBrowserOnPackageOfLooseMethod
	| default |
	#nocreate.
	#'1512'.
	default := Smalltalk developmentSystem defaultBrowserClass.
	
	[| method |
	Smalltalk developmentSystem defaultBrowserClass: SystemBrowserShell.
	method := Object compiledMethodAt: #asValue.
	self assert: method isLoose.
	presenter := method browse.
	self assert: presenter packages equals: {method owningPackage}]
			ensure: [Smalltalk developmentSystem defaultBrowserClass: default]!

testEvaluationContext
	"#832"

	| browserClass |
	browserClass := presenter actualClass.
	self assert: methodsPresenter evaluationContext equals: browserClass.
	presenter actualClass: DeadObject.
	self assert: methodsPresenter evaluationContext identicalTo: DeadObject.
	presenter method: (Context compiledMethodAt: #block).
	self assert: methodsPresenter evaluationContext identicalTo: Context.
	presenter actualClass: nil.
	self assertIsNil: methodsPresenter evaluationContext!

testIsMethodVisible
	self deny: presenter isShowInheritedMethods.
	self assert: presenter isFilterObjectMethods.
	presenter actualClass: ClassBrowserAbstractTest.
	self
		assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self deny: (presenter isMethodVisible: (DolphinTest compiledMethodAt: #createPackage:)).
	self deny: (presenter isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (presenter isMethodVisible: (TestResource compiledMethodAt: #name)).
	presenter toggleShowInheritedMethods.
	self assert: presenter isShowInheritedMethods.
	self
		assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self assert: (presenter isMethodVisible: (DolphinTest compiledMethodAt: #createPackage:)).
	self assert: (presenter isMethodVisible: (Object compiledMethodAt: #==))
		equals: presenter class defaultFilterObjectMethods not.
	self deny: (presenter isMethodVisible: (TestResource compiledMethodAt: #name)).
	presenter toggleFilterObjectMethods.
	self deny: presenter isFilterObjectMethods equals: presenter class defaultFilterObjectMethods.
	self
		assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (presenter isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (presenter isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self assert: (presenter isMethodVisible: (DolphinTest compiledMethodAt: #createPackage:)).
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

!ClassBrowserAbstractTest categoriesForMethods!
assertIsOnlyMethodVisible:!helpers!public! !
deleteTestMethods:!helpers!private! !
inheritedMethodAddRemoveTests!helpers!private! !
initializePresenter!accessing!private! !
setUp!private!Running! !
tearDown!private!Running! !
testAddRemoveOfInheritedMethods!public!unit tests! !
testBrowseItOpensSystemBrowserOnPackageOfLooseMethod!public!unit tests! !
testEvaluationContext!public!unit tests! !
testIsMethodVisible!public!unit tests! !
testIsMethodVisibleClassSide!public!unit tests! !
testIsMethodVisibleInObject!public!unit tests! !
testSwitchFilterPane!public!unit tests! !
viewClass!constants!private! !
visibilityTestPlaceHolder!helpers!private! !
!

