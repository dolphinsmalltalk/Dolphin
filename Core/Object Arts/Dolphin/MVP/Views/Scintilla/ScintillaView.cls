"Filed out from Dolphin Smalltalk 7"!

MultilineTextEdit subclass: #ScintillaView
	instanceVariableNames: 'this currentTextStyles styleIdMap styler markerDefinitions markers wordChars styleMask modificationEventMask autoCStops autoCFillups whitespaceBackcolor whitespaceForecolor selectionBackcolor selectionForecolor indicators callTipTabWidth punctuation callTipHighlightColor braceChars whitespaces scFlags allTextStyles foldMarginColor foldMarginHiColor foldMarkerStyle foldFlags extraStyleBits keyBindings indicatorStyles secondarySelectionForecolor secondarySelectionBackcolor annotationStyles _unused50'
	classVariableNames: 'AnnotationStylesOffset BackgroundDwellEvents BraceHilightingMask CodePages DefaultCallTipTabWidth DefaultKeyBindings DefaultTextStyles FoldingMask Lexers MarginStylesOffset ScnMap'
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
	AutoCompletionSortModes <Array> of <Symbol>s being the names of the possible sorting modes for autocompletion lists.
'!
!ScintillaView categoriesForClass!MVP-Views! !
!ScintillaView methodsFor!

acceptAutoCompletion
	"User has selected an item so remove the list and insert the selection."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCCOMPLETE
				wParam: 0
				lParam: 0]!

activeHotspotBackcolor
	"Get the back colour for active hotspots."

	^this isNil 
		ifTrue: [nil]
		ifFalse: 
			[RGB fromInteger: (ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETHOTSPOTACTIVEBACK
						wParam: 0
						lParam: 0)]!

activeHotspotBackcolor: aColorOrNil 
	"Set the back colour for active hotspots."

	aColorOrNil 
		ifNil: [self sciSetHotspotActiveBack: false back: 0]
		ifNotNil: [self sciSetHotspotActiveBack: true back: aColorOrNil asRGB]!

activeHotspotForecolor
	"Get the fore colour for active hotspots."

	^this isNil 
		ifTrue: [nil]
		ifFalse: 
			[RGB fromInteger: (ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETHOTSPOTACTIVEFORE
						wParam: 0
						lParam: 0)]!

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

addSelectionRange: anInterval 
	"Add a secondary selection to the list of selected ranges."

	self sciAddSelection: anInterval stop anchor: anInterval start - 1!

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
	^self class annotationModes at: self sciAnnotationGetVisible + 1 ifAbsent: [#hidden]!

annotationMode: aSymbol 
	self sciAnnotationSetVisible: (self class annotationModes keyAtValue: aSymbol) - 1!

annotations
	"Answer a collection of all the individual annotations currently set in the receiver. There
	could be several per line, the line indices are one-based, and the styles are described by
	symbolic names, one annotation style name per character."

	| annotations raw |
	self ensureHasAnnotationStyles.
	raw := self getRawAnnotations.
	annotations := OrderedCollection new: raw size.
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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONGETSTYLEOFFSET
				wParam: 0
				lParam: 0]!

annotationStylesOffset: styleInteger 
	"Get the start of the range of style numbers used for annotations"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONSETSTYLEOFFSET
				wParam: styleInteger
				lParam: 0]!

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

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETADDITIONALCARETSVISIBLE
				wParam: 0
				lParam: 0) asBoolean]!

areAdditionalCaretsVisible: additionalCaretsBlinkBoolean 
	"Set whether additional carets are visible"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETADDITIONALCARETSVISIBLE
				wParam: additionalCaretsBlinkBoolean asParameter
				lParam: 0]!

areAllLinesVisible
	"Are all lines visible?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETALLLINESVISIBLE
				wParam: 0
				lParam: 0) asBoolean]!

areHotspotsSingleLine
	"Get the HotspotSingleLine property"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETHOTSPOTSINGLELINE
				wParam: 0
				lParam: 0) asBoolean]!

areHotspotsSingleLine: singleLineBoolean 
	"Limit hotspots to single line so hotspots on two lines don't merge."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETHOTSPOTSINGLELINE
				wParam: singleLineBoolean asParameter
				lParam: 0]!

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

autoCompletionCurrentText
	"Get currently selected item text in the auto-completion list Returns the length of the item
	text Result is NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_AUTOCGETCURRENTTEXT
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETCURRENTTEXT
				wParam: 0
				lpParam: result.
			result]!

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

autoCompletionSortMode
	"Answer the <Character> used as the separator between entries in an auto-completion list <String>."

	^self autoCompletionSortModes at: self sciAutoCGetOrder + 1!

autoCompletionSortMode: aSymbol 
	^self sciAutoCSetOrder: (self autoCompletionSortModes indexOf: aSymbol) - 1!

backcolorChanged
	"Private - Note we don't supersend, because we don't need to invalidate on changing colours
	- Scintilla takes care of that"

	self updateTextStyles!

backspace
	"Delete the selection or if no selection, the character before the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DELETEBACK
				wParam: 0
				lParam: 0]!

backspaceNoLine
	"Delete the selection or if no selection, the character before the caret. Will not delete
	the character before at the start of a line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DELETEBACKNOTLINE
				wParam: 0
				lParam: 0]!

backspaceUnindents
	"Does a backspace pressed when caret is within indentation unindent?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETBACKSPACEUNINDENTS
				wParam: 0
				lParam: 0) asBoolean]!

backspaceUnindents: bsUnIndentsBoolean 
	"Sets whether a backspace pressed when caret is within indentation unindents."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETBACKSPACEUNINDENTS
				wParam: bsUnIndentsBoolean asParameter
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEAR
				wParam: 0
				lParam: 0]!

basicLineFromPosition: posInteger 
	"Retrieve the line containing a position."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEFROMPOSITION
				wParam: posInteger
				lParam: 0]!

basicPositionAtLine: lineInteger 
	"Retrieve the position at the start of a line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_POSITIONFROMLINE
				wParam: lineInteger
				lParam: 0]!

basicRemoveAllAnnotations
	"Clear the annotations from all lines"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONCLEARALL
				wParam: 0
				lParam: 0]!

basicSelectAll
	"Select all the text in the document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SELECTALL
				wParam: 0
				lParam: 0]!

basicSelectionRange
	"Private - Answer an <interval> identifying the selected range of text as reported by the underlying 
	Windows control. Note that this range includes the starting character, but the end of the range
	is the first unselected character. Note further that this characteristic means that the range should 
	NEVER be empty."

	^self sciGetSelectionStart to: self sciGetSelectionEnd!

basicSelectionStart: startInteger end: endInteger 
	"Select a range of text."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSEL
				wParam: startInteger
				lParam: endInteger]!

basicUndo
	"Undo one action in the undo history."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_UNDO
				wParam: 0
				lParam: 0]!

beginUndoGroup
	"Start a sequence of actions that is undone and redone as a unit. May be nested."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_BEGINUNDOACTION
				wParam: 0
				lParam: 0]!

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

callTipPosition: anInteger 
	"Change the start position of the call tip."

	^self sciCallTipSetPosStart: anInteger - 1!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCCANCEL
				wParam: 0
				lParam: 0]!

cancelCallTip
	"Remove the call tip from the screen."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPCANCEL
				wParam: 0
				lParam: 0]!

cancelModes
	"Cancel any modes such as call tip or auto-completion list display."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CANCEL
				wParam: 0
				lParam: 0]!

canHScroll
	"Is the horizontal scroll bar visible?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETHSCROLLBAR
				wParam: 0
				lParam: 0) asBoolean]!

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

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_CANREDO
				wParam: 0
				lParam: 0) asBoolean]!

canScrollPastEnd
	"Answer whether the window can be scrolled up to one-page past the end of the text. If false
	then the window can only be scrolled to the last line."

	^self sciGetEndAtLastLine asBoolean!

canScrollPastEnd: endAtLastLineBoolean 
	"Sets the scroll range so that maximum scroll position has the last line at the bottom of
	the view (default). Setting this to false allows scrolling one page below the last line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETENDATLASTLINE
				wParam: endAtLastLineBoolean asParameter
				lParam: 0]!

canUndo
	"Are there any undoable actions in the undo history?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_CANUNDO
				wParam: 0
				lParam: 0) asBoolean]!

canVScroll
	"Is the vertical scroll bar visible?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETVSCROLLBAR
				wParam: 0
				lParam: 0) asBoolean]!

caretForecolor
	"Get the foreground colour of the caret."

	^this isNil 
		ifTrue: [nil]
		ifFalse: 
			[RGB fromInteger: (ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETCARETFORE
						wParam: 0
						lParam: 0)]!

caretForecolor: foreRGB 
	"Set the foreground colour of the caret."

	self sciSetCaretFore: (foreRGB ifNil: [Color black]) asRGB!

caretPeriod
	"Get the time in milliseconds that the caret is on and off."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCARETPERIOD
				wParam: 0
				lParam: 0]!

caretPeriod: periodMillisecondsInteger 
	"Get the time in milliseconds that the caret is on and off. 0 = steady on."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETPERIOD
				wParam: periodMillisecondsInteger
				lParam: 0]!

caretPosition
	"Answer the insertion cursor position, as the number of characters from the start of the
	receivers text."

	^self sciGetCurrentPos + 1!

caretPosition: anInteger 
	"Sets the insertion cursor to be at the specified character position (which is one based,
	i.e. caretPosition 1 is home)."

	self sciSetEmptySelection: anInteger - 1!

caretScreenCoordinates
	^self mapPoint: (self positionOfChar: self caretPosition) to: View desktop!

caretStyle
	"Answer the style of caret displayed in the receiver; one of #invisible (no caret), #line or
	#block"

	^self class caretStyles at: self sciGetCaretStyle + 1 ifAbsent: [#line]!

caretStyle: aSymbol 
	"Set the style of caret displayed in the receiver; one of #invisible (no caret), #line or
	#block"

	^self sciSetCaretStyle: (self class caretStyles indexOf: aSymbol ifAbsent: [CARETSTYLE_LINE + 1]) - 1!

caretWidth
	"Returns the width of the insert mode caret."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCARETWIDTH
				wParam: 0
				lParam: 0]!

caretWidth: anInteger 
	"Set the width of the caret to the number of pels specified by the <integer> argument."

	(anInteger between: 1 and: 3) 
		ifFalse: [^self error: 'Caret width must be between 1 and 3, not ' , anInteger printString].
	self sciSetCaretWidth: anInteger!

centerCurrentLine
	"Centre current line in window."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VERTICALCENTRECARET
				wParam: 0
				lParam: 0]!

characterAt: anInteger 
	"Answer the <Character> at the specified one-based <integer> index in the receiver's text."

	^Character value: ((self sciGetCharAt: anInteger - 1) bitAnd: 16rFF)!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEARALL
				wParam: 0
				lParam: 0]!

clearContainerIndicators
	"Clear all the indicators (e.g. squiggly underlines) from the receiver."

	self basicClearContainerIndicators.
	indicators := nil!

clearIndicator: anIntegerOrSymbol from: startInteger to: stopInteger 
	"Clear the indicator identified by <integer> id from the range of text between two one-based
	<integer> positions."

	self currentIndicatorId: (self indicatorIdFromName: anIntegerOrSymbol).
	self sciIndicatorClearRange: startInteger - 1 clearLength: stopInteger - startInteger + 1!

clearRange: anInterval 
	"Delete a range of text from the view."

	self sciDeleteRange: anInterval start - 1 deleteLength: anInterval size!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LOWERCASE
				wParam: 0
				lParam: 0]!

convertToUppercase
	"Transform the selection to upper case."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_UPPERCASE
				wParam: 0
				lParam: 0]!

copyLine
	"Copy the line containing the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINECOPY
				wParam: 0
				lParam: 0]!

copyRange: anInterval 
	"Copy a range of text to the clipboard."

	self sciCopyRange: anInterval start - 1 end: anInterval stop!

copySelection
	"Copy the selection to the clipboard."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_COPY
				wParam: 0
				lParam: 0]!

copySelectionOrLine
	"Copy the selection, if selection empty copy the line with the caret"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_COPYALLOWLINE
				wParam: 0
				lParam: 0]!

currentIndicatorId
	"Get the current indicator"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETINDICATORCURRENT
				wParam: 0
				lParam: 0]!

currentIndicatorId: indicatorInteger 
	"Set the indicator used for IndicatorFillRange and IndicatorClearRange"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETINDICATORCURRENT
				wParam: indicatorInteger
				lParam: 0]!

currentIndicatorValue
	"Get the current indicator value"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETINDICATORVALUE
				wParam: 0
				lParam: 0]!

currentIndicatorValue: valueInteger 
	"Set the value used for IndicatorFillRange"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETINDICATORVALUE
				wParam: valueInteger
				lParam: 0]!

currentLineAlpha
	"Get the background alpha of the caret line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCARETLINEBACKALPHA
				wParam: 0
				lParam: 0]!

currentLineAlpha: alphaInteger 
	"Set background alpha of the caret line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETLINEBACKALPHA
				wParam: alphaInteger
				lParam: 0]!

currentLineBackcolor
	"Get the colour of the background of the line containing the caret."

	^this isNil 
		ifTrue: [nil]
		ifFalse: 
			[RGB fromInteger: (ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETCARETLINEBACK
						wParam: 0
						lParam: 0)]!

currentLineBackcolor: backRGB 
	"Set the colour of the background of the line containing the caret. Note that this will have
	no effect unless #isCurrentLineHighlighted is set to true. You will also want to set
	#currentLineAlpha to some reasonable transparency value (100 or less), or the background
	will obliterate the text."

	self sciSetCaretLineBack: (backRGB ifNil: [Color yellow]) asRGB!

currentLineText
	"Retrieve the text of the line containing the caret. Returns the index of the caret on the
	line. Result is NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETCURLINE
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len - 1.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCURLINE
				wParam: len
				lpParam: result.
			result]!

cutLine
	"Cut the line containing the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINECUT
				wParam: 0
				lParam: 0]!

cutSelection
	"Cut the selection to the clipboard."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CUT
				wParam: 0
				lParam: 0]!

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

deleteLine
	"Delete the line containing the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEDELETE
				wParam: 0
				lParam: 0]!

deleteMarkers: markerNumberInteger 
	"Delete all markers with a particular number from all lines."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERDELETEALL
				wParam: markerNumberInteger
				lParam: 0]!

deleteToEndOfLine
	"Delete forwards from the current position to the end of the line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DELLINERIGHT
				wParam: 0
				lParam: 0]!

deleteToEndOfWord
	"Delete the word to the right of the caret, but not the trailing non-word characters."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DELWORDRIGHTEND
				wParam: 0
				lParam: 0]!

deleteToNextWord
	"Delete the word to the right of the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DELWORDRIGHT
				wParam: 0
				lParam: 0]!

deleteToStartOfLine
	"Delete back from the current position to the start of the line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DELLINELEFT
				wParam: 0
				lParam: 0]!

deleteToStartOfWord
	"Delete the word to the left of the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DELWORDLEFT
				wParam: 0
				lParam: 0]!

describeKeywordSets
	"Retrieve a '\n' separated list of descriptions of the keyword sets understood by the
	current lexer. Result is NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_DESCRIBEKEYWORDSETS
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_DESCRIBEKEYWORDSETS
				wParam: 0
				lpParam: result.
			result]!

destroyAutoCompletionListImages
	"Clear all the registered XPM images."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEARREGISTEREDIMAGES
				wParam: 0
				lParam: 0]!

directPointer
	^this ifNil: [self getDirectPointer]!

drawingPhases
	"Answer the <Character> used as the separator between entries in an auto-completion list <String>."

	^self class drawingPhases at: self sciGetPhasesDraw + 1!

drawingPhases: aSymbol 
	^self sciSetPhasesDraw: (self class drawingPhases indexOf: aSymbol) - 1!

duplicateLine
	"Duplicate the current line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEDUPLICATE
				wParam: 0
				lParam: 0]!

duplicateSelection
	"Duplicate the selection. If selection empty duplicate the line containing the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SELECTIONDUPLICATE
				wParam: 0
				lParam: 0]!

edgeColor
	"Retrieve the colour used in edge indication."

	^this isNil 
		ifTrue: [nil]
		ifFalse: 
			[RGB fromInteger: (ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETEDGECOLOUR
						wParam: 0
						lParam: 0)]!

edgeColor: edgeColourRGB 
	"Change the colour used in edge indication."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETEDGECOLOUR
				wParam: edgeColourRGB asParameter
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_EMPTYUNDOBUFFER
				wParam: 0
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ENDUNDOACTION
				wParam: 0
				lParam: 0]!

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
	self sciScrollCaret!

ensureHasAnnotationStyles
	annotationStyles 
		ifNil: [annotationStyles := self buildAnnotationStyles: self class defaultAnnotationStyles]!

ensureLineVisible: anInteger 
	self sciEnsureVisible: anInteger - 1!

ensureRangeVisible: anInterval 
	"Ensure that the specified range of text is visible, prioritising visibility of the start of the range."

	self sciScrollRange: anInterval stop primary: anInterval start - 1!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSTATUS
				wParam: 0
				lParam: 0]!

errorStatus: statusCodeInteger 
	"Change error status - 0 = OK."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSTATUS
				wParam: statusCodeInteger
				lParam: 0]!

extendDown
	"Move caret down one line extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEDOWNEXTEND
				wParam: 0
				lParam: 0]!

extendLeft
	"Move caret left one character extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHARLEFTEXTEND
				wParam: 0
				lParam: 0]!

extendPageDown
	"Move caret one page down extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PAGEDOWNEXTEND
				wParam: 0
				lParam: 0]!

extendPageUp
	"Move caret one page up extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PAGEUPEXTEND
				wParam: 0
				lParam: 0]!

extendParaDown
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PARADOWNEXTEND
				wParam: 0
				lParam: 0]!

extendParaUp
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PARAUPEXTEND
				wParam: 0
				lParam: 0]!

extendRectangleDown
	"Move caret down one line, extending rectangular selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEDOWNRECTEXTEND
				wParam: 0
				lParam: 0]!

extendRectangleLeft
	"Move caret left one character, extending rectangular selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHARLEFTRECTEXTEND
				wParam: 0
				lParam: 0]!

extendRectanglePageDown
	"Move caret one page down, extending rectangular selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PAGEDOWNRECTEXTEND
				wParam: 0
				lParam: 0]!

extendRectanglePageUp
	"Move caret one page up, extending rectangular selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PAGEUPRECTEXTEND
				wParam: 0
				lParam: 0]!

extendRectangleRight
	"Move caret right one character, extending rectangular selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHARRIGHTRECTEXTEND
				wParam: 0
				lParam: 0]!

extendRectangleToEndOfLine
	"Move caret to last position on line, extending rectangular selection to new caret
	position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEENDRECTEXTEND
				wParam: 0
				lParam: 0]!

extendRectangleToStartOfLine
	"Move caret to first position on line, extending rectangular selection to new caret
	position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HOMERECTEXTEND
				wParam: 0
				lParam: 0]!

extendRectangleToVcHome
	"Move caret to before first visible character on line. If already there move to first
	character on line. In either case, extend rectangular selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VCHOMERECTEXTEND
				wParam: 0
				lParam: 0]!

extendRectangleUp
	"Move caret up one line, extending rectangular selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEUPRECTEXTEND
				wParam: 0
				lParam: 0]!

extendRight
	"Move caret right one character extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHARRIGHTEXTEND
				wParam: 0
				lParam: 0]!

extendStutteredPageDown
	"Move caret to bottom of page, or one page down if already at bottom of page, extending
	selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_STUTTEREDPAGEDOWNEXTEND
				wParam: 0
				lParam: 0]!

extendStutteredPageUp
	"Move caret to top of page, or one page up if already at top of page, extending selection to
	new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_STUTTEREDPAGEUPEXTEND
				wParam: 0
				lParam: 0]!

extendToEndOfDisplayLine
	"Move caret to last position on display line extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEENDDISPLAYEXTEND
				wParam: 0
				lParam: 0]!

extendToEndOfDocument
	"Move caret to last position in document extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DOCUMENTENDEXTEND
				wParam: 0
				lParam: 0]!

extendToEndOfLine
	"Move caret to last position on line extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEENDEXTEND
				wParam: 0
				lParam: 0]!

extendToEndOfNextWord
	"Move caret right one word, position cursor at end of word, extending selection to new caret
	position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDRIGHTENDEXTEND
				wParam: 0
				lParam: 0]!

extendToEndOfPreviousWord
	"Move caret left one word, position cursor at end of word, extending selection to new caret
	position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDLEFTENDEXTEND
				wParam: 0
				lParam: 0]!

extendToEndOfWord
	"Move caret right one word extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDRIGHTEXTEND
				wParam: 0
				lParam: 0]!

extendToEndOfWordPart
	"Move to the next change in capitalisation extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDPARTRIGHTEXTEND
				wParam: 0
				lParam: 0]!

extendToEndOfWrappedLine
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEENDWRAPEXTEND
				wParam: 0
				lParam: 0]!

extendToStartOfDisplayLine
	"Move caret to first position on display line extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HOMEDISPLAYEXTEND
				wParam: 0
				lParam: 0]!

extendToStartOfDocument
	"Move caret to first position in document extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DOCUMENTSTARTEXTEND
				wParam: 0
				lParam: 0]!

extendToStartOfLine
	"Move caret to first position on line extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HOMEEXTEND
				wParam: 0
				lParam: 0]!

extendToStartOfVcDisplayLine
	"Like VCHomeDisplay but extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VCHOMEDISPLAYEXTEND
				wParam: 0
				lParam: 0]!

extendToStartOfWord
	"Move caret left one word extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDLEFTEXTEND
				wParam: 0
				lParam: 0]!

extendToStartOfWordPart
	"Move to the previous change in capitalisation extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDPARTLEFTEXTEND
				wParam: 0
				lParam: 0]!

extendToStartOfWrappedLine
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HOMEWRAPEXTEND
				wParam: 0
				lParam: 0]!

extendToVcHome
	"Like VCHome but extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VCHOMEEXTEND
				wParam: 0
				lParam: 0]!

extendToWrappedVcHome
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VCHOMEWRAPEXTEND
				wParam: 0
				lParam: 0]!

extendUp
	"Move caret up one line extending selection to new caret position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEUPEXTEND
				wParam: 0
				lParam: 0]!

extraAscent
	"Get extra ascent for each line"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETEXTRAASCENT
				wParam: 0
				lParam: 0]!

extraAscent: extraAscentInteger 
	"Set extra ascent for each line"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETEXTRAASCENT
				wParam: extraAscentInteger
				lParam: 0]!

extraDescent
	"Get extra descent for each line"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETEXTRADESCENT
				wParam: 0
				lParam: 0]!

extraDescent: extraDescentInteger 
	"Set extra descent for each line"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETEXTRADESCENT
				wParam: extraDescentInteger
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSELECT
				wParam: 0
				lpParam: textString]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FORMFEED
				wParam: 0
				lParam: 0]!

getDirectPointer
	^this := (super sendMessage: SCI_GETDIRECTPOINTER) asExternalHandle!

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

	| text |
	text := self sciAnnotationGetText: anInteger.
	^text isEmpty 
		ifFalse: 
			[| styles |
			styles := self sciAnnotationGetStyles: anInteger.
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
			but makes this run up to 25% faster, which might be significant for very
			large files."
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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETWRAPSTARTINDENT
				wParam: 0
				lParam: 0]!

hangingIndent: indentInteger 
	"Set the start indent for wrapped lines."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWRAPSTARTINDENT
				wParam: indentInteger
				lParam: 0]!

hasBlinkingSecondaryCarets
	"Whether additional carets will blink"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETADDITIONALCARETSBLINK
				wParam: 0
				lParam: 0) asBoolean]!

hasBlinkingSecondaryCarets: additionalCaretsBlinkBoolean 
	"Set whether additional carets will blink"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETADDITIONALCARETSBLINK
				wParam: additionalCaretsBlinkBoolean asParameter
				lParam: 0]!

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

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETVIEWEOL
				wParam: 0
				lParam: 0) asBoolean]!

hasVisibleLineEndings: visibleBoolean 
	"Make the end of line characters visible or invisible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETVIEWEOL
				wParam: visibleBoolean asParameter
				lParam: 0]!

hideExtraIndicators
	| indics |
	this ifNil: [^self].
	indics := 8 - self styleBits.	"Make any indicators coinciding with the extra style bits invisible."
	indics - extraStyleBits to: indics - 1
		do: 
			[:each | 
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_INDICSETSTYLE
				wParam: each
				lParam: INDIC_HIDDEN]!

hideIndicators
	"Private - Reconfigure all indicator styles to hidden apart from the default 3 pre-configured styles."

	this ifNil: [^self].
	3 to: INDIC_MAX
		do: 
			[:each | 
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_INDICSETSTYLE
				wParam: each
				lParam: INDIC_HIDDEN]!

hideSelection: normalBoolean 
	"Draw the selection in normal style or with selection highlighted."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HIDESELECTION
				wParam: normalBoolean asParameter
				lParam: 0]!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETHIGHLIGHTGUIDE
				wParam: 0
				lParam: 0]!

highlightGuide: columnInteger 
	"Set the highlighted indentation guide column. 0 = no highlighted guide."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETHIGHLIGHTGUIDE
				wParam: columnInteger
				lParam: 0]!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMOUSEDWELLTIME
				wParam: 0
				lParam: 0]!

hoverTime: periodMillisecondsInteger 
	"Sets the time the mouse must sit still to generate a mouse dwell event."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMOUSEDWELLTIME
				wParam: periodMillisecondsInteger
				lParam: 0]!

idOfStyleNamed: aSymbol 
	^(self styleNamed: aSymbol) ifNil: [0] ifNotNil: [:style | style id]!

imeMode
	^self class imeInteractionModes at: self sciGetIMEInteraction + 1!

imeMode: aSymbol 
	self 
		sciSetIMEInteraction: (self class imeInteractionModes indexOf: aSymbol
				ifAbsent: [self error: 'Invalid IME interaction mode ' , aSymbol printString]) - 1!

indent
	"If selection is empty or all on one line replace the selection with a tab character. If
	more than one line selected, indent the lines."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_TAB
				wParam: 0
				lParam: 0]!

indentation
	"Retrieve indentation size."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETINDENT
				wParam: 0
				lParam: 0]!

indentation: indentSizeInteger 
	"Set the number of spaces used for one level of indentation."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETINDENT
				wParam: indentSizeInteger
				lParam: 0]!

indentationGuides
	"Answer the symbolic name of the style of indentation guides visible in the receiver, or nil if none."

	^self class indentationGuideStyles at: self sciGetIndentationGuides ifAbsent: []!

indentationGuides: aSymbolOrNil 
	"Set the style of indication guides to be displayed in the receiver, one of nil (no
	guides), #real, #lookForward, #lookBoth."

	self sciSetIndentationGuides: (self class indentationGuideStyles indexOf: aSymbolOrNil
				ifAbsent: [SC_IV_NONE])!

indentationOfLine: anInteger 
	"Retrieve the number of columns that a line is indented."

	^self sciGetLineIndentation: anInteger - 1!

indicatorCount
	"Answer the number of indicators configured for the receiver. With the advent of 'modern'
	indicators, this is now fixed at 32 and not related to the number of style bits used."

	^INDIC_MAX + 1!

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
	self setCharacterClasses.
	autoCFillups ifNotNil: [self sciAutoCSetFillUps: autoCFillups].
	autoCStops ifNotNil: [self sciAutoCStops: autoCStops].
	whitespaceForecolor ifNotNil: [self setWhitespaceForecolor].
	whitespaceBackcolor ifNotNil: [self setWhitespaceBackcolor].
	"Note that if any primary selection foreground/background colors are set, then any second
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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ADDTEXT
				wParam: lengthInteger
				lpParam: textString]!

invalidateStyling
	self startStylingFrom: 1!

isActiveHotspotUnderlined
	"Get whether underlining for active hotspots."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETHOTSPOTACTIVEUNDERLINE
				wParam: 0
				lParam: 0) asBoolean]!

isActiveHotspotUnderlined: underlineBoolean 
	"Enable / Disable underlining active hotspots."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETHOTSPOTACTIVEUNDERLINE
				wParam: underlineBoolean asParameter
				lParam: 0]!

isAutoCompletionActive
	"Is there an auto-completion list visible?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCACTIVE
				wParam: 0
				lParam: 0) asBoolean]!

isAutoCompletionCancelledAtStart
	"Retrieve whether auto-completion cancelled by backspacing before start."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETCANCELATSTART
				wParam: 0
				lParam: 0) asBoolean]!

isAutoCompletionCancelledAtStart: cancelBoolean 
	"Should the auto-completion list be cancelled if the user backspaces to a position before
	where the box was created."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETCANCELATSTART
				wParam: cancelBoolean asParameter
				lParam: 0]!

isAutoCompletionCancelledWhenNoMatch
	"Retrieve whether or not autocompletion is hidden automatically when nothing matches."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETAUTOHIDE
				wParam: 0
				lParam: 0) asBoolean]!

isAutoCompletionCancelledWhenNoMatch: autoHideBoolean 
	"Set whether or not autocompletion is hidden automatically when nothing matches."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETAUTOHIDE
				wParam: autoHideBoolean asParameter
				lParam: 0]!

isAutoCompletionCaseInsensitive
	"Retrieve state of ignore case flag."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETIGNORECASE
				wParam: 0
				lParam: 0) asBoolean]!

isAutoCompletionCaseInsensitive: ignoreCaseBoolean 
	"Set whether case is significant when performing auto-completion searches."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETIGNORECASE
				wParam: ignoreCaseBoolean asParameter
				lParam: 0]!

isAutoCompletionSingleMatchChosen
	"Retrieve whether a single item auto-completion list automatically choose the item."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETCHOOSESINGLE
				wParam: 0
				lParam: 0) asBoolean]!

isAutoCompletionSingleMatchChosen: chooseSingleBoolean 
	"Should a single item auto-completion list automatically choose the item."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETCHOOSESINGLE
				wParam: chooseSingleBoolean asParameter
				lParam: 0]!

isAutoCompletionTruncating
	"Retrieve whether or not autocompletion deletes any word characters after the inserted text
	upon completion."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETDROPRESTOFWORD
				wParam: 0
				lParam: 0) asBoolean]!

isAutoCompletionTruncating: dropRestOfWordBoolean 
	"Set whether or not autocompletion deletes any word characters after the inserted text upon
	completion."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETDROPRESTOFWORD
				wParam: dropRestOfWordBoolean asParameter
				lParam: 0]!

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

isCallTipAboveText: aboveBoolean 
	"Set position of calltip, above or below text."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPSETPOSITION
				wParam: aboveBoolean asParameter
				lParam: 0]!

isCallTipActive
	"Is there an active call tip?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPACTIVE
				wParam: 0
				lParam: 0) asBoolean]!

