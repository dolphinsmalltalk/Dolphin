"Filed out from Dolphin Smalltalk"!

DolphinTestClassResource subclass: #MustBeBooleanTestClasses
	instanceVariableNames: 'trueClass falseClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MustBeBooleanTestClasses guid: (GUID fromString: '{7a283553-a0fa-4c3f-8502-7d21d0babca4}')!

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

!MustBeBooleanTestClasses categoriesForMethods!
createClasses!public!unit tests! !
falseClass!accessing!public! !
isAvailable!public!Testing! !
tearDown!public!Running! !
trueClass!accessing!public! !
!

