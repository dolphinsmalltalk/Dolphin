"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #PublishedAspectInspectorTest
	instanceVariableNames: 'treePresenter displayPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PublishedAspectInspectorTest guid: (GUID fromString: '{26c95677-a861-4030-8d8e-b6bed0a6c3ef}')!

PublishedAspectInspectorTest comment: ''!

!PublishedAspectInspectorTest categoriesForClass!Unclassified! !

!PublishedAspectInspectorTest methodsFor!

aspectAccessorNamed: aSymbol
	^treePresenter view displayedContents detect: [:each | each name == aSymbol]!

aspectPresenter
	^presenter instVarNamed: 'aspectPresenter'!

classToTest
	^PublishedAspectInspector!

createInspectorOn: inspectee
	presenter
		ifNil: 
			[presenter := PublishedAspectInspector shellOn: inspectee.
			treePresenter := presenter instVarNamed: 'aspectTreePresenter'.
			displayPresenter := presenter instVarNamed: 'displayPresenter'.
			treePresenter selection: treePresenter model roots first]
		ifNotNil: [presenter value: inspectee]!

getAccessorKeyText: anAspectAccessor 
	^treePresenter view getItemText: (treePresenter view handleFromObject: anAspectAccessor)!

getAccessorValueText: anAspectAccessor 
	^(treePresenter view columnAtIndex: 2) getTextBlock value: anAspectAccessor!

