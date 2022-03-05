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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1877912960 170 192 34 12 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_History_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1405 1 882 169 51 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 2 0 0 0 0 0 0 18 3 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'historyTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1051 1 882 247 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 976 992 nil 27 8 'editTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(Smalltalk.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 615 1 882 437 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 976 992 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1504 nil nil nil 7 nil nil nil 1504 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1504 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1744 nil nil nil 7 nil nil nil 1744 738 ##(Smalltalk.Toolbar) #resource_Find_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1297 1 882 109 51 1744 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 190 2 0 0 25 0 0 0] 976 992 nil 27 8 'findTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1984 nil nil nil 7 nil nil nil 1984 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 63 51 1984 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 976 992 nil 27 8 'imageTools' 170 192 976 138 144 976 nil nil 1 nil 882 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1779 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 34 6 1984 1504 1264 1024 1744 672 992 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2464 nil nil nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 882 193 193 nil 2464 nil 8 1877614448 170 192 34 6 853766 ##(Smalltalk.StatusBarItem) 1 -1 2464 nil 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) nil 8 'version' 2674 1 45 2464 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2800 7 257 nil nil 8 'modified' 2674 1 841 2464 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' 34 3 2768 2944 2688 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2464 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 713 882 1779 41 2464 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 8 #() 992 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3184 nil nil nil 7 nil nil nil 3184 498 1 1 nil nil nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 3184 34 2 8 1409286144 131073 3264 nil nil nil 7 nil nil nil 3264 1180166 ##(Smalltalk.ProportionalLayout) 170 176 976 true 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 3264 34 2 8 1140916224 131073 3408 nil nil nil 7 nil nil nil 3408 738 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 337 882 1779 327 3408 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 976 992 nil 27 8 'source' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1779 663 3264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 34 3 410 ##(Smalltalk.ContainerView) 34 15 nil 3264 34 2 8 1140850688 131073 3808 nil nil nil 7 nil nil nil 3808 3330 138 ##(Smalltalk.Dictionary) 34 1 2898 410 ##(Smalltalk.Splitter) 34 12 nil 3808 34 2 8 1140850688 1 3936 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 3936 nil 1 #left nil nil nil 882 1 1 882 9 9 nil 4032 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 885 1 882 11 327 3936 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 8 #() 992 nil 27 1 false 170 192 34 4 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3808 34 2 8 1409286144 131073 4256 nil nil nil 519 nil nil nil 4256 656710 1 ##(Smalltalk.CardLayout) 138 144 34 1 2898 8 'History' 410 ##(Smalltalk.TreeView) 34 27 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 4256 34 2 8 1140850688 131073 4448 nil nil nil 7 nil nil nil 4448 4336 170 192 34 2 4416 8 'historyTree' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 4256 34 2 8 1140851328 1 4560 590662 2 ##(Smalltalk.ListModel) 138 144 34 1 4400 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 4560 nil 8 1877659392 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 885 327 4560 834 #setSingleSelection: 8 #(1) 4560 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4560 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 8 #() 992 nil 27 nil 4256 882 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 4448 nil 1 590342 ##(Smalltalk.Rectangle) 882 785 3 882 817 35 nil 1180998 4 ##(Smalltalk.CommandDescription) #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 57 9 882 821 311 4448 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 34 1 4416 992 nil 27 34 2 8 1140916775 1025 4416 590918 3 ##(Smalltalk.TreeModel) nil 4704 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 976 608 nil 7 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 5106 #browseMessageDefinitions 8 '&Definitions of...' 1 1 nil nil nil 5474 1 5106 #browseMessageReferences 8 '&References to...' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5474 1 5106 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4416 nil 8 1877733392 2706 #displayString 8 #() ##(Smalltalk.IconicListAbstract) 4752 nil nil nil nil nil 170 176 976 nil #noIcons 1 170 ##(Smalltalk.PluggableLookupTable) 976 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 37 882 821 275 4416 834 #contextMenu: 34 1 5440 4416 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 154 1 0 0 155 0 0 0] 8 #() 992 nil 27 4416 nil nil nil 170 192 976 nil 4560 4448 882 201 201 401 1 31 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 885 327 4256 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 34 2 4448 4560 992 nil 27 8 'historySlidey' 410 ##(Smalltalk.ReferenceView) 34 14 nil 3808 34 2 8 1140850688 131073 6160 nil nil nil 7 nil nil nil 6160 738 ##(Smalltalk.MethodBrowser) #resource_Method_browser_method_list nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 895 1 882 885 327 6160 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 976 992 nil 27 8 'methodlist' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1779 327 3808 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 34 3 4256 3936 6160 992 nil 27 410 ##(Smalltalk.Splitter) 34 12 nil 3264 34 2 8 1140850688 1 6560 nil nil nil 519 nil nil nil 4002 6560 nil 1 #left nil nil nil 4032 4048 nil 4032 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 327 882 1779 11 6560 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 8 #() 992 nil 27 3408 992 nil 27 170 192 34 2 3264 8 'browser' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1779 663 3184 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 34 1 3264 992 nil 27 170 192 34 4 2464 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 8 5426 nil true 34 8 5474 1 5106 #fileNew 8 '&New Workspace' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'NewWorkspace.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 5474 1 5106 #fileOpen 8 '&Open Workspace...' 9375 1 7202 nil true 7248 8 'OpenWorkspace.ico' 7296 nil nil 5474 1 5106 #fileFileIn 8 '&File In...' 1 1 7202 nil true 7248 8 'FileIn.ico' 7296 nil nil 5586 4097 5474 1 5106 #saveImage 8 'Sa&ve Image' 1 1 7202 nil true 7248 8 'Snapshot.ico' 7296 nil nil 5474 1 5106 #smalltalkExit 8 'E&xit Dolphin' 1 1 7202 nil true 7248 8 'PowerSwitch.ico' 7296 nil nil 5586 4097 5474 1 5106 #exit 8 '&Close' 17639 1 788806 1 ##(Smalltalk.TextTileIcon) $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 57287 nil nil 5426 nil true 34 13 5474 1 5106 #undo 8 '&Undo' 9397 1 7202 nil true 7248 8 'EditUndo.ico' 7296 nil nil 5586 4097 5474 1 5106 #cutSelection 8 'Cu&t' 9393 1 7202 nil true 7248 8 'EditCut.ico' 7296 nil nil 5474 1 5106 #copySelection 8 '&Copy' 9351 1 7202 nil true 7248 8 'EditCopy.ico' 7296 nil nil 5474 1 5106 #pasteClipboard 8 '&Paste' 9389 1 7202 nil true 7248 8 'EditPaste.ico' 7296 nil nil 5474 1 5106 #editDelete 8 '&Delete' 1 1 7202 nil true 7248 8 'EditClear.ico' 7296 nil nil 5426 nil true 34 2 5474 1 5106 #reformatSource 8 '&Source' 9391 1 nil nil nil 5474 1 5106 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 57303 nil nil 5586 4097 5474 1 5106 #selectAll 8 'Select &All' 9347 1 nil nil nil 5586 4097 5474 1 5106 #editFind 8 '&Find...' 9357 1 7202 nil true 7248 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5474 1 5106 #findNext 8 'Find &Next' 1253 1 7202 nil true 7248 8 'FindNext.ico' 7296 nil nil 5474 1 5106 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 57313 nil nil 5426 nil true 34 17 5474 1 5106 #browseIt 8 '&Browse It' 9349 1 7202 nil true 7248 8 'ClassBrowserShell.ico' 7296 nil nil 5474 1 5106 #displayIt 8 '&Display It' 9353 1 7202 nil true 7248 8 'DisplayIt.ico' 7296 nil nil 5474 1 5106 #printIt 8 '&Print It' 9377 1 7202 nil true 7248 8 'PrintIt.ico' 7296 nil nil 5474 1 5106 #evaluateIt 8 '&Evaluate It' 9355 1 7202 nil true 7248 8 'EvaluateIt.ico' 7296 nil nil 5474 1 5106 #inspectIt 8 '&Inspect It' 9363 1 7202 nil true 7248 8 'InspectIt.ico' 7296 nil nil 5474 1 5106 #debugIt 8 'Deb&ug It' 1269 1 7202 nil true 7248 8 'Debugger.ico' 7296 nil nil 5474 1 5106 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5586 4097 5474 1 5106 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5474 1 5106 #browseReferences 8 '&References' 5367 1 nil nil nil 5586 4097 5474 2097153 5106 #accept 8 '&Accept' 9383 1 nil nil nil 5474 1 5106 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5586 4097 5426 nil true 34 14 5474 1 5106 #renameVariable 8 'Re&name <1d>...' 1 1 nil nil nil 5586 4097 5474 1 5106 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 nil nil nil 5474 1 5106 #extractMethod 8 'E&xtract Method...' 9371 1 nil nil nil 5474 1 5106 #extractToComponent 8 'Extract to &Component...' 1 1 nil nil nil 5474 1 5106 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5586 4097 5474 1 5106 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5474 1 5106 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5474 1 5106 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5586 4097 5474 1 5106 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 5474 1 5106 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5474 1 5106 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Re&factorings' #codeRefactoringsMenu 134217729 7202 nil true 7248 8 'Refactoring.ico' 7296 nil 57359 nil nil 5586 4097 5426 nil true 34 7 5474 1 5106 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5474 1 5106 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5474 1 5106 #toggleLineEndings 8 'Line &Endings' 1 1 7730 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5474 1 5106 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5474 1 5106 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5474 1 5106 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5474 1 5106 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 7202 nil true 7248 8 'Preferences.ico' 7296 nil 57375 nil nil 8 '&Workspace' nil 134217729 nil nil 57377 nil nil 5426 nil true 34 11 5426 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil 57379 nil nil 5426 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil 57381 nil nil 5426 nil true 34 11 5474 1 5106 #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 5474 1 5106 #browseContainingText 8 'C&ontaining Text...' 1 1 7202 nil true 7248 8 'SearchText.ico' 7296 nil nil 5474 1 5106 #browseMethodCategory 8 'Cate&gory...' 1 1 7202 nil true 7248 8 'Category.ico' 7296 nil nil 5474 1 5106 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5474 1 5106 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5586 4097 5474 1 5106 #browseMethodPackages 8 'Package <s>' 1 1 7202 nil true 7248 8 'Package.ico' 7296 nil nil 5474 1 5106 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 5586 4097 5474 1 5106 #browseMethodHistory 8 '&Change History' 1 1 7202 nil true 7248 8 'MethodHistory.ico' 7296 nil nil 5474 1 5106 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 57401 nil nil 5586 4097 5474 1 5106 #removeMethod 8 '&Delete' 1 1 7202 nil true 7248 8 'EditClear.ico' 7296 nil nil 5426 nil true 34 17 5474 1 5106 #renameMethod 8 'Re&name' 1 1 nil nil nil 5474 1 5106 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5474 1 5106 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 5586 4097 5474 1 5106 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 5426 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 57413 nil nil 5426 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 57415 nil nil 5426 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 57417 nil nil 5586 4097 5426 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 57419 nil nil 5426 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 57421 nil nil 5586 4097 5474 1 5106 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5474 1 5106 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5474 1 5106 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5474 1 5106 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5474 1 5106 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 7202 nil true 7248 8 'Refactoring.ico' 7296 nil 57433 nil nil 5586 4097 5474 1 5106 #methodPackage 8 '&Package...' 1 1 7202 nil true 7248 8 'Package.ico' 7296 nil nil 5426 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 57437 nil nil 5426 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil 57439 nil nil 5474 1 5106 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 57443 nil nil 5426 nil true 34 3 5474 1 5106 #undoChange 8 '&Undo <1d>' 1 1 7202 nil true 7248 8 'EditUndo.ico' 7296 nil nil 5474 1 5106 #redoChange 8 '&Redo <1d>' 1 1 7202 nil true 7248 8 'EditRedo.ico' 7296 nil nil 5474 1 5106 #clearChangeHistory 8 'Clear Change &History' 1 1 7202 nil true 7248 8 'MethodHistoryErase.ico' 7296 nil nil 8 'H&istory' nil 134217729 nil nil 57451 nil nil 5426 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 57453 nil nil 5426 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 57455 nil nil 5426 nil true 34 15 5474 1 5106 #helpContents 8 '&Contents' 1025 1 7202 nil true 7248 8 'Help.ico' 7296 nil nil 5474 1 5106 #help 8 'On this &Tool' 1249 1 nil nil nil 5474 1 5106 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5586 4097 5474 1 5106 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7730 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 5586 4097 5474 1 5106 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5474 1 5106 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5474 1 5106 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5586 4097 5474 1 5106 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 7202 nil true 7248 8 '!!APPLICATION' 7296 nil nil 5474 1 5106 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5474 1 5106 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5586 4097 5474 1 5106 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7730 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 1811 871 416 834 #text: 34 1 8 'Method Explorer' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 136 15 0 0 189 1 0 0] 34 3 528 3184 2464 992 nil 27 )! !
!MethodExplorerShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
displayOn:!displaying!public! !
historyListSize!accessing!public! !
historyListSize:!accessing!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

