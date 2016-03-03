"Filed out from Dolphin Smalltalk 7"!

ListView subclass: #EditableListView
	instanceVariableNames: 'activeColumn multSelectStack _spare0 rowForecolor rowBackcolor rowHeight smallImageExtent hasVirtualGridlines'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EditableListView guid: (GUID fromString: '{E2B66E41-55E0-4105-A492-B9DEFD40CD23}')!
EditableListView comment: ''!
!EditableListView categoriesForClass!Unclassified! !
!EditableListView methodsFor!

activateEditorAt: aPoint tabbed: aBoolean

	"Private - aPoint is the row@column coordinates of a subitem
	if aBoolean is true, act as if tabbed into the field
	Return the editor activated, or nil if none"

	| itemRect column index item |

	itemRect := self lvmGetSubItemRect: (aPoint - (1@1)) bounding: LVIR_LABEL.
	index := aPoint x.
	item := self list at: index.

	column := self columnAtIndex: aPoint y.
	(column isEditableWith: item) ifFalse: 
		[column isEditable ifTrue: [Sound bell]. "Bell if the column is disabled for the current item only"
		self enableRedraw. 
		^nil].

	column hasColumnImage ifTrue: [itemRect left: ((itemRect left + self smallImageExtent x) min: itemRect right)].

	self activeEditorCoords: aPoint.

	[self activeEditorNeedsHighlight
		ifTrue: [self activeEditor backcolor: Color face3d]
		ifFalse: [self activeEditor backcolor: Color window].

	self activeColumn setEditorValueFrom: item.

	self activeEditor showIn: itemRect.
	
	aBoolean ifTrue: [self activeEditor tabFocus] ifFalse: [self activeEditor setFocus]]
		ensure: [self enableRedraw].

	^self activeEditor!

activateEditorForColumn: anEditableListViewColumn

	anEditableListViewColumn isEditable ifFalse: [^ self].
	self activateEditorForColumnIndex: (self allColumns indexOf: anEditableListViewColumn)!

activateEditorForColumnIndex: anInteger

	self list isEmpty ifTrue: [^self].
	self selectionByIndex = 0 ifTrue: [self selectionByIndex: self list size].

	((self columnAtIndex: anInteger) isEditableWith: self selection) ifFalse: [^self].

	^self activateEditorAt: (self selectionByIndex@anInteger) tabbed: true!

activateFirstEditor

	"Return the activated editor, or nil if none"

	| coords |

	self list isEmpty ifTrue: [^nil].
	self hasEditableColumn ifFalse: [^nil].

	coords := self firstEditableCoordsOnOrAfter: (self selectionByIndex max: 1).
	coords = nil ifTrue: [^nil].

	self selectionByIndex: coords x.
	^self activateEditorAt: coords tabbed: true!

activateLastEditor

	self selectionByIndex = 0 ifTrue: [self selectionByIndex: self list size].

	^self activateEditorAt: (self selectionByIndex@(self allColumns indexOf: self lastEditableColumn)) tabbed: true!

activeColumn
	^self columnAtIndex: (self activeEditorCoords ifNil: [^nil]) y!

activeColumnIndex

	^self activeEditorCoords y!

activeEditor
	^self activeColumn ifNil: [nil] ifNotNil: [ :col | col editor]!

activeEditorCoords
	^activeColumn!

activeEditorCoords: aPoint
	activeColumn := aPoint!

activeEditorNeedsHighlight

	^self showsSelAlways and: 
		[self hasFullRowSelect or: [self activeEditor == self primaryColumn editor]]!

additionalHorzOffsetFor: anEmbeddedEdit

	"Additional offset needed for embedded editors with column images (except primary col)"

	^(self hasColumnImage: anEmbeddedEdit)
		ifTrue: [self smallImageExtent x]
		ifFalse: [0]!

