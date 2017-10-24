"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #BehaviorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BehaviorTest guid: (GUID fromString: '{157f8981-4d21-430b-bbec-c8b53e6a6f56}')!
BehaviorTest comment: ''!
!BehaviorTest categoriesForClass!Unclassified! !
!BehaviorTest methodsFor!

testHasAbstractMethods
	| subject |
	subject := BehaviorTestClasses current classWithAbstractMethod1.
	self assert: subject hasAbstractMethods.
	self deny: subject class hasAbstractMethods.
	subject := BehaviorTestClasses current classWithAbstractMethod2.
	self deny: subject hasAbstractMethods.
	self assert: subject class hasAbstractMethods!

testIsAbstract
	self assert: BehaviorTestClasses current classWithAbstractMethod1 isAbstract.
	self assert: BehaviorTestClasses current classWithAbstractMethod2 isAbstract!

testIsNonInstantiable
	| subject |
	subject := BehaviorTestClasses current classWithAbstractMethod1.
	self deny: subject isNonInstantiable.
	self deny: subject class isNonInstantiable.
	subject isNonInstantiable: true.
	self assert: subject isNonInstantiable.
	self deny: subject class isNonInstantiable.
	subject isNonInstantiable: false.
	self deny: subject isNonInstantiable.
	self deny: subject class isNonInstantiable.
	subject class isNonInstantiable: true.
	self deny: subject isNonInstantiable.
	self assert: subject class isNonInstantiable.
	subject class isNonInstantiable: false.
	self deny: subject isNonInstantiable.
	self deny: subject class isNonInstantiable! !
!BehaviorTest categoriesFor: #testHasAbstractMethods!public! !
!BehaviorTest categoriesFor: #testIsAbstract!public! !
!BehaviorTest categoriesFor: #testIsNonInstantiable!public! !

!BehaviorTest class methodsFor!

resources
	^{BehaviorTestClasses}! !
!BehaviorTest class categoriesFor: #resources!Accessing!public! !

