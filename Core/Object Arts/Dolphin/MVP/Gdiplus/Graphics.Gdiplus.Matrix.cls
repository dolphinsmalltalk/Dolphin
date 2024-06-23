"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase
	subclass: #'Graphics.Gdiplus.Matrix'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Matrix guid: (Core.GUID fromString: '{1a1a5ea7-6151-11d7-b609-00e0987e8081}')!

Graphics.Gdiplus.Matrix comment: 'GdiplusMatrix represents a 3 ×3 matrix that, in turn, represents an affine transformation. An instance stores only six of the 9 numbers in a 3 ×3 matrix because all 3 ×3 matrices that represent affine transformations have the same third column (0, 0, 1).  An instance is typically used to transform characteristics of another object (see definitions of #transform:).

'!

!Graphics.Gdiplus.Matrix methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	self == anObject ifTrue: [^true].
	^self class == anObject class and: [self isEqualMatrix: anObject]!

asArray
	^self elements!

closeTo: aNumber
	^self closeTo: aNumber precision: 0.0000001!

closeTo: aMatrix precision: precisionFloat
	^self elements closeTo: aMatrix asArray precision: precisionFloat!

createHandle
	^initializer
		ifNil: 
			[| gpMatrix |
			gpMatrix := Handle new.
			Gdip gdipCreateMatrix: gpMatrix.
			gpMatrix]
		ifNotNil: [initializer createHandle]!

displayOn: aStream
	aStream nextPut: $(.
	self elements do: [:each | each printOn: aStream significantFigures: 6]
		separatedBy: 
			[aStream
				nextPutAll: aStream locale listSeparator;
				space].
	aStream nextPut: $)!

elements
	^self initializer elements!

elements: aSequencedReadableCollection
	Gdip
		gdipSetMatrixElements: self handle
		m11: (aSequencedReadableCollection at: 1)
		m12: (aSequencedReadableCollection at: 2)
		m21: (aSequencedReadableCollection at: 3)
		m22: (aSequencedReadableCollection at: 4)
		dx: (aSequencedReadableCollection at: 5)
		dy: (aSequencedReadableCollection at: 6).
	initializer := nil!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^MatrixInitializer!

isEqualMatrix: aMatrix
	"Private - Answer whether the receiver and anObject are equivalent matrices.
	This uses the official comparison provided by the GdipIsMatrixEqual function, but is arguably over-precise as it does not take into account the very limited precision available in a single-precision IEEEE float. See also #closeTo:[precision:]"

	| bool |
	bool := UInt32Bytes new.
	Gdip
		gdipIsMatrixEqual: self handle
		matrix2: aMatrix asParameter
		result: bool.
	^bool asBoolean!

isIdentity
	"Answer whether the receiver is an identity matrix, i.e. (1, 0, 0, 1, 0, 0)"

	^self initializer isIdentity!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^true!

offsetX
	^self elements at: 5!

offsetY
	^self elements at: 6!

rotate: aNumber
	"Prepend a rotation to the receiver of the <Number> angle in degrees argument."

	self rotate: aNumber order: MatrixOrderPrepend!

rotate: aRealAngle at: aPoint
	"Translate the receiver's transformation matrix by a Point and then rotate it by aRealAngle."

	self
		translate: aPoint;
		rotate: aRealAngle!

rotate: aNumber order: aMatrixOrderConstant
	"Rotate the receiver by the <Number> angle in degrees 1st argument, with the order of transformation specified by MatrixOrder <integer> 2nd argument."

	Gdip
		gdipRotateMatrix: self handle
		angle: aNumber asFloat
		order: aMatrixOrderConstant.
	initializer := nil!

scale: aPoint
	"Prepend a scaling transformation to the receiver of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self scale: aPoint order: MatrixOrderPrepend!

scale: aPoint order: aMatrixOrderConstant
	"Scale the receiver by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> 1st argument, in the order specified by the <integer> MatrixOrder 2nd argument."

	Gdip
		gdipScaleMatrix: self handle
		scaleX: aPoint x asFloat
		scaleY: aPoint y asFloat
		order: aMatrixOrderConstant.
	initializer := nil!

shear: aPoint
	"Prepend a shearing transformation to the receiver of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self shear: aPoint order: MatrixOrderPrepend!

shear: aPoint order: aMatrixOrderConstant
	"Shear the receiver by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> 1st argument, in the order specified by the <integer> MatrixOrder 2nd argument."

	Gdip
		gdipShearMatrix: self handle
		shearX: aPoint x asFloat
		shearY: aPoint y asFloat
		order: aMatrixOrderConstant.
	initializer := nil!

transformPoints: aPointsCollection
	"Transform the <collection> of <Point> argument using this matrix, answering the transformed collection.
	Note that if a <POINTLArray> is passed as the argument, it will be updated in place."

	| nativePoints |
	nativePoints := POINTLArray marshal: aPointsCollection.
	Gdip
		gdipTransformMatrixPointsI: self handle
		pts: nativePoints
		count: aPointsCollection size.
	^nativePoints!

translate: aPoint
	"Prepend the translation (shift) to the receiver that is specified by the horizontal and vertical offsets that are the x and y co-ordinates of the <Point> argument."

	self translate: aPoint order: MatrixOrderPrepend!

translate: aPoint order: aMatrixOrderConstant
	"Translate the receiver by the horizontal and vertical offsets that are the x and y co-ordinates of the <Point> first argument, in the order specified by the <integer> MatrixOrder second argument."

	Gdip
		gdipTranslateMatrix: self handle
		offsetX: aPoint x
		offsetY: aPoint y
		order: aMatrixOrderConstant.
	initializer := nil! !

!Graphics.Gdiplus.Matrix categoriesForMethods!
=!comparing!public! !
asArray!converting!public! !
closeTo:!comparing!public! !
closeTo:precision:!comparing!public! !
createHandle!public!realizing/unrealizing! !
displayOn:!printing!public! !
elements!converting!public! !
elements:!converting!public! !
initializerClass!private!realizing/unrealizing! !
isEqualMatrix:!comparing!private! !
isIdentity!public!testing! !
isSelfEvaluating!public!testing! !
offsetX!converting!public! !
offsetY!converting!public! !
rotate:!public!transformations! !
rotate:at:!public!transformations! !
rotate:order:!public!transformations! !
scale:!public!transformations! !
scale:order:!public!transformations! !
shear:!public!transformations! !
shear:order:!public!transformations! !
transformPoints:!operations!public! !
translate:!public!transformations! !
translate:order:!public!transformations! !
!

!Graphics.Gdiplus.Matrix class methodsFor!

dashed
	^self withStyleName: #dashed!

fromArray: anArray
	^self fromInitializer: (MatrixInitializer fromArray: anArray)!

identity
	^self new!

m11: aNumber11 m12: aNumber12 m21: aNumber21 m22: aNumber22 dx: dxNumber dy: dyNumber
	^self fromInitializer: (MatrixInitializer
				m11: aNumber11
				m12: aNumber12
				m21: aNumber21
				m22: aNumber22
				dx: dxNumber
				dy: dyNumber)!

rectangle: aRectangle point: aPoint
	^self
		m11: aRectangle left
		m12: aRectangle top
		m21: aRectangle width
		m22: aRectangle height
		dx: aPoint x
		dy: aPoint y! !

!Graphics.Gdiplus.Matrix class categoriesForMethods!
dashed!instance creation!public! !
fromArray:!instance creation!public! !
identity!instance creation!public! !
m11:m12:m21:m22:dx:dy:!instance creation!public! !
rectangle:point:!instance creation!public! !
!