isUsingListTreeView
	"Private - Answer true if the PAI is using a ListTreeView rather than the older style TreeView"

	^(Smalltalk lookup: #ListTreeView)
		ifNil: [false]
		ifNotNil: [:ltv | treePresenter view isKindOf: ltv]!

repaint
	false
		ifTrue: 
			[presenter view update.
			Processor sleep: 1500 milliseconds]!

seqCollMoveDownTest: testClass
	| inspectee collection |
	inspectee := testClass withAll: (1 to: 3).
	self createInspectorOn: inspectee.
	collection := inspectee.
	treePresenter selection: treePresenter model roots first.
	self repaint.
	0 to: 1
		do: 
			[:j |
			| listPresenter |
			self assert: treePresenter view itemCount identicalTo: collection size + 1 + j.
			listPresenter := self aspectPresenter listPresenter.
			listPresenter selectionByIndex: 1.
			2 to: 3
				do: 
					[:i |
					self aspectPresenter moveDown.
					self repaint.
					self assert: treePresenter view itemCount identicalTo: collection size + 1 + j.
					self assert: listPresenter selectionByIndex equals: i.
					self assert: collection asArray equals: (2 to: i) , {1} , (i + 1 to: 3)].
			"Repeat with a nested collection"
			collection := testClass withAll: (1 to: 3).
			inspectee := {collection}.
			presenter value: inspectee.
			treePresenter selection: (treePresenter model childrenOf: treePresenter model roots first) first.
			treePresenter view expandAll]!

seqCollMoveFirstTest: testClass
	| inspectee expected |
	inspectee := testClass withAll: (1 to: 5).
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount identicalTo: 5 + 1.
	self repaint.
	expected := #(#(1 2 3 4 5) #(2 1 3 4 5) #(3 2 1 4 5) #(4 3 2 1 5) #(5 4 3 2 1)).
	1 to: inspectee size
		do: 
			[:i |
			| listPresenter |
			listPresenter := self aspectPresenter listPresenter.
			listPresenter selectionByIndex: i.
			self aspectPresenter moveFirst.
			self repaint.
			self assert: treePresenter view itemCount identicalTo: 5 + 1.
			self assert: listPresenter selectionByIndex equals: 1.
			self assert: inspectee asArray equals: (expected at: i)]!

seqCollMoveLastTest: testClass
	| inspectee expected |
	inspectee := testClass withAll: (1 to: 5).
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount identicalTo: 5 + 1.
	self repaint.
	expected := #(#(2 3 4 5 1) #(2 4 5 1 3) #(2 4 1 3 5) #(2 4 1 5 3) #(2 4 1 5 3)).
	1 to: inspectee size
		do: 
			[:i |
			| listPresenter |
			listPresenter := self aspectPresenter listPresenter.
			listPresenter selectionByIndex: i.
			self aspectPresenter moveLast.
			self repaint.
			self assert: treePresenter view itemCount identicalTo: 5 + 1.
			self assert: listPresenter selectionByIndex equals: 5.
			self assert: inspectee asArray equals: (expected at: i)]!

seqCollMoveUpTest: testClass
	| inspectee listPresenter |
	inspectee := testClass withAll: (1 to: 5).
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount identicalTo: 6.
	self repaint.
	listPresenter := self aspectPresenter listPresenter.
	listPresenter selectionByIndex: 5.
	4 to: 1
		by: -1
		do: 
			[:i |
			self aspectPresenter moveUp.
			self repaint.
			self assert: inspectee asArray equals: (1 to: i - 1) , {5} , (i to: 5 - 1).
			self assert: listPresenter selectionByIndex equals: i.
			self assert: treePresenter view itemCount identicalTo: 5 + 1]!

shouldSetupPresenter
	^false!

tearDown
	treePresenter := displayPresenter := nil.
	super tearDown!

testAddRemoveCollectionElement
	| inspectee listPresenter |
	inspectee := OrderedCollection new.
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount identicalTo: 1.
	self repaint.
	listPresenter := self aspectPresenter listPresenter.
	self aspectPresenter addItem: 1.
	"The item always remains expanded"
	self assert: treePresenter view itemCount identicalTo: 2.
	treePresenter view expandAll.
	self repaint.
	self assert: treePresenter view itemCount identicalTo: 2.
	listPresenter selectionByIndex: 1.
	self aspectPresenter removeItem.
	self assert: treePresenter view itemCount identicalTo: 1.
	self repaint.
	self aspectPresenter addItem: 1.
	listPresenter selectionByIndex: 1.
	self aspectPresenter addItem: 2.
	"The item always remains expanded"
	self assert: treePresenter view itemCount identicalTo: 3.
	self repaint.
	self aspectPresenter removeItem.
	self aspectPresenter removeItem.
	self assert: treePresenter view itemCount identicalTo: 1.
	self repaint!

testAspectChanged
	| inspectee accessors tvItem hItem |
	inspectee := Association new.
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount identicalTo: 3.
	self repaint.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	self assert: (self getAccessorKeyText: accessors first) equals: 'key'.
	self assert: (self getAccessorValueText: accessors first) equals: 'nil'.
	self assert: (self getAccessorKeyText: accessors last) equals: 'value'.
	self assert: (self getAccessorValueText: accessors last) equals: 'nil'.
	"Set key to a scalar"
	inspectee key: 1.
	presenter aspectChanged: #key of: inspectee.
	self repaint.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	self assert: (self getAccessorKeyText: accessors first) equals: 'key'.
	self assert: (self getAccessorValueText: accessors first) equals: '1'.
	self assert: (self getAccessorKeyText: accessors last) equals: 'value'.
	self assert: (self getAccessorValueText: accessors last) equals: 'nil'.
	self assert: treePresenter view itemCount identicalTo: 3.
	"Set back to nil"
	inspectee key: nil.
	presenter aspectChanged: #key of: inspectee.
	self repaint.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	self assert: (self getAccessorKeyText: accessors first) equals: 'key'.
	self assert: (self getAccessorValueText: accessors first) equals: 'nil'.
	self assert: (self getAccessorKeyText: accessors last) equals: 'value'.
	self assert: (self getAccessorValueText: accessors last) equals: 'nil'.
	self assert: treePresenter view itemCount identicalTo: 3.
	"Now set to something with sub-aspects"
	inspectee key: (1 to: 2).
	presenter aspectChanged: #key of: inspectee.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	hItem := treePresenter view handleFromObject: accessors first.
	self assert: (treePresenter view getItemText: hItem) equals: 'key'.
	self assert: (self getAccessorKeyText: accessors last) equals: 'value'.
	self assert: (self getAccessorValueText: accessors last) equals: 'nil'.
	self isUsingListTreeView
		ifFalse: 
			[tvItem := treePresenter view getItemState: hItem.
			self assert: treePresenter view itemCount identicalTo: 3.
			self assert: tvItem cChildren > 0].
	treePresenter expand: accessors first.
	self repaint.
	self assert: treePresenter view itemCount identicalTo: 6.
	"Set back to nil"
	inspectee key: nil.
	presenter aspectChanged: #key of: inspectee.
	self repaint.
	accessors := treePresenter model childrenOf: treePresenter model roots first.
	self assert: (self getAccessorKeyText: accessors first) equals: 'key'.
	self assert: (self getAccessorValueText: accessors first) equals: 'nil'.
	self assert: (self getAccessorKeyText: accessors last) equals: 'value'.
	self assert: (self getAccessorValueText: accessors last) equals: 'nil'.
	self assert: treePresenter view itemCount identicalTo: 3.
	self repaint.
	"Now nil the root"
	inspectee oneWayBecome: nil.
	presenter aspectChanged: #yourself.
	self assert: treePresenter view itemCount identicalTo: 1.
	self repaint!

testCommandMenuItemEditor
	"Simple kick-the-tyres test that inspector in menu item dialog opens without error."

	| dialog cards |
	dialog := (CommandMenuItemDialog createOn: CommandMenuItem new) show.
	cards := dialog view viewNamed: 'cards'.
	cards tabs selectionByIndex: 3.
	dialog view exit!

testContextMenuEdit
	| inspectee |
	inspectee := View new.
	inspectee create.
	
	[| contextMenu accessor items |
	contextMenu := inspectee contextMenu.
	self assertIsNil: contextMenu.
	self createInspectorOn: inspectee.
	accessor := self aspectAccessorNamed: #contextMenu.
	treePresenter selection: accessor.
	self aspectPresenter value: Menu new.
	contextMenu := inspectee contextMenu.
	self denyIsNil: contextMenu.
	self assert: contextMenu isEmpty.
	self repaint.
	accessor := self aspectAccessorNamed: #items.
	treePresenter selection: accessor.
	self assert: accessor value isEmpty.
	self aspectPresenter addItem: CommandMenuItem new.
	accessor := self aspectAccessorNamed: #items.
	self assert: accessor value size equals: 1.
	self deny: contextMenu identicalTo: inspectee contextMenu.
	"Original context menu should not have been changed"
	self assert: contextMenu isEmpty.
	self assert: inspectee contextMenu size equals: 1.
	self deny: inspectee contextMenu items identicalTo: accessor value.
	self assert: inspectee contextMenu items first command identicalTo: accessor value first command.
	treePresenter view expandAll.
	contextMenu := inspectee contextMenu.
	accessor := self aspectAccessorNamed: #description.
	self assert: accessor value equals: 'No Command'.
	treePresenter selection: accessor.
	self aspectPresenter value: 'Blah blah'.
	self assert: accessor value equals: 'Blah blah'.
	"Should propagate up and retitle the item"
	self assert: (self getAccessorValueText: (self aspectAccessorNamed: 1)) equals: 'Blah blah'.
	"Should also have propagated into the View's menu, which should have been replaced, original not changed"
	self assert: contextMenu items first description equals: 'No Command'.
	self deny: inspectee contextMenu identicalTo: contextMenu.
	"Obviously the description update should have propagated through"
	self assert: inspectee contextMenu items first description equals: accessor value.

	"Now try copying and pasting a menu item over a new menu item"
	treePresenter selection: (self aspectAccessorNamed: 1).
	presenter copyAspect.
	accessor := self aspectAccessorNamed: #items.
	treePresenter selection: accessor.
	self aspectPresenter addItem: CommandMenuItem new.
	items := inspectee contextMenu items.
	self assert: items size equals: 2.
	self assert: items last description equals: 'No Command'.
	accessor := self aspectAccessorNamed: 2.
	treePresenter selection: accessor.
	presenter pasteAspect.
	items := inspectee contextMenu items.
	self assert: items size equals: 2.
	"If the paste worked, then the inspectee's second context menu item should have been updated"
	self assert: items last description equals: 'Blah blah']
			ensure: [inspectee destroy]!

testCopyAndPasteMenu
	| inspectee1 inspectee2 |
	inspectee1 := ShellView new.
	inspectee1 create.
	inspectee2 := ShellView new.
	inspectee2 create.
	
	[| menuBar1 accessor menuBar2 fileMenu |
	menuBar1 := MenuBar fromStrings: #(#('&File' 'Open//fileOpen' '-' '&Save/Ctrl+S/fileSave')).
	fileMenu := menuBar1 items single.
	self assert: fileMenu size equals: 3.
	self assert: fileMenu items first text equals: 'Open'.
	inspectee1 menuBar: menuBar1.
	self createInspectorOn: inspectee1.
	accessor := self aspectAccessorNamed: #menuBar.
	treePresenter selection: accessor.
	self assert: accessor value identicalTo: menuBar1.
	self repaint.
	presenter copyAspect.
	presenter value: inspectee2.
	self repaint.
	self assertIsNil: inspectee2 menuBar.
	accessor := self aspectAccessorNamed: #menuBar.
	treePresenter selection: accessor.
	self assertIsNil: accessor value.
	presenter pasteAspect.
	self repaint.
	self denyIsNil: accessor value.
	menuBar2 := inspectee2 menuBar.
	self denyIsNil: menuBar2.
	self deny: menuBar1 identicalTo: menuBar2.
	self assert: menuBar2 size equals: 1.
	fileMenu := menuBar2 items single.
	self assert: fileMenu items first text equals: 'Open']
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
	self deny: extent identicalTo: originalExtent.
	self assert: extent isZero not.
	self createInspectorOn: inspectee.
	accessor := self aspectAccessorNamed: #extent.
	self assert: accessor isMutable not.
	treePresenter selection: accessor.
	self assert: accessor value equals: extent.
	self deny: accessor value identicalTo: extent.
	treePresenter view expandAll.
	accessor := self aspectAccessorNamed: #y.
	treePresenter selection: accessor.
	self aspectPresenter value: 150.
	self repaint.
	accessor := self aspectAccessorNamed: #y.
	self assert: (self getAccessorKeyText: accessor) equals: 'y'.
	self assert: (self getAccessorValueText: accessor) equals: '150'.
	accessor := self aspectAccessorNamed: #extent.
	self assert: (self getAccessorKeyText: accessor) equals: 'extent'.
	self assert: (self getAccessorValueText: accessor)
		equals: ('<1d>@150' expandMacrosWith: originalExtent x).

	"Note that the original extent object should not have changed"
	self assert: extent equals: originalExtent.
	"But the view's extent should have"
	self deny: inspectee extent identicalTo: extent.
	self assert: inspectee extent y equals: 150.
	"The view must not be referencing the same copy of the immutable object as the aspect tree"
	self deny: accessor value identicalTo: inspectee extent]
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
	self assert: accessor value equals: originalFormat.
	"The value of the accessor is still the original object, but its sub-aspect values should 
	 be pointing at a copy"
	self assert: accessor value identicalTo: originalFormat.
	treePresenter view expandAll.
	accessor := self aspectAccessorNamed: 1.
	self assert: accessor value equals: 'false'.
	self assert: accessor subject equals: originalFormat.
	self deny: accessor subject identicalTo: originalFormat.
	accessor2 := self aspectAccessorNamed: 2.
	self assert: accessor2 value equals: 'true'.
	self assert: accessor2 subject equals: originalFormat.
	self deny: accessor2 subject identicalTo: originalFormat.
	self assert: accessor2 subject identicalTo: accessor subject.
	treePresenter selection: accessor.
	self aspectPresenter value: 'no'.
	self repaint.
	accessor := self aspectAccessorNamed: 1.
	self assert: (self getAccessorKeyText: accessor) equals: '1'.
	self assert: (self getAccessorValueText: accessor) equals: '''no'''.
	accessor := self aspectAccessorNamed: #format.
	self assert: (self getAccessorKeyText: accessor) equals: 'format'.
	self assert: (self getAccessorValueText: accessor) equals: 'an Array'.

	"Note that the original object should not have changed"
	self assert: originalFormat equals: #('false' 'true').
	"But the inspectee's should have"
	self deny: inspectee format identicalTo: originalFormat.
	self assert: inspectee format equals: #('no' 'true').
	"The inspectee should still be referencing the same copy of the immutable object as the aspect tree,
	but again not the sub-aspects"
	self assert: accessor value identicalTo: inspectee format.
	1 to: 2
		do: 
			[:i |
			| each |
			each := self aspectAccessorNamed: i.
			self deny: each subject identicalTo: inspectee format.
			self assert: each subject equals: inspectee format].

	"Now update the other sub-aspect"
	accessor2 := self aspectAccessorNamed: 2.
	self assert: accessor2 value equals: 'true'.
	self deny: accessor2 subject equals: originalFormat.
	self deny: accessor2 subject identicalTo: originalFormat.
	accessor := self aspectAccessorNamed: 1.
	self assert: accessor2 subject identicalTo: accessor subject.
	treePresenter selection: accessor2.
	self aspectPresenter value: 'yes'.
	self repaint.
	accessor := self aspectAccessorNamed: 2.
	self assert: (self getAccessorKeyText: accessor2) equals: '2'.
	self assert: (self getAccessorValueText: accessor2) equals: '''yes'''.
	accessor := self aspectAccessorNamed: #format.
	self assert: (self getAccessorKeyText: accessor) equals: 'format'.
	self assert: (self getAccessorValueText: accessor) equals: 'an Array'.

	"Note that the original object should not have changed"
	self assert: originalFormat equals: #('false' 'true').
	"But the inspectee's should have"
	self deny: inspectee format identicalTo: originalFormat.
	self assert: inspectee format equals: #('no' 'yes').
	"The inspectee should still be referencing the same copy of the immutable object as the aspect tree,
	but again not the sub-aspects"
	self assert: accessor value identicalTo: inspectee format.
	1 to: 2
		do: 
			[:i |
			| each |
			each := self aspectAccessorNamed: i.
			self deny: each subject identicalTo: inspectee format.
			self assert: each subject equals: inspectee format]!

