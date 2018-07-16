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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1149239296 131073 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1409286144 131073 592 nil nil nil 7 nil nil nil 592 530 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 592 34 2 8 1140850688 1 736 nil 482 8 4278190080 nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 736 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 866 9 9 nil 880 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 866 1 85 866 731 11 736 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 42 0 0 0 109 1 0 0 47 0 0 0] 8 #() 866 193 193 nil 27 1 true 170 192 8 #() nil 914 138 144 34 1 978 #createAt:extent: 34 2 866 481 21 866 777 727 592 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 240 0 0 0 10 0 0 0 116 2 0 0 117 1 0 0] 34 2 736 410 ##(Smalltalk.CardContainer) 34 16 nil 592 34 2 8 1409286144 131073 1328 nil nil nil 7 nil nil nil 1328 655878 ##(Smalltalk.CardLayout) 138 144 34 2 706 ##(Smalltalk.PropertyInspector) 410 ##(Smalltalk.ListTreeView) 34 44 nil 1328 34 2 8 1140953421 1 1472 590662 2 ##(Smalltalk.ListModel) 138 144 1152 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 15 265030 4 ##(Smalltalk.Menu) nil true 34 12 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #inspectIt 8 '&Inspect' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'BasicInspector.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1666 1 1698 #inspectReferences 8 'Inspect &References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 1666 1 1698 #browseIt 8 '&Browse It' 1 1 1746 nil true 1792 8 'ClassBrowserShell.ico' 1840 nil nil 1922 4097 1666 1 1698 #copyAspect 8 '&Copy' 1 1 nil nil nil 1666 1 1698 #pasteAspect 8 '&Paste <1d>' 1 1 nil nil nil 1922 4097 1666 1 1698 #editAspect 8 '&Edit' 1 1 nil nil nil 1666 1 1698 #nilAspect 8 'Set to &Nil' 1 1 nil nil nil 1922 4097 1666 1 1698 #refresh 8 'Re&fresh' 1 1 nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 1472 nil 8 1912800272 459270 ##(Smalltalk.Message) #valueText 8 #() nil 1050182 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Property' 357 #left 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 3 1 2352 8 'doIt' 8 '[:x | x aspectDescriptor displayString]' 8 #[31 105 226 0 159 106] #aspectDescriptor #displayString 2528 7 257 nil 2354 #<= 8 #() nil nil 1472 nil 3 nil nil 2466 8 'Value' 357 #left 2514 0 nil 2546 2 1 2512 8 'doIt' 8 '[:x | x valueTextOnly ]' 8 #[30 105 226 0 106] #valueTextOnly 2688 7 257 nil 2354 #<= 2640 nil nil 1472 2514 0 nil 2546 2 1 2512 8 'doIt' 8 '[:x | x valueImage ]' 8 #[30 105 226 0 106] #valueImage 2784 7 257 nil 3 nil nil 2466 8 '' 41 #center 2354 #displayString 8 #() 2354 #<= 2912 nil nil 1472 2514 0 nil 2546 3 1 2512 8 'doIt' 8 '[:x | PropertyInspector editButtonImageIndexFor: x ]' 8 #[31 105 29 17 177 106] ##(Smalltalk.PropertyInspector) #editButtonImageIndexFor: 2944 7 257 nil 1 nil nil #report 1152 nil 359 866 129 129 34 4 nil nil 866 1 1 nil false 1050438 3 ##(Smalltalk.VirtualTreeModel) nil 1600 138 144 1152 nil nil 2514 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3072 #defaultHasChildrenBlock 508791331 8 #[252 1 0 0 1 4 0 65 176 159 106 105] #childrenOf: #notEmpty 17 257 3088 2514 0 nil 3138 1 83886083 3072 #defaultFilterBlock 508773827 8 #[29 105 17 157 106] 3184 7 257 nil nil 138 ##(Smalltalk.PluggableSet) 1152 138 ##(Smalltalk.PluggableSet) 1152 13 5 nil nil nil nil nil nil nil 914 138 144 34 3 978 #createAt:extent: 34 2 866 9 9 866 761 667 1472 978 #contextMenu: 34 1 1632 1472 978 #text: 34 1 8 'Property' 1472 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1120 nil 2021 706 ##(Smalltalk.ValueWorkspace) 410 ##(Smalltalk.ScintillaView) 34 50 nil 1328 34 2 8 1411453252 1 3520 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 786950 ##(Smalltalk.DefaultColor) #smalltalkWorkspace nil 21 1618 nil true 34 17 1666 1 1698 #accept 8 '&Accept' 1 1 nil nil nil 1922 4097 1618 nil true 34 9 1666 1 1698 #undo 8 '&Undo' 1 1 1746 nil true 1792 8 'EditUndo.ico' 1840 nil nil 1922 4097 1666 1 1698 #cutSelection 8 'Cu&t' 1 1 1746 nil true 1792 8 'EditCut.ico' 1840 nil nil 1666 1 1698 #copySelection 8 '&Copy' 1 1 1746 nil true 1792 8 'EditCopy.ico' 1840 nil nil 1666 1 1698 #pasteClipboard 8 '&Paste' 1 1 1746 nil true 1792 8 'EditPaste.ico' 1840 nil nil 1666 1 1698 #clearSelection 8 'De&lete' 1 1 1746 nil true 1792 8 'EditClear.ico' 1840 nil nil 1666 1 1698 #reformatSource 8 'Re&format' 1 1 nil nil nil 1922 4097 1666 1 1698 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 1666 1 1698 #clear 8 'Clea&r' 1 1 nil nil nil 1922 4097 1666 1 1698 #browseIt 8 'Bro&wse It' 1 1 1746 nil true 1792 8 'ClassBrowserShell.ico' 1840 nil nil 1666 1 1698 #displayIt 8 '&Display It' 1 1 1746 nil true 1792 8 'DisplayIt.ico' 1840 nil nil 1666 1 1698 #evaluateIt 8 'E&valuate It' 1 1 1746 nil true 1792 8 'EvaluateIt.ico' 1840 nil nil 1666 1 1698 #inspectIt 8 '&Inspect It' 1 1 1746 nil true 1792 8 'InspectIt.ico' 1840 nil nil 1666 1 1698 #debugIt 8 'Deb&ug It' 1 1 1746 nil true 1792 8 'Debugger.ico' 1840 nil nil 1922 4097 1666 1 1698 #chooseEvaluationPools 8 '&Pools...' 1 1 1746 nil true 1792 8 'SystemDictionary.ico' 1840 nil nil 1666 1 1698 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 1922 4097 1618 nil true 34 2 1666 2097153 1698 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 1666 1 1698 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 1922 4097 1618 nil true 34 9 1666 1 1698 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 1666 1 1698 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 1666 1 1698 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 1666 1 1698 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 1666 1 1698 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 1666 1 1698 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 1666 1 1698 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 1922 4097 1618 nil true 34 2 1666 1 1698 2354 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 1666 1 1698 2354 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 3520 nil 8 1893518953 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 5842 77 786694 ##(Smalltalk.IndexedColor) 33554457 5890 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 5856 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 1152 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 3520 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1152 nil 170 176 1152 9215 nil nil nil nil 5890 33554447 nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 5808 nil nil nil nil 3 nil 170 192 34 6 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 19 3520 33554465 3 false #Warning nil nil nil nil nil nil #Error 6274 21 3520 33554459 3 false #Error nil nil nil nil nil nil #Notification 6274 17 3520 33554437 11 false #Notification nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 5842 1027 196934 1 ##(Smalltalk.RGB) 60239 6386 31326207 1 nil nil nil nil #Warning nil nil nil #Error 5842 1031 6386 335 6386 31317503 1 nil nil nil nil #Error nil nil nil #Notification 5842 1029 nil 6386 31185883 1 nil nil nil nil #Notification nil nil nil nil 914 138 144 34 10 978 #createAt:extent: 34 2 866 9 9 866 761 667 3520 978 #contextMenu: 34 1 3680 3520 978 #textLimit: 8 #(1073741823) 3520 978 #modificationEventMask: 8 #(4607) 3520 978 #hoverTime: 8 #(500) 3520 978 #caretPeriod: 8 #(530) 3520 978 #wordWrap: 8 #(true) 3520 978 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 3520 1 3 nil nil 5 nil 6866 3 3520 1 nil nil 67108863 5 nil 6866 5 3520 1 nil nil nil 5 nil 3520 978 #tabWidth: 8 #(4) 3520 978 #maxCompletionListHeight: 8 #(9) 3520 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 128 1 0 0 81 1 0 0] 8 #() 1120 nil 29 1472 170 192 34 4 3520 8 'workspace' 1472 8 'aspects' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 1328 34 2 8 1140916738 1 7104 1538 138 144 8 #(##(Smalltalk.PropertyInspector) ##(Smalltalk.ValueWorkspace)) nil 1600 nil nil 3 nil nil nil 7104 nil 8 1912616880 2514 0 nil 2546 1 83886081 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | nil]' 1782343965 7232 7 257 nil 2514 0 nil 3138 2 3 ##(Smalltalk.IconicListAbstract) #defaultGetImageBlock 579598755 8 #[30 105 226 0 106] #iconImageIndex 7296 7 257 nil 2416 nil nil nil nil nil #smallIcons nil nil nil nil nil 914 138 144 34 3 978 #createAt:extent: 34 2 866 1 1 866 777 727 7104 978 #basicSelectionsByIndex: 34 1 8 #(1) 7104 978 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7104 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 8 #() 1120 nil 27 914 138 144 34 1 978 #createAt:extent: 34 2 866 1 1 866 777 727 1328 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 132 1 0 0 107 1 0 0] 34 3 1472 3520 7104 1120 nil 27 1120 nil 27 524806 ##(Smalltalk.Fraction) 1553 1227 410 ##(Smalltalk.ListView) 34 30 nil 416 34 2 8 1409372236 1 7776 1538 138 144 1152 nil 1600 nil nil 7 nil nil nil 7776 nil 8 1912800272 2354 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 2416 nil nil nil 866 129 129 nil nil 138 144 34 1 2466 8 'Column 1' 201 #left 2354 #displayString 7904 ##(Smalltalk.SortedCollection) nil nil 7776 nil 1 nil nil #thumbnails 1152 866 193 193 131169 866 65 65 8 #(nil) 914 138 144 34 2 978 #createAt:extent: 34 2 866 21 21 866 451 727 7776 978 #text: 34 1 8 'Column 1' 7776 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 235 0 0 0 117 1 0 0] 8 #() 1120 nil 27 7746 901 1227 false 170 192 34 4 592 8 'inspector' 7776 8 'contents' 590342 ##(Smalltalk.Rectangle) 866 21 21 866 21 21 914 138 144 34 2 978 #createAt:extent: 34 2 866 3839 21 866 1281 771 416 978 #text: 34 1 8 'Inspector' 416 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 139 1 0 0] 34 3 7776 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 8624 nil 482 8 4278190080 nil 519 nil nil nil 834 8624 nil 1 #left nil nil nil 866 1 1 896 nil 8736 nil 914 138 144 34 1 978 #createAt:extent: 34 2 866 471 21 866 11 727 8624 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 235 0 0 0 10 0 0 0 240 0 0 0 117 1 0 0] 8 #() 1120 nil 27 592 1120 nil 27 )!

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

