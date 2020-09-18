"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.Pen'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Pen guid: (Core.GUID fromString: '{f98f70c8-58ea-4592-bc70-1907f78c8bc8}')!
Graphics.Gdiplus.Pen comment: 'GdiplusPen is used to draw lines and curves.  In general, where an object has an outside and an inside, GdiplusPen draws the outside and GdiplusBrush is used to fill the inside.'!
!Graphics.Gdiplus.Pen categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Pen methodsFor!

alignment
	"Answer the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	| alignment |
	alignment := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPenMode: self asParameter penMode: alignment.
	^alignment sdwordAtOffset: 0!

alignment: aPenAlignmentConstant
	"Set the alignment (e.g., center or inset) of the receiver relative to a stroke that is drawn."

	GdiplusLibrary default gdipSetPenMode: self asParameter penMode: aPenAlignmentConstant!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDeletePen: handle!

brush
	"Answer the receiver's brush, used when drawing a line."

	| type gpHandle class |
	gpHandle := Handle new.
	GdiplusLibrary default gdipGetPenBrushFill: self asParameter brush: gpHandle.
	type := SDWORD new.
	GdiplusLibrary default gdipGetBrushType: gpHandle type: type.
	class := ##({SolidBrush. HatchBrush. TextureBrush. PathGradientBrush. LinearGradientBrush})
				at: type value + 1.
	^class fromOwnedHandle: gpHandle!

brush: aGdiplusBrush
	"Set the receiver to use aGdiplusBrush when drawing a line."

	GdiplusLibrary default gdipSetPenBrushFill: self asParameter brush: aGdiplusBrush asParameter!

color
	"Answer an ARGB that is the receiver's drawing color."

	| color |
	color := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPenColor: self asParameter argb: color.
	^Color fromArgbCode: (color dwordAtOffset: 0)!

color: aColor
	"Set the receiver's drawing color to the <Color> argument."

	GdiplusLibrary default gdipSetPenColor: self asParameter argb: aColor argbCode!

compoundArray
	| array |
	array := FLOATArray new: self compoundArrayCount.
	GdiplusLibrary default
		gdipGetPenCompoundArray: self asParameter
		dash: array
		count: array size.
	^array asArray!

compoundArray: aRealArray
	self assert: [aRealArray size >= 2].
	self assert: [aRealArray allSatisfy: [:each | each between: 0.0 and: 1.0]].
	self assert: [aRealArray first = 0.0 and: [aRealArray last = 1.0]].
	GdiplusLibrary default
		gdipSetPenCompoundArray: self asParameter
		dash: (FLOATArray withAll: aRealArray)
		count: aRealArray size!

compoundArrayCount
	"Private - Answer the size of the receiver's compound array."

	| count |
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPenCompoundCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

customEndCap
	| gpHandle |
	gpHandle := Handle new.
	GdiplusLibrary default gdipGetPenCustomEndCap: self asParameter customCap: gpHandle.
	^CustomLineCap fromOwnedHandle: gpHandle!

customEndCap: aGdiplusCustomLineCap
	GdiplusLibrary default gdipSetPenCustomEndCap: self asParameter
		customCap: aGdiplusCustomLineCap asParameter!

customStartCap: aGdiplusCustomLineCap
	GdiplusLibrary default gdipSetPenCustomStartCap: self asParameter
		customCap: aGdiplusCustomLineCap asParameter!

dashCap: aDashCapConstant
	"Set the dash cap of the receiver."

	GdiplusLibrary default gdipSetPenDashCap197819: self asParameter dashCap: aDashCapConstant!

dashPattern
	"Answer an array of custom dashes and spaces for the receiver."

	| array |
	array := FLOATArray new: self dashPatternCount.
	GdiplusLibrary default
		gdipGetPenDashArray: self asParameter
		dash: array
		count: array size.
	^array asArray!

dashPattern: aRealArray
	"Set an array of custom dashes and spaces for the receiver."

	GdiplusLibrary default
		gdipSetPenDashArray: self asParameter
		dash: (FLOATArray withAll: aRealArray)
		count: aRealArray size!

dashPatternCount
	"Private - Answer the size of the receiver's dash pattern array."

	| count |
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPenDashCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

dashStyle: aDashStyleConstant
	"Set the dash style of the receiver."

	GdiplusLibrary default gdipSetPenDashStyle: self asParameter dashStyle: aDashStyleConstant!

endCap: aLineCapConstant
	GdiplusLibrary default gdipSetPenEndCap: self asParameter endCap: aLineCapConstant!

lineCap: startCap endCap: endCap dashCap: dashCap
	GdiplusLibrary default
		gdipSetPenLineCap197819: self asParameter
		startCap: startCap
		endCap: endCap
		dashCap: dashCap!

lineJoin: aLineJoinConstant
	GdiplusLibrary default gdipSetPenLineJoin: self asParameter lineJoin: aLineJoinConstant!

resetTransform
	"Set the receiver's transformation matrix to the identity matrix."

	GdiplusLibrary default gdipResetPenTransform: self asParameter!

