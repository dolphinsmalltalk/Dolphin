"Filed out from Dolphin Smalltalk 7"!

UI.Scintilla.Attribute subclass: #'UI.Scintilla.TextStyle'
	instanceVariableNames: 'forecolor backcolor flags faceName centiPointSize characterSet case name description weight _reserved12'
	classVariableNames: 'PredefinedStyleNames'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'EolFilledMask' -> 16rC0.
		'HotspotMask' -> 16rC00.
		'InvisibleMask' -> 16r3000.
		'ItalicMask' -> 16rC.
		'ReadOnlyMask' -> 16r300.
		'UnderlinedMask' -> 16r30
	}!
UI.Scintilla.TextStyle guid: (Core.GUID fromString: '{441d5422-db7d-4872-a16d-d6ca9d88e0b8}')!
UI.Scintilla.TextStyle comment: '`ScintillaStyle` instances represent the visual styles that can be applied to colour text in a particular `ScintillaView`.

There are a number of predefined styles:
  `#normal` - the default style used to draw all unstyled text, and from which user-defined styles inherit.
  `#braceHighlight` - style used to highlight matching braces (where the brace highlighting feature is implemented)
  `#mismatchedBrace` - style used to highlight mismatched braces (where the brace highlighting feature is implemented)
  `#controlChar` - style used to draw control characters such as Form Feed when these are present in the text.
  `#lineNumber` - style used to draw text in the line number margin, and to control the background colour of all margins except the fold margin.
  `#indentGuide` - style used to draw indentation guides
  `#callTip` - style used for call tips.
	
Note that the `#braceHighlight` and `#mismatchedBrace` styles are normally implemented using indicator styles.

With the exception of `#normal`, these styles are present to allow control over the presentation of particular features, but they cannot themselves be set against regions of text. Note that some styling, such as that used for visible whitespace, is controlled independently of the normal text style definitions  by directly setting properties of the `ScintillaView`.

Up to 256 styles can be defined per view. These have symbolic names for use in Smalltalk code, and have id''s allocated automatically. The predefined styles listed above have ids which Scintilla recognises specifically, with ids between `STYLE_DEFAULT` (32) and `STYLE_LASTPREDEFINED` (39). In addition style id 0 is reserved for "normal", which (somewhat confusingly given the existance of `STYLE_DEFAULT`) is the style applied to text by default and from which all the other styles inherit any unspecified properties. See the Scintilla docs for further details of the predefined styles. All other styles are user-defined, can have any symbolic name, and are allocated an unused id in the range 1..255. 

The instance variables of all styles specify the differences from the default (or "normal") style, so any that are nil imply inheritance of that aspect from the special `#normal` style (which has style id 0). In turn the `#normal` style "inherits" any unspecified font and color settings from those aspects of the view itself. 

Note that Scintilla style information is now queryable from the control, but this was not the case when the Dolphin wrapper was originally designed so `ScintillaTextStyle`s are only ever set to the control, never queried back.

##Instance Variables:
	`forecolor`		`<Color>`. Text foreground colour.
	`backcolor`		`<Color>`. Background colour.
	`flags`			`<integer`> Various flags controlling font appearance, etc.
	`faceName`		`String`. Font face name.
	`centiPointSize`	`<integer>`. Font size in hundredths of a point.
	`characterSet`		`<integer>`. Font character set.
	`case`			`<integer>`. Font case type
	`name`			`Symbol`. Symbolic name of the visual style.
	`description`		`String`. Optional description of the style, useful for presentation in user preferences dialogs.
	`weight`			`<integer>` font weight.

##Class Variables:
	`EolFilledMask`		`<integer>` bitmask used to specify whether the backcolor is extended to the end-of-line.
	`HotspotMask`		`<integer>` bitmask used to specify whether the marked text should be treated as a hotspot.
	`InvisibleMask`		`<integer>` bitmaks used to specify whether the text should be invisible.
	`ItalicMask`			`<integer>` bitmask used to specify an italic font in `flags` inst. var.
	`PredefinedStyleNames`	`IdentityDictionary` mapping `Symbol` to `<integer>` style code for all fixed/predefined styles.
	`ReadOnlyMask`		`<integer>` bitmask used to specify whether the text should be read-only.
	`UnderlinedMask`		`<integer>` bitmask used to specify an underlined font in `flags` inst. var.
