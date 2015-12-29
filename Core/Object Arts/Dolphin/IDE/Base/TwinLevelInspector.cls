"Filed out from Dolphin Smalltalk X6.2"!

Presenter subclass: #TwinLevelInspector
	instanceVariableNames: 'contentsPresenter inspectorPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TwinLevelInspector guid: (GUID fromString: '{DC9A61D9-617E-42A8-BB8A-A84102AE8002}')!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1149239296 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  234 240 98 4 410 432 98 15 0 416 98 2 8 1409286144 131073 608 0 0 0 7 0 0 0 608 546 202 8 ##(Smalltalk.Dictionary)  98 1 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.Splitter)  98 12 0 608 98 2 8 1140850688 1 768 0 498 8 4278190080 0 519 0 0 0 768 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 85 1010 731 11 768 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 98 0 1010 193 193 0 27 1 16 234 256 98 0 0 882 202 208 98 1 946 976 98 2 1010 481 21 1010 777 727 608 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 98 2 768 410 8 ##(Smalltalk.CardContainer)  98 16 0 608 98 2 8 1409286144 131073 1328 0 0 0 7 0 0 0 1328 655878 ##(Smalltalk.CardLayout)  202 208 98 2 738 8 ##(Smalltalk.PropertyInspector)  410 8 ##(Smalltalk.ListTreeView)  98 44 0 1328 98 2 8 1140953421 1 1504 590662 2 ##(Smalltalk.ListModel)  202 208 1152 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  0 0 15 265030 4 ##(Smalltalk.Menu)  0 16 98 12 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 1714 1 1746 8 #inspectReferences 8 'Inspect &References' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 1714 1 1746 8 #browseIt 8 '&Browse It' 1 1 1810 0 16 1856 8 'ClassBrowserShell.ico' 1904 0 0 2002 4097 1714 1 1746 8 #copyAspect 8 '&Copy' 1 1 0 0 0 1714 1 1746 8 #pasteAspect 8 '&Paste <1d>' 1 1 0 0 0 2002 4097 1714 1 1746 8 #editAspect 8 '&Edit' 1 1 0 0 0 1714 1 1746 8 #nilAspect 8 'Set to &Nil' 1 1 0 0 0 2002 4097 1714 1 1746 8 #refresh 8 'Re&fresh' 1 1 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 1504 0 8 4294905539 459270 ##(Smalltalk.Message)  8 #valueText 98 0 0 1049926 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Property' 357 8 #left 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  3 1 2528 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] 8 #aspectDescriptor 8 #displayString 2736 7 257 0 2530 8 #<= 98 0 0 0 1504 0 3 0 0 2658 8 'Value' 357 2704 2722 0 0 2754 2 1 2720 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] 8 #valueTextOnly 2944 7 257 0 2530 2880 2896 0 0 1504 2722 0 0 2754 2 1 2720 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] 8 #valueImage 3056 7 257 0 3 0 0 2658 8 '' 41 8 #center 2530 2848 98 0 2530 2880 3216 0 0 1504 2722 0 0 2754 3 1 2720 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] 1488 8 #editButtonImageIndexFor: 3248 7 257 0 1 0 0 8 #report 1152 0 359 1010 129 129 0 32 1050438 3 ##(Smalltalk.VirtualTreeModel)  0 1648 202 208 1152 0 0 2722 0 0 918822 ##(Smalltalk.CompiledMethod)  2 3 3376 8 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] 8 #childrenOf: 8 #notEmpty 17 257 3392 2722 0 0 3442 1 83886083 3376 8 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3536 7 257 0 0 202 8 ##(Smalltalk.PluggableSet)  1152 202 3616 1152 13 5 0 0 0 0 0 0 0 882 202 208 98 3 946 976 98 2 1010 9 9 1010 761 669 1504 946 8 #contextMenu: 98 1 1680 1504 946 8 #text: 98 1 8 'Property' 1504 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 82 1 0 0] 98 0 1120 0 2021 738 8 ##(Smalltalk.ValueWorkspace)  410 8 ##(Smalltalk.ScintillaView)  98 50 0 1328 98 2 8 1411453252 1 3952 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 498 8 4278190080 0 21 1666 0 16 98 17 1714 1 1746 8 #accept 8 '&Accept' 1 1 0 0 0 2002 4097 1666 0 16 98 9 1714 1 1746 8 #undo 8 '&Undo' 1 1 1810 0 16 1856 8 'EditUndo.ico' 1904 0 0 2002 4097 1714 1 1746 8 #cutSelection 8 'Cu&t' 1 1 1810 0 16 1856 8 'EditCut.ico' 1904 0 0 1714 1 1746 8 #copySelection 8 '&Copy' 1 1 1810 0 16 1856 8 'EditCopy.ico' 1904 0 0 1714 1 1746 8 #pasteClipboard 8 '&Paste' 1 1 1810 0 16 1856 8 'EditPaste.ico' 1904 0 0 1714 1 1746 8 #clearSelection 8 'De&lete' 1 1 1810 0 16 1856 8 'EditClear.ico' 1904 0 0 1714 1 1746 8 #reformatSource 8 'Re&format' 1 1 0 0 0 2002 4097 1714 1 1746 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 1714 1 1746 8 #clear 8 'Clea&r' 1 1 0 0 0 2002 4097 1714 1 1746 2064 8 'Bro&wse It' 1 1 1810 0 16 1856 8 'ClassBrowserShell.ico' 1904 0 0 1714 1 1746 8 #displayIt 8 '&Display It' 1 1 1810 0 16 1856 8 'DisplayIt.ico' 1904 0 0 1714 1 1746 8 #evaluateIt 8 'E&valuate It' 1 1 1810 0 16 1856 8 'EvaluateIt.ico' 1904 0 0 1714 1 1746 1776 8 '&Inspect It' 1 1 1810 0 16 1856 8 'InspectIt.ico' 1904 0 0 1714 1 1746 8 #debugIt 8 'Deb&ug It' 1 1 1810 0 16 1856 8 'Debugger.ico' 1904 0 0 2002 4097 1714 1 1746 8 #chooseEvaluationPools 8 '&Pools...' 1 1 1810 0 16 1856 8 'SystemDictionary.ico' 1904 0 0 1714 1 1746 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 2002 4097 1666 0 16 98 2 1714 2097153 1746 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 1714 1 1746 8 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 2002 4097 1666 0 16 98 9 1714 1 1746 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 1714 1 1746 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 1714 1 1746 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 1714 1 1746 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 1714 1 1746 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 1714 1 1746 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 1714 1 1746 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 2002 4097 1666 0 16 98 2 1714 1 1746 2530 8 #language: 98 1 8 #container 8 '&Smalltalk' 1 1 0 0 0 1714 1 1746 2530 6416 98 1 8 #xml 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 0 0 0 8 '&Options' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 3952 0 8 4294905535 852486 ##(Smalltalk.NullConverter)  0 0 9 0 234 256 98 4 8 #callTip 1182726 ##(Smalltalk.ScintillaTextStyle)  77 786694 ##(Smalltalk.IndexedColor)  33554457 6754 33554471 1 0 0 0 0 6704 0 0 0 8 #normal 6722 1 0 0 1 0 0 0 0 6800 0 0 0 98 40 6816 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler)  1 0 0 32 202 208 1152 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 6754 33554433 6784 3952 8 #circle 202 208 1152 0 63 9215 0 0 0 0 6754 33554447 0 0 65 0 0 234 256 98 6 8 #specialCharacter 8 '()[]<>' 8 #literalBytes 8 '[]' 8 #literalArray 8 '()' 8 '' 3 234 256 98 2 6448 6672 0 0 0 0 3 0 234 256 98 6 8 #Notification 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  17 3952 33554437 11 32 7248 0 8 #Error 7266 21 3952 33554459 3 32 7296 0 8 #Warning 7266 19 3952 33554465 3 32 7328 0 0 0 234 256 98 6 7248 6722 1029 0 196934 1 ##(Smalltalk.RGB)  31185883 1 0 0 0 0 7248 0 0 0 7296 6722 1031 7410 335 7410 31317503 1 0 0 0 0 7296 0 0 0 7328 6722 1027 7410 60239 7410 31326207 1 0 0 0 0 7328 0 0 0 0 882 202 208 98 14 946 976 98 2 1010 9 9 1010 761 669 3952 946 3776 98 1 4128 3952 946 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 3952 946 8 #isTextModified: 98 1 32 3952 946 8 #modificationEventMask: 98 1 9215 3952 946 8 #hoverTime: 98 1 1001 3952 946 8 #secondaryCaretForecolor: 98 1 7410 16711423 3952 946 8 #caretPeriod: 98 1 1061 3952 946 8 #wordWrap: 98 1 16 3952 946 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin)  1 3952 1 3 32 1 5 8130 3 3952 1 1 32 67108863 5 8130 5 3952 1 1 32 1 5 3952 946 8 #indentationGuides: 98 1 0 3952 946 8 #tabIndents: 98 1 16 3952 946 8 #tabWidth: 98 1 9 3952 946 8 #areAdditionalCaretsVisible: 98 1 16 3952 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 82 1 0 0] 98 0 1120 0 29 1504 234 256 98 4 1504 8 'aspects' 3952 8 'workspace' 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 1328 98 2 8 1140916738 1 8496 1586 202 208 98 2 1488 3936 0 1648 0 0 3 0 0 0 8496 0 8 4294904565 2722 0 0 2754 1 83886081 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:x | nil]' 1782343965 8640 7 257 0 2722 0 0 3442 2 3 8 ##(Smalltalk.IconicListAbstract)  8 #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] 8 #iconImageIndex 8720 7 257 0 2608 0 0 0 0 0 8 #smallIcons 0 0 0 0 0 882 202 208 98 3 946 976 98 2 1010 1 1 1010 777 727 8496 946 8 #basicSelectionsByIndex: 98 1 98 1 3 8496 946 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 8496 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 98 0 1120 0 27 882 202 208 98 1 946 976 98 2 1010 1 1 1010 777 727 1328 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 98 3 1504 3952 8496 1120 0 27 1120 0 27 524806 ##(Smalltalk.Fraction)  1553 1227 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1409372236 1 9296 1586 202 208 1152 0 1648 0 0 7 0 0 0 9296 0 8 4294905539 2530 2848 98 0 8752 2608 0 0 0 1010 129 129 787526 1 ##(Smalltalk.ImageManager)  234 240 1152 234 240 1152 498 8 4278190080 0 0 202 208 98 1 2658 8 'Column 1' 201 2704 2530 2848 9440 8 ##(Smalltalk.SortedCollection)  0 0 9296 0 1 0 0 8 #thumbnails 1152 1010 193 193 131169 1010 65 65 0 882 202 208 98 2 946 976 98 2 1010 21 21 1010 451 727 9296 946 3824 98 1 8 'Column 1' 9296 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 98 0 1120 0 27 9266 901 1227 32 234 256 98 4 9296 8 'contents' 608 8 'inspector' 590342 ##(Smalltalk.Rectangle)  1010 21 21 1010 21 21 882 202 208 98 2 946 976 98 2 1010 3359 21 1010 1281 771 416 946 3824 98 1 8 'Inspector' 416 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 15 9 0 0 139 1 0 0] 98 3 9296 410 784 98 12 0 416 98 2 8 1140850688 1 10272 0 498 8 4278190080 0 519 0 0 0 10272 882 202 208 98 1 946 976 98 2 1010 471 21 1010 11 727 10272 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 98 0 1120 0 27 608 1120 0 27 )!

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

