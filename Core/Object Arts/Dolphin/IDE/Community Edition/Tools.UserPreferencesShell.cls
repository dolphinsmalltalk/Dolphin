"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.UserPreferencesShell'
	instanceVariableNames: 'preferencesPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.UserPreferencesShell guid: (Core.GUID fromString: '{952571b1-f954-4626-bf12-bdd570b30a14}')!
Tools.UserPreferencesShell comment: ''!
!Tools.UserPreferencesShell categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!Tools.UserPreferencesShell methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	preferencesPresenter := self add: TwinLevelInspector new name: 'preferences'!

model: aListModelOfObjects 
	super model: aListModelOfObjects.
	preferencesPresenter model: aListModelOfObjects!

selectionOrNil: aClass 
	^preferencesPresenter selectionOrNil: aClass! !
!Tools.UserPreferencesShell categoriesForMethods!
createComponents!private! !
model:!public! !
selectionOrNil:!public! !
!

!Tools.UserPreferencesShell class methodsFor!

defaultModel
	^ListModel on: SmalltalkSystem current systemOptions!

defaultOptionFlags
	^##(ReuseIfOpenMask | CanUseIdeaSpaceMask)!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'User Preferences'!

icon
	"Answers an Icon that can be used to represent this class"

	^Icon fromId: 'SMALLTALKOPTIONSFOLDER.ICO'!

