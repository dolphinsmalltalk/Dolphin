"Filed out from Dolphin Smalltalk 7"!

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
!TwinLevelInspector categoriesFor: #aspectAccessor!public! !
!TwinLevelInspector categoriesFor: #createComponents!private! !
!TwinLevelInspector categoriesFor: #createSchematicWiring!initializing!private! !
!TwinLevelInspector categoriesFor: #inspectorPresenter!public! !
!TwinLevelInspector categoriesFor: #isRootAspectVisible:!accessing!public! !
!TwinLevelInspector categoriesFor: #model:!public! !
!TwinLevelInspector categoriesFor: #onContentsSelectionChanged!private! !
!TwinLevelInspector categoriesFor: #selectionOrNil!public!selection! !
!TwinLevelInspector categoriesFor: #selectionOrNil:!public!selection! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1409372236 1 576 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 7 nil nil nil 576 nil 8 1921599248 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 328198 ##(Smalltalk.Point) 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 754 #displayString 784 754 #<= 8 #() nil nil 576 nil 1 nil nil #thumbnails 688 834 193 193 131169 834 65 65 34 4 nil nil 834 1 1 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 834 21 21 834 451 727 576 1122 #text: 34 1 8 'Column 1' 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 834 193 193 nil 27 524806 ##(Smalltalk.Fraction) 901 1227 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 1360 nil nil nil 7 nil nil nil 1360 514 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 1360 34 2 8 1140850688 1 1504 nil 496 nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 1504 nil 1 #left nil nil nil 834 1 1 834 9 9 nil 1600 nil 1058 138 144 34 1 1122 #createAt:extent: 34 2 834 1 85 834 731 11 1504 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1312 nil 27 1 true 170 192 688 nil 1058 138 144 34 1 1122 #createAt:extent: 34 2 834 481 21 834 777 727 1360 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 1504 410 ##(Smalltalk.CardContainer) 34 16 nil 1360 34 2 8 1409286144 131073 1968 nil nil nil 7 nil nil nil 1968 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 1474 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 1968 34 2 8 1140953421 1 2112 642 138 144 688 nil 720 nil nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2258 1 2290 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2258 1 2290 #browseIt 8 '&Browse It' 1 1 2338 nil true 2384 8 'ClassBrowserShell.ico' 2432 nil nil 2514 4097 2258 1 2290 #copyAspect 8 '&Copy' 1 1 nil nil nil 2258 1 2290 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2514 4097 2258 1 2290 #editAspect 8 '&Edit' 1 1 nil nil nil 2258 1 2290 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 2514 4097 2258 1 2290 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 2112 nil 8 1921599248 754 #valueText 8 #() nil 816 nil nil nil nil nil nil 138 144 34 3 898 8 'Property' 357 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 752 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 3056 7 257 nil 754 #<= 8 #() nil nil 2112 nil 3 nil nil 898 8 'Value' 357 #left 3042 0 nil 3074 2 1 3040 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 3216 7 257 nil 754 #<= 3168 nil nil 2112 3042 0 nil 3074 2 1 3040 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 3312 7 257 nil 3 nil nil 898 8 '' 41 #center 754 #displayString 8 #() 754 #<= 3440 nil nil 2112 3042 0 nil 3074 3 1 3040 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 3472 7 257 nil 1 nil nil #report 688 nil 359 834 129 129 34 4 nil nil 834 1 1 nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 720 138 144 688 nil nil 3042 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3600 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3616 3042 0 nil 3666 1 83886083 3600 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3712 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 688 138 ##(Smalltalk.IdentitySet) 688 13 5 nil nil nil nil nil nil nil 1058 138 144 34 3 1122 #createAt:extent: 34 2 834 9 9 834 761 667 2112 1122 #contextMenu: 34 1 2224 2112 1122 #text: 34 1 8 'Property' 2112 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1312 nil 2021 1474 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 1968 34 2 8 1411453252 1 4048 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 21 2210 nil true 34 13 2258 1 2290 #accept 8 '&Accept' 1 1 nil nil nil 2514 4097 2210 nil true 34 10 2258 1 2290 #undo 8 '&Undo' 1 1 2338 nil true 2384 8 'EditUndo.ico' 2432 nil nil 2514 4097 2258 1 2290 #cutSelection 8 'Cu&t' 1 1 2338 nil true 2384 8 'EditCut.ico' 2432 nil nil 2258 1 2290 #copySelection 8 '&Copy' 1 1 2338 nil true 2384 8 'EditCopy.ico' 2432 nil nil 2258 1 2290 #pasteClipboard 8 '&Paste' 1 1 2338 nil true 2384 8 'EditPaste.ico' 2432 nil nil 2258 1 2290 #clearSelection 8 'De&lete' 1 1 2338 nil true 2384 8 'EditClear.ico' 2432 nil nil 2514 4097 2258 1 2290 #reformatSource 8 'Re&format' 1 1 nil nil nil 2514 4097 2258 1 2290 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2210 nil true 34 10 2258 1 2290 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 2258 1 2290 #cloneNew 8 '&Clone' 1 1 2338 nil true 2384 8 'SmalltalkWorkspace.ico' 2432 nil nil 2514 4097 2258 1 2290 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2258 1 2290 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2258 1 2290 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2258 1 2290 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2258 1 2290 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2258 1 2290 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2258 1 2290 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 2514 4097 2258 1 2290 #browseIt 8 'Bro&wse It' 1 1 2338 nil true 2384 8 'ClassBrowserShell.ico' 2432 nil nil 2258 1 2290 #displayIt 8 '&Display It' 1 1 2338 nil true 2384 8 'DisplayIt.ico' 2432 nil nil 2258 1 2290 #printIt 8 '&Print It' 1 1 2338 nil true 2384 8 'PrintIt.ico' 2432 nil nil 2258 1 2290 #evaluateIt 8 'E&valuate It' 1 1 2338 nil true 2384 8 'EvaluateIt.ico' 2432 nil nil 2258 1 2290 #inspectIt 8 '&Inspect It' 1 1 2338 nil true 2384 8 'InspectIt.ico' 2432 nil nil 2258 1 2290 #debugIt 8 'Deb&ug It' 1 1 2338 nil true 2384 8 'Debugger.ico' 2432 nil nil 2514 4097 2210 nil true 34 2 2258 2097153 2290 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 2258 1 2290 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 4048 nil 8 1894044095 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 482 #gray 482 #white 1 nil nil nil nil #callTip nil nil nil #normal 6226 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 40 6288 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 688 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4048 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 688 nil 170 176 688 9215 nil nil nil nil 482 #silver nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 6192 nil nil nil nil 3 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 4048 482 #blue 3 false #Warning nil nil nil nil nil nil #Error 6642 21 4048 482 #red 3 false #Error nil nil nil nil nil nil #Notification 6642 17 4048 482 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6226 1027 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6226 1031 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6226 1029 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1058 138 144 34 10 1122 #createAt:extent: 34 2 834 9 9 834 761 667 4048 1122 #contextMenu: 34 1 4208 4048 1122 #textLimit: 8 #(1073741823) 4048 1122 #hoverTime: 8 #(500) 4048 1122 #caretPeriod: 8 #(530) 4048 1122 #wordWrap: 8 #(true) 4048 1122 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 4048 1 3 nil nil 5 nil 7234 3 4048 1 nil nil 67108863 5 nil 7234 5 4048 1 nil nil nil 5 nil 4048 1122 #tabWidth: 8 #(4) 4048 1122 #maxCompletionListHeight: 8 #(9) 4048 1122 #edgeColumn: 8 #(1) 4048 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1312 nil 29 2112 nil nil nil 170 192 34 4 4048 8 'workspace' 2112 8 'aspects' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1968 34 2 8 1140916738 1 7504 642 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 720 nil nil 3 nil nil nil 7504 nil 8 1921705120 3042 0 nil 3074 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7632 7 257 nil 3042 0 nil 3666 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7696 7 257 nil 816 nil nil nil nil nil #smallIcons nil nil nil nil nil 1058 138 144 34 3 1122 #createAt:extent: 34 2 834 1 1 834 777 727 7504 1122 #basicSelectionsByIndex: 34 1 8 #(1) 7504 1122 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7504 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1312 nil 27 1058 138 144 34 1 1122 #createAt:extent: 34 2 834 1 1 834 777 727 1968 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 2112 4048 7504 1312 nil 27 1312 nil 27 1330 1553 1227 false 170 192 34 4 576 8 'contents' 1360 8 'inspector' 590342 ##(Smalltalk.Rectangle) 834 21 21 834 21 21 1058 138 144 34 2 1122 #createAt:extent: 34 2 834 3839 21 834 1281 771 416 1122 #text: 34 1 8 'Inspector' 416 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 139 1 0 0] 34 3 576 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8496 nil 496 nil 519 nil nil nil 1570 8496 nil 1 #left nil nil nil 1600 1616 nil 1600 nil 1058 138 144 34 1 1122 #createAt:extent: 34 2 834 471 21 834 11 727 8496 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1312 nil 27 1360 1312 nil 27 )!

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
!TwinLevelInspector class categoriesFor: #defaultModel!public! !
!TwinLevelInspector class categoriesFor: #icon!constants!public! !
!TwinLevelInspector class categoriesFor: #resource_Default_view!public!resources-views! !
!TwinLevelInspector class categoriesFor: #shellOn:caption:!instance creation!public! !

