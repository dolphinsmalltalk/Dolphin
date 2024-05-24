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

	GdiplusLibrary default
		gdipRotateTextureTransform: self asParameter
		angle: aRealAngle
		order: aMatrixOrderConstant!

transform: aGdiplusMatrix
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	GdiplusLibrary default gdipSetTextureTransform: self asParameter matrix: aGdiplusMatrix asParameter! !

!GdiplusTextureBrush categoriesForMethods!
rotateTransform:!operations!public! !
rotateTransform:order:!operations!public! !
transform:!accessing!public! !
!

!GdiplusTextureBrush class methodsFor!

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
image:!instance creation!public! !
image:wrapMode:!instance creation!public! !
image:wrapMode:rectangle:!instance creation!public! !
!