rotateTransform: aRealAngle order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipRotatePenTransform: self asParameter
		angle: aRealAngle
		order: aMatrixOrderConstant!

scaleTransform: aRealPoint order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipScalePenTransform: self asParameter
		sx: aRealPoint x
		sy: aRealPoint y
		order: aMatrixOrderConstant!

startCap: aLineCapConstant
	GdiplusLibrary default gdipSetPenStartCap: self asParameter startCap: aLineCapConstant!

transform: aGdiplusMatrix
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	GdiplusLibrary default gdipSetPenTransform: self asParameter matrix: aGdiplusMatrix asParameter!

width
	"Answer the width of the receiver's stroke."

	| width |
	width := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPenWidth: self asParameter width: width.
	^width floatAtOffset: 0!

width: aNumber
	"Set the width of the receiver's stroke."

	GdiplusLibrary default gdipSetPenWidth: self asParameter width: aNumber! !
!Graphics.Gdiplus.Pen categoriesFor: #alignment!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #alignment:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Gdiplus.Pen categoriesFor: #brush!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #brush:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #color!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #color:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #compoundArray!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #compoundArray:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #compoundArrayCount!accessing!private! !
!Graphics.Gdiplus.Pen categoriesFor: #customEndCap!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #customEndCap:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #customStartCap:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #dashCap:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #dashPattern!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #dashPattern:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #dashPatternCount!accessing!private! !
!Graphics.Gdiplus.Pen categoriesFor: #dashStyle:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #endCap:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #lineCap:endCap:dashCap:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #lineJoin:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #resetTransform!operations!public! !
!Graphics.Gdiplus.Pen categoriesFor: #rotateTransform:order:!operations!public! !
!Graphics.Gdiplus.Pen categoriesFor: #scaleTransform:order:!operations!public! !
!Graphics.Gdiplus.Pen categoriesFor: #startCap:!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #transform:!operations!public! !
!Graphics.Gdiplus.Pen categoriesFor: #width!accessing!public! !
!Graphics.Gdiplus.Pen categoriesFor: #width:!accessing!public! !

!Graphics.Gdiplus.Pen class methodsFor!

black
	^self color: Color black!

blue
	^self color: Color blue!

brush: aGdiplusBrush width: aFloat
	"Creates a Pen object that uses the attributes of a brush and a real number to set the width of this Pen object"

	^self fromInitializer: (PenFromBrushInitializer brush: aGdiplusBrush width: aFloat)!

color: aColor
	"Answer an instance of the receiver with the specified color and default width (1.0)."

	^self color: aColor width: nil!

color: anARGB width: aFloat
	"Answer an instance of the receiver with the specified color and width."

	^self fromInitializer: (PenFromColorInitializer color: anARGB width: aFloat)!

exampleGdipPAttributes
	"From MSDN: Using GDI+ > Using a Pen to Draw Lines and Shapes > Setting Pen Width and Alignment

		self exampleGdipPAttributes showExample
	"

	| bitmap graphics blackPen greenPen |
	bitmap := Bitmap extent: 150 @ 300.
	graphics := bitmap graphics.
	blackPen := Pen black.
	greenPen := Pen green width: 10.
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
	bitmap := Bitmap extent: 450 @ 350.
	graphics := bitmap graphics.
	pen := Pen blue width: 30.
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
	bitmap := Bitmap extent: 300 @ 200.
	graphics := bitmap graphics.
	strokePath := Path new addRectangle: (-10 @ -5 corner: 20 @ 10).
	pen := Pen blue.
	custCap := CustomLineCap strokePath: strokePath.
	pen customStartCap: custCap.
	pen customEndCap: custCap.
	graphics drawLine: (20 @ 20 corner: 200 @ 100) pen: pen.
	^bitmap!

exampleGdipPDashCap
	"MSDN:  Pen::SetDashCap Method

		self exampleGdipPDashCap showExample
	"

	| bitmap graphics pen |
	bitmap := Bitmap extent: 300 @ 200.
	graphics := bitmap graphics.
	pen := Pen blue width: 15.
	pen dashStyle: DashStyleDash.
	pen dashCap: DashCapTriangle.
	graphics drawLine: (20 @ 20 corner: 280 @ 180) pen: pen.
	^bitmap!

exampleGdipPDashPattern
	"This example draws a dashed line.  An array specifies the size of each pair of dash and space.

		self exampleGdipPDashPattern showExample
	"

	| bitmap pen |
	bitmap := Bitmap extent: 450 @ 200.
	pen := Pen blue width: 5.
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
	bitmap := Bitmap extent: 350 @ 150.
	pen := Pen black.
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
	bitmap := Bitmap extent: 350 @ 150.
	image := (Image fromFile: self fileResource pafEyeJpg) thumbnailWithHeight: 32.
	brush := TextureBrush image: image.
	pen := Pen brush: brush width: 30.
	(bitmap graphics)
		drawImage: image;
		drawEllipse: (100 @ 20 extent: 200 @ 100) pen: pen.
	^bitmap
