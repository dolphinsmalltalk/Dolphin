"Filed out from Dolphin Smalltalk"!

ListViewColumn subclass: #EditableListViewColumn
	instanceVariableNames: 'isEditable setContentsBlock editor forecolor backcolor preDrawBlock getSortContentsBlock isEditableBlock events cachedParent isValidContentsBlock'
	classVariableNames: ''
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!

EditableListViewColumn guid: (GUID fromString: '{787a1ff5-1809-4381-ab64-22f338ecaa37}')!

EditableListViewColumn comment: ''!

!EditableListViewColumn categoriesForClass!Unclassified! !

!EditableListViewColumn methodsFor!

_imageFromRow: anObject

	self parent hasColumnImages ifFalse: [^self parent imageFromRow: anObject].

	"Allow a getImageBlock to access the object as well as the content"
	(self getImageBlock notNil and: [self getImageBlock ~~ IconicListAbstract and: [self getImageBlock argumentCount = 2]]) ifTrue: [^self getImageBlock value: (self contentFromRow: anObject) value: anObject].

	^super imageFromRow: anObject!

activate

	self parent activateEditorForColumn: self!

backcolor
	^backcolor!

backcolor: anObject
	backcolor := anObject!

cachedParent
	^cachedParent!

cachedParent: anELV
	cachedParent := anELV!

contentFromRow: item

	"Overriden to respect isValidContentsBlock"

	^(self isValidContentsBlock isNil or: [self isValidContentsBlock value: item])
		ifTrue: [super contentFromRow: item]
		ifFalse: [nil]!

createEditorIn: aView

	self hasEditor ifTrue: [self editor createEmbeddedIn: aView].

	self isEditable ifTrue: 
		[self editor model: 
			(ValueHolder new
				when: #valueChanged send: #onValueChangedIn: to: aView with: self;
				yourself)]!

