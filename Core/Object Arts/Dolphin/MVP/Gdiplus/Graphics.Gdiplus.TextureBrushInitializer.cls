"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.TransformableBrushInitializer subclass: #'Graphics.Gdiplus.TextureBrushInitializer'
	instanceVariableNames: 'image rectangle'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.TextureBrushInitializer guid: (Core.GUID fromString: '{1a1a5ea3-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.TextureBrushInitializer comment: ''!
!Graphics.Gdiplus.TextureBrushInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject
		or: [super = anObject and: [image = anObject image and: [self rectangle = anObject rectangle]]]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	rectangle isNil
		ifTrue: 
			[Gdip
				gdipCreateTexture: image asParameter
				wrapMode: wrapMode
				texture: gpHandle]
		ifFalse: 
			[Gdip
				gdipCreateTexture2I: image asParameter
				wrapMode: wrapMode
				x: rectangle left
				y: rectangle top
				width: rectangle width
				height: rectangle height
				texture: gpHandle].
	^gpHandle!

gdipGetTransform: aHandle matrix: matrix
	Gdip gdipGetTextureTransform: aHandle matrix: matrix handle!

gdipMultiplyTransform: aGpBrush matrix: aGpMatrix order: aMatrixOrderConstant
	Gdip
		gdipMultiplyTextureTransform: aGpBrush
		matrix: aGpMatrix
		order: aMatrixOrderConstant!

gdipResetTransform: aHandle
	Gdip gdipResetTextureTransform: aHandle!

gdipRotateTransform: aHandle angle: aNumber order: aMatrixOrderConstant
	Gdip
		gdipRotateTextureTransform: aHandle
		angle: aNumber asFloat
		order: aMatrixOrderConstant!

gdipScaleTransform: aHandle width: widthFloat height: heightFloat order: aMatrixOrderConstant
	Gdip
		gdipScaleTextureTransform: aHandle
		sx: widthFloat
		sy: heightFloat
		order: aMatrixOrderConstant!

gdipSetTransform: aHandle matrix: aMatrix
	Gdip gdipSetTextureTransform: aHandle matrix: aMatrix asParameter!

gdipSetWrap: aHandle mode: aWrapModeConstant
	Gdip gdipSetTextureWrapMode: aHandle wrapMode: aWrapModeConstant!

gdipTranslateTransform: aHandle dx: dxFloat dy: dyFloat order: aMatrixOrderConstant
	Gdip
		gdipTranslateTextureTransform: aHandle
		dx: dxFloat
		dy: dyFloat
		order: aMatrixOrderConstant!

hash
	"Answer the <integer> hash value for the receiver."

	^(((self species hash + wrapMode hash) hashMultiply + rectangle hash) hashMultiply + image hash)
		hashMultiply!

image
	^image!

image: anImage wrapMode: aWrapModeConstant rectangle: aRectangle
	image := anImage.
	wrapMode := aWrapModeConstant.
	rectangle := aRectangle.
	^self!

isPersistent
	"Answer true if the receiver holds sufficient information such that it can recreate the Gdiplus native object it describes exactly as it was across Smalltalk image save/restore."

	^image isPersistent!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^super isSelfEvaluating and: [image isSelfEvaluating]!

printAttributesOn: aStream
	aStream
		nextPutAll: 'image: ';
		print: image.
	wrapMode == self defaultWrapMode
		ifFalse: 
			[aStream nextPutAll: ' wrapMode: '.
			self
				printEnum: wrapMode
				names: Gdiplus.WrapModeNames
				on: aStream].
	rectangle
		ifNotNil: 
			[aStream
				nextPutAll: ' rectangle: ';
				print: rectangle].
	transform isNil
		ifFalse: 
			[aStream
				nextPutAll: '; transform: ';
				print: transform]!

rectangle
	^rectangle ?? image bounds! !
!Graphics.Gdiplus.TextureBrushInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
gdipGetTransform:matrix:!private!transformations! !
gdipMultiplyTransform:matrix:order:!private!transformations! !
gdipResetTransform:!private!transformations! !
gdipRotateTransform:angle:order:!private!transformations! !
gdipScaleTransform:width:height:order:!private!transformations! !
gdipSetTransform:matrix:!private!transformations! !
gdipSetWrap:mode:!attributes!private! !
gdipTranslateTransform:dx:dy:order:!private!transformations! !
hash!comparing!public! !
image!accessing!public! !
image:wrapMode:rectangle:!initializing!private! !
isPersistent!public!testing! !
isSelfEvaluating!public!testing! !
printAttributesOn:!printing!private! !
rectangle!accessing!public! !
!

!Graphics.Gdiplus.TextureBrushInitializer class methodsFor!

image: anImage wrapMode: aNumber rectangle: aRectangle
	^self new 
		image: anImage
		wrapMode: aNumber
		rectangle: aRectangle!

stbConvertFrom: anSTBClassFormat
	^
	[:data |
	self
		image: (data at: 2)
		wrapMode: (data at: 3)
		rectangle: (data at: 4)]! !
!Graphics.Gdiplus.TextureBrushInitializer class categoriesForMethods!
image:wrapMode:rectangle:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
!

