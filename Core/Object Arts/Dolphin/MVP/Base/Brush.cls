"Filed out from Dolphin Smalltalk X6"!

GraphicsTool subclass: #Brush
	instanceVariableNames: 'logBrush'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Brush guid: (GUID fromString: '{87B4C633-026E-11D3-9FD7-00A0CC3E4A32}')!
Brush comment: ''!
!Brush categoriesForClass!Graphics-Tools! !
!Brush methodsFor!

createHandle
	"Private - Answer an external handle to a new brush as described by the logbrush structure."

	^GDILibrary default createBrushIndirect: logBrush!

logBrush
	"Private - Answe the logical description (LOGBRUSH) for the receiver."

	logBrush isNil 
		ifTrue: 
			[logBrush := LOGBRUSH new.
			self getData: logBrush].
	^logBrush!

logBrush: aLOGBRUSH 
	"Private - Set the receiver's logical attributes."

	logBrush := aLOGBRUSH.
	self free! !
!Brush categoriesFor: #createHandle!private!realizing/unrealizing! !
!Brush categoriesFor: #logBrush!accessing!private! !
!Brush categoriesFor: #logBrush:!accessing!private! !

!Brush class methodsFor!

bitmap: aBitmap 
	"Answer a new instance of the receiver for paiting the specified <Bitmap> pattern."

	^self 
		withStyle: BS_PATTERN
		color: 0
		hatch: aBitmap!

black
	"Answer the stock black brush."

	^StockBrush fromId: BLACK_BRUSH!

color: aColor 
	"Answer a new instance of the receiver for painting in the specified solid colour."

	^aColor brush!

dkGray
	"Answer the stock dark grey Brush."

	^StockBrush fromId: DKGRAY_BRUSH!

fromLogBrush: aLOGBRUSH
	"Answer a new instance of the receiver containing the given logical brush."

	^self new
		logBrush: aLOGBRUSH;
		yourself!

gray
	"Answer the stock grey brush."

	^StockBrush fromId: GRAY_BRUSH!

hatchedDiagonal
	"Answer a new instance of the receiver for painting diagonal hatching."

	^self 
		withStyle: BS_HATCHED
		color: 0
		hatch: HS_BDIAGONAL!

hollow
	"Answer the stock hollow (or null) brush."

	^StockBrush fromId: HOLLOW_BRUSH!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

ltGray
	"Answer the stock light grey brush."

	^StockBrush fromId: LTGRAY_BRUSH!

newColor: aColour 
	"Private - Answer a new instance of the receiver for painting in the specified solid colour."

	^self 
		withStyle: BS_SOLID
		color: aColour
		hatch: 0!

transparent
	"Answer the stock transparent brush."

	^StockBrush fromId: NULL_BRUSH!

white
	"Answer the stock white brush."

	^StockBrush fromId: WHITE_BRUSH!

withStyle: styleFlags color: aColour hatch: hatchObject 
	"Answer a new instance of the receiver with the specified style, colour and hatching attributes."

	^self fromLogBrush: ((LOGBRUSH new)
				style: styleFlags;
				color: aColour;
				hatch: hatchObject;
				yourself)! !
!Brush class categoriesFor: #bitmap:!instance creation!public! !
!Brush class categoriesFor: #black!instance creation!public! !
!Brush class categoriesFor: #color:!instance creation!public! !
!Brush class categoriesFor: #dkGray!instance creation!public! !
!Brush class categoriesFor: #fromLogBrush:!instance creation!public! !
!Brush class categoriesFor: #gray!instance creation!public! !
!Brush class categoriesFor: #hatchedDiagonal!instance creation!public! !
!Brush class categoriesFor: #hollow!instance creation!public! !
!Brush class categoriesFor: #icon!constants!public! !
!Brush class categoriesFor: #ltGray!instance creation!public! !
!Brush class categoriesFor: #newColor:!instance creation!private! !
!Brush class categoriesFor: #transparent!instance creation!public! !
!Brush class categoriesFor: #white!instance creation!public! !
!Brush class categoriesFor: #withStyle:color:hatch:!instance creation!public! !

