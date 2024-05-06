"Filed out from Dolphin Smalltalk"!

GdiplusBrush subclass: #GdiplusTextureBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusTextureBrush guid: (GUID fromString: '{1a1a5ea2-6151-11d7-b609-00e0987e8081}')!

GdiplusTextureBrush comment: 'A texture brush paints an image. The image or texture is either a portion of a specified image or a scaled version of a specified image. The type of image (metafile or nonmetafile) determines whether the texture is a portion of the image or a scaled version of the image. '!

!GdiplusTextureBrush categoriesForClass!Unclassified! !

!GdiplusTextureBrush methodsFor!

rotateTransform: aRealAngle 
	"Rotate the receiver's transformation matrix by aRealAngle."

	self rotateTransform: aRealAngle order: MatrixOrderPrepend!

rotateTransform: aRealAngle order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipRotateTextureTransform: self asParameter
				angle: aRealAngle
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipRotateTextureTransform failed' with: status]!

transform: aGdiplusMatrix 
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetTextureTransform: self asParameter
				matrix: aGdiplusMatrix asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetTextureTransform failed' with: status]! !

!GdiplusTextureBrush categoriesForMethods!
rotateTransform:!operations!public! !
rotateTransform:order:!operations!public! !
transform:!accessing!public! !
!

!GdiplusTextureBrush class methodsFor!

exampleGdipTBFillAShape
	"MSDN: GDI+ > Using GDI+ > Using a Brush to Fill Shapes > Filling a Shape with an Image Texture
	The following example fills an ellipse with an image.  The code first creates an Image and then a 
	Brush based on the image. The image in the brush is then scaled and the brush is used to fill an 
	ellipse.  Three ellipses are drawn, with varying scales, i.e., smaller, equal, and greater, compared to 
	the image.  When the scaled brush image is smaller than the ellipse, the brush is tiled in the ellipse.

		self exampleGdipTBFillAShape showExample
	"

	| bitmap graphics image brush layoutExtent matrix fac |
	bitmap := GdiplusBitmap extent: 600 @ 350.
	graphics := bitmap graphics.
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	layoutExtent := 180 @ 135.
	fac := 0.25 * layoutExtent x / image width.
	graphics 
		drawImage: image
		at: 200 @ 0
		extent: layoutExtent.
	brush := GdiplusTextureBrush image: image.
	matrix := GdiplusMatrix rectangle: (fac @ 0 extent: 0 @ fac) point: Point new.
	brush transform: matrix.
	graphics fillEllipse: (0 @ 170 extent: layoutExtent) brush: brush.
	fac := layoutExtent x / image width.
	matrix := GdiplusMatrix rectangle: (fac @ 0 extent: 0 @ fac) point: Point new.
	brush transform: matrix.
	graphics fillEllipse: (200 @ 170 extent: layoutExtent) brush: brush.
	fac := 4 * layoutExtent x / image width.
	matrix := GdiplusMatrix rectangle: (fac @ 0 extent: 0 @ fac) point: Point new.
	brush transform: matrix.
	graphics fillEllipse: (400 @ 170 extent: layoutExtent) brush: brush.
	^bitmap!

exampleGdipTBTilingAShape
	"MSDN: GDI+ > Using GDI+ > Using a Brush to Fill Shapes > Tiling a Shape with an Image

		self exampleGdipTBTilingAShape showExample
	"

	| bitmap image brush pen |
	bitmap := GdiplusBitmap extent: 250 @ 250.
	image := (GdiplusImage fromFile: 'Resources/Beach Ball.bmp'
				usingLocator: FileLocator installRelative) thumbnailWithHeight: 75.
	brush := GdiplusTextureBrush image: image.
	pen := GdiplusPen black.
	(bitmap graphics)
		drawRectangle: (0 @ 0 corner: 200 @ 200) pen: pen;
		fillRectangle: (0 @ 0 extent: 200 @ 200) brush: brush.
	^bitmap!

image: anImage
	^self image: anImage wrapMode: WrapModeTile!

image: anImage wrapMode: anInteger
	^self 
		image: anImage
		wrapMode: anInteger
		rectangle: nil!

image: anImage wrapMode: aWrapModeConstant rectangle: aRectangle
	"Answers a TextureBrush object based on an image, a wrap mode and a defining rectangle."

	^self fromInitializer: (GdiplusTextureBrushInitializer 
				image: anImage
				wrapMode: aWrapModeConstant
				rectangle: aRectangle)! !

!GdiplusTextureBrush class categoriesForMethods!
exampleGdipTBFillAShape!examples!public!sunit! !
exampleGdipTBTilingAShape!examples!public!sunit! !
image:!instance creation!public! !
image:wrapMode:!instance creation!public! !
image:wrapMode:rectangle:!instance creation!public! !
!

