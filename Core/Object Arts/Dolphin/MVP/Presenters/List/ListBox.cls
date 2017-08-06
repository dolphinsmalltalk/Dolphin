"Filed out from Dolphin Smalltalk 7"!

BasicListAbstract subclass: #ListBox
	instanceVariableNames: '_reserved'
	classVariableNames: 'LbnMap SelectionModeMask SelectionModes'
	poolDictionaries: 'ListBoxConstants'
	classInstanceVariableNames: ''!
ListBox guid: (GUID fromString: '{87b4c72c-026e-11d3-9fd7-00a0cc3e4a32}')!
ListBox comment: 'ListBox is the <listView> implementing the standard Windows LISTBOX control. It is for single selection use and, therefore, implements the <selectableItems> protocol  for use with any <listModel>.

Instance Variables:
	dummy	<UndefinedObject> reserved for future use.

Class Variables:
	LbnMap	<IdentityDictionary> mapping Windows notification messages to <selector>s.
'!
!ListBox categoriesForClass!MVP-Views! !
!ListBox methodsFor!

anchorIndex
	"Answer the 1-based <integer> index of the anchor (the item from which a multiple selection
	will start), or 0 if none."

	^(self sendMessage: LB_GETANCHORINDEX) + 1!

anchorIndex: anInteger
	"Private - Set the 1-based index of the anchor (the item from which a multiple selection will start)."

	self sendMessage: LB_SETANCHORINDEX wParam: anInteger - 1.!

basicAdd: anObject 
	"Private - Adds a string for the <Object> argument to the listbox control at the end of the
	list. Answers the argument."

	self 
		sendMessage: LB_ADDSTRING
		wParam: 0
		lpParam: (self displayStringFor: anObject).
	^anObject!

basicAdd: anObject atIndex: anInteger 
	"Private - Adds a string for the <Object> argument to the listbox control at the specified
	1-based <integer> index. If anInteger is zero then the string is added to the end of the
	list. Answer anObject."

	self 
		sendMessage: LB_INSERTSTRING
		wParam: anInteger - 1
		lpParam: (self displayStringFor: anObject).
	^anObject!

basicClear
	"Private - Clears down the listbox control(but not its model). 
	XB_RESETCONTENT does not return a value."

	self sendMessage: LB_RESETCONTENT!

basicItemFromPoint: aPoint 
	"Private - Answer the zero-based index of the object in the list under the <Point> argument,
	or -1 if none."

	"Implementation Note: As the receiver is a list, the 'handle' is an index, but be aware that
	it is in the native range of the control, and is therefore zero based. Note also that the
	answer may be greater than the zero based index of the last item in the list. It is the
	callers responsibilty to interpret appropriately - e.g. to accept drops past the last item
	in the list."

	| result |
	result := self 
				sendMessage: LB_ITEMFROMPOINT
				wParam: 0
				lParam: aPoint asUIntPtr.
	^result highWord = 0 ifTrue: [result lowWord] ifFalse: [-1]!

basicRemoveAtIndex: anInteger 
	"Private - Deletes a string from the listbox control at 1 based index, anInteger.
	Answers the number of strings remaining in the list, or -1 if anInteger is out of
	bounds."

	^self sendMessage: LB_DELETESTRING wParam: anInteger - 1!

basicResetSelection
	"Private - Set the receiver to have no selection."

	self isMultiSelect 
		ifTrue: 
			[self 
				sendMessage: LB_SETSEL
				wParam: 0
				lParam: -1]
		ifFalse: [super basicResetSelection]!

canHScroll
	"Answer true if the receiver is in horizontal scrolling mode"

	^self baseStyleAllMask: WS_HSCROLL!

canHScroll: aBoolean 
	"Sets the receiver into horizontal scrolling mode if aBoolean is true. 
	This is the WS_HSCROLL style"

	(self 
		baseStyleMask: WS_HSCROLL
		set: aBoolean
		recreateIfChanged: false) ifTrue: [self frameChanged]!

caretIndex
	"Answer the 1-based index of the caret (the item with focus in a multi-selection
	list box, or the selected item, if any, in a single-selection list box)."

	^(self sendMessage: LB_GETCARETINDEX) + 1!

caretIndex: anInteger
	"Set the caret (focus) to the specified item number."

	^self sendMessage: LB_SETCARETINDEX wParam: anInteger -1 lParam: false asParameter!

clearSelectionsByIndex: collection 
	"Removes selection from the items in the receiver with the Integer
	indices in collection"

	self selectIndices: collection set: false.

	"Windows only sends the change notification
	when the selection is the result of a user action so
	force it here"
	self onSelChanged!

