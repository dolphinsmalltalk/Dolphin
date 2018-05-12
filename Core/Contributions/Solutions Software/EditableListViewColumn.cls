"Filed out from Dolphin Smalltalk 7"!

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

	| image imageRect canvas origin |

	image := self imageFromRow: aContext item.
	image isNil ifTrue: [^self].

	imageRect := aContext view 
		lvmGetSubItemRect: (aContext dwItemSpec@aContext iSubItem) 
		bounding: LVIR_ICON.

	imageRect := imageRect expandedBy: (self parent columnImagePadding * 2)@0.

	canvas := aContext canvas.

	self displayBackcolor ifNotNil: 
		[ :col |
		(self parent isDisplayContextSelectedOrHot: aContext) ifFalse: [canvas erase: imageRect color: col]].

	image isInteger
	ifTrue:
		["Regular ListView image index behavior"
		origin := imageRect origin + ((imageRect extent - Icon smallExtent) // 2) + (self parent columnImagePadding@0).
		(self parent imageManager imageListWithExtent: Icon smallExtent) 
			draw: image
			on: canvas
			at: origin
			flags: 0]
	ifFalse:
		["Actual Icon"
		origin := imageRect origin + ((imageRect extent - image extent) // 2) + (self parent columnImagePadding@0).
		image drawOn: canvas at: origin extent: image extent].

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

ownerDraw: aContext

	| itemRect canvas brush bcolor fcolor hasColumnImage drawVal |

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
	canvas := aContext canvas.
	canvas font: self parent actualFont.
	aContext
		forecolor: (self displayForecolor ifNil: [Color default]);
		backcolor: (self displayBackcolor ifNil: [Color default]).

	self hasPreDrawBlock ifTrue: 
		[aContext font: canvas font copy.
		self preDrawBlock value: aContext.
		aContext applyFont].

	hasColumnImage := self hasColumnImage.

	"No editor = no owner draw = per-column icon drawn in slightly different place - discuss"
	(self hasEditor and: [self editor isDisplayOwnerDrawn or: [hasColumnImage]]) ifFalse: [^false].

	"aContext boundingRectangle unreliable"
	itemRect := aContext view 
				lvmGetSubItemRect: (aContext dwItemSpec@aContext iSubItem) 
				bounding: LVIR_LABEL.

	hasColumnImage ifTrue: 
		[itemRect left: ((itemRect left + self parent columnImageSpacing) min: itemRect right).
		"Take off default icon spacing added to primary columnn (we're displaying this ourselves)"
		self == self parent primaryColumn ifTrue: [itemRect left: (itemRect left - self parent smallImageExtent x)]].

	"Handle custom colors vs. selection/hot highlighting"
	(self parent isDisplayContextSelectedOrHot: aContext)
	ifTrue: 
		[self parent shouldOwnerDrawSelectionHighlight ifTrue:
			[self parent hasFocus
			ifTrue: 
				[fcolor := Color highlightText.
				bcolor := Color highlight]
			ifFalse:
				[fcolor := Color windowText.
				bcolor := Color face3d]]]
	ifFalse:
		[fcolor := self displayForecolor.
		bcolor := self displayBackcolor].

	(aContext forecolor = Color default or: [aContext forecolor = Color windowText]) ifFalse: [fcolor := aContext forecolor].
	(aContext backcolor = Color default or: [aContext backcolor = Color window]) ifFalse: [bcolor := aContext backcolor].

	bcolor isNil ifFalse: 
		[brush := Brush color: bcolor.
		"Inset is to match what ListView does with its own drawn cells"
		canvas fillRectangle: (itemRect insetCornerBy: 2@0) brush: brush.
		brush free].

	(isValidContentsBlock isNil or: [isValidContentsBlock value: aContext item]) ifFalse: [^true].

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

	| zeroIndex itemRectangle |

	self isVisible ifFalse: [^##(0@0 corner: 0@0)].

	zeroIndex := self index - 1.
	itemRectangle := self parent lvmGetSubItemRect: (0@zeroIndex) bounding: LVIR_LABEL.

	"In row image mode, the first column excludes the row icon. We want the full box"
	(zeroIndex = 0 and: [self parent hasRowImage]) ifTrue: [itemRectangle left: (itemRectangle left - parent smallImageExtent x)].

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

updateValueIn: anObject

	self setContentsBlock value: anObject value: self editor embeddedValue.
	self trigger: #itemUpdated: with: anObject! !
!EditableListViewColumn categoriesFor: #_imageFromRow:!drawing!private! !
!EditableListViewColumn categoriesFor: #activate!operations!public! !
!EditableListViewColumn categoriesFor: #backcolor!accessing!public! !
!EditableListViewColumn categoriesFor: #backcolor:!accessing!public! !
!EditableListViewColumn categoriesFor: #cachedParent!accessing!private! !
!EditableListViewColumn categoriesFor: #cachedParent:!accessing!private! !
!EditableListViewColumn categoriesFor: #contentFromRow:!accessing!public! !
!EditableListViewColumn categoriesFor: #createEditorIn:!initialize/release!private! !
!EditableListViewColumn categoriesFor: #customDrawIcon:!drawing!public! !
!EditableListViewColumn categoriesFor: #displayBackcolor!drawing!private! !
!EditableListViewColumn categoriesFor: #displayForecolor!drawing!private! !
!EditableListViewColumn categoriesFor: #displayOn:!displaying!private! !
!EditableListViewColumn categoriesFor: #editor!accessing!public! !
!EditableListViewColumn categoriesFor: #editor:!accessing!public! !
!EditableListViewColumn categoriesFor: #forecolor!accessing!public! !
!EditableListViewColumn categoriesFor: #forecolor:!accessing!public! !
!EditableListViewColumn categoriesFor: #getEvents!events!private! !
!EditableListViewColumn categoriesFor: #getSortContentsBlock!accessing!public! !
!EditableListViewColumn categoriesFor: #getSortContentsBlock:!accessing!public! !
!EditableListViewColumn categoriesFor: #hasColumnImage!public!testing! !
!EditableListViewColumn categoriesFor: #hasEditor!public!testing! !
!EditableListViewColumn categoriesFor: #hasHotTracking!public!testing! !
!EditableListViewColumn categoriesFor: #hasImageBlock!public!testing! !
!EditableListViewColumn categoriesFor: #hasPreDrawBlock!public!testing! !
!EditableListViewColumn categoriesFor: #hide!operations!public! !
!EditableListViewColumn categoriesFor: #imageFromRow:!public!testing! !
!EditableListViewColumn categoriesFor: #infoTip!accessing!public! !
!EditableListViewColumn categoriesFor: #infoTip:!accessing!public! !
!EditableListViewColumn categoriesFor: #infoTipFromRow:withPrefix:!adapters!private! !
!EditableListViewColumn categoriesFor: #infoTipPrefixTextFor:on:!accessing!public! !
!EditableListViewColumn categoriesFor: #initialize!initialize/release!private! !
!EditableListViewColumn categoriesFor: #invalidate!operations!public! !
!EditableListViewColumn categoriesFor: #isEditable!accessing!public! !
!EditableListViewColumn categoriesFor: #isEditable:!accessing!public! !
!EditableListViewColumn categoriesFor: #isEditableBlock!accessing!public! !
!EditableListViewColumn categoriesFor: #isEditableBlock:!accessing!public! !
!EditableListViewColumn categoriesFor: #isEditableWith:!public!testing! !
!EditableListViewColumn categoriesFor: #isValidContentsBlock!accessing!public! !
!EditableListViewColumn categoriesFor: #isValidContentsBlock:!accessing!public! !
!EditableListViewColumn categoriesFor: #isVisible!public!testing! !
!EditableListViewColumn categoriesFor: #ownerDraw:!drawing!public! !
!EditableListViewColumn categoriesFor: #postCopy!copying!public! !
!EditableListViewColumn categoriesFor: #preDrawBlock!accessing!public! !
!EditableListViewColumn categoriesFor: #preDrawBlock:!accessing!public! !
!EditableListViewColumn categoriesFor: #rectangle!accessing!public! !
!EditableListViewColumn categoriesFor: #rowSortBlock!private!sorting! !
!EditableListViewColumn categoriesFor: #safeSortBlock!private!sorting! !
!EditableListViewColumn categoriesFor: #setContentsBlock!accessing!public! !
!EditableListViewColumn categoriesFor: #setContentsBlock:!accessing!public! !
!EditableListViewColumn categoriesFor: #setEditorValueFrom:!operations!private! !
!EditableListViewColumn categoriesFor: #setEvents:!events!private! !
!EditableListViewColumn categoriesFor: #show!operations!public! !
!EditableListViewColumn categoriesFor: #showAfter:!operations!public! !
!EditableListViewColumn categoriesFor: #showIn:!operations!public! !
!EditableListViewColumn categoriesFor: #showIn:after:!operations!public! !
!EditableListViewColumn categoriesFor: #sortAscending!public!sorting! !
!EditableListViewColumn categoriesFor: #sortAscending:!public!sorting! !
!EditableListViewColumn categoriesFor: #sortContentFromRow:!private!sorting! !
!EditableListViewColumn categoriesFor: #sortDescending!public!sorting! !
!EditableListViewColumn categoriesFor: #stbSaveOn:!binary filing!public! !
!EditableListViewColumn categoriesFor: #updateValueIn:!operations!private! !

!EditableListViewColumn class methodsFor!

stbVersion

	"12: Added isEditableBlock
	14: Added cachedWidth and cachedIndex
	15: Added isValidContentsBlock"

	^15! !
!EditableListViewColumn class categoriesFor: #stbVersion!binary filing!public! !

