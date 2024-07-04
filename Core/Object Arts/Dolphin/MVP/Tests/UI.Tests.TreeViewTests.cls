"Filed out from Dolphin Smalltalk"!

UI.Tests.SelectableTreeItemsTest
	subclass: #'UI.Tests.TreeViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.TreeViewTest guid: (Core.GUID fromString: '{9f22e0fe-4151-461c-a92a-f1d9f25e6605}')!

UI.Tests.TreeViewTest comment: ''!

!UI.Tests.TreeViewTest categoriesForClass!Unclassified! !

!UI.Tests.TreeViewTest methodsFor!

classToTest
	^TreeView!

getItemText: anObject
	| treeView |
	treeView := presenter view.
	^treeView getItemText: (treeView handleFromObject: anObject)!

paintTree
	false
		ifTrue: 
			[(presenter view)
				invalidate;
				update]!

refreshTree: aSymbol
	| tvItem child root text |
	presenter hasLinesAtRoot: true.
	presenter view updateMode: aSymbol.
	root := '1' -> 1.
	presenter model addRoot: root.
	child := '1.1' -> 2.
	presenter model add: child asChildOf: root.
	presenter view expandAll: root.
	self paintTree.
	tvItem := self getItemText: root.
	text := root displayString.
	self assert: (self getItemText: root) equals: text.
	root value: 3.
	presenter view updateMode == #dynamic
		ifFalse: 
			[self assert: (self getItemText: root) equals: text.
			self paintTree.
			self assert: (self getItemText: root) equals: text]
		ifTrue: 
			["Just re-requesting the text is sufficient to get it to redisplay"
			self assert: (self getItemText: root) equals: root displayString].
	presenter model refreshTree: root.
	self assert: (self getItemText: root) equals: root displayString.
	self paintTree!

testCollapseOneLevel
	presenter hasLinesAtRoot: true.
	presenter model: (TreeModel withRoots: #('1') searchPolicy: SearchPolicy equality).
	presenter model add: '1.1' asChildOf: '1'.
	presenter view expandAll: '1'.
	presenter model collapse: '1'.
	self paintTree!

testCollapseTwoLevels
	presenter hasLinesAtRoot: true.
	presenter model: (TreeModel withRoots: #('1') searchPolicy: SearchPolicy equality).
	presenter model add: '1.1' asChildOf: '1'.
	#('1.1.1' '1.1.2') do: [:each | presenter model add: each asChildOf: '1.1'].
	presenter view expandAll: '1'.
	self
		assert: (presenter isExpanded: '1');
		assert: (presenter isExpanded: '1.1');
		yourself.
	presenter model collapse: '1.1'.
	self
		paintTree;
		assert: (presenter isExpanded: '1');
		deny: (presenter isExpanded: '1.1');
		yourself.
	presenter model collapse: '1'.
	self paintTree
		deny: (presenter isExpanded: '1');
		deny: (presenter isExpanded: '1.1');
		yourself.
!

testRefreshTreeDynamic
	self refreshTree: #dynamic!

testRefreshTreeLazy
	"Just re-requesting the text is sufficient to get it to redisplay"

	self refreshTree: #lazy!

testRefreshTreeStatic
	"Just re-requesting the text is sufficient to get it to redisplay"

	self refreshTree: #static!

testSelectionSetter
	| object1 object2 |
	object1 := '1'.
	presenter model: (TreeModel withRoots: (Array with: object1) searchPolicy: SearchPolicy equality).
	self assert: (object2 := presenter selection: object1) identicalTo: object1!

testSelectionsPreservedOnRecreate
	| root child |
	presenter hasLinesAtRoot: true.
	root := '1'.
	presenter model addRoot: root.
	child := '1.1'.
	presenter model add: child asChildOf: root.
	presenter selection: child.
	presenter recreate.
	self assert: presenter selection equals: child
!

testSetImageBlockDoesNotAffectSelection
	presenter view class updateModes do: 
			[:each | 
			presenter view updateMode: each.
			super testSetImageBlockDoesNotAffectSelection.
			presenter view model clear]!

testSetTextBlockDoesNotAffectSelection
	presenter view class updateModes do: 
			[:each | 
			presenter view updateMode: each.
			super testSetTextBlockDoesNotAffectSelection.
			presenter view model clear]!

testViewModes
	| dpi canvas minHeight |
	dpi := presenter monitor dpi.
	presenter model: (TreeModel withRoots: {Object} searchPolicy: SearchPolicy identity).
	{Behavior. View. Magnitude} do: [:each | presenter model add: each asChildOf: Object].
	presenter model
		add: ArithmeticValue asChildOf: Magnitude;
		add: Number asChildOf: ArithmeticValue.
	presenter expandAll.
	canvas := presenter canvas.
	canvas font: presenter actualFont.
	"The minimum height is determined by the font height, plus a 1 pixel border, rounded to even"
	minHeight := canvas textMetrics tmHeight + 2 roundTo: 2.
	canvas free.
	presenter class viewModes keysAndValuesDo: 
			[:eachKey :eachValue |
			"Skip extra large icons as these will be particularly expensive to populate into the icon image manager"
			eachKey == #extraLargeIcons
				ifFalse: 
					[| expectedExtent |
					presenter viewMode: eachKey.
					self assert: presenter imageExtent equals: eachValue.
					expectedExtent := Icon standardSizeFor: eachValue * dpi // USER_DEFAULT_SCREEN_DPI.
					self assert: presenter scaledImageExtent equals: expectedExtent.
					self assert: presenter itemHeight equals: (expectedExtent y max: minHeight)]]!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view updateMode identicalTo: #dynamic.
	self assertIsNil: view customDrawBlock.
	self assert: view largeIconExtent equals: SystemMetrics default largeIconExtent.
	self assert: view isExpandAllEnabled.
	self assert: view isVirtual.
	anInteger < 13
		ifTrue: [self assert: self view indentSeparation equals: 16 * self view dpi // USER_DEFAULT_SCREEN_DPI]! !

!UI.Tests.TreeViewTest categoriesForMethods!
classToTest!helpers!private! !
getItemText:!helpers!private! !
paintTree!helpers!private! !
refreshTree:!helpers!private! !
testCollapseOneLevel!public!unit tests! !
testCollapseTwoLevels!public!unit tests! !
testRefreshTreeDynamic!public!unit tests! !
testRefreshTreeLazy!public!unit tests! !
testRefreshTreeStatic!public!unit tests! !
testSelectionSetter!public!unit tests! !
testSelectionsPreservedOnRecreate!public!unit tests! !
testSetImageBlockDoesNotAffectSelection!public!unit tests! !
testSetTextBlockDoesNotAffectSelection!public!unit tests! !
testViewModes!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.TreeViewTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.TreeView) 98 27 0 0 98 2 8 1409351719 1025 416 590918 3 ##(Smalltalk.TreeModel) 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 98 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294903619 459270 ##(Smalltalk.Message) 8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract) 1049670 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 234 240 608 17 8 #noIcons 1 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 962 401 571 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 63 6 0 0 39 1 0 0] 98 0 962 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TreeView) 34 27 nil nil 34 2 8 1409352231 1025 416 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903706176 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 592 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 592 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 882 401 571 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 71 8 0 0 39 1 0 0] 8 #() 882 193 193 nil 27 )! !

!UI.Tests.TreeViewTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

