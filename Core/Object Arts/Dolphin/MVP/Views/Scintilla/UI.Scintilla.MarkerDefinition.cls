"Filed out from Dolphin Smalltalk"!

UI.Scintilla.Attribute
	subclass: #'UI.Scintilla.MarkerDefinition'
	instanceVariableNames: 'code forecolor backcolor view name alpha selectionBackcolor strokeWidth layerCode _reserved11 _reserved12'
	classVariableNames: 'Alpha Backcolor Forecolor GlyphName Layer SelectionBackcolor StrokeWidth'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'DefaultBackcolor' -> Color white.
			'DefaultForecolor' -> Color black.
			'DefaultSelectionBackcolor' -> Color red.
			'DefaultStrokeWidth' -> 16r64.
			'FolderNames'
				-> (IdentityDictionary withAll: {
								#folder -> 16r1E.
								#folderEnd -> 16r19.
								#folderMidTail -> 16r1B.
								#folderOpen -> 16r1F.
								#folderOpenMid -> 16r1A.
								#folderSub -> 16r1D.
								#folderTail -> 16r1C.
								#historyModified -> 16r17.
								#historyRevertedToModified -> 16r18.
								#historyRevertedToOrigin -> 16r15.
								#historySaved -> 16r16
							}).
			'PredefinedNames'
				-> (IdentityDictionary withAll: {
								#folder -> 16r1E.
								#folderEnd -> 16r19.
								#folderMidTail -> 16r1B.
								#folderOpen -> 16r1F.
								#folderOpenMid -> 16r1A.
								#folderSub -> 16r1D.
								#folderTail -> 16r1C
							})
		}!

UI.Scintilla.MarkerDefinition guid: (Core.GUID fromString: '{6191c503-f964-4afb-9973-c2106886ccf9}')!

UI.Scintilla.MarkerDefinition comment: '`Scintilla.MarkerDefinition` instances represent the configured types of `Scintilla.Marker`s for a particular `ScintillaView`.

Markers can be displayed in any symbol `Margin` configured for the view to mark particular lines.

## Instance Variables:
  `code`				`<integer>`. Marker glyph code from the SC_MARK_XXX enumeration
  `forecolor`			`<Color>`. Foreground colour value of the marker glyph.
  `backcolor`			`<Color>`. Background colour value of the marker glyph.
  `view`				`ScintillaView`. View in which this marker type is defined.
  `name`				`Symbol`. Symbolic name of the marker type, e.g. #folder for a fold point marker, or some application defined name
  `alpha`				`<Integer>`. 0..255 opacity
  `selectionBackcolor` 	`Color`. Highlight background colour of selected marker.
  `strokeWidth`		`<integer>`
  `layerCode`			`<integer>`

## Class Variables:
  `Alpha`				`<Scintilla.IntPropertyDescriptor>`
  `Backcolor`			`<Scintilla.ColourAlphaPropertyDescriptor>`
  `Forecolor`			`<Scintilla.ColourAlphaPropertyDescriptor>`
  `GlyphName`			`<Scintilla.EnumPropertyDescriptor>`
  `Layer`				`<Scintilla.EnumPropertyDescriptor>`
  `SelectionBackcolor`	`<Scintilla.ColourAlphaPropertyDescriptor>`
  `StrokeWidth`		`<Scintilla.HundredthsPropertyDescriptor>`

## Class Constants:
  `DefaultBackcolor`			`Color`. Default `backcolor`.
  `DefaultForecolor`			`Color`. Default `forecolor`.
  `DefaultSelectionBackcolor`	`Color`. Default `selectionBackcolor`.
  `DefaultStrokeWidth` 		`<integer>`. Default `strokeWidth`.
  `FolderNames`		`IdentityDictionary` mapping `Symbol` names of folder markers to the integer code from the `SC_MARKNUM_FOLDERxxx` enumeration



'!

!UI.Scintilla.MarkerDefinition categoriesForClass!MVP-Views-Support! !

!UI.Scintilla.MarkerDefinition methodsFor!

alpha
	^alpha ?? SC_ALPHA_NOALPHA!

alpha: anInteger
	alpha := anInteger isNil
				ifFalse: 
					[anInteger = SC_ALPHA_NOALPHA
						ifFalse: 
							[(anInteger between: SC_ALPHA_TRANSPARENT and: SC_ALPHA_OPAQUE)
								ifTrue: [anInteger]
								ifFalse: [self error: 'Invalid alpha value ' , anInteger displayString]]].
	self updateViewProperty: Alpha!

