"Filed out from Dolphin Smalltalk 7"!

RBAbstractCondition subclass: #RBConjunctiveCondition
	instanceVariableNames: 'left right failed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RBConjunctiveCondition guid: (GUID fromString: '{a39b3587-7d58-4929-b47c-00c804e537be}')!
RBConjunctiveCondition comment: 'ConjunctiveCondition represents and-ing two AbstractConditions together.

Instance Variables:
	failed	<Symbol>	which condition failed (#leftFailed, #rightFailed, or #unknownFailed)
	left	<AbstractCondition>	the condition on the left side of the and
	right	<AbstractCondition>	the condition on the right side of the and'!
!RBConjunctiveCondition categoriesForClass!Refactory-Conditions! !
!RBConjunctiveCondition methodsFor!

check
	left check
		ifFalse: 
			[failed := #leftFailed.
			^false].
	right check
		ifFalse: 
			[failed := #rightFailed.
			^false].
	^true!

errorBlockFor: aBoolean 
	^aBoolean
		ifTrue: [nil]
		ifFalse: 
			[failed == #leftFailed ifTrue: [left errorBlock] ifFalse: [right errorBlock]]!

errorMacro
	^errorMacro isNil
		ifTrue: [self longMacro]
		ifFalse: [super errorMacro]!

errorStringFor: aBoolean 
	^aBoolean
		ifTrue: [self neitherFailed]
		ifFalse: [self perform: failed]!

left: aCondition right: aCondition2 
	left := aCondition.
	right := aCondition2.
	failed := #unknownFailed!

leftFailed
	^left errorStringFor: false!

longMacro
	^'(' , left errorMacro , ') <1?AND:OR> (' , right errorMacro , ')'!

neitherFailed
	^(left errorStringFor: true) , ' AND ' , (right errorStringFor: true)!

printOn: aStream 
	aStream print: left;
		nextPutAll: ' & ';
		print: right!

rightFailed
	^right errorStringFor: false!

unknownFailed
	^(left errorStringFor: false) , ' OR ' , (right errorStringFor: false)! !
!RBConjunctiveCondition categoriesFor: #check!checking!public! !
!RBConjunctiveCondition categoriesFor: #errorBlockFor:!private! !
!RBConjunctiveCondition categoriesFor: #errorMacro!private! !
!RBConjunctiveCondition categoriesFor: #errorStringFor:!private! !
!RBConjunctiveCondition categoriesFor: #left:right:!initialize/release!public! !
!RBConjunctiveCondition categoriesFor: #leftFailed!private! !
!RBConjunctiveCondition categoriesFor: #longMacro!private! !
!RBConjunctiveCondition categoriesFor: #neitherFailed!private! !
!RBConjunctiveCondition categoriesFor: #printOn:!printing!public! !
!RBConjunctiveCondition categoriesFor: #rightFailed!private! !
!RBConjunctiveCondition categoriesFor: #unknownFailed!private! !

