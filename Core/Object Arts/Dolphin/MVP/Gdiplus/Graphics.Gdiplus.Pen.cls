"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase
	subclass: #'Graphics.Gdiplus.Pen'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Pen guid: (Core.GUID fromString: '{f98f70c8-58ea-4592-bc70-1907f78c8bc8}')!
Graphics.Gdiplus.Pen comment: 'GdiplusPen is used to draw lines and curves.  In general, where an object has an outside and an inside, GdiplusPen draws the outside and GdiplusBrush is used to fill the inside.'!
!Graphics.Gdiplus.Pen methodsFor!

alignment
	"Answer the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	^initializer alignment!

alignment: aPenAlignmentConstant
	"Set the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	initializer alignmentOf: self set: aPenAlignmentConstant!

beCentered
	self alignment: PenAlignmentCenter!

beInset
	self alignment: PenAlignmentInset!

brush
	"Answer the receiver's brush, used when drawing a line."

	^initializer brushOf: self!

brush: aGdiplusBrush
	"Set the receiver to use aGdiplusBrush when drawing a line."

	initializer brushOf: self set: aGdiplusBrush!

clone
	"Answer a copy of the receiver."

	"The attributes of Pens cannot all be queried through the GDI+ API in all cases (given that Pen's can be based on TransformableBrushes that we cannot rebuild from a handle), so we cannot populate an initializer from the handle. Consequently we must copy over the initializer."

	^super clone
		initializer: initializer copy;
		yourself!

color
	"Answer the <Color> of the receiver's ink."

	^initializer color!

color: aColor
	"Set the receiver's drawing color to the <Color> argument."

	initializer colorOf: self set: aColor!

compoundArray
	^initializer compoundArray!

compoundArray: aRealArray
	initializer compoundArrayOf: self set: aRealArray!

customEndCap
	^initializer customEndCap!

customEndCap: aGdiplusCustomLineCap
	initializer customEndCapOf: self set: aGdiplusCustomLineCap!

customStartCap
	^initializer customStartCap!

customStartCap: aGdiplusCustomLineCap
	initializer customStartCapOf: self set: aGdiplusCustomLineCap!

dashCap
	^initializer dashCap!

dashCap: aDashCapConstant
	"Set the dash cap of the receiver."

	initializer dashCapOf: self set: aDashCapConstant!

dashPattern
	"Answer an array of custom dashes and spaces for the receiver."

	^initializer dashPattern!

dashPattern: anArray
	"Set an array of custom dashes and spaces for the receiver."

	initializer dashPatternOf: self set: anArray!

dashStyle
	^initializer dashStyle!

dashStyle: aDashStyleConstant
	"Set the dash style of the receiver."

	initializer dashStyleOf: self set: aDashStyleConstant!

endCap
	^initializer endCap!

endCap: aLineCapConstant
	initializer endCapOf: self set: aLineCapConstant!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^PenInitializer!

ink
	^initializer ink!

lineCap: startCap endCap: endCap dashCap: dashCap
	initializer
		capsOf: self
		setLineCap: startCap
		endCap: endCap
		dashCap: dashCap!

lineJoin
	^initializer lineJoin!

lineJoin: aLineJoinConstant
	initializer lineJoinOf: self set: aLineJoinConstant!

multiply: aMatrix
	"Set the receiver's world transform to the product of itself and the <Matrix> argument."

	self multiply: aMatrix order: MatrixOrderPrepend!

multiply: aMatrix order: aMatrixOrderConstant
	"Set the receiver's world transform to the product of itself and the <Matrix> 1st argument, with the order of transformation specified by MatrixOrder <integer> 2nd argument."

	initializer
		transform: self
		multiply: aMatrix
		order: aMatrixOrderConstant!

resetTransform
	"Reset the receiver's world transform to the identity matrix (i.e. no transformation)."

	initializer resetTransformOf: self!

rotate: aNumber
	"Prepend a rotation to the receiver's world transform by the <Number> angle in degrees argument."

	self rotate: aNumber order: MatrixOrderPrepend!

rotate: aNumber order: aMatrixOrderConstant
	"Rotate the receiver's world transform by the <Number> angle in degrees 1st argument, with the order of transformation specified by MatrixOrder <integer> 2nd argument."

	initializer
		transform: self
		rotate: aNumber asFloat
		order: aMatrixOrderConstant!

rotateTransform: aRealAngle
	#deprecated.
	self rotate: aRealAngle!

rotateTransform: aNumber order: aMatrixOrderConstant
	#deprecated.
	self rotate: aNumber order: aMatrixOrderConstant!

scale: aPoint
	"Prepend a scaling transformation to the receiver's transformation matrix of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self scale: aPoint order: MatrixOrderPrepend!

scale: aPoint order: aMatrixOrderConstant
	"Scale the receiver's world transform by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> 1st argument, with the order of transformation specified by the <integer> MatrixOrder 2nd argument."

	initializer
		transform: self
		scale: aPoint
		order: aMatrixOrderConstant!

scaleTransform: aPoint
	#deprecated.
	self scale: aPoint!

scaleTransform: aRealPoint order: aMatrixOrderConstant
	#deprecated.
	self scale: aRealPoint order: aMatrixOrderConstant!

shear: aPoint
	"Prepend a shearing transformation to the receiver of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self shear: aPoint order: MatrixOrderPrepend!

