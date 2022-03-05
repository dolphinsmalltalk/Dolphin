"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusPen
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPen guid: (GUID fromString: '{f98f70c8-58ea-4592-bc70-1907f78c8bc8}')!
GdiplusPen comment: 'GdiplusPen is used to draw lines and curves.  In general, where an object has an outside and an inside, GdiplusPen draws the outside and GdiplusBrush is used to fill the inside.'!
!GdiplusPen categoriesForClass!Unclassified! !
!GdiplusPen methodsFor!

alignment
	"Answer the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	| status alignment |
	alignment := SDWORD new.
	(status := GdiplusLibrary default gdipGetPenMode: self asParameter penMode: alignment) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPenMode failed' with: status].
	^alignment value!

alignment: aPenAlignmentConstant 
	"Set the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	| status |
	(status := GdiplusLibrary default gdipSetPenMode: self asParameter penMode: aPenAlignmentConstant) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetPenMode failed' with: status]!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDeletePen: handle!

brush
	"Answer the receiver's brush, used when drawing a line."

	| status type gpHandle class |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipGetPenBrushFill: self asParameter brush: gpHandle) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPenBrushFill failed' with: status].
	type := SDWORD new.
	(status := GdiplusLibrary default gdipGetBrushType: gpHandle type: type) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetBrushType failed' with: status].
	class := ##({GdiplusSolidBrush.
				GdiplusHatchBrush.
				GdiplusTextureBrush.
				GdiplusPathGradientBrush.
				GdiplusLinearGradientBrush}) at: type value + 1.
	^class fromOwnedHandle: gpHandle!

