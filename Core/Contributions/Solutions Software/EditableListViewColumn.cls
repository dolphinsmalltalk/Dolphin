"Filed out from Dolphin Smalltalk X6.1"!

ListViewColumn subclass: #EditableListViewColumn
	instanceVariableNames: 'isEditable setContentsBlock editor forecolor backcolor preDrawBlock getSortContentsBlock isEditableBlock cachedWidth cachedIndex'
	classVariableNames: ''
	poolDictionaries: 'CommCtrlConstants'
	classInstanceVariableNames: ''!
EditableListViewColumn guid: (GUID fromString: '{787A1FF5-1809-4381-AB64-22F338ECAA37}')!
EditableListViewColumn comment: ''!
!EditableListViewColumn categoriesForClass!Unclassified! !
!EditableListViewColumn methodsFor!

backcolor
	^backcolor!

backcolor: anObject
	backcolor := anObject!

cachedIndex
	^cachedIndex!

cachedIndex: anObject
	cachedIndex := anObject!

cachedWidth
	^cachedWidth!

cachedWidth: anObject
	cachedWidth := anObject!

createEditorIn: aView

	self hasEditor ifTrue: [self editor createEmbeddedIn: aView].

	self isEditable ifTrue: 
		[self editor model: 
			(ValueHolder new
				when: #valueChanged send: #onValueChangedIn: to: aView with: self;
				yourself)]!

