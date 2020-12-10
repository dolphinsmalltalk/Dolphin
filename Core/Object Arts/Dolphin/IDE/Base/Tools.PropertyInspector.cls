"Filed out from Dolphin Smalltalk 7"!

Tools.AbstractPublishedAspectInspector subclass: #'Tools.PropertyInspector'
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
	^View 
		mapRectangle: rect
		from: aspectListView
		to: View desktop! !
!Tools.PropertyInspector categoriesFor: #createComponents!private! !
!Tools.PropertyInspector categoriesFor: #onAspectActioned!event handling!private! !
!Tools.PropertyInspector categoriesFor: #onAspectSelected!private! !
!Tools.PropertyInspector categoriesFor: #popupEditAspect!operations!public! !
!Tools.PropertyInspector categoriesFor: #selectAspect:!private! !
!Tools.PropertyInspector categoriesFor: #selectedAspectValueRect!private! !

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

	Smalltalk developmentSystem registerTool: self.
	treeUpdateMode := #lazy.
	treeHasGridLines := false!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1376774 ##(UI.ProportionalLayout) 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 576 nil 1 #left nil nil nil 918022 ##(Graphics.Point) 1 1 674 9 9 nil 688 nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 674 1 85 674 731 11 576 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 674 193 193 nil 27 1 true 170 192 8 #() nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 6143 21 674 731 341 416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 108 13 0 0 180 0 0 0] 34 2 576 410 ##(UI.CardContainer) 34 16 nil 416 34 2 8 1409286144 131073 1136 nil nil nil 5 nil nil nil 1136 853318 1 ##(UI.CardLayout) 138 144 34 2 546 ##(Tools.PropertyInspector) 410 ##(UI.ListTreeView) 34 59 nil 1136 34 2 8 1140953421 1 1280 787270 2 ##(UI.ListModel) 138 144 960 nil 1769478 ##(Kernel.IdentitySearchPolicy) 917510 ##(Graphics.Color) #default nil 13 461638 4 ##(UI.Menu) nil true 34 12 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #inspectIt 8 '&Inspect' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1506 1 1538 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 1506 1 1538 #browseIt 8 '&Browse It' 1 1 1586 nil true 1632 8 'ClassBrowserShell.ico' 1680 nil nil 1762 4097 1506 1 1538 #copyAspect 8 '&Copy' 1 1 nil nil nil 1506 1 1538 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1762 4097 1506 1 1538 #editAspect 8 '&Edit' 1 1 nil nil nil 1506 1 1538 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1762 4097 1506 1 1538 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1280 nil 8 1801282304 786950 ##(Core.Message) #valueText 8 #() nil 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil nil 138 144 34 3 1117254 5 ##(UI.ListViewColumn) 8 'Property' 335 #left 2194 #valueNameOnly 8 #() 2194 #<= 8 #() nil nil 1280 nil 3 2194 #valueNameInfo 8 #() nil 2306 8 'Value' 333 #left 2194 #valueTextOnly 8 #() 2194 #<= 2400 nil nil 1280 2194 #valueImage 8 #() 3 nil nil 2306 8 '' 33 #center nil 2194 #<= 8 #() nil nil 1280 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 3 1 2624 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Tools.PropertyInspector) #editButtonImageIndexFor: 2640 7 257 nil 1 nil nil #report 8 #() nil 131431 674 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1247046 3 ##(UI.VirtualTreeModel) nil 1408 138 144 960 nil nil 2626 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 2768 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2784 2626 0 nil 2834 1 83886083 2768 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2880 7 257 nil nil 138 ##(Core.PluggableSet) 960 138 ##(Core.IdentitySet) 960 13 1 nil nil nil nil nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 674 9 9 674 715 281 1280 786 #contextMenu: 34 1 1472 1280 786 #text: 34 1 8 'Property' 1280 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 928 nil 2029 546 ##(Tools.ValueWorkspace) 410 ##(UI.Scintilla.ScintillaView) 34 50 nil 1136 34 2 8 1411453252 1 3216 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 1245702 ##(Graphics.ThemeColor) #smalltalkWorkspace nil 21 1458 nil true 34 13 1506 1 1538 #accept 8 '&Accept' 1 1 nil nil nil 1762 4097 1458 nil true 34 10 1506 1 1538 #undo 8 '&Undo' 1 1 1586 nil true 1632 8 'EditUndo.ico' 1680 nil nil 1762 4097 1506 1 1538 #cutSelection 8 'Cu&t' 1 1 1586 nil true 1632 8 'EditCut.ico' 1680 nil nil 1506 1 1538 #copySelection 8 '&Copy' 1 1 1586 nil true 1632 8 'EditCopy.ico' 1680 nil nil 1506 1 1538 #pasteClipboard 8 '&Paste' 1 1 1586 nil true 1632 8 'EditPaste.ico' 1680 nil nil 1506 1 1538 #clearSelection 8 'De&lete' 1 1 1586 nil true 1632 8 'EditClear.ico' 1680 nil nil 1762 4097 1506 1 1538 #reformatSource 8 'Re&format' 1 1 nil nil nil 1762 4097 1506 1 1538 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1458 nil true 34 10 1506 1 1538 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1506 1 1538 #cloneNew 8 '&Clone' 1 1 1586 nil true 1632 8 'SmalltalkWorkspace.ico' 1680 nil nil 1762 4097 1506 1 1538 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1506 1 1538 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1506 1 1538 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1506 1 1538 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 1 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1506 1 1538 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1506 1 1538 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1506 1 1538 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1762 4097 1506 1 1538 #browseIt 8 'Bro&wse It' 1 1 1586 nil true 1632 8 'ClassBrowserShell.ico' 1680 nil nil 1506 1 1538 #displayIt 8 '&Display It' 1 1 1586 nil true 1632 8 'DisplayIt.ico' 1680 nil nil 1506 1 1538 #printIt 8 '&Print It' 1 1 1586 nil true 1632 8 'PrintIt.ico' 1680 nil nil 1506 1 1538 #evaluateIt 8 'E&valuate It' 1 1 1586 nil true 1632 8 'EvaluateIt.ico' 1680 nil nil 1506 1 1538 #inspectIt 8 '&Inspect It' 1 1 1586 nil true 1632 8 'InspectIt.ico' 1680 nil nil 1506 1 1538 #debugIt 8 'Deb&ug It' 1 1 1586 nil true 1632 8 'Debugger.ico' 1680 nil nil 1762 4097 1458 nil true 34 2 1506 2097153 1538 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1506 1 1538 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3216 nil 8 2031697384 1049094 ##(UI.NullConverter) nil nil 9 1848888897 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 5394 77 1426 #gray 1426 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 960 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 3216 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 960 nil 170 176 960 9215 nil nil nil nil 1426 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 5360 nil nil nil nil 16 nil 170 192 34 6 #Notification 1772614 3 ##(UI.Scintilla.IndicatorStyle) 17 3216 1426 #commonGreen 11 false #Notification nil nil nil nil nil nil #Warning 5794 19 3216 1426 #blue 3 false #Warning nil nil nil nil nil nil #Error 5794 21 3216 1426 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 5394 1029 nil 1426 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 5394 1027 1426 #darkGoldenrod 1426 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 5394 1031 1426 #firebrick 1426 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 722 138 144 34 10 786 #createAt:extent: 34 2 674 9 9 674 715 281 3216 786 #contextMenu: 34 1 3376 3216 786 #hoverTime: 8 #(500) 3216 786 #caretPeriod: 8 #(530) 3216 786 #wordWrap: 8 #(true) 3216 786 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 3216 1 3 nil nil 5 nil 6354 3 3216 1 nil nil 67108863 5 nil 6354 5 3216 1 nil nil nil 5 nil 3216 786 #tabWidth: 8 #(4) 3216 786 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 3216 786 #maxCompletionListHeight: 8 #(9) 3216 786 #edgeColumn: 8 #(1) 3216 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 928 nil 31 1280 nil nil nil 170 192 34 4 1280 8 'aspects' 3216 8 'workspace' nil 410 ##(UI.TabViewXP) 34 28 nil 1136 34 2 8 1140916738 1 6688 1346 138 144 8 #(##(Tools.PropertyInspector) ##(Tools.ValueWorkspace)) nil 1408 nil nil 1 nil nil nil 6688 nil 8 1801049728 2626 0 nil 2658 1 83886081 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 6816 7 257 nil 2626 0 nil 2834 2 3 ##(UI.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 6880 7 257 nil 2256 nil nil nil nil nil #smallIcons nil nil nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 674 1 1 674 731 341 6688 786 #setSingleSelection: 8 #(1) 6688 786 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6688 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 8 #() 928 nil 27 722 138 144 34 1 786 #createAt:extent: 34 2 674 1 1 674 731 341 1136 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 34 3 1280 3216 6688 928 nil 27 928 nil 27 )! !
!Tools.PropertyInspector class categoriesFor: #editButtonImageIndexFor:!public! !
!Tools.PropertyInspector class categoriesFor: #ellipsisButtonIcon!public! !
!Tools.PropertyInspector class categoriesFor: #initialize!initializing!private! !
!Tools.PropertyInspector class categoriesFor: #resource_Default_view!public!resources-views! !

