"Filed out from Dolphin Smalltalk 7"!

QueryableScintillaAttribute subclass: #ScintillaIndicatorStyle
	instanceVariableNames: 'forecolor style under name alpha hoverStyle hoverForecolor flags foreAlpha reserved'
	classVariableNames: 'StyleNames'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaIndicatorStyle guid: (GUID fromString: '{2de64fd7-5b9f-4ac7-81c6-912b56b41a4f}')!
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
	alpha	<integer> 0..255 opacity (for indicatory styles for which this is relevant)
	hoverStyle	<integer> Hover style code
	
'!
!ScintillaIndicatorStyle categoriesForClass!MVP-Views-Support! !
!ScintillaIndicatorStyle methodsFor!

alpha
	"Answer the alpha value for the transparency of the background of box indicator styles"

	^alpha!

alpha: anInteger
	self basicAlpha: (anInteger isNil
				ifFalse: 
					[self getAlpha: anInteger default: 30	"Magic number from the Scintilla code - no const for this"]).
	self updateViewProperty: #alpha!

basicAlpha: anIntegerOrNil
	alpha := anIntegerOrNil!

basicForeAlpha: anIntegerOrNil
	foreAlpha := anIntegerOrNil!

basicForecolor
	^forecolor!

basicForecolor: aColorOrNil 
	forecolor := aColorOrNil!

basicHoverForecolor
	^hoverForecolor!

basicHoverForecolor: anObject
	hoverForecolor := anObject!

basicHoverStyle: anIntegerOrNil
	hoverStyle := anIntegerOrNil!

basicId
	^id ifNil: [name isInteger ifTrue: [id := name]]!

basicIsUnderText
	^under!

basicIsUnderText: anIntegerOrNil
	under := anIntegerOrNil!

basicStyle: anIntegerOrNil
	style := anIntegerOrNil!

checkIndicatorStyle: anInteger 
	(anInteger isNil or: [anInteger between: INDIC_PLAIN and: INDIC_MAX]) 
		ifFalse: [self error: 'Invalid indicator style']!

flags
	^flags!

flags: anInteger 
	flags := anInteger!

foreAlpha
	"Answer the alpha value for the transparency of the foreground of box indicator styles, or
	nil if the default (50) is to be used."

	^foreAlpha!

foreAlpha: anInteger
	self basicForeAlpha: (anInteger isNil
				ifFalse: 
					["Magic number for default value is from the Scintilla code - no const for this"
					self getAlpha: anInteger default: 50]).
	self updateViewProperty: #foreAlpha!

forecolor
	^self basicForecolor ifNotNil: [:rgbVal | Color fromInteger: rgbVal]!

