"Filed out from Dolphin Smalltalk 7"!

MultilineTextEdit subclass: #ScintillaView
	instanceVariableNames: 'this currentTextStyles styleIdMap styler markerDefinitions markers wordChars registeredImages modificationEventMask autoCStops autoCFillups whitespaceBackcolor whitespaceForecolor selectionBackcolor selectionForecolor indicators callTipTabWidth punctuation callTipHighlightColor braceChars whitespaces scFlags allTextStyles foldMarginColor foldMarginHiColor foldMarkerStyle foldFlags codePage keyBindings indicatorStyles secondarySelectionForecolor secondarySelectionBackcolor annotationStyles foldTextTagStyle'
	classVariableNames: 'AnnotationStylesOffset BackgroundDwellEvents BraceHilightingMask CodePages DefaultCallTipTabWidth DefaultKeyBindings DefaultTextStyles FoldingMask MarginStylesOffset ScnMap'
	poolDictionaries: 'ScintillaConstants Win32Constants'
	classInstanceVariableNames: ''!
ScintillaView guid: (GUID fromString: '{47a3310b-b7e4-4aa9-b6e6-640ad9fe7a3a}')!
ScintillaView addClassConstant: 'AnnotationStylesOffset' value: 16r200!
ScintillaView addClassConstant: 'BackgroundDwellEvents' value: 16r4!
ScintillaView addClassConstant: 'BraceHilightingMask' value: 16r1!
ScintillaView addClassConstant: 'DefaultCallTipTabWidth' value: 16r20!
ScintillaView addClassConstant: 'FoldingMask' value: 16r2!
ScintillaView addClassConstant: 'MarginStylesOffset' value: 16r100!
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
			newText nextPut: $\n.
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
	self sciAssignCmdKey: aScintillaKeyBinding scintillaKeyCode sciCommand: aScintillaKeyBinding message.
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

	self sciAddSelection: anInterval stop + 1 anchor: anInterval start!

anchorPosition
	"Returns the position of the opposite end of the selection to the caret."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETANCHOR
				wParam: 0
				lParam: 0) + 1]!

anchorPosition: anchorInteger
	"Set the selection anchor to a position. The anchor is the opposite end of the selection
	from the caret."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETANCHOR
				wParam: anchorInteger - 1
				lParam: 0]!

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
			[text nextPut: $\n.
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
	linesOfText := text subStrings: $\n.
	count := linesOfText size.
	^count == 1
		ifTrue: 
			[{ScintillaAnnotation
					line: line
					text: text
					styles: (self annotationStylesFromStyleBytes: aScintillaAnnotation styles)}]
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

areAdditionalCaretsVisible: additionalCaretsVisibleBoolean
	"Set whether additional carets are visible"

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETADDITIONALCARETSVISIBLE
				wParam: additionalCaretsVisibleBoolean asParameter
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

	^autoCFillups ?? ''!

autoCompletionAcceptChars: aString 
	"Set the <String> of characters that, when typed, will cause the auto-completion list to
	choose the currently selected item."

	autoCFillups := aString isEmpty ifFalse: [aString].
	self sciAutoCSetFillUps: aString!

autoCompletionCancelChars
	"Answer the <String> of character that, when typed, will cancel an auto-completion list."

	^autoCStops ?? ''!

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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
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

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_AUTOCPOSSTART
				wParam: 0
				lParam: 0) + 1]!

autoCompletionSeparator
	"Answer the <Character> used as the separator between entries in an auto-completion list <String>."

	^Character value: self sciAutoCGetSeparator!

autoCompletionSeparator: aCharacter 
	"Set the <Character> used as the separator between entries in an auto-completion list
	string. The default is a space but this should be be changed if entries may contain such."

	self sciAutoCSetSeparator: aCharacter asInteger!

autoCompletionSortMode
	"Answer the <Character> used as the separator between entries in an auto-completion list <String>."

	^self class autoCompletionSortModes at: self sciAutoCGetOrder + 1!

autoCompletionSortMode: aSymbol 
	^self sciAutoCSetOrder: (self class autoCompletionSortModes indexOf: aSymbol) - 1!

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
			self sciIndicatorClearRange: 1 lengthClear: length]!

basicClearSelection
	"Private - Clear the selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_CLEAR
				wParam: 0
				lParam: 0]!

basicLineFromPosition: posInteger
	"Private - Retrieve the line containing a position."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_LINEFROMPOSITION
				wParam: posInteger
				lParam: 0]!

basicPositionAtLine: lineInteger
	"Private - Retrieve the position at the start of a line."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_POSITIONFROMLINE
				wParam: lineInteger
				lParam: 0]!

basicRemoveAllAnnotations
	"Private - Clear the annotations from all lines"

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_ANNOTATIONCLEARALL
				wParam: 0
				lParam: 0]!

basicSelectAll
	"Private - Select all the text in the document."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SELECTALL
				wParam: 0
				lParam: 0]!

basicSelectionStart: anchorInteger end: caretInteger
	"Private - Select a range of text."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSEL
				wParam: anchorInteger
				lParam: caretInteger]!

basicUndo
	"Private - Undo one action in the undo history."

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
	availableStyles := ((offset + 1 to: offset + 255 - 1) difference: allocatedStyles) 
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

buildItemList: aCollection withIcons: aBoolean
	| itemList sep typesep |
	itemList := self stringClass writeStream.
	sep := self autoCompletionSeparator.
	typesep := self autoCompletionImageIdSeparator.
	aCollection do: 
			[:each |
			itemList display: each.
			aBoolean
				ifTrue: 
					[itemList
						nextPut: typesep;
						display: (self imageIndexForIcon: each icon)].
			itemList nextPut: sep].
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
		asSortedCollectionUsing: (MergesortAlgorithm newSortBlock: [:a :b | a line < b line])) do: 
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
						text nextPut: $\n.
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

	^callTipHighlightColor ifNil: [Color darkBlue]!

callTipHighlightColor: aColorOrNil 
	"Set the foreground <Color> for the highlighted part of the call tip. If the argument is nil
	then the default colour (dark blue) is set."

	(callTipHighlightColor := aColorOrNil) isNil 
		ifTrue: [self sciCallTipSetForeHlt: nil]
		ifFalse: [self setCallTipHighlightColor]!

callTipPosition
	"Retrieve the position where the caret was before displaying the call tip."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_CALLTIPPOSSTART
				wParam: 0
				lParam: 0) + 1]!

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
	"Returns the position of the caret."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETCURRENTPOS
				wParam: 0
				lParam: 0) + 1]!

caretPosition: caretInteger
	"Set caret to a position, while removing any existing selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETEMPTYSELECTION
				wParam: caretInteger - 1
				lParam: 0]!

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
	"Answer the <Character> at the specified one-based <integer> index in the receiver's text.
	When the view is in UTF-8 mode, the returned <Character> may be a leading or trailing surrogate."

	| ch |
	ch := (self sciGetCharAt: anInteger) bitAnd: 16rFF.
	^codePage == SC_CP_UTF8
		ifTrue: [Character utf8Value: ch]
		ifFalse: [Character ansiValue: ch]!

charCloseToPosition: aPoint
	"Answer the one-based index of the character closest to the specified <Point> within the
	receiver, or 0 if the co-ordinate is outside the window or not 'close' to any character."

	^self sciCharPositionFromPointClose: aPoint x y: aPoint y!

charNearestPosition: aPoint
	"Answer the one-based index of the character nearest the specified <Point> within the
	receiver."

	^self sciCharPositionFromPoint: aPoint x y: aPoint y!

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
	self sciIndicatorClearRange: startInteger lengthClear: stopInteger - startInteger + 1!

clearRange: anInterval
	"Delete a range of text from the view."

	self sciDeleteRange: anInterval start lengthDelete: anInterval size!

codePage
	"Answer a <Symbol> naming the code page currently in use. Note that the multi-byte code
	pages supported by Scintilla such as 932, or 936, will not work correctly in Dolphin as
	there is basic support for multi-byte strings other than in UTF representations. Where
	international character support is desired, the UTF-8 mode should be used."

	^CodePages lookup: codePage!

codePage: aSymbol
	"Set the code page currently in use to that named by the <Symbol> argument (one of #utf8, #ansi)."

	codePage := aSymbol ifNil: [0] ifNotNil: [CodePages keyAtValue: aSymbol].
	self sciSetCodePage: codePage!

columnFromPosition: anInteger
	"Answer the column number of the character at the specified position."

	"From the Scintilla documentation:' This message returns the column number of a position pos
	within the document taking the width of tabs into account. This returns the column number of
	the last tab on the line before pos, plus the number of characters between the last tab and
	pos. If there are no tab characters on the line, the return value is the number of
	characters up to the position on the line. In both cases, double byte characters count as a
	single character. This is probably only useful with monospaced fonts.'"

	^(self sciGetColumn: anInteger) + 1!

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

	self sciCopyRange: anInterval start end: anInterval stop + 1!

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

currentLineFrameWidth
	"Retrieve the caret line frame width. Width = 0 means this option is disabled."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETCARETLINEFRAME
				wParam: 0
				lParam: 0]!

currentLineFrameWidth: widthInteger
	"Display the caret line framed. Set width !!= 0 to enable this option and width = 0 to
	disable it."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETCARETLINEFRAME
				wParam: widthInteger
				lParam: 0]!

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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len - 1.
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
			style := stream next.
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

	^##((IdentityDictionary new)
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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
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
		#multiline - similar to #line but allows a configurable set of vertical lines to be shown simultaneously. 
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

	self sciScrollRange: anInterval stop + 1 primary: anInterval start!

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

errorStatus: statusInteger
	"Change error status - 0 = OK."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSTATUS
				wParam: statusInteger
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
	"Extend selection down one paragraph (delimited by empty lines)."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_PARADOWNEXTEND
				wParam: 0
				lParam: 0]!

extendParaUp
	"Extend selection up one paragraph (delimited by empty lines)."

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
	"Like LineEndExtend but when word-wrap is enabled extends first to end of display line
	LineEndDisplayExtend, then to start of document line LineEndExtend."

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
	"Like HomeExtend but when word-wrap is enabled extends first to start of display line
	HomeDisplayExtend, then to start of document line HomeExtend."

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
	"Like VCHomeExtend but when word-wrap is enabled extends first to start of display line
	VCHomeDisplayExtend, then behaves like VCHomeExtend."

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
				text: (self stringClass fromString: aString).
	self sciFindText: anInteger ft: findText.
	range := findText chrgText.
	^range cpMin + 1 to: range cpMax!

findAutoCompletionEntry: selectString
	"Select the item in the auto-completion list that starts with a string."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_AUTOCSELECT
				wParam: 0
				lpParam: selectString]!

findMatchingBrace: anInteger
	"Answer the one-based <integer> index of the character in the receiver which is the brace
	matching that at the one-based <integer> index argument. If there is no matching brace, or
	the character at the specified position is not itself a brace character, then answer zero.
	Note that for two brace characters to be considered a match they must have the same style."

	^self sciBraceMatch: anInteger maxReStyle: 0!

findString: aString startingAt: anInteger 

	self 
		sciSetTargetRange: anInteger 
		end: self textLength + 1.
	^(self
		sciSearchInTarget: aString size 
		text: aString) + 1
!

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

foldTextTagStyle
	"Answer the symbolic name of the current fold text tag style:
		nil		- unspecified (uses current Scintilla default, i.e. #hidden)
		#hidden	- text tags are not displayed
		#standard	- text tags are displayed
		#boxed	- text tags are displayed with a box drawn around them"

	^foldTextTagStyle!

foldTextTagStyle: aSymbolOrNil
	"Set the appearance of fold text tags - see #foldTextTagStyle for more details."

	foldTextTagStyle := aSymbolOrNil.
	self setFoldTextTagStyle!

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

goto: caretInteger
	"Set caret to a position and ensure it is visible."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GOTOPOS
				wParam: caretInteger - 1
				lParam: 0]!

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

hasSelection
	"Answer true if the receiver has a selected range of text."

	^self selectionRange isEmpty not!

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

hideIndicators
	"Private - Reconfigure all indicator styles to hidden apart from the default 3 pre-configured styles."

	| lib |
	this ifNil: [^self].
	lib := ScintillaLibrary default.
	3 to: INDIC_MAX
		do: 
			[:each |
			lib
				directFunction: this
				msg: SCI_INDICSETSTYLE
				wParam: each
				lParam: INDIC_HIDDEN]!

hideSelection: hideBoolean
	"Draw the selection either highlighted or in normal (non-highlighted) style."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_HIDESELECTION
				wParam: hideBoolean asParameter
				lParam: 0]!

highlightBracesAt: posAInteger and: posBInteger
	"Highlight the characters at two positions."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_BRACEHIGHLIGHT
				wParam: posAInteger - 1
				lParam: posBInteger - 1]!

highlightCallTipFrom: startInteger to: stopInteger 
	"Highlight a range of the text in the call tip."

	self sciCallTipSetHlt: startInteger - 1 highlightEnd: stopInteger - 1!

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

highlightMismatchedBrace: posInteger
	"Highlight the character at a position indicating there is no matching brace."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_BRACEBADLIGHT
				wParam: posInteger - 1
				lParam: 0]!

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

identifyTextMatchingSelectionWithStyleName: aSymbol

	| index newIndicators selection selectionStart |
	"get a list of indicators that aren't related to secondary selection"
	newIndicators := self indicators reject: [:each | each styleName = aSymbol]. 
	"If no current selection, then we are done"
	(selection := self selection) isEmpty ifTrue: [
		self indicators: newIndicators.
		^self
	].

	newIndicators = #() ifTrue: [newIndicators := OrderedCollection new].
	index := 0.
	selectionStart := self selectionRange start.
	[
		index := self findString: selection startingAt: index + 1.
		0 < index.
	] whileTrue: [
		| end |
		end := index + selection size - 1.
		index ~~ selectionStart ifTrue: [
			newIndicators add: (ScintillaIndicator
				styleName: aSymbol
				range: (index to: end) 
				tag: nil).
			index := end + 1.
		].
	].
	self indicators: newIndicators.
!

idleStylingMode
	^self class idleStylingModes at: self sciGetIdleStyling + 1!

idleStylingMode: aSymbol 
	^self sciSetIdleStyling: (self class idleStylingModes indexOf: aSymbol ifAbsent: [1]) - 1!

idOfStyleNamed: aSymbol 
	^(self styleNamed: aSymbol) ifNil: [0] ifNotNil: [:style | style id]!

imageIndexForIcon: anIcon
	^registeredImages at: anIcon
		ifAbsentPut: 
			[| type bmp |
			type := registeredImages size.
			bmp := anIcon asMenuBitmap.
			type = 0
				ifTrue: 
					[| ext |
					ext := bmp extent.
					self
						sciRGBAImageSetWidth: ext x;
						sciRGBAImageSetHeight: ext y].
			self sciRegisterRGBAImage: type pixels: (self rgbaBitsFromBitmap: bmp).
			type]!

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

	^self class indentationGuideStyles lookup: self sciGetIndentationGuides!

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

indicatorIdFromName: anIntegerOrSymbol
	^anIntegerOrSymbol isInteger
		ifTrue: 
			[(anIntegerOrSymbol between: 0 and: INDIC_MAX)
				ifFalse: [self error: 'Indicator id is out of range: ' , anIntegerOrSymbol printString].
			anIntegerOrSymbol]
		ifFalse: 
			[(indicatorStyles ifNotNil: [:indics | indics lookup: anIntegerOrSymbol])
				ifNil: [-1	"Indicator is not configured in the view, not necessarily an error"]
				ifNotNil: [:indicStyle | indicStyle id]]!

indicatorMaskAt: posInteger
	"Are any indicators present at pos?"

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_INDICATORALLONFOR
				wParam: posInteger - 1
				lParam: 0]!

indicators
	"Answer a <collection> of <ScintillaIndicator>s, being the indicators (e.g. squiggly
	underlines) associated with ranges of text in the receiver."

	^indicators ?? #()!

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

	self setIndicatorStyles: aCollection ?? #()!

indicatorsUnder: aPoint 
	^self indicatorsAt: (self charCloseToPosition: aPoint)!

initialize
	| styles |
	super initialize.
	markerDefinitions := self defaultMarkerDefinitions.
	markers := IdentitySet new.
	allTextStyles := IdentityDictionary new.
	styles := self class defaultTextStyles.
	self setCurrentTextStyles: styles.
	selectionBackcolor := Color gray.
	codePage := scFlags := 0.
	self initializeRegisteredImages.!

