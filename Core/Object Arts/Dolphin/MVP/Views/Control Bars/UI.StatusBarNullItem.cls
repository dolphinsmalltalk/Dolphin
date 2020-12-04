"Filed out from Dolphin Smalltalk 7"!

UI.StatusBarItemAbstract subclass: #'UI.StatusBarNullItem'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.StatusBarNullItem guid: (Core.GUID fromString: '{23883cbe-a382-483d-a712-4b5320f87928}')!
UI.StatusBarNullItem comment: 'StatusBarNullItem is a class of status bar items that occupy space, but are otherwise invisible.
'!
!UI.StatusBarNullItem categoriesForClass!MVP-Views-Support! !
!UI.StatusBarNullItem methodsFor!

drawItem: aCanvas bounding: boundingRectangle 
	"Private - A request to draw the receiver. As we are just a placeholder, we do nothing."

	! !
!UI.StatusBarNullItem categoriesFor: #drawItem:bounding:!drawing!private! !

