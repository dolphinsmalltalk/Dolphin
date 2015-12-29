"Filed out from Dolphin Smalltalk X6.2"!

MultilineTextEdit subclass: #ScintillaView
	instanceVariableNames: 'this currentTextStyles styleIdMap styler markerDefinitions markers wordChars styleMask modificationEventMask autoCStops autoCFillups whitespaceBackcolor whitespaceForecolor selectionBackcolor selectionForecolor indicators callTipTabWidth _unused34 callTipHighlightColor braceChars whitespaces scFlags allTextStyles foldMarginColor foldMarginHiColor foldMarkerStyle foldFlags extraStyleBits keyBindings indicatorStyles secondarySelectionForecolor secondarySelectionBackcolor annotationStyles _unused50'
	classVariableNames: 'AnnotationModes AnnotationStylesOffset BackgroundDwellEvents BraceHilightingMask CaretStyles CodePages DefaultCallTipTabWidth DefaultKeyBindings DefaultTextStyles FoldingMask FoldMarkerStyles IndentationGuideStyles Lexers MarginStylesOffset ScnMap Whitespaces WrapIndentModes'
	poolDictionaries: 'ScintillaConstants Win32Constants'
	classInstanceVariableNames: ''!
ScintillaView guid: (GUID fromString: '{47A3310B-B7E4-4AA9-B6E6-640AD9FE7A3A}')!
ScintillaView comment: 'ScintillaView is a <valueView> class that wraps the "Scintilla" programmers'' edit control. 

Scintilla is a very powerful control with an extensive range of features. It is inevitably somewhat complex, and you are urged to read the documentation at http://www.scintilla.org/ScintillaDoc.html if you want to use this control in your own applications. In order to expose the full capabilities of Scintilla, this class and its supporting classes are also somewhat complex, but as far as reasonably possible this complexity is hidden from common use cases.

This class provides at least a basic interface to all of Scintilla''s extensive functionality; almost every SCI_XXX message listed in the documentation has a corresponding wrapper method in this class. The wrapper methods have been auto-generated from Scintilla''s interface definition file (Scintilla.iface), and are either of the form #sciXXX:etc, or have had a more readable symbol allocated. These can all be found in the ''scintilla interface'' method category. Likewise each of the SCN_XXX notification messages has a corresponding #scnXXX event handler that is (or can be) used to hook the event. These can all be found in the ''event handling-scintilla'' method category. In addition ScintillaView implements higher-level functionality to allow it to be used as a drop-in replacement for a <MultilineTextEdit>, and which also simplifies the use of most of its additional capabilities. 

ScintillaView provides high-level object-oriented wrappings for the following Scintilla features:
	Text retrieval and modification	(though not get/set of styled text, and based around the standard <textView> protocol)
	Searching and replacing 		(TextEdit implementation is inherited, but does not include RegExp replace)
	Overtype
	Cut, copy and paste			(implements standard MVP protocols)
	Undo and Redo
	Mouse capture				(supported as #willCaptureMouse aspect, but not really required - use MVP''s MouseTracker instead)
	Line endings
	Styling					(an extensive Smalltalk framework is provided - stylers can be implemented in Smalltalk e.g. ScintillaSmalltalkStyler based on SmalltalkScanner)
	Style definition				(full control is possible by altering aspects of a collection of ScintillaTextStyle objects, UI editors are provided for this too).
	Caret, selection, 
		and hotspot styles		(not hotspot styles)
	Margins
	Other Settings				(mostly)
	Brace highlighting
	Tab and Indentation Guides
	Markers
	Indicators					Named "modern" indicators are now supported. Indicator values are unused at present and probably not needed. The old style-byte indicators are deprecated.
	Autocompletion				(note that the container needs to invoke auto-completion when appropriate)
	User lists
	Keyboard commands			(some are bound to existing commands)
	Key bindings
	Line wrapping				(currently no public interface for visual line wrap flags)
	Zooming
	Long lines
	Direct access				(i.e. direct calls to the control, rather than through the message queue, faster but not thread safe)
	Folding					(requires lexer support)
	Annotations
	Multiple-selection
	
Features of Scintilla that are not currently exposed at any level higher than the basic message interface include:
	Error handling				(not currently used by Scintilla itself)
	Cursor					(superfluous given MVP''s cursor management framework)
	Call tips
	Popup edit menu			(no special means to disable control context menus is needed in MVP)
	Macro-recording
	Printing					(partial support for some properties is provided)
	Multiple views				(alternatives exist using the MVP framework, though this could be useful in some applications)
	Margin text
	
N.B. Scintilla is an excellent editor control, but does not do much parameter validation. Thus if using the low-level API be careful not to pass in invalid parameters as these may cause unexpected behaviour. For example if length passed to SCI_SETSTYLING is -1, then the control goes into a loop (at the time of writing).

Instance Variables:
	this				<ExternalHandle>. C++ ''this'' pointer for direct function invocation.
	currentTextStyles	<IdentityDictionary> mapping <Symbol> to <ScintillaTextStyle> for the current lexer.
	styleIdMap		<IdentityDictionary> 
	styler			<ScintillaStyler>. Responsible for dynamically ''colouring'' text in the view.
	markerDefinitions	<IdentityDictionary> mapping <Symbol> to <ScintillaMarkerDefinition>.
	markers			<IdentitySet> of <ScintillaMarker>s. All markers currently set in the view.
	wordChars			<String> of characters considered to be word delimiters.
	maxStyle			<SmallInteger> maximum style index. Depends on number of bits used for text styles. Default 31, maximum 127.
	modificationEventMask <integer> bit mask controlling SCN_MODIFIED notifications (see Scintilla docs).
	autoCStops		<String> or nil. The characters which cancel an auto-completion list when typed..
	autoCFillups		<String> or nil. The characters which accept the selection in an auto-completion list when typed.
	whitespaceBackcolor	<Color> or nil. The colour of the background drawn behind whitespace.
	whitespaceForecolor	<Color> or nil. The colour of the glyphs used to display visible whitespace.
	selectionBackcolor 	<Color>. The background colour used to highlight the selection (default is grey).
	selectionForecolor	<Color> or nil. The foreground colour used to highlight the selection.
	indicators			<Array> of <ScintillaIndicator>s
	callTipBackcolor	<Color> or nil. The background colour for calltips.
	callTipForecolor		<Color> or nil. The foreground colour for calltips.
	callTipHighlightColor	<Color> or nil. The hilight colour for calltips.
	braceChars		<String> of characters considered to be brace characters, e.g. ''()[]{}''.
	whitespaceChars	<String> of characters considered to be whitespace.
	scFlags			<integer>. Various flags.
	allTextStyles		<IdentityDictionary> mapping <Symbol>ic lexer name to dictionary of text styles for that lexer.
	foldMarginColor 		<Color> or nil. The fold margin background colour (if visible)
	foldMarginHiColor 	<Color> or nil. The fold margin hilight colour (if visible).
	foldMarkerStyle		<Symbol>. Name of the fold (outlining) marker style employed in the fold margin.
	foldFlags			<integer>. Lexer fold flags.
	extraStyleBits		<integer>
	keyBindings		<IdentityDictionary> mapping Dolphin accelerator key codes to Scintilla messages. nil by default (default bindings are used).
	indicatorStyles		<IdentityDictionary> mapping <Symbol> or <integer> indicator style names to <ScintillaIndicatorStyle>s.

Class Variables:
	BackgroundDwellEvents	<integer>
	BraceHighlightMask	<integer> bit mask for accessing brace highlighting flag.
	CodePages			<IdentityDictionary> mapping <integer> to <Symbol>
	Commands		<IdentityDictionary> mapping Dolphin accelerator key codes to command symbols.
	DefaultTextStyles	<IdentityDictionary> of default text style maps by lexer name.
	FoldingMask		<integer> bit mask for access the folding (outlining) enabled flag.
	FoldMarkerStyles	<Array> of <Symbol>s being the names of the standard fold marker styles.
	KeyBindings		<IdentityDictionary> mapping Dolphin accelerator key codes to Scintilla messages for the default key bindings.
	Lexers			<Array> of <Symbol>. Lexer language names.
	ScnMap			<Array> of <Symbol>s being the selectors of the notification event handlers.
	Whitespaces		<String>
	IndentationGuideStyles	<Array> of <Symbol>s being the names of the indentation guide styles.
'!
!ScintillaView categoriesForClass!MVP-Views! !
!ScintillaView methodsFor!

acceptAutoCompletion
	"User has selected an item so remove the list and insert the selection."

	self 
		sendMessage: SCI_AUTOCCOMPLETE
		wParam: 0
		lParam: 0!

activeHotspotBackcolor
	"Get the back colour for active hotspots."

	^RGB fromInteger: (self 
				sendMessage: SCI_GETHOTSPOTACTIVEBACK
				wParam: 0
				lParam: 0)!

activeHotspotBackcolor: aColorOrNil 
	"Set the back colour for active hotspots."

	aColorOrNil 
		ifNil: [self sciSetHotspotActiveBack: false back: 0]
		ifNotNil: [self sciSetHotspotActiveBack: true back: aColorOrNil asRGB]!

activeHotspotForecolor
	"Get the fore colour for active hotspots."

	^RGB fromInteger: (self 
				sendMessage: SCI_GETHOTSPOTACTIVEFORE
				wParam: 0
				lParam: 0)!

activeHotspotForecolor: aColorOrNil 
	"Set the foreground colour for active hotspots."

	aColorOrNil 
		ifNil: [self sciSetHotspotActiveFore: false fore: 0]
		ifNotNil: [self sciSetHotspotActiveFore: true fore: aColorOrNil asRGB]!

addAnnotation: aScintillaAnnotation 
	"Append the specified <ScintillaAnnotation> to the current annotations (if any) for the line
	with which is is associated."

	| line newText newStyles |
	line := aScintillaAnnotation line - 1.
	(self getRawAnnotation: line) 
		ifNil: 
			["No existing annotations on the line"
			newText := String writeStream.
			newStyles := ByteArray writeStream]
		ifNotNil: 
			[:existing | 
			newText := WriteStream with: existing text.
			"Add the LF separator"
			newText nextPut: Character lf.
			newStyles := WriteStream with: existing styles.
			"Add a style byte for the LF separator"
			newStyles nextPut: 0].
	newText nextPutAll: aScintillaAnnotation text.
	self printAnnotationStyleBytes: aScintillaAnnotation on: newStyles.
	self 
		basicAnnotateLine: line
		withText: newText contents
		inStyles: newStyles contents.
	self invalidate!

addKeyBinding: aScintillaKeyBinding 
	| bindings |
	bindings := self keyBindings.
	bindings at: aScintillaKeyBinding acceleratorKey put: aScintillaKeyBinding.
	self sciAssignCmdKey: aScintillaKeyBinding scintillaKeyCode msg: aScintillaKeyBinding message.
	keyBindings := bindings!

addMarker: aScintillaMarker 
	"Add the specified <ScintillaMarker> to this view. Depending on the marker and margin
	configuration this may cause a symbol to appear in a margin or affect the visual style (e.g.
	background colour) of the marked line."

	aScintillaMarker addToView: self.
	^markers add: aScintillaMarker!

addMarkerType: aSymbol at: anInteger 
	"Add the named marker to the symbols margin at the specified one-based line index. If the named
	marker is not configured for this view, then use the default marker, initially configured as
	a black-on-white circle. Answer the new <ScintillaMarker>."

	"Note that the name is typically one that is meaningful in the application domain rather
	than the name of a shape. For example if implementing a debugger one might have markers
	named #breakpoint, #currentLine, etc. The styles of these markers (and therefore the shape
	actually used to display the marker) can then be configured by altering the marker
	definition. "

	| markerType |
	markerType := markerDefinitions at: aSymbol
				ifAbsent: 
					[(ScintillaMarkerDefinition new)
						name: aSymbol;
						yourself].
	^self addMarker: (markerType newForLine: anInteger)!

anchorPosition
	"Answer the position of the selection anchor."

	^self sciGetAnchor + 1!

anchorPosition: anInteger 
	"Move the selection anchor to be at the specified character position (which is one based,
	i.e. 1 is home)."

	^self sciSetAnchor: anInteger - 1!

annotateLine: anInteger withAll: aCollectionOfScintillaAnnotation 
	"Apply the <collection> of <ScintillaAnnotation> as the annotations for the line identified
	by the one-based <integer> index, anInteger. Note that the line number associated with the
	<ScintillaAnnotations> are ignored, and all annotations are associated with specified line."

	| text styleBytes |
	text := String writeStream.
	styleBytes := ByteArray writeStream.
	aCollectionOfScintillaAnnotation do: 
			[:each | 
			text nextPutAll: each text.
			self printAnnotationStyleBytes: each on: styleBytes]
		separatedBy: 
			[text nextPut: Character lf.
			styleBytes nextPut: 0].
	self 
		basicAnnotateLine: anInteger
		withText: text contents
		inStyles: styleBytes contents.
	self invalidate!

annotationMode
	^AnnotationModes at: self sciAnnotationGetVisible + 1 ifAbsent: [#hidden]!

annotationMode: aSymbol 
	self sciAnnotationSetVisible: (AnnotationModes keyAtValue: aSymbol) - 1!

annotations
	"Answer a collection of all the individual annotations currently set in the receiver. There
	could be several per line, the line indices are one-based, and the styles are described by
	symbolic names, one annotation style name per character."

	| annotations raw |
	self ensureHasAnnotationStyles.
	raw := self getRawAnnotations.
	annotations := OrderedCollection new: raw.
	raw do: [:each | annotations addAll: (self annotationsFromRawAnnotation: each)].
	^annotations!

annotations: aCollectionOfScintillaAnnotation 
	"Set the annotations associated with lines of text in the receiver to the <Collection> of
	<ScintillaAnnotations>s argument."

	self setRawAnnotations: (self buildRawAnnotations: aCollectionOfScintillaAnnotation)!

annotationsForLine: anInteger 
	"Answer a <sequencedReadableCollection> of <ScintillaAnnotation>, being each individual
	annotation currently set in the receiver for the specified line. There could be several, the
	line indices are one-based, and the styles are described by symbolic names, one annotation
	style name per character. The annotations are in the same order as they appear visually."

	^(self getRawAnnotation: anInteger - 1) 
		ifNil: [#()]
		ifNotNil: 
			[:raw | 
			self ensureHasAnnotationStyles.
			self annotationsFromRawAnnotation: raw]!

annotationsFromRawAnnotation: aScintillaAnnotation 
	| line text linesOfText count |
	line := aScintillaAnnotation line + 1.
	text := aScintillaAnnotation text.
	linesOfText := text subStrings: Character lf.
	count := linesOfText size.
	^count == 1 
		ifTrue: 
			[Array with: (ScintillaAnnotation 
						line: line
						text: text
						styles: (self annotationStylesFromStyleBytes: aScintillaAnnotation styles))]
		ifFalse: 
			[| start annotations |
			annotations := Array new: count.
			start := 1.
			1 to: count
				do: 
					[:i | 
					| eachLine lineLength |
					eachLine := linesOfText at: i.
					lineLength := eachLine size.
					annotations at: i
						put: (ScintillaAnnotation 
								line: line
								text: eachLine
								styles: (self annotationStylesFromStyleBytes: (aScintillaAnnotation styles copyFrom: start
												to: start + lineLength - 1))).
					"Note we mus skip the style byte for the LF separator"
					start := start + lineLength + 1].
			annotations]!

annotationStyles
	"Answer the <collection> of <ScintillaTextStyle>s currently configured for annotations.
	This collection should be considered as immutable - any changes to its elements, or the
	addition/removal/replacement of elements, will not result in the view being updated. To
	change annotation styles the entire collection must be replaced."

	self ensureHasAnnotationStyles.
	^(annotationStyles values asSortedCollection: ScintillaAttribute sortByIdBlock) asArray!

annotationStyles: aCollection 
	"Set the collection of <ScintillaTextStyle>s configured for annotations in the receiver to
	be those specified in the argument. This may involve removing old style definitions, and
	adding new ones."

	"Implementation Note: See #textStyles: for more information about the wrapping of Scintilla
	text style attributes in Dolphin."

	annotationStyles := self buildAnnotationStyles: aCollection.
	self updateTextStyles!

annotationStylesFromStyleBytes: aByteArray 
	| runs values styleLookup |
	runs := Array writeStream.
	values := Array writeStream.
	styleLookup := IdentityDictionary new: annotationStyles size.
	annotationStyles do: [:each | styleLookup at: each id put: each name].
	aByteArray runsAndValuesDo: 
			[:run :value | 
			runs nextPut: run.
			values nextPut: (styleLookup at: value)].
	^RunArray runs: runs contents values: values contents!

annotationStylesOffset
	"Get the start of the range of style numbers used for annotations"

	^self 
		sendMessage: SCI_ANNOTATIONGETSTYLEOFFSET
		wParam: 0
		lParam: 0!

annotationStylesOffset: styleInteger 
	"Get the start of the range of style numbers used for annotations"

	self 
		sendMessage: SCI_ANNOTATIONSETSTYLEOFFSET
		wParam: styleInteger
		lParam: 0!

appendText: aString 
	"Append the <String> argument to the end of the document without changing the selection."

	self modifyText: [self sciAppendText: aString size text: aString]!

applyAttributes: aSequenceableCollection 
	aSequenceableCollection keysAndValuesDo: [:i :each | each applyToView: self at: i - 1]!

applyStyle: aSymbol toNext: anInteger 
	"Apply the named style to the next anInteger characters (from the current styling position)
	to the style named by the <Symbol> argument, advancing the current styling position
	appropriately. If the style name is not recognised, then the default style is used."

	anInteger > 0 
		ifTrue: [self styleNext: anInteger mask: (currentTextStyles at: aSymbol ifAbsent: [0]) asParameter]!

applyStyleId: idInteger toNext: countInteger 
	"Apply the style with the <integer> id, idInteger, to the next countInteger characters (from
	the current styling position), advancing the current styling position appropriately."

	countInteger > 0 ifTrue: [self styleNext: countInteger mask: idInteger]!

applyTextStylesForLexer: aSymbol 
	aSymbol isNil 
		ifTrue: 
			[self
				setCurrentTextStyles: self class defaultTextStyles;
				removeAllStyling]
		ifFalse: 
			[self
				setCurrentTextStyles: (allTextStyles at: aSymbol ifAbsent: [self defaultTextStylesFor: aSymbol]);
				invalidateStyling]!

areAdditionalCaretsVisible
	"Whether additional carets are visible"

	^(self 
		sendMessage: SCI_GETADDITIONALCARETSVISIBLE
		wParam: 0
		lParam: 0) asBoolean!

areAdditionalCaretsVisible: additionalCaretsBlinkBoolean 
	"Set whether additional carets are visible"

	self 
		sendMessage: SCI_SETADDITIONALCARETSVISIBLE
		wParam: additionalCaretsBlinkBoolean asParameter
		lParam: 0!

areHotspotsSingleLine
	"Get the HotspotSingleLine property"

	^(self 
		sendMessage: SCI_GETHOTSPOTSINGLELINE
		wParam: 0
		lParam: 0) asBoolean!

areHotspotsSingleLine: singleLineBoolean 
	"Limit hotspots to single line so hotspots on two lines don't merge."

	self 
		sendMessage: SCI_SETHOTSPOTSINGLELINE
		wParam: singleLineBoolean asParameter
		lParam: 0!

autoCompletionAcceptChars
	"Answer a <String> of characters that, when typed, will accept the current selection in an
	auto-completion list."

	^autoCFillups ifNil: ['']!

autoCompletionAcceptChars: aString 
	"Set the <String> of characters that, when typed, will cause the auto-completion list to
	choose the currently selected item."

	autoCFillups := aString isEmpty ifFalse: [aString].
	self sciAutoCSetFillUps: aString!

autoCompletionCancelChars
	"Answer the <String> of character that, when typed, will cancel an auto-completion list."

	^autoCStops ifNil: ['']!

autoCompletionCancelChars: aString 
	"Set the <String> of characters that, when typed, will cancel an auto-completion list."

	autoCStops := aString isEmpty ifFalse: [aString].
	self sciAutoCStops: aString!

autoCompletionImageIdSeparator
	"Answer the <Character> used as the separator between entry text and image identifiers in an
	auto-completion list <String>."

	^Character value: self sciAutoCGetTypeSeparator !

autoCompletionImageIdSeparator: aCharacter 
	"Set the <Character> used as the separator between entry text and image identifiers in an
	auto-completion list <String>. The default is '?' but this should be be changed if entries
	may contain '?'."

	self sciAutoCSetTypeSeparator: aCharacter asInteger!

autoCompletionListPosition
	"Retrieve the position of the caret when the auto-completion list was displayed."

	^self sciAutoCPosStart + 1!

autoCompletionSeparator
	"Answer the <Character> used as the separator between entries in an auto-completion list <String>."

	^Character value: self sciAutoCGetSeparator!

autoCompletionSeparator: aCharacter 
	"Set the <Character> used as the separator between entries in an auto-completion list
	string. The default is a space but this should be be changed if entries may contain such."

	self sciAutoCSetSeparator: aCharacter asInteger!

backcolorChanged
	"Private - Note we don't supersend, because we don't need to invalidate on changing colours
	- Scintilla takes care of that"

	self updateTextStyles!

backspace
	"Delete the selection or if no selection, the character before the caret."

	self 
		sendMessage: SCI_DELETEBACK
		wParam: 0
		lParam: 0!

backspaceNoLine
	"Delete the selection or if no selection, the character before the caret. Will not delete
	the character before at the start of a line."

	self 
		sendMessage: SCI_DELETEBACKNOTLINE
		wParam: 0
		lParam: 0!

backspaceUnindents
	"Does a backspace pressed when caret is within indentation unindent?"

	^(self 
		sendMessage: SCI_GETBACKSPACEUNINDENTS
		wParam: 0
		lParam: 0) asBoolean!

backspaceUnindents: bsUnIndentsBoolean 
	"Sets whether a backspace pressed when caret is within indentation unindents."

	self 
		sendMessage: SCI_SETBACKSPACEUNINDENTS
		wParam: bsUnIndentsBoolean asParameter
		lParam: 0!

basicAnnotateLine: anInteger withText: aString inStyles: aByteArray 
	self
		sciAnnotationSetText: anInteger text: aString;
		sciAnnotationSetStyles: anInteger styles: aByteArray!

basicClearContainerIndicators
	"Private - Clear all the containers indicators (those with Id's starting with
	INDIC_CONTAINER) from the receiver Indicators reserved for use by lexers (those with id's in
	the range 0..INDIC_CONTAINER-1) are unaffected."

	| length |
	length := self textLength.
	INDIC_CONTAINER to: INDIC_MAX
		do: 
			[:each | 
			self currentIndicatorId: each.
			self sciIndicatorClearRange: 0 clearLength: length]!

basicClearSelection
	"Clear the selection."

	self 
		sendMessage: SCI_CLEAR
		wParam: 0
		lParam: 0!

basicLineFromPosition: posInteger 
	"Retrieve the line containing a position."

	^self 
		sendMessage: SCI_LINEFROMPOSITION
		wParam: posInteger
		lParam: 0!

basicPositionAtLine: lineInteger 
	"Retrieve the position at the start of a line."

	^self 
		sendMessage: SCI_POSITIONFROMLINE
		wParam: lineInteger
		lParam: 0!

basicRemoveAllAnnotations
	"Clear the annotations from all lines"

	self 
		sendMessage: SCI_ANNOTATIONCLEARALL
		wParam: 0
		lParam: 0!

basicSelectAll
	"Select all the text in the document."

	self 
		sendMessage: SCI_SELECTALL
		wParam: 0
		lParam: 0!

basicSelectionRange
	"Private - Answer an <interval> identifying the selected range of text as reported by the underlying 
	Windows control. Note that this range includes the starting character, but the end of the range
	is the first unselected character. Note further that this characteristic means that the range should 
	NEVER be empty."

	^self sciGetSelectionStart to: self sciGetSelectionEnd!

basicSelectionStart: startInteger end: endInteger 
	"Select a range of text."

	self 
		sendMessage: SCI_SETSEL
		wParam: startInteger
		lParam: endInteger!

basicUndo
	"Undo one action in the undo history."

	self 
		sendMessage: SCI_UNDO
		wParam: 0
		lParam: 0!

beginUndoGroup
	"Start a sequence of actions that is undone and redone as a unit. May be nested."

	self 
		sendMessage: SCI_BEGINUNDOACTION
		wParam: 0
		lParam: 0!

boundingRectangleOfTextRange: anIntervalOfInteger 
	| height topLeft line style width start |
	start := anIntervalOfInteger start.
	topLeft := self positionOfChar: start.
	line := self lineFromPosition:  start.
	self assert: [(self lineFromPosition: anIntervalOfInteger stop) = line].
	height := self lineHeight: line.
	style := self styleAt:  start.
	width := self widthOfText: (self plainTextRange: anIntervalOfInteger) inStyle: style name.
	^topLeft extent: width @ height!

braceChars
	"Answer a <LookupTable> the keys of which are <Symbol>ic style names, and the associated
	values are the <String>s containing the the set of <Character>s that should be considered as
	brace characters for that style."

	^braceChars ifNil: [self defaultBraceChars]!

braceChars: aLookupTable 
	"Set the map between <Symbol>ic style names and the brace characters in that style to be the
	<LookupTable> argument. Note that Scintilla recognises a hard-coded set of brace characters,
	it is not possible to use other characters for any style, but the set can be reduced on a
	per-style basis."

	aLookupTable do: 
			[:each | 
			| diffs |
			diffs := each difference: '[]{}()<>'.
			diffs notEmpty ifTrue: [self error: 'invalid brace characters: ' , diffs]].
	braceChars := aLookupTable!

braceHighlight
	| len pos found1 found2 |
	len := self textLength.
	len < 1 ifTrue: [^self].
	pos := self caretPosition.
	found1 := 0.
	(pos > 1 and: [self isBraceAt: pos - 1]) ifTrue: [found1 := pos - 1].
	(found1 == 0 and: [pos <= len and: [self isBraceAt: pos]]) ifTrue: [found1 := pos].
	(found1 == 0 or: [(found2 := self findMatchingBrace: found1) == 0]) 
		ifTrue: [self highlightMismatchedBrace: found1]
		ifFalse: [self highlightBracesAt: found1 and: found2]!

buildAnnotationStyles: aCollection 
	| newStylesByName allocatedStyles offset availableStyles count |
	count := aCollection size.
	allocatedStyles := OrderedCollection new: count.
	offset := self annotationStylesOffset.
	aCollection do: 
			[:each | 
			each basicId 
				ifNotNil: 
					[:id | 
					self assert: [id > offset].
					allocatedStyles add: id]].
	"Note that we always leave the first allocation style with the same setup as the normal text style style"
	availableStyles := ((offset + 1 to: offset + self maxStyle - 1) difference: allocatedStyles) 
				readStream.
	newStylesByName := IdentityDictionary new: count.
	aCollection do: 
			[:each | 
			each basicId isNil ifTrue: [each basicId: availableStyles next].
			newStylesByName at: each name put: each].
	^newStylesByName!

