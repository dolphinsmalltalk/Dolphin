"Filed out from Dolphin Smalltalk"!

Graphics.AbstractFont
	subclass: #'Graphics.Font'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

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
	self free!

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
	self free!

isStruckThrough: aBoolean 
	"Set the struck out character effect."

	self isStruckThrough == aBoolean ifTrue: [^self].
	logfont lfStrikeOut: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self free!

isUnderlined: aBoolean 
	"Reset the receiver's underline attribute."

	self isUnderlined == aBoolean ifTrue: [^self].
	logfont lfUnderline: aBoolean asParameter.
	"Cause the receiver to be re-realized"
	self free!

logFont: aLOGFONT 
	"Set the receiver's logical attributes."

	logfont := aLOGFONT.
	self free!

name: aString
	"Set the receiver's font name attribute. This has no affect if the receiver is already realized."

	self logFont faceName: aString!

pixelSize: anInteger
	"Set's the receiver's pixel size to anInteger pixels.
	This has no affect if the receiver is already realized."

	self logFont lfHeight: anInteger negated!

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

weight: anInteger 
	"Set the receiver's 'weight' (thickness)."

	self weight = anInteger ifTrue: [^self].
	logfont lfWeight: anInteger.
	"Cause the receiver to be re-realized"
	self free! !

!Graphics.Font categoriesForMethods!
beBold!accessing!public! !
beItalic!accessing!public! !
beUnderlined!accessing!public! !
characterSet:!accessing!public! !
getLogFont!initializing!private! !
handle:!accessing!public! !
isBold:!modes!public! !
isItalic:!modes!public! !
isStruckThrough:!accessing!public! !
isUnderlined:!modes!public! !
logFont:!accessing!public! !
name:!accessing!public! !
pixelSize:!accessing!public! !
printOn:!development!printing!public! !
weight:!accessing!public! !
!

