"Filed out from Dolphin Smalltalk X6.1"!

ScintillaAttribute subclass: #ScintillaTextStyle
	instanceVariableNames: 'forecolor backcolor flags faceName pointSize characterSet case name description _reserved1 _reserved2'
	classVariableNames: 'BoldMask EolFilledMask HotspotMask InvisibleMask ItalicMask PredefinedStyleNames ReadOnlyMask UnderlinedMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaTextStyle guid: (GUID fromString: '{441D5422-DB7D-4872-A16D-D6CA9D88E0B8}')!
ScintillaTextStyle comment: 'ScintillaStyle instances represent the visual styles that can be applied to colour text in a particular <ScintillaView>.

There are a number of predefined styles:
	#normal - the default style used to draw all unstyled text, and from which user-defined styles inherit.
	#braceHighlight 	- style used to highlight matching braces (where the brace highlighting feature is implemented)
	#mismatchedBrace - style used to highlight mismatched braces (where the brace highlighting feature is implemented)
	#controlChar - style used to draw control characters such as Form Feed when these are present in the text.
	#lineNumber - style used to draw text in the line number margin, and to control the background colour of all margins except the fold margin.
	#indentGuide - style used to draw indentation guides
	
With the exception of #normal, these styles are present to allow control over the presentation of particular features, but they cannot themselves be set against regions of text. Note that some styling, such as that used for visible whitespace, is controlled independently of the normal text style definitions  by directly setting properties of the ScintillaView.

Up to 32 other styles* can be defined per view. These have symbolic names for use in Smalltalk code, and have id''s allocated automatically. The predefined styles listed above have ids which Scintilla recognises specifically, and these are not included in the limit of 32 styles. All other styles are user-defined, can have any symbolic name, and are allocated an id in the range 1..31. 

The instance variables of all styles specify the differences from the default style, so any that are nil imply inheritance of that aspect from the special #normal style (which has style id 0). In turn the #normal style "inherits" any unspecified font and color settings from those aspects of the view itself. 

*It is possible to define more than 32 styles by changing the number of #styleBits configured for the view, but this reduces the number of indicators that can be used, and is not recommended.

Instance Variables:
	forecolor	<Color>. Text foreground colour.
	backcolor	<Color>. Background colour.
	flags		<integer> Various flags controlling font appearance, etc.
	faceName	<String>. Font face name.
	pointSize	<integer>. Font size in points.
	characterSet	<integer>. Font character set.
	case		<integer>. Font case type
	name		<Symbol>. Symbolic name of the visual style.
	description	<String>. Optional description of the style, useful for presentation in user preferences dialogs.

Class Variables:
	ItalicMask			<integer> bitmask used to specify an italic font in ''flags'' inst. var.
	PredefinedStyleNames	<IdentityDictionary> mapping <Symbol> to <integer> style code for all fixed/predefined styles.
	BoldMask			<integer> bitmask used to specify a bold font in ''flags'' inst. var.
	UnderlinedMask		<integer> bitmask used to specify an underlined font in ''flags'' inst. var.
	ChangeableMask		<integer> bitmask used to control whether the marked text is protected from editing.
	EolFilledMask		<integer> bitmask used to specify whether the backcolor is extended to the end-of-line.
	HotspotMask		<integer> bitmask used to specify whether the marked text should be treated as a hotspot.'!
!ScintillaTextStyle categoriesForClass!MVP-Views-Support! !
!ScintillaTextStyle methodsFor!

= anObject 
	"Answer whether the receiver and the <Object> argument are considered equivalent. A pair of
	<ScintillaTextStyle>s are only considered equivalent if all attributes are equal."

	^anObject class == self species and: 
			[self name = anObject name and: 
					[self flags = anObject flags and: 
							[self forecolor = anObject forecolor and: 
									[self backcolor = anObject backcolor and: 
											[self fontName = anObject fontName and: 
													[self pointSize = anObject pointSize 
														and: [self characterSet = anObject characterSet and: [self case = anObject case]]]]]]]]!

backcolor
	^backcolor!

backcolor: aColorOrNil 
	backcolor = aColorOrNil ifTrue: [^self].
	backcolor := aColorOrNil!

basicId
	^id ifNil: [name ifNotNil: [id := PredefinedStyleNames at: name ifAbsent: []]]!

case
	^case!

case: anIntegerOrNil 
	case = anIntegerOrNil ifTrue: [^self].
	case := anIntegerOrNil!

caseName
	^self case ifNotNil: [:enum | self class caseNames at: enum+1]!

caseName: aSymbolOrNil 
	self 
		case: (aSymbolOrNil isNil ifFalse: [(self class caseNames indexOf: aSymbolOrNil) - 1])!

characterSet
	^characterSet!

