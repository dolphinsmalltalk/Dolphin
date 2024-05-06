"Filed out from Dolphin Smalltalk"!

BasicListAbstract subclass: #ComboBox
	instanceVariableNames: 'droppedHeight'
	classVariableNames: 'Modes'
	poolDictionaries: 'ComboBoxConstants'
	classInstanceVariableNames: ''!

ComboBox guid: (GUID fromString: '{87b4c72b-026e-11d3-9fd7-00a0cc3e4a32}')!

ComboBox addClassConstant: 'Modes' value: #(#simple #dropDown #dropDownList)!

ComboBox comment: 'ComboBox is the <listView> implementing the standard Windows COMBOBOX control. It is for single selection use and, therefore, implements the <selectableItems> protocol for use with any <listModel>.

Instance Variables:
	droppedHeight	<integer> pixel height of dropdown.

Class Variables:
	CbnMap	<IdentityDictionary> mapping Windows notification messages to <selector>s.
	Modes		<Array> of <Symbol>s decribing the COMBOBOX styles.
'!

!ComboBox categoriesForClass!MVP-Views! !

!ComboBox methodsFor!

actualHeight
	"Private - Answer the actual height of the receiver when dropped down
	(not applicable to simple mode). This includes the fixed height edit field
	and the (configurable) maximum dropped height."

	^self height + self droppedHeight!

adjustRectangle: aRectangle 
	"Update the <Rectangle> argument, which is a proposed new position and extent for the
	receiver, to account for any of the receiver's foibles."

	"Implementation Note: Override because the height of a combo-box cannot be
	changed (unless in simple mode) - it is fixed as the height of the edit box plus the 
	droppedHeight."

	^self mode == #simple 
		ifTrue: [aRectangle]
		ifFalse: 
			[(aRectangle copy)
				height: self actualHeight;
				yourself]!

basicAdd: anObject
	"Private - Adds a string for the <Object> argument to the listbox control at the end of the
	list. Answers the argument."

	self
		sendMessage: CB_ADDSTRING
		wParam: 0
		szParam: (self displayStringFor: anObject).
	^anObject!

basicAdd: anObject atIndex: anInteger
	"Private - Adds a string for the <Object> argument to the listbox control at the specified
	1-based <integer> index. If anInteger is zero then the string is added to the end of the
	list. Answer anObject."

	self
		sendMessage: CB_INSERTSTRING
		wParam: anInteger - 1
		szParam: (self displayStringFor: anObject).
	^anObject!

basicClear
	"Private - Clears down the listbox control(but not its model). 
	XB_RESETCONTENT does not return a value."

	self sendMessage: CB_RESETCONTENT!

basicRemoveAtIndex: anInteger 
	"Private - Deletes a string from the listbox control at 1 based index, anInteger.
	Answers the number of strings remaining in the list, or -1 if anInteger is out of
	bounds."

	^self sendMessage: CB_DELETESTRING wParam: anInteger - 1!

canHScroll
	"Answer whether the receiver's edit field is in horizontal scrolling mode."

	^self baseStyleAllMask: CBS_AUTOHSCROLL!