command: anInteger id: id
	"Private - Handler for a redirected WM_COMMAND notification message."

	^(LbnMap lookup: anInteger) ifNotNil: [:selector | self perform: selector]!

defaultWindowStyle
	"Private - Answer the default basic window creation style for a list box"

	^super defaultWindowStyle bitOr: ##(LBS_NOTIFY | LBS_NOINTEGRALHEIGHT)!

dragLeave: session 
	"The drag operation described by the <DragDropSession> session has moved 
	to a new position outside the receiver's window. Remove any drop highlighting
	etc."

	session hideCursorWhile: [self hideDropHighlight]!

dragOver: session 
	"The drag operation described by the <DragDropSession>. session,
	has moved to a new position over the receiver's window.
	Implementation Note: Override in order to provide drop target highlighting
	and to suggest a reasonable drop target for most cases (the item under the
	cursor)."

	| item |
	item := self itemFromPoint: (session dragPointInView: self).
	session suggestedTarget: (item isNil ifFalse: [self objectFromHandle: item]).
	super dragOver: session.
	item = self dropHighlight ifTrue: [^self].
	session hideCursorWhile: 
			[self hideDropHighlight.
			item isNil ifFalse: [self showDropHighlight: item]]!

drop: session 
	"The drag operation described by the <DragDropSession>, session, has 
	culminated in a drop over the receiver. Answer whether the drop was successfull
	so that the Session knows whether to cut the item from the 	drag source in the case 
	of a #move operation.
	Implementation Note: We must remove the drop highlight."

	session hideCursorWhile: [self hideDropHighlight].
	^super drop: session!

dropHighlight
	"Private - Answers the current drop highlight for within the receiver or
	nil if there is none."

	^self propertyAt: #dropHighlight ifAbsent: [].!

ensureSelectionVisible
	"Ensure the selected item is visible, scrolling it into view if necessary."

	self isMultiSelect
		ifTrue: 
			[| caret selected |
			caret := self caretIndex.
			selected := self getMultipleSelections.
			self caretIndex: ((selected isEmpty or: [selected includes: caret])
						ifTrue: [caret]
						ifFalse: [selected first])]
		ifFalse: [super ensureSelectionVisible]!

