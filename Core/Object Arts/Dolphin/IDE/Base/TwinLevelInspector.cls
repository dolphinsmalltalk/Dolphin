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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 0 0 34 2 8 1149239296 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 7 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1409286144 131073 592 0 0 0 7 0 0 0 592 530 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 0 592 34 2 8 1140850688 1 736 0 482 8 4278190080 0 519 0 0 0 736 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 85 946 731 11 736 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 946 193 193 0 27 1 true 170 192 8 #() 0 834 138 144 34 1 898 #createAt:extent: 34 2 946 481 21 946 777 727 592 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 736 410 ##(Smalltalk.CardContainer) 34 16 0 592 34 2 8 1409286144 131073 1264 0 0 0 7 0 0 0 1264 655878 ##(Smalltalk.CardLayout) 138 144 34 2 706 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 0 1264 34 2 8 1140953421 1 1408 590662 2 ##(Smalltalk.ListModel) 138 144 1088 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 0 0 15 265030 4 ##(Smalltalk.Menu) 0 true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 1602 1 1634 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1602 1 1634 #browseIt 8 '&Browse It' 1 1 1682 0 true 1728 8 'ClassBrowserShell.ico' 1776 0 0 1858 4097 1602 1 1634 #copyAspect 8 '&Copy' 1 1 0 0 0 1602 1 1634 #pasteAspect 8 '&Paste <1d>' 1 1 0 0 0 1858 4097 1602 1 1634 #editAspect 8 '&Edit' 1 1 0 0 0 1602 1 1634 #nilAspect 8 'Set to &Nil' 1 1 0 0 0 1858 4097 1602 1 1634 #refresh 8 'Re&fresh' 1 1 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 1408 0 8 4294905883 459270 ##(Smalltalk.Message) #valueText 8 #() 0 1049926 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 0 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Property' 357 #left 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 3 1 2288 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 2464 7 257 0 2290 #<= 8 #() 0 0 1408 0 3 0 0 2402 8 'Value' 357 #left 2450 0 0 2482 2 1 2448 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 2624 7 257 0 2290 #<= 2576 0 0 1408 2450 0 0 2482 2 1 2448 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2720 7 257 0 3 0 0 2402 8 '' 41 #center 2290 #displayString 8 #() 2290 #<= 2848 0 0 1408 2450 0 0 2482 3 1 2448 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2880 7 257 0 1 0 0 #report 1088 0 359 946 129 129 8 #(nil) false 1050438 3 ##(Smalltalk.VirtualTreeModel) 0 1536 138 144 1088 0 0 2450 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 2992 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3008 2450 0 0 3058 1 83886083 2992 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3104 7 257 0 0 138 ##(Smalltalk.PluggableSet) 1088 138 ##(Smalltalk.PluggableSet) 1088 13 5 0 0 0 0 0 0 0 834 138 144 34 3 898 #createAt:extent: 34 2 946 9 9 946 761 665 1408 898 #contextMenu: 34 1 1568 1408 898 #text: 34 1 8 'Property' 1408 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 80 1 0 0] 8 #() 1056 0 2021 706 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 0 1264 34 2 8 1411453252 1 3440 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 482 8 4278190080 0 21 1554 0 true 34 17 1602 1 1634 #accept 8 '&Accept' 1 1 0 0 0 1858 4097 1554 0 true 34 9 1602 1 1634 #undo 8 '&Undo' 1 1 1682 0 true 1728 8 'EditUndo.ico' 1776 0 0 1858 4097 1602 1 1634 #cutSelection 8 'Cu&t' 1 1 1682 0 true 1728 8 'EditCut.ico' 1776 0 0 1602 1 1634 #copySelection 8 '&Copy' 1 1 1682 0 true 1728 8 'EditCopy.ico' 1776 0 0 1602 1 1634 #pasteClipboard 8 '&Paste' 1 1 1682 0 true 1728 8 'EditPaste.ico' 1776 0 0 1602 1 1634 #clearSelection 8 'De&lete' 1 1 1682 0 true 1728 8 'EditClear.ico' 1776 0 0 1602 1 1634 #reformatSource 8 'Re&format' 1 1 0 0 0 1858 4097 1602 1 1634 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 1602 1 1634 #clear 8 'Clea&r' 1 1 0 0 0 1858 4097 1602 1 1634 #browseIt 8 'Bro&wse It' 1 1 1682 0 true 1728 8 'ClassBrowserShell.ico' 1776 0 0 1602 1 1634 #displayIt 8 '&Display It' 1 1 1682 0 true 1728 8 'DisplayIt.ico' 1776 0 0 1602 1 1634 #evaluateIt 8 'E&valuate It' 1 1 1682 0 true 1728 8 'EvaluateIt.ico' 1776 0 0 1602 1 1634 #inspectIt 8 '&Inspect It' 1 1 1682 0 true 1728 8 'InspectIt.ico' 1776 0 0 1602 1 1634 #debugIt 8 'Deb&ug It' 1 1 1682 0 true 1728 8 'Debugger.ico' 1776 0 0 1858 4097 1602 1 1634 #chooseEvaluationPools 8 '&Pools...' 1 1 1682 0 true 1728 8 'SystemDictionary.ico' 1776 0 0 1602 1 1634 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 1858 4097 1554 0 true 34 2 1602 2097153 1634 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 1602 1 1634 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 1858 4097 1554 0 true 34 9 1602 1 1634 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 1602 1 1634 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 1602 1 1634 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 1602 1 1634 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 1602 1 1634 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 1602 1 1634 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 1602 1 1634 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 1858 4097 1554 0 true 34 2 1602 1 1634 2290 #language: 8 #(#container) 8 '&Smalltalk' 1 1 0 0 0 1602 1 1634 2290 #language: 8 #(#xml) 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 0 0 0 8 '&Options' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 3440 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 5794 33554471 1 0 0 0 0 #callTip 0 0 0 #normal 5762 1 0 0 1 0 0 0 0 #normal 0 0 0 34 40 5840 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 0 0 false 138 144 1088 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 3440 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 1088 0 170 176 1088 9215 0 0 0 0 5794 33554447 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 5728 0 0 0 0 3 0 170 192 34 6 #Notification 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 3440 33554437 11 false #Notification 0 0 0 0 0 0 #Warning 6194 19 3440 33554465 3 false #Warning 0 0 0 0 0 0 #Error 6194 21 3440 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 5762 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 5762 1027 6306 60239 6306 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 5762 1031 6306 335 6306 31317503 1 0 0 0 0 #Error 0 0 0 0 834 138 144 34 8 898 #createAt:extent: 34 2 946 9 9 946 761 665 3440 898 #contextMenu: 34 1 3600 3440 898 #modificationEventMask: 8 #(4607) 3440 898 #hoverTime: 8 #(500) 3440 898 #caretPeriod: 8 #(530) 3440 898 #wordWrap: 8 #(true) 3440 898 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 3440 1 3 0 0 5 0 6754 3 3440 1 0 0 67108863 5 0 6754 5 3440 1 0 0 0 5 0 3440 898 #tabWidth: 8 #(4) 3440 994 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 80 1 0 0] 8 #() 1056 0 29 1408 170 192 34 4 1408 8 'aspects' 3440 8 'workspace' 0 410 ##(Smalltalk.TabViewXP) 34 28 0 1264 34 2 8 1140916738 1 6960 1474 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) 0 1536 0 0 3 0 0 0 6960 0 8 4294903993 2450 0 0 2482 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7088 7 257 0 2450 0 0 3058 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7152 7 257 0 2352 0 0 0 0 0 #smallIcons 0 0 0 0 0 834 138 144 34 3 898 #createAt:extent: 34 2 946 1 1 946 777 727 6960 898 #basicSelectionsByIndex: 34 1 8 #(1) 6960 898 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 6960 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1056 0 27 834 138 144 34 1 898 #createAt:extent: 34 2 946 1 1 946 777 727 1264 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 1408 3440 6960 1056 0 27 1056 0 27 524806 ##(Smalltalk.Fraction) 1553 1227 410 ##(Smalltalk.ListView) 34 30 0 416 34 2 8 1409372236 1 7632 1474 138 144 1088 0 1536 0 0 7 0 0 0 7632 0 8 4294905883 2290 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 2352 0 0 0 946 129 129 787526 1 ##(Smalltalk.ImageManager) 170 176 1088 170 176 1088 482 8 4278190080 0 0 138 144 34 1 2402 8 'Column 1' 201 #left 2290 #displayString 7760 ##(Smalltalk.SortedCollection) 0 0 7632 0 1 0 0 #thumbnails 1088 946 193 193 131169 946 65 65 8 #(nil) 834 138 144 34 2 898 #createAt:extent: 34 2 946 21 21 946 451 727 7632 898 #text: 34 1 8 'Column 1' 7632 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 1056 0 27 7602 901 1227 false 170 192 34 4 592 8 'inspector' 7632 8 'contents' 590342 ##(Smalltalk.Rectangle) 946 21 21 946 21 21 834 138 144 34 2 898 #createAt:extent: 34 2 946 3839 21 946 1281 771 416 898 #text: 34 1 8 'Inspector' 416 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 139 1 0 0] 34 3 7632 410 ##(Smalltalk.Splitter) 34 12 0 416 34 2 8 1140850688 1 8576 0 482 8 4278190080 0 519 0 0 0 8576 834 138 144 34 1 898 #createAt:extent: 34 2 946 471 21 946 11 727 8576 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1056 0 27 592 1056 0 27 )!

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

