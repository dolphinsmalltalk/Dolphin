"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusImageAttributes
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusImageAttributes guid: (GUID fromString: '{c5f76a31-54e8-45a9-905c-14e9d8ae7c0d}')!

GdiplusImageAttributes comment: 'A GdiplusImageAttributes object contains information about how bitmap and metafile colors are manipulated during rendering.  Accessors are available to adjust color, grayscale, gamma, brightness, transparency, and more.  Typically you will initialize an instance, change some settings, and pass the instance to a GdiplusGraphics drawImage method.'!

!GdiplusImageAttributes categoriesForClass!Unclassified! !

!GdiplusImageAttributes methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDisposeImageAttributes: handle!

colorKeys: aColorAdjustTypeConstant colorLow: lowARGB colorHigh: highARGB 
	| status |
	(status := GdiplusLibrary default 
				gdipSetImageAttributesColorKeys: self asParameter
				type: aColorAdjustTypeConstant
				enableFlag: true asParameter
				colorLow: lowARGB argbCode
				colorHigh: highARGB argbCode) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetImageAttributesColorKeys failed' with: status]!

colorMatrix: aColorMatrix
	"Set the receiver's color-adjustment matrix."

	self 
		colorMatrix: aColorMatrix
		type: ColorAdjustTypeDefault
		mode: ColorMatrixFlagsDefault!

colorMatrix: aColorMatrix type: aColorAdjustTypeConstant mode: aColorMatrixFlagsConstant 
	"Set the receiver's color-adjustment matrix for a specified category."

	| status |
	(status := GdiplusLibrary default 
				gdipSetImageAttributesColorMatrix: self asParameter
				type: aColorAdjustTypeConstant
				enableFlag: true asParameter
				colorMatrix: aColorMatrix asParameter
				grayMatrix: nil
				flags: aColorMatrixFlagsConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetImageAttributesColorMatrix  failed' with: status]!

gamma: aFloat
	"Set the receiver's gamma value for all categories that do not have adjustment settings of their own."

	self gamma: aFloat type: ColorAdjustTypeDefault!

gamma: aFloat type: aColorAdjustTypeConstant 
	"Set the receiver's gamma value for the specified color adjustment category."

	| status |
	(status := GdiplusLibrary default 
				gdipSetImageAttributesGamma: self asParameter
				type: aColorAdjustTypeConstant
				enableFlag: true asParameter
				gamma: aFloat) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetImageAttributesGamma  failed' with: status]!

outputChannel: aColorAdjustTypeConstant channelFlags: channelFlags 
	| status |
	(status := GdiplusLibrary default 
				gdipSetImageAttributesOutputChannel: self asParameter
				type: aColorAdjustTypeConstant
				enableFlag: true asParameter
				channelFlags: channelFlags) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetImageAttributesOutputChannel failed' with: status]!

remapTable: aColorMapArray
	^self remapTable: aColorMapArray type: ColorAdjustTypeDefault!

remapTable: aColorMapArray type: aColorAdjustTypeConstant 
	| status |
	(status := GdiplusLibrary default 
				gdipSetImageAttributesRemapTable: self asParameter
				type: aColorAdjustTypeConstant
				enableFlag: true asParameter
				mapSize: aColorMapArray size
				map: aColorMapArray) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetImageAttributesRemapTable failed' with: status]!

threshold: aFloat
	"Set the receiver's threshold (transparency range)."

	self threshold: aFloat type: ColorAdjustTypeDefault!

threshold: aFloat type: aColorAdjustTypeConstant 
	"Set the receiver's threshold (transparency range) for a specified category."

	| status |
	(status := GdiplusLibrary default 
				gdipSetImageAttributesThreshold: self asParameter
				type: aColorAdjustTypeConstant
				enableFlag: true asParameter
				threshold: aFloat) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetImageAttributesThreshold  failed' with: status]! !

!GdiplusImageAttributes categoriesForMethods!
basicFree!private!realizing/unrealizing! !
colorKeys:colorLow:colorHigh:!accessing!public! !
colorMatrix:!accessing!public! !
colorMatrix:type:mode:!accessing!public! !
gamma:!accessing!public! !
gamma:type:!accessing!public! !
outputChannel:channelFlags:!accessing!public! !
remapTable:!accessing!public! !
remapTable:type:!accessing!public! !
threshold:!accessing!public! !
threshold:type:!accessing!public! !
!

!GdiplusImageAttributes class methodsFor!

exampleColorBars1
	| bitmap |
	bitmap := GdiplusBitmap extent: 160 @ 120.
	(bitmap graphics)
		fillRectangle: (0 @ 0 extent: 40 @ 120) brush: GdiplusSolidBrush black;
		fillRectangle: (40 @ 0 extent: 40 @ 120) brush: GdiplusSolidBrush red;
		fillRectangle: (80 @ 0 extent: 40 @ 120) brush: GdiplusSolidBrush green;
		fillRectangle: (120 @ 0 extent: 40 @ 120) brush: GdiplusSolidBrush blue.
	^bitmap!

exampleColorBars2
	| bitmap |
	bitmap := GdiplusBitmap extent: 160 @ 120.
	(bitmap graphics)
		fillRectangle: (0 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0.4 0.4 0.4)));
		fillRectangle: (40 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0.4 0.2 0.2)));
		fillRectangle: (80 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0.2 0.4 0.2)));
		fillRectangle: (120 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0.4 0.4 0.8))).
	^bitmap!

