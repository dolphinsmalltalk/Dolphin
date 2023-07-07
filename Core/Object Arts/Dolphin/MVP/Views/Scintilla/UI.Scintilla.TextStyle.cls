"Filed out from Dolphin Smalltalk"!

UI.Scintilla.Attribute
	subclass: #'UI.Scintilla.TextStyle'
	instanceVariableNames: 'forecolor backcolor flags fontName centiPointSize characterSet case name description weight invisibleRepresentation'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'CheckMonospacedMask' -> 16rC000.
			'EolFilledMask' -> 16rC0.
			'HotspotMask' -> 16rC00.
			'InvisibleMask' -> 16r3000.
			'ItalicMask' -> 16rC.
			'PredefinedStyleNames'
				-> (IdentityDictionary withAll: {
								#braceHighlight -> 16r22.
								#braceMismatch -> 16r23.
								#callTip -> 16r26.
								#controlChar -> 16r24.
								#foldDisplayText -> 16r27.
								#indentGuide -> 16r25.
								#lineNumber -> 16r21.
								#normal -> 16r0.
								16r1 -> 16r1.
								16r10 -> 16r10.
								16r11 -> 16r11.
								16r12 -> 16r12.
								16r13 -> 16r13.
								16r14 -> 16r14.
								16r15 -> 16r15.
								16r16 -> 16r16.
								16r17 -> 16r17.
								16r18 -> 16r18.
								16r19 -> 16r19.
								16r1A -> 16r1A.
								16r1B -> 16r1B.
								16r1C -> 16r1C.
								16r1D -> 16r1D.
								16r1E -> 16r1E.
								16r1F -> 16r1F.
								16r2 -> 16r2.
								16r3 -> 16r3.
								16r4 -> 16r4.
								16r5 -> 16r5.
								16r6 -> 16r6.
								16r7 -> 16r7.
								16r8 -> 16r8.
								16r9 -> 16r9.
								16rA -> 16rA.
								16rB -> 16rB.
								16rC -> 16rC.
								16rD -> 16rD.
								16rE -> 16rE.
								16rF -> 16rF
							}).
			'ReadOnlyMask' -> 16r300.
			'UnderlinedMask' -> 16r30
		}!
UI.Scintilla.TextStyle guid: (Core.GUID fromString: '{441d5422-db7d-4872-a16d-d6ca9d88e0b8}')!
UI.Scintilla.TextStyle comment: '`Scintilla.TextStyle` instances represent the visual styles that can be applied to colour text in a particular `ScintillaView`.

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

Up to 256 styles can be defined per view. These have symbolic names for use in Smalltalk code, and have id''s allocated automatically. The predefined styles listed above have id''s which Scintilla recognises specifically, with id''s between `STYLE_DEFAULT` (32) and `STYLE_LASTPREDEFINED` (39). In addition style id 0 is reserved for "normal", which (somewhat confusingly given the existance of `STYLE_DEFAULT`) is the style applied to text by default and from which all the other styles inherit any unspecified properties. See the Scintilla docs for further details of the predefined styles. All other styles are user-defined, can have any symbolic name, and are allocated an unused id in the range 1..255. 

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
					[flags = anObject flags and: 
							[forecolor = anObject forecolor and: 
									[backcolor = anObject backcolor and: 
											[fontName = anObject fontName and: 
													[centiPointSize = anObject centiPointSize
														and: [weight = anObject weight and: [characterSet = anObject characterSet and: [case = anObject case]]]]]]]]]!

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

	fontName := centiPointSize := characterSet := nil.
	flags := flags bitAnd: ##((ItalicMask | UnderlinedMask) bitInvert).
	weight := nil!

description
	^description ifNil: [self name ifNotNil: [:string | string asPhrase]]!

description: aString
	"Set the user-defined description of this text style to the specified <String>."

	description := (aString isNil or: [aString isEmpty]) ifFalse: [aString]!

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
	^fontName!

fontName: aStringOrNil
	fontName = aStringOrNil ifTrue: [^self].
	fontName := aStringOrNil!

forecolor
	"Answer the foreground <Color> used to draw text in this style, or nil if the style does not specify a foreground colour and should inherit the default."

	^forecolor!

forecolor: aColorOrNil 
	forecolor := aColorOrNil == Color default ifFalse: [aColorOrNil]!

getThreeStateFlag: anInteger
	^#(nil true false) at: ((flags bitAnd: anInteger) bitShift: 1 - anInteger lowBit) + 1!

initialize
	flags := 0.
!

invisibleRepresentation
	^invisibleRepresentation!

invisibleRepresentation: aString
	"Set the text to be used in place of text with this style when invisible. Only the first character of the string is used. By default this is not set (nil)."

	invisibleRepresentation := aString!

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

isPossiblyMonospaced
	"Answer true if Scintilla should check that the receiver's font is monospaced in the ASCII range. This is an optimisation - see the [Scintilla documentation](https://www.scintilla.org/ScintillaDoc.html#SCI_STYLEGETCHECKMONOSPACED)"

	^self getThreeStateFlag: CheckMonospacedMask!