initializeControl
	"Private - Prime the Scintilla control with any settings stored in instance variables that
	differ from the defaults."

	"Discard registered images rather than restoring - these can be re-registered dynamically as required"

	self initializeRegisteredImages.
	self sciSetModEventMask: self modificationEventMask.
	"Not necessary.
		self sciUsePopup: false asParameter."
	self setCallTipTabWidth.
	self
		marginStylesOffset: MarginStylesOffset;
		updateIndicatorStyles;
		updateTextStyles;
		updateMarkerDefinitions.
	styler ifNotNil: [self invalidateStyling].
	codePage == 0 ifFalse: [self sciSetCodePage: codePage].
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
	keyBindings ifNotNil: [self updateKeyBindings].
	foldTextTagStyle ifNotNil: [self setFoldTextTagStyle]!

initializeRegisteredImages
	registeredImages := LookupTable new!

insertText: aString at: anInteger
	"Insert text at the specified position without moving the caret."

	self sciInsertText: anInteger text: aString!

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

isAccessibilityEnabled
	"Answer whether accessibility features are currently enabled."

	^self sciGetAccessibility asBoolean!

isAccessibilityEnabled: aBoolean
	"Set whether accessibility features are currently enabled."

	self sciSetAccessibility: aBoolean asParameter!

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
	^(self braceChars lookup: style)
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

isInSelectionExtendMode
	"Get whether or not regular caret moves will extend or reduce the selection."

	^this isNil
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETMOVEEXTENDSSELECTION
				wParam: 0
				lParam: 0) asBoolean]!

isLine: lineInteger folded: expandedBoolean 
	"Fold/unfold the specified header line, depending on the value of the <boolean> argument."

	self sciSetFoldExpanded: lineInteger - 1 expanded: expandedBoolean!

isLine: anInteger markedWith: aSymbol
	"Answer whether the line in the receiver with the specified one-based <integer>
	index has the named marker."

	| def |
	def := markerDefinitions lookup: aSymbol.
	^def notNil and: [(self sciMarkerGet: anInteger - 1) allMask: (1 bitShift: def id)]!

isLineVisible: anInteger 
	"Answer whether the line with the specified one-based <integer> index is visible"

	^self sciGetLineVisible: anInteger - 1!

isMouseWheelCaptured
	"Get whether mouse wheel can be active outside the window."

	^this isNil
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETMOUSEWHEELCAPTURES
				wParam: 0
				lParam: 0) asBoolean]!

isMouseWheelCaptured: capturesBoolean
	"Set whether the mouse wheel can be active outside the window."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETMOUSEWHEELCAPTURES
				wParam: capturesBoolean asParameter
				lParam: 0]!

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

isOvertypeEnabled: overTypeBoolean
	"Set to overtype (true) or insert mode."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETOVERTYPE
				wParam: overTypeBoolean asParameter
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
	keyBindings := nil.
	aCollectionOfScintillaKeyBindings 
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
	^id == SCLEX_AUTOMATIC ifTrue: [#automatic] ifFalse: [self class lexerLanguages lookup: id + 1]!

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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_GETLEXERLANGUAGE
				wParam: 0
				lpParam: result.
			result]!

lexerNamedStyles
	"Answer the names of the styles supported by the current lexer."

	| count styles |
	count := self sciGetNamedStyles.
	styles := Array writeStream: count.
	1 to: count
		do: 
			[:i |
			| style |
			style := ScintillaLexerNamedStyle view: self id: i - 1.
			style name isEmpty ifFalse: [styles nextPut: style]].
	^styles contents!

lexerProperties
	"Answer a <collection> of the <ScintillaLexerProperty> objects representing the current lexers' properties."

	^self sciPropertyNames subStrings collect: [:each | ScintillaLexerProperty view: self id: each]!

lexerPropertyNames
	"Answer a <collection> of the <String> names of the current lexers' properties."

	^self sciPropertyNames subStrings!

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
	end := (self sciGetLineEndPosition: pos) - 1.
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
	"Answer the maximum number of margins that can be displayed. As of Scintilla 3.7.0
	this is no longer fixed at three."

	^self sciGetMargins!

marginCount: anInteger
	"Set the maximum number of margins that can be displayed. As of Scintilla 3.7.0
	this is no longer fixed at three."

	^self sciSetMargins: anInteger!

margins
	"Answer a <sequencedReadableCollection> of <ScintillaMargin> containing all the receiver's
	margins."

	^(1 to: self marginCount) collect: [:index | ScintillaMargin view: self index: index - 1]!

margins: aSequenceableCollection 
	"Set the receiver's collection of margins to the <sequencedReadableCollection> of <ScintillaMargin> 
	argument."

	self marginCount: aSequenceableCollection size.
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

	^{self sciGetMarginLeft. self sciGetMarginRight}!

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

	markers := aCollection asIdentitySet.
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
	"Move caret down one paragraph (delimited by empty lines)."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_PARADOWN
				wParam: 0
				lParam: 0]!

moveParaUp
	"Move caret up one paragraph (delimited by empty lines)."

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
	"Like LineEnd but when word-wrap is enabled goes first to end of display line
	LineEndDisplay, then to start of document line LineEnd."

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
	"Like Home but when word-wrap is enabled goes first to start of display line HomeDisplay,
	then to start of document line Home."

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
	"Like VCHome but when word-wrap is enabled goes first to start of display line
	VCHomeDisplay, then behaves like VCHome."

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

newNotification: pSCNotification
	^(SCNotification fromAddress: pSCNotification)
		view: self;
		yourself!

newTextBuffer: anInteger
	^self stringClass newFixed: anInteger!

nmNotify: pNMHDR
	"Private - Handler for a redirected generic WM_NOTIFY message."

	^(ScnMap lookup: (pNMHDR sdwordAtOffset: 8) - 1999)
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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len - 1.
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
	range := TEXTRANGE from: startInteger - 1 to: stopInteger type: self stringClass.
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

	^(self sciPointXFromPosition: anInteger) @ (self sciPointYFromPosition: anInteger)!

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
			styleId := (annotationStyles lookup: eachStyleName) ifNil: [0] ifNotNil: [:style | style id].
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

	^(positionInteger > 0 and: [self isIndicator: anIntegerOrSymbol setAt: positionInteger])
		ifTrue: 
			[| id |
			id := self indicatorIdFromName: anIntegerOrSymbol.
			(self sciIndicatorStart: id pos: positionInteger) + 1
				to: (self sciIndicatorEnd: id pos: positionInteger)]
		ifFalse: 
			["The interval occuppied by the indicator that intersects the position is empty"
			positionInteger to: positionInteger - 1]!

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

removeAllEdges
	"Clear all vertical edges."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_MULTIEDGECLEARALL
				wParam: 0
				lParam: 0]!

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

	self highlightBracesAt: 0 and: 0!

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

	self
		startStylingFrom: startInteger;
		styleNext: stopInteger - startInteger + 1 mask: 0!

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

restyleFrom: startInteger to: endInteger
	"Colourise a segment of the document using the current lexing language."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_COLOURISE
				wParam: startInteger - 1
				lParam: endInteger - 1]!

reverseSelectedLines
	"Reverse order of selected lines."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_LINEREVERSE
				wParam: 0
				lParam: 0]!

rgbaBitsFromBitmap: aDIBSection
	"Private - Return a <ByteArray> representing the <DIBSection> in RGBA format (as opposed to the native Windows BRGA format)."

	| bgra rgba count ext |
	#todo.	"This is going to be slow, even given the small size of the icons. Find a faster way to perform this conversion."
	ext := aDIBSection extent.
	count := ext x * ext y * 4.
	bgra := aDIBSection imageBits.
	rgba := ByteArray newFixed: count.
	1 to: count
		by: 4
		do: 
			[:i |
			rgba
				at: i put: (bgra at: i + 2);
				at: i + 1 put: (bgra at: i + 1);
				at: i + 2 put: (bgra at: i);
				at: i + 3 put: (bgra at: i + 3)].
	^rgba!

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

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_ADDSELECTION
				wParam: caretInteger - 1
				lParam: anchorInteger - 1]!

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
		ifTrue: [ByteArray empty]
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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
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

sciAssignCmdKey: keyDefinitionInteger sciCommand: sciCommandInteger
	"Private - When key+modifier combination keyDefinition is pressed perform sciCommand."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_ASSIGNCMDKEY
				wParam: keyDefinitionInteger
				lParam: sciCommandInteger]!

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

sciAutoCShow: lengthEnteredInteger itemList: itemListString
	"Private - Display a auto-completion list. The lengthEntered parameter indicates how many
	characters before the caret should be used to provide context."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_AUTOCSHOW
				wParam: lengthEnteredInteger
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

sciBraceBadLightIndicator: useSettingBoolean indicator: indicatorInteger
	"Private - Use specified indicator to highlight non matching brace instead of changing its
	style."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_BRACEBADLIGHTINDICATOR
				wParam: useSettingBoolean asParameter
				lParam: indicatorInteger]!

sciBraceHighlightIndicator: useSettingBoolean indicator: indicatorInteger
	"Private - Use specified indicator to highlight matching braces instead of changing their
	style."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_BRACEHIGHLIGHTINDICATOR
				wParam: useSettingBoolean asParameter
				lParam: indicatorInteger]!

sciBraceMatch: posInteger maxReStyle: maxReStyleInteger
	"Private - Find the position of a matching brace or INVALID_POSITION if no match. The
	maxReStyle must be 0 for now. It may be defined in a future release."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_BRACEMATCH
				wParam: posInteger - 1
				lParam: maxReStyleInteger) + 1]!

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

sciCallTipSetHlt: highlightStartInteger highlightEnd: highlightEndInteger
	"Private - Highlight a segment of the definition."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_CALLTIPSETHLT
				wParam: highlightStartInteger
				lParam: highlightEndInteger]!

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
				wParam: posInteger - 1
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
				wParam: startInteger - 1
				lParam: endInteger - 1]!

sciCharPositionFromPoint: xInteger y: yInteger
	"Private - Find the position of a character from a point within the window."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_CHARPOSITIONFROMPOINT
				wParam: xInteger
				lParam: yInteger) + 1]!

sciCharPositionFromPointClose: xInteger y: yInteger
	"Private - Find the position of a character from a point within the window. Return
	INVALID_POSITION if not close to text."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_CHARPOSITIONFROMPOINTCLOSE
				wParam: xInteger
				lParam: yInteger) + 1]!

sciClearAllCmdKeys
	"Private - Drop all key mappings."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_CLEARALLCMDKEYS
				wParam: 0
				lParam: 0]!

sciClearCmdKey: keyDefinitionInteger
	"Private - When key+modifier combination keyDefinition is pressed do nothing."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_CLEARCMDKEY
				wParam: keyDefinitionInteger
				lParam: 0]!

sciClearRepresentation: encodedCharacterString
	"Private - Remove a character representation."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_CLEARREPRESENTATION
				wpParam: encodedCharacterString
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
				wParam: startInteger - 1
				lParam: endInteger - 1]!

sciCountCharacters: startInteger end: endInteger
	"Private - Count characters between two positions."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_COUNTCHARACTERS
				wParam: startInteger - 1
				lParam: endInteger - 1]!

sciCreateDocument: bytesInteger documentOptions: documentOptionsInteger
	"Private - Create a new document object. Starts with reference count of 1 and not selected
	into editor."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_CREATEDOCUMENT
				wParam: bytesInteger
				lParam: documentOptionsInteger]!

sciDeleteRange: startInteger lengthDelete: lengthDeleteInteger
	"Private - Delete a range of text in the document."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_DELETERANGE
				wParam: startInteger - 1
				lParam: lengthDeleteInteger]!

sciDescribeProperty: nameString
	"Private - Describe a property. Result is NUL-terminated."

	| len |
	len := this
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default
						directFunction: this
						msg: SCI_DESCRIBEPROPERTY
						wpParam: nameString
						lpParam: nil].
	^len = 0
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_DESCRIBEPROPERTY
				wpParam: nameString
				lpParam: result.
			result]!

sciDescriptionOfStyle: styleInteger
	"Private - Retrieve a description of a style. Result is NUL-terminated."

	| len |
	len := this
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default
						directFunction: this
						msg: SCI_DESCRIPTIONOFSTYLE
						wParam: styleInteger
						lpParam: nil].
	^len = 0
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_DESCRIPTIONOFSTYLE
				wParam: styleInteger
				lpParam: result.
			result]!

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

sciDocLineFromVisible: displayLineInteger
	"Private - Find the document line of a display line taking hidden lines into account."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_DOCLINEFROMVISIBLE
				wParam: displayLineInteger
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

sciEncodedFromUTF8: utf8String
	"Private - Translates a UTF8 string into the document encoding. Return the length of the
	result in bytes. On error return 0."

	| len |
	len := this
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default
						directFunction: this
						msg: SCI_ENCODEDFROMUTF8
						wpParam: utf8String
						lpParam: nil].
	^len = 0
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_ENCODEDFROMUTF8
				wpParam: utf8String
				lpParam: result.
			result]!

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
				wParam: startInteger - 1
				lParam: endInteger - 1]!

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
				wParam: startInteger - 1
				lParam: endInteger - 1]!

sciFindText: searchFlagsInteger ft: ftFINDTEXTEX
	"Private - Find some text in the document."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_FINDTEXT
				wParam: searchFlagsInteger
				lpParam: ftFINDTEXTEX) + 1]!

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

sciFoldDisplayTextSetStyle: styleInteger
	"Private - Set the style of fold display text"

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_FOLDDISPLAYTEXTSETSTYLE
				wParam: styleInteger
				lParam: 0]!

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
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_FORMATRANGE
				wParam: drawBoolean asParameter
				lpParam: frFORMATRANGE) + 1]!

sciFreeSubStyles
	"Private - Free allocated sub styles"

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_FREESUBSTYLES
				wParam: 0
				lParam: 0]!

sciGetAccessibility
	"Private - Report accessibility status."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETACCESSIBILITY
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

sciGetBidirectional
	"Private - Retrieve bidirectional text display state."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETBIDIRECTIONAL
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
				wParam: posInteger - 1
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
				wParam: posInteger - 1
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

sciGetDocumentOptions
	"Private - Get which document options are set."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETDOCUMENTOPTIONS
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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
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
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETLINEENDPOSITION
				wParam: lineInteger
				lParam: 0) + 1]!

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
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETLINEINDENTPOSITION
				wParam: lineInteger
				lParam: 0) + 1]!

sciGetLineSelEndPosition: lineInteger
	"Private - Retrieve the position of the end of the selection at the given line
	(INVALID_POSITION if no selection on this line)."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETLINESELENDPOSITION
				wParam: lineInteger
				lParam: 0) + 1]!

sciGetLineSelStartPosition: lineInteger
	"Private - Retrieve the position of the start of the selection at the given line
	(INVALID_POSITION if no selection on this line)."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETLINESELSTARTPOSITION
				wParam: lineInteger
				lParam: 0) + 1]!

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

sciGetMargins
	"Private - How many margins are there?."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETMARGINS
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

sciGetNamedStyles
	"Private - Retrieve the number of named styles for the lexer."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETNAMEDSTYLES
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

sciGetProperty: keyString
	"Private - Retrieve a 'property' value previously set with SetProperty. Result is
	NUL-terminated."

	| len |
	len := this
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default
						directFunction: this
						msg: SCI_GETPROPERTY
						wpParam: keyString
						lpParam: nil].
	^len = 0
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_GETPROPERTY
				wpParam: keyString
				lpParam: result.
			result]!

sciGetPropertyExpanded: keyString
	"Private - Retrieve a 'property' value previously set with SetProperty, with '$()' variable
	replacement on returned buffer. Result is NUL-terminated."

	| len |
	len := this
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default
						directFunction: this
						msg: SCI_GETPROPERTYEXPANDED
						wpParam: keyString
						lpParam: nil].
	^len = 0
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_GETPROPERTYEXPANDED
				wpParam: keyString
				lpParam: result.
			result]!

sciGetPropertyInt: keyString defaultValue: defaultValueInteger
	"Private - Retrieve a 'property' value previously set with SetProperty, interpreted as an
	int AFTER any '$()' variable replacement."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETPROPERTYINT
				wpParam: keyString
				lParam: defaultValueInteger]!

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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_GETPUNCTUATIONCHARS
				wParam: 0
				lpParam: result.
			result]!

sciGetRectangularSelectionAnchor
	"Private - Return the anchor position of the rectangular selection."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETRECTANGULARSELECTIONANCHOR
				wParam: 0
				lParam: 0) + 1]!

sciGetRectangularSelectionAnchorVirtualSpace
	"Private - Return the virtual space of the anchor of the rectangular selection."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETRECTANGULARSELECTIONANCHORVIRTUALSPACE
				wParam: 0
				lParam: 0]!

sciGetRectangularSelectionCaret
	"Private - Return the caret position of the rectangular selection."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETRECTANGULARSELECTIONCARET
				wParam: 0
				lParam: 0) + 1]!

