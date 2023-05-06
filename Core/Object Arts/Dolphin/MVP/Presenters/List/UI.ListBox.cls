"Filed out from Dolphin Smalltalk"!

UI.BasicListAbstract
	subclass: #'UI.ListBox'
	instanceVariableNames: 'approvedSelIndices'
	classVariableNames: ''
	imports: #(#{OS.ListBoxConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'SelectionModeMask' -> 16r808.
			'SelectionModes'
				-> (IdentityDictionary withAll: { #multi -> 16r800. #single -> 16r0. #toggle -> 16r8 })
		}!
UI.ListBox guid: (Core.GUID fromString: '{87b4c72c-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ListBox comment: 'ListBox is the <listView> implementing the standard Windows LISTBOX control. It is for single selection use and, therefore, implements the <selectableItems> protocol  for use with any <listModel>.

Instance Variables:
	dummy	<UndefinedObject> reserved for future use.

Class Variables:
	LbnMap	<IdentityDictionary> mapping Windows notification messages to <selector>s.
'!
!UI.ListBox categoriesForClass!MVP-Views! !
!UI.ListBox methodsFor!

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
		szParam: (self displayStringFor: anObject).
	^anObject!

basicAdd: anObject atIndex: anInteger
	"Private - Adds a string for the <Object> argument to the listbox control at the specified
	1-based <integer> index. If anInteger is zero then the string is added to the end of the
	list. Answer anObject."

	self
		sendMessage: LB_INSERTSTRING
		wParam: anInteger - 1
		szParam: (self displayStringFor: anObject).
	^anObject!

basicClear
	"Private - Clears down the listbox control(but not its model). 
	LB_RESETCONTENT does not return a value."

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

	^(##(IdentityDictionary withAll: {LBN_ERRSPACE -> #errorOutOfMemory.
				LBN_SELCHANGE -> #lbnSelChange.
				LBN_DBLCLK -> #lbnDblClk.
				LBN_SELCANCEL -> #lbnSelCancel})
		lookup: anInteger) ifNotNil: [:selector | self perform: selector]!

defaultWindowStyle
	"Private - Answer the default basic window creation style for a list box"

	^super defaultWindowStyle bitOr: ##(LBS_NOTIFY | LBS_NOINTEGRALHEIGHT)!

dragLeave: session 
	"The drag operation described by the <DragDropSession> session has moved 
	to a new position outside the receiver's window. Remove any drop highlighting
	etc."

	session hideCursorWhile: [self hideDropHighlight]!

dragOver: session 
	"The drag operation described by the <DragDropSession>, session,
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
	culminated in a drop over the receiver. Answer whether the drop was successful
	so that the Session knows whether to cut the item from the drag source in the case 
	of a #move operation.
	Implementation Note: We must remove the drop highlight."

	session hideCursorWhile: [self hideDropHighlight].
	^super drop: session!

dropHighlight
	"Private - Answers the current drop highlight for within the receiver or
	nil if there is none."

	^self propertyAt: #dropHighlight ifAbsent: nil!

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
	count := self getSelectedCount.
	count <= 0 ifTrue: [^#()].
	buffer := UInt32Array new: count.
	(self
		sendMessage: LB_GETSELITEMS
		wParam: count
		lpParam: buffer asParameter) = LB_ERR
		ifTrue: [self errorNotMultiSelect].
	^buffer collect: [:each | each + 1]!

getSelectedCount
	| count |
	count := self sendMessage: LB_GETSELCOUNT.
	^count == LB_ERR ifTrue: [self getSingleSelection == 0 ifTrue: [0] ifFalse: [1]] ifFalse: [count]!

getSelectionsByIndex
	"Private - Query the current selections from the control."

	^self isMultiSelect
		ifTrue: [self getMultipleSelections]
		ifFalse: 
			[| index |
			index := self getSingleSelection.
			index == 0 ifTrue: [#()] ifFalse: [{index}]]!

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
	self removePropertyAt: #dropHighlight ifAbsent: nil!

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

isReadOnly
	"Answer whether the receiver's contents can be selected."

	^self baseStyleAllMask: LBS_NOSEL!

isReadOnly: aBoolean
	"Set whether the receiver's contents can be selected."

	self
		baseStyleMask: LBS_NOSEL
		set: aBoolean
		recreateIfChanged: true	"Must recreate in order for this change to take effect"!

itemCount
	"Answers the count of elements in the receiver. This may be 
	different from the answer to #size if the model has been updated but
	the change has not yet propagated to the receiver's contents"

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
	rect := RECTL newBuffer.
	self
		sendMessage: LB_GETITEMRECT
		wParam: anIntegerIndex - 1
		lpParam: rect asParameter.
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

lbnSelCancel
	"Private - A LBN_SELCANCEL has been received by our parent window."

	self maybeSelChanging: #mouse.
	^nil!

lbnSelChange
	"Private - A LBN_SELCHANGE has been received by our parent window."

	self maybeSelChanging: #mouse.
	^nil!

maybeSelChanging: aSymbol
	"Private - The selection may be changing as a result of a user action (e.g. due to a keypress). 
	The argument is either #mouse, or #keyboard, indicating the source of the user input that
	is initiating the selection change. Give the presenter/view a chance to change their mind."

	"See if the change is acceptable, and if not revert to original selection if there was one"

	| curSel |
	curSel := self getSelectionsByIndex.
	curSel = lastSelIndices ifTrue: [^self].
	(self onSelChanging: curSel cause: aSymbol)
		ifFalse: 
			[self
				postMessage: RevertSelMessage
				wParam: 0
				lParam: 0.
			^self].
	self onSelChanged: curSel!

newMultiSelectionsFromEvent: aMouseEvent

	| itemClicked modified anchorIndex shiftRange button |
	itemClicked := self itemFromPoint: aMouseEvent position.
	modified := aMouseEvent isModifierDown.
	button := aMouseEvent button.
	"We follow the ListView behavior for right button clicks as the control itself does not actually change selection on right click natively:
		- A right or middle click on an already-selected item should not change the selection
		- If there are any modifiers then the click has no effect on selection"
	(button ~~ #left and: [modified or: [lastSelIndices includes: itemClicked]])
		ifTrue: [^lastSelIndices].
	"Having taken care of the above edge cases, if no modifier keys are down, the behavior is equivalent to the single-select case."
	modified ifFalse: [^itemClicked ifNil: [lastSelIndices] ifNotNil: [{itemClicked}]].
	"The ListBox behaves differently to the ListView in that clicking out of bounds is as if clicking on the last item"
	itemClicked isNil ifTrue: [itemClicked := self itemCount].
	aMouseEvent isShiftDown
		ifFalse: 
			[| newSelections |
			"Only Ctrl is down, so we flip the selection state of the clicked item."
			newSelections := lastSelIndices asSortedCollection.
			newSelections remove: itemClicked ifAbsent: [newSelections add: itemClicked].
			^newSelections asArray].
	"At least Shift is down, so we must start examining the 'anchor'. This is the last item that was clicked with no modifiers, only ctrl, or ctrl + shift (shift-clicks do *not* move the anchor). It acts as the 'start point' for operations where shift is held--they affect the range of items from the anchor to the click point, inclusive. Initially it is zero, i.e. out-of-bounds, in which case holding shift essentially has no effect, and we act only on the item actually clicked."
	anchorIndex := self anchorIndex.
	shiftRange := anchorIndex == 0
				ifTrue: [itemClicked to: itemClicked]
				ifFalse: [(anchorIndex min: itemClicked) to: (anchorIndex max: itemClicked)].
	"If only shift is down, not ctrl, the current selection will be replaced by the marked range between the anchor and the selection, although inclusive of the anchor only if currently selected."
	^aMouseEvent isCtrlDown
		ifTrue: 
			["Both ctrl and shift are down, so we set the selection state of the affected range to that of the anchor itself. Note that this ignores the selection state of the item actually clicked and everything in between it and the anchor."
			((lastSelIndices includes: anchorIndex)
				ifTrue: [lastSelIndices union: shiftRange]
				ifFalse: [lastSelIndices difference: shiftRange]) asSortedCollection
				asArray]
		ifFalse: 
			[((lastSelIndices includes: anchorIndex) or: [anchorIndex == 0])
				ifTrue: [shiftRange asArray]
				ifFalse: [shiftRange copyWithout: anchorIndex]]!

newSelectionsFromEvent: aMouseEvent
	"Private - Answer a collection of the <integer> selections that would occur if the `MouseEvent` argument was passed to the list box control.
	The behaviour is quite complicated, and different from the similarly complicated behaviour of the later ListView control."

	| mode |
	mode := self selectionMode.
	mode == #single ifTrue: [^self newSingleSelectionsFromEvent: aMouseEvent].
	mode == #multi ifTrue: [^self newMultiSelectionsFromEvent: aMouseEvent].
	^self newToggleSelectionsFromEvent: aMouseEvent!

newSingleSelectionsFromEvent: aMouseEvent
	"Private - Answer a single element `Array` of <integer> being the selections that result if the `MouseEvent` argument was passed to a list box control in single-select mode.
	Single select mode is very simple:
		- clicking an item selects it
		- clicking outside any item has no effect on selection (although the caret moves)
		- modifier keys are irrelevant"

	| itemClicked |
	^(aMouseEvent isSelectionButtonDown
		and: [(itemClicked := self itemFromPoint: aMouseEvent position) notNil])
			ifTrue: [{itemClicked}]
			ifFalse: [lastSelIndices]!

newToggleSelectionsFromEvent: aMouseEvent
	"Private - Answer a single element `Array` of <integer> being the selections that result if the `MouseEvent` argument was passed to a list box control in toggle-select mode.
	Toggle select mode is relatively simple:
		- clicking an item toggles its previous selection state
		- clicking outside any item toggles the last selected item
		- modifier keys are ignored for left clicks, and cause right clicks to be ignored
		- right clicks can only add to the selection (not toggle off items).
	Note that the right click actions are not native behaviour of the control, but rather added here in Dolphin following the general principles of the way right clicks work in the ListView."

	| itemClicked newSelections |
	itemClicked := (self itemFromPoint: aMouseEvent position) ifNil: [self caretIndex].
	newSelections := lastSelIndices asSet.
	aMouseEvent button == #left
		ifTrue: [newSelections remove: itemClicked ifAbsent: [newSelections add: itemClicked]]
		ifFalse: [aMouseEvent isModifierDown ifFalse: [newSelections add: itemClicked]].
	^newSelections asSortedArray!

onLeftButtonPressed: aMouseEvent
	"Handle a left button down mouse event. We intercede here in order to detect selection change events, and, if the view/presenter don't want the selection changed, then the message is absorbed without passing it to the control. Otherwise accept the default window processing."

	| indices |
	self presenter trigger: #leftButtonPressed: with: aMouseEvent.
	indices := self newSelectionsFromEvent: aMouseEvent.
	^indices = lastSelIndices
		ifTrue: [aMouseEvent defaultWindowProcessing]
		ifFalse: 
			[(self onSelChanging: indices cause: #mouse)
				ifTrue: 
					["Selection change permitted"
					(Keyboard default isButtonDown: aMouseEvent button)
						ifFalse: 
							[self
								postMessage: aMouseEvent message + 1
								wParam: (aMouseEvent wParam maskClear: aMouseEvent buttonFlag)
								lParam: aMouseEvent lParam].
					aMouseEvent defaultWindowProcessing]
				ifFalse: 
					["Suppress the mouse down so not received by control"
					0]]!

onRightButtonPressed: aMouseEvent
	"Handle a left button down mouse event. We intercede here in order to implement selection changes on right clicks, which the control does not do natively."

	| indices |
	self presenter trigger: #rightButtonPressed: with: aMouseEvent.
	indices := self newSelectionsFromEvent: aMouseEvent.
	(indices ~= lastSelIndices and: [self onSelChanging: indices cause: #mouse])
		ifTrue: 
			["Selection change permitted"
			self selectionsByIndex: indices.
			self onSelChanged: indices].
	^aMouseEvent defaultWindowProcessing!

onSelChanged: anArray
	approvedSelIndices := nil.
	super onSelChanged: anArray!

onSelChanging: anArray cause: aSymbol
	"Private - Selection is changing in the receiver to the item in the receiver's model identified by the specified <Collection> of <integer> indices. Answer whether to allow the selection change to proceed.
	Note that #selectionChanging: events are only fired as a direct consequence of user initiated actions, not in response to selection changes that occur as direct or indirect results of programmatic actions."

	^self isStateRestoring or: 
			[anArray = approvedSelIndices or: 
					[| event |
					event := SelectionChangingEvent forSource: self.
					event
						newSelections: (anArray collect: [:each | self objectFromHandle: each]);
						oldSelections: (lastSelIndices collect: [:each | self objectFromHandle: each]);
						cause: aSymbol.
					self presenter onSelectionChanging: event.
					event value ifTrue: [approvedSelIndices := anArray].
					event value]]!

positionForKeyboardContextMenu
	"Answer the desired position for a context menu requested from the keyboard.
	This should be based on the 'current selection', whatever that means in the context of the
	receiver. Should be overridden by subclasses as appropriate."

	| caret |
	caret := self caretIndex.
	^caret == 0
		ifTrue: [super positionForKeyboardContextMenu]
		ifFalse: [self mapPointToScreen: (self itemRect: caret) bottomLeft]!

selectAll
	| count |
	count := self itemCount.
	self selectedCount ~= count ifTrue: [self selectionsByIndex: (1 to: count)]!

selectedCount
	"Answer the total number of items selected in the receiver."

	"Implementation Note: If switching between single and multi-select modes, then the
	internally held style may be out of sync. with the actual list box during the recreation
	process. Thus we have to make this work for a list box which claims to be multiple
	selection, but which is in fact single selection."

	^self isMultiSelect ifTrue: [self getSelectedCount] ifFalse: [super selectedCount]!

selectIndex: anInteger set: aBoolean
	"Private - Set/reset the selection state of the object at the specified one-based <integer> index within the receiver according to the <boolean> argument."

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
	(mode == #single eqv: aSymbol == #single) ifFalse: [self onSelChanged: self getSelectionsByIndex]!

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
	to its current state. Add the horizontal extent aspect since it is not otherwise cached in an
	instance variable"

	^super state
		add: (MessageSend
					receiver: self
					selector: #horizontalExtent:
					argument: self horizontalExtent);
		yourself! !
!UI.ListBox categoriesForMethods!
anchorIndex!public!selection! !
anchorIndex:!public!selection! !
basicAdd:!adding!private! !
basicAdd:atIndex:!adding!private! !
basicClear!private!removing! !
basicItemFromPoint:!enquiries!private! !
basicRemoveAtIndex:!private!removing! !
basicResetSelection!private!selection! !
canHScroll!accessing-styles!public!testing! !
canHScroll:!accessing-styles!public! !
caretIndex!public!selection! !
caretIndex:!public!selection! !
clearSelectionsByIndex:!public!selection! !
command:id:!commands!private! !
defaultWindowStyle!constants!private! !
dragLeave:!event handling!public! !
dragOver:!event handling!public! !
drop:!event handling!public! !
dropHighlight!drag & drop!private! !
ensureSelectionVisible!public!selection! !
getMultipleSelections!private!selection! !
getSelectedCount!private!selection! !
getSelectionsByIndex!private!selection! !
getSingleSelection!helpers!private!selection! !
hasPermanentScrollbars!accessing-styles!public!testing! !
hasPermanentScrollbars:!accessing-styles!public! !
hasToggleSelection!accessing-styles!public!testing! !
hasToggleSelection:!accessing-styles!public! !
hideDropHighlight!drag & drop!private! !
horizontalExtent!accessing!public! !
horizontalExtent:!accessing!public! !
initStorageFor:!helpers!private! !
isDragSource:!accessing!public! !
isMultiSelect!accessing-styles!public!selection!testing! !
isMultiSelect:!accessing-styles!public! !
isReadOnly!accessing-styles!public!testing! !
isReadOnly:!accessing-styles!public! !
itemCount!accessing!public! !
itemFromPoint:!enquiries!private! !
itemRect:!accessing!public! !
lbnBeginDrag:!event handling-win32!private! !
lbnDblClk!event handling-win32!private! !
lbnSelCancel!event handling-win32!private!selection! !
lbnSelChange!event handling-win32!private!selection! !
maybeSelChanging:!event handling!private! !
newMultiSelectionsFromEvent:!private!selection! !
newSelectionsFromEvent:!event handling!private! !
newSingleSelectionsFromEvent:!event handling!private! !
newToggleSelectionsFromEvent:!event handling!private! !
onLeftButtonPressed:!public! !
onRightButtonPressed:!event handling!public! !
onSelChanged:!event handling!private! !
onSelChanging:cause:!event handling!private! !
positionForKeyboardContextMenu!enquiries!public! !
selectAll!public!selection! !
selectedCount!public!selection! !
selectIndex:set:!private!selection! !
selectionMode!accessing-styles!public! !
selectionMode:!accessing-styles!public! !
setSingleSelection:!private!selection! !
showDropHighlight:!drag & drop!private! !
state!accessing!private! !
!

UI.ListBox methodProtocol: #multipleIndexSelectableItems attributes: #(#readOnly) selectors: #(#addSelectionsByIndex: #clearSelectionsByIndex: #selectionsByIndex #selectionsByIndex: #selectionsByIndex:ifAbsent:)!
UI.ListBox methodProtocol: #multipleSelectableItems attributes: #(#readOnly) selectors: #(#addSelections: #addSelections:ifAbsent: #hasSelection #selectAll #selections #selections: #selections:ifAbsent:)!

!UI.ListBox class methodsFor!

initialize
	"Private - Initialise the receiver's class variables:
		LbnMap - a map of interesting ListBox-specific command notification codes to selectors."

	self registerMessageMappings: self listboxMessageMappings.
	self addClassConstant: 'SelectionModes'
		value: (IdentityDictionary new
				at: #single put: 0;
				at: #multi put: LBS_EXTENDEDSEL;
				at: #toggle put: LBS_MULTIPLESEL;
				shrink;
				beReadOnlyObject;
				yourself).
	self addClassConstant: 'SelectionModeMask'
		value: (SelectionModes inject: 0 into: [:sum :each | sum + each])!

listboxMessageMappings
	^{WM_BEGINDRAG -> #wmBeginDrag:wParam:lParam:}!

selectionModes
	^SelectionModes!

themePartName
	^#ListBox!

uninitialize
	self unregisterMessageMappings: {WM_BEGINDRAG}!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'LISTBOX'
! !
!UI.ListBox class categoriesForMethods!
initialize!development!initializing!private! !
listboxMessageMappings!constants!must not strip!private! !
selectionModes!constants!public! !
themePartName!constants!private! !
uninitialize!class hierarchy-removing!private! !
winClassName!constants!private! !
!