'!
!UI.Scintilla.TextStyle categoriesForClass!MVP-Views-Support! !
!UI.Scintilla.TextStyle methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument are considered equivalent. A pair of
	<ScintillaTextStyle>s are only considered equivalent if all attributes are equal."

	^anObject class == self species and: 
			[self name = anObject name and: 
					[self flags = anObject flags and: 
							[self forecolor = anObject forecolor and: 
									[self backcolor = anObject backcolor and: 
											[self fontName = anObject fontName and: 
													[self centiPointSize = anObject centiPointSize and: 
															[self weight = anObject weight
																and: [self characterSet = anObject characterSet and: [self case = anObject case]]]]]]]]]!

backcolor
	"Answer the background <Color> used to draw text in this style, or nil if the style does not specify a background colour and should inherit the default."

	^backcolor!

backcolor: aColorOrNil
	backcolor := aColorOrNil == Color default ifFalse: [aColorOrNil]!

basicId
	^id ifNil: [name ifNotNil: [self setPredefinedId]]!

case
	^case!

case: anIntegerOrNil 
	case = anIntegerOrNil ifTrue: [^self].
	case := anIntegerOrNil!

caseName
	^self case ifNotNil: [:enum | self class caseNames at: enum+1]!

caseName: aSymbolOrNil 
	self case: (aSymbolOrNil ifNotNil: [(self class caseNames indexOf: aSymbolOrNil) - 1])!

centiPointSize
	^centiPointSize!

centiPointSize: aNumberOrNil 
	centiPointSize := aNumberOrNil!

characterSet
	^characterSet!

characterSet: anIntegerOrNil 
	characterSet = anIntegerOrNil ifTrue: [^self].
	characterSet := anIntegerOrNil!

clearFont
	"Clear all font settings so that these are inherited."

	faceName := centiPointSize := characterSet := nil.
	flags := flags maskClear: ItalicMask | UnderlinedMask.
	weight := nil!

description
	^description ifNil: [self name ifNotNil: [:string | string asPhrase]]!

description: aString 
	"Set the user-defined description of this text style to the specified <String>."

	description := (aString notNil and: [aString notEmpty]) ifTrue: [aString]!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| displayName |
	displayName := String streamContents: [:strm | self name displayOn: strm].
	aPuttableStream nextPutAll: displayName asPhrase!

flags
	^flags!

font
	"Answer a font configured with the receiver's settings."

	| answer |
	answer := self fontName ifNil: [Font default] ifNotNil: [:face | Font name: face].
	self restyleFont: answer.
	^answer!

font: aFont 
	self clearFont.
	self mergeFont: aFont!

fontName
	^faceName!

fontName: aStringOrNil 
	faceName = aStringOrNil ifTrue: [^self].
	faceName := aStringOrNil!

forecolor
	"Answer the foreground <Color> used to draw text in this style, or nil if the style does not specify a foreground colour and should inherit the default."

	^forecolor!

forecolor: aColorOrNil 
	forecolor := aColorOrNil == Color default ifFalse: [aColorOrNil]!

getThreeStateFlag: anInteger
	^#(nil true false) at: ((flags bitAnd: anInteger) bitShift: 1 - anInteger lowBit) + 1!

initialize
	super initialize.
	flags := 0.
!

isBackcolorExtendedToEndOfLine
	"Answer whether the background colour of this style will be extended to the end of the line if the last 
	visible character on the line has this style. This corresponds to SCI_STYLESETEOLFILLED, see
	the Scintilla documentation for further details."

	^self getThreeStateFlag: EolFilledMask!

isBackcolorExtendedToEndOfLine: aBooleanOrNil 
	"Set whether the background colour of this style will be extended to the end of the line if the last 
	visible character on the line has this style. This corresponds to SCI_STYLESETEOLFILLED, see
	the Scintilla documentation for further details."

	self setThreeStateFlag: EolFilledMask value: aBooleanOrNil!

isBold
	"Answer true if the receiver's font is bold, false if regular weight, or nil if not specified."

	^self weight ifNotNil: [:w | w >= SC_WEIGHT_BOLD]!

isBold: aBooleanOrNil 
	"Set the receiver's three state flag that specifies whether the associated font
	is bold. If the argument is nil, then this style has no effect on the default
	font."

	self 
		weight: (aBooleanOrNil ifNotNil: [:bold | bold ifTrue: [SC_WEIGHT_BOLD] ifFalse: [SC_WEIGHT_NORMAL]])!

isChangeable
	^self isReadOnly ifNotNil: [:readOnly | readOnly not]!

