"Filed out from Dolphin Smalltalk"!

UI.Scintilla.QueryableAttribute
	subclass: #'UI.Scintilla.IndicatorDefinition'
	instanceVariableNames: 'forecolor style layer name alpha hoverStyle hoverForecolor flags foreAlpha strokeWidth'
	classVariableNames: 'AlphaProperty FlagsProperty ForeAlphaProperty ForecolorProperty HoverForecolorProperty HoverStyleProperty LayerProperty StrokeWidthProperty StyleProperty'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'DefaultAlpha' -> 16r1E.
			'DefaultColor' -> Color black.
			'DefaultForeAlpha' -> 16r32.
			'DefaultStrokeWidth' -> 16r64.
			'IndicatorStyleNames'
				-> #(#underline #squiggle #tt #hatch #strikeOut #hidden #box #roundBox #straightBox #dash #dots #squiggleLow #dotBox #squigglePixmap #compositionThick #compositionThin #fullBox #textFore #point #pointCharacter #gradient #gradientCentre #pointTop)
		}!
UI.Scintilla.IndicatorDefinition guid: (Core.GUID fromString: '{2de64fd7-5b9f-4ac7-81c6-912b56b41a4f}')!
UI.Scintilla.IndicatorDefinition comment: '`Scintilla.IndicatorDefinition` instances represent the indicator configuration for a particular `ScintillaView`.

Indicators are orthogonal to visual styles, and can be used to highlight areas of text regardless of styling. A common example usage would be highlight erroneous text by underlining it with a squiggly line.

Originally Scintilla supported only 3 indicator types and shared the styling byte associated with each character. As of Scintilla 1.75 indicators became more useful as they can be independent of styles. This means all style bits are available for styles (now up to 255), but also that indicators can be applied completely independently and that there are now up to 32 different types of indicator available. In our original Dolphin wrapping we didn''t name indicator styles because of the implementation. Our wrapper now supports the more powerful and numerous "modern indicators", and indicators are now named symbolically. 

Indicator styles are separated into two ranges:
	`0..INDIC_CONTAINER-1`			(0..7)		Reserved for use by lexers
	`INDIC_CONTAINER..INDIC_MAX`	(8..31)		Available for use by the container

Named indicators are automatically allocated an id in the container range. There is a limit of 24 of these. Any that are unconfigured are hidden; they can be set, but will have no visual effect.

The attributes of lexer indicators can be configured by adding a `Scintilla.IndicatorDefinition` to the `indicatorDefinitions` collection and explicitly setting the Id to the desired `integer` value. This can be useful when debugging a `ScintillaStyler` that is using hidden indicators to mark text regions for internal purposes. For example the `SmalltalkStyler` uses an indicator to mark text regions that are covered by literal arrays. Normally indicators used for such purposes would be configured as invisible (hidden), but by adding a non-hidden definition, these can be made visible.

For historical reasons the first 3 indicator styles are preconfigured by Scintilla. If you don''t configure these in the `indicatorDefinitions` collection then they will remain with default settings, as described in the Scintilla documentation.

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
  `#gradient`			Vertical gradient-filled rectangle, fading from the forecolor + alpha at the top down to fully transparent
  `#gradientCentre`		Vertical gradient-filled rectangle, fading from the forecolor + alpha at the centre, to fully transparent at the top and bottom
  `#pointTop`			As `#point`, but just above the start of the indicated range.

## Instance Variables:
  `forecolor`		`Color`. Foreground colour used to draw the indicator.
  `style`			`<integer>` from the `INDIC_xxxx` enumeration. These relate to the named styles listed above.
  `under`			`<integer>`. Determines whether the indicator is drawn under (0) or over (1) the text when two phase drawing is enabled.
  `name`			`Symbol` uniquely naming a container indicator, or <integer> id of the lexer indicator
  `alpha`			`<integer>`. 0..255 opacity of styles with translucent background fills
  `hoverStyle`		`<integer>` from the `INDIC_xxx` enumeration for the indicator style to be used when hot
  `hoverForecolor`	`Color`. Foreground colour used to draw the indicator when hot (mouse hovering over)
  `flags`			`<integer>`
  `foreAlpha`		`<integer>`. 0..255 alpha transparency level for any foreground element of translucent indicators (e.g. edge of boxes)
  `strokeWidth`	`<integer>` expressing the width of stroke used to draw the indicator, expressed in hundredth''s of a pixel.


