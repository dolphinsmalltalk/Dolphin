"Filed out from Dolphin Smalltalk 7"!

ListPresenter subclass: #MethodBrowser
	instanceVariableNames: 'methodsPresenter sourcePresenter filter searchEnvironment refactoringTool versionModel'
	classVariableNames: 'AdditionalAccelerators AutoFormat InfoTips WordWrap'
	poolDictionaries: 'CompilerFlags'
	classInstanceVariableNames: 'commandQueryHandlers'
	classConstants: {}!
MethodBrowser guid: (GUID fromString: '{87b4c68d-026e-11d3-9fd7-00a0cc3e4a32}')!
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
!MethodBrowser categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
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
	"Prompt for a selector and open a method browserdisplaying the references to that selector
	within the context of the current search environment using the the first word of the clipboard text as the initial
	suggestion."

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
										arguments: {methods. cat}.
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
				add: (ListPresenter on: (ListModel newWithSearchPolicy: SearchPolicy method))
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

customDrawMethodClass: anNMLVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in a method browser's class column."

	| class |
	class := anNMLVCUSTOMDRAW item methodClass.
	class isDeprecated ifTrue: [anNMLVCUSTOMDRAW font isStruckThrough: true].
	class isNonInstantiable ifTrue: [anNMLVCUSTOMDRAW font isItalic: true]!

customDrawSelector: anNMLVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in a method browser's selector column."

	| method |
	method := anNMLVCUSTOMDRAW item.
	method isDeprecated ifTrue: [anNMLVCUSTOMDRAW font isStruckThrough: true].
	method isAbstract ifTrue: [anNMLVCUSTOMDRAW font isItalic: true]!

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
			[| packages |
			packages := (methods collect: [:each | each owningPackage]) asSet.
			aCommandQuery isEnabled: packages notEmpty.
			aCommandQuery text: (packages size = 1
						ifTrue: [aCommandQuery commandDescription menuText expandMacrosWith: packages anyOne name printString]
						ifFalse: ['Packages']).
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
	| sccs |
	sccs := self sourceControl.
	sccs isConnected ifFalse: [^self].
	
	[versionModel
		value: (self selectedMethod isNil ifFalse: [sccs getVersionInfoFor: self selectedMethod])]
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
!MethodBrowser categoriesFor: #customDrawMethodClass:!helpers!private! !
!MethodBrowser categoriesFor: #customDrawSelector:!helpers!private! !
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
!MethodBrowser categoriesFor: #sourceControl!constants!public! !
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

	^ListModel newWithSearchPolicy: SearchPolicy method!

getAdditionalKeyBindings
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ListView) 34 45 nil nil 34 2 8 1409355849 1 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 29 265030 4 ##(Smalltalk.Menu) nil true 34 15 610 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil nil nil nil 610 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil nil nil nil 610 nil true 34 13 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #browseReferencesToGlobal 8 'References to Global...' 1 1 nil nil nil 786 1 818 #browseContainingText 8 'C&ontaining Text...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'SearchText.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 786 1 818 #browseMethodCategory 8 'Cate&gory...' 1 1 914 nil true 960 8 'Category.ico' 1008 nil nil 786 1 818 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 786 1 818 #browseMethodPackages 8 'Package <s>' 1 1 914 nil true 960 8 'Package.ico' 1008 nil nil 786 1 818 #browseMethodClasses 8 'Class <s>' 1 1 nil nil nil 1170 4097 786 1 818 #browseMethodHistory 8 '&Change History' 1 1 914 nil true 960 8 'MethodHistory.ico' 1008 nil nil 786 1 818 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 1170 4097 786 1 818 #browseMethodInheritanceChain 8 '&Inheritance Chain' 1 1 nil nil nil 786 1 818 #browseOverriddenMethod 8 'Goto &Superclass Definition' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil nil nil nil 1170 4097 786 1 818 #newMethod 8 '&New' 1 1 914 nil true 960 8 'NewMethod.ico' 1008 nil nil 786 1 818 #removeMethod 8 '&Delete' 1 1 914 nil true 960 8 'EditClear.ico' 1008 nil nil 610 nil true 34 17 786 1 818 #renameMethod 8 'Re&name' 1 1 914 nil true 960 8 'Rename.ico' 1008 nil nil 786 1 818 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 786 1 818 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 1170 4097 786 1 818 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 610 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 610 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil nil nil nil 610 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil nil nil nil 1170 4097 610 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil nil nil nil 610 nil true 8 #() 8 'Convert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil nil nil nil 1170 4097 786 1 818 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 786 1 818 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 786 1 818 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 786 1 818 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 786 1 818 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 914 nil true 960 8 'Refactoring.ico' 1008 nil nil nil nil 1170 4097 786 1 818 #methodPackage 8 '&Package...' 1 1 914 nil true 960 8 'Package.ico' 1008 nil nil 610 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil nil nil nil 610 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil nil nil nil 786 1 818 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 1170 4097 786 1 818 #toggleFilterObjectMethods 8 'Filter &Object Methods' 1 1 nil nil nil 786 1 818 #toggleShowInheritedMethods 8 'Show &Inherited Methods' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil nil nil nil nil nil 416 nil 8 1883852064 459270 ##(Smalltalk.Message) #selector 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil 2994 #infoTip 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 4 1 3104 8 'doIt' 8 '[:ctx | ctx view parentPresenter parentPresenter customDrawSelector: ctx]' 8 #[32 105 226 0 159 159 17 178 106] #view #parentPresenter #customDrawSelector: 3120 7 257 nil nil nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Methods' 431 #left ##(Smalltalk.BasicListAbstract) 2994 #<= 8 #() 2994 #selector 8 #() nil 416 nil 3 nil 3120 3250 8 '' 33 #center 721670 ##(Smalltalk.MessageSend) #empty 8 #() 16 3106 0 nil 3138 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:m1 :m2 | 
m1 isOverride = m2 isOverride 
	ifTrue: [m1 selector <= m2 selector]
	ifFalse: [m1 isOverride]]' 8 #[31 105 17 158 18 158 132 123 17 159 18 159 130 106 17 158 106] #isOverride #selector 3440 7 513 nil nil nil 416 3106 0 nil 3138 7 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:each | 
