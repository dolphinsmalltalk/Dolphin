"Filed out from Dolphin Smalltalk X6.1"!

ScintillaAttribute subclass: #ScintillaMarkerDefinition
	instanceVariableNames: 'code forecolor backcolor view name'
	classVariableNames: 'FolderNames'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaMarkerDefinition guid: (GUID fromString: '{6191C503-F964-4AFB-9973-C2106886CCF9}')!
ScintillaMarkerDefinition comment: 'ScintillaMarkerDefinition instances represent the configured types of <ScintillaMarker>s for a particular <ScintillaView>.

Markers can be displayed in any margins configured for the view to mark particular lines.

Instance Variables:
	code		<integer>. Marker glyph code from the SC_MARK_XXX enumeration
	forecolor	<Color>. Foreground colour of the marker glyph.
	backcolor	<Color>. Background colour of the marker glyph.
	view		<ScintillaView>. View in which this marker type is defined.
	name	<Symbol>. Symbolic name of the marker type, e.g. #folder for a fold point marker, or some application defined name

'!
!ScintillaMarkerDefinition categoriesForClass!MVP-Views-Support! !
!ScintillaMarkerDefinition methodsFor!

backcolor
	^backcolor!

backcolor: aColor 
	backcolor := aColor.
	self updateViewAttribute: #backcolor!

basicId
	^id ifNil: [name ifNotNil: [id := FolderNames at: name ifAbsent: []]]!

code
	^code!

code: anInteger 
	code := anInteger.
	self updateViewAttribute: #code!

forecolor
	^forecolor!

forecolor: aColor 
	forecolor := aColor.
	self updateViewAttribute: #forecolor!

glyphName
	^code < SC_MARK_CHARACTER 
		ifTrue: [self class glyphNames at: code + 1]
		ifFalse: [(Character codePoint: code - SC_MARK_CHARACTER) asSymbol]!

glyphName: aSymbol 
	self code: (self class glyphNames indexOf: aSymbol
				ifAbsent: 
					[(aSymbol size = 1 and: [aSymbol first isPrintable and: [aSymbol first isWhitespace not]]) 
						ifTrue: [aSymbol first codePoint + SC_MARK_CHARACTER + 1]
						ifFalse: [^self error: 'Invalid glyph  ' , aSymbol printString]]) 
					- 1!

name
	^name ifNil: [self id]!

name: anObject 
	name = anObject ifTrue: [^self].
	name := anObject.
	id := name isInteger ifTrue: [name]!

newForLine: anInteger 
	"Answer a new <ScintillaMarker> of the type described by the receiver, for insertion
	at the specified line."

	^ScintillaMarker definition: self line: anInteger!

printableAttributes
	^(super printableAttributes)
		remove: #code;
		add: #glyphName;
		yourself!

setCode: anInteger forecolor: foreColor backcolor: backColor 
	code := anInteger.
	forecolor := foreColor.
	backcolor := backColor!

storeableAttributes
	^(Array with: #name) , super storeableAttributes!

view
	^view!

view: aScintillaView 
	view := aScintillaView! !
!ScintillaMarkerDefinition categoriesFor: #backcolor!accessing!public! !
!ScintillaMarkerDefinition categoriesFor: #backcolor:!accessing!public! !
!ScintillaMarkerDefinition categoriesFor: #basicId!accessing!private! !
!ScintillaMarkerDefinition categoriesFor: #code!accessing!private! !
!ScintillaMarkerDefinition categoriesFor: #code:!accessing!private! !
!ScintillaMarkerDefinition categoriesFor: #forecolor!accessing!public! !
!ScintillaMarkerDefinition categoriesFor: #forecolor:!accessing!public! !
!ScintillaMarkerDefinition categoriesFor: #glyphName!accessing!public! !
!ScintillaMarkerDefinition categoriesFor: #glyphName:!accessing!public! !
!ScintillaMarkerDefinition categoriesFor: #name!accessing!public! !
!ScintillaMarkerDefinition categoriesFor: #name:!accessing!public! !
!ScintillaMarkerDefinition categoriesFor: #newForLine:!adding!public! !
!ScintillaMarkerDefinition categoriesFor: #printableAttributes!development!helpers!printing!private! !
!ScintillaMarkerDefinition categoriesFor: #setCode:forecolor:backcolor:!initializing!private! !
!ScintillaMarkerDefinition categoriesFor: #storeableAttributes!development!printing!private! !
!ScintillaMarkerDefinition categoriesFor: #view!accessing!private! !
!ScintillaMarkerDefinition categoriesFor: #view:!accessing!private! !

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
	backcolor := RGB 
				red: 16r80
				green: 16r80
				blue: 16r80.
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

circleTree
	"Answer a set of marker definitions for fold margin markers in the 'Circle Tree' style. This
	is like a flattened tree control using circular headers and curved joins."

	| forecolor backcolor |
	forecolor := Color white.
	backcolor := RGB 
				red: 16r40
				green: 16r40
				blue: 16r40.
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

code: anInteger forecolor: foreColor backcolor: backColor 
	^(self basicNew)
		setCode: anInteger
			forecolor: foreColor
			backcolor: backColor;
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
	"An invisiable marker, potentially useful for tracking lines since markers move with them"
	names := names, #(#empty).
	names := names, #(#arrowDown #minus #plus).
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

	names := names, #(available).
	"Draws an underline across the text"
	names := names, #(underline).
	names)
!

initialize
	"
	self initialize
	"

	attributes := (IdentityDictionary new)
				at: #backcolor put: SCI_MARKERSETBACK;
				at: #forecolor put: SCI_MARKERSETFORE;
				at: #code put: SCI_MARKERDEFINE;
				shrink;
				isImmutable: true;
				yourself.
	FolderNames := (IdentityDictionary new)
				at: #folderEnd put: SC_MARKNUM_FOLDEREND;
				at: #folderOpenMid put: SC_MARKNUM_FOLDEROPENMID;
				at: #folderMidTail put: SC_MARKNUM_FOLDERMIDTAIL;
				at: #folderTail put: SC_MARKNUM_FOLDERTAIL;
				at: #folderSub put: SC_MARKNUM_FOLDERSUB;
				at: #folder put: SC_MARKNUM_FOLDER;
				at: #folderOpen put: SC_MARKNUM_FOLDEROPEN;
				shrink;
				isImmutable: true;
				yourself!

new
	^self 
		code: 0
		forecolor: Color black
		backcolor: Color white!

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

visibleCharacterGlyphs
	^(Character byteCharacterSet 
		select: [:each | each isPrintable and: [each isWhitespace not]]) asArray 
		collect: [:each | each asSymbol]! !
!ScintillaMarkerDefinition class categoriesFor: #arrows!constants!public! !
!ScintillaMarkerDefinition class categoriesFor: #boxTree!constants!public! !
!ScintillaMarkerDefinition class categoriesFor: #circleTree!constants!public! !
!ScintillaMarkerDefinition class categoriesFor: #code:forecolor:backcolor:!instance creation!public! !
!ScintillaMarkerDefinition class categoriesFor: #folderIds!constants!public! !
!ScintillaMarkerDefinition class categoriesFor: #foldMarkerNames!constants!public! !
!ScintillaMarkerDefinition class categoriesFor: #glyphNames!constants!public! !
!ScintillaMarkerDefinition class categoriesFor: #initialize!initializing!public! !
!ScintillaMarkerDefinition class categoriesFor: #new!instance creation!public! !
!ScintillaMarkerDefinition class categoriesFor: #plusMinus!constants!public! !
!ScintillaMarkerDefinition class categoriesFor: #visibleCharacterGlyphs!constants!development!public! !

