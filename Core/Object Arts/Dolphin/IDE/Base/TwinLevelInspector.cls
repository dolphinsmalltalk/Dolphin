"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #TwinLevelInspector
	instanceVariableNames: 'contentsPresenter inspectorPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TwinLevelInspector guid: (GUID fromString: '{dc9a61d9-617e-42a8-bb8a-a84102ae8002}')!
TwinLevelInspector comment: ''!
!TwinLevelInspector categoriesForClass!MVP-Presenters! !
!TwinLevelInspector methodsFor!

aspectAccessor
	^self inspectorPresenter aspectAccessor!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	contentsPresenter := self add: ListPresenter new name: 'contents'.
	inspectorPresenter := self add: PropertyInspector new name: 'inspector'.
	inspectorPresenter
		isRootAspectVisible: false;
		isSingleLevelOnly: true!

createSchematicWiring
	super createSchematicWiring.
	contentsPresenter 
		when: #selectionChanged
		send: #onContentsSelectionChanged
		to: self!

inspectorPresenter
	^inspectorPresenter!

isRootAspectVisible: aBoolean 
	inspectorPresenter isRootAspectVisible: aBoolean!

model: aListModelOfObjects 
	super model: aListModelOfObjects.
	contentsPresenter model: aListModelOfObjects!

onContentsSelectionChanged
	inspectorPresenter value: contentsPresenter selectionOrNil!

selectionOrNil
	^contentsPresenter selectionOrNil!

selectionOrNil: anObject
	^contentsPresenter selectionOrNil: anObject! !
!TwinLevelInspector categoriesFor: #aspectAccessor!public! !
!TwinLevelInspector categoriesFor: #createComponents!private! !
!TwinLevelInspector categoriesFor: #createSchematicWiring!initializing!private! !
!TwinLevelInspector categoriesFor: #inspectorPresenter!public! !
!TwinLevelInspector categoriesFor: #isRootAspectVisible:!accessing!public! !
!TwinLevelInspector categoriesFor: #model:!public! !
!TwinLevelInspector categoriesFor: #onContentsSelectionChanged!private! !
!TwinLevelInspector categoriesFor: #selectionOrNil!public!selection! !
!TwinLevelInspector categoriesFor: #selectionOrNil:!public!selection! !

!TwinLevelInspector class methodsFor!

defaultModel
	^ListModel new!

