"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.ProceedValue'
	instanceVariableNames: 'value canCancel'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.ProceedValue guid: (Core.GUID fromString: '{8d7650bc-6192-416e-8279-c75712a841b8}')!

Core.ProceedValue comment: ''!

!Core.ProceedValue methodsFor!

initialize
	canCancel := value := true!

isCancellable
	^canCancel!

isCancellable: aBoolean
	canCancel := aBoolean!

value
	^value!

value: aBooleanOrNil
	value := aBooleanOrNil! !

!Core.ProceedValue categoriesForMethods!
initialize!initializing!public! !
isCancellable!accessing!public! !
isCancellable:!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
!

!Core.ProceedValue class methodsFor!

new
	^self basicNew initialize! !

!Core.ProceedValue class categoriesForMethods!
new!public! !
!