alphaValue
	"Private - Answer the integer alpha value to be passed to Scintilla"

	^self alpha ?? SC_ALPHA_NOALPHA!

backcolor
	"Answer the background <Color> used to draw the marker, or nil if the marker definition does not specify a background colour and the Scintilla default (white) should be used."

	^backcolor ?? DefaultBackcolor!

backcolor: aColorOrNil
	self basicBackcolor: aColorOrNil.
	self updateViewProperty: Backcolor!

basicBackcolor: aColorOrNil
	backcolor := (aColorOrNil isNil or: [aColorOrNil = DefaultBackcolor])
				ifFalse: [aColorOrNil isDefault ifTrue: [Color face3d] ifFalse: [aColorOrNil]]!

basicForecolor: aColorOrNil 
	forecolor := aColorOrNil = DefaultForecolor ifFalse: [aColorOrNil]!

basicId
	^id ifNil: [name ifNotNil: [id := PredefinedNames lookup: name]]!

basicSelectionBackcolor: aColorOrNil
	selectionBackcolor := aColorOrNil = DefaultSelectionBackcolor ifFalse: [aColorOrNil]!

basicStrokeWidth
	^strokeWidth!

basicStrokeWidth: anInteger
	strokeWidth := anInteger!

code
	^code!

code: anIntegerOrNil 
	code := anIntegerOrNil!

forecolor
	"Answer the foreground <Color> used to draw the marker, or nil if the marker definition does not specify a foreground colour and should use the Scintilla default (black)."

	^forecolor ?? DefaultForecolor!

forecolor: aColorOrNil
	self basicForecolor: aColorOrNil.
	self updateViewProperty: Forecolor!