## Class Variables:
  `AlphaProperty`		`IntPropertyDescriptor`
  `FlagsProperty`		`IntPropertyDescriptor`
  `ForeAlphaProperty`		`IntPropertyDescriptor`
  `ForecolorProperty`		`ColourPropertyDescriptor`
  `HoverForecolorProperty`		`ColourPropertyDescriptor`
  `HoverStyleProperty`		`EnumPropertyDescriptor`
  `LayerProperty`		`BoolPropertyDescriptor`
  `StrokeWidthProperty`		`HundredthsPropertyDescriptor`
  `StyleProperty`		`EnumPropertyDescriptor`

## Class Constants:
  `DefaultAlpha` 		`<integer>`. The default `alpha`.
  `DefaultColor`	 	`<Color>`. The default `forecolor`.
  `DefaultForeAlpha` 	`<integer>`. The default `foreAlpha`.
  `DefaultStrokeWidth` 	`<integer>`. The default `strokeWidth`.
  `IndicatorStyleNames`	`Array` of `Symbol`. The named styles above, in an order corresponding to the underlying Scintilla INDIC_xxxx enumeration 
  `StyleNames`			`<Object>`

'!
!UI.Scintilla.IndicatorDefinition categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.IndicatorDefinition methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument are considered equivalent. A pair of
	<Scintilla.IndicatorStyle>s are only considered equivalent if all attributes are equal."

	^anObject class == self species and: 
			[self name = anObject name and: 
					[style = anObject basicStyle and: 
							[flags = anObject flags and: 
									[layer = anObject layer and: 
											[alpha = anObject basicAlpha and: 
													[forecolor = anObject basicForecolor and: 
															[foreAlpha = anObject basicForeAlpha and: 
																	[strokeWidth = anObject basicStrokeWidth
																		and: [hoverStyle = anObject basicHoverStyle and: [hoverForecolor = anObject basicHoverForecolor]]]]]]]]]]!

alpha
	"Answer the alpha value for the transparency of the background of #fullBox, #roundBox, and #straightBox indicator styles, i.e. the fill colour of box. Has no effect on other indicator styles, not even #box."

	^alpha ?? DefaultAlpha!

alpha: anInteger
	self validateAlpha: anInteger.
	self basicAlpha: anInteger.
	self updateViewProperty: AlphaProperty!

basicAlpha
	^alpha!

basicAlpha: anIntegerOrNil
	alpha := anIntegerOrNil == DefaultAlpha ifFalse: [anIntegerOrNil]!

basicForeAlpha
	^foreAlpha!

basicForeAlpha: anIntegerOrNil
	foreAlpha := anIntegerOrNil == DefaultForeAlpha ifFalse: [anIntegerOrNil]!

basicForecolor
	^forecolor!

basicForecolor: aColorOrNil 
	forecolor := aColorOrNil = DefaultColor ifFalse: [aColorOrNil]!

basicHoverForecolor
	^hoverForecolor!

basicHoverForecolor: aColorOrNil
	hoverForecolor := aColorOrNil = self forecolor ifFalse: [aColorOrNil]!

basicHoverStyle
	^hoverStyle!

basicHoverStyle: anInteger
	"If the same as the non-hover style, then don't store it so it changes with that style"

	hoverStyle := anInteger = style ifFalse: [anInteger]!

basicId
	^id ifNil: [name isInteger ifTrue: [id := name]]!

basicStrokeWidth
	^strokeWidth!

basicStrokeWidth: anInteger
	strokeWidth := anInteger!

basicStyle
	^style!

