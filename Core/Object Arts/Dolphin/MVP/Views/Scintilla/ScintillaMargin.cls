"Filed out from Dolphin Smalltalk 7"!

QueryableScintillaAttribute subclass: #ScintillaMargin
	instanceVariableNames: 'width type isSensitive mask cursorType backcolor'
	classVariableNames: 'CursorTypes MarginTypes'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaMargin guid: (GUID fromString: '{FD6F73FE-70D8-4E4A-8332-EC147E5BA899}')!
ScintillaMargin comment: 'ScintillaMargin instances represent the ''margin'' attributes of a <ScintillaView>.

From the Scintilla Documentation:

"There may be up to three margins to the left of the text display, plus a gap either side of the text. Each margin can be set to display either symbols or line numbers [using the #isNumbers aspect]. The markers that can be displayed in each margin are set with [#mask]. Any markers not associated with a visible margin will be displayed as changes in background colour in the text. A width in pixels can be set for each margin. Margins with a zero width are ignored completely. You can choose if a mouse click in a margin [triggers a #marginClicked event] or selects a line of text [by using the #isSensitive aspect].

The margins are numbered 0 to 2. Using a margin number outside the valid range has no effect. By default, margin 0 is set to display line numbers, but is given a width of 0, so it is hidden. Margin 1 is set to display non-folding symbols and is given a width of 16 pixels, so it is visible. Margin 2 is set to display the folding symbols, but is given a width of 0, so it is hidden. Of course, you can set the margins to be whatever you wish."

Instance Variables:
	width		<integer>. Pixel width of the margin (0 if invisible)
	type		<integer>. Type code (numbers, symbols, or numbers and symbols)
	isSensitive	<boolean>. Whether responds to mouse clicks by sending SCN_MARGINCLICK notifications.
	mask		<integer> flags controlling which markers can be displayed. See #mask for further details.

'!
!ScintillaMargin categoriesForClass!MVP-Views-Support! !
!ScintillaMargin methodsFor!

backcolor
	^self basicBackcolor ifNotNil: [:rgbVal | RGB fromInteger: rgbVal]!

backcolor: aColorOrNil
	self basicBackcolor: (aColorOrNil ifNotNil: [aColorOrNil asParameter]).
	self updateViewProperty: #backcolor!

basicBackcolor
	^backcolor!

basicBackcolor: anIntegerOrNil
	backcolor := anIntegerOrNil!

basicCursorType
	"Private - The Scintilla cursor type to be used in the margin, or nil if the default reverse
	arrow is to be used."

	^cursorType!

basicCursorType: anIntegerOrNil 
	"Private - The Scintilla cursor type to be used in the margin."

	cursorType := anIntegerOrNil!

basicIsSensitive
	^isSensitive!

basicIsSensitive: anIntegerOrNil
	isSensitive := anIntegerOrNil!

basicType
	"Private - The Scintilla margin type. From the Scintilla documentation: 'You can use the
	predefined constants SC_MARGIN_SYMBOL (0) and SC_MARGIN_NUMBER (1) to set a margin as either
	a line number or a symbol margin. A margin with application defined text may use
	SC_MARGIN_TEXT (4) or SC_MARGIN_RTEXT (5) to right justify the text. By convention, margin 0
	is used for line numbers and the next two are used for symbols. You can also use the
	constants SC_MARGIN_BACK (2), SC_MARGIN_FORE (3), and SC_MARGIN_COLOUR (6) for symbol
	margins that set their background colour to match the STYLE_DEFAULT background and
	foreground colours or a specified colour.'"

	^type!

basicType: anIntegerOrNil 
	type := anIntegerOrNil!

basicWidth
	^width!

basicWidth: anIntegerOrNil
	width := anIntegerOrNil!

cursorType
	"The symbolic name of the Scintilla cursor type."

	^self basicCursorType ifNotNil: [:t | CursorTypes at: t]!

cursorType: aSymbol
	"Set the margin's cursor to be that named."

	self basicCursorType: (aSymbol isNil
				ifFalse: [CursorTypes keyAtValue: aSymbol ifAbsent: [self error: 'Invalid cursor type' , aSymbol]]).
	self updateViewProperty: #cursorType!

isFolders
	^mask allMask: SC_MASK_FOLDERS!

isFolders: aBoolean 
	self mask: (self mask mask: SC_MASK_FOLDERS set: aBoolean)!

isSensitive
	"Answer whether this margin is sensitive to mouse clicks."

	^(self basicIsSensitive ?? 0) asBoolean!

isSensitive: aBooleanOrNil
	self basicIsSensitive: (aBooleanOrNil ?? false ifTrue: [1]).
	self updateViewProperty: #isSensitive!

mask
	"Answe the <integer> mask which controls which shapes will be visible in the margin.

	From the Scintilla documentation:

	'The mask is a 32-bit value. Each bit corresponds to one of 32 logical symbols that can be
	displayed in a margin that is enabled for symbols. There is a useful constant,
	SC_MASK_FOLDERS (0xFE000000 or -33554432), that is a mask for the 7 logical symbols used to
	denote folding. You can assign a wide range of symbols and colours to each of the 32 logical
	symbols, see Markers for more information. If (mask & SC_MASK_FOLDERS)==0, the margin
	background colour is controlled by style 33 (STYLE_LINENUMBER).

	... If a line has an associated marker that does not appear in the mask of any margin with a
	non-zero width, the marker changes the background colour of the line. For example, suppose
	you decide to use logical marker 10 to mark lines with a syntax error and you want to show
	such lines by changing the background colour. The mask for this marker is 1 shifted left 10
	times (1<<10) which is 0x400. If you make sure that no symbol margin includes 0x400 in its
	mask, any line with the marker gets the background colour changed.

	To set a non-folding margin 1 use SCI_SETMARGINMASKN(1, ~SC_MASK_FOLDERS); to set a folding
	margin 2 use SCI_SETMARGINMASKN(2, SC_MASK_FOLDERS). This is the default set by Scintilla.
	~SC_MASK_FOLDERS is 0x1FFFFFF in hexadecimal or 33554431 decimal. Of course, you may need to
	display all 32 symbols in a margin, in which case use SCI_SETMARGINMASKN(margin, -1).'"

	^mask!

