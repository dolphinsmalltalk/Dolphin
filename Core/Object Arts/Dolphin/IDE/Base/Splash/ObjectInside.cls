"Filed out from Dolphin Smalltalk"!

Object subclass: #ObjectInside
	instanceVariableNames: 'image edgePoints position scale rotation alpha color baseColor matrix'
	classVariableNames: 'EdgePointResolution'
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!

ObjectInside guid: (GUID fromString: '{c019a761-9b1c-4f55-8dd3-66b8e8b2864f}')!

ObjectInside addClassConstant: 'EdgePointResolution' value: 16rA!

ObjectInside comment: ''!

!ObjectInside categoriesForClass!Kernel-Objects! !

!ObjectInside methodsFor!

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
	attributes := GdiplusImageAttributes new.
	self color 
		ifNotNil: 
			[:col | 
			| table |
			table := StructureArray length: 1 elementClass: GpColorMap.
			(table at: 1)
				oldColor: self baseColor argbCode;
				newColor: col argbCode.
			attributes remapTable: table].
	self alpha 
		ifNotNil: 
			[:alph | 
			| colorMatrix |
			colorMatrix := GpColorMatrix identity.
			colorMatrix atPoint: 4 @ 4 put: alph.
			attributes colorMatrix: colorMatrix].
	aGdiplusGraphics
		interpolationMode: InterpolationModeHighQualityBicubic;
		transform: self matrix;
		drawImage: self image
			at: Point zero
			extent: extent
			from: Point zero
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
	gdipluslib := GdiplusLibrary default.
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
			[matrix := (GdiplusMatrix new)
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
	gdiplusLib := GdiplusLibrary default.
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

!ObjectInside categoriesForMethods!
alpha!accessing!public! !
alpha:!accessing!public! !
baseColor!accessing!public! !
baseColor:!accessing!public! !
center!accessing!public! !
color!accessing!public! !
color:!accessing!public! !
copy!copying!public! !
drawEdgePointsOn:!operations!public! !
drawOn:!operations!public! !
edgePoints!accessing!public! !
edgePoints:!accessing!public! !
extent!accessing!public! !
findEdgePoints!operations!private! !
image!private! !
initialize!private! !
matrix!accessing!operations!public! !
position!accessing!public! !
position:!accessing!public! !
resetMatrix!operations!public! !
rotation!accessing!public! !
rotation:!accessing!public! !
scale!accessing!public! !
scale:!accessing!public! !
setImage:!private! !
testCollisionIn:!accessing!public! !
x!accessing!public! !
x:!accessing!public! !
y!accessing!public! !
y:!accessing!public! !
!

!ObjectInside class methodsFor!

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
	scaledBitmap := GdiplusBitmap fromImage: aGdiplusImage scaledBy: aFloatScale.
	^self fromImage: scaledBitmap! !

!ObjectInside class categoriesForMethods!
chooseFile!public! !
fromBytes:!public! !
fromImage:!public! !
fromImage:scaledBy:!public! !
!

