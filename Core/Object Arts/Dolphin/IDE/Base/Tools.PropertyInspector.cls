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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 #{UI.ProportionalLayout} 138 #{Core.Dictionary} 34 1 1049094 #{Core.Association} 410 #{UI.Splitter} 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 576 nil 1 #left nil nil nil 918022 #{Graphics.Point} 1 1 674 9 9 nil 688 nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 674 1 85 674 731 11 576 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 674 193 193 nil 27 1 true 170 192 8 #() nil 722 34 1 770 #createAt:extent: 34 2 674 12287 21 674 731 341 416 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 108 25 0 0 180 0 0 0] 34 2 576 410 #{UI.CardContainer} 34 16 nil 416 34 2 8 1409286144 131073 1104 nil nil nil 5 nil nil nil 1104 853318 1 #{UI.CardLayout} 138 144 34 2 546 #{Tools.PropertyInspector} 410 #{UI.ListTreeView} 34 59 nil 1104 34 2 8 1140953421 1 1248 787270 2 #{UI.ListModel} 138 144 944 nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 13 461638 4 #{UI.Menu} nil true 34 12 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #inspectIt 8 '&Inspect' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'BasicInspector.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 1474 1 1506 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 1474 1 1506 #browseIt 8 '&Browse It' 1 1 1554 nil true 1586 8 'ClassBrowserShell.ico' 1648 65541 nil nil nil 1730 4097 1474 1 1506 #copyAspect 8 '&Copy' 1 1 nil nil nil 1474 1 1506 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1730 4097 1474 1 1506 #editAspect 8 '&Edit' 1 1 nil nil nil 1474 1 1506 #resetAspect 8 '&Set to Nil/Default' 1 1 nil nil nil 1730 4097 1474 1 1506 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 1248 nil 8 1815049392 786950 #{Core.Message} #valueText 8 #() nil 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil nil 138 144 34 3 1117254 5 #{UI.ListViewColumn} 8 'Property' 335 #left 2178 #valueNameOnly 8 #() 2178 #<= 8 #() nil nil 1248 2178 #typeImage 8 #() 3 2178 #valueNameInfo 8 #() nil 2290 8 'Value' 333 #left 2178 #valueTextOnly 8 #() 2178 #<= 2384 nil nil 1248 2178 #valueImage 8 #() 3 nil nil 2290 8 '' 33 #center nil 2178 #<= 8 #() nil nil 1248 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 3 1 2640 8 'doIt' 8 '[:x | Tools.PropertyInspector editButtonImageIndexFor: x]' 8 #[31 105 45 17 177 106] 1442886 2 #{Kernel.VariableBinding} #PropertyInspector #{Tools.PropertyInspector} #{Tools} 1 #editButtonImageIndexFor: 2656 7 257 nil 1 nil nil #report 8 #() nil 131431 674 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 #{UI.VirtualTreeModel} nil 1376 138 144 944 nil nil 2642 0 nil 1377574 #{Kernel.CompiledMethod} 2 3 2816 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2832 2642 0 nil 2882 1 83886083 2816 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2928 7 257 nil nil 138 #{Core.PluggableSet} 944 138 #{Core.IdentitySet} 944 13 1 nil nil nil nil nil nil nil 722 34 3 770 #createAt:extent: 34 2 674 9 9 674 715 281 1248 770 #contextMenu: 34 1 1440 1248 770 #text: 34 1 8 'Property' 1248 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 912 nil 2029 546 #{Tools.ValueWorkspace} 410 #{UI.Scintilla.ScintillaView} 34 52 nil 1104 34 2 8 1411453252 1 3248 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 1245702 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 1426 nil true 34 13 1474 1 1506 #accept 8 '&Accept' 1 1 nil nil nil 1730 4097 1426 nil true 34 10 1474 1 1506 #undo 8 '&Undo' 1 1 1554 nil true 1586 8 'EditUndo.ico' 1648 65541 nil nil nil 1730 4097 1474 1 1506 #cutSelection 8 'Cu&t' 1 1 1554 nil true 1586 8 'EditCut.ico' 1648 65541 nil nil nil 1474 1 1506 #copySelection 8 '&Copy' 1 1 1554 nil true 1586 8 'EditCopy.ico' 1648 65541 nil nil nil 1474 1 1506 #pasteClipboard 8 '&Paste' 1 1 1554 nil true 1586 8 'EditPaste.ico' 1648 65541 nil nil nil 1474 1 1506 #clearSelection 8 'De&lete' 1 1 1554 nil true 1586 8 'EditClear.ico' 1648 65541 nil nil nil 1730 4097 1474 1 1506 #reformatSource 8 'Re&format' 1 1 nil nil nil 1730 4097 1474 1 1506 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1426 nil true 34 10 1474 1 1506 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1474 1 1506 #cloneNew 8 '&Clone' 1 1 1554 nil true 1586 8 'SmalltalkWorkspace.ico' 1648 65541 nil nil nil 1730 4097 1474 1 1506 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1474 1 1506 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1474 1 1506 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1474 1 1506 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1474 1 1506 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1474 1 1506 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1474 1 1506 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1730 4097 1474 1 1506 #browseIt 8 'Bro&wse It' 1 1 1554 nil true 1586 8 'ClassBrowserShell.ico' 1648 65541 nil nil nil 1474 1 1506 #displayIt 8 '&Display It' 1 1 1554 nil true 1586 8 'DisplayIt.ico' 1648 65541 nil nil nil 1474 1 1506 #printIt 8 '&Print It' 1 1 1554 nil true 1586 8 'PrintIt.ico' 1648 65541 nil nil nil 1474 1 1506 #evaluateIt 8 'E&valuate It' 1 1 1554 nil true 1586 8 'EvaluateIt.ico' 1648 65541 nil nil nil 1474 1 1506 #inspectIt 8 '&Inspect It' 1 1 1554 nil true 1586 8 'InspectIt.ico' 1648 65541 nil nil nil 1474 1 1506 #debugIt 8 'Deb&ug It' 1 1 1554 nil true 1586 8 'Debugger.ico' 1648 65541 nil nil nil 1730 4097 1426 nil true 34 2 1474 2097153 1506 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 1474 1 1506 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3248 nil 8 1395533126 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 5618 77 1394 #gray 1394 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 138 144 944 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 3248 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 944 nil 170 176 944 9215 nil nil 170 176 34 2 81 1394 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 5584 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 4 #{UI.Scintilla.IndicatorStyle} 17 3248 1394 #commonGreen 11 3 #Notification nil nil nil nil nil nil #Warning 6082 19 3248 1394 #blue 3 3 #Warning nil nil nil nil nil nil #Error 6082 21 3248 1394 #red 3 3 #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 5618 1029 nil 1394 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5618 1027 1394 #darkGoldenrod 1394 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 5618 1031 1394 #firebrick 1394 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 722 34 9 770 #createAt:extent: 34 2 674 9 9 674 715 281 3248 770 #contextMenu: 34 1 3408 3248 770 #wordWrap: 8 #(true) 3248 770 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 3248 1 3 nil nil 5 nil 6562 3 3248 1 nil nil 67108863 5 nil 6562 5 3248 1 nil nil nil 5 nil 3248 770 #tabWidth: 8 #(4) 3248 770 #maxCompletionListHeight: 8 #(9) 3248 770 #sciSetTechnology: 8 #(1) 3248 770 #sciSetFontQuality: 8 #(3) 3248 770 #sciSetSelectionLayer: 8 #(1) 3248 850 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 912 nil 35 1248 nil nil nil 170 192 34 4 1248 8 'aspects' 3248 8 'workspace' nil 410 #{UI.TabViewXP} 34 28 nil 1104 34 2 8 1140916738 1 6896 1314 138 144 8 #(#{Tools.PropertyInspector} #{Tools.ValueWorkspace}) nil 1376 nil nil 1 nil nil nil 6896 nil 8 1814862704 2642 0 nil 2674 1 83886081 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | nil]' 1782343965 7024 7 257 nil 2178 #iconImageIndex 8 #() 2240 nil nil nil nil nil #smallIcons nil nil nil nil nil 722 34 3 770 #createAt:extent: 34 2 674 1 1 674 731 341 6896 770 #setSingleSelection: 8 #(1) 6896 770 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6896 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 8 #() 912 nil 27 722 34 1 770 #createAt:extent: 34 2 674 1 1 674 731 341 1104 850 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 34 3 1248 3248 6896 912 nil 27 912 nil 27)! !
!Tools.PropertyInspector class categoriesForMethods!
editButtonImageIndexFor:!public! !
ellipsisButtonIcon!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

