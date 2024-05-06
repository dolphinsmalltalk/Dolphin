"Filed out from Dolphin Smalltalk"!

QueryableScintillaAttribute subclass: #ScintillaIndicatorStyle
	instanceVariableNames: 'forecolor style under name alpha hoverStyle hoverForecolor flags foreAlpha _reserved12'
	classVariableNames: 'HoverForecolor HoverStyle IndicatorStyles StyleNames'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaIndicatorStyle guid: (GUID fromString: '{2de64fd7-5b9f-4ac7-81c6-912b56b41a4f}')!

ScintillaIndicatorStyle addClassConstant: 'IndicatorStyles' value: #(#underline #squiggle #tt #hatch #strikeOut #hidden #box #roundBox #straightBox #dash #dots #squiggleLow #dotBox #squigglePixmap #compositionThick #compositionThin #fullBox #textFore #point #pointCharacter)!

ScintillaIndicatorStyle comment: '`ScintillaIndicatorStyle` instances represent the indicator configuration for a particular `ScintillaView`.

Indicators are orthogonal to visual styles, and can be used to highlight areas of text regardless of styling. A common example usage would be highlight erroneous text by underlining it with a squiggly line.

Older versions of Scintilla supported only 3 indicator types and shared the styling byte associated with each character. As of Scintilla 1.75 indicators have become more useful as they can be independent of styles. This means all style bits are available for styles (now up to 255), but also that indicators can be applied completely independently and that there are now up to 32 different types of indicator available. In our original Dolphin wrapping we didn''t name indicator styles because of the implementation. Our wrapper now supports the more powerful and numerous "modern indicators", and indicators are now named symbolically. 

Indicator styles are separated into two ranges:
	`0..INDIC_CONTAINER-1`			(0..7)		Reserved for use by lexers
	`INDIC_CONTAINER..INDIC_MAX`	(8..31)		Available for use by the container

Named indicators are automatically allocated an id in the container range. There is a limit of 24 of these. Any that are unconfigured are hidden; they can be set, but will have no visual effect.

The style of lexer indicators can be configured by adding a `ScintillaIndicatorStyle` to the `#indicatorStyles` collection and explicitly setting the Id to the desired integer value. This can be useful when debugging a `ScintillaStyler` that is using indicators for mark text regions for internal purposes. For example the `SmalltalkStyler` uses an indicator to mark text regions that are covered by literal arrays. Normally indicators used for such purposes would be configured as invisible (hidden).

For historical reasons the first 3 indicator styles are preconfigured by Scintilla. If you don''t configure these in the indicatorStyles collection then they will remain with default settings, as described in the Scintilla documentation.

A fixed set of named styles is supported, although this tends to get added to over time as Scintilla evolves:
  `#underline`			Underlines the text with a straight line
  `#squiggle`			Underlines the text with a squiggly line
  `#tt`				Underlines the text with a dashed line made up of little T''s
  `#hatch`				Underlines the text with a line of diagonal dashes
  `#strikeOut`			Strikes through the text with a straight line
  `#hidden`			An invisible indicator (can be used to temporarily hide a particular indicator type without removing it from the text)
  `#box`				Surrounds the text with a box
  `#roundBox`			Surrounds the text with a translucent round cornered box drawn with alpha blending so that the interior is more tranlucent than the edges.
  `#straightBox` 		Surrounds the text with a translucent (alpha blended) box. The box one pixel shorter than the row height so there is some visual separation between lines.
  `#dash` 				Underlines the text with dashed lines
  `#dots` 				Underlines the text with dotted lines
  `#squiggleLow`		Underlines the text with height challenged squiggles
  `#dotBox`			Draws a dotted box around the text
  `#squigglePixmap`	As `#squiggles`, but drawn using a pixmap. The effect is heavier.
  `#compositionThick`	2-pel thick solid underline at the bottom of the text row - for larger fonts this will be below the descenders, unlike `#underline`
  `#compositionThin`	As `#compositionThick`, but 1-pel.
  `#fullBox`			Like `#straightBox`, but filling the entire line so there is no visual separation between lines
  `#textFore`			Draws the text in the foreground colour of the indicator, rather than from the text style
  `#point`				Draws a small triangle just before the start of the indicated range (very subtle)
  `#pointCharacter`		As `#point`, but under the first character of the range.

## Instance Variables:
  `forecolor`		`Color`. Foreground colour used to draw the indicator.
  `style`			`<integer>` from the `INDIC_xxxx` enumeration. These relate to the named styles listed above.
  `under`			`Boolean`. Determines whether the indicator is drawn under or over the text when two phase drawing is enabled.
  `name`			`Symbol` uniquely naming a container indicator, or <integer> id of the lexer indicator
  `alpha`			`<integer>`. 0..255 opacity of styles with translucent background fills
  `hoverStyle`		`<integer>` from the `INDIC_xxx` enumeration for the indicator style to be used when hot
  `hoverForecolor`	`Color`. Foreground colour used to draw the indicator when hot (mouse hovering over)
  `flags`			`<integer>`
  `foreAlpha`		`<integer>`. 0..255 alpha transparency level for any foreground element of translucent indicators (e.g. edge of boxes)

