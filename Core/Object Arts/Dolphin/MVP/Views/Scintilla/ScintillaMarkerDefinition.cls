"Filed out from Dolphin Smalltalk"!

ScintillaAttribute subclass: #ScintillaMarkerDefinition
	instanceVariableNames: 'code forecolor backcolor view name alpha selectionBackcolor _reserved9 _reserved10 _reserved11 _reserved12'
	classVariableNames: 'FolderNames'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ScintillaMarkerDefinition guid: (GUID fromString: '{6191c503-f964-4afb-9973-c2106886ccf9}')!

ScintillaMarkerDefinition comment: '`ScintillaMarkerDefinition` instances represent the configured types of `ScintillaMarker`s for a particular `ScintillaView`.

Markers can be displayed in any symbol margins configured for the view to mark particular lines.

## Instance Variables:
  `code`				`<integer>`. Marker glyph code from the SC_MARK_XXX enumeration
  `forecolor`			`<Color>`. Foreground colour value of the marker glyph.
  `backcolor`			`<Color>`. Background colour value of the marker glyph.
  `view`				`ScintillaView`. View in which this marker type is defined.
  `name`				`Symbol`. Symbolic name of the marker type, e.g. #folder for a fold point marker, or some application defined name
  `alpha`				`<Integer>`. 0..255 opacity
  `selectionBackcolor` 	`Color`. Highlight background colour of selected marker.

## Class Variables:
  `FolderNames`		`IdentityDictionary` mapping `Symbol` names of folder markers to the integer code from the `SC_MARKNUM_FOLDERxxx` enumeration



'!

!ScintillaMarkerDefinition categoriesForClass!MVP-Views-Support! !

!ScintillaMarkerDefinition methodsFor!

alpha
	^alpha!

alpha: anInteger
	alpha := anInteger isNil
				ifFalse: 
					[anInteger = SC_ALPHA_NOALPHA
						ifFalse: 
							[(anInteger between: SC_ALPHA_TRANSPARENT and: SC_ALPHA_OPAQUE)
								ifTrue: [anInteger]
								ifFalse: [self error: 'Invalid alpha value ' , anInteger displayString]]].
	self updateViewProperty: #alpha!

alphaValue
	"Private - Answer the integer alpha value to be passed to Scintilla"

	^self alpha ?? SC_ALPHA_NOALPHA!

backcolor
	"Answer the background <Color> used to draw the marker, or nil if the marker definition does not specify a background colour and the Scintilla default (white) should be used."

	^backcolor!

backcolor: aColorOrNil
	self basicBackcolor: aColorOrNil.
	self updateViewProperty: #backcolor!

basicBackcolor: aColorOrNil 
	backcolor := aColorOrNil!

basicForecolor: aColorOrNil 
	forecolor := aColorOrNil!

basicId
	^id ifNil: [name ifNotNil: [id := FolderNames lookup: name]]!

basicSelectionBackcolor: aColorOrNil
	selectionBackcolor := aColorOrNil!

code
	^code!

code: anIntegerOrNil 
	code := anIntegerOrNil!

forecolor
	"Answer the foreground <Color> used to draw the marker, or nil if the marker definition does not specify a foreground colour and should use the Scintilla default (black)."

	^forecolor!

forecolor: aColorOrNil
	self basicForecolor: aColorOrNil.
	self updateViewProperty: #forecolor!

