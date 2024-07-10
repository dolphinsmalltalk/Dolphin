"Filed out from Dolphin Smalltalk"!

UI.IconicListAbstract
	subclass: #'UI.TreeView'
	instanceVariableNames: 'handleObjectMap indentSeparation viewMode tvFlags objectHandleMap tvStyle updateMode _unused29 _unused30 _unused31 _unused32 _unused33 _unused34'
	classVariableNames: ''
	imports: #(#{OS.TreeViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'DisableExpandAllMask' -> 16r1.
			'LegacyUpdateModeMask' -> 16r6.
			'UpdateModes'
				-> (IdentityDictionary withAll: {
								#dynamic -> TreeViewDynamicUpdateMode.
								#lazy -> TreeViewLazyUpdateMode.
								#static -> TreeViewStaticUpdateMode
							})
		}!

UI.TreeView guid: (Core.GUID fromString: '{87b4c732-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.TreeView comment: 'TreeView is a <treeView> wrapping the Windows "SysTreeView32" common control. It is for single selection use and, therefore, implements the <selectableItems> protocol for use with any <treeModel>. 

A TreeView is capable of displaying its items in one of three modes (#smallIcons, #largeIcons, #noIcons) which can be set using the #viewMode aspect. 

The refresh mode of a tree can be controlled with the #updateMode aspect. The tree can be configured to re-request the icon and text for items on every repaint (#dynamic), or to request the icon and text on first paint only (#lazy), or to request the icon and text when the nodes are added (#static). The dynamic mode is most commonly used, and is the easiest way to have changes reflected immediately. #lazy is useful where the tree is potentially large and calculating the icon or text is expensive. #static is useful where there may be synchronisation issues between repainting and the tree model changing behind the scenes.

Instance Variables:
	handleObjectMap	<LookupTable> of Windows tree view handles to item <Object>s
	indentSeparation		<integer> indentation in pixels of each tree level.
	viewMode			<Symbol>  describing the mode in which the tree is displaying items.
	tvFlags				<integer>. Various flags.
	_unused			Reserved for future use
	
Class Variables:
	DisableExpandAllMask	<integer> mask applied against tvFlags
	NonVirtualMask			<integer> mask applied against tvFlags
	TvnMap				<Array> mapping TVN??? notification messages to <selector>s.
	UpdateModes			<Array> 
	UpdateModeMask		<integer> mask for extracting updateMode from tvFlags



'!

!UI.TreeView categoriesForClass!MVP-Views! !

!UI.TreeView methodsFor!

addRoot: anObject
	updateMode
		addItems: { anObject }
		inHandle: TVGN_ROOT
		afterHandle: TVI_LAST.
	self hasLinesAtRoot ifFalse: [self expand: anObject]!

applyExtendedStyles
	"Private - Apply any extended TreeView styles after view creation or recreation. 
	At present these are not configurable - we just hard-code the use of double-buffering to reduce flickering, which can otherwise be very noticeable with custom-drawing, especially if the CDIS_DISABLED state is used."

	User32
		sendMessageU: handle
		msg: TVM_SETEXTENDEDSTYLE
		wParam: TVS_EX_DOUBLEBUFFER
		lParam: TVS_EX_DOUBLEBUFFER!

applyImageLists
	"Private - Set the receiver's image lists from the image managers."

	| imList stateImList imageSize |
	imageSize := self imageExtent.
	imList := imageSize > 0
				ifTrue: 
					[stateImList := self stateImageManager ifNotNil: [:sim | sim imageListWithExtent: imageSize].
					self imageManager imageListWithExtent: imageSize].
	User32
		sendMessageU: handle
			msg: TVM_SETIMAGELIST
			wParam: TVSIL_NORMAL
			lParam: imList asParameter;
		sendMessageU: handle
			msg: TVM_SETIMAGELIST
			wParam: TVSIL_STATE
			lParam: stateImList asParameter!

basicAdd: anObject atIndex: anInteger 
	"Private - Adds an item to the list view at the index given by anInteger"

	^self shouldNotImplement!

basicClear
	"Private - Clears all items from the tree view and also clears the map"

	"First empty the handle object map so we don't respond to any messages when selection, etc, reset."

	self newMaps.
	"The Windows tree view control appears to send repeated selection change messages as item are deleted. Prevent this by resetting the selection here"
	self resetSelection.

	"Now delete all elements"
	User32
		sendMessage: handle
		msg: TVM_DELETEITEM
		wParam: 0
		lParam: TVI_ROOT!

basicEditItemLabel: hItem
	"Private - Initiate in-place editing of the item in the receiver with the specified
	handle. Answers the handle of the edit control (or 0 if fails)."

	^self
		sendMessage: TVM_EDITLABELW
		wParam: 0
		lParam: hItem asParameter!

basicItemFromPoint: aPoint
	"Private - Answer a TVHITTESTINFO populated with details of the item under the <Point>
	argument."

	| struct |
	struct := TVHITTESTINFO position: aPoint.
	self
		sendMessage: TVM_HITTEST
		wParam: 0
		lpParam: struct.
	^struct!

basicParentOf: aHandle
	"Private - Answer the handle of the parent of the item in the receiver with handle, aHandle."

	^User32
		sendMessageU: handle
		msg: TVM_GETNEXTITEM
		wParam: TVGN_PARENT
		lParam: aHandle!

basicRefreshContents
	| roots |
	self basicClear.
	roots := self model roots.
	roots isEmpty ifTrue: [^self].
	updateMode
		addItems: roots
		inHandle: TVGN_ROOT
		afterHandle: TVI_LAST.
	self hasLinesAtRoot ifFalse: [roots reverseDo: [:each | self expand: each]]!

basicRemove: aHandle
	"Private - Remove the object with aHandle from the TreeView and from the receiver's map.
	Answer aHandle.
	Implementation Note: We first remove the handle from the map as the TreeView may, oddly,
	ask for display details for the item we are removing (in particular whether it has children
	if using children callback mode) and this will cause confusion if our model has already
	removed the item."

	objectHandleMap removeKey: (handleObjectMap removeKey: aHandle).
	User32
		sendMessage: handle
		msg: TVM_DELETEITEM
		wParam: 0
		lParam: aHandle.
	^aHandle!

basicRemoveAtIndex: anInteger
	"Private - Delete the item with the specified <integer> handle."

	^self shouldNotImplement!

basicResetSelection
	"Private - Clear all selections. Do not issue a selection changed
	notification."

	^self 
		sendMessage: TVM_SELECTITEM
		wParam: TVGN_CARET
		lParam: 0!

beDefaultThemed
	self hasHotTracking: true.
	super beDefaultThemed!

collapse: anObject
	"Collapse the displayed hierarchy below anObject, triggering a selection
	change event if one of the children of the object was previously selected.
	Note that we ask the tree view to actually remove the nodes. This saves
	memory and makes the tree behave in a more dynamic fashion, since 
	when it is re-expanded it will pick up any changes in the model."

	self collapseHandle: (self handleFromObject: anObject)!

collapseHandle: aHandle
	| selection |
	selection := self selectionOrNil.
	User32
		sendMessage: handle
		msg: TVM_EXPAND
		wParam: ##(TVE_COLLAPSE bitOr: TVE_COLLAPSERESET)
		lParam: aHandle.
	(self isSelected: selection)
		ifFalse: 
			["The selection was changed"
			self onSelChanged: nil]!

connectModel
	"Connect the receiver to its model, wiring events, etc.
	Implementation Note: Completely replace the superclass implementation, as 
	<TreeModel>s publish a completely different set of events."

	self model 
		when: #treeChanged: send: #onTreeChanged: to: self;
		when: #item:addedInParent: send: #onItem:addedInParent: to: self;
		when: #item:removedFromParent: send: #onItem:removedFromParent: to: self;
		when: #item:movedToParent: send: #onItem:movedToParent: to: self;
		when: #itemUpdated: send: #onItemUpdated: to: self!

customDrawContextClass
	"Private - Answer the class of NM??CUSTOMDRAW structure associated with the receiver."

	^NMTVCUSTOMDRAW!

defaultWindowStyle
	"Private - Answer a default base style to use when creating a TreeView."

	^super defaultWindowStyle bitOr: ##(TVS_HASBUTTONS | TVS_HASLINES | TVS_SHOWSELALWAYS)!

displayedContents
	"Answers the displayed contents of the receiver. These may be different from the contents of the model
	if the receiver hasn't yet chosen to display all of the model items"

	^handleObjectMap values!

editLabelStyle
	"Private - Answer the <integer> style mask used to control whether label editing is enabled
	in the receiver's control."

	^TVS_EDITLABELS!

ensureVisible: aHandle
	"Ensure that the tree view node represented by aHandle is visible 
	by scrolling the receiver's window appropriately"

	^(self sendMessage: TVM_ENSUREVISIBLE wParam: 0 lParam: aHandle) asBoolean
	

!

expand: anObject
	"Expand anObject to show its children."

	(self handleFromObject: anObject)
		ifNotNil: 
			[:hItem |
			User32
				sendMessage: handle
				msg: TVM_EXPAND
				wParam: TVE_EXPAND
				lParam: hItem]!

expandAll
	"Expand the entire tree below the current selection."

	Cursor wait showWhile: [self expandAll: self selectionOrNil]!

expandAll: anObject 
	"Expand the complete hierarchy below anObject (i.e. expand the node and, recursively, 
	all its sub-nodes)."

	self expand: anObject.
	(self model childrenOf: anObject) do: [:each | self expandAll: each].
!

findNode: anObject
	^(self handleFromObject: anObject)
		ifNil: 
			["Maybe the object does not exist in the model, so lets check"
			(self model includes: anObject) ifFalse: [^nil].
			"The object is not yet expanded in the tree"
			(self model allParentsOf: anObject) do: [:each | self expand: each].
			self handleFromObject: anObject]!

forecolor: aColorOrNil
	"Sets the foreground colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	| clrref |
	super forecolor: aColorOrNil.
	clrref := (aColorOrNil ?? Color.WindowText) asCOLORREF.
	self
		sendMessage: TVM_SETTEXTCOLOR
		wParam: 0
		lParam: clrref!

getEditControl
	^self sendMessage: TVM_GETEDITCONTROL

!

getItemState: anExternalHandle
	| tvItem |
	tvItem := (TVITEMW hItem: anExternalHandle)
				mask: ##(TVIF_CHILDREN | TVIF_STATE);
				yourself.
	User32
		sendMessage: handle
		msg: TVM_GETITEMW
		wParam: 0
		lpParam: tvItem.
	^tvItem!

getItemText: itemHandle
	| tvItem |
	tvItem := (TVITEMW hItem: itemHandle)
				newTextBuffer: 128;
				yourself.
	User32
		sendMessage: handle
		msg: TVM_GETITEMW
		wParam: 0
		lpParam: tvItem.
	^tvItem pszText!

getSelectionsByIndex
	"Private - Query the control for the current selection"

	| selection |
	selection := User32
				sendMessageU: handle
				msg: TVM_GETNEXTITEM
				wParam: TVGN_CARET
				lParam: nil.
	^selection == 0 ifTrue: [#()] ifFalse: [{ selection }]!

getSingleSelection
	"Private - Answer the 'index' (or in the case of the receiver, the handle) of the selected object in 
	the receiver, or zero if there is no selection."

	^User32
		sendMessageU: handle
		msg: TVM_GETNEXTITEM
		wParam: TVGN_CARET
		lParam: nil!

handleFromObject: anObject
	^objectHandleMap lookup: anObject!

handleFromObject: anObject ifAbsent: exceptionHandler
	"Private - Answer the handle associated with anObject in the receiver,
	or the result of evaluating the <niladicValuable>, exceptionHandler,
	if the object is not found."

	^objectHandleMap at: anObject ifAbsent: exceptionHandler!

hasAutomaticHorizontalScrolling
	"Answer whether the view will scroll automatically in the horizontal plane to bring items into view."

	^tvStyle allMask: TVS_EX_AUTOHSCROLL!

hasAutomaticHorizontalScrolling: aBoolean
	"Set whether the view will scroll automatically in the horizontal plane to bring items into view."

	"Contrary to the documentation this does not remove the horizontal scroll bar, rather it moves the viewing window left or right as it judges appropriate for the selection or mouse position."

	self treeViewStyleMask: TVS_EX_AUTOHSCROLL set: aBoolean!

hasButtons
	"Answer whether the receiver has expand/contract buttons associated
	with its nodes which the user can single click over to expand/contract the
	nodes children."

	^self baseStyleAllMask: TVS_HASBUTTONS!

hasButtons: aBoolean
	"Set whether the receiver has expand/contract buttons associated
	with its nodes which the user can single click over to expand/contract the
	nodes children. Can be changed dynamically without recreating
	the underlying control."

	self baseStyleMask: TVS_HASBUTTONS set: aBoolean recreateIfChanged: false!

hasCheckBoxes
	"Answer whether the receiver has check-boxes associated with its items."

	^self baseStyleAllMask: TVS_CHECKBOXES!

hasCheckBoxes: aBoolean
	"Sets the receiver to either have or not have check-boxes associated with its items.
	Note that this style is permanent and requires a re-create to take effect."

	self baseStyleMask: TVS_CHECKBOXES set: aBoolean recreateIfChanged: true!

hasFadingExpandos
	"Answer whether the expandos in the tree fade away when not hovering over it."

	"N.B. this flickers a lot without double-buffering enabled (see #isDouble Buffered)."

	^tvStyle allMask: TVS_EX_FADEINOUTEXPANDOS!

hasFadingExpandos: aBoolean
	"Set whether the expandos in the tree fade away when not hovering over it."

	"N.B. this flickers a lot without double-buffering enabled (see #isDouble Buffered)."

	self treeViewStyleMask: TVS_EX_FADEINOUTEXPANDOS set: aBoolean!

hasFullRowSelect
	"Answer whether the receiver highlights the whole row when a selection is made, or just the label."

	^self baseStyleAllMask: TVS_FULLROWSELECT!

hasFullRowSelect: aBoolean
	self baseStyleMask: TVS_FULLROWSELECT set: aBoolean recreateIfChanged: false!

hasHotTracking
	"Answer whether the receiver has the hot-tracking style."

	^self baseStyleAllMask: TVS_TRACKSELECT!

hasHotTracking: aBoolean
	"Sets the receiver into or out of hot-tracking mode."

	self baseStyleMask: TVS_TRACKSELECT set: aBoolean recreateIfChanged: false!

hasInfoTips
	"Answer whether the receiver has Info. Tips (per-item bubble help popped when hovering)."

	^self baseStyleAllMask: TVS_INFOTIP!

hasInfoTips: aBoolean
	"Sets whether the receiver has Info. Tips (per-item bubble help popped when hovering)."

	self baseStyleMask: TVS_INFOTIP set: aBoolean recreateIfChanged: false!

hasLines
	"Answer whether the receiver has lines connecting its nodes."

	^self baseStyleAllMask: TVS_HASLINES!

hasLines: aBoolean
	"Set whether the receiver has lines connecting its nodes.
	This style can be changed dynamically without recreating the underlying
	control."

	self baseStyleMask: TVS_HASLINES set: aBoolean recreateIfChanged: false!

hasLinesAtRoot
	"Answer whether the receiver has lines and buttons for its root entries."

	^self baseStyleAllMask: TVS_LINESATROOT!

hasLinesAtRoot: aBoolean
	"Sets the receiver to have lines and buttons for its root entries
	depending on the value of aBoolean. This is the TVS_LINESATROOT style,
	which can be changed dynamically without needing to recreate the control."

	self baseStyleMask: TVS_LINESATROOT set: aBoolean recreateIfChanged: false!

hasSelection
	^self selectionByIndex ~~ 0!

hideDropHighlight
	"Private - Hide any drop highlight within the receiver."

	super hideDropHighlight.
	self sendMessage: TVM_SELECTITEM wParam: TVGN_DROPHILITE lParam: nil; update!

includesItem: anObject 
	"Answer whether the argument is displayed in this tree."

	^(self handleFromObject: anObject) notNil!

indentSeparation
	"Answer the pixel identation of child items from their parents excluding
	the width of the current set of icons being shown."

	^indentSeparation!

indentSeparation: anIntegerOrNil
	"Set the pixel identation of child items from their parents excluding the width of the
	current set of icons being shown. Setting the indent to nil will cause the use of the
	default setting of the control."

	indentSeparation := anIntegerOrNil.
	self updateIndentation.!

initialize
	"Private - Initialise the instance on creation."

	super initialize.
	viewMode := #noIcons.
	tvStyle := tvFlags := 0.
	"Default to dynamic/virtual mode where the tree does not hold any data required for display, but requests it every time painting is required."
	updateMode := TreeViewDynamicUpdateMode forIconicList: self!

isDoubleBuffered
	"Answer whether the tree display is double-buffered to avoid flicker. This is useful for trees that are frequently updated by background events."

	^tvStyle allMask: TVS_EX_DOUBLEBUFFER!

isDoubleBuffered: aBoolean 
	"Set whether thet tree display is double-buffered to avoid flicker. This is useful for	trees that are frequently updated by background events."

	self treeViewStyleMask: TVS_EX_DOUBLEBUFFER set: aBoolean!

isExpandAllEnabled
	"Answer whether the tree will expand all nodes below the selected node when the '*' key is
	pressed on the numeric pad. This is enabled by default, but should be turned off if the tree
	is very large or contains cycles."

	^tvFlags noMask: DisableExpandAllMask!

isExpandAllEnabled: aBoolean
	"Set whether the tree will expand all nodes below the selected node when the '*' key is
	pressed on the numeric pad. This is enabled by default, but should be turned off if the tree
	is very large or contains cycles."

	tvFlags := tvFlags mask: DisableExpandAllMask set: aBoolean not!

isExpanded: anObject
	"Answers if the node associated with anObject is expanded."

	| hItem |
	hItem := objectHandleMap lookup: anObject.
	^hItem notNil and: [(self getItemState: hItem) dwState allMask: TVIS_EXPANDED]!

isLargeIcons
	"Answer true if the receiver is in large icon mode."

	^self viewMode == #largeIcons!

isMonoExpandable
	"Answer whether the receiver has the single-expand style."

	^self baseStyleAllMask: TVS_SINGLEEXPAND!

isMonoExpandable: aBoolean
	"Sets the receiver into or out of single-expand mode."

	self baseStyleMask: TVS_SINGLEEXPAND set: aBoolean recreateIfChanged: false!

isSelected: anObject
	"Answer whether the <Object> argument is the selected item in the tree."

	^self model searchPolicy 
		compare: self selectionOrNil with: anObject!

isSmallIcons
	"Answer true if the receiver is in small icon mode."

	^self viewMode == #smallIcons!

isVirtual
	"Answer true if the receiver configures the tree to ask for text and images by callback (i.e. lazy or dynamic mode).
	To configure the tree in non-virtual mode the #updateMode should be set to #static."

	^updateMode isVirtual!

itemCount
	"Answer the total number of items in the view."

	^self sendMessage: TVM_GETCOUNT!

itemRect: itemHandle textOnly: aBoolean
	"Answers the <Rectangle> surrounding the receiver's item with the specified handle, optionally for the text part of the label only."

	| rect |
	rect := RECTL newBuffer.
	"The handle of the item being queried is passed in the output RECT buffer"
	rect bytes uintPtrAtOffset: 0 put: itemHandle asInteger.
	User32
		sendMessage: handle
		msg: TVM_GETITEMRECT
		wParam: aBoolean asParameter
		lpParam: rect.
	^rect asRectangle!

itemStructure
	^TVITEMW!

minimumIndent
	"Private - Answer the minimum indent separation. This includes the width of any images."

	^16!

newMaps
	"Private -"

	"Not IdentityDictionary as handles may be large ints"

	handleObjectMap := LookupTable new.
	objectHandleMap := self model searchPolicy newLookupTable!

nmDeleteItem: pNMHDR
	"Private - Default handler for the TVN_DELETEITEM notification message.
	Remove the itemOld object from our map if it is present."

	handleObjectMap isEmpty
		ifFalse: 
			[(handleObjectMap
				removeKey: (pNMHDR uintPtrAtOffset: ##(NMTREEVIEWW._OffsetOf_itemOld + TVITEMW._OffsetOf_hItem))
				ifAbsent: nil) ifNotNil: [:object | objectHandleMap removeKey: object]].
	"Answer nil to accept the default processing (which we must do or the TreeView leaks... apparently, although I can't see why it would since this is a notification originally sent to the parent?)."
	^nil!

nmNotify: pNMHDR
	"Private - Handler for a redirected TreeView WM_NOTIFY message."

	^(##((Array new: TVN_FIRST - TVN_ENDLABELEDITW + 1 withAll: #nmDummy:)
		at: TVN_FIRST - TVN_SELCHANGINGW + 1 put: #tvnSelChanging:;
		at: TVN_FIRST - TVN_SELCHANGEDW + 1 put: #nmSelChanged:;
		at: TVN_FIRST - TVN_GETDISPINFOW + 1 put: #nmGetDispInfoW:;
		at: TVN_FIRST - TVN_SETDISPINFOW + 1 put: #nmSetDispInfoW:;
		at: TVN_FIRST - TVN_ITEMEXPANDINGW + 1 put: #tvnItemExpanding:;
		at: TVN_FIRST - TVN_ITEMEXPANDEDW + 1 put: #tvnItemExpanded:;
		at: TVN_FIRST - TVN_BEGINDRAGW + 1 put: #nmBeginDrag:;
		at: TVN_FIRST - TVN_BEGINRDRAGW + 1 put: #nmBeginRDrag:;
		at: TVN_FIRST - TVN_DELETEITEMW + 1 put: #nmDeleteItem:;
		at: TVN_FIRST - TVN_KEYDOWN + 1 put: #nmKeyDown:;
		at: TVN_FIRST - TVN_GETINFOTIPW + 1 put: #tvnGetInfoTip:;
		at: TVN_FIRST - TVN_ASYNCDRAW + 1 put: #tvnAsyncDraw:;
		at: TVN_FIRST - TVN_ITEMCHANGINGW + 1 put: #tvnItemChanging:;
		at: TVN_FIRST - TVN_ITEMCHANGEDW + 1 put: #tvnItemChanged:;
		at: TVN_FIRST - TVN_BEGINLABELEDITW + 1 put: #nmBeginLabelEdit:;
		at: TVN_FIRST - TVN_ENDLABELEDITW + 1 put: #nmEndLabelEdit:;
		yourself) lookup: ##(TVN_FIRST + 1) - (pNMHDR int32AtOffset: NMHDR._OffsetOf_code))
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

nmRClick: pNMHDR
	"Handle the NM_RCLICK notification message. 
	Implementation Note: We make some slight modifications to the TreeView control's default behaviour here:
		1) Add selection on right click.
		2) Pop context menu on right click.
	We take control of the triggering a context menu for the tree, because the control's behaviour is rather 
	irregular (see Microsoft Knowledge Base article Q222905).

	Note that the TreeView is unusual among Windows' controls in that it only changes selection on
	mouse up, not on mouse down. We stick with this as it has the useful property that drags can be
	initiated with an item other than the current selection.
	"

	| newSel pt curSel |
	pt := Cursor position.
	newSel := self selectionFromPoint: (self mapScreenToClient: pt).
	curSel := self selectionByIndex.
	(newSel = curSel or: 
			["Selection change permitted?"
			(self
				onSelChangingFrom: (self objectFromHandle: curSel ifAbsent: nil)
				to: (self objectFromHandle: newSel ifAbsent: nil)
				cause: #mouse) and: 
						[self selectionByIndex: newSel.
						true]])
		ifTrue: 
			[self
				sendMessage: WM_CONTEXTMENU
				wParam: handle
				lParam: pt asUIntPtr].
	"Return non-zero to prevent the default processing"
	^TRUE!

notificationClass
	"Private - Answer the class of NMXXXXVIEW structure associated with the receiver."

	^NMTREEVIEWW!

objectFromHandle: aHandle ifAbsent: exceptionHandler
	"Private - Answer the object in the receiver associated with aHandle,
	or the result of evaluating the <niladicValuable>, exceptionHandler,
	if the handle is not in the map."

	^handleObjectMap at: aHandle ifAbsent: exceptionHandler!

onDestroyed
	"Private - Handler for window destruction notification.
	Implementation Note: In order to speed up deletion we first reset the handleObjectMap so that
	the item deletion notifications are handled more speedily - unfortunately
	we can't turn them off altogether, as then the tree leaks."

	self newMaps.
	^super onDestroyed!

onDisplayDetailsRequired: aTVITEM
	"Private - Get the display info for the requested <TVITEM>."

	| object requestMask |
	object := handleObjectMap lookup: aTVITEM hItem.
	"The TreeView sometimes asks for display details for items that are being removed, or are being added but for which we do not yet have the handle"
	object ifNil: [^0].
	requestMask := aTVITEM mask.
	(requestMask allMask: TVIF_CHILDREN)
		ifTrue: 
			[aTVITEM children: (model hasChildren: object) asParameter.
			"If only requesting children details, tell the control to not ask again, regardless of updateMode"
			requestMask == TVIF_CHILDREN
				ifTrue: 
					[aTVITEM maskIn: TVIF_DI_SETITEM.
					^0]].
	((requestMask allMask: TVIF_IMAGE) and: [self hasIcons])
		ifTrue: 
			[aTVITEM
				images: ((self getImageBlock ifNotNil: [:getImage | getImage value: object]) ?? ##(I_IMAGENONE + 1))
						- 1].
	(requestMask allMask: TVIF_TEXT) ifTrue: [aTVITEM textInBuffer: (self getTextBlock value: object)].
	updateMode viewStoresItemData ifTrue: [aTVITEM maskIn: TVIF_DI_SETITEM].
	"Suppress default processing"
	^0!

onItem: anObject addedAtIndex: anIntegerIndex 
	"Event received when anObject has been added to the receiver's
	model at anIntegerIndex. Trees use #onItem:addedInParent:"

	^self shouldNotImplement!

onItem: anObject addedInParent: aParentObject
	"Event received when anObject has been added to the receiver's
	model within aParentObject."

	"Update parent if it has gained its first child."

	| parentHandle parentTvItem siblings previousSiblingIndex previousSiblingHandle |
	aParentObject isNil
		ifTrue: 
			["Adding a root object"
			self addRoot: anObject.
			^self].

	"Get the TVITEM structure for the parent"
	(parentHandle := self handleFromObject: aParentObject) ifNil: [^self].
	parentTvItem := self getItemState: parentHandle.
	"#348: When TVM_GETITEM is sent the control, if it has not previously been repainted, may send back a 
	children callback to request the number of children of the parent, to which the answer is now '1' (since that 
	is determined by asking the model). However the control does not display the expansion button in this case
	(a bug), so we must refresh it even if there is already one child just in case."
	parentTvItem cChildren <= 1 ifTrue: [self refreshHasChildren: parentHandle].
	parentTvItem isStateExpandedOnce ifFalse: [^self].
	(self handleFromObject: anObject)
		ifNotNil: 
			["Don't add it again, e.g. when !!hasLinesAtRoot addition of new root expands the immediate children 
			automatically so when adding a chain up to the root the node may already have been added."
			^self].
	siblings := self model childrenOf: aParentObject.
	previousSiblingIndex := (self model
				keyOfNode: anObject
				in: siblings
				ifAbsent: 0) - 1.

	"The model may have added more than one sibling, so we have to locate the first of them that we know about currently"
	previousSiblingHandle := nil.
	
	[previousSiblingIndex > 0
		and: [(previousSiblingHandle := self handleFromObject: (siblings at: previousSiblingIndex)) isNil]]
			whileTrue: [previousSiblingIndex := previousSiblingIndex - 1].
	updateMode
		addItems: { anObject }
		inHandle: parentHandle
		afterHandle: previousSiblingHandle ?? TVI_FIRST!

onItem: anObject movedToParent: aParentObject 
	"Event received when anObject has been moved in the receiver's
	hierarchy to be a child of aParentObject."

	self presenter noEventsDo: 
			["Add new node and remove old one"
			| selection |
			selection := self selectionOrNil.
			(self handleFromObject: anObject) 
				ifNotNil: 
					[:hItem | 
					| hParent |
					hParent := self basicParentOf: hItem.
					self basicRemove: hItem.
					self refreshHasChildren: hParent].
			self onItem: anObject addedInParent: aParentObject.
			"Allow for the fact that the item may no longer be in tree because the parent is not"
			self restoreSelection: selection]!

onItem: anObject removedAtIndex: anInteger 
	"Event received when the <Object>, anObject, has been removed from the receiver's
	model at the <integer> index, anInteger. Trees use #onItem:removedFromParent:."

	^self shouldNotImplement!

onItem: anObject removedFromParent: aParentObject
	"Event received when anObject has been removed from the receiver's
	model from aParentObject"

	(self handleFromObject: anObject)
		ifNotNil: 
			[:hItem |
			| hParent selectionBugWorkaroundRequired |
			hParent := self basicParentOf: hItem.
			"Work around TreeView bug - it doesn't send selection change event when the last item is deleted"
			selectionBugWorkaroundRequired := hParent isNull and: [self model isEmpty].
			self basicRemove: hItem.
			selectionBugWorkaroundRequired ifTrue: [self onSelChanged: nil].
			hParent notNull ifTrue: [self refreshHasChildren: hParent]]!

onItem: anObject updatedAtIndex: anInteger 
	"TreeView's cannot be connected directly to a ListModel."

	^self shouldNotImplement!

onItems: anObject addedAtIndex: anIntegerIndex 
	"Event received when anObject has been added to the receiver's
	model at anIntegerIndex. Trees use #onItem:addedInParent:"

	^self shouldNotImplement!

onItemUpdated: anObject 
	"Event received when anObject has been updated.
	Refresh the tree representation of this object"

	self updateItem: anObject!

onSelChanging: anExternalAddress
	"Private - Selection is changing in the receiver as a direct result of user input. Details
	about the selection change are recorded in the <NMTREEVIEW> structure pointed at
	by the argument. A #selectionChanging: event is triggered to enquire as to whether the 
	selection change is permissible. If it is not then any observer that wishes to veto the change 
	must set the value of the <SelectionChangingEvent> to false."

	"Implementation Note: The TreeView is unusual among Windows controls in that it sends selection 
	changing notifications for programmatic changes, as well as for user input, so we have to identify
	and ignore these."

	| nmtv action |
	self isStateRestoring
		ifTrue: 
			["Selection changing notifications are not propagated during state restoral."
			^true].
	nmtv := NMTREEVIEWW fromAddress: anExternalAddress.
	action := nmtv action.
	"The TreeView sends a notification with the undocumented action code 4096 when it wants to reset
	 selection to the root. It doesn't seem to be happy without a selection, and tries to select the root whenever
	 reactivated with no selection. Answering false for any unexpected action codes prevents unwanted selection 
	changes from occurring."
	action > TVC_BYKEYBOARD ifTrue: [^false].
	^action == TVC_UNKNOWN or: 
			[self
				onSelChangingFrom: (self objectFromHandle: nmtv itemOld hItem ifAbsent: nil)
				to: (self objectFromHandle: nmtv itemNew hItem ifAbsent: nil)
				cause: (#(#mouse #keyboard) at: action)]!

onSelChangingFrom: oldSelection to: newSelection cause: aSymbol
	| event |
	event := SelectionChangingEvent forSource: self.
	event
		newSelection: newSelection;
		oldSelection: oldSelection;
		cause: aSymbol.
	"If the old selection is nil, and the source of the change is unknown, then  assume the 
	selection change cannot be prevented, as it may result from the deletion of an item."
	self presenter onSelectionChanging: event.
	^event value!

onTreeChanged: anObject
	"The tree structure below the argument has been changed. If nil this 
	indicates that the entire tree from the root down may have changed.
	Refresh the receiver appropriately.
	Implementation Note: Any notifications for objects not currently in 
	the tree are ignored (these might be because the model has been changed 
	but this tree view is not expanded to show the element in question)."

	anObject isNil ifTrue: [^self refreshContents].
	(self handleFromObject: anObject)
		ifNotNil: 
			[:hItem |
			self collapseHandle: hItem.
			updateMode updateItem: anObject at: hItem]!

onViewCreated
	"The receiver's window has been created. Copy across to it any information
	held in instance variables"

	super onViewCreated.
	self newMaps.
	"Some vagary of the TreeView causes the font to be incorrectly restored during ControlView>>onCreated. We force it again here"
	self applyFont.
	self refreshContents.
	tvStyle == 0
		ifFalse: 
			[User32
				sendMessage: handle
				msg: TVM_SETEXTENDEDSTYLE
				wParam: -1
				lParam: tvStyle].
	self updateIndentation.
	self applyExtendedStyles!

refreshContents
	"Repopulate the receiver with the elements of the receiver's model."

	self isOpen ifFalse: [^self].
	self noRedrawDo: [self basicRefreshContents]!

refreshHasChildren: anExternalHandle
	"Private - Update the TreeView's understanding of whether the element of the receiver	with the specified handle has children or not. This affects whether the TreeView displays an expansion button or not."

	| tvItem |
	tvItem := (TVITEMW hItem: anExternalHandle)
				childrenCallback;
				yourself.
	User32
		sendMessage: handle
		msg: TVM_SETITEMW
		wParam: 0
		lpParam: tvItem!

resetSelection
	"Sets the receiver to have no selected object."

	^self basicResetSelection!

resolutionScaledBy: aPoint
	"Private - The receiver is being loaded and it has been determined that the pixel resolution has changed since the point at which the view was saved. Scale any internal pixels by <Point>the point argument."

	indentSeparation isNil ifTrue: [^self].
	indentSeparation := (indentSeparation * aPoint x) truncated!

restoreSelection: anObject 
	"Private - Restore the selection in the receiver to be the <Object> argument, if that object
	is still in the tree."

	self selection: anObject ifAbsent: []!

selection: anObject ifAbsent: exceptionHandler
	"Select the first occurrence of the <Object>, anObject, in the receiver
	and answer it. If there are no occurrences then answer the
	result of evaluating the <niladicValuable>, exceptionHandler."

	| nodeHandle |
	anObject isNil ifTrue: [^self resetSelection].
	nodeHandle := (self findNode: anObject) ifNil: [^exceptionHandler cull: anObject].
	^(self selectionByIndex: nodeHandle ifAbsent: nil)
		ifNil: [exceptionHandler cull: anObject]
		ifNotNil: [anObject]!

selectionByIndex
	"Answer the 'index' (or in the case of the receiver, the handle) of the selected object in the receiver, or 0 if there is no selection."

	^User32
		sendMessageU: handle
		msg: TVM_GETNEXTITEM
		wParam: TVGN_CARET
		lParam: nil!

selectionByIndex: itemHandle ifAbsent: exceptionHandler
	"Select the object identified by the 'handle', itemHandle, in the receiver.
	Answer the 'handle' of the resulting selection (the selection might not
	change if the selection changing request is denied)."

	| oldSel |
	(oldSel := self selectionByIndex) = itemHandle
		ifFalse: 
			[(self setSingleSelection: itemHandle)
				ifTrue: [(self objectFromHandle: itemHandle ifAbsent: nil) ifNil: [^exceptionHandler value]]
				ifFalse: [^itemHandle]].
	"Either the selection was already that indicated or the change was refused by onSelChanging handlers"
	^oldSel!

selectionFromPoint: pos
	"Private - Answer the <integer> selection that would occur if a mouse click at the
	<Point>, pos, was passed to the control."

	^(self itemFromPoint: pos) ?? 0!

selectionIfNone: aBlock
	"Answer the selected object in the receiver or the
	result of evaluating aBlock if there is no selection."

	| h |
	h := self selectionByIndex.
	^h isNull ifTrue: [aBlock value] ifFalse: [self objectFromHandle: h ifAbsent: nil]!

selectionState
	"Private - Answer a <MessageSend> which, when evaluated, will restore the current selection, or nil if there is no selection to restore."

	| h |
	h := self selectionByIndex.
	^h == 0
		ifFalse: 
			[(self objectFromHandle: h ifAbsent: nil)
				ifNotNil: 
					[:selection |
					MessageSend
						receiver: self
						selector: #restoreSelection:
						argument: selection]]!

setControlBackcolor: aColor 
	self 
		sendMessage: TVM_SETBKCOLOR
		wParam: 0
		lParam: aColor asCOLORREF!

setSingleSelection: itemHandle 
	^(self 
		sendMessage: TVM_SELECTITEM
		wParam: TVGN_CARET
		lParam: itemHandle) == 0!

setViewMode: aSymbol 
	viewMode := aSymbol!

showDropHighlight: anItem
	"Private - Shows a drop highlight for anItem within the receiver."

	super showDropHighlight: anItem.
	self sendMessage: TVM_SELECTITEM wParam: TVGN_DROPHILITE lParam: anItem; update.!

showsSelAlways
	"Answers true if the receiver always displays its selection, if any, even
	if it doesn't have focus."

	^self baseStyleAllMask: TVS_SHOWSELALWAYS!

showsSelAlways: aBoolean 
	"Set whether the receiver always displays its selection, if any, even
	if it doesn't have focus."

	self 
		baseStyleMask: TVS_SHOWSELALWAYS
		set: aBoolean
		recreateIfChanged: true	"Recreate required to take effect"!

treeViewStyleMask: anInteger set: aBoolean
	"Private - Sets/clears the tree view extended style bits in the <integer> first argument according to the <Boolean> second argument. Answer the previous extended style flags."

	| valueMask prevStyle |
	valueMask := anInteger bitAnd: 0 - aBoolean asInteger.
	prevStyle := User32
				sendMessage: handle
				msg: TVM_SETEXTENDEDSTYLE
				wParam: anInteger
				lParam: valueMask.
	tvStyle := (prevStyle bitAnd: anInteger bitInvert) bitOr: valueMask.
	^prevStyle!

tvmInsertItem: anObject tvis: aTVINSERTSTRUCT
	| hItem |
	hItem := User32
				sendMessageU: handle
				msg: TVM_INSERTITEMW
				wParam: 0
				lpParam: aTVINSERTSTRUCT.
	hItem == 0 ifFalse: [objectHandleMap at: (handleObjectMap at: hItem put: anObject) put: hItem]!

tvmSetItem: tvItem
	User32
		sendMessage: self handle
		msg: TVM_SETITEMW
		wParam: 0
		lpParam: tvItem!

tvnGetInfoTip: pNMTVGETINFOTIPW
	"Private - Default handler for the TVN_GETINFOTIP notification message."

	getInfoTipBlock isNil
		ifFalse: 
			[| nmtv |
			nmtv := NMTVGETINFOTIPW fromAddress: pNMTVGETINFOTIPW.
			(self objectFromHandle: nmtv itemHandle ifAbsent: nil)
				ifNotNil: [:object | nmtv text: (getInfoTipBlock value: object)]].

	"The control ignores the return value for this notification code."
	^0!

tvnItemChanged: pNMTVITEMCHANGE
	"Private - Notification that an item in the tree has changed."

	"The documentation says to return FALSE to accept the change, or TRUE to prevent the change, but this is presumably a copy&paste error from TVN_ITEMCHANGING, since the item has already changed."

	^FALSE!

tvnItemChanging: pNMTVITEMCHANGE
	"Private - Notification that an item in the tree is about to change. Return FALSE to accept the change, or TRUE to prevent the change."

	^FALSE!

tvnItemExpanded: pNMHDR
	"Private - Default handler for the TVN_ITEMEXPANDEDW notification message."

	"Return value not used, but suppress needless call to DefWindowProc on the parent"

	^0!

tvnItemExpanding: pNMHDR
	"Private - Default handler for the TVN_ITEMEXPANDINGW notification message."

	| tviParent hParent |
	(pNMHDR uint32AtOffset: NMTREEVIEWW._OffsetOf_action) == TVE_EXPAND ifFalse: [^FALSE].
	tviParent := TVITEMW fromAddress: pNMHDR asInteger + NMTREEVIEWW._OffsetOf_itemNew.
	"See if we have been expanded before"
	tviParent isStateExpandedOnce ifTrue: [^FALSE].
	"If not, add the children"
	hParent := tviParent hItem.
	(self objectFromHandle: hParent ifAbsent: nil)
		ifNotNil: 
			[:parentObject |
			| children |
			children := self model childrenOf: parentObject.
			children isEmpty
				ifFalse: 
					[Cursor wait showWhile: 
							[updateMode
								addItems: children
								inHandle: hParent
								afterHandle: TVI_LAST]].
			"Inform the parent item that we don't want to be informed when we are expanded again"
			tviParent beStateExpandedOnce].
	^FALSE	"Allow the expansion to proceed - returning TRUE would prevent"!

tvnSelChanging: pNMHDR
	"Private - Default handler for the TVN_SELCHANGINGW notification message.
	Answer false to permit the selection to change, true to prevent it.
	Note that the tree view sends this for all selection changes, whether programmatically
	or user initiated."

	^(self onSelChanging: pNMHDR) not!

updateAll
	"Re-render the model's contents. This is a similar operation to #refreshContents, except that it is assumed that the models contents are the same objects, but may have changed internally so that their visual representation must be updated. The effect will depend on the current update mode:
		#dynamic - the view is just invalidated to trigger repaint, which will re-request text, icons, etc
		#lazy, #static - the view is asked to refresh each item individually."

	updateMode updateAllItems!

updateAllItems
	"Private - Update the text and images the tree view stores for each item in non-dynamic tree."

	handleObjectMap
		keysAndValuesDo: [:eachHandle :eachObject | updateMode updateItem: eachObject at: eachHandle]!

updateIndentation
	"Private - Update the identation of child items to reflect the current values
	of the icon extents and identSeparation."

	indentSeparation
		ifNil: 
			["Tell the control to use its default ident"
			self sendMessage: TVM_SETINDENT wParam: 0]
		ifNotNil: 
			[| imageWidth |
			imageWidth := self imageExtent x.
			self sendMessage: TVM_SETINDENT wParam: (imageWidth + indentSeparation max: self minimumIndent).
			indentSeparation := (self sendMessage: TVM_GETINDENT) - imageWidth]!

updateItem: anObject
	(self handleFromObject: anObject) ifNotNil: [:hItem | updateMode updateItem: anObject at: hItem]!

updateItem: anObject at: anInteger
	self shouldNotImplement!

updateMode
	"Answer the configured update mode, one of:
		#dynamic	- Display details re-requested by callback on every paint
		#lazy		- Supported by TreeView only. Display details initially requested by callback on first paint only
		#static		- Items fully populated with display details when first added
	The display details referred to are the label text, icon, and (in a tree) whether or not the item has children."

	^updateMode name!

updateMode: aSymbol
	"Set the desired update mode, one of:
		#dynamic	- display details re-requested by callback on every paint
		#lazy		- display details initially requested by callback on first paint only
		#static	- tree nodes fully populated with display details when first added
	The display details referred to are the label test, icon, and whether or not the node has children.
	Note that the update mode should not be changed after the tree has been populated."

	updateMode := (UpdateModes at: aSymbol ?? #dynamic) forIconicList: self!

viewMode
	"Answer the view mode of the receiver. See the class method #viewModes for the
	set of valid symbols."

	^viewMode
		!

viewModeChanged
	super viewModeChanged.
	self updateIndentation!

wantCustomDrawItemNotifications: pNMHDR
	"Implementation Note: The TreeView control sends prepaint notifications with an
	empty paint area and invalid colours. We suppress these as they are, ahem, unhelpful."

	^self customDrawBlock notNil and: 
			[(pNMHDR int32AtOffset: ##(NMCUSTOMDRAW._OffsetOf_rc + RECTL._OffsetOf_right))
				- (pNMHDR int32AtOffset: ##(NMCUSTOMDRAW._OffsetOf_rc + RECTL._OffsetOf_left)) > 0
				and: 
					[(pNMHDR int32AtOffset: ##(NMCUSTOMDRAW._OffsetOf_rc + RECTL._OffsetOf_bottom))
						- (pNMHDR int32AtOffset: ##(NMCUSTOMDRAW._OffsetOf_rc + RECTL._OffsetOf_top)) > 0]]!

wmKeyDown: message wParam: wParam lParam: lParam
	"Private - Handle WM_KEYDOWN.
	Implementation Note: We override here in order to be able to disable the 'Expand All'
	accelerator (the numeric pad's multiply key), which may be undesirable if the 'tree'
	being represented is either very large, or has cycles."

	^(wParam == VK_MULTIPLY and: [self isExpandAllEnabled not]) 
		ifTrue: [0]
		ifFalse: 
			[super 
				wmKeyDown: message
				wParam: wParam
				lParam: lParam].! !

!UI.TreeView categoriesForMethods!
addRoot:!adding!private! !
applyExtendedStyles!private!updating! !
applyImageLists!image management!private! !
basicAdd:atIndex:!adding!private! !
basicClear!operations!private! !
basicEditItemLabel:!operations!private! !
basicItemFromPoint:!accessing!private! !
basicParentOf:!accessing!private! !
basicRefreshContents!private!updating! !
basicRemove:!private!removing! !
basicRemoveAtIndex:!private!removing! !
basicResetSelection!private!selection! !
beDefaultThemed!modes!public! !
collapse:!expanding/collapsing!public! !
collapseHandle:!expanding/collapsing!private! !
connectModel!models!public! !
customDrawContextClass!constants!private! !
defaultWindowStyle!constants!private! !
displayedContents!accessing!public! !
editLabelStyle!constants!private! !
ensureVisible:!drawing!public! !
expand:!expanding/collapsing!public! !
expandAll!commands-actions!public! !
expandAll:!expanding/collapsing!public! !
findNode:!public!selection! !
forecolor:!accessing!public! !
getEditControl!accessing!private! !
getItemState:!helpers!private! !
getItemText:!accessing!private! !
getSelectionsByIndex!private!selection! !
getSingleSelection!private!selection! !
handleFromObject:!accessing!private! !
handleFromObject:ifAbsent:!accessing!private! !
hasAutomaticHorizontalScrolling!accessing-styles!public! !
hasAutomaticHorizontalScrolling:!accessing-styles!public! !
hasButtons!accessing-styles!public! !
hasButtons:!accessing-styles!public! !
hasCheckBoxes!accessing-styles!public! !
hasCheckBoxes:!accessing-styles!public! !
hasFadingExpandos!accessing-styles!public! !
hasFadingExpandos:!accessing-styles!public! !
hasFullRowSelect!accessing-styles!public! !
hasFullRowSelect:!accessing-styles!public! !
hasHotTracking!accessing-styles!public! !
hasHotTracking:!accessing-styles!public! !
hasInfoTips!accessing-styles!public! !
hasInfoTips:!accessing-styles!public! !
hasLines!accessing-styles!public!testing! !
hasLines:!accessing-styles!public! !
hasLinesAtRoot!accessing-styles!public!testing! !
hasLinesAtRoot:!accessing-styles!public! !
hasSelection!public!selection! !
hideDropHighlight!drag & drop!private! !
includesItem:!enquiries!public! !
indentSeparation!accessing!public! !
indentSeparation:!accessing!public! !
initialize!initializing!private! !
isDoubleBuffered!accessing-styles!public! !
isDoubleBuffered:!accessing-styles!public! !
isExpandAllEnabled!accessing!public! !
isExpandAllEnabled:!accessing!public! !
isExpanded:!public!testing! !
isLargeIcons!public!testing! !
isMonoExpandable!accessing-styles!public! !
isMonoExpandable:!accessing-styles!public! !
isSelected:!public!testing! !
isSmallIcons!public!testing! !
isVirtual!accessing-styles!public! !
itemCount!accessing!public! !
itemRect:textOnly:!enquiries!public! !
itemStructure!constants!private! !
minimumIndent!constants!public! !
newMaps!helpers!private! !
nmDeleteItem:!event handling-win32!private! !
nmNotify:!event handling!event handling-win32!private! !
nmRClick:!event handling-win32!public! !
notificationClass!constants!private! !
objectFromHandle:ifAbsent:!accessing!private! !
onDestroyed!event handling!private! !
onDisplayDetailsRequired:!event handling!private! !
onItem:addedAtIndex:!event handling!public! !
onItem:addedInParent:!event handling!public! !
onItem:movedToParent:!event handling!public! !
onItem:removedAtIndex:!event handling!public! !
onItem:removedFromParent:!event handling!public! !
onItem:updatedAtIndex:!event handling!public! !
onItems:addedAtIndex:!event handling!public! !
onItemUpdated:!event handling!public! !
onSelChanging:!event handling!private! !
onSelChangingFrom:to:cause:!event handling!helpers!private! !
onTreeChanged:!event handling!public! !
onViewCreated!event handling!public! !
refreshContents!public!updating! !
refreshHasChildren:!private!updating! !
resetSelection!public!selection! !
resolutionScaledBy:!geometry!private! !
restoreSelection:!binary filing!private!selection! !
selection:ifAbsent:!public!selection! !
selectionByIndex!private!selection! !
selectionByIndex:ifAbsent:!public!selection! !
selectionFromPoint:!event handling!private! !
selectionIfNone:!public!selection! !
selectionState!binary filing!private!selection! !
setControlBackcolor:!accessing!private! !
setSingleSelection:!public!selection! !
setViewMode:!accessing!private! !
showDropHighlight:!drag & drop!private! !
showsSelAlways!accessing-styles!public! !
showsSelAlways:!accessing-styles!public! !
treeViewStyleMask:set:!accessing-styles!private! !
tvmInsertItem:tvis:!adding!private! !
tvmSetItem:!private!updating! !
tvnGetInfoTip:!event handling-win32!private! !
tvnItemChanged:!event handling-win32!private! !
tvnItemChanging:!event handling-win32!private! !
tvnItemExpanded:!event handling-win32!private! !
tvnItemExpanding:!event handling-win32!private! !
tvnSelChanging:!event handling-win32!private! !
updateAll!public!updating! !
updateAllItems!private!updating! !
updateIndentation!private!updating! !
updateItem:!event handling!public! !
updateItem:at:!public!updating! !
updateMode!accessing!public! !
updateMode:!accessing!public! !
viewMode!accessing!public! !
viewModeChanged!accessing!private! !
wantCustomDrawItemNotifications:!event handling-win32!private! !
wmKeyDown:wParam:lParam:!event handling-win32!private! !
!

UI.TreeView methodProtocol: #treeView attributes: #(#readOnly) selectors: #(#collapse: #expand: #expandAll: #includesItem: #onItem:addedInParent: #onItem:movedToParent: #onItem:removedFromParent: #onItemUpdated: #onTreeChanged: #updateItem: #viewMode #viewMode:)!

!UI.TreeView class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it is initialized."

	^TreeModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	CommCtrlLibrary addInitFlag: ICC_TREEVIEW_CLASSES!

stbConvertFromVersion10: anArray
	"Private - Perform an STB conversion from a version 10 <TreeView> to version 11,
	i.e. append tvFlags and reserve another slot for later use."

	| size array |
	array := super stbConvertFromVersion10: anArray.
	size := array size.
	"2 instance variables were added"
	^(Array new: size + 2)
		replaceFrom: 1
			to: size
			with: array
			startingAt: 1;
		at: size + 1 put: 0;
		yourself!

stbConvertProxy: anSTBViewProxy
	| size vars |
	super stbConvertProxy: anSTBViewProxy.
	anSTBViewProxy version < 14 ifFalse: [^self].
	vars := anSTBViewProxy instVars.
	size := vars size.
	(vars resize: size + 8)
		at: size + 1 put: 0;
		at: size + 2
			put: ((##({ TreeViewDynamicUpdateMode. TreeViewStaticUpdateMode. TreeViewLazyUpdateMode })
					at: (((vars at: ##(self indexOfInstVar: 'tvFlags')) bitAnd: LegacyUpdateModeMask) bitShift: -1) + 1)
						forIconicList: anSTBViewProxy)!

stbVersion
	"14: Adds tvStyle, updateMode, and 6 spares"

	^14!

themePartName
	^#TreeView!

uninitialize
	CommCtrlLibrary removeInitFlag: ICC_TREEVIEW_CLASSES!

updateModes
	^UpdateModes keys asSortedArray!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysTreeView32'! !

!UI.TreeView class categoriesForMethods!
defaultModel!models!public! !
icon!constants!public! !
initialize!development!initializing!private! !
stbConvertFromVersion10:!binary filing!private! !
stbConvertProxy:!binary filing!public! !
stbVersion!binary filing!public! !
themePartName!constants!public! !
uninitialize!class hierarchy-removing!private! !
updateModes!constants!private! !
winClassName!constants!private! !
!

