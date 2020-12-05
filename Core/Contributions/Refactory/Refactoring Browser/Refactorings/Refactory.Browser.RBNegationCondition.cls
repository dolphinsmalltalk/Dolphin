"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RBAbstractCondition subclass: #'Refactory.Browser.RBNegationCondition'
	instanceVariableNames: 'condition'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RBNegationCondition guid: (Core.GUID fromString: '{b9c3d59c-1ad9-483a-91cc-9d03b95a12a6}')!
Refactory.Browser.RBNegationCondition comment: 'NegationCondition represents negating another condition.

Instance Variables:
	condition	<AbstractCondition>	the condition that is to be negated'!
!Refactory.Browser.RBNegationCondition categoriesForClass!Refactory-Conditions! !
!Refactory.Browser.RBNegationCondition methodsFor!

check
	^condition check not!

condition: aCondition 
	condition := aCondition.
	self errorMacro: condition errorMacro!

errorBlockFor: aBoolean 
	^condition errorBlockFor: aBoolean not!

errorStringFor: aBoolean 
	^condition errorStringFor: aBoolean not!

printOn: aStream 
	aStream nextPutAll: 'NOT ';
		print: condition! !
!Refactory.Browser.RBNegationCondition categoriesFor: #check!checking!public! !
!Refactory.Browser.RBNegationCondition categoriesFor: #condition:!initialize/release!public! !
!Refactory.Browser.RBNegationCondition categoriesFor: #errorBlockFor:!private! !
!Refactory.Browser.RBNegationCondition categoriesFor: #errorStringFor:!private! !
!Refactory.Browser.RBNegationCondition categoriesFor: #printOn:!printing!public! !

!Refactory.Browser.RBNegationCondition class methodsFor!

on: aCondition
	^self new condition: aCondition! !
!Refactory.Browser.RBNegationCondition class categoriesFor: #on:!instance creation!public! !

