"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.AbstractFont'
	instanceVariableNames: 'logfont dpi series'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.AbstractFont guid: (Core.GUID fromString: '{894c6c14-886e-4fde-9d60-0038c187704b}')!

Graphics.AbstractFont isNonInstantiable: true!

Graphics.AbstractFont comment: ''!

!Graphics.AbstractFont methodsFor!

= aFont
	"Answer true if aFont is equal to (has the same logical font info) as the receiver."

	^self species == aFont species and: 
			[series == aFont series
				or: [(logfont equalExcludingSize: aFont logFont) and: [self pointSize == aFont pointSize]]]!

actualFont
	^self!

atDpi: anInteger
	"Answer a <Font> that is same as the receiver, but with the specified resolution. If that resolution is the same as the receiver's, then answer the receiver."

	dpi = anInteger ifTrue: [^self].
	^self series atDpi: anInteger!

characterSet
	"Answer an <integer> identifying the character set of the receiver."

	^self logFont lfCharSet!

createHandle
	"Private - Answer an external handle to a new font as described by the logfont structure."

	^Gdi32 createFontIndirectW: self logFont!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self name;
		nextPut: $\x20;
		display: self pointSize;
		nextPutAll: 'pt'!

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
	^self subclassResponsibility!

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

	^self weight == FW_BOLD!

isDefault
	"Answer true if the receiver is the default font"

	^self = Font default!

isItalic
	"Answer whether the receiver is itatic."

	^self logFont lfItalic ~~ 0!

isStruckThrough
	"Answer whether the strike-out effect is set."

	^self logFont lfStrikeOut ~~ 0!

isUnderlined
	"Answer whether the receiver is underlined."

	^self logFont lfUnderline ~~ 0!

logFont
	"Answer the receiver's logical attributes."

	^logfont ifNil: [self getLogFont]!

name
	"Answer the face name of the font."

	^self logFont faceName!

pixelSize
	"Answers the receiver's pixel size."

	^self logFont lfHeight abs!

pointSize
	"Answers the receiver's point size."

	| lfHeight |
	lfHeight := self logFont lfHeight.
	lfHeight > 0 ifTrue: [ | dc tm |
"		dc := Canvas forDesktop.
		dc font: self.
		tm := dc outlineTextMetrics.
		dc free."
		] ifFalse: [lfHeight := lfHeight negated].
	^(lfHeight * 72 / self dpi) rounded
"
Font system pointSize
"!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver."

	super postCopy.
	logfont := logfont copy.
	series := nil.
	^self!

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
	self handle: anExternalHandle.
	dpi := anInteger.
	^self!

setLogFont: aLOGFONT dpi: anInteger
	ownsHandle := true.
	logfont := aLOGFONT.
	dpi := anInteger.
	^self!

setOwnedHandle: anExternalHandle dpi: anInteger
	self ownedHandle: anExternalHandle.
	dpi := anInteger.
	self getLogFont.
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
		ifFalse: [anSTBOutFiler nextPut: (series atDpi: USER_DEFAULT_SCREEN_DPI)]!

styleChanged
	"Private - An attribute of the receiver has been changed, invalidating the handle and the relationship to the series."

	self free.
	series := nil!

unstyledCopy
	"Answer a new <Font> that is the same as the receiver, but without any styling (i.e. without italics, bold, or underlining)."

	^Font name: self name pixelSize: self pixelSize!

weight
	"Answer the receiver's <integer> 'weight' (thickness)."

	^self logFont lfWeight! !

!Graphics.AbstractFont categoriesForMethods!
=!comparing!public! !
actualFont!public! !
atDpi:!public!scaling! !
characterSet!accessing!public! !
createHandle!private!realizing/unrealizing! !
displayOn:!displaying!public! !
dpi!accessing!public!scaling! !
dpi:!accessing!public!scaling! !
getLogFont!initializing!private! !
hash!comparing!public! !
initialize!initializing!public! !
isBold!public!testing! !
isDefault!public!testing! !
isItalic!public!testing! !
isStruckThrough!public!testing! !
isUnderlined!public!testing! !
logFont!public! !
name!public! !
pixelSize!public! !
pointSize!accessing!public! !
postCopy!copying!public! !
resolution!accessing!public! !
resolution:!accessing!public!scaling! !
series!accessing!public! !
series:!accessing!public! !
setHandle:dpi:!initializing!private! !
setLogFont:dpi:!initializing!private! !
setOwnedHandle:dpi:!initializing!private! !
species!public! !
stbSaveOn:!binary filing!public! !
styleChanged!modes!private! !
unstyledCopy!copying!public! !
weight!accessing!public! !
!

!Graphics.AbstractFont class methodsFor!

default
	"Answers the default font for the system."

	^self fromId: DEFAULT_GUI_FONT
!

defaultPointSize
	"Private - Answer a default point size to use when it is not explicitly specified"

	^10!

fromHandle: aHandle
	Notification deprecated.	"Use #fromHandle:dpi:"
	^self fromHandle: aHandle dpi: SystemMetrics current dpi!

fromHandle: aHandle dpi: anInteger
	"Answers an instance of the receiver with aHandle that has been created for use at the specified DPI. The handle is not owned by the instance and will not therefore be freed by it."

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

	^Font basicNew setOwnedHandle: aHandle dpi: anInteger!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 'Font.ico'!

name: aString
	"Answer a new instance of the receiver for fontname aString and a default point size"

	^self name: aString pointSize: self defaultPointSize
!

name: aString pixelSize: anInteger
	"Answer a new instance of the receiver for fontname aString, and pixel size anInteger."

	^Font new
		name: aString; 
		pixelSize: anInteger;
		yourself!

name: aString pointSize: anInteger
	"Answer a new instance of the receiver for fontname aString, pointsize anInteger."

	^Font new
		name: aString; 
		pointSize: anInteger;
		yourself!

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
	^self fromId: SYSTEM_FONT! !

!Graphics.AbstractFont class categoriesForMethods!
default!instance creation!public! !
defaultPointSize!constants!private! !
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
stbConvertFrom:!binary filing!private! !
stbConvertFromVersion0:!binary filing!private! !
stbVersion!binary filing!public! !
system!instance creation!public! !
!

