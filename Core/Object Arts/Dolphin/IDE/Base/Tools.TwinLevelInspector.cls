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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1149239296 131073 32 nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 518 #{Kernel.STBCollectionProxy} #{Core.LookupTable} 50 2 518 #{Core.Association} 18 #{UI.ListView} 50 45 nil 32 50 2 8 1409372236 1 256 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 5 nil nil nil 256 nil nil 518 #{Core.Message} #displayString 8 #() 418 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil 518 #{Graphics.Point} 129 129 nil nil 354 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 418 #displayString 448 418 #<= 8 #() nil nil 256 nil 1 nil nil #thumbnails 8 #() 530 193 193 131169 530 65 65 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 256 nil nil nil nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 193 288 8 'Column 1' 256 3 8 #() 530 193 193 nil 35 518 #{Core.Fraction} 901 1227 226 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1409286144 131073 1024 nil nil nil 5 nil nil nil 1024 146 178 #{Core.Dictionary} 50 1 226 18 #{UI.Splitter} 50 12 nil 1024 50 2 8 1140850688 1 1152 nil 128 nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 1152 nil 1 #left nil nil nil 530 1 1 530 9 9 nil 1248 nil 754 50 1 802 #createWindow: 50 1 850 882 8 #[0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 193 1184 8 '' 1152 1 8 #() 530 193 193 nil 27 1 true 550 #{Core.IdentityDictionary} 0 nil 754 50 1 802 #createWindow: 50 1 850 882 8 #[240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 193 1056 8 '' 1024 3 50 2 1152 18 #{UI.CardContainer} 50 16 nil 1024 50 2 8 1409286144 131073 1616 nil nil nil 5 nil nil nil 1616 1350 1 #{UI.CardLayout} 354 2 226 #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 1616 50 2 8 1140953421 1 1744 322 354 0 nil 400 nil nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1890 1 1922 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1890 1 1922 #browseIt 8 '&Browse It' 1 1 1970 nil true 2002 8 'ClassBrowserShell.ico' 2064 65541 nil nil nil 2146 4097 1890 1 1922 #copyAspect 8 '&Copy' 1 1 nil nil nil 1890 1 1922 #pasteAspect 8 '&Paste <d>' 1 1 nil nil nil 2146 4097 1890 1 1922 #editAspect 8 '&Edit' 1 1 nil nil nil 1890 1 1922 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 2146 4097 1890 1 1922 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1744 nil nil 418 #valueText 8 #() nil 512 nil nil nil nil nil nil 354 3 578 8 'Property' 361 #left 418 #valueNameOnly 8 #() 418 #<= 8 #() nil nil 1744 418 #typeImage 8 #() 3 418 #valueNameInfo 8 #() nil 578 8 'Value' 361 #left 418 #valueTextOnly 8 #() 418 #<= 2704 nil nil 1744 418 #valueImage 2832 3 nil nil 578 8 '' 41 #center 418 #displayString 8 #() 418 #<= 2928 nil nil 1744 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 2960 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 2976 7 257 nil 1 nil nil #report 672 nil 359 530 129 129 1 nil nil nil nil 1 722 1744 nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 400 354 0 nil nil 2962 0 nil 1318 #{Kernel.CompiledMethod} 2 3 3136 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3152 2962 0 nil 3202 1 83886083 3136 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3248 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 13 5 nil nil nil nil nil nil nil 754 50 2 802 #createWindow: 50 1 850 882 8 #[4 0 0 0 4 0 0 0 128 1 0 0 83 1 0 0] 193 1776 8 'Property' 1744 802 #contextMenu: 50 1 1856 1744 1 8 #() 530 193 193 nil 2029 226 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 1616 50 2 8 1411453252 1 3568 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 1842 nil true 50 13 1890 1 1922 #accept 8 '&Accept' 1 1 nil nil nil 2146 4097 1842 nil true 50 10 1890 1 1922 #undo 8 '&Undo' 1 1 1970 nil true 2002 8 'EditUndo.ico' 2064 65541 nil nil nil 2146 4097 1890 1 1922 #cutSelection 8 'Cu&t' 1 1 1970 nil true 2002 8 'EditCut.ico' 2064 65541 nil nil nil 1890 1 1922 #copySelection 8 '&Copy' 1 1 1970 nil true 2002 8 'EditCopy.ico' 2064 65541 nil nil nil 1890 1 1922 #pasteClipboard 8 '&Paste' 1 1 1970 nil true 2002 8 'EditPaste.ico' 2064 65541 nil nil nil 1890 1 1922 #clearSelection 8 'De&lete' 1 1 1970 nil true 2002 8 'EditClear.ico' 2064 65541 nil nil nil 2146 4097 1890 1 1922 #reformatSource 8 'Re&format' 1 1 nil nil nil 2146 4097 1890 1 1922 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1842 nil true 50 10 1890 1 1922 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1890 1 1922 #cloneNew 8 '&Clone' 1 1 1970 nil true 2002 8 'SmalltalkWorkspace.ico' 2064 65541 nil nil nil 2146 4097 1890 1 1922 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1890 1 1922 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1890 1 1922 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1890 1 1922 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1890 1 1922 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1890 1 1922 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1890 1 1922 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 2146 4097 1890 1 1922 #browseIt 8 'Bro&wse It' 1 1 1970 nil true 2002 8 'ClassBrowserShell.ico' 2064 65541 nil nil nil 1890 1 1922 #displayIt 8 '&Display It' 1 1 1970 nil true 2002 8 'DisplayIt.ico' 2064 65541 nil nil nil 1890 1 1922 #printIt 8 '&Print It' 1 1 1970 nil true 2002 8 'PrintIt.ico' 2064 65541 nil nil nil 1890 1 1922 #evaluateIt 8 'E&valuate It' 1 1 1970 nil true 2002 8 'EvaluateIt.ico' 2064 65541 nil nil nil 1890 1 1922 #inspectIt 8 '&Inspect It' 1 1 1970 nil true 2002 8 'InspectIt.ico' 2064 65541 nil nil nil 1890 1 1922 #debugIt 8 'Deb&ug It' 1 1 1970 nil true 2002 8 'Debugger.ico' 2064 65541 nil nil nil 2146 4097 1842 nil true 50 2 1890 2097153 1922 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1890 1 1922 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3568 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 1442 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 114 #gray 114 #white 1 nil nil nil nil #callTip nil nil nil #normal 5906 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 354 0 1442 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 3568 #circle nil nil nil nil nil nil 3330 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 6098 1 81 114 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 1442 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 1442 1 #container 5888 nil nil nil nil #{Core.Utf8String} nil 1442 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 3568 114 #red 3 3 #Error nil nil nil nil nil nil #Notification 6290 17 3568 114 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 6290 19 3568 114 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 1442 3 #Error 5906 1031 114 #firebrick 114 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 5906 1029 nil 114 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5906 1027 114 #darkGoldenrod 114 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 754 50 9 802 #createWindow: 50 1 850 882 8 #[4 0 0 0 4 0 0 0 128 1 0 0 83 1 0 0] 193 3600 nil 3568 802 #contextMenu: 50 1 3728 3568 802 #wordWrap: 8 #(true) 3568 802 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 3568 nil 3 nil nil 5 nil 6770 3 3568 nil nil nil 67108863 5 nil 6770 5 3568 nil nil nil nil 5 nil 3568 802 #tabWidth: 8 #(4) 3568 802 #maxCompletionListHeight: 8 #(9) 3568 802 #sciSetTechnology: 8 #(1) 3568 802 #sciSetFontQuality: 8 #(3) 3568 802 #sciSetSelectionLayer: 8 #(1) 3568 3 8 #() 530 193 193 nil 45 3568 nil nil nil 518 #{Kernel.STBIdentityDictionaryProxy} 1440 50 4 1744 8 'aspects' 3568 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 1616 50 2 8 1140916738 1 7104 322 354 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 400 nil nil 1 nil nil nil 7104 nil nil 2962 0 nil 2994 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 7200 7 257 nil 464 512 nil nil nil nil nil #smallIcons nil nil nil nil nil 754 50 3 802 #createWindow: 50 1 850 882 8 #[0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 193 7136 8 '' 7104 802 #setSingleSelection: 8 #(2) 7104 802 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7104 3 8 #() 530 193 193 nil 27 754 50 1 802 #createWindow: 50 1 850 882 8 #[0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 193 1648 8 '' 1616 3 50 3 1744 3568 7104 530 193 193 nil 27 530 193 193 nil 27 978 1553 1227 false 7026 1440 50 4 256 8 'contents' 1024 8 'inspector' 518 #{Graphics.Rectangle} 530 21 21 530 21 21 754 50 1 802 #createWindow: 50 1 850 882 8 #[255 14 0 0 10 0 0 0 127 17 0 0 139 1 0 0] 193 80 8 'Inspector' 32 3 50 3 256 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 7952 nil 128 nil 517 nil nil nil 1218 7952 nil 1 #left nil nil nil 1248 1264 nil 1248 nil 754 50 1 802 #createWindow: 50 1 850 882 8 #[235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 193 7984 8 '' 7952 3 8 #() 530 193 193 nil 27 1024 530 193 193 nil 27)!

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

