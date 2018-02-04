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

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1409372236 1 592 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 7 nil nil nil 592 nil 8 4294902479 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil 328198 ##(Smalltalk.Point) 129 129 787526 1 ##(Smalltalk.ImageManager) 170 176 704 170 176 704 482 8 4278190080 nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 770 #displayString 800 ##(Smalltalk.SortedCollection) nil nil 592 nil 1 nil nil #thumbnails 704 850 193 193 131169 850 65 65 8 #(nil) 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 850 21 21 850 451 727 592 1186 #text: 34 1 8 'Column 1' 592 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 850 193 193 nil 27 524806 ##(Smalltalk.Fraction) 901 1227 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 1424 nil nil nil 7 nil nil nil 1424 530 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 1424 34 2 8 1140850688 1 1568 nil 482 8 4278190080 nil 519 nil nil nil 1568 1122 138 144 34 1 1186 #createAt:extent: 34 2 850 1 85 850 731 11 1568 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 1376 nil 27 1 true 170 192 704 nil 1122 138 144 34 1 1186 #createAt:extent: 34 2 850 481 21 850 777 727 1424 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 1568 410 ##(Smalltalk.CardContainer) 34 16 nil 1424 34 2 8 1409286144 131073 2000 nil nil nil 7 nil nil nil 2000 655878 ##(Smalltalk.CardLayout) 138 144 34 2 1538 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 2000 34 2 8 1140953421 1 2144 658 138 144 704 nil 736 nil nil 13 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 2290 1 2322 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2290 1 2322 #browseIt 8 '&Browse It' 1 1 2370 nil true 2416 8 'ClassBrowserShell.ico' 2464 nil nil 2546 4097 2290 1 2322 #copyAspect 8 '&Copy' 1 1 nil nil nil 2290 1 2322 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 2546 4097 2290 1 2322 #editAspect 8 '&Edit' 1 1 nil nil nil 2290 1 2322 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 2546 4097 2290 1 2322 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 2144 nil 8 4294902479 770 #valueText 8 #() nil 832 nil nil nil nil nil nil 138 144 34 3 1010 8 'Property' 357 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 768 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 3088 7 257 nil 770 #<= 8 #() nil nil 2144 nil 3 nil nil 1010 8 'Value' 357 #left 3074 0 nil 3106 2 1 3072 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 3248 7 257 nil 770 #<= 3200 nil nil 2144 3074 0 nil 3106 2 1 3072 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 3344 7 257 nil 3 nil nil 1010 8 '' 41 #center 770 #displayString 8 #() 770 #<= 3472 nil nil 2144 3074 0 nil 3106 3 1 3072 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 3504 7 257 nil 1 nil nil #report 704 nil 359 850 129 129 8 #(nil) false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 736 138 144 704 nil nil 3074 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3616 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3632 3074 0 nil 3682 1 83886083 3616 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3728 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 704 138 ##(Smalltalk.PluggableSet) 704 13 5 nil nil nil nil nil nil nil 1122 138 144 34 3 1186 #createAt:extent: 34 2 850 9 9 850 761 665 2144 1186 #contextMenu: 34 1 2256 2144 1186 #text: 34 1 8 'Property' 2144 1314 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 80 1 0 0] 8 #() 1376 nil 2021 1538 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 2000 34 2 8 1411453252 1 4064 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 482 8 4278190080 nil 23 2242 nil true 34 17 2290 1 2322 #accept 8 '&Accept' 1 1 nil nil nil 2546 4097 2242 nil true 34 9 2290 1 2322 #undo 8 '&Undo' 1 1 2370 nil true 2416 8 'EditUndo.ico' 2464 nil nil 2546 4097 2290 1 2322 #cutSelection 8 'Cu&t' 1 1 2370 nil true 2416 8 'EditCut.ico' 2464 nil nil 2290 1 2322 #copySelection 8 '&Copy' 1 1 2370 nil true 2416 8 'EditCopy.ico' 2464 nil nil 2290 1 2322 #pasteClipboard 8 '&Paste' 1 1 2370 nil true 2416 8 'EditPaste.ico' 2464 nil nil 2290 1 2322 #clearSelection 8 'De&lete' 1 1 2370 nil true 2416 8 'EditClear.ico' 2464 nil nil 2290 1 2322 #reformatSource 8 'Re&format' 1 1 nil nil nil 2546 4097 2290 1 2322 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 2290 1 2322 #clear 8 'Clea&r' 1 1 nil nil nil 2546 4097 2290 1 2322 #browseIt 8 'Bro&wse It' 1 1 2370 nil true 2416 8 'ClassBrowserShell.ico' 2464 nil nil 2290 1 2322 #displayIt 8 '&Display It' 1 1 2370 nil true 2416 8 'DisplayIt.ico' 2464 nil nil 2290 1 2322 #evaluateIt 8 'E&valuate It' 1 1 2370 nil true 2416 8 'EvaluateIt.ico' 2464 nil nil 2290 1 2322 #inspectIt 8 '&Inspect It' 1 1 2370 nil true 2416 8 'InspectIt.ico' 2464 nil nil 2290 1 2322 #debugIt 8 'Deb&ug It' 1 1 2370 nil true 2416 8 'Debugger.ico' 2464 nil nil 2546 4097 2290 1 2322 #chooseEvaluationPools 8 '&Pools...' 1 1 2370 nil true 2416 8 'SystemDictionary.ico' 2464 nil nil 2290 1 2322 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 2546 4097 2242 nil true 34 2 2290 2097153 2322 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 2290 1 2322 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 2546 4097 2242 nil true 34 9 2290 1 2322 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 2290 1 2322 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 2290 1 2322 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 2290 1 2322 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 2290 1 2322 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 2290 1 2322 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 2290 1 2322 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 2546 4097 2242 nil true 34 2 2290 1 2322 770 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 2290 1 2322 770 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 4064 nil 8 4294907129 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 6418 33554471 1 nil nil nil nil #callTip nil nil nil #normal 6386 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 40 6464 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 704 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4064 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 704 nil 170 176 704 9215 nil nil nil nil 6418 33554447 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6352 nil nil nil nil 3 nil 170 192 34 6 #Notification 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 4064 33554437 11 false #Notification nil nil nil nil nil nil #Warning 6818 19 4064 33554465 3 false #Warning nil nil nil nil nil nil #Error 6818 21 4064 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 6386 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 6386 1027 6930 60239 6930 31326207 1 nil nil nil nil #Warning nil nil nil #Error 6386 1031 6930 335 6930 31317503 1 nil nil nil nil #Error nil nil nil nil 1122 138 144 34 10 1186 #createAt:extent: 34 2 850 9 9 850 761 665 4064 1186 #contextMenu: 34 1 4224 4064 1186 #modificationEventMask: 8 #(4607) 4064 1186 #hoverTime: 8 #(500) 4064 1186 #caretPeriod: 8 #(530) 4064 1186 #wordWrap: 8 #(true) 4064 1186 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 4064 1 3 nil nil 5 nil 7378 3 4064 1 nil nil 67108863 5 nil 7378 5 4064 1 nil nil nil 5 nil 4064 1186 #tabWidth: 8 #(4) 4064 1186 #maxCompletionListHeight: 8 #(9) 4064 1186 #sciSetCodePage: 8 #(65001) 4064 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 80 1 0 0] 8 #() 1376 nil 29 4064 170 192 34 4 4064 8 'workspace' 2144 8 'aspects' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 2000 34 2 8 1140916738 1 7648 658 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 736 nil nil 3 nil nil nil 7648 nil 8 4294907861 3074 0 nil 3106 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7776 7 257 nil 3074 0 nil 3682 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7840 7 257 nil 832 nil nil nil nil nil #smallIcons nil nil nil nil nil 1122 138 144 34 3 1186 #createAt:extent: 34 2 850 1 1 850 777 727 7648 1186 #basicSelectionsByIndex: 34 1 8 #(2) 7648 1186 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7648 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1376 nil 27 1122 138 144 34 1 1186 #createAt:extent: 34 2 850 1 1 850 777 727 2000 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 2144 4064 7648 1376 nil 27 1376 nil 27 1394 1553 1227 false 170 192 34 4 592 8 'contents' 1424 8 'inspector' 590342 ##(Smalltalk.Rectangle) 850 21 21 850 21 21 1122 138 144 34 2 1186 #createAt:extent: 34 2 850 3839 21 850 1281 771 416 1186 #text: 34 1 8 'Inspector' 416 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 139 1 0 0] 34 3 592 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8640 nil 482 8 4278190080 nil 519 nil nil nil 8640 1122 138 144 34 1 1186 #createAt:extent: 34 2 850 471 21 850 11 727 8640 1314 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1376 nil 27 1424 1376 nil 27 )!

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
!TwinLevelInspector class categoriesFor: #resource_Default_view!public!resources-views! !
!TwinLevelInspector class categoriesFor: #shellOn:caption:!instance creation!public! !

