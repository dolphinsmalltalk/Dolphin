"Filed out from Dolphin Smalltalk"!

Refactory.Browser.SharedVariableChange subclass: #'Refactory.Browser.AddSharedVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddSharedVariableChange guid: (Core.GUID fromString: '{2c271662-7065-4aeb-b1ab-1312d4674e99}')!
Refactory.Browser.AddSharedVariableChange comment: '`AddSharedVariableChange` is a Dolphin specific `RefactoryChange` that defines a shared variable in a namespace, initialising it to nil.'!
!Refactory.Browser.AddSharedVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.AddSharedVariableChange methodsFor!

asUndoOperation
	^RemoveSharedVariableChange removeSharedVariable: variable from: environmentName!

changeString
	^'Define Shared Variable <1d>.<2s>' << {environmentName. variable}!

primitiveExecute
	self environment declareVariable: variable! !
!Refactory.Browser.AddSharedVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
primitiveExecute!applying!private! !
!

!Refactory.Browser.AddSharedVariableChange class methodsFor!

addSharedVariable: aString to: aNamespace
	^self new setVariable: aString environment: aNamespace! !
!Refactory.Browser.AddSharedVariableChange class categoriesForMethods!
addSharedVariable:to:!instance creation!public! !
!

