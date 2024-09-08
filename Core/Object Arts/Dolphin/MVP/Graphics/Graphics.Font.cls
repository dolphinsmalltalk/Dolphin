"Filed out from Dolphin Smalltalk"!

Graphics.AbstractFont
	subclass: #'Graphics.Font'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'Qualities'
				-> #(#default #draft #proof #nonantialiased #antialiased #cleartype #cleartypeNatural)
		}!

Graphics.Font guid: (Core.GUID fromString: '{87b4c634-026e-11d3-9fd7-00a0cc3e4a32}')!

Graphics.Font comment: ''!

!Graphics.Font categoriesForClass!Graphics-Tools! !

!Graphics.Font methodsFor!

beBold
	"Set the receiver's bold attribute."

	self isBold: true!

beItalic
	"Set the receiver's italic attribute."

	self isItalic: true!

beUnderlined
	"Set the receiver's underline attribute."

	self isUnderlined: true!

characterSet: anInteger 
	"Set the <integer> identifying the character set of the receiver."

	anInteger = self characterSet ifTrue: [^self].
	logfont lfCharSet: anInteger.
	self styleChanged!

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

isBold: aBoolean
	"Set the receiver's bold attribute."

	self weight: (aBoolean ifTrue: [FW_BOLD] ifFalse: [FW_NORMAL])!

isItalic: aBoolean 
	"Set whether the receiver is an italic typeface."

	self isItalic == aBoolean ifTrue: [^self].
	logfont lfItalic: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self styleChanged!

isStruckThrough: aBoolean 
	"Set the struck out character effect."

	self isStruckThrough == aBoolean ifTrue: [^self].
	logfont lfStrikeOut: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self styleChanged!

isUnderlined: aBoolean 
	"Reset the receiver's underline attribute."

	self isUnderlined == aBoolean ifTrue: [^self].
	logfont lfUnderline: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self styleChanged!

logFont: aLOGFONT 
	"Set the receiver's logical attributes."

	logfont := aLOGFONT.
	self styleChanged!

name: aString
	"Set the receiver's font name attribute. This has no affect if the receiver is already realized."

	self logFont faceName: aString!

pixelSize: anInteger
	"Set's the receiver's pixel size to anInteger pixels.
	This has no affect if the receiver is already realized."

	self logFont lfHeight: anInteger negated!

pointSize: anInteger
	"Convert anInteger to pixels and store in the receiver's logfont lfHeight.
	This has no affect if the receiver is already realized."

	self logFont lfHeight: (anInteger * self dpi / 72) rounded negated!

printOn: aStream
	"Append, to aStream, a String whose characters are a description of the receiver as a developer
	would want to see it."

	| attributes weight |
	(series notNil and: [series canonical ~~ self])
		ifTrue: 
			[series canonical printOn: aStream.
			^self].
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
	Setting this value causes the Font to be re-realised so should not be done to a Font that is in use."

	self quality == aSymbol ifTrue: [^self].
	logfont lfQuality: (Qualities identityIndexOf: aSymbol) - 1.
	self styleChanged!

styleChanged
	"Private - An attribute of the receiver has been changed, invalidating the handle and the relationship to the series."

	self free.
	series := nil!

weight: anInteger 
	"Set the receiver's 'weight' (thickness)."

	self weight = anInteger ifTrue: [^self].
	logfont lfWeight: anInteger.
	"Cause the receiver to be re-realized"
	self styleChanged! !

!Graphics.Font categoriesForMethods!
beBold!accessing!public! !
beItalic!accessing!public! !
beUnderlined!accessing!public! !
characterSet:!accessing!public! !
dpi:!accessing!public!scaling! !
getLogFont!initializing!private! !
handle:!accessing!public! !
isBold:!modes!public! !
isItalic:!modes!public! !
isStruckThrough:!accessing!public! !
isUnderlined:!modes!public! !
logFont:!accessing!public! !
name:!accessing!public! !
pixelSize:!accessing!public! !
pointSize:!accessing!public! !
printOn:!development!printing!public! !
quality!accessing!public! !
quality:!accessing!public! !
styleChanged!helpers!private! !
weight:!accessing!public! !
!

!Graphics.Font class methodsFor!

fromHandle: aHandle
	Notification deprecated.	"Use #fromHandle:dpi:"
	^self fromHandle: aHandle dpi: SystemMetrics current dpi!

fromHandle: aHandle dpi: anInteger
	"Answers an instance of the receiver with aHandle that has been created for use at the specified DPI. The handle is not owned by the instance and will not therefore be freed by it."

	aHandle = System handle ifTrue: [^System].
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

	^self basicNew setOwnedHandle: aHandle dpi: anInteger! !

!Graphics.Font class categoriesForMethods!
fromHandle:!instance creation!public! !
fromHandle:dpi:!instance creation!public! !
fromLogFont:!instance creation!public! !
fromLogFont:dpi:!instance creation!public! !
fromOwnedHandle:!instance creation!public! !
fromOwnedHandle:dpi:!instance creation!public! !
!