shear: aPoint order: aMatrixOrderConstant
	"Shear the receiver's world transform by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> 1st argument, in the order specified by the <integer> MatrixOrder 2nd argument."

	self transform: (self transform shear: aPoint order: aMatrixOrderConstant)!

startCap
	^initializer startCap!

startCap: aLineCapConstant
	initializer startCapOf: self set: aLineCapConstant!

transform
	"Answer the receiver's world transform."

	^initializer transform!

transform: aGdiplusMatrix
	"Set the receiver's world transform to the <Matrix> argument."

	initializer matrixOf: self set: aGdiplusMatrix!

translate: aPoint
	"Prepend the translation (shift) to the receiver that is specified by the horizontal and vertical offsets that are the x and y co-ordinates of the <Point> argument."

	self translate: aPoint order: MatrixOrderPrepend!

translate: aPoint order: aMatrixOrderConstant
	"Translate the receiver's transformation matrix by the horizontal and vertical offsets that are the x and y co-ordindates of the <Point> 1st argument, with the order of transformation specified by <integer> MatrixOrderConstant 2nd argument."

	initializer
		transform: self
		translate: aPoint
		order: aMatrixOrderConstant!

width
	"Answer the actual width of the receiver's stroke."

	^initializer width!

width: aNumber
	"Set the width of the receiver's stroke."

	initializer widthOf: self set: aNumber! !
!Graphics.Gdiplus.Pen categoriesForMethods!
alignment!accessing!public! !
alignment:!accessing!public! !
beCentered!modes!public! !
beInset!modes!public! !
brush!accessing!public! !
brush:!accessing!public! !
clone!copying!public! !
color!accessing!public! !
color:!accessing!public! !
compoundArray!accessing!public! !
compoundArray:!accessing!public! !
customEndCap!accessing!public! !
customEndCap:!accessing!public! !
customStartCap!accessing!public! !
customStartCap:!accessing!public! !
dashCap!accessing!public! !
dashCap:!accessing!public! !
dashPattern!accessing!public! !
dashPattern:!accessing!public! !
dashStyle!accessing!public! !
dashStyle:!accessing!public! !
endCap!accessing!public! !
endCap:!accessing!public! !
initializerClass!constants!private! !
ink!accessing!public! !
lineCap:endCap:dashCap:!accessing!public! !
lineJoin!accessing!public! !
lineJoin:!accessing!public! !
multiply:!public!transformations! !
multiply:order:!public!transformations! !
resetTransform!public!transformations! !
rotate:!public!transformations! !
rotate:order:!public!transformations! !
rotateTransform:!public!transformations! !
rotateTransform:order:!public!transformations! !
scale:!public!transformations! !
scale:order:!public!transformations! !
scaleTransform:!public!transformations! !
scaleTransform:order:!public!transformations! !
shear:!public!transformations! !
shear:order:!public!transformations! !
startCap!accessing!public! !
startCap:!accessing!public! !
transform!public!transformations! !
transform:!public!transformations! !
translate:!public!transformations! !
translate:order:!public!transformations! !
width!accessing!public! !
width:!accessing!public! !
!

!Graphics.Gdiplus.Pen class methodsFor!

black
	^self color: Color.Black!

blue
	^self color: Color blue!

brush: aGdiplusBrush
	"Answer a new instance of the receiver with the specified brush as it's ink, with the default width (1.0)."

	^self brush: aGdiplusBrush width: nil!

brush: aGdiplusBrush width: aNumber
	"Answer a new instance of the receiver with the first argument <Brush> as its ink, and <Number> line width specified by the 2nd argument."

	^self ink: aGdiplusBrush width: aNumber!

color: aColor
	"Answer an instance of the receiver with the specified colour ink, and default width (1.0)."

	^self color: aColor width: nil!

color: aColor width: aNumber
	"Answer a new instance of the receiver ink of the <Color> specified by the first argument, and <Number> line width specified by the 2nd argument."

	^self ink: aColor width: aNumber!

dashDot
	^self dashStyle: DashStyleDashDot!

dashDotDot
	^self dashStyle: DashStyleDashDotDot!

dashed
	^self dashStyle: DashStyleDash!

dashStyle: aDashStyleConstant
	^self new
		dashStyle: aDashStyleConstant;
		yourself!

dotted
	^self dashStyle: DashStyleDot!

green
	^self color: Color green!

ink: aColor
	^self ink: aColor width: nil!

ink: aGdiplusBrushOrColor width: aNumber
	"Answer a new instance of the receiver with the first argument <Brush> as its ink, and <Number> line width specified by the 2nd argument."

	^self fromInitializer: (PenInitializer ink: aGdiplusBrushOrColor width: aNumber)!

new
	^self black!

red
	^self color: Color red!

solid
	^self black!

width: aNumber
	"Answer a new instance of the receiver with black and the specified <Number> line width."

	^self ink: Color.Black width: aNumber! !
!Graphics.Gdiplus.Pen class categoriesForMethods!
black!instance creation!public! !
blue!instance creation!public! !
brush:!instance creation!public! !
brush:width:!instance creation!public! !
color:!instance creation!public! !
color:width:!instance creation!public! !
dashDot!instance creation!public! !
dashDotDot!instance creation!public! !
dashed!instance creation!public! !
dashStyle:!instance creation!public! !
dotted!instance creation!public! !
green!instance creation!public! !
ink:!instance creation!public! !
ink:width:!instance creation!public! !
new!instance creation!public! !
red!instance creation!public! !
solid!instance creation!public! !
width:!instance creation!public! !
!