characterSet: anIntegerOrNil 
	characterSet = anIntegerOrNil ifTrue: [^self].
	characterSet := anIntegerOrNil!

clearFont
	"Clear all font settings so that these are inherited."

	faceName := pointSize := characterSet := nil.
	flags := flags maskClear: ItalicMask | BoldMask | UnderlinedMask!

description
	^description ifNil: [self name ifNotNil: [:string | string asPhrase]]!

description: aString 
	"Set the user-defined description of this text style to the specified <String>."

	description := (aString notNil and: [aString notEmpty]) ifTrue: [aString]!

displayOn: aStream 
	aStream nextPutAll: self name displayString asPhrase!

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
	^forecolor!

forecolor: aColorOrNil 
	forecolor := aColorOrNil!

getThreeStateFlag: anInteger
	^#(nil true false) at: ((flags bitAnd: anInteger) >> (anInteger lowBit - 1)) + 1!

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

	^self getThreeStateFlag: BoldMask!

isBold: aBooleanOrNil 
	"Set the receiver's three state flag that specifies whether the associated font
	is bold. If the argument is nil, then this style has no effect on the default
	font."

	self setThreeStateFlag: BoldMask value: aBooleanOrNil!

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

mergeFont: aFont 
	"Initialize any font settings that are currently unspecified from the <Font> argument."

	faceName ifNil: [faceName := aFont name].
	pointSize ifNil: [pointSize := aFont pointSize].
	self isItalic ifNil: [self setThreeStateFlag: ItalicMask value: aFont isItalic].
	self isBold ifNil: [self setThreeStateFlag: BoldMask value: aFont isBold].
	self isUnderlined ifNil: [self setThreeStateFlag: UnderlinedMask value: aFont isUnderlined].
	characterSet ifNil: [characterSet := aFont characterSet]!

name
	^name ifNil: ['style', self id displayString]!

name: anObject 
	name = anObject ifTrue: [^self].
	name := anObject isInteger 
				ifTrue: [id := anObject]
				ifFalse: [anObject  isEmpty ifFalse: [anObject asSymbol]]!

pointSize
	^pointSize!

pointSize: anIntegerOrNil 
	pointSize := anIntegerOrNil!

restyleFont: aFont 
	self pointSize ifNotNil: [:points | aFont pointSize: points].
	self isItalic ifNotNil: [:isItalic | aFont isItalic: isItalic].
	self isBold ifNotNil: [:isBold | aFont isBold: isBold].
	self isUnderlined ifNotNil: [:isUnderlined | aFont isUnderlined: isUnderlined].
	self characterSet ifNotNil: [:set | aFont characterSet: set]!

setThreeStateFlag: anInteger value: aBooleanOrNil
	| state |
	state := aBooleanOrNil isNil 
				ifTrue: [0]
				ifFalse: 
					[aBooleanOrNil 
						ifTrue: [(anInteger bitShift: -1) bitAnd: anInteger]
						ifFalse: [(anInteger bitShift: 1) bitAnd: anInteger]].
	flags := (flags maskClear: anInteger) maskSet: state!

