"Filed out from Dolphin Smalltalk 7"!

IconicListAbstract subclass: #TabView
	instanceVariableNames: 'viewMode'
	classVariableNames: 'TabOrientations TabViewModes'
	poolDictionaries: 'TabViewConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'OrientationMask' -> 16r82
	}!
TabView guid: (GUID fromString: '{87b4c731-026e-11d3-9fd7-00a0cc3e4a32}')!
TabView comment: 'TabView is the <listView> implementing the Windows "SysTabControl32" common control. It is for single selection use and, therefore, implements the <selectableItems> protocol. Each of the list items displayed by the view appear in separate "tabs". The list operates in one of three modes (#noIcons, #smallIcons, #largeIcons) that can be selected using the #viewMode aspect.

The most typical use of a <TabView> is as part of a <CardContainer> where each of the cards is identified by a separate tab.

Instance Variables:
	viewMode		<Symbol> indicating the current view mode.

Class Variables:
	TcnMap		<IdentityDictionary> mapping Windows notification messages to <selectors>.

'!
!TabView categoriesForClass!MVP-Views! !
!TabView methodsFor!

applyImageLists
	"Private - Set the receiver's image list from the image manager."

	| imList |
	imList := self hasIcons ifTrue: [self imageManager imageListWithExtent: self imageExtent].
	self tcmSetImageList: imList!

basicAdd: anObject atIndex: anInteger 
	"Private - Adds anObject to the TabControl at 1 based index, anInteger.
	Does not add to the receiver's contents collection (assumes this has already been done)"

	^self tcmInsertItem: (self makeTcItemStruct: anObject) atOffset: anInteger - 1!

basicClear
	"Private - Clears down the tab view control(but not its model)."

	(self sendMessage: TCM_DELETEALLITEMS) == 0 ifTrue: [^self errorInCommonControlCall]!

basicItemFromPoint: aPoint 
	"Private - Answer a TCHITTESTINFO populated with details of the item under the <Point>
	argument."

	| struct |
	struct := TCHITTESTINFO new.
	struct pt: aPoint asParameter.
	struct iItem: (self 
				sendMessage: TCM_HITTEST
				wParam: 0
				lpParam: struct).
	^struct!

basicRefreshContents
	self noRedrawDo: 
			[self basicClear.
			self list keysAndValuesDo: [:index :each | self basicAdd: each atIndex: index]].
	self invalidate!

basicRemoveAtIndex: anInteger 
	"Private - Delete item at anInteger index in the receiver"

	(self sendMessage: TCM_DELETEITEM wParam: anInteger - 1) == 0 
		ifTrue: [^self errorInCommonControlCall]!

beNoIcons
	"Work without icons."

	self viewMode: #noIcons!

