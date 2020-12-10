"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.UserPreferencesShell'
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
!Tools.UserPreferencesShell categoriesFor: #createComponents!private! !
!Tools.UserPreferencesShell categoriesFor: #model:!public! !
!Tools.UserPreferencesShell categoriesFor: #selectionOrNil:!public! !

!Tools.UserPreferencesShell class methodsFor!

defaultModel
	^ListModel on: SmalltalkSystem current systemOptions!

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

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true.
	!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13369344 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 5 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 nil nil nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1376774 ##(UI.ProportionalLayout) 170 176 8 #() false 170 192 640 nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 21 21 786 1409 813 528 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 498 1 1 410 ##(UI.StaticText) 34 16 nil 896 34 2 8 1140850945 1 976 nil 917510 ##(Graphics.Color) #silver nil 7 nil nil nil 976 nil 8 1801195232 1049094 ##(UI.NullConverter) nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 699 39 976 738 #text: 34 1 8 'System Options' 976 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 786 193 193 nil 27 nil nil nil 410 ##(UI.ListView) 34 45 nil 896 34 2 8 1409372236 1 1344 787270 2 ##(UI.ListModel) 138 144 640 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 7 nil nil nil 1344 nil 8 1801282304 786950 ##(Core.Message) #displayString 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil 786 129 129 nil nil 138 144 34 1 1117254 5 ##(UI.ListViewColumn) 8 'Column 1' 201 #left 1506 #displayString 1536 1506 #<= 8 #() nil nil 1344 nil 1 nil nil #thumbnails 8 #() 786 193 193 131169 786 65 65 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 39 786 699 775 1344 738 #text: 34 1 8 'Column 1' 1344 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 1328 nil 35 170 192 34 2 1344 8 'contents' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 699 813 896 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 34 2 976 1344 1328 nil 27 410 ##(UI.Splitter) 34 12 nil 528 34 2 8 1140850688 1 2192 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 2192 nil 1 #left nil nil nil 786 1 1 786 9 9 nil 2288 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 699 1 786 11 813 2192 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 1328 nil 27 410 ##(UI.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 2480 nil nil nil 7 nil nil nil 2480 498 1 1 410 ##(UI.StaticText) 34 16 nil 2480 34 2 8 1140850945 1 2560 nil 1056 nil 7 nil nil nil 2560 nil 8 1801195232 1090 nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 701 39 2560 738 #text: 34 1 8 'Properties' 2560 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 1328 nil 27 nil nil nil 410 ##(UI.ContainerView) 34 15 nil 2480 34 2 8 1409286144 131073 2864 nil nil nil 7 nil nil nil 2864 594 138 ##(Core.Dictionary) 640 true 170 192 640 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 39 786 701 775 2864 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 34 1 410 ##(UI.CardContainer) 34 16 nil 2864 34 2 8 1409286144 131073 3136 nil nil nil 7 nil nil nil 3136 853318 1 ##(UI.CardLayout) 138 144 34 2 1049094 ##(Core.Association) ##(Tools.PropertyInspector) 410 ##(UI.ListTreeView) 34 59 nil 3136 34 2 8 1140953421 1 3296 1410 138 144 640 nil 1472 1042 #default nil 15 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #inspectIt 8 '&Inspect' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3458 1 3490 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3458 1 3490 #browseIt 8 '&Browse It' 1 1 3538 nil true 3584 8 'ClassBrowserShell.ico' 3632 nil nil 3714 4097 3458 1 3490 #copyAspect 8 '&Copy' 1 1 nil nil nil 3458 1 3490 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 3714 4097 3458 1 3490 #editAspect 8 '&Edit' 1 1 nil nil nil 3458 1 3490 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 3714 4097 3458 1 3490 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3296 nil 8 1801282304 1506 #valueText 8 #() nil 1568 nil nil nil nil nil nil 138 144 34 3 1634 8 'Property' 319 #left 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 1504 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4256 7 257 nil 1506 #<= 8 #() nil nil 3296 nil 3 nil nil 1634 8 'Value' 319 #left 4242 0 nil 4274 2 1 4240 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4416 7 257 nil 1506 #<= 4368 nil nil 3296 4242 0 nil 4274 2 1 4240 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 4512 7 257 nil 3 nil nil 1634 8 '' 41 #center 1506 #displayString 8 #() 1506 #<= 4640 nil nil 3296 4242 0 nil 4274 3 1 4240 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Tools.PropertyInspector) #editButtonImageIndexFor: 4672 7 257 nil 1 nil nil #report 1728 nil 131431 786 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 ##(UI.VirtualTreeModel) nil 1472 138 144 640 nil nil 4242 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 4768 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4784 4242 0 nil 4834 1 83886083 4768 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4880 7 257 nil nil 138 ##(Core.PluggableSet) 640 138 ##(Core.IdentitySet) 640 1 1 nil nil nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 9 9 786 685 715 3296 738 #contextMenu: 34 1 3424 3296 738 #text: 34 1 8 'Property' 3296 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 2029 3266 ##(Tools.ValueWorkspace) 410 ##(UI.Scintilla.ScintillaView) 34 50 nil 3136 34 2 8 1411453252 1 5216 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 466 #smalltalkWorkspace nil 21 3410 nil true 34 13 3458 1 3490 #accept 8 '&Accept' 1 1 nil nil nil 3714 4097 3410 nil true 34 10 3458 1 3490 #undo 8 '&Undo' 1 1 3538 nil true 3584 8 'EditUndo.ico' 3632 nil nil 3714 4097 3458 1 3490 #cutSelection 8 'Cu&t' 1 1 3538 nil true 3584 8 'EditCut.ico' 3632 nil nil 3458 1 3490 #copySelection 8 '&Copy' 1 1 3538 nil true 3584 8 'EditCopy.ico' 3632 nil nil 3458 1 3490 #pasteClipboard 8 '&Paste' 1 1 3538 nil true 3584 8 'EditPaste.ico' 3632 nil nil 3458 1 3490 #clearSelection 8 'De&lete' 1 1 3538 nil true 3584 8 'EditClear.ico' 3632 nil nil 3714 4097 3458 1 3490 #reformatSource 8 'Re&format' 1 1 nil nil nil 3714 4097 3458 1 3490 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3410 nil true 34 10 3458 1 3490 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 3458 1 3490 #cloneNew 8 '&Clone' 1 1 3538 nil true 3584 8 'SmalltalkWorkspace.ico' 3632 nil nil 3714 4097 3458 1 3490 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3458 1 3490 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3458 1 3490 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3458 1 3490 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 1 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3458 1 3490 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3458 1 3490 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3458 1 3490 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 3714 4097 3458 1 3490 #browseIt 8 'Bro&wse It' 1 1 3538 nil true 3584 8 'ClassBrowserShell.ico' 3632 nil nil 3458 1 3490 #displayIt 8 '&Display It' 1 1 3538 nil true 3584 8 'DisplayIt.ico' 3632 nil nil 3458 1 3490 #printIt 8 '&Print It' 1 1 3538 nil true 3584 8 'PrintIt.ico' 3632 nil nil 3458 1 3490 #evaluateIt 8 'E&valuate It' 1 1 3538 nil true 3584 8 'EvaluateIt.ico' 3632 nil nil 3458 1 3490 #inspectIt 8 '&Inspect It' 1 1 3538 nil true 3584 8 'InspectIt.ico' 3632 nil nil 3458 1 3490 #debugIt 8 'Deb&ug It' 1 1 3538 nil true 3584 8 'Debugger.ico' 3632 nil nil 3714 4097 3410 nil true 34 2 3458 2097153 3490 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 3458 1 3490 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5216 nil 8 2031697384 1090 nil nil 9 1848871425 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7362 77 1042 #gray 1042 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 640 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 5216 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 640 nil 170 176 640 9215 nil nil nil nil 1056 nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 7328 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 3 ##(UI.Scintilla.IndicatorStyle) 17 5216 1042 #commonGreen 11 false #Notification nil nil nil nil nil nil #Warning 7746 19 5216 1042 #blue 3 false #Warning nil nil nil nil nil nil #Error 7746 21 5216 1042 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 7362 1029 nil 1042 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 7362 1027 1042 #darkGoldenrod 1042 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 7362 1031 1042 #firebrick 1042 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 674 138 144 34 10 738 #createAt:extent: 34 2 786 9 9 786 685 715 5216 738 #contextMenu: 34 1 5360 5216 738 #hoverTime: 8 #(500) 5216 738 #caretPeriod: 8 #(530) 5216 738 #wordWrap: 8 #(true) 5216 738 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 5216 1 3 nil nil 5 nil 8306 3 5216 1 nil nil 67108863 5 nil 8306 5 5216 1 nil nil nil 5 nil 5216 738 #tabWidth: 8 #(4) 5216 738 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 5216 738 #maxCompletionListHeight: 8 #(9) 5216 738 #edgeColumn: 8 #(1) 5216 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 31 3296 nil nil nil 170 192 34 4 3296 8 'aspects' 5216 8 'workspace' nil 410 ##(UI.TabViewXP) 34 28 nil 3136 34 2 8 1140916738 1 8640 1410 138 144 8 #(##(Tools.PropertyInspector) ##(Tools.ValueWorkspace)) nil 1472 nil nil 1 nil nil nil 8640 nil 8 1801049728 4242 0 nil 4274 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 8768 7 257 nil 4242 0 nil 4834 2 3 ##(UI.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 8832 7 257 nil 1568 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 1 786 701 775 8640 738 #setSingleSelection: 8 #(1) 8640 738 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8640 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 1328 nil 27 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 701 775 3136 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 34 3 3296 5216 8640 1328 nil 27 1328 nil 27 170 192 34 2 2864 8 'inspector' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 709 1 786 701 813 2480 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 34 2 2560 2864 1328 nil 27 1328 nil 27 170 192 34 2 528 8 'preferences' 1180166 ##(Graphics.Rectangle) 786 21 21 786 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 6143 21 786 1481 931 416 738 #text: 34 1 8 'User Preferences' 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 14 0 0 219 1 0 0] 34 1 528 1328 nil 27 )!

toolsFolderHelpId
	^10580! !
!Tools.UserPreferencesShell class categoriesFor: #defaultModel!public! !
!Tools.UserPreferencesShell class categoriesFor: #displayOn:!public! !
!Tools.UserPreferencesShell class categoriesFor: #icon!constants!public! !
!Tools.UserPreferencesShell class categoriesFor: #initialize!initializing!private! !
!Tools.UserPreferencesShell class categoriesFor: #publishedAspects!public! !
!Tools.UserPreferencesShell class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.UserPreferencesShell class categoriesFor: #toolsFolderHelpId!private! !

