"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.BrowserEnvironmentTest'
	instanceVariableNames: 'universalEnvironment totalSelectors'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.BrowserEnvironmentTest guid: (Core.GUID fromString: '{d900c35c-e907-4c85-a762-35dd60264a6c}')!
Refactory.Browser.Tests.BrowserEnvironmentTest comment: ''!
!Refactory.Browser.Tests.BrowserEnvironmentTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.BrowserEnvironmentTest methodsFor!

categoriesFor: anEnvironment
	| allCategories |
	allCategories := Set withAll: universalEnvironment categories.
	allCategories removeAll: anEnvironment categories.
	anEnvironment not categories do: [:each | allCategories remove: each ifAbsent: nil].
	allCategories do: [:each | self assert: (universalEnvironment classNamesFor: each) isEmpty]!

classesFor: aBrowserEnvironment
	| allClasses |
	allClasses := aBrowserEnvironment classes asSet.
	allClasses addAll: aBrowserEnvironment not classes.
	universalEnvironment classesDo: [:each | allClasses remove: each].
	self assert: allClasses isEmpty!

classNamesFor: anEnvironment
	"N.B. A class can be in an environment, and in its inverse, if it is only partially included in the original environment"

	| classNames allClassNames |
	classNames := anEnvironment classNames
				addAll: anEnvironment not classNames;
				yourself.
	allClassNames := universalEnvironment classNames.
	self assert: classNames equals: allClassNames.
	self assert: (anEnvironment & anEnvironment not) classNames isEmpty.
	self assert: (anEnvironment | anEnvironment not) classNames equals: allClassNames!

copyFor: aBrowserEnvironment
	| newEnvironment |
	newEnvironment := aBrowserEnvironment copy.
	self assert: newEnvironment numberSelectors equals: aBrowserEnvironment numberSelectors.
	self assert: (aBrowserEnvironment & newEnvironment not) numberSelectors equals: 0!

keysFor: aBrowserEnvironment
	| allKeys |
	allKeys := aBrowserEnvironment keys asSet.
	allKeys addAll: aBrowserEnvironment not keys.
	allKeys removeAll: Smalltalk keys.
	self assert: allKeys isEmpty!

labelFor: aBrowserEnvironment 
	self deny: aBrowserEnvironment label isNil.
	self deny: aBrowserEnvironment label isEmpty.
	self deny: aBrowserEnvironment defaultLabel isNil.
	self deny: aBrowserEnvironment defaultLabel isEmpty!

numberSelectorsFor: aBrowserEnvironment
	| selectorCount |
	selectorCount := aBrowserEnvironment numberSelectors.
	self assert: selectorCount + aBrowserEnvironment not numberSelectors equals: self totalSelectors.
	self assert: (aBrowserEnvironment & aBrowserEnvironment not) numberSelectors equals: 0.
	self assert: (universalEnvironment & aBrowserEnvironment) numberSelectors equals: selectorCount.
	self assert: (aBrowserEnvironment & universalEnvironment) numberSelectors equals: selectorCount!

setUp
	super setUp.
	universalEnvironment := BrowserEnvironment new.
	universalEnvironment beImmutableObject!

storeStringFor: aBrowserEnvironment
	| newEnvironment |
	newEnvironment := Compiler evaluate: aBrowserEnvironment storeString.
	self assert: newEnvironment numberSelectors equals: aBrowserEnvironment numberSelectors.
	self assert: (aBrowserEnvironment & newEnvironment not) numberSelectors equals: 0!

tearDown
	totalSelectors := nil.
	super tearDown!

testAllClassesDo
	| allClasses |
	allClasses := Set new.
	universalEnvironment classesDo: [:each | allClasses add: each].
	Smalltalk allBehaviorsDo: [:each | allClasses remove: each].
	self assert: allClasses isEmpty!

