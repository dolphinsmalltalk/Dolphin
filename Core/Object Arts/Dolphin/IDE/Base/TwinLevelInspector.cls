"Filed out from Dolphin Smalltalk"!

Presenter subclass: #TwinLevelInspector
	instanceVariableNames: 'contentsPresenter inspectorPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TwinLevelInspector guid: (GUID fromString: '{dc9a61d9-617e-42a8-bb8a-a84102ae8002}')!

TwinLevelInspector comment: ''!

!TwinLevelInspector categoriesForClass!MVP-Presenters! !

!TwinLevelInspector methodsFor!

aspectAccessor
	^self inspectorPresenter aspectAccessor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	contentsPresenter := self add: ListPresenter new name: 'contents'.
	inspectorPresenter := self add: PropertyInspector new name: 'inspector'.
	inspectorPresenter
		isRootAspectVisible: false;
		isSingleLevelOnly: true!

createSchematicWiring
	super createSchematicWiring.
	contentsPresenter 
		when: #selectionChanged
		send: #onContentsSelectionChanged
		to: self!

inspectorPresenter
	^inspectorPresenter!

isRootAspectVisible: aBoolean 
	inspectorPresenter isRootAspectVisible: aBoolean!

model: aListModelOfObjects 
	super model: aListModelOfObjects.
	contentsPresenter model: aListModelOfObjects!

onContentsSelectionChanged
	inspectorPresenter value: contentsPresenter selectionOrNil!

selectionOrNil
	^contentsPresenter selectionOrNil!

selectionOrNil: anObject
	^contentsPresenter selectionOrNil: anObject! !

!TwinLevelInspector categoriesForMethods!
aspectAccessor!public! !
createComponents!private! !
createSchematicWiring!initializing!private! !
inspectorPresenter!public! !
isRootAspectVisible:!accessing!public! !
model:!public! !
onContentsSelectionChanged!private! !
selectionOrNil!public!selection! !
selectionOrNil:!public!selection! !
!

!TwinLevelInspector class methodsFor!