mask: anInteger
	mask := anInteger.
	self updateViewProperty: #mask!

type
	"The symbolic name of the Scintilla margin type, defaulting to #symbol."

	^self basicType
		ifNil: [#symbol]
		ifNotNil: [:t | MarginTypes at: t + 1]!

type: aSymbol
	"Set the margin type by name."

	self basicType: (aSymbol ifNotNil: [(MarginTypes keyAtValue: aSymbol) - 1]).
	self updateViewProperty: #type!

width
	"Answer the <integer> pixel width of this margin."

	^self basicWidth ?? 0!

width: anInteger
	"Answer the <integer> pixel width of this margin. Set to zero to make the margin invisible."

	self basicWidth: (anInteger ifNotNil: [anInteger]).
	self updateViewProperty: #width! !
!ScintillaMargin categoriesFor: #backcolor!accessing!public! !
!ScintillaMargin categoriesFor: #backcolor:!accessing!public! !
!ScintillaMargin categoriesFor: #basicBackcolor!accessing!private! !
!ScintillaMargin categoriesFor: #basicBackcolor:!accessing!private! !
!ScintillaMargin categoriesFor: #basicCursorType!accessing!private! !
!ScintillaMargin categoriesFor: #basicCursorType:!accessing!private! !
!ScintillaMargin categoriesFor: #basicIsSensitive!accessing!private! !
!ScintillaMargin categoriesFor: #basicIsSensitive:!accessing!private! !
!ScintillaMargin categoriesFor: #basicType!accessing!private! !
!ScintillaMargin categoriesFor: #basicType:!accessing!private! !
!ScintillaMargin categoriesFor: #basicWidth!accessing!private! !
!ScintillaMargin categoriesFor: #basicWidth:!accessing!private! !
!ScintillaMargin categoriesFor: #cursorType!accessing!public! !
!ScintillaMargin categoriesFor: #cursorType:!accessing!public! !
!ScintillaMargin categoriesFor: #isFolders!accessing!public! !
!ScintillaMargin categoriesFor: #isFolders:!accessing!public! !
!ScintillaMargin categoriesFor: #isSensitive!public!testing! !
!ScintillaMargin categoriesFor: #isSensitive:!accessing!public! !
!ScintillaMargin categoriesFor: #mask!accessing!public! !
!ScintillaMargin categoriesFor: #mask:!accessing!public! !
!ScintillaMargin categoriesFor: #type!accessing!public! !
!ScintillaMargin categoriesFor: #type:!accessing!public! !
!ScintillaMargin categoriesFor: #width!accessing!public! !
!ScintillaMargin categoriesFor: #width:!accessing!public! !

!ScintillaMargin class methodsFor!

initialize
	"
		self initialize
	"

	propertyMap := (IdentityDictionary new)
				at: #isSensitive
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #basicIsSensitive
							defaultValue: 0
							setMessage: SCI_SETMARGINSENSITIVEN
							setSelector: #basicIsSensitive:
							getMessage: SCI_GETMARGINSENSITIVEN);
				at: #mask
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #mask
							defaultValue: 0
							setMessage: SCI_SETMARGINMASKN
							setSelector: #mask:
							getMessage: SCI_GETMARGINMASKN);
				at: #type
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #basicType
							defaultValue: SC_MARGIN_SYMBOL
							setMessage: SCI_SETMARGINTYPEN
							setSelector: #basicType:
							getMessage: SCI_GETMARGINTYPEN);
				at: #width
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #basicWidth
							defaultValue: nil "varies by default margin"
							setMessage: SCI_SETMARGINWIDTHN
							setSelector: #basicWidth:
							getMessage: SCI_GETMARGINWIDTHN);
				at: #cursorType
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #basicCursorType
							defaultValue: SC_CURSORREVERSEARROW
							setMessage: SCI_SETMARGINCURSORN
							setSelector: #basicCursorType:
							getMessage: SCI_GETMARGINCURSORN);
				at: #backcolor
					put: (QueryableScintillaPropertyDescriptor
							getSelector: #basicBackcolor
							defaultValue: 0
							setMessage: SCI_SETMARGINBACKN
							setSelector: #basicBackcolor:
							getMessage: SCI_GETMARGINBACKN);
				shrink;
				isImmutable: true;
				yourself.
	MarginTypes := #(#symbol #lineNumber #symbolBackground #symbolForeground #text #rightJustifiedText #color).
	CursorTypes := (LookupTable new)
				at: SC_CURSORARROW put: #arrow;
				at: SC_CURSORREVERSEARROW put: #reverseArrow;
				at: SC_CURSORWAIT put: #wait;
				at: SC_CURSORNORMAL put: #normal;
				shrink;
				isImmutable: true;
				yourself!

stbConvertFrom: anSTBClassFormat 
	^
	[:vars | 
	| instance |
	instance := self new.
	vars keysAndValuesDo: [:eachKey :eachValue | instance instVarAt: eachKey put: eachValue].
	instance]!

stbVersion
	^2! !
!ScintillaMargin class categoriesFor: #initialize!initializing!public! !
!ScintillaMargin class categoriesFor: #stbConvertFrom:!binary filing!private! !
!ScintillaMargin class categoriesFor: #stbVersion!binary filing!public! !

