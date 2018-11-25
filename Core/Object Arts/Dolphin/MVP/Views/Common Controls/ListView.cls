"Filed out from Dolphin Smalltalk 7"!

IconicListAbstract subclass: #ListView
	instanceVariableNames: 'lastClickedColIndex columns viewMode lastSelIndices iconSpacing lvStyle thumbnailExtent moreParams'
	classVariableNames: 'LvModes RevertSelMessage UnknownItem'
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
ListView guid: (GUID fromString: '{87b4c730-026e-11d3-9fd7-00a0cc3e4a32}')!
ListView comment: 'ListView is the <listView> implementing the Windows "SysListView32" common control. It is for single selection use and, therefore, implements the <selectableItems> protocol for use with any <listModel>.

A ListView is capable of displaying it items in one of four modes (#smallIcons, #largeIcons, #list, #report) which can be set using the #viewMode aspect. In the first three of these modes the list effectively has only one column being displayed; this is the primary column. Columns are described using instances of ListViewColumn. See the comment for this class for details on how to set up a column to display the appropriate information for a list item.

The underlying Windows common control is a sophisticated one with many options. We have not attempted to wrap all of the features of this control within the ListView class. However, you should find that much of the most useful functionality is present.

Instance Variables:
	primaryColumn	<ListViewColumn> which is the main column in the list.
	columns			<OrderedCollection> of <ListViewColumn>s which are displayed in #report mode (excluding the primary column).
	viewMode		<Symbol> describing the mode in which the list is displaying items.
	lastSel			<integer> index of the last selection made.
	iconSpacing		<Point> or nil, representing the explicit spacing between icons in #smallIcons and #largeIcons view modes.
	lvStyle			<integer> representing the Windows extended list view style.
	_lvReserved1	Reserved for future system use. Do not use.
	_lvReserved2	Reserved for future system use. Do not use.

Class Variables:
	LvnMap			<Array> which is a map between integer Windows notification messages and <selector>s.
	RevertSelMessage	<integer> holding the private ''RevertSelection'' message.
	ViewModes			<IdentityDictionary> mapping symbolic view mode names to the corresponding list view style constants.
'!
!ListView categoriesForClass!MVP-Views! !
!ListView methodsFor!

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
	title := 'Column ', (self columnCount+1) displayString.
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
	lvItem := LVITEMW new.
	msg := aBoolean
				ifTrue: [ListViewConstants.LVM_SETITEMW]
				ifFalse: [ListViewConstants.LVM_INSERTITEMW].
	aSequenceableCollection keysAndValuesDo: 
			[:i :each |
			lvItem
				row: i + anInteger
				text: (primaryTextSupplier textFromRow: each)
				imageIndex: (primaryImageSupplier imageFromRow: each)
				indent: (self indentFromRow: each).
			self
				sendMessage: msg
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
						indent: nil.
					self lvmSetItem: lvItem]]!

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

	| largeImList smallImList |
	largeImList := self customImageExtent
				ifNotNil: [:ext | self thumbnailsImageManager imageListWithExtent: ext]
				ifNil: 
					[thumbnailsImageManager := nil.
					self imageManager ifNotNil: [:im | im imageListWithExtent: self largeIconExtent]].
	smallImList := self imageManager ifNotNil: [:im | im imageListWithExtent: Icon smallExtent].
	self lvmSetImageList: smallImList type: LVSIL_SMALL.
	self lvmSetImageList: largeImList type: LVSIL_NORMAL!

autoResizeColumns
	"Private - Attempt to share the available width in the receiver between all automagically resizeable
	columns. This only has a visible effect in #report mode."

	self autoResizeColumns: self clientWidth!

autoResizeColumns: anInteger 
	"Private - Attempt to share the specified <integer> width between all automagically
	resizeable columns in the receiver. This only has a visible effect in #report mode."

	| fixedWidth idealWidth remainingWidth clientWidth actualAccum idealAccum autoCols |
	fixedWidth := 0.
	autoCols := OrderedCollection new.
	self allColumns keysAndValuesDo: 
			[:eachIndex :eachCol | 
			eachCol isAutoResize 
				ifTrue: [autoCols addLast: eachIndex - 1 -> eachCol]
				ifFalse: [fixedWidth := fixedWidth + eachCol width]].
	autoCols isEmpty ifTrue: [^self].
	clientWidth := anInteger-4.
	"#1063: ListView doesn't seem to report its actual client width correctly if it has a static edge
	but not one of the other border styles, hence we must 'adjust' it a little in this case."
	(self hasStaticEdge and: [(self hasClientEdge or: [self hasBorder]) not]) 
		ifTrue: [clientWidth := clientWidth - 2].
	remainingWidth := clientWidth - fixedWidth.
	remainingWidth <= 0 ifTrue: [^self].
	"Split the available width between the auto columns - note the use of fractional arithmetic to avoid accumulating a rounding error"
	idealWidth := remainingWidth / autoCols size.
	idealAccum := 0.
	actualAccum := 0.
	autoCols do: 
			[:each | 
			| thisWidth |
			idealAccum := idealAccum + idealWidth.
			thisWidth := (idealAccum - actualAccum) rounded.
			each value basicWidth: thisWidth.
			self lvmSetColumnWidth: each key to: thisWidth.
			actualAccum := actualAccum + thisWidth]!

backcolorChanged
	super backcolorChanged.
	self backImage notNil ifTrue: [self backImageChanged]!

backImage
	^self moreParamsAt: 1!

backImage: aBitmapOrNil 
	self moreParamsAt: 1 put: aBitmapOrNil.
	self backImageChanged!

backImageAlphaPercent
	| percent |
	percent := self moreParamsAt: 4.
	percent ifNil: [self backImageAlphaPercent: (percent := 100)].
	^percent!

backImageAlphaPercent: anInteger 
	self backImage 
		ifNotNil: 
			[self moreParamsAt: 4 put: anInteger.
			self backImageChanged]!

backImageChanged
	"Private - The background image has been changed; apply it into the receiver. We take a copy here
	since Windows takes ownership of the bitmap handle that we give it"

	| backImage bk isTiled offset |
	backImage := self backImage.
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
	| isTiled |
	isTiled := self moreParamsAt: 2.
	isTiled ifNil: [self backImageIsTiled: (isTiled := false)].
	^isTiled!

backImageIsTiled: aBoolean 
	self backImage 
		ifNotNil: 
			[self moreParamsAt: 2 put: aBoolean.
			self backImageChanged]!

backImageOffset
	| offset |
	offset := self moreParamsAt: 3.
	offset ifNil: [self backImageOffset: (offset := Point zero)].
	^offset!

backImageOffset: aPoint 
	self moreParamsAt: 3 put: aPoint.
	self backImageChanged!

basicAdd: anObject atIndex: anInteger
	"Private - Adds an item to the list view at the index given by anInteger"

	self isVirtual
		ifTrue: 
			[| lvItem |
			lvItem := LVITEMW allCallbacks.
			lvItem iItem: anInteger - 1.
			self lvmInsertItem: lvItem]
		ifFalse: 
			[self
				addOrUpdate: false
				nonVirtualItems: {anObject}
				afterIndex: anInteger - 1]!

basicAddColumn: aListViewColumn atIndex: anInteger
	"Private - Insert aListViewColumn in the associated control at the index 
	columnIndex. N.B. Does not modify the receiver's column collection.
	Answers aListViewColumn."

	| lvColumn |
	lvColumn := LVCOLUMNW fromColumn: aListViewColumn in: self.
	self lvmInsertAt: anInteger - 1 column: lvColumn.
	aListViewColumn parent: self.
	^aListViewColumn!

basicClear
	"Private - Clears down the listview control(but not its model)."

	self lvmDeleteAllItems!

basicEditItemLabel: itemIndex
	"Private - Begin inline editing of the item with one-based <integer> index, itemIndex."

	^self sendMessage: LVM_EDITLABEL wParam: itemIndex-1!

basicItemFromPoint: aPoint 
	"Private - Answer a LVHITTESTINFO populated by the control with hit-test information for the
	item (and sub-item) under the client coordinate represented by the <Point> argument."

	| struct |
	struct := LVHITTESTINFO new.
	struct pt: aPoint asParameter.
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
					self viewMode == #report ifTrue: [self autoResizeColumns]]]
		ifFalse: [self refreshNonVirtual]!

basicRemoveAtIndex: anInteger
	"Private - Delete item at anInteger index in the list view.
	Answer whether the request succeeded."

	^self lvmDeleteItem: anInteger-1.!

basicRemoveColumnAtIndex: anInteger
	self lvmDeleteColumn: anInteger - 1!

basicResetSelection
	"Private - Clear all selections. Do not issue a selection changed
	notification."

	| anLvItem |
	anLvItem := LVITEMW new.
	anLvItem stateMask: ##(LVIS_SELECTED | LVNI_FOCUSED).
	self lvmSetItem: -1 state: anLvItem!

