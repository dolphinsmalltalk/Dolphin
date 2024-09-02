"Filed out from Dolphin Smalltalk"!

GraphicsTool subclass: #Font
	instanceVariableNames: 'logfont dpi series'
	classVariableNames: 'Qualities System'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Font guid: (GUID fromString: '{87b4c634-026e-11d3-9fd7-00a0cc3e4a32}')!

Font addClassConstant: 'Qualities' value: #(#default #draft #proof #nonantialiased #antialiased #cleartype #cleartypeNatural)!

Font comment: '`Font` is the class of `GraphicsTool`s that wrap a Windows Font object

## Instance Variables:
  `logfont`	`LOGFONTW` structure with details describing the font.
  `dpi`		`<integer>` . The DPI at which this font is realised.
  `series`		`FontSeries`. Series of equivalent fonts at different DPIs.

'!

!Font categoriesForClass!Graphics-Tools! !

!Font methodsFor!

= aFont
	"Answer true if aFont is equal to (has the same logical font info) as the receiver."

	^self == aFont or: 
			[self species == aFont species and: 
					[series == aFont series
						or: [(self logFont equalExcludingSize: aFont logFont) and: [self pointSize == aFont pointSize]]]]!

atDpi: anInteger
	"Answer a <Font> that is same as the receiver, but with the specified resolution. If that resolution is the same as the receiver's, then answer the receiver."

	dpi = anInteger ifTrue: [^self].
	^self series atDpi: anInteger!

beBold
	"Set the receiver's bold attribute."

	self isBold: true!

beItalic
	"Set the receiver's italic attribute."

	self isItalic: true!

beUnderlined
	"Set the receiver's underline attribute."

	self isUnderlined: true!

characterSet
	"Answer an <integer> identifying the character set of the receiver."

	^logfont lfCharSet!

characterSet: anInteger 
	"Set the <integer> identifying the character set of the receiver."

	anInteger = self characterSet ifTrue: [^self].
	logfont lfCharSet: anInteger.
	self styleChanged!

createHandle
	"Private - Answer an external handle to a new font as described by the logfont structure."

	^GDILibrary default createFontIndirectW: self logFont!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	self name displayOn: aStream.
	aStream nextPut: $\x20.
	self pointSize displayOn: aStream.
	aStream nextPutAll: 'pt'!

dpi
	"Answer the logical pixels per inch of the receiver"

	^dpi!

dpi: anInteger
	"Sets the logical pixels per inch of the receiver. Note that if the dpi changes, this will free the font handle, breaking any existing uses. This tends to be obvious as controls will mysteriously start painting using the system font. Changing the DPI of a shared font must therefore be avoided. Instead use #atDpi: to get an equivalent Font at the desired scale."

	| oldDpi |
	dpi = anInteger ifTrue: [^self].
	self free.
	oldDpi := dpi.
	
	[| ptSize |
	ptSize := self pointSize.
	dpi := anInteger.
	self pointSize: ptSize]
			ifCurtailed: [dpi := oldDpi]!

getLogFont
	logfont ifNil: [logfont := LOGFONTW newBuffer].
	self isRealized ifTrue: [self getData: logfont] ifFalse: [logfont lfWeight: FW_NORMAL].
	^logfont!

handle: hFont
	"Sets the non-owned handle for the receiver and queries its logical info."

	super handle: hFont.
	self getLogFont!

hash
	"Answer the SmallInteger hash value for the receiver."

	^self pointSize hashMultiply + self name hash!

initialize
	"Initialise the receiver."

	super initialize.
	"With per-monitor high DPI scaling, we don't know what actual pixel size font we will need out of context. If not running at 96-dpi, then the correct size of font will be derived based on this one at point of use, and both are linked together via a FontSeries, meaning that a reference to either will prevent both being GC'd. This is necessary because the object memory reference will likely be to the original 96-dpi font, but the font handle passed to a control may be from a scaled version of the font. The series also allows us to share a single scaled instance when installing the font into multiple controls."
	dpi := USER_DEFAULT_SCREEN_DPI!

isBold
	"Answer whether the receiver is bold."

	^self weight = FW_BOLD!

isBold: aBoolean
	"Set the receiver's bold attribute."

	self weight: (aBoolean ifTrue: [FW_BOLD] ifFalse: [FW_NORMAL])!

isDefault
	"Answer true if the receiver is the default font"

	^self = Font default!

