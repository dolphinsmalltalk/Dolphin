"Filed out from Dolphin Smalltalk 7"!

UI.ValueConvertingControlView subclass: #'UI.TextEdit'
	instanceVariableNames: 'teFlags'
	classVariableNames: 'AlignmentMap FindDialogMessage FormatMap'
	imports: #(#{OS.TextEditConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'FindDisabledMask' -> 16r20.
		'ModifiedMask' -> 16r8.
		'ReadOnlyMask' -> 16r1.
		'StaticMask' -> 16r10.
		'UpdatePerCharMask' -> 16r2.
		'WantTabMask' -> 16r4
	}!
UI.TextEdit guid: (Core.GUID fromString: '{87b4c73a-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.TextEdit comment: 'TextEdit is a <valueView> class that implements the Windows "EDIT" control for the displaying and editing of single line text. The <valueModel> associated with a TextEdit must always yield a <readableString> value when mapped through the installed type converter. A TextEdit will normally be used in conjunction with a <TextPresenter>. 

The alignment of the text can be specified using the alignment aspect which can assume of of the following values: (#left, #center, #right). The #updatePerChar aspect, if set to true, will ensure that the editor''s associated model will be kept up to date with the view as each character is typed. If false, the update only takes place when the view loses focus.

Instance Variables:
	teFlags		<integer> flags for the mode of the editor.

Class Variables:
	EnMap		<IdentityDictionary> map of Windows notification messages to <selector>s.
	FindDialogMessage	<integer> registered Windows message for "commdlg_FindReplace"
	ReadOnlyMask	<integer> mask for the read-only mode flag.
	WantTabMask	<integer> mask for the want-tab mode flag.
	AlignmentMap	<LookupTable> mapping alignment <Symbol>s to Windows styles.
	UpdatePerCharMask	<integer> mask for the update-per-char mode flag.
'!
!UI.TextEdit categoriesForClass!MVP-Views! !
!UI.TextEdit methodsFor!

alignment
	"Answer a symbolic text alignment for the receiver's current mode."

	| typeFlags |
	typeFlags := self baseStyle bitAnd: ##(ES_LEFT | ES_CENTER | ES_RIGHT).
	^AlignmentMap keyAtValue: typeFlags ifAbsent: [#left]!

alignment: aSymbol
	"Sets the text alignment to the symbolic aligment name, aSymbol."

	self setAlignment: (AlignmentMap at: aSymbol).
	self invalidateCalculatedExtent
	!

apply
	"Apply the changes made to the edit to the receivers model. Answer whether
	any update actually occurred to the model."

	| modified |
	modified := self isTextModified.
	modified ifTrue: [self updateModel].
	^modified!

basicClearSelection
	self sendMessage: WM_CLEAR!

basicFindNext
	"Private - Hilight the next occurrence which satisfies the find operation held in findDetails."

	^self findDetails ifNil: [false] ifNotNil: [:findDetails | (self findNextWrapped: findDetails) notEmpty]!

basicLineFromPosition: anInteger
	"Private - Answers the zero-based line index from the zero-based character position, 
	anInteger."

	^self sendMessage: EM_LINEFROMCHAR wParam: anInteger
!

basicPositionAtLine: anInteger 
	^self sendMessage: EM_LINEINDEX wParam: anInteger!

basicSelectAll
	self basicSelectionStart: 0 end: -1!

basicSelectionRange
	"Private - Answer an interval identifying the selected range of text
	as reported by the underlying Windows control. Note that this
	range includes the starting character, but the end of the range
	is the first unselected character. Note further that this characteristic
	means that the range should NEVER be empty."

	| dwStart dwEnd |
	dwStart := DWORD new.
	dwEnd := DWORD new.
	self
		sendMessage: EM_GETSEL
		wParam: dwStart yourAddress
		lpParam: dwEnd.
	^dwStart asInteger to: dwEnd asInteger!

basicSelectionStart: start end: end
	"Private - Sets the selected range of text to the range defined by start and end 
	(0 based, end-exclusive). (0 to: -1) means select all. -1 for start means lose
	current selection. According to the Win32 help, EM_SETSEL does not return any 
	meaningful value."

	self sendMessage: EM_SETSEL wParam: start lParam: end!

calcRectangleFromClientRectangle: aRectangle
	"Private - Given a client rectangle represented by the <Rectangle> argument, answer the
	window rectangle that would be required to achieve this taking into account the current
	window styles etc Note that the answered rectangle is in the COORDINATE SYSTEM OF THE
	CLIENT.

	Implementation Note: We must override here because of EDIT controls implicit border."

	| rect |
	rect := RECTL fromRectangle: aRectangle.
	UserLibrary default
		adjustWindowRectEx: rect
		dwStyle: self baseStyle | WS_BORDER
		bMenu: false
		dwExStyle: self extendedStyle.
	^rect asRectangle!

calculateExtent: aLayoutContext
	"Private - Calculate an extent for the receiver that would allow it to display all the text that it currently contains on a single line."

	| canvas extent margins text |
	canvas := self canvas.
	canvas font: self actualFont.
	text := self plainText.
	extent := canvas
				textExtent: (text isEmpty ifTrue: ['.'] ifFalse: [text])
				width: 0
				flags: ##(DT_SINGLELINE | DT_EDITCONTROL | DT_NOPREFIX | DT_EXPANDTABS | DT_EXTERNALLEADING).
	canvas free.
	margins := self marginWidths.
	^self calcExtentFromClientExtent: extent + ((margins first + margins last) @ 0)!

canHScroll
	"Answer true if the receiver is in horizontal scrolling mode"

	^self baseStyleAllMask: ES_AUTOHSCROLL!

canHScroll: aBoolean 
	"Sets the receiver into horizontal scrolling mode if aBoolean is true. When this style is
	off the control limits the amount of text that can be entered to that which can be displayed
	in the box. When the style is on the user can enter text up to the #textLimit (the caret
	remains at the right edge of the field and the text scrolls left to accomodate new input)."

	"Implementation Note: The control ignores these style changes after creation,
	so we must accept the default action, which is to recreate the view."

	(self 
		baseStyleMask: ES_AUTOHSCROLL
		set: aBoolean
		recreateIfChanged: true) ifTrue: [self invalidateCalculatedExtent]!

canPaste
	"Answer whether the window can paste from the current contents of
	the clipboard."

	^self isReadOnly not and: [UserLibrary default isClipboardFormatAvailable: CF_UNICODETEXT]!

canRedo
	"Answer whether the window can redo the last undone operation."

	^false!

canUndo
	"Answer whether the window can undo the last edit-control operation."

	^(self sendMessage: EM_CANUNDO) == 1
!

caretPosition
	"Answer the insertion cursor position, as the number of characters from the start
	of the receivers text"

	^self selectionRange start	"Use #start to avoid bounds error if empty"!

caretPosition: anInteger
	"Sets the insertion cursor to be at the specified character position
	(which is one based, i.e. caretPosition 1 is home)."

	self selectionStart: anInteger end: anInteger-1!

charNearestPosition: aPoint 
	"Answer the one based index of the character nearest aPoint within the receiver.
	Note that, because of the word size return, this is limited to detection 
	within 65K of text"

	| pt |
	pt := self clientRectangle constrain: aPoint.
	^(self 
		sendMessage: EM_CHARFROMPOS
		wParam: 0
		lParam: pt asUIntPtr) lowWord + 1!

clear
	"Clears the contents of the receiver"

	self value: ''!

clearSelection
	"Delete the current selection from the receiver.
	N.B. If there is no selection, deletes the character immediately after the
	caret (i.e. behaves like Del key)."

	| range |
	range := self selectionRange.
	range isEmpty ifTrue: [self selectionStart: range start end: range start].
	self basicClearSelection!

command: anInteger id: id
	"Private - Handler for a redirected WM_COMMAND notification message."

	^((IdentityDictionary new
		at: 16r100 put: #enSetFocus;
		at: 16r200 put: #enKillFocus;
		at: 16r300 put: #enChange;
		at: 16r400 put: #enUpdate;
		at: 16r500 put: #errorOutOfMemory;
		at: 16r501 put: #enMaxText;
		shrink;
		yourself) lookup: anInteger)
		ifNotNil: [:selector | self perform: selector]!

copySelection
	"Copy the current selection to the clipboard."

	self sendMessage: WM_COPY
!

cueBanner
	"Answer the textual cue to be displayed when this single-line text box is empty and does not
	have focus, or nil if none is set."

	| buf |
	buf := Utf16String newFixed: 512.
	^((self
		sendMessage: EM_GETCUEBANNER
		wParam: buf yourAddress
		lParam: buf size + 1) ~~ 0
		and: [buf first ~~ $\0]) ifTrue: [buf trimNulls]!

cueBanner: aString
	"Set a textual cue to be displayed when this single line text box is empty and does not have
	focus."

	self
		sendMessage: EM_SETCUEBANNER
		wParam: 0
		szParam: aString ?? ''!

cutSelection
	"Cut the current selection and place on the clipboard."

	self sendMessage: WM_CUT
!

defaultSelectionRange
	^1 to: 0!

defaultTextLimit
	^30000!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitOr: WS_EX_CLIENTEDGE!

dispatchRegistered: registeredId wParam: wParam lParam: lParam 
	"Private - Handle the registered FindDialog message."

	registeredId == FindDialogMessage 
		ifTrue: 
			[^self 
				onFind: registeredId
				wParam: wParam
				lParam: lParam].
	^super 
		dispatchRegistered: registeredId
		wParam: wParam
		lParam: lParam!

displayValue
	"Private - Answer the displayed contents, the text, of the receiver"

	^self text!

displayValue: anObject
	"Private - Set the displayable contents, the text, of the receiver to the
	displayString of anObject"

	| newText |
	newText := anObject displayString.
	self displayValue = newText ifFalse: [
		"If the text has changed then set the new text for anObject"
		self text: newText ]!

dlgCode
	"Private - Answer the combination of DLGC flags usually appropriate for the
	receiver. This can be modified depending on the particular message received
	with a WM_GETDLGCODE."

	^##(DLGC_HASSETSEL | DLGC_WANTARROWS | DLGC_WANTCHARS)
!

dragOver: session
	"The drag operation described by  the <DragDropSession> session,
	 has moved to a new position over the receiver's window. 
	Implementation Note: Suggest the character position under the drop as a
	sensible drop target for most uses of TextEdit and its subclasses."

	| pt |
	pt := session dragPointInView: self view.
	session suggestedTarget: (self view charNearestPosition: pt).
	super dragOver: session!

editFind
	"Launch the common Find dialog."

	self findPrompt: self suggestedFindText!

emptyUndoBuffer
	self sendMessage: EM_EMPTYUNDOBUFFER
!

enChange
	"Private - The receiver's text has been updated, and the change has 
	been displayed. This could have caused the text rectangle to have
	changed, so invalidate the calculated extent."

	self presenter trigger: #textChanged.
	self invalidateCalculatedExtent.
	^nil!

enKillFocus
	"Private - The receiver is losing focus"

	self updateModel.	
	^self presenter onKillFocus.!

enMaxText
	"Private - The receiver has hit its current text limit. Sensible responses might be to expand
	the text limit with EM_SETLIMITTEXT (the default is 32Kb), or to inform the user that they are
	trying to enter too much data."

	^self onTextOverflow!

enSetFocus
	"Private - The receiver is gaining focus"

	^self presenter onSetFocus!

ensureCaretVisible
	self sendMessage: EM_SCROLLCARET!

enUpdate
	"Private - The receiver is about to display altered text.
	Note that this is fired when selecting text in the edit control, 
	as well as when keys are typed, but not when moving the caret 
	i.e. it indicates that the display has been updated."

	self invalidateUserInterface.
	^nil!

find
	"Launch the FindText dialog in response to a generic toolbar find command."

	self editFind!

find: aFindDetails range: anInterval 
	"Private - Find the first occurrence of text in the receiver that matches the specified
	<FindDetails>, within the range, anInterval. Answer the <Interval> of the match (an
	empty interval if not found)."

	^aFindDetails findIn: self range: anInterval!

findDetails
	"Private - TextEdit does not store information about the find operation, but its presenter
	might."

	^self presenter == self ifFalse: [self presenter findDetails]!

findDetails: aFindDetails 
	"Private - TextEdit does not provide storage for details of the last find, but its presenter
	might."

	^self presenter == self ifFalse: [self presenter findDetails: aFindDetails]!

findDialogClass
	^#{AdvancedFindDialog} valueOrNil ?? UI.FindDialog!

findNext
	"Hilight the next occurrence which satisfies the find operation held in findDetails."

	self findDetails isNil
		ifTrue: [self find]
		ifFalse: [self basicFindNext ifFalse: [Sound defaultBeep]]!

findNext: aFindDetails
	| match |
	match := self findNextWrapped: aFindDetails.
	match isEmpty
		ifTrue: 
			["Not found, cancel the selection."
			self selectionStart: (aFindDetails isForwards
						ifTrue: [self selectionRange stop + 1]
						ifFalse: [self selectionRange start])
				length: 0].
	^match!

findNextWrapped: aFindDetails 
	"Find the next match with the specified <FindDetails> in the text of the receiver forward
	from the current insert location. The search wraps and selects any match found. Answer an
	<Interval> that describes the range of text occuppied by the match, or an empty <Interval>
	if no further matches are found."

	| selRange match rangeAbove rangeBelow |
	selRange := self selectionRange.
	rangeAbove := 1 to: selRange start - 1.
	rangeBelow := selRange stop + 1 to: self textLength.
	match := self find: aFindDetails
				range: (aFindDetails isForwards ifTrue: [rangeBelow] ifFalse: [rangeAbove]).
	(match isEmpty and: [aFindDetails isWrapAround]) 
		ifTrue: 
			[match := self find: aFindDetails
						range: (aFindDetails isForwards ifTrue: [rangeAbove] ifFalse: [rangeBelow])].
	match isEmpty ifFalse: [self highlightFindMatch: match].
	^match!

findPrompt: aString
	"Private - Launch the modeless Find dialog.
	Pre-populate the dialog with aString."

	| details dialogClass |
	dialogClass := self findDialogClass.
	details := self findDetails ifNil: [dialogClass defaultModel].
	details pattern: aString.
	^dialogClass showModeless: self on: details!

findReplace
	"Launch the FindReplaceText dialog."

	self findReplacePrompt: self suggestedFindText!

findReplacePrompt: aString
	"Launch the FindReplaceText dialog."

	UI.FindReplaceDialog ownerView: self findWhat: aString!

format
	"Answer the current format mode of the receiver, one of #mixed, #upperCase, 
	#lowerCase or #numeric. The default is #mixed. The #upperCase and #lowerCase
	modes force text into upper or lower case respectively, and the #numeric mode
	restricts entry to digits only."

	| fmtFlags |
	fmtFlags := self baseStyle bitAnd: ##(ES_UPPERCASE | ES_LOWERCASE | ES_NUMBER).
	^FormatMap keyAtValue: fmtFlags ifAbsent: [#mixed]!

format: aSymbol 
	"Sets the text format to the symbolic format name, aSymbol. 
	See #format for further details.
	Note that any existing text in the edit control is unaffected by changing
	the mode - it only affects subsequent text entry."

	self 
		baseStyle: (FormatMap at: aSymbol)
		maskedBy: ##(ES_LOWERCASE | ES_UPPERCASE | ES_NUMBER)
		recreateIfChanged: false!

formatRectangle
	"Answers the Rectangle used to format the text"

	| rect |
	rect := RECTL new.
	self
		sendMessage: EM_GETRECT
		wParam: 0
		lpParam: rect.
	^rect asRectangle!

hasSelection
	"Answer true if the receiver has a selected range of text.
	Implementation Note: The simplest implementation of this would be
		self selectionRange isEmpty
	But because the selection range reported by the control sometimes
	includes the phantom end character (e.g. if a single line and the entire
	range of text is selected), the #selectionRange message always 
	accesses the #textLength of the control to 'adjust' the selection range
	so it does not include the phantom character. Getting the text length
	of a control with a lot of text on it can be very slow on certain platforms,	
	so we want to avoid that if at all possible. In this case we only need check
	it if the selection length is 1, as otherwise there is no selection, or the selection
	includes at least one other character in addition to the phantom end character."

	| range len |
	range := self basicSelectionRange.
	len := range size.
	^range size > 1 and: 
			[range size > 2 or: 
					[| selStart selEnd |
					"Make sure that the selection doesn't try to include the phantom end character."
					len := self textLength.
					(selEnd := range stop) > len ifTrue: [selEnd := len].
					(selStart := range start) > len ifTrue: [selStart := len].
					(selStart + 1 to: selEnd) notEmpty]]!

highlightFindMatch: anInterval 
	self selectionRange: anInterval!

initialize
	"Private - Initialize the receiver"

	super initialize.
	teFlags := 0.		"Tabs not wanted by default"!

initializeNewTypeConverter: aTypeConverter
	aTypeConverter rightNullValue: ''!

isFindEnabled
	"Answer whether the find and find/replace commands are enabled."

	^teFlags noMask: FindDisabledMask!

isFindEnabled: aBoolean 
	"Set whether the find and find/replace commands are enabled in the receiver."

	teFlags := teFlags mask: FindDisabledMask set: aBoolean not!

isModified
	"Answer true if the receiver's text has been modified.
	Note that this must be explicitly reset."

	^(teFlags allMask: ModifiedMask) or: [self isTextModified]!

isModified: aBoolean
	"Set the receiver's text modification flag.
	Implementation Note: If resetting the flag then we must make sure that
	the model is in sync. with the view, as otherwise any pending changes
	may be lost."

	aBoolean ifFalse: [self updateModel].
	teFlags := teFlags mask: ModifiedMask set: aBoolean.
	self assert: [self isModified == aBoolean]!

isPassword
	"Answer whether the receiver is a password entry field (i.e. it has the
	ES_PASSWORD style."

	^self baseStyleAllMask: ES_PASSWORD!

isPassword: aBoolean
	"Sets the receiver to use the ES_PASSWORD style or not depending on the value of aBoolean."

	self 
		baseStyleMask: ES_PASSWORD
		set: aBoolean
		recreateIfChanged: true	"Recreate required for this change to take effect"!

isReadOnly
	"Answer whether the receiver is in read only mode."

	^teFlags anyMask: ReadOnlyMask!

isReadOnly: aBoolean 
	"Sets the receiver into read only mode if aBoolean is true. Otherwise
	it is set into edit mode."

	| newFlags |
	newFlags := teFlags mask: ReadOnlyMask set: aBoolean.
	teFlags = newFlags ifTrue: [^self].
	teFlags := newFlags.
	self setReadOnly: aBoolean!

isSelectionKept
	"Answer true if the receiver is set to maintain selection even after losing focus.
	This is a manifestation of the ES_NOHIDESEL style"

	^self baseStyleAllMask: ES_NOHIDESEL!

isSelectionKept: aBoolean
	"Sets the receiver to maintain selection after losing focus according to aBoolean.
	This is a manifestation of the ES_NOHIDESEL style"

	self 
		baseStyleMask: ES_NOHIDESEL
		set: aBoolean
		recreateIfChanged: true	"Recreate required for this change to take effect"!

isStatic
	"Answer whether the receiver is in static (non-selectable) mode."

	^teFlags anyMask: StaticMask!

isStatic: aBoolean
	"Sets the receiver into static mode if aBoolean is true. Otherwise
	it is set into selectable mode."

	teFlags := teFlags mask: StaticMask set: aBoolean.

!

isTextModified
	"Private - Answer whether the receiver's text has been modified since last sync'd with
	the model."

	^(self sendMessage: EM_GETMODIFY) ~~ 0!

isTextModified: aBoolean
	"Private - Set the receiver's text modification flag."

	self sendMessage: EM_SETMODIFY wParam: aBoolean asParameter!

isUpdatePerChar
	"Answer whether the receiver is in update per character mode."

	^self updatePerChar!

isUpdatePerChar: aBoolean
	"Sets the receiver into update per char mode if aBoolean is true"

	self updatePerChar: aBoolean
!

lineCount
	"Answers the number of lines in the receiver."

	^1!

lineFromPosition: anInteger 
	"Answers the one-based line index of the character at the one based position, anInteger. In
	the case of a single-line <TextEdit> the answer will always be one, unless the position is
	out of range in which case a BoundsError will be raised."

	^anInteger < 1 
		ifTrue: [self errorSubscriptBounds: anInteger]
		ifFalse: [(self basicLineFromPosition: anInteger - 1) + 1]!

lineLengthFromPosition: anInteger 
	"Private - Answer the <integer> length of the line containing the specified <integer>
	character position. Raise a BoundsError if the character position is out of bounds."

	"Implementation Note: We defer an expensive text length check unless the control reports a
	zero length line, which could be due to a request for a position off the end of the text."

	| len |
	anInteger < 1 ifTrue: [^self errorSubscriptBounds: anInteger].
	len := self sendMessage: EM_LINELENGTH wParam: anInteger - 1.
	^(len == 0 and: [self textLength + 1 < anInteger]) 
		ifTrue: [self errorSubscriptBounds: anInteger]
		ifFalse: [len]!

lineRange: anInteger
	"Answer an <Interval> specifying the range of character positions in the 
	receiver occuppied by the line with the specified <integer> index,
	not including the end-of-line terminators (if any)."

	| start |
	anInteger < 1 ifTrue: [^self errorSubscriptBounds: anInteger].
	start := self positionAtLine: anInteger.
	^start to: start + (self lineLengthFromPosition: start) - 1!

lineScroll
	"Answers the number of the first line displayed in the receiver"

	^(self sendMessage: EM_GETFIRSTVISIBLELINE)+1

!

lineScroll: anIntegerLineNumber
	"Scrolls the text in the receiver to display the line at anIntegerLineNumber"

	self lineScrollBy: anIntegerLineNumber-self lineScroll

!

lineScrollBy: anIntegerNumberOfLines
	"Scrolls the text in the receiver by anIntegerNumberOfLines"

	self sendMessage: EM_LINESCROLL wParam: 0 lParam: anIntegerNumberOfLines

!

marginWidths
	"Private - Answer the left and right margins."

	| dword |
	dword := self sendMessage: EM_GETMARGINS.
	^{dword highWord. dword lowWord}!

maxTextLimit
	"Private - Answer the absolute maximum amount of text that the receiver can ever hold."

	^self class maxTextLimit!

onFind: aFindDetails
	"Handle a  find/replace dialog command."

	| action |
	self presenter ifNotNil: [:p | p findDetails: aFindDetails].
	action := aFindDetails action.
	#findNext == action
		ifTrue: 
			[(self findNext: aFindDetails) isEmpty ifTrue: [Sound warningBeep].
			^self].
	#replace == action
		ifTrue: 
			[self replace: aFindDetails.
			^self].
	#replaceAll == action
		ifTrue: 
			[self replaceAll: aFindDetails.
			^self].
	Sound warningBeep!

onFind: registeredId wParam: wParam lParam: lParam
	| details struct |
	struct := FINDREPLACEW fromAddress: lParam.
	struct isClosing
		ifTrue: 
			["The FindDialog is closing."
			^0].
	details := struct findDetails.
	^self onFind: details!

onInputMaskRequired: anEvent
	"Private - Handler for a WM_GETDLGCODE. 
	Implementation Note: We override this message primarily because of the
	strange behaviour which WM_GETDLGCODE otherwise induces in the MLE
	control. It seems that the MLE assumes that it is a child of a Dialog 
	if it receives this message which causes it to not insert tabs received 
	through WM_CHAR. In order to suppress this inconsistent feature, we override 
	WM_GETDLGCODE to ensure the control never actually receives it. This keeps 
	its behaviour sane, and means we do not need workarounds in WM_CHAR (to 
	forcibly insert VK_TABs). It also enables us to implement WantTab functionality
	which windows does not support directly as an Edit control style."

	| dlgCode |
	dlgCode := self dlgCode.
	self wantTab
		ifTrue: [dlgCode := dlgCode maskSet: DLGC_WANTTAB]
		ifFalse: 
			[| msg |
			((msg := MSG fromAddress: anEvent lParam) notNil
				and: [msg message == WM_KEYDOWN and: [msg wParam == VK_TAB]])
					ifTrue: [dlgCode := dlgCode maskClear: ##(DLGC_WANTALLKEYS | DLGC_WANTTAB)]].
	^dlgCode!

onKeyTyped: aKeyEvent 
	"Handle aKeyEvent. If the receiver is in updatePerChar mode, then we
	update the model immediately after processing the character."

	"Implementation Note: Sadly the edit control does not insert tabs if used 
	in conjunction with IsDialogMessage(), even though it says it wants to 
	receive them. We therefore fix this bug overridding WM_GETDLGCODE and never
	allowing it to reach the control. This prevents the control from getting the
	notion that it is in a dialog, and retains the saner behaviour.
	An alternative workaround to implementing WM_GETDLGCODE would be to
	recode this method thus:
		...
		| answer |
		answer := aKeyEvent code == VK_TAB
			ifTrue: [self replaceSelection: String tab. 0]
			ifFalse: [super onKeyTyped: aKeyEvent].
		...
	However the WM_GETDLGCODE override is preferred, because it prevents other nasties
	too."

	| answer |
	answer := super onKeyTyped: aKeyEvent.
	self updatePerChar ifTrue: [self updateModel].
	^answer!

onTextChanged
	self invalidateCalculatedExtent.
	^nil!

onTextOverflow
	"Private - Default handler for EN_MAXTEXT notification."

	self presenter trigger: #textOverflow.
	^nil!

onTipTextRequired: tool 
	"Tool tip text is required for the <ToolbarItem>, tool."

	| cmd |
	cmd := tool command asSymbol.
	#find == cmd ifTrue: [^'Find text'].
	#findNext == cmd ifTrue: [^'Find next  ' , self findDetails pattern printString].
	#clearSelection == cmd ifTrue: [^'Delete selected text'].
	^super onTipTextRequired: tool!

onViewCreated
	"The receiver window has been created"

	super onViewCreated.
	self setMarginWidths: #(0 0).
	self isReadOnly ifTrue: [self setReadOnly: true]!

passwordCharacter
	"Answer the <Character> displayed for every password typed when the receiver 
	has the password style, or nil if not set.
	N.B. On XP this could be a Unicode character, in which case this accessor will 
	fail."

	| code |
	code := self sendMessage: EM_GETPASSWORDCHAR.
	^code = 0 ifFalse: [Character codePoint: code]!

passwordCharacter: aCharacter 
	"Set the <Character> displayed for every password typed when the receiver 
	has the password style."

	self sendMessage: EM_SETPASSWORDCHAR wParam: aCharacter asInteger!

pasteClipboard
	"Paste the clipboard text into the receiver's window."

	self sendMessage: WM_PASTE!

pastePlainText
	"Paste the clipboard text into the receiver's window."

	self pasteClipboard!

plainTextAtLine: anInteger 
	^self plainTextRange: (self lineRange: anInteger)!

positionAtLine: anInteger 
	"Answer the index of the first character in the specified line (if 0 then
	the line containing the caret). Raise a BoundsError if the lineNumber is 
	<= 0 or > number of lines."

	| index |
	index := self basicPositionAtLine: anInteger - 1.
	^index < 0 ifTrue: [self errorSubscriptBounds: anInteger] ifFalse: [index + 1]!

positionForKeyboardContextMenu
	"Answer the desired position for a context menu requested from the keyboard.
	This should be based on the 'current selection', whatever that means in the context of the
	receiver. Should be overridden by subclasses as appropriate."

	^(self mapPointToScreen: (self positionOfChar: self caretPosition)) + (0 @ 20)!

positionOfChar: anInteger 
	"Map the one-based index of a character in the receiver to its client co-ordinates
	within the receiver."

	"Note that the parameters and return type of this message vary depending on the particular edit control. 
	For Edit controls (from MSDN):
	-	wParam: Specifies the zero-based index of the character. 
	-	lParam:This parameter is not used
	-	The return value contains the client area coordinates of the character. The
		low-order word contains the horizontal coordinate and the high-order word contains
		the vertical coordinate"

	| ret |
	ret := self sendMessage: EM_POSFROMCHAR wParam: anInteger - 1.
	ret = -1 ifTrue: [^self errorSubscriptBounds: anInteger].
	^ret lowWord @ ret highWord!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG,
	which is a keyboard message.
	In order to support tabbing out of edit fields which use tabs for input (
	i.e. wantTab answers true), we pretranslate any Ctrl+Tab keyboard input,
	and tab out on key down."

	(aMSG wParam == VK_TAB and: [self wantTab and: [Keyboard default isCtrlDown]])
		ifTrue: 
			["On Ctrl+Tab down, tab to next"
			aMSG message == WM_KEYDOWN ifTrue: [self tabNext].
			"Absorb any Ctrl+Tab messages"
			^true].
	^false!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery> argument."

	| command |
	command := aCommandQuery commandSymbol.
	(#(#pasteClipboard #pastePlainText) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: self canPaste.
			^true].
	#copySelection == command 
		ifTrue: 
			[aCommandQuery
				receiver: self;
				isEnabled: self hasSelection.
			^true].
	(#(#cutSelection #clearSelection #clear) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery
				receiver: self;
				isEnabled: (self isReadOnly not and: [self hasSelection]).
			^true].
	(#(#editFind #find) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: (self isFindEnabled and: [self textLength > 0]).
			^true].
	#findReplace == command 
		ifTrue: 
			[aCommandQuery isEnabled: (self isFindEnabled and: [self isReadOnly not and: [self textLength > 0]]).
			^true].
	command == #findNext 
		ifTrue: 
			[aCommandQuery isEnabled: self findDetails notNil.
			^true].
	command == #apply 
		ifTrue: 
			[aCommandQuery isEnabled: self isTextModified.
			^true].
	command == #undo 
		ifTrue: 
			[aCommandQuery isEnabled: self canUndo.
			^true].
	^super queryCommand: aCommandQuery!

redo
	"Redo the last undone edit action."

	^self error: 'Redo not supported'!

refreshContents
	"The model held by the receiver has been changed so refresh 
	the receiver contents. Overridden here since TextEdit and subclasses
	are allowed to have no model. This is for efficiency, to avoid having to 
	maintain two copies of possibly large text (one in Windows, one in Smalltalk)"

	self model notNil ifTrue: [ super refreshContents ]!

replace: aFindDetails
	| selection replaced nextMatch |
	selection := self selection.
	replaced := false.
	(aFindDetails isCaseSensitive
		ifTrue: [selection = aFindDetails pattern]
		ifFalse: [selection sameAs: aFindDetails pattern])
			ifTrue: 
				[self replaceSelection: aFindDetails replaceWith.
				replaced := true].
	nextMatch := self findNext: aFindDetails.
	(nextMatch isEmpty and: [replaced not]) ifTrue: [Sound warningBeep].
	^nextMatch!

replaceAll: aFindDetails 
	[(self replace: aFindDetails) notEmpty] whileTrue!

replaceSelection: text
	"Replace the receiver's current selection with the Rich or plain text 
	argument, text. Double dispatch to 'text' to do the right thing."

	text replaceSelectionIn: self!

scrollDown
	"Scroll the document down, keeping the caret visible."

	self sendMessage: EM_SCROLL wParam: SB_LINEDOWN!

scrollToEnd
	"Scroll the receiver to display the last available line"

	self lineScroll: self lineCount!

scrollUp
	"Scroll the document up, keeping the caret visible."

	self sendMessage: EM_SCROLL wParam: SB_LINEUP!

selectAll
	"Select all the text in the receiver, and answer the new selection range."

	self basicSelectAll.
	^1 to: self textLength!

selectAllIfSingleLine
	"Select all the text in the receiver if there is only one line"

	self lineCount < 2 ifTrue: [self selectAll]!

selection
	"Answer a String containing the receiver's currently selected text"

	| range |
	range := self selectionRange.
	^self plainTextRange: range!

selectionPlainText: aString
	"Private - Replace the receiver's current selection with aString.
	EM_REPLACESEL does not return a value."

	self
		sendMessage: EM_REPLACESEL
		wParam: 0
		szParam: aString!

selectionRange
	"Answers an interval identifying the selected range of text.
	We convert the Windows' control's rather unconventional
	interval to a form consistent with Smalltalk - i.e. entirely
	inclusive, with an empty interval being signified by the
	start of the interval being greater than the end.
	The caret position is always indicated by the first element
	in the selection range, regardless of whether there is any
	actual selection."

	| range selStart selEnd |
	range := self basicSelectionRange.
	selStart := range start.
	selEnd := range stop.
	selEnd > selStart 
		ifTrue: 
			["Make sure that the selection doesn't try to include the phantom end character."

			"#textLength can be very slow for a large amount of text so we need to 
			   cache the value (use EN_CHANGED notification to clear cached value"
			| textLen |
			#todo.
			textLen := self textLength.
			selEnd := selEnd min: textLen.
			selStart := selStart min: textLen].
	^selStart + 1 to: selEnd!

selectionRange: anInterval
	"Sets the selected range of text to the range provided in anInterval
	(the interval includes the start of the selection, but the last
	character in the interval is not included in the selection, but
	instead identifies the first non-selected character after that
	point)."

	^self selectionStart: anInterval start end: anInterval stop
!

selectionStart: start end: end
	"Sets the selected range of text to the range defined by the parameters start 
	and end (1 based, start and end inclusive)."

	^self basicSelectionStart: start-1 end: end
!

selectionStart: start length: length
	"Sets the selected range of text to the range defined by the parameters start (1 based) and length."

	^self basicSelectionStart: start-1 end: start-1+length
!

selectLine: anInteger
	"Selects a complete line of text in the receiver indicated by anInteger
	line number. Answers the selected range."

	"Implemenation Note: As the receiver represents a single line of text 
	the argument must always be line 1."

	anInteger == 1 ifFalse: [^self errorSubscriptBounds: anInteger].
	^self selectAll!

setAlignment: anInteger
	"Private - Sets the text alignment to anInteger, one of ES_LEFT, ES_CENTER, ES_RIGHT"

	self baseStyle: anInteger maskedBy: ##(ES_LEFT|ES_CENTER|ES_RIGHT)!

setMarginWidths: anArray
	| margins |
	SystemMetrics current hasTextBoxMargins ifFalse: [^self].
	margins := DWORD new
				highWord: anArray first;
				lowWord: anArray last.
	self
		sendMessage: EM_SETMARGINS
		wParam: (EC_LEFTMARGIN bitOr: EC_RIGHTMARGIN)
		lParam: margins asParameter!

setReadOnly: aBoolean
	"Private - Instruct the receiver's control to be read-only or writeable depending
	on the value of aBoolean."

	self sendMessage: EM_SETREADONLY wParam: aBoolean asParameter!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	| state margins sel limit |
	state := super state.
	sel := self selectionRange.
	sel = self defaultSelectionRange
		ifFalse: 
			[state add: (MessageSend
						receiver: self
						selector: #selectionRange:
						argument: sel)].
	self isTextModified
		ifTrue: 
			[state add: (MessageSend
						receiver: self
						selector: #isTextModified:
						argument: true)].
	margins := self marginWidths.
	margins = #(0 0)
		ifFalse: 
			[state add: (MessageSend
						receiver: self
						selector: #setMarginWidths:
						argument: margins)].
	self cueBanner
		ifNotNil: 
			[:cue |
			cue isEmpty
				ifFalse: 
					[state add: (MessageSend
								receiver: self
								selector: #cueBanner:
								argument: cue)]].
	limit := self textLimit.
	limit = self defaultTextLimit
		ifFalse: 
			[state add: (MessageSend
						receiver: self
						selector: #textLimit:
						argument: limit)].
	^state!

suggestedFindText
	"Private - Answer the text which will be used to pre-populate the find/replace dialog."

	| prompt |
	prompt := self selection.
	prompt isEmpty 
		ifTrue: [self findDetails notNil ifTrue: [prompt := self findDetails pattern]].
	^prompt!

tabFocus
	"Private - Sets focus to the receiver.
	For text fields, we also select the contents."

	| answer |
	answer := super tabFocus.
	self selectAll.
	^answer
!

textLimit
	"Answer the current text limit for the control (i.e. the amount of text it can hold)."

	^(self sendMessage: EM_GETLIMITTEXT) asDword!

textLimit: anInteger
	"Set the maximum text limit for the receiver. The initial default limit is around 32kb.
	N.B.  The maximum limits are as follows:
		Single Line
			NT		-  0x7FFFFFFE 
			95/98	- 16r7FFE (i.e. less than 32kb).
		Multiline
			NT		-  16rFFFFFFFF
			95/98	- 16rFFFF
	"

	(anInteger between: 1 and: self maxTextLimit) ifFalse: [self errorSubscriptBounds: anInteger].
	self sendMessage: EM_SETLIMITTEXT wParam: anInteger lParam: 0!

textRange
	"Answers an interval identifying the complete range of text."

	^1 to: self textLength
!

undo
	"Undo the last undoable edit action."

	self sendMessage: EM_UNDO!

updateModel
	"Private - The displayed value of the receiver may have been changed so set this
	back into the model after first running through the type converter.
	Overridden here since TextEdit and subclasses are allowed to have no model, and
	also because we can detect if the view's representation has actually changed since
	we sync'd back to the model. The option to have no model is for efficiency, to avoid 
	having to maintain two copies of possibly 	large text (one in Windows, one in Smalltalk)."

	self isTextModified ifFalse: [^self].
	self isTextModified: false.
	self isModified: true.
	self model notNil ifTrue: [super updateModel]!

updatePerChar
	"Answer true if the receiver is to update its model as each character is typed"

	^teFlags anyMask: UpdatePerCharMask
	!

updatePerChar: aBoolean
	"Set the receiver to update its model as each character is typed if aBoolean
	is true"

	teFlags := teFlags mask: UpdatePerCharMask set: aBoolean!

value
	"Answer the value of the receiver."

	"Implementation Note: Overridden here since TextEdit and subclasses can 
	potentially have no model. This method accesses the 	receiver's window directly 
	via #displayValue where that is the case."

	^self model 
		ifNil: [self typeconverter convertFromRightToLeft: self displayValue]
		ifNotNil: [:m | m value]!

value: anObject
	"Set the value of the receiver to anObject."

	"Implementation Note: Overridden here since TextEdit and subclasses can 
	potentially have no model. This method accesses the receiver's window directly 
	via #displayValue: where that is the case."

	self model 
		ifNil: [self displayValue: (self typeconverter convertFromLeftToRight: anObject)]
		ifNotNil: [:m | m value: anObject]!

wantReturn
	"Answer whether the receiver wishes to receiver ENTER keystrokes
	as input, as opposed to allowing them to be used for navigation/default
	button depression (i.e. whether the receiver has the ES_WANTRETURN style).
	Note that this is only relevant to a <MultilineTextEdit> (where it becomes
	a published aspect), but we implement at this level anyway because 
	the control itself allows this style to be set even on a single-line instance."

	^self baseStyleAllMask: ES_WANTRETURN!

wantReturn: aBoolean
	"Sets the receiver to have the ES_WANTRETURN style or not depending on 
	the value of aBoolean."

	self baseStyleMask: ES_WANTRETURN set: aBoolean!

wantTab
	"Answer whether the receiver wishes to receiver tab characters as WM_CHAR messages."

	^teFlags anyMask: WantTabMask!

wantTab: aBoolean
	"Set whether the receiver wishes to receiver tab characters as WM_CHAR messages."

	teFlags := teFlags mask: WantTabMask set: aBoolean!

wmKeyDown: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_KEYDOWN.
	Implementation Note: We need to override in order to be able to
	apply changes back to the model in the case of VK_RETURN, or VK_DELETE
	in update per char mode."

	| answer |
	answer := super wmKeyDown: message wParam: wParam lParam: lParam.
	wParam = VK_RETURN 
		ifTrue: [
			"There was a bug in Dolphin versions prior to 4.0 whereby the model would be updated
			regardless of the setting of the wantReturn style - we don't want to update the model 
			if the want return style is on since it is not then a control key, and indeed this could cause quite
			strange behaviour where a MultilineTextEdit was used in a dialog with PushButtons."
			(self updatePerChar or: [self wantReturn not])
				ifTrue: [self updateModel]]
		ifFalse: [
			(wParam = VK_DELETE and: [self updatePerChar])
				ifTrue: [self updateModel]].
	^answer!

wmKillFocus: message wParam: wParam lParam: lParam
	"Private - This window is losing focus. 
	Handled by #enKillFocus notification"

	^nil!

wmNcHitTest: message wParam: wParam lParam: lParam
	"Private - Default handler for a WM_NCHITTEST. 
	Answer nil to accept default window processing."

	self isStatic ifTrue: [^HTTRANSPARENT].

	^super wmNcHitTest: message wParam: wParam lParam: lParam
!

wmSetFocus: message wParam: wParam lParam: lParam
	"Private - This window is getting focus.
	Handled by #enSetFocus notification."

	^nil! !
!UI.TextEdit categoriesFor: #alignment!accessing!public! !
!UI.TextEdit categoriesFor: #alignment:!accessing!public! !
!UI.TextEdit categoriesFor: #apply!commands!public! !
!UI.TextEdit categoriesFor: #basicClearSelection!helpers!private! !
!UI.TextEdit categoriesFor: #basicFindNext!private!searching & replacing! !
!UI.TextEdit categoriesFor: #basicLineFromPosition:!accessing!private! !
!UI.TextEdit categoriesFor: #basicPositionAtLine:!accessing!private! !
!UI.TextEdit categoriesFor: #basicSelectAll!private!selection! !
!UI.TextEdit categoriesFor: #basicSelectionRange!accessing!private! !
!UI.TextEdit categoriesFor: #basicSelectionStart:end:!accessing!private! !
!UI.TextEdit categoriesFor: #calcRectangleFromClientRectangle:!geometry!private! !
!UI.TextEdit categoriesFor: #calculateExtent:!geometry!private! !
!UI.TextEdit categoriesFor: #canHScroll!accessing-styles!public! !
!UI.TextEdit categoriesFor: #canHScroll:!accessing-styles!public! !
!UI.TextEdit categoriesFor: #canPaste!clipboard operations!public!testing! !
!UI.TextEdit categoriesFor: #canRedo!public!testing!undo & redo! !
!UI.TextEdit categoriesFor: #canUndo!public!testing!undo & redo! !
!UI.TextEdit categoriesFor: #caretPosition!caret!public! !
!UI.TextEdit categoriesFor: #caretPosition:!accessing!caret!public! !
!UI.TextEdit categoriesFor: #charNearestPosition:!accessing!public! !
!UI.TextEdit categoriesFor: #clear!operations!public! !
!UI.TextEdit categoriesFor: #clearSelection!clipboard operations!commands!public! !
!UI.TextEdit categoriesFor: #command:id:!commands!private! !
!UI.TextEdit categoriesFor: #copySelection!clipboard operations!commands!public! !
!UI.TextEdit categoriesFor: #cueBanner!accessing!public! !
!UI.TextEdit categoriesFor: #cueBanner:!accessing!public! !
!UI.TextEdit categoriesFor: #cutSelection!clipboard operations!commands!public! !
!UI.TextEdit categoriesFor: #defaultSelectionRange!constants!private! !
!UI.TextEdit categoriesFor: #defaultTextLimit!constants!private! !
!UI.TextEdit categoriesFor: #defaultWindowExStyle!constants!private! !
!UI.TextEdit categoriesFor: #dispatchRegistered:wParam:lParam:!dispatching!private! !
!UI.TextEdit categoriesFor: #displayValue!private!updating! !
!UI.TextEdit categoriesFor: #displayValue:!private!updating! !
!UI.TextEdit categoriesFor: #dlgCode!constants!private! !
!UI.TextEdit categoriesFor: #dragOver:!drag & drop!public! !
!UI.TextEdit categoriesFor: #editFind!commands!public!searching & replacing! !
!UI.TextEdit categoriesFor: #emptyUndoBuffer!commands!public!undo & redo! !
!UI.TextEdit categoriesFor: #enChange!event handling-win32!private! !
!UI.TextEdit categoriesFor: #enKillFocus!event handling-win32!private! !
!UI.TextEdit categoriesFor: #enMaxText!event handling-win32!private! !
!UI.TextEdit categoriesFor: #enSetFocus!event handling-win32!private! !
!UI.TextEdit categoriesFor: #ensureCaretVisible!caret!operations!public! !
!UI.TextEdit categoriesFor: #enUpdate!event handling-win32!private! !
!UI.TextEdit categoriesFor: #find!public!searching & replacing! !
!UI.TextEdit categoriesFor: #find:range:!private!searching & replacing! !
!UI.TextEdit categoriesFor: #findDetails!private!searching & replacing! !
!UI.TextEdit categoriesFor: #findDetails:!private!searching & replacing! !
!UI.TextEdit categoriesFor: #findDialogClass!constants!private! !
!UI.TextEdit categoriesFor: #findNext!commands!public!searching & replacing! !
!UI.TextEdit categoriesFor: #findNext:!helpers!private!searching & replacing! !
!UI.TextEdit categoriesFor: #findNextWrapped:!public!searching & replacing! !
!UI.TextEdit categoriesFor: #findPrompt:!private!searching & replacing! !
!UI.TextEdit categoriesFor: #findReplace!commands!public!searching & replacing! !
!UI.TextEdit categoriesFor: #findReplacePrompt:!public!searching & replacing! !
!UI.TextEdit categoriesFor: #format!public!testing! !
!UI.TextEdit categoriesFor: #format:!accessing!public! !
!UI.TextEdit categoriesFor: #formatRectangle!accessing!public! !
!UI.TextEdit categoriesFor: #hasSelection!public!selection! !
!UI.TextEdit categoriesFor: #highlightFindMatch:!private!searching & replacing! !
!UI.TextEdit categoriesFor: #initialize!initializing!private! !
!UI.TextEdit categoriesFor: #initializeNewTypeConverter:!accessing!private! !
!UI.TextEdit categoriesFor: #isFindEnabled!public!testing! !
!UI.TextEdit categoriesFor: #isFindEnabled:!accessing!public! !
!UI.TextEdit categoriesFor: #isModified!public!testing! !
!UI.TextEdit categoriesFor: #isModified:!modes!public! !
!UI.TextEdit categoriesFor: #isPassword!public!testing! !
!UI.TextEdit categoriesFor: #isPassword:!accessing!public! !
!UI.TextEdit categoriesFor: #isReadOnly!public!testing! !
!UI.TextEdit categoriesFor: #isReadOnly:!accessing-styles!public! !
!UI.TextEdit categoriesFor: #isSelectionKept!public!testing! !
!UI.TextEdit categoriesFor: #isSelectionKept:!accessing!public! !
!UI.TextEdit categoriesFor: #isStatic!public!testing! !
!UI.TextEdit categoriesFor: #isStatic:!accessing!public! !
!UI.TextEdit categoriesFor: #isTextModified!private!testing! !
!UI.TextEdit categoriesFor: #isTextModified:!modes!private! !
!UI.TextEdit categoriesFor: #isUpdatePerChar!public!testing! !
!UI.TextEdit categoriesFor: #isUpdatePerChar:!accessing!public! !
!UI.TextEdit categoriesFor: #lineCount!accessing!public! !
!UI.TextEdit categoriesFor: #lineFromPosition:!accessing!public! !
!UI.TextEdit categoriesFor: #lineLengthFromPosition:!accessing!private! !
!UI.TextEdit categoriesFor: #lineRange:!accessing!public! !
!UI.TextEdit categoriesFor: #lineScroll!public!scrolling! !
!UI.TextEdit categoriesFor: #lineScroll:!public!scrolling! !
!UI.TextEdit categoriesFor: #lineScrollBy:!public!scrolling! !
!UI.TextEdit categoriesFor: #marginWidths!constants!private! !
!UI.TextEdit categoriesFor: #maxTextLimit!constants!private! !
!UI.TextEdit categoriesFor: #onFind:!event handling!public! !
!UI.TextEdit categoriesFor: #onFind:wParam:lParam:!dispatching!private! !
!UI.TextEdit categoriesFor: #onInputMaskRequired:!event handling!private! !
!UI.TextEdit categoriesFor: #onKeyTyped:!event handling!public! !
!UI.TextEdit categoriesFor: #onTextChanged!event handling-win32!private! !
!UI.TextEdit categoriesFor: #onTextOverflow!event handling!private! !
!UI.TextEdit categoriesFor: #onTipTextRequired:!event handling!public! !
!UI.TextEdit categoriesFor: #onViewCreated!event handling!operations!public! !
!UI.TextEdit categoriesFor: #passwordCharacter!accessing!public! !
!UI.TextEdit categoriesFor: #passwordCharacter:!accessing!public! !
!UI.TextEdit categoriesFor: #pasteClipboard!clipboard operations!commands!public! !
!UI.TextEdit categoriesFor: #pastePlainText!clipboard operations!commands!public! !
!UI.TextEdit categoriesFor: #plainTextAtLine:!public! !
!UI.TextEdit categoriesFor: #positionAtLine:!accessing!public! !
!UI.TextEdit categoriesFor: #positionForKeyboardContextMenu!enquiries!public! !
!UI.TextEdit categoriesFor: #positionOfChar:!accessing!public! !
!UI.TextEdit categoriesFor: #preTranslateKeyboardInput:!dispatching!public! !
!UI.TextEdit categoriesFor: #queryCommand:!commands!private! !
!UI.TextEdit categoriesFor: #redo!operations!public!undo & redo! !
!UI.TextEdit categoriesFor: #refreshContents!operations!public! !
!UI.TextEdit categoriesFor: #replace:!private!searching & replacing! !
!UI.TextEdit categoriesFor: #replaceAll:!event handling!public! !
!UI.TextEdit categoriesFor: #replaceSelection:!public!selection! !
!UI.TextEdit categoriesFor: #scrollDown!commands!public! !
!UI.TextEdit categoriesFor: #scrollToEnd!public!scrolling! !
!UI.TextEdit categoriesFor: #scrollUp!commands!public! !
!UI.TextEdit categoriesFor: #selectAll!commands!public!selection! !
!UI.TextEdit categoriesFor: #selectAllIfSingleLine!commands!public!selection! !
!UI.TextEdit categoriesFor: #selection!public!selection! !
!UI.TextEdit categoriesFor: #selectionPlainText:!private!selection! !
!UI.TextEdit categoriesFor: #selectionRange!public!selection! !
!UI.TextEdit categoriesFor: #selectionRange:!public!selection! !
!UI.TextEdit categoriesFor: #selectionStart:end:!public!selection! !
!UI.TextEdit categoriesFor: #selectionStart:length:!public!selection! !
!UI.TextEdit categoriesFor: #selectLine:!public!selection! !
!UI.TextEdit categoriesFor: #setAlignment:!modes!private! !
!UI.TextEdit categoriesFor: #setMarginWidths:!accessing!private!wine fix! !
!UI.TextEdit categoriesFor: #setReadOnly:!modes!private! !
!UI.TextEdit categoriesFor: #state!accessing!private! !
!UI.TextEdit categoriesFor: #suggestedFindText!helpers!private! !
!UI.TextEdit categoriesFor: #tabFocus!private!tabbing! !
!UI.TextEdit categoriesFor: #textLimit!accessing!public! !
!UI.TextEdit categoriesFor: #textLimit:!accessing!public! !
!UI.TextEdit categoriesFor: #textRange!accessing!public! !
!UI.TextEdit categoriesFor: #undo!operations!public! !
!UI.TextEdit categoriesFor: #updateModel!private!updating! !
!UI.TextEdit categoriesFor: #updatePerChar!public!testing! !
!UI.TextEdit categoriesFor: #updatePerChar:!accessing!public! !
!UI.TextEdit categoriesFor: #value!accessing!public! !
!UI.TextEdit categoriesFor: #value:!accessing!public! !
!UI.TextEdit categoriesFor: #wantReturn!public!testing! !
!UI.TextEdit categoriesFor: #wantReturn:!accessing!public! !
!UI.TextEdit categoriesFor: #wantTab!public!testing! !
!UI.TextEdit categoriesFor: #wantTab:!accessing!public! !
!UI.TextEdit categoriesFor: #wmKeyDown:wParam:lParam:!event handling-win32!operations!private! !
!UI.TextEdit categoriesFor: #wmKillFocus:wParam:lParam:!event handling-win32!private! !
!UI.TextEdit categoriesFor: #wmNcHitTest:wParam:lParam:!event handling-win32!private! !
!UI.TextEdit categoriesFor: #wmSetFocus:wParam:lParam:!event handling-win32!private! !

UI.TextEdit methodProtocol: #textFinder attributes: #(#readOnly) selectors: #(#onFind:)!

!UI.TextEdit class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialise the receiver's class variables:

			TextEdit initialize
	"

	self addClassConstant: 'AlignmentMap'
		value: (IdentityDictionary new
				at: #left put: ES_LEFT;
				at: #right put: ES_RIGHT;
				at: #center put: ES_CENTER;
				shrink;
				isImmutable: true;
				yourself).
	self addClassConstant: 'FormatMap'
		value: (IdentityDictionary new
				at: #mixed put: 0;
				at: #uppercase put: ES_UPPERCASE;
				at: #lowercase put: ES_LOWERCASE;
				at: #numeric put: ES_NUMBER;
				shrink;
				isImmutable: true;
				yourself)!

onStartup
	"Lookup the value of the FindDialog message.
	(This can change from one session to another.)"

	FindDialogMessage := self registerMessage: 'commdlg_FindReplace'
!

themePartName
	^'EDIT'
!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'EDIT'
! !
!UI.TextEdit class categoriesFor: #icon!constants!public! !
!UI.TextEdit class categoriesFor: #initialize!development!initializing!private! !
!UI.TextEdit class categoriesFor: #onStartup!event handling!public! !
!UI.TextEdit class categoriesFor: #themePartName!constants!private!theming! !
!UI.TextEdit class categoriesFor: #winClassName!constants!private! !

