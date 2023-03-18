"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Tools.ObjectInside'
	instanceVariableNames: 'image edgePoints position scale rotation alpha color baseColor matrix'
	classVariableNames: ''
	imports: #(#{Graphics private} #{Graphics.Gdiplus private})
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
	| attributes |
	attributes := ImageAttributes new.
	self color ifNotNil: [:col | attributes remapColor: self baseColor to: col].
	self alpha
		ifNotNil: 
			[:alph |
			attributes colorMatrix: (ColorMatrix identity
						atPoint: 4 @ 4 put: alph;
						yourself)].
	aGdiplusGraphics
		interpolationMode: InterpolationModeHighQualityBicubic;
		transform: self matrix;
		drawImage: self image attributes: attributes;
		resetTransform.
	attributes free!

edgePoints
	^edgePoints ifNil: [edgePoints := self findEdgePoints]!

edgePoints: anArray
	edgePoints := anArray!

extent
	^self image extent!

findEdgePoints
	| width argb imageHandle height pts |
	pts := OrderedCollection new: 50.
	height := image height.
	width := image width.
	argb := ByteArray new: 4.
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
					Gdip
						gdipBitmapGetPixel: imageHandle
						x: (x min: width - 1)
						y: ym
						color: argb.
					(argb uint32AtOffset: 0) == 0 == found
						ifTrue: 
							[pts addLast: x @ y.
							found := found not]]].
	^pts asArray!

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
			[matrix := Matrix new
						translate: self position;
						rotate: self rotation;
						scale: self scale asPoint;
						translate: self center negated;
						yourself]!

position
	^position!

position: aPoint
	position := aPoint.
	self resetMatrix!

resetMatrix
	matrix free.
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
	| color1 bitmapHandle |
	color1 := ByteArray newFixed: 4.
	bitmapHandle := aGdiplusBitmap asParameter.
	^(self matrix transformPoints: self edgePoints) anySatisfy: 
			[:each |
			(Gdip
				gdipBitmapGetPixel: bitmapHandle
				x: each x
				y: each y
				color: color1) == Ok
				and: [(color1 int32AtOffset: 0) ~= ##(Color white argbCode asSDword)]]!

x
	^self position x!

x: aNumber
	self position: aNumber @ self position y!

y
	^self position y!

y: aNumber
	self position: self position x @ aNumber! !
!Tools.ObjectInside categoriesForMethods!
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
!Tools.ObjectInside class categoriesForMethods!
chooseFile!public! !
fromBytes:!public! !
fromImage:!public! !
fromImage:scaledBy:!public! !
!