isHotspot
	"Answer true if the text marked with this style is a hotspot that can detect
	mouse clicks, e.g. for hypertext linking.."

	^self getThreeStateFlag: HotspotMask!

isHotspot: aBooleanOrNil 
	"Set whether the text marked with this style is a hotspot that can detect
	mouse clicks, e.g. for hypertext linking.."

	self setThreeStateFlag: HotspotMask value: aBooleanOrNil!

isInvisible
	"Answer whether text marked with this style is hidden."

	^self getThreeStateFlag: InvisibleMask!

isInvisible: aBooleanOrNil 
	"Set  whether text marked with this style is hidden."

	self setThreeStateFlag: InvisibleMask value: aBooleanOrNil!

isItalic
	"Answer true if the receiver's font is italic, false if regular, or nil if not specified."

	^self getThreeStateFlag: ItalicMask!

isItalic: aBooleanOrNil 
	"Set the receiver's three state flag that specifies whether the associated font
	is italic. If the argument is nil, then this  style has no effect on the default
	font."

	self setThreeStateFlag: ItalicMask value: aBooleanOrNil!

isPredefined
	"Answer whether the receiver represents one of the styles pre-defined by Scintilla."

	| n |
	n := self name.
	^n isInteger not and: [PredefinedStyleNames includesKey: n]!

isReadOnly
	"Answer true if the text marked with this style is protected against editing."

	^(self getThreeStateFlag: ReadOnlyMask)!

isReadOnly: aBooleanOrNil 
	"Set whether the text marked with this style will be protected against editing."

	self setThreeStateFlag: ReadOnlyMask value: aBooleanOrNil!

isUnderlined
	"Answer true if the receiver's font is underlined, false if regular weight, or nil if not specified."

	^self getThreeStateFlag: UnderlinedMask!

isUnderlined: aBooleanOrNil 
	"Set the receiver's three state flag that specifies whether the associated font
	is underlined. If the argument is nil, then this style has no effect on the default
	font."

	self setThreeStateFlag: UnderlinedMask value: aBooleanOrNil!

isVisible
	"Private - Answer whether text marked with this style is visible."

	^(self getThreeStateFlag: InvisibleMask) ifNotNil: [:invisible | invisible not]!

key
	^self name!

mergeFont: aFont 
	"Initialize any font settings that are currently unspecified from the <Font> argument."

	faceName ifNil: [faceName := aFont name].
	centiPointSize ifNil: [self pointSize: aFont pointSize].
	self isItalic ifNil: [self setThreeStateFlag: ItalicMask value: aFont isItalic].
	self isBold ifNil: [self isBold: aFont isBold].
	self isUnderlined ifNil: [self setThreeStateFlag: UnderlinedMask value: aFont isUnderlined].
	characterSet ifNil: [characterSet := aFont characterSet]!

name
	^name ifNil: ['style', self id displayString]!

name: anObject
	name = anObject ifTrue: [^self].
	anObject isInteger
		ifTrue: [name := id := anObject]
		ifFalse: 
			[(anObject isNil or: [anObject isEmpty])
				ifTrue: [name := id := nil]
				ifFalse: 
					[name := anObject asSymbol.
					self setPredefinedId]]!

pointSize
	^centiPointSize 
		ifNotNil: 
			[:cp | 
			"Try and provide an integer, if the pointSize is whole"
			| points fraction |
			points := cp / 100.0.
			fraction := points asApproximateFraction.
			fraction isInteger ifTrue: [fraction] ifFalse: [points]]!

pointSize: aNumberOrNil 
	centiPointSize := aNumberOrNil ifNotNil: [:i | (i * 100) rounded]!

restyleFont: aFont 
	self pointSize ifNotNil: [:points | aFont pointSize: points].
	self isItalic ifNotNil: [:isItalic | aFont isItalic: isItalic].
	self weight ifNotNil: [:w | aFont weight: w].
	self isUnderlined ifNotNil: [:isUnderlined | aFont isUnderlined: isUnderlined].
	self characterSet ifNotNil: [:set | aFont characterSet: set]!

setPredefinedId
	^id := PredefinedStyleNames lookup: name!

setThreeStateFlag: anInteger value: aBooleanOrNil
	| state |
	state := aBooleanOrNil isNil 
				ifTrue: [0]
				ifFalse: 
					[aBooleanOrNil 
						ifTrue: [(anInteger bitShift: -1) bitAnd: anInteger]
						ifFalse: [(anInteger bitShift: 1) bitAnd: anInteger]].
	flags := (flags maskClear: anInteger) maskSet: state!