storeableAttributes
	| attribs |
	attribs := super storeableAttributes.
	name ifNotNil: [attribs := (Array with: #name) , attribs].
	^attribs! !
!ScintillaTextStyle categoriesFor: #=!comparing!public! !
!ScintillaTextStyle categoriesFor: #backcolor!accessing!public! !
!ScintillaTextStyle categoriesFor: #backcolor:!accessing!public! !
!ScintillaTextStyle categoriesFor: #basicId!accessing!private! !
!ScintillaTextStyle categoriesFor: #case!accessing!public! !
!ScintillaTextStyle categoriesFor: #case:!accessing!public! !
!ScintillaTextStyle categoriesFor: #caseName!accessing!public! !
!ScintillaTextStyle categoriesFor: #caseName:!accessing!public! !
!ScintillaTextStyle categoriesFor: #characterSet!accessing!public! !
!ScintillaTextStyle categoriesFor: #characterSet:!accessing!public! !
!ScintillaTextStyle categoriesFor: #clearFont!accessing!public! !
!ScintillaTextStyle categoriesFor: #description!accessing!public! !
!ScintillaTextStyle categoriesFor: #description:!accessing!public! !
!ScintillaTextStyle categoriesFor: #displayOn:!displaying!public! !
!ScintillaTextStyle categoriesFor: #flags!accessing!public! !
!ScintillaTextStyle categoriesFor: #font!accessing!public! !
!ScintillaTextStyle categoriesFor: #font:!accessing!public! !
!ScintillaTextStyle categoriesFor: #fontName!accessing!public! !
!ScintillaTextStyle categoriesFor: #fontName:!accessing!public! !
!ScintillaTextStyle categoriesFor: #forecolor!accessing!public! !
!ScintillaTextStyle categoriesFor: #forecolor:!accessing!public! !
!ScintillaTextStyle categoriesFor: #getThreeStateFlag:!helpers!private! !
!ScintillaTextStyle categoriesFor: #initialize!initializing!private! !
!ScintillaTextStyle categoriesFor: #isBackcolorExtendedToEndOfLine!public!testing! !
!ScintillaTextStyle categoriesFor: #isBackcolorExtendedToEndOfLine:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isBold!public!testing! !
!ScintillaTextStyle categoriesFor: #isBold:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isChangeable!private!testing! !
!ScintillaTextStyle categoriesFor: #isHotspot!public!testing! !
!ScintillaTextStyle categoriesFor: #isHotspot:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isInvisible!public!testing! !
!ScintillaTextStyle categoriesFor: #isInvisible:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isItalic!public!testing! !
!ScintillaTextStyle categoriesFor: #isItalic:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isPredefined!public!testing! !
!ScintillaTextStyle categoriesFor: #isReadOnly!public!testing! !
!ScintillaTextStyle categoriesFor: #isReadOnly:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isUnderlined!public!testing! !
!ScintillaTextStyle categoriesFor: #isUnderlined:!accessing!public! !
!ScintillaTextStyle categoriesFor: #isVisible!private!testing! !
!ScintillaTextStyle categoriesFor: #mergeFont:!accessing!public! !
!ScintillaTextStyle categoriesFor: #name!accessing!public! !
!ScintillaTextStyle categoriesFor: #name:!accessing!public! !
!ScintillaTextStyle categoriesFor: #pointSize!accessing!public! !
!ScintillaTextStyle categoriesFor: #pointSize:!accessing!public! !
!ScintillaTextStyle categoriesFor: #restyleFont:!accessing!public! !
!ScintillaTextStyle categoriesFor: #setThreeStateFlag:value:!helpers!private! !
!ScintillaTextStyle categoriesFor: #storeableAttributes!development!printing!private! !

!ScintillaTextStyle class methodsFor!

caseNames
	^#(#mixed #upper #lower)!

icon
	^Font icon!

initialize
	"
		self initialize
	"

	BoldMask := 2r11.
	ItalicMask := 2r1100.
	UnderlinedMask := 2r110000.
	EolFilledMask := 2r11000000.
	ReadOnlyMask := 2r1100000000.
	HotspotMask := 2r110000000000.
	InvisibleMask := 2r11000000000000.
	attributes := (IdentityDictionary new)
				at: #forecolor put: SCI_STYLESETFORE;
				at: #backcolor put: SCI_STYLESETBACK;
				at: #fontName put: SCI_STYLESETFONT;
				at: #isBold put: SCI_STYLESETBOLD;
				at: #isItalic put: SCI_STYLESETITALIC;
				at: #isUnderlined put: SCI_STYLESETUNDERLINE;
				at: #case put: SCI_STYLESETCASE;
				at: #characterSet put: SCI_STYLESETCHARACTERSET;
				at: #pointSize put: SCI_STYLESETSIZE;
				at: #isBackcolorExtendedToEndOfLine put: SCI_STYLESETEOLFILLED;
				at: #isChangeable put: SCI_STYLESETCHANGEABLE;
				at: #isHotspot put: SCI_STYLESETHOTSPOT;
				at: #isVisible put: SCI_STYLESETVISIBLE;
				shrink;
				isImmutable: true;
				yourself.
	PredefinedStyleNames := IdentityDictionary new: STYLE_LASTPREDEFINED + 1.
	(STYLE_NORMAL + 1 to: STYLE_LASTPREDEFINED) do: [:each | PredefinedStyleNames at: each put: each].
	"These are not really Scintilla pre-defined styles, but some additional ones we add for convenience in the wrapping"
	PredefinedStyleNames
		at: #normal put: STYLE_NORMAL;
		yourself.
	PredefinedStyleNames
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
		removeKey: STYLE_DEFAULT.
	PredefinedStyleNames
		isImmutable: true;
		shrink!

name: aSymbol 
	^(self new)
		name: aSymbol;
		yourself!

new
	^super new initialize!

normal
	^(self name: #normal)
		description: 'Default text style';
		yourself! !
!ScintillaTextStyle class categoriesFor: #caseNames!constants!public! !
!ScintillaTextStyle class categoriesFor: #icon!constants!public! !
!ScintillaTextStyle class categoriesFor: #initialize!initializing!public! !
!ScintillaTextStyle class categoriesFor: #name:!instance creation!public! !
!ScintillaTextStyle class categoriesFor: #new!instance creation!public! !
!ScintillaTextStyle class categoriesFor: #normal!instance creation!public! !

