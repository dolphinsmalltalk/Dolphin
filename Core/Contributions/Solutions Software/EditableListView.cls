"Filed out from Dolphin Smalltalk"!

ListView subclass: #EditableListView
	instanceVariableNames: 'activeEditorCoords originalColumns _spare0 rowForecolor rowBackcolor rowHeight smallImageExtent headerControl hotItemAndColumn tipText'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

EditableListView guid: (GUID fromString: '{e2b66e41-55e0-4105-a492-b9defd40cd23}')!

EditableListView comment: ''!

!EditableListView categoriesForClass!Unclassified! !

!EditableListView methodsFor!

activateEditorAt: aPoint cause: aSymbol tabbed: aBoolean

	"Private - aPoint is the row@column coordinates of a subitem
	if aBoolean is true, act as if tabbed into the field
	Return the editor activated, or nil if none"

	| itemIndex item column columnRectangle editor |

	self hideToolTipWindow.

	"requestDeactivateEditor should already have been sent and approved"
	self hasActiveEditor ifTrue: [self hideActiveEditor].

	itemIndex := aPoint x.
	(self ensureIndexSelected: itemIndex cause: aSymbol) ifFalse: ["Selection suppressed" ^nil].

	item := self list at: itemIndex.
	column := self columnAtIndex: aPoint y.

	(column isEditableWith: item) ifFalse: 
		[column isEditable ifTrue: [Sound beep: MessageBoxConstants.MB_ICONWARNING]. "Bell if the column is disabled for the current item only"
		^nil].

	"Ensure the editor is visibile"
	columnRectangle := column rectangle.
	(columnRectangle left < 0 or: [columnRectangle right > self width]) ifTrue: [self horzScrollBy: columnRectangle left].

	self activeEditorCoords: aPoint.
	self activeColumn setEditorValueFrom: item.
	
	editor := self activeEditor.

	self activeEditorNeedsHighlight
		ifTrue: [editor backcolor: self activeEditorHighlightColor]
		ifFalse: [editor backcolor: Color window].

	editor showIn: self activeEditorCellRect.	

	"If the cause is a mouse click, focus will be set by that. Otherwise set manually"
	aSymbol = #keyboard ifTrue: 
		[aBoolean 
			ifTrue: [editor tabFocus] 
			ifFalse: [editor setFocus]].

	^editor!

activateEditorForColumn: anEditableListViewColumn

	self activateEditorForColumnIndex: (self allColumns indexOf: anEditableListViewColumn)!

activateEditorForColumnIndex: anInteger

	| rowIndex |

	self list isEmpty ifTrue: [^self].

	rowIndex := self selectionOrCaretIndex.
	rowIndex = 0 ifTrue: [rowIndex := self list size].

	self activateEditorAt: (rowIndex@anInteger) cause: #keyboard tabbed: true!

