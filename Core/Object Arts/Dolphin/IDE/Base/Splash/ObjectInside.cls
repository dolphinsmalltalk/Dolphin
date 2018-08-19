"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ObjectInside
	instanceVariableNames: 'image edgePoints position scale rotation alpha color baseColor matrix'
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!
ObjectInside guid: (GUID fromString: '{c019a761-9b1c-4f55-8dd3-66b8e8b2864f}')!
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
				oldColor: self baseColor asARGB asParameter;
				newColor: col asARGB asParameter.
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

edgePointResolution
	^10!

edgePoints
	^edgePoints ifNil: [edgePoints := self findEdgePoints]!

edgePoints: anArray
	edgePoints := anArray!

extent
	^self image extent!

findEdgePoints
	| pts transparent |
	transparent := self transparentColor.
	pts := OrderedCollection new.
	0 to: self extent y + self edgePointResolution
		by: self edgePointResolution
		do: 
			[:y | 
			| found |
			found := false.
			0 to: self extent x + self edgePointResolution
				by: self edgePointResolution
				do: 
					[:x | 
					| pixel |
					pixel := self image pixelAt: (x min: self extent x-1) @ (y min: self extent y-1).
					found 
						ifFalse: 
							[pixel ~= transparent 
								ifTrue: 
									[pts add: x @ y.
									found := true]]
						ifTrue: 
							[pixel = transparent 
								ifTrue: 
									[pts add: x @ y.
									found := false]]]].
	^pts!

image
	^image!

initialize
	super initialize.
	scale := 1.
	rotation := 0.
	alpha := 1.
	baseColor := ARGB black.
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
	| pts |
	pts := self matrix transformPoints: self edgePoints.
	^(pts asArray anySatisfy: [:each | 
		([aGdiplusBitmap pixelAt: each] on: Error do: [:e | nil]) ~= ARGB white])!

transparentColor
	^##(Color
		a: 0
		r: 0
		g: 0
		b: 0)!

x
	^self position x!

x: aNumber
	self position: aNumber @ self position y!

y
	^self position y!

y: aNumber
	self position: self position x @ aNumber! !
!ObjectInside categoriesFor: #alpha!accessing!public! !
!ObjectInside categoriesFor: #alpha:!accessing!public! !
!ObjectInside categoriesFor: #baseColor!accessing!public! !
!ObjectInside categoriesFor: #baseColor:!accessing!public! !
!ObjectInside categoriesFor: #center!accessing!public! !
!ObjectInside categoriesFor: #color!accessing!public! !
!ObjectInside categoriesFor: #color:!accessing!public! !
!ObjectInside categoriesFor: #copy!copying!public! !
!ObjectInside categoriesFor: #drawEdgePointsOn:!operations!public! !
!ObjectInside categoriesFor: #drawOn:!operations!public! !
!ObjectInside categoriesFor: #edgePointResolution!constants!private! !
!ObjectInside categoriesFor: #edgePoints!accessing!public! !
!ObjectInside categoriesFor: #edgePoints:!accessing!public! !
!ObjectInside categoriesFor: #extent!accessing!public! !
!ObjectInside categoriesFor: #findEdgePoints!operations!private! !
!ObjectInside categoriesFor: #image!private! !
!ObjectInside categoriesFor: #initialize!private! !
!ObjectInside categoriesFor: #matrix!accessing!operations!public! !
!ObjectInside categoriesFor: #position!accessing!public! !
!ObjectInside categoriesFor: #position:!accessing!public! !
!ObjectInside categoriesFor: #resetMatrix!operations!public! !
!ObjectInside categoriesFor: #rotation!accessing!public! !
!ObjectInside categoriesFor: #rotation:!accessing!public! !
!ObjectInside categoriesFor: #scale!accessing!public! !
!ObjectInside categoriesFor: #scale:!accessing!public! !
!ObjectInside categoriesFor: #setImage:!private! !
!ObjectInside categoriesFor: #testCollisionIn:!accessing!public! !
!ObjectInside categoriesFor: #transparentColor!private! !
!ObjectInside categoriesFor: #x!accessing!public! !
!ObjectInside categoriesFor: #x:!accessing!public! !
!ObjectInside categoriesFor: #y!accessing!public! !
!ObjectInside categoriesFor: #y:!accessing!public! !

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
!ObjectInside class categoriesFor: #chooseFile!public! !
!ObjectInside class categoriesFor: #fromBytes:!public! !
!ObjectInside class categoriesFor: #fromImage:!public! !
!ObjectInside class categoriesFor: #fromImage:scaledBy:!public! !

