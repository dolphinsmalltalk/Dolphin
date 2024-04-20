"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.CreateWindowFunction'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: { 'UseDefaultGeometry' -> (-16r80000000 @ -16r80000000) }!

UI.CreateWindowFunction guid: (Core.GUID fromString: '{4452c723-d081-4053-b0bf-7660d58cbf74}')!

UI.CreateWindowFunction isNonInstantiable: true!

UI.CreateWindowFunction comment: ''!

!UI.CreateWindowFunction categoriesForClass!Kernel-Objects! !

!UI.CreateWindowFunction methodsFor!

create: aView
	"Create a native window for the <View> argument."

	^self subclassResponsibility!

dpi
	"Answer the <integer> logical dots-per-inch at which the <rectangle> stored in the receiver is measured."

	^self subclassResponsibility!

extent
	"Answer a <point> expressing the width and height of the window to be created. These are measured at the receiver's DPI."

	^self rectangle extent!

hasDefaultExtent
	"Answer whether the window should be created at the default extent determined by Windows, or if not a top-level window an extent yet to be determined."

	^self extent = UseDefaultGeometry!

hasDefaultPosition
	"Answer whether the window should be created at the default position for the parent, or if not a top-level window a position yet to be determined."

	^self position = UseDefaultGeometry!

position
	"Answer a <point> expressing the position (top-left corner) of the window to be created. The position is measured at the receiver's DPI."

	^self rectangle origin!

position: positionPoint extent: extentPoint dpi: anInteger
	"Set the position and extent of the window that will be created, and the dpi in which the pixel co-ordinates that it contains are measured."

	self rectangle: (RECTL origin: positionPoint extent: extentPoint) dpi: anInteger!

rectangle
	"Answer the <rectangle> specifying the position and extent of the window that will be created."

	^self subclassResponsibility!

rectangle: aRectangle dpi: anInteger
	"Set the <rectangle> specifying the position and extent of the window that will be created, and the dpi in which the pixel co-ordinates that it contains are measured."

	self subclassResponsibility!

scaleToDpi: anInteger
	"Scale the receiver in-place by the specified <Point> or <Number> multiplier. Note that the receiver should not be scaled multiple times, as rounding error may accumulate. The intent is that the receiver be scaled once for DPI, if required."

	"Note that we scale the rectangle corners rather than origin and extent as this is what Windows DWM appears to do:
		rect := (10@10 extent: 183@19) scaledBy: 1.25.
		rect truncated extent	=> 229@24
		rect extent truncated	=> 228@23"

	self rectangle: (self rectangle scaleToDpi: anInteger from: self dpi) dpi: anInteger! !

!UI.CreateWindowFunction categoriesForMethods!
create:!operations!public! !
dpi!accessing!high DPI!public! !
extent!accessing!public! !
hasDefaultExtent!accessing!public! !
hasDefaultPosition!accessing!public! !
position!accessing!public! !
position:extent:dpi:!accessing!public! !
rectangle!accessing!public! !
rectangle:dpi:!accessing!public! !
scaleToDpi:!accessing!public! !
!

!UI.CreateWindowFunction class methodsFor!

initialize
	self addClassConstant: 'UseDefaultGeometry' value: CW_USEDEFAULT @ CW_USEDEFAULT! !

!UI.CreateWindowFunction class categoriesForMethods!
initialize!public! !
!

