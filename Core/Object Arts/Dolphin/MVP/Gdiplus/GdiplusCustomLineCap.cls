"Filed out from Dolphin Smalltalk"!

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

	| linecap |
	linecap := SDWORD new.
	GdiplusLibrary default gdipGetCustomLineCapBaseCap: self asParameter baseCap: linecap.
	^linecap value!

baseCap: aLineCapConstant
	"Set the style of the base cap used at the end of a line to that represented by aLineCapConstant."

	GdiplusLibrary default gdipSetCustomLineCapBaseCap: self asParameter baseCap: aLineCapConstant!

baseInset
	"Answer the distance between the base cap to the start of the line."

	| baseInset |
	baseInset := FLOAT new.
	GdiplusLibrary default gdipGetCustomLineCapBaseInset: self asParameter inset: baseInset.
	^baseInset value!

baseInset: aNumber
	"Set the distance between the base cap to the start of the line."

	GdiplusLibrary default gdipSetCustomLineCapBaseInset: self asParameter inset: aNumber!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteCustomLineCap: handle!

clone
	"Answer a copy of the receiver."

	| gpHandle |
	gpHandle := ExternalHandle new.
	GdiplusLibrary default gdipCloneCustomLineCap: self handle clonedCap: gpHandle.
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

	GdiplusLibrary default
		gdipSetCustomLineCapStrokeCaps: self asParameter
		startCap: startLineCapConstant
		endCap: endLineCapConstant!

strokeCaps
	"Private - Answer a 2-element integer array that contains the styles of the start and ending stroke caps."

	| startCap endCap |
	startCap := SDWORD new.
	endCap := SDWORD new.
	GdiplusLibrary default
		gdipGetCustomLineCapStrokeCaps: self asParameter
		startCap: startCap
		endCap: endCap.
	^{startCap value. endCap value}!

strokeJoin
	"Answer the style of line join (how intersecting lines are joined) for the stroke."

	| lineJoin |
	lineJoin := SDWORD new.
	GdiplusLibrary default gdipGetCustomLineCapStrokeJoin: self asParameter lineJoin: lineJoin.
	^lineJoin value!

strokeJoin: aLineJoinConstant
	"Set the style of line join (how intersecting lines are joined) for the stroke."

	GdiplusLibrary default gdipSetCustomLineCapStrokeJoin: self asParameter lineJoin: aLineJoinConstant!

widthScale
	"Answer the amount to scale the receiver relative to the width of the GdiplusPen used to draw lines."

	| widthScale |
	widthScale := FLOAT new.
	GdiplusLibrary default gdipGetCustomLineCapWidthScale: self asParameter widthScale: widthScale.
	^widthScale value!

widthScale: aNumber
	"Set the amount to scale the receiver relative to the width of the GdiplusPen used to 
	draw lines. The default value of 1.0 does not scale the line cap."

	GdiplusLibrary default gdipSetCustomLineCapWidthScale: self asParameter widthScale: aNumber! !

!GdiplusCustomLineCap categoriesForMethods!
baseCap!accessing!public! !
baseCap:!accessing!public! !
baseInset!accessing!public! !
baseInset:!accessing!public! !
basicFree!private!realizing/unrealizing! !
clone!copying!public! !
endCap!accessing!public! !
startCap!accessing!public! !
startCap:endCap:!accessing!public! !
strokeCaps!accessing!private! !
strokeJoin!accessing!public! !
strokeJoin:!accessing!public! !
widthScale!accessing!public! !
widthScale:!accessing!public! !
!

!GdiplusCustomLineCap class methodsFor!

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

!GdiplusCustomLineCap class categoriesForMethods!
fillPath:strokePath:baseCap:baseInset:!instance creation!public! !
new!instance creation!public! !
strokePath:!instance creation!public! !
!

