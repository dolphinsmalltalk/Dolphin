"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.TransformableBrush
	subclass: #'Graphics.Gdiplus.TextureBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.TextureBrush guid: (Core.GUID fromString: '{1a1a5ea2-6151-11d7-b609-00e0987e8081}')!

Graphics.Gdiplus.TextureBrush comment: 'A texture brush paints an image. The image or texture is either a portion of a specified image or a scaled version of a specified image. The type of image (metafile or nonmetafile) determines whether the texture is a portion of the image or a scaled version of the image. '!

!Graphics.Gdiplus.TextureBrush methodsFor!

bounds
	"Answer a bounding <Rectangle> for the receiver."

	^initializer rectangle!

image
	^self initializer image!

initializerClass
	^TextureBrushInitializer! !

!Graphics.Gdiplus.TextureBrush categoriesForMethods!
bounds!accessing!public! !
image!attributes!public! !
initializerClass!constants!private! !
!

!Graphics.Gdiplus.TextureBrush class methodsFor!

image: anImage
	^self image: anImage wrapMode: WrapModeTile!

image: anImage rectangle: aRectangle
	^self
		image: anImage
		wrapMode: WrapModeTile
		rectangle: aRectangle!

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

!Graphics.Gdiplus.TextureBrush class categoriesForMethods!
image:!instance creation!public! !
image:rectangle:!instance creation!public! !
image:wrapMode:!instance creation!public! !
image:wrapMode:rectangle:!instance creation!public! !
!