calcClientRectangleFromRectangle: aRectangle 
	"Private - Given a window rectangle represented by the <Rectangle> argument, answer the
	client area that this would provide, taking into account the current window styles etc."

	| clientRect |
	clientRect := self tcmAdjustRect: false for: aRectangle.
	(self tabOrientation == #bottom and: [self isThemed]) ifTrue: [clientRect := clientRect translatedBy: 0 @ -2].
	^clientRect!

calcRectangleFromClientRectangle: aRectangle 
	"Private - Given a client rectangle represented by the <Rectangle> argument, answer the
	window rectangle that would be required to achieve this taking into account the current
	window styles etc Note that the answered rectangle is in the COORDINATE SYSTEM OF THE
	CLIENT."

	^self tcmAdjustRect: true for: aRectangle!

canEditLabels
	"Answer whether the receiver's labels can be edited in-place."

	^false!

defaultBackcolor
	"Private - Answer the default colour for the receiver's background"

	^Color face3d!

defaultExtent
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(350 @ 30)!

defaultWindowExStyle
	"Private - Answer the default extended window creation style."

	^super defaultWindowExStyle maskClear: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer a default base style to use when creating a tab view"

	^super defaultWindowStyle bitOr: TCS_MULTILINE!

dragOver: aDragDropSession 
	"The user is dragging the mouse over the receiver. If dropping is enabled, then select the tab under the mouse."

	| hit |
	hit := self basicItemFromPoint: (aDragDropSession dragPointInView: self).
	hit isItemHit 
		ifTrue: 
			[aDragDropSession hideCursorWhile: 
					[self selectionByIndex: hit handle.
					self topView update]].
	^super dragOver: aDragDropSession!

ensureVisible: anIntegerOrHandle 
	"Ensure the item with the specified index is visible, scrolling it into view if necessary."

	"Nothing to do (or nothing we can do)"!

fontChanged
	"Private - The receiver's font has been changed, this will affect the tab geometry."

	super fontChanged.
	self invalidateLayout!

getItem: anInteger
	| tcItem |
	tcItem := TCITEMW new.
	tcItem
		newTextBuffer: 256;
		maskIn: tcItem imageValidMask.
	self
		sendMessage: TCM_GETITEMW
		wParam: anInteger - 1
		lpParam: tcItem asParameter.
	^tcItem!

getSelectionsByIndex
	"Private - Query the current selections from the control"

	| index |
	index := self getSingleSelection.
	^index == 0 ifTrue: [#()] ifFalse: [{index}]!

getSingleSelection
	"Private - Answers the handle of the selected object in the receiver or zero if
	there is none."

	^(self sendMessage: TCM_GETCURSEL) + 1!

hasButtons
	"Answer whether the receiver has the buttons instead of tabs
	(i.e. the TCS_BUTTONS style)."

	^self baseStyleAllMask: TCS_BUTTONS!

hasButtons: aBoolean 
	"Set whether or not the receiver has the buttons instead of tabs
	(i.e. the TCS_BUTTONS style)."

	self 
		baseStyleMask: TCS_BUTTONS
		set: aBoolean
		recreateIfChanged: false	"Modifiable after creation"!

hasFlatSeparators
	"Answer whether the receiver has the the TCS_EX_FLATSEPARATORS style."

	^self tabViewStyleAllMask: TCS_EX_FLATSEPARATORS!

hasFlatSeparators: aBoolean
	"Set whether or not the receiver has the the TCS_EX_FLATSEPARATORS style."

	^self tabViewStyleMask: TCS_EX_FLATSEPARATORS set: aBoolean!

hasHotTracking
	"Answer whether the receiver has the hot-tracking style whereby tabs that are hovered over are automatically selected."

	"Implementation Note: TCS_HOTTRACK does not correspond to our definition of hot-tracking -
	it just moves the highlight, not the selection - so we implement the tracking ourselves by
	using TrackMouseEvent to generate WM_MOUSEHOVER messages."

	^self baseStyleAllMask: TCS_HOTTRACK!

hasHotTracking: aBoolean 
	"Sets the receiver to hot-track the selection or not depending on the value of aBoolean."

	self 
		baseStyleMask: TCS_HOTTRACK
		set: aBoolean
		recreateIfChanged: false!

hasIcons
	"Answer true if the receiver wants to show icons."

	^self viewMode ~= #noIcons
!

hasToolTips
	"Answer whether or not the receiver has tool tips (i.e. the TCS_TOOLTIPS style)."

	^self baseStyleAllMask: TCS_TOOLTIPS
!

hasToolTips: aBoolean 
	"Set whether or not the receiver has tool tips (i.e. the TCS_TOOLTIPS style)."

	self 
		baseStyleMask: TCS_TOOLTIPS
		set: aBoolean
		recreateIfChanged: true	"Requires a recreate to take effect."!

initialize
	"Private - Initialise the instance on creation."

	super initialize.
	viewMode := #noIcons.
	backcolor := Color default!

isInverted
	"Answer whether the receiver has its buttons or tabs along its bottom or right edges rather
	than along its top or left edges."

	^self baseStyleAllMask: TCS_BOTTOM!

isInverted: aBoolean
	Notification deprecated.	"D6: Use #tabOrientation:"
	(self
		baseStyleMask: TCS_BOTTOM
		set: aBoolean
		recreateIfChanged: self isVertical) ifTrue: [self invalidateLayout]	"Modifiable after creation if not vertical"!

isMultiline
	"Answers whether the receiver can display multiple lines of tabs."

	^self baseStyleAllMask: TCS_MULTILINE!

isMultiline: aBoolean 
	"Set whether the receiver can display multiple lines of tabs."

	(self isVertical and: [aBoolean not]) 
		ifTrue: [^self error: 'Single line mode is not supported with vertical tabs'].
	(self 
		baseStyleMask: TCS_MULTILINE
		set: aBoolean
		recreateIfChanged: false) ifTrue: [self invalidateLayout]!

isVertical
	"Answer whether the receiver has a vertical orientation."

	^self baseStyleAllMask: TCS_VERTICAL!

isVertical: aBoolean
	Notification deprecated.	"D6: Use #tabOrientation:"
	(self
		baseStyleMask: TCS_VERTICAL
		set: aBoolean
		recreateIfChanged: true) ifTrue: [self invalidateLayout]	"Requires a recreate to take proper effect"!

itemCount
	"Answer the total number of items in the view."

	^self sendMessage: TCM_GETITEMCOUNT!

itemFromNMHDRA: pNMHDR
	^self shouldNotImplement!

itemFromNMHDRW: pNMHDR
	^self shouldNotImplement!

itemRect: anInteger textOnly: aBoolean 
	"Answers the rectangle surrounding the item with anIntegerIndex within
	the receiver, optionally for the text label only."

	^(self tcmGetItemRect: anInteger-1) asObject!

makeTcItemStruct: anObject
	| tcItem |
	tcItem := TCITEMW new.
	tcItem text: (self getTextBlock value: anObject).
	self hasIcons
		ifTrue: 
			[(self getImageBlock value: anObject)
				ifNil: [tcItem image: -1]
				ifNotNil: [:imageIndex | tcItem image: imageIndex - 1]].
	^tcItem!

nmNotify: pNMHDR
	"Private - Handler for a redirected WinTab WM_NOTIFY message."

	^(##((Array new: TCN_FIRST - TCN_SELCHANGING + 1 withAll: #nmDummy:)
		at: TCN_FIRST - TCN_KEYDOWN + 1 put: #nmKeyDown:;
		at: TCN_FIRST - TCN_SELCHANGE + 1 put: #nmSelChanged:;
		at: TCN_FIRST - TCN_SELCHANGING + 1 put: #tcnSelChanging:;
		yourself) lookup: ##(TCN_FIRST + 1) - (pNMHDR sdwordAtOffset: 8))
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

onItem: anObject removedAtIndex: anInteger 
	"Event received when the <Object>, anObject, has been removed from the receiver's
	model at the <integer> index, anInteger. Remove the appropriate object from the tab
	view, and move the selection (if any) back to the previous tab."

	| selIndex |
	selIndex := self selectionByIndex.
	self basicRemoveAtIndex: anInteger.
	selIndex = anInteger 
		ifTrue: 
			[self itemCount > 0 
				ifTrue: [self selectionByIndex: (selIndex - 1 max: 1)]
				ifFalse: [self onSelChanged: nil]]!

onMouseHovering: aMouseEvent 
	"The user is hovering the mouse over the receiver. If hot-tracking is enabled, then select the tab under the mouse."

	self hasHotTracking 
		ifTrue: 
			[| hit |
			hit := self basicItemFromPoint: aMouseEvent position.
			(hit isItemHit and: [self selectionByIndex ~= hit handle]) 
				ifTrue: 
					[| event |
					event := SelectionChangingEvent forSource: self.
					event oldSelection: self selectionOrNil.
					self presenter onSelectionChanging: event.
					event value ifTrue: [self selectionByIndex: hit handle]]].
	^super onMouseHovering: aMouseEvent!

onMouseMoved: aMouseEvent 
	"Handler for mouseMoved: events."

	self hasHotTracking ifTrue: [self trackMouseHover: -1].
	^super onMouseMoved: aMouseEvent!

onViewCreated
	"The receiver window has been created. Copy the info held
	in instance variables across to it"

	super onViewCreated.
	self viewMode: self viewMode.

	"In Common Controls 6 the vertical style of tab can't be used with themes because the theme
	graphics are all designed for horizontal tabs."
	(self isVertical and: [self supportsThemedVertical not]) ifTrue: [self beNotThemed].
	self refreshContents!

preTranslateKeyboardInput: aMSG 
	"Answer whether the receiver would like to consume the argument aMSG, which is a keyboard
	message."

	| vk |
	vk := aMSG wParam.
	((vk == VK_TAB or: [vk == VK_PRIOR or: [vk == VK_NEXT]]) and: [Keyboard default isCtrlDown]) 
		ifTrue: 
			[aMSG message == WM_KEYDOWN 
				ifTrue: 
					[| index |
					index := self selectionByIndex.
					index := (vk == VK_PRIOR or: [vk == VK_TAB and: [Keyboard default isShiftDown]]) 
								ifTrue: [index = 1 ifTrue: [self size] ifFalse: [index - 1]]
								ifFalse: [index \\ self size + 1].
					self selectionByIndex: index].
			^true].
	^false!

queryCommand: aCommandQuery 
	"Private - Update aCommandQuery to indicates how a command would be processed.
	if sent to the receiver."

	"Note: TabViews must respond to the CommandTarget protocol in order to address issue #1841 where CardContainers
	were not receiving #queryCommand: messages when their owned TabViews were right clicked. Hence the addition of
	the dummy implementation here."
	!

refreshContents
	"Refresh the receiver's contents to match the contents collection"

	self isOpen ifFalse: [^self].
	self basicRefreshContents.
	self onSelChanged: nil!

rows
	"Answer the number of tab rows in the receiver."

	^self sendMessage: TCM_GETROWCOUNT!

selectionByIndex
	"Answers the handle of the selected object in the receiver or zero if there is none."

	^(self sendMessage: TCM_GETCURSEL) + 1!

selectionByIndex: anInteger ifAbsent: exceptionHandler 
	"Selects the object identified by the specified one-based <integer> index in the receiver.
	If the index is zero then all selections are cleared. Answers the new selection index, or
	the result of evaluating the <niladicValuable>, exceptionHandler, if the index is out of
	range."

	self selectionByIndex = anInteger 
		ifFalse: 
			[(anInteger >= 0 and: [anInteger <= self itemCount]) ifFalse: [^exceptionHandler value].
			self setSingleSelection: anInteger.

			"Windows only sends the selection change notification when the selection is
			the result of a user action so force it here"
			self onSelChanged: nil].
	^anInteger!

selectionState
	| selectedIndex |
	selectedIndex := self selectionByIndex.
	^selectedIndex == 0
		ifFalse: 
			[MessageSend
				receiver: self
				selector: #setSingleSelection:
				argument: selectedIndex]!

setSingleSelection: anInteger 
	self sendMessage: TCM_SETCURSEL wParam: anInteger - 1!

setViewMode: aSymbol 
	viewMode := aSymbol!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	| sequence |
	sequence := super state.
	sequence add: (MessageSend
				receiver: self
				selector: #tcmSetExtendedStyle:dwExStyle:
				arguments: {-1. self tcmGetExtendedStyle}).
	^sequence!

supportsThemedVertical
	^false!

tabOrientation
	"Answer a <Symbol> naming the orientation of the receiver. This primarily controls where the
	tab strip is displayed and is one of #left, #right, #top (the default) or #bottom."

	^TabOrientations at: (self baseStyle bitAnd: OrientationMask)!

tabOrientation: aSymbol 
	"Set the the orientation (i.e. the edge along which the tabs are displayed) of the receiver
	to that named by the <Symbol> argument. Note that if a vertical mode is selected then the
	single-line (scrolling tabs) mode is not supported so we switch on the multiline flag implicitly."

	| orientationFlags mask initialSelections |
	initialSelections := self selections.
	orientationFlags := TabOrientations keyAtValue: aSymbol ifAbsent: [0].
	mask := (orientationFlags allMask: TCS_VERTICAL) 
				ifTrue: 
					[orientationFlags := orientationFlags | TCS_MULTILINE.
					OrientationMask | TCS_MULTILINE]
				ifFalse: [OrientationMask].
	(self 
		baseStyle: orientationFlags
		maskedBy: mask
		recreateIfChanged: true) ifTrue: [self invalidateLayout].
	self noEventsDo: [self selections: initialSelections]!

tabViewStyleAllMask: anInteger
	"Private - Answers true if the tab view's extended style bits contains all the bits in anInteger"

	^self tcmGetExtendedStyle allMask: anInteger.
!

tabViewStyleMask: mask set: aBoolean
	"Private - Sets/clears the tab view's extended style bits in the
	32-bit unsigned <integer>, mask."

	^self tcmSetExtendedStyle: mask dwExStyle: aBoolean asParameter negated!

tcmAdjustRect: aBooleanMode for: aRectangle 
	"Private - Calculates the display area for a given window rectangle or calculates
	the window rectangle that would correspond to a specified display area. The operation
	is determined by aBooleanMode being false or true respectively. Answers the calculated
	rectangle"

	| wr |
	"The control has a bug whereby TCM_ADJUSTRECT sometimes GPFs when it has no extent"
	aRectangle extent isZero ifTrue: [^aRectangle].
	wr := aRectangle asParameter.
	self 
		sendMessage: TCM_ADJUSTRECT
		wParam: aBooleanMode asParameter
		lpParam: wr asParameter.
	^wr asRectangle!

tcmGetCurFocus
	"Private - Answer the zero-based <integer> index of the tab with focus."

	^self sendMessage: TCM_GETCURSEL!

tcmGetExtendedStyle
	"Private - Answer the views extended style flags."

	^self sendMessage: TCM_GETEXTENDEDSTYLE wParam: 0 lpParam: 0!

tcmGetItemRect: anInteger 
	"Private - Answer the bounding rectangle for the tree-view item identified by aHandle. If aBoolean is true,
	the bounding rectangle includes only the text of the item, otherwise, it includes the entire line
	that the item occupies in the tree-view control."

	| rect |
	rect := RECT new.
	self 
		sendMessage: TCM_GETITEMRECT
		wParam: anInteger
		lpParam: rect.
	^rect!

tcmInsertItem: tcItem atOffset: anInteger
	"Private - Insert a tab defined by tcItem to the receiver at offset anInteger."

	^self
		sendMessage: TCM_INSERTITEMW
		wParam: anInteger
		lpParam: tcItem asParameter!

tcmSetExtendedStyle: dwExMask dwExStyle: dwExStyle
	"Private - Set the extended styles of the receiver. Only those flags
	masked in by the unsigned 32-bit <integer> mask, dwExMask,
	will be affected. Answers a 32-bit unsigned <integer> that contains
	the previous extended style flags."

	^self sendMessage: TCM_SETEXTENDEDSTYLE wParam: dwExMask lParam: dwExStyle!

tcmSetImageList: aWinImageList
	"Private - Set the image list to aWinImageList."

	^self sendMessage: TCM_SETIMAGELIST wParam: 0 lParam: aWinImageList asParameter!

tcnSelChanging: pNMHDR
	"Private - Default handler for the TCN_SELCHANGING notification message.
	Answer false to permit the selection to change, true to prevent it."

	^(self isStateRestoring or: 
			[| event |
			event := SelectionChangingEvent forSource: self.
			"In the case of the tab control, the notification is just that the selection
			is changing. There is no helpful information as to what the selection
			currently is and what it will be."
			event oldSelection: self selectionOrNil.
			self presenter onSelectionChanging: event.
			event value]) 
		not!

updateAllNonVirtual
	"Private - Update the text and images the tree view stores for each item in non-dynamic view."

	self list keysAndValuesDo: [:index :each | self updateItem: each atIndex: index]!

updateItem: anObject atIndex: aninteger 
	"Re-render the specified item, which is at the specified <integer> index in the list."

	| tcItem |
	tcItem := self makeTcItemStruct: anObject.
	self 
		sendMessage: TCM_SETITEMW
		wParam: aninteger - 1
		lpParam: tcItem asParameter!

updateSelectionCache
	"Private - The tab view is somewhat unlike other Windows list controls. The first item to be added to
	it will automatically be selected. Since no lists generate selection events due to programmatic
	manipulation (like this) we have to force a selection changed event here in this situation"

	self itemCount = 1 ifTrue: [self onSelChanged: nil]!

viewMode
	"Answer the view mode of the reciver.
	This can be one of:
		#noIcons
		#smallIcons	(16x16)
		#mediumIcons	(24x24)
		#largeIcons	(32x32)
		#tileIcons		(48x48)
		#thumbnails	(64@64)
		#extraLargeIcons (256@256)"

	^viewMode
		!

viewModeChanged
	super viewModeChanged.
	self invalidateLayout! !
!TabView categoriesFor: #applyImageLists!image management!private! !
!TabView categoriesFor: #basicAdd:atIndex:!adding!private! !
!TabView categoriesFor: #basicClear!public!removing! !
!TabView categoriesFor: #basicItemFromPoint:!accessing!private! !
!TabView categoriesFor: #basicRefreshContents!private!updating! !
!TabView categoriesFor: #basicRemoveAtIndex:!public!removing! !
!TabView categoriesFor: #beNoIcons!modes!public! !
!TabView categoriesFor: #calcClientRectangleFromRectangle:!private! !
!TabView categoriesFor: #calcRectangleFromClientRectangle:!geometry!private! !
!TabView categoriesFor: #canEditLabels!accessing-styles!public!testing! !
!TabView categoriesFor: #defaultBackcolor!private! !
!TabView categoriesFor: #defaultExtent!constants!private! !
!TabView categoriesFor: #defaultWindowExStyle!constants!private! !
!TabView categoriesFor: #defaultWindowStyle!constants!public! !
!TabView categoriesFor: #dragOver:!drag & drop!public! !
!TabView categoriesFor: #ensureVisible:!public! !
!TabView categoriesFor: #fontChanged!public!updating! !
!TabView categoriesFor: #getItem:!helpers!private! !
!TabView categoriesFor: #getSelectionsByIndex!private!selection! !
!TabView categoriesFor: #getSingleSelection!public!selection! !
!TabView categoriesFor: #hasButtons!accessing-styles!public! !
!TabView categoriesFor: #hasButtons:!accessing-styles!public! !
!TabView categoriesFor: #hasFlatSeparators!accessing-styles!public! !
!TabView categoriesFor: #hasFlatSeparators:!accessing-styles!public! !
!TabView categoriesFor: #hasHotTracking!accessing-styles!public! !
!TabView categoriesFor: #hasHotTracking:!accessing-styles!public! !
!TabView categoriesFor: #hasIcons!public!testing! !
!TabView categoriesFor: #hasToolTips!accessing-styles!public! !
!TabView categoriesFor: #hasToolTips:!accessing-styles!public! !
!TabView categoriesFor: #initialize!initializing!private! !
!TabView categoriesFor: #isInverted!accessing-styles!public! !
!TabView categoriesFor: #isInverted:!accessing-styles!public! !
!TabView categoriesFor: #isMultiline!accessing!public! !
!TabView categoriesFor: #isMultiline:!accessing!public! !
!TabView categoriesFor: #isVertical!accessing-styles!public! !
!TabView categoriesFor: #isVertical:!accessing-styles!public! !
!TabView categoriesFor: #itemCount!accessing!public! !
!TabView categoriesFor: #itemFromNMHDRA:!helpers!private! !
!TabView categoriesFor: #itemFromNMHDRW:!event handling-win32!private! !
!TabView categoriesFor: #itemRect:textOnly:!public! !
!TabView categoriesFor: #makeTcItemStruct:!adding!private! !
!TabView categoriesFor: #nmNotify:!event handling-win32!private! !
!TabView categoriesFor: #onItem:removedAtIndex:!event handling!public! !
!TabView categoriesFor: #onMouseHovering:!constants!public! !
!TabView categoriesFor: #onMouseMoved:!event handling!public! !
!TabView categoriesFor: #onViewCreated!event handling!public! !
!TabView categoriesFor: #preTranslateKeyboardInput:!public! !
!TabView categoriesFor: #queryCommand:!private! !
!TabView categoriesFor: #refreshContents!public!updating! !
!TabView categoriesFor: #rows!geometry!public! !
!TabView categoriesFor: #selectionByIndex!public!selection! !
!TabView categoriesFor: #selectionByIndex:ifAbsent:!public!selection! !
!TabView categoriesFor: #selectionState!accessing!private! !
!TabView categoriesFor: #setSingleSelection:!public!selection! !
!TabView categoriesFor: #setViewMode:!accessing!private! !
!TabView categoriesFor: #state!accessing!private! !
!TabView categoriesFor: #supportsThemedVertical!constants!private! !
!TabView categoriesFor: #tabOrientation!event handling!public! !
!TabView categoriesFor: #tabOrientation:!event handling!public! !
!TabView categoriesFor: #tabViewStyleAllMask:!accessing-styles!private! !
!TabView categoriesFor: #tabViewStyleMask:set:!accessing-styles!private! !
!TabView categoriesFor: #tcmAdjustRect:for:!geometry!private! !
!TabView categoriesFor: #tcmGetCurFocus!private!selection! !
!TabView categoriesFor: #tcmGetExtendedStyle!accessing-styles!private! !
!TabView categoriesFor: #tcmGetItemRect:!private! !
!TabView categoriesFor: #tcmInsertItem:atOffset:!adding!private! !
!TabView categoriesFor: #tcmSetExtendedStyle:dwExStyle:!accessing-styles!private! !
!TabView categoriesFor: #tcmSetImageList:!image management!private! !
!TabView categoriesFor: #tcnSelChanging:!event handling-win32!private! !
!TabView categoriesFor: #updateAllNonVirtual!private!updating! !
!TabView categoriesFor: #updateItem:atIndex:!event handling!public! !
!TabView categoriesFor: #updateSelectionCache!event handling!private! !
!TabView categoriesFor: #viewMode!accessing!public! !
!TabView categoriesFor: #viewModeChanged!helpers!private! !

!TabView class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialise the receiver's class variables.
		TabView initialize
	"

	self addClassConstant: 'TabOrientations'
		value: (IdentityDictionary new
				at: 0 put: #top;
				at: TCS_BOTTOM put: #bottom;
				at: TCS_VERTICAL put: #left;
				at: TCS_BOTTOM | TCS_VERTICAL put: #right;
				shrink;
				isImmutable: true;
				yourself).
	self addClassConstant: 'TabViewModes'
		value: (IdentityDictionary new
				at: #noIcons put: 0 @ 0;
				at: #smallIcons put: 16 @ 16;
				at: #mediumSmallIcons put: 20 @ 20;
				at: #mediumIcons put: 24 @ 24;
				at: #largeIcons put: 32 @ 32;
				at: #tileIcons put: 48 @ 48;
				at: #thumbnails put: 64 @ 64;
				at: #extraLargeIcons put: 256 @ 256;
				shrink;
				isImmutable: true;
				yourself)!

tabOrientations
	^TabOrientations!

viewModes
	^TabViewModes!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysTabControl32'
! !
!TabView class categoriesFor: #icon!constants!public! !
!TabView class categoriesFor: #initialize!development!initializing!private! !
!TabView class categoriesFor: #tabOrientations!accessing!constants!public! !
!TabView class categoriesFor: #viewModes!accessing!public! !
!TabView class categoriesFor: #winClassName!constants!private! !

