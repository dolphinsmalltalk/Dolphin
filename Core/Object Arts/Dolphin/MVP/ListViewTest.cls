"Filed out from Dolphin Smalltalk"!

ListControlTest subclass: #ListViewTest
	instanceVariableNames: 'nmClick'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ListViewTest guid: (GUID fromString: '{bce10a8d-244e-4377-846c-bcbef9d853a1}')!

ListViewTest isAbstract: true!

ListViewTest comment: ''!

!ListViewTest categoriesForClass!Unclassified! !

!ListViewTest methodsFor!

classToTest
	^ListView!

forceColumnResize
	| width |
	"Force the view to auto-resize its columns. Force this to happen as the result of a resize event,
	as this has a different implementation than simply sending #autoResizeColumns."
	width := presenter width.
	presenter
		width: width + 1;
		width: width!

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
				sendMessage: ListViewConstants.LVM_GETCOLUMNW
				wParam: each
				lpParam: col) asBoolean
				ifTrue: 
					[col text: col text trimNulls.
					answer add: col]
				ifFalse: [^answer]]!

getItem: anInteger
	| item |
	item := LVITEMW new
				iItem: anInteger - 1;
				image: 0;
				newTextBuffer: 128;
				yourself.
	presenter view lvmGetItem: item.
	^item!

newSelectionAfterLeftClickOutsideList: anArrayOfInteger 
	^#()!

newSelectionsFromEvent: aMouseEvent
	^presenter view newSelectionsFromEvent: aMouseEvent!

setColumns: cols
	| list |
	presenter view columnsList: cols.
	list := self getColumns.
	self assert: (list collect: [:each | each text]) asArray
		equals: (cols collect: [:each | each text]) asArray.
	self assert: presenter view columnOrder equals: (1 to: cols size).
	^list!

setupClickIntercept
	| anonClass method |
	anonClass := ListView newAnonymousSubclass.	"Convert the ListView to an instance of an anonymous subclass with an override of nmClick handler that allows us to intercept the notifications."
	presenter view becomeA: anonClass.
	method := anonClass
				compile: 'nmClick: pNMHDR
		#placeholder value: pNMHDR.
		^super nmClick: pNMHDR'.
	self assert: (method literalAt: 1) equals: #placeholder.
	nmClick := [:itemactivate | clicks addLast: itemactivate copy].
	method whileMutableDo: 
			[method literalAt: 1 put: [:pNMHDR | nmClick value: (NMITEMACTIVATE fromAddress: pNMHDR)]]!

setUpForSelectionTesting
	super setUpForSelectionTesting.
	presenter view viewMode: #list!

sortSelections
	^self subclassResponsibility!

test1071
	"Tests that reducing the number of items in a list that is scrolled down with auto-sizing columns does not corrupt the scroll offset."

	| lv |
	lv := presenter view.
	lv viewMode: #report.
	lv addColumn isAutoResize: true.
	lv model list: (1 to: 100).
	self assert: lv lvmGetOrigin equals: Point zero.
	lv ensureVisible: 100.
	lv model list: (1 to: 5).
	self assert: lv lvmGetOrigin equals: Point zero!

testAutoResizeColumns
	presenter viewMode: #report.
	"One column, full width"
	self verifyColumnWidths: #(196).
	"Resizes given the addition of another column"
	presenter addColumn.
	self verifyColumnWidths: #(96 100).
	"Two auto-resize columns share non-fixed space equally"
	presenter addColumn isAutoResize: true.
	self verifyColumnWidths: #(48 100 48).
	"Rounding errors do not accumulate"
	presenter columnsList second width: 101.
	self verifyColumnWidths: #(48 101 47).
	"Resizes when a column is removed"
	presenter removeColumnAtIndex: 3.
	self verifyColumnWidths: #(95 101)!

testAutoResizeColumnsPositionChangedAddingScrollbar
	| shellNCHeight |
	shellNCHeight := presenter topShell height - presenter height.
	presenter viewMode: #report.
	presenter list: (1 to: 15).
	self verifyColumnWidths: #(196).
	"This is the shortest we can be without a vertical scrollbar. Sanity-check that one is in fact not shown."
	presenter topShell height: 343 + shellNCHeight.
	self deny: (presenter getWindowStyle allMask: WS_VSCROLL).
	self verifyColumnWidths: #(196).
	"One pixel shorter, and a scrollbar appears, which we must compensate for."
	presenter topShell height: 342 + shellNCHeight.
	self assert: (presenter getWindowStyle allMask: WS_VSCROLL).
	self verifyColumnWidths: {196 - SystemMetrics current scrollbarWidth}!

testAutoResizeColumnsWithChangedBorderStyles
	presenter viewMode: #report.
	self verifyColumnWidths: #(196).
	"Static edge adds an additional 1px on each side"
	presenter hasStaticEdge: true.
	self forceColumnResize.
	self verifyColumnWidths: #(194).
	"This is a special case--we might expect to see 198 here, but when
	static edge is the *only* border style, the columns must total 2px less
	than the actual client width or a scrollbar appears."
	presenter hasClientEdge: false.
	self forceColumnResize.
	self verifyColumnWidths: #(196).
	"Giving the control a border stops this strange behavior,
	resulting in no actual change in width even though the
	visual thickness of the border increases by 1px."
	presenter hasBorder: true.
	self forceColumnResize.
	self verifyColumnWidths: #(196)!

