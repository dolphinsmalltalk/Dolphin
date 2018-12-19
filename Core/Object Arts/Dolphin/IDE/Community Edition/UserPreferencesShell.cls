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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13369344 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 37 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1180166 ##(Smalltalk.ProportionalLayout) 170 176 8 #() false 170 192 640 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 21 21 786 1409 813 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 202 2 0 0 160 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 896 nil nil nil 7 nil nil nil 896 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 896 34 2 8 1140850945 1 976 nil 786694 ##(Smalltalk.IndexedColor) 33554447 nil 7 nil nil nil 976 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 699 39 976 738 #text: 34 1 8 'System Options' 976 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 19 0 0 0] 8 #() 786 193 193 nil 27 nil nil nil 410 ##(Smalltalk.ListView) 34 30 nil 896 34 2 8 1409372236 1 1344 590662 2 ##(Smalltalk.ListModel) 138 144 640 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 7 nil nil nil 1344 nil 8 1915211424 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 786 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 1506 #displayString 1536 1506 #<= 8 #() nil nil 1344 nil 1 nil nil #thumbnails 640 786 193 193 131169 786 65 65 34 4 nil nil 786 1 1 nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 39 786 699 775 1344 738 #text: 34 1 8 'Column 1' 1344 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 93 1 0 0 150 1 0 0] 8 #() 1328 nil 27 170 192 34 2 1344 8 'contents' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 699 813 896 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 93 1 0 0 150 1 0 0] 34 2 976 1344 1328 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 528 34 2 8 1140850688 1 2208 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 2208 nil 1 #left nil nil nil 786 1 1 786 9 9 nil 2304 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 699 1 786 11 813 2208 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 93 1 0 0 0 0 0 0 98 1 0 0 150 1 0 0] 8 #() 1328 nil 27 410 ##(Smalltalk.ContainerView) 34 15 nil 528 34 2 8 1140850688 131073 2496 nil nil nil 7 nil nil nil 2496 498 1 1 410 ##(Smalltalk.StaticText) 34 16 nil 2496 34 2 8 1140850945 1 2576 nil 1056 nil 7 nil nil nil 2576 nil 8 1915124368 1090 nil nil nil 674 138 144 34 2 738 #createAt:extent: 34 2 786 1 1 786 701 39 2576 738 #text: 34 1 8 'Properties' 2576 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 19 0 0 0] 8 #() 1328 nil 27 nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 2496 34 2 8 1409286144 131073 2880 nil nil nil 7 nil nil nil 2880 594 138 ##(Smalltalk.Dictionary) 640 true 170 192 640 nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 39 786 701 775 2880 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 19 0 0 0 94 1 0 0 150 1 0 0] 34 1 410 ##(Smalltalk.CardContainer) 34 16 nil 2880 34 2 8 1409286144 131073 3152 nil nil nil 7 nil nil nil 3152 655878 ##(Smalltalk.CardLayout) 138 144 34 2 721414 ##(Smalltalk.Association) ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 3152 34 2 8 1140953421 1 3312 1410 138 144 640 nil 1472 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3506 1 3538 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3506 1 3538 #browseIt 8 '&Browse It' 1 1 3586 nil true 3632 8 'ClassBrowserShell.ico' 3680 nil nil 3762 4097 3506 1 3538 #copyAspect 8 '&Copy' 1 1 nil nil nil 3506 1 3538 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 3762 4097 3506 1 3538 #editAspect 8 '&Edit' 1 1 nil nil nil 3506 1 3538 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 3762 4097 3506 1 3538 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3312 nil 8 1915211424 1506 #valueText 8 #() nil 1568 nil nil nil nil nil nil 138 144 34 3 1634 8 'Property' 319 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 1504 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 4304 7 257 nil 1506 #<= 8 #() nil nil 3312 nil 3 nil nil 1634 8 'Value' 319 #left 4290 0 nil 4322 2 1 4288 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 4464 7 257 nil 1506 #<= 4416 nil nil 3312 4290 0 nil 4322 2 1 4288 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 4560 7 257 nil 3 nil nil 1634 8 '' 41 #center 1506 #displayString 8 #() 1506 #<= 4688 nil nil 3312 4290 0 nil 4322 3 1 4288 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 4720 7 257 nil 1 nil nil #report 640 nil 131431 786 129 129 34 4 nil nil 786 1 1 nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1472 138 144 640 nil nil 4290 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 4848 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 4864 4290 0 nil 4914 1 83886083 4848 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 4960 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 640 138 ##(Smalltalk.PluggableSet) 640 1 1 nil nil nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 9 9 786 685 715 3312 738 #contextMenu: 34 1 3472 3312 738 #text: 34 1 8 'Property' 3312 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 2021 3282 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 3152 34 2 8 1411453252 1 5296 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 466 #smalltalkWorkspace nil 21 3458 nil true 34 17 3506 1 3538 #accept 8 '&Accept' 1 1 nil nil nil 3762 4097 3458 nil true 34 9 3506 1 3538 #undo 8 '&Undo' 1 1 3586 nil true 3632 8 'EditUndo.ico' 3680 nil nil 3762 4097 3506 1 3538 #cutSelection 8 'Cu&t' 1 1 3586 nil true 3632 8 'EditCut.ico' 3680 nil nil 3506 1 3538 #copySelection 8 '&Copy' 1 1 3586 nil true 3632 8 'EditCopy.ico' 3680 nil nil 3506 1 3538 #pasteClipboard 8 '&Paste' 1 1 3586 nil true 3632 8 'EditPaste.ico' 3680 nil nil 3506 1 3538 #clearSelection 8 'De&lete' 1 1 3586 nil true 3632 8 'EditClear.ico' 3680 nil nil 3506 1 3538 #reformatSource 8 'Re&format' 1 1 nil nil nil 3762 4097 3506 1 3538 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3506 1 3538 #clear 8 'Clea&r' 1 1 nil nil nil 3762 4097 3506 1 3538 #browseIt 8 'Bro&wse It' 1 1 3586 nil true 3632 8 'ClassBrowserShell.ico' 3680 nil nil 3506 1 3538 #displayIt 8 '&Display It' 1 1 3586 nil true 3632 8 'DisplayIt.ico' 3680 nil nil 3506 1 3538 #evaluateIt 8 'E&valuate It' 1 1 3586 nil true 3632 8 'EvaluateIt.ico' 3680 nil nil 3506 1 3538 #inspectIt 8 '&Inspect It' 1 1 3586 nil true 3632 8 'InspectIt.ico' 3680 nil nil 3506 1 3538 #debugIt 8 'Deb&ug It' 1 1 3586 nil true 3632 8 'Debugger.ico' 3680 nil nil 3762 4097 3506 1 3538 #chooseEvaluationPools 8 '&Pools...' 1 1 3586 nil true 3632 8 'SystemDictionary.ico' 3680 nil nil 3506 1 3538 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 3762 4097 3458 nil true 34 2 3506 2097153 3538 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 3506 1 3538 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 3762 4097 3458 nil true 34 9 3506 1 3538 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3506 1 3538 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3506 1 3538 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 3506 1 3538 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3506 1 3538 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3506 1 3538 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3506 1 3538 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 3762 4097 3458 nil true 34 2 3506 1 3538 1506 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 3506 1 3538 1506 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5296 nil 523476179 1090 nil nil 9 nil 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 1042 33554457 1042 33554471 1 nil nil nil nil #callTip nil nil nil #normal 7570 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 40 7632 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 640 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 5296 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 640 nil 170 176 640 9215 nil nil nil nil 1056 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' 8 '' 3 170 192 34 2 #container 7536 nil nil nil nil 3 nil 170 192 34 6 #Notification 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 5296 33554437 11 false #Notification nil nil nil nil nil nil #Warning 7970 19 5296 33554465 3 false #Warning nil nil nil nil nil nil #Error 7970 21 5296 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 7570 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 7570 1027 8082 60239 8082 31326207 1 nil nil nil nil #Warning nil nil nil #Error 7570 1031 8082 335 8082 31317503 1 nil nil nil nil #Error nil nil nil nil 674 138 144 34 10 738 #createAt:extent: 34 2 786 9 9 786 685 715 5296 738 #contextMenu: 34 1 5440 5296 738 #textLimit: 8 #(1073741823) 5296 738 #modificationEventMask: 8 #(4607) 5296 738 #hoverTime: 8 #(500) 5296 738 #caretPeriod: 8 #(530) 5296 738 #wordWrap: 8 #(true) 5296 738 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 5296 1 3 nil nil 5 nil 8562 3 5296 1 nil nil 67108863 5 nil 8562 5 5296 1 nil nil nil 5 nil 5296 738 #tabWidth: 8 #(4) 5296 738 #maxCompletionListHeight: 8 #(9) 5296 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 90 1 0 0 105 1 0 0] 8 #() 1328 nil 29 3312 170 192 34 4 3312 8 'aspects' 5296 8 'workspace' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 3152 34 2 8 1140916738 1 8800 1410 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1472 nil nil 1 nil nil nil 8800 nil 8 1915274640 4290 0 nil 4322 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 8928 7 257 nil 4290 0 nil 4914 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 8992 7 257 nil 1568 nil nil nil nil nil #smallIcons nil nil nil nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 1 1 786 701 775 8800 738 #basicSelectionsByIndex: 34 1 8 #(1) 8800 738 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8800 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 8 #() 1328 nil 27 674 138 144 34 1 738 #createAt:extent: 34 2 786 1 1 786 701 775 3152 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 94 1 0 0 131 1 0 0] 34 3 3312 5296 8800 1328 nil 27 1328 nil 27 170 192 34 2 2880 8 'inspector' nil 674 138 144 34 1 738 #createAt:extent: 34 2 786 709 1 786 701 813 2496 834 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 98 1 0 0 0 0 0 0 192 2 0 0 150 1 0 0] 34 2 2576 2880 1328 nil 27 1328 nil 27 170 192 34 2 528 8 'preferences' 590342 ##(Smalltalk.Rectangle) 786 21 21 786 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 674 138 144 34 3 738 #createAt:extent: 34 2 786 3839 21 786 1481 931 416 738 #text: 34 1 8 'User Preferences' 416 738 #updateMenuBar 640 416 834 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 99 10 0 0 219 1 0 0] 34 1 528 1328 nil 27 )!

toolsFolderHelpId
	^10580! !
!UserPreferencesShell class categoriesFor: #defaultModel!public! !
!UserPreferencesShell class categoriesFor: #displayOn:!public! !
!UserPreferencesShell class categoriesFor: #icon!constants!public! !
!UserPreferencesShell class categoriesFor: #initialize!initializing!private! !
!UserPreferencesShell class categoriesFor: #publishedAspects!public! !
!UserPreferencesShell class categoriesFor: #resource_Default_view!public!resources-views! !
!UserPreferencesShell class categoriesFor: #toolsFolderHelpId!private! !