basicStyle: anInteger
	style := anInteger ?? INDIC_HIDDEN!

flags
	^flags!

flags: anInteger 
	flags := anInteger!

foreAlpha
	"Answer the alpha value for the transparency of the foreground of #fullBox, #roundBox, and #straightBox indicator styles (e.g. the box edges), or nil if the default (50) is to be used. Has no effect on other indicator styles, even where one might expect that, i.e. it does not affect the way other line styles such as squiggles, underlining, etc, are drawn. It does not affect the #box style either."

	^foreAlpha ?? DefaultForeAlpha!

foreAlpha: anInteger
	self validateAlpha: anInteger.
	self basicForeAlpha: anInteger.
	self updateViewProperty: ForeAlphaProperty!

forecolor
	"Answer the foreground <Color> used to draw the indicator. The default is black."

	^forecolor ?? DefaultColor!

forecolor: aColorOrNil
	"Set the foreground colour used to draw the indicator to the <Color> argument. If the argument is nil, then Scintilla's default indicator colour (black) is used."

	self basicForecolor: aColorOrNil.
	self updateViewProperty: ForecolorProperty.
	self basicHoverForecolor: hoverForecolor.
	hoverForecolor ifNotNil: [self updateViewProperty: HoverForecolorProperty]!

hoverForecolor
	"Answer the foreground <Color> used to hot-highlight the indicator when the mouse cursor is hovering over it. Can be nil, indicating that hot-highlighting is disabled."

	^hoverForecolor ifNil: [self forecolor]!

hoverForecolor: aColorOrNil
	"Set the foreground colour used to hot-highlight the indicator when the mouse cursor hovering over it to the <Color> argument. If the argument is nil, then base forecolor is inherited."

	hoverForecolor := aColorOrNil.
	self updateViewProperty: HoverForecolorProperty.
	self basicHoverForecolor: aColorOrNil!

hoverStyle
	"Answer the symbolic name of the indicator style used when either an indicator of this style is hovered over, or when the caret is within the text range of the indicator."

	^IndicatorStyleNames at: (hoverStyle ?? style) + 1!

hoverStyle: aSymbol
	hoverStyle := self styleFromName: aSymbol.
	self updateViewProperty: HoverStyleProperty.
	self basicHoverStyle: hoverStyle!

initialize
	"Private - Initialize the receiver's instance variables."

	"When initializing indicators we first reset all to hidden, so although the default for the control is INDIC_PLAIN, the effective default is INDIC_HIDDEN"

	style := INDIC_HIDDEN.
	"Draw indicators under the text by default - the control has the opposite default for historical reasons, but under is better."
	layer := 1!

isUnderText
	"Answer true if indicators of this style are drawn under text, or false if over."

	"For historical reasons, the Scintilla draws indicators over the text by default, overwriting any descenders. Better results are achieved by drawing the indicators under (i.e. before) the text, so we make this the default if the setting is currently unspecified. Note that under-drawing is not supported in the deprecated single-phase drawing mode."

	^self layer asBoolean!

isUnderText: aBooleanOrNil
	self layer: (aBooleanOrNil ?? true) asParameter.
	self updateViewProperty: LayerProperty!

layer
	^layer!

layer: anInteger
	layer := anInteger ?? 0!

name
	^name ifNil: ['indicator' , self id displayString]!

name: anObject 
	name = anObject ifTrue: [^self].
	name := anObject isInteger 
				ifTrue: [id := anObject]
				ifFalse: [anObject isEmpty ifFalse: [anObject asSymbol]]!

name: nameSymbol style: styleSymbol forecolor: aColor
	layer := 1.
	name := nameSymbol.
	style := self styleFromName: styleSymbol.
	forecolor := aColor = DefaultColor ifFalse: [aColor].
	^self!

strokeWidth
	"Answer the stroke width used to draw the indicators where 1 is 1 pel, 0.5 is half a pel."

	| width fraction |
	width := (strokeWidth ?? DefaultStrokeWidth) / 100.0.
	fraction := width asApproximateFraction.
	^fraction isInteger ifTrue: [fraction] ifFalse: [width]!

