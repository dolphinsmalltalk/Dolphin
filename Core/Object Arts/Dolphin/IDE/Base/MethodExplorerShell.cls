"Filed out from Dolphin Smalltalk 7"!

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
!MethodExplorerShell categoriesForClass!Development! !
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
!MethodExplorerShell categoriesFor: #addSearch:under:!public! !
!MethodExplorerShell categoriesFor: #addToCommandRoute:!commands!public! !
!MethodExplorerShell categoriesFor: #browseMethodsIn:!public! !
!MethodExplorerShell categoriesFor: #browseMethodsInEnvironments:!public! !
!MethodExplorerShell categoriesFor: #buildHistoryFutureMenu!helpers!menus!private! !
!MethodExplorerShell categoriesFor: #buildHistoryMenu:command:!helpers!menus!private! !
!MethodExplorerShell categoriesFor: #buildHistoryPastMenu!helpers!menus!private! !
!MethodExplorerShell categoriesFor: #buildPopupForCommand:!event handling!private! !
!MethodExplorerShell categoriesFor: #canSaveState!private!saved state! !
!MethodExplorerShell categoriesFor: #clearSelection!commands!public! !
!MethodExplorerShell categoriesFor: #createComponents!initializing!public! !
!MethodExplorerShell categoriesFor: #createSchematicWiring!initializing!public! !
!MethodExplorerShell categoriesFor: #defaultHelpId!public! !
!MethodExplorerShell categoriesFor: #deleteItCommand!helpers!private! !
!MethodExplorerShell categoriesFor: #hasFuture!public!testing! !
!MethodExplorerShell categoriesFor: #hasPast!public!testing! !
!MethodExplorerShell categoriesFor: #historySkip:!commands!private! !
!MethodExplorerShell categoriesFor: #historyTree!public! !
!MethodExplorerShell categoriesFor: #initialize!initializing!private! !
!MethodExplorerShell categoriesFor: #isSameMethod:as:!helpers!private! !
!MethodExplorerShell categoriesFor: #killVisitTimer!helpers!private! !
!MethodExplorerShell categoriesFor: #methods:!accessing!public! !
!MethodExplorerShell categoriesFor: #onMethodSelected!event handling!private! !
!MethodExplorerShell categoriesFor: #onTimerTick:!event handling!private! !
!MethodExplorerShell categoriesFor: #onTipTextRequired:!event handling!private! !
!MethodExplorerShell categoriesFor: #onTreeSelectionChanged!event handling!private! !
!MethodExplorerShell categoriesFor: #onViewOpened!event handling!private! !
!MethodExplorerShell categoriesFor: #queryCommand:!commands!private! !
!MethodExplorerShell categoriesFor: #recordMethodVisit!helpers!private! !
!MethodExplorerShell categoriesFor: #removeHistoryNode!helpers!private! !
!MethodExplorerShell categoriesFor: #saveStateOn:!private!saved state! !
!MethodExplorerShell categoriesFor: #selectFirstMethod!event handling!private! !
!MethodExplorerShell categoriesFor: #setVisitTimer!helpers!private! !
!MethodExplorerShell categoriesFor: #slideyPinNames!accessing!private! !

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
	HistoryListSize isNil ifTrue: [HistoryListSize := self defaultHistoryListSize].
	^HistoryListSize!

historyListSize: anInteger 
	HistoryListSize := anInteger!

