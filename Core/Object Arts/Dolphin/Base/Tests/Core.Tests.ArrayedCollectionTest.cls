"Filed out from Dolphin Smalltalk"!

Core.Tests.SequenceableCollectionTest
	subclass: #'Core.Tests.ArrayedCollectionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.ArrayedCollectionTest guid: (Core.GUID fromString: '{48d15c8e-983b-48d0-8c62-51b644ba6bdb}')!

Core.Tests.ArrayedCollectionTest isNonInstantiable: true!

Core.Tests.ArrayedCollectionTest comment: ''!

!Core.Tests.ArrayedCollectionTest methodsFor!

testNewWithAll
	| subject elem |
	0 to: 3
		do: 
			[:i |
			elem := self assimilate: i.
			subject := self collectionClass new: i withAll: elem.
			self assert: subject size equals: i.
			subject allSatisfy: [:each | each = elem]]!

testReplaceIdentityWith
	| a rep |
	a := self newCollection: #($1 $2 $3 $3 $5).
	rep := self assimilate: $0.
	a replaceIdentity: (self assimilate: $1) with: rep.
	self assert: a equals: (self newCollection: #($0 $2 $3 $3 $5)).
	a replaceIdentity: (self assimilate: $3) with: rep.
	self assert: a equals: (self newCollection: #($0 $2 $0 $3 $5)).
	a replaceIdentity: (self assimilate: $5) with: rep.
	self assert: a equals: (self newCollection: #($0 $2 $0 $3 $0)).
	a replaceIdentity: (self assimilate: $6) with: rep.
	self assert: a equals: (self newCollection: #($0 $2 $0 $3 $0 $0))!

testSortColon
	| subject |
	subject := self newCollection: #(3 1 2 4).
	subject sort: [:a :b | a <= b].
	self assert: subject equals: (self newCollection: #(1 2 3 4)).
	subject sort: [:a :b | a >= b].
	self assert: subject equals: (self newCollection: #(4 3 2 1)).
! !

!Core.Tests.ArrayedCollectionTest categoriesForMethods!
testNewWithAll!public! !
testReplaceIdentityWith!public!unit tests! !
testSortColon!public!unit tests! !
!

