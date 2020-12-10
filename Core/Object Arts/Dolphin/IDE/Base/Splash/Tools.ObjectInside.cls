"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Tools.ObjectInside'
	instanceVariableNames: 'image edgePoints position scale rotation alpha color baseColor matrix'
	classVariableNames: ''
	imports: #(#{Graphics.Gdiplus.GdiplusConstants private} #{Graphics private})
	classInstanceVariableNames: ''
	classConstants: {
		'EdgePointResolution' -> 16rA
	}!
Tools.ObjectInside guid: (Core.GUID fromString: '{c019a761-9b1c-4f55-8dd3-66b8e8b2864f}')!
Tools.ObjectInside comment: ''!
!Tools.ObjectInside categoriesForClass!Kernel-Objects! !
!Tools.ObjectInside methodsFor!

alpha
	^alpha!

alpha: aFloat
	alpha := aFloat!

baseColor
	"Answer the base color to map from"

	^baseColor!

baseColor: aColor
	"Set the base color to map from"

	baseColor :=aColor!

center
	^self image extent // 2!

color
	"Answer the color to map the baseColor to, or nil if there is no deviation from the original"

	^color!

color: aColorOrNil
	"Set the color to map the baseColor to, or nil if there is no deviation from the original"

	color :=aColorOrNil!

copy
	^super copy
		setImage: self image copy;
		resetMatrix;
		yourself!

drawEdgePointsOn: aGdiplusGraphics 
	aGdiplusGraphics transform: self matrix.
	self edgePoints do: [:each | aGdiplusGraphics drawRectangle: (each extent: 1)]!

drawOn: aGdiplusGraphics
	| attributes extent |
	extent := self extent.
	attributes := Gdiplus.ImageAttributes new.
	self color ifNotNil: [:col | attributes remapColor: self baseColor to: col].
	self alpha
		ifNotNil: 
			[:alph |
			| colorMatrix |
			colorMatrix := Gdiplus.GpColorMatrix identity.
			colorMatrix atPoint: 4 @ 4 put: alph.
			attributes colorMatrix: colorMatrix].
	aGdiplusGraphics
		interpolationMode: InterpolationModeHighQualityBicubic;
		transform: self matrix;
		drawImage: self image
			at: Point.Zero
			extent: extent
			from: Point.Zero
			extent: extent
			unit: UnitPixel
			attributes: attributes;
		resetTransform.
	attributes free!

edgePoints
	^edgePoints ifNil: [edgePoints := self findEdgePoints]!

edgePoints: anArray
	edgePoints := anArray!

extent
	^self image extent!

findEdgePoints
	| width argb gdipluslib imageHandle height pts |
	pts := OrderedCollection new: 50.
	height := image height.
	width := image width.
	argb := ByteArray new: 4.
	gdipluslib := Gdiplus.GdiplusLibrary default.
	imageHandle := image asParameter.
	0 to: height + EdgePointResolution
		by: EdgePointResolution
		do: 
			[:y |
			| found ym |
			ym := y min: height - 1.
			found := false.
			0 to: width + EdgePointResolution
				by: EdgePointResolution
				do: 
					[:x |
					gdipluslib
						gdipBitmapGetPixel: imageHandle
						x: (x min: width - 1)
						y: ym
						color: argb.
					(argb dwordAtOffset: 0) == 0 == found
						ifTrue: 
							[pts addLast: x @ y.
							found := found not]]].
	^pts!

image
	^image!

initialize
	super initialize.
	scale := 1.
	rotation := 0.
	alpha := 1.
	baseColor := Color black.
	position := Point zero
!

matrix
	^matrix 
		ifNil: 
			[matrix := (Gdiplus.Matrix new)
						translateTransform: self position;
						rotateTransform: self rotation;
						scaleTransform: self scale asPoint;
						translateTransform: self center negated;
						yourself]!

position
	^position!

position: aPoint
	position := aPoint.
	self resetMatrix!

resetMatrix
	matrix ifNotNil: [matrix free].
	matrix := nil!

rotation
	^rotation!

rotation: degrees 
	rotation := degrees.
	self resetMatrix!

scale
	^scale!

scale: aFloat 
	scale := aFloat.
	self resetMatrix!