isPossiblyMonospaced: aBooleanOrNil
	"Set whether Scintilla should check that the receiver's font is monospaced in the ASCII range. This is an optimisation - see the [Scintilla documentation](https://www.scintilla.org/ScintillaDoc.html#SCI_STYLESETCHECKMONOSPACED)"

	self setThreeStateFlag: CheckMonospacedMask value: aBooleanOrNil!

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
	"Answer true if the receiver's font is underlined, false if regular, or nil if not specified."

	^self getThreeStateFlag: UnderlinedMask!

isUnderlined: aBooleanOrNil 
	"Set the receiver's three state flag that specifies whether the associated font
	is underlined. If the argument is nil, then this style has no effect on the default
	font."

	self setThreeStateFlag: UnderlinedMask value: aBooleanOrNil!

isVisible
	"Private - Answer whether text marked with this style is visible."

	^self isInvisible ifNotNil: [:invisible | invisible not]!

isVisible: aBooleanOrNil 
	"Private - Set  whether text marked with this style is hidden."

	self isInvisible: (aBooleanOrNil ifNotNil: [aBooleanOrNil not])!

key
	^self name!

mergeFont: aFont
	"Initialize any font settings that are currently unspecified from the <Font> argument."

	fontName ifNil: [fontName := aFont name].
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
	flags := aBooleanOrNil
				ifNil: [flags bitAnd: anInteger bitInvert]
				ifNotNil: 
					[(flags bitAnd: anInteger bitInvert)
						bitOr: ((anInteger bitShift: (aBooleanOrNil ifTrue: [-1] ifFalse: [1])) bitAnd: anInteger)]!