testAutoResizeColumnsWithLargeNumberOfItems
	| font |
	presenter viewMode: #report.
	"With reasonably normal font settings, this is squarely in the range where
	LVM_APPROXIMATEVIEWRECT will overflow and return a negative value."
	presenter list: (1 to: 2000).
	self verifyColumnWidths: {196 - SystemMetrics current scrollbarWidth}.
	"Use a massive font to trigger the bug with a (relatively) small number of rows."
	font := presenter actualFont copy.
	font pointSize: font pointSize * 4.
	presenter font: font.
	presenter list: (1 to: 500).
	self verifyColumnWidths: {196 - SystemMetrics current scrollbarWidth}!

testBackImage
	| watermark |
	self deny: presenter view backImageIsTiled.
	self assert: presenter view backImageOffset equals: Point zero.
	self assert: presenter view backImageAlphaPercent equals: 100.
	self assert: presenter view backImage isNil.
	watermark := Bitmap fromFile: 'Resources\IdeaSpaceBackdrop.bmp'
				usingLocator: FileLocator installRelative.
	presenter view backImage:  watermark; backImageAlphaPercent: 60; backImageIsTiled: true.
	self assert: presenter view backImage identicalTo: watermark.
	self assert: presenter view backImageAlphaPercent equals: 60.
	self assert: presenter view backImageIsTiled
!

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

testCheckBoxes
	| stateImageList |
	presenter hasCheckBoxes: true.
	"In the default virtual mode, checkboxes are not supported"
	self deny: presenter hasCheckBoxes.
	presenter isVirtual: false.
	self assert: presenter hasCheckBoxes.
	self assert: presenter viewMode equals: #smallIcons.
	stateImageList := presenter lvmGetImageList: ListViewConstants.LVSIL_STATE.
	self assert: stateImageList ~= 0.
	"The ListView checkbox mode state image list contains just two images, the first an unchecked checkbox, and the 2nd a checked check box. It can be inspected by evaluating:
			WinImageList fromHandle: stateImageList
	Remember that image list indices are unusual in starting at 1."
	presenter model: (ListModel withAll: (1 to: 5)).
	1 to: 5 do: [:i | self deny: (presenter getItemChecked: i)].
	"Check every other item"
	1 to: 5
		by: 2
		do: [:i | presenter setItem: i checked: true].
	1 to: 5 do: [:i | self assert: (presenter getItemChecked: i) equals: i odd].
	"Changing view mode should preserve the checked/unchecked state."
	presenter viewMode: #largeIcons.
	1 to: 5 do: [:i | self assert: (presenter getItemChecked: i) equals: i odd].
	"Changing model should reset state"
	presenter model: (ListModel withAll: #($a $b $c)).
	1 to: 3 do: [:i | self deny: (presenter getItemChecked: i)].
	presenter setItem: 2 checked: true.
	self assert: (presenter getItemChecked: 2).
	presenter hasCheckBoxes: false.
	self deny: (presenter getItemChecked: 2)!

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

testNewSelectionsClickOutsideListWithModifiers
	| event selection expected |
	self setUpForSelectionTesting.
	selection := #(1).
	expected := self isMultiSelect ifTrue: [selection] ifFalse: [#()].
	OrderedCollection new
		add: #(#control);
		add: #(#shift);
		add: #(#control #shift);
		do: 
				[:modifiers |
				presenter selectionsByIndex: selection.
				event := self mouseDownEventOnItem: 0 buttons: (modifiers copyWith: #left).
				self verifySelectionsFromMouseDown: event equals: expected]!

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
				against: presenter]!

verifyClicks: anArray
	clicks with: anArray
		do: 
			[:click :expected |
			self assert: click iItem equals: expected first - 1.
			self assert: click position equals: expected second]!

verifyColumnWidths: widths
	presenter columnsList with: widths do: [:col :width | self assert: col width equals: width]! !

!ListViewTest categoriesForMethods!
classToTest!helpers!private! !
forceColumnResize!helpers!private! !
getColumns!helpers!private! !
getItem:!helpers!private! !
newSelectionAfterLeftClickOutsideList:!constants!private! !
newSelectionsFromEvent:!helpers!private! !
setColumns:!helpers!private! !
setupClickIntercept!private! !
setUpForSelectionTesting!helpers!private! !
sortSelections!helpers!public! !
test1071!public!unit tests! !
testAutoResizeColumns!public!unit tests! !
testAutoResizeColumnsPositionChangedAddingScrollbar!public!unit tests! !
testAutoResizeColumnsWithChangedBorderStyles!public!unit tests! !
testAutoResizeColumnsWithLargeNumberOfItems!public!unit tests! !
testBackImage!public!unit tests! !
testChangeViewMode!public!unit tests! !
testCheckBoxes!public!unit tests! !
testColumnsList!public!unit tests! !
testNewSelectionsClickOutsideListWithModifiers!public!unit tests! !
testNilRow!public!unit tests! !
testSelectionRemainsVisibleOnSort!public!unit tests! !
testSetTextBlockDoesNotAffectSelection!public!unit tests! !
testSetTextImageDoesNotAffectSelection!public!unit tests! !
verifyClicks:!helpers!private! !
verifyColumnWidths:!helpers!private! !
!