isCaretSticky
	"Can the caret preferred x position only be changed by explicit movement commands?"

	^self sciGetCaretSticky ~= 0!

isCaretSticky: aBoolean 
	"Stop the caret preferred x position changing when the user types."

	self sciSetCaretSticky: (aBoolean ifTrue: [SC_CARETSTICKY_ON] ifFalse: [SC_CARETSTICKY_OFF])!

isCurrentLineHighlighted
	"Is the background of the line containing the caret in a different colour?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCARETLINEVISIBLE
				wParam: 0
				lParam: 0) asBoolean]!

isCurrentLineHighlighted: showBoolean 
	"Display the background of the line containing the caret in a different colour."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETLINEVISIBLE
				wParam: showBoolean asParameter
				lParam: 0]!

isCurrentLineHighlightedAlways
	"Is the caret line always visible?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCARETLINEVISIBLEALWAYS
				wParam: 0
				lParam: 0) asBoolean]!

isCurrentLineHighlightedAlways: alwaysVisibleBoolean 
	"Sets the caret line to always visible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETLINEVISIBLEALWAYS
				wParam: alwaysVisibleBoolean asParameter
				lParam: 0]!

isCurrentLineMarkedWith: aSymbol 
	"Answer whether the current line (i.e. the line with the caret) has the named marker."

	^self isLine: self currentLine markedWith: aSymbol!

isDrawingBuffered
	"Is drawing done first into a buffer or direct to the screen?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETBUFFEREDDRAW
				wParam: 0
				lParam: 0) asBoolean]!

isDrawingBuffered: bufferedBoolean 
	"If drawing is buffered then each line of text is drawn into a bitmap buffer before drawing
	it to the screen to avoid flicker."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETBUFFEREDDRAW
				wParam: bufferedBoolean asParameter
				lParam: 0]!

isDrawingTwoPhase
	"Is drawing done in two phases with backgrounds drawn before foregrounds?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTWOPHASEDRAW
				wParam: 0
				lParam: 0) asBoolean]!

isDrawingTwoPhase: twoPhaseBoolean 
	"In twoPhaseDraw mode, drawing is performed in two phases, first the background and then the
	foreground. This avoids chopping off characters that overlap the next run."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETTWOPHASEDRAW
				wParam: twoPhaseBoolean asParameter
				lParam: 0]!

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

	#deprecated.
	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETKEYSUNICODE
				wParam: 0
				lParam: 0) asBoolean]!

isKeyboardInputUnicode: keysUnicodeBoolean 
	"Deprecated in 3.5.5 Always interpret keyboard input as Unicode"

	#deprecated.
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETKEYSUNICODE
				wParam: keysUnicodeBoolean asParameter
				lParam: 0]!

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

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMULTIPLESELECTION
				wParam: 0
				lParam: 0) asBoolean]!

isMultiSelect: multipleSelectionBoolean 
	"Set whether multiple selections can be made"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMULTIPLESELECTION
				wParam: multipleSelectionBoolean asParameter
				lParam: 0]!

isOvertypeEnabled
	"Returns true if overtype mode is active otherwise false is returned."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETOVERTYPE
				wParam: 0
				lParam: 0) asBoolean]!

isOvertypeEnabled: overtypeBoolean 
	"Set to overtype (true) or insert mode."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETOVERTYPE
				wParam: overtypeBoolean asParameter
				lParam: 0]!

isScrollWidthTracking
	"Retrieve whether the scroll width tracks wide lines."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSCROLLWIDTHTRACKING
				wParam: 0
				lParam: 0) asBoolean]!

isScrollWidthTracking: trackingBoolean 
	"Sets whether the maximum width line displayed is used to set scroll width."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSCROLLWIDTHTRACKING
				wParam: trackingBoolean asParameter
				lParam: 0]!

isSelectionBackcolorExtendedToEndOfLine
	"Is the selection end of line filled?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELEOLFILLED
				wParam: 0
				lParam: 0) asBoolean]!

isSelectionBackcolorExtendedToEndOfLine: filledBoolean 
	"Set the selection to have its end of line filled or not."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELEOLFILLED
				wParam: filledBoolean asParameter
				lParam: 0]!

isSelectionEmpty
	"Is every selected range empty?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONEMPTY
				wParam: 0
				lParam: 0) asBoolean]!

isSelectionKept
	"Answer true if the receiver is set to maintain selection even after losing focus."

	"N.B. Scintilla always displays the selection - this is not configurable."

	^true!

isSelectionRectangular
	"Is the selection rectangular? The alternative is the more common stream selection."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_SELECTIONISRECTANGLE
				wParam: 0
				lParam: 0) asBoolean]!

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

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMODIFY
				wParam: 0
				lParam: 0) asBoolean]!

isTextModified: aBoolean 
	"Private - Set/reset the receiver's text modification flag."

	#todo.	"Supersend here sends EM_SETMODIFY which is deprecated from Scintilla's point of view"
	aBoolean ifTrue: [super isTextModified: aBoolean] ifFalse: [self sciSetSavePoint]!

isUndoEnabled
	"Is undo history being collected?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETUNDOCOLLECTION
				wParam: 0
				lParam: 0) asBoolean]!

isUndoEnabled: collectUndoBoolean 
	"Choose between collecting actions into the undo history and discarding them."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETUNDOCOLLECTION
				wParam: collectUndoBoolean asParameter
				lParam: 0]!

isUsingPalette
	"Deprecated in 2.30 In palette mode?"

	#deprecated.
	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETUSEPALETTE
				wParam: 0
				lParam: 0) asBoolean]!

isUsingPalette: usePaletteBoolean 
	"In palette mode, Scintilla uses the environment's palette calls to display more colours.
	This may lead to ugly displays."

	#deprecated.
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETUSEPALETTE
				wParam: usePaletteBoolean asParameter
				lParam: 0]!

isUsingTabs
	"Retrieve whether tabs will be used in indentation."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETUSETABS
				wParam: 0
				lParam: 0) asBoolean]!

isUsingTabs: useTabsBoolean 
	"Indentation will only use space characters if useTabs is false, otherwise it will use a
	combination of tabs and spaces."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETUSETABS
				wParam: useTabsBoolean asParameter
				lParam: 0]!

joinTarget
	"Join the lines in the target."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINESJOIN
				wParam: 0
				lParam: 0]!

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

lexerLanguage
	"Retrieve the name of the lexer. Return the length of the text. Result is NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETLEXERLANGUAGE
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLEXERLANGUAGE
				wParam: 0
				lpParam: result.
			result]!

lexerPropertyNames
	"Retrieve a '\n' separated list of properties understood by the current lexer. Result is
	NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_PROPERTYNAMES
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_PROPERTYNAMES
				wParam: 0
				lpParam: result.
			result]!

lineCount
	"Returns the number of lines in the document. There is always at least one."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINECOUNT
				wParam: 0
				lParam: 0]!

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

	^self margins detect: [:each | each type == #lineNumber] ifNone: []!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINESONSCREEN
				wParam: 0
				lParam: 0]!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINGETSTYLEOFFSET
				wParam: 0
				lParam: 0]!

marginStylesOffset: styleInteger 
	"Get the start of the range of style numbers used for margin text"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINSETSTYLEOFFSET
				wParam: styleInteger
				lParam: 0]!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETMAXHEIGHT
				wParam: 0
				lParam: 0]!

maxCompletionListHeight: rowCountInteger 
	"Set the maximum height, in rows, of auto-completion and user lists. The default is 5 rows."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETMAXHEIGHT
				wParam: rowCountInteger
				lParam: 0]!

maxCompletionListWidth
	"Get the maximum width, in characters, of auto-completion and user lists."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETMAXWIDTH
				wParam: 0
				lParam: 0]!

maxCompletionListWidth: characterCountInteger 
	"Set the maximum width, in characters, of auto-completion and user lists. Set to 0 to
	autosize to fit longest item, which is the default."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETMAXWIDTH
				wParam: characterCountInteger
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MOVECARETINSIDEVIEW
				wParam: 0
				lParam: 0]!

moveDown
	"Move caret down one line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEDOWN
				wParam: 0
				lParam: 0]!

moveLeft
	"Move caret left one character."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHARLEFT
				wParam: 0
				lParam: 0]!

movePageDown
	"Move caret one page down."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PAGEDOWN
				wParam: 0
				lParam: 0]!

movePageUp
	"Move caret one page up."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PAGEUP
				wParam: 0
				lParam: 0]!

moveParaDown
	"Move caret between paragraphs (delimited by empty lines)."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PARADOWN
				wParam: 0
				lParam: 0]!

moveParaUp
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PARAUP
				wParam: 0
				lParam: 0]!

moveRight
	"Move caret right one character."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHARRIGHT
				wParam: 0
				lParam: 0]!

moveSelectedLinesDown
	"Move the selected lines down one line, shifting the line below before the selection"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MOVESELECTEDLINESDOWN
				wParam: 0
				lParam: 0]!

moveSelectedLinesUp
	"Move the selected lines up one line, shifting the line above after the selection"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MOVESELECTEDLINESUP
				wParam: 0
				lParam: 0]!

moveStutteredPageDown
	"Move caret to bottom of page, or one page down if already at bottom of page."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_STUTTEREDPAGEDOWN
				wParam: 0
				lParam: 0]!

moveStutteredPageUp
	"Move caret to top of page, or one page up if already at top of page."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_STUTTEREDPAGEUP
				wParam: 0
				lParam: 0]!

moveToEndOfDisplayLine
	"Move caret to last position on display line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEENDDISPLAY
				wParam: 0
				lParam: 0]!

moveToEndOfDocument
	"Move caret to last position in document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DOCUMENTEND
				wParam: 0
				lParam: 0]!

moveToEndOfLine
	"Move caret to last position on line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEEND
				wParam: 0
				lParam: 0]!

moveToEndOfNextWord
	"Move caret right one word, position cursor at end of word."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDRIGHTEND
				wParam: 0
				lParam: 0]!

moveToEndOfPreviousWord
	"Move caret left one word, position cursor at end of word."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDLEFTEND
				wParam: 0
				lParam: 0]!

moveToEndOfWord
	"Move caret right one word."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDRIGHT
				wParam: 0
				lParam: 0]!

moveToEndOfWordPart
	"Move to the change next in capitalisation."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDPARTRIGHT
				wParam: 0
				lParam: 0]!

moveToEndOfWrappedLine
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEENDWRAP
				wParam: 0
				lParam: 0]!

moveToStartOfDisplayLine
	"Move caret to first position on display line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HOMEDISPLAY
				wParam: 0
				lParam: 0]!

moveToStartOfDocument
	"Move caret to first position in document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DOCUMENTSTART
				wParam: 0
				lParam: 0]!

moveToStartOfLine
	"Move caret to first position on line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HOME
				wParam: 0
				lParam: 0]!

moveToStartOfWord
	"Move caret left one word."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDLEFT
				wParam: 0
				lParam: 0]!

moveToStartOfWordPart
	"Move to the previous change in capitalisation."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDPARTLEFT
				wParam: 0
				lParam: 0]!

moveToStartOfWrappedLine
	"These are like their namesakes Home(Extend)?, LineEnd(Extend)?, VCHome(Extend)? except they
	behave differently when word-wrap is enabled: They go first to the start / end of the
	display line, like (Home|LineEnd)Display The difference is that, the cursor is already at
	the point, it goes on to the start or end of the document line, as appropriate for
	(Home|LineEnd|VCHome)(Extend)?."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HOMEWRAP
				wParam: 0
				lParam: 0]!

moveToVcHome
	"Move caret to before first visible character on line. If already there move to first
	character on line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VCHOME
				wParam: 0
				lParam: 0]!

moveToVcStartOfDisplayLine
	"Move caret to before first visible character on display line. If already there move to
	first character on display line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VCHOMEDISPLAY
				wParam: 0
				lParam: 0]!

moveToWrappedVcHome
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VCHOMEWRAP
				wParam: 0
				lParam: 0]!

moveUp
	"Move caret up one line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINEUP
				wParam: 0
				lParam: 0]!

multiPasteMode
	"Retrieve the effect of pasting when there are multiple selections.."

	^self class multiPasteModes at: self sciGetMultiPaste + 1 ifAbsent: [#once]!

multiPasteMode: aSymbol 
	"Set the effect of pasting when there are multiple selections.."

	^self sciSetMultiPaste: (self class multiPasteModes keyAtValue: aSymbol) - 1!

newLine
	"Insert a new line, may use a CRLF, CR or LF depending on EOL mode."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_NEWLINE
				wParam: 0
				lParam: 0]!

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

	self getDirectPointer.
	super onViewCreated.
	self initializeControl!

passwordCharacter
	^self shouldNotImplement!

passwordCharacter: aCharacter 
	^self shouldNotImplement!

pasteClipboard
	"Paste the contents of the clipboard into the document replacing the selection."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PASTE
				wParam: 0
				lParam: 0]!

performUndoableAction: aNiladicBlock 
	"Evaluate the <niladicBlock> argument as a composite update within an undo group
	such that it may be undone as a single undo operation."

	self beginUndoGroup.
	aNiladicBlock ensure: [self endUndoGroup]!

plainText
	"Retrieve all the text in the document. Returns number of characters retrieved. Result is
	NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETTEXT
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len - 1.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTEXT
				wParam: len
				lpParam: result.
			result]!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPOSITIONCACHE
				wParam: 0
				lParam: 0]!

positionCacheSize: sizeInteger 
	"Set number of entries in position cache"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETPOSITIONCACHE
				wParam: sizeInteger
				lParam: 0]!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPRINTCOLOURMODE
				wParam: 0
				lParam: 0]!

printColourMode: modeInteger 
	"Modify colours when printing for clearer printed text."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETPRINTCOLOURMODE
				wParam: modeInteger
				lParam: 0]!

printMagnification
	"Returns the print magnification."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPRINTMAGNIFICATION
				wParam: 0
				lParam: 0]!

printMagnification: magnificationInteger 
	"Sets the print magnification added to the point size of each style for printing."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETPRINTMAGNIFICATION
				wParam: magnificationInteger
				lParam: 0]!

punctuation
	^punctuation ifNil: [self sciGetPunctuationChars]!

punctuation: aStringOrNil 
	punctuation := aStringOrNil.
	punctuation ifNil: [self setCharacterClasses] ifNotNil: [self sciSetPunctuationChars: punctuation]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_REDO
				wParam: 0
				lParam: 0]!

rememberCaretX
	"Set the last x chosen value to be the caret x position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHOOSECARETX
				wParam: 0
				lParam: 0]!

removeAllAnnotations
	"Remove all the annotations from all lines in the receiver."

	self annotations: #()!

removeAllMarkers
	"Remove all markers on all lines from the view."

	self resetMarkers.
	self deleteMarkers: 0!

removeAllStyling
	"Set all style bytes to 0, remove all folding information."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEARDOCUMENTSTYLE
				wParam: 0
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEARSELECTIONS
				wParam: 0
				lParam: 0]!

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

	self zoomLevel: 0!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ROTATESELECTION
				wParam: 0
				lParam: 0]!

sciAddRefDocument: docInteger 
	"Private - Extend life of document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ADDREFDOCUMENT
				wParam: 0
				lParam: docInteger]!

sciAddSelection: caretInteger anchor: anchorInteger 
	"Private - Add a selection"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ADDSELECTION
				wParam: caretInteger
				lParam: anchorInteger]!

sciAddStyledText: lengthInteger c: cByteArray 
	"Private - Add array of cells to document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ADDSTYLEDTEXT
				wParam: lengthInteger
				lpParam: cByteArray]!

sciAddTabStop: lineInteger x: xInteger 
	"Private - Add an explicit tab stop for a line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ADDTABSTOP
				wParam: lineInteger
				lParam: xInteger]!

sciAddUndoAction: tokenInteger flags: flagsInteger 
	"Private - Add a container action to the undo stack"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ADDUNDOACTION
				wParam: tokenInteger
				lParam: flagsInteger]!

sciAllocate: bytesInteger 
	"Private - Enlarge the document to a particular size of text bytes."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ALLOCATE
				wParam: bytesInteger
				lParam: 0]!

sciAllocateExtendedStyles: numberStylesInteger 
	"Private - Allocate some extended (>255) style numbers and return the start of the range"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ALLOCATEEXTENDEDSTYLES
				wParam: numberStylesInteger
				lParam: 0]!

sciAllocateSubStyles: styleBaseInteger numberStyles: numberStylesInteger 
	"Private - Allocate a set of sub styles for a particular base style, returning start of
	range"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ALLOCATESUBSTYLES
				wParam: styleBaseInteger
				lParam: numberStylesInteger]!

sciAnnotationGetLines: lineInteger 
	"Private - Get the number of annotation lines for a line"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONGETLINES
				wParam: lineInteger
				lParam: 0]!

sciAnnotationGetStyles: lineInteger 
	"Private - Get the annotation styles for a line"

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_ANNOTATIONGETSTYLES
						wParam: lineInteger
						lpParam: nil].
	^len = 0 
		ifTrue: [#[]]
		ifFalse: 
			[| result |
			result := ByteArray newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONGETSTYLES
				wParam: lineInteger
				lpParam: result.
			result]!

sciAnnotationGetText: lineInteger 
	"Private - Get the annotation text for a line"

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_ANNOTATIONGETTEXT
						wParam: lineInteger
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONGETTEXT
				wParam: lineInteger
				lpParam: result.
			result]!

sciAnnotationGetVisible
	"Private - Get the visibility for the annotations for a view"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONGETVISIBLE
				wParam: 0
				lParam: 0]!

sciAnnotationSetStyles: lineInteger styles: stylesString 
	"Private - Set the annotation styles for a line"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONSETSTYLES
				wParam: lineInteger
				lpParam: stylesString]!

sciAnnotationSetText: lineInteger text: textString 
	"Private - Set the annotation text for a line"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONSETTEXT
				wParam: lineInteger
				lpParam: textString]!

sciAnnotationSetVisible: visibleInteger 
	"Private - Set the visibility for the annotations for a view"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ANNOTATIONSETVISIBLE
				wParam: visibleInteger
				lParam: 0]!

sciAppendText: lengthInteger text: textString 
	"Private - Append a string to the end of the document without changing the selection."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_APPENDTEXT
				wParam: lengthInteger
				lpParam: textString]!

sciAssignCmdKey: kmInteger msg: msgInteger 
	"Private - When key+modifier combination km is pressed perform msg."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ASSIGNCMDKEY
				wParam: kmInteger
				lParam: msgInteger]!

sciAutoCGetCaseInsensitiveBehaviour
	"Private - Get auto-completion case insensitive behaviour."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETCASEINSENSITIVEBEHAVIOUR
				wParam: 0
				lParam: 0]!

sciAutoCGetCurrent
	"Private - Get currently selected item position in the auto-completion list"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETCURRENT
				wParam: 0
				lParam: 0]!

sciAutoCGetMulti
	"Private - Retrieve the effect of autocompleting when there are multiple selections."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETMULTI
				wParam: 0
				lParam: 0]!

sciAutoCGetOrder
	"Private - Get the way autocompletion lists are ordered."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETORDER
				wParam: 0
				lParam: 0]!

sciAutoCGetSeparator
	"Private - Retrieve the auto-completion list separator character."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETSEPARATOR
				wParam: 0
				lParam: 0]!

sciAutoCGetTypeSeparator
	"Private - Retrieve the auto-completion list type-separator character."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCGETTYPESEPARATOR
				wParam: 0
				lParam: 0]!

sciAutoCPosStart
	"Private - Retrieve the position of the caret when the auto-completion list was displayed."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCPOSSTART
				wParam: 0
				lParam: 0]!

sciAutoCSetCaseInsensitiveBehaviour: behaviourInteger 
	"Private - Set auto-completion case insensitive behaviour to either prefer case-sensitive
	matches or have no preference."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETCASEINSENSITIVEBEHAVIOUR
				wParam: behaviourInteger
				lParam: 0]!

sciAutoCSetFillUps: characterSetString 
	"Private - Define a set of characters that when typed will cause the autocompletion to
	choose the selected item."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETFILLUPS
				wParam: 0
				lpParam: characterSetString]!

sciAutoCSetMulti: multiInteger 
	"Private - Change the effect of autocompleting when there are multiple selections."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETMULTI
				wParam: multiInteger
				lParam: 0]!

sciAutoCSetOrder: orderInteger 
	"Private - Set the way autocompletion lists are ordered."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETORDER
				wParam: orderInteger
				lParam: 0]!

sciAutoCSetSeparator: separatorCharacterInteger 
	"Private - Change the separator character in the string setting up an auto-completion list.
	Default is space but can be changed if items contain space."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETSEPARATOR
				wParam: separatorCharacterInteger
				lParam: 0]!

sciAutoCSetTypeSeparator: separatorCharacterInteger 
	"Private - Change the type-separator character in the string setting up an auto-completion
	list. Default is '?' but can be changed if items contain '?'."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSETTYPESEPARATOR
				wParam: separatorCharacterInteger
				lParam: 0]!

sciAutoCShow: lenEnteredInteger itemList: itemListString 
	"Private - Display a auto-completion list. The lenEntered parameter indicates how many
	characters before the caret should be used to provide context."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSHOW
				wParam: lenEnteredInteger
				lpParam: itemListString]!

sciAutoCStops: characterSetString 
	"Private - Define a set of character that when typed cancel the auto-completion list."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_AUTOCSTOPS
				wParam: 0
				lpParam: characterSetString]!

sciBraceBadLight: posInteger 
	"Private - Highlight the character at a position indicating there is no matching brace."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_BRACEBADLIGHT
				wParam: posInteger
				lParam: 0]!

sciBraceBadLightIndicator: useBraceBadLightIndicatorBoolean indicator: indicatorInteger 
	"Private - Use specified indicator to highlight non matching brace instead of changing its
	style."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_BRACEBADLIGHTINDICATOR
				wParam: useBraceBadLightIndicatorBoolean asParameter
				lParam: indicatorInteger]!

sciBraceHighlight: pos1Integer pos2: pos2Integer 
	"Private - Highlight the characters at two positions."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_BRACEHIGHLIGHT
				wParam: pos1Integer
				lParam: pos2Integer]!

sciBraceHighlightIndicator: useBraceHighlightIndicatorBoolean indicator: indicatorInteger 
	"Private - Use specified indicator to highlight matching braces instead of changing their
	style."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_BRACEHIGHLIGHTINDICATOR
				wParam: useBraceHighlightIndicatorBoolean asParameter
				lParam: indicatorInteger]!

sciBraceMatch: posInteger 
	"Private - Find the position of a matching brace or INVALID_POSITION if no match."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_BRACEMATCH
				wParam: posInteger
				lParam: 0]!

sciCallTipPosStart
	"Private - Retrieve the position where the caret was before displaying the call tip."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPPOSSTART
				wParam: 0
				lParam: 0]!

sciCallTipSetBack: backRGB 
	"Private - Set the background colour for the call tip."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPSETBACK
				wParam: backRGB asParameter
				lParam: 0]!

sciCallTipSetFore: foreRGB 
	"Private - Set the foreground colour for the call tip."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPSETFORE
				wParam: foreRGB asParameter
				lParam: 0]!

sciCallTipSetForeHlt: foreRGB 
	"Private - Set the foreground colour for the highlighted part of the call tip."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPSETFOREHLT
				wParam: foreRGB asParameter
				lParam: 0]!

sciCallTipSetHlt: startInteger end: endInteger 
	"Private - Highlight a segment of the definition."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPSETHLT
				wParam: startInteger
				lParam: endInteger]!

sciCallTipSetPosStart: posStartInteger 
	"Private - Set the start position in order to change when backspacing removes the calltip."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPSETPOSSTART
				wParam: posStartInteger
				lParam: 0]!

sciCallTipShow: posInteger definition: definitionString 
	"Private - Show a call tip containing a definition near position pos."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPSHOW
				wParam: posInteger
				lpParam: definitionString]!

sciCallTipUseStyle: tabSizeInteger 
	"Private - Enable use of STYLE_CALLTIP and set call tip tab size in pixels."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CALLTIPUSESTYLE
				wParam: tabSizeInteger
				lParam: 0]!

sciCanPaste
	"Private - Will a paste succeed?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_CANPASTE
				wParam: 0
				lParam: 0) asBoolean]!

sciChangeInsertion: lengthInteger text: textString 
	"Private - Change the text that is being inserted in response to SC_MOD_INSERTCHECK"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHANGEINSERTION
				wParam: lengthInteger
				lpParam: textString]!

sciChangeLexerState: startInteger end: endInteger 
	"Private - Indicate that the internal state of a lexer has changed over a range and
	therefore there may be a need to redraw."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHANGELEXERSTATE
				wParam: startInteger
				lParam: endInteger]!

sciCharPositionFromPoint: xInteger y: yInteger 
	"Private - Find the position of a character from a point within the window."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHARPOSITIONFROMPOINT
				wParam: xInteger
				lParam: yInteger]!

sciCharPositionFromPointClose: xInteger y: yInteger 
	"Private - Find the position of a character from a point within the window. Return
	INVALID_POSITION if not close to text."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CHARPOSITIONFROMPOINTCLOSE
				wParam: xInteger
				lParam: yInteger]!

sciClearAllCmdKeys
	"Private - Drop all key mappings."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEARALLCMDKEYS
				wParam: 0
				lParam: 0]!

sciClearCmdKey: kmInteger 
	"Private - When key+modifier combination km is pressed do nothing."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEARCMDKEY
				wParam: kmInteger
				lParam: 0]!

sciClearRepresentation: encodedCharacterString 
	"Private - Remove a character representation."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEARREPRESENTATION
				wParam: encodedCharacterString
				lParam: 0]!

sciClearTabStops: lineInteger 
	"Private - Clear explicit tabstops on a line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CLEARTABSTOPS
				wParam: lineInteger
				lParam: 0]!

sciColourise: startInteger end: endInteger 
	"Private - Colourise a segment of the document using the current lexing language."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_COLOURISE
				wParam: startInteger
				lParam: endInteger]!

sciContractedFoldNext: lineStartInteger 
	"Private - Find the next line at or after lineStart that is a contracted fold header line.
	Return -1 when no more lines."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CONTRACTEDFOLDNEXT
				wParam: lineStartInteger
				lParam: 0]!

sciConvertEOLs: eolModeInteger 
	"Private - Convert all line endings in the document to one mode."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CONVERTEOLS
				wParam: eolModeInteger
				lParam: 0]!

sciCopyRange: startInteger end: endInteger 
	"Private - Copy a range of text to the clipboard. Positions are clipped into the document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_COPYRANGE
				wParam: startInteger
				lParam: endInteger]!

sciCountCharacters: startPosInteger endPos: endPosInteger 
	"Private - Count characters between two positions."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_COUNTCHARACTERS
				wParam: startPosInteger
				lParam: endPosInteger]!

sciCreateDocument
	"Private - Create a new document object. Starts with reference count of 1 and not selected
	into editor."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_CREATEDOCUMENT
				wParam: 0
				lParam: 0]!

sciDeleteRange: posInteger deleteLength: deleteLengthInteger 
	"Private - Delete a range of text in the document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DELETERANGE
				wParam: posInteger
				lParam: deleteLengthInteger]!

sciDescribeProperty: nameString description: descriptionString 
	"Private - Describe a property. Result is NUL-terminated."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DESCRIBEPROPERTY
				wParam: nameString
				lpParam: descriptionString]!

sciDistanceToSecondaryStyles
	"Private - Where styles are duplicated by a feature such as active/inactive code return the
	distance between the two types."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DISTANCETOSECONDARYSTYLES
				wParam: 0
				lParam: 0]!

sciDocLineFromVisible: lineDisplayInteger 
	"Private - Find the document line of a display line taking hidden lines into account."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DOCLINEFROMVISIBLE
				wParam: lineDisplayInteger
				lParam: 0]!

sciDropSelectionN: selectionInteger 
	"Private - Drop one selection"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_DROPSELECTIONN
				wParam: selectionInteger
				lParam: 0]!

sciEncodedFromUTF8: utf8String encoded: encodedString 
	"Private - Translates a UTF8 string into the document encoding. Return the length of the
	result in bytes. On error return 0."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ENCODEDFROMUTF8
				wParam: utf8String
				lpParam: encodedString]!

sciEnsureVisible: lineInteger 
	"Private - Ensure a particular line is visible by expanding any header line hiding it."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ENSUREVISIBLE
				wParam: lineInteger
				lParam: 0]!

sciEnsureVisibleEnforcePolicy: lineInteger 
	"Private - Ensure a particular line is visible by expanding any header line hiding it. Use
	the currently set visibility policy to determine which range to display."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ENSUREVISIBLEENFORCEPOLICY
				wParam: lineInteger
				lParam: 0]!

sciExpandChildren: lineInteger level: levelInteger 
	"Private - Expand a fold header and all children. Use the level argument instead of the
	line's current level."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_EXPANDCHILDREN
				wParam: lineInteger
				lParam: levelInteger]!

sciFindColumn: lineInteger column: columnInteger 
	"Private - Find the position of a column on a line taking into account tabs and multi-byte
	characters. If beyond end of line, return line end position."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FINDCOLUMN
				wParam: lineInteger
				lParam: columnInteger]!

sciFindIndicatorFlash: startInteger end: endInteger 
	"Private - On OS X, flash a find indicator, then fade out."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FINDINDICATORFLASH
				wParam: startInteger
				lParam: endInteger]!

sciFindIndicatorHide
	"Private - On OS X, hide the find indicator."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FINDINDICATORHIDE
				wParam: 0
				lParam: 0]!

sciFindIndicatorShow: startInteger end: endInteger 
	"Private - On OS X, show a find indicator."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FINDINDICATORSHOW
				wParam: startInteger
				lParam: endInteger]!

sciFindText: flagsInteger ft: ftFINDTEXTEX 
	"Private - Find some text in the document."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FINDTEXT
				wParam: flagsInteger
				lpParam: ftFINDTEXTEX]!

sciFoldAll: actionInteger 
	"Private - Expand or contract all fold headers."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FOLDALL
				wParam: actionInteger
				lParam: 0]!

sciFoldChildren: lineInteger action: actionInteger 
	"Private - Expand or contract a fold header and its children."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FOLDCHILDREN
				wParam: lineInteger
				lParam: actionInteger]!

sciFoldLine: lineInteger action: actionInteger 
	"Private - Expand or contract a fold header."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FOLDLINE
				wParam: lineInteger
				lParam: actionInteger]!

sciFormatRange: drawBoolean fr: frFORMATRANGE 
	"Private - On Windows, will draw the document into a display context such as a printer."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FORMATRANGE
				wParam: drawBoolean asParameter
				lpParam: frFORMATRANGE]!

sciFreeSubStyles
	"Private - Free allocated sub styles"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_FREESUBSTYLES
				wParam: 0
				lParam: 0]!

sciGetAdditionalSelectionTyping
	"Private - Whether typing can be performed into multiple selections"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETADDITIONALSELECTIONTYPING
				wParam: 0
				lParam: 0) asBoolean]!

