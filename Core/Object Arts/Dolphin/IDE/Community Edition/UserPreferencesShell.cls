"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #UserPreferencesShell
	instanceVariableNames: 'preferencesPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UserPreferencesShell guid: (GUID fromString: '{952571b1-f954-4626-bf12-bdd570b30a14}')!
UserPreferencesShell comment: ''!
!UserPreferencesShell categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!UserPreferencesShell methodsFor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	preferencesPresenter := self add: TwinLevelInspector new name: 'preferences'!

model: aListModelOfObjects 
	super model: aListModelOfObjects.
	preferencesPresenter model: aListModelOfObjects!

selectionOrNil: aClass 
	^preferencesPresenter selectionOrNil: aClass! !
!UserPreferencesShell categoriesFor: #createComponents!private! !
!UserPreferencesShell categoriesFor: #model:!public! !
!UserPreferencesShell categoriesFor: #selectionOrNil:!public! !

!UserPreferencesShell class methodsFor!

defaultModel
	^ListModel on: SmalltalkSystem current systemOptions !

displayOn: aStream 
	aStream nextPutAll: 'User Preferences'!

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

	| aspects |
	aspects := super publishedAspects.
	aspects add: (Aspect boolean: #reuseIfOpen).
	aspects add: (Aspect boolean: #canUseIdeaSpace).
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 5 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 5 nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 640 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 21 21 786 1409 813 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 896 34 2 8 1140850945 1 976 nil 786694 ##(Smalltalk.IndexedColor) 33554447 nil 5 nil nil nil 976 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 699 39 976 738 #text: 34 1 8 'System Options' 976 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 786 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 896 34 2 8 1409372236 1 1344 590662 2 ##(Smalltalk.ListModel) 138 144 640 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 5 nil nil nil 1344 nil 8 1915211424 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 786 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 1506 #displayString 1536 ##(Smalltalk.SortedCollection) nil nil 1344 nil 1 nil nil #thumbnails 640 786 193 193 131169 786 65 65 34 4 nil nil 786 1 1 nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 39 786 699 775 1344 738 #text: 34 1 8 'Column 1' 1344 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 1328 nil 27 170 192 34 2 1344 8 'contents' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 699 813 896 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 34 2 976 1344 1328 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 2176 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2176 nil 1 #left nil nil nil 786 1 1 786 9 9 nil 2272 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 699 1 786 11 813 2176 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 1328 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 2464 nil nil nil 5 nil nil nil 2464 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 2464 34 2 8 1140850945 1 2544 nil 1056 nil 5 nil nil nil 2544 nil 8 1915124368 1090 nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 701 39 2544 738 #text: 34 1 8 'Properties' 2544 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 1328 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2464 34 2 8 1409286144 131073 2848 nil nil nil 5 nil nil nil 2848 594 138 ##(Smalltalk.Dictionary) 640 true 170 192 640 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 39 786 701 775 2848 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 34 1 410 ##(Smalltalk.CardContainer) 34 16 nil 2848 34 2 8 1409286144 131073 3120 nil nil nil 5 nil nil nil 3120 655878 ##(Smalltalk.CardLayout) 138 144 34 2 721414 ##(Smalltalk.Association) ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 3120 34 2 8 1140953421 1 3280 1410 138 144 640 nil 1472 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3474 1 3506 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3474 1 3506 #browseIt 8 '&Browse It' 1 1 3554 nil true 3600 8 'ClassBrowserShell.ico' 3648 nil nil 3730 4097 3474 1 3506 #copyAspect 8 '&Copy' 1 1 nil nil nil 3474 1 3506 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 3730 4097 3474 1 3506 #editAspect 8 '&Edit' 1 1 nil nil nil 3474 1 3506 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 3730 4097 3474 1 3506 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3280 nil 8 1915211424 1506 #valueText 8 #() nil 1568 nil nil nil nil nil nil 138 144 34 3 1634 8 'Property' 319 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 1504 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4272 7 257 nil 1506 #<= 8 #() nil nil 3280 nil 3 nil nil 1634 8 'Value' 319 #left 4258 0 nil 4290 2 1 4256 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4432 7 257 nil 1506 #<= 4384 nil nil 3280 4258 0 nil 4290 2 1 4256 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 4528 7 257 nil 3 nil nil 1634 8 '' 41 #center 1506 #displayString 8 #() 1506 #<= 4656 nil nil 3280 4258 0 nil 4290 3 1 4256 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 4688 7 257 nil 1 nil nil #report 640 nil 131431 786 129 129 34 4 nil nil 786 1 1 nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1472 138 144 640 nil nil 4258 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 4816 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4832 4258 0 nil 4882 1 83886083 4816 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4928 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 640 138 ##(Smalltalk.PluggableSet) 640 1 1 nil nil nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 9 9 786 685 715 3280 738 #contextMenu: 34 1 3440 3280 738 #text: 34 1 8 'Property' 3280 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 2021 3250 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 3120 34 2 8 1411453252 1 5264 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 #smalltalkWorkspace nil 21 3426 nil true 34 17 3474 1 3506 #accept 8 '&Accept' 1 1 nil nil nil 3730 4097 3426 nil true 34 9 3474 1 3506 #undo 8 '&Undo' 1 1 3554 nil true 3600 8 'EditUndo.ico' 3648 nil nil 3730 4097 3474 1 3506 #cutSelection 8 'Cu&t' 1 1 3554 nil true 3600 8 'EditCut.ico' 3648 nil nil 3474 1 3506 #copySelection 8 '&Copy' 1 1 3554 nil true 3600 8 'EditCopy.ico' 3648 nil nil 3474 1 3506 #pasteClipboard 8 '&Paste' 1 1 3554 nil true 3600 8 'EditPaste.ico' 3648 nil nil 3474 1 3506 #clearSelection 8 'De&lete' 1 1 3554 nil true 3600 8 'EditClear.ico' 3648 nil nil 3474 1 3506 #reformatSource 8 'Re&format' 1 1 nil nil nil 3730 4097 3474 1 3506 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3474 1 3506 #clear 8 'Clea&r' 1 1 nil nil nil 3730 4097 3474 1 3506 #browseIt 8 'Bro&wse It' 1 1 3554 nil true 3600 8 'ClassBrowserShell.ico' 3648 nil nil 3474 1 3506 #displayIt 8 '&Display It' 1 1 3554 nil true 3600 8 'DisplayIt.ico' 3648 nil nil 3474 1 3506 #evaluateIt 8 'E&valuate It' 1 1 3554 nil true 3600 8 'EvaluateIt.ico' 3648 nil nil 3474 1 3506 #inspectIt 8 '&Inspect It' 1 1 3554 nil true 3600 8 'InspectIt.ico' 3648 nil nil 3474 1 3506 #debugIt 8 'Deb&ug It' 1 1 3554 nil true 3600 8 'Debugger.ico' 3648 nil nil 3730 4097 3474 1 3506 #chooseEvaluationPools 8 '&Pools...' 1 1 3554 nil true 3600 8 'SystemDictionary.ico' 3648 nil nil 3474 1 3506 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 3730 4097 3426 nil true 34 2 3474 2097153 3506 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 3474 1 3506 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 3730 4097 3426 nil true 34 9 3474 1 3506 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3474 1 3506 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3474 1 3506 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 3474 1 3506 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3474 1 3506 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3474 1 3506 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3474 1 3506 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 3730 4097 3426 nil true 34 2 3474 1 3506 1506 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 3474 1 3506 1506 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5264 nil 8 1825558121 1090 nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7554 77 1042 33554457 1042 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 7568 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 640 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 5264 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 640 nil 170 176 640 9215 nil nil nil nil 1056 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 7520 nil nil nil nil 3 nil 170 192 34 6 #Notification 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 5264 33554437 11 false #Notification nil nil nil nil nil nil #Warning 7954 19 5264 33554465 3 false #Warning nil nil nil nil nil nil #Error 7954 21 5264 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 7554 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 7554 1027 8066 60239 8066 31326207 1 nil nil nil nil #Warning nil nil nil #Error 7554 1031 8066 335 8066 31317503 1 nil nil nil nil #Error nil nil nil nil 674 138 144 34 10 738 #createAt:extent: 34 2 786 9 9 786 685 715 5264 738 #contextMenu: 34 1 5408 5264 738 #textLimit: 8 #(1073741823) 5264 738 #modificationEventMask: 8 #(4607) 5264 738 #hoverTime: 8 #(500) 5264 738 #caretPeriod: 8 #(530) 5264 738 #wordWrap: 8 #(true) 5264 738 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 5264 1 3 nil nil 5 nil 8546 3 5264 1 nil nil 67108863 5 nil 8546 5 5264 1 nil nil nil 5 nil 5264 738 #tabWidth: 8 #(4) 5264 738 #maxCompletionListHeight: 8 #(9) 5264 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 29 3280 170 192 34 4 3280 8 'aspects' 5264 8 'workspace' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3120 34 2 8 1140916738 1 8784 1410 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1472 nil nil 1 nil nil nil 8784 nil 8 1915274640 4258 0 nil 4290 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 8912 7 257 nil 4258 0 nil 4882 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 8976 7 257 nil 1568 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 1 786 701 775 8784 738 #basicSelectionsByIndex: 34 1 8 #(1) 8784 738 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8784 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 1328 nil 27 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 701 775 3120 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 34 3 3280 5264 8784 1328 nil 27 1328 nil 27 170 192 34 2 2848 8 'inspector' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 709 1 786 701 813 2464 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 34 2 2544 2848 1328 nil 27 1328 nil 27 170 192 34 2 528 8 'preferences' 590342 ##(Smalltalk.Rectangle) 786 21 21 786 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 209 209 786 1481 931 416 738 #text: 34 1 8 'User Preferences' 416 738 #updateMenuBar 640 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 104 0 0 0 104 0 0 0 76 3 0 0 57 2 0 0] 34 1 528 1328 nil 27 )!

toolsFolderHelpId
	^10580!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self! !
!UserPreferencesShell class categoriesFor: #defaultModel!public! !
!UserPreferencesShell class categoriesFor: #displayOn:!public! !
!UserPreferencesShell class categoriesFor: #icon!constants!public! !
!UserPreferencesShell class categoriesFor: #initialize!initializing!private! !
!UserPreferencesShell class categoriesFor: #publishedAspects!development!public! !
!UserPreferencesShell class categoriesFor: #resource_Default_view!public!resources-views! !
!UserPreferencesShell class categoriesFor: #toolsFolderHelpId!private! !
!UserPreferencesShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !

