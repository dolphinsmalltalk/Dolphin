"Filed out from Dolphin Smalltalk"!

Refactory.Browser.SharedVariableChange
	subclass: #'Refactory.Browser.RemoveSharedVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RemoveSharedVariableChange guid: (Core.GUID fromString: '{b031ef44-3901-49ad-9be0-eb7ce796f79e}')!

Refactory.Browser.RemoveSharedVariableChange comment: '`RemoveSharedVariableChange` is a Dolphin specific `RefactoryChange` that removes a shared variable from a namespace'!

!Refactory.Browser.RemoveSharedVariableChange categoriesForClass!Refactory-Change Objects! !

!Refactory.Browser.RemoveSharedVariableChange methodsFor!

asUndoOperation
	^AddSharedVariableChange addSharedVariable: variable to: environmentName!

changeString
	^'Remove Shared Variable <1d>.<2s>' << {environmentName. variable}!

primitiveExecute
	self environment removeBindingFor: variable! !

!Refactory.Browser.RemoveSharedVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
primitiveExecute!applying!private! !
!

!Refactory.Browser.RemoveSharedVariableChange class methodsFor!

removeSharedVariable: aVariable from: aNamespace
	^self new setVariable: aVariable environment: aNamespace! !

!Refactory.Browser.RemoveSharedVariableChange class categoriesForMethods!
removeSharedVariable:from:!instance creation!public! !
!

