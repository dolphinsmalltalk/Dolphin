"Filed out from Dolphin Smalltalk X6.1"!

ListPresenter subclass: #MethodBrowser
	instanceVariableNames: 'methodsPresenter sourcePresenter filter searchEnvironment refactoringTool versionModel'
	classVariableNames: 'AdditionalAccelerators AutoFormat InfoTips WordWrap'
	poolDictionaries: 'CompilerFlags'
	classInstanceVariableNames: 'commandQueryHandlers'!
MethodBrowser guid: (GUID fromString: '{87B4C68D-026E-11D3-9FD7-00A0CC3E4A32}')!
MethodBrowser comment: 'MethodBrowser is a <compositePresenter> used to display a <collection> of <CompiledMethod>s. The browser can be instantiated and then filled with methods using #methods: aspect, the value of which must be a <BrowserEnvironment>. The methods defined in the environment are enumerated and displayed in the browser list.

Example:
	MethodBrowser show methods: BrowserEnvironment new.

Note that it is also possible to specify a <monadicValuable> filter that can be used to affect the subsequent maintenance of the browsers content. All methods in the original list are displayed. This is useful for when the browser is required to present a list of methods meeting a specific criteria. If any of these methods are recompiled (possibly in another browser) the filter is applied once more to see whether the browser should continue to display the method in its list.

Instance Variables:
	methodsPresenter		<ListPresenter> holding the methods being displayed.
	sourcePresenter		<MethodWorkspace> for displaying the source of the selected method.
	filter					<monadicValuable> to determine which methods are included in the list.
	searchEnvironment		<BrowserEnvironment> constraining any definition/reference searches performed in the browser
	refactoringTool			<MethodRefactoringTool>

Class Variables:
	AdditionalAccelerators	<Array> of <Array> of <Symbol>, <String> pairs.
	WordWrap			<boolean> indicating whether the source pane should wrap its text.
	AutoFormat			<boolean> indicating whether source is pretty printed when displayed.
	InfoTips				<boolean> indicating whether method info tips (showing category information) should be displayed. If nil then configured by view.

'!
!MethodBrowser categoriesForClass!Development!MVP-Presenters!MVP-Resources-IDE Tools! !
!MethodBrowser methodsFor!

addMethods: aCollectionOfMethods toCategory: aMethodCategory 
	aMethodCategory addMethods: aCollectionOfMethods.
	aCollectionOfMethods do: [:each | each storeCategories]!

addToCommandRoute: route 
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer the next <Presenter> to visit. The receiver is
	guaranteed not to be on the command path already."

	"Implementation Note: We add our method refactoring tool to the command route, and also the
	workspace to pick up any menu bar commands intended for it."

	| next |
	refactoringTool notNil ifTrue: [route appendTarget: refactoringTool].
	next := super addToCommandRoute: route.
	sourcePresenter addToCommandRoute: route.
	^next!

