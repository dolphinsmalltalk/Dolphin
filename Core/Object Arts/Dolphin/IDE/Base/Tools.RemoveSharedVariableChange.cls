"Filed out from Dolphin Smalltalk"!

Tools.SharedVariableChange subclass: #'Tools.RemoveSharedVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RemoveSharedVariableChange guid: (Core.GUID fromString: '{b031ef44-3901-49ad-9be0-eb7ce796f79e}')!
Tools.RemoveSharedVariableChange comment: '`RemoveSharedVariableChange` is a Dolphin specific `RefactoryChange` that removes a shared variable from a namespace'!
!Tools.RemoveSharedVariableChange categoriesForClass!Refactory-Change Objects! !
!Tools.RemoveSharedVariableChange methodsFor!

asUndoOperation
	^AddSharedVariableChange addSharedVariable: variable to: environmentName!

changeString
	^'Remove global <1p>' expandMacrosWith: variable asString!

primitiveExecute
	self environment removeBindingFor: variable! !
!Tools.RemoveSharedVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
primitiveExecute!applying!private! !
!

!Tools.RemoveSharedVariableChange class methodsFor!

removeSharedVariable: aVariable from: aNamespace
	^self new setVariable: aVariable environment: aNamespace! !
!Tools.RemoveSharedVariableChange class categoriesForMethods!
removeSharedVariable:from:!instance creation!public! !
!

