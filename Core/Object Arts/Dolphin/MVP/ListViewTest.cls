"Filed out from Dolphin Smalltalk 7"!

SelectableListItemsTest subclass: #ListViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'ListViewConstants'
	classInstanceVariableNames: ''!
ListViewTest guid: (GUID fromString: '{bce10a8d-244e-4377-846c-bcbef9d853a1}')!
ListViewTest isAbstract: true!
ListViewTest comment: ''!
!ListViewTest categoriesForClass!Unclassified! !
!ListViewTest methodsFor!

assertCaretVisible
	| pos view |
	view := presenter view.
	pos := (view itemRect: view caretIndex) origin.
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
			col := LVCOLUMNW new.
			col newTextBuffer: 256.
			(presenter view
				sendMessage: LVM_GETCOLUMNW
				wParam: each
				lpParam: col) asBoolean
				ifTrue: 
					[col text: col text trimNulls.
					answer add: col]
				ifFalse: [^answer]]!

getItem: anInteger
	| item aListView |
	aListView := presenter view.
	item := LVITEMW new.
	item iItem: anInteger - 1.
	item iSubItem: 0.
	item image: 0.
	item newTextBuffer: 128.
	aListView lvmGetItem: item.
	^item!

mouseDownEventOnItem: itemIndex buttons: anArray
	| mouseButton keys position |
	mouseButton := anArray intersection: #(#left #right #middle).
	self assert: mouseButton size equals: 1.
	mouseButton := mouseButton anyOne.
	keys := (anArray collect: 
					[:each |
					##(IdentityDictionary new
						at: #left put: MK_LBUTTON;
						at: #right put: MK_RBUTTON;
						at: #middle put: MK_MBUTTON;
						at: #control put: MK_CONTROL;
						at: #shift put: MK_SHIFT;
						yourself) at: each])
				fold: [:a :b | a bitOr: b].
	position := itemIndex == 0
				ifTrue: [presenter clientExtent - (1 @ 1)]
				ifFalse: [(presenter itemRect: itemIndex) origin + (1 @ 1)].
	^MouseEvent
		window: presenter
		message: (##(IdentityDictionary new
				at: #left put: WM_LBUTTONDOWN;
				at: #right put: WM_RBUTTONDOWN;
				at: #middle put: WM_MBUTTONDOWN;
				yourself) at: mouseButton)
		wParam: keys
		lParam: (DWORD fromPoint: position) asInteger!

setColumns: cols
	| list |
	presenter view columnsList: cols.
	list := self getColumns.
	self assert: (list collect: [:each | each text]) asArray
		equals: (cols collect: [:each | each text]) asArray.
	self assert: presenter view columnOrder equals: (1 to: cols size).
	^list!

setUpForSelectionTesting
	presenter
		list: (1 to: 10);
		viewMode: #list.!

sortSelections
	^self subclassResponsibility!

testChangeViewMode
	"#1510"

	| column |
	self assert: presenter isVirtual.
	presenter viewMode: #report.
	self assert: presenter viewMode identicalTo: #report.
	column := presenter primaryColumn.
	presenter getTextBlock: [:each | each first].
	column getTextBlock: [:each | each second].
	presenter model list: #(#('1' '2') #('11' '22')).
	2 timesRepeat: 
			[presenter model keysAndValuesDo: 
					[:i :each |
					| text |
					text := presenter getItemText: i.
					self assert: text equals: each second].
			presenter viewMode: #smallIcons.
			presenter model keysAndValuesDo: 
					[:i :each |
					| text |
					text := presenter getItemText: i.
					self assert: text equals: each first].
			presenter viewMode: #report.
			"Switch to non-virtual"
			presenter isVirtual: false.
			presenter refreshContents]!

