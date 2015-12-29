"Filed out from Dolphin Smalltalk X6"!

Object subclass: #Event
	instanceVariableNames: 'hWnd'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Event guid: (GUID fromString: '{04134010-906C-40DD-B5E7-7F26E4216AA0}')!
Event comment: ''!
!Event categoriesForClass!Kernel-Objects! !
!Event methodsFor!

setSource: aWindow
	hWnd := aWindow asParameter!

window
	"Answers a window which was the target for this event. This window
	must be a registered Dolphin window."

	^SessionManager inputState windowAt: hWnd ifAbsent: []! !
!Event categoriesFor: #setSource:!initializing!private! !
!Event categoriesFor: #window!accessing!public! !

!Event class methodsFor!

forSource: aWindow
	^(self basicNew)
		setSource: aWindow;
		yourself! !
!Event class categoriesFor: #forSource:!instance creation!public! !

