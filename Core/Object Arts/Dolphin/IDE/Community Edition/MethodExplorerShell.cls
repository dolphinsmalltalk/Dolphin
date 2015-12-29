"Filed out from Dolphin Smalltalk X6.1"!

MethodBrowserShell subclass: #MethodExplorerShell
	instanceVariableNames: 'historyTree historyList'
	classVariableNames: 'HistoryListSize'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodExplorerShell guid: (GUID fromString: '{8D4892FD-F8E1-49BD-87B5-7366078A04FF}')!
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
			method := each value ifNil: ['(none)'].
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
		ifNil: [browserPresenter list: #()]
		ifNotNil: 
			[:env | 
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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout)  1 1 410 8 ##(Smalltalk.Toolbar)  98 25 0 416 98 2 8 1140851532 131073 560 0 482 8 4278190080 0 519 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 482 656 8 4294906347 234 256 98 10 410 8 ##(Smalltalk.ReferenceView)  98 14 0 560 98 2 8 1140850688 131073 848 0 0 0 7 0 0 0 848 1180166 ##(Smalltalk.ResourceIdentifier)  576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 754 1 1 754 63 51 848 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 754 193 193 0 27 8 'imageTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1232 0 0 0 7 0 0 0 1232 930 576 8 #resource_Smalltalk_tools 0 978 202 208 98 1 1042 1072 98 2 754 63 1 754 991 51 1232 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1184 1200 0 27 8 'smalltalkTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1488 0 0 0 7 0 0 0 1488 930 576 8 #resource_History_tools 0 978 202 208 98 1 1042 1072 98 2 754 1 51 754 169 51 1488 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 84 0 0 0 50 0 0 0] 1184 1200 0 27 8 'historyTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 1744 0 0 0 7 0 0 0 1744 930 576 8 #resource_Edit_tools 0 978 202 208 98 1 1042 1072 98 2 754 1053 1 754 247 51 1744 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 137 2 0 0 25 0 0 0] 1184 1200 0 27 8 'editTools' 410 864 98 14 0 560 98 2 8 1140850688 131073 2000 0 0 0 7 0 0 0 2000 930 576 8 #resource_Find_tools 0 978 202 208 98 1 1042 1072 98 2 754 1299 1 754 109 51 2000 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 137 2 0 0 0 0 0 0 191 2 0 0 25 0 0 0] 1184 1200 0 27 8 'findTools' 234 256 1184 202 208 1184 234 240 1184 0 1 0 754 33 33 754 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 978 202 208 98 2 1042 1072 98 2 754 1 1 754 1497 101 560 1042 8 #updateSize 1184 560 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 236 2 0 0 50 0 0 0] 98 5 848 1232 1744 2000 1488 1200 0 27 410 8 ##(Smalltalk.StatusBar)  98 18 0 416 98 2 8 1140850956 1 2560 0 482 8 4278190080 0 7 0 674 0 16 706 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 754 193 193 0 2560 0 8 4294909649 234 256 98 6 853766 ##(Smalltalk.StatusBarItem)  1 841 2560 0 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  8 'errors' 2786 1 -1 2560 0 459270 ##(Smalltalk.Message)  8 #displayString 98 0 2832 0 8 'version' 2786 1 45 2560 0 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  5 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association)  8 #Smalltalk 48 8 #developmentSystem 8 #changedIcon 8 #imageIndex 3024 7 257 0 0 8 'modified' 98 3 2992 2800 2896 1115142 ##(Smalltalk.StatusBarNullItem)  513 1 2560 0 0 978 202 208 98 1 1042 1072 98 2 754 1 669 754 1497 41 2560 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 78 1 0 0 236 2 0 0 98 1 0 0] 98 0 1200 0 27 0 0 410 8 ##(Smalltalk.ContainerView)  98 15 0 416 98 2 8 1140850688 131073 3456 0 0 0 7 0 0 0 3456 530 1 1 0 0 0 0 410 3472 98 15 0 3456 98 2 8 1409286144 131073 3552 0 0 0 7 0 0 0 3552 1180166 ##(Smalltalk.ProportionalLayout)  234 240 1184 16 234 256 98 2 410 864 98 14 0 3552 98 2 8 1140916224 131073 3696 0 0 0 7 0 0 0 3696 930 8 ##(Smalltalk.MethodWorkspace)  8 #resource_Default_view 0 978 202 208 98 1 1042 1072 98 2 754 1 293 754 1497 277 3696 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 146 0 0 0 236 2 0 0 28 1 0 0] 1184 1200 0 27 8 'source' 0 978 202 208 98 1 1042 1072 98 2 754 1 1 754 1497 569 3552 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 236 2 0 0 28 1 0 0] 98 3 410 3472 98 15 0 3552 98 2 8 1140850688 131073 4128 0 0 0 7 0 0 0 4128 3618 202 8 ##(Smalltalk.Dictionary)  98 1 3138 410 8 ##(Smalltalk.Splitter)  98 12 0 4128 98 2 8 1140850688 1 4272 0 482 8 4278190080 0 519 0 0 0 4272 978 202 208 98 1 1042 1072 98 2 754 739 1 754 19 275 4272 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 113 1 0 0 0 0 0 0 122 1 0 0 137 0 0 0] 98 0 1200 0 27 1 32 234 256 98 4 410 8 ##(Smalltalk.SlideyInneyOuteyThing)  98 23 0 4128 98 2 8 1409286144 131073 4576 0 482 8 4278190080 0 519 0 0 0 4576 655878 ##(Smalltalk.CardLayout)  202 208 98 1 3138 8 'History' 410 8 ##(Smalltalk.TreeView)  98 27 0 410 8 ##(Smalltalk.SlidingCardTray)  98 22 0 4576 98 2 8 1140850688 131073 4832 0 196934 1 ##(Smalltalk.RGB)  30915469 0 7 0 0 0 4832 4704 234 256 98 2 4784 8 'historyTree' 0 410 8 ##(Smalltalk.TabViewXP)  98 28 0 4576 98 2 8 1140851328 1 4992 590662 2 ##(Smalltalk.ListModel)  202 208 98 1 4768 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  4928 0 1 0 0 0 4992 0 8 4294905541 2816 2832 2864 0 0 0 0 0 8 #noIcons 0 0 0 0 0 978 202 208 98 3 1042 1072 98 2 754 1 1 754 739 275 4992 1042 8 #basicSelectionsByIndex: 98 1 98 1 3 4992 1042 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 4992 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 113 1 0 0 137 0 0 0] 98 0 1200 0 27 0 4576 754 33 33 1049862 ##(Smalltalk.ButtonInteractor)  4832 0 590342 ##(Smalltalk.Rectangle)  754 641 3 754 673 35 1 1180998 4 ##(Smalltalk.CommandDescription)  8 #togglePin 8 'Pin or Unpin the tray' 1 1 0 0 0 978 202 208 98 1 1042 1072 98 2 754 55 9 754 677 259 4832 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 27 0 0 0 4 0 0 0 109 1 0 0 133 0 0 0] 98 1 4784 1200 0 27 98 2 8 1140916775 1025 4784 590918 3 ##(Smalltalk.TreeModel)  0 5152 525062 ##(Smalltalk.TreeNode)  0 0 0 234 256 1184 482 8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem)  1 5586 8 #browseMessageDefinitions 8 '&Definitions of...' 1 1 0 0 0 6002 1 5586 8 #browseMessageReferences 8 '&References to...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 6002 1 5586 8 #clearSelection 8 'Re&move' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 4784 0 8 4294907867 2914 2944 98 0 2832 2864 0 0 0 0 0 234 240 1184 17 5184 1 0 978 202 208 98 2 1042 1072 98 2 754 1 37 754 677 223 4784 1042 8 #contextMenu: 98 1 5968 4784 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 82 1 0 0 129 0 0 0] 98 0 1200 0 27 4784 234 256 1184 0 4992 4832 754 201 201 401 1 31 0 0 978 202 208 98 1 1042 1072 98 2 754 1 1 754 739 275 4576 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 113 1 0 0 137 0 0 0] 98 2 4832 4992 1200 0 27 8 'historySlidey' 410 864 98 14 0 4128 98 2 8 1140850688 131073 6736 0 0 0 7 0 0 0 6736 930 8 ##(Smalltalk.MethodBrowser)  8 #resource_Method_browser_method_list 0 978 202 208 98 1 1042 1072 98 2 754 757 1 754 741 275 6736 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 1 0 0 0 0 0 0 236 2 0 0 137 0 0 0] 1184 1200 0 27 8 'methodlist' 0 978 202 208 98 1 1042 1072 98 2 754 1 1 754 1497 275 4128 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 236 2 0 0 137 0 0 0] 98 3 4576 4272 6736 1200 0 27 410 4288 98 12 0 3552 98 2 8 1140850688 1 7168 0 482 4368 0 519 0 0 0 7168 978 202 208 98 1 1042 1072 98 2 754 1 275 754 1497 19 7168 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 137 0 0 0 236 2 0 0 146 0 0 0] 98 0 1200 0 27 3696 1200 0 27 234 256 98 2 3552 8 'browser' 0 978 202 208 98 1 1042 1072 98 2 754 1 101 754 1497 569 3456 1138 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 50 0 0 0 236 2 0 0 78 1 0 0] 98 1 3552 1200 0 27 234 256 98 4 2560 8 'statusbar' 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar)  0 16 98 8 5954 0 16 98 8 6002 1 5586 8 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'FileNew.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 6002 1 5586 8 #fileOpen 8 '&Open...' 9375 1 7826 0 16 7872 8 'FileOpen.ico' 7920 0 0 6002 1 5586 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 6146 4097 6002 1 5586 8 #saveImage 8 'Sa&ve Image' 1 1 7826 0 16 7872 8 'Snapshot.ico' 7920 0 0 6002 1 5586 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 7826 0 16 7872 8 'PowerSwitch.ico' 7920 0 0 6146 4097 6002 1 5586 8 #exit 8 '&Close' 17639 1 7826 0 16 7872 8 'CloseWindow.ico' 7920 0 0 8 '&File' 0 134217729 0 0 42411 0 0 5954 0 16 98 13 6002 1 5586 8 #undo 8 '&Undo' 9397 1 7826 0 16 7872 8 'EditUndo.ico' 7920 0 0 6146 4097 6002 1 5586 8 #cutSelection 8 'Cu&t' 9393 1 7826 0 16 7872 8 'EditCut.ico' 7920 0 0 6002 1 5586 8 #copySelection 8 '&Copy' 9351 1 7826 0 16 7872 8 'EditCopy.ico' 7920 0 0 6002 1 5586 8 #pasteClipboard 8 '&Paste' 9389 1 7826 0 16 7872 8 'EditPaste.ico' 7920 0 0 6002 1 5586 8 #editDelete 8 '&Delete' 1 1 7826 0 16 7872 8 'EditClear.ico' 7920 0 0 5954 0 16 98 2 6002 1 5586 8 #reformatSource 8 '&Source' 9391 1 0 0 0 6002 1 5586 8 #reformatComment 8 '&Comment' 9367 1 0 0 0 8 'Ref&ormat' 0 134217729 0 0 42427 0 0 6146 4097 6002 1 5586 8 #selectAll 8 'Select &All' 9347 1 0 0 0 6146 4097 6002 1 5586 8 #editFind 8 '&Find...' 9357 1 7826 0 16 7872 47 786694 ##(Smalltalk.ShellLibrary)  0 0 6002 1 5586 8 #findNext 8 'Find &Next' 1253 1 7826 0 16 7872 8 'FindNext.ico' 7920 0 0 6002 1 5586 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 42437 0 0 5954 0 16 98 16 6002 1 5586 8 #browseIt 8 '&Browse It' 9349 1 7826 0 16 7872 8 'ClassBrowserShell.ico' 7920 0 0 6002 1 5586 8 #displayIt 8 '&Display It' 9353 1 7826 0 16 7872 8 'DisplayIt.ico' 7920 0 0 6002 1 5586 8 #evaluateIt 8 '&Evaluate It' 9355 1 7826 0 16 7872 8 'EvaluateIt.ico' 7920 0 0 6002 1 5586 8 #inspectIt 8 '&Inspect It' 9363 1 7826 0 16 7872 8 'InspectIt.ico' 7920 0 0 6002 1 5586 8 #debugIt 8 'Deb&ug It' 1269 1 7826 0 16 7872 8 'Debugger.ico' 7920 0 0 6002 1 5586 8 #fileItIn 8 'Fi&le It In' 1 1 0 0 0 6146 4097 6002 1 5586 8 #browseDefinitions 8 'Defi&nitions' 1271 1 0 0 0 6002 1 5586 8 #browseReferences 8 '&References' 5367 1 0 0 0 6146 4097 6002 2097153 5586 8 #accept 8 '&Accept' 9383 1 0 0 0 6002 1 5586 8 #reformatAccept 8 'Refor&mat/Accept' 13479 1 0 0 0 6146 4097 5954 0 16 98 14 6002 1 5586 8 #renameVariable 8 'Re&name <1d>...' 1 1 0 0 0 6146 4097 6002 1 5586 8 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 0 0 0 6002 1 5586 8 #extractMethod 8 'E&xtract Method...' 9371 1 0 0 0 6002 1 5586 8 #extractToComponent 8 'Extract to &Component...' 1 1 0 0 0 6002 1 5586 8 #inlineMessage 8 'Inline &Message' 13467 1 0 0 0 6146 4097 6002 1 5586 8 #inlineTemporary 8 '&Inline Temporary' 13481 1 0 0 0 6002 1 5586 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 0 0 0 6002 1 5586 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 6146 4097 6002 1 5586 8 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 6002 1 5586 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 6002 1 5586 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Re&factorings' 8 #codeRefactoringsMenu 134217729 7826 0 16 7872 8 'Refactoring.ico' 7920 0 42481 0 0 6146 4097 5954 0 16 98 7 6002 1 5586 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 6002 1 5586 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 6002 1 5586 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 6002 1 5586 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 6002 1 5586 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 6002 1 5586 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 6002 1 5586 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 42497 0 0 8 '&Workspace' 0 134217729 0 0 42499 0 0 5954 0 16 98 13 5954 0 16 98 0 8 'De&finitions of' 8 #definitionsMenu 1 0 0 42501 0 0 5954 0 16 98 0 8 '&References to' 8 #referencesMenu 1 0 0 42503 0 0 5954 0 16 98 11 6002 1 5586 8 #browseReferencesToGlobal 8 'References to Global...' 1 1 0 0 0 6002 1 5586 8 #browseContainingText 8 'C&ontaining Text...' 1 1 7826 0 16 7872 8 'SearchText.ico' 7920 0 0 6002 1 5586 8 #browseMethodCategory 8 'Cate&gory...' 1 1 0 0 0 6002 1 5586 8 #browseCompilationFailures 8 'Compilation &Failures' 1 1 0 0 0 6002 1 5586 8 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 0 0 0 6146 4097 6002 1 5586 8 #browseMethodPackages 8 'Package <s>' 1 1 0 0 0 6002 1 5586 8 #browseMethodClasses 8 'Class <s>' 1 1 0 0 0 6146 4097 6002 1 5586 8 #browseMethodHistory 8 '&Change History' 1 1 0 0 0 6002 1 5586 8 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 0 0 0 8 '&Browse other' 0 134217729 0 0 42523 0 0 6146 4097 6002 1 5586 8 #removeMethod 8 '&Delete' 1 1 7826 0 16 7872 8 'EditClear.ico' 7920 0 0 5954 0 16 98 17 6002 1 5586 8 #renameMethod 8 'Re&name' 1 1 0 0 0 6002 1 5586 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 6002 1 5586 8 #safeRemoveMethods 8 'Rem&ove' 1 1 0 0 0 6146 4097 6002 1 5586 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 5954 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 42535 0 0 5954 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 42537 0 0 5954 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 42539 0 0 6146 4097 5954 0 16 98 0 8 'Rename &Temporary' 8 #renameTempMenu 134217729 0 0 42541 0 0 5954 0 16 98 0 8 'Convert Temp to Inst. Var.' 8 #convertTempToInstVarMenu 134217729 0 0 42543 0 0 6146 4097 6002 1 5586 8 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 0 0 0 6002 1 5586 8 #pushUpMethods 8 'Push &Up' 9325 1 0 0 0 6002 1 5586 8 #pushDownMethods 8 'Push &Down' 9327 1 0 0 0 6002 1 5586 8 #overrideMethods 8 'Ove&rride <1d>' 1 1 0 0 0 6002 1 5586 8 #moveMethod 8 'Move to &Component...' 1 1 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 7826 0 16 7872 8 'Refactoring.ico' 7920 0 42555 0 0 6146 4097 6002 1 5586 8 #methodPackage 8 '&Package...' 1 1 7826 0 16 7872 8 'Package.ico' 7920 0 0 5954 0 16 98 0 8 'Add to &Category' 8 #addCategoryMenu 134217729 0 0 42559 0 0 5954 0 16 98 0 8 'Re&move from Category' 8 #removeCategoryMenu 134217729 0 0 42561 0 0 6002 1 5586 8 #togglePrivate 8 'Pri&vate' 1 1 0 0 0 6146 4097 6002 1 5586 8 #browseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 8 '&Method' 0 134217729 0 0 42567 0 0 5954 0 16 98 3 6002 1 5586 8 #undoChange 8 '&Undo <1d>' 1 1 7826 0 16 7872 8 'EditUndo.ico' 7920 0 0 6002 1 5586 8 #redoChange 8 '&Redo <1d>' 1 1 7826 0 16 7872 8 'EditRedo.ico' 7920 0 0 6002 1 5586 8 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 42575 0 0 5954 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 42577 0 0 5954 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 42579 0 0 5954 0 16 98 19 6002 1 5586 8 #helpContents 8 '&Contents' 1025 1 7826 0 16 7872 49 9344 0 0 6002 1 5586 8 #help 8 'On this &Tool' 1249 1 0 0 0 6002 1 5586 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 6146 4097 6002 1 5586 8 #helpFirstSplash 8 'First Splash!!' 1 1 0 0 0 6146 4097 6002 1 5586 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 6002 1 5586 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 6002 1 5586 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5954 0 16 98 4 6002 2097153 5586 8 #tipOfTheDay 8 '&Next Tip of the Day' 9441 1 7826 0 16 7872 8 'TipOfTheDay.ico' 7920 0 0 6002 1 5586 8 #previousTipOfTheDay 8 '&Previous Tip of the Day' 13537 1 7826 0 16 7872 8 'TipOfTheDay.ico' 7920 0 0 6146 4097 6002 1 5586 8 #toggleShowTipsAtStartup 8 '&Show Tips at Startup' 1 1 0 0 0 8 'Tip of the &Day' 0 134217729 0 0 42601 0 0 6146 4097 6002 1 5586 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 6002 1 5586 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 6002 1 5586 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 6002 1 5586 8 #myDolphinAccount 8 'My Dolphin Account' 1 1 0 0 0 6146 4097 6002 1 5586 8 #dolphinLiveUpdate 8 'Check for Live &Updates...' 1 1 7826 0 16 7872 8 'LiveUpdate.ico' 7920 0 0 6146 4097 6002 1 5586 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7826 0 16 7872 8 '!!APPLICATION' 7920 0 0 8 '&Help' 0 134217729 0 0 42615 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 978 202 208 98 3 1042 1072 98 2 754 3359 21 754 1529 821 416 1042 8 #text: 98 1 8 'Method Explorer' 416 1042 8 #updateMenuBar 1184 416 1138 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 139 9 0 0 164 1 0 0] 98 3 560 3456 2560 1200 0 27 )! !
!MethodExplorerShell class categoriesFor: #browseMethodsInEnvironments:!instance creation!public! !
!MethodExplorerShell class categoriesFor: #displayOn:!displaying!public! !
!MethodExplorerShell class categoriesFor: #historyListSize!accessing!public! !
!MethodExplorerShell class categoriesFor: #historyListSize:!accessing!public! !
!MethodExplorerShell class categoriesFor: #initialize!initializing!private! !
!MethodExplorerShell class categoriesFor: #resource_Default_view!public!resources-views! !

