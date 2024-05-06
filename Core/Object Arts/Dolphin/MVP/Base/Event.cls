"Filed out from Dolphin Smalltalk"!

Object subclass: #Event
	instanceVariableNames: 'window'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Event guid: (GUID fromString: '{04134010-906c-40dd-b5e7-7f26e4216aa0}')!

Event comment: ''!

!Event categoriesForClass!Kernel-Objects! !

!Event methodsFor!

hwnd
	^window asParameter!

setSource: aWindow
	window := aWindow!

window
	"Answers a window which was the target for this event. This window
	must be a registered Dolphin window."

	^window! !

!Event categoriesForMethods!
hwnd!accessing!private! !
setSource:!initializing!private! !
window!accessing!public! !
!

!Event class methodsFor!

forSource: aWindow
	^(self basicNew)
		setSource: aWindow;
		yourself!

icon
	"Answers an Icon that can be used to represent this class."

	^##(self) defaultIcon! !

!Event class categoriesForMethods!
forSource:!instance creation!public! !
icon!constants!public! !
!

