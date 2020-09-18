"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Brush subclass: #'Graphics.Gdiplus.TextureBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.TextureBrush guid: (Core.GUID fromString: '{1a1a5ea2-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.TextureBrush comment: 'A texture brush paints an image. The image or texture is either a portion of a specified image or a scaled version of a specified image. The type of image (metafile or nonmetafile) determines whether the texture is a portion of the image or a scaled version of the image. '!
!Graphics.Gdiplus.TextureBrush categoriesForClass!Unclassified! !
!Graphics.Gdiplus.TextureBrush methodsFor!

rotateTransform: aRealAngle 
	"Rotate the receiver's transformation matrix by aRealAngle."

	self rotateTransform: aRealAngle order: MatrixOrderPrepend!

rotateTransform: aRealAngle order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipRotateTextureTransform: self asParameter
		angle: aRealAngle
		order: aMatrixOrderConstant!

transform: aGdiplusMatrix
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	GdiplusLibrary default gdipSetTextureTransform: self asParameter matrix: aGdiplusMatrix asParameter! !
!Graphics.Gdiplus.TextureBrush categoriesFor: #rotateTransform:!operations!public! !
!Graphics.Gdiplus.TextureBrush categoriesFor: #rotateTransform:order:!operations!public! !
!Graphics.Gdiplus.TextureBrush categoriesFor: #transform:!accessing!public! !

!Graphics.Gdiplus.TextureBrush class methodsFor!

exampleGdipTBFillAShape
	"MSDN: GDI+ > Using GDI+ > Using a Brush to Fill Shapes > Filling a Shape with an Image Texture
	The following example fills an ellipse with an image.  The code first creates an Image and then a 
	Brush based on the image. The image in the brush is then scaled and the brush is used to fill an 
	ellipse.  Three ellipses are drawn, with varying scales, i.e., smaller, equal, and greater, compared to 
	the image.  When the scaled brush image is smaller than the ellipse, the brush is tiled in the ellipse.

		self exampleGdipTBFillAShape showExample
	"

	| bitmap graphics image brush layoutExtent matrix fac |
	bitmap := Bitmap extent: 600 @ 350.
	graphics := bitmap graphics.
	image := Image fromFile: self fileResource pafEyeJpg.
	layoutExtent := 180 @ 135.
	fac := 0.25 * layoutExtent x / image width.
	graphics
		drawImage: image
		at: 200 @ 0
		extent: layoutExtent.
	brush := TextureBrush image: image.
	matrix := Matrix rectangle: (fac @ 0 extent: 0 @ fac) point: Point new.
	brush transform: matrix.
	graphics fillEllipse: (0 @ 170 extent: layoutExtent) brush: brush.
	fac := layoutExtent x / image width.
	matrix := Matrix rectangle: (fac @ 0 extent: 0 @ fac) point: Point new.
	brush transform: matrix.
	graphics fillEllipse: (200 @ 170 extent: layoutExtent) brush: brush.
	fac := 4 * layoutExtent x / image width.
	matrix := Matrix rectangle: (fac @ 0 extent: 0 @ fac) point: Point new.
	brush transform: matrix.
	graphics fillEllipse: (400 @ 170 extent: layoutExtent) brush: brush.
	^bitmap!

exampleGdipTBTilingAShape
	"MSDN: GDI+ > Using GDI+ > Using a Brush to Fill Shapes > Tiling a Shape with an Image

		self exampleGdipTBTilingAShape showExample
	"

	| bitmap image brush pen |
	bitmap := Bitmap extent: 250 @ 250.
	image := (Image fromFile: 'Resources/Beach Ball.bmp' usingLocator: FileLocator installRelative)
				thumbnailWithHeight: 75.
	brush := TextureBrush image: image.
	pen := Pen black.
	bitmap graphics
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

	^self fromInitializer: (TextureBrushInitializer
				image: anImage
				wrapMode: aWrapModeConstant
				rectangle: aRectangle)! !
!Graphics.Gdiplus.TextureBrush class categoriesFor: #exampleGdipTBFillAShape!examples!public!sunit! !
!Graphics.Gdiplus.TextureBrush class categoriesFor: #exampleGdipTBTilingAShape!examples!public!sunit! !
!Graphics.Gdiplus.TextureBrush class categoriesFor: #image:!instance creation!public! !
!Graphics.Gdiplus.TextureBrush class categoriesFor: #image:wrapMode:!instance creation!public! !
!Graphics.Gdiplus.TextureBrush class categoriesFor: #image:wrapMode:rectangle:!instance creation!public! !

