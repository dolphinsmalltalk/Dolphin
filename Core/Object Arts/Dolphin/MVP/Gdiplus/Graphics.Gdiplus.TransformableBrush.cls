"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Brush
	subclass: #'Graphics.Gdiplus.TransformableBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.TransformableBrush guid: (Core.GUID fromString: '{802654fb-8e86-4cca-a186-b7ef93ecc056}')!
Graphics.Gdiplus.TransformableBrush isNonInstantiable: true!
Graphics.Gdiplus.TransformableBrush comment: ''!
!Graphics.Gdiplus.TransformableBrush methodsFor!

bounds
	"Answer a bounding <Rectangle> for the receiver."

	^self subclassResponsibility!

clone
	"Answer a copy of the receiver."

	"The attributes of TransformableBrushes cannot all be queried through the GDI+ API, so we cannot populate an initializer from the handle. Consequently we must copy over the initializer."

	^super clone
		initializer: initializer copy;
		yourself!

extent
	^self bounds extent!

gdiplusBrush: aRectangle
	^self clone
		translate: aRectangle origin;
		scale: aRectangle extent / self extent max;
		yourself!

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

scale: aPoint
	"Prepend a scaling transformation to the receiver's transformation matrix of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self scale: aPoint order: MatrixOrderPrepend!

scale: aPoint order: aMatrixOrderConstant
	"Scale the receiver's world transform by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> 1st argument, with the order of transformation specified by the <integer> MatrixOrder 2nd argument."

	initializer
		transform: self
		scale: aPoint
		order: aMatrixOrderConstant!

shear: aPoint
	"Prepend a shearing transformation to the receiver of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self shear: aPoint order: MatrixOrderPrepend!

shear: aPoint order: aMatrixOrderConstant
	"Shear the receiver's world transform by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> 1st argument, in the order specified by the <integer> MatrixOrder 2nd argument."

	self transform: (self transform shear: aPoint order: aMatrixOrderConstant)!

transform
	"Answer a <Matrix> that is the receiver's transformation matrix."

	^initializer getTransformOf: self!

transform: aMatrix
	"Set the transformation matrix of the receiver to the <Matrix> argument."

	initializer transformOf: self set: aMatrix!

translate: aPoint
	"Translate the receiver's transformation matrix by the x (horizontal) and y (vertical) components specified in the <Point> argument."

	self translate: aPoint order: MatrixOrderPrepend!

translate: aPoint order: aMatrixOrderConstant
	"Translate the receiver's transformation matrix by the horizontal and vertical offsets that are the x and y co-ordindates of the <Point> 1st argument, with the order of transformation specified by <integer> MatrixOrderConstant 2nd argument."

	initializer
		transform: self
		translate: aPoint
		order: aMatrixOrderConstant!

wrapMode
	"Answer a number that indicates if and how painting is done outside the receiver's boundary path."

	^initializer wrapMode!

wrapMode: aWrapModeConstant
	"Set if and how painting is done outside the receiver's boundary path."

	initializer wrapMode: self handle set: aWrapModeConstant! !
!Graphics.Gdiplus.TransformableBrush categoriesForMethods!
bounds!accessing!public! !
clone!copying!public! !
extent!accessing!public! !
gdiplusBrush:!converting!public! !
multiply:!public!transformations! !
multiply:order:!public!transformations! !
resetTransform!public!transformations! !
rotate:!public!transformations! !
rotate:order:!public!transformations! !
scale:!public!transformations! !
scale:order:!public!transformations! !
shear:!public!transformations! !
shear:order:!public!transformations! !
transform!accessing!public!transformations! !
transform:!public!transformations! !
translate:!public!transformations! !
translate:order:!public!transformations! !
wrapMode!accessing!public! !
wrapMode:!accessing!public! !
!

