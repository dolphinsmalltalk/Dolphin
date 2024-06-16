"Filed out from Dolphin Smalltalk"!

MethodBrowserShell subclass: #MethodExplorerShell
	instanceVariableNames: 'historyTree historyList'
	classVariableNames: 'HistoryListSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MethodExplorerShell guid: (GUID fromString: '{8d4892fd-f8e1-49bd-87b5-7366078a04ff}')!

MethodExplorerShell comment: 'MethodExplorerShell is a <MethodBrowserShell> that implements a method browser tool with history tree of searches. Each browse operation (e.g. a definitions or reference search) initiated from the browser results in a new node in the tree. The node is created under the node that was current when the search was performed. This allows one to drill down by performing a series of nested search operations, with the tree maintaining the path. A history list and forward/back buttons allow one to navigate through the chronological history of searches.

Instance Variables:
	historyTree		<TreePresenter>
	historyList			<HistoryList>

Class Variables:
	HistoryListSize		<integer>

'!

!MethodExplorerShell categoriesForClass!MVP-Presenters! !

!MethodExplorerShell methodsFor!

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
						text: (aCommandQuery commandDescription menuText expandMacrosWith: historyList next)]
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
						text: (aCommandQuery commandDescription menuText expandMacrosWith: historyList previous)]
				ifFalse: 
					[aCommandQuery
						isEnabled: false;
						text: 'Back'].
			^true].
	^super queryCommand: aCommandQuery!

recordMethodVisit
	"Private - Add to the visit history - note that the current item is at the top of the history list"

	| node method |
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

!MethodExplorerShell categoriesForMethods!
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

