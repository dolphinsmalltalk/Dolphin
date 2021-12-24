"Filed out from Dolphin Smalltalk"!

Tools.SharedVariableChange subclass: #'Tools.AddSharedVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AddSharedVariableChange guid: (Core.GUID fromString: '{2c271662-7065-4aeb-b1ab-1312d4674e99}')!
Tools.AddSharedVariableChange comment: '`AddSharedVariableChange` is a Dolphin specific `RefactoryChange` that defines a shared variable in a namespace, initialising it to nil.'!
!Tools.AddSharedVariableChange categoriesForClass!Refactory-Change Objects! !
!Tools.AddSharedVariableChange methodsFor!

asUndoOperation
	^RemoveSharedVariableChange removeSharedVariable: variable from: environmentName!

changeString
	^'Define Shared Variable <1d>.<2s>' expandMacrosWith: environmentName with: variable!

primitiveExecute
	self environment declareVariable: variable! !
!Tools.AddSharedVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
primitiveExecute!applying!private! !
!

!Tools.AddSharedVariableChange class methodsFor!

addSharedVariable: aString to: aNamespace
	^self new setVariable: aString environment: aNamespace! !
!Tools.AddSharedVariableChange class categoriesForMethods!
addSharedVariable:to:!instance creation!public! !
!