getMultipleSelections
	"Private - Answer an <Array> of the one based <integer> indices of the selected items in 
	the receiver, in ascending order. This will fail if the ListBox is not in multi-select mode."

	| count buffer |
	count := self getSelCount.
	count <= 0 ifTrue: [^#()].
	buffer := DWORDArray new: count.
	(self 
		sendMessage: LB_GETSELITEMS
		wParam: count
		lpParam: buffer asParameter) = LB_ERR 
		ifTrue: [self errorNotMultiSelect].
	^buffer collect: [:each | each + 1]!

getSelCount
	| count |
	count := self sendMessage: LB_GETSELCOUNT.
	^count == LB_ERR ifTrue: [self getSingleSelection == 0 ifTrue: [0] ifFalse: [1]] ifFalse: [count]!

getSingleSelection
	"Private - Answer the one-based <integer> 'index' of the selected object in the receiver or
	zero if there is none."

	"Implementation Note: Unfortunately some versions of Windows appear to return a phantom
	selection for empty list so we have to catch this explicitly."

	^self itemCount > 0 ifTrue: [(self sendMessage: LB_GETCURSEL) + 1] ifFalse: [0]!

hasPermanentScrollbars
	"Answer true if the receiver is set to always display its scrollbars regardless of whether 
	they are necessary. This is the LBS_DISABLENOSCROLL style"

	^self baseStyleAllMask: LBS_DISABLENOSCROLL
!

hasPermanentScrollbars: aBoolean 
	"Sets the receiver to always display its scrollbars regardless of whether they are necessary.
	This is the LBS_DISABLENOSCROLL style.
	Incidentally, this is the only way to display a horizontal scroll bar"

	self 
		baseStyleMask: LBS_DISABLENOSCROLL
		set: aBoolean
		recreateIfChanged: true	"Must recreate in order for this change to take effect"!

hasToggleSelection
	"Answer whether the receiver has the LBS_MULTIPLESEL style set.
	If this style is set then the selection of items is toggled by clicking over them
	with the mouse."

	^self baseStyleAllMask: LBS_MULTIPLESEL!

hasToggleSelection: aBoolean
	"Sets/resets the selection toggling style of the receiver.
	If the toggle style is set then the selection of items is toggled by clicking over them
	with the mouse, otherwise the keyboard must be used in conjunction with Ctrl & Shift keys
	to make multiple selections. Which is more convenient depends on the number of items in 
	the list, etc."

	self baseStyle: (aBoolean ifTrue: [LBS_MULTIPLESEL] ifFalse: [LBS_EXTENDEDSEL])
		maskedBy: ##(LBS_MULTIPLESEL | LBS_EXTENDEDSEL)!

hideDropHighlight
	"Private - Hides any drop highlight within the receiver."

	| item |
	item := self dropHighlight.
	item notNil 
		ifTrue: 
			[| canvas |
			canvas := self canvas.
			canvas invertRectangle: (self itemRect: item).
			canvas free].
	self removePropertyAt: #dropHighlight ifAbsent: []!

horizontalExtent
	"Answers the effective width of the receiver when horizontal scrolling is enabled"

	^self sendMessage: LB_GETHORIZONTALEXTENT!

horizontalExtent: anInteger
	"Sets the effective width of the receiver when horizontal scrolling is enabled to anInteger."

	self sendMessage: LB_SETHORIZONTALEXTENT wParam: anInteger asParameter!

initStorageFor: anInteger
	"Private - Ask the listbox to preallocate space for anInteger number of entries, using a default size."

	anInteger > 100 ifTrue: [ 
		^self sendMessage: LB_INITSTORAGE wParam: anInteger lParam: 10*anInteger ]!

isDragSource: aBoolean
	"Set or reset the receiver's isDragSource flag. 
	When true, the receiver can take part in a drag and drop operation as a drag source."

	super isDragSource: aBoolean.
	self exStyleMask: WS_EX_NOTIFYDRAG set: aBoolean.
!

isMultiSelect
	"Answer whether the receiver is in one of the multi-selection modes."

	^self baseStyle anyMask: SelectionModeMask!

isMultiSelect: aBoolean 
	"Set whether the receive is in multi-select or single selection modes depending on the value
	of the <boolean> argument."

	self selectionMode: (aBoolean ifTrue: [#multi] ifFalse: [#single])!

itemCount
	"Answers the count of elements in the receiver. This may be 
	different from the answer to #size if the model has been updated but
	the change has not yet propaged to the receiver's contents"

	^self sendMessage: LB_GETCOUNT!

itemFromPoint: aPoint 
	"Private - Answer the index of the object in the list under the <Point> argument, or nil if
	none. Note that the answer may be greater than the one-based index of the last item in the
	list. It is the callers responsibilty to interpret appropriately - e.g. to accept drops past
	the last item in the list."

	| index |
	index := self basicItemFromPoint: aPoint.
	^index < 0 ifFalse: [index + 1]!

itemRect: anIntegerIndex
	"Answers the rectangle surrounding the item with anIntegerIndex within
	the receiver"

	| rect |
	rect := RECT new.
	self sendMessage: LB_GETITEMRECT wParam: anIntegerIndex-1 lpParam: rect asParameter.
	^rect asRectangle!

lbnBeginDrag: itemIndex
	"Private - Default handler for a WM_BEGINDRAG notification message redirected from
	the receiver's parent when the WS_EX_NOTIFYDRAG style is present."

	self onBegin: #left drag: (self model at: itemIndex+1).
	^nil!

lbnDblClk
	"Private - A LBN_DBLCLK has been received by our parent window."

	^nil.
!

lbnErrSpace
	"Private - A LBN_ERRSPACE has been received by our parent window. 
	Signal an OutOfMemoryError"

	^self errorOutOfMemory.
!

lbnSelCancel
	"Private - A LBN_SELCANCEL has been received by our parent window."

	self onSelChanging.
	^nil!

lbnSelChange
	"Private - A LBN_SELCHANGE has been received by our parent window."

	self onSelChanging.
	^nil!

positionForKeyboardContextMenu
	"Answer the desired position for a context menu requested from the keyboard.
	This should be based on the 'current selection', whatever that means in the context of the
	receiver. Should be overridden by subclasses as appropriate."

	| caret |
	caret := self caretIndex.
	^caret == 0
		ifTrue: [super positionForKeyboardContextMenu]
		ifFalse: [self mapPoint: (self itemRect: caret) bottomLeft to: self class desktop]
!

primarySelectionIndex
	"Answer the index of the selected item with focus, or zero if there is no selection."

	| caret selected |
	selected := self selectionsByIndex.
	^selected isEmpty
		ifTrue: [0]
		ifFalse: 
			[caret := self caretIndex.
			(selected includes: caret) ifTrue: [caret] ifFalse: [selected first]]!

selectAll
	| size |
	size := self size.
	self selectedCount ~= size ifTrue: [self selectionsByIndex: (1 to: size)]!

selectedCount
	"Answer the total number of items selected in the receiver."

	"Implementation Note: If switching between single and multi-select modes, then the
	internally held style may be out of sync. with the actual list box during the recreation
	process. Thus we have to make this work for a list box which claims to be multiple
	selection, but which is in fact single selection."

	^self isMultiSelect ifTrue: [self getSelCount] ifFalse: [super selectedCount]!

selectIndex: anInteger set: aBoolean 
	"Private - Set/reset the selection state of the object at the specified one-based <integer>
	index within the receiver according to the <boolean> argument."

	(self 
		sendMessage: LB_SETSEL
		wParam: aBoolean asParameter
		lParam: anInteger - 1) == LB_ERR 
		ifTrue: 
			[self isMultiSelect 
				ifTrue: 
					["Assume its a bounds error"
					self errorSubscriptBounds: anInteger]
				ifFalse: [self errorNotMultiSelect]]!

selectionFromPoint: pos 
	"Private - Answer the selection that would occur if a mouse click at the
	<Point>, pos, was passed to the control."

	| item |
	item := self itemFromPoint: pos.
	^self isMultiSelect ifTrue: [item isNil ifTrue: [#()] ifFalse: [Array with: item]] ifFalse: [item]!

selectionMode
	^SelectionModes keyAtValue: (self baseStyle bitAnd: SelectionModeMask)!

selectionMode: aSymbol 
	"Sets the selection style of the receiver to one of #single (single selection), #multi
	(muti-selection) or #toggle (toggleable multi-selection). If the toggle style is set then
	the selection of items is toggled by clicking over them with the mouse, otherwise the
	keyboard must be used in conjunction with Ctrl & Shift keys to make multiple selections.
	Which is more convenient depends on the number of items in the list, etc."

	| mode |
	mode := self selectionMode.
	mode == aSymbol ifTrue: [^self].
	self baseStyle: (SelectionModes at: aSymbol) maskedBy: SelectionModeMask.
	(mode == #single eqv: aSymbol == #single) ifFalse: [self onSelChanged: self selectionsByIndex]!

setSingleSelection: anInteger 
	"Private - Set the selection to the item with the specified index (1-based), scrolling it
	into view if necessary."

	^(self sendMessage: LB_SETCURSEL wParam: anInteger - 1) ~= LB_ERR!

showDropHighlight: anItem
	"Private - Shows a drop highlight for anItem within the receiver."

	| canvas |

	canvas := self canvas.
	canvas invertRectangle: (self itemRect: anItem).
	canvas free.

	self propertyAt: #dropHighlight put: anItem.
!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state. Add the horizonatl extent aspect since it is not otherwise cached in an
	instance variable"

	^super state
		add: (MessageSend receiver: self selector: #horizontalExtent: argument: self horizontalExtent);
		yourself
!

wmRButtonDown: message wParam: wParam lParam: lParam 
	"Handle a WM_RBUTTONDOWN. We select the item under the mouse before
	passing control on."

	| sel |
	sel := self selectionFromPoint: lParam lowPartSigned @ lParam highPartSigned.
	sel notNil ifTrue: [self selectionByIndex: sel].
	^super 
		wmRButtonDown: message
		wParam: wParam
		lParam: lParam! !
!ListBox categoriesFor: #anchorIndex!public!selection! !
!ListBox categoriesFor: #anchorIndex:!public!selection! !
!ListBox categoriesFor: #basicAdd:!adding!private! !
!ListBox categoriesFor: #basicAdd:atIndex:!adding!private! !
!ListBox categoriesFor: #basicClear!private!removing! !
!ListBox categoriesFor: #basicItemFromPoint:!enquiries!private! !
!ListBox categoriesFor: #basicRemoveAtIndex:!private!removing! !
!ListBox categoriesFor: #basicResetSelection!private!selection! !
!ListBox categoriesFor: #canHScroll!public!testing! !
!ListBox categoriesFor: #canHScroll:!accessing-styles!public! !
!ListBox categoriesFor: #caretIndex!public!selection! !
!ListBox categoriesFor: #caretIndex:!public!selection! !
!ListBox categoriesFor: #clearSelectionsByIndex:!public!selection! !
!ListBox categoriesFor: #command:id:!commands!private! !
!ListBox categoriesFor: #defaultWindowStyle!constants!private! !
!ListBox categoriesFor: #dragLeave:!event handling!public! !
!ListBox categoriesFor: #dragOver:!event handling!public! !
!ListBox categoriesFor: #drop:!event handling!public! !
!ListBox categoriesFor: #dropHighlight!drag & drop!private! !
!ListBox categoriesFor: #ensureSelectionVisible!public!selection! !
!ListBox categoriesFor: #getMultipleSelections!private!selection! !
!ListBox categoriesFor: #getSelCount!public!selection! !
!ListBox categoriesFor: #getSingleSelection!helpers!private!selection! !
!ListBox categoriesFor: #hasPermanentScrollbars!public!testing! !
!ListBox categoriesFor: #hasPermanentScrollbars:!accessing-styles!public! !
!ListBox categoriesFor: #hasToggleSelection!accessing-styles!public! !
!ListBox categoriesFor: #hasToggleSelection:!accessing-styles!public! !
!ListBox categoriesFor: #hideDropHighlight!drag & drop!private! !
!ListBox categoriesFor: #horizontalExtent!accessing!public! !
!ListBox categoriesFor: #horizontalExtent:!accessing!public! !
!ListBox categoriesFor: #initStorageFor:!helpers!private! !
!ListBox categoriesFor: #isDragSource:!accessing!public! !
!ListBox categoriesFor: #isMultiSelect!public!selection!testing! !
!ListBox categoriesFor: #isMultiSelect:!public!testing! !
!ListBox categoriesFor: #itemCount!accessing!public! !
!ListBox categoriesFor: #itemFromPoint:!enquiries!private! !
!ListBox categoriesFor: #itemRect:!accessing!public! !
!ListBox categoriesFor: #lbnBeginDrag:!event handling-win32!private! !
!ListBox categoriesFor: #lbnDblClk!event handling-win32!private! !
!ListBox categoriesFor: #lbnErrSpace!event handling-win32!private! !
!ListBox categoriesFor: #lbnSelCancel!event handling-win32!private!selection! !
!ListBox categoriesFor: #lbnSelChange!event handling-win32!private!selection! !
!ListBox categoriesFor: #positionForKeyboardContextMenu!enquiries!public! !
!ListBox categoriesFor: #primarySelectionIndex!public!selection! !
!ListBox categoriesFor: #selectAll!public!selection! !
!ListBox categoriesFor: #selectedCount!public!selection! !
!ListBox categoriesFor: #selectIndex:set:!private!selection! !
!ListBox categoriesFor: #selectionFromPoint:!event handling!private! !
!ListBox categoriesFor: #selectionMode!accessing-styles!public! !
!ListBox categoriesFor: #selectionMode:!accessing-styles!public! !
!ListBox categoriesFor: #setSingleSelection:!private!selection! !
!ListBox categoriesFor: #showDropHighlight:!drag & drop!private! !
!ListBox categoriesFor: #state!accessing!private! !
!ListBox categoriesFor: #wmRButtonDown:wParam:lParam:!event handling-win32!public! !

ListBox methodProtocol: #multipleIndexSelectableItems attributes: #(#readOnly) selectors: #(#addSelectionsByIndex: #clearSelectionsByIndex: #selectionsByIndex #selectionsByIndex: #selectionsByIndex:ifAbsent:)!
ListBox methodProtocol: #multipleSelectableItems attributes: #(#readOnly) selectors: #(#addSelections: #addSelections:ifAbsent: #hasSelection #selectAll #selections #selections: #selections:ifAbsent:)!

!ListBox class methodsFor!

initialize
	"Private - Initialise the receiver's class variables:
		LbnMap - a map of interesting ListBox-specific command notification codes to selectors."

	LbnMap := (IdentityDictionary new: 4)
				at: -2 put: #lbnErrSpace;
				at: 1 put: #lbnSelChange;
				at: 2 put: #lbnDblClk;
				at: 3 put: #lbnSelCancel;
				yourself.
	self registerMessages: (Array with: WM_BEGINDRAG -> #wmBeginDrag:wParam:lParam:).
	SelectionModes := (IdentityDictionary new)
				at: #single put: 0;
				at: #multi put: LBS_EXTENDEDSEL;
				at: #toggle put: LBS_MULTIPLESEL;
				shrink;
				yourself.
	SelectionModeMask := SelectionModes inject: 0 into: [:sum :each | sum + each]!

selectionModes
	^SelectionModes!

uninitialize
	self unregisterMessages: (Array with: WM_BEGINDRAG)!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'LISTBOX'
! !
!ListBox class categoriesFor: #initialize!initializing!private! !
!ListBox class categoriesFor: #selectionModes!constants!public! !
!ListBox class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!ListBox class categoriesFor: #winClassName!constants!private! !

