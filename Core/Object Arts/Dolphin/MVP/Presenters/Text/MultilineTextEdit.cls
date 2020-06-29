"Filed out from Dolphin Smalltalk 7"!

TextEdit subclass: #MultilineTextEdit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ButtonConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
MultilineTextEdit guid: (GUID fromString: '{87b4c743-026e-11d3-9fd7-00a0cc3e4a32}')!
MultilineTextEdit comment: 'MultilineTextEdit is a <valueView> class that implements the Windows "EDIT" control with an ES_MULTILINE style for the displaying and editing of multi-line text. The <valueModel> associated with a MultilineTextEdit  must always yield a <readableString> value when mapped through the installed type converter. A MultilineTextEdit will normally be used in conjunction with a <TextPresenter>. '!
!MultilineTextEdit categoriesForClass!MVP-Views! !
!MultilineTextEdit methodsFor!

calculateExtent: aLayoutContext 
	"Private - Answer a calculated preferred extent for the receiver."

	| canvas extent metrics margins |
	self wordWrap ifFalse: [^super calculateExtent: aLayoutContext].
	canvas := self canvas.
	canvas font: self actualFont.
	#todo.	"Need to use the suggested extent passed as the argument here, rather than the current client rectangle"
	extent := canvas 
				textExtent: self text
				width: (aLayoutContext clientRectangleOf: self) width
				alignment: self alignment.
	metrics := canvas textMetrics.
	margins := self marginWidths.
	extent := extent + ((margins first + margins last) @ metrics tmExternalLeading).

	"Multiline Edit fields always allow one extra line in which to type"
	self isReadOnly ifFalse: [extent y: extent y + metrics tmHeight + metrics tmInternalLeading].
	canvas free.
	^self calcExtentFromClientExtent: extent!

canHScroll
	"Answer true if the receiver is in horizontal scrolling mode"

	^self baseStyleAllMask: WS_HSCROLL!

canHScroll: aBoolean 
	"Sets the receiver into horizontal scrolling mode if aBoolean is true.
	This is a combination of the WS_HSCROLL and ES_AUTOHSCROLL styles"

	(self 
		baseStyleMask: ##(WS_HSCROLL | ES_AUTOHSCROLL)
		set: aBoolean
		recreateIfChanged: true) 
			ifTrue: 
				[self invalidateCalculatedExtent.
				self frameChanged]!

canVScroll
	"Answer true if the receiver is in vertical scrolling mode"

	^self baseStyleAllMask: WS_VSCROLL!

canVScroll: aBoolean 
	"Sets the receiver into vertical scrolling mode if aBoolean is true
	This a combination of the WS_VSCROLL and ES_AUTOVSCROLL styles"

	self showVerticalScrollBar: aBoolean.
	self invalidateCalculatedExtent!

copyLine
	"Copy the current line. The selection is unaffected."

	| range |
	range := self lineRange: self currentLine.
	(self plainTextRange: range) copyToClipboard!

copySelectionOrLine
	self hasSelection ifTrue: [self copySelection] ifFalse: [self copyLine]!

currentLine
	"Answer the line on which the caret is currently positioned."

	^self lineFromPosition: self caretPosition
!

cutLine
	"Delete the line on which the caret is located, including the line delimiter (i.e. subsequent lines shift
	up by one). If it is the last line just cuts the text on that line, if any."

	self selectLineAndTerminator: self currentLine.
	self cutSelection!

defaultExtent
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(200 @ 80)!

defaultWindowStyle
	"Private - Answer a default style to use when creating a multiline edit pane."

	^super defaultWindowStyle bitOr: ##(ES_WANTRETURN | ES_MULTILINE | ES_NOHIDESEL)!

deleteLine
	"Delete the line on which the caret is located, including the line delimiter (i.e. subsequent lines shift
	up by one). If it is the last line just deletes the text on that line, if any."

	self selectLineAndTerminator: self currentLine.
	self clearSelection!

displayOnFormats
	"Private - Answers an array of selectors that can be used to determine how the receiver is
	represented as a textual display string by #displayOn:. These selectors are sent in turn
	until one yields a non-nil, non-empty string as a result. Can be overridden by subclasses to 
	change the way a view formats itself as text"

	^super displayOnFormats copyReplacing: #text withObject: #displayOnText!

displayOnText
	"Private - Answers a reasonably short piece of the receiver's text."

	^self lineCount > 0 ifTrue: [self plainTextRange: (self lineRange: 1)] ifFalse: ['']!

dlgCode
	"Private - Answer the combination of DLGC_XXX flags usually appropriate for the
	receiver. This can be modified depending on the particular message received
	with a WM_GETDLGCODE."

	^(super dlgCode maskClear: DLGC_HASSETSEL) bitOr: DLGC_WANTALLKEYS!

duplicateLine
	"Duplicate the current line."

	| range |
	range := self lineRange: self currentLine.
	self insertText: String lineDelimiter , (self plainTextRange: range) at: range stop + 1!

