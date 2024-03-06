"Filed out from Dolphin Smalltalk"!

GraphicsTool subclass: #Font
	instanceVariableNames: 'logfont dpi series'
	classVariableNames: 'System'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Font guid: (GUID fromString: '{87b4c634-026e-11d3-9fd7-00a0cc3e4a32}')!

Font comment: ''!

!Font categoriesForClass!Graphics-Tools! !

!Font methodsFor!

= aFont
	"Answer true if aFont is equal to (has the same logical font info) as the receiver."

	^self species == aFont species and: [logfont = aFont logFont]!

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

	^logfont createFont!

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
	"Sets the logical pixels per inch of the receiver. Note that if the dpi changes, this will free the font handle, breaking any existing uses. This tends to be obvious as controls will mysteriously start painting using some default font. Changing the DPI of a shared font must therefore be avoided. Instead use #atDpi: to get an equivalent Font at the desired scale."

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
	logfont := LOGFONTW newBuffer
				getData: handle;
				yourself!

handle: hFont
	"Sets the non-owned handle for the receiver and queries its logical info."

	super handle: hFont.
	logfont getData: hFont!

hash
	"Answer the SmallInteger hash value for the receiver."

	^logfont hash!

initialize
	"Initialise the receiver."

	super initialize.
	(logfont := LOGFONTW new) lfWeight: FW_NORMAL.
	dpi := SystemMetrics current dpi!

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

	^logfont lfItalic ~= 0!

isItalic: aBoolean
	"Set whether the receiver is an italic typeface."

	self isItalic == aBoolean ifTrue: [^self].
	logfont lfItalic: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self styleChanged!

isStruckThrough
	"Answer whether the strike-out effect is set."

	^logfont lfStrikeOut ~= 0!

isStruckThrough: aBoolean 
	"Set the struck out character effect."

	self isStruckThrough == aBoolean ifTrue: [^self].
	logfont lfStrikeOut: aBoolean asParameter.
	self styleChanged!

isUnderlined
	"Answer whether the receiver is underlined."

	^logfont lfUnderline ~= 0!

isUnderlined: aBoolean 
	"Reset the receiver's underline attribute."

	self isUnderlined == aBoolean ifTrue: [^self].
	logfont lfUnderline: aBoolean asParameter.
	self styleChanged!

logFont
	"Answer the receiver's logical attributes."

	^logfont!

logFont: aLOGFONT 
	"Set the receiver's logical attributes."

	logfont := aLOGFONT.
	self styleChanged!

name
	"Answer the face name of the font."

	^logfont faceName!

name: aString
	"Set the receiver's font name attribute. This has no affect if the receiver is already realized."

	logfont faceName: aString!

pixelFromPoints: size
	"Private - Answers a pixel size from a given point size."

	^(size * self dpi / 72) rounded!

pixelSize
	"Answers the receiver's pixel size."

	^self logFont lfHeight abs!

pixelSize: anInteger
	"Set's the receiver's pixel size to anInteger pixels.
	This has no affect if the receiver is already realized."

	self logFont lfHeight: anInteger negated!

pointFromPixels: size
	"Private - Answers a point size from a given pixel size."

	^(size * 72 / self dpi) rounded.
!

pointSize
	"Answers the receiver's point size."

	^self pointFromPixels: self logFont lfHeight abs!

pointSize: anInteger
	"Convert anInteger to pixels and store in the receiver's logfont lfHeight.
	This has no affect if the receiver is already realized."

	self logFont lfHeight: (self pixelFromPoints: anInteger) negated!

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

	aStream
		nextPut: $(;
		display: self class;
		nextPutAll: ' name: '; print: self name;
		nextPutAll: ' pointSize: '; print: self pointSize;
		nextPut: $)!

resolution
	"Answer the logical pixels per inch of the receiver"

	^dpi @ dpi!

resolution: aPoint
	"Sets the logical pixels per inch of the receiver. Note that this will free the font handle, so don't change the resolution of a shared font (use #withResolution:)."

	self dpi: aPoint y!

series
	^series ifNil: [FontSeries forFont: self]!

series: aFontSeries
	series := aFontSeries!

setHandle: anExternalHandle dpi: anInteger
	ownsHandle := false.
	handle := anExternalHandle.
	dpi := anInteger.
	self getLogFont.
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
pixelFromPoints:!mapping!private! !
pixelSize!accessing!public! !
pixelSize:!accessing!public! !
pointFromPixels:!mapping!private! !
pointSize!accessing!public! !
pointSize:!accessing!public! !
postCopy!copying!public! !
printOn:!development!printing!public! !
resolution!accessing!public! !
resolution:!accessing!public!scaling! !
series!accessing!public! !
series:!accessing!public! !
setHandle:dpi:!initializing!private! !
setLogFont:dpi:!initializing!private! !
setOwnedHandle:dpi:!initializing!private! !
styleChanged!modes!private! !
weight!accessing!public! !
weight:!accessing!public! !
!

!Font class methodsFor!

default
	"Answers the default font for the system."

	^self system
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

onPreStripImage
	"Private - The image is about to be stripped. Nil the lazily initialized cursors to allow
	them to be removed (and also perhaps the ref to the resource library)."

	self uninitialize!

reset
	"Clear down the receiver's lazily initialized class variables."

	System := nil!

stbConvertFrom: anSTBClassFormat
	| version |
	version := anSTBClassFormat version.
	version == 0 ifTrue: [^[:data | (self stbConvertFromVersion0: data) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersion0: anArray
	"Private - Convert from version 0 font. Version 1 adds series instance variable, which is lazily initialized, and the DPI is stored as an integer value rather than a <Point>"

	^(anArray resize: anArray size + 1)
		at: 4 put: (anArray at: 4) y;
		yourself!

stbVersion
	"Version 1 adds series inst var, and repurposes the resolution inst var to hold just the DPI (we don't need two dimensions to scale the font height)."

	^1!

system
	"Answer the stock System font."

	System isNil ifTrue: [System := StockFont fromId: SYSTEM_FONT].
	^System!

uninitialize
	"Uninitialize the class variables of the receiver as it is about to be removed from the system."

	System := nil! !

!Font class categoriesForMethods!
default!instance creation!public! !
defaultPointSize!constants!private! !
fromHandle:!instance creation!public! !
fromHandle:dpi:!instance creation!public! !
fromLogFont:!instance creation!public! !
fromLogFont:dpi:!instance creation!public! !
fromOwnedHandle:!instance creation!public! !
fromOwnedHandle:dpi:!instance creation!public! !
icon!constants!public! !
name:!instance creation!public! !
name:pixelSize:!instance creation!public! !
name:pointSize:!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
reset!instance creation!public! !
stbConvertFrom:!binary filing!private! !
stbConvertFromVersion0:!binary filing!private! !
stbVersion!binary filing!public! !
system!instance creation!public! !
uninitialize!class hierarchy-removing!private! !
!