(each isOverride ifTrue: [CompiledMethod overriddenIcon] ifFalse: [Icon blank]) 
	imageIndex]' 8 #[35 105 17 158 120 46 160 111 48 162 163 106] #isOverride 721414 ##(Smalltalk.Association) #CompiledMethod ##(Smalltalk.CompiledMethod) #overriddenIcon 3602 #Icon 912 #blank #imageIndex 3520 7 257 nil 1 nil nil 3250 8 '' 33 #center nil 3106 0 nil 3138 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:m1 :m2 | m1 isPublic = m2 isPublic ifTrue: [m1 selector <= m2 selector] ifFalse: [m1 isPublic]]' 8 #[31 105 17 158 18 158 132 123 17 159 18 159 130 106 17 158 106] #isPublic #selector 3680 7 513 nil nil nil 416 ##(Smalltalk.IconicListAbstract) 1 nil nil #report 528 nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 4 3394 #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 3858 503 233 416 3394 #contextMenu: 34 1 624 416 3394 #text: 34 1 8 'Methods' 416 3394 #columnOrder: 34 1 8 #(2 3 1) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 186 14 0 0 126 0 0 0] 8 #() 3858 193 193 nil 35 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ContainerView) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 1180166 ##(Smalltalk.ProportionalLayout) 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.Splitter) 34 12 nil 416 34 2 8 1140850688 1 576 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 576 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 674 9 9 nil 688 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1 351 674 1271 11 576 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 175 0 0 0 123 2 0 0 180 0 0 0] 8 #() 674 193 193 nil 27 1 true 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 976 nil nil nil 5 nil nil nil 976 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.MethodBrowser) #resource_Method_browser_method_list nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 1 1 674 1271 351 976 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 123 2 0 0 175 0 0 0] 8 #() 928 nil 27 8 'methodsList' 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140916224 131073 1248 nil nil nil 5 nil nil nil 1248 1042 ##(Smalltalk.MethodWorkspace) #resource_Default_view nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 1 361 674 1271 351 1248 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 180 0 0 0 123 2 0 0 99 1 0 0] 1216 928 nil 27 8 'source' nil 722 138 144 34 1 786 #createAt:extent: 34 2 674 3839 21 674 1271 711 416 866 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 250 9 0 0 109 1 0 0] 34 3 976 576 1248 928 nil 27 )!

