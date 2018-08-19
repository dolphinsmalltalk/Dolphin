"Filed out from Dolphin Smalltalk 7"!

AbstractPublishedAspectInspector subclass: #PropertyInspector
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PropertyInspector guid: (GUID fromString: '{35bdcf77-b398-4b3b-bd3a-9675f82870d6}')!
PropertyInspector comment: 'A new version of the Published Aspect Inspector that uses a more traditional hierarchical list pane to edit properties (published aspects) in situ. Doesn''t provide the PAI functionality of rendering separate displays of the aspect being aspected. Should be plug-compatible with retro uses of the PAI.

'!
!PropertyInspector categoriesForClass!Development!MVP-Resources-IDE Tools! !
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
!PropertyInspector categoriesFor: #createComponents!private! !
!PropertyInspector categoriesFor: #onAspectActioned!event handling!private! !
!PropertyInspector categoriesFor: #onAspectSelected!private! !
!PropertyInspector categoriesFor: #popupEditAspect!operations!public! !
!PropertyInspector categoriesFor: #selectAspect:!private! !
!PropertyInspector categoriesFor: #selectedAspectValueRect!private! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 576 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 674 9 9 nil 688 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 85 674 731 11 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 674 193 193 nil 27 1 true 170 192 8 #() nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 3839 21 674 731 341 416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 236 8 0 0 180 0 0 0] 34 2 576 410 ##(Smalltalk.CardContainer) 34 16 nil 416 34 2 8 1409286144 131073 1136 nil nil nil 5 nil nil nil 1136 655878 ##(Smalltalk.CardLayout) 138 144 34 2 546 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 1136 34 2 8 1140953421 1 1280 590662 2 ##(Smalltalk.ListModel) 138 144 960 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1522 1 1554 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1522 1 1554 #browseIt 8 '&Browse It' 1 1 1602 nil true 1648 8 'ClassBrowserShell.ico' 1696 nil nil 1778 4097 1522 1 1554 #copyAspect 8 '&Copy' 1 1 nil nil nil 1522 1 1554 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1778 4097 1522 1 1554 #editAspect 8 '&Edit' 1 1 nil nil nil 1522 1 1554 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1778 4097 1522 1 1554 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1280 nil 8 1895760912 459270 ##(Smalltalk.Message) #valueText 8 #() nil 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Property' 335 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 2208 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 2384 7 257 nil 2210 #<= 8 #() nil nil 1280 nil 3 nil nil 2322 8 'Value' 333 #left 2370 0 nil 2402 2 1 2368 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 2544 7 257 nil 2210 #<= 2496 nil nil 1280 2370 0 nil 2402 2 1 2368 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2640 7 257 nil 3 nil nil 2322 8 '' 41 #center 2210 #displayString 8 #() 2210 #<= 2768 nil nil 1280 2370 0 nil 2402 3 1 2368 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2800 7 257 nil 1 nil nil #report 960 nil 131431 674 129 129 34 4 nil nil 674 1 1 nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1408 138 144 960 nil nil 2370 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2928 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 2944 2370 0 nil 2994 1 83886083 2928 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3040 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 960 138 ##(Smalltalk.PluggableSet) 960 13 1 nil nil nil nil nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 674 9 9 674 715 281 1280 786 #contextMenu: 34 1 1488 1280 786 #text: 34 1 8 'Property' 1280 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 928 nil 2021 546 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 1136 34 2 8 1411453252 1 3376 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 21 1474 nil true 34 17 1522 1 1554 #accept 8 '&Accept' 1 1 nil nil nil 1778 4097 1474 nil true 34 9 1522 1 1554 #undo 8 '&Undo' 1 1 1602 nil true 1648 8 'EditUndo.ico' 1696 nil nil 1778 4097 1522 1 1554 #cutSelection 8 'Cu&t' 1 1 1602 nil true 1648 8 'EditCut.ico' 1696 nil nil 1522 1 1554 #copySelection 8 '&Copy' 1 1 1602 nil true 1648 8 'EditCopy.ico' 1696 nil nil 1522 1 1554 #pasteClipboard 8 '&Paste' 1 1 1602 nil true 1648 8 'EditPaste.ico' 1696 nil nil 1522 1 1554 #clearSelection 8 'De&lete' 1 1 1602 nil true 1648 8 'EditClear.ico' 1696 nil nil 1522 1 1554 #reformatSource 8 'Re&format' 1 1 nil nil nil 1778 4097 1522 1 1554 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1522 1 1554 #clear 8 'Clea&r' 1 1 nil nil nil 1778 4097 1522 1 1554 #browseIt 8 'Bro&wse It' 1 1 1602 nil true 1648 8 'ClassBrowserShell.ico' 1696 nil nil 1522 1 1554 #displayIt 8 '&Display It' 1 1 1602 nil true 1648 8 'DisplayIt.ico' 1696 nil nil 1522 1 1554 #evaluateIt 8 'E&valuate It' 1 1 1602 nil true 1648 8 'EvaluateIt.ico' 1696 nil nil 1522 1 1554 #inspectIt 8 '&Inspect It' 1 1 1602 nil true 1648 8 'InspectIt.ico' 1696 nil nil 1522 1 1554 #debugIt 8 'Deb&ug It' 1 1 1602 nil true 1648 8 'Debugger.ico' 1696 nil nil 1778 4097 1522 1 1554 #chooseEvaluationPools 8 '&Pools...' 1 1 1602 nil true 1648 8 'SystemDictionary.ico' 1696 nil nil 1522 1 1554 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 1778 4097 1474 nil true 34 2 1522 2097153 1554 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1522 1 1554 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 1778 4097 1474 nil true 34 9 1522 1 1554 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1522 1 1554 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1522 1 1554 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 1522 1 1554 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1522 1 1554 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1522 1 1554 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1522 1 1554 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 1778 4097 1474 nil true 34 2 1522 1 1554 2210 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 1522 1 1554 2210 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3376 nil 8 1826147945 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 5698 77 786694 ##(Smalltalk.IndexedColor) 33554457 5746 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 5712 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 960 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 3376 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 960 nil 170 176 960 9215 nil nil nil nil 5746 33554447 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 5664 nil nil nil nil 3 nil 170 192 34 6 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 3376 33554465 3 false #Warning nil nil nil nil nil nil #Error 6130 21 3376 33554459 3 false #Error nil nil nil nil nil nil #Notification 6130 17 3376 33554437 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 5698 1027 196934 1 ##(Smalltalk.RGB) 60239 6242 31326207 1 nil nil nil nil #Warning nil nil nil #Error 5698 1031 6242 335 6242 31317503 1 nil nil nil nil #Error nil nil nil #Notification 5698 1029 nil 6242 31185883 1 nil nil nil nil #Notification nil nil nil nil 722 138 144 34 10 786 #createAt:extent: 34 2 674 9 9 674 715 281 3376 786 #contextMenu: 34 1 3536 3376 786 #textLimit: 8 #(1073741823) 3376 786 #modificationEventMask: 8 #(4607) 3376 786 #hoverTime: 8 #(500) 3376 786 #caretPeriod: 8 #(530) 3376 786 #wordWrap: 8 #(true) 3376 786 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 3376 1 3 nil nil 5 nil 6722 3 3376 1 nil nil 67108863 5 nil 6722 5 3376 1 nil nil nil 5 nil 3376 786 #tabWidth: 8 #(4) 3376 786 #maxCompletionListHeight: 8 #(9) 3376 866 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 105 1 0 0 144 0 0 0] 8 #() 928 nil 29 1280 170 192 34 4 3376 8 'workspace' 1280 8 'aspects' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1136 34 2 8 1140916738 1 6960 1346 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1408 nil nil 1 nil nil nil 6960 nil 8 1895577520 2370 0 nil 2402 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7088 7 257 nil 2370 0 nil 2994 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7152 7 257 nil 2272 nil nil nil nil nil #smallIcons nil nil nil nil nil 722 138 144 34 3 786 #createAt:extent: 34 2 674 1 1 674 731 341 6960 786 #basicSelectionsByIndex: 34 1 8 #(1) 6960 786 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6960 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 8 #() 928 nil 27 722 138 144 34 1 786 #createAt:extent: 34 2 674 1 1 674 731 341 1136 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 109 1 0 0 170 0 0 0] 34 3 1280 3376 6960 928 nil 27 928 nil 27 )! !
!PropertyInspector class categoriesFor: #editButtonImageIndexFor:!public! !
!PropertyInspector class categoriesFor: #ellipsisButtonIcon!public! !
!PropertyInspector class categoriesFor: #initialize!initializing!private! !
!PropertyInspector class categoriesFor: #resource_Default_view!public!resources-views! !

