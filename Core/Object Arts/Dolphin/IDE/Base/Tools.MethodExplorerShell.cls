"Filed out from Dolphin Smalltalk"!

Tools.MethodBrowserShell subclass: #'Tools.MethodExplorerShell'
	instanceVariableNames: 'historyTree historyList'
	classVariableNames: 'HistoryListSize'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.MethodExplorerShell guid: (Core.GUID fromString: '{8d4892fd-f8e1-49bd-87b5-7366078a04ff}')!
Tools.MethodExplorerShell comment: 'MethodExplorerShell is a <MethodBrowserShell> that implements a method browser tool with history tree of searches. Each browse operation (e.g. a definitions or reference search) initiated from the browser results in a new node in the tree. The node is created under the node that was current when the search was performed. This allows one to drill down by performing a series of nested search operations, with the tree maintaining the path. A history list and forward/back buttons allow one to navigate through the chronological history of searches.

Instance Variables:
	historyTree		<TreePresenter>
	historyList			<HistoryList>

Class Variables:
	HistoryListSize		<integer>

'!
!Tools.MethodExplorerShell categoriesForClass!MVP-Presenters! !
!Tools.MethodExplorerShell methodsFor!

addSearch: aBrowserEnvironment under: parentBrowserEnvironment 
	historyTree model add: aBrowserEnvironment asChildOf: parentBrowserEnvironment!

addToCommandRoute: route 
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next."

	"Implementation Note: We want to make sure that the methods presenter is always
	in the route, and that it appears before SmalltalkSystem but after the receiver (if not already
	in the route)."

	route
		appendTarget: self;
		appendTarget: browserPresenter;
		appendPresenter: self!

browseMethodsIn: aBrowserEnvironment 
	self addSearch: aBrowserEnvironment under: historyTree selectionOrNil.
	historyTree selection: aBrowserEnvironment.
	self setInitialFocus!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironments 
	| first |
	aCollectionOfBrowserEnvironments do: 
			[:each | 
			first ifNil: [first := each].
			self addSearch: each under: historyTree selectionOrNil].
	first ifNotNil: [historyTree selection: first].
	self setInitialFocus!

