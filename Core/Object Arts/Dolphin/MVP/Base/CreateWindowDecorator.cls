﻿"Filed out from Dolphin Smalltalk"!

CreateWindowFunction subclass: #CreateWindowDecorator
	instanceVariableNames: 'decorated'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CreateWindowDecorator guid: (GUID fromString: '{9f663f08-1e15-4156-afcd-ae3057aec8db}')!

CreateWindowDecorator isAbstract: true!

CreateWindowDecorator comment: ''!

!CreateWindowDecorator categoriesForClass!Kernel-Objects! !

!CreateWindowDecorator methodsFor!

createShellWindow: aShellView
	decorated createShellWindow: aShellView!

decorated
	^decorated!

decorated: aCreateWindowFunction
	decorated := aCreateWindowFunction!

dpi
	"Answer the <integer> logical dots-per-inch at which the <rectangle> of the receiver is measured."

	^decorated dpi!

dpi: anInteger
	"Set the <integer> logical dots-per-inch at which the <rectangle> of the receiver is measured."

	decorated dpi: anInteger!

position: positionPoint extent: extentPoint dpi: anInteger
	"Set the position and extent of the window that will be created, and the dpi in which the pixel co-ordinates that it contains are measured."

	decorated position: positionPoint extent: extentPoint dpi: anInteger!

rectangle
	"Answer the <rectangle> specifying the position and extent of the window that will be created."

	^decorated rectangle!

scaleToDpi: anInteger
	"Private - Scale the receiver in-place from it's current DPI to that specified by the <SmallInteger> argument."

	decorated scaleToDpi: anInteger! !

!CreateWindowDecorator categoriesForMethods!
createShellWindow:!operations!public! !
decorated!accessing!private! !
decorated:!accessing!private! !
dpi!accessing!public! !
dpi:!accessing!public! !
position:extent:dpi:!initializing!public! !
rectangle!accessing!public! !
scaleToDpi:!helpers!high DPI!private! !
!

!CreateWindowDecorator class methodsFor!

decorating: aCreateWindow
	<primitive: 157>
	^self new decorated: aCreateWindow! !

!CreateWindowDecorator class categoriesForMethods!
decorating:!instance creation!public! !
!
