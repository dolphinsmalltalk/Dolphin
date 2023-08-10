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
		ifFalse: [aCommandQuery text: 'Forward']!

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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 519 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 519 nil nil nil 160 6 #{Graphics.Color} #default 8 1853287488 550 #{Core.IdentityDictionary} 6 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 7 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Find_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1297 1 498 109 51 304 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 136 2 0 0 0 0 0 0 190 2 0 0 25 0 0 0] 8 #() 498 193 193 nil 27 8 'findTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 640 nil nil nil 7 nil nil nil 640 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createAt:extent: 50 2 498 615 1 498 437 51 640 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 592 608 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 864 nil nil nil 7 nil nil nil 864 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 63 51 864 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 592 608 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1088 nil nil nil 7 nil nil nil 1088 370 #{UI.Toolbar} #resource_History_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1405 1 498 169 51 1088 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 190 2 0 0 0 0 0 0 18 3 0 0 25 0 0 0] 592 608 nil 27 8 'historyTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1312 nil nil nil 7 nil nil nil 1312 370 #{UI.Toolbar} #resource_Edit_tools nil 402 50 1 450 #createAt:extent: 50 2 498 1051 1 498 247 51 1312 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 136 2 0 0 25 0 0 0] 592 608 nil 27 8 'editTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1536 nil nil nil 7 nil nil nil 1536 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createAt:extent: 50 2 498 63 1 498 553 51 1536 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 592 608 nil 27 8 'smalltalkTools' nil nil nil 274 0 550 #{Core.OrderedCollection} 0 nil nil 1 nil 498 33 33 nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1779 51 160 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 50 6 864 1536 640 1312 304 1088 608 nil 29 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140853004 1 2000 nil nil nil 7 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 59 0 0 0 0 247 0 5 86 111 1] 498 193 193 nil 2000 nil 8 1852980448 274 3 1862 1 #{UI.StatusBarItem} 8193 -1 2000 nil 518 #{Core.Message} #displayString 8 #() 2226 #iconImageIndex 2256 nil 8 'errors' 2194 8193 45 2000 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 6 1 2320 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1094 2 #{Kernel.VariableBinding} #'Tools.SmalltalkSystem' #{Tools.SmalltalkSystem} #{Smalltalk} 1 #current #changedIcon #imageIndex #ifTrue: 2336 7 257 nil 2322 0 nil 2354 3 1 2320 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2464 #ifTrue: 7 257 nil 8 'modified' 2194 8705 351 2000 nil 2226 #displayString 8 #() 2226 #iconImageIndex 8 #() 2322 0 nil 2354 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2656 7 257 nil 8 'namespace' nil nil nil 50 3 2304 2208 2576 1094 1 #{UI.StatusBarNullItem} 8705 1 2000 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 713 498 1779 41 2000 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 8 #() 608 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2960 nil nil nil 7 nil nil nil 2960 130 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 2960 50 2 8 1409286144 131073 3040 nil nil nil 7 nil nil nil 3040 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 274 1 18 #{UI.ReferenceView} 50 14 nil 3040 50 2 8 1140916224 131073 3184 nil nil nil 7 nil nil nil 3184 370 #{Tools.MethodWorkspace} #resource_Default_view nil 402 50 1 450 #createAt:extent: 50 2 498 1 337 498 1779 327 3184 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 592 608 nil 27 8 'source' nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1779 663 3040 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 50 3 18 #{UI.ContainerView} 50 15 nil 3040 50 2 8 1140850688 131073 3552 nil nil nil 7 nil nil nil 3552 3106 294 #{Core.Dictionary} 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 3552 50 2 8 1140850688 1 3696 nil nil nil 519 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 3696 nil 1 #left nil nil nil 498 1 1 498 9 9 nil 3792 nil 402 50 1 450 #createAt:extent: 50 2 498 885 1 498 11 327 3696 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 8 #() 608 nil 27 1 false 274 2 18 #{UI.ReferenceView} 50 14 nil 3552 50 2 8 1140850688 131073 3984 nil nil nil 7 nil nil nil 3984 370 #{Tools.MethodBrowser} #resource_Method_browser_method_list nil 402 50 1 450 #createAt:extent: 50 2 498 895 1 498 885 327 3984 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 592 608 nil 27 8 'methodlist' 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 3552 50 2 8 1409286144 131073 4208 nil nil nil 519 nil nil nil 4208 1350 1 #{UI.CardLayout} 1778 1 3666 8 'History' 18 #{UI.TreeView} 50 27 nil 18 #{UI.SlidingCardTray} 50 22 nil 4208 50 2 8 1140850688 131073 4384 nil nil nil 7 nil nil nil 4384 4288 274 1 4352 8 'historyTree' nil 18 #{UI.TabViewXP} 50 28 nil 4208 50 2 8 1140851328 1 4480 838 2 #{UI.ListModel} 1778 1 4336 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 4480 nil 8 1852839600 2240 2272 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 402 50 3 450 #createAt:extent: 50 2 498 1 1 498 885 327 4480 450 #setSingleSelection: 8 #(1) 4480 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4480 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 8 #() 608 nil 27 nil 4208 498 33 33 1606 1 #{UI.ButtonInteractor} 4384 nil 1 518 #{Graphics.Rectangle} 498 785 3 498 817 35 nil 1350 4 #{UI.CommandDescription} #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createAt:extent: 50 2 498 57 9 498 821 311 4384 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 50 1 4352 608 nil 27 50 2 8 1140916775 1025 4352 1094 3 #{UI.TreeModel} nil 4608 774 #{UI.TreeNode} nil nil nil 274 0 240 nil 7 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 4994 #browseMessageDefinitions 8 '&Definitions of…' 1 1 nil nil nil 5346 1 4994 #browseMessageReferences 8 '&References to…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 5346 1 4994 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4352 nil 8 1852941248 2226 #displayString 8 #() 2272 4656 nil nil nil nil nil 3138 0 nil #noIcons 1 274 0 402 50 1 450 #createAt:extent: 50 2 498 1 37 498 821 275 4352 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 154 1 0 0 155 0 0 0] 8 #() 608 nil 27 4352 nil nil nil 274 0 nil 4480 4384 498 201 201 401 1 31 nil nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 885 327 4208 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 50 2 4384 4480 608 nil 27 8 'historySlidey' nil 402 50 1 450 #createAt:extent: 50 2 498 1 1 498 1779 327 3552 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 50 3 4208 3696 3984 608 nil 27 18 #{UI.Splitter} 50 12 nil 3040 50 2 8 1140850688 1 6112 nil nil nil 519 nil nil nil 3762 6112 nil 1 #left nil nil nil 3792 3808 nil 3792 nil 402 50 1 450 #createAt:extent: 50 2 498 1 327 498 1779 11 6112 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 8 #() 608 nil 27 3184 608 nil 27 274 1 3040 8 'browser' nil 402 50 1 450 #createAt:extent: 50 2 498 1 51 498 1779 663 2960 546 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 50 1 3040 608 nil 27 274 2 2000 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 8 5298 nil true 50 8 5346 1 4994 #fileNew 8 '&New Workspace' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 5346 1 4994 #fileOpen 8 '&Open Workspace…' 9375 1 6690 nil true 6722 8 'OpenWorkspace.ico' 6784 65541 nil nil nil 5346 1 4994 #fileFileIn 8 '&File In…' 1 1 6690 nil true 6722 8 'FileIn.ico' 6784 65541 nil nil nil 5458 4097 5346 1 4994 #saveImage 8 'Sa&ve Image' 1 1 6690 nil true 6722 8 'Snapshot.ico' 6784 65541 nil nil nil 5346 1 4994 #smalltalkExit 8 'E&xit Dolphin' 1 1 6690 nil true 6722 8 'PowerSwitch.ico' 6784 65541 nil nil nil 5458 4097 5346 1 4994 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 51219 nil nil 5298 nil true 50 13 5346 1 4994 #undo 8 '&Undo' 9397 1 6690 nil true 6722 8 'EditUndo.ico' 6784 65541 nil nil nil 5458 4097 5346 1 4994 #cutSelection 8 'Cu&t' 9393 1 6690 nil true 6722 8 'EditCut.ico' 6784 65541 nil nil nil 5346 1 4994 #copySelection 8 '&Copy' 9351 1 6690 nil true 6722 8 'EditCopy.ico' 6784 65541 nil nil nil 5346 1 4994 #pasteClipboard 8 '&Paste' 9389 1 6690 nil true 6722 8 'EditPaste.ico' 6784 65541 nil nil nil 5346 1 4994 #editDelete 8 '&Delete' 1 1 6690 nil true 6722 8 'EditClear.ico' 6784 65541 nil nil nil 5298 nil true 50 2 5346 1 4994 #reformatSource 8 '&Source' 9391 1 nil nil nil 5346 1 4994 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil 51235 nil nil 5458 4097 5346 1 4994 #selectAll 8 'Select &All' 9347 1 nil nil nil 5458 4097 5346 1 4994 #editFind 8 '&Find…' 9357 1 6690 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 5346 1 4994 #findNext 8 'Find &Next' 1253 1 6690 nil true 6722 8 'FindNext.ico' 6784 65541 nil nil nil 5346 1 4994 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 51245 nil nil 5298 nil true 50 17 5346 1 4994 #browseIt 8 '&Browse It' 9349 1 6690 nil true 6722 8 'ClassBrowserShell.ico' 6784 65541 nil nil nil 5346 1 4994 #displayIt 8 '&Display It' 9353 1 6690 nil true 6722 8 'DisplayIt.ico' 6784 65541 nil nil nil 5346 1 4994 #printIt 8 '&Print It' 9377 1 6690 nil true 6722 8 'PrintIt.ico' 6784 65541 nil nil nil 5346 1 4994 #evaluateIt 8 '&Evaluate It' 9355 1 6690 nil true 6722 8 'EvaluateIt.ico' 6784 65541 nil nil nil 5346 1 4994 #inspectIt 8 '&Inspect It' 9363 1 6690 nil true 6722 8 'InspectIt.ico' 6784 65541 nil nil nil 5346 1 4994 #debugIt 8 'Deb&ug It' 1269 1 6690 nil true 6722 8 'Debugger.ico' 6784 65541 nil nil nil 5346 1 4994 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5458 4097 5346 1 4994 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5346 1 4994 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 5458 4097 5346 2097153 4994 #accept 8 '&Accept' 9383 1 nil nil nil 5346 1 4994 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5458 4097 5298 nil true 50 14 5346 1 4994 #renameVariable 8 'Re&name <1d>…' 1 1 nil nil nil 5458 4097 5346 1 4994 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 5346 1 4994 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 5346 1 4994 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 5346 1 4994 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5458 4097 5346 1 4994 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5346 1 4994 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5346 1 4994 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5458 4097 5346 1 4994 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 5346 1 4994 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5346 1 4994 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 6690 nil true 6722 8 'Refactoring.ico' 6784 65541 nil nil 51291 nil nil 5458 4097 5298 nil true 50 7 5346 1 4994 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5346 1 4994 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5346 1 4994 #toggleLineEndings 8 'Line &Endings' 1 1 7282 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5346 1 4994 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5346 1 4994 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5346 1 4994 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5346 1 4994 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 6690 nil true 6722 8 'Preferences.ico' 6784 65541 nil nil 51307 nil nil 8 '&Workspace' nil 134217729 nil nil 51309 nil nil 5298 nil true 50 11 5298 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil 51311 nil nil 5298 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil 51313 nil nil 5298 nil true 50 11 5346 1 4994 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 5346 1 4994 #browseContainingText 8 'C&ontaining Text…' 1 1 6690 nil true 6722 8 'SearchText.ico' 6784 65541 nil nil nil 5346 1 4994 #browseMethodCategory 8 'Cate&gory…' 1 1 6690 nil true 6722 8 'Category.ico' 6784 65541 nil nil nil 5346 1 4994 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5346 1 4994 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5458 4097 5346 1 4994 #browseMethodPackages 8 'Package <s>' 1 1 6690 nil true 6722 8 'Package.ico' 6784 65541 nil nil nil 5346 1 4994 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 5458 4097 5346 1 4994 #browseMethodHistory 8 '&Change History' 1 1 6690 nil true 6722 8 'MethodHistory.ico' 6784 65541 nil nil nil 5346 1 4994 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil 51333 nil nil 5458 4097 5346 1 4994 #removeMethod 8 'Re&move' 1 1 6690 nil true 6722 8 'MethodDelete.ico' 6784 65541 nil nil nil 5298 nil true 50 16 5346 1 4994 #renameMethod 8 'Re&name' 1 1 nil nil nil 5346 1 4994 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 5458 4097 5346 1 4994 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 5298 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil 51343 nil nil 5298 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil 51345 nil nil 5298 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil 51347 nil nil 5458 4097 5298 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil 51349 nil nil 5298 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil 51351 nil nil 5458 4097 5346 1 4994 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5346 1 4994 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5346 1 4994 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5346 1 4994 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 5346 1 4994 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 6690 nil true 6722 8 'Refactoring.ico' 6784 65541 nil nil 51363 nil nil 5458 4097 5346 1 4994 #methodPackage 8 '&Package…' 1 1 6690 nil true 6722 8 'Package.ico' 6784 65541 nil nil nil 5298 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil 51367 nil nil 5298 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil 51369 nil nil 5346 1 4994 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil 51373 nil nil 5298 nil true 50 3 5346 1 4994 #undoChange 8 '&Undo <1d>' 1 1 6690 nil true 6722 8 'EditUndo.ico' 6784 65541 nil nil nil 5346 1 4994 #redoChange 8 '&Redo <1d>' 1 1 6690 nil true 6722 8 'EditRedo.ico' 6784 65541 nil nil nil 5346 1 4994 #clearChangeHistory 8 'Clear Change &History' 1 1 6690 nil true 6722 8 'MethodHistoryErase.ico' 6784 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 51381 nil nil 5298 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 51383 nil nil 5298 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 51385 nil nil 5298 nil true 50 15 5346 1 4994 #helpContents 8 '&Contents' 1025 1 6690 nil true 6722 8 'Help.ico' 6784 65541 nil nil nil 5346 1 4994 #help 8 'On this &Tool' 1249 1 nil nil nil 5346 1 4994 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5458 4097 5346 1 4994 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7282 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 5458 4097 5346 1 4994 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5346 1 4994 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5346 1 4994 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5458 4097 5346 1 4994 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 6690 nil true 6722 8 '!!APPLICATION' 6784 65541 nil nil nil 5346 1 4994 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5346 1 4994 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5458 4097 5346 1 4994 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7282 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 51409 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 402 50 2 450 #createAt:extent: 50 2 498 6143 21 498 1811 871 32 450 #text: 50 1 8 'Method Explorer' 32 546 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 136 15 0 0 189 1 0 0] 50 3 160 2960 2000 608 nil 27)! !
!Tools.MethodExplorerShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
defaultDefaultSlideyPinsMap!constants!options!private! !
displayOn:!displaying!public! !
historyListSize!accessing!public! !
historyListSize:!accessing!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

