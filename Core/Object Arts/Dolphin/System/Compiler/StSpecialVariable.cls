"Filed out from Dolphin Smalltalk 7"!

StVariable subclass: #StSpecialVariable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StSpecialVariable guid: (GUID fromString: '{83bccab3-8ad0-4dbb-bbf0-dba008295503}')!
StSpecialVariable comment: ''!
!StSpecialVariable categoriesForClass!Kernel-Objects! !
!StSpecialVariable methodsFor!

addWrite: anStVariableNode
	self error: 'Cannot assign to pseudo-variables'!

isConstant
	^true!

isWritten
	^false! !
!StSpecialVariable categoriesFor: #addWrite:!public! !
!StSpecialVariable categoriesFor: #isConstant!public!testing! !
!StSpecialVariable categoriesFor: #isWritten!public!testing! !