resource_Method_browser_method_list
	"Answer the literal data from which the 'Method browser method list' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Method_browser_method_list)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.WizardCardContainer) 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 11 482 nil true 8 #() 8 'De&finitions of' #definitionsMenu 1 nil nil nil nil nil 482 nil true 8 #() 8 '&References to' #referencesMenu 1 nil nil nil nil nil 482 nil true 34 10 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #browseReferencesToGlobal 8 'R&eferences to Global...' 1 1 nil nil nil 658 1 690 #browseContainingText 8 'C&ontaining Text...' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'SearchText.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 658 1 690 #browseMethodCategory 8 'Cate&gory...' 1 1 nil nil nil 658 1 690 #browseCompilationFailures 8 'Compilation &Failures' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 658 1 690 #browseMethodPackages 8 '&Package <s>' 1 1 786 nil true 832 8 'PackageBrowserShell.ico' 880 nil nil 658 1 690 #browseMethodClasses 8 '&Class <s>' 1 1 786 nil true 832 8 'ClassBrowserShell.ico' 880 nil nil 1010 4097 658 1 690 #browseMethodHistory 8 'Change &History' 1 1 786 nil true 832 8 'MethodHistory.ico' 880 nil nil 658 1 690 #browseAllChangedMethods 8 '&All Changed Methods' 1 1 nil nil nil 8 '&Browse other' nil 134217729 nil nil nil nil nil 1010 4097 658 1 690 #removeMethod 8 '&Delete' 1 1 786 nil true 832 8 'EditClear.ico' 880 nil nil 482 nil true 34 17 658 1 690 #renameMethod 8 'Re&name' 1 1 nil nil nil 658 1 690 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 658 1 690 #safeRemoveMethods 8 'Rem&ove' 1 1 nil nil nil 1010 4097 658 1 690 #addParameter 8 'Add &Parameter...' 1 1 nil nil nil 482 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'Rena&me Parameter' #renameParameterMenu 134217729 nil nil nil nil nil 482 nil true 8 #() 8 '&Inline Parameter' #inlineParameterMenu 134217729 nil nil nil nil nil 1010 4097 482 nil true 8 #() 8 'Rename &Temporary' #renameTempMenu 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'Conv&ert Temp to Inst. Var.' #convertTempToInstVarMenu 134217729 nil nil nil nil nil 1010 4097 658 1 690 #inlineAllSelfSends 8 'Inline &Self Sends' 1 1 nil nil nil 658 1 690 #pushUpMethods 8 'Push &Up' 9325 1 nil nil nil 658 1 690 #pushDownMethods 8 'Push &Down' 9327 1 nil nil nil 658 1 690 #overrideMethods 8 'Ove&rride <1d>' 1 1 nil nil nil 658 1 690 #moveMethod 8 'Move to &Component...' 1 1 nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 786 nil true 832 8 'Refactoring.ico' 880 nil nil nil nil 1010 4097 658 1 690 #methodPackage 8 '&Package...' 1 1 786 nil true 832 8 'Package.ico' 880 nil nil 482 nil true 8 #() 8 'Add to &Category' #addCategoryMenu 134217729 nil nil nil nil nil 482 nil true 8 #() 8 'Re&move from Category' #removeCategoryMenu 134217729 nil nil nil nil nil 658 1 690 #togglePrivate 8 'Pri&vate' 1 1 nil nil nil 8 '&Method' nil 134217729 nil nil nil nil nil nil nil 416 656710 1 ##(Smalltalk.CardLayout) 138 144 34 2 721414 ##(Smalltalk.Association) 3 410 ##(Smalltalk.ListView) 34 45 nil 416 34 2 8 1140920393 1 2608 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 13 nil nil nil 2608 nil 8 1883852064 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.ListView) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 'Selector' 335 #left 2818 #selector 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a selector <= b selector]' 8 #[30 105 226 0 226 32 130 106] #selector 3024 7 513 nil nil nil 2608 nil 1 2818 #infoTip 8 #() 3010 0 nil 3042 4 1 3008 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawSelector: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawSelector: 3152 7 257 nil 2930 8 'Class' 333 #left 2818 #name 8 #() 2818 #<= 8 #() 2818 #methodClass 8 #() nil 2608 ##(Smalltalk.IconicListAbstract) 1 nil 3010 0 nil 3042 4 1 3008 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawMethodClass: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawMethodClass: 3360 7 257 nil 2930 8 'Package' 253 #left 2818 #name 8 #() 3010 0 nil 3042 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name <= b name]' 8 #[30 105 226 0 226 32 130 106] #name 3504 7 513 nil 2818 #owningPackage 8 #() nil 2608 ##(Smalltalk.IconicListAbstract) 3 nil nil 2930 8 '' 33 #center nil 3010 0 nil 3042 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:m1 :m2 | m1 isPublic = m2 isPublic ifTrue: [m1 selector <= m2 selector] ifFalse: [m1 isPublic]]' 8 #[31 105 17 158 18 158 132 123 17 159 18 159 130 106 17 158 106] #isPublic #selector 3648 7 513 nil nil nil 2608 ##(Smalltalk.IconicListAbstract) 1 nil nil #report 2720 nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 3842 951 421 2608 3794 #text: 34 1 8 'Selector' 2608 3794 #columnOrder: 34 1 8 #(4 1 2 3) 2608 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 219 1 0 0 210 0 0 0] 8 #() 3842 193 193 nil 35 2578 5 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 4080 nil 2770 #window nil 5 nil nil nil 4080 nil 8 1883797456 852486 ##(Smalltalk.NullConverter) nil nil nil 3730 138 144 34 3 3794 #createAt:extent: 34 2 3842 1 1 3842 951 421 4080 3794 #isEnabled: 8 #(false) 4080 3794 #text: 34 1 8 '
