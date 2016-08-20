"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #PublishedAspectInspectorTest
	instanceVariableNames: 'inspector treePresenter displayPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PublishedAspectInspectorTest guid: (GUID fromString: '{26C95677-A861-4030-8D8E-B6BED0A6C3EF}')!
PublishedAspectInspectorTest comment: ''!
!PublishedAspectInspectorTest categoriesForClass!Unclassified! !
!PublishedAspectInspectorTest methodsFor!

aspectAccessorNamed: aSymbol
	^treePresenter view displayedContents detect: [:each | each name == aSymbol]!

aspectPresenter
	^inspector instVarNamed: 'aspectPresenter'!

createInspectorOn: inspectee
	inspector := PublishedAspectInspector shellOn: inspectee.
	treePresenter := inspector instVarNamed: 'aspectTreePresenter'.
	displayPresenter := inspector instVarNamed: 'displayPresenter'.
	treePresenter selection: (treePresenter model roots first)!

getAccessorKeyText: anAspectAccessor 
	^treePresenter view getItemText: (treePresenter view handleFromObject: anAspectAccessor)!

getAccessorValueText: anAspectAccessor 
	^(treePresenter view columnAtIndex: 2) getTextBlock value: anAspectAccessor!

isUsingListTreeView
	"Private - Answer true if the PAI is using a ListTreeView rather than the older style TreeView"

	^(Smalltalk at: #ListTreeView ifAbsent: []) 
		ifNil: [false]
		ifNotNil: [:ltv | treePresenter view isKindOf: ltv]!

repaint
	inspector view update.
	false ifTrue: [Processor sleep: 1500]!

seqCollMoveDownTest: testClass 
	| inspectee collection |
	inspectee := testClass withAll: (1 to: 5).
	inspector value: inspectee.
	collection := inspectee.
	treePresenter selection: treePresenter model roots first.
	self repaint.
	0 to: 1
		do: 
			[:j | 
			| listPresenter |
			self assert: treePresenter view itemCount == (collection size + 1 + j).
			listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
			listPresenter selectionByIndex: 1.
			2 to: 5
				do: 
					[:i | 
					self aspectPresenter moveDown.
					self repaint.
					self assert: treePresenter view itemCount == (collection size + 1 + j).
					listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
					self assert: listPresenter selectionByIndex = i.
					self assert: collection asArray = ((2 to: i) , (Array with: 1) , (i + 1 to: 5))].
			collection := Array withAll: (1 to: 5).
			inspectee := Array with: collection.
			inspector value: inspectee.
			treePresenter 
				selection: (treePresenter model childrenOf: treePresenter model roots first) first.
			treePresenter view expandAll]!

seqCollMoveFirstTest: testClass
	| inspectee listPresenter last |
	last := 5.
	inspectee := testClass withAll: (1 to: last).
	inspector value: inspectee.
	self assert: treePresenter view itemCount == (last + 1).
	self repaint.
	listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
	1 to: inspectee size
		do: 
			[:i | 
			listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
			listPresenter selectionByIndex: i.
			self aspectPresenter moveFirst.
			self repaint.
			self assert: treePresenter view itemCount == (last + 1).
			listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
			self assert: listPresenter selectionByIndex = 1.
			self assert: inspectee asArray = ((Array with: i) , (1 to: i-1),  (i + 1 to: last)).
			inspectee 
				replaceFrom: 1
				to: last
				with: (1 to: last)
				startingAt: 1.
			inspector aspectChanged: #yourself]!

seqCollMoveLastTest: testClass
	| inspectee listPresenter last |
	last := 5.
	inspectee := testClass withAll: (1 to: last).
	inspector value: inspectee.
	self assert: treePresenter view itemCount == (last + 1).
	self repaint.
	listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
	1 to: inspectee size
		do: 
			[:i | 
			listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
			listPresenter selectionByIndex: i.
			self aspectPresenter moveLast.
			self repaint.
			self assert: treePresenter view itemCount == (last + 1).
			listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
			self assert: listPresenter selectionByIndex = last.
			self assert: inspectee asArray = ((1 to: i - 1) , (i + 1 to: last) , (Array with: i)).
			inspectee 
				replaceFrom: 1
				to: last
				with: (1 to: last)
				startingAt: 1.
			inspector aspectChanged: #yourself]!

seqCollMoveUpTest: testClass
	| inspectee listPresenter |
	inspectee := testClass withAll: (1 to: 5).
	inspector value: inspectee.
	self assert: treePresenter view itemCount == 6.
	self repaint.
	listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
	listPresenter selectionByIndex: 5.
	4 to: 1 by: -1 do: [:i |
		self aspectPresenter moveUp.
		self repaint.
		self assert: inspectee asArray = ((1 to: i-1), (Array with: 5), (i to: 4)).
		self assert: listPresenter selectionByIndex = i.
		self assert: treePresenter view itemCount == 6]

!

tearDown
	inspector isNil 
		ifFalse: 
			[inspector view topView destroy.
			inspector := nil].
	super tearDown!

testAddRemoveCollectionElement
	| inspectee listPresenter |
	inspectee := OrderedCollection new.
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount == 1.
	self repaint.
	listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
	self aspectPresenter addItem: 1.
	"The item always remains expanded"
	self assert: treePresenter view itemCount == 2.
	treePresenter view expandAll.
	self repaint.
	self assert: treePresenter view itemCount == 2.
	listPresenter selectionByIndex: 1.
	self aspectPresenter removeItem.
	self assert: treePresenter view itemCount == 1.
	self repaint.
	self aspectPresenter addItem: 1.
	listPresenter selectionByIndex: 1.
	self aspectPresenter addItem: 2.
	"The item always remains expanded"
	self assert: treePresenter view itemCount == 3.
	self repaint.
	self aspectPresenter removeItem.
	self aspectPresenter removeItem.
	self assert: treePresenter view itemCount == 1.
	self repaint!

testAspectChanged
	| inspectee accessors tvItem hItem |
	inspectee := Association new.
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount == 3.
	self repaint.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	self assert: (self getAccessorKeyText: accessors first) = 'key'.
	self assert: (self getAccessorValueText: accessors first) = 'nil'.
	self assert: (self getAccessorKeyText: accessors last) = 'value'.
	self assert: (self getAccessorValueText: accessors last) = 'nil'.
	"Set key to a scalar"
	inspectee key: 1.
	inspector aspectChanged: #key of: inspectee.
	self repaint.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	self assert: (self getAccessorKeyText: accessors first) = 'key'.
	self assert: (self getAccessorValueText: accessors first) = '1'.
	self assert: (self getAccessorKeyText: accessors last) = 'value'.
	self assert: (self getAccessorValueText: accessors last) = 'nil'.
	self assert: treePresenter view itemCount == 3.
	"Set back to nil"
	inspectee key: nil.
	inspector aspectChanged: #key of: inspectee.
	self repaint.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	self assert: (self getAccessorKeyText: accessors first) = 'key'.
	self assert: (self getAccessorValueText: accessors first) = 'nil'.
	self assert: (self getAccessorKeyText: accessors last) = 'value'.
	self assert: (self getAccessorValueText: accessors last) = 'nil'.
	self assert: treePresenter view itemCount == 3.
	"Now set to something with sub-aspects"
	inspectee key: (1 to: 2).
	inspector aspectChanged: #key of: inspectee.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	hItem := treePresenter view handleFromObject: accessors first.
	self assert: (treePresenter view getItemText: hItem) = 'key'.
	self assert: (self getAccessorKeyText: accessors last) = 'value'.
	self assert: (self getAccessorValueText: accessors last) = 'nil'.
	self isUsingListTreeView 
		ifFalse: 
			[tvItem := treePresenter view getItemState: hItem.
			self assert: treePresenter view itemCount == 3.
			self assert: tvItem cChildren > 0].
	treePresenter expand: accessors first.
	self repaint.
	self assert: treePresenter view itemCount == 6.
	"Set back to nil"
	inspectee key: nil.
	inspector aspectChanged: #key of: inspectee.
	self repaint.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	self assert: (self getAccessorKeyText: accessors first) = 'key'.
	self assert: (self getAccessorValueText: accessors first) = 'nil'.
	self assert: (self getAccessorKeyText: accessors last) = 'value'.
	self assert: (self getAccessorValueText: accessors last) = 'nil'.
	self assert: treePresenter view itemCount == 3.
	self repaint.
	"Now nil the root"
	inspectee oneWayBecome: nil.
	inspector aspectChanged: #yourself.
	self assert: treePresenter view itemCount == 1.
	self repaint!

testContextMenuEdit
	| inspectee |
	inspectee := View new.
	inspectee create.
	
	[| contextMenu accessor items |
	contextMenu := inspectee contextMenu.
	self assert: contextMenu isNil.
	self createInspectorOn: inspectee.
	accessor := self aspectAccessorNamed: #contextMenu.
	treePresenter selection: accessor.
	self aspectPresenter value: Menu new.
	contextMenu := inspectee contextMenu.
	self assert: contextMenu notNil.
	self assert: contextMenu isEmpty.
	self repaint.
	accessor := self aspectAccessorNamed: #items.
	treePresenter selection: accessor.
	self assert: accessor value isEmpty.
	self aspectPresenter addItem: CommandMenuItem new.
	accessor := self aspectAccessorNamed: #items.
	self assert: accessor value size = 1.
	self assert: contextMenu ~~ inspectee contextMenu.
	"Original context menu should not have been changed"
	self assert: contextMenu isEmpty.
	self assert: inspectee contextMenu size = 1.
	self assert: inspectee contextMenu items ~~ accessor value.
	self assert: inspectee contextMenu items first command == accessor value first command.
	treePresenter view expandAll.
	contextMenu := inspectee contextMenu.
	accessor := self aspectAccessorNamed: #description.
	self assert: accessor value = 'No Command'.
	treePresenter selection: accessor.
	self aspectPresenter value: 'Blah blah'.
	self assert: accessor value = 'Blah blah'.
	"Should propagate up and retitle the item"
	self assert: (self getAccessorValueText: (self aspectAccessorNamed: 1)) = 'Blah blah'.
	"Should also have propagated into the View's menu, which should have been replaced, original not changed"
	self assert: contextMenu items first description = 'No Command'.
	self assert: inspectee contextMenu ~~ contextMenu.
	"Obviously the description update should have propagated through"
	self assert: inspectee contextMenu items first description = accessor value.

	"Now try copying and pasting a menu item over a new menu item"
	treePresenter selection: (self aspectAccessorNamed: 1).
	inspector copyAspect.
	accessor := self aspectAccessorNamed: #items.
	treePresenter selection: accessor.
	self aspectPresenter addItem: CommandMenuItem new.
	items := inspectee contextMenu items.
	self assert: items size = 2.
	self assert: items last description = 'No Command'.
	accessor := self aspectAccessorNamed: 2.
	treePresenter selection: accessor.
	inspector pasteAspect.
	items := inspectee contextMenu items.
	self assert: items size = 2.
	"If the paste worked, then the inspectee's second context menu item should have been updated"
	self assert: items last description = 'Blah blah'] 
			ensure: [inspectee destroy]!

testCopyAndPasteMenu
	| inspectee1 inspectee2 |
	inspectee1 := ShellView new.
	inspectee1 create.
	inspectee2 := ShellView new.
	inspectee2 create.
	
	[| menuBar1 accessor menuBar2 |
	menuBar1 := inspectee1 menuBar.
	self assert: menuBar1 isNil.
	self createInspectorOn: inspectee1.
	accessor := self aspectAccessorNamed: #menuBar.
	treePresenter selection: accessor.
	self assert: accessor value isNil.
	self aspectPresenter 
		value: (MenuBar fromStrings: #('&File' 'Open//fileOpen' '-' '&Save/Ctrl+S/fileSave')).
	self repaint.
	menuBar1 := inspectee1 menuBar.
	self assert: menuBar1 notNil.
	self assert: menuBar1 size = 3.
	self assert: menuBar1 items first text = 'Open'.
	inspector copyAspect.
	inspector value: inspectee2.
	self repaint.
	self assert: inspectee2 menuBar isNil.
	accessor := self aspectAccessorNamed: #menuBar.
	treePresenter selection: accessor.
	self assert: accessor value isNil.
	inspector pasteAspect.
	self repaint.
	self assert: accessor value notNil.
	menuBar2 := inspectee2 menuBar.
	self assert: menuBar2 notNil.
	self deny: menuBar1 == menuBar2.
	self assert: menuBar2 size = 3.
	self assert: menuBar2 items first text = 'Open'] 
			ensure: 
				[inspectee1 destroy.
				inspectee2 destroy]!

testImmutableAspect
	| inspectee |
	inspectee := View new.
	inspectee create.
	
	[| extent accessor originalExtent |
	extent := inspectee extent.
	originalExtent := extent copy.
	self assert: extent ~~ originalExtent.
	self assert: extent isZero not.
	self createInspectorOn: inspectee.
	accessor := self aspectAccessorNamed: #extent.
	self assert: accessor isMutable not.
	treePresenter selection: accessor.
	self assert: accessor value = extent.
	self assert: accessor value ~~ extent.
	treePresenter view expandAll.
	accessor := self aspectAccessorNamed: #y.
	treePresenter selection: accessor.
	self aspectPresenter value: 150.
	self repaint.
	accessor := self aspectAccessorNamed: #y.
	self assert: (self getAccessorKeyText: accessor) = 'y'.
	self assert: (self getAccessorValueText: accessor) = '150'.
	accessor := self aspectAccessorNamed: #extent.
	self assert: (self getAccessorKeyText: accessor) = 'extent'.
	self 
		assert: (self getAccessorValueText: accessor) = ('<1d>@150' expandMacrosWith: originalExtent x).

	"Note that the original extent object should not have changed"
	self assert: extent = originalExtent.
	"But the view's extent should have"
	self assert: inspectee extent ~~ extent.
	self assert: inspectee extent y = 150.
	"The view must not be referencing the same copy of the immutable object as the aspect tree"
	self assert: accessor value ~~ inspectee extent] 
			ensure: [inspectee destroy]!

testImmutableAspect2
	| inspectee accessor originalFormat accessor2 |
	inspectee := BooleanToText new.
	originalFormat := #('false' 'true') copy.
	inspectee format: originalFormat.
	self createInspectorOn: inspectee.
	accessor := self aspectAccessorNamed: #format.
	self assert: accessor isMutable not.
	treePresenter selection: accessor.
	self assert: accessor value = originalFormat.
	"The value of the accessor is still the original object, but its sub-aspect values should 
	 be pointing at a copy"
	self assert: accessor value == originalFormat.
	treePresenter view expandAll.
	accessor := self aspectAccessorNamed: 1.
	self assert: accessor value = 'false'.
	self assert: accessor subject = originalFormat.
	self assert: accessor subject ~~ originalFormat.
	accessor2 := self aspectAccessorNamed: 2.
	self assert: accessor2 value = 'true'.
	self assert: accessor2 subject = originalFormat.
	self assert: accessor2 subject ~~ originalFormat.
	self assert: accessor2 subject == accessor subject.
	treePresenter selection: accessor.
	self aspectPresenter value: 'no'.
	self repaint.
	accessor := self aspectAccessorNamed: 1.
	self assert: (self getAccessorKeyText: accessor) = '1'.
	self assert: (self getAccessorValueText: accessor) = '''no'''.
	accessor := self aspectAccessorNamed: #format.
	self assert: (self getAccessorKeyText: accessor) = 'format'.
	self assert: (self getAccessorValueText: accessor) = 'an Array'.

	"Note that the original object should not have changed"
	self assert: originalFormat = #('false' 'true').
	"But the inspectee's should have"
	self assert: inspectee format ~~ originalFormat.
	self assert: inspectee format = #('no' 'true').
	"The inspectee should still be referencing the same copy of the immutable object as the aspect tree,
	but again not the sub-aspects"
	self assert: accessor value == inspectee format.
	1 to: 2
		do: 
			[:i | 
			| each |
			each := self aspectAccessorNamed: i.
			self assert: each subject ~~ inspectee format.
			self assert: each subject = inspectee format].

	"Now update the other sub-aspect"
	accessor2 := self aspectAccessorNamed: 2.
	self assert: accessor2 value = 'true'.
	self assert: accessor2 subject ~= originalFormat.
	self assert: accessor2 subject ~~ originalFormat.
	accessor := self aspectAccessorNamed: 1.
	self assert: accessor2 subject == accessor subject.
	treePresenter selection: accessor2.
	self aspectPresenter value: 'yes'.
	self repaint.
	accessor := self aspectAccessorNamed: 2.
	self assert: (self getAccessorKeyText: accessor2) = '2'.
	self assert: (self getAccessorValueText: accessor2) = '''yes'''.
	accessor := self aspectAccessorNamed: #format.
	self assert: (self getAccessorKeyText: accessor) = 'format'.
	self assert: (self getAccessorValueText: accessor) = 'an Array'.

	"Note that the original object should not have changed"
	self assert: originalFormat = #('false' 'true').
	"But the inspectee's should have"
	self assert: inspectee format ~~ originalFormat.
	self assert: inspectee format = #('no' 'yes').
	"The inspectee should still be referencing the same copy of the immutable object as the aspect tree,
	but again not the sub-aspects"
	self assert: accessor value == inspectee format.
	1 to: 2
		do: 
			[:i | 
			| each |
			each := self aspectAccessorNamed: i.
			self assert: each subject ~~ inspectee format.
			self assert: each subject = inspectee format]!

testListViewColumnsEdit
	| inspectee |
	inspectee := ListView show.
	inspectee create.
	
	[| columnsList accessor |
	columnsList := inspectee columnsList.
	"The ListView in D5 has been reimplemented to all columns, including primary, are held in a single collection"
	self assert: columnsList == inspectee allColumns.
	self assert: columnsList size = 1.
	self createInspectorOn: inspectee.
	accessor := self aspectAccessorNamed: #columnsList.
	self assert: accessor value size = 1.
	treePresenter selection: accessor.
	"Even though the aspect is immutable, the value of the accessor should still be that of the original columnsList"
	self assert: accessor value == columnsList.
	self assert: accessor value == inspectee allColumns.
	self assert: inspectee columnsList == columnsList.
	"but, so the editor should be looking at a copy of it"
	self deny: self aspectPresenter listModel list == columnsList.

	"If not looking at a copy, this will fail anyway as the View will think it had two columns all along"
	self aspectPresenter addItem: ListViewColumn new.
	"Should still be looking at a different value to the one stored back by the above."
	self deny: self aspectPresenter listModel list == inspectee columnsList.
	self repaint.
	"The columns list should now have been replaced..."
	self assert: columnsList ~~ inspectee columnsList.
	self assert: inspectee columnsList size = 2.
	"The accessor should still be pulling the value out of its original source"
	self assert: accessor value == inspectee allColumns.
	self deny: self aspectPresenter listModel list == inspectee columnsList.

	"Original should not have been changed"
	self assert: columnsList size = 1.

	"Now add another column"
	columnsList := inspectee columnsList.
	inspectee columnsList.
	"If not looking at a copy, this will fail anyway as the View will think it had two columns all along"
	self aspectPresenter addItem: ListViewColumn new.
	self repaint.
	"The columns list should now have been replaced..."
	self assert: columnsList ~~ inspectee columnsList.
	self assert: inspectee columnsList size = 3.
	"The accessor should still be pulling the value out of its original source"
	self assert: accessor value == inspectee allColumns.

	"And should not be the same as the one the aspect presenter is viewing."
	self aspectPresenter listModel ~~ inspectee columnsList.
	self assert: columnsList size = 2.

	"Delete the midle one"
	columnsList := inspectee columnsList.
	(self aspectPresenter instVarNamed: 'listPresenter') selectionByIndex: 2.
	"If not looking at a copy, this will fail anyway as the View will think it had two columns all along"
	self aspectPresenter removeItem.
	self repaint.
	"The columns list should now have been replaced..."
	self assert: columnsList ~~ inspectee columnsList.
	self assert: columnsList size = 3.
	self assert: inspectee columnsList size = 2.
	"The accessor should still be pulling the value out of its original source"
	self assert: accessor value == inspectee allColumns.
	"And should not be the same as the one the aspect presenter is viewing."
	self aspectPresenter listModel ~~ inspectee columnsList.

	"Now edit the secondary column"
	columnsList := inspectee columnsList.
	self deny: self aspectPresenter listModel == columnsList.
	treePresenter selection: (self aspectAccessorNamed: 2).

	"N.B. Although the list is immutable, and therefore copied, the copy is only shallow 
	 and the keyed sub-aspects are not themselves copied and so will be updated in place.
	 I think that this should probably be changed so that one can state that not only is
	 the collection  itself immutable, but that its keyed sub-aspects are too."
	self assert: treePresenter selection subject last == columnsList last.
	treePresenter view expandAll.
	treePresenter selection: (accessor := self aspectAccessorNamed: #text).
	self assert: accessor value isEmpty.
	self aspectPresenter value: 'Yet more blah'.
	self repaint.
	self assert: accessor value = 'Yet more blah'.
	"Should propagate up and retitle the column"
	self assert: (self getAccessorValueText: (self aspectAccessorNamed: 2)) 
				= 'a ListViewColumn(''Yet more blah'')'.
	"But not the ListView as not primary!!"
	self assert: ('a ListView(*, ''Column 1'')' 
				match: (self getAccessorValueText: (self aspectAccessorNamed: #yourself))).
	self deny: columnsList first text isEmpty.


	"Note that the original will have changed, because the keyed sub-aspects of the columns list are not themselves immutable"
	self assert: inspectee columnsList ~~ columnsList.
	"Obviously the description update should have propagated through"
	self assert: inspectee columnsList last text = accessor value.
	columnsList := inspectee columnsList.
	treePresenter selection: (self aspectAccessorNamed: 2).

	"N.B. Although the list is immutable, and therefore copied, the copy is only shallow 
	 and the keyed sub-aspects are not themselves copied and so will be updated in place.
	 I think that this should probably be changed so that one can state that not only is
	 the collection  itself immutable, but that its keyed sub-aspects are too."
	self assert: treePresenter selection subject last == columnsList last.
	treePresenter collapse: (self aspectAccessorNamed: 2).

	"Now edit the primary column"
	columnsList := inspectee columnsList.
	treePresenter selection: (self aspectAccessorNamed: 1).
	treePresenter view expandAll.
	treePresenter selection: (accessor := self aspectAccessorNamed: #text).
	self assert: accessor value = 'Column 1'.
	self aspectPresenter value: 'Blah blah'.
	self repaint.
	self assert: accessor value = 'Blah blah'.
	"Should propagate up and retitle the column"
	self assert: (self getAccessorValueText: (self aspectAccessorNamed: 1)) 
				= 'a ListViewColumn(''Blah blah'')'.
	"And the ListView!!"
	self assert: ('a ListView(*, ''Blah blah'')' match: (self getAccessorValueText: (self aspectAccessorNamed: #yourself))).

	"Should also have propagated into the View's menu, which should have been replaced"

	"Note that the original will have changed, because the keyed sub-aspects of the columns list are not themselves immutable"
	self deny: columnsList first text = 'Column 1'.
	self assert: inspectee columnsList ~~ columnsList.
	"Obviously the description update should have propagated through"
	self assert: inspectee columnsList first text = accessor value] 
			ensure: [inspectee topView destroy]!

testMoveDown
	self createInspectorOn: nil.
	(Array 
		with: Array
		with: ByteArray
		with: OrderedCollection) do: [:each | self seqCollMoveDownTest: each]!

testMoveFirst
	self createInspectorOn: nil.
	(Array 
		with: Array
		with: ByteArray
		with: OrderedCollection) do: [:each | self seqCollMoveFirstTest: each]!

testMoveLast
	self createInspectorOn: nil.
	(Array 
		with: Array
		with: ByteArray
		with: OrderedCollection) do: [:each | self seqCollMoveLastTest: each]!

testMoveUp
	self createInspectorOn: nil.
	(Array 
		with: Array
		with: ByteArray
		with: OrderedCollection) do: [:each | self seqCollMoveUpTest: each]!

testPublishedAspectsOfInstancesOnClassSide
	"#2136"
	(Smalltalk developmentSystem definitionsOf: #publishedAspectsOfInstances) 
		methodsDo: [:each | self assert: each methodClass isMeta]!

testRefresh
	| inspectee roots children |
	inspectee := 1 @ 2 corner: 3 @ 4.
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount == 5.
	inspector refresh.
	self assert: treePresenter view itemCount == 5!

testRemoveCollectionElements1
	| inspectee inner listPresenter root |
	inner := OrderedCollection 
				with: 1
				with: 2
				with: 3.
	inspectee := OrderedCollection with: inner.
	self createInspectorOn: inspectee.
	self repaint.
	self assert: treePresenter view itemCount = 2.
	root := treePresenter model roots first.
	treePresenter selection: (treePresenter model childrenOf: root) first.
	self assert: treePresenter view itemCount = 2.
	treePresenter view expandAll.
	self assert: treePresenter view itemCount = 5.
	listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
	listPresenter selectionByIndex: 2.
	self aspectPresenter removeItem.
	self repaint.
	self aspectPresenter removeItem.
	self repaint.
	self aspectPresenter removeItem.
	self repaint!

testRootAspectVisible
	| inspectee roots children |
	inspectee := 1 @ 2 corner: 3 @ 4.
	self createInspectorOn: inspectee.
	inspector isRootAspectVisible: false.
	self assert: treePresenter view itemCount == 4.
	roots := treePresenter model roots.
	self assert: (roots collect: [:each | each name]) asArray = #(#bottom #left #right #top).
	inspector isRootAspectVisible: true.
	self assert: treePresenter view itemCount == 5.
	roots := treePresenter model roots.
	children := treePresenter model childrenOf: roots first.
	self assert: roots size = 1.
	self assert: children size = 4.
	self assert: (children collect: [:each | each name]) asArray = #(#bottom #left #right #top)!

testSetToNil
	| inspectee listPresenter root |
	inspectee := OrderedCollection with: 1 @ 2.
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount == 2.
	self repaint.
	listPresenter := self aspectPresenter instVarNamed: 'listPresenter'.
	self assert: treePresenter view itemCount == 2.
	treePresenter view expandAll.
	self repaint.
	self assert: treePresenter view itemCount == 4.
	root := treePresenter model roots first.
	treePresenter selection: (treePresenter model childrenOf: root) first.
	inspector setAspectValue: nil.
	self assert: treePresenter view itemCount == 2.
	self repaint! !
!PublishedAspectInspectorTest categoriesFor: #aspectAccessorNamed:!helpers!private! !
!PublishedAspectInspectorTest categoriesFor: #aspectPresenter!accessing!private! !
!PublishedAspectInspectorTest categoriesFor: #createInspectorOn:!helpers!private! !
!PublishedAspectInspectorTest categoriesFor: #getAccessorKeyText:!private!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #getAccessorValueText:!private!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #isUsingListTreeView!private! !
!PublishedAspectInspectorTest categoriesFor: #repaint!helpers!private! !
!PublishedAspectInspectorTest categoriesFor: #seqCollMoveDownTest:!helpers!private! !
!PublishedAspectInspectorTest categoriesFor: #seqCollMoveFirstTest:!helpers!private! !
!PublishedAspectInspectorTest categoriesFor: #seqCollMoveLastTest:!helpers!private! !
!PublishedAspectInspectorTest categoriesFor: #seqCollMoveUpTest:!helpers!private! !
!PublishedAspectInspectorTest categoriesFor: #tearDown!public!running! !
!PublishedAspectInspectorTest categoriesFor: #testAddRemoveCollectionElement!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testAspectChanged!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testContextMenuEdit!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testCopyAndPasteMenu!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testImmutableAspect!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testImmutableAspect2!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testListViewColumnsEdit!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testMoveDown!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testMoveFirst!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testMoveLast!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testMoveUp!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testPublishedAspectsOfInstancesOnClassSide!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testRefresh!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testRemoveCollectionElements1!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testRootAspectVisible!public!unit tests! !
!PublishedAspectInspectorTest categoriesFor: #testSetToNil!public!unit tests! !

