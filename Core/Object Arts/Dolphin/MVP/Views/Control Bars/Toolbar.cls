"Filed out from Dolphin Smalltalk 7"!

ControlBarAbstract subclass: #Toolbar
	instanceVariableNames: 'idMap items bitmapsStart insets tbFlags _reserved2 bitmapSize buttonSize tipText layoutManager'
	classVariableNames: 'LabelsMask TbnMap'
	poolDictionaries: 'ToolbarConstants'
	classInstanceVariableNames: ''!
Toolbar guid: (GUID fromString: '{87b4c72f-026e-11d3-9fd7-00a0cc3e4a32}')!
Toolbar comment: 'Toolbar is a <compositeView> implementing the Windows "ToolbarWindow32" common control.

Toolbar holds a list of <ToolbarItem> items matching the order of items in the control. Items may be added and deleted once the view has been created.  It also allows a name to be associated with each item. 

Instance Variables:
	idMap		<IdentityDictionary> mapping item IDs to <ToolbarItem>s
	items		<Array> of <ToolbarItem>s held by the toolbar.
	bitmapsStart	<LookupTable> of IDs for system bitmaps.
	reserved1		<UndefinedObject> reserved for future use.
	labels		<boolean> indicating whether buttons display labels.
	waitingItems	<UndefinedObject> reserved for future use.
	bitmapSize		<Point> size of each button bitmap.
	buttonSize		<Point> size of each button.
	tipText		<readableString> or nil, tip text for last button hover.
	layoutManager	<layoutManager> or nil, for managing the layout of sub-views.

Class Variables:
	TbnMap		<IdentityDictionary> mapping Windows messages to <selector>s.


'!
!Toolbar categoriesForClass!MVP-Views! !
!Toolbar methodsFor!

