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
	^self selectedMethods allSatisfy: [:each | self isEditableMethod: each]!

hasMethods
	"Answer whether there are any methods in the browser model."

	^browserPresenter hasMethods!

hasMethodSelected
	"Answer whether a single method is selected in the browser"

	^browserPresenter hasMethodSelected!

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
	(self view viewNamed: 'errors' ifNone: nil) ifNotNil: [:item | item model: self statusModel].
	(self view viewNamed: 'modified' ifNone: nil)
		ifNotNil: [:item | item model: self browser modifiedModel].
	(self view viewNamed: 'namespace' ifNone: nil)
		ifNotNil: [:item | item model: browserPresenter namespaceModel]!

parseContext
	^self selectedMethod
		ifNil: 
			[ParseContext methodClass: (model modelClassFor: UndefinedObject)
				environment: (model modelClassFor: Smalltalk)]
		ifNotNil: 
			[:method |
			| class package |
			package := method owningPackageIfLoose.
			class := model modelClassFor: method methodClass.
			(method customEnvironment notNil or: [package isNil and: [class owningPackage isNil]])
				ifTrue: [class methodFor: method selector]
				ifFalse: 
					[| env |
					env := package ifNil: [class environment] ifNotNil: [package environment ifNil: [class environment]].
					ParseContext methodClass: class environment: (model modelClassFor: env)]]!

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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 #{Graphics.Color} #default 8 1809897712 170 192 34 10 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Smalltalk_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 63 1 866 553 51 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 8 #() 866 193 193 nil 27 8 'smalltalkTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 7 nil nil nil 1008 738 #{UI.Toolbar} #resource_Image_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 63 51 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 960 976 nil 27 8 'imageTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 738 #{UI.Toolbar} #resource_Search_tools nil 770 34 1 818 #createAt:extent: 34 2 866 615 1 866 437 51 1232 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 960 976 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1456 nil nil nil 7 nil nil nil 1456 738 #{UI.Toolbar} #resource_History_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1159 1 866 169 51 1456 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 67 2 0 0 0 0 0 0 151 2 0 0 25 0 0 0] 960 976 nil 27 8 'historyTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1680 nil nil nil 7 nil nil nil 1680 738 #{UI.Toolbar} #resource_Find_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1051 1 866 109 51 1680 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 67 2 0 0 25 0 0 0] 960 976 nil 27 8 'findTools' nil nil nil 170 192 960 138 144 960 nil nil 1 nil 866 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1469 51 528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 25 0 0 0] 34 5 1008 672 1232 1680 1456 976 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 2128 nil nil nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 866 193 193 nil 2128 nil 8 1809451024 170 192 34 6 1050438 1 #{UI.StatusBarItem} 8193 -1 2128 nil 786950 #{Core.Message} #displayString 8 #() 2370 #iconImageIndex 2400 nil 8 'errors' 2338 8193 45 2128 nil nil 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 6 1 2464 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 #{Kernel.VariableBinding} #'Tools.SmalltalkSystem' #{Tools.SmalltalkSystem} #{Smalltalk} 1 #current #changedIcon #imageIndex #ifTrue: 2480 7 257 nil 2466 0 nil 2498 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edit'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2608 #ifTrue: 7 257 nil 8 'modified' 2338 8705 351 2128 nil 2370 #displayString 8 #() 2370 #iconImageIndex 8 #() 2466 0 nil 2498 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2800 7 257 nil 8 'namespace' nil nil nil 34 3 2448 2352 2720 1311814 1 #{UI.StatusBarNullItem} 8705 1 2128 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 543 866 1469 41 2128 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 15 1 0 0 222 2 0 0 35 1 0 0] 8 #() 976 nil 29 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 3104 nil nil nil 7 nil nil nil 3104 498 1 1 nil nil nil nil 410 #{UI.ReferenceView} 34 14 nil 3104 34 2 8 1140850688 131073 3184 nil nil nil 519 nil nil nil 3184 738 #{Tools.MethodBrowser} #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1469 493 3184 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 222 2 0 0 246 0 0 0] 960 976 nil 27 170 192 34 2 3184 8 'browser' nil 770 34 1 818 #createAt:extent: 34 2 866 1 51 866 1469 493 3104 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 222 2 0 0 15 1 0 0] 34 1 3184 976 nil 27 170 192 34 4 2128 8 'statusbar' 528 8 'toolbar' nil 658246 4 #{UI.MenuBar} nil true 34 8 461638 4 #{UI.Menu} nil true 34 8 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #fileNew 8 '&New Workspace' 9373 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 3746 1 3778 #fileOpen 8 '&Open Workspace…' 9375 1 3826 nil true 3858 8 'OpenWorkspace.ico' 3920 65541 nil nil nil 3746 1 3778 #fileFileIn 8 '&File In…' 1 1 3826 nil true 3858 8 'FileIn.ico' 3920 65541 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 3746 1 3778 #saveImage 8 'Sa&ve Image' 1 1 3826 nil true 3858 8 'Snapshot.ico' 3920 65541 nil nil nil 3746 1 3778 #smalltalkExit 8 'E&xit Dolphin' 1 1 3826 nil true 3858 8 'PowerSwitch.ico' 3920 65541 nil nil nil 4146 4097 3746 1 3778 #exit 8 '&Close' 17639 1 1378630 2 #{Graphics.TextTileIcon} $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 39423 nil nil 3698 nil true 34 13 3746 1 3778 #undo 8 '&Undo' 9397 1 3826 nil true 3858 8 'EditUndo.ico' 3920 65541 nil nil nil 4146 4097 3746 1 3778 #cutSelection 8 'Cu&t' 9393 1 3826 nil true 3858 8 'EditCut.ico' 3920 65541 nil nil nil 3746 1 3778 #copySelection 8 '&Copy' 9351 1 3826 nil true 3858 8 'EditCopy.ico' 3920 65541 nil nil nil 3746 1 3778 #pasteClipboard 8 '&Paste' 9389 1 3826 nil true 3858 8 'EditPaste.ico' 3920 65541 nil nil nil 3746 1 3778 #editDelete 8 '&Delete' 1 1 3826 nil true 3858 8 'EditClear.ico' 3920 65541 nil nil nil 3698 nil true 34 2 3746 1 3778 #reformatSource 8 '&Source' 9391 1 nil nil nil 3746 1 3778 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 39439 nil nil 4146 4097 3746 1 3778 #selectAll 8 'Select &All' 9347 1 nil nil nil 4146 4097 3746 1 3778 #editFind 8 '&Find…' 9357 1 3826 nil true 2425862 #{Graphics.ImageFromResourceInitializer} 47 983302 #{OS.ShellLibrary} 65541 nil nil nil 3746 1 3778 #findNext 8 'Find &Next' 1253 1 3826 nil true 3858 8 'FindNext.ico' 3920 65541 nil nil nil 3746 1 3778 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 39449 nil nil 3698 nil true 34 17 3746 1 3778 #browseIt 8 '&Browse It' 9349 1 3826 nil true 3858 8 'ClassBrowserShell.ico' 3920 65541 nil nil nil 3746 1 3778 #displayIt 8 '&Display It' 9353 1 3826 nil true 3858 8 'DisplayIt.ico' 3920 65541 nil nil nil 3746 1 3778 #printIt 8 '&Print It' 9377 1 3826 nil true 3858 8 'PrintIt.ico' 3920 65541 nil nil nil 3746 1 3778 #evaluateIt 8 '&Evaluate It' 9355 1 3826 nil true 3858 8 'EvaluateIt.ico' 3920 65541 nil nil nil 3746 1 3778 #inspectIt 8 '&Inspect It' 9363 1 3826 nil true 3858 8 'InspectIt.ico' 3920 65541 nil nil nil 3746 1 3778 #debugIt 8 'Deb&ug It' 1269 1 3826 nil true 3858 8 'Debugger.ico' 3920 65541 nil nil nil 3746 1 3778 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 4146 4097 3746 1 3778 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 3746 1 3778 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 4146 4097 3746 2097153 3778 #accept 8 '&Accept' 9383 1 nil nil nil 3746 1 3778 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 4146 4097 3698 nil true 34 14 3746 1 3778 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 4146 4097 3746 1 3778 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 3746 1 3778 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 3746 1 3778 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 3746 1 3778 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 4146 4097 3746 1 3778 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 3746 1 3778 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 3746 1 3778 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 4146 4097 3746 1 3778 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 3746 1 3778 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 3746 1 3778 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 3826 nil true 3858 8 'Refactoring.ico' 3920 65541 nil nil 39495 nil nil 4146 4097 3698 nil true 34 7 3746 1 3778 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3746 1 3778 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3746 1 3778 #toggleLineEndings 8 'Line &Endings' 1 1 4434 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3746 1 3778 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3746 1 3778 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3746 1 3778 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3746 1 3778 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 3826 nil true 3858 8 'Preferences.ico' 3920 65541 nil nil 39511 nil nil 8 '&Workspace' nil 134217729 nil nil 39513 nil nil 3698 nil true 34 11 3698 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil 39515 nil nil 3698 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil 39517 nil nil 3698 nil true 34 10 3746 1 3778 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 3746 1 3778 #browseContainingText 8 'C&ontaining Text…' 1 1 3826 nil true 3858 8 'SearchText.ico' 3920 65541 nil nil nil 3746 1 3778 #browseMethodCategory 8 'Cate&gory…' 1 1 3826 nil true 3858 8 'Category.ico' 3920 65541 nil nil nil 3746 1 3778 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 4146 4097 3746 1 3778 #browseMethodPackages 8 'Package <s>' 1 1 3826 nil true 3858 8 'Package.ico' 3920 65541 nil nil nil 3746 1 3778 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 4146 4097 3746 1 3778 #browseMethodHistory 8 '&Change History' 1 1 3826 nil true 3858 8 'MethodHistory.ico' 3920 65541 nil nil nil 3746 1 3778 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 39535 nil nil 4146 4097 3746 1 3778 #removeMethod 8 'Re&move' 1 1 3826 nil true 3858 8 'MethodDelete.ico' 3920 65541 nil nil nil 3698 nil true 34 16 3746 1 3778 #renameMethod 8 'Re&name' 1 1 nil nil nil 3746 1 3778 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 4146 4097 3746 1 3778 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 3698 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 39545 nil nil 3698 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 39547 nil nil 3698 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 39549 nil nil 4146 4097 3698 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 39551 nil nil 3698 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 39553 nil nil 4146 4097 3746 1 3778 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 3746 1 3778 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 3746 1 3778 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 3746 1 3778 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 3746 1 3778 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 3826 nil true 3858 8 'Refactoring.ico' 3920 65541 nil nil 39565 nil nil 4146 4097 3746 1 3778 #methodPackage 8 '&Package…' 1 1 3826 nil true 3858 8 'Package.ico' 3920 65541 nil nil nil 3698 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 39569 nil nil 3698 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil 39571 nil nil 3746 1 3778 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 8 '&Method' #method 134217729 nil nil 39575 nil nil 3698 nil true 34 3 3746 1 3778 #undoChange 8 '&Undo <1d>' 1 1 3826 nil true 3858 8 'EditUndo.ico' 3920 65541 nil nil nil 3746 1 3778 #redoChange 8 '&Redo <1d>' 1 1 3826 nil true 3858 8 'EditRedo.ico' 3920 65541 nil nil nil 3746 1 3778 #clearChangeHistory 8 'Clear Change &History' 1 1 3826 nil true 3858 8 'MethodHistoryErase.ico' 3920 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 39583 nil nil 3698 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 39585 nil nil 3698 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 39587 nil nil 3698 nil true 34 15 3746 1 3778 #helpContents 8 '&Contents' 1025 1 3826 nil true 3858 8 'Help.ico' 3920 65541 nil nil nil 3746 1 3778 #help 8 'On this &Tool' 1249 1 nil nil nil 3746 1 3778 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4146 4097 3746 1 3778 #learnSmalltalk 8 'Learn Smalltalk' 1 1 4434 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 4146 4097 3746 1 3778 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3746 1 3778 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3746 1 3778 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4146 4097 3746 1 3778 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 3826 nil true 3858 8 '!!APPLICATION' 3920 65541 nil nil nil 3746 1 3778 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3746 1 3778 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4146 4097 3746 1 3778 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4434 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 39611 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 1 818 #createAt:extent: 34 2 866 12287 21 866 1501 701 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 237 26 0 0 104 1 0 0] 34 3 528 3104 2128 976 nil 27)! !
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

