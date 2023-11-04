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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1149239296 131073 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.ListView} 50 45 nil 32 50 2 8 1409372236 1 256 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 5 nil nil nil 256 nil nil 518 #{Core.Message} #displayString 8 #() 418 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil 518 #{Graphics.Point} 129 129 nil nil 354 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 418 #displayString 448 418 #<= 8 #() nil nil 256 nil 1 nil nil #thumbnails 8 #() 530 193 193 131169 530 65 65 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 2 774 #{Core.MessageSend} #createAt:extent: 50 2 530 21 21 530 451 727 256 770 #text: 50 1 8 'Column 1' 256 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 530 193 193 nil 35 518 #{Core.Fraction} 901 1227 226 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1409286144 131073 1024 nil nil nil 5 nil nil nil 1024 146 178 #{Core.Dictionary} 50 1 226 18 #{UI.Splitter} 50 12 nil 1024 50 2 8 1140850688 1 1152 nil 128 nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 1152 nil 1 #left nil nil nil 530 1 1 530 9 9 nil 1248 nil 722 50 1 770 #createAt:extent: 50 2 530 1 85 530 731 11 1152 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 960 nil 27 1 true 550 #{Core.IdentityDictionary} 0 nil 722 50 1 770 #createAt:extent: 50 2 530 481 21 530 777 727 1024 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 50 2 1152 18 #{UI.CardContainer} 50 16 nil 1024 50 2 8 1409286144 131073 1600 nil nil nil 5 nil nil nil 1600 1350 1 #{UI.CardLayout} 354 2 226 #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 1600 50 2 8 1140953421 1 1728 322 354 0 nil 400 nil nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1874 1 1906 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1874 1 1906 #browseIt 8 '&Browse It' 1 1 1954 nil true 1986 8 'ClassBrowserShell.ico' 2048 65541 nil nil nil 2130 4097 1874 1 1906 #copyAspect 8 '&Copy' 1 1 nil nil nil 1874 1 1906 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2130 4097 1874 1 1906 #editAspect 8 '&Edit' 1 1 nil nil nil 1874 1 1906 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 2130 4097 1874 1 1906 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1728 nil nil 418 #valueText 8 #() nil 512 nil nil nil nil nil nil 354 3 578 8 'Property' 357 #left 418 #valueNameOnly 8 #() 418 #<= 8 #() nil nil 1728 418 #typeImage 8 #() 3 418 #valueNameInfo 8 #() nil 578 8 'Value' 357 #left 418 #valueTextOnly 8 #() 418 #<= 2688 nil nil 1728 418 #valueImage 2816 3 nil nil 578 8 '' 41 #center 418 #displayString 8 #() 418 #<= 2912 nil nil 1728 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 2944 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 2960 7 257 nil 1 nil nil #report 672 nil 359 530 129 129 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 400 354 0 nil nil 2946 0 nil 1318 #{Kernel.CompiledMethod} 2 3 3104 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3120 2946 0 nil 3170 1 83886083 3104 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3216 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 13 5 nil nil nil nil nil nil nil 722 50 2 770 #createAt:extent: 50 2 530 9 9 530 761 667 1728 770 #text: 50 1 8 'Property' 1728 898 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 960 nil 2029 226 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 1600 50 2 8 1411453252 1 3536 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 1826 nil true 50 13 1874 1 1906 #accept 8 '&Accept' 1 1 nil nil nil 2130 4097 1826 nil true 50 10 1874 1 1906 #undo 8 '&Undo' 1 1 1954 nil true 1986 8 'EditUndo.ico' 2048 65541 nil nil nil 2130 4097 1874 1 1906 #cutSelection 8 'Cu&t' 1 1 1954 nil true 1986 8 'EditCut.ico' 2048 65541 nil nil nil 1874 1 1906 #copySelection 8 '&Copy' 1 1 1954 nil true 1986 8 'EditCopy.ico' 2048 65541 nil nil nil 1874 1 1906 #pasteClipboard 8 '&Paste' 1 1 1954 nil true 1986 8 'EditPaste.ico' 2048 65541 nil nil nil 1874 1 1906 #clearSelection 8 'De&lete' 1 1 1954 nil true 1986 8 'EditClear.ico' 2048 65541 nil nil nil 2130 4097 1874 1 1906 #reformatSource 8 'Re&format' 1 1 nil nil nil 2130 4097 1874 1 1906 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1826 nil true 50 10 1874 1 1906 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1874 1 1906 #cloneNew 8 '&Clone' 1 1 1954 nil true 1986 8 'SmalltalkWorkspace.ico' 2048 65541 nil nil nil 2130 4097 1874 1 1906 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1874 1 1906 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1874 1 1906 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1874 1 1906 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1874 1 1906 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1874 1 1906 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1874 1 1906 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 2130 4097 1874 1 1906 #browseIt 8 'Bro&wse It' 1 1 1954 nil true 1986 8 'ClassBrowserShell.ico' 2048 65541 nil nil nil 1874 1 1906 #displayIt 8 '&Display It' 1 1 1954 nil true 1986 8 'DisplayIt.ico' 2048 65541 nil nil nil 1874 1 1906 #printIt 8 '&Print It' 1 1 1954 nil true 1986 8 'PrintIt.ico' 2048 65541 nil nil nil 1874 1 1906 #evaluateIt 8 'E&valuate It' 1 1 1954 nil true 1986 8 'EvaluateIt.ico' 2048 65541 nil nil nil 1874 1 1906 #inspectIt 8 '&Inspect It' 1 1 1954 nil true 1986 8 'InspectIt.ico' 2048 65541 nil nil nil 1874 1 1906 #debugIt 8 'Deb&ug It' 1 1 1954 nil true 1986 8 'Debugger.ico' 2048 65541 nil nil nil 2130 4097 1826 nil true 50 2 1874 2097153 1906 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1874 1 1906 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3536 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 1426 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 114 #gray 114 #white 1 nil nil nil nil #callTip nil nil nil #normal 5874 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 354 0 1426 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 3536 #circle nil nil nil nil nil nil 3298 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 6066 1 81 114 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 1426 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 1426 1 #container 5856 nil nil nil nil #{Core.Utf8String} nil 1426 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 3536 114 #red 3 3 #Error nil nil nil nil nil nil #Notification 6258 17 3536 114 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 6258 19 3536 114 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 1426 3 #Error 5874 1031 114 #firebrick 114 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 5874 1029 nil 114 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5874 1027 114 #darkGoldenrod 114 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 722 50 8 770 #createAt:extent: 50 2 530 9 9 530 761 667 3536 770 #wordWrap: 8 #(true) 3536 770 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 3536 nil 3 nil nil 5 nil 6690 3 3536 nil nil nil 67108863 5 nil 6690 5 3536 nil nil nil nil 5 nil 3536 770 #tabWidth: 8 #(4) 3536 770 #maxCompletionListHeight: 8 #(9) 3536 770 #sciSetTechnology: 8 #(1) 3536 770 #sciSetFontQuality: 8 #(3) 3536 770 #sciSetSelectionLayer: 8 #(1) 3536 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 960 nil 45 3536 nil nil nil 518 #{Kernel.STBIdentityDictionaryProxy} 1424 50 4 1728 8 'aspects' 3536 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 1600 50 2 8 1140916738 1 7040 322 354 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 400 nil nil 1 nil nil nil 7040 nil nil 2946 0 nil 2978 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 7136 7 257 nil 464 512 nil nil nil nil nil #smallIcons nil nil nil nil nil 722 50 3 770 #createAt:extent: 50 2 530 1 1 530 777 727 7040 770 #setSingleSelection: 8 #(2) 7040 770 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7040 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 960 nil 27 722 50 1 770 #createAt:extent: 50 2 530 1 1 530 777 727 1600 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 50 3 1728 3536 7040 960 nil 27 960 nil 27 978 1553 1227 false 6962 1424 50 4 256 8 'contents' 1024 8 'inspector' 518 #{Graphics.Rectangle} 530 21 21 530 21 21 722 50 2 770 #createAt:extent: 50 2 530 6143 21 530 1281 771 32 770 #text: 50 1 8 'Inspector' 32 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 127 14 0 0 139 1 0 0] 50 3 256 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 7888 nil 128 nil 517 nil nil nil 1218 7888 nil 1 #left nil nil nil 1248 1264 nil 1248 nil 722 50 1 770 #createAt:extent: 50 2 530 471 21 530 11 727 7888 898 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 960 nil 27 1024 960 nil 27)!

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

