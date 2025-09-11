"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.BrowserEnvironmentTest
	subclass: #'Refactory.Browser.Tests.SelectorEnvironmentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.SelectorEnvironmentTest guid: (Core.GUID fromString: '{5ccbc558-e4bc-4c62-aae1-dc7895d23e4e}')!

Refactory.Browser.Tests.SelectorEnvironmentTest comment: ''!

!Refactory.Browser.Tests.SelectorEnvironmentTest methodsFor!

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

testImplementorsMatching
	| print |
	print := universalEnvironment implementorsMatching: '*print*'.
	self universalTestFor: print.
	self assert: (print implementorsOf: #printString) numberSelectors
		equals: (universalEnvironment implementorsOf: #printString) numberSelectors.
	print classesAndSelectorsDo: [:class :sel | self assert: ('*print*' match: sel)]!

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
	self deny: (methods includesSelector: #initialize in: Object class)! !

!Refactory.Browser.Tests.SelectorEnvironmentTest categoriesForMethods!
testConstructedSelectorEnvironment!BrowserEnvironment tests!public! !
testImplementorsMatching!BrowserEnvironment tests!public! !
testSelectMethods!BrowserEnvironment tests!public! !
testSelectorEnvironment!BrowserEnvironment tests!public! !
testSelectorEnvironmentCopy!BrowserEnvironment tests!public! !
!

