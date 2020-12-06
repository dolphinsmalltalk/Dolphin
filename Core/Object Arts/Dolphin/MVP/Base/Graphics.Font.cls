"Filed out from Dolphin Smalltalk 7"!

Graphics.GraphicsTool subclass: #'Graphics.Font'
	instanceVariableNames: 'logfont resolution'
	classVariableNames: 'System'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Font guid: (Core.GUID fromString: '{87b4c634-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.Font comment: ''!
!Graphics.Font categoriesForClass!Graphics-Tools! !
!Graphics.Font methodsFor!

= aFont
	"Answer true if aFont is equal to (has the same logical font info) as the receiver."

	^self species == aFont species and: [logfont = aFont logFont]!

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
	self free!

createHandle
	"Private - Answer an external handle to a new font as described by the logfont structure."

	^logfont createFont!

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
	resolution := self desktopResolution!

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
	self free!

isStruckThrough
	"Answer whether the strike-out effect is set."

	^logfont lfStrikeOut ~= 0!

isStruckThrough: aBoolean 
	"Set the struck out character effect."

	self isStruckThrough == aBoolean ifTrue: [^self].
	logfont lfStrikeOut: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self free!

isUnderlined
	"Answer whether the receiver is underlined."

	^logfont lfUnderline ~= 0!

isUnderlined: aBoolean 
	"Reset the receiver's underline attribute."

	self isUnderlined == aBoolean ifTrue: [^self].
	logfont lfUnderline: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self free!

logFont
	"Answer the receiver's logical attributes."

	^logfont!

logFont: aLOGFONT 
	"Set the receiver's logical attributes."

	logfont := aLOGFONT.
	self free!

name
	"Answer the face name of the font."

	^logfont faceName!

name: aString
	"Set the receiver's font name attribute. This has no affect if the receiver is already realized."

	logfont faceName: aString!

pixelFromPoints: size
	"Private - Answers a pixel size from a given point size."

	^(size * resolution y / 72) rounded.
!

pixelSize
	"Answers the receiver's pixel size."

	^self logFont lfHeight abs!

pixelSize: anInteger
	"Set's the receiver's pixel size to anInteger pixels.
	This has no affect if the receiver is already realized."

	self logFont lfHeight: anInteger negated!

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
		display: self class;
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

weight
	"Answer the receiver's <integer> 'weight' (thickness)."

	^logfont lfWeight!

weight: anInteger 
	"Set the receiver's 'weight' (thickness)."

	self weight = anInteger ifTrue: [^self].
	logfont lfWeight: anInteger.
	"Cause the receiver to be re-realized"
	self free! !
!Graphics.Font categoriesFor: #=!comparing!public! !
!Graphics.Font categoriesFor: #beBold!accessing!public! !
!Graphics.Font categoriesFor: #beItalic!accessing!public! !
!Graphics.Font categoriesFor: #beUnderlined!accessing!public! !
!Graphics.Font categoriesFor: #characterSet!accessing!public! !
!Graphics.Font categoriesFor: #characterSet:!accessing!public! !
!Graphics.Font categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Font categoriesFor: #desktopResolution!initializing!private! !
!Graphics.Font categoriesFor: #displayOn:!displaying!public! !
!Graphics.Font categoriesFor: #handle:!accessing!public! !
!Graphics.Font categoriesFor: #hash!comparing!public! !
!Graphics.Font categoriesFor: #initialize!initializing!public! !
!Graphics.Font categoriesFor: #isBold!public!testing! !
!Graphics.Font categoriesFor: #isBold:!modes!public! !
!Graphics.Font categoriesFor: #isDefault!public!testing! !
!Graphics.Font categoriesFor: #isItalic!public!testing! !
!Graphics.Font categoriesFor: #isItalic:!modes!public! !
!Graphics.Font categoriesFor: #isStruckThrough!public!testing! !
!Graphics.Font categoriesFor: #isStruckThrough:!accessing!public! !
!Graphics.Font categoriesFor: #isUnderlined!public!testing! !
!Graphics.Font categoriesFor: #isUnderlined:!modes!public! !
!Graphics.Font categoriesFor: #logFont!accessing!public! !
!Graphics.Font categoriesFor: #logFont:!accessing!public! !
!Graphics.Font categoriesFor: #name!accessing!public! !
!Graphics.Font categoriesFor: #name:!accessing!public! !
!Graphics.Font categoriesFor: #pixelFromPoints:!mapping!private! !
!Graphics.Font categoriesFor: #pixelSize!accessing!public! !
!Graphics.Font categoriesFor: #pixelSize:!accessing!public! !
!Graphics.Font categoriesFor: #pointFromPixels:!mapping!private! !
!Graphics.Font categoriesFor: #pointSize!accessing!public! !
!Graphics.Font categoriesFor: #pointSize:!accessing!public! !
!Graphics.Font categoriesFor: #postCopy!copying!public! !
!Graphics.Font categoriesFor: #printOn:!development!printing!public! !
!Graphics.Font categoriesFor: #resolution!accessing!public! !
!Graphics.Font categoriesFor: #resolution:!accessing!public! !
!Graphics.Font categoriesFor: #weight!accessing!public! !
!Graphics.Font categoriesFor: #weight:!accessing!public! !

!Graphics.Font class methodsFor!

default
	"Answers the default font for the system."

	^self system
!

defaultPointSize
	"Private - Answer a default point size to use when it is not explicitly specified"

	^10!

fromLogFont: aLOGFONT
	"Answer a new instance of the receiver with specified logical attributes."

	^self new
		logFont: aLOGFONT;
		yourself!

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

system
	"Answer the stock System font."

	System isNil ifTrue: [System := StockFont fromId: SYSTEM_FONT].
	^System!

uninitialize
	"Uninitialize the class variables of the receiver as it is about to be removed from the system."

	System := nil! !
!Graphics.Font class categoriesFor: #default!instance creation!public! !
!Graphics.Font class categoriesFor: #defaultPointSize!constants!private! !
!Graphics.Font class categoriesFor: #fromLogFont:!instance creation!public! !
!Graphics.Font class categoriesFor: #icon!constants!public! !
!Graphics.Font class categoriesFor: #name:!instance creation!public! !
!Graphics.Font class categoriesFor: #name:pixelSize:!instance creation!public! !
!Graphics.Font class categoriesFor: #name:pointSize:!instance creation!public! !
!Graphics.Font class categoriesFor: #onPreStripImage!class hierarchy-removing!private! !
!Graphics.Font class categoriesFor: #reset!instance creation!public! !
!Graphics.Font class categoriesFor: #system!instance creation!public! !
!Graphics.Font class categoriesFor: #uninitialize!class hierarchy-removing!private! !

