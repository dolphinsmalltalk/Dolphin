"Filed out from Dolphin Smalltalk 7"!

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
				self verifyNewSelectionsFromEvent: event equals: expected]!

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

verifyNewSelectionsFromEvent: aMouseEvent equals: anArray
	self assert: (presenter view newSelectionsFromEvent: aMouseEvent) equals: anArray.
	super verifyNewSelectionsFromEvent: aMouseEvent equals: anArray! !
!ListViewTest categoriesFor: #classToTest!helpers!private! !
!ListViewTest categoriesFor: #getColumns!helpers!private! !
!ListViewTest categoriesFor: #getItem:!helpers!private! !
!ListViewTest categoriesFor: #newSelectionAfterLeftClickOutsideList:!constants!private! !
!ListViewTest categoriesFor: #newSelectionsFromEvent:!helpers!private! !
!ListViewTest categoriesFor: #setColumns:!helpers!private! !
!ListViewTest categoriesFor: #setupClickIntercept!private! !
!ListViewTest categoriesFor: #setUpForSelectionTesting!helpers!private! !
!ListViewTest categoriesFor: #sortSelections!helpers!public! !
!ListViewTest categoriesFor: #testBackImage!public!unit tests! !
!ListViewTest categoriesFor: #testChangeViewMode!public!unit tests! !
!ListViewTest categoriesFor: #testColumnsList!public!unit tests! !
!ListViewTest categoriesFor: #testNewSelectionsClickOutsideListWithModifiers!public!unit tests! !
!ListViewTest categoriesFor: #testNilRow!public!unit tests! !
!ListViewTest categoriesFor: #testSelectionRemainsVisibleOnSort!public!unit tests! !
!ListViewTest categoriesFor: #testSetTextBlockDoesNotAffectSelection!public!unit tests! !
!ListViewTest categoriesFor: #testSetTextImageDoesNotAffectSelection!public!unit tests! !
!ListViewTest categoriesFor: #verifyClicks:!helpers!private! !
!ListViewTest categoriesFor: #verifyNewSelectionsFromEvent:equals:!helpers!private! !

