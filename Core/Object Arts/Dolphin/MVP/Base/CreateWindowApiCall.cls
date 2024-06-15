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

createShellWindow: aShellView
	self resolveShellGeometry: aShellView.
	"Set the dpi of the shell to that of the monitor we think it is created on, and to which we have scaled the position/extent. This will mean that even if we made the wrong choice, and Windows thinks it is placed on another monitor, when it is moved between monitors it should at least rescale correctly. Note that we would at least need to clear any cached DPI, as otherwise the shell will keep getting rescaled from its original DPI. Basically the cached ShellView DPI needs to always be the same as the actual DPI, except during the per-monitor transition process when Windows is sending WM_DPICHANGED_BEFOREPARENT to all the children. In order for the children to rescale correctly, they need to know the DPI to which they were last scaled, which is the primary reason to cache the DPI in ShellView."
	aShellView
		dpi: dpi;
		basicCreateWindow: self!

dpi
	"Answer the <integer> logical dots-per-inch at which the <rectangle> of the receiver is measured."

	^dpi!

dpi: anInteger
	"Set the <integer> logical dots-per-inch at which the <rectangle> of the receiver is measured."

	dpi := anInteger!

extent: aPoint
	"Set the width and height of the window to be created to the x and y co-ordinates, respectively, of the <point> argument, without changing its position. Co-ordinates are assumed to be measured at the receiver's dpi."

	rectangle extent: aPoint!

position: aPoint
	"Set the position (top-left corner) of the window to be created to the x and y co-ordinates, respectively, of the <point> argument, without changing the receiver's extent. Coordinates are pixel positions at the receiver's dpi."

	rectangle position: aPoint!

position: positionPoint extent: extentPoint dpi: anInteger
	"Set the position and extent of the window that will be created, and the dpi in which the pixel co-ordinates that it contains are measured."

	rectangle := RECT origin: positionPoint extent: extentPoint.
	dpi := anInteger!

printOn: aStream
	aStream
		basicPrint: self;
		nextPut: $(;
		display: self rectangle;
		nextPutAll: ' dpi: ';
		print: dpi;
		nextPut: $)!

rectangle
	"Answer the <rectangle> specifying the position and extent of the window that will be created."

	^rectangle!

resolveShellGeometry: aShellView
	self subclassResponsibility!

scaleToDpi: anInteger
	"Private - Scale the receiver in-place from it's current DPI to that specified by the <SmallInteger> argument."

	"Note that we scale the rectangle corners rather than origin and extent as this is what Windows DWM appears to do:
		rect := (10@10 extent: 183@19) scaledBy: 1.25.
		rect truncated extent	=> 229@24
		rect extent truncated	=> 228@23"

	dpi == anInteger ifTrue: [^self].
	rectangle scaleToDpi: anInteger from: dpi.
	dpi := anInteger! !

!CreateWindowApiCall categoriesForMethods!
createShellWindow:!operations!public! !
dpi!accessing!public! !
dpi:!accessing!public! !
extent:!accessing!public! !
position:!accessing!public! !
position:extent:dpi:!initializing!public! !
printOn:!printing!public! !
rectangle!accessing!public! !
resolveShellGeometry:!operations!private! !
scaleToDpi:!helpers!high DPI!private! !
!

