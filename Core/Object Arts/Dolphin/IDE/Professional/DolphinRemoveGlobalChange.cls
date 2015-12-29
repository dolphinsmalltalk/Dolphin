"Filed out from Dolphin Smalltalk X6"!

DolphinGlobalChange subclass: #DolphinRemoveGlobalChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinRemoveGlobalChange guid: (GUID fromString: '{B031EF44-3901-49AD-9BE0-EB7CE796F79E}')!
DolphinRemoveGlobalChange comment: 'DolphinRemoveGlobalChange is a Dolphin specific <RefactoryChange> that removes a global variable from the system dictionary'!
!DolphinRemoveGlobalChange categoriesForClass!Refactory-Change Objects! !
!DolphinRemoveGlobalChange methodsFor!

asUndoOperation
	^DolphinAddGlobalChange addGlobal: variable!

changeString
	^'Remove global <1p>' expandMacrosWith: variable asString!

primitiveExecute
	Smalltalk removeKey: variable! !
!DolphinRemoveGlobalChange categoriesFor: #asUndoOperation!converting!public! !
!DolphinRemoveGlobalChange categoriesFor: #changeString!printing!public! !
!DolphinRemoveGlobalChange categoriesFor: #primitiveExecute!private! !

!DolphinRemoveGlobalChange class methodsFor!

removeGlobal: aVariable 
	^(self new)
		variable: aVariable;
		yourself! !
!DolphinRemoveGlobalChange class categoriesFor: #removeGlobal:!instance creation!public! !

