"Filed out from Dolphin Smalltalk 7"!

GdiplusBase subclass: #GdiplusCustomLineCap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusCustomLineCap guid: (GUID fromString: '{ea986b35-8426-11d7-b609-00e0987e8081}')!
GdiplusCustomLineCap comment: 'GdiplusCustomLineCap defines the style of graphic used to draw the ends of a line. It can be various shapes, such as a square, circle, or diamond and is defined by the path that draws it. The path is drawn by using a Pen object to draw the outline of a shape or by using a Brush object to fill the interior. The cap can be used on either or both ends of the line. Spacing can be adjusted between the end caps and the line.

'!
!GdiplusCustomLineCap categoriesForClass!Unclassified! !
!GdiplusCustomLineCap methodsFor!

baseCap
	"Answer a LineCap integer that represents the style of the base cap used at the end of a line."

	| status linecap |
	linecap := SDWORD new.
	(status := GdiplusLibrary default gdipGetCustomLineCapBaseCap: self asParameter baseCap: linecap) 
		= Ok ifFalse: [GdiplusError signal: 'GdipGetCustomLineCapBaseCap failed' with: status].
	^linecap value!

baseCap: aLineCapConstant 
	"Set the style of the base cap used at the end of a line to that represented by aLineCapConstant."

	| status |
	(status := GdiplusLibrary default gdipSetCustomLineCapBaseCap: self asParameter
				baseCap: aLineCapConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetCustomLineCapBaseCap failed' with: status]!

baseInset
	"Answer the distance between the base cap to the start of the line."

	| status baseInset |
	baseInset := FLOAT new.
	(status := GdiplusLibrary default gdipGetCustomLineCapBaseInset: self asParameter inset: baseInset)
		= Ok ifFalse: [GdiplusError signal: 'GdipGetCustomLineCapBaseInset failed' with: status].
	^baseInset value!

baseInset: aNumber 
	"Set the distance between the base cap to the start of the line."

	| status |
	(status := GdiplusLibrary default gdipSetCustomLineCapBaseInset: self asParameter inset: aNumber) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetCustomLineCapBaseInset failed' with: status]!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteCustomLineCap: handle!

clone
	"Answer a copy of the receiver."

	| status gpHandle |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipCloneCustomLineCap: self handle clonedCap: gpHandle) = Ok 
		ifFalse: [^GdiplusError signal: 'Error in GdipCloneCustomLineCap' with: status].
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

endCap
	"Answer the style of the stroke cap used at the end of lines."

	^self strokeCaps at: 2!

startCap
	"Answer the style of the stroke cap used at the start of lines."

	^self strokeCaps at: 1!

startCap: startLineCapConstant endCap: endLineCapConstant 
	"Set the style of the stroke cap used at the start and ends of lines."

	| status |
	(status := GdiplusLibrary default 
				gdipSetCustomLineCapStrokeCaps: self asParameter
				startCap: startLineCapConstant
				endCap: endLineCapConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetCustomLineCapStrokeCaps failed' with: status]!

strokeCaps
	"Private - Answer a 2-element integer array that contains the styles of the start and ending stroke caps."

	| status startCap endCap |
	startCap := SDWORD new.
	endCap := SDWORD new.
	(status := GdiplusLibrary default
				gdipGetCustomLineCapStrokeCaps: self asParameter
				startCap: startCap
				endCap: endCap) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetCustomLineCapStrokeCaps failed' with: status].
	^{startCap value. endCap value}!

strokeJoin
	"Answer the style of line join (how intersecting lines are joined) for the stroke."

	| status lineJoin |
	lineJoin := SDWORD new.
	(status := GdiplusLibrary default gdipGetCustomLineCapStrokeJoin: self asParameter
				lineJoin: lineJoin) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetCustomLineCapStrokeJoin failed' with: status].
	^lineJoin value!

strokeJoin: aLineJoinConstant 
	"Set the style of line join (how intersecting lines are joined) for the stroke."

	| status |
	(status := GdiplusLibrary default gdipSetCustomLineCapStrokeJoin: self asParameter
				lineJoin: aLineJoinConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetCustomLineCapStrokeJoin failed' with: status]!

widthScale
	"Answer the amount to scale the receiver relative to the width of the GdiplusPen used to draw lines."

	| status widthScale |
	widthScale := FLOAT new.
	(status := GdiplusLibrary default gdipGetCustomLineCapWidthScale: self asParameter
				widthScale: widthScale) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetCustomLineCapWidthScale failed' with: status].
	^widthScale value!

widthScale: aNumber 
	"Set the amount to scale the receiver relative to the width of the GdiplusPen used to 
	draw lines. The default value of 1.0 does not scale the line cap."

	| status |
	(status := GdiplusLibrary default gdipSetCustomLineCapWidthScale: self asParameter
				widthScale: aNumber) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetCustomLineCapWidthScale failed' with: status]! !
!GdiplusCustomLineCap categoriesFor: #baseCap!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #baseCap:!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #baseInset!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #baseInset:!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #basicFree!private!realizing/unrealizing! !
!GdiplusCustomLineCap categoriesFor: #clone!copying!public! !
!GdiplusCustomLineCap categoriesFor: #endCap!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #startCap!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #startCap:endCap:!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #strokeCaps!accessing!private! !
!GdiplusCustomLineCap categoriesFor: #strokeJoin!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #strokeJoin:!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #widthScale!accessing!public! !
!GdiplusCustomLineCap categoriesFor: #widthScale:!accessing!public! !

!GdiplusCustomLineCap class methodsFor!

exampleGdipCLCStrokeCaps
	"This example creates a GdiplusCustomLineCap object , sets its stroke cap, and then 
	assigns the custom cap's stroke cap as the end cap of a GdiplusPen.  The pen draws a
	diagonal line.

		self exampleGdipCLCStrokeCaps showExample
	"

	| bitmap graphics path customCap pen rect |
	bitmap := GdiplusBitmap extent: 450 @ 300.
	graphics := bitmap graphics.
	path := GdiplusGraphicsPath new addLines: {-15 @ -15. 0 @ 0. 15 @ -15}.
	customCap := GdiplusCustomLineCap strokePath: path.
	customCap startCap: LineCapTriangle endCap: LineCapRound.
	pen := GdiplusPen red width: 5.5.
	pen customEndCap: customCap.
	rect := 50 @ 50 extent: 300 @ 100.
	graphics
		drawLine: rect pen: pen;
		drawRectangle: rect pen: GdiplusPen black.
	^bitmap!

fillPath: aFillPath strokePath: aStrokePath baseCap: aBaseCap baseInset: aBaseInset 
	^self fromInitializer: (GdiplusCustomLineCapInitializer 
				fillPath: aFillPath
				strokePath: aStrokePath
				baseCap: aBaseCap
				baseInset: aBaseInset)!

new
	^self strokePath: GdiplusGraphicsPath new!

strokePath: aStrokePath 
	^self 
		fillPath: nil
		strokePath: aStrokePath
		baseCap: LineCapFlat
		baseInset: 0! !
!GdiplusCustomLineCap class categoriesFor: #exampleGdipCLCStrokeCaps!examples!public!unit tests! !
!GdiplusCustomLineCap class categoriesFor: #fillPath:strokePath:baseCap:baseInset:!instance creation!public! !
!GdiplusCustomLineCap class categoriesFor: #new!instance creation!public! !
!GdiplusCustomLineCap class categoriesFor: #strokePath:!instance creation!public! !

