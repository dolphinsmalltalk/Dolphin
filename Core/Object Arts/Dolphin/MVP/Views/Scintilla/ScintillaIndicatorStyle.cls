"Filed out from Dolphin Smalltalk X6.1"!

QueryableScintillaAttribute subclass: #ScintillaIndicatorStyle
	instanceVariableNames: 'forecolor style under name alphaPercent'
	classVariableNames: 'StyleNames'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaIndicatorStyle guid: (GUID fromString: '{2DE64FD7-5B9F-4AC7-81C6-912B56B41A4F}')!
ScintillaIndicatorStyle comment: 'ScintillaIndicatorStyle instances represent the indicator configuration for a particular <ScintillaView>.

Indicators are orthogonal to visual styles, and can be used to highlight areas of text regardless of styling. A common example usage would be highlight erroneous text by underlining it with a squiggly line.

Older versions of Scintilla supported only 3 indicator types. Indicators shared the styling byte associated with each character, with 5 bits of that byte being allocated to the styles in the normal configuration, although this could be changed (see ScintillaView>>styleBits:). Each character position may only have one visual style, so the 5 bits provided for 32 possible visual styles. Unlike the visual styles, however, each character may have any combination of indicators set, so the 3-bits available for indicators equated to only 3 indicator types. In other words each indicator type required that a bit be reserved.

As of Scintilla 1.75 indicators have become more useful as they can be independent of styles. This means all style bits are available for styles (now up to 255), but also that indicators can be applied completely independently and that there are now up to 32 different types of indicator available. In our original Dolphin wrapping we didn''t name indicator styles because of the implementation. Our wrapper now supports the more powerful and numerous "modern indicators", and indicators are now named symbolically. 

Indicator styles are separated into two ranges:
	0..INDIC_CONTAINER-1			(0..7)		Reserved for use by lexers
	INDIC_CONTAINER..INDIC_MAX		(8..31)		Available for use by the container

Named indicators are automatically allocated an id in the container range. There is a limit of 24 of these. Any that are unconfigured are hidden; they can be set, but will have no visual effect.

The style of lexer indicators can be configured by adding a <ScintillaIndicatorStyle> to the #indicatorStyles collection and explicitly setting the Id to the desired integer value. This can be useful when debugging a <ScintillaStyler> that is using indicators for mark text regions for internal purposes. For example the <SmalltalkStyler> uses an indicator to mark text regions that are covered by literal arrays. Normally indicators used for such purposes would be configured as invisible.

For historical reasons the first 3 indicator styles are preconfigured by Scintilla. If you don''t configure these in the indicatorStyles collection then they will remain with default settings, as described in the Scintilla documentation.

A fixed set of named styles is supported:
	#underline		Underlines the text with a straight line
	#squiggle		Underlines the text with a squiggly line
	#tt			Underlines the text with a dashed line made up of little T''s
	#hatch		Underlines the text with a line of diagonal dashes
	#strikeOut		Strikes through the text with a straight line
	#hidden		An invisible indicator (can be used to temporarily hide a particular indicator type without removing it from the text)
	#box			Surrounds the text with a box
	#roundBox	Surrounds the text with a translucent round cornered box drawn with alpha blending so that the interior is more tranlucent than the edges.

Instance Variables:
	forecolor	<Color>. Foreground colour used to draw the indicator.
	style		<integer> from the INDIC_xxxx enumeration. These relate to the named styles listed above.
	under	<boolean>. Determines whether the indicator is drawn under or over the text when two phase drawing is enabled.
	name	<symbol> uniquely naming a container indicator, or <integer> id of the lexer indicator
'!
!ScintillaIndicatorStyle categoriesForClass!MVP-Views-Support! !
!ScintillaIndicatorStyle methodsFor!

alphaPercent
	"Answer an <integer> representing the percentage alpha (transparency) for the indicator.
	Note that this is a percentage (hence the name), and not the usual 0..255 range. Zero
	represents completely transparent, 100 completely opaque. Note that this is currently only
	relevant for the #roundBox indicator style."


	^alphaPercent ifNil: [30]!

