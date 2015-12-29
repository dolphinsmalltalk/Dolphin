"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RBAbstractCondition subclass: #RBConjunctiveCondition
	instanceVariableNames: 'left right failed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RBConjunctiveCondition comment: 'ConjunctiveCondition represents and-ing two AbstractConditions together.

Instance Variables:
	failed	<Symbol>	which condition failed (#leftFailed, #rightFailed, or #unknownFailed)
	left	<AbstractCondition>	the condition on the left side of the and
	right	<AbstractCondition>	the condition on the right side of the and'!

RBConjunctiveCondition guid: (GUID fromString: '{A39B3587-7D58-4929-B47C-00C804E537BE}')!

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
!RBConjunctiveCondition categoriesFor: #errorBlockFor:!*-unclassified!private! !
!RBConjunctiveCondition categoriesFor: #errorMacro!*-unclassified!private! !
!RBConjunctiveCondition categoriesFor: #errorStringFor:!*-unclassified!private! !
!RBConjunctiveCondition categoriesFor: #left:right:!initialize/release!public! !
!RBConjunctiveCondition categoriesFor: #leftFailed!*-unclassified!private! !
!RBConjunctiveCondition categoriesFor: #longMacro!*-unclassified!private! !
!RBConjunctiveCondition categoriesFor: #neitherFailed!*-unclassified!private! !
!RBConjunctiveCondition categoriesFor: #printOn:!printing!public! !
!RBConjunctiveCondition categoriesFor: #rightFailed!*-unclassified!private! !
!RBConjunctiveCondition categoriesFor: #unknownFailed!*-unclassified!private! !