addBitmap: aBitmap index: anIntegerIndex
	"Private - Add the sub-bitmap identified by anIntegerIndex within aBitmap
	to the receiver. Answer the index of the sub-bitmap within the registered
	entries"

	| start |
	start := bitmapsStart at: aBitmap
				ifAbsentPut: 
					[| addBitmap size |
					aBitmap setMap3DColors: true.
					(addBitmap := TBADDBITMAP new)
						hInst: 0;
						nID: aBitmap asParameter.
					"If the extent reported by the bitmap is not correct, then the start index will be out,
					 so watch out for caching duff old extent (see Bitmap>>loadFromInstance)."
					size := aBitmap extent x // self bitmapSize x.

					"#305 We must make sure that the bitmap is not selected into a DC or the result will
					be a blank image in the list. This won't damage the bitmap in any way because the canvas
			`		can always be lazily recreated."
					aBitmap freeDC.

					self tbAddBitmap: addBitmap size: size].
	^start + anIntegerIndex!

addEditTools
	"Private - Add the standard file tools to the receiver."

	self addItems: self itemClass editTools!

addFileTools
	"Private - Add the standard file tools to the receiver."

	self addItems: self itemClass fileTools!

addFindTools
	"Private - Add the standard file tools to the receiver."

	self addItems: self itemClass findTools!

addItem: tool
	"Add the <ToolbarItem>, tool, to the receiver. Answer the new tool."

	(idMap includesKey: tool commandId) ifTrue: [^nil].
		
	items := items copyWith: tool.
	tool toolbar: self.

	^self basicAddItems: (Array with: tool)!

addItems: toolbarItems
	"Add a collection of ToolBaritems to the receiver, and answer that collection."

	| unique |
	unique := toolbarItems reject: [:t | idMap includesKey: t commandId].
	unique do: [:t | t toolbar: self].
	items := items, unique.
	self basicAddItems: unique.
	^toolbarItems!

addSeparator
	"Add a separator to the receiver. Answer that separator."

	^self addItem: ToolbarSeparator new!

addString: aString
	"Private - Add aString to the list of strings registered for the receiver.
	Answers the index of the string within the registry."

	^self tbAddString: aString!

addSystemBitmap: systemBitmapId index: anIntegerIndex 
	"Private - Add the system defined sub-bitmap identified by anIntegerIndex within
	the bitmap identified by systemBitmapId"

	| start |
	start := bitmapsStart at: systemBitmapId
				ifAbsentPut: 
					[| addBitmap |
					(addBitmap := TBADDBITMAP new)
						hInst: HINST_COMMCTRL;
						nID: systemBitmapId.
					self tbAddBitmap: addBitmap size: 0].
	^start + anIntegerIndex!

basicActualForeolor
	"Private - Answer the <Color> to be applied as the receiver's foreground colour. This might
	be 'Color default' indicating that the receiver is configured to use the default background
	colour, which might vary by view class. If no background colour is configured in the
	receiver, then it is inherited from the parent view. The inherited colour could be 'Color
	none' if the parent is transparent, but not 'normally Color default' since the parent will
	answers its own default colour if it is so configured. The exception is the desktop view,
	which will answer 'Color default' to instruct top-level views to draw in their own default
	colour."

	^self forecolor ifNil: [self parentView ambientBackcolor]!

basicAddItems: tools 
	"Private - Add the specified  <sequencedReadableCollection> of tools to the receiver
	positioning them beyond the present right most item. The tools are NOT added to the tools 
	collection but they are added to the Id map. Answers the argument."

	| buttons hasLabels size |
	size := tools size.
	size == 0 ifTrue: [^tools	"It is an error to set zero buttons on IE5/NT5"].
	buttons := StructureArray length: size elementClass: TBBUTTON.
	buttons beUnfinalizable.	"Nothing to free here"
	hasLabels := self hasLabels.
	buttons with: tools
		do: 
			[:tb :aToolbarItem | 
			| cmd |
			cmd := aToolbarItem getCommandId.
			cmd == 0 ifFalse: [idMap at: cmd put: aToolbarItem].
			tb
				iBitmap: (aToolbarItem imageIndexIn: self);
				idCommand: cmd;
				fsState: TB_STATEENABLED;
				fsStyle: aToolbarItem style;
				iString: (hasLabels ifTrue: [aToolbarItem textIndexIn: self] ifFalse: [-1])].
	self tbAddButtons: buttons.
	^tools!

bitmapSize
	"Answer the size of bitmaps shown on the toolbar"

	^bitmapSize copy!

bitmapSize: aPoint
	"Set the size of bitmaps shown on the toolbar to aPoint"

	bitmapSize := aPoint.
	self updateAllItems.!

buttonSize
	"Answer the size of buttons shown on the toolbar"

	^buttonSize copy!

buttonSize: aPointOrNil
	"Set the size of buttons shown on the toolbar to aPointOrNil.
	If nil then the buttons assume a default size."

	buttonSize := aPointOrNil.
	self updateAllItems.!

calcButtonWidths
	"Private - Answer the actual cummulative width of all the buttons in the receiver."

	| tbinfo sum |
	tbinfo := TBBUTTONINFO new.
	"We only need the size"
	tbinfo dwMask: TBIF_SIZE.
	sum := 0.
	items keysAndValuesDo: [:i :each | | cmd |
		cmd := each commandId.
		tbinfo cx: 0.
		self tbGetButtonInfo: cmd tbbi: tbinfo.
		sum := sum + tbinfo cx].
	^sum
	!

calculateExtent: aLayoutContext 
	"Private - Answer an extent for the receiver within the specified <LayoutContext>."

	"Implementation Note: Any suggested or existing extent is ignored. We calculate the extent
	required to draw all the buttons, etc, in the toolbar."

	| size buttonWidth verticalBugs dropDownBug |
	size := self tbGetMaxSize.
	"We need to workaround some Windows bugs: TB_GETMAXSIZE treats the height of a separator as
	being the full bar height, regardless of whether horizontal or vertical. Another bug is it
	not correctly allowing for the true width of drop down tool buttons. On older Windows
	versions this was always the case, since XP the bug only applies in vertical mode."
	buttonWidth := self buttonSize x.
	verticalBugs := self isVertical.
	dropDownBug := verticalBugs or: [VMLibrary default isWindowsXPOrGreater not].
	items do: 
			[:each | 
			(verticalBugs and: [each isDivider]) ifTrue: [size y: size y - buttonWidth].
			(dropDownBug and: [each isDropdownStyle]) 
				ifTrue: 
					[size x: size x + (each isDropDownOnly ifTrue: [buttonWidth // 3] ifFalse: [buttonWidth * 3 // 4])]].
	"Neither does the Windows calculation allow for a similar border above and below the button.
	We'll add half the pad height."
	size y: size y + (self tbGetPadding y // 2).
	^self calcExtentFromClientExtent: size!

canCustomize
	"Answers whether the user is allowed to customize the toolbar at runtime."

	^self baseStyleAllMask: CCS_ADJUSTABLE!

canCustomize: aBoolean 
	"Set whether the user is allowed to customize the toolbar at runtime."

	self 
		baseStyleMask: CCS_ADJUSTABLE
		set: aBoolean
		recreateIfChanged: false!

changeButtonSize: aNiladicBlock 
	"Private - Apply an operation that affects the button geometry of the toolbar, requiring
	that it recalculates its layout. Due to a bug in the common controls DLL if we want to
	maintain a consistent border width (of zero) between flat and non-flat styles we must turn
	on the flat/transparent style for the duration of the resizing operation."

	| style |
	style := self getWindowStyle.
	(style allMask: TBSTYLE_FLAT) ifTrue: [^aNiladicBlock value].
	^
	[self setWindowStyle: (style bitOr: ##(TBSTYLE_FLAT | TBSTYLE_TRANSPARENT)).
	aNiladicBlock value] 
			ensure: [self setWindowStyle: style]!

clearIdMap
	"Private - Clear down the idMap."

	idMap := IdentityDictionary new!

command: notifyCode id: id 
	"Private - Handler for a redirected WM_COMMAND notification message."

	^(idMap at: id ifAbsent: []) 
		ifNil: [super command: notifyCode id: id]
		ifNotNil: [:tool | self onCommand: tool commandDescription]!

commandSource
	"Answer the <View> which is the starting point for routing commands issued by the receiver.
	Delegate to the containing shell."

	^self topShell commandSource!

defaultBitmapSize
	"Private - Answer a default size for bitmaps in the receiver"

	^16 @ 15!

defaultButtonSize
	"Private - Answer a default size for buttons in the receiver"

	^22 @ 22!

defaultExtent
	"Private - Answer the default size of the receiver to be used when it is created."

	^##(350 @ 25)!

defaultGradientBackcolor
	"Private - Answer the default colour for the final colour in the receiver's gradient filled background"

	"This is the colour of the shadow at the bottom of a header control in the luna theme."

	^RGB 
		red: 203
		green: 199
		blue: 184!

defaultGradientForecolor
	"Private - Answer the default colour for the final colour in the receiver's gradient filled background"

	"This is Color light3d in the luna theme"

	^RGB 
		red: 241
		green: 239
		blue: 226!

defaultWindowStyle
	"Private - Answer a default base style to use when creating the receiver"

	^super defaultWindowStyle 
		bitOr: ##(TBSTYLE_TOOLTIPS | TBSTYLE_WRAPABLE)!

fontChanged
	"Private - The receiver's font has been changed. The default is to cause the receiver to
	resize."

	super fontChanged.
	self updateSize!

getLabelExtent: n 
	| item canvas extent |
	item := self items at: n.
	canvas := self canvas.
	canvas font: self actualFont.
	extent := canvas textExtent: item text.
	canvas free.
	^extent!

hasFlatAppearance
	"Answer whether the receiver has a flat appearance. A flat toolbar draws its buttons without
	outlines, and is also transparent (i.e. its buttons appear to be overlayed over the client
	area of the window underneath the ToolBar)."

	^self baseStyleAllMask: TBSTYLE_FLAT!

hasFlatAppearance: aBoolean 
	"Sets the receiver to have a flat appearance if aBoolean is true. A flat toolbar draws its
	buttons without outlines, and is also transparent (i.e. its buttons appear to be overlayed
	over the client area of the window underneath the ToolBar). Note that this style is ignored
	if running on WinXP with an application manifest that enables version 6 common controls - in
	that case toolbars are always flat and transparent."

	"Implementation Note: This style cannot be changed without recreating the toolbar - MSDN
	suggests that to do otherwise will cause 'redraw problems'"

	self 
		baseStyleMask: TBSTYLE_FLAT
		set: aBoolean
		recreateIfChanged: true!

hasLabels
	"Answer whether labels are to be included in buttons."

	^tbFlags allMask: LabelsMask!

hasLabels: aBoolean 
	"Set whether labels are to be included in a button."

	tbFlags := tbFlags mask: LabelsMask set: aBoolean.
	self updateAllItems!

hasListAppearance
	"Answers true if the receiver has a list appearance. i.e. it has the TBSTYLE_LIST style"

	^self baseStyleAllMask: TBSTYLE_LIST!

hasListAppearance: aBoolean 
	"Sets the receiver to have a list appearance if aBoolean is true. This is the TBSTYLE_LIST
	style"

	self 
		baseStyleMask: TBSTYLE_LIST
		set: aBoolean
		recreateIfChanged: true	"MSDN suggests recreation necessary to avoid redraw problems."!

hasTransparentAppearance: aBoolean 
	"Sets the receiver to have a flat appearance if aBoolean is true. A flat toolbar draws its
	buttons without outlines, and is also transparent (i.e. its buttons appear to be overlayed
	over the client area of the window underneath the ToolBar). Note that this style is ignored
	if running on WinXP with an application manifest that enables version 6 common controls - in
	that case toolbars are always flat and transparent."

	"Implementation Note: This style cannot be changed without recreating the toolbar - MSDN
	suggests that to do otherwise will cause 'redraw problems'"

	self 
		baseStyleMask: TBSTYLE_TRANSPARENT
		set: aBoolean
		recreateIfChanged: true!

hasTransparentBackground
	"Private - Answers true if the receiver has a transparent background."

	^self baseStyle anyMask: ##(TBSTYLE_FLAT | TBSTYLE_TRANSPARENT)!

indexOfItem: aToolbarItem
	"Private - Answer the index of aToolbarItem."

	^items identityIndexOf: aToolbarItem!

initialize
	"Private - Initialise the receiver."

	super initialize.
	self clearIdMap.
	items := Array new.
	tbFlags := 0.
	bitmapSize := self defaultBitmapSize.
	buttonSize := self defaultButtonSize.
	forecolor := Color default!

insets
	"Answer the <Rectangle> whose edges specify the distance (in pixels) by which the sub views
	are inset from the border of the receiver."

	^insets ifNil: [Rectangle new]!

insets: aRectangle 
	"Set the <Rectangle> whose edges specify the distance (in pixels) by which the sub views are
	inset from the border of the receiver."

	insets := aRectangle = Rectangle new ifFalse: [aRectangle].
	self invalidateLayout!

itemAtIndex: index
	"Answers the <ToolbarItem> at the specified <integer> index in the receiver"

	^items at: index
 !

itemClass
	"Answer the class of items managed by the receiver."

	^ToolbarItem!

itemFromId: anInteger 
	"Private - Answers the sub-item of the receiver with the specified <integer> item specifier."

	^idMap at: anInteger ifAbsent: []!

itemRect: index
	"Answer the bounding <Rectangle> for the button at 1-based <Integer> index."

	^(self tbGetItemRect: index - 1) asRectangle!

items
	"Private - Answer the receiver's <OrderedCollection> of <ToolbarItem>s.
	Implementation Note: We explicity convert to an OrderedCollection here to make
	the result easier for the published aspect inspector to manipulate."

	^items asOrderedCollection!

items: tools
	"Private - Sets the receiver's collection of <ToolbarItem>s to those in 
	the <collection>, tools."

	items := tools asArray.
	items do: [:each | each toolbar: self ].
	self recreate.!

layoutManager
	"Answer the layout manager for the receiver"

	^layoutManager!

layoutManager: aLayoutManager
	"Set the layout manager for the receiver to aLayoutManager"

	layoutManager := aLayoutManager.
	self basicInvalidateLayout!

nmNotify: pNMHDR 
	"Private - Handler for a WM_NOTIFY message."

	^(TbnMap at: (pNMHDR sdwordAtOffset: 8) ifAbsent: []) 
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

onDropDown: aToolbarButton
	"Private - The receiver's control has sent a notification that a drop-down
	style buttons drop-down arrow has been pressed. Handle in some
	application specific manner, and answer zero if handled."

	self presenter trigger: #dropDown: with: aToolbarButton.
	^TBDDRET_DEFAULT!

onEraseRequired: aColorEvent 
	"Private - Handler for erase background event- erase to the background colour,
	or answer nil if no colour is set to accept the default window processing."

	"Implementation Note: Unlike other common controls there is no mechanism to set a toolbars
	background colour, and they do not send WM_CTLCOLORxxx notifications, therefore we must take
	control of the background erase where a colour has been set and not in one of the
	transparent background modes. Toolbars support a transparent background, but to enable this
	the backcolor must be set to 'Color none' as well as turning on #isTransparent. To get a
	gradient fill, set the foreground colour to the colour at the start of the gradient and the
	background colour to the colour at the end, (both can be set to Color default to get a light grey gradient)."

	| back fore rect canvas |
	back := self basicActualBackcolor.
	back isNone ifTrue: [^true].
	fore := self basicActualForeolor.
	rect := self clientRectangle.
	canvas := aColorEvent canvas.
	fore isNone 
		ifTrue: 
			[^canvas fillRectangle: rect color: (back isDefault ifTrue: [self defaultBackcolor] ifFalse: [back])].
	canvas 
		fillRectangle: rect
		startColor: (fore isDefault ifTrue: [self defaultGradientForecolor] ifFalse: [fore])
		endColor: (back isDefault ifTrue: [self defaultGradientBackcolor] ifFalse: [back])
		verticalGradient: self isVertical not.
	"Prevent the toolbar from destroying the background when it paints if it is not transparent (it draws the buttons transparently, 
	but fills the remaining space in a solid colour unless marked as transparent."
	self isTransparent 
		ifFalse: 
			[canvas 
				excludeClipRectangle: ((self isVertical 
						ifTrue: [rect left @ (rect top + (self calculateExtent: nil) y)]
						ifFalse: [(rect left + (self calculateExtent: nil) x) @ rect top]) corner: rect corner)].
	^true!

onPositionChanged: aPositionEvent 
	"Handle a window position change event (move or resize).
	Implementation Note:  Toolbars (depending on the Common Control Library
	version) do not redraw properly when wrapping so we always invalidate them 
	here."

	aPositionEvent isResize 
		ifTrue: 
			["Dynamically change the receiver's orientation to take best advantage of the available space."
			self isVertical: aPositionEvent height > aPositionEvent width.
			self invalidate].
	^super onPositionChanged: aPositionEvent!

onTipTextRequired: item
	"Text is required for the tool-tip associated with the
	<ToolbarItem>, item."

	^item onTipTextRequired!

onViewCreated
	"The receiver window has been created (but is not yet visible). 
	Finish the job and install the known ToolbarItems"

	super onViewCreated.
	bitmapsStart := LookupTable new.
	self changeButtonSize: [self tbSetBitmapSize: self bitmapSize].
	#todo.	"Store extended style in an inst. var (appear to be some unused?) and provide accessors/mode settings"
	self tbSetExtendedStyle: ##(TBSTYLE_EX_DRAWDDARROWS | TBSTYLE_EX_DOUBLEBUFFER).
	self clearIdMap.
	self basicAddItems: items!

removeAllItems
	"Remove all the receivers buttons."

	items copy do: [ :each | self removeItem: each].
!

removeItem: aToolbarItem
	"Remove aToolbarItem from both the internal collection of
	available buttons and from the associated Windows control. 
	Answer aToolbarItem."

	| index |
	index := self indexOfItem: aToolbarItem.
	items := (items copyFrom: 1 to: index-1), (items copyFrom: index+1).
	aToolbarItem commandId ~= 0 ifTrue: [
		idMap removeKey: aToolbarItem commandId].
	self tbDeleteButton: index.
	^aToolbarItem!

size
	"Answer the number of ToolbarItems in the receiver."

	^self tbButtonCount!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state. The Windows help suggests that the #tbSetBitmapSize: and 
	#tbSetButtonSize messages will only work if sent before the buttons are added to 
	the bar. In fact the exact opposite appears to be the case and hence the reason 
	to include these messages as part of the state rather than using them in the 
	#onCreated handler"

	^super state
		add: (MessageSend receiver: self selector: #updateSizePosted );
		yourself!

tbAddBitmap: struct size: size
	"Private - Adds the images referenced in struct to the receiver.
	Answer the index of the first element, or -1 if the call failed."

	^self
		sendMessage: TB_ADDBITMAP
		wParam: size
		lpParam: struct asParameter!

tbAddButtons: tbButtons
	"Private - Adds a StructureArray of tbButtons to the receiver."

	| index |
	index := self sendMessage: TB_ADDBUTTONS wParam: tbButtons size lpParam: tbButtons asParameter.
	^index == 0
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [index]!

tbAddString: aString
	"Private - Add aString to the receiver. Answer the index of the new string."

	| buffer index |

	buffer := aString copyWith: $\0.	"Last string must have extra null"
	^(index := self sendMessage: TB_ADDSTRING wParam: 0 lpParam: buffer) == -1
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [index]!

tbAutoSize
	"Private - Cause the receiver to be resized."

	self sendMessage: TB_AUTOSIZE!

tbButtonCount
	"Private - Answer number of buttons in the toolbar."

	^self sendMessage: TB_BUTTONCOUNT!

tbButtonStructSize
	"Private - Specifies the size of the TBBUTTON structure."

	self sendMessage: TB_BUTTONSTRUCTSIZE wParam: TBBUTTON byteSize!

tbCheckButton: anIntegerId state: checkBoolean
	"Private - Set whether the button with anIntegerId is checked or not.
	See the note in #tbEnableButton:state: regarding the deliberate lack of error checking"

	self sendMessage: TB_CHECKBUTTON wParam: anIntegerId lParam: checkBoolean asParameter!

tbCustomize
	"Private - Show the toolbar customize dialog box."

	self sendMessage: TB_CUSTOMIZE!

tbDeleteButton: anInteger
	"Private - Delete the button with anInteger index from the receiver."

	(self sendMessage: TB_DELETEBUTTON wParam: anInteger - 1 lParam: 0) == 0
		ifTrue: [^self errorInCommonControlCall]!

tbEnableButton: anIntegerId state: enableBoolean
	"Private - Set whether the button with anIntegerId is enabled or not.

	Note: Unusually we don't generate an #errorInCommonControlCall if this fails.
	This is to prevent a walkback appearing in the idle processing of #validUserInterface
	when enabling/disabling toolbar buttons while a view is being closed. The problem only
	occurs when a view is closed by a process other than the user interface process 
	(e.g the Debugger). Unfotunately it is not just possible to test the toolbar with #isOpen 
	because it reports that it still is. I suspect that although the toolbar is still open - the 
	buttons are not"

	(self sendMessage: TB_ENABLEBUTTON wParam: anIntegerId lParam: enableBoolean asParameter) == 0
		ifTrue: [self errorInCommonControlCall]!

tbGetButton: anInteger
	"Private - Answer a TBBUTTON describing the button with anInteger index in the receiver."

	| tbButton |
	tbButton := TBBUTTON new.
	^(self sendMessage: TB_GETBUTTON wParam: anInteger-1 lpParam: tbButton asParameter) == 0
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [tbButton]
!

tbGetButtonInfo: iID tbbi: binfo
	"Private - Populate the <TBBUTTONINFO>, binfo,  argument with information about the 
	item in receiver with <integer> command id, iID. Answers the index of the button
	or raises an exception if an error occured."

	| i |
	^(i := self sendMessage: TB_GETBUTTONINFO wParam: iID lpParam: binfo) == -1
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [i]!

tbGetIdealHeight
	"Private - Answer the ideal height for the receiver."

	| size |
	size := POINTL new.
	self 
		sendMessage: TB_GETIDEALSIZE
		wParam: true asParameter
		lpParam: size.
	^size y!

tbGetIdealWidth
	"Private - Answer the ideal width for the receiver."

	| size |
	size := POINTL new.
	self 
		sendMessage: TB_GETIDEALSIZE
		wParam: false asParameter
		lpParam: size.
	^size x!

tbGetItemRect: anInteger
	"Private - Answer the bounding RECT for the receiver's button with the zero-based
	<Integer> index."

	| rect |
	rect := RECT new.
	(self sendMessage: TB_GETITEMRECT wParam: anInteger lpParam: rect) == 0
		ifTrue: [^self errorInCommonControlCall].
	^rect!

tbGetMaxSize
	"Private - Answer the maximum extent for the receiver."

	| size |
	size := POINTL new.
	self sendMessage: TB_GETMAXSIZE wParam: 0 lpParam: size.
	^size asPoint
!

tbGetPadding
	"Private - Answer the padding between buttons of the the receiver."

	| pad |
	pad := self sendMessage: TB_GETPADDING.
	^pad lowWord @ pad highWord
!

tbGetRect: id
	"Private - Answer the bounding RECT for the receiver's button with the specified
	<Integer> command id."

	| rect |
	rect := RECT new.
	(self sendMessage: TB_GETRECT wParam: id lpParam: rect) == 0
		ifTrue: [^self errorInCommonControlCall].
	^rect!

tbGetRows
	"Private - Answer the number of rows of buttons. The toolbar must have the TBSTYLE_WRAPABLE
	style (the default in Dolphin) to generate more than one row."

	^self sendMessage: TB_GETROWS!

tbGetState: anIntegerId
	"Private - Answer the state information for button with anIntegerId."

	| state |
	^(state := self sendMessage: TB_GETSTATE wParam: anIntegerId) == -1
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [state]!

tbGetToolTips
	"Private - Answer the handle of the receiver's tooltip control, or NULL if
	there is not one."

	^(self sendMessage: TB_GETTOOLTIPS) asExternalHandle!

tbHideButton: anIntegerId state: hideBoolean
	"Private - Set whether the button with anIntegerId is shown or hidden on the toolbar."

	(self sendMessage: TB_HIDEBUTTON wParam: anIntegerId lParam: hideBoolean asParameter) == 0
		ifTrue: [self errorInCommonControlCall]!

tbIndeterminate: anIntegerId state: indeterminateBoolean
	"Private - Set whether the button with anIntegerId is in it's indeterminate state."

	(self sendMessage: TB_INDETERMINATE wParam: anIntegerId lParam: indeterminateBoolean asParameter) == 0
		ifTrue: [^self errorInCommonControlCall]!

tbIsButtonChecked: anIntegerId
	"Private - Answer whether the button with anIntegerId is checked."

	^(self sendMessage: TB_ISBUTTONCHECKED wParam: anIntegerId) asBoolean!

tbIsButtonEnabled: anIntegerId
	"Private - Answer whether the button with anIntegerId is enabled."

	^(self sendMessage: TB_ISBUTTONENABLED wParam: anIntegerId) asBoolean!

tbIsButtonHidden: anIntegerId
	"Private - Answer whether the button with anIntegerId is hidden."

	^(self sendMessage: TB_ISBUTTONHIDDEN wParam: anIntegerId) asBoolean!

tbIsButtonIndeterminate: anIntegerId
	"Private - Answer whether the button with anIntegerId is in it's indeterminate state."

	^(self sendMessage: TB_ISBUTTONINDETERMINATE wParam: anIntegerId) asBoolean!

tbIsButtonPressed: anIntegerId
	"Private - Answer whether the button with anIntegerId is pressed."

	^(self sendMessage: TB_ISBUTTONPRESSED wParam: anIntegerId) asBoolean!

tbnBeginAdjust: pNMHDR
	"Private - Default handler for the TBN_BEGINADJUST notification message.
	Answer nil to accept the default processing."

	^nil!

tbnBeginDrag: pNMHDR
	"Private - Default handler for the TBN_BEGINDRAG notification message.
	Answer nil to accept the default processing.
	The NMHDR is actually a TBNOTIFY (i.e. TBNOTIFY fromAddress: anNMHDR yourAddress)."

	^nil!

tbnCloseUp: pNMHDR
	"Private - Default handler for the TBN_CLOSEUP notification message.
	Answer nil to accept the default processing."

	^nil!

tbnCustHelp: pNMHDR
	"Private - Default handler for the TBN_CUSTHELP notification message.
	Answer nil to accept the default processing."

	^nil!

tbnDropDown: pNMHDR 
	"Private - Default handler for the TBN_DROPDOWN notification message.
	Forward on a #onDropDown: event to the presenter."

	| nmtb id |
	nmtb := NMTOOLBAR fromAddress: pNMHDR.
	id := nmtb iItem.
	^(self itemFromId: id) 
		ifNil: [TBDDRET_DEFAULT]
		ifNotNil: [:button | self presenter onDropDown: button]!

tbnEndAdjust: pNMHDR
	"Private - Default handler for the TBN_ENDADJUST notification message.
	Answer nil to accept the default processing."

	^nil!

tbnEndDrag: pNMHDR
	"Private - Default handler for the TBN_ENDDRAG notification message.
	Answer nil to accept the default processing.
	The NMHDR is actually a TBNOTIFY (i.e. TBNOTIFY fromAddress: pNMHDR)."

	^nil!

tbnGetButtonInfo: pNMHDR
	"Private - Default handler for the TBN_GETBUTTONINFO notification message.
	The NMHDR is actually a TBNOTIFY (i.e. TBNOTIFY fromAddress: pNMHDR)."

	^false!

tbnQueryDelete: pNMHDR
	"Private - Default handler for the TBN_QUERYDELETE notification message.
	The NMHDR is actually a TBNOTIFY (i.e. TBNOTIFY fromAddress: pNMHDR)."

	^true!

tbnQueryInsert: pNMHDR
	"Private - Default handler for the TBN_QUERYINSERT notification message.
	The NMHDR is actually a TBNOTIFY (i.e. TBNOTIFY fromAddress: pNMHDR)."

	^true!

tbnReset: pNMHDR
	"Private - Default handler for the TBN_RESET notification message.
	Answer nil to accept the default processing."

	^nil!

tbnToolbarChange: pNMHDR
	"Private - Default handler for the TBN_TOOLBARCHANGE notification message."

	self tbAutoSize!

tbPressButton: anIntegerId state: pressBoolean
	"Private - Press or release the button withanIntegerId."

	(self sendMessage: TB_PRESSBUTTON 	wParam: anIntegerId lParam: pressBoolean asParameter) == 0
		ifTrue: [^self errorInCommonControlCall]!

tbSetBitmapSize: aPoint 
	"Private - Set the size of the bitmapped images for the receiver
	to aPoint. Must be sent before any items are added."

	(self 
		sendMessage: TB_SETBITMAPSIZE
		wParam: 0
		lParam: aPoint asUIntPtr) == 0 
		ifTrue: [^self errorInCommonControlCall]!

tbSetButtonSize: aPoint 
	"Private - Set the size of the receiver's items to be aPoint.
	Must be sent before any items are added"

	(self 
		sendMessage: TB_SETBUTTONSIZE
		wParam: 0
		lParam: aPoint asUIntPtr) == 0 
		ifTrue: [^self errorInCommonControlCall]!

tbSetCmdID: anInteger id: anIntegerId
	"Private - Set the command id for the button with anInteger index to be anIntegerId."

	(self sendMessage: TB_SETCMDID wParam: anInteger - 1 lParam: anIntegerId) == 0
		ifTrue: [^self errorInCommonControlCall]!

tbSetExtendedStyle: tbExStyleMask
	"Private - Set the extended toolbar styles of the receiver to the <Integer>
	argument, tbExStyleMask."

	^self sendMessage: TB_SETEXTENDEDSTYLE
		wParam: 0
		lParam: tbExStyleMask
!

tbSetRows: anIntegerRows large: largerBoolean
	"Private - Set the number of rows in the receiver to anInteger. If largerBoolean is
	true then more rows will be created if there is not enough horizontal width to
	hold the necessary items. 
	Answer a Rectangle marking the new boundary of the receiver."

	| rect |
	rect := RECT new.
	self sendMessage: TB_SETROWS
		wParam: (anIntegerRows bitOr: (largerBoolean asParameter << 16))
		lpParam: rect.
	^rect asRectangle!

tbSetState: id state: stateMask
	"Private - Set the TBSTATE_XXX flags of the button in the receiver with the specified <integer> 
	id, to the set of flags in the <integer> stateMask. We don't really care if it succeeds or not."

	^self 
		sendMessage: TB_SETSTATE 
		wParam: id 
		lParam: stateMask!

tbSetToolTips: toolTipHandle
	"Private - Set the handle of the receivers tooltip control to toolTipHandle."

	self sendMessage: TB_SETTOOLTIPS wParam: toolTipHandle!

ttnGetDispInfo: anNMTTDISPINFO 
	"Private - Generic handler for the TTN_NEEDTEXT(A/W) notification message."

	^(anNMTTDISPINFO idIsHandle 
		ifTrue: [View withHandle: anNMTTDISPINFO idFrom]
		ifFalse: [self itemFromId: anNMTTDISPINFO idFrom]) 
			ifNotNil: 
				[:tool | 
				"Note that we must keep a reference to the text string to prevent its premature death"
				tipText := anNMTTDISPINFO text: (self presenter onTipTextRequired: tool).
				0]!

updateAllItems
	"Private - Cause all of the receivers items to be rebuilt"

	| existingItems |
	existingItems := items copy.
	self removeAllItems.
	self addItems: existingItems; updateSize!

updateSize
	"Private - Update the toolbar button and bitmap sizes."

	self isOpen ifFalse: [^self].
	self changeButtonSize: 
			[self buttonSize notNil ifTrue: [self tbSetButtonSize: self buttonSize].
			self tbSetBitmapSize: self bitmapSize].
	self tbAutoSize!

updateSizePosted
	[self updateSize] postToInputQueue!

validateUserInterface
	"Set the state of the receiver accordingly. Determine the enable state of all the
	toolbar buttons."

	| route |
	route := self presenter commandPolicy.
	items do: [:each | each validateUserInterface: route].
	"Workaround a bug in the control - it keeps wanting to display itself horizontally unless we
	remind it to recalculate its size regularly. There may be a better way to do this, but this
	works in lieu"
	self isVertical ifTrue: [self tbAutoSize].
	super validateUserInterface!

wmCreate: message wParam: wParam lParam: lParam
	"Private - As we create the receiver with the standard CreateWindowEx call we have
	to inform Windows of the size of TBBUTTON struct that we are using before
	we can add any buttons."

	self	tbButtonStructSize.
	^super wmCreate: message wParam: wParam lParam: lParam
!

wmNotify: message wParam: wParam lParam: lParam
	"Private - Redirects WM_NOTIFY messages to the appropriate control as a notify message.
	Overridden here to handle notifications from the receiver's tool tip control which 
	does not itself have an associated View so cannot receive the redirected message.
	In any case it is more convenient to direct the notification to the receiver's
	#ttnNeedText: handler."

	| pnmhdr code |
	pnmhdr := lParam asExternalAddress.
	code := pnmhdr sdwordAtOffset: 8.
	(code == TTN_GETDISPINFOW or: [code == TTN_GETDISPINFOW]) ifTrue: [^self nmNotify: pnmhdr].
	^super wmNotify: message wParam: wParam lParam: lParam! !
!Toolbar categoriesFor: #addBitmap:index:!helpers!private! !
!Toolbar categoriesFor: #addEditTools!adding!private! !
!Toolbar categoriesFor: #addFileTools!adding!private! !
!Toolbar categoriesFor: #addFindTools!adding!private! !
!Toolbar categoriesFor: #addItem:!adding!public! !
!Toolbar categoriesFor: #addItems:!adding!public! !
!Toolbar categoriesFor: #addSeparator!adding!public! !
!Toolbar categoriesFor: #addString:!helpers!private! !
!Toolbar categoriesFor: #addSystemBitmap:index:!helpers!private! !
!Toolbar categoriesFor: #basicActualForeolor!private! !
!Toolbar categoriesFor: #basicAddItems:!adding!private! !
!Toolbar categoriesFor: #bitmapSize!geometry!public! !
!Toolbar categoriesFor: #bitmapSize:!geometry!public! !
!Toolbar categoriesFor: #buttonSize!geometry!public! !
!Toolbar categoriesFor: #buttonSize:!geometry!public! !
!Toolbar categoriesFor: #calcButtonWidths!helpers!private! !
!Toolbar categoriesFor: #calculateExtent:!geometry!private! !
!Toolbar categoriesFor: #canCustomize!accessing-styles!public! !
!Toolbar categoriesFor: #canCustomize:!accessing-styles!public! !
!Toolbar categoriesFor: #changeButtonSize:!helpers!private! !
!Toolbar categoriesFor: #clearIdMap!initializing!private! !
!Toolbar categoriesFor: #command:id:!commands!private! !
!Toolbar categoriesFor: #commandSource!commands!public! !
!Toolbar categoriesFor: #defaultBitmapSize!constants!private! !
!Toolbar categoriesFor: #defaultButtonSize!constants!private! !
!Toolbar categoriesFor: #defaultExtent!constants!private! !
!Toolbar categoriesFor: #defaultGradientBackcolor!colors!constants!private! !
!Toolbar categoriesFor: #defaultGradientForecolor!colors!constants!private! !
!Toolbar categoriesFor: #defaultWindowStyle!constants!private! !
!Toolbar categoriesFor: #fontChanged!private!updating! !
!Toolbar categoriesFor: #getLabelExtent:!public! !
!Toolbar categoriesFor: #hasFlatAppearance!accessing-styles!public! !
!Toolbar categoriesFor: #hasFlatAppearance:!accessing-styles!public! !
!Toolbar categoriesFor: #hasLabels!accessing-styles!public! !
!Toolbar categoriesFor: #hasLabels:!accessing-styles!public! !
!Toolbar categoriesFor: #hasListAppearance!accessing-styles!public! !
!Toolbar categoriesFor: #hasListAppearance:!accessing-styles!public! !
!Toolbar categoriesFor: #hasTransparentAppearance:!accessing-styles!public! !
!Toolbar categoriesFor: #hasTransparentBackground!accessing-styles!private! !
!Toolbar categoriesFor: #indexOfItem:!accessing!private! !
!Toolbar categoriesFor: #initialize!initializing!private! !
!Toolbar categoriesFor: #insets!accessing!public! !
!Toolbar categoriesFor: #insets:!accessing!public! !
!Toolbar categoriesFor: #itemAtIndex:!accessing!public! !
!Toolbar categoriesFor: #itemClass!constants!public! !
!Toolbar categoriesFor: #itemFromId:!accessing!private! !
!Toolbar categoriesFor: #itemRect:!geometry!public! !
!Toolbar categoriesFor: #items!accessing!private! !
!Toolbar categoriesFor: #items:!accessing!private! !
!Toolbar categoriesFor: #layoutManager!geometry!public! !
!Toolbar categoriesFor: #layoutManager:!geometry!public! !
!Toolbar categoriesFor: #nmNotify:!event handling-win32!private! !
!Toolbar categoriesFor: #onDropDown:!event handling!private! !
!Toolbar categoriesFor: #onEraseRequired:!private! !
!Toolbar categoriesFor: #onPositionChanged:!event handling!public! !
!Toolbar categoriesFor: #onTipTextRequired:!event handling!public! !
!Toolbar categoriesFor: #onViewCreated!event handling!public! !
!Toolbar categoriesFor: #removeAllItems!public!removing! !
!Toolbar categoriesFor: #removeItem:!public!removing! !
!Toolbar categoriesFor: #size!geometry!public! !
!Toolbar categoriesFor: #state!accessing!private! !
!Toolbar categoriesFor: #tbAddBitmap:size:!helpers!private! !
!Toolbar categoriesFor: #tbAddButtons:!helpers!private! !
!Toolbar categoriesFor: #tbAddString:!adding!private! !
!Toolbar categoriesFor: #tbAutoSize!operations!private! !
!Toolbar categoriesFor: #tbButtonCount!geometry!private! !
!Toolbar categoriesFor: #tbButtonStructSize!accessing!private! !
!Toolbar categoriesFor: #tbCheckButton:state:!operations!private! !
!Toolbar categoriesFor: #tbCustomize!operations!private! !
!Toolbar categoriesFor: #tbDeleteButton:!helpers!private! !
!Toolbar categoriesFor: #tbEnableButton:state:!operations!private! !
!Toolbar categoriesFor: #tbGetButton:!accessing!private! !
!Toolbar categoriesFor: #tbGetButtonInfo:tbbi:!accessing!private! !
!Toolbar categoriesFor: #tbGetIdealHeight!geometry!private! !
!Toolbar categoriesFor: #tbGetIdealWidth!geometry!private! !
!Toolbar categoriesFor: #tbGetItemRect:!geometry!private! !
!Toolbar categoriesFor: #tbGetMaxSize!geometry!private! !
!Toolbar categoriesFor: #tbGetPadding!geometry!private! !
!Toolbar categoriesFor: #tbGetRect:!geometry!private! !
!Toolbar categoriesFor: #tbGetRows!geometry!private! !
!Toolbar categoriesFor: #tbGetState:!accessing!private! !
!Toolbar categoriesFor: #tbGetToolTips!accessing!private! !
!Toolbar categoriesFor: #tbHideButton:state:!operations!private! !
!Toolbar categoriesFor: #tbIndeterminate:state:!operations!private! !
!Toolbar categoriesFor: #tbIsButtonChecked:!private!testing! !
!Toolbar categoriesFor: #tbIsButtonEnabled:!private!testing! !
!Toolbar categoriesFor: #tbIsButtonHidden:!private!testing! !
!Toolbar categoriesFor: #tbIsButtonIndeterminate:!private!testing! !
!Toolbar categoriesFor: #tbIsButtonPressed:!private!testing! !
!Toolbar categoriesFor: #tbnBeginAdjust:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnBeginDrag:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnCloseUp:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnCustHelp:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnDropDown:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnEndAdjust:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnEndDrag:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnGetButtonInfo:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnQueryDelete:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnQueryInsert:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnReset:!event handling-win32!private! !
!Toolbar categoriesFor: #tbnToolbarChange:!event handling-win32!private! !
!Toolbar categoriesFor: #tbPressButton:state:!operations!private! !
!Toolbar categoriesFor: #tbSetBitmapSize:!geometry!private! !
!Toolbar categoriesFor: #tbSetButtonSize:!geometry!private! !
!Toolbar categoriesFor: #tbSetCmdID:id:!commands!private! !
!Toolbar categoriesFor: #tbSetExtendedStyle:!helpers!private! !
!Toolbar categoriesFor: #tbSetRows:large:!geometry!private! !
!Toolbar categoriesFor: #tbSetState:state:!helpers!private! !
!Toolbar categoriesFor: #tbSetToolTips:!accessing!private! !
!Toolbar categoriesFor: #ttnGetDispInfo:!event handling-win32!private! !
!Toolbar categoriesFor: #updateAllItems!operations!private! !
!Toolbar categoriesFor: #updateSize!operations!private! !
!Toolbar categoriesFor: #updateSizePosted!operations!private! !
!Toolbar categoriesFor: #validateUserInterface!operations!public! !
!Toolbar categoriesFor: #wmCreate:wParam:lParam:!event handling-win32!private! !
!Toolbar categoriesFor: #wmNotify:wParam:lParam:!event handling-win32!private! !

!Toolbar class methodsFor!

initialize
	"Private - Initialise the receiver's class variables.
		Toolbar initialize
	"

	self initializeNotificationMap.
	LabelsMask := 1!

initializeNotificationMap
	"Private - Initialise the map of Toolbar notification codes to selector/parameter-class pairs.
	N.B. Must not be stripped in order to preserve notification handlers."

	TbnMap := (IdentityDictionary new: 14)			
			at: TBN_GETBUTTONINFOA	put: #tbnGetButtonInfo:;
			at: TBN_BEGINDRAG			put: #tbnBeginDrag:;
			at: TBN_ENDDRAG				put: #tbnEndDrag:;
			at: TBN_BEGINADJUST			put: #tbnBeginAdjust:;	
			at: TBN_ENDADJUST			put: #tbnEndAdjust:;
			at: TBN_RESET				put: #tbnReset:;
			at: TBN_QUERYINSERT			put: #tbnQueryInsert:;
			at: TBN_QUERYDELETE			put: #tbnQueryDelete:;
			at: TBN_TOOLBARCHANGE	put: #tbnToolbarChange:;
			at: TBN_CUSTHELP			put: #tbnCustHelp:;
			at: TBN_DROPDOWN			put: #tbnDropDown:;
			at: TBN_CLOSEUP				put: #tbnCloseUp:;
			shrink;
			yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1140851468 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 498 528 8 4294906599 0 234 256 98 0 98 0 234 240 592 0 1 0 328198 ##(Smalltalk.Point)  33 31 642 45 45 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 642 1 1 642 701 51 416 754 8 #updateSize 592 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 25 0 0 0] 98 0 642 193 193 0 27 )!

resource_Edit_tools
	"Answer the literal data from which the 'Edit tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Edit_tools)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1409289036 131137 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 498 528 8 4294903595 234 256 98 0 234 256 98 10 56769 853766 ##(Smalltalk.ToolbarButton)  56769 0 416 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #cutSelection 8 'Cut' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'EditBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 7 328198 ##(Smalltalk.Point)  193 33 1 56771 642 56771 0 416 1 674 8 #copySelection 8 'Copy' 1 1 0 752 3 56773 642 56773 0 416 1 674 8 #pasteClipboard 8 'Paste' 1 1 0 752 5 56775 642 56775 0 416 1 674 8 #clearSelection 8 'Delete' 1 1 0 752 11 56777 642 56777 0 416 1 674 8 #undo 8 'Undo' 1 1 0 752 7 98 6 656 896 960 1024 1088 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 416 3 0 1 234 240 98 2 752 1 0 1 0 866 33 33 866 45 45 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 866 2799 21 866 241 51 416 1330 8 #updateSize 592 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 239 5 0 0 35 0 0 0] 98 0 866 193 193 0 27 )!

resource_File_tools
	"Answer the literal data from which the 'File tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_File_tools)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1409289036 131137 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 498 528 8 4294903595 234 256 98 0 234 256 98 6 57467 1115910 ##(Smalltalk.ToolbarIconButton)  57467 0 416 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #fileNew 8 'New' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'DocumentShell.ico' 0 395334 3 ##(Smalltalk.Bitmap)  0 16 0 0 0 0 3 328198 ##(Smalltalk.Point)  33 33 1 57469 642 57469 0 416 1 674 8 #fileOpen 8 'Open' 1 1 738 0 16 784 8 'FileOpen.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 818 0 16 0 0 0 0 3 850 33 33 1 57471 642 57471 0 416 1 674 8 #fileSave 8 'Save' 1 1 738 0 16 784 8 'FileSave.ico' 992 818 0 16 0 0 0 0 3 850 33 33 1 98 4 656 880 1056 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 416 3 0 1 234 240 98 6 1152 5 832 1 1024 3 0 1 0 850 33 33 850 45 45 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 850 2799 21 850 151 51 416 1362 8 #updateSize 592 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 194 5 0 0 35 0 0 0] 98 0 850 193 193 0 27 )!

resource_Find_tools
	"Answer the literal data from which the 'Find tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Find_tools)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1409289036 131137 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 498 528 8 4294903595 234 256 98 0 234 256 98 4 57829 853766 ##(Smalltalk.ToolbarButton)  57829 0 416 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #findNext 8 'Find Next' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FindBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 7 328198 ##(Smalltalk.Point)  65 33 3 57827 642 57827 0 416 1 674 8 #find 8 'Find' 1 1 0 752 1 98 3 896 656 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 416 3 0 1 234 240 98 2 752 1 0 1 0 866 33 33 866 45 45 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 866 2799 21 866 111 51 416 1138 8 #updateSize 592 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 174 5 0 0 35 0 0 0] 98 0 866 193 193 0 27 )!

resource_History_tools
	"Answer the literal data from which the 'History tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_History_tools)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1409289036 131137 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 517 0 0 0 416 498 528 8 4294903595 234 256 98 0 234 256 98 4 58159 1115910 ##(Smalltalk.ToolbarIconButton)  58159 0 416 17 1180998 4 ##(Smalltalk.CommandDescription)  459270 ##(Smalltalk.Message)  8 #historyBack 98 0 8 'Back' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'HistoryBack.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 395334 3 ##(Smalltalk.Bitmap)  0 16 0 0 0 0 3 328198 ##(Smalltalk.Point)  33 33 1 58161 642 58161 0 416 17 674 706 8 #historyForward 98 0 8 'Forward' 1 1 786 0 16 832 8 'HistoryForward.ico' 880 914 0 16 0 0 0 0 3 946 33 33 1 98 3 656 976 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 416 3 0 1 234 240 98 4 928 1 1104 3 0 1 0 946 33 33 946 45 45 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 946 2799 21 946 201 51 416 1314 8 #updateSize 592 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 219 5 0 0 35 0 0 0] 98 0 946 193 193 0 27 )!

resource_List_tools
	"Answer the literal data from which the 'List tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_List_tools)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1409288972 131137 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 517 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 498 528 8 4294903595 234 256 98 0 234 256 98 12 59841 853766 ##(Smalltalk.ToolbarButton)  59841 0 416 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #moveFirst 8 'Move First' 1 1 0 395334 3 ##(Smalltalk.Bitmap)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'ListBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 7 626 161 33 5 59843 754 59843 0 416 1 786 8 #moveUp 8 'Move Up' 1 1 0 864 1 59845 754 59845 0 416 1 786 8 #moveDown 8 'Move Down' 1 1 0 864 3 59847 754 59847 0 416 1 786 8 #moveLast 8 'Move Last' 1 1 0 864 7 59837 754 59837 0 416 1 786 8 #addItem 8 'New Item' 1 1 0 864 9 59839 754 59839 0 416 1 786 8 #removeItem 8 'Delete Item' 1 1 0 850 0 16 896 8 'EditBar.bmp' 944 0 7 626 193 33 11 98 8 1184 1248 1050118 ##(Smalltalk.ToolbarSeparator)  0 0 416 3 0 1 768 992 1056 1120 1378 0 0 416 3 0 1 234 240 98 4 864 1 1312 11 0 1 0 626 33 33 626 45 45 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 626 2799 21 626 311 51 416 1554 8 #updateSize 704 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 18 6 0 0 35 0 0 0] 98 0 626 193 193 0 27 )!

resource_Tool_bar
	"Answer the literal data from which the 'Tool bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tool_bar)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1409288972 131137 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 517 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 498 528 8 4294903295 234 256 98 0 234 256 704 202 208 704 234 240 704 0 1 0 626 33 33 626 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 626 2799 21 626 701 51 416 898 8 #updateSize 704 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 35 0 0 0] 98 0 626 193 193 0 27 )!

stbConvertFromVersion12: anArray 
	"Private - Perform an STB conversion from a version 12 <View> to version 13."

	| creationStyle |
	anArray at: 20 put: ((anArray at: 20) ifTrue: [LabelsMask] ifFalse: [0]).
	creationStyle := anArray at: 3.
	"creationStyle at: 1 put: ((creationStyle at: 1) bitOr: TBSTYLE_WRAPABLE)."
	"The common idiom of embedding subsidiary toolsbars in a parent toolbar requires that the
	embedded toolbars be marked as transparent, or they will always paint a face3d background."
	creationStyle at: 2 put: ((creationStyle at: 2) bitOr: WS_EX_TRANSPARENT).
	anArray at: 13 put: Color default.
	(anArray at: 6) = Color face3d ifTrue: [anArray at: 6 put: Color default].
	^super stbConvertFromVersion12: anArray!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'ToolbarWindow32'
! !
!Toolbar class categoriesFor: #initialize!initializing!private! !
!Toolbar class categoriesFor: #initializeNotificationMap!initializing!must not strip!private! !
!Toolbar class categoriesFor: #resource_Default_view!public!resources-views! !
!Toolbar class categoriesFor: #resource_Edit_tools!public!resources-views! !
!Toolbar class categoriesFor: #resource_File_tools!public!resources-views! !
!Toolbar class categoriesFor: #resource_Find_tools!public!resources-views! !
!Toolbar class categoriesFor: #resource_History_tools!public!resources-views! !
!Toolbar class categoriesFor: #resource_List_tools!public!resources-views! !
!Toolbar class categoriesFor: #resource_Tool_bar!public!resources-views! !
!Toolbar class categoriesFor: #stbConvertFromVersion12:!binary filing!private! !
!Toolbar class categoriesFor: #winClassName!constants!private! !

