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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 576 nil nil nil 7 nil nil nil 576 514 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 576 34 2 8 1140850688 1 720 nil 496 nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 720 nil 1 #left nil nil nil 918022 ##(Graphics.Point) 1 1 818 9 9 nil 832 nil 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 818 1 85 818 731 11 720 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 818 193 193 nil 27 1 true 170 192 8 #() nil 866 34 1 914 #createAt:extent: 34 2 818 481 21 818 777 727 576 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 720 410 ##(UI.CardContainer) 34 16 nil 576 34 2 8 1409286144 131073 1248 nil nil nil 7 nil nil nil 1248 853318 1 ##(UI.CardLayout) 138 144 34 2 690 ##(Tools.PropertyInspector) 410 ##(UI.ListTreeView) 34 59 nil 1248 34 2 8 1140953421 1 1392 787270 2 ##(UI.ListModel) 138 144 1088 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 15 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #inspectIt 8 '&Inspect' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil nil nil 1586 1 1618 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1586 1 1618 #browseIt 8 '&Browse It' 1 1 1666 nil true 1712 8 'ClassBrowserShell.ico' 1760 nil nil 1842 4097 1586 1 1618 #copyAspect 8 '&Copy' 1 1 nil nil nil 1586 1 1618 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1842 4097 1586 1 1618 #editAspect 8 '&Edit' 1 1 nil nil nil 1586 1 1618 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1842 4097 1586 1 1618 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1392 nil 8 1793750192 786950 ##(Core.Message) #valueText 8 #() nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Property' 357 #left 2274 #valueNameOnly 8 #() 2274 #<= 8 #() nil nil 1392 2274 #typeImage 8 #() 3 2274 #valueNameInfo 8 #() nil 2386 8 'Value' 357 #left 2274 #valueTextOnly 1088 2274 #<= 2480 nil nil 1392 2274 #valueImage 1088 3 nil nil 2386 8 '' 41 #center 2274 #displayString 8 #() 2274 #<= 2688 nil nil 1392 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 2720 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Tools.PropertyInspector) #editButtonImageIndexFor: 2736 7 257 nil 1 nil nil #report 8 #() nil 359 818 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 ##(UI.VirtualTreeModel) nil 1520 138 144 1088 nil nil 2722 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 2864 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2880 2722 0 nil 2930 1 83886083 2864 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2976 7 257 nil nil 138 ##(Core.PluggableSet) 1088 138 ##(Core.IdentitySet) 1088 13 5 nil nil nil nil nil nil nil 866 34 3 914 #createAt:extent: 34 2 818 9 9 818 761 667 1392 914 #contextMenu: 34 1 1552 1392 914 #text: 34 1 8 'Property' 1392 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1056 nil 2029 690 ##(Tools.ValueWorkspace) 410 ##(UI.Scintilla.ScintillaView) 34 52 nil 1248 34 2 8 1411453252 1 3296 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 1245702 ##(Graphics.ThemeColor) #smalltalkWorkspace nil 21 1538 nil true 34 13 1586 1 1618 #accept 8 '&Accept' 1 1 nil nil nil 1842 4097 1538 nil true 34 10 1586 1 1618 #undo 8 '&Undo' 1 1 1666 nil true 1712 8 'EditUndo.ico' 1760 nil nil 1842 4097 1586 1 1618 #cutSelection 8 'Cu&t' 1 1 1666 nil true 1712 8 'EditCut.ico' 1760 nil nil 1586 1 1618 #copySelection 8 '&Copy' 1 1 1666 nil true 1712 8 'EditCopy.ico' 1760 nil nil 1586 1 1618 #pasteClipboard 8 '&Paste' 1 1 1666 nil true 1712 8 'EditPaste.ico' 1760 nil nil 1586 1 1618 #clearSelection 8 'De&lete' 1 1 1666 nil true 1712 8 'EditClear.ico' 1760 nil nil 1842 4097 1586 1 1618 #reformatSource 8 'Re&format' 1 1 nil nil nil 1842 4097 1586 1 1618 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1538 nil true 34 10 1586 1 1618 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1586 1 1618 #cloneNew 8 '&Clone' 1 1 1666 nil true 1712 8 'SmalltalkWorkspace.ico' 1760 nil nil 1842 4097 1586 1 1618 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1586 1 1618 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1586 1 1618 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1586 1 1618 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1586 1 1618 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1586 1 1618 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1586 1 1618 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1842 4097 1586 1 1618 #browseIt 8 'Bro&wse It' 1 1 1666 nil true 1712 8 'ClassBrowserShell.ico' 1760 nil nil 1586 1 1618 #displayIt 8 '&Display It' 1 1 1666 nil true 1712 8 'DisplayIt.ico' 1760 nil nil 1586 1 1618 #printIt 8 '&Print It' 1 1 1666 nil true 1712 8 'PrintIt.ico' 1760 nil nil 1586 1 1618 #evaluateIt 8 'E&valuate It' 1 1 1666 nil true 1712 8 'EvaluateIt.ico' 1760 nil nil 1586 1 1618 #inspectIt 8 '&Inspect It' 1 1 1666 nil true 1712 8 'InspectIt.ico' 1760 nil nil 1586 1 1618 #debugIt 8 'Deb&ug It' 1 1 1666 nil true 1712 8 'Debugger.ico' 1760 nil nil 1842 4097 1538 nil true 34 2 1586 2097153 1618 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1586 1 1618 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3296 nil 8 1637229025 1049094 ##(UI.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 5474 77 482 #gray 482 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 1088 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 3296 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 1088 nil 170 176 1088 9215 nil nil 170 176 34 2 81 482 #windowText nil nil 2162950 ##(UI.Scintilla.NullScintillaLibrary) nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' 8 '' 3 170 192 34 2 #container 5440 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 4 ##(UI.Scintilla.IndicatorStyle) 17 3296 482 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 5938 19 3296 482 #blue 3 3 #Warning nil nil nil nil nil nil #Error 5938 21 3296 482 #red 3 3 #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 5474 1029 nil 482 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5474 1027 482 #darkGoldenrod 482 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 5474 1031 482 #firebrick 482 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 866 34 9 914 #createAt:extent: 34 2 818 9 9 818 761 667 3296 914 #contextMenu: 34 1 3456 3296 914 #wordWrap: 8 #(true) 3296 914 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 3296 1 3 nil nil 5 nil 6418 3 3296 1 nil nil 67108863 5 nil 6418 5 3296 1 nil nil nil 5 nil 3296 914 #tabWidth: 8 #(4) 3296 914 #maxCompletionListHeight: 8 #(9) 3296 914 #sciSetTechnology: 8 #(1) 3296 914 #sciSetFontQuality: 8 #(3) 3296 914 #sciSetSelectionLayer: 8 #(1) 3296 994 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1056 nil 35 1392 nil nil nil 170 192 34 4 3296 8 'workspace' 1392 8 'aspects' nil 410 ##(UI.TabViewXP) 34 28 nil 1248 34 2 8 1140916738 1 6752 1458 138 144 8 #(##(Tools.PropertyInspector) ##(Tools.ValueWorkspace)) nil 1520 nil nil 3 nil nil nil 6752 nil 8 1793563504 2722 0 nil 2754 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 6880 7 257 nil 2722 0 nil 2930 2 3 ##(UI.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 6944 7 257 nil 2336 nil nil nil nil nil #smallIcons nil nil nil nil nil 866 34 3 914 #createAt:extent: 34 2 818 1 1 818 777 727 6752 914 #setSingleSelection: 8 #(1) 6752 914 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6752 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1056 nil 27 866 34 1 914 #createAt:extent: 34 2 818 1 1 818 777 727 1248 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 1392 3296 6752 1056 nil 27 1056 nil 27 852486 ##(Core.Fraction) 1553 1227 410 ##(UI.ListView) 34 45 nil 416 34 2 8 1409372236 1 7376 1458 138 144 1088 nil 1520 nil nil 7 nil nil nil 7376 nil 8 1793750192 2274 #displayString 8 #() ##(UI.IconicListAbstract) 2336 nil nil nil 818 129 129 nil nil 138 144 34 1 2386 8 'Column 1' 201 #left 2274 #displayString 7504 2274 #<= 8 #() nil nil 7376 nil 1 nil nil #thumbnails 2832 818 193 193 131169 818 65 65 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 866 34 2 914 #createAt:extent: 34 2 818 21 21 818 451 727 7376 914 #text: 34 1 8 'Column 1' 7376 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 1056 nil 35 7346 901 1227 false 170 192 34 4 576 8 'inspector' 7376 8 'contents' 1180166 ##(Graphics.Rectangle) 818 21 21 818 21 21 866 34 2 914 #createAt:extent: 34 2 818 12287 21 818 1281 771 416 914 #text: 34 1 8 'Inspector' 416 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 127 26 0 0 139 1 0 0] 34 3 7376 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8208 nil 496 nil 519 nil nil nil 786 8208 nil 1 #left nil nil nil 832 848 nil 832 nil 866 34 1 914 #createAt:extent: 34 2 818 471 21 818 11 727 8208 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1056 nil 27 576 1056 nil 27 )!

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