activateFirstEditor

	"Return the activated editor, or nil if none"

	self list isEmpty ifTrue: [^nil].
	self hasEditableColumn ifFalse: [^nil].
	(self hasActiveEditor not or: [self requestDeactivateEditor]) ifFalse: [^nil].

	^(self firstEditableCoordsOnOrAfter: (self selectionOrCaretIndex max: 1)) ifNotNil: 
		[ :coords |
		self activateEditorAt: coords cause: #keyboard tabbed: true]!

activateLastEditor

	"Return the activated editor, or nil if none"

	self list isEmpty ifTrue: [^nil].
	self hasEditableColumn ifFalse: [^nil].
	(self hasActiveEditor not or: [self requestDeactivateEditor]) ifFalse: [^nil].

	^(self lastEditableCoordsOnOrBefore: (self selectionOrCaretIndex max: 1)) ifNotNil: 
		[ :coords |
		self activateEditorAt: coords cause: #keyboard tabbed: true]!

activeColumn
	^self activeColumnIndex ifNotNil: [ :index | self columnAtIndex: index]!

activeColumnIndex

	^self activeEditorCoords ifNotNil: [ :coords | coords y]!

activeEditor
	^self activeColumn ifNil: [nil] ifNotNil: [ :col | col editor]!

activeEditorCellRect

	| editorCoords cellRect firstCellOffset |

	editorCoords := self activeEditorCoords.
	editorCoords isNil ifTrue: [^0@0 extent: 0@0].

	"Outside the current list? Invalidate the whole column"
	(editorCoords x between: 1 and: self itemCount) ifFalse: [^self activeColumn rectangle].

	cellRect  := self lvmGetSubItemRect: editorCoords x - 1 subitem: editorCoords y - 1 bounding: LVIR_LABEL.	

	"Take off default icon spacing added to primary columnn (we handle this ourselves)"
	(editorCoords y = 1 and: [self hasRowImage or: [self hasColumnImages]]) 
		ifTrue: [firstCellOffset := self smallImageExtent x negated]
		ifFalse: [firstCellOffset := 0].

	"...but we need to add spacing if there is a per-column image"
	(firstCellOffset ~= 0 or: [self hasColumnImages and: [(self columnAtIndex: editorCoords y) hasColumnImage]]) ifTrue: [cellRect left: ((cellRect left + firstCellOffset + self columnImageSpacing) min: cellRect right)].

	^cellRect!

activeEditorCoords
	^activeEditorCoords!

activeEditorCoords: aPoint
	activeEditorCoords := aPoint!

activeEditorHighlightColor

	^Color face3d!

activeEditorModel
	^self activeEditorCoords ifNotNil: [ :coords | self list at: coords x]!

activeEditorModelIndex
	^self activeEditorCoords 
		ifNil: [0]
		ifNotNil: [ :coords | coords x]!

activeEditorModelIndex: anInteger
	^self activeEditorCoords ifNotNil: [ :coords | coords x: anInteger]!

activeEditorNeedsHighlight

	^self showsSelAlways and: 
		[self hasFullRowSelect or: [self activeEditor == self primaryColumn editor]]!

applyImageLists
	"Private - Set the receiver's image lists from the image managers.
	By using a custom smallImageList we can change the row size"

	| smallImList largeImList |

	self isMultiline ifFalse: [^super applyImageLists].

	smallImList := WinImageList newExtent: (self smallImageExtent x@(self rowPixelHeight - 1)) truncated initialSize: 0 masked: false.
	self imageManager notNil ifTrue: [largeImList := self imageManager imageListWithExtent: self largeIconExtent].

	self lvmSetImageList: smallImList type: LVSIL_SMALL. 
	self lvmSetImageList: largeImList type: LVSIL_NORMAL!

canMoveActiveEditor

	^self hasActiveEditor and: [self requestDeactivateEditor]!

columnImagePadding

	^1!

columnImageSpacing

	^self smallImageExtent x + self columnImagePadding!

columnNamed: aStringOrSymbol

	^self columnNamed: aStringOrSymbol ifNone: [self error: ('column named <1p> not found' expandMacrosWith: aStringOrSymbol)]!

columnNamed: aStringOrSymbol ifNone: aBlock

	^self originalColumns detect: [ :each | each name = aStringOrSymbol] ifNone: aBlock!

columnUnderPoint: aPoint

	| itemStruct |

	itemStruct := self fullItemFromPoint: aPoint.

	^self allColumns at: (itemStruct iSubItem + 1)!

defaultOffsetForEditor: aColumnEditor

	"Works for most text-type editors (set an explicit offset on the editor if not)"

	| fontSize x y |

	fontSize := aColumnEditor actualFont pixelSize.

	x := ((21 - fontSize) / 3) rounded max: 0.
	y := ((self rowPixelHeight - (fontSize + 6)) / 2) rounded max: 0.

	(aColumnEditor column == self primaryColumn and: [self hasRowImage not and: [self hasColumnImages not]]) ifTrue: [x := x - 4].

	^x@y!

disconnectFromModel

	"Private - Deactivate any active editor, since the model is about to change under it"
	self hideActiveEditor.

	^super disconnectFromModel!

drawHorizontalGridlinesOn: aCanvas from: top to: bottom by: height

	"Private - Special handling in case a line overlaps an active editor"

	| ed edRect |

	ed := self activeEditor.
	ed isNil ifTrue: [^super drawHorizontalGridlinesOn: aCanvas from: top to: bottom by: height].
	
	edRect := ed rectangle.
	top to: bottom by: height do:
		[ :i |
		(i between: edRect top and: edRect bottom)
		ifTrue: 
			[aCanvas 
				lineFrom: (0@i) to: (edRect left@i);
				lineFrom: (edRect right@i) to: (self rectangle width@i)]
		ifFalse:
			[aCanvas lineFrom: (0@i) to: (self rectangle width@i)]]!

drawSubItem: context

	(context iSubItem = 0 and: [self customDrawBlock isNil not]) ifTrue: [self customDrawBlock value: context].

	^context column ownerDraw: context!

ensureIndexSelected: anInteger cause: aSymbol

	self selectionByIndex = anInteger ifTrue: [^true].

	^(self onSelChanging: (Array with: anInteger) cause: aSymbol)
		ifTrue: [self singleSelect: anInteger. true]
		ifFalse: [false]!

fieldExitDown

	self moveEditorVerticallyBy: 1!

fieldExitNextTabbed: aBoolean

	self canMoveActiveEditor ifFalse: [^self].

	(self nextEditableCoordsAfter: self activeEditorCoords)
		ifNil: [self tabNext]
		ifNotNil: [ :prev | self activateEditorAt: prev cause: #keyboard tabbed: aBoolean]!

fieldExitPrevTabbed: aBoolean

	self canMoveActiveEditor ifFalse: [^self].

	(self nextEditableCoordsBefore: self activeEditorCoords)
		ifNil: [self tabPrevious]
		ifNotNil: [ :prev | (self activateEditorAt: prev cause: #keyboard tabbed: aBoolean) ifNotNil: [ :editor | aBoolean ifFalse: [editor onCursoredLeft]]]!

fieldExitUp

	self moveEditorVerticallyBy: -1!

filerProxy

	"Don't save the headerControl (if present)"

	| temp proxy |

	headerControl isNil ifTrue: [^super filerProxy].

	temp := headerControl.
	headerControl := nil.
	proxy := super filerProxy.
	proxy clearSubViews.
	headerControl := temp.
	^proxy!

firstEditableCoordsOnOrAfter: anInteger

	anInteger to: self list size do:
		[ :row || item |
		item := self list at: row.
		1 to: self allColumns size do:
			[ :col |
			((self columnAtIndex: col) isEditableWith: item) ifTrue: [^row@col]]].

	^nil!

hasActiveEditor

	^self activeColumn notNil!

hasEditableColumn

	^self allColumns anySatisfy: [ :each | each isEditable]
!

hasImageBlock

	^self getImageBlock notNil!

hasMultipleSelections

	^self selectionsByIndex size > 1!

hasRowImage

	^self hasImageBlock!

headerControl

	^headerControl ifNil: [headerControl := self getHeaderControl]!

hideActiveEditor

	self activeEditor ifNotNil: [ :editor | self hideEditor: editor]!

hideEditor: anEmbeddedEditor

	(self list isEmpty not and: [self hasSelection]) ifTrue: [self invalidateRect: self activeEditorCellRect].

	"Need to do this first to prevent the editor's lose focus notification resulting in another send to this method.
	However we need to preserve the x coord (item index) for now to handle any update"
	self activeEditorCoords y: nil.

	anEmbeddedEditor hide.

	"Editor is now gone"
	self activeEditorCoords: nil!

hotItemAndColumn
	^hotItemAndColumn!

hotItemAndColumn: anObject

	hotItemAndColumn := anObject!

hotItemTipText

	"Request tip text from the hot column for the hot item"

	^self hotItemAndColumn ifNotNil: 
		[ :pt || item column prefixText infoText |
		item := self list at: pt x.
		column := self allColumns at: pt y.
		prefixText := column infoTipPrefixTextFor: item on: self getDC.
		infoText := column infoTipFromRow: item withPrefix: prefixText.
		infoText isEmpty
			ifTrue: [prefixText]
			ifFalse: [infoText]]!

imageFromRow: anObject

	"Allow an image to be returned directly"
	^(super imageFromRow: anObject) ifNotNil: 
		[ :imageOrInteger |
		imageOrInteger isInteger 
			ifTrue: [imageOrInteger]
			ifFalse: [imageOrInteger imageIndex]]!

isDisplayContextSelectedOrHot: aContext

	^(self hasFullRowSelect or: [aContext iSubItem = 0]) and: [self isDisplayIndexSelectedOrHot: (aContext dwItemSpec + 1)]!

isDisplayIndexSelectedOrHot: anIndex

	^(self selectionsByIndex includes: anIndex) or: 
		["Use LVM_GETHOTITEM in addition to our own hot tracking, since the system call also takes into account visibility of the hot item"
		(self isHotIndex: anIndex) and: [anIndex = ((self sendMessage: LVM_GETHOTITEM) + 1)]]!

isHotIndex: anIndex

	"Range check to handle list changing underneath us"
	^self hotItemAndColumn 
		ifNil: [false] 
		ifNotNil: [ :point | point x = anIndex and: [anIndex <= self list size]]!

isMultiline

	^self rowHeight > 1!

itemAndColumnAt: aPoint

	| itemStruct itemIndex columnIndex |

	itemStruct := self fullItemFromPoint: aPoint.
	itemIndex := itemStruct iItem + 1.
	columnIndex := itemStruct iSubItem + 1.

	^((itemIndex between: 1 and: self list size) and: [columnIndex between: 1 and: self allColumns size])
		ifTrue: [itemIndex@columnIndex]
		ifFalse: [nil]!

lastEditableCoordsOnOrBefore: anInteger

	anInteger to: 1 by: -1 do:
		[ :row || item |
		item := self list at: row.
		self allColumns size to: 1 by: -1 do:
			[ :col |
			((self columnAtIndex: col) isEditableWith: item) ifTrue: [^row@col]]].

	^nil!

lvmSetColumn: anLvColumn at: columnIndex

	"Ignore if the receiver is not open"

	self isOpen ifTrue: [super lvmSetColumn: anLvColumn at: columnIndex]!

moveEditorVerticallyBy: anInteger

	| nextEditorCoords nextRow |

	self canMoveActiveEditor ifFalse: [^self].

	nextEditorCoords := self activeEditorCoords + (anInteger@0).
	nextRow := nextEditorCoords x.
	(nextRow between: 1 and: self list size) ifFalse: [^self].
	
	self activateEditorAt: nextEditorCoords cause: #keyboard tabbed: false!

nextEditableCoordsAfter: coords

	| row item | 

	row := coords x.
	item := self list at: row.
	(coords y + 1) to: self allColumns size do:
		[ :col |
		((self columnAtIndex: col) isEditableWith: item) ifTrue: [^row@col]].

	^self firstEditableCoordsOnOrAfter: row + 1!

nextEditableCoordsBefore: coords

	| row item | 

	row := coords x.
	item := self list at: row.
	(coords y - 1) to: 1 by: -1 do:
		[ :col |
		((self columnAtIndex: col) isEditableWith: item) ifTrue: [^row@col]].

	^self lastEditableCoordsOnOrBefore: row - 1!

nmCustomDraw: pNMHDR

	"Private - Override to trap or queue a (sub)item post-paint notification"

	| context columnIndex drawStage res |

	context := self customDrawContextClass fromAddress: pNMHDR.
	columnIndex := context iSubItem + 1.

	"Only needed to manually draw icons when multiline or the editor is active"
	(self isMultiline or: [(columnIndex >= 1) and: [columnIndex <= columns size and: [(self columnAtIndex: columnIndex) editor ifNil: [false] ifNotNil: [ :ed | ed hasVisibleStyle]]]]) ifFalse: [^super nmCustomDraw: pNMHDR].

	"Postdraw notification (see below)?"
	((drawStage := pNMHDR dwordAtOffset: 12) allMask: CDDS_ITEMPOSTPAINT) ifTrue:
		[(columnIndex > columns size or: [context rc width = 0]) ifFalse: 
			["The control attempts to draw stuff that isn't there on occasion"
			(self objectFromHandle: context itemHandle ifAbsent: [nil]) ifNotNil: 
				[ :item | 
				context item: item; view: self.	
				self postDraw: context columnIndex: columnIndex]].
		^CDRF_DODEFAULT].

	res := super nmCustomDraw: pNMHDR.

	"Request postdraw notification - see above"
	^((drawStage allMask: CDDS_ITEMPREPAINT) and: [(res = CDRF_DODEFAULT)
		and: [(self hasColumnImages and: [drawStage allMask: CDDS_SUBITEM])
				or: [self hasColumnImages not and: [self hasRowImage and: [columnIndex = 1]]]]])
					ifTrue: [CDRF_NOTIFYPOSTPAINT]
					ifFalse: [res]!

noSelection

	^0!

onDisplayDetailsRequired: lvitem 
	"Private - Get the display info for the receiver's row identified by the <LVITEM>, lvitem."

	"N.B. This is a callback request from the ListView so setting a breakpoint in here may bring
	your image to its knees."

	"Implementation Note: If in report mode then the task of supplying the text/images is
	delegated to the particular column, otherwise the valuables local to the receiver are used.
	This may seem inconsistent, but it allows different text/images to be displayed for the
	primary column if the application requires that the view be dynamically switchable between
	#report mode and the other modes."

	| rowObject mask column columnIdx |
	rowObject := self objectFromHandle: lvitem handle ifAbsent: [].
	"List sometimes asks for lvitem we no longer have, answer nil to accept default processing"
	rowObject isNil ifTrue: [^nil].
	self isReportMode 
		ifTrue: 
			[columnIdx := lvitem iSubItem + 1.
			column := self columnAtIndex: columnIdx].
	mask := lvitem mask.

	"Image Request"
	(mask allMask: LVIF_IMAGE) ifTrue: 
		[(((column notNil and: [self hasColumnImages]) ifTrue: [column] ifFalse: [self]) imageFromRow: rowObject) ifNotNil: [ :imgIdx | lvitem image: imgIdx - 1]].

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

onEditorLostFocus: anEmbeddedEditor

	self activeEditor == anEmbeddedEditor ifTrue: [self hideEditor: anEmbeddedEditor].

	"If the editor lost focus due to the shell losing focus, arrange that the receiver (not the editor) gets focus when reactivated"
	self topShell ifNotNil: 
		[ :shell | 
		(shell isOpen and: [shell view isActive not and: [shell view lastFocus == anEmbeddedEditor]]) ifTrue: [shell view lastFocus: self]]!

onHeaderBeginDrag

	self hideActiveEditor!

onHeaderBeginTrack

	self hideActiveEditor!

onItem: anObject addedAtIndex: anInteger 

	anInteger > self activeEditorModelIndex ifFalse: 
		["Adjustment needed"
		self activeEditorModelIndex = self itemCount 
			ifTrue: [self activeEditorModelIndex: 0]
			ifFalse: [self activeEditorModelIndex: self activeEditorModelIndex + 1]].

	self hideActiveEditor.

	^super onItem: anObject addedAtIndex: anInteger !

onItem: anObject removedAtIndex: anInteger

	anInteger > self activeEditorModelIndex ifFalse: 
		["Adjustment needed"
		anInteger = self activeEditorModelIndex
			ifTrue: [self activeEditorModelIndex: 0]
			ifFalse: [self activeEditorModelIndex: self activeEditorModelIndex - 1]].

	self hideActiveEditor.

	^super onItem: anObject removedAtIndex: anInteger !

onLeftButtonDoubleClicked: aMouseEvent

	self onLeftButtonPressed: aMouseEvent.

	(self itemAndColumnAt: aMouseEvent position) ifNotNil: 
		[ :itemAndColumn || item column |
		item := self list at: itemAndColumn x.
		column := self columnAtIndex: itemAndColumn y.
		(column events hasActionsForEvent: #itemDoubleClicked:) ifTrue: [^column trigger: #itemDoubleClicked: with: item]].

	^super onLeftButtonDoubleClicked: aMouseEvent!

onLeftButtonPressed: aMouseEvent

	| point itemStruct itemCoords |

	self hasActiveEditor ifTrue: 
		[self requestDeactivateEditor ifFalse: [^0].
		self hideActiveEditor].

	"Special handling only needed for single select"
	(self isMultiSelect and: [aMouseEvent isShiftDown or: [aMouseEvent isCtrlDown]]) ifTrue: [^super onLeftButtonPressed: aMouseEvent].

	point := aMouseEvent position.
	itemStruct := self fullItemFromPoint: point.

	"Not interested in clicks not on list items"
	itemStruct iItem negative ifTrue: [^super onLeftButtonPressed: aMouseEvent].

	itemCoords := (itemStruct iItem @ itemStruct iSubItem) + (1@1).

	"If clicked the icon, then select only"
	((self columnAtIndex: itemCoords y) hasColumnImage and: [(self lvmGetSubItemRect: itemStruct iItem subitem: itemStruct iSubItem bounding: LVIR_ICON) containsPoint: point]) ifTrue: 
		[^super onLeftButtonPressed: aMouseEvent].

	self hasFocus ifFalse: [self setFocus].

	self presenter trigger: #leftButtonPressed: with: aMouseEvent.

	"Activate the editor and pass the click along"
	(self activateEditorAt: itemCoords cause: #mouse tabbed: false) ifNotNil: [ :editor | [aMouseEvent resendTo: editor] postToMessageQueue].

	^0!

onMouseLeave: aMouseEvent

	self updateHotItem: nil.

	^super onMouseLeave: aMouseEvent!

onMouseMoved: aMouseEvent

	self updateHotItem: (self itemAndColumnAt: aMouseEvent position).

	^super onMouseMoved: aMouseEvent!

onMouseWheeled: aMouseWheelEvent
	self hideActiveEditor.
	^super onMouseWheeled: aMouseWheelEvent!

onPositionChanging: aPositionEvent

	self hideActiveEditor.

	^super onPositionChanging: aPositionEvent!

onSelChanged: anObject

	self hideActiveEditor.

	^super onSelChanged: anObject!

onSetFocus

	self trackMouseLeave.

	^super onSetFocus!

onValueChangedIn: aColumn

	|activeEditorModelIndex|
	"We keep the index in case of the view being hidden"
	activeEditorModelIndex := self activeEditorModelIndex.
	"If the list changed whilst the editor was active the change may be invalid - in this case we set the row being edited to zero"
	activeEditorModelIndex > 0 ifFalse: [^self].

	aColumn updateValueIn: (self list at: activeEditorModelIndex).

	"attempt to ensure that changes are triggered off the list model"
	self model refreshAtIndex: activeEditorModelIndex!

onViewOpened

	super onViewOpened.

	self headerControl 
		when: #beginDrag send: #onHeaderBeginDrag to: self;
		when: #beginTrack send: #onHeaderBeginTrack to: self.

	self originalColumns: self allColumns copy.
	self allColumns do: 
		[ :each | 
		each 
			createEditorIn: self;
			customDrawBlock: [ :context | self drawSubItem: context]]!

originalColumns

	^originalColumns ifNil: ["Pre-opening" self allColumns]!

originalColumns: aCollection

	originalColumns := aCollection!

postDraw: aContext columnIndex: anInteger

	((anInteger = 1 and: [self hasRowImage]) or: [self hasColumnImages]) 
		ifTrue: [(self columnAtIndex: anInteger) customDrawIcon: aContext]
		ifFalse: [aContext canvas free]!

preTranslateKeyboardInput: aMSG

	| key |

	key := aMSG wParam.

	(self activeColumn isNil and: [aMSG message = WM_KEYDOWN]) ifTrue:
		[(key = VK_RIGHT and: [self itemCount > 0]) ifTrue:
			[self hasSelection 
				ifTrue: [self activateFirstEditor notNil ifTrue: [^true]]
				ifFalse: [self selectionByIndex: 1. ^true]].

		(key =VK_TAB and: [self hasEditableColumn]) ifTrue:
			[Keyboard default isShiftDown
				ifTrue: [[self activateLastEditor] postToInputQueue]
				ifFalse: [[self activateFirstEditor] postToInputQueue].
			^true]].

	"Crude way to activate visual cues on tabbed set focus"
	(aMSG message = WM_KEYUP and: [key = VK_TAB]) ifTrue: [self shouldShowFocusRect: true].

	^super preTranslateKeyboardInput: aMSG!

removeColumn: aColumn

	super removeColumn: aColumn.

	self autoResizeColumns
!

requestDeactivateEditor

	^(self hasActiveEditor not or: [self activeEditor onRequestDeactivate])
		ifTrue: [true]
		ifFalse: [self activeEditor ifNotNil: [ :editor | editor show; tabFocus]. false]!

rowBackcolor
	^rowBackcolor!

rowBackcolor: anObject
	rowBackcolor := anObject!

rowForecolor
	^rowForecolor!

rowForecolor: anObject
	rowForecolor := anObject!

rowHeight

	^rowHeight ifNil: [1]!

rowHeight: anObject
	rowHeight := anObject.
	self isOpen ifTrue: [self hideActiveEditor; applyImageLists]!

rowPixelHeight

	^(self rowHeight ifNil: [1]) = 1
		ifTrue: [super rowPixelHeight]
		ifFalse: [((self actualFont pixelSize + 2) * self rowHeight) truncated + 1]!

selectionOrCaretIndex

	^self selectionByIndex > 0 
		ifTrue: [self selectionByIndex]
		ifFalse: [self caretIndex]!

setColumnIcon: anImage atIndex: anInteger

	"Only use to clear image - proper header sort images are set in sortOnColumn:"

	anImage isNil ifTrue: [self headerControl clearSortIconForColumnAtIndex: anInteger]!

shouldOwnerDrawSelectionHighlight

	"Themed controls appear to draw their own alpha-blended highlights"
	^self isThemed not or: [SystemMetrics current hasListViewAlphaBlendedHighlights not]!

showColumn: aColumn

	"Need to change the width of the column after addition to prompt a scrollbar to be added if necessary. 
	This happens automatically when removing a column but not when adding one. Need a better way..."
	[self disableRedraw.
	aColumn basicWidth: aColumn basicWidth - 1.
	self addColumn: aColumn atIndex: (self visibleColumns indexOf: aColumn)] ensure: 
		[aColumn width: aColumn basicWidth + 1.
		self autoResizeColumns.
		self enableRedraw]!

showColumn: aColumn after: anotherColumn

	(self originalColumns includes: aColumn) 
	ifTrue: 
		[self originalColumns remove: aColumn]
	ifFalse: 
		[aColumn
			createEditorIn: self;
			customDrawBlock: [ :context | self drawSubItem: context]].

	self originalColumns add: aColumn after: anotherColumn.
	self showColumn: aColumn!

singleSelect: anInteger

	| hadMultipleSelections |

	hadMultipleSelections := self hasMultipleSelections.		
	(hadMultipleSelections not and: [self selectionByIndex = anInteger]) ifFalse:
		[hadMultipleSelections ifTrue: [self selectionByIndex: self noSelection "Clear the selections"].
		self selectionByIndex: anInteger.
		self onSelChanged]!

smallImageExtent
	"Private - Answer the value of the receiver's 'smallImageExtent' instance variable."

	^smallImageExtent ifNil: [Icon smallExtent]!

smallImageExtent: anObject
	"Private - Set the value of the receiver's 'smallImageExtent' instance variable to the argument."

	smallImageExtent := anObject!

sortColumn

	^self allColumns at: self sortColumnIndex!

sortColumnIndex

	^lastClickedColIndex!

sortColumnIndex: anInteger

	self forgetLastClickedColumn.
	lastClickedColIndex := anInteger!

sortOnColumn: aListViewColumn

	super sortOnColumn: aListViewColumn.

	self sortColumnIndex: (self allColumns indexOf: aListViewColumn).
	self headerControl setSortIconForColumn: aListViewColumn!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of an object in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]!

ttnGetDispInfo: aNMTTDISPINFOW
	"ListView's own info tip notification doesn't fire for custom draw items, so we handle as per a normal control"

	self hotItemTipText
		ifNil: [presenter onTipDetailsRequired: aNMTTDISPINFOW]
		ifNotNil: [:text | aNMTTDISPINFOW text: text].

	"Note that we must keep a reference to the text string to prevent its premature death"
	tipText := aNMTTDISPINFOW text.
	^1!

updateHotItem: nowHot

	| wasHot | 

	nowHot = self hotItemAndColumn ifTrue: [^self].

	wasHot := self hotItemAndColumn.
	self hotItemAndColumn: nowHot.

	(Array with: wasHot with: nowHot) do: 
		[ :each | 
		each ifNotNil: 
			[ :pt |
			"Take account of a column hidden whilst it was hot"
			((self allColumns size >= pt y) and: [(self allColumns at: pt y) hasHotTracking]) ifTrue: 
				[self invalidateRect: 
					(self 
						lvmGetSubItemRect: pt x - 1 "0-based indexing"
						subitem: pt y - 1
						bounding: LVIR_BOUNDS)]]]!

visibleColumns

	^self originalColumns select: [ :each | each isVisible]!

wmHScroll: message wParam: wParam lParam: lParam 

	self hideActiveEditor.

	^super wmHScroll: message wParam: wParam lParam: lParam !

wmNotify: message wParam: wParam lParam: lParam
	"Private - Redirects WM_NOTIFY messages to the appropriate control as a notify message.
	Overridden here to handle notifications from the receiver's tool tip control which 
	does not itself have an associated View so cannot receive the redirected message.
	In any case it is more convenient to direct the notification to the receiver's
	#ttnNeedText: handler."

	| pnmhdr code |
	pnmhdr := lParam asExternalAddress.
	code := pnmhdr sdwordAtOffset: 8.
	(code == TTN_GETDISPINFOW or: [code == TTN_GETDISPINFOA]) ifTrue: [^self nmNotify: pnmhdr].
	^super wmNotify: message wParam: wParam lParam: lParam!

wmVScroll: message wParam: wParam lParam: lParam 

	self hideActiveEditor.

	^super wmVScroll: message wParam: wParam lParam: lParam ! !

!EditableListView categoriesForMethods!
activateEditorAt:cause:tabbed:!operations!private! !
activateEditorForColumn:!operations!public! !
activateEditorForColumnIndex:!operations!public! !
activateFirstEditor!operations!public! !
activateLastEditor!operations!public! !
activeColumn!accessing!public! !
activeColumnIndex!accessing!public! !
activeEditor!accessing!public! !
activeEditorCellRect!accessing!public! !
activeEditorCoords!accessing!private! !
activeEditorCoords:!accessing!private! !
activeEditorHighlightColor!accessing!public! !
activeEditorModel!accessing!public! !
activeEditorModelIndex!accessing!public! !
activeEditorModelIndex:!accessing!public! !
activeEditorNeedsHighlight!public!testing! !
applyImageLists!image management!private! !
canMoveActiveEditor!public!testing! !
columnImagePadding!accessing!public! !
columnImageSpacing!accessing!public! !
columnNamed:!accessing!public! !
columnNamed:ifNone:!accessing!public! !
columnUnderPoint:!accessing!public! !
defaultOffsetForEditor:!accessing!public! !
disconnectFromModel!operations!private! !
drawHorizontalGridlinesOn:from:to:by:!drawing!private! !
drawSubItem:!drawing!public! !
ensureIndexSelected:cause:!private!selection! !
fieldExitDown!operations!public! !
fieldExitNextTabbed:!operations!public! !
fieldExitPrevTabbed:!operations!public! !
fieldExitUp!operations!public! !
filerProxy!binary filing!private! !
firstEditableCoordsOnOrAfter:!helpers!private! !
hasActiveEditor!public!testing! !
hasEditableColumn!public!testing! !
hasImageBlock!public!testing! !
hasMultipleSelections!public!testing! !
hasRowImage!public!testing! !
headerControl!accessing!public! !
hideActiveEditor!operations!public! !
hideEditor:!operations!private! !
hotItemAndColumn!accessing!private! !
hotItemAndColumn:!accessing!private! !
hotItemTipText!accessing!public! !
imageFromRow:!accessing!public! !
isDisplayContextSelectedOrHot:!public!testing! !
isDisplayIndexSelectedOrHot:!public!testing! !
isHotIndex:!public!testing! !
isMultiline!public!testing! !
itemAndColumnAt:!accessing!private! !
lastEditableCoordsOnOrBefore:!helpers!private! !
lvmSetColumn:at:!columns!private! !
moveEditorVerticallyBy:!operations!private! !
nextEditableCoordsAfter:!helpers!private! !
nextEditableCoordsBefore:!helpers!private! !
nmCustomDraw:!event handling!private! !
noSelection!accessing!public! !
onDisplayDetailsRequired:!event handling!private! !
onEditorLostFocus:!event handling!public! !
onHeaderBeginDrag!event handling!public! !
onHeaderBeginTrack!event handling!public! !
onItem:addedAtIndex:!event handling!public! !
onItem:removedAtIndex:!event handling!public! !
onLeftButtonDoubleClicked:!event handling!public! !
onLeftButtonPressed:!event handling!public! !
onMouseLeave:!event handling!public! !
onMouseMoved:!event handling!public! !
onMouseWheeled:!event handling!public! !
onPositionChanging:!event handling!public! !
onSelChanged:!event handling!public! !
onSetFocus!event handling!public! !
onValueChangedIn:!event handling!public! !
onViewOpened!event handling!public! !
originalColumns!accessing!public! !
originalColumns:!accessing!public! !
postDraw:columnIndex:!drawing!private! !
preTranslateKeyboardInput:!event handling!public! !
removeColumn:!columns!private! !
requestDeactivateEditor!operations!private! !
rowBackcolor!accessing!private! !
rowBackcolor:!accessing!private! !
rowForecolor!accessing!private! !
rowForecolor:!accessing!private! !
rowHeight!accessing!public! !
rowHeight:!accessing!public! !
rowPixelHeight!accessing!public! !
selectionOrCaretIndex!private!selection! !
setColumnIcon:atIndex:!helpers!public! !
shouldOwnerDrawSelectionHighlight!public!testing! !
showColumn:!columns!private! !
showColumn:after:!columns!private! !
singleSelect:!private!selection! !
smallImageExtent!accessing!public! !
smallImageExtent:!accessing!public! !
sortColumn!public!sorting! !
sortColumnIndex!public!sorting! !
sortColumnIndex:!private!sorting! !
sortOnColumn:!public!sorting! !
stbSaveOn:!binary filing!public! !
ttnGetDispInfo:!event handling!public! !
updateHotItem:!helpers!public! !
visibleColumns!accessing!public! !
wmHScroll:wParam:lParam:!event handling!private! !
wmNotify:wParam:lParam:!event handling!public! !
wmVScroll:wParam:lParam:!event handling!private! !
!

!EditableListView class methodsFor!

columnClass
	"Answer the class of object used to represent the columns of the receiver."

	^EditableListViewColumn!

stbConvert: instVarArray fromVersion: verInteger

	| origInstVars instVars offset base new |
	origInstVars := super stbConvert: instVarArray fromVersion: (verInteger <= 14 ifTrue: [11] ifFalse: [verInteger]).
	instVars := origInstVars.
	offset := 0.
	base := ListView instSize.

	verInteger < 12 ifTrue: 
		["Added rowHeight"
		new := Array new: instVars size + 1.
		new replaceFrom: 1 to: (##(self) instSize - 3) with: instVars startingAt: 1.
		new at: (##(self) instSize - 2) put: 1.
		instVars := new.
		offset := offset + 1].

	verInteger < 14 ifTrue:
		["Added _spares"
		new := Array new: instVars size + 2.
		new replaceFrom: 1 to: (##(self) instSize - 2) with: instVars startingAt: 1.
		new 
			at: ##(self) instSize put: nil;
			at: (##(self) instSize - 1) put: nil.
		instVars := new.
		offset := offset + 2].

	verInteger < 15 ifTrue:
		["Added hotItemAndColumn tipText'"
		new := Array new: instVars size + 2.
		new replaceFrom: 1 to: (##(self) instSize - 2) with: instVars startingAt: 1.
		offset := offset + 2.

		(new at: base + 6 "rowHeight") isNil ifTrue: [new at: base + 6 put: 1].
		(new at: base + 3 "old isMultiSelect") == true
			ifTrue: [(new instVarAt: 3) at: 1 put: ((new instVarAt: 3) first maskClear: LVS_SINGLESEL)]
			ifFalse: [(new instVarAt: 3) at: 1 put: ((new instVarAt: 3) first maskSet: LVS_SINGLESEL)].

		"Copy inst vars of any subclass"
		self instSize > ##(self) instSize ifTrue:
			[new 
				replaceFrom: (##(self) instSize + 1) 
				to: new size 
				with: origInstVars 
				startingAt: (##(self) instSize - offset) + 1].

		instVars := new].

	verInteger <= 15 ifTrue:
		["Renamed/reused inst vars. Clear out any old values no longer appropriate"
		instVars 
			at: base + 2 put: nil; "originalColumns - was multSelectStack"
			at: base + 8 put: nil "headerControl - was hotItemAndColumn"].

	^instVars!

stbVersion

	"12 - added rowHeight
	14 - added _spares
	15 - added hotItemAndColumn, tipText
	16 - renamed/reused inst vars"

	^16! !

!EditableListView class categoriesForMethods!
columnClass!constants!private! !
stbConvert:fromVersion:!binary filing!public! !
stbVersion!constants!private! !
!

