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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 528 524550 ##(Smalltalk.ColorRef) 8 4278190080 8 1912794480 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 800 nil nil nil 7 nil nil nil 800 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Search_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 661 1 674 433 51 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 34 2 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1136 nil nil nil 7 nil nil nil 1136 866 ##(Smalltalk.Toolbar) #resource_Image_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 63 51 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1088 1104 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1376 nil nil nil 7 nil nil nil 1376 866 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 63 1 674 599 51 1376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 1088 1104 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1616 nil nil nil 7 nil nil nil 1616 866 ##(Smalltalk.Toolbar) #resource_Find_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1093 1 674 111 49 1616 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 2 0 0 0 0 0 0 89 2 0 0 24 0 0 0] 1088 1104 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1856 nil nil nil 7 nil nil nil 1856 866 ##(Smalltalk.Toolbar) #resource_History_tools nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1203 1 674 169 51 1856 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 89 2 0 0 0 0 0 0 173 2 0 0 25 0 0 0] 1088 1104 nil 27 8 'historyTools' 170 192 1088 138 144 1088 170 176 1088 nil 1 nil 674 33 33 674 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 898 138 144 34 2 962 #createAt:extent: 34 2 674 1 1 674 1379 51 528 962 #updateSizePosted 1088 528 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 177 2 0 0 25 0 0 0] 34 5 1136 1376 800 1616 1856 1104 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2384 nil nil nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 674 193 193 nil 2384 nil 8 1912526784 170 192 34 6 853766 ##(Smalltalk.StatusBarItem) 1 45 2384 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2608 7 257 nil nil 8 'modified' 2562 1 561 2384 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 2562 1 -1 2384 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 2594 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 2560 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 2880 7 257 nil nil 8 'version' 34 3 2576 2752 2816 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2384 nil nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 503 674 1379 41 2384 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 251 0 0 0 177 2 0 0 15 1 0 0] 8 #() 1104 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3168 nil nil nil 7 nil nil nil 3168 498 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 3168 34 2 8 1140850688 131073 3248 nil nil nil 519 nil nil nil 3248 866 ##(Smalltalk.MethodBrowser) #resource_Default_view nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 1 674 1379 453 3248 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 177 2 0 0 226 0 0 0] 1088 1104 nil 27 170 192 34 2 3248 8 'browser' nil 898 138 144 34 1 962 #createAt:extent: 34 2 674 1 51 674 1379 453 3168 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 177 2 0 0 251 0 0 0] 34 1 3248 1104 nil 27 170 192 34 4 2384 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 8 265030 4 ##(Smalltalk.Menu) nil true 34 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileNew.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3842 1 3874 #fileOpen 8 '&Open...' 9375 1 3922 nil true 3968 8 'FileOpen.ico' 4016 nil nil 3842 1 3874 #fileFileIn 8 '&File In...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3842 1 3874 #saveImage 8 'Sa&ve Image' 1 1 3922 nil true 3968 8 'Snapshot.ico' 4016 nil nil 3842 1 3874 #smalltalkExit 8 'E&xit Dolphin' 1 1 3922 nil true 3968 8 'PowerSwitch.ico' 4016 nil nil 4178 4097 3842 1 3874 #exit 8 '&Close' 17639 1 3922 nil true 3968 8 'CloseWindow.ico' 4016 nil nil 8 '&File' nil 134217729 nil nil 30409 nil nil 3794 nil true 34 13 3842 1 3874 #undo 8 '&Undo' 9397 1 3922 nil true 3968 8 'EditUndo.ico' 4016 nil nil 4178 4097 3842 1 3874 #cutSelection 8 'Cu&t' 9393 1 3922 nil true 3968 8 'EditCut.ico' 4016 nil nil 3842 1 3874 #copySelection 8 '&Copy' 9351 1 3922 nil true 3968 8 'EditCopy.ico' 4016 nil nil 3842 1 3874 #pasteClipboard 8 '&Paste' 9389 1 3922 nil true 3968 8 'EditPaste.ico' 4016 nil nil 3842 1 3874 #editDelete 8 '&Delete' 1 1 3922 nil true 3968 8 'EditClear.ico' 4016 nil nil 3794 nil true 34 2 3842 1 3874 #reformatSource 8 '&Source' 9391 1 nil nil nil 3842 1 3874 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 30425 nil nil 4178 4097 3842 1 3874 #selectAll 8 'Select &All' 9347 1 nil nil nil 4178 4097 3842 1 3874 #editFind 8 '&Find...' 9357 1 3922 nil true 3968 47 786694 ##(Smalltalk.ShellLibrary) nil nil 3842 1 3874 #findNext 8 'Find &Next' 1253 1 3922 nil true 3968 8 'FindNext.ico' 4016 nil nil 3842 1 3874 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 30435 nil nil 3794 nil true 34 16 3842 1 3874 #browseIt 8 '&Browse It' 9349 1 3922 nil true 3968 8 'ClassBrowserShell.ico' 4016 nil nil 3842 1 3874 #displayIt 8 '&Display It' 9353 1 3922 nil true 3968 8 'DisplayIt.ico' 4016 nil nil 3842 1 3874 #evaluateIt 8 '&Evaluate It' 9355 1 3922 nil true 3968 8 'EvaluateIt.ico' 4016 nil nil 3842 1 3874 #inspectIt 8 '&Inspect It' 9363 1 3922 nil true 3968 8 'InspectIt.ico' 4016 nil nil 3842 1 3874 #debugIt 8 'Deb&ug It' 1269 1 3922 nil true 3968 8 'Debugger.ico' 4016 nil nil 3842 1 3874 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 4178 4097 3842 1 3874 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3842 1 3874 #browseReferences 8 '&References' 5367 1 nil nil nil 4178 4097 3842 2097153 3874 #accept 8 '&Accept' 9383 1 nil nil nil 3842 1 3874 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 4178 4097 3794 nil true 34 14 3842 1 3874 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 4178 4097 3842 1 3874 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 3842 1 3874 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 3842 1 3874 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 3842 1 3874 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 4178 4097 3842 1 3874 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3842 1 3874 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3842 1 3874 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 4178 4097 3842 1 3874 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 3842 1 3874 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3842 1 3874 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 3922 nil true 3968 8 'Refactoring.ico' 4016 nil 30479 nil nil 4178 4097 3794 nil true 34 7 3842 1 3874 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3842 1 3874 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3842 1 3874 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 3842 1 3874 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3842 1 3874 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3842 1 3874 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3842 1 3874 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 30495 nil nil 8 '&Workspace' nil 134217729 nil nil 30497 nil nil 3794 nil true 34 13 3794 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 30499 nil nil 3794 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 30501 nil nil 3794 nil true 34 10 3842 1 3874 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 3842 1 3874 #browseContainingText 8 'C&ontaining Text...' 1 1 3922 nil true 3968 8 'SearchText.ico' 4016 nil nil 3842 1 3874 #browseMethodCategory 8 'Cate&gory...' 1 1 nil nil nil 3842 1 3874 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 4178 4097 3842 1 3874 #browseMethodPackages 8 'Package <s>' 1 1 nil nil nil 3842 1 3874 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 4178 4097 3842 1 3874 #browseMethodHistory 8 '&Change History' 1 1 nil nil nil 3842 1 3874 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 30519 nil nil 4178 4097 3842 1 3874 #removeMethod 8 '&Delete' 1 1 3922 nil true 3968 8 'EditClear.ico' 4016 nil nil 3794 nil true 34 17 3842 1 3874 #renameMethod 8 'Re&name' 1 1 nil nil nil 3842 1 3874 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 3842 1 3874 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 4178 4097 3842 1 3874 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 3794 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 30531 nil nil 3794 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 30533 nil nil 3794 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 30535 nil nil 4178 4097 3794 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 30537 nil nil 3794 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 30539 nil nil 4178 4097 3842 1 3874 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3842 1 3874 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3842 1 3874 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3842 1 3874 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3842 1 3874 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 3922 nil true 3968 8 'Refactoring.ico' 4016 nil 30551 nil nil 4178 4097 3842 1 3874 #methodPackage 8 '&Package...' 1 1 3922 nil true 3968 8 'Package.ico' 4016 nil nil 3794 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 30555 nil nil 3794 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 30557 nil nil 3842 1 3874 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 4178 4097 3842 1 3874 #browseMethodEditions 8 'Browse &Editions' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 30563 nil nil 3794 nil true 34 3 3842 1 3874 #undoChange 8 '&Undo <1d>' 1 1 3922 nil true 3968 8 'EditUndo.ico' 4016 nil nil 3842 1 3874 #redoChange 8 '&Redo <1d>' 1 1 3922 nil true 3968 8 'EditRedo.ico' 4016 nil nil 3842 1 3874 #clearChangeHistory 8 'Clear Change &History' 1 1 nil nil nil 8 'H&istory' nil 134217729 nil nil 30571 nil nil 3794 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 30573 nil nil 3794 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 30575 nil nil 3794 nil true 34 15 3842 1 3874 #helpContents 8 '&Contents' 1025 1 3922 nil true 3968 49 5232 nil nil 3842 1 3874 #help 8 'On this &Tool' 1249 1 nil nil nil 3842 1 3874 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4178 4097 3842 1 3874 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 4178 4097 3842 1 3874 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3842 1 3874 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3842 1 3874 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4178 4097 3842 1 3874 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 3842 1 3874 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3842 1 3874 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4178 4097 3842 1 3874 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 3922 nil true 3968 8 '!!APPLICATION' 4016 nil nil 8 '&Help' nil 134217729 nil nil 30599 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 674 3839 21 674 1411 661 416 962 #updateMenuBar 1088 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 64 10 0 0 84 1 0 0] 34 3 528 3168 2384 1104 nil 27 )! !
!MethodBrowserShell class categoriesFor: #browseMethodsInEnvironments:!instance creation!public! !
!MethodBrowserShell class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!MethodBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!MethodBrowserShell class categoriesFor: #icon!constants!public! !
!MethodBrowserShell class categoriesFor: #initialize!initializing!private! !
!MethodBrowserShell class categoriesFor: #publishedAspects!development!public! !
!MethodBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !

