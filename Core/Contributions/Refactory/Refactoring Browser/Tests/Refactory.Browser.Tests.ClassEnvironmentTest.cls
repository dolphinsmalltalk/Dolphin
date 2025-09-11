"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.BrowserEnvironmentTest
	subclass: #'Refactory.Browser.Tests.ClassEnvironmentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.ClassEnvironmentTest guid: (Core.GUID fromString: '{73fb6433-4e49-404d-a7bf-cd0675661cb7}')!

Refactory.Browser.Tests.ClassEnvironmentTest comment: ''!

!Refactory.Browser.Tests.ClassEnvironmentTest methodsFor!

testClassEnvironment
	| subject classes |
	classes := { Object. Object class }.
	subject := ClassEnvironment onEnvironment: universalEnvironment classes: classes.
	self universalTestFor: subject.
	"Note that classNames does not include metaclass names."
	self assert: subject classNames asArray equals: #('Core.Object').
	self assert: (subject implementorsOf: #printString) numberSelectors equals: 1.
	#rbFix.	"Test #definesClass: and #includesClass"
	self deny: (subject includesClass: Association).
	self deny: (subject definesClass: Association).
	classes do: 
			[:each |
			self assert: (subject includesClass: each).
			self assert: (subject definesClass: each)].
	"Older storeString format"
	subject := (ClassEnvironment onEnvironment: BrowserEnvironment new)
				classes: #('Core.Object')
				metaClasses: #('Core.Association').
	self assert: subject classes equals: (Set with: Object with: Association class)!

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

testLegacyStoreString
	<skip: 'Direct lookups in Smalltalk by legacy short name will fail in Dolphin 8 in most cases'>
	| env |
	env := Compiler
				evaluate: '((ClassEnvironment onEnvironment: BrowserEnvironment new) classes: ((#(#Object) inject: OrderedCollection new into: [:sum :each | 
				| class |
				class := Smalltalk at: each ifAbsent: [nil].
				class notNil ifTrue: [sum add: class].
				sum]) , (#(#Association #Object) inject: OrderedCollection new into: [:sum :each | 
				| class |
				class := Smalltalk at: each ifAbsent: [nil].
				class notNil ifTrue: [sum add: class class].
				sum])))'.
	self assert: env classes asSortedArray equals: {Association class. Object. Object class}! !

!Refactory.Browser.Tests.ClassEnvironmentTest categoriesForMethods!
testClassEnvironment!BrowserEnvironment tests!public! !
testConstructedClassEnvironment!BrowserEnvironment tests!public! !
testLegacyStoreString!BrowserEnvironment tests!public! !
!