basicUpdateColumnAtIndex: anInteger
	| column |
	column := self columnAtIndex: anInteger.
	anInteger == 1 ifTrue: [column text setTextInto: self].
	self lvmSetColumn: (LVCOLUMNW fromColumn: column in: self) at: anInteger - 1!

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
	^popup
!

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
	lvItem := LVITEMW new.
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

	| iArray iCount oldPositions |
	oldPositions := self columnOrder.
	oldPositions = positions ifTrue: [^self	"Order not changed"].
	iCount := positions size.
	iArray := DWORDArray new: iCount.
	1 to: positions size do: [:i | iArray at: i put: (positions at: i)-1].
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
	oldSize + 1 to: newSize
		do: [:each | self basicAddColumn: (columns at: each) atIndex: each].
	1 to: (oldSize min: newSize)
		do: 
			[:each | 
			(columns at: each) parent: self.
			self basicUpdateColumnAtIndex: each].
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
	"If not the first column, and the previous column has a custom draw block, then we need to reset the custom draw settings as otherwise we'll end up picking up whatever customizations might have been applied to the previous column."
	(idx ~~ 0 and: [(columns at: idx) customDrawBlock notNil]) ifTrue: [context reset].
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

dispatchRegistered: registeredId wParam: wParam lParam: lParam
	"Private - Dispatch the registered message which was sent to the receiver."

	^registeredId == RevertSelMessage
		ifTrue: [self revertSelection. 0]
		ifFalse: [super dispatchRegistered: registeredId wParam: wParam lParam: lParam]!

editLabelStyle
	"Private - Answer the <integer> style mask used to control whether label editing is enabled
	in the receiver's control."

	^LVS_EDITLABELS!

ensureSelectionVisible
	"Ensure the selected item is visible, scrolling it into view if necessary."

	| caret selected |
	caret := self caretIndex.
	selected := self selectionsByIndex.
	self ensureVisible: ((selected isEmpty or: [selected includes: caret])
				ifTrue: [caret]
				ifFalse: [selected first])!

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
	Answer the index of the item, or 0 if it none matched."

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
	clrref := (aColorOrNil isNil 
			ifTrue: [Color windowText]
			ifFalse: [aColorOrNil]) asColorRef asParameter.
	self sendMessage: LVM_SETTEXTCOLOR wParam: 0 lParam: clrref.

!

forgetLastClickedColumn
	lastClickedColIndex isNil ifTrue: [^self].
	self setColumnIcon: nil atIndex: lastClickedColIndex.
	lastClickedColIndex := nil!

getItemText: anInteger
	| item |
	item := LVITEMW new
				iItem: anInteger - 1;
				newTextBuffer: 128;
				yourself.
	self lvmGetItem: item.
	^item pszText!

getMultipleSelections
	"Private - Answer an <Array> of the <integer> the indices of the selected items in the
	receiver in ascending order. The array will be empty if there is no selection."

	^self withOldWndProc: 
			[| count index answer |
			count := self selectedCount.
			answer := Array new: count.
			index := -1.
			1 to: count
				do: [:i | answer at: i put: (index := self lvmGetNextItem: index flags: LVNI_SELECTED) + 1].
			answer]!

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

	^self listViewStyleAllMask: LVS_EX_BORDERSELECT!

hasBorderSelect: aBoolean 
	"Set whether the receiver displays selected by changing the border colour of an item rather
	than the background colour. This is not available in pre-IE5 versions of the CommCtrl
	Library."

	^self listViewStyleMask: LVS_EX_BORDERSELECT set: aBoolean!

hasCheckBoxes
	"Answer whether the receiver has check-boxes associated with its items."

	^self listViewStyleAllMask: LVS_EX_CHECKBOXES!

hasCheckBoxes: aBoolean
	"Sets the receiver to either have or not have check-boxes associated with its items."

	^self listViewStyleMask: LVS_EX_CHECKBOXES set: aBoolean!

hasColumnHeaders
	"Answers true if the receiver has column headers enabled"

	^(self baseStyleAllMask: LVS_NOCOLUMNHEADER) not
!

hasColumnHeaders: aBoolean
	"Set the receiver's base style such that is has column headers
	according to aBoolean." 

	self 
		baseStyleMask: LVS_NOCOLUMNHEADER
		set: aBoolean not
		recreateIfChanged: false!

hasColumnImages
	"Answer whether the receiver displays images for additional columns.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^self listViewStyleAllMask: LVS_EX_SUBITEMIMAGES!

hasColumnImages: aBoolean 
	"Sets the receiver to have images for individual columns depending on the value of aBoolean."

	self listViewStyleMask: LVS_EX_SUBITEMIMAGES set: aBoolean!

hasFlatScrollbars
	"Answer whether the receiver has the new flat scrollbars style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^self listViewStyleAllMask: LVS_EX_FLATSB!

hasFlatScrollbars: aBoolean
	"Set whether the receiver has the new flat scrollbars style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^self listViewStyleMask: LVS_EX_FLATSB set: aBoolean!

hasFullRowSelect
	"Answer whether the receiver has the full row select style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^self listViewStyleAllMask: LVS_EX_FULLROWSELECT!

hasFullRowSelect: aBoolean
	"Sets the receiver to have full row select or not depending on the 
	value of aBoolean."

	^self listViewStyleMask: LVS_EX_FULLROWSELECT set: aBoolean!

hasGridLines
	"Answer whether the receiver has the gridlines style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^self listViewStyleAllMask: LVS_EX_GRIDLINES!

hasGridLines: aBoolean
	"Sets the receiver to have grid lines or not depending on the 
	value of aBoolean."

	^self listViewStyleMask: LVS_EX_GRIDLINES set: aBoolean!

hasHeaderDragDrop
	"Answer whether the receiver has the header drag drop style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^self listViewStyleAllMask: LVS_EX_HEADERDRAGDROP!

hasHeaderDragDrop: aBoolean
	"Sets the receiver to have header drag drop or not depending on the 
	value of aBoolean."

	^self listViewStyleMask: LVS_EX_HEADERDRAGDROP set: aBoolean!

hasHotTracking
	"Answer whether the receiver has the track select style.
	This is not available in pre-IE4 versions of the CommCtrl Library."

	^self listViewStyleAllMask: LVS_EX_TRACKSELECT!

hasHotTracking: aBoolean 
	"Sets the receiver to have track select or not depending on the 
	value of aBoolean."

	self listViewStyleMask: LVS_EX_TRACKSELECT set: aBoolean!

hasInfoTips
	"Answer whether the receiver has the Info. Tip style.
	Note that this style controls whether or not the control displays any
	info tips at all, including the default tips which display the full text
	of clipped items."

	^self listViewStyleAllMask: LVS_EX_INFOTIP!

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
			anLvItem := LVITEMW new.
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
	self fontChanged!

imageFromRow: item
	"Private - Answer the image for row which represents the <Object>, item.
	As of Dolphin 3.0 the image block is permitted to be nil for the common case
	where the list does not have images."

	self hasLargeImages ifTrue: [^self getThumbnailOf: item].
	NTLibrary isWine
		ifTrue: 
			["Wine ListViews seem to expect image indices to always be set in
			ListView>>onDisplayDetailsRequired:, even if we don't want images to appear.
			Normally, we answer nil here if no image is required. In Wine we must answer
			an image index of 0"
			getImageBlock ifNil: [^0]].
	^self getImageBlock isNil ifFalse: [getImageBlock value: item]!

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
	(hWnd := self lvmGetHeader) notNull ifTrue: [
		UserLibrary default invalidate: hWnd lpRect: nil bErase: true]!

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

	^self listViewStyleAllMask: LVS_EX_DOUBLEBUFFER!

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
	^self viewMode == #report!

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
		recreateIfChanged: true!

itemCount
	"Answer the total number of items in the view."

	^self sendMessage: LVM_GETITEMCOUNT!

itemFromNMHDRW: pNMHDR
	^LVITEMW fromAddress: pNMHDR yourAddress + ##(NMHDR byteSize)!

itemFromPoint:  coord
	"Private - Answer the one-based index of the item in the control under the <Point>, coord,
	or nil if none."

	| ht |
	ht := self basicItemFromPoint: coord.
	^ht isItemHit ifTrue: [ht iItem+1]!

itemRect: itemHandle textOnly: aBoolean
	"Answers the rectangle surrounding the item with anIntegerIndex within
	the receiver, optionally for the text label only."

	^self lvmGetItemRect: itemHandle-1 
		bounding: (aBoolean ifTrue: [LVIR_LABEL] ifFalse: [LVIR_BOUNDS])!

itemsPerPage
	^self sendMessage: LVM_GETCOUNTPERPAGE!

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

lastSelIndices: anArray 
	lastSelIndices := anArray!

listMode
	"Place the receiver in list mode"

	self viewMode: #list!

listViewStyleAllMask: anInteger
	"Private - Answers true if the list views extended style bits contains all the bits in anInteger"

	^lvStyle allMask: anInteger.