storeableProperties
	| attribs |
	attribs := super storeableProperties.
	name ifNotNil: [attribs := {#name} , attribs].
	^attribs!

value
	^self!

view
	^nil!

view: aScintillaView 
	!

weight
	^weight!

weight: anInteger 
	weight := anInteger! !
!UI.Scintilla.TextStyle categoriesFor: #=!comparing!public! !
!UI.Scintilla.TextStyle categoriesFor: #backcolor!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #backcolor:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #basicId!accessing!private! !
!UI.Scintilla.TextStyle categoriesFor: #case!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #case:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #caseName!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #caseName:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #centiPointSize!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #centiPointSize:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #characterSet!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #characterSet:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #clearFont!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #description!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #description:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #displayOn:!displaying!public! !
!UI.Scintilla.TextStyle categoriesFor: #flags!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #font!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #font:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #fontName!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #fontName:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #forecolor!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #forecolor:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #getThreeStateFlag:!helpers!private! !
!UI.Scintilla.TextStyle categoriesFor: #initialize!initializing!private! !
!UI.Scintilla.TextStyle categoriesFor: #isBackcolorExtendedToEndOfLine!public!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isBackcolorExtendedToEndOfLine:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #isBold!public!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isBold:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #isChangeable!private!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isHotspot!public!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isHotspot:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #isInvisible!public!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isInvisible:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #isItalic!public!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isItalic:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #isPredefined!public!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isReadOnly!public!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isReadOnly:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #isUnderlined!public!testing! !
!UI.Scintilla.TextStyle categoriesFor: #isUnderlined:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #isVisible!private!testing! !
!UI.Scintilla.TextStyle categoriesFor: #key!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #mergeFont:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #name!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #name:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #pointSize!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #pointSize:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #restyleFont:!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #setPredefinedId!accessing!private! !
!UI.Scintilla.TextStyle categoriesFor: #setThreeStateFlag:value:!helpers!private! !
!UI.Scintilla.TextStyle categoriesFor: #storeableProperties!development!printing!private! !
!UI.Scintilla.TextStyle categoriesFor: #value!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #view!accessing!private! !
!UI.Scintilla.TextStyle categoriesFor: #view:!accessing!private! !
!UI.Scintilla.TextStyle categoriesFor: #weight!accessing!public! !
!UI.Scintilla.TextStyle categoriesFor: #weight:!accessing!public! !

!UI.Scintilla.TextStyle class methodsFor!

buildPropertyMap
	^IdentityDictionary new
		at: #forecolor
			put: (ColorPropertyDescriptor
					getSelector: #forecolor
					defaultValue: Color black
					setMessage: SCI_STYLESETFORE);
		at: #backcolor
			put: (ColorPropertyDescriptor
					getSelector: #backcolor
					defaultValue: Color white
					setMessage: SCI_STYLESETBACK);
		at: #fontName
			put: (PropertyDescriptor
					getSelector: #fontName
					defaultValue: nil
					setMessage: SCI_STYLESETFONT);
		at: #isBold
			put: (PropertyDescriptor
					getSelector: #isBold
					defaultValue: false
					setMessage: SCI_STYLESETBOLD);
		at: #isItalic
			put: (PropertyDescriptor
					getSelector: #isItalic
					defaultValue: false
					setMessage: SCI_STYLESETITALIC);
		at: #isUnderlined
			put: (PropertyDescriptor
					getSelector: #isUnderlined
					defaultValue: false
					setMessage: SCI_STYLESETUNDERLINE);
		at: #case
			put: (PropertyDescriptor
					getSelector: #case
					defaultValue: SC_CASE_MIXED
					setMessage: SCI_STYLESETCASE);
		at: #characterSet
			put: (PropertyDescriptor
					getSelector: #characterSet
					defaultValue: SC_CHARSET_DEFAULT
					setMessage: SCI_STYLESETCHARACTERSET);
		at: #pointSize
			put: (PropertyDescriptor
					getSelector: #centiPointSize
					defaultValue: nil
					setMessage: SCI_STYLESETSIZEFRACTIONAL);
		at: #isBackcolorExtendedToEndOfLine
			put: (PropertyDescriptor
					getSelector: #isBackcolorExtendedToEndOfLine
					defaultValue: false
					setMessage: SCI_STYLESETEOLFILLED);
		at: #isChangeable
			put: (PropertyDescriptor
					getSelector: #isChangeable
					defaultValue: true
					setMessage: SCI_STYLESETCHANGEABLE);
		at: #isHotspot
			put: (PropertyDescriptor
					getSelector: #isHotspot
					defaultValue: false
					setMessage: SCI_STYLESETHOTSPOT);
		at: #isVisible
			put: (PropertyDescriptor
					getSelector: #isVisible
					defaultValue: true
					setMessage: SCI_STYLESETVISIBLE);
		at: #weight
			put: (PropertyDescriptor
					getSelector: #weight
					defaultValue: SC_WEIGHT_NORMAL
					setMessage: SCI_STYLESETWEIGHT);
		shrink;
		yourself!

caseNames
	^#(#mixed #upper #lower #camel)!

icon
	^Font icon!

initialize
	"
		self initialize
	"

	| predefinedStyleNames |
	self addClassConstant: 'ItalicMask' value: 2r1100.
	self addClassConstant: 'UnderlinedMask' value: 2r110000.
	self addClassConstant: 'EolFilledMask' value: 2r11000000.
	self addClassConstant: 'ReadOnlyMask' value: 2r1100000000.
	self addClassConstant: 'HotspotMask' value: 2r110000000000.
	self addClassConstant: 'InvisibleMask' value: 2r11000000000000.
	propertyMap := self buildPropertyMap
				isImmutable: true;
				yourself.
	predefinedStyleNames := IdentityDictionary new: STYLE_LASTPREDEFINED + 1.
	STYLE_NORMAL + 1 to: STYLE_LASTPREDEFINED do: [:each | predefinedStyleNames at: each put: each].
	"These are not really Scintilla pre-defined styles, but some additional ones we add for convenience in the wrapping"
	predefinedStyleNames
		at: #normal put: STYLE_NORMAL;
		yourself.
	predefinedStyleNames
		removeKey: STYLE_BRACELIGHT;
		at: #braceHighlight put: STYLE_BRACELIGHT;
		removeKey: STYLE_BRACEBAD;
		at: #braceMismatch put: STYLE_BRACEBAD;
		removeKey: STYLE_CONTROLCHAR;
		at: #controlChar put: STYLE_CONTROLCHAR;
		removeKey: STYLE_LINENUMBER;
		at: #lineNumber put: STYLE_LINENUMBER;
		removeKey: STYLE_INDENTGUIDE;
		at: #indentGuide put: STYLE_INDENTGUIDE;
		removeKey: STYLE_CALLTIP;
		at: #callTip put: STYLE_CALLTIP;
		removeKey: STYLE_FOLDDISPLAYTEXT;
		at: #foldDisplayText put: STYLE_FOLDDISPLAYTEXT;
		removeKey: STYLE_DEFAULT.
	predefinedStyleNames
		isImmutable: true;
		shrink.
	self addClassConstant: 'PredefinedStyleNames' value: predefinedStyleNames!

name: aSymbol 
	^(self new)
		name: aSymbol;
		yourself!

new
	^super new initialize!

normal
	^(self name: #normal)
		description: 'Default text style';
		yourself!

stbConvertFrom: anSTBClassFormat 
	^
	[:vars | 
	| instance |
	instance := self new.
	vars keysAndValuesDo: [:eachKey :eachValue | instance instVarAt: eachKey put: eachValue].
	"Scintilla now supports fractional point size, so convert old instance pointSize stored in the same inst var"
	instance pointSize: instance centiPointSize.
	"Weight is now stored as an integer value, rather than just a bold flag (BoldMask as 2r11)."
	instance isBold: (instance getThreeStateFlag: 2r11).
	instance]!

stbVersion
	^1! !
!UI.Scintilla.TextStyle class categoriesFor: #buildPropertyMap!constants!must not strip!private! !
!UI.Scintilla.TextStyle class categoriesFor: #caseNames!constants!public! !
!UI.Scintilla.TextStyle class categoriesFor: #icon!constants!public! !
!UI.Scintilla.TextStyle class categoriesFor: #initialize!development!initializing!public! !
!UI.Scintilla.TextStyle class categoriesFor: #name:!instance creation!public! !
!UI.Scintilla.TextStyle class categoriesFor: #new!instance creation!public! !
!UI.Scintilla.TextStyle class categoriesFor: #normal!instance creation!public! !
!UI.Scintilla.TextStyle class categoriesFor: #stbConvertFrom:!binary filing!private! !
!UI.Scintilla.TextStyle class categoriesFor: #stbVersion!binary filing!public! !