brush: aGdiplusBrush 
	"Set the receiver to use aGdiplusBrush when drawing a line."

	| status |
	(status := GdiplusLibrary default gdipSetPenBrushFill: self asParameter
				brush: aGdiplusBrush asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenBrushFill failed' with: status]!

color
	"Answer an ARGB that is the receiver's drawing color."

	| status color |
	color := DWORD new.
	(status := GdiplusLibrary default gdipGetPenColor: self asParameter argb: color) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetPenColor failed' with: status].
	^Color fromArgbCode: color value!

color: aColor
	"Set the receiver's drawing color to the <Color> argument."

	| status |
	(status := GdiplusLibrary default gdipSetPenColor: self asParameter argb: aColor argbCode) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetPenColor failed' with: status]!

compoundArray
	| status array |
	array := FLOATArray new: self compoundArrayCount.
	(status := GdiplusLibrary default 
				gdipGetPenCompoundArray: self asParameter
				dash: array
				count: array size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPenCompoundArray failed' with: status].
	^array asArray!

compoundArray: aRealArray 
	| status |
	self assert: [aRealArray size >= 2].
	self assert: [aRealArray allSatisfy: [:each | each between: 0.0 and: 1.0]].
	self assert: [aRealArray first = 0.0 and: [aRealArray last = 1.0]].
	(status := GdiplusLibrary default 
				gdipSetPenCompoundArray: self asParameter
				dash: (FLOATArray withAll: aRealArray)
				count: aRealArray size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenCompoundArray failed' with: status]!

compoundArrayCount
	"Private - Answer the size of the receiver's compound array."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPenCompoundCount: self asParameter count: count) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPenCompoundCount failed' with: status].
	^count value!

customEndCap
	| status gpHandle |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipGetPenCustomEndCap: self asParameter customCap: gpHandle) 
		= Ok ifFalse: [GdiplusError signal: 'GdipGetPenCustomEndCap failed' with: status].
	^GdiplusCustomLineCap fromOwnedHandle: gpHandle!

customEndCap: aGdiplusCustomLineCap 
	| status |
	(status := GdiplusLibrary default gdipSetPenCustomEndCap: self asParameter
				customCap: aGdiplusCustomLineCap asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenCustomEndCap failed' with: status]!

customStartCap: aGdiplusCustomLineCap 
	| status |
	(status := GdiplusLibrary default gdipSetPenCustomStartCap: self asParameter
				customCap: aGdiplusCustomLineCap asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenCustomStartCap failed' with: status]!

dashCap: aDashCapConstant 
	"Set the dash cap of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetPenDashCap197819: self asParameter
				dashCap: aDashCapConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenDashCap197819 failed' with: status]!

dashPattern
	"Answer an array of custom dashes and spaces for the receiver."

	| status array |
	array := FLOATArray new: self dashPatternCount.
	(status := GdiplusLibrary default
				gdipGetPenDashArray: self asParameter
				dash: array
				count: array size) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPenDashArray failed' with: status].
	^array asArray!

dashPattern: aRealArray 
	"Set an array of custom dashes and spaces for the receiver."

	| status |
	(status := GdiplusLibrary default 
				gdipSetPenDashArray: self asParameter
				dash: (FLOATArray withAll: aRealArray)
				count: aRealArray size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenDashArray failed' with: status]!

dashPatternCount
	"Private - Answer the size of the receiver's dash pattern array."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPenDashCount: self asParameter count: count) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPenDashCount failed' with: status].
	^count value!

dashStyle: aDashStyleConstant 
	"Set the dash style of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetPenDashStyle: self asParameter
				dashStyle: aDashStyleConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenDashStyle failed' with: status]!

endCap: aLineCapConstant 
	| status |
	(status := GdiplusLibrary default gdipSetPenEndCap: self asParameter endCap: aLineCapConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenEndCap failed' with: status]!

lineCap: startCap endCap: endCap dashCap: dashCap 
	| status |
	(status := GdiplusLibrary default 
				gdipSetPenLineCap197819: self asParameter
				startCap: startCap
				endCap: endCap
				dashCap: dashCap) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenLineCap197819 failed' with: status]!

lineJoin: aLineJoinConstant 
	| status |
	(status := GdiplusLibrary default gdipSetPenLineJoin: self asParameter lineJoin: aLineJoinConstant) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetPenLineJoin failed' with: status]!

resetTransform
	"Set the receiver's transformation matrix to the identity matrix."

	| status |
	(status := GdiplusLibrary default gdipResetPenTransform: self asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipResetPenTransform failed' with: status]!

rotateTransform: aRealAngle order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipRotatePenTransform: self asParameter
				angle: aRealAngle
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipRotatePenTransform failed' with: status]!

scaleTransform: aRealPoint order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipScalePenTransform: self asParameter
				sx: aRealPoint x
				sy: aRealPoint y
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipScalePenTransform failed' with: status]!

startCap: aLineCapConstant 
	| status |
	(status := GdiplusLibrary default gdipSetPenStartCap: self asParameter startCap: aLineCapConstant) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetPenStartCap failed' with: status]!

transform: aGdiplusMatrix 
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetPenTransform: self asParameter
				matrix: aGdiplusMatrix asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenTransform failed' with: status]!

width
	"Answer the width of the receiver's stroke."

	| status width |
	width := FLOAT new.
	(status := GdiplusLibrary default gdipGetPenWidth: self asParameter width: width) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPenWidth failed' with: status].
	^width asFloat!

width: aNumber 
	"Set the width of the receiver's stroke."

	| status |
	(status := GdiplusLibrary default gdipSetPenWidth: self asParameter width: aNumber) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPenWidth failed' with: status]! !
!GdiplusPen categoriesForMethods!
alignment!accessing!public! !
alignment:!accessing!public! !
basicFree!private!realizing/unrealizing! !
brush!accessing!public! !
brush:!accessing!public! !
color!accessing!public! !
color:!accessing!public! !
compoundArray!accessing!public! !
compoundArray:!accessing!public! !
compoundArrayCount!accessing!private! !
customEndCap!accessing!public! !
customEndCap:!accessing!public! !
customStartCap:!accessing!public! !
dashCap:!accessing!public! !
dashPattern!accessing!public! !
dashPattern:!accessing!public! !
dashPatternCount!accessing!private! !
dashStyle:!accessing!public! !
endCap:!accessing!public! !
lineCap:endCap:dashCap:!accessing!public! !
lineJoin:!accessing!public! !
resetTransform!operations!public! !
rotateTransform:order:!operations!public! !
scaleTransform:order:!operations!public! !
startCap:!accessing!public! !
transform:!operations!public! !
width!accessing!public! !
width:!accessing!public! !
!

!GdiplusPen class methodsFor!

black
	^self color: Color black!

blue
	^self color: Color blue!

brush: aGdiplusBrush width: aFloat
	"Creates a Pen object that uses the attributes of a brush and a real number to set the width of this Pen object"

	^self 
		fromInitializer: (GdiplusPenFromBrushInitializer brush: aGdiplusBrush width: aFloat)!

color: aColor
	"Answer an instance of the receiver with the specified color and default width (1.0)."

	^self color: aColor width: nil!

color: anARGB width: aFloat
	"Answer an instance of the receiver with the specified color and width."

	^self fromInitializer: (GdiplusPenFromColorInitializer color: anARGB width: aFloat)!

exampleGdipPAttributes
	"From MSDN: Using GDI+ > Using a Pen to Draw Lines and Shapes > Setting Pen Width and Alignment

		self exampleGdipPAttributes showExample
	"

	| bitmap graphics blackPen greenPen |
	bitmap := GdiplusBitmap extent: 150 @ 300.
	graphics := bitmap graphics.
	blackPen := GdiplusPen black.
	greenPen := GdiplusPen green width: 10.
	graphics
		drawLine: (10 @ 10 corner: 100 @ 50) pen: greenPen;
		drawLine: (10 @ 10 corner: 100 @ 50) pen: blackPen;
		drawRectangle: (10 @ 100 corner: 100 @ 150) pen: greenPen;
		drawRectangle: (10 @ 100 corner: 100 @ 150) pen: blackPen.
	greenPen
		alignment: PenAlignmentInset;
		width: 15.
	graphics
		drawRectangle: (10 @ 200 corner: 100 @ 250) pen: greenPen;
		drawRectangle: (10 @ 200 corner: 100 @ 250) pen: blackPen.
	^bitmap!

exampleGdipPCompoundArray
	"This example draws several thick lines that each appear as several thinner parallel lines.

		self exampleGdipPCompoundArray showExample
	"

	| bitmap graphics pen |
	bitmap := GdiplusBitmap extent: 450 @ 350.
	graphics := bitmap graphics.
	pen := GdiplusPen blue width: 30.
	pen compoundArray: #(0 1).
	graphics
		drawLine: (10 @ 60 corner: 400 @ 60) pen: pen;
		drawString: 'compoundArray: ' 
					, (pen compoundArray collect: [:e | e roundTo: 0.1]) displayString
			at: 100 @ 10.
	pen compoundArray: #(0 0.5 0.9 1).
	graphics
		drawLine: (10 @ 160 corner: 400 @ 160) pen: pen;
		drawString: 'compoundArray: ' 
					, (pen compoundArray collect: [:e | e roundTo: 0.1]) displayString
			at: 100 @ 110.
	pen compoundArray: #(0 0.5 0.6 0.7 0.9 1).
	graphics
		drawLine: (10 @ 260 corner: 400 @ 260) pen: pen;
		drawString: 'compoundArray: ' 
					, (pen compoundArray collect: [:e | e roundTo: 0.1]) displayString
			at: 100 @ 210.
	^bitmap!

exampleGdipPCustomCaps
	"MSDN:  Pen::SetCustomStartCap and Pen::SetCustomEndCap Methods
	This example creates a GdiplusGraphicsPath object and adds a rectangle to it
	The code then creates a GdiplusPen object, sets the custom start and end caps 
	based on the path object, and draws a line.

		self exampleGdipPCustomCaps showExample
	"

	| bitmap graphics strokePath pen custCap |
	bitmap := GdiplusBitmap extent: 300 @ 200.
	graphics := bitmap graphics.
	strokePath := GdiplusGraphicsPath new addRectangle: (-10 @ -5 corner: 20 @ 10).
	pen := GdiplusPen blue.
	custCap := GdiplusCustomLineCap strokePath: strokePath.
	pen customStartCap: custCap.
	pen customEndCap: custCap.
	graphics drawLine: (20 @ 20 corner: 200 @ 100) pen: pen.
	^bitmap!

exampleGdipPDashCap
	"MSDN:  Pen::SetDashCap Method

		self exampleGdipPDashCap showExample
	"

	| bitmap graphics pen |
	bitmap := GdiplusBitmap extent: 300 @ 200.
	graphics := bitmap graphics.
	pen := GdiplusPen blue width: 15.
	pen dashStyle: DashStyleDash.
	pen dashCap: DashCapTriangle.
	graphics drawLine: (20 @ 20 corner: 280 @ 180) pen: pen.
	^bitmap!

exampleGdipPDashPattern
	"This example draws a dashed line.  An array specifies the size of each pair of dash and space.

		self exampleGdipPDashPattern showExample
	"

	| bitmap pen |
	bitmap := GdiplusBitmap extent: 450 @ 200.
	pen := GdiplusPen blue width: 5.
	pen dashPattern: #(10 2).
	(bitmap graphics)
		drawLine: (10 @ 40 extent: 400 @ 0) pen: pen;
		drawString: 'dashPattern: ' , (pen dashPattern collect: [:e | e asInteger]) displayString
			at: 50 @ 10.
	pen dashPattern: #(10 2 7 4).
	(bitmap graphics)
		drawLine: (10 @ 100 extent: 400 @ 0) pen: pen;
		drawString: 'dashPattern: ' , (pen dashPattern collect: [:e | e asInteger]) displayString
			at: 50 @ 70.
	pen dashPattern: #(10 2 2 2 2 2).
	(bitmap graphics)
		drawLine: (10 @ 160 extent: 400 @ 0) pen: pen;
		drawString: 'dashPattern: ' , (pen dashPattern collect: [:e | e asInteger]) displayString
			at: 50 @ 130.
	^bitmap!

exampleGdipPDrawing
	"MSDN:  Using GDI+ > Using a Pen to Draw Lines and Shapes > Using a Pen to Draw Lines and Rectangles 
	This example draws a line and a thick-bordered rectangle.

		self exampleGdipPDrawing showExample
	"

	| bitmap pen |
	bitmap := GdiplusBitmap extent: 350 @ 150.
	pen := GdiplusPen black.
	(bitmap graphics)
		drawLine: (20 @ 10 corner: 300 @ 100) pen: pen;
		drawRectangle: (10 @ 10 corner: 100 @ 50) pen: (pen width: 5).
	^bitmap!

exampleGdipPFillWithTexture
	"MSDN: Using GDI+ > Using a Pen to Draw Lines and Shapes > Drawing a Line Filled with a Texture
	This example creates a blank Bitmap and accesses its Graphics object.  It creates a thumbnail Image
	from an Image from a file.  It creates a Brush based on the image and a thick Pen based on the brush.
	Finally, the graphics object draws the thumbnail Image and an ellipses. 

		self exampleGdipPFillWithTexture showExample
	"

	| bitmap image brush pen |
	bitmap := GdiplusBitmap extent: 350 @ 150.
	image := (GdiplusImage fromFile: self fileResource pafEyeJpg) thumbnailWithHeight: 32.
	brush := GdiplusTextureBrush image: image.
	pen := GdiplusPen brush: brush width: 30.
	(bitmap graphics)
		drawImage: image;
		drawEllipse: (100 @ 20 extent: 200 @ 100) pen: pen.
	^bitmap!

exampleGdipPJoiningLines
	"From MSDN: Using GDI+ > Using a Pen to Draw Lines and Shapes > Joining Lines

		self exampleGdipPJoiningLines showExample
	"

	| bitmap graphics path pen x |
	bitmap := GdiplusBitmap extent: 600 @ 400.
	graphics := bitmap graphics.
	pen := GdiplusPen blue width: 15.
	self enumsLineJoin keysAndValuesDo: 
			[:i :e | 
			path := GdiplusGraphicsPath new.
			path startFigure.
			x := (i - 1) * 120.
			path addLineFrom: (x + 20) @ 50 to: (x + 70) @ 50.
			path addLineFrom: (x + 70) @ 50 to: (x + 50) @ 100.
			pen lineJoin: e value.
			graphics
				drawPath: path pen: pen;
				drawString: e key at: ((i - 1) * 120) @ 20].
	self enumsLineJoin keysAndValuesDo: 
			[:i :e | 
			path := GdiplusGraphicsPath new.
			path startFigure.
			x := (i - 1) * 120.
			path addLineFrom: (x + 20) @ 150 to: (x + 50) @ 150.
			path addLineFrom: (x + 70) @ 150 to: (x + 70) @ 200.
			pen lineJoin: e value.
			graphics drawPath: path pen: pen].
	self enumsLineJoin keysAndValuesDo: 
			[:i :e | 
			path := GdiplusGraphicsPath new.
			path startFigure.
			x := (i - 1) * 120.
			path addLineFrom: (x + 20) @ 250 to: (x + 70) @ 250.
			path addLineFrom: (x + 70) @ 250 to: (x + 90) @ 300.
			pen lineJoin: e value.
			graphics drawPath: path pen: pen].
	^bitmap!

exampleGdipPLineCaps
	"This example displays the various LineCap styles that can be used at the start and end of 
	lines drawn with a pen.  For each cap style, the pen draws a vertical and diagonal line.  
	Horizontal lines are drawn above and below all the lines to show where each line cap 
	ends relative to its line end.

		self exampleGdipPLineCaps showExample
	"

	| bitmap graphics path pen row x y |
	bitmap := GdiplusBitmap extent: 750 @ 500.
	graphics := bitmap graphics.
	path := GdiplusGraphicsPath new.
	pen := GdiplusPen red width: 9.
	self enumsLineCap keysAndValuesDo: 
			[:i :e | 
			pen startCap: e value.
			pen endCap: e value.
			row := (i - 1) // 4.
			y := row * 160 + 40.
			x := (i - 1 - (row * 4)) * 175 + 10.
			graphics
				drawLine: (x @ y extent: 100 @ 100) pen: pen;
				drawLine: ((x + 50) @ y extent: 0 @ 100) pen: pen;
				drawString: e key at: x @ (row * 160 + 5)].
	pen := GdiplusPen blue.
	0 to: 2
		do: 
			[:i | 
			graphics
				drawLine: (5 @ (i * 160 + 40) extent: 700 @ 0) pen: pen;
				drawLine: (5 @ (i * 160 + 140) extent: 700 @ 0) pen: pen].
	^bitmap!

examplesWorkspace
	"Private - These are examples in progress.  Evaluate each block separately (or all at once).

		self examplesWorkspace
	"

	| bitmap graphics pen matrix width pen2 brush |
	#GdiplusPen.

	"#transform:"
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	pen := GdiplusPen blue width: 2.
	graphics drawRectangle: (10 @ 50 extent: 150 @ 100) pen: GdiplusPen black.
	matrix := GdiplusMatrix fromArray: #(20 0 0 10 0 0).
	pen transform: matrix.
	graphics drawRectangle: (210 @ 50 extent: 150 @ 100) pen: pen.
	pen resetTransform.
	graphics drawRectangle: (10 @ 50 extent: 150 @ 100) pen: (pen color: Color red).
	bitmap showExample.

	"#scaleTransform:"
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	pen := GdiplusPen blue width: 2.
	graphics drawRectangle: (50 @ 50 extent: 150 @ 100) pen: pen.
	pen scaleTransform: 8 @ 4 order: MatrixOrderPrepend.
	graphics drawRectangle: (250 @ 50 extent: 150 @ 100) pen: pen.
	bitmap showExample.

	"#rotateTransform:"
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	pen := GdiplusPen blue width: 5.
	pen scaleTransform: 1 @ 4 order: MatrixOrderPrepend.
	pen rotateTransform: 30 order: MatrixOrderPrepend.
	graphics drawEllipse: (50 @ 50 extent: 200 @ 150) pen: pen.
	pen resetTransform.
	graphics drawEllipse: (50 @ 50 extent: 200 @ 150) pen: (pen color: Color red).
	bitmap showExample.

	"#dashStyle:"
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	pen := GdiplusPen blue width: 15.
	pen dashStyle: DashStyleDash.
	graphics drawLine: (0 @ 50 corner: 400 @ 150) pen: pen.
	pen dashStyle: DashStyleDot.
	graphics drawLine: (0 @ 80 corner: 400 @ 180) pen: pen.
	pen dashStyle: DashStyleDashDot.
	graphics drawLine: (0 @ 110 corner: 400 @ 210) pen: pen.
	bitmap showExample.

	"#brush:"
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	brush := GdiplusHatchBrush 
				style: HatchStyleVertical
				forecolor: Color red
				backcolor: Color blue.
	pen := GdiplusPen green width: 10.
	graphics drawLine: (10 @ 10 corner: 200 @ 50) pen: pen.
	pen brush: brush.
	graphics drawLine: (10 @ 10 corner: 200 @ 100) pen: pen.
	bitmap showExample!

green
	^self color: Color green!

icon
	"Answers an Icon that can be used to represent this class"

	^Pen icon!

new
	^self black!

red
	^self color: Color red! !
!GdiplusPen class categoriesForMethods!
black!instance creation!public! !
blue!instance creation!public! !
brush:width:!instance creation!public! !
color:!instance creation!public! !
color:width:!instance creation!public! !
exampleGdipPAttributes!examples!public!sunit! !
exampleGdipPCompoundArray!examples!public!sunit! !
exampleGdipPCustomCaps!examples!public!sunit! !
exampleGdipPDashCap!examples!public!sunit! !
exampleGdipPDashPattern!examples!public!sunit! !
exampleGdipPDrawing!examples!public!sunit! !
exampleGdipPFillWithTexture!examples!public!sunit! !
exampleGdipPJoiningLines!examples!public!sunit! !
exampleGdipPLineCaps!examples!public!unit tests! !
examplesWorkspace!examples!private! !
green!instance creation!public! !
icon!constants!development!public! !
new!instance creation!public! !
red!instance creation!public! !
!

