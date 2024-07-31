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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 160 nil nil nil 5 nil nil nil 160 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 550 #{Core.IdentityDictionary} 0 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 193 192 8 '' 160 3 50 3 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 130 1 1 18 #{UI.StaticText} 50 16 nil 528 50 2 8 1140850945 1 608 nil 6 #{Graphics.Color} #silver nil 5 nil nil nil 608 nil nil 518 #{UI.NullConverter} nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 193 640 nil 608 370 #text: 50 1 8 'System Options' 608 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 528 50 2 8 1409372236 1 944 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 5 nil nil nil 944 nil nil 518 #{Core.Message} #displayString 8 #() 1106 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil 914 129 129 nil nil 1042 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 1106 #displayString 1136 1106 #<= 8 #() nil nil 944 nil 1 nil nil #thumbnails 8 #() 914 193 193 131169 914 65 65 1 nil nil nil nil 1 262 #{UI.ListViewVirtualUpdateMode} 944 nil nil nil nil nil nil nil nil nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 193 976 8 'Column 1' 944 3 8 #() 914 193 193 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} 288 50 2 944 8 'contents' nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 193 560 8 '' 528 3 50 2 608 944 914 193 193 nil 27 18 #{UI.Splitter} 50 12 nil 160 50 2 8 1140850688 1 1808 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 1808 nil 1 #left nil nil nil 914 1 1 914 9 9 nil 1904 nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 193 1840 8 '' 1808 3 8 #() 914 193 193 nil 27 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 2096 nil nil nil 5 nil nil nil 2096 130 1 1 18 #{UI.StaticText} 50 16 nil 2096 50 2 8 1140850945 1 2176 nil 688 nil 5 nil nil nil 2176 nil nil 706 nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 193 2208 nil 2176 370 #text: 50 1 8 'Properties' 2176 3 8 #() 914 193 193 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 2096 50 2 8 1409286144 131073 2448 nil nil nil 5 nil nil nil 2448 226 294 #{Core.Dictionary} 0 true 290 0 nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 193 2480 8 '' 2448 3 50 1 18 #{UI.CardContainer} 50 16 nil 2448 50 2 8 1409286144 131073 2720 nil nil nil 5 nil nil nil 2720 1350 1 #{UI.CardLayout} 1042 2 518 #{Core.Association} #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 2720 50 2 8 1140953421 1 2864 1010 1042 0 nil 1088 674 #default nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 3026 1 3058 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3026 1 3058 #browseIt 8 '&Browse It' 1 1 3106 nil true 3138 8 'ClassBrowserShell.ico' 3200 65541 nil nil nil 3282 4097 3026 1 3058 #copyAspect 8 '&Copy' 1 1 nil nil nil 3026 1 3058 #pasteAspect 8 '&Paste <d>' 1 1 nil nil nil 3282 4097 3026 1 3058 #editAspect 8 '&Edit' 1 1 nil nil nil 3026 1 3058 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 3282 4097 3026 1 3058 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2864 nil nil 1106 #valueText 8 #() nil 1200 nil nil nil nil nil nil 1042 3 1250 8 'Property' 323 #left 1106 #valueNameOnly 8 #() 1106 #<= 8 #() nil nil 2864 1106 #typeImage 8 #() 3 1106 #valueNameInfo 8 #() nil 1250 8 'Value' 323 #left 1106 #valueTextOnly 8 #() 1106 #<= 3840 nil nil 2864 1106 #valueImage 8 #() 3 nil nil 1250 8 '' 41 #center nil 1106 #<= 8 #() nil nil 2864 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 4096 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 4112 7 257 nil 1 nil nil #report 1344 nil 131431 914 129 129 1 nil nil nil nil 1 1394 2864 nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 1088 1042 0 nil nil 4098 0 nil 1318 #{Kernel.CompiledMethod} 2 3 4272 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4288 4098 0 nil 4338 1 83886083 4272 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4384 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 1 1 nil nil nil nil nil nil nil 322 50 2 370 #createWindow: 50 1 418 450 8 #[4 0 0 0 4 0 0 0 90 1 0 0 107 1 0 0] 193 2896 8 'Property' 2864 370 #contextMenu: 50 1 2992 2864 3 8 #() 914 193 193 nil 2029 2834 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 2720 50 2 8 1411453252 1 4704 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 98 #smalltalkWorkspace nil 21 2978 nil true 50 13 3026 1 3058 #accept 8 '&Accept' 1 1 nil nil nil 3282 4097 2978 nil true 50 10 3026 1 3058 #undo 8 '&Undo' 1 1 3106 nil true 3138 8 'EditUndo.ico' 3200 65541 nil nil nil 3282 4097 3026 1 3058 #cutSelection 8 'Cu&t' 1 1 3106 nil true 3138 8 'EditCut.ico' 3200 65541 nil nil nil 3026 1 3058 #copySelection 8 '&Copy' 1 1 3106 nil true 3138 8 'EditCopy.ico' 3200 65541 nil nil nil 3026 1 3058 #pasteClipboard 8 '&Paste' 1 1 3106 nil true 3138 8 'EditPaste.ico' 3200 65541 nil nil nil 3026 1 3058 #clearSelection 8 'De&lete' 1 1 3106 nil true 3138 8 'EditClear.ico' 3200 65541 nil nil nil 3282 4097 3026 1 3058 #reformatSource 8 'Re&format' 1 1 nil nil nil 3282 4097 3026 1 3058 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2978 nil true 50 10 3026 1 3058 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 3026 1 3058 #cloneNew 8 '&Clone' 1 1 3106 nil true 3138 8 'SmalltalkWorkspace.ico' 3200 65541 nil nil nil 3282 4097 3026 1 3058 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3026 1 3058 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3026 1 3058 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3026 1 3058 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3026 1 3058 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3026 1 3058 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3026 1 3058 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 3282 4097 3026 1 3058 #browseIt 8 'Bro&wse It' 1 1 3106 nil true 3138 8 'ClassBrowserShell.ico' 3200 65541 nil nil nil 3026 1 3058 #displayIt 8 '&Display It' 1 1 3106 nil true 3138 8 'DisplayIt.ico' 3200 65541 nil nil nil 3026 1 3058 #printIt 8 '&Print It' 1 1 3106 nil true 3138 8 'PrintIt.ico' 3200 65541 nil nil nil 3026 1 3058 #evaluateIt 8 'E&valuate It' 1 1 3106 nil true 3138 8 'EvaluateIt.ico' 3200 65541 nil nil nil 3026 1 3058 #inspectIt 8 '&Inspect It' 1 1 3106 nil true 3138 8 'InspectIt.ico' 3200 65541 nil nil nil 3026 1 3058 #debugIt 8 'Deb&ug It' 1 1 3106 nil true 3138 8 'Debugger.ico' 3200 65541 nil nil nil 3282 4097 2978 nil true 50 2 3026 2097153 3058 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 3026 1 3058 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 4704 nil nil 706 nil nil 9 #focusLost nil nil nil nil 290 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 674 #gray 674 #white 1 nil nil nil nil #callTip nil nil nil #normal 7010 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 1042 0 290 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 4704 #circle nil nil nil nil nil nil 4466 0 nil 258 0 9215 nil nil 258 1 81 674 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 290 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 290 1 #container 6992 nil nil nil nil #{Core.Utf8String} nil 290 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 4704 674 #red 3 3 #Error nil nil nil nil nil nil #Notification 7378 17 4704 674 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 7378 19 4704 674 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 290 3 #Error 7010 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 7010 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7010 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 322 50 10 370 #createWindow: 50 1 418 450 8 #[4 0 0 0 4 0 0 0 90 1 0 0 107 1 0 0] 193 4736 nil 4704 370 #contextMenu: 50 1 4848 4704 370 #sciSetMouseDwellTime: 8 #(500) 4704 370 #wordWrap: 8 #(true) 4704 370 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 4704 nil 3 nil nil 5 nil 7890 3 4704 nil nil nil 67108863 5 nil 7890 5 4704 nil nil nil nil 5 nil 4704 370 #tabWidth: 8 #(4) 4704 370 #maxCompletionListHeight: 8 #(9) 4704 370 #sciSetTechnology: 8 #(1) 4704 370 #sciSetFontQuality: 8 #(3) 4704 370 #sciSetSelectionLayer: 8 #(1) 4704 1 8 #() 914 193 193 nil 45 2864 nil nil nil 1586 288 50 4 2864 8 'aspects' 4704 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 2720 50 2 8 1140916738 1 8208 1010 1042 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 1088 nil nil 1 nil nil nil 8208 nil nil 4098 0 nil 4130 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 8304 7 257 nil 1152 1200 nil nil nil nil nil #smallIcons nil nil nil nil nil 322 50 3 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 193 8240 8 '' 8208 370 #setSingleSelection: 8 #(1) 8208 370 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8208 3 8 #() 914 193 193 nil 27 322 50 1 370 #createWindow: 50 1 418 450 8 #[0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 193 2752 8 '' 2720 3 50 3 2864 4704 8208 914 193 193 nil 27 914 193 193 nil 27 1586 288 50 2 2448 8 'inspector' nil 322 50 1 370 #createWindow: 50 1 418 450 8 #[98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 193 2128 8 '' 2096 3 50 2 2176 2448 914 193 193 nil 27 914 193 193 nil 27 1586 288 50 2 160 8 'preferences' 518 #{Graphics.Rectangle} 914 21 21 914 21 21 nil nil nil nil 1 nil nil nil nil 1 nil 193 322 50 1 370 #createWindow: 50 1 418 9042 914 7679 21 914 9159 951 193 80 8 'User Preferences' 32 1 50 1 160 914 193 193 nil 27)!

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