defaultModel
	^ListModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 576 nil nil nil 7 nil nil nil 576 514 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 576 34 2 8 1140850688 1 720 nil 496 nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 720 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 818 9 9 nil 832 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 193 752 8 '' 720 1 8 #() 818 193 193 nil 27 1 true 170 192 8 #() nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 193 608 8 '' 576 3 34 2 720 410 ##(Smalltalk.CardContainer) 34 16 nil 576 34 2 8 1409286144 131073 1296 nil nil nil 7 nil nil nil 1296 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 690 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 59 nil 1296 34 2 8 1140953421 1 1440 590662 2 ##(Smalltalk.ListModel) 138 144 1120 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1634 1 1666 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1634 1 1666 #browseIt 8 '&Browse It' 1 1 1714 nil true 1760 8 'ClassBrowserShell.ico' 1808 nil nil 1890 4097 1634 1 1666 #copyAspect 8 '&Copy' 1 1 nil nil nil 1634 1 1666 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1890 4097 1634 1 1666 #editAspect 8 '&Edit' 1 1 nil nil nil 1634 1 1666 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1890 4097 1634 1 1666 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1440 nil 8 1795768528 459270 ##(Smalltalk.Message) #valueText 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Property' 361 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 2320 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 2496 7 257 nil 2322 #<= 8 #() nil nil 1440 nil 3 nil nil 2434 8 'Value' 361 #left 2482 0 nil 2514 2 1 2480 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 2656 7 257 nil 2322 #<= 2608 nil nil 1440 2482 0 nil 2514 2 1 2480 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2752 7 257 nil 3 nil nil 2434 8 '' 41 #center 2322 #displayString 8 #() 2322 #<= 2880 nil nil 1440 2482 0 nil 2514 3 1 2480 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2912 7 257 nil 1 nil nil #report 8 #() nil 359 818 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1568 138 144 1120 nil nil 2482 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3024 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3040 2482 0 nil 3090 1 83886083 3024 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3136 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 1120 138 ##(Smalltalk.IdentitySet) 1120 13 5 nil nil nil nil nil nil nil 866 138 144 34 2 930 #createWindow: 34 1 978 1010 8 #[4 0 0 0 4 0 0 0 128 1 0 0 83 1 0 0] 193 1472 8 'Property' 1440 930 #contextMenu: 34 1 1600 1440 3 8 #() 818 193 193 nil 2029 690 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 65 nil 1296 34 2 8 1411453252 1 3440 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 21 1586 nil true 34 13 1634 1 1666 #accept 8 '&Accept' 1 1 nil nil nil 1890 4097 1586 nil true 34 10 1634 1 1666 #undo 8 '&Undo' 1 1 1714 nil true 1760 8 'EditUndo.ico' 1808 nil nil 1890 4097 1634 1 1666 #cutSelection 8 'Cu&t' 1 1 1714 nil true 1760 8 'EditCut.ico' 1808 nil nil 1634 1 1666 #copySelection 8 '&Copy' 1 1 1714 nil true 1760 8 'EditCopy.ico' 1808 nil nil 1634 1 1666 #pasteClipboard 8 '&Paste' 1 1 1714 nil true 1760 8 'EditPaste.ico' 1808 nil nil 1634 1 1666 #clearSelection 8 'De&lete' 1 1 1714 nil true 1760 8 'EditClear.ico' 1808 nil nil 1890 4097 1634 1 1666 #reformatSource 8 'Re&format' 1 1 nil nil nil 1890 4097 1634 1 1666 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1586 nil true 34 10 1634 1 1666 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1634 1 1666 #cloneNew 8 '&Clone' 1 1 1714 nil true 1760 8 'SmalltalkWorkspace.ico' 1808 nil nil 1890 4097 1634 1 1666 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1634 1 1666 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1634 1 1666 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1634 1 1666 #toggleLineEndings 8 'Line &Endings' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1634 1 1666 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1634 1 1666 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1634 1 1666 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1890 4097 1634 1 1666 #browseIt 8 'Bro&wse It' 1 1 1714 nil true 1760 8 'ClassBrowserShell.ico' 1808 nil nil 1634 1 1666 #displayIt 8 '&Display It' 1 1 1714 nil true 1760 8 'DisplayIt.ico' 1808 nil nil 1634 1 1666 #printIt 8 '&Print It' 1 1 1714 nil true 1760 8 'PrintIt.ico' 1808 nil nil 1634 1 1666 #evaluateIt 8 'E&valuate It' 1 1 1714 nil true 1760 8 'EvaluateIt.ico' 1808 nil nil 1634 1 1666 #inspectIt 8 '&Inspect It' 1 1 1714 nil true 1760 8 'InspectIt.ico' 1808 nil nil 1634 1 1666 #debugIt 8 'Deb&ug It' 1 1 1714 nil true 1760 8 'Debugger.ico' 1808 nil nil 1890 4097 1586 nil true 34 2 1634 2097153 1666 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1634 1 1666 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3440 nil 8 1537949160 852486 ##(Smalltalk.NullConverter) nil nil 9 1418429905 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 482 #gray 482 #white 1 nil nil nil nil #callTip nil nil nil #normal 5618 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 1120 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 3440 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1120 nil 170 176 1120 9215 nil nil nil nil 482 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 5584 nil nil nil nil 16 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 3440 482 #blue 3 false #Warning nil nil nil nil nil nil #Error 6018 21 3440 482 #red 3 false #Error nil nil nil nil nil nil #Notification 6018 17 3440 482 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 5618 1027 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 5618 1031 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 5618 1029 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 138 144 34 10 930 #createWindow: 34 1 978 1010 8 #[4 0 0 0 4 0 0 0 128 1 0 0 83 1 0 0] 193 3472 nil 3440 930 #contextMenu: 34 1 3600 3440 930 #hoverTime: 8 #(500) 3440 930 #caretPeriod: 8 #(530) 3440 930 #wordWrap: 8 #(true) 3440 930 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 3440 1 3 nil nil 5 nil 6594 3 3440 1 nil nil 67108863 5 nil 6594 5 3440 1 nil nil nil 5 nil 3440 930 #tabWidth: 8 #(4) 3440 930 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 3440 930 #maxCompletionListHeight: 8 #(9) 3440 930 #edgeColumn: 8 #(1) 3440 1 8 #() 818 193 193 nil 33 1440 nil nil nil 170 192 34 4 3440 8 'workspace' 1440 8 'aspects' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1296 34 2 8 1140916738 1 6912 1506 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1568 nil nil 3 nil nil nil 6912 nil 8 1795364496 2482 0 nil 2514 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7040 7 257 nil 2482 0 nil 3090 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7104 7 257 nil 2384 nil nil nil nil nil #smallIcons nil nil nil nil nil 866 138 144 34 3 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 193 6944 8 '' 6912 930 #setSingleSelection: 8 #(1) 6912 930 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6912 3 8 #() 818 193 193 nil 27 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 193 1328 8 '' 1296 3 34 3 1440 3440 6912 818 193 193 nil 27 818 193 193 nil 27 524806 ##(Smalltalk.Fraction) 1553 1227 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1409372236 1 7616 1506 138 144 1120 nil 1568 nil nil 7 nil nil nil 7616 nil 8 1795768528 2322 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 2384 nil nil nil 818 129 129 nil nil 138 144 34 1 2434 8 'Column 1' 201 #left 2322 #displayString 7744 2322 #<= 8 #() nil nil 7616 nil 1 nil nil #thumbnails 2992 818 193 193 131169 818 65 65 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 193 7648 8 'Column 1' 7616 3 8 #() 818 193 193 nil 35 7586 901 1227 false 170 192 34 4 576 8 'inspector' 7616 8 'contents' 590342 ##(Smalltalk.Rectangle) 818 21 21 818 21 21 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[255 11 0 0 10 0 0 0 127 14 0 0 139 1 0 0] 193 448 8 'Inspector' 416 3 34 3 7616 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8400 nil 496 nil 519 nil nil nil 786 8400 nil 1 #left nil nil nil 832 848 nil 832 nil 866 138 144 34 1 930 #createWindow: 34 1 978 1010 8 #[235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 193 8432 8 '' 8400 3 8 #() 818 193 193 nil 27 576 818 193 193 nil 27 )!

shellOn: aListModelOfObjects caption: caption 
	"Open an Inspector shell displaying on anObject. 
	Answer the new Inspector."

	| inspector shell |
	shell := InspectorShell create.
	shell caption: caption.
	inspector := self createIn: shell on: aListModelOfObjects.
	inspector view arrangement: #center.
	shell view validateLayout.
	shell show setInitialFocus.
	^inspector! !

!TwinLevelInspector class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
shellOn:caption:!instance creation!public! !
!

