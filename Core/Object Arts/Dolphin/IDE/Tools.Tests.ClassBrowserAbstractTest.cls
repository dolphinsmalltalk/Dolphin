"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.ClassBrowserAbstractTest'
	instanceVariableNames: 'browser methodsPresenter packageA plugins'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClassBrowserAbstractTest guid: (Core.GUID fromString: '{fa025e63-3880-48ae-82d4-4b3172d507cc}')!
Tools.Tests.ClassBrowserAbstractTest isNonInstantiable: true!
Tools.Tests.ClassBrowserAbstractTest comment: ''!
!Tools.Tests.ClassBrowserAbstractTest categoriesForClass!Unclassified! !
!Tools.Tests.ClassBrowserAbstractTest methodsFor!

assertIsOnlyMethodVisible: method
	(browser isFilterObjectMethods and: [method methodClass == Object]) 
		ifTrue: 
			[self assert: (browser isMethodVisible: method) not.
			self 
				assert: (methodsPresenter list select: [:each | each selector == method selector]) size 
						<= 1]
		ifFalse: 
			[| matches |
			self assert: (browser isMethodVisible: method).
			matches := methodsPresenter list select: [:each | each selector == method selector].
			self assert: (matches size == 1 and: [matches first == method])]!

browser
	^browser
		ifNil: 
			[browser := self browserClass show.
			methodsPresenter := browser instVarNamed: 'methodBrowserPresenter'.
			browser]!

browserClass
	^self subclassResponsibility!

deleteTestMethods: aCollection
	aCollection
		do: [:each | Transcript display: 'Removing '; print: each; cr. each methodClass removeSelector: each selector ifAbsent: []]!

inheritedMethodAddRemoveTests
	"Private - "

	"Add a new method to Object never seen before, to a non-immediate superclass, to an immediate superclass, and finally to the class itself"

	| myMethod method |
	{Object -> 'blah'.
		TestCase -> 'blah2'.
		Core.Tests.DolphinTest -> 'blah3'.
		ClassBrowserAbstractTest -> 'blah4'} do: 
				[:each |
				method := each key
							compile: each value
							categories: #()
							package: packageA.
				self assertIsOnlyMethodVisible: method].

	"Add a couple of methods to an unrelated hierarchy, but with the same selector as something in the hierarchy"
	{ProtoObject -> 'blah'. Core.Tests.BooleanTest -> 'blah'} do: 
			[:each |
			method := each key
						compile: each value
						categories: #()
						package: packageA.
			self assertIsOnlyMethodVisible: (Object compiledMethodAt: method selector)].

	"Add a method to Object that is already in this class, repeat in non-immediate superclass, and again in immediate superclass"
	myMethod := ClassBrowserAbstractTest compiledMethodAt: #visibilityTestPlaceHolder.
	self assert: (browser isMethodVisible: myMethod).
	{Object. TestCase. Core.Tests.DolphinTest} do: 
			[:each |
			method := each
						compile: 'visibilityTestPlaceHolder'
						categories: #()
						package: packageA.
			self deny: (browser isMethodVisible: method).
			self assertIsOnlyMethodVisible: myMethod].

	"Override a method inherited from an immediate superclass, from a non-immediate superclass, and a method inherited from Object"
	{'blah3'. 'blah2'. 'blah'} do: 
			[:each |
			method := ClassBrowserAbstractTest
						compile: each
						categories: #()
						package: packageA.
			self assertIsOnlyMethodVisible: method].

	"Add a method to super that is already overridden in class (from Object)"
	method := Core.Tests.DolphinTest
				compile: 'blah'
				categories: #()
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).

	"Add a method to super that is already overridden in class (from super super)"
	method := Core.Tests.DolphinTest
				compile: 'blah2'
				categories: #()
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).

	"Add a method to super-super that is already overridden in class (from Object)"
	method := TestCase
				compile: 'blah'
				categories: #()
				package: packageA.
	self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector).

	"Now overriding a superclass once removed but adding to our superclass"
	method := Core.Tests.DolphinTest
				compile: 'addDependentToHierachy: anObject'
				categories: #()
				package: packageA.
	self assertIsOnlyMethodVisible: method.

	"Overriding object adding to non-immediate superclass"
	method := TestCase
				compile: 'addDependent: anObject'
				categories: #()
				package: packageA.
	self assertIsOnlyMethodVisible: method.

	"Overriding object adding to immediate superclass"
	method := Core.Tests.DolphinTest
				compile: 'removeDependent: anObject'
				categories: #()
				package: packageA.
	self assertIsOnlyMethodVisible: method.

	"Some invisible removes of inherited methods"
	{TestCase -> 'blah' asSymbol. Core.Tests.DolphinTest -> 'blah' asSymbol. Core.Tests.DolphinTest -> 'blah2' asSymbol} do: 
			[:each |
			method := each key removeSelector: each value.
			self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: each value)].

	"Remove methods not in the hierarchy, but which has an implementation in this hierarchy"
	{ProtoObject. Core.Tests.BooleanTest} do: 
			[:each |
			method := each removeSelector: 'blah' asSymbol.
			self assertIsOnlyMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: method selector)].

	"Remove override of a method inherited from an immediate superclass, of a method inherited from a non-immediate superclass, 
	and of a method inherited from Object"
	{Core.Tests.DolphinTest -> 'blah3'. TestCase -> 'blah2'. Object -> 'blah'} do: 
			[:each |
			method := ClassBrowserAbstractTest removeSelector: each value asSymbol.
			self assertIsOnlyMethodVisible: (each key compiledMethodAt: method selector)].


	"Remove some visible non-overridden methods"
	{Object -> 'blah' asSymbol.
		Core.Tests.DolphinTest -> 'blah3' asSymbol.
		TestCase -> 'blah2' asSymbol.
		ClassBrowserAbstractTest -> 'blah4' asSymbol} do: 
				[:each |
				method := each key removeSelector: each value.
				self
					assert: (methodsPresenter list allSatisfy: [:eachMethod | eachMethod selector ~~ method selector])].

	"Remove methods that would be inherited if not for the implementation in this class"
	{Core.Tests.DolphinTest. TestCase. Object} do: 
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

