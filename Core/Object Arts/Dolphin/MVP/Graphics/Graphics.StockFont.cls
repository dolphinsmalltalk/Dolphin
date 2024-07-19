"Filed out from Dolphin Smalltalk"!

Graphics.SystemFont
	subclass: #'Graphics.StockFont'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'StockNames' -> (IdentityDictionary withAll: { 16rD -> #system. 16r11 -> #default })
		}!

Graphics.StockFont guid: (Core.GUID fromString: '{87b4c63c-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.StockFont comment: '`StockFont` is the class of `GraphicsTool`s that wrap a Windows standard Font such as System, or Fixed System.

The stock fonts are really of limited use as they have not been updated since the early versions of Windows and most are raster (rather than vector) fonts, so they are not really scaleable. StockFonts should be considered superseded and not used deliberately. The only real reason to retain this wrapping is that the default font selected into a Windows device context is the stock system font, and we use StockFont instances to represent this, so for example when setting a `Font` into a `Canvas` for the first time, the `font:` setter method will return a `StockFont` instance.

Note that if a StockFont is applied into a View or Canvas at a DPI other than 96 (i.e with display scale > 100%), then it will be replaced by a standard `Font` instance. If the stock font is a raster font it will not be scaled to the new DPI. Vector stock fonts will be scaled as normal.
'!

!Graphics.StockFont categoriesForClass!Graphics-Tools! !

!Graphics.StockFont methodsFor!

atDpi: anInteger
	"Answer a <Font> that is same as the receiver, but with the specified resolution. If that resolution is the same as the receiver's, then answer the receiver.
	As system fonts (SYSTEM_FONT and SYSTEM_FIXED_FONT) are unscalable raster fonts, we use the same instance for all DPIs (i.e. the point size remains the same, regardless of scale). This will mean the Fonts may be too small on typical high dpi displays today, but then these old fonts are ugly and not likely to be used anymore. StockFont exists primarily to wrap the default font set into a DC on creation, and an instance will be returned by the Canvas>>font: method when first called."

	(anInteger == dpi or: [self logFont isRasterFont]) ifTrue: [^self].
	^self series atDpi: anInteger!

basicFree
	"Private - Free up external resources held by the receiver. Ignore any errors which might arise."

	"[It is not necessary (but it is not harmful) to delete stock objects by calling DeleteObject](https://learn.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-getstockobject)"

	!

basicRealize
	"Private - Realize (create) the external resource associated with the receiver, sent from
	the public method, #realize, if not already realized."

	"Override because we don't own the handle"

	self handle: self createHandle!

createHandle
	^self getStockObject: id!

getLogFont
	logfont := LOGFONTW newBuffer.
	self getData: logfont.
	^logfont!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	(StockNames lookup: id)
		ifNil: 
			[aStream
				nextPut: $(;
				display: Font;
				nextPutAll: ' fromId: ';
				print: id;
				nextPut: $)]
		ifNotNil: 
			[:name |
			aStream
				display: Font;
				space;
				nextPutAll: name]!

resolution: aPoint
	"Sets the logical pixels per inch of the receiver"

	"Ignored"

	!

setId: anInteger
	id := anInteger.
	ownsHandle := false.
	^self! !

!Graphics.StockFont categoriesForMethods!
atDpi:!public!scaling! !
basicFree!private!realizing/unrealizing! !
basicRealize!private!realizing/unrealizing! !
createHandle!private!realizing/unrealizing! !
getLogFont!initializing!private! !
ownedHandle:!accessing!private! !
printOn:!development!printing!public! !
resolution:!accessing!public! !
setId:!initializing!private! !
!