sciGetAnchor
	"Private - Returns the position of the opposite end of the selection to the caret."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETANCHOR
				wParam: 0
				lParam: 0]!

sciGetAutomaticFold
	"Private - Get automatic folding behaviours."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETAUTOMATICFOLD
				wParam: 0
				lParam: 0]!

sciGetCaretSticky
	"Private - Can the caret preferred x position only be changed by explicit movement
	commands?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCARETSTICKY
				wParam: 0
				lParam: 0]!

sciGetCaretStyle
	"Private - Returns the current style of the caret."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCARETSTYLE
				wParam: 0
				lParam: 0]!

sciGetCharAt: posInteger 
	"Private - Returns the character byte at the position."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCHARAT
				wParam: posInteger
				lParam: 0]!

sciGetCodePage
	"Private - Get the code page used to interpret the bytes of the document as characters."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCODEPAGE
				wParam: 0
				lParam: 0]!

sciGetColumn: posInteger 
	"Private - Retrieve the column number of a position, taking tab width into account."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCOLUMN
				wParam: posInteger
				lParam: 0]!

sciGetControlCharSymbol
	"Private - Get the way control characters are displayed."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCONTROLCHARSYMBOL
				wParam: 0
				lParam: 0]!

sciGetCurrentPos
	"Private - Returns the position of the caret."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETCURRENTPOS
				wParam: 0
				lParam: 0]!

sciGetDocPointer
	"Private - Retrieve a pointer to the document object."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETDOCPOINTER
				wParam: 0
				lParam: 0]!

sciGetEdgeColumn
	"Private - Retrieve the column number which text should be kept within."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETEDGECOLUMN
				wParam: 0
				lParam: 0]!

sciGetEdgeMode
	"Private - Retrieve the edge highlight mode."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETEDGEMODE
				wParam: 0
				lParam: 0]!

sciGetEndAtLastLine
	"Private - Retrieve whether the maximum scroll position has the last line at the bottom of
	the view."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETENDATLASTLINE
				wParam: 0
				lParam: 0) asBoolean]!

sciGetEndStyled
	"Private - Retrieve the position of the last correctly styled character."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETENDSTYLED
				wParam: 0
				lParam: 0]!

sciGetEOLMode
	"Private - Retrieve the current end of line mode - one of CRLF, CR, or LF."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETEOLMODE
				wParam: 0
				lParam: 0]!

sciGetFirstVisibleLine
	"Private - Retrieve the display line at the top of the display."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETFIRSTVISIBLELINE
				wParam: 0
				lParam: 0]!

sciGetFoldExpanded: lineInteger 
	"Private - Is a header line expanded?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETFOLDEXPANDED
				wParam: lineInteger
				lParam: 0) asBoolean]!

sciGetFoldLevel: lineInteger 
	"Private - Retrieve the fold level of a line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETFOLDLEVEL
				wParam: lineInteger
				lParam: 0]!

sciGetFoldParent: lineInteger 
	"Private - Find the parent line of a child line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETFOLDPARENT
				wParam: lineInteger
				lParam: 0]!

sciGetFontQuality
	"Private - Retrieve the quality level for text."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETFONTQUALITY
				wParam: 0
				lParam: 0]!

sciGetIdleStyling
	"Private - Retrieve the limits to idle styling."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETIDLESTYLING
				wParam: 0
				lParam: 0]!

sciGetIMEInteraction
	"Private - Is the IME displayed in a window or inline?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETIMEINTERACTION
				wParam: 0
				lParam: 0]!

sciGetIndentationGuides
	"Private - Are the indentation guides visible?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETINDENTATIONGUIDES
				wParam: 0
				lParam: 0]!

sciGetLastChild: lineInteger level: levelInteger 
	"Private - Find the last child line of a header line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLASTCHILD
				wParam: lineInteger
				lParam: levelInteger]!

sciGetLayoutCache
	"Private - Retrieve the degree of caching of layout information."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLAYOUTCACHE
				wParam: 0
				lParam: 0]!

sciGetLexer
	"Private - Retrieve the lexing language of the document."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLEXER
				wParam: 0
				lParam: 0]!

sciGetLine: lineInteger 
	"Private - Retrieve the contents of a line. Returns the length of the line."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETLINE
						wParam: lineInteger
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINE
				wParam: lineInteger
				lpParam: result.
			result]!

sciGetLineEndPosition: lineInteger 
	"Private - Get the position after the last visible characters on a line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINEENDPOSITION
				wParam: lineInteger
				lParam: 0]!

sciGetLineEndTypesActive
	"Private - Get the line end types currently recognised. May be a subset of the allowed types
	due to lexer limitation."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINEENDTYPESACTIVE
				wParam: 0
				lParam: 0]!

sciGetLineEndTypesAllowed
	"Private - Get the line end types currently allowed."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINEENDTYPESALLOWED
				wParam: 0
				lParam: 0]!

sciGetLineEndTypesSupported
	"Private - Bit set of LineEndType enumertion for which line ends beyond the standard LF, CR,
	and CRLF are supported by the lexer."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINEENDTYPESSUPPORTED
				wParam: 0
				lParam: 0]!

sciGetLineIndentation: lineInteger 
	"Private - Retrieve the number of columns that a line is indented."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINEINDENTATION
				wParam: lineInteger
				lParam: 0]!

sciGetLineIndentPosition: lineInteger 
	"Private - Retrieve the position before the first non indentation character on a line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINEINDENTPOSITION
				wParam: lineInteger
				lParam: 0]!

sciGetLineSelEndPosition: lineInteger 
	"Private - Retrieve the position of the end of the selection at the given line
	(INVALID_POSITION if no selection on this line)."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINESELENDPOSITION
				wParam: lineInteger
				lParam: 0]!

sciGetLineSelStartPosition: lineInteger 
	"Private - Retrieve the position of the start of the selection at the given line
	(INVALID_POSITION if no selection on this line)."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINESELSTARTPOSITION
				wParam: lineInteger
				lParam: 0]!

sciGetLineState: lineInteger 
	"Private - Retrieve the extra styling information for a line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINESTATE
				wParam: lineInteger
				lParam: 0]!

sciGetLineVisible: lineInteger 
	"Private - Is a line visible?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETLINEVISIBLE
				wParam: lineInteger
				lParam: 0) asBoolean]!

sciGetMainSelection
	"Private - Which selection is the main selection"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMAINSELECTION
				wParam: 0
				lParam: 0]!

sciGetMarginLeft
	"Private - Returns the size in pixels of the left margin."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMARGINLEFT
				wParam: 0
				lParam: 0]!

sciGetMarginOptions
	"Private - Get the margin options."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMARGINOPTIONS
				wParam: 0
				lParam: 0]!

sciGetMarginRight
	"Private - Returns the size in pixels of the right margin."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMARGINRIGHT
				wParam: 0
				lParam: 0]!

sciGetMaxLineState
	"Private - Retrieve the last line number that has line state."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMAXLINESTATE
				wParam: 0
				lParam: 0]!

sciGetMouseSelectionRectangularSwitch
	"Private - Whether switching to rectangular mode while selecting with the mouse is allowed."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMOUSESELECTIONRECTANGULARSWITCH
				wParam: 0
				lParam: 0) asBoolean]!

sciGetMultiPaste
	"Private - Retrieve the effect of pasting when there are multiple selections."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMULTIPASTE
				wParam: 0
				lParam: 0]!

sciGetNextTabStop: lineInteger x: xInteger 
	"Private - Find the next explicit tab stop position on a line after a position."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETNEXTTABSTOP
				wParam: lineInteger
				lParam: xInteger]!

sciGetPasteConvertEndings
	"Private - Get convert-on-paste setting"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPASTECONVERTENDINGS
				wParam: 0
				lParam: 0) asBoolean]!

sciGetPhasesDraw
	"Private - How many phases is drawing done in?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPHASESDRAW
				wParam: 0
				lParam: 0]!

sciGetPrimaryStyleFromStyle: styleInteger 
	"Private - For a secondary style, return the primary style, else return the argument."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPRIMARYSTYLEFROMSTYLE
				wParam: styleInteger
				lParam: 0]!

sciGetPrintWrapMode
	"Private - Is printing line wrapped?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPRINTWRAPMODE
				wParam: 0
				lParam: 0]!

sciGetProperty: keyString buf: bufString 
	"Private - Retrieve a 'property' value previously set with SetProperty. Result is
	NUL-terminated."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPROPERTY
				wParam: keyString
				lpParam: bufString]!

sciGetPropertyExpanded: keyString buf: bufString 
	"Private - Retrieve a 'property' value previously set with SetProperty, with '$()' variable
	replacement on returned buffer. Result is NUL-terminated."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPROPERTYEXPANDED
				wParam: keyString
				lpParam: bufString]!

sciGetPropertyInt: keyString 
	"Private - Retrieve a 'property' value previously set with SetProperty, interpreted as an
	int AFTER any '$()' variable replacement."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPROPERTYINT
				wParam: keyString
				lParam: 0]!

sciGetPunctuationChars
	"Private - Get the set of characters making up punctuation characters"

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETPUNCTUATIONCHARS
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETPUNCTUATIONCHARS
				wParam: 0
				lpParam: result.
			result]!

sciGetRectangularSelectionAnchor
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETRECTANGULARSELECTIONANCHOR
				wParam: 0
				lParam: 0]!

sciGetRectangularSelectionAnchorVirtualSpace
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE
				wParam: 0
				lParam: 0]!

sciGetRectangularSelectionCaret
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETRECTANGULARSELECTIONCARET
				wParam: 0
				lParam: 0]!

sciGetRectangularSelectionCaretVirtualSpace
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE
				wParam: 0
				lParam: 0]!

sciGetRepresentation: encodedCharacterString representation: representationString 
	"Private - Set the way a character is drawn. Result is NUL-terminated."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETREPRESENTATION
				wParam: encodedCharacterString
				lpParam: representationString]!

sciGetSearchFlags
	"Private - Get the search flags used by SearchInTarget."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSEARCHFLAGS
				wParam: 0
				lParam: 0]!

sciGetSelectionEnd
	"Private - Returns the position at the end of the selection."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONEND
				wParam: 0
				lParam: 0]!

sciGetSelectionMode
	"Private - Get the mode of the current selection."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONMODE
				wParam: 0
				lParam: 0]!

sciGetSelectionNAnchor: selectionInteger 
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONNANCHOR
				wParam: selectionInteger
				lParam: 0]!

sciGetSelectionNAnchorVirtualSpace: selectionInteger 
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONNANCHORVIRTUALSPACE
				wParam: selectionInteger
				lParam: 0]!

sciGetSelectionNCaret: selectionInteger 
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONNCARET
				wParam: selectionInteger
				lParam: 0]!

sciGetSelectionNCaretVirtualSpace: selectionInteger 
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONNCARETVIRTUALSPACE
				wParam: selectionInteger
				lParam: 0]!

sciGetSelectionNEnd: selectionInteger 
	"Private - Returns the position at the end of the selection."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONNEND
				wParam: selectionInteger
				lParam: 0]!

sciGetSelectionNStart: selectionInteger 
	"Private - Returns the position at the start of the selection."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONNSTART
				wParam: selectionInteger
				lParam: 0]!

sciGetSelectionStart
	"Private - Returns the position at the start of the selection."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONSTART
				wParam: 0
				lParam: 0]!

sciGetStyleBits
	"Private - Retrieve number of bits in style bytes used to hold the lexical state."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSTYLEBITS
				wParam: 0
				lParam: 0]!

sciGetStyleBitsNeeded
	"Private - Retrieve the number of bits the current lexer needs for styling."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSTYLEBITSNEEDED
				wParam: 0
				lParam: 0]!

sciGetStyledText: trTEXTRANGE 
	"Private - Retrieve a buffer of cells. Returns the number of bytes in the buffer not
	including terminating NULs."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSTYLEDTEXT
				wParam: 0
				lpParam: trTEXTRANGE]!

sciGetStyleFromSubStyle: subStyleInteger 
	"Private - For a sub style, return the base style, else return the argument."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSTYLEFROMSUBSTYLE
				wParam: subStyleInteger
				lParam: 0]!

sciGetSubStyleBases
	"Private - Get the set of base styles that can be extended with sub styles Result is
	NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETSUBSTYLEBASES
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: [#[]]
		ifFalse: 
			[| result |
			result := ByteArray newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSUBSTYLEBASES
				wParam: 0
				lpParam: result.
			result]!

sciGetSubStylesLength: styleBaseInteger 
	"Private - The number of sub styles associated with a base style"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSUBSTYLESLENGTH
				wParam: styleBaseInteger
				lParam: 0]!

sciGetSubStylesStart: styleBaseInteger 
	"Private - The starting style number for the sub styles associated with a base style"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSUBSTYLESSTART
				wParam: styleBaseInteger
				lParam: 0]!

sciGetTag: tagNumberInteger 
	"Private - Retrieve the value of a tag from a regular expression search. Result is
	NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETTAG
						wParam: tagNumberInteger
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTAG
				wParam: tagNumberInteger
				lpParam: result.
			result]!

sciGetTargetEnd
	"Private - Get the position that ends the target."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTARGETEND
				wParam: 0
				lParam: 0]!

sciGetTargetStart
	"Private - Get the position that starts the target."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTARGETSTART
				wParam: 0
				lParam: 0]!

sciGetTechnology
	"Private - Get the tech."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTECHNOLOGY
				wParam: 0
				lParam: 0]!

sciGetTextRange: trTEXTRANGE 
	"Private - Retrieve a range of text. Return the length of the text."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTEXTRANGE
				wParam: 0
				lpParam: trTEXTRANGE]!

sciGetViewWS
	"Private - Are white space characters currently visible? Returns one of SCWS_* constants."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETVIEWWS
				wParam: 0
				lParam: 0]!

sciGetVirtualSpaceOptions
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETVIRTUALSPACEOPTIONS
				wParam: 0
				lParam: 0]!

sciGetWhitespaceChars
	"Private - Get the set of characters making up whitespace for when moving or selecting by
	word."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETWHITESPACECHARS
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETWHITESPACECHARS
				wParam: 0
				lpParam: result.
			result]!

sciGetWordChars
	"Private - Get the set of characters making up words for when moving or selecting by word.
	Returns the number of characters"

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETWORDCHARS
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETWORDCHARS
				wParam: 0
				lpParam: result.
			result]!

sciGetWrapIndentMode
	"Private - Retrieve how wrapped sublines are placed. Default is fixed."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETWRAPINDENTMODE
				wParam: 0
				lParam: 0]!

sciGetWrapMode
	"Private - Retrieve whether text is word wrapped."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETWRAPMODE
				wParam: 0
				lParam: 0]!

sciGetWrapVisualFlags
	"Private - Retrive the display mode of visual flags for wrapped lines."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETWRAPVISUALFLAGS
				wParam: 0
				lParam: 0]!

sciGetWrapVisualFlagsLocation
	"Private - Retrive the location of visual flags for wrapped lines."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETWRAPVISUALFLAGSLOCATION
				wParam: 0
				lParam: 0]!

sciGotoLine: lineInteger 
	"Private - Set caret to start of a line and ensure it is visible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GOTOLINE
				wParam: lineInteger
				lParam: 0]!

sciGotoPos: posInteger 
	"Private - Set caret to a position and ensure it is visible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GOTOPOS
				wParam: posInteger
				lParam: 0]!

sciHideLines: lineStartInteger lineEnd: lineEndInteger 
	"Private - Make a range of lines invisible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_HIDELINES
				wParam: lineStartInteger
				lParam: lineEndInteger]!

sciIndicatorAllOnFor: positionInteger 
	"Private - Are any indicators present at position?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_INDICATORALLONFOR
				wParam: positionInteger
				lParam: 0]!

sciIndicatorClearRange: positionInteger clearLength: clearLengthInteger 
	"Private - Turn a indicator off over a range."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_INDICATORCLEARRANGE
				wParam: positionInteger
				lParam: clearLengthInteger]!

sciIndicatorEnd: indicatorInteger position: positionInteger 
	"Private - Where does a particular indicator end?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_INDICATOREND
				wParam: indicatorInteger
				lParam: positionInteger]!

sciIndicatorFillRange: positionInteger fillLength: fillLengthInteger 
	"Private - Turn a indicator on over a range."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_INDICATORFILLRANGE
				wParam: positionInteger
				lParam: fillLengthInteger]!

sciIndicatorStart: indicatorInteger position: positionInteger 
	"Private - Where does a particular indicator start?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_INDICATORSTART
				wParam: indicatorInteger
				lParam: positionInteger]!

sciIndicatorValueAt: indicatorInteger position: positionInteger 
	"Private - What value does a particular indicator have at at a position?"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_INDICATORVALUEAT
				wParam: indicatorInteger
				lParam: positionInteger]!

sciInsertText: posInteger text: textString 
	"Private - Insert string at a position."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_INSERTTEXT
				wParam: posInteger
				lpParam: textString]!

sciIsRangeWord: startInteger end: endInteger 
	"Private - Is the range start..end considered a word?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_ISRANGEWORD
				wParam: startInteger
				lParam: endInteger) asBoolean]!

sciLineScroll: columnsInteger lines: linesInteger 
	"Private - Scroll horizontally and vertically."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINESCROLL
				wParam: columnsInteger
				lParam: linesInteger]!

sciLoadLexerLibrary: pathString 
	"Private - Load a lexer library (dll / so)."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LOADLEXERLIBRARY
				wParam: 0
				lpParam: pathString]!

sciMarginGetStyle: lineInteger 
	"Private - Get the style number for the text margin for a line"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINGETSTYLE
				wParam: lineInteger
				lParam: 0]!

sciMarginGetStyles: lineInteger 
	"Private - Get the styles in the text margin for a line"

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_MARGINGETSTYLES
						wParam: lineInteger
						lpParam: nil].
	^len = 0 
		ifTrue: [#[]]
		ifFalse: 
			[| result |
			result := ByteArray newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINGETSTYLES
				wParam: lineInteger
				lpParam: result.
			result]!

sciMarginGetText: lineInteger 
	"Private - Get the text in the text margin for a line"

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_MARGINGETTEXT
						wParam: lineInteger
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINGETTEXT
				wParam: lineInteger
				lpParam: result.
			result]!

sciMarginSetStyle: lineInteger style: styleInteger 
	"Private - Set the style number for the text margin for a line"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINSETSTYLE
				wParam: lineInteger
				lParam: styleInteger]!

sciMarginSetStyles: lineInteger styles: stylesString 
	"Private - Set the style in the text margin for a line"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINSETSTYLES
				wParam: lineInteger
				lpParam: stylesString]!

sciMarginSetText: lineInteger text: textString 
	"Private - Set the text in the text margin for a line"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINSETTEXT
				wParam: lineInteger
				lpParam: textString]!

sciMarginTextClearAll
	"Private - Clear the margin text on all lines"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARGINTEXTCLEARALL
				wParam: 0
				lParam: 0]!

sciMarkerAddSet: lineInteger set: setInteger 
	"Private - Add a set of markers to a line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERADDSET
				wParam: lineInteger
				lParam: setInteger]!

sciMarkerDefinePixmap: markerNumberInteger pixmap: pixmapString 
	"Private - Define a marker from a pixmap."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERDEFINEPIXMAP
				wParam: markerNumberInteger
				lpParam: pixmapString]!

sciMarkerDefineRGBAImage: markerNumberInteger pixels: pixelsString 
	"Private - Define a marker from RGBA data. It has the width and height from
	RGBAImageSetWidth/Height"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERDEFINERGBAIMAGE
				wParam: markerNumberInteger
				lpParam: pixelsString]!

sciMarkerDeleteHandle: handleInteger 
	"Private - Delete a marker."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERDELETEHANDLE
				wParam: handleInteger
				lParam: 0]!

sciMarkerEnableHighlight: enabledBoolean 
	"Private - Enable/disable highlight for current folding bloc (smallest one that contains the
	caret)"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERENABLEHIGHLIGHT
				wParam: enabledBoolean asParameter
				lParam: 0]!

sciMarkerGet: lineInteger 
	"Private - Get a bit mask of all the markers set on a line."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERGET
				wParam: lineInteger
				lParam: 0]!

sciMarkerLineFromHandle: handleInteger 
	"Private - Retrieve the line number at which a particular marker is located."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERLINEFROMHANDLE
				wParam: handleInteger
				lParam: 0]!

sciMarkerNext: lineStartInteger markerMask: markerMaskInteger 
	"Private - Find the next line at or after lineStart that includes a marker in mask. Return
	-1 when no more lines."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERNEXT
				wParam: lineStartInteger
				lParam: markerMaskInteger]!

sciMarkerPrevious: lineStartInteger markerMask: markerMaskInteger 
	"Private - Find the previous line before lineStart that includes a marker in mask."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERPREVIOUS
				wParam: lineStartInteger
				lParam: markerMaskInteger]!

sciMarkerSetAlpha: markerNumberInteger alpha: alphaInteger 
	"Private - Set the alpha used for a marker that is drawn in the text area, not the margin."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERSETALPHA
				wParam: markerNumberInteger
				lParam: alphaInteger]!

sciMarkerSymbolDefined: markerNumberInteger 
	"Private - Which symbol was defined for markerNumber with MarkerDefine"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MARKERSYMBOLDEFINED
				wParam: markerNumberInteger
				lParam: 0]!

sciMultipleSelectAddEach
	"Private - Add each occurrence of the main selection in the target to the set of selections.
	If the current selection is empty then select word around caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MULTIPLESELECTADDEACH
				wParam: 0
				lParam: 0]!

sciMultipleSelectAddNext
	"Private - Add the next occurrence of the main selection to the set of selections as main.
	If the current selection is empty then select word around caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_MULTIPLESELECTADDNEXT
				wParam: 0
				lParam: 0]!

sciPointXFromPosition: posInteger 
	"Private - Retrieve the x value of the point in the window where a position is displayed."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_POINTXFROMPOSITION
				wParam: 0
				lParam: posInteger]!

sciPointYFromPosition: posInteger 
	"Private - Retrieve the y value of the point in the window where a position is displayed."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_POINTYFROMPOSITION
				wParam: 0
				lParam: posInteger]!

sciPositionAfter: posInteger 
	"Private - Given a valid document position, return the next position taking code page into
	account. Maximum value returned is the last position in the document."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_POSITIONAFTER
				wParam: posInteger
				lParam: 0]!

sciPositionBefore: posInteger 
	"Private - Given a valid document position, return the previous position taking code page
	into account. Returns 0 if passed 0."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_POSITIONBEFORE
				wParam: posInteger
				lParam: 0]!

sciPositionFromPoint: xInteger y: yInteger 
	"Private - Find the position from a point within the window."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_POSITIONFROMPOINT
				wParam: xInteger
				lParam: yInteger]!

sciPositionFromPointClose: xInteger y: yInteger 
	"Private - Find the position from a point within the window but return INVALID_POSITION if
	not close to text."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_POSITIONFROMPOINTCLOSE
				wParam: xInteger
				lParam: yInteger]!

sciPositionRelative: posInteger relative: relativeInteger 
	"Private - Given a valid document position, return a position that differs in a number of
	characters. Returned value is always between 0 and last position in document."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_POSITIONRELATIVE
				wParam: posInteger
				lParam: relativeInteger]!

sciPrivateLexerCall: operationInteger pointer: pointerInteger 
	"Private - For private communication between an application and a known lexer."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PRIVATELEXERCALL
				wParam: operationInteger
				lParam: pointerInteger]!

sciPropertyType: nameString 
	"Private - Retrieve the type of a property."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_PROPERTYTYPE
				wParam: nameString
				lParam: 0]!

sciRegisterImage: typeInteger xpmData: xpmDataString 
	"Private - Register an XPM image for use in autocompletion lists."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_REGISTERIMAGE
				wParam: typeInteger
				lpParam: xpmDataString]!

sciRegisterRGBAImage: typeInteger pixels: pixelsString 
	"Private - Register an RGBA image for use in autocompletion lists. It has the width and
	height from RGBAImageSetWidth/Height"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_REGISTERRGBAIMAGE
				wParam: typeInteger
				lpParam: pixelsString]!

sciReleaseAllExtendedStyles
	"Private - Release all extended (>255) style numbers"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_RELEASEALLEXTENDEDSTYLES
				wParam: 0
				lParam: 0]!

sciReleaseDocument: docInteger 
	"Private - Release a reference to the document, deleting document if it fades to black."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_RELEASEDOCUMENT
				wParam: 0
				lParam: docInteger]!

sciReplaceSel: textString 
	"Private - Replace the selected text with the argument text."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_REPLACESEL
				wParam: 0
				lpParam: textString]!

sciReplaceTarget: lengthInteger text: textString 
	"Private - Replace the target text with the argument text. Text is counted so it can contain
	NULs. Returns the length of the replacement text."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_REPLACETARGET
				wParam: lengthInteger
				lpParam: textString]!

sciReplaceTargetRE: lengthInteger text: textString 
	"Private - Replace the target text with the argument text after \d processing. Text is
	counted so it can contain NULs. Looks for \d where d is between 1 and 9 and replaces these
	with the strings matched in the last search operation which were surrounded by \( and \).
	Returns the length of the replacement text including any change caused by processing the \d
	patterns."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_REPLACETARGETRE
				wParam: lengthInteger
				lpParam: textString]!

sciRGBAImageSetHeight: heightInteger 
	"Private - Set the height for future RGBA image data."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_RGBAIMAGESETHEIGHT
				wParam: heightInteger
				lParam: 0]!

sciRGBAImageSetScale: scalePercentInteger 
	"Private - Set the scale factor in percent for future RGBA image data."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_RGBAIMAGESETSCALE
				wParam: scalePercentInteger
				lParam: 0]!

sciRGBAImageSetWidth: widthInteger 
	"Private - Set the width for future RGBA image data."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_RGBAIMAGESETWIDTH
				wParam: widthInteger
				lParam: 0]!

sciScrollCaret
	"Private - Ensure the caret is visible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SCROLLCARET
				wParam: 0
				lParam: 0]!

sciScrollRange: secondaryInteger primary: primaryInteger 
	"Private - Scroll the argument positions and the range between them into view giving
	priority to the primary position then the secondary position. This may be used to make a
	search match visible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SCROLLRANGE
				wParam: secondaryInteger
				lParam: primaryInteger]!

sciSearchAnchor
	"Private - Sets the current caret position to be the search anchor."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SEARCHANCHOR
				wParam: 0
				lParam: 0]!

sciSearchInTarget: lengthInteger text: textString 
	"Private - Search for a counted string in the target and set the target to the found range.
	Text is counted so it can contain NULs. Returns length of range or -1 for failure in which
	case target is not moved."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SEARCHINTARGET
				wParam: lengthInteger
				lpParam: textString]!

sciSearchNext: flagsInteger text: textString 
	"Private - Find some text starting at the search anchor. Does not ensure the selection is
	visible."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SEARCHNEXT
				wParam: flagsInteger
				lpParam: textString]!

sciSearchPrev: flagsInteger text: textString 
	"Private - Find some text starting at the search anchor and moving backwards. Does not
	ensure the selection is visible."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SEARCHPREV
				wParam: flagsInteger
				lpParam: textString]!

sciSetAdditionalCaretFore: foreRGB 
	"Private - Set the foreground colour of additional carets."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETADDITIONALCARETFORE
				wParam: foreRGB asParameter
				lParam: 0]!

sciSetAdditionalSelBack: backRGB 
	"Private - Set the background colour of additional selections. Must have previously called
	SetSelBack with non-zero first argument for this to have an effect."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETADDITIONALSELBACK
				wParam: backRGB asParameter
				lParam: 0]!

sciSetAdditionalSelectionTyping: additionalSelectionTypingBoolean 
	"Private - Set whether typing can be performed into multiple selections"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETADDITIONALSELECTIONTYPING
				wParam: additionalSelectionTypingBoolean asParameter
				lParam: 0]!

sciSetAdditionalSelFore: foreRGB 
	"Private - Set the foreground colour of additional selections. Must have previously called
	SetSelFore with non-zero first argument for this to have an effect."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETADDITIONALSELFORE
				wParam: foreRGB asParameter
				lParam: 0]!

sciSetAnchor: posAnchorInteger 
	"Private - Set the selection anchor to a position. The anchor is the opposite end of the
	selection from the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETANCHOR
				wParam: posAnchorInteger
				lParam: 0]!

sciSetAutomaticFold: automaticFoldInteger 
	"Private - Set automatic folding behaviours."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETAUTOMATICFOLD
				wParam: automaticFoldInteger
				lParam: 0]!

sciSetCaretFore: foreRGB 
	"Private - Set the foreground colour of the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETFORE
				wParam: foreRGB asParameter
				lParam: 0]!

sciSetCaretLineBack: backRGB 
	"Private - Set the colour of the background of the line containing the caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETLINEBACK
				wParam: backRGB asParameter
				lParam: 0]!

sciSetCaretSticky: useCaretStickyBehaviourInteger 
	"Private - Stop the caret preferred x position changing when the user types."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETSTICKY
				wParam: useCaretStickyBehaviourInteger
				lParam: 0]!

sciSetCaretStyle: caretStyleInteger 
	"Private - Set the style of the caret to be drawn."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETSTYLE
				wParam: caretStyleInteger
				lParam: 0]!

sciSetCaretWidth: pixelWidthInteger 
	"Private - Set the width of the insert mode caret."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCARETWIDTH
				wParam: pixelWidthInteger
				lParam: 0]!

sciSetCharsDefault
	"Private - Reset the set of characters for whitespace and word characters to the defaults."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCHARSDEFAULT
				wParam: 0
				lParam: 0]!

sciSetCodePage: codePageInteger 
	"Private - Set the code page used to interpret the bytes of the document as characters. The
	SC_CP_UTF8 value can be used to enter Unicode mode."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCODEPAGE
				wParam: codePageInteger
				lParam: 0]!

sciSetControlCharSymbol: symbolInteger 
	"Private - Change the way control characters are displayed: If symbol is < 32, keep the
	drawn way, else, use the given character."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETCONTROLCHARSYMBOL
				wParam: symbolInteger
				lParam: 0]!

sciSetDocPointer: pointerInteger 
	"Private - Change the document object used."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETDOCPOINTER
				wParam: 0
				lParam: pointerInteger]!

sciSetEdgeColumn: columnInteger 
	"Private - Set the column number of the edge. If text goes past the edge then it is
	highlighted."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETEDGECOLUMN
				wParam: columnInteger
				lParam: 0]!

sciSetEdgeMode: modeInteger 
	"Private - The edge may be displayed by a line (EDGE_LINE) or by highlighting text that goes
	beyond it (EDGE_BACKGROUND) or not displayed at all (EDGE_NONE)."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETEDGEMODE
				wParam: modeInteger
				lParam: 0]!

sciSetEmptySelection: posInteger 
	"Private - Set caret to a position, while removing any existing selection."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETEMPTYSELECTION
				wParam: posInteger
				lParam: 0]!

