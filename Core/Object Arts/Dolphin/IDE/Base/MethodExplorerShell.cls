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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 786694 ##(Smalltalk.ColorDefault) 8 4278190080 8 1915204752 170 192 34 12 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 688 nil nil nil 7 nil nil nil 688 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Image_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 898 63 51 688 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 898 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 754 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 63 1 898 553 51 1040 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 992 1008 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1280 nil nil nil 7 nil nil nil 1280 754 ##(Smalltalk.Toolbar) #resource_Find_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1297 1 898 109 51 1280 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 190 2 0 0 25 0 0 0] 992 1008 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1520 nil nil nil 7 nil nil nil 1520 754 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1051 1 898 247 51 1520 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 992 1008 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1760 nil nil nil 7 nil nil nil 1760 754 ##(Smalltalk.Toolbar) #resource_Search_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 615 1 898 437 51 1760 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 992 1008 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2000 nil nil nil 7 nil nil nil 2000 754 ##(Smalltalk.Toolbar) #resource_History_tools nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1405 1 898 169 51 2000 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 2 0 0 0 0 0 0 18 3 0 0 25 0 0 0] 992 1008 nil 27 8 'historyTools' 170 192 992 138 144 992 nil nil 1 nil 898 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 786 138 144 34 2 850 #createAt:extent: 34 2 898 1 1 898 1779 51 528 850 #updateSizePosted 992 528 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 34 6 688 1040 1760 1520 1280 2000 1008 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2496 nil nil nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 898 193 193 nil 2496 nil 8 1914952576 170 192 34 6 853766 ##(Smalltalk.StatusBarItem) 1 841 2496 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' 2706 1 -1 2496 nil 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) nil 8 'version' 2706 1 45 2496 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2864 7 257 nil nil 8 'modified' 34 3 2832 2720 2752 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2496 nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 713 898 1779 41 2496 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 8 #() 1008 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3216 nil nil nil 7 nil nil nil 3216 498 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 3216 34 2 8 1409286144 131073 3296 nil nil nil 7 nil nil nil 3296 1180166 ##(Smalltalk.ProportionalLayout) 170 176 992 true 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 3296 34 2 8 1140916224 131073 3440 nil nil nil 7 nil nil nil 3440 754 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 337 898 1779 327 3440 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 992 1008 nil 27 8 'source' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 1779 663 3296 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3296 34 2 8 1140850688 131073 3840 nil nil nil 7 nil nil nil 3840 3362 138 ##(Smalltalk.Dictionary) 34 1 2962 410 ##(Smalltalk.Splitter) 34 12 nil 3840 34 2 8 1140850688 1 3968 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3968 nil 1 #left nil nil nil 898 1 1 898 9 9 nil 4064 nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 885 1 898 11 327 3968 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 8 #() 1008 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 3840 34 2 8 1140850688 131073 4288 nil nil nil 7 nil nil nil 4288 754 ##(Smalltalk.MethodBrowser) #resource_Method_browser_method_list nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 895 1 898 885 327 4288 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 992 1008 nil 27 8 'methodlist' 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3840 34 2 8 1409286144 131073 4528 nil nil nil 519 nil nil nil 4528 655878 ##(Smalltalk.CardLayout) 138 144 34 1 2962 8 'History' 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 4528 34 2 8 1140850688 131073 4720 nil nil nil 7 nil nil nil 4720 4608 170 192 34 2 4688 8 'historyTree' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 4528 34 2 8 1140851328 1 4832 590662 2 ##(Smalltalk.ListModel) 138 144 34 1 4672 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4832 nil 8 1915274640 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 786 138 144 34 3 850 #createAt:extent: 34 2 898 1 1 898 885 327 4832 850 #basicSelectionsByIndex: 34 1 8 #(1) 4832 850 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4832 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 8 #() 1008 nil 27 nil 4528 898 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 4720 nil 1 590342 ##(Smalltalk.Rectangle) 898 785 3 898 817 35 nil 1180998 4 ##(Smalltalk.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 57 9 898 821 311 4720 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 34 1 4688 1008 nil 27 34 2 8 1140916775 1025 4688 590918 3 ##(Smalltalk.TreeModel) nil 4976 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 992 608 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 5394 #browseMessageDefinitions 8 '&Definitions of...' 1 1 nil nil nil 5762 1 5394 #browseMessageReferences 8 '&References to...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5762 1 5394 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4688 nil 8 1914975136 2770 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 5024 nil nil nil nil nil 170 176 992 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 992 786 138 144 34 2 850 #createAt:extent: 34 2 898 1 37 898 821 275 4688 850 #contextMenu: 34 1 5728 4688 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 154 1 0 0 155 0 0 0] 8 #() 1008 nil 27 4688 170 192 992 nil 4832 4720 898 201 201 401 1 31 nil nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 885 327 4528 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 34 2 4720 4832 1008 nil 27 8 'historySlidey' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 1 898 1779 327 3840 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 34 3 4528 3968 4288 1008 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3296 34 2 8 1140850688 1 6608 nil nil nil 519 nil nil nil 4034 6608 nil 1 #left nil nil nil 4064 4080 nil 4064 nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 327 898 1779 11 6608 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 8 #() 1008 nil 27 3440 1008 nil 27 170 192 34 2 3296 8 'browser' nil 786 138 144 34 1 850 #createAt:extent: 34 2 898 1 51 898 1779 663 3216 946 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 34 1 3296 1008 nil 27 170 192 34 4 2496 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 8 5714 nil true 34 8 5762 1 5394 #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5762 1 5394 #fileOpen 8 '&Open Workspace...' 9375 1 7250 nil true 7296 8 'OpenWorkspace.ico' 7344 nil nil 5762 1 5394 #fileFileIn 8 '&File In...' 1 1 7250 nil true 7296 8 'FileIn.ico' 7344 nil nil 5874 4097 5762 1 5394 #saveImage 8 'Sa&ve Image' 1 1 7250 nil true 7296 8 'Snapshot.ico' 7344 nil nil 5762 1 5394 #smalltalkExit 8 'E&xit Dolphin' 1 1 7250 nil true 7296 8 'PowerSwitch.ico' 7344 nil nil 5874 4097 5762 1 5394 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 20451 nil nil 5714 nil true 34 13 5762 1 5394 #undo 8 '&Undo' 9397 1 7250 nil true 7296 8 'EditUndo.ico' 7344 nil nil 5874 4097 5762 1 5394 #cutSelection 8 'Cu&t' 9393 1 7250 nil true 7296 8 'EditCut.ico' 7344 nil nil 5762 1 5394 #copySelection 8 '&Copy' 9351 1 7250 nil true 7296 8 'EditCopy.ico' 7344 nil nil 5762 1 5394 #pasteClipboard 8 '&Paste' 9389 1 7250 nil true 7296 8 'EditPaste.ico' 7344 nil nil 5762 1 5394 #editDelete 8 '&Delete' 1 1 7250 nil true 7296 8 'EditClear.ico' 7344 nil nil 5714 nil true 34 2 5762 1 5394 #reformatSource 8 '&Source' 9391 1 nil nil nil 5762 1 5394 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 20467 nil nil 5874 4097 5762 1 5394 #selectAll 8 'Select &All' 9347 1 nil nil nil 5874 4097 5762 1 5394 #editFind 8 '&Find...' 9357 1 7250 nil true 7296 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5762 1 5394 #findNext 8 'Find &Next' 1253 1 7250 nil true 7296 8 'FindNext.ico' 7344 nil nil 5762 1 5394 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 20477 nil nil 5714 nil true 34 16 5762 1 5394 #browseIt 8 '&Browse It' 9349 1 7250 nil true 7296 8 'ClassBrowserShell.ico' 7344 nil nil 5762 1 5394 #displayIt 8 '&Display It' 9353 1 7250 nil true 7296 8 'DisplayIt.ico' 7344 nil nil 5762 1 5394 #evaluateIt 8 '&Evaluate It' 9355 1 7250 nil true 7296 8 'EvaluateIt.ico' 7344 nil nil 5762 1 5394 #inspectIt 8 '&Inspect It' 9363 1 7250 nil true 7296 8 'InspectIt.ico' 7344 nil nil 5762 1 5394 #debugIt 8 'Deb&ug It' 1269 1 7250 nil true 7296 8 'Debugger.ico' 7344 nil nil 5762 1 5394 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5874 4097 5762 1 5394 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5762 1 5394 #browseReferences 8 '&References' 5367 1 nil nil nil 5874 4097 5762 2097153 5394 #accept 8 '&Accept' 9383 1 nil nil nil 5762 1 5394 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5874 4097 5714 nil true 34 14 5762 1 5394 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 5874 4097 5762 1 5394 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 5762 1 5394 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 5762 1 5394 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 5762 1 5394 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5874 4097 5762 1 5394 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5762 1 5394 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5762 1 5394 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5874 4097 5762 1 5394 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 5762 1 5394 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5762 1 5394 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 7250 nil true 7296 8 'Refactoring.ico' 7344 nil 20521 nil nil 5874 4097 5714 nil true 34 7 5762 1 5394 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5762 1 5394 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5762 1 5394 #toggleLineEndings 8 'Line &Endings' 1 1 7778 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5762 1 5394 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5762 1 5394 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5762 1 5394 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5762 1 5394 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 7250 nil true 7296 8 'Preferences.ico' 7344 nil 20537 nil nil 8 '&Workspace' nil 134217729 nil nil 20539 nil nil 5714 nil true 34 11 5714 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 20541 nil nil 5714 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 20543 nil nil 5714 nil true 34 11 5762 1 5394 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 5762 1 5394 #browseContainingText 8 'C&ontaining Text...' 1 1 7250 nil true 7296 8 'SearchText.ico' 7344 nil nil 5762 1 5394 #browseMethodCategory 8 'Cate&gory...' 1 1 7250 nil true 7296 8 'Category.ico' 7344 nil nil 5762 1 5394 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5762 1 5394 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5874 4097 5762 1 5394 #browseMethodPackages 8 'Package <s>' 1 1 7250 nil true 7296 8 'Package.ico' 7344 nil nil 5762 1 5394 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 5874 4097 5762 1 5394 #browseMethodHistory 8 '&Change History' 1 1 7250 nil true 7296 8 'MethodHistory.ico' 7344 nil nil 5762 1 5394 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 20563 nil nil 5874 4097 5762 1 5394 #removeMethod 8 '&Delete' 1 1 7250 nil true 7296 8 'EditClear.ico' 7344 nil nil 5714 nil true 34 17 5762 1 5394 #renameMethod 8 'Re&name' 1 1 nil nil nil 5762 1 5394 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5762 1 5394 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 5874 4097 5762 1 5394 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 5714 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 20575 nil nil 5714 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 20577 nil nil 5714 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 20579 nil nil 5874 4097 5714 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 20581 nil nil 5714 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 20583 nil nil 5874 4097 5762 1 5394 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5762 1 5394 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5762 1 5394 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5762 1 5394 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5762 1 5394 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 7250 nil true 7296 8 'Refactoring.ico' 7344 nil 20595 nil nil 5874 4097 5762 1 5394 #methodPackage 8 '&Package...' 1 1 7250 nil true 7296 8 'Package.ico' 7344 nil nil 5714 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 20599 nil nil 5714 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 20601 nil nil 5762 1 5394 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 20605 nil nil 5714 nil true 34 3 5762 1 5394 #undoChange 8 '&Undo <1d>' 1 1 7250 nil true 7296 8 'EditUndo.ico' 7344 nil nil 5762 1 5394 #redoChange 8 '&Redo <1d>' 1 1 7250 nil true 7296 8 'EditRedo.ico' 7344 nil nil 5762 1 5394 #clearChangeHistory 8 'Clear Change &History' 1 1 7250 nil true 7296 8 'MethodHistoryErase.ico' 7344 nil nil 8 'H&istory' nil 134217729 nil nil 20613 nil nil 5714 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 20615 nil nil 5714 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 20617 nil nil 5714 nil true 34 15 5762 1 5394 #helpContents 8 '&Contents' 1025 1 7250 nil true 7296 8 'Help.ico' 7344 nil nil 5762 1 5394 #help 8 'On this &Tool' 1249 1 nil nil nil 5762 1 5394 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5874 4097 5762 1 5394 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7778 $\x1F393 nil 262406 ##(Smalltalk.ARGB) 8 4292695180 786694 ##(Smalltalk.IndexedColor) 33554471 nil nil 1 nil nil nil nil 5874 4097 5762 1 5394 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5762 1 5394 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5762 1 5394 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5874 4097 5762 1 5394 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 7250 nil true 7296 8 '!!APPLICATION' 7344 nil nil 5762 1 5394 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5762 1 5394 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5874 4097 5762 1 5394 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7778 $\x1F42C nil nil 196934 1 ##(Smalltalk.RGB) 17741887 nil nil 1 nil nil nil nil 8 '&Help' nil 134217729 nil nil 20641 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 786 138 144 34 3 850 #createAt:extent: 34 2 898 3839 21 898 1811 871 416 850 #text: 34 1 8 'Method Explorer' 416 850 #updateMenuBar 992 416 946 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 8 11 0 0 189 1 0 0] 34 3 528 3216 2496 1008 nil 27 )! !
!MethodExplorerShell class categoriesFor: #browseMethodsInEnvironments:!instance creation!public! !
!MethodExplorerShell class categoriesFor: #displayOn:!displaying!public! !
!MethodExplorerShell class categoriesFor: #historyListSize!accessing!public! !
!MethodExplorerShell class categoriesFor: #historyListSize:!accessing!public! !
!MethodExplorerShell class categoriesFor: #initialize!initializing!private! !
!MethodExplorerShell class categoriesFor: #resource_Default_view!public!resources-views! !

