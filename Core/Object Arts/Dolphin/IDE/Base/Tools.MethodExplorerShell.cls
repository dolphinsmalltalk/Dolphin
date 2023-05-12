"Filed out from Dolphin Smalltalk"!

Tools.MethodBrowserShell
	subclass: #'Tools.MethodExplorerShell'
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

addToCommandRoute: aCommandPolicy
	"Update the command routing path of the <CommandPolicy> argument with the receiver's contribution to the command path. "

	"Implementation Note: We want to make sure that the methods presenter is always in the route, and that it appears before SmalltalkSystem (added by the supersend) but after the receiver (if not already in the route)."

	aCommandPolicy
		appendTarget: self;
		appendTarget: browserPresenter.
	^super addToCommandRoute: aCommandPolicy!

browseMethodsIn: aBrowserEnvironment 
	self addSearch: aBrowserEnvironment under: historyTree selectionOrNil.
	historyTree selection: aBrowserEnvironment.
	self setInitialFocus!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironments
	(aCollectionOfBrowserEnvironments inject: nil
		into: 
			[:first :each |
			self addSearch: each under: historyTree selectionOrNil.
			first ?? each])
			ifNotNil: [:first | historyTree selection: first].
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
					[methods := Set new.
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

futureSize
	^historyList futureSize!

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
	browserPresenter clearErrors.
	method := nil.
	visit value
		ifNotNil: 
			[:name |
			method := name valueOrNil.
			method isNil
				ifTrue: 
					[self statusText: ('<1p> has been deleted' expandMacrosWith: method).
					Sound warningBeep]].
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

pastSize
	^historyList pastSize!

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
	^super queryCommand: aCommandQuery!

queryHistoryBack: aCommandQuery
	self hasPast
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: { historyList previous }
							locale: Locale smalltalk)]
		ifFalse: 
			[aCommandQuery
				isEnabled: false;
				text: 'Back']!

queryHistoryForward: aCommandQuery
	self hasFuture
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: { historyList next }
							locale: Locale smalltalk)]
		ifFalse: 
			[aCommandQuery
				isEnabled: false;
				text: 'Forward']!