## Class Variables:
  `IndicatorStyles`	`Array`
  `StyleNames`		`<Object>`
'!

!ScintillaIndicatorStyle categoriesForClass!MVP-Views-Support! !

!ScintillaIndicatorStyle methodsFor!

alpha
	"Answer the alpha value for the transparency of the background of box indicator styles"

	^alpha!

alpha: anInteger
	anInteger isNil ifFalse: [self validateAlpha: anInteger].
	self basicAlpha: anInteger.
	self updateViewProperty: #alpha!

applyToView: aScintillaView initializing: aBoolean
	"Private - Apply any non-default properties of this attribute to the <ScintillaView> argument. This should only be used for initialization, or after resetting the corresponding attributes of the view to defaults. See also #updateInView:"

	self view: aScintillaView.
	self class propertyMap do: 
			[:descriptor |
			(descriptor == HoverForecolor or: [descriptor == HoverStyle])
				ifFalse: 
					[descriptor
						setAttribute: self
						ofView: aScintillaView
						initializing: aBoolean]].
	HoverForecolor
		setAttribute: self
		ofView: aScintillaView
		initializing: aBoolean.
	HoverStyle
		setAttribute: self
		ofView: aScintillaView
		initializing: aBoolean!

basicAlpha: anIntegerOrNil
	alpha := anIntegerOrNil!

basicForeAlpha: anIntegerOrNil
	foreAlpha := anIntegerOrNil!

basicForecolor: aColorOrNil 
	forecolor := aColorOrNil!

basicHoverForecolor: aColorOrNil
	hoverForecolor := aColorOrNil!

basicHoverStyle
	^hoverStyle!

basicHoverStyle: anInteger
	"If the same as the non-hover style, then don't store it so it changes with that style"
	hoverStyle := anInteger = self basicStyle ifFalse: [anInteger]!

basicId
	^id ifNil: [name isInteger ifTrue: [id := name]]!

basicIsUnderText
	^under!

basicIsUnderText: anIntegerOrNil
	under := anIntegerOrNil!

basicStyle
	^style!

basicStyle: anInteger
	style := anInteger!

flags
	^flags!

flags: anInteger 
	flags := anInteger!

foreAlpha
	"Answer the alpha value for the transparency of the foreground of box indicator styles, or
	nil if the default (50) is to be used."

	^foreAlpha!

foreAlpha: anInteger
	anInteger isNil ifFalse: [self validateAlpha: anInteger].
	self basicForeAlpha: anInteger.
	self updateViewProperty: #foreAlpha!

forecolor
	"Answer the foreground <Color> used to draw the indicator, or nil if the indicator style does not specify a colour and should use the Scintilla default (black)."

	^forecolor!