duplicateSelection
	"Duplicate the current selection (or line if the selection is empty)."

	| sel |
	sel := self selectionRange.
	sel isEmpty 
		ifTrue: [self duplicateLine]
		ifFalse: 
			[| text |
			text := self plainTextRange: sel.
			self insertText: text at: sel stop + 1]!

goto: anInteger 
	"Move the caret to the specified position (not line) and ensure it is visible."

	self caretPosition: anInteger.
	self ensureCaretVisible!

gotoLine: anInteger 
	"Set caret to start of the line with the specified one-based <integer> index, ensure that
	the line is visible."

	self goto: (self positionAtLine: anInteger)!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self wantTab: true.	"Want tabs by default"!

insertText: aString at: anInteger 
	| caret |
	caret := self caretPosition.
	self
		caretPosition: anInteger;
		replaceSelection: aString;
		caretPosition: caret!

lineCount
	"Answers the number of lines in the receiver."

	^self sendMessage: EM_GETLINECOUNT
!

lineHeight: anInteger
	"Answer the height of the specified line of text in the receiver, expressed in pixels and
	not including any leading."

	| canvas height |
	canvas := self canvas.
	canvas font: self actualFont.
	height := canvas textMetrics tmHeight.
	canvas free.
	^height!

lineLength: anIntegerLineNumber
	"Answers the length of the line at anIntegerLineNumber."

	^self lineLengthFromPosition: (self positionAtLine: anIntegerLineNumber).
!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery>."

	| command |
	command := aCommandQuery commandSymbol.
	command == #toggleWordWrap 
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self wordWrap.
			^true].
	^super queryCommand: aCommandQuery!

resetCharFormat
	"Resets the formatting attributes of the selection to the default mode."!

selectCurrentLine
	"Selects the complete line of text in the receiver at which
	the caret is currently positioned, not including the end of
	line characters. Answer the range selected."

	^self selectLine: self currentLine!

selectLine: anInteger
	"Select the complete line of text in the receiver with the <integer>
	index, line, not including the end-of-line characters. Answer the selected 
	range."

	| range |
	range := self lineRange: anInteger.
	self selectionRange: range.
	^range!

selectLineAndTerminator: anInteger
	"Select the line on which the caret is located, including the line delimiter. If it is the last line 
	(i.e. there is no line terminator), selects the text to the end of line. Answer the selected
	range."

	| last |
	last := self lineCount.
	^anInteger = last 
		ifTrue: [self selectLine: anInteger]
		ifFalse: 
			[| range |
			range := (self positionAtLine: anInteger) 
						to: (self positionAtLine: anInteger + 1) - 1.
			self selectionRange: range.
			range]!

setTabStops: anInteger
	"Private - Set the width of the receiver's tab stops to anInteger."

	| width |
	width := DWORD fromInteger: anInteger.
	self sendMessage: EM_SETTABSTOPS wParam: 1 lpParam: width yourAddress
!

showVerticalScrollBar: aBoolean 
	(self 
		baseStyleMask: ##(WS_VSCROLL | ES_AUTOVSCROLL)
		set: aBoolean
		recreateIfChanged: false) ifTrue: [self frameChanged]!

tabFocus
	"Private - Sets focus to the receiver. Answers the View which previously had focus,
	or nil if none/invalid handle."

	^self setFocus!

tabWidth: anInteger
	"Change the visible size of a tab to be a multiple of the width of a space character."

	| canvas spaceWidth |
	canvas := self canvas.
	canvas font: self actualFont.
	spaceWidth := (canvas textExtent: ' ') x.
	canvas free.
	self setTabStops: anInteger * spaceWidth!

textAtLine: lineIndex
	"Private - Answer the text of a line at the given line index (1-based)."

	| length text |
	lineIndex <= 0 ifTrue: [^self errorSubscriptBounds: lineIndex].

	"EM_GETLINE has an unusual way of specifying the buffer size, which is that the size is in characters is written into the first word.
	It does not write a null terminator, but our strings have an implicit one anyway"
	length := self lineLength: lineIndex.
	text := Utf16String newFixed: length.
	text basicAt: 1 put: length.
	self
		sendMessage: EM_GETLINE
		wParam: lineIndex - 1
		lpParam: text.
	^text!

toggleWordWrap
	"Toggle the receiver into/out-of word wrap mode.
	Implementation Note: Changing word wrap mode causes the receiver to ge recreated, so we must
	restore focus if we had it. This is especially important given the Windows bug in IsDialogMessage
	which will go into an infinite loop if a keyboard shortcut or navigation key is pressed when the active
	view does not have focus anywhere."

	| focus |
	focus := self class focus.	
	self wordWrap: self wordWrap not.
	focus == self ifTrue: [self setFocus]
	!

