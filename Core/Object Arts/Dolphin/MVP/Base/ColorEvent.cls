"Filed out from Dolphin Smalltalk X6"!

WindowsEvent subclass: #ColorEvent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ColorEvent guid: (GUID fromString: '{87B4C54C-026E-11D3-9FD7-00A0CC3E4A32}')!
ColorEvent comment: ''!
!ColorEvent categoriesForClass!MVP-Views-Events! !
!ColorEvent methodsFor!

canvas
	"Answer the canvas to setup for the color"

	^Canvas withNonOwnedDC: self wParam.!

hdc
	^self wParam! !
!ColorEvent categoriesFor: #canvas!accessing!public! !
!ColorEvent categoriesFor: #hdc!accessing!public! !