strokeWidth: aNumberOrNil
	self basicStrokeWidth: (aNumberOrNil ifNotNil: [:i | (i * 100) rounded]).
	self updateViewProperty: StrokeWidthProperty!

style
	^style ifNotNil: [:s | IndicatorStyleNames lookup: s + 1]!

style: aSymbol
	self basicStyle: (self styleFromName: aSymbol).
	self updateViewProperty: StyleProperty.
	"If the style is set, the control, overwrites the hover style, and we may want to change it to tracking if now the same."
	self basicHoverStyle: hoverStyle.
	hoverStyle ifNotNil: [self updateViewProperty: HoverStyleProperty]!

styleFromName: aSymbolOrNil
	^aSymbolOrNil isNil ifFalse: [(IndicatorStyleNames keyAtValue: aSymbolOrNil) - 1]!

validateAlpha: anInteger
	^(anInteger isNil or: [anInteger between: SC_ALPHA_TRANSPARENT and: SC_ALPHA_OPAQUE])
		ifTrue: [anInteger]
		ifFalse: [self error: 'Invalid alpha value ' , anInteger displayString]! !
!UI.Scintilla.IndicatorDefinition categoriesForMethods!
=!comparing!public! !
alpha!accessing!public! !
alpha:!accessing!public! !
basicAlpha!accessing!private! !
basicAlpha:!accessing!private! !
basicForeAlpha!accessing!private! !
basicForeAlpha:!accessing!private! !
basicForecolor!accessing!private! !
basicForecolor:!accessing!private! !
basicHoverForecolor!accessing!private! !
basicHoverForecolor:!accessing!private! !
basicHoverStyle!accessing!private! !
basicHoverStyle:!accessing!private! !
basicId!accessing!private! !
basicStrokeWidth!accessing!private! !
basicStrokeWidth:!accessing!private! !
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
initialize!initializing!private! !
isUnderText!public!testing! !
isUnderText:!accessing!public! !
layer!private!testing! !
layer:!accessing!private! !
name!accessing!public! !
name:!accessing!public! !
name:style:forecolor:!initializing!private! !
strokeWidth!accessing!public! !
strokeWidth:!accessing!public! !
style!accessing!public! !
style:!accessing!public! !
styleFromName:!helpers!private! !
validateAlpha:!helpers!private! !
!

!UI.Scintilla.IndicatorDefinition class methodsFor!

