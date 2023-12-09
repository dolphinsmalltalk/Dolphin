"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.MethodBrowserShell'
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
	| methods |
	methods := self selectedMethods.
	^methods notEmpty and: [methods allSatisfy: [:each | self isEditableMethod: each]]!

hasMethods
	"Answer whether there are any methods in the browser model."

	^browserPresenter hasMethods!

hasMethodSelected
	"Answer whether a single method is selected in the browser"

	^browserPresenter hasMethodSelected!

isEditableMethod: aCompiledMethod 
	^aCompiledMethod isUnbound not!

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
	(self view viewNamed: 'errors' ifNone: nil) ifNotNil: [:item | item model: self statusModel].
	(self view viewNamed: 'modified' ifNone: nil)
		ifNotNil: [:item | item model: self browser modifiedModel].
	(self view viewNamed: 'namespace' ifNone: nil)
		ifNotNil: [:item | item model: browserPresenter namespaceModel]!

parseContext
	^self selectedMethod
		ifNil: [model defaultParseContext]
		ifNotNil: [:method | (model modelMethodFor: method) parseContext]!

recompileDiffs
	<commandQuery: #hasMethodSelected>
	self developmentSystem recompileDiffs: self selectedMethod!

saveNewMethod: aString
	| method package |
	method := self selectedMethod.
	package := method owningPackageIfLoose.
	self browser
		saveMethod: aString
		in: method methodClass
		environment: (package ifNotNil: [package environment])
		categories: method realCategories
		package: package!

searchEnvironment: aBrowserEnvironment 
	browserPresenter searchEnvironment: aBrowserEnvironment!

selectedMethod
	"Answer the currently selected method, or nil if there is not exactly one selected."

	^self browser selectedMethod!

selectedMethods
	"Answer the currently selected methods, or an empty collection if there are no selections."

	^self browser selectedMethods!

setInitialFocus
	self hasMethodSelected ifTrue: [browserPresenter setInitialFocus] ifFalse: [super setInitialFocus]!

statusModel
	^self browser errorModel!

statusText: aString
	self statusModel value: (aString isNil ifFalse: [Notification messageText: aString])!

systemModel
	^self model! !
!Tools.MethodBrowserShell categoriesForMethods!
browser!accessing!public! !
canSaveMethod!private!testing! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
filter!accessing!public! !
findDetails:!accessing!public! !
findSelector:!public!searching! !
hasEditableMethodSelected!public!testing! !
hasEditableMethodsSelected!public!testing! !
hasMethods!public!testing! !
hasMethodSelected!public!testing! !
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
selectedMethods!accessing!public! !
setInitialFocus!operations!public! !
statusModel!event handling!public! !
statusText:!accessing!private! !
systemModel!accessing!private! !
!

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