setUp
	plugins := ClassBrowserAbstract allSubclasses collect: 
					[:each |
					| a |
					a := each -> each plugins.
					each plugins: #().
					a].
	packageA := Core.Tests.DolphinTestPackages current a!

tearDown
	| methods |
	plugins do: [:a | a key plugins: a value].
	methods := packageA methods.
	browser destroy.
	self deleteTestMethods: methods.
	browser := methodsPresenter := packageA := nil!

testAddRemoveOfInheritedMethods
	self browser toggleShowInheritedMethods.
	self assert: browser isShowInheritedMethods.
	self assert: browser isFilterObjectMethods equals: browser class defaultFilterObjectMethods.
	browser actualClass: Tools.Tests.ClassBrowserAbstractTest.
	self inheritedMethodAddRemoveTests.
	browser toggleFilterObjectMethods.
	self deleteTestMethods: packageA methods.
	self deny: browser isFilterObjectMethods equals: browser class defaultFilterObjectMethods.
	self inheritedMethodAddRemoveTests!

testBrowseItOpensSystemBrowserOnPackageOfLooseMethod
	| default |
	#'1512'.
	default := Smalltalk developmentSystem defaultBrowserClass.
	
	[| method |
	Smalltalk developmentSystem defaultBrowserClass: SystemBrowserShell.
	method := Object compiledMethodAt: #asValue.
	self assert: method isLoose.
	browser := method browse.
	self assert: browser packages equals: {method owningPackage}]
			ensure: [Smalltalk developmentSystem defaultBrowserClass: default]!

