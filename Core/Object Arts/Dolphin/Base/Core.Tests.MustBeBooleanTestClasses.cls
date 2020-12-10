"Filed out from Dolphin Smalltalk 7"!

DolphinTestClassResource subclass: #MustBeBooleanTestClasses
	instanceVariableNames: 'trueClass falseClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MustBeBooleanTestClasses guid: (GUID fromString: '{7a283553-a0fa-4c3f-8502-7d21d0babca4}')!
MustBeBooleanTestClasses comment: ''!
!MustBeBooleanTestClasses categoriesForClass!Unclassified! !
!MustBeBooleanTestClasses methodsFor!

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
!MustBeBooleanTestClasses categoriesFor: #createClasses!public!unit tests! !
!MustBeBooleanTestClasses categoriesFor: #falseClass!accessing!public! !
!MustBeBooleanTestClasses categoriesFor: #isAvailable!public!Testing! !
!MustBeBooleanTestClasses categoriesFor: #tearDown!public!Running! !
!MustBeBooleanTestClasses categoriesFor: #trueClass!accessing!public! !