applyImageLists
	"Private - Set the receiver's image lists from the image managers."

	| largeImList smallImList pixelHeight |

	self isMultiline ifFalse: [^super applyImageLists].

	pixelHeight := (self actualFont pixelSize + 2) * self rowHeight.

	self imageManager notNil ifTrue: [
		largeImList := self imageManager imageListWithExtent: self largeIconExtent.
		smallImList := self imageManager basicImageListWithExtent: (self smallImageExtent x@pixelHeight)].

	smallImList addImage: Icon question.

	self lvmSetImageList: smallImList type: LVSIL_SMALL. 
	self lvmSetImageList: largeImList type: LVSIL_NORMAL!

clearFocusItem

	| anLvItem |

	anLvItem := LVITEM new.
	anLvItem stateMask: LVIS_FOCUSED.
	anLvItem dwState: 0.
	1 to: self itemCount do: [ :i | self lvmSetItem: i-1 state: anLvItem]!

clearFocusRect

	(self propertyAt: #focusRectDrawn ifAbsent: [false]) ifTrue:
		[self drawFocusRect: self clientFocusRectangle.
		self removePropertyAt: #focusRectDrawn]!

click: aMouseEvent activateEditor: aBoolean at: aPoint

	"Private - aPoint is the row@column coordinates of a subitem.
	Return the editor created, or nil if none"

	| row |

	row := aPoint x.

	self hasFocus ifFalse: [self setFocus].

	self validateMultSelectStack.
	(self isMultiSelect and: [aMouseEvent isShiftDown or: [aMouseEvent isCtrlDown]])
	ifTrue:
		[aMouseEvent isShiftDown
			ifTrue: [self handleShiftMultSelectOn: row]
			ifFalse: [self handleCtrlMultSelectOn: row]]
	ifFalse:
		[self handleSingleSelectOn: row].

	^aBoolean
		ifTrue: [self activateEditorAt: aPoint tabbed: false]
		ifFalse: [self enableRedraw. nil]!

clientFocusRectangle

	^self clientRectangle!

columnNamed: aString

	^self allColumns detect: [ :each | each name = aString]!

columnWithEditor: anEmbeddedEdit

	^self allColumns detect: [ :each | each editor == anEmbeddedEdit]!

commitOngoingEdit
	"If there is an active editor, then kill it nicely."

	self hasActiveEditor ifTrue: [self deactivateEditor; enableRedraw; invalidate].!

deactivateEditor

	"Private - Note that redraw is turned off to prevent flickering if the receiver gets focus.
	Clients of this method should ensure redraw is later reactivated"

	self disableRedraw.
	self hideActiveEditor!

drawFocusRect

	self drawFocusRect: self clientFocusRectangle.
	self propertyAt: #focusRectDrawn put: true!

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

fieldExitDown

	self requestDeactivateEditor ifFalse: [^0].

	self selectionByIndex < self list size ifTrue:
		[| row col |
		row := self selectionByIndex + 1.
		col := self activeColumnIndex.
		self 
			deactivateEditor;
			multSelectStack: (OrderedCollection with: row);
			selectionByIndex: self noSelection;
			selectionByIndex: row;
			activateEditorAt: (row@col) tabbed: false]
!

fieldExitNextTabbed: aBoolean

	| next |

	self requestDeactivateEditor ifFalse: [^0].

	next := self nextEditableCoords.
	self hasActiveEditor ifTrue: [self deactivateEditor].

	next isNil ifTrue: [^self enableRedraw; tabNext].

	self selectionByIndex: next x.		
	self activateEditorAt: next tabbed: aBoolean!

fieldExitPrevTabbed: aBoolean

	| nextCoords editor |

	self requestDeactivateEditor ifFalse: [^0].

	nextCoords := self prevEditableCoords.
	self hasActiveEditor ifTrue: [self deactivateEditor].

	nextCoords isNil ifTrue:
		[self enableRedraw.
		^self tabPrev].

	self selectionByIndex: nextCoords x.
	editor := self activateEditorAt: nextCoords tabbed: aBoolean.
	aBoolean ifFalse: [editor onCursoredLeft]!

fieldExitUp

	| row |

	self requestDeactivateEditor ifFalse: [^self].

	(row := self selectionByIndex - 1) > 0 ifTrue:
		[| col |
		col := self activeColumnIndex.
		self 
			deactivateEditor;
			multSelectStack: (OrderedCollection with: row);
			selectionByIndex: self noSelection;
			selectionByIndex: row;
			activateEditorAt: (row@col) tabbed: false]!

firstEditableColumn

	^self allColumns detect: [ :each | each isEditableWith: (self list at: self selectionByIndex)]!

firstEditableCoordsOnOrAfter: anInteger

	anInteger to: self list size do:
		[ :row || item |
		item := self list at: row.
		1 to: self allColumns size do:
			[ :col |
			((self columnAtIndex: col) isEditableWith: item) ifTrue: [^row@col]]].

	^nil!

handleCtrlMultSelectOn: anInteger

	"anInteger is the row clicked"

	| set |

	set := (self multSelectStack includes: anInteger) not.

	self selectIndex: anInteger set: set.
	self multSelectStack remove: anInteger ifAbsent: [].
	set ifTrue: [self multSelectStack addLast: anInteger]!

handleShiftMultSelectOn: anInteger

	"anInteger is the row clicked"

	| start newSelections |

	self multSelectStack isEmpty ifTrue: [^self handleSingleSelectOn: anInteger].

	start := self multSelectStack first.
	start < anInteger
		ifTrue: [newSelections := start to: anInteger]
		ifFalse: [newSelections := anInteger to: start].

	(self multSelectStack difference: newSelections) do:
		[ :unsetRow |
		self selectIndex: unsetRow set: false].

	newSelections do:
		[ :setRow |
		self selectIndex: setRow set: true].

	start < anInteger
		ifTrue: [self multSelectStack: newSelections asOrderedCollection]
		ifFalse: [self multSelectStack: newSelections asOrderedCollection reverse]!

handleSingleSelectOn: anInteger

	"anInteger is the row clicked"

	self selectionByIndex = anInteger ifFalse:
		[self 
			multSelectStack: (OrderedCollection with: anInteger);
			selectionByIndex: self noSelection;
			selectionByIndex: anInteger]!

hasActiveEditor

	^self activeColumn notNil!

hasColumnImage: anEmbeddedEdit

	"Additional offset needed for embedded editors with column images (except primary col)"

	| column |

	self hasColumnImages ifFalse: [^false].

	column := self columnWithEditor: anEmbeddedEdit.

	^(column ~~ self primaryColumn and: [column hasImageBlock])!

hasEditableColumn

	^self allColumns anySatisfy: [ :each | each isEditable]
!

hasEditableColumnInCurrentRow

	| current |

	current := self selection.

	^self allColumns anySatisfy: [ :each | each isEditableWith: current]
!

hasImageBlock

	^self getImageBlock notNil!

hasVirtualGridlines
	^hasVirtualGridlines ifNil: [hasVirtualGridlines := true]!

hasVirtualGridlines: anObject
	hasVirtualGridlines := anObject!

hideActiveEditor

	self activeEditor ifNotNil:
		[ :editor |
		editor hide. 
		self activeEditorCoords: nil]!

isMultiline

	^self rowHeight > 1!

isSelected: anObject

	^self selectionsByIndex includes: (self list identityIndexOf: anObject)!

itemIndex: anInteger hasFocus: aBoolean

	| anLvItem |

	anLvItem := LVITEM new.
	anLvItem stateMask: LVIS_FOCUSED.
	anLvItem dwState: aBoolean.
	self lvmSetItem: anInteger-1 state: anLvItem!

itemIndexWithFocus

	^(1 to: self itemCount) detect: [ :i | (self lvmGetItemState: (i - 1) mask: LVIS_FOCUSED) = 1] ifNone: [nil]!

itemIndexWithFocus: anInteger

	| anLvItem |

	anLvItem := LVITEM new.
	anLvItem stateMask: LVIS_FOCUSED.
	anLvItem dwState: 1.
	self lvmSetItem: anInteger-1 state: anLvItem!

lastEditableColumn

	^self allColumns reverse detect: [ :each | each isEditable]!

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

	^self isOpen ifTrue: [super lvmSetColumn: anLvColumn at: columnIndex]!

multSelectStack
	^multSelectStack ifNil: [multSelectStack := OrderedCollection new]!

multSelectStack: anObject
	multSelectStack := anObject!

nextEditableColumn

	(self activeColumnIndex + 1) to: self allColumns size do:
		[ :index || column |
		column := self allColumns at: index.
		column isEditable ifTrue: [^column]].

	^nil!

nextEditableCoords

	^self nextEditableCoordsInOrAfter: (self selectionByIndex@(self activeColumnIndex + 1))!

nextEditableCoordsInOrAfter: coords

	| row item | 

	row := coords x.
	item := self list at: row.
	coords y to: self allColumns size do:
		[ :col |
		((self columnAtIndex: col) isEditableWith: item) ifTrue: [^row@col]].

	^self firstEditableCoordsOnOrAfter: row + 1!

nmCustomDraw: pNMHDR

	"Override to trap or queue a (sub)item post-paint notification"

	| context columnIndex drawStage res |

	context := self customDrawContextClass fromAddress: pNMHDR.
	columnIndex := context iSubItem + 1.

	"Only needed to manually draw icons when multiline or the editor is active"
	(self isMultiline or: [(columnIndex >= 1) and: [columnIndex <= columns size and: [(self columnAtIndex: columnIndex) editor ifNil: [false] ifNotNil: [ :ed | ed hasVisibleStyle]]]]) ifFalse: [^super nmCustomDraw: pNMHDR].

	"Postdraw notification (see below)?"
	((drawStage := pNMHDR dwordAtOffset: 12) allMask: 65538 "CDDS_ITEMPOSTPAINT") ifTrue:
		[columnIndex > columns size ifTrue: [^CDRF_DODEFAULT].
		context rc width = 0 ifTrue: [^CDRF_DODEFAULT].
		context
			item: (self objectFromHandle: context itemHandle ifAbsent: [^CDRF_DODEFAULT]);
			view: self.	"The control attempts to draw stuff that isn't there on occassion"
		self postDraw: context columnIndex: columnIndex.
		^CDRF_DODEFAULT].

	res := super nmCustomDraw: pNMHDR.

	"Request postdraw notification - see above"
	^((drawStage allMask: CDDS_ITEMPREPAINT) and: [(res = CDRF_DODEFAULT)
		and: [(self hasColumnImages and: [drawStage allMask: CDDS_SUBITEM])
				or: [self hasColumnImages not and: [self hasImageBlock and: [columnIndex = 1]]]]])
					ifTrue: [16r10 "CDRF_NOTIFYPOSTPAINT"]
					ifFalse: [res]!

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


	"Image Request? Fake it for multiline (icons drawn manually, see nmCustomDraw:)"
	(mask allMask: LVIF_IMAGE) 
		ifTrue: 
			[| imgIdx |
			self isMultiline 
				ifTrue: [imgIdx := -1]
				ifFalse: 
					[imgIdx := ((column notNil and: [self hasColumnImages]) ifTrue: [column] ifFalse: [self]) 
								imageFromRow: rowObject.
					imgIdx notNil ifTrue: [lvitem image: imgIdx - 1]]].

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

onHeaderBeginTrack

	self hideActiveEditor!

onKillFocus

	self clearFocusRect.

	^super onKillFocus!

onLeftButtonDoubleClicked: aMouseEvent

	self onLeftButtonPressed: aMouseEvent.
	^super onLeftButtonDoubleClicked: aMouseEvent!

onLeftButtonPressed: aMouseEvent

	| point itemStruct itemCoords selectOnly |

	self requestDeactivateEditor ifFalse: [^0].

	point := aMouseEvent x@aMouseEvent y.
	itemStruct := self fullItemFromPoint: point.
	itemStruct iItem negative 
	ifTrue: 
		["Check for pseudo full row select"
		(self hasFullRowSelect or: [point x > self allColumns first width]) ifTrue: 
			[self clearFocusItem.
			^super onLeftButtonPressed: aMouseEvent].
		itemStruct := self fullItemFromPoint: (point + (self allColumns first width@0)).
		(itemStruct isNil or: [itemStruct iItem negative]) ifTrue: [^self].
		itemCoords := (itemStruct iItem @ itemStruct iSubItem) + (1@0)]
	ifFalse:
		[itemCoords := (itemStruct iItem @ itemStruct iSubItem) + (1@1)].

	self hasActiveEditor ifTrue: [self deactivateEditor].
	self presenter trigger: #leftButtonPressed: with: aMouseEvent.

	"If clicked the icon, then select only"
	selectOnly := (self lvmGetSubItemRect: (itemCoords - (1@1)) bounding: LVIR_ICON) containsPoint: point.

	^(self click: aMouseEvent activateEditor: selectOnly not at: itemCoords) 
		ifNil: [0]
		ifNotNil: [ :editor | SessionManager inputState queueDeferredAction: [aMouseEvent resendTo: editor]. 0]	!

onSelChanged: anObject

	self validateMultSelectStack.
	self primaryColumn onSelectionChanged.
	^super onSelChanged: anObject!

onSetFocus

	self hasSelection ifFalse: 
		[self 
			clearFocusItem;
			drawFocusRect].

	^super onSetFocus!

onValueChangedIn: aColumn

	aColumn updateValueIn: self selection.

	"attempt to ensure that changes are triggered off the list model"
	self model updateAtIndex: (self selectionByIndex)!

onViewOpened

	super onViewOpened.

	self headerControl when: #beginTrack send: #onHeaderBeginTrack to: self.

	self allColumns do: 
		[ :each | 
		each 
			createEditorIn: self;
			customDrawBlock: (MessageSend receiver: self selector: #drawSubItem: arguments: (Array with: nil))]!

postDraw: aContext columnIndex: anInteger

	((anInteger = 1 and: [self hasImageBlock]) or: [self hasColumnImages]) 
		ifTrue: [(self columnAtIndex: anInteger) customDrawIcon: aContext]
		ifFalse: [aContext canvas free]!

preTranslateKeyboardInput: aMSG

	| key |

	key := aMSG wParam.

	aMSG message = WM_KEYDOWN ifTrue:
		[(key = VK_RIGHT and: [self itemCount > 0]) ifTrue:
			[self hasSelection 
				ifTrue: [self activeColumn isNil ifTrue: 
						[self activateFirstEditor notNil ifTrue: [^true]]]
				ifFalse: [self selectionByIndex: 1. ^true]].

		self hasEditableColumn ifTrue:
			[| action |
			key = VK_TAB ifTrue:
				[Keyboard default isShiftDown
					ifTrue: [action := MessageSend receiver: self selector: #activateLastEditor]
					ifFalse: [action := MessageSend receiver: self selector: #activateFirstEditor]].
			action notNil ifTrue:
				[SessionManager inputState queueDeferredAction: action.
				^true]]].

	^super preTranslateKeyboardInput: aMSG!

prevEditableColumn

	((self activeColumnIndex) - 1) to: 1 by: -1 do:
		[ :index || column |
		column := self allColumns at: index.
		column isEditable ifTrue: [^column]].

	^nil!

prevEditableCoords

	^self prevEditableCoordsInOrBefore: (self selectionByIndex@(self activeColumnIndex - 1))!

prevEditableCoordsInOrBefore: coords

	| row item | 

	row := coords x.
	item := self list at: row.
	coords y to: 1 by: -1 do:
		[ :col |
		((self columnAtIndex: col) isEditableWith: item) ifTrue: [^row@col]].

	^self lastEditableCoordsOnOrBefore: row - 1!

requestDeactivateEditor

	^(self hasActiveEditor not or: [self activeEditor onRequestDeactivate])
		ifTrue: [true]
		ifFalse: [self activeEditor show; tabFocus. false]!

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
	rowHeight := anObject!

rowPixelHeight

	^(self rowHeight ifNil: [1]) = 1
		ifTrue: [super rowPixelHeight]
		ifFalse: [((self actualFont pixelSize + 2) * self rowHeight) truncated + 1]!

selectionByIndex

	^self multSelectStack isEmpty
		ifTrue: [super selectionByIndex]
		ifFalse: [self multSelectStack last]!

selectionByIndex: anInteger

	self multSelectStack: (OrderedCollection with: anInteger).
	^super selectionByIndex: anInteger!

selectionsByIndex: aCollectionOfIntegers

	"cancel any outstanding edit first"
	self
		commitOngoingEdit;
		basicSelectionsByIndex: aCollectionOfIntegers;
		multSelectStack: aCollectionOfIntegers asOrderedCollection;
		onSelChanged: nil!

setColumnIcon: anImage atIndex: anInteger

	"Only use to clear image - proper header sort images are set in sortOnColumn:"

	anImage isNil ifTrue: [self headerControl clearSortIconForColumnAtIndex: anInteger]!

smallImageExtent
	"Private - Answer the value of the receiver's 'smallImageExtent' instance variable."

	^smallImageExtent ifNil: [Icon smallExtent]!

smallImageExtent: anObject
	"Private - Set the value of the receiver's 'smallImageExtent' instance variable to the argument."

	smallImageExtent := anObject!

sortAscending: aBoolean onColumnIndex: anInteger

	| column |

	column := self columnAtIndex: anInteger.
	column isSortOrderInverted: aBoolean not.

	self 
		forgetLastClickedColumn;
		sortOnColumn: column;
		setColumnIcon: (column headerIcon: true) atIndex: anInteger.

	lastClickedColIndex := anInteger!

sortColumnIndex

	^lastClickedColIndex!

sortOnColumn: aListViewColumn

	self headerControl setSortIconForColumn: aListViewColumn.

	^super sortOnColumn: aListViewColumn!

stbSaveOn: anSTBOutFiler

	"If the receiver is unrealized (i.e. just exists in the spec of an object in the view composer),
	save as a plain object"

	handle isNil 
		ifTrue: [anSTBOutFiler saveObject: self]
		ifFalse: [super stbSaveOn: anSTBOutFiler]!

tabPrev

	| parent prev |
	parent := self parentView.
	[parent notNil and: [parent ~~ self class desktop and: [prev isNil]]] whileTrue: [
		prev := parent tabNextSiblingFrom: self forward: false.
		parent := parent parentView].
	prev isNil ifFalse: [prev tabFocus]!

validateMultSelectStack

	| shouldBe |

	shouldBe := self selectionsByIndex.

	((shouldBe size = 1 and: [self multSelectStack size = 1 and: [shouldBe first = self multSelectStack first]]) or: [shouldBe = self multSelectStack asSortedCollection asArray]) ifFalse:
		[self multSelectStack: shouldBe asOrderedCollection]!

wmHScroll: message wParam: wParam lParam: lParam 

	self hasActiveEditor ifTrue: [self deactivateEditor; enableRedraw].
	^super wmHScroll: message wParam: wParam lParam: lParam !

wmMouseWheel: message wParam: wParam lParam: lParam 

	self hasActiveEditor ifTrue: [self deactivateEditor; enableRedraw].
	^super wmMouseWheel: message wParam: wParam lParam: lParam !

wmPaint: message wParam: wParam lParam: lParam

	self clearFocusRect.

	^super wmPaint: message wParam: wParam lParam: lParam!

wmVScroll: message wParam: wParam lParam: lParam 

	self hasActiveEditor ifTrue: [self deactivateEditor; enableRedraw].
	^super wmVScroll: message wParam: wParam lParam: lParam ! !
!EditableListView categoriesFor: #activateEditorAt:tabbed:!helpers!public! !
!EditableListView categoriesFor: #activateEditorForColumn:!operations!public! !
!EditableListView categoriesFor: #activateEditorForColumnIndex:!operations!public! !
!EditableListView categoriesFor: #activateFirstEditor!operations!public! !
!EditableListView categoriesFor: #activateLastEditor!operations!public! !
!EditableListView categoriesFor: #activeColumn!accessing!public! !
!EditableListView categoriesFor: #activeColumnIndex!accessing!public! !
!EditableListView categoriesFor: #activeEditor!accessing!public! !
!EditableListView categoriesFor: #activeEditorCoords!accessing!private! !
!EditableListView categoriesFor: #activeEditorCoords:!accessing!private! !
!EditableListView categoriesFor: #activeEditorNeedsHighlight!public!testing! !
!EditableListView categoriesFor: #additionalHorzOffsetFor:!accessing!public! !
!EditableListView categoriesFor: #applyImageLists!image management!private! !
!EditableListView categoriesFor: #clearFocusItem!helpers!public! !
!EditableListView categoriesFor: #clearFocusRect!helpers!public! !
!EditableListView categoriesFor: #click:activateEditor:at:!helpers!private! !
!EditableListView categoriesFor: #clientFocusRectangle!helpers!public! !
!EditableListView categoriesFor: #columnNamed:!accessing!public! !
!EditableListView categoriesFor: #columnWithEditor:!accessing!public! !
!EditableListView categoriesFor: #commitOngoingEdit!operations!public! !
!EditableListView categoriesFor: #deactivateEditor!helpers!private! !
!EditableListView categoriesFor: #drawFocusRect!helpers!public! !
!EditableListView categoriesFor: #drawHorizontalGridlinesOn:from:to:by:!helpers!private! !
!EditableListView categoriesFor: #drawSubItem:!helpers!public! !
!EditableListView categoriesFor: #fieldExitDown!operations!public! !
!EditableListView categoriesFor: #fieldExitNextTabbed:!operations!public! !
!EditableListView categoriesFor: #fieldExitPrevTabbed:!operations!public! !
!EditableListView categoriesFor: #fieldExitUp!operations!public! !
!EditableListView categoriesFor: #firstEditableColumn!accessing!public! !
!EditableListView categoriesFor: #firstEditableCoordsOnOrAfter:!helpers!private! !
!EditableListView categoriesFor: #handleCtrlMultSelectOn:!helpers!private! !
!EditableListView categoriesFor: #handleShiftMultSelectOn:!helpers!private! !
!EditableListView categoriesFor: #handleSingleSelectOn:!helpers!private! !
!EditableListView categoriesFor: #hasActiveEditor!public!testing! !
!EditableListView categoriesFor: #hasColumnImage:!public!testing! !
!EditableListView categoriesFor: #hasEditableColumn!public!testing! !
!EditableListView categoriesFor: #hasEditableColumnInCurrentRow!public!testing! !
!EditableListView categoriesFor: #hasImageBlock!public!testing! !
!EditableListView categoriesFor: #hasVirtualGridlines!accessing!private! !
!EditableListView categoriesFor: #hasVirtualGridlines:!accessing!private! !
!EditableListView categoriesFor: #hideActiveEditor!helpers!public! !
!EditableListView categoriesFor: #isMultiline!public!testing! !
!EditableListView categoriesFor: #isSelected:!public!testing! !
!EditableListView categoriesFor: #itemIndex:hasFocus:!helpers!public! !
!EditableListView categoriesFor: #itemIndexWithFocus!accessing!public! !
!EditableListView categoriesFor: #itemIndexWithFocus:!accessing!public! !
!EditableListView categoriesFor: #lastEditableColumn!accessing!public! !
!EditableListView categoriesFor: #lastEditableCoordsOnOrBefore:!helpers!private! !
!EditableListView categoriesFor: #lvmSetColumn:at:!columns!private! !
!EditableListView categoriesFor: #multSelectStack!accessing!private! !
!EditableListView categoriesFor: #multSelectStack:!accessing!private! !
!EditableListView categoriesFor: #nextEditableColumn!accessing!public! !
!EditableListView categoriesFor: #nextEditableCoords!helpers!private! !
!EditableListView categoriesFor: #nextEditableCoordsInOrAfter:!helpers!private! !
!EditableListView categoriesFor: #nmCustomDraw:!event handling!public! !
!EditableListView categoriesFor: #onDisplayDetailsRequired:!event handling!private! !
!EditableListView categoriesFor: #onHeaderBeginTrack!event handling!public! !
!EditableListView categoriesFor: #onKillFocus!event handling!public! !
!EditableListView categoriesFor: #onLeftButtonDoubleClicked:!event handling!public! !
!EditableListView categoriesFor: #onLeftButtonPressed:!event handling!public! !
!EditableListView categoriesFor: #onSelChanged:!event handling!public! !
!EditableListView categoriesFor: #onSetFocus!event handling!public! !
!EditableListView categoriesFor: #onValueChangedIn:!event handling!public! !
!EditableListView categoriesFor: #onViewOpened!event handling!public! !
!EditableListView categoriesFor: #postDraw:columnIndex:!helpers!private! !
!EditableListView categoriesFor: #preTranslateKeyboardInput:!event handling!public! !
!EditableListView categoriesFor: #prevEditableColumn!accessing!public! !
!EditableListView categoriesFor: #prevEditableCoords!helpers!private! !
!EditableListView categoriesFor: #prevEditableCoordsInOrBefore:!helpers!private! !
!EditableListView categoriesFor: #requestDeactivateEditor!helpers!private! !
!EditableListView categoriesFor: #rowBackcolor!accessing!private! !
!EditableListView categoriesFor: #rowBackcolor:!accessing!private! !
!EditableListView categoriesFor: #rowForecolor!accessing!private! !
!EditableListView categoriesFor: #rowForecolor:!accessing!private! !
!EditableListView categoriesFor: #rowHeight!accessing!private! !
!EditableListView categoriesFor: #rowHeight:!accessing!private! !
!EditableListView categoriesFor: #rowPixelHeight!accessing!public! !
!EditableListView categoriesFor: #selectionByIndex!public!selection! !
!EditableListView categoriesFor: #selectionByIndex:!public!selection! !
!EditableListView categoriesFor: #selectionsByIndex:!public!selection! !
!EditableListView categoriesFor: #setColumnIcon:atIndex:!helpers!public! !
!EditableListView categoriesFor: #smallImageExtent!accessing!public! !
!EditableListView categoriesFor: #smallImageExtent:!accessing!public! !
!EditableListView categoriesFor: #sortAscending:onColumnIndex:!columns!private! !
!EditableListView categoriesFor: #sortColumnIndex!columns!private! !
!EditableListView categoriesFor: #sortOnColumn:!helpers!public! !
!EditableListView categoriesFor: #stbSaveOn:!binary filing!public! !
!EditableListView categoriesFor: #tabPrev!operations!public! !
!EditableListView categoriesFor: #validateMultSelectStack!helpers!public! !
!EditableListView categoriesFor: #wmHScroll:wParam:lParam:!event handling!public! !
!EditableListView categoriesFor: #wmMouseWheel:wParam:lParam:!event handling!public! !
!EditableListView categoriesFor: #wmPaint:wParam:lParam:!event handling!public! !
!EditableListView categoriesFor: #wmVScroll:wParam:lParam:!event handling!public! !

!EditableListView class methodsFor!

columnClass
	"Answer the class of object used to represent the columns of the receiver."

	^EditableListViewColumn!

stbConvert: instVarArray fromVersion: verInteger

	| origInstVars instVars newArray offset |

	origInstVars := super stbConvert: instVarArray fromVersion: verInteger.
	instVars := origInstVars.
	offset := 0.

	verInteger < 12 ifTrue: 
		[| new |
		"Added rowHeight"
		new := Array new: instVars size + 1.
		new replaceFrom: 1 to: (##(self) instSize - 3) with: instVars startingAt: 1.
		new at: (##(self) instSize - 2) put: 1.
		instVars := new.
		offset := offset + 1].

	verInteger < 14 ifTrue:
		[| new |
		"Added _spares"
		new := Array new: instVars size + 2.
		new replaceFrom: 1 to: (##(self) instSize - 2) with: instVars startingAt: 1.
		new 
			at: ##(self) instSize put: nil;
			at: (##(self) instSize - 1) put: nil.

		offset := offset + 2.

		"Copy inst vars of any subclass"
		self instSize > ##(self) instSize ifTrue:
			[new 
				replaceFrom: (##(self) instSize + 1) 
				to: new size 
				with: origInstVars 
				startingAt: (##(self) instSize - offset) + 1].

		instVars := new].

	^instVars!

stbVersion

	"12 - added rowHeight
	14 - added _spares"

	^14! !
!EditableListView class categoriesFor: #columnClass!constants!private! !
!EditableListView class categoriesFor: #stbConvert:fromVersion:!constants!public! !
!EditableListView class categoriesFor: #stbVersion!constants!private! !

