"Filed out from Dolphin Smalltalk"!

UI.ControlBarAbstract
	subclass: #'UI.Toolbar'
	instanceVariableNames: 'textcolor idMap items bitmapsStart insets tbFlags indent imageSize buttonSize dropDownMenu layoutManager'
	classVariableNames: 'FluentIconFonts'
	imports: #(#{OS.ToolbarConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'FluentIconsMask' -> 16r2.
			'ImageSizes'
				-> (IdentityDictionary withAll: {
								#largeIcons -> (16r20 @ 16r20).
								#mediumIcons -> (16r18 @ 16r18).
								#mediumSmallIcons -> (16r14 @ 16r14).
								#smallIcons -> (16r10 @ 16r10).
								#smallTileIcons -> (16r28 @ 16r28).
								#thumbnails -> (16r40 @ 16r40).
								#tileIcons -> (16r30 @ 16r30)
							}).
			'IsScalableMask' -> 16r4.
			'LabelsMask' -> 16r1.
			'NotScalableMask' -> 16r8.
			'ScalableMask' -> 16rC
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
  `indent`			`SmallInteger` pixel indent before first button.
  `imageSize`		`Symbol`. Logical size of button images.
  `buttonSize`		`Point` size of each button. Used for setting a custom button size, but not recommended.
  `_unused27`		Reserved for future use.
  `layoutManager`	`<layoutManager>` or `nil`, for managing the layout of sub-views.

## Class Variables:
  `LabelsMask`		`<integer>` mask for `hasLabels` flag.
  `ImageSizes`		`IdentityDictionary` mapping logical image names to 96-dpi icon sizes.


'!

!UI.Toolbar categoriesForClass!MVP-Views! !

!UI.Toolbar methodsFor!

actualBitmapSize
	^ImageSizes at: self actualImageSize!

actualImageSize
	"Private - Answer the symbolic size of images to be shown as buttons on the toolbar. This can be visually inherited from a parent toolbar, which is useful in allowing the bitmap size to be changed just by changing that of the topmost toolbar."

	| visibleParent |
	imageSize ifNotNil: [:symbol | ^symbol].

	"If nested in a Toolbar, inherit its bitmap size"
	visibleParent := self parentView nonReferenceAncestor.
	^visibleParent class == self class
		ifTrue: [visibleParent actualImageSize]
		ifFalse: [self defaultImageSize]!

addBitmap: aBitmap index: anInteger
	"Private - Add the sub-bitmap identified by anIntegerIndex within aBitmap to the receiver. Answer the index of the sub-bitmap within the registered entries."

	^(bitmapsStart at: aBitmap ifAbsentPutClean: [self tbAddBitmap: aBitmap]) + anInteger!

addEditTools
	"Private - Add the standard edit tools to the receiver."

	self addItems: self itemClass editTools!

addFileTools
	"Private - Add the standard file tools to the receiver."

	self addItems: self itemClass fileTools!

addFindTools
	"Private - Add the standard find tools to the receiver."

	self addItems: self itemClass findTools!

addItem: tool
	"Add the <ToolbarItem>, tool, to the receiver. Answer the new tool."

	(idMap includesKey: tool commandId) ifTrue: [^nil].
	items := items copyWith: tool.
	tool toolbar: self.
	self isScalable: nil.
	^self basicAddItems: {tool}!

addItems: toolbarItems
	"Add a collection of ToolBarItems to the receiver, and answer that collection."

	| unique |
	unique := toolbarItems reject: [:t | idMap includesKey: t commandId].
	unique do: [:t | t toolbar: self].
	items := items, unique.
	self basicAddItems: unique.
	self isScalable: nil.
	^toolbarItems!

addSeparator
	"Add a separator to the receiver. Answer that separator."

	^self addItem: ToolbarSeparator new!

addString: aString
	"Private - Add aString to the list of strings registered for the receiver.
	Answers the index of the string within the registry."

	^self tbAddString: aString!

addSystemBitmap: systemBitmapId index: anIntegerIndex
	"Private - Add the system defined sub-bitmap identified by anIntegerIndex within the bitmap identified by systemBitmapId"

	| start |
	#highDpiToDo. "System bitmaps don't scale so currently their use disables scaling. Not a very satisfactory solution."
	start := bitmapsStart at: systemBitmapId
				ifAbsentPutClean: 
					[self
						sendMessage: TB_LOADIMAGES
						wParam: systemBitmapId
						lParam: HINST_COMMCTRL].
	^start + anIntegerIndex!

