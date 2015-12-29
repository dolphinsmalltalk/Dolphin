"Filed out from Dolphin Smalltalk X6.2"!

SmalltalkToolShell subclass: #StsVersionTreeDiagram
	instanceVariableNames: 'treePresenter treeModel status'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StsVersionTreeDiagram guid: (GUID fromString: '{7105C5B0-BA53-11D4-B24E-000000000000}')!
StsVersionTreeDiagram comment: ''!
!StsVersionTreeDiagram categoriesForClass!Unclassified! !
!StsVersionTreeDiagram methodsFor!

add: editions asChildOf: parentEdition remainingDepth: remainingDepth 
	remainingDepth > 0 ifFalse: [^self].
	editions do: 
			[:each | 
			(each previousEdition isIdenticalTo: parentEdition) 
				ifTrue: 
					[treeModel add: each odbResolve asChildOf: parentEdition odbResolve.
					self 
						add: editions
						asChildOf: each
						remainingDepth: remainingDepth - 1]]!

createComponents
	super createComponents.
	treePresenter := self add: (TreePresenter on: TreeModel new) name: 'versions'.
	status := self add: TextPresenter new name: 'status'.
	status value: nil!

createSchematicWiring
	super createSchematicWiring.
	treePresenter 
		when: #selectionChanged
		send: #onEditionSelected
		to: self!

defaultHelpId
	^10981!

maxDepth
	^10!

onEditionSelected
	status 
		value: (treePresenter selectionOrNil isNil ifFalse: [treePresenter selectionOrNil versionInfo])!

onViewOpened
	| workRect |
	super onViewOpened.
	workRect := View desktop workArea.
	self view rectangle: (workRect insetBy: workRect extent // 4)!

setEditions: editions selectedEdition: selectedEdition 
	| rootEdition latestEdition depth tmp |
	treeModel := TreeModel new.
	latestEdition := editions first.

	"Find root edition working back from the given selectedEdition."
	rootEdition := selectedEdition.
	depth := 0.
	
	[rootEdition isNil or: 
			[(tmp := rootEdition previousEdition) isNil or: [tmp isODBReference not or: [depth > self maxDepth]]]] 
			whileFalse: 
				[rootEdition := tmp.
				depth := depth + 1].
	rootEdition notNil ifTrue: [treeModel add: rootEdition odbResolve asChildOf: nil].

	"Now build the tree from the root up"
	self 
		add: editions
		asChildOf: rootEdition
		remainingDepth: depth + self maxDepth.
	self caption: ('Version Tree for <1d>: <2d>' expandMacrosWith: latestEdition class displayName
				with: latestEdition name).

	"Select the selectedEdition in the tree"
	treePresenter
		model: treeModel;
		selection: selectedEdition odbResolve ifAbsent: [];
		setFocus! !
!StsVersionTreeDiagram categoriesFor: #add:asChildOf:remainingDepth:!operations!private! !
!StsVersionTreeDiagram categoriesFor: #createComponents!initializing!private! !
!StsVersionTreeDiagram categoriesFor: #createSchematicWiring!initializing!private! !
!StsVersionTreeDiagram categoriesFor: #defaultHelpId!constants!public! !
!StsVersionTreeDiagram categoriesFor: #maxDepth!accessing!constants!public! !
!StsVersionTreeDiagram categoriesFor: #onEditionSelected!event handling!private! !
!StsVersionTreeDiagram categoriesFor: #onViewOpened!event handling!private! !
!StsVersionTreeDiagram categoriesFor: #setEditions:selectedEdition:!accessing!public! !

!StsVersionTreeDiagram class methodsFor!

icon
	^Icon fromId: 'SOURCETRACKINGTOOLSHELL.ICO'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 0 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140853004 1 560 0 721158 ##(Smalltalk.SystemColor)  31 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 159 4 0 134 63 1 0 0 204 53 63 1 2 0 20 59 0 0 0 0 247 0 5 86 111 1] 328198 ##(Smalltalk.Point)  193 193 0 560 0 8 4294904209 234 256 98 2 853766 ##(Smalltalk.StatusBarItem)  1 -1 560 0 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.IconImageManager)  8 #current 8 'status' 98 1 848 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 560 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 1 849 754 1265 45 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 1 0 0 120 2 0 0 190 1 0 0] 98 0 754 193 193 0 27 0 0 410 8 ##(Smalltalk.ScrollingDecorator)  98 18 0 416 98 2 8 1143996416 132097 1264 0 482 512 0 7 0 0 0 1264 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout)  16 234 256 98 2 410 8 ##(Smalltalk.MoenTreeView)  98 30 0 1264 98 2 8 1140850688 1 1424 590918 3 ##(Smalltalk.TreeModel)  0 906 8 ##(Smalltalk.SearchPolicy)  8 #identity 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 98 0 482 512 0 543 0 0 0 1424 788998 ##(Smalltalk.MoenTreeNode)  0 721926 ##(Smalltalk.MoenContour)  0 0 0 0 754 1 1 1728 0 0 0 0 0 7 459270 ##(Smalltalk.Message)  8 #versionDescriptor 98 0 880 268435457 3 912 754 17 17 45 0 197382 ##(Smalltalk.Pen)  0 16 393478 ##(Smalltalk.LOGPEN)  8 #[0 0 0 0 1 0 0 0 0 0 0 0 0 0 255 0] 754 33 33 754 501 1999 81953 1808 754 35 1 0 0 0 1026 202 208 98 1 1090 1120 98 2 754 1 1 754 1257 841 1424 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 116 2 0 0 164 1 0 0] 98 0 1248 0 27 8 'versions' 0 754 1 1 16 754 17 17 1026 202 208 98 1 1090 1120 98 2 754 1 1 754 1265 849 1264 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 120 2 0 0 168 1 0 0] 98 1 1424 1248 0 27 234 256 98 2 560 8 'statusBar' 0 0 0 0 0 1 0 0 0 0 1 0 0 1026 202 208 98 3 1090 1120 98 2 754 6399 21 754 1281 961 416 1090 8 #text: 98 1 8 'Version Tree' 416 1090 8 #menuBar: 98 1 0 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 12 0 0 10 0 0 0 255 14 0 0 234 1 0 0] 98 2 1264 560 1248 0 27 )! !
!StsVersionTreeDiagram class categoriesFor: #icon!public! !
!StsVersionTreeDiagram class categoriesFor: #resource_Default_view!public!resources-views! !