buildPropertyDescriptors
	"Some magic numbers for default values are from the Scintilla code - no consts for these"

	| sortedStyles |
	sortedStyles := IndicatorStyleNames copy sort.
	HoverStyleProperty := (EnumPropertyDescriptor
				key: #hoverStyle
				defaultValue: nil
				setMessage: SCI_INDICSETHOVERSTYLE)
				getSelector: #basicHoverStyle;
				setSelector: #basicHoverStyle:;
				getMessage: SCI_INDICGETHOVERSTYLE;
				values: sortedStyles;
				nilChoice: '<None>';
				yourself.
	HoverForecolorProperty := (ColourPropertyDescriptor
				key: #hoverForecolor
				defaultValue: nil
				setMessage: SCI_INDICSETHOVERFORE)
				getSelector: #basicHoverForecolor;
				setSelector: #basicHoverForecolor:;
				getMessage: SCI_INDICGETHOVERFORE;
				yourself.
	ForecolorProperty := (ColourPropertyDescriptor
				key: #forecolor
				defaultValue: DefaultColor
				setMessage: SCI_INDICSETFORE)
				getSelector: #basicForecolor;
				setSelector: #basicForecolor:;
				getMessage: SCI_INDICGETFORE;
				yourself.
	StyleProperty := (EnumPropertyDescriptor
				key: #style
				defaultValue: INDIC_HIDDEN
				setMessage: SCI_INDICSETSTYLE)
				getSelector: #basicStyle;
				setSelector: #basicStyle:;
				getMessage: SCI_INDICGETSTYLE;
				values: sortedStyles;
				yourself.
	LayerProperty := (BoolPropertyDescriptor
				key: #isUnderText
				defaultValue: 0
				setMessage: SCI_INDICSETUNDER)
				getSelector: #layer;
				setSelector: #layer:;
				getMessage: SCI_INDICGETUNDER;
				yourself.
	AlphaProperty := (IntPropertyDescriptor
				key: #alpha
				defaultValue: DefaultAlpha
				setMessage: SCI_INDICSETALPHA)
				setSelector: #basicAlpha:;
				getMessage: SCI_INDICGETALPHA;
				beNullable;
				yourself.
	FlagsProperty := (IntPropertyDescriptor
				key: #flags
				defaultValue: 0
				setMessage: SCI_INDICSETFLAGS)
				setSelector: #flags:;
				getMessage: SCI_INDICGETFLAGS;
				isNonBrowsable: true;
				beNullable;
				yourself.
	ForeAlphaProperty := (IntPropertyDescriptor
				key: #foreAlpha
				defaultValue: DefaultForeAlpha
				setMessage: SCI_INDICSETOUTLINEALPHA)
				setSelector: #basicForeAlpha:;
				getMessage: SCI_INDICGETOUTLINEALPHA;
				beNullable;
				yourself.
	StrokeWidthProperty := (HundredthsPropertyDescriptor
				key: #strokeWidth
				defaultValue: DefaultStrokeWidth
				setMessage: SCI_INDICSETSTROKEWIDTH)
				getSelector: #basicStrokeWidth;
				setSelector: #basicStrokeWidth:;
				getMessage: SCI_INDICGETSTROKEWIDTH;
				beNullable;
				yourself.
	"In this case order is significant, since the HoverForecolorProperty must be applied before the HoverStyleProperty, and after the ForecolorProperty"
	^{ForecolorProperty.
		StyleProperty.
		LayerProperty.
		AlphaProperty.
		FlagsProperty.
		ForeAlphaProperty.
		StrokeWidthProperty.
		HoverForecolorProperty.
		HoverStyleProperty}!

initialize
	"
		self initialize
	"

	propertyDescriptors := self buildPropertyDescriptors
				beImmutableObject;
				yourself!

name: nameSymbol style: styleSymbol forecolor: aColor
	^self basicNew
		name: nameSymbol style: styleSymbol forecolor: aColor!

new
	^(super new)
		initialize;
		yourself!

stbConvertFrom: anSTBClassFormat
	^
	[:data |
	| under |
	data resize: self instSize.
	anSTBClassFormat version < 3
		ifTrue: 
			["Convert forecolor and hoverForecolor from COLORREF to Color"
			#(3 9) do: 
					[:i |
					(data lookup: i)
						ifNotNil: [:colorRef | data at: i put: (colorRef isZero ifFalse: [Color fromCOLORREF: colorRef])]]].
	(data at: 4) ifNil: [data at: 4 put: 0].
	under := data at: 5.
	data at: 5 put: (under ifNil: [1] ifNotNil: [under asParameter]).
	data becomeA: self]!

stbVersion
	"Versions:
		0:
		1: 7.0 initial. as ScintillaIndicatorStyle. (80d5c9c20)
		2: Scintilla 3.6.3 upgrade; adds hoverStyle, hoveForecolor, flags, foreAlpha, and reserved (29d80afa7)
		3: Ensure colors not stored as IndexedColors as not compatible with DirectWrite (95eb10ab2)
		4: Scintilla 5.0.3 upgrade; 'layer' enum replaces 'under' bool (0/1)
		5: style is always non-nil (an integer from the INDIC_XXXX enumeration)"

	^5! !
!UI.Scintilla.IndicatorDefinition class categoriesForMethods!
buildPropertyDescriptors!constants!must not strip!private! !
initialize!development!initializing!public! !
name:style:forecolor:!instance creation!public! !
new!public! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
!

