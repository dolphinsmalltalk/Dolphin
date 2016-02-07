"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #MethodBrowserShell
	instanceVariableNames: 'browserPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodBrowserShell guid: (GUID fromString: '{87B4C6BF-026E-11D3-9FD7-00A0CC3E4A32}')!
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 131137 560 0 482 512 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 0 560 482 512 8 4294902647 234 256 98 8 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 832 0 0 0 7 0 0 0 832 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Edit_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 1 51 738 247 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 123 0 0 0 50 0 0 0] 98 0 738 193 193 0 27 8 'editTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1216 0 0 0 7 0 0 0 1216 914 576 8 #resource_Image_tools 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 63 51 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1168 1184 0 27 8 'imageTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1472 0 0 0 7 0 0 0 1472 914 576 8 #resource_Find_tools 0 962 202 208 98 1 1026 1056 98 2 738 247 51 738 109 51 1472 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 123 0 0 0 25 0 0 0 177 0 0 0 50 0 0 0] 1168 1184 0 27 8 'findTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1728 0 0 0 7 0 0 0 1728 914 576 8 #resource_Smalltalk_tools 0 962 202 208 98 1 1026 1056 98 2 738 63 1 738 991 51 1728 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1168 1184 0 27 8 'smalltalkTools' 234 256 1168 202 208 1168 234 240 1168 0 1 0 738 33 33 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1169 101 560 1026 8 #updateSizePosted 1168 560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 50 0 0 0] 98 4 1216 1728 832 1472 1184 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 2288 0 482 512 0 7 0 658 0 16 690 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 738 193 193 0 2288 0 8 4294902455 234 256 98 6 853766 ##(Smalltalk.StatusBarItem) 1 561 2288 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 2498 1 45 2288 0 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 1180966 ##(Smalltalk.CompiledExpression) 5 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) 8 #Smalltalk 48 8 #developmentSystem 8 #changedIcon 8 #imageIndex 2640 7 257 0 0 8 'modified' 2498 1 -1 2288 0 459270 ##(Smalltalk.Message) 8 #displayString 98 0 2626 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 2496 8 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] 8 #iconImageIndex 2944 7 257 0 0 8 'version' 98 3 2608 2512 2864 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2288 0 0 962 202 208 98 1 1026 1056 98 2 738 1 643 738 1169 41 2288 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 65 1 0 0 72 2 0 0 85 1 0 0] 98 0 1184 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 3264 0 0 0 7 0 0 0 3264 530 1 1 0 0 0 0 410 848 98 14 0 3264 98 2 8 1140850688 131073 3360 0 0 0 519 0 0 0 3360 914 8 ##(Smalltalk.MethodBrowser) 8 #resource_Default_view 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 1169 543 3360 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 15 1 0 0] 1168 1184 0 27 234 256 98 2 3360 8 'browser' 0 962 202 208 98 1 1026 1056 98 2 738 1 101 738 1169 543 3264 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 72 2 0 0 65 1 0 0] 98 1 3360 1184 0 27 234 256 98 4 560 8 'toolbar' 2288 8 'statusbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 8 265030 4 ##(Smalltalk.Menu) 0 16 98 8 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileNew.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 3986 1 4018 8 #fileOpen 8 '&Open...' 9375 1 4082 0 16 4128 8 'FileOpen.ico' 4176 0 0 3986 1 4018 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3986 1 4018 8 #saveImage 8 'Sa&ve Image' 1 1 4082 0 16 4128 8 'Snapshot.ico' 4176 0 0 3986 1 4018 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 4082 0 16 4128 8 'PowerSwitch.ico' 4176 0 0 4370 4097 3986 1 4018 8 #exit 8 '&Close' 17639 1 4082 0 16 4128 8 'CloseWindow.ico' 4176 0 0 8 '&File' 0 134217729 0 0 15551 0 0 3938 0 16 98 13 3986 1 4018 8 #undo 8 '&Undo' 9397 1 4082 0 16 4128 8 'EditUndo.ico' 4176 0 0 4370 4097 3986 1 4018 8 #cutSelection 8 'Cu&t' 9393 1 4082 0 16 4128 8 'EditCut.ico' 4176 0 0 3986 1 4018 8 #copySelection 8 '&Copy' 9351 1 4082 0 16 4128 8 'EditCopy.ico' 4176 0 0 3986 1 4018 8 #pasteClipboard 8 '&Paste' 9389 1 4082 0 16 4128 8 'EditPaste.ico' 4176 0 0 3986 1 4018 8 #editDelete 8 '&Delete' 1 1 4082 0 16 4128 8 'EditClear.ico' 4176 0 0 3938 0 16 98 2 3986 1 4018 8 #reformatSource 8 '&Source' 9391 1 0 0 0 3986 1 4018 8 #reformatComment 8 '&Comment' 9367 1 0 0 0 8 'Ref&ormat' 0 134217729 0 0 15567 0 0 4370 4097 3986 1 4018 8 #selectAll 8 'Select &All' 9347 1 0 0 0 4370 4097 3986 1 4018 8 #editFind 8 '&Find...' 9357 1 4082 0 16 4128 47 786694 ##(Smalltalk.ShellLibrary) 0 0 3986 1 4018 8 #findNext 8 'Find &Next' 1253 1 4082 0 16 4128 8 'FindNext.ico' 4176 0 0 3986 1 4018 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 15577 0 0 3938 0 16 98 16 3986 1 4018 8 #browseIt 8 '&Browse It' 9349 1 4082 0 16 4128 8 'ClassBrowserShell.ico' 4176 0 0 3986 1 4018 8 #displayIt 8 '&Display It' 9353 1 4082 0 16 4128 8 'DisplayIt.ico' 4176 0 0 3986 1 4018 8 #evaluateIt 8 '&Evaluate It' 9355 1 4082 0 16 4128 8 'EvaluateIt.ico' 4176 0 0 3986 1 4018 8 #inspectIt 8 '&Inspect It' 9363 1 4082 0 16 4128 8 'InspectIt.ico' 4176 0 0 3986 1 4018 8 #debugIt 8 'Deb&ug It' 1269 1 4082 0 16 4128 8 'Debugger.ico' 4176 0 0 3986 1 4018 8 #fileItIn 8 'Fi&le It In' 1 1 0 0 0 4370 4097 3986 1 4018 8 #browseDefinitions 8 'Defi&nitions' 1271 1 0 0 0 3986 1 4018 8 #browseReferences 8 '&References' 5367 1 0 0 0 4370 4097 3986 2097153 4018 8 #accept 8 '&Accept' 9383 1 0 0 0 3986 1 4018 8 #reformatAccept 8 'Refor&mat/Accept' 13479 1 0 0 0 4370 4097 3938 0 16 98 14 3986 1 4018 8 #renameVariable 8 'Re&name <1d>...' 1 1 0 0 0 4370 4097 3986 1 4018 8 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 0 0 0 3986 1 4018 8 #extractMethod 8 'E&xtract Method...' 9371 1 0 0 0 3986 1 4018 8 #extractToComponent 8 'Extract to &Component...' 1 1 0 0 0 3986 1 4018 8 #inlineMessage 8 'Inline &Message' 13467 1 0 0 0 4370 4097 3986 1 4018 8 #inlineTemporary 8 '&Inline Temporary' 13481 1 0 0 0 3986 1 4018 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 0 0 0 3986 1 4018 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 4370 4097 3986 1 4018 8 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 3986 1 4018 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 3986 1 4018 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Re&factorings' 8 #codeRefactoringsMenu 134217729 4082 0 16 4128 8 'Refactoring.ico' 4176 0 15621 0 0 4370 4097 3938 0 16 98 7 3986 1 4018 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 3986 1 4018 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 3986 1 4018 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 3986 1 4018 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 3986 1 4018 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 3986 1 4018 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 3986 1 4018 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 15637 0 0 8 '&Workspace' 0 134217729 0 0 15639 0 0 3938 0 16 98 13 3938 0 16 98 0 8 'De&finitions of' 8 #definitionsMenu 1 0 0 15641 0 0 3938 0 16 98 0 8 '&References to' 8 #referencesMenu 1 0 0 15643 0 0 3938 0 16 98 10 3986 1 4018 8 #browseReferencesToGlobal 8 'References to Global...' 1 1 0 0 0 3986 1 4018 8 #browseContainingText 8 'C&ontaining Text...' 1 1 4082 0 16 4128 8 'SearchText.ico' 4176 0 0 3986 1 4018 8 #browseMethodCategory 8 'Cate&gory...' 1 1 0 0 0 3986 1 4018 8 #browseCompilationFailures 8 'Compilation &Failures' 1 1 0 0 0 4370 4097 3986 1 4018 8 #browseMethodPackages 8 'Package <s>' 1 1 0 0 0 3986 1 4018 8 #browseMethodClasses 8 'Class <s>' 1 1 0 0 0 4370 4097 3986 1 4018 8 #browseMethodHistory 8 '&Change History' 1 1 0 0 0 3986 1 4018 8 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 0 0 0 8 '&Browse other' 0 134217729 0 0 15661 0 0 4370 4097 3986 1 4018 8 #removeMethod 8 '&Delete' 1 1 4082 0 16 4128 8 'EditClear.ico' 4176 0 0 3938 0 16 98 17 3986 1 4018 8 #renameMethod 8 'Re&name' 1 1 0 0 0 3986 1 4018 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 3986 1 4018 8 #safeRemoveMethods 8 'Rem&ove' 1 1 0 0 0 4370 4097 3986 1 4018 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 3938 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 15673 0 0 3938 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 15675 0 0 3938 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 15677 0 0 4370 4097 3938 0 16 98 0 8 'Rename &Temporary' 8 #renameTempMenu 134217729 0 0 15679 0 0 3938 0 16 98 0 8 'Convert Temp to Inst. Var.' 8 #convertTempToInstVarMenu 134217729 0 0 15681 0 0 4370 4097 3986 1 4018 8 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 0 0 0 3986 1 4018 8 #pushUpMethods 8 'Push &Up' 9325 1 0 0 0 3986 1 4018 8 #pushDownMethods 8 'Push &Down' 9327 1 0 0 0 3986 1 4018 8 #overrideMethods 8 'Ove&rride <1d>' 1 1 0 0 0 3986 1 4018 8 #moveMethod 8 'Move to &Component...' 1 1 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 4082 0 16 4128 8 'Refactoring.ico' 4176 0 15693 0 0 4370 4097 3986 1 4018 8 #methodPackage 8 '&Package...' 1 1 4082 0 16 4128 8 'Package.ico' 4176 0 0 3938 0 16 98 0 8 'Add to &Category' 8 #addCategoryMenu 134217729 0 0 15697 0 0 3938 0 16 98 0 8 'Re&move from Category' 8 #removeCategoryMenu 134217729 0 0 15699 0 0 3986 1 4018 8 #togglePrivate 8 'Pri&vate' 1 1 0 0 0 4370 4097 3986 1 4018 8 #browseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 8 '&Method' 0 134217729 0 0 15705 0 0 3938 0 16 98 3 3986 1 4018 8 #undoChange 8 '&Undo <1d>' 1 1 4082 0 16 4128 8 'EditUndo.ico' 4176 0 0 3986 1 4018 8 #redoChange 8 '&Redo <1d>' 1 1 4082 0 16 4128 8 'EditRedo.ico' 4176 0 0 3986 1 4018 8 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 15713 0 0 3938 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 15715 0 0 3938 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 15717 0 0 3938 0 16 98 16 3986 1 4018 8 #helpContents 8 '&Contents' 1025 1 4082 0 16 4128 49 5616 0 0 3986 1 4018 8 #help 8 'On this &Tool' 1249 1 0 0 0 3986 1 4018 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 4370 4097 3986 1 4018 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 4370 4097 3986 1 4018 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 3986 1 4018 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 3986 1 4018 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 3938 0 16 98 4 3986 2097153 4018 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 4082 0 16 4128 8 'TipOfTheDay.ico' 4176 0 0 3986 1 4018 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 4082 0 16 4128 8 'TipOfTheDay.ico' 4176 0 0 4370 4097 3986 1 4018 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 15739 0 0 4370 4097 3986 1 4018 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 3986 1 4018 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 3986 1 4018 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 4370 4097 3986 1 4018 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4082 0 16 4128 8 '!!APPLICATION' 4176 0 0 8 '&Help' 0 134217729 0 0 15749 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 962 202 208 98 2 1026 1056 98 2 738 4999 21 738 1201 801 416 1026 8 #updateMenuBar 1168 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 195 9 0 0 10 0 0 0 27 12 0 0 154 1 0 0] 98 3 560 3264 2288 1184 0 27)! !
!MethodBrowserShell class categoriesFor: #browseMethodsInEnvironments:!instance creation!public! !
!MethodBrowserShell class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!MethodBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!MethodBrowserShell class categoriesFor: #icon!constants!public! !
!MethodBrowserShell class categoriesFor: #initialize!initializing!private! !
!MethodBrowserShell class categoriesFor: #publishedAspects!development!public! !
!MethodBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !

