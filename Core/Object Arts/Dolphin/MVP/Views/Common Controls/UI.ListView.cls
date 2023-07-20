"Filed out from Dolphin Smalltalk"!

UI.IconicListAbstract
	subclass: #'UI.ListView'
	instanceVariableNames: 'lastClickedColIndex columns viewMode lastSelIndices iconSpacing lvStyle thumbnailExtent lvFlags backImage backImageOffset backImageAlpha approvedSelIndices noRedrawCount _unused36 _unused37 _unused38 _unused39 _unused40 _unused41 _unused42 _unused43 _unused44 _unused45'
	classVariableNames: 'SelectionStateMask UnknownItem'
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {
			'BackImageIsTiledMask' -> 16r1.
			'LvModes'
				-> (IdentityDictionary withAll: {
								#extraLargeIcons -> 16r0.
								#largeIcons -> 16r0.
								#list -> 16r3.
								#report -> 16r1.
								#smallIcons -> 16r2.
								#thumbnails -> 16r0.
								#tileIcons -> 16r0
							}).
			'NoImageIndex' -> 16r0
		}!
UI.ListView guid: (Core.GUID fromString: '{87b4c730-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ListView comment: '`ListView` is the `<listView>` implementing the Windows "SysListView32" common control. It is for single selection use and, therefore, implements the `<selectableItems>` protocol for use with any `<listModel>`.

A `ListView` is capable of displaying its items in one of a number of modes, e.g. `#smallIcons`, `#largeIcons`, `#list`, and `#report` which can be set using the `#viewMode` aspect. In all but `#report` mode the list effectively has only one column being displayed; this is the primary column. Columns are described using instances of `ListViewColumn`. See the comment for this class for details on how to set up a column to display the appropriate information for a list item.

The underlying Windows common control is a sophisticated one with many options. We have not attempted to wrap all of the features of this control within the ListView class. However, you should find that much of the most useful functionality is present.

## Instance Variables:
  `lastClickedColIndex`	`<integer>` index of the last column clicked for sorting
  `columns`			`OrderedCollection` of `ListViewColumn`s which are displayed in `#report` mode.
  `viewMode`			`Symbol` describing the mode in which the list is displaying items.
  `lastSelIndices`		`Array` of `<integer>`. The indices of the last selected rows.
  `iconSpacing`		`Point`, optional. Represents the explicit spacing between icons in icon view modes. Default is to use the control''s preferred spacing.
  `lvStyle`				`<integer>`. List view extended style flags
  `thumbnailExtent`		`Point`, optional, representing the size of icons when in `#thumbnail` view mode. Default is 64@64.
  `lvFlags`				`<integer>` flags specific to list views
  `backImage`			`<Bitmap>`, optional. Background image. Default, nil.
  `backImageOffset`		`Point`, optional. Origin of the background image. Default is 0@0.
  `backImageAlpha`		`<integer>`, optional. Alpha percent for the background image. Default is 100.
  
## Class Variables:
  `BackImageIsTiledMask`	`<integer>`. Flag mask for backImageIsTiled.
  `LvModes`				`IdentityDictionary` mapping symbolic view mode names to the corresponding list view style constants. 
  `NoImageIndex`			`<integer>`
  `RevertSelMessage`		`<integer>` holding the private ''RevertSelection'' message.
  `SelectionStateMask`		`<integer>`
  `UnknownItem`			`<Object>`


'!
!UI.ListView categoriesForClass!MVP-Views! !
!UI.ListView methodsFor!

addAllNonVirtual
	"Private - Add all the row and column items for a non-virtual list."

	self 
		addOrUpdate: false
		nonVirtualItems: self list
		afterIndex: 0!

addColumn
	"Append a new default column to the report views columns. 
	Answers the new column"

	| title |
	title := 'Column ', (self columnCount+1) printString.
	^self addColumn: (self columnClass text: title)
 !

addColumn: newColumn
	"Append the <ListViewColumn>, newColumn, to the receiver's existing 
	list of columns. Answers the appended column."

	^self addColumn: newColumn atIndex: (self columnCount + 1)
 
!

addColumn: newColumn atIndex: columnIndex
	"Insert the <ListViewColumn>, newColumn, into the receiver
	at the <integer> index columnIndex, shifting the positions of all 
	subsequent columns up by one. Answers the inserted column."

	lastClickedColIndex notNil
		ifTrue: [lastClickedColIndex >= columnIndex ifTrue: [lastClickedColIndex := lastClickedColIndex + 1]].
	columns add: newColumn beforeIndex: columnIndex.
	self basicAddColumn: newColumn atIndex: columnIndex.
	self autoResizeColumns.
	self invalidateLayout.
	self updateAll.
	^newColumn!

addOrUpdate: aBoolean nonVirtualItems: aSequenceableCollection afterIndex: anInteger
	"Private - Add/update row and column items for specified sequence of objects to the ListView,
	starting at the specified row index."

	| lvItem primaryImageSupplier primaryTextSupplier isMultiColumn colImageBlock msg |
	primaryImageSupplier := primaryTextSupplier := self.
	colImageBlock := [:eachRow :eachCol | nil].
	(isMultiColumn := self isReportMode)
		ifTrue: 
			[primaryTextSupplier := self allColumns at: 1 ifAbsent: [self].
			self hasColumnImages
				ifTrue: 
					[colImageBlock := [:eachRow :eachCol | eachCol imageFromRow: eachRow].
					primaryImageSupplier := primaryTextSupplier]].
	lvItem := LVITEMW newBuffer.
	msg := aBoolean ifTrue: [LVM_SETITEMW] ifFalse: [LVM_INSERTITEMW].
	aSequenceableCollection keysAndValuesDo: 
			[:i :each |
			lvItem
				row: i + anInteger
				text: (primaryTextSupplier textFromRow: each)
				imageIndex: (primaryImageSupplier imageFromRow: each)
				indent: (self indentFromRow: each).
			(self stateImageFromRow: each) ifNotNil: [:state | lvItem stateImageIndex: state].
			User32
				sendMessage: handle
				msg: msg
				wParam: 0
				lpParam: lvItem].
	isMultiColumn ifFalse: [^self].
	self allColumns from: 2
		keysAndValuesDo: 
			[:j :eachCol |
			lvItem column: j.
			aSequenceableCollection keysAndValuesDo: 
					[:i :eachRow |
					lvItem
						row: i + anInteger
						text: (eachCol textFromRow: eachRow)
						imageIndex: (colImageBlock value: eachRow value: eachCol)
						indent: 0.
					self lvmSetItem: lvItem]]!

adjustForStaticEdgeBug: aRectangle
	"#1063: If we have a static edge but no other edge style, the view behaves as though it
	is slightly smaller than the reported client width for the purposes of calculating if scrollbars
	are shown. Adjust the available width a little to prevent this."

	(self hasStaticEdge and: [(self hasClientEdge or: [self hasBorder]) not])
		ifTrue: [aRectangle corner: aRectangle corner - 2].
	^aRectangle!

allColumns
	"Answer an <sequencedReadableCollection> of all the columns in the view including
	the primary column."

	^columns!

anchorIndex
	"Answer the one-based <integer> index of the item from which a multiple selection will
	start, or 0 if there is none."

	^(self sendMessage: LVM_GETSELECTIONMARK) + 1!

anchorIndex: anInteger
	"Set the one-based <integer> index of the item from which
	a multiple selection will start, or clear it if <anInteger> is 0.

	N.B. The ListView documentation calls this concept the 'selection mark',
	while that for the older ListBox refers to it as the 'anchor'. Since they behave the same,
	we standardize on what seems like the shorter, clearer name."

	self
		sendMessage: LVM_SETSELECTIONMARK
		wParam: 0
		lParam: anInteger - 1.!

applyImageLists
	"Private - Set the receiver's image lists from the image managers."

	| largeImList smallExt |
	largeImList := self customImageExtent
				ifNotNil: [:ext | self thumbnailsImageManager imageListWithExtent: ext]
				ifNil: 
					[thumbnailsImageManager := nil.
					self imageManager ifNotNil: [:im | im imageListWithExtent: self largeIconExtent]].
	smallExt := self smallIconExtent.
	self lvmSetImageList: (self imageManager ifNotNil: [:im | im imageListWithExtent: smallExt])
		type: LVSIL_SMALL.
	self lvmSetImageList: largeImList type: LVSIL_NORMAL.
	self hasCheckBoxes
		ifFalse: 
			[self lvmSetImageList: (self stateImageManager
						ifNotNil: [:stateImages | stateImages imageListWithExtent: smallExt])
				type: LVSIL_STATE]!

autoResizeColumns
	"Private - Attempt to share the available width in the receiver between all automagically resizeable
	columns. This only has a visible effect in #report mode, or if the list is subsequently switched to report mode."

	self isReportMode
		ifTrue: [self autoResizeColumns: (self adjustForStaticEdgeBug: self clientRectangle) width]!

autoResizeColumns: anInteger
	"Private - Attempt to share the specified <integer> width (which must be the client width of the view,
	after subtracting for borders and such) between all automagically resizeable columns in the receiver.
	This only has a visible effect in #report mode."

	| cols count autoCols fixedWidth idealWidth remainingWidth |
	fixedWidth := autoCols := 0.
	cols := self allColumns.
	count := cols size.
	1 to: count
		do: 
			[:i |
			(cols at: i) isAutoResize
				ifTrue: [autoCols := autoCols + 1]
				ifFalse: [fixedWidth := fixedWidth + (self lvmGetColumnWidth: i - 1)]].
	autoCols == 0 ifTrue: [^self].
	remainingWidth := anInteger - fixedWidth.
	remainingWidth <= 0 ifTrue: [^self].
	"Split the available width between the auto columns - note the use of fractional arithmetic to avoid accumulating a rounding error"
	idealWidth := remainingWidth / autoCols.
	"Suppress painting while changing the columns widths as, if there are multiple auto-resize columns, there is no point repainting the intermediate states"
	self noRedrawDo: 
			[| actualAccum idealAccum |
			idealAccum := actualAccum := 0.
			1 to: count
				do: 
					[:i |
					| each |
					each := cols at: i.
					each isAutoResize
						ifTrue: 
							[| thisWidth |
							idealAccum := idealAccum + idealWidth.
							thisWidth := (idealAccum - actualAccum) rounded.
							each basicWidth: thisWidth.
							self lvmSetColumnWidth: i - 1 to: thisWidth.
							actualAccum := actualAccum + thisWidth]]]!

backcolorChanged
	super backcolorChanged.
	self backImage notNil ifTrue: [self backImageChanged]!

backImage
	^backImage!

backImage: aBitmapOrNil 
	backImage := aBitmapOrNil.
	self backImageChanged!

backImageAlphaPercent
	^backImageAlpha ?? 100!

backImageAlphaPercent: anInteger
	backImageAlpha := anInteger.
	backImage ifNotNil: [self backImageChanged]!

backImageChanged
	"Private - The background image has been changed; apply it into the receiver. We take a copy here
	since Windows takes ownership of the bitmap handle that we give it"

	| bk isTiled offset |
	bk := LVBKIMAGEW new.
	bk bitmap: (backImage notNil
				ifTrue: 
					[backImage asBitmap createWatermarkAlphaPercent: self backImageAlphaPercent
						backcolor: self actualBackcolor]).
	backImage notNil
		ifTrue: 
			[offset := self backImageOffset.
			isTiled := self backImageIsTiled.
			bk isTiled: isTiled.
			isTiled ifTrue: [bk offsetTile: offset] ifFalse: [bk offsetPercent: offset]].
	self lvmSetBkImage: bk!

backImageIsTiled
	^self lvFlags allMask: BackImageIsTiledMask!

backImageIsTiled: aBoolean
	lvFlags := self lvFlags mask: BackImageIsTiledMask set: aBoolean.
	backImage ifNotNil: [self backImageChanged]!

backImageOffset
	^backImageOffset ?? Point.Zero!

backImageOffset: aPoint
	backImageOffset := aPoint = Point.Zero ifFalse: [aPoint].
	backImage ifNotNil: [self backImageChanged]!

basicAdd: anObject atIndex: anInteger
	"Private - Adds an item to the list view at the index given by anInteger"

	self isVirtual
		ifTrue: [self lvmInsertItem: (LVITEMW allCallbacks
						iItem: anInteger - 1;
						yourself)]
		ifFalse: 
			[self
				addOrUpdate: false
				nonVirtualItems: {anObject}
				afterIndex: anInteger - 1]!

basicAddColumn: aListViewColumn atIndex: anInteger
	"Private - Insert aListViewColumn in the associated control at the index 
	columnIndex. N.B. Does not modify the receiver's column collection.
	Answers aListViewColumn."

	self lvmInsertAt: anInteger - 1 column: (LVCOLUMNW fromColumn: aListViewColumn).
	aListViewColumn parent: self.
	^aListViewColumn!

