"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTestClassResource subclass: #'Core.Tests.MustBeBooleanTestClasses'
	instanceVariableNames: 'trueClass falseClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.MustBeBooleanTestClasses guid: (Core.GUID fromString: '{7a283553-a0fa-4c3f-8502-7d21d0babca4}')!
Core.Tests.MustBeBooleanTestClasses comment: ''!
!Core.Tests.MustBeBooleanTestClasses categoriesForClass!Unclassified! !
!Core.Tests.MustBeBooleanTestClasses methodsFor!

createClasses
	trueClass := self
				createClass: #MustBeBooleanTestTrueClass
				superclass: Object
				instVars: ''
				pools: ''
				classVars: ''.
	trueClass compile: 'mustBeBoolean ^true'.
	falseClass := self
				createClass: #MustBeBooleanTestFalseClass
				superclass: Object
				instVars: ''
				pools: ''
				classVars: ''.
	falseClass compile: 'mustBeBoolean ^false'!

falseClass
	^falseClass!

isAvailable
	^trueClass notNil!

tearDown
	super tearDown.
	trueClass := falseClass := nil!

trueClass
	^trueClass! !
!Core.Tests.MustBeBooleanTestClasses categoriesFor: #createClasses!public!unit tests! !
!Core.Tests.MustBeBooleanTestClasses categoriesFor: #falseClass!accessing!public! !
!Core.Tests.MustBeBooleanTestClasses categoriesFor: #isAvailable!public!Testing! !
!Core.Tests.MustBeBooleanTestClasses categoriesFor: #tearDown!public!Running! !
!Core.Tests.MustBeBooleanTestClasses categoriesFor: #trueClass!accessing!public! !