sciGetRectangularSelectionCaretVirtualSpace
	"Private - Return the virtual space of the caret of the rectangular selection."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETRECTANGULARSELECTIONCARETVIRTUALSPACE
				wParam: 0
				lParam: 0]!

sciGetRepresentation: encodedCharacterString
	"Private - Set the way a character is drawn. Result is NUL-terminated."

	| len |
	len := this
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default
						directFunction: this
						msg: SCI_GETREPRESENTATION
						wpParam: encodedCharacterString
						lpParam: nil].
	^len = 0
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_GETREPRESENTATION
				wpParam: encodedCharacterString
				lpParam: result.
			result]!

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
	"Private - Return the anchor position of the nth selection."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETSELECTIONNANCHOR
				wParam: selectionInteger
				lParam: 0) + 1]!

sciGetSelectionNAnchorVirtualSpace: selectionInteger
	"Private - Return the virtual space of the anchor of the nth selection."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETSELECTIONNANCHORVIRTUALSPACE
				wParam: selectionInteger
				lParam: 0]!

sciGetSelectionNCaret: selectionInteger
	"Private - Return the caret position of the nth selection."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETSELECTIONNCARET
				wParam: selectionInteger
				lParam: 0) + 1]!

sciGetSelectionNCaretVirtualSpace: selectionInteger
	"Private - Return the virtual space of the caret of the nth selection."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETSELECTIONNCARETVIRTUALSPACE
				wParam: selectionInteger
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
		ifTrue: [ByteArray empty]
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

sciGetTabDrawMode
	"Private - Retrieve the current tab draw mode. Returns one of SCTD_* constants."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETTABDRAWMODE
				wParam: 0
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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_GETTAG
				wParam: tagNumberInteger
				lpParam: result.
			result]!

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
	"Private - Return options for virtual space behaviour."

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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
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

sciHideLines: lineStartInteger lineEnd: lineEndInteger
	"Private - Make a range of lines invisible."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_HIDELINES
				wParam: lineStartInteger
				lParam: lineEndInteger]!

sciIndicatorClearRange: startInteger lengthClear: lengthClearInteger
	"Private - Turn a indicator off over a range."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_INDICATORCLEARRANGE
				wParam: startInteger - 1
				lParam: lengthClearInteger]!

sciIndicatorEnd: indicatorInteger pos: posInteger
	"Private - Where does a particular indicator end?"

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_INDICATOREND
				wParam: indicatorInteger
				lParam: posInteger - 1]!

sciIndicatorFillRange: startInteger lengthFill: lengthFillInteger
	"Private - Turn a indicator on over a range."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_INDICATORFILLRANGE
				wParam: startInteger - 1
				lParam: lengthFillInteger]!

sciIndicatorStart: indicatorInteger pos: posInteger
	"Private - Where does a particular indicator start?"

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_INDICATORSTART
				wParam: indicatorInteger
				lParam: posInteger - 1]!

sciIndicatorValueAt: indicatorInteger pos: posInteger
	"Private - What value does a particular indicator have at a position?"

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_INDICATORVALUEAT
				wParam: indicatorInteger
				lParam: posInteger - 1]!

sciInsertText: posInteger text: textString
	"Private - Insert string at a position."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_INSERTTEXT
				wParam: posInteger - 1
				lpParam: textString]!

sciIsRangeWord: startInteger end: endInteger
	"Private - Is the range start..end considered a word?"

	^this isNil
		ifTrue: [false]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_ISRANGEWORD
				wParam: startInteger - 1
				lParam: endInteger - 1) asBoolean]!

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
		ifTrue: [ByteArray empty]
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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
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

sciMarkerAddSet: lineInteger markerSet: markerSetInteger
	"Private - Add a set of markers to a line."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_MARKERADDSET
				wParam: lineInteger
				lParam: markerSetInteger]!

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

sciMarkerDeleteHandle: markerHandleInteger
	"Private - Delete a marker."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_MARKERDELETEHANDLE
				wParam: markerHandleInteger
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

sciMarkerLineFromHandle: markerHandleInteger
	"Private - Retrieve the line number at which a particular marker is located."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_MARKERLINEFROMHANDLE
				wParam: markerHandleInteger
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

sciMultiEdgeAddLine: columnInteger edgeColour: edgeColourRGB
	"Private - Add a new vertical edge to the view."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_MULTIEDGEADDLINE
				wParam: columnInteger
				lParam: edgeColourRGB asParameter]!

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

sciNameOfStyle: styleInteger
	"Private - Retrieve the name of a style. Result is NUL-terminated."

	| len |
	len := this
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default
						directFunction: this
						msg: SCI_NAMEOFSTYLE
						wParam: styleInteger
						lpParam: nil].
	^len = 0
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_NAMEOFSTYLE
				wParam: styleInteger
				lpParam: result.
			result]!

sciPointXFromPosition: posInteger
	"Private - Retrieve the x value of the point in the window where a position is displayed."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_POINTXFROMPOSITION
				wParam: 0
				lParam: posInteger - 1]!

sciPointYFromPosition: posInteger
	"Private - Retrieve the y value of the point in the window where a position is displayed."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_POINTYFROMPOSITION
				wParam: 0
				lParam: posInteger - 1]!

sciPositionAfter: posInteger
	"Private - Given a valid document position, return the next position taking code page into
	account. Maximum value returned is the last position in the document."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_POSITIONAFTER
				wParam: posInteger - 1
				lParam: 0) + 1]!

sciPositionBefore: posInteger
	"Private - Given a valid document position, return the previous position taking code page
	into account. Returns 0 if passed 0."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_POSITIONBEFORE
				wParam: posInteger - 1
				lParam: 0) + 1]!

sciPositionFromPoint: xInteger y: yInteger
	"Private - Find the position from a point within the window."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_POSITIONFROMPOINT
				wParam: xInteger
				lParam: yInteger) + 1]!

sciPositionFromPointClose: xInteger y: yInteger
	"Private - Find the position from a point within the window but return INVALID_POSITION if
	not close to text."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_POSITIONFROMPOINTCLOSE
				wParam: xInteger
				lParam: yInteger) + 1]!

sciPositionRelative: posInteger relative: relativeInteger
	"Private - Given a valid document position, return a position that differs in a number of
	characters. Returned value is always between 0 and last position in document."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_POSITIONRELATIVE
				wParam: posInteger - 1
				lParam: relativeInteger) + 1]!

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

sciPropertyNames
	"Private - Retrieve a '\n' separated list of properties understood by the current lexer.
	Result is NUL-terminated."

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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_PROPERTYNAMES
				wParam: 0
				lpParam: result.
			result]!

sciPropertyType: nameString
	"Private - Retrieve the type of a property."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_PROPERTYTYPE
				wpParam: nameString
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
				wParam: secondaryInteger - 1
				lParam: primaryInteger - 1]!

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

sciSearchNext: searchFlagsInteger text: textString
	"Private - Find some text starting at the search anchor. Does not ensure the selection is
	visible."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SEARCHNEXT
				wParam: searchFlagsInteger
				lpParam: textString]!

sciSearchPrev: searchFlagsInteger text: textString
	"Private - Find some text starting at the search anchor and moving backwards. Does not
	ensure the selection is visible."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SEARCHPREV
				wParam: searchFlagsInteger
				lpParam: textString]!

sciSetAccessibility: accessibilityInteger
	"Private - Enable or disable accessibility."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETACCESSIBILITY
				wParam: accessibilityInteger
				lParam: 0]!

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

sciSetAutomaticFold: automaticFoldInteger
	"Private - Set automatic folding behaviours."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETAUTOMATICFOLD
				wParam: automaticFoldInteger
				lParam: 0]!

sciSetBidirectional: bidirectionalInteger
	"Private - Set bidirectional text display state."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETBIDIRECTIONAL
				wParam: bidirectionalInteger
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

	"To avoid an expensive view upgrade, we intercept the state setter call that will exist in
	old resources to save down the code page"
	codePage := codePageInteger.
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

sciSetDocPointer: docInteger
	"Private - Change the document object used."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETDOCPOINTER
				wParam: 0
				lParam: docInteger]!

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

sciSetEdgeMode: edgeModeInteger
	"Private - The edge may be displayed by a line (EDGE_LINE/EDGE_MULTILINE) or by highlighting
	text that goes beyond it (EDGE_BACKGROUND) or not displayed at all (EDGE_NONE)."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETEDGEMODE
				wParam: edgeModeInteger
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

sciSetFirstVisibleLine: displayLineInteger
	"Private - Scroll so that a display line is at the top of the display."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETFIRSTVISIBLELINE
				wParam: displayLineInteger
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
	"Private - Set one of the colours used as a chequerboard pattern in the fold margin"

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETFOLDMARGINCOLOUR
				wParam: useSettingBoolean asParameter
				lParam: backRGB asParameter]!

sciSetFoldMarginHiColour: useSettingBoolean fore: foreRGB
	"Private - Set the other colour used as a chequerboard pattern in the fold margin"

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

sciSetHScrollBar: visibleBoolean
	"Private - Show or hide the horizontal scroll bar."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETHSCROLLBAR
				wParam: visibleBoolean asParameter
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

sciSetKeyWords: keyWordSetInteger keyWords: keyWordsString
	"Private - Set up the key words used by the lexer."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETKEYWORDS
				wParam: keyWordSetInteger
				lpParam: keyWordsString]!

sciSetLayoutCache: cacheModeInteger
	"Private - Sets the degree of caching of layout information."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETLAYOUTCACHE
				wParam: cacheModeInteger
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

sciSetLineIndentation: lineInteger indentation: indentationInteger
	"Private - Change the indentation of a line to a number of columns."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETLINEINDENTATION
				wParam: lineInteger
				lParam: indentationInteger]!

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

sciSetMargins: marginsInteger
	"Private - Allocate a non-standard number of margins."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETMARGINS
				wParam: marginsInteger
				lParam: 0]!

sciSetModEventMask: eventMaskInteger
	"Private - Set which document modification events are sent to the container."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETMODEVENTMASK
				wParam: eventMaskInteger
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

sciSetPrintWrapMode: wrapModeInteger
	"Private - Set printing to line wrapped (SC_WRAP_WORD) or not line wrapped (SC_WRAP_NONE)."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETPRINTWRAPMODE
				wParam: wrapModeInteger
				lParam: 0]!

sciSetProperty: keyString value: valueString
	"Private - Set up a value that may be used by a lexer for some optional feature."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETPROPERTY
				wpParam: keyString
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

sciSetRectangularSelectionAnchor: anchorInteger
	"Private - Set the anchor position of the rectangular selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETRECTANGULARSELECTIONANCHOR
				wParam: anchorInteger - 1
				lParam: 0]!

sciSetRectangularSelectionAnchorVirtualSpace: spaceInteger
	"Private - Set the virtual space of the anchor of the rectangular selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETRECTANGULARSELECTIONANCHORVIRTUALSPACE
				wParam: spaceInteger
				lParam: 0]!

sciSetRectangularSelectionCaret: caretInteger
	"Private - Set the caret position of the rectangular selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETRECTANGULARSELECTIONCARET
				wParam: caretInteger - 1
				lParam: 0]!

sciSetRectangularSelectionCaretVirtualSpace: spaceInteger
	"Private - Set the virtual space of the caret of the rectangular selection."

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
				wpParam: encodedCharacterString
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

sciSetSearchFlags: searchFlagsInteger
	"Private - Set the search flags used by SearchInTarget."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSEARCHFLAGS
				wParam: searchFlagsInteger
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

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSELECTION
				wParam: caretInteger - 1
				lParam: anchorInteger - 1]!

sciSetSelectionMode: selectionModeInteger
	"Private - Set the selection mode to stream (SC_SEL_STREAM) or rectangular
	(SC_SEL_RECTANGLE/SC_SEL_THIN) or by lines (SC_SEL_LINES)."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSELECTIONMODE
				wParam: selectionModeInteger
				lParam: 0]!

sciSetSelectionNAnchor: selectionInteger anchor: anchorInteger
	"Private - Set the anchor position of the nth selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSELECTIONNANCHOR
				wParam: selectionInteger
				lParam: anchorInteger - 1]!

sciSetSelectionNAnchorVirtualSpace: selectionInteger space: spaceInteger
	"Private - Set the virtual space of the anchor of the nth selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSELECTIONNANCHORVIRTUALSPACE
				wParam: selectionInteger
				lParam: spaceInteger]!

sciSetSelectionNCaret: selectionInteger caret: caretInteger
	"Private - Set the caret position of the nth selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSELECTIONNCARET
				wParam: selectionInteger
				lParam: caretInteger - 1]!

sciSetSelectionNCaretVirtualSpace: selectionInteger space: spaceInteger
	"Private - Set the virtual space of the caret of the nth selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSELECTIONNCARETVIRTUALSPACE
				wParam: selectionInteger
				lParam: spaceInteger]!

sciSetSelectionNEnd: selectionInteger caret: caretInteger
	"Private - Sets the position that ends the selection - this becomes the currentPosition."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSELECTIONNEND
				wParam: selectionInteger
				lParam: caretInteger - 1]!

sciSetSelectionNStart: selectionInteger anchor: anchorInteger
	"Private - Sets the position that starts the selection - this becomes the anchor."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSELECTIONNSTART
				wParam: selectionInteger
				lParam: anchorInteger - 1]!

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

sciSetStylingEx: lengthInteger styles: stylesString
	"Private - Set the styles for a segment of the document."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETSTYLINGEX
				wParam: lengthInteger
				lpParam: stylesString]!

sciSetTabDrawMode: tabDrawModeInteger
	"Private - Set how tabs are drawn when visible."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETTABDRAWMODE
				wParam: tabDrawModeInteger
				lParam: 0]!

sciSetTargetRange: startInteger end: endInteger
	"Private - Sets both the start and end of the target in one call."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETTARGETRANGE
				wParam: startInteger - 1
				lParam: endInteger - 1]!

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
	"Private - Set options for virtual space behaviour."

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

sciSetWrapIndentMode: wrapIndentModeInteger
	"Private - Sets how wrapped sublines are placed. Default is fixed."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETWRAPINDENTMODE
				wParam: wrapIndentModeInteger
				lParam: 0]!

sciSetWrapMode: wrapModeInteger
	"Private - Sets whether text is word wrapped."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETWRAPMODE
				wParam: wrapModeInteger
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

sciStyleClearAll
	"Private - Clear all the styles and make equivalent to the global default style."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_STYLECLEARALL
				wParam: 0
				lParam: 0]!

sciStyleResetDefault
	"Private - Reset the default style to its state at startup"

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_STYLERESETDEFAULT
				wParam: 0
				lParam: 0]!

sciTagsOfStyle: styleInteger
	"Private - Retrieve a ' ' separated list of style tags like 'literal quoted string'. Result
	is NUL-terminated."

	| len |
	len := this
				ifNil: [0]
				ifNotNil: 
					[ScintillaLibrary default
						directFunction: this
						msg: SCI_TAGSOFSTYLE
						wParam: styleInteger
						lpParam: nil].
	^len = 0
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
			ScintillaLibrary default
				directFunction: this
				msg: SCI_TAGSOFSTYLE
				wParam: styleInteger
				lpParam: result.
			result]!

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
		ifTrue: [Utf8String empty]
		ifFalse: 
			[| result |
			result := Utf8String newFixed: len.
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

sciToggleFoldShowText: lineInteger text: textString
	"Private - Switch a header line between expanded and contracted and show some text after the
	line."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_TOGGLEFOLDSHOWTEXT
				wParam: lineInteger
				lpParam: textString]!

sciUserListShow: listTypeInteger itemList: itemListString
	"Private - Display a list of strings and send notification when user chooses one."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_USERLISTSHOW
				wParam: listTypeInteger
				lpParam: itemListString]!

sciVisibleFromDocLine: docLineInteger
	"Private - Find the display line of a document line taking hidden lines into account."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_VISIBLEFROMDOCLINE
				wParam: docLineInteger
				lParam: 0]!

sciWordEndPosition: posInteger onlyWordCharacters: onlyWordCharactersBoolean
	"Private - Get position of end of word."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_WORDENDPOSITION
				wParam: posInteger - 1
				lParam: onlyWordCharactersBoolean asParameter]!

sciWordStartPosition: posInteger onlyWordCharacters: onlyWordCharactersBoolean
	"Private - Get position of start of word."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_WORDSTARTPOSITION
				wParam: posInteger - 1
				lParam: onlyWordCharactersBoolean asParameter]!

sciWrapCount: docLineInteger
	"Private - The number of display lines needed to wrap a document line"

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_WRAPCOUNT
				wParam: docLineInteger
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
	struct := self newNotification: pSCNotification.
	self presenter trigger: #autoComplete:startingAt:accept:
		withArguments: {struct textString. struct position. accept}.
	accept value ifFalse: [self cancelAutoCompletion].
	^0!

