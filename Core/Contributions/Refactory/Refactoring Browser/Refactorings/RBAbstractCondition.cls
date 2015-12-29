"Filed out from Dolphin Smalltalk 2000 release 4.01"!

Object subclass: #RBAbstractCondition
	instanceVariableNames: 'errorMacro'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBAbstractCondition comment: 'AbstractCondition is an abstract class. It represents a precondition that is used whenever a Refactoring is performed. All preconditions must evaluate successfully in order for the Refactoring to be performed.

Instance Variables:
	errorMacro	<String>	the error string that is used when the condition fails'!

RBAbstractCondition guid: (GUID fromString: '{F74A2F07-4669-4626-8D47-0122B7CE23FF}')!

!RBAbstractCondition categoriesForClass!Refactory-Conditions! !
!RBAbstractCondition methodsFor!

& aCondition 
	^RBConjunctiveCondition new left: self right: aCondition!

| aCondition 
	"(A | B) = (A not & B not) not"

	^(self not & aCondition not) not!

check
	self subclassResponsibility!

errorBlock
	^self errorBlockFor: false!

errorBlockFor: aBoolean 
	^nil!

errorMacro
	^errorMacro isNil
		ifTrue: ['unknown']
		ifFalse: [errorMacro]!

errorMacro: aString 
	errorMacro := aString!

errorString
	^self errorStringFor: false!

errorStringFor: aBoolean
	^self errorMacro expandMacrosWith: aBoolean!

not
	^RBNegationCondition on: self! !
!RBAbstractCondition categoriesFor: #&!logical operations!public! !
!RBAbstractCondition categoriesFor: #|!logical operations!public! !
!RBAbstractCondition categoriesFor: #check!*-subclass responsibility!checking!public! !
!RBAbstractCondition categoriesFor: #errorBlock!accessing!public! !
!RBAbstractCondition categoriesFor: #errorBlockFor:!*-unclassified!private! !
!RBAbstractCondition categoriesFor: #errorMacro!*-unclassified!private! !
!RBAbstractCondition categoriesFor: #errorMacro:!*-unclassified!private! !
!RBAbstractCondition categoriesFor: #errorString!accessing!public! !
!RBAbstractCondition categoriesFor: #errorStringFor:!*-unclassified!private! !
!RBAbstractCondition categoriesFor: #not!logical operations!public! !