applyFont
	"Private - The receiver's font has been changed. The default is to cause the receiver to
	resize."

	super applyFont.
	self updateSize!

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

	| buttons |
	tools isEmpty ifTrue: [^tools	"It is an error to set zero buttons on IE5/NT5"].
	buttons := StructureArray
				withAll: tools
				elementClass: TBBUTTON
				initializer: (self hasLabels
						ifTrue: 
							[
							[:tbButton :toolbarItem |
							| cmd |
							cmd := toolbarItem getCommandId.
							cmd == 0 ifFalse: [idMap at: cmd put: toolbarItem].
							tbButton
								iBitmap: (toolbarItem imageIndexIn: self);
								idCommand: cmd;
								fsState: TB_STATEENABLED;
								fsStyle: (toolbarItem style bitOr: ##(BTNS_AUTOSIZE | BTNS_SHOWTEXT));
								iString: (toolbarItem textIndexIn: self)]]
						ifFalse: 
							[
							[:tbButton :toolbarItem |
							| cmd |
							cmd := toolbarItem getCommandId.
							cmd == 0 ifFalse: [idMap at: cmd put: toolbarItem].
							tbButton
								iBitmap: (toolbarItem imageIndexIn: self);
								idCommand: cmd;
								fsState: TB_STATEENABLED;
								fsStyle: toolbarItem style;
								iString: (toolbarItem isTextOnly ifTrue: [toolbarItem textIndexIn: self] ifFalse: [-1])]]).
	buttons beUnfinalizable.	"Nothing to free here"
	self
		sendMessageNz: TB_ADDBUTTONSW
		wParam: buttons size
		lpParam: buttons.
	^tools!

bitmapSize
	"Answer the device-independent (aka DIPs, or 96-dpi) size of bitmaps shown on the toolbar."

	^imageSize ifNotNil: [ImageSizes at: imageSize]!

bitmapSize: aPoint
	"Set the device-independent (aka DIPs, or 96-dpi) size of bitmaps shown on the toolbar to the <Point> argument."

	#deprecated.
	self imageSize: (ImageSizes keyAtEqualValue: aPoint ifAbsent: [self defaultImageSize])!

buttonSize
	"Answer the size of buttons shown on the toolbar, measured in device pixels at the receiver's DPI.
	It is recommended that this not be used and that the toolbar be allowed to choose the preferred size of button to fit the images."

	^buttonSize ifNil: [self isOpen ifTrue: [self tbGetButtonSize]]!

buttonSize: aPointOrNil
	"Set the size of buttons shown on the toolbar to aPointOrNil. If nil then the buttons assume a default size, which is distinctly the preferred option for normal use."

	buttonSize = aPointOrNil ifTrue: [^self].
	buttonSize := aPointOrNil.
	self updateAllItems!

buttonSpacing
	^self tbGetMetrics buttonSpacing!

buttonSpacing: aPoint
	| metrics |
	metrics := TBMETRICS newBuffer.
	metrics buttonSpacing: aPoint.
	self tbSetMetrics: metrics!

calculateExtent: aLayoutContext
	"Private - Answer an extent for the receiver within the specified <LayoutContext>."

	"Implementation Note: Any suggested or existing extent is ignored. We calculate the extent
	required to draw all the buttons, etc, in the toolbar."

	| size |
	self indent: (self managedSubViews inject: self initialIndent
				into: [:sum :each | sum + (aLayoutContext visibleExtentOf: each) x]).
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
	size y: size y + (self padHeight // 2).
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

creationStyles
	"Private - Answer the base and extended style pair to be used when creating the receiver's Window."

	^self hasFluentIcons
		ifTrue: [{(creationStyles at: 1) bitOr: TBSTYLE_LIST. creationStyles at: 2}]
		ifFalse: [creationStyles]!

customDrawContextClass
	"Private - Answer the class of <customDrawContext> associated with the receiver.
	This is the type of object passed to the customDrawBlock. and provides access to
	all the contextual information to implement partial or complete custom drawing."

	^NMTBCUSTOMDRAW!

customDrawItem: aNMTBCUSTOMDRAW
	"Private - Custom draw the 'item' identified in the argument.
	Answer the custom draw return code (an integer from the [TB]CDRF_XXXX enumeration) to be returned to the control."

	"Implementation Note: We don't implement a full custom draw capability because this is ignored when using themed controls, and consequently it would be necessary to disable themes for the toolbar, then requiring substantial work to emulate those aspects of the theme behaviour that one wanted to retain, such as the hot-highlighting. We can however use this to allow setting of the text colour, as otherwise the text is always black which may not suit a dark background colour. This is particularly useful when using fluent (text glyph) icons, as in that case the button 'image' is actually text."

	| rc |
	rc := CDRF_DODEFAULT.
	textcolor
		ifNotNil: 
			[aNMTBCUSTOMDRAW clrText: textcolor.
			rc := rc bitOr: TBCDRF_USECDCOLORS].
	^rc!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

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

defaultImageSize
	"Private - Answer the logical image size to be used by default. This is the smallest icon size, which at 96-dpi corresponds to 16@16. The actual image size will be scaled to the window DPI, e.g. at 120-dpi (or 125% scaling) the actual image size will be 20@20 for small icons."

	^#smallIcons!

defaultWindowStyle
	"Private - Answer a default base style to use when creating the receiver"

	^super defaultWindowStyle bitOr: ##(TBSTYLE_TOOLTIPS | TBSTYLE_WRAPABLE | TBSTYLE_FLAT)!

filerProxyIn: anSTxOutFiler
	| proxy |
	proxy := super filerProxyIn: anSTxOutFiler.
	proxy instVars 
		at: ##(self indexOfInstVar: 'bitmapsStart') put: nil;
		at: ##(self indexOfInstVar: 'idMap') put: nil.
	^proxy!

fluentIconSpacing
	^self scalePadding: 4!

getActualFont
	^font
		ifNil: 
			[self hasFluentIcons
				ifTrue: [FluentIconFonts at: self actualImageSize]
				ifFalse: [self parentView getActualFont]]!

getItemRect: anInteger
	"Private - Answer the bounding <RECTL> for the button at the specified zero-based <Integer> index."

	| rect |
	rect := RECTL newBuffer.
	self
		sendMessageNz: TB_GETITEMRECT
		wParam: anInteger
		lpParam: rect.
	^rect!

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

hasFluentIcons
	"Answer whether the toolbar consists of text-only buttons that are assumed to be configured to use the glyphs from the [Segoe Fluent Icons](https://learn.microsoft.com/en-us/windows/apps/design/style/segoe-fluent-icons-font). This causes the font of the toolbar to be defaulted to 'Segoe Fluent Icons' at an appropriate point size for the image size so that any text-only buttons are drawn with characters from the font. This will probably not work well if the text of the buttons is not chosen from the fluent icon set. When this style is set, TBSTYLE_LIST (hasListAppearance) is implied."

	^tbFlags allMask: FluentIconsMask!

hasFluentIcons: aBoolean
	"Set whether the toolbar consists of text-only buttons that are assumed to be configured to use the glyphs from the [Segoe Fluent Icons](https://learn.microsoft.com/en-us/windows/apps/design/style/segoe-fluent-icons-font). This causes the font of the toolbar to be defaulted to 'Segoe Fluent Icons' at an appropriate point size for the image size so that any text-only buttons are drawn with characters from the font. This will probably not work well if the text of the buttons is not chosen from the fluent icon set. Generally a fluent icons toolbar will consist entirely of text-only buttons (i.e. ToolbarTextButtons). This style implies TBSTYLE_LIST (hasListAppearance)."

	self hasFluentIcons = aBoolean ifTrue: [^self].
	tbFlags := tbFlags mask: FluentIconsMask set: aBoolean.
	self recreate!

hasLabels
	"Answer whether labels are to be included in buttons."

	^tbFlags allMask: LabelsMask!

hasLabels: aBoolean 
	"Set whether labels are to be included in a button."

	tbFlags := tbFlags mask: LabelsMask set: aBoolean.
	self updateAllItems!

hasListAppearance
	"Answers true if the receiver has should display any button text alongside image rather than underneath it. i.e. it has (or will have when created) the TBSTYLE_LIST style. If the toolbar has fluent icons, this style is implied."

	^self hasFluentIcons or: [self baseStyleAllMask: TBSTYLE_LIST]!

hasListAppearance: aBoolean 
	"Sets the receiver to have a list appearance if aBoolean is true. This is the TBSTYLE_LIST style."

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

imageSize
	"Answer the symbolic size size of images shown on the toolbar."

	^imageSize!

imageSize: aSymbol
	"Set the symbolic size of images shown on the toolbar."

	self imageSize == aSymbol ifTrue: [^self].
	imageSize := (ImageSizes includesKey: aSymbol) ifTrue: [aSymbol].
	self invalidateLayout.
	"If the toolbar does not have an explicit button size, then adjust the toolbar to use the new size of images"
	buttonSize
		ifNil: 
			["The Toolbar has a bug whereby it doesn't update its metrics correctly if the image size is changed - the default button size is generally too large, especially if switching to a smaller size. Therefore we recreate the control."
			self recreate]
		ifNotNil: [self updateAllItems]!

indent
	"Answer the number of pels by which the first button in the toolbar will be indented. Note that this is now calculated automatically to allow space for any child views before the buttons are shown.
	This provides a much better mechanism for reserving space in a toolbar for a nested control than the addition of a separator of a specified width that must be completely covered in order not to show unwanted visual artefacts. Weirdly MSDN still recommends the separator technique."

	^indent ?? 0!

indent: anInteger
	indent = anInteger ifTrue: [^self].
	indent := anInteger.
	self tbSetIndent: anInteger!

indexOfItem: aToolbarItem
	"Private - Answer the index of aToolbarItem."

	^items identityIndexOf: aToolbarItem!

initialIndent
	^self hasFluentIcons ifTrue: [self scalePadding: 2] ifFalse: [0]!

initialize
	"Private - Initialise the receiver."

	super initialize.
	self clearIdMap.
	items := {}.
	tbFlags := 0.
	imageSize := self defaultImageSize .
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

isScalable
	| scalable |
	scalable := (tbFlags bitAnd: ScalableMask) bitShift: ##(1 - ScalableMask lowBit).
	^scalable == 0
		ifTrue: 
			[scalable := items allSatisfy: [:each | each isScalable].
			self isScalable: scalable.
			scalable]
		ifFalse: [scalable == 1]!

isScalable: aBooleanOrNil
	tbFlags := tbFlags bitAnd: ##(ScalableMask bitInvert).
	aBooleanOrNil ifNil: [^self].
	tbFlags := tbFlags bitOr: (aBooleanOrNil ifTrue: [IsScalableMask] ifFalse: [NotScalableMask])!

isWrapable
	^self baseStyle allMask: TBSTYLE_WRAPABLE!

isWrapable: aBoolean
	self 
		baseStyleMask: TBSTYLE_WRAPABLE
		set: aBoolean
		recreateIfChanged: true!

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
	self isScalable: nil.
	self recreate.!

layoutManager
	"Answer the layout manager for the receiver"

	^layoutManager!

layoutManager: aLayoutManager
	"Set the layout manager for the receiver to aLayoutManager"

	layoutManager := aLayoutManager.
	self basicInvalidateLayout!

nmCustomDraw: pNMHDR
	"Private - Handle a NM_CUSTOMDRAW notification message."

	"Implementation Note: Defer creating the header struct as long as possible to avoid impacting 
	draw speed too much as this message can be sent several times per sub-item."

	| drawStage context item |
	(drawStage := pNMHDR uint32AtOffset: NMCUSTOMDRAW._OffsetOf_dwDrawStage) == CDDS_PREPAINT
		ifTrue: 
			["Before any painting"
			^(self wantCustomDrawItemNotifications: pNMHDR)
				ifTrue: [CDRF_NOTIFYITEMDRAW]
				ifFalse: [CDRF_DODEFAULT]].
	"Before painting item"
	(drawStage allMask: CDDS_ITEMPREPAINT) ifFalse: [^nil].
	context := self customDrawContextClass fromAddress: pNMHDR.
	item := self itemFromId: context dwItemSpec.
	item
		ifNil: 
			["The control attempts to draw stuff that isn't there on occassion"
			^CDRF_DODEFAULT].
	context
		item: item;
		view: self.
	^self customDrawItem: context!

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
		yourself) lookup: ##(TBN_FIRST + 1) - (pNMHDR int32AtOffset: NMHDR._OffsetOf_code))
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

onDropDown: aToolbarButton
	"Private - The receiver's control has sent a notification that a drop-down style buttons drop-down arrow has been pressed.  We use the generic command routing and querying mechanism to identify a target that implements and can populate the menu. This works very similarly to standard dynamic menu population, except that the menu is always built completely from scratch. All the boilerplate code that used to be required to handle the #dropDown: event is no longer needed - it is only necessary to implement a menu populator method, and associate that with the drop-down button commands (that should already exist) using #menuPopulator: annotations. For backwards compatibility, if there is no command target on the path prepared to populate the menu, we will then trigger the #dropDown: event that used to be hooked in order to build and show menus for toolbar drop-downs. Otherwise normal menu processing applies, i.e. #onAboutToDisplayMenu: is sent to presenter/view for both the popup itself and any sub-menus that are opened, and the default implementations will trigger the aboutToDisplayMenu: event off the presenter. If a menu is populated through the shared mechanism, then the #dropDown: event is not triggered."

	| emptyMenu |
	dropDownMenu := Menu new name: aToolbarButton command asSymbol.
	dropDownMenu showIn: self position: aToolbarButton screenRectangle bottomLeft.
	emptyMenu := dropDownMenu isEmpty.
	dropDownMenu := nil.
	emptyMenu ifTrue: [self presenter trigger: #dropDown: with: aToolbarButton].
	dropDownMenu := nil.
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
					[| bottom oldPen |
					bottom := rect bottom - 1.
					oldPen := canvas pen: (back intensity: 0.95) pen.
					canvas lineFrom: rect left @ bottom to: rect right @ bottom.
					(canvas pen: oldPen) free]]
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
						ifTrue: 
							[rect left @ (rect top + (self calculateExtent: (LayoutContext forContainer: self parentView)) y)]
						ifFalse: 
							[(rect left + (self calculateExtent: (LayoutContext forContainer: self parentView)) x) @ rect top])
							corner: rect corner)].
	^true!

