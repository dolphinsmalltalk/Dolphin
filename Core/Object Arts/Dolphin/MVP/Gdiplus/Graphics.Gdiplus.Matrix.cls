"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.Matrix'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Matrix guid: (Core.GUID fromString: '{1a1a5ea7-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.Matrix comment: 'GdiplusMatrix represents a 3 ×3 matrix that, in turn, represents an affine transformation. An instance stores only six of the 9 numbers in a 3 ×3 matrix because all 3 ×3 matrices that represent affine transformations have the same third column (0, 0, 1).  An instance is typically used to transform characteristics of another object (see definitions of #transform:).

'!
!Graphics.Gdiplus.Matrix categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Matrix methodsFor!

asArray
	| array |
	array := FLOATArray new: 6.
	GdiplusLibrary default gdipGetMatrixElements: self asParameter matrixOut: array.
	^array asArray!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteMatrix: handle!

printOn: aStream
	self basicPrintOn: aStream.
	aStream nextPut: $(.
	self isRealized ifTrue: [
		self asArray do: [:each | aStream print: (each roundTo: 0.000001)] separatedBy: [aStream nextPutAll: ', ']].
	aStream nextPut: $)!

rotateTransform: aRealAngle
	self rotateTransform: aRealAngle order: MatrixOrderPrepend!

rotateTransform: aRealAngle order: aMatrixOrderConstant
	GdiplusLibrary default
		gdipRotateMatrix: self asParameter
		angle: aRealAngle
		order: aMatrixOrderConstant!

scaleTransform: aPoint
	self scaleTransform: aPoint order: MatrixOrderPrepend!

scaleTransform: aPoint order: aMatrixOrderConstant
	GdiplusLibrary default
		gdipScaleMatrix: self asParameter
		scaleX: aPoint x
		scaleY: aPoint y
		order: aMatrixOrderConstant!

shearTransform: aPoint
	self shearTransform: aPoint order: MatrixOrderPrepend!

shearTransform: aPoint order: aMatrixOrderConstant
	GdiplusLibrary default
		gdipShearMatrix: self asParameter
		shearX: aPoint x
		shearY: aPoint y
		order: aMatrixOrderConstant!

transformPoints: aPointsCollection
	| pts |
	pts := StructureArray
				withAll: aPointsCollection
				elementClass: POINTL
				initializer: [:pointl :point | pointl x: point x y: point y].
	pts beUnfinalizable.
	GdiplusLibrary default
		gdipTransformMatrixPointsI: self handle
		pts: pts
		count: aPointsCollection size.
	^pts!

translateTransform: aPoint
	self translateTransform: aPoint order: MatrixOrderPrepend!

translateTransform: aPoint order: aMatrixOrderConstant
	GdiplusLibrary default
		gdipTranslateMatrix: self asParameter
		offsetX: aPoint x
		offsetY: aPoint y
		order: aMatrixOrderConstant! !
!Graphics.Gdiplus.Matrix categoriesFor: #asArray!converting!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Gdiplus.Matrix categoriesFor: #printOn:!printing!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #rotateTransform:!operations!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #rotateTransform:order:!operations!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #scaleTransform:!operations!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #scaleTransform:order:!operations!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #shearTransform:!operations!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #shearTransform:order:!operations!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #transformPoints:!operations!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #translateTransform:!operations!public! !
!Graphics.Gdiplus.Matrix categoriesFor: #translateTransform:order:!operations!public! !

!Graphics.Gdiplus.Matrix class methodsFor!

exampleGdipMShadows
	"This example various transformations (shear, scale and translate) to display a string
	in large font and its shadow.

		self exampleGdipMShadows showExample
	"

	| bitmap graphics font matrix brush |
	bitmap := Bitmap extent: 750 @ 200.
	graphics := bitmap graphics.
	(matrix := Matrix new)
		shearTransform: -1.4 @ 0;
		scaleTransform: 1 @ 0.6;
		translateTransform: 180 @ 86.
	graphics transform: matrix.
	font := Font name: 'Times New Roman' pointSize: 100.
	brush := SolidBrush color: Color gray.
	#(50 150 250 330 415 510 560) with: 'DOLPHIN'
		do: 
			[:num :char |
			graphics
				drawString: char asString
				font: font
				at: num @ 10
				format: nil
				brush: brush].
	graphics resetTransform.
	brush color: Color blue.
	#(50 150 250 330 415 510 560) with: 'DOLPHIN'
		do: 
			[:num :char |
			graphics
				drawString: char asString
				font: font
				at: num @ 10
				format: nil
				brush: brush].
	^bitmap!