canHScroll: aBoolean 
	"Sets the receiver into horizontal scrolling mode if aBoolean is true. When this style is
	off the control limits the amount of text that can be entered to that which can be displayed
	in the box. When the style is on the user can enter more text than can be displayed (the
	caret remains at the right edge of the field and the text scrolls left to accomodate new
	input). This style is only relevant when the combobox has an associated edit field (i.e. not
	when in #dropDownList mode)."

	"Implementation Note: The control ignores changes to this style after creation, so we must
	accept the default action, which is to recreate the view."

	self 
		baseStyleMask: CBS_AUTOHSCROLL
		set: aBoolean
		recreateIfChanged: true!

cbnDblClk
	"Private - A CBN_DBLCLK has been received by our parent window. Inform the presenter to
	perform its action when in simple mode."

	"Note that the Win32 documentation states 'This notification message occurs only for a combo
	box with the CBS_SIMPLE style. In a combo box with the CBS_DROPDOWN or CBS_DROPDOWNLIST
	style, a double-click cannot occur because a single click closes the list box.'. This suits
	us fine because we fire the action on selection when the receiver is in #dropDown or
	#dropDownList mode."

	self presenter performAction.
	^nil!

cbnErrSpace
	"Private - A CBN_ERRSPACE has been received by our parent window. Signal an
	OutOfMemoryError"

	^self errorOutOfMemory
!

cbnKillFocus
	"Private - An CBN_KILLFOCUS has been received by our parent window."

	"Implementation Note: This is useful because when a Combo receives a WM_SETFOCUS it
	immediately changes focus to one of its children thus generating a confusing WM_KILLFOCUS.
	This class therefore absorbs WM_KILLFOCUS events to prevent two onKillFocus messages being
	sent."

	^self presenter onKillFocus!

cbnSelChange
	"Private - An CBN_SELCHANGE has been received by our parent window."

	(self onSelChanging and: [self mode ~~ #simple]) 
		ifTrue: 
			["Unless in simple mode treat selection as action"
			self isStateRestoring ifFalse: [self presenter performAction]].
	^nil!

cbnSetFocus
	"Private - An CBN_SETFOCUS has been received by our parent window."

	"Implementation Note: This is useful because although a Combo receives the normal
	WM_SETFOCUS it immediately changes focus to one of its children. This class therefore
	absorbs WM_SETFOCUS events to prevent two onSetFocus messages being sent."

	^self presenter onSetFocus!

command: anInteger id: id
	"Private - Handler for a redirected WM_COMMAND notification message."

	^((IdentityDictionary new
		at: -1 put: #cbnErrSpace;
		at: 1 put: #cbnSelChange;
		at: 2 put: #cbnDblClk;
		at: 3 put: #cbnSetFocus;
		at: 4 put: #cbnKillFocus;
		shrink;
		yourself) lookup: anInteger)
		ifNotNil: [:selector | self perform: selector]!

cueBanner
	"Answer the textual cue to be displayed when this combo box is empty and does not have
	focus, or nil if none is set."

	| buf |
	buf := Utf16String newFixed: 512.
	^((self
		sendMessage: CB_GETCUEBANNER
		wParam: buf yourAddress
		lParam: buf size + 1) ~~ 0
		and: [buf first ~~ $\0]) ifTrue: [buf trimNulls]!

cueBanner: aString
	"Set a textual cue to be displayed when the combo box is empty and does not have focus."

	self
		sendMessage: CB_SETCUEBANNER
		wParam: 0
		szParam: aString ?? ''!

defaultWindowStyle
	"Private - Answer a default window base style to use when creating a combobox."

	^super defaultWindowStyle bitOr: ##(CBS_HASSTRINGS | CBS_NOINTEGRALHEIGHT | CBS_DROPDOWN)!

droppedHeight
	"Answer the height of the drop down list component of the receiver."

	^droppedHeight!

droppedHeight: anInteger 
	"Set the dropped height of the receiver."

	droppedHeight := anInteger.
	self height: self actualHeight!

editHwnd
	"Private - Answer an <ExternalHandle> that is the handle of the Edit control
	belonging to the receiver."

	^self getItemHandle: 1001 ifAbsent: [self error: 'No Edit child found']!

editView
	"Answer the <TextEdit> that represents the Edit control belonging to the receiver."

	| hWnd editView |
	hWnd := self editHwnd.
	editView := View withHandle: hWnd.
	editView isNil 
		ifTrue: 
			[editView := (Smalltalk at: #TextEdit ifAbsent: [ControlView]) new.
			editView
				parentView: self;
				attachHandle: hWnd;
				subclassWindow].
	^editView!

extent: aPoint 
	"Set the dimensions of the receiver's outer window to the <Point>
	argument."

	"Implementation Note: Override because the height of a combo-box cannot be
	changed (unless in simple mode) - it is fixed as the height of the edit box plus the 
	droppedHeight."

	super 
		extent: (self mode == #simple ifTrue: [aPoint] ifFalse: [aPoint x @ self actualHeight])!

getSelectionsByIndex
	"Private - Query the current selections from the control"

	| index |
	index := (self sendMessage: CB_GETCURSEL) + 1.
	^index == 0 ifTrue: [#()] ifFalse: [{index}]!

getSingleSelection
	"Private - Answer the one-based <integer> 'index' of the selected object in the receiver or
	zero if there is none."

	^(self sendMessage: CB_GETCURSEL) + 1!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	droppedHeight := 200.!

itemCount
	"Answers the count of elements in the receiver. This may be 
	different from the answer to #size if the model has been updated but
	the change has not yet propaged to the receiver's contents"

	^self sendMessage: CB_GETCOUNT!

itemFromPoint: aPoint 
	"Private - Answer the index of the object in the list under the <Point> argument, or nil if
	none. Note that the answer may be greater than the one-based index of the last item in the
	list. It is the callers responsibilty to interpret appropriately - e.g. to accept drops past
	the last item in the list."

	^self mode == #simple ifTrue: [Error notYetImplemented] ifFalse: [self shouldNotImplement]!

mode
	"Answer the symbolic mode name for the receiver, one of:
		#simple		- list
		#dropDown		- edit field, with drop-down
		#dropDownList 	- drop-down only."

	^Modes at: (self baseStyle bitAnd: ##(CBS_SIMPLE | CBS_DROPDOWN | CBS_DROPDOWNLIST))!

mode: modeSymbol
	"Set the receiver into either #simple, #dropDown, or #dropDownList mode, depending on
	the symbol argument, modeSymbol. The valid modes are:
		#simple		- edit control and permanent list of standard values
		#dropDown		- edit control and drop-down list of standard values
		#dropDownList	- static (non-editable) with drop-down list of all valid values."

	| style |
	style := Modes keyAtValue: modeSymbol.
	self 
		baseStyle: style
		maskedBy: ##(CBS_SIMPLE|CBS_DROPDOWN|CBS_DROPDOWNLIST)
	!

onPositionChanged: aPositionEvent 
	"Handle a window position change event (move or resize)."

	"Implementation Note:  Unless the receiver is in #simple mode
	then 	we can't invalidate the layout on resize because the combo-box 
	always stays the same height (depending on the font and some system
	settings) and an infinite loop may otherwise result in the layout manager."

	^(aPositionEvent isResize and: [self mode ~~ #simple]) 
		ifFalse: [super onPositionChanged: aPositionEvent]!

placement: aWINDOWPLACEMENT 
	"Private - Sets the current placement (e.g. minimized/maximized/restored locations 
	and extents) of the receiver from information in the <WINDOWPLACEMENT>
	argument."

	"Implementation Note: Except when in #simple mode (i.e. always dropped down), the 
	extent reported by a combobox does not include the dropped height. However when 
	setting the extent one must include that as there is no other mechanism to tell the 
	control how big the drop-down should be.  The edit field is a fixed height based on 
	the font size and system metrics."

	| placement |
	self mode == #simple 
		ifTrue: [placement := aWINDOWPLACEMENT]
		ifFalse: 
			[| rect |
			placement := aWINDOWPLACEMENT copy.
			rect := aWINDOWPLACEMENT rcNormalPosition.
			rect bottom: rect bottom + self droppedHeight.
			placement rcNormalPosition: rect].
	super placement: placement!

selectionByIndex
	"Answer the one-based <integer> 'index' of the selected object in the receiver or zero if there is none."

	^(self sendMessage: CB_GETCURSEL) + 1!

setSingleSelection: anInteger 
	"Private - Set the selection to the item with the specified index (1-based), scrolling it
	into view if necessary."

	self sendMessage: CB_SETCURSEL wParam: anInteger - 1!

textLimit: anInteger 
	"Set the maximum text limit for the receiver's edit field. The initial default limit is
	around 32kb. The maximum limits are as follows:
		NT - 0x7FFFFFFE
		9x/Me - 16r7FFE (i.e. less than 32kb).
	This setting is only relevant when the combobox has an edit field (i.e. when not in
	#dropDownList mode), and when #canHScroll is true."

	(anInteger between: 1 and: self class maxTextLimit) ifFalse: [^self errorSubscriptBounds: anInteger].
	self sendMessage: CB_LIMITTEXT wParam: anInteger!

wmKillFocus: message wParam: wParam lParam: lParam
	"Private - This window is losing focus. 
	Implementation Note: Absorb this message as we do our focus handling in 
	response to the combo-box notifications."

	^nil!

wmSetFocus: message wParam: wParam lParam: lParam
	"Private - This window is gaining focus. 
	Implementation Note: Absorb this message as we do our focus handling in 
	response to the combo-box notifications."

	^nil! !

!ComboBox categoriesForMethods!
actualHeight!accessing!geometry!private! !
adjustRectangle:!geometry!public! !
basicAdd:!adding!private! !
basicAdd:atIndex:!adding!private! !
basicClear!private!removing! !
basicRemoveAtIndex:!private!removing! !
canHScroll!accessing-styles!public! !
canHScroll:!accessing-styles!public! !
cbnDblClk!event handling-win32!private! !
cbnErrSpace!event handling-win32!private! !
cbnKillFocus!event handling-win32!private! !
cbnSelChange!event handling-win32!private!selection! !
cbnSetFocus!event handling-win32!private! !
command:id:!commands!private! !
cueBanner!event handling!public! !
cueBanner:!event handling!public! !
defaultWindowStyle!constants!private! !
droppedHeight!accessing!public! !
droppedHeight:!accessing!public! !
editHwnd!accessing!private! !
editView!accessing!public! !
extent:!geometry!public! !
getSelectionsByIndex!private!selection! !
getSingleSelection!helpers!private!selection! !
initialize!initializing!private! !
itemCount!accessing!public! !
itemFromPoint:!enquiries!private! !
mode!accessing-styles!public! !
mode:!accessing-styles!public! !
onPositionChanged:!event handling!public! !
placement:!geometry!private! !
selectionByIndex!helpers!private!selection! !
setSingleSelection:!private!selection! !
textLimit:!accessing!public! !
wmKillFocus:wParam:lParam:!event handling-win32!private! !
wmSetFocus:wParam:lParam:!event handling-win32!private! !
!

!ComboBox class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialise the receiver's class variables.
		ComboBox initialize
	"

	self addClassConstant: 'Modes' value: #(#simple #dropDown #dropDownList)!

themePartName
	^#ComboBox
!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'COMBOBOX'
! !

!ComboBox class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
themePartName!constants!private! !
winClassName!constants!private! !
!

