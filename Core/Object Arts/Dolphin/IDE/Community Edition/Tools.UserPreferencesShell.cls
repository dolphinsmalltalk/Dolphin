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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 7 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 160 nil nil nil 7 nil nil nil 160 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 550 #{Core.IdentityDictionary} 0 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 21 21 418 1409 813 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 50 3 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 130 1 1 18 #{UI.StaticText} 50 16 nil 528 50 2 8 1140850945 1 608 nil 6 #{Graphics.Color} #silver nil 7 nil nil nil 608 nil 8 1853387904 518 #{UI.NullConverter} nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 1 418 699 39 608 370 #text: 50 1 8 'System Options' 608 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 418 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 528 50 2 8 1409372236 1 960 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 7 nil nil nil 960 nil 8 1853243664 518 #{Core.Message} #displayString 8 #() 1138 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil 418 129 129 nil nil 1058 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 1138 #displayString 1168 1138 #<= 8 #() nil nil 960 nil 1 nil nil #thumbnails 8 #() 418 193 193 131169 418 65 65 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 39 418 699 775 960 370 #text: 50 1 8 'Column 1' 960 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 944 nil 35 290 1 960 8 'contents' nil 322 50 1 370 #createAt:extent: 50 2 418 1 1 418 699 813 528 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 50 2 608 960 944 nil 27 18 #{UI.Splitter} 50 12 nil 160 50 2 8 1140850688 1 1792 nil nil nil 519 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 1792 nil 1 #left nil nil nil 418 1 1 418 9 9 nil 1888 nil 322 50 1 370 #createAt:extent: 50 2 418 699 1 418 11 813 1792 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 944 nil 27 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 2064 nil nil nil 7 nil nil nil 2064 130 1 1 18 #{UI.StaticText} 50 16 nil 2064 50 2 8 1140850945 1 2144 nil 688 nil 7 nil nil nil 2144 nil 8 1853387904 722 nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 1 418 701 39 2144 370 #text: 50 1 8 'Properties' 2144 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 944 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 2064 50 2 8 1409286144 131073 2432 nil nil nil 7 nil nil nil 2432 226 294 #{Core.Dictionary} 0 true 290 0 nil 322 50 1 370 #createAt:extent: 50 2 418 1 39 418 701 775 2432 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 50 1 18 #{UI.CardContainer} 50 16 nil 2432 50 2 8 1409286144 131073 2704 nil nil nil 7 nil nil nil 2704 1350 1 #{UI.CardLayout} 1058 2 518 #{Core.Association} #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 2704 50 2 8 1140953421 1 2848 1026 1058 0 nil 1104 674 #default nil 15 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 3010 1 3042 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3010 1 3042 #browseIt 8 '&Browse It' 1 1 3090 nil true 3122 8 'ClassBrowserShell.ico' 3184 65541 nil nil nil 3266 4097 3010 1 3042 #copyAspect 8 '&Copy' 1 1 nil nil nil 3010 1 3042 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 3266 4097 3010 1 3042 #editAspect 8 '&Edit' 1 1 nil nil nil 3010 1 3042 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 3266 4097 3010 1 3042 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2848 nil 8 1853243664 1138 #valueText 8 #() nil 1232 nil nil nil nil nil nil 1058 3 1282 8 'Property' 319 #left 1138 #valueNameOnly 8 #() 1138 #<= 8 #() nil nil 2848 1138 #typeImage 8 #() 3 1138 #valueNameInfo 8 #() nil 1282 8 'Value' 319 #left 1138 #valueTextOnly 8 #() 1138 #<= 3840 nil nil 2848 1138 #valueImage 8 #() 3 nil nil 1282 8 '' 41 #center nil 1138 #<= 8 #() nil nil 2848 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 4096 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 4112 7 257 nil 1 nil nil #report 1376 nil 131431 418 129 129 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 1104 1058 0 nil nil 4098 0 nil 1318 #{Kernel.CompiledMethod} 2 3 4256 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4272 4098 0 nil 4322 1 83886083 4256 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4368 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 1 1 nil nil nil nil nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 9 9 418 685 715 2848 370 #text: 50 1 8 'Property' 2848 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 944 nil 2029 2818 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 2704 50 2 8 1411453252 1 4688 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 98 #smalltalkWorkspace nil 21 2962 nil true 50 13 3010 1 3042 #accept 8 '&Accept' 1 1 nil nil nil 3266 4097 2962 nil true 50 10 3010 1 3042 #undo 8 '&Undo' 1 1 3090 nil true 3122 8 'EditUndo.ico' 3184 65541 nil nil nil 3266 4097 3010 1 3042 #cutSelection 8 'Cu&t' 1 1 3090 nil true 3122 8 'EditCut.ico' 3184 65541 nil nil nil 3010 1 3042 #copySelection 8 '&Copy' 1 1 3090 nil true 3122 8 'EditCopy.ico' 3184 65541 nil nil nil 3010 1 3042 #pasteClipboard 8 '&Paste' 1 1 3090 nil true 3122 8 'EditPaste.ico' 3184 65541 nil nil nil 3010 1 3042 #clearSelection 8 'De&lete' 1 1 3090 nil true 3122 8 'EditClear.ico' 3184 65541 nil nil nil 3266 4097 3010 1 3042 #reformatSource 8 'Re&format' 1 1 nil nil nil 3266 4097 3010 1 3042 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2962 nil true 50 10 3010 1 3042 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 3010 1 3042 #cloneNew 8 '&Clone' 1 1 3090 nil true 3122 8 'SmalltalkWorkspace.ico' 3184 65541 nil nil nil 3266 4097 3010 1 3042 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3010 1 3042 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3010 1 3042 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3010 1 3042 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3010 1 3042 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3010 1 3042 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3010 1 3042 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 3266 4097 3010 1 3042 #browseIt 8 'Bro&wse It' 1 1 3090 nil true 3122 8 'ClassBrowserShell.ico' 3184 65541 nil nil nil 3010 1 3042 #displayIt 8 '&Display It' 1 1 3090 nil true 3122 8 'DisplayIt.ico' 3184 65541 nil nil nil 3010 1 3042 #printIt 8 '&Print It' 1 1 3090 nil true 3122 8 'PrintIt.ico' 3184 65541 nil nil nil 3010 1 3042 #evaluateIt 8 'E&valuate It' 1 1 3090 nil true 3122 8 'EvaluateIt.ico' 3184 65541 nil nil nil 3010 1 3042 #inspectIt 8 '&Inspect It' 1 1 3090 nil true 3122 8 'InspectIt.ico' 3184 65541 nil nil nil 3010 1 3042 #debugIt 8 'Deb&ug It' 1 1 3090 nil true 3122 8 'Debugger.ico' 3184 65541 nil nil nil 3266 4097 2962 nil true 50 2 3010 2097153 3042 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 3010 1 3042 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 4688 nil 8 1367644576 722 nil nil 9 #focusLost nil nil nil nil 290 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 674 #gray 674 #white 1 nil nil nil nil #callTip nil nil nil #normal 7010 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 1058 0 290 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 4688 #circle nil nil nil nil nil nil 4450 0 nil 258 0 9215 nil nil 258 1 81 674 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 290 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 290 1 #container 6992 nil nil nil nil #{Core.AnsiString} nil 290 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 4688 674 #red 3 3 #Error nil nil nil nil nil nil #Notification 7378 17 4688 674 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 7378 19 4688 674 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 290 3 #Error 7010 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 7010 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7010 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 322 50 9 370 #createAt:extent: 50 2 418 9 9 418 685 715 4688 370 #sciSetMouseDwellTime: 8 #(500) 4688 370 #wordWrap: 8 #(true) 4688 370 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 4688 nil 3 nil nil 5 nil 7842 3 4688 nil nil nil 67108863 5 nil 7842 5 4688 nil nil nil nil 5 nil 4688 370 #tabWidth: 8 #(4) 4688 370 #maxCompletionListHeight: 8 #(9) 4688 370 #sciSetTechnology: 8 #(1) 4688 370 #sciSetFontQuality: 8 #(3) 4688 370 #sciSetSelectionLayer: 8 #(1) 4688 466 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 944 nil 45 2848 nil nil nil 290 2 2848 8 'aspects' 4688 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 2704 50 2 8 1140916738 1 8160 1026 1058 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 1104 nil nil 1 nil nil nil 8160 nil 8 1852839600 4098 0 nil 4130 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 8272 7 257 nil 1184 1232 nil nil nil nil nil #smallIcons nil nil nil nil nil 322 50 3 370 #createAt:extent: 50 2 418 1 1 418 701 775 8160 370 #setSingleSelection: 8 #(1) 8160 370 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8160 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 944 nil 27 322 50 1 370 #createAt:extent: 50 2 418 1 1 418 701 775 2704 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 50 3 2848 4688 8160 944 nil 27 944 nil 27 290 1 2432 8 'inspector' nil 322 50 1 370 #createAt:extent: 50 2 418 709 1 418 701 813 2064 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 50 2 2144 2432 944 nil 27 944 nil 27 290 1 160 8 'preferences' 518 #{Graphics.Rectangle} 418 21 21 418 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 322 50 2 370 #createAt:extent: 50 2 418 6143 21 418 1481 931 32 370 #text: 50 1 8 'User Preferences' 32 466 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 14 0 0 219 1 0 0] 50 1 160 944 nil 27)!

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

