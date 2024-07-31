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

buildHistoryFutureMenu: aMenu
	"Private - Answer a dynamically created future visit menu."

	super buildHistoryFutureMenu: aMenu.
	self buildHistoryMenu: aMenu visits: historyList upToEnd command: #historyForward:!

buildHistoryMenu: aMenu visits: aSequenceableCollection command: cmdSelector
	"Private - Answer a dynamically created past visit history menu."

	| lastEnv subMenu methods |
	lastEnv := nil.
	aSequenceableCollection keysAndValuesDo: 
			[:i :each |
			| env method |
			env := each key.
			env == lastEnv
				ifFalse: 
					[methods := Set new.
					subMenu := aMenu addSubmenu: env displayString.
					lastEnv := env].
			method := each value ?? '(none)'.
			"We only want to add each method to the menu once"
			(methods includes: method)
				ifFalse: 
					[subMenu addCommand: (Message selector: cmdSelector argument: i) description: method displayString.
					methods add: method].
			subMenu setDefault: 1].
	aMenu setDefault: 1!

buildHistoryPastMenu: aMenu
	"Private - Answer a dynamically created past visit history menu."

	super buildHistoryPastMenu: aMenu.
	self
		buildHistoryMenu: aMenu
		visits: historyList past
		command: #historyBack:!

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
buildHistoryFutureMenu:!commands-menus!private! !
buildHistoryMenu:visits:command:!commands-menus!private! !
buildHistoryPastMenu:!commands-menus!private! !
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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 12 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Edit_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[11 2 0 0 0 0 0 0 134 2 0 0 25 0 0 0] 193 336 8 '' 304 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'editTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 370 #{UI.Toolbar} #resource_Find_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[134 2 0 0 0 0 0 0 188 2 0 0 25 0 0 0] 193 688 8 '' 656 3 592 610 193 193 nil 27 8 'findTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 370 #{UI.Toolbar} #resource_History_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[188 2 0 0 0 0 0 0 16 3 0 0 25 0 0 0] 193 928 8 '' 896 3 592 610 193 193 nil 27 8 'historyTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1136 nil nil nil 5 nil nil nil 1136 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1168 8 '' 1136 3 592 610 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1376 nil nil nil 5 nil nil nil 1376 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1408 8 '' 1376 3 592 610 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1616 nil nil nil 5 nil nil nil 1616 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1648 8 '' 1616 3 592 610 193 193 nil 27 8 'smalltalkTools' nil nil nil nil 550 #{Core.OrderedCollection} 0 nil nil 9 1569 #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 121 3 0 0 25 0 0 0] 193 192 8 '' 160 3 50 6 1136 1616 1376 304 656 896 610 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140853004 1 2080 nil nil nil 5 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 2080 nil nil 258 #{Core.IdentityDictionary} 50 6 1862 1 #{UI.StatusBarItem} 8193 -1 2080 nil 518 #{Core.Message} #displayString 8 #() 2290 #iconImageIndex 2320 nil 8 'errors' 2258 8193 45 2080 nil nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 6 1 2384 8 'doIt' 8 '[:modified | modified ifTrue: [SmalltalkSystem current changedIcon imageIndex]]' 8 #[34 105 17 122 45 159 160 161 106 60 106] 1094 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #current #changedIcon #imageIndex #ifTrue: 2400 7 257 nil 2386 0 nil 2418 3 1 2384 8 'doIt' 8 '[:modified | modified ifTrue: [''Unsaved edits'']]' 8 #[30 105 17 119 29 106 60 106] 8 'Unsaved edits' 2528 #ifTrue: 7 257 nil 8 'modified' 2258 8705 351 2080 nil 2290 #displayString 8 #() 2290 #iconImageIndex 8 #() 2386 0 nil 2418 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:namespace | ''Method namespace: '', namespace fullName]' 8 #[32 105 29 226 1 178 106] 8 'Method namespace: ' #fullName #, 2720 7 257 nil 8 'namespace' nil nil nil 50 3 2368 2272 2640 1094 1 #{UI.StatusBarNullItem} 8705 1 2080 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 100 1 0 0 121 3 0 0 120 1 0 0] 193 2112 8 '' 2080 3 8 #() 610 193 193 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 3040 nil nil nil 5 nil nil nil 3040 130 1 1 nil nil nil nil 18 #{UI.ContainerView} 50 15 nil 3040 50 2 8 1409286144 131073 3120 nil nil nil 5 nil nil nil 3120 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 258 #{Core.IdentityDictionary} 50 2 18 #{UI.ReferenceView} 50 14 nil 3120 50 2 8 1140916224 131073 3280 nil nil nil 5 nil nil nil 3280 370 #{Tools.MethodWorkspace} #resource_Default_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 168 0 0 0 121 3 0 0 75 1 0 0] 193 3312 8 '' 3280 3 592 610 193 193 nil 27 8 'source' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 121 3 0 0 75 1 0 0] 193 3152 8 '' 3120 3 50 3 18 #{UI.ContainerView} 50 15 nil 3120 50 2 8 1140850688 131073 3664 nil nil nil 5 nil nil nil 3664 3186 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 1 518 #{Core.Association} 18 #{UI.Splitter} 50 12 nil 3664 50 2 8 1140850688 1 3824 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 3824 nil 1 #left nil nil nil 610 1 1 610 9 9 nil 3920 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[186 1 0 0 0 0 0 0 191 1 0 0 163 0 0 0] 193 3856 8 '' 3824 3 8 #() 610 193 193 nil 27 1 false 258 #{Core.IdentityDictionary} 50 4 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 3664 50 2 8 1409286144 131073 4144 nil nil nil 517 nil nil nil 4144 1350 1 #{UI.CardLayout} 1858 1 3794 8 'History' 18 #{UI.TreeView} 50 35 nil 18 #{UI.SlidingCardTray} 50 22 nil 4144 50 2 8 1140850688 131073 4320 nil nil nil 5 nil nil nil 4320 4224 258 #{Core.IdentityDictionary} 50 2 4288 8 'historyTree' nil 18 #{UI.TabViewXP} 50 28 nil 4144 50 2 8 1140851328 1 4432 838 2 #{UI.ListModel} 1858 1 4272 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 4432 nil nil 2304 2336 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #noIcons nil nil nil nil nil 402 50 3 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 193 4464 8 '' 4432 450 #setSingleSelection: 8 #(1) 4432 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4432 3 8 #() 610 193 193 nil 27 nil 4144 610 33 33 1606 1 #{UI.ButtonInteractor} 4320 nil 1 518 #{Graphics.Rectangle} 610 787 3 610 819 35 nil 1350 4 #{UI.CommandDescription} #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[27 0 0 0 4 0 0 0 182 1 0 0 159 0 0 0] 193 4352 8 '' 4320 3 50 1 4288 610 193 193 nil 27 50 2 8 1140916775 1025 4288 1094 3 #{UI.TreeModel} nil 4560 774 #{UI.TreeNode} nil nil nil 550 #{Core.IdentityDictionary} 0 240 nil 5 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 4946 #browseMessageDefinitions 8 '&Definitions of…' 1 1 nil nil nil 5330 1 4946 #browseMessageReferences 8 '&References to…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 5330 1 4946 #clearSelection 8 'Re&move' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4288 nil nil 2290 #displayString 8 #() 2336 4592 nil nil nil nil nil 3218 0 nil #noIcons 1 5250 0 1 262 #{UI.TreeViewDynamicUpdateMode} 4288 nil nil nil nil nil nil 402 50 2 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 155 1 0 0 155 0 0 0] 193 5152 8 '' 4288 450 #contextMenu: 50 1 5296 4288 3 8 #() 610 193 193 nil 29 4288 nil nil nil 5250 0 nil 4432 4320 610 201 201 401 1 31 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 186 1 0 0 163 0 0 0] 193 4176 8 '' 4144 3 50 2 4320 4432 610 193 193 nil 27 8 'historySlidey' 18 #{UI.ReferenceView} 50 14 nil 3664 50 2 8 1140850688 131073 6032 nil nil nil 5 nil nil nil 6032 370 #{Tools.MethodBrowser} #resource_Method_browser_method_list nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[191 1 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 193 6064 8 '' 6032 3 592 610 193 193 nil 27 8 'methodlist' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 121 3 0 0 163 0 0 0] 193 3696 8 '' 3664 3 50 3 4144 3824 6032 610 193 193 nil 27 18 #{UI.Splitter} 50 12 nil 3120 50 2 8 1140850688 1 6432 nil nil nil 517 nil nil nil 3890 6432 nil 1 #left nil nil nil 3920 3936 nil 3920 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 163 0 0 0 121 3 0 0 168 0 0 0] 193 6464 8 '' 6432 3 8 #() 610 193 193 nil 27 3280 610 193 193 nil 27 258 5248 50 2 3120 8 'browser' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 25 0 0 0 121 3 0 0 100 1 0 0] 193 3072 8 '' 3040 3 50 1 3120 610 193 193 nil 27 258 5248 50 4 2080 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 8 5282 nil true 50 8 5330 1 4946 #fileNew 8 '&New Workspace' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'NewWorkspace.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 5330 1 4946 #fileOpen 8 '&Open Workspace…' 9375 1 7090 nil true 7122 8 'OpenWorkspace.ico' 7184 65541 nil nil nil 5330 1 4946 #fileFileIn 8 '&File In…' 1 1 7090 nil true 7122 8 'FileIn.ico' 7184 65541 nil nil nil 5442 4097 5330 1 4946 #saveImage 8 'Sa&ve Image' 1 1 7090 nil true 7122 8 'Snapshot.ico' 7184 65541 nil nil nil 5330 1 4946 #smalltalkExit 8 'E&xit Dolphin' 1 1 7090 nil true 7122 8 'PowerSwitch.ico' 7184 65541 nil nil nil 5442 4097 5330 1 4946 #exit 8 '&Close' 17639 1 2374 2 #{Graphics.TextTileIcon} 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 5282 nil true 50 13 5330 1 4946 #undo 8 '&Undo' 9397 1 7090 nil true 7122 8 'EditUndo.ico' 7184 65541 nil nil nil 5442 4097 5330 1 4946 #cutSelection 8 'Cu&t' 9393 1 7090 nil true 7122 8 'EditCut.ico' 7184 65541 nil nil nil 5330 1 4946 #copySelection 8 '&Copy' 9351 1 7090 nil true 7122 8 'EditCopy.ico' 7184 65541 nil nil nil 5330 1 4946 #pasteClipboard 8 '&Paste' 9389 1 7090 nil true 7122 8 'EditPaste.ico' 7184 65541 nil nil nil 5330 1 4946 #editDelete 8 '&Delete' 1 1 7090 nil true 7122 8 'EditClear.ico' 7184 65541 nil nil nil 5282 nil true 50 2 5330 1 4946 #reformatSource 8 '&Source' 9391 1 nil nil nil 5330 1 4946 #reformatComment 8 '&Comment' 9367 1 nil nil nil 8 'Ref&ormat' nil 134217729 nil nil nil nil nil 5442 4097 5330 1 4946 #selectAll 8 'Select &All' 9347 1 nil nil nil 5442 4097 5330 1 4946 #editFind 8 '&Find…' 9357 1 7090 nil true 1030 #{Graphics.ImageFromResourceInitializer} 47 262 #{OS.ShellLibrary} 65541 nil nil nil 5330 1 4946 #findNext 8 'Find &Next' 1253 1 7090 nil true 7122 8 'FindNext.ico' 7184 65541 nil nil nil 5330 1 4946 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 5282 nil true 50 17 5330 1 4946 #browseIt 8 '&Browse It' 9349 1 7090 nil true 7122 8 'ClassBrowserShell.ico' 7184 65541 nil nil nil 5330 1 4946 #displayIt 8 '&Display It' 9353 1 7090 nil true 7122 8 'DisplayIt.ico' 7184 65541 nil nil nil 5330 1 4946 #printIt 8 '&Print It' 9377 1 7090 nil true 7122 8 'PrintIt.ico' 7184 65541 nil nil nil 5330 1 4946 #evaluateIt 8 '&Evaluate It' 9355 1 7090 nil true 7122 8 'EvaluateIt.ico' 7184 65541 nil nil nil 5330 1 4946 #inspectIt 8 '&Inspect It' 9363 1 7090 nil true 7122 8 'InspectIt.ico' 7184 65541 nil nil nil 5330 1 4946 #debugIt 8 'Deb&ug It' 1269 1 7090 nil true 7122 8 'Debugger.ico' 7184 65541 nil nil nil 5330 1 4946 #fileItIn 8 'Fi&le It In' 1 1 nil nil nil 5442 4097 5330 1 4946 #browseDefinitions 8 'Defi&nitions' 1271 1 nil nil nil 5330 1 4946 #browseReferences 8 'Re&ferences' 5367 1 nil nil nil 5442 4097 5330 2097153 4946 #accept 8 '&Accept' 9383 1 nil nil nil 5330 1 4946 #reformatAccept 8 'Refor&mat/Accept' 13479 1 nil nil nil 5442 4097 5282 nil true 50 14 5330 1 4946 #renameVariable 8 'Re&name <d:Variable>…' 1 17 nil nil nil 5442 4097 5330 1 4946 #extractToTemporary 8 'Extract to &Temporary…' 9385 1 nil nil nil 5330 1 4946 #extractMethod 8 'E&xtract Method…' 9371 1 nil nil nil 5330 1 4946 #extractToComponent 8 'Extract to &Component…' 1 1 nil nil nil 5330 1 4946 #inlineMessage 8 'Inline &Message' 13467 1 nil nil nil 5442 4097 5330 1 4946 #inlineTemporary 8 '&Inline Temporary' 13481 1 nil nil nil 5330 1 4946 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 nil nil nil 5330 1 4946 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 5442 4097 5330 1 4946 #addParameterToMessage 8 '&Add Parameter to <d:Message>…' 1 17 nil nil nil 5330 1 4946 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 5330 1 4946 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 134217729 7090 nil true 7122 8 'Refactoring.ico' 7184 65541 nil nil nil nil nil 5442 4097 5282 nil true 50 7 5330 1 4946 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5330 1 4946 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5330 1 4946 #toggleLineEndings 8 'Line &Endings' 1 1 7682 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 5330 1 4946 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5330 1 4946 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5330 1 4946 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5330 1 4946 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 7090 nil true 7122 8 'Preferences.ico' 7184 65541 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 5282 nil true 50 11 5282 nil true 8 #() 8 '&Definitions of' #definitionsMenu 1 nil nil nil nil nil 5282 nil true 8 #() 8 'Re&ferences to' #referencesMenu 1 nil nil nil nil nil 5282 nil true 50 11 5330 1 4946 #browseReferencesToGlobal 8 'References to Global…' 1 1 nil nil nil 5330 1 4946 #browseContainingText 8 'C&ontaining Text…' 1 1 7090 nil true 7122 8 'SearchText.ico' 7184 65541 nil nil nil 5330 1 4946 #browseMethodCategory 8 'Cate&gory…' 1 1 7090 nil true 7122 8 'Category.ico' 7184 65541 nil nil nil 5330 1 4946 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 5330 1 4946 #browseCompilationIssues 8 'Compilation Iss&ues' 1 1 nil nil nil 5442 4097 5330 1 4946 #browseMethodPackages 8 'Package <s>' 1 17 7090 nil true 7122 8 'Package.ico' 7184 65541 nil nil nil 5330 1 4946 #browseMethodClasses 8 'Class <s>' 1 17 nil nil nil 5442 4097 5330 1 4946 #browseMethodHistory 8 '&Change History' 1 1 7090 nil true 7122 8 'MethodHistory.ico' 7184 65541 nil nil nil 5330 1 4946 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil nil nil nil 5442 4097 5330 1 4946 #removeMethod 8 'Re&move' 1 1 7090 nil true 7122 8 'MethodDelete.ico' 7184 65541 nil nil nil 5282 nil true 50 16 5330 1 4946 #renameMethod 8 'Re&name' 1 1 nil nil nil 5330 1 4946 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 5442 4097 5330 1 4946 #addParameter 8 'Add &Parameter…' 1 1 nil nil nil 5282 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 5282 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil nil nil nil 5282 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil nil nil nil 5442 4097 5282 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil nil nil nil 5282 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil nil nil nil 5442 4097 5330 1 4946 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 5330 1 4946 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 5330 1 4946 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 5330 1 4946 #overrideMethods 8 'Ove&rride <d:Methods>' 1 17 nil nil nil 5330 1 4946 #moveMethod 8 'Move to &Component…' 1 1 nil nil nil 8 '&Refactorings' #methodRefactoringsMenu 134217729 7090 nil true 7122 8 'Refactoring.ico' 7184 65541 nil nil nil nil nil 5442 4097 5330 1 4946 #methodPackage 8 '&Package…' 1 1 7090 nil true 7122 8 'Package.ico' 7184 65541 nil nil nil 5282 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil nil nil nil 5282 nil true 8 #() 8 'Remo&ve from Category' #removeCategoryMenu 134217729 nil nil nil nil nil 5330 1 4946 #togglePrivate 8 'Priva&te' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil nil nil nil 5282 nil true 50 3 5330 1 4946 #undoChange 8 '&Undo <d:…>' 1 17 7090 nil true 7122 8 'EditUndo.ico' 7184 65541 nil nil nil 5330 1 4946 #redoChange 8 '&Redo <d:…>' 1 17 7090 nil true 7122 8 'EditRedo.ico' 7184 65541 nil nil nil 5330 1 4946 #clearChangeHistory 8 'Clear Change &History' 1 1 7090 nil true 7122 8 'MethodHistoryErase.ico' 7184 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil nil nil nil 5282 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 5282 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 5282 nil true 50 15 5330 1 4946 #helpContents 8 '&Contents' 1025 1 7090 nil true 7122 8 'Help.ico' 7184 65541 nil nil nil 5330 1 4946 #help 8 'On this &Tool' 1249 1 nil nil nil 5330 1 4946 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5442 4097 5330 1 4946 #learnSmalltalk 8 'Learn Smalltalk' 1 1 7682 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 5442 4097 5330 1 4946 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5330 1 4946 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5330 1 4946 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5442 4097 5330 1 4946 #dolphinHomePage 8 'Dolphin Homepage' 1 1 7090 nil true 7122 8 '!!APPLICATION' 7184 65541 nil nil nil 5330 1 4946 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5330 1 4946 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5442 4097 5330 1 4946 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 7682 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 402 50 1 450 #createWindow: 50 1 498 4882 610 7679 21 610 9489 891 193 80 8 'Method Explorer' 32 1 50 3 160 3040 2080 610 193 193 nil 27)! !

!Tools.MethodExplorerShell class categoriesForMethods!
browseMethodsInEnvironments:!instance creation!public! !
defaultDefaultSlideyPinsMap!constants!options!private! !
displayOn:!displaying!public! !
historyListSize!accessing!public! !
historyListSize:!accessing!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