basicClear
	"Private - Clears down the listview control (but not its model)."

	self lvmDeleteAllItems!

basicEditItemLabel: itemIndex
	"Private - Begin inline editing of the item with one-based <integer> index, itemIndex."

	^self sendMessage: LVM_EDITLABEL wParam: itemIndex-1!

basicItemFromPoint: aPoint
	"Private - Answer a LVHITTESTINFO populated by the control with hit-test information for the
	item (and sub-item) under the client coordinate represented by the <Point> argument."

	| struct |
	struct := LVHITTESTINFO position: aPoint.
	self
		sendMessage: LVM_SUBITEMHITTEST
		wParam: 0
		lpParam: struct.
	^struct!

basicRefreshContents
	| count |
	self isVirtual
		ifTrue: 
			[count := self size.
			self
				basicResetSelection;
				lvmSetItemCount: count.
			count > 0
				ifTrue: 
					["If virtual, then don't need to actually add the items (hooray!!)"
					self autoResizeColumns]]
		ifFalse: [self refreshNonVirtual]!

basicRemoveAtIndex: anInteger
	"Private - Delete item at anInteger index in the list view.
	Answer whether the request succeeded."

	^(User32
		sendMessage: handle
		msg: LVM_DELETEITEM
		wParam: anInteger - 1
		lParam: 0) ~~ 0!

basicRemoveColumnAtIndex: anInteger
	self lvmDeleteColumn: anInteger - 1!

basicResetSelection
	"Private - Clear all selections. Do not issue a selection changed
	notification."

	| anLvItem |
	anLvItem := LVITEMW newBuffer.
	anLvItem stateMask: ##(LVIS_SELECTED | LVNI_FOCUSED).
	self lvmSetItem: -1 state: anLvItem!

basicUpdateColumn: aListViewColumn
	| i |
	i := columns identityIndexOf: aListViewColumn.
	i == 1 ifTrue: [aListViewColumn text setTextInto: self].
	self lvmSetColumn: (LVCOLUMNW fromColumn: aListViewColumn) at: i - 1!

beSorted: aBlockClosure 
	self list: (self list asSortedCollection: aBlockClosure)!