forecolor: aColorOrNil
	self basicForecolor: (aColorOrNil isNil ifFalse: [aColorOrNil asParameter]).
	self updateViewProperty: #forecolor.
	self hoverForecolor isNil ifFalse: [self updateViewProperty: #hoverForecolor]!

getAlpha: anInteger default: defaultInteger 
	^anInteger = defaultInteger 
		ifFalse: 
			[(anInteger between: SC_ALPHA_TRANSPARENT and: SC_ALPHA_OPAQUE) 
				ifTrue: [anInteger]
				ifFalse: [self error: 'Invalid alpha value ' , anInteger displayString]]!

hoverForecolor
	"Answer the foreground <Color> used for the indicator when hovering."

	^self basicHoverForecolor ifNotNil: [:rgbVal | Color fromInteger: rgbVal]!

hoverForecolor: aColorOrNil
	self basicHoverForecolor: (aColorOrNil ifNotNil: [aColorOrNil asRGB asParameter]).
	self updateViewProperty: #hoverForecolor!

hoverStyle
	^hoverStyle!

hoverStyle: anInteger
	self checkIndicatorStyle: anInteger.
	self basicHoverStyle: (anInteger = self style ifFalse: [anInteger])!

hoverStyleName
	"Answer the symbolic name of the indicator style used either an indicator of this style is
	hovered over, or when the caret is within the text range of the indicator."

	^self hoverStyle ifNotNil: [:s | self class styleNames at: s + 1]!

hoverStyleName: aSymbol
	self hoverStyle: (self styleFromName: aSymbol).
	self updateViewProperty: #hoverStyleName!

isUnderText
	^(self basicIsUnderText ?? 0) asBoolean!

isUnderText: aBooleanOrNil
	self basicIsUnderText: (aBooleanOrNil ?? false ifTrue: [1]).
	self updateViewProperty: #isUnderText!

name
	^name ifNil: ['indicator' , self id displayString]!

name: anObject 
	name = anObject ifTrue: [^self].
	name := anObject isInteger 
				ifTrue: [id := anObject]
				ifFalse: [anObject isEmpty ifFalse: [anObject asSymbol]]!

propertyMapDo: aMonadicValuable
	"Private - Evaluate the <monadicValuable> argument for each of the indicator style settings' property descriptors.
	The hover styles are enumerated last as these must be applied after the normal style as (unfortunately) setting the
	normal style resets the hover style."

	| setLast map |
	setLast := #(#hoverForecolor #hoverStyleName).
	map := self propertyMap.
	map
		keysAndValuesDo: [:eachKey :eachValue | (setLast includes: eachKey) ifFalse: [aMonadicValuable value: eachValue]].
	setLast do: [:each | aMonadicValuable value: (map at: each)]!

style
	^style!

style: anInteger
	self checkIndicatorStyle: anInteger.
	self basicStyle: anInteger!

styleFromName: aSymbolOrNil 
	^aSymbolOrNil isNil 
		ifFalse: 
			[(self class styleNames indexOf: aSymbolOrNil
				ifAbsent: [self error: 'Unrecognised style name: ' , aSymbolOrNil]) - 1]!

styleName
	^self style ifNotNil: [:s | self class styleNames at: s + 1]!

styleName: aSymbol
	self style: (self styleFromName: aSymbol).
	self updateViewProperty: #styleName.
	"If the style is set, the control, rather annoyingly, overwrites the hover style, so we need
	to set that again too (if set)."
	hoverStyle isNil ifFalse: [self updateViewProperty: #hoverStyleName]! !
!ScintillaIndicatorStyle categoriesFor: #alpha!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #alpha:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #basicAlpha:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicForeAlpha:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicForecolor!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicForecolor:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicHoverForecolor!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicHoverForecolor:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicHoverStyle:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicId!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicIsUnderText!private!testing! !
!ScintillaIndicatorStyle categoriesFor: #basicIsUnderText:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #basicStyle:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #checkIndicatorStyle:!helpers!private! !
!ScintillaIndicatorStyle categoriesFor: #flags!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #flags:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #foreAlpha!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #foreAlpha:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #forecolor!accessing!colors!public! !
!ScintillaIndicatorStyle categoriesFor: #forecolor:!accessing!colors!public! !
!ScintillaIndicatorStyle categoriesFor: #getAlpha:default:!helpers!private! !
!ScintillaIndicatorStyle categoriesFor: #hoverForecolor!accessing!colors!public! !
!ScintillaIndicatorStyle categoriesFor: #hoverForecolor:!accessing!colors!public! !
!ScintillaIndicatorStyle categoriesFor: #hoverStyle!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #hoverStyle:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #hoverStyleName!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #hoverStyleName:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #isUnderText!public!testing! !
!ScintillaIndicatorStyle categoriesFor: #isUnderText:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #name!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #name:!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #propertyMapDo:!helpers!private! !
!ScintillaIndicatorStyle categoriesFor: #style!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #style:!accessing!private! !
!ScintillaIndicatorStyle categoriesFor: #styleFromName:!helpers!private! !
!ScintillaIndicatorStyle categoriesFor: #styleName!accessing!public! !
!ScintillaIndicatorStyle categoriesFor: #styleName:!accessing!public! !

!ScintillaIndicatorStyle class methodsFor!

initialize
	"
		self initialize
	"

	propertyMap := (IdentityDictionary new)
				at: #forecolor
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #basicForecolor
							defaultValue: Color black asParameter
							setMessage: SCI_INDICSETFORE
							setSelector: #basicForecolor:
							getMessage: SCI_INDICGETFORE);
				at: #styleName
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #style
							defaultValue: nil
							setMessage: SCI_INDICSETSTYLE
							setSelector: #basicStyle:
							getMessage: SCI_INDICGETSTYLE);
				at: #hoverStyleName
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #hoverStyle
							defaultValue: INDIC_SQUIGGLE
							setMessage: SCI_INDICSETHOVERSTYLE
							setSelector: #basicHoverStyle:
							getMessage: SCI_INDICGETHOVERSTYLE);
				at: #isUnderText
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #basicIsUnderText
							defaultValue: 0
							setMessage: SCI_INDICSETUNDER
							setSelector: #basicIsUnderText:
							getMessage: SCI_INDICGETUNDER);
				at: #alpha
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #alpha
							defaultValue: 30
							setMessage: SCI_INDICSETALPHA
							setSelector: #basicAlpha:
							getMessage: SCI_INDICGETALPHA);
				at: #hoverForecolor
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #basicHoverForecolor
							defaultValue: Color black asParameter
							setMessage: SCI_INDICSETHOVERFORE
							setSelector: #basicHoverForecolor:
							getMessage: SCI_INDICGETHOVERFORE);
				at: #flags
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #flags
							defaultValue: 0
							setMessage: SCI_INDICSETFLAGS
							setSelector: #flags:
							getMessage: SCI_INDICGETFLAGS);
				at: #foreAlpha
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #foreAlpha
							defaultValue: 50
							setMessage: SCI_INDICSETOUTLINEALPHA
							setSelector: #basicForeAlpha:
							getMessage: SCI_INDICSETOUTLINEALPHA);
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
	^2!

styleNames
	^#(#underline #squiggle #tt #hatch #strikeOut #hidden #box #roundBox #container #dash #dots #squiggleLow #dotBox #squigglePixmap #compositionThick #compositionThin #fullBox #textFore #point #pointCharacter #gradient #gradientCentre)! !
!ScintillaIndicatorStyle class categoriesFor: #initialize!initializing!public! !
!ScintillaIndicatorStyle class categoriesFor: #new!public! !
!ScintillaIndicatorStyle class categoriesFor: #stbConvertFrom:!binary filing!private! !
!ScintillaIndicatorStyle class categoriesFor: #stbVersion!binary filing!public! !
!ScintillaIndicatorStyle class categoriesFor: #styleNames!initializing!public! !

