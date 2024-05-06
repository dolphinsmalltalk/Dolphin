"Filed out from Dolphin Smalltalk"!

DolphinGlobalChange subclass: #DolphinRemoveGlobalChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DolphinRemoveGlobalChange guid: (GUID fromString: '{b031ef44-3901-49ad-9be0-eb7ce796f79e}')!

DolphinRemoveGlobalChange comment: 'DolphinRemoveGlobalChange is a Dolphin specific <RefactoryChange> that removes a global variable from the system dictionary'!

!DolphinRemoveGlobalChange categoriesForClass!Refactory-Change Objects! !

!DolphinRemoveGlobalChange methodsFor!

asUndoOperation
	^DolphinAddGlobalChange addGlobal: variable!

changeString
	^'Remove global <1p>' expandMacrosWith: variable asString!

primitiveExecute
	Smalltalk removeKey: variable! !

!DolphinRemoveGlobalChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
primitiveExecute!private! !
!

!DolphinRemoveGlobalChange class methodsFor!

removeGlobal: aVariable 
	^(self new)
		variable: aVariable;
		yourself! !

!DolphinRemoveGlobalChange class categoriesForMethods!
removeGlobal:!instance creation!public! !
!