testColumnsList
	"Remove the first column"

	| cols |
	cols := self getColumns.
	self assert: cols size equals: 1.
	self assert: cols first text equals: 'Column 1'.
	self assert: presenter view columnOrder equals: (1 to: 1).
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
	cols := cols copy
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
	self assert: (presenter instVarNamed: 'lastSelIndices') equals: #(2).
	presenter model removeAtIndex: 1.
	self assert: (presenter instVarNamed: 'lastSelIndices') equals: #(1)!

testNewSelectionsLeftClickOutsideList
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 0 buttons: #(#left).
	self assert: (presenter newSelectionsFromEvent: event) equals: #().
	presenter selectionsByIndex: #(3).
	self assert: (presenter newSelectionsFromEvent: event) equals: #()!

testNewSelectionsSimpleLeftClick
	| event |
	self setUpForSelectionTesting.
	event := self mouseDownEventOnItem: 1 buttons: #(#left).
	self assert: (presenter newSelectionsFromEvent: event) equals: #(1).
	presenter selectionsByIndex: #(3).
	self assert: (presenter newSelectionsFromEvent: event) equals: #(1)!

testNilRow
	"#2157"

	| m c item txt |
	presenter viewMode: #report.
	m := ListModel on: #(nil) , (1 to: 5).
	presenter model: m.
	c := presenter view columnAtIndex: 1.
	txt := 'this is nil'.
	c getTextBlock: [:it | it ifNil: [txt]].
	item := self getItem: 1.
	self assert: item pszText equals: txt.
	self assert: item iImage equals: nil icon imageIndex - 1!

testProgrammaticSelectionVisible
	"#1381"

	"Note that the last selection is the one with the caret, and therefore it is that which should be visible"

	| view |
	view := presenter view.
	view list: (0 to: 100) asOrderedCollection.
	#(#(100) #(50 100) #(100 50) #(1)) do: 
			[:each | 
			view selections: each.
			self assertCaretVisible]!

testSelectionRemainsVisibleOnSort
	"#1381"

	| view |
	view := presenter view.
	view list: (0 to: 100) asOrderedCollection.
	view selections: self sortSelections.
	self assertCaretVisible.
	view columnClicked: 1.
	self assertCaretVisible.
	view columnClicked: 1.
	self assertCaretVisible!

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
			self assert: presenter selectionByIndex identicalTo: 2.
			self
				shouldnt: [presenter selectionByIndex: 2]
				trigger: #selectionChanging:
				against: presenter]! !
!ListViewTest categoriesFor: #assertCaretVisible!private!unit tests! !
!ListViewTest categoriesFor: #classToTest!helpers!private! !
!ListViewTest categoriesFor: #getColumns!helpers!private! !
!ListViewTest categoriesFor: #getItem:!private!unit tests! !
!ListViewTest categoriesFor: #mouseDownEventOnItem:buttons:!helpers!private! !
!ListViewTest categoriesFor: #setColumns:!private!unit tests! !
!ListViewTest categoriesFor: #setUpForSelectionTesting!helpers!private! !
!ListViewTest categoriesFor: #sortSelections!public!unit tests! !
!ListViewTest categoriesFor: #testChangeViewMode!public!unit tests! !
!ListViewTest categoriesFor: #testColumnsList!public!unit tests! !
!ListViewTest categoriesFor: #testLastSelectionCacheUpdatedOnRemove!public!unit tests! !
!ListViewTest categoriesFor: #testNewSelectionsLeftClickOutsideList!public!unit tests! !
!ListViewTest categoriesFor: #testNewSelectionsSimpleLeftClick!public!unit tests! !
!ListViewTest categoriesFor: #testNilRow!public!unit tests! !
!ListViewTest categoriesFor: #testProgrammaticSelectionVisible!public!unit tests! !
!ListViewTest categoriesFor: #testSelectionRemainsVisibleOnSort!public!unit tests! !
!ListViewTest categoriesFor: #testSetTextBlockDoesNotAffectSelection!public!unit tests! !
!ListViewTest categoriesFor: #testSetTextImageDoesNotAffectSelection!public!unit tests! !

