"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.DolphinGlobalChange subclass: #'Refactory.Browser.DolphinAddGlobalChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.DolphinAddGlobalChange guid: (Core.GUID fromString: '{2c271662-7065-4aeb-b1ab-1312d4674e99}')!
Refactory.Browser.DolphinAddGlobalChange comment: 'DolphinAddGlobalChange is a Dolphin specific <RefactoryChange> that defines a global variable, initialising it to nil.'!
!Refactory.Browser.DolphinAddGlobalChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.DolphinAddGlobalChange methodsFor!

asUndoOperation
	^DolphinRemoveGlobalChange removeGlobal: variable!

changeString
	^'Define global <1p>' expandMacrosWith: variable asString!

primitiveExecute
	Smalltalk at: variable put: nil! !
!Refactory.Browser.DolphinAddGlobalChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.DolphinAddGlobalChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.DolphinAddGlobalChange categoriesFor: #primitiveExecute!private! !

!Refactory.Browser.DolphinAddGlobalChange class methodsFor!

addGlobal: aVariable 
	^(self new)
		variable: aVariable;
		yourself! !
!Refactory.Browser.DolphinAddGlobalChange class categoriesFor: #addGlobal:!instance creation!public! !