glyphName
	^self code 
		ifNil: [#circle]
		ifNotNil: 
			[:c | 
			c < SC_MARK_CHARACTER 
				ifTrue: [self class glyphNames at: c + 1]
				ifFalse: [(Character codePoint: c - SC_MARK_CHARACTER) asSymbol]]!

glyphName: aSymbol
	self code: (aSymbol isNil
				ifFalse: 
					[(self class glyphNames indexOf: aSymbol
						ifAbsent: 
							[(aSymbol size = 1 and: [aSymbol first isGraph])
								ifTrue: [aSymbol first codePoint + SC_MARK_CHARACTER + 1]
								ifFalse: [^self error: 'Invalid glyph  ' , aSymbol printString]])
							- 1]).
	self updateViewProperty: #glyphName!

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

	^ScintillaMarker definition: self line: anInteger!

selectionBackcolor
	"Answer the background <Color> used to draw the marker when selector, or nil if the marker definition does not specify a selection background colour and the Scintilla default (red) should be used."

	^selectionBackcolor!

selectionBackcolor: aColor
	self basicSelectionBackcolor: aColor.
	self updateViewProperty: #selectionBackcolor!

storeableProperties
	^{#name} , super storeableProperties!

view
	^view!

view: aScintillaView 
	view := aScintillaView! !

!ScintillaMarkerDefinition categoriesForMethods!
alpha!accessing!public! !
alpha:!accessing!public! !
alphaValue!accessing!private! !
backcolor!accessing!public! !
backcolor:!accessing!public! !
basicBackcolor:!accessing!private! !
basicForecolor:!accessing!private! !
basicId!accessing!private! !
basicSelectionBackcolor:!accessing!private! !
code!accessing!private! !
code:!accessing!private! !
forecolor!accessing!colors!public! !
forecolor:!accessing!colors!public! !
glyphName!accessing!public! !
glyphName:!accessing!public! !
name!accessing!public! !
name:!accessing!public! !
newForLine:!adding!must not strip!public! !
selectionBackcolor!accessing!colors!public! !
selectionBackcolor:!accessing!colors!public! !
storeableProperties!development!printing!private! !
view!accessing!private! !
view:!accessing!private! !
!

!ScintillaMarkerDefinition class methodsFor!

arrows
	"Answer a set of marker definitions for fold margin markers in the Macintosh 'Arrow' style.
	This is a minimalist set with only a right arrow for collapsed fold points, and down arrow
	for expanded."

	| white black |
	white := Color white.
	black := Color black.
	^(OrderedCollection new)
		add: ((self new)
					name: #folderOpen;
					forecolor: black;
					backcolor: black;
					glyphName: #arrowDown;
					yourself);
		add: ((self new)
					name: #folder;
					forecolor: black;
					backcolor: black;
					glyphName: #arrow;
					yourself);
		add: ((self new)
					name: #folderSub;
					forecolor: black;
					backcolor: black;
					glyphName: #empty;
					yourself);
		add: ((self new)
					name: #folderTail;
					forecolor: black;
					backcolor: black;
					glyphName: #empty;
					yourself);
		add: ((self new)
					name: #folderEnd;
					forecolor: white;
					backcolor: black;
					glyphName: #empty;
					yourself);
		add: ((self new)
					name: #folderOpenMid;
					forecolor: white;
					backcolor: black;
					glyphName: #empty;
					yourself);
		add: ((self new)
					name: #folderMidTail;
					forecolor: white;
					backcolor: black;
					glyphName: #empty;
					yourself);
		yourself!

boxTree
	"Answer a set of marker definitions for fold margin markers in the 'Box Tree' style. This is
	like a flattened tree control using square headers and right angle joins"

	| forecolor backcolor |
	forecolor := Color white.
	backcolor := Color brightness: 16r80/16rFF. 
	^(OrderedCollection new)
		add: ((self new)
					name: #folderOpen;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #boxMinus;
					yourself);
		add: ((self new)
					name: #folder;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #boxPlus;
					yourself);
		add: ((self new)
					name: #folderSub;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #verticalLine;
					yourself);
		add: ((self new)
					name: #folderTail;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #leftCorner;
					yourself);
		add: ((self new)
					name: #folderEnd;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #boxPlusConnected;
					yourself);
		add: ((self new)
					name: #folderOpenMid;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #boxMinusConnected;
					yourself);
		add: ((self new)
					name: #folderMidTail;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #teeJunction;
					yourself);
		yourself!

buildPropertyMap
	^IdentityDictionary new
		at: #backcolor
			put: (ScintillaColorPropertyDescriptor
					getSelector: #backcolor
					defaultValue: Color white
					setMessage: SCI_MARKERSETBACK);
		at: #forecolor
			put: (ScintillaColorPropertyDescriptor
					getSelector: #forecolor
					defaultValue: Color black
					setMessage: SCI_MARKERSETFORE);
		at: #glyphName
			put: ((ScintillaPropertyDescriptor
					getSelector: #code
					defaultValue: 0
					setMessage: SCI_MARKERDEFINE)
					alwaysPrint: true;
					yourself);
		at: #alpha
			put: (ScintillaPropertyDescriptor
					getSelector: #alpha
					defaultValue: SC_ALPHA_NOALPHA
					setMessage: SCI_MARKERSETALPHA);
		at: #selectionBackcolor
			put: (ScintillaColorPropertyDescriptor
					getSelector: #selectionBackcolor
					defaultValue: Color red
					setMessage: SCI_MARKERSETBACKSELECTED);
		shrink;
		yourself!

circleTree
	"Answer a set of marker definitions for fold margin markers in the 'Circle Tree' style. This
	is like a flattened tree control using circular headers and curved joins."

	| forecolor backcolor |
	forecolor := Color white.
	backcolor := Color brightness: 16r40/16rFF.
	^(OrderedCollection new)
		add: ((self new)
					name: #folderOpen;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #circleMinus;
					yourself);
		add: ((self new)
					name: #folder;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #circlePlus;
					yourself);
		add: ((self new)
					name: #folderSub;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #verticalLine;
					yourself);
		add: ((self new)
					name: #folderTail;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #leftCornerCurve;
					yourself);
		add: ((self new)
					name: #folderEnd;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #circlePlusConnected;
					yourself);
		add: ((self new)
					name: #folderOpenMid;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #circleMinusConnected;
					yourself);
		add: ((self new)
					name: #folderMidTail;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #teeJunctionCurve;
					yourself);
		yourself!

folderIds
	^FolderNames values!

foldMarkerNames
	"Answer the symbolic names of all predefined fold marker id's. These correspond with the
	codes in the SC_MARKNUM_XXX enumeration. "

	^FolderNames keys!

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
	names)!

initialize
	"
	self initialize
	"

	propertyMap := self buildPropertyMap
				isImmutable: true;
				yourself.
	self addClassConstant: 'FolderNames'
		value: (IdentityDictionary new
				at: #folderEnd put: SC_MARKNUM_FOLDEREND;
				at: #folderOpenMid put: SC_MARKNUM_FOLDEROPENMID;
				at: #folderMidTail put: SC_MARKNUM_FOLDERMIDTAIL;
				at: #folderTail put: SC_MARKNUM_FOLDERTAIL;
				at: #folderSub put: SC_MARKNUM_FOLDERSUB;
				at: #folder put: SC_MARKNUM_FOLDER;
				at: #folderOpen put: SC_MARKNUM_FOLDEROPEN;
				shrink;
				isImmutable: true;
				yourself)!

plusMinus
	"Answer a set of marker definitions for fold margin markers in the 'Plus/Minus' style. This
	is a minimalist set with only a plus sign for collapsed fold points, and minus sign for
	expanded."

	"If you want basically this style but a heavier effect, either invert the foreground and
	background colours, or set both to black"

	| forecolor backcolor |
	forecolor := Color white.
	backcolor := Color black.
	^(OrderedCollection new)
		add: ((self new)
					name: #folderOpen;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #minus;
					yourself);
		add: ((self new)
					name: #folder;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #plus;
					yourself);
		add: ((self new)
					name: #folderSub;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #empty;
					yourself);
		add: ((self new)
					name: #folderTail;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #empty;
					yourself);
		add: ((self new)
					name: #folderEnd;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #empty;
					yourself);
		add: ((self new)
					name: #folderOpenMid;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #empty;
					yourself);
		add: ((self new)
					name: #folderMidTail;
					forecolor: forecolor;
					backcolor: backcolor;
					glyphName: #empty;
					yourself);
		yourself!

stbConvertFrom: anSTBClassFormat
	^
	[:vars |
	| instance |
	instance := self new.
	vars keysAndValuesDo: [:eachKey :eachValue | instance instVarAt: eachKey put: eachValue].
	"Nil out some inst vars that have default value in old instances"
	instance code ifNotNil: [:code | instance code: (code isZero ifFalse: [code])].
	instance forecolor
		ifNotNil: 
			[:color |
			| forecolor |
			forecolor := color isInteger ifTrue: [Color fromCOLORREF: color] ifFalse: [color].
			instance basicForecolor: (forecolor rgbCode == 0 ifFalse: [forecolor])].
	instance backcolor
		ifNotNil: 
			[:color |
			| backcolor |
			backcolor := color isInteger ifTrue: [Color fromCOLORREF: color] ifFalse: [color].
			instance basicBackcolor: (backcolor rgbCode == 16rFFFFFF ifFalse: [backcolor])].
	instance selectionBackcolor
		ifNotNil: 
			[:color |
			| backcolor |
			backcolor := color isInteger ifTrue: [Color fromCOLORREF: color] ifFalse: [color].
			instance basicSelectionBackcolor: (backcolor rgbCode == 16rFF ifFalse: [backcolor])].
	instance]!

stbVersion
	^2!

visibleCharacterGlyphs
	^(Character byteCharacterSet select: [:each | each isGraph]) asArray
		collect: [:each | each asSymbol]! !

!ScintillaMarkerDefinition class categoriesForMethods!
arrows!constants!public! !
boxTree!constants!public! !
buildPropertyMap!constants!must not strip!private! !
circleTree!constants!public! !
folderIds!constants!public! !
foldMarkerNames!constants!public! !
glyphNames!constants!public! !
initialize!development!initializing!public! !
plusMinus!constants!public! !
stbConvertFrom:!binary filing!private! !
stbVersion!binary filing!public! !
visibleCharacterGlyphs!constants!public! !
!

