"Filed out from Dolphin Smalltalk"!

Graphics.GraphicsTool
	subclass: #'Graphics.AbstractFont'
	instanceVariableNames: 'logfont resolution'
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

	^self species == aFont species and: [self logFont = aFont logFont]!

actualFont
	^self!

characterSet
	"Answer an <integer> identifying the character set of the receiver."

	^self logFont lfCharSet!

createHandle
	"Private - Answer an external handle to a new font as described by the logfont structure."

	^self logFont createFont!

desktopResolution
	"Private - Answer the resolution of the active desktop."

	^Canvas desktopResolution!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: self name;
		nextPut: $\x20;
		display: self pointSize;
		nextPutAll: 'pt'!

hash
	"Answer the SmallInteger hash value for the receiver."

	^logfont hash!

initialize
	"Initialise the receiver."

	super initialize.
	resolution := self desktopResolution!

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

	^logfont!

name
	"Answer the face name of the font."

	^self logFont faceName!

pixelFromPoints: size
	"Private - Answers a pixel size from a given point size."

	^(size * resolution y / 72) rounded.
!

pixelSize
	"Answers the receiver's pixel size."

	^self logFont lfHeight abs!

pointFromPixels: size
	"Private - Answers a point size from a given pixel size."

	^(size * 72 / resolution y) rounded.
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
	^self!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	aStream
		nextPut: $(;
		display: Font;
		nextPutAll: ' name: '; print: self name;
		nextPutAll: ' pointSize: '; print: self pointSize;
		nextPut: $)!

resolution
	"Answer the logical pixels per inch of the receiver"

	^resolution!

resolution: aPoint 
	"Sets the logical pixels per inch of the receiver"

	"Check the resolution for the receiver to see if it matches
	the supplied resolution in aPoint. If not, then the logical font information
	is rescaled and the receiver's resolution is changed to that in aPoint."

	| oldres |
	resolution = aPoint ifTrue: [^self].
	self free.
	oldres := resolution.
	
	[| ptSize |
	ptSize := self pointSize.
	resolution := aPoint.
	self pointSize: ptSize] 
			ifCurtailed: [resolution := oldres]!

species
	^Font!

unstyledCopy
	"Answer a new <Font> that is the same as the receiver, but without any styling (i.e. without italics, bold, or underlining)."

	^Font name: self name pixelSize: self pixelSize!

weight
	"Answer the receiver's <integer> 'weight' (thickness)."

	^self logFont lfWeight! !
!Graphics.AbstractFont categoriesForMethods!
=!comparing!public! !
actualFont!public! !
characterSet!accessing!public! !
createHandle!private!realizing/unrealizing! !
desktopResolution!initializing!private! !
displayOn:!displaying!public! !
hash!comparing!public! !
initialize!initializing!public! !
isBold!public!testing! !
isDefault!public!testing! !
isItalic!public!testing! !
isStruckThrough!public!testing! !
isUnderlined!public!testing! !
logFont!accessing!public! !
name!accessing!public! !
pixelFromPoints:!mapping!private! !
pixelSize!accessing!public! !
pointFromPixels:!mapping!private! !
pointSize!accessing!public! !
pointSize:!accessing!public! !
postCopy!copying!public! !
printOn:!development!printing!public! !
resolution!accessing!public! !
resolution:!accessing!public! !
species!public! !
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

fromId: anInteger
	"Answer a new instance of the receiver representing the stock font id anInteger."

	^StockFont new
		setId: anInteger;
		yourself!

fromLogFont: aLOGFONT
	"Answer a new instance of the receiver with specified logical attributes."

	^Font new setLogFont: aLOGFONT!

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

system
	"Answer the stock System font."

	^self fromId: SYSTEM_FONT! !
!Graphics.AbstractFont class categoriesForMethods!
default!instance creation!public! !
defaultPointSize!constants!private! !
fromId:!instance creation!public! !
fromLogFont:!instance creation!public! !
icon!constants!public! !
name:!instance creation!public! !
name:pixelSize:!instance creation!public! !
name:pointSize:!instance creation!public! !
system!instance creation!public! !
!

