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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1409372236 1 576 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 7 nil nil nil 576 nil 8 1759068368 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 328198 ##(Smalltalk.Point) 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 754 #displayString 784 754 #<= 8 #() nil nil 576 nil 1 nil nil #thumbnails 8 #() 834 193 193 131169 834 65 65 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 193 608 8 'Column 1' 576 3 8 #() 834 193 193 nil 35 524806 ##(Smalltalk.Fraction) 901 1227 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 1312 nil nil nil 7 nil nil nil 1312 514 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 1312 34 2 8 1140850688 1 1456 nil 496 nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 1456 nil 1 #left nil nil nil 834 1 1 834 9 9 nil 1552 nil 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 193 1488 8 '' 1456 1 8 #() 834 193 193 nil 27 1 true 170 192 688 nil 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 193 1344 8 '' 1312 3 34 2 1456 410 ##(Smalltalk.CardContainer) 34 16 nil 1312 34 2 8 1409286144 131073 1936 nil nil nil 7 nil nil nil 1936 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 1426 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 59 nil 1936 34 2 8 1140953421 1 2080 642 138 144 688 nil 720 nil nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2226 1 2258 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2226 1 2258 #browseIt 8 '&Browse It' 1 1 2306 nil true 2352 8 'ClassBrowserShell.ico' 2400 nil nil 2482 4097 2226 1 2258 #copyAspect 8 '&Copy' 1 1 nil nil nil 2226 1 2258 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2482 4097 2226 1 2258 #editAspect 8 '&Edit' 1 1 nil nil nil 2226 1 2258 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 2482 4097 2226 1 2258 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 2080 nil 8 1759068368 754 #valueText 8 #() nil 816 nil nil nil nil nil nil 138 144 34 3 898 8 'Property' 357 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 752 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 3024 7 257 nil 754 #<= 8 #() nil nil 2080 nil 3 nil nil 898 8 'Value' 357 #left 3010 0 nil 3042 2 1 3008 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 3184 7 257 nil 754 #<= 3136 nil nil 2080 3010 0 nil 3042 2 1 3008 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 3280 7 257 nil 3 nil nil 898 8 '' 41 #center 754 #displayString 8 #() 754 #<= 3408 nil nil 2080 3010 0 nil 3042 3 1 3008 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 3440 7 257 nil 1 nil nil #report 992 nil 359 834 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 720 138 144 688 nil nil 3010 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3536 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3552 3010 0 nil 3602 1 83886083 3536 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3648 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 688 138 ##(Smalltalk.IdentitySet) 688 13 5 nil nil nil nil nil nil nil 1042 138 144 34 2 1106 #createWindow: 34 1 1154 1186 8 #[4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 193 2112 8 'Property' 2080 1106 #contextMenu: 34 1 2192 2080 3 8 #() 834 193 193 nil 2029 1426 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 65 nil 1936 34 2 8 1411453252 1 3952 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 21 2178 nil true 34 13 2226 1 2258 #accept 8 '&Accept' 1 1 nil nil nil 2482 4097 2178 nil true 34 10 2226 1 2258 #undo 8 '&Undo' 1 1 2306 nil true 2352 8 'EditUndo.ico' 2400 nil nil 2482 4097 2226 1 2258 #cutSelection 8 'Cu&t' 1 1 2306 nil true 2352 8 'EditCut.ico' 2400 nil nil 2226 1 2258 #copySelection 8 '&Copy' 1 1 2306 nil true 2352 8 'EditCopy.ico' 2400 nil nil 2226 1 2258 #pasteClipboard 8 '&Paste' 1 1 2306 nil true 2352 8 'EditPaste.ico' 2400 nil nil 2226 1 2258 #clearSelection 8 'De&lete' 1 1 2306 nil true 2352 8 'EditClear.ico' 2400 nil nil 2482 4097 2226 1 2258 #reformatSource 8 'Re&format' 1 1 nil nil nil 2482 4097 2226 1 2258 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2178 nil true 34 10 2226 1 2258 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 2226 1 2258 #cloneNew 8 '&Clone' 1 1 2306 nil true 2352 8 'SmalltalkWorkspace.ico' 2400 nil nil 2482 4097 2226 1 2258 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2226 1 2258 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2226 1 2258 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2226 1 2258 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2226 1 2258 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2226 1 2258 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2226 1 2258 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 2482 4097 2226 1 2258 #browseIt 8 'Bro&wse It' 1 1 2306 nil true 2352 8 'ClassBrowserShell.ico' 2400 nil nil 2226 1 2258 #displayIt 8 '&Display It' 1 1 2306 nil true 2352 8 'DisplayIt.ico' 2400 nil nil 2226 1 2258 #printIt 8 '&Print It' 1 1 2306 nil true 2352 8 'PrintIt.ico' 2400 nil nil 2226 1 2258 #evaluateIt 8 'E&valuate It' 1 1 2306 nil true 2352 8 'EvaluateIt.ico' 2400 nil nil 2226 1 2258 #inspectIt 8 '&Inspect It' 1 1 2306 nil true 2352 8 'InspectIt.ico' 2400 nil nil 2226 1 2258 #debugIt 8 'Deb&ug It' 1 1 2306 nil true 2352 8 'Debugger.ico' 2400 nil nil 2482 4097 2178 nil true 34 2 2226 2097153 2258 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 2226 1 2258 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3952 nil 8 1504001512 852486 ##(Smalltalk.NullConverter) nil nil 9 68806849 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 482 #gray 482 #white 1 nil nil nil nil #callTip nil nil nil #normal 6130 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 688 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 3952 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 688 nil 170 176 688 9215 nil nil nil nil 482 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6096 nil nil nil nil 16 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 3952 482 #blue 3 false #Warning nil nil nil nil nil nil #Error 6530 21 3952 482 #red 3 false #Error nil nil nil nil nil nil #Notification 6530 17 3952 482 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6130 1027 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6130 1031 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6130 1029 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1042 138 144 34 10 1106 #createWindow: 34 1 1154 1186 8 #[4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 193 3984 nil 3952 1106 #contextMenu: 34 1 4112 3952 1106 #hoverTime: 8 #(500) 3952 1106 #caretPeriod: 8 #(530) 3952 1106 #wordWrap: 8 #(true) 3952 1106 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 3952 1 3 nil nil 5 nil 7106 3 3952 1 nil nil 67108863 5 nil 7106 5 3952 1 nil nil nil 5 nil 3952 1106 #tabWidth: 8 #(4) 3952 1106 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 3952 1106 #maxCompletionListHeight: 8 #(9) 3952 1106 #edgeColumn: 8 #(1) 3952 1 8 #() 834 193 193 nil 33 2080 nil nil nil 170 192 34 4 2080 8 'aspects' 3952 8 'workspace' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1936 34 2 8 1140916738 1 7424 642 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 720 nil nil 1 nil nil nil 7424 nil 8 1758664336 3010 0 nil 3042 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7552 7 257 nil 3010 0 nil 3602 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7616 7 257 nil 816 nil nil nil nil nil #smallIcons nil nil nil nil nil 1042 138 144 34 3 1106 #createWindow: 34 1 1154 1186 8 #[0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 193 7456 8 '' 7424 1106 #setSingleSelection: 8 #(1) 7424 1106 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7424 3 8 #() 834 193 193 nil 27 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 193 1968 8 '' 1936 3 34 3 2080 3952 7424 834 193 193 nil 27 834 193 193 nil 27 1282 1553 1227 false 170 192 34 4 576 8 'contents' 1312 8 'inspector' 590342 ##(Smalltalk.Rectangle) 834 21 21 834 21 21 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[191 13 0 0 10 0 0 0 63 16 0 0 139 1 0 0] 193 448 8 'Inspector' 416 3 34 3 576 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8400 nil 496 nil 519 nil nil nil 1522 8400 nil 1 #left nil nil nil 1552 1568 nil 1552 nil 1042 138 144 34 1 1106 #createWindow: 34 1 1154 1186 8 #[235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 193 8432 8 '' 8400 3 8 #() 834 193 193 nil 27 1312 834 193 193 nil 27 )!

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

