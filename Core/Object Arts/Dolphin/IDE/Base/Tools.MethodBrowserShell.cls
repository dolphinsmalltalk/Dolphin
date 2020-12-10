"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.MethodBrowserShell'
	instanceVariableNames: 'browserPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MethodBrowserShell guid: (Core.GUID fromString: '{87b4c6bf-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.MethodBrowserShell comment: 'MethodBrowserShell is a <SmalltalkToolShell> that implements a method browser tool in a top-level window. Note that this is really just a "shell" around the real functionality which is obtained by embedding a <MethodBrowser> presenter. 

Instance Variables:
	browserPresenter		<MethodBrowser> browsing the list of methods.


'!
!Tools.MethodBrowserShell categoriesForClass!MVP-Presenters! !
!Tools.MethodBrowserShell methodsFor!

browseMethodsIn: aBrowserEnvironment 
	self systemModel browseMethodsIn: aBrowserEnvironment!

browser
	"Answer the <MethodBrowser> held by the receiver"

	^browserPresenter!

canSaveMethod
	"In order to be able to save a method in a Method Browser there must be a single editable
	method selected. We can't save on no selection, because we don't have a class context to
	save into."

	^self hasEditableMethodSelected!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	browserPresenter := self add: self methodBrowserClass new name: 'browser'!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self browser.
	(self browser)
		when: #methodSelected
			send: #onMethodSelected
			to: self;
		when: #actionPerformed
			send: #browseIt
			to: self!

filter
	^self browser filter!

findDetails: aFindDetails 
	self browser findDetails: aFindDetails!

findSelector: aSymbol 
	self browser findSelector: aSymbol!

hasEditableMethodSelected
	^self selectedMethod ifNil: [false] ifNotNil: [:method | self isEditableMethod: method]!

hasEditableMethodsSelected
	^self browser hasMethodsSelected!

hasMethods
	^self browser hasMethods!

hasMethodSelected
	^self browser hasMethodSelected!

isEditableMethod: aCompiledMethod 
	^true!

method
	Notification deprecated.
	^self selectedMethod!

methods
	^self browser list!

methods: aBrowserEnvironment 
	self caption: aBrowserEnvironment label.
	self browser methods: aBrowserEnvironment!

onMethodSelected
	"Private - The browserPresenter has selected a method.
	Ensure that the browserPresenter selects the appropriate text."

	(self browser)
		findNextMatch;
		enableSource: self canSaveMethod!

onViewOpened
	"Received when the receiver's view is been connected. 
	Transfer the caption across to the view"

	super onViewOpened.
	(self view viewNamed: 'errors' ifNone: []) ifNotNil: [:item | item model: self statusModel].
	(self view viewNamed: 'modified' ifNone: []) 
		ifNotNil: [:item | item model: self browser modifiedModel].
	(self view viewNamed: 'version' ifNone: []) 
		ifNotNil: [:item | item model: browserPresenter versionModel]!

parseContext
	^self selectedMethod ifNotNil: [:method | method methodClass]!

recompileDiffs
	self systemModel recompileDiffs: self method!

saveNewMethod: aString 
	| method |
	method := self selectedMethod.
	self browser 
		saveMethod: aString
		in: method methodClass
		categories: method realCategories
		package: method owningPackage!

searchEnvironment: aBrowserEnvironment 
	browserPresenter searchEnvironment: aBrowserEnvironment!

selectedMethod
	"Answer the currently selected method, or nil if there is not exactly one selected."

	^self browser selectedMethod!

setInitialFocus
	browserPresenter hasMethodSelected 
		ifTrue: [browserPresenter setInitialFocus]
		ifFalse: [super setInitialFocus]!

statusModel
	^self browser errorModel!

statusText: aString
	self statusModel value: (aString isNil ifFalse: [Notification new messageText: aString])! !
!Tools.MethodBrowserShell categoriesFor: #browseMethodsIn:!public! !
!Tools.MethodBrowserShell categoriesFor: #browser!accessing!public! !
!Tools.MethodBrowserShell categoriesFor: #canSaveMethod!commands!private! !
!Tools.MethodBrowserShell categoriesFor: #createComponents!initializing!public! !
!Tools.MethodBrowserShell categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.MethodBrowserShell categoriesFor: #filter!accessing!public! !
!Tools.MethodBrowserShell categoriesFor: #findDetails:!accessing!public! !
!Tools.MethodBrowserShell categoriesFor: #findSelector:!public!searching! !
!Tools.MethodBrowserShell categoriesFor: #hasEditableMethodSelected!public!testing! !
!Tools.MethodBrowserShell categoriesFor: #hasEditableMethodsSelected!public!testing! !
!Tools.MethodBrowserShell categoriesFor: #hasMethods!browsing!public! !
!Tools.MethodBrowserShell categoriesFor: #hasMethodSelected!idb goodies!public!testing! !
!Tools.MethodBrowserShell categoriesFor: #isEditableMethod:!enquiries!public! !
!Tools.MethodBrowserShell categoriesFor: #method!accessing!public! !
!Tools.MethodBrowserShell categoriesFor: #methods!accessing!public! !
!Tools.MethodBrowserShell categoriesFor: #methods:!accessing!public! !
!Tools.MethodBrowserShell categoriesFor: #onMethodSelected!event handling!private! !
!Tools.MethodBrowserShell categoriesFor: #onViewOpened!event handling!public! !
!Tools.MethodBrowserShell categoriesFor: #parseContext!accessing!public! !
!Tools.MethodBrowserShell categoriesFor: #recompileDiffs!public! !
!Tools.MethodBrowserShell categoriesFor: #saveNewMethod:!helpers!private! !
!Tools.MethodBrowserShell categoriesFor: #searchEnvironment:!public! !
!Tools.MethodBrowserShell categoriesFor: #selectedMethod!accessing!public! !
!Tools.MethodBrowserShell categoriesFor: #setInitialFocus!operations!public! !
!Tools.MethodBrowserShell categoriesFor: #statusModel!event handling!public! !
!Tools.MethodBrowserShell categoriesFor: #statusText:!accessing!private! !

Tools.MethodBrowserShell methodProtocol: #methodBrowserHost attributes: #(#readOnly) selectors: #(#hasEditableMethodSelected #isEditableMethod: #parseContext #saveNewMethod:)!

!Tools.MethodBrowserShell class methodsFor!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironment 
	aCollectionOfBrowserEnvironment do: 
			[:each | 
			| browser |
			browser := self show.
			browser methods: each.
			browser]!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators , #(#(#renameIt 'F2'))!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Method Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^MethodBrowser icon!

initialize
	"private -- class-side initalisation.

		self initialize.
	"

	Smalltalk developmentSystem registerTool: self.
	self canUseIdeaSpace: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 517 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 10 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Smalltalk_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 63 1 882 553 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(UI.Toolbar) #resource_History_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1159 1 882 169 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 2 0 0 0 0 0 0 151 2 0 0 25 0 0 0] 976 992 nil 27 8 'historyTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(UI.Toolbar) #resource_Find_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1051 1 882 109 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 976 992 nil 27 8 'findTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1504 nil nil nil 7 nil nil nil 1504 738 ##(UI.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 615 1 882 437 51 1504 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 976 992 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1744 nil nil nil 7 nil nil nil 1744 738 ##(UI.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 63 51 1744 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 976 992 nil 27 8 'imageTools' 170 192 976 138 144 976 nil nil 1 nil 882 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1469 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 25 0 0 0] 34 5 1744 672 1504 1264 1024 992 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2224 nil nil nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 882 193 193 nil 2224 nil 8 1801004784 170 192 34 6 1050374 ##(UI.StatusBarItem) 1 45 2224 nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 6 1 2464 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 ##(Kernel.VariableBinding) #'Tools.SmalltalkSystem' ##(Tools.SmalltalkSystem) ##(Smalltalk) 1 #current #changedIcon #imageIndex #ifTrue: 2480 7 257 nil nil 8 'modified' 2434 1 561 2224 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'errors' 2434 1 -1 2224 nil 786950 ##(Core.Message) #displayString 8 #() 2466 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 2432 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 2720 7 257 nil nil 8 'version' 34 3 2448 2624 2656 1311750 ##(UI.StatusBarNullItem) 513 1 2224 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 543 882 1469 41 2224 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 15 1 0 0 222 2 0 0 35 1 0 0] 8 #() 992 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3008 nil nil nil 7 nil nil nil 3008 498 1 1 nil nil nil nil 410 ##(UI.ReferenceView) 34 14 nil 3008 34 2 8 1140850688 131073 3088 nil nil nil 519 nil nil nil 3088 738 ##(Tools.MethodBrowser) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1469 493 3088 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 246 0 0 0] 976 992 nil 27 170 192 34 2 3088 8 'browser' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1469 493 3008 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 222 2 0 0 15 1 0 0] 34 1 3088 992 nil 27 170 192 34 4 528 8 'toolbar' 2224 8 'statusbar' nil 658246 4 ##(UI.MenuBar) nil true 34 8 461638 4 ##(UI.Menu) nil true 34 8 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #fileNew 8 '&New Workspace' 9373 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3682 1 3714 #fileOpen 8 '&Open Workspace...' 9375 1 3762 nil true 3808 8 'OpenWorkspace.ico' 3856 nil nil 3682 1 3714 #fileFileIn 8 '&File In...' 1 1 3762 nil true 3808 8 'FileIn.ico' 3856 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3682 1 3714 #saveImage 8 'Sa&ve Image' 1 1 3762 nil true 3808 8 'Snapshot.ico' 3856 nil nil 3682 1 3714 #smalltalkExit 8 'E&xit Dolphin' 1 1 3762 nil true 3808 8 'PowerSwitch.ico' 3856 nil nil 4050 4097 3682 1 3714 #exit 8 '&Close' 17639 1 1378630 1 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 47181 nil nil 3634 nil true 34 13 3682 1 3714 #undo 8 '&Undo' 9397 1 3762 nil true 3808 8 'EditUndo.ico' 3856 nil nil 4050 4097 3682 1 3714 #cutSelection 8 'Cu&t' 9393 1 3762 nil true 3808 8 'EditCut.ico' 3856 nil nil 3682 1 3714 #copySelection 8 '&Copy' 9351 1 3762 nil true 3808 8 'EditCopy.ico' 3856 nil nil 3682 1 3714 #pasteClipboard 8 '&Paste' 9389 1 3762 nil true 3808 8 'EditPaste.ico' 3856 nil nil 3682 1 3714 #editDelete 8 '&Delete' 1 1 3762 nil true 3808 8 'EditClear.ico' 3856 nil nil 3634 nil true 34 2 3682 1 3714 #reformatSource 8 '&Source' 9391 1 nil nil nil 3682 1 3714 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 47197 nil nil 4050 4097 3682 1 3714 #selectAll 8 'Select &All' 9347 1 nil nil nil 4050 4097 3682 1 3714 #editFind 8 '&Find...' 9357 1 3762 nil true 3808 47 983302 ##(OS.ShellLibrary) nil nil 3682 1 3714 #findNext 8 'Find &Next' 1253 1 3762 nil true 3808 8 'FindNext.ico' 3856 nil nil 3682 1 3714 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 47207 nil nil 3634 nil true 34 17 3682 1 3714 #browseIt 8 '&Browse It' 9349 1 3762 nil true 3808 8 'ClassBrowserShell.ico' 3856 nil nil 3682 1 3714 #displayIt 8 '&Display It' 9353 1 3762 nil true 3808 8 'DisplayIt.ico' 3856 nil nil 3682 1 3714 #printIt 8 '&Print It' 9377 1 3762 nil true 3808 8 'PrintIt.ico' 3856 nil nil 3682 1 3714 #evaluateIt 8 '&Evaluate It' 9355 1 3762 nil true 3808 8 'EvaluateIt.ico' 3856 nil nil 3682 1 3714 #inspectIt 8 '&Inspect It' 9363 1 3762 nil true 3808 8 'InspectIt.ico' 3856 nil nil 3682 1 3714 #debugIt 8 'Deb&ug It' 1269 1 3762 nil true 3808 8 'Debugger.ico' 3856 nil nil 3682 1 3714 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 4050 4097 3682 1 3714 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3682 1 3714 #browseReferences 8 '&References' 5367 1 nil nil nil 4050 4097 3682 2097153 3714 #accept 8 '&Accept' 9383 1 nil nil nil 3682 1 3714 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 4050 4097 3634 nil true 34 14 3682 1 3714 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 4050 4097 3682 1 3714 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 3682 1 3714 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 3682 1 3714 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 3682 1 3714 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 4050 4097 3682 1 3714 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3682 1 3714 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3682 1 3714 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 4050 4097 3682 1 3714 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 3682 1 3714 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3682 1 3714 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 3762 nil true 3808 8 'Refactoring.ico' 3856 nil 47253 nil nil 4050 4097 3634 nil true 34 7 3682 1 3714 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3682 1 3714 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3682 1 3714 #toggleLineEndings 8 'Line &Endings' 1 1 4306 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3682 1 3714 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3682 1 3714 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3682 1 3714 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3682 1 3714 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 3762 nil true 3808 8 'Preferences.ico' 3856 nil 47269 nil nil 8 '&Workspace' nil 134217729 nil nil 47271 nil nil 3634 nil true 34 11 3634 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 47273 nil nil 3634 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 47275 nil nil 3634 nil true 34 10 3682 1 3714 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 3682 1 3714 #browseContainingText 8 'C&ontaining Text...' 1 1 3762 nil true 3808 8 'SearchText.ico' 3856 nil nil 3682 1 3714 #browseMethodCategory 8 'Cate&gory...' 1 1 3762 nil true 3808 8 'Category.ico' 3856 nil nil 3682 1 3714 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 4050 4097 3682 1 3714 #browseMethodPackages 8 'Package <s>' 1 1 3762 nil true 3808 8 'Package.ico' 3856 nil nil 3682 1 3714 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 4050 4097 3682 1 3714 #browseMethodHistory 8 '&Change History' 1 1 3762 nil true 3808 8 'MethodHistory.ico' 3856 nil nil 3682 1 3714 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 47293 nil nil 4050 4097 3682 1 3714 #removeMethod 8 '&Delete' 1 1 3762 nil true 3808 8 'EditClear.ico' 3856 nil nil 3634 nil true 34 17 3682 1 3714 #renameMethod 8 'Re&name' 1 1 nil nil nil 3682 1 3714 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 3682 1 3714 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 4050 4097 3682 1 3714 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 3634 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 47305 nil nil 3634 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 47307 nil nil 3634 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 47309 nil nil 4050 4097 3634 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 47311 nil nil 3634 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 47313 nil nil 4050 4097 3682 1 3714 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3682 1 3714 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3682 1 3714 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3682 1 3714 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3682 1 3714 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 3762 nil true 3808 8 'Refactoring.ico' 3856 nil 47325 nil nil 4050 4097 3682 1 3714 #methodPackage 8 '&Package...' 1 1 3762 nil true 3808 8 'Package.ico' 3856 nil nil 3634 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 47329 nil nil 3634 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 47331 nil nil 3682 1 3714 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 47335 nil nil 3634 nil true 34 3 3682 1 3714 #undoChange 8 '&Undo <1d>' 1 1 3762 nil true 3808 8 'EditUndo.ico' 3856 nil nil 3682 1 3714 #redoChange 8 '&Redo <1d>' 1 1 3762 nil true 3808 8 'EditRedo.ico' 3856 nil nil 3682 1 3714 #clearChangeHistory 8 'Clear Change &History' 1 1 3762 nil true 3808 8 'MethodHistoryErase.ico' 3856 nil nil 8 'H&istory' nil 134217729 nil nil 47343 nil nil 3634 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 47345 nil nil 3634 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 47347 nil nil 3634 nil true 34 15 3682 1 3714 #helpContents 8 '&Contents' 1025 1 3762 nil true 3808 8 'Help.ico' 3856 nil nil 3682 1 3714 #help 8 'On this &Tool' 1249 1 nil nil nil 3682 1 3714 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4050 4097 3682 1 3714 #learnSmalltalk 8 'Learn Smalltalk' 1 1 4306 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 4050 4097 3682 1 3714 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3682 1 3714 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3682 1 3714 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4050 4097 3682 1 3714 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 3762 nil true 3808 8 '!!APPLICATION' 3856 nil nil 3682 1 3714 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3682 1 3714 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4050 4097 3682 1 3714 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4306 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 47371 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 6143 21 882 1501 701 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 237 14 0 0 104 1 0 0] 34 3 528 3008 2224 992 nil 27 )! !
!Tools.MethodBrowserShell class categoriesFor: #browseMethodsInEnvironments:!instance creation!public! !
!Tools.MethodBrowserShell class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.MethodBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!Tools.MethodBrowserShell class categoriesFor: #icon!constants!public! !
!Tools.MethodBrowserShell class categoriesFor: #initialize!initializing!private! !
!Tools.MethodBrowserShell class categoriesFor: #publishedAspects!public! !
!Tools.MethodBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !

