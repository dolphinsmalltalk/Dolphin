"Filed out from Dolphin Smalltalk X6"!

StatusBarItemAbstract subclass: #StatusBarNullItem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StatusBarNullItem guid: (GUID fromString: '{23883CBE-A382-483D-A712-4B5320F87928}')!
StatusBarNullItem comment: 'StatusBarNullItem is a class of status bar items that occupy space, but are otherwise invisible.
'!
!StatusBarNullItem categoriesForClass!MVP-Views-Support! !
!StatusBarNullItem methodsFor!

drawItem: aCanvas bounding: boundingRectangle 
	"Private - A request to draw the receiver. As we are just a placeholder, we do nothing."

	! !
!StatusBarNullItem categoriesFor: #drawItem:bounding:!drawing!private! !