forecolor: aColorOrNil
	"Set the foreground colour used to draw the indicator to the <Color> argument. If the argument is nil, then Scintilla's default indicator colour (black) is used."

	self basicForecolor: aColorOrNil.
	self updateViewProperty: #forecolor.
	self hoverForecolor isNil ifFalse: [self updateViewProperty: #hoverForecolor]!

hoverForecolor
	"Answer the foreground <Color> used to hot-highlight the indicator when the mouse cursor is hovering over it. Can be nil, indicating that hot-highlighting is disabled."

	^hoverForecolor!

hoverForecolor: aColorOrNil
	"Set the foreground colour used to hot-highlight the indicator when the mouse cursor hovering over it to the <Color> argument. If the argument is nil, then Scintilla's default indicator colour (black) is used."

	self basicHoverForecolor: aColorOrNil.
	self updateViewProperty: #hoverForecolor!

hoverStyle
	"Answer the symbolic name of the indicator style used either an indicator of this style is
	hovered over, or when the caret is within the text range of the indicator."

	^hoverStyle ifNotNil: [:s | IndicatorStyles at: s + 1]!

hoverStyle: aSymbol
	self basicHoverStyle: (self styleFromName: aSymbol).
	self updateViewProperty: #hoverStyle!

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

style
	^style ifNotNil: [:s | IndicatorStyles at: s + 1 ifAbsent: []]!

style: aSymbol
	self basicStyle: (self styleFromName: aSymbol).
	self updateViewProperty: #style.
	"If the style is set, the control, rather annoyingly, overwrites the hover style, so we need
	to set that again too (if set)."
	hoverStyle isNil ifFalse: [self updateViewProperty: #hoverStyle]!

styleFromName: aSymbolOrNil
	^aSymbolOrNil isNil ifFalse: [(IndicatorStyles keyAtValue: aSymbolOrNil) - 1]!

validateAlpha: anInteger
	^(anInteger between: SC_ALPHA_TRANSPARENT and: SC_ALPHA_OPAQUE)
		ifTrue: [anInteger]
		ifFalse: [self error: 'Invalid alpha value ' , anInteger displayString]! !

!ScintillaIndicatorStyle categoriesForMethods!
alpha!accessing!public! !
alpha:!accessing!public! !
applyToView:initializing:!helpers!private! !
basicAlpha:!accessing!private! !
basicForeAlpha:!accessing!private! !
basicForecolor:!accessing!private! !
basicHoverForecolor:!accessing!private! !
basicHoverStyle!accessing!private! !
basicHoverStyle:!accessing!private! !
basicId!accessing!private! !
basicIsUnderText!private!testing! !
basicIsUnderText:!accessing!private! !
basicStyle!accessing!private! !
basicStyle:!accessing!private! !
flags!accessing!private! !
flags:!accessing!private! !
foreAlpha!accessing!public! !
foreAlpha:!accessing!public! !
forecolor!accessing!colors!public! !
forecolor:!accessing!colors!public! !
hoverForecolor!accessing!colors!public! !
hoverForecolor:!accessing!colors!public! !
hoverStyle!accessing!public! !
hoverStyle:!accessing!public! !
isUnderText!public!testing! !
isUnderText:!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
style!accessing!public! !
style:!accessing!public! !
styleFromName:!helpers!private! !
validateAlpha:!helpers!private! !
!

!ScintillaIndicatorStyle class methodsFor!

buildPropertyMap
	"Some magic numbers for default values are from the Scintilla code - no consts for these"

	HoverStyle := ScintillaPropertyDescriptor
				getSelector: #basicHoverStyle
				defaultValue: INDIC_SQUIGGLE
				setMessage: SCI_INDICSETHOVERSTYLE
				setSelector: #basicHoverStyle:
				getMessage: SCI_INDICGETHOVERSTYLE.
	HoverForecolor := ScintillaColorPropertyDescriptor
				getSelector: #hoverForecolor
				defaultValue: Color black
				setMessage: SCI_INDICSETHOVERFORE
				setSelector: #basicHoverForecolor:
				getMessage: SCI_INDICGETHOVERFORE.
	^IdentityDictionary new
		at: #forecolor
			put: (ScintillaColorPropertyDescriptor
					getSelector: #forecolor
					defaultValue: Color black
					setMessage: SCI_INDICSETFORE
					setSelector: #basicForecolor:
					getMessage: SCI_INDICGETFORE);
		at: #style
			put: (ScintillaPropertyDescriptor
					getSelector: #basicStyle
					defaultValue: nil
					setMessage: SCI_INDICSETSTYLE
					setSelector: #basicStyle:
					getMessage: SCI_INDICGETSTYLE);
		at: #hoverStyle put: HoverStyle;
		at: #isUnderText
			put: (ScintillaPropertyDescriptor
					getSelector: #basicIsUnderText
					defaultValue: 0
					setMessage: SCI_INDICSETUNDER
					setSelector: #basicIsUnderText:
					getMessage: SCI_INDICGETUNDER);
		at: #alpha
			put: (ScintillaPropertyDescriptor
					getSelector: #alpha
					defaultValue: 30
					setMessage: SCI_INDICSETALPHA
					setSelector: #basicAlpha:
					getMessage: SCI_INDICGETALPHA);
		at: #hoverForecolor put: HoverForecolor;
		at: #flags
			put: (ScintillaPropertyDescriptor
					getSelector: #flags
					defaultValue: 0
					setMessage: SCI_INDICSETFLAGS
					setSelector: #flags:
					getMessage: SCI_INDICGETFLAGS);
		at: #foreAlpha
			put: (ScintillaPropertyDescriptor
					getSelector: #foreAlpha
					defaultValue: 50
					setMessage: SCI_INDICSETOUTLINEALPHA
					setSelector: #basicForeAlpha:
					getMessage: SCI_INDICSETOUTLINEALPHA);
		shrink;
		yourself!

initialize
	"
		self initialize
	"

	propertyMap := self buildPropertyMap
				isImmutable: true;
				yourself.
	self addClassConstant: 'IndicatorStyles'
		value: #(#underline #squiggle #tt #hatch #strikeOut #hidden #box #roundBox #straightBox #dash #dots #squiggleLow #dotBox #squigglePixmap #compositionThick #compositionThin #fullBox #textFore #point #pointCharacter)!

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
	instance forecolor
		ifNotNil: [:int | instance basicForecolor: (int isZero ifFalse: [Color fromCOLORREF: int])].
	instance hoverForecolor
		ifNotNil: [:int | instance basicHoverForecolor: (int isZero ifFalse: [Color fromCOLORREF: int])].
	instance]!

stbVersion
	^3! !

!ScintillaIndicatorStyle class categoriesForMethods!
buildPropertyMap!constants!must not strip!private! !
initialize!development!initializing!public! !
new!public! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
!

