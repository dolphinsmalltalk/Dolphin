"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.ClassDescriptionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ClassDescriptionTest guid: (Core.GUID fromString: '{2e47ba8b-6e05-41a9-87ce-ccfeabd45cb7}')!
Core.Tests.ClassDescriptionTest isNonInstantiable: true!
Core.Tests.ClassDescriptionTest comment: ''!
!Core.Tests.ClassDescriptionTest categoriesForClass!Unclassified! !
!Core.Tests.ClassDescriptionTest methodsFor!

allClassHierarchyInstancesDo: aMonadicValuable
	self subclassResponsibility!

testLessOrEqual
	self subclassResponsibility!

testStoreOn
	self subclassResponsibility!

testSubclasses
	self allClassHierarchyInstancesDo: 
			[:each |
			each subclasses do: [:subclass | self assert: subclass superclass identicalTo: each].
			self assert: each subclasses equals: each subclasses distinct]! !
!Core.Tests.ClassDescriptionTest categoriesFor: #allClassHierarchyInstancesDo:!helpers!private! !
!Core.Tests.ClassDescriptionTest categoriesFor: #testLessOrEqual!public!unit tests! !
!Core.Tests.ClassDescriptionTest categoriesFor: #testStoreOn!public!unit tests! !
!Core.Tests.ClassDescriptionTest categoriesFor: #testSubclasses!public!unit tests! !

