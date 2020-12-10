"Filed out from Dolphin Smalltalk 7"!

UI.Presenter subclass: #'Tools.TwinLevelInspector'
	instanceVariableNames: 'contentsPresenter inspectorPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.TwinLevelInspector guid: (Core.GUID fromString: '{dc9a61d9-617e-42a8-bb8a-a84102ae8002}')!
Tools.TwinLevelInspector comment: ''!
!Tools.TwinLevelInspector categoriesForClass!MVP-Presenters! !
!Tools.TwinLevelInspector methodsFor!

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
!Tools.TwinLevelInspector categoriesFor: #aspectAccessor!public! !
!Tools.TwinLevelInspector categoriesFor: #createComponents!private! !
!Tools.TwinLevelInspector categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.TwinLevelInspector categoriesFor: #inspectorPresenter!public! !
!Tools.TwinLevelInspector categoriesFor: #isRootAspectVisible:!accessing!public! !
!Tools.TwinLevelInspector categoriesFor: #model:!public! !
!Tools.TwinLevelInspector categoriesFor: #onContentsSelectionChanged!private! !
!Tools.TwinLevelInspector categoriesFor: #selectionOrNil!public!selection! !
!Tools.TwinLevelInspector categoriesFor: #selectionOrNil:!public!selection! !

!Tools.TwinLevelInspector class methodsFor!

