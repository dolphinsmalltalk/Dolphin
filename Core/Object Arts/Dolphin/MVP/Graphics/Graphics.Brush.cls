"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.Brush'
	instanceVariableNames: 'logBrush'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Brush guid: (Core.GUID fromString: '{87b4c633-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.Brush comment: '`Brush` is a `GraphicsTool` that wraps a Windows GDI Brush object. Brushes are selected into `Canvas`s to paint areas of pixels, for example to fill rectangles.

## Instance Variables:
  `logBrush` 	`LOGBRUSH`. Windows API structure describing the brush.'!

!Graphics.Brush categoriesForClass!Graphics-Tools! !

!Graphics.Brush methodsFor!

createHandle
	"Private - Answer an external handle to a new brush as described by the logbrush structure."

	^Gdi32 createBrushIndirect: logBrush!

logBrush
	"Private - Answe the logical description (LOGBRUSH) for the receiver."

	logBrush isNil
		ifTrue: 
			[logBrush := LOGBRUSH newBuffer.
			self getData: logBrush].
	^logBrush!

logBrush: aLOGBRUSH 
	"Private - Set the receiver's logical attributes."

	logBrush := aLOGBRUSH.
	self free!

printOn: aPuttableStream
	"Append, to the <puttableStream> argument a string whose characters are a the same as those which would result from sending a #printString message to the receiver."

	| lb |
	lb := self logBrush.
	(lb lbStyle == BS_SOLID and: [lb lbHatch == 0])
		ifTrue: 
			[aPuttableStream
				nextPut: $(;
				print: self class;
				space;
				display: #color:;
				space;
				print: lb lbColor;
				nextPut: $)]
		ifFalse: 
			[aPuttableStream
				basicPrint: self;
				nextPut: $(;
				print: lb;
				nextPut: $)]! !

!Graphics.Brush categoriesForMethods!
createHandle!private!realizing/unrealizing! !
logBrush!accessing!private! !
logBrush:!accessing!private! !
printOn:!development!printing!public! !
!

!Graphics.Brush class methodsFor!

bitmap: aBitmap 
	"Answer a new instance of the receiver for painting the specified <Bitmap> pattern."

	^self 
		style: BS_PATTERN
		color: Color black
		hatch: aBitmap!

black
	"Answer the stock black brush."

	^StockBrush fromId: BLACK_BRUSH!

color: aColor 
	"Answer a new instance of the receiver for painting in the specified solid colour."

	^aColor brush!

cross
	"Answer a new instance of the receiver for painting a hatched pattern of evenly-spaced, perpendicular, vertical and horizontal lines in black."

	^self cross: Color black!

cross: aColor
	"Answer a new instance of the receiver for painting a hatched pattern of evenly-spaced, perpendicular, vertical and horizontal lines in the specified <Color>."

	^HatchBrush fromId: HS_CROSS color: aColor!

darkGray
	"Answer the stock dark grey Brush."

	^StockBrush fromId: DKGRAY_BRUSH!

diagonal
	"Answer a new instance of the receiver for painting a hatched pattern of evenly-spaced diagonal lines in black. The lines are draw from bottom left towards top right, i.e. sloping up from a left to right perspective."

	^self diagonal: Color black!

diagonal: aColor
	"Answer a new instance of the receiver for painting a hatched pattern of evenly-spaced diagonal lines in the specified <Color>. The lines are draw from bottom left towards top right, i.e. sloping up from a left to right perspective."

	^HatchBrush fromId: HS_BDIAGONAL color: aColor!

diamond
	"Answer a new instance of the receiver for painting a hatched pattern of evenly-spaced, diagonal and reverse-diagonal lines, in black."

	^self diamond: Color black!

diamond: aColor
	"Answer a new instance of the receiver for painting a hatched pattern of evenly-spaced, diagonal and reverse-diagonal lines in the specified <Color>."

	^HatchBrush fromId: HS_DIAGCROSS color: aColor!

fromLogBrush: aLOGBRUSH
	"Answer a new instance of the receiver containing the given logical brush."

	^self new
		logBrush: aLOGBRUSH;
		yourself!

gray
	"Answer the stock grey brush."

	^StockBrush fromId: GRAY_BRUSH!

horizontal
	"Answer a new instance of the receiver for painting a hatched pattern of horizontally-oriented parallel lines in black."

	^self horizontal: Color black!

horizontal: aColor
	"Answer a new instance of the receiver for painting a hatched pattern of horizontally-oriented parallel lines in the specified <Color>."

	^HatchBrush fromId: HS_HORIZONTAL color: aColor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

newColor: aColour 
	"Private - Answer a new instance of the receiver for painting in the specified solid colour."

	^self 
		style: BS_SOLID
		color: aColour
		hatch: 0!

reverseDiagonal
	"Answer a new instance of the receiver for painting a reverse diagonal hatched pattern in black. The lines are draw from top left towards bottom right, i.e. sloping down from a left to right perspective."

	^self reverseDiagonal: Color black!

reverseDiagonal: aColor
	"Answer a new instance of the receiver for painting a reverse diagonal hatched pattern in the specified <Color>. The lines are draw from top left towards bottom right, i.e. sloping down from a left to right perspective."

	^HatchBrush fromId: HS_FDIAGONAL color: aColor!

silver
	"Answer the stock light grey brush."

	^StockBrush fromId: LTGRAY_BRUSH!

style: styleFlags color: aColour hatch: hatchObject
	"Answer a new instance of the receiver with the specified style, colour and hatching attributes. The hatchObject can be either a <Bitmap> or one of the <integer> constants from the Win32 HS_xxx enumeration."

	^self fromLogBrush: (LOGBRUSH
				style: styleFlags
				color: aColour
				hatch: hatchObject)!

transparent
	"Answer the stock transparent (aka Null, aka Hollow) brush."

	^StockBrush fromId: NULL_BRUSH!

vertical
	"Answer a new instance of the receiver for painting a hatched pattern of vertically-oriented parallel lines in black."

	^self vertical: Color black!

vertical: aColor
	"Answer a new instance of the receiver for painting a hatched pattern of vertically-oriented parallel lines in the specified <Color>."

	^HatchBrush fromId: HS_VERTICAL color: aColor!

white
	"Answer the stock white brush."

	^StockBrush fromId: WHITE_BRUSH!

withStyle: styleFlags color: aColour hatch: hatchObject
	#deprecated.
	^self
		style: styleFlags
		color: aColour
		hatch: hatchObject! !

!Graphics.Brush class categoriesForMethods!
bitmap:!instance creation!public! !
black!instance creation!public! !
color:!instance creation!public! !
cross!instance creation!public! !
cross:!instance creation!public! !
darkGray!instance creation!public! !
diagonal!instance creation!public! !
diagonal:!instance creation!public! !
diamond!instance creation!public! !
diamond:!instance creation!public! !
fromLogBrush:!instance creation!public! !
gray!instance creation!public! !
horizontal!instance creation!public! !
horizontal:!instance creation!public! !
icon!constants!public! !
newColor:!instance creation!private! !
reverseDiagonal!instance creation!public! !
reverseDiagonal:!instance creation!public! !
silver!instance creation!public! !
style:color:hatch:!instance creation!public! !
transparent!instance creation!public! !
vertical!instance creation!public! !
vertical:!instance creation!public! !
white!instance creation!public! !
withStyle:color:hatch:!instance creation!public! !
!

