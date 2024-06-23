"Filed out from Dolphin Smalltalk"!

ProfilerPresenter subclass: #ProfilerTreesPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProfilerTreesPresenter guid: (GUID fromString: '{425d0eb6-542e-11d3-998b-d5ca2c3c1d61}')!

ProfilerTreesPresenter comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ProfilerTreesPresenter categoriesForClass!IDB Goodies! !

!ProfilerTreesPresenter methodsFor!

collapse
	"Collapse the tree one level starting at the current node"

	| presenter |
	presenter := self treePresenter.
	presenter hasSelection ifTrue: [presenter collapse: presenter selection]!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	self add: (TreePresenter new model: (VirtualTreeModel withRoots: OrderedCollection new))
		name: 'tree'.
	self add: MethodWorkspace new name: 'workspace'.
	self add: SmalltalkWorkspace new name: 'disassembly'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self treePresenter 
		when: #selectionChanged
		send: #onSelectionChanged
		to: self!

expand
	"Expand the tree one level starting at the current node"

	| presenter |
	presenter := self treePresenter.
	presenter hasSelection ifTrue: [presenter expand: presenter selection]!

filterDolphin: aBoolean 
	"Answers true if the filter is on and the node is not part of a branch that
	only contains nodes in the Dolphin package"

	dolphinFilter := [:o | (aBoolean and: [o isDolphinBranch]) not].
	super filterChanged!

filterPercentage: aFloat 
	"Set the percentage figure for the tree"

	percentageFilter := [:o | (self treeValueFor: o) > (aFloat / 100.0 * self total) truncated].
	super filterChanged!

filterSelector: aCompiledCodeOrNil 
	"Answer true if this node shold be displayed for the selector filter.
	Answers true if
		aCompiledCodeOrNil is nil - the filter is off so show all.
		ACompiledCodeOrNil matches the class/selector for this node"

	selectorFilter := aCompiledCodeOrNil isNil 
				ifTrue: [[:o | true]]
				ifFalse: 
					[(aCompiledCodeOrNil isKindOf: CompiledMethod) 
						ifTrue: [[:o | o isParentOfFrameFor: aCompiledCodeOrNil]]
						ifFalse: [[:o | false]]].
	super filterChanged!

onSelectionChanged
	"The frame selection has changed so update the source view accordingly"

	| sourceText sourceSelectionRange disassemblyText disassemblySelectionLine styler |
	self selectionOrNil
		ifNil: 
			[sourceText := String new.
			sourceSelectionRange := 0 to: 0.
			disassemblyText := String new.
			disassemblySelectionLine := 0.
			styler := NullScintillaStyler]
		ifNotNil: 
			[:arg |
			sourceText := arg object coloredSource.
			sourceSelectionRange := arg object selectionRange.
			disassemblyText := arg object disassemblySource.
			disassemblySelectionLine := arg object disassemblySelectionLine.
			styler := arg object compiledCode stylerClass].
	self workspacePresenter
		text: sourceText;
		stylerClass: styler;
		selectionRange: sourceSelectionRange.
	(self presenterNamed: 'disassembly') text: disassemblyText.
	disassemblySelectionLine ~~ 0
		ifTrue: [(self presenterNamed: 'disassembly') selectLine: disassemblySelectionLine]!

