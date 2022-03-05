"Filed out from Dolphin Smalltalk"!

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
				pools: ''.
	classWithAbstractMethod1 compile: 'abstractMethod ^self subclassResponsibility'.
	classWithAbstractMethod1 class compile: 'nonAbstractMethod  ^#(subclassResponsibility)'.
	classWithAbstractMethod2 := self
				createClass: #ClassWithAbstractMethod2
				superclass: Object
				instVars: 'iv1'
				pools: ''.
	classWithAbstractMethod2 class compile: 'abstractMethod self subclassResponsibility'.
	classWithAbstractMethod2 compile: 'nonAbstractMethod1 #(subclassResponsibility)'.
	classWithAbstractMethod2 compile: 'nonAbstractMethod2  ^iv1 subclassResponsibility'.

	classWithAbstractMethod1 compile: 'returnSendSelfSpecial ^self class'.
	classWithAbstractMethod1 compile: 'sendSelfSpecial ^self value'.
!

isAvailable
	^classWithAbstractMethod1 notNil!

tearDown
	super tearDown.
	classWithAbstractMethod1 := classWithAbstractMethod2 := nil! !
!BehaviorTestClasses categoriesForMethods!
classWithAbstractMethod1!accessing!public! !
classWithAbstractMethod2!accessing!public! !
createClasses!public!unit tests! !
isAvailable!public!Testing! !
tearDown!public!Running! !
!

