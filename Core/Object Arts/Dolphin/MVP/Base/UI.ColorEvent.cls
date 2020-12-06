"Filed out from Dolphin Smalltalk 7"!

UI.WindowsEvent subclass: #'UI.ColorEvent'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ColorEvent guid: (Core.GUID fromString: '{87b4c54c-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ColorEvent comment: ''!
!UI.ColorEvent categoriesForClass!MVP-Views-Events! !
!UI.ColorEvent methodsFor!

canvas
	"Answer the canvas to setup for the color"

	^Canvas withNonOwnedDC: self wParam.!

hdc
	^self wParam! !
!UI.ColorEvent categoriesFor: #canvas!accessing!public! !
!UI.ColorEvent categoriesFor: #hdc!accessing!public! !

