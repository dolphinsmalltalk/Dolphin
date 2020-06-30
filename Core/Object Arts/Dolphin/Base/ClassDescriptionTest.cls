"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ClassDescriptionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ClassDescriptionTest guid: (GUID fromString: '{2e47ba8b-6e05-41a9-87ce-ccfeabd45cb7}')!
ClassDescriptionTest isAbstract: true!
ClassDescriptionTest comment: ''!
!ClassDescriptionTest categoriesForClass!Unclassified! !
!ClassDescriptionTest methodsFor!

allClassHierarchyInstancesDo: aMonadicValuable
	self subclassResponsibility!

testLessOrEqual
	self subclassResponsibility!

testSubclasses
	self allClassHierarchyInstancesDo: 
			[:each |
			each subclasses do: [:subclass | self assert: subclass superclass identicalTo: each].
			self assert: each subclasses asSet size equals: each subclasses size.
			"Dolphin's Class subclasses collections have historically been sorted arrays. This gives repeatable results when enumerating classes.
			It does impose a cost when building classes, but I'm loathe to change it now for fear of what it will break."
			self assert: each subclasses
				equals: (each subclasses asSortedCollection: [:a :b | a name <= b name]) asArray]! !
!ClassDescriptionTest categoriesFor: #allClassHierarchyInstancesDo:!helpers!private! !
!ClassDescriptionTest categoriesFor: #testLessOrEqual!public!unit tests! !
!ClassDescriptionTest categoriesFor: #testSubclasses!public!unit tests! !

