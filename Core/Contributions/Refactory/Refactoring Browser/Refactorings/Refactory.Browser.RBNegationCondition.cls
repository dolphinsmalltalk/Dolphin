"Filed out from Dolphin Smalltalk 7"!

RBAbstractCondition subclass: #RBNegationCondition
	instanceVariableNames: 'condition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!RBNegationCondition categoriesFor: #check!checking!public! !
!RBNegationCondition categoriesFor: #condition:!initialize/release!public! !
!RBNegationCondition categoriesFor: #errorBlockFor:!private! !
!RBNegationCondition categoriesFor: #errorStringFor:!private! !
!RBNegationCondition categoriesFor: #printOn:!printing!public! !

!RBNegationCondition class methodsFor!

on: aCondition
	^self new condition: aCondition! !
!RBNegationCondition class categoriesFor: #on:!instance creation!public! !