scnAutoCSelectionChange: pSCNotification
	"Private - Default handler for an SCN_AUTOCSELECTIONCHANGE event.
	The following fields of the notification structure are set:
		listType
		text
		position"

	| struct |
	struct := self newNotification: pSCNotification.
	self presenter trigger: #autoCompleteSelectionChanged: with: struct.
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
		with: (#(#upArrow #downArrow) at: (self newNotification: pSCNotification) position ifAbsent: [#other]).
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

	self presenter trigger: #charAdded: with: (self newNotification: pSCNotification) character.
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
	scn := self newNotification: pSCNotification.
	self presenter trigger: #hoverEnd: with: scn point.
	^0!

scnDwellStart: pSCNotification
	"Private - Respond to an SCN_DWELLSTART notification. The 'position' , 'x' and 'y' fields of
	the notification structure are set.
	From the Scintilla docs:
		'...generated when the user hold the mouse still in one spot for the dwell period.'
	"

	| scn |
	scn := self newNotification: pSCNotification.
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
	self presenter trigger: #hotSpotClicked: with: (self newNotification: pSCNotification).
	^0!

scnHotSpotDoubleClick: pSCNotification
	"Private - Default handler for an SCN_HOTSPOTDOUBLECLICK event.
	The following fields of the notification structure are set:
		modifiers
		position

	See scnHotSpotClick:
	"

	#todo.	"Send around a MouseEvent here"
	self presenter trigger: #hotSpotDoubleClicked: with: (self newNotification: pSCNotification).
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

	self presenter trigger: #indicatorClicked: with: (self newNotification: pSCNotification).
	^0!

scnIndicatorRelease: pSCNotification
	"Private - Default handler for an SCN_INDICATORRELEASE event.
	The following fields of the notification structure are set:
		modifiers
		position"

	self presenter trigger: #indicatorReleased: with: (self newNotification: pSCNotification).
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

	self presenter trigger: #macroRecord: with: (self newNotification: pSCNotification).
	^0!

scnMarginClick: pSCNotification
	"Private - Respond to an SCN_MARGINCLICK notification. The 'modifiers', 'position' and
	'margin' fields of the notification structure are set.

	From the Scintilla docs:
		'Tells the container that the mouse was clicked inside a margin marked sensitive. 
		Can be used to perform folding or to place breakpoints.'
	"

	| struct |
	struct := self newNotification: pSCNotification.
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

scnMarginRightClick: pSCNotification
	"Private - Default handler for an SCN_MARGINRIGHTCLICK event.
	The following fields of the notification structure are set:
		modifiers
		position
		margin"

	self presenter trigger: #marginRightClicked: with: (self newNotification: pSCNotification).
	^0!

scnModified: pSCNotification
	"Private - Respond to SCN_MODIFIED notification.The 'position', 'modificationType', 'text',
	'length', 'linesAdded', 'line', 'foleLevelNow' and 'foldLevelPrev' fields of the
	notification structure are set.

	See the Scintilla documentation for more information about this important and heavily
	overloaded notification."

	| eventMask |
	eventMask := pSCNotification sdwordAtOffset: SCNotification.ModificationTypeOffset.
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
	notification := self newNotification: pSCNotification.
	"SCNotification.position is a zero-based inter-character index in this case, so we can treat
	it as the one-based index of the last character in the range to be styled."
	stop := notification scPosition.
	
	[| last notificationMask |
	last := self stylingPosition.
	notificationMask := self modificationEventMask.
	
	["Temporarily disable style change notifications to speed up the colouring"
	self modificationEventMask: (notificationMask maskClear: ##(SC_MOD_CHANGESTYLE | SC_PERFORMED_USER)).
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

	self presenter trigger: #updateUI: with: (self newNotification: pSCNotification).
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
	struct := self newNotification: anExternalAddress.
	self presenter
		trigger: #userList:selection:
		with: struct wParam
		with: struct textString.
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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len - 1.
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

	| text |
	text := self stringClass fromString: aString.
	self modifyText: [self sciReplaceSel: text]!

selectionRange
	"Answers an <Interval> identifying the one-based range of selected text. The start of the
	interval is the one-based position of the first selected character, and the end of the
	interval is the one-based interval of the last selected character. If one character is
	selected then the start and end of the interval will be the same. If no characters are
	selected then the start position represents the caret position, and the end position is less
	than the start position (i.e. the interval is empty)."

	^this isNil
		ifTrue: [0 to: -1]
		ifFalse: 
			[| lib |
			lib := ScintillaLibrary default.
			(lib
				directFunction: this
				msg: SCI_GETSELECTIONSTART
				wParam: 0
				lParam: 0) + 1
				to: (lib
						directFunction: this
						msg: SCI_GETSELECTIONEND
						wParam: 0
						lParam: 0)]!

selectionRanges
	"Answer an <Array> of <Interval> representing the current selections. Even if not in
	multi-select mode there could be more than one selection range if a rectangular selection
	has been made."

	| lib |
	lib := ScintillaLibrary default.
	^(0 to: self selectionCount - 1) collect: 
			[:i |
			(lib
				directFunction: this
				msg: SCI_GETSELECTIONNSTART
				wParam: i
				lParam: 0) + 1
				to: (lib
						directFunction: this
						msg: SCI_GETSELECTIONNEND
						wParam: i
						lParam: 0)]!

selectionRanges: anArrayOfInterval
	"Apply the selections provided in the argument. Any existing selections are removed. Note
	that multiple selection ranges are allowed even if the receiver is not in multi-select
	mode."

	self removeSelections.
	anArrayOfInterval do: [:each | self addSelectionRange: each]!

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
	availableStyles := ((1 to: STYLE_DEFAULT - 1) , (STYLE_LASTPREDEFINED + 1 to: 255) 
				difference: allocatedStyles) readStream.
	newStylesByName := IdentityDictionary new: count.
	newStylesById := Array new: (STYLE_LASTPREDEFINED max: 255) + 1.
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
	self sciStyleResetDefault.
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
			[| propValue |
			propValue := aBoolean asParameter displayString.
			"The HTML lexer uses an additional property"
			#todo.	"The properties may vary by lexer and should be user configurable too."
			#('fold' 'fold.html') do: [:each | self sciSetProperty: each value: propValue]]!

setFoldTextTagStyle
	| style |
	style := foldTextTagStyle
				ifNil: [0]
				ifNotNil: [(self class foldTextTagStyles identityIndexOf: foldTextTagStyle) - 1].
	self sciFoldDisplayTextSetStyle: style!

setFont: aFont 
	"Private - Apply the specified font to the receiver's associated Windows control"

	super setFont: aFont.
	self updateTextStyles!

setIndicator: anIntegerOrSymbol from: startInteger length: lengthInteger
	"Apply the indicator identified by the <integer> id or <symbol> name, anIntegerOrSymbol, to
	the range of text in the receiver starting from the one-base integer character position,
	startInteger, for a run length specified by the <integer>, lengthInteger."

	self currentIndicatorId: (self indicatorIdFromName: anIntegerOrSymbol).
	self sciIndicatorFillRange: startInteger lengthFill: lengthInteger!

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
					[availableStyles atEnd ifTrue: [self error: 'Too many styles'].
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
					self lexer ~~ aSymbol ifTrue: [self error: 'Unrecognised language: ' , aSymbol printString]].
			"The fold properties must be set after the lexer has been set."
			self isFoldingEnabled ifTrue: [self setFoldProperty: true]]!

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

	| text |
	text := self stringClass fromString: aString.
	"We use SCI_APPENDTEXT because SCI_SETTEXT assumes the string is null terminated and will
	therefore stop on the first of any embedded nulls."
	self
		cancelModes;
		clearAll;
		sciAppendText: text size text: text;
		isTextModified: false;
		emptyUndoBuffer.
	"Setting the text removes all current markers - we still tell Scintilla to delete them
	though, since it seems that setting empty text may not remove any markers on line 0."
	self removeAllMarkers.
	"Setting the text also removes the indicators"
	indicators := nil!

setWhitespaceBackcolor
	whitespaceBackcolor 
		ifNil: [self sciSetWhitespaceBack: false back: nil]
		ifNotNil: [self sciSetWhitespaceBack: true back: whitespaceBackcolor asRGB]!

setWhitespaceForecolor
	whitespaceForecolor 
		ifNil: [self sciSetWhitespaceFore: false fore: nil]
		ifNotNil: [self sciSetWhitespaceFore: true fore: whitespaceForecolor asRGB]!

showAutoCompletionList: aCollection prefixLength: anInteger
	"Display a auto-completion list built from the displayStrings of the elements of the
	<collection> argument, but without icons. The <Integer> parameter indicates how many
	characters before the caret should be used to provide context."

	self
		showAutoCompletionList: aCollection
		prefixLength: anInteger
		withIcons: false!

showAutoCompletionList: aCollection prefixLength: anInteger withIcons: aBoolean
	"Display a auto-completion list built from the displayStrings of the elements of the
	<collection> argument, optionally with icons if <boolean> argument is true. The <Integer>
	parameter indicates how many characters before the caret should be used to provide context."

	"N.B. It is important for correct operation of incremental search in the auto-completion
	list that the collection of items be appropriately sorted. In particular if Scintilla is
	configured to perform case-sensitive auto-completion then the list must be sorted in the
	same order as would result from using strcmp() to compare the items. This is because
	Scintilla uses a binary chop to perform an incremental search of the the list as characters
	are entered, and so it may fail to find items if the sort order is not based on the same
	comparison order that it uses."

	aCollection isEmpty
		ifTrue: [self cancelAutoCompletion]
		ifFalse: 
			[| string |
			string := self buildItemList: aCollection asSortedCollection withIcons: aBoolean.
			self sciAutoCShow: anInteger itemList: string]!

showCallTip: aString at: anInteger
	"Show the specified <String> as a call tip at the specified <integer> character position."

	self sciCallTipShow: anInteger definition: aString!

showUserList: aCollection id: anInteger
	"Display a 'user list' built from the displayStrings of the elements of the <collection>
	argument. The <Integer> parameter is passed back with the SCN_USERLISTSELECTION
	notification."

	self sciUserListShow: anInteger itemList: (self buildItemList: aCollection withIcons: false)!

showVerticalScrollBar: visibleBoolean
	"Show or hide the vertical scroll bar."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETVSCROLLBAR
				wParam: visibleBoolean asParameter
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

startStylingFrom: startInteger
	"Set the current styling position to start. The unused parameter is no longer used and
	should be set to 0."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_STARTSTYLING
				wParam: startInteger - 1
				lParam: 0]!

state
	"Private - Answer a <MessageSequence> which, when replayed, will restore the receiver to its current state"

	"Implementation Note: Each attributes has a 3-element array, respectively the set selector, get selector, and default value. State is only saved for an attribute if the current value differs from the default. By convention the low-level Scintilla get/set operations are used for efficiency, and to make it easier to relate the default value to the documentation.

	The markers must be stored as part of the state, even though stored in an instance variable, as these are reset when the text is restored."

	| answer |
	answer := super state.
	#(#(#modificationEventMask: #modificationEventMask ##(SC_MODEVENTMASKALL)) #(#isDrawingBuffered: #isDrawingBuffered true) #(#hoverTime: #hoverTime 10000000) #(#setIndicators: #indicators #()) #(#sciSetCaretStyle: #sciGetCaretStyle ##(CARETSTYLE_LINE)) #(#caretForecolor: #caretForecolor ##(Color
		black asRGB)) #(#secondaryCaretForecolor: #secondaryCaretForecolor ##(RGB fromInteger: 16r7F7F7F)) #(#currentLineAlpha: #currentLineAlpha ##(SC_ALPHA_NOALPHA)) #(#caretPeriod: #caretPeriod 500) #(#caretWidth: #caretWidth 1) #(#sciSetCaretSticky: #sciGetCaretSticky ##(SC_CARETSTICKY_OFF)) #(#isCurrentLineHighlighted: #isCurrentLineHighlighted false) #(#isCurrentLineHighlightedAlways: #isCurrentLineHighlightedAlways false) #(#currentLineBackcolor: #currentLineBackcolor ##(Color
		yellow asRGB)) #(#sciSetEOLMode: #sciGetEOLMode ##(SC_EOL_CRLF)) #(#hasVisibleLineEndings: #hasVisibleLineEndings false) #(#wordWrap: #wordWrap false) #(#sciSetLayoutCache: #sciGetLayoutCache ##(SC_CACHE_CARET)) #(#margins: #margins #()) #(#markers: #markers ##(IdentitySet
		new)) #(#isOvertypeEnabled: #isOvertypeEnabled false) #(#printMagnification: #printMagnification 0) #(#printColourMode: #printColourMode ##(SC_PRINT_NORMAL)) #(#canHScroll: #canHScroll true) #(#canScrollPastEnd: #canScrollPastEnd true) #(#scrollWidth: #scrollWidth 2000) #(#xOffset: #xOffset 0) #(#sciSetSelectionMode: #sciGetSelectionMode ##(SC_SEL_STREAM)) #(#backspaceUnindents: #backspaceUnindents false) #(#sciSetIndentationGuides: #sciGetIndentationGuides ##(SC_IV_NONE)) #(#indentation: #indentation 0) #(#tabIndents: #tabIndents true) #(#tabWidth: #tabWidth 8) #(#isUsingTabs: #isUsingTabs true) #(#targetRange: #targetRange ##(1
		to: 0)) #(#sciSetViewWS: #sciGetViewWS ##(SCWS_INVISIBLE)) #(#autoCompletionSeparator: #autoCompletionSeparator $\x20) #(#autoCompletionImageIdSeparator: #autoCompletionImageIdSeparator $?) #(#isAutoCompletionCancelledAtStart: #isAutoCompletionCancelledAtStart true) #(#isAutoCompletionCaseInsensitive: #isAutoCompletionCaseInsensitive false) #(#isAutoCompletionCancelledWhenNoMatch: #isAutoCompletionCancelledWhenNoMatch true) #(#isAutoCompletionTruncating: #isAutoCompletionTruncating false) #(#maxCompletionListHeight: #maxCompletionListHeight 5) #(#maxCompletionListWidth: #maxCompletionListWidth 0) #(#sciSetEdgeMode: #sciGetEdgeMode ##(EDGE_NONE)) #(#edgeColor: #edgeColor ##(Color
		gray asRGB)) #(#zoomLevel: #zoomLevel 0) #(#setLexerLanguage: #lexer #container) #(#controlCharacter: #controlCharacter nil) #(#selectionAlpha: #selectionAlpha ##(SC_ALPHA_NOALPHA)) #(#secondarySelectionAlpha: #secondarySelectionAlpha ##(SC_ALPHA_NOALPHA)) #(#positionCacheSize: #positionCacheSize 1024) #(#activeHotspotBackcolor: #activeHotspotBackcolor ##(Color
		white asRGB)) #(#activeHotspotForecolor: #activeHotspotForecolor ##(Color blue asRGB)) #(#areHotspotsSingleLine: #areHotspotsSingleLine true) #(#sciAnnotationSetVisible: #sciAnnotationGetVisible ##(ANNOTATION_HIDDEN)) #(#setRawAnnotations: #getRawAnnotations ##(OrderedCollection
		new)) #(#extraAscent: #extraAscent 0) #(#extraDescent: #extraDescent 0) #(#areAdditionalCaretsVisible: #areAdditionalCaretsVisible true) #(#sciSetFontQuality: #sciGetFontQuality ##(SC_EFF_QUALITY_DEFAULT)) #(#whitespaceMarkerSize: #whitespaceMarkerSize 1) #(#sciSetMultiPaste: #sciGetMultiPaste ##(SC_MULTIPASTE_ONCE)) #(#sciSetIMEInteraction: #sciGetIMEInteraction ##(SC_IME_WINDOWED)) #(#sciAutoCSetOrder: #sciAutoCGetOrder ##(SC_ORDER_PRESORTED)) #(#sciSetPhasesDraw: #sciGetPhasesDraw ##(SC_PHASES_TWO)) #(#sciSetIdleStyling: #sciGetIdleStyling ##(SC_IDLESTYLING_NONE)) #(#isMouseWheelCaptured: #isMouseWheelCaptured true) #(#sciSetTabDrawMode: #sciGetTabDrawMode 0) #(#sciSetAccessibility: #sciGetAccessibility 0) #(#currentLineFrameWidth: #currentLineFrameWidth 0) #(isAccessibilityEnabled: #isAccessibilityEnabled false) #(#sciSetWrapIndentMode: #sciGetWrapIndentMode ##(SC_WRAPINDENT_FIXED)))
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

stringClass
	^codePage == SC_CP_UTF8 ifTrue: [Utf8String] ifFalse: [AnsiString]!

