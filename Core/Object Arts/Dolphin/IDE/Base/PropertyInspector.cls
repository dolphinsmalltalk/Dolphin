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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 576 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 674 9 9 nil 688 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 193 608 8 '' 576 1 8 #() 674 193 193 nil 27 1 true 170 192 8 #() nil 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[191 13 0 0 10 0 0 0 44 15 0 0 180 0 0 0] 193 448 8 '' 416 1 34 2 576 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1409286144 131073 1152 nil nil nil 5 nil nil nil 1152 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 546 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 59 nil 1152 34 2 8 1140953421 1 1296 590662 2 ##(Smalltalk.ListModel) 138 144 976 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1522 1 1554 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1522 1 1554 #browseIt 8 '&Browse It' 1 1 1602 nil true 1648 8 'ClassBrowserShell.ico' 1696 nil nil 1778 4097 1522 1 1554 #copyAspect 8 '&Copy' 1 1 nil nil nil 1522 1 1554 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1778 4097 1522 1 1554 #editAspect 8 '&Edit' 1 1 nil nil nil 1522 1 1554 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1778 4097 1522 1 1554 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1296 nil 8 1759068368 459270 ##(Smalltalk.Message) #valueText 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Property' 335 #left 2210 #valueNameOnly 8 #() 2210 #<= 8 #() nil nil 1296 nil 3 2210 #valueNameInfo 8 #() nil 2322 8 'Value' 333 #left 2210 #valueTextOnly 8 #() 2210 #<= 2416 nil nil 1296 2210 #valueImage 8 #() 3 nil nil 2322 8 '' 33 #center nil 2210 #<= 8 #() nil nil 1296 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 2640 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2656 7 257 nil 1 nil nil #report 8 #() nil 131431 674 129 129 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1424 138 144 976 nil nil 2642 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2784 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2800 2642 0 nil 2850 1 83886083 2784 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 2896 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 976 138 ##(Smalltalk.IdentitySet) 976 13 1 nil nil nil nil nil nil nil 722 138 144 34 2 786 #createWindow: 34 1 834 866 8 #[4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 193 1328 8 'Property' 1296 786 #contextMenu: 34 1 1488 1296 3 8 #() 674 193 193 nil 2029 546 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 65 nil 1152 34 2 8 1411453252 1 3200 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 21 1474 nil true 34 13 1522 1 1554 #accept 8 '&Accept' 1 1 nil nil nil 1778 4097 1474 nil true 34 10 1522 1 1554 #undo 8 '&Undo' 1 1 1602 nil true 1648 8 'EditUndo.ico' 1696 nil nil 1778 4097 1522 1 1554 #cutSelection 8 'Cu&t' 1 1 1602 nil true 1648 8 'EditCut.ico' 1696 nil nil 1522 1 1554 #copySelection 8 '&Copy' 1 1 1602 nil true 1648 8 'EditCopy.ico' 1696 nil nil 1522 1 1554 #pasteClipboard 8 '&Paste' 1 1 1602 nil true 1648 8 'EditPaste.ico' 1696 nil nil 1522 1 1554 #clearSelection 8 'De&lete' 1 1 1602 nil true 1648 8 'EditClear.ico' 1696 nil nil 1778 4097 1522 1 1554 #reformatSource 8 'Re&format' 1 1 nil nil nil 1778 4097 1522 1 1554 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1474 nil true 34 10 1522 1 1554 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 1522 1 1554 #cloneNew 8 '&Clone' 1 1 1602 nil true 1648 8 'SmalltalkWorkspace.ico' 1696 nil nil 1778 4097 1522 1 1554 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1522 1 1554 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1522 1 1554 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1522 1 1554 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 1522 1 1554 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1522 1 1554 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1522 1 1554 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 1778 4097 1522 1 1554 #browseIt 8 'Bro&wse It' 1 1 1602 nil true 1648 8 'ClassBrowserShell.ico' 1696 nil nil 1522 1 1554 #displayIt 8 '&Display It' 1 1 1602 nil true 1648 8 'DisplayIt.ico' 1696 nil nil 1522 1 1554 #printIt 8 '&Print It' 1 1 1602 nil true 1648 8 'PrintIt.ico' 1696 nil nil 1522 1 1554 #evaluateIt 8 'E&valuate It' 1 1 1602 nil true 1648 8 'EvaluateIt.ico' 1696 nil nil 1522 1 1554 #inspectIt 8 '&Inspect It' 1 1 1602 nil true 1648 8 'InspectIt.ico' 1696 nil nil 1522 1 1554 #debugIt 8 'Deb&ug It' 1 1 1602 nil true 1648 8 'Debugger.ico' 1696 nil nil 1778 4097 1474 nil true 34 2 1522 2097153 1554 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1522 1 1554 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3200 nil 8 1504001512 852486 ##(Smalltalk.NullConverter) nil nil 9 68763169 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 1442 #gray 1442 #white 1 nil nil nil nil #callTip nil nil nil #normal 5378 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 976 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 3200 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 1442 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 5344 nil nil nil nil 16 nil 170 192 34 6 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 3200 1442 #blue 3 false #Warning nil nil nil nil nil nil #Error 5778 21 3200 1442 #red 3 false #Error nil nil nil nil nil nil #Notification 5778 17 3200 1442 #commonGreen 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 5378 1027 1442 #darkGoldenrod 1442 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 5378 1031 1442 #firebrick 1442 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 5378 1029 nil 1442 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 722 138 144 34 10 786 #createWindow: 34 1 834 866 8 #[4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 193 3232 nil 3200 786 #contextMenu: 34 1 3360 3200 786 #hoverTime: 8 #(500) 3200 786 #caretPeriod: 8 #(530) 3200 786 #wordWrap: 8 #(true) 3200 786 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 3200 1 3 nil nil 5 nil 6354 3 3200 1 nil nil 67108863 5 nil 6354 5 3200 1 nil nil nil 5 nil 3200 786 #tabWidth: 8 #(4) 3200 786 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 3200 786 #maxCompletionListHeight: 8 #(9) 3200 786 #edgeColumn: 8 #(1) 3200 1 8 #() 674 193 193 nil 33 1296 nil nil nil 170 192 34 4 1296 8 'aspects' 3200 8 'workspace' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1152 34 2 8 1140916738 1 6672 1362 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1424 nil nil 1 nil nil nil 6672 nil 8 1758664336 2642 0 nil 2674 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 6800 7 257 nil 2642 0 nil 2850 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 6864 7 257 nil 2272 nil nil nil nil nil #smallIcons nil nil nil nil nil 722 138 144 34 3 786 #createWindow: 34 1 834 866 8 #[0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 193 6704 8 '' 6672 786 #setSingleSelection: 8 #(1) 6672 786 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6672 3 8 #() 674 193 193 nil 27 722 138 144 34 1 786 #createWindow: 34 1 834 866 8 #[0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 193 1184 8 '' 1152 3 34 3 1296 3200 6672 674 193 193 nil 27 674 193 193 nil 27 )! !

!PropertyInspector class categoriesForMethods!
editButtonImageIndexFor:!public! !
ellipsisButtonIcon!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