!MethodExplorerShell class methodsFor!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironment 
	| browser |
	browser := self show.
	browser browseMethodsInEnvironments: aCollectionOfBrowserEnvironment.
	^browser!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Method Explorer'!

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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 517 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1759112192 170 192 34 12 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 5 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Edit_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[11 2 0 0 0 0 0 0 134 2 0 0 25 0 0 0] 193 704 8 '' 672 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 738 ##(Smalltalk.Toolbar) #resource_Find_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[134 2 0 0 0 0 0 0 188 2 0 0 25 0 0 0] 193 1072 8 '' 1040 3 976 994 193 193 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1296 nil nil nil 5 nil nil nil 1296 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1328 8 '' 1296 3 976 994 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1552 nil nil nil 5 nil nil nil 1552 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1584 8 '' 1552 3 976 994 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1808 nil nil nil 5 nil nil nil 1808 738 ##(Smalltalk.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1840 8 '' 1808 3 976 994 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2064 nil nil nil 5 nil nil nil 2064 738 ##(Smalltalk.Toolbar) #resource_History_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[188 2 0 0 0 0 0 0 16 3 0 0 25 0 0 0] 193 2096 8 '' 2064 3 976 994 193 193 nil 27 8 'historyTools' nil nil nil 170 192 976 138 144 976 nil nil 9 1569 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 193 560 8 '' 528 3 34 6 1552 1296 1808 672 1040 2064 994 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140850956 1 2560 nil nil nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2560 nil 8 1758805184 170 192 34 6 853830 1 ##(Smalltalk.StatusBarItem) 8193 841 2560 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' 2754 8193 -1 2560 nil 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) nil 8 'version' 2754 8193 45 2560 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2912 7 257 nil nil 8 'modified' nil nil nil 34 3 2880 2768 2800 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2560 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 193 2592 8 '' 2560 3 8 #() 994 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3280 nil nil nil 5 nil nil nil 3280 498 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 3280 34 2 8 1409286144 131073 3360 nil nil nil 5 nil nil nil 3360 1180166 ##(Smalltalk.ProportionalLayout) 170 176 976 true 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 3360 34 2 8 1140916224 131073 3504 nil nil nil 5 nil nil nil 3504 738 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 193 3536 8 '' 3504 3 976 994 193 193 nil 27 8 'source' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 193 3392 8 '' 3360 3 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3360 34 2 8 1140850688 131073 3920 nil nil nil 5 nil nil nil 3920 3426 138 ##(Smalltalk.Dictionary) 34 1 3010 410 ##(Smalltalk.Splitter) 34 12 nil 3920 34 2 8 1140850688 1 4048 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 4048 nil 1 #left nil nil nil 994 1 1 994 9 9 nil 4144 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 193 4080 8 '' 4048 3 8 #() 994 193 193 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 3920 34 2 8 1140850688 131073 4384 nil nil nil 5 nil nil nil 4384 738 ##(Smalltalk.MethodBrowser) #resource_Method_browser_method_list nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 193 4416 8 '' 4384 3 976 994 193 193 nil 27 8 'methodlist' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3920 34 2 8 1409286144 131073 4640 nil nil nil 517 nil nil nil 4640 656710 1 ##(Smalltalk.CardLayout) 138 144 34 1 3010 8 'History' 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 4640 34 2 8 1140850688 131073 4832 nil nil nil 5 nil nil nil 4832 4720 170 192 34 2 4800 8 'historyTree' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 4640 34 2 8 1140851328 1 4944 590662 2 ##(Smalltalk.ListModel) 138 144 34 1 4784 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4944 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 770 138 144 34 3 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 193 4976 8 '' 4944 834 #setSingleSelection: 8 #(1) 4944 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4944 3 8 #() 994 193 193 nil 27 nil 4640 994 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 4832 nil 1 590342 ##(Smalltalk.Rectangle) 994 787 3 994 819 35 nil 1180998 4 ##(Smalltalk.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[27 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 193 4864 8 '' 4832 3 34 1 4800 994 193 193 nil 27 34 2 8 1140916775 1025 4800 590918 3 ##(Smalltalk.TreeModel) nil 5088 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 976 608 nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 5506 #browseMessageDefinitions 8 '&Definitions of...' 1 1 nil nil nil 5890 1 5506 #browseMessageReferences 8 '&References to...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5890 1 5506 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4800 nil 8 1758766000 2818 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 5136 nil nil nil nil nil 170 176 976 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 976 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 155 1 0 0 155 0 0 0] 193 5728 8 '' 4800 834 #contextMenu: 34 1 5856 4800 3 8 #() 994 193 193 nil 27 4800 nil nil nil 170 192 976 nil 4944 4832 994 201 201 401 1 31 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 193 4672 8 '' 4640 3 34 2 4832 4944 994 193 193 nil 27 8 'historySlidey' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 193 3952 8 '' 3920 3 34 3 4640 4048 4384 994 193 193 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3360 34 2 8 1140850688 1 6784 nil nil nil 517 nil nil nil 4114 6784 nil 1 #left nil nil nil 4144 4160 nil 4144 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 193 6816 8 '' 6784 3 8 #() 994 193 193 nil 27 3504 994 193 193 nil 27 170 192 34 2 3360 8 'browser' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 193 3312 8 '' 3280 3 34 1 3360 994 193 193 nil 27 170 192 34 4 528 8 'toolbar' 2560 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 8 5842 nil true 34 8 5890 1 5506 #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5890 1 5506 #fileOpen 8 '&Open Workspace...' 9375 1 7474 nil true 7520 8 'OpenWorkspace.ico' 7568 nil nil 5890 1 5506 #fileFileIn 8 '&File In...' 1 1 7474 nil true 7520 8 'FileIn.ico' 7568 nil nil 6002 4097 5890 1 5506 #saveImage 8 'Sa&ve Image' 1 1 7474 nil true 7520 8 'Snapshot.ico' 7568 nil nil 5890 1 5506 #smalltalkExit 8 'E&xit Dolphin' 1 1 7474 nil true 7520 8 'PowerSwitch.ico' 7568 nil nil 6002 4097 5890 1 5506 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 13767 nil nil 5842 nil true 34 13 5890 1 5506 #undo 8 '&Undo' 9397 1 7474 nil true 7520 8 'EditUndo.ico' 7568 nil nil 6002 4097 5890 1 5506 #cutSelection 8 'Cu&t' 9393 1 7474 nil true 7520 8 'EditCut.ico' 7568 nil nil 5890 1 5506 #copySelection 8 '&Copy' 9351 1 7474 nil true 7520 8 'EditCopy.ico' 7568 nil nil 5890 1 5506 #pasteClipboard 8 '&Paste' 9389 1 7474 nil true 7520 8 'EditPaste.ico' 7568 nil nil 5890 1 5506 #editDelete 8 '&Delete' 1 1 7474 nil true 7520 8 'EditClear.ico' 7568 nil nil 5842 nil true 34 2 5890 1 5506 #reformatSource 8 '&Source' 9391 1 nil nil nil 5890 1 5506 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 13783 nil nil 6002 4097 5890 1 5506 #selectAll 8 'Select &All' 9347 1 nil nil nil 6002 4097 5890 1 5506 #editFind 8 '&Find...' 9357 1 7474 nil true 7520 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5890 1 5506 #findNext 8 'Find &Next' 1253 1 7474 nil true 7520 8 'FindNext.ico' 7568 nil nil 5890 1 5506 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 13793 nil nil 5842 nil true 34 17 5890 1 5506 #browseIt 8 '&Browse It' 9349 1 7474 nil true 7520 8 'ClassBrowserShell.ico' 7568 nil nil 5890 1 5506 #displayIt 8 '&Display It' 9353 1 7474 nil true 7520 8 'DisplayIt.ico' 7568 nil nil 5890 1 5506 #printIt 8 '&Print It' 9377 1 7474 nil true 7520 8 'PrintIt.ico' 7568 nil nil 5890 1 5506 #evaluateIt 8 '&Evaluate It' 9355 1 7474 nil true 7520 8 'EvaluateIt.ico' 7568 nil nil 5890 1 5506 #inspectIt 8 '&Inspect It' 9363 1 7474 nil true 7520 8 'InspectIt.ico' 7568 nil nil 5890 1 5506 #debugIt 8 'Deb&ug It' 1269 1 7474 nil true 7520 8 'Debugger.ico' 7568 nil nil 5890 1 5506 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 6002 4097 5890 1 5506 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5890 1 5506 #browseReferences 8 '&References' 5367 1 nil nil nil 6002 4097 5890 2097153 5506 #accept 8 '&Accept' 9383 1 nil nil nil 5890 1 5506 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 6002 4097 5842 nil true 34 14 5890 1 5506 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 6002 4097 5890 1 5506 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 5890 1 5506 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 5890 1 5506 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 5890 1 5506 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 6002 4097 5890 1 5506 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5890 1 5506 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5890 1 5506 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 6002 4097 5890 1 5506 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 5890 1 5506 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5890 1 5506 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 7474 nil true 7520 8 'Refactoring.ico' 7568 nil 13839 nil nil 6002 4097 5842 nil true 34 7 5890 1 5506 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5890 1 5506 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5890 1 5506 #toggleLineEndings 8 'Line &Endings' 1 1 8002 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5890 1 5506 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5890 1 5506 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5890 1 5506 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5890 1 5506 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 7474 nil true 7520 8 'Preferences.ico' 7568 nil 13855 nil nil 8 '&Workspace' nil 134217729 nil nil 13857 nil nil 5842 nil true 34 11 5842 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 13859 nil nil 5842 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 13861 nil nil 5842 nil true 34 11 5890 1 5506 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 5890 1 5506 #browseContainingText 8 'C&ontaining Text...' 1 1 7474 nil true 7520 8 'SearchText.ico' 7568 nil nil 5890 1 5506 #browseMethodCategory 8 'Cate&gory...' 1 1 7474 nil true 7520 8 'Category.ico' 7568 nil nil 5890 1 5506 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5890 1 5506 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 6002 4097 5890 1 5506 #browseMethodPackages 8 'Package <s>' 1 1 7474 nil true 7520 8 'Package.ico' 7568 nil nil 5890 1 5506 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 6002 4097 5890 1 5506 #browseMethodHistory 8 '&Change History' 1 1 7474 nil true 7520 8 'MethodHistory.ico' 7568 nil nil 5890 1 5506 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 13881 nil nil 6002 4097 5890 1 5506 #removeMethod 8 '&Delete' 1 1 7474 nil true 7520 8 'EditClear.ico' 7568 nil nil 5842 nil true 34 17 5890 1 5506 #renameMethod 8 'Re&name' 1 1 nil nil nil 5890 1 5506 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5890 1 5506 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 6002 4097 5890 1 5506 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 5842 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 13893 nil nil 5842 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 13895 nil nil 5842 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 13897 nil nil 6002 4097 5842 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 13899 nil nil 5842 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 13901 nil nil 6002 4097 5890 1 5506 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5890 1 5506 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5890 1 5506 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5890 1 5506 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5890 1 5506 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 7474 nil true 7520 8 'Refactoring.ico' 7568 nil 13913 nil nil 6002 4097 5890 1 5506 #methodPackage 8 '&Package...' 1 1 7474 nil true 7520 8 'Package.ico' 7568 nil nil 5842 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 13917 nil nil 5842 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 13919 nil nil 5890 1 5506 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 13923 nil nil 5842 nil true 34 3 5890 1 5506 #undoChange 8 '&Undo <1d>' 1 1 7474 nil true 7520 8 'EditUndo.ico' 7568 nil nil 5890 1 5506 #redoChange 8 '&Redo <1d>' 1 1 7474 nil true 7520 8 'EditRedo.ico' 7568 nil nil 5890 1 5506 #clearChangeHistory 8 'Clear Change &History' 1 1 7474 nil true 7520 8 'MethodHistoryErase.ico' 7568 nil nil 8 'H&istory' nil 134217729 nil nil 13931 nil nil 5842 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 13933 nil nil 5842 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 13935 nil nil 5842 nil true 34 15 5890 1 5506 #helpContents 8 '&Contents' 1025 1 7474 nil true 7520 8 'Help.ico' 7568 nil nil 5890 1 5506 #help 8 'On this &Tool' 1249 1 nil nil nil 5890 1 5506 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 6002 4097 5890 1 5506 #learnSmalltalk 8 'Learn Smalltalk' 1 1 8002 $🎓 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 6002 4097 5890 1 5506 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5890 1 5506 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5890 1 5506 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 6002 4097 5890 1 5506 #dolphinHomePage 8 'Dolphin Homepage' 1 1 7474 nil true 7520 8 '!!APPLICATION' 7568 nil nil 5890 1 5506 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5890 1 5506 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 6002 4097 5890 1 5506 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 8002 $🐬 nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 13959 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 770 138 144 34 1 834 #createWindow: 34 1 882 5442 994 1 1 994 1811 871 193 448 8 'Method Explorer' 416 1 34 3 528 3280 2560 994 193 193 nil 27 )! !

!MethodExplorerShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
displayOn:!displaying!public! !
historyListSize!accessing!public! !
historyListSize:!accessing!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

