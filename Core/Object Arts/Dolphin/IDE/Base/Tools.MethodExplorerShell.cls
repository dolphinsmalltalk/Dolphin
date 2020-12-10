"Filed out from Dolphin Smalltalk 7"!

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
!Tools.MethodExplorerShell categoriesFor: #addSearch:under:!public! !
!Tools.MethodExplorerShell categoriesFor: #addToCommandRoute:!commands!public! !
!Tools.MethodExplorerShell categoriesFor: #browseMethodsIn:!public! !
!Tools.MethodExplorerShell categoriesFor: #browseMethodsInEnvironments:!public! !
!Tools.MethodExplorerShell categoriesFor: #buildHistoryFutureMenu!helpers!menus!private! !
!Tools.MethodExplorerShell categoriesFor: #buildHistoryMenu:command:!helpers!menus!private! !
!Tools.MethodExplorerShell categoriesFor: #buildHistoryPastMenu!helpers!menus!private! !
!Tools.MethodExplorerShell categoriesFor: #buildPopupForCommand:!event handling!private! !
!Tools.MethodExplorerShell categoriesFor: #canSaveState!private!saved state! !
!Tools.MethodExplorerShell categoriesFor: #clearSelection!commands!public! !
!Tools.MethodExplorerShell categoriesFor: #createComponents!initializing!public! !
!Tools.MethodExplorerShell categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.MethodExplorerShell categoriesFor: #defaultHelpId!public! !
!Tools.MethodExplorerShell categoriesFor: #deleteItCommand!helpers!private! !
!Tools.MethodExplorerShell categoriesFor: #hasFuture!public!testing! !
!Tools.MethodExplorerShell categoriesFor: #hasPast!public!testing! !
!Tools.MethodExplorerShell categoriesFor: #historySkip:!commands!private! !
!Tools.MethodExplorerShell categoriesFor: #historyTree!public! !
!Tools.MethodExplorerShell categoriesFor: #initialize!initializing!private! !
!Tools.MethodExplorerShell categoriesFor: #isSameMethod:as:!helpers!private! !
!Tools.MethodExplorerShell categoriesFor: #killVisitTimer!helpers!private! !
!Tools.MethodExplorerShell categoriesFor: #methods:!accessing!public! !
!Tools.MethodExplorerShell categoriesFor: #onMethodSelected!event handling!private! !
!Tools.MethodExplorerShell categoriesFor: #onTimerTick:!event handling!private! !
!Tools.MethodExplorerShell categoriesFor: #onTipTextRequired:!event handling!private! !
!Tools.MethodExplorerShell categoriesFor: #onTreeSelectionChanged!event handling!private! !
!Tools.MethodExplorerShell categoriesFor: #onViewOpened!event handling!private! !
!Tools.MethodExplorerShell categoriesFor: #queryCommand:!commands!private! !
!Tools.MethodExplorerShell categoriesFor: #recordMethodVisit!helpers!private! !
!Tools.MethodExplorerShell categoriesFor: #removeHistoryNode!helpers!private! !
!Tools.MethodExplorerShell categoriesFor: #saveStateOn:!private!saved state! !
!Tools.MethodExplorerShell categoriesFor: #selectFirstMethod!event handling!private! !
!Tools.MethodExplorerShell categoriesFor: #setVisitTimer!helpers!private! !
!Tools.MethodExplorerShell categoriesFor: #slideyPinNames!accessing!private! !

!Tools.MethodExplorerShell class methodsFor!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironment 
	| browser |
	browser := self show.
	browser browseMethodsInEnvironments: aCollectionOfBrowserEnvironment.
	^browser!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Method Explorer'!

historyListSize
	^HistoryListSize ifNil: [self defaultHistoryListSize]!

historyListSize: anInteger 
	HistoryListSize := anInteger!