sciSetEOLMode: eolModeInteger 
	"Private - Set the current end of line mode."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETEOLMODE
				wParam: eolModeInteger
				lParam: 0]!

sciSetFirstVisibleLine: lineDisplayInteger 
	"Private - Scroll so that a display line is at the top of the display."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETFIRSTVISIBLELINE
				wParam: lineDisplayInteger
				lParam: 0]!

sciSetFoldExpanded: lineInteger expanded: expandedBoolean 
	"Private - Show the children of a header line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETFOLDEXPANDED
				wParam: lineInteger
				lParam: expandedBoolean asParameter]!

sciSetFoldFlags: flagsInteger 
	"Private - Set some style options for folding."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETFOLDFLAGS
				wParam: flagsInteger
				lParam: 0]!

sciSetFoldLevel: lineInteger level: levelInteger 
	"Private - Set the fold level of a line. This encodes an integer level along with flags
	indicating whether the line is a header and whether it is effectively white space."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETFOLDLEVEL
				wParam: lineInteger
				lParam: levelInteger]!

sciSetFoldMarginColour: useSettingBoolean back: backRGB 
	"Private - Set the colours used as a chequerboard pattern in the fold margin"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETFOLDMARGINCOLOUR
				wParam: useSettingBoolean asParameter
				lParam: backRGB asParameter]!

sciSetFoldMarginHiColour: useSettingBoolean fore: foreRGB 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETFOLDMARGINHICOLOUR
				wParam: useSettingBoolean asParameter
				lParam: foreRGB asParameter]!

sciSetFontQuality: fontQualityInteger 
	"Private - Choose the quality level for text from the FontQuality enumeration."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETFONTQUALITY
				wParam: fontQualityInteger
				lParam: 0]!

sciSetHotspotActiveBack: useSettingBoolean back: backRGB 
	"Private - Set a back colour for active hotspots."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETHOTSPOTACTIVEBACK
				wParam: useSettingBoolean asParameter
				lParam: backRGB asParameter]!

sciSetHotspotActiveFore: useSettingBoolean fore: foreRGB 
	"Private - Set a fore colour for active hotspots."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETHOTSPOTACTIVEFORE
				wParam: useSettingBoolean asParameter
				lParam: foreRGB asParameter]!

sciSetHScrollBar: showBoolean 
	"Private - Show or hide the horizontal scroll bar."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETHSCROLLBAR
				wParam: showBoolean asParameter
				lParam: 0]!

sciSetIdentifiers: styleInteger identifiers: identifiersString 
	"Private - Set the identifiers that are shown in a particular style"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETIDENTIFIERS
				wParam: styleInteger
				lpParam: identifiersString]!

sciSetIdleStyling: idleStylingInteger 
	"Private - Sets limits to idle styling."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETIDLESTYLING
				wParam: idleStylingInteger
				lParam: 0]!

sciSetIMEInteraction: imeInteractionInteger 
	"Private - Choose to display the the IME in a winow or inline."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETIMEINTERACTION
				wParam: imeInteractionInteger
				lParam: 0]!

sciSetIndentationGuides: indentViewInteger 
	"Private - Show or hide indentation guides."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETINDENTATIONGUIDES
				wParam: indentViewInteger
				lParam: 0]!

sciSetKeyWords: keywordSetInteger keyWords: keyWordsString 
	"Private - Set up the key words used by the lexer."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETKEYWORDS
				wParam: keywordSetInteger
				lpParam: keyWordsString]!

sciSetLayoutCache: modeInteger 
	"Private - Sets the degree of caching of layout information."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETLAYOUTCACHE
				wParam: modeInteger
				lParam: 0]!

sciSetLengthForEncode: bytesInteger 
	"Private - Set the length of the utf8 argument for calling EncodedFromUTF8. Set to -1 and
	the string will be measured to the first nul."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETLENGTHFORENCODE
				wParam: bytesInteger
				lParam: 0]!

sciSetLexer: lexerInteger 
	"Private - Set the lexing language of the document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETLEXER
				wParam: lexerInteger
				lParam: 0]!

sciSetLexerLanguage: languageString 
	"Private - Set the lexing language of the document based on string name."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETLEXERLANGUAGE
				wParam: 0
				lpParam: languageString]!

sciSetLineEndTypesAllowed: lineEndBitSetInteger 
	"Private - Set the line end types that the application wants to use. May not be used if
	incompatible with lexer or encoding."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETLINEENDTYPESALLOWED
				wParam: lineEndBitSetInteger
				lParam: 0]!

sciSetLineIndentation: lineInteger indentSize: indentSizeInteger 
	"Private - Change the indentation of a line to a number of columns."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETLINEINDENTATION
				wParam: lineInteger
				lParam: indentSizeInteger]!

sciSetLineState: lineInteger state: stateInteger 
	"Private - Used to hold extra styling information for each line."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETLINESTATE
				wParam: lineInteger
				lParam: stateInteger]!

sciSetMainSelection: selectionInteger 
	"Private - Set the main selection"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMAINSELECTION
				wParam: selectionInteger
				lParam: 0]!

sciSetMarginLeft: pixelWidthInteger 
	"Private - Sets the size in pixels of the left margin."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMARGINLEFT
				wParam: 0
				lParam: pixelWidthInteger]!

sciSetMarginOptions: marginOptionsInteger 
	"Private - Set the margin options."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMARGINOPTIONS
				wParam: marginOptionsInteger
				lParam: 0]!

sciSetMarginRight: pixelWidthInteger 
	"Private - Sets the size in pixels of the right margin."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMARGINRIGHT
				wParam: 0
				lParam: pixelWidthInteger]!

sciSetModEventMask: maskInteger 
	"Private - Set which document modification events are sent to the container."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMODEVENTMASK
				wParam: maskInteger
				lParam: 0]!

sciSetMouseSelectionRectangularSwitch: mouseSelectionRectangularSwitchBoolean 
	"Private - Set whether switching to rectangular mode while selecting with the mouse is
	allowed."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMOUSESELECTIONRECTANGULARSWITCH
				wParam: mouseSelectionRectangularSwitchBoolean asParameter
				lParam: 0]!

sciSetMultiPaste: multiPasteInteger 
	"Private - Change the effect of pasting when there are multiple selections."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMULTIPASTE
				wParam: multiPasteInteger
				lParam: 0]!

sciSetPasteConvertEndings: convertBoolean 
	"Private - Enable/Disable convert-on-paste for line endings"

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETPASTECONVERTENDINGS
				wParam: convertBoolean asParameter
				lParam: 0]!

sciSetPhasesDraw: phasesInteger 
	"Private - In one phase draw, text is drawn in a series of rectangular blocks with no
	overlap. In two phase draw, text is drawn in a series of lines allowing runs to overlap
	horizontally. In multiple phase draw, each element is drawn over the whole drawing area,
	allowing text to overlap from one line to the next."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETPHASESDRAW
				wParam: phasesInteger
				lParam: 0]!

sciSetPrintWrapMode: modeInteger 
	"Private - Set printing to line wrapped (SC_WRAP_WORD) or not line wrapped (SC_WRAP_NONE)."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETPRINTWRAPMODE
				wParam: modeInteger
				lParam: 0]!

sciSetProperty: keyString value: valueString 
	"Private - Set up a value that may be used by a lexer for some optional feature."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETPROPERTY
				wParam: keyString
				lpParam: valueString]!

sciSetPunctuationChars: charactersString 
	"Private - Set the set of characters making up punctuation characters Should be called after
	SetWordChars."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETPUNCTUATIONCHARS
				wParam: 0
				lpParam: charactersString]!

sciSetRectangularSelectionAnchor: posAnchorInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETRECTANGULARSELECTIONANCHOR
				wParam: posAnchorInteger
				lParam: 0]!

sciSetRectangularSelectionAnchorVirtualSpace: spaceInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETRECTANGULARSELECTIONANCHORVIRTUALSPACE
				wParam: spaceInteger
				lParam: 0]!

sciSetRectangularSelectionCaret: posInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETRECTANGULARSELECTIONCARET
				wParam: posInteger
				lParam: 0]!

sciSetRectangularSelectionCaretVirtualSpace: spaceInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETRECTANGULARSELECTIONCARETVIRTUALSPACE
				wParam: spaceInteger
				lParam: 0]!

sciSetRepresentation: encodedCharacterString representation: representationString 
	"Private - Set the way a character is drawn."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETREPRESENTATION
				wParam: encodedCharacterString
				lpParam: representationString]!

sciSetSavePoint
	"Private - Remember the current position in the undo history as the position at which the
	document was saved."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSAVEPOINT
				wParam: 0
				lParam: 0]!

sciSetSearchFlags: flagsInteger 
	"Private - Set the search flags used by SearchInTarget."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSEARCHFLAGS
				wParam: flagsInteger
				lParam: 0]!

sciSetSelBack: useSettingBoolean back: backRGB 
	"Private - Set the background colour of the main and additional selections and whether to
	use this setting."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELBACK
				wParam: useSettingBoolean asParameter
				lParam: backRGB asParameter]!

sciSetSelection: caretInteger anchor: anchorInteger 
	"Private - Set a simple selection"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELECTION
				wParam: caretInteger
				lParam: anchorInteger]!

sciSetSelectionMode: modeInteger 
	"Private - Set the selection mode to stream (SC_SEL_STREAM) or rectangular
	(SC_SEL_RECTANGLE/SC_SEL_THIN) or by lines (SC_SEL_LINES)."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELECTIONMODE
				wParam: modeInteger
				lParam: 0]!

sciSetSelectionNAnchor: selectionInteger posAnchor: posAnchorInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELECTIONNANCHOR
				wParam: selectionInteger
				lParam: posAnchorInteger]!

sciSetSelectionNAnchorVirtualSpace: selectionInteger space: spaceInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELECTIONNANCHORVIRTUALSPACE
				wParam: selectionInteger
				lParam: spaceInteger]!

sciSetSelectionNCaret: selectionInteger pos: posInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELECTIONNCARET
				wParam: selectionInteger
				lParam: posInteger]!

sciSetSelectionNCaretVirtualSpace: selectionInteger space: spaceInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELECTIONNCARETVIRTUALSPACE
				wParam: selectionInteger
				lParam: spaceInteger]!

sciSetSelectionNEnd: selectionInteger pos: posInteger 
	"Private - Sets the position that ends the selection - this becomes the currentPosition."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELECTIONNEND
				wParam: selectionInteger
				lParam: posInteger]!

sciSetSelectionNStart: selectionInteger pos: posInteger 
	"Private - Sets the position that starts the selection - this becomes the anchor."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELECTIONNSTART
				wParam: selectionInteger
				lParam: posInteger]!

sciSetSelFore: useSettingBoolean fore: foreRGB 
	"Private - Set the foreground colour of the main and additional selections and whether to
	use this setting."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELFORE
				wParam: useSettingBoolean asParameter
				lParam: foreRGB asParameter]!

sciSetStyleBits: bitsInteger 
	"Private - Divide each styling byte into lexical class bits (default: 5) and indicator bits
	(default: 3). If a lexer requires more than 32 lexical states, then this is used to expand
	the possible states."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSTYLEBITS
				wParam: bitsInteger
				lParam: 0]!

sciSetStylingEx: lengthInteger styles: stylesString 
	"Private - Set the styles for a segment of the document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSTYLINGEX
				wParam: lengthInteger
				lpParam: stylesString]!

sciSetTargetRange: startInteger end: endInteger 
	"Private - Sets both the start and end of the target in one call."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETTARGETRANGE
				wParam: startInteger
				lParam: endInteger]!

sciSetTechnology: technologyInteger 
	"Private - Set the technology used."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETTECHNOLOGY
				wParam: technologyInteger
				lParam: 0]!

sciSetText: textString 
	"Private - Replace the contents of the document with the argument text."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETTEXT
				wParam: 0
				lpParam: textString]!

sciSetViewWS: viewWSInteger 
	"Private - Make white space characters invisible, always visible or visible outside
	indentation."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETVIEWWS
				wParam: viewWSInteger
				lParam: 0]!

sciSetVirtualSpaceOptions: virtualSpaceOptionsInteger 
	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETVIRTUALSPACEOPTIONS
				wParam: virtualSpaceOptionsInteger
				lParam: 0]!

sciSetVisiblePolicy: visiblePolicyInteger visibleSlop: visibleSlopInteger 
	"Private - Set the way the display area is determined when a particular line is to be moved
	to by Find, FindNext, GotoLine, etc."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETVISIBLEPOLICY
				wParam: visiblePolicyInteger
				lParam: visibleSlopInteger]!

sciSetWhitespaceBack: useSettingBoolean back: backRGB 
	"Private - Set the background colour of all whitespace and whether to use this setting."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWHITESPACEBACK
				wParam: useSettingBoolean asParameter
				lParam: backRGB asParameter]!

sciSetWhitespaceChars: charactersString 
	"Private - Set the set of characters making up whitespace for when moving or selecting by
	word. Should be called after SetWordChars."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWHITESPACECHARS
				wParam: 0
				lpParam: charactersString]!

sciSetWhitespaceFore: useSettingBoolean fore: foreRGB 
	"Private - Set the foreground colour of all whitespace and whether to use this setting."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWHITESPACEFORE
				wParam: useSettingBoolean asParameter
				lParam: foreRGB asParameter]!

sciSetWordChars: charactersString 
	"Private - Set the set of characters making up words for when moving or selecting by word.
	First sets defaults like SetCharsDefault."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWORDCHARS
				wParam: 0
				lpParam: charactersString]!

sciSetWrapIndentMode: modeInteger 
	"Private - Sets how wrapped sublines are placed. Default is fixed."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWRAPINDENTMODE
				wParam: modeInteger
				lParam: 0]!

sciSetWrapMode: modeInteger 
	"Private - Sets whether text is word wrapped."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWRAPMODE
				wParam: modeInteger
				lParam: 0]!

sciSetWrapVisualFlags: wrapVisualFlagsInteger 
	"Private - Set the display mode of visual flags for wrapped lines."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWRAPVISUALFLAGS
				wParam: wrapVisualFlagsInteger
				lParam: 0]!

sciSetWrapVisualFlagsLocation: wrapVisualFlagsLocationInteger 
	"Private - Set the location of visual flags for wrapped lines."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWRAPVISUALFLAGSLOCATION
				wParam: wrapVisualFlagsLocationInteger
				lParam: 0]!

sciSetXCaretPolicy: caretPolicyInteger caretSlop: caretSlopInteger 
	"Private - Set the way the caret is kept visible when going sideways. The exclusion zone is
	given in pixels."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETXCARETPOLICY
				wParam: caretPolicyInteger
				lParam: caretSlopInteger]!

sciSetYCaretPolicy: caretPolicyInteger caretSlop: caretSlopInteger 
	"Private - Set the way the line the caret is on is kept visible. The exclusion zone is given
	in lines."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETYCARETPOLICY
				wParam: caretPolicyInteger
				lParam: caretSlopInteger]!

sciShowLines: lineStartInteger lineEnd: lineEndInteger 
	"Private - Make a range of lines visible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SHOWLINES
				wParam: lineStartInteger
				lParam: lineEndInteger]!

sciStartStyling: posInteger mask: maskInteger 
	"Private - Set the current styling position to pos and the styling mask to mask. The styling
	mask can be used to protect some bits in each styling byte from modification."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_STARTSTYLING
				wParam: posInteger
				lParam: maskInteger]!

sciStyleClearAll
	"Private - Clear all the styles and make equivalent to the global default style."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_STYLECLEARALL
				wParam: 0
				lParam: 0]!

sciTargetAsUTF8
	"Private - Returns the target converted to UTF8. Return the length in bytes."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_TARGETASUTF8
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_TARGETASUTF8
				wParam: 0
				lpParam: result.
			result]!

sciTextHeight: lineInteger 
	"Private - Retrieve the height of a particular line of text in pixels."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_TEXTHEIGHT
				wParam: lineInteger
				lParam: 0]!

sciTextWidth: styleInteger text: textString 
	"Private - Measure the pixel width of some text in a particular style. NUL terminated text
	argument. Does not handle tab or control characters."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_TEXTWIDTH
				wParam: styleInteger
				lpParam: textString]!

sciToggleCaretSticky
	"Private - Switch between sticky and non-sticky: meant to be bound to a key."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_TOGGLECARETSTICKY
				wParam: 0
				lParam: 0]!

sciToggleFold: lineInteger 
	"Private - Switch a header line between expanded and contracted."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_TOGGLEFOLD
				wParam: lineInteger
				lParam: 0]!

sciUserListShow: listTypeInteger itemList: itemListString 
	"Private - Display a list of strings and send notification when user chooses one."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_USERLISTSHOW
				wParam: listTypeInteger
				lpParam: itemListString]!

sciVisibleFromDocLine: lineInteger 
	"Private - Find the display line of a document line taking hidden lines into account."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_VISIBLEFROMDOCLINE
				wParam: lineInteger
				lParam: 0]!

sciWordEndPosition: posInteger onlyWordCharacters: onlyWordCharactersBoolean 
	"Private - Get position of end of word."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDENDPOSITION
				wParam: posInteger
				lParam: onlyWordCharactersBoolean asParameter]!

sciWordStartPosition: posInteger onlyWordCharacters: onlyWordCharactersBoolean 
	"Private - Get position of start of word."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WORDSTARTPOSITION
				wParam: posInteger
				lParam: onlyWordCharactersBoolean asParameter]!

sciWrapCount: lineInteger 
	"Private - The number of display lines needed to wrap a document line"

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_WRAPCOUNT
				wParam: lineInteger
				lParam: 0]!

scnAutoCCancelled: pSCNotification 
	"Private - Default handler for an SCN_AUTOCCANCELLED event.
	No fields of the notification structure are set, so we ignore it."

	self presenter trigger: #autoCompleteCancelled.
	^0!

scnAutoCCharDeleted: pSCNotification 
	"Private - Default handler for an SCN_AUTOCCHARDELETED event.
	The following fields of the notification structure are set:
		"

	^nil!

scnAutoCCompleted: pSCNotification 
	"Private - Default handler for an SCN_AUTOCCOMPLETED event.
	The following fields of the notification structure are set:
		text
		position
		ch
		listCompletionMethod"

	^nil!

scnAutoCSelection: pSCNotification 
	| accept struct |
	accept := true asValue.
	struct := SCNotification fromAddress: pSCNotification.
	self presenter trigger: #autoComplete:startingAt:accept:
		withArguments: (Array 
				with: struct text
				with: struct scPosition + 1
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
	'position' 'modifiers' and 'line' fields of the notification structure are set."

	"Implementation Note: This notification is ignored since it is redundant."

	^0!

scnDwellEnd: pSCNotification 
	"Private - Respond to an SCN_DWELLEND notification. The 'position' , 'x' and 'y' fields of
	the notification structure are set.
	From the Scintilla docs:
		' ...generated after a SCN_DWELLSTART and the mouse is moved or other activity 
		such as key press indicates the dwell is over.'
	"

	| scn |
	scn := SCNotification fromAddress: pSCNotification.
	self presenter trigger: #hoverEnd: with: scn point.
	^0!

scnDwellStart: pSCNotification 
	"Private - Respond to an SCN_DWELLSTART notification. The 'position' , 'x' and 'y' fields of
	the notification structure are set.
	From the Scintilla docs:
		'...generated when the user hold the mouse still in one spot for the dwell period.'
	"

	| scn |
	scn := SCNotification fromAddress: pSCNotification.
	self presenter trigger: #hoverStart: with: scn point.
	^0!

scnFocusIn: pSCNotification 
	"Private - Default handler for an SCN_FOCUSIN event.
	The following fields of the notification structure are set:
		"

	^nil!

scnFocusOut: pSCNotification 
	"Private - Default handler for an SCN_FOCUSOUT event.
	The following fields of the notification structure are set:
		"

	^nil!

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
	"Private - Respond to SCN_UPDATEUI notification. The 'updated' field of notification structure is set.

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINESCROLLDOWN
				wParam: 0
				lParam: 0]!

scrollToEnd
	"Scroll to end of document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SCROLLTOEND
				wParam: 0
				lParam: 0]!

scrollToStart
	"Scroll to start of document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SCROLLTOSTART
				wParam: 0
				lParam: 0]!

scrollUp
	"Scroll the document up, keeping the caret visible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINESCROLLUP
				wParam: 0
				lParam: 0]!

scrollWidth
	"Retrieve the document width assumed for scrolling."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSCROLLWIDTH
				wParam: 0
				lParam: 0]!

scrollWidth: pixelWidthInteger 
	"Sets the document width assumed for scrolling."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSCROLLWIDTH
				wParam: pixelWidthInteger
				lParam: 0]!

secondaryCaretForecolor
	"Get the foreground colour of additional carets."

	^this isNil 
		ifTrue: [nil]
		ifFalse: 
			[RGB fromInteger: (ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETADDITIONALCARETFORE
						wParam: 0
						lParam: 0)]!

secondaryCaretForecolor: foreRGB 
	"Set the foreground colour of the secondary carets."

	self sciSetAdditionalCaretFore: (foreRGB ifNil: [Color darkGray]) asRGB!

secondarySelectionAlpha
	"Get the alpha of the selection."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETADDITIONALSELALPHA
				wParam: 0
				lParam: 0]!

secondarySelectionAlpha: alphaInteger 
	"Set the alpha of the selection."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETADDITIONALSELALPHA
				wParam: alphaInteger
				lParam: 0]!

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
	"Retrieve the selected text. Return the length of the text. Result is NUL-terminated."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETSELTEXT
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len - 1.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELTEXT
				wParam: 0
				lpParam: result.
			result]!

selectionAlpha
	"Get the alpha of the selection."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELALPHA
				wParam: 0
				lParam: 0]!

selectionAlpha: alphaInteger 
	"Set the alpha of the selection."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSELALPHA
				wParam: alphaInteger
				lParam: 0]!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSELECTIONS
				wParam: 0
				lParam: 0]!

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

	^this 
		ifNil: [0]
		ifNotNil: 
			[ScintillaLibrary default 
				directFunction: this
				msg: anInteger
				wParam: 0
				lParam: 0]!

sendMessage: msgInteger wParam: wParamInteger 
	"Private - Send the Win32 message msgInteger to the receiver's real window with the
	specified wParam, and lParam set to 0."

	"Implementation Note: Override to ensure goes through direct call mechanism."

	^this 
		ifNil: [0]
		ifNotNil: 
			[ScintillaLibrary default 
				directFunction: this
				msg: msgInteger
				wParam: wParamInteger
				lParam: 0]!

sendMessage: anIntegerMessageID wParam: wParam lParam: lParam 
	"Private - Send the specified Win32 <integer> message to the receiver with the specified
	32-bit <integer> wParam and lParam parameters."

	"Implementation Note: Use the direct pointer mechanism provided by Scintilla, which allows
	us to bypass the Windows message queue altogether for best performance. This does mean,
	however, that no callback into Dolphin will result. Also we must be careful not to call
	through a null pointer or we will get a GPF."

	^this 
		ifNil: [0]
		ifNotNil: 
			[ScintillaLibrary default 
				directFunction: this
				msg: anIntegerMessageID
				wParam: wParam
				lParam: lParam]!

sendMessage: anIntegerMessageID wParam: wParam lpParam: lpParam 
	"Private - Send the Win32 message anIntegerMessageID with parameters wParam and lpParam
	(pointer) to the receiver's Window."

	"Implementation Note: Use the direct pointer mechanism provided by Scintilla, which allows
	us to bypass the Windows message queue altogether for best performance. This does mean,
	however, that no callback into Dolphin will result. Also we must be careful not to call
	through a null pointer or we will get a GPF."

	^this 
		ifNotNil: 
			[ScintillaLibrary default 
				directFunction: this
				msg: anIntegerMessageID
				wParam: wParam
				lpParam: lpParam yourAddress]!

setCallTipHighlightColor
	self sciCallTipSetForeHlt: callTipHighlightColor asRGB!

setCallTipTabWidth
	self sciCallTipUseStyle: callTipTabWidth!

setCharacterClasses
	"Private - Configure the control with current character class settings. 
	Setting word chars causes Scintilla to reset other character classes to defaults, so 
	we have to set all these immediately after setting the word characters."

	wordChars ifNil: [self sciSetCharsDefault] ifNotNil: [self sciSetWordChars: wordChars].
	"Whitepace and punctutation character classes will have been reset to defaults."
	whitespaces ifNotNil: [self sciSetWhitespaceChars: whitespaces].
	punctuation ifNotNil: [self sciSetPunctuationChars: punctuation]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETREADONLY
				wParam: readOnlyBoolean asParameter
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_TARGETFROMSELECTION
				wParam: 0
				lParam: 0]!

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

setWhitespaceForecolor
	whitespaceForecolor 
		ifTrue: [self sciSetWhitespaceFore: false fore: nil]
		ifFalse: [self sciSetWhitespaceFore: true fore: whitespaceForecolor asRGB]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETVSCROLLBAR
				wParam: showBoolean asParameter
				lParam: 0]!

splitTarget: pixelWidthInteger 
	"Split the lines in the target into lines that are less wide than pixelWidth where
	possible."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINESSPLIT
				wParam: pixelWidthInteger
				lParam: 0]!

startDwellTimer
	self setTimer: 1 interval: 100!

startRecording
	"Start notifying the container of all key presses and commands."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_STARTRECORD
				wParam: 0
				lParam: 0]!

startStylingFrom: anInteger 
	"Set the current styling position to the one-based <integer> index argument."

	self sciStartStyling: anInteger - 1 mask: self restyleMask!

state
	"Private - Answer a <MessageSequence> which, when replayed, will restore the receiver 
	to its current state"

	"Implementation Note: Each attributes has a 3-element array, respectively the set selector,
	get selector, and default value. State is only saved for an attribute if the current value
	differs from the default. By convention the low-level Scintilla get/set operations are used
	for efficiency, and to make it easier to relate the default value to the documentation.

	The markers must be stored as part of the state, even though stored in an instance variable,
	as these are reset when the text is restored."

	| answer |
	answer := super state.
	#(#(#modificationEventMask: #modificationEventMask ##(SC_MODEVENTMASKALL)) #(#isDrawingBuffered: #isDrawingBuffered true) #(#hoverTime: #hoverTime 10000000) #(#setIndicators: #indicators #()) #(#sciSetCaretStyle: #sciGetCaretStyle ##(CARETSTYLE_LINE)) #(#caretForecolor: #caretForecolor ##(Color 
		black asRGB)) #(#secondaryCaretForecolor: #secondaryCaretForecolor ##(Color darkGray asRGB)) #(#currentLineAlpha: #currentLineAlpha ##(SC_ALPHA_NOALPHA)) #(#caretPeriod: #caretPeriod 500) #(#caretWidth: #caretWidth 1) #(#sciSetCaretSticky: #sciGetCaretSticky ##(SC_CARETSTICKY_OFF)) #(#isCurrentLineHighlighted: #isCurrentLineHighlighted false) #(#currentLineBackcolor: #currentLineBackcolor ##(Color 
		yellow asRGB)) #(#sciSetEOLMode: #sciGetEOLMode ##(SC_EOL_CRLF)) #(#hasVisibleLineEndings: #hasVisibleLineEndings false) #(#wordWrap: #wordWrap false) #(#sciSetLayoutCache: #sciGetLayoutCache ##(SC_CACHE_CARET)) #(#margins: #margins #()) #(#markers: #markers ##(OrderedCollection 
		new)) #(#isOvertypeEnabled: #isOvertypeEnabled false) #(#printMagnification: #printMagnification 0) #(#printColourMode: #printColourMode ##(SC_PRINT_NORMAL)) #(#canHScroll: #canHScroll true) #(#canScrollPastEnd: #canScrollPastEnd true) #(#scrollWidth: #scrollWidth 2000) #(#xOffset: #xOffset 0) #(#sciSetSelectionMode: #sciGetSelectionMode ##(SC_SEL_STREAM)) #(#backspaceUnindents: #backspaceUnindents false) #(#sciSetIndentationGuides: #sciGetIndentationGuides ##(SC_IV_NONE)) #(#indentation: #indentation 0) #(#tabIndents: #tabIndents false) #(#tabWidth: #tabWidth 8) #(#isUsingTabs: #isUsingTabs true) #(#targetRange: #targetRange ##(1 
		to: 0)) #(#sciSetViewWS: #sciGetViewWS ##(SCWS_INVISIBLE)) #(#autoCompletionSeparator: #autoCompletionSeparator $ ) #(#autoCompletionImageIdSeparator: #autoCompletionImageIdSeparator $?) #(#isAutoCompletionCancelledAtStart: #isAutoCompletionCancelledAtStart true) #(#isAutoCompletionCaseInsensitive: #isAutoCompletionCaseInsensitive false) #(#isAutoCompletionCancelledWhenNoMatch: #isAutoCompletionCancelledWhenNoMatch true) #(#isAutoCompletionTruncating: #isAutoCompletionTruncating false) #(#maxCompletionListHeight: #maxCompletionListHeight 5) #(#maxCompletionListWidth: #maxCompletionListWidth 0) #(#sciSetCodePage: #sciGetCodePage 0) #(#sciSetEdgeMode: #sciGetEdgeMode ##(EDGE_NONE)) #(#edgeColor: #edgeColor ##(Color 
		gray asRGB)) #(#zoomLevel: #zoomLevel 0) #(#setLexerLanguage: #lexer #container) #(#controlCharacter: #controlCharacter nil) #(#selectionAlpha: #selectionAlpha ##(SC_ALPHA_NOALPHA)) #(#secondarySelectionAlpha: #secondarySelectionAlpha ##(SC_ALPHA_NOALPHA)) #(#positionCacheSize: #positionCacheSize 1024) #(#activeHotspotBackcolor: #activeHotspotBackcolor ##(Color 
		white asRGB)) #(#activeHotspotForecolor: #activeHotspotForecolor ##(Color blue asRGB)) #(#areHotspotsSingleLine: #areHotspotsSingleLine true) #(#sciAnnotationSetVisible: #sciAnnotationGetVisible ##(ANNOTATION_HIDDEN)) #(#setRawAnnotations: #getRawAnnotations ##(OrderedCollection 
		new)) #(#extraAscent: #extraAscent 0) #(#extraDescent: #extraDescent 0) #(#areAdditionalCaretsVisible: #areAdditionalCaretsVisible false) #(#sciSetFontQuality: #sciGetFontQuality ##(SC_EFF_QUALITY_DEFAULT)) #(#whitespaceMarkerSize: #whitespaceMarkerSize 1) #(#sciSetMultiPaste: #sciGetMultiPaste ##(SC_MULTIPASTE_ONCE)) #(#sciSetIMEInteraction: #sciGetIMEInteraction ##(SC_IME_WINDOWED)) #(#sciAutoCSetOrder: #sciAutoCGetOrder ##(SC_ORDER_PRESORTED)) #(#sciSetPhasesDraw: #sciGetPhasesDraw ##(SC_PHASES_TWO))) 
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

stopDwellTimer
	self killTimer: 1!