alphaPercent: anInteger 
	"Set the percentage alpha (transparency) for the indicator to the <integer> argument. Note
	that this is a percentage (hence the name), and not the usual 0..255 range. Zero represents
	completely transparent, 100 completely opaque. Note that this is currently only relevant for
	the #roundBox indicator style."

	alphaPercent := anInteger.
	self updateViewAttribute: #alphaPercent!

basicId
	^id ifNil: [name isInteger ifTrue: [id := name]]!

forecolor
	^forecolor ifNotNil: [:color | color isInteger ifTrue: [Color fromInteger: color] ifFalse: [color]]!

forecolor: aColor 
	forecolor := aColor asParameter."isInteger ifTrue: [Color fromInteger: aColor] ifFalse: [aColor]."
	self updateViewAttribute: #forecolor!

initialize
	style := INDIC_PLAIN.
	forecolor := 0.
	under := false.
	alphaPercent := 30!

isUnderText
	^under!

isUnderText: aBoolean 
	under := aBoolean asBoolean.
	self updateViewAttribute: #isUnderText!

name
	^name ifNil: ['indicator' , self id displayString]!

name: anObject 
	name = anObject ifTrue: [^self].
	name := anObject isInteger 
				ifTrue: [id := anObject]
				ifFalse: [anObject isEmpty ifFalse: [anObject asSymbol]]!

printableAttributes
	^(super printableAttributes)
		remove: #style;
		add: #styleName;
		yourself!

style
	^style!

style: anInteger 
	(anInteger between: INDIC_PLAIN and: INDIC_ROUNDBOX) 
		ifFalse: [^self error: 'Invalid indicator style'].
	style := anInteger.
	self updateViewAttribute: #style!

styleName
	^StyleNames at: self style + 1!

styleName: aSymbol 
	self 
		style: (StyleNames indexOf: aSymbol
				ifAbsent: [^self error: 'Unrecognised style name: ' , aSymbol]) - 1! !
!ScintillaIndicatorStyle categoriesFor: #alphaPercent!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #alphaPercent:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #basicId!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #forecolor!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #forecolor:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #initialize!private! !
!ScintillaIndicatorStyle categoriesFor: #isUnderText!public!testing! !
!ScintillaIndicatorStyle categoriesFor: #isUnderText:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #name!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #name:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #printableAttributes!development!helpers!printing!private! !
!ScintillaIndicatorStyle categoriesFor: #style!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #style:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #styleName!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #styleName:!accessing!public! !

!ScintillaIndicatorStyle class methodsFor!

initialize
	"
		self initialize
	"

	StyleNames := #(#underline #squiggle #tt #hatch #strikeOut #hidden #box #roundBox).
	getMessages := (IdentityDictionary new)
				at: #forecolor: put: SCI_INDICGETFORE;
				at: #style: put: SCI_INDICGETSTYLE;
				at: #isUnderText: put: SCI_INDICGETUNDER;
				at: #alphaPercent put: SCI_INDICGETALPHA;
				shrink;
				isImmutable: true;
				yourself.
	attributes := (IdentityDictionary new)
				at: #forecolor put: SCI_INDICSETFORE;
				at: #style put: SCI_INDICSETSTYLE;
				at: #isUnderText put: SCI_INDICSETUNDER;
				at: #alphaPercent put: SCI_INDICSETALPHA;
				shrink;
				isImmutable: true;
				yourself!

new
	^(super new)
		initialize;
		yourself!

stbConvertFrom: anSTBClassFormat 
	^
	[:vars | 
	| instance |
	instance := self new.
	vars keysAndValuesDo: [:eachKey :eachValue | instance instVarAt: eachKey put: eachValue].
	instance]!

stbVersion
	^1! !
!ScintillaIndicatorStyle class categoriesFor: #initialize!initializing!public! !
!ScintillaIndicatorStyle class categoriesFor: #new!public! !
!ScintillaIndicatorStyle class categoriesFor: #stbConvertFrom:!binary filing!private! !
!ScintillaIndicatorStyle class categoriesFor: #stbVersion!binary filing!public! !

