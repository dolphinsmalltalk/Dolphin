"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #MethodBrowserShell
	instanceVariableNames: 'browserPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MethodBrowserShell guid: (GUID fromString: '{87b4c6bf-026e-11d3-9fd7-00a0cc3e4a32}')!

MethodBrowserShell comment: 'MethodBrowserShell is a <SmalltalkToolShell> that implements a method browser tool in a top-level window. Note that this is really just a "shell" around the real functionality which is obtained by embedding a <MethodBrowser> presenter. 

Instance Variables:
	browserPresenter		<MethodBrowser> browsing the list of methods.


'!

!MethodBrowserShell categoriesForClass!MVP-Presenters! !

!MethodBrowserShell methodsFor!

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

!MethodBrowserShell categoriesForMethods!
browseMethodsIn:!public! !
browser!accessing!public! !
canSaveMethod!commands!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
filter!accessing!public! !
findDetails:!accessing!public! !
findSelector:!public!searching! !
hasEditableMethodSelected!public!testing! !
hasEditableMethodsSelected!public!testing! !
hasMethods!browsing!public! !
hasMethodSelected!idb goodies!public!testing! !
isEditableMethod:!enquiries!public! !
method!accessing!public! !
methods!accessing!public! !
methods:!accessing!public! !
onMethodSelected!event handling!private! !
onViewOpened!event handling!public! !
parseContext!accessing!public! !
recompileDiffs!public! !
saveNewMethod:!helpers!private! !
searchEnvironment:!public! !
selectedMethod!accessing!public! !
setInitialFocus!operations!public! !
statusModel!event handling!public! !
statusText:!accessing!private! !
!

MethodBrowserShell methodProtocol: #methodBrowserHost attributes: #(#readOnly) selectors: #(#hasEditableMethodSelected #isEditableMethod: #parseContext #saveNewMethod:)!

!MethodBrowserShell class methodsFor!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironment 
	aCollectionOfBrowserEnvironment do: 
			[:each | 
			| browser |
			browser := self show.
			browser methods: each.
			browser]!