customDrawIcon: aContext

	| image imageRect canvas colBackcolor origin |

	image := self imageFromRow: aContext item.
	image isNil ifTrue: [^self].

	imageRect := aContext view 
		lvmGetSubItemRect: (aContext dwItemSpec@aContext iSubItem) 
		bounding: LVIR_ICON.

	canvas := aContext canvas.

	(self parent backcolor ifNil: [Color default]) isDefault
		ifTrue: [colBackcolor := Color window]
		ifFalse: [colBackcolor := self parent backcolor].

	canvas 
		erase: (imageRect origin extent: imageRect extent - (0@1))
		color: colBackcolor.

	image isInteger
	ifTrue:
		["Regular ListView image index behavior"
		origin := imageRect origin + ((imageRect extent - Icon smallExtent) // 2).
		(self parent imageManager imageListWithExtent: Icon smallExtent) 
			draw: image
			on: canvas
			at: origin
			flags: 0]
	ifFalse:
		["Actual Icon"
		origin := imageRect origin + ((imageRect extent - image extent) // 2).
		image drawOn: canvas at: origin extent: image extent].

	canvas free!

displayBackcolor

	^self parent rowBackcolor ifNil: 
		[self backcolor ifNil: 
			[(self parent backcolor ifNil: [Color default]) isDefault
				ifTrue: [Color window]
				ifFalse: [self parent backcolor]]]!

displayForecolor

	^(self hasEditor not or: [self editor isEnabled])
	ifTrue: 
		[self parent rowForecolor ifNil: 
			[self forecolor ifNil: 
				[self parent forecolor ifNil:
					[Color windowText]]]]
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

getSortContentsBlock
	^getSortContentsBlock!

getSortContentsBlock: anObject
	getSortContentsBlock := anObject!

hasColumnImage

	^self parent hasColumnImages and: [self hasImageBlock and: [self ~~ self parent primaryColumn]]!

hasEditor

	^self editor notNil!

hasImage

	^(self parent hasColumnImages and: [self hasImageBlock])
		or: [self parent primaryColumn == self and: [self parent hasImageBlock]]!

hasImageBlock

	^self getImageBlock notNil!

hasPreDrawBlock

	^self preDrawBlock notNil!

hide

	self 
		cachedWidth: self width;
		cachedIndex: (self parent allColumns identityIndexOf: self).

	self parent removeColumn: self!

imageFromRow: anObject

	^self parent hasColumnImages
		ifTrue: [super imageFromRow: anObject]
		ifFalse: [self parent imageFromRow: anObject]!

initialize
	"Private - Initialize the state of the receiever."

	super initialize.
	self
		isEditable: true;
		setContentsBlock: nil;
		editor: EmbeddedTextEdit new!

isEditable
	^isEditable!

isEditable: anObject
	isEditable := anObject!

isEditableBlock
	^isEditableBlock!

isEditableBlock: anObject
	isEditableBlock := anObject!

isEditableWith: anObject

	^self isEditable and: [self isEditableBlock isNil or: [self isEditableBlock value: anObject]]!

onSelectionChanged

	"Do nothing"!

ownerDraw: aContext

	| itemRect canvas brush bcolor fcolor hasColumnImage |

	"Self-drawing editor active? It will handle all drawing itself"
	(self hasEditor and: [self editor isDisplayOwnerDrawn not 
		and: [self editor hasVisibleStyle and: [aContext item == self parent selectionOrNil]]]) ifTrue: 
			["...however, need to ensure any areas not covered by the editor are cleared"
			canvas := aContext canvas.
			self parent activeEditorNeedsHighlight ifTrue:
				[(self parent activeEditor cellRect areasOutside: self parent activeEditor rectangle) do:
					[ :each | canvas erase: each color: Color face3d]].
			"...and, if the receiver has an icon, need to draw it manually"
			self parent postDraw: aContext columnIndex: self index. "Implicit canvas free"
			^true].

	aContext forecolor: self displayForecolor; backcolor: self displayBackcolor.
	self hasPreDrawBlock ifTrue: [self preDrawBlock value: aContext].

	hasColumnImage := self hasColumnImage.

	(self hasEditor and: [self editor isDisplayOwnerDrawn or: [hasColumnImage]]) ifFalse: [^false].

	aContext rc width = 0 ifTrue: [^self].

	canvas := aContext canvas.

	"aContext boundingRectangle unreliable"
	itemRect := aContext view 
				lvmGetSubItemRect: (aContext dwItemSpec@aContext iSubItem) 
				bounding: LVIR_LABEL.

	hasColumnImage ifTrue: [itemRect left: ((itemRect left + self parent smallImageExtent x) min: itemRect right)].

	"Handle selection background color"
	aContext view hasFullRowSelect 
	ifTrue:
		[(self parent isSelected: aContext item)
		ifTrue: 
			[self parent hasFocus
			ifTrue: 
				[bcolor := Color highlight.
				fcolor := Color highlightText]
			ifFalse: 
				[self parent showsSelAlways
					ifTrue: [bcolor := Color face3d]
					ifFalse: [bcolor := aContext backcolor]]]
		ifFalse: 
			[bcolor := self displayBackcolor]]
	ifFalse:
		[bcolor := aContext backcolor].

	brush := Brush color: bcolor.
	canvas fillRectangle: itemRect brush: brush.
	brush free.

	self editor 
		display: (self getContentsBlock value: aContext item) 
		in: itemRect 
		on: canvas
		forecolor: (fcolor ifNil: [self displayForecolor])
		backcolor: bcolor.

	hasColumnImage ifTrue: [self customDrawIcon: aContext].

	^true!

preDrawBlock
	^preDrawBlock!

preDrawBlock: anObject
	preDrawBlock := anObject!

rowSortBlock
	"Private - Answer a two argument block that can be used to compare
	two rows based on this column, or nil if the column is not sortable.
	Note that the first time the sort block is accessed, it is returned as originally 
	set up. On the next access it is inverted, and on the next it is inverted again
	(i.e. back to the original). This effectively toggles the sort order between
	ascending (or whatever it was originally) and descending, each time
	the sort block is accessed."

	^self isSortable ifTrue: 
		[self isSortOrderInverted 
			ifTrue: 
				[[:a :b | getSortValueBlock value: (self sortContentFromRow: b) value: (self sortContentFromRow: a)]]
			ifFalse: 
				[[:a :b | getSortValueBlock value: (self sortContentFromRow: a) value: (self sortContentFromRow: b)]]]
!

setContentsBlock

	"setContentsBlock stores a 2-arg block which is evaluated with a list item 
	and an updated value (as returned by the editor) to set the new value in a list"

	^setContentsBlock!

setContentsBlock: anObject

	"setContentsBlock stores a 2-arg block which is evaluated with a list item 
	and an updated value (as returned by the editor) to set the new value in a list"

	setContentsBlock := anObject!

setEditorValueFrom: anObject

	self editor embeddedValue: (self getContentsBlock value: anObject)!

showIn: anEditableListView

	anEditableListView addColumn: self atIndex: self cachedIndex.
	self width: self cachedWidth!

sortContentFromRow: item

	"Return the row attribute to use for sorting"

	^self getSortContentsBlock isNil 
		ifTrue: [self contentFromRow: item]
		ifFalse: [self getSortContentsBlock value: item]!

updateValueIn: anObject

	self setContentsBlock value: anObject value: self editor embeddedValue! !
!EditableListViewColumn categoriesFor: #backcolor!accessing!private! !
!EditableListViewColumn categoriesFor: #backcolor:!accessing!private! !
!EditableListViewColumn categoriesFor: #cachedIndex!accessing!private! !
!EditableListViewColumn categoriesFor: #cachedIndex:!accessing!private! !
!EditableListViewColumn categoriesFor: #cachedWidth!accessing!private! !
!EditableListViewColumn categoriesFor: #cachedWidth:!accessing!private! !
!EditableListViewColumn categoriesFor: #createEditorIn:!initialize/release!private! !
!EditableListViewColumn categoriesFor: #customDrawIcon:!operations!public! !
!EditableListViewColumn categoriesFor: #displayBackcolor!accessing!private! !
!EditableListViewColumn categoriesFor: #displayForecolor!accessing!private! !
!EditableListViewColumn categoriesFor: #displayOn:!operations!private! !
!EditableListViewColumn categoriesFor: #editor!accessing!public! !
!EditableListViewColumn categoriesFor: #editor:!accessing!public! !
!EditableListViewColumn categoriesFor: #forecolor!accessing!private! !
!EditableListViewColumn categoriesFor: #forecolor:!accessing!private! !
!EditableListViewColumn categoriesFor: #getSortContentsBlock!accessing!private! !
!EditableListViewColumn categoriesFor: #getSortContentsBlock:!accessing!private! !
!EditableListViewColumn categoriesFor: #hasColumnImage!public!testing! !
!EditableListViewColumn categoriesFor: #hasEditor!public!testing! !
!EditableListViewColumn categoriesFor: #hasImage!public!testing! !
!EditableListViewColumn categoriesFor: #hasImageBlock!public!testing! !
!EditableListViewColumn categoriesFor: #hasPreDrawBlock!accessing!public! !
!EditableListViewColumn categoriesFor: #hide!operations!public! !
!EditableListViewColumn categoriesFor: #imageFromRow:!public!testing! !
!EditableListViewColumn categoriesFor: #initialize!initialize/release!private! !
!EditableListViewColumn categoriesFor: #isEditable!accessing!public! !
!EditableListViewColumn categoriesFor: #isEditable:!accessing!public! !
!EditableListViewColumn categoriesFor: #isEditableBlock!accessing!private! !
!EditableListViewColumn categoriesFor: #isEditableBlock:!accessing!private! !
!EditableListViewColumn categoriesFor: #isEditableWith:!public!testing! !
!EditableListViewColumn categoriesFor: #onSelectionChanged!event handling!public! !
!EditableListViewColumn categoriesFor: #ownerDraw:!operations!public! !
!EditableListViewColumn categoriesFor: #preDrawBlock!accessing!private! !
!EditableListViewColumn categoriesFor: #preDrawBlock:!accessing!private! !
!EditableListViewColumn categoriesFor: #rowSortBlock!accessing!private! !
!EditableListViewColumn categoriesFor: #setContentsBlock!accessing!public! !
!EditableListViewColumn categoriesFor: #setContentsBlock:!accessing!public! !
!EditableListViewColumn categoriesFor: #setEditorValueFrom:!operations!private! !
!EditableListViewColumn categoriesFor: #showIn:!operations!public! !
!EditableListViewColumn categoriesFor: #sortContentFromRow:!adapters!private! !
!EditableListViewColumn categoriesFor: #updateValueIn:!operations!private! !

!EditableListViewColumn class methodsFor!

stbVersion

	"12: Added isEditableBlock
	14: Added cachedWidth and cachedIndex"

	^14
! !
!EditableListViewColumn class categoriesFor: #stbVersion!public! !