stopRecording
	"Stop notifying the container of all key presses and commands."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_STOPRECORD
				wParam: 0
				lParam: 0]!

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
	"Inlined to minimize overhead when scanning text for the start of a style."

	^this 
		ifNil: [0]
		ifNotNil: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETSTYLEAT
				wParam: anInteger - 1
				lParam: 0]!

styleNamed: aSymbol 
	"Answer a <ScintillaTextStyle> being the named style, or nil if the name is not recognised."

	^currentTextStyles at: aSymbol ifAbsent: []!

styleNext: lengthInteger mask: styleInteger 
	"Change style from current styling position for length characters to a style and move the
	current styling position to after this newly styled segment."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETSTYLING
				wParam: lengthInteger
				lParam: styleInteger]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SWAPMAINANCHORCARET
				wParam: 0
				lParam: 0]!

tabIndents
	"Does a tab pressed when caret is within indentation indent?"

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTABINDENTS
				wParam: 0
				lParam: 0) asBoolean]!

tabIndents: tabIndentsBoolean 
	"Sets whether a tab pressed when caret is within indentation indents."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETTABINDENTS
				wParam: tabIndentsBoolean asParameter
				lParam: 0]!

tabWidth
	"Retrieve the visible size of a tab."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTABWIDTH
				wParam: 0
				lParam: 0]!

tabWidth: tabWidthInteger 
	"Change the visible size of a tab to be a multiple of the width of a space character."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETTABWIDTH
				wParam: tabWidthInteger
				lParam: 0]!

targetAll
	"Sets the target to the whole document."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_TARGETWHOLEDOCUMENT
				wParam: 0
				lParam: 0]!

targetRange
	"Answer the range of the current search/replace target. The target is like the selection,
	but not visible."

	^self sciGetTargetStart + 1 to: self sciGetTargetEnd!

targetRange: anInterval 
	"Set the range of the current search/replace target. The target is like the selection, but
	not visible."

	self sciSetTargetRange: anInterval start - 1 end: anInterval stop!

targetText
	"Retrieve the text in the target."

	| len |
	len := this 
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default 
						directFunction: this
						msg: SCI_GETTARGETTEXT
						wParam: 0
						lpParam: nil].
	^len = 0 
		ifTrue: ['']
		ifFalse: 
			[| result |
			result := String newFixed: len.
			ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTARGETTEXT
				wParam: 0
				lpParam: result.
			result]!

textAtLine: anInteger 
	"Private - Answer the text of a line at the given line index (1-based)."

	"Implementation Note: The result will include any line terminators, which we should probably
	strip off here."

	anInteger <= 0 ifTrue: [^self errorSubscriptBounds: anInteger].
	^self sciGetLine: anInteger - 1!

textLength
	"Retrieve the number of characters in the document."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETTEXTLENGTH
				wParam: 0
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_EDITTOGGLEOVERTYPE
				wParam: 0
				lParam: 0]!

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

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_LINETRANSPOSE
				wParam: 0
				lParam: 0]!

undo
	"Undo one action in the undo history."

	self cancelModes.
	self basicUndo!

unindent
	"Dedent the selected lines."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_BACKTAB
				wParam: 0
				lParam: 0]!

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

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETWHITESPACESIZE
				wParam: 0
				lParam: 0]!

whitespaceMarkerSize: sizeInteger 
	"Set the size of the dots used to mark space characters."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETWHITESPACESIZE
				wParam: sizeInteger
				lParam: 0]!

whitespaces
	^whitespaces ifNil: [self sciGetWhitespaceChars]!

whitespaces: aStringOrNil 
	whitespaces := aStringOrNil.
	whitespaces ifNil: [self setCharacterClasses] ifNotNil: [self sciSetWhitespaceChars: whitespaces]!

whitespaceVisibility
	"Answer a <Symbol> naming the level of whitespace marking currently configured in the receiver."

	^self class whitespaceVisibilityLevels at: self sciGetViewWS + 1!

whitespaceVisibility: aSymbol 
	"Make white space characters invisible, always visible or visible outside indentation
	depending on the <Symbol> argument (one of #invisible, #visibleAlways or
	#visibleAfterIndent, respectively)."

	self sciSetViewWS: (self class whitespaceVisibilityLevels indexOf: aSymbol) - 1!

widthOfText: aString inStyle: aSymbol 
	"Answer the <integer> pixel width that would be needed to display the text in the <String>
	argument in the text style named by the <Symbol> argument."

	^self sciTextWidth: ((self styleNamed: aSymbol) ifNil: [0] ifNotNil: [:style | style id])
		text: aString!

willCaptureMouse
	"Get whether mouse gets captured."

	^this isNil 
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETMOUSEDOWNCAPTURES
				wParam: 0
				lParam: 0) asBoolean]!

willCaptureMouse: capturesBoolean 
	"Set whether the mouse is captured when its button is pressed."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETMOUSEDOWNCAPTURES
				wParam: capturesBoolean asParameter
				lParam: 0]!

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
	"Answer a <String> containing the set of characters considered to be those valid as
	characters in a single word. All other characters are considered to be delimiters. This
	setting controls word-oriented cursor movements and selections."

	^wordChars ifNil: [self sciGetWordChars]!

wordChars: aStringOrNil 
	"Set the set of characters considered to be those valid as characters in a single word. All
	other characters are considered to be delimiters. This setting controls word-oriented cursor
	movements and selections. If the argument is nil, then the word characters are restored to
	the default Scintilla setting (see #defaultWordChars)."

	wordChars := aStringOrNil.
	self setCharacterClasses!

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

	^self class wrapIndentModes at: self sciGetWrapIndentMode + 1 ifAbsent: [#fixed]!

wrapIndentMode: aSymbol 
	self sciSetWrapIndentMode: (self class wrapIndentModes keyAtValue: aSymbol) - 1!

xOffset
	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETXOFFSET
				wParam: 0
				lParam: 0]!

xOffset: newOffsetInteger 
	"Get and Set the xOffset (ie, horizontal scroll position)."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETXOFFSET
				wParam: newOffsetInteger
				lParam: 0]!

zoomIn
	"Magnify the displayed text by increasing the sizes by 1 point."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ZOOMIN
				wParam: 0
				lParam: 0]!

zoomLevel
	"Retrieve the zoom level."

	^this isNil 
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_GETZOOM
				wParam: 0
				lParam: 0]!

zoomLevel: zoomInteger 
	"Set the zoom level. This number of points is added to the size of all fonts. It may be
	positive to magnify or negative to reduce."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_SETZOOM
				wParam: zoomInteger
				lParam: 0]!

zoomOut
	"Make the displayed text smaller by decreasing the sizes by 1 point."

	this isNil 
		ifFalse: 
			[ScintillaLibrary default 
				directFunction: this
				msg: SCI_ZOOMOUT
				wParam: 0
				lParam: 0]! !
!ScintillaView categoriesFor: #acceptAutoCompletion!**auto generated**!autocompletion!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #activeHotspotBackcolor!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #activeHotspotBackcolor:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #activeHotspotForecolor!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #activeHotspotForecolor:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #addAnnotation:!adding!annotations!public! !
!ScintillaView categoriesFor: #addKeyBinding:!key bindings!public! !
!ScintillaView categoriesFor: #addMarker:!markers!public! !
!ScintillaView categoriesFor: #addMarkerType:at:!markers!public! !
!ScintillaView categoriesFor: #addSelectionRange:!public!selection! !
!ScintillaView categoriesFor: #anchorPosition!accessing!public!selection! !
!ScintillaView categoriesFor: #anchorPosition:!accessing!public!selection! !
!ScintillaView categoriesFor: #annotateLine:withAll:!annotations!public! !
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
!ScintillaView categoriesFor: #areAllLinesVisible!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #areHotspotsSingleLine!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #areHotspotsSingleLine:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionAcceptChars!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionAcceptChars:!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionCancelChars!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionCancelChars:!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionCurrentText!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionImageIdSeparator!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionImageIdSeparator:!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionListPosition!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionSeparator!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionSeparator:!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionSortMode!accessing!autocompletion!public! !
!ScintillaView categoriesFor: #autoCompletionSortMode:!accessing!autocompletion!public! !
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
!ScintillaView categoriesFor: #callTipPosition:!accessing!call tips!public!scintilla interface! !
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
!ScintillaView categoriesFor: #caretPosition:!accessing!caret!public!selection! !
!ScintillaView categoriesFor: #caretScreenCoordinates!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
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
!ScintillaView categoriesFor: #clearRange:!public!text retrieval & modification! !
!ScintillaView categoriesFor: #codePage!accessing!public! !
!ScintillaView categoriesFor: #codePage:!accessing!public! !
!ScintillaView categoriesFor: #columnFromPosition:!enquiries!public! !
!ScintillaView categoriesFor: #controlCharacter!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #controlCharacter:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #convertToLowercase!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #convertToUppercase!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #copyLine!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #copyRange:!clipboard operations!public! !
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
!ScintillaView categoriesFor: #currentLineText!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #cutLine!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #cutSelection!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #decodeStyledText:!accessing!private!text retrieval & modification! !
!ScintillaView categoriesFor: #defaultBraceChars!brace highlighting!constants!private! !
!ScintillaView categoriesFor: #defaultKeyBindings!helpers!key bindings!private! !
!ScintillaView categoriesFor: #defaultMarkerDefinitions!constants!markers!private! !
!ScintillaView categoriesFor: #defaultModEventMask!constants!private! !
!ScintillaView categoriesFor: #defaultTextStylesFor:!constants!public!style definition! !
!ScintillaView categoriesFor: #defaultWhitespaceChars!constants!public! !
!ScintillaView categoriesFor: #defaultWindowStyle!constants!private! !
!ScintillaView categoriesFor: #deleteLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteMarkers:!**auto generated**!markers!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToEndOfLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToEndOfWord!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToNextWord!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToStartOfLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #deleteToStartOfWord!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #describeKeywordSets!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #destroyAutoCompletionListImages!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #directPointer!accessing!private! !
!ScintillaView categoriesFor: #drawingPhases!accessing!other settings!public!scintilla interface! !
!ScintillaView categoriesFor: #drawingPhases:!accessing!other settings!public! !
!ScintillaView categoriesFor: #duplicateLine!**auto generated**!accessing!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #duplicateSelection!**auto generated**!accessing!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColor!**auto generated**!accessing!long lines!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColor:!**auto generated**!accessing!long lines!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColumn!accessing!long lines!public! !
!ScintillaView categoriesFor: #edgeColumn:!accessing!long lines!public! !
!ScintillaView categoriesFor: #edgeMode!accessing!long lines!public! !
!ScintillaView categoriesFor: #edgeMode:!accessing!long lines!public! !
!ScintillaView categoriesFor: #editStyles!accessing!commands!public! !
!ScintillaView categoriesFor: #emptyUndoBuffer!**auto generated**!accessing!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #enChange!accessing!event handling-win32!private! !
!ScintillaView categoriesFor: #endOfLineMode!accessing!line endings!public! !
!ScintillaView categoriesFor: #endOfLineMode:!accessing!line endings!public! !
!ScintillaView categoriesFor: #endUndoGroup!**auto generated**!accessing!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #enKillFocus!accessing!event handling-win32!private! !
!ScintillaView categoriesFor: #enSetFocus!accessing!event handling-win32!private! !
!ScintillaView categoriesFor: #ensureCaretVisible!accessing!caret!public! !
!ScintillaView categoriesFor: #ensureHasAnnotationStyles!accessing!annotations!helpers!initializing!private! !
!ScintillaView categoriesFor: #ensureLineVisible:!accessing!public!scrolling! !
!ScintillaView categoriesFor: #ensureRangeVisible:!accessing!public!scrolling! !
!ScintillaView categoriesFor: #ensureVisible:!accessing!public!scrolling! !
!ScintillaView categoriesFor: #enUpdate!accessing!event handling-win32!private! !
!ScintillaView categoriesFor: #errorStatus!**auto generated**!accessing!error handling!public!scintilla interface! !
!ScintillaView categoriesFor: #errorStatus:!**auto generated**!accessing!error handling!public!scintilla interface! !
!ScintillaView categoriesFor: #extendDown!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendLeft!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendPageDown!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendPageUp!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendParaDown!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendParaUp!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleDown!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleLeft!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectanglePageDown!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectanglePageUp!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleRight!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleToEndOfLine!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleToStartOfLine!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleToVcHome!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRectangleUp!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendRight!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendStutteredPageDown!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendStutteredPageUp!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfDisplayLine!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfDocument!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfLine!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfNextWord!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfPreviousWord!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfWord!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfWordPart!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToEndOfWrappedLine!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfDisplayLine!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfDocument!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfLine!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfVcDisplayLine!**auto generated**!accessing!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #extendToStartOfWord!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfWordPart!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfWrappedLine!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToVcHome!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToWrappedVcHome!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendUp!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extraAscent!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #extraAscent:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #extraDescent!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #extraDescent:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #extraStyleBits!accessing!public!style definition! !
!ScintillaView categoriesFor: #extraStyleBits:!accessing!public!style definition! !
!ScintillaView categoriesFor: #extraStyleMask!accessing!private! !
!ScintillaView categoriesFor: #find:range:!accessing!private!searching & replacing! !
!ScintillaView categoriesFor: #find:range:flags:!accessing!public!searching & replacing! !
!ScintillaView categoriesFor: #findAutoCompletionEntry:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #findMatchingBrace:!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #findStyleStart:before:!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #firstVisibleLine:!accessing!public!scrolling! !
!ScintillaView categoriesFor: #foldFlags!accessing!folding!public! !
!ScintillaView categoriesFor: #foldFlags:!accessing!folding!public! !
!ScintillaView categoriesFor: #foldLine:level:!accessing!folding!public!scintilla interface! !
!ScintillaView categoriesFor: #foldMargin!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginColor!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginColor:!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginHiColor!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginHiColor:!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarkerStyle!accessing!folding!markers!public! !
!ScintillaView categoriesFor: #foldMarkerStyle:!accessing!folding!markers!public! !
!ScintillaView categoriesFor: #fontQuality!accessing!other settings!public! !
!ScintillaView categoriesFor: #fontQuality:!accessing!other settings!public! !
!ScintillaView categoriesFor: #forecolor:!accessing!public! !
!ScintillaView categoriesFor: #formatRectangle!accessing!public! !
!ScintillaView categoriesFor: #formFeed!**auto generated**!accessing!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #getDirectPointer!accessing!private! !
!ScintillaView categoriesFor: #getLexerLanguage!accessing!lexer!public! !
!ScintillaView categoriesFor: #getLineState:!accessing!public!styling! !
!ScintillaView categoriesFor: #getRawAnnotation:!accessing!annotations!private! !
!ScintillaView categoriesFor: #getRawAnnotations!accessing!annotations!private! !
!ScintillaView categoriesFor: #goto:!accessing!caret!public! !
!ScintillaView categoriesFor: #gotoLine:!accessing!caret!commands!public! !
!ScintillaView categoriesFor: #handle:!accessing!private! !
!ScintillaView categoriesFor: #hangingIndent!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #hangingIndent:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #hasBlinkingSecondaryCarets!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #hasBlinkingSecondaryCarets:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #hasFoldMargin!accessing!folding!margins!public!testing! !
!ScintillaView categoriesFor: #hasFoldMargin:!accessing!folding!margins!public! !
!ScintillaView categoriesFor: #hasIndentationGuides!accessing!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #hasIndentationGuides:!accessing!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #hasLineNumbers!accessing!public!testing! !
!ScintillaView categoriesFor: #hasLineNumbers:!accessing!commands!margins!public! !
!ScintillaView categoriesFor: #hasVisibleLineEndings!**auto generated**!accessing!line endings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #hasVisibleLineEndings:!**auto generated**!accessing!line endings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #hideExtraIndicators!accessing!helpers!private! !
!ScintillaView categoriesFor: #hideIndicators!accessing!helpers!indicators!private! !
!ScintillaView categoriesFor: #hideSelection:!**auto generated**!accessing!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #highlightBracesAt:and:!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #highlightCallTipFrom:to:!accessing!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #highlightFindMatch:!accessing!private!searching & replacing! !
!ScintillaView categoriesFor: #highlightGuide!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #highlightGuide:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #highlightMismatchedBrace:!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #highlightRange:withIndicator:!accessing!indicators!public! !
!ScintillaView categoriesFor: #hoverTime!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #hoverTime:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #idOfStyleNamed:!accessing!helpers!private! !
!ScintillaView categoriesFor: #imeMode!accessing!ime!public! !
!ScintillaView categoriesFor: #imeMode:!accessing!public! !
!ScintillaView categoriesFor: #indent!**auto generated**!accessing!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #indentation!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentation:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationGuides!accessing!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationGuides:!accessing!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationOfLine:!accessing!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indicatorCount!accessing!constants!indicators!public! !
!ScintillaView categoriesFor: #indicatorDefinitions:!accessing!indicators!public! !
!ScintillaView categoriesFor: #indicatorIdFromName:!accessing!indicators!private! !
!ScintillaView categoriesFor: #indicatorMaskAt:!accessing!indicators!public! !
!ScintillaView categoriesFor: #indicators!accessing!indicators!public! !
!ScintillaView categoriesFor: #indicators:!accessing!indicators!public! !
!ScintillaView categoriesFor: #indicatorsAt:!accessing!public! !
!ScintillaView categoriesFor: #indicatorStyles!accessing!public! !
!ScintillaView categoriesFor: #indicatorStyles:!accessing!public! !
!ScintillaView categoriesFor: #indicatorsUnder:!accessing!event handling!private! !
!ScintillaView categoriesFor: #initialize!accessing!initializing!public! !
!ScintillaView categoriesFor: #initializeControl!accessing!initializing!private! !
!ScintillaView categoriesFor: #insertText:at:!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #insertText:from:!**auto generated**!accessing!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #invalidateStyling!accessing!public!styling! !
!ScintillaView categoriesFor: #isActiveHotspotUnderlined!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isActiveHotspotUnderlined:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionActive!**auto generated**!accessing!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledAtStart!**auto generated**!accessing!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledAtStart:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledWhenNoMatch!**auto generated**!accessing!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledWhenNoMatch:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionCaseInsensitive!**auto generated**!accessing!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCaseInsensitive:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionSingleMatchChosen!**auto generated**!accessing!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionSingleMatchChosen:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionTruncating!**auto generated**!accessing!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionTruncating:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isBackgroundDwellEnabled!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #isBackgroundDwellEnabled:!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #isBraceAt:!accessing!brace highlighting!private!testing! !
!ScintillaView categoriesFor: #isBraceHighlightingEnabled!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #isBraceHighlightingEnabled:!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #isCallTipAboveText:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #isCallTipActive!**auto generated**!accessing!call tips!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isCaretSticky!accessing!caret, selection, and hotspot styles!public!testing! !
!ScintillaView categoriesFor: #isCaretSticky:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #isCurrentLineHighlighted!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isCurrentLineHighlighted:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isCurrentLineHighlightedAlways!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #isCurrentLineHighlightedAlways:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #isCurrentLineMarkedWith:!accessing!markers!public!testing! !
!ScintillaView categoriesFor: #isDrawingBuffered!**auto generated**!accessing!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isDrawingBuffered:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #isDrawingTwoPhase!**auto generated**!accessing!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isDrawingTwoPhase:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #isFoldingEnabled!accessing!folding!public!testing! !
!ScintillaView categoriesFor: #isFoldingEnabled:!accessing!folding!public! !
!ScintillaView categoriesFor: #isIndicator:setAt:!accessing!indicators!public! !
!ScintillaView categoriesFor: #isKeyboardInputUnicode!**auto generated**!accessing!other settings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isKeyboardInputUnicode:!**auto generated**!accessing!other settings!public!scintilla interface! !
!ScintillaView categoriesFor: #isLine:folded:!accessing!folding!public!scintilla interface! !
!ScintillaView categoriesFor: #isLine:markedWith:!accessing!markers!public!testing! !
!ScintillaView categoriesFor: #isLineVisible:!accessing!folding!public!testing! !
!ScintillaView categoriesFor: #isMultiSelect!**auto generated**!accessing!public!scintilla interface!selection!testing! !
!ScintillaView categoriesFor: #isMultiSelect:!**auto generated**!accessing!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #isOvertypeEnabled!**auto generated**!accessing!overtype!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isOvertypeEnabled:!**auto generated**!accessing!overtype!public!scintilla interface! !
!ScintillaView categoriesFor: #isScrollWidthTracking!**auto generated**!accessing!public!scintilla interface!scrolling!testing! !
!ScintillaView categoriesFor: #isScrollWidthTracking:!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #isSelectionBackcolorExtendedToEndOfLine!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isSelectionBackcolorExtendedToEndOfLine:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isSelectionEmpty!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #isSelectionKept!accessing!public!testing! !
!ScintillaView categoriesFor: #isSelectionRectangular!**auto generated**!accessing!public!scintilla interface!selection!testing! !
!ScintillaView categoriesFor: #isStylingEnabled!accessing!public!styling!testing! !
!ScintillaView categoriesFor: #isStylingEnabled:!accessing!public!styling! !
!ScintillaView categoriesFor: #isTextModified!**auto generated**!accessing!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isTextModified:!accessing!modes!private! !
!ScintillaView categoriesFor: #isUndoEnabled!**auto generated**!accessing!public!scintilla interface!testing!undo & redo! !
!ScintillaView categoriesFor: #isUndoEnabled:!**auto generated**!accessing!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #isUsingPalette!**auto generated**!accessing!other settings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isUsingPalette:!**auto generated**!accessing!other settings!public!scintilla interface! !
!ScintillaView categoriesFor: #isUsingTabs!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides!testing! !
!ScintillaView categoriesFor: #isUsingTabs:!**auto generated**!accessing!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #joinTarget!**auto generated**!accessing!commands!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #keyBindings!accessing!key bindings!public! !
!ScintillaView categoriesFor: #keyBindings:!accessing!key bindings!public! !
!ScintillaView categoriesFor: #keyboardCommands!accessing!commands!public! !
!ScintillaView categoriesFor: #lastLineWithState!accessing!public!styling! !
!ScintillaView categoriesFor: #layoutCachingMode!accessing!line wrapping!public! !
!ScintillaView categoriesFor: #layoutCachingMode:!accessing!line wrapping!public! !
!ScintillaView categoriesFor: #lexer!accessing!lexer!public! !
!ScintillaView categoriesFor: #lexer:!accessing!lexer!public! !
!ScintillaView categoriesFor: #lexerLanguage!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #lexerPropertyNames!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #lineCount!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #lineHeight:!accessing!enquiries!public! !
!ScintillaView categoriesFor: #lineLength:!accessing!public! !
!ScintillaView categoriesFor: #lineLengthFromPosition:!accessing!private! !
!ScintillaView categoriesFor: #lineNumberMargin!accessing!margins!public! !
!ScintillaView categoriesFor: #lineRange:!accessing!public! !
!ScintillaView categoriesFor: #lineScroll!accessing!public!scrolling! !
!ScintillaView categoriesFor: #lineScrollBy:!accessing!public!scrolling! !
!ScintillaView categoriesFor: #linesOnScreen!**auto generated**!accessing!enquiries!public!scintilla interface! !
!ScintillaView categoriesFor: #marginCount!accessing!constants!margins!private! !
!ScintillaView categoriesFor: #margins!accessing!margins!public! !
!ScintillaView categoriesFor: #margins:!accessing!margins!public! !
!ScintillaView categoriesFor: #marginStylesOffset!**auto generated**!accessing!margins!public!scintilla interface! !
!ScintillaView categoriesFor: #marginStylesOffset:!**auto generated**!accessing!margins!public!scintilla interface! !
!ScintillaView categoriesFor: #marginWidths!accessing!private! !
!ScintillaView categoriesFor: #markerDefinitions!accessing!markers!public! !
!ScintillaView categoriesFor: #markerDefinitions:!accessing!markers!public! !
!ScintillaView categoriesFor: #markers!accessing!markers!public! !
!ScintillaView categoriesFor: #markers:!accessing!markers!public! !
!ScintillaView categoriesFor: #markerTypesOnLine:!accessing!markers!public! !
!ScintillaView categoriesFor: #maxCompletionListHeight!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListHeight:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListWidth!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListWidth:!**auto generated**!accessing!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxStyle!accessing!constants!public!style definition! !
!ScintillaView categoriesFor: #modificationEventMask!accessing!public! !
!ScintillaView categoriesFor: #modificationEventMask:!accessing!public! !
!ScintillaView categoriesFor: #modifyText:!accessing!private!text retrieval & modification! !
!ScintillaView categoriesFor: #moveCaretInsideView!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveDown!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveLeft!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #movePageDown!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #movePageUp!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveParaDown!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveParaUp!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveRight!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveSelectedLinesDown!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #moveSelectedLinesUp!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #moveStutteredPageDown!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveStutteredPageUp!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfDisplayLine!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfDocument!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfLine!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfNextWord!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfPreviousWord!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfWord!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfWordPart!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToEndOfWrappedLine!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfDisplayLine!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfDocument!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfLine!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfWord!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfWordPart!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToStartOfWrappedLine!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToVcHome!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToVcStartOfDisplayLine!**auto generated**!accessing!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToWrappedVcHome!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveUp!**auto generated**!accessing!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #multiPasteMode!accessing!clipboard operations!public! !
!ScintillaView categoriesFor: #multiPasteMode:!accessing!clipboard operations!public! !
!ScintillaView categoriesFor: #newLine!**auto generated**!accessing!commands!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #nmNotify:!accessing!event handling-win32!private! !
!ScintillaView categoriesFor: #onEraseRequired:!accessing!event handling!public! !
!ScintillaView categoriesFor: #onKillFocus!accessing!event handling!public! !
!ScintillaView categoriesFor: #onSetFocus!accessing!event handling!public! !
!ScintillaView categoriesFor: #onViewCreated!accessing!event handling!public! !
!ScintillaView categoriesFor: #passwordCharacter!accessing!public! !
!ScintillaView categoriesFor: #passwordCharacter:!accessing!public! !
!ScintillaView categoriesFor: #pasteClipboard!**auto generated**!accessing!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #performUndoableAction:!accessing!public!undo & redo! !
!ScintillaView categoriesFor: #plainText!**auto generated**!accessing!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #plainText:!accessing!private!text retrieval & modification! !
!ScintillaView categoriesFor: #plainTextFrom:to:!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #positionCacheSize!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #positionCacheSize:!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #positionOfChar:!accessing!public! !
!ScintillaView categoriesFor: #primarySelectionIndex!accessing!public!selection! !
!ScintillaView categoriesFor: #primarySelectionIndex:!accessing!public!selection! !
!ScintillaView categoriesFor: #printAnnotationStyleBytes:on:!accessing!annotations!helpers!private! !
!ScintillaView categoriesFor: #printColourMode!**auto generated**!accessing!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printColourMode:!**auto generated**!accessing!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printMagnification!**auto generated**!accessing!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printMagnification:!**auto generated**!accessing!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #punctuation!accessing!character classes!public! !
!ScintillaView categoriesFor: #punctuation:!accessing!character classes!public! !
!ScintillaView categoriesFor: #queryCommand:!accessing!commands!private! !
!ScintillaView categoriesFor: #rangeOfIndicator:at:!accessing!indicators!public! !
!ScintillaView categoriesFor: #redo!**auto generated**!accessing!commands!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #rememberCaretX!**auto generated**!accessing!caret!public!scintilla interface! !
!ScintillaView categoriesFor: #removeAllAnnotations!accessing!annotations!public!removing! !
!ScintillaView categoriesFor: #removeAllMarkers!accessing!markers!public! !
!ScintillaView categoriesFor: #removeAllStyling!**auto generated**!accessing!public!scintilla interface!styling! !
!ScintillaView categoriesFor: #removeAnnotation:!accessing!annotations!public!removing! !
!ScintillaView categoriesFor: #removeAnnotationsForLine:!accessing!annotations!public!removing! !
!ScintillaView categoriesFor: #removeBraceHighlight!accessing!brace highlighting!public! !
!ScintillaView categoriesFor: #removeKeyBinding:!accessing!key bindings!public! !
!ScintillaView categoriesFor: #removeMarker:!accessing!markers!public! !
!ScintillaView categoriesFor: #removeMarkersOfType:!accessing!markers!public! !
!ScintillaView categoriesFor: #removeSelections!**auto generated**!accessing!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #removeStylingFrom:to:!accessing!public!styling! !
!ScintillaView categoriesFor: #replaceTarget:!accessing!public!searching & replacing! !
!ScintillaView categoriesFor: #requiredLineMarginWidth!accessing!helpers!margins!private! !
!ScintillaView categoriesFor: #resetMarkers!accessing!helpers!markers!private! !
!ScintillaView categoriesFor: #resetZoom!accessing!commands!public!zooming! !
!ScintillaView categoriesFor: #restyleAll!accessing!public!styling! !
!ScintillaView categoriesFor: #restyleFrom:to:!accessing!public!styling! !
!ScintillaView categoriesFor: #restyleMask!accessing!constants!private!styling! !
!ScintillaView categoriesFor: #rotateSelection!**auto generated**!accessing!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciAddRefDocument:!**auto generated**!accessing!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAddSelection:anchor:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciAddStyledText:c:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAddTabStop:x:!**auto generated**!accessing!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciAddUndoAction:flags:!**auto generated**!accessing!private!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #sciAllocate:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAllocateExtendedStyles:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAllocateSubStyles:numberStyles:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetLines:!**auto generated**!accessing!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetStyles:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetText:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetVisible!**auto generated**!accessing!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetStyles:styles:!**auto generated**!accessing!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetText:text:!**auto generated**!accessing!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetVisible:!**auto generated**!accessing!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAppendText:text:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAssignCmdKey:msg:!**auto generated**!accessing!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetCaseInsensitiveBehaviour!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetCurrent!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetMulti!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetOrder!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetSeparator!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetTypeSeparator!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCPosStart!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetCaseInsensitiveBehaviour:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetFillUps:!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetMulti:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetOrder:!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetSeparator:!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetTypeSeparator:!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCShow:itemList:!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCStops:!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceBadLight:!**auto generated**!accessing!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceBadLightIndicator:indicator:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceHighlight:pos2:!**auto generated**!accessing!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceHighlightIndicator:indicator:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceMatch:!**auto generated**!accessing!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipPosStart!**auto generated**!accessing!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetBack:!**auto generated**!accessing!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetFore:!**auto generated**!accessing!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetForeHlt:!**auto generated**!accessing!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetHlt:end:!**auto generated**!accessing!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetPosStart:!**auto generated**!accessing!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipShow:definition:!**auto generated**!accessing!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipUseStyle:!**auto generated**!accessing!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCanPaste!**auto generated**!accessing!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciChangeInsertion:text:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciChangeLexerState:end:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCharPositionFromPoint:y:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCharPositionFromPointClose:y:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearAllCmdKeys!**auto generated**!accessing!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearCmdKey:!**auto generated**!accessing!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearRepresentation:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearTabStops:!**auto generated**!accessing!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciColourise:end:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciContractedFoldNext:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciConvertEOLs:!**auto generated**!accessing!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCopyRange:end:!**auto generated**!accessing!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCountCharacters:endPos:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCreateDocument!**auto generated**!accessing!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDeleteRange:deleteLength:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDescribeProperty:description:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDistanceToSecondaryStyles!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDocLineFromVisible:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDropSelectionN:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciEncodedFromUTF8:encoded:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciEnsureVisible:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciEnsureVisibleEnforcePolicy:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciExpandChildren:level:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFindColumn:column:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciFindIndicatorFlash:end:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFindIndicatorHide!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFindIndicatorShow:end:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFindText:ft:!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciFoldAll:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFoldChildren:action:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFoldLine:action:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFormatRange:fr:!**auto generated**!accessing!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFreeSubStyles!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetAdditionalSelectionTyping!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetAnchor!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetAutomaticFold!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCaretSticky!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCaretStyle!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCharAt:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCodePage!**auto generated**!accessing!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetColumn:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetControlCharSymbol!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCurrentPos!**auto generated**!accessing!caret!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetDocPointer!**auto generated**!accessing!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEdgeColumn!**auto generated**!accessing!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEdgeMode!**auto generated**!accessing!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEndAtLastLine!**auto generated**!accessing!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciGetEndStyled!**auto generated**!accessing!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetEOLMode!**auto generated**!accessing!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFirstVisibleLine!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFoldExpanded:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFoldLevel:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFoldParent:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFontQuality!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetIdleStyling!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetIMEInteraction!**auto generated**!accessing!ime!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetIndentationGuides!**auto generated**!accessing!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLastChild:level:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLayoutCache!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLexer!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLine:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineEndPosition:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineEndTypesActive!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineEndTypesAllowed!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineEndTypesSupported!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineIndentation:!**auto generated**!accessing!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLineIndentPosition:!**auto generated**!accessing!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLineSelEndPosition:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetLineSelStartPosition:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetLineState:!**auto generated**!accessing!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetLineVisible:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMainSelection!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetMarginLeft!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMarginOptions!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMarginRight!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMaxLineState!**auto generated**!accessing!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetMouseSelectionRectangularSwitch!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMultiPaste!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetNextTabStop:x:!**auto generated**!accessing!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetPasteConvertEndings!**auto generated**!accessing!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPhasesDraw!**auto generated**!accessing!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPrimaryStyleFromStyle:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPrintWrapMode!**auto generated**!accessing!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetProperty:buf:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPropertyExpanded:buf:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPropertyInt:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPunctuationChars!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionAnchor!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionAnchorVirtualSpace!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionCaret!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionCaretVirtualSpace!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRepresentation:representation:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetSearchFlags!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciGetSelectionEnd!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionMode!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNAnchor:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNAnchorVirtualSpace:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNCaret:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNCaretVirtualSpace:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNEnd:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNStart:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionStart!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetStyleBits!**auto generated**!accessing!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciGetStyleBitsNeeded!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetStyledText:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetStyleFromSubStyle:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetSubStyleBases!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetSubStylesLength:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetSubStylesStart:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetTag:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetTargetEnd!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciGetTargetStart!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciGetTechnology!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetTextRange:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetViewWS!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetVirtualSpaceOptions!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWhitespaceChars!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWordChars!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapIndentMode!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapMode!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapVisualFlags!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapVisualFlagsLocation!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGotoLine:!**auto generated**!accessing!caret!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGotoPos:!**auto generated**!accessing!caret!private!scintilla interface! !
!ScintillaView categoriesFor: #sciHideLines:lineEnd:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorAllOnFor:!**auto generated**!accessing!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorClearRange:clearLength:!**auto generated**!accessing!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorEnd:position:!**auto generated**!accessing!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorFillRange:fillLength:!**auto generated**!accessing!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorStart:position:!**auto generated**!accessing!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorValueAt:position:!**auto generated**!accessing!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciInsertText:text:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciIsRangeWord:end:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciLineScroll:lines:!**auto generated**!accessing!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciLoadLexerLibrary:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetStyle:!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetStyles:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetText:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetStyle:style:!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetStyles:styles:!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetText:text:!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginTextClearAll!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerAddSet:set:!**auto generated**!accessing!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerDefinePixmap:pixmap:!**auto generated**!accessing!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerDefineRGBAImage:pixels:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerDeleteHandle:!**auto generated**!accessing!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerEnableHighlight:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerGet:!**auto generated**!accessing!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerLineFromHandle:!**auto generated**!accessing!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerNext:markerMask:!**auto generated**!accessing!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerPrevious:markerMask:!**auto generated**!accessing!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerSetAlpha:alpha:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerSymbolDefined:!**auto generated**!accessing!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMultipleSelectAddEach!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMultipleSelectAddNext!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPointXFromPosition:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPointYFromPosition:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionAfter:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionBefore:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionFromPoint:y:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionFromPointClose:y:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionRelative:relative:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPrivateLexerCall:pointer:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPropertyType:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRegisterImage:xpmData:!**auto generated**!accessing!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRegisterRGBAImage:pixels:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciReleaseAllExtendedStyles!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciReleaseDocument:!**auto generated**!accessing!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciReplaceSel:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciReplaceTarget:text:!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciReplaceTargetRE:text:!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciRGBAImageSetHeight:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRGBAImageSetScale:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRGBAImageSetWidth:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciScrollCaret!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciScrollRange:primary:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSearchAnchor!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchInTarget:text:!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchNext:text:!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchPrev:text:!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSetAdditionalCaretFore:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelBack:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelectionTyping:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelFore:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAnchor:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAutomaticFold:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretFore:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretLineBack:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretSticky:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretStyle:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretWidth:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCharsDefault!**auto generated**!accessing!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCodePage:!**auto generated**!accessing!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetControlCharSymbol:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetDocPointer:!**auto generated**!accessing!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEdgeColumn:!**auto generated**!accessing!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEdgeMode:!**auto generated**!accessing!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEmptySelection:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEOLMode:!**auto generated**!accessing!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFirstVisibleLine:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldExpanded:expanded:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldFlags:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldLevel:level:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldMarginColour:back:!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldMarginHiColour:fore:!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFontQuality:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHotspotActiveBack:back:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHotspotActiveFore:fore:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHScrollBar:!**auto generated**!accessing!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetIdentifiers:identifiers:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetIdleStyling:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetIMEInteraction:!**auto generated**!accessing!ime!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetIndentationGuides:!**auto generated**!accessing!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciSetKeyWords:keyWords:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLayoutCache:!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLengthForEncode:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetLexer:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLexerLanguage:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLineEndTypesAllowed:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLineIndentation:indentSize:!**auto generated**!accessing!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciSetLineState:state:!**auto generated**!accessing!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciSetMainSelection:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetMarginLeft:!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMarginOptions:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMarginRight:!**auto generated**!accessing!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetModEventMask:!**auto generated**!accessing!notifications!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMouseSelectionRectangularSwitch:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMultiPaste:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPasteConvertEndings:!**auto generated**!accessing!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPhasesDraw:!**auto generated**!accessing!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPrintWrapMode:!**auto generated**!accessing!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetProperty:value:!**auto generated**!accessing!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPunctuationChars:!**auto generated**!accessing!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionAnchor:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionAnchorVirtualSpace:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionCaret:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionCaretVirtualSpace:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRepresentation:representation:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSavePoint!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetSearchFlags:!**auto generated**!accessing!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSetSelBack:back:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSelection:anchor:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionMode:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNAnchor:posAnchor:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNAnchorVirtualSpace:space:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNCaret:pos:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNCaretVirtualSpace:space:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNEnd:pos:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNStart:pos:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelFore:fore:!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetStyleBits:!**auto generated**!accessing!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciSetStylingEx:styles:!**auto generated**!accessing!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciSetTargetRange:end:!**auto generated**!accessing!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetTechnology:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetText:!**auto generated**!accessing!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetViewWS:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetVirtualSpaceOptions:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetVisiblePolicy:visibleSlop:!**auto generated**!accessing!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetWhitespaceBack:back:!**auto generated**!accessing!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetWhitespaceChars:!**auto generated**!accessing!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWhitespaceFore:fore:!**auto generated**!accessing!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetWordChars:!**auto generated**!accessing!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapIndentMode:!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapMode:!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapVisualFlags:!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapVisualFlagsLocation:!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetXCaretPolicy:caretSlop:!**auto generated**!accessing!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetYCaretPolicy:caretSlop:!**auto generated**!accessing!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciShowLines:lineEnd:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciStartStyling:mask:!**auto generated**!accessing!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciStyleClearAll!**auto generated**!accessing!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciTargetAsUTF8!**auto generated**!accessing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciTextHeight:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciTextWidth:text:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciToggleCaretSticky!**auto generated**!accessing!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciToggleFold:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciUserListShow:itemList:!**auto generated**!accessing!private!scintilla interface!user lists! !
!ScintillaView categoriesFor: #sciVisibleFromDocLine:!**auto generated**!accessing!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWordEndPosition:onlyWordCharacters:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWordStartPosition:onlyWordCharacters:!**auto generated**!accessing!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWrapCount:!**auto generated**!accessing!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #scnAutoCCancelled:!accessing!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCCharDeleted:!**auto generated**!accessing!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCCompleted:!**auto generated**!accessing!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCSelection:!accessing!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnCallTipClick:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnCharAdded:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDoubleClick:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDwellEnd:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDwellStart:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnFocusIn:!**auto generated**!accessing!event handling-scintilla!private! !
!ScintillaView categoriesFor: #scnFocusOut:!**auto generated**!accessing!event handling-scintilla!private! !
!ScintillaView categoriesFor: #scnHotSpotClick:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnHotSpotDoubleClick:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnHotSpotReleaseClick:!**auto generated**!accessing!event handling-scintilla!private! !
!ScintillaView categoriesFor: #scnIndicatorClick:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnIndicatorRelease:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnKey:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnMacroRecord:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnMarginClick:!accessing!event handling-scintilla!margins!notifications!private! !
!ScintillaView categoriesFor: #scnModified:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnModifyAttemptRO:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnNeedShown:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnPainted:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnSavePointLeft:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnSavePointReached:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnStyleNeeded:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnUpdateUI:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnURIDropped:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnUserListSelection:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnZoom:!accessing!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scrollDown!**auto generated**!accessing!commands!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollToEnd!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #scrollToStart!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #scrollUp!**auto generated**!accessing!commands!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollWidth!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollWidth:!**auto generated**!accessing!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #secondaryCaretForecolor!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondaryCaretForecolor:!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionAlpha!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionAlpha:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionBackcolor!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionBackcolor:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionForecolor!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionForecolor:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selection!**auto generated**!accessing!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #selectionAlpha!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #selectionAlpha:!**auto generated**!accessing!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #selectionBackcolor!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionBackcolor:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionCount!**auto generated**!accessing!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #selectionForecolor!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionForecolor:!accessing!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionMode!accessing!public!selection! !
!ScintillaView categoriesFor: #selectionMode:!accessing!public!selection! !
!ScintillaView categoriesFor: #selectionPlainText:!accessing!private!selection! !
!ScintillaView categoriesFor: #selectionRanges!accessing!public!selection! !
!ScintillaView categoriesFor: #selectionRanges:!accessing!public!selection! !
!ScintillaView categoriesFor: #selections!accessing!public!selection! !
!ScintillaView categoriesFor: #sendMessage:!accessing!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:!accessing!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:lParam:!accessing!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:lpParam:!operations!private! !
!ScintillaView categoriesFor: #setCallTipHighlightColor!call tips!private! !
!ScintillaView categoriesFor: #setCallTipTabWidth!helpers!private! !
!ScintillaView categoriesFor: #setCharacterClasses!character classes!helpers!private! !
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
!ScintillaView categoriesFor: #setIndicatorStyles:!helpers!private! !
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
!ScintillaView categoriesFor: #setWhitespaceForecolor!private!white space! !
!ScintillaView categoriesFor: #showAutoCompletionList:prefixLength:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #showCallTip:at:!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #showUserList:id:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #showVerticalScrollBar:!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #splitTarget:!**auto generated**!commands!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #startDwellTimer!notifications!private! !
!ScintillaView categoriesFor: #startRecording!**auto generated**!macro recording!public!scintilla interface! !
!ScintillaView categoriesFor: #startStylingFrom:!public!styling! !
!ScintillaView categoriesFor: #state!accessing!private! !
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
!ScintillaView categoriesFor: #targetAll!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #targetRange!public!search & replace using target! !
!ScintillaView categoriesFor: #targetRange:!public!search & replace using target! !
!ScintillaView categoriesFor: #targetText!**auto generated**!public!scintilla interface!search & replace using target! !
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
!ScintillaView categoriesFor: #whitespaces!accessing!character classes!public! !
!ScintillaView categoriesFor: #whitespaces:!accessing!character classes!public! !
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
	^#(#hidden #standard #boxed indented)!

