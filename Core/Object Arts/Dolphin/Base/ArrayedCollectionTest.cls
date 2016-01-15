"Filed out from Dolphin Smalltalk 7"!

SequenceableCollectionTest subclass: #ArrayedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ArrayedCollectionTest guid: (GUID fromString: '{48D15C8E-983B-48D0-8C62-51B644BA6BDB}')!
ArrayedCollectionTest comment: ''!
!ArrayedCollectionTest categoriesForClass!Unclassified! !
!ArrayedCollectionTest methodsFor!

testReplaceIdentityWith
	| a rep |
	a := self newCollection: #($1 $2 $3 $3 $5).
	rep := self assimilate: $0.
	a replaceIdentity: (self assimilate: $1) with: rep.
	self assert: a = (self newCollection: #($0 $2 $3 $3 $5)).
	a replaceIdentity: (self assimilate: $3) with: rep.
	self assert: a = (self newCollection: #($0 $2 $0 $3 $5)).
	a replaceIdentity: (self assimilate: $5) with: rep.
	self assert: a = (self newCollection: #($0 $2 $0 $3 $0)).
	a replaceIdentity: (self assimilate: $6) with: rep.
	self assert: a = (self newCollection: #($0 $2 $0 $3 $0 $0))! !
!ArrayedCollectionTest categoriesFor: #testReplaceIdentityWith!public!unit tests! !

!ArrayedCollectionTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!ArrayedCollectionTest class categoriesFor: #isAbstract!public!Testing! !