!

listViewStyleMask: mask set: aBoolean
	"Private - Sets/clears the list view extended style bits in the <integer>, mask, 
	according to aBoolean. Answer the previous extended style flags."

	^self lvmSetExtendedListViewStyle: mask dwExStyle: aBoolean asParameter negated!

lvmApproximateViewRect: countInteger cx: cxInteger cy: cyInteger 
	| dword |
	dword := self 
				sendMessage: LVM_APPROXIMATEVIEWRECT
				wParam: countInteger
				lParam: ((cxInteger bitShift: 16) bitOr: (cyInteger bitAnd: 16rFFFF)).
	^(dword bitAnd: 16rFFFF) @ (dword bitShift: -16)!

lvmArrange: arrangeStyle
	"Private - Arrange items when in icon style."

	(self sendMessage: LVM_ARRANGE wParam: arrangeStyle) == 0
		ifTrue: [^self errorInCommonControlCall]!

lvmCreateDragImage: index position: position
	"Private - Answer a Handle for the drag image list and the argument, position,
	contains the upper-left position of the item (in view coordinates)."

	| dragList |
	^(dragList := self sendMessage: LVM_CREATEDRAGIMAGE wParam: index lpParam: position asParameter) == 0
		ifTrue: [self errorInCommonControlCall: index]
		ifFalse: [dragList asExternalHandle]
	!

lvmDeleteAllItems
	"Private - Remove all items from the ListView control.
	Answer whether the call succeeded."

	^(self sendMessage: LVM_DELETEALLITEMS) ~= 0!

lvmDeleteColumn: index
	"Private - Removes the column at index."

	(self sendMessage: LVM_DELETECOLUMN wParam: index) == 0
		ifTrue: [^self errorInCommonControlCall: index]!

lvmDeleteItem: index
	"Private - Removes the item at index. Answer whether the request
	succeeded."

	^(self sendMessage: LVM_DELETEITEM wParam: index) ~~ 0!

lvmEnsureVisible: index partial: partialBoolean
	"Private - Ensure the item at index is visible."

	self sendMessage: LVM_ENSUREVISIBLE wParam: index lParam: partialBoolean asParameter!

lvmFindItem: aLvFindInfo startingAt: start
	"Private - Answer the index of the found item, or -1 there are none."

	^self sendMessage: LVM_FINDITEM wParam: start lpParam: aLvFindInfo!

lvmGetBkImage: aLVBKIMAGEW
	"Private - Populate the <LVBIMAGEW> argument with details of the receiver's background
	image. Answer whether the request succeeded."

	^(self
		sendMessage: LVM_GETBKIMAGEW
		wParam: 0
		lpParam: aLVBKIMAGEW) asBoolean!

lvmGetCallbackMask
	"Private - Answers the callback mask of the underlying control"

	^self sendMessage: LVM_GETCALLBACKMASK!

lvmGetColumnOrderArray
	"Private - Answer an <SDWORDArray> containing the current left-to-right order 
	of columns in the receiver specified as a zero-based positions. "

	| iCount iArray |
	iCount := self columnCount.
	iArray := DWORDArray new: iCount.
	(self 
		sendMessage: LVM_GETCOLUMNORDERARRAY
		wParam: iCount
		lpParam: iArray) == 0 
		ifTrue: [^self errorInCommonControlCall].
	^iArray!

lvmGetColumnWidth: columnIndex
	"Private - Answers the width of the column at the zero based columnIndex"

	^self sendMessage: LVM_GETCOLUMNWIDTH wParam: columnIndex.
!

lvmGetExtendedListViewStyle
	"Private - Answer the views extended style flags."

	^self sendMessage: LVM_GETEXTENDEDLISTVIEWSTYLE wParam: 0 lpParam: 0!

lvmGetHeader
	"Private - Answer the handle of the header control."

	^self sendMessage: LVM_GETHEADER!

lvmGetItem: aLvItem
	"Private - Retrieve the requested items attributes into the argument, aLvItem."

	(self
		sendMessage: ListViewConstants.LVM_GETITEMW
		wParam: 0
		lpParam: aLvItem) == 0
		ifTrue: [^self errorInCommonControlCall]!

lvmGetItemPosition: index
	"Private - Answer the Point of the index item on the view."

	| pt |
	pt := POINTL new.
	(self sendMessage: LVM_GETITEMPOSITION wParam: index lpParam: pt) == 0
		ifTrue: [^self errorInCommonControlCall: index].
	^pt asPoint!

lvmGetItemRect: index bounding: boundingValue
	"Private - Answer a bounding Rectangle for all or part of an item."

	| rect |
	rect := RECT new.
	rect left: boundingValue.
	(self sendMessage: LVM_GETITEMRECT wParam: index lpParam: rect) == 0
		ifTrue: [^self errorInCommonControlCall: index].
	^rect asRectangle!

lvmGetItemSpacing
	| dword |
	dword := self sendMessage: LVM_GETITEMSPACING.
	^dword lowWord @ dword highWord!

lvmGetItemState: index mask: mask
	"Private - Answer the item's state flags."

	^self sendMessage: LVM_GETITEMSTATE wParam: index lParam: mask!

lvmGetNextItem: startIndex flags: niFlags
	"Private - Answer the next item found matching flags."

	^self sendMessage: LVM_GETNEXTITEM wParam: startIndex lParam: niFlags!

lvmGetOrigin
	"Private - Answer the current view origin. This will fail if the receiver is in list or report mode."

	| pt |
	pt := POINTL new.
	(self sendMessage: LVM_GETORIGIN wParam: 0 lpParam: pt) == 0
		ifTrue: [^self errorInCommonControlCall].
	^pt asPoint!

lvmGetStringWidth: aString
	"Private - Answer the width of aString when displayed in this view."

	| width |
	width := self sendMessage: LVM_GETSTRINGWIDTH wParam: 0 lpParam: aString.
	^width == 0
		ifTrue: [self errorInCommonControlCall]
		ifFalse: [width]!

lvmGetSubItemRect: rowInteger subitem: colInteger bounding: flagInteger
	"Private - Answer a bounding Rectangle for all or part of a subitem."

	| rect |
	rect := RECT new.
	rect
		top: colInteger;
		left: flagInteger.
	(self
		sendMessage: LVM_GETSUBITEMRECT
		wParam: rowInteger
		lpParam: rect) == 0
		ifTrue: [^self errorInCommonControlCall: rowInteger].
	^rect asRectangle!

lvmGetView
	"Private - Retrieve the current view mode."

	^self sendMessage: LVM_GETVIEW!

lvmGetViewRect
	"Private - Answer the bounding rectangle that contains all items in the control. This will
	fail if not in one of the icon modes."

	| rect |
	rect := RECT new.
	(self 
		sendMessage: LVM_GETVIEWRECT
		wParam: 0
		lpParam: rect) == 0 
		ifTrue: [^self errorInCommonControlCall].
	^rect asRectangle!

lvmInsertAt: column column: anLvColumn
	"Private - Answer the index of the new column."

	| index |
	index := self
				sendMessage: LVM_INSERTCOLUMNW
				wParam: column
				lpParam: anLvColumn asParameter.
	^index == -1 ifTrue: [self errorInCommonControlCall] ifFalse: [index]!

lvmInsertItem: aLvItem
	"Private - Insert aLvItem into the tree view and add it to our contents dictionary"

	^self
		sendMessage: ListViewConstants.LVM_INSERTITEMW
		wParam: 0
		lpParam: aLvItem asParameter!

lvmRedrawItems: firstIndex to: lastIndex
	"Private - Insert aLvItem into the tree view and add it to our contents dictionary"

	^self sendMessage: LVM_REDRAWITEMS wParam: firstIndex lpParam: lastIndex!

lvmSetBkImage: aLVBKIMAGEW
	"Private - Set the background image according to the information held in the <LVBKIMAGEW> argument."

	^(self
		sendMessage: LVM_SETBKIMAGEW
		wParam: 0
		lpParam: aLVBKIMAGEW) asBoolean!

lvmSetCallbackMask: anInteger 
	"Private - Answers the callback mask of the underlying control."

	^self sendMessage: LVM_SETCALLBACKMASK wParam: anInteger!

lvmSetColumn: anLvColumn at: columnIndex
	"Private - Set the attributes of a column."

	(self
		sendMessage: LVM_SETCOLUMNW
		wParam: columnIndex
		lpParam: anLvColumn asParameter) == 0
		ifTrue: [^self errorInCommonControlCall]!

lvmSetColumnOrderArray: iArray
	"Private - Sets the left-to-right order of columns in the receiver to the zero-based positions
	specified in the <SDWORDArray> argument, iArray."

	self sendMessage: LVM_SETCOLUMNORDERARRAY wParam: iArray size lpParam: iArray!