initialize
	"Private - Register the receiver with SmalltalkSystem.

		self initialize.
	"

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	(aspects at: #reuseIfOpen) defaultValue: true.
	aspects add: self canUseIdeaSpaceAspect.
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13369344 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 39 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1376774 #{UI.ProportionalLayout} 170 176 8 #() false 170 192 640 nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 21 21 770 1409 813 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 34 3 410 #{UI.ContainerView} 34 15 nil 528 34 2 8 1140850688 131073 880 nil nil nil 7 nil nil nil 880 498 1 1 410 #{UI.StaticText} 34 16 nil 880 34 2 8 1140850945 1 960 nil 917510 #{Graphics.Color} #silver nil 7 nil nil nil 960 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 674 34 2 722 #createAt:extent: 34 2 770 1 1 770 699 39 960 722 #text: 34 1 8 'System Options' 960 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 770 193 193 nil 27 nil nil nil 410 #{UI.ListView} 34 45 nil 880 34 2 8 1409372236 1 1312 787270 2 #{UI.ListModel} 138 144 640 nil 1769478 #{Kernel.IdentitySearchPolicy} nil nil 7 nil nil nil 1312 nil 8 1815049392 786950 #{Core.Message} #displayString 8 #() 1474 #iconImageIndex 8 #() 1639750 1 #{Graphics.IconImageManager} nil nil nil 770 129 129 nil nil 138 144 34 1 1117254 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 1474 #displayString 1504 1474 #<= 8 #() nil nil 1312 nil 1 nil nil #thumbnails 8 #() 770 193 193 131169 770 65 65 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 674 34 2 722 #createAt:extent: 34 2 770 1 39 770 699 775 1312 722 #text: 34 1 8 'Column 1' 1312 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 1296 nil 35 170 192 34 2 1312 8 'contents' nil 674 34 1 722 #createAt:extent: 34 2 770 1 1 770 699 813 880 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 34 2 960 1312 1296 nil 27 410 #{UI.Splitter} 34 12 nil 528 34 2 8 1140850688 1 2160 nil nil nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 2160 nil 1 #left nil nil nil 770 1 1 770 9 9 nil 2256 nil 674 34 1 722 #createAt:extent: 34 2 770 699 1 770 11 813 2160 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 1296 nil 27 410 #{UI.ContainerView} 34 15 nil 528 34 2 8 1140850688 131073 2432 nil nil nil 7 nil nil nil 2432 498 1 1 410 #{UI.StaticText} 34 16 nil 2432 34 2 8 1140850945 1 2512 nil 1040 nil 7 nil nil nil 2512 nil 8 1815137184 1074 nil nil nil 674 34 2 722 #createAt:extent: 34 2 770 1 1 770 701 39 2512 722 #text: 34 1 8 'Properties' 2512 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 1296 nil 27 nil nil nil 410 #{UI.ContainerView} 34 15 nil 2432 34 2 8 1409286144 131073 2800 nil nil nil 7 nil nil nil 2800 594 138 #{Core.Dictionary} 640 true 170 192 640 nil 674 34 1 722 #createAt:extent: 34 2 770 1 39 770 701 775 2800 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 34 1 410 #{UI.CardContainer} 34 16 nil 2800 34 2 8 1409286144 131073 3056 nil nil nil 7 nil nil nil 3056 853318 1 #{UI.CardLayout} 138 144 34 2 1049094 #{Core.Association} #{Tools.PropertyInspector} 410 #{UI.ListTreeView} 34 59 nil 3056 34 2 8 1140953421 1 3216 1378 138 144 640 nil 1440 1026 #default nil 15 461638 4 #{UI.Menu} nil true 34 12 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 3378 1 3410 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 3378 1 3410 #browseIt 8 '&Browse It' 1 1 3458 nil true 3490 8 'ClassBrowserShell.ico' 3552 65541 nil nil nil 3634 4097 3378 1 3410 #copyAspect 8 '&Copy' 1 1 nil nil nil 3378 1 3410 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 3634 4097 3378 1 3410 #editAspect 8 '&Edit' 1 1 nil nil nil 3378 1 3410 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 3634 4097 3378 1 3410 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3216 nil 8 1815049392 1474 #valueText 8 #() nil 1568 nil nil nil nil nil nil 138 144 34 3 1634 8 'Property' 319 #left 1474 #valueNameOnly 8 #() 1474 #<= 8 #() nil nil 3216 1474 #typeImage 8 #() 3 1474 #valueNameInfo 8 #() nil 1634 8 'Value' 319 #left 1474 #valueTextOnly 8 #() 1474 #<= 4224 nil nil 3216 1474 #valueImage 8 #() 3 nil nil 1634 8 '' 41 #center nil 1474 #<= 8 #() nil nil 3216 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 3 1 4480 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1442886 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 4496 7 257 nil 1 nil nil #report 1728 nil 131431 770 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 #{UI.VirtualTreeModel} nil 1440 138 144 640 nil nil 4482 0 nil 1377574 #{Kernel.CompiledMethod} 2 3 4640 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4656 4482 0 nil 4706 1 83886083 4640 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4752 7 257 nil nil 138 #{Core.PluggableSet} 640 138 #{Core.IdentitySet} 640 1 1 nil nil nil nil nil nil nil 674 34 3 722 #createAt:extent: 34 2 770 9 9 770 685 715 3216 722 #contextMenu: 34 1 3344 3216 722 #text: 34 1 8 'Property' 3216 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1296 nil 2029 3186 #{Tools.ValueWorkspace} 410 #{UI.Scintilla.ScintillaView} 34 52 nil 3056 34 2 8 1411453252 1 5072 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 466 #smalltalkWorkspace nil 21 3330 nil true 34 13 3378 1 3410 #accept 8 '&Accept' 1 1 nil nil nil 3634 4097 3330 nil true 34 10 3378 1 3410 #undo 8 '&Undo' 1 1 3458 nil true 3490 8 'EditUndo.ico' 3552 65541 nil nil nil 3634 4097 3378 1 3410 #cutSelection 8 'Cu&t' 1 1 3458 nil true 3490 8 'EditCut.ico' 3552 65541 nil nil nil 3378 1 3410 #copySelection 8 '&Copy' 1 1 3458 nil true 3490 8 'EditCopy.ico' 3552 65541 nil nil nil 3378 1 3410 #pasteClipboard 8 '&Paste' 1 1 3458 nil true 3490 8 'EditPaste.ico' 3552 65541 nil nil nil 3378 1 3410 #clearSelection 8 'De&lete' 1 1 3458 nil true 3490 8 'EditClear.ico' 3552 65541 nil nil nil 3634 4097 3378 1 3410 #reformatSource 8 'Re&format' 1 1 nil nil nil 3634 4097 3378 1 3410 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3330 nil true 34 10 3378 1 3410 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 3378 1 3410 #cloneNew 8 '&Clone' 1 1 3458 nil true 3490 8 'SmalltalkWorkspace.ico' 3552 65541 nil nil nil 3634 4097 3378 1 3410 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3378 1 3410 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3378 1 3410 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3378 1 3410 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3378 1 3410 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3378 1 3410 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3378 1 3410 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 3634 4097 3378 1 3410 #browseIt 8 'Bro&wse It' 1 1 3458 nil true 3490 8 'ClassBrowserShell.ico' 3552 65541 nil nil nil 3378 1 3410 #displayIt 8 '&Display It' 1 1 3458 nil true 3490 8 'DisplayIt.ico' 3552 65541 nil nil nil 3378 1 3410 #printIt 8 '&Print It' 1 1 3458 nil true 3490 8 'PrintIt.ico' 3552 65541 nil nil nil 3378 1 3410 #evaluateIt 8 'E&valuate It' 1 1 3458 nil true 3490 8 'EvaluateIt.ico' 3552 65541 nil nil nil 3378 1 3410 #inspectIt 8 '&Inspect It' 1 1 3458 nil true 3490 8 'InspectIt.ico' 3552 65541 nil nil nil 3378 1 3410 #debugIt 8 'Deb&ug It' 1 1 3458 nil true 3490 8 'Debugger.ico' 3552 65541 nil nil nil 3634 4097 3330 nil true 34 2 3378 2097153 3410 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 3378 1 3410 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5072 nil 8 1395533126 1074 nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7410 77 1026 #gray 1026 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 138 144 640 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 5072 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 640 nil 170 176 640 9215 nil nil 170 176 34 2 81 1026 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 7376 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 4 #{UI.Scintilla.IndicatorStyle} 17 5072 1026 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 7874 19 5072 1026 #blue 3 3 #Warning nil nil nil nil nil nil #Error 7874 21 5072 1026 #red 3 3 #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 7410 1029 nil 1026 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7410 1027 1026 #darkGoldenrod 1026 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 7410 1031 1026 #firebrick 1026 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 674 34 10 722 #createAt:extent: 34 2 770 9 9 770 685 715 5072 722 #contextMenu: 34 1 5216 5072 722 #sciSetMouseDwellTime: 8 #(500) 5072 722 #wordWrap: 8 #(true) 5072 722 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 5072 1 3 nil nil 5 nil 8386 3 5072 1 nil nil 67108863 5 nil 8386 5 5072 1 nil nil nil 5 nil 5072 722 #tabWidth: 8 #(4) 5072 722 #maxCompletionListHeight: 8 #(9) 5072 722 #sciSetTechnology: 8 #(1) 5072 722 #sciSetFontQuality: 8 #(3) 5072 722 #sciSetSelectionLayer: 8 #(1) 5072 818 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1296 nil 35 3216 nil nil nil 170 192 34 4 5072 8 'workspace' 3216 8 'aspects' nil 410 #{UI.TabViewXP} 34 28 nil 3056 34 2 8 1140916738 1 8720 1378 138 144 8 #(#{Tools.PropertyInspector} #{Tools.ValueWorkspace}) nil 1440 nil nil 1 nil nil nil 8720 nil 8 1814862704 4482 0 nil 4514 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 8848 7 257 nil 1520 1568 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 34 3 722 #createAt:extent: 34 2 770 1 1 770 701 775 8720 722 #setSingleSelection: 8 #(1) 8720 722 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8720 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 1296 nil 27 674 34 1 722 #createAt:extent: 34 2 770 1 1 770 701 775 3056 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 34 3 3216 5072 8720 1296 nil 27 1296 nil 27 170 192 34 2 2800 8 'inspector' nil 674 34 1 722 #createAt:extent: 34 2 770 709 1 770 701 813 2432 818 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 34 2 2512 2800 1296 nil 27 1296 nil 27 170 192 34 2 528 8 'preferences' 1180166 #{Graphics.Rectangle} 770 21 21 770 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 674 34 2 722 #createAt:extent: 34 2 770 12287 21 770 1481 931 416 722 #text: 34 1 8 'User Preferences' 416 818 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 227 26 0 0 219 1 0 0] 34 1 528 1296 nil 27)!

toolsFolderHelpId
	^10580! !
!Tools.UserPreferencesShell class categoriesForMethods!
defaultModel!public! !
defaultOptionFlags!constants!options!private! !
displayOn:!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!private! !
!

