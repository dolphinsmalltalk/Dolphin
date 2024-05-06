"Filed out from Dolphin Smalltalk"!

DolphinGlobalChange subclass: #DolphinAddGlobalChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinAddGlobalChange guid: (GUID fromString: '{2c271662-7065-4aeb-b1ab-1312d4674e99}')!

DolphinAddGlobalChange comment: 'DolphinAddGlobalChange is a Dolphin specific <RefactoryChange> that defines a global variable, initialising it to nil.'!

!DolphinAddGlobalChange categoriesForClass!Refactory-Change Objects! !

!DolphinAddGlobalChange methodsFor!

asUndoOperation
	^DolphinRemoveGlobalChange removeGlobal: variable!

changeString
	^'Define global <1p>' expandMacrosWith: variable asString!

primitiveExecute
	Smalltalk at: variable put: nil! !

!DolphinAddGlobalChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
primitiveExecute!private! !
!

!DolphinAddGlobalChange class methodsFor!

addGlobal: aVariable 
	^(self new)
		variable: aVariable;
		yourself! !

!DolphinAddGlobalChange class categoriesForMethods!
addGlobal:!instance creation!public! !
!