glyphName
	^self code
		ifNil: [#circle]
		ifNotNil: 
			[:c |
			c < SC_MARK_CHARACTER
				ifTrue: [self class glyphNames at: c + 1]
				ifFalse: [Character codePoint: c - SC_MARK_CHARACTER]]!

glyphName: aSymbolOrCharacter
	"Set the glyph to be displayed for the marker in the margin. There are a range of named symbols, and any Unicode character may be used. When using <Character> glyphs, the character is drawn in the configured foreground colour (default black) onto a tile of the configured background color (default white). To avoid a visible tile of colour, set the backcolor to `Color face3d` (or `Color default`) so that background tile is the same colour as the margin."

	self code: (aSymbolOrCharacter isNil
				ifFalse: 
					[aSymbolOrCharacter isSymbol
						ifTrue: [(self class glyphNames indexOf: aSymbolOrCharacter ifAbsent: [SC_MARK_EMPTY + 1]) - 1]
						ifFalse: 
							[(aSymbolOrCharacter isCharacter and: [aSymbolOrCharacter isGraph])
								ifTrue: [aSymbolOrCharacter codePoint + SC_MARK_CHARACTER]
								ifFalse: [^self error: 'Invalid glyph  ' , aSymbolOrCharacter printString]]]).
	self updateViewProperty: GlyphName!

layer
	^self layerCode ifNil: [#base] ifNotNil: [:c | ScintillaView layerNames at: c + 1]!

layer: aSymbol
	layerCode := aSymbol ifNotNil: [(ScintillaView layerNames indexOf: aSymbol) - 1].
	self updateViewProperty: Layer!

layerCode
	^layerCode!

name
	^name ifNil: [self id]!

name: anObject 
	name = anObject ifTrue: [^self].
	name := anObject.
	id := name isInteger ifTrue: [name]!

newForLine: anInteger
	"Answer a new <ScintillaMarker> of the type described by the receiver, for insertion
	at the specified line."

	"This method is in the 'must not strip' category to prevent ScintillaMarker being removed if not otherwise referenced."

	^Marker definition: self line: anInteger!

selectionBackcolor
	"Answer the background <Color> used to draw the marker when selector, or nil if the marker definition does not specify a selection background colour and the Scintilla default (red) should be used."

	^selectionBackcolor ?? DefaultSelectionBackcolor!

selectionBackcolor: aColor
	self basicSelectionBackcolor: aColor.
	self updateViewProperty: SelectionBackcolor!

storeableProperties
	^{#name} , super storeableProperties!

strokeWidth
	"The stroke width used to draw the marker expressed in pixels."

	| width fraction |
	width := (strokeWidth ?? DefaultStrokeWidth) / 100.0.
	fraction := width asApproximateFraction.
	^fraction isInteger ifTrue: [fraction] ifFalse: [width]!

strokeWidth: aNumberOrNil
	self basicStrokeWidth: (aNumberOrNil ifNotNil: [:i | (i * 100) rounded]).
	self updateViewProperty: StrokeWidth!

view
	^view!

view: aScintillaView 
	view := aScintillaView! !

!UI.Scintilla.MarkerDefinition categoriesForMethods!
alpha!accessing!public! !
alpha:!accessing!public! !
alphaValue!accessing!private! !
backcolor!accessing!public! !
backcolor:!accessing!public! !
basicBackcolor:!accessing!private! !
basicForecolor:!accessing!private! !
basicId!accessing!private! !
basicSelectionBackcolor:!accessing!private! !
basicStrokeWidth!accessing!private! !
basicStrokeWidth:!accessing!private! !
code!accessing!private! !
code:!accessing!private! !
forecolor!accessing!colors!public! !
forecolor:!accessing!colors!public! !
glyphName!accessing!public! !
glyphName:!accessing!public! !
layer!accessing!public! !
layer:!accessing!public! !
layerCode!accessing!private! !
name!accessing!public! !
name:!accessing!public! !
newForLine:!adding!must not strip!public! !
selectionBackcolor!accessing!colors!public! !
selectionBackcolor:!accessing!colors!public! !
storeableProperties!development!printing!private! !
strokeWidth!accessing!public! !
strokeWidth:!accessing!public! !
view!accessing!private! !
view:!accessing!private! !
!

!UI.Scintilla.MarkerDefinition class methodsFor!

arrows
	"Answer a set of marker definitions for fold margin markers in the Macintosh 'Arrow' style. This is a minimalist set with only a right arrow for collapsed fold points, and down arrow for expanded."

	^{
		self new
			name: #folderOpen;
			forecolor: Color.Black;
			backcolor: Color.Black;
			glyphName: #arrowDown;
			yourself.
		self new
			name: #folder;
			forecolor: Color.Black;
			backcolor: Color.Black;
			glyphName: #arrow;
			yourself.
		self new
			name: #folderSub;
			forecolor: Color.Black;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself.
		self new
			name: #folderTail;
			forecolor: Color.Black;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself.
		self new
			name: #folderEnd;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself.
		self new
			name: #folderOpenMid;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself.
		self new
			name: #folderMidTail;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself
	}!

boxTree
	"Answer a set of marker definitions for fold margin markers in the 'Box Tree' style. This is like a flattened tree control using square headers and right angle joins"

	| backcolor |
	backcolor := Color brightness: 16r80 / 16rFF.
	^{
		self new
			name: #folderOpen;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #boxMinus;
			yourself.
		self new
			name: #folder;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #boxPlus;
			yourself.
		self new
			name: #folderSub;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #verticalLine;
			yourself.
		self new
			name: #folderTail;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #leftCorner;
			yourself.
		self new
			name: #folderEnd;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #boxPlusConnected;
			yourself.
		self new
			name: #folderOpenMid;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #boxMinusConnected;
			yourself.
		self new
			name: #folderMidTail;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #teeJunction;
			yourself
	}!

buildPropertyDescriptors
	Backcolor := ColourAlphaPropertyDescriptor
				key: #backcolor
				defaultValue: Color white
				setMessage: SCI_MARKERSETBACKTRANSLUCENT.
	Forecolor := ColourAlphaPropertyDescriptor
				key: #forecolor
				defaultValue: Color black
				setMessage: SCI_MARKERSETFORETRANSLUCENT.
	GlyphName := (EnumPropertyDescriptor
				key: #glyphName
				defaultValue: SC_MARK_CIRCLE
				setMessage: SCI_MARKERDEFINE)
				getSelector: #code;
				values: self glyphNames , self visibleCharacterGlyphs;
				alwaysPrint: true;
				yourself.
	Alpha := IntPropertyDescriptor
				key: #alpha
				defaultValue: SC_ALPHA_NOALPHA
				setMessage: SCI_MARKERSETALPHA.
	SelectionBackcolor := ColourAlphaPropertyDescriptor
				key: #selectionBackcolor
				defaultValue: Color red
				setMessage: SCI_MARKERSETBACKSELECTEDTRANSLUCENT.
	StrokeWidth := (HundredthsPropertyDescriptor
				key: #strokeWidth
				defaultValue: DefaultStrokeWidth
				setMessage: SCI_MARKERSETSTROKEWIDTH)
				getSelector: #basicStrokeWidth;
				beNullable;
				yourself.
	Layer := (EnumPropertyDescriptor
				key: #layer
				defaultValue: SC_LAYER_BASE
				setMessage: SCI_MARKERSETLAYER)
				getSelector: #layerCode;
				values: ScintillaView layerNames;
				yourself.
	^{ Backcolor. Forecolor. GlyphName. Alpha. SelectionBackcolor. StrokeWidth. Layer }!

circleTree
	"Answer a set of marker definitions for fold margin markers in the 'Circle Tree' style. This is like a flattened tree control using circular headers and curved joins."

	| backcolor |
	backcolor := Color brightness: 16r40 / 16rFF.
	^{
		self new
			name: #folderOpen;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #circleMinus;
			yourself.
		self new
			name: #folder;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #circlePlus;
			yourself.
		self new
			name: #folderSub;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #verticalLine;
			yourself.
		self new
			name: #folderTail;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #leftCornerCurve;
			yourself.
		self new
			name: #folderEnd;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #circlePlusConnected;
			yourself.
		self new
			name: #folderOpenMid;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #circleMinusConnected;
			yourself.
		self new
			name: #folderMidTail;
			forecolor: Color.White;
			backcolor: backcolor;
			glyphName: #teeJunctionCurve;
			yourself
	}!

folderIds
	^SC_MARKNUM_FOLDEREND to: SC_MARKNUM_FOLDEROPEN!

foldMarkerNames
	"Answer the symbolic names of all predefined fold marker id's. These correspond with the codes in the SC_MARKNUM_XXX enumeration. "

	^PredefinedNames keys select: [:each | each beginsWith: 'folder']!

glyphNames
	"Answer the symbolic names of all predefined marker shapes. These correspond with the codes in the SC_MARK_XXX enumeration.
	Note that any visible character in the font can also be used as a marker glyph."

	^##(| names |
	names := #(#circle #roundRect #arrow #smallRect #shortArrow).
	"An invisible marker, potentially useful for tracking lines since markers move with them"
	names := names , #(#empty).
	names := names , #(#arrowDown #minus #plus).
	"Shapes for fold margin"
	names := names
				, #(#verticalLine #leftCorner #teeJunction #boxPlus #boxPlusConnected #boxMinus #boxMinusConnected #leftCornerCurve #teeJunctionCurve #circlePlus #circlePlusConnected #circleMinus #circleMinusConnected).
	"Invisible marker that sets the line background colour to match that defined for the marker"
	names := names , #(#background).
	"Miscellaneous"
	names := names , #(#dotDotDot #arrows #pixmap).
	"Marker similar to #background, but changes only the margin background colour"
	names := names , #(#fullRect).
	"?"
	names := names , #(#leftRect).
	names := names , #(#available).
	"Draws an underline across the text"
	names := names , #(#underline).
	"RGBA image - not fully supported"
	names := names , #(#rgbaImage).
	names := names , #(#bookmark #verticalBookmark).
	"5.3.2"
	names := names , #(#bar).
	names)
!

historyBars
	"Answer a set of marker definitions for change history margin markers in the default Scintilla style (i.e. using the bar marker symnbol)"

	| revertedToOrigin saved modified revertedToChange |
	revertedToOrigin := Color
				r: 16r40
				g: 16rA0
				b: 16rBF.
	saved := Color
				r: 16r0
				g: 16rA0
				b: 16r0.
	modified := Color
				r: 16rFF
				g: 16r80
				b: 16r0.
	revertedToChange := Color
				r: 16rA0
				g: 16rC0
				b: 16r0.
	^{
		self new
			name: #historyRevertedToOrigin;
			id: SC_MARKNUM_HISTORY_REVERTED_TO_ORIGIN;
			forecolor: revertedToOrigin;
			backcolor: revertedToOrigin;
			glyphName: #bar;
			yourself.
		self new
			name: #historySaved;
			id: SC_MARKNUM_HISTORY_SAVED;
			forecolor: saved;
			backcolor: saved;
			glyphName: #bar;
			yourself.
		self new
			name: #historyModified;
			id: SC_MARKNUM_HISTORY_MODIFIED;
			forecolor: modified;
			backcolor: Color face3d;
			glyphName: #bar;
			yourself.
		self new
			name: #historyRevertedToModified;
			id: SC_MARKNUM_HISTORY_REVERTED_TO_MODIFIED;
			forecolor: revertedToChange;
			backcolor: revertedToChange;
			glyphName: #bar;
			yourself
	}!

initialize
	"
	self initialize
	"

	propertyDescriptors := self buildPropertyDescriptors
				beImmutableObject;
				yourself.
	self addClassConstant: 'FolderNames'
		value: (IdentityDictionary withAll: {
						#folderEnd -> SC_MARKNUM_FOLDEREND.
						#folderOpenMid -> SC_MARKNUM_FOLDEROPENMID.
						#folderMidTail -> SC_MARKNUM_FOLDERMIDTAIL.
						#folderTail -> SC_MARKNUM_FOLDERTAIL.
						#folderSub -> SC_MARKNUM_FOLDERSUB.
						#folder -> SC_MARKNUM_FOLDER.
						#folderOpen -> SC_MARKNUM_FOLDEROPEN.
						#historyRevertedToOrigin -> SC_MARKNUM_HISTORY_REVERTED_TO_ORIGIN.
						#historySaved -> SC_MARKNUM_HISTORY_SAVED.
						#historyModified -> SC_MARKNUM_HISTORY_MODIFIED.
						#historyRevertedToModified -> SC_MARKNUM_HISTORY_REVERTED_TO_MODIFIED
					})!

name: aSymbol
	^self new
		name: aSymbol;
		yourself!

plusMinus
	"Answer a set of marker definitions for fold margin markers in the 'Plus/Minus' style. This is a minimalist set with only a plus sign for collapsed fold points, and minus sign for expanded."

	"If you want basically this style but a heavier effect, either invert the foreground and background colours, or set both to black"

	^{
		self new
			name: #folderOpen;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #minus;
			yourself.
		self new
			name: #folder;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #plus;
			yourself.
		self new
			name: #folderSub;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself.
		self new
			name: #folderTail;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself.
		self new
			name: #folderEnd;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself.
		self new
			name: #folderOpenMid;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself.
		self new
			name: #folderMidTail;
			forecolor: Color.White;
			backcolor: Color.Black;
			glyphName: #empty;
			yourself
	}!

stbConvertFrom: anSTBClassFormat
	^
	[:vars |
	vars resize: self instSize.
	"code"
	(vars at: 2) == 0 ifTrue: [vars at: 2 put: nil].
	"Replace integer colour values and IndexedColors, nil'ing if the default else storing a (non-indexed) Color"
	#(3 0 4 16rFFFFFF 8 16rFF) pairsDo: 
			[:i :default |
			(vars lookup: i)
				ifNotNil: 
					[:color |
					| rgb |
					rgb := (color isInteger ifTrue: [Color fromCOLORREF: color] ifFalse: [color]) rgbCode.
					vars at: 3 put: (rgb = default ifFalse: [Color fromRgbCode: rgb])]].
	vars becomeA: self]!

stbVersion
	"Versions:
		0: 7.0 initial (80d5c9c20)
		1: Scintilla 3.6.3 upgrade; adds alpha selectionBackcolor and reserved vars (29d80afa7)
		3: Ensure colors not stored as IndexedColors as not compatible with DirectWrite (ec9ba7ecc)"

	^2!

visibleCharacterGlyphs
	#todo.	"Select a better range of characters more likely to be useful as markers by using the Unicode classifications, e.g. geometric shapes."
	^(Character byteCharacterSet select: [:each | each isGraph]) asArray! !

!UI.Scintilla.MarkerDefinition class categoriesForMethods!
arrows!constants!public! !
boxTree!constants!public! !
buildPropertyDescriptors!constants!must not strip!private! !
circleTree!constants!public! !
folderIds!constants!public! !
foldMarkerNames!constants!public! !
glyphNames!constants!public! !
historyBars!constants!public! !
initialize!development!initializing!public! !
name:!instance creation!public! !
plusMinus!constants!public! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
visibleCharacterGlyphs!constants!public! !
!

