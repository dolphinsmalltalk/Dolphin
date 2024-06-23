"Filed out from Dolphin Smalltalk"!

Core.Error
	subclass: #'Core.BoundsError'
	instanceVariableNames: 'receiver'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.BoundsError guid: (Core.GUID fromString: '{87b4c558-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.BoundsError comment: ''!

!Core.BoundsError categoriesForClass!Kernel-Exception Handling! !

!Core.BoundsError methodsFor!

_descriptionFormat
	"Answer the description format string for the receiver."

	^'Index %2 is out of bounds'!

receiver
	"Answer the object which generated the bounds error."
	
	^receiver!

receiver: anObject index: anInteger
	receiver := anObject.
	tag := anInteger! !

!Core.BoundsError categoriesForMethods!
_descriptionFormat!displaying!public! !
receiver!accessing!public! !
receiver:index:!accessing!initializing!private! !
!

!Core.BoundsError class methodsFor!

receiver: anObject index: anInteger
	"Raise a new instance of the receiver reporting that out-of-bounds indexed access was attempted to the indexed element, anInteger, of the <object>, anObject."

	^self basicNew
		receiver: anObject index: anInteger;
		signal! !

!Core.BoundsError class categoriesForMethods!
receiver:index:!instance creation!public! !
!

