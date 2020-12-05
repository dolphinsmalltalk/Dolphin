"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.RBAbstractCondition'
	instanceVariableNames: 'errorMacro'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBAbstractCondition guid: (Core.GUID fromString: '{f74a2f07-4669-4626-8d47-0122b7ce23ff}')!
Refactory.Browser.RBAbstractCondition isNonInstantiable: true!
Refactory.Browser.RBAbstractCondition comment: 'AbstractCondition is an abstract class. It represents a precondition that is used whenever a Refactoring is performed. All preconditions must evaluate successfully in order for the Refactoring to be performed.

Instance Variables:
	errorMacro	<String>	the error string that is used when the condition fails'!
!Refactory.Browser.RBAbstractCondition categoriesForClass!Refactory-Conditions! !
!Refactory.Browser.RBAbstractCondition methodsFor!

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
!Refactory.Browser.RBAbstractCondition categoriesFor: #&!logical operations!public! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #|!logical operations!public! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #check!checking!public! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #errorBlock!accessing!public! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #errorBlockFor:!private! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #errorMacro!private! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #errorMacro:!private! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #errorString!accessing!public! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #errorStringFor:!private! !
!Refactory.Browser.RBAbstractCondition categoriesFor: #not!logical operations!public! !