styleAt: anInteger 
	"Answer a <ScintillaTextStyle> being the the style of the character at the specified character
	position."

	^self styleWithId: (self styleIdAt: anInteger)!

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

styleIdAt: posInteger
	"Returns the style byte at the position."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETSTYLEAT
				wParam: posInteger - 1
				lParam: 0]!

styleNamed: aSymbol
	"Answer a <ScintillaTextStyle> being the named style, or nil if the name is not recognised."

	^currentTextStyles lookup: aSymbol!

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

	self styler: (aScintillaStylerClass ?? NullScintillaStyler) new!

styleUnderCaret
	"Answer a <ScintillaTextStyle> representing the style of the character under the caret."

	^self styleAt: self caretPosition!

styleWithId: anInteger
	^(styleIdMap lookup: anInteger + 1)
		ifNil: 
			[(ScintillaTextStyle new)
				name: anInteger;
				yourself]!

stylingPosition
	"Retrieve the position of the last correctly styled character."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[(ScintillaLibrary default
				directFunction: this
				msg: SCI_GETENDSTYLED
				wParam: 0
				lParam: 0) + 1]!

swapPrimarySelectionAnchorAndCaret
	"Swap that caret and anchor of the main selection."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SWAPMAINANCHORCARET
				wParam: 0
				lParam: 0]!