autoCompletionSortModes
	^#(#presorted #sort #custom)!

caretStyles
	^#(#invisible #line #block)!

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

defineConstantsPool
	##((Smalltalk at: #ScintillaConstants put: (PoolConstantsDictionary named: #ScintillaConstants))
		at: 'ANNOTATION_BOXED' put: 2;
		at: 'ANNOTATION_HIDDEN' put: 0;
		at: 'ANNOTATION_INDENTED' put: 3;
		at: 'ANNOTATION_STANDARD' put: 1;
		at: 'CARET_EVEN' put: 8;
		at: 'CARET_JUMPS' put: 16;
		at: 'CARET_SLOP' put: 1;
		at: 'CARET_STRICT' put: 4;
		at: 'CARETSTYLE_BLOCK' put: 2;
		at: 'CARETSTYLE_INVISIBLE' put: 0;
		at: 'CARETSTYLE_LINE' put: 1;
		at: 'EDGE_BACKGROUND' put: 2;
		at: 'EDGE_LINE' put: 1;
		at: 'EDGE_NONE' put: 0;
		at: 'INDIC_BOX' put: 6;
		at: 'INDIC_COMPOSITIONTHICK' put: 14;
		at: 'INDIC_COMPOSITIONTHIN' put: 15;
		at: 'INDIC_CONTAINER' put: 8;
		at: 'INDIC_DASH' put: 9;
		at: 'INDIC_DIAGONAL' put: 3;
		at: 'INDIC_DOTBOX' put: 12;
		at: 'INDIC_DOTS' put: 10;
		at: 'INDIC_FULLBOX' put: 16;
		at: 'INDIC_HIDDEN' put: 5;
		at: 'INDIC_IME' put: 32;
		at: 'INDIC_IME_MAX' put: 35;
		at: 'INDIC_MAX' put: 35;
		at: 'INDIC_PLAIN' put: 0;
		at: 'INDIC_ROUNDBOX' put: 7;
		at: 'INDIC_SQUIGGLE' put: 1;
		at: 'INDIC_SQUIGGLELOW' put: 11;
		at: 'INDIC_SQUIGGLEPIXMAP' put: 13;
		at: 'INDIC_STRAIGHTBOX' put: 8;
		at: 'INDIC_STRIKE' put: 4;
		at: 'INDIC_TEXTFORE' put: 17;
		at: 'INDIC_TT' put: 2;
		at: 'INDIC0_MASK' put: 32;
		at: 'INDIC1_MASK' put: 64;
		at: 'INDIC2_MASK' put: 128;
		at: 'INDICS_MASK' put: 224;
		at: 'INVALID_POSITION' put: -1;
		at: 'KEYWORDSET_MAX' put: 8;
		at: 'MARKER_MAX' put: 31;
		at: 'SC_AC_COMMAND' put: 5;
		at: 'SC_AC_DOUBLECLICK' put: 2;
		at: 'SC_AC_FILLUP' put: 1;
		at: 'SC_AC_NEWLINE' put: 4;
		at: 'SC_AC_TAB' put: 3;
		at: 'SC_ALPHA_NOALPHA' put: 256;
		at: 'SC_ALPHA_OPAQUE' put: 255;
		at: 'SC_ALPHA_TRANSPARENT' put: 0;
		at: 'SC_AUTOMATICFOLD_CHANGE' put: 4;
		at: 'SC_AUTOMATICFOLD_CLICK' put: 2;
		at: 'SC_AUTOMATICFOLD_SHOW' put: 1;
		at: 'SC_CACHE_CARET' put: 1;
		at: 'SC_CACHE_DOCUMENT' put: 3;
		at: 'SC_CACHE_NONE' put: 0;
		at: 'SC_CACHE_PAGE' put: 2;
		at: 'SC_CARETSTICKY_OFF' put: 0;
		at: 'SC_CARETSTICKY_ON' put: 1;
		at: 'SC_CARETSTICKY_WHITESPACE' put: 2;
		at: 'SC_CASE_CAMEL' put: 3;
		at: 'SC_CASE_LOWER' put: 2;
		at: 'SC_CASE_MIXED' put: 0;
		at: 'SC_CASE_UPPER' put: 1;
		at: 'SC_CASEINSENSITIVEBEHAVIOUR_IGNORECASE' put: 1;
		at: 'SC_CASEINSENSITIVEBEHAVIOUR_RESPECTCASE' put: 0;
		at: 'SC_CHARSET_8859_15' put: 1000;
		at: 'SC_CHARSET_ANSI' put: 0;
		at: 'SC_CHARSET_ARABIC' put: 178;
		at: 'SC_CHARSET_BALTIC' put: 186;
		at: 'SC_CHARSET_CHINESEBIG5' put: 136;
		at: 'SC_CHARSET_CYRILLIC' put: 1251;
		at: 'SC_CHARSET_DEFAULT' put: 1;
		at: 'SC_CHARSET_EASTEUROPE' put: 238;
		at: 'SC_CHARSET_GB2312' put: 134;
		at: 'SC_CHARSET_GREEK' put: 161;
		at: 'SC_CHARSET_HANGUL' put: 129;
		at: 'SC_CHARSET_HEBREW' put: 177;
		at: 'SC_CHARSET_JOHAB' put: 130;
		at: 'SC_CHARSET_MAC' put: 77;
		at: 'SC_CHARSET_OEM' put: 255;
		at: 'SC_CHARSET_OEM866' put: 866;
		at: 'SC_CHARSET_RUSSIAN' put: 204;
		at: 'SC_CHARSET_SHIFTJIS' put: 128;
		at: 'SC_CHARSET_SYMBOL' put: 2;
		at: 'SC_CHARSET_THAI' put: 222;
		at: 'SC_CHARSET_TURKISH' put: 162;
		at: 'SC_CHARSET_VIETNAMESE' put: 163;
		at: 'SC_CP_DBCS' put: 1;
		at: 'SC_CP_UTF8' put: 65001;
		at: 'SC_CURSORARROW' put: 2;
		at: 'SC_CURSORNORMAL' put: -1;
		at: 'SC_CURSORREVERSEARROW' put: 7;
		at: 'SC_CURSORWAIT' put: 4;
		at: 'SC_EFF_QUALITY_ANTIALIASED' put: 2;
		at: 'SC_EFF_QUALITY_DEFAULT' put: 0;
		at: 'SC_EFF_QUALITY_LCD_OPTIMIZED' put: 3;
		at: 'SC_EFF_QUALITY_MASK' put: 15;
		at: 'SC_EFF_QUALITY_NON_ANTIALIASED' put: 1;
		at: 'SC_EOL_CR' put: 1;
		at: 'SC_EOL_CRLF' put: 0;
		at: 'SC_EOL_LF' put: 2;
		at: 'SC_FOLDACTION_CONTRACT' put: 0;
		at: 'SC_FOLDACTION_EXPAND' put: 1;
		at: 'SC_FOLDACTION_TOGGLE' put: 2;
		at: 'SC_FOLDFLAG_LEVELNUMBERS' put: 64;
		at: 'SC_FOLDFLAG_LINEAFTER_CONTRACTED' put: 16;
		at: 'SC_FOLDFLAG_LINEAFTER_EXPANDED' put: 8;
		at: 'SC_FOLDFLAG_LINEBEFORE_CONTRACTED' put: 4;
		at: 'SC_FOLDFLAG_LINEBEFORE_EXPANDED' put: 2;
		at: 'SC_FOLDFLAG_LINESTATE' put: 128;
		at: 'SC_FOLDLEVELBASE' put: 1024;
		at: 'SC_FOLDLEVELHEADERFLAG' put: 8192;
		at: 'SC_FOLDLEVELNUMBERMASK' put: 4095;
		at: 'SC_FOLDLEVELWHITEFLAG' put: 4096;
		at: 'SC_FONT_SIZE_MULTIPLIER' put: 100;
		at: 'SC_IDLESTYLING_AFTERVISIBLE' put: 2;
		at: 'SC_IDLESTYLING_ALL' put: 3;
		at: 'SC_IDLESTYLING_NONE' put: 0;
		at: 'SC_IDLESTYLING_TOVISIBLE' put: 1;
		at: 'SC_IME_INLINE' put: 1;
		at: 'SC_IME_WINDOWED' put: 0;
		at: 'SC_INDICFLAG_VALUEFORE' put: 1;
		at: 'SC_INDICVALUEBIT' put: 16777216;
		at: 'SC_INDICVALUEMASK' put: 16777215;
		at: 'SC_IV_LOOKBOTH' put: 3;
		at: 'SC_IV_LOOKFORWARD' put: 2;
		at: 'SC_IV_NONE' put: 0;
		at: 'SC_IV_REAL' put: 1;
		at: 'SC_LASTSTEPINUNDOREDO' put: 256;
		at: 'SC_LINE_END_TYPE_DEFAULT' put: 0;
		at: 'SC_LINE_END_TYPE_UNICODE' put: 1;
		at: 'SC_MARGIN_BACK' put: 2;
		at: 'SC_MARGIN_FORE' put: 3;
		at: 'SC_MARGIN_NUMBER' put: 1;
		at: 'SC_MARGIN_RTEXT' put: 5;
		at: 'SC_MARGIN_SYMBOL' put: 0;
		at: 'SC_MARGIN_TEXT' put: 4;
		at: 'SC_MARGINOPTION_NONE' put: 0;
		at: 'SC_MARGINOPTION_SUBLINESELECT' put: 1;
		at: 'SC_MARK_ARROW' put: 2;
		at: 'SC_MARK_ARROWDOWN' put: 6;
		at: 'SC_MARK_ARROWS' put: 24;
		at: 'SC_MARK_AVAILABLE' put: 28;
		at: 'SC_MARK_BACKGROUND' put: 22;
		at: 'SC_MARK_BOOKMARK' put: 31;
		at: 'SC_MARK_BOXMINUS' put: 14;
		at: 'SC_MARK_BOXMINUSCONNECTED' put: 15;
		at: 'SC_MARK_BOXPLUS' put: 12;
		at: 'SC_MARK_BOXPLUSCONNECTED' put: 13;
		at: 'SC_MARK_CHARACTER' put: 10000;
		at: 'SC_MARK_CIRCLE' put: 0;
		at: 'SC_MARK_CIRCLEMINUS' put: 20;
		at: 'SC_MARK_CIRCLEMINUSCONNECTED' put: 21;
		at: 'SC_MARK_CIRCLEPLUS' put: 18;
		at: 'SC_MARK_CIRCLEPLUSCONNECTED' put: 19;
		at: 'SC_MARK_DOTDOTDOT' put: 23;
		at: 'SC_MARK_EMPTY' put: 5;
		at: 'SC_MARK_FULLRECT' put: 26;
		at: 'SC_MARK_LCORNER' put: 10;
		at: 'SC_MARK_LCORNERCURVE' put: 16;
		at: 'SC_MARK_LEFTRECT' put: 27;
		at: 'SC_MARK_MINUS' put: 7;
		at: 'SC_MARK_PIXMAP' put: 25;
		at: 'SC_MARK_PLUS' put: 8;
		at: 'SC_MARK_RGBAIMAGE' put: 30;
		at: 'SC_MARK_ROUNDRECT' put: 1;
		at: 'SC_MARK_SHORTARROW' put: 4;
		at: 'SC_MARK_SMALLRECT' put: 3;
		at: 'SC_MARK_TCORNER' put: 11;
		at: 'SC_MARK_TCORNERCURVE' put: 17;
		at: 'SC_MARK_UNDERLINE' put: 29;
		at: 'SC_MARK_VLINE' put: 9;
		at: 'SC_MARKNUM_FOLDER' put: 30;
		at: 'SC_MARKNUM_FOLDEREND' put: 25;
		at: 'SC_MARKNUM_FOLDERMIDTAIL' put: 27;
		at: 'SC_MARKNUM_FOLDEROPEN' put: 31;
		at: 'SC_MARKNUM_FOLDEROPENMID' put: 26;
		at: 'SC_MARKNUM_FOLDERSUB' put: 29;
		at: 'SC_MARKNUM_FOLDERTAIL' put: 28;
		at: 'SC_MASK_FOLDERS' put: 4261412864;
		at: 'SC_MAX_MARGIN' put: 4;
		at: 'SC_MOD_BEFOREDELETE' put: 2048;
		at: 'SC_MOD_BEFOREINSERT' put: 1024;
		at: 'SC_MOD_CHANGEANNOTATION' put: 131072;
		at: 'SC_MOD_CHANGEFOLD' put: 8;
		at: 'SC_MOD_CHANGEINDICATOR' put: 16384;
		at: 'SC_MOD_CHANGELINESTATE' put: 32768;
		at: 'SC_MOD_CHANGEMARGIN' put: 65536;
		at: 'SC_MOD_CHANGEMARKER' put: 512;
		at: 'SC_MOD_CHANGESTYLE' put: 4;
		at: 'SC_MOD_CHANGETABSTOPS' put: 2097152;
		at: 'SC_MOD_CONTAINER' put: 262144;
		at: 'SC_MOD_DELETETEXT' put: 2;
		at: 'SC_MOD_INSERTCHECK' put: 1048576;
		at: 'SC_MOD_INSERTTEXT' put: 1;
		at: 'SC_MOD_LEXERSTATE' put: 524288;
		at: 'SC_MODEVENTMASKALL' put: 4194303;
		at: 'SC_MULTIAUTOC_EACH' put: 1;
		at: 'SC_MULTIAUTOC_ONCE' put: 0;
		at: 'SC_MULTILINEUNDOREDO' put: 4096;
		at: 'SC_MULTIPASTE_EACH' put: 1;
		at: 'SC_MULTIPASTE_ONCE' put: 0;
		at: 'SC_MULTISTEPUNDOREDO' put: 128;
		at: 'SC_ORDER_CUSTOM' put: 2;
		at: 'SC_ORDER_PERFORMSORT' put: 1;
		at: 'SC_ORDER_PRESORTED' put: 0;
		at: 'SC_PERFORMED_REDO' put: 64;
		at: 'SC_PERFORMED_UNDO' put: 32;
		at: 'SC_PERFORMED_USER' put: 16;
		at: 'SC_PHASES_MULTIPLE' put: 2;
		at: 'SC_PHASES_ONE' put: 0;
		at: 'SC_PHASES_TWO' put: 1;
		at: 'SC_PRINT_BLACKONWHITE' put: 2;
		at: 'SC_PRINT_COLOURONWHITE' put: 3;
		at: 'SC_PRINT_COLOURONWHITEDEFAULTBG' put: 4;
		at: 'SC_PRINT_INVERTLIGHT' put: 1;
		at: 'SC_PRINT_NORMAL' put: 0;
		at: 'SC_SEL_LINES' put: 2;
		at: 'SC_SEL_RECTANGLE' put: 1;
		at: 'SC_SEL_STREAM' put: 0;
		at: 'SC_SEL_THIN' put: 3;
		at: 'SC_STARTACTION' put: 8192;
		at: 'SC_STATUS_BADALLOC' put: 2;
		at: 'SC_STATUS_FAILURE' put: 1;
		at: 'SC_STATUS_OK' put: 0;
		at: 'SC_STATUS_WARN_REGEX' put: 1001;
		at: 'SC_STATUS_WARN_START' put: 1000;
		at: 'SC_TECHNOLOGY_DEFAULT' put: 0;
		at: 'SC_TECHNOLOGY_DIRECTWRITE' put: 1;
		at: 'SC_TECHNOLOGY_DIRECTWRITEDC' put: 3;
		at: 'SC_TECHNOLOGY_DIRECTWRITERETAIN' put: 2;
		at: 'SC_TIME_FOREVER' put: 10000000;
		at: 'SC_TYPE_BOOLEAN' put: 0;
		at: 'SC_TYPE_INTEGER' put: 1;
		at: 'SC_TYPE_STRING' put: 2;
		at: 'SC_UPDATE_CONTENT' put: 1;
		at: 'SC_UPDATE_H_SCROLL' put: 8;
		at: 'SC_UPDATE_SELECTION' put: 2;
		at: 'SC_UPDATE_V_SCROLL' put: 4;
		at: 'SC_WEIGHT_BOLD' put: 700;
		at: 'SC_WEIGHT_NORMAL' put: 400;
		at: 'SC_WEIGHT_SEMIBOLD' put: 600;
		at: 'SC_WRAP_CHAR' put: 2;
		at: 'SC_WRAP_NONE' put: 0;
		at: 'SC_WRAP_WHITESPACE' put: 3;
		at: 'SC_WRAP_WORD' put: 1;
		at: 'SC_WRAPINDENT_FIXED' put: 0;
		at: 'SC_WRAPINDENT_INDENT' put: 2;
		at: 'SC_WRAPINDENT_SAME' put: 1;
		at: 'SC_WRAPVISUALFLAG_END' put: 1;
		at: 'SC_WRAPVISUALFLAG_MARGIN' put: 4;
		at: 'SC_WRAPVISUALFLAG_NONE' put: 0;
		at: 'SC_WRAPVISUALFLAG_START' put: 2;
		at: 'SC_WRAPVISUALFLAGLOC_DEFAULT' put: 0;
		at: 'SC_WRAPVISUALFLAGLOC_END_BY_TEXT' put: 1;
		at: 'SC_WRAPVISUALFLAGLOC_START_BY_TEXT' put: 2;
		at: 'SCEN_CHANGE' put: 768;
		at: 'SCEN_KILLFOCUS' put: 256;
		at: 'SCEN_SETFOCUS' put: 512;
		at: 'SCFIND_CXX11REGEX' put: 8388608;
		at: 'SCFIND_MATCHCASE' put: 4;
		at: 'SCFIND_POSIX' put: 4194304;
		at: 'SCFIND_REGEXP' put: 2097152;
		at: 'SCFIND_WHOLEWORD' put: 2;
		at: 'SCFIND_WORDSTART' put: 1048576;
		at: 'SCI_ADDREFDOCUMENT' put: 2376;
		at: 'SCI_ADDSELECTION' put: 2573;
		at: 'SCI_ADDSTYLEDTEXT' put: 2002;
		at: 'SCI_ADDTABSTOP' put: 2676;
		at: 'SCI_ADDTEXT' put: 2001;
		at: 'SCI_ADDUNDOACTION' put: 2560;
		at: 'SCI_ALLOCATE' put: 2446;
		at: 'SCI_ALLOCATEEXTENDEDSTYLES' put: 2553;
		at: 'SCI_ALLOCATESUBSTYLES' put: 4020;
		at: 'SCI_ANNOTATIONCLEARALL' put: 2547;
		at: 'SCI_ANNOTATIONGETLINES' put: 2546;
		at: 'SCI_ANNOTATIONGETSTYLE' put: 2543;
		at: 'SCI_ANNOTATIONGETSTYLEOFFSET' put: 2551;
		at: 'SCI_ANNOTATIONGETSTYLES' put: 2545;
		at: 'SCI_ANNOTATIONGETTEXT' put: 2541;
		at: 'SCI_ANNOTATIONGETVISIBLE' put: 2549;
		at: 'SCI_ANNOTATIONSETSTYLE' put: 2542;
		at: 'SCI_ANNOTATIONSETSTYLEOFFSET' put: 2550;
		at: 'SCI_ANNOTATIONSETSTYLES' put: 2544;
		at: 'SCI_ANNOTATIONSETTEXT' put: 2540;
		at: 'SCI_ANNOTATIONSETVISIBLE' put: 2548;
		at: 'SCI_APPENDTEXT' put: 2282;
		at: 'SCI_ASSIGNCMDKEY' put: 2070;
		at: 'SCI_AUTOCACTIVE' put: 2102;
		at: 'SCI_AUTOCCANCEL' put: 2101;
		at: 'SCI_AUTOCCOMPLETE' put: 2104;
		at: 'SCI_AUTOCGETAUTOHIDE' put: 2119;
		at: 'SCI_AUTOCGETCANCELATSTART' put: 2111;
		at: 'SCI_AUTOCGETCASEINSENSITIVEBEHAVIOUR' put: 2635;
		at: 'SCI_AUTOCGETCHOOSESINGLE' put: 2114;
		at: 'SCI_AUTOCGETCURRENT' put: 2445;
		at: 'SCI_AUTOCGETCURRENTTEXT' put: 2610;
		at: 'SCI_AUTOCGETDROPRESTOFWORD' put: 2271;
		at: 'SCI_AUTOCGETIGNORECASE' put: 2116;
		at: 'SCI_AUTOCGETMAXHEIGHT' put: 2211;
		at: 'SCI_AUTOCGETMAXWIDTH' put: 2209;
		at: 'SCI_AUTOCGETMULTI' put: 2637;
		at: 'SCI_AUTOCGETORDER' put: 2661;
		at: 'SCI_AUTOCGETSEPARATOR' put: 2107;
		at: 'SCI_AUTOCGETTYPESEPARATOR' put: 2285;
		at: 'SCI_AUTOCPOSSTART' put: 2103;
		at: 'SCI_AUTOCSELECT' put: 2108;
		at: 'SCI_AUTOCSETAUTOHIDE' put: 2118;
		at: 'SCI_AUTOCSETCANCELATSTART' put: 2110;
		at: 'SCI_AUTOCSETCASEINSENSITIVEBEHAVIOUR' put: 2634;
		at: 'SCI_AUTOCSETCHOOSESINGLE' put: 2113;
		at: 'SCI_AUTOCSETDROPRESTOFWORD' put: 2270;
		at: 'SCI_AUTOCSETFILLUPS' put: 2112;
		at: 'SCI_AUTOCSETIGNORECASE' put: 2115;
		at: 'SCI_AUTOCSETMAXHEIGHT' put: 2210;
		at: 'SCI_AUTOCSETMAXWIDTH' put: 2208;
		at: 'SCI_AUTOCSETMULTI' put: 2636;
		at: 'SCI_AUTOCSETORDER' put: 2660;
		at: 'SCI_AUTOCSETSEPARATOR' put: 2106;
		at: 'SCI_AUTOCSETTYPESEPARATOR' put: 2286;
		at: 'SCI_AUTOCSHOW' put: 2100;
		at: 'SCI_AUTOCSTOPS' put: 2105;
		at: 'SCI_BACKTAB' put: 2328;
		at: 'SCI_BEGINUNDOACTION' put: 2078;
		at: 'SCI_BRACEBADLIGHT' put: 2352;
		at: 'SCI_BRACEBADLIGHTINDICATOR' put: 2499;
		at: 'SCI_BRACEHIGHLIGHT' put: 2351;
		at: 'SCI_BRACEHIGHLIGHTINDICATOR' put: 2498;
		at: 'SCI_BRACEMATCH' put: 2353;
		at: 'SCI_CALLTIPACTIVE' put: 2202;
		at: 'SCI_CALLTIPCANCEL' put: 2201;
		at: 'SCI_CALLTIPPOSSTART' put: 2203;
		at: 'SCI_CALLTIPSETBACK' put: 2205;
		at: 'SCI_CALLTIPSETFORE' put: 2206;
		at: 'SCI_CALLTIPSETFOREHLT' put: 2207;
		at: 'SCI_CALLTIPSETHLT' put: 2204;
		at: 'SCI_CALLTIPSETPOSITION' put: 2213;
		at: 'SCI_CALLTIPSETPOSSTART' put: 2214;
		at: 'SCI_CALLTIPSHOW' put: 2200;
		at: 'SCI_CALLTIPUSESTYLE' put: 2212;
		at: 'SCI_CANCEL' put: 2325;
		at: 'SCI_CANPASTE' put: 2173;
		at: 'SCI_CANREDO' put: 2016;
		at: 'SCI_CANUNDO' put: 2174;
		at: 'SCI_CHANGEINSERTION' put: 2672;
		at: 'SCI_CHANGELEXERSTATE' put: 2617;
		at: 'SCI_CHARLEFT' put: 2304;
		at: 'SCI_CHARLEFTEXTEND' put: 2305;
		at: 'SCI_CHARLEFTRECTEXTEND' put: 2428;
		at: 'SCI_CHARPOSITIONFROMPOINT' put: 2561;
		at: 'SCI_CHARPOSITIONFROMPOINTCLOSE' put: 2562;
		at: 'SCI_CHARRIGHT' put: 2306;
		at: 'SCI_CHARRIGHTEXTEND' put: 2307;
		at: 'SCI_CHARRIGHTRECTEXTEND' put: 2429;
		at: 'SCI_CHOOSECARETX' put: 2399;
		at: 'SCI_CLEAR' put: 2180;
		at: 'SCI_CLEARALL' put: 2004;
		at: 'SCI_CLEARALLCMDKEYS' put: 2072;
		at: 'SCI_CLEARCMDKEY' put: 2071;
		at: 'SCI_CLEARDOCUMENTSTYLE' put: 2005;
		at: 'SCI_CLEARREGISTEREDIMAGES' put: 2408;
		at: 'SCI_CLEARREPRESENTATION' put: 2667;
		at: 'SCI_CLEARSELECTIONS' put: 2571;
		at: 'SCI_CLEARTABSTOPS' put: 2675;
		at: 'SCI_COLOURISE' put: 4003;
		at: 'SCI_CONTRACTEDFOLDNEXT' put: 2618;
		at: 'SCI_CONVERTEOLS' put: 2029;
		at: 'SCI_COPY' put: 2178;
		at: 'SCI_COPYALLOWLINE' put: 2519;
		at: 'SCI_COPYRANGE' put: 2419;
		at: 'SCI_COPYTEXT' put: 2420;
		at: 'SCI_COUNTCHARACTERS' put: 2633;
		at: 'SCI_CREATEDOCUMENT' put: 2375;
		at: 'SCI_CREATELOADER' put: 2632;
		at: 'SCI_CUT' put: 2177;
		at: 'SCI_DELETEBACK' put: 2326;
		at: 'SCI_DELETEBACKNOTLINE' put: 2344;
		at: 'SCI_DELETERANGE' put: 2645;
		at: 'SCI_DELLINELEFT' put: 2395;
		at: 'SCI_DELLINERIGHT' put: 2396;
		at: 'SCI_DELWORDLEFT' put: 2335;
		at: 'SCI_DELWORDRIGHT' put: 2336;
		at: 'SCI_DELWORDRIGHTEND' put: 2518;
		at: 'SCI_DESCRIBEKEYWORDSETS' put: 4017;
		at: 'SCI_DESCRIBEPROPERTY' put: 4016;
		at: 'SCI_DISTANCETOSECONDARYSTYLES' put: 4025;
		at: 'SCI_DOCLINEFROMVISIBLE' put: 2221;
		at: 'SCI_DOCUMENTEND' put: 2318;
		at: 'SCI_DOCUMENTENDEXTEND' put: 2319;
		at: 'SCI_DOCUMENTSTART' put: 2316;
		at: 'SCI_DOCUMENTSTARTEXTEND' put: 2317;
		at: 'SCI_DROPSELECTIONN' put: 2671;
		at: 'SCI_EDITTOGGLEOVERTYPE' put: 2324;
		at: 'SCI_EMPTYUNDOBUFFER' put: 2175;
		at: 'SCI_ENCODEDFROMUTF8' put: 2449;
		at: 'SCI_ENDUNDOACTION' put: 2079;
		at: 'SCI_ENSUREVISIBLE' put: 2232;
		at: 'SCI_ENSUREVISIBLEENFORCEPOLICY' put: 2234;
		at: 'SCI_EXPANDCHILDREN' put: 2239;
		at: 'SCI_FINDCOLUMN' put: 2456;
		at: 'SCI_FINDINDICATORFLASH' put: 2641;
		at: 'SCI_FINDINDICATORHIDE' put: 2642;
		at: 'SCI_FINDINDICATORSHOW' put: 2640;
		at: 'SCI_FINDTEXT' put: 2150;
		at: 'SCI_FOLDALL' put: 2662;
		at: 'SCI_FOLDCHILDREN' put: 2238;
		at: 'SCI_FOLDLINE' put: 2237;
		at: 'SCI_FORMATRANGE' put: 2151;
		at: 'SCI_FORMFEED' put: 2330;
		at: 'SCI_FREESUBSTYLES' put: 4023;
		at: 'SCI_GETADDITIONALCARETFORE' put: 2605;
		at: 'SCI_GETADDITIONALCARETSBLINK' put: 2568;
		at: 'SCI_GETADDITIONALCARETSVISIBLE' put: 2609;
		at: 'SCI_GETADDITIONALSELALPHA' put: 2603;
		at: 'SCI_GETADDITIONALSELECTIONTYPING' put: 2566;
		at: 'SCI_GETALLLINESVISIBLE' put: 2236;
		at: 'SCI_GETANCHOR' put: 2009;
		at: 'SCI_GETAUTOMATICFOLD' put: 2664;
		at: 'SCI_GETBACKSPACEUNINDENTS' put: 2263;
		at: 'SCI_GETBUFFEREDDRAW' put: 2034;
		at: 'SCI_GETCARETFORE' put: 2138;
		at: 'SCI_GETCARETLINEBACK' put: 2097;
		at: 'SCI_GETCARETLINEBACKALPHA' put: 2471;
		at: 'SCI_GETCARETLINEVISIBLE' put: 2095;
		at: 'SCI_GETCARETLINEVISIBLEALWAYS' put: 2654;
		at: 'SCI_GETCARETPERIOD' put: 2075;
		at: 'SCI_GETCARETSTICKY' put: 2457;
		at: 'SCI_GETCARETSTYLE' put: 2513;
		at: 'SCI_GETCARETWIDTH' put: 2189;
		at: 'SCI_GETCHARACTERPOINTER' put: 2520;
		at: 'SCI_GETCHARAT' put: 2007;
		at: 'SCI_GETCODEPAGE' put: 2137;
		at: 'SCI_GETCOLUMN' put: 2129;
		at: 'SCI_GETCONTROLCHARSYMBOL' put: 2389;
		at: 'SCI_GETCURLINE' put: 2027;
		at: 'SCI_GETCURRENTPOS' put: 2008;
		at: 'SCI_GETCURSOR' put: 2387;
		at: 'SCI_GETDIRECTFUNCTION' put: 2184;
		at: 'SCI_GETDIRECTPOINTER' put: 2185;
		at: 'SCI_GETDOCPOINTER' put: 2357;
		at: 'SCI_GETEDGECOLOUR' put: 2364;
		at: 'SCI_GETEDGECOLUMN' put: 2360;
		at: 'SCI_GETEDGEMODE' put: 2362;
		at: 'SCI_GETENDATLASTLINE' put: 2278;
		at: 'SCI_GETENDSTYLED' put: 2028;
		at: 'SCI_GETEOLMODE' put: 2030;
		at: 'SCI_GETEXTRAASCENT' put: 2526;
		at: 'SCI_GETEXTRADESCENT' put: 2528;
		at: 'SCI_GETFIRSTVISIBLELINE' put: 2152;
		at: 'SCI_GETFOCUS' put: 2381;
		at: 'SCI_GETFOLDEXPANDED' put: 2230;
		at: 'SCI_GETFOLDLEVEL' put: 2223;
		at: 'SCI_GETFOLDPARENT' put: 2225;
		at: 'SCI_GETFONTQUALITY' put: 2612;
		at: 'SCI_GETGAPPOSITION' put: 2644;
		at: 'SCI_GETHIGHLIGHTGUIDE' put: 2135;
		at: 'SCI_GETHOTSPOTACTIVEBACK' put: 2495;
		at: 'SCI_GETHOTSPOTACTIVEFORE' put: 2494;
		at: 'SCI_GETHOTSPOTACTIVEUNDERLINE' put: 2496;
		at: 'SCI_GETHOTSPOTSINGLELINE' put: 2497;
		at: 'SCI_GETHSCROLLBAR' put: 2131;
		at: 'SCI_GETIDENTIFIER' put: 2623;
		at: 'SCI_GETIDLESTYLING' put: 2693;
		at: 'SCI_GETIMEINTERACTION' put: 2678;
		at: 'SCI_GETINDENT' put: 2123;
		at: 'SCI_GETINDENTATIONGUIDES' put: 2133;
		at: 'SCI_GETINDICATORCURRENT' put: 2501;
		at: 'SCI_GETINDICATORVALUE' put: 2503;
		at: 'SCI_GETKEYSUNICODE' put: 2522;
		at: 'SCI_GETLASTCHILD' put: 2224;
		at: 'SCI_GETLAYOUTCACHE' put: 2273;
		at: 'SCI_GETLENGTH' put: 2006;
		at: 'SCI_GETLEXER' put: 4002;
		at: 'SCI_GETLEXERLANGUAGE' put: 4012;
		at: 'SCI_GETLINE' put: 2153;
		at: 'SCI_GETLINECOUNT' put: 2154;
		at: 'SCI_GETLINEENDPOSITION' put: 2136;
		at: 'SCI_GETLINEENDTYPESACTIVE' put: 2658;
		at: 'SCI_GETLINEENDTYPESALLOWED' put: 2657;
		at: 'SCI_GETLINEENDTYPESSUPPORTED' put: 4018;
		at: 'SCI_GETLINEINDENTATION' put: 2127;
		at: 'SCI_GETLINEINDENTPOSITION' put: 2128;
		at: 'SCI_GETLINESELENDPOSITION' put: 2425;
		at: 'SCI_GETLINESELSTARTPOSITION' put: 2424;
		at: 'SCI_GETLINESTATE' put: 2093;
		at: 'SCI_GETLINEVISIBLE' put: 2228;
		at: 'SCI_GETMAINSELECTION' put: 2575;
		at: 'SCI_GETMARGINCURSORN' put: 2249;
		at: 'SCI_GETMARGINLEFT' put: 2156;
		at: 'SCI_GETMARGINMASKN' put: 2245;
		at: 'SCI_GETMARGINOPTIONS' put: 2557;
		at: 'SCI_GETMARGINRIGHT' put: 2158;
		at: 'SCI_GETMARGINSENSITIVEN' put: 2247;
		at: 'SCI_GETMARGINTYPEN' put: 2241;
		at: 'SCI_GETMARGINWIDTHN' put: 2243;
		at: 'SCI_GETMAXLINESTATE' put: 2094;
		at: 'SCI_GETMODEVENTMASK' put: 2378;
		at: 'SCI_GETMODIFY' put: 2159;
		at: 'SCI_GETMOUSEDOWNCAPTURES' put: 2385;
		at: 'SCI_GETMOUSEDWELLTIME' put: 2265;
		at: 'SCI_GETMOUSESELECTIONRECTANGULARSWITCH' put: 2669;
		at: 'SCI_GETMULTIPASTE' put: 2615;
		at: 'SCI_GETMULTIPLESELECTION' put: 2564;
		at: 'SCI_GETNEXTTABSTOP' put: 2677;
		at: 'SCI_GETOVERTYPE' put: 2187;
		at: 'SCI_GETPASTECONVERTENDINGS' put: 2468;
		at: 'SCI_GETPHASESDRAW' put: 2673;
		at: 'SCI_GETPOSITIONCACHE' put: 2515;
		at: 'SCI_GETPRIMARYSTYLEFROMSTYLE' put: 4028;
		at: 'SCI_GETPRINTCOLOURMODE' put: 2149;
		at: 'SCI_GETPRINTMAGNIFICATION' put: 2147;
		at: 'SCI_GETPRINTWRAPMODE' put: 2407;
		at: 'SCI_GETPROPERTY' put: 4008;
		at: 'SCI_GETPROPERTYEXPANDED' put: 4009;
		at: 'SCI_GETPROPERTYINT' put: 4010;
		at: 'SCI_GETPUNCTUATIONCHARS' put: 2649;
		at: 'SCI_GETRANGEPOINTER' put: 2643;
		at: 'SCI_GETREADONLY' put: 2140;
		at: 'SCI_GETRECTANGULARSELECTIONANCHOR' put: 2591;
		at: 'SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE' put: 2595;
		at: 'SCI_GETRECTANGULARSELECTIONCARET' put: 2589;
		at: 'SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE' put: 2593;
		at: 'SCI_GETRECTANGULARSELECTIONMODIFIER' put: 2599;
		at: 'SCI_GETREPRESENTATION' put: 2666;
		at: 'SCI_GETSCROLLWIDTH' put: 2275;
		at: 'SCI_GETSCROLLWIDTHTRACKING' put: 2517;
		at: 'SCI_GETSEARCHFLAGS' put: 2199;
		at: 'SCI_GETSELALPHA' put: 2477;
		at: 'SCI_GETSELECTIONEMPTY' put: 2650;
		at: 'SCI_GETSELECTIONEND' put: 2145;
		at: 'SCI_GETSELECTIONMODE' put: 2423;
		at: 'SCI_GETSELECTIONNANCHOR' put: 2579;
		at: 'SCI_GETSELECTIONNANCHORVIRTUALSPACE' put: 2583;
		at: 'SCI_GETSELECTIONNCARET' put: 2577;
		at: 'SCI_GETSELECTIONNCARETVIRTUALSPACE' put: 2581;
		at: 'SCI_GETSELECTIONNEND' put: 2587;
		at: 'SCI_GETSELECTIONNSTART' put: 2585;
		at: 'SCI_GETSELECTIONS' put: 2570;
		at: 'SCI_GETSELECTIONSTART' put: 2143;
		at: 'SCI_GETSELEOLFILLED' put: 2479;
		at: 'SCI_GETSELTEXT' put: 2161;
		at: 'SCI_GETSTATUS' put: 2383;
		at: 'SCI_GETSTYLEAT' put: 2010;
		at: 'SCI_GETSTYLEBITS' put: 2091;
		at: 'SCI_GETSTYLEBITSNEEDED' put: 4011;
		at: 'SCI_GETSTYLEDTEXT' put: 2015;
		at: 'SCI_GETSTYLEFROMSUBSTYLE' put: 4027;
		at: 'SCI_GETSUBSTYLEBASES' put: 4026;
		at: 'SCI_GETSUBSTYLESLENGTH' put: 4022;
		at: 'SCI_GETSUBSTYLESSTART' put: 4021;
		at: 'SCI_GETTABINDENTS' put: 2261;
		at: 'SCI_GETTABWIDTH' put: 2121;
		at: 'SCI_GETTAG' put: 2616;
		at: 'SCI_GETTARGETEND' put: 2193;
		at: 'SCI_GETTARGETSTART' put: 2191;
		at: 'SCI_GETTARGETTEXT' put: 2687;
		at: 'SCI_GETTECHNOLOGY' put: 2631;
		at: 'SCI_GETTEXT' put: 2182;
		at: 'SCI_GETTEXTLENGTH' put: 2183;
		at: 'SCI_GETTEXTRANGE' put: 2162;
		at: 'SCI_GETTWOPHASEDRAW' put: 2283;
		at: 'SCI_GETUNDOCOLLECTION' put: 2019;
		at: 'SCI_GETUSEPALETTE' put: 2139;
		at: 'SCI_GETUSETABS' put: 2125;
		at: 'SCI_GETVIEWEOL' put: 2355;
		at: 'SCI_GETVIEWWS' put: 2020;
		at: 'SCI_GETVIRTUALSPACEOPTIONS' put: 2597;
		at: 'SCI_GETVSCROLLBAR' put: 2281;
		at: 'SCI_GETWHITESPACECHARS' put: 2647;
		at: 'SCI_GETWHITESPACESIZE' put: 2087;
		at: 'SCI_GETWORDCHARS' put: 2646;
		at: 'SCI_GETWRAPINDENTMODE' put: 2473;
		at: 'SCI_GETWRAPMODE' put: 2269;
		at: 'SCI_GETWRAPSTARTINDENT' put: 2465;
		at: 'SCI_GETWRAPVISUALFLAGS' put: 2461;
		at: 'SCI_GETWRAPVISUALFLAGSLOCATION' put: 2463;
		at: 'SCI_GETXOFFSET' put: 2398;
		at: 'SCI_GETZOOM' put: 2374;
		at: 'SCI_GOTOLINE' put: 2024;
		at: 'SCI_GOTOPOS' put: 2025;
		at: 'SCI_GRABFOCUS' put: 2400;
		at: 'SCI_HIDELINES' put: 2227;
		at: 'SCI_HIDESELECTION' put: 2163;
		at: 'SCI_HOME' put: 2312;
		at: 'SCI_HOMEDISPLAY' put: 2345;
		at: 'SCI_HOMEDISPLAYEXTEND' put: 2346;
		at: 'SCI_HOMEEXTEND' put: 2313;
		at: 'SCI_HOMERECTEXTEND' put: 2430;
		at: 'SCI_HOMEWRAP' put: 2349;
		at: 'SCI_HOMEWRAPEXTEND' put: 2450;
		at: 'SCI_INDICATORALLONFOR' put: 2506;
		at: 'SCI_INDICATORCLEARRANGE' put: 2505;
		at: 'SCI_INDICATOREND' put: 2509;
		at: 'SCI_INDICATORFILLRANGE' put: 2504;
		at: 'SCI_INDICATORSTART' put: 2508;
		at: 'SCI_INDICATORVALUEAT' put: 2507;
		at: 'SCI_INDICGETALPHA' put: 2524;
		at: 'SCI_INDICGETFLAGS' put: 2685;
		at: 'SCI_INDICGETFORE' put: 2083;
		at: 'SCI_INDICGETHOVERFORE' put: 2683;
		at: 'SCI_INDICGETHOVERSTYLE' put: 2681;
		at: 'SCI_INDICGETOUTLINEALPHA' put: 2559;
		at: 'SCI_INDICGETSTYLE' put: 2081;
		at: 'SCI_INDICGETUNDER' put: 2511;
		at: 'SCI_INDICSETALPHA' put: 2523;
		at: 'SCI_INDICSETFLAGS' put: 2684;
		at: 'SCI_INDICSETFORE' put: 2082;
		at: 'SCI_INDICSETHOVERFORE' put: 2682;
		at: 'SCI_INDICSETHOVERSTYLE' put: 2680;
		at: 'SCI_INDICSETOUTLINEALPHA' put: 2558;
		at: 'SCI_INDICSETSTYLE' put: 2080;
		at: 'SCI_INDICSETUNDER' put: 2510;
		at: 'SCI_INSERTTEXT' put: 2003;
		at: 'SCI_ISRANGEWORD' put: 2691;
		at: 'SCI_LEXER_START' put: 4000;
		at: 'SCI_LINECOPY' put: 2455;
		at: 'SCI_LINECUT' put: 2337;
		at: 'SCI_LINEDELETE' put: 2338;
		at: 'SCI_LINEDOWN' put: 2300;
		at: 'SCI_LINEDOWNEXTEND' put: 2301;
		at: 'SCI_LINEDOWNRECTEXTEND' put: 2426;
		at: 'SCI_LINEDUPLICATE' put: 2404;
		at: 'SCI_LINEEND' put: 2314;
		at: 'SCI_LINEENDDISPLAY' put: 2347;
		at: 'SCI_LINEENDDISPLAYEXTEND' put: 2348;
		at: 'SCI_LINEENDEXTEND' put: 2315;
		at: 'SCI_LINEENDRECTEXTEND' put: 2432;
		at: 'SCI_LINEENDWRAP' put: 2451;
		at: 'SCI_LINEENDWRAPEXTEND' put: 2452;
		at: 'SCI_LINEFROMPOSITION' put: 2166;
		at: 'SCI_LINELENGTH' put: 2350;
		at: 'SCI_LINESCROLL' put: 2168;
		at: 'SCI_LINESCROLLDOWN' put: 2342;
		at: 'SCI_LINESCROLLUP' put: 2343;
		at: 'SCI_LINESJOIN' put: 2288;
		at: 'SCI_LINESONSCREEN' put: 2370;
		at: 'SCI_LINESSPLIT' put: 2289;
		at: 'SCI_LINETRANSPOSE' put: 2339;
		at: 'SCI_LINEUP' put: 2302;
		at: 'SCI_LINEUPEXTEND' put: 2303;
		at: 'SCI_LINEUPRECTEXTEND' put: 2427;
		at: 'SCI_LOADLEXERLIBRARY' put: 4007;
		at: 'SCI_LOWERCASE' put: 2340;
		at: 'SCI_MARGINGETSTYLE' put: 2533;
		at: 'SCI_MARGINGETSTYLEOFFSET' put: 2538;
		at: 'SCI_MARGINGETSTYLES' put: 2535;
		at: 'SCI_MARGINGETTEXT' put: 2531;
		at: 'SCI_MARGINSETSTYLE' put: 2532;
		at: 'SCI_MARGINSETSTYLEOFFSET' put: 2537;
		at: 'SCI_MARGINSETSTYLES' put: 2534;
		at: 'SCI_MARGINSETTEXT' put: 2530;
		at: 'SCI_MARGINTEXTCLEARALL' put: 2536;
		at: 'SCI_MARKERADD' put: 2043;
		at: 'SCI_MARKERADDSET' put: 2466;
		at: 'SCI_MARKERDEFINE' put: 2040;
		at: 'SCI_MARKERDEFINEPIXMAP' put: 2049;
		at: 'SCI_MARKERDEFINERGBAIMAGE' put: 2626;
		at: 'SCI_MARKERDELETE' put: 2044;
		at: 'SCI_MARKERDELETEALL' put: 2045;
		at: 'SCI_MARKERDELETEHANDLE' put: 2018;
		at: 'SCI_MARKERENABLEHIGHLIGHT' put: 2293;
		at: 'SCI_MARKERGET' put: 2046;
		at: 'SCI_MARKERLINEFROMHANDLE' put: 2017;
		at: 'SCI_MARKERNEXT' put: 2047;
		at: 'SCI_MARKERPREVIOUS' put: 2048;
		at: 'SCI_MARKERSETALPHA' put: 2476;
		at: 'SCI_MARKERSETBACK' put: 2042;
		at: 'SCI_MARKERSETBACKSELECTED' put: 2292;
		at: 'SCI_MARKERSETFORE' put: 2041;
		at: 'SCI_MARKERSYMBOLDEFINED' put: 2529;
		at: 'SCI_MOVECARETINSIDEVIEW' put: 2401;
		at: 'SCI_MOVESELECTEDLINESDOWN' put: 2621;
		at: 'SCI_MOVESELECTEDLINESUP' put: 2620;
		at: 'SCI_MULTIPLESELECTADDEACH' put: 2689;
		at: 'SCI_MULTIPLESELECTADDNEXT' put: 2688;
		at: 'SCI_NEWLINE' put: 2329;
		at: 'SCI_NULL' put: 2172;
		at: 'SCI_OPTIONAL_START' put: 3000;
		at: 'SCI_PAGEDOWN' put: 2322;
		at: 'SCI_PAGEDOWNEXTEND' put: 2323;
		at: 'SCI_PAGEDOWNRECTEXTEND' put: 2434;
		at: 'SCI_PAGEUP' put: 2320;
		at: 'SCI_PAGEUPEXTEND' put: 2321;
		at: 'SCI_PAGEUPRECTEXTEND' put: 2433;
		at: 'SCI_PARADOWN' put: 2413;
		at: 'SCI_PARADOWNEXTEND' put: 2414;
		at: 'SCI_PARAUP' put: 2415;
		at: 'SCI_PARAUPEXTEND' put: 2416;
		at: 'SCI_PASTE' put: 2179;
		at: 'SCI_POINTXFROMPOSITION' put: 2164;
		at: 'SCI_POINTYFROMPOSITION' put: 2165;
		at: 'SCI_POSITIONAFTER' put: 2418;
		at: 'SCI_POSITIONBEFORE' put: 2417;
		at: 'SCI_POSITIONFROMLINE' put: 2167;
		at: 'SCI_POSITIONFROMPOINT' put: 2022;
		at: 'SCI_POSITIONFROMPOINTCLOSE' put: 2023;
		at: 'SCI_POSITIONRELATIVE' put: 2670;
		at: 'SCI_PRIVATELEXERCALL' put: 4013;
		at: 'SCI_PROPERTYNAMES' put: 4014;
		at: 'SCI_PROPERTYTYPE' put: 4015;
		at: 'SCI_REDO' put: 2011;
		at: 'SCI_REGISTERIMAGE' put: 2405;
		at: 'SCI_REGISTERRGBAIMAGE' put: 2627;
		at: 'SCI_RELEASEALLEXTENDEDSTYLES' put: 2552;
		at: 'SCI_RELEASEDOCUMENT' put: 2377;
		at: 'SCI_REPLACESEL' put: 2170;
		at: 'SCI_REPLACETARGET' put: 2194;
		at: 'SCI_REPLACETARGETRE' put: 2195;
		at: 'SCI_RGBAIMAGESETHEIGHT' put: 2625;
		at: 'SCI_RGBAIMAGESETSCALE' put: 2651;
		at: 'SCI_RGBAIMAGESETWIDTH' put: 2624;
		at: 'SCI_ROTATESELECTION' put: 2606;
		at: 'SCI_SCROLLCARET' put: 2169;
		at: 'SCI_SCROLLRANGE' put: 2569;
		at: 'SCI_SCROLLTOEND' put: 2629;
		at: 'SCI_SCROLLTOSTART' put: 2628;
		at: 'SCI_SEARCHANCHOR' put: 2366;
		at: 'SCI_SEARCHINTARGET' put: 2197;
		at: 'SCI_SEARCHNEXT' put: 2367;
		at: 'SCI_SEARCHPREV' put: 2368;
		at: 'SCI_SELECTALL' put: 2013;
		at: 'SCI_SELECTIONDUPLICATE' put: 2469;
		at: 'SCI_SELECTIONISRECTANGLE' put: 2372;
		at: 'SCI_SETADDITIONALCARETFORE' put: 2604;
		at: 'SCI_SETADDITIONALCARETSBLINK' put: 2567;
		at: 'SCI_SETADDITIONALCARETSVISIBLE' put: 2608;
		at: 'SCI_SETADDITIONALSELALPHA' put: 2602;
		at: 'SCI_SETADDITIONALSELBACK' put: 2601;
		at: 'SCI_SETADDITIONALSELECTIONTYPING' put: 2565;
		at: 'SCI_SETADDITIONALSELFORE' put: 2600;
		at: 'SCI_SETANCHOR' put: 2026;
		at: 'SCI_SETAUTOMATICFOLD' put: 2663;
		at: 'SCI_SETBACKSPACEUNINDENTS' put: 2262;
		at: 'SCI_SETBUFFEREDDRAW' put: 2035;
		at: 'SCI_SETCARETFORE' put: 2069;
		at: 'SCI_SETCARETLINEBACK' put: 2098;
		at: 'SCI_SETCARETLINEBACKALPHA' put: 2470;
		at: 'SCI_SETCARETLINEVISIBLE' put: 2096;
		at: 'SCI_SETCARETLINEVISIBLEALWAYS' put: 2655;
		at: 'SCI_SETCARETPERIOD' put: 2076;
		at: 'SCI_SETCARETSTICKY' put: 2458;
		at: 'SCI_SETCARETSTYLE' put: 2512;
		at: 'SCI_SETCARETWIDTH' put: 2188;
		at: 'SCI_SETCHARSDEFAULT' put: 2444;
		at: 'SCI_SETCODEPAGE' put: 2037;
		at: 'SCI_SETCONTROLCHARSYMBOL' put: 2388;
		at: 'SCI_SETCURRENTPOS' put: 2141;
		at: 'SCI_SETCURSOR' put: 2386;
		at: 'SCI_SETDOCPOINTER' put: 2358;
		at: 'SCI_SETEDGECOLOUR' put: 2365;
		at: 'SCI_SETEDGECOLUMN' put: 2361;
		at: 'SCI_SETEDGEMODE' put: 2363;
		at: 'SCI_SETEMPTYSELECTION' put: 2556;
		at: 'SCI_SETENDATLASTLINE' put: 2277;
		at: 'SCI_SETEOLMODE' put: 2031;
		at: 'SCI_SETEXTRAASCENT' put: 2525;
		at: 'SCI_SETEXTRADESCENT' put: 2527;
		at: 'SCI_SETFIRSTVISIBLELINE' put: 2613;
		at: 'SCI_SETFOCUS' put: 2380;
		at: 'SCI_SETFOLDEXPANDED' put: 2229;
		at: 'SCI_SETFOLDFLAGS' put: 2233;
		at: 'SCI_SETFOLDLEVEL' put: 2222;
		at: 'SCI_SETFOLDMARGINCOLOUR' put: 2290;
		at: 'SCI_SETFOLDMARGINHICOLOUR' put: 2291;
		at: 'SCI_SETFONTQUALITY' put: 2611;
		at: 'SCI_SETHIGHLIGHTGUIDE' put: 2134;
		at: 'SCI_SETHOTSPOTACTIVEBACK' put: 2411;
		at: 'SCI_SETHOTSPOTACTIVEFORE' put: 2410;
		at: 'SCI_SETHOTSPOTACTIVEUNDERLINE' put: 2412;
		at: 'SCI_SETHOTSPOTSINGLELINE' put: 2421;
		at: 'SCI_SETHSCROLLBAR' put: 2130;
		at: 'SCI_SETIDENTIFIER' put: 2622;
		at: 'SCI_SETIDENTIFIERS' put: 4024;
		at: 'SCI_SETIDLESTYLING' put: 2692;
		at: 'SCI_SETIMEINTERACTION' put: 2679;
		at: 'SCI_SETINDENT' put: 2122;
		at: 'SCI_SETINDENTATIONGUIDES' put: 2132;
		at: 'SCI_SETINDICATORCURRENT' put: 2500;
		at: 'SCI_SETINDICATORVALUE' put: 2502;
		at: 'SCI_SETKEYSUNICODE' put: 2521;
		at: 'SCI_SETKEYWORDS' put: 4005;
		at: 'SCI_SETLAYOUTCACHE' put: 2272;
		at: 'SCI_SETLENGTHFORENCODE' put: 2448;
		at: 'SCI_SETLEXER' put: 4001;
		at: 'SCI_SETLEXERLANGUAGE' put: 4006;
		at: 'SCI_SETLINEENDTYPESALLOWED' put: 2656;
		at: 'SCI_SETLINEINDENTATION' put: 2126;
		at: 'SCI_SETLINESTATE' put: 2092;
		at: 'SCI_SETMAINSELECTION' put: 2574;
		at: 'SCI_SETMARGINCURSORN' put: 2248;
		at: 'SCI_SETMARGINLEFT' put: 2155;
		at: 'SCI_SETMARGINMASKN' put: 2244;
		at: 'SCI_SETMARGINOPTIONS' put: 2539;
		at: 'SCI_SETMARGINRIGHT' put: 2157;
		at: 'SCI_SETMARGINSENSITIVEN' put: 2246;
		at: 'SCI_SETMARGINTYPEN' put: 2240;
		at: 'SCI_SETMARGINWIDTHN' put: 2242;
		at: 'SCI_SETMODEVENTMASK' put: 2359;
		at: 'SCI_SETMOUSEDOWNCAPTURES' put: 2384;
		at: 'SCI_SETMOUSEDWELLTIME' put: 2264;
		at: 'SCI_SETMOUSESELECTIONRECTANGULARSWITCH' put: 2668;
		at: 'SCI_SETMULTIPASTE' put: 2614;
		at: 'SCI_SETMULTIPLESELECTION' put: 2563;
		at: 'SCI_SETOVERTYPE' put: 2186;
		at: 'SCI_SETPASTECONVERTENDINGS' put: 2467;
		at: 'SCI_SETPHASESDRAW' put: 2674;
		at: 'SCI_SETPOSITIONCACHE' put: 2514;
		at: 'SCI_SETPRINTCOLOURMODE' put: 2148;
		at: 'SCI_SETPRINTMAGNIFICATION' put: 2146;
		at: 'SCI_SETPRINTWRAPMODE' put: 2406;
		at: 'SCI_SETPROPERTY' put: 4004;
		at: 'SCI_SETPUNCTUATIONCHARS' put: 2648;
		at: 'SCI_SETREADONLY' put: 2171;
		at: 'SCI_SETRECTANGULARSELECTIONANCHOR' put: 2590;
		at: 'SCI_SETRECTANGULARSELECTIONANCHORVIRTUALSPACE' put: 2594;
		at: 'SCI_SETRECTANGULARSELECTIONCARET' put: 2588;
		at: 'SCI_SETRECTANGULARSELECTIONCARETVIRTUALSPACE' put: 2592;
		at: 'SCI_SETRECTANGULARSELECTIONMODIFIER' put: 2598;
		at: 'SCI_SETREPRESENTATION' put: 2665;
		at: 'SCI_SETSAVEPOINT' put: 2014;
		at: 'SCI_SETSCROLLWIDTH' put: 2274;
		at: 'SCI_SETSCROLLWIDTHTRACKING' put: 2516;
		at: 'SCI_SETSEARCHFLAGS' put: 2198;
		at: 'SCI_SETSEL' put: 2160;
		at: 'SCI_SETSELALPHA' put: 2478;
		at: 'SCI_SETSELBACK' put: 2068;
		at: 'SCI_SETSELECTION' put: 2572;
		at: 'SCI_SETSELECTIONEND' put: 2144;
		at: 'SCI_SETSELECTIONMODE' put: 2422;
		at: 'SCI_SETSELECTIONNANCHOR' put: 2578;
		at: 'SCI_SETSELECTIONNANCHORVIRTUALSPACE' put: 2582;
		at: 'SCI_SETSELECTIONNCARET' put: 2576;
		at: 'SCI_SETSELECTIONNCARETVIRTUALSPACE' put: 2580;
		at: 'SCI_SETSELECTIONNEND' put: 2586;
		at: 'SCI_SETSELECTIONNSTART' put: 2584;
		at: 'SCI_SETSELECTIONSTART' put: 2142;
		at: 'SCI_SETSELEOLFILLED' put: 2480;
		at: 'SCI_SETSELFORE' put: 2067;
		at: 'SCI_SETSTATUS' put: 2382;
		at: 'SCI_SETSTYLEBITS' put: 2090;
		at: 'SCI_SETSTYLING' put: 2033;
		at: 'SCI_SETSTYLINGEX' put: 2073;
		at: 'SCI_SETTABINDENTS' put: 2260;
		at: 'SCI_SETTABWIDTH' put: 2036;
		at: 'SCI_SETTARGETEND' put: 2192;
		at: 'SCI_SETTARGETRANGE' put: 2686;
		at: 'SCI_SETTARGETSTART' put: 2190;
		at: 'SCI_SETTECHNOLOGY' put: 2630;
		at: 'SCI_SETTEXT' put: 2181;
		at: 'SCI_SETTWOPHASEDRAW' put: 2284;
		at: 'SCI_SETUNDOCOLLECTION' put: 2012;
		at: 'SCI_SETUSEPALETTE' put: 2039;
		at: 'SCI_SETUSETABS' put: 2124;
		at: 'SCI_SETVIEWEOL' put: 2356;
		at: 'SCI_SETVIEWWS' put: 2021;
		at: 'SCI_SETVIRTUALSPACEOPTIONS' put: 2596;
		at: 'SCI_SETVISIBLEPOLICY' put: 2394;
		at: 'SCI_SETVSCROLLBAR' put: 2280;
		at: 'SCI_SETWHITESPACEBACK' put: 2085;
		at: 'SCI_SETWHITESPACECHARS' put: 2443;
		at: 'SCI_SETWHITESPACEFORE' put: 2084;
		at: 'SCI_SETWHITESPACESIZE' put: 2086;
		at: 'SCI_SETWORDCHARS' put: 2077;
		at: 'SCI_SETWRAPINDENTMODE' put: 2472;
		at: 'SCI_SETWRAPMODE' put: 2268;
		at: 'SCI_SETWRAPSTARTINDENT' put: 2464;
		at: 'SCI_SETWRAPVISUALFLAGS' put: 2460;
		at: 'SCI_SETWRAPVISUALFLAGSLOCATION' put: 2462;
		at: 'SCI_SETXCARETPOLICY' put: 2402;
		at: 'SCI_SETXOFFSET' put: 2397;
		at: 'SCI_SETYCARETPOLICY' put: 2403;
		at: 'SCI_SETZOOM' put: 2373;
		at: 'SCI_SHOWLINES' put: 2226;
		at: 'SCI_START' put: 2000;
		at: 'SCI_STARTRECORD' put: 3001;
		at: 'SCI_STARTSTYLING' put: 2032;
		at: 'SCI_STOPRECORD' put: 3002;
		at: 'SCI_STUTTEREDPAGEDOWN' put: 2437;
		at: 'SCI_STUTTEREDPAGEDOWNEXTEND' put: 2438;
		at: 'SCI_STUTTEREDPAGEUP' put: 2435;
		at: 'SCI_STUTTEREDPAGEUPEXTEND' put: 2436;
		at: 'SCI_STYLECLEARALL' put: 2050;
		at: 'SCI_STYLEGETBACK' put: 2482;
		at: 'SCI_STYLEGETBOLD' put: 2483;
		at: 'SCI_STYLEGETCASE' put: 2489;
		at: 'SCI_STYLEGETCHANGEABLE' put: 2492;
		at: 'SCI_STYLEGETCHARACTERSET' put: 2490;
		at: 'SCI_STYLEGETEOLFILLED' put: 2487;
		at: 'SCI_STYLEGETFONT' put: 2486;
		at: 'SCI_STYLEGETFORE' put: 2481;
		at: 'SCI_STYLEGETHOTSPOT' put: 2493;
		at: 'SCI_STYLEGETITALIC' put: 2484;
		at: 'SCI_STYLEGETSIZE' put: 2485;
		at: 'SCI_STYLEGETSIZEFRACTIONAL' put: 2062;
		at: 'SCI_STYLEGETUNDERLINE' put: 2488;
		at: 'SCI_STYLEGETVISIBLE' put: 2491;
		at: 'SCI_STYLEGETWEIGHT' put: 2064;
		at: 'SCI_STYLERESETDEFAULT' put: 2058;
		at: 'SCI_STYLESETBACK' put: 2052;
		at: 'SCI_STYLESETBOLD' put: 2053;
		at: 'SCI_STYLESETCASE' put: 2060;
		at: 'SCI_STYLESETCHANGEABLE' put: 2099;
		at: 'SCI_STYLESETCHARACTERSET' put: 2066;
		at: 'SCI_STYLESETEOLFILLED' put: 2057;
		at: 'SCI_STYLESETFONT' put: 2056;
		at: 'SCI_STYLESETFORE' put: 2051;
		at: 'SCI_STYLESETHOTSPOT' put: 2409;
		at: 'SCI_STYLESETITALIC' put: 2054;
		at: 'SCI_STYLESETSIZE' put: 2055;
		at: 'SCI_STYLESETSIZEFRACTIONAL' put: 2061;
		at: 'SCI_STYLESETUNDERLINE' put: 2059;
		at: 'SCI_STYLESETVISIBLE' put: 2074;
		at: 'SCI_STYLESETWEIGHT' put: 2063;
		at: 'SCI_SWAPMAINANCHORCARET' put: 2607;
		at: 'SCI_TAB' put: 2327;
		at: 'SCI_TARGETASUTF8' put: 2447;
		at: 'SCI_TARGETFROMSELECTION' put: 2287;
		at: 'SCI_TARGETWHOLEDOCUMENT' put: 2690;
		at: 'SCI_TEXTHEIGHT' put: 2279;
		at: 'SCI_TEXTWIDTH' put: 2276;
		at: 'SCI_TOGGLECARETSTICKY' put: 2459;
		at: 'SCI_TOGGLEFOLD' put: 2231;
		at: 'SCI_UNDO' put: 2176;
		at: 'SCI_UPPERCASE' put: 2341;
		at: 'SCI_USEPOPUP' put: 2371;
		at: 'SCI_USERLISTSHOW' put: 2117;
		at: 'SCI_VCHOME' put: 2331;
		at: 'SCI_VCHOMEDISPLAY' put: 2652;
		at: 'SCI_VCHOMEDISPLAYEXTEND' put: 2653;
		at: 'SCI_VCHOMEEXTEND' put: 2332;
		at: 'SCI_VCHOMERECTEXTEND' put: 2431;
		at: 'SCI_VCHOMEWRAP' put: 2453;
		at: 'SCI_VCHOMEWRAPEXTEND' put: 2454;
		at: 'SCI_VERTICALCENTRECARET' put: 2619;
		at: 'SCI_VISIBLEFROMDOCLINE' put: 2220;
		at: 'SCI_WORDENDPOSITION' put: 2267;
		at: 'SCI_WORDLEFT' put: 2308;
		at: 'SCI_WORDLEFTEND' put: 2439;
		at: 'SCI_WORDLEFTENDEXTEND' put: 2440;
		at: 'SCI_WORDLEFTEXTEND' put: 2309;
		at: 'SCI_WORDPARTLEFT' put: 2390;
		at: 'SCI_WORDPARTLEFTEXTEND' put: 2391;
		at: 'SCI_WORDPARTRIGHT' put: 2392;
		at: 'SCI_WORDPARTRIGHTEXTEND' put: 2393;
		at: 'SCI_WORDRIGHT' put: 2310;
		at: 'SCI_WORDRIGHTEND' put: 2441;
		at: 'SCI_WORDRIGHTENDEXTEND' put: 2442;
		at: 'SCI_WORDRIGHTEXTEND' put: 2311;
		at: 'SCI_WORDSTARTPOSITION' put: 2266;
		at: 'SCI_WRAPCOUNT' put: 2235;
		at: 'SCI_ZOOMIN' put: 2333;
		at: 'SCI_ZOOMOUT' put: 2334;
		at: 'SCK_ADD' put: 310;
		at: 'SCK_BACK' put: 8;
		at: 'SCK_DELETE' put: 308;
		at: 'SCK_DIVIDE' put: 312;
		at: 'SCK_DOWN' put: 300;
		at: 'SCK_END' put: 305;
		at: 'SCK_ESCAPE' put: 7;
		at: 'SCK_HOME' put: 304;
		at: 'SCK_INSERT' put: 309;
		at: 'SCK_LEFT' put: 302;
		at: 'SCK_MENU' put: 315;
		at: 'SCK_NEXT' put: 307;
		at: 'SCK_PRIOR' put: 306;
		at: 'SCK_RETURN' put: 13;
		at: 'SCK_RIGHT' put: 303;
		at: 'SCK_RWIN' put: 314;
		at: 'SCK_SUBTRACT' put: 311;
		at: 'SCK_TAB' put: 9;
		at: 'SCK_UP' put: 301;
		at: 'SCK_WIN' put: 313;
		at: 'SCLEX_A68K' put: 100;
		at: 'SCLEX_ABAQUS' put: 84;
		at: 'SCLEX_ADA' put: 20;
		at: 'SCLEX_APDL' put: 61;
		at: 'SCLEX_AS' put: 113;
		at: 'SCLEX_ASM' put: 34;
		at: 'SCLEX_ASN1' put: 63;
		at: 'SCLEX_ASYMPTOTE' put: 85;
		at: 'SCLEX_AU3' put: 60;
		at: 'SCLEX_AUTOMATIC' put: 1000;
		at: 'SCLEX_AVE' put: 19;
		at: 'SCLEX_AVS' put: 104;
		at: 'SCLEX_BAAN' put: 31;
		at: 'SCLEX_BASH' put: 62;
		at: 'SCLEX_BATCH' put: 12;
		at: 'SCLEX_BIBTEX' put: 116;
		at: 'SCLEX_BLITZBASIC' put: 66;
		at: 'SCLEX_BULLANT' put: 27;
		at: 'SCLEX_CAML' put: 65;
		at: 'SCLEX_CLW' put: 45;
		at: 'SCLEX_CLWNOCASE' put: 46;
		at: 'SCLEX_CMAKE' put: 80;
		at: 'SCLEX_COBOL' put: 92;
		at: 'SCLEX_COFFEESCRIPT' put: 102;
		at: 'SCLEX_CONF' put: 17;
		at: 'SCLEX_CONTAINER' put: 0;
		at: 'SCLEX_CPP' put: 3;
		at: 'SCLEX_CPPNOCASE' put: 35;
		at: 'SCLEX_CSOUND' put: 74;
		at: 'SCLEX_CSS' put: 38;
		at: 'SCLEX_D' put: 79;
		at: 'SCLEX_DIFF' put: 16;
		at: 'SCLEX_DMAP' put: 112;
		at: 'SCLEX_DMIS' put: 114;
		at: 'SCLEX_ECL' put: 105;
		at: 'SCLEX_EIFFEL' put: 23;
		at: 'SCLEX_EIFFELKW' put: 24;
		at: 'SCLEX_ERLANG' put: 53;
		at: 'SCLEX_ERRORLIST' put: 10;
		at: 'SCLEX_ESCRIPT' put: 41;
		at: 'SCLEX_F77' put: 37;
		at: 'SCLEX_FLAGSHIP' put: 73;
		at: 'SCLEX_FORTH' put: 52;
		at: 'SCLEX_FORTRAN' put: 36;
		at: 'SCLEX_FREEBASIC' put: 75;
		at: 'SCLEX_GAP' put: 81;
		at: 'SCLEX_GUI4CLI' put: 58;
		at: 'SCLEX_HASKELL' put: 68;
		at: 'SCLEX_HTML' put: 4;
		at: 'SCLEX_IHEX' put: 118;
		at: 'SCLEX_INNOSETUP' put: 76;
		at: 'SCLEX_KIX' put: 57;
		at: 'SCLEX_KVIRC' put: 110;
		at: 'SCLEX_LATEX' put: 14;
		at: 'SCLEX_LISP' put: 21;
		at: 'SCLEX_LITERATEHASKELL' put: 108;
		at: 'SCLEX_LOT' put: 47;
		at: 'SCLEX_LOUT' put: 40;
		at: 'SCLEX_LUA' put: 15;
		at: 'SCLEX_MAGIK' put: 87;
		at: 'SCLEX_MAKEFILE' put: 11;
		at: 'SCLEX_MARKDOWN' put: 98;
		at: 'SCLEX_MATLAB' put: 32;
		at: 'SCLEX_METAPOST' put: 50;
		at: 'SCLEX_MMIXAL' put: 44;
		at: 'SCLEX_MODULA' put: 101;
		at: 'SCLEX_MSSQL' put: 55;
		at: 'SCLEX_MYSQL' put: 89;
		at: 'SCLEX_NIMROD' put: 96;
		at: 'SCLEX_NNCRONTAB' put: 26;
		at: 'SCLEX_NSIS' put: 43;
		at: 'SCLEX_NULL' put: 1;
		at: 'SCLEX_OCTAVE' put: 54;
		at: 'SCLEX_OPAL' put: 77;
		at: 'SCLEX_OSCRIPT' put: 106;
		at: 'SCLEX_PASCAL' put: 18;
		at: 'SCLEX_PERL' put: 6;
		at: 'SCLEX_PHPSCRIPT' put: 69;
		at: 'SCLEX_PLM' put: 82;
		at: 'SCLEX_PO' put: 90;
		at: 'SCLEX_POV' put: 39;
		at: 'SCLEX_POWERBASIC' put: 51;
		at: 'SCLEX_POWERPRO' put: 95;
		at: 'SCLEX_POWERSHELL' put: 88;
		at: 'SCLEX_PROGRESS' put: 83;
		at: 'SCLEX_PROPERTIES' put: 9;
		at: 'SCLEX_PS' put: 42;
		at: 'SCLEX_PUREBASIC' put: 67;
		at: 'SCLEX_PYTHON' put: 2;
		at: 'SCLEX_R' put: 86;
		at: 'SCLEX_REBOL' put: 71;
		at: 'SCLEX_REGISTRY' put: 115;
		at: 'SCLEX_RUBY' put: 22;
		at: 'SCLEX_RUST' put: 111;
		at: 'SCLEX_SCRIPTOL' put: 33;
		at: 'SCLEX_SMALLTALK' put: 72;
		at: 'SCLEX_SML' put: 97;
		at: 'SCLEX_SORCUS' put: 94;
		at: 'SCLEX_SPECMAN' put: 59;
		at: 'SCLEX_SPICE' put: 78;
		at: 'SCLEX_SQL' put: 7;
		at: 'SCLEX_SREC' put: 117;
		at: 'SCLEX_STTXT' put: 109;
		at: 'SCLEX_TACL' put: 93;
		at: 'SCLEX_TADS3' put: 70;
		at: 'SCLEX_TAL' put: 91;
		at: 'SCLEX_TCL' put: 25;
		at: 'SCLEX_TCMD' put: 103;
		at: 'SCLEX_TEHEX' put: 119;
		at: 'SCLEX_TEX' put: 49;
		at: 'SCLEX_TXT2TAGS' put: 99;
		at: 'SCLEX_VB' put: 8;
		at: 'SCLEX_VBSCRIPT' put: 28;
		at: 'SCLEX_VERILOG' put: 56;
		at: 'SCLEX_VHDL' put: 64;
		at: 'SCLEX_VISUALPROLOG' put: 107;
		at: 'SCLEX_XCODE' put: 13;
		at: 'SCLEX_XML' put: 5;
		at: 'SCLEX_YAML' put: 48;
		at: 'SCMOD_ALT' put: 4;
		at: 'SCMOD_CTRL' put: 2;
		at: 'SCMOD_META' put: 16;
		at: 'SCMOD_NORM' put: 0;
		at: 'SCMOD_SHIFT' put: 1;
		at: 'SCMOD_SUPER' put: 8;
		at: 'SCN_AUTOCCANCELLED' put: 2025;
		at: 'SCN_AUTOCCHARDELETED' put: 2026;
		at: 'SCN_AUTOCCOMPLETED' put: 2030;
		at: 'SCN_AUTOCSELECTION' put: 2022;
		at: 'SCN_CALLTIPCLICK' put: 2021;
		at: 'SCN_CHARADDED' put: 2001;
		at: 'SCN_DOUBLECLICK' put: 2006;
		at: 'SCN_DWELLEND' put: 2017;
		at: 'SCN_DWELLSTART' put: 2016;
		at: 'SCN_FOCUSIN' put: 2028;
		at: 'SCN_FOCUSOUT' put: 2029;
		at: 'SCN_HOTSPOTCLICK' put: 2019;
		at: 'SCN_HOTSPOTDOUBLECLICK' put: 2020;
		at: 'SCN_HOTSPOTRELEASECLICK' put: 2027;
		at: 'SCN_INDICATORCLICK' put: 2023;
		at: 'SCN_INDICATORRELEASE' put: 2024;
		at: 'SCN_KEY' put: 2005;
		at: 'SCN_MACRORECORD' put: 2009;
		at: 'SCN_MARGINCLICK' put: 2010;
		at: 'SCN_MODIFIED' put: 2008;
		at: 'SCN_MODIFYATTEMPTRO' put: 2004;
		at: 'SCN_NEEDSHOWN' put: 2011;
		at: 'SCN_PAINTED' put: 2013;
		at: 'SCN_SAVEPOINTLEFT' put: 2003;
		at: 'SCN_SAVEPOINTREACHED' put: 2002;
		at: 'SCN_STYLENEEDED' put: 2000;
		at: 'SCN_UPDATEUI' put: 2007;
		at: 'SCN_URIDROPPED' put: 2015;
		at: 'SCN_USERLISTSELECTION' put: 2014;
		at: 'SCN_ZOOM' put: 2018;
		at: 'SCVS_NONE' put: 0;
		at: 'SCVS_RECTANGULARSELECTION' put: 1;
		at: 'SCVS_USERACCESSIBLE' put: 2;
		at: 'SCWS_INVISIBLE' put: 0;
		at: 'SCWS_VISIBLEAFTERINDENT' put: 2;
		at: 'SCWS_VISIBLEALWAYS' put: 1;
		at: 'SCWS_VISIBLEONLYININDENT' put: 3;
		at: 'STYLE_BRACEBAD' put: 35;
		at: 'STYLE_BRACELIGHT' put: 34;
		at: 'STYLE_CALLTIP' put: 38;
		at: 'STYLE_CONTROLCHAR' put: 36;
		at: 'STYLE_DEFAULT' put: 32;
		at: 'STYLE_INDENTGUIDE' put: 37;
		at: 'STYLE_LASTPREDEFINED' put: 39;
		at: 'STYLE_LINENUMBER' put: 33;
		at: 'STYLE_MAX' put: 255;
		at: 'STYLE_NORMAL' put: 0;
		at: 'UNDO_MAY_COALESCE' put: 1;
		at: 'VISIBLE_SLOP' put: 1;
		at: 'VISIBLE_STRICT' put: 4;
		shrink;
		yourself)!