isItalic
	"Answer whether the receiver is itatic."

	^self logFont lfItalic ~= 0!

isItalic: aBoolean
	"Set whether the receiver is an italic typeface."

	self isItalic == aBoolean ifTrue: [^self].
	logfont lfItalic: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self styleChanged!

isStruckThrough
	"Answer whether the strike-out effect is set."

	^self logFont lfStrikeOut ~= 0!

isStruckThrough: aBoolean 
	"Set the struck out character effect."

	self isStruckThrough == aBoolean ifTrue: [^self].
	logfont lfStrikeOut: aBoolean asParameter.
	self styleChanged!

isUnderlined
	"Answer whether the receiver is underlined."

	^self logFont lfUnderline ~= 0!

isUnderlined: aBoolean 
	"Reset the receiver's underline attribute."

	self isUnderlined == aBoolean ifTrue: [^self].
	logfont lfUnderline: aBoolean asParameter.
	self styleChanged!

logFont
	"Answer the receiver's logical attributes."

	^logfont ifNil: [self getLogFont]!

logFont: aLOGFONT 
	"Set the receiver's logical attributes."

	logfont := aLOGFONT.
	self styleChanged!

name
	"Answer the face name of the font."

	^self logFont faceName!

name: aString
	"Set the receiver's font name attribute. This has no affect if the receiver is already realized."

	self logFont faceName: aString!

pixelSize
	"Answers the receiver's pixel size (this is the Em height, or character height). Note that this is the physical size, so will increase proportionally to DPI scale for the same logical point size."

	| lf emHeight dc tm |
	lf := self logFont.
	emHeight := lf lfHeight.
	emHeight < 0 ifTrue: [^emHeight negated].
	"If the height in the LOGFONT is positive, then it is a pixel cell height. To calculate the point size we will need to follow [Q32667](https://jeffpar.github.io/kbarchive/kb/032/Q32667/). We use the raw Win32 APIs to reduce overhead and class dependencies. This is relatively expensive, but in practice we only tend to encounter this case for older non-scalable rasterized fonts such as the venerable Windows System font."
	dc := UserLibrary default getDC: nil.
	
	[GDILibrary default selectObject: dc hgdiobj: self handle.
	tm := TEXTMETRICW newBuffer.
	GDILibrary default  getTextMetrics: dc lptm: tm]
			ensure: [UserLibrary default releaseDC: nil hDC: dc].
	^tm emHeight!

pixelSize: anInteger
	"Set's the receiver's pixel size to anInteger pixels.
	This has no affect if the receiver is already realized."

	self logFont lfHeight: anInteger negated!

pointSize
	"Answers the receiver's point size. Note that this is logical point size independent of DPI scaling. For example a 10 point font at 96-dpi will be physically the size of a 20 point font at 192 dpi, but the logical point size will still be 10. See also #pixelSize."

	^(self pixelSize * 72 / self dpi) rounded!