setImage: aGdiplusImage 
	image := aGdiplusImage.

!

testCollisionIn: aGdiplusBitmap
	| white color1 gdiplusLib bitmapHandle |
	white := Color white argbCode asSDword.
	color1 := ByteArray new: 4.
	gdiplusLib := Gdiplus.GdiplusLibrary default.
	bitmapHandle := aGdiplusBitmap asParameter.
	^(self matrix transformPoints: self edgePoints) anySatisfy: 
			[:each |
			(gdiplusLib
				gdipBitmapGetPixel: bitmapHandle
				x: each x
				y: each y
				color: color1) == Ok
				and: [(color1 sdwordAtOffset: 0) ~= white]]!

x
	^self position x!

x: aNumber
	self position: aNumber @ self position y!

y
	^self position y!

y: aNumber
	self position: self position x @ aNumber! !
!Tools.ObjectInside categoriesFor: #alpha!accessing!public! !
!Tools.ObjectInside categoriesFor: #alpha:!accessing!public! !
!Tools.ObjectInside categoriesFor: #baseColor!accessing!public! !
!Tools.ObjectInside categoriesFor: #baseColor:!accessing!public! !
!Tools.ObjectInside categoriesFor: #center!accessing!public! !
!Tools.ObjectInside categoriesFor: #color!accessing!public! !
!Tools.ObjectInside categoriesFor: #color:!accessing!public! !
!Tools.ObjectInside categoriesFor: #copy!copying!public! !
!Tools.ObjectInside categoriesFor: #drawEdgePointsOn:!operations!public! !
!Tools.ObjectInside categoriesFor: #drawOn:!operations!public! !
!Tools.ObjectInside categoriesFor: #edgePoints!accessing!public! !
!Tools.ObjectInside categoriesFor: #edgePoints:!accessing!public! !
!Tools.ObjectInside categoriesFor: #extent!accessing!public! !
!Tools.ObjectInside categoriesFor: #findEdgePoints!operations!private! !
!Tools.ObjectInside categoriesFor: #image!private! !
!Tools.ObjectInside categoriesFor: #initialize!private! !
!Tools.ObjectInside categoriesFor: #matrix!accessing!operations!public! !
!Tools.ObjectInside categoriesFor: #position!accessing!public! !
!Tools.ObjectInside categoriesFor: #position:!accessing!public! !
!Tools.ObjectInside categoriesFor: #resetMatrix!operations!public! !
!Tools.ObjectInside categoriesFor: #rotation!accessing!public! !
!Tools.ObjectInside categoriesFor: #rotation:!accessing!public! !
!Tools.ObjectInside categoriesFor: #scale!accessing!public! !
!Tools.ObjectInside categoriesFor: #scale:!accessing!public! !
!Tools.ObjectInside categoriesFor: #setImage:!private! !
!Tools.ObjectInside categoriesFor: #testCollisionIn:!accessing!public! !
!Tools.ObjectInside categoriesFor: #x!accessing!public! !
!Tools.ObjectInside categoriesFor: #x:!accessing!public! !
!Tools.ObjectInside categoriesFor: #y!accessing!public! !
!Tools.ObjectInside categoriesFor: #y:!accessing!public! !

!Tools.ObjectInside class methodsFor!

chooseFile
	^self fromBytes: InternalBitmap chooseFile asByteArray.
!

fromBytes: aByteArray 
	^(self fromImage: (InternalBitmap fromBytes: aByteArray) gdiplusBitmap)
		yourself!

fromImage: aGdiplusImage
	^super new 	
		initialize;
		setImage:aGdiplusImage;
		yourself!

fromImage: aGdiplusImage scaledBy: aFloatScale 
	| scaledBitmap |
	aFloatScale = 1 ifTrue: [^self fromImage: aGdiplusImage].
	scaledBitmap := Gdiplus.Bitmap fromImage: aGdiplusImage scaledBy: aFloatScale.
	^self fromImage: scaledBitmap! !
!Tools.ObjectInside class categoriesFor: #chooseFile!public! !
!Tools.ObjectInside class categoriesFor: #fromBytes:!public! !
!Tools.ObjectInside class categoriesFor: #fromImage:!public! !
!Tools.ObjectInside class categoriesFor: #fromImage:scaledBy:!public! !