There are no methods to browse' 4080 3986 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 219 1 0 0 210 0 0 0] 8 #() 4048 nil 27 2608 nil nil nil 170 192 34 4 2608 8 'methods' 4080 8 'noMethodsText' nil 3730 138 144 34 2 3794 #createAt:extent: 34 2 3842 7039 21 3842 951 421 416 3794 #contextMenu: 34 1 496 416 3986 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 154 15 0 0 220 0 0 0] 34 2 2608 4080 4048 nil 27 )!

setAdditionalKeyBindings: anArray
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
!MethodBrowser class categoriesFor: #getAdditionalKeyBindings!accessing!private! !
!MethodBrowser class categoriesFor: #getCommandQueryHandlers!accessing!private! !
!MethodBrowser class categoriesFor: #hasInfoTips!accessing!options!public! !
!MethodBrowser class categoriesFor: #hasInfoTips:!accessing!options!public! !
!MethodBrowser class categoriesFor: #icon!constants!public! !
!MethodBrowser class categoriesFor: #initialize!initializing!private! !
!MethodBrowser class categoriesFor: #publishedAspects!public! !
!MethodBrowser class categoriesFor: #publishedEventsOfInstances!events!public! !
!MethodBrowser class categoriesFor: #resource_Class_browser_method_list!public!resources-views! !
!MethodBrowser class categoriesFor: #resource_Default_view!public!resources-views! !
!MethodBrowser class categoriesFor: #resource_Method_browser_method_list!public!resources-views! !
!MethodBrowser class categoriesFor: #setAdditionalKeyBindings:!accessing!private! !
!MethodBrowser class categoriesFor: #setCommandQueryHandlers:!accessing!private! !
!MethodBrowser class categoriesFor: #wordWrap!accessing!options!public! !
!MethodBrowser class categoriesFor: #wordWrap:!accessing!options!public! !

