"Filed out from Dolphin Smalltalk"!

AbstractPublishedAspectInspector subclass: #PropertyInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PropertyInspector guid: (GUID fromString: '{35bdcf77-b398-4b3b-bd3a-9675f82870d6}')!

PropertyInspector comment: 'A new version of the Published Aspect Inspector that uses a more traditional hierarchical list pane to edit properties (published aspects) in situ. Doesn''t provide the PAI functionality of rendering separate displays of the aspect being aspected. Should be plug-compatible with retro uses of the PAI.

'!

!PropertyInspector categoriesForClass!MVP-Resources-IDE Tools! !

!PropertyInspector methodsFor!

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

!PropertyInspector categoriesForMethods!
createComponents!private! !
onAspectActioned!event handling!private! !
onAspectSelected!private! !
popupEditAspect!operations!public! !
selectAspect:!private! !
selectedAspectValueRect!private! !
!

!PropertyInspector class methodsFor!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 576 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 674 9 9 nil 688 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 85 674 731 11 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 674 193 193 nil 27 1 true 170 192 8 #() nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 7039 21 674 731 341 416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 44 15 0 0 180 0 0 0] 34 2 576 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1409286144 131073 1136 nil nil nil 5 nil nil nil 1136 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 546 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 59 nil 1136 34 2 8 1140953421 1 1280 590662 2 ##(Smalltalk.ListModel) 138 144 960 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1506 1 1538 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1506 1 1538 #browseIt 8 '&Browse It' 1 1 1586 nil true 1632 8 'ClassBrowserShell.ico' 1680 nil nil 1762 4097 1506 1 1538 #copyAspect 8 '&Copy' 1 1 nil nil nil 1506 1 1538 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1762 4097 1506 1 1538 #editAspect 8 '&Edit' 1 1 nil nil nil 1506 1 1538 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1762 4097 1506 1 1538 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1280 nil 8 1867533600 459270 ##(Smalltalk.Message) #valueText 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Property' 335 #left 2194 #valueNameOnly 8 #() 2194 #<= 8 #() nil nil 1280 nil 3 2194 #valueNameInfo 8 #() nil 2306 8 'Value' 333 #left 2194 #valueTextOnly 8 #() 2194 #<= 2400 nil nil 1280 2194 #valueImage 8 #() 3 nil nil 2306 8 '' 33 #center nil 2194 #<= 8 #() nil nil 1280 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 2624 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2640 7 257 nil 1 nil nil #report 960 nil 131431 674 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1408 138 144 960 nil nil 2626 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2752 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2768 2626 0 nil 2818 1 83886083 2752 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2864 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 960 138 ##(Smalltalk.IdentitySet) 960 13 1 nil nil nil nil nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 674 9 9 674 715 281 1280 786 #contextMenu: 34 1 1472 1280 786 #text: 34 1 8 'Property' 1280 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 928 nil 2029 546 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 1136 34 2 8 1411453252 1 3200 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 21 1458 nil true 34 13 1506 1 1538 #accept 8 '&Accept' 1 1 nil nil nil 1762 4097 1458 nil true 34 10 1506 1 1538 #undo 8 '&Undo' 1 1 1586 nil true 1632 8 'EditUndo.ico' 1680 nil nil 1762 4097 1506 1 1538 #cutSelection 8 'Cu&t' 1 1 1586 nil true 1632 8 'EditCut.ico' 1680 nil nil 1506 1 1538 #copySelection 8 '&Copy' 1 1 1586 nil true 1632 8 'EditCopy.ico' 1680 nil nil 1506 1 1538 #pasteClipboard 8 '&Paste' 1 1 1586 nil true 1632 8 'EditPaste.ico' 1680 nil nil 1506 1 1538 #clearSelection 8 'De&lete' 1 1 1586 nil true 1632 8 'EditClear.ico' 1680 nil nil 1762 4097 1506 1 1538 #reformatSource 8 'Re&format' 1 1 nil nil nil 1762 4097 1506 1 1538 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1458 nil true 34 10 1506 1 1538 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1506 1 1538 #cloneNew 8 '&Clone' 1 1 1586 nil true 1632 8 'SmalltalkWorkspace.ico' 1680 nil nil 1762 4097 1506 1 1538 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1506 1 1538 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1506 1 1538 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1506 1 1538 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1506 1 1538 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1506 1 1538 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1506 1 1538 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1762 4097 1506 1 1538 #browseIt 8 'Bro&wse It' 1 1 1586 nil true 1632 8 'ClassBrowserShell.ico' 1680 nil nil 1506 1 1538 #displayIt 8 '&Display It' 1 1 1586 nil true 1632 8 'DisplayIt.ico' 1680 nil nil 1506 1 1538 #printIt 8 '&Print It' 1 1 1586 nil true 1632 8 'PrintIt.ico' 1680 nil nil 1506 1 1538 #evaluateIt 8 'E&valuate It' 1 1 1586 nil true 1632 8 'EvaluateIt.ico' 1680 nil nil 1506 1 1538 #inspectIt 8 '&Inspect It' 1 1 1586 nil true 1632 8 'InspectIt.ico' 1680 nil nil 1506 1 1538 #debugIt 8 'Deb&ug It' 1 1 1586 nil true 1632 8 'Debugger.ico' 1680 nil nil 1762 4097 1458 nil true 34 2 1506 2097153 1538 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1506 1 1538 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3200 nil 8 1533163101 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 5378 77 1426 #gray 1426 #white 1 nil nil nil nil #callTip nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 960 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 3200 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 960 nil 170 176 960 9215 nil nil nil nil 1426 #silver nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 5344 nil nil nil nil 3 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 3200 1426 #blue 3 false #Warning nil nil nil nil nil nil #Notification 5778 17 3200 1426 #commonGreen 11 false #Notification nil nil nil nil nil nil #Error 5778 21 3200 1426 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 5378 1027 1426 #darkGoldenrod 1426 #ivory 1 nil nil nil nil #Warning nil nil nil #Notification 5378 1029 nil 1426 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 5378 1031 1426 #firebrick 1426 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 722 138 144 34 11 786 #createAt:extent: 34 2 674 9 9 674 715 281 3200 786 #contextMenu: 34 1 3360 3200 786 #textLimit: 8 #(1073741823) 3200 786 #hoverTime: 8 #(500) 3200 786 #caretPeriod: 8 #(530) 3200 786 #wordWrap: 8 #(true) 3200 786 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 3200 1 3 nil nil 5 nil 6370 3 3200 1 nil nil 67108863 5 nil 6370 5 3200 1 nil nil nil 5 nil 3200 786 #tabWidth: 8 #(4) 3200 786 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 3200 786 #maxCompletionListHeight: 8 #(9) 3200 786 #edgeColumn: 8 #(1) 3200 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 928 nil 29 1280 nil nil nil 170 192 34 4 1280 8 'aspects' 3200 8 'workspace' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1136 34 2 8 1140916738 1 6704 1346 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1408 nil nil 1 nil nil nil 6704 nil 8 1867639456 2626 0 nil 2658 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 6832 7 257 nil 2626 0 nil 2818 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 6896 7 257 nil 2256 nil nil nil nil nil #smallIcons nil nil nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 674 1 1 674 731 341 6704 786 #basicSelectionsByIndex: 34 1 8 #(1) 6704 786 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6704 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 8 #() 928 nil 27 722 138 144 34 1 786 #createAt:extent: 34 2 674 1 1 674 731 341 1136 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 34 3 1280 3200 6704 928 nil 27 928 nil 27 )! !

!PropertyInspector class categoriesForMethods!
editButtonImageIndexFor:!public! !
ellipsisButtonIcon!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

