"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RBAbstractCondition subclass: #RBNegationCondition
	instanceVariableNames: 'condition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBNegationCondition comment: 'NegationCondition represents negating another condition.

Instance Variables:
	condition	<AbstractCondition>	the condition that is to be negated'!

RBNegationCondition guid: (GUID fromString: '{B9C3D59C-1AD9-483A-91CC-9D03B95A12A6}')!

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
!RBNegationCondition categoriesFor: #errorBlockFor:!*-unclassified!private! !
!RBNegationCondition categoriesFor: #errorStringFor:!*-unclassified!private! !
!RBNegationCondition categoriesFor: #printOn:!printing!public! !

!RBNegationCondition class methodsFor!

on: aCondition
	^self new condition: aCondition! !
!RBNegationCondition class categoriesFor: #on:!instance creation!public! !