drawingPhases
	^#(#one #two #multiple)!

edgeModes
	"Answer the symbolic names of the long-line edge marking modes supported by Scintilla."

	^#(#none #line #background)!

foldMarkerStyles
	^#(#arrows #boxTree #circleTree #plusMinus)!

fontQualities
	^#(#default #unaliased #antialiased #lcdOptimized)!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

imeInteractionModes
	^#(#windowed #inline)!

immutableCopyOfCollection: aCollection 
	^(aCollection collect: 
			[:each | 
			(each copy)
				isImmutable: true;
				yourself])
		isImmutable: true;
		yourself!

indentationGuideStyles
	^#(#real #lookForward #lookBoth)!

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
!

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
	ScnMap := (Array new: 31)
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
				at: SCN_FOCUSIN - 1999 put: #scnFocusIn:;
				at: SCN_FOCUSOUT - 1999 put: #scnFocusOut:;
				at: SCN_AUTOCCOMPLETED - 1999 put: #scnAutoCCompleted:;
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
	"Private - Convert from earlier version view by updating and answering the array of instance variables
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

	^#(#invisible #visibleAlways #visibleAfterIndent #visibleOnlyInIndent)!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	"Ensure the DLL has been loaded"

	ScintillaLibrary realize.
	^'Scintilla'!