buildDefaultStyle
	| defaultStyle |
	defaultStyle := (currentTextStyles at: #normal) copy.
	defaultStyle mergeFont: self actualFont.
	defaultStyle forecolor ifNil: [defaultStyle forecolor: (self forecolor ifNil: [Color windowText])].
	defaultStyle backcolor ifNil: [defaultStyle backcolor: self actualBackcolor].
	defaultStyle case ifNil: [defaultStyle case: SC_CASE_MIXED].
	defaultStyle characterSet ifNil: [defaultStyle characterSet: SC_CHARSET_DEFAULT].
	^defaultStyle!

buildItemList: aCollection 
	| itemList sep typesep |
	itemList := String writeStream.
	sep := self autoCompletionSeparator.
	typesep := self autoCompletionImageIdSeparator.
	aCollection do: 
			[:each | 
			itemList
				display: each;
				"nextPut: typesep;
				display: each icon imageIndex;"
				nextPut: sep].
	^itemList
		pop;
		contents!

buildRawAnnotations: aCollectionOfScintillaAnnotations 
	"Private - Convert the specified <collection> of <ScintillaAnnotation>s in public API format
	(i.e. one annotation object per line, one-based line indices, and symbolic style names), to
	the raw format required by the private API fo the underlying control (i.e. line numbers are
	zero-based, all lines of text and styles are concatenated, styles are represented
	numerically rather than symbolically."

	| styleBytes currentLine firstInLine rawAnnotations text |
	aCollectionOfScintillaAnnotations isEmpty ifTrue: [^#()].
	currentLine := 0.
	"We need a pair of stream buffers to build the annotation text and styles for a line"
	text := String writeStream.
	styleBytes := ByteArray writeStream.
	firstInLine := true.
	rawAnnotations := OrderedCollection new.
	"Use a stable sort algorithm to preserve any existing ordering"
	(aCollectionOfScintillaAnnotations 
		asSortedCollectionUsing: (MergesortAlgorithm sortBlock: [:a :b | a line < b line])) do: 
				[:eachAnnotation | 
				eachAnnotation line ~= currentLine 
					ifTrue: 
						["Line has changed, so convert any previously
						 buffered annotation data and prepare for the next
						 line"
						currentLine == 0 
							ifFalse: 
								[rawAnnotations add: (ScintillaAnnotation 
											line: currentLine - 1
											text: text contents
											styles: styleBytes contents)].
						currentLine := eachAnnotation line.
						text reset.
						styleBytes reset.
						firstInLine := true].
				firstInLine 
					ifTrue: [firstInLine := false]
					ifFalse: 
						["Each line of annotations is separated by a single line feed character"
						text nextPut: Character lf.
						"We must provide a style byte for the linefeed as well"
						styleBytes nextPut: 0].
				text nextPutAll: eachAnnotation text.
				self printAnnotationStyleBytes: eachAnnotation on: styleBytes].
	"Add the annotations for the last annotated line, as these remain in the buffers when the
	loop terminates"
	rawAnnotations add: (ScintillaAnnotation 
				line: currentLine - 1
				text: text contents
				styles: styleBytes contents).
	^rawAnnotations!

buildViewStyle
	^(ScintillaTextStyle new)
		font: self actualFont;
		backcolor: (self backcolor ifNil: [Color window]);
		forecolor: (self forecolor ifNil: [Color windowText]);
		yourself!

callTipBackcolor
	"Answer the background <Color> of the call tips box. By default this is white."

	^self callTipStyle backcolor!

callTipBackcolor: aColorOrNil 
	"Set the background <Color> of the call tips box. If the argument is nil then the default
	colour (white) is set."

	self callTipStyle backcolor: (aColorOrNil isNil 
				ifTrue: 
					[self sciCallTipSetBack: nil.
					Color white]
				ifFalse: 
					[self sciCallTipSetBack: aColorOrNil asRGB.
					aColorOrNil])!

callTipForecolor
	"Answer the foreground <Color> of the unhighlighted text in call tips. By default this is
	dark grey."

	^self callTipStyle forecolor!

callTipForecolor: aColorOrNil 
	"Set the foreground <Color> of the unhighlighted text in call tips. If the argument is nil
	then the default colour (dark grey) is set."

	self callTipStyle backcolor: (aColorOrNil isNil 
				ifTrue: 
					[self sciCallTipSetFore: nil.
					Color darkGray]
				ifFalse: 
					[self sciCallTipSetFore: aColorOrNil asRGB.
					aColorOrNil])!

callTipHighlightColor
	"Answer the foreground <Color> for the highlighted part of the call tip. By default this is
	dark blue."

	^callTipHighlightColor ifNil: [##(Color darkBlue)]!

callTipHighlightColor: aColorOrNil 
	"Set the foreground <Color> for the highlighted part of the call tip. If the argument is nil
	then the default colour (dark blue) is set."

	(callTipHighlightColor := aColorOrNil) isNil 
		ifTrue: [self sciCallTipSetForeHlt: nil]
		ifFalse: [self setCallTipHighlightColor]!

callTipPosition
	"Answer the <integer> character position of the caret immediately before the call tip was
	displayed."

	^self sciCallTipPosStart + 1!

callTipStyle
	^currentTextStyles at: #callTip
		ifAbsentPut: [styleIdMap at: STYLE_CALLTIP + 1 put: self class defaultCallTipStyle]!

callTipTabWidth
	^callTipTabWidth!

callTipTabWidth: anInteger 
	callTipTabWidth := anInteger.
	self setCallTipTabWidth!

cancelAutoCompletion
	"Remove the auto-completion list from the screen."

	self 
		sendMessage: SCI_AUTOCCANCEL
		wParam: 0
		lParam: 0!

cancelCallTip
	"Remove the call tip from the screen."

	self 
		sendMessage: SCI_CALLTIPCANCEL
		wParam: 0
		lParam: 0!

cancelModes
	"Cancel any modes such as call tip or auto-completion list display."

	self 
		sendMessage: SCI_CANCEL
		wParam: 0
		lParam: 0!

canHScroll
	"Is the horizontal scroll bar visible?"

	^(self 
		sendMessage: SCI_GETHSCROLLBAR
		wParam: 0
		lParam: 0) asBoolean!

canHScroll: aBoolean 
	"Sets the receiver into horizontal scrolling mode the <Boolean> argument is true."

	self sciSetHScrollBar: aBoolean.
	self invalidateCalculatedExtent!

canonicalizeLineEndings: aSymbol 
	"Replace all non-standard line-endings in the text so that all are as named by the <Symbol>
	argument, one of #crlf, #cr, or #lf."

	self sciConvertEOLs: (self class lineEndings indexOf: aSymbol) - 1!

canPaste
	"Answer whether the window can paste from the current contents of the clipboard."

	^self sciCanPaste or: [super canPaste]!

canRedo
	"Are there any redoable actions in the undo history?"

	^(self 
		sendMessage: SCI_CANREDO
		wParam: 0
		lParam: 0) asBoolean!

canScrollPastEnd
	"Answer whether the window can be scrolled up to one-page past the end of the text. If false
	then the window can only be scrolled to the last line."

	^self sciGetEndAtLastLine asBoolean!

canScrollPastEnd: endAtLastLineBoolean 
	"Sets the scroll range so that maximum scroll position has the last line at the bottom of
	the view (default). Setting this to false allows scrolling one page below the last line."

	self 
		sendMessage: SCI_SETENDATLASTLINE
		wParam: endAtLastLineBoolean asParameter
		lParam: 0!

canUndo
	"Are there any undoable actions in the undo history?"

	^(self 
		sendMessage: SCI_CANUNDO
		wParam: 0
		lParam: 0) asBoolean!

canVScroll
	"Is the vertical scroll bar visible?"

	^(self 
		sendMessage: SCI_GETVSCROLLBAR
		wParam: 0
		lParam: 0) asBoolean!

caretForecolor
	"Get the foreground colour of the caret."

	^RGB fromInteger: (self 
				sendMessage: SCI_GETCARETFORE
				wParam: 0
				lParam: 0)!

caretForecolor: foreRGB 
	"Set the foreground colour of the caret."

	self sciSetCaretFore: (foreRGB ifNil: [Color black]) asRGB!

caretPeriod
	"Get the time in milliseconds that the caret is on and off."

	^self 
		sendMessage: SCI_GETCARETPERIOD
		wParam: 0
		lParam: 0!

caretPeriod: periodMillisecondsInteger 
	"Get the time in milliseconds that the caret is on and off. 0 = steady on."

	self 
		sendMessage: SCI_SETCARETPERIOD
		wParam: periodMillisecondsInteger
		lParam: 0!

caretPosition
	"Answer the insertion cursor position, as the number of characters from the start of the
	receivers text."

	^self sciGetCurrentPos + 1!

caretPosition: anInteger
	"Sets the insertion cursor to be at the specified character position (which is one based,
	i.e. caretPosition 1 is home)."

	"Implementation Note: SCI_SETCURRENTPOS moves the current position, but not the anchor.
	We want this to reset the selection to empty, so use superclass implementation."

	"self sendMessage: SCI_SETCURRENTPOS wParam: anInteger - 1"

	super caretPosition: anInteger!

caretScreenCoordinates
	^self mapPoint: (self positionOfChar: self caretPosition) to: View desktop!

caretStyle
	"Answer the style of caret displayed in the receiver; one of #invisible (no caret), #line or
	#block"

	^CaretStyles at: self sciGetCaretStyle + 1 ifAbsent: [#line]!

caretStyle: aSymbol 
	"Set the style of caret displayed in the receiver; one of #invisible (no caret), #line or
	#block"

	^self sciSetCaretStyle: (CaretStyles indexOf: aSymbol ifAbsent: [CARETSTYLE_LINE + 1]) - 1!

caretWidth
	"Returns the width of the insert mode caret."

	^self 
		sendMessage: SCI_GETCARETWIDTH
		wParam: 0
		lParam: 0!

caretWidth: anInteger 
	"Set the width of the caret to the number of pels specified by the <integer> argument."

	(anInteger between: 1 and: 3) 
		ifFalse: [^self error: 'Caret width must be between 1 and 3, not ' , anInteger printString].
	self sciSetCaretWidth: anInteger!

centerCurrentLine
	"Centre current line in window."

	self 
		sendMessage: SCI_VERTICALCENTRECARET
		wParam: 0
		lParam: 0!

characterAt: anInteger 
	"Answer the <Character> at the specified one-based <integer> index in the receiver's text."

	^Character 
		value: ((self 
				sendMessage: SCI_GETCHARAT
				wParam: anInteger - 1
				lParam: 0) bitAnd: 16rFF)!

charCloseToPosition: aPoint 
	"Answer the one-based index of the character closest to the specified <Point> within the
	receiver, or 0 if the co-ordinate is outside the window or not 'close' to any character."

	^(self sciCharPositionFromPointClose: aPoint x y: aPoint y) + 1!

charNearestPosition: aPoint 
	"Answer the one-based index of the character nearest the specified <Point> within the
	receiver."

	^(self sciCharPositionFromPoint: aPoint x y: aPoint y) + 1!

clearAll
	"Delete all text in the document."

	self 
		sendMessage: SCI_CLEARALL
		wParam: 0
		lParam: 0!

clearContainerIndicators
	"Clear all the indicators (e.g. squiggly underlines) from the receiver."

	self basicClearContainerIndicators.
	indicators := nil!

clearIndicator: anIntegerOrSymbol from: startInteger to: stopInteger 
	"Clear the indicator identified by <integer> id from the range of text between two one-based
	<integer> positions."

	self currentIndicatorId: (self indicatorIdFromName: anIntegerOrSymbol).
	self sciIndicatorClearRange: startInteger - 1 clearLength: stopInteger - startInteger + 1!

codePage
	"Answer a <Symbol> naming the code page currently in use, either #utf8 or #dbcs."

	^CodePages at: self sciGetCodePage ifAbsent: [#dbcs]!

codePage: aSymbol 
	"Set the code page currently in use to that named by the <Symbol> argument (one of #utf8 or
	#dbcs)."

	self sciSetCodePage: (CodePages keyAtValue: aSymbol)!

columnFromPosition: anInteger 
	"Answer the column number of the character at the specified position."

	"From the Scintilla documentation:' This message returns the column number of a position pos
	within the document taking the width of tabs into account. This returns the column number of
	the last tab on the line before pos, plus the number of characters between the last tab and
	pos. If there are no tab characters on the line, the return value is the number of
	characters up to the position on the line. In both cases, double byte characters count as a
	single character. This is probably only useful with monospaced fonts.'"

	^(self sciGetColumn: anInteger - 1) + 1!

controlCharacter
	"Answer the character used to display control characters in the document, or nil if the
	control characters are drawn (the default)."

	| code |
	code := self sciGetControlCharSymbol.
	^code < 32 ifFalse: [Character codePoint: code]!

controlCharacter: aCharacter
	"Set the way control characters are displayed: If the argument is nil (or has a code point <
	32) then draw the characters, otherwise use the given <Character>."

	self sciSetControlCharSymbol: aCharacter codePoint!

convertToLowercase
	"Transform the selection to lower case."

	self 
		sendMessage: SCI_LOWERCASE
		wParam: 0
		lParam: 0!

convertToUppercase
	"Transform the selection to upper case."

	self 
		sendMessage: SCI_UPPERCASE
		wParam: 0
		lParam: 0!

copyLine
	"Copy the line containing the caret."

	self 
		sendMessage: SCI_LINECOPY
		wParam: 0
		lParam: 0!

copySelection
	"Copy the selection to the clipboard."

	self 
		sendMessage: SCI_COPY
		wParam: 0
		lParam: 0!

copySelectionOrLine
	"Copy the selection, if selection empty copy the line with the caret"

	self 
		sendMessage: SCI_COPYALLOWLINE
		wParam: 0
		lParam: 0!

currentIndicatorId
	"Get the current indicator"

	^self 
		sendMessage: SCI_GETINDICATORCURRENT
		wParam: 0
		lParam: 0!

currentIndicatorId: indicatorInteger 
	"Set the indicator used for IndicatorFillRange and IndicatorClearRange"

	self 
		sendMessage: SCI_SETINDICATORCURRENT
		wParam: indicatorInteger
		lParam: 0!

currentIndicatorValue
	"Get the current indicator vaue"

	^self 
		sendMessage: SCI_GETINDICATORVALUE
		wParam: 0
		lParam: 0!

currentIndicatorValue: valueInteger 
	"Set the value used for IndicatorFillRange"

	self 
		sendMessage: SCI_SETINDICATORVALUE
		wParam: valueInteger
		lParam: 0!

currentLineAlpha
	"Get the background alpha of the caret line."

	^self 
		sendMessage: SCI_GETCARETLINEBACKALPHA
		wParam: 0
		lParam: 0!

currentLineAlpha: alphaInteger 
	"Set background alpha of the caret line."

	self 
		sendMessage: SCI_SETCARETLINEBACKALPHA
		wParam: alphaInteger
		lParam: 0!

currentLineBackcolor
	"Get the colour of the background of the line containing the caret."

	^RGB fromInteger: (self 
				sendMessage: SCI_GETCARETLINEBACK
				wParam: 0
				lParam: 0)!

currentLineBackcolor: backRGB 
	"Set the colour of the background of the line containing the caret. Note that this will have
	no effect unless #isCurrentLineHighlighted is set to true. You will also want to set
	#currentLineAlpha to some reasonable transparency value (100 or less), or the background
	will obliterate the text."

	self sciSetCaretLineBack: (backRGB ifNil: [Color yellow]) asRGB!

cutLine
	"Cut the line containing the caret."

	self 
		sendMessage: SCI_LINECUT
		wParam: 0
		lParam: 0!

cutSelection
	"Cut the selection to the clipboard."

	self 
		sendMessage: SCI_CUT
		wParam: 0
		lParam: 0!

decodeStyledText: aByteArray 
	| tokens pair lastStyle buffer wsStyle stream ws |
	tokens := OrderedCollection new.
	pair := nil -> nil.
	lastStyle := nil.
	buffer := ByteArray writeStream.
	"Note that whitespace might have a specific style, or may just use the normal style in which
	case we must check for whitespace characters."
	wsStyle := (self styleNamed: #whitespace) ifNil: [0] ifNotNil: [:style | style id].
	ws := self whitespaces asByteArray.
	stream := aByteArray readStream.
	[stream atEnd] whileFalse: 
			[| char style |
			char := stream next.
			style := stream next bitAnd: self maxStyle.
			(style == wsStyle and: [wsStyle ~~ 0 or: [ws identityIncludes: char]]) 
				ifTrue: [lastStyle := nil]
				ifFalse: 
					[lastStyle == style 
						ifFalse: 
							[lastStyle := style.
							pair value: buffer contents asString.
							buffer reset.
							pair := (self styleWithId: lastStyle) name -> nil.
							tokens addLast: pair].
					buffer nextPut: char]].
	pair value: buffer contents asString.
	^tokens!

defaultBraceChars
	"Private - Answer a <String> containing the set of <Character>s that Scintilla considers to be brace
	characters by default."

	^##((LookupTable new)
		at: #normal put: '()[]{}<>';
		yourself)!

defaultKeyBindings
	^DefaultKeyBindings collect: [:each | each copy]!

defaultMarkerDefinitions
	"Private - Answer an <IdentityDictionary> that associates marker names that are meaningful in the
	application domain to the definition for that marker, where the definition specifies
	attributes such as the glyph used, and foreground and background colours."

	^IdentityDictionary 
		with: #default -> ((ScintillaMarkerDefinition new)
						name: #circle;
						yourself)!

defaultModEventMask
	"Private - Answer the default modification event mask. We're not interested in marker
	changes, or the 'before' notifications of deletions and insertions, and various others.
	These can be enabled on a per-instance basis though."

	^##(SC_MODEVENTMASKALL - SC_MOD_CHANGEMARKER - SC_MOD_BEFOREDELETE - SC_MOD_BEFOREINSERT 
		- SC_MOD_CHANGEINDICATOR - SC_MOD_CONTAINER)!

defaultTextStylesFor: aSymbol 
	"Answer the default text style settings to be used for newly configured lexers."

	^(DefaultTextStyles at: aSymbol ifAbsent: [DefaultTextStyles at: #container]) 
		collect: [:each | each copy]!

defaultWhitespaceChars
	"Answer a <String> containing the <Character>s that Scintilla considers to be whitespace by
	default."

	^Character byteCharacterSet select: [:each | each codePoint < 16r20 or: [each == $ ]]!

defaultWindowStyle
	"Private - Answer a default style to use when creating a ScintillaView."

	"Implementation Note: Scintilla occassionally creates child windows, e.g. for
	autocompletion, and since it does background painting it may occassionally paint over these.
	Therefore it needs the WS_CLIPCHILDREN style. Unfortunately the documentation does not
	mention this, but Scite does set this style when creating the window."

	^super defaultWindowStyle bitOr: WS_CLIPCHILDREN!

defaultWordChars
	"Answer a <collection> of the characters that, by default, Scintilla considers to be 'word'
	characters, as opposed to word delimiters such as whitespace or punctuation."

	"Implementation Note: This property of the control is not queryable, so this implementation
	is based on examination of the source code."

	^Character byteCharacterSet 
		select: [:each | each == $_ or: [each codePoint >= 16r80 or: [each isAlphaNumeric]]]!

deleteLine
	"Delete the line containing the caret."

	self 
		sendMessage: SCI_LINEDELETE
		wParam: 0
		lParam: 0!

deleteMarkers: markerNumberInteger 
	"Delete all markers with a particular number from all lines."

	self 
		sendMessage: SCI_MARKERDELETEALL
		wParam: markerNumberInteger
		lParam: 0!

deleteToEndOfLine
	"Delete forwards from the current position to the end of the line."

	self 
		sendMessage: SCI_DELLINERIGHT
		wParam: 0
		lParam: 0!

deleteToEndOfWord
	"Delete the word to the right of the caret, but not the trailing non-word characters."

	self 
		sendMessage: SCI_DELWORDRIGHTEND
		wParam: 0
		lParam: 0!

deleteToNextWord
	"Delete the word to the right of the caret."

	self 
		sendMessage: SCI_DELWORDRIGHT
		wParam: 0
		lParam: 0!

deleteToStartOfLine
	"Delete back from the current position to the start of the line."

	self 
		sendMessage: SCI_DELLINELEFT
		wParam: 0
		lParam: 0!

deleteToStartOfWord
	"Delete the word to the left of the caret."

	self 
		sendMessage: SCI_DELWORDLEFT
		wParam: 0
		lParam: 0!

destroyAutoCompletionListImages
	"Clear all the registered XPM images."

	self 
		sendMessage: SCI_CLEARREGISTEREDIMAGES
		wParam: 0
		lParam: 0!

duplicateLine
	"Duplicate the current line."

	self 
		sendMessage: SCI_LINEDUPLICATE
		wParam: 0
		lParam: 0!

duplicateSelection
	"Duplicate the selection. If selection empty duplicate the line containing the caret."

	self 
		sendMessage: SCI_SELECTIONDUPLICATE
		wParam: 0
		lParam: 0!

edgeColor
	"Retrieve the colour used in edge indication."

	^RGB fromInteger: (self 
				sendMessage: SCI_GETEDGECOLOUR
				wParam: 0
				lParam: 0)!

edgeColor: edgeColourRGB 
	"Change the colour used in edge indication."

	self 
		sendMessage: SCI_SETEDGECOLOUR
		wParam: edgeColourRGB asParameter
		lParam: 0!

edgeColumn
	"Answer the one-based <integer> index of the column considered to be the rightmost edge of
	the view. This is only relevant when long-line marking is enabled by setting the edge mode
	to something other than #none."

	^self sciGetEdgeColumn + 1!

edgeColumn: anInteger
	"Set the one-based <integer> index of the column considered to be the rightmost edge of
	the view. This is only relevant when long-line marking is enabled by setting the edge mode
	to something other than #none."

	self sciSetEdgeColumn: anInteger - 1!

edgeMode
	"Answer the <Symbol>ic name of the current edge marking mode used to indicate long lines.
	See #edgeMode: for a description of the modes."

	^self class edgeModes at: self sciGetEdgeMode + 1!

edgeMode: aSymbol 
	"Set the edge marking mode used to indicate long lines. The <Symbol> argument can be one of:
		#none - long lines are not marked 
		#line - a vertical line is drawn at the edge column
		#background - the #edgeColor is used for the background past the #edgeColumn 
	N.B. #background mode should be used in views with proportional fonts in preference to #line."

	^self sciSetEdgeMode: (self class edgeModes keyAtValue: aSymbol) - 1!

editStyles
	(ScintillaTextStylesDialog createOn: (self aspectValue: #textStyles))
		defaultStyle: self buildViewStyle;
		showModal!

emptyUndoBuffer
	"Delete the undo history."

	self 
		sendMessage: SCI_EMPTYUNDOBUFFER
		wParam: 0
		lParam: 0!

enChange
	"Private - The receiver's text (not styles or other visuals) has been updated, and the change has 
	been displayed."

	"Implementation Note: Ignore EN_CHANGE from Scintilla since it sends it for all sorts of
	events that haven't changed the text. We detect text changes in #scnModified: instead.
	Return 0 to suppress propagation of WM_COMMAND to the parent view's default window
	procedure."

	^0!

endOfLineMode
	"Answer a <Symbol> naming the receiver's current end-of-line mode, one of #cr, #lf, #crlf.
	This controls the character, or characters in the case of #crlf, inserted into the text when
	the carriage return key is pressed."

	^self class lineEndings at: self sciGetEOLMode + 1!

endOfLineMode: aSymbol 
	"Set the End of Line mode of the receiver. The <Symbol> argument must be one of #crlf, #cr,
	or #lf. This controls the character, or characters in the case of #crlf, inserted into the
	text when the carriage return key is pressed. Any pre-existing text is unaffected by changes
	to the end-of-line mode, but see also #canonicalizeLineEndings:."

	self sciSetEOLMode: (self class lineEndings indexOf: aSymbol) - 1!

endUndoGroup
	"End a sequence of actions that is undone and redone as a unit."

	self 
		sendMessage: SCI_ENDUNDOACTION
		wParam: 0
		lParam: 0!

enKillFocus
	"Private - The receiver is actually gaining focus (the defintions of
	SCEN_KILLFOCUS and SCEN_SETFOCUS are inverted with 
	respect to EN_KILLFOCUS and EN_SETFOCUS)."

	^super enSetFocus!

enSetFocus
	"Private - The receiver is actually losing focus (the defintions of
	SCEN_KILLFOCUS and SCEN_SETFOCUS are inverted with 
	respect to EN_KILLFOCUS and EN_SETFOCUS)."

	^super enKillFocus!

ensureCaretVisible
	"Ensure the caret is visible. Note that this will show the caret even if currently hidden inside a fold."

	self ensureVisible: self caretPosition.
	self 
		sendMessage: SCI_SCROLLCARET
		wParam: 0
		lParam: 0!

ensureHasAnnotationStyles
	annotationStyles 
		ifNil: [annotationStyles := self buildAnnotationStyles: self class defaultAnnotationStyles]!

ensureLineVisible: anInteger 
	self sciEnsureVisible: anInteger - 1!

ensureVisible: anInteger 
	"Ensure that the specified character position is visible."

	self ensureLineVisible: (self lineFromPosition: anInteger)!

enUpdate
	"Private - The receiver's text has been updated, and the change has 
	been displayed."

	"Implementation Note: SCN_UPDATEUI seems better notification to hook.
	Just return 0 to suppress propagation of WM_COMMAND to parent window procedure."

	^0!

errorStatus
	"Get error status."

	^self 
		sendMessage: SCI_GETSTATUS
		wParam: 0
		lParam: 0!

errorStatus: statusCodeInteger 
	"Change error status - 0 = OK."

	self 
		sendMessage: SCI_SETSTATUS
		wParam: statusCodeInteger
		lParam: 0!

extendDown
	"Move caret down one line extending selection to new caret position."

	self 
		sendMessage: SCI_LINEDOWNEXTEND
		wParam: 0
		lParam: 0!

extendLeft
	"Move caret left one character extending selection to new caret position."

	self 
		sendMessage: SCI_CHARLEFTEXTEND
		wParam: 0
		lParam: 0!

extendPageDown
	"Move caret one page down extending selection to new caret position."

	self 
		sendMessage: SCI_PAGEDOWNEXTEND
		wParam: 0
		lParam: 0!

extendPageUp
	"Move caret one page up extending selection to new caret position."

	self 
		sendMessage: SCI_PAGEUPEXTEND
		wParam: 0
		lParam: 0!

extendParaDown
	self 
		sendMessage: SCI_PARADOWNEXTEND
		wParam: 0
		lParam: 0!

extendParaUp
	self 
		sendMessage: SCI_PARAUPEXTEND
		wParam: 0
		lParam: 0!

extendRectangleDown
	"Move caret down one line, extending rectangular selection to new caret position."

	self 
		sendMessage: SCI_LINEDOWNRECTEXTEND
		wParam: 0
		lParam: 0!

extendRectangleLeft
	"Move caret left one character, extending rectangular selection to new caret position."

	self 
		sendMessage: SCI_CHARLEFTRECTEXTEND
		wParam: 0
		lParam: 0!

extendRectanglePageDown
	"Move caret one page down, extending rectangular selection to new caret position."

	self 
		sendMessage: SCI_PAGEDOWNRECTEXTEND
		wParam: 0
		lParam: 0!

extendRectanglePageUp
	"Move caret one page up, extending rectangular selection to new caret position."

	self 
		sendMessage: SCI_PAGEUPRECTEXTEND
		wParam: 0
		lParam: 0!

extendRectangleRight
	"Move caret right one character, extending rectangular selection to new caret position."

	self 
		sendMessage: SCI_CHARRIGHTRECTEXTEND
		wParam: 0
		lParam: 0!

extendRectangleToEndOfLine
	"Move caret to last position on line, extending rectangular selection to new caret
	position."

	self 
		sendMessage: SCI_LINEENDRECTEXTEND
		wParam: 0
		lParam: 0!

extendRectangleToStartOfLine
	"Move caret to first position on line, extending rectangular selection to new caret
	position."

	self 
		sendMessage: SCI_HOMERECTEXTEND
		wParam: 0
		lParam: 0!

extendRectangleToVcHome
	"Move caret to before first visible character on line. If already there move to first
	character on line. In either case, extend rectangular selection to new caret position."

	self 
		sendMessage: SCI_VCHOMERECTEXTEND
		wParam: 0
		lParam: 0!

extendRectangleUp
	"Move caret up one line, extending rectangular selection to new caret position."

	self 
		sendMessage: SCI_LINEUPRECTEXTEND
		wParam: 0
		lParam: 0!

extendRight
	"Move caret right one character extending selection to new caret position."

	self 
		sendMessage: SCI_CHARRIGHTEXTEND
		wParam: 0
		lParam: 0!

extendStutteredPageDown
	"Move caret to bottom of page, or one page down if already at bottom of page, extending
	selection to new caret position."

	self 
		sendMessage: SCI_STUTTEREDPAGEDOWNEXTEND
		wParam: 0
		lParam: 0!

extendStutteredPageUp
	"Move caret to top of page, or one page up if already at top of page, extending selection to
	new caret position."

	self 
		sendMessage: SCI_STUTTEREDPAGEUPEXTEND
		wParam: 0
		lParam: 0!

extendToEndOfDisplayLine
	"Move caret to last position on display line extending selection to new caret position."

	self 
		sendMessage: SCI_LINEENDDISPLAYEXTEND
		wParam: 0
		lParam: 0!

extendToEndOfDocument
	"Move caret to last position in document extending selection to new caret position."

	self 
		sendMessage: SCI_DOCUMENTENDEXTEND
		wParam: 0
		lParam: 0!

extendToEndOfLine
	"Move caret to last position on line extending selection to new caret position."

	self 
		sendMessage: SCI_LINEENDEXTEND
		wParam: 0
		lParam: 0!

extendToEndOfNextWord
	"Move caret right one word, position cursor at end of word, extending selection to new caret
	position."

	self 
		sendMessage: SCI_WORDRIGHTENDEXTEND
		wParam: 0
		lParam: 0!

extendToEndOfPreviousWord
	"Move caret left one word, position cursor at end of word, extending selection to new caret
	position."

	self 
		sendMessage: SCI_WORDLEFTENDEXTEND
		wParam: 0
		lParam: 0!

extendToEndOfWord
	"Move caret right one word extending selection to new caret position."

	self 
		sendMessage: SCI_WORDRIGHTEXTEND
		wParam: 0
		lParam: 0!

extendToEndOfWordPart
	"Move to the next change in capitalisation extending selection to new caret position."

	self 
		sendMessage: SCI_WORDPARTRIGHTEXTEND
		wParam: 0
		lParam: 0!

extendToEndOfWrappedLine
	self 
		sendMessage: SCI_LINEENDWRAPEXTEND
		wParam: 0
		lParam: 0!

extendToStartOfDisplayLine
	"Move caret to first position on display line extending selection to new caret position."

	self 
		sendMessage: SCI_HOMEDISPLAYEXTEND
		wParam: 0
		lParam: 0!

extendToStartOfDocument
	"Move caret to first position in document extending selection to new caret position."

	self 
		sendMessage: SCI_DOCUMENTSTARTEXTEND
		wParam: 0
		lParam: 0!

extendToStartOfLine
	"Move caret to first position on line extending selection to new caret position."

	self 
		sendMessage: SCI_HOMEEXTEND
		wParam: 0
		lParam: 0!

extendToStartOfWord
	"Move caret left one word extending selection to new caret position."

	self 
		sendMessage: SCI_WORDLEFTEXTEND
		wParam: 0
		lParam: 0!

extendToStartOfWordPart
	"Move to the previous change in capitalisation extending selection to new caret position."

	self 
		sendMessage: SCI_WORDPARTLEFTEXTEND
		wParam: 0
		lParam: 0!

extendToStartOfWrappedLine
	self 
		sendMessage: SCI_HOMEWRAPEXTEND
		wParam: 0
		lParam: 0!

extendToVcHome
	"Like VCHome but extending selection to new caret position."

	self 
		sendMessage: SCI_VCHOMEEXTEND
		wParam: 0
		lParam: 0!

extendToWrappedVcHome
	self 
		sendMessage: SCI_VCHOMEWRAPEXTEND
		wParam: 0
		lParam: 0!

extendUp
	"Move caret up one line extending selection to new caret position."

	self 
		sendMessage: SCI_LINEUPEXTEND
		wParam: 0
		lParam: 0!

extraAscent
	"Get extra ascent for each line"

	^self 
		sendMessage: SCI_GETEXTRAASCENT
		wParam: 0
		lParam: 0!

extraAscent: extraAscentInteger 
	"Set extra ascent for each line"

	self 
		sendMessage: SCI_SETEXTRAASCENT
		wParam: extraAscentInteger
		lParam: 0!

extraDescent
	"Get extra descent for each line"

	^self 
		sendMessage: SCI_GETEXTRADESCENT
		wParam: 0
		lParam: 0!

extraDescent: extraDescentInteger 
	"Set extra descent for each line"

	self 
		sendMessage: SCI_SETEXTRADESCENT
		wParam: extraDescentInteger
		lParam: 0!

extraStyleBits
	"Style-byte indicators should no longer be used."

	#deprecated.
	^extraStyleBits!

extraStyleBits: anInteger 
	"Style-byte indicators should no longer be used. Lexers/stylers can use indicators from the
	reserved range, 0..7, for marking regions of text independently of other styling
	information."

	#deprecated.
	(anInteger between: 0 and: 8 - self styleBits) 
		ifFalse: [self error: 'Invalid number of extra style bits'].
	extraStyleBits := anInteger.
	self hideExtraIndicators!

extraStyleMask
	^16r700 >> extraStyleBits bitAnd: 16rFF!

find: aFindDetails range: anInterval 
	"Private - Find the first occurrence of aString in the text of the receiver within the range rangeInterval."

	| findFlags range |
	aFindDetails isRegularExpression ifTrue: [^super find: aFindDetails range: anInterval].
	findFlags := 0.
	aFindDetails isWholeWord ifTrue: [findFlags := findFlags maskSet: SCFIND_WHOLEWORD].
	aFindDetails isCaseSensitive ifTrue: [findFlags := findFlags maskSet: SCFIND_MATCHCASE].
	"Note that we don't actually use the Scintilla RegExp search because it is too limited"
	aFindDetails isRegularExpression ifTrue: [findFlags := findFlags maskSet: SCFIND_REGEXP].
	range := aFindDetails isForwards 
				ifTrue: [anInterval]
				ifFalse: [anInterval stop to: anInterval start].
	^self 
		find: aFindDetails pattern
		range: range
		flags: findFlags!

find: aString range: anInterval flags: anInteger 
	"Attempt to find the text findString in the receivers text within findRange. flags are from
	the SCFIND enumeration. Answer the (1-based) position of the found string, or 0 if nothing matched."

	| findText start stop range |
	start := anInterval start - 1.
	stop := anInterval stop.
	stop < start ifTrue: [stop := stop - 1].
	findText := FINDTEXTEX 
				from: start
				to: stop
				text: aString.
	self sciFindText: anInteger ft: findText.
	range := findText chrgText.
	^range cpMin + 1 to: range cpMax!

findAutoCompletionEntry: textString 
	"Select the item in the auto-completion list that starts with a string."

	self 
		sendMessage: SCI_AUTOCSELECT
		wParam: 0
		lpParam: textString!

findMatchingBrace: anInteger 
	"Answer the one-based <integer> index of the character in the receiver which is the brace
	matching that at the one-based <integer> index argument. If there is no matching brace, or
	the character at the specified position is not itself a brace character, then answer zero.
	Note that for two brace characters to be considered a match they must have the same style."

	^(self sciBraceMatch: anInteger - 1) + 1!

findStyleStart: aSymbol before: anInteger 
	"Answer the one-based <integer> index of the first character in a block of the style named
	by the <Symbol> argument, searching back from the specified <integer> character position. If
	the style is not found before the start of the text is reached, answer zero."

	| id start |
	id := (self styleNamed: aSymbol) ifNil: [^0] ifNotNil: [:style | style id].
	start := anInteger.
	[(self styleIdAt: start) == id] whileFalse: [(start := start - 1) == 0 ifTrue: [^0]].
	[start > 0 and: [(self styleIdAt: start) == id]] whileTrue: [start := start - 1].
	^start + 1!

firstVisibleLine: anInteger 
	"Scroll so that a display line is at the top of the display."

	self sciSetFirstVisibleLine: anInteger - 1!

foldFlags
	^foldFlags!

foldFlags: anInteger 
	"Set the fold flags used to configure the visual appearance of folding (document outlining) in Scintilla:
	The <integer> argument should be some combination of the following values:
		SC_FOLDFLAG_LINEBEFORE_EXPANDED -> 2 
		SC_FOLDFLAG_LINEBEFORE_CONTRACTED -> 4 
		SC_FOLDFLAG_LINEAFTER_EXPANDED -> 8 
		SC_FOLDFLAG_LINEAFTER_CONTRACTED -> 16 
		SC_FOLDFLAG_LEVELNUMBERS -> 64 
	"

	foldFlags := anInteger.
	self setFoldFlags!

foldLine: lineInteger level: levelInteger 
	"Set the fold 'level' of the specified line. The levelInteger argument encodes an integer
	level along with flags indicating whether the line is a header and whether it is effectively
	white space."

	self sciSetFoldLevel: lineInteger - 1 level: levelInteger!

foldMargin
	"Answer the <ScintillaMargin> used to display fold markers for outlining."

	"N.B. It is assumed there is only one fold margin in the view, so the first encountered is
	used."

	^self margins detect: [:each | each isFolders] ifNone: []!

foldMarginColor
	"Answer the background colour of the fold margin."

	^foldMarginColor ifNil: [Color face3d]!

foldMarginColor: aColorOrNil 
	"Set the background colour of the fold margin."

	foldMarginColor := aColorOrNil.
	self setFoldMarginColor!

foldMarginHiColor
	"Answer the background colour of the fold margin."

	^foldMarginHiColor ifNil: [Color highlight3d]!

foldMarginHiColor: aColorOrNil 
	"Set the background colour of the fold margin."

	foldMarginHiColor := aColorOrNil.
	self setFoldMarginHiColor!

foldMarkerStyle
	"Answer the symbolic name of the fold markers (outliner glyphs) in use in the receiver if
	the fold margin is visible, and the current lexer supports (and is enabled for) folding. If
	the fold marker style is nil, then all markers are available to be defined as desired. This
	allows for custom fold marker styles on a per-instance basis, or you can add your own styles
	to the FoldMarkerStyles collection."

	^foldMarkerStyle!

foldMarkerStyle: aSymbol 
	| folders |
	folders := aSymbol ifNil: [#()] ifNotNil: [ScintillaMarkerDefinition perform: aSymbol].
	markerDefinitions := markerDefinitions 
				reject: [:each | each basicId between: SC_MARKNUM_FOLDEREND and: SC_MARKNUM_FOLDEROPEN].
	folders do: 
			[:each | 
			each applyToView: self.
			markerDefinitions at: each name put: each].
	foldMarkerStyle := aSymbol!

fontQuality
	"Retrieve the quality level for text."

	^self class fontQualities at: self sciGetFontQuality + 1 ifAbsent: [#default]!

fontQuality: aSymbol 
	"Choose the quality level for text from the FontQuality enumeration."

	self sciSetFontQuality: (self class fontQualities keyAtValue: aSymbol) - 1!

forecolor: aColorOrNil 
	"Sets the background colour of the receiver to aColorOrNil. If aColorOrNil is nil then
	inherit the foreground colour of the parent window."

	"Note we don't supersend, because we don't need to invalidate on changing colours - Scintilla takes care of that"

	forecolor := aColorOrNil.
	self updateTextStyles!

formatRectangle
	"Answers the <Rectangle> used to format the text."

	"Implementation Note: Scintilla does not support this functionality of the standard edit control"

	^self shouldNotImplement!

formFeed
	"Insert a Form Feed character."

	self 
		sendMessage: SCI_FORMFEED
		wParam: 0
		lParam: 0!

getDirectPointer
	this := (super sendMessage: SCI_GETDIRECTPOINTER) asExternalHandle!

getLexerLanguage
	| len |
	len := self sciGetLexerLanguage: nil.
	^len = 0 
		ifTrue: [#container]
		ifFalse: 
			[| buf |
			buf := String newFixed: len.
			self sciGetLexerLanguage: buf.
			buf asSymbol]!

getLineState: anInteger 
	"Get the extra line state information (if any) associated with the specified line."

	^self sciGetLineState: anInteger - 1!

getRawAnnotation: anInteger 
	"Private - Answer a single <ScintillaAnnotation> representing the raw form of the annotations against
	the line of the receiver identified by the zero-based <integer> index argument. The raw form
	holds each annotation line as a single concatenated string with linefeed separators, and
	with a <ByteArray> representing the style bytes for the characters of the text in
	corresponding positions."

	| textLength |
	textLength := self sciAnnotationGetText: anInteger text: nil.
	^textLength > 0 
		ifTrue: 
			[| styles text |
			text := String newFixed: textLength.
			self sciAnnotationGetText: anInteger text: text.
			styles := ByteArray newFixed: textLength.
			self sciAnnotationGetStyles: anInteger styles: styles.
			ScintillaAnnotation 
				line: anInteger
				text: text
				styles: styles]!

getRawAnnotations
	"Private - Answer a single <collection> of <ScintillaAnnotation> representing the raw form
	of the annotations against all lines of the receiver that are currently annotated. The raw
	form holds each annotation line as a single concatenated string with linefeed separators,
	and with a <ByteArray> representing the style bytes for the characters of the text in
	corresponding positions."

	| rawAnnotations |
	rawAnnotations := OrderedCollection new.
	0 to: self lineCount - 1
		do: 
			[:i | 
			"Checking for presence of annotations on each line is not stricly necessary,
			but makes this run up to 25%, which might be significant for very large
			files."
			(self sciAnnotationGetLines: i) > 0 ifTrue: [rawAnnotations add: (self getRawAnnotation: i)]].
	^rawAnnotations!

goto: anInteger 
	"Move the caret to the specified position and ensure it is visible."

	self sciGotoPos: anInteger - 1!

gotoLine: lineInteger 
	"Set caret to start of the line with the specified one-based <integer> index, ensure that
	the line is visible."

	self sciGotoLine: lineInteger - 1!

handle: aHandleOrNil 
	this := nil.
	super handle: aHandleOrNil!

hangingIndent
	"Retrive the start indent for wrapped lines."

	^self 
		sendMessage: SCI_GETWRAPSTARTINDENT
		wParam: 0
		lParam: 0!

hangingIndent: indentInteger 
	"Set the start indent for wrapped lines."

	self 
		sendMessage: SCI_SETWRAPSTARTINDENT
		wParam: indentInteger
		lParam: 0!

hasBlinkingSecondaryCarets
	"Whether additional carets will blink"

	^(self 
		sendMessage: SCI_GETADDITIONALCARETSBLINK
		wParam: 0
		lParam: 0) asBoolean!

hasBlinkingSecondaryCarets: additionalCaretsBlinkBoolean 
	"Set whether additional carets will blink"

	self 
		sendMessage: SCI_SETADDITIONALCARETSBLINK
		wParam: additionalCaretsBlinkBoolean asParameter
		lParam: 0!

hasFoldMargin
	^self foldMargin ifNotNil: [:margin | margin width ~~ 0] ifNil: [false]!

hasFoldMargin: aBoolean 
	self foldMargin ifNotNil: [:margin | margin width: (aBoolean ifTrue: [16] ifFalse: [0])]!

hasIndentationGuides
	"Are the indentation guides visible?"

	^self indentationGuides ~= nil!

hasIndentationGuides: aBoolean 
	"Show or hide indentation guides."

	self indentationGuides: (aBoolean ifTrue: [#real])
		!

hasLineNumbers
	^self lineNumberMargin ifNotNil: [:margin | margin width ~~ 0] ifNil: [false]!

hasLineNumbers: aBoolean 
	self lineNumberMargin 
		ifNotNil: [:margin | margin width: (aBoolean ifTrue: [self requiredLineMarginWidth] ifFalse: [0])]!

hasVisibleLineEndings
	"Are the end of line characters visible?"

	^(self 
		sendMessage: SCI_GETVIEWEOL
		wParam: 0
		lParam: 0) asBoolean!

hasVisibleLineEndings: visibleBoolean 
	"Make the end of line characters visible or invisible."

	self 
		sendMessage: SCI_SETVIEWEOL
		wParam: visibleBoolean asParameter
		lParam: 0!

hideExtraIndicators
	| indics |
	indics := 8 - self styleBits.	"Make any indicators coinciding with the extra style bits invisible."
	indics - extraStyleBits to: indics - 1
		do: 
			[:each | 
			self 
				sendMessage: SCI_INDICSETSTYLE
				wParam: each
				lParam: INDIC_HIDDEN]!

hideIndicators
	"Private - Reconfigure all indicator styles to hidden apart from the default 3 pre-configured styles."

	3 to: INDIC_MAX
		do: 
			[:each | 
			self 
				sendMessage: SCI_INDICSETSTYLE
				wParam: each
				lParam: INDIC_HIDDEN]!

hideSelection: normalBoolean 
	"Draw the selection in normal style or with selection highlighted."

	self 
		sendMessage: SCI_HIDESELECTION
		wParam: normalBoolean asParameter
		lParam: 0!

highlightBracesAt: leftInteger and: rightInteger 
	"Highlight the pair of characters (presumably braces) at the specified one-based <integer>
	indices by applying the #braceHighlight text style to them."

	self sciBraceHighlight: leftInteger - 1 pos2: rightInteger - 1!

highlightCallTipFrom: startInteger to: stopInteger 
	"Highlight a range of the text in the call tip."

	self sciCallTipSetHlt: startInteger - 1 end: stopInteger - 1!

highlightFindMatch: anInterval 
	"self ensureVisible: anInterval start.
	self ensureVisible: anInterval stop."

	self selectionRange: anInterval.
	self ensureCaretVisible!

highlightGuide
	"Get the highlighted indentation guide column."

	^self 
		sendMessage: SCI_GETHIGHLIGHTGUIDE
		wParam: 0
		lParam: 0!

highlightGuide: columnInteger 
	"Set the highlighted indentation guide column. 0 = no highlighted guide."

	self 
		sendMessage: SCI_SETHIGHLIGHTGUIDE
		wParam: columnInteger
		lParam: 0!

highlightMismatchedBrace: anInteger 
	"Highlight the character (presumably a brace) at the specified one-based <integer> index
	with the #mismatchedBrace text style. If the argument is zero, any brace highlighting is removed."

	self sciBraceBadLight: anInteger - 1!

highlightRange: anInterval withIndicator: idInteger 
	"Apply the indicator identified by the <integer> argument to the range of text
	specified by the <Interval> argument."

	#deprecated.
	self setIndicator: idInteger range: anInterval!

hoverTime
	"Retrieve the time the mouse must sit still to generate a mouse dwell event."

	^self 
		sendMessage: SCI_GETMOUSEDWELLTIME
		wParam: 0
		lParam: 0!

hoverTime: periodMillisecondsInteger 
	"Sets the time the mouse must sit still to generate a mouse dwell event."

	self 
		sendMessage: SCI_SETMOUSEDWELLTIME
		wParam: periodMillisecondsInteger
		lParam: 0!

idOfStyleNamed: aSymbol 
	^(self styleNamed: aSymbol) ifNil: [0] ifNotNil: [:style | style id]!

indent
	"If selection is empty or all on one line replace the selection with a tab character. If
	more than one line selected, indent the lines."

	self 
		sendMessage: SCI_TAB
		wParam: 0
		lParam: 0!

indentation
	"Retrieve indentation size."

	^self 
		sendMessage: SCI_GETINDENT
		wParam: 0
		lParam: 0!

indentation: indentSizeInteger 
	"Set the number of spaces used for one level of indentation."

	self 
		sendMessage: SCI_SETINDENT
		wParam: indentSizeInteger
		lParam: 0!

indentationGuides
	"Answer the symbolic name of the style of indentation guides visible in the receiver, or nil if none."

	^IndentationGuideStyles at: self sciGetIndentationGuides ifAbsent: []!

indentationGuides: aSymbolOrNil 
	"Set the style of indication guides to be displayed in the receiver, one of nil (no
	guides), #real, #lookForward, #lookBoth."

	self sciSetIndentationGuides: (IndentationGuideStyles indexOf: aSymbolOrNil ifAbsent: [0])!

indentationOfLine: anInteger 
	"Retrieve the number of columns that a line is indented."

	^self sciGetLineIndentation: anInteger - 1!

indicatorCount
	"Answer the number of indicators configured for the receiver. With the advent of 'modern'
	indicators, this is now fixed at 32 and not related to the number of style bits used."

	^INDIC_MAX + 1!

indicatorDefinitions
	#deprecated.
	^self indicatorStyles!

indicatorDefinitions: aSequenceableCollection 
	#deprecated.
	self indicatorStyles: aSequenceableCollection!

indicatorIdFromName: anIntegerOrSymbol 
	^anIntegerOrSymbol isInteger 
		ifTrue: 
			[(anIntegerOrSymbol between: 0 and: INDIC_MAX) 
				ifFalse: [self error: 'Indicator id is out of range: ' , anIntegerOrSymbol printString].
			anIntegerOrSymbol]
		ifFalse: 
			[(indicatorStyles ifNotNil: [:indics | indics at: anIntegerOrSymbol ifAbsent: []]) 
				ifNil: [-1	"Indicator is not configured in the view, not necessarily an error"]
				ifNotNil: [:indicStyle | indicStyle id]]!

indicatorMaskAt: anInteger 
	"Answer an <integer> which is a bit mask describing the indicators applied to the character
	at the specified one-based <integer> index."

	^self sciIndicatorAllOnFor: anInteger - 1!

indicators
	"Answer a <collection> of <ScintillaIndicator>s, being the indicators (e.g. squiggly
	underlines) associated with ranges of text in the receiver."

	^indicators ifNil: [#()]!

indicators: aCollectionOfScintillaIndicator 
	"Set the indicators (e.g. squiggly underlines) associated with ranges of text in the
	receiver to the <Collection> of <ScintillaIndicator>s argument."

	self setIndicators: aCollectionOfScintillaIndicator!

indicatorsAt: anInteger 
	"Answer a <collection> of <ScintillaIndicator>s, being the indicators applied to the
	character position with the specified one-based <integer> index."

	(indicators isNil or: [(self indicatorMaskAt: anInteger) == 0]) ifTrue: [^#()].
	^indicators select: [:each | each range includes: anInteger]!

indicatorStyles
	"Answer a <sequencedReadableCollection> containing all the receiver's indicator definitions."

	^(indicatorStyles ifNil: [#()] ifNotNil: [:value | value values]) 
		asSortedCollection: ScintillaAttribute sortByIdBlock!

indicatorStyles: aCollection 
	"Set the receiver's collection of indicators to the <collection> of
	<ScintillaIndicatorStyle>s argument."

	self setIndicatorStyles: (aCollection ifNil: [#()])!

indicatorsUnder: aPoint 
	^self indicatorsAt: (self charCloseToPosition: aPoint)!

initialize
	| styles |
	super initialize.
	markerDefinitions := self defaultMarkerDefinitions.
	markers := IdentitySet new.
	styleMask := 31.
	allTextStyles := IdentityDictionary new.
	styles := self class defaultTextStyles.
	self setCurrentTextStyles: styles.
	whitespaces := Whitespaces.
	selectionBackcolor := Color gray.
	scFlags := 0.
	extraStyleBits := 0!

initializeControl
	"Private - Prime the Scintilla control with any settings stored in instance variables that
	differ from the defaults."

	self sciSetModEventMask: self modificationEventMask.
	self sciGetStyleBits = self styleBits ifFalse: [self sciSetStyleBits: self styleBits].
	"Not necessary.
		self sciUsePopup: false asParameter."
	self setCallTipTabWidth.
	self
		marginStylesOffset: MarginStylesOffset;
		updateIndicatorStyles;
		updateTextStyles;
		updateMarkerDefinitions.
	styler ifNotNil: [self invalidateStyling].
	self setWordChars.
	autoCFillups ifNotNil: [self sciAutoCSetFillUps: autoCFillups].
	autoCStops ifNotNil: [self sciAutoCStops: autoCStops].
	whitespaceForecolor ifNotNil: [self setWhitespaceForecolor].
	whitespaceBackcolor ifNotNil: [self setWhitespaceBackcolor].
	"Note that if any priimary selection foreground/background colors are set, then any second
	selection colours will also be set"
	selectionForecolor ifNotNil: [self setSelectionForecolor].
	selectionBackcolor = Color gray ifFalse: [self setSelectionBackcolor].
	callTipHighlightColor ifNotNil: [self setCallTipHighlightColor].
	foldMarginColor ifNotNil: [self setFoldMarginColor].
	foldMarginHiColor ifNotNil: [self setFoldMarginHiColor].
	foldFlags ifNotNil: [self setFoldFlags].
	self isFoldingEnabled ifTrue: [self setFoldProperty: true].
	keyBindings ifNotNil: [self updateKeyBindings]!

insertText: aString at: anInteger 
	"Insert text at the specified position without moving the caret."

	self sciInsertText: anInteger - 1 text: aString!

insertText: lengthInteger from: textString 
	"Add text to the document at current position."

	self 
		sendMessage: SCI_ADDTEXT
		wParam: lengthInteger
		lParam: textString yourAddress!

invalidateStyling
	self startStylingFrom: 1!

isActiveHotspotUnderlined
	"Get whether underlining for active hotspots."

	^(self 
		sendMessage: SCI_GETHOTSPOTACTIVEUNDERLINE
		wParam: 0
		lParam: 0) asBoolean!

isActiveHotspotUnderlined: underlineBoolean 
	"Enable / Disable underlining active hotspots."

	self 
		sendMessage: SCI_SETHOTSPOTACTIVEUNDERLINE
		wParam: underlineBoolean asParameter
		lParam: 0!

isAutoCompletionActive
	"Is there an auto-completion list visible?"

	^(self 
		sendMessage: SCI_AUTOCACTIVE
		wParam: 0
		lParam: 0) asBoolean!

isAutoCompletionCancelledAtStart
	"Retrieve whether auto-completion cancelled by backspacing before start."

	^(self 
		sendMessage: SCI_AUTOCGETCANCELATSTART
		wParam: 0
		lParam: 0) asBoolean!

isAutoCompletionCancelledAtStart: cancelBoolean 
	"Should the auto-completion list be cancelled if the user backspaces to a position before
	where the box was created."

	self 
		sendMessage: SCI_AUTOCSETCANCELATSTART
		wParam: cancelBoolean asParameter
		lParam: 0!

isAutoCompletionCancelledWhenNoMatch
	"Retrieve whether or not autocompletion is hidden automatically when nothing matches."

	^(self 
		sendMessage: SCI_AUTOCGETAUTOHIDE
		wParam: 0
		lParam: 0) asBoolean!

isAutoCompletionCancelledWhenNoMatch: autoHideBoolean 
	"Set whether or not autocompletion is hidden automatically when nothing matches."

	self 
		sendMessage: SCI_AUTOCSETAUTOHIDE
		wParam: autoHideBoolean asParameter
		lParam: 0!

isAutoCompletionCaseInsensitive
	"Retrieve state of ignore case flag."

	^(self 
		sendMessage: SCI_AUTOCGETIGNORECASE
		wParam: 0
		lParam: 0) asBoolean!

isAutoCompletionCaseInsensitive: ignoreCaseBoolean 
	"Set whether case is significant when performing auto-completion searches."

	self 
		sendMessage: SCI_AUTOCSETIGNORECASE
		wParam: ignoreCaseBoolean asParameter
		lParam: 0!

isAutoCompletionSingleMatchChosen
	"Retrieve whether a single item auto-completion list automatically choose the item."

	^(self 
		sendMessage: SCI_AUTOCGETCHOOSESINGLE
		wParam: 0
		lParam: 0) asBoolean!

isAutoCompletionSingleMatchChosen: chooseSingleBoolean 
	"Should a single item auto-completion list automatically choose the item."

	self 
		sendMessage: SCI_AUTOCSETCHOOSESINGLE
		wParam: chooseSingleBoolean asParameter
		lParam: 0!

isAutoCompletionTruncating
	"Retrieve whether or not autocompletion deletes any word characters after the inserted text
	upon completion."

	^(self 
		sendMessage: SCI_AUTOCGETDROPRESTOFWORD
		wParam: 0
		lParam: 0) asBoolean!

isAutoCompletionTruncating: dropRestOfWordBoolean 
	"Set whether or not autocompletion deletes any word characters after the inserted text upon
	completion."

	self 
		sendMessage: SCI_AUTOCSETDROPRESTOFWORD
		wParam: dropRestOfWordBoolean asParameter
		lParam: 0!

isBackgroundDwellEnabled
	"Answer whether dwell (hover) events are generated even when the control does not have focus.
	There is some overhead in supporting this, so it is disabled by default."

	^scFlags allMask: BackgroundDwellEvents!

isBackgroundDwellEnabled: aBoolean 
	"Set whether dwell (hover) events are generated even when the control does not have focus."

	scFlags := scFlags mask: BackgroundDwellEvents set: aBoolean.
	(aBoolean and: [self isOpen]) ifTrue: [self startDwellTimer]!

isBraceAt: anInteger 
	| style |
	style := (self styleAt: anInteger) name.
	^(self braceChars at: style ifAbsent: []) 
		ifNil: [false]
		ifNotNil: [:chars | chars identityIncludes: (self characterAt: anInteger)]!

isBraceHighlightingEnabled
	"Answer whether automatic brace highlighting is enabled in the receiver view."

	^scFlags allMask: BraceHilightingMask!

isBraceHighlightingEnabled: aBoolean 
	"Set  whether automatic brace highlighting is enabled in the receiver view.
	See also: #braceChars:"

	scFlags := scFlags mask: BraceHilightingMask set: aBoolean!

isCallTipActive
	"Is there an active call tip?"

	^(self 
		sendMessage: SCI_CALLTIPACTIVE
		wParam: 0
		lParam: 0) asBoolean!

isCaretSticky
	"Can the caret preferred x position only be changed by explicit movement commands?"

	^self sciGetCaretSticky ~= 0!

isCaretSticky: aBoolean 
	"Stop the caret preferred x position changing when the user types."

	self sciSetCaretSticky: (aBoolean ifTrue: [SC_CARETSTICKY_ON] ifFalse: [SC_CARETSTICKY_OFF])!

isCurrentLineHighlighted
	"Is the background of the line containing the caret in a different colour?"

	^(self 
		sendMessage: SCI_GETCARETLINEVISIBLE
		wParam: 0
		lParam: 0) asBoolean!

isCurrentLineHighlighted: showBoolean 
	"Display the background of the line containing the caret in a different colour."

	self 
		sendMessage: SCI_SETCARETLINEVISIBLE
		wParam: showBoolean asParameter
		lParam: 0!

isCurrentLineMarkedWith: aSymbol 
	"Answer whether the current line (i.e. the line with the caret) has the named marker."

	^self isLine: self currentLine markedWith: aSymbol!

isDrawingBuffered
	"Is drawing done first into a buffer or direct to the screen?"

	^(self 
		sendMessage: SCI_GETBUFFEREDDRAW
		wParam: 0
		lParam: 0) asBoolean!

isDrawingBuffered: bufferedBoolean 
	"If drawing is buffered then each line of text is drawn into a bitmap buffer before drawing
	it to the screen to avoid flicker."

	self 
		sendMessage: SCI_SETBUFFEREDDRAW
		wParam: bufferedBoolean asParameter
		lParam: 0!

isDrawingTwoPhase
	"Is drawing done in two phases with backgrounds drawn before faoregrounds?"

	^(self 
		sendMessage: SCI_GETTWOPHASEDRAW
		wParam: 0
		lParam: 0) asBoolean!

isDrawingTwoPhase: twoPhaseBoolean 
	"In twoPhaseDraw mode, drawing is performed in two phases, first the background and then the
	foreground. This avoids chopping off characters that overlap the next run."

	self 
		sendMessage: SCI_SETTWOPHASEDRAW
		wParam: twoPhaseBoolean asParameter
		lParam: 0!

isFoldingEnabled
	^scFlags allMask: FoldingMask!

isFoldingEnabled: aBoolean 
	"Enable or disable folding (or outlining). Enabling folding may have no effect if not supported by the lexer."

	"Implementation Note: Changing the fold enablement is rather long winded as there seem to be some bugs in Scintilla
	in this respect - also bearing in mind the importance of the fold flag it shouldn't really be a passive property."

	self isFoldingEnabled = aBoolean ifTrue: [^self].
	scFlags := scFlags mask: FoldingMask set: aBoolean.
	self setFoldProperty: aBoolean.
	aBoolean 
		ifFalse: 
			["If disabling folding it is necessary to call #removeAllStyling
			 (SCI_CLEARDOCUMENTSTYLE) as this is the only way to remove the existing
			 fold information."
			self removeAllStyling.
			"Scintilla Bug: Sometimes redraws incorrectly where word wrap is involved,
			so we need to force a call to the line wrapping code, this being one way to do that."
			self sciSetMarginLeft: self sciGetMarginLeft].
	self invalidateStyling!

isIndicator: anIntegerOrSymbol setAt: positionInteger 
	"Answer whether the indicator identified by the <integer> id or <symbol> name,
	anIntegerOrSymbol, is set at the at the one-based <integer> character position,
	positionInteger."

	^(self indicatorMaskAt: positionInteger) 
		anyMask: (1 bitShift: (self indicatorIdFromName: anIntegerOrSymbol))!

isKeyboardInputUnicode
	"Are keys always interpreted as Unicode?"

	^(self 
		sendMessage: SCI_GETKEYSUNICODE
		wParam: 0
		lParam: 0) asBoolean!

isKeyboardInputUnicode: keysUnicodeBoolean 
	"Always interpret keyboard input as Unicode"

	self 
		sendMessage: SCI_SETKEYSUNICODE
		wParam: keysUnicodeBoolean asParameter
		lParam: 0!

isLine: lineInteger folded: expandedBoolean 
	"Fold/unfold the specified header line, depending on the value of the <boolean> argument."

	self sciSetFoldExpanded: lineInteger - 1 expanded: expandedBoolean!

isLine: anInteger markedWith: aSymbol 
	"Answer whether the line in the receiver with the specified one-based <integer>
	index has the named marker."

	| def |
	def := markerDefinitions at: aSymbol ifAbsent: [].
	^def notNil and: [(self sciMarkerGet: anInteger - 1) allMask: (1 bitShift: def id)]!

isLineVisible: anInteger 
	"Answer whether the line with the specified one-based <integer> index is visible"

	^self sciGetLineVisible: anInteger - 1!

isMultiSelect
	"Whether multiple selections can be made"

	^(self 
		sendMessage: SCI_GETMULTIPLESELECTION
		wParam: 0
		lParam: 0) asBoolean!

isMultiSelect: multipleSelectionBoolean 
	"Set whether multiple selections can be made"

	self 
		sendMessage: SCI_SETMULTIPLESELECTION
		wParam: multipleSelectionBoolean asParameter
		lParam: 0!

isOvertypeEnabled
	"Returns true if overtype mode is active otherwise false is returned."

	^(self 
		sendMessage: SCI_GETOVERTYPE
		wParam: 0
		lParam: 0) asBoolean!

isOvertypeEnabled: overtypeBoolean 
	"Set to overtype (true) or insert mode."

	self 
		sendMessage: SCI_SETOVERTYPE
		wParam: overtypeBoolean asParameter
		lParam: 0!

isScrollWidthTracking
	"Retrieve whether the scroll width tracks wide lines."

	^(self 
		sendMessage: SCI_GETSCROLLWIDTHTRACKING
		wParam: 0
		lParam: 0) asBoolean!

isScrollWidthTracking: trackingBoolean 
	"Sets whether the maximum width line displayed is used to set scroll width."

	self 
		sendMessage: SCI_SETSCROLLWIDTHTRACKING
		wParam: trackingBoolean asParameter
		lParam: 0!

isSelectionBackcolorExtendedToEndOfLine
	"Is the selection end of line filled?"

	^(self 
		sendMessage: SCI_GETSELEOLFILLED
		wParam: 0
		lParam: 0) asBoolean!

isSelectionBackcolorExtendedToEndOfLine: filledBoolean 
	"Set the selection to have its end of line filled or not."

	self 
		sendMessage: SCI_SETSELEOLFILLED
		wParam: filledBoolean asParameter
		lParam: 0!

isSelectionKept
	"Answer true if the receiver is set to maintain selection even after losing focus."

	"N.B. Scintilla always displays the selection - this is not configurable."

	^true!

isSelectionRectangular
	"Is the selection rectangular? The alternative is the more common stream selection."

	^(self 
		sendMessage: SCI_SELECTIONISRECTANGLE
		wParam: 0
		lParam: 0) asBoolean!

isStylingEnabled
	"Answer whether dynamic text styling using the receiver's configured <ScintillaStyler> is enabled."

	^self sciGetLexer ~~ SCLEX_NULL!

isStylingEnabled: aBoolean 
	"Enable or disable dynamic text styling using the receiver's configured <ScintillaStyler>."

	self isStylingEnabled == aBoolean ifTrue: [^self].
	aBoolean 
		ifTrue: 
			[self sciSetLexer: SCLEX_CONTAINER.
			self invalidateStyling]
		ifFalse: 
			[self sciSetLexer: SCLEX_NULL.
			self removeAllStyling]!

isTextModified
	"Is the document different from when it was last saved?"

	^(self 
		sendMessage: SCI_GETMODIFY
		wParam: 0
		lParam: 0) asBoolean!

isTextModified: aBoolean 
	"Private - Set/reset the receiver's text modification flag."

	#todo.	"Supersend here sends EM_SETMODIFY which is deprecated from Scintilla's point of view"
	aBoolean ifTrue: [super isTextModified: aBoolean] ifFalse: [self sciSetSavePoint]!

isUndoEnabled
	"Is undo history being collected?"

	^(self 
		sendMessage: SCI_GETUNDOCOLLECTION
		wParam: 0
		lParam: 0) asBoolean!

isUndoEnabled: collectUndoBoolean 
	"Choose between collecting actions into the undo history and discarding them."

	self 
		sendMessage: SCI_SETUNDOCOLLECTION
		wParam: collectUndoBoolean asParameter
		lParam: 0!

isUsingPalette
	"In palette mode?"

	^(self 
		sendMessage: SCI_GETUSEPALETTE
		wParam: 0
		lParam: 0) asBoolean!

isUsingPalette: usePaletteBoolean 
	"In palette mode, Scintilla uses the environment's palette calls to display more colours.
	This may lead to ugly displays."

	self 
		sendMessage: SCI_SETUSEPALETTE
		wParam: usePaletteBoolean asParameter
		lParam: 0!

isUsingTabs
	"Retrieve whether tabs will be used in indentation."

	^(self 
		sendMessage: SCI_GETUSETABS
		wParam: 0
		lParam: 0) asBoolean!

isUsingTabs: useTabsBoolean 
	"Indentation will only use space characters if useTabs is false, otherwise it will use a
	combination of tabs and spaces."

	self 
		sendMessage: SCI_SETUSETABS
		wParam: useTabsBoolean asParameter
		lParam: 0!

joinTarget
	"Join the lines in the target."

	self 
		sendMessage: SCI_LINESJOIN
		wParam: 0
		lParam: 0!

keyBindings
	"Answer the collection of key bindings currently assigned in the receiver."

	^(keyBindings ifNil: [self defaultKeyBindings]) 
		asSortedCollection: [:a :b | a commandSymbol <= b commandSymbol]
	" asArray"!

keyBindings: aCollectionOfScintillaKeyBindings 
	aCollectionOfScintillaKeyBindings 
		ifNil: [keyBindings := nil]
		ifNotNil: 
			[| set |
			set := aCollectionOfScintillaKeyBindings asSet.
			(set noDifference: DefaultKeyBindings values) 
				ifFalse: 
					[keyBindings := LookupTable new.
					set do: [:each | keyBindings at: each acceleratorKey put: each]]].
	self updateKeyBindings!

keyboardCommands
	^self keyBindings collect: 
			[:each | 
			(CommandDescription command: each commandSymbol)
				acceleratorKey: each acceleratorKey;
				yourself]!

lastLineWithState
	"Answer the 1-based index of the last line with additional styling state information associated with it."

	^self sciGetMaxLineState + 1!

layoutCachingMode
	"Answer a <Symbol> naming the current layout caching mode. This will be one of: 
		#none			No lines are cached
		#caret			The line containing the text caret. This is the default.
		#page			Visible lines plus the line containing the caret.
		#document		All lines in the document.
	These correspond to the Scintilla constants SC_CACHE_NONE, SC_CACHE_CARET, 
	SC_CACHE_PAGE, SC_CACHE_DOCUMENT respectively."

	"Selection of the this mode is a trade-off between line wrap performance and memory usage:
	From the Scintilla Documentation: 'Much of the time used by Scintilla is spent on laying out
	and drawing text. The same text layout calculations may be performed many times even when
	the data used in these calculations does not change. To avoid these unnecessary calculations
	in some circumstances, the line layout cache can store the results of the calculations. The
	cache is invalidated whenever the underlying data, such as the contents or styling of the
	document changes. Caching the layout of the whole document [#document mode in Dolphin] has
	the most effect, making dynamic line wrap as much as 20 times faster but this requires 7
	times the memory required by the document contents plus around 80 bytes per line.'"    

	^self class layoutCachingModes at: self sciGetLayoutCache+1!

layoutCachingMode: aSymbol
	"Set the layout caching mode - see #layoutCachingMode for further details."

	^self sciSetLayoutCache: (self class layoutCachingModes keyAtValue: aSymbol)-1!

lexer
	"Answer the symbolic name of the lexer currently configured for the receiver.
	This is normally #container, meaning the lexing is implemented by the <ScintillaStyler>
	held in the 'styler' instance variable."

	| id |
	id := self sciGetLexer.
	^id == SCLEX_AUTOMATIC ifTrue: [#automatic] ifFalse: [Lexers at: id + 1 ifAbsent: []]!

lexer: aString 
	"Set the lexer used in the receiver to be that named by the <Symbol> argument. #container is
	a special case, meaning that lexing is performed by the <ScintillaStyler> object held in the
	'styler' instance variable, rather than by some C++ module linked into SciLexer.dll."

	"Note that switching to a particular lexer does not necessarily mean that you will get
	the same visual results as in Scite (for example) because the visual styles may not be
	configured correctly, if at all."

	| sym |
	sym := aString asSymbol.
	self lexer == sym ifTrue: [^self].
	self setLexerLanguage: sym.
	self applyTextStylesForLexer: sym!

lineCount
	"Returns the number of lines in the document. There is always at least one."

	^self 
		sendMessage: SCI_GETLINECOUNT
		wParam: 0
		lParam: 0!

lineHeight: lineInteger 
	"Retrieve the height of a particular line of text in pixels."

	^self sciTextHeight: lineInteger - 1!

lineLength: anInteger 
	"Answers the length of the line at anInteger."

	"Implementation Note: SCI_LINELENGTH includes line-terminators, which we don't want.
	See the Scintilla documentation."

	^(self lineRange: anInteger) size!

lineLengthFromPosition: anInteger 
	"Private - Answer the <integer> length of the line containing the specified one-based
	<integer> character position, charPos. Raise a <BoundsError> if the character position is
	out of bounds."

	^self lineLength: (self lineFromPosition: anInteger)!

lineNumberMargin
	"Answer the <ScintillaMargin> used to display line numbers."

	"N.B. It is assumed there is only one line-number margin in the view, so the first
	encountered is used."

	^self margins detect: [:each | each isNumbers] ifNone: []!

lineRange: anInteger 
	"Answer an <Interval> specifying the range of character positions in the receiver occuppied
	by the line with the specified <integer> index, not including the end-of-line terminators
	(if any)."

	"Implementation Note: Override to exploit specific functionality available from Scintilla"

	| start end pos |
	pos := anInteger - 1.
	start := self basicPositionAtLine: pos.
	end := self sciGetLineEndPosition: pos.
	(start < 0 or: [end < start]) ifTrue: [^self errorSubscriptBounds: anInteger].
	^start + 1 to: end!

lineScroll
	"Answers the number of the first line displayed in the receiver."

	^self sciGetFirstVisibleLine + 1!

lineScrollBy: anInteger 
	"Scrolls the text in the receiver by anInteger lines."

	self sciLineScroll: 0 lines: anInteger!

linesOnScreen
	"Retrieves the number of lines completely visible."

	^self 
		sendMessage: SCI_LINESONSCREEN
		wParam: 0
		lParam: 0!

marginCount
	"Private - Answer the maximum number of margins that can be displayed. This is currently fixed at
	three."

	^3!

margins
	"Answer a <sequencedReadableCollection> of <ScintillaMargin> containing all the receiver's
	margins."

	^(1 to: self marginCount) collect: [:index | ScintillaMargin view: self index: index - 1]!

margins: aSequenceableCollection 
	"Set the receiver's collection of margins to the <sequencedReadableCollection> of <ScintillaMargin> 
	argument."

	self applyAttributes: aSequenceableCollection!

marginStylesOffset
	"Get the start of the range of style numbers used for margin text"

	^self 
		sendMessage: SCI_MARGINGETSTYLEOFFSET
		wParam: 0
		lParam: 0!

marginStylesOffset: styleInteger 
	"Get the start of the range of style numbers used for margin text"

	self 
		sendMessage: SCI_MARGINSETSTYLEOFFSET
		wParam: styleInteger
		lParam: 0!

marginWidths
	"Private - Answer a two element <Array> containing the <integer> widths of left and right
	page margins (not the same as Scintilla 'margins')."

	^Array with: self sciGetMarginLeft with: self sciGetMarginRight!

markerDefinitions
	"Answer an <OrderedCollection> of <ScintillaMarkerDefinition>s, being the margin markers
	currently defined for this view, in ascending order of id. Each marker definition can be
	configured to use a particular glyph, such as an arrow or circle, as well as its foreground
	and background colours. The application refers to the markers it wants to use by name so
	that the visual appearance of those markers can be configured in the view. A maximum of 32
	different markers can be defined, this a limit set by Scintilla itself, however we consider
	7 of these to be predefined for use as 'folding' (outlining) markers."

	| defns |
	defns := markerDefinitions values.
	foldMarkerStyle 
		ifNotNil: 
			[defns := defns reject: 
							[:each | 
							| id |
							id := each basicId.
							id notNil and: [id between: SC_MARKNUM_FOLDEREND and: MARKER_MAX]]].
	^defns asSortedCollection: ScintillaAttribute sortByIdBlock!

markerDefinitions: aCollection 
	"Set the margin markers currently defined for this view to be those in the <Collection> of
	<ScintillaMarkerDefinition>s argument. See #markerDefinitions for further information."

	| allocated available count userIds |
	userIds := 0 to: (foldMarkerStyle ifNil: [MARKER_MAX] ifNotNil: [SC_MARKNUM_FOLDEREND - 1]).
	aCollection size > userIds size ifTrue: [^self error: 'Too many marker definitions'].
	count := aCollection size.
	allocated := OrderedCollection new: count.
	aCollection do: [:each | each basicId ifNotNil: [:id | allocated add: id]].
	available := (userIds difference: allocated) readStream.
	markerDefinitions := markerDefinitions reject: [:each | userIds includes: each basicId].
	aCollection do: 
			[:each | 
			each basicId isNil ifTrue: [each basicId: available next].
			each applyToView: self.
			markerDefinitions at: each name put: each]!

markers
	"Answer a <collection> of the <ScintillaMarker>s currently set in the receiver.
	These display as minature graphics in the margin alongside the marked lines."

	^markers!

markers: aCollection 
	"Set the markers to be displayed in the receiver's margin(s) to be those in the <collection>
	of the <ScintillaMarker>s argument."

	markers := aCollection asOrderedCollection.
	self updateMarkers!

markerTypesOnLine: anInteger 
	"Answer a <collection> of <Symbol>s, being the names of the marker types currently
	set on the line with the specified one-based <integer> index."

	| mask types |
	mask := (self sciMarkerGet: anInteger - 1) asDword.
	types := IdentitySet new.
	markerDefinitions 
		do: [:each | (mask allMask: (1 bitShift: each id)) ifTrue: [types add: each name]].
	^types!

maxCompletionListHeight
	"Set the maximum height, in rows, of auto-completion and user lists."

	^self 
		sendMessage: SCI_AUTOCGETMAXHEIGHT
		wParam: 0
		lParam: 0!

maxCompletionListHeight: rowCountInteger 
	"Set the maximum height, in rows, of auto-completion and user lists. The default is 5 rows."

	self 
		sendMessage: SCI_AUTOCSETMAXHEIGHT
		wParam: rowCountInteger
		lParam: 0!

maxCompletionListWidth
	"Get the maximum width, in characters, of auto-completion and user lists."

	^self 
		sendMessage: SCI_AUTOCGETMAXWIDTH
		wParam: 0
		lParam: 0!

maxCompletionListWidth: characterCountInteger 
	"Set the maximum width, in characters, of auto-completion and user lists. Set to 0 to
	autosize to fit longest item, which is the default."

	self 
		sendMessage: SCI_AUTOCSETMAXWIDTH
		wParam: characterCountInteger
		lParam: 0!

maxStyle
	"Answer the maximum usable style index. From Scintilla 1.75 all 8-bits can now be used for
	style bits with 0 for indicators, so this is normally 255. Styles are numbered from zero, so
	the limit on the number of styles is maxStyle+1"

	^styleMask!

modificationEventMask
	"Answer the <integer> notification event mask that controls the SCN_MODIFIED notifications that 
	the control will send. This will be a combination of the bit flags mainly in the SC_MOD_ enumeration,
	but see the Scintilla documentation for a full list and further details."

	^modificationEventMask ifNil: [self defaultModEventMask]!

modificationEventMask: anInteger 
	"Set the notification event mask that controls the SCN_MODIFIED notifications that will be sent.
	The <integer> argument is a combination of the bit flags mainly in the SC_MOD_ enumeration,
	but see the Scintilla documentation for a full list and further details."

	modificationEventMask = anInteger ifTrue: [^self].
	modificationEventMask := anInteger = self defaultModEventMask ifFalse: [anInteger].
	self sciSetModEventMask: self modificationEventMask!

modifyText: niladicBlock 
	"Evaluate the <niladicBlock> argument, which is assumed to modify the receiver's text
	content."

	"Implementation Note: Scintilla has a bug (well I consider it one) such that it refuses to
	set text if in read-only mode. This is not consistent with the normal behaviour of Windows
	text controls, which permit programmatic modifications in read-only mode. To workaround we
	must temporarily disable read-only mode when performing any operation which updates text in
	the view."

	| readOnly |
	readOnly := self isReadOnly.
	self isReadOnly: false.
	niladicBlock ensure: [self isReadOnly: readOnly]!

moveCaretInsideView
	"Move the caret inside current view if it's not there already."

	self 
		sendMessage: SCI_MOVECARETINSIDEVIEW
		wParam: 0
		lParam: 0!

moveDown
	"Move caret down one line."

	self 
		sendMessage: SCI_LINEDOWN
		wParam: 0
		lParam: 0!

moveLeft
	"Move caret left one character."

	self 
		sendMessage: SCI_CHARLEFT
		wParam: 0
		lParam: 0!

movePageDown
	"Move caret one page down."

	self 
		sendMessage: SCI_PAGEDOWN
		wParam: 0
		lParam: 0!

movePageUp
	"Move caret one page up."

	self 
		sendMessage: SCI_PAGEUP
		wParam: 0
		lParam: 0!

moveParaDown
	"Move caret between paragraphs (delimited by empty lines)."

	self 
		sendMessage: SCI_PARADOWN
		wParam: 0
		lParam: 0!

moveParaUp
	self 
		sendMessage: SCI_PARAUP
		wParam: 0
		lParam: 0!

moveRight
	"Move caret right one character."

	self 
		sendMessage: SCI_CHARRIGHT
		wParam: 0
		lParam: 0!

moveStutteredPageDown
	"Move caret to bottom of page, or one page down if already at bottom of page."

	self 
		sendMessage: SCI_STUTTEREDPAGEDOWN
		wParam: 0
		lParam: 0!

moveStutteredPageUp
	"Move caret to top of page, or one page up if already at top of page."

	self 
		sendMessage: SCI_STUTTEREDPAGEUP
		wParam: 0
		lParam: 0!

moveToEndOfDisplayLine
	"Move caret to last position on display line."

	self 
		sendMessage: SCI_LINEENDDISPLAY
		wParam: 0
		lParam: 0!

moveToEndOfDocument
	"Move caret to last position in document."

	self 
		sendMessage: SCI_DOCUMENTEND
		wParam: 0
		lParam: 0!

moveToEndOfLine
	"Move caret to last position on line."

	self 
		sendMessage: SCI_LINEEND
		wParam: 0
		lParam: 0!

moveToEndOfNextWord
	"Move caret right one word, position cursor at end of word."

	self 
		sendMessage: SCI_WORDRIGHTEND
		wParam: 0
		lParam: 0!

moveToEndOfPreviousWord
	"Move caret left one word, position cursor at end of word."

	self 
		sendMessage: SCI_WORDLEFTEND
		wParam: 0
		lParam: 0!

moveToEndOfWord
	"Move caret right one word."

	self 
		sendMessage: SCI_WORDRIGHT
		wParam: 0
		lParam: 0!

moveToEndOfWordPart
	"Move to the change next in capitalisation."

	self 
		sendMessage: SCI_WORDPARTRIGHT
		wParam: 0
		lParam: 0!

moveToEndOfWrappedLine
	self 
		sendMessage: SCI_LINEENDWRAP
		wParam: 0
		lParam: 0!

moveToStartOfDisplayLine
	"Move caret to first position on display line."

	self 
		sendMessage: SCI_HOMEDISPLAY
		wParam: 0
		lParam: 0!

moveToStartOfDocument
	"Move caret to first position in document."

	self 
		sendMessage: SCI_DOCUMENTSTART
		wParam: 0
		lParam: 0!

moveToStartOfLine
	"Move caret to first position on line."

	self 
		sendMessage: SCI_HOME
		wParam: 0
		lParam: 0!

moveToStartOfWord
	"Move caret left one word."

	self 
		sendMessage: SCI_WORDLEFT
		wParam: 0
		lParam: 0!

moveToStartOfWordPart
	"Move to the previous change in capitalisation."

	self 
		sendMessage: SCI_WORDPARTLEFT
		wParam: 0
		lParam: 0!

moveToStartOfWrappedLine
	"These are like their namesakes Home(Extend)?, LineEnd(Extend)?, VCHome(Extend)? except they
	behave differently when word-wrap is enabled: They go first to the start / end of the
	display line, like (Home|LineEnd)Display The difference is that, the cursor is already at
	the point, it goes on to the start or end of the document line, as appropriate for
	(Home|LineEnd|VCHome)(Extend)?."

	self 
		sendMessage: SCI_HOMEWRAP
		wParam: 0
		lParam: 0!

moveToVcHome
	"Move caret to before first visible character on line. If already there move to first
	character on line."

	self 
		sendMessage: SCI_VCHOME
		wParam: 0
		lParam: 0!

moveToWrappedVcHome
	self 
		sendMessage: SCI_VCHOMEWRAP
		wParam: 0
		lParam: 0!

moveUp
	"Move caret up one line."

	self 
		sendMessage: SCI_LINEUP
		wParam: 0
		lParam: 0!

multiPasteMode
	"Retrieve the effect of pasting when there are multiple selections.."

	^self class multiPasteModes at: self sciGetMultiPaste + 1 ifAbsent: [#once]!

multiPasteMode: aSymbol 
	"Set the effect of pasting when there are multiple selections.."

	^self sciSetMultiPaste: (self class multiPasteModes keyAtValue: aSymbol) - 1!

newLine
	"Insert a new line, may use a CRLF, CR or LF depending on EOL mode."

	self 
		sendMessage: SCI_NEWLINE
		wParam: 0
		lParam: 0!

nmNotify: pNMHDR 
	"Private - Handler for a redirected generic WM_NOTIFY message."

	^(ScnMap at: (pNMHDR sdwordAtOffset: 8) - 1999 ifAbsent: []) 
		ifNotNil: [:action | self perform: action with: pNMHDR]!

onEraseRequired: aColorEvent 
	"Handler for erase background event - allow the control to take care of this, unless
	transparent backcolor is set in which case the erase is suppressed.."

	"Scintilla deals with all this itself"

	^nil!

onKillFocus
	"Handler for loss of focus"

	"Implementation Note: Scintilla does not stop its caret/dwell timer when it loses focus,
	causing needless consumption of CPU (and network bandwidth if using RDC) when in the
	background. The timer is needed, however, if background dwell events are wanted."

	self isBackgroundDwellEnabled ifFalse: [self stopDwellTimer].
	^super onKillFocus!

onSetFocus
	"Handler for set focus event"

	"See #onKillFocus"

	self isBackgroundDwellEnabled ifFalse: [self startDwellTimer].
	^super onSetFocus!

onViewCreated
	"The receiver window has just been created. Populate the control with any non-default state
	preserved in instance variables."

	super onViewCreated.
	self initializeControl!

passwordCharacter
	^self shouldNotImplement!

passwordCharacter: aCharacter 
	^self shouldNotImplement!

pasteClipboard
	"Paste the contents of the clipboard into the document replacing the selection."

	self 
		sendMessage: SCI_PASTE
		wParam: 0
		lParam: 0!

performUndoableAction: aNiladicBlock 
	"Evaluate the <niladicBlock> argument as a composite update within an undo group
	such that it may be undone as a single undo operation."

	self beginUndoGroup.
	aNiladicBlock ensure: [self endUndoGroup]!

plainText
	"Answers the plain, unformatted, text from the receiver."

	| buf |
	buf := String newFixed: self textLength.
	self sciGetText: buf byteSize text: buf.
	^buf!

plainText: aString 
	"Private - Set the text contents of the receiver to the plain text aString.
	Part of the RichText double dispatching protocol"

	self modifyText: [self setText: aString]!

plainTextFrom: startInteger to: stopInteger 
	"Answer a string containing the plain text contents of the receiver in the specified
	one-based, end-inclusive, range."

	| range |
	startInteger < 1 ifTrue: [^self errorSubscriptBounds: startInteger].
	stopInteger < startInteger ifTrue: [^String new].
	stopInteger > self textLength ifTrue: [^self errorSubscriptBounds: stopInteger].
	range := TEXTRANGE from: startInteger - 1 to: stopInteger.
	self sciGetTextRange: range.
	^range text!

positionCacheSize
	"How many entries are allocated to the position cache?"

	^self 
		sendMessage: SCI_GETPOSITIONCACHE
		wParam: 0
		lParam: 0!

positionCacheSize: sizeInteger 
	"Set number of entries in position cache"

	self 
		sendMessage: SCI_SETPOSITIONCACHE
		wParam: sizeInteger
		lParam: 0!

positionOfChar: anInteger 
	"Map the one-based index of a character in the receiver to its client co-ordinates within
	the receiver."

	| pos |
	pos := anInteger - 1.
	^(self sciPointXFromPosition: pos) @ (self sciPointYFromPosition: pos)!

primarySelectionIndex
	"Answer the index of the primary selection in the array of selection ranges. Note that the
	following expression is always true:

	(self selectionRanges at: self primarySelectionIndex) = self selectionRange "

	^self sciGetMainSelection + 1!

primarySelectionIndex: anInteger 
	"Set the primary selection to be that with the specified one-based <integer> index in the array of selection ranges."

	(anInteger between: 1 and: self selectionCount) ifFalse: [^self errorSubscriptBounds: anInteger].
	self sciSetMainSelection: anInteger - 1!

printAnnotationStyleBytes: aScintillaAnnotation on: aWriteStream 
	aScintillaAnnotation styles runsAndValuesDo: 
			[:run :eachStyleName | 
			| styleId |
			styleId := (annotationStyles at: eachStyleName ifAbsent: []) 
						ifNil: [0]
						ifNotNil: [:style | style id].
			aWriteStream next: run put: styleId]!

printColourMode
	"Returns the print colour mode."

	^self 
		sendMessage: SCI_GETPRINTCOLOURMODE
		wParam: 0
		lParam: 0!

printColourMode: modeInteger 
	"Modify colours when printing for clearer printed text."

	self 
		sendMessage: SCI_SETPRINTCOLOURMODE
		wParam: modeInteger
		lParam: 0!

printMagnification
	"Returns the print magnification."

	^self 
		sendMessage: SCI_GETPRINTMAGNIFICATION
		wParam: 0
		lParam: 0!

printMagnification: magnificationInteger 
	"Sets the print magnification added to the point size of each style for printing."

	self 
		sendMessage: SCI_SETPRINTMAGNIFICATION
		wParam: magnificationInteger
		lParam: 0!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	command == #toggleStyling 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self isStylingEnabled.
			^true].
	command == #toggleLineNumbers 
		ifTrue: 
			[self lineNumberMargin 
				ifNil: [aCommandQuery isEnabled: false]
				ifNotNil: 
					[:margin | 
					aCommandQuery
						isEnabled: true;
						isChecked: margin width ~= 0].
			^true].
	command == #toggleLineEndings 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self hasVisibleLineEndings.
			^true].
	command == #toggleIndentationGuides 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self hasIndentationGuides.
			^true].
	command == #toggleWhitespace 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self whitespaceVisibility ~~ #invisible.
			^true].
	^super queryCommand: aCommandQuery!

rangeOfIndicator: anIntegerOrSymbol at: positionInteger 
	"Answer an <Interval> representing the range of one-based character positions of the
	indicator whose style is identified by the <integer> id or <symbol> name, anIntegerOrSymbol,
	that intersects with the one-based <integer> character position, positionIndicator. If the
	indicator is not set at the specified position then the interval will be empty."

	| pos |
	pos := positionInteger - 1.
	^(positionInteger > 0 and: [self isIndicator: anIntegerOrSymbol setAt: positionInteger]) 
		ifTrue: 
			[| id |
			id := self indicatorIdFromName: anIntegerOrSymbol.
			(self sciIndicatorStart: id position: pos) + 1 to: (self sciIndicatorEnd: id position: pos) + 1]
		ifFalse: 
			["The interval occuppied by the indicator that intersects the position is empty"
			positionInteger to: pos]!

redo
	"Redoes the next action on the undo history."

	self 
		sendMessage: SCI_REDO
		wParam: 0
		lParam: 0!

rememberCaretX
	"Set the last x chosen value to be the caret x position."

	self 
		sendMessage: SCI_CHOOSECARETX
		wParam: 0
		lParam: 0!

removeAllAnnotations
	"Remove all the annotations from all lines in the receiver."

	self annotations: #()!

removeAllMarkers
	"Remove all markers on all lines from the view."

	self resetMarkers.
	self deleteMarkers: 0!

removeAllStyling
	"Set all style bytes to 0, remove all folding information."

	self 
		sendMessage: SCI_CLEARDOCUMENTSTYLE
		wParam: 0
		lParam: 0!

removeAnnotation: aScintillaAnnotation 
	"Remove any annotations in the receiver matching the <ScintillaAnnotation> argument, i.e.
	any annotations on the same line, and with the same text and styles."

	| original remaining |
	original := self annotationsForLine: aScintillaAnnotation line.
	remaining := original copyWithout: aScintillaAnnotation.
	remaining size = original size 
		ifFalse: [self annotateLine: aScintillaAnnotation line withAll: remaining]!

removeAnnotationsForLine: anInteger 
	"Remove all annotations from the line with the specified one-based index."

	self 
		basicAnnotateLine: anInteger - 1
		withText: nil
		inStyles: nil.
	self invalidate!

removeBraceHighlight
	"Remove any current brace highlighting."

	self sciBraceHighlight: -1 pos2: -1!

removeKeyBinding: aScintillaKeyBinding 
	| bindings |
	bindings := self keyBindings.
	(bindings removeKey: aScintillaKeyBinding ifAbsent: []) 
		ifNotNil: 
			[:removed | 
			self sciClearCmdKey: removed scintillaKeyCode.
			keyBindings := bindings]!

removeMarker: aScintillaMarker 
	"Remove the specified <ScintillaMarker> from the view."

	markers remove: aScintillaMarker.
	self sciMarkerDeleteHandle: aScintillaMarker handle.
	aScintillaMarker removedFromView!

removeMarkersOfType: aSymbol 
	"Remove markers of the type named by the <Symbol> argument from the view."

	| markerDef |
	markerDef := markerDefinitions at: aSymbol.
	markers := markers reject: [:each | each definition == markerDef].
	self deleteMarkers: markerDef id!

removeSelections
	"Clear selections to a single empty stream selection"

	self 
		sendMessage: SCI_CLEARSELECTIONS
		wParam: 0
		lParam: 0!

removeStylingFrom: startInteger to: stopInteger 
	"Remove any styling from the specified range of text."

	"ensure: [self sciSetLayoutCache: mode]"

	self sciStartStyling: startInteger - 1 mask: self restyleMask.
	self styleNext: (stopInteger - startInteger) + 1 mask: 0!

replaceTarget: aString 
	"Replace the receiver's current target range with the plain text represented by the <String>
	argument."

	self modifyText: [self sciReplaceTarget: -1 text: aString]!

requiredLineMarginWidth
	^self widthOfText: '_' , (self lineCount max: 999) displayString inStyle: #lineNumber!

resetMarkers
	markers do: [:each | each removedFromView].
	markers := IdentitySet new!

resetZoom
	"Reset the zoom level so the text is displayed at standard size."

	self 
		sendMessage: SCI_SETZOOM
		wParam: 0
		lParam: 0!

restyleAll
	"Re-colour the entire contents of the receiver."

	self restyleFrom: 1 to: 0!

restyleFrom: startInteger to: stopInteger 
	"Restyle the specified range of text. If stopInteger is zero, then text is styled up to the
	end. Note that this is only a request. The text may be restyled asynchronously in blocks if
	it is large. In particular if lexing is performed by a <SmalltalkStyler> (i.e. container
	based lexer with Dolphin as the container), then the maximum amount of text that will be
	synchronously styled in response to this request is controlled by the #blockSize method on
	that styler."

	"Prior to 1.63 SCI_COLOURISE had no effect for container based lexing (a bug)."

	true ifTrue: [self startStylingFrom: startInteger].
	self sciColourise: startInteger - 1 end: stopInteger - 1!

restyleMask
	^styleMask bitOr: self extraStyleMask!

rotateSelection
	"Set the main selection to the next selection."

	self 
		sendMessage: SCI_ROTATESELECTION
		wParam: 0
		lParam: 0!

sciAddRefDocument: docInteger 
	"Private - Extend life of document."

	self 
		sendMessage: SCI_ADDREFDOCUMENT
		wParam: 0
		lParam: docInteger!

sciAddSelection: caretInteger anchor: anchorInteger 
	"Private - Add a selection"

	^self 
		sendMessage: SCI_ADDSELECTION
		wParam: caretInteger
		lParam: anchorInteger!

sciAddStyledText: lengthInteger c: cByteArray 
	"Private - Add array of cells to document."

	self 
		sendMessage: SCI_ADDSTYLEDTEXT
		wParam: lengthInteger
		lParam: cByteArray yourAddress!

sciAddUndoAction: tokenInteger flags: flagsInteger 
	"Private - Add a container action to the undo stack"

	self 
		sendMessage: SCI_ADDUNDOACTION
		wParam: tokenInteger
		lParam: flagsInteger!

sciAllocate: bytesInteger 
	"Private - Enlarge the document to a particular size of text bytes."

	self 
		sendMessage: SCI_ALLOCATE
		wParam: bytesInteger
		lParam: 0!

sciAnnotationGetLines: lineInteger 
	"Private - Get the number of annotation lines for a line"

	^self 
		sendMessage: SCI_ANNOTATIONGETLINES
		wParam: lineInteger
		lParam: 0!

sciAnnotationGetStyles: lineInteger styles: stylesString 
	"Private - Get the annotation styles for a line"

	^self 
		sendMessage: SCI_ANNOTATIONGETSTYLES
		wParam: lineInteger
		lParam: stylesString yourAddress!

sciAnnotationGetText: lineInteger text: textString 
	"Private - Get the annotation text for a line"

	^self 
		sendMessage: SCI_ANNOTATIONGETTEXT
		wParam: lineInteger
		lParam: textString yourAddress!

sciAnnotationGetVisible
	"Private - Get the visibility for the annotations for a view"

	^self 
		sendMessage: SCI_ANNOTATIONGETVISIBLE
		wParam: 0
		lParam: 0!

sciAnnotationSetStyles: lineInteger styles: stylesString 
	"Private - Set the annotation styles for a line"

	self 
		sendMessage: SCI_ANNOTATIONSETSTYLES
		wParam: lineInteger
		lParam: stylesString yourAddress!

sciAnnotationSetText: lineInteger text: textString 
	"Private - Set the annotation text for a line"

	self 
		sendMessage: SCI_ANNOTATIONSETTEXT
		wParam: lineInteger
		lParam: textString yourAddress!

sciAnnotationSetVisible: visibleInteger 
	"Private - Set the visibility for the annotations for a view"

	self 
		sendMessage: SCI_ANNOTATIONSETVISIBLE
		wParam: visibleInteger
		lParam: 0!

sciAppendText: lengthInteger text: textString 
	"Private - Append a string to the end of the document without changing the selection."

	self 
		sendMessage: SCI_APPENDTEXT
		wParam: lengthInteger
		lParam: textString yourAddress!

sciAssignCmdKey: kmInteger msg: msgInteger 
	"Private - When key+modifier combination km is pressed perform msg."

	self 
		sendMessage: SCI_ASSIGNCMDKEY
		wParam: kmInteger
		lParam: msgInteger!

sciAutoCGetCurrent
	"Private - Get currently selected item position in the auto-completion list"

	^self 
		sendMessage: SCI_AUTOCGETCURRENT
		wParam: 0
		lParam: 0!

sciAutoCGetCurrentText: sString 
	"Private - Get currently selected item text in the auto-completion list Returns the length
	of the item text"

	^self 
		sendMessage: SCI_AUTOCGETCURRENTTEXT
		wParam: 0
		lpParam: sString!

sciAutoCGetSeparator
	"Private - Retrieve the auto-completion list separator character."

	^self 
		sendMessage: SCI_AUTOCGETSEPARATOR
		wParam: 0
		lParam: 0!

sciAutoCGetTypeSeparator
	"Private - Retrieve the auto-completion list type-separator character."

	^self 
		sendMessage: SCI_AUTOCGETTYPESEPARATOR
		wParam: 0
		lParam: 0!

sciAutoCPosStart
	"Private - Retrieve the position of the caret when the auto-completion list was displayed."

	^self 
		sendMessage: SCI_AUTOCPOSSTART
		wParam: 0
		lParam: 0!

sciAutoCSetFillUps: characterSetString 
	"Private - Define a set of characters that when typed will cause the autocompletion to
	choose the selected item."

	self 
		sendMessage: SCI_AUTOCSETFILLUPS
		wParam: 0
		lpParam: characterSetString!

sciAutoCSetSeparator: separatorCharacterInteger 
	"Private - Change the separator character in the string setting up an auto-completion list.
	Default is space but can be changed if items contain space."

	self 
		sendMessage: SCI_AUTOCSETSEPARATOR
		wParam: separatorCharacterInteger
		lParam: 0!

sciAutoCSetTypeSeparator: separatorCharacterInteger 
	"Private - Change the type-separator character in the string setting up an auto-completion
	list. Default is '?' but can be changed if items contain '?'."

	self 
		sendMessage: SCI_AUTOCSETTYPESEPARATOR
		wParam: separatorCharacterInteger
		lParam: 0!

sciAutoCShow: lenEnteredInteger itemList: itemListString 
	"Private - Display a auto-completion list. The lenEntered parameter indicates how many
	characters before the caret should be used to provide context."

	self 
		sendMessage: SCI_AUTOCSHOW
		wParam: lenEnteredInteger
		lParam: itemListString yourAddress!

sciAutoCStops: characterSetString 
	"Private - Define a set of character that when typed cancel the auto-completion list."

	self 
		sendMessage: SCI_AUTOCSTOPS
		wParam: 0
		lpParam: characterSetString!

sciBraceBadLight: posInteger 
	"Private - Highlight the character at a position indicating there is no matching brace."

	self 
		sendMessage: SCI_BRACEBADLIGHT
		wParam: posInteger
		lParam: 0!

sciBraceHighlight: pos1Integer pos2: pos2Integer 
	"Private - Highlight the characters at two positions."

	self 
		sendMessage: SCI_BRACEHIGHLIGHT
		wParam: pos1Integer
		lParam: pos2Integer!

sciBraceMatch: posInteger 
	"Private - Find the position of a matching brace or INVALID_POSITION if no match."

	^self 
		sendMessage: SCI_BRACEMATCH
		wParam: posInteger
		lParam: 0!

sciCallTipPosStart
	"Private - Retrieve the position where the caret was before displaying the call tip."

	^self 
		sendMessage: SCI_CALLTIPPOSSTART
		wParam: 0
		lParam: 0!

sciCallTipSetBack: backRGB 
	"Private - Set the background colour for the call tip."

	self 
		sendMessage: SCI_CALLTIPSETBACK
		wParam: backRGB asParameter
		lParam: 0!

sciCallTipSetFore: foreRGB 
	"Private - Set the foreground colour for the call tip."

	self 
		sendMessage: SCI_CALLTIPSETFORE
		wParam: foreRGB asParameter
		lParam: 0!

sciCallTipSetForeHlt: foreRGB 
	"Private - Set the foreground colour for the highlighted part of the call tip."

	self 
		sendMessage: SCI_CALLTIPSETFOREHLT
		wParam: foreRGB asParameter
		lParam: 0!

sciCallTipSetHlt: startInteger end: endInteger 
	"Private - Highlight a segment of the definition."

	self 
		sendMessage: SCI_CALLTIPSETHLT
		wParam: startInteger
		lParam: endInteger!

sciCallTipShow: posInteger definition: definitionString 
	"Private - Show a call tip containing a definition near position pos."

	self 
		sendMessage: SCI_CALLTIPSHOW
		wParam: posInteger
		lParam: definitionString yourAddress!

sciCallTipUseStyle: tabSizeInteger 
	"Private - Enable use of STYLE_CALLTIP and set call tip tab size in pixels."

	self 
		sendMessage: SCI_CALLTIPUSESTYLE
		wParam: tabSizeInteger
		lParam: 0!

sciCanPaste
	"Private - Will a paste succeed?"

	^(self 
		sendMessage: SCI_CANPASTE
		wParam: 0
		lParam: 0) asBoolean!

sciChangeLexerState: startInteger end: endInteger 
	"Private - Indicate that the internal state of a lexer has changed over a range and
	therefore there may be a need to redraw."

	^self 
		sendMessage: SCI_CHANGELEXERSTATE
		wParam: startInteger
		lParam: endInteger!

sciCharPositionFromPoint: xInteger y: yInteger 
	"Private - Find the position of a character from a point within the window."

	^self 
		sendMessage: SCI_CHARPOSITIONFROMPOINT
		wParam: xInteger
		lParam: yInteger!

sciCharPositionFromPointClose: xInteger y: yInteger 
	"Private - Find the position of a character from a point within the window. Return
	INVALID_POSITION if not close to text."

	^self 
		sendMessage: SCI_CHARPOSITIONFROMPOINTCLOSE
		wParam: xInteger
		lParam: yInteger!

sciClearAllCmdKeys
	"Private - Drop all key mappings."

	self 
		sendMessage: SCI_CLEARALLCMDKEYS
		wParam: 0
		lParam: 0!

sciClearCmdKey: kmInteger 
	"Private - When key+modifier combination km is pressed do nothing."

	self 
		sendMessage: SCI_CLEARCMDKEY
		wParam: kmInteger
		lParam: 0!

sciColourise: startInteger end: endInteger 
	"Private - Colourise a segment of the document using the current lexing language."

	self 
		sendMessage: SCI_COLOURISE
		wParam: startInteger
		lParam: endInteger!

sciContractedFoldNext: lineStartInteger 
	"Private - Find the next line at or after lineStart that is a contracted fold header line.
	Return -1 when no more lines."

	^self 
		sendMessage: SCI_CONTRACTEDFOLDNEXT
		wParam: lineStartInteger
		lParam: 0!

sciConvertEOLs: eolModeInteger 
	"Private - Convert all line endings in the document to one mode."

	self 
		sendMessage: SCI_CONVERTEOLS
		wParam: eolModeInteger
		lParam: 0!

sciCopyRange: startInteger end: endInteger 
	"Private - Copy a range of text to the clipboard. Positions are clipped into the document."

	self 
		sendMessage: SCI_COPYRANGE
		wParam: startInteger
		lParam: endInteger!

sciCreateDocument
	"Private - Create a new document object. Starts with reference count of 1 and not selected
	into editor."

	^self 
		sendMessage: SCI_CREATEDOCUMENT
		wParam: 0
		lParam: 0!

sciDescribeKeyWordSets: descriptionsString 
	"Private - Retrieve a '\n' separated list of descriptions of the keyword sets understood by
	the current lexer."

	^self 
		sendMessage: SCI_DESCRIBEKEYWORDSETS
		wParam: 0
		lpParam: descriptionsString!

sciDescribeProperty: nameString description: descriptionString 
	"Private - Describe a property."

	^self 
		sendMessage: SCI_DESCRIBEPROPERTY
		wParam: nameString yourAddress
		lParam: descriptionString yourAddress!

sciDocLineFromVisible: lineDisplayInteger 
	"Private - Find the document line of a display line taking hidden lines into account."

	^self 
		sendMessage: SCI_DOCLINEFROMVISIBLE
		wParam: lineDisplayInteger
		lParam: 0!

sciEncodedFromUTF8: utf8String encoded: encodedString 
	"Private - Translates a UTF8 string into the document encoding. Return the length of the
	result in bytes. On error return 0."

	^self 
		sendMessage: SCI_ENCODEDFROMUTF8
		wParam: utf8String yourAddress
		lParam: encodedString yourAddress!

sciEnsureVisible: lineInteger 
	"Private - Ensure a particular line is visible by expanding any header line hiding it."

	self 
		sendMessage: SCI_ENSUREVISIBLE
		wParam: lineInteger
		lParam: 0!

sciEnsureVisibleEnforcePolicy: lineInteger 
	"Private - Ensure a particular line is visible by expanding any header line hiding it. Use
	the currently set visibility policy to determine which range to display."

	self 
		sendMessage: SCI_ENSUREVISIBLEENFORCEPOLICY
		wParam: lineInteger
		lParam: 0!

sciFindColumn: lineInteger column: columnInteger 
	"Private - Find the position of a column on a line taking into account tabs and multi-byte
	characters. If beyond end of line, return line end position."

	^self 
		sendMessage: SCI_FINDCOLUMN
		wParam: lineInteger
		lParam: columnInteger!

sciFindText: flagsInteger ft: ftFINDTEXT 
	"Private - Find some text in the document."

	^self 
		sendMessage: SCI_FINDTEXT
		wParam: flagsInteger
		lParam: ftFINDTEXT yourAddress!

sciFormatRange: drawBoolean fr: frFORMATRANGE 
	"Private - On Windows, will draw the document into a display context such as a printer."

	^self 
		sendMessage: SCI_FORMATRANGE
		wParam: drawBoolean asParameter
		lParam: frFORMATRANGE yourAddress!

sciGetAdditionalSelectionTyping
	"Private - Whether typing can be performed into multiple selections"

	^(self 
		sendMessage: SCI_GETADDITIONALSELECTIONTYPING
		wParam: 0
		lParam: 0) asBoolean!

sciGetAnchor
	"Private - Returns the position of the opposite end of the selection to the caret."

	^self 
		sendMessage: SCI_GETANCHOR
		wParam: 0
		lParam: 0!

sciGetCaretSticky
	"Private - Can the caret preferred x position only be changed by explicit movement
	commands?"

	^self 
		sendMessage: SCI_GETCARETSTICKY
		wParam: 0
		lParam: 0!

sciGetCaretStyle
	"Private - Returns the current style of the caret."

	^self 
		sendMessage: SCI_GETCARETSTYLE
		wParam: 0
		lParam: 0!

sciGetCharacterPointer
	"Private - Compact the document buffer and return a read-only pointer to the characters in
	the document."

	^self 
		sendMessage: SCI_GETCHARACTERPOINTER
		wParam: 0
		lParam: 0!

sciGetCodePage
	"Private - Get the code page used to interpret the bytes of the document as characters."

	^self 
		sendMessage: SCI_GETCODEPAGE
		wParam: 0
		lParam: 0!

sciGetColumn: posInteger 
	"Private - Retrieve the column number of a position, taking tab width into account."

	^self 
		sendMessage: SCI_GETCOLUMN
		wParam: posInteger
		lParam: 0!

sciGetControlCharSymbol
	"Private - Get the way control characters are displayed."

	^self 
		sendMessage: SCI_GETCONTROLCHARSYMBOL
		wParam: 0
		lParam: 0!

sciGetCurLine: lengthInteger text: textString 
	"Private - Retrieve the text of the line containing the caret. Returns the index of the
	caret on the line."

	^self 
		sendMessage: SCI_GETCURLINE
		wParam: lengthInteger
		lParam: textString yourAddress!

sciGetCurrentPos
	"Private - Returns the position of the caret."

	^self 
		sendMessage: SCI_GETCURRENTPOS
		wParam: 0
		lParam: 0!

sciGetDocPointer
	"Private - Retrieve a pointer to the document object."

	^self 
		sendMessage: SCI_GETDOCPOINTER
		wParam: 0
		lParam: 0!

sciGetEdgeColumn
	"Private - Retrieve the column number which text should be kept within."

	^self 
		sendMessage: SCI_GETEDGECOLUMN
		wParam: 0
		lParam: 0!

sciGetEdgeMode
	"Private - Retrieve the edge highlight mode."

	^self 
		sendMessage: SCI_GETEDGEMODE
		wParam: 0
		lParam: 0!

sciGetEndAtLastLine
	"Private - Retrieve whether the maximum scroll position has the last line at the bottom of
	the view."

	^(self 
		sendMessage: SCI_GETENDATLASTLINE
		wParam: 0
		lParam: 0) asBoolean!

sciGetEndStyled
	"Private - Retrieve the position of the last correctly styled character."

	^self 
		sendMessage: SCI_GETENDSTYLED
		wParam: 0
		lParam: 0!

sciGetEOLMode
	"Private - Retrieve the current end of line mode - one of CRLF, CR, or LF."

	^self 
		sendMessage: SCI_GETEOLMODE
		wParam: 0
		lParam: 0!

sciGetFirstVisibleLine
	"Private - Retrieve the display line at the top of the display."

	^self 
		sendMessage: SCI_GETFIRSTVISIBLELINE
		wParam: 0
		lParam: 0!

sciGetFoldExpanded: lineInteger 
	"Private - Is a header line expanded?"

	^(self 
		sendMessage: SCI_GETFOLDEXPANDED
		wParam: lineInteger
		lParam: 0) asBoolean!

sciGetFoldLevel: lineInteger 
	"Private - Retrieve the fold level of a line."

	^self 
		sendMessage: SCI_GETFOLDLEVEL
		wParam: lineInteger
		lParam: 0!

sciGetFoldParent: lineInteger 
	"Private - Find the parent line of a child line."

	^self 
		sendMessage: SCI_GETFOLDPARENT
		wParam: lineInteger
		lParam: 0!

sciGetFontQuality
	"Private - Retrieve the quality level for text."

	^self 
		sendMessage: SCI_GETFONTQUALITY
		wParam: 0
		lParam: 0!

sciGetIndentationGuides
	"Private - Are the indentation guides visible?"

	^self 
		sendMessage: SCI_GETINDENTATIONGUIDES
		wParam: 0
		lParam: 0!

sciGetLastChild: lineInteger level: levelInteger 
	"Private - Find the last child line of a header line."

	^self 
		sendMessage: SCI_GETLASTCHILD
		wParam: lineInteger
		lParam: levelInteger!

sciGetLayoutCache
	"Private - Retrieve the degree of caching of layout information."

	^self 
		sendMessage: SCI_GETLAYOUTCACHE
		wParam: 0
		lParam: 0!

sciGetLexer
	"Private - Retrieve the lexing language of the document."

	^self 
		sendMessage: SCI_GETLEXER
		wParam: 0
		lParam: 0!

sciGetLexerLanguage: textString 
	"Private - Retrieve the name of the lexer. Return the length of the text."

	^self 
		sendMessage: SCI_GETLEXERLANGUAGE
		wParam: 0
		lpParam: textString!

sciGetLine: lineInteger text: textString 
	"Private - Retrieve the contents of a line. Returns the length of the line."

	^self 
		sendMessage: SCI_GETLINE
		wParam: lineInteger
		lParam: textString yourAddress!

sciGetLineEndPosition: lineInteger 
	"Private - Get the position after the last visible characters on a line."

	^self 
		sendMessage: SCI_GETLINEENDPOSITION
		wParam: lineInteger
		lParam: 0!

sciGetLineIndentation: lineInteger 
	"Private - Retrieve the number of columns that a line is indented."

	^self 
		sendMessage: SCI_GETLINEINDENTATION
		wParam: lineInteger
		lParam: 0!

sciGetLineIndentPosition: lineInteger 
	"Private - Retrieve the position before the first non indentation character on a line."

	^self 
		sendMessage: SCI_GETLINEINDENTPOSITION
		wParam: lineInteger
		lParam: 0!

sciGetLineSelEndPosition: lineInteger 
	"Private - Retrieve the position of the end of the selection at the given line
	(INVALID_POSITION if no selection on this line)."

	^self 
		sendMessage: SCI_GETLINESELENDPOSITION
		wParam: lineInteger
		lParam: 0!

sciGetLineSelStartPosition: lineInteger 
	"Private - Retrieve the position of the start of the selection at the given line
	(INVALID_POSITION if no selection on this line)."

	^self 
		sendMessage: SCI_GETLINESELSTARTPOSITION
		wParam: lineInteger
		lParam: 0!

sciGetLineState: lineInteger 
	"Private - Retrieve the extra styling information for a line."

	^self 
		sendMessage: SCI_GETLINESTATE
		wParam: lineInteger
		lParam: 0!

sciGetLineVisible: lineInteger 
	"Private - Is a line visible?"

	^(self 
		sendMessage: SCI_GETLINEVISIBLE
		wParam: lineInteger
		lParam: 0) asBoolean!

sciGetMainSelection
	"Private - Which selection is the main selection"

	^self 
		sendMessage: SCI_GETMAINSELECTION
		wParam: 0
		lParam: 0!

sciGetMarginLeft
	"Private - Returns the size in pixels of the left margin."

	^self 
		sendMessage: SCI_GETMARGINLEFT
		wParam: 0
		lParam: 0!

sciGetMarginRight
	"Private - Returns the size in pixels of the right margin."

	^self 
		sendMessage: SCI_GETMARGINRIGHT
		wParam: 0
		lParam: 0!

sciGetMaxLineState
	"Private - Retrieve the last line number that has line state."

	^self 
		sendMessage: SCI_GETMAXLINESTATE
		wParam: 0
		lParam: 0!

sciGetMultiPaste
	"Private - Retrieve the effect of pasting when there are multiple selections.."

	^self 
		sendMessage: SCI_GETMULTIPASTE
		wParam: 0
		lParam: 0!

sciGetPasteConvertEndings
	"Private - Get convert-on-paste setting"

	^(self 
		sendMessage: SCI_GETPASTECONVERTENDINGS
		wParam: 0
		lParam: 0) asBoolean!

sciGetPrintWrapMode
	"Private - Is printing line wrapped?"

	^self 
		sendMessage: SCI_GETPRINTWRAPMODE
		wParam: 0
		lParam: 0!

sciGetProperty: keyString buf: bufString 
	"Private - Retrieve a 'property' value previously set with SetProperty."

	^self 
		sendMessage: SCI_GETPROPERTY
		wParam: keyString yourAddress
		lParam: bufString yourAddress!

sciGetPropertyExpanded: keyString buf: bufString 
	"Private - Retrieve a 'property' value previously set with SetProperty, with '$()' variable
	replacement on returned buffer."

	^self 
		sendMessage: SCI_GETPROPERTYEXPANDED
		wParam: keyString yourAddress
		lParam: bufString yourAddress!

sciGetPropertyInt: keyString 
	"Private - Retrieve a 'property' value previously set with SetProperty, interpreted as an
	int AFTER any '$()' variable replacement."

	^self 
		sendMessage: SCI_GETPROPERTYINT
		wParam: keyString yourAddress
		lParam: 0!

sciGetRectangularSelectionAnchor
	^self 
		sendMessage: SCI_GETRECTANGULARSELECTIONANCHOR
		wParam: 0
		lParam: 0!

sciGetRectangularSelectionAnchorVirtualSpace
	^self 
		sendMessage: SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE
		wParam: 0
		lParam: 0!

sciGetRectangularSelectionCaret
	^self 
		sendMessage: SCI_GETRECTANGULARSELECTIONCARET
		wParam: 0
		lParam: 0!

sciGetRectangularSelectionCaretVirtualSpace
	^self 
		sendMessage: SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE
		wParam: 0
		lParam: 0!

sciGetSearchFlags
	"Private - Get the search flags used by SearchInTarget."

	^self 
		sendMessage: SCI_GETSEARCHFLAGS
		wParam: 0
		lParam: 0!

sciGetSelectionEnd
	"Private - Returns the position at the end of the selection."

	^self 
		sendMessage: SCI_GETSELECTIONEND
		wParam: 0
		lParam: 0!

sciGetSelectionMode
	"Private - Get the mode of the current selection."

	^self 
		sendMessage: SCI_GETSELECTIONMODE
		wParam: 0
		lParam: 0!

sciGetSelectionNAnchor: selectionInteger 
	^self 
		sendMessage: SCI_GETSELECTIONNANCHOR
		wParam: selectionInteger
		lParam: 0!

sciGetSelectionNAnchorVirtualSpace: selectionInteger 
	^self 
		sendMessage: SCI_GETSELECTIONNANCHORVIRTUALSPACE
		wParam: selectionInteger
		lParam: 0!

sciGetSelectionNCaret: selectionInteger 
	^self 
		sendMessage: SCI_GETSELECTIONNCARET
		wParam: selectionInteger
		lParam: 0!

sciGetSelectionNCaretVirtualSpace: selectionInteger 
	^self 
		sendMessage: SCI_GETSELECTIONNCARETVIRTUALSPACE
		wParam: selectionInteger
		lParam: 0!

sciGetSelectionNEnd: selectionInteger 
	"Private - Returns the position at the end of the selection."

	^self 
		sendMessage: SCI_GETSELECTIONNEND
		wParam: selectionInteger
		lParam: 0!

sciGetSelectionNStart: selectionInteger 
	"Private - Returns the position at the start of the selection."

	^self 
		sendMessage: SCI_GETSELECTIONNSTART
		wParam: selectionInteger
		lParam: 0!

sciGetSelectionStart
	"Private - Returns the position at the start of the selection."

	^self 
		sendMessage: SCI_GETSELECTIONSTART
		wParam: 0
		lParam: 0!

sciGetSelText: textString 
	"Private - Retrieve the selected text. Return the length of the text."

	^self 
		sendMessage: SCI_GETSELTEXT
		wParam: 0
		lpParam: textString!

sciGetStyleBits
	"Private - Retrieve number of bits in style bytes used to hold the lexical state."

	^self 
		sendMessage: SCI_GETSTYLEBITS
		wParam: 0
		lParam: 0!

sciGetStyleBitsNeeded
	"Private - Retrieve the number of bits the current lexer needs for styling."

	^self 
		sendMessage: SCI_GETSTYLEBITSNEEDED
		wParam: 0
		lParam: 0!

sciGetStyledText: trTEXTRANGE 
	"Private - Retrieve a buffer of cells. Returns the number of bytes in the buffer not
	including terminating NULs."

	^self 
		sendMessage: SCI_GETSTYLEDTEXT
		wParam: 0
		lpParam: trTEXTRANGE!

sciGetTag: tagNumberInteger tagValue: tagValueString 
	"Private - Retrieve the value of a tag from a regular expression search."

	^self 
		sendMessage: SCI_GETTAG
		wParam: tagNumberInteger
		lParam: tagValueString yourAddress!

sciGetTargetEnd
	"Private - Get the position that ends the target."

	^self 
		sendMessage: SCI_GETTARGETEND
		wParam: 0
		lParam: 0!

sciGetTargetStart
	"Private - Get the position that starts the target."

	^self 
		sendMessage: SCI_GETTARGETSTART
		wParam: 0
		lParam: 0!

sciGetText: lengthInteger text: textString 
	"Private - Retrieve all the text in the document. Returns number of characters retrieved."

	^self 
		sendMessage: SCI_GETTEXT
		wParam: lengthInteger
		lParam: textString yourAddress!

sciGetTextRange: trTEXTRANGE 
	"Private - Retrieve a range of text. Return the length of the text."

	^self 
		sendMessage: SCI_GETTEXTRANGE
		wParam: 0
		lpParam: trTEXTRANGE!

sciGetVirtualSpaceOptions
	^self 
		sendMessage: SCI_GETVIRTUALSPACEOPTIONS
		wParam: 0
		lParam: 0!

sciGetWrapIndentMode
	"Private - Retrieve how wrapped sublines are placed. Default is fixed."

	^self 
		sendMessage: SCI_GETWRAPINDENTMODE
		wParam: 0
		lParam: 0!

sciGetWrapMode
	"Private - Retrieve whether text is word wrapped."

	^self 
		sendMessage: SCI_GETWRAPMODE
		wParam: 0
		lParam: 0!

sciGetWrapVisualFlags
	"Private - Retrive the display mode of visual flags for wrapped lines."

	^self 
		sendMessage: SCI_GETWRAPVISUALFLAGS
		wParam: 0
		lParam: 0!

sciGetWrapVisualFlagsLocation
	"Private - Retrive the location of visual flags for wrapped lines."

	^self 
		sendMessage: SCI_GETWRAPVISUALFLAGSLOCATION
		wParam: 0
		lParam: 0!

sciGotoLine: lineInteger 
	"Private - Set caret to start of a line and ensure it is visible."

	self 
		sendMessage: SCI_GOTOLINE
		wParam: lineInteger
		lParam: 0!

sciGotoPos: posInteger 
	"Private - Set caret to a position and ensure it is visible."

	self 
		sendMessage: SCI_GOTOPOS
		wParam: posInteger
		lParam: 0!

sciHideLines: lineStartInteger lineEnd: lineEndInteger 
	"Private - Make a range of lines invisible."

	self 
		sendMessage: SCI_HIDELINES
		wParam: lineStartInteger
		lParam: lineEndInteger!

sciIndicatorAllOnFor: positionInteger 
	"Private - Are any indicators present at position?"

	^self 
		sendMessage: SCI_INDICATORALLONFOR
		wParam: positionInteger
		lParam: 0!

sciIndicatorClearRange: positionInteger clearLength: clearLengthInteger 
	"Private - Turn a indicator off over a range."

	self 
		sendMessage: SCI_INDICATORCLEARRANGE
		wParam: positionInteger
		lParam: clearLengthInteger!

sciIndicatorEnd: indicatorInteger position: positionInteger 
	"Private - Where does a particular indicator end?"

	^self 
		sendMessage: SCI_INDICATOREND
		wParam: indicatorInteger
		lParam: positionInteger!

sciIndicatorFillRange: positionInteger fillLength: fillLengthInteger 
	"Private - Turn a indicator on over a range."

	self 
		sendMessage: SCI_INDICATORFILLRANGE
		wParam: positionInteger
		lParam: fillLengthInteger!

sciIndicatorStart: indicatorInteger position: positionInteger 
	"Private - Where does a particular indicator start?"

	^self 
		sendMessage: SCI_INDICATORSTART
		wParam: indicatorInteger
		lParam: positionInteger!

sciIndicatorValueAt: indicatorInteger position: positionInteger 
	"Private - What value does a particular indicator have at at a position?"

	^self 
		sendMessage: SCI_INDICATORVALUEAT
		wParam: indicatorInteger
		lParam: positionInteger!

sciInsertText: posInteger text: textString 
	"Private - Insert string at a position."

	self 
		sendMessage: SCI_INSERTTEXT
		wParam: posInteger
		lParam: textString yourAddress!

sciLineScroll: columnsInteger lines: linesInteger 
	"Private - Scroll horizontally and vertically."

	self 
		sendMessage: SCI_LINESCROLL
		wParam: columnsInteger
		lParam: linesInteger!

sciLoadLexerLibrary: pathString 
	"Private - Load a lexer library (dll / so)."

	self 
		sendMessage: SCI_LOADLEXERLIBRARY
		wParam: 0
		lpParam: pathString!

sciMarginGetStyle: lineInteger 
	"Private - Get the style number for the text margin for a line"

	^self 
		sendMessage: SCI_MARGINGETSTYLE
		wParam: lineInteger
		lParam: 0!

sciMarginGetStyles: lineInteger styles: stylesString 
	"Private - Get the styles in the text margin for a line"

	^self 
		sendMessage: SCI_MARGINGETSTYLES
		wParam: lineInteger
		lParam: stylesString yourAddress!

sciMarginGetText: lineInteger text: textString 
	"Private - Get the text in the text margin for a line"

	^self 
		sendMessage: SCI_MARGINGETTEXT
		wParam: lineInteger
		lParam: textString yourAddress!

sciMarginSetStyle: lineInteger style: styleInteger 
	"Private - Set the style number for the text margin for a line"

	self 
		sendMessage: SCI_MARGINSETSTYLE
		wParam: lineInteger
		lParam: styleInteger!

sciMarginSetStyles: lineInteger styles: stylesString 
	"Private - Set the style in the text margin for a line"

	self 
		sendMessage: SCI_MARGINSETSTYLES
		wParam: lineInteger
		lParam: stylesString yourAddress!

sciMarginSetText: lineInteger text: textString 
	"Private - Set the text in the text margin for a line"

	self 
		sendMessage: SCI_MARGINSETTEXT
		wParam: lineInteger
		lParam: textString yourAddress!

sciMarginTextClearAll
	"Private - Clear the margin text on all lines"

	self 
		sendMessage: SCI_MARGINTEXTCLEARALL
		wParam: 0
		lParam: 0!

sciMarkerAddSet: lineInteger set: setInteger 
	"Private - Add a set of markers to a line."

	self 
		sendMessage: SCI_MARKERADDSET
		wParam: lineInteger
		lParam: setInteger!

sciMarkerDefinePixmap: markerNumberInteger pixmap: pixmapString 
	"Private - Define a marker from a pixmap."

	self 
		sendMessage: SCI_MARKERDEFINEPIXMAP
		wParam: markerNumberInteger
		lParam: pixmapString yourAddress!

sciMarkerDeleteHandle: handleInteger 
	"Private - Delete a marker."

	self 
		sendMessage: SCI_MARKERDELETEHANDLE
		wParam: handleInteger
		lParam: 0!

sciMarkerGet: lineInteger 
	"Private - Get a bit mask of all the markers set on a line."

	^self 
		sendMessage: SCI_MARKERGET
		wParam: lineInteger
		lParam: 0!

sciMarkerLineFromHandle: handleInteger 
	"Private - Retrieve the line number at which a particular marker is located."

	^self 
		sendMessage: SCI_MARKERLINEFROMHANDLE
		wParam: handleInteger
		lParam: 0!

sciMarkerNext: lineStartInteger markerMask: markerMaskInteger 
	"Private - Find the next line at or after lineStart that includes a marker in mask. Return
	-1 when no more lines."

	^self 
		sendMessage: SCI_MARKERNEXT
		wParam: lineStartInteger
		lParam: markerMaskInteger!

sciMarkerPrevious: lineStartInteger markerMask: markerMaskInteger 
	"Private - Find the previous line before lineStart that includes a marker in mask."

	^self 
		sendMessage: SCI_MARKERPREVIOUS
		wParam: lineStartInteger
		lParam: markerMaskInteger!

sciMarkerSetAlpha: markerNumberInteger alpha: alphaInteger 
	"Private - Set the alpha used for a marker that is drawn in the text area, not the margin."

	self 
		sendMessage: SCI_MARKERSETALPHA
		wParam: markerNumberInteger
		lParam: alphaInteger!

sciMarkerSymbolDefined: markerNumberInteger 
	"Private - Which symbol was defined for markerNumber with MarkerDefine"

	^self 
		sendMessage: SCI_MARKERSYMBOLDEFINED
		wParam: markerNumberInteger
		lParam: 0!

sciPointXFromPosition: posInteger 
	"Private - Retrieve the x value of the point in the window where a position is displayed."

	^self 
		sendMessage: SCI_POINTXFROMPOSITION
		wParam: 0
		lParam: posInteger!

sciPointYFromPosition: posInteger 
	"Private - Retrieve the y value of the point in the window where a position is displayed."

	^self 
		sendMessage: SCI_POINTYFROMPOSITION
		wParam: 0
		lParam: posInteger!

sciPositionAfter: posInteger 
	"Private - Given a valid document position, return the next position taking code page into
	account. Maximum value returned is the last position in the document."

	^self 
		sendMessage: SCI_POSITIONAFTER
		wParam: posInteger
		lParam: 0!

sciPositionBefore: posInteger 
	"Private - Given a valid document position, return the previous position taking code page
	into account. Returns 0 if passed 0."

	^self 
		sendMessage: SCI_POSITIONBEFORE
		wParam: posInteger
		lParam: 0!

sciPositionFromPoint: xInteger y: yInteger 
	"Private - Find the position from a point within the window."

	^self 
		sendMessage: SCI_POSITIONFROMPOINT
		wParam: xInteger
		lParam: yInteger!

sciPositionFromPointClose: xInteger y: yInteger 
	"Private - Find the position from a point within the window but return INVALID_POSITION if
	not close to text."

	^self 
		sendMessage: SCI_POSITIONFROMPOINTCLOSE
		wParam: xInteger
		lParam: yInteger!

sciPrivateLexerCall: operationInteger pointer: pointerInteger 
	"Private - For private communication between an application and a known lexer."

	^self 
		sendMessage: SCI_PRIVATELEXERCALL
		wParam: operationInteger
		lParam: pointerInteger!

sciPropertyNames: namesString 
	"Private - Retrieve a '\n' separated list of properties understood by the current lexer."

	^self 
		sendMessage: SCI_PROPERTYNAMES
		wParam: 0
		lpParam: namesString!

sciPropertyType: nameString 
	"Private - Retrieve the type of a property."

	^self 
		sendMessage: SCI_PROPERTYTYPE
		wParam: nameString yourAddress
		lParam: 0!

sciRegisterImage: typeInteger xpmData: xpmDataString 
	"Private - Register an XPM image for use in autocompletion lists."

	self 
		sendMessage: SCI_REGISTERIMAGE
		wParam: typeInteger
		lParam: xpmDataString yourAddress!

sciReleaseDocument: docInteger 
	"Private - Release a reference to the document, deleting document if it fades to black."

	self 
		sendMessage: SCI_RELEASEDOCUMENT
		wParam: 0
		lParam: docInteger!

sciReplaceSel: textString 
	"Private - Replace the selected text with the argument text."

	self 
		sendMessage: SCI_REPLACESEL
		wParam: 0
		lpParam: textString!

sciReplaceTarget: lengthInteger text: textString 
	"Private - Replace the target text with the argument text. Text is counted so it can contain
	NULs. Returns the length of the replacement text."

	^self 
		sendMessage: SCI_REPLACETARGET
		wParam: lengthInteger
		lParam: textString yourAddress!

sciReplaceTargetRE: lengthInteger text: textString 
	"Private - Replace the target text with the argument text after \d processing. Text is
	counted so it can contain NULs. Looks for \d where d is between 1 and 9 and replaces these
	with the strings matched in the last search operation which were surrounded by \( and \).
	Returns the length of the replacement text including any change caused by processing the \d
	patterns."

	^self 
		sendMessage: SCI_REPLACETARGETRE
		wParam: lengthInteger
		lParam: textString yourAddress!

sciSearchAnchor
	"Private - Sets the current caret position to be the search anchor."

	self 
		sendMessage: SCI_SEARCHANCHOR
		wParam: 0
		lParam: 0!

sciSearchInTarget: lengthInteger text: textString 
	"Private - Search for a counted string in the target and set the target to the found range.
	Text is counted so it can contain NULs. Returns length of range or -1 for failure in which
	case target is not moved."

	^self 
		sendMessage: SCI_SEARCHINTARGET
		wParam: lengthInteger
		lParam: textString yourAddress!

sciSearchNext: flagsInteger text: textString 
	"Private - Find some text starting at the search anchor. Does not ensure the selection is
	visible."

	^self 
		sendMessage: SCI_SEARCHNEXT
		wParam: flagsInteger
		lParam: textString yourAddress!

sciSearchPrev: flagsInteger text: textString 
	"Private - Find some text starting at the search anchor and moving backwards. Does not
	ensure the selection is visible."

	^self 
		sendMessage: SCI_SEARCHPREV
		wParam: flagsInteger
		lParam: textString yourAddress!

sciSetAdditionalCaretFore: foreRGB 
	"Private - Set the foreground colour of additional carets."

	self 
		sendMessage: SCI_SETADDITIONALCARETFORE
		wParam: foreRGB asParameter
		lParam: 0!

sciSetAdditionalSelBack: backRGB 
	"Private - Set the background colour of additional selections. Must have previously called
	SetSelBack with non-zero first argument for this to have an effect."

	self 
		sendMessage: SCI_SETADDITIONALSELBACK
		wParam: backRGB asParameter
		lParam: 0!

sciSetAdditionalSelectionTyping: additionalSelectionTypingBoolean 
	"Private - Set whether typing can be performed into multiple selections"

	self 
		sendMessage: SCI_SETADDITIONALSELECTIONTYPING
		wParam: additionalSelectionTypingBoolean asParameter
		lParam: 0!

sciSetAdditionalSelFore: foreRGB 
	"Private - Set the foreground colour of additional selections. Must have previously called
	SetSelFore with non-zero first argument for this to have an effect."

	self 
		sendMessage: SCI_SETADDITIONALSELFORE
		wParam: foreRGB asParameter
		lParam: 0!

sciSetAnchor: posAnchorInteger 
	"Private - Set the selection anchor to a position. The anchor is the opposite end of the
	selection from the caret."

	self 
		sendMessage: SCI_SETANCHOR
		wParam: posAnchorInteger
		lParam: 0!

sciSetCaretFore: foreRGB 
	"Private - Set the foreground colour of the caret."

	self 
		sendMessage: SCI_SETCARETFORE
		wParam: foreRGB asParameter
		lParam: 0!

sciSetCaretLineBack: backRGB 
	"Private - Set the colour of the background of the line containing the caret."

	self 
		sendMessage: SCI_SETCARETLINEBACK
		wParam: backRGB asParameter
		lParam: 0!

sciSetCaretSticky: useCaretStickyBehaviourInteger 
	"Private - Stop the caret preferred x position changing when the user types."

	self 
		sendMessage: SCI_SETCARETSTICKY
		wParam: useCaretStickyBehaviourInteger
		lParam: 0!

sciSetCaretStyle: caretStyleInteger 
	"Private - Set the style of the caret to be drawn."

	self 
		sendMessage: SCI_SETCARETSTYLE
		wParam: caretStyleInteger
		lParam: 0!

sciSetCaretWidth: pixelWidthInteger 
	"Private - Set the width of the insert mode caret."

	self 
		sendMessage: SCI_SETCARETWIDTH
		wParam: pixelWidthInteger
		lParam: 0!

sciSetCharsDefault
	"Private - Reset the set of characters for whitespace and word characters to the defaults."

	self 
		sendMessage: SCI_SETCHARSDEFAULT
		wParam: 0
		lParam: 0!

sciSetCodePage: codePageInteger 
	"Private - Set the code page used to interpret the bytes of the document as characters. The
	SC_CP_UTF8 value can be used to enter Unicode mode."

	self 
		sendMessage: SCI_SETCODEPAGE
		wParam: codePageInteger
		lParam: 0!

sciSetControlCharSymbol: symbolInteger 
	"Private - Change the way control characters are displayed: If symbol is < 32, keep the
	drawn way, else, use the given character."

	self 
		sendMessage: SCI_SETCONTROLCHARSYMBOL
		wParam: symbolInteger
		lParam: 0!

sciSetDocPointer: pointerInteger 
	"Private - Change the document object used."

	self 
		sendMessage: SCI_SETDOCPOINTER
		wParam: 0
		lParam: pointerInteger!

sciSetEdgeColumn: columnInteger 
	"Private - Set the column number of the edge. If text goes past the edge then it is
	highlighted."

	self 
		sendMessage: SCI_SETEDGECOLUMN
		wParam: columnInteger
		lParam: 0!

sciSetEdgeMode: modeInteger 
	"Private - The edge may be displayed by a line (EDGE_LINE) or by highlighting text that goes
	beyond it (EDGE_BACKGROUND) or not displayed at all (EDGE_NONE)."

	self 
		sendMessage: SCI_SETEDGEMODE
		wParam: modeInteger
		lParam: 0!

sciSetEOLMode: eolModeInteger 
	"Private - Set the current end of line mode."

	self 
		sendMessage: SCI_SETEOLMODE
		wParam: eolModeInteger
		lParam: 0!

sciSetFirstVisibleLine: lineDisplayInteger 
	"Private - Scroll so that a display line is at the top of the display."

	self 
		sendMessage: SCI_SETFIRSTVISIBLELINE
		wParam: lineDisplayInteger
		lParam: 0!

sciSetFoldExpanded: lineInteger expanded: expandedBoolean 
	"Private - Show the children of a header line."

	self 
		sendMessage: SCI_SETFOLDEXPANDED
		wParam: lineInteger
		lParam: expandedBoolean asParameter!

sciSetFoldFlags: flagsInteger 
	"Private - Set some style options for folding."

	self 
		sendMessage: SCI_SETFOLDFLAGS
		wParam: flagsInteger
		lParam: 0!

sciSetFoldLevel: lineInteger level: levelInteger 
	"Private - Set the fold level of a line. This encodes an integer level along with flags
	indicating whether the line is a header and whether it is effectively white space."

	self 
		sendMessage: SCI_SETFOLDLEVEL
		wParam: lineInteger
		lParam: levelInteger!

sciSetFoldMarginColour: useSettingBoolean back: backRGB 
	"Private - Set the colours used as a chequerboard pattern in the fold margin"

	self 
		sendMessage: SCI_SETFOLDMARGINCOLOUR
		wParam: useSettingBoolean asParameter
		lParam: backRGB asParameter!

sciSetFoldMarginHiColour: useSettingBoolean fore: foreRGB 
	self 
		sendMessage: SCI_SETFOLDMARGINHICOLOUR
		wParam: useSettingBoolean asParameter
		lParam: foreRGB asParameter!

sciSetFontQuality: fontQualityInteger 
	"Private - Choose the quality level for text from the FontQuality enumeration."

	self 
		sendMessage: SCI_SETFONTQUALITY
		wParam: fontQualityInteger
		lParam: 0!

sciSetHotspotActiveBack: useSettingBoolean back: backRGB 
	"Private - Set a back colour for active hotspots."

	self 
		sendMessage: SCI_SETHOTSPOTACTIVEBACK
		wParam: useSettingBoolean asParameter
		lParam: backRGB asParameter!

sciSetHotspotActiveFore: useSettingBoolean fore: foreRGB 
	"Private - Set a fore colour for active hotspots."

	self 
		sendMessage: SCI_SETHOTSPOTACTIVEFORE
		wParam: useSettingBoolean asParameter
		lParam: foreRGB asParameter!

sciSetHScrollBar: showBoolean 
	"Private - Show or hide the horizontal scroll bar."

	self 
		sendMessage: SCI_SETHSCROLLBAR
		wParam: showBoolean asParameter
		lParam: 0!

sciSetIndentationGuides: indentViewInteger 
	"Private - Show or hide indentation guides."

	self 
		sendMessage: SCI_SETINDENTATIONGUIDES
		wParam: indentViewInteger
		lParam: 0!

sciSetKeyWords: keywordSetInteger keyWords: keyWordsString 
	"Private - Set up the key words used by the lexer."

	self 
		sendMessage: SCI_SETKEYWORDS
		wParam: keywordSetInteger
		lParam: keyWordsString yourAddress!

sciSetLayoutCache: modeInteger 
	"Private - Sets the degree of caching of layout information."

	self 
		sendMessage: SCI_SETLAYOUTCACHE
		wParam: modeInteger
		lParam: 0!

sciSetLengthForEncode: bytesInteger 
	"Private - Set the length of the utf8 argument for calling EncodedFromUTF8. Set to -1 and
	the string will be measured to the first nul."

	self 
		sendMessage: SCI_SETLENGTHFORENCODE
		wParam: bytesInteger
		lParam: 0!

sciSetLexer: lexerInteger 
	"Private - Set the lexing language of the document."

	self 
		sendMessage: SCI_SETLEXER
		wParam: lexerInteger
		lParam: 0!

sciSetLexerLanguage: languageString 
	"Private - Set the lexing language of the document based on string name."

	self 
		sendMessage: SCI_SETLEXERLANGUAGE
		wParam: 0
		lpParam: languageString!

sciSetLineIndentation: lineInteger indentSize: indentSizeInteger 
	"Private - Change the indentation of a line to a number of columns."

	self 
		sendMessage: SCI_SETLINEINDENTATION
		wParam: lineInteger
		lParam: indentSizeInteger!

sciSetLineState: lineInteger state: stateInteger 
	"Private - Used to hold extra styling information for each line."

	self 
		sendMessage: SCI_SETLINESTATE
		wParam: lineInteger
		lParam: stateInteger!

sciSetMainSelection: selectionInteger 
	"Private - Set the main selection"

	self 
		sendMessage: SCI_SETMAINSELECTION
		wParam: selectionInteger
		lParam: 0!

sciSetMarginLeft: pixelWidthInteger 
	"Private - Sets the size in pixels of the left margin."

	self 
		sendMessage: SCI_SETMARGINLEFT
		wParam: 0
		lParam: pixelWidthInteger!

sciSetMarginRight: pixelWidthInteger 
	"Private - Sets the size in pixels of the right margin."

	self 
		sendMessage: SCI_SETMARGINRIGHT
		wParam: 0
		lParam: pixelWidthInteger!

sciSetModEventMask: maskInteger 
	"Private - Set which document modification events are sent to the container."

	self 
		sendMessage: SCI_SETMODEVENTMASK
		wParam: maskInteger
		lParam: 0!

sciSetMultiPaste: multiPasteInteger 
	"Private - Change the effect of pasting when there are multiple selections."

	self 
		sendMessage: SCI_SETMULTIPASTE
		wParam: multiPasteInteger
		lParam: 0!

sciSetPasteConvertEndings: convertBoolean 
	"Private - Enable/Disable convert-on-paste for line endings"

	self 
		sendMessage: SCI_SETPASTECONVERTENDINGS
		wParam: convertBoolean asParameter
		lParam: 0!

sciSetPrintWrapMode: modeInteger 
	"Private - Set printing to line wrapped (SC_WRAP_WORD) or not line wrapped (SC_WRAP_NONE)."

	self 
		sendMessage: SCI_SETPRINTWRAPMODE
		wParam: modeInteger
		lParam: 0!

sciSetProperty: keyString value: valueString 
	"Private - Set up a value that may be used by a lexer for some optional feature."

	self 
		sendMessage: SCI_SETPROPERTY
		wParam: keyString yourAddress
		lParam: valueString yourAddress!

sciSetRectangularSelectionAnchor: posAnchorInteger 
	self 
		sendMessage: SCI_SETRECTANGULARSELECTIONANCHOR
		wParam: posAnchorInteger
		lParam: 0!

sciSetRectangularSelectionAnchorVirtualSpace: spaceInteger 
	self 
		sendMessage: SCI_SETRECTANGULARSELECTIONANCHORVIRTUALSPACE
		wParam: spaceInteger
		lParam: 0!

sciSetRectangularSelectionCaret: posInteger 
	self 
		sendMessage: SCI_SETRECTANGULARSELECTIONCARET
		wParam: posInteger
		lParam: 0!

sciSetRectangularSelectionCaretVirtualSpace: spaceInteger 
	self 
		sendMessage: SCI_SETRECTANGULARSELECTIONCARETVIRTUALSPACE
		wParam: spaceInteger
		lParam: 0!

sciSetSavePoint
	"Private - Remember the current position in the undo history as the position at which the
	document was saved."

	self 
		sendMessage: SCI_SETSAVEPOINT
		wParam: 0
		lParam: 0!

sciSetSearchFlags: flagsInteger 
	"Private - Set the search flags used by SearchInTarget."

	self 
		sendMessage: SCI_SETSEARCHFLAGS
		wParam: flagsInteger
		lParam: 0!

sciSetSelBack: useSettingBoolean back: backRGB 
	"Private - Set the background colour of the main and additional selections and whether to
	use this setting."

	self 
		sendMessage: SCI_SETSELBACK
		wParam: useSettingBoolean asParameter
		lParam: backRGB asParameter!

sciSetSelection: caretInteger anchor: anchorInteger 
	"Private - Set a simple selection"

	^self 
		sendMessage: SCI_SETSELECTION
		wParam: caretInteger
		lParam: anchorInteger!

sciSetSelectionMode: modeInteger 
	"Private - Set the selection mode to stream (SC_SEL_STREAM) or rectangular
	(SC_SEL_RECTANGLE/SC_SEL_THIN) or by lines (SC_SEL_LINES)."

	self 
		sendMessage: SCI_SETSELECTIONMODE
		wParam: modeInteger
		lParam: 0!

sciSetSelectionNAnchor: selectionInteger posAnchor: posAnchorInteger 
	self 
		sendMessage: SCI_SETSELECTIONNANCHOR
		wParam: selectionInteger
		lParam: posAnchorInteger!

sciSetSelectionNAnchorVirtualSpace: selectionInteger space: spaceInteger 
	self 
		sendMessage: SCI_SETSELECTIONNANCHORVIRTUALSPACE
		wParam: selectionInteger
		lParam: spaceInteger!

sciSetSelectionNCaret: selectionInteger pos: posInteger 
	self 
		sendMessage: SCI_SETSELECTIONNCARET
		wParam: selectionInteger
		lParam: posInteger!

sciSetSelectionNCaretVirtualSpace: selectionInteger space: spaceInteger 
	self 
		sendMessage: SCI_SETSELECTIONNCARETVIRTUALSPACE
		wParam: selectionInteger
		lParam: spaceInteger!

sciSetSelectionNEnd: selectionInteger pos: posInteger 
	"Private - Sets the position that ends the selection - this becomes the currentPosition."

	self 
		sendMessage: SCI_SETSELECTIONNEND
		wParam: selectionInteger
		lParam: posInteger!

sciSetSelectionNStart: selectionInteger pos: posInteger 
	"Private - Sets the position that starts the selection - this becomes the anchor."

	self 
		sendMessage: SCI_SETSELECTIONNSTART
		wParam: selectionInteger
		lParam: posInteger!

sciSetSelFore: useSettingBoolean fore: foreRGB 
	"Private - Set the foreground colour of the main and additional selections and whether to
	use this setting."

	self 
		sendMessage: SCI_SETSELFORE
		wParam: useSettingBoolean asParameter
		lParam: foreRGB asParameter!

sciSetStyleBits: bitsInteger 
	"Private - Divide each styling byte into lexical class bits (default: 5) and indicator bits
	(default: 3). If a lexer requires more than 32 lexical states, then this is used to expand
	the possible states."

	self 
		sendMessage: SCI_SETSTYLEBITS
		wParam: bitsInteger
		lParam: 0!

sciSetStylingEx: lengthInteger styles: stylesString 
	"Private - Set the styles for a segment of the document."

	self 
		sendMessage: SCI_SETSTYLINGEX
		wParam: lengthInteger
		lParam: stylesString yourAddress!

sciSetTargetEnd: posInteger 
	"Private - Sets the position that ends the target which is used for updating the document
	without affecting the scroll position."

	self 
		sendMessage: SCI_SETTARGETEND
		wParam: posInteger
		lParam: 0!

sciSetTargetStart: posInteger 
	"Private - Sets the position that starts the target which is used for updating the document
	without affecting the scroll position."

	self 
		sendMessage: SCI_SETTARGETSTART
		wParam: posInteger
		lParam: 0!

sciSetText: textString 
	"Private - Replace the contents of the document with the argument text."

	self 
		sendMessage: SCI_SETTEXT
		wParam: 0
		lpParam: textString!

sciSetVirtualSpaceOptions: virtualSpaceOptionsInteger 
	self 
		sendMessage: SCI_SETVIRTUALSPACEOPTIONS
		wParam: virtualSpaceOptionsInteger
		lParam: 0!

sciSetVisiblePolicy: visiblePolicyInteger visibleSlop: visibleSlopInteger 
	"Private - Set the way the display area is determined when a particular line is to be moved
	to by Find, FindNext, GotoLine, etc."

	self 
		sendMessage: SCI_SETVISIBLEPOLICY
		wParam: visiblePolicyInteger
		lParam: visibleSlopInteger!

sciSetWhitespaceBack: useSettingBoolean back: backRGB 
	"Private - Set the background colour of all whitespace and whether to use this setting."

	self 
		sendMessage: SCI_SETWHITESPACEBACK
		wParam: useSettingBoolean asParameter
		lParam: backRGB asParameter!

sciSetWhitespaceChars: charactersString 
	"Private - Set the set of characters making up whitespace for when moving or selecting by
	word. Should be called after SetWordChars."

	self 
		sendMessage: SCI_SETWHITESPACECHARS
		wParam: 0
		lpParam: charactersString!

sciSetWhitespaceFore: useSettingBoolean fore: foreRGB 
	"Private - Set the foreground colour of all whitespace and whether to use this setting."

	self 
		sendMessage: SCI_SETWHITESPACEFORE
		wParam: useSettingBoolean asParameter
		lParam: foreRGB asParameter!

sciSetWordChars: charactersString 
	"Private - Set the set of characters making up words for when moving or selecting by word.
	First sets defaults like SetCharsDefault."

	self 
		sendMessage: SCI_SETWORDCHARS
		wParam: 0
		lpParam: charactersString!

sciSetWrapIndentMode: modeInteger 
	"Private - Sets how wrapped sublines are placed. Default is fixed."

	self 
		sendMessage: SCI_SETWRAPINDENTMODE
		wParam: modeInteger
		lParam: 0!

sciSetWrapMode: modeInteger 
	"Private - Sets whether text is word wrapped."

	self 
		sendMessage: SCI_SETWRAPMODE
		wParam: modeInteger
		lParam: 0!

sciSetWrapVisualFlags: wrapVisualFlagsInteger 
	"Private - Set the display mode of visual flags for wrapped lines."

	self 
		sendMessage: SCI_SETWRAPVISUALFLAGS
		wParam: wrapVisualFlagsInteger
		lParam: 0!

sciSetWrapVisualFlagsLocation: wrapVisualFlagsLocationInteger 
	"Private - Set the location of visual flags for wrapped lines."

	self 
		sendMessage: SCI_SETWRAPVISUALFLAGSLOCATION
		wParam: wrapVisualFlagsLocationInteger
		lParam: 0!

sciSetXCaretPolicy: caretPolicyInteger caretSlop: caretSlopInteger 
	"Private - Set the way the caret is kept visible when going sideway. The exclusion zone is
	given in pixels."

	self 
		sendMessage: SCI_SETXCARETPOLICY
		wParam: caretPolicyInteger
		lParam: caretSlopInteger!

sciSetYCaretPolicy: caretPolicyInteger caretSlop: caretSlopInteger 
	"Private - Set the way the line the caret is on is kept visible. The exclusion zone is given
	in lines."

	self 
		sendMessage: SCI_SETYCARETPOLICY
		wParam: caretPolicyInteger
		lParam: caretSlopInteger!

sciShowLines: lineStartInteger lineEnd: lineEndInteger 
	"Private - Make a range of lines visible."

	self 
		sendMessage: SCI_SHOWLINES
		wParam: lineStartInteger
		lParam: lineEndInteger!

sciStartStyling: posInteger mask: maskInteger 
	"Private - Set the current styling position to pos and the styling mask to mask. The styling
	mask can be used to protect some bits in each styling byte from modification."

	self 
		sendMessage: SCI_STARTSTYLING
		wParam: posInteger
		lParam: maskInteger!

sciStyleClearAll
	"Private - Clear all the styles and make equivalent to the global default style."

	self 
		sendMessage: SCI_STYLECLEARALL
		wParam: 0
		lParam: 0!

sciTargetAsUTF8: sString 
	"Private - Returns the target converted to UTF8. Return the length in bytes."

	^self 
		sendMessage: SCI_TARGETASUTF8
		wParam: 0
		lpParam: sString!

sciTextHeight: lineInteger 
	"Private - Retrieve the height of a particular line of text in pixels."

	^self 
		sendMessage: SCI_TEXTHEIGHT
		wParam: lineInteger
		lParam: 0!

sciTextWidth: styleInteger text: textString 
	"Private - Measure the pixel width of some text in a particular style. NUL terminated text
	argument. Does not handle tab or control characters."

	^self 
		sendMessage: SCI_TEXTWIDTH
		wParam: styleInteger
		lParam: textString yourAddress!

sciToggleCaretSticky
	"Private - Switch between sticky and non-sticky: meant to be bound to a key."

	self 
		sendMessage: SCI_TOGGLECARETSTICKY
		wParam: 0
		lParam: 0!

sciToggleFold: lineInteger 
	"Private - Switch a header line between expanded and contracted."

	self 
		sendMessage: SCI_TOGGLEFOLD
		wParam: lineInteger
		lParam: 0!

sciUserListShow: listTypeInteger itemList: itemListString 
	"Private - Display a list of strings and send notification when user chooses one."

	self 
		sendMessage: SCI_USERLISTSHOW
		wParam: listTypeInteger
		lParam: itemListString yourAddress!

sciVisibleFromDocLine: lineInteger 
	"Private - Find the display line of a document line taking hidden lines into account."

	^self 
		sendMessage: SCI_VISIBLEFROMDOCLINE
		wParam: lineInteger
		lParam: 0!

sciWordEndPosition: posInteger onlyWordCharacters: onlyWordCharactersBoolean 
	"Private - Get position of end of word."

	^self 
		sendMessage: SCI_WORDENDPOSITION
		wParam: posInteger
		lParam: onlyWordCharactersBoolean asParameter!

sciWordStartPosition: posInteger onlyWordCharacters: onlyWordCharactersBoolean 
	"Private - Get position of start of word."

	^self 
		sendMessage: SCI_WORDSTARTPOSITION
		wParam: posInteger
		lParam: onlyWordCharactersBoolean asParameter!

sciWrapCount: lineInteger 
	"Private - The number of display lines needed to wrap a document line"

	^self 
		sendMessage: SCI_WRAPCOUNT
		wParam: lineInteger
		lParam: 0!

scnAutoCCancelled: pSCNotification 
	"Private - Default handler for an SCN_AUTOCCANCELLED event.
	No fields of the notification structure are set, so we ignore it."

	self presenter trigger: #autoCompleteCancelled.
	^0!

scnAutoCCharDeleted: pSCNotification 
	"Private - Default handler for an SCN_AUTOCCHARDELETED event.
	No fields of the notification structure are set."

	^nil!

scnAutoCSelection: pSCNotification 
	| accept struct |
	accept := true asValue.
	struct := SCNotification fromAddress: pSCNotification.
	self presenter trigger: #autoComplete:startingAt:accept:
		withArguments: (Array 
				with: struct text
				with: struct lParam + 1
				with: accept).
	accept value ifFalse: [self cancelAutoCompletion].
	^0!

scnCallTipClick: pSCNotification 
	"Private - Default handler for an SCN_CALLTIPCLICK event.
	The following fields of the notification structure are set:
		position

	From the Scintilla Docs:
		'... generated when the user clicks on a calltip. ...	can be used to display the next 
		function prototype when a function name is overloaded with different arguments.
		The position field is set to 1 if the click is in an up arrow, 2 if in a down arrow, 
		and 0 if elsewhere.'
	"

	self presenter trigger: #callTipClicked:
		with: (#(#upArrow #downArrow) at: (SCNotification fromAddress: pSCNotification) position
				ifAbsent: [#other]).
	^0!

scnCharAdded: pSCNotification 
	"Private - Default handler for an SCN_CHARADDED event.
	The following fields of the notification structure are set:
		ch 	(set to the code point of the new character).

	From the Scintilla docs:
		'Fired when the user types an ordinary text character (as opposed to a command character) 
		which is entered into the text. Can be used by the container to decide to display a call tip or 
		auto completion list.'
	"

	self presenter trigger: #charAdded: with: (SCNotification fromAddress: pSCNotification) character.
	^0!

scnDoubleClick: pSCNotification 
	"Private - Default handler for an SCN_DOUBLECLICK event.
	No fields of the notification structure are set."

	"Implementation Note: This notification is ignored since it is redundant."

	^0!

scnDwellEnd: pSCNotification 
	"Private - Respond to an SCN_DWELLEND notification. The 'position' , 'x' and 'y' fields of
	the notification structure are set.
	From the Scintilla docs:
		' ...generated after a SCN_DWELLSTART and the mouse is moved or other activity 
		such as key press indicates the dwell is over.'
	"

	self presenter trigger: #hoverEnd: with: (SCNotification fromAddress: pSCNotification) point.
	^0!

scnDwellStart: pSCNotification 
	"Private - Respond to an SCN_DWELLSTART notification. The 'position' , 'x' and 'y' fields of
	the notification structure are set.
	From the Scintilla docs:
		'...generated when the user hold the mouse still in one spot for the dwell period.'
	"

	self presenter trigger: #hoverStart: with: (SCNotification fromAddress: pSCNotification) point.
	^0!

scnHotSpotClick: pSCNotification 
	"Private - Default handler for an SCN_HOTSPOTCLICK event.
	The following fields of the notification structure are set:
		modifiers
		position

	From the Scintilla Docs:
		'... generated when the user clicks .. on text that is in a style with the hotspot attribute set. ...
		The position field is set the text position of the click ... and the modifiers field set to the key 
		modifiers held down in a similar manner to SCN_KEY.'
	"

	#todo.	"Send around a MouseEvent here"
	self presenter trigger: #hotSpotClicked: with: (SCNotification fromAddress: pSCNotification).
	^0!

scnHotSpotDoubleClick: pSCNotification 
	"Private - Default handler for an SCN_HOTSPOTDOUBLECLICK event.
	The following fields of the notification structure are set:
		modifiers
		position

	See scnHotSpotClick:
	"

	#todo.	"Send around a MouseEvent here"
	self presenter trigger: #hotSpotDoubleClicked: with: (SCNotification fromAddress: pSCNotification).
	^0!

scnHotSpotReleaseClick: pSCNotification 
	"Private - Default handler for an SCN_HOTSPOTRELEASECLICK event.
	The following fields of the notification structure are set:
		modifiers
		position"

	^nil!

scnIndicatorClick: pSCNotification 
	"Private - Default handler for an SCN_INDICATORCLICK event.
	The following fields of the notification structure are set:
		modifiers
		position"

	self presenter trigger: #indicatorClicked: with: (SCNotification fromAddress: pSCNotification).
	^0!

scnIndicatorRelease: pSCNotification 
	"Private - Default handler for an SCN_INDICATORRELEASE event.
	The following fields of the notification structure are set:
		modifiers
		position"

	self presenter trigger: #indicatorReleased: with: (SCNotification fromAddress: pSCNotification).
	^0!

scnKey: pSCNotification 
	"Private - Default handler for an SCN_KEY event.
	The following fields of the notification structure are set:
		ch
		modifiers"

	"Implementation Note: Not sent by Scintilla on Windows."

	^0!

scnMacroRecord: pSCNotification 
	"Private - Respond to an SCN_MACRORECORD notification. The 'message', 'wParam' and
	'lParam' fields of the notification structure are set.

	From the Scintilla docs:
		'Tells the container that an operation is being performed so that the container may 
		choose to record the fact if it is in a macro recording mode.'
	"

	self presenter trigger: #macroRecord: with: (SCNotification fromAddress: pSCNotification).
	^0!

scnMarginClick: pSCNotification 
	"Private - Respond to an SCN_MARGINCLICK notification. The 'modifiers', 'position' and
	'margin' fields of the notification structure are set.

	From the Scintilla docs:
		'Tells the container that the mouse was clicked inside a margin marked sensitive. 
		Can be used to perform folding or to place breakpoints.'
	"

	| struct |
	struct := SCNotification fromAddress: pSCNotification.
	self isFoldingEnabled 
		ifTrue: 
			[| margin |
			margin := self margins at: struct margin + 1.
			margin isFolders 
				ifTrue: 
					[| line |
					line := self lineFromPosition: struct position.
					self toggleFold: line]].
	self presenter trigger: #marginClicked: with: struct.
	^0!

scnModified: pSCNotification 
	"Private - Respond to SCN_MODIFIED notification.The 'position', 'modificationType', 'text',
	'length', 'linesAdded', 'line', 'foleLevelNow' and 'foldLevelPrev' fields of the
	notification structure are set.

	See the Scintilla documentation for more information about this important and heavily
	overloaded notification."

	| struct eventMask |
	struct := SCNotification fromAddress: pSCNotification.
	eventMask := struct modificationType.
	(eventMask anyMask: ##(SC_MOD_INSERTTEXT | SC_MOD_DELETETEXT)) 
		ifTrue: 
			["Text changed"
			super enChange]
		ifFalse: 
			[(eventMask 
				anyMask: ##(SC_MOD_CHANGESTYLE | SC_MOD_CHANGEFOLD | SC_MOD_CHANGEANNOTATION | SC_MOD_CHANGEMARGIN)) 
					ifTrue: [self invalidateCalculatedExtent]].
	^0!

scnModifyAttemptRO: pSCNotification
	"Private - Respond to an SCN_MODIFYATTEMPTRO notification. 	No fields of the notification 
	structure are set.

	From the Scintilla docs:
		'When in read-only mode, this notification is sent to the container should the user try to 
		edit the document. This can be used to check the document out of a version control system.'
	"

	^0!

scnNeedShown: pSCNotification
	"Private - Respond to an SCN_NEEDSHOWN notification. The 'position' and 'length' fields of the
	notification structure are set.

	From the Scintilla docs:
		'Scintilla has determined that a range of lines that is currently invisible should be made visible. 
		An example of where this may be needed is if the end of line of a contracted fold point is deleted. 
		This message is sent to the container in case it wants to make the line visible in some unusual way 
		such as making the whole document visible. Most containers will just ensure each line in the range 
		is visible by calling SCI_ENSUREVISIBLE.'
	"

	^0!

scnPainted: pSCNotification 
	"Private - Respond to an SCN_PAINTED notification. No fields of the notification 
	structure are set.

	From the Scintilla docs:
		'Painting has just been done. Useful when you want to update some other widgets based 
		on a change in Scintilla, but want to have the paint occur first to appear more responsive. 
	"

	self presenter trigger: #painted.
	^0!

scnSavePointLeft: pSCNotification 
	"Private - Respond to an SCN_SAVEPOINTLEFT notification. No fields of the notification 
	structure are set.

	From the Scintilla docs:
		'Sent to the container when the savepoint is left..., allowing the container to display 
		a dirty indicator and change its menus.'
	"

	self presenter trigger: #savePointLeft.
	^0!

scnSavePointReached: pSCNotification 
	"Private - Respond to an SCN_SAVEPOINTREACHED notification. No fields of the nofication
	structure are set.

	From the Scintilla docs:
		'Sent to the container when the savepoint is entered..., allowing the container to display 
		a dirty indicator and change its menus.'
	"

	self presenter trigger: #savePointReached.
	^0!

scnStyleNeeded: pSCNotification 
	"Private - Respond to SCN_STYLENEEDED notification. Only the 'position' field of the
	notification structure is set.

	From the Scintilla docs: 'Before displaying a page or printing, this message is sent to the
	container. It is a good opportunity for the container to ensure that syntax styling
	information for the visible text.'

	Beware: The Scintilla documentation states (in the description of SCI_GETENDSTYLED) that
	'Scintilla will always ask to style whole lines'. This is NOT the case for container-based
	styling; see the docs for SCN_STYLENEEDED."

	| stop notification |
	notification := SCNotification fromAddress: pSCNotification.
	"SCNotification.position is a zero-based inter-character index in this case, so we can treat
	it as the one-based index of the last character in the range to be styled."
	stop := notification scPosition.
	
	[| last notificationMask |
	last := self stylingPosition.
	notificationMask := self modificationEventMask.
	
	["Temporarily disable style change notifications to speed up the colouring"
	self 
		modificationEventMask: (notificationMask maskClear: ##(SC_MOD_CHANGESTYLE | SC_PERFORMED_USER)).
	self styler 
		onStyleNeeded: self
		from: last
		to: stop] 
			ensure: 
				[self modificationEventMask: notificationMask.
				self invalidateCalculatedExtent]] 
			on: Error
			do: 
				[:ex | 
				"Avoid repeated error by clearing the style needed  state"
				self startStylingFrom: stop + 1.
				ex pass].
	^0!

scnUpdateUI: pSCNotification
	"Private - Respond to SCN_UPDATEUI notification. No fields of the notification structure are set.

	From the Scintilla docs: 
		'Either the text or styling of the document has changed or the selection range has changed.
		Now would be a good time to update any container UI elements that depend on document or view state'
	"

	self invalidateUserInterface.
	^0!

scnURIDropped: pSCNotification 
	"Private - Default handler for an SCN_URIDROPPED event.
	The following fields of the notification structure are set:
		text"

	"Implementation Note: Not sent by Scintilla on Windows."

	^0!

scnUserListSelection: anExternalAddress 
	"Private - Respond to SCN_USERLISTSELECTION notification. The 'message', 'wParam',
	'lParam' and 'text' fields of the notification structure are set (though note that
	the message and lParam fields are always zero).
	From the Scintilla docs: 
		'User has selected an item in a user list. The list type is available in wParam and the text chosen in text.'
	"

	| struct |
	struct := SCNotification fromAddress: anExternalAddress.
	self presenter 
		trigger: #userList:selection:
		with: struct wParam
		with: struct text.
	^0!

scnZoom: anExternalAddress 
	"Private - Respond to an SCN_ZOOM notification. No fields of the notification structure are set.
	From the Scintilla docs:
		' ...generated when the user zooms the display using the keyboard or the SCI_SETZOOM 
		method is called. This notification can be used to recalculate positions, such as the width 
		of the line number margin to maintain sizes in terms of characters rather than pixels.'
	"

	self presenter trigger: #zoomed.
	^0!

scrollDown
	"Scroll the document down, keeping the caret visible."

	self 
		sendMessage: SCI_LINESCROLLDOWN
		wParam: 0
		lParam: 0!

scrollUp
	"Scroll the document up, keeping the caret visible."

	self 
		sendMessage: SCI_LINESCROLLUP
		wParam: 0
		lParam: 0!

scrollWidth
	"Retrieve the document width assumed for scrolling."

	^self 
		sendMessage: SCI_GETSCROLLWIDTH
		wParam: 0
		lParam: 0!

scrollWidth: pixelWidthInteger 
	"Sets the document width assumed for scrolling."

	self 
		sendMessage: SCI_SETSCROLLWIDTH
		wParam: pixelWidthInteger
		lParam: 0!

secondaryCaretForecolor
	"Get the foreground colour of additional carets."

	^RGB fromInteger: (self 
				sendMessage: SCI_GETADDITIONALCARETFORE
				wParam: 0
				lParam: 0)!

secondaryCaretForecolor: foreRGB 
	"Set the foreground colour of the secondary carets."

	self sciSetAdditionalCaretFore: (foreRGB ifNil: [Color darkGray]) asRGB!

secondarySelectionAlpha
	"Get the alpha of the selection."

	^self 
		sendMessage: SCI_GETADDITIONALSELALPHA
		wParam: 0
		lParam: 0!

secondarySelectionAlpha: alphaInteger 
	"Set the alpha of the selection."

	self 
		sendMessage: SCI_SETADDITIONALSELALPHA
		wParam: alphaInteger
		lParam: 0!

secondarySelectionBackcolor
	^secondarySelectionBackcolor!

secondarySelectionBackcolor: aColorOrNil 
	"Set the background colour of secondary selections. Note that this setting is ignored if a
	primary selection background colour has not been set."

	secondarySelectionBackcolor := aColorOrNil.
	self setSecondarySelectionBackcolor!

secondarySelectionForecolor
	^secondarySelectionForecolor!

secondarySelectionForecolor: aColorOrNil 
	"Set the foreground colour for secondary selections. Note that this is ignored unless a
	primary selection foreground colour has been set."

	secondarySelectionForecolor := aColorOrNil.
	self setSecondarySelectionForecolor!

selection
	"Answer a String containing the receiver's currently selected text, or the text of the main
	selection if in multi-select mode."

	"Implementation Note: The superclass implementation will work (although only for streaming
	selections), but this is about 4x faster, and returns all selected text for rectangular and
	multi-selections too."

	| length buf |
	length := self sciGetSelText: nil.
	"The returned length includes the null character."
	buf := String newFixed: length - 1.
	self sciGetSelText: buf.
	^buf!

selectionAlpha
	"Get the alpha of the selection."

	^self 
		sendMessage: SCI_GETSELALPHA
		wParam: 0
		lParam: 0!

selectionAlpha: alphaInteger 
	"Set the alpha of the selection."

	self 
		sendMessage: SCI_SETSELALPHA
		wParam: alphaInteger
		lParam: 0!

selectionBackcolor
	"Answer the background colour of the selection, or nil if selection background colouring is
	disabled."

	^selectionBackcolor!

selectionBackcolor: aColorOrNil 
	"Set the background colour of the selection. The argument can be nil to turn off selection
	highlighting by background colour. If this setting is nil, then the #selectionForecolor
	should be set, as otherwise the selection will not be visible at all."

	selectionBackcolor := aColorOrNil.
	self setSelectionBackcolor!

selectionCount
	"How many selections are there?"

	^self 
		sendMessage: SCI_GETSELECTIONS
		wParam: 0
		lParam: 0!

selectionForecolor
	"Answer the foreground colour of the selection, or nil if the selection foreground colouring
	is disabled (the default)."

	^selectionForecolor!

selectionForecolor: aColorOrNil 
	"Set the foreground colour of the selection. If the argument is nil, then selection
	foreground colouring is enabled and the selected text retains its original foreground
	colour."

	selectionForecolor := aColorOrNil.
	self setSelectionForecolor!

selectionMode
	"Answer a <Symbol> naming the current selection mode."

	"Note that holding down Ctrl+Alt while selecting with the mouse will perform a #rectangular selection,
	the normal selection mode being #stream."

	^self class selectionModes at: self sciGetSelectionMode + 1!

selectionMode: aSymbol 
	"Set the current selection mode to be that named by the <Symbol> argument, one of #stream,
	#rectangle or #lines."

	self sciSetSelectionMode: (self class selectionModes indexOf: aSymbol) - 1!

selectionPlainText: aString 
	"Private - Replace the receiver's current selection with aString.
	SCI_REPLACESEL does not return a useful value."

	self modifyText: [self sciReplaceSel: aString]!

selectionRanges
	"Answer an <Array> of <Interval> representing the current selections. Even if not in
	multi-select mode there could be more than one selection range if a rectangular selection
	has been made."

	^(0 to: self selectionCount - 1) 
		collect: [:i | (self sciGetSelectionNStart: i) + 1 to: (self sciGetSelectionNEnd: i)]!

selectionRanges: anArrayOfInterval 
	"Apply the selections provided in the argument. Any existing selections are removed. Note
	that multiple selection ranges are allowed even if the receiver is not in multi-select
	mode."

	self removeSelections.
	anArrayOfInterval do: [:each | self sciAddSelection: each stop anchor: each start - 1]!

selections
	"Answer an <Array> of <String> being the current selections. Even if not in
	multi-select mode there could be more than one selection if a rectangular selection
	has been made."

	^self selectionRanges collect: [:each | self plainTextRange: each]!

sendMessage: anInteger 
	"Private - Send the Win32 message, anInteger, to the receiver's real window with wParam and
	lParam set to 0."

	"Implementation Note: Override to ensure goes through direct call mechanism."

	^self 
		sendMessage: anInteger
		wParam: 0
		lParam: 0!

sendMessage: msgInteger wParam: wParamInteger 
	"Private - Send the Win32 message msgInteger to the receiver's real window with the
	specified wParam, and lParam set to 0."

	"Implementation Note: Override to ensure goes through direct call mechanism."

	^self 
		sendMessage: msgInteger
		wParam: wParamInteger
		lParam: 0!

sendMessage: anIntegerMessageID wParam: wParam lParam: lParam 
	"Private - Send the specified Win32 <integer> message to the receiver with the specified
	32-bit <integer> wParam and lParam parameters."

	"Implementation Note: Use the direct pointer mechanism provided by Scintilla, which allows
	us to bypass the Windows message queue altogether for best performance. This does mean,
	however, that no callback into Dolphin will result. Also we must be careful not to call
	through a null pointer or we will get a GPF."

	this 
		ifNil: 
			[self getDirectPointer.
			this ifNil: [^0]].
	^ScintillaLibrary default 
		directFunction: this
		msg: anIntegerMessageID
		wParam: wParam
		lParam: lParam!

sendMessage: anIntegerMessageID wParam: wParam lpParam: lParam 
	"Private - Send the Win32 message anIntegerMessageID with parameters wParam and lpParam
	(pointer) to the receiver's Window."

	"Implementation Note: Use the direct pointer mechanism provided by Scintilla, which allows
	us to bypass the Windows message queue altogether for best performance. This does mean,
	however, that no callback into Dolphin will result. Also we must be careful not to call
	through a null pointer or we will get a GPF."

	this isNil 
		ifTrue: 
			[self getDirectPointer.
			this isNil ifTrue: [^0]].
	^ScintillaLibrary default 
		directFunction: this
		msg: anIntegerMessageID
		wParam: wParam
		lParam: lParam yourAddress!

setCallTipHighlightColor
	self sciCallTipSetForeHlt: callTipHighlightColor asRGB!

setCallTipTabWidth
	self sciCallTipUseStyle: callTipTabWidth!

setCurrentTextStyles: aCollection 
	| newStylesByName allocatedStyles newStylesById availableStyles count |
	count := aCollection size.
	allocatedStyles := OrderedCollection new: count.
	aCollection do: [:each | each basicId ifNotNil: [:id | allocatedStyles add: id]].
	availableStyles := ((1 to: STYLE_DEFAULT - 1) , (STYLE_LASTPREDEFINED + 1 to: self maxStyle) 
				difference: allocatedStyles) readStream.
	newStylesByName := IdentityDictionary new: count.
	newStylesById := Array new: (STYLE_LASTPREDEFINED max: self maxStyle) + 1.
	aCollection do: 
			[:each | 
			each basicId isNil ifTrue: [each basicId: availableStyles next].
			newStylesByName at: each name put: each.
			newStylesById at: each basicId + 1 put: each].
	newStylesByName at: #normal ifAbsentPut: [ScintillaTextStyle normal].
	currentTextStyles := newStylesByName.
	styleIdMap := newStylesById.
	self updateTextStyles!

setDefaultTextStyle
	"Private - Set the default text style by merging settings from the #normal style, and the view with
	the #normal style taking precedence. All styles are then reset to match the default style.
	This should be done as a precursor to setting style attributes, so that all other styles
	inherit unspecified settings from the #normal style (and ultimately the view)."

	| defaultStyle |
	defaultStyle := self buildDefaultStyle.
	defaultStyle applyToView: self at: STYLE_DEFAULT.
	self sciStyleClearAll!

setFoldFlags
	self sciSetFoldFlags: foldFlags!

setFoldMarginColor
	foldMarginColor 
		ifNil: [self sciSetFoldMarginColour: false back: nil]
		ifNotNil: [self sciSetFoldMarginColour: true back: foldMarginColor asRGB]!

setFoldMarginHiColor
	foldMarginHiColor 
		ifNil: [self sciSetFoldMarginHiColour: false fore: nil]
		ifNotNil: [self sciSetFoldMarginHiColour: true fore: foldMarginHiColor asRGB]!

setFoldProperty: aBoolean 
	self isOpen 
		ifTrue: 
			["The HTML lexer uses an additional property"
			#('fold' 'fold.html') 
				do: [:each | self sciSetProperty: each yourAddress value: aBoolean asParameter displayString]]!

setFont: aFont 
	"Private - Apply the specified font to the receiver's associated Windows control"

	super setFont: aFont.
	self updateTextStyles!

setIndicator: anIntegerOrSymbol from: startInteger length: lengthInteger 
	"Apply the indicator identified by the <integer> id or <symbol> name, anIntegerOrSymbol, to
	the range of text in the receiver starting from the one-base integer character position,
	startInteger, for a run length specified by the <integer>, lengthInteger."

	self currentIndicatorId: (self indicatorIdFromName: anIntegerOrSymbol).
	self sciIndicatorFillRange: startInteger - 1 fillLength: lengthInteger!

setIndicator: anIntegerOrSymbol range: anInterval 
	"Apply the indicator identified by the <integer> id or <symbol> name, anIntegerOrSymbol, to
	the range of text specified by the <Interval>, anInterval."

	self 
		setIndicator: anIntegerOrSymbol
		from: anInterval start
		length: anInterval size!

setIndicators: anArray 
	indicators := anArray.
	self updateIndicators!

setIndicatorStyles: aCollection 
	| newStylesByName allocatedStyles availableStyles count |
	count := aCollection size.
	allocatedStyles := OrderedCollection new: count.
	aCollection do: [:each | each basicId ifNotNil: [:id | allocatedStyles add: id]].
	availableStyles := ((INDIC_CONTAINER to: INDIC_MAX) difference: allocatedStyles) readStream.
	newStylesByName := IdentityDictionary new: count.
	aCollection do: 
			[:each | 
			each basicId isNil 
				ifTrue: 
					[availableStyles atEnd ifTrue: [^self error: 'Too many styles'].
					each basicId: availableStyles next].
			newStylesByName at: each name put: each].
	indicatorStyles := newStylesByName.
	self updateIndicatorStyles!

setLexerLanguage: aSymbol 
	aSymbol == #container 
		ifTrue: [self sciSetLexer: SCLEX_CONTAINER]
		ifFalse: 
			[aSymbol == #automatic 
				ifTrue: [self sciSetLexer: SCLEX_AUTOMATIC]
				ifFalse: 
					[self sciSetLexerLanguage: aSymbol.
					self lexer ~~ aSymbol ifTrue: [self error: 'Unrecognised language: ' , aSymbol printString]]]!

setLine: lineInteger state: stateInteger 
	"Associate extra line state information with a particular line."

	self sciSetLineState: lineInteger - 1 state: stateInteger!

setMarginWidths: anArray 
	"Private - Sets the left and right margins of the receiver to anInteger pixels"

	self
		sciSetMarginLeft: anArray first;
		sciSetMarginRight: anArray last!

setRawAnnotations: aCollectionOfScintillaAnnotations 
	"Private - Update the control with the specified collection of annotations in raw form (one
	annotation object per line with linefeed separated annotation text lines, zero-based line
	index, styles represented numerically)."

	self basicRemoveAllAnnotations.
	aCollectionOfScintillaAnnotations do: 
			[:each | 
			self 
				basicAnnotateLine: each line
				withText: each text
				inStyles: each styles].
	"Scintilla doesn't seem to redraw automatically when annotations are set"
	self invalidate!

setReadOnly: readOnlyBoolean 
	"Set to read only or read write."

	self 
		sendMessage: SCI_SETREADONLY
		wParam: readOnlyBoolean asParameter
		lParam: 0!

setSecondarySelectionBackcolor
	selectionBackcolor 
		ifNotNil: [self sciSetAdditionalSelBack: secondarySelectionBackcolor asRGB]!

setSecondarySelectionForecolor
	secondarySelectionForecolor 
		ifNotNil: [self sciSetAdditionalSelFore: secondarySelectionForecolor asRGB]!

setSelectionBackcolor
	selectionBackcolor 
		ifNil: [self sciSetSelBack: false back: nil]
		ifNotNil: 
			[self sciSetSelBack: true back: selectionBackcolor asRGB.
			self setSecondarySelectionBackcolor]!

setSelectionForecolor
	selectionForecolor 
		ifNil: [self sciSetSelFore: false fore: nil]
		ifNotNil: 
			[self sciSetSelFore: true fore: selectionForecolor asRGB.
			self setSecondarySelectionForecolor]!

setTabStops: anInteger 
	"Private - Set the width of the receiver's tab stops to anInteger."

	self tabWidth: anInteger!

setTargetRangeFromSelection
	"Make the target range start and end be the same as the selection range start and end."

	self 
		sendMessage: SCI_TARGETFROMSELECTION
		wParam: 0
		lParam: 0!

setText: aString 
	"Private - Set up the receiver to be displaying the new text in the <String> argument."

	self cancelModes.
	self sciSetText: aString.
	self
		isTextModified: false;
		emptyUndoBuffer.
	"Setting the text removes all current markers - we still tell Scintilla to delete them
	though, since it seems that setting empty text may not remove any markers on line 0."
	self removeAllMarkers.
	"Setting the text also removes the indicators"
	indicators := nil
!

setWhitespaceBackcolor
	whitespaceBackcolor 
		ifNil: [self sciSetWhitespaceBack: false back: nil]
		ifNotNil: [self sciSetWhitespaceBack: true back: whitespaceBackcolor asRGB]!

setWhitespaceChars
	self sciSetWhitespaceChars: whitespaces!

setWhitespaceForecolor
	whitespaceForecolor 
		ifTrue: [self sciSetWhitespaceFore: false fore: nil]
		ifFalse: [self sciSetWhitespaceFore: true fore: whitespaceForecolor asRGB]!

setWordChars
	wordChars isNil ifTrue: [^self].
	self sciSetWordChars: wordChars.
	"Setting word chars causes Scintilla to reset the whitespace chars to the defaults"
	self setWhitespaceChars!

showAutoCompletionList: aCollection prefixLength: anInteger 
	"Display a auto-completion list built from the displayStrings of the elements of the
	<collection> argument. The <Integer> parameter indicates how many characters before the
	caret should be used to provide context."

	"N.B. It is important for correct operation of incremental search in the auto-completion
	list that the collection of items be appropriately sorted. In particular if Scintilla is
	configured to perform case-sensitive auto-completion then the list must be sorted in the
	same order as would result from using strcmp() to compare the items. This is because
	Scintilla uses a binary chop to perform an incremental search of the the list as characters
	are entered, and so it may fail to find items if the sort order is not correct."

	aCollection isEmpty 
		ifTrue: [self cancelAutoCompletion]
		ifFalse: 
			[| string |
			string := self buildItemList: aCollection asSortedCollection.
			self sciAutoCShow: anInteger itemList: string]!

showCallTip: aString at: anInteger 
	"Show the specified <String> as a call tip at the specified <integer> character position."

	self sciCallTipShow: anInteger - 1 definition: aString!

showUserList: aCollection id: anInteger 
	"Display a 'user list' built from the displayStrings of the elements of the <collection>
	argument. The <Integer> parameter is passed back with the SCN_USERLISTSELECTION
	notification."

	self sciUserListShow: anInteger itemList: (self buildItemList: aCollection)!

showVerticalScrollBar: showBoolean 
	"Show or hide the vertical scroll bar."

	self 
		sendMessage: SCI_SETVSCROLLBAR
		wParam: showBoolean asParameter
		lParam: 0!

splitTarget: pixelWidthInteger 
	"Split the lines in the target into lines that are less wide than pixelWidth where
	possible."

	self 
		sendMessage: SCI_LINESSPLIT
		wParam: pixelWidthInteger
		lParam: 0!

startDwellTimer
	self setTimer: 1 interval: 100!

startRecording
	"Start notifying the container of all key presses and commands."

	self 
		sendMessage: SCI_STARTRECORD
		wParam: 0
		lParam: 0!

startStylingFrom: anInteger 
	"Set the current styling position to the one-based <integer> index argument."

	self sciStartStyling: anInteger - 1 mask: self restyleMask!

state
	"Private - Answer a <MessageSequence> which, when replayed, will restore the receiver 
	to its current state"

	"Implementation Note: Each attributes has a 3-element array, respectively the set selector,
	get selector, and default value. State is only saved for an attribute if the current value
	differs from the default.

	The markers must be stored as part of the state, even though stored in an instance variable,
	as these are reset when the text is restored."

	| answer |
	answer := super state.
	#(#(#modificationEventMask: #modificationEventMask ##(SC_MODEVENTMASKALL)) #(#isDrawingBuffered: #isDrawingBuffered true) #(#hoverTime: #hoverTime 10000000) #(#setIndicators: #indicators #()) #(#caretStyle: #caretStyle #line) #(#caretForecolor: #caretForecolor ##(Color 
		black asRGB)) #(#secondaryCaretForecolor: #secondaryCaretForecolor ##(Color darkGray asRGB)) #(#currentLineAlpha: #currentLineAlpha 256) #(#caretPeriod: #caretPeriod 500) #(#caretWidth: #caretWidth 1) #(#getCaretSticky: #sciGetCaretSticky ##(SC_CARETSTICKY_OFF)) #(#isCurrentLineHighlighted: #isCurrentLineHighlighted false) #(#currentLineBackcolor: #currentLineBackcolor ##(Color 
		yellow asRGB)) #(#endOfLineMode: #endOfLineMode #crlf) #(#hasVisibleLineEndings: #hasVisibleLineEndings false) #(#wordWrap: #wordWrap false) #(#layoutCachingMode: #layoutCachingMode #caret) #(#margins: #margins #()) #(#markers: #markers ##(OrderedCollection 
		new)) #(#isOvertypeEnabled: #isOvertypeEnabled false) #(#printMagnification: #printMagnification 0) #(#printColourMode: #printColourMode 0) #(#canHScroll: #canHScroll true) #(#canScrollPastEnd: #canScrollPastEnd true) #(#scrollWidth: #scrollWidth 2000) #(#xOffset: #xOffset 0) #(#selectionMode: #selectionMode #stream) #(#backspaceUnindents: #backspaceUnindents false) #(#indentationGuides: #indentationGuides #none) #(#indentation: #indentation 0) #(#tabIndents: #tabIndents false) #(#tabWidth: #tabWidth 8) #(#isUsingTabs: #isUsingTabs true) #(#targetRange: #targetRange ##(1 
		to: 0)) #(#whitespaceVisibility: #whitespaceVisibility #invisible) #(#autoCompletionSeparator: #autoCompletionSeparator $ ) #(#autoCompletionImageIdSeparator: #autoCompletionImageIdSeparator $?) #(#isAutoCompletionCancelledAtStart: #isAutoCompletionCancelledAtStart true) #(#isAutoCompletionCaseInsensitive: #isAutoCompletionCaseInsensitive false) #(#isAutoCompletionCancelledWhenNoMatch: #isAutoCompletionCancelledWhenNoMatch true) #(#isAutoCompletionTruncating: #isAutoCompletionTruncating false) #(#maxCompletionListHeight: #maxCompletionListHeight 5) #(#maxCompletionListWidth: #maxCompletionListWidth 0) #(#sciSetCodePage: #sciGetCodePage 0) #(#edgeMode: #edgeMode #none) #(#edgeColor: #edgeColor ##(Color 
		gray asRGB)) #(#zoomLevel: #zoomLevel 0) #(#isUsingPalette: #isUsingPalette false) #(#setLexerLanguage: #lexer #container) #(#controlCharacter: #controlCharacter nil) #(#selectionAlpha: #selectionAlpha 256) #(#secondarySelectionAlpha: #secondarySelectionAlpha 256) #(#positionCacheSize: #positionCacheSize 1024) #(#activeHotspotBackcolor: #activeHotspotBackcolor ##(Color 
		white asRGB)) #(#activeHotspotForecolor: #activeHotspotForecolor ##(Color blue asRGB)) #(#areHotspotsSingleLine: #areHotspotsSingleLine true) #(#isKeyboardInputUnicode: #isKeyboardInputUnicode false) #(#annotationMode: #annotationMode #hidden) #(#setRawAnnotations: #getRawAnnotations ##(OrderedCollection 
		new)) #(#extraAscent: #extraAscent 0) #(#extraDescent: #extraDescent 0) #(#areAdditionalCaretsVisible: #areAdditionalCaretsVisible false) #(#sciSetFontQuality: #sciGetFontQuality ##(SC_EFF_QUALITY_DEFAULT)) #(#whitespaceMarkerSize: #whitespaceMarkerSize 1) #(#sciSetMultiPaste: #sciGetMultiPaste ##(SC_MULTIPASTE_ONCE))) 
			do: 
				[:each | 
				| attrib |
				attrib := self perform: each second.
				attrib = each last 
					ifFalse: 
						[| msg |
						msg := MessageSend 
									receiver: self
									selector: each first
									argument: attrib.
						answer add: msg]].
	^answer!

stbVersion
	^14!

stopDwellTimer
	self killTimer: 1!

stopRecording
	"Stop notifying the container of all key presses and commands."

	self 
		sendMessage: SCI_STOPRECORD
		wParam: 0
		lParam: 0!

stopStyling
	"Cancel any further styling for the specified mask by moving the styling end point to the
	end of the document."

	self startStylingFrom: self textLength + 1!

styleAt: anInteger 
	"Answer a <ScintillaTextStyle> being the the style of the character at the specified character
	position."

	^self styleWithId: (self styleIdAt: anInteger)!

styleBits
	"Answer the number of bits available for text styles. See #styleBits for further
	information."

	^styleMask highBit!

styleBits: anInteger 
	"Set the number of bits available for text styles. Originally this defaulted to 5 giving a
	total of 32 user configurable styles, allowing 3 bits for indicators. With the advent of
	modern indicators (which are stored separately from styles) all 8 bits are available for
	styles."

	(anInteger between: 1 and: 8) ifFalse: [self error: 'Invalid number of style bits'].
	self styleBits = anInteger ifTrue: [^self].
	styleMask := (1 << anInteger) - 1.
	self sciSetStyleBits: anInteger.
	"Changing the number of style bits necessitates recreating the control, else the text pane will just go black"
	self recreate!

styledTextFrom: startInteger to: stopInteger 
	"Private - Answer a <ByteArray> containing pairs of bytes that represent the character and
	style byte for each position in the specified range."

	| bytes range |
	startInteger < 1 ifTrue: [self errorSubscriptBounds: startInteger].
	stopInteger < startInteger ifTrue: [#()].
	stopInteger > self textLength ifTrue: [self errorSubscriptBounds: stopInteger].
	"Note extra two bytes needed for null-terminator"
	bytes := ByteArray newFixed: (stopInteger - startInteger + 1 + 1) * 2.
	range := TEXTRANGE 
				from: startInteger - 1
				to: stopInteger
				text: bytes.
	self sciGetStyledText: range.
	"Drop the redundant null terms"
	bytes resize: bytes size - 2.
	^bytes!

styleIdAt: anInteger 
	^(self styleMaskAt: anInteger) bitAnd: styleMask!

styleMaskAt: anInteger 
	"Inlined to cut overhead when scanning text for the start of a style."

	^self 
		sendMessage: SCI_GETSTYLEAT
		wParam: anInteger - 1
		lParam: 0!

styleNamed: aSymbol 
	"Answer a <ScintillaTextStyle> being the named style, or nil if the name is not recognised."

	^currentTextStyles at: aSymbol ifAbsent: []!

styleNext: lengthInteger mask: styleInteger 
	"Change style from current styling position for length characters to a style and move the
	current styling position to after this newly styled segment."

	self 
		sendMessage: SCI_SETSTYLING
		wParam: lengthInteger
		lParam: styleInteger!

styler
	"Answer the <ScintillaStyler> used to dynamically colour text in the receiver."

	styler isNil ifTrue: [styler := NullScintillaStyler new].
	^styler!

styler: aScintillaStyler 
	"Set the <ScintillaStyler> used to dynamically colour text in the receiver."

	styler := aScintillaStyler.
	styler prepareToStyleView: self.
	self invalidateStyling!

stylerClass
	"Answer the class of the receiver's dynamic styler."

	^self styler class!

stylerClass: aScintillaStylerClass 
	"Set the class of the receiver's dynamic styler, replacing the styler with a new instance of the specified class."

	self styler: (aScintillaStylerClass ifNil: [NullScintillaStyler]) new!

styleUnderCaret
	"Answer a <ScintillaTextStyle> representing the style of the character under the caret."

	^self styleAt: self caretPosition!

styleWithId: anInteger 
	^(styleIdMap at: anInteger + 1 ifAbsent: []) 
		ifNil: 
			[(ScintillaTextStyle new)
				name: anInteger;
				yourself]!

stylingPosition
	"Answer the one-based <integer> index of the next character in the receiver that requires styling."

	^self sciGetEndStyled + 1!

swapPrimarySelectionAnchorAndCaret
	"Swap that caret and anchor of the main selection."

	self 
		sendMessage: SCI_SWAPMAINANCHORCARET
		wParam: 0
		lParam: 0!

tabIndents
	"Does a tab pressed when caret is within indentation indent?"

	^(self 
		sendMessage: SCI_GETTABINDENTS
		wParam: 0
		lParam: 0) asBoolean!

tabIndents: tabIndentsBoolean 
	"Sets whether a tab pressed when caret is within indentation indents."

	self 
		sendMessage: SCI_SETTABINDENTS
		wParam: tabIndentsBoolean asParameter
		lParam: 0!

tabWidth
	"Retrieve the visible size of a tab."

	^self 
		sendMessage: SCI_GETTABWIDTH
		wParam: 0
		lParam: 0!

tabWidth: tabWidthInteger 
	"Change the visible size of a tab to be a multiple of the width of a space character."

	self 
		sendMessage: SCI_SETTABWIDTH
		wParam: tabWidthInteger
		lParam: 0!

targetAll
	"Target all the text in the receiver, and answer the new selection range."

	| interval |
	interval := 1 to: self textLength.
	self targetRange: interval.
	^interval!

targetRange
	"Answer the range of the current search/replace target. The target is like the selection,
	but not visible."

	^self sciGetTargetStart + 1 to: self sciGetTargetEnd!

targetRange: anInterval 
	"Set the range of the current search/replace target. The target is like the selection,
	but not visible."

	self sciSetTargetStart: anInterval start - 1.
	self sciSetTargetEnd: anInterval stop!

textAtLine: anInteger 
	"Private - Answer the text of a line at the given line index (1-based)."

	"Implementation Note: The result will include any line terminators, which we should probably
	strip off here."

	| length text |
	anInteger <= 0 ifTrue: [^self errorSubscriptBounds: anInteger].
	"As of 1.60, Scintilla reports line length if passed null buffer"
	length := self sciGetLine: anInteger - 1 text: nil.
	text := String newFixed: length.
	self sciGetLine: anInteger - 1 text: text.
	^text!

textLength
	"Retrieve the number of characters in the document."

	^self 
		sendMessage: SCI_GETTEXTLENGTH
		wParam: 0
		lParam: 0!

textLimit
	"Answer the current text limit for the control (i.e. the amount of text it can hold)."

	^SmallInteger maximum

!

textLimit: anInteger 
	"Set the maximum text limit for the receiver."

	"Implementation Note: Ignored as not supported by Scintilla."

	^self!

textStyles
	"Answer the currently configured <collection> of <ScintillaTextStyle>s. 
	This collection should be considered as immutable - any changes to its elements, or the
	addition/removal/replacement of elements, will not result in the view being updated. To
	change text styles the entire collection must be replaced."

	^(currentTextStyles values asSortedCollection: ScintillaAttribute sortByIdBlock) asArray!

textStyles: aCollection 
	"Set the collection of <ScintillaTextStyle>s configured for the receiver to be those
	specified in the argument. This may involve removing old style definitions, and adding new
	ones."

	"Implementation Note: Like most of Scintilla's attributes, text styles are numbered by
	integer indices .As this is a somewhat inconvenient representation, we allow styles to be
	given symbolic names. Any pre-existing styles (i.e. styles of the same name) maintain their
	index so that existing styled text remains associated with the correct style. Normally a new
	style is allocated the first available style number, however certain style names are
	associated with Scintilla's predefined styles and so these names are always mapped to the
	same style number."

	self setCurrentTextStyles: aCollection.
	allTextStyles at: self lexer put: currentTextStyles!

toggleFold: anInteger 
	self sciToggleFold: anInteger - 1!

toggleFoldMargin
	"Show or hide the first fold margin, inverting the current state."

	self hasFoldMargin: self hasFoldMargin not!

toggleIndentationGuides
	"Show or hide the indentation guides."

	self hasIndentationGuides: self hasIndentationGuides not!

toggleLineEndings
	"Show or hide the end-of-line characters."

	self hasVisibleLineEndings: self hasVisibleLineEndings not!

toggleLineNumbers
	"Show or hide the first line number margin, inverting the current state."

	self hasLineNumbers: self hasLineNumbers not!

toggleOvertype
	"Switch from insert to overtype mode or the reverse."

	self 
		sendMessage: SCI_EDITTOGGLEOVERTYPE
		wParam: 0
		lParam: 0!

toggleStyling
	"Enable/disable dynamic styling of text in the receiver."

	self isStylingEnabled: self isStylingEnabled not!

toggleWhitespace
	"Show or hide the whitespace markers in the view."

	self whitespaceVisibility: (self whitespaceVisibility == #invisible 
				ifTrue: [#visibleAlways]
				ifFalse: [#invisible])!

toggleWordWrap
	"Toggle the receiver into/out-of word wrap mode."

	self wordWrap: self wordWrap not!

tokenEndAt: anInteger 
	"Answer the <integer> end position of the token that includes the specified <integer>
	position. This is dependent on there being valid styling information available, and that the
	styles delimit tokens."

	| stop tokenId max |
	tokenId := self styleIdAt: anInteger.
	stop := anInteger.
	max := self textLength.
	[stop < max and: [(self styleIdAt: stop + 1) == tokenId]] whileTrue: [stop := stop + 1].
	^stop!

tokenRangeAt: anInteger 
	"Answer the <Interval> of text in the receiver occuppied by the token under the specified
	<integer> position. This is dependent on there being valid styling information available,
	and that the styles delimit tokens."

	^(self tokenStartAt: anInteger) to: (self tokenEndAt: anInteger)!

tokensFrom: startInteger to: stopInteger 
	"Answer an <sequencedReadableCollection> of <Associations> representing the tokenised form
	of the text in the specified range, as deduced from the styling information. The key of each
	association is the name of the style, and the value is the token text."

	| bytes |
	bytes := self styledTextFrom: startInteger to: stopInteger.
	^self decodeStyledText: bytes!

tokenStartAt: anInteger 
	"Answer the <integer> start position of the token that includes the specified <integer>
	position. This is dependent on there being valid styling information available, and that the
	styles delimit tokens."

	| start tokenId |
	tokenId := self styleIdAt: anInteger.
	start := anInteger.
	[start > 1 and: [(self styleIdAt: start - 1) == tokenId]] whileTrue: [start := start - 1].
	^start!

twiddleLines
	"Switch the current line with the previous."

	self 
		sendMessage: SCI_LINETRANSPOSE
		wParam: 0
		lParam: 0!

undo
	"Undo one action in the undo history."

	self cancelModes.
	self basicUndo!

unindent
	"Dedent the selected lines."

	self 
		sendMessage: SCI_BACKTAB
		wParam: 0
		lParam: 0!

updateIndicators
	self basicClearContainerIndicators.
	indicators do: [:each | self setIndicator: each styleName range: each range]!

updateIndicatorStyles
	self hideIndicators.
	indicatorStyles ifNotNil: [:indics | indics do: [:each | each applyToView: self at: each basicId]]!

updateKeyBindings
	"Private - Update the control with the key bindings configured for the receiver, replacing
	its default command key assignments."

	self sciClearAllCmdKeys.
	self keyBindings do: [:each | self sciAssignCmdKey: each scintillaKeyCode msg: each message]!

updateMarkerDefinitions
	markerDefinitions do: [:each | each applyToView: self at: each basicId]!

updateMarkers
	self deleteMarkers: 0.
	markers do: [:each | each addToView: self]!

updateTextStyles
	"Private - Sync. the control's knowledge of the text styles with those recorded in the receiver."

	self isOpen ifFalse: [^self].
	"Ensure there is a call tip style"
	self callTipStyle.
	"Note that this will clear the annotation and margin styles too"
	self setDefaultTextStyle.
	currentTextStyles do: [:each | each applyToView: self].
	self annotationStylesOffset: AnnotationStylesOffset.
	self annotationStyles do: [:each | each applyToView: self]!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time
	when the UI has been flagged as being invalid"

	self isBraceHighlightingEnabled ifTrue: [self braceHighlight].
	super validateUserInterface!

whitespaceBackcolor
	"Answer the background colour of all whitespace, or nil if none is specified. If no global
	white space background colour, then the default colour is used. This will be that of
	whatever style the styler is setting on blocks of whitespace, otherwise the default
	background colour of the view."

	^whitespaceBackcolor!

whitespaceBackcolor: aColorOrNil 
	"Set the background colour of all whitespace. The argument can be nil to adopt the default
	background colour."

	whitespaceBackcolor := aColorOrNil.
	self setWhitespaceBackcolor!

whitespaceForecolor
	"Answer the foreground colour used to display whitespace markers (when visible). If nil then
	the default whitespace colour is being used. This will be that of whatever style the styler
	is setting on blocks of whitespace (which could be a specially allocated whitespace style,
	or just the normal style), otherwise the default foreground colour of the view."

	^whitespaceForecolor!

whitespaceForecolor: aColorOrNil 
	"Set the foreground colour to be used to display whitespace markers (when visible). If nil
	then the default white space colour will be used."

	whitespaceForecolor := aColorOrNil.
	self setWhitespaceForecolor!

whitespaceMarkerSize
	"Get the size of the dots used to mark space characters."

	^self 
		sendMessage: SCI_GETWHITESPACESIZE
		wParam: 0
		lParam: 0!

whitespaceMarkerSize: sizeInteger 
	"Set the size of the dots used to mark space characters."

	self 
		sendMessage: SCI_SETWHITESPACESIZE
		wParam: sizeInteger
		lParam: 0!

whitespaces
	^whitespaces!

whitespaces: aString 
	whitespaces := aString ifNil: [Whitespaces].
	self setWhitespaceChars!

whitespaceVisibility
	"Answer a <Symbol> naming the level of whitespace marking currently configured in the receiver."

	^self class whitespaceVisibilityLevels 
		at: (self 
				sendMessage: SCI_GETVIEWWS
				wParam: 0
				lParam: 0) + 1!

whitespaceVisibility: aSymbol 
	"Make white space characters invisible, always visible or visible outside indentation
	depending on the <Symbol> argument (one of #invisible, #visibleAlways or
	#visibleAfterIndent, respectively)."

	self 
		sendMessage: SCI_SETVIEWWS
		wParam: (self class whitespaceVisibilityLevels indexOf: aSymbol) - 1
		lParam: 0!

widthOfText: aString inStyle: aSymbol 
	"Answer the <integer> pixel width that would be needed to display the text in the <String>
	argument in the text style named by the <Symbol> argument."

	^self sciTextWidth: ((self styleNamed: aSymbol) ifNil: [0] ifNotNil: [:style | style id])
		text: aString!

willCaptureMouse
	"Get whether mouse gets captured."

	^(self 
		sendMessage: SCI_GETMOUSEDOWNCAPTURES
		wParam: 0
		lParam: 0) asBoolean!

willCaptureMouse: capturesBoolean 
	"Set whether the mouse is captured when its button is pressed."

	self 
		sendMessage: SCI_SETMOUSEDOWNCAPTURES
		wParam: capturesBoolean asParameter
		lParam: 0!

wmChar: message wParam: wParam lParam: lParam 
	"Private - Handle WM_CHAR. Implementation Note: We override here in order to allow
	the correct behaviour for the RETURN key in dialogs (i.e. to send a the id of the default
	button to the dialog).We only need to do this if the receiver has specifically said that it
	does not wantReturns.

	See also #wmKeyDown:wParam:lParam:"

	(wParam == VK_RETURN and: [self wantReturn not & self isAutoCompletionActive not]) 
		ifTrue: [^0	"Suppress default processing"].
	^super 
		wmChar: message
		wParam: wParam
		lParam: lParam!

wmContextMenu: message wParam: wParam lParam: lParam 
	"Private - Shows and tracks a context menu for the receiver"

	self cancelModes.
	^super wmContextMenu: message wParam: wParam lParam: lParam!

wmKeyDown: message wParam: wParam lParam: lParam 
	"Private - Handle WM_KEYDOWN. Implementation Note: We override here in order to allow
	the correct behaviour for the RETURN key in dialogs (i.e. to send a the id of the default
	button to the dialog).We only need to do this if the receiver has specifically said that it
	does not wantReturns.

	Note also that we must accept VK_RETURN if it is being used to dismiss an auto completetion
	box."

	(wParam == VK_RETURN and: [self wantReturn not & self isAutoCompletionActive not]) 
		ifTrue: 
			[| shell defId |
			shell := self topShell view.
			defId := shell getItemHandle: shell defaultButtonId
						ifAbsent: 
							[^super 
								wmKeyDown: message
								wParam: wParam
								lParam: lParam].
			shell 
				sendMessage: WM_COMMAND
				wParam: BN_CLICKED << 16 | shell defaultButtonId
				lParam: defId.
			^0	"Suppress default processing"].
	^super 
		wmKeyDown: message
		wParam: wParam
		lParam: lParam!

wmTimer: message wParam: wParam lParam: lParam 
	"Private - A timer event, identified by the <integer> id, wParam, has fired."

	"Implementation Note: Scintilla uses a rapidly firing timer, id 1, that we want to ignore"

	^wParam == 1 
		ifFalse: 
			[super 
				wmTimer: message
				wParam: wParam
				lParam: lParam]!

wordChars
	"Answer a <String> containting the set of characters considered to be those valid as
	characters in a single word. All other characters are considered to be delimiters. This
	setting controls word-oriented cursor movements and selections."

	^wordChars 
		ifNil: 
			[| lib |
			lib := CRTLibrary default.
			"This replicates the Scintilla default (this property of the control is not queryable), 
			although personally I think this includes too many control/graphic characters."
			Character byteCharacterSet 
				select: [:each | each == $_ or: [each codePoint >= 16r80 or: [lib isalnum: each]]]]!

wordChars: aString 
	"Set the set of characters considered to be those valid as characters in a single word. All
	other characters are considered to be delimiters. This setting controls word-oriented cursor
	movements and selections."

	wordChars := aString.
	self setWordChars!

wordWrap
	"Answer whether the receiver is in word-wrap mode."

	"From the Scintilla Documentation: 'By default, Scintilla does not wrap lines of text. If 
	you enable line wrapping, lines wider than the window width are continued on the following 
	lines. Lines are broken after space or tab characters or between runs of different styles. 
	If this is not possible because a word in one style is wider than the window then the break 
	occurs after the last character that completely fits on the line. The horizontal scroll bar 
	does not appear when wrap mode is on.'"

	^self sciGetWrapMode = SC_WRAP_WORD!

wordWrap: aBoolean 
	"Set whether the receiver is in word-wrap mode."

	self sciSetWrapMode: (aBoolean ifTrue: [SC_WRAP_WORD] ifFalse: [SC_WRAP_NONE])!

wrapIndentMode
	"Answer the current indenting mode used when wrapping lines. This can be one of #fixed
	(indent to a fixed point, by default no indent), #same (indent to the same point as the start
	of the wrapped line), or #indent (indent from the start of the wrapped line by one tab
	width)."

	^WrapIndentModes at: self sciGetWrapIndentMode + 1 ifAbsent: [#fixed]!

wrapIndentMode: aSymbol 
	self sciSetWrapIndentMode: (WrapIndentModes keyAtValue: aSymbol) - 1!

xOffset
	^self 
		sendMessage: SCI_GETXOFFSET
		wParam: 0
		lParam: 0!

xOffset: newOffsetInteger 
	"Get and Set the xOffset (ie, horizonal scroll position)."

	self 
		sendMessage: SCI_SETXOFFSET
		wParam: newOffsetInteger
		lParam: 0!

zoomIn
	"Magnify the displayed text by increasing the sizes by 1 point."

	self 
		sendMessage: SCI_ZOOMIN
		wParam: 0
		lParam: 0!

zoomLevel
	"Retrieve the zoom level."

	^self 
		sendMessage: SCI_GETZOOM
		wParam: 0
		lParam: 0!

zoomLevel: zoomInteger 
	"Set the zoom level. This number of points is added to the size of all fonts. It may be
	positive to magnify or negative to reduce."

	self 
		sendMessage: SCI_SETZOOM
		wParam: zoomInteger
		lParam: 0!

zoomOut
	"Make the displayed text smaller by decreasing the sizes by 1 point."

	self 
		sendMessage: SCI_ZOOMOUT
		wParam: 0
		lParam: 0! !
!ScintillaView categoriesFor: #acceptAutoCompletion!**auto generated**!autocompletion!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #activeHotspotBackcolor!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #activeHotspotBackcolor:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #activeHotspotForecolor!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #activeHotspotForecolor:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #addAnnotation:!adding!annotations!public! !
!ScintillaView categoriesFor: #addKeyBinding:!key bindings!public! !
!ScintillaView categoriesFor: #addMarker:!markers!public! !
!ScintillaView categoriesFor: #addMarkerType:at:!markers!public! !
!ScintillaView categoriesFor: #anchorPosition!accessing!public!selection! !
!ScintillaView categoriesFor: #anchorPosition:!accessing!public!selection! !
!ScintillaView categoriesFor: #annotateLine:withAll:!public! !
!ScintillaView categoriesFor: #annotationMode!accessing!annotations!public! !
!ScintillaView categoriesFor: #annotationMode:!accessing!annotations!public! !
!ScintillaView categoriesFor: #annotations!accessing!annotations!public! !
!ScintillaView categoriesFor: #annotations:!indicators!public! !
!ScintillaView categoriesFor: #annotationsForLine:!accessing!annotations!public! !
!ScintillaView categoriesFor: #annotationsFromRawAnnotation:!annotations!converting!helpers!private! !
!ScintillaView categoriesFor: #annotationStyles!accessing!annotations!public!style definition! !
!ScintillaView categoriesFor: #annotationStyles:!accessing!annotations!public!style definition! !
!ScintillaView categoriesFor: #annotationStylesFromStyleBytes:!annotations!converting!private! !
!ScintillaView categoriesFor: #annotationStylesOffset!**auto generated**!accessing!annotations!public!scintilla interface! !
!ScintillaView categoriesFor: #annotationStylesOffset:!**auto generated**!accessing!annotations!public!scintilla interface! !
!ScintillaView categoriesFor: #appendText:!public!text retrieval & modification! !
!ScintillaView categoriesFor: #applyAttributes:!helpers!private! !
!ScintillaView categoriesFor: #applyStyle:toNext:!public!styling! !
!ScintillaView categoriesFor: #applyStyleId:toNext:!public!styling! !
!ScintillaView categoriesFor: #applyTextStylesForLexer:!helpers!lexer!private! !
!ScintillaView categoriesFor: #areAdditionalCaretsVisible!**auto generated**!caret!public!scintilla interface! !
!ScintillaView categoriesFor: #areAdditionalCaretsVisible:!**auto generated**!caret!public!scintilla interface! !
!ScintillaView categoriesFor: #areHotspotsSingleLine!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #areHotspotsSingleLine:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionAcceptChars!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionAcceptChars:!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionCancelChars!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionCancelChars:!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionImageIdSeparator!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionImageIdSeparator:!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionListPosition!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionSeparator!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionSeparator:!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #backcolorChanged!helpers!private! !
!ScintillaView categoriesFor: #backspace!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #backspaceNoLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #backspaceUnindents!**auto generated**!public!scintilla interface!tabs & indentation guides!testing! !
!ScintillaView categoriesFor: #backspaceUnindents:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #basicAnnotateLine:withText:inStyles:!annotations!helpers!private! !
!ScintillaView categoriesFor: #basicClearContainerIndicators!indicators!private! !
!ScintillaView categoriesFor: #basicClearSelection!**auto generated**!helpers!public!scintilla interface! !
!ScintillaView categoriesFor: #basicLineFromPosition:!**auto generated**!enquiries!public!scintilla interface! !
!ScintillaView categoriesFor: #basicPositionAtLine:!**auto generated**!enquiries!public!scintilla interface! !
!ScintillaView categoriesFor: #basicRemoveAllAnnotations!**auto generated**!annotations!public!removing!scintilla interface! !
!ScintillaView categoriesFor: #basicSelectAll!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #basicSelectionRange!private!selection! !
!ScintillaView categoriesFor: #basicSelectionStart:end:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #basicUndo!**auto generated**!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #beginUndoGroup!**auto generated**!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #boundingRectangleOfTextRange:!helpers!private! !
!ScintillaView categoriesFor: #braceChars!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #braceChars:!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #braceHighlight!brace highlighting!helpers!private! !
!ScintillaView categoriesFor: #buildAnnotationStyles:!annotations!private!style definition! !
!ScintillaView categoriesFor: #buildDefaultStyle!private!style definition! !
!ScintillaView categoriesFor: #buildItemList:!autocompletion!private! !
!ScintillaView categoriesFor: #buildRawAnnotations:!annotations!converting!helpers!private! !
!ScintillaView categoriesFor: #buildViewStyle!helpers!private! !
!ScintillaView categoriesFor: #callTipBackcolor!accessing!call tips!public! !
!ScintillaView categoriesFor: #callTipBackcolor:!accessing!call tips!public! !
!ScintillaView categoriesFor: #callTipForecolor!accessing!call tips!public! !
!ScintillaView categoriesFor: #callTipForecolor:!accessing!call tips!public! !
!ScintillaView categoriesFor: #callTipHighlightColor!accessing!call tips!public! !
!ScintillaView categoriesFor: #callTipHighlightColor:!accessing!call tips!public! !
!ScintillaView categoriesFor: #callTipPosition!accessing!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #callTipStyle!accessing!call tips!private! !
!ScintillaView categoriesFor: #callTipTabWidth!accessing!public! !
!ScintillaView categoriesFor: #callTipTabWidth:!accessing!public! !
!ScintillaView categoriesFor: #cancelAutoCompletion!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #cancelCallTip!**auto generated**!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #cancelModes!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #canHScroll!**auto generated**!public!scintilla interface!scrolling!testing! !
!ScintillaView categoriesFor: #canHScroll:!accessing!public!scrolling! !
!ScintillaView categoriesFor: #canonicalizeLineEndings:!line endings!public! !
!ScintillaView categoriesFor: #canPaste!clipboard operations!public!testing! !
!ScintillaView categoriesFor: #canRedo!**auto generated**!public!scintilla interface!testing!undo & redo! !
!ScintillaView categoriesFor: #canScrollPastEnd!public!scrolling!testing! !
!ScintillaView categoriesFor: #canScrollPastEnd:!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #canUndo!**auto generated**!public!scintilla interface!testing!undo & redo! !
!ScintillaView categoriesFor: #canVScroll!**auto generated**!public!scintilla interface!scrolling!testing! !
!ScintillaView categoriesFor: #caretForecolor!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretForecolor:!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretPeriod!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretPeriod:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretPosition!accessing!caret!public!selection! !
!ScintillaView categoriesFor: #caretPosition:!accessing!caret!public! !
!ScintillaView categoriesFor: #caretScreenCoordinates!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretStyle!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #caretStyle:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #caretWidth!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretWidth:!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #centerCurrentLine!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #characterAt:!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #charCloseToPosition:!public!selection! !
!ScintillaView categoriesFor: #charNearestPosition:!public!selection! !
!ScintillaView categoriesFor: #clearAll!**auto generated**!commands!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #clearContainerIndicators!indicators!public! !
!ScintillaView categoriesFor: #clearIndicator:from:to:!indicators!public! !
!ScintillaView categoriesFor: #codePage!accessing!public! !
!ScintillaView categoriesFor: #codePage:!accessing!public! !
!ScintillaView categoriesFor: #columnFromPosition:!enquiries!public! !
!ScintillaView categoriesFor: #controlCharacter!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #controlCharacter:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #convertToLowercase!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #convertToUppercase!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #copyLine!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #copySelection!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #copySelectionOrLine!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #currentIndicatorId!**auto generated**!indicators!public!scintilla interface! !
!ScintillaView categoriesFor: #currentIndicatorId:!**auto generated**!indicators!public!scintilla interface! !
!ScintillaView categoriesFor: #currentIndicatorValue!**auto generated**!indicators!public!scintilla interface! !
!ScintillaView categoriesFor: #currentIndicatorValue:!**auto generated**!indicators!public!scintilla interface! !
!ScintillaView categoriesFor: #currentLineAlpha!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #currentLineAlpha:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #currentLineBackcolor!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #currentLineBackcolor:!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #cutLine!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #cutSelection!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #decodeStyledText:!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #defaultBraceChars!brace highlighting!constants!private! !
!ScintillaView categoriesFor: #defaultKeyBindings!helpers!key bindings!private! !
!ScintillaView categoriesFor: #defaultMarkerDefinitions!constants!markers!private! !
!ScintillaView categoriesFor: #defaultModEventMask!constants!private! !
!ScintillaView categoriesFor: #defaultTextStylesFor:!constants!public!style definition! !
!ScintillaView categoriesFor: #defaultWhitespaceChars!constants!public! !
!ScintillaView categoriesFor: #defaultWindowStyle!constants!private! !
!ScintillaView categoriesFor: #defaultWordChars!constants!public! !
!ScintillaView categoriesFor: #deleteLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteMarkers:!**auto generated**!markers!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToEndOfLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToEndOfWord!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToNextWord!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToStartOfLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToStartOfWord!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #destroyAutoCompletionListImages!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #duplicateLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #duplicateSelection!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColor!**auto generated**!accessing!long lines!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColor:!**auto generated**!accessing!long lines!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColumn!accessing!long lines!public! !
!ScintillaView categoriesFor: #edgeColumn:!accessing!long lines!public! !
!ScintillaView categoriesFor: #edgeMode!accessing!long lines!public! !
!ScintillaView categoriesFor: #edgeMode:!accessing!long lines!public! !
!ScintillaView categoriesFor: #editStyles!commands!public! !
!ScintillaView categoriesFor: #emptyUndoBuffer!**auto generated**!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #enChange!event handling-win32!private! !
!ScintillaView categoriesFor: #endOfLineMode!accessing!line endings!public! !
!ScintillaView categoriesFor: #endOfLineMode:!accessing!line endings!public! !
!ScintillaView categoriesFor: #endUndoGroup!**auto generated**!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #enKillFocus!event handling-win32!private! !
!ScintillaView categoriesFor: #enSetFocus!event handling-win32!private! !
!ScintillaView categoriesFor: #ensureCaretVisible!caret!public! !
!ScintillaView categoriesFor: #ensureHasAnnotationStyles!annotations!helpers!initializing!private! !
!ScintillaView categoriesFor: #ensureLineVisible:!public!scrolling! !
!ScintillaView categoriesFor: #ensureVisible:!public!scrolling! !
!ScintillaView categoriesFor: #enUpdate!event handling-win32!private! !
!ScintillaView categoriesFor: #errorStatus!**auto generated**!error handling!public!scintilla interface! !
!ScintillaView categoriesFor: #errorStatus:!**auto generated**!error handling!public!scintilla interface! !
!ScintillaView categoriesFor: #extendDown!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendLeft!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendPageDown!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendPageUp!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendParaDown!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendParaUp!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleDown!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleLeft!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectanglePageDown!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectanglePageUp!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleRight!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleToEndOfLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleToStartOfLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleToVcHome!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleUp!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRight!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendStutteredPageDown!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendStutteredPageUp!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfDisplayLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfDocument!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfNextWord!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfPreviousWord!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfWord!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfWordPart!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfWrappedLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfDisplayLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfDocument!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfWord!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfWordPart!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfWrappedLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToVcHome!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToWrappedVcHome!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendUp!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extraAscent!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #extraAscent:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #extraDescent!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #extraDescent:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #extraStyleBits!accessing!public!style definition! !
!ScintillaView categoriesFor: #extraStyleBits:!accessing!public!style definition! !
!ScintillaView categoriesFor: #extraStyleMask!accessing!private! !
!ScintillaView categoriesFor: #find:range:!private!searching & replacing! !
!ScintillaView categoriesFor: #find:range:flags:!public!searching & replacing! !
!ScintillaView categoriesFor: #findAutoCompletionEntry:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #findMatchingBrace:!brace highlighting!public! !
!ScintillaView categoriesFor: #findStyleStart:before:!brace highlighting!public! !
!ScintillaView categoriesFor: #firstVisibleLine:!public!scrolling! !
!ScintillaView categoriesFor: #foldFlags!accessing!folding!public! !
!ScintillaView categoriesFor: #foldFlags:!accessing!folding!public! !
!ScintillaView categoriesFor: #foldLine:level:!folding!public!scintilla interface! !
!ScintillaView categoriesFor: #foldMargin!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginColor!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginColor:!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginHiColor!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginHiColor:!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarkerStyle!accessing!folding!markers!public! !
!ScintillaView categoriesFor: #foldMarkerStyle:!accessing!folding!markers!public! !
!ScintillaView categoriesFor: #fontQuality!other settings!public! !
!ScintillaView categoriesFor: #fontQuality:!other settings!public! !
!ScintillaView categoriesFor: #forecolor:!accessing!public! !
!ScintillaView categoriesFor: #formatRectangle!accessing!public! !
!ScintillaView categoriesFor: #formFeed!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #getDirectPointer!accessing!private! !
!ScintillaView categoriesFor: #getLexerLanguage!accessing!lexer!public! !
!ScintillaView categoriesFor: #getLineState:!public!styling! !
!ScintillaView categoriesFor: #getRawAnnotation:!accessing!annotations!private! !
!ScintillaView categoriesFor: #getRawAnnotations!accessing!annotations!private! !
!ScintillaView categoriesFor: #goto:!caret!public! !
!ScintillaView categoriesFor: #gotoLine:!caret!commands!public! !
!ScintillaView categoriesFor: #handle:!accessing!private! !
!ScintillaView categoriesFor: #hangingIndent!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #hangingIndent:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #hasBlinkingSecondaryCarets!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #hasBlinkingSecondaryCarets:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #hasFoldMargin!folding!margins!public!testing! !
!ScintillaView categoriesFor: #hasFoldMargin:!folding!margins!public! !
!ScintillaView categoriesFor: #hasIndentationGuides!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #hasIndentationGuides:!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #hasLineNumbers!public!testing! !
!ScintillaView categoriesFor: #hasLineNumbers:!commands!margins!public! !
!ScintillaView categoriesFor: #hasVisibleLineEndings!**auto generated**!line endings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #hasVisibleLineEndings:!**auto generated**!line endings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #hideExtraIndicators!helpers!private! !
!ScintillaView categoriesFor: #hideIndicators!helpers!indicators!private! !
!ScintillaView categoriesFor: #hideSelection:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #highlightBracesAt:and:!brace highlighting!public! !
!ScintillaView categoriesFor: #highlightCallTipFrom:to:!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #highlightFindMatch:!private!searching & replacing! !
!ScintillaView categoriesFor: #highlightGuide!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #highlightGuide:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #highlightMismatchedBrace:!brace highlighting!public! !
!ScintillaView categoriesFor: #highlightRange:withIndicator:!indicators!public! !
!ScintillaView categoriesFor: #hoverTime!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #hoverTime:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #idOfStyleNamed:!helpers!private! !
!ScintillaView categoriesFor: #indent!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #indentation!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentation:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationGuides!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationGuides:!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationOfLine:!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indicatorCount!constants!indicators!public! !
!ScintillaView categoriesFor: #indicatorDefinitions!indicators!public! !
!ScintillaView categoriesFor: #indicatorDefinitions:!indicators!public! !
!ScintillaView categoriesFor: #indicatorIdFromName:!indicators!private! !
!ScintillaView categoriesFor: #indicatorMaskAt:!indicators!public! !
!ScintillaView categoriesFor: #indicators!indicators!public! !
!ScintillaView categoriesFor: #indicators:!indicators!public! !
!ScintillaView categoriesFor: #indicatorsAt:!accessing!public! !
!ScintillaView categoriesFor: #indicatorStyles!public! !
!ScintillaView categoriesFor: #indicatorStyles:!public! !
!ScintillaView categoriesFor: #indicatorsUnder:!event handling!private! !
!ScintillaView categoriesFor: #initialize!initializing!public! !
!ScintillaView categoriesFor: #initializeControl!initializing!private! !
!ScintillaView categoriesFor: #insertText:at:!public!text retrieval & modification! !
!ScintillaView categoriesFor: #insertText:from:!**auto generated**!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #invalidateStyling!public!styling! !
!ScintillaView categoriesFor: #isActiveHotspotUnderlined!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isActiveHotspotUnderlined:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionActive!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledAtStart!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledAtStart:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledWhenNoMatch!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledWhenNoMatch:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionCaseInsensitive!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCaseInsensitive:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionSingleMatchChosen!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionSingleMatchChosen:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionTruncating!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionTruncating:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isBackgroundDwellEnabled!brace highlighting!public! !
!ScintillaView categoriesFor: #isBackgroundDwellEnabled:!brace highlighting!public! !
!ScintillaView categoriesFor: #isBraceAt:!brace highlighting!private!testing! !
!ScintillaView categoriesFor: #isBraceHighlightingEnabled!brace highlighting!public! !
!ScintillaView categoriesFor: #isBraceHighlightingEnabled:!brace highlighting!public! !
!ScintillaView categoriesFor: #isCallTipActive!**auto generated**!call tips!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isCaretSticky!caret, selection, and hotspot styles!public!testing! !
!ScintillaView categoriesFor: #isCaretSticky:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #isCurrentLineHighlighted!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isCurrentLineHighlighted:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isCurrentLineMarkedWith:!markers!public!testing! !
!ScintillaView categoriesFor: #isDrawingBuffered!**auto generated**!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isDrawingBuffered:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #isDrawingTwoPhase!**auto generated**!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isDrawingTwoPhase:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #isFoldingEnabled!folding!public!testing! !
!ScintillaView categoriesFor: #isFoldingEnabled:!accessing!folding!public! !
!ScintillaView categoriesFor: #isIndicator:setAt:!indicators!public! !
!ScintillaView categoriesFor: #isKeyboardInputUnicode!**auto generated**!other settings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isKeyboardInputUnicode:!**auto generated**!accessing!other settings!public!scintilla interface! !
!ScintillaView categoriesFor: #isLine:folded:!folding!public!scintilla interface! !
!ScintillaView categoriesFor: #isLine:markedWith:!markers!public!testing! !
!ScintillaView categoriesFor: #isLineVisible:!folding!public!testing! !
!ScintillaView categoriesFor: #isMultiSelect!**auto generated**!public!scintilla interface!selection!testing! !
!ScintillaView categoriesFor: #isMultiSelect:!**auto generated**!accessing!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #isOvertypeEnabled!**auto generated**!overtype!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isOvertypeEnabled:!**auto generated**!accessing!overtype!public!scintilla interface! !
!ScintillaView categoriesFor: #isScrollWidthTracking!**auto generated**!public!scintilla interface!scrolling!testing! !
!ScintillaView categoriesFor: #isScrollWidthTracking:!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #isSelectionBackcolorExtendedToEndOfLine!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isSelectionBackcolorExtendedToEndOfLine:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isSelectionKept!public!testing! !
!ScintillaView categoriesFor: #isSelectionRectangular!**auto generated**!public!scintilla interface!selection!testing! !
!ScintillaView categoriesFor: #isStylingEnabled!public!styling!testing! !
!ScintillaView categoriesFor: #isStylingEnabled:!accessing!public!styling! !
!ScintillaView categoriesFor: #isTextModified!**auto generated**!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isTextModified:!modes!private! !
!ScintillaView categoriesFor: #isUndoEnabled!**auto generated**!public!scintilla interface!testing!undo & redo! !
!ScintillaView categoriesFor: #isUndoEnabled:!**auto generated**!accessing!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #isUsingPalette!**auto generated**!other settings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isUsingPalette:!**auto generated**!accessing!other settings!public!scintilla interface! !
!ScintillaView categoriesFor: #isUsingTabs!**auto generated**!public!scintilla interface!tabs & indentation guides!testing! !
!ScintillaView categoriesFor: #isUsingTabs:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #joinTarget!**auto generated**!commands!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #keyBindings!accessing!key bindings!public! !
!ScintillaView categoriesFor: #keyBindings:!accessing!key bindings!public! !
!ScintillaView categoriesFor: #keyboardCommands!commands!public! !
!ScintillaView categoriesFor: #lastLineWithState!public!styling! !
!ScintillaView categoriesFor: #layoutCachingMode!accessing!line wrapping!public! !
!ScintillaView categoriesFor: #layoutCachingMode:!accessing!line wrapping!public! !
!ScintillaView categoriesFor: #lexer!accessing!lexer!public! !
!ScintillaView categoriesFor: #lexer:!accessing!lexer!public! !
!ScintillaView categoriesFor: #lineCount!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #lineHeight:!enquiries!public! !
!ScintillaView categoriesFor: #lineLength:!accessing!public! !
!ScintillaView categoriesFor: #lineLengthFromPosition:!accessing!private! !
!ScintillaView categoriesFor: #lineNumberMargin!accessing!margins!public! !
!ScintillaView categoriesFor: #lineRange:!accessing!public! !
!ScintillaView categoriesFor: #lineScroll!public!scrolling! !
!ScintillaView categoriesFor: #lineScrollBy:!public!scrolling! !
!ScintillaView categoriesFor: #linesOnScreen!**auto generated**!enquiries!public!scintilla interface! !
!ScintillaView categoriesFor: #marginCount!constants!margins!private! !
!ScintillaView categoriesFor: #margins!accessing!margins!public! !
!ScintillaView categoriesFor: #margins:!accessing!margins!public! !
!ScintillaView categoriesFor: #marginStylesOffset!**auto generated**!accessing!margins!public!scintilla interface! !
!ScintillaView categoriesFor: #marginStylesOffset:!**auto generated**!accessing!margins!public!scintilla interface! !
!ScintillaView categoriesFor: #marginWidths!accessing!private! !
!ScintillaView categoriesFor: #markerDefinitions!accessing!markers!public! !
!ScintillaView categoriesFor: #markerDefinitions:!accessing!markers!public! !
!ScintillaView categoriesFor: #markers!accessing!markers!public! !
!ScintillaView categoriesFor: #markers:!accessing!markers!public! !
!ScintillaView categoriesFor: #markerTypesOnLine:!markers!public! !
!ScintillaView categoriesFor: #maxCompletionListHeight!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListHeight:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListWidth!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListWidth:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxStyle!constants!public!style definition! !
!ScintillaView categoriesFor: #modificationEventMask!accessing!public! !
!ScintillaView categoriesFor: #modificationEventMask:!accessing!public! !
!ScintillaView categoriesFor: #modifyText:!private!text retrieval & modification! !
!ScintillaView categoriesFor: #moveCaretInsideView!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveDown!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveLeft!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #movePageDown!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #movePageUp!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveParaDown!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveParaUp!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveRight!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveStutteredPageDown!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveStutteredPageUp!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfDisplayLine!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfDocument!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfLine!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfNextWord!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfPreviousWord!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfWord!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfWordPart!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfWrappedLine!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfDisplayLine!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfDocument!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfLine!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfWord!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfWordPart!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfWrappedLine!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToVcHome!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToWrappedVcHome!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveUp!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #multiPasteMode!clipboard operations!public! !
!ScintillaView categoriesFor: #multiPasteMode:!clipboard operations!public! !
!ScintillaView categoriesFor: #newLine!**auto generated**!commands!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #nmNotify:!event handling-win32!private! !
!ScintillaView categoriesFor: #onEraseRequired:!event handling!public! !
!ScintillaView categoriesFor: #onKillFocus!event handling!public! !
!ScintillaView categoriesFor: #onSetFocus!event handling!public! !
!ScintillaView categoriesFor: #onViewCreated!event handling!public! !
!ScintillaView categoriesFor: #passwordCharacter!accessing!public! !
!ScintillaView categoriesFor: #passwordCharacter:!accessing!public! !
!ScintillaView categoriesFor: #pasteClipboard!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #performUndoableAction:!public!undo & redo! !
!ScintillaView categoriesFor: #plainText!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #plainText:!accessing!private!text retrieval & modification! !
!ScintillaView categoriesFor: #plainTextFrom:to:!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #positionCacheSize!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #positionCacheSize:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #positionOfChar:!accessing!public! !
!ScintillaView categoriesFor: #primarySelectionIndex!public!selection! !
!ScintillaView categoriesFor: #primarySelectionIndex:!public!selection! !
!ScintillaView categoriesFor: #printAnnotationStyleBytes:on:!annotations!helpers!private! !
!ScintillaView categoriesFor: #printColourMode!**auto generated**!accessing!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printColourMode:!**auto generated**!accessing!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printMagnification!**auto generated**!accessing!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printMagnification:!**auto generated**!accessing!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #queryCommand:!commands!private! !
!ScintillaView categoriesFor: #rangeOfIndicator:at:!indicators!public! !
!ScintillaView categoriesFor: #redo!**auto generated**!commands!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #rememberCaretX!**auto generated**!caret!public!scintilla interface! !
!ScintillaView categoriesFor: #removeAllAnnotations!annotations!public!removing! !
!ScintillaView categoriesFor: #removeAllMarkers!markers!public! !
!ScintillaView categoriesFor: #removeAllStyling!**auto generated**!public!scintilla interface!styling! !
!ScintillaView categoriesFor: #removeAnnotation:!annotations!public!removing! !
!ScintillaView categoriesFor: #removeAnnotationsForLine:!annotations!public!removing! !
!ScintillaView categoriesFor: #removeBraceHighlight!brace highlighting!public! !
!ScintillaView categoriesFor: #removeKeyBinding:!key bindings!public! !
!ScintillaView categoriesFor: #removeMarker:!markers!public! !
!ScintillaView categoriesFor: #removeMarkersOfType:!markers!public! !
!ScintillaView categoriesFor: #removeSelections!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #removeStylingFrom:to:!public!styling! !
!ScintillaView categoriesFor: #replaceTarget:!public!searching & replacing! !
!ScintillaView categoriesFor: #requiredLineMarginWidth!helpers!margins!private! !
!ScintillaView categoriesFor: #resetMarkers!helpers!markers!private! !
!ScintillaView categoriesFor: #resetZoom!commands!public!zooming! !
!ScintillaView categoriesFor: #restyleAll!public!styling! !
!ScintillaView categoriesFor: #restyleFrom:to:!public!styling! !
!ScintillaView categoriesFor: #restyleMask!constants!private!styling! !
!ScintillaView categoriesFor: #rotateSelection!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciAddRefDocument:!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAddSelection:anchor:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciAddStyledText:c:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAddUndoAction:flags:!**auto generated**!private!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #sciAllocate:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAnnotationGetLines:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetStyles:styles:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetText:text:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetVisible!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetStyles:styles:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetText:text:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetVisible:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAppendText:text:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAssignCmdKey:msg:!**auto generated**!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetCurrent!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetCurrentText:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetSeparator!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetTypeSeparator!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCPosStart!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetFillUps:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetSeparator:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetTypeSeparator:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCShow:itemList:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCStops:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceBadLight:!**auto generated**!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceHighlight:pos2:!**auto generated**!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceMatch:!**auto generated**!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipPosStart!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetBack:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetFore:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetForeHlt:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetHlt:end:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipShow:definition:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipUseStyle:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCanPaste!**auto generated**!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciChangeLexerState:end:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCharPositionFromPoint:y:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCharPositionFromPointClose:y:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearAllCmdKeys!**auto generated**!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearCmdKey:!**auto generated**!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciColourise:end:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciContractedFoldNext:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciConvertEOLs:!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCopyRange:end:!**auto generated**!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCreateDocument!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDescribeKeyWordSets:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDescribeProperty:description:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDocLineFromVisible:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciEncodedFromUTF8:encoded:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciEnsureVisible:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciEnsureVisibleEnforcePolicy:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFindColumn:column:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciFindText:ft:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciFormatRange:fr:!**auto generated**!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetAdditionalSelectionTyping!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetAnchor!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetCaretSticky!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCaretStyle!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCharacterPointer!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCodePage!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetColumn:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetControlCharSymbol!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCurLine:text:!**auto generated**!caret!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCurrentPos!**auto generated**!caret!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetDocPointer!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEdgeColumn!**auto generated**!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEdgeMode!**auto generated**!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEndAtLastLine!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciGetEndStyled!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetEOLMode!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFirstVisibleLine!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFoldExpanded:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFoldLevel:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFoldParent:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFontQuality!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetIndentationGuides!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLastChild:level:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLayoutCache!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLexer!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLexerLanguage:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLine:text:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetLineEndPosition:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineIndentation:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLineIndentPosition:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLineSelEndPosition:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetLineSelStartPosition:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetLineState:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetLineVisible:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMainSelection!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetMarginLeft!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMarginRight!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMaxLineState!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetMultiPaste!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPasteConvertEndings!**auto generated**!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPrintWrapMode!**auto generated**!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetProperty:buf:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPropertyExpanded:buf:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPropertyInt:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionAnchor!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionAnchorVirtualSpace!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionCaret!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionCaretVirtualSpace!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSearchFlags!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciGetSelectionEnd!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionMode!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNAnchor:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNAnchorVirtualSpace:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNCaret:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNCaretVirtualSpace:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNEnd:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNStart:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionStart!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelText:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetStyleBits!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciGetStyleBitsNeeded!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetStyledText:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetTag:tagValue:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetTargetEnd!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciGetTargetStart!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciGetText:text:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetTextRange:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetVirtualSpaceOptions!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapIndentMode!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapMode!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapVisualFlags!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapVisualFlagsLocation!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGotoLine:!**auto generated**!caret!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGotoPos:!**auto generated**!caret!private!scintilla interface! !
!ScintillaView categoriesFor: #sciHideLines:lineEnd:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorAllOnFor:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorClearRange:clearLength:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorEnd:position:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorFillRange:fillLength:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorStart:position:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorValueAt:position:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciInsertText:text:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciLineScroll:lines:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciLoadLexerLibrary:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetStyle:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetStyles:styles:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetText:text:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetStyle:style:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetStyles:styles:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetText:text:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginTextClearAll!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerAddSet:set:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerDefinePixmap:pixmap:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerDeleteHandle:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerGet:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerLineFromHandle:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerNext:markerMask:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerPrevious:markerMask:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerSetAlpha:alpha:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerSymbolDefined:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPointXFromPosition:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPointYFromPosition:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionAfter:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionBefore:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionFromPoint:y:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionFromPointClose:y:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPrivateLexerCall:pointer:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPropertyNames:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPropertyType:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRegisterImage:xpmData:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciReleaseDocument:!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciReplaceSel:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciReplaceTarget:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciReplaceTargetRE:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchAnchor!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchInTarget:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchNext:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchPrev:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSetAdditionalCaretFore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelBack:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelectionTyping:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelFore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAnchor:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetCaretFore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretLineBack:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretSticky:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretStyle:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretWidth:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCharsDefault!**auto generated**!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetCodePage:!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetControlCharSymbol:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetDocPointer:!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEdgeColumn:!**auto generated**!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEdgeMode:!**auto generated**!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEOLMode:!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFirstVisibleLine:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldExpanded:expanded:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldFlags:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldLevel:level:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldMarginColour:back:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldMarginHiColour:fore:!**auto generated**!margins!public!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFontQuality:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHotspotActiveBack:back:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHotspotActiveFore:fore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHScrollBar:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetIndentationGuides:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciSetKeyWords:keyWords:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLayoutCache:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLengthForEncode:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetLexer:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLexerLanguage:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLineIndentation:indentSize:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciSetLineState:state:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciSetMainSelection:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetMarginLeft:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMarginRight:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetModEventMask:!**auto generated**!notifications!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMultiPaste:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPasteConvertEndings:!**auto generated**!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPrintWrapMode:!**auto generated**!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetProperty:value:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionAnchor:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionAnchorVirtualSpace:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionCaret:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionCaretVirtualSpace:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSavePoint!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetSearchFlags:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSetSelBack:back:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSelection:anchor:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionMode:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNAnchor:posAnchor:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNAnchorVirtualSpace:space:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNCaret:pos:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNCaretVirtualSpace:space:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNEnd:pos:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNStart:pos:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelFore:fore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetStyleBits:!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciSetStylingEx:styles:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciSetTargetEnd:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSetTargetStart:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSetText:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetVirtualSpaceOptions:!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #sciSetVisiblePolicy:visibleSlop:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetWhitespaceBack:back:!**auto generated**!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetWhitespaceChars:!**auto generated**!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetWhitespaceFore:fore:!**auto generated**!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetWordChars:!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapIndentMode:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapMode:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapVisualFlags:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapVisualFlagsLocation:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetXCaretPolicy:caretSlop:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetYCaretPolicy:caretSlop:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciShowLines:lineEnd:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciStartStyling:mask:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciStyleClearAll!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciTargetAsUTF8:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciTextHeight:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciTextWidth:text:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciToggleCaretSticky!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciToggleFold:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciUserListShow:itemList:!**auto generated**!private!scintilla interface!user lists! !
!ScintillaView categoriesFor: #sciVisibleFromDocLine:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWordEndPosition:onlyWordCharacters:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWordStartPosition:onlyWordCharacters:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWrapCount:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #scnAutoCCancelled:!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCCharDeleted:!**auto generated**!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCSelection:!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnCallTipClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnCharAdded:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDoubleClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDwellEnd:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDwellStart:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnHotSpotClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnHotSpotDoubleClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnHotSpotReleaseClick:!**auto generated**!event handling-scintilla!private! !
!ScintillaView categoriesFor: #scnIndicatorClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnIndicatorRelease:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnKey:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnMacroRecord:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnMarginClick:!event handling-scintilla!margins!notifications!private! !
!ScintillaView categoriesFor: #scnModified:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnModifyAttemptRO:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnNeedShown:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnPainted:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnSavePointLeft:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnSavePointReached:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnStyleNeeded:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnUpdateUI:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnURIDropped:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnUserListSelection:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnZoom:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scrollDown!**auto generated**!commands!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollUp!**auto generated**!commands!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollWidth!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollWidth:!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #secondaryCaretForecolor!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #secondaryCaretForecolor:!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionAlpha!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionAlpha:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionBackcolor!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionBackcolor:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionForecolor!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionForecolor:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selection!public!selection! !
!ScintillaView categoriesFor: #selectionAlpha!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #selectionAlpha:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #selectionBackcolor!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionBackcolor:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionCount!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #selectionForecolor!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionForecolor:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionMode!accessing!public!selection! !
!ScintillaView categoriesFor: #selectionMode:!accessing!public!selection! !
!ScintillaView categoriesFor: #selectionPlainText:!private!selection! !
!ScintillaView categoriesFor: #selectionRanges!public!selection! !
!ScintillaView categoriesFor: #selectionRanges:!public!selection! !
!ScintillaView categoriesFor: #selections!public!selection! !
!ScintillaView categoriesFor: #sendMessage:!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:lParam:!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:lpParam:!operations!private! !
!ScintillaView categoriesFor: #setCallTipHighlightColor!call tips!private! !
!ScintillaView categoriesFor: #setCallTipTabWidth!helpers!private! !
!ScintillaView categoriesFor: #setCurrentTextStyles:!private!style definition! !
!ScintillaView categoriesFor: #setDefaultTextStyle!private!style definition! !
!ScintillaView categoriesFor: #setFoldFlags!folding!private! !
!ScintillaView categoriesFor: #setFoldMarginColor!folding!margins!private! !
!ScintillaView categoriesFor: #setFoldMarginHiColor!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #setFoldProperty:!helpers!private! !
!ScintillaView categoriesFor: #setFont:!helpers!private!style definition! !
!ScintillaView categoriesFor: #setIndicator:from:length:!indicators!public! !
!ScintillaView categoriesFor: #setIndicator:range:!indicators!public! !
!ScintillaView categoriesFor: #setIndicators:!indicators!private! !
!ScintillaView categoriesFor: #setIndicatorStyles:!public! !
!ScintillaView categoriesFor: #setLexerLanguage:!accessing!lexer!public! !
!ScintillaView categoriesFor: #setLine:state:!public!styling! !
!ScintillaView categoriesFor: #setMarginWidths:!helpers!margins!private! !
!ScintillaView categoriesFor: #setRawAnnotations:!annotations!helpers!private! !
!ScintillaView categoriesFor: #setReadOnly:!**auto generated**!modes!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #setSecondarySelectionBackcolor!caret, selection, and hotspot styles!private! !
!ScintillaView categoriesFor: #setSecondarySelectionForecolor!caret, selection, and hotspot styles!private! !
!ScintillaView categoriesFor: #setSelectionBackcolor!caret, selection, and hotspot styles!private! !
!ScintillaView categoriesFor: #setSelectionForecolor!caret, selection, and hotspot styles!private! !
!ScintillaView categoriesFor: #setTabStops:!private!tabs & indentation guides! !
!ScintillaView categoriesFor: #setTargetRangeFromSelection!**auto generated**!public!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #setText:!helpers!private!text retrieval & modification! !
!ScintillaView categoriesFor: #setWhitespaceBackcolor!initializing!private! !
!ScintillaView categoriesFor: #setWhitespaceChars!helpers!private!white space! !
!ScintillaView categoriesFor: #setWhitespaceForecolor!private!white space! !
!ScintillaView categoriesFor: #setWordChars!helpers!other settings!private! !
!ScintillaView categoriesFor: #showAutoCompletionList:prefixLength:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #showCallTip:at:!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #showUserList:id:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #showVerticalScrollBar:!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #splitTarget:!**auto generated**!commands!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #startDwellTimer!notifications!private! !
!ScintillaView categoriesFor: #startRecording!**auto generated**!macro recording!public!scintilla interface! !
!ScintillaView categoriesFor: #startStylingFrom:!public!styling! !
!ScintillaView categoriesFor: #state!accessing!private! !
!ScintillaView categoriesFor: #stbVersion!public! !
!ScintillaView categoriesFor: #stopDwellTimer!notifications!private! !
!ScintillaView categoriesFor: #stopRecording!**auto generated**!macro recording!public!scintilla interface! !
!ScintillaView categoriesFor: #stopStyling!public!styling! !
!ScintillaView categoriesFor: #styleAt:!accessing!public!styling! !
!ScintillaView categoriesFor: #styleBits!constants!public!style definition! !
!ScintillaView categoriesFor: #styleBits:!accessing!public!style definition! !
!ScintillaView categoriesFor: #styledTextFrom:to:!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #styleIdAt:!accessing!private!styling! !
!ScintillaView categoriesFor: #styleMaskAt:!accessing!public!styling! !
!ScintillaView categoriesFor: #styleNamed:!accessing!public!styling! !
!ScintillaView categoriesFor: #styleNext:mask:!**auto generated**!public!scintilla interface!styling! !
!ScintillaView categoriesFor: #styler!accessing!public!styling! !
!ScintillaView categoriesFor: #styler:!accessing!public!styling! !
!ScintillaView categoriesFor: #stylerClass!accessing!public!styling! !
!ScintillaView categoriesFor: #stylerClass:!accessing!public!styling! !
!ScintillaView categoriesFor: #styleUnderCaret!accessing!public!styling! !
!ScintillaView categoriesFor: #styleWithId:!accessing!public!style definition! !
!ScintillaView categoriesFor: #stylingPosition!public!styling! !
!ScintillaView categoriesFor: #swapPrimarySelectionAnchorAndCaret!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #tabIndents!**auto generated**!public!scintilla interface!tabs & indentation guides!testing! !
!ScintillaView categoriesFor: #tabIndents:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #tabWidth!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #tabWidth:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #targetAll!commands!public!selection! !
!ScintillaView categoriesFor: #targetRange!accessing!public!searching & replacing! !
!ScintillaView categoriesFor: #targetRange:!accessing!public!searching & replacing! !
!ScintillaView categoriesFor: #textAtLine:!accessing!private!text retrieval & modification! !
!ScintillaView categoriesFor: #textLength!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #textLimit!accessing!public! !
!ScintillaView categoriesFor: #textLimit:!accessing!public! !
!ScintillaView categoriesFor: #textStyles!accessing!public!style definition! !
!ScintillaView categoriesFor: #textStyles:!accessing!public!style definition! !
!ScintillaView categoriesFor: #toggleFold:!folding!operations!public! !
!ScintillaView categoriesFor: #toggleFoldMargin!commands!margins!public! !
!ScintillaView categoriesFor: #toggleIndentationGuides!commands!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #toggleLineEndings!commands!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #toggleLineNumbers!commands!margins!public! !
!ScintillaView categoriesFor: #toggleOvertype!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #toggleStyling!commands!public!styling! !
!ScintillaView categoriesFor: #toggleWhitespace!commands!margins!public! !
!ScintillaView categoriesFor: #toggleWordWrap!commands!public! !
!ScintillaView categoriesFor: #tokenEndAt:!enquiries!public! !
!ScintillaView categoriesFor: #tokenRangeAt:!enquiries!public! !
!ScintillaView categoriesFor: #tokensFrom:to:!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #tokenStartAt:!enquiries!public! !
!ScintillaView categoriesFor: #twiddleLines!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #undo!commands!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #unindent!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #updateIndicators!helpers!indicators!private! !
!ScintillaView categoriesFor: #updateIndicatorStyles!helpers!indicators!private! !
!ScintillaView categoriesFor: #updateKeyBindings!helpers!key bindings!private! !
!ScintillaView categoriesFor: #updateMarkerDefinitions!helpers!markers!private! !
!ScintillaView categoriesFor: #updateMarkers!helpers!markers!private! !
!ScintillaView categoriesFor: #updateTextStyles!helpers!private!style definition! !
!ScintillaView categoriesFor: #validateUserInterface!operations!public! !
!ScintillaView categoriesFor: #whitespaceBackcolor!accessing!public!white space! !
!ScintillaView categoriesFor: #whitespaceBackcolor:!accessing!public!white space! !
!ScintillaView categoriesFor: #whitespaceForecolor!accessing!public!white space! !
!ScintillaView categoriesFor: #whitespaceForecolor:!accessing!public!white space! !
!ScintillaView categoriesFor: #whitespaceMarkerSize!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #whitespaceMarkerSize:!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #whitespaces!accessing!public! !
!ScintillaView categoriesFor: #whitespaces:!accessing!public! !
!ScintillaView categoriesFor: #whitespaceVisibility!accessing!public!white space! !
!ScintillaView categoriesFor: #whitespaceVisibility:!accessing!public!white space! !
!ScintillaView categoriesFor: #widthOfText:inStyle:!enquiries!public! !
!ScintillaView categoriesFor: #willCaptureMouse!**auto generated**!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #willCaptureMouse:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #wmChar:wParam:lParam:!event handling-win32!private! !
!ScintillaView categoriesFor: #wmContextMenu:wParam:lParam:!event handling-win32!private! !
!ScintillaView categoriesFor: #wmKeyDown:wParam:lParam:!event handling-win32!private! !
!ScintillaView categoriesFor: #wmTimer:wParam:lParam:!event handling-win32!private!timers! !
!ScintillaView categoriesFor: #wordChars!accessing!other settings!public! !
!ScintillaView categoriesFor: #wordChars:!accessing!other settings!public! !
!ScintillaView categoriesFor: #wordWrap!accessing-styles!line wrapping!public! !
!ScintillaView categoriesFor: #wordWrap:!accessing-styles!line wrapping!public! !
!ScintillaView categoriesFor: #wrapIndentMode!accessing!public! !
!ScintillaView categoriesFor: #wrapIndentMode:!accessing!public! !
!ScintillaView categoriesFor: #xOffset!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #xOffset:!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #zoomIn!**auto generated**!commands!public!scintilla interface!zooming! !
!ScintillaView categoriesFor: #zoomLevel!**auto generated**!accessing!public!scintilla interface!zooming! !
!ScintillaView categoriesFor: #zoomLevel:!**auto generated**!accessing!public!scintilla interface!zooming! !
!ScintillaView categoriesFor: #zoomOut!**auto generated**!commands!public!scintilla interface!zooming! !

!ScintillaView class methodsFor!

annotationModes
	^AnnotationModes!

codePages
	^CodePages!

defaultAnnotationStyles
	"Answer the default annoration style settings to be used for new instances of the receiver."

	^(Set new)
		add: ((ScintillaTextStyle name: #Error)
					forecolor: (Color fromHTMLSpec: '#A70000');
					backcolor: (Color fromHTMLSpec: '#FFEEEE');
					yourself);
		add: ((ScintillaTextStyle name: #Warning)
					forecolor: (Color fromHTMLSpec: '#A77500');
					backcolor: (Color fromHTMLSpec: '#FFFFEE');
					yourself);
		add: ((ScintillaTextStyle name: #Notification)
					backcolor: (Color fromHTMLSpec: '#EDEDED');
					yourself);
		isImmutable: true;
		yourself!

defaultCallTipStyle
	^(ScintillaTextStyle name: #callTip)
		backcolor: Color white;
		forecolor: Color darkGray;
		yourself!

defaultKeyMap
	"Private - This key map is built (using editor macros) from the source code of the Scintilla control.
	Unfortunately there is no way to query the command key assignments."

	^#(
	    (##(VK_DOWN)		0	##(SCI_LINEDOWN))
	    (##(VK_DOWN)		##(FSHIFT)	##(SCI_LINEDOWNEXTEND))
	    (##(VK_DOWN)		##(FCONTROL)	##(SCI_LINESCROLLDOWN))
	    (##(VK_DOWN)		##(FALT|FSHIFT)	##(SCI_LINEDOWNRECTEXTEND))
	    (##(VK_UP)		0	##(SCI_LINEUP))
	    (##(VK_UP)			##(FSHIFT)	##(SCI_LINEUPEXTEND))
	    (##(VK_UP)			##(FCONTROL)	##(SCI_LINESCROLLUP))
	    (##(VK_UP)		##(FALT|FSHIFT)	##(SCI_LINEUPRECTEXTEND))
	    (##(VK_OEM_4)		##(FCONTROL)		##(SCI_PARAUP))
	    (##(VK_OEM_4)		##(FCONTROL|FSHIFT)	##(SCI_PARAUPEXTEND))
	    (##(VK_OEM_6)		##(FCONTROL)		##(SCI_PARADOWN))
	    (##(VK_OEM_6)		##(FCONTROL|FSHIFT)	##(SCI_PARADOWNEXTEND))
	    (##(VK_LEFT)		0	##(SCI_CHARLEFT))
	    (##(VK_LEFT)		##(FSHIFT)	##(SCI_CHARLEFTEXTEND))
	    (##(VK_LEFT)		##(FCONTROL)	##(SCI_WORDLEFT))
	    (##(VK_LEFT)		##(FCONTROL|FSHIFT)	##(SCI_WORDLEFTEXTEND))
	    (##(VK_LEFT)		##(FALT|FSHIFT)	##(SCI_CHARLEFTRECTEXTEND))
	    (##(VK_RIGHT)		0	##(SCI_CHARRIGHT))
	    (##(VK_RIGHT)		##(FSHIFT)	##(SCI_CHARRIGHTEXTEND))
	    (##(VK_RIGHT)		##(FCONTROL)	##(SCI_WORDRIGHT))
	    (##(VK_RIGHT)		##(FCONTROL|FSHIFT)	##(SCI_WORDRIGHTEXTEND))
	    (##(VK_RIGHT)		##(FALT|FSHIFT)	##(SCI_CHARRIGHTRECTEXTEND))
	    (##(VK_OEM_2)	##(FCONTROL)		##(SCI_WORDPARTLEFT))
	    (##(VK_OEM_2)	##(FCONTROL|FSHIFT)	##(SCI_WORDPARTLEFTEXTEND))
	    (##(VK_OEM_5)	##(FCONTROL)		##(SCI_WORDPARTRIGHT))
	    (##(VK_OEM_5)	##(FCONTROL|FSHIFT)	##(SCI_WORDPARTRIGHTEXTEND))
	    (##(VK_HOME)		0	##(SCI_VCHOME))
	    (##(VK_HOME) 		##(FSHIFT) 	##(SCI_VCHOMEEXTEND))
	    (##(VK_HOME) 		##(FCONTROL) 	##(SCI_DOCUMENTSTART))
	    (##(VK_HOME) 		##(FCONTROL|FSHIFT) 	##(SCI_DOCUMENTSTARTEXTEND))
	    (##(VK_HOME) 		##(FALT) 	##(SCI_HOMEDISPLAY))
	    (##(VK_HOME)		##(FALT|FSHIFT)	##(SCI_VCHOMERECTEXTEND))
	    (##(VK_END)	 	0	##(SCI_LINEEND))
	    (##(VK_END)	 	##(FSHIFT) 	##(SCI_LINEENDEXTEND))
	    (##(VK_END) 		##(FCONTROL) 	##(SCI_DOCUMENTEND))
	    (##(VK_END) 		##(FCONTROL|FSHIFT) 	##(SCI_DOCUMENTENDEXTEND))
	    (##(VK_END) 		##(FALT) 	##(SCI_LINEENDDISPLAY))
	    (##(VK_END)		##(FALT|FSHIFT)	##(SCI_LINEENDRECTEXTEND))
	    (##(VK_PRIOR)		0	##(SCI_PAGEUP))
	    (##(VK_PRIOR)		##(FSHIFT) 	##(SCI_PAGEUPEXTEND))
	    (##(VK_PRIOR)		##(FALT|FSHIFT)	##(SCI_PAGEUPRECTEXTEND))
	    (##(VK_NEXT) 		0 	##(SCI_PAGEDOWN))
	    (##(VK_NEXT) 		##(FSHIFT) 	##(SCI_PAGEDOWNEXTEND))
	    (##(VK_NEXT)		##(FALT|FSHIFT)	##(SCI_PAGEDOWNRECTEXTEND))
	    (##(VK_DELETE) 	0	##(SCI_CLEAR))
	    (##(VK_DELETE) 	##(FSHIFT)	##(SCI_CUT))
	    (##(VK_DELETE) 	##(FCONTROL)	##(SCI_DELWORDRIGHT))
	    (##(VK_DELETE)	##(FCONTROL|FSHIFT)	##(SCI_DELLINERIGHT))
	    (##(VK_INSERT) 		0	##(SCI_EDITTOGGLEOVERTYPE))
	    (##(VK_INSERT) 		##(FSHIFT)	##(SCI_PASTE))
	    (##(VK_INSERT) 		##(FCONTROL)	##(SCI_COPY))
	    (##(VK_ESCAPE)  	0	##(SCI_CANCEL))
	    (##(VK_BACK)		0 	##(SCI_DELETEBACK))
	    (##(VK_BACK)		##(FSHIFT) 	##(SCI_DELETEBACK))
	    (##(VK_BACK)		##(FCONTROL) 	##(SCI_DELWORDLEFT))
	    (##(VK_BACK) 		##(FALT)	##(SCI_UNDO))
	    (##(VK_BACK)		##(FCONTROL|FSHIFT)	##(SCI_DELLINELEFT))
	    ($Z 			##(FCONTROL)	##(SCI_UNDO))
	    ($Y 			##(FCONTROL)	##(SCI_REDO))
	    ($X 			##(FCONTROL)	##(SCI_CUT))
	    ($C 			##(FCONTROL)	##(SCI_COPY))
	    ($V 			##(FCONTROL)	##(SCI_PASTE))
	    ($A 			##(FCONTROL)	##(SCI_SELECTALL))
	    (##(VK_TAB)		0	##(SCI_TAB))
	    (##(VK_TAB)		##(FSHIFT)	##(SCI_BACKTAB))
	    (##(VK_RETURN) 	0	##(SCI_NEWLINE))
	    (##(VK_RETURN) 	##(FSHIFT)	##(SCI_NEWLINE))
	    (##(VK_ADD) 		##(FCONTROL)	##(SCI_ZOOMIN))
	    (##(VK_SUBTRACT)	##(FCONTROL)	##(SCI_ZOOMOUT))
	    (##(VK_DIVIDE)	##(FCONTROL)	##(SCI_SETZOOM)) "Reset zoom level to zero"
	    ($L 			##(FCONTROL)	##(SCI_LINECUT))
	    ($L 			##(FCONTROL|FSHIFT)	##(SCI_LINEDELETE))
	    ($T 			##(FCONTROL|FSHIFT)	##(SCI_LINECOPY))
	    ($T 			##(FCONTROL)	##(SCI_LINETRANSPOSE))
	    ($D 			##(FCONTROL)	##(SCI_LINEDUPLICATE))
	    ($U 			##(FCONTROL)	##(SCI_LOWERCASE))
	    ($U 			##(FCONTROL|FSHIFT)	##(##(SCI_UPPERCASE)))
	)!

defaultTextStyles
	"Answer the default text style settings to be used for new instances of the receiver. By
	default we just set up some of the predefined/special styles where we are likely to want
	change these from those preconfigured into the control.

	Any aspect of a style which is not explicitly specified is inherited from the global
	settings (e.g. font and colours) associated with the view. Unless set-up here, or configured
	in the view resource or otherwise set up by the presenter, all the predefined styles will
	use the default background and foreground colour and font."

	| answer |
	answer := Set new.
	"The #normal style must be present - it has id 0, and is the style from which the others
	inherit there default settings. In turn it inherits its own default settings from the view."
	answer add: (ScintillaTextStyle name: #normal).
	"Some 'predefined' styles"
	answer
		add: (ScintillaTextStyle name: #lineNumber);
		add: (ScintillaTextStyle name: #indentGuide);
		add: self defaultCallTipStyle;
		yourself.
	^answer!

defaultWhitespaceChars
	"Answer a <String> containing the <Character>s that Scintilla considers to be whitespace by
	default."

	^Character byteCharacterSet select: [:each | each codePoint < 16r20 or: [each == $ ]]!

edgeModes
	"Answer the symbolic names of the long-line edge marking modes supported by Scintilla."

	^#(#none #line #background)!

fontQualities
	^#(#default #unaliased #antialiased #lcdOptimized)!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

immutableCopyOfCollection: aCollection 
	^(aCollection collect: 
			[:each | 
			(each copy)
				isImmutable: true;
				yourself])
		isImmutable: true;
		yourself!

initialize
	"Private - Initialize the receiver's class variables, etc
		self initialize
	"

	self initializeNotificationMap.
	CodePages := (IdentityDictionary new)
				at: SC_CP_DBCS put: #dbcs;
				at: SC_CP_UTF8 put: #utf8;
				shrink;
				isImmutable: true;
				yourself.
	self initializeLexerLanguages.
	BraceHilightingMask := 1.
	FoldingMask := 2.
	BackgroundDwellEvents := 4.
	DefaultTextStyles := (IdentityDictionary new)
				at: #container put: (self immutableCopyOfCollection: self defaultTextStyles);
				at: #xml put: (self immutableCopyOfCollection: self xmlTextStyles);
				at: #text put: (self immutableCopyOfCollection: self txtTextStyles);
				at: #smalltalk put: (self immutableCopyOfCollection: self smalltalkTextStyles);
				shrink;
				isImmutable: true;
				yourself.
	FoldMarkerStyles := #(#arrows #boxTree #circleTree #plusMinus).
	IndentationGuideStyles := #(#real #lookForward #lookBoth).
	CaretStyles := #(#invisible #line #block).
	AnnotationModes := #(#hidden #standard #boxed).
	Whitespaces := (self defaultWhitespaceChars)
				isImmutable: true;
				yourself.
	DefaultKeyBindings := LookupTable new.
	self defaultKeyMap do: 
			[:each | 
			| keyCode |
			keyCode := AcceleratorTable keyCode: each first asInteger modifiers: each second.
			DefaultKeyBindings at: keyCode
				put: ((ScintillaKeyBinding newAcceleratorKey: keyCode message: each last)
						isImmutable: true;
						yourself)].
	DefaultKeyBindings
		shrink;
		isImmutable: true.
	DefaultCallTipTabWidth := 32.
	"Offsets must always be multiples of 256 for implementation reasons"
	MarginStylesOffset := 256.
	AnnotationStylesOffset := 512.
	WrapIndentModes := #(#fixed #same #indent)!

initializeLexerLanguages
	"Private - The set of lexers tends to increase quite rapidly over time (though some also get
	dropped, hence the empty slots in the array), this is from 2.23. Note that a Smalltalk lexer
	was added around 1.63, however we do not use this. Dolphin's Smalltalk lexer is implemented
	in the image and container based lexing is used. This is slower, but much more powerful.

	self initializeLexerLanguages

	"

	Lexers := #(#container #text #python #cpp #hypertext #xml #perl #sql #vb #props #errorlist #makefile #batch nil #latex #lua #diff #conf #pascal #ave #ada #lisp #ruby #eiffel #eiffelkw #tcl #nncrontab #bullant #vbscript nil nil #baan #matlab #scriptol #asm #cppnocase #fortran #f77 #css #pov #lout #escript #ps #nsis #mmixal nil nil #lot #yaml #tex #metapost #powerbasic #forth #erlang #octave #mssql #verilog #kix #gui4cli #specman #au3 #apdl #bash #asn1 #vhdl #caml #blitzbasic #purebasic #haskell #phpscript #tads3 #rebol #smalltalk #flagship #csound #freebasic #inno #opal #spice #d #cmake #gap #'PL/M' nil #abaqus #asy #r nil #powershell nil #po nil nil nil nil #powerpro #nimrod #sml #markdown #txt2tags #a68k #automatic).
	self assert: [Lexers size = (SCLEX_A68K + 2)]!

initializeNotificationMap
	ScnMap := (Array new: 28)
				at: SCN_STYLENEEDED - 1999 put: #scnStyleNeeded:;
				at: SCN_CHARADDED - 1999 put: #scnCharAdded:;
				at: SCN_SAVEPOINTREACHED - 1999 put: #scnSavePointReached:;
				at: SCN_SAVEPOINTLEFT - 1999 put: #scnSavePointLeft:;
				at: SCN_MODIFYATTEMPTRO - 1999 put: #scnModifyAttemptRO:;
				at: SCN_KEY - 1999 put: #scnKey:;
				at: SCN_DOUBLECLICK - 1999 put: #scnDoubleClick:;
				at: SCN_UPDATEUI - 1999 put: #scnUpdateUI:;
				at: SCN_MODIFIED - 1999 put: #scnModified:;
				at: SCN_MACRORECORD - 1999 put: #scnMacroRecord:;
				at: SCN_MARGINCLICK - 1999 put: #scnMarginClick:;
				at: SCN_NEEDSHOWN - 1999 put: #scnNeedShown:;
				at: SCN_PAINTED - 1999 put: #scnPainted:;
				at: SCN_USERLISTSELECTION - 1999 put: #scnUserListSelection:;
				at: SCN_URIDROPPED - 1999 put: #scnURIDropped:;
				at: SCN_DWELLSTART - 1999 put: #scnDwellStart:;
				at: SCN_DWELLEND - 1999 put: #scnDwellEnd:;
				at: SCN_ZOOM - 1999 put: #scnZoom:;
				at: SCN_HOTSPOTCLICK - 1999 put: #scnHotSpotClick:;
				at: SCN_HOTSPOTDOUBLECLICK - 1999 put: #scnHotSpotDoubleClick:;
				at: SCN_CALLTIPCLICK - 1999 put: #scnCallTipClick:;
				at: SCN_AUTOCSELECTION - 1999 put: #scnAutoCSelection:;
				at: SCN_INDICATORCLICK - 1999 put: #scnIndicatorClick:;
				at: SCN_INDICATORRELEASE - 1999 put: #scnIndicatorRelease:;
				at: SCN_AUTOCCANCELLED - 1999 put: #scnAutoCCancelled:;
				at: SCN_AUTOCCHARDELETED - 1999 put: #scnAutoCCharDeleted:;
				at: SCN_HOTSPOTRELEASECLICK - 1999 put: #scnHotSpotReleaseClick:;
				isImmutable: true;
				yourself!

layoutCachingModes
	^#(#none #caret #page #document)!

lineEndings
	"Answer the symbolic names of the end-of-line modes supported by Scintilla. These correspond
	to the character sequences, with #crlf being the default for Windows."

	^#(#crlf #cr #lf)!

multiPasteModes
	^#(#once #each)!

selectionModes
	"Answer the symbolic names of the selection modes supported by Scintilla."

	^#(#stream #rectangle #lines)!

smalltalkTextStyles
	"Answer the default text style settings to be used for new instances of the receiver in
	conjunction with the built in (not Dolphin) smalltalk lexer. Note that these styles are
	those from Scite, and are NOT those used in the Dolphin IDE, which uses container based
	lexing."

	| answer keywordColor |
	answer := self defaultTextStyles.
	keywordColor := Color fromHTMLSpec: '#00007F'.
	answer
		add: ((ScintillaTextStyle name: #string)
					id: 1;
					forecolor: (Color fromHTMLSpec: '#7F007F');
					isBackcolorExtendedToEndOfLine: true;
					yourself);
		add: ((ScintillaTextStyle name: #number)
					id: 2;
					forecolor: (Color fromHTMLSpec: '#007F7F');
					yourself);
		add: ((ScintillaTextStyle name: #comment)
					id: 3;
					forecolor: (Color fromHTMLSpec: '#007F00');
					yourself);
		add: ((ScintillaTextStyle name: #symbol)
					id: 4;
					forecolor: Color darkMagenta;
					yourself);
		add: ((ScintillaTextStyle name: #binary)
					id: 5;
					forecolor: Color black;
					yourself);
		add: ((ScintillaTextStyle name: #boolean)
					id: 6;
					forecolor: keywordColor;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #self)
					id: 7;
					forecolor: keywordColor;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #super)
					id: 8;
					forecolor: keywordColor;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #nil)
					id: 9;
					forecolor: keywordColor;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #global)
					id: 10;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #return)
					id: 11;
					forecolor: (Color fromHTMLSpec: '#A00000');
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #special)
					id: 12;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #keywordSend)
					id: 13;
					forecolor: Color darkGreen;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #assignment)
					id: 14;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #character)
					id: 15;
					forecolor: (Color fromHTMLSpec: '#7F007F');
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #specialSelector)
					id: 16;
					forecolor: keywordColor;
					isBold: true;
					yourself);
		yourself.
	"Add some standard styles"
	answer
		add: ((ScintillaTextStyle name: #indentGuide)
					forecolor: Color gray;
					yourself);
		add: ((ScintillaTextStyle name: #braceHighlight)
					forecolor: Color blue;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #braceMismatch)
					forecolor: Color red;
					isBold: true;
					yourself);
		yourself.
	^answer!

stbConvert: instVarArray fromVersion: verInteger 
	"Convert from earlier version view by updating and answering the array of instance variables
	(for the View), instVarArray."

	| instVars |
	instVars := instVarArray.
	verInteger < 13 ifTrue: [instVars := super stbConvert: instVarArray fromVersion: verInteger].
	verInteger < 14 ifTrue: [instVars := self stbConvertFromVersion13: instVars].
	^instVars!

stbConvertFromVersion13: anArray 
	"Private - Perform an STB conversion from a version 13 <ScintillaView> to version 14,
	i.e. use call tip style, fix a small bug, and add some spare inst vars."

	| instVars callTipBackcolor callTipForecolor currentTextStyles callTipStyle selectionBackcolor |
	instVars := anArray.
	callTipBackcolor := instVars at: 33.
	callTipForecolor := instVars at: 34.
	instVars at: 33 put: DefaultCallTipTabWidth.
	instVars at: 34 put: nil.
	currentTextStyles := instVars at: 18.
	callTipStyle := currentTextStyles at: #callTip ifAbsentPut: [self defaultCallTipStyle].
	callTipBackcolor ifNotNil: [:value | callTipStyle backcolor: value].
	callTipForecolor ifNotNil: [:value | callTipStyle forecolor: value].
	selectionBackcolor := instVars at: 30.
	selectionBackcolor = Color darkGray ifTrue: [instVars at: 30 put: Color gray].
	^instVars!

stbConvertFromVersion9: anArray 
	"Private - Perform an STB conversion from a version 9 (or earlier) <ScintillaView> to version 10.
	The single collection of text styles was replaced by a current collection, and a collection of collections
	keyed by lexer language. This allows a single ScintillaView to be switched easily between different languages.
	Also add a few more spare instance variables."

	| table array |
	array := super stbConvertFromVersion9: anArray.
	table := IdentityDictionary new.
	array at: 39 put: table.
	"All older resources only have container based lexing"
	table at: #container put: (array at: 18).
	^array!

stbVersion
	^14!

txtTextStyles
	"Answer the default text style settings to be used for new instances of the receiver.
	These are the styles used as the defaults for txt files in Scite."

	| styles |
	styles := self defaultTextStyles.
	styles add: ((ScintillaTextStyle name: #normal)
				backcolor: Color window;
				yourself).
	^styles!

whitespaceVisibilityLevels
	"Answer the symbolic names of the whitespace visibility modes supported by Scintilla."

	^#(#invisible #visibleAlways #visibleAfterIndent)!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	"Ensure the DLL has been loaded"

	ScintillaLibrary realize.
	^'Scintilla'!

wrapIndentModes
	^WrapIndentModes!

xmlTextStyles
	"Answer the default XML text style settings to be used for new instances of the receiver.
	These are the styles used as the defaults for XML files in Scite."

	"Implementation Note: The XML lexer uses a different style for the open tag character (1) vs
	the close tag characters (11). In consequence Scintilla cannot do brace matching in XML
	docs, since it will only match braces where they have the same style - this avoids a brace
	in a comment, for example, wrongly matching a brace in code. Because of this there is no
	point defining the brace highlight and mismatch styles."

	| styles sgmlBackcolour |
	styles := self defaultTextStyles.
	styles add: ((ScintillaTextStyle name: #normal)
				backcolor: Color window;
				yourself).
	styles add: ((ScintillaTextStyle name: #tag)
				id: 1;
				forecolor: Color darkBlue;
				yourself).
	styles add: ((ScintillaTextStyle name: #unknownTag)
				id: 2;
				forecolor: Color darkBlue;
				yourself).
	styles add: ((ScintillaTextStyle name: #attribute)
				id: 3;
				forecolor: Color darkCyan;
				yourself).
	styles add: ((ScintillaTextStyle name: #unknownAttribute)
				id: 4;
				forecolor: Color darkCyan;
				yourself).
	styles add: ((ScintillaTextStyle name: #number)
				id: 5;
				forecolor: (RGB 
							red: 0
							green: 127
							blue: 127);
				yourself).
	styles add: ((ScintillaTextStyle name: #doubleString)
				id: 6;
				forecolor: (RGB 
							red: 127
							green: 0
							blue: 127);
				yourself).
	styles add: ((ScintillaTextStyle name: #singleString)
				id: 7;
				forecolor: (RGB 
							red: 127
							green: 0
							blue: 127);
				yourself).
	styles add: ((ScintillaTextStyle name: #otherInsideTag)
				id: 8;
				forecolor: Color darkMagenta;
				yourself).
	styles add: ((ScintillaTextStyle name: #comment)
				id: 9;
				forecolor: Color brown;
				yourself).
	styles add: ((ScintillaTextStyle name: #entity)
				id: 10;
				forecolor: Color darkMagenta;
				yourself).
	styles add: ((ScintillaTextStyle name: #tagEnd)
				id: 11;
				forecolor: Color darkBlue;
				yourself).
	styles add: ((ScintillaTextStyle name: #identifierEnd)
				id: 12;
				forecolor: Color darkMagenta;
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #identifierStart)
				id: 13;
				forecolor: Color darkMagenta;
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #CDATA)
				id: 17;
				backcolor: (RGB 
							red: 255
							green: 240
							blue: 240);
				forecolor: Color darkRed;
				isBackcolorExtendedToEndOfLine: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #question)
				id: 18;
				forecolor: Color darkRed;
				yourself).
	styles add: ((ScintillaTextStyle name: #unquotedValue)
				id: 19;
				forecolor: (RGB 
							red: 96
							green: 128
							blue: 96);
				yourself).
	sgmlBackcolour := RGB 
				red: 239
				green: 239
				blue: 255.
	styles add: ((ScintillaTextStyle name: #sgmlTag)
				id: 21;
				backcolor: sgmlBackcolour;
				forecolor: Color darkBlue;
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlCommand)
				id: 22;
				backcolor: sgmlBackcolour;
				forecolor: Color darkBlue;
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlFirstParam)
				id: 23;
				backcolor: sgmlBackcolour;
				forecolor: (RGB 
							red: 0
							green: 102
							blue: 0);
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlDoubleString)
				id: 24;
				backcolor: sgmlBackcolour;
				forecolor: Color darkRed;
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlSingleString)
				id: 25;
				backcolor: sgmlBackcolour;
				forecolor: (RGB 
							red: 153
							green: 51
							blue: 0);
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlError)
				id: 26;
				backcolor: (RGB 
							red: 255
							green: 102
							blue: 102);
				forecolor: Color darkRed;
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlSpecial)
				id: 27;
				backcolor: sgmlBackcolour;
				forecolor: (RGB 
							red: 51
							green: 102
							blue: 255);
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlEntity)
				id: 28;
				backcolor: sgmlBackcolour;
				forecolor: (RGB 
							red: 51
							green: 51
							blue: 51);
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlComment)
				id: 29;
				backcolor: sgmlBackcolour;
				forecolor: Color brown;
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlBlock)
				id: 31;
				backcolor: (RGB 
							red: 204
							green: 204
							blue: 224);
				forecolor: (RGB 
							red: 0
							green: 0
							blue: 102);
				yourself).
	^styles! !
!ScintillaView class categoriesFor: #annotationModes!constants!public! !
!ScintillaView class categoriesFor: #codePages!constants!public! !
!ScintillaView class categoriesFor: #defaultAnnotationStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #defaultCallTipStyle!constants!public!style definition! !
!ScintillaView class categoriesFor: #defaultKeyMap!constants!private! !
!ScintillaView class categoriesFor: #defaultTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #defaultWhitespaceChars!constants!public! !
!ScintillaView class categoriesFor: #edgeModes!constants!public! !
!ScintillaView class categoriesFor: #fontQualities!constants!public! !
!ScintillaView class categoriesFor: #icon!constants!public! !
!ScintillaView class categoriesFor: #immutableCopyOfCollection:!helpers!private! !
!ScintillaView class categoriesFor: #initialize!development!initializing!private! !
!ScintillaView class categoriesFor: #initializeLexerLanguages!development!initializing!private! !
!ScintillaView class categoriesFor: #initializeNotificationMap!**auto generated**!must not strip!public!scintilla interface! !
!ScintillaView class categoriesFor: #layoutCachingModes!constants!public! !
!ScintillaView class categoriesFor: #lineEndings!constants!public! !
!ScintillaView class categoriesFor: #multiPasteModes!constants!public! !
!ScintillaView class categoriesFor: #selectionModes!constants!public! !
!ScintillaView class categoriesFor: #smalltalkTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #stbConvert:fromVersion:!binary filing!public! !
!ScintillaView class categoriesFor: #stbConvertFromVersion13:!binary filing!private! !
!ScintillaView class categoriesFor: #stbConvertFromVersion9:!binary filing!private! !
!ScintillaView class categoriesFor: #stbVersion!public! !
!ScintillaView class categoriesFor: #txtTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #whitespaceVisibilityLevels!constants!public! !
!ScintillaView class categoriesFor: #winClassName!constants!private! !
!ScintillaView class categoriesFor: #wrapIndentModes!constants!public! !
!ScintillaView class categoriesFor: #xmlTextStyles!constants!public!style definition! !

