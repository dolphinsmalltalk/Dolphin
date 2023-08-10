"Filed out from Dolphin Smalltalk"!

Tools.AbstractPublishedAspectInspector
	subclass: #'Tools.PropertyInspector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PropertyInspector guid: (Core.GUID fromString: '{35bdcf77-b398-4b3b-bd3a-9675f82870d6}')!
Tools.PropertyInspector comment: 'A new version of the Published Aspect Inspector that uses a more traditional hierarchical list pane to edit properties (published aspects) in situ. Doesn''t provide the PAI functionality of rendering separate displays of the aspect being aspected. Should be plug-compatible with retro uses of the PAI.

'!
!Tools.PropertyInspector categoriesForClass!MVP-Resources-IDE Tools! !
!Tools.PropertyInspector methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	aspectPresenter := self add: ValueWorkspace new name: 'workspace'!

onAspectActioned
	"Event handler for an action being performed on the current aspect, i.e. Enter or double-click"

	self aspectAccessor canImmediateAction 
		ifTrue: [^self aspectAccessor immediateActionUsing: aspectPresenter].
	self popupEditAspect!

onAspectSelected
	"Private - An aspect accessor has been selected within the aspect tree. Transfer the new aspect value
	to our local aspectValueModel buffer and then create the appropriate aspect presenters."

	self aspectAccessor 
		ifNil: 
			["Replacing the entire value model avoids any chance of any old observers seeing future change events"
			aspectValueHolder := nil]
		ifNotNil: [:accessor | accessor selectIn: self]!

popupEditAspect
	"Action the currently selected aspect using the current aspect presenter"

	| aspectDialog |
	aspectDialog := AspectEditorDialog createOn: nil asValue.

	"To avoid visual shock, make sure the dialog font is the same as that of our aspectTreePresenter"
	aspectDialog view font: aspectTreePresenter view font.

	"Ensure the aspect is visible"
	aspectTreePresenter ensureSelectionVisible.
	aspectDialog recommendedRectangle: self selectedAspectValueRect.
	aspectDialog createAspectPresenters: self aspectAccessor for: aspectValueHolder.
	^aspectDialog showModal!

selectAspect: anAspectAccessor 
	"Private - Replacing the entire value model avoids any chance of any old observers seeing future change events"

	self createValueHolderFor: anAspectAccessor.
	aspectPresenter model: aspectValueHolder!

selectedAspectValueRect
	"Private - Answer a screen rectangle bounding the value area of the selected aspect "

	| aspectListView rect |
	aspectListView := aspectTreePresenter view.
	rect := aspectListView subItemRectRow: aspectListView selectionByIndex column: 2.
	^aspectListView mapRectangle: rect to: View desktop! !
!Tools.PropertyInspector categoriesForMethods!
createComponents!private! !
onAspectActioned!event handling!private! !
onAspectSelected!private! !
popupEditAspect!operations!public! !
selectAspect:!private! !
selectedAspectValueRect!private! !
!

!Tools.PropertyInspector class methodsFor!

editButtonImageIndexFor: anAspectAccessor 
	"Answers the image index for an edit button for anAspectAccessor (if any). Used in the
	PropertyInspector aspects view pane to display an edit button where appropriate. Answers -1
	if no such button is required"

	| aspect |
	aspect := anAspectAccessor aspectDescriptor.
	(aspect canEdit and: [aspect canImmediateAction not]) ifFalse: [^-1].
	^self ellipsisButtonIcon imageIndex!