lvmSetColumnWidth: itemIndex to: anInteger
	"Private - Set the width of the column identified by itemIndex to anInteger."
	"wParam = (WPARAM) (int) iCol; 
	lParam = MAKELPARAM((int) cx, 0); "

	self sendMessage: LVM_SETCOLUMNWIDTH wParam: itemIndex lpParam: anInteger!

lvmSetExtendedListViewStyle: style
	"Private - Set the extended styles of the receiver.
	Implementation Note: Present for backward compatibility with pre-3.0 resources."

	lvStyle := style.
	self sendMessage: LVM_SETEXTENDEDLISTVIEWSTYLE wParam: 0 lpParam: style asParameter!

lvmSetExtendedListViewStyle: dwExMask dwExStyle: dwExStyle
	"Private - Set or reset the masked extended styles of the receiver.
	Answer the previous style flags."

	| prevStyle |
	prevStyle := self sendMessage: LVM_SETEXTENDEDLISTVIEWSTYLE wParam: dwExMask lpParam: dwExStyle.
	lvStyle := (prevStyle maskClear: dwExMask) maskSet: (dwExStyle bitAnd: dwExMask).
	^prevStyle!

lvmSetIconSpacing: aPoint 
	"Private - Set the spacing between icons displayed in the receiver.
	Answer's the previous icon spacing packed into a 32-bit integer."

	^self 
		sendMessage: LVM_SETICONSPACING
		wParam: 0
		lpParam: aPoint asUIntPtr!

lvmSetImageList: aWinImageList type: anIntegerImageType
	"Private - Set the receivers normal/state image list depending on anIntegerImageType.
	 Answer the receiver's previous WinImagelist."

	^WinImageList
		fromHandle: (UserLibrary default
				sendMessageU: handle
				msg: LVM_SETIMAGELIST
				wParam: anIntegerImageType
				lParam: aWinImageList asParameter) asParameter!

lvmSetItem: anLvItem
	"Private - Set some or all of the receivers default attributes as 
	specified in the argument, anLvItem."

	(self
		sendMessage: ListViewConstants.LVM_SETITEMW
		wParam: 0
		lpParam: anLvItem asParameter) == 0
		ifTrue: [^self errorInCommonControlCall]!

lvmSetItem: index position: aPos
	"Private - Move an item to the specified position in the receiver when
	in large or small icon mode"

	self 
		sendMessage: LVM_SETITEMPOSITION
		wParam: index
		lpParam: aPos asParameter!

lvmSetItem: index state: anLvItem
	"Private - Set an items state to that in anLvItem."

	(self 
		sendMessage: LVM_SETITEMSTATE
		wParam: index
		lpParam: anLvItem asParameter) == 0 
		ifTrue: 
			["Control didn't like it, try and deduce why..."

			^self errorInCommonControlCall: index]!

lvmSetItemCount: size
	"Private - Prepare a list view for adding a large number of items."

	self sendMessage: LVM_SETITEMCOUNT wParam: size!

lvmSetItemText: anLvItem index: index
	"Private - Change the text of an item or subitem."

	(self
		sendMessage: ListViewConstants.LVM_SETITEMTEXTW
		wParam: index
		lpParam: anLvItem asParameter) == 0
		ifTrue: [^self errorInCommonControlCall: index]!

lvmSetView: anInteger
	self sendMessage: LVM_SETVIEW wParam: anInteger!

lvmUpdate: index
	"Private - Update an item at the specified zero-based <integer> index in the receiver.
	If in auto arrange mode then arrange."

	(self sendMessage: LVM_UPDATE wParam: index) == 0
		ifTrue: [^self errorInCommonControlCall: index]!

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
	Answer true to suppress individual LVN_DELETEITEM notifications."

	^true

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

	| target prefixText nmlv |
	nmlv := NMLVGETINFOTIPW fromAddress: pNMHDR.
	target := self objectFromHandle: nmlv itemHandle ifAbsent: [^0].	"ListView may occassionally ask for info tip for item we don't have (e.g. off end of list)"
	prefixText := nmlv dwFlags == 0 ifTrue: [nmlv text] ifFalse: [''].	"If in report mode and the column has an info. tip block then we delegate to it, otherwise fill it in."
	nmlv
		text: ((self isReportMode
				ifTrue: 
					[| column |
					column := self columnAtIndex: nmlv iSubItem + 1.
					column getInfoTipBlock notNil ifTrue: [column] ifFalse: [self]]
				ifFalse: [self]) infoTipFromRow: target withPrefix: prefixText).
	^0	"Return value is ignored"!

lvnIncrementalSearch: pNMHDR
	^nil!

lvnInsertItem: pNMHDR
	"Private - Default handler for the LVN_INSERTITEM notification message.
	Answer nil to accept default processing."

	^nil


	!

lvnItemActivate: anExternalAddress
	^nil!

lvnItemChanged: anNMHDR
	"Private - Item has changed.
	We no longer use this notification to look for selection changes, as it
	is absurdly difficult to tell what is going on from a disconnected series
	of events with no indication as to the overall effect."

	^nil!

lvnItemChanging: pNMHDR
	"Private - Default handler for the LVN_ITEMCHANGING notification message.
	Answer false to allow the change, or true to prevent it"

	^false.
!

lvnLinkClick: pNMHDR
	^nil!

lvnMarqueeBegin: anExternalAddress 
	^nil!

lvnODStateChanged: pNMHDR
	"Private - Default handler for the LVN_ODSTATECHANGED notification message."

	"	| nmlv |
	nmlv := NMLVODSTATECHANGE fromAddress: anNMHDR yourAddress."

	^nil!

maybeSelChanging: aSymbol 
	"Private - The selection may be changing as a result of a user action (e.g. due to a keypress). 
	The argument is either #mouse, or #keyboard, indicating the source of the user input that
	is initiating the selection change. Give the presenter/view a chance to change their mind."

	"See if the change is acceptable, and if not revert to original selection if there was one"

	| curSel |
	curSel := self selectionsByIndex.
	curSel = lastSelIndices ifTrue: [^self].
	(self onSelChanging: curSel cause: aSymbol) 
		ifFalse: 
			[self 
				postMessage: RevertSelMessage
				wParam: 0
				lParam: 0.
			^self].
	self onSelChanged!

moreParams
	"Private - A cheating way of adding additional instance parameters to the receiver without
	having to worry about STB upgrading"

	moreParams ifNil: [moreParams := Array new: 1].
	^moreParams!

moreParamsAt: n 
	"Private - A cheating way of adding additional instance parameters to the receiver without
	having to worry about STB upgrading"

	self moreParams at: n ifPresent: [:x | ^x].
	moreParams resize: n.
	^nil!

moreParamsAt: n put: anObject 
	"Private - A cheating way of adding additional instance parameters to the receiver without
	having to worry about STB upgrading"

	self moreParams at: n.
	^self moreParams at: n put: anObject!

