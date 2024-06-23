"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Event'
	instanceVariableNames: 'window'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Event guid: (Core.GUID fromString: '{04134010-906c-40dd-b5e7-7f26e4216aa0}')!

UI.Event comment: ''!

!UI.Event categoriesForClass!Kernel-Objects! !

!UI.Event methodsFor!

hwnd
	^window asParameter!

setSource: aWindow
	window := aWindow!

window
	"Answers a window which was the target for this event. This window
	must be a registered Dolphin window."

	^window! !

!UI.Event categoriesForMethods!
hwnd!accessing!private! !
setSource:!initializing!private! !
window!accessing!public! !
!

!UI.Event class methodsFor!

forSource: aWindow
	^(self basicNew)
		setSource: aWindow;
		yourself!

icon
	"Answers an Icon that can be used to represent this class."

	^##(self) defaultIcon! !

!UI.Event class categoriesForMethods!
forSource:!instance creation!public! !
icon!constants!public! !
!