initialize
	"private -- class-side initalisation.

		self initialize.
	"

	Smalltalk developmentSystem registerTool: self.
	self canUseIdeaSpace: true!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 524550 ##(Smalltalk.ColorRef) 8 4278190080 8 1912794480 170 192 34 12 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 688 nil nil nil 7 nil nil nil 688 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_History_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1447 1 898 169 51 688 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 211 2 0 0 0 0 0 0 39 3 0 0 25 0 0 0] 8 #() 898 193 193 nil 27 8 'historyTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 754 ##(Smalltalk.Toolbar) #resource_Search_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 661 1 898 433 51 1040 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 34 2 0 0 25 0 0 0] 992 1008 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1280 nil nil nil 7 nil nil nil 1280 754 ##(Smalltalk.Toolbar) #resource_Image_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 63 51 1280 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 992 1008 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1520 nil nil nil 7 nil nil nil 1520 754 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1093 1 898 247 51 1520 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 2 0 0 0 0 0 0 157 2 0 0 25 0 0 0] 992 1008 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1760 nil nil nil 7 nil nil nil 1760 754 ##(Smalltalk.Toolbar) #resource_Find_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1339 1 898 109 51 1760 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 157 2 0 0 0 0 0 0 211 2 0 0 25 0 0 0] 992 1008 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2000 nil nil nil 7 nil nil nil 2000 754 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 63 1 898 599 51 2000 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 992 1008 nil 27 8 'smalltalkTools' 170 192 992 138 144 992 170 176 992 nil 1 nil 898 33 33 898 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 786 138 144 34 2 850 #createAt:extent: 34 2 898 1 1 898 1649 51 528 850 #updateSizePosted 992 528 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 56 3 0 0 25 0 0 0] 34 6 1280 2000 1040 1520 1760 688 1008 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2528 nil nil nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 898 193 193 nil 2528 nil 8 1912526784 170 192 34 6 853766 ##(Smalltalk.StatusBarItem) 1 841 2528 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 2738 1 -1 2528 nil 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) nil 8 'version' 2738 1 45 2528 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2928 7 257 nil nil 8 'modified' 34 3 2896 2752 2816 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2528 nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 663 898 1649 41 2528 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 75 1 0 0 56 3 0 0 95 1 0 0] 8 #() 1008 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3280 nil nil nil 7 nil nil nil 3280 498 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 3280 34 2 8 1409286144 131073 3360 nil nil nil 7 nil nil nil 3360 1180166 ##(Smalltalk.ProportionalLayout) 170 176 992 true 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 3360 34 2 8 1140916224 131073 3504 nil nil nil 7 nil nil nil 3504 754 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 311 898 1649 303 3504 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 155 0 0 0 56 3 0 0 50 1 0 0] 992 1008 nil 27 8 'source' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 1649 613 3360 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 56 3 0 0 50 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3360 34 2 8 1140850688 131073 3904 nil nil nil 7 nil nil nil 3904 3426 138 ##(Smalltalk.Dictionary) 34 1 3026 410 ##(Smalltalk.Splitter) 34 12 nil 3904 34 2 8 1140850688 1 4032 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 4032 nil 1 #left nil nil nil 898 1 1 898 9 9 nil 4128 nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 819 1 898 11 301 4032 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 153 1 0 0 0 0 0 0 158 1 0 0 150 0 0 0] 8 #() 1008 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 3904 34 2 8 1140850688 131073 4352 nil nil nil 7 nil nil nil 4352 754 ##(Smalltalk.MethodBrowser) #resource_Method_browser_method_list nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 829 1 898 821 301 4352 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 158 1 0 0 0 0 0 0 56 3 0 0 150 0 0 0] 992 1008 nil 27 8 'methodlist' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3904 34 2 8 1409286144 131073 4592 nil nil nil 519 nil nil nil 4592 655878 ##(Smalltalk.CardLayout) 138 144 34 1 3026 8 'History' 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 4592 34 2 8 1140850688 131073 4784 nil nil nil 7 nil nil nil 4784 4672 170 192 34 2 4752 8 'historyTree' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 4592 34 2 8 1140851328 1 4896 590662 2 ##(Smalltalk.ListModel) 138 144 34 1 4736 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4896 nil 8 1912616880 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 2784 nil nil nil nil nil #noIcons nil nil nil nil nil 786 138 144 34 3 850 #createAt:extent: 34 2 898 1 1 898 819 301 4896 850 #basicSelectionsByIndex: 34 1 8 #(1) 4896 850 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4896 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 153 1 0 0 150 0 0 0] 8 #() 1008 nil 27 nil 4592 898 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 4784 nil 1 590342 ##(Smalltalk.Rectangle) 898 719 3 898 751 35 nil 1180998 4 ##(Smalltalk.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 57 9 898 755 285 4784 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 149 1 0 0 146 0 0 0] 34 1 4752 1008 nil 27 34 2 8 1140916775 1025 4752 590918 3 ##(Smalltalk.TreeModel) nil 5040 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 992 594 8 4278190080 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 5426 #browseMessageDefinitions 8 '&Definitions of...' 1 1 nil nil nil 5826 1 5426 #browseMessageReferences 8 '&References to...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5826 1 5426 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4752 nil 8 1912658960 2834 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 2784 nil nil nil nil nil 170 176 992 17 #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 992 786 138 144 34 2 850 #createAt:extent: 34 2 898 1 37 898 755 249 4752 850 #contextMenu: 34 1 5792 4752 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 121 1 0 0 142 0 0 0] 8 #() 1008 nil 27 4752 170 192 992 nil 4896 4784 898 201 201 401 1 31 nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 819 301 4592 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 153 1 0 0 150 0 0 0] 34 2 4784 4896 1008 nil 27 8 'historySlidey' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 1649 301 3904 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 56 3 0 0 150 0 0 0] 34 3 4592 4032 4352 1008 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3360 34 2 8 1140850688 1 6672 nil nil nil 519 nil nil nil 4098 6672 nil 1 #left nil nil nil 898 1 1 4144 nil 6752 nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 301 898 1649 11 6672 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 150 0 0 0 56 3 0 0 155 0 0 0] 8 #() 1008 nil 27 3504 1008 nil 27 170 192 34 2 3360 8 'browser' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 51 898 1649 613 3280 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 56 3 0 0 75 1 0 0] 34 1 3360 1008 nil 27 170 192 34 4 528 8 'toolbar' 2528 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 8 5778 nil true 34 8 5826 1 5426 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileNew.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5826 1 5426 #fileOpen 8 '&Open...' 9375 1 7330 nil true 7376 8 'FileOpen.ico' 7424 nil nil 5826 1 5426 #fileFileIn 8 '&File In...' 1 1 nil nil nil 5938 4097 5826 1 5426 #saveImage 8 'Sa&ve Image' 1 1 7330 nil true 7376 8 'Snapshot.ico' 7424 nil nil 5826 1 5426 #smalltalkExit 8 'E&xit Dolphin' 1 1 7330 nil true 7376 8 'PowerSwitch.ico' 7424 nil nil 5938 4097 5826 1 5426 #exit 8 '&Close' 17639 1 7330 nil true 7376 8 'CloseWindow.ico' 7424 nil nil 8 '&File' nil 134217729 nil nil 31001 nil nil 5778 nil true 34 13 5826 1 5426 #undo 8 '&Undo' 9397 1 7330 nil true 7376 8 'EditUndo.ico' 7424 nil nil 5938 4097 5826 1 5426 #cutSelection 8 'Cu&t' 9393 1 7330 nil true 7376 8 'EditCut.ico' 7424 nil nil 5826 1 5426 #copySelection 8 '&Copy' 9351 1 7330 nil true 7376 8 'EditCopy.ico' 7424 nil nil 5826 1 5426 #pasteClipboard 8 '&Paste' 9389 1 7330 nil true 7376 8 'EditPaste.ico' 7424 nil nil 5826 1 5426 #editDelete 8 '&Delete' 1 1 7330 nil true 7376 8 'EditClear.ico' 7424 nil nil 5778 nil true 34 2 5826 1 5426 #reformatSource 8 '&Source' 9391 1 nil nil nil 5826 1 5426 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 31017 nil nil 5938 4097 5826 1 5426 #selectAll 8 'Select &All' 9347 1 nil nil nil 5938 4097 5826 1 5426 #editFind 8 '&Find...' 9357 1 7330 nil true 7376 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5826 1 5426 #findNext 8 'Find &Next' 1253 1 7330 nil true 7376 8 'FindNext.ico' 7424 nil nil 5826 1 5426 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 31027 nil nil 5778 nil true 34 16 5826 1 5426 #browseIt 8 '&Browse It' 9349 1 7330 nil true 7376 8 'ClassBrowserShell.ico' 7424 nil nil 5826 1 5426 #displayIt 8 '&Display It' 9353 1 7330 nil true 7376 8 'DisplayIt.ico' 7424 nil nil 5826 1 5426 #evaluateIt 8 '&Evaluate It' 9355 1 7330 nil true 7376 8 'EvaluateIt.ico' 7424 nil nil 5826 1 5426 #inspectIt 8 '&Inspect It' 9363 1 7330 nil true 7376 8 'InspectIt.ico' 7424 nil nil 5826 1 5426 #debugIt 8 'Deb&ug It' 1269 1 7330 nil true 7376 8 'Debugger.ico' 7424 nil nil 5826 1 5426 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5938 4097 5826 1 5426 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5826 1 5426 #browseReferences 8 '&References' 5367 1 nil nil nil 5938 4097 5826 2097153 5426 #accept 8 '&Accept' 9383 1 nil nil nil 5826 1 5426 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5938 4097 5778 nil true 34 14 5826 1 5426 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 5938 4097 5826 1 5426 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 5826 1 5426 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 5826 1 5426 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 5826 1 5426 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5938 4097 5826 1 5426 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5826 1 5426 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5826 1 5426 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5938 4097 5826 1 5426 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 5826 1 5426 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5826 1 5426 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 7330 nil true 7376 8 'Refactoring.ico' 7424 nil 31071 nil nil 5938 4097 5778 nil true 34 7 5826 1 5426 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5826 1 5426 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5826 1 5426 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 5826 1 5426 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5826 1 5426 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5826 1 5426 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5826 1 5426 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 31087 nil nil 8 '&Workspace' nil 134217729 nil nil 31089 nil nil 5778 nil true 34 13 5778 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 31091 nil nil 5778 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 31093 nil nil 5778 nil true 34 11 5826 1 5426 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 5826 1 5426 #browseContainingText 8 'C&ontaining Text...' 1 1 7330 nil true 7376 8 'SearchText.ico' 7424 nil nil 5826 1 5426 #browseMethodCategory 8 'Cate&gory...' 1 1 nil nil nil 5826 1 5426 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5826 1 5426 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5938 4097 5826 1 5426 #browseMethodPackages 8 'Package <s>' 1 1 nil nil nil 5826 1 5426 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 5938 4097 5826 1 5426 #browseMethodHistory 8 '&Change History' 1 1 nil nil nil 5826 1 5426 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 31113 nil nil 5938 4097 5826 1 5426 #removeMethod 8 '&Delete' 1 1 7330 nil true 7376 8 'EditClear.ico' 7424 nil nil 5778 nil true 34 17 5826 1 5426 #renameMethod 8 'Re&name' 1 1 nil nil nil 5826 1 5426 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5826 1 5426 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 5938 4097 5826 1 5426 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 5778 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 31125 nil nil 5778 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 31127 nil nil 5778 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 31129 nil nil 5938 4097 5778 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 31131 nil nil 5778 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 31133 nil nil 5938 4097 5826 1 5426 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5826 1 5426 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5826 1 5426 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5826 1 5426 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5826 1 5426 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 7330 nil true 7376 8 'Refactoring.ico' 7424 nil 31145 nil nil 5938 4097 5826 1 5426 #methodPackage 8 '&Package...' 1 1 7330 nil true 7376 8 'Package.ico' 7424 nil nil 5778 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 31149 nil nil 5778 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 31151 nil nil 5826 1 5426 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 5938 4097 5826 1 5426 #browseMethodEditions 8 'Browse &Editions' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 31157 nil nil 5778 nil true 34 3 5826 1 5426 #undoChange 8 '&Undo <1d>' 1 1 7330 nil true 7376 8 'EditUndo.ico' 7424 nil nil 5826 1 5426 #redoChange 8 '&Redo <1d>' 1 1 7330 nil true 7376 8 'EditRedo.ico' 7424 nil nil 5826 1 5426 #clearChangeHistory 8 'Clear Change &History' 1 1 nil nil nil 8 'H&istory' nil 134217729 nil nil 31165 nil nil 5778 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 31167 nil nil 5778 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 31169 nil nil 5778 nil true 34 15 5826 1 5426 #helpContents 8 '&Contents' 1025 1 7330 nil true 7376 49 8624 nil nil 5826 1 5426 #help 8 'On this &Tool' 1249 1 nil nil nil 5826 1 5426 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5938 4097 5826 1 5426 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 5938 4097 5826 1 5426 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5826 1 5426 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5826 1 5426 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5938 4097 5826 1 5426 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 5826 1 5426 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5826 1 5426 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5938 4097 5826 1 5426 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7330 nil true 7376 8 '!!APPLICATION' 7424 nil nil 8 '&Help' nil 134217729 nil nil 31193 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 786 138 144 34 3 850 #createAt:extent: 34 2 898 3839 21 898 1681 821 416 850 #text: 34 1 8 'Method Explorer' 416 850 #updateMenuBar 992 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 199 10 0 0 164 1 0 0] 34 3 528 3280 2528 1008 nil 27 )! !
!MethodExplorerShell class categoriesFor: #browseMethodsInEnvironments:!instance creation!public! !
!MethodExplorerShell class categoriesFor: #displayOn:!displaying!public! !
!MethodExplorerShell class categoriesFor: #historyListSize!accessing!public! !
!MethodExplorerShell class categoriesFor: #historyListSize:!accessing!public! !
!MethodExplorerShell class categoriesFor: #initialize!initializing!private! !
!MethodExplorerShell class categoriesFor: #resource_Default_view!public!resources-views! !