wrapIndentModes
	^#(#fixed #same #indent)!

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
!ScintillaView class categoriesFor: #autoCompletionSortModes!constants!private! !
!ScintillaView class categoriesFor: #caretStyles!constants!public! !
!ScintillaView class categoriesFor: #codePages!constants!public! !
!ScintillaView class categoriesFor: #defaultAnnotationStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #defaultCallTipStyle!constants!public!style definition! !
!ScintillaView class categoriesFor: #defaultKeyMap!constants!private! !
!ScintillaView class categoriesFor: #defaultTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #defineConstantsPool!**auto generated**!development!public! !
!ScintillaView class categoriesFor: #drawingPhases!constants!private! !
!ScintillaView class categoriesFor: #edgeModes!constants!public! !
!ScintillaView class categoriesFor: #foldMarkerStyles!constants!public! !
!ScintillaView class categoriesFor: #fontQualities!constants!public! !
!ScintillaView class categoriesFor: #icon!constants!public! !
!ScintillaView class categoriesFor: #imeInteractionModes!constants!private! !
!ScintillaView class categoriesFor: #immutableCopyOfCollection:!helpers!private! !
!ScintillaView class categoriesFor: #indentationGuideStyles!constants!private! !
!ScintillaView class categoriesFor: #initialize!development!initializing!private! !
!ScintillaView class categoriesFor: #initializeLexerLanguages!development!initializing!private! !
!ScintillaView class categoriesFor: #initializeNotificationMap!**auto generated**!must not strip!public!scintilla interface! !
!ScintillaView class categoriesFor: #layoutCachingModes!constants!public! !
!ScintillaView class categoriesFor: #lineEndings!constants!public! !
!ScintillaView class categoriesFor: #multiPasteModes!constants!public! !
!ScintillaView class categoriesFor: #selectionModes!constants!public! !
!ScintillaView class categoriesFor: #smalltalkTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #stbConvert:fromVersion:!binary filing!private! !
!ScintillaView class categoriesFor: #stbConvertFromVersion13:!binary filing!private! !
!ScintillaView class categoriesFor: #stbConvertFromVersion9:!binary filing!private! !
!ScintillaView class categoriesFor: #stbVersion!binary filing!public! !
!ScintillaView class categoriesFor: #txtTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #whitespaceVisibilityLevels!constants!public! !
!ScintillaView class categoriesFor: #winClassName!constants!private! !
!ScintillaView class categoriesFor: #wrapIndentModes!constants!public! !
!ScintillaView class categoriesFor: #xmlTextStyles!constants!public!style definition! !