exampleGdipMShear
	" MSDN:  GDI+ >  GDI+ Reference >  Classes >  Matrix >  Matrix Methods > Shear
	This example creates a Matrix object and performs first a scale, then a shearing transformation on it.
	A rectangle is drawn initially and then again after each transformation.  This particular shearing
	slides the bottom edge of the rectangle to the right. The distance that the bottom edge slides is
	3 multiplied by the height of the rectangle after it is stretched by the scaling transformation.

		self exampleGdipMShear showExample
	"

	| bitmap graphics rect matrix |
	bitmap := Bitmap extent: 550 @ 150.
	graphics := bitmap graphics.
	rect := 0 @ 0 extent: 100 @ 50.
	graphics drawRectangle: rect pen: Pen black.
	matrix := Matrix new.
	matrix scaleTransform: 2 @ 2.
	graphics transform: matrix.
	graphics drawRectangle: rect pen: Pen blue.
	matrix shearTransform: 3 @ 0 order: MatrixOrderAppend.
	graphics transform: matrix.
	graphics drawRectangle: rect pen: Pen red.
	^bitmap!

exampleGdipMTranslate
	"This example creates a GdiplusMatrix object, sets its elements to a rotation, then updates 
	the matrix with the product of itself and a translation matrix. At that point, the matrix 
	represents a composite transformation: first rotate, then translate, and it is used to set the 
	world transformation of a GdiplusGraphics object, on which an ellipse is drawn.

		self exampleGdipMTranslate showExample
	"

	| bitmap matrix pen |
	bitmap := Bitmap extent: 500 @ 300.
	(matrix := Matrix new)
		rotateTransform: 30;
		translateTransform: 250 @ 100 order: MatrixOrderAppend.
	pen := Pen blue.
	bitmap graphics
		drawEllipse: (Point zero extent: 200 @ 100) pen: pen;
		drawString: 'Original' at: 60 @ 40;
		transform: matrix;
		drawEllipse: (Point zero extent: 200 @ 100) pen: pen;
		drawString: 'Rotated and Translated' at: 20 @ 40;
		drawLine: (-100 @ 0 corner: 100 @ 0) pen: pen;
		drawLine: (0 @ -100 corner: 0 @ 100) pen: pen;
		drawString: '0 @ 0' at: 0 @ 0.
	^bitmap!

fromArray: anArray
	^self
		m11: (anArray at: 1)
		m12: (anArray at: 2)
		m21: (anArray at: 3)
		m22: (anArray at: 4)
		m31: (anArray at: 5)
		m32: (anArray at: 6)!

m11: aNumber11 m12: aNumber12 m21: aNumber21 m22: aNumber22 m31: aNumber31 m32: aNumber32
	^self fromInitializer: (MatrixInitializer
				m11: aNumber11 asFloat
				m12: aNumber12 asFloat
				m21: aNumber21 asFloat
				m22: aNumber22 asFloat
				m31: aNumber31 asFloat
				m32: aNumber32 asFloat)!

new
	^self fromArray: #(1 0 0 1 0 0)!

rectangle: aRectangle point: aPoint
	^self 
		m11: aRectangle left
		m12: aRectangle top
		m21: aRectangle width
		m22: aRectangle height
		m31: aPoint x
		m32: aPoint y! !
!Graphics.Gdiplus.Matrix class categoriesFor: #exampleGdipMShadows!examples!public!sunit! !
!Graphics.Gdiplus.Matrix class categoriesFor: #exampleGdipMShear!examples!public!sunit! !
!Graphics.Gdiplus.Matrix class categoriesFor: #exampleGdipMTranslate!examples!public!sunit! !
!Graphics.Gdiplus.Matrix class categoriesFor: #fromArray:!instance creation!public! !
!Graphics.Gdiplus.Matrix class categoriesFor: #m11:m12:m21:m22:m31:m32:!instance creation!public! !
!Graphics.Gdiplus.Matrix class categoriesFor: #new!instance creation!public! !
!Graphics.Gdiplus.Matrix class categoriesFor: #rectangle:point:!instance creation!public! !

