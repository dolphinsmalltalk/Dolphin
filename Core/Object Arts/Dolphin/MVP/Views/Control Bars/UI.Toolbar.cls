"Filed out from Dolphin Smalltalk 7"!

UI.ControlBarAbstract subclass: #'UI.Toolbar'
	instanceVariableNames: 'idMap items bitmapsStart insets tbFlags indent bitmapSize buttonSize tipText layoutManager'
	classVariableNames: ''
	imports: #(#{OS.ToolbarConstants})
	classInstanceVariableNames: ''
	classConstants: {
		'LabelsMask' -> 16r1
	}!
UI.Toolbar guid: (Core.GUID fromString: '{87b4c72f-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Toolbar comment: '`Toolbar` is a `<compositeView>` implementing the Windows _ToolbarWindow32_ common control.

Toolbar holds a list of `<ToolbarItem>` items matching the order of items in the control. Items may be added and deleted once the view has been created.  It also allows a name to be associated with each item. 

## Instance Variables:
  `idMap`			`IdentityDictionary` mapping item IDs to `ToolbarItem`s
  `items`			`Array` of `ToolbarItem`s held by the toolbar.
  `bitmapsStart`		`LookupTable` of IDs for system bitmaps.
  `insets`			`Rectangle` specifying insets from edges for nested controls.
  `tbFlags`			`<integer>` toolbar specific flags.
  `_reserved2`		`UndefinedObject` reserved for future use.
  `bitmapSize`		`Point` size of each button bitmap.
  `buttonSize`		`Point` size of each button.
  `tipText`			`<readableString>` or `nil`, tip text for last button hover.
  `layoutManager`	`<layoutManager>` or `nil`, for managing the layout of sub-views.

## Class Variables:
  `LabelsMask`		`<integer>` mask for `hasLabels` flag.
  `TbnMap`		`IdentityDictionary` mapping Windows messages to `<selector>`s.


'!
!UI.Toolbar categoriesForClass!MVP-Views! !
!UI.Toolbar methodsFor!

actualBitmapSize
	"Answer the size of bitmaps shown on the toolbar. This can be visually inherited from a
	parent toolbar, which is useful in allowing the bitmap size to be changed just by changing
	that of the topmost toolbar."

	^bitmapSize
		ifNil: 
			[| visibleParent |
			"If nested in a Toolbar, inherit its bitmap size"
			visibleParent := self parentView nonReferenceAncestor.
			visibleParent class == self class
				ifTrue: [visibleParent actualBitmapSize]
				ifFalse: [self defaultBitmapSize]]!

addBitmap: aBitmap index: anIntegerIndex
	"Private - Add the sub-bitmap identified by anIntegerIndex within aBitmap
	to the receiver. Answer the index of the sub-bitmap within the registered
	entries"

	| start |
	start := bitmapsStart at: aBitmap
				ifAbsentPutClean: 
					[| gdiBitmap size |
					gdiBitmap := aBitmap asBitmap.
					gdiBitmap setMap3DColors: true.
					"If the extent reported by the bitmap is not correct, then the start index will be out,
					 so watch out for caching duff old extent (see Bitmap>>loadFromInstance)."
					size := gdiBitmap extent x // self actualBitmapSize x.

					"#305 We must make sure that the bitmap is not selected into a DC or the result will
					be a blank image in the list. This won't damage the bitmap in any way because the canvas
			`		can always be lazily recreated."
					gdiBitmap freeDC.
					self tbAddBitmap: (TBADDBITMAP newBuffer
								nID: gdiBitmap asParameter;
								yourself)
						size: size].
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
	^self basicAddItems: {tool}!

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
				ifAbsentPutClean: 
					[| addBitmap |
					(addBitmap := TBADDBITMAP newBuffer)
						hInst: HINST_COMMCTRL;
						nID: systemBitmapId.
					self tbAddBitmap: addBitmap size: 0].
	^start + anIntegerIndex!

basicActualForecolor
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

	| buttons hasLabels |
	tools isEmpty ifTrue: [^tools	"It is an error to set zero buttons on IE5/NT5"].
	hasLabels := self hasLabels.
	buttons := StructureArray
				withAll: tools
				elementClass: TBBUTTON
				initializer: 
					[:tbButton :toolbarItem |
					| cmd |
					cmd := toolbarItem getCommandId.
					cmd == 0 ifFalse: [idMap at: cmd put: toolbarItem].
					tbButton
						iBitmap: (toolbarItem imageIndexIn: self);
						idCommand: cmd;
						fsState: TB_STATEENABLED;
						fsStyle: toolbarItem style;
						iString: (hasLabels ifTrue: [toolbarItem textIndexIn: self] ifFalse: [-1])].
	buttons beUnfinalizable.	"Nothing to free here"
	self tbAddButtons: buttons.
	^tools!

bitmapSize
	"Answer the size of bitmaps shown on the toolbar"

	^bitmapSize!

bitmapSize: aPoint
	"Set the size of bitmaps shown on the toolbar to aPoint"

	bitmapSize = aPoint ifTrue: [^self].
	bitmapSize := aPoint.
	buttonSize
		ifNil: 
			["The Toolbar has a bug whereby it doesn't update its metrics correctly if
			the bitmap size is changed - the default button size is generally too large,
			especially if switching to a smaller size. Therefore we recreate the control."
			self recreate]
		ifNotNil: [self updateAllItems]!

buttonSize
	"Answer the size of buttons shown on the toolbar"

	^buttonSize ifNil: [self isOpen ifTrue: [self tbGetButtonSize]]!

buttonSize: aPointOrNil
	"Set the size of buttons shown on the toolbar to aPointOrNil. If nil then the buttons assume
	a default size, which is the preferred option for normal use."

	buttonSize = aPointOrNil ifTrue: [^self].
	buttonSize := aPointOrNil.
	self updateAllItems.!

calculateExtent: aLayoutContext
	"Private - Answer an extent for the receiver within the specified <LayoutContext>."

	"Implementation Note: Any suggested or existing extent is ignored. We calculate the extent
	required to draw all the buttons, etc, in the toolbar."

	| size |
	size := self tbGetMaxSize.
	"We need to workaround some Windows bugs: TB_GETMAXSIZE treats the height of a separator as
	being the full bar height, regardless of whether horizontal or vertical. Another bug is it
	not correctly allowing for the true width of drop down tool buttons. Since XP the bug has
	only applied in vertical mode and we no longer support Windows versions earlier than Vista."
	self isVertical
		ifTrue: 
			[| buttonWidth |
			buttonWidth := self buttonSize x.
			items do: 
					[:each |
					each isDivider ifTrue: [size y: size y - buttonWidth].
					each isDropdownStyle
						ifTrue: 
							[size x: size x + (each isDropDownOnly ifTrue: [buttonWidth // 3] ifFalse: [buttonWidth * 3 // 4])]]].
	"The max size calculation does not include any indent."
	size x: size x + self indent.
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

	^(idMap lookup: id)
		ifNil: [super command: notifyCode id: id]
		ifNotNil: [:tool | self onCommand: tool commandDescription]!

commandSource
	"Answer the <View> which is the starting point for routing commands issued by the receiver.
	Delegate to the containing shell."

	^self topShell commandSource!

defaultBitmapSize
	"Private - Answer a default size for bitmaps in the receiver"

	^16 @ 16!

defaultButtonSize
	"Private - Answer a default size for buttons in the receiver"

	^22 @ 22!

defaultExtent
	"Private - Answer the default size of the receiver to be used when it is created."

	^##(350 @ 25)!

defaultGradientBackcolor
	"Private - Answer the default colour for the final colour in the receiver's gradient filled background"

	"This is the colour of the shadow at the bottom of a header control in the luna theme."

	^Color 
		r: 203
		g: 199
		b: 184!

defaultGradientForecolor
	"Private - Answer the default colour for the final colour in the receiver's gradient filled background"

	"This is Color light3d in the luna theme"

	^Color 
		r: 241
		g: 239
		b: 226!

defaultWindowStyle
	"Private - Answer a default base style to use when creating the receiver"

	^super defaultWindowStyle 
		bitOr: ##(TBSTYLE_TOOLTIPS | TBSTYLE_WRAPABLE)!

filerProxy
	| saved |
	saved := bitmapsStart.
	bitmapsStart := nil.
	^[super filerProxy] ensure: [bitmapsStart := saved]!

fontChanged
	"Private - The receiver's font has been changed. The default is to cause the receiver to
	resize."

	super fontChanged.
	self updateSize!

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

indent
	"Answer the number of pels by which the first button in the toolbar will be indented. 
	This provides a much better mechanism for reserving space in a toolbar for a nested control than the addition of a separator of a specified width that must be completely covered in order not to show unwanted visual artefacts. Weirdly MSDN still recommends the separator technique."

	^indent ?? 0!

indent: anInteger
	indent = anInteger ifFalse: [
		indent := anInteger.
		self tbSetIndent: anInteger]!

indexOfItem: aToolbarItem
	"Private - Answer the index of aToolbarItem."

	^items identityIndexOf: aToolbarItem!

initialize
	"Private - Initialise the receiver."

	super initialize.
	self clearIdMap.
	items := {}.
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

	insets := aRectangle = Rectangle.Empty ifFalse: [aRectangle].
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

	^idMap lookup: anInteger!

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

	^(##((Array new: TBN_FIRST - TBN_GETBUTTONINFOW + 1 withAll: #nmDummy:)
		at: TBN_FIRST - TBN_BEGINDRAG + 1 put: #tbnBeginDrag:;
		at: TBN_FIRST - TBN_ENDDRAG + 1 put: #tbnEndDrag:;
		at: TBN_FIRST - TBN_BEGINADJUST + 1 put: #tbnBeginAdjust:;
		at: TBN_FIRST - TBN_ENDADJUST + 1 put: #tbnEndAdjust:;
		at: TBN_FIRST - TBN_RESET + 1 put: #tbnReset:;
		at: TBN_FIRST - TBN_QUERYINSERT put: #tbnQueryInsert:;
		at: TBN_FIRST - TBN_QUERYDELETE + 1 put: #tbnQueryDelete:;
		at: TBN_FIRST - TBN_TOOLBARCHANGE + 1 put: #tbnToolbarChange:;
		at: TBN_FIRST - TBN_CUSTHELP + 1 put: #tbnCustHelp:;
		at: TBN_FIRST - TBN_DROPDOWN + 1 put: #tbnDropDown:;
		at: TBN_FIRST - TBN_CLOSEUP + 1 put: #tbnCloseUp:;
		at: TBN_FIRST - TBN_GETBUTTONINFOW + 1 put: #tbnGetButtonInfo:;
		yourself) lookup: ##(TBN_FIRST + 1) - (pNMHDR sdwordAtOffset: 8))
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
	background colour to the colour at the end, (both can be set to Color default to get a light
	grey gradient)."

	| back fore rect canvas |
	back := self basicActualBackcolor.
	back isNone ifTrue: [^true].
	rect := self clientRectangle.
	canvas := aColorEvent canvas.
	(self hasFlatAppearance or: [(fore := self basicActualForecolor) isNone])
		ifTrue: 
			[back := back isDefault ifTrue: [self defaultBackcolor] ifFalse: [back].
			canvas fillRectangle: rect color: back.
			self isVertical
				ifFalse: 
					[| bottom |
					bottom := rect bottom - 1.
					canvas
						pen: (back intensity: 0.95) pen;
						lineFrom: rect left @ bottom to: rect right @ bottom]]
		ifFalse: 
			[canvas
				fillRectangle: rect
				startColor: (fore isDefault ifTrue: [self defaultGradientForecolor] ifFalse: [fore])
				endColor: (back isDefault ifTrue: [self defaultGradientBackcolor] ifFalse: [back])
				verticalGradient: self isVertical not].
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

onStateRestored
	self updateSize!

onTipTextRequired: item
	"Text is required for the tool-tip associated with the
	<ToolbarItem>, item."

	^item onTipTextRequired!

onViewCreated
	"The receiver window has been created (but is not yet visible). 
	Finish the job and install the known ToolbarItems"

	super onViewCreated.
	self tbButtonStructSize: TBBUTTON byteSize.
	bitmapsStart := LookupTable new.
	self changeButtonSize: [self tbSetBitmapSize: self actualBitmapSize].
	#todo.	"Store extended style in an inst. var (appear to be some unused?) and provide accessors/mode settings"
	self tbSetExtendedStyle: ##(TBSTYLE_EX_DRAWDDARROWS | TBSTYLE_EX_DOUBLEBUFFER).
	self clearIdMap.
	self indent == 0 ifFalse: [self tbSetIndent: self indent].
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
	index := self sendMessage: TB_ADDBUTTONSW wParam: tbButtons size lpParam: tbButtons asParameter.
	^index == 0
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [index]!

tbAddString: aString
	"Private - Add aString to the receiver. Answer the index of the new string."

	| buffer index |

	buffer := aString asUtf16String copyWith: $\0.	"Last string must have extra null"
	^(index := self sendMessage: TB_ADDSTRINGW wParam: 0 lpParam: buffer) == -1
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [index]

!

tbAutoSize
	"Private - Cause the receiver to be resized."

	self sendMessage: TB_AUTOSIZE!

tbButtonCount
	"Private - Answer number of buttons in the toolbar."

	^self sendMessage: TB_BUTTONCOUNT!

tbButtonStructSize: anInteger
	^self
		sendMessage: TB_BUTTONSTRUCTSIZE
		wParam: anInteger
		lParam: 0!

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
	^(self
		sendMessage: TB_GETBUTTON
		wParam: anInteger - 1
		lpParam: tbButton asParameter) == 0
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [tbButton]!

tbGetButtonInfo: iID tbbi: binfo
	"Private - Populate the <TBBUTTONINFO>, binfo,  argument with information about the 
	item in receiver with <integer> command id, iID. Answers the index of the button
	or raises an exception if an error occured."

	| i |
	^(i := self sendMessage: TB_GETBUTTONINFOW wParam: iID lpParam: binfo) == -1
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [i]!

tbGetButtonSize
	"Private - Answer the current size of the toolbar buttons."

	| size |
	size := self sendMessage: TB_GETBUTTONSIZE.
	^size lowWord @ size highWord!

tbGetIdealHeight
	"Private - Answer the ideal height for the receiver."

	| size |
	size := SIZEL new.
	self
		sendMessage: TB_GETIDEALSIZE
		wParam: true asParameter
		lpParam: size.
	^size cy!

tbGetIdealWidth
	"Private - Answer the ideal width for the receiver."

	| size |
	size := SIZEL new.
	self
		sendMessage: TB_GETIDEALSIZE
		wParam: false asParameter
		lpParam: size.
	^size cx!

tbGetItemRect: anInteger
	"Private - Answer the bounding RECTL for the receiver's button with the zero-based
	<Integer> index."

	| rect |
	rect := RECTL new.
	(self
		sendMessage: TB_GETITEMRECT
		wParam: anInteger
		lpParam: rect) == 0
		ifTrue: [^self errorInCommonControlCall].
	^rect!

tbGetMaxSize
	"Private - Answer the maximum extent for the receiver."

	| size |
	size := POINTL new.
	self
		sendMessage: TB_GETMAXSIZE
		wParam: 0
		lpParam: size.
	^size asPoint!

tbGetPadding
	"Private - Answer the padding between buttons of the the receiver."

	| pad |
	pad := self sendMessage: TB_GETPADDING.
	^pad lowWord @ pad highWord
!

tbGetRect: id
	"Private - Answer the bounding RECTL for the receiver's button with the specified
	<Integer> command id."

	| rect |
	rect := RECTL new.
	(self
		sendMessage: TB_GETRECT
		wParam: id
		lpParam: rect) == 0
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
	"Private - Default handler for the TBN_DROPDOWNW notification message.
	Forward on a #onDropDown: event to the presenter."

	| nmtb id |
	nmtb := NMTOOLBARW fromAddress: pNMHDR.
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

	(self
		sendMessage: TB_PRESSBUTTON
		wParam: anIntegerId
		lParam: pressBoolean asParameter) == 0
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

tbSetIndent: anInteger 
	self sendMessage: TB_SETINDENT wParam: anInteger
	!

tbSetRows: anIntegerRows large: largerBoolean
	"Private - Set the number of rows in the receiver to anInteger. If largerBoolean is
	true then more rows will be created if there is not enough horizontal width to
	hold the necessary items. 
	Answer a Rectangle marking the new boundary of the receiver."

	| rect |
	rect := RECTL new.
	self
		sendMessage: TB_SETROWS
		wParam: (anIntegerRows bitOr: largerBoolean asParameter << 16)
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

ttnGetDispInfo: anNMTTDISPINFOW
	"Private - Handler for the TTN_NEEDTEXTW notification message."

	^(anNMTTDISPINFOW idIsHandle
		ifTrue: [View withHandle: anNMTTDISPINFOW idFrom]
		ifFalse: [self itemFromId: anNMTTDISPINFOW idFrom])
			ifNotNil: 
				[:tool |
				"Note that we must keep a reference to the text string to prevent its premature death"
				tipText := anNMTTDISPINFOW text: (self presenter onTipTextRequired: tool).
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
			[buttonSize ifNotNil: [self tbSetButtonSize: buttonSize].
			self tbSetBitmapSize: self actualBitmapSize].
	self tbAutoSize!

updateSizePosted
	"Sent by legacy saved views"!

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
	"Private - As we create the receiver with the standard CreateWindowEx call we have to inform
	Windows of the size of TBBUTTON struct that we are using before we can add any buttons."

	self sendMessage: TB_BUTTONSTRUCTSIZE wParam: TBBUTTON byteSize.
	^super
		wmCreate: message
		wParam: wParam
		lParam: lParam!

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
!UI.Toolbar categoriesFor: #actualBitmapSize!geometry!public! !
!UI.Toolbar categoriesFor: #addBitmap:index:!helpers!private! !
!UI.Toolbar categoriesFor: #addEditTools!adding!private! !
!UI.Toolbar categoriesFor: #addFileTools!adding!private! !
!UI.Toolbar categoriesFor: #addFindTools!adding!private! !
!UI.Toolbar categoriesFor: #addItem:!adding!public! !
!UI.Toolbar categoriesFor: #addItems:!adding!public! !
!UI.Toolbar categoriesFor: #addSeparator!adding!public! !
!UI.Toolbar categoriesFor: #addString:!helpers!private! !
!UI.Toolbar categoriesFor: #addSystemBitmap:index:!helpers!private! !
!UI.Toolbar categoriesFor: #basicActualForecolor!accessing!private! !
!UI.Toolbar categoriesFor: #basicAddItems:!adding!private! !
!UI.Toolbar categoriesFor: #bitmapSize!geometry!public! !
!UI.Toolbar categoriesFor: #bitmapSize:!geometry!public! !
!UI.Toolbar categoriesFor: #buttonSize!geometry!public! !
!UI.Toolbar categoriesFor: #buttonSize:!geometry!public! !
!UI.Toolbar categoriesFor: #calculateExtent:!geometry!private! !
!UI.Toolbar categoriesFor: #canCustomize!accessing-styles!public! !
!UI.Toolbar categoriesFor: #canCustomize:!accessing-styles!public! !
!UI.Toolbar categoriesFor: #changeButtonSize:!helpers!private! !
!UI.Toolbar categoriesFor: #clearIdMap!initializing!private! !
!UI.Toolbar categoriesFor: #command:id:!commands!private! !
!UI.Toolbar categoriesFor: #commandSource!commands!public! !
!UI.Toolbar categoriesFor: #defaultBitmapSize!constants!private! !
!UI.Toolbar categoriesFor: #defaultButtonSize!constants!private! !
!UI.Toolbar categoriesFor: #defaultExtent!constants!private! !
!UI.Toolbar categoriesFor: #defaultGradientBackcolor!colors!constants!private! !
!UI.Toolbar categoriesFor: #defaultGradientForecolor!colors!constants!private! !
!UI.Toolbar categoriesFor: #defaultWindowStyle!constants!private! !
!UI.Toolbar categoriesFor: #filerProxy!binary filing!private! !
!UI.Toolbar categoriesFor: #fontChanged!private!updating! !
!UI.Toolbar categoriesFor: #hasFlatAppearance!accessing-styles!public! !
!UI.Toolbar categoriesFor: #hasFlatAppearance:!accessing-styles!public! !
!UI.Toolbar categoriesFor: #hasLabels!accessing-styles!public! !
!UI.Toolbar categoriesFor: #hasLabels:!accessing-styles!public! !
!UI.Toolbar categoriesFor: #hasListAppearance!accessing-styles!public! !
!UI.Toolbar categoriesFor: #hasListAppearance:!accessing-styles!public! !
!UI.Toolbar categoriesFor: #hasTransparentAppearance:!accessing-styles!public! !
!UI.Toolbar categoriesFor: #hasTransparentBackground!accessing-styles!private! !
!UI.Toolbar categoriesFor: #indent!accessing!public! !
!UI.Toolbar categoriesFor: #indent:!accessing!public! !
!UI.Toolbar categoriesFor: #indexOfItem:!accessing!private! !
!UI.Toolbar categoriesFor: #initialize!initializing!private! !
!UI.Toolbar categoriesFor: #insets!accessing!public! !
!UI.Toolbar categoriesFor: #insets:!accessing!public! !
!UI.Toolbar categoriesFor: #itemAtIndex:!accessing!public! !
!UI.Toolbar categoriesFor: #itemClass!constants!public! !
!UI.Toolbar categoriesFor: #itemFromId:!accessing!private! !
!UI.Toolbar categoriesFor: #itemRect:!geometry!public! !
!UI.Toolbar categoriesFor: #items!accessing!private! !
!UI.Toolbar categoriesFor: #items:!accessing!private! !
!UI.Toolbar categoriesFor: #layoutManager!geometry!public! !
!UI.Toolbar categoriesFor: #layoutManager:!geometry!public! !
!UI.Toolbar categoriesFor: #nmNotify:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #onDropDown:!event handling!private! !
!UI.Toolbar categoriesFor: #onEraseRequired:!event handling!private! !
!UI.Toolbar categoriesFor: #onPositionChanged:!event handling!public! !
!UI.Toolbar categoriesFor: #onStateRestored!binary filing!private! !
!UI.Toolbar categoriesFor: #onTipTextRequired:!event handling!public! !
!UI.Toolbar categoriesFor: #onViewCreated!event handling!public! !
!UI.Toolbar categoriesFor: #removeAllItems!public!removing! !
!UI.Toolbar categoriesFor: #removeItem:!public!removing! !
!UI.Toolbar categoriesFor: #size!geometry!public! !
!UI.Toolbar categoriesFor: #tbAddBitmap:size:!helpers!private! !
!UI.Toolbar categoriesFor: #tbAddButtons:!helpers!private! !
!UI.Toolbar categoriesFor: #tbAddString:!adding!private! !
!UI.Toolbar categoriesFor: #tbAutoSize!operations!private! !
!UI.Toolbar categoriesFor: #tbButtonCount!geometry!private! !
!UI.Toolbar categoriesFor: #tbButtonStructSize:!helpers!private! !
!UI.Toolbar categoriesFor: #tbCheckButton:state:!operations!private! !
!UI.Toolbar categoriesFor: #tbCustomize!operations!private! !
!UI.Toolbar categoriesFor: #tbDeleteButton:!helpers!private! !
!UI.Toolbar categoriesFor: #tbEnableButton:state:!operations!private! !
!UI.Toolbar categoriesFor: #tbGetButton:!accessing!private! !
!UI.Toolbar categoriesFor: #tbGetButtonInfo:tbbi:!accessing!private! !
!UI.Toolbar categoriesFor: #tbGetButtonSize!geometry!private! !
!UI.Toolbar categoriesFor: #tbGetIdealHeight!geometry!private! !
!UI.Toolbar categoriesFor: #tbGetIdealWidth!geometry!private! !
!UI.Toolbar categoriesFor: #tbGetItemRect:!geometry!private! !
!UI.Toolbar categoriesFor: #tbGetMaxSize!geometry!private! !
!UI.Toolbar categoriesFor: #tbGetPadding!geometry!private! !
!UI.Toolbar categoriesFor: #tbGetRect:!geometry!private! !
!UI.Toolbar categoriesFor: #tbGetRows!geometry!private! !
!UI.Toolbar categoriesFor: #tbGetState:!accessing!private! !
!UI.Toolbar categoriesFor: #tbGetToolTips!accessing!private! !
!UI.Toolbar categoriesFor: #tbHideButton:state:!operations!private! !
!UI.Toolbar categoriesFor: #tbIndeterminate:state:!operations!private! !
!UI.Toolbar categoriesFor: #tbIsButtonChecked:!private!testing! !
!UI.Toolbar categoriesFor: #tbIsButtonEnabled:!private!testing! !
!UI.Toolbar categoriesFor: #tbIsButtonHidden:!private!testing! !
!UI.Toolbar categoriesFor: #tbIsButtonIndeterminate:!private!testing! !
!UI.Toolbar categoriesFor: #tbIsButtonPressed:!private!testing! !
!UI.Toolbar categoriesFor: #tbnBeginAdjust:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnBeginDrag:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnCloseUp:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnCustHelp:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnDropDown:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnEndAdjust:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnEndDrag:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnGetButtonInfo:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnQueryDelete:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnQueryInsert:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnReset:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbnToolbarChange:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #tbPressButton:state:!operations!private! !
!UI.Toolbar categoriesFor: #tbSetBitmapSize:!geometry!private! !
!UI.Toolbar categoriesFor: #tbSetButtonSize:!geometry!private! !
!UI.Toolbar categoriesFor: #tbSetCmdID:id:!commands!private! !
!UI.Toolbar categoriesFor: #tbSetExtendedStyle:!helpers!private! !
!UI.Toolbar categoriesFor: #tbSetIndent:!operations!private! !
!UI.Toolbar categoriesFor: #tbSetRows:large:!geometry!private! !
!UI.Toolbar categoriesFor: #tbSetState:state:!helpers!private! !
!UI.Toolbar categoriesFor: #tbSetToolTips:!accessing!private! !
!UI.Toolbar categoriesFor: #ttnGetDispInfo:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #updateAllItems!operations!private! !
!UI.Toolbar categoriesFor: #updateSize!operations!private! !
!UI.Toolbar categoriesFor: #updateSizePosted!operations!private! !
!UI.Toolbar categoriesFor: #validateUserInterface!operations!public! !
!UI.Toolbar categoriesFor: #wmCreate:wParam:lParam:!event handling-win32!private! !
!UI.Toolbar categoriesFor: #wmNotify:wParam:lParam:!event handling-win32!private! !

!UI.Toolbar class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Toolbar) 34 25 nil nil 34 2 8 1140853580 131073 416 nil nil nil 7 nil nil nil 416 917510 ##(Graphics.Color) #default 8 1920642432 nil 170 192 8 #() 8 #() nil nil 1 nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 690 401 51 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 199 12 0 0 35 0 0 0] 8 #() 690 193 193 nil 27)!

resource_Edit_tools
	"Answer the literal data from which the 'Edit tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Edit_tools)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Toolbar) 34 25 nil nil 34 2 8 1409289036 131137 416 nil nil nil 517 nil nil nil 416 917510 ##(Graphics.Color) #default 8 1920642432 170 192 8 #() 170 192 34 10 22365 1311814 1 ##(UI.ToolbarIconButton) 416 1 1377606 4 ##(UI.CommandDescription) #undo 8 'Undo' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'EditUndo.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 22365 22361 594 416 1 626 #pasteClipboard 8 'Paste' 1 1 674 nil true 720 8 'EditPaste.ico' 768 22361 22357 594 416 1 626 #cutSelection 8 'Cut' 1 1 674 nil true 720 8 'EditCut.ico' 768 22357 22363 594 416 1 626 #clearSelection 8 'Delete' 1 1 674 nil true 720 8 'EditClear.ico' 768 22363 22359 594 416 1 626 #copySelection 8 'Copy' 1 1 674 nil true 720 8 'EditCopy.ico' 768 22359 34 6 880 1040 800 960 608 1245766 1 ##(UI.ToolbarSeparator) 416 1 nil nil 1 nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 1282 247 51 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 122 12 0 0 35 0 0 0] 8 #() 1282 193 193 nil 27)!

resource_File_tools
	"Answer the literal data from which the 'File tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_File_tools)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Toolbar) 34 25 nil nil 34 2 8 1409289036 131137 416 nil nil nil 517 nil nil nil 416 917510 ##(Graphics.Color) #default 8 1920642432 170 192 8 #() 170 192 34 6 22689 1311814 1 ##(UI.ToolbarIconButton) 416 1 1377606 4 ##(UI.CommandDescription) #fileSave 8 'Save' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'FileSave.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 22689 22687 594 416 1 626 #fileOpen 8 'Open' 1 1 674 nil true 720 8 'FileOpen.ico' 768 22687 22685 594 416 1 626 #fileNew 8 'New' 1 1 674 nil true 720 8 'FileNew.ico' 768 22685 34 4 880 800 608 1245766 1 ##(UI.ToolbarSeparator) 416 1 nil nil 1 nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 1122 155 51 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 76 12 0 0 35 0 0 0] 8 #() 1122 193 193 nil 27)!

resource_Find_tools
	"Answer the literal data from which the 'Find tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Find_tools)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Toolbar) 34 25 nil nil 34 2 8 1409289036 131137 416 nil nil nil 517 nil nil nil 416 917510 ##(Graphics.Color) #default 8 1920642432 170 192 8 #() 170 192 34 4 23007 1311814 1 ##(UI.ToolbarIconButton) 416 1 1377606 4 ##(UI.CommandDescription) #find 8 'Find' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'Find.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 23007 23009 594 416 1 626 #findNext 8 'Find Next' 1 1 674 nil true 720 8 'FindNext.ico' 768 23009 34 3 608 800 1245766 1 ##(UI.ToolbarSeparator) 416 1 nil nil 1 nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 1042 109 51 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 53 12 0 0 35 0 0 0] 8 #() 1042 193 193 nil 27)!

resource_History_tools
	"Answer the literal data from which the 'History tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_History_tools)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Toolbar) 34 25 nil nil 34 2 8 1409289036 131137 416 nil nil nil 517 nil nil nil 416 917510 ##(Graphics.Color) #default 8 1920642432 170 192 8 #() 170 192 34 4 23329 1311814 1 ##(UI.ToolbarIconButton) 416 17 1377606 4 ##(UI.CommandDescription) 786950 ##(Core.Message) #historyForward 8 #() 8 'Forward' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'HistoryForward.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 23329 23327 594 416 17 626 658 #historyBack 8 #() 8 'Back' 1 1 722 nil true 768 8 'HistoryBack.ico' 816 23327 34 3 848 608 1245766 1 ##(UI.ToolbarSeparator) 416 1 nil nil 1 nil nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 1122 169 51 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 83 12 0 0 35 0 0 0] 8 #() 1122 193 193 nil 27)!

resource_Tool_bar
	"Answer the literal data from which the 'Tool bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tool_bar)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Toolbar) 34 25 nil nil 34 2 8 1409288972 131137 416 nil 917510 ##(Graphics.Color) #default nil 517 nil nil nil 416 496 8 1920642432 170 192 8 #() 170 192 544 138 144 544 nil nil 1 nil nil nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 738 701 51 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 93 13 0 0 35 0 0 0] 8 #() 738 193 193 nil 27)!

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

themePartName
	^#Toolbar!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'ToolbarWindow32'
! !
!UI.Toolbar class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.Toolbar class categoriesFor: #resource_Edit_tools!public!resources-views! !
!UI.Toolbar class categoriesFor: #resource_File_tools!public!resources-views! !
!UI.Toolbar class categoriesFor: #resource_Find_tools!public!resources-views! !
!UI.Toolbar class categoriesFor: #resource_History_tools!public!resources-views! !
!UI.Toolbar class categoriesFor: #resource_Tool_bar!public!resources-views! !
!UI.Toolbar class categoriesFor: #stbConvertFromVersion12:!binary filing!private! !
!UI.Toolbar class categoriesFor: #themePartName!constants!private! !
!UI.Toolbar class categoriesFor: #winClassName!constants!private! !

