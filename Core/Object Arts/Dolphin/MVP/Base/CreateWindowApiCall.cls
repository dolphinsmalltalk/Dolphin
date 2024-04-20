"Filed out from Dolphin Smalltalk"!

CreateWindowFunction subclass: #CreateWindowApiCall
	instanceVariableNames: 'rectangle dpi'
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

CreateWindowApiCall guid: (GUID fromString: '{ac6f6c50-dda6-44d8-9fba-d1bb96fb4951}')!

CreateWindowApiCall isAbstract: true!

CreateWindowApiCall comment: ''!

!CreateWindowApiCall categoriesForClass!Kernel-Objects! !

!CreateWindowApiCall methodsFor!

dpi
	"Answer the <integer> logical dots-per-inch at which the <rectangle> stored in the receiver is measured."

	^dpi!

dpi: anInteger
	dpi := anInteger!

extent: aPoint
	"Set the width and height of the window to be created to the x and y co-ordinates, respectively, of the <point> argument, without changing its position. Co-ordinates are assumed to be measured at the receiver's dpi."

	rectangle extent: aPoint!

position: aPoint
	"Set the position (top-left corner) of the window to be created to the x and y co-ordinates, respectively, of the <point> argument, without changing the receiver's extent. Coordinates are pixel positions at the receiver's dpi."

	rectangle position: aPoint!

printOn: aStream
	aStream
		basicPrint: self;
		print: self rectangle;
		nextPutAll: ' dpi: ';
		print: dpi;
		nextPut: $)!

rectangle
	"Answer the <rectangle> specifying the position and extent of the window that will be created."

	^rectangle!

rectangle: aRectangle dpi: anInteger
	"Set the <rectangle> specifying the position and extent of the window that will be created, and the dpi in which the pixel co-ordinates that it contains are measured."

	rectangle := RECT marshal: aRectangle.
	dpi := anInteger! !

!CreateWindowApiCall categoriesForMethods!
dpi!accessing!high DPI!public! !
dpi:!accessing!public! !
extent:!accessing!public! !
position:!accessing!public! !
printOn:!printing!public! !
rectangle!accessing!public! !
rectangle:dpi:!accessing!public! !
!