recordMethodVisit
	"Private - Add to the visit history - note that the current item is at the top of the history list"

	| node method pair |
	node := historyTree selectionOrNil.
	node isNil ifTrue: [^self].
	method := self selectedMethod.
	pair := node -> (method ifNotNil: [MethodName method: method]).
	(historyList isEmpty or: [historyList current ~= pair])
		ifTrue: 
			[historyList addLast: pair.
			self invalidateUserInterface]
		ifFalse: [historyList current: pair]!

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
futureSize!accessing!public! !
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
pastSize!accessing!public! !
queryCommand:!commands!private! !
queryHistoryBack:!commands!private! !
queryHistoryForward:!commands!private! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 #{Graphics.Color} #default 8 1815075056 170 192 34 12 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Image_tools nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 866 63 51 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 866 193 193 nil 27 8 'imageTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1008 nil nil nil 7 nil nil nil 1008 738 #{UI.Toolbar} #resource_History_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1405 1 866 169 51 1008 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 2 0 0 0 0 0 0 18 3 0 0 25 0 0 0] 960 976 nil 27 8 'historyTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1232 nil nil nil 7 nil nil nil 1232 738 #{UI.Toolbar} #resource_Edit_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1051 1 866 247 51 1232 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 960 976 nil 27 8 'editTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1456 nil nil nil 7 nil nil nil 1456 738 #{UI.Toolbar} #resource_Smalltalk_tools nil 770 34 1 818 #createAt:extent: 34 2 866 63 1 866 553 51 1456 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 960 976 nil 27 8 'smalltalkTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1680 nil nil nil 7 nil nil nil 1680 738 #{UI.Toolbar} #resource_Search_tools nil 770 34 1 818 #createAt:extent: 34 2 866 615 1 866 437 51 1680 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 960 976 nil 27 8 'searchTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1904 nil nil nil 7 nil nil nil 1904 738 #{UI.Toolbar} #resource_Find_tools nil 770 34 1 818 #createAt:extent: 34 2 866 1297 1 866 109 51 1904 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 190 2 0 0 25 0 0 0] 960 976 nil 27 8 'findTools' nil nil nil 170 192 960 138 144 960 nil nil 1 nil 866 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1779 51 528 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 34 6 672 1456 1680 1232 1904 1008 976 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140853004 1 2352 nil nil nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 866 193 193 nil 2352 nil 8 1814628368 170 192 34 6 1050438 1 #{UI.StatusBarItem} 8193 45 2352 nil nil 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 6 1 2592 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 #{Kernel.VariableBinding} #'Tools.SmalltalkSystem' #{Tools.SmalltalkSystem} #{Smalltalk} 1 #current #changedIcon #imageIndex #ifTrue: 2608 7 257 nil 2594 0 nil 2626 3 1 2592 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2736 #ifTrue: 7 257 nil 8 'modified' 2562 8705 351 2352 nil 786950 #{Core.Message} #displayString 8 #() 2866 #iconImageIndex 8 #() 2594 0 nil 2626 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2944 7 257 nil 8 'namespace' 2562 8193 -1 2352 nil 2866 #displayString 960 2866 #iconImageIndex 960 nil 8 'errors' nil nil nil 34 3 2576 3056 2848 1311814 1 #{UI.StatusBarNullItem} 8705 1 2352 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 713 866 1779 41 2352 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 8 #() 976 nil 29 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 3312 nil nil nil 7 nil nil nil 3312 498 1 1 nil nil nil nil 410 #{UI.ContainerView} 34 15 nil 3312 34 2 8 1409286144 131073 3392 nil nil nil 7 nil nil nil 3392 1376774 #{UI.ProportionalLayout} 170 176 960 true 170 192 34 2 410 #{UI.ReferenceView} 34 14 nil 3392 34 2 8 1140916224 131073 3536 nil nil nil 7 nil nil nil 3536 738 #{Tools.MethodWorkspace} #resource_Default_view nil 770 34 1 818 #createAt:extent: 34 2 866 1 337 866 1779 327 3536 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 960 976 nil 27 8 'source' nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1779 663 3392 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 34 3 410 #{UI.ContainerView} 34 15 nil 3392 34 2 8 1140850688 131073 3904 nil nil nil 7 nil nil nil 3904 3458 138 #{Core.Dictionary} 34 1 1049094 #{Core.Association} 410 #{UI.Splitter} 34 12 nil 3904 34 2 8 1140850688 1 4048 nil nil nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 4048 nil 1 #left nil nil nil 866 1 1 866 9 9 nil 4144 nil 770 34 1 818 #createAt:extent: 34 2 866 885 1 866 11 327 4048 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 8 #() 976 nil 27 1 false 170 192 34 4 410 #{UI.ReferenceView} 34 14 nil 3904 34 2 8 1140850688 131073 4352 nil nil nil 7 nil nil nil 4352 738 #{Tools.MethodBrowser} #resource_Method_browser_method_list nil 770 34 1 818 #createAt:extent: 34 2 866 895 1 866 885 327 4352 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 960 976 nil 27 8 'methodlist' 410 #{UI.SlideyInneyOuteyThing} 34 23 nil 3904 34 2 8 1409286144 131073 4576 nil nil nil 519 nil nil nil 4576 853318 1 #{UI.CardLayout} 138 144 34 1 4018 8 'History' 410 #{UI.TreeView} 34 27 nil 410 #{UI.SlidingCardTray} 34 22 nil 4576 34 2 8 1140850688 131073 4768 nil nil nil 7 nil nil nil 4768 4656 170 192 34 2 4736 8 'historyTree' nil 410 #{UI.TabViewXP} 34 28 nil 4576 34 2 8 1140851328 1 4880 787270 2 #{UI.ListModel} 138 144 34 1 4720 nil 1769478 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 4880 nil 8 1814862704 3072 3088 1639750 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 770 34 3 818 #createAt:extent: 34 2 866 1 1 866 885 327 4880 818 #setSingleSelection: 8 #(1) 4880 818 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4880 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 8 #() 976 nil 27 nil 4576 866 33 33 1246790 1 #{UI.ButtonInteractor} 4768 nil 1 1180166 #{Graphics.Rectangle} 866 785 3 866 817 35 nil 1377606 4 #{UI.CommandDescription} #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 34 1 818 #createAt:extent: 34 2 866 57 9 866 821 311 4768 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 34 1 4736 976 nil 27 34 2 8 1140916775 1025 4736 787526 3 #{UI.TreeModel} nil 5024 721670 #{UI.TreeNode} nil nil nil 170 192 960 608 nil 7 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 5410 #browseMessageDefinitions 8 '&Definitions of…' 1 1 nil nil nil 5762 1 5410 #browseMessageReferences 8 '&References to…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 5762 1 5410 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4736 nil 8 1814826960 2866 #displayString 8 #() 3088 5072 nil nil nil nil nil 170 176 960 nil #noIcons 1 170 192 960 770 34 2 818 #createAt:extent: 34 2 866 1 37 866 821 275 4736 818 #contextMenu: 34 1 5728 4736 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 154 1 0 0 155 0 0 0] 8 #() 976 nil 27 4736 nil nil nil 170 192 960 nil 4880 4768 866 201 201 401 1 31 nil nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 885 327 4576 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 34 2 4768 4880 976 nil 27 8 'historySlidey' nil 770 34 1 818 #createAt:extent: 34 2 866 1 1 866 1779 327 3904 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 34 3 4576 4048 4352 976 nil 27 410 #{UI.Splitter} 34 12 nil 3392 34 2 8 1140850688 1 6560 nil nil nil 519 nil nil nil 4114 6560 nil 1 #left nil nil nil 4144 4160 nil 4144 nil 770 34 1 818 #createAt:extent: 34 2 866 1 327 866 1779 11 6560 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 8 #() 976 nil 27 3536 976 nil 27 170 192 34 2 3392 8 'browser' nil 770 34 1 818 #createAt:extent: 34 2 866 1 51 866 1779 663 3312 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 34 1 3392 976 nil 27 170 192 34 4 528 8 'toolbar' 2352 8 'statusbar' nil 658246 4 #{UI.MenuBar} nil true 34 8 5714 nil true 34 8 5762 1 5410 #fileNew 8 '&New Workspace' 9373 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 5762 1 5410 #fileOpen 8 '&Open Workspace…' 9375 1 7170 nil true 7202 8 'OpenWorkspace.ico' 7264 65541 nil nil nil 5762 1 5410 #fileFileIn 8 '&File In…' 1 1 7170 nil true 7202 8 'FileIn.ico' 7264 65541 nil nil nil 5874 4097 5762 1 5410 #saveImage 8 'Sa&ve Image' 1 1 7170 nil true 7202 8 'Snapshot.ico' 7264 65541 nil nil nil 5762 1 5410 #smalltalkExit 8 'E&xit Dolphin' 1 1 7170 nil true 7202 8 'PowerSwitch.ico' 7264 65541 nil nil nil 5874 4097 5762 1 5410 #exit 8 '&Close' 17639 1 1378630 2 #{Graphics.TextTileIcon} $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 33939 nil nil 5714 nil true 34 13 5762 1 5410 #undo 8 '&Undo' 9397 1 7170 nil true 7202 8 'EditUndo.ico' 7264 65541 nil nil nil 5874 4097 5762 1 5410 #cutSelection 8 'Cu&t' 9393 1 7170 nil true 7202 8 'EditCut.ico' 7264 65541 nil nil nil 5762 1 5410 #copySelection 8 '&Copy' 9351 1 7170 nil true 7202 8 'EditCopy.ico' 7264 65541 nil nil nil 5762 1 5410 #pasteClipboard 8 '&Paste' 9389 1 7170 nil true 7202 8 'EditPaste.ico' 7264 65541 nil nil nil 5762 1 5410 #editDelete 8 '&Delete' 1 1 7170 nil true 7202 8 'EditClear.ico' 7264 65541 nil nil nil 5714 nil true 34 2 5762 1 5410 #reformatSource 8 '&Source' 9391 1 nil nil nil 5762 1 5410 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 33955 nil nil 5874 4097 5762 1 5410 #selectAll 8 'Select &All' 9347 1 nil nil nil 5874 4097 5762 1 5410 #editFind 8 '&Find…' 9357 1 7170 nil true 2425862 #{Graphics.ImageFromResourceInitializer} 47 983302 #{OS.ShellLibrary} 65541 nil nil nil 5762 1 5410 #findNext 8 'Find &Next' 1253 1 7170 nil true 7202 8 'FindNext.ico' 7264 65541 nil nil nil 5762 1 5410 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 33965 nil nil 5714 nil true 34 17 5762 1 5410 #browseIt 8 '&Browse It' 9349 1 7170 nil true 7202 8 'ClassBrowserShell.ico' 7264 65541 nil nil nil 5762 1 5410 #displayIt 8 '&Display It' 9353 1 7170 nil true 7202 8 'DisplayIt.ico' 7264 65541 nil nil nil 5762 1 5410 #printIt 8 '&Print It' 9377 1 7170 nil true 7202 8 'PrintIt.ico' 7264 65541 nil nil nil 5762 1 5410 #evaluateIt 8 '&Evaluate It' 9355 1 7170 nil true 7202 8 'EvaluateIt.ico' 7264 65541 nil nil nil 5762 1 5410 #inspectIt 8 '&Inspect It' 9363 1 7170 nil true 7202 8 'InspectIt.ico' 7264 65541 nil nil nil 5762 1 5410 #debugIt 8 'Deb&ug It' 1269 1 7170 nil true 7202 8 'Debugger.ico' 7264 65541 nil nil nil 5762 1 5410 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5874 4097 5762 1 5410 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5762 1 5410 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 5874 4097 5762 2097153 5410 #accept 8 '&Accept' 9383 1 nil nil nil 5762 1 5410 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5874 4097 5714 nil true 34 14 5762 1 5410 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 5874 4097 5762 1 5410 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 5762 1 5410 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 5762 1 5410 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 5762 1 5410 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5874 4097 5762 1 5410 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5762 1 5410 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5762 1 5410 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5874 4097 5762 1 5410 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 5762 1 5410 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5762 1 5410 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 7170 nil true 7202 8 'Refactoring.ico' 7264 65541 nil nil 34011 nil nil 5874 4097 5714 nil true 34 7 5762 1 5410 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5762 1 5410 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5762 1 5410 #toggleLineEndings 8 'Line &Endings' 1 1 7762 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5762 1 5410 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5762 1 5410 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5762 1 5410 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5762 1 5410 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 7170 nil true 7202 8 'Preferences.ico' 7264 65541 nil nil 34027 nil nil 8 '&Workspace' nil 134217729 nil nil 34029 nil nil 5714 nil true 34 11 5714 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil 34031 nil nil 5714 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil 34033 nil nil 5714 nil true 34 11 5762 1 5410 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 5762 1 5410 #browseContainingText 8 'C&ontaining Text…' 1 1 7170 nil true 7202 8 'SearchText.ico' 7264 65541 nil nil nil 5762 1 5410 #browseMethodCategory 8 'Cate&gory…' 1 1 7170 nil true 7202 8 'Category.ico' 7264 65541 nil nil nil 5762 1 5410 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5762 1 5410 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5874 4097 5762 1 5410 #browseMethodPackages 8 'Package <s>' 1 1 7170 nil true 7202 8 'Package.ico' 7264 65541 nil nil nil 5762 1 5410 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 5874 4097 5762 1 5410 #browseMethodHistory 8 '&Change History' 1 1 7170 nil true 7202 8 'MethodHistory.ico' 7264 65541 nil nil nil 5762 1 5410 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 34053 nil nil 5874 4097 5762 1 5410 #removeMethod 8 'Re&move' 1 1 7170 nil true 7202 8 'MethodDelete.ico' 7264 65541 nil nil nil 5714 nil true 34 16 5762 1 5410 #renameMethod 8 'Re&name' 1 1 nil nil nil 5762 1 5410 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 5874 4097 5762 1 5410 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 5714 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 34063 nil nil 5714 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 34065 nil nil 5714 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 34067 nil nil 5874 4097 5714 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 34069 nil nil 5714 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 34071 nil nil 5874 4097 5762 1 5410 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5762 1 5410 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5762 1 5410 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5762 1 5410 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5762 1 5410 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 7170 nil true 7202 8 'Refactoring.ico' 7264 65541 nil nil 34083 nil nil 5874 4097 5762 1 5410 #methodPackage 8 '&Package…' 1 1 7170 nil true 7202 8 'Package.ico' 7264 65541 nil nil nil 5714 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 34087 nil nil 5714 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil 34089 nil nil 5762 1 5410 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 34093 nil nil 5714 nil true 34 3 5762 1 5410 #undoChange 8 '&Undo <1d>' 1 1 7170 nil true 7202 8 'EditUndo.ico' 7264 65541 nil nil nil 5762 1 5410 #redoChange 8 '&Redo <1d>' 1 1 7170 nil true 7202 8 'EditRedo.ico' 7264 65541 nil nil nil 5762 1 5410 #clearChangeHistory 8 'Clear Change &History' 1 1 7170 nil true 7202 8 'MethodHistoryErase.ico' 7264 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 34101 nil nil 5714 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 34103 nil nil 5714 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 34105 nil nil 5714 nil true 34 15 5762 1 5410 #helpContents 8 '&Contents' 1025 1 7170 nil true 7202 8 'Help.ico' 7264 65541 nil nil nil 5762 1 5410 #help 8 'On this &Tool' 1249 1 nil nil nil 5762 1 5410 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5874 4097 5762 1 5410 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7762 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 5874 4097 5762 1 5410 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5762 1 5410 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5762 1 5410 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5874 4097 5762 1 5410 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 7170 nil true 7202 8 '!!APPLICATION' 7264 65541 nil nil nil 5762 1 5410 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5762 1 5410 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5874 4097 5762 1 5410 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7762 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 34129 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 34 2 818 #createAt:extent: 34 2 866 12287 21 866 1811 871 416 818 #text: 34 1 8 'Method Explorer' 416 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 136 27 0 0 189 1 0 0] 34 3 528 3312 2352 976 nil 27)! !
!Tools.MethodExplorerShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
defaultDefaultSlideyPinsMap!constants!options!private! !
displayOn:!displaying!public! !
historyListSize!accessing!public! !
historyListSize:!accessing!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