onViewOpened
	"Set the getImageBlock and getTExtBlocks for the receiver. These are done here, rather
	than in the ViewComposer as normal, as two types of tree use the same view and we need to
	discriminate between them in the getTextBlock"

	super onViewOpened.
	self workspacePresenter view isReadOnly: true.
	(self treePresenter view)
		getImageBlock: [:o | o object icon imageIndex];
		getTextBlock: 
				[:o | 
				| stream count |
				count := self treeValueFor: o.
				stream := String writeStream.
				ProfileBrowser showCounts 
					ifTrue: 
						[stream
							print: count;
							space].
				stream
					nextPut: $(;
					print: (count asPercentageOf: self total);
					nextPutAll: '%)';
					space.
				o hasChildren 
					ifTrue: [stream print: o firstChild object]
					ifFalse: 
						[stream
							nextPutAll: 'Primitive in ';
							print: o object].
				stream contents]!

selectedMethod
	^self selectionOrNil ifNotNil: [:node | node object compiledCode]!

selectionOrNil
	^self treePresenter selectionOrNil!

total
	"Answer the total number of items for this type of tree"

	self subclassResponsibility!

treePresenter
	^self presenterNamed: 'tree'!

treeValueFor: aProfilerTreeNode 
	"Answers the value of the field for the receiver's type of tree"

	self subclassResponsibility!

update
	"One of the filters has changed so redraw the tree taking the new filter into account. 
	Try to retain the current selection if possible"

	| presenter selection |
	selection := (presenter := self treePresenter) selectionOrNil.
	(presenter model)
		roots: self model rootNodes;
		filter: [:o | self filter: o].
	selection notNil ifTrue: [presenter selection: selection ifAbsent: []]!

workspacePresenter
	^self presenterNamed: 'workspace'! !

!ProfilerTreesPresenter categoriesForMethods!
collapse!commands-actions!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
expand!commands-actions!public! !
filterDolphin:!filtering!public! !
filterPercentage:!filtering!public! !
filterSelector:!filtering!public! !
onSelectionChanged!event handling!public! !
onViewOpened!event handling!public! !
selectedMethod!public!selection! !
selectionOrNil!public!selection! !
total!accessing!public! !
treePresenter!accessing!public! !
treeValueFor:!accessing!public! !
update!public!updating! !
workspacePresenter!accessing!public! !
!

!ProfilerTreesPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 917510 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 1376774 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil 496 nil 5 461638 4 ##(Smalltalk.Menu) nil true 34 1 1180742 2 ##(Smalltalk.CommandMenuItem) 1 1377606 4 ##(Smalltalk.CommandDescription) #browseIt 8 'Bro&wse <d:It>' 1 17 852806 4 ##(Smalltalk.Icon) nil true 2819078 ##(Smalltalk.ImageFromStringResourceInitializer) 8 'ClassBrowserShell.ico' 2490894 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1707078 1 ##(Smalltalk.DraggableViewInteractor) 576 nil 1 #left nil nil nil 918022 ##(Smalltalk.Point) 1 1 946 9 9 nil 960 nil 1310982 ##(Smalltalk.MessageSequence) 34 2 1049350 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 946 1 227 946 701 7 576 1042 #contextMenu: 34 1 656 576 1179910 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 113 0 0 0 94 1 0 0 116 0 0 0] 8 #() 946 193 193 nil 27 1 true 170 192 34 2 410 ##(Smalltalk.TreeView) 34 27 nil 416 34 2 8 1140916775 1025 1264 787526 3 ##(Smalltalk.TreeModel) nil 1769478 ##(Smalltalk.IdentitySearchPolicy) 721670 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 496 nil 5 642 nil true 34 4 690 1 722 #expand 8 'Expand' 591 1 nil nil nil 690 1 722 #collapse 8 'Collapse' 587 1 nil nil nil 1179974 1 ##(Smalltalk.DividerMenuItem) 4097 690 1 722 #browseIt 8 'Bro&wse <d:It>' 1 17 770 nil true 802 8 'ClassBrowserShell.ico' 864 65541 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 1264 nil 8 1840320464 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1639750 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 1440 nil #smallIcons 1 170 192 1440 994 34 2 1042 #createAt:extent: 34 2 946 1 1 946 701 227 1264 1042 #contextMenu: 34 1 1456 1264 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 113 0 0 0] 8 #() 1216 nil 27 8 'tree' nil 994 34 1 1042 #createAt:extent: 34 2 946 12287 21 946 701 461 416 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 93 25 0 0 240 0 0 0] 34 3 1264 576 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1140850688 131073 2144 nil 496 nil 5 nil nil nil 2144 853318 1 ##(Smalltalk.CardLayout) 138 144 34 2 1049094 ##(Smalltalk.Association) 8 'Workspace' 410 ##(Smalltalk.ReferenceView) 34 14 nil 2144 34 2 8 1140850688 131073 2320 nil nil nil 5 nil nil nil 2320 1376838 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 994 34 1 1042 #createAt:extent: 34 2 946 9 53 946 685 169 2320 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 110 0 0 0] 1440 1216 nil 27 2274 8 'Disassembly' 410 ##(Smalltalk.ReferenceView) 34 14 nil 2144 34 2 8 1140850688 131073 2576 nil nil nil 5 nil nil nil 2576 2386 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 994 34 1 1042 #createAt:extent: 34 2 946 9 53 946 685 169 2576 1154 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 110 0 0 0] 1440 1216 nil 27 2320 nil nil nil 170 192 34 4 2320 8 'workspace' 2576 8 'disassembly' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 2144 34 2 8 1140916736 1 2848 787270 2 ##(Smalltalk.ListModel) 138 144 34 2 2304 2560 nil 1376 482 #face3d nil 1 nil nil nil 2848 nil 8 1840356208 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1760 nil nil nil nil nil #noIcons nil nil nil nil nil 994 34 3 1042 #createAt:extent: 34 2 946 1 1 946 701 229 2848 1042 #setSingleSelection: 8 #(1) 2848 1042 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 2848 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 114 0 0 0] 8 #() 1216 nil 27 994 34 1 1042 #createAt:extent: 34 2 946 1 233 946 701 229 2144 1154 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 116 0 0 0 94 1 0 0 230 0 0 0] 34 3 2320 2576 2848 1216 nil 27 1216 nil 27 )! !

!ProfilerTreesPresenter class categoriesForMethods!
resource_Default_view!public!resources-views! !
!

