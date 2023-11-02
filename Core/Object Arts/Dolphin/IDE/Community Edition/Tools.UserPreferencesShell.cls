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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13369344 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 5 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 160 nil nil nil 5 nil nil nil 160 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 false 550 #{Core.IdentityDictionary} 0 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 21 21 418 1409 813 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 50 3 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 130 1 1 18 #{UI.StaticText} 50 16 nil 528 50 2 8 1140850945 1 608 nil 6 #{Graphics.Color} #silver nil 5 nil nil nil 608 nil nil 518 #{UI.NullConverter} nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 1 418 699 39 608 370 #text: 50 1 8 'System Options' 608 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 418 193 193 nil 27 nil nil nil 18 #{UI.ListView} 50 45 nil 528 50 2 8 1409372236 1 944 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 5 nil nil nil 944 nil nil 518 #{Core.Message} #displayString 8 #() 1106 #iconImageIndex 8 #() 1350 1 #{Graphics.IconImageManager} nil nil nil 418 129 129 nil nil 1042 1 3142 5 #{UI.ListViewColumn} 8 'Column 1' 201 #left 1106 #displayString 1136 1106 #<= 8 #() nil nil 944 nil 1 nil nil #thumbnails 8 #() 418 193 193 131169 418 65 65 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 39 418 699 775 944 370 #text: 50 1 8 'Column 1' 944 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 928 nil 35 518 #{Kernel.STBIdentityDictionaryProxy} 288 50 2 944 8 'contents' nil 322 50 1 370 #createAt:extent: 50 2 418 1 1 418 699 813 528 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 50 2 608 944 928 nil 27 18 #{UI.Splitter} 50 12 nil 160 50 2 8 1140850688 1 1792 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 1792 nil 1 #left nil nil nil 418 1 1 418 9 9 nil 1888 nil 322 50 1 370 #createAt:extent: 50 2 418 699 1 418 11 813 1792 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 928 nil 27 18 #{UI.ContainerView} 50 15 nil 160 50 2 8 1140850688 131073 2064 nil nil nil 5 nil nil nil 2064 130 1 1 18 #{UI.StaticText} 50 16 nil 2064 50 2 8 1140850945 1 2144 nil 688 nil 5 nil nil nil 2144 nil nil 706 nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 1 1 418 701 39 2144 370 #text: 50 1 8 'Properties' 2144 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 928 nil 27 nil nil nil 18 #{UI.ContainerView} 50 15 nil 2064 50 2 8 1409286144 131073 2416 nil nil nil 5 nil nil nil 2416 226 294 #{Core.Dictionary} 0 true 290 0 nil 322 50 1 370 #createAt:extent: 50 2 418 1 39 418 701 775 2416 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 50 1 18 #{UI.CardContainer} 50 16 nil 2416 50 2 8 1409286144 131073 2688 nil nil nil 5 nil nil nil 2688 1350 1 #{UI.CardLayout} 1042 2 518 #{Core.Association} #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 2688 50 2 8 1140953421 1 2832 1010 1042 0 nil 1088 674 #default nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 2994 1 3026 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 2994 1 3026 #browseIt 8 '&Browse It' 1 1 3074 nil true 3106 8 'ClassBrowserShell.ico' 3168 65541 nil nil nil 3250 4097 2994 1 3026 #copyAspect 8 '&Copy' 1 1 nil nil nil 2994 1 3026 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 3250 4097 2994 1 3026 #editAspect 8 '&Edit' 1 1 nil nil nil 2994 1 3026 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 3250 4097 2994 1 3026 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 2832 nil nil 1106 #valueText 8 #() nil 1200 nil nil nil nil nil nil 1042 3 1250 8 'Property' 319 #left 1106 #valueNameOnly 8 #() 1106 #<= 8 #() nil nil 2832 1106 #typeImage 8 #() 3 1106 #valueNameInfo 8 #() nil 1250 8 'Value' 319 #left 1106 #valueTextOnly 8 #() 1106 #<= 3808 nil nil 2832 1106 #valueImage 8 #() 3 nil nil 1250 8 '' 41 #center nil 1106 #<= 8 #() nil nil 2832 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 4064 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 4080 7 257 nil 1 nil nil #report 1344 nil 131431 418 129 129 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 1088 1042 0 nil nil 4066 0 nil 1318 #{Kernel.CompiledMethod} 2 3 4224 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4240 4066 0 nil 4290 1 83886083 4224 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4336 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 1 1 nil nil nil nil nil nil nil 322 50 2 370 #createAt:extent: 50 2 418 9 9 418 685 715 2832 370 #text: 50 1 8 'Property' 2832 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 928 nil 2029 2802 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 2688 50 2 8 1411453252 1 4656 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 98 #smalltalkWorkspace nil 21 2946 nil true 50 13 2994 1 3026 #accept 8 '&Accept' 1 1 nil nil nil 3250 4097 2946 nil true 50 10 2994 1 3026 #undo 8 '&Undo' 1 1 3074 nil true 3106 8 'EditUndo.ico' 3168 65541 nil nil nil 3250 4097 2994 1 3026 #cutSelection 8 'Cu&t' 1 1 3074 nil true 3106 8 'EditCut.ico' 3168 65541 nil nil nil 2994 1 3026 #copySelection 8 '&Copy' 1 1 3074 nil true 3106 8 'EditCopy.ico' 3168 65541 nil nil nil 2994 1 3026 #pasteClipboard 8 '&Paste' 1 1 3074 nil true 3106 8 'EditPaste.ico' 3168 65541 nil nil nil 2994 1 3026 #clearSelection 8 'De&lete' 1 1 3074 nil true 3106 8 'EditClear.ico' 3168 65541 nil nil nil 3250 4097 2994 1 3026 #reformatSource 8 'Re&format' 1 1 nil nil nil 3250 4097 2994 1 3026 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2946 nil true 50 10 2994 1 3026 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 2994 1 3026 #cloneNew 8 '&Clone' 1 1 3074 nil true 3106 8 'SmalltalkWorkspace.ico' 3168 65541 nil nil nil 3250 4097 2994 1 3026 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2994 1 3026 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2994 1 3026 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2994 1 3026 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 2994 1 3026 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2994 1 3026 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2994 1 3026 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 3250 4097 2994 1 3026 #browseIt 8 'Bro&wse It' 1 1 3074 nil true 3106 8 'ClassBrowserShell.ico' 3168 65541 nil nil nil 2994 1 3026 #displayIt 8 '&Display It' 1 1 3074 nil true 3106 8 'DisplayIt.ico' 3168 65541 nil nil nil 2994 1 3026 #printIt 8 '&Print It' 1 1 3074 nil true 3106 8 'PrintIt.ico' 3168 65541 nil nil nil 2994 1 3026 #evaluateIt 8 'E&valuate It' 1 1 3074 nil true 3106 8 'EvaluateIt.ico' 3168 65541 nil nil nil 2994 1 3026 #inspectIt 8 '&Inspect It' 1 1 3074 nil true 3106 8 'InspectIt.ico' 3168 65541 nil nil nil 2994 1 3026 #debugIt 8 'Deb&ug It' 1 1 3074 nil true 3106 8 'Debugger.ico' 3168 65541 nil nil nil 3250 4097 2946 nil true 50 2 2994 2097153 3026 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 2994 1 3026 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 4656 nil nil 706 nil nil 9 #focusLost nil nil nil nil 290 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 674 #gray 674 #white 1 nil nil nil nil #callTip nil nil nil #normal 6962 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 1042 0 290 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 4656 #circle nil nil nil nil nil nil 4418 0 nil 258 0 9215 nil nil 258 1 81 674 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 290 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 290 1 #container 6944 nil nil nil nil #{Core.AnsiString} nil 290 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 4656 674 #red 3 3 #Error nil nil nil nil nil nil #Notification 7330 17 4656 674 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 7330 19 4656 674 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 290 3 #Error 6962 1031 674 #firebrick 674 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 6962 1029 nil 674 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 6962 1027 674 #darkGoldenrod 674 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 322 50 9 370 #createAt:extent: 50 2 418 9 9 418 685 715 4656 370 #sciSetMouseDwellTime: 8 #(500) 4656 370 #wordWrap: 8 #(true) 4656 370 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 4656 nil 3 nil nil 5 nil 7794 3 4656 nil nil nil 67108863 5 nil 7794 5 4656 nil nil nil nil 5 nil 4656 370 #tabWidth: 8 #(4) 4656 370 #maxCompletionListHeight: 8 #(9) 4656 370 #sciSetTechnology: 8 #(1) 4656 370 #sciSetFontQuality: 8 #(3) 4656 370 #sciSetSelectionLayer: 8 #(1) 4656 466 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 928 nil 45 2832 nil nil nil 1586 288 50 4 2832 8 'aspects' 4656 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 2688 50 2 8 1140916738 1 8128 1010 1042 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 1088 nil nil 1 nil nil nil 8128 nil nil 4066 0 nil 4098 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 8224 7 257 nil 1152 1200 nil nil nil nil nil #smallIcons nil nil nil nil nil 322 50 3 370 #createAt:extent: 50 2 418 1 1 418 701 775 8128 370 #setSingleSelection: 8 #(1) 8128 370 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8128 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 928 nil 27 322 50 1 370 #createAt:extent: 50 2 418 1 1 418 701 775 2688 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 50 3 2832 4656 8128 928 nil 27 928 nil 27 1586 288 50 2 2416 8 'inspector' nil 322 50 1 370 #createAt:extent: 50 2 418 709 1 418 701 813 2064 466 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 50 2 2144 2416 928 nil 27 928 nil 27 1586 288 50 2 160 8 'preferences' 518 #{Graphics.Rectangle} 418 21 21 418 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 322 50 2 370 #createAt:extent: 50 2 418 6143 21 418 1481 931 32 370 #text: 50 1 8 'User Preferences' 32 466 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 14 0 0 219 1 0 0] 50 1 160 928 nil 27)!

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

