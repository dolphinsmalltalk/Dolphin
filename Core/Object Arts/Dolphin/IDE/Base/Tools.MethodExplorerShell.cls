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

onTreeSelectionChanged
	self killVisitTimer.
	historyTree selectionOrNil
		ifNil: 
			[self caption: self class displayString.
			browserPresenter methods: (BrowserEnvironment new forMethods: #())]
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

queryHistoryBack: aCommandQuery
	self hasPast
		ifTrue: 
			[aCommandQuery
				beEnabled;
				expandMenuTextWith: historyList previous]!

queryHistoryForward: aCommandQuery
	self hasFuture
		ifTrue: 
			[aCommandQuery
				beEnabled;
				expandMenuTextWith: historyList next]!

queryRemoveHistoryNode: aCommandQuery
	aCommandQuery
		isEnabled: historyTree hasSelection;
		text: 'Delete History Node'!

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
	<commandQuery: #queryRemoveHistoryNode:>
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
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultHelpId!public! !
deleteItCommand!commands-mappings!private! !
futureSize!accessing!public! !
historySkip:!commands!private! !
historyTree!public! !
initialize!initializing!private! !
isSameMethod:as:!helpers!private! !
killVisitTimer!helpers!private! !
methods:!accessing!public! !
onMethodSelected!event handling!private! !
onTimerTick:!event handling!private! !
onTreeSelectionChanged!event handling!private! !
onViewOpened!event handling!private! !
pastSize!accessing!public! !
queryHistoryBack:!commands!private! !
queryHistoryForward:!commands!private! !
queryRemoveHistoryNode:!commands!private! !
recordMethodVisit!helpers!private! !
removeHistoryNode!commands-actions!private! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 12 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Edit_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1051 1 498 247 51 304 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'editTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 640 nil nil nil 5 nil nil nil 640 370 #{UI.Toolbar} #resource_Find_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1297 1 498 109 51 640 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 190 2 0 0 25 0 0 0] 592 608 nil 27 8 'findTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 864 nil nil nil 5 nil nil nil 864 370 #{UI.Toolbar} #resource_History_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1405 1 498 169 51 864 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 2 0 0 0 0 0 0 18 3 0 0 25 0 0 0] 592 608 nil 27 8 'historyTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1088 nil nil nil 5 nil nil nil 1088 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 63 51 1088 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 592 608 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1312 nil nil nil 5 nil nil nil 1312 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createAt:extent: 50 2 498 615 1 498 437 51 1312 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 592 608 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1536 nil nil nil 5 nil nil nil 1536 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createAt:extent: 50 2 498 63 1 498 553 51 1536 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 592 608 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 1 nil 498 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1779 51 160 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 50 6 1088 1536 1312 304 640 864 608 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140853004 1 1984 nil nil nil 5 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 498 193 193 nil 1984 nil nil 258 #{Core.IdentityDictionary} 50 6 1862 1 #{UI.StatusBarItem} 8193 -1 1984 nil 518 #{Core.Message} #displayString 8 #() 2210 #iconImageIndex 2240 nil 8 'errors' 2178 8193 45 1984 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 6 1 2304 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1094 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #current #changedIcon #imageIndex #ifTrue: 2320 7 257 nil 2306 0 nil 2338 3 1 2304 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2448 #ifTrue: 7 257 nil 8 'modified' 2178 8705 351 1984 nil 2210 #displayString 8 #() 2210 #iconImageIndex 8 #() 2306 0 nil 2338 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2640 7 257 nil 8 'namespace' nil nil nil 50 3 2288 2192 2560 1094 1 #{UI.StatusBarNullItem} 8705 1 1984 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 713 498 1779 41 1984 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 8 #() 608 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2944 nil nil nil 5 nil nil nil 2944 130 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 2944 50 2 8 1409286144 131073 3024 nil nil nil 5 nil nil nil 3024 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 258 #{Core.IdentityDictionary} 50 2 18 #{UI.ReferenceView} 50 14 nil 3024 50 2 8 1140916224 131073 3184 nil nil nil 5 nil nil nil 3184 370 #{Tools.MethodWorkspace} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 1 337 498 1779 327 3184 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 592 608 nil 27 8 'source' nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1779 663 3024 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 50 3 18 #{UI.ContainerView} 50 15 nil 3024 50 2 8 1140850688 131073 3552 nil nil nil 5 nil nil nil 3552 3090 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 3552 50 2 8 1140850688 1 3712 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 3712 nil 1 #left nil nil nil 498 1 1 498 9 9 nil 3808 nil 402 50 1 450 #createAt:extent: 50 2 498 885 1 498 11 327 3712 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 8 #() 608 nil 27 1 false 258 #{Core.IdentityDictionary} 50 4 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 3552 50 2 8 1409286144 131073 4016 nil nil nil 517 nil nil nil 4016 1350 1 #{UI.CardLayout} 1762 1 3682 8 'History' 18 #{UI.TreeView} 50 27 nil 18 #{UI.SlidingCardTray} 50 22 nil 4016 50 2 8 1140850688 131073 4192 nil nil nil 5 nil nil nil 4192 4096 258 #{Core.IdentityDictionary} 50 2 4160 8 'historyTree' nil 18 #{UI.TabViewXP} 50 28 nil 4016 50 2 8 1140851328 1 4304 838 2 #{UI.ListModel} 1762 1 4144 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 4304 nil nil 2224 2256 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 402 50 3 450 #createAt:extent: 50 2 498 1 1 498 885 327 4304 450 #setSingleSelection: 8 #(1) 4304 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4304 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 8 #() 608 nil 27 nil 4016 498 33 33 1606 1 #{UI.ButtonInteractor} 4192 nil 1 518 #{Graphics.Rectangle} 498 785 3 498 817 35 nil 1350 4 #{UI.CommandDescription} #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createAt:extent: 50 2 498 57 9 498 821 311 4192 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 50 1 4160 608 nil 27 50 2 8 1140916775 1025 4160 1094 3 #{UI.TreeModel} nil 4432 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 240 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 4802 #browseMessageDefinitions 8 '&Definitions of…' 1 1 nil nil nil 5170 1 4802 #browseMessageReferences 8 '&References to…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 5170 1 4802 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4160 nil nil 2210 #displayString 8 #() 2256 4464 nil nil nil nil nil 3122 0 nil #noIcons 1 5090 0 402 50 1 450 #createAt:extent: 50 2 498 1 37 498 821 275 4160 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 154 1 0 0 155 0 0 0] 8 #() 608 nil 27 4160 nil nil nil 5090 0 nil 4304 4192 498 201 201 401 1 31 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 885 327 4016 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 50 2 4192 4304 608 nil 27 8 'historySlidey' 18 #{UI.ReferenceView} 50 14 nil 3552 50 2 8 1140850688 131073 5776 nil nil nil 5 nil nil nil 5776 370 #{Tools.MethodBrowser} #resource_Method_browser_method_list nil 402 50 1 450 #createAt:extent: 50 2 498 895 1 498 885 327 5776 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 592 608 nil 27 8 'methodlist' nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1779 327 3552 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 50 3 4016 3712 5776 608 nil 27 18 #{UI.Splitter} 50 12 nil 3024 50 2 8 1140850688 1 6144 nil nil nil 517 nil nil nil 3778 6144 nil 1 #left nil nil nil 3808 3824 nil 3808 nil 402 50 1 450 #createAt:extent: 50 2 498 1 327 498 1779 11 6144 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 8 #() 608 nil 27 3184 608 nil 27 258 5088 50 2 3024 8 'browser' nil 402 50 1 450 #createAt:extent: 50 2 498 1 51 498 1779 663 2944 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 50 1 3024 608 nil 27 258 5088 50 4 1984 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 8 5122 nil true 50 8 5170 1 4802 #fileNew 8 '&New Workspace' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 5170 1 4802 #fileOpen 8 '&Open Workspace…' 9375 1 6754 nil true 6786 8 'OpenWorkspace.ico' 6848 65541 nil nil nil 5170 1 4802 #fileFileIn 8 '&File In…' 1 1 6754 nil true 6786 8 'FileIn.ico' 6848 65541 nil nil nil 5282 4097 5170 1 4802 #saveImage 8 'Sa&ve Image' 1 1 6754 nil true 6786 8 'Snapshot.ico' 6848 65541 nil nil nil 5170 1 4802 #smalltalkExit 8 'E&xit Dolphin' 1 1 6754 nil true 6786 8 'PowerSwitch.ico' 6848 65541 nil nil nil 5282 4097 5170 1 4802 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 5122 nil true 50 13 5170 1 4802 #undo 8 '&Undo' 9397 1 6754 nil true 6786 8 'EditUndo.ico' 6848 65541 nil nil nil 5282 4097 5170 1 4802 #cutSelection 8 'Cu&t' 9393 1 6754 nil true 6786 8 'EditCut.ico' 6848 65541 nil nil nil 5170 1 4802 #copySelection 8 '&Copy' 9351 1 6754 nil true 6786 8 'EditCopy.ico' 6848 65541 nil nil nil 5170 1 4802 #pasteClipboard 8 '&Paste' 9389 1 6754 nil true 6786 8 'EditPaste.ico' 6848 65541 nil nil nil 5170 1 4802 #editDelete 8 '&Delete' 1 1 6754 nil true 6786 8 'EditClear.ico' 6848 65541 nil nil nil 5122 nil true 50 2 5170 1 4802 #reformatSource 8 '&Source' 9391 1 nil nil nil 5170 1 4802 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil nil nil nil 5282 4097 5170 1 4802 #selectAll 8 'Select &All' 9347 1 nil nil nil 5282 4097 5170 1 4802 #editFind 8 '&Find…' 9357 1 6754 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 5170 1 4802 #findNext 8 'Find &Next' 1253 1 6754 nil true 6786 8 'FindNext.ico' 6848 65541 nil nil nil 5170 1 4802 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 5122 nil true 50 17 5170 1 4802 #browseIt 8 '&Browse It' 9349 1 6754 nil true 6786 8 'ClassBrowserShell.ico' 6848 65541 nil nil nil 5170 1 4802 #displayIt 8 '&Display It' 9353 1 6754 nil true 6786 8 'DisplayIt.ico' 6848 65541 nil nil nil 5170 1 4802 #printIt 8 '&Print It' 9377 1 6754 nil true 6786 8 'PrintIt.ico' 6848 65541 nil nil nil 5170 1 4802 #evaluateIt 8 '&Evaluate It' 9355 1 6754 nil true 6786 8 'EvaluateIt.ico' 6848 65541 nil nil nil 5170 1 4802 #inspectIt 8 '&Inspect It' 9363 1 6754 nil true 6786 8 'InspectIt.ico' 6848 65541 nil nil nil 5170 1 4802 #debugIt 8 'Deb&ug It' 1269 1 6754 nil true 6786 8 'Debugger.ico' 6848 65541 nil nil nil 5170 1 4802 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5282 4097 5170 1 4802 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5170 1 4802 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 5282 4097 5170 2097153 4802 #accept 8 '&Accept' 9383 1 nil nil nil 5170 1 4802 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5282 4097 5122 nil true 50 14 5170 1 4802 #renameVariable 8 'Re&name <d:Variable>…' 1 17 nil nil nil 5282 4097 5170 1 4802 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 5170 1 4802 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 5170 1 4802 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 5170 1 4802 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5282 4097 5170 1 4802 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5170 1 4802 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5170 1 4802 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5282 4097 5170 1 4802 #addParameterToMessage 8 '&Add Parameter to <d:Message>…' 1 17 nil nil nil 5170 1 4802 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5170 1 4802 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 6754 nil true 6786 8 'Refactoring.ico' 6848 65541 nil nil nil nil nil 5282 4097 5122 nil true 50 7 5170 1 4802 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5170 1 4802 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5170 1 4802 #toggleLineEndings 8 'Line &Endings' 1 1 7346 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5170 1 4802 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5170 1 4802 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5170 1 4802 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5170 1 4802 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 6754 nil true 6786 8 'Preferences.ico' 6848 65541 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 5122 nil true 50 11 5122 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil nil nil nil 5122 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil nil nil nil 5122 nil true 50 11 5170 1 4802 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 5170 1 4802 #browseContainingText 8 'C&ontaining Text…' 1 1 6754 nil true 6786 8 'SearchText.ico' 6848 65541 nil nil nil 5170 1 4802 #browseMethodCategory 8 'Cate&gory…' 1 1 6754 nil true 6786 8 'Category.ico' 6848 65541 nil nil nil 5170 1 4802 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5170 1 4802 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5282 4097 5170 1 4802 #browseMethodPackages 8 'Package <s>' 1 17 6754 nil true 6786 8 'Package.ico' 6848 65541 nil nil nil 5170 1 4802 #browseMethodClasses 8 'Class <s>' 1 17 nil nil nil 5282 4097 5170 1 4802 #browseMethodHistory 8 '&Change History' 1 1 6754 nil true 6786 8 'MethodHistory.ico' 6848 65541 nil nil nil 5170 1 4802 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil nil nil nil 5282 4097 5170 1 4802 #removeMethod 8 'Re&move' 1 1 6754 nil true 6786 8 'MethodDelete.ico' 6848 65541 nil nil nil 5122 nil true 50 16 5170 1 4802 #renameMethod 8 'Re&name' 1 1 nil nil nil 5170 1 4802 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 5282 4097 5170 1 4802 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 5122 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 5122 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil nil nil nil 5122 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil nil nil nil 5282 4097 5122 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil nil nil nil 5122 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil nil nil nil 5282 4097 5170 1 4802 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5170 1 4802 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5170 1 4802 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5170 1 4802 #overrideMethods 8 'Ove&rride <d:Methods>' 1 17 nil nil nil 5170 1 4802 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 6754 nil true 6786 8 'Refactoring.ico' 6848 65541 nil nil nil nil nil 5282 4097 5170 1 4802 #methodPackage 8 '&Package…' 1 1 6754 nil true 6786 8 'Package.ico' 6848 65541 nil nil nil 5122 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil nil nil nil 5122 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil nil nil nil 5170 1 4802 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil nil nil nil 5122 nil true 50 3 5170 1 4802 #undoChange 8 '&Undo <d:…>' 1 17 6754 nil true 6786 8 'EditUndo.ico' 6848 65541 nil nil nil 5170 1 4802 #redoChange 8 '&Redo <d:…>' 1 17 6754 nil true 6786 8 'EditRedo.ico' 6848 65541 nil nil nil 5170 1 4802 #clearChangeHistory 8 'Clear Change &History' 1 1 6754 nil true 6786 8 'MethodHistoryErase.ico' 6848 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil nil nil nil 5122 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 5122 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 5122 nil true 50 15 5170 1 4802 #helpContents 8 '&Contents' 1025 1 6754 nil true 6786 8 'Help.ico' 6848 65541 nil nil nil 5170 1 4802 #help 8 'On this &Tool' 1249 1 nil nil nil 5170 1 4802 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5282 4097 5170 1 4802 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7346 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 5282 4097 5170 1 4802 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5170 1 4802 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5170 1 4802 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5282 4097 5170 1 4802 #dolphinHomePage 8 'Dolphin Homepage' 1 1 6754 nil true 6786 8 '!!APPLICATION' 6848 65541 nil nil nil 5170 1 4802 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5170 1 4802 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5282 4097 5170 1 4802 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7346 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 402 50 2 450 #createAt:extent: 50 2 498 6143 21 498 1811 871 32 450 #text: 50 1 8 'Method Explorer' 32 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 136 15 0 0 189 1 0 0] 50 3 160 2944 1984 608 nil 27)! !
!Tools.MethodExplorerShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
defaultDefaultSlideyPinsMap!constants!options!private! !
displayOn:!displaying!public! !
historyListSize!accessing!public! !
historyListSize:!accessing!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

