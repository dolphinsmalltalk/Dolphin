"Filed out from Dolphin Smalltalk"!

WindowsEvent subclass: #DpiChangedEvent
	instanceVariableNames: 'currentDpi'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DpiChangedEvent guid: (GUID fromString: '{8350389b-9de4-473a-9927-a183da987fca}')!

DpiChangedEvent comment: ''!

!DpiChangedEvent categoriesForClass!MVP-Views-Events! !

!DpiChangedEvent methodsFor!

currentDpi
	^currentDpi!

currentDpi: anInteger
	currentDpi := anInteger!

newDpi
	^self wParam lowWord!

printOn: aStream
	"Append a textual representation of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: self window;
		nextPutAll: ' currentDpi: ';
		print: self currentDpi;
		nextPutAll: ' newDpi: ';
		print: self newDpi;
		nextPutAll: ' proposedRect: ';
		print: self proposedRect;
		nextPut: $)!

proposedRect
	^RECTL fromAddress: self lParam! !

!DpiChangedEvent categoriesForMethods!
currentDpi!accessing!public! !
currentDpi:!accessing!initializing!private! !
newDpi!event handling-win32!private! !
printOn:!development!printing!public! !
proposedRect!event handling-win32!private! !
!