icon
	"Answers an Icon that can be used to represent this class"

	^BasicInspector icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 7 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1409372236 1 592 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 7 nil nil nil 592 nil 8 1915211424 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 328198 ##(Smalltalk.Point) 129 129 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 770 #displayString 800 ##(Smalltalk.SortedCollection) nil nil 592 nil 1 nil nil #thumbnails 704 850 193 193 131169 850 65 65 8 #(nil) 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 850 21 21 850 451 727 592 1090 #text: 34 1 8 'Column 1' 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 850 193 193 nil 27 524806 ##(Smalltalk.Fraction) 901 1227 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 1328 nil nil nil 7 nil nil nil 1328 530 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 1328 34 2 8 1140850688 1 1472 nil 496 nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 1472 nil 1 #left nil nil nil 850 1 1 850 9 9 nil 1568 nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 850 1 85 850 731 11 1472 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1280 nil 27 1 true 170 192 704 nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 850 481 21 850 777 727 1328 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 1472 410 ##(Smalltalk.CardContainer) 34 16 nil 1328 34 2 8 1409286144 131073 1936 nil nil nil 7 nil nil nil 1936 655878 ##(Smalltalk.CardLayout) 138 144 34 2 1442 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 1936 34 2 8 1140953421 1 2080 658 138 144 704 nil 736 nil nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2226 1 2258 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2226 1 2258 #browseIt 8 '&Browse It' 1 1 2306 nil true 2352 8 'ClassBrowserShell.ico' 2400 nil nil 2482 4097 2226 1 2258 #copyAspect 8 '&Copy' 1 1 nil nil nil 2226 1 2258 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2482 4097 2226 1 2258 #editAspect 8 '&Edit' 1 1 nil nil nil 2226 1 2258 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 2482 4097 2226 1 2258 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 2080 nil 8 1915211424 770 #valueText 8 #() nil 832 nil nil nil nil nil nil 138 144 34 3 914 8 'Property' 357 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 768 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 3024 7 257 nil 770 #<= 8 #() nil nil 2080 nil 3 nil nil 914 8 'Value' 357 #left 3010 0 nil 3042 2 1 3008 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 3184 7 257 nil 770 #<= 3136 nil nil 2080 3010 0 nil 3042 2 1 3008 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 3280 7 257 nil 3 nil nil 914 8 '' 41 #center 770 #displayString 8 #() 770 #<= 3408 nil nil 2080 3010 0 nil 3042 3 1 3008 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 3440 7 257 nil 1 nil nil #report 704 nil 359 850 129 129 34 4 nil nil 850 1 1 nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 736 138 144 704 nil nil 3010 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3568 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3584 3010 0 nil 3634 1 83886083 3568 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3680 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 704 138 ##(Smalltalk.PluggableSet) 704 13 5 nil nil nil nil nil nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 850 9 9 850 761 667 2080 1090 #contextMenu: 34 1 2192 2080 1090 #text: 34 1 8 'Property' 2080 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1280 nil 2021 1442 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 1936 34 2 8 1411453252 1 4016 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 655878 ##(Smalltalk.ThemeColor) #smalltalkWorkspace nil 21 2178 nil true 34 17 2226 1 2258 #accept 8 '&Accept' 1 1 nil nil nil 2482 4097 2178 nil true 34 9 2226 1 2258 #undo 8 '&Undo' 1 1 2306 nil true 2352 8 'EditUndo.ico' 2400 nil nil 2482 4097 2226 1 2258 #cutSelection 8 'Cu&t' 1 1 2306 nil true 2352 8 'EditCut.ico' 2400 nil nil 2226 1 2258 #copySelection 8 '&Copy' 1 1 2306 nil true 2352 8 'EditCopy.ico' 2400 nil nil 2226 1 2258 #pasteClipboard 8 '&Paste' 1 1 2306 nil true 2352 8 'EditPaste.ico' 2400 nil nil 2226 1 2258 #clearSelection 8 'De&lete' 1 1 2306 nil true 2352 8 'EditClear.ico' 2400 nil nil 2226 1 2258 #reformatSource 8 'Re&format' 1 1 nil nil nil 2482 4097 2226 1 2258 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2226 1 2258 #clear 8 'Clea&r' 1 1 nil nil nil 2482 4097 2226 1 2258 #browseIt 8 'Bro&wse It' 1 1 2306 nil true 2352 8 'ClassBrowserShell.ico' 2400 nil nil 2226 1 2258 #displayIt 8 '&Display It' 1 1 2306 nil true 2352 8 'DisplayIt.ico' 2400 nil nil 2226 1 2258 #evaluateIt 8 'E&valuate It' 1 1 2306 nil true 2352 8 'EvaluateIt.ico' 2400 nil nil 2226 1 2258 #inspectIt 8 '&Inspect It' 1 1 2306 nil true 2352 8 'InspectIt.ico' 2400 nil nil 2226 1 2258 #debugIt 8 'Deb&ug It' 1 1 2306 nil true 2352 8 'Debugger.ico' 2400 nil nil 2482 4097 2226 1 2258 #chooseEvaluationPools 8 '&Pools...' 1 1 2306 nil true 2352 8 'SystemDictionary.ico' 2400 nil nil 2226 1 2258 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 2482 4097 2178 nil true 34 2 2226 2097153 2258 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 2226 1 2258 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 2482 4097 2178 nil true 34 9 2226 1 2258 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2226 1 2258 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2226 1 2258 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 2226 1 2258 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2226 1 2258 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2226 1 2258 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2226 1 2258 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 2482 4097 2178 nil true 34 2 2226 1 2258 770 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2226 1 2258 770 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 4016 nil 8 1825558121 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 6338 77 786694 ##(Smalltalk.IndexedColor) 33554457 6386 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 6352 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 704 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4016 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 704 nil 170 176 704 9215 nil nil nil nil 6386 33554447 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6304 nil nil nil nil 3 nil 170 192 34 6 #Notification 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 4016 33554437 11 false #Notification nil nil nil nil nil nil #Warning 6770 19 4016 33554465 3 false #Warning nil nil nil nil nil nil #Error 6770 21 4016 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 6338 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 6338 1027 6882 60239 6882 31326207 1 nil nil nil nil #Warning nil nil nil #Error 6338 1031 6882 335 6882 31317503 1 nil nil nil nil #Error nil nil nil nil 1026 138 144 34 10 1090 #createAt:extent: 34 2 850 9 9 850 761 667 4016 1090 #contextMenu: 34 1 4176 4016 1090 #textLimit: 8 #(1073741823) 4016 1090 #modificationEventMask: 8 #(4607) 4016 1090 #hoverTime: 8 #(500) 4016 1090 #caretPeriod: 8 #(530) 4016 1090 #wordWrap: 8 #(true) 4016 1090 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 4016 1 3 nil nil 5 nil 7362 3 4016 1 nil nil 67108863 5 nil 7362 5 4016 1 nil nil nil 5 nil 4016 1090 #tabWidth: 8 #(4) 4016 1090 #maxCompletionListHeight: 8 #(9) 4016 1218 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1280 nil 29 2080 170 192 34 4 4016 8 'workspace' 2080 8 'aspects' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1936 34 2 8 1140916738 1 7600 658 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 736 nil nil 3 nil nil nil 7600 nil 8 1915274640 3010 0 nil 3042 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7728 7 257 nil 3010 0 nil 3634 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7792 7 257 nil 832 nil nil nil nil nil #smallIcons nil nil nil nil nil 1026 138 144 34 3 1090 #createAt:extent: 34 2 850 1 1 850 777 727 7600 1090 #basicSelectionsByIndex: 34 1 8 #(1) 7600 1090 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7600 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1280 nil 27 1026 138 144 34 1 1090 #createAt:extent: 34 2 850 1 1 850 777 727 1936 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 2080 4016 7600 1280 nil 27 1280 nil 27 1298 1553 1227 false 170 192 34 4 592 8 'contents' 1328 8 'inspector' 590342 ##(Smalltalk.Rectangle) 850 21 21 850 21 21 1026 138 144 34 2 1090 #createAt:extent: 34 2 850 3839 21 850 1281 771 416 1090 #text: 34 1 8 'Inspector' 416 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 139 1 0 0] 34 3 592 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8592 nil 496 nil 519 nil nil nil 1538 8592 nil 1 #left nil nil nil 1568 1584 nil 1568 nil 1026 138 144 34 1 1090 #createAt:extent: 34 2 850 471 21 850 11 727 8592 1218 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1280 nil 27 1328 1280 nil 27 )!

shellOn: aListModelOfObjects caption: caption 
	"Open an Inspector shell displaying on anObject. 
	Answer the new Inspector."

	| inspector shell |
	shell := InspectorShell create.
	shell caption: caption.
	inspector := self createIn: shell on: aListModelOfObjects.
	inspector view arrangement: #center.
	shell view validateLayout.
	shell show setInitialFocus.
	^inspector! !
!TwinLevelInspector class categoriesFor: #defaultModel!public! !
!TwinLevelInspector class categoriesFor: #icon!constants!public! !
!TwinLevelInspector class categoriesFor: #resource_Default_view!public!resources-views! !
!TwinLevelInspector class categoriesFor: #shellOn:caption:!instance creation!public! !

