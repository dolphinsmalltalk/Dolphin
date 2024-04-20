"Filed out from Dolphin Smalltalk"!

UI.CreateWindowFunction
	subclass: #'UI.CreateWindowDecorator'
	instanceVariableNames: 'decorated'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CreateWindowDecorator guid: (Core.GUID fromString: '{9f663f08-1e15-4156-afcd-ae3057aec8db}')!

UI.CreateWindowDecorator isNonInstantiable: true!

UI.CreateWindowDecorator comment: ''!

!UI.CreateWindowDecorator categoriesForClass!Kernel-Objects! !

!UI.CreateWindowDecorator methodsFor!

decorated
	^decorated!

decorated: aCreateWindowFunction
	decorated := aCreateWindowFunction!

dpi
	^decorated dpi!

rectangle
	"Answer the <rectangle> specifying the position and extent of the window that will be created."

	^decorated rectangle!

rectangle: aRectangle dpi: anInteger
	"Set the <rectangle> specifying the position and extent of the window that will be created, and the dpi in which the pixel co-ordinates that it contains are measured."

	decorated rectangle: aRectangle dpi: anInteger! !

!UI.CreateWindowDecorator categoriesForMethods!
decorated!accessing!private! !
decorated:!accessing!private! !
dpi!public! !
rectangle!public! !
rectangle:dpi:!accessing!public! !
!

!UI.CreateWindowDecorator class methodsFor!

decorating: aCreateWindow
	<primitive: 157>
	^self new decorated: aCreateWindow! !

!UI.CreateWindowDecorator class categoriesForMethods!
decorating:!public! !
!

