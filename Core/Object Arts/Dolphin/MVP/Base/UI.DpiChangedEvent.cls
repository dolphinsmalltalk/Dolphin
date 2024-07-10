"Filed out from Dolphin Smalltalk"!

UI.WindowsEvent
	subclass: #'UI.DpiChangedEvent'
	instanceVariableNames: 'currentDpi'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.DpiChangedEvent guid: (Core.GUID fromString: '{8350389b-9de4-473a-9927-a183da987fca}')!

UI.DpiChangedEvent comment: ''!

!UI.DpiChangedEvent categoriesForClass!MVP-Views-Events! !

!UI.DpiChangedEvent methodsFor!

currentDpi
	^currentDpi!

currentDpi: anInteger
	currentDpi := anInteger!

newDpi
	^self wParam lowWord!

proposedRect
	^RECTL fromAddress: self lParam! !

!UI.DpiChangedEvent categoriesForMethods!
currentDpi!accessing!public! !
currentDpi:!accessing!initializing!private! !
newDpi!event handling-win32!private! !
proposedRect!event handling-win32!private! !
!

