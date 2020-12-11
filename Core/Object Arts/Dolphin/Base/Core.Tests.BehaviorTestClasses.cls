"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTestClassResource subclass: #'Core.Tests.BehaviorTestClasses'
	instanceVariableNames: 'classWithAbstractMethod1 classWithAbstractMethod2'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.BehaviorTestClasses guid: (Core.GUID fromString: '{bc98a827-49e3-4ce3-902e-fa6452944374}')!
Core.Tests.BehaviorTestClasses comment: ''!
!Core.Tests.BehaviorTestClasses categoriesForClass!Unclassified! !
!Core.Tests.BehaviorTestClasses methodsFor!

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
!Core.Tests.BehaviorTestClasses categoriesFor: #classWithAbstractMethod1!accessing!public! !
!Core.Tests.BehaviorTestClasses categoriesFor: #classWithAbstractMethod2!accessing!public! !
!Core.Tests.BehaviorTestClasses categoriesFor: #createClasses!public!unit tests! !
!Core.Tests.BehaviorTestClasses categoriesFor: #isAvailable!public!Testing! !
!Core.Tests.BehaviorTestClasses categoriesFor: #tearDown!public!Running! !

