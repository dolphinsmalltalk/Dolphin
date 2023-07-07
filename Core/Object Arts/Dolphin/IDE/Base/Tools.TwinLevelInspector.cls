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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1149239296 131073 416 nil 917510 #{Graphics.Color} #default nil 7 nil nil nil 416 1376774 #{UI.ProportionalLayout} 170 176 34 4 410 #{UI.ListView} 34 45 nil 416 34 2 8 1409372236 1 576 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} nil nil 7 nil nil nil 576 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() 754 #iconImageIndex 8 #() 1639750 1 #{Graphics.IconImageManager} nil nil nil 918022 #{Graphics.Point} 129 129 nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 754 #displayString 784 754 #<= 8 #() nil nil 576 nil 1 nil nil #thumbnails 8 #() 866 193 193 131169 866 65 65 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 2 1049350 #{Core.MessageSend} #createAt:extent: 34 2 866 21 21 866 451 727 576 1122 #text: 34 1 8 'Column 1' 576 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 866 193 193 nil 35 852486 #{Core.Fraction} 901 1227 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1409286144 131073 1360 nil nil nil 7 nil nil nil 1360 514 138 #{Core.Dictionary} 34 1 1049094 #{Core.Association} 410 #{UI.Splitter} 34 12 nil 1360 34 2 8 1140850688 1 1504 nil 496 nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 1504 nil 1 #left nil nil nil 866 1 1 866 9 9 nil 1600 nil 1074 34 1 1122 #createAt:extent: 34 2 866 1 85 866 731 11 1504 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1312 nil 27 1 true 170 192 688 nil 1074 34 1 1122 #createAt:extent: 34 2 866 481 21 866 777 727 1360 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 1504 410 #{UI.CardContainer} 34 16 nil 1360 34 2 8 1409286144 131073 1936 nil nil nil 7 nil nil nil 1936 853318 1 #{UI.CardLayout} 138 144 34 2 1474 #{Tools.PropertyInspector} 410 #{UI.ListTreeView} 34 59 nil 1936 34 2 8 1140953421 1 2080 642 138 144 688 nil 720 nil nil 15 461638 4 #{UI.Menu} nil true 34 12 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 2226 1 2258 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 2226 1 2258 #browseIt 8 '&Browse It' 1 1 2306 nil true 2338 8 'ClassBrowserShell.ico' 2400 65541 nil nil nil 2482 4097 2226 1 2258 #copyAspect 8 '&Copy' 1 1 nil nil nil 2226 1 2258 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2482 4097 2226 1 2258 #editAspect 8 '&Edit' 1 1 nil nil nil 2226 1 2258 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 2482 4097 2226 1 2258 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2080 nil 8 1815049392 754 #valueText 8 #() nil 848 nil nil nil nil nil nil 138 144 34 3 930 8 'Property' 357 #left 754 #valueNameOnly 8 #() 754 #<= 8 #() nil nil 2080 754 #typeImage 8 #() 3 754 #valueNameInfo 8 #() nil 930 8 'Value' 357 #left 754 #valueTextOnly 8 #() 754 #<= 3072 nil nil 2080 754 #valueImage 3200 3 nil nil 930 8 '' 41 #center 754 #displayString 8 #() 754 #<= 3296 nil nil 2080 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 3 1 3328 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1442886 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 3344 7 257 nil 1 nil nil #report 1024 nil 359 866 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 #{UI.VirtualTreeModel} nil 720 138 144 688 nil nil 3330 0 nil 1377574 #{Kernel.CompiledMethod} 2 3 3488 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3504 3330 0 nil 3554 1 83886083 3488 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3600 7 257 nil nil 138 #{Core.PluggableSet} 688 138 #{Core.IdentitySet} 688 13 5 nil nil nil nil nil nil nil 1074 34 3 1122 #createAt:extent: 34 2 866 9 9 866 761 667 2080 1122 #contextMenu: 34 1 2192 2080 1122 #text: 34 1 8 'Property' 2080 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1312 nil 2029 1474 #{Tools.ValueWorkspace} 410 #{UI.Scintilla.ScintillaView} 34 52 nil 1936 34 2 8 1411453252 1 3920 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 1245702 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 2178 nil true 34 13 2226 1 2258 #accept 8 '&Accept' 1 1 nil nil nil 2482 4097 2178 nil true 34 10 2226 1 2258 #undo 8 '&Undo' 1 1 2306 nil true 2338 8 'EditUndo.ico' 2400 65541 nil nil nil 2482 4097 2226 1 2258 #cutSelection 8 'Cu&t' 1 1 2306 nil true 2338 8 'EditCut.ico' 2400 65541 nil nil nil 2226 1 2258 #copySelection 8 '&Copy' 1 1 2306 nil true 2338 8 'EditCopy.ico' 2400 65541 nil nil nil 2226 1 2258 #pasteClipboard 8 '&Paste' 1 1 2306 nil true 2338 8 'EditPaste.ico' 2400 65541 nil nil nil 2226 1 2258 #clearSelection 8 'De&lete' 1 1 2306 nil true 2338 8 'EditClear.ico' 2400 65541 nil nil nil 2482 4097 2226 1 2258 #reformatSource 8 'Re&format' 1 1 nil nil nil 2482 4097 2226 1 2258 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2178 nil true 34 10 2226 1 2258 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 2226 1 2258 #cloneNew 8 '&Clone' 1 1 2306 nil true 2338 8 'SmalltalkWorkspace.ico' 2400 65541 nil nil nil 2482 4097 2226 1 2258 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2226 1 2258 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2226 1 2258 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2226 1 2258 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2226 1 2258 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2226 1 2258 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2226 1 2258 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 2482 4097 2226 1 2258 #browseIt 8 'Bro&wse It' 1 1 2306 nil true 2338 8 'ClassBrowserShell.ico' 2400 65541 nil nil nil 2226 1 2258 #displayIt 8 '&Display It' 1 1 2306 nil true 2338 8 'DisplayIt.ico' 2400 65541 nil nil nil 2226 1 2258 #printIt 8 '&Print It' 1 1 2306 nil true 2338 8 'PrintIt.ico' 2400 65541 nil nil nil 2226 1 2258 #evaluateIt 8 'E&valuate It' 1 1 2306 nil true 2338 8 'EvaluateIt.ico' 2400 65541 nil nil nil 2226 1 2258 #inspectIt 8 '&Inspect It' 1 1 2306 nil true 2338 8 'InspectIt.ico' 2400 65541 nil nil nil 2226 1 2258 #debugIt 8 'Deb&ug It' 1 1 2306 nil true 2338 8 'Debugger.ico' 2400 65541 nil nil nil 2482 4097 2178 nil true 34 2 2226 2097153 2258 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 2226 1 2258 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3920 nil 8 1395533126 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6290 77 482 #gray 482 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 138 144 688 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 3920 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 688 nil 170 176 688 9215 nil nil 170 176 34 2 81 482 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6256 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 4 #{UI.Scintilla.IndicatorDefinition} 17 3920 482 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 6754 19 3920 482 #blue 3 3 #Warning nil nil nil nil nil nil #Error 6754 21 3920 482 #red 3 3 #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 6290 1029 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 6290 1027 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 6290 1031 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 1074 34 9 1122 #createAt:extent: 34 2 866 9 9 866 761 667 3920 1122 #contextMenu: 34 1 4080 3920 1122 #wordWrap: 8 #(true) 3920 1122 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 3920 1 3 nil nil 5 nil 7234 3 3920 1 nil nil 67108863 5 nil 7234 5 3920 1 nil nil nil 5 nil 3920 1122 #tabWidth: 8 #(4) 3920 1122 #maxCompletionListHeight: 8 #(9) 3920 1122 #sciSetTechnology: 8 #(1) 3920 1122 #sciSetFontQuality: 8 #(3) 3920 1122 #sciSetSelectionLayer: 8 #(1) 3920 1250 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1312 nil 35 2080 nil nil nil 170 192 34 4 3920 8 'workspace' 2080 8 'aspects' nil 410 #{UI.TabViewXP} 34 28 nil 1936 34 2 8 1140916738 1 7568 642 138 144 8 #(#{Tools.PropertyInspector} #{Tools.ValueWorkspace}) nil 720 nil nil 3 nil nil nil 7568 nil 8 1814862704 3330 0 nil 3362 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 7696 7 257 nil 800 848 nil nil nil nil nil #smallIcons nil nil nil nil nil 1074 34 3 1122 #createAt:extent: 34 2 866 1 1 866 777 727 7568 1122 #setSingleSelection: 8 #(1) 7568 1122 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7568 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1312 nil 27 1074 34 1 1122 #createAt:extent: 34 2 866 1 1 866 777 727 1936 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 2080 3920 7568 1312 nil 27 1312 nil 27 1330 1553 1227 false 170 192 34 4 576 8 'contents' 1360 8 'inspector' 1180166 #{Graphics.Rectangle} 866 21 21 866 21 21 1074 34 2 1122 #createAt:extent: 34 2 866 12287 21 866 1281 771 416 1122 #text: 34 1 8 'Inspector' 416 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 127 26 0 0 139 1 0 0] 34 3 576 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 8448 nil 496 nil 519 nil nil nil 1570 8448 nil 1 #left nil nil nil 1600 1616 nil 1600 nil 1074 34 1 1122 #createAt:extent: 34 2 866 471 21 866 11 727 8448 1250 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1312 nil 27 1360 1312 nil 27)!

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

