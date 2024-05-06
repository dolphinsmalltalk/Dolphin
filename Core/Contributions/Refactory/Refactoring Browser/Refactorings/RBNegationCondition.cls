"Filed out from Dolphin Smalltalk"!

RBAbstractCondition subclass: #RBNegationCondition
	instanceVariableNames: 'condition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RBNegationCondition guid: (GUID fromString: '{b9c3d59c-1ad9-483a-91cc-9d03b95a12a6}')!

RBNegationCondition comment: 'NegationCondition represents negating another condition.

Instance Variables:
	condition	<AbstractCondition>	the condition that is to be negated'!

!RBNegationCondition categoriesForClass!Refactory-Conditions! !

!RBNegationCondition methodsFor!

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

!RBNegationCondition categoriesForMethods!
check!checking!public! !
condition:!initialize/release!public! !
errorBlockFor:!private! !
errorStringFor:!private! !
printOn:!printing!public! !
!

!RBNegationCondition class methodsFor!

on: aCondition
	^self new condition: aCondition! !

!RBNegationCondition class categoriesForMethods!
on:!instance creation!public! !
!