tabDrawMode
	"Answer the current indenting mode used when wrapping lines. This can be one of #fixed
	(indent to a fixed point, by default no indent), #same (indent to the same point as the start
	of the wrapped line), or #indent (indent from the start of the wrapped line by one tab
	width)."

	^self class tabDrawModes at: self sciGetTabDrawMode + 1 ifAbsent: [#longArrow]!

tabDrawMode: aSymbol
	self sciSetTabDrawMode: (self class tabDrawModes keyAtValue: aSymbol) - 1!

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

	^this isNil
		ifTrue: [0 to: -1]
		ifFalse: 
			[| lib |
			lib := ScintillaLibrary default.
			(lib
				directFunction: this
				msg: SCI_GETTARGETSTART
				wParam: 0
				lParam: 0) + 1
				to: (lib
						directFunction: this
						msg: SCI_GETTARGETEND
						wParam: 0
						lParam: 0)]!

targetRange: anInterval
	"Set the range of the current search/replace target. The target is like the selection, but
	not visible."

	self sciSetTargetRange: anInterval start end: anInterval stop + 1!

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
		ifTrue: [self stringClass empty]
		ifFalse: 
			[| result |
			result := self stringClass newFixed: len.
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
	indicatorStyles ifNil: [^self].
	indicatorStyles do: [:each | each applyToView: self at: each basicId].
	(indicatorStyles lookup: #braceHighlight)
		ifNil: [self sciBraceHighlightIndicator: false indicator: 0]
		ifNotNil: [:indic | self sciBraceHighlightIndicator: true indicator: indic basicId].
	(indicatorStyles lookup: #braceMismatch)
		ifNil: [self sciBraceBadLightIndicator: false indicator: 0]
		ifNotNil: [:indic | self sciBraceBadLightIndicator: true indicator: indic basicId]!

updateKeyBindings
	"Private - Update the control with the key bindings configured for the receiver, replacing
	its default command key assignments."

	self sciClearAllCmdKeys.
	self keyBindings do: [:each | self sciAssignCmdKey: each scintillaKeyCode sciCommand: each message]!

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
	"Answer a <String> representing the set of characters considered to be whitespace in the receiver."

	^(whitespaces isNil or: [whitespaces isEmpty]) ifTrue: [self sciGetWhitespaceChars]!

whitespaces: aStringOrNil 
	"Set the characters considered to be whitespace in the receiver to be those in the <String> argument.
	If the argument is nil (or empty), then use the default set of whitespace characters."

	(aStringOrNil isNil or: [aStringOrNil isEmpty]) 
		ifTrue: 
			[whitespaces := nil.
			self setCharacterClasses]
		ifFalse: 
			[whitespaces := aStringOrNil.
			self sciSetWhitespaceChars: whitespaces]!

whitespaceVisibility
	"Answer a <Symbol> naming the level of whitespace marking currently configured in the receiver."

	^self class whitespaceVisibilityLevels at: self sciGetViewWS + 1!

whitespaceVisibility: aSymbol
	"Make white space characters invisible, always visible, visible only after indentation, or
	visible only in indentation, depending on the <Symbol> argument (one of #invisible,
	#visibleAlways, #visibleAfterIndent, or visibleOnlyInIndent respectively)."

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

	(wParam == VK_RETURN and: [self wantReturn not and: [self isAutoCompletionActive not]]) 
		ifTrue: 
			[| shell |
			shell := self topShell view.
			(shell getItemHandle: shell defaultButtonId ifAbsent: []) 
				ifNil: 
					[^super 
						wmKeyDown: message
						wParam: wParam
						lParam: lParam]
				ifNotNil: 
					[:defId | 
					shell 
						sendMessage: WM_COMMAND
						wParam: BN_CLICKED << 16 | shell defaultButtonId
						lParam: defId].
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

	^wordChars
		ifNil: 
			["Note the caveat in the documentation that SCI_GETWORDCHARS doesn't work
			 correctly when using non-ANSI code pages, such as UTF-8, for characters
			 with code points >= 0x80 (i.e. non-ASCII), so we filter out the nonsense."
			self sciGetWordChars select: [:each | each isAscii]]!

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
	"Get the xOffset (ie, horizontal scroll position)."

	^this isNil
		ifTrue: [0]
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_GETXOFFSET
				wParam: 0
				lParam: 0]!

xOffset: xOffsetInteger
	"Set the xOffset (ie, horizontal scroll position)."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETXOFFSET
				wParam: xOffsetInteger
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

zoomLevel: zoomInPointsInteger
	"Set the zoom level. This number of points is added to the size of all fonts. It may be
	positive to magnify or negative to reduce."

	this isNil
		ifFalse: 
			[ScintillaLibrary default
				directFunction: this
				msg: SCI_SETZOOM
				wParam: zoomInPointsInteger
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
!ScintillaView categoriesFor: #anchorPosition!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #anchorPosition:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #annotateLine:withAll:!annotations!public! !
!ScintillaView categoriesFor: #annotationMode!annotations!public! !
!ScintillaView categoriesFor: #annotationMode:!annotations!public! !
!ScintillaView categoriesFor: #annotations!annotations!public! !
!ScintillaView categoriesFor: #annotations:!indicators!public! !
!ScintillaView categoriesFor: #annotationsForLine:!annotations!enquiries!public! !
!ScintillaView categoriesFor: #annotationsFromRawAnnotation:!annotations!converting!helpers!private! !
!ScintillaView categoriesFor: #annotationStyles!annotations!public!style definition! !
!ScintillaView categoriesFor: #annotationStyles:!annotations!public!style definition! !
!ScintillaView categoriesFor: #annotationStylesFromStyleBytes:!annotations!converting!private! !
!ScintillaView categoriesFor: #annotationStylesOffset!**auto generated**!annotations!public!scintilla interface! !
!ScintillaView categoriesFor: #annotationStylesOffset:!**auto generated**!annotations!public!scintilla interface! !
!ScintillaView categoriesFor: #appendText:!public!text retrieval & modification! !
!ScintillaView categoriesFor: #applyAttributes:!helpers!private! !
!ScintillaView categoriesFor: #applyStyle:toNext:!public!styling! !
!ScintillaView categoriesFor: #applyStyleId:toNext:!public!styling! !
!ScintillaView categoriesFor: #applyTextStylesForLexer:!helpers!lexer!private! !
!ScintillaView categoriesFor: #areAdditionalCaretsVisible!**auto generated**!caret!public!scintilla interface! !
!ScintillaView categoriesFor: #areAdditionalCaretsVisible:!**auto generated**!caret!public!scintilla interface! !
!ScintillaView categoriesFor: #areAllLinesVisible!**auto generated**!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #areHotspotsSingleLine!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #areHotspotsSingleLine:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionAcceptChars!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionAcceptChars:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionCancelChars!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionCancelChars:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionCurrentText!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionImageIdSeparator!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionImageIdSeparator:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionListPosition!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionSeparator!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionSeparator:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #autoCompletionSortMode!autocompletion!public! !
!ScintillaView categoriesFor: #autoCompletionSortMode:!autocompletion!public! !
!ScintillaView categoriesFor: #backcolorChanged!helpers!private! !
!ScintillaView categoriesFor: #backspace!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #backspaceNoLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #backspaceUnindents!**auto generated**!public!scintilla interface!tabs & indentation guides!testing! !
!ScintillaView categoriesFor: #backspaceUnindents:!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #basicAnnotateLine:withText:inStyles:!annotations!helpers!private! !
!ScintillaView categoriesFor: #basicClearContainerIndicators!indicators!private! !
!ScintillaView categoriesFor: #basicClearSelection!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #basicLineFromPosition:!accessing!private! !
!ScintillaView categoriesFor: #basicPositionAtLine:!accessing!private! !
!ScintillaView categoriesFor: #basicRemoveAllAnnotations!**auto generated**!annotations!private!removing!scintilla interface! !
!ScintillaView categoriesFor: #basicSelectAll!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #basicSelectionStart:end:!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #basicUndo!**auto generated**!private!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #beginUndoGroup!**auto generated**!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #boundingRectangleOfTextRange:!helpers!private! !
!ScintillaView categoriesFor: #braceChars!brace highlighting!public! !
!ScintillaView categoriesFor: #braceChars:!brace highlighting!public! !
!ScintillaView categoriesFor: #braceHighlight!brace highlighting!helpers!private! !
!ScintillaView categoriesFor: #buildAnnotationStyles:!annotations!private!style definition! !
!ScintillaView categoriesFor: #buildDefaultStyle!private!style definition! !
!ScintillaView categoriesFor: #buildItemList:withIcons:!autocompletion!private! !
!ScintillaView categoriesFor: #buildRawAnnotations:!annotations!converting!helpers!private! !
!ScintillaView categoriesFor: #buildViewStyle!helpers!private! !
!ScintillaView categoriesFor: #callTipBackcolor!call tips!public! !
!ScintillaView categoriesFor: #callTipBackcolor:!call tips!public! !
!ScintillaView categoriesFor: #callTipForecolor!call tips!public! !
!ScintillaView categoriesFor: #callTipForecolor:!call tips!public! !
!ScintillaView categoriesFor: #callTipHighlightColor!call tips!public! !
!ScintillaView categoriesFor: #callTipHighlightColor:!call tips!public! !
!ScintillaView categoriesFor: #callTipPosition!**auto generated**!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #callTipPosition:!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #callTipStyle!call tips!private! !
!ScintillaView categoriesFor: #callTipTabWidth!call tips!public! !
!ScintillaView categoriesFor: #callTipTabWidth:!call tips!public! !
!ScintillaView categoriesFor: #cancelAutoCompletion!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #cancelCallTip!**auto generated**!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #cancelModes!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #canHScroll!**auto generated**!public!scintilla interface!scrolling!testing! !
!ScintillaView categoriesFor: #canHScroll:!public!scrolling! !
!ScintillaView categoriesFor: #canonicalizeLineEndings:!line endings!public! !
!ScintillaView categoriesFor: #canPaste!clipboard operations!public!testing! !
!ScintillaView categoriesFor: #canRedo!**auto generated**!public!scintilla interface!testing!undo & redo! !
!ScintillaView categoriesFor: #canScrollPastEnd!public!scrolling!testing! !
!ScintillaView categoriesFor: #canScrollPastEnd:!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #canUndo!**auto generated**!public!scintilla interface!testing!undo & redo! !
!ScintillaView categoriesFor: #canVScroll!**auto generated**!public!scintilla interface!scrolling!testing! !
!ScintillaView categoriesFor: #caretForecolor!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretForecolor:!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretPeriod!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretPeriod:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretPosition!**auto generated**!caret!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #caretPosition:!**auto generated**!caret!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #caretScreenCoordinates!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretStyle!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #caretStyle:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #caretWidth!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #caretWidth:!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #centerCurrentLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #characterAt:!public!text retrieval & modification! !
!ScintillaView categoriesFor: #charCloseToPosition:!public!selection! !
!ScintillaView categoriesFor: #charNearestPosition:!public!selection! !
!ScintillaView categoriesFor: #clearAll!**auto generated**!commands!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #clearContainerIndicators!indicators!public! !
!ScintillaView categoriesFor: #clearIndicator:from:to:!indicators!public! !
!ScintillaView categoriesFor: #clearRange:!public!text retrieval & modification! !
!ScintillaView categoriesFor: #codePage!other settings!public! !
!ScintillaView categoriesFor: #codePage:!other settings!public! !
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
!ScintillaView categoriesFor: #currentLineBackcolor!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #currentLineBackcolor:!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #currentLineFrameWidth!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #currentLineFrameWidth:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #currentLineText!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #cutLine!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #cutSelection!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #decodeStyledText:!private!text retrieval & modification! !
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
!ScintillaView categoriesFor: #describeKeywordSets!**auto generated**!enquiries!public!scintilla interface! !
!ScintillaView categoriesFor: #destroyAutoCompletionListImages!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #drawingPhases!other settings!public!scintilla interface! !
!ScintillaView categoriesFor: #drawingPhases:!other settings!public! !
!ScintillaView categoriesFor: #duplicateLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #duplicateSelection!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColor!**auto generated**!long lines!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColor:!**auto generated**!long lines!public!scintilla interface! !
!ScintillaView categoriesFor: #edgeColumn!long lines!public! !
!ScintillaView categoriesFor: #edgeColumn:!long lines!public! !
!ScintillaView categoriesFor: #edgeMode!long lines!public! !
!ScintillaView categoriesFor: #edgeMode:!long lines!public! !
!ScintillaView categoriesFor: #editStyles!commands!public! !
!ScintillaView categoriesFor: #emptyUndoBuffer!**auto generated**!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #enChange!event handling-win32!private! !
!ScintillaView categoriesFor: #endOfLineMode!line endings!public! !
!ScintillaView categoriesFor: #endOfLineMode:!line endings!public! !
!ScintillaView categoriesFor: #endUndoGroup!**auto generated**!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #enKillFocus!event handling-win32!private! !
!ScintillaView categoriesFor: #enSetFocus!event handling-win32!private! !
!ScintillaView categoriesFor: #ensureCaretVisible!caret!public! !
!ScintillaView categoriesFor: #ensureHasAnnotationStyles!annotations!helpers!initializing!private! !
!ScintillaView categoriesFor: #ensureLineVisible:!public!scrolling! !
!ScintillaView categoriesFor: #ensureRangeVisible:!public!scrolling! !
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
!ScintillaView categoriesFor: #extendToStartOfVcDisplayLine!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #extendToStartOfWord!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfWordPart!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToStartOfWrappedLine!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToVcHome!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendToWrappedVcHome!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extendUp!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #extraAscent!**auto generated**!public!scintilla interface!white space! !
!ScintillaView categoriesFor: #extraAscent:!**auto generated**!public!scintilla interface!white space! !
!ScintillaView categoriesFor: #extraDescent!**auto generated**!public!scintilla interface!white space! !
!ScintillaView categoriesFor: #extraDescent:!**auto generated**!public!scintilla interface!white space! !
!ScintillaView categoriesFor: #find:range:!private!searching & replacing! !
!ScintillaView categoriesFor: #find:range:flags:!public!searching & replacing! !
!ScintillaView categoriesFor: #findAutoCompletionEntry:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #findMatchingBrace:!brace highlighting!public! !
!ScintillaView categoriesFor: #findString:startingAt:!public!searching & replacing! !
!ScintillaView categoriesFor: #findStyleStart:before:!brace highlighting!public! !
!ScintillaView categoriesFor: #firstVisibleLine:!public!scrolling! !
!ScintillaView categoriesFor: #foldFlags!folding!public! !
!ScintillaView categoriesFor: #foldFlags:!folding!public! !
!ScintillaView categoriesFor: #foldLine:level:!folding!public!scintilla interface! !
!ScintillaView categoriesFor: #foldMargin!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginColor!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginColor:!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginHiColor!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarginHiColor:!folding!margins!public! !
!ScintillaView categoriesFor: #foldMarkerStyle!folding!markers!public! !
!ScintillaView categoriesFor: #foldMarkerStyle:!folding!markers!public! !
!ScintillaView categoriesFor: #foldTextTagStyle!accessing!folding!public! !
!ScintillaView categoriesFor: #foldTextTagStyle:!accessing!folding!public! !
!ScintillaView categoriesFor: #fontQuality!other settings!public! !
!ScintillaView categoriesFor: #fontQuality:!other settings!public! !
!ScintillaView categoriesFor: #forecolor:!accessing!public! !
!ScintillaView categoriesFor: #formatRectangle!accessing!public! !
!ScintillaView categoriesFor: #formFeed!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #getDirectPointer!helpers!private! !
!ScintillaView categoriesFor: #getLineState:!lexer!public!styling! !
!ScintillaView categoriesFor: #getRawAnnotation:!annotations!private! !
!ScintillaView categoriesFor: #getRawAnnotations!annotations!private! !
!ScintillaView categoriesFor: #goto:!**auto generated**!caret!public!scintilla interface! !
!ScintillaView categoriesFor: #gotoLine:!caret!commands!public! !
!ScintillaView categoriesFor: #handle:!accessing!private! !
!ScintillaView categoriesFor: #hangingIndent!**auto generated**!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #hangingIndent:!**auto generated**!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #hasBlinkingSecondaryCarets!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #hasBlinkingSecondaryCarets:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #hasFoldMargin!folding!margins!public!testing! !
!ScintillaView categoriesFor: #hasFoldMargin:!folding!margins!public! !
!ScintillaView categoriesFor: #hasIndentationGuides!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #hasIndentationGuides:!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #hasLineNumbers!margins!public!testing! !
!ScintillaView categoriesFor: #hasLineNumbers:!commands!margins!public! !
!ScintillaView categoriesFor: #hasSelection!public!selection! !
!ScintillaView categoriesFor: #hasVisibleLineEndings!**auto generated**!line endings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #hasVisibleLineEndings:!**auto generated**!line endings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #hideIndicators!helpers!indicators!private! !
!ScintillaView categoriesFor: #hideSelection:!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #highlightBracesAt:and:!**auto generated**!brace highlighting!public!scintilla interface! !
!ScintillaView categoriesFor: #highlightCallTipFrom:to:!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #highlightFindMatch:!private!searching & replacing! !
!ScintillaView categoriesFor: #highlightGuide!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #highlightGuide:!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #highlightMismatchedBrace:!**auto generated**!brace highlighting!public!scintilla interface! !
!ScintillaView categoriesFor: #hoverTime!**auto generated**!notifications!public!scintilla interface! !
!ScintillaView categoriesFor: #hoverTime:!**auto generated**!notifications!public!scintilla interface! !
!ScintillaView categoriesFor: #identifyTextMatchingSelectionWithStyleName:!public!searching & replacing! !
!ScintillaView categoriesFor: #idleStylingMode!public!styling! !
!ScintillaView categoriesFor: #idleStylingMode:!public!styling! !
!ScintillaView categoriesFor: #idOfStyleNamed:!helpers!private! !
!ScintillaView categoriesFor: #imageIndexForIcon:!autocompletion!helpers!private! !
!ScintillaView categoriesFor: #imeMode!ime!other settings!public! !
!ScintillaView categoriesFor: #imeMode:!other settings!public! !
!ScintillaView categoriesFor: #indent!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #indentation!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentation:!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationGuides!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationGuides:!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indentationOfLine:!public!tabs & indentation guides! !
!ScintillaView categoriesFor: #indicatorCount!constants!indicators!public! !
!ScintillaView categoriesFor: #indicatorIdFromName:!indicators!private! !
!ScintillaView categoriesFor: #indicatorMaskAt:!**auto generated**!indicators!public!scintilla interface! !
!ScintillaView categoriesFor: #indicators!indicators!public! !
!ScintillaView categoriesFor: #indicators:!indicators!public! !
!ScintillaView categoriesFor: #indicatorsAt:!indicators!public! !
!ScintillaView categoriesFor: #indicatorStyles!indicators!public! !
!ScintillaView categoriesFor: #indicatorStyles:!indicators!public! !
!ScintillaView categoriesFor: #indicatorsUnder:!indicators!private! !
!ScintillaView categoriesFor: #initialize!initializing!public! !
!ScintillaView categoriesFor: #initializeControl!initializing!private! !
!ScintillaView categoriesFor: #initializeRegisteredImages!initializing!private! !
!ScintillaView categoriesFor: #insertText:at:!public!text retrieval & modification! !
!ScintillaView categoriesFor: #insertText:from:!**auto generated**!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #invalidateStyling!public!styling! !
!ScintillaView categoriesFor: #isAccessibilityEnabled!accessibility!public! !
!ScintillaView categoriesFor: #isAccessibilityEnabled:!accessibility!public! !
!ScintillaView categoriesFor: #isActiveHotspotUnderlined!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isActiveHotspotUnderlined:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionActive!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledAtStart!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledAtStart:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledWhenNoMatch!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCancelledWhenNoMatch:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionCaseInsensitive!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionCaseInsensitive:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionSingleMatchChosen!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionSingleMatchChosen:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isAutoCompletionTruncating!**auto generated**!autocompletion!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isAutoCompletionTruncating:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #isBackgroundDwellEnabled!brace highlighting!public! !
!ScintillaView categoriesFor: #isBackgroundDwellEnabled:!brace highlighting!public! !
!ScintillaView categoriesFor: #isBraceAt:!brace highlighting!private!testing! !
!ScintillaView categoriesFor: #isBraceHighlightingEnabled!brace highlighting!public! !
!ScintillaView categoriesFor: #isBraceHighlightingEnabled:!brace highlighting!public! !
!ScintillaView categoriesFor: #isCallTipAboveText:!**auto generated**!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #isCallTipActive!**auto generated**!call tips!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isCaretSticky!caret, selection, and hotspot styles!public!testing! !
!ScintillaView categoriesFor: #isCaretSticky:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #isCurrentLineHighlighted!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isCurrentLineHighlighted:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isCurrentLineHighlightedAlways!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isCurrentLineHighlightedAlways:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isCurrentLineMarkedWith:!markers!public!testing! !
!ScintillaView categoriesFor: #isDrawingBuffered!**auto generated**!other settings!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isDrawingBuffered:!**auto generated**!other settings!public!scintilla interface! !
!ScintillaView categoriesFor: #isFoldingEnabled!folding!public!testing! !
!ScintillaView categoriesFor: #isFoldingEnabled:!folding!public! !
!ScintillaView categoriesFor: #isIndicator:setAt:!indicators!public! !
!ScintillaView categoriesFor: #isInSelectionExtendMode!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #isLine:folded:!folding!public!scintilla interface! !
!ScintillaView categoriesFor: #isLine:markedWith:!markers!public!testing! !
!ScintillaView categoriesFor: #isLineVisible:!folding!public!testing! !
!ScintillaView categoriesFor: #isMouseWheelCaptured!**auto generated**!mouse capture!public!scintilla interface! !
!ScintillaView categoriesFor: #isMouseWheelCaptured:!**auto generated**!mouse capture!public!scintilla interface! !
!ScintillaView categoriesFor: #isMultiSelect!**auto generated**!multiple selection and virtual space!public!scintilla interface!selection!testing! !
!ScintillaView categoriesFor: #isMultiSelect:!**auto generated**!multiple selection and virtual space!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #isOvertypeEnabled!**auto generated**!overtype!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isOvertypeEnabled:!**auto generated**!overtype!public!scintilla interface! !
!ScintillaView categoriesFor: #isScrollWidthTracking!**auto generated**!public!scintilla interface!scrolling!testing! !
!ScintillaView categoriesFor: #isScrollWidthTracking:!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #isSelectionBackcolorExtendedToEndOfLine!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isSelectionBackcolorExtendedToEndOfLine:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #isSelectionEmpty!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #isSelectionKept!public!testing! !
!ScintillaView categoriesFor: #isSelectionRectangular!**auto generated**!public!scintilla interface!selection!testing! !
!ScintillaView categoriesFor: #isStylingEnabled!public!styling!testing! !
!ScintillaView categoriesFor: #isStylingEnabled:!public!styling! !
!ScintillaView categoriesFor: #isTextModified!**auto generated**!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #isTextModified:!modes!private! !
!ScintillaView categoriesFor: #isUndoEnabled!**auto generated**!public!scintilla interface!testing!undo & redo! !
!ScintillaView categoriesFor: #isUndoEnabled:!**auto generated**!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #isUsingTabs!**auto generated**!public!scintilla interface!tabs & indentation guides!testing! !
!ScintillaView categoriesFor: #isUsingTabs:!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #joinTarget!**auto generated**!commands!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #keyBindings!key bindings!public! !
!ScintillaView categoriesFor: #keyBindings:!key bindings!public! !
!ScintillaView categoriesFor: #keyboardCommands!commands!public! !
!ScintillaView categoriesFor: #lastLineWithState!enquiries!public!styling! !
!ScintillaView categoriesFor: #layoutCachingMode!line wrapping!public! !
!ScintillaView categoriesFor: #layoutCachingMode:!line wrapping!public! !
!ScintillaView categoriesFor: #lexer!lexer!public! !
!ScintillaView categoriesFor: #lexer:!lexer!public! !
!ScintillaView categoriesFor: #lexerLanguage!**auto generated**!lexer!public!scintilla interface! !
!ScintillaView categoriesFor: #lexerNamedStyles!accessing!lexer!multiple selection and virtual space!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #lexerProperties!accessing!lexer!public!scintilla interface! !
!ScintillaView categoriesFor: #lexerPropertyNames!accessing!lexer!public!scintilla interface! !
!ScintillaView categoriesFor: #lineCount!**auto generated**!enquiries!public!scintilla interface! !
!ScintillaView categoriesFor: #lineHeight:!enquiries!public! !
!ScintillaView categoriesFor: #lineLength:!enquiries!public! !
!ScintillaView categoriesFor: #lineLengthFromPosition:!helpers!private! !
!ScintillaView categoriesFor: #lineNumberMargin!margins!public! !
!ScintillaView categoriesFor: #lineRange:!accessing!public! !
!ScintillaView categoriesFor: #lineScroll!public!scrolling! !
!ScintillaView categoriesFor: #lineScrollBy:!public!scrolling! !
!ScintillaView categoriesFor: #linesOnScreen!**auto generated**!enquiries!public!scintilla interface! !
!ScintillaView categoriesFor: #marginCount!constants!margins!public! !
!ScintillaView categoriesFor: #marginCount:!constants!margins!public! !
!ScintillaView categoriesFor: #margins!margins!public! !
!ScintillaView categoriesFor: #margins:!margins!public! !
!ScintillaView categoriesFor: #marginStylesOffset!**auto generated**!margins!public!scintilla interface! !
!ScintillaView categoriesFor: #marginStylesOffset:!**auto generated**!margins!public!scintilla interface! !
!ScintillaView categoriesFor: #marginWidths!accessing!private! !
!ScintillaView categoriesFor: #markerDefinitions!markers!public! !
!ScintillaView categoriesFor: #markerDefinitions:!markers!public! !
!ScintillaView categoriesFor: #markers!markers!public! !
!ScintillaView categoriesFor: #markers:!markers!public! !
!ScintillaView categoriesFor: #markerTypesOnLine:!enquiries!markers!public! !
!ScintillaView categoriesFor: #maxCompletionListHeight!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListHeight:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListWidth!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #maxCompletionListWidth:!**auto generated**!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #modificationEventMask!notifications!public! !
!ScintillaView categoriesFor: #modificationEventMask:!notifications!public! !
!ScintillaView categoriesFor: #modifyText:!private!text retrieval & modification! !
!ScintillaView categoriesFor: #moveCaretInsideView!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveDown!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveLeft!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #movePageDown!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #movePageUp!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveParaDown!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveParaUp!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveRight!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveSelectedLinesDown!**auto generated**!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveSelectedLinesUp!**auto generated**!commands!public!scintilla interface! !
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
!ScintillaView categoriesFor: #moveToVcStartOfDisplayLine!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveToWrappedVcHome!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #moveUp!**auto generated**!caret!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #multiPasteMode!clipboard operations!multiple selection and virtual space!public! !
!ScintillaView categoriesFor: #multiPasteMode:!clipboard operations!multiple selection and virtual space!public! !
!ScintillaView categoriesFor: #newLine!**auto generated**!commands!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #newNotification:!autocompletion!event handling-scintilla!helpers!notifications!private! !
!ScintillaView categoriesFor: #newTextBuffer:!helpers!private! !
!ScintillaView categoriesFor: #nmNotify:!event handling-win32!private! !
!ScintillaView categoriesFor: #onEraseRequired:!event handling!public! !
!ScintillaView categoriesFor: #onKillFocus!event handling!public! !
!ScintillaView categoriesFor: #onSetFocus!event handling!public! !
!ScintillaView categoriesFor: #onViewCreated!event handling!public! !
!ScintillaView categoriesFor: #passwordCharacter!accessing!public! !
!ScintillaView categoriesFor: #passwordCharacter:!accessing!public! !
!ScintillaView categoriesFor: #pasteClipboard!**auto generated**!clipboard operations!commands!public!scintilla interface! !
!ScintillaView categoriesFor: #performUndoableAction:!public!undo & redo! !
!ScintillaView categoriesFor: #plainText!**auto generated**!accessing!public!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #plainText:!accessing!private!text retrieval & modification! !
!ScintillaView categoriesFor: #plainTextFrom:to:!accessing!public!text retrieval & modification! !
!ScintillaView categoriesFor: #positionCacheSize!**auto generated**!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #positionCacheSize:!**auto generated**!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #positionOfChar:!enquiries!public! !
!ScintillaView categoriesFor: #primarySelectionIndex!multiple selection and virtual space!public!selection! !
!ScintillaView categoriesFor: #primarySelectionIndex:!multiple selection and virtual space!public!selection! !
!ScintillaView categoriesFor: #printAnnotationStyleBytes:on:!annotations!helpers!private! !
!ScintillaView categoriesFor: #printColourMode!**auto generated**!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printColourMode:!**auto generated**!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printMagnification!**auto generated**!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #printMagnification:!**auto generated**!printing!public!scintilla interface! !
!ScintillaView categoriesFor: #punctuation!character classes!public! !
!ScintillaView categoriesFor: #punctuation:!character classes!public! !
!ScintillaView categoriesFor: #queryCommand:!commands!private! !
!ScintillaView categoriesFor: #rangeOfIndicator:at:!enquiries!indicators!public! !
!ScintillaView categoriesFor: #redo!**auto generated**!commands!public!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #rememberCaretX!**auto generated**!caret!public!scintilla interface! !
!ScintillaView categoriesFor: #removeAllAnnotations!annotations!public!removing! !
!ScintillaView categoriesFor: #removeAllEdges!**auto generated**!long lines!public!scintilla interface! !
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
!ScintillaView categoriesFor: #requiredLineMarginWidth!enquiries!helpers!margins!private! !
!ScintillaView categoriesFor: #resetMarkers!helpers!markers!private! !
!ScintillaView categoriesFor: #resetZoom!commands!public!zooming! !
!ScintillaView categoriesFor: #restyleAll!public!styling! !
!ScintillaView categoriesFor: #restyleFrom:to:!**auto generated**!public!scintilla interface!styling! !
!ScintillaView categoriesFor: #reverseSelectedLines!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #rgbaBitsFromBitmap:!autocompletion!helpers!private! !
!ScintillaView categoriesFor: #rotateSelection!**auto generated**!commands!multiple selection and virtual space!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciAddRefDocument:!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAddSelection:anchor:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciAddStyledText:c:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAddTabStop:x:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciAddUndoAction:flags:!**auto generated**!private!scintilla interface!undo & redo! !
!ScintillaView categoriesFor: #sciAllocate:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAllocateExtendedStyles:!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciAllocateSubStyles:numberStyles:!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciAnnotationGetLines:!**auto generated**!annotations!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetStyles:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetText:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationGetVisible!**auto generated**!annotations!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetStyles:styles:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetText:text:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAnnotationSetVisible:!**auto generated**!annotations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAppendText:text:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciAssignCmdKey:sciCommand:!**auto generated**!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetCaseInsensitiveBehaviour!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetCurrent!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetMulti!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetOrder!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetSeparator!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCGetTypeSeparator!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetCaseInsensitiveBehaviour:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetFillUps:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetMulti:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetOrder:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetSeparator:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCSetTypeSeparator:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCShow:itemList:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciAutoCStops:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceBadLightIndicator:indicator:!**auto generated**!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceHighlightIndicator:indicator:!**auto generated**!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciBraceMatch:maxReStyle:!**auto generated**!brace highlighting!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetBack:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetFore:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetForeHlt:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetHlt:highlightEnd:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipSetPosStart:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipShow:definition:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCallTipUseStyle:!**auto generated**!call tips!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCanPaste!**auto generated**!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciChangeInsertion:text:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciChangeLexerState:end:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCharPositionFromPoint:y:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCharPositionFromPointClose:y:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearAllCmdKeys!**auto generated**!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearCmdKey:!**auto generated**!key bindings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearRepresentation:!**auto generated**!character representations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciClearTabStops:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciContractedFoldNext:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciConvertEOLs:!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCopyRange:end:!**auto generated**!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCountCharacters:end:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciCreateDocument:documentOptions:!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDeleteRange:lengthDelete:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciDescribeProperty:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDescriptionOfStyle:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDistanceToSecondaryStyles!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciDocLineFromVisible:!**auto generated**!enquiries!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciDropSelectionN:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciEncodedFromUTF8:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciEnsureVisible:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciEnsureVisibleEnforcePolicy:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciExpandChildren:level:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFindColumn:column:!**auto generated**!enquiries!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciFindIndicatorFlash:end:!**auto generated**!indicators!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciFindIndicatorHide!**auto generated**!indicators!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciFindIndicatorShow:end:!**auto generated**!indicators!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciFindText:ft:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciFoldAll:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFoldChildren:action:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFoldDisplayTextSetStyle:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFoldLine:action:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFormatRange:fr:!**auto generated**!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciFreeSubStyles!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciGetAccessibility!**auto generated**!accessibility!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetAdditionalSelectionTyping!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetAutomaticFold!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetBidirectional!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCaretSticky!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCaretStyle!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCharAt:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetCodePage!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetColumn:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetControlCharSymbol!**auto generated**!character representations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetDocPointer!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetDocumentOptions!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEdgeColumn!**auto generated**!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEdgeMode!**auto generated**!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetEndAtLastLine!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciGetEOLMode!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFirstVisibleLine!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciGetFoldExpanded:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFoldLevel:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFoldParent:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetFontQuality!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetIdleStyling!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetIMEInteraction!**auto generated**!ime!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetIndentationGuides!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLastChild:level:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLayoutCache!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLexer!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLine:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetLineEndPosition:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineEndTypesActive!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineEndTypesAllowed!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineEndTypesSupported!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetLineIndentation:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLineIndentPosition:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetLineSelEndPosition:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetLineSelStartPosition:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetLineState:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetLineVisible:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMainSelection!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetMarginLeft!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMarginOptions!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMarginRight!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMargins!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMaxLineState!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetMouseSelectionRectangularSwitch!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetMultiPaste!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetNamedStyles!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetNextTabStop:x:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciGetPasteConvertEndings!**auto generated**!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPhasesDraw!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPrimaryStyleFromStyle:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciGetPrintWrapMode!**auto generated**!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetProperty:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPropertyExpanded:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPropertyInt:defaultValue:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetPunctuationChars!**auto generated**!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionAnchor!**auto generated**!accessing!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionAnchorVirtualSpace!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionCaret!**auto generated**!accessing!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRectangularSelectionCaretVirtualSpace!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetRepresentation:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetSearchFlags!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciGetSelectionMode!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNAnchor:!**auto generated**!accessing!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNAnchorVirtualSpace:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNCaret:!**auto generated**!accessing!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetSelectionNCaretVirtualSpace:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciGetStyledText:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetStyleFromSubStyle:!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciGetSubStyleBases!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciGetSubStylesLength:!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciGetSubStylesStart:!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciGetTabDrawMode!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetTag:!**auto generated**!private!scintilla interface!search & replace using target! !
!ScintillaView categoriesFor: #sciGetTechnology!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetTextRange:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciGetViewWS!**auto generated**!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciGetVirtualSpaceOptions!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWhitespaceChars!**auto generated**!character classes!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciGetWordChars!**auto generated**!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapIndentMode!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapMode!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapVisualFlags!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGetWrapVisualFlagsLocation!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciGotoLine:!**auto generated**!caret!private!scintilla interface! !
!ScintillaView categoriesFor: #sciHideLines:lineEnd:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorClearRange:lengthClear:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorEnd:pos:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorFillRange:lengthFill:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorStart:pos:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciIndicatorValueAt:pos:!**auto generated**!indicators!private!scintilla interface! !
!ScintillaView categoriesFor: #sciInsertText:text:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciIsRangeWord:end:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciLineScroll:lines:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciLoadLexerLibrary:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetStyle:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetStyles:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginGetText:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetStyle:style:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetStyles:styles:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginSetText:text:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarginTextClearAll!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerAddSet:markerSet:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerDefinePixmap:pixmap:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerDefineRGBAImage:pixels:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerDeleteHandle:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerEnableHighlight:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerGet:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerLineFromHandle:!**auto generated**!enquiries!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerNext:markerMask:!**auto generated**!enquiries!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerPrevious:markerMask:!**auto generated**!enquiries!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerSetAlpha:alpha:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMarkerSymbolDefined:!**auto generated**!enquiries!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMultiEdgeAddLine:edgeColour:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMultipleSelectAddEach!**auto generated**!commands!private!scintilla interface! !
!ScintillaView categoriesFor: #sciMultipleSelectAddNext!**auto generated**!commands!private!scintilla interface! !
!ScintillaView categoriesFor: #sciNameOfStyle:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPointXFromPosition:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPointYFromPosition:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionAfter:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionBefore:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionFromPoint:y:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionFromPointClose:y:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPositionRelative:relative:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPrivateLexerCall:pointer:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPropertyNames!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciPropertyType:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRegisterImage:xpmData:!**auto generated**!autocompletion!helpers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRegisterRGBAImage:pixels:!**auto generated**!autocompletion!private!scintilla interface! !
!ScintillaView categoriesFor: #sciReleaseAllExtendedStyles!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciReleaseDocument:!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciReplaceSel:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciReplaceTarget:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciReplaceTargetRE:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciRGBAImageSetHeight:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRGBAImageSetScale:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciRGBAImageSetWidth:!**auto generated**!markers!private!scintilla interface! !
!ScintillaView categoriesFor: #sciScrollCaret!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciScrollRange:primary:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSearchAnchor!**auto generated**!caret!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchInTarget:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchNext:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSearchPrev:text:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSetAccessibility:!**auto generated**!accessibility!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetAdditionalCaretFore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelBack:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelectionTyping:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAdditionalSelFore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetAutomaticFold:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetBidirectional:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretFore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretLineBack:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretSticky:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretStyle:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCaretWidth:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCharsDefault!**auto generated**!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetCodePage:!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetControlCharSymbol:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetDocPointer:!**auto generated**!multiple views!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEdgeColumn:!**auto generated**!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEdgeMode:!**auto generated**!long lines!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetEOLMode:!**auto generated**!line endings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFirstVisibleLine:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetFoldExpanded:expanded:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldFlags:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldLevel:level:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldMarginColour:back:!**auto generated**!folding!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFoldMarginHiColour:fore:!**auto generated**!folding!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetFontQuality:!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHotspotActiveBack:back:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHotspotActiveFore:fore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetHScrollBar:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetIdentifiers:identifiers:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetIdleStyling:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciSetIMEInteraction:!**auto generated**!ime!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetIndentationGuides:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciSetKeyWords:keyWords:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLayoutCache:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLengthForEncode:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetLexer:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLexerLanguage:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLineEndTypesAllowed:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetLineIndentation:indentation:!**auto generated**!private!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #sciSetLineState:state:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciSetMainSelection:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetMarginLeft:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMarginOptions:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMarginRight:!**auto generated**!margins!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMargins:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetModEventMask:!**auto generated**!notifications!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMouseSelectionRectangularSwitch:!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetMultiPaste:!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPasteConvertEndings:!**auto generated**!clipboard operations!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPhasesDraw:!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPrintWrapMode:!**auto generated**!printing!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetProperty:value:!**auto generated**!lexer!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetPunctuationChars:!**auto generated**!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionAnchor:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionAnchorVirtualSpace:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionCaret:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRectangularSelectionCaretVirtualSpace:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetRepresentation:representation:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSavePoint!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetSearchFlags:!**auto generated**!private!scintilla interface!searching & replacing! !
!ScintillaView categoriesFor: #sciSetSelBack:back:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSelection:anchor:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionMode:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNAnchor:anchor:!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSelectionNAnchorVirtualSpace:space:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNCaret:caret:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSelectionNCaretVirtualSpace:space:!**auto generated**!multiple selection and virtual space!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetSelectionNEnd:caret:!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSelectionNStart:anchor:!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetSelFore:fore:!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetStylingEx:styles:!**auto generated**!private!scintilla interface!styling! !
!ScintillaView categoriesFor: #sciSetTabDrawMode:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetTargetRange:end:!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciSetTechnology:!**auto generated**!other settings!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetText:!**auto generated**!private!scintilla interface!text retrieval & modification! !
!ScintillaView categoriesFor: #sciSetViewWS:!**auto generated**!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetVirtualSpaceOptions:!**auto generated**!multiple selection and virtual space!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetVisiblePolicy:visibleSlop:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetWhitespaceBack:back:!**auto generated**!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetWhitespaceChars:!**auto generated**!character classes!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetWhitespaceFore:fore:!**auto generated**!private!scintilla interface!white space! !
!ScintillaView categoriesFor: #sciSetWordChars:!**auto generated**!character classes!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapIndentMode:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapMode:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapVisualFlags:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetWrapVisualFlagsLocation:!**auto generated**!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #sciSetXCaretPolicy:caretSlop:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciSetYCaretPolicy:caretSlop:!**auto generated**!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciShowLines:lineEnd:!**auto generated**!folding!private!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #sciStyleClearAll!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciStyleResetDefault!**auto generated**!private!scintilla interface!style definition! !
!ScintillaView categoriesFor: #sciTagsOfStyle:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciTargetAsUTF8!**auto generated**!private!scintilla interface!selection! !
!ScintillaView categoriesFor: #sciTextHeight:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciTextWidth:text:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciToggleCaretSticky!**auto generated**!caret, selection, and hotspot styles!private!scintilla interface! !
!ScintillaView categoriesFor: #sciToggleFold:!**auto generated**!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciToggleFoldShowText:text:!**auto generated**!private!scintilla interface! !
!ScintillaView categoriesFor: #sciUserListShow:itemList:!**auto generated**!private!scintilla interface!user lists! !
!ScintillaView categoriesFor: #sciVisibleFromDocLine:!**auto generated**!enquiries!folding!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWordEndPosition:onlyWordCharacters:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWordStartPosition:onlyWordCharacters:!**auto generated**!enquiries!private!scintilla interface! !
!ScintillaView categoriesFor: #sciWrapCount:!**auto generated**!enquiries!line wrapping!private!scintilla interface! !
!ScintillaView categoriesFor: #scnAutoCCancelled:!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCCharDeleted:!**auto generated**!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCCompleted:!**auto generated**!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCSelection:!autocompletion!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnAutoCSelectionChange:!event handling-scintilla!private! !
!ScintillaView categoriesFor: #scnCallTipClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnCharAdded:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDoubleClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDwellEnd:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnDwellStart:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnFocusIn:!**auto generated**!event handling-scintilla!private! !
!ScintillaView categoriesFor: #scnFocusOut:!**auto generated**!event handling-scintilla!private! !
!ScintillaView categoriesFor: #scnHotSpotClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnHotSpotDoubleClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnHotSpotReleaseClick:!**auto generated**!event handling-scintilla!private! !
!ScintillaView categoriesFor: #scnIndicatorClick:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnIndicatorRelease:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnKey:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnMacroRecord:!event handling-scintilla!notifications!private! !
!ScintillaView categoriesFor: #scnMarginClick:!event handling-scintilla!margins!notifications!private! !
!ScintillaView categoriesFor: #scnMarginRightClick:!event handling-scintilla!private! !
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
!ScintillaView categoriesFor: #scrollToEnd!**auto generated**!commands!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollToStart!**auto generated**!commands!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollUp!**auto generated**!commands!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollWidth!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #scrollWidth:!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #secondaryCaretForecolor!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondaryCaretForecolor:!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionAlpha!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionAlpha:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #secondarySelectionBackcolor!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionBackcolor:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionForecolor!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #secondarySelectionForecolor:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selection!**auto generated**!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #selectionAlpha!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #selectionAlpha:!**auto generated**!caret, selection, and hotspot styles!public!scintilla interface! !
!ScintillaView categoriesFor: #selectionBackcolor!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionBackcolor:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionCount!**auto generated**!multiple selection and virtual space!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #selectionForecolor!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionForecolor:!caret, selection, and hotspot styles!public! !
!ScintillaView categoriesFor: #selectionMode!public!selection! !
!ScintillaView categoriesFor: #selectionMode:!public!selection! !
!ScintillaView categoriesFor: #selectionPlainText:!private!selection! !
!ScintillaView categoriesFor: #selectionRange!public!selection! !
!ScintillaView categoriesFor: #selectionRanges!public!selection! !
!ScintillaView categoriesFor: #selectionRanges:!public!selection! !
!ScintillaView categoriesFor: #selections!public!selection! !
!ScintillaView categoriesFor: #sendMessage:!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:lParam:!operations!private! !
!ScintillaView categoriesFor: #sendMessage:wParam:lpParam:!operations!private! !
!ScintillaView categoriesFor: #setCallTipHighlightColor!call tips!private! !
!ScintillaView categoriesFor: #setCallTipTabWidth!helpers!private! !
!ScintillaView categoriesFor: #setCharacterClasses!character classes!helpers!private! !
!ScintillaView categoriesFor: #setCurrentTextStyles:!private!style definition! !
!ScintillaView categoriesFor: #setDefaultTextStyle!private!style definition! !
!ScintillaView categoriesFor: #setFoldFlags!folding!private! !
!ScintillaView categoriesFor: #setFoldMarginColor!folding!margins!private! !
!ScintillaView categoriesFor: #setFoldMarginHiColor!folding!margins!private! !
!ScintillaView categoriesFor: #setFoldProperty:!folding!private! !
!ScintillaView categoriesFor: #setFoldTextTagStyle!accessing!folding!private! !
!ScintillaView categoriesFor: #setFont:!helpers!private!style definition! !
!ScintillaView categoriesFor: #setIndicator:from:length:!indicators!public! !
!ScintillaView categoriesFor: #setIndicator:range:!indicators!public! !
!ScintillaView categoriesFor: #setIndicators:!indicators!private! !
!ScintillaView categoriesFor: #setIndicatorStyles:!helpers!private! !
!ScintillaView categoriesFor: #setLexerLanguage:!lexer!private! !
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
!ScintillaView categoriesFor: #showAutoCompletionList:prefixLength:withIcons:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #showCallTip:at:!call tips!public!scintilla interface! !
!ScintillaView categoriesFor: #showUserList:id:!autocompletion!public!scintilla interface! !
!ScintillaView categoriesFor: #showVerticalScrollBar:!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #splitTarget:!**auto generated**!commands!line wrapping!public!scintilla interface! !
!ScintillaView categoriesFor: #startDwellTimer!notifications!private! !
!ScintillaView categoriesFor: #startRecording!**auto generated**!macro recording!public!scintilla interface! !
!ScintillaView categoriesFor: #startStylingFrom:!**auto generated**!public!scintilla interface!styling! !
!ScintillaView categoriesFor: #state!accessing!private! !
!ScintillaView categoriesFor: #stopDwellTimer!notifications!private! !
!ScintillaView categoriesFor: #stopRecording!**auto generated**!macro recording!public!scintilla interface! !
!ScintillaView categoriesFor: #stopStyling!public!styling! !
!ScintillaView categoriesFor: #stringClass!helpers!private! !
!ScintillaView categoriesFor: #styleAt:!public!styling! !
!ScintillaView categoriesFor: #styledTextFrom:to:!public!text retrieval & modification! !
!ScintillaView categoriesFor: #styleIdAt:!**auto generated**!public!scintilla interface!styling! !
!ScintillaView categoriesFor: #styleNamed:!enquiries!public!styling! !
!ScintillaView categoriesFor: #styleNext:mask:!**auto generated**!public!scintilla interface!styling! !
!ScintillaView categoriesFor: #styler!public!styling! !
!ScintillaView categoriesFor: #styler:!public!styling! !
!ScintillaView categoriesFor: #stylerClass!public!styling! !
!ScintillaView categoriesFor: #stylerClass:!public!styling! !
!ScintillaView categoriesFor: #styleUnderCaret!enquiries!public!styling! !
!ScintillaView categoriesFor: #styleWithId:!enquiries!public!style definition! !
!ScintillaView categoriesFor: #stylingPosition!**auto generated**!public!scintilla interface!styling! !
!ScintillaView categoriesFor: #swapPrimarySelectionAnchorAndCaret!**auto generated**!commands!public!scintilla interface!selection! !
!ScintillaView categoriesFor: #tabDrawMode!other settings!public! !
!ScintillaView categoriesFor: #tabDrawMode:!other settings!public! !
!ScintillaView categoriesFor: #tabIndents!**auto generated**!public!scintilla interface!tabs & indentation guides!testing! !
!ScintillaView categoriesFor: #tabIndents:!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #tabWidth!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #tabWidth:!**auto generated**!public!scintilla interface!tabs & indentation guides! !
!ScintillaView categoriesFor: #targetAll!**auto generated**!public!scintilla interface! !
!ScintillaView categoriesFor: #targetRange!public!search & replace using target! !
!ScintillaView categoriesFor: #targetRange:!public!search & replace using target! !
!ScintillaView categoriesFor: #targetText!**auto generated**!public!scintilla interface!search & replace using target! !
!ScintillaView categoriesFor: #textAtLine:!private!text retrieval & modification! !
!ScintillaView categoriesFor: #textLength!**auto generated**!accessing!public!scintilla interface! !
!ScintillaView categoriesFor: #textLimit!accessing!public! !
!ScintillaView categoriesFor: #textLimit:!accessing!public! !
!ScintillaView categoriesFor: #textStyles!public!style definition! !
!ScintillaView categoriesFor: #textStyles:!public!style definition! !
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
!ScintillaView categoriesFor: #tokensFrom:to:!public!text retrieval & modification! !
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
!ScintillaView categoriesFor: #whitespaceBackcolor!public!white space! !
!ScintillaView categoriesFor: #whitespaceBackcolor:!public!white space! !
!ScintillaView categoriesFor: #whitespaceForecolor!public!white space! !
!ScintillaView categoriesFor: #whitespaceForecolor:!public!white space! !
!ScintillaView categoriesFor: #whitespaceMarkerSize!**auto generated**!public!scintilla interface!white space! !
!ScintillaView categoriesFor: #whitespaceMarkerSize:!**auto generated**!public!scintilla interface!white space! !
!ScintillaView categoriesFor: #whitespaces!character classes!public!white space! !
!ScintillaView categoriesFor: #whitespaces:!character classes!public!white space! !
!ScintillaView categoriesFor: #whitespaceVisibility!public!white space! !
!ScintillaView categoriesFor: #whitespaceVisibility:!public!white space! !
!ScintillaView categoriesFor: #widthOfText:inStyle:!enquiries!public! !
!ScintillaView categoriesFor: #willCaptureMouse!**auto generated**!mouse capture!public!scintilla interface!testing! !
!ScintillaView categoriesFor: #willCaptureMouse:!**auto generated**!mouse capture!public!scintilla interface! !
!ScintillaView categoriesFor: #wmChar:wParam:lParam:!event handling-win32!private! !
!ScintillaView categoriesFor: #wmContextMenu:wParam:lParam:!event handling-win32!private! !
!ScintillaView categoriesFor: #wmKeyDown:wParam:lParam:!event handling-win32!private! !
!ScintillaView categoriesFor: #wmTimer:wParam:lParam:!event handling-win32!private!timers! !
!ScintillaView categoriesFor: #wordChars!character classes!other settings!public! !
!ScintillaView categoriesFor: #wordChars:!character classes!other settings!public! !
!ScintillaView categoriesFor: #wordWrap!line wrapping!public! !
!ScintillaView categoriesFor: #wordWrap:!line wrapping!public! !
!ScintillaView categoriesFor: #wrapIndentMode!other settings!public! !
!ScintillaView categoriesFor: #wrapIndentMode:!other settings!public! !
!ScintillaView categoriesFor: #xOffset!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #xOffset:!**auto generated**!public!scintilla interface!scrolling! !
!ScintillaView categoriesFor: #zoomIn!**auto generated**!commands!public!scintilla interface!zooming! !
!ScintillaView categoriesFor: #zoomLevel!**auto generated**!public!scintilla interface!zooming! !
!ScintillaView categoriesFor: #zoomLevel:!**auto generated**!public!scintilla interface!zooming! !
!ScintillaView categoriesFor: #zoomOut!**auto generated**!commands!public!scintilla interface!zooming! !

!ScintillaView class methodsFor!

annotationModes
	^#(#hidden #standard #boxed indented)!

autoCompletionSortModes
	^#(#presorted #sort #custom)!

caretStyles
	^#(#invisible #line #block)!

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
	answer := IdentityDictionary new.
	"The #normal style must be present - it has id 0, and is the style from which the others
	inherit their default settings. In turn it inherits its own default settings from the view."
	answer add: (ScintillaTextStyle name: #normal).
	"Some 'predefined' styles"
	answer
		add: (ScintillaTextStyle name: #lineNumber);
		add: (ScintillaTextStyle name: #indentGuide);
		add: self defaultCallTipStyle;
		yourself.
	^answer!

drawingPhases
	^#(#one #two #multiple)!

edgeModes
	"Answer the symbolic names of the long-line edge marking modes supported by Scintilla."

	^#(#none #line #background #multiline)!

foldMarkerStyles
	^#(#arrows #boxTree #circleTree #plusMinus)!

foldTextTagStyles
	^#(#hidden #standard #boxed)!

fontQualities
	^#(#default #unaliased #antialiased #lcdOptimized)!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

idleStylingModes
	"Answer the symbolic names of the idle-styling modes supported by Scintilla."

	^#(#none #toVisible #afterVisible #all)!

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

	| defaultKeyBindings |
	self initializeNotificationMap.
	self addClassConstant: 'CodePages'
		value: ((IdentityDictionary new)
				at: CP_ACP put: #ansi;
				at: SC_CP_UTF8 put: #utf8;
				shrink;
				isImmutable: true;
				yourself).
	self addClassConstant: 'BraceHilightingMask' value: 1.
	self addClassConstant: 'FoldingMask' value: 2.
	self addClassConstant: 'BackgroundDwellEvents' value: 4.
	self addClassConstant: 'DefaultTextStyles'
		value: ((IdentityDictionary new)
				at: #container put: (self immutableCopyOfCollection: self defaultTextStyles);
				at: #xml put: (self immutableCopyOfCollection: self xmlTextStyles);
				at: #text put: (self immutableCopyOfCollection: self txtTextStyles);
				at: #smalltalk put: (self immutableCopyOfCollection: self smalltalkTextStyles);
				at: #markdown put: (self immutableCopyOfCollection: self markdownTextStyles);
				shrink;
				isImmutable: true;
				yourself).
	defaultKeyBindings := LookupTable new.
	self defaultKeyMap do: 
			[:each |
			| keyCode |
			keyCode := AcceleratorTable keyCode: each first asInteger modifiers: each second.
			defaultKeyBindings at: keyCode
				put: ((ScintillaKeyBinding newAcceleratorKey: keyCode message: each last)
						isImmutable: true;
						yourself)].
	defaultKeyBindings
		shrink;
		isImmutable: true.
	self addClassConstant: 'DefaultKeyBindings' value: defaultKeyBindings.
	self addClassConstant: 'DefaultCallTipTabWidth' value: 32.
	"Offsets must always be multiples of 256 for implementation reasons"
	self addClassConstant: 'MarginStylesOffset' value: 256.
	self addClassConstant: 'AnnotationStylesOffset' value: 512!

initializeNotificationMap
	ScnMap := (Array new: 33)
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
				at: SCN_MARGINRIGHTCLICK - 1999 put: #scnMarginRightClick:;
				at: SCN_AUTOCSELECTIONCHANGE - 1999 put: #scnAutoCSelectionChange:;
				isImmutable: true;
				yourself!

layoutCachingModes
	^#(#none #caret #page #document)!

lexerLanguages
	"Answer the names of all known languages with a lexers built into SciLexer.dll
	The set of lexers tends to increase quite rapidly over time (though some also get
	dropped, hence the empty slots in the array), this is from 4.10. Note that a Smalltalk lexer
	was added around 1.63, however we do not use this. Dolphin's Smalltalk lexer is implemented
	in the image and container-based lexing is used. This is slower, but much more powerful."

	"Note that SCLEX_XCODE (13) seem to be dead (i.e. no lexer is registered for it). Note also
	that the language names are case sensitive. Finally note that there are two special names which
	are not languages as such: #automatic is an instruction to Scintilla to choose a lexer, and #container
	sends colourization requests back to the control's container (i.e. into our Smalltalk wrapper)."

	^#(#container #text #python #cpp #hypertext #xml #perl #sql #vb #props #errorlist #makefile #batch nil #latex #lua #diff #conf #pascal #ave #ada #lisp #ruby #eiffel #eiffelkw #tcl #nncrontab #bullant #vbscript nil nil #baan #matlab #scriptol #asm #cppnocase #fortran #f77 #css #pov #lout #escript #ps #nsis #mmixal #clarion #clarionnocase #lot #yaml #tex #metapost #powerbasic #forth #erlang #octave #mssql #verilog #kix #gui4cli #specman #au3 #apdl #bash #asn1 #vhdl #caml #blitzbasic #purebasic #haskell #phpscript #tads3 #rebol #smalltalk #flagship #csound #freebasic #inno #opal #spice #d #cmake #gap #'PL/M' #abl #abaqus #asy #r #magiksf #powershell #mysql #po #TAL #COBOL #TACL #sorcins #powerpro #nimrod #SML #markdown #txt2tags #a68k #modula #coffeescript #tcmd #avs #ecl #oscript #visualprolog #literatehaskell #fcST #kvirc #rust #DMAP #as #DMIS #registry #bib #srec #ihex #tehex #json #edifact #indent #maxima nil nil #automatic)!

lineEndings
	"Answer the symbolic names of the end-of-line modes supported by Scintilla. These correspond
	to the character sequences, with #crlf being the default for Windows."

	^#(#crlf #cr #lf)!

markdownTextStyles
	"Answer the default Markdown text style settings to be used for new instances of the receiver.
	These are the styles used as the defaults for Markdown files in Scite."

	| styles |
	styles := self defaultTextStyles.
	styles add: ((ScintillaTextStyle name: #lineBegin)
				id: 1;
				yourself).
	styles add: ((ScintillaTextStyle name: #strong1)
				id: 2;
				forecolor: (Color fromHTMLSpec: '#224466');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #strong2)
				id: 3;
				forecolor: (Color fromHTMLSpec: '#224466');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #em1)
				id: 4;
				forecolor: (Color fromHTMLSpec: '#663300');
				isItalic: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #em2)
				id: 5;
				forecolor: (Color fromHTMLSpec: '#663300');
				isItalic: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #header1)
				id: 6;
				forecolor: (Color fromHTMLSpec: '#518C34');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #header2)
				id: 7;
				forecolor: (Color fromHTMLSpec: '#518C34');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #header3)
				id: 8;
				forecolor: (Color fromHTMLSpec: '#518C34');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #header4)
				id: 9;
				forecolor: (Color fromHTMLSpec: '#518C34');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #header5)
				id: 10;
				forecolor: (Color fromHTMLSpec: '#518C34');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #header6)
				id: 11;
				forecolor: (Color fromHTMLSpec: '#518C34');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #preChar)
				id: 12;
				forecolor: Color black;
				backcolor: (Color fromHTMLSpec: '#EEEEAA');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #ulistItem)
				id: 13;
				forecolor: (Color fromHTMLSpec: '#555555');
				yourself).
	styles add: ((ScintillaTextStyle name: #olistItem)
				id: 14;
				forecolor: (Color fromHTMLSpec: '#555555');
				yourself).
	styles add: ((ScintillaTextStyle name: #blockQuote)
				id: 15;
				forecolor: (Color fromHTMLSpec: '#000088');
				yourself).
	styles add: ((ScintillaTextStyle name: #strikeOut)
				id: 16;
				forecolor: (Color fromHTMLSpec: '#18453B');
				backcolor: (Color fromHTMLSpec: '#A9BA9D');
				yourself).
	styles add: ((ScintillaTextStyle name: #horizontalRule)
				id: 17;
				forecolor: (Color fromHTMLSpec: '#555555');
				isBold: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #link)
				id: 18;
				forecolor: (Color fromHTMLSpec: '#0000AA');
				isUnderlined: true;
				yourself).
	styles add: ((ScintillaTextStyle name: #code)
				id: 19;
				forecolor: (Color fromHTMLSpec: '#000088');
				backcolor: (Color fromHTMLSpec: '#EEEEEE');
				yourself).
	styles add: ((ScintillaTextStyle name: #code2)
				id: 20;
				forecolor: (Color fromHTMLSpec: '#000088');
				backcolor: (Color fromHTMLSpec: '#EEEEEE');
				yourself).
	styles add: ((ScintillaTextStyle name: #codeBlock)
				id: 21;
				forecolor: (Color fromHTMLSpec: '#000088');
				backcolor: (Color fromHTMLSpec: '#EEEEEE');
				yourself).
	^styles!

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

tabDrawModes
	^#(#longArrow #strikeOut)!

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
	^#(#fixed #same #indent #deepIndent)!

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
							r: 0
							g: 127
							b: 127);
				yourself).
	styles add: ((ScintillaTextStyle name: #doubleString)
				id: 6;
				forecolor: (RGB
							r: 127
							g: 0
							b: 127);
				yourself).
	styles add: ((ScintillaTextStyle name: #singleString)
				id: 7;
				forecolor: (RGB
							r: 127
							g: 0
							b: 127);
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
							r: 255
							g: 240
							b: 240);
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
							r: 96
							g: 128
							b: 96);
				yourself).
	sgmlBackcolour := RGB
				r: 239
				g: 239
				b: 255.
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
							r: 0
							g: 102
							b: 0);
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
							r: 153
							g: 51
							b: 0);
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlError)
				id: 26;
				backcolor: (RGB
							r: 255
							g: 102
							b: 102);
				forecolor: Color darkRed;
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlSpecial)
				id: 27;
				backcolor: sgmlBackcolour;
				forecolor: (RGB
							r: 51
							g: 102
							b: 255);
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlEntity)
				id: 28;
				backcolor: sgmlBackcolour;
				forecolor: (RGB
							r: 51
							g: 51
							b: 51);
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlComment)
				id: 29;
				backcolor: sgmlBackcolour;
				forecolor: Color brown;
				yourself).
	styles add: ((ScintillaTextStyle name: #sgmlBlock)
				id: 31;
				backcolor: (RGB
							r: 204
							g: 204
							b: 224);
				forecolor: (RGB
							r: 0
							g: 0
							b: 102);
				yourself).
	^styles! !
!ScintillaView class categoriesFor: #annotationModes!constants!public! !
!ScintillaView class categoriesFor: #autoCompletionSortModes!constants!private! !
!ScintillaView class categoriesFor: #caretStyles!constants!public! !
!ScintillaView class categoriesFor: #defaultAnnotationStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #defaultCallTipStyle!constants!public!style definition! !
!ScintillaView class categoriesFor: #defaultKeyMap!constants!private! !
!ScintillaView class categoriesFor: #defaultTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #drawingPhases!constants!private! !
!ScintillaView class categoriesFor: #edgeModes!constants!public! !
!ScintillaView class categoriesFor: #foldMarkerStyles!constants!public! !
!ScintillaView class categoriesFor: #foldTextTagStyles!constants!public! !
!ScintillaView class categoriesFor: #fontQualities!constants!public! !
!ScintillaView class categoriesFor: #icon!constants!public! !
!ScintillaView class categoriesFor: #idleStylingModes!constants!public! !
!ScintillaView class categoriesFor: #imeInteractionModes!constants!private! !
!ScintillaView class categoriesFor: #immutableCopyOfCollection:!helpers!private! !
!ScintillaView class categoriesFor: #indentationGuideStyles!constants!private! !
!ScintillaView class categoriesFor: #initialize!development!initializing!private! !
!ScintillaView class categoriesFor: #initializeNotificationMap!**auto generated**!must not strip!public!scintilla interface! !
!ScintillaView class categoriesFor: #layoutCachingModes!constants!public! !
!ScintillaView class categoriesFor: #lexerLanguages!constants!public! !
!ScintillaView class categoriesFor: #lineEndings!constants!public! !
!ScintillaView class categoriesFor: #markdownTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #multiPasteModes!constants!public! !
!ScintillaView class categoriesFor: #selectionModes!constants!public! !
!ScintillaView class categoriesFor: #smalltalkTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #stbConvert:fromVersion:!binary filing!private! !
!ScintillaView class categoriesFor: #stbConvertFromVersion13:!binary filing!private! !
!ScintillaView class categoriesFor: #stbConvertFromVersion9:!binary filing!private! !
!ScintillaView class categoriesFor: #stbVersion!binary filing!public! !
!ScintillaView class categoriesFor: #tabDrawModes!constants!public! !
!ScintillaView class categoriesFor: #txtTextStyles!constants!public!style definition! !
!ScintillaView class categoriesFor: #whitespaceVisibilityLevels!constants!public! !
!ScintillaView class categoriesFor: #winClassName!constants!private! !
!ScintillaView class categoriesFor: #wrapIndentModes!constants!public! !
!ScintillaView class categoriesFor: #xmlTextStyles!constants!public!style definition! !

