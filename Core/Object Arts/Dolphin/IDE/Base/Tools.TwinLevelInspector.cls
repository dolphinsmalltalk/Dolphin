"Filed out from Dolphin Smalltalk"!

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
!Tools.TwinLevelInspector categoriesForMethods!
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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 170 176 34 4 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1409372236 1 576 787270 2 ##(UI.ListModel) 138 144 8 #() nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 7 nil nil nil 576 nil 8 1852011696 786950 ##(Core.Message) #displayString 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil 918022 ##(Graphics.Point) 129 129 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Column 1' 201 #left 754 #displayString 784 754 #<= 8 #() nil nil 576 nil 1 nil nil #thumbnails 8 #() 834 193 193 131169 834 65 65 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 ##(Core.MessageSequence) 34 2 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 834 21 21 834 451 727 576 1090 #text: 34 1 8 'Column 1' 576 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 834 193 193 nil 35 852486 ##(Core.Fraction) 901 1227 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 1328 nil nil nil 7 nil nil nil 1328 514 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 1328 34 2 8 1140850688 1 1472 nil 496 nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 1472 nil 1 #left nil nil nil 834 1 1 834 9 9 nil 1568 nil 1042 34 1 1090 #createAt:extent: 34 2 834 1 85 834 731 11 1472 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1280 nil 27 1 true 170 192 688 nil 1042 34 1 1090 #createAt:extent: 34 2 834 481 21 834 777 727 1328 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 1472 410 ##(UI.CardContainer) 34 16 nil 1328 34 2 8 1409286144 131073 1904 nil nil nil 7 nil nil nil 1904 853318 1 ##(UI.CardLayout) 138 144 34 2 1442 ##(Tools.PropertyInspector) 410 ##(UI.ListTreeView) 34 59 nil 1904 34 2 8 1140953421 1 2048 642 138 144 688 nil 720 nil nil 15 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #inspectIt 8 '&Inspect' 1 1 852806 4 ##(Graphics.Icon) nil true 2819078 ##(Graphics.ImageFromStringResourceInitializer) 8 'BasicInspector.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 2194 1 2226 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 2194 1 2226 #browseIt 8 '&Browse It' 1 1 2274 nil true 2306 8 'ClassBrowserShell.ico' 2368 65541 nil nil nil 2450 4097 2194 1 2226 #copyAspect 8 '&Copy' 1 1 nil nil nil 2194 1 2226 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2450 4097 2194 1 2226 #editAspect 8 '&Edit' 1 1 nil nil nil 2194 1 2226 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 2450 4097 2194 1 2226 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2048 nil 8 1852011696 754 #valueText 8 #() nil 816 nil nil nil nil nil nil 138 144 34 3 898 8 'Property' 357 #left 754 #valueNameOnly 8 #() 754 #<= 8 #() nil nil 2048 754 #typeImage 8 #() 3 754 #valueNameInfo 8 #() nil 898 8 'Value' 357 #left 754 #valueTextOnly 8 #() 754 #<= 3040 nil nil 2048 754 #valueImage 3168 3 nil nil 898 8 '' 41 #center 754 #displayString 8 #() 754 #<= 3264 nil nil 2048 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 3296 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Tools.PropertyInspector) #editButtonImageIndexFor: 3312 7 257 nil 1 nil nil #report 992 nil 359 834 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 ##(UI.VirtualTreeModel) nil 720 138 144 688 nil nil 3298 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 3424 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3440 3298 0 nil 3490 1 83886083 3424 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3536 7 257 nil nil 138 ##(Core.PluggableSet) 688 138 ##(Core.IdentitySet) 688 13 5 nil nil nil nil nil nil nil 1042 34 3 1090 #createAt:extent: 34 2 834 9 9 834 761 667 2048 1090 #contextMenu: 34 1 2160 2048 1090 #text: 34 1 8 'Property' 2048 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1280 nil 2029 1442 ##(Tools.ValueWorkspace) 410 ##(UI.Scintilla.ScintillaView) 34 52 nil 1904 34 2 8 1411453252 1 3856 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 1245702 ##(Graphics.ThemeColor) #smalltalkWorkspace nil 21 2146 nil true 34 13 2194 1 2226 #accept 8 '&Accept' 1 1 nil nil nil 2450 4097 2146 nil true 34 10 2194 1 2226 #undo 8 '&Undo' 1 1 2274 nil true 2306 8 'EditUndo.ico' 2368 65541 nil nil nil 2450 4097 2194 1 2226 #cutSelection 8 'Cu&t' 1 1 2274 nil true 2306 8 'EditCut.ico' 2368 65541 nil nil nil 2194 1 2226 #copySelection 8 '&Copy' 1 1 2274 nil true 2306 8 'EditCopy.ico' 2368 65541 nil nil nil 2194 1 2226 #pasteClipboard 8 '&Paste' 1 1 2274 nil true 2306 8 'EditPaste.ico' 2368 65541 nil nil nil 2194 1 2226 #clearSelection 8 'De&lete' 1 1 2274 nil true 2306 8 'EditClear.ico' 2368 65541 nil nil nil 2450 4097 2194 1 2226 #reformatSource 8 'Re&format' 1 1 nil nil nil 2450 4097 2194 1 2226 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2146 nil true 34 10 2194 1 2226 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 2194 1 2226 #cloneNew 8 '&Clone' 1 1 2274 nil true 2306 8 'SmalltalkWorkspace.ico' 2368 65541 nil nil nil 2450 4097 2194 1 2226 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2194 1 2226 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2194 1 2226 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2194 1 2226 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2194 1 2226 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2194 1 2226 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2194 1 2226 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 2450 4097 2194 1 2226 #browseIt 8 'Bro&wse It' 1 1 2274 nil true 2306 8 'ClassBrowserShell.ico' 2368 65541 nil nil nil 2194 1 2226 #displayIt 8 '&Display It' 1 1 2274 nil true 2306 8 'DisplayIt.ico' 2368 65541 nil nil nil 2194 1 2226 #printIt 8 '&Print It' 1 1 2274 nil true 2306 8 'PrintIt.ico' 2368 65541 nil nil nil 2194 1 2226 #evaluateIt 8 'E&valuate It' 1 1 2274 nil true 2306 8 'EvaluateIt.ico' 2368 65541 nil nil nil 2194 1 2226 #inspectIt 8 '&Inspect It' 1 1 2274 nil true 2306 8 'InspectIt.ico' 2368 65541 nil nil nil 2194 1 2226 #debugIt 8 'Deb&ug It' 1 1 2274 nil true 2306 8 'Debugger.ico' 2368 65541 nil nil nil 2450 4097 2146 nil true 34 2 2194 2097153 2226 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 2194 1 2226 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3856 nil 8 2039292984 1049094 ##(UI.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6226 77 482 #gray 482 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 688 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 3856 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 688 nil 170 176 688 9215 nil nil 170 176 34 2 81 482 #windowText nil nil 2162950 ##(UI.Scintilla.NullScintillaLibrary) nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6192 nil nil nil nil 16 nil 170 192 34 6 #Warning 1772614 4 ##(UI.Scintilla.IndicatorStyle) 19 3856 482 #blue 3 3 #Warning nil nil nil nil nil nil #Error 6690 21 3856 482 #red 3 3 #Error nil nil nil nil nil nil #Notification 6690 17 3856 482 #commonGreen 11 3 #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 6226 1027 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6226 1031 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6226 1029 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil 1042 34 9 1090 #createAt:extent: 34 2 834 9 9 834 761 667 3856 1090 #contextMenu: 34 1 4016 3856 1090 #wordWrap: 8 #(true) 3856 1090 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 3856 1 3 nil nil 5 nil 7170 3 3856 1 nil nil 67108863 5 nil 7170 5 3856 1 nil nil nil 5 nil 3856 1090 #tabWidth: 8 #(4) 3856 1090 #maxCompletionListHeight: 8 #(9) 3856 1090 #sciSetTechnology: 8 #(1) 3856 1090 #sciSetFontQuality: 8 #(3) 3856 1090 #sciSetSelectionLayer: 8 #(1) 3856 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1280 nil 35 2048 nil nil nil 170 192 34 4 3856 8 'workspace' 2048 8 'aspects' nil 410 ##(UI.TabViewXP) 34 28 nil 1904 34 2 8 1140916738 1 7504 642 138 144 8 #(##(Tools.PropertyInspector) ##(Tools.ValueWorkspace)) nil 720 nil nil 3 nil nil nil 7504 nil 8 1851825008 3298 0 nil 3330 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7632 7 257 nil 3298 0 nil 3490 2 3 ##(UI.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7696 7 257 nil 816 nil nil nil nil nil #smallIcons nil nil nil nil nil 1042 34 3 1090 #createAt:extent: 34 2 834 1 1 834 777 727 7504 1090 #setSingleSelection: 8 #(1) 7504 1090 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7504 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1280 nil 27 1042 34 1 1090 #createAt:extent: 34 2 834 1 1 834 777 727 1904 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 2048 3856 7504 1280 nil 27 1280 nil 27 1298 1553 1227 false 170 192 34 4 576 8 'contents' 1328 8 'inspector' 1180166 ##(Graphics.Rectangle) 834 21 21 834 21 21 1042 34 2 1090 #createAt:extent: 34 2 834 12287 21 834 1281 771 416 1090 #text: 34 1 8 'Inspector' 416 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 127 26 0 0 139 1 0 0] 34 3 576 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8432 nil 496 nil 519 nil nil nil 1538 8432 nil 1 #left nil nil nil 1568 1584 nil 1568 nil 1042 34 1 1090 #createAt:extent: 34 2 834 471 21 834 11 727 8432 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1280 nil 27 1328 1280 nil 27)!

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
!Tools.TwinLevelInspector class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
shellOn:caption:!instance creation!public! !
!

