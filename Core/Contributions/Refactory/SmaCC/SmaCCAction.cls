"Filed out from Dolphin Smalltalk XP"!

Object subclass: #SmaCCAction
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCAction guid: (GUID fromString: '{72E888FD-ECEF-4934-853B-034E6D320376}')!
SmaCCAction comment: 'SmaCCAction is an abstract class that represents an action in the LR parsing table.

Subclasses must implement the following messages:
	accessing
		id'!
!SmaCCAction categoriesForClass!SmaCC Runtime! !
!SmaCCAction methodsFor!

id
	^self subclassResponsibility!

isReduce
	^false!

isShift
	^false! !
!SmaCCAction categoriesFor: #id!accessing!public! !
!SmaCCAction categoriesFor: #isReduce!public!testing! !
!SmaCCAction categoriesFor: #isShift!public!testing! !

