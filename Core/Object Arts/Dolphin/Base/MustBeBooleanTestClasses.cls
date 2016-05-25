"Filed out from Dolphin Smalltalk 7"!

DolphinTestClassResource subclass: #MustBeBooleanTestClasses
	instanceVariableNames: 'trueClass falseClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MustBeBooleanTestClasses guid: (GUID fromString: '{7A283553-A0FA-4C3F-8502-7D21D0BABCA4}')!
MustBeBooleanTestClasses comment: ''!
!MustBeBooleanTestClasses categoriesForClass!Unclassified! !
!MustBeBooleanTestClasses methodsFor!

createClasses
	trueClass := self
				createClass: #MustBeBooleanTestTrueClass
				superclass: Object
				instVars: ''
				pools: ''.
	trueClass compile: 'mustBeBoolean ^true'.
	falseClass := self
				createClass: #MustBeBooleanTestFalseClass
				superclass: Object
				instVars: ''
				pools: ''.
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