ellipsisButtonIcon
	^Icon fromId: 'EllipsisButton.ico'!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	SmalltalkSystem current registerTool: self.
	treeUpdateMode := #lazy.
	treeHasGridLines := false!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ContainerView} 38 #{Core.Array} 15 nil nil 50 2 8 1409286144 131073 32 nil nil nil 5 nil nil nil 32 518 #{UI.ProportionalLayout} 294 #{Core.Dictionary} 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 32 50 2 8 1140850688 1 208 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 208 nil 1 #left nil nil nil 518 #{Graphics.Point} 1 1 306 9 9 nil 320 nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 306 1 85 306 731 11 208 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 306 193 193 nil 27 1 true 550 #{Core.IdentityDictionary} 0 nil 354 50 1 402 #createAt:extent: 50 2 306 6143 21 306 731 341 32 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 108 13 0 0 180 0 0 0] 50 2 208 18 #{UI.CardContainer} 50 16 nil 32 50 2 8 1409286144 131073 736 nil nil nil 5 nil nil nil 736 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 2 178 #{Tools.PropertyInspector} 18 #{UI.ListTreeView} 50 59 nil 736 50 2 8 1140953421 1 880 838 2 #{UI.ListModel} 834 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 13 2886 4 #{UI.Menu} nil true 50 12 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 1106 1 1138 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 1106 1 1138 #browseIt 8 '&Browse It' 1 1 1186 nil true 1218 8 'ClassBrowserShell.ico' 1280 65541 nil nil nil 1362 4097 1106 1 1138 #copyAspect 8 '&Copy' 1 1 nil nil nil 1106 1 1138 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1362 4097 1106 1 1138 #editAspect 8 '&Edit' 1 1 nil nil nil 1106 1 1138 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 1362 4097 1106 1 1138 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 880 nil 8 1853243664 518 #{Core.Message} #valueText 8 #() nil 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 834 3 3142 5 #{UI.ListViewColumn} 8 'Property' 335 #left 1810 #valueNameOnly 8 #() 1810 #<= 8 #() nil nil 880 1810 #typeImage 8 #() 3 1810 #valueNameInfo 8 #() nil 1906 8 'Value' 333 #left 1810 #valueTextOnly 8 #() 1810 #<= 2000 nil nil 880 1810 #valueImage 8 #() 3 nil nil 1906 8 '' 33 #center nil 1810 #<= 8 #() nil nil 880 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 3 1 2256 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1094 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 2272 7 257 nil 1 nil nil #report 8 #() nil 131431 306 129 129 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil false 1862 3 #{UI.VirtualTreeModel} nil 1008 834 0 nil nil 2258 0 nil 1318 #{Kernel.CompiledMethod} 2 3 2432 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2448 2258 0 nil 2498 1 83886083 2432 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2544 7 257 nil nil 550 #{Core.PluggableSet} 0 294 #{Core.IdentitySet} 0 13 1 nil nil nil nil nil nil nil 354 50 2 402 #createAt:extent: 50 2 306 9 9 306 715 281 880 402 #text: 50 1 8 'Property' 880 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 544 nil 2029 178 #{Tools.ValueWorkspace} 18 #{UI.Scintilla.ScintillaView} 50 56 nil 736 50 2 8 1411453252 1 2864 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 1058 nil true 50 13 1106 1 1138 #accept 8 '&Accept' 1 1 nil nil nil 1362 4097 1058 nil true 50 10 1106 1 1138 #undo 8 '&Undo' 1 1 1186 nil true 1218 8 'EditUndo.ico' 1280 65541 nil nil nil 1362 4097 1106 1 1138 #cutSelection 8 'Cu&t' 1 1 1186 nil true 1218 8 'EditCut.ico' 1280 65541 nil nil nil 1106 1 1138 #copySelection 8 '&Copy' 1 1 1186 nil true 1218 8 'EditCopy.ico' 1280 65541 nil nil nil 1106 1 1138 #pasteClipboard 8 '&Paste' 1 1 1186 nil true 1218 8 'EditPaste.ico' 1280 65541 nil nil nil 1106 1 1138 #clearSelection 8 'De&lete' 1 1 1186 nil true 1218 8 'EditClear.ico' 1280 65541 nil nil nil 1362 4097 1106 1 1138 #reformatSource 8 'Re&format' 1 1 nil nil nil 1362 4097 1106 1 1138 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1058 nil true 50 10 1106 1 1138 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1106 1 1138 #cloneNew 8 '&Clone' 1 1 1186 nil true 1218 8 'SmalltalkWorkspace.ico' 1280 65541 nil nil nil 1362 4097 1106 1 1138 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1106 1 1138 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1106 1 1138 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1106 1 1138 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1106 1 1138 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1106 1 1138 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1106 1 1138 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1362 4097 1106 1 1138 #browseIt 8 'Bro&wse It' 1 1 1186 nil true 1218 8 'ClassBrowserShell.ico' 1280 65541 nil nil nil 1106 1 1138 #displayIt 8 '&Display It' 1 1 1186 nil true 1218 8 'DisplayIt.ico' 1280 65541 nil nil nil 1106 1 1138 #printIt 8 '&Print It' 1 1 1186 nil true 1218 8 'PrintIt.ico' 1280 65541 nil nil nil 1106 1 1138 #evaluateIt 8 'E&valuate It' 1 1 1186 nil true 1218 8 'EvaluateIt.ico' 1280 65541 nil nil nil 1106 1 1138 #inspectIt 8 '&Inspect It' 1 1 1186 nil true 1218 8 'InspectIt.ico' 1280 65541 nil nil nil 1106 1 1138 #debugIt 8 'Deb&ug It' 1 1 1186 nil true 1218 8 'Debugger.ico' 1280 65541 nil nil nil 1362 4097 1058 nil true 50 2 1106 2097153 1138 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1106 1 1138 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 2864 nil 8 1367644576 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 562 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 1026 #gray 1026 #white 1 nil nil nil nil #callTip nil nil nil #normal 5218 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 834 0 562 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 2864 #circle nil nil nil nil nil nil 2626 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 5410 1 81 1026 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 562 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 562 1 #container 5200 nil nil nil nil #{Core.AnsiString} nil 562 3 #Error 3142 5 #{UI.Scintilla.IndicatorDefinition} 21 2864 1026 #red 3 3 #Error nil nil nil nil nil nil #Notification 5602 17 2864 1026 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 5602 19 2864 1026 #blue 3 3 #Warning nil nil nil nil nil nil nil nil 562 3 #Error 5218 1031 1026 #firebrick 1026 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 5218 1029 nil 1026 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5218 1027 1026 #darkGoldenrod 1026 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 354 50 8 402 #createAt:extent: 50 2 306 9 9 306 715 281 2864 402 #wordWrap: 8 #(true) 2864 402 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 2864 nil 3 nil nil 5 nil 6034 3 2864 nil nil nil 67108863 5 nil 6034 5 2864 nil nil nil nil 5 nil 2864 402 #tabWidth: 8 #(4) 2864 402 #maxCompletionListHeight: 8 #(9) 2864 402 #sciSetTechnology: 8 #(1) 2864 402 #sciSetFontQuality: 8 #(3) 2864 402 #sciSetSelectionLayer: 8 #(1) 2864 482 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 544 nil 45 880 nil nil nil 562 2 880 8 'aspects' 2864 8 'workspace' nil 18 #{UI.TabViewXP} 50 28 nil 736 50 2 8 1140916738 1 6352 946 834 2 #{Tools.PropertyInspector} #{Tools.ValueWorkspace} nil 1008 nil nil 1 nil nil nil 6352 nil 8 1852839600 2258 0 nil 2290 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 6464 7 257 nil 1810 #iconImageIndex 8 #() 1872 nil nil nil nil nil #smallIcons nil nil nil nil nil 354 50 3 402 #createAt:extent: 50 2 306 1 1 306 731 341 6352 402 #setSingleSelection: 8 #(1) 6352 402 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6352 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 8 #() 544 nil 27 354 50 1 402 #createAt:extent: 50 2 306 1 1 306 731 341 736 482 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 50 3 880 2864 6352 544 nil 27 544 nil 27)! !
!Tools.PropertyInspector class categoriesForMethods!
editButtonImageIndexFor:!public! !
ellipsisButtonIcon!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