buildViewsPopup
	| popup |
	popup := Menu new.
	popup
		addCommand: (Message selector: #extraLargeIconMode) description: 'Extra large icons';
		addCommand: (Message selector: #thumbnailsMode) description: 'Thumbnails';
		addCommand: (Message selector: #tileIconMode) description: 'Tiles';
		addCommand: (Message selector: #largeIconMode) description: 'Icons';
		addCommand: (Message selector: #listMode) description: 'List';
		addCommand: (Message selector: #reportMode) description: 'Details'.
	popup items do: [:each | each isRadioButtonStyle: true].
	^popup!

cancelLabelEdit
	"Private - Cancel current inline editing."

	self sendMessage: LVM_EDITLABEL wParam: -1

!

caretIndex
	"Answer the 1-based <integer> index of the item in the list that has focus, or zero if there
	is none."

	^(self lvmGetNextItem: -1 flags: LVNI_FOCUSED) + 1!

caretIndex: anInteger
	"Set the 1-based <integer> index of the item in the list that has focus,
	or clear the focus if <anInteger> is 0."

	| lvItem |
	lvItem := LVITEMW newBuffer.
	lvItem stateMask: LVIS_FOCUSED.
	"If we pass -1 to LVM_SETITEMSTATE, the change applies to *all* items in the list,
	but we must also tell the control to clear the focus state rather than set it."
	anInteger == 0 ifFalse: [lvItem dwState: LVIS_FOCUSED].
	self lvmSetItem: anInteger - 1 state: lvItem!

clearSelectionsByIndex: collection 
	"Removes selection from the items in the receiver with the Integer
	indices in collection"

	self selectIndices: collection set: false.

	"Windows only sends the change notification
	when the selection is the result of a user action so
	force it here"
	self onSelChanged!

columnAtIndex: anInteger
	^columns at: anInteger!

columnClass
	"Answer the class of object used to represent the columns of the receiver."

	^self class columnClass!

columnClicked: anInteger
	| column selections |
	selections := self selections.
	column := self columnAtIndex: anInteger.
	column isSortable
		ifFalse: 
			[Sound warningBeep.
			^self].
	anInteger = lastClickedColIndex
		ifTrue: [column toggleSortOrder]
		ifFalse: 
			[self forgetLastClickedColumn.
			lastClickedColIndex := anInteger].
	self setColumnIcon: (column headerIcon: true) atIndex: anInteger.
	self sortOnColumn: column.
	self selections: selections!

columnCount
	^self allColumns size!

columnOrder
	"Answer an <Array> specifying the column order in the receiver."

	^self lvmGetColumnOrderArray collect: [:i | i +1]!

columnOrder: positions
	"Set the column order of the receiver to the specified <sequencedReadableCollection> 
	of 1-based positions."

	| iArray iCount |
	self columnOrder = positions ifTrue: [^self	"Order not changed"].
	iCount := positions size.
	iArray := UInt32Array new: iCount.
	1 to: positions size do: [:i | iArray at: i put: (positions at: i) - 1].
	self lvmSetColumnOrderArray: iArray.
	"The control does not repaint, so we must force it"
	self updateAll!

columnsList
	"Answer an OrderedCollection of all the columns in the view. This is a published aspect.
	N.B. In D5 this is the actual columns list the view uses internally, and so it should not
	be modified directly (e.g. to add/remove items). Always modify a copy and set it back!!
	Note that the published aspect is marked as immutable so that the PAI always works
	on a copy when editing."

	^self allColumns!

columnsList: anOrderedCollection
	"Set the columns of the receiver to be those in anOrderedCollection of ListViewColumns"

	| oldSize newSize |
	self forgetLastClickedColumn.
	newSize := anOrderedCollection size.
	oldSize := self columnCount.
	oldSize to: newSize + 1
		by: -1
		do: [:each | self basicRemoveColumnAtIndex: each].
	columns := anOrderedCollection.
	oldSize + 1 to: newSize do: [:each | self basicAddColumn: (columns at: each) atIndex: each].
	1 to: (oldSize min: newSize)
		do: [:each | self basicUpdateColumn: ((columns at: each)
						parent: self;
						yourself)].
	self
		invalidateLayout;
		invalidate!

customDrawContextClass
	"Private - Answer the class of NM??CUSTOMDRAW structure associated with the receiver."

	^NMLVCUSTOMDRAW!

customDrawSubItem: context
	"Private - Custom draw the sub-item identified in the <customDrawContext>, context.
	Answer the custom draw return code (an integer from the CDRF_XXXX enumeration) to 
	be returned to the control."

	| column idx custom |
	idx := context iSubItem.
	column := columns at: idx + 1.
	custom := column customDrawBlock.
	"We need to reset the custom draw settings as otherwise we'll end up picking up whatever customizations might have been applied to the previous column."
	context reset.
	^custom isNil
		ifTrue: [context applyFont]
		ifFalse: 
			[context
				column: column;
				evaluateDrawBlock: custom]!

customImageExtent
	viewMode == #thumbnails ifTrue: [^self thumbnailExtent].
	viewMode == #extraLargeIcons ifTrue: [^Icon extraLargeExtent].
	^nil!

defaultListViewExStyle
	"Private - Answer the default ListView extended style. 
	This is only available with IE4 common controls."

	^##(LVS_EX_FULLROWSELECT | LVS_EX_HEADERDRAGDROP|LVS_EX_INFOTIP)!

defaultThumbnailExtent
	^64@64!

defaultWindowStyle
	"Private - Answer a base style to use when creating a ListView."

	^super defaultWindowStyle bitOr: 
		##(LVS_ICON | LVS_SHAREIMAGELISTS | LVS_SHOWSELALWAYS | LVS_SINGLESEL| 
			LVS_OWNERDATA	"This style is necessary for virtual list behaviour"
			)!

editLabelStyle
	"Private - Answer the <integer> style mask used to control whether label editing is enabled
	in the receiver's control."

	^LVS_EDITLABELS!

ensureItemsVisible: indices
	| caret |
	caret := self caretIndex.
	self ensureVisible: ((indices isEmpty or: [indices includes: caret])
				ifTrue: [caret]
				ifFalse: [indices first])!

ensureSelectionVisible
	"Ensure the selected item is visible, scrolling it into view if necessary."

	self ensureItemsVisible: self selectionsByIndex!

ensureVisible: anInteger 
	"Ensure the item with the specified index is visible, scrolling it into view if necessary."

	self lvmEnsureVisible: anInteger - 1 partial: false!

errorInCommonControlCall: index
	"Private - Raise an appropriate exception in the event of a common control message failure
	at the specified zero-based index."

	self isOpen 
		ifTrue: 
			[| size |
			size := self itemCount.
			(index between: 0 and: size - 1) ifFalse: [^self errorSubscriptBounds: index]].
	^self errorInCommonControlCall!

extraLargeIconMode
	"Place the receiver in extra large icons mode"

	self viewMode: #extraLargeIcons!

findItem: aString startingAt: anInteger wrap: aBoolean
	"Private - Perform a search for the first item starting with the <readableString>,
	partialName, beginning with the item at <integer> index, start, potentially wrapping
	round to the start depending on the <boolean>, wrap. i.e. an incremental search.
	Answer the index of the item, or 0 if none matched."

	| items getText len |
	items := self list.
	getText := (self isReportMode and: [columns notEmpty])
				ifTrue: 
					[| column |
					column := self columnAtIndex: lastClickedColIndex ?? 1.
					column getTextBlock notNil ifTrue: [column] ifFalse: [self]]
				ifFalse: [self].
	len := aString size.
	items
		from: anInteger
		to: items size
		keysAndValuesDo: 
			[:index :each |
			| text |
			text := getText textFromRow: each.
			((text leftString: len) sameAs: aString) ifTrue: [^index]].
	aBoolean
		ifTrue: 
			[items
				from: 1
				to: anInteger - 1
				keysAndValuesDo: 
					[:index :each |
					| text |
					text := getText textFromRow: each.
					((text leftString: len) sameAs: aString) ifTrue: [^index]]].
	^0	"couldnt find it"!

forecolor: aColorOrNil
	"Sets the foreground colour of the receiver to aColorOrNil.
	If aColorOrNil is nil then use the default color"

	| clrref |
	super forecolor: aColorOrNil.
	clrref := (aColorOrNil ?? Color.WindowText) asCOLORREF.
	self
		sendMessage: LVM_SETTEXTCOLOR
		wParam: 0
		lParam: clrref!

forgetLastClickedColumn
	lastClickedColIndex isNil ifTrue: [^self].
	self setColumnIcon: nil atIndex: lastClickedColIndex.
	lastClickedColIndex := nil!

getEditControl
	^self sendMessage: LVM_GETEDITCONTROL

!

getItemChecked: anInteger
	"Answer whether the item with the specified index is 'checked' or not. The result is unspecified if the receiver is not in `hasCheckBoxes` mode."
	"Implementation mode: The ListView checkboxes feature is really just an application of state images, and the API for managing checked/unchecked is irregular and not very specific.
		- to determine whether an item is checked, we have to request the state image index using a special message (LVM_GETITEM does not return it). The image index should be 1 for unchecked, and 2 for checked.
		- to check/uncheck an item, we set the state image index to either 1 or 2. See `setItem:checked:`. If set to 0 (or some other value) then the checkbox will not be shown at all, but will reappear if the user clicks the item. In practice this isn't useful to represent 3 states, as it would be better to have a specific image for the unspecified state."

	^((self lvmGetItemState: anInteger - 1 mask: LVIS_STATEIMAGEMASK)
		bitShift: ##((LVIS_STATEIMAGEMASK lowBit - 1) negated)) > 1!

getItemText: anInteger
	| item |
	item := LVITEMW newBuffer
				iItem: anInteger - 1;
				newTextBuffer: 128;
				yourself.
	self lvmGetItem: item.
	^item pszText!

getNoRedrawCount
	^noRedrawCount!

getSelectedCount
	"Private - Query the total number of items selected from the control."

	^self sendMessage: LVM_GETSELECTEDCOUNT!

getSelectionsByIndex
	"Private - Query the actual current selections from the control."

	| selections index |
	self isOpen ifFalse: [^#()].
	selections := Array writeStream: 1.
	index := -1.
	
	[(index := self
				sendMessage: LVM_GETNEXTITEM
				wParam: index
				lParam: LVNI_SELECTED) == -1]
			whileFalse: [selections nextPut: index + 1].
	^selections grabContents!

getSingleSelection
	"Private - Answer the one-based <integer> index of the selected object in the receiver or
	zero if there is none."

	^(self lvmGetNextItem: -1 flags: LVNI_SELECTED) + 1


	
	!

getThumbnailOf: anObject 
	^self thumbnailsImageManager addImage: anObject extent: self customImageExtent!

hasBorderSelect
	"Answer whether the receiver displays selected by changing the border colour of an item
	rather than the background colour. This is not available in pre-IE5 versions of the CommCtrl
	Library, and only has any effect in the #largeIcons and #tileIcons modes."

	^lvStyle allMask: LVS_EX_BORDERSELECT!

hasBorderSelect: aBoolean 
	"Set whether the receiver displays selected by changing the border colour of an item rather
	than the background colour. This is not available in pre-IE5 versions of the CommCtrl
	Library."

	^self listViewStyleMask: LVS_EX_BORDERSELECT set: aBoolean!

hasButtons
	"Answer whether the receiver has state images (usually used for expand/contract buttons)."

	^false!

hasCheckBoxes
	"Answer whether the receiver has check-boxes associated with its items. This feature is only supported in non-virtual mode."

	^(lvStyle allMask: LVS_EX_CHECKBOXES) and: [self isVirtual not]!

hasCheckBoxes: aBoolean
	"Set whether the receiver has check-boxes associated with its items. Note that check-boxes are only supported when in non-virtual mode, and are also mutually exclusive with any other use of state images in the list."

	| hadCheckboxes |
	hadCheckboxes := (self listViewStyleMask: LVS_EX_CHECKBOXES set: aBoolean)
				allMask: LVS_EX_CHECKBOXES.
	hadCheckboxes
		ifTrue: 
			["Reset the state as the list does not do this, although ironically it will reset when the checkboxes are turned back on."
			self setItem: 0 checked: false].
	^hadCheckboxes!

hasColumnHeaders
	"Answers true if the receiver has column headers enabled"

	^(self baseStyleAllMask: LVS_NOCOLUMNHEADER) not
!

hasColumnHeaders: aBoolean
	"Set the receiver's base style such that it has column headers
	according to aBoolean." 

	self 
		baseStyleMask: LVS_NOCOLUMNHEADER
		set: aBoolean not
		recreateIfChanged: false!

hasColumnImages
	"Answer whether the receiver displays images for additional columns.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^lvStyle allMask: LVS_EX_SUBITEMIMAGES!

hasColumnImages: aBoolean 
	"Sets the receiver to have images for individual columns depending on the value of aBoolean."

	self listViewStyleMask: LVS_EX_SUBITEMIMAGES set: aBoolean!

hasFlatScrollbars
	"Answer whether the receiver has the new flat scrollbars style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^lvStyle allMask: LVS_EX_FLATSB!

hasFlatScrollbars: aBoolean
	"Set whether the receiver has the new flat scrollbars style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^self listViewStyleMask: LVS_EX_FLATSB set: aBoolean!

hasFullRowSelect
	"Answer whether the receiver has the full row select style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^lvStyle allMask: LVS_EX_FULLROWSELECT!

hasFullRowSelect: aBoolean
	"Sets the receiver to have full row select or not depending on the 
	value of aBoolean."

	^self listViewStyleMask: LVS_EX_FULLROWSELECT set: aBoolean!

hasGridLines
	"Answer whether the receiver has the gridlines style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^lvStyle allMask: LVS_EX_GRIDLINES!

hasGridLines: aBoolean
	"Sets the receiver to have grid lines or not depending on the 
	value of aBoolean."

	^self listViewStyleMask: LVS_EX_GRIDLINES set: aBoolean!

hasHeaderDragDrop
	"Answer whether the receiver has the header drag drop style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^lvStyle allMask: LVS_EX_HEADERDRAGDROP!

hasHeaderDragDrop: aBoolean
	"Sets the receiver to have header drag drop or not depending on the 
	value of aBoolean."

	^self listViewStyleMask: LVS_EX_HEADERDRAGDROP set: aBoolean!

hasHotTracking
	"Answer whether the receiver has the track select style. This means that the item under the cursor is automatically selected when hovered over for a period of time. 
	See [Extended List-View Styles](https://docs.microsoft.com/en-us/windows/win32/controls/extended-list-view-styles)."

	^lvStyle allMask: LVS_EX_TRACKSELECT!

hasHotTracking: aBoolean 
	"Sets the receiver to have track select or not depending on the 
	value of aBoolean."

	self listViewStyleMask: LVS_EX_TRACKSELECT set: aBoolean!

hasInfoTips
	"Answer whether the receiver has the Info. Tip style.
	Note that this style controls whether or not the control displays any
	info tips at all, including the default tips which display the full text
	of clipped items."

	^lvStyle allMask: LVS_EX_INFOTIP!

hasInfoTips: aBoolean
	"Sets whether the receiver has Info. Tips.
	Note that this style controls whether or not the control displays any
	info tips at all, including the default tips which display the full text
	of clipped items."

	^self listViewStyleMask: LVS_EX_INFOTIP set: aBoolean!

hasLargeImages
	^viewMode == #thumbnails or: [viewMode == #extraLargeIcons]!

hasPrimaryColumnImages
	^(self isReportMode and: [self hasColumnImages]) 
		ifTrue: [self primaryColumn getImageBlock notNil]
		ifFalse: [getImageBlock notNil]!

hasSortHeaders
	"Answers true if the receiver has column headers which respond to clicks
	by sorting on their associated column."

	^(self baseStyleAllMask: LVS_NOSORTHEADER) not!

hasSortHeaders: aBoolean
	"Set whether the receiver has column headers which respond to clicks
	by sorting on their associated column."

	self 
		baseStyleMask: LVS_NOSORTHEADER
		set: aBoolean not
		recreateIfChanged: true	"Cannot be changed on-the-fly without recreating the view."!

hasSubItemCustomDraw
	"Private - Answer whether the receiver wants NM_CUSTOMDRAW notifications at the
	sub-item (e.g. column) level."

	^self isReportMode and: 
			["Test for column custom draw, cache as flag"

			#todo.
			true]!

hideDropHighlight
	"Private - Hides any drop highlight within the receiver."

	| item |
	item := self dropHighlight.
	item notNil
		ifTrue: 
			[| anLvItem |
			anLvItem := LVITEMW newBuffer.
			anLvItem
				stateMask: LVIS_DROPHILITED;
				dwState: 0.
			self
				lvmSetItem: item - 1 state: anLvItem;
				update].
	super hideDropHighlight!

iconSpacing
	"Answers a Point that is the spacing between icons in the receiver if in #largeIcons or
	#smallIcons view mode. If nil the receiver uses the default spacing."

	^iconSpacing!

iconSpacing: aPointOrNil
	"Sets the spacing between icons in the receiver if in #largeIcons or
	#smallIcons view mode to aPointOrNil. If nil the receiver uses the default spacing."

	self setIconSpacing: (iconSpacing := aPointOrNil).
	self applyFont!

imageFromRow: item
	"Private - Answer the image for row which represents the <Object>, item.
	As of Dolphin 3.0 the image block is permitted to be nil for the common case
	where the list does not have images."

	self hasLargeImages ifTrue: [^self getThumbnailOf: item].
	^self getImageBlock ifNil: [NoImageIndex] ifNotNil: [:getImage | getImage value: item]!

indentFromRow: item
	"Private - Answer the number of image widths to indent the row associated with 
	the <Object>, item. Note that unlike the other display details, this cannot be specified
	on a per-column basis.
	Implementation Note: If there is no image block, then answer -1 so that no space
	is reserved for images, otherwise just answer 0 for a single image width."

	^self hasPrimaryColumnImages ifTrue: [0] ifFalse: [-1]!

infoTipFromRow: item withPrefix: prefixText
	"Private - Answer the info. tip for the row associated with the <Object>, item,
	with the <readableString> prefix, prefixText, as supplied by the ListView control
	(at the time of writing if the displayed  item text has been truncated with ellipsis, 
	then prefixText will be the full item text, otherwise it will be the empty string). 
	If there is no info. tip block then answer the empty string. The info. tip block can 
	be a monadic or dynadic valuable, in either cases expected to evaluate to a <String>.
	If monadic then it is passed only the row content object, if dyadic it is passed the 
	prefixText as its second argument. Info. Tip support is new for Dolphin 3.0.
	Note that this message is not sent to the ListView itself when in report mode but is instead 
	forwarded to the appropriate column.  This allows for differing behaviour 	in a view 
	dynamically switchable between modes. There is one exception which is in the case of
	the primary column where its own getInfoTipBlock is nil."

	| tipper |
	tipper := self getInfoTipBlock.
	^tipper isNil 
		ifTrue: ['']
		ifFalse: [
			(tipper argumentCount > 1
				ifTrue: [tipper value: item value: prefixText]
				ifFalse: [tipper value: item]) displayString]!

initialize
	"Private - Initialise the instance on creation"

	super initialize.
	lastSelIndices := #().
	columns := OrderedCollection with: ((self columnClass text: 'Column 1')
						parent: self;
						yourself).
	"self viewMode: #report."
	lvStyle := self defaultListViewExStyle.
	self primaryColumn isAutoResize: true!

invalidateHeader
	"Invalidate the header of the list view to cause it to be repainted.
	This is only really useful to work around bugs in the control?"

	| hWnd |
	(hWnd := self lvmGetHeader) notNull
		ifTrue: 
			[User32
				invalidate: hWnd
				lpRect: nil
				bErase: true]!

isArrangeable
	"Answer true if the item positions in the receiver can be set in the current view style."

	^#(#largeIcons #smallIcons) includes: self viewMode!

isAutoArranged
	"Answer whether the icons in the receiver are automatically arranged into a grid as they are
	added, and that grid is recalculated to give a best-fit when the view is resized.."

	"Implementation Note: From MSDN: 'All virtual list-view controls default to the
	LVS_AUTOARRANGE style.'"

	^(self baseStyleAllMask: LVS_AUTOARRANGE) or: [self isVirtual]!

isAutoArranged: aBoolean 
	"Set whether icons should be automatically arranged."

	"Implementation Note: Unlike some controls ListViews are capable of accepting dynamic style
	changes and so don't need to be re-created. This style can be changed on-the-fly."

	self 
		baseStyleMask: LVS_AUTOARRANGE
		set: aBoolean
		recreateIfChanged: false!

isDoubleBuffered
	"Answer whether the list display is double-buffered to avoid flicker. This is useful for
	lists that are frequently updated by background events."

	^lvStyle allMask: LVS_EX_DOUBLEBUFFER!

isDoubleBuffered: aBoolean 
	"Set whether the list display is double-buffered to avoid flicker. This is useful for
	lists that are frequently updated by background events."

	self listViewStyleMask: LVS_EX_DOUBLEBUFFER set: aBoolean!

isMultiSelect
	"Answer whether the receiver is in multi-select mode."

	^self baseStyle noMask: LVS_SINGLESEL!

isMultiSelect: aBoolean
	"Set whether the receiver is in multiple or single selection mode."

	| isSingleSelect primary |
	self isMultiSelect = aBoolean ifTrue: [^self].
	(isSingleSelect := aBoolean not)
		ifTrue: 
			["If switching to single-select from multi-select we must remove all but one
			 of the selections, since the view does not do this itself."
			primary := self primarySelectionIndex.
			self selectionByIndex: primary].
	self
		baseStyleMask: LVS_SINGLESEL
		set: isSingleSelect
		recreateIfChanged: false!

isReportMode
	^viewMode == #report!

isVirtual
	"Answer whether the receiver has the owner data style.
	This is not available in pre-IE4 versions of the CommCtrl Library
	but then those are no longer supported by Dolphin!!"

	^(self baseStyleAllMask: LVS_OWNERDATA)!

isVirtual: aBoolean
	"Sets the receiver to be virtual or not depending on the value of aBoolean (i.e. sets/clears
	the LVS_OWNERDATA style)."

	"Implementation Note: From MSDN: 'Dynamically switching to and from the LVS_OWNERDATA style
	is not supported.' i.e. Cannot be changed on-the-fly without view recreation."

	self
		baseStyleMask: LVS_OWNERDATA
		set: aBoolean
		recreateIfChanged: true.
	self isOpen
		ifTrue: 
			[self lvmSetCallbackMask: (self lvmGetCallbackMask mask: LVIS_STATEIMAGEMASK
						set: (aBoolean and: [self stateImageManager notNil]))]!

itemCount
	"Answer the total number of items in the view."

	^self sendMessage: LVM_GETITEMCOUNT!

itemFromPoint:  coord
	"Private - Answer the one-based index of the item in the control under the <Point>, coord,
	or nil if none."

	| ht |
	ht := self basicItemFromPoint: coord.
	^ht isItemHit ifTrue: [ht iItem+1]!

itemRect: anInteger textOnly: aBoolean
	"Answers the rectangle surrounding the indexed item within the receiver, optionally for the text label only."

	| rect |
	rect := RECTL newBuffer.
	aBoolean ifTrue: [rect left: LVIR_LABEL].
	(User32
		sendMessage: handle
		msg: LVM_GETITEMRECT
		wParam: anInteger - 1
		lpParam: rect) == 0
		ifTrue: [^self errorInCommonControlCall: anInteger - 1].
	^rect asRectangle!

itemsPerPage
	^self sendMessage: LVM_GETCOUNTPERPAGE!

itemStructure
	^LVITEMW!

largeIconExtent: aPointOrNil
	iconSpacing notNil
		ifTrue: 
			["Remove any custom spacing if insufficient for the icon size"
			self setIconSpacing: ((aPointOrNil notNil and: [aPointOrNil > iconSpacing]) ifFalse: [iconSpacing])].
	^super largeIconExtent: aPointOrNil!

largeIconMode
	"Place the receiver in large icons mode"

	self viewMode: #largeIcons!

lastSelIndices
	^lastSelIndices!

listMode
	"Place the receiver in list mode"

	self viewMode: #list!

listViewStyleMask: mask set: aBoolean
	"Private - Sets/clears the list view extended style bits in the <integer>, mask, 
	according to aBoolean. Answer the previous extended style flags."

	^self lvmSetExtendedListViewStyle: mask dwExStyle: aBoolean asParameter negated!

lvFlags
	^lvFlags ?? 0!

lvmApproximateViewRect: countInteger cx: cxInteger cy: cyInteger
	| dword |
	dword := User32
				sendMessage: handle
				msg: LVM_APPROXIMATEVIEWRECT
				wParam: countInteger
				lParam: ((cxInteger bitShift: 16) bitOr: (cyInteger bitAnd: 16rFFFF)).
	^(dword bitAnd: 16rFFFF) @ (dword bitShift: -16)!

lvmArrange: arrangeStyle
	"Private - Arrange items when in icon style."

	self
		sendMessageNz: LVM_ARRANGE
		wParam: arrangeStyle
		lpParam: 0!

lvmCreateDragImage: index position: position
	"Private - Answer a Handle for the drag image list and the argument, position,
	contains the upper-left position of the item (in view coordinates)."

	| dragList |
	^(dragList := User32
				sendMessage: handle
				msg: LVM_CREATEDRAGIMAGE
				wParam: index
				lpParam: position asParameter) == 0
		ifTrue: [self errorInCommonControlCall: index]
		ifFalse: [dragList asExternalHandle]!

lvmDeleteAllItems
	"Private - Remove all items from the ListView control.
	Answer whether the call succeeded."

	^(User32
		sendMessage: handle
		msg: LVM_DELETEALLITEMS
		wParam: 0
		lParam: 0) ~= 0!

lvmDeleteColumn: index
	"Private - Removes the column at index."

	(User32
		sendMessage: handle
		msg: LVM_DELETECOLUMN
		wParam: index
		lParam: 0) == 0
		ifTrue: [^self errorInCommonControlCall: index]!

lvmEnsureVisible: index partial: partialBoolean
	"Private - Ensure the item at index is visible."

	User32
		sendMessage: handle
		msg: LVM_ENSUREVISIBLE
		wParam: index
		lParam: partialBoolean asParameter!

lvmFindItem: aLvFindInfo startingAt: start
	"Private - Answer the index of the found item, or -1 there are none."

	^User32
		sendMessage: handle
		msg: LVM_FINDITEM
		wParam: start
		lpParam: aLvFindInfo!

lvmGetBkImage: aLVBKIMAGEW
	"Private - Populate the <LVBIMAGEW> argument with details of the receiver's background
	image. Answer whether the request succeeded."

	^(User32
		sendMessage: handle
		msg: LVM_GETBKIMAGEW
		wParam: 0
		lpParam: aLVBKIMAGEW) asBoolean!

lvmGetCallbackMask
	"Private - Answers the callback mask of the underlying control"

	^User32
		sendMessage: handle
		msg: LVM_GETCALLBACKMASK
		wParam: 0
		lParam: 0!

lvmGetColumnOrderArray
	"Private - Answer a <UInt32Array> containing the current left-to-right order 
	of columns in the receiver specified as zero-based positions. "

	| iCount iArray |
	iCount := self columnCount.
	iArray := UInt32Array new: iCount.
	self
		sendMessageNz: LVM_GETCOLUMNORDERARRAY
		wParam: iCount
		lpParam: iArray.
	^iArray!

lvmGetColumnWidth: columnIndex
	"Private - Answers the width of the column at the zero based columnIndex"

	^User32
		sendMessage: handle
		msg: LVM_GETCOLUMNWIDTH
		wParam: columnIndex
		lParam: 0!

lvmGetExtendedListViewStyle
	"Private - Answer the views extended style flags."

	^User32
		sendMessage: handle
		msg: LVM_GETEXTENDEDLISTVIEWSTYLE
		wParam: 0
		lpParam: 0!

lvmGetHeader
	"Private - Answer the handle of the header control."

	^User32
		sendMessage: handle
		msg: LVM_GETHEADER
		wParam: 0
		lParam: 0!

lvmGetImageList: wParam
	^User32
		sendMessage: handle
		msg: LVM_GETIMAGELIST
		wParam: wParam
		lParam: 0!

lvmGetItem: aLvItem
	"Private - Retrieve the requested items attributes into the argument, aLvItem."

	self
		sendMessageNz: LVM_GETITEMW
		wParam: 0
		lpParam: aLvItem!

lvmGetItemCount
	"Private - Answers the number of items in the underlying list-view control."

	^User32
		sendMessage: handle
		msg: LVM_GETITEMCOUNT
		wParam: 0
		lParam: 0!

lvmGetItemPosition: anInteger
	"Private - Answer the Point of the index item on the view."

	| pt |
	pt := POINTL newBuffer.
	(User32
		sendMessage: handle
		msg: LVM_GETITEMPOSITION
		wParam: anInteger
		lpParam: pt) == 0
		ifTrue: [^self errorInCommonControlCall: anInteger].
	^pt asPoint!

lvmGetItemSpacing
	| dword |
	dword := User32
				sendMessage: handle
				msg: LVM_GETITEMSPACING
				wParam: 0
				lParam: 0.
	^dword lowWord @ dword highWord!

lvmGetItemState: index mask: mask
	"Private - Answer the item's state flags."

	^User32
		sendMessage: handle
		msg: LVM_GETITEMSTATE
		wParam: index
		lParam: mask!

lvmGetNextItem: startIndex flags: niFlags
	"Private - Answer the next item found matching flags."

	^User32
		sendMessage: handle
		msg: LVM_GETNEXTITEM
		wParam: startIndex
		lParam: niFlags!

lvmGetOrigin
	"Private - Answer the current view origin. This will fail if the receiver is in list or report mode."

	| pt |
	pt := POINTL newBuffer.
	self
		sendMessageNz: LVM_GETORIGIN
		wParam: 0
		lpParam: pt.
	^pt asPoint!

lvmGetStringWidth: aString
	"Private - Answer the width of aString when displayed in this view."

	aString isEmpty ifTrue: [^0].
	^self
		sendMessageNz: LVM_GETSTRINGWIDTH
		wParam: 0
		lpParam: aString!

lvmGetSubItemRect: rowInteger subitem: colInteger bounding: flagInteger
	"Private - Answer a bounding Rectangle for all or part of a subitem."

	| rect |
	rect := RECTL newBuffer.
	rect
		top: colInteger;
		left: flagInteger.
	(User32
		sendMessage: handle
		msg: LVM_GETSUBITEMRECT
		wParam: rowInteger
		lpParam: rect) == 0
		ifTrue: [^self errorInCommonControlCall: rowInteger].
	^rect asRectangle!

lvmGetView
	"Private - Retrieve the current view mode."

	^User32
		sendMessage: handle
		msg: LVM_GETVIEW
		wParam: 0
		lParam: 0!

lvmGetViewRect
	"Private - Answer the bounding rectangle that contains all items in the control. This will
	fail if not in one of the icon modes."

	| rect |
	rect := RECTL newBuffer.
	self
		sendMessageNz: LVM_GETVIEWRECT
		wParam: 0
		lpParam: rect.
	^rect asRectangle!

lvmInsertAt: column column: anLvColumn
	"Private - Answer the index of the new column."

	| index |
	index := User32
				sendMessage: handle
				msg: LVM_INSERTCOLUMNW
				wParam: column
				lpParam: anLvColumn asParameter.
	^index == -1 ifTrue: [self errorInCommonControlCall] ifFalse: [index]!

lvmInsertItem: aLvItem
	"Private - Insert aLvItem into the tree view and add it to our contents dictionary"

	^User32
		sendMessage: handle
		msg: LVM_INSERTITEMW
		wParam: 0
		lpParam: aLvItem asParameter!

lvmRedrawItems: firstIndex to: lastIndex
	^User32
		sendMessage: handle
		msg: LVM_REDRAWITEMS
		wParam: firstIndex
		lpParam: lastIndex!

lvmSetBkImage: aLVBKIMAGEW
	"Private - Set the background image according to the information held in the <LVBKIMAGEW> argument."

	^(User32
		sendMessage: handle
		msg: LVM_SETBKIMAGEW
		wParam: 0
		lpParam: aLVBKIMAGEW) asBoolean!

lvmSetCallbackMask: anInteger
	"Private - Answers the callback mask of the underlying control."

	^User32
		sendMessage: handle
		msg: LVM_SETCALLBACKMASK
		wParam: anInteger
		lParam: 0!

lvmSetColumn: anLvColumn at: columnIndex
	"Private - Set the attributes of a column."

	self
		sendMessageNz: LVM_SETCOLUMNW
		wParam: columnIndex
		lpParam: anLvColumn asParameter!

lvmSetColumnOrderArray: iArray
	"Private - Sets the left-to-right order of columns in the receiver to the zero-based positions
	specified in the <Int32Array> argument, iArray."

	User32
		sendMessage: handle
		msg: LVM_SETCOLUMNORDERARRAY
		wParam: iArray size
		lpParam: iArray!

lvmSetColumnWidth: itemIndex to: anInteger
	"Private - Set the width of the column identified by itemIndex to anInteger."

	"wParam = (WPARAM) (int) iCol; 
	lParam = MAKELPARAM((int) cx, 0); "

	^User32
		sendMessage: handle
		msg: LVM_SETCOLUMNWIDTH
		wParam: itemIndex
		lParam: anInteger!

lvmSetExtendedListViewStyle: style
	"Private - Set the extended styles of the receiver.
	Implementation Note: Present for backward compatibility with pre-3.0 resources."

	#deprecated.
	lvStyle := style bitOr: LVS_EX_DOUBLEBUFFER.
	User32
		sendMessage: handle
		msg: LVM_SETEXTENDEDLISTVIEWSTYLE
		wParam: 0
		lpParam: style asParameter!

lvmSetExtendedListViewStyle: dwExMask dwExStyle: dwExStyle
	"Private - Set or reset the masked extended styles of the receiver.
	Answer the previous style flags."

	| prevStyle |
	prevStyle := User32
				sendMessage: handle
				msg: LVM_SETEXTENDEDLISTVIEWSTYLE
				wParam: dwExMask
				lParam: dwExStyle.
	lvStyle := (prevStyle bitAnd: dwExMask bitInvert) bitOr: (dwExStyle bitAnd: dwExMask).
	^prevStyle!

lvmSetIconSpacing: aPoint
	"Private - Set the spacing between icons displayed in the receiver.
	Answers the previous icon spacing packed into a 32-bit integer."

	^User32
		sendMessage: handle
		msg: LVM_SETICONSPACING
		wParam: 0
		lpParam: aPoint asUIntPtr!

lvmSetImageList: aWinImageList type: anIntegerImageType
	"Private - Set the receiver's normal/state image list depending on anIntegerImageType.
	Answer the handle of the previous image list."

	^User32
		sendMessageU: handle
		msg: LVM_SETIMAGELIST
		wParam: anIntegerImageType
		lParam: aWinImageList asParameter!

lvmSetItem: anLvItem
	"Private - Set some or all of the receiver's default attributes as 
	specified in the argument, anLvItem."

	self
		sendMessageNz: LVM_SETITEMW
		wParam: 0
		lpParam: anLvItem asParameter!

lvmSetItem: anInteger position: aPos
	"Private - Move an item to the specified position in the receiver when
	in large or small icon mode"

	User32
		sendMessage: handle
		msg: LVM_SETITEMPOSITION
		wParam: anInteger
		lpParam: aPos asParameter!

lvmSetItem: index state: anLvItem
	"Private - Set an item's state to that in anLvItem."

	(User32
		sendMessage: handle
		msg: LVM_SETITEMSTATE
		wParam: index
		lpParam: anLvItem asParameter) == 0
		ifTrue: 
			["Control didn't like it, try and deduce why..."
			^self errorInCommonControlCall: index]!

lvmSetItemCount: size
	"Private - Prepare a list view for adding a large number of items, or set the number of items in a virtual list."

	User32
		sendMessage: handle
		msg: LVM_SETITEMCOUNT
		wParam: size
		lParam: 0!

lvmSetItemText: anLvItem index: index
	"Private - Change the text of an item or subitem."

	(User32
		sendMessage: handle
		msg: LVM_SETITEMTEXTW
		wParam: index
		lpParam: anLvItem asParameter) == 0
		ifTrue: [^self errorInCommonControlCall: index]!

lvmSetView: anInteger
	User32
		sendMessage: handle
		msg: LVM_SETVIEW
		wParam: anInteger
		lParam: 0!

lvmUpdate: anInteger
	"Private - Update an item at the specified zero-based <integer> index in the receiver.
	If in auto arrange mode then arrange."

	(User32
		sendMessage: handle
		msg: LVM_UPDATE
		wParam: anInteger
		lParam: 0) == 0
		ifTrue: [^self errorInCommonControlCall: anInteger]!

lvnBeginScroll: pNMHDR 
	^nil!

lvnColumnClick: anNMHDR 
	"Private - Default handler for the LVN_COLUMNCLICK notification message.
	Attempts to maintain current selection and to keep it visible."

	| nmlv |
	nmlv := self notificationClass fromAddress: anNMHDR yourAddress.
	self columnClicked: nmlv iSubItem + 1.
	^0!

lvnColumnDropDown: pNMHDR
	^nil!

lvnColumnOverflowClick: pNMHDR
	^nil!

lvnDeleteAllItems: pNMHDR
	"Private - Default handler for the LVN_DELETEALLITEMS notification message.
	Answer true (1) to suppress individual LVN_DELETEITEM notifications."

	^TRUE

	!

lvnEndScroll: pNMHDR 
	^nil!

lvnFindItem: pNMHDR
	| f lvfi nmlv |
	nmlv := NMLVFINDITEMW fromAddress: pNMHDR.
	lvfi := nmlv lvfi.
	f := lvfi flags.
	(f allMask: LVFI_STRING) ifFalse: [^-1	"Can't find it"].
	^(self
		findItem: lvfi psz
		startingAt: nmlv iStart + 1
		wrap: (f allMask: LVFI_WRAP)) - 1!

lvnGetEmptyMarkup: pNMHDR
	^nil!

lvnGetInfoTip: pNMHDR
	"Private - Default handler for the LVN_GETINFOTIPW notification message."

	| nmlv target prefixText |
	nmlv := NMLVGETINFOTIPW fromAddress: pNMHDR.
	target := self objectFromHandle: nmlv itemHandle ifAbsent: UnknownItem.
	"ListView may occassionally ask for info tip for item we don't have (e.g. off end of list)"
	target == UnknownItem ifTrue: [^0].
	prefixText := nmlv dwFlags == 0 ifTrue: [nmlv text] ifFalse: [''].	"If in report mode and the column has an info. tip block then we delegate to it, otherwise fill it in."
	nmlv
		text: ((self isReportMode
				ifTrue: 
					[| column |
					column := self columnAtIndex: nmlv iSubItem + 1.
					column getInfoTipBlock notNil ifTrue: [column] ifFalse: [self]]
				ifFalse: [self]) infoTipFromRow: target withPrefix: prefixText).
	^0	"Return value is ignored"!

lvnHotTrack: anAddress 
"	| nmlv |
	nmlv := OS.NMLISTVIEW fromAddress: anAddress."
	^0!

lvnIncrementalSearch: pNMHDR
	^nil!

lvnInsertItem: pNMHDR
	"Private - Default handler for the LVN_INSERTITEM notification message.
	Answer nil to accept default processing."

	^nil


	!

lvnItemActivate: anExternalAddress
	^0!

lvnItemChanged: anNMHDR
	"Private - Item has changed.
	We no longer use this notification to look for selection changes, as it
	is absurdly difficult to tell what is going on from a disconnected series
	of events with no indication as to the overall effect."

	^0!

lvnItemChanging: pNMHDR
	"Private - Default handler for the LVN_ITEMCHANGING notification message.
	Answer false (0) to allow the change, or true (1) to prevent it"

	^0
!

lvnLinkClick: pNMHDR
	^nil!

lvnMarqueeBegin: anExternalAddress 
	^0!

lvnODStateChanged: pNMHDR
	"Private - Default handler for the LVN_ODSTATECHANGED notification message."

	"	| nmlv |
	nmlv := NMLVODSTATECHANGE fromAddress: anNMHDR yourAddress."

	^0!

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

nmBeginDrag: pNMHDR
	self maybeSelChanging: #mouse.
	^super nmBeginDrag: pNMHDR!

nmBeginRDrag: pNMHDR
	self maybeSelChanging: #mouse.
	^super nmBeginRDrag: pNMHDR!

nmClick: pNMHDR
	"Private - Handler for a NM_CLICK notification message.
	We intercept this to catch potential selection changes resulting from a drag-select
	operation."

	self maybeSelChanging: #mouse.
	^super nmClick: pNMHDR!

nmNotify: pNMHDR
	"Private - Handler for a redirected ListView WM_NOTIFY message."

	^(##((Array new: LVN_FIRST - LVN_GETEMPTYMARKUP + 1 withAll: #nmDummy:)
		at: LVN_FIRST - LVN_ITEMCHANGING + 1 put: #lvnItemChanging:;
		at: LVN_FIRST - LVN_ITEMCHANGED + 1 put: #lvnItemChanged:;
		at: LVN_FIRST - LVN_INSERTITEM + 1 put: #lvnInsertItem:;
		at: LVN_FIRST - LVN_DELETEITEM + 1 put: #nmDeleteItem:;
		at: LVN_FIRST - LVN_DELETEALLITEMS + 1 put: #lvnDeleteAllItems:;
		at: LVN_FIRST - LVN_BEGINLABELEDITW + 1 put: #nmBeginLabelEdit:;
		at: LVN_FIRST - LVN_ENDLABELEDITW + 1 put: #nmEndLabelEdit:;
		at: LVN_FIRST - LVN_COLUMNCLICK + 1 put: #lvnColumnClick:;
		at: LVN_FIRST - LVN_BEGINDRAG + 1 put: #nmBeginDrag:;
		at: LVN_FIRST - LVN_BEGINRDRAG + 1 put: #nmBeginRDrag:;
		at: LVN_FIRST - LVN_ODCACHEHINT + 1 put: #nmDummy:;
		at: LVN_FIRST - LVN_ITEMACTIVATE + 1 put: #lvnItemActivate:;
		at: LVN_FIRST - LVN_ODSTATECHANGED + 1 put: #lvnODStateChanged:;
		at: LVN_FIRST - LVN_HOTTRACK + 1 put: #lvnHotTrack:;
		at: LVN_FIRST - LVN_GETDISPINFOW + 1 put: #nmGetDispInfoW:;
		at: LVN_FIRST - LVN_SETDISPINFOW + 1 put: #nmSetDispInfoW:;
		at: LVN_FIRST - LVN_ODFINDITEMW + 1 put: #lvnFindItem:;
		at: LVN_FIRST - LVN_KEYDOWN + 1 put: #nmKeyDown:;
		at: LVN_FIRST - LVN_MARQUEEBEGIN + 1 put: #lvnMarqueeBegin:;
		at: LVN_FIRST - LVN_GETINFOTIPW + 1 put: #lvnGetInfoTip:;
		at: LVN_FIRST - LVN_INCREMENTALSEARCHW + 1 put: #lvnIncrementalSearch:;
		at: LVN_FIRST - LVN_COLUMNDROPDOWN + 1 put: #lvnColumnDropDown:;
		at: LVN_FIRST - LVN_COLUMNOVERFLOWCLICK + 1 put: #lvnColumnOverflowClick:;
		at: LVN_FIRST - LVN_BEGINSCROLL + 1 put: #lvnBeginScroll:;
		at: LVN_FIRST - LVN_ENDSCROLL + 1 put: #lvnEndScroll:;
		at: LVN_FIRST - LVN_LINKCLICK + 1 put: #lvnLinkClick:;
		at: LVN_FIRST - LVN_GETEMPTYMARKUP + 1 put: #lvnGetEmptyMarkup:;
		yourself) lookup: ##(LVN_FIRST + 1) - (pNMHDR int32AtOffset: 8))
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

nmRClick: pNMHDR
	"Private - Handler for a NM_RCLICK notification message.
	We intercept this to catch potential selection changes resulting from a drag-select
	operation."

	self maybeSelChanging: #mouse.
	^super nmRClick: pNMHDR!

nmSelChanged: anExternalAddress 
	"Private - Default handler for the ??N_SELCHANGED notification message."

	"We don't expect to receive this for ListViews."

	self shouldNotImplement!

notificationClass
	"Private - Answer the class of NM_XXXXVIEW structure associated with the receiver."

	^NMLISTVIEW!

onButtonPressed: aMouseEvent
	"Private - Common handler for a button down mouse event. Look for potential selection change events, and fire a #selectionChanging: event if necessary. The mouse event is only allowed to propagate to the control if we are happy that the selection should indeed be changed."

	| indices |
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

onDisplayDetailsRequired: anLVITEM
	"Private - Get the display info for the receiver's row identified by the <LVITEM>, lvitem."

	"N.B. This is a callback request from the ListView's paint handler so setting an
	unconditional breakpoint in here may bring your image to its knees as the LV repeatedly
	attempts to paint a damaged region."

	"Implementation Note: If in report mode then the task of supplying the text/images is
	delegated to the particular column, otherwise the valuables local to the receiver are used.
	This may seem inconsistent, but it allows different text/images to be displayed for the
	primary column if the application requires that the view be dynamically switchable between
	#report mode and the other modes."

	| rowObject mask column subItem |
	rowObject := self objectFromHandle: anLVITEM handle ifAbsent: UnknownItem.
	"List sometimes asks for lvitem we no longer have, answer nil to accept default processing"
	rowObject == UnknownItem ifTrue: [^nil].
	subItem := anLVITEM iSubItem.
	self isReportMode ifTrue: [column := columns at: subItem + 1].
	mask := anLVITEM mask.

	"Image Request?"
	(mask allMask: LVIF_IMAGE)
		ifTrue: 
			[anLVITEM
				iImage: ((((column notNil and: [self hasColumnImages]) ifTrue: [column] ifFalse: [self])
						imageFromRow: rowObject) ?? NoImageIndex)
						- 1].

	"Text request?"
	(mask allMask: LVIF_TEXT)
		ifTrue: 
			["If in report mode the column's get text block is used unless the request
			 is for the primary column and its text block is nil, in which case the view
			 level block is used"
			anLVITEM
				textInBuffer: (((column notNil and: [subItem ~~ 0 or: [column getTextBlock notNil]])
						ifTrue: [column]
						ifFalse: [self]) textFromRow: rowObject)].
	(mask allMask: LVIF_INDENT)
		ifTrue: 
			["Indenting is only supported for the whole row, not on a per-column basis"
			anLVITEM iIndent: (self indentFromRow: rowObject)].
	"State image"
	(subItem == 0 and: [mask allMask: LVIF_STATE])
		ifTrue: 
			[(self stateImageFromRow: rowObject) ifNotNil: [:stateImage | anLVITEM iStateImage: stateImage]].
	^0	"suppress default processing"!

onDropDown: aToolbarButton 
	"Private - The receiver's toolbar has sent a notification that a button's drop-down arrow
	has been pressed. Generate and pop-up the appropriate menu."

	| popup |
	aToolbarButton command asSymbol == #viewModeSelect ifFalse: [^nil].
	popup := self buildViewsPopup.
	popup queryAllAlong: self commandPolicy recursive: true.
	popup showIn: self position: aToolbarButton screenRectangle bottomLeft.
	^0!

onEraseRequired: aColorEvent
	"Handler for erase background. ListView controls manage their own background colours so
	we pass on erase background requests"

	^nil "Perform default processing"!

onItem: anObject removedAtIndex: anInteger 
	"Event received when the <Object>, anObject, has been removed from the receiver's
	model at the <integer> index, anInteger. Remove the appropriate object from the list,
	and trigger a selection changed event if the removed item was previously selected."

	"Implementation Note: Override in order to maintain the lastSel correctly."

	super onItem: anObject removedAtIndex: anInteger.
	self updateSelectionCache!

onItems: aSequenceableCollection addedAtIndex: anInteger
	"Event received when the specified sequence of objects has been added to the receiver's model beginning at the specified <integer> index. By default, do nothing."

	self isVirtual
		ifTrue: 
			[| count |
			count := aSequenceableCollection size.
			"In a virtual list, if more than a few items are being added, we may as well just update the virtual size. This will cause the list to be redrawn completely, but unless inserting at the end that is likely anyway, and this is many times faster than sending multiple LVM_INSERTITEM messages."
			count > 3
				ifTrue: [self lvmSetItemCount: self lvmGetItemCount + count]
				ifFalse: 
					[| lvItem |
					lvItem := LVITEMW allCallbacks.
					anInteger - 1 to: anInteger + count - 2
						do: 
							[:index |
							lvItem iItem: index.
							self lvmInsertItem: lvItem]]]
		ifFalse: 
			[self
				addOrUpdate: false
				nonVirtualItems: aSequenceableCollection
				afterIndex: anInteger - 1].
	self updateSelectionCache!

onKeyPressed: aKeyEvent
	"Default handler for a key press event.
	In addition to the superclass actions we need to look for potential selection
	changes caused by navigational keys and give observers the chance to
	reject the change of selection."

	| answer |
	answer := super onKeyPressed: aKeyEvent.
	self maybeSelChanging: #keyboard.
	^answer!

onKeyTyped: aKeyEvent
	"Default handler for a keyboard event.
	In addition to the superclass actions we need to look for potential selection
	changes caused by navigational keys and give observers the chance to
	reject the change of selection."

	| answer |
	answer := super onKeyTyped: aKeyEvent.
	self maybeSelChanging: #keyboard.
	^answer!

onLeftButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse left button double-click event."

	| answer handled |
	self presenter trigger: #leftButtonDoubleClicked: with: aMouseEvent.
	handled := aMouseEvent isHandled.
	answer := aMouseEvent defaultWindowProcessing.
	(handled not and: 
			[self hasFullRowSelect or: 
					[| hit |
					hit := self basicItemFromPoint: aMouseEvent position.
					hit iItem >= 0 and: [hit iSubItem == 0]]])
		ifTrue: [self presenter performAction].
	^answer!

onLeftButtonPressed: aMouseEvent
	"Handle a left button down mouse event. We intercede here in order 
	to detect selection change events, and, if the view/presenter don't want 
	the selection changed, then the message is absorbed without passing 
	it to the control. Otherwise accept the default window processing."

	self presenter trigger: #leftButtonPressed: with: aMouseEvent.
	^self onButtonPressed: aMouseEvent.!

onPositionChanged: aPositionEvent
	"We must resize any auto-sizing columns *before* WM_WINDOWPOSCHANGED is passed to the
	control, as that is when it updates scrollbars which can cause the horizontal scrollbar to
	briefly flicker if the column widths are not adjusted beforehand (#2103)."

	(aPositionEvent isResize and: [self isReportMode])
		ifTrue: 
			[| clientRect clientWidth count |
			clientRect := self
						adjustForStaticEdgeBug: (self calcClientRectangleFromRectangle: aPositionEvent rectangle).
			clientWidth := clientRect width.
			count := self itemCount.
			count > 0
				ifTrue: 
					[| requiredHeight |
					requiredHeight := self lvmGetOrigin y + (self itemRect: count) bottom.
					requiredHeight > clientRect height
						ifTrue: [clientWidth := clientWidth - SystemMetrics current scrollbarWidth]].
			self autoResizeColumns: clientWidth].
	^super onPositionChanged: aPositionEvent!

onRightButtonPressed: aMouseEvent
	"Handle a right button down mouse event. We intercede here 
	in order to detect selection change events, and, if the view/presenter don't want 
	the selection changed, then the message is absorbed without passing it to the 
	control. Otherwise accept the default window processing."

	self presenter trigger: #rightButtonPressed: with: aMouseEvent.
	^self onButtonPressed: aMouseEvent!

onSelChanged: anArray 
	lastSelIndices := anArray.
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

onSelRemoved
	"Private - A selected item has been removed. Update the receiver's selection state to
	account."

	self onSelChanged: self getSelectionsByIndex!

onStateRestored
	self backImage ifNotNil: [self backImageChanged]!

onViewCreated
	"The receiver window has been created. Copy the info held in instance variables across to it, and perform any other state initialization that is required on attachment of the receiver's associated native window."

	super onViewCreated.
	noRedrawCount := 0.
	approvedSelIndices := nil.
	self setControlBackcolor.
	self forecolor ifNotNil: [:fore | self forecolor: fore].
	self allColumns
		keysAndValuesDo: [:eachIndex :eachColumn | self basicAddColumn: eachColumn atIndex: eachIndex].
	self viewMode: self viewMode.
	self lvmSetExtendedListViewStyle: -1 dwExStyle: lvStyle.
	self basicRefreshContents.
	self applyImageLists.
	self basicSelectionsByIndex: lastSelIndices.
	self iconSpacing ifNotNil: [:spacing | self lvmSetIconSpacing: spacing].
	(self isVirtual and: [self stateImageManager notNil])
		ifTrue: [self lvmSetCallbackMask: LVIS_STATEIMAGEMASK]!

primaryColumn
	"Private - Answer the primary column for the report view mode"

	^columns first!

queryCommand: aCommandQuery
	"Update aCommandQuery to indicate how a command would be processed.
	if sent to the receiver. Answers whether the receiver recognised the command
	as one of its own (this may be ignored by the command router)."

	| cmd |
	cmd := aCommandQuery commandSymbol.
	
	#extraLargeIconMode == cmd ifTrue: [
		aCommandQuery isChecked: (self viewMode==#extraLargeIcons)].
	#tileIconMode == cmd ifTrue: [
		aCommandQuery isChecked: (self viewMode==#tileIcons)].
	#largeIconMode == cmd ifTrue: [
		aCommandQuery isChecked: (self viewMode==#largeIcons)].
	#listMode == cmd ifTrue: [
		aCommandQuery isChecked: (self viewMode==#list)].
	#reportMode == cmd ifTrue: [
		aCommandQuery isChecked: (self viewMode==#report)].
	#thumbnailsMode == cmd ifTrue: [
		aCommandQuery isChecked: (self viewMode==#thumbnails)].

	^super queryCommand: aCommandQuery!

refreshContents
	"Refresh the receiver's contents from the model"

	self isOpen ifFalse: [^self].
	self basicRefreshContents.
	self applyImageLists.
	"List will not send selection change event when ALL items deleted, so we need one now"
	self onSelChanged!

refreshNonVirtual
	self withOldWndProc: [self noRedrawDo: 
					[self basicClear.
					self addAllNonVirtual]]!

removeColumn: aListViewColumn
	"Remove the column from the view."

	self removeColumnAtIndex: (self allColumns indexOf: aListViewColumn)!

removeColumnAtIndex: columnIndex
	"Remove the Column at columnIndex with all its subitems."

	lastClickedColIndex isNil
		ifFalse: 
			[columnIndex = lastClickedColIndex
				ifTrue: [lastClickedColIndex := nil]
				ifFalse: [columnIndex < lastClickedColIndex ifTrue: [lastClickedColIndex := lastClickedColIndex - 1]]].
	(columns removeAtIndex: columnIndex) parent: nil.
	self basicRemoveColumnAtIndex: columnIndex.
	self
		autoResizeColumns;
		invalidate;
		update!

reportMode
	self viewMode: #report!

resetSelection
	"Set the receiver to have no selection.
	Note that deliberate programmatic changes of the selection do not generate
	#selectionChanging: event, but they do generate #selectionChanged events."

	lastSelIndices notEmpty 
		ifTrue: 
			[self
				basicResetSelection;
				onSelChanged]!

resolutionScaledBy: scale
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by <Point>
	scale. Note that the placement (position and extent) of the receiver has already been scaled
	in #restorePlacement:resolution:."

	self allColumns do: [:each | each resolutionScaledBy: scale].
	iconSpacing ifNotNil: [self iconSpacing: (iconSpacing * scale) truncated]!

selectAll
	| size |
	size := self size.
	self selectedCount ~= size ifTrue: [self selectionsByIndex: (1 to: size)]!

selectedCount
	"Private - Answer the total number of items selected in the receiver."

	^lastSelIndices size!

selectIndex: anInteger set: aBoolean
	"Private - Set/reset the selection state of the object at the specified one-based <integer>
	index within the receiver according to the <boolean> argument."

	| anLvItem |
	anLvItem := LVITEMW newBuffer.
	anLvItem stateMask: SelectionStateMask.
	aBoolean ifTrue: [anLvItem dwState: SelectionStateMask].
	self lvmSetItem: anInteger - 1 state: anLvItem!

selectIndices: aCollection set: aBoolean
	| anLvItem |
	anLvItem := LVITEMW newBuffer.
	anLvItem stateMask: SelectionStateMask.
	aBoolean ifTrue: [anLvItem dwState: SelectionStateMask].
	self isMultiSelect
		ifTrue: [aCollection do: [:each | self lvmSetItem: each - 1 state: anLvItem]]
		ifFalse: [self lvmSetItem: aCollection first - 1 state: anLvItem]!

selectionByIndex
	"Answer the 1-based <integer> index of the selected item in the view, or zero if there is not exactly one selection."

	^lastSelIndices size == 1 ifTrue: [lastSelIndices at: 1] ifFalse: [0]!

selections: aCollection ifAbsent: aNiladicOrMonadicValuable
	"Select the first occurrences of the specified collection of <Object>s in the receiver and
	answer the new selection. If any of the elements of the collection are not present in the
	receiver's list, then answer the result of evaluating the <monadicValuable>,
	exceptionHandler. If the exception handler expects a single argument it is passed a
	<collection> of the missing items."

	| missing indices |
	missing := OrderedCollection new: aCollection size.
	indices := self handlesFromObjects: aCollection whenAbsent: [:e | missing addLast: e].
	self setSelectionsByIndex: indices.
	^missing isEmpty ifTrue: [aCollection] ifFalse: [aNiladicOrMonadicValuable cull: missing]!

selectionsByIndex
	"Answer an <Array> of the <integer> the indices of the selected items in the receiver in ascending order. The array will be empty if there is no selection."

	^lastSelIndices!

selectionsByIndex: aCollection ifAbsent: exceptionHandler
	"Select the objects identified by the <collection> of <integer> indices, aCollection, in the
	receiver. If any of the indices are out of bounds, then evaluate the <monadicValuable>,
	exceptionHandler, passing it a <collection> of the offending indices. For backwards
	compatibility with the superclass implementation, exceptionHandler can also be a
	<niladicValuable>, but in that the exception handler must work out for itself which indices
	were missing."

	| inRange size |
	size := self size.
	inRange := aCollection select: [:i | i between: 1 and: size].
	self setSelectionsByIndex: inRange.
	^aCollection size ~= inRange size
		ifTrue: [exceptionHandler cull: (aCollection difference: inRange)]
		ifFalse: [inRange]!

setColumnIcon: anImage atIndex: anInteger
	| lvcol |
	lvcol := LVCOLUMNW newBuffer.
	lvcol alignment: (self columnAtIndex: anInteger) alignment.
	anImage isNil
		ifFalse: 
			[lvcol image: (imageManager indexOfImage: anImage) - 1.
			lvcol fmt: (lvcol fmt bitOr: ##(LVCFMT_BITMAP_ON_RIGHT | LVCFMT_IMAGE))].
	self lvmSetColumn: lvcol at: anInteger - 1!

setControlBackcolor: aColor 
	| clrref |
	clrref := aColor asCOLORREF.
	self 
		sendMessage: LVM_SETBKCOLOR
		wParam: 0
		lParam: clrref.
	self 
		sendMessage: LVM_SETTEXTBKCOLOR
		wParam: 0
		lParam: clrref!

setIconSpacing: aPointOrNil
	self lvmSetIconSpacing: aPointOrNil ?? (-1 @ -1)!

setItem: anInteger checked: aBoolean
	"Set whether the item with the specified index is 'checked' or not. This will have unpredictable effects if the list is not in `hasCheckBoxes` mode."

	| item |
	item := LVITEMW newBuffer
				iStateImage: aBoolean asParameter + 1;
				yourself.
	self lvmSetItem: anInteger - 1 state: item!

setNoRedrawCount: anInteger
	noRedrawCount := anInteger max: 0!

setSelectionsByIndex: indices
	"Use the actual selections that resulted - we need to check these again against the last selections, as in the single selection case the actual selection may not have changed if multiple selections were requested and the first is still the same as the previous single selection."

	| selections |
	(indices noDifference: lastSelIndices) ifTrue: [^self].
	self basicSelectionsByIndex: indices.
	selections := self getSelectionsByIndex.
	selections = lastSelIndices ifTrue: [^self].
	self ensureItemsVisible: selections.
	self onSelChanged: selections!

setSingleSelection: anInteger 
	self selectIndex: anInteger set: anInteger ~~ 0!

setViewMode: aSymbol 
	viewMode := aSymbol!

setWidthOfColumn: colIndexInteger to: widthInteger
	"Set the width of the column identified by itemIndex to anInteger."

	self lvmSetColumnWidth: colIndexInteger - 1 to: widthInteger.
	self autoResizeColumns.
	self invalidateLayout!

showDropHighlight: item
	"Private - Shows a drop highlight for the item at the specified one-based <Integer> 
	index within the receiver."

	| anLvItem |
	anLvItem := LVITEMW newBuffer.
	anLvItem
		stateMask: LVIS_DROPHILITED;
		dwState: LVIS_DROPHILITED.
	self
		lvmSetItem: item - 1 state: anLvItem;
		update.
	super showDropHighlight: item!

showsSelAlways
	"Answers true if the receiver always displays its selection, if any, even
	if it doesn't have focus."

	^self baseStyleAllMask: LVS_SHOWSELALWAYS!

showsSelAlways: aBoolean
	"Set whether the receiver always displays its selection, if any, even
	if it doesn't have focus."

	self baseStyleMask: LVS_SHOWSELALWAYS set: aBoolean recreateIfChanged: false!

smallIconMode
	"Place the receiver in small icons mode"

	self viewMode: #smallIcons!

sortOnColumn: aListViewColumn
	"Sorts the receiver according to the sort block in aListViewColumn"

	aListViewColumn isSortable
		ifTrue: [Cursor wait showWhile: [self presenter beSorted: aListViewColumn rowSortBlock]]!

state
	"Private - Answer a MessageSequence which, when replayed, will restore the receiver 
	to its current state"

	| sequence order |
	sequence := super state.
	self isReportMode
		ifTrue: 
			["Ensure the actual column widths are cached"
			self allColumns
				keysAndValuesDo: [:eachKey :eachValue | eachValue basicWidth: (self lvmGetColumnWidth: eachKey - 1)]].
	"Record the column order if anything other than ascending"
	(order := self columnOrder) = (1 to: self columnCount)
		ifFalse: 
			[sequence add: (MessageSend
						receiver: self
						selector: #columnOrder:
						argument: order)].
	^sequence!

stateImageFromRow: anObject
	"Private - Answer the index of the state image for the row <Object> argument, or nil if none."

	^nil!

subItemRectRow: rowInteger column: colInteger
	"Answer a <Rectangle> representing the bounds of the sub-item at the specified row and column."

	| fullRect item subitem |
	item := rowInteger - 1.
	subitem := colInteger - 1.
	fullRect := self
				lvmGetSubItemRect: item
				subitem: subitem
				bounding: LVIR_LABEL.
	^(columns at: colInteger) getImageBlock
		ifNil: [fullRect]
		ifNotNil: 
			[| iconRect |
			"We need to subtract the icon rect and adjust for the gap too"
			iconRect := self
						lvmGetSubItemRect: item
						subitem: subitem
						bounding: LVIR_ICON.
			iconRect right: iconRect right + 4.
			fullRect subtract: iconRect]!

text: aString
	"Sets the title text for the receiver. We also set the primary
	column title from this"

	super text: aString.
	self primaryColumn text: aString!

textFromRow: item
	"Private - Answer the text for the row which represents the <Object>, item.
	As of Dolphin 3.0 the text block is permitted to be nil for the unusual case 
	where the row contains only images.
	As of Dolphin 4.0 #displayString is always sent to the result of the getTextBlock,
	which is useful in those cases where one forgets to answer a String. 
	#displayString on String is a very fast nop, so the extra safety costs little."

	^getTextBlock isNil 
		ifTrue: ['']
		ifFalse: [(getTextBlock value: item) displayString]
!

thumbnailExtent
	^thumbnailExtent ifNil: [self defaultThumbnailExtent]!

thumbnailExtent: aPointOrNil
	thumbnailExtent = aPointOrNil ifTrue: [^self].
	thumbnailExtent := aPointOrNil = self defaultThumbnailExtent ifFalse: [aPointOrNil].
	self viewMode == #thumbnails ifTrue: [self viewModeChanged]!

thumbnailsImageManager
	"Private - Answer the  private <ImageManager> containing images for the large images size modes of the receiver.
	A private image manager is used to avoid bloating the default IconImageManager with large images for every
	icon that is rendered in a control that uses image lists."

	thumbnailsImageManager isNil
		ifTrue: 
			[thumbnailsImageManager := ImageManager new.
			thumbnailsImageManager maskcolor: Color default].
	^thumbnailsImageManager!

thumbnailsMode
	"Place the receiver in thumbnails mode"

	self viewMode: #thumbnails!

tileIconMode
	"Place the receiver in tile icons mode"

	self viewMode: #tileIcons!

updateAllNonVirtual
	"Private - Update the text and images the list view stores for each item in this non-virtual list."

	self 
		addOrUpdate: true
		nonVirtualItems: self list
		afterIndex: 0!

updateAllVirtual
	"Private - Re-render a virtual list. In this case we have a special operation which allows us to
	repaint the list content without invalidating the column headings, etc, thus reducing
	flashing."

	self lvmRedrawItems: 0 to: self size - 1!

updateColumn: aListViewColumn
	"Private - Update the view to reflect the current state of aListViewColumn."

	self basicUpdateColumn: aListViewColumn.
	self updateAll!

updateItem: anObject atIndex: anInteger
	"Re-render the specified item, which is at the specified <integer> index in the list."

	self isVirtual
		ifTrue: 
			["We always use callback mode, so we can simply request that the item be
			redrawn, and let the ListView re-request the details."
			self lvmRedrawItems: anInteger - 1 to: anInteger - 1]
		ifFalse: 
			[self
				addOrUpdate: true
				nonVirtualItems: {anObject}
				afterIndex: anInteger - 1]!

updateSelectionCache
	"Private - The receiver's model is being modified, so we may need to account for selection changes caused by that.
	Of course this can't add a selection if there is none."

	lastSelIndices isEmpty ifFalse: [lastSelIndices := self getSelectionsByIndex].
	approvedSelIndices := nil!

viewMode
	"Answer the view mode of the receiver.
	This can be one of: 
		#smallIcon		- 16x16 icon, (LVS_SMALLICONS)
		#largeIcons	- 32x32 icon, (LVS_ICON)
		#tileIcons		- 48x48 icon, (LVS_ICON)
		#thumbnails 	- custom size, default 64x64 (LVS_ICON) 
		#extraLargeIcons - 256x256 (LVS_ICON)
		#list			- 16x16 icon, fixed columnar arrangement(LVS_LIST)
		#report		- 16x16 icons, multi-column view, normally with column headers (LVS_REPORT)"

	^viewMode!

viewModeChanged
	| style |
	(self customImageExtent
		ifNil: 
			[viewMode == #largeIcons
				ifTrue: [Icon largeExtent]
				ifFalse: [viewMode == #tileIcons ifTrue: [Icon tileExtent]]])
			ifNil: [self applyImageLists]
			ifNotNil: [:ext | self largeIconExtent: ext].
	style := LvModes at: viewMode ifAbsent: [LVS_REPORT].
	self
		baseStyle: style
		maskedBy: LVS_TYPEMASK
		recreateIfChanged: false.
	self autoResizeColumns.
	self updateAll.
	self trigger: #viewModeChanged!

viewModeSelect
	"Toggle the view mode of the receiver"

	self 
		viewMode: (#(#report #extraLargeIcons #thumbnails #tileIcons #largeIcons #smallIcons #list #report) 
				after: self viewMode)!

wantCustomDrawItemNotifications: pNMHDR
	^self customDrawBlock notNil or: [self hasSubItemCustomDraw]! !
!UI.ListView categoriesForMethods!
addAllNonVirtual!private!updating! !
addColumn!adding!columns!public! !
addColumn:!adding!columns!public! !
addColumn:atIndex:!adding!columns!public! !
addOrUpdate:nonVirtualItems:afterIndex:!private!updating! !
adjustForStaticEdgeBug:!helpers!private! !
allColumns!columns!public! !
anchorIndex!public!selection! !
anchorIndex:!public!selection! !
applyImageLists!image management!private! !
autoResizeColumns!operations!private! !
autoResizeColumns:!helpers!private! !
backcolorChanged!helpers!private! !
backImage!accessing!public! !
backImage:!accessing!public! !
backImageAlphaPercent!accessing!public! !
backImageAlphaPercent:!accessing!public! !
backImageChanged!accessing!helpers!private! !
backImageIsTiled!accessing!public! !
backImageIsTiled:!accessing!public! !
backImageOffset!accessing!public! !
backImageOffset:!accessing!public! !
basicAdd:atIndex:!adding!private! !
basicAddColumn:atIndex:!adding!columns!private! !
basicClear!private!removing! !
basicEditItemLabel:!operations!private! !
basicItemFromPoint:!accessing!private! !
basicRefreshContents!private!updating! !
basicRemoveAtIndex:!private!removing! !
basicRemoveColumnAtIndex:!columns!public!removing! !
basicResetSelection!private!selection! !
basicUpdateColumn:!columns!private!updating! !
beSorted:!public!sorting! !
buildViewsPopup!helpers!private! !
cancelLabelEdit!operations!private! !
caretIndex!public!selection! !
caretIndex:!public!selection! !
clearSelectionsByIndex:!public!selection! !
columnAtIndex:!columns!public! !
columnClass!constants!private! !
columnClicked:!helpers!private! !
columnCount!accessing!private! !
columnOrder!accessing!public! !
columnOrder:!accessing!public! !
columnsList!columns!public! !
columnsList:!columns!public! !
customDrawContextClass!constants!private! !
customDrawSubItem:!event handling!private! !
customImageExtent!accessing!private! !
defaultListViewExStyle!accessing-styles!constants!private! !
defaultThumbnailExtent!constants!private! !
defaultWindowStyle!constants!private! !
editLabelStyle!constants!private! !
ensureItemsVisible:!helpers!private! !
ensureSelectionVisible!public!selection! !
ensureVisible:!operations!public! !
errorInCommonControlCall:!exceptions!private! !
extraLargeIconMode!commands!public! !
findItem:startingAt:wrap:!private!searching! !
forecolor:!accessing!public! !
forgetLastClickedColumn!helpers!private! !
getEditControl!accessing!private! !
getItemChecked:!accessing!public! !
getItemText:!accessing!private! !
getNoRedrawCount!private! !
getSelectedCount!private!selection! !
getSelectionsByIndex!private!selection! !
getSingleSelection!private!selection! !
getThumbnailOf:!helpers!private! !
hasBorderSelect!accessing-styles!public! !
hasBorderSelect:!accessing-styles!public! !
hasButtons!accessing-styles!public!testing! !
hasCheckBoxes!accessing-styles!public! !
hasCheckBoxes:!accessing-styles!public! !
hasColumnHeaders!accessing!public! !
hasColumnHeaders:!accessing!public! !
hasColumnImages!accessing-styles!public! !
hasColumnImages:!accessing-styles!public! !
hasFlatScrollbars!accessing-styles!public! !
hasFlatScrollbars:!accessing-styles!public! !
hasFullRowSelect!accessing-styles!public! !
hasFullRowSelect:!accessing-styles!public! !
hasGridLines!accessing-styles!public! !
hasGridLines:!accessing-styles!public! !
hasHeaderDragDrop!accessing-styles!public! !
hasHeaderDragDrop:!accessing-styles!public! !
hasHotTracking!accessing-styles!public! !
hasHotTracking:!accessing-styles!public! !
hasInfoTips!accessing-styles!public! !
hasInfoTips:!accessing-styles!public! !
hasLargeImages!private!testing! !
hasPrimaryColumnImages!private!testing! !
hasSortHeaders!accessing-styles!public! !
hasSortHeaders:!accessing-styles!public! !
hasSubItemCustomDraw!private!testing! !
hideDropHighlight!drag & drop!private! !
iconSpacing!accessing!public! !
iconSpacing:!accessing!public! !
imageFromRow:!adapters!private! !
indentFromRow:!adapters!private! !
infoTipFromRow:withPrefix:!adapters!private! !
initialize!initializing!private! !
invalidateHeader!private!updating! !
isArrangeable!arranging!public! !
isAutoArranged!arranging!public! !
isAutoArranged:!accessing-styles!public! !
isDoubleBuffered!accessing-styles!public! !
isDoubleBuffered:!accessing-styles!public! !
isMultiSelect!public!selection!testing! !
isMultiSelect:!public!testing! !
isReportMode!private!updating! !
isVirtual!accessing-styles!public! !
isVirtual:!accessing-styles!public! !
itemCount!accessing!public! !
itemFromPoint:!enquiries!private! !
itemRect:textOnly:!enquiries!public! !
itemsPerPage!geometry!public! !
itemStructure!constants!private! !
largeIconExtent:!constants!public! !
largeIconMode!commands!public! !
lastSelIndices!accessing!private! !
listMode!commands!public! !
listViewStyleMask:set:!accessing-styles!private! !
lvFlags!accessing!private! !
lvmApproximateViewRect:cx:cy:!geometry!private! !
lvmArrange:!operations!private! !
lvmCreateDragImage:position:!operations!private! !
lvmDeleteAllItems!private!removing! !
lvmDeleteColumn:!columns!private!removing! !
lvmEnsureVisible:partial:!operations!private! !
lvmFindItem:startingAt:!operations!private! !
lvmGetBkImage:!accessing!private! !
lvmGetCallbackMask!accessing!private! !
lvmGetColumnOrderArray!accessing!private! !
lvmGetColumnWidth:!accessing!private! !
lvmGetExtendedListViewStyle!accessing!private! !
lvmGetHeader!geometry!private! !
lvmGetImageList:!image management!private! !
lvmGetItem:!accessing!private! !
lvmGetItemCount!accessing!private! !
lvmGetItemPosition:!geometry!private! !
lvmGetItemSpacing!accessing!private! !
lvmGetItemState:mask:!accessing!private! !
lvmGetNextItem:flags:!accessing!private! !
lvmGetOrigin!accessing!private! !
lvmGetStringWidth:!accessing!private! !
lvmGetSubItemRect:subitem:bounding:!geometry!private! !
lvmGetView!accessing-styles!private! !
lvmGetViewRect!geometry!private! !
lvmInsertAt:column:!adding!private! !
lvmInsertItem:!adding!private! !
lvmRedrawItems:to:!operations!private! !
lvmSetBkImage:!accessing!private! !
lvmSetCallbackMask:!accessing!private! !
lvmSetColumn:at:!columns!private! !
lvmSetColumnOrderArray:!accessing!private! !
lvmSetColumnWidth:to:!accessing!private! !
lvmSetExtendedListViewStyle:!accessing!private! !
lvmSetExtendedListViewStyle:dwExStyle:!accessing!private! !
lvmSetIconSpacing:!accessing!private! !
lvmSetImageList:type:!image management!private! !
lvmSetItem:!accessing!private! !
lvmSetItem:position:!geometry!private! !
lvmSetItem:state:!accessing!private! !
lvmSetItemCount:!operations!private! !
lvmSetItemText:index:!accessing!private! !
lvmSetView:!geometry!private! !
lvmUpdate:!operations!private! !
lvnBeginScroll:!event handling-win32!private! !
lvnColumnClick:!event handling-win32!private! !
lvnColumnDropDown:!event handling-win32!private! !
lvnColumnOverflowClick:!event handling-win32!private! !
lvnDeleteAllItems:!event handling-win32!private! !
lvnEndScroll:!event handling-win32!private! !
lvnFindItem:!event handling-win32!private! !
lvnGetEmptyMarkup:!event handling-win32!private! !
lvnGetInfoTip:!event handling-win32!private! !
lvnHotTrack:!event handling-win32!private! !
lvnIncrementalSearch:!event handling-win32!private! !
lvnInsertItem:!event handling-win32!private! !
lvnItemActivate:!event handling-win32!private! !
lvnItemChanged:!private!selection! !
lvnItemChanging:!event handling-win32!private! !
lvnLinkClick:!event handling-win32!private! !
lvnMarqueeBegin:!event handling-win32!private! !
lvnODStateChanged:!event handling-win32!private! !
maybeSelChanging:!event handling!private! !
nmBeginDrag:!event handling-win32!private! !
nmBeginRDrag:!event handling-win32!private! !
nmClick:!event handling-win32!private! !
nmNotify:!event handling-win32!private! !
nmRClick:!event handling-win32!private! !
nmSelChanged:!event handling-win32!private! !
notificationClass!constants!private! !
onButtonPressed:!event handling!private! !
onDisplayDetailsRequired:!event handling!private! !
onDropDown:!event handling!private! !
onEraseRequired:!event handling!public! !
onItem:removedAtIndex:!event handling!public! !
onItems:addedAtIndex:!event handling!public! !
onKeyPressed:!event handling!public! !
onKeyTyped:!event handling!public! !
onLeftButtonDoubleClicked:!event handling!public! !
onLeftButtonPressed:!event handling!public! !
onPositionChanged:!event handling!public! !
onRightButtonPressed:!event handling!public! !
onSelChanged:!event handling!private! !
onSelChanging:cause:!event handling!private! !
onSelRemoved!public!selection! !
onStateRestored!binary filing!private! !
onViewCreated!event handling!public! !
primaryColumn!columns!private! !
queryCommand:!commands!public! !
refreshContents!public!updating! !
refreshNonVirtual!private!updating! !
removeColumn:!columns!public!removing! !
removeColumnAtIndex:!columns!public!removing! !
reportMode!commands!public! !
resetSelection!public!selection! !
resolutionScaledBy:!geometry!private! !
selectAll!public!selection! !
selectedCount!private!selection! !
selectIndex:set:!private!selection! !
selectIndices:set:!private!selection! !
selectionByIndex!public!selection! !
selections:ifAbsent:!public!selection! !
selectionsByIndex!public!selection! !
selectionsByIndex:ifAbsent:!public!selection! !
setColumnIcon:atIndex:!helpers!private! !
setControlBackcolor:!helpers!private! !
setIconSpacing:!helpers!private! !
setItem:checked:!accessing!public! !
setNoRedrawCount:!private! !
setSelectionsByIndex:!private!selection! !
setSingleSelection:!private!selection! !
setViewMode:!accessing!private! !
setWidthOfColumn:to:!columns!public! !
showDropHighlight:!drag & drop!private! !
showsSelAlways!accessing-styles!public! !
showsSelAlways:!accessing-styles!public! !
smallIconMode!commands!public! !
sortOnColumn:!columns!public!sorting! !
state!accessing!private! !
stateImageFromRow:!helpers!private! !
subItemRectRow:column:!geometry!public! !
text:!accessing!public! !
textFromRow:!adapters!private! !
thumbnailExtent!accessing!public! !
thumbnailExtent:!accessing!public! !
thumbnailsImageManager!image management!private! !
thumbnailsMode!commands!public! !
tileIconMode!commands!public! !
updateAllNonVirtual!private!updating! !
updateAllVirtual!private!updating! !
updateColumn:!columns!private!updating! !
updateItem:atIndex:!event handling!public! !
updateSelectionCache!helpers!private!selection! !
viewMode!accessing!public! !
viewModeChanged!helpers!private! !
viewModeSelect!commands!public! !
wantCustomDrawItemNotifications:!helpers!private! !
!

UI.ListView methodProtocol: #multipleIndexSelectableItems attributes: #(#readOnly) selectors: #(#addSelectionsByIndex: #clearSelectionsByIndex: #selectionsByIndex #selectionsByIndex: #selectionsByIndex:ifAbsent:)!
UI.ListView methodProtocol: #multipleSelectableItems attributes: #(#readOnly) selectors: #(#addSelections: #addSelections:ifAbsent: #hasSelection #selectAll #selections #selections: #selections:ifAbsent:)!

!UI.ListView class methodsFor!

columnClass
	"Answer the class of object used to represent the columns of the receiver."

	^ListViewColumn!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialise the receiver's class variables.
		self initialize
	"

	CommCtrlLibrary addInitFlag: ICC_LISTVIEW_CLASSES.
	self addClassConstant: 'LvModes'
		value: (IdentityDictionary withAll: {
						#thumbnails -> LVS_ICON.
						#smallIcons -> LVS_SMALLICON.
						#largeIcons -> LVS_ICON.
						#tileIcons -> LVS_ICON.
						#extraLargeIcons -> LVS_ICON.
						#list -> LVS_LIST.
						#report -> LVS_REPORT
					}).
	UnknownItem := Object new!

onStartup
	SelectionStateMask := NtDll isWine
				ifTrue: 
					["When running under Wine the autoSelectPackages option causes an unpleasant scrolling effect when many packages are selected in a System Browser or Package Browser. The problem does not occur without the LVIS_FOCUSED style, the absence of which does mean the loss of focus indication."
					LVIS_SELECTED]
				ifFalse: [##(LVIS_SELECTED | LVIS_FOCUSED)]!

stbConvert: instVarArray fromVersion: verInteger
	| instVars |
	instVars := instVarArray.
	verInteger <= 13 ifTrue: [instVars := super stbConvert: instVars fromVersion: verInteger].
	verInteger < 17
		ifTrue: 
			[| size lvFlags |
			size := instVars size + 15.
			instVars := (Array new: size)
						replaceFrom: 1
							to: 30
							with: instVars
							startingAt: 1;
						replaceFrom: 46
							to: size
							with: instVars
							startingAt: 31;
						yourself.
			lvFlags := 0.
			(instVars at: 30)
				ifNotNil: 
					[:moreParams |
					| backImageOffset |
					(moreParams lookup: 2)
						ifNotNil: [:isTiled | lvFlags := lvFlags mask: BackImageIsTiledMask set: isTiled].
					backImageOffset := moreParams lookup: 3.
					instVars at: 31 put: (moreParams lookup: 1).
					instVars at: 32 put: (backImageOffset = Point.Zero ifFalse: [backImageOffset]).
					instVars at: 33 put: (moreParams lookup: 4)].
			instVars at: 30 put: lvFlags].
	^instVars!

stbConvertFromVersion10: anArray
	"Private - Perform an STB conversion from a version 10 <ListView> to version 11,
	i.e. merge column and primaryColumns instance variables into one, and add a couple 
	of new spare inst. var slots."

	| array |
	array := super stbConvertFromVersion10: anArray.
	(array at: 24) addFirst: (array at: 23).	"Copy primary column into OrderedCollection of columns"
	self assert: [anArray size = 28].
	"nil the former primary column slot (23), and set lastSelIndices to empty"	
	^(Array new: 30)
		replaceFrom: 1
			to: 28
			with: array
			startingAt: 1;
		at: 23 put: nil;
		at: 26 put: #();
		yourself	!

stbConvertFromVersion11: anArray 
	"Private - Perform an STB conversion from a version 11 <ListView> to version 12,
	i.e. add in the double-buffered list view style."

	| array |
	array := super stbConvertFromVersion11: anArray.
	array at: 28 put: ((array at: 28) bitOr: LVS_EX_DOUBLEBUFFER).
	^array!

stbConvertFromVersion2: anArray
	"Private - Perform an STB conversion from a version 2 (or earlier) <View> to version 3,
	i.e. add iconSpacing inst var in ListView and subclasses"

	| array |
	array := super stbConvertFromVersion2: anArray.
	^array resize: array size + 1!

stbConvertFromVersion5: anArray 
	"Private - Perform an STB conversion from a version 5 (or earlier) <View> to version 6,
	i.e. insert lvStyle inst var in ListView and subclasses."

	^(super stbConvertFromVersion5: anArray) copyWith: 0!

stbVersion
	"Versions:
		1-9: Common across all views and STBViewProxy
		10: Adds customDrawBlock and two spare instance variables to IconicListAbstract (now largeIconExtent and thumbnailsImageManager) (D4; inst size 28)
		11: primaryColumn and columns inst. vars merged into one collection, lastSel becomes lastSelIndices (and is always a collection) and add a couple of spare inst. vars (D5; inst size 30).
		14-16: See EditableListView
		17: Consolidates 4 vars using moreParams into inst vars and adds 12 spares"

	^17!

themePartName
	^#ListView!

uninitialize
	CommCtrlLibrary removeInitFlag: ICC_LISTVIEW_CLASSES!

viewModes
	^LvModes!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysListView32'! !
!UI.ListView class categoriesForMethods!
columnClass!constants!private! !
icon!constants!public! !
initialize!development!initializing!private! !
onStartup!events-session!public! !
stbConvert:fromVersion:!binary filing!public! !
stbConvertFromVersion10:!binary filing!private! !
stbConvertFromVersion11:!binary filing!private! !
stbConvertFromVersion2:!binary filing!private! !
stbConvertFromVersion5:!binary filing!private! !
stbVersion!binary filing!public! !
themePartName!constants!public! !
uninitialize!class hierarchy-removing!private! !
viewModes!accessing!public! !
winClassName!constants!private! !
!