newSelectionsFromEvent: event
	"Private - Answer a collection of the <integer> selections that would occur if the <MouseEvent>,
	event, was was passed to the control."

	| itemClicked anyKeysDown newSelections anchorIndex shiftRange anchorIsSelected |
	itemClicked := self itemFromPoint: event position.
	"In single-select mode, the new selection is always the item clicked, or nothing if the click is outside all items."
	self isMultiSelect ifFalse: [^itemClicked ifNil: [#()] ifNotNil: [:item | {item}]].
	newSelections := self selectionsByIndex.
	anyKeysDown := event isShiftDown or: [event isCtrlDown].
	"If the click is outside all items, and ctrl or shift is down, nothing changes."
	(itemClicked isNil and: [anyKeysDown]) ifTrue: [^newSelections].
	"A right or middle click on an already-selected item also does not change the selection,
	otherwise it would be very frustrating to open the context menu with multiple items selected.
	The control also chooses to leave the selection alone if modifiers are held during a right/middle click."
	(event button ~= #left and: [anyKeysDown or: [newSelections includes: itemClicked]])
		ifTrue: [^newSelections].
	"Having taken care of the above edge cases, if no keys are down, the behavior is equivalent to the single-select case."
	anyKeysDown ifFalse: [^itemClicked ifNil: [#()] ifNotNil: [:item | {item}]].
	"Only Ctrl is down, so we flip the selection state of the clicked item."
	event isShiftDown
		ifFalse: 
			[newSelections := newSelections asSortedCollection.
			newSelections remove: itemClicked ifAbsent: [newSelections add: itemClicked].
			^newSelections asArray].
	"At least Shift is down, so we must start examining the 'anchor'. This is the last item
	that was clicked with no modifiers, only ctrl, or ctrl + shift (shift-clicks do *not* move the
	anchor). It acts as the 'start point' for operations where shift is held--they affect
	the range of items from the anchor to the click point, inclusive. Initially it is zero,
	i.e. out-of-bounds, in which case holding shift essentially has no effect, and we act only on
	the item actually clicked."
	anchorIndex := self anchorIndex.
	shiftRange := anchorIndex == 0
				ifTrue: [itemClicked to: itemClicked]
				ifFalse: [(anchorIndex min: itemClicked) to: (anchorIndex max: itemClicked)].
	"Only shift is down, not ctrl, so the current selection will be entirely replaced by the marked range."
	event isCtrlDown ifFalse: [^shiftRange asArray].
	"Both ctrl and shift are down, so we set the selection state of the affected range to that of the
	anchor itself. Note that this ignores the selection state of the item actually clicked
	and everything in between it and the anchor."
	newSelections := newSelections asSet.
	anchorIsSelected := newSelections includes: anchorIndex.
	shiftRange do: (anchorIsSelected
				ifTrue: [[:i | newSelections add: i]]
				ifFalse: [[:i | newSelections remove: i ifAbsent: []]]).
	"For some reason, the item clicked is always left selected, even if we are deselecting the rest
	of the marked range. This is not true in e.g. Windows Explorer--why is it in Dolphin?"
	newSelections add: itemClicked.
	^newSelections asSortedCollection asArray!

nmClick: pNMHDR 
	"Private - Handler for a NM_CLICK notification message.
	We intercept this to catch potential selection changes resulting from a drag-select
	operation."

	self isMultiSelect ifTrue: [self maybeSelChanging: #mouse].
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
		at: LVN_FIRST - LVN_HOTTRACK + 1 put: #nmDummy:;
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
		yourself) lookup: ##(LVN_FIRST + 1) - (pNMHDR sdwordAtOffset: 8))
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

nmRClick: pNMHDR 
	"Private - Handler for a NM_RCLICK notification message.
	We intercept this to catch potential selection changes resulting from a drag-select
	operation."

	self isMultiSelect ifTrue: [self maybeSelChanging: #mouse].
	^super nmRClick: pNMHDR!

notificationClass
	"Private - Answer the class of NM_XXXXVIEW structure associated with the receiver."

	^NMLISTVIEW!

onButtonPressed: aMouseEvent
	"Private - Common handler for a button down mouse event. Look for potential
	selection change events, and fire a #selectionChanging: event if necessary.
	The mouse event is only allowed to propagate to the control if we are happy that 
	the selection should indeed be changed."

| indices |
	indices := self newSelectionsFromEvent: aMouseEvent.
	^indices = lastSelIndices
		ifTrue: [aMouseEvent defaultWindowProcessing]
		ifFalse: 
			[(self onSelChanging: indices cause: #mouse)
				ifTrue: 
					[| answer |
					"Selection change permitted?"
					answer := aMouseEvent defaultWindowProcessing.
					self onSelChanged.	"Selection may have changed"
					answer]
				ifFalse: 
					["Suppress the mouse down so not received by control"
					0]].!

onDisplayDetailsRequired: lvitem 
	"Private - Get the display info for the receiver's row identified by the <LVITEM>, lvitem."

	"N.B. This is a callback request from the ListView's paint handler so setting an
	unconditional breakpoint in here may bring your image to its knees as the LV repeatedly
	attempts to paint a damaged region."

	"Implementation Note: If in report mode then the task of supplying the text/images is
	delegated to the particular column, otherwise the valuables local to the receiver are used.
	This may seem inconsistent, but it allows different text/images to be displayed for the
	primary column if the application requires that the view be dynamically switchable between
	#report mode and the other modes."

	| rowObject mask column columnIdx |
	rowObject := self objectFromHandle: lvitem handle ifAbsent: [UnknownItem].
	"List sometimes asks for lvitem we no longer have, answer nil to accept default processing"
	rowObject == UnknownItem ifTrue: [^nil].
	self isReportMode 
		ifTrue: 
			[columnIdx := lvitem iSubItem + 1.
			column := self columnAtIndex: columnIdx].
	mask := lvitem mask.

	"Image Request?"
	(mask allMask: LVIF_IMAGE) 
		ifTrue: 
			[| imgIdx |
			imgIdx := ((column notNil and: [self hasColumnImages]) ifTrue: [column] ifFalse: [self]) 
						imageFromRow: rowObject.
			imgIdx notNil ifTrue: [lvitem image: imgIdx - 1]].

	"Text request?"
	(mask allMask: LVIF_TEXT) 
		ifTrue: 
			["If in report mode the column's get text block is used unless the request
			 is for the primary column and its text block is nil, in which case the view
			 level block is used"
			lvitem 
				textInBuffer: (((column notNil and: [columnIdx > 1 or: [column getTextBlock notNil]]) 
						ifTrue: [column]
						ifFalse: [self]) textFromRow: rowObject)].
	(mask allMask: LVIF_INDENT) 
		ifTrue: 
			["Indenting is only supported for the whole row, not on a per-column basis"
			lvitem indent: (self indentFromRow: rowObject)].
	^0	"suppress default processing"!

onDropDown: aToolbarButton 
	"Private - The receiver's toolbar has sent a notification that a button's drop-down arrow
	has been pressed. Generate and pop-up the appropriate menu."

	| popup |
	aToolbarButton command asSymbol == #viewModeSelect ifFalse: [^nil].
	popup := self buildViewsPopup.
	popup queryAllFromView: self.
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

	(aPositionEvent isRectangleChanged and: [self isReportMode]) 
		ifTrue: 
			[| width count |
			width := aPositionEvent width.
			count := self itemCount.
			count > 0 
				ifTrue: 
					[| extent |
					extent := self 
								lvmApproximateViewRect: count
								cx: width
								cy: aPositionEvent height.
					extent y - SystemMetrics current scrollbarHeight > aPositionEvent height 
						ifTrue: [width := width - SystemMetrics current scrollbarWidth]].
			self autoResizeColumns: width].
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
	super onSelChanged: anArray!

onSelChanging: anArray cause: aSymbol
	"Private - Selection is changing in the receiver to the item in the receiver's model 
	identified by the specified <Collection> of <integer> indices. 
	Note that #selectionChanging: events are only fired as a direct consequence of 
	user initiated actions, not in response to selection changes that occur as direct 
	or indirect results of programmatic actions."

	^self isStateRestoring or: 
			[| event |
			event := SelectionChangingEvent forSource: self.
			event
				newSelections: (anArray collect: [:each | self objectFromHandle: each]);
				oldSelections: (lastSelIndices collect: [:each | self objectFromHandle: each]);
				cause: aSymbol.
			self presenter onSelectionChanging: event.
			event value]!

onSelRemoved
	"Private - A selected item has been removed. Update the receiver's selection state to
	account."

	self onSelChanged: self selectionsByIndex!

onViewCreated
	"The receiver window has been created. Copy the info held
	in instance variables across to it, and perform any other state
	initialization that is required on attachment of the receiver's
	associated native window."

	super onViewCreated.
	lastSelIndices := #().
	self setControlBackcolor.
	self forecolor ifNotNil: [:fore | self forecolor: fore].
	self allColumns
		keysAndValuesDo: [:eachIndex :eachColumn | self basicAddColumn: eachColumn atIndex: eachIndex].
	self viewMode: self viewMode.
	self lvmSetExtendedListViewStyle: -1 dwExStyle: lvStyle.
	self refreshContents.
	self iconSpacing ifNotNil: [:spacing | self lvmSetIconSpacing: spacing]!

primaryColumn
	"Private - Answer the primary column for the report view mode"

	^self allColumns first!

primarySelectionIndex
	"Answer the index of the selected item with focus, or zero if there is no selection."

	| caret selected |
	selected := self selectionsByIndex.
	^selected isEmpty
		ifTrue: [0]
		ifFalse: 
			[caret := self caretIndex.
			(selected includes: caret) ifTrue: [caret] ifFalse: [selected first]]!

queryCommand: aCommandQuery
	"Update aCommandQuery to indicates how a command would be processed.
	if sent to the receiver. Answers whether the receiver recognised the command
	as one of its own (this may be ignored by the command router). This need not
	be supersent if the #isEnabled: is sent to the <CommandQuery> to explicitly
	enable or disable a particular command."

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
				ifFalse: 
					[columnIndex < lastClickedColIndex 
						ifTrue: [lastClickedColIndex := lastClickedColIndex - 1]]].
	(columns removeAtIndex: columnIndex) parent: nil.
	self basicRemoveColumnAtIndex: columnIndex.
	self
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

revertSelection
	"Private - Revert to the last recorded selection (useful if the user indicated that he didn't want
	to change selection after all when prompted)."

	self basicSelectionsByIndex: lastSelIndices!

selectAll
	| size |
	size := self size.
	self selectedCount ~= size ifTrue: [self selectionsByIndex: (1 to: size)]!

selectedCount
	"Private - Answer the total number of items selected in the receiver."

	^self sendMessage: LVM_GETSELECTEDCOUNT!

selectIndex: anInteger set: aBoolean
	"Private - Set/reset the selection state of the object at the specified one-based <integer>
	index within the receiver according to the <boolean> argument."

	| anLvItem mask |
	anLvItem := LVITEMW new.
	mask := NTLibrary isWine
				ifTrue: 
					["Having autoSelectPackages option turned on in System
					 Browser gives unpleasant scrolling effect when many
					 multiple packages are selected. This also happens in
					 Package Browser. Problem under Wine traced to LVIS_FOCUSED
					 option in ListView>>selectIndex:. Not sure what overall
					 effect it will have turning this off."
					LVIS_SELECTED]
				ifFalse: [##(LVIS_SELECTED | LVIS_FOCUSED)].
	anLvItem stateMask: mask.
	aBoolean ifTrue: [anLvItem dwState: mask].
	self lvmSetItem: anInteger - 1 state: anLvItem!

selections: aCollection ifAbsent: aNiladicOrMonadicValuable 
	"Select the first occurrences of the specified collection of <Object>s in the receiver and
	answer the new selection. If any of the elements of the collection are not present in the
	receiver's list, then answer the result of evaluating the <monadicValuable>,
	exceptionHandler. If the exception handler expects a single argument it is passed a
	<collection> of the missing items."

	| missing indices |
	missing := OrderedCollection new.
	indices := self handlesFromObjects: aCollection whenAbsent: [:e | missing addLast: e].
	self setSelectionsByIndex: indices.
	^missing isEmpty 
		ifTrue: [aCollection]
		ifFalse: 
			[aNiladicOrMonadicValuable argumentCount == 1 
				ifTrue: [aNiladicOrMonadicValuable value: missing]
				ifFalse: [aNiladicOrMonadicValuable value]]!

selectionsByIndex: aCollection ifAbsent: exceptionHandler 
	"Select the objects identified by the <collection> of <integer> indices, indices, in the
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
		ifTrue: 
			[exceptionHandler argumentCount == 1 
				ifTrue: [exceptionHandler value: (aCollection difference: inRange)]
				ifFalse: [exceptionHandler value]]
		ifFalse: [inRange]!

setColumnIcon: anImage atIndex: anInteger
	| lvcol |
	lvcol := LVCOLUMNW new.
	lvcol alignment: (self columnAtIndex: anInteger) alignment.
	anImage isNil
		ifFalse: 
			[lvcol image: (imageManager indexOfImage: anImage) - 1.
			lvcol fmt: (lvcol fmt bitOr: ##(LVCFMT_BITMAP_ON_RIGHT | LVCFMT_IMAGE))].
	self lvmSetColumn: lvcol at: anInteger - 1!

setControlBackcolor: aColor 
	| clrref |
	clrref := aColor asColorRef asParameter.
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

setSelectionsByIndex: indices 
	(indices noDifference: lastSelIndices) ifTrue: [^self].
	self basicSelectionsByIndex: indices.
	self ensureSelectionVisible.
	"Note: We have to check again whether the selection has changed because of the single-select
	case - onSelChanged does this."
	self onSelChanged!

setSingleSelection: anInteger 
	self selectIndex: anInteger set: anInteger ~~ 0!

setViewMode: aSymbol 
	viewMode := aSymbol!

setWidthOfColumn: colIndexInteger to: widthInteger
	"Set the width of the column identified by itemIndex to anInteger."

	self lvmSetColumnWidth: colIndexInteger-1 to: widthInteger.
	self invalidateLayout!

showDropHighlight: item
	"Private - Shows a drop highlight for the item at the specified one-based <Integer> 
	index within the receiver."

	| anLvItem |
	anLvItem := LVITEMW new.
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
	self backImage notNil 
		ifTrue: [sequence add: (MessageSend receiver: self selector: #backImageChanged)].
	^sequence!

stateImageList: aWinImageList
	"Private - Set the receiver's state image list to aWinImageList."

	^self lvmSetImageList: aWinImageList type: LVSIL_STATE!

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
	thumbnailExtent := aPointOrNil = self defaultThumbnailExtent ifFalse: [aPointOrNil]!

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

	self updateColumnAtIndex: (self allColumns indexOf: aListViewColumn)!

updateColumnAtIndex: anInteger
	"Private - Update the view to reflect the current state of the column
	at columnIndex. If this is the primary column then we must update
	the receiver's text too."

	self basicUpdateColumnAtIndex: anInteger.
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
	lastSelIndices notEmpty ifTrue: [lastSelIndices := self selectionsByIndex]!

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
	self isVirtual ifTrue: [self invalidate] ifFalse: [self updateAll].
	self trigger: #viewModeChanged!

viewModeSelect
	"Toggle the view mode of the receiver"

	self 
		viewMode: (#(#report #extraLargeIcons #thumbnails #tileIcons #largeIcons #smallIcons #list #report) 
				after: self viewMode)!

wantCustomDrawItemNotifications: pNMHDR
	^self customDrawBlock notNil or: [self hasSubItemCustomDraw]! !
!ListView categoriesFor: #addAllNonVirtual!private!updating! !
!ListView categoriesFor: #addColumn!adding!columns!public! !
!ListView categoriesFor: #addColumn:!adding!columns!public! !
!ListView categoriesFor: #addColumn:atIndex:!adding!columns!public! !
!ListView categoriesFor: #addOrUpdate:nonVirtualItems:afterIndex:!private!updating! !
!ListView categoriesFor: #allColumns!columns!public! !
!ListView categoriesFor: #anchorIndex!public!selection! !
!ListView categoriesFor: #anchorIndex:!public!selection! !
!ListView categoriesFor: #applyImageLists!image management!private! !
!ListView categoriesFor: #autoResizeColumns!operations!private! !
!ListView categoriesFor: #autoResizeColumns:!helpers!private! !
!ListView categoriesFor: #backcolorChanged!helpers!private! !
!ListView categoriesFor: #backImage!accessing!public! !
!ListView categoriesFor: #backImage:!accessing!public! !
!ListView categoriesFor: #backImageAlphaPercent!accessing!public! !
!ListView categoriesFor: #backImageAlphaPercent:!accessing!public! !
!ListView categoriesFor: #backImageChanged!accessing!helpers!private! !
!ListView categoriesFor: #backImageIsTiled!accessing!public! !
!ListView categoriesFor: #backImageIsTiled:!accessing!public! !
!ListView categoriesFor: #backImageOffset!accessing!public! !
!ListView categoriesFor: #backImageOffset:!accessing!public! !
!ListView categoriesFor: #basicAdd:atIndex:!adding!private! !
!ListView categoriesFor: #basicAddColumn:atIndex:!adding!columns!private! !
!ListView categoriesFor: #basicClear!private!removing! !
!ListView categoriesFor: #basicEditItemLabel:!operations!private! !
!ListView categoriesFor: #basicItemFromPoint:!accessing!private! !
!ListView categoriesFor: #basicRefreshContents!private!updating! !
!ListView categoriesFor: #basicRemoveAtIndex:!private!removing! !
!ListView categoriesFor: #basicRemoveColumnAtIndex:!columns!public!removing! !
!ListView categoriesFor: #basicResetSelection!private!selection! !
!ListView categoriesFor: #basicUpdateColumnAtIndex:!columns!private!updating! !
!ListView categoriesFor: #beSorted:!public!sorting! !
!ListView categoriesFor: #buildViewsPopup!helpers!private! !
!ListView categoriesFor: #cancelLabelEdit!operations!private! !
!ListView categoriesFor: #caretIndex!public!selection! !
!ListView categoriesFor: #caretIndex:!public!selection! !
!ListView categoriesFor: #clearSelectionsByIndex:!public!selection! !
!ListView categoriesFor: #columnAtIndex:!columns!public! !
!ListView categoriesFor: #columnClass!constants!private! !
!ListView categoriesFor: #columnClicked:!helpers!private! !
!ListView categoriesFor: #columnCount!accessing!private! !
!ListView categoriesFor: #columnOrder!accessing!public! !
!ListView categoriesFor: #columnOrder:!accessing!public! !
!ListView categoriesFor: #columnsList!columns!public! !
!ListView categoriesFor: #columnsList:!columns!public! !
!ListView categoriesFor: #customDrawContextClass!constants!private! !
!ListView categoriesFor: #customDrawSubItem:!event handling!private! !
!ListView categoriesFor: #customImageExtent!accessing!private! !
!ListView categoriesFor: #defaultListViewExStyle!accessing-styles!constants!private! !
!ListView categoriesFor: #defaultThumbnailExtent!constants!private! !
!ListView categoriesFor: #defaultWindowStyle!constants!private! !
!ListView categoriesFor: #dispatchRegistered:wParam:lParam:!operations!private! !
!ListView categoriesFor: #editLabelStyle!constants!private! !
!ListView categoriesFor: #ensureSelectionVisible!public!selection! !
!ListView categoriesFor: #ensureVisible:!operations!public! !
!ListView categoriesFor: #errorInCommonControlCall:!exceptions!private! !
!ListView categoriesFor: #extraLargeIconMode!commands!public! !
!ListView categoriesFor: #findItem:startingAt:wrap:!private!searching! !
!ListView categoriesFor: #forecolor:!accessing!public! !
!ListView categoriesFor: #forgetLastClickedColumn!helpers!private! !
!ListView categoriesFor: #getItemText:!accessing!private! !
!ListView categoriesFor: #getMultipleSelections!private!selection! !
!ListView categoriesFor: #getSingleSelection!private!selection! !
!ListView categoriesFor: #getThumbnailOf:!helpers!private! !
!ListView categoriesFor: #hasBorderSelect!accessing-styles!public! !
!ListView categoriesFor: #hasBorderSelect:!accessing-styles!public! !
!ListView categoriesFor: #hasCheckBoxes!accessing-styles!public! !
!ListView categoriesFor: #hasCheckBoxes:!accessing-styles!public! !
!ListView categoriesFor: #hasColumnHeaders!accessing!public! !
!ListView categoriesFor: #hasColumnHeaders:!accessing!public! !
!ListView categoriesFor: #hasColumnImages!accessing-styles!public! !
!ListView categoriesFor: #hasColumnImages:!accessing-styles!public! !
!ListView categoriesFor: #hasFlatScrollbars!accessing-styles!public! !
!ListView categoriesFor: #hasFlatScrollbars:!accessing-styles!public! !
!ListView categoriesFor: #hasFullRowSelect!accessing-styles!public! !
!ListView categoriesFor: #hasFullRowSelect:!accessing-styles!public! !
!ListView categoriesFor: #hasGridLines!accessing-styles!public! !
!ListView categoriesFor: #hasGridLines:!accessing-styles!public! !
!ListView categoriesFor: #hasHeaderDragDrop!accessing-styles!public! !
!ListView categoriesFor: #hasHeaderDragDrop:!accessing-styles!public! !
!ListView categoriesFor: #hasHotTracking!accessing-styles!public! !
!ListView categoriesFor: #hasHotTracking:!accessing-styles!public! !
!ListView categoriesFor: #hasInfoTips!accessing-styles!public! !
!ListView categoriesFor: #hasInfoTips:!accessing-styles!public! !
!ListView categoriesFor: #hasLargeImages!private!testing! !
!ListView categoriesFor: #hasPrimaryColumnImages!private!testing! !
!ListView categoriesFor: #hasSortHeaders!accessing-styles!public! !
!ListView categoriesFor: #hasSortHeaders:!accessing-styles!public! !
!ListView categoriesFor: #hasSubItemCustomDraw!private!testing! !
!ListView categoriesFor: #hideDropHighlight!drag & drop!private! !
!ListView categoriesFor: #iconSpacing!accessing!public! !
!ListView categoriesFor: #iconSpacing:!accessing!public! !
!ListView categoriesFor: #imageFromRow:!adapters!private!wine fix! !
!ListView categoriesFor: #indentFromRow:!adapters!private! !
!ListView categoriesFor: #infoTipFromRow:withPrefix:!adapters!private! !
!ListView categoriesFor: #initialize!initializing!private! !
!ListView categoriesFor: #invalidateHeader!private!updating! !
!ListView categoriesFor: #isArrangeable!arranging!public! !
!ListView categoriesFor: #isAutoArranged!arranging!public! !
!ListView categoriesFor: #isAutoArranged:!accessing-styles!public! !
!ListView categoriesFor: #isDoubleBuffered!accessing-styles!public! !
!ListView categoriesFor: #isDoubleBuffered:!accessing-styles!public! !
!ListView categoriesFor: #isMultiSelect!public!selection!testing! !
!ListView categoriesFor: #isMultiSelect:!public!testing! !
!ListView categoriesFor: #isReportMode!private!updating! !
!ListView categoriesFor: #isVirtual!accessing-styles!public! !
!ListView categoriesFor: #isVirtual:!accessing-styles!public! !
!ListView categoriesFor: #itemCount!accessing!public! !
!ListView categoriesFor: #itemFromNMHDRW:!helpers!private! !
!ListView categoriesFor: #itemFromPoint:!enquiries!private! !
!ListView categoriesFor: #itemRect:textOnly:!enquiries!public! !
!ListView categoriesFor: #itemsPerPage!geometry!public! !
!ListView categoriesFor: #largeIconExtent:!constants!public! !
!ListView categoriesFor: #largeIconMode!commands!public! !
!ListView categoriesFor: #lastSelIndices!accessing!private! !
!ListView categoriesFor: #lastSelIndices:!accessing!private! !
!ListView categoriesFor: #listMode!commands!public! !
!ListView categoriesFor: #listViewStyleAllMask:!accessing-styles!private! !
!ListView categoriesFor: #listViewStyleMask:set:!accessing-styles!private! !
!ListView categoriesFor: #lvmApproximateViewRect:cx:cy:!geometry!private! !
!ListView categoriesFor: #lvmArrange:!operations!private! !
!ListView categoriesFor: #lvmCreateDragImage:position:!operations!private! !
!ListView categoriesFor: #lvmDeleteAllItems!private!removing! !
!ListView categoriesFor: #lvmDeleteColumn:!columns!private!removing! !
!ListView categoriesFor: #lvmDeleteItem:!private!removing! !
!ListView categoriesFor: #lvmEnsureVisible:partial:!operations!private! !
!ListView categoriesFor: #lvmFindItem:startingAt:!operations!private! !
!ListView categoriesFor: #lvmGetBkImage:!accessing!private! !
!ListView categoriesFor: #lvmGetCallbackMask!accessing!private! !
!ListView categoriesFor: #lvmGetColumnOrderArray!accessing!private! !
!ListView categoriesFor: #lvmGetColumnWidth:!accessing!private! !
!ListView categoriesFor: #lvmGetExtendedListViewStyle!accessing!private! !
!ListView categoriesFor: #lvmGetHeader!geometry!private! !
!ListView categoriesFor: #lvmGetItem:!accessing!private! !
!ListView categoriesFor: #lvmGetItemPosition:!geometry!private! !
!ListView categoriesFor: #lvmGetItemRect:bounding:!geometry!private! !
!ListView categoriesFor: #lvmGetItemSpacing!accessing!private! !
!ListView categoriesFor: #lvmGetItemState:mask:!accessing!private! !
!ListView categoriesFor: #lvmGetNextItem:flags:!accessing!private! !
!ListView categoriesFor: #lvmGetOrigin!accessing!private! !
!ListView categoriesFor: #lvmGetStringWidth:!accessing!private! !
!ListView categoriesFor: #lvmGetSubItemRect:subitem:bounding:!private! !
!ListView categoriesFor: #lvmGetView!accessing-styles!private! !
!ListView categoriesFor: #lvmGetViewRect!geometry!private! !
!ListView categoriesFor: #lvmInsertAt:column:!adding!private! !
!ListView categoriesFor: #lvmInsertItem:!adding!private! !
!ListView categoriesFor: #lvmRedrawItems:to:!operations!private! !
!ListView categoriesFor: #lvmSetBkImage:!accessing!private! !
!ListView categoriesFor: #lvmSetCallbackMask:!accessing!private! !
!ListView categoriesFor: #lvmSetColumn:at:!columns!private! !
!ListView categoriesFor: #lvmSetColumnOrderArray:!accessing!private! !
!ListView categoriesFor: #lvmSetColumnWidth:to:!accessing!private! !
!ListView categoriesFor: #lvmSetExtendedListViewStyle:!accessing!private! !
!ListView categoriesFor: #lvmSetExtendedListViewStyle:dwExStyle:!accessing!private! !
!ListView categoriesFor: #lvmSetIconSpacing:!accessing!private! !
!ListView categoriesFor: #lvmSetImageList:type:!image management!private! !
!ListView categoriesFor: #lvmSetItem:!accessing!private! !
!ListView categoriesFor: #lvmSetItem:position:!geometry!private! !
!ListView categoriesFor: #lvmSetItem:state:!accessing!private! !
!ListView categoriesFor: #lvmSetItemCount:!operations!private! !
!ListView categoriesFor: #lvmSetItemText:index:!accessing!private! !
!ListView categoriesFor: #lvmSetView:!geometry!private! !
!ListView categoriesFor: #lvmUpdate:!operations!private! !
!ListView categoriesFor: #lvnBeginScroll:!event handling-win32!private! !
!ListView categoriesFor: #lvnColumnClick:!event handling-win32!private! !
!ListView categoriesFor: #lvnColumnDropDown:!event handling-win32!private! !
!ListView categoriesFor: #lvnColumnOverflowClick:!event handling-win32!private! !
!ListView categoriesFor: #lvnDeleteAllItems:!event handling-win32!private! !
!ListView categoriesFor: #lvnEndScroll:!event handling-win32!private! !
!ListView categoriesFor: #lvnFindItem:!event handling-win32!private! !
!ListView categoriesFor: #lvnGetEmptyMarkup:!event handling-win32!private! !
!ListView categoriesFor: #lvnGetInfoTip:!event handling-win32!private! !
!ListView categoriesFor: #lvnIncrementalSearch:!event handling-win32!private! !
!ListView categoriesFor: #lvnInsertItem:!event handling-win32!private! !
!ListView categoriesFor: #lvnItemActivate:!event handling-win32!private! !
!ListView categoriesFor: #lvnItemChanged:!private!selection! !
!ListView categoriesFor: #lvnItemChanging:!event handling-win32!private! !
!ListView categoriesFor: #lvnLinkClick:!event handling-win32!private! !
!ListView categoriesFor: #lvnMarqueeBegin:!event handling-win32!private! !
!ListView categoriesFor: #lvnODStateChanged:!event handling-win32!private! !
!ListView categoriesFor: #maybeSelChanging:!event handling!private! !
!ListView categoriesFor: #moreParams!accessing!private! !
!ListView categoriesFor: #moreParamsAt:!accessing!private! !
!ListView categoriesFor: #moreParamsAt:put:!accessing!private! !
!ListView categoriesFor: #newSelectionsFromEvent:!event handling!private! !
!ListView categoriesFor: #nmClick:!event handling-win32!private! !
!ListView categoriesFor: #nmNotify:!event handling-win32!private! !
!ListView categoriesFor: #nmRClick:!event handling-win32!private! !
!ListView categoriesFor: #notificationClass!constants!private! !
!ListView categoriesFor: #onButtonPressed:!event handling!private! !
!ListView categoriesFor: #onDisplayDetailsRequired:!event handling!private! !
!ListView categoriesFor: #onDropDown:!event handling!private! !
!ListView categoriesFor: #onEraseRequired:!event handling!public! !
!ListView categoriesFor: #onItem:removedAtIndex:!event handling!public! !
!ListView categoriesFor: #onKeyPressed:!event handling!public! !
!ListView categoriesFor: #onKeyTyped:!event handling!public! !
!ListView categoriesFor: #onLeftButtonDoubleClicked:!event handling!public! !
!ListView categoriesFor: #onLeftButtonPressed:!event handling!public! !
!ListView categoriesFor: #onPositionChanged:!event handling!public! !
!ListView categoriesFor: #onRightButtonPressed:!event handling!public! !
!ListView categoriesFor: #onSelChanged:!event handling!private! !
!ListView categoriesFor: #onSelChanging:cause:!event handling!private! !
!ListView categoriesFor: #onSelRemoved!public!selection! !
!ListView categoriesFor: #onViewCreated!event handling!public! !
!ListView categoriesFor: #primaryColumn!columns!private! !
!ListView categoriesFor: #primarySelectionIndex!public!selection! !
!ListView categoriesFor: #queryCommand:!commands!public! !
!ListView categoriesFor: #refreshContents!public!updating! !
!ListView categoriesFor: #refreshNonVirtual!private!updating! !
!ListView categoriesFor: #removeColumn:!columns!public!removing! !
!ListView categoriesFor: #removeColumnAtIndex:!columns!public!removing! !
!ListView categoriesFor: #reportMode!commands!public! !
!ListView categoriesFor: #resetSelection!public!selection! !
!ListView categoriesFor: #resolutionScaledBy:!geometry!private! !
!ListView categoriesFor: #revertSelection!helpers!private!selection! !
!ListView categoriesFor: #selectAll!public!selection! !
!ListView categoriesFor: #selectedCount!private!selection! !
!ListView categoriesFor: #selectIndex:set:!private!selection!wine fix! !
!ListView categoriesFor: #selections:ifAbsent:!public!selection! !
!ListView categoriesFor: #selectionsByIndex:ifAbsent:!public!selection! !
!ListView categoriesFor: #setColumnIcon:atIndex:!helpers!private! !
!ListView categoriesFor: #setControlBackcolor:!helpers!private! !
!ListView categoriesFor: #setIconSpacing:!helpers!private! !
!ListView categoriesFor: #setSelectionsByIndex:!private!selection! !
!ListView categoriesFor: #setSingleSelection:!private!selection! !
!ListView categoriesFor: #setViewMode:!accessing!private! !
!ListView categoriesFor: #setWidthOfColumn:to:!columns!public! !
!ListView categoriesFor: #showDropHighlight:!drag & drop!private! !
!ListView categoriesFor: #showsSelAlways!accessing-styles!public! !
!ListView categoriesFor: #showsSelAlways:!accessing-styles!public! !
!ListView categoriesFor: #smallIconMode!commands!public! !
!ListView categoriesFor: #sortOnColumn:!columns!public!sorting! !
!ListView categoriesFor: #state!accessing!private! !
!ListView categoriesFor: #stateImageList:!image management!private! !
!ListView categoriesFor: #subItemRectRow:column:!geometry!public! !
!ListView categoriesFor: #text:!accessing!public! !
!ListView categoriesFor: #textFromRow:!adapters!private! !
!ListView categoriesFor: #thumbnailExtent!accessing!public! !
!ListView categoriesFor: #thumbnailExtent:!accessing!public! !
!ListView categoriesFor: #thumbnailsImageManager!image management!private! !
!ListView categoriesFor: #thumbnailsMode!commands!public! !
!ListView categoriesFor: #tileIconMode!commands!public! !
!ListView categoriesFor: #updateAllNonVirtual!private!updating! !
!ListView categoriesFor: #updateAllVirtual!private!updating! !
!ListView categoriesFor: #updateColumn:!columns!private!updating! !
!ListView categoriesFor: #updateColumnAtIndex:!columns!private!updating! !
!ListView categoriesFor: #updateItem:atIndex:!event handling!public! !
!ListView categoriesFor: #updateSelectionCache!helpers!private!selection! !
!ListView categoriesFor: #viewMode!accessing!public! !
!ListView categoriesFor: #viewModeChanged!helpers!private! !
!ListView categoriesFor: #viewModeSelect!commands!public! !
!ListView categoriesFor: #wantCustomDrawItemNotifications:!helpers!private! !

ListView methodProtocol: #multipleIndexSelectableItems attributes: #(#readOnly) selectors: #(#addSelectionsByIndex: #clearSelectionsByIndex: #selectionsByIndex #selectionsByIndex: #selectionsByIndex:ifAbsent:)!
ListView methodProtocol: #multipleSelectableItems attributes: #(#readOnly) selectors: #(#addSelections: #addSelections:ifAbsent: #hasSelection #selectAll #selections #selections: #selections:ifAbsent:)!

!ListView class methodsFor!

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

	self addClassConstant: 'LvModes'
		value: (IdentityDictionary new
				at: #thumbnails put: LVS_ICON;
				at: #smallIcons put: LVS_SMALLICON;
				at: #largeIcons put: LVS_ICON;
				at: #tileIcons put: LVS_ICON;
				at: #extraLargeIcons put: LVS_ICON;
				at: #list put: LVS_LIST;
				at: #report put: LVS_REPORT;
				shrink;
				isImmutable: true;
				yourself).
	UnknownItem := Object new!

onStartup
	"The system is starting: Register a message to be used for cancelling a selection after
	the fact."

	RevertSelMessage := self registerMessage: 'RevertSelection'!

stbConvertFromVersion10: anArray 
	"Private - Perform an STB conversion from a version 10 <ListView> to version 11,
	i.e. merge column and primaryColumns instance variables into one, and add a couple 
	of new spare inst. var slots."

	| array |
	array := super stbConvertFromVersion10: anArray.
	(array at: 24) addFirst: (array at: 23).	"Copy primary column into OrderedCollection of columns"
	array at: 23 put: nil.			"nil the former primary column slot"
	^array!

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

	| newArray size array |
	array := super stbConvertFromVersion2: anArray.
	size := array size.
	newArray := Array new: size + 1.
	newArray 
		replaceFrom: 1
		to: size
		with: array
		startingAt: 1.
	^newArray!

stbConvertFromVersion5: anArray 
	"Private - Perform an STB conversion from a version 5 (or earlier) <View> to version 6,
	i.e. insert lvStyle inst var in ListView and subclasses."

	^(super stbConvertFromVersion5: anArray) copyWith: 0!

viewModes
	^LvModes!

winClassName
	"Private - Answer the name of the Windows window class to use when realizing the receiver."

	^'SysListView32'! !
!ListView class categoriesFor: #columnClass!constants!private! !
!ListView class categoriesFor: #icon!constants!public! !
!ListView class categoriesFor: #initialize!development!initializing!private! !
!ListView class categoriesFor: #onStartup!events-session!public! !
!ListView class categoriesFor: #stbConvertFromVersion10:!binary filing!private! !
!ListView class categoriesFor: #stbConvertFromVersion11:!binary filing!private! !
!ListView class categoriesFor: #stbConvertFromVersion2:!binary filing!private! !
!ListView class categoriesFor: #stbConvertFromVersion5:!binary filing!private! !
!ListView class categoriesFor: #viewModes!accessing!public! !
!ListView class categoriesFor: #winClassName!constants!private! !

