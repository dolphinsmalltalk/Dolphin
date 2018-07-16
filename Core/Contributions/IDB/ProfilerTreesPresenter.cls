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

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ContainerView) 98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(ColorRef) 8 4278190080 0 5 0 0 0 416 1180166 ##(ProportionalLayout) 234 240 98 2 410 8 ##(Splitter) 98 12 0 416 98 2 8 1140850688 1 608 0 498 528 0 5 0 0 0 608 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 1 227 834 701 7 608 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 113 0 0 0 94 1 0 0 116 0 0 0] 98 0 834 193 193 0 27 1 16 234 256 98 2 410 8 ##(TreeView) 98 27 0 416 98 2 8 1140916263 1025 992 590918 3 ##(TreeModel) 0 1114638 ##(STBSingletonProxy) 8 ##(SearchPolicy) 8 #identity 525062 ##(TreeNode) 0 0 0 234 256 98 0 498 528 0 5 265030 4 ##(Menu) 0 16 98 2 984134 2 ##(CommandMenuItem) 1 1180998 4 ##(CommandDescription) 8 #expand 8 'Expand' 591 1 0 0 0 1298 1 1330 8 #collapse 8 'Collapse' 587 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 992 0 8 4294904696 8 ##(BasicListAbstract) 8 ##(IconicListAbstract) 1114 8 ##(IconImageManager) 8 #current 0 0 0 0 0 234 240 1216 17 8 #smallIcons 1 0 706 202 208 98 2 770 800 98 2 834 1 1 834 701 227 992 770 8 #contextMenu: 98 1 1264 992 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 113 0 0 0] 98 0 944 0 27 8 'tree' 0 706 202 208 98 1 770 800 98 2 834 1349 1017 834 701 461 416 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 162 2 0 0 252 1 0 0 0 4 0 0 226 2 0 0] 98 3 992 608 410 8 ##(CardContainer) 98 16 0 416 98 2 8 1140850688 131073 1984 0 498 528 0 5 0 0 0 1984 655878 ##(CardLayout) 202 208 98 2 721414 ##(Association) 8 'Workspace' 410 8 ##(ReferenceView) 98 14 0 1984 98 2 8 1140850688 131073 2192 0 0 0 5 0 0 0 2192 1180166 ##(ResourceIdentifier) 8 ##(SmalltalkWorkspace) 8 #resource_Default_view 0 706 202 208 98 1 770 800 98 2 834 9 51 834 685 171 2192 882 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 25 0 0 0 90 1 0 0 110 0 0 0] 1216 944 0 27 2146 8 'Disassembly' 410 2208 98 14 0 1984 98 2 8 1140850688 131073 2512 0 0 0 5 0 0 0 2512 2274 2304 2320 0 706 202 208 98 1 770 800 98 2 834 9 51 834 685 171 2512 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 25 0 0 0 90 1 0 0 110 0 0 0] 1216 944 0 27 2512 234 256 98 4 2512 8 'disassembly' 2192 8 'workspace' 0 410 8 ##(TabViewXP) 98 23 0 1984 98 2 8 1140916736 1 2800 590662 2 ##(ListModel) 202 208 98 2 2176 2496 0 1120 721158 ##(SystemColor) 31 0 1 0 0 0 2800 0 8 4294904500 1488 1504 1520 0 0 0 0 0 8 #noIcons 706 202 208 98 3 770 800 98 2 834 1 1 834 701 229 2800 770 8 #selectionByIndex:ifAbsent: 98 2 5 770 8 #yourself 1216 0 2800 770 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 2800 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 114 0 0 0] 98 0 944 0 27 706 202 208 98 1 770 800 98 2 834 1 233 834 701 229 1984 882 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 116 0 0 0 94 1 0 0 230 0 0 0] 98 3 2192 2512 2800 944 0 27 944 0 27)! !
!ProfilerTreesPresenter class categoriesFor: #resource_Default_view!public!resources-views! !

