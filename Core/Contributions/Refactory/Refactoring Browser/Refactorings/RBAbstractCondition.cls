"Filed out from Dolphin Smalltalk 7"!

Object subclass: #RBAbstractCondition
	instanceVariableNames: 'errorMacro'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBAbstractCondition guid: (GUID fromString: '{f74a2f07-4669-4626-8d47-0122b7ce23ff}')!
RBAbstractCondition isAbstract: true!
RBAbstractCondition comment: 'AbstractCondition is an abstract class. It represents a precondition that is used whenever a Refactoring is performed. All preconditions must evaluate successfully in order for the Refactoring to be performed.

Instance Variables:
	errorMacro	<String>	the error string that is used when the condition fails'!
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
!RBAbstractCondition categoriesFor: #check!checking!public! !
!RBAbstractCondition categoriesFor: #errorBlock!accessing!public! !
!RBAbstractCondition categoriesFor: #errorBlockFor:!private! !
!RBAbstractCondition categoriesFor: #errorMacro!private! !
!RBAbstractCondition categoriesFor: #errorMacro:!private! !
!RBAbstractCondition categoriesFor: #errorString!accessing!public! !
!RBAbstractCondition categoriesFor: #errorStringFor:!private! !
!RBAbstractCondition categoriesFor: #not!logical operations!public! !

