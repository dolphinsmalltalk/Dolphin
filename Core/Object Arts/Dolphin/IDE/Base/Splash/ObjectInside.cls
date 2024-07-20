"Filed out from Dolphin Smalltalk"!

Object subclass: #ObjectInside
	instanceVariableNames: 'image edgePoints position scale rotation color baseColor matrix centerOffset baseScale attributes'
	classVariableNames: 'EdgePointResolution'
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!

ObjectInside guid: (GUID fromString: '{c019a761-9b1c-4f55-8dd3-66b8e8b2864f}')!

ObjectInside addClassConstant: 'EdgePointResolution' value: 16rA!

ObjectInside comment: ''!

!ObjectInside categoriesForClass!Kernel-Objects! !

!ObjectInside methodsFor!

attributes
	^attributes ifNil: [attributes := GdiplusImageAttributes new]!

baseScale
	^baseScale!

baseScale: aFloat
	baseScale := aFloat!

color
	"Answer the color to map the baseColor to, or nil if there is no deviation from the original"

	^color!

color: aColorOrNil
	"Set the color to map the baseColor to, or nil if there is no deviation from the original"

	color := aColorOrNil.
	color ifNil: [^self].
	self attributes remapColor: baseColor to: color!

drawOn: aGdiplusGraphics
	aGdiplusGraphics
		transform: self matrix;
		drawImage: image attributes: attributes!

edgePoints
	^edgePoints ifNil: [edgePoints := POINTLArray withAll: self findEdgePoints]!

extent
	^image extent!

findEdgePoints
	| width argb gdipluslib imageHandle height pts |
	pts := Array writeStream: 100.
	height := image height.
	width := image width.
	argb := ByteArray newFixed: 4.
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
					(argb sdwordAtOffset: 0) == 0 == found
						ifTrue: 
							[pts nextPutAll: x @ y.
							found := found not]]].
	^pts contents!

free
	image free.
	image := nil.
	attributes free.
	attributes := nil.
	self resetMatrix!

initialize
	super initialize.
	scale := 1.
	rotation := 0.
	baseColor := Color black.
	position := Point zero
!

matrix
	^matrix
		ifNil: 
			[matrix := GdiplusMatrix new
						translateTransform: position;
						rotateTransform: rotation;
						scaleTransform: scale asPoint;
						translateTransform: centerOffset;
						yourself]!

position
	^position!

position: aPoint
	position := aPoint.
	self resetMatrix!

postCopy
	image := image copy.
	self resetMatrix.
	^self!

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
	scale = aFloat ifTrue: [^self].
	scale := aFloat.
	self resetMatrix!

setImage: aGdiplusImage
	image := aGdiplusImage.
	centerOffset := image extent / -2.0!

testCollisionIn: aGdiplusBitmap
	| pixel gdiplusLib bitmapHandle |
	pixel := ByteArray new: 4.
	gdiplusLib := GdiplusLibrary default.
	bitmapHandle := aGdiplusBitmap asParameter.
	^(self matrix transformPoints: self edgePoints copy) anySatisfy: 
			[:each |
			(gdiplusLib
				gdipBitmapGetPixel: bitmapHandle
				x: each x
				y: each y
				color: pixel) == Ok
				and: [(pixel sdwordAtOffset: 0) ~~ ##(Color white argbCode asSDword)]]!

x
	^position x!

x: aNumber
	self position: aNumber @ self position y!

y
	^position y!

y: aNumber
	self position: self position x @ aNumber! !

!ObjectInside categoriesForMethods!
attributes!accessing!private! !
baseScale!accessing!public! !
baseScale:!accessing!public! !
color!accessing!public! !
color:!accessing!public! !
drawOn:!operations!public! !
edgePoints!accessing!public! !
extent!accessing!public! !
findEdgePoints!operations!private! !
free!finalizing!public! !
initialize!private! !
matrix!accessing!operations!public! !
position!public! !
position:!accessing!public! !
postCopy!copying!public! !
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

fromImage: aGdiplusImage
	^super new 	
		initialize;
		setImage:aGdiplusImage;
		yourself! !

!ObjectInside class categoriesForMethods!
fromImage:!public! !
!

