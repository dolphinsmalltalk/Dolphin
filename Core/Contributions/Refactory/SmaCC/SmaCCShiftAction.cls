"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

SmaCCAction subclass: #SmaCCShiftAction
	instanceVariableNames: ''
	classVariableNames: 'Shift'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCShiftAction guid: (GUID fromString: '{E25B2CA0-131B-4C26-A394-513FBA923997}')!
SmaCCShiftAction comment: 'SmaCCShiftAction represents a shift action in the parser''s tables.'!
!SmaCCShiftAction categoriesForClass!SmaCC Runtime! !
!SmaCCShiftAction methodsFor!

id
	^2r01!

isShift
	^true! !
!SmaCCShiftAction categoriesFor: #id!accessing!public! !
!SmaCCShiftAction categoriesFor: #isShift!public!testing! !

!SmaCCShiftAction class methodsFor!

initialize
	Shift := self basicNew!

new
	^Shift!

releaseObjects
	Shift := nil!

uninitialize
	Shift := nil! !
!SmaCCShiftAction class categoriesFor: #initialize!class initialization!public! !
!SmaCCShiftAction class categoriesFor: #new!instance creation!public! !
!SmaCCShiftAction class categoriesFor: #releaseObjects!class initialization!public! !
!SmaCCShiftAction class categoriesFor: #uninitialize!class hierarchy-removing!public! !

