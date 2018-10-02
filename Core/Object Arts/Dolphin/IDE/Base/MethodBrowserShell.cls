"Filed out from Dolphin Smalltalk 7"!

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
!MethodBrowserShell categoriesForClass!Development!MVP-Presenters! !
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
!MethodBrowserShell categoriesFor: #browseMethodsIn:!public! !
!MethodBrowserShell categoriesFor: #browser!accessing!public! !
!MethodBrowserShell categoriesFor: #canSaveMethod!commands!private! !
!MethodBrowserShell categoriesFor: #createComponents!initializing!public! !
!MethodBrowserShell categoriesFor: #createSchematicWiring!initializing!public! !
!MethodBrowserShell categoriesFor: #filter!accessing!public! !
!MethodBrowserShell categoriesFor: #findDetails:!accessing!public! !
!MethodBrowserShell categoriesFor: #findSelector:!public!searching! !
!MethodBrowserShell categoriesFor: #hasEditableMethodSelected!public!testing! !
!MethodBrowserShell categoriesFor: #hasEditableMethodsSelected!public!testing! !
!MethodBrowserShell categoriesFor: #hasMethods!browsing!public! !
!MethodBrowserShell categoriesFor: #hasMethodSelected!idb goodies!public!testing! !
!MethodBrowserShell categoriesFor: #isEditableMethod:!enquiries!public! !
!MethodBrowserShell categoriesFor: #method!accessing!public! !
!MethodBrowserShell categoriesFor: #methods!accessing!public! !
!MethodBrowserShell categoriesFor: #methods:!accessing!public! !
!MethodBrowserShell categoriesFor: #onMethodSelected!event handling!private! !
!MethodBrowserShell categoriesFor: #onViewOpened!event handling!public! !
!MethodBrowserShell categoriesFor: #parseContext!accessing!public! !
!MethodBrowserShell categoriesFor: #recompileDiffs!public! !
!MethodBrowserShell categoriesFor: #saveNewMethod:!helpers!private! !
!MethodBrowserShell categoriesFor: #searchEnvironment:!public! !
!MethodBrowserShell categoriesFor: #selectedMethod!accessing!public! !
!MethodBrowserShell categoriesFor: #setInitialFocus!operations!public! !
!MethodBrowserShell categoriesFor: #statusModel!event handling!public! !
!MethodBrowserShell categoriesFor: #statusText:!accessing!private! !

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
		add: (Aspect boolean: #reuseIfOpen);
		add: (Aspect boolean: #canUseIdeaSpace);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 517 nil nil nil 528 786694 ##(Smalltalk.ColorDefault) 8 4278190080 8 1915204752 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 688 nil nil nil 5 nil nil nil 688 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_History_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1159 1 898 169 51 688 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 2 0 0 0 0 0 0 151 2 0 0 25 0 0 0] 8 #() 898 193 193 nil 27 8 'historyTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 754 ##(Smalltalk.Toolbar) #resource_Find_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1051 1 898 109 51 1040 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 992 1008 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1280 nil nil nil 5 nil nil nil 1280 754 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 63 1 898 553 51 1280 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 992 1008 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1520 nil nil nil 5 nil nil nil 1520 754 ##(Smalltalk.Toolbar) #resource_Image_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 63 51 1520 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 992 1008 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1760 nil nil nil 5 nil nil nil 1760 754 ##(Smalltalk.Toolbar) #resource_Search_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 615 1 898 437 51 1760 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 992 1008 nil 27 8 'searchTools' 170 192 992 138 144 992 nil nil 1 nil 898 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 786 138 144 34 2 850 #createAt:extent: 34 2 898 1 1 898 1469 51 528 850 #updateSizePosted 992 528 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 25 0 0 0] 34 5 1520 1280 1760 1040 688 1008 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2256 nil nil nil 5 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 898 193 193 nil 2256 nil 8 1914952576 170 192 34 6 853766 ##(Smalltalk.StatusBarItem) 1 -1 2256 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2464 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 2560 7 257 nil nil 8 'version' 2466 1 561 2256 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 2466 1 45 2256 nil nil 2546 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2720 7 257 nil nil 8 'modified' 34 3 2704 2640 2480 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2256 nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 543 898 1469 41 2256 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 15 1 0 0 222 2 0 0 35 1 0 0] 8 #() 1008 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3072 nil nil nil 5 nil nil nil 3072 498 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3072 34 2 8 1140850688 131073 3152 nil nil nil 517 nil nil nil 3152 754 ##(Smalltalk.MethodBrowser) #resource_Default_view nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 1469 493 3152 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 246 0 0 0] 992 1008 nil 27 170 192 34 2 3152 8 'browser' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 51 898 1469 493 3072 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 222 2 0 0 15 1 0 0] 34 1 3152 1008 nil 27 170 192 34 4 528 8 'toolbar' 2256 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 8 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3746 1 3778 #fileOpen 8 '&Open Workspace...' 9375 1 3826 nil true 3872 8 'OpenWorkspace.ico' 3920 nil nil 3746 1 3778 #fileFileIn 8 '&File In...' 1 1 3826 nil true 3872 8 'FileIn.ico' 3920 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3746 1 3778 #saveImage 8 'Sa&ve Image' 1 1 3826 nil true 3872 8 'Snapshot.ico' 3920 nil nil 3746 1 3778 #smalltalkExit 8 'E&xit Dolphin' 1 1 3826 nil true 3872 8 'PowerSwitch.ico' 3920 nil nil 4114 4097 3746 1 3778 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 45669 nil nil 3698 nil true 34 13 3746 1 3778 #undo 8 '&Undo' 9397 1 3826 nil true 3872 8 'EditUndo.ico' 3920 nil nil 4114 4097 3746 1 3778 #cutSelection 8 'Cu&t' 9393 1 3826 nil true 3872 8 'EditCut.ico' 3920 nil nil 3746 1 3778 #copySelection 8 '&Copy' 9351 1 3826 nil true 3872 8 'EditCopy.ico' 3920 nil nil 3746 1 3778 #pasteClipboard 8 '&Paste' 9389 1 3826 nil true 3872 8 'EditPaste.ico' 3920 nil nil 3746 1 3778 #editDelete 8 '&Delete' 1 1 3826 nil true 3872 8 'EditClear.ico' 3920 nil nil 3698 nil true 34 2 3746 1 3778 #reformatSource 8 '&Source' 9391 1 nil nil nil 3746 1 3778 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 45685 nil nil 4114 4097 3746 1 3778 #selectAll 8 'Select &All' 9347 1 nil nil nil 4114 4097 3746 1 3778 #editFind 8 '&Find...' 9357 1 3826 nil true 3872 47 786694 ##(Smalltalk.ShellLibrary) nil nil 3746 1 3778 #findNext 8 'Find &Next' 1253 1 3826 nil true 3872 8 'FindNext.ico' 3920 nil nil 3746 1 3778 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 45695 nil nil 3698 nil true 34 16 3746 1 3778 #browseIt 8 '&Browse It' 9349 1 3826 nil true 3872 8 'ClassBrowserShell.ico' 3920 nil nil 3746 1 3778 #displayIt 8 '&Display It' 9353 1 3826 nil true 3872 8 'DisplayIt.ico' 3920 nil nil 3746 1 3778 #evaluateIt 8 '&Evaluate It' 9355 1 3826 nil true 3872 8 'EvaluateIt.ico' 3920 nil nil 3746 1 3778 #inspectIt 8 '&Inspect It' 9363 1 3826 nil true 3872 8 'InspectIt.ico' 3920 nil nil 3746 1 3778 #debugIt 8 'Deb&ug It' 1269 1 3826 nil true 3872 8 'Debugger.ico' 3920 nil nil 3746 1 3778 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 4114 4097 3746 1 3778 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3746 1 3778 #browseReferences 8 '&References' 5367 1 nil nil nil 4114 4097 3746 2097153 3778 #accept 8 '&Accept' 9383 1 nil nil nil 3746 1 3778 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 4114 4097 3698 nil true 34 14 3746 1 3778 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 4114 4097 3746 1 3778 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 3746 1 3778 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 3746 1 3778 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 3746 1 3778 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 4114 4097 3746 1 3778 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3746 1 3778 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3746 1 3778 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 4114 4097 3746 1 3778 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 3746 1 3778 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3746 1 3778 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 3826 nil true 3872 8 'Refactoring.ico' 3920 nil 45739 nil nil 4114 4097 3698 nil true 34 7 3746 1 3778 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3746 1 3778 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3746 1 3778 #toggleLineEndings 8 'Line &Endings' 1 1 4370 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3746 1 3778 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3746 1 3778 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3746 1 3778 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3746 1 3778 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 3826 nil true 3872 8 'Preferences.ico' 3920 nil 45755 nil nil 8 '&Workspace' nil 134217729 nil nil 45757 nil nil 3698 nil true 34 11 3698 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 45759 nil nil 3698 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 45761 nil nil 3698 nil true 34 10 3746 1 3778 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 3746 1 3778 #browseContainingText 8 'C&ontaining Text...' 1 1 3826 nil true 3872 8 'SearchText.ico' 3920 nil nil 3746 1 3778 #browseMethodCategory 8 'Cate&gory...' 1 1 3826 nil true 3872 8 'Category.ico' 3920 nil nil 3746 1 3778 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 4114 4097 3746 1 3778 #browseMethodPackages 8 'Package <s>' 1 1 3826 nil true 3872 8 'Package.ico' 3920 nil nil 3746 1 3778 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 4114 4097 3746 1 3778 #browseMethodHistory 8 '&Change History' 1 1 3826 nil true 3872 8 'MethodHistory.ico' 3920 nil nil 3746 1 3778 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 45779 nil nil 4114 4097 3746 1 3778 #removeMethod 8 '&Delete' 1 1 3826 nil true 3872 8 'EditClear.ico' 3920 nil nil 3698 nil true 34 17 3746 1 3778 #renameMethod 8 'Re&name' 1 1 nil nil nil 3746 1 3778 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 3746 1 3778 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 4114 4097 3746 1 3778 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 3698 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 45791 nil nil 3698 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 45793 nil nil 3698 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 45795 nil nil 4114 4097 3698 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 45797 nil nil 3698 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 45799 nil nil 4114 4097 3746 1 3778 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3746 1 3778 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3746 1 3778 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3746 1 3778 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3746 1 3778 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 3826 nil true 3872 8 'Refactoring.ico' 3920 nil 45811 nil nil 4114 4097 3746 1 3778 #methodPackage 8 '&Package...' 1 1 3826 nil true 3872 8 'Package.ico' 3920 nil nil 3698 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 45815 nil nil 3698 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 45817 nil nil 3746 1 3778 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 45821 nil nil 3698 nil true 34 3 3746 1 3778 #undoChange 8 '&Undo <1d>' 1 1 3826 nil true 3872 8 'EditUndo.ico' 3920 nil nil 3746 1 3778 #redoChange 8 '&Redo <1d>' 1 1 3826 nil true 3872 8 'EditRedo.ico' 3920 nil nil 3746 1 3778 #clearChangeHistory 8 'Clear Change &History' 1 1 3826 nil true 3872 8 'MethodHistoryErase.ico' 3920 nil nil 8 'H&istory' nil 134217729 nil nil 45829 nil nil 3698 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 45831 nil nil 3698 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 45833 nil nil 3698 nil true 34 15 3746 1 3778 #helpContents 8 '&Contents' 1025 1 3826 nil true 3872 8 'Help.ico' 3920 nil nil 3746 1 3778 #help 8 'On this &Tool' 1249 1 nil nil nil 3746 1 3778 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4114 4097 3746 1 3778 #learnSmalltalk 8 'Learn Smalltalk' 1 1 4370 $\x1F393 nil 262406 ##(Smalltalk.ARGB) 8 4292695180 9730 8 4294967295 nil nil 1 nil nil nil nil 4114 4097 3746 1 3778 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3746 1 3778 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3746 1 3778 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4114 4097 3746 1 3778 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 3826 nil true 3872 8 '!!APPLICATION' 3920 nil nil 3746 1 3778 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3746 1 3778 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4114 4097 3746 1 3778 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4370 $\x1F42C nil nil 196934 1 ##(Smalltalk.RGB) 17741887 nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 45857 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 786 138 144 34 2 850 #createAt:extent: 34 2 898 313 313 898 1501 701 416 850 #updateMenuBar 992 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 156 0 0 0 156 0 0 0 138 3 0 0 250 1 0 0] 34 3 528 3072 2256 1008 nil 27 )! !
!MethodBrowserShell class categoriesFor: #browseMethodsInEnvironments:!instance creation!public! !
!MethodBrowserShell class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!MethodBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!MethodBrowserShell class categoriesFor: #icon!constants!public! !
!MethodBrowserShell class categoriesFor: #initialize!initializing!private! !
!MethodBrowserShell class categoriesFor: #publishedAspects!development!public! !
!MethodBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !

