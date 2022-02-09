"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.RBModelTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RBModelTest guid: (Core.GUID fromString: '{79170e4b-f3f8-4b46-8093-dac62f866cba}')!
Refactory.Browser.Tests.RBModelTest comment: ''!
!Refactory.Browser.Tests.RBModelTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RBModelTest methodsFor!

testAllBehaviorsDo
	| model classes |
	classes := 0.
	model := RBModel new.
	model allBehaviorsDo: [:each | classes := classes + 1].
	self assert: classes equals: Smalltalk allClasses size * 2.
	BrowserEnvironment new classesDo: [:each | classes := classes - 1].
	self assert: classes equals: 0!

testAllBehaviorsDoOnSelectorEnvironment
	| env model classes |
	classes := Set new.
	env := BrowserEnvironment new
				forMethods: {Smalltalk class >> #allClassesDo:. self class >> self selector}.
	model := RBModel onEnvironment: env.
	model allBehaviorsDo: [:each | classes add: each].
	self assert: classes equals: {model classFor: Smalltalk class. model classFor: self class} asSet!

testCommentChange
	| st cl |
	st := RBModel new.
	cl := st classNamed: self class fullName.
	self assert: cl comment isString.
	cl comment: 'a comment'.
	self assert: cl comment = 'a comment'.
	self assert: st changes changes size = 1.
	self assert: st changes changes first comment = 'a comment'.
	cl comment: nil.
	self assert: cl comment isNil.
	self assert: st changes changes size = 2.
	self assert: st changes changes last comment isNil!

testDefineClassAfterDeletedChange
	| st className |
	st := RBModel new.
	className := self class fullName.
	st removeClassNamed: className.
	self deny: (st includesClassNamed: className).
	st defineClass: self class definition.
	self assert: (st includesClassNamed: className).
	self denyIsNil: (st classNamed: className)!

testDefineClassChange
	| st |
	st := RBModel new.
	st
		defineClass: 'RefactoringBrowserTest subclass: #SmalltalkTestXXX
				instanceVariableNames: ''''
				classVariableNames: ''''
				poolDictionaries: ''''
				category: ''Refactory-Testing'''.
	self assert: (st includesClassNamed: #SmalltalkTestXXX).
	self denyIsNil: (st classNamed: #SmalltalkTestXXX)!

testDefineClassChangeD8
	| subject class classVars classConsts |
	subject := RBModel new.
	subject
		defineClass: 'Refactory.Browser.Tests.RefactoringBrowserTest subclass: #''Refactory.Browser.Tests.SmalltalkTestXXX''
				instanceVariableNames: ''iv1 iv2''
				classVariableNames: ''Cv1 Cv2''
				imports: #(#{Tools})
				classInstanceVariableNames: ''ci1 ci2''
				classConstants: { ''Cc1'' -> 1. ''Cc2'' -> 2 }'.
	class := subject classNamed: 'Refactory.Browser.Tests.SmalltalkTestXXX'.
	self denyIsNil: class.
	classVars := class classVariables.
	self assert: (classVars collect: [:each | each key]) asArray sort equals: #('Cv1' 'Cv2').
	self assert: (classVars allSatisfy: [:each | each isVariableBinding]).
	self assert: (classVars allSatisfy: [:each | each isClassVariable and: [each isImmutable not]]).
	self assert: (classVars allSatisfy: [:each | each environment == class]).
	classConsts := class classConstants.
	self assert: (classConsts collect: [:each | each printString]) asSortedCollection asArray
		equals: #('''Cc1'' -> 1' '''Cc2'' -> 2').
	self assert: (classConsts allSatisfy: [:each | each isVariableBinding]).
	self assert: (classConsts allSatisfy: [:each | each isClassVariable and: [each isImmutable]]).
	self assert: (classConsts allSatisfy: [:each | each environment == class]).
	self assert: class imports equals: {(subject classFor: Tools) fullyQualifiedReference}!

testExistingMethodsThatReferToClass
	| subject references |
	subject := RBModel new.
	references := (subject classFor: RefactoryTestDataApp) existingMethodsThatReferTo: ClassToRename.
	self assert: (references collect: [:each | each selector]) asSortedArray
		equals: #(#refersToClassConstantFullyQualified #refersToClassConstantPartiallyQualified1 refersToClassConstantPartiallyQualified2 #refersToClassConstantUnqualified #refersToClassFullyQualified #refersToClassFullyQualifiedBinding #refersToClassFullyQualifiedBindingInArray #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2 #refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2 #refersToClassPartiallyQualifiedBindingInArray #refersToClassUnqualified #refersToClassUnqualifiedBinding #refersToClassUnqualifiedBindingInArray #refersToClassUnqualifiedInArray #refersToClassVariableFullyQualified #refersToClassVariablePartiallyQualified #refersToClassVariablePartiallyQualifiedBinding)!

testExistingMethodsThatReferToClassAndItsNamespaces
	"We are explicitly referencing RBModel, but then Refactory.Browser as the environment of RBModel, and so on up through Refactory, and Root"
	self verifyMethodRefersToNamespaceHierarchy: self class >> self selector in: RBModel new!

testExistingMethodsThatReferToClassViaBindingReference
	"We are explicitly referencing RBModel, but then Refactory.Browser as the environment of RBModel, and Refactory, and Root"
	self verifyMethodRefersToNamespaceHierarchy: self class >> self selector
		in: #{Refactory.Browser.RBModel} value new!

testImplementors
	| st |
	st := RBModel new.
	self assert: ((st allImplementorsOf: #printString) includes: (st classNamed: #'Core.Object')).
	(st classNamed: #'Core.Object') removeMethod: #printString.
	self deny: ((st allImplementorsOf: #printString) includes: (st classNamed: #'Core.Object'))!

testIncludesClass
	self assert: (RBModel new includesClassNamed: #'Core.Object').
	self deny: (RBModel new includesClassNamed: #Object1).
	self
		deny: ((RBModel
				onEnvironment: (ClassEnvironment onEnvironment: BrowserEnvironment new classes: {Object}))
					includesClassNamed: #OrderedCollection)!

testMetaclassNamed
	| model metaclass |
	model := RBModel new.
	metaclass := model metaclassNamed: 'Core.Symbol'.
	self assert: metaclass realClass identicalTo: Symbol class.
	self assert: (model metaclassNamed: 'Core.Symbol') identicalTo: metaclass
	!

testModelImplementorsSenders
	| model class modelImps refs found |
	model := RBModel new.
	model
		defineClass: 'Object subclass: #Asdf
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: ''''
			category: ''Refactory-Testing'''.
	class := model classNamed: #Asdf.
	class compile: 'storeOn: aStream ^super storeOn: aStream' classified: #printing.
	modelImps := model allImplementorsOf: #storeOn:.
	self assert: (modelImps includes: class).
	self assert: modelImps size - 1
		equals: (BrowserEnvironment new implementorsOf: #storeOn:) numberSelectors.
	refs := BrowserEnvironment new referencesTo: #storeOn:.
	found := false.
	(model allReferencesTo: #storeOn:) do: 
			[:each |
			each modelClass = class
				ifTrue: [found := true]
				ifFalse: [self assert: (refs includesSelector: each selector in: each modelClass realClass)]].
	self assert: found!

testRedefineClassChange
	| st |
	st := RBModel new.
	st
		defineClass: 'nil subclass: #Object
				instanceVariableNames: ''a''
				classVariableNames: ''A''
				poolDictionaries: ''OpcodePool''
				category: ''Refactory-Testing'''.
	self assert: (st includesClassNamed: #'Core.Object').
	self denyIsNil: (st classNamed: #'Core.Object')!

testReferencesPrintOn
	| hasFoundObject hasFoundSelf st |
	hasFoundObject := false.
	hasFoundSelf := false.
	st := RBModel new.
	(st allReferencesTo: #printOn:) do: 
			[:each |
			hasFoundObject := hasFoundObject
						or: [each selector = #fullPrintString and: [each modelClass = (st classNamed: #'Core.Object')]].
			hasFoundSelf := hasFoundSelf or: 
							[each selector = #testReferencesPrintOn and: [each modelClass = (st classNamed: self class fullName)]]].
	self assert: hasFoundObject.
	self assert: hasFoundSelf!

testReferencesPrintOnAfterAddition
	| hasFoundObject hasFoundSelf smalltalk |
	hasFoundObject := false.
	hasFoundSelf := false.
	smalltalk := RBModel new.
	(smalltalk classNamed: #'Core.Object') compile: 'someTestReference self printOn: nil'
		classified: #testing.
	(smalltalk classNamed: self class fullName) compile: 'someTestReference ^ #printOn:'
		classified: #testing.
	(smalltalk allReferencesTo: #printOn:) do: 
			[:each |
			hasFoundObject := hasFoundObject or: 
							[each selector = #someTestReference and: [each modelClass = (smalltalk classNamed: #'Core.Object')]].
			hasFoundSelf := hasFoundSelf or: 
							[each selector = #someTestReference
								and: [each modelClass = (smalltalk classNamed: self class fullName)]]].
	self assert: hasFoundObject.
	self assert: hasFoundSelf!

testReferencesPrintOnAfterRemove
	| hasFoundObject hasFoundSelf st |
	hasFoundObject := false.
	hasFoundSelf := false.
	st := RBModel new.
	(st classNamed: #'Core.Object') removeMethod: #printString.
	(st allReferencesTo: #printOn:) do: 
			[:each |
			hasFoundObject := hasFoundObject
						or: [each selector = #printString and: [each modelClass = (st classNamed: #'Core.Object')]].
			hasFoundSelf := hasFoundSelf or: 
							[each selector = #testReferencesPrintOnAfterRemove
								and: [each modelClass = (st classNamed: self class fullName)]]].
	self deny: hasFoundObject.
	self assert: hasFoundSelf!

testRemoveClassChange
	| st className |
	st := RBModel new.
	className := self class fullName.
	st removeClassNamed: className.
	self deny: (st includesClassNamed: className).
	self assertIsNil: (st classNamed: className)!

testReparentSuperclassChange
	| st superclass subclasses |
	st := RBModel new.
	superclass := st classFor: TestCase superclass.
	subclasses := TestCase subclasses collect: [:each | st classFor: each].
	st reparentClasses: subclasses to: superclass.
	subclasses do: [:each | self assert: each superclass equals: superclass]!

testResolveBindingPathOfClassConstant
	| subject var |
	subject := RBModel new.
	var := subject fullBindingFor: 'OS.Win32Constants.BS_PATTERN'.
	self assert: var isKindOf: RBVariableBinding.
	self assert: var realBinding identicalTo: (OS.Win32Constants bindingFor: 'BS_PATTERN')!

testResolveBindingPathOfClassVar
	| subject var |
	subject := RBModel new.
	var := subject fullBindingFor: 'Object._EventsRegister'.
	self assert: var isKindOf: RBVariableBinding.
	self assert: var
		identicalTo: ((subject classFor: Object) classPool associationAt: '_EventsRegister').
	self assert: var realBinding identicalTo: (Object bindingFor: '_EventsRegister')!

testRoot
	| model root |
	model := RBModel new.
	root := model classFor: Root.
	self assert: root isKindOf: RBRootNamespace.
	self assertIsNil: root environment.
	self assert: root identicalTo: model rootNamespace.
	self assert: (model rootNamespace classPool at: #Root) identicalTo: root!

testRootClasses
	| model |
	model := RBModel new.
	self assert: (model rootClasses asSortedArray: [:a :b | a name < b name])
		equals: ((Class rootsOfTheWorld collect: [:each | model classFor: each])
				asSortedArray: [:a :b | a name < b name])!

verifyMethodRefersToNamespaceHierarchy: aCompiledMethod in: aRBModel
	| myModelClass path env |
	myModelClass := aRBModel classFor: aCompiledMethod methodClass.
	"We are explicitly referencing RBModel, but then Refactory.Browser as the environment of RBModel, and Refactory, and Root"
	env := aRBModel class.
	path := OrderedCollection new.
	
	[| references |
	path addLast: env.
	references := myModelClass existingMethodsThatReferTo: env.
	self assert: (references includes: aCompiledMethod).
	(env := env environment) isNil]
			whileFalse.
	self assert: (path collect: [:each | each name]) asArray
		equals: #('RBModel' 'Browser' 'Refactory' 'Root')! !
!Refactory.Browser.Tests.RBModelTest categoriesForMethods!
testAllBehaviorsDo!public!unit tests! !
testAllBehaviorsDoOnSelectorEnvironment!public!unit tests! !
testCommentChange!public!unit tests! !
testDefineClassAfterDeletedChange!public!unit tests! !
testDefineClassChange!public!unit tests! !
testDefineClassChangeD8!public!unit tests! !
testExistingMethodsThatReferToClass!public!unit tests! !
testExistingMethodsThatReferToClassAndItsNamespaces!public!unit tests! !
testExistingMethodsThatReferToClassViaBindingReference!public!unit tests! !
testImplementors!public!unit tests! !
testIncludesClass!public!unit tests! !
testMetaclassNamed!public!unit tests! !
testModelImplementorsSenders!public!unit tests! !
testRedefineClassChange!public!unit tests! !
testReferencesPrintOn!public!unit tests! !
testReferencesPrintOnAfterAddition!public!unit tests! !
testReferencesPrintOnAfterRemove!public!unit tests! !
testRemoveClassChange!public!unit tests! !
testReparentSuperclassChange!public!unit tests! !
testResolveBindingPathOfClassConstant!public!unit tests! !
testResolveBindingPathOfClassVar!public!unit tests! !
testRoot!public!unit tests! !
testRootClasses!public!unit tests! !
verifyMethodRefersToNamespaceHierarchy:in:!helpers!private! !
!