exampleColorBars3
	| bitmap |
	bitmap := GdiplusBitmap extent: 160 @ 120.
	(bitmap graphics)
		fillRectangle: (0 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0.6 0.6 0.6)));
		fillRectangle: (40 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0 1 1)));
		fillRectangle: (80 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 1 1 0)));
		fillRectangle: (120 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 1 0 1))).
	^bitmap!

exampleColorBars4
	| bitmap |
	bitmap := GdiplusBitmap extent: 160 @ 120.
	(bitmap graphics)
		fillRectangle: (0 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0 0 1)));
		fillRectangle: (40 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0.5 1 0.5)));
		fillRectangle: (80 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 1 1 0)));
		fillRectangle: (120 @ 0 extent: 40 @ 120)
			brush: (GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0.4 0.4 0.4))).
	^bitmap!

exampleColorKeyTest
	| bitmap |
	bitmap := GdiplusBitmap extent: 160 @ 120.
	(bitmap graphics)
		fillRectangle: (0 @ 0 extent: 160 @ 40)
			brush: (GdiplusSolidBrush color: (Color fromArray: #(255 90 90 20)));
		fillRectangle: (0 @ 40 extent: 160 @ 40)
			brush: (GdiplusSolidBrush color: (Color fromArray: #(255 130 130 40)));
		fillRectangle: (0 @ 80 extent: 160 @ 40)
			brush: (GdiplusSolidBrush color: (Color fromArray: #(255 150 150 150))).
	^bitmap!

exampleGdipIAAlphaBlending
	"Using GDI+ .... Alpha Blending Lines and Fills ... Using a Color Matrix to Set Alpha Values in Images

		self exampleGdipIAAlphaBlending showExample
	"

	| bitmap graphics image pen colorMatrix imageAtt |
	bitmap := GdiplusBitmap extent: 250 @ 150.
	graphics := bitmap graphics.
	image := GdiplusBitmap fromFile: self fileResource pafFish32x32png.
	"Initialize the color matrix and change the value at row 4 column 4."
	colorMatrix := GpColorMatrix identity atPoint: 4 @ 4 put: 0.8.
	"Create an ImageAttributes object and set its color matrix. "
	imageAtt := GdiplusImageAttributes new colorMatrix: colorMatrix.
	"First draw a wide black line. "
	pen := GdiplusPen color: (Color fromArray: #(255 0 0 0)) width: 5.
	graphics drawLine: (10 @ 55 corner: 200 @ 55) pen: pen.
	"Now draw the semitransparent bitmap image"
	graphics 
		drawImage: image
		at: 30 @ 0
		extent: image extent * 3
		from: 0 @ 0
		extent: image extent
		unit: UnitPixel
		attributes: imageAtt.
	^bitmap!

exampleGdipIAColorKey
	"MSDN:  ImageAttributes::SetColorKey Method 

		self exampleGdipIAColorKey showExample
	"

	| bitmap graphics image imageAtt |
	bitmap := GdiplusBitmap extent: 450 @ 250.
	graphics := bitmap graphics.
	image := GdiplusImageAttributes exampleColorKeyTest.
	(imageAtt := GdiplusImageAttributes new) 
		colorKeys: ColorAdjustTypeBitmap
		colorLow: (Color fromArray: #(255 100 95 30))
		colorHigh: (Color fromArray: #(255 250 245 60)).
	graphics
		drawImage: image at: 10 @ 70;
		drawImage: image
			at: 210 @ 70
			extent: image extent
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAtt;
		drawString: 'Original' at: 10 @ 40;
		drawString: 'Color key set - middle stripe is transparent'
			layoutRect: (210 @ 20 extent: 220 @ 50).
	^bitmap!

exampleGdipIAColorMatrix
	"MSDN:  GDI+ >  Using GDI+ >  Recoloring > Using a Color Matrix to Transform a Single Color

		self exampleGdipIAColorMatrix showExample
 	"

	| bitmap image brush colorMatrix imageAttributes |
	image := GdiplusBitmap extent: 160 @ 120.
	"Create an image that's a solid color."
	brush := GdiplusSolidBrush color: (Color fromNormalizedArray: #(1 0.2 0 0.4)).
	image graphics fillRectangle: (Point zero extent: image extent) brush: brush.
	"Create a color matrix and draw the image unchanged and changed."
	(colorMatrix := GpColorMatrix identity)
		atPoint: 1 @ 1 put: 2;
		atPoint: 5 @ 1 put: 0.2;
		atPoint: 5 @ 2 put: 0.2;
		atPoint: 5 @ 3 put: 0.2.
	imageAttributes := GdiplusImageAttributes new colorMatrix: colorMatrix.
	bitmap := GdiplusBitmap extent: 400 @ 330.
	(bitmap graphics)
		drawImage: image at: 10 @ 10;
		drawImage: image
			at: 200 @ 10
			extent: image extent
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAttributes.
	"Using the same color matrix, draw a picture, unchanged and changed."
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	(bitmap graphics)
		drawImage: image
			at: 10 @ 150
			extent: image extent / 4;
		drawImage: image
			at: 200 @ 150
			extent: image extent / 4
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAttributes.
	^bitmap!

exampleGdipIAColorRemap
	"MSDN:  GDI+ >  Using GDI+ >  Recoloring > Using a Color Remap Table
	Remapping is the process of converting the colors in an image according to a color remap table,
	an array of GpColorMap structures, each of which contains an oldColor and a newColor.
	This example creates a remap table with a single entry that maps all red pixels to blue.

		self exampleGdipIAColorRemap showExample
 	"

	| image table imageAttributes bitmap |
	image := self exampleRemapInput.
	table := StructureArray length: 1 elementClass: GpColorMap.
	(table at: 1)
		oldColor: Color red argbCode;
		newColor: Color blue argbCode.
	imageAttributes := GdiplusImageAttributes new remapTable: table.
	bitmap := GdiplusBitmap extent: 400 @ 200.
	bitmap graphics
		drawImage: image at: 10 @ 10;
		drawImage: image
			at: 200 @ 10
			extent: image extent
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAttributes;
		drawString: 'Using a remap table - map red to blue' at: 50 @ 150.
	^bitmap!

exampleGdipIAGamma
	" GDI+ Ref .... Classes ... ImageAttributes::SetGamma Method

		self exampleGdipIAGamma showExample
	"

	| image graphics bitmap imageAtt |
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	imageAtt := GdiplusImageAttributes new.
	imageAtt gamma: 0.7 type: ColorAdjustTypeBitmap.
	bitmap := GdiplusBitmap extent: 700 @ 300.
	graphics := bitmap graphics.
	graphics
		drawImage: image
			at: 25 @ 25
			extent: (image extent / 2) rounded;
		drawImage: image
			at: 350 @ 25
			extent: (image extent / 2) rounded
			from: 0 @ 0
			extent: image extent
			unit: UnitPixel
			attributes: imageAtt.
	^bitmap!

exampleGdipIAOutputChannel
	"MSDN:  ImageAttributes::SetOutputChannel Method 
	This example displays the CMYK intensities of an image.

		self exampleGdipIAOutputChannel showExample
	"

	| bitmap graphics image imageAtt |
	bitmap := GdiplusBitmap extent: 550 @ 200.
	graphics := bitmap graphics.
	image := GdiplusImage fromFile: self fileResource pafMosaic2Bmp.
	graphics
		drawString: 'CMYK intensities of an image' at: 150 @ 10;
		drawString: 'Original' at: 10 @ 50;
		drawString: 'Cyan' at: 110 @ 50;
		drawString: 'Magenta' at: 210 @ 50;
		drawString: 'Yellow' at: 310 @ 50;
		drawString: 'Black' at: 410 @ 50.
	graphics drawImage: image at: 10 @ 70.
	imageAtt := GdiplusImageAttributes new.
	imageAtt outputChannel: ColorAdjustTypeBitmap channelFlags: ColorChannelFlagsC.
	graphics 
		drawImage: image
		at: 110 @ 70
		extent: image extent
		from: Point zero
		extent: image extent
		unit: UnitPixel
		attributes: imageAtt.
	imageAtt outputChannel: ColorAdjustTypeBitmap channelFlags: ColorChannelFlagsM.
	graphics 
		drawImage: image
		at: 210 @ 70
		extent: image extent
		from: Point zero
		extent: image extent
		unit: UnitPixel
		attributes: imageAtt.
	imageAtt outputChannel: ColorAdjustTypeBitmap channelFlags: ColorChannelFlagsY.
	graphics 
		drawImage: image
		at: 310 @ 70
		extent: image extent
		from: Point zero
		extent: image extent
		unit: UnitPixel
		attributes: imageAtt.
	imageAtt outputChannel: ColorAdjustTypeBitmap channelFlags: ColorChannelFlagsK.
	graphics 
		drawImage: image
		at: 410 @ 70
		extent: image extent
		from: Point zero
		extent: image extent
		unit: UnitPixel
		attributes: imageAtt.
	^bitmap!

exampleGdipIAScaleColors
	"MSDN:  GDI+ >  Using GDI+ >  Recoloring > Scaling Colors
	A scaling multiples one or more of the four color components by a number. The color matrix's 
	diagonal (1@1 through 4@4) has values that correspond to scalings for red, green, blue and alpha.  
	This example displays two rows:  In the first row, a set of color bars is shown unchanged and then
	with the blue component scaled by 2.  A picture with the blue component scaled is also shown.  
	The second row shows a different set of color bars, first unchanged, then with rgb components 
	scaled.  Again, a picture is shown with rgb scaled.

		self exampleGdipIAScaleColors showExample
 	"

	| bitmap bars image brush colorMatrix imageAttributes |
	bars := self exampleColorBars2.
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	colorMatrix := GpColorMatrix identity.
	colorMatrix atPoint: 3 @ 3 put: 2.
	imageAttributes := GdiplusImageAttributes new.
	imageAttributes colorMatrix: colorMatrix.
	bitmap := GdiplusBitmap extent: 600 @ 300.
	(bitmap graphics)
		drawImage: bars at: 10 @ 10;
		drawImage: bars
			at: 200 @ 10
			extent: bars extent
			from: Point zero
			extent: bars extent
			unit: UnitPixel
			attributes: imageAttributes;
		drawImage: image
			at: 400 @ 10
			extent: image extent / 4
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAttributes.
	"Using the same color matrix, draw a picture, unchanged and changed."
	bars := self exampleColorBars3.
	colorMatrix
		atPoint: 1 @ 1 put: 0.75;
		atPoint: 2 @ 2 put: 0.65;
		atPoint: 3 @ 3 put: 0.5.
	imageAttributes colorMatrix: colorMatrix.
	(bitmap graphics)
		drawImage: bars at: 10 @ 150;
		drawImage: bars
			at: 200 @ 150
			extent: bars extent
			from: Point zero
			extent: bars extent
			unit: UnitPixel
			attributes: imageAttributes;
		drawImage: image
			at: 400 @ 150
			extent: image extent / 4
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAttributes.
	^bitmap!

exampleGdipIAShearColors
	"MSDN:  GDI+ >  Using GDI+ >  Recoloring > Shearing Colors
	Shearing increases or decreases a color component by an amount proportional to another color
	component. This example increases the red component by one half the value of the blue component.
.
		self exampleGdipIAShearColors showExample
 	"

	| bitmap image brush colorMatrix imageAttributes |
	image := self exampleColorBars4.
	colorMatrix := GpColorMatrix identity.
	colorMatrix atPoint: 3 @ 1 put: 0.5.
	imageAttributes := GdiplusImageAttributes new.
	imageAttributes colorMatrix: colorMatrix.
	bitmap := GdiplusBitmap extent: 600 @ 150.
	(bitmap graphics)
		drawImage: image at: 10 @ 10;
		drawImage: image
			at: 200 @ 10
			extent: image extent
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAttributes.
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	bitmap graphics 
		drawImage: image
		at: 400 @ 10
		extent: image extent / 4
		from: Point zero
		extent: image extent
		unit: UnitPixel
		attributes: imageAttributes.
	^bitmap!

exampleGdipIAThreshold
	" GDI+ Ref .... Classes ... ImageAttributes::SetThreshold Method 

		self exampleGdipIAThreshold showExample
	"

	| bitmap graphics image imageAtt |
	bitmap := GdiplusBitmap extent: 300 @ 150.
	graphics := bitmap graphics.
	image := GdiplusImage fromFile: self fileResource pafFish32x32png.
	"Create an ImageAttributes object, and set its bitmap threshold."
	imageAtt := GdiplusImageAttributes new threshold: 0.6.
	graphics 
		drawImage: image
		at: 100 @ 10
		extent: image extent * 3
		from: 0 @ 0
		extent: image extent
		unit: UnitPixel
		attributes: imageAtt.
	^bitmap!

exampleGdipIATranslateColors
	"MSDN:  GDI+ >  Using GDI+ >  Recoloring > Translating Colors
	A translation adds a value to one or more of the four color components. The color matrix's fifth
	row (5@1 through 5@4) has values that correspond to translations for red, green, blue and alpha.  
	This example adds .75 to the red component of each pixel in two images.

		self exampleGdipIATranslateColors showExample
 	"

	| bitmap image brush colorMatrix imageAttributes |
	image := self exampleColorBars1.
	colorMatrix := GpColorMatrix identity.
	colorMatrix atPoint: 5 @ 1 put: 0.75.
	imageAttributes := GdiplusImageAttributes new colorMatrix: colorMatrix.
	bitmap := GdiplusBitmap extent: 400 @ 300.
	(bitmap graphics)
		drawImage: image at: 10 @ 10;
		drawImage: image
			at: 200 @ 10
			extent: image extent
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAttributes.
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	(bitmap graphics)
		drawImage: image
			at: 10 @ 150
			extent: image extent / 4;
		drawImage: image
			at: 200 @ 150
			extent: image extent / 4
			from: Point zero
			extent: image extent
			unit: UnitPixel
			attributes: imageAttributes.
	^bitmap!

exampleRemapInput
	| bitmap |
	bitmap := GdiplusBitmap extent: 160 @ 120.
	bitmap graphics
		clear: Color red;
		fillRectangle: (50 @ 40 corner: 115 @ 80) brush: (GdiplusSolidBrush color: Color yellow);
		fillEllipse: (30 @ 20 corner: 70 @ 100) brush: (GdiplusSolidBrush color: Color cyan);
		fillRectangle: (80 @ 70 corner: 140 @ 100) brush: (GdiplusSolidBrush color: Color green);
		fillEllipse: (80 @ 20 corner: 140 @ 50) brush: (GdiplusSolidBrush color: Color magenta).
	^bitmap!

new
	^self fromInitializer: GdiplusImageAttributesInitializer default! !

!GdiplusImageAttributes class categoriesForMethods!
exampleColorBars1!examples!private! !
exampleColorBars2!examples!private! !
exampleColorBars3!examples!private! !
exampleColorBars4!examples!private! !
exampleColorKeyTest!examples!private! !
exampleGdipIAAlphaBlending!examples!public!sunit! !
exampleGdipIAColorKey!examples!public!sunit! !
exampleGdipIAColorMatrix!examples!public!sunit! !
exampleGdipIAColorRemap!examples!public!sunit! !
exampleGdipIAGamma!examples!public!sunit! !
exampleGdipIAOutputChannel!examples!public!sunit! !
exampleGdipIAScaleColors!examples!public!sunit! !
exampleGdipIAShearColors!examples!public!sunit! !
exampleGdipIAThreshold!examples!public!sunit! !
exampleGdipIATranslateColors!examples!public!sunit! !
exampleRemapInput!examples!private! !
new!instance creation!public! !
!

