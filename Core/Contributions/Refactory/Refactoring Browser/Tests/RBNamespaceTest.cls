"Filed out from Dolphin Smalltalk 7"!

RefactoringBrowserTest subclass: #RBNamespaceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBNamespaceTest guid: (GUID fromString: '{79170e4b-f3f8-4b46-8093-dac62f866cba}')!
RBNamespaceTest comment: ''!
!RBNamespaceTest categoriesForClass!Refactory-Testing! !
!RBNamespaceTest methodsFor!

testAllClassesDo
	| model classes |
	classes := 0.
	model := RBNamespace new.
	model allClassesDo: 
			[:each |
			each name = #Object ifTrue: [each allSubclasses].
			classes := classes + 1].
	BrowserEnvironment new classesDo: [:each | classes := classes - 1].
	self assert: classes equals: 0!

testDefineClassAfterDeletedChange
	| st |
	st := RBNamespace new.
	st removeClassNamed: self class name.
	self deny: (st includesClassNamed: self class name).
	st defineClass: self class definition.
	self assert: (st includesClassNamed: self class name).
	self denyIsNil: (st classNamed: self class name)!

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
	self assert: ((st allImplementorsOf: #printString) 
				includes: (st classNamed: #Object)).
	(st classNamed: #Object) removeMethod: #printString.
	self deny: ((st allImplementorsOf: #printString) 
				includes: (st classNamed: #Object))!

testIncludesClass
	self assert: (RBNamespace new includesClassNamed: #Object).
	self deny: (RBNamespace new includesClassNamed: #Object1).
	self 
		deny: ((RBNamespace 
				onEnvironment: (ClassEnvironment onEnvironment: BrowserEnvironment new
						classes: (Array with: Object))) 
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
	class compile: 'printOn: aStream ^super printOn: aStream' classified: #(#printing).
	modelImps := model allImplementorsOf: #printOn:.
	self assert: (modelImps includes: class).
	self assert: modelImps size - 1
		equals: (BrowserEnvironment new implementorsOf: #printOn:) numberSelectors.
	refs := BrowserEnvironment new referencesTo: #printOn:.
	found := false.
	model allReferencesTo: #printOn:
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
	self assert: (st includesClassNamed: #Object).
	self denyIsNil: (st classNamed: #Object)!

testReferencesPrintOn
	| hasFoundObject hasFoundSelf st |
	hasFoundObject := false.
	hasFoundSelf := false.
	st := RBNamespace new.
	st allReferencesTo: #printOn:
		do: 
			[:each | 
			hasFoundObject := hasFoundObject or: 
							[each selector = #printString 
								and: [each modelClass = (st classNamed: #Object)]].
			hasFoundSelf := hasFoundSelf or: 
							[each selector = #testReferencesPrintOn 
								and: [each modelClass = (st classNamed: self class name)]]].
	self assert: hasFoundObject.
	self assert: hasFoundSelf!

testReferencesPrintOnAfterRemove
	| hasFoundObject hasFoundSelf st |
	hasFoundObject := false.
	hasFoundSelf := false.
	st := RBNamespace new.
	(st classNamed: #Object) removeMethod: #printString.
	st allReferencesTo: #printOn:
		do: 
			[:each | 
			hasFoundObject := hasFoundObject or: 
							[each selector = #printString 
								and: [each modelClass = (st classNamed: #Object)]].
			hasFoundSelf := hasFoundSelf or: 
							[each selector = #testReferencesPrintOnAfterRemove 
								and: [each modelClass = (st classNamed: self class name)]]].
	self deny: hasFoundObject.
	self assert: hasFoundSelf!

testRemoveClassChange
	| st |
	st := RBNamespace new.
	st removeClassNamed: self class name.
	self deny: (st includesClassNamed: self class name).
	self assertIsNil: (st classNamed: self class name)!

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
!RBNamespaceTest categoriesFor: #testAllClassesDo!class tests!public! !
!RBNamespaceTest categoriesFor: #testDefineClassAfterDeletedChange!class tests!public! !
!RBNamespaceTest categoriesFor: #testDefineClassChange!class tests!public! !
!RBNamespaceTest categoriesFor: #testImplementors!class tests!public! !
!RBNamespaceTest categoriesFor: #testIncludesClass!class tests!public! !
!RBNamespaceTest categoriesFor: #testModelImplementorsSenders!class tests!public! !
!RBNamespaceTest categoriesFor: #testRedefineClassChange!class tests!public! !
!RBNamespaceTest categoriesFor: #testReferencesPrintOn!class tests!public! !
!RBNamespaceTest categoriesFor: #testReferencesPrintOnAfterRemove!class tests!public! !
!RBNamespaceTest categoriesFor: #testRemoveClassChange!class tests!public! !
!RBNamespaceTest categoriesFor: #testReparentSuperclassChange!class tests!public! !
!RBNamespaceTest categoriesFor: #testRoots!class tests!public! !