wmKeyDown: message wParam: wParam lParam: lParam 
	"Private - Handle WM_KEYDOWN.
	Implementation Note: We override here in order to implement the correct behaviour for
	the ESCape key in dialogs (i.e. to send an IDCANCEL command to the dialog).
	MLEs will do this if they have previously received a WM_GETDLGCODE message, but we
	implement those internally in order to suppress a number of features (bugs) which
	otherwise occur. RichEdit controls attempt to close their immediate parent directly
	with a WM_CLOSE message, rather than sending a WM_COMMAND, which is completely wrong
	(why should the parent necessarily be a dialog?), and again they only do this if
	they have previously received a WM_GETDLGCODE (which again we absorb to suppress bugs).
	If the shell doesn't have an IDCANCEL button, then nothing will happen (which will be the
	usual case for non-dialog shells)."

	wParam == VK_ESCAPE 
		ifTrue: 
			[| shell cancel |
			shell := self topShell view.
			cancel := shell getItemHandle: IDCANCEL
						ifAbsent: 
							[^super 
								wmKeyDown: message
								wParam: wParam
								lParam: lParam].
			shell 
				sendMessage: WM_COMMAND
				wParam: ##(BN_CLICKED << 16 | IDCANCEL)
				lParam: cancel.
			^0	"Suppress default processing"].
	^super 
		wmKeyDown: message
		wParam: wParam
		lParam: lParam!

wmKeyUp: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_KEYUP.
	We override the implementation in our superclass since MultilineTextEdits
	do not update their model when Enter is pressed. Instead we answer nil 
	to accept default window processing."

	^nil!

wordWrap
	"Answer whether the receiver is in word wrap OR horizontal scrolling mode.
	This is a synonym for #canHScroll:, except that it is the boolean inversion."

	^self canHScroll not!

wordWrap: aBoolean
	"Set the receiver into word wrap OR horizontal scrolling mode, depending on the value of the
	<boolean> argument. This is a synonym for #canHScroll:, except that its effect is reversed."

	self canHScroll: aBoolean not! !
!MultilineTextEdit categoriesFor: #calculateExtent:!geometry!private! !
!MultilineTextEdit categoriesFor: #canHScroll!public!testing! !
!MultilineTextEdit categoriesFor: #canHScroll:!accessing-styles!public! !
!MultilineTextEdit categoriesFor: #canVScroll!public!testing! !
!MultilineTextEdit categoriesFor: #canVScroll:!accessing-styles!public! !
!MultilineTextEdit categoriesFor: #copyLine!clipboard operations!commands!public! !
!MultilineTextEdit categoriesFor: #copySelectionOrLine!clipboard operations!commands!public! !
!MultilineTextEdit categoriesFor: #currentLine!public!selection! !
!MultilineTextEdit categoriesFor: #cutLine!clipboard operations!commands!public! !
!MultilineTextEdit categoriesFor: #defaultExtent!constants!private! !
!MultilineTextEdit categoriesFor: #defaultWindowStyle!constants!private! !
!MultilineTextEdit categoriesFor: #deleteLine!commands!public! !
!MultilineTextEdit categoriesFor: #displayOnFormats!displaying!private! !
!MultilineTextEdit categoriesFor: #displayOnText!displaying!private! !
!MultilineTextEdit categoriesFor: #dlgCode!constants!private! !
!MultilineTextEdit categoriesFor: #duplicateLine!commands!public! !
!MultilineTextEdit categoriesFor: #duplicateSelection!commands!public! !
!MultilineTextEdit categoriesFor: #goto:!caret!public! !
!MultilineTextEdit categoriesFor: #gotoLine:!caret!commands!public! !
!MultilineTextEdit categoriesFor: #initialize!initializing!private! !
!MultilineTextEdit categoriesFor: #insertText:at:!public!text retrieval & modification! !
!MultilineTextEdit categoriesFor: #lineCount!accessing!public! !
!MultilineTextEdit categoriesFor: #lineHeight:!public! !
!MultilineTextEdit categoriesFor: #lineLength:!accessing!public! !
!MultilineTextEdit categoriesFor: #queryCommand:!commands!private! !
!MultilineTextEdit categoriesFor: #resetCharFormat!operations!public! !
!MultilineTextEdit categoriesFor: #selectCurrentLine!public!selection! !
!MultilineTextEdit categoriesFor: #selectLine:!public!selection! !
!MultilineTextEdit categoriesFor: #selectLineAndTerminator:!public!selection! !
!MultilineTextEdit categoriesFor: #setTabStops:!operations!private! !
!MultilineTextEdit categoriesFor: #showVerticalScrollBar:!accessing-styles!private! !
!MultilineTextEdit categoriesFor: #tabFocus!private!tabbing! !
!MultilineTextEdit categoriesFor: #tabWidth:!accessing!public! !
!MultilineTextEdit categoriesFor: #textAtLine:!accessing!private! !
!MultilineTextEdit categoriesFor: #toggleWordWrap!commands!public! !
!MultilineTextEdit categoriesFor: #wmKeyDown:wParam:lParam:!event handling-win32!private! !
!MultilineTextEdit categoriesFor: #wmKeyUp:wParam:lParam:!event handling-win32!private! !
!MultilineTextEdit categoriesFor: #wordWrap!accessing-styles!public! !
!MultilineTextEdit categoriesFor: #wordWrap:!accessing-styles!public! !

!MultilineTextEdit class methodsFor!

maxTextLimit
	"Private - Answer the absolute maximum amount of text that the receiver can ever hold."

	^16rFFFFFFFF! !
!MultilineTextEdit class categoriesFor: #maxTextLimit!constants!private! !