testListViewColumnsEdit
	| inspectee |
	inspectee := ListView show.
	inspectee create.
	
	[| columnsList accessor |
	columnsList := inspectee columnsList.
	"The ListView in D5 has been reimplemented to all columns, including primary, are held in a single collection"
	self assert: columnsList identicalTo: inspectee allColumns.
	self assert: columnsList size equals: 1.
	self createInspectorOn: inspectee.
	accessor := self aspectAccessorNamed: #columnsList.
	self assert: accessor value size equals: 1.
	treePresenter selection: accessor.
	"Even though the aspect is immutable, the value of the accessor should still be that of the original columnsList"
	self assert: accessor value identicalTo: columnsList.
	self assert: accessor value identicalTo: inspectee allColumns.
	self assert: inspectee columnsList identicalTo: columnsList.
	"but, so the editor should be looking at a copy of it"
	self deny: self aspectPresenter listModel list identicalTo: columnsList.

	"If not looking at a copy, this will fail anyway as the View will think it had two columns all along"
	self aspectPresenter addItem: ListViewColumn new.
	"Should still be looking at a different value to the one stored back by the above."
	self deny: self aspectPresenter listModel list identicalTo: inspectee columnsList.
	self repaint.
	"The columns list should now have been replaced..."
	self deny: columnsList identicalTo: inspectee columnsList.
	self assert: inspectee columnsList size equals: 2.
	"The accessor should still be pulling the value out of its original source"
	self assert: accessor value identicalTo: inspectee allColumns.
	self deny: self aspectPresenter listModel list identicalTo: inspectee columnsList.

	"Original should not have been changed"
	self assert: columnsList size equals: 1.

	"Now add another column"
	columnsList := inspectee columnsList.
	inspectee columnsList.
	"If not looking at a copy, this will fail anyway as the View will think it had two columns all along"
	self aspectPresenter addItem: ListViewColumn new.
	self repaint.
	"The columns list should now have been replaced..."
	self deny: columnsList identicalTo: inspectee columnsList.
	self assert: inspectee columnsList size equals: 3.
	"The accessor should still be pulling the value out of its original source"
	self assert: accessor value identicalTo: inspectee allColumns.

	"And should not be the same as the one the aspect presenter is viewing."
	self aspectPresenter listModel ~~ inspectee columnsList.
	self assert: columnsList size equals: 2.

	"Delete the midle one"
	columnsList := inspectee columnsList.
	self aspectPresenter listPresenter selectionByIndex: 2.
	"If not looking at a copy, this will fail anyway as the View will think it had two columns all along"
	self aspectPresenter removeItem.
	self repaint.
	"The columns list should now have been replaced..."
	self deny: columnsList identicalTo: inspectee columnsList.
	self assert: columnsList size equals: 3.
	self assert: inspectee columnsList size equals: 2.
	"The accessor should still be pulling the value out of its original source"
	self assert: accessor value identicalTo: inspectee allColumns.
	"And should not be the same as the one the aspect presenter is viewing."
	self aspectPresenter listModel ~~ inspectee columnsList.

	"Now edit the secondary column"
	columnsList := inspectee columnsList.
	self deny: self aspectPresenter listModel identicalTo: columnsList.
	treePresenter selection: (self aspectAccessorNamed: 2).

	"N.B. Although the list is immutable, and therefore copied, the copy is only shallow 
	 and the keyed sub-aspects are not themselves copied and so will be updated in place.
	 I think that this should probably be changed so that one can state that not only is
	 the collection  itself immutable, but that its keyed sub-aspects are too."
	self assert: treePresenter selection subject last identicalTo: columnsList last.
	treePresenter view expandAll.
	treePresenter selection: (accessor := self aspectAccessorNamed: #text).
	self assert: accessor value isEmpty.
	self aspectPresenter value: 'Yet more blah'.
	self repaint.
	self assert: accessor value equals: 'Yet more blah'.
	"Should propagate up and retitle the column"
	self assert: (self getAccessorValueText: (self aspectAccessorNamed: 2))
		equals: 'a ListViewColumn(''Yet more blah'')'.
	"But not the ListView as not primary!!"
	self assert: ('a ListView(*, ''Column 1'')'
				match: (self getAccessorValueText: (self aspectAccessorNamed: #yourself))).
	self deny: columnsList first text isEmpty.


	"Note that the original will have changed, because the keyed sub-aspects of the columns list are not themselves immutable"
	self deny: inspectee columnsList identicalTo: columnsList.
	"Obviously the description update should have propagated through"
	self assert: inspectee columnsList last text equals: accessor value.
	columnsList := inspectee columnsList.
	treePresenter selection: (self aspectAccessorNamed: 2).

	"N.B. Although the list is immutable, and therefore copied, the copy is only shallow 
	 and the keyed sub-aspects are not themselves copied and so will be updated in place.
	 I think that this should probably be changed so that one can state that not only is
	 the collection  itself immutable, but that its keyed sub-aspects are too."
	self assert: treePresenter selection subject last identicalTo: columnsList last.
	treePresenter collapse: (self aspectAccessorNamed: 2).

	"Now edit the primary column"
	columnsList := inspectee columnsList.
	treePresenter selection: (self aspectAccessorNamed: 1).
	treePresenter view expandAll.
	treePresenter selection: (accessor := self aspectAccessorNamed: #text).
	self assert: accessor value equals: 'Column 1'.
	self aspectPresenter value: 'Blah blah'.
	self repaint.
	self assert: accessor value equals: 'Blah blah'.
	"Should propagate up and retitle the column"
	self assert: (self getAccessorValueText: (self aspectAccessorNamed: 1))
		equals: 'a ListViewColumn(''Blah blah'')'.
	"And the ListView!!"
	self assert: ('a ListView(*, ''Blah blah'')'
				match: (self getAccessorValueText: (self aspectAccessorNamed: #yourself))).

	"Should also have propagated into the View's menu, which should have been replaced"

	"Note that the original will have changed, because the keyed sub-aspects of the columns list are not themselves immutable"
	self deny: columnsList first text equals: 'Column 1'.
	self deny: inspectee columnsList identicalTo: columnsList.
	"Obviously the description update should have propagated through"
	self assert: inspectee columnsList first text equals: accessor value]
			ensure: [inspectee topView destroy]!

testMoveDown
	{Array. ByteArray. OrderedCollection} do: [:each | self seqCollMoveDownTest: each]!

testMoveFirst
	{Array. ByteArray. OrderedCollection} do: [:each | self seqCollMoveFirstTest: each]!

testMoveLast
	{Array. ByteArray. OrderedCollection} do: [:each | self seqCollMoveLastTest: each]!

testMoveUp
	{Array. ByteArray. OrderedCollection} do: [:each | self seqCollMoveUpTest: each]!

testPublishedAspectsOfInstancesOnClassSide
	"#2136"
	(Smalltalk developmentSystem definitionsOf: #publishedAspectsOfInstances) 
		methodsDo: [:each | self assert: each methodClass isMeta]!

testRefresh
	| inspectee |
	inspectee := 1 @ 2 corner: 3 @ 4.
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount identicalTo: 5.
	presenter refresh.
	self assert: treePresenter view itemCount identicalTo: 5!

testRemoveCollectionElements1
	| inspectee inner listPresenter root |
	inner := OrderedCollection
				with: 1
				with: 2
				with: 3.
	inspectee := OrderedCollection with: inner.
	self createInspectorOn: inspectee.
	self repaint.
	self assert: treePresenter view itemCount equals: 2.
	root := treePresenter model roots first.
	treePresenter selection: (treePresenter model childrenOf: root) first.
	self assert: treePresenter view itemCount equals: 2.
	treePresenter view expandAll.
	self assert: treePresenter view itemCount equals: 5.
	listPresenter := self aspectPresenter listPresenter.
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
	presenter isRootAspectVisible: false.
	self assert: treePresenter view itemCount identicalTo: 4.
	roots := treePresenter model roots.
	self assert: (roots collect: [:each | each name]) asArray equals: #(#bottom #left #right #top).
	presenter isRootAspectVisible: true.
	self assert: treePresenter view itemCount identicalTo: 5.
	roots := treePresenter model roots.
	children := treePresenter model childrenOf: roots first.
	self assert: roots size equals: 1.
	self assert: children size equals: 4.
	self assert: (children collect: [:each | each name]) asArray equals: #(#bottom #left #right #top)!

testSetToNil
	| inspectee root |
	inspectee := OrderedCollection with: 1 @ 2.
	self createInspectorOn: inspectee.
	self assert: treePresenter view itemCount identicalTo: 2.
	self repaint.
	self assert: treePresenter view itemCount identicalTo: 2.
	treePresenter view expandAll.
	self repaint.
	self assert: treePresenter view itemCount identicalTo: 4.
	root := treePresenter model roots first.
	treePresenter selection: (treePresenter model childrenOf: root) first.
	presenter setAspectValue: nil.
	self assert: treePresenter view itemCount identicalTo: 2.
	self repaint!

viewClass
	^ContainerView! !

!PublishedAspectInspectorTest categoriesForMethods!
aspectAccessorNamed:!helpers!private! !
aspectPresenter!accessing!private! !
classToTest!helpers!private! !
createInspectorOn:!helpers!private! !
getAccessorKeyText:!private!unit tests! !
getAccessorValueText:!private!unit tests! !
isUsingListTreeView!private! !
repaint!helpers!private! !
seqCollMoveDownTest:!helpers!private! !
seqCollMoveFirstTest:!helpers!private! !
seqCollMoveLastTest:!helpers!private! !
seqCollMoveUpTest:!helpers!private! !
shouldSetupPresenter!helpers!private! !
tearDown!public!running! !
testAddRemoveCollectionElement!public!unit tests! !
testAspectChanged!public!unit tests! !
testCommandMenuItemEditor!public!unit tests! !
testContextMenuEdit!public!unit tests! !
testCopyAndPasteMenu!public!unit tests! !
testImmutableAspect!public!unit tests! !
testImmutableAspect2!public!unit tests! !
testListViewColumnsEdit!public!unit tests! !
testMoveDown!public!unit tests! !
testMoveFirst!public!unit tests! !
testMoveLast!public!unit tests! !
testMoveUp!public!unit tests! !
testPublishedAspectsOfInstancesOnClassSide!public!unit tests! !
testRefresh!public!unit tests! !
testRemoveCollectionElements1!public!unit tests! !
testRootAspectVisible!public!unit tests! !
testSetToNil!public!unit tests! !
viewClass!constants!private! !
!

!PublishedAspectInspectorTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 2 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.TreeView)  98 27 0 416 98 2 8 1140916259 1 656 590918 3 ##(Smalltalk.TreeModel)  0 1310726 ##(Smalltalk.IdentitySearchPolicy)  525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 98 0 498 528 0 13 265030 4 ##(Smalltalk.Menu)  0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 930 1 962 8 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 930 1 962 8 #browseIt 8 '&Browse It' 1 1 1026 0 16 1072 8 'ClassBrowserShell.ico' 1120 0 0 1218 4097 930 1 962 8 #copyAspect 8 '&Copy' 1 1 0 0 0 930 1 962 8 #pasteAspect 8 '&Paste <1d>' 1 1 0 0 0 1218 4097 930 1 962 8 #editAspect 8 '&Edit' 1 1 0 0 0 930 1 962 8 #nilAspect 8 'Set to &Nil' 1 1 0 0 0 1218 4097 930 1 962 8 #refresh 8 'Re&fresh' 1 1 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 656 0 8 4294903077 459270 ##(Smalltalk.Message)  8 #valueText 98 0 1746 8 #valueImage 1792 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 234 240 848 17 8 #smallIcons 9 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 2034 317 341 656 1970 8 #contextMenu: 98 1 896 656 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 158 0 0 0 170 0 0 0] 98 0 2034 193 193 0 27 3 626 410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 2224 0 498 528 0 517 0 0 0 2224 1906 202 208 98 1 1970 2000 98 2 2034 317 1 2034 19 341 2224 2130 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 158 0 0 0 0 0 0 0 167 0 0 0 170 0 0 0] 98 0 2192 0 27 1 32 234 256 98 4 656 8 'aspects' 410 8 ##(Smalltalk.CardContainer)  98 16 0 416 98 2 8 1140850688 131073 2528 0 721158 ##(Smalltalk.SystemColor)  31 0 5 0 0 0 2528 655878 ##(Smalltalk.CardLayout)  202 208 848 0 234 256 848 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 2528 98 2 8 1140916866 1 2704 590662 2 ##(Smalltalk.ListModel)  202 208 848 0 784 0 0 1 0 0 0 2704 0 8 4294906325 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  1 83886081 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | nil]' 8 #[29 105 60 106] 2864 7 257 0 8 ##(Smalltalk.IconicListAbstract)  1856 0 0 0 0 0 1888 0 0 0 0 0 1906 202 208 98 2 1970 2000 98 2 2034 1 1 2034 317 341 2704 1970 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 2704 2130 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 158 0 0 0 170 0 0 0] 98 0 2192 0 27 1906 202 208 98 1 1970 2000 98 2 2034 335 1 2034 317 341 2528 2130 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 167 0 0 0 0 0 0 0 69 1 0 0 170 0 0 0] 98 1 2704 2192 0 27 8 'display' 0 1906 202 208 98 1 1970 2000 98 2 2034 2799 21 2034 651 341 416 2130 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 188 6 0 0 180 0 0 0] 98 3 656 2224 2528 2192 0 27 )! !

!PublishedAspectInspectorTest class categoriesForMethods!
resource_Default_view_D6!public! !
!