applyOptions
	"Apply the class options to the receiver"

	| methodList |
	sourcePresenter view wordWrap: self class wordWrap.
	self class hasInfoTips 
		ifNotNil: 
			[:hasTips | 
			methodList := methodsPresenter view.
			(methodList respondsTo: #hasInfoTips:) ifTrue: [methodList hasInfoTips: hasTips]]!

browseCompilationFailures
	(self systemModel methodsThatFailedToCompileIn: self searchEnvironment) 
		ifNotNil: [:failed | self browseMethodsIn: failed]!

browseCompilationIssues
	(self systemModel methodsWithCompilationIssuesIn: self searchEnvironment) 
		ifNotNil: [:failed | self browseMethodsIn: failed]!

browseContainingText
	"Prompt for a string and browse the methods containing that string."

	(self systemModel 
		methodsContainingText: ''
		in: self searchEnvironment
		prompt: true) ifNotNil: [:env | self browseMethodsIn: env]!

browseDefinitions
	"Browse method definitions with the same selector as the currently selected method."

	self browseDefinitionsMatching: (MethodSearch newSelector: self selectedMethod selector)
		in: self searchEnvironment!

browseDefinitionsMatching: aMethodSearch in: aBrowserEnvironment 
	| definitions |
	definitions := OrderedCollection 
				with: (self systemModel definitionsMatching: aMethodSearch in: aBrowserEnvironment).
	parentPresenter parseContext 
		ifNotNil: 
			[:class | 
			definitions add: (self systemModel definitionsMatching: aMethodSearch
						in: (aBrowserEnvironment forClassHierarchyOf: class))].
	self routeCommand: (CommandDescription 
				command: (Message selector: #browseMethodsInEnvironments: argument: definitions))!

browseDefinitionsOfSelector: aSymbol in: aBrowserEnvironment 
	"Private - Opens a MethodBrowser on all the methods whose selectors match the specified
	<readableString> pattern in the scope of the specified <BrowserEnvironment>."

	self browseDefinitionsMatching: (MethodSearch newSelector: aSymbol) in: aBrowserEnvironment!

browseGlobalReferences: anAssociation in: aBrowserEnvironment 
	"Private - Opens a new Method Browser on all the methods which refer to the global binding represented
	by the <Association> argument. Also includes methods that refer directly to the current
	value of the global binding."

	self 
		browseMethodsIn: (self systemModel referencesToVariable: anAssociation in: aBrowserEnvironment)!

browseHierarchy
	"Open a class hierarchy browser on the current method"

	self systemModel browseClassHierarchyOfMethod: self selection!

browseIt
	"Open a default browser on the current method(s)"

	^self perform: self browseItCommand!

browseItCommand
	"Private - Open a class browser on the selected method(s) class(es)."

	^#browseMethodClasses!

browseMessage
	"Prompt for a selector and open a method browser displaying the implementors and senders of
	that selector."

	self browseMessagesIn: self searchEnvironment!

browseMessageDefinitions
	"Prompt for a selector and open a method browser displaying the implementors of that
	selector."

	self browseMessageDefinitions: '' in: self searchEnvironment!

browseMessageDefinitions: aString in: aBrowserEnvironment 
	"Private - Prompt for a selector and open a method explorer displaying the implementors of
	that selector, both globally and in the local hierarchy."

	(self systemModel promptForSelector: aString caption: 'Definitions of ...') 
		ifNotNil: [:search | Cursor wait showWhile: [self browseDefinitionsMatching: search in: self searchEnvironment]]!

browseMessageReferences
	"Prompt for a selector and open a method browser displaying the references to that
	selector, using the the first word of the clipboard text as the initial suggestion."

	self browseMessageReferences: '' in: self searchEnvironment!

browseMessageReferences: aString in: aBrowserEnvironment 
	"Private - Prompt for a selector and open a method explorer displaying the references to that
	selector, using the <readableString> argument as the initial suggestion (or if that is empty
	the first word of the clipboard text)."

	(self systemModel promptForSelector: aString caption: 'References to...') 
		ifNotNil: [:search | Cursor wait showWhile: [self browseReferencesMatching: search in: aBrowserEnvironment]]!

browseMessagesIn: aBrowserEnvironment 
	"Private - Prompt for a selector and open a method browser displaying the references to that
	selector, using the <readableString> argument as the initial suggestion (or if that is empty
	the first word of the clipboard text)."

	(self systemModel promptForSelector: '' caption: 'Browse Messages Matching...') 
		ifNotNil: [:search | Cursor wait showWhile: [self browseMessagesMatching: search in: aBrowserEnvironment]]!

browseMessagesMatching: aMethodSearch in: aBrowserEnvironment 
	| searches |
	searches := OrderedCollection 
				with: (self systemModel definitionsMatching: aMethodSearch in: aBrowserEnvironment)
				with: (self systemModel referencesMatching: aMethodSearch in: aBrowserEnvironment).
	parentPresenter parseContext 
		ifNotNil: 
			[:class | 
			| hierarchy |
			hierarchy := aBrowserEnvironment forClassHierarchyOf: class.
			searches
				add: (self systemModel definitionsMatching: aMethodSearch in: hierarchy);
				add: (self systemModel referencesMatching: aMethodSearch in: hierarchy)].
	self routeCommand: (CommandDescription 
				command: (Message selector: #browseMethodsInEnvironments: argument: searches))!

browseMethodClasses
	"Open a class browser on the selected method(s) class(es)."

	"Implementation Note: If a single method is selected, then a default class browser is opened
	with that method selected, otherwise if methods of a single class are selected then a
	default class browser is opened on that class, otherwise an Environment Browser is opened on
	the methods' classes."

	| selections |
	selections := self selections.
	^selections size = 1 
		ifTrue: [selections anyOne browse]
		ifFalse: 
			[| classes |
			classes := (selections collect: [:each | each methodClass]) asSet.
			classes size = 1 
				ifTrue: [classes anyOne browse]
				ifFalse: [(BrowserEnvironment new forClasses: classes) openEditor]]!

browseMethodInheritanceChain
	"Open a method browser displaying the definitions of the 
	current selector in the superclass chain."

	self systemModel browseMethodHierarchyFrom: self selection!

browseMethodPackages
	"Open a package browser on the current methods' owning packages."

	self systemModel browsePackages: (self selections collect: [:each | each owningPackage]) asSet.!

browseMethodsIn: aBrowserEnvironment 
	parentPresenter browseMethodsIn: aBrowserEnvironment!

browseMethodsMatching: aMethodSearch in: aBrowserEnvironment 
	self browseMethodsIn: (self systemModel referencesMatching: aMethodSearch in: aBrowserEnvironment)!

browsePackages
	"Implement the context-sensitive browse packages command by browsing the package
	of the selected method."

	self browseMethodPackages.!

browseReferences
	"Context-sensitive 'Browse References' command. In this case browse refs. to the 
	current selector."

	self browseReferencesMatching: (MethodSearch newSelector: self selection selector)
		in: self searchEnvironment!

browseReferencesMatching: aMethodSearch in: aBrowserEnvironment 
	| references |
	references := OrderedCollection 
				with: (self systemModel referencesMatching: aMethodSearch in: aBrowserEnvironment).
	parentPresenter parseContext 
		ifNotNil: 
			[:class | 
			references add: (self systemModel referencesMatching: aMethodSearch
						in: (aBrowserEnvironment forClassHierarchyOf: class))].
	self routeCommand: (CommandDescription 
				command: (Message selector: #browseMethodsInEnvironments: argument: references))!

browseReferencesToGlobal
	"Prompt for a global name and open a method browser displaying the
	references to that global."

	(self systemModel promptForReferencesToGlobal: self selectedWord in: self searchEnvironment) 
		ifNotNil: [:env | self browseMethodsIn: env]!

browseReferencesToLiteral: anObject in: aBrowserEnvironment 
	"Private - Opens a MethodBrowser on all the methods that refer to aString from their literal frames
	(aString is normally a symbolic selector), within the scope of the specified
	<BrowserEnvironment>."

	self browseReferencesMatching: (MethodSearch newLiteral: anObject) in: aBrowserEnvironment!

browserEnvironment
	^searchEnvironment!

browseSystem
	"Open a system browser on the current method"

	self systemModel browseSystemOnMethod: self selection!

buildAddCategoryMenu: aMenu 
	"Private - Build a dynamic pull-out menu to hold suggested categories and an 'Other...' 
	command to bring up the traditional prompter."

	"First clear away any previously set-up category addition commands"

	| methods suggestions |
	aMenu clear.
	methods := self selections.
	methods isEmpty ifTrue: [^self].
	suggestions := #().
	methods 
		do: [:each | suggestions := suggestions union: (self methodCategorizationPolicy suggestionsFor: each)].
	suggestions notEmpty 
		ifTrue: 
			[| suggested |
			suggested := IdentitySet new.
			suggestions do: 
					[:cat | 
					(suggested includes: cat) 
						ifFalse: 
							[| msg desc |
							suggested add: cat.
							msg := MessageSend 
										receiver: self
										selector: #addMethods:toCategory:
										arguments: (Array with: methods with: cat).
							desc := cat name.
							(desc identityIncludes: $&) ifTrue: [desc := desc copyReplaceAll: '&' with: '&&'].
							aMenu addCommand: msg description: desc]]].
	aMenu addSeparator.
	aMenu addCommand: #categorizeMethods description: 'Other...'.
	aMenu setDefault: aMenu items size!

buildParseTree
	^self selectionOrNil 
		ifNotNil: [:method | SmalltalkParser parseExistingMethodNoError: method]!

buildRemoveCategoryMenu: aMenu 
	| methods categories filterCats |
	aMenu clear.
	methods := self selections.
	filterCats := [:each | each categories reject: [:cat | cat isVirtual]].
	categories := (methods copyFrom: 2) inject: (filterCats value: methods first)
				into: [:cats :each | cats intersection: (filterCats value: each)].
	categories asSortedCollection do: 
			[:each | 
			| msg desc |
			msg := MessageSend 
						receiver: each
						selector: #removeMethods:
						argument: methods.
			desc := each name.
			(desc identityIncludes: $&) ifTrue: [desc := desc copyReplaceAll: '&' with: '&&'].
			aMenu addCommand: msg description: desc]!

canSaveMethod
	^parentPresenter canSaveMethod!

categorizeMethods
	"Invokes a dialog to categorize the currently selected methods."

	| methods originalCategory chosenCategory categories captionPostscript |
	methods := self selections.
	methods size == 1 
		ifTrue: 
			[| method |
			method := methods first.
			originalCategory := method categories asSortedCollection first.
			captionPostscript := method selector printString]
		ifFalse: 
			[originalCategory := nil.
			captionPostscript := 'methods'].
	categories := MethodCategory allMethodCategories.
	chosenCategory := (CategoryPrompter 
				on: originalCategory
				choices: categories
				caption: 'Categorize ' , captionPostscript) showModal.
	(chosenCategory notNil and: [chosenCategory ~= originalCategory]) ifFalse: [^self].
	self addMethods: methods toCategory: chosenCategory!

clearErrors
	^sourcePresenter clearErrors!

clearSelection
	"Removes the selected method from the system"

	self perform: self deleteItCommand!

commandPolicy
	^methodsPresenter commandPolicy!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	methodsPresenter := self 
				add: (ListPresenter on: (ListModel newWithSearchPolicy: CompiledMethodSearchPolicy current))
				name: 'methods'
				helpId: 10742.
	sourcePresenter := self 
				add: self systemModel methodWorkspaceClass new yourself
				name: 'source'
				helpId: 10490.
	refactoringTool := self systemModel newMethodRefactoringToolFor: self!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self selectableItems)
		when: #actionPerformed
			send: #browseIt
			to: self;
		when: #selectionChanged
			send: #onMethodSelected
			to: self;
		when: #selectionChanging:
			send: #onMethodSelectionChanging:
			to: self;
		when: #drag:
			send: #onDrag:
			to: self;
		when: #dragCut:
			send: #onDragCut:
			to: self;
		when: #dragOver:
			send: #onDragOver:
			to: self;
		when: #drop:
			send: #onDropOver:
			to: self.
	(self systemModel)
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodUpdated:
			send: #onMethodUpdated:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self;
		when: #methodCategorized:
			send: #onMethodCategorized:
			to: self!

deleteItCommand
	methodsPresenter hasFocus ifTrue: [^#removeMethod].
	^nil!

enableSource: aBoolean 
	"Private - Enable the source pane of the receiver according to aBoolean."

	sourcePresenter isReadOnly: aBoolean not!

ensureSourceVisible
	"Ensure that the source pane is visible in the receiver"

	sourcePresenter ensureVisible!

errorModel
	"Answer the errorModel used to collect notifications from the Compiler."

	^sourcePresenter errorModel!

errorModel: aValueModel
	"Set the errorModel used to collect notifications from the Compiler."

	sourcePresenter errorModel: aValueModel!

evaluationContext
	^sourcePresenter evaluationContext!

filter
	"Answers the oneArgBlock that sppecifies a filter that determines how methods 
	are selected for display within the receiver. The filter must include any 
	criteria that are implicitly present in the methodsList."

	^filter!

filter: aOneArgBlock
	"Sets the filter that determines how methods are selected for display
	within the receiver. The filter must include any criteria that are
	implicitly present in the original methodsList."

	filter := aOneArgBlock.
!

findDetails: aFindDetails 
	sourcePresenter findDetails: aFindDetails!

findNextMatch
	"Hilight the next occurrence of the sourcePresenter's findString in its
	current source."

	sourcePresenter view basicFindNext!

findSelector: aSelector 
	"Set the String to search for in the receivers source to be one that describes aSelector"

	aSelector isNil ifTrue: [^self].
	sourcePresenter findDetails: (MethodSearch newSelector: aSelector) findDetails!

hasEditableMethodSelected
	"Answer true if a single method is selected and it is editable."

	^self selectedMethod ifNil: [false] ifNotNil: [:method | self isEditableMethod: method]!

hasEditableMethodsSelected
	^parentPresenter hasEditableMethodsSelected!

hasMethods
	^self model notEmpty!

hasMethodSelected
	"Answer true if the receiver currently has a method selected
	in the methodsPresenter"

	^self hasSingleSelection!

hasMethodsSelected
	"Answer true if the receiver currently has a method selected
	in the methodsPresenter"

	^self hasSelection!

initialize
	"Private - Initialize the receiver"

	super initialize.
	"Initially the filter excludes all methods, this fixes the bug where a class browser
	without selection was picking up all methods added/modified."
	filter := [:aCompiledMethod | aCompiledMethod isNil].
	searchEnvironment := self systemModel systemEnvironment.
	versionModel := ValueHolder new.!

inspectIt
	"Open an inspector on the currently selected method."

	| methods |
	methods := self selections.
	(methods size = 1 ifTrue: [methods first] ifFalse: [methods]) inspect!

isEditableMethod: aCompiledMethod 
	^parentPresenter isEditableMethod: aCompiledMethod!

isModified
	^sourcePresenter isModified!

isSourceReadOnly
	^sourcePresenter isReadOnly!

list: aSequenceableCollection 
	"MethodBrowser attempts to maintain selection when the list is changed. Perhaps all <listPresenter>s should do this, or at least as an option."

	| selections |
	(aSequenceableCollection isEmpty ifTrue: [self noMethodsView] ifFalse: [methodsPresenter view]) 
		ensureVisible.
	selections := self selections.
	self noEventsDo: 
			[super list: aSequenceableCollection.
			self selections: selections ifAbsent: []].
	self selections = selections ifFalse: [self trigger: #selectionChanged]!

method
	Notification deprecated.
	^self selectedMethod!

method: aCompiledMethodOrNil 
	Notification deprecated.
	self selectMethod: aCompiledMethodOrNil!

methodCategorizationPolicy
	"Private - Answer the <MethodCategorizationPolicy> used by the receiver."

	^self systemModel methodCategorizationPolicy!

methodPackage
	"Prompt for the user to repackage the selected method(s)."

	| methods oldPkg newPkg captionPostscript default |
	methods := self selections.
	methods size = 1 
		ifTrue: 
			[captionPostscript := methods first.
			oldPkg := methods first owningPackage.
			default := methods first methodClass owningPackage]
		ifFalse: 
			[| classes packages |
			packages := methods collect: [:each | each owningPackage].
			oldPkg := packages asSet size = 1 ifTrue: [oldPkg := packages first].
			classes := methods collect: [:each | each methodClass].
			default := classes size = 1 ifTrue: [classes first].
			captionPostscript := 'methods'].
	newPkg := PackagePrompter 
				showModalOn: oldPkg asValue
				caption: ('Package of <1d> ...' expandMacrosWith: captionPostscript)
				default: default
				validationBlock: [:package | package notNil and: [methods allSatisfy: [:each | each isUnbound not]]].
	"We allow OK even if no change from existing package, so must check for that here"
	(newPkg notNil and: [newPkg ~= oldPkg]) ifFalse: [^self].
	methods do: [:each | Package manager addMethod: each to: newPkg].
	self selectionsByIndex do: [:each | self model refreshAtIndex: each]!

methods: aBrowserEnvironment 
	Cursor wait showWhile: 
			[self
				list: aBrowserEnvironment allMethods;
				searchEnvironment: aBrowserEnvironment environment;
				filter: aBrowserEnvironment filter;
				findDetails: aBrowserEnvironment search findDetails]!

methodsPresenter
	^methodsPresenter!

model: aListModel
	"Set the receiver's model to aListModel of CompiledMethods"

	super model: aListModel.
	self selectableItems model: aListModel.
!

modifiedModel
	^sourcePresenter modifiedModel!

modifiedModel: aValueHolder
	sourcePresenter modifiedModel: aValueHolder!

newMethod
	"Sets the receiver up for creating a new method"

	"Are there outstanding changes?"

	self promptToSaveChanges ifFalse: [^self].
	self selectMethod: nil.
	"#833: If there was previously no method selection (i.e. no selection change event occurred when the selection
	was reset), then we will need to clear down the source presenter, so do that regardless"
	sourcePresenter
		text: String new;
		setFocus!

noMethodsView
	^view viewNamed: 'noMethodsText' ifNone: [methodsPresenter view]!

onAboutToDisplayMenu: aMenu 
	"The pop-up <Menu>, popup, is about to be displayed.
	This is our opportunity to update it, e.g. to add/remove items."

	| menuName |
	super onAboutToDisplayMenu: aMenu.
	menuName := aMenu name.
	menuName == #addCategoryMenu ifTrue: [^self buildAddCategoryMenu: aMenu].
	menuName == #removeCategoryMenu ifTrue: [^self buildRemoveCategoryMenu: aMenu].

	"Otherwise pass on to the dev. system model to populate message menus"
	self systemModel 
		populateMessagesMenus: aMenu
		fromMethods: self selections
		environment: self searchEnvironment!

onCloseRequested: boolValueHolder
	"A request to close the view onto the receiver as occurred.
	Prompt to save any outstanding changed"

	boolValueHolder value: self promptToSaveChanges!

onDrag: aDragDropSession 
	"A drag has been started. Drag the currently selected methods."

	self systemModel beginDrag: aDragDropSession methods: self selections!

onDragCut: aDragDropSession 
	"Private - A <DragDropSession> has just completed a successful move operation. The receiver is now
	responsible for deleting the dragged object from itself. Note that many targets will perform
	the cut operation themselves and suppress this (by resetting the drag/drop operation) in
	order to construct a single composite change."

	| methods |
	methods := OrderedCollection new.
	aDragDropSession dragObjects do: 
			[:each | 
			(each isFormatAvailable: #CompiledMethod) 
				ifTrue: 
					[| method |
					method := each format: #CompiledMethod.
					methods add: method]].
	self systemModel basicRemoveMethods: methods!

onDragOver: session
	"Private - A drag operation described by the <DragDropSession>, session, has 
	moved over the receiver's method list pane. Forward on notification to any observers
	that might be interested."

	self trigger: #dragOver: with: session!

onDropOver: session
	"Private - A drag operation described by the <DragDropSession>, session, has 
	dropped over the receiver's method list pane. Forward on notification to any observers
	that might be interested."

	self trigger: #drop: with: session!

onMethod: oldCompiledMethod updatedTo: newCompiledMethod 
	| wasSelected index |
	index := self model indexOf: oldCompiledMethod.
	index == 0 
		ifTrue: [wasSelected := false]
		ifFalse: 
			[wasSelected := self selectionsByIndex includes: index.
			self model remove: oldCompiledMethod].
	(self filter value: newCompiledMethod) 
		ifTrue: 
			[self model add: newCompiledMethod.
			"Reselect it if an old instance was previously selected BUT NOT if the source presenter
			 is preserving prevously changed text for this method."
			(wasSelected and: [sourcePresenter isModified not]) 
				ifTrue: [self selections: (self selections copyWith: newCompiledMethod) ifAbsent: []]].

	"There may be visible effects (override markers) that need to be updated even when
	the added method is from a different class. Force the method presenter to redraw
	in order to guarantee that these are kept consistent"
	self selectableItems view updateAll!

onMethodAdded: aCompilationResult 
	| method |
	self assert: [aCompilationResult isNew].
	method := aCompilationResult method.
	(self filter value: method) 
		ifTrue: 
			[self model add: method.
			self model size = 1 ifTrue: [methodsPresenter view ensureVisible]].
	"There may be visible effects (override markers) that need to be updated even when
	the added method is from a different class. Force the method presenter to redraw
	in order to guarantee that these are kept consistent"
	self selectableItems view updateAll!

onMethodCategorized: aCompiledMethod 
	"Private - The development system has re-categorized aCompiledMethod, update 
	appropriately, depending on whether the method passes the receiver's filter."

	(filter value: aCompiledMethod) 
		ifTrue: [self model refresh: aCompiledMethod ifAbsent: [self model add: aCompiledMethod]]
		ifFalse: [self model remove: aCompiledMethod ifAbsent: []]!

onMethodRemoved: aCompiledMethod 
	"Private - The development system has removed aCompiledMethod. Remove this from
	our methods display if it includes it"

	self model remove: aCompiledMethod ifAbsent: [].
	self model isEmpty ifTrue: [self noMethodsView ensureVisible].
	"There may be visible effects (override markers) that need to be updated even when
	the removed method is from a different class. Force the method presenter to redraw 
	in order to guarantee that these are kept consistent"
	self selectableItems view updateAll!

onMethodSelected
	"Private - The method selected within the receiver has changed. 
	Refresh the source pane"

	| text method |
	self promptToCopyChanges.
	text := String new.
	method := self selectedMethod.
	method notNil 
		ifTrue: 
			[text := AutoFormat 
						ifTrue: [method parseTreeNoError ifNil: [method getSource] ifNotNil: [:tree | tree formattedCode]]
						ifFalse: [method getSource]].
	sourcePresenter
		clearStatus;
		text: text;
		selectionRange: (1 to: 0).
	self updateMethodVersion.
	self trigger: #methodSelected!

onMethodSelectionChanging: aSelectionChangingEvent 
	"Private - A selection is about to change  within the receiver.
	Prompt to save any outstanding changes"

	sourcePresenter clearParseTree.
	self onPromptToSaveChanges: aSelectionChangingEvent!

onMethodUpdated: aCompilationResult
	"Private - The development system has added aCompiledMethod. Check to see if this should
	be included in the receiver's display of methods by running it through the filter. If it
	shouldn't then remove any existing occurence of it from the display"

	self onMethod: aCompilationResult oldMethod updatedTo: aCompilationResult method!

onPromptToSaveChanges: aSelectionChangingEvent
	"Private - Check to see if the method source has been changed. 
	If so prompt to see if the changes should be retained and if they should then
	set the value of the parameter to false"

	^sourcePresenter prompt: 'source' toSaveChanges: aSelectionChangingEvent!

onTipTextRequired: tool 
	"Private - Tool tip text is required for the <ToolbarItem>, tool."

	| cmd |
	cmd := tool command.
	cmd == #browseHierarchy 
		ifTrue: [^'Open Hierarchy Browser on <1p>' expandMacrosWith: self selection].
	cmd == #browseSystem ifTrue: [^'Open System Browser on <1p>' expandMacrosWith: self selection].
	#clearSelection == cmd 
		ifTrue: 
			[| methods |
			methods := self selectedMethods.
			^'Delete <1d>' 
				expandMacrosWith: (methods size = 1 ifTrue: [methods first] ifFalse: ['Selected Methods'])].
	^super onTipTextRequired: tool!

onViewClosed
	"Sent by the receiver's view when it has been closed.
	Disconnect from any events triggered by the devlopment system"

	super onViewClosed.
	self systemModel removeEventsTriggeredFor: self!

onViewOpened
	"Received when the receiver's view is been connected. "

	super onViewOpened.
	self applyOptions!

parseContext
	^self selectedMethod ifNil: [parentPresenter parseContext] ifNotNil: [:method | method methodClass]!

parseTree
	^sourcePresenter parseTree!

promptToCopyChanges
	"Private - If there are any changes, prompt the user as to whether they wish to copy them
	to the clipboard because a class selection change has occurred that is not preventable."

	^self onPromptToSaveChanges: (SelectionChangedEvent forSource: self)!

promptToSaveChanges
	| method |
	method := self selectedMethod.
	^self onPromptToSaveChanges: ((SelectionChangingEvent forSource: self)
				oldSelection: method;
				yourself)!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the 
	<CommandQuery> argument."

	| selector method methods |
	selector := aCommandQuery commandSymbol.
	#browseIt == selector ifTrue: [selector := self browseItCommand].
	#clearSelection == selector 
		ifTrue: 
			[selector := self deleteItCommand.
			selector isNil 
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#newMethod == selector 
		ifTrue: 
			[aCommandQuery isEnabled: false.
			^false].	"Can't add new methods as don't know class"
	(#(#definitionsMenu #referencesMenu) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: true.
			^true].
	methods := self selections.
	method := methods size = 1 ifTrue: [methods first].
	#browseMethodInheritanceChain == selector 
		ifTrue: 
			[aCommandQuery isEnabled: (method notNil and: [method isOverride]).
			^true].
	(#(#inspectIt #browsePackages) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: methods notEmpty.
			^true].
	(#(#browseMessages #browseDefinitions #browseReferences #browseHierarchy #browsePackages) 
		identityIncludes: selector) 
			ifTrue: 
				[aCommandQuery isEnabled: method notNil.
				^true].
	#browseSystem == selector 
		ifTrue: 
			[aCommandQuery isEnabled: method notNil.
			^true].
	(#(#addCategoryMenu #removeCategoryMenu #categorizeMethods #methodPackage #removeMethod) 
		identityIncludes: selector) 
			ifTrue: 
				[aCommandQuery isEnabled: (methods notEmpty 
							and: [methods allSatisfy: [:each | parentPresenter isEditableMethod: each]]).
				^true].
	#browseMethodClasses == selector 
		ifTrue: 
			[| text |
			text := method isNil 
						ifTrue: 
							[aCommandQuery isEnabled: methods notEmpty.
							'Classes']
						ifFalse: 
							[aCommandQuery isEnabled: true.
							method methodClass name].
			aCommandQuery text: (aCommandQuery commandDescription menuText expandMacrosWith: text).
			^true].
	#browseMethodPackages == selector 
		ifTrue: 
			[| name packages |
			packages := (methods collect: [:each | each owningPackage]) asSet.
			name := packages size = 1 ifTrue: [packages anyOne name printString] ifFalse: ['Packages'].
			aCommandQuery isEnabled: packages notEmpty.
			aCommandQuery text: (aCommandQuery commandDescription menuText expandMacrosWith: name).
			^true].
	"We want find next to work, even when the source pane does not have focus"
	#findNext == selector 
		ifTrue: 
			[(method notNil and: [sourcePresenter findDetails notNil]) 
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						receiver: sourcePresenter view.
					^true]].
	#togglePrivate == selector 
		ifTrue: 
			[aCommandQuery
				isEnabled: (methods notEmpty 
							and: [methods allSatisfy: [:each | parentPresenter isEditableMethod: each]]);
				isChecked: (methods notEmpty and: [methods allSatisfy: [:each | each isPrivate]]).
			^true].
	^super queryCommand: aCommandQuery!

refactoringTool
	^refactoringTool!

refactoringTool: aMethodRefactoringTool 
	refactoringTool := aMethodRefactoringTool!

removeMethod
	"Removes the selected method(s) from the system"

	self promptToSaveChanges ifFalse: [^self].
	[self systemModel removeMethods: self selections] on: OperationAborted
		do: [:ex | self errorModel value: ex]!

saveMethod: aString in: aClass categories: aCollection package: aPackageOrNil 
	| modified originalSelection change newMethod |
	originalSelection := sourcePresenter selectionRange.
	modified := sourcePresenter isModified.
	sourcePresenter
		clearErrors;
		isModified: false.
	
	[change := self systemModel 
				compile: aString
				in: aClass
				categories: aCollection
				package: aPackageOrNil
				extraFlags: (sourcePresenter isAutoParseEnabled ifTrue: [0] ifFalse: [Interactive])] 
			on: Compiler notificationClass
			do: [:cn | sourcePresenter compilerNotification: cn offset: 0].
	newMethod := change ifNotNil: [change method].
	newMethod 
		ifNil: 
			["If the compilation fails we must restore the modified flag"
			sourcePresenter isModified: modified]
		ifNotNil: [self selectionOrNil == newMethod ifFalse: [self selection: newMethod ifAbsent: []]].
	(sourcePresenter showFirstError: 0) 
		ifFalse: [sourcePresenter view selectionRange: originalSelection].
	^newMethod!

saveNewMethod: aString 
	| editedMethod |
	editedMethod := self selectedMethod.
	(editedMethod notNil and: [self parseTree selector == editedMethod selector]) 
		ifFalse: 
			["Saving a method other than that which was being edited."
			self parseContext 
				ifNotNil: 
					[:class | 
					(class includesSelector: self parseTree selector) 
				ifTrue: 
					[(MessageBox 
						confirm: ('<1d> already defines <2p><n><n>Are you sure you would like to overwrite it?' 
								expandMacrosWith: self parseContext
								with: self parseTree selector)) 
									ifFalse: [^nil]]]].
	parentPresenter saveNewMethod: aString!

searchEnvironment
	^searchEnvironment!

searchEnvironment: aBrowserEnvironment 
	"Set the <BrowserEnvironment> used as the context for searches such as those for references to a selector..
	By default this will be 'Smalltalk', which includes the whole system, so all searches will be global."

	searchEnvironment := aBrowserEnvironment.
	sourcePresenter searchEnvironment: aBrowserEnvironment
	!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"

	^methodsPresenter!

selectedMethod
	"Answer the currently selected method, or nil if there is not exactly one selected."

	^self selectionOrNil!

selectedMethods
	"Answer the currently selected methods, or any empty collection if none are selected."

	^self selections!

selectedNode
	"Private - Answer an <StProgramNode> to represent the syntactic element which is currently
	selected, or which the caret is over in the source pane."

	^sourcePresenter selectedNode!

selectedWord
	^sourcePresenter selectedWord!

selection: aCompiledMethod ifAbsent: exceptionHandler
	"Set the currently selected method to aCompiledMethod"

	aCompiledMethod isNil 
		ifTrue: [self resetSelection]
		ifFalse: [super selection: aCompiledMethod ifAbsent: exceptionHandler]!

selectionEnvironment
	^parentPresenter selectionEnvironment!

selectMethod: aCompiledMethodOrNil 
	"Set the currently selected method to aCompiledMethodOrNil"

	self selectionOrNil: aCompiledMethodOrNil!

setInitialFocus
	self sourcePresenter setFocus!

sortBlock
	^self selectableItems sortBlock!

sortBlock: anObject
	self selectableItems sortBlock: anObject
!

source
	"Answer the source for the currently selected method as a String"

	^sourcePresenter source!

sourceControl

	^Package manager sourceControl!

sourcePresenter
	^sourcePresenter!

sourcePresenter: anObject
	sourcePresenter := anObject!

sourceSelection
	"Answer the current selection of the selected methods source."

	^sourcePresenter view selection!

systemModel
	^Smalltalk developmentSystem!

togglePrivate
	"Private - Toggle the selected method between public and private status."

	| methods |
	methods := self selections.
	methods do: 
			[:method | 
			method isPrivate 
				ifTrue: [self systemModel publicizeMethod: method]
				ifFalse: [self systemModel privatizeMethod: method]]!

updateMethodVersion
	
	[versionModel value: (self selectedMethod isNil 
				ifFalse: [self sourceControl getVersionInfoFor: self selectedMethod])] 
			forkAt: Processor userBackgroundPriority!

versionModel
	^versionModel! !
!MethodBrowser categoriesFor: #addMethods:toCategory:!commands!private! !
!MethodBrowser categoriesFor: #addToCommandRoute:!commands!public! !
!MethodBrowser categoriesFor: #applyOptions!operations!options!public! !
!MethodBrowser categoriesFor: #browseCompilationFailures!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseCompilationIssues!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseContainingText!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseDefinitions!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseDefinitionsMatching:in:!browsing!private! !
!MethodBrowser categoriesFor: #browseDefinitionsOfSelector:in:!browsing!private! !
!MethodBrowser categoriesFor: #browseGlobalReferences:in:!browsing!private! !
!MethodBrowser categoriesFor: #browseHierarchy!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseIt!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseItCommand!browsing!helpers!private! !
!MethodBrowser categoriesFor: #browseMessage!commands!public! !
!MethodBrowser categoriesFor: #browseMessageDefinitions!commands!public! !
!MethodBrowser categoriesFor: #browseMessageDefinitions:in:!browsing!private! !
!MethodBrowser categoriesFor: #browseMessageReferences!commands!public! !
!MethodBrowser categoriesFor: #browseMessageReferences:in:!browsing!private! !
!MethodBrowser categoriesFor: #browseMessagesIn:!browsing!private! !
!MethodBrowser categoriesFor: #browseMessagesMatching:in:!browsing!private! !
!MethodBrowser categoriesFor: #browseMethodClasses!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseMethodInheritanceChain!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseMethodPackages!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseMethodsIn:!browsing!private! !
!MethodBrowser categoriesFor: #browseMethodsMatching:in:!browsing!private! !
!MethodBrowser categoriesFor: #browsePackages!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseReferences!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseReferencesMatching:in:!browsing!private! !
!MethodBrowser categoriesFor: #browseReferencesToGlobal!browsing!commands!public! !
!MethodBrowser categoriesFor: #browseReferencesToLiteral:in:!browsing!private! !
!MethodBrowser categoriesFor: #browserEnvironment!accessing!public! !
!MethodBrowser categoriesFor: #browseSystem!browsing!commands!public! !
!MethodBrowser categoriesFor: #buildAddCategoryMenu:!menus!private! !
!MethodBrowser categoriesFor: #buildParseTree!helpers!private! !
!MethodBrowser categoriesFor: #buildRemoveCategoryMenu:!menus!private! !
!MethodBrowser categoriesFor: #canSaveMethod!helpers!private!testing! !
!MethodBrowser categoriesFor: #categorizeMethods!commands!public! !
!MethodBrowser categoriesFor: #clearErrors!operations!public! !
!MethodBrowser categoriesFor: #clearSelection!commands!public! !
!MethodBrowser categoriesFor: #commandPolicy!accessing!public! !
!MethodBrowser categoriesFor: #createComponents!initializing!public! !
!MethodBrowser categoriesFor: #createSchematicWiring!initializing!public! !
!MethodBrowser categoriesFor: #deleteItCommand!helpers!private! !
!MethodBrowser categoriesFor: #enableSource:!modes!private! !
!MethodBrowser categoriesFor: #ensureSourceVisible!operations!public! !
!MethodBrowser categoriesFor: #errorModel!accessing!public! !
!MethodBrowser categoriesFor: #errorModel:!accessing!public! !
!MethodBrowser categoriesFor: #evaluationContext!accessing!private! !
!MethodBrowser categoriesFor: #filter!accessing!public! !
!MethodBrowser categoriesFor: #filter:!accessing!public! !
!MethodBrowser categoriesFor: #findDetails:!accessing!public! !
!MethodBrowser categoriesFor: #findNextMatch!commands!public!searching! !
!MethodBrowser categoriesFor: #findSelector:!public!searching! !
!MethodBrowser categoriesFor: #hasEditableMethodSelected!public!testing! !
!MethodBrowser categoriesFor: #hasEditableMethodsSelected!public!testing! !
!MethodBrowser categoriesFor: #hasMethods!public!testing! !
!MethodBrowser categoriesFor: #hasMethodSelected!public!testing! !
!MethodBrowser categoriesFor: #hasMethodsSelected!public!testing! !
!MethodBrowser categoriesFor: #initialize!initializing!private! !
!MethodBrowser categoriesFor: #inspectIt!commands!public! !
!MethodBrowser categoriesFor: #isEditableMethod:!public!testing! !
!MethodBrowser categoriesFor: #isModified!public!testing! !
!MethodBrowser categoriesFor: #isSourceReadOnly!private!testing! !
!MethodBrowser categoriesFor: #list:!accessing!public! !
!MethodBrowser categoriesFor: #method!accessing!public! !
!MethodBrowser categoriesFor: #method:!accessing!public! !
!MethodBrowser categoriesFor: #methodCategorizationPolicy!constants!private! !
!MethodBrowser categoriesFor: #methodPackage!commands!public! !
!MethodBrowser categoriesFor: #methods:!accessing!public! !
!MethodBrowser categoriesFor: #methodsPresenter!accessing!private! !
!MethodBrowser categoriesFor: #model:!accessing!public! !
!MethodBrowser categoriesFor: #modifiedModel!accessing!public! !
!MethodBrowser categoriesFor: #modifiedModel:!accessing!public! !
!MethodBrowser categoriesFor: #newMethod!commands!public! !
!MethodBrowser categoriesFor: #noMethodsView!accessing!private! !
!MethodBrowser categoriesFor: #onAboutToDisplayMenu:!event handling!menus!public! !
!MethodBrowser categoriesFor: #onCloseRequested:!event handling!public! !
!MethodBrowser categoriesFor: #onDrag:!event handling!public! !
!MethodBrowser categoriesFor: #onDragCut:!event handling!private! !
!MethodBrowser categoriesFor: #onDragOver:!event handling!private! !
!MethodBrowser categoriesFor: #onDropOver:!event handling!private! !
!MethodBrowser categoriesFor: #onMethod:updatedTo:!event handling!private! !
!MethodBrowser categoriesFor: #onMethodAdded:!event handling!private! !
!MethodBrowser categoriesFor: #onMethodCategorized:!event handling!private! !
!MethodBrowser categoriesFor: #onMethodRemoved:!event handling!private! !
!MethodBrowser categoriesFor: #onMethodSelected!event handling!private! !
!MethodBrowser categoriesFor: #onMethodSelectionChanging:!event handling!private! !
!MethodBrowser categoriesFor: #onMethodUpdated:!event handling!private! !
!MethodBrowser categoriesFor: #onPromptToSaveChanges:!private!testing! !
!MethodBrowser categoriesFor: #onTipTextRequired:!event handling!private! !
!MethodBrowser categoriesFor: #onViewClosed!event handling!public! !
!MethodBrowser categoriesFor: #onViewOpened!event handling!public! !
!MethodBrowser categoriesFor: #parseContext!accessing!public! !
!MethodBrowser categoriesFor: #parseTree!helpers!private! !
!MethodBrowser categoriesFor: #promptToCopyChanges!event handling!public! !
!MethodBrowser categoriesFor: #promptToSaveChanges!helpers!private! !
!MethodBrowser categoriesFor: #queryCommand:!commands!private! !
!MethodBrowser categoriesFor: #refactoringTool!accessing!public! !
!MethodBrowser categoriesFor: #refactoringTool:!accessing!private! !
!MethodBrowser categoriesFor: #removeMethod!commands!public! !
!MethodBrowser categoriesFor: #saveMethod:in:categories:package:!operations!private! !
!MethodBrowser categoriesFor: #saveNewMethod:!helpers!public! !
!MethodBrowser categoriesFor: #searchEnvironment!accessing!public! !
!MethodBrowser categoriesFor: #searchEnvironment:!accessing!public! !
!MethodBrowser categoriesFor: #selectableItems!accessing!private! !
!MethodBrowser categoriesFor: #selectedMethod!accessing!public! !
!MethodBrowser categoriesFor: #selectedMethods!accessing!public! !
!MethodBrowser categoriesFor: #selectedNode!accessing!private! !
!MethodBrowser categoriesFor: #selectedWord!accessing!public! !
!MethodBrowser categoriesFor: #selection:ifAbsent:!accessing!public! !
!MethodBrowser categoriesFor: #selectionEnvironment!accessing!public! !
!MethodBrowser categoriesFor: #selectMethod:!operations!public! !
!MethodBrowser categoriesFor: #setInitialFocus!operations!public! !
!MethodBrowser categoriesFor: #sortBlock!accessing!private! !
!MethodBrowser categoriesFor: #sortBlock:!accessing!private! !
!MethodBrowser categoriesFor: #source!accessing!public! !
!MethodBrowser categoriesFor: #sourceControl!constants!development!public! !
!MethodBrowser categoriesFor: #sourcePresenter!accessing!private! !
!MethodBrowser categoriesFor: #sourcePresenter:!accessing!private! !
!MethodBrowser categoriesFor: #sourceSelection!accessing!public! !
!MethodBrowser categoriesFor: #systemModel!accessing!private! !
!MethodBrowser categoriesFor: #togglePrivate!commands!private! !
!MethodBrowser categoriesFor: #updateMethodVersion!event handling!private! !
!MethodBrowser categoriesFor: #versionModel!accessing!public! !

!MethodBrowser class methodsFor!

autoFormat
	^AutoFormat!

autoFormat: aBoolean
	AutoFormat := aBoolean!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^ListModel newWithSearchPolicy: CompiledMethodSearchPolicy current!

getAdditionalAccelerators
	^AdditionalAccelerators!

getCommandQueryHandlers
	^commandQueryHandlers!

hasInfoTips
	^InfoTips!

hasInfoTips: aBoolean
	InfoTips := aBoolean!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self wordWrap: true.
	self autoFormat: false!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect dictionary: #acceleratorKeyBindings) beImmutable;
		add: ((Aspect boolean: #hasInfoTips)
					isNullable: true;
					yourself);
		yourself!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^(super publishedEventsOfInstances)
		add: #methodSelected;
		add: #dragOver:;
		add: #drop:;
		yourself!

resource_Class_browser_method_list
	"Answer the literal data from which the 'Class browser method list' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Class_browser_method_list)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ListView)  98 30 0 0 98 2 8 1409355849 1 416 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 29 265030 4 ##(Smalltalk.Menu)  0 16 98 20 642 0 16 98 0 8 'De&finitions of' 8 #definitionsMenu 1 0 0 0 0 0 642 0 16 98 0 8 '&References to' 8 #referencesMenu 1 0 0 0 0 0 642 0 16 98 13 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #browseReferencesToGlobal 8 'References to Global...' 1 1 0 0 0 850 1 882 8 #browseContainingText 8 'C&ontaining Text...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'SearchText.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 850 1 882 8 #browseMethodCategory 8 'Cate&gory...' 1 1 0 0 0 850 1 882 8 #browseCompilationFailures 8 'Compilation &Failures' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 850 1 882 8 #browseMethodPackages 8 'Package <s>' 1 1 0 0 0 850 1 882 8 #browseMethodClasses 8 'Class <s>' 1 1 0 0 0 1266 4097 850 1 882 8 #browseMethodHistory 8 '&Change History' 1 1 0 0 0 850 1 882 8 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 0 0 0 1266 4097 850 1 882 8 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 0 0 0 850 1 882 8 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 0 0 0 8 '&Browse other' 0 134217729 0 0 0 0 0 1266 4097 850 1 882 8 #newMethod 8 '&New' 1 1 1010 0 16 1056 8 'NewMethod.ico' 1104 0 0 850 1 882 8 #removeMethod 8 '&Delete' 1 1 1010 0 16 1056 8 'EditClear.ico' 1104 0 0 642 0 16 98 17 850 1 882 8 #renameMethod 8 'Re&name' 1 1 0 0 0 850 1 882 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 850 1 882 8 #safeRemoveMethods 8 'Rem&ove' 1 1 0 0 0 1266 4097 850 1 882 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 642 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 0 0 0 642 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 0 0 0 642 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 0 0 0 1266 4097 642 0 16 98 0 8 'Rename &Temporary' 8 #renameTempMenu 134217729 0 0 0 0 0 642 0 16 98 0 8 'Convert Temp to Inst. Var.' 8 #convertTempToInstVarMenu 134217729 0 0 0 0 0 1266 4097 850 1 882 8 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 0 0 0 850 1 882 8 #pushUpMethods 8 'Push &Up' 9325 1 0 0 0 850 1 882 8 #pushDownMethods 8 'Push &Down' 9327 1 0 0 0 850 1 882 8 #overrideMethods 8 'Ove&rride <1d>' 1 1 0 0 0 850 1 882 8 #moveMethod 8 'Move to &Component...' 1 1 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 1010 0 16 1056 8 'Refactoring.ico' 1104 0 0 0 0 1266 4097 850 1 882 8 #methodPackage 8 '&Package...' 1 1 1010 0 16 1056 8 'Package.ico' 1104 0 0 642 0 16 98 0 8 'Add to &Category' 8 #addCategoryMenu 134217729 0 0 0 0 0 642 0 16 98 0 8 'Re&move from Category' 8 #removeCategoryMenu 134217729 0 0 0 0 0 850 1 882 8 #togglePrivate 8 'Pri&vate' 1 1 0 0 0 1266 4097 850 1 882 8 #browseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 850 1 882 8 #browseAvailableMethods 8 'Browse Available Editions' 1 1 0 0 0 850 1 882 8 #compareMethodEditions 8 'Com&pare Method Editions' 1 1 0 0 0 850 1 882 8 #revertToPreviousEdition 8 'Rever&t to Previous Edition' 1 1 0 0 0 1266 4097 850 1 882 8 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 0 0 0 850 1 882 8 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 0 0 0 8 '&Method' 0 134217729 0 0 0 0 0 0 0 416 0 8 4294902851 459270 ##(Smalltalk.Message)  8 #selector 98 0 8 ##(Smalltalk.IconicListAbstract)  1049670 1 ##(Smalltalk.IconImageManager)  0 3730 8 #infoTip 98 0 0 0 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn)  8 'Methods' 439 8 #left 8 ##(Smalltalk.BasicListAbstract)  8 ##(Smalltalk.SortedCollection)  3730 3760 98 0 0 416 0 3 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  13 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:ctx | 
ctx item isLoose ifTrue: [ctx forecolor: ClassBrowserAbstract looseMethodColor].
(ctx view presenter parentPresenter isEditableMethod: ctx item) 
	ifFalse: 
		[ctx forecolor: (ctx forecolor
			fadedBy: ClassBrowserAbstract grayedMethodFadeFactor)]]' 8 #[41 105 226 0 159 122 17 47 161 180 97 226 5 164 165 226 0 184 220 8 17 226 9 47 168 187 180 106 60 106] 8 #item 8 #isLoose 983558 ##(Smalltalk.VariableBinding)  8 #ClassBrowserAbstract 8 ##(Smalltalk.ClassBrowserAbstract)  8 #looseMethodColor 8 #forecolor: 8 #view 8 #presenter 8 #parentPresenter 8 #isEditableMethod: 8 #forecolor 8 #grayedMethodFadeFactor 8 #fadedBy: 4064 7 257 0 3922 8 '' 33 8 #center 721670 ##(Smalltalk.MessageSend)  8 #empty 98 0 80 4050 0 0 4082 3 1 4112 8 'doIt' 8 '[:m1 :m2 | 
m1 isOverride = m2 isOverride 
	ifTrue: [m1 selector <= m2 selector]
	ifFalse: [m1 isOverride]]' 8 #[31 105 17 158 18 158 132 123 17 159 18 159 130 106 17 158 106] 8 #isOverride 3760 4528 7 513 0 0 0 416 4050 0 0 4082 7 1 4112 8 'doIt' 8 '[:each | 
(each isOverride ifTrue: [CompiledMethod overriddenIcon] ifFalse: [Icon blank]) 
	imageIndex]' 8 #[35 105 17 158 120 46 160 111 48 162 163 106] 4608 721414 ##(Smalltalk.Association)  8 #CompiledMethod 8 ##(Smalltalk.CompiledMethod)  8 #overriddenIcon 4706 8 #Icon 1008 8 #blank 8 #imageIndex 4624 7 257 0 1 0 0 3922 8 '' 33 4448 0 4050 0 0 4082 3 1 4112 8 'doIt' 8 '[:m1 :m2 | m1 isPublic = m2 isPublic ifTrue: [m1 selector <= m2 selector] ifFalse: [m1 isPublic]]' 8 #[31 105 17 158 18 158 132 123 17 159 18 159 130 106 17 158 106] 8 #isPublic 3760 4880 7 513 0 0 0 416 3792 1 0 0 8 #report 544 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 4 4466 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  3359 21 5106 503 233 416 4466 8 #contextMenu: 98 1 656 416 4466 8 #text: 98 1 8 'Methods' 416 4466 8 #columnOrder: 98 1 98 3 5 7 3 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 138 7 0 0 126 0 0 0] 98 0 5106 193 193 0 27 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ContainerView)  98 15 0 0 98 2 8 1409286144 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 1180166 ##(Smalltalk.ProportionalLayout)  202 8 ##(Smalltalk.Dictionary)  98 1 721414 ##(Smalltalk.Association)  410 8 ##(Smalltalk.Splitter)  98 12 0 416 98 2 8 1140850688 1 656 0 498 528 0 517 0 0 0 656 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 351 882 1271 11 656 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 175 0 0 0 123 2 0 0 180 0 0 0] 98 0 882 193 193 0 27 1 16 234 256 98 4 410 8 ##(Smalltalk.ReferenceView)  98 14 0 416 98 2 8 1140916224 131073 1040 0 0 0 5 0 0 0 1040 1180166 ##(Smalltalk.ResourceIdentifier)  8 ##(Smalltalk.MethodWorkspace)  8 #resource_Default_view 0 754 202 208 98 1 818 848 98 2 882 1 361 882 1271 351 1040 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 180 0 0 0 123 2 0 0 99 1 0 0] 98 0 992 0 27 8 'source' 410 1056 98 14 0 416 98 2 8 1140850688 131073 1360 0 498 8 4278190080 0 5 0 0 0 1360 1122 8 ##(Smalltalk.MethodBrowser)  8 #resource_Method_browser_method_list 0 754 202 208 98 1 818 848 98 2 882 1 1 882 1271 351 1360 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 123 2 0 0 175 0 0 0] 1328 992 0 27 8 'methodsList' 0 754 202 208 98 1 818 848 98 2 882 2799 21 882 1271 711 416 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 242 7 0 0 109 1 0 0] 98 3 1360 656 1040 992 0 27 )!

resource_Method_browser_method_list
	"Answer the literal data from which the 'Method browser method list' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Method_browser_method_list)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.WizardCardContainer)  98 15 0 0 98 2 8 1409286144 131073 416 0 0 0 5 265030 4 ##(Smalltalk.Menu)  0 16 98 13 498 0 16 98 0 8 'De&finitions of' 8 #definitionsMenu 1 0 0 0 0 0 498 0 16 98 0 8 '&References to' 8 #referencesMenu 1 0 0 0 0 0 498 0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #browseReferencesToGlobal 8 'R&eferences to Global...' 1 1 0 0 0 706 1 738 8 #browseContainingText 8 'C&ontaining Text...' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'SearchText.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 706 1 738 8 #browseMethodCategory 8 'Cate&gory...' 1 1 0 0 0 706 1 738 8 #browseCompilationFailures 8 'Compilation &Failures' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 706 1 738 8 #browseMethodPackages 8 '&Package <s>' 1 1 0 0 0 706 1 738 8 #browseMethodClasses 8 '&Class <s>' 1 1 0 0 0 1122 4097 706 1 738 8 #browseMethodHistory 8 'Change &History' 1 1 0 0 0 706 1 738 8 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 0 0 0 8 '&Browse other' 0 134217729 0 0 0 0 0 1122 4097 706 1 738 8 #removeMethod 8 '&Delete' 1 1 866 0 16 912 8 'EditClear.ico' 960 0 0 498 0 16 98 17 706 1 738 8 #renameMethod 8 'Re&name' 1 1 0 0 0 706 1 738 8 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 706 1 738 8 #safeRemoveMethods 8 'Rem&ove' 1 1 0 0 0 1122 4097 706 1 738 8 #addParameter 8 'Add &Parameter...' 1 1 0 0 0 498 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 0 0 0 498 0 16 98 0 8 'Rena&me Parameter' 8 #renameParameterMenu 134217729 0 0 0 0 0 498 0 16 98 0 8 '&Inline Parameter' 8 #inlineParameterMenu 134217729 0 0 0 0 0 1122 4097 498 0 16 98 0 8 'Rename &Temporary' 8 #renameTempMenu 134217729 0 0 0 0 0 498 0 16 98 0 8 'Conv&ert Temp to Inst. Var.' 8 #convertTempToInstVarMenu 134217729 0 0 0 0 0 1122 4097 706 1 738 8 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 0 0 0 706 1 738 8 #pushUpMethods 8 'Push &Up' 9325 1 0 0 0 706 1 738 8 #pushDownMethods 8 'Push &Down' 9327 1 0 0 0 706 1 738 8 #overrideMethods 8 'Ove&rride <1d>' 1 1 0 0 0 706 1 738 8 #moveMethod 8 'Move to &Component...' 1 1 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 866 0 16 912 8 'Refactoring.ico' 960 0 0 0 0 1122 4097 706 1 738 8 #methodPackage 8 '&Package...' 1 1 866 0 16 912 8 'Package.ico' 960 0 0 498 0 16 98 0 8 'Add to &Category' 8 #addCategoryMenu 134217729 0 0 0 0 0 498 0 16 98 0 8 'Re&move from Category' 8 #removeCategoryMenu 134217729 0 0 0 0 0 706 1 738 8 #togglePrivate 8 'Pri&vate' 1 1 0 0 0 1122 4097 706 1 738 8 #browseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 8 '&Method' 0 134217729 0 0 0 0 0 0 0 416 655878 ##(Smalltalk.CardLayout)  202 208 98 2 721414 ##(Smalltalk.Association)  3 410 8 ##(Smalltalk.ListView)  98 30 0 416 98 2 8 1140920393 1 3088 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy)  524550 ##(Smalltalk.ColorRef)  8 4278190080 0 13 0 0 0 3088 0 8 4294903581 459270 ##(Smalltalk.Message)  8 #displayString 98 0 3104 1049670 1 ##(Smalltalk.IconImageManager)  0 0 0 0 0 0 202 208 98 4 920646 5 ##(Smalltalk.ListViewColumn)  8 'Selector' 335 8 #left 3330 8 #selector 98 0 787814 3 ##(Smalltalk.BlockClosure)  0 0 1180966 ##(Smalltalk.CompiledExpression)  2 1 8 ##(Smalltalk.UndefinedObject)  8 'doIt' 8 '[:a :b | a selector <= b selector]' 8 #[30 105 226 0 226 32 130 106] 3536 3584 7 513 0 0 0 3088 0 1 3330 8 #infoTip 98 0 0 3458 8 'Class' 333 3504 3330 8 #name 98 0 3330 8 #<= 98 0 3330 8 #methodClass 98 0 0 3088 8 ##(Smalltalk.IconicListAbstract)  1 0 0 3458 8 'Package' 253 3504 3330 3792 98 0 3570 0 0 3602 2 1 3632 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] 3792 4000 7 513 0 3330 8 #owningPackage 98 0 0 3088 0 3 0 0 3458 8 '' 33 8 #center 0 3570 0 0 3602 3 1 3632 8 'doIt' 8 '[:m1 :m2 | m1 isPublic = m2 isPublic ifTrue: [m1 selector <= m2 selector] ifFalse: [m1 isPublic]]' 8 #[31 105 17 158 18 158 132 123 17 159 18 159 130 106 17 158 106] 8 #isPublic 3536 4176 7 513 0 0 0 3088 3920 1 0 0 8 #report 3216 0 133221 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 3 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  1 1 4418 951 421 3088 4354 8 #text: 98 1 8 'Selector' 3088 4354 8 #columnOrder: 98 1 98 4 9 3 5 7 3088 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 219 1 0 0 210 0 0 0] 98 0 4418 193 193 0 27 3058 5 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850945 1 4688 0 721158 ##(Smalltalk.SystemColor)  11 0 5 0 0 0 4688 0 8 4294903713 852486 ##(Smalltalk.NullConverter)  0 0 0 4290 202 208 98 3 4354 4384 98 2 4418 1 1 4418 951 421 4688 4354 8 #isEnabled: 98 1 32 4688 4354 4480 98 1 8 '
There are no methods to browse' 4688 4594 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 219 1 0 0 210 0 0 0] 98 0 4656 0 27 3088 234 256 98 4 3088 8 'methods' 4688 8 'noMethodsText' 0 4290 202 208 98 2 4354 4384 98 2 4418 2799 21 4418 951 421 416 4354 8 #contextMenu: 98 1 512 416 4594 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 82 7 0 0 220 0 0 0] 98 2 3088 4688 4656 0 27 )!

setAdditionalAccelerators: anArray 
	AdditionalAccelerators := anArray!

setCommandQueryHandlers: anArray 
	commandQueryHandlers := anArray!

wordWrap
	"Answer true if instances of the receiver use word wrapping by default."

	^WordWrap!

wordWrap: aBoolean
	"Sets the word wrapping state for instances of the receiver to aBoolean."

	WordWrap := aBoolean! !
!MethodBrowser class categoriesFor: #autoFormat!accessing!public! !
!MethodBrowser class categoriesFor: #autoFormat:!accessing!public! !
!MethodBrowser class categoriesFor: #defaultModel!models!public! !
!MethodBrowser class categoriesFor: #getAdditionalAccelerators!accessing!private! !
!MethodBrowser class categoriesFor: #getCommandQueryHandlers!accessing!private! !
!MethodBrowser class categoriesFor: #hasInfoTips!accessing!options!public! !
!MethodBrowser class categoriesFor: #hasInfoTips:!accessing!options!public! !
!MethodBrowser class categoriesFor: #icon!constants!public! !
!MethodBrowser class categoriesFor: #initialize!initializing!private! !
!MethodBrowser class categoriesFor: #publishedAspects!development!public! !
!MethodBrowser class categoriesFor: #publishedEventsOfInstances!development!events!public! !
!MethodBrowser class categoriesFor: #resource_Class_browser_method_list!public!resources-views! !
!MethodBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!MethodBrowser class categoriesFor: #resource_Method_browser_method_list!public!resources-views! !
!MethodBrowser class categoriesFor: #setAdditionalAccelerators:!accessing!private! !
!MethodBrowser class categoriesFor: #setCommandQueryHandlers:!accessing!private! !
!MethodBrowser class categoriesFor: #wordWrap!accessing!options!public! !
!MethodBrowser class categoriesFor: #wordWrap:!accessing!options!public! !

