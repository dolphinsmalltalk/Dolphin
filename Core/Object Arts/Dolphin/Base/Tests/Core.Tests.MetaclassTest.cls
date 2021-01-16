"Filed out from Dolphin Smalltalk 7"!

Core.Tests.ClassDescriptionTest subclass: #'Core.Tests.MetaclassTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.MetaclassTest guid: (Core.GUID fromString: '{0643eed4-cf1f-4bfa-84f5-4af3a05fe655}')!
Core.Tests.MetaclassTest comment: ''!
!Core.Tests.MetaclassTest categoriesForClass!Unclassified! !
!Core.Tests.MetaclassTest methodsFor!

allClassHierarchyInstancesDo: aMonadicValuable
	Smalltalk allRoots do: [:root | root class withAllSubclassesDo: aMonadicValuable]!

testInstances
	"Verifies that 
		- all metaclasses are correctly linked into the class hierarchy
		- that they have exactly one instance, and it is the expected one
		- that the superclass and subclasses or metaclass and instance are matching"

	| all stats unbound shadows |
	all := Array writeStream: Class allClasses size.
	self allClassHierarchyInstancesDo: [:each | all nextPut: each].
	all := all contents asIdentitySet.
	"It is rather expensive to run a few thousand instance scans individually, so instead we use the VM's instance stats primitive to check that there is exactly one instance of each metaclass and then check that the stored instance is of the metaclass."
	stats := MemoryManager current primInstanceStats: nil.
	unbound := IdentitySet new.
	1 to: stats size
		by: 3
		do: 
			[:i |
			| each |
			each := stats at: i.
			each isMeta
				ifTrue: 
					[| instClass |
					(all includes: each)
						ifTrue: 
							[self
								assert: (stats at: i + 1)
								equals: 1
								description: 'Metaclasses should have one instance'.
							"Is the known instance actually an instance of this metaclass?"
							self assert: each instanceClass class identicalTo: each.
							"Does the instance have a matching superclass?"
							instClass := each instanceClass.
							instClass superclass
								ifNil: [self assert: each superclass identicalTo: Class]
								ifNotNil: [:superclass | self assert: superclass class identicalTo: each superclass].
							"And matching subclasses too?"
							self assert: each subclasses equals: (instClass subclasses collect: [:subbie | subbie class])]
						ifFalse: [unbound add: each]]].
	"Metaclasses not bound into the class hierarchy? It is all too easy to create these in tests and hang onto them in TestCase instance variables, so we can't reliably assert
	that there are none. What we can do is to check that they aren't dead versions of bound classes"
	"self assert: unbound asArray equals: #()"
	shadows := unbound select: 
					[:each |
					each isAnonymous not and: [each instanceClass environment includesKey: each instanceClass name]].
	self assert: shadows asArray equals: #()!

testLessOrEqual
	self assert: ArithmeticError class <= ArithmeticError class
		description: 'Metaclasses must be <= to themselves'.
	self deny: ArithmeticError class <= ArithmeticError
		description: 'Metaclasses should sort after their instance classes'.
	self assert: ArithmeticError class <= ArithmeticValue class.
	self assert: ArithmeticError class <= ArithmeticValue.
	self deny: ArithmeticValue class <= ArithmeticError.
	self deny: ArithmeticValue class <= ArithmeticError class!

testName
	Smalltalk allRoots do: 
			[:root |
			root class
				allSubclassesDo: [:each | self assert: each name equals: each instanceClass name , ' class']]!

testStoreOn
	self assert: self class class storeString equals: 'Core.Tests.MetaclassTest class'! !
!Core.Tests.MetaclassTest categoriesFor: #allClassHierarchyInstancesDo:!helpers!private! !
!Core.Tests.MetaclassTest categoriesFor: #testInstances!public!unit tests! !
!Core.Tests.MetaclassTest categoriesFor: #testLessOrEqual!public!unit tests! !
!Core.Tests.MetaclassTest categoriesFor: #testName!public!unit tests! !
!Core.Tests.MetaclassTest categoriesFor: #testStoreOn!public!unit tests! !

