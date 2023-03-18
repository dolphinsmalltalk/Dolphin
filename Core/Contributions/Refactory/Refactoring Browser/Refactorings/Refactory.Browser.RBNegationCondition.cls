"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBAbstractCondition
	subclass: #'Refactory.Browser.RBNegationCondition'
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
!Refactory.Browser.RBNegationCondition categoriesForMethods!
check!checking!public! !
condition:!initialize/release!public! !
errorBlockFor:!private! !
errorStringFor:!private! !
printOn:!printing!public! !
!

!Refactory.Browser.RBNegationCondition class methodsFor!

on: aCondition
	^self new condition: aCondition! !
!Refactory.Browser.RBNegationCondition class categoriesForMethods!
on:!instance creation!public! !
!

