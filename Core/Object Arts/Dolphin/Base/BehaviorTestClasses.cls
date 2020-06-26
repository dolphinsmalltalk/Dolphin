"Filed out from Dolphin Smalltalk 7"!

DolphinTestClassResource subclass: #BehaviorTestClasses
	instanceVariableNames: 'classWithAbstractMethod1 classWithAbstractMethod2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BehaviorTestClasses guid: (GUID fromString: '{bc98a827-49e3-4ce3-902e-fa6452944374}')!
BehaviorTestClasses comment: ''!
!BehaviorTestClasses categoriesForClass!Unclassified! !
!BehaviorTestClasses methodsFor!

classWithAbstractMethod1
	^classWithAbstractMethod1!

classWithAbstractMethod2
	^classWithAbstractMethod2!

createClasses
	classWithAbstractMethod1 := self
				createClass: #ClassWithAbstractMethod1
				superclass: Object
				instVars: ''
				pools: ''
				classVars: ''.
	classWithAbstractMethod1 compile: 'abstractMethod ^self subclassResponsibility'.
	classWithAbstractMethod1 class compile: 'nonAbstractMethod  ^#(subclassResponsibility)'.
	classWithAbstractMethod2 := self
				createClass: #ClassWithAbstractMethod2
				superclass: Object
				instVars: 'iv1'
				pools: ''
				classVars: ''.
	classWithAbstractMethod2 class compile: 'abstractMethod self subclassResponsibility'.
	classWithAbstractMethod2 compile: 'nonAbstractMethod1 #(subclassResponsibility)'.
	classWithAbstractMethod2 compile: 'nonAbstractMethod2  ^iv1 subclassResponsibility'.
	classWithAbstractMethod1 compile: 'returnSendSelfSpecial ^self class'.
	classWithAbstractMethod1 compile: 'sendSelfSpecial ^self value'!

isAvailable
	^classWithAbstractMethod1 notNil!

tearDown
	super tearDown.
	classWithAbstractMethod1 := classWithAbstractMethod2 := nil! !
!BehaviorTestClasses categoriesFor: #classWithAbstractMethod1!accessing!public! !
!BehaviorTestClasses categoriesFor: #classWithAbstractMethod2!accessing!public! !
!BehaviorTestClasses categoriesFor: #createClasses!public!unit tests! !
!BehaviorTestClasses categoriesFor: #isAvailable!public!Testing! !
!BehaviorTestClasses categoriesFor: #tearDown!public!Running! !

