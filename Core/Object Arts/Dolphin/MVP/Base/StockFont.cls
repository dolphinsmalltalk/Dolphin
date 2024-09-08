"Filed out from Dolphin Smalltalk"!

Font subclass: #StockFont
	instanceVariableNames: 'id'
	classVariableNames: 'ANSI_FIXED_FONT ANSI_VAR_FONT DEFAULT_GUI_FONT DEVICE_DEFAULT_FONT OEM_FIXED_FONT SYSTEM_FIXED_FONT SYSTEM_FONT'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StockFont guid: (GUID fromString: '{87b4c63c-026e-11d3-9fd7-00a0cc3e4a32}')!

StockFont addClassConstant: 'ANSI_FIXED_FONT' value: 16rB!
StockFont addClassConstant: 'ANSI_VAR_FONT' value: 16rC!
StockFont addClassConstant: 'DEFAULT_GUI_FONT' value: 16r11!
StockFont addClassConstant: 'DEVICE_DEFAULT_FONT' value: 16rE!
StockFont addClassConstant: 'OEM_FIXED_FONT' value: 16rA!
StockFont addClassConstant: 'SYSTEM_FIXED_FONT' value: 16r10!
StockFont addClassConstant: 'SYSTEM_FONT' value: 16rD!

StockFont comment: '`StockFont` is the class of `GraphicsTool`s that wrap a Windows standard Font such as System, or Fixed System.

The stock fonts are really of limited use as they have not been updated since the early versions of Windows and most are raster (rather than vector) fonts, so they are not really scaleable. StockFonts should be considered superseded and not used deliberately. The only real reason to retain this wrapping is that the default font selected into a Windows device context is the stock system font, and we use StockFont instances to represent this, so for example when setting a `Font` into a `Canvas` for the first time, the `font:` setter method will return a `StockFont` instance.

Note that if a StockFont is applied into a View or Canvas at a DPI other than 96 (i.e with display scale > 100%), then it will be replaced by a standard `Font` instance. If the stock font is a raster font it will not be scaled to the new DPI. Vector stock fonts will be scaled as normal.'!

!StockFont categoriesForClass!Graphics-Tools! !

!StockFont methodsFor!

atDpi: anInteger
	"Answer a <Font> that is same as the receiver, but with the specified resolution. If that resolution is the same as the receiver's, then answer the receiver.
	As system fonts (SYSTEM_FONT and SYSTEM_FIXED_FONT) are unscalable raster fonts, we use the same instance for all DPIs (i.e. the point size remains the same, regardless of scale). This will mean the Fonts may be too small on typical high dpi displays today, but then these old fonts are ugly and not likely to be used anymore. StockFont exists primarily to wrap the default font set into a DC on creation, and an instance will be returned by the Canvas>>font: method when first called."

	(anInteger == dpi or: [self logFont isRasterFont]) ifTrue: [^self].
	^self series atDpi: anInteger!

clearCached
	"Private - Clear down the receiver's cached information and handles.
	Should be overridden by subclasses which wish to clear down other
	handles and cached information."

	super clearCached.
	logfont := nil!

copy
	| lf |
	lf := self logFont copy.
	"If the font's height is specified as cell height, ensure translated to character height in the copy to allow for easier scaling."
	lf lfHeight: self pixelSize negated.
	^Font fromLogFont: lf dpi: dpi!

createHandle
	"Private - Get the handle for the stock font with id stockID."

	^self getStockObject: id!

getLogFont
	logfont := LOGFONTW newBuffer.
	self getData: logfont.
	^logfont!

id
	"Private - Answer the stock font id of the receiver"

	^id!

initialize
	"Initialise the receiver."

	super initialize.
	"The stock fonts are sized for the system (primary monitor) DPI."
	dpi := UserLibrary default getDpiForSystem!

ownedHandle: aHandle 
	"Private - Set the handle of the external graphics's tool object represented and owned by
	the receiver to be the argument."

	"Implementation Note: Stock objects should never be free'd"

	self handle: aHandle!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	id == SYSTEM_FONT
		ifTrue: 
			[aStream
				display: Font;
				space;
				display: #system]
		ifFalse: 
			[aStream
				nextPut: $(;
				display: Font;
				nextPutAll: ' fromId: StockFont.';
				display: ((self class classPool keyAtValue: id ifAbsent: nil)
							ifNil: [id]
							ifNotNil: [:const | self class classPool associationAt: const]) displayString;
				nextPut: $)]!

setId: anInteger
	id := anInteger.
	ownsHandle := false.
	^self!

stbFixup: anSTBInFiler at: newObjectIndex
	"We don't want to clear the cached LOGFONT from the shared instances, so override superclass to do nothing."

	^self!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler."

	anSTBOutFiler 
		writePreambleFor: self;
		nextPut: id! !

!StockFont categoriesForMethods!
atDpi:!public!scaling! !
clearCached!private!realizing/unrealizing! !
copy!copying!public! !
createHandle!private!realizing/unrealizing! !
getLogFont!initializing!private! !
id!accessing!private! !
initialize!initializing!public! !
ownedHandle:!accessing!private! !
printOn:!printing!public! !
setId:!initializing!private! !
stbFixup:at:!binary filing!public! !
stbSaveOn:!binary filing!public! !
!

!StockFont class methodsFor!

newId: anInteger
	"Private - Answer a new instance of the receiver representing the stock font id anInteger."

	^self new
		setId: anInteger;
		yourself!

stbConvertFromVersion0: anArray
	"Private - Convert from version 0 StockFont. Version 1 uses a singleton representation."

	^(self fromId: (anArray at: 5)) atDpi: (anArray at: 4) y!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read a sub-instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to support conversion from pre version 1 instances, which can be found in STB files from versions of Dolphin predating 6.0"

	^(anSTBClassConversion notNil and: [anSTBClassConversion version < 1])
		ifTrue: 
			[| vars |
			vars := anSTBInFiler readObjectOfClass: Array size: anSTBClassConversion instSize.
			(self fromId: (vars at: 5)) atDpi: (vars at: 4) y]
		ifFalse: 
			[| stock |
			"Otherwise use the custom deserialization"
			stock := self fromId: anSTBInFiler basicNext.
			anSTBInFiler register: stock.
			stock]! !

!StockFont class categoriesForMethods!
newId:!instance creation!private! !
stbConvertFromVersion0:!binary filing!private! !
stbReadFrom:format:size:!binary filing!public! !
!

