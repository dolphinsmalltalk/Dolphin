"Filed out from Dolphin Smalltalk 7"!

StatusBarItemAbstract subclass: #StatusBarNullItem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StatusBarNullItem guid: (GUID fromString: '{23883cbe-a382-483d-a712-4b5320f87928}')!
StatusBarNullItem comment: 'StatusBarNullItem is a class of status bar items that occupy space, but are otherwise invisible.
'!
!StatusBarNullItem categoriesForClass!MVP-Views-Support! !
!StatusBarNullItem methodsFor!

drawItem: aCanvas bounding: boundingRectangle 
	"Private - A request to draw the receiver. As we are just a placeholder, we do nothing."

	! !
!StatusBarNullItem categoriesFor: #drawItem:bounding:!drawing!private! !