buildHistoryFutureMenu
	"Private - Answer a dynamically created future visit menu."

	^(self buildHistoryMenu: historyList upToEnd command: #historyForward:)
		text: 'Forward';
		yourself!

buildHistoryMenu: visits command: cmdSelector
	"Private - Answer a dynamically created past visit history menu."

	| popup lastEnv subMenu methods |
	popup := Menu new.
	lastEnv := nil.
	visits keysAndValuesDo: 
			[:i :each |
			| env method |
			env := each key.
			env == lastEnv
				ifFalse: 
					[methods := IdentitySet new.
					subMenu := popup addSubmenu: env displayString.
					lastEnv := env].
			method := each value ?? '(none)'.
			"We only want to add each method to the menu once"
			(methods includes: method)
				ifFalse: 
					[subMenu addCommand: (Message selector: cmdSelector argument: i) description: method displayString.
					methods add: method].
			subMenu setDefault: 1].
	popup setDefault: 1.
	^popup!

buildHistoryPastMenu
	"Private - Answer a dynamically created past visit history menu."

	^(self buildHistoryMenu: historyList past command: #historyBack:)
		text: 'Past';
		yourself!

buildPopupForCommand: aSymbol 
	"Private - Dynamically build an appropriate popup menu for aSymbol command."

	aSymbol == #historyBack ifTrue: [^self buildHistoryPastMenu].
	aSymbol == #historyForward ifTrue: [^self buildHistoryFutureMenu].
	^super buildPopupForCommand: aSymbol!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

clearSelection
	"Removes the selected method from the system"

	self perform: self deleteItCommand!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	historyTree := self
				add: TreePresenter new
				name: 'historyTree'
				helpId: 10875!

createSchematicWiring
	super createSchematicWiring.
	historyTree 
		when: #selectionChanged
		send: #onTreeSelectionChanged
		to: self.
	self 
		when: #timerTick:
		send: #onTimerTick:
		to: self!

defaultHelpId
	^10874!

deleteItCommand
	historyTree hasFocus ifTrue: [^#removeHistoryNode].
	^nil!

hasFuture
	^historyList hasFuture!

hasPast
	^historyList hasPast!

historySkip: anInteger
	"Private - Move around in the history list by the specified <integer> delta (negative for
	backwards)."

	| method history visit node |
	history := historyList.
	browserPresenter promptToSaveChanges ifFalse: [^self].
	history skip: anInteger.
	visit := history current.
	node := visit key.
	self noEventsDo: [historyTree selection: node].
	method := visit value.
	browserPresenter clearErrors.
	(method notNil and: [(method methodClass includesSelector: method selector) not])
		ifTrue: 
			[self statusText: ('<1p> has been deleted' expandMacrosWith: method).
			Sound warningBeep.
			method := nil].
	browserPresenter selection: method ifAbsent: []!

historyTree
	^historyTree!

initialize
	"Private - Initialize the receiver."

	super initialize.
	historyList := HistoryList new: self class historyListSize!

isSameMethod: aCompiledMethod1 as: aCompiledMethod2 
	^aCompiledMethod1 isNil 
		ifTrue: [aCompiledMethod2 isNil]
		ifFalse: 
			[aCompiledMethod2 notNil and: 
					[aCompiledMethod1 selector == aCompiledMethod2 selector 
						and: [aCompiledMethod1 methodClass == aCompiledMethod2 methodClass]]]!

killVisitTimer
	self view killTimer: 1!

methods: aBrowserEnvironment
	self browseMethodsIn: aBrowserEnvironment!

onMethodSelected
	"Private - The browserPresenter has selected a method.
	Ensure that the browserPresenter selects the appropriate text."

	super onMethodSelected.
	self setVisitTimer!

onTimerTick: anInteger 
	anInteger == 1 ifFalse: [^self].
	self killVisitTimer.
	self recordMethodVisit!

onTipTextRequired: tool
	"Tool tip text is required for the <ToolbarItem>, tool."

	| cmd |
	cmd := tool command asSymbol.
	(cmd == #historyBack and: [historyList hasPast])
		ifTrue: [^'Back to <1p>' expandMacrosWith: historyList previous].
	(cmd == #historyForward and: [historyList hasFuture])
		ifTrue: [^'Forward to <1p>' expandMacrosWith: historyList next].
	^super onTipTextRequired: tool!

onTreeSelectionChanged
	self killVisitTimer.
	historyTree selectionOrNil
		ifNil: 
			[self caption: self class displayString.
			browserPresenter list: #()]
		ifNotNil: 
			[:env |
			self caption: env label.
			browserPresenter methods: env.
			self selectFirstMethod]!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	| toolbar |
	super onViewOpened.
	toolbar := self view viewNamed: 'historyTools'.
	toolbar presenterConnectionPoint 
		when: #dropDown:
		send: #onDropDown:
		to: self.
!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>."

	| selector |
	selector := aCommandQuery commandSymbol.
	#clearSelection == selector
		ifTrue: 
			[selector := self deleteItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#historyBack: == selector
		ifTrue: 
			[| dist |
			dist := aCommandQuery command arguments first.
			aCommandQuery isEnabled: historyList pastSize >= dist.
			^true].
	#historyForward: == selector
		ifTrue: 
			[| dist |
			dist := aCommandQuery command arguments first.
			aCommandQuery isEnabled: historyList futureSize >= dist.
			^true].
	selector == #historyForward
		ifTrue: 
			[self hasFuture
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {historyList next}
									locale: Locale smalltalk)]
				ifFalse: 
					[aCommandQuery
						isEnabled: false;
						text: 'Forward'].
			^true].
	selector == #historyBack
		ifTrue: 
			[self hasPast
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {historyList previous}
									locale: Locale smalltalk)]
				ifFalse: 
					[aCommandQuery
						isEnabled: false;
						text: 'Back'].
			^true].
	^super queryCommand: aCommandQuery!

recordMethodVisit
	"Private - Add to the visit history - note that the current item is at the top of the history list"

	| node method |
	#namespaceToDo.	"Rework to use MethodNames"
	node := historyTree selectionOrNil.
	node isNil ifTrue: [^self].
	method := self selectedMethod.
	(historyList isEmpty or: 
			[| cur |
			cur := historyList current.
			cur key ~= node or: [(self isSameMethod: cur value as: method) not]])
		ifTrue: 
			[historyList addLast: node -> method.
			self invalidateUserInterface]
		ifFalse: [historyList current: node -> method]!

removeHistoryNode
	| node |
	node := historyTree selection.
	historyList removeMatching: [:visit | visit key = node].
	historyTree model remove: node.
	self invalidateUserInterface!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream nextPutAll: '[ :aMethodExplorer | aMethodExplorer historyTree model: '.
	self historyTree model literalStoreEvaluationOn: aWriteStream.
	aWriteStream
		nextPut: $.;
		cr.
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aMethodExplorer.'.
	aWriteStream nextPutAll: ']'!

selectFirstMethod
	^browserPresenter hasMethods 
		ifTrue: [browserPresenter selection: browserPresenter list first]
		ifFalse: [self setVisitTimer]!

setVisitTimer
	self view setTimer: 1 interval: self class historyDwellTime!

slideyPinNames
	^super slideyPinNames , #('historySlidey')! !
!Tools.MethodExplorerShell categoriesForMethods!
addSearch:under:!public! !
addToCommandRoute:!commands!public! !
browseMethodsIn:!public! !
browseMethodsInEnvironments:!public! !
buildHistoryFutureMenu!helpers!menus!private! !
buildHistoryMenu:command:!helpers!menus!private! !
buildHistoryPastMenu!helpers!menus!private! !
buildPopupForCommand:!event handling!private! !
canSaveState!private!saved state! !
clearSelection!commands!public! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultHelpId!public! !
deleteItCommand!helpers!private! !
hasFuture!public!testing! !
hasPast!public!testing! !
historySkip:!commands!private! !
historyTree!public! !
initialize!initializing!private! !
isSameMethod:as:!helpers!private! !
killVisitTimer!helpers!private! !
methods:!accessing!public! !
onMethodSelected!event handling!private! !
onTimerTick:!event handling!private! !
onTipTextRequired:!event handling!private! !
onTreeSelectionChanged!event handling!private! !
onViewOpened!event handling!private! !
queryCommand:!commands!private! !
recordMethodVisit!helpers!private! !
removeHistoryNode!helpers!private! !
saveStateOn:!private!saved state! !
selectFirstMethod!event handling!private! !
setVisitTimer!helpers!private! !
slideyPinNames!accessing!private! !
!

!Tools.MethodExplorerShell class methodsFor!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironment 
	| browser |
	browser := self show.
	browser browseMethodsInEnvironments: aCollectionOfBrowserEnvironment.
	^browser!

defaultDefaultSlideyPinsMap
	^##(IdentityDictionary new
		at: #historySlidey put: true;
		yourself)!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Method Explorer'!

historyListSize
	self ensureOptionsLoaded.
	^HistoryListSize!

historyListSize: anInteger 
	self historyListSize = anInteger ifTrue: [^self].
	HistoryListSize := anInteger.
	self persistOptions!

initialize
	"private -- class-side initalisation.

		self initialize.
	"

	SmalltalkSystem current registerTool: self!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 551 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1845352688 170 192 34 12 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Image_tools nil 1310982 ##(Core.MessageSequence) 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 866 63 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 866 193 193 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 7 nil nil nil 1008 738 ##(UI.Toolbar) #resource_Search_tools nil 770 34 1 818 #createAt:extent: 34 2 866 615 1 866 437 51 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 960 976 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 34 1 818 #createAt:extent: 34 2 866 63 1 866 553 51 1232 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 960 976 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1456 nil nil nil 7 nil nil nil 1456 738 ##(UI.Toolbar) #resource_Find_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1297 1 866 109 51 1456 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 190 2 0 0 25 0 0 0] 960 976 nil 27 8 'findTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1680 nil nil nil 7 nil nil nil 1680 738 ##(UI.Toolbar) #resource_History_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1405 1 866 169 51 1680 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 2 0 0 0 0 0 0 18 3 0 0 25 0 0 0] 960 976 nil 27 8 'historyTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1904 nil nil nil 7 nil nil nil 1904 738 ##(UI.Toolbar) #resource_Edit_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1051 1 866 247 51 1904 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 960 976 nil 27 8 'editTools' nil nil nil 170 192 960 138 144 960 nil nil 1 nil 866 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1779 51 528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 34 6 672 1232 1008 1904 1456 1680 976 nil 29 410 ##(UI.StatusBar) 34 21 nil 416 34 2 8 1140853004 1 2352 nil nil nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 866 193 193 nil 2352 nil 8 1844906000 170 192 34 6 1050438 1 ##(UI.StatusBarItem) 8193 45 2352 nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 6 1 2592 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 ##(Kernel.VariableBinding) #'Tools.SmalltalkSystem' ##(Tools.SmalltalkSystem) ##(Smalltalk) 1 #current #changedIcon #imageIndex #ifTrue: 2608 7 257 nil 2594 0 nil 2626 3 1 2592 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2736 #ifTrue: 7 257 nil 8 'modified' 2562 8705 351 2352 nil 786950 ##(Core.Message) #displayString 8 #() 2866 #iconImageIndex 8 #() 2594 0 nil 2626 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2944 7 257 nil 8 'namespace' 2562 8193 -1 2352 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'errors' nil nil nil 34 3 2576 3056 2848 1311814 1 ##(UI.StatusBarNullItem) 8705 1 2352 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 713 866 1779 41 2352 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 8 #() 976 nil 29 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3280 nil nil nil 7 nil nil nil 3280 498 1 1 nil nil nil nil 410 ##(UI.ContainerView) 34 15 nil 3280 34 2 8 1409286144 131073 3360 nil nil nil 7 nil nil nil 3360 1376774 ##(UI.ProportionalLayout) 170 176 960 true 170 192 34 2 410 ##(UI.ReferenceView) 34 14 nil 3360 34 2 8 1140916224 131073 3504 nil nil nil 7 nil nil nil 3504 738 ##(Tools.MethodWorkspace) #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 1 337 866 1779 327 3504 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 960 976 nil 27 8 'source' nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1779 663 3360 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 3360 34 2 8 1140850688 131073 3872 nil nil nil 7 nil nil nil 3872 3426 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 3872 34 2 8 1140850688 1 4016 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 4016 nil 1 #left nil nil nil 866 1 1 866 9 9 nil 4112 nil 770 34 1 818 #createAt:extent: 34 2 866 885 1 866 11 327 4016 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 8 #() 976 nil 27 1 false 170 192 34 4 410 ##(UI.ReferenceView) 34 14 nil 3872 34 2 8 1140850688 131073 4320 nil nil nil 7 nil nil nil 4320 738 ##(Tools.MethodBrowser) #resource_Method_browser_method_list nil 770 34 1 818 #createAt:extent: 34 2 866 895 1 866 885 327 4320 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 960 976 nil 27 8 'methodlist' 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 3872 34 2 8 1409286144 131073 4544 nil nil nil 519 nil nil nil 4544 853318 1 ##(UI.CardLayout) 138 144 34 1 3986 8 'History' 410 ##(UI.TreeView) 34 27 nil 410 ##(UI.SlidingCardTray) 34 22 nil 4544 34 2 8 1140850688 131073 4736 nil nil nil 7 nil nil nil 4736 4624 170 192 34 2 4704 8 'historyTree' nil 410 ##(UI.TabViewXP) 34 28 nil 4544 34 2 8 1140851328 1 4848 787270 2 ##(UI.ListModel) 138 144 34 1 4688 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 1 nil nil nil 4848 nil 8 1845140336 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 885 327 4848 818 #setSingleSelection: 8 #(1) 4848 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4848 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 8 #() 976 nil 27 nil 4544 866 33 33 1246790 1 ##(UI.ButtonInteractor) 4736 nil 1 1180166 ##(Graphics.Rectangle) 866 785 3 866 817 35 nil 1377606 4 ##(UI.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 57 9 866 821 311 4736 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 34 1 4704 976 nil 27 34 2 8 1140916775 1025 4704 787526 3 ##(UI.TreeModel) nil 4992 721670 ##(UI.TreeNode) nil nil nil 170 192 960 608 nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1 5378 #browseMessageDefinitions 8 '&Definitions of…' 1 1 nil nil nil 5730 1 5378 #browseMessageReferences 8 '&References to…' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 5730 1 5378 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4704 nil 8 1845104592 2866 #displayString 8 #() ##(UI.IconicListAbstract) 5040 nil nil nil nil nil 170 176 960 nil #noIcons 1 170 192 960 770 34 2 818 #createAt:extent: 34 2 866 1 37 866 821 275 4704 818 #contextMenu: 34 1 5696 4704 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 154 1 0 0 155 0 0 0] 8 #() 976 nil 27 4704 nil nil nil 170 192 960 nil 4848 4736 866 201 201 401 1 31 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 885 327 4544 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 34 2 4736 4848 976 nil 27 8 'historySlidey' nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1779 327 3872 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 34 3 4544 4016 4320 976 nil 27 410 ##(UI.Splitter) 34 12 nil 3360 34 2 8 1140850688 1 6528 nil nil nil 519 nil nil nil 4082 6528 nil 1 #left nil nil nil 4112 4128 nil 4112 nil 770 34 1 818 #createAt:extent: 34 2 866 1 327 866 1779 11 6528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 8 #() 976 nil 27 3504 976 nil 27 170 192 34 2 3360 8 'browser' nil 770 34 1 818 #createAt:extent: 34 2 866 1 51 866 1779 663 3280 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 34 1 3360 976 nil 27 170 192 34 4 528 8 'toolbar' 2352 8 'statusbar' nil 658246 4 ##(UI.MenuBar) nil true 34 8 5682 nil true 34 8 5730 1 5378 #fileNew 8 '&New Workspace' 9373 1 852806 4 ##(Graphics.Icon) nil true 2819078 ##(Graphics.ImageFromStringResourceInitializer) 8 'NewWorkspace.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr8.dll' nil 65541 nil nil nil 5730 1 5378 #fileOpen 8 '&Open Workspace…' 9375 1 7138 nil true 7170 8 'OpenWorkspace.ico' 7232 65541 nil nil nil 5730 1 5378 #fileFileIn 8 '&File In…' 1 1 7138 nil true 7170 8 'FileIn.ico' 7232 65541 nil nil nil 5842 4097 5730 1 5378 #saveImage 8 'Sa&ve Image' 1 1 7138 nil true 7170 8 'Snapshot.ico' 7232 65541 nil nil nil 5730 1 5378 #smalltalkExit 8 'E&xit Dolphin' 1 1 7138 nil true 7170 8 'PowerSwitch.ico' 7232 65541 nil nil nil 5842 4097 5730 1 5378 #exit 8 '&Close' 17639 1 1378630 2 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 29895 nil nil 5682 nil true 34 13 5730 1 5378 #undo 8 '&Undo' 9397 1 7138 nil true 7170 8 'EditUndo.ico' 7232 65541 nil nil nil 5842 4097 5730 1 5378 #cutSelection 8 'Cu&t' 9393 1 7138 nil true 7170 8 'EditCut.ico' 7232 65541 nil nil nil 5730 1 5378 #copySelection 8 '&Copy' 9351 1 7138 nil true 7170 8 'EditCopy.ico' 7232 65541 nil nil nil 5730 1 5378 #pasteClipboard 8 '&Paste' 9389 1 7138 nil true 7170 8 'EditPaste.ico' 7232 65541 nil nil nil 5730 1 5378 #editDelete 8 '&Delete' 1 1 7138 nil true 7170 8 'EditClear.ico' 7232 65541 nil nil nil 5682 nil true 34 2 5730 1 5378 #reformatSource 8 '&Source' 9391 1 nil nil nil 5730 1 5378 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 29911 nil nil 5842 4097 5730 1 5378 #selectAll 8 'Select &All' 9347 1 nil nil nil 5842 4097 5730 1 5378 #editFind 8 '&Find…' 9357 1 7138 nil true 2425862 ##(Graphics.ImageFromResourceInitializer) 47 983302 ##(OS.ShellLibrary) 65541 nil nil nil 5730 1 5378 #findNext 8 'Find &Next' 1253 1 7138 nil true 7170 8 'FindNext.ico' 7232 65541 nil nil nil 5730 1 5378 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 29921 nil nil 5682 nil true 34 17 5730 1 5378 #browseIt 8 '&Browse It' 9349 1 7138 nil true 7170 8 'ClassBrowserShell.ico' 7232 65541 nil nil nil 5730 1 5378 #displayIt 8 '&Display It' 9353 1 7138 nil true 7170 8 'DisplayIt.ico' 7232 65541 nil nil nil 5730 1 5378 #printIt 8 '&Print It' 9377 1 7138 nil true 7170 8 'PrintIt.ico' 7232 65541 nil nil nil 5730 1 5378 #evaluateIt 8 '&Evaluate It' 9355 1 7138 nil true 7170 8 'EvaluateIt.ico' 7232 65541 nil nil nil 5730 1 5378 #inspectIt 8 '&Inspect It' 9363 1 7138 nil true 7170 8 'InspectIt.ico' 7232 65541 nil nil nil 5730 1 5378 #debugIt 8 'Deb&ug It' 1269 1 7138 nil true 7170 8 'Debugger.ico' 7232 65541 nil nil nil 5730 1 5378 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5842 4097 5730 1 5378 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5730 1 5378 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 5842 4097 5730 2097153 5378 #accept 8 '&Accept' 9383 1 nil nil nil 5730 1 5378 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5842 4097 5682 nil true 34 14 5730 1 5378 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 5842 4097 5730 1 5378 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 5730 1 5378 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 5730 1 5378 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 5730 1 5378 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5842 4097 5730 1 5378 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5730 1 5378 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5730 1 5378 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5842 4097 5730 1 5378 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 5730 1 5378 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5730 1 5378 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 7138 nil true 7170 8 'Refactoring.ico' 7232 65541 nil nil 29967 nil nil 5842 4097 5682 nil true 34 7 5730 1 5378 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5730 1 5378 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5730 1 5378 #toggleLineEndings 8 'Line &Endings' 1 1 7730 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5730 1 5378 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5730 1 5378 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5730 1 5378 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5730 1 5378 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 7138 nil true 7170 8 'Preferences.ico' 7232 65541 nil nil 29983 nil nil 8 '&Workspace' nil 134217729 nil nil 29985 nil nil 5682 nil true 34 11 5682 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil 29987 nil nil 5682 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil 29989 nil nil 5682 nil true 34 11 5730 1 5378 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 5730 1 5378 #browseContainingText 8 'C&ontaining Text…' 1 1 7138 nil true 7170 8 'SearchText.ico' 7232 65541 nil nil nil 5730 1 5378 #browseMethodCategory 8 'Cate&gory…' 1 1 7138 nil true 7170 8 'Category.ico' 7232 65541 nil nil nil 5730 1 5378 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5730 1 5378 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5842 4097 5730 1 5378 #browseMethodPackages 8 'Package <s>' 1 1 7138 nil true 7170 8 'Package.ico' 7232 65541 nil nil nil 5730 1 5378 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 5842 4097 5730 1 5378 #browseMethodHistory 8 '&Change History' 1 1 7138 nil true 7170 8 'MethodHistory.ico' 7232 65541 nil nil nil 5730 1 5378 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 30009 nil nil 5842 4097 5730 1 5378 #removeMethod 8 'Re&move' 1 1 7138 nil true 7170 8 'MethodDelete.ico' 7232 65541 nil nil nil 5682 nil true 34 16 5730 1 5378 #renameMethod 8 'Re&name' 1 1 nil nil nil 5730 1 5378 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 5842 4097 5730 1 5378 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 5682 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 30019 nil nil 5682 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 30021 nil nil 5682 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 30023 nil nil 5842 4097 5682 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 30025 nil nil 5682 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 30027 nil nil 5842 4097 5730 1 5378 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5730 1 5378 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5730 1 5378 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5730 1 5378 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5730 1 5378 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 7138 nil true 7170 8 'Refactoring.ico' 7232 65541 nil nil 30039 nil nil 5842 4097 5730 1 5378 #methodPackage 8 '&Package…' 1 1 7138 nil true 7170 8 'Package.ico' 7232 65541 nil nil nil 5682 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 30043 nil nil 5682 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil 30045 nil nil 5730 1 5378 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 30049 nil nil 5682 nil true 34 3 5730 1 5378 #undoChange 8 '&Undo <1d>' 1 1 7138 nil true 7170 8 'EditUndo.ico' 7232 65541 nil nil nil 5730 1 5378 #redoChange 8 '&Redo <1d>' 1 1 7138 nil true 7170 8 'EditRedo.ico' 7232 65541 nil nil nil 5730 1 5378 #clearChangeHistory 8 'Clear Change &History' 1 1 7138 nil true 7170 8 'MethodHistoryErase.ico' 7232 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 30057 nil nil 5682 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 30059 nil nil 5682 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 30061 nil nil 5682 nil true 34 15 5730 1 5378 #helpContents 8 '&Contents' 1025 1 7138 nil true 7170 8 'Help.ico' 7232 65541 nil nil nil 5730 1 5378 #help 8 'On this &Tool' 1249 1 nil nil nil 5730 1 5378 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5842 4097 5730 1 5378 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7730 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 5842 4097 5730 1 5378 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5730 1 5378 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5730 1 5378 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5842 4097 5730 1 5378 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 7138 nil true 7170 8 '!!APPLICATION' 7232 65541 nil nil nil 5730 1 5378 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5730 1 5378 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5842 4097 5730 1 5378 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7730 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 30085 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 2 818 #createAt:extent: 34 2 866 12287 21 866 1811 871 416 818 #text: 34 1 8 'Method Explorer' 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 136 27 0 0 189 1 0 0] 34 3 528 3280 2352 976 nil 27 )! !
!Tools.MethodExplorerShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
defaultDefaultSlideyPinsMap!constants!options!private! !
displayOn:!displaying!public! !
historyListSize!accessing!public! !
historyListSize:!accessing!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