initialize
	"private -- class-side initalisation.

		self initialize.
	"

	Smalltalk developmentSystem registerTool: self.
	self canUseIdeaSpace: true.
	self historyListSize: nil!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 517 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 12 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Edit_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1051 1 882 247 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'editTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(UI.Toolbar) #resource_History_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1405 1 882 169 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 2 0 0 0 0 0 0 18 3 0 0 25 0 0 0] 976 992 nil 27 8 'historyTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1504 nil nil nil 7 nil nil nil 1504 738 ##(UI.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 63 51 1504 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 976 992 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1744 nil nil nil 7 nil nil nil 1744 738 ##(UI.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 615 1 882 437 51 1744 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 976 992 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1984 nil nil nil 7 nil nil nil 1984 738 ##(UI.Toolbar) #resource_Find_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1297 1 882 109 51 1984 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 190 2 0 0 25 0 0 0] 976 992 nil 27 8 'findTools' 170 192 976 138 144 976 nil nil 1 nil 882 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1779 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 34 6 1504 1024 1744 672 1984 1264 992 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2464 nil nil nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 882 193 193 nil 2464 nil 8 1801004784 170 192 34 6 1050374 ##(UI.StatusBarItem) 1 841 2464 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'errors' 2674 1 45 2464 nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 6 1 2736 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1442886 2 ##(Kernel.VariableBinding) #'Tools.SmalltalkSystem' ##(Tools.SmalltalkSystem) ##(Smalltalk) 1 #current #changedIcon #imageIndex #ifTrue: 2752 7 257 nil nil 8 'modified' 2674 1 -1 2464 nil 786950 ##(Core.Message) #displayString 8 #() ##(UI.IconicListAbstract) nil 8 'version' 34 3 2720 2688 2896 1311750 ##(UI.StatusBarNullItem) 513 1 2464 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 713 882 1779 41 2464 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 8 #() 992 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3184 nil nil nil 7 nil nil nil 3184 498 1 1 nil nil nil nil 410 ##(UI.ContainerView) 34 15 nil 3184 34 2 8 1409286144 131073 3264 nil nil nil 7 nil nil nil 3264 1376774 ##(UI.ProportionalLayout) 170 176 976 true 170 192 34 2 410 ##(UI.ReferenceView) 34 14 nil 3264 34 2 8 1140916224 131073 3408 nil nil nil 7 nil nil nil 3408 738 ##(Tools.MethodWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 337 882 1779 327 3408 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 976 992 nil 27 8 'source' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1779 663 3264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 34 3 410 ##(UI.ContainerView) 34 15 nil 3264 34 2 8 1140850688 131073 3808 nil nil nil 7 nil nil nil 3808 3330 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.Splitter) 34 12 nil 3808 34 2 8 1140850688 1 3952 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 3952 nil 1 #left nil nil nil 882 1 1 882 9 9 nil 4048 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 885 1 882 11 327 3952 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 8 #() 992 nil 27 1 false 170 192 34 4 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 3808 34 2 8 1409286144 131073 4272 nil nil nil 519 nil nil nil 4272 853318 1 ##(UI.CardLayout) 138 144 34 1 3922 8 'History' 410 ##(UI.TreeView) 34 27 nil 410 ##(UI.SlidingCardTray) 34 22 nil 4272 34 2 8 1140850688 131073 4464 nil nil nil 7 nil nil nil 4464 4352 170 192 34 2 4432 8 'historyTree' nil 410 ##(UI.TabViewXP) 34 28 nil 4272 34 2 8 1140851328 1 4576 787270 2 ##(UI.ListModel) 138 144 34 1 4416 nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 1 nil nil nil 4576 nil 8 1801049728 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 885 327 4576 834 #setSingleSelection: 8 #(1) 4576 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4576 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 8 #() 992 nil 27 nil 4272 882 33 33 1246790 1 ##(UI.ButtonInteractor) 4464 nil 1 1180166 ##(Graphics.Rectangle) 882 785 3 882 817 35 nil 1377606 4 ##(UI.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 57 9 882 821 311 4464 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 34 1 4432 992 nil 27 34 2 8 1140916775 1025 4432 787526 3 ##(UI.TreeModel) nil 4720 721670 ##(UI.TreeNode) nil nil nil 170 192 976 608 nil 7 461638 4 ##(UI.Menu) nil true 34 4 1180742 2 ##(UI.CommandMenuItem) 1 5122 #browseMessageDefinitions 8 '&Definitions of...' 1 1 nil nil nil 5490 1 5122 #browseMessageReferences 8 '&References to...' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 5490 1 5122 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4432 nil 8 1801125840 2914 #displayString 8 #() ##(UI.IconicListAbstract) 4768 nil nil nil nil nil 170 176 976 nil #noIcons 1 170 192 976 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 37 882 821 275 4432 834 #contextMenu: 34 1 5456 4432 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 154 1 0 0 155 0 0 0] 8 #() 992 nil 27 4432 nil nil nil 170 192 976 nil 4576 4464 882 201 201 401 1 31 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 885 327 4272 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 34 2 4464 4576 992 nil 27 8 'historySlidey' 410 ##(UI.ReferenceView) 34 14 nil 3808 34 2 8 1140850688 131073 6176 nil nil nil 7 nil nil nil 6176 738 ##(Tools.MethodBrowser) #resource_Method_browser_method_list nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 895 1 882 885 327 6176 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 976 992 nil 27 8 'methodlist' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1779 327 3808 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 34 3 4272 3952 6176 992 nil 27 410 ##(UI.Splitter) 34 12 nil 3264 34 2 8 1140850688 1 6576 nil nil nil 519 nil nil nil 4018 6576 nil 1 #left nil nil nil 4048 4064 nil 4048 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 327 882 1779 11 6576 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 8 #() 992 nil 27 3408 992 nil 27 170 192 34 2 3264 8 'browser' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1779 663 3184 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 34 1 3264 992 nil 27 170 192 34 4 2464 8 'statusbar' 528 8 'toolbar' nil 658246 4 ##(UI.MenuBar) nil true 34 8 5442 nil true 34 8 5490 1 5122 #fileNew 8 '&New Workspace' 9373 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5490 1 5122 #fileOpen 8 '&Open Workspace...' 9375 1 7218 nil true 7264 8 'OpenWorkspace.ico' 7312 nil nil 5490 1 5122 #fileFileIn 8 '&File In...' 1 1 7218 nil true 7264 8 'FileIn.ico' 7312 nil nil 5602 4097 5490 1 5122 #saveImage 8 'Sa&ve Image' 1 1 7218 nil true 7264 8 'Snapshot.ico' 7312 nil nil 5490 1 5122 #smalltalkExit 8 'E&xit Dolphin' 1 1 7218 nil true 7264 8 'PowerSwitch.ico' 7312 nil nil 5602 4097 5490 1 5122 #exit 8 '&Close' 17639 1 1378630 1 ##(Graphics.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 47429 nil nil 5442 nil true 34 13 5490 1 5122 #undo 8 '&Undo' 9397 1 7218 nil true 7264 8 'EditUndo.ico' 7312 nil nil 5602 4097 5490 1 5122 #cutSelection 8 'Cu&t' 9393 1 7218 nil true 7264 8 'EditCut.ico' 7312 nil nil 5490 1 5122 #copySelection 8 '&Copy' 9351 1 7218 nil true 7264 8 'EditCopy.ico' 7312 nil nil 5490 1 5122 #pasteClipboard 8 '&Paste' 9389 1 7218 nil true 7264 8 'EditPaste.ico' 7312 nil nil 5490 1 5122 #editDelete 8 '&Delete' 1 1 7218 nil true 7264 8 'EditClear.ico' 7312 nil nil 5442 nil true 34 2 5490 1 5122 #reformatSource 8 '&Source' 9391 1 nil nil nil 5490 1 5122 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 47445 nil nil 5602 4097 5490 1 5122 #selectAll 8 'Select &All' 9347 1 nil nil nil 5602 4097 5490 1 5122 #editFind 8 '&Find...' 9357 1 7218 nil true 7264 47 983302 ##(OS.ShellLibrary) nil nil 5490 1 5122 #findNext 8 'Find &Next' 1253 1 7218 nil true 7264 8 'FindNext.ico' 7312 nil nil 5490 1 5122 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 47455 nil nil 5442 nil true 34 17 5490 1 5122 #browseIt 8 '&Browse It' 9349 1 7218 nil true 7264 8 'ClassBrowserShell.ico' 7312 nil nil 5490 1 5122 #displayIt 8 '&Display It' 9353 1 7218 nil true 7264 8 'DisplayIt.ico' 7312 nil nil 5490 1 5122 #printIt 8 '&Print It' 9377 1 7218 nil true 7264 8 'PrintIt.ico' 7312 nil nil 5490 1 5122 #evaluateIt 8 '&Evaluate It' 9355 1 7218 nil true 7264 8 'EvaluateIt.ico' 7312 nil nil 5490 1 5122 #inspectIt 8 '&Inspect It' 9363 1 7218 nil true 7264 8 'InspectIt.ico' 7312 nil nil 5490 1 5122 #debugIt 8 'Deb&ug It' 1269 1 7218 nil true 7264 8 'Debugger.ico' 7312 nil nil 5490 1 5122 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5602 4097 5490 1 5122 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5490 1 5122 #browseReferences 8 '&References' 5367 1 nil nil nil 5602 4097 5490 2097153 5122 #accept 8 '&Accept' 9383 1 nil nil nil 5490 1 5122 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5602 4097 5442 nil true 34 14 5490 1 5122 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 5602 4097 5490 1 5122 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 5490 1 5122 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 5490 1 5122 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 5490 1 5122 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5602 4097 5490 1 5122 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5490 1 5122 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5490 1 5122 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5602 4097 5490 1 5122 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 5490 1 5122 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5490 1 5122 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 7218 nil true 7264 8 'Refactoring.ico' 7312 nil 47501 nil nil 5602 4097 5442 nil true 34 7 5490 1 5122 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5490 1 5122 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5490 1 5122 #toggleLineEndings 8 'Line &Endings' 1 1 7746 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5490 1 5122 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5490 1 5122 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5490 1 5122 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5490 1 5122 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 7218 nil true 7264 8 'Preferences.ico' 7312 nil 47517 nil nil 8 '&Workspace' nil 134217729 nil nil 47519 nil nil 5442 nil true 34 11 5442 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 47521 nil nil 5442 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 47523 nil nil 5442 nil true 34 11 5490 1 5122 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 5490 1 5122 #browseContainingText 8 'C&ontaining Text...' 1 1 7218 nil true 7264 8 'SearchText.ico' 7312 nil nil 5490 1 5122 #browseMethodCategory 8 'Cate&gory...' 1 1 7218 nil true 7264 8 'Category.ico' 7312 nil nil 5490 1 5122 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5490 1 5122 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5602 4097 5490 1 5122 #browseMethodPackages 8 'Package <s>' 1 1 7218 nil true 7264 8 'Package.ico' 7312 nil nil 5490 1 5122 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 5602 4097 5490 1 5122 #browseMethodHistory 8 '&Change History' 1 1 7218 nil true 7264 8 'MethodHistory.ico' 7312 nil nil 5490 1 5122 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 47543 nil nil 5602 4097 5490 1 5122 #removeMethod 8 '&Delete' 1 1 7218 nil true 7264 8 'EditClear.ico' 7312 nil nil 5442 nil true 34 17 5490 1 5122 #renameMethod 8 'Re&name' 1 1 nil nil nil 5490 1 5122 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5490 1 5122 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 5602 4097 5490 1 5122 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 5442 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 47555 nil nil 5442 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 47557 nil nil 5442 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 47559 nil nil 5602 4097 5442 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 47561 nil nil 5442 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 47563 nil nil 5602 4097 5490 1 5122 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5490 1 5122 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5490 1 5122 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5490 1 5122 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5490 1 5122 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 7218 nil true 7264 8 'Refactoring.ico' 7312 nil 47575 nil nil 5602 4097 5490 1 5122 #methodPackage 8 '&Package...' 1 1 7218 nil true 7264 8 'Package.ico' 7312 nil nil 5442 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 47579 nil nil 5442 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 47581 nil nil 5490 1 5122 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 47585 nil nil 5442 nil true 34 3 5490 1 5122 #undoChange 8 '&Undo <1d>' 1 1 7218 nil true 7264 8 'EditUndo.ico' 7312 nil nil 5490 1 5122 #redoChange 8 '&Redo <1d>' 1 1 7218 nil true 7264 8 'EditRedo.ico' 7312 nil nil 5490 1 5122 #clearChangeHistory 8 'Clear Change &History' 1 1 7218 nil true 7264 8 'MethodHistoryErase.ico' 7312 nil nil 8 'H&istory' nil 134217729 nil nil 47593 nil nil 5442 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 47595 nil nil 5442 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 47597 nil nil 5442 nil true 34 15 5490 1 5122 #helpContents 8 '&Contents' 1025 1 7218 nil true 7264 8 'Help.ico' 7312 nil nil 5490 1 5122 #help 8 'On this &Tool' 1249 1 nil nil nil 5490 1 5122 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5602 4097 5490 1 5122 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7746 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 5602 4097 5490 1 5122 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5490 1 5122 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5490 1 5122 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5602 4097 5490 1 5122 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 7218 nil true 7264 8 '!!APPLICATION' 7312 nil nil 5490 1 5122 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5490 1 5122 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5602 4097 5490 1 5122 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7746 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 47621 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 1811 871 416 834 #text: 34 1 8 'Method Explorer' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 136 15 0 0 189 1 0 0] 34 3 528 3184 2464 992 nil 27 )! !
!Tools.MethodExplorerShell class categoriesFor: #browseMethodsInEnvironments:!instance creation!public! !
!Tools.MethodExplorerShell class categoriesFor: #displayOn:!displaying!public! !
!Tools.MethodExplorerShell class categoriesFor: #historyListSize!accessing!public! !
!Tools.MethodExplorerShell class categoriesFor: #historyListSize:!accessing!public! !
!Tools.MethodExplorerShell class categoriesFor: #initialize!initializing!private! !
!Tools.MethodExplorerShell class categoriesFor: #resource_Default_view!public!resources-views! !

