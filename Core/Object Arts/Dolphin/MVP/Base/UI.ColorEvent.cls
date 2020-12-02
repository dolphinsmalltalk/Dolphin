"Filed out from Dolphin Smalltalk 7"!

WindowsEvent subclass: #ColorEvent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ColorEvent guid: (GUID fromString: '{87b4c54c-026e-11d3-9fd7-00a0cc3e4a32}')!
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

