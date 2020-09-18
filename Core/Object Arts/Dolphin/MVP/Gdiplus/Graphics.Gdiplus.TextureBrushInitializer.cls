"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.TextureBrushInitializer'
	instanceVariableNames: 'image wrapMode rectangle'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.TextureBrushInitializer guid: (Core.GUID fromString: '{1a1a5ea3-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.TextureBrushInitializer comment: ''!
!Graphics.Gdiplus.TextureBrushInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.TextureBrushInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	rectangle isNil
		ifTrue: 
			[self library
				gdipCreateTexture: image asParameter
				wrapMode: wrapMode
				texture: gpHandle]
		ifFalse: 
			[self library
				gdipCreateTexture2I: image asParameter
				wrapMode: wrapMode
				x: rectangle left
				y: rectangle top
				width: rectangle width
				height: rectangle height
				texture: gpHandle].
	^gpHandle!

image: anImage wrapMode: aNumber rectangle: aRectangle
	image := anImage.
	wrapMode := aNumber.
	rectangle := aRectangle!

isPersistent
	^image isPersistent! !
!Graphics.Gdiplus.TextureBrushInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.TextureBrushInitializer categoriesFor: #image:wrapMode:rectangle:!initializing!private! !
!Graphics.Gdiplus.TextureBrushInitializer categoriesFor: #isPersistent!public! !

!Graphics.Gdiplus.TextureBrushInitializer class methodsFor!

image: anImage wrapMode: aNumber rectangle: aRectangle
	^self new 
		image: anImage
		wrapMode: aNumber
		rectangle: aRectangle! !
!Graphics.Gdiplus.TextureBrushInitializer class categoriesFor: #image:wrapMode:rectangle:!instance creation!public! !