defaultAdditionalAccelerators
	^super defaultAdditionalAccelerators , #(#(#renameIt 'F2'))!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Method Browser'!

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

	^(super publishedAspects)
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1962208256 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 704 8 '' 672 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 738 ##(Smalltalk.Toolbar) #resource_History_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[65 2 0 0 0 0 0 0 149 2 0 0 25 0 0 0] 193 1072 8 '' 1040 3 976 994 193 193 nil 27 8 'historyTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1296 nil nil nil 7 nil nil nil 1296 738 ##(Smalltalk.Toolbar) #resource_Find_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[11 2 0 0 0 0 0 0 65 2 0 0 25 0 0 0] 193 1328 8 '' 1296 3 976 994 193 193 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1552 nil nil nil 7 nil nil nil 1552 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1584 8 '' 1552 3 976 994 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1808 nil nil nil 7 nil nil nil 1808 738 ##(Smalltalk.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1840 8 '' 1808 3 976 994 193 193 nil 27 8 'searchTools' nil nil nil 170 192 976 138 144 976 nil nil 9 1323 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 222 2 0 0 25 0 0 0] 193 560 8 '' 528 3 34 5 1552 672 1808 1296 1040 994 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140850956 1 2304 nil nil nil 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2304 nil 8 1961901280 170 192 34 6 853830 1 ##(Smalltalk.StatusBarItem) 8193 45 2304 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2544 7 257 nil nil 8 'modified' 2498 8193 561 2304 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' 2498 8193 -1 2304 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2530 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2496 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 2784 7 257 nil nil 8 'version' nil nil nil 34 3 2512 2688 2720 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2304 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 15 1 0 0 222 2 0 0 35 1 0 0] 193 2336 8 '' 2304 3 8 #() 994 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3088 nil nil nil 7 nil nil nil 3088 498 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3088 34 2 8 1140850688 131073 3168 nil nil nil 519 nil nil nil 3168 738 ##(Smalltalk.MethodBrowser) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 222 2 0 0 246 0 0 0] 193 3200 8 '' 3168 3 976 994 193 193 nil 27 170 192 34 2 3168 8 'browser' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 25 0 0 0 222 2 0 0 15 1 0 0] 193 3120 8 '' 3088 3 34 1 3168 994 193 193 nil 27 170 192 34 4 528 8 'toolbar' 2304 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 8 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3794 1 3826 #fileOpen 8 '&Open Workspace...' 9375 1 3874 nil true 3920 8 'OpenWorkspace.ico' 3968 nil nil 3794 1 3826 #fileFileIn 8 '&File In...' 1 1 3874 nil true 3920 8 'FileIn.ico' 3968 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3794 1 3826 #saveImage 8 'Sa&ve Image' 1 1 3874 nil true 3920 8 'Snapshot.ico' 3968 nil nil 3794 1 3826 #smalltalkExit 8 'E&xit Dolphin' 1 1 3874 nil true 3920 8 'PowerSwitch.ico' 3968 nil nil 4162 4097 3794 1 3826 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 11887 nil nil 3746 nil true 34 13 3794 1 3826 #undo 8 '&Undo' 9397 1 3874 nil true 3920 8 'EditUndo.ico' 3968 nil nil 4162 4097 3794 1 3826 #cutSelection 8 'Cu&t' 9393 1 3874 nil true 3920 8 'EditCut.ico' 3968 nil nil 3794 1 3826 #copySelection 8 '&Copy' 9351 1 3874 nil true 3920 8 'EditCopy.ico' 3968 nil nil 3794 1 3826 #pasteClipboard 8 '&Paste' 9389 1 3874 nil true 3920 8 'EditPaste.ico' 3968 nil nil 3794 1 3826 #editDelete 8 '&Delete' 1 1 3874 nil true 3920 8 'EditClear.ico' 3968 nil nil 3746 nil true 34 2 3794 1 3826 #reformatSource 8 '&Source' 9391 1 nil nil nil 3794 1 3826 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 11903 nil nil 4162 4097 3794 1 3826 #selectAll 8 'Select &All' 9347 1 nil nil nil 4162 4097 3794 1 3826 #editFind 8 '&Find...' 9357 1 3874 nil true 3920 47 786694 ##(Smalltalk.ShellLibrary) nil nil 3794 1 3826 #findNext 8 'Find &Next' 1253 1 3874 nil true 3920 8 'FindNext.ico' 3968 nil nil 3794 1 3826 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 11913 nil nil 3746 nil true 34 17 3794 1 3826 #browseIt 8 '&Browse It' 9349 1 3874 nil true 3920 8 'ClassBrowserShell.ico' 3968 nil nil 3794 1 3826 #displayIt 8 '&Display It' 9353 1 3874 nil true 3920 8 'DisplayIt.ico' 3968 nil nil 3794 1 3826 #printIt 8 '&Print It' 9377 1 3874 nil true 3920 8 'PrintIt.ico' 3968 nil nil 3794 1 3826 #evaluateIt 8 '&Evaluate It' 9355 1 3874 nil true 3920 8 'EvaluateIt.ico' 3968 nil nil 3794 1 3826 #inspectIt 8 '&Inspect It' 9363 1 3874 nil true 3920 8 'InspectIt.ico' 3968 nil nil 3794 1 3826 #debugIt 8 'Deb&ug It' 1269 1 3874 nil true 3920 8 'Debugger.ico' 3968 nil nil 3794 1 3826 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 4162 4097 3794 1 3826 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3794 1 3826 #browseReferences 8 '&References' 5367 1 nil nil nil 4162 4097 3794 2097153 3826 #accept 8 '&Accept' 9383 1 nil nil nil 3794 1 3826 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 4162 4097 3746 nil true 34 14 3794 1 3826 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 4162 4097 3794 1 3826 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 3794 1 3826 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 3794 1 3826 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 3794 1 3826 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 4162 4097 3794 1 3826 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3794 1 3826 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3794 1 3826 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 4162 4097 3794 1 3826 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 3794 1 3826 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3794 1 3826 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 3874 nil true 3920 8 'Refactoring.ico' 3968 nil 11959 nil nil 4162 4097 3746 nil true 34 7 3794 1 3826 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3794 1 3826 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3794 1 3826 #toggleLineEndings 8 'Line &Endings' 1 1 4418 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3794 1 3826 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3794 1 3826 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3794 1 3826 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3794 1 3826 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 3874 nil true 3920 8 'Preferences.ico' 3968 nil 11975 nil nil 8 '&Workspace' nil 134217729 nil nil 11977 nil nil 3746 nil true 34 11 3746 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 11979 nil nil 3746 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 11981 nil nil 3746 nil true 34 10 3794 1 3826 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 3794 1 3826 #browseContainingText 8 'C&ontaining Text...' 1 1 3874 nil true 3920 8 'SearchText.ico' 3968 nil nil 3794 1 3826 #browseMethodCategory 8 'Cate&gory...' 1 1 3874 nil true 3920 8 'Category.ico' 3968 nil nil 3794 1 3826 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 4162 4097 3794 1 3826 #browseMethodPackages 8 'Package <s>' 1 1 3874 nil true 3920 8 'Package.ico' 3968 nil nil 3794 1 3826 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 4162 4097 3794 1 3826 #browseMethodHistory 8 '&Change History' 1 1 3874 nil true 3920 8 'MethodHistory.ico' 3968 nil nil 3794 1 3826 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 11999 nil nil 4162 4097 3794 1 3826 #removeMethod 8 '&Delete' 1 1 3874 nil true 3920 8 'EditClear.ico' 3968 nil nil 3746 nil true 34 17 3794 1 3826 #renameMethod 8 'Re&name' 1 1 nil nil nil 3794 1 3826 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 3794 1 3826 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 4162 4097 3794 1 3826 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 3746 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 12011 nil nil 3746 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 12013 nil nil 3746 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 12015 nil nil 4162 4097 3746 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 12017 nil nil 3746 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 12019 nil nil 4162 4097 3794 1 3826 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3794 1 3826 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3794 1 3826 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3794 1 3826 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3794 1 3826 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 3874 nil true 3920 8 'Refactoring.ico' 3968 nil 12031 nil nil 4162 4097 3794 1 3826 #methodPackage 8 '&Package...' 1 1 3874 nil true 3920 8 'Package.ico' 3968 nil nil 3746 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 12035 nil nil 3746 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 12037 nil nil 3794 1 3826 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 12041 nil nil 3746 nil true 34 3 3794 1 3826 #undoChange 8 '&Undo <1d>' 1 1 3874 nil true 3920 8 'EditUndo.ico' 3968 nil nil 3794 1 3826 #redoChange 8 '&Redo <1d>' 1 1 3874 nil true 3920 8 'EditRedo.ico' 3968 nil nil 3794 1 3826 #clearChangeHistory 8 'Clear Change &History' 1 1 3874 nil true 3920 8 'MethodHistoryErase.ico' 3968 nil nil 8 'H&istory' nil 134217729 nil nil 12049 nil nil 3746 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 12051 nil nil 3746 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 12053 nil nil 3746 nil true 34 15 3794 1 3826 #helpContents 8 '&Contents' 1025 1 3874 nil true 3920 8 'Help.ico' 3968 nil nil 3794 1 3826 #help 8 'On this &Tool' 1249 1 nil nil nil 3794 1 3826 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4162 4097 3794 1 3826 #learnSmalltalk 8 'Learn Smalltalk' 1 1 4418 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 4162 4097 3794 1 3826 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3794 1 3826 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3794 1 3826 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4162 4097 3794 1 3826 #dolphinHomePage 8 'Dolphin Homepage' 1 1 3874 nil true 3920 8 '!!APPLICATION' 3968 nil nil 3794 1 3826 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3794 1 3826 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4162 4097 3794 1 3826 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4418 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 12077 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[255 9 0 0 10 0 0 0 237 12 0 0 104 1 0 0] 193 448 8 '' 416 1 34 3 528 3088 2304 994 193 193 nil 27 )! !

!MethodBrowserShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
defaultAdditionalAccelerators!constants!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
!