!

exampleGdipPJoiningLines
	"From MSDN: Using GDI+ > Using a Pen to Draw Lines and Shapes > Joining Lines

		self exampleGdipPJoiningLines showExample
	"

	| bitmap graphics path pen x |
	bitmap := Bitmap extent: 600 @ 400.
	graphics := bitmap graphics.
	pen := Pen blue width: 15.
	self enumsLineJoin keysAndValuesDo: 
			[:i :e |
			path := Path new.
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
			path := Path new.
			path startFigure.
			x := (i - 1) * 120.
			path addLineFrom: (x + 20) @ 150 to: (x + 50) @ 150.
			path addLineFrom: (x + 70) @ 150 to: (x + 70) @ 200.
			pen lineJoin: e value.
			graphics drawPath: path pen: pen].
	self enumsLineJoin keysAndValuesDo: 
			[:i :e |
			path := Path new.
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

	| bitmap graphics pen row x y |
	bitmap := Bitmap extent: 750 @ 500.
	graphics := bitmap graphics.
	pen := Pen red width: 9.
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
	pen := Pen blue.
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

	| bitmap graphics pen matrix brush |
	#GdiplusPen.

	"#transform:"
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	pen := Pen blue width: 2.
	graphics drawRectangle: (10 @ 50 extent: 150 @ 100) pen: Pen black.
	matrix := Matrix fromArray: #(20 0 0 10 0 0).
	pen transform: matrix.
	graphics drawRectangle: (210 @ 50 extent: 150 @ 100) pen: pen.
	pen resetTransform.
	graphics drawRectangle: (10 @ 50 extent: 150 @ 100) pen: (pen color: Color red).
	bitmap showExample.

	"#scaleTransform:"
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	pen := Pen blue width: 2.
	graphics drawRectangle: (50 @ 50 extent: 150 @ 100) pen: pen.
	pen scaleTransform: 8 @ 4 order: MatrixOrderPrepend.
	graphics drawRectangle: (250 @ 50 extent: 150 @ 100) pen: pen.
	bitmap showExample.

	"#rotateTransform:"
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	pen := Pen blue width: 5.
	pen scaleTransform: 1 @ 4 order: MatrixOrderPrepend.
	pen rotateTransform: 30 order: MatrixOrderPrepend.
	graphics drawEllipse: (50 @ 50 extent: 200 @ 150) pen: pen.
	pen resetTransform.
	graphics drawEllipse: (50 @ 50 extent: 200 @ 150) pen: (pen color: Color red).
	bitmap showExample.

	"#dashStyle:"
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	pen := Pen blue width: 15.
	pen dashStyle: DashStyleDash.
	graphics drawLine: (0 @ 50 corner: 400 @ 150) pen: pen.
	pen dashStyle: DashStyleDot.
	graphics drawLine: (0 @ 80 corner: 400 @ 180) pen: pen.
	pen dashStyle: DashStyleDashDot.
	graphics drawLine: (0 @ 110 corner: 400 @ 210) pen: pen.
	bitmap showExample.

	"#brush:"
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	brush := HatchBrush 
				style: HatchStyleVertical
				forecolor: Color red
				backcolor: Color blue.
	pen := Pen green width: 10.
	graphics drawLine: (10 @ 10 corner: 200 @ 50) pen: pen.
	pen brush: brush.
	graphics drawLine: (10 @ 10 corner: 200 @ 100) pen: pen.
	bitmap showExample!

green
	^self color: Color green!

icon
	"Answers an Icon that can be used to represent this class"

	^Graphics.Pen icon!

new
	^self black!

red
	^self color: Color red! !
!Graphics.Gdiplus.Pen class categoriesFor: #black!instance creation!public! !
!Graphics.Gdiplus.Pen class categoriesFor: #blue!instance creation!public! !
!Graphics.Gdiplus.Pen class categoriesFor: #brush:width:!instance creation!public! !
!Graphics.Gdiplus.Pen class categoriesFor: #color:!instance creation!public! !
!Graphics.Gdiplus.Pen class categoriesFor: #color:width:!instance creation!public! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPAttributes!examples!public!sunit! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPCompoundArray!examples!public!sunit! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPCustomCaps!examples!public!sunit! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPDashCap!examples!public!sunit! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPDashPattern!examples!public!sunit! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPDrawing!examples!public!sunit! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPFillWithTexture!examples!public!sunit! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPJoiningLines!examples!public!sunit! !
!Graphics.Gdiplus.Pen class categoriesFor: #exampleGdipPLineCaps!examples!public!unit tests! !
!Graphics.Gdiplus.Pen class categoriesFor: #examplesWorkspace!examples!private! !
!Graphics.Gdiplus.Pen class categoriesFor: #green!instance creation!public! !
!Graphics.Gdiplus.Pen class categoriesFor: #icon!constants!development!public! !
!Graphics.Gdiplus.Pen class categoriesFor: #new!instance creation!public! !
!Graphics.Gdiplus.Pen class categoriesFor: #red!instance creation!public! !