defaultOptionFlags
	^CanUseIdeaSpaceMask!

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

	SmalltalkSystem current registerTool: self!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: ((Aspect boolean: #canUseIdeaSpace)
					defaultValue: true;
					yourself);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 10 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Find_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1051 1 498 109 51 304 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'findTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 370 #{UI.Toolbar} #resource_History_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1159 1 498 169 51 640 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 2 0 0 0 0 0 0 151 2 0 0 25 0 0 0] 592 608 nil 27 8 'historyTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 864 nil nil nil 5 nil nil nil 864 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 63 51 864 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 592 608 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1088 nil nil nil 5 nil nil nil 1088 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createAt:extent: 50 2 498 615 1 498 437 51 1088 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 592 608 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1312 nil nil nil 5 nil nil nil 1312 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createAt:extent: 50 2 498 63 1 498 553 51 1312 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 592 608 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 1 nil 498 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1469 51 160 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 25 0 0 0] 50 5 864 1312 1088 304 640 608 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140850956 1 1760 nil nil nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 1760 nil nil 258 #{Core.IdentityDictionary} 50 6 1862 1 #{UI.StatusBarItem} 8193 -1 1760 nil 518 #{Core.Message} #displayString 8 #() 1986 #iconImageIndex 2016 nil 8 'errors' 1954 8193 45 1760 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 6 1 2080 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1094 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #current #changedIcon #imageIndex #ifTrue: 2096 7 257 nil 2082 0 nil 2114 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edit'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2224 #ifTrue: 7 257 nil 8 'modified' 1954 8705 351 1760 nil 1986 #displayString 8 #() 1986 #iconImageIndex 8 #() 2082 0 nil 2114 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2416 7 257 nil 8 'namespace' nil nil nil 50 3 2064 1968 2336 1094 1 #{UI.StatusBarNullItem} 8705 1 1760 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 543 498 1469 41 1760 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 15 1 0 0 222 2 0 0 35 1 0 0] 8 #() 608 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2720 nil nil nil 5 nil nil nil 2720 130 1 1 nil nil nil nil 18 #{UI.ReferenceView} 50 14 nil 2720 50 2 8 1140850688 131073 2800 nil nil nil 517 nil nil nil 2800 370 #{Tools.MethodBrowser} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1469 493 2800 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 246 0 0 0] 592 608 nil 27 258 #{Core.IdentityDictionary} 50 2 2800 8 'browser' nil 402 50 1 450 #createAt:extent: 50 2 498 1 51 498 1469 493 2720 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 222 2 0 0 15 1 0 0] 50 1 2800 608 nil 27 258 #{Core.IdentityDictionary} 50 4 1760 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 8 2886 4 #{UI.Menu} nil true 50 8 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New Workspace' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 3362 1 3394 #fileOpen 8 '&Open Workspace…' 9375 1 3442 nil true 3474 8 'OpenWorkspace.ico' 3536 65541 nil nil nil 3362 1 3394 #fileFileIn 8 '&File In…' 1 1 3442 nil true 3474 8 'FileIn.ico' 3536 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 3362 1 3394 #saveImage 8 'Sa&ve Image' 1 1 3442 nil true 3474 8 'Snapshot.ico' 3536 65541 nil nil nil 3362 1 3394 #smalltalkExit 8 'E&xit Dolphin' 1 1 3442 nil true 3474 8 'PowerSwitch.ico' 3536 65541 nil nil nil 3762 4097 3362 1 3394 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 3314 nil true 50 13 3362 1 3394 #undo 8 '&Undo' 9397 1 3442 nil true 3474 8 'EditUndo.ico' 3536 65541 nil nil nil 3762 4097 3362 1 3394 #cutSelection 8 'Cu&t' 9393 1 3442 nil true 3474 8 'EditCut.ico' 3536 65541 nil nil nil 3362 1 3394 #copySelection 8 '&Copy' 9351 1 3442 nil true 3474 8 'EditCopy.ico' 3536 65541 nil nil nil 3362 1 3394 #pasteClipboard 8 '&Paste' 9389 1 3442 nil true 3474 8 'EditPaste.ico' 3536 65541 nil nil nil 3362 1 3394 #editDelete 8 '&Delete' 1 1 3442 nil true 3474 8 'EditClear.ico' 3536 65541 nil nil nil 3314 nil true 50 2 3362 1 3394 #reformatSource 8 '&Source' 9391 1 nil nil nil 3362 1 3394 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil nil nil nil 3762 4097 3362 1 3394 #selectAll 8 'Select &All' 9347 1 nil nil nil 3762 4097 3362 1 3394 #editFind 8 '&Find…' 9357 1 3442 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 3362 1 3394 #findNext 8 'Find &Next' 1253 1 3442 nil true 3474 8 'FindNext.ico' 3536 65541 nil nil nil 3362 1 3394 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 3314 nil true 50 17 3362 1 3394 #browseIt 8 '&Browse It' 9349 1 3442 nil true 3474 8 'ClassBrowserShell.ico' 3536 65541 nil nil nil 3362 1 3394 #displayIt 8 '&Display It' 9353 1 3442 nil true 3474 8 'DisplayIt.ico' 3536 65541 nil nil nil 3362 1 3394 #printIt 8 '&Print It' 9377 1 3442 nil true 3474 8 'PrintIt.ico' 3536 65541 nil nil nil 3362 1 3394 #evaluateIt 8 '&Evaluate It' 9355 1 3442 nil true 3474 8 'EvaluateIt.ico' 3536 65541 nil nil nil 3362 1 3394 #inspectIt 8 '&Inspect It' 9363 1 3442 nil true 3474 8 'InspectIt.ico' 3536 65541 nil nil nil 3362 1 3394 #debugIt 8 'Deb&ug It' 1269 1 3442 nil true 3474 8 'Debugger.ico' 3536 65541 nil nil nil 3362 1 3394 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 3762 4097 3362 1 3394 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3362 1 3394 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 3762 4097 3362 2097153 3394 #accept 8 '&Accept' 9383 1 nil nil nil 3362 1 3394 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 3762 4097 3314 nil true 50 14 3362 1 3394 #renameVariable 8 'Re&name <d:Variable>…' 1 1 nil nil nil 3762 4097 3362 1 3394 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 3362 1 3394 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 3362 1 3394 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 3362 1 3394 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 3762 4097 3362 1 3394 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3362 1 3394 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3362 1 3394 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 3762 4097 3362 1 3394 #addParameterToMessage 8 '&Add Parameter to <d:Message>…' 1 1 nil nil nil 3362 1 3394 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3362 1 3394 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 3442 nil true 3474 8 'Refactoring.ico' 3536 65541 nil nil nil nil nil 3762 4097 3314 nil true 50 7 3362 1 3394 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3362 1 3394 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3362 1 3394 #toggleLineEndings 8 'Line &Endings' 1 1 4050 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3362 1 3394 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3362 1 3394 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3362 1 3394 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3362 1 3394 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 3442 nil true 3474 8 'Preferences.ico' 3536 65541 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 3314 nil true 50 11 3314 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil nil nil nil 3314 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil nil nil nil 3314 nil true 50 10 3362 1 3394 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 3362 1 3394 #browseContainingText 8 'C&ontaining Text…' 1 1 3442 nil true 3474 8 'SearchText.ico' 3536 65541 nil nil nil 3362 1 3394 #browseMethodCategory 8 'Cate&gory…' 1 1 3442 nil true 3474 8 'Category.ico' 3536 65541 nil nil nil 3362 1 3394 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 3762 4097 3362 1 3394 #browseMethodPackages 8 'Package <s>' 1 1 3442 nil true 3474 8 'Package.ico' 3536 65541 nil nil nil 3362 1 3394 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 3762 4097 3362 1 3394 #browseMethodHistory 8 '&Change History' 1 1 3442 nil true 3474 8 'MethodHistory.ico' 3536 65541 nil nil nil 3362 1 3394 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil nil nil nil 3762 4097 3362 1 3394 #removeMethod 8 'Re&move' 1 1 3442 nil true 3474 8 'MethodDelete.ico' 3536 65541 nil nil nil 3314 nil true 50 16 3362 1 3394 #renameMethod 8 'Re&name' 1 1 nil nil nil 3362 1 3394 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 3762 4097 3362 1 3394 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 3314 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 3314 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil nil nil nil 3314 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil nil nil nil 3762 4097 3314 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil nil nil nil 3314 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil nil nil nil 3762 4097 3362 1 3394 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3362 1 3394 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3362 1 3394 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3362 1 3394 #overrideMethods 8 'Ove&rride <d:Methods>' 1 1 nil nil nil 3362 1 3394 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 3442 nil true 3474 8 'Refactoring.ico' 3536 65541 nil nil nil nil nil 3762 4097 3362 1 3394 #methodPackage 8 '&Package…' 1 1 3442 nil true 3474 8 'Package.ico' 3536 65541 nil nil nil 3314 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil nil nil nil 3314 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil nil nil nil 3362 1 3394 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 8 '&Method' #method 134217729 nil nil nil nil nil 3314 nil true 50 3 3362 1 3394 #undoChange 8 '&Undo <d>' 1 1 3442 nil true 3474 8 'EditUndo.ico' 3536 65541 nil nil nil 3362 1 3394 #redoChange 8 '&Redo <d>' 1 1 3442 nil true 3474 8 'EditRedo.ico' 3536 65541 nil nil nil 3362 1 3394 #clearChangeHistory 8 'Clear Change &History' 1 1 3442 nil true 3474 8 'MethodHistoryErase.ico' 3536 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil nil nil nil 3314 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 3314 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 3314 nil true 50 15 3362 1 3394 #helpContents 8 '&Contents' 1025 1 3442 nil true 3474 8 'Help.ico' 3536 65541 nil nil nil 3362 1 3394 #help 8 'On this &Tool' 1249 1 nil nil nil 3362 1 3394 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3762 4097 3362 1 3394 #learnSmalltalk 8 'Learn Smalltalk' 1 1 4050 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 3762 4097 3362 1 3394 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3362 1 3394 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3362 1 3394 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3762 4097 3362 1 3394 #dolphinHomePage 8 'Object Arts Homepage' 1 1 3442 nil true 3474 8 '!!APPLICATION' 3536 65541 nil nil nil 3362 1 3394 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3362 1 3394 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3762 4097 3362 1 3394 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4050 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 402 50 1 450 #createAt:extent: 50 2 498 6143 21 498 1501 701 32 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 237 14 0 0 104 1 0 0] 50 3 160 2720 1760 608 nil 27)! !
!Tools.MethodBrowserShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
defaultAdditionalAccelerators!constants!private! !
defaultOptionFlags!constants!options!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
!