customDrawIcon: aContext

	| image iSubItem imageRect canvas origin iconSize |

	self hasColumnImage ifFalse: [^self].

	image := self imageFromRow: aContext item.

	iSubItem := aContext iSubItem.
	imageRect := aContext view 
		lvmGetSubItemRect: aContext dwItemSpec
		subitem: iSubItem 
		bounding: LVIR_ICON.

	imageRect right: (imageRect right + self parent columnImagePadding).

	canvas := aContext canvas.

	"Need to draw custom background color for the primary column"
	iSubItem = 0 ifTrue: 
		[self displayBackcolor ifNotNil: [ :col | (self parent isDisplayContextSelectedOrHot: aContext) ifFalse: [canvas erase: imageRect color: col]]].

	image isNil ifTrue: [^self].

	iconSize := aContext metrics smallIconExtent.
	origin := imageRect origin + ((imageRect extent - iconSize) // 2) + (self parent columnImagePadding@0).
	(self parent imageManager imageListWithExtent: iconSize) draw: image on: canvas at: origin flags: 0.

	canvas free!

displayBackcolor

	^self parent rowBackcolor ifNil: 
		[self backcolor ifNil: 
			[(self parent backcolor ifNil: [Color default]) isDefault
				ifTrue: [nil]
				ifFalse: [self parent backcolor]]]!

displayForecolor

	^(self hasEditor not or: [self editor isEnabled])
	ifTrue: 
		[self parent rowForecolor ifNil: 
			[self forecolor ifNil: 
				[self parent forecolor ifNil:
					[nil]]]]
	ifFalse: 
		[Color grayText]!

displayOn: aStream

	super displayOn: aStream.
	self hasEditor ifTrue: [aStream space; nextPutAll: self editor class name]!

dropDownMenu: aMenu

	self columnHeader 
		isDropDownStyle: aMenu notNil;
		dropDownMenu: aMenu!

editor
	^editor!

editor: anObject
	editor := anObject!

forecolor
	^forecolor!

forecolor: anObject
	forecolor := anObject!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

getSortContentsBlock
	^getSortContentsBlock!

getSortContentsBlock: anObject
	getSortContentsBlock := anObject!

hasColumnImage

	^(self parent hasColumnImages and: [self hasImageBlock]) or: [self parent primaryColumn == self and: [self parent hasRowImage]]!

hasEditor

	^self editor notNil!

hasHotTracking

	^self hasEditor and: [self editor hasEmbeddedHotTracking]!

hasImageBlock

	^self getImageBlock notNil!

hasPreDrawBlock

	^self preDrawBlock notNil!

haveCheckAllHeader

	"Configure the receiver to have a checkbox in its column header which automatically checkes/unchecks all checkboxes in this column.
	ASSERT: the receiver has a checkbox editor"

	self parent headerControl isCheckBoxesStyle: true.

	self columnHeader 
		isCheckStyle: true;
		isChecked: false;
		when: #isChecked: send: #onColumnHeaderChecked: to: self
	!

hide

	self isVisible ifFalse: [^self].

	self cachedParent: self parent.
	self parent removeColumn: self!

imageFromRow: anObject

	"Allow an image to be returned directly"
	^(self _imageFromRow: anObject) ifNotNil: 
		[ :imageOrInteger |
		imageOrInteger isInteger 
			ifTrue: [imageOrInteger]
			ifFalse: [imageOrInteger imageIndex]]!

infoTip

	^self getInfoTipBlock ifNotNil: [ :blk | [blk valueWithArguments: (Array new: blk argumentCount)] on: MessageNotUnderstood do: [ :exc | exc return: nil]]!

infoTip: aString

	^aString isEmpty
		ifTrue: [self getInfoTipBlock: nil]
		ifFalse: [self getInfoTipBlock: (MessageSend receiver: aString selector: #yourself)]!

infoTipFromRow: item withPrefix: prefixText

	"Overridden to support 3-arg block - third arg is the item itself; allows info tip based on an attribute other than that displayed in the column"

	^(getInfoTipBlock notNil and: [getInfoTipBlock argumentCount = 3])
		ifTrue: [getInfoTipBlock value: (self contentFromRow: item) value: prefixText value: item]
		ifFalse: [super infoTipFromRow: item withPrefix: prefixText]!

infoTipPrefixTextFor: anItem on: aCanvasHandle
	"Calculate and return the prefix string argument for a 2-arg getInfoTipBlock (i.e. the receiver's text if too large for its width, or the empty string otherwise).
	Needed since custom drawn columns don't produce standard ListView tooltip notifications"

	| string size |
	"Only appropriate for text-type columns"
	(self hasEditor not or: [(self editor isKindOf: TextEdit) or: [self editor isKindOf: ComboBox]])
		ifFalse: [^''].
	string := (self textFromRow: anItem) asUtf16String.
	size := POINTL new.
	(GDILibrary default
		getTextExtentPoint32: aCanvasHandle
		lpString: string
		c: string size
		lpSize: size asParameter)
			ifFalse: 
				["Absorb the error"
				^''].
	^size asPoint x > self width ifTrue: [string] ifFalse: ['']!

initialize
	"Private - Initialize the state of the receiever."

	super initialize.
	self
		isEditable: true;
		setContentsBlock: nil;
		editor: EmbeddedTextEdit new!

invalidate

	self parent invalidateRect: self rectangle
!

isEditable
	^isEditable!

isEditable: anObject
	isEditable := anObject!

isEditableBlock
	^isEditableBlock!

isEditableBlock: anObject
	isEditableBlock := anObject!

isEditableWith: anObject

	^self isEditable and: 
		[(self isValidContentsBlock isNil or: [self isValidContentsBlock value: anObject]) and: 
			[self isEditableBlock isNil or: [self isEditableBlock value: anObject]]]!

isValidContentsBlock 

	^isValidContentsBlock!

isValidContentsBlock: aBlock

	isValidContentsBlock := aBlock!

isVisible

	^self parent notNil!

onColumnHeaderChecked: aBoolean

	self parent list do: [ :row | (self isEditableWith: row) ifTrue: [self updateValue: aBoolean in: row]].
	self parent activeColumn == self ifTrue: [self editor embeddedValue: aBoolean].
	self parent invalidate
!

ownerDraw: aContext

	| itemRect canvas brush bcolor fcolor iSubItem isPrimaryColumn hasColumnImage drawVal |

	"Active editor? It will handle all drawing itself"
	(self hasEditor and: [self editor hasVisibleStyle and: [aContext item == self parent selectionOrNil]]) ifTrue: 
		["...however, need to ensure any areas not drawn by the editor are cleared"
		self parent activeEditorNeedsHighlight ifTrue: [aContext canvas erase: self parent activeEditorCellRect color: self parent activeEditorHighlightColor].
		"...and, if the receiver has an icon, need to draw it manually"
		self parent postDraw: aContext columnIndex: self index. "Implicit canvas free"
		^true].

	"Nothing to do?"
	aContext rc width = 0 ifTrue: [^false].

	"Reset canvas/context to defaults otherwise per-column changes are carried over from previous columns"
	aContext
		forecolor: (self displayForecolor ifNil: [Color default]);
		backcolor: (self displayBackcolor ifNil: [Color default]).

	canvas := aContext canvas.
	self hasPreDrawBlock ifTrue: 
		[self preDrawBlock value: aContext.
		aContext applyFont].

	iSubItem := aContext iSubItem. 
	isPrimaryColumn := iSubItem = 0.
	hasColumnImage := self hasColumnImage.

	"aContext boundingRectangle unreliable"
	itemRect := aContext view 
				lvmGetSubItemRect: aContext dwItemSpec 
				subitem: iSubItem
				bounding: (isPrimaryColumn ifTrue: [LVIR_LABEL] ifFalse: [LVIR_BOUNDS]).

	"Handle custom colors vs. selection/hot highlighting"
	(self parent shouldOwnerDrawSelectionHighlight and: [self parent isDisplayContextSelectedOrHot: aContext])
	ifTrue: 
		[self parent hasFocus
		ifTrue: 
			[fcolor := Color highlightText.
			bcolor := Color highlight]
		ifFalse:
			[fcolor := Color windowText.
			bcolor := Color face3d]]
	ifFalse:
		[(aContext forecolor = Color default or: [aContext forecolor = Color windowText]) ifFalse: [fcolor := aContext forecolor].
		(aContext backcolor = Color default or: [aContext backcolor = Color window]) ifFalse: [bcolor := aContext backcolor]].

	"Suppress custom colors where the item is selected/hot and we do not handle displaying highlights ourself"
	(bcolor notNil and: [(self parent isDisplayContextSelectedOrHot: aContext) not or: [self parent shouldOwnerDrawSelectionHighlight]]) ifTrue: 
		[brush := Brush color: bcolor.
		canvas fillRectangle: itemRect brush: brush.
		brush free].

	(isValidContentsBlock isNil or: [isValidContentsBlock value: aContext item]) ifFalse: [^true].

	"No editor / no owner draw - nothing more to do here"
	(self hasEditor and: [self editor isDisplayOwnerDrawn or: [hasColumnImage]]) ifFalse: [^false].

	hasColumnImage ifTrue: 
		["Inset by the icon width"
		itemRect left: ((itemRect left + self parent columnImageSpacing) min: itemRect right).
		"Take off default icon spacing added to primary columnn (we're displaying this ourselves)"
		isPrimaryColumn ifTrue: [itemRect left: (itemRect left - self parent smallImageExtent x)]].

	"Bug in earlier versions - did not check getTextBlock, but using it in all cases screws up some widgets. Hence a test (unfortunately)"
	self getContentsBlock
	ifNil: 
		[drawVal := nil]
	ifNotNil: 
		[ :gcb | 
		drawVal := gcb value: aContext item.
		self editor expectsText ifTrue: [drawVal := self getTextBlock value: drawVal]].

	self editor 
		display: drawVal 
		in: itemRect 
		on: canvas
		forecolor: fcolor
		backcolor: bcolor
		editable: (self isEditableWith: aContext item)
		hot: (self parent hotItemAndColumn ifNil: [false] ifNotNil: [ :pt | (self parent columnAtIndex: pt y) == self and: [pt x == aContext itemHandle]]).

	hasColumnImage ifTrue: [self customDrawIcon: aContext].

	^true!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original. Answer the receiver."

	super postCopy.
	events := nil.
	^self!

preDrawBlock
	^preDrawBlock!

preDrawBlock: anObject
	preDrawBlock := anObject!

rectangle

	| zeroIndex itemRectangle iconRectangle |

	(self isVisible and: [self parent itemCount > 0]) ifFalse: [^##(0@0 corner: 0@0)].

	zeroIndex := self index - 1.
	itemRectangle := self parent lvmGetSubItemRect: 0 subitem: zeroIndex bounding: LVIR_LABEL.

	"The primary column excludes the row icon (if any) We want the full box"
	(self == self parent primaryColumn and: [self hasColumnImage]) ifTrue: 
		[iconRectangle := self parent lvmGetSubItemRect: 0 subitem: zeroIndex bounding: LVIR_ICON.
		itemRectangle left: iconRectangle left].

	^(itemRectangle left@self parent rectangle top) extent: (itemRectangle width@self parent height)!

rowSortBlock

	| sortBlock |

	self isSortable ifFalse: [^nil].

	sortBlock := self safeSortBlock.

	^self isSortOrderInverted 
		ifTrue: [	[:a :b | sortBlock value: (self sortContentFromRow: b) value: (self sortContentFromRow: a)]	]
		ifFalse: [	[:a :b | sortBlock value: (self sortContentFromRow: a) value: (self sortContentFromRow: b)]	]
!

safeSortBlock

	"If no custom sorting has been configured use a sort block which is tolerant of nils and Booleans.
	This allows columns containing these values to be sorted sensibly without special handling"

	(getSortContentsBlock isNil and: [getSortValueBlock = self defaultSortBlock]) ifFalse: [^getSortValueBlock].

	"Sort order is 
	 - nil
	 - false
	 - true
	 - everything else"

	^[ :a :b |
	a isNil or: 
		[(a == false and: [b notNil]) or: 
			[(a == true and: [b notNil and: [b ~~ false]]) or: 
				[b notNil and: [b ~~ false and: [b ~~ true and: [a <= b]]]]]]]!

setContentsBlock

	"setContentsBlock stores a 2-arg block which is evaluated with a list item 
	and an updated value (as returned by the editor) to set the new value in a list"

	^setContentsBlock!

setContentsBlock: anObject

	"setContentsBlock stores a 2-arg block which is evaluated with a list item 
	and an updated value (as returned by the editor) to set the new value in a list"

	setContentsBlock := anObject!

setEditorValueFrom: anObject

	self editor embeddedValue: (self getContentsBlock ifNotNil: [ :gcb | gcb value: anObject])!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

show

	self isVisible ifTrue: [^self].

	self parent: self cachedParent.
	self parent showColumn: self!

showAfter: anotherColumn

	self isVisible ifTrue: [^self].

	self parent: self cachedParent.
	self parent showColumn: self after: anotherColumn!

showIn: anEditableListView

	self showIn: anEditableListView after: anEditableListView allColumns last!

showIn: anEditableListView after: anotherColumn

	self isVisible ifTrue: [^self].

	self cachedParent: anEditableListView.
	self showAfter: anotherColumn!

sortAscending

	"Ask the ELV to sort itself in ascending order using this column's sort criteria"

	self sortAscending: true!

sortAscending: aBoolean

	"Ask the ELV to sort itself using this column's sort criteria"

	self isSortOrderInverted: aBoolean not.
	self parent sortOnColumn: self!

sortContentFromRow: item

	"Return the row attribute to use for sorting.
	ELV adds the concept of the getSortContentsBlock which allows items to be sorted by a column using a different attribute to that used by the column"

	^getSortContentsBlock isNil
		ifTrue: [self contentFromRow: item]
		ifFalse: [getSortContentsBlock value: item]!

sortDescending

	"Ask the ELV to sort itself in descending order using this column's sort criteria"

	self sortAscending: false!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the local events collection
	is NOT saved to the filer"

	anSTBOutFiler override: events with: nil.
	super stbSaveOn: anSTBOutFiler.!

updateValue: aValue in: anObject

	self setContentsBlock value: anObject value: aValue.
	self trigger: #itemUpdated: with: anObject!

updateValueIn: anObject

	self updateValue: self editor embeddedValue in: anObject! !

!EditableListViewColumn categoriesForMethods!
_imageFromRow:!drawing!private! !
activate!operations!public! !
backcolor!accessing!public! !
backcolor:!accessing!public! !
cachedParent!accessing!private! !
cachedParent:!accessing!private! !
contentFromRow:!accessing!public! !
createEditorIn:!initialize/release!private! !
customDrawIcon:!drawing!public! !
displayBackcolor!drawing!private! !
displayForecolor!drawing!private! !
displayOn:!displaying!private! !
dropDownMenu:!accessing!public! !
editor!accessing!public! !
editor:!accessing!public! !
forecolor!accessing!public! !
forecolor:!accessing!public! !
getEvents!events!private! !
getSortContentsBlock!accessing!public! !
getSortContentsBlock:!accessing!public! !
hasColumnImage!public!testing! !
hasEditor!public!testing! !
hasHotTracking!public!testing! !
hasImageBlock!public!testing! !
hasPreDrawBlock!public!testing! !
haveCheckAllHeader!initialize/release!public! !
hide!operations!public! !
imageFromRow:!public!testing! !
infoTip!accessing!public! !
infoTip:!accessing!public! !
infoTipFromRow:withPrefix:!adapters!private! !
infoTipPrefixTextFor:on:!accessing!public! !
initialize!initialize/release!private! !
invalidate!operations!public! !
isEditable!accessing!public! !
isEditable:!accessing!public! !
isEditableBlock!accessing!public! !
isEditableBlock:!accessing!public! !
isEditableWith:!public!testing! !
isValidContentsBlock!accessing!public! !
isValidContentsBlock:!accessing!public! !
isVisible!public!testing! !
onColumnHeaderChecked:!event handling!private! !
ownerDraw:!drawing!public! !
postCopy!copying!public! !
preDrawBlock!accessing!public! !
preDrawBlock:!accessing!public! !
rectangle!accessing!public! !
rowSortBlock!private!sorting! !
safeSortBlock!private!sorting! !
setContentsBlock!accessing!public! !
setContentsBlock:!accessing!public! !
setEditorValueFrom:!operations!private! !
setEvents:!events!private! !
show!operations!public! !
showAfter:!operations!public! !
showIn:!operations!public! !
showIn:after:!operations!public! !
sortAscending!public!sorting! !
sortAscending:!public!sorting! !
sortContentFromRow:!private!sorting! !
sortDescending!public!sorting! !
stbSaveOn:!binary filing!public! !
updateValue:in:!operations!private! !
updateValueIn:!operations!private! !
!

!EditableListViewColumn class methodsFor!

stbVersion

	"12: Added isEditableBlock
	14: Added cachedWidth and cachedIndex
	15: Added isValidContentsBlock"

	^15! !

!EditableListViewColumn class categoriesForMethods!
stbVersion!binary filing!public! !
!