defaultModel
	^ListModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 576 nil nil nil 7 nil nil nil 576 514 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 576 34 2 8 1140850688 1 720 nil 496 nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 720 nil 1 #left nil nil nil 918022 ##(Graphics.Point) 1 1 818 9 9 nil 832 nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 818 1 85 818 731 11 720 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 818 193 193 nil 27 1 true 170 192 8 #() nil 866 138 144 34 1 930 #createAt:extent: 34 2 818 481 21 818 777 727 576 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 720 410 ##(UI.CardContainer) 34 16 nil 576 34 2 8 1409286144 131073 1280 nil nil nil 7 nil nil nil 1280 853318 1 ##(UI.CardLayout) 138 144 34 2 690 ##(Tools.PropertyInspector) 410 ##(UI.ListTreeView) 34 59 nil 1280 34 2 8 1140953421 1 1424 787270 2 ##(UI.ListModel) 138 144 1104 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 15 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #inspectIt 8 '&Inspect' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1618 1 1650 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1618 1 1650 #browseIt 8 '&Browse It' 1 1 1698 nil true 1744 8 'ClassBrowserShell.ico' 1792 nil nil 1874 4097 1618 1 1650 #copyAspect 8 '&Copy' 1 1 nil nil nil 1618 1 1650 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1874 4097 1618 1 1650 #editAspect 8 '&Edit' 1 1 nil nil nil 1618 1 1650 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1874 4097 1618 1 1650 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1424 nil 8 1801282304 786950 ##(Core.Message) #valueText 8 #() nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Property' 357 #left 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 2304 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 2480 7 257 nil 2306 #<= 8 #() nil nil 1424 nil 3 nil nil 2418 8 'Value' 357 #left 2466 0 nil 2498 2 1 2464 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 2640 7 257 nil 2306 #<= 2592 nil nil 1424 2466 0 nil 2498 2 1 2464 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2736 7 257 nil 3 nil nil 2418 8 '' 41 #center 2306 #displayString 8 #() 2306 #<= 2864 nil nil 1424 2466 0 nil 2498 3 1 2464 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Tools.PropertyInspector) #editButtonImageIndexFor: 2896 7 257 nil 1 nil nil #report 8 #() nil 359 818 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 ##(UI.VirtualTreeModel) nil 1552 138 144 1104 nil nil 2466 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 3008 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3024 2466 0 nil 3074 1 83886083 3008 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3120 7 257 nil nil 138 ##(Core.PluggableSet) 1104 138 ##(Core.IdentitySet) 1104 13 5 nil nil nil nil nil nil nil 866 138 144 34 3 930 #createAt:extent: 34 2 818 9 9 818 761 667 1424 930 #contextMenu: 34 1 1584 1424 930 #text: 34 1 8 'Property' 1424 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1072 nil 2029 690 ##(Tools.ValueWorkspace) 410 ##(UI.Scintilla.ScintillaView) 34 50 nil 1280 34 2 8 1411453252 1 3456 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 1245702 ##(Graphics.ThemeColor) #smalltalkWorkspace nil 21 1570 nil true 34 13 1618 1 1650 #accept 8 '&Accept' 1 1 nil nil nil 1874 4097 1570 nil true 34 10 1618 1 1650 #undo 8 '&Undo' 1 1 1698 nil true 1744 8 'EditUndo.ico' 1792 nil nil 1874 4097 1618 1 1650 #cutSelection 8 'Cu&t' 1 1 1698 nil true 1744 8 'EditCut.ico' 1792 nil nil 1618 1 1650 #copySelection 8 '&Copy' 1 1 1698 nil true 1744 8 'EditCopy.ico' 1792 nil nil 1618 1 1650 #pasteClipboard 8 '&Paste' 1 1 1698 nil true 1744 8 'EditPaste.ico' 1792 nil nil 1618 1 1650 #clearSelection 8 'De&lete' 1 1 1698 nil true 1744 8 'EditClear.ico' 1792 nil nil 1874 4097 1618 1 1650 #reformatSource 8 'Re&format' 1 1 nil nil nil 1874 4097 1618 1 1650 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1570 nil true 34 10 1618 1 1650 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1618 1 1650 #cloneNew 8 '&Clone' 1 1 1698 nil true 1744 8 'SmalltalkWorkspace.ico' 1792 nil nil 1874 4097 1618 1 1650 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1618 1 1650 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1618 1 1650 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1618 1 1650 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 1 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1618 1 1650 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1618 1 1650 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1618 1 1650 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1874 4097 1618 1 1650 #browseIt 8 'Bro&wse It' 1 1 1698 nil true 1744 8 'ClassBrowserShell.ico' 1792 nil nil 1618 1 1650 #displayIt 8 '&Display It' 1 1 1698 nil true 1744 8 'DisplayIt.ico' 1792 nil nil 1618 1 1650 #printIt 8 '&Print It' 1 1 1698 nil true 1744 8 'PrintIt.ico' 1792 nil nil 1618 1 1650 #evaluateIt 8 'E&valuate It' 1 1 1698 nil true 1744 8 'EvaluateIt.ico' 1792 nil nil 1618 1 1650 #inspectIt 8 '&Inspect It' 1 1 1698 nil true 1744 8 'InspectIt.ico' 1792 nil nil 1618 1 1650 #debugIt 8 'Deb&ug It' 1 1 1698 nil true 1744 8 'Debugger.ico' 1792 nil nil 1874 4097 1570 nil true 34 2 1618 2097153 1650 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1618 1 1650 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3456 nil 8 2031697384 1049094 ##(UI.NullConverter) nil nil 9 1848897633 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 5634 77 482 #gray 482 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 1104 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 3456 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 1104 nil 170 176 1104 9215 nil nil nil nil 482 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 5600 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 3 ##(UI.Scintilla.IndicatorStyle) 17 3456 482 #commonGreen 11 false #Notification nil nil nil nil nil nil #Warning 6034 19 3456 482 #blue 3 false #Warning nil nil nil nil nil nil #Error 6034 21 3456 482 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 5634 1029 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5634 1027 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 5634 1031 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 866 138 144 34 10 930 #createAt:extent: 34 2 818 9 9 818 761 667 3456 930 #contextMenu: 34 1 3616 3456 930 #hoverTime: 8 #(500) 3456 930 #caretPeriod: 8 #(530) 3456 930 #wordWrap: 8 #(true) 3456 930 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 3456 1 3 nil nil 5 nil 6594 3 3456 1 nil nil 67108863 5 nil 6594 5 3456 1 nil nil nil 5 nil 3456 930 #tabWidth: 8 #(4) 3456 930 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 3456 930 #maxCompletionListHeight: 8 #(9) 3456 930 #edgeColumn: 8 #(1) 3456 1010 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1072 nil 31 1424 nil nil nil 170 192 34 4 3456 8 'workspace' 1424 8 'aspects' nil 410 ##(UI.TabViewXP) 34 28 nil 1280 34 2 8 1140916738 1 6928 1490 138 144 8 #(##(Tools.PropertyInspector) ##(Tools.ValueWorkspace)) nil 1552 nil nil 3 nil nil nil 6928 nil 8 1801049728 2466 0 nil 2498 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7056 7 257 nil 2466 0 nil 3074 2 3 ##(UI.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7120 7 257 nil 2368 nil nil nil nil nil #smallIcons nil nil nil nil nil 866 138 144 34 3 930 #createAt:extent: 34 2 818 1 1 818 777 727 6928 930 #setSingleSelection: 8 #(1) 6928 930 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6928 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1072 nil 27 866 138 144 34 1 930 #createAt:extent: 34 2 818 1 1 818 777 727 1280 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 1424 3456 6928 1072 nil 27 1072 nil 27 852486 ##(Core.Fraction) 1553 1227 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1409372236 1 7584 1490 138 144 1104 nil 1552 nil nil 7 nil nil nil 7584 nil 8 1801282304 2306 #displayString 8 #() ##(UI.IconicListAbstract) 2368 nil nil nil 818 129 129 nil nil 138 144 34 1 2418 8 'Column 1' 201 #left 2306 #displayString 7712 2306 #<= 8 #() nil nil 7584 nil 1 nil nil #thumbnails 2976 818 193 193 131169 818 65 65 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 138 144 34 2 930 #createAt:extent: 34 2 818 21 21 818 451 727 7584 930 #text: 34 1 8 'Column 1' 7584 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 1072 nil 35 7554 901 1227 false 170 192 34 4 576 8 'inspector' 7584 8 'contents' 1180166 ##(Graphics.Rectangle) 818 21 21 818 21 21 866 138 144 34 2 930 #createAt:extent: 34 2 818 6143 21 818 1281 771 416 930 #text: 34 1 8 'Inspector' 416 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 127 14 0 0 139 1 0 0] 34 3 7584 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8448 nil 496 nil 519 nil nil nil 786 8448 nil 1 #left nil nil nil 832 848 nil 832 nil 866 138 144 34 1 930 #createAt:extent: 34 2 818 471 21 818 11 727 8448 1010 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1072 nil 27 576 1072 nil 27 )!

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
!Tools.TwinLevelInspector class categoriesFor: #defaultModel!public! !
!Tools.TwinLevelInspector class categoriesFor: #icon!constants!public! !
!Tools.TwinLevelInspector class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.TwinLevelInspector class categoriesFor: #shellOn:caption:!instance creation!public! !

