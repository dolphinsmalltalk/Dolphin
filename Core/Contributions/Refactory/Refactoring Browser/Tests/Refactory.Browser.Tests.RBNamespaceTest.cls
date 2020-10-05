"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringBrowserTest subclass: #'Refactory.Browser.Tests.RBNamespaceTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RBNamespaceTest guid: (Core.GUID fromString: '{79170e4b-f3f8-4b46-8093-dac62f866cba}')!
Refactory.Browser.Tests.RBNamespaceTest comment: ''!
!Refactory.Browser.Tests.RBNamespaceTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RBNamespaceTest methodsFor!

testAllClassesDo
	| model classes |
	classes := 0.
	model := RBNamespace new.
	model allClassesDo: 
			[:each |
			each name = #'Core.Object' ifTrue: [each allSubclasses].
			classes := classes + 1].
	BrowserEnvironment new classesDo: [:each | classes := classes - 1].
	self assert: classes equals: 0!

testCommentChange
	| st cl |
	st := RBNamespace new.
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
	st := RBNamespace new.
	className := self class fullName.
	st removeClassNamed: className.
	self deny: (st includesClassNamed: className).
	st defineClass: self class definition.
	self assert: (st includesClassNamed: className).
	self denyIsNil: (st classNamed: className)!

testDefineClassChange
	| st |
	st := RBNamespace new.
	st
		defineClass: 'RefactoringBrowserTest subclass: #SmalltalkTestXXX
				instanceVariableNames: ''''
				classVariableNames: ''''
				poolDictionaries: ''''
				category: ''Refactory-Testing'''.
	self assert: (st includesClassNamed: #SmalltalkTestXXX).
	self denyIsNil: (st classNamed: #SmalltalkTestXXX)!

testImplementors
	| st |
	st := RBNamespace new.
	self assert: ((st allImplementorsOf: #printString) includes: (st classNamed: #'Core.Object')).
	(st classNamed: #'Core.Object') removeMethod: #printString.
	self deny: ((st allImplementorsOf: #printString) includes: (st classNamed: #'Core.Object'))!

testIncludesClass
	self assert: (RBNamespace new includesClassNamed: #'Core.Object').
	self deny: (RBNamespace new includesClassNamed: #Object1).
	self
		deny: ((RBNamespace
				onEnvironment: (ClassEnvironment onEnvironment: BrowserEnvironment new classes: {Object}))
					includesClassNamed: #OrderedCollection)!

testModelImplementorsSenders
	| model class modelImps refs found |
	model := RBNamespace new.
	model
		defineClass: 'Object subclass: #Asdf
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: ''''
			category: ''Refactory-Testing'''.
	class := model classNamed: #Asdf.
	class compile: 'storeOn: aStream ^super storeOn: aStream' classified: #(#printing).
	modelImps := model allImplementorsOf: #storeOn:.
	self assert: (modelImps includes: class).
	self assert: modelImps size - 1
		equals: (BrowserEnvironment new implementorsOf: #storeOn:) numberSelectors.
	refs := BrowserEnvironment new referencesTo: #storeOn:.
	found := false.
	model allReferencesTo: #storeOn:
		do: 
			[:each |
			each modelClass = class
				ifTrue: [found := true]
				ifFalse: [self assert: (refs includesSelector: each selector in: each modelClass realClass)]].
	self assert: found!

testRedefineClassChange
	| st |
	st := RBNamespace new.
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
	st := RBNamespace new.
	st allReferencesTo: #printOn:
		do: 
			[:each |
			hasFoundObject := hasFoundObject
						or: [each selector = #fullPrintString and: [each modelClass = (st classNamed: #'Core.Object')]].
			hasFoundSelf := hasFoundSelf
						or: [each selector = #testReferencesPrintOn and: [each modelClass = (st classNamed: self class fullName)]]].
	self assert: hasFoundObject.
	self assert: hasFoundSelf!

testReferencesPrintOnAfterAddition
	| hasFoundObject hasFoundSelf smalltalk |
	hasFoundObject := false.
	hasFoundSelf := false.
	smalltalk := RBNamespace new.
	(smalltalk classNamed: #'Core.Object') 
		compile: 'someTestReference self printOn: nil'
		classified: #(testing).
	(smalltalk classNamed: self class fullName)
		compile: 'someTestReference ^ #printOn:'
		classified: #(testing).
	smalltalk allReferencesTo: #printOn: do: [ :each | 
		hasFoundObject := hasFoundObject 
			or: [ each selector = #someTestReference 
			and: [ each modelClass = (smalltalk classNamed: #'Core.Object') ] ].
		hasFoundSelf := hasFoundSelf
			or: [ each selector = #someTestReference 
			and: [ each modelClass = (smalltalk classNamed: self class fullName) ] ] ].
	self assert: hasFoundObject.
	self assert: hasFoundSelf!

testReferencesPrintOnAfterRemove
	| hasFoundObject hasFoundSelf st |
	hasFoundObject := false.
	hasFoundSelf := false.
	st := RBNamespace new.
	(st classNamed: #'Core.Object') removeMethod: #printString.
	st allReferencesTo: #printOn:
		do: 
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
	st := RBNamespace new.
	className := self class fullName.
	st removeClassNamed: className.
	self deny: (st includesClassNamed: className).
	self assertIsNil: (st classNamed: className)!

testReparentSuperclassChange
	| st superclass subclasses |
	st := RBNamespace new.
	superclass := st classFor: TestCase superclass.
	subclasses := TestCase subclasses collect: [:each | st classFor: each].
	st reparentClasses: subclasses to: superclass.
	subclasses do: [:each | self assert: each superclass equals: superclass]!

testRoots
	| model |
	model := RBNamespace new.
	self assert: (model rootClasses asSortedCollection: [:a :b | a name < b name]) asArray
		equals: ((Class rootsOfTheWorld collect: [:each | model classFor: each])
				asSortedCollection: [:a :b | a name < b name]) asArray! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testAllClassesDo!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testCommentChange!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testDefineClassAfterDeletedChange!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testDefineClassChange!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testImplementors!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testIncludesClass!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testModelImplementorsSenders!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testRedefineClassChange!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testReferencesPrintOn!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testReferencesPrintOnAfterAddition!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testReferencesPrintOnAfterRemove!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testRemoveClassChange!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testReparentSuperclassChange!class tests!public! !
!Refactory.Browser.Tests.RBNamespaceTest categoriesFor: #testRoots!class tests!public! !