pointSize: anInteger
	"Convert anInteger to pixels and store in the receiver's logfont lfHeight.
	This has no affect if the receiver is already realized."

	self logFont lfHeight: (anInteger * self dpi / 72) rounded negated!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver."

	super postCopy.
	logfont := logfont copy.
	series := nil.
	^self!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	| attributes weight |
	attributes := OrderedCollection new.
	weight := self weight.
	weight == FW_NORMAL
		ifFalse: 
			[attributes add: (weight == FW_BOLD ifTrue: [#isBold: -> true] ifFalse: [#weight: -> self weight])].
	self isItalic ifTrue: [attributes add: #isItalic: -> true].
	self isUnderlined ifTrue: [attributes add: #isUnderlined: -> true].
	self isStruckThrough ifTrue: [attributes add: #isStruckThrough: -> true].
	attributes isEmpty ifFalse: [aStream nextPut: $(].
	aStream
		nextPut: $(;
		display: Font;
		nextPutAll: ' name: ';
		print: self name;
		nextPutAll: ' pointSize: ';
		print: self pointSize;
		nextPut: $).
	attributes isEmpty
		ifFalse: 
			[attributes do: 
					[:each |
					aStream
						space;
						nextPutAll: each key;
						space;
						print: each value]
				separatedBy: [aStream nextPut: $;].
			aStream nextPut: $)]!

quality
	^Qualities at: self logFont lfQuality + 1!

quality: aSymbol
	"Set the Font rendering quality to that named by the <Symbol> argument, one of:
		default			- Use default font quality
		draft				- Appearance of the font does not matter
		proof			- Character quality of the font is more important than exact matching of the logical-font attributes.
		nonantialiased		- Anti-aliasing is disabled
		antialiased		- Font is anti-aliased if the font supports it, depending on size.
		cleartype 			- Cleartype anti-aliasing is used, if the font supports it
		cleartypeNatural	- Not well documented
	See the documentation for the lfQuality member of [LOGFONTW](view-source:https://learn.microsoft.com/en-us/windows/win32/api/wingdi/ns-wingdi-logfontw) for further details.
	Setting this value has no immediate effect if the receiver is already realized."

	self quality == aSymbol ifTrue: [^self].
	logfont lfQuality: (Qualities identityIndexOf: aSymbol) - 1.
	self styleChanged!

resolution
	"Answer the logical pixels per inch of the receiver"

	^dpi @ dpi!

resolution: aPoint
	"Sets the logical pixels per inch of the receiver. Note that this will free the font handle, so don't change the resolution of a shared font (use #withResolution:)."

	self dpi: aPoint y!

series
	^series ifNil: [series := FontSeries forFont: self]!

series: aFontSeries
	series := aFontSeries!

setHandle: anExternalHandle dpi: anInteger
	ownsHandle := false.
	dpi := anInteger.
	self handle: anExternalHandle.
	^self!

setLogFont: aLOGFONT dpi: anInteger
	ownsHandle := true.
	logfont := aLOGFONT.
	dpi := anInteger.
	^self!

setOwnedHandle: anExternalHandle dpi: anInteger
	dpi := anInteger.
	self ownedHandle: anExternalHandle.
	^self!

species
	^Font!

stbSaveOn: anSTBOutFiler
	"Serialize the receiver to anSTBOutFiler."

	"For Fonts we want to replace all instances from a series with a 96-dpi design instance, and we never want to serialize the series itself"

	dpi == USER_DEFAULT_SCREEN_DPI
		ifTrue: 
			[| savedHandle savedSeries |
			savedHandle := handle.
			savedSeries := series.
			handle := series := nil.
			[anSTBOutFiler saveObject: self] ensure: 
					[handle := savedHandle.
					series := savedSeries]]
		ifFalse: [anSTBOutFiler basicNextPut: (series atDpi: USER_DEFAULT_SCREEN_DPI)]!

styleChanged
	"Private - An attribute of the receiver has been changed, invalidating the handle and the relationship to the series."

	self free.
	series := nil!

weight
	"Answer the receiver's <integer> 'weight' (thickness)."

	^logfont lfWeight!

weight: anInteger 
	"Set the receiver's 'weight' (thickness)."

	self weight = anInteger ifTrue: [^self].
	logfont lfWeight: anInteger.
	self styleChanged! !

!Font categoriesForMethods!
=!comparing!public! !
atDpi:!public!scaling! !
beBold!accessing!public! !
beItalic!accessing!public! !
beUnderlined!accessing!public! !
characterSet!accessing!public! !
characterSet:!accessing!public! !
createHandle!private!realizing/unrealizing! !
displayOn:!displaying!public! !
dpi!accessing!public!scaling! !
dpi:!accessing!public!scaling! !
getLogFont!initializing!private! !
handle:!accessing!public! !
hash!comparing!public! !
initialize!initializing!public! !
isBold!public!testing! !
isBold:!modes!public! !
isDefault!public!testing! !
isItalic!public!testing! !
isItalic:!modes!public! !
isStruckThrough!public!testing! !
isStruckThrough:!accessing!public! !
isUnderlined!public!testing! !
isUnderlined:!modes!public! !
logFont!accessing!public! !
logFont:!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
pixelSize!accessing!public! !
pixelSize:!accessing!public! !
pointSize!accessing!public! !
pointSize:!accessing!public! !
postCopy!copying!public! !
printOn:!development!printing!public! !
quality!accessing!public! !
quality:!accessing!public! !
resolution!accessing!public! !
resolution:!accessing!public!scaling! !
series!accessing!public! !
series:!accessing!public! !
setHandle:dpi:!initializing!private! !
setLogFont:dpi:!initializing!private! !
setOwnedHandle:dpi:!initializing!private! !
species!constants!public! !
stbSaveOn:!binary filing!public! !
styleChanged!modes!private! !
weight!accessing!public! !
weight:!accessing!public! !
!

!Font class methodsFor!

default
	"Answers the default font for the system."

	^self fromId: DEFAULT_GUI_FONT!

defaultPointSize
	"Private - Answer a default point size to use when it is not explicitly specified"

	^10!

fixedSystem
	^self fromId: SYSTEM_FIXEDFONT!

fromHandle: aHandle
	Notification deprecated.	"Use #fromHandle:dpi:"
	^self fromHandle: aHandle dpi: SystemMetrics current dpi!

fromHandle: aHandle dpi: anInteger
	"Answers an instance of the receiver with aHandle that has been created for use at the specified DPI. The handle is not owned by the instance and will not therefore be freed by it."

	aHandle = System handle ifTrue: [^System].
	^self basicNew setHandle: aHandle dpi: anInteger!

fromId: anInteger
	"Answer a new instance of the receiver representing the stock font id anInteger."

	^StockFont new
		setId: anInteger;
		yourself!

fromLogFont: aLOGFONT
	"Answer a new instance of the receiver with specified logical attributes. Note that it is assumed that the font height in the LOGFONT is specified for a font to be used at the current system (i.e. primary monitor) DPI. It is usually preferable to use #fromLogFont:dpi: and specify the DPI, otherwise the font may be sized incorrectly. Unfortunately there is no way to specify a point size directly in a LOGFONT - the physical size must be specified."

	Notification deprecated. "Use fromLogFont:dpi: to be explicit about the DPI"
	^self fromLogFont: aLOGFONT dpi: SystemMetrics current dpi!

fromLogFont: aLOGFONT dpi: anInteger
	"Answer a new instance of the receiver with specified logical attributes."

	^self basicNew setLogFont: aLOGFONT dpi: anInteger!

fromOwnedHandle: aHandle
	Notification deprecated.	"Use #fromOwnedHandle:dpi:"
	^self fromOwnedHandle: aHandle dpi: SystemMetrics current dpi!

fromOwnedHandle: aHandle dpi: anInteger
	"Answers an instance of the receiver with aHandle assumed to have been created for the specified DPI. The handle is owned by the instance and will therefore be freed by it."

	^self basicNew setOwnedHandle: aHandle dpi: anInteger!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

name: aString
	"Answer a new instance of the receiver for fontname aString and a default point size"

	^self name: aString pointSize: self defaultPointSize
!

name: aString pixelSize: anInteger
	"Answer a new instance of the receiver for fontname aString, and pixel size anInteger."

	^self new
		name: aString; 
		pixelSize: anInteger;
		yourself!

name: aString pointSize: anInteger
	"Answer a new instance of the receiver for fontname aString, pointsize anInteger."

	^self new
		name: aString; 
		pointSize: anInteger;
		yourself!

onStartup2
	System := self fromId: SYSTEM_FONT!

stbConvertFrom: anSTBClassFormat
	| version |
	version := anSTBClassFormat version.
	version == 0 ifTrue: [^[:data | (self stbConvertFromVersion0: data) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersion0: anArray
	"Private - Convert from version 0 font. Version 1 adds series instance variable, which is lazily initialized, and the DPI is stored as an integer value rather than a <Point>"

	anArray resize: anArray size + 1.
	anArray
		replaceFrom: 6
		to: anArray size
		with: anArray
		startingAt: 5.
	anArray at: 4 put: (anArray at: 4) y.
	^anArray!

stbVersion
	"Version 1 adds series inst var, and repurposes the resolution inst var to hold just the DPI (we don't need two dimensions to scale the font height)."

	^1!

system
	"Answer the stock System font."

	^System! !

!Font class categoriesForMethods!
default!instance creation!public! !
defaultPointSize!constants!private! !
fixedSystem!instance creation!public! !
fromHandle:!instance creation!public! !
fromHandle:dpi:!instance creation!public! !
fromId:!instance creation!public! !
fromLogFont:!instance creation!public! !
fromLogFont:dpi:!instance creation!public! !
fromOwnedHandle:!instance creation!public! !
fromOwnedHandle:dpi:!instance creation!public! !
icon!constants!public! !
name:!instance creation!public! !
name:pixelSize:!instance creation!public! !
name:pointSize:!instance creation!public! !
onStartup2!event handling!private! !
stbConvertFrom:!binary filing!private! !
stbConvertFromVersion0:!binary filing!private! !
stbVersion!binary filing!public! !
system!instance creation!public! !
!