onPositionChanged: aPositionEvent
	"Handle a window position change event (move or resize)."

	"Implementation Note:  Toolbars (depending on the Common Control Library version) do not redraw properly when wrapping so we always invalidate them here."

	aPositionEvent isResize
		ifTrue: 
			["Dynamically change the receiver's orientation to take best advantage of the available space."
			self isVertical: aPositionEvent isTall.
			self invalidate].
	^super onPositionChanged: aPositionEvent!

onStateRestored
	self updateSize!

onViewCreated
	"The receiver window has been created (but is not yet visible). 
	Finish the job and install the known ToolbarItems"

	super onViewCreated.
	self
		sendMessage: TB_BUTTONSTRUCTSIZE
		wParam: TBBUTTON._TBBUTTON_Size
		lParam: 0.
	bitmapsStart := LookupTable new.
	self setButtonSize.
	self tbSetExtendedStyle: (self hasLabels
				ifTrue: [##(TBSTYLE_EX_DRAWDDARROWS | TBSTYLE_EX_DOUBLEBUFFER)]
				ifFalse: [##(TBSTYLE_EX_DRAWDDARROWS | TBSTYLE_EX_DOUBLEBUFFER | TBSTYLE_EX_MIXEDBUTTONS)]).
	self clearIdMap.
	indent ifNotNil: [self tbSetIndent: indent].
	"If we are using text-only buttons for fluent icons, we get better results without padding as the textual icon is then centred"
	self hasFluentIcons ifTrue: [self setFluentIconMetrics].
	self basicAddItems: items!

padHeight
	^(self sendMessage: TB_GETPADDING) highWord!

preferredHeight
	"Private - Answer the <integer> number of pels that would be the ideal height for the client area of the receiver."

	^self buttonSize y + (self padHeight // 2)!

removeAllItems
	"Remove all the receiver's buttons."

	items size - 1 to: 0
		by: -1
		do: [:i | self tbDeleteButton: i].
	self clearIdMap.
	items := {}.
	self isScalable: true!

removeItem: aToolbarItem
	"Remove aToolbarItem from both the internal collection of
	available buttons and from the associated Windows control. 
	Answer aToolbarItem."

	| index |
	index := self indexOfItem: aToolbarItem.
	items := (items copyFrom: 1 to: index-1), (items copyFrom: index+1).
	aToolbarItem commandId ~= 0 ifTrue: [
		idMap removeKey: aToolbarItem commandId].
	self isScalable: nil.
	self tbDeleteButton: index - 1.
	^aToolbarItem!

resolutionScaledBy: aPoint
	"Private - The receiver is being loaded and it has been determined that the pixel resolution has changed since the point at which the view was saved. Scale any internal pixels by the <Point> argument. "

	super resolutionScaledBy: aPoint.
	buttonSize ifNotNil: [buttonSize := (buttonSize * aPoint) truncated]!

scaledBitmapSize
	"Private - Answer the actual pixel extent of bitmaps shown on the toolbar, measure at the current window DPI. This can be visually inherited from a parent toolbar, which is useful in allowing the image size to be changed just by changing that of the topmost toolbar."

	| size |
	size := self actualBitmapSize.
	^self isScalable ifTrue: [Icon standardSizeFor: (size * self dpi // USER_DEFAULT_SCREEN_DPI)] ifFalse: [size]!

scalePadding: anInteger
	^anInteger * self actualBitmapSize x * self dpi // ##(16 * USER_DEFAULT_SCREEN_DPI)!

setButtonSize
	self changeButtonSize: 
			[buttonSize ifNotNil: [self tbSetButtonSize: buttonSize].
			self tbSetBitmapSize: self scaledBitmapSize]!

setFluentIconMetrics
	| metrics spacing |
	metrics := self tbGetMetrics.
	spacing := self fluentIconSpacing.
	metrics
		cxButtonSpacing: spacing;
		cyButtonSpacing: spacing;
		cxPad: (self scalePadding: 1).
	self tbSetMetrics: metrics!

size
	"Answer the number of ToolbarItems in the receiver."

	^self sendMessage: TB_BUTTONCOUNT!

tbAddBitmap: aBitmap
	| size gdiBitmap |
	gdiBitmap := aBitmap asBitmap.
	gdiBitmap setMap3DColors: true.
	"If the extent reported by the bitmap is not correct, then the start index will be out, so watch out for caching duff old extent (see Bitmap>>loadFromInstance)."
	size := gdiBitmap extent x // self scaledBitmapSize x.

	"#305 We must make sure that the bitmap is not selected into a DC or the result will be a blank image in the list. This won't damage the bitmap in any way because the canvas can always be lazily recreated."
	gdiBitmap freeDC.
	^self
		sendMessage: TB_ADDBITMAP
		wParam: size
		lpParam: ((ByteArray newFixed: TBADDBITMAP._TBADDBITMAP_Size)
				uintPtrAtOffset: TBADDBITMAP._OffsetOf_nID put: gdiBitmap asParameter;
				yourself)!

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

tbCheckButton: anIntegerId state: checkBoolean
	"Private - Set whether the button with anIntegerId is checked or not.
	See the note in #tbEnableButton:state: regarding the deliberate lack of error checking"

	self sendMessage: TB_CHECKBUTTON wParam: anIntegerId lParam: checkBoolean asParameter!

tbCustomize
	"Private - Show the toolbar customize dialog box."

	self sendMessage: TB_CUSTOMIZE!

tbDeleteButton: anInteger
	"Private - Delete the button with the specified zero-based <integer> index from the receiver."

	self
		sendMessageNz: TB_DELETEBUTTON
		wParam: anInteger
		lpParam: nil!

tbEnableButton: anIntegerId state: enableBoolean
	"Private - Set whether the button with anIntegerId is enabled or not."

	self
		sendMessageNz: TB_ENABLEBUTTON
		wParam: anIntegerId
		lpParam: enableBoolean asParameter!

tbGetButton: anInteger
	"Private - Answer a TBBUTTON describing the button with the specified zero-based <integer> index in the receiver."

	| tbButton |
	tbButton := TBBUTTON newBuffer.
	self
		sendMessageNz: TB_GETBUTTON
		wParam: anInteger
		lpParam: tbButton asParameter.
	^tbButton!

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

tbGetItemRect: anInteger
	"Private - Answer the bounding RECTL for the receiver's button with the zero-based
	<Integer> index."

	| rect |
	rect := RECTL newBuffer.
	self
		sendMessageNz: TB_GETITEMRECT
		wParam: anInteger
		lpParam: rect.
	^rect!

tbGetMaxSize
	"Private - Answer the maximum extent for the receiver."

	| size |
	size := SIZEL newBuffer.
	self
		sendMessageNz: TB_GETMAXSIZE
		wParam: 0
		lpParam: size.
	^size asPoint!

tbGetMetrics
	"Private - "

	| metrics |
	metrics := TBMETRICS newBuffer.
	metrics dwMask: ##(TBMF_PAD | TBMF_BARPAD | TBMF_BUTTONSPACING).
	self
		sendMessage: TB_GETMETRICS
		wParam: 0
		lpParam: metrics.
	^metrics!

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
	rect := RECTL newBuffer.
	self
		sendMessageNz: TB_GETRECT
		wParam: id
		lpParam: rect.
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
	"Private - Set whether the button with the command id specified as the <integer> first argument is shown or hidden on the toolbar."

	self
		sendMessageNz: TB_HIDEBUTTON
		wParam: anIntegerId
		lpParam: hideBoolean asParameter!

tbIndeterminate: anIntegerId state: indeterminateBoolean
	"Private - Set whether the button with anIntegerId is in its indeterminate state."

	self
		sendMessageNz: TB_INDETERMINATE
		wParam: anIntegerId
		lpParam: indeterminateBoolean asParameter!

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
	"Private - Answer whether the button with anIntegerId is in its indeterminate state."

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
	"Private - Press or release the button with anIntegerId."

	self
		sendMessageNz: TB_PRESSBUTTON
		wParam: anIntegerId
		lpParam: pressBoolean asParameter!

tbSetBitmapSize: aPoint 
	"Private - Set the size of the bitmapped images for the receiver to aPoint. The documentation does say that this must be sent before any items are added, and indeed the toolbar does not resize itself correctly if this is changed after the fact."

	self
		sendMessageNz: TB_SETBITMAPSIZE
		wParam: 0
		lpParam: aPoint asUIntPtr!

tbSetButtonSize: aPoint
	"Private - Set the size of the receiver's items to be aPoint.
	Must be sent before any items are added"

	self
		sendMessageNz: TB_SETBUTTONSIZE
		wParam: 0
		lpParam: aPoint asUIntPtr!

tbSetCmdID: anInteger id: anIntegerId
	"Private - Set the command id for the button with anInteger index to be anIntegerId."

	self
		sendMessageNz: TB_SETCMDID
		wParam: anInteger - 1
		lpParam: anIntegerId!

tbSetExtendedStyle: tbExStyleMask
	"Private - Set the extended toolbar styles of the receiver to the <Integer>
	argument, tbExStyleMask."

	^self sendMessage: TB_SETEXTENDEDSTYLE
		wParam: 0
		lParam: tbExStyleMask
!

tbSetIndent: anInteger 
	self sendMessage: TB_SETINDENT wParam: anInteger asInteger
	!

tbSetListGap: anInteger
	"Private - Set the gap, in pixels, between buttons on the toolbar."

	self
		sendMessage: TB_SETLISTGAP
		wParam: anInteger
		lParam: 0!

tbSetMetrics: aTBMETRICS
	"Private - "

	self
		sendMessage: TB_SETMETRICS
		wParam: 0
		lpParam: aTBMETRICS!

tbSetPadding: aPoint
	"Private - Set the padding around buttons of the the receiver."

	self
		sendMessage: TB_SETPADDING
		wParam: 0
		lParam: aPoint asUInt32!

tbSetRows: anIntegerRows large: largerBoolean
	"Private - Set the number of rows in the receiver to anInteger. If largerBoolean is
	true then more rows will be created if there is not enough horizontal width to
	hold the necessary items. 
	Answer a Rectangle marking the new boundary of the receiver."

	| rect |
	rect := RECTL newBuffer.
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
	"Private - Set the handle of the receiver's tooltip control to toolTipHandle."

	self sendMessage: TB_SETTOOLTIPS wParam: toolTipHandle!

textcolor
	^textcolor!

textcolor: aColor
	textcolor := aColor!

updateAllItems
	"Private - Cause all of the receiver's items to be rebuilt"

	| existingItems |
	existingItems := items copy.
	self removeAllItems.
	self addItems: existingItems; updateSize!

updateSize
	"Private - Update the toolbar button and bitmap sizes."

	self isOpen ifFalse: [^self].
	self setButtonSize.
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

wantCustomDrawItemNotifications: pNMHDR
	^textcolor notNil!

wmCreate: message wParam: wParam lParam: lParam
	"Private - As we create the receiver with the standard CreateWindowEx call we have to inform
	Windows of the size of TBBUTTON struct that we are using before we can add any buttons."

	self sendMessage: TB_BUTTONSTRUCTSIZE wParam: TBBUTTON._TBBUTTON_Size.
	^super
		wmCreate: message
		wParam: wParam
		lParam: lParam!

wmDpiChangedAfterParent: message wParam: wParam lParam: lParam
	"Private - Handles a WM_DPICHANGED_AFTERPARENT message. This is only sent to child windows, bottom-up, before the top-level window receives a WM_DPICHANGED."

	"Toolbars don't resize properly when the bitmap size is changed, so we have to recreate them. Note that as the WM_DPICHANGED_AFTERPARENT message is sent top-down (the opposite of WM_DPICHANGED_BEFOREPARENT), this will mean that the existing sub-toolbars will not receive the resize because they have been replaced, which is ideal"

	self isScalable ifTrue: [self recreate].
	"Obviously we don't want this passed on since we recreated the window and the new Toolbar won't be expecting it."
	^0!

wmInitMenuPopup: message wParam: wParam lParam: lParam
	"Private - In addition to the normal context menu handling, the toolbar also has drop-down menus associated with drop-down items. These are queried in the normal way, allowing any #menuPopulator: and #commandQuery: methods registered on the command path to populate and update the status of the menu."

	dropDownMenu
		ifNil: 
			[^super
				wmInitMenuPopup: message
				wParam: wParam
				lParam: lParam].
	^(dropDownMenu menuFromHandle: wParam)
		ifNotNil: 
			[:subMenu |
			subMenu queryAllFromView: self.
			"Handled"
			0]! !

!UI.Toolbar categoriesForMethods!
actualBitmapSize!geometry!private! !
actualImageSize!geometry!private! !
addBitmap:index:!helpers!private! !
addEditTools!adding!private! !
addFileTools!adding!private! !
addFindTools!adding!private! !
addItem:!adding!public! !
addItems:!adding!public! !
addSeparator!adding!public! !
addString:!helpers!private! !
addSystemBitmap:index:!helpers!private! !
applyFont!font!private!updating! !
basicActualForecolor!accessing!private! !
basicAddItems:!adding!private! !
bitmapSize!geometry!public! !
bitmapSize:!geometry!public! !
buttonSize!geometry!public! !
buttonSize:!geometry!public! !
buttonSpacing!accessing!public! !
buttonSpacing:!accessing!public! !
calculateExtent:!geometry!private! !
canCustomize!accessing-styles!public! !
canCustomize:!accessing-styles!public! !
changeButtonSize:!geometry!private! !
clearIdMap!initializing!private! !
command:id:!commands!private! !
commandSource!commands!public! !
creationStyles!private!realizing/unrealizing! !
customDrawContextClass!constants!private! !
customDrawItem:!event handling!private! !
defaultExtent!constants!private! !
defaultGradientBackcolor!colors!constants!private! !
defaultGradientForecolor!colors!constants!private! !
defaultImageSize!constants!private! !
defaultWindowStyle!constants!private! !
filerProxyIn:!binary filing!private! !
fluentIconSpacing!geometry!private! !
getActualFont!accessing!font!private! !
getItemRect:!geometry!private! !
hasFlatAppearance!accessing-styles!public! !
hasFlatAppearance:!accessing-styles!public! !
hasFluentIcons!accessing-styles!public! !
hasFluentIcons:!accessing-styles!public! !
hasLabels!accessing-styles!public! !
hasLabels:!accessing-styles!public! !
hasListAppearance!accessing-styles!public! !
hasListAppearance:!accessing-styles!public! !
hasTransparentAppearance:!accessing-styles!public! !
hasTransparentBackground!accessing-styles!private! !
imageSize!geometry!public! !
imageSize:!geometry!public! !
indent!accessing!public! !
indent:!accessing!public! !
indexOfItem:!accessing!private! !
initialIndent!geometry!private! !
initialize!initializing!private! !
insets!accessing!public! !
insets:!accessing!public! !
isScalable!public!testing! !
isScalable:!private!testing! !
isWrapable!accessing-styles!public! !
isWrapable:!accessing-styles!public! !
itemAtIndex:!accessing!public! !
itemClass!constants!public! !
itemFromId:!accessing!private! !
items!accessing!private! !
items:!accessing!private! !
layoutManager!geometry!public! !
layoutManager:!geometry!public! !
nmCustomDraw:!event handling-win32!private! !
nmNotify:!event handling-win32!private! !
onDropDown:!event handling!private! !
onEraseRequired:!event handling!private! !
onPositionChanged:!event handling!public! !
onStateRestored!binary filing!private! !
onViewCreated!event handling!public! !
padHeight!geometry!private! !
preferredHeight!private! !
removeAllItems!public!removing! !
removeItem:!public!removing! !
resolutionScaledBy:!geometry!private! !
scaledBitmapSize!geometry!private! !
scalePadding:!geometry!private! !
setButtonSize!operations!private! !
setFluentIconMetrics!geometry!private! !
size!geometry!public! !
tbAddBitmap:!helpers!private! !
tbAddString:!adding!private! !
tbAutoSize!operations!private! !
tbCheckButton:state:!operations!private! !
tbCustomize!operations!private! !
tbDeleteButton:!helpers!private! !
tbEnableButton:state:!operations!private! !
tbGetButton:!accessing!private! !
tbGetButtonInfo:tbbi:!accessing!private! !
tbGetButtonSize!geometry!private! !
tbGetItemRect:!geometry!private! !
tbGetMaxSize!geometry!private! !
tbGetMetrics!geometry!private! !
tbGetPadding!geometry!private! !
tbGetRect:!geometry!private! !
tbGetRows!geometry!private! !
tbGetState:!accessing!private! !
tbGetToolTips!accessing!private! !
tbHideButton:state:!operations!private! !
tbIndeterminate:state:!operations!private! !
tbIsButtonChecked:!private!testing! !
tbIsButtonEnabled:!private!testing! !
tbIsButtonHidden:!private!testing! !
tbIsButtonIndeterminate:!private!testing! !
tbIsButtonPressed:!private!testing! !
tbnBeginAdjust:!event handling-win32!private! !
tbnBeginDrag:!event handling-win32!private! !
tbnCloseUp:!event handling-win32!private! !
tbnCustHelp:!event handling-win32!private! !
tbnDropDown:!event handling-win32!private! !
tbnEndAdjust:!event handling-win32!private! !
tbnEndDrag:!event handling-win32!private! !
tbnGetButtonInfo:!event handling-win32!private! !
tbnQueryDelete:!event handling-win32!private! !
tbnQueryInsert:!event handling-win32!private! !
tbnReset:!event handling-win32!private! !
tbnToolbarChange:!event handling-win32!private! !
tbPressButton:state:!operations!private! !
tbSetBitmapSize:!geometry!private! !
tbSetButtonSize:!geometry!private! !
tbSetCmdID:id:!commands!private! !
tbSetExtendedStyle:!helpers!private! !
tbSetIndent:!operations!private! !
tbSetListGap:!geometry!private! !
tbSetMetrics:!geometry!private! !
tbSetPadding:!geometry!private! !
tbSetRows:large:!geometry!private! !
tbSetState:state:!helpers!private! !
tbSetToolTips:!accessing!private! !
textcolor!accessing!public! !
textcolor:!accessing!public! !
updateAllItems!operations!private! !
updateSize!operations!private! !
updateSizePosted!operations!private! !
validateUserInterface!operations!public! !
wantCustomDrawItemNotifications:!event handling-win32!private! !
wmCreate:wParam:lParam:!event handling-win32!private! !
wmDpiChangedAfterParent:wParam:lParam:!event handling-win32!private! !
wmInitMenuPopup:wParam:lParam:!event handling-win32!private! !
!

!UI.Toolbar class methodsFor!

initialize
	"Private - Initialise the receiver's class variables.
		Toolbar initialize
	"

	"Although we could calculate the required fluent icon font size on the fly, we need to prevent the instances being GC'd to keep the font handle live
	while in use in any live toolbars."
	self addClassConstant: 'FluentIconFonts'
		value: (ImageSizes
						collect: [:each | Font name: 'Segoe Fluent Icons' pointSize: each value x * 72 // 96])!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1140853580 131073 32 nil nil nil 5 nil nil nil 32 6 #{Graphics.Color} #default nil nil nil nil nil nil 8 #() nil nil 9 1 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 199 15 0 0 35 0 0 0] 193 80 8 '' 32 3 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_Edit_tools
	"Answer the literal data from which the 'Edit tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Edit_tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409289036 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 6 1094 1 #{UI.ToolbarIconButton} 32 1 1350 4 #{UI.CommandDescription} #cutSelection 8 'Cut' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditCut.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 210 32 1 242 #copySelection 8 'Copy' 1 1 290 nil true 322 8 'EditCopy.ico' 384 65541 nil nil 210 32 1 242 #pasteClipboard 8 'Paste' 1 1 290 nil true 322 8 'EditPaste.ico' 384 65541 nil nil 210 32 1 242 #clearSelection 8 'Delete <d>' 1 17 290 nil true 322 8 'EditClear.ico' 384 65541 nil nil 210 32 1 242 #undo 8 'Undo' 1 1 290 nil true 322 8 'EditUndo.ico' 384 65541 nil nil 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 9 nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 122 15 0 0 35 0 0 0] 193 80 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_File_tools
	"Answer the literal data from which the 'File tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_File_tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409289036 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 4 1094 1 #{UI.ToolbarIconButton} 32 1 1350 4 #{UI.CommandDescription} #fileNew 8 'New' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'FileNew.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 210 32 1 242 #fileOpen 8 'Open' 1 1 290 nil true 322 8 'FileOpen.ico' 384 65541 nil nil 210 32 1 242 #fileSave 8 'Save' 1 1 290 nil true 322 8 'FileSave.ico' 384 65541 nil nil 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 9 nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 76 15 0 0 35 0 0 0] 193 80 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_Find_tools
	"Answer the literal data from which the 'Find tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Find_tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409289036 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 3 1094 1 #{UI.ToolbarIconButton} 32 1 1350 4 #{UI.CommandDescription} #find 8 'Find <d>' 1 17 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'Find.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 210 32 1 242 #findNext 8 'Find Next <p:>' 1 17 290 nil true 322 8 'FindNext.ico' 384 65541 nil nil 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 9 nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 53 15 0 0 35 0 0 0] 193 80 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_Fluent_Edit_tools
	"Answer the literal data from which the 'Fluent Edit tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Fluent_Edit_tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409293132 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 6 1350 1 #{UI.ToolbarTextButton} 32 161 1350 4 #{UI.CommandDescription} #cutSelection 8 'Cut' 1 1 nil nil 8 $\xE8C6 210 32 161 242 #copySelection 8 'Copy' 1 1 nil nil 8 $\xE8C8 210 32 161 242 #pasteClipboard 8 'Paste' 1 1 nil nil 8 $\xE77F 210 32 161 242 #clearSelection 8 'Delete' 1 1 nil nil 8 $\xE894 210 32 161 242 #undo 8 'Undo' 1 1 nil nil 8 $\xE7A7 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 13 1 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 142 15 0 0 35 0 0 0] 193 50 2 8 1140857676 131137 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_Fluent_File_tools
	"Answer the literal data from which the 'Fluent File tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Fluent_File_tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409293132 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 4 1350 1 #{UI.ToolbarTextButton} 32 161 1350 4 #{UI.CommandDescription} #fileNew 8 'New' 1 1 nil nil 8 $\xE8A5 210 32 161 242 #fileOpen 8 'Open' 1 1 nil nil 8 $\xE8E5 210 32 161 242 #fileSave 8 'Save' 1 1 nil nil 8 $\xE105 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 13 1 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 79 15 0 0 35 0 0 0] 193 50 2 8 1140857676 131137 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_Fluent_Find_tools
	"Answer the literal data from which the 'Fluent Find tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Fluent_Find_tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409293132 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 3 1350 1 #{UI.ToolbarTextButton} 32 161 1350 4 #{UI.CommandDescription} #find 8 'Find' 1 1 nil nil 8 $\xE721 210 32 161 242 #findNext 8 'Find Next' 1 1 nil nil 8 $\xE893 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 13 1 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 61 15 0 0 35 0 0 0] 193 50 2 8 1140857676 131137 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_Fluent_Font_Tools
	"Answer the literal data from which the 'Fluent Font Tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Fluent_Font_Tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409293132 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 8 1350 1 #{UI.ToolbarTextButton} 32 161 1350 4 #{UI.CommandDescription} #chooseSelectionFont 8 'Font…' 1 1 nil nil 8 $\xE8D2 210 32 161 242 #toggleBold 8 'Bold' 1 1 nil nil 8 $\xE8DD 210 32 161 242 #toggleItalic 8 'Italic' 1 1 nil nil 8 $\xE8DB 210 32 161 242 #toggleUnderlined 8 'Underlined' 1 1 nil nil 8 $\xE8DC 210 32 161 242 #toggleStrikeout 8 'Strikethrough' 1 1 nil nil 8 $\xEDE0 210 32 161 242 #chooseSelectionColor 8 'Text Color…' 1 1 nil nil 8 $\xE8D3 210 32 161 242 #chooseSelectionBackcolor 8 'Text highlight color…' 1 1 nil nil 8 $\xE7E6 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 13 5 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 184 15 0 0 35 0 0 0] 193 50 2 8 1140857676 131137 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_Fluent_Paragraph_Tools
	"Answer the literal data from which the 'Fluent Paragraph Tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Fluent_Paragraph_Tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409293132 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 4 1350 1 #{UI.ToolbarTextButton} 32 161 1350 4 #{UI.CommandDescription} #alignParagraphLeft 8 'Align text left' 1 1 nil nil 8 $\xE8E4 210 32 161 242 #alignParagraphCenter 8 'Center' 1 1 nil nil 8 $\xE8E3 210 32 161 242 #alignParagraphRight 8 'Align text right' 1 1 nil nil 8 $\xE8E2 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 13 1 nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 79 15 0 0 35 0 0 0] 193 50 2 8 1140857676 131137 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_History_tools
	"Answer the literal data from which the 'History tools' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_History_tools)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409289036 131137 32 nil nil nil 517 nil nil nil 32 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 50 3 1094 1 #{UI.ToolbarIconButton} 32 17 1350 4 #{UI.CommandDescription} 518 #{Core.Message} #historyBack 8 #() 8 'Back to <d:…>' 1 17 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'HistoryBack.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil 210 32 17 242 274 #historyForward 8 #() 8 'Forward to <d:…>' 1 17 338 nil true 370 8 'HistoryForward.ico' 432 65541 nil nil 582 1 #{UI.ToolbarSeparator} 32 1 nil nil 9 nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 83 15 0 0 35 0 0 0] 193 80 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

resource_Tool_bar
	"Answer the literal data from which the 'Tool bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Tool_bar)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Toolbar} 38 #{Core.Array} 28 nil nil 50 2 8 1409288972 131137 32 nil 6 #{Graphics.Color} #default nil 517 nil nil nil 32 128 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 8 #() nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 9 nil nil nil nil 838 1 #{UI.FlowLayout} 1 1 1 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 93 16 0 0 35 0 0 0] 193 80 8 '' 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 31)!

stbConvert: anArray fromVersion: verInteger
	"Convert from earlier version view by updating and answering the array of instance variables (for the View), instVarArray."

	| instVars |
	instVars := super stbConvert: anArray fromVersion: verInteger.
	verInteger < 15 ifTrue: [instVars := self stbConvertFromVersion14: instVars].
	^instVars!

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
	(anArray at: 6) = Color.Face3d ifTrue: [anArray at: 6 put: Color default].
	^super stbConvertFromVersion12: anArray!

stbConvertFromVersion13: anArray
	"Private - Perform an STB conversion from a version 13 `Toolbar` to version 14.
	Version 14 adds a tipText instance variable to the superclass (and a couple of spares). The former tipText instance variable of Toolbar is now used for 'indent'"

	"D6 and earlier had an odd default bitmap size of 16@15 for toolbars, and these may still be present in v13 toolbars"

	(anArray at: 22) = (16 @ 15) ifTrue: [anArray at: 22 put: 16 @ 16].
	anArray at: 24 put: nil.
	^super stbConvertFromVersion13: anArray!

stbConvertFromVersion14: anArray
	"Private - Perform an STB conversion from a version 14 `Toolbar` to version 15. The only change is that the image size becomes a named logical value rather than a point size."

	^anArray
		at: 25 put: (ImageSizes keyAtEqualValue: (anArray at: 25) ifAbsent: [#smallIcons]);
		yourself!

stbVersion
	"15: bitmapSize <Point> changes to imageSize <Symbol> - physical sizes are confusing with DPI scaling"

	^15!

themePartName
	^#Toolbar!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'ToolbarWindow32'
! !

!UI.Toolbar class categoriesForMethods!
initialize!class initialization!public! !
resource_Default_view!public!resources-views! !
resource_Edit_tools!public!resources-views! !
resource_File_tools!public!resources-views! !
resource_Find_tools!public!resources-views! !
resource_Fluent_Edit_tools!public!resources-views! !
resource_Fluent_File_tools!public!resources-views! !
resource_Fluent_Find_tools!public!resources-views! !
resource_Fluent_Font_Tools!public!resources-views! !
resource_Fluent_Paragraph_Tools!public!resources-views! !
resource_History_tools!public!resources-views! !
resource_Tool_bar!public!resources-views! !
stbConvert:fromVersion:!binary filing!public! !
stbConvertFromVersion12:!binary filing!private! !
stbConvertFromVersion13:!binary filing!private! !
stbConvertFromVersion14:!binary filing!private! !
stbVersion!binary filing!public! !
themePartName!constants!private! !
winClassName!constants!private! !
!

