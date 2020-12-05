"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.DolphinGlobalChange subclass: #'Refactory.Browser.DolphinRemoveGlobalChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.DolphinRemoveGlobalChange guid: (Core.GUID fromString: '{b031ef44-3901-49ad-9be0-eb7ce796f79e}')!
Refactory.Browser.DolphinRemoveGlobalChange comment: 'DolphinRemoveGlobalChange is a Dolphin specific <RefactoryChange> that removes a global variable from the system dictionary'!
!Refactory.Browser.DolphinRemoveGlobalChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.DolphinRemoveGlobalChange methodsFor!

asUndoOperation
	^DolphinAddGlobalChange addGlobal: variable!

changeString
	^'Remove global <1p>' expandMacrosWith: variable asString!

primitiveExecute
	#namespaceToDo.	"Need to remember the environment as well so we can remove from the correct namespace."
	Smalltalk removeKey: variable! !
!Refactory.Browser.DolphinRemoveGlobalChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.DolphinRemoveGlobalChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.DolphinRemoveGlobalChange categoriesFor: #primitiveExecute!private! !

!Refactory.Browser.DolphinRemoveGlobalChange class methodsFor!

removeGlobal: aVariable 
	^(self new)
		variable: aVariable;
		yourself! !
!Refactory.Browser.DolphinRemoveGlobalChange class categoriesFor: #removeGlobal:!instance creation!public! !

