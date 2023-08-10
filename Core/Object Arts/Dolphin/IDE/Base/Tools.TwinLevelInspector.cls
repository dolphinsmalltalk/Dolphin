"Filed out from Dolphin Smalltalk"!

UI.Presenter
	subclass: #'Tools.TwinLevelInspector'
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1149239296 131073 32 nil 6 #{Graphics.Color} #default nil 7 nil nil nil 32 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 2 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1409286144 131073 208 nil nil nil 7 nil nil nil 208 146 294 #{Core.Dictionary} 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 208 50 2 8 1140850688 1 352 nil 128 nil 519 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 352 nil 1 #left nil nil nil 518 #{Graphics.Point} 1 1 450 9 9 nil 464 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 450 1 85 450 731 11 352 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 450 193 193 nil 27 1 true 550 #{Core.IdentityDictionary} 0 nil 498 50 1 546 #createAt:extent: 50 2 450 481 21 450 777 727 208 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 50 2 352 18 #{UI.CardContainer} 50 16 nil 208 50 2 8 1409286144 131073 880 nil nil nil 7 nil nil nil 880 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 2 322 #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 880 50 2 8 1140953421 1 1024 838 2 #{UI.ListModel} 978 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 15 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1218 1 1250 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1218 1 1250 #browseIt 8 '&Browse It' 1 1 1298 nil true 1330 8 'ClassBrowserShell.ico' 1392 65541 nil nil nil 1474 4097 1218 1 1250 #copyAspect 8 '&Copy' 1 1 nil nil nil 1218 1 1250 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1474 4097 1218 1 1250 #editAspect 8 '&Edit' 1 1 nil nil nil 1218 1 1250 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 1474 4097 1218 1 1250 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1024 nil 8 1853243664 518 #{Core.Message} #valueText 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 978 3 3142 5 #{UI.ListViewColumn} 8 'Property' 357 #left 1922 #valueNameOnly 8 #() 1922 #<= 8 #() nil nil 1024 1922 #typeImage 8 #() 3 1922 #valueNameInfo 8 #() nil 2018 8 'Value' 357 #left 1922 #valueTextOnly 8 #() 1922 #<= 2112 nil nil 1024 1922 #valueImage 2240 3 nil nil 2018 8 '' 41 #center 1922 #displayString 8 #() 1922 #<= 2336 nil nil 1024 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 2368 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 2384 7 257 nil 1 nil nil #report 8 #() nil 359 450 129 129 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 1152 978 0 nil nil 2370 0 nil 1318 #{Kernel.CompiledMethod} 2 3 2544 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2560 2370 0 nil 2610 1 83886083 2544 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2656 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 13 5 nil nil nil nil nil nil nil 498 50 2 546 #createAt:extent: 50 2 450 9 9 450 761 667 1024 546 #text: 50 1 8 'Property' 1024 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 688 nil 2029 322 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 880 50 2 8 1411453252 1 2976 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 1170 nil true 50 13 1218 1 1250 #accept 8 '&Accept' 1 1 nil nil nil 1474 4097 1170 nil true 50 10 1218 1 1250 #undo 8 '&Undo' 1 1 1298 nil true 1330 8 'EditUndo.ico' 1392 65541 nil nil nil 1474 4097 1218 1 1250 #cutSelection 8 'Cu&t' 1 1 1298 nil true 1330 8 'EditCut.ico' 1392 65541 nil nil nil 1218 1 1250 #copySelection 8 '&Copy' 1 1 1298 nil true 1330 8 'EditCopy.ico' 1392 65541 nil nil nil 1218 1 1250 #pasteClipboard 8 '&Paste' 1 1 1298 nil true 1330 8 'EditPaste.ico' 1392 65541 nil nil nil 1218 1 1250 #clearSelection 8 'De&lete' 1 1 1298 nil true 1330 8 'EditClear.ico' 1392 65541 nil nil nil 1474 4097 1218 1 1250 #reformatSource 8 'Re&format' 1 1 nil nil nil 1474 4097 1218 1 1250 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1170 nil true 50 10 1218 1 1250 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1218 1 1250 #cloneNew 8 '&Clone' 1 1 1298 nil true 1330 8 'SmalltalkWorkspace.ico' 1392 65541 nil nil nil 1474 4097 1218 1 1250 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1218 1 1250 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1218 1 1250 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1218 1 1250 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1218 1 1250 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1218 1 1250 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1218 1 1250 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1474 4097 1218 1 1250 #browseIt 8 'Bro&wse It' 1 1 1298 nil true 1330 8 'ClassBrowserShell.ico' 1392 65541 nil nil nil 1218 1 1250 #displayIt 8 '&Display It' 1 1 1298 nil true 1330 8 'DisplayIt.ico' 1392 65541 nil nil nil 1218 1 1250 #printIt 8 '&Print It' 1 1 1298 nil true 1330 8 'PrintIt.ico' 1392 65541 nil nil nil 1218 1 1250 #evaluateIt 8 'E&valuate It' 1 1 1298 nil true 1330 8 'EvaluateIt.ico' 1392 65541 nil nil nil 1218 1 1250 #inspectIt 8 '&Inspect It' 1 1 1298 nil true 1330 8 'InspectIt.ico' 1392 65541 nil nil nil 1218 1 1250 #debugIt 8 'Deb&ug It' 1 1 1298 nil true 1330 8 'Debugger.ico' 1392 65541 nil nil nil 1474 4097 1170 nil true 50 2 1218 2097153 1250 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1218 1 1250 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 2976 nil 8 1367644576 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 706 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 114 #gray 114 #white 1 nil nil nil nil #callTip nil nil nil #normal 5330 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 978 0 706 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 2976 #circle nil nil nil nil nil nil 2738 0 nil 178 0 9215 nil nil 178 1 81 114 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 706 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 706 1 #container 5312 nil nil nil nil #{Core.AnsiString} nil 706 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 2976 114 #red 3 3 #Error nil nil nil nil nil nil #Notification 5698 17 2976 114 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 5698 19 2976 114 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 706 3 #Error 5330 1031 114 #firebrick 114 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 5330 1029 nil 114 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5330 1027 114 #darkGoldenrod 114 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 498 50 8 546 #createAt:extent: 50 2 450 9 9 450 761 667 2976 546 #wordWrap: 8 #(true) 2976 546 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 2976 nil 3 nil nil 5 nil 6130 3 2976 nil nil nil 67108863 5 nil 6130 5 2976 nil nil nil nil 5 nil 2976 546 #tabWidth: 8 #(4) 2976 546 #maxCompletionListHeight: 8 #(9) 2976 546 #sciSetTechnology: 8 #(1) 2976 546 #sciSetFontQuality: 8 #(3) 2976 546 #sciSetSelectionLayer: 8 #(1) 2976 626 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 688 nil 45 1024 nil nil nil 706 2 1024 8 'aspects' 2976 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 880 50 2 8 1140916738 1 6448 1090 978 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 1152 nil nil 3 nil nil nil 6448 nil 8 1852839600 2370 0 nil 2402 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 6560 7 257 nil 1922 #iconImageIndex 8 #() 1984 nil nil nil nil nil #smallIcons nil nil nil nil nil 498 50 3 546 #createAt:extent: 50 2 450 1 1 450 777 727 6448 546 #setSingleSelection: 8 #(1) 6448 546 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6448 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 688 nil 27 498 50 1 546 #createAt:extent: 50 2 450 1 1 450 777 727 880 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 50 3 1024 2976 6448 688 nil 27 688 nil 27 518 #{Core.Fraction} 1553 1227 18 #{UI.ListView} 50 45 nil 32 50 2 8 1409372236 1 7040 1090 978 0 nil 1152 nil nil 7 nil nil nil 7040 nil 8 1853243664 1922 #displayString 8 #() 6624 1984 nil nil nil 450 129 129 nil nil 978 1 2018 8 'Column 1' 201 #left 1922 #displayString 7168 1922 #<= 8 #() nil nil 7040 nil 1 nil nil #thumbnails 2512 450 193 193 131169 450 65 65 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 498 50 2 546 #createAt:extent: 50 2 450 21 21 450 451 727 7040 546 #text: 50 1 8 'Column 1' 7040 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 688 nil 35 7010 901 1227 false 706 2 208 8 'inspector' 7040 8 'contents' 518 #{Graphics.Rectangle} 450 21 21 450 21 21 498 50 2 546 #createAt:extent: 50 2 450 6143 21 450 1281 771 32 546 #text: 50 1 8 'Inspector' 32 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 127 14 0 0 139 1 0 0] 50 3 7040 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 7840 nil 128 nil 519 nil nil nil 418 7840 nil 1 #left nil nil nil 464 480 nil 464 nil 498 50 1 546 #createAt:extent: 50 2 450 471 21 450 11 727 7840 626 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 688 nil 27 208 688 nil 27)!

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

