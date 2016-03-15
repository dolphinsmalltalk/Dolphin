"Filed out from Dolphin Smalltalk 7"!

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

	!

storeOn: aStream indent: anInteger variables: aDictionary

	aStream
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' separator: 0)'! !
!StatusBarNullItem categoriesFor: #drawItem:bounding:!drawing!private! !
!StatusBarNullItem categoriesFor: #storeOn:indent:variables:!printing!public! !

