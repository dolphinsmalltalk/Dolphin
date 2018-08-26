"Filed out from Dolphin Smalltalk 7"!

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
	self selectedNode 
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
	(self workspacePresenter)
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
	^self selectedNode ifNotNil: [:node | node object compiledCode]!

selectedNode
	^self treePresenter selectionOrNil!

total
	"Answer the total number of items for this type of tree"

	self subclassResponsibility!

treePresenter
	^self presenterNamed: 'tree'!

treeValueFor: aProfilerTreeNode 
	"Answers the value of the field for the receivers type of tree"

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
!ProfilerTreesPresenter categoriesFor: #collapse!commands!public! !
!ProfilerTreesPresenter categoriesFor: #createComponents!initializing!public! !
!ProfilerTreesPresenter categoriesFor: #createSchematicWiring!initializing!public! !
!ProfilerTreesPresenter categoriesFor: #expand!commands!public! !
!ProfilerTreesPresenter categoriesFor: #filterDolphin:!filtering!public! !
!ProfilerTreesPresenter categoriesFor: #filterPercentage:!filtering!public! !
!ProfilerTreesPresenter categoriesFor: #filterSelector:!filtering!public! !
!ProfilerTreesPresenter categoriesFor: #onSelectionChanged!event handling!public! !
!ProfilerTreesPresenter categoriesFor: #onViewOpened!event handling!public! !
!ProfilerTreesPresenter categoriesFor: #selectedMethod!event handling!public! !
!ProfilerTreesPresenter categoriesFor: #selectedNode!event handling!public! !
!ProfilerTreesPresenter categoriesFor: #total!accessing!public! !
!ProfilerTreesPresenter categoriesFor: #treePresenter!accessing!public! !
!ProfilerTreesPresenter categoriesFor: #treeValueFor:!accessing!public! !
!ProfilerTreesPresenter categoriesFor: #update!public!updating! !
!ProfilerTreesPresenter categoriesFor: #workspacePresenter!accessing!public! !

!ProfilerTreesPresenter class methodsFor!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 2 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 592 nil 496 nil 5 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 592 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 690 9 9 nil 704 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 1 227 690 701 7 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 113 0 0 0 94 1 0 0 116 0 0 0] 8 #() 690 193 193 nil 27 1 true 170 192 34 2 410 ##(Smalltalk.TreeView) 34 27 nil 416 34 2 8 1140916775 1025 992 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 496 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 2 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #expand 8 'Expand' 591 1 nil nil nil 1234 1 1266 #collapse 8 'Collapse' 587 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 992 nil 8 1903418384 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil 170 176 1168 nil #smallIcons 1 170 ##(Smalltalk.PluggableLookupTable) 1168 738 138 144 34 2 802 #createAt:extent: 34 2 690 1 1 690 701 227 992 802 #contextMenu: 34 1 1200 992 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 113 0 0 0] 8 #() 944 nil 27 8 'tree' nil 738 138 144 34 1 802 #createAt:extent: 34 2 690 3839 21 690 701 461 416 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 221 8 0 0 240 0 0 0] 34 3 992 592 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1140850688 131073 1824 nil 496 nil 5 nil nil nil 1824 655878 ##(Smalltalk.CardLayout) 138 144 34 2 721414 ##(Smalltalk.Association) 8 'Workspace' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1824 34 2 8 1140850688 131073 2000 nil nil nil 5 nil nil nil 2000 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 738 138 144 34 1 802 #createAt:extent: 34 2 690 9 53 690 685 169 2000 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 110 0 0 0] 1168 944 nil 27 1954 8 'Disassembly' 410 ##(Smalltalk.ReferenceView) 34 14 nil 1824 34 2 8 1140850688 131073 2272 nil nil nil 5 nil nil nil 2272 2066 ##(Smalltalk.SmalltalkWorkspace) #resource_Default_view nil 738 138 144 34 1 802 #createAt:extent: 34 2 690 9 53 690 685 169 2272 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 26 0 0 0 90 1 0 0 110 0 0 0] 1168 944 nil 27 2000 170 192 34 4 2000 8 'workspace' 2272 8 'disassembly' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1824 34 2 8 1140916736 1 2560 590662 2 ##(Smalltalk.ListModel) 138 144 34 2 1984 2256 nil 1104 721158 ##(Smalltalk.SystemColor) 31 nil 1 nil nil nil 2560 nil 8 1903376304 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1408 nil nil nil nil nil #noIcons nil nil nil nil nil 738 138 144 34 3 802 #createAt:extent: 34 2 690 1 1 690 701 229 2560 802 #basicSelectionsByIndex: 34 1 8 #(1) 2560 802 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 2560 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 114 0 0 0] 8 #() 944 nil 27 738 138 144 34 1 802 #createAt:extent: 34 2 690 1 233 690 701 229 1824 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 116 0 0 0 94 1 0 0 230 0 0 0] 34 3 2000 2272 2560 944 nil 27 944 nil 27 )! !
!ProfilerTreesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