storeableProperties
	| attribs |
	attribs := super storeableProperties.
	name ifNotNil: [attribs := {#name} , attribs].
	^attribs!

view
	^nil!

view: aScintillaView 
	!

weight
	^weight!

weight: anInteger 
	weight := anInteger! !
!UI.Scintilla.TextStyle categoriesForMethods!
=!comparing!public! !
backcolor!accessing!public! !
backcolor:!accessing!public! !
basicId!accessing!private! !
case!accessing!public! !
case:!accessing!public! !
caseName!accessing!public! !
caseName:!accessing!public! !
centiPointSize!accessing!public! !
centiPointSize:!accessing!public! !
characterSet!accessing!public! !
characterSet:!accessing!public! !
clearFont!accessing!public! !
description!accessing!public! !
description:!accessing!public! !
displayOn:!displaying!public! !
flags!accessing!public! !
font!accessing!public! !
font:!accessing!public! !
fontName!accessing!public! !
fontName:!accessing!public! !
forecolor!accessing!public! !
forecolor:!accessing!public! !
getThreeStateFlag:!helpers!private! !
initialize!initializing!private! !
invisibleRepresentation!accessing!public! !
invisibleRepresentation:!accessing!public! !
isBackcolorExtendedToEndOfLine!public!testing! !
isBackcolorExtendedToEndOfLine:!accessing!public! !
isBold!public!testing! !
isBold:!accessing!public! !
isChangeable!private!testing! !
isHotspot!public!testing! !
isHotspot:!accessing!public! !
isInvisible!public!testing! !
isInvisible:!accessing!public! !
isItalic!public!testing! !
isItalic:!accessing!public! !
isPossiblyMonospaced!public!testing! !
isPossiblyMonospaced:!accessing!public! !
isPredefined!public!testing! !
isReadOnly!public!testing! !
isReadOnly:!accessing!public! !
isUnderlined!public!testing! !
isUnderlined:!accessing!public! !
isVisible!private!testing! !
isVisible:!accessing!private! !
key!accessing!public! !
mergeFont:!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
pointSize!accessing!public! !
pointSize:!accessing!public! !
restyleFont:!accessing!public! !
setPredefinedId!accessing!private! !
setThreeStateFlag:value:!helpers!private! !
storeableProperties!development!printing!private! !
view!accessing!private! !
view:!accessing!private! !
weight!accessing!public! !
weight:!accessing!public! !
!

!UI.Scintilla.TextStyle class methodsFor!

buildPropertyDescriptors
	^{ColourPropertyDescriptor
			key: #forecolor
			defaultValue: Color black
			setMessage: SCI_STYLESETFORE.
		ColourPropertyDescriptor
			key: #backcolor
			defaultValue: Color white
			setMessage: SCI_STYLESETBACK.
		(EnumPropertyDescriptor
			key: #fontName
			defaultValue: nil
			setMessage: SCI_STYLESETFONT)
			type: String;
			values: [(Canvas forDesktop fontNames reject: [:each | (each at: 1) = $@]) asSortedArray];
			nilChoice: '<Inherited>';
			yourself.
		(BoolPropertyDescriptor
			key: #isBold
			defaultValue: false
			setMessage: SCI_STYLESETBOLD)
			beNullable;
			yourself.
		(ThreeStateBooleanPropertyDescriptor
			key: #isItalic
			defaultValue: false
			setMessage: SCI_STYLESETITALIC)
			flagsMask: ItalicMask;
			yourself.
		(ThreeStateBooleanPropertyDescriptor
			key: #isUnderlined
			defaultValue: false
			setMessage: SCI_STYLESETUNDERLINE)
			flagsMask: UnderlinedMask;
			yourself.
		(EnumPropertyDescriptor
			key: #case
			defaultValue: SC_CASE_MIXED
			setMessage: SCI_STYLESETCASE)
			values: self caseNames;
			beNullable;
			yourself.
		(IntPropertyDescriptor
			key: #characterSet
			defaultValue: SC_CHARSET_DEFAULT
			setMessage: SCI_STYLESETCHARACTERSET)
			beNullable;
			isNonBrowsable: true;
			yourself.
		(HundredthsPropertyDescriptor
			key: #pointSize
			defaultValue: nil
			setMessage: SCI_STYLESETSIZEFRACTIONAL)
			getSelector: #centiPointSize;
			beNullable;
			yourself.
		(ThreeStateBooleanPropertyDescriptor
			key: #isBackcolorExtendedToEndOfLine
			defaultValue: false
			setMessage: SCI_STYLESETEOLFILLED)
			flagsMask: EolFilledMask;
			yourself.
		(InvertedThreeStateBooleanPropertyDescriptor
			key: #isReadOnly
			defaultValue: false
			setMessage: SCI_STYLESETCHANGEABLE)
			flagsMask: ReadOnlyMask;
			isNonBrowsable: true;
			yourself.
		(ThreeStateBooleanPropertyDescriptor
			key: #isHotspot
			defaultValue: false
			setMessage: SCI_STYLESETHOTSPOT)
			flagsMask: HotspotMask;
			yourself.
		(InvertedThreeStateBooleanPropertyDescriptor
			key: #isInvisible
			defaultValue: false
			setMessage: SCI_STYLESETVISIBLE)
			flagsMask: InvisibleMask;
			isNonBrowsable: true;
			yourself.
		(IntPropertyDescriptor
			key: #weight
			defaultValue: SC_WEIGHT_NORMAL
			setMessage: SCI_STYLESETWEIGHT)
			beNullable;
			yourself.
		(ThreeStateBooleanPropertyDescriptor
			key: #isPossiblyMonospaced
			defaultValue: false
			setMessage: SCI_STYLESETCHECKMONOSPACED)
			flagsMask: CheckMonospacedMask;
			isNonBrowsable: true;
			yourself.
		(StringPropertyDescriptor
			key: #invisibleRepresentation
			defaultValue: nil
			setMessage: SCI_STYLESETINVISIBLEREPRESENTATION)
			getMessage: SCI_STYLEGETINVISIBLEREPRESENTATION;
			setSelector: #invisibleRepresentation:;
			beNullable;
"			isNonBrowsable: true;"
			yourself}!

caseNames
	^#(#mixed #upper #lower #camel)!

icon
	^Font icon!

initialize
	"
		self initialize
	"

	self addClassConstant: 'ItalicMask' value: 2r1100.
	self addClassConstant: 'UnderlinedMask' value: 2r110000.
	self addClassConstant: 'EolFilledMask' value: 2r11000000.
	self addClassConstant: 'ReadOnlyMask' value: 2r1100000000.
	self addClassConstant: 'HotspotMask' value: 2r110000000000.
	self addClassConstant: 'InvisibleMask' value: 2r11000000000000.
	propertyDescriptors := self buildPropertyDescriptors
				beImmutableObject;
				yourself.
	self addClassConstant: 'PredefinedStyleNames'
		value: (IdentityDictionary
				withAll: ((STYLE_NORMAL + 1 to: STYLE_DEFAULT - 1) collect: [:each | each -> each]) , {
								#normal -> STYLE_NORMAL.
								#braceHighlight -> STYLE_BRACELIGHT.
								#braceMismatch -> STYLE_BRACEBAD.
								#controlChar -> STYLE_CONTROLCHAR.
								#lineNumber -> STYLE_LINENUMBER.
								#indentGuide -> STYLE_INDENTGUIDE.
								#callTip -> STYLE_CALLTIP.
								#foldDisplayText -> STYLE_FOLDDISPLAYTEXT
							})!

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
	[:data |
	data resize: self instSize.
	data becomeA: self.
	"Scintilla now supports fractional point size, so convert old instance pointSize stored in the same inst var"
	data pointSize: data centiPointSize.
	"Weight is now stored as an integer value, rather than just a bold flag (BoldMask as 2r11)."
	data isBold: (data getThreeStateFlag: 2r11).
	data]!

stbVersion
	"Versions:
		0: 7.0 initial (80d5c9c20)
		1: Scintilla 3.6.3 upgrade; centiPointSize replaces pointSize, adds weight to replace former isBold flag, and a spare* (29d80afa7)

	*Spare _reserved12 inst var from v1 later used for invisibleRepresentation, no conversion required.
	"

	^1! !
!UI.Scintilla.TextStyle class categoriesForMethods!
buildPropertyDescriptors!constants!must not strip!private! !
caseNames!constants!public! !
icon!constants!public! !
initialize!development!initializing!public! !
name:!instance creation!public! !
new!instance creation!public! !
normal!instance creation!public! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
!

