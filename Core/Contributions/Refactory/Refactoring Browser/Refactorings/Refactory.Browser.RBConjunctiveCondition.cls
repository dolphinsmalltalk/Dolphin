"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RBAbstractCondition
	subclass: #'Refactory.Browser.RBConjunctiveCondition'
	instanceVariableNames: 'left right failed'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RBConjunctiveCondition guid: (Core.GUID fromString: '{a39b3587-7d58-4929-b47c-00c804e537be}')!

Refactory.Browser.RBConjunctiveCondition comment: 'ConjunctiveCondition represents and-ing two AbstractConditions together.

Instance Variables:
	failed	<Symbol>	which condition failed (#leftFailed, #rightFailed, or #unknownFailed)
	left	<AbstractCondition>	the condition on the left side of the and
	right	<AbstractCondition>	the condition on the right side of the and'!

!Refactory.Browser.RBConjunctiveCondition categoriesForClass!Refactory-Conditions! !

!Refactory.Browser.RBConjunctiveCondition methodsFor!

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

!Refactory.Browser.RBConjunctiveCondition categoriesForMethods!
check!checking!public! !
errorBlockFor:!private! !
errorMacro!private! !
errorStringFor:!private! !
left:right:!initialize/release!public! !
leftFailed!private! !
longMacro!private! !
neitherFailed!private! !
printOn:!printing!public! !
rightFailed!private! !
unknownFailed!private! !
!

