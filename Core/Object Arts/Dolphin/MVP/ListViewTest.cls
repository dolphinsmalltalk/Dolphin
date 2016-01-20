"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #ListViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
ListViewTest guid: (GUID fromString: '{BCE10A8D-244E-4377-846C-BCBEF9D853A1}')!
ListViewTest comment: ''!
!ListViewTest categoriesForClass!Unclassified! !
!ListViewTest methodsFor!

assertCaretVisible
	| pos view |
	view := presenter view.
	pos := view lvmGetItemPosition: view caretIndex - 1.
	self assert: (view rectangle containsPoint: pos)!

classToTest
	^ListView!

getColumns
	| answer |
	answer := OrderedCollection new.
	0 to: 256
		do: 
			[:each | 
			| col |
			col := LVCOLUMN new.
			col text: (String new: 256).
			(presenter view 
				sendMessage: LVM_GETCOLUMN
				wParam: each
				lpParam: col) asBoolean 
				ifTrue: 
					[col text: col text trimNulls.
					answer add: col]
				ifFalse: [^answer]]!

getItem: anInteger 
	| item textBuf aListView |
	aListView := presenter view.
	item := LVITEM new.
	item iItem: anInteger - 1.
	item iSubItem: 0.
	item image: 0.
	textBuf := String new: 128.
	item text: textBuf.
	item bytes sdwordAtOffset: 24 put: textBuf size.
	aListView lvmGetItem: item.
	^item!

setColumns: cols 
	| list |
	(presenter view)
		columnsList: cols;
		update.
	list := self getColumns.
	self 
		assert: (list collect: [:each | each text]) asArray = (cols collect: [:each | each text]) asArray.
	self assert: presenter view columnOrder = (1 to: cols size).
	^list!

sortSelections
	^#(50)!

testColumnsList
	"Remove the first column"

	| cols |
	cols := self getColumns.
	self assert: cols size = 1.
	self assert: cols first text = 'Column 1'.
	self assert: presenter view columnOrder = (1 to: 1).
	cols := (1 to: 6) collect: 
					[:each | 
					(ListViewColumn text: each displayString)
						isAutoResize: true;
						yourself].
	self setColumns: cols.
	"Remove the first column"
	cols := cols copyFrom: 2.
	presenter view columnsList: cols.
	self setColumns: cols.

	"Remove the last column"
	cols := cols copyFrom: 1 to: 4.
	self setColumns: cols.

	"Remove last two columns"
	cols := cols copyFrom: 1 to: 2.
	self setColumns: cols.

	"Add one back on the end"
	cols := cols copyWith: ((ListViewColumn text: '4')
						isAutoResize: true;
						yourself).
	self setColumns: cols.

	"Add one on the front"
	cols := (OrderedCollection withAll: cols)
				addFirst: ((ListViewColumn text: '1')
							isAutoResize: true;
							yourself);
				yourself.
	self setColumns: cols.

	"Remove two from the middle."
	cols := (cols copy)
				removeAtIndex: 2;
				removeAtIndex: 2;
				yourself.
	self setColumns: cols.

	"Remove them all"
	self setColumns: #()!

testLastSelectionCacheUpdatedOnRemove
	"#717"
	| objects |
	objects := self objectsToTest.
	presenter model addAll: objects.
	self assert: presenter hasSelection not.
	presenter selection: objects second.
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(2).
	presenter model removeAtIndex: 1.
	self assert: (presenter instVarNamed: 'lastSelIndices') = #(1)!

testSetTextBlockDoesNotAffectSelection
	2 timesRepeat: 
			[super testSetTextBlockDoesNotAffectSelection.
			presenter view isVirtual: false]!

testSetTextImageDoesNotAffectSelection
	| objects |
	objects := self objectsToTest.
	presenter view isVirtual: false.
	0 to: 1
		do: 
			[:i | 
			presenter model removeAll.
			presenter view isVirtual: i asBoolean.
			presenter model addAll: objects.
			presenter selectionByIndex: 2.
			self 
				shouldnt: 
					["Remove an object after the selection"
					presenter view getImageBlock: [:each | each icon imageIndex + 1]]
				trigger: #selectionChanged
				against: presenter.
			self assert: presenter selectionByIndex == 2.
			self 
				shouldnt: [presenter selectionByIndex: 2]
				trigger: #selectionChanging:
				against: presenter]! !
!ListViewTest categoriesFor: #assertCaretVisible!private!unit tests! !
!ListViewTest categoriesFor: #classToTest!helpers!private! !
!ListViewTest categoriesFor: #getColumns!helpers!private! !
!ListViewTest categoriesFor: #getItem:!private!unit tests! !
!ListViewTest categoriesFor: #setColumns:!private!unit tests! !
!ListViewTest categoriesFor: #sortSelections!public!unit tests! !
!ListViewTest categoriesFor: #testColumnsList!public!unit tests! !
!ListViewTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
!ListViewTest categoriesFor: #testSetTextBlockDoesNotAffectSelection!public!unit tests! !
!ListViewTest categoriesFor: #testSetTextImageDoesNotAffectSelection!public!unit tests! !