testAndEnvironment
	| originalEnvironment objectPrintStringEnvironment andEnvironment |
	originalEnvironment := universalEnvironment referencesTo: #printOn:.
	objectPrintStringEnvironment := universalEnvironment forClass: Object
				selectors: #(#fullPrintString).
	andEnvironment := objectPrintStringEnvironment & originalEnvironment.
	self universalTestFor: andEnvironment.
	self assert: andEnvironment numberSelectors equals: 1.
	self assert: andEnvironment classNames asArray equals: {Object fullName}.
	#rbFix.	"Also test #definesClass:"
	self deny: (andEnvironment definesClass: Object).
	self deny: (objectPrintStringEnvironment definesClass: Object).
	self deny: (andEnvironment definesClass: Object).
	#rbFix.	"Since Dolpin has multiple categories, we must allow for the fact that #printString may be the member of more than one"
	self assert: (andEnvironment protocolsFor: Object) size
		equals: (Object compiledMethodAt: #printString) realCategories size.
	andEnvironment := originalEnvironment & (universalEnvironment referencesTo: #printString).
	self assert: andEnvironment numberSelectors
		equals: (originalEnvironment referencesTo: #printString) numberSelectors.
	self assert: andEnvironment classNames asSortedCollection
		equals: (originalEnvironment referencesTo: #printString) classNames asSortedCollection!

testBindingFor
	| subject |
	subject := ClassEnvironment onEnvironment: universalEnvironment
				classes: { Object. Object class. Core }.
	self assert: (subject bindingFor: #'Core.Object') identicalTo: Object binding.
	self assertIsNil: (subject bindingFor: #'Core.Association').
	self assert: (subject bindingFor: #'Core.Processor') identicalTo: (Core bindingFor: #Processor)!

testBrowserEnvironment
	self universalTestFor: universalEnvironment.
	#rbFix.	"Also test #definesClass:"
	Smalltalk allClasses allSatisfy: [:each | universalEnvironment definesClass: each]!

testCategoryEnvironment
	| aCategoryEnvironment |
	#rbFix.	"Dolphin's category names are strings, not symbols"
	aCategoryEnvironment := CategoryEnvironment onEnvironment: universalEnvironment
				categories: #('Kernel-Objects').
	self universalTestFor: aCategoryEnvironment.
	#rbFix.	"There are actually 4 implementors of #printString in the Kernel-Objects category in Dolphin 8"
	self assert: (aCategoryEnvironment implementorsOf: #printString) numberSelectors equals: 4!

testClassEnvironment
	| aClassEnvironment classes |
	classes := {Object. Object class}.
	aClassEnvironment := ClassEnvironment onEnvironment: universalEnvironment classes: classes.
	self universalTestFor: aClassEnvironment.
	self assert: (aClassEnvironment implementorsOf: #printString) numberSelectors equals: 1.
	#rbFix.	"Test #definesClass: and #includesClass"
	self deny: (aClassEnvironment includesClass: Association).
	self deny: (aClassEnvironment definesClass: Association).
	classes do: 
			[:each |
			self assert: (aClassEnvironment includesClass: each).
			self assert: (aClassEnvironment definesClass: each)]!

testConstructedClassEnvironment
	| environment classes |
	environment := ClassEnvironment new.
	#rbFix.	"Also test #definesClass:"
	classes := {Object. OrderedCollection. Collection}.
	classes do: [:each | environment addClass: each].
	classes do: 
			[:each |
			self assert: (environment includesClass: each).
			self assert: (environment definesClass: each).
			self deny: (environment includesClass: each class).
			self deny: (environment definesClass: each class)].
	environment removeClass: Collection.
	self assert: (environment includesClass: Object).
	self assert: (environment includesClass: OrderedCollection).
	self deny: (environment includesClass: Collection).
	self assert: environment numberClasses equals: 2.
	environment addClass: Object class.
	self assert: environment numberClasses equals: 2.
	self assert: (environment includesClass: Object class).
	environment removeClass: self class.
	self assert: environment numberClasses equals: 2!

testConstructedSelectorEnvironment
	| environment newEnvironment |
	environment := SelectorEnvironment new.
	environment
		addClass: Object selector: #printString;
		addClass: OrderedCollection selector: #add:;
		addClass: Collection.
	self assert: (environment includesClass: Object).
	self assert: (environment selectorsForClass: Object) size equals: 1.
	self assert: (environment includesClass: OrderedCollection).
	self deny: (environment definesClass: Object).
	self deny: (environment definesClass: OrderedCollection).
	#rbFix.	"Dolphin doesn't have an #add: in OrderedCollection"
	self assert: (environment selectorsForClass: OrderedCollection) size
		equals: ((OrderedCollection includesSelector: #add:) ifTrue: [1] ifFalse: [0]).
	self assert: (environment includesClass: Collection).
	self assert: (environment selectorsForClass: Collection) size equals: Collection selectors size.
	self deny: (environment includesClass: Object class).
	newEnvironment := environment copy.
	newEnvironment
		removeClass: OrderedCollection;
		addClass: Object selector: #printOn:;
		removeClass: Object selector: #printString.
	self assert: (newEnvironment includesClass: Object).
	self deny: (newEnvironment includesSelector: #printString in: Object).
	self deny: (newEnvironment includesClass: OrderedCollection).
	self assert: (newEnvironment includesClass: Collection).
	self assert: newEnvironment numberClasses equals: 2.
	self assert: newEnvironment numberSelectors + 1 equals: environment numberSelectors.
	newEnvironment addClass: Object class.
	self assert: newEnvironment numberClasses equals: 2.
	self assert: (newEnvironment includesClass: Object class).
	newEnvironment removeClass: self class.
	self assert: newEnvironment numberClasses equals: 2!

testEnvironmentWrapper
	| printString wrapper |
	printString := universalEnvironment referencesTo: #printString.
	wrapper := BrowserEnvironmentWrapper onEnvironment: printString.
	self assert: wrapper numberSelectors equals: printString numberSelectors.
	self assert: wrapper numberClasses equals: printString numberClasses.
	self assert: wrapper environment identicalTo: printString!

testImplementorsMatching
	| print |
	print := universalEnvironment implementorsMatching: '*print*'.
	self universalTestFor: print.
	self assert: (print implementorsOf: #printString) numberSelectors
		equals: (universalEnvironment implementorsOf: #printString) numberSelectors.
	print classesAndSelectorsDo: [:class :sel | self assert: ('*print*' match: sel)]!

testMatches
	| envEnvironment environmentEnvironment env |
	env := universalEnvironment
				forClasses: BrowserEnvironment withAllSubclasses , BrowserEnvironment class withAllSubclasses.
	envEnvironment := env matches: '*env*'.
	environmentEnvironment := env referencesTo: #environment.
	self assert: (envEnvironment referencesTo: #environment) numberSelectors
		equals: environmentEnvironment numberSelectors!

testNotEnvironment
	| notPrintStringEnvironment printStringEnvironment |
	printStringEnvironment := universalEnvironment referencesTo: #printString.
	self deny: (printStringEnvironment definesClass: Object).
	notPrintStringEnvironment := printStringEnvironment not.
	self assert: (notPrintStringEnvironment definesClass: Object).
	self universalTestFor: notPrintStringEnvironment.
	self assert: (notPrintStringEnvironment referencesTo: #printString) isEmpty.
	self assert: (notPrintStringEnvironment not includesClass: self class).
	self assert: (notPrintStringEnvironment not includesSelector: #testNotEnvironment in: self class)!

testOrEnvironment
	<knownSlowTest>
	| env1 env2 orEnvironment |
	env2 := universalEnvironment forClass: Object selectors: #(#fullPrintString).
	env1 := universalEnvironment forClass: Object selectors: #(#printOn:).
	self assert: (env1 | env2) numberSelectors equals: 2.
	self assert: (env2 | env1) numberSelectors equals: 2.
	self universalTestFor: env1 | env2.
	self assert: (env1 | env1) numberSelectors equals: 1.
	orEnvironment := env1 | env1 not.
	self universalTestFor: orEnvironment.
	self assert: orEnvironment numberSelectors equals: self totalSelectors.
	self assert: orEnvironment classNames equals: universalEnvironment classNames.
	#rbFix.	"Comparing sets for equality - maybe temporary, as protocolsFor: should presumably return something else"
	self assert: (orEnvironment protocolsFor: Object)
		equals: (universalEnvironment protocolsFor: Object)!

testProtocolEnvironment
	| aProtocolEnvironment size |
	aProtocolEnvironment := ProtocolEnvironment
				onEnvironment: universalEnvironment
				class: Object
				protocols: #(#printing #testing).
	self universalTestFor: aProtocolEnvironment.
	self assert: (aProtocolEnvironment implementorsOf: #printString) numberSelectors equals: 1.
	size := 0.
	aProtocolEnvironment classesDo: [:each | size := size + 1].
	self assert: size equals: 1.
	aProtocolEnvironment selectorsForClass: Object
		do: 
			[:each |
			#rbFix.	"Dolphin supports multiple method categories"
			self
				assert: (#(#printing #testing)
						intersection: (universalEnvironment whichProtocolsInclude: each in: Object)) notEmpty]!

testReferencesToVariable
	| subject methods |
	subject := BrowserEnvironment new referencesToVariable: #{Transcript} binding.
	methods := subject allMethods.
	self assert: (methods includes: self class >> self selector).
	subject := BrowserEnvironment new referencesToVariable: ClassToRename binding.
	methods := subject allMethods.
	self
		assert: ((methods select: [:each | each methodClass == RefactoryTestDataApp])
				collect: [:each | each selector]) asSortedArray
		equals: #(#refersToClassBindingNotFoundInArray #refersToClassConstantUnqualified #refersToClassFullyQualified #refersToClassFullyQualifiedBinding #refersToClassFullyQualifiedBindingInArray #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2 #refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2 #refersToClassPartiallyQualifiedBindingInArray #refersToClassUnqualified #refersToClassUnqualifiedBinding #refersToClassUnqualifiedBindingInArray #refersToClassUnqualifiedInArray #refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation)!

testRemoveSelectorByAndAndNot
	| objectPrintString |
	objectPrintString := SelectorEnvironment onEnvironment: universalEnvironment.
	objectPrintString addClass: Object selector: #printString.
	self assert: self totalSelectors - 1
		equals: (universalEnvironment & objectPrintString not) numberSelectors.
	self universalTestFor: universalEnvironment & objectPrintString not!

testSelectMethods
	| environment |
	environment := universalEnvironment selectMethods: [:each | false].
	self assert: environment numberSelectors equals: 0.
	self assert: environment numberClasses equals: 0.
	environment := universalEnvironment selectMethods: [:each | true].
	self assert: environment numberSelectors equals: self totalSelectors.
	environment := universalEnvironment selectMethods: [:method | method refersToLiteral: #environment].
	self assert: environment numberSelectors
		equals: (universalEnvironment referencesTo: #environment) numberSelectors!

testSelectorEnvironment
	| printString |
	printString := universalEnvironment referencesTo: #printString.
	self deny: (printString definesClass: Object).
	self universalTestFor: printString.
	self assert: printString numberSelectors
		equals: (printString referencesTo: #printString) numberSelectors.
	self assert: printString numberClasses
		equals: (printString referencesTo: #printString) numberClasses!

testSelectorEnvironmentCopy
	| methods methods2 |
	methods := universalEnvironment referencesTo: #printString.
	methods2 := methods copy.
	methods addClass: Object selector: #displayString.
	self assert: (methods includesSelector: #displayString in: Object).
	self deny: (methods2 includesSelector: #displayString in: Object).
	methods2 addClass: Object class selector: #initialize.
	self assert: (methods2 includesSelector: #initialize in: Object class).
	self deny: (methods includesSelector: #initialize in: Object class)!

testSystemIntegrity
	| classes |
	classes := IdentitySet new.
	universalEnvironment classesDo: 
			[:class |
			(classes includes: class)
				ifFalse: [classes add: class]
				ifTrue: [self fail: 'The class ' , class fullName , ' is available under two or more names.']]!

totalSelectors
	^totalSelectors ifNil: [totalSelectors := universalEnvironment numberSelectors]!

uniqueClassesIn: aBrowserEnvironment
	| allBehaviors |
	allBehaviors := Set new.
	aBrowserEnvironment classesDo: 
			[:each |
			self deny: (allBehaviors includes: each).
			allBehaviors add: each]!

universalTestFor: aBrowserEnvironment
	self labelFor: aBrowserEnvironment.
	self uniqueClassesIn: aBrowserEnvironment.
	self numberSelectorsFor: aBrowserEnvironment.
	self storeStringFor: aBrowserEnvironment.
	self classNamesFor: aBrowserEnvironment.
	self copyFor: aBrowserEnvironment.
	self categoriesFor: aBrowserEnvironment.
	self classesFor: aBrowserEnvironment.
	self assert: aBrowserEnvironment problemCount = 0 equals: aBrowserEnvironment isEmpty! !
!Refactory.Browser.Tests.BrowserEnvironmentTest categoriesForMethods!
categoriesFor:!public!universal tests! !
classesFor:!BrowserEnvironment tests!public! !
classNamesFor:!BrowserEnvironment tests!public! !
copyFor:!public!universal tests! !
keysFor:!public!universal tests! !
labelFor:!BrowserEnvironment tests!public! !
numberSelectorsFor:!public!universal tests! !
setUp!public!set up! !
storeStringFor:!public!universal tests! !
tearDown!public!Running! !
testAllClassesDo!BrowserEnvironment tests!public! !
testAndEnvironment!AndEnvironment tests!public! !
testBindingFor!BrowserEnvironment tests!public! !
testBrowserEnvironment!BrowserEnvironment tests!public! !
testCategoryEnvironment!BrowserEnvironment tests!public! !
testClassEnvironment!BrowserEnvironment tests!public! !
testConstructedClassEnvironment!BrowserEnvironment tests!public! !
testConstructedSelectorEnvironment!BrowserEnvironment tests!public! !
testEnvironmentWrapper!BrowserEnvironment tests!public! !
testImplementorsMatching!BrowserEnvironment tests!public! !
testMatches!BrowserEnvironment tests!public! !
testNotEnvironment!NotEnvironment tests!public! !
testOrEnvironment!OrEnvironment tests!public! !
testProtocolEnvironment!BrowserEnvironment tests!public! !
testReferencesToVariable!BrowserEnvironment tests!public! !
testRemoveSelectorByAndAndNot!BrowserEnvironment tests!public! !
testSelectMethods!BrowserEnvironment tests!public! !
testSelectorEnvironment!BrowserEnvironment tests!public! !
testSelectorEnvironmentCopy!BrowserEnvironment tests!public! !
testSystemIntegrity!BrowserEnvironment tests!public! !
totalSelectors!accessing!private! !
uniqueClassesIn:!public!universal tests! !
universalTestFor:!public!universal tests! !
!