testEvaluationContext
	"#832"

	| browserClass |
	browserClass := self browser actualClass.
	self assert: methodsPresenter evaluationContext equals: browserClass.
	browser actualClass: Behavior.
	self assert: methodsPresenter evaluationContext identicalTo: Behavior.
	browser method: (Message compiledMethodAt: #arguments).
	self assert: methodsPresenter evaluationContext identicalTo: Message.
	browser actualClass: nil.
	self assertIsNil: methodsPresenter evaluationContext!

testIsMethodVisible
	self deny: self browser isShowInheritedMethods.
	self assert: browser isFilterObjectMethods.
	browser actualClass: ClassBrowserAbstractTest.
	self
		assert: (browser isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (browser isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (browser isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self deny: (browser isMethodVisible: (Core.Tests.DolphinTest compiledMethodAt: #createPackage:)).
	self deny: (browser isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (browser isMethodVisible: (TestResource compiledMethodAt: #name)).
	browser toggleShowInheritedMethods.
	self assert: browser isShowInheritedMethods.
	self
		assert: (browser isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (browser isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (browser isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self assert: (browser isMethodVisible: (Core.Tests.DolphinTest compiledMethodAt: #createPackage:)).
	self assert: (browser isMethodVisible: (Object compiledMethodAt: #==))
		equals: browser class defaultFilterObjectMethods not.
	self deny: (browser isMethodVisible: (TestResource compiledMethodAt: #name)).
	browser toggleFilterObjectMethods.
	self deny: browser isFilterObjectMethods equals: browser class defaultFilterObjectMethods.
	self
		assert: (browser isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #testIsMethodVisible)).
	self assert: (browser isMethodVisible: (ClassBrowserAbstractTest compiledMethodAt: #setUp)).
	self deny: (browser isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	self assert: (browser isMethodVisible: (Core.Tests.DolphinTest compiledMethodAt: #createPackage:)).
	self assert: (browser isMethodVisible: (Object compiledMethodAt: #==))
		equals: browser class defaultFilterObjectMethods.
	self deny: (browser isMethodVisible: (TestResource compiledMethodAt: #name))!

testIsMethodVisibleClassSide
	| subjectClass |
	self deny: self browser isShowInheritedMethods.
	self assert: browser isFilterObjectMethods equals: browser class defaultFilterObjectMethods.
	subjectClass := Tools.Tests.PackageBrowserShellTest class.
	browser actualClass: subjectClass.
	self assert: (browser isMethodVisible: (subjectClass compiledMethodAt: #resources)).
	self deny: (browser isMethodVisible: (TestCase class compiledMethodAt: #resources)).
	self deny: (browser isMethodVisible: (TestCase class compiledMethodAt: #testSelectors)).
	self deny: (browser isMethodVisible: (Behavior compiledMethodAt: #selectors)).
	self deny: (browser isMethodVisible: (Object compiledMethodAt: #==)).
	browser toggleShowInheritedMethods.
	self assert: browser isShowInheritedMethods.
	self assert: (browser isMethodVisible: (subjectClass compiledMethodAt: #resources)).
	self deny: (browser isMethodVisible: (TestCase class compiledMethodAt: #resources)).
	self assert: (browser isMethodVisible: (TestCase class compiledMethodAt: #testSelectors)).
	self assert: (browser isMethodVisible: (Behavior compiledMethodAt: #selectors))
		equals: browser class defaultFilterObjectMethods not.
	self assert: (browser isMethodVisible: (Object compiledMethodAt: #==))
		equals: browser class defaultFilterObjectMethods not.
	browser toggleFilterObjectMethods.
	self deny: browser isFilterObjectMethods equals: browser class defaultFilterObjectMethods.
	self assert: (browser isMethodVisible: (subjectClass compiledMethodAt: #resources)).
	self deny: (browser isMethodVisible: (TestCase class compiledMethodAt: #resources)).
	self assert: (browser isMethodVisible: (TestCase class compiledMethodAt: #testSelectors)).
	"We now filter everything in Object class and above on the class side - see #923."
	self assert: (browser isMethodVisible: (Object class compiledMethodAt: #binaryReadFrom:))
		equals: browser isFilterObjectMethods not.
	self assert: (browser isMethodVisible: (Behavior compiledMethodAt: #selectors))
		equals: browser isFilterObjectMethods not.
	self assert: (browser isMethodVisible: (Object compiledMethodAt: #==))
		equals: browser isFilterObjectMethods not!

testIsMethodVisibleInObject
	self deny: self browser isShowInheritedMethods.
	self assert: browser isFilterObjectMethods equals: browser class defaultFilterObjectMethods.
	browser actualClass: Object.
	self assert: (browser isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (browser isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	browser toggleShowInheritedMethods.
	self assert: browser isShowInheritedMethods.
	self assert: (browser isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (browser isMethodVisible: (TestCase compiledMethodAt: #setUp)).
	browser toggleFilterObjectMethods.
	self deny: browser isFilterObjectMethods equals: browser class defaultFilterObjectMethods.
	self assert: (browser isMethodVisible: (Object compiledMethodAt: #==)).
	self deny: (browser isMethodVisible: (TestCase compiledMethodAt: #setUp))!

testSwitchFilterPane
	"#1768"

	| testMethod |
	testMethod := Tools.Tests.ClassBrowserAbstractTest compiledMethodAt: #testSwitchFilterPane.
	self browser method: testMethod.
	self assert: browser method identicalTo: testMethod.
	self assert: (browser instVarNamed: 'methodBrowserPresenter') source equals: testMethod getSource.
	"Switch to variables pane from categories with no selection"
	browser method: testMethod.
	(browser instVarNamed: 'variablesPresenter') view ensureVisible.
	self assert: browser method identicalTo: testMethod.
	self assert: (browser instVarNamed: 'methodBrowserPresenter') source equals: testMethod getSource.
	"Switch to protocols pane from variables with no selection"
	browser method: testMethod.
	(browser instVarNamed: 'protocolsPresenter') view ensureVisible.
	self assert: browser method identicalTo: testMethod.
	self assert: (browser instVarNamed: 'methodBrowserPresenter') source equals: testMethod getSource.
	"Switch to categories pane from protocols with no selection"
	browser method: testMethod.
	(browser instVarNamed: 'categoriesPresenter') view ensureVisible.
	self assert: browser method identicalTo: testMethod.
	self assert: (browser instVarNamed: 'methodBrowserPresenter') source equals: testMethod getSource!

visibilityTestPlaceHolder! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #assertIsOnlyMethodVisible:!helpers!public! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #browser!accessing!private! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #browserClass!public!Running! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #deleteTestMethods:!helpers!private! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #inheritedMethodAddRemoveTests!helpers!private! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #setUp!private!Running! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #tearDown!private!Running! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #testAddRemoveOfInheritedMethods!public!unit tests! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #testBrowseItOpensSystemBrowserOnPackageOfLooseMethod!public!unit tests! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #testEvaluationContext!public!unit tests! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #testIsMethodVisible!public!unit tests! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #testIsMethodVisibleClassSide!public!unit tests! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #testIsMethodVisibleInObject!public!unit tests! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #testSwitchFilterPane!public!unit tests! !
!Tools.Tests.ClassBrowserAbstractTest categoriesFor: #visibilityTestPlaceHolder!helpers!private! !

