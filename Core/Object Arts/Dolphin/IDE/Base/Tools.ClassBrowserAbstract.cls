"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.ClassBrowserAbstract'
	instanceVariableNames: 'classesPresenter categoriesPresenter methodBrowserPresenter definitionPresenter modePresenter flags history variablesPresenter protocolsPresenter filterPresenter packageModel statusModel versionModel cardsPresenter loadedPlugins methodCategories'
	classVariableNames: 'GrayedMethodFadeFactor HistoryListSize LooseMethodColor WordWrapDefinition'
	imports: #()
	classInstanceVariableNames: 'defaultShowInheritedMethods defaultFilterObjectMethods plugins'
	classConstants: {
		'FilterObjectMethodsMask' -> 16r2.
		'ShowInheritedMethodsMask' -> 16r1
	}!
Tools.ClassBrowserAbstract guid: (Core.GUID fromString: '{87b4c6bc-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.ClassBrowserAbstract comment: 'ClassBrowserAbstract is an abstract <SmalltalkToolShell> that implements most of the functionality required for a class browser development tool. Concrete subclasses implement the Class Hierarchy Browser and System Browser development tools.

Instance Variables:
	classesPresenter			<ClassHierarchySelector> displaying the class hierarchy.
	categoriesPresenter		<treePresenter> displaying the category hierarchy filtered for methods of the selected class.
	methodBrowserPresenter	<MethodBrowser> browsing methods in the selected class.
	definitionPresenter		<SmalltalkWorkspace> holding the current class definition.
	commentPresenter		<SmalltalkWorkspace> holding the current class comment.
	modePresenter			<listPresenter> displaying the Instance and Class mode tabs.
	flags					<integer> mode flags for the browser.
	history					<HistoryList> keeping a history of visited methods.
	variablesPresenter		<listPresenter> holding a list of instance variables for the current class.
	protocolsPresenter		<listPresenter> holding a list of protocols that the current class conforms to.
	filterPresenter			<CardContainer> holding the Categories, Protocols and Variables cards.
	packageModel			<valueModel>
	statusModel				<valueModel>

Class Variables:
	DefaultPackageName 			<readableString> package name into which new classes are added by default.
	LooseMethodColor 			<Color> used to paint foreground text of loose methods'' selectors in method pane
	WordWrapComment			<boolean> indicating whether the comment pane should would wrap.
	WordWrapDefinition			<boolean> indicating whether the definition pane should word wrap.
	ShowInheritedMethodsMask	<integer>
	FilterObjectMethodsMask		<integer>
	HistoryListSize				<integer>. Maximum number of entries in the visit history list.
	HistoryDwellTime			<integer>. Period of time for which it is necessary to dwell on a visit for an entry to be recorded in the history list.

Class Instance Variables:
	DefaultShowInheritedMethods	<boolean>
	DefaultFilterObjectMethods		<boolean>
'!
!Tools.ClassBrowserAbstract categoriesForClass!MVP-Presenters! !
!Tools.ClassBrowserAbstract methodsFor!

accept
	"Save the source on the currently displayed source card."

	self perform: self acceptItCommand!

acceptItCommand
	"Private - Answer which of the various accept commands applies at this time."

	self isDefinitionCardVisible ifTrue: [^#saveDefinition].
	^nil!

actualClass
	"Answer the actual class selected in the receiver after taking account
	of instance or class mode. Answer nil if there is no class selected"

	^classesPresenter actualClass!

actualClass: class
	"Sets the actual class selected and determines the current mode"

	classesPresenter actualClass: class!

actualClass: aClass ifAbsent: exceptionHandler
	"Sets the actual class selected and determines the current mode."

	classesPresenter actualClass: aClass ifAbsent: exceptionHandler!

actualClassChain
	"Private - Answer the method search chain for the actual class selected in the receiver after taking account
	of instance or class mode and whether superclass searching is enabled."

	| actualClass |
	(actualClass := self actualClass) isNil ifTrue: [^#()].
	^self isShowInheritedMethods
		ifTrue: 
			[| chain |
			chain := actualClass withAllSuperclasses.
			self isFilterObjectMethods
				ifTrue: 
					[| objectClass |
					objectClass := self isInstanceMode ifTrue: [Object] ifFalse: [Object class].
					actualClass ~= objectClass ifTrue: [chain := chain upTo: objectClass]].
			chain]
		ifFalse: [{actualClass}]!

actualClassChainCategories
	"Private - Answer an <OrderedCollection> of all the method categories in the search chain for the actual class selected in the receiver.
	This is after taking account of instance or class mode and whether superclass searching is enabled."

	| categories |
	categories := Set new.
	self actualClassChain do: [:each | categories addAll: each methodCategories].
	^categories!

actualClassChainMethods
	"Private - Answer an <OrderedCollection> of all the methods in the search chain for the
	actual class selected in the receiver. This is after taking account of instance or class
	mode and whether superclass searching is enabled. Implementation Note: Optimized for the
	common case of displaying only the immediate classes methods."

	| dict classes |
	classes := self actualClassChain.
	classes size = 1
		ifTrue: [dict := classes first methodDictionary]
		ifFalse: 
			[dict := IdentityDictionary new.
			classes reverseDo: 
					[:eachClass |
					eachClass methodDictionary
						keysAndValuesDo: [:eachSelector :eachMethod | dict at: eachSelector put: eachMethod]]].
	^dict values!

addCategoriesOfMethod: aCompiledMethod
	(aCompiledMethod realCategories difference: categoriesPresenter model asSet) 
		do: [:each | categoriesPresenter model addCategory: each]!

addMethod: method toCategory: target
	"Private - Add the <CompiledMethod>, method, to the <methodCategory>,
	target, e.g. following a drag-copy operation in the category pane."

	methodBrowserPresenter addMethods: {method} toCategory: target!

addMethodCategory
	"Private - Add a new method category to the receiver's category pane."

	| actualClass newCategory |
	actualClass := self actualClass.
	newCategory := (CategoryPrompter choices: MethodCategory allMethodCategories
				caption: 'Add Method Category ...') showModal.
	newCategory notNil ifFalse: [^self].
	categoriesPresenter model addCategory: newCategory.
	newCategory addClass: actualClass!

addMethodProtocol
	"Private - Add a new <MethodProtocol> to the selected class in the receiver."

	| actualClass newProtocol protocols protClass |
	actualClass := self actualClass.
	protClass := actualClass methodProtocolClass.
	protocols := protClass allMethodProtocols asSortedCollection: [:a :b | a name < b name].
	newProtocol := (ChoicePrompter
				create: 'Extensible choice prompter'
				on: nil asValue
				choices: protocols
				caption: 'Add Protocol to ' , actualClass name , ' ...')
				getTextBlock: [:protocol | protocol name];
				newBlock: [:aString | protClass name: aString];
				showModal.
	newProtocol notNil ifTrue: [self model addClass: actualClass toProtocol: newProtocol]!

addProtocol: newProtocol to: class
	"Private - Add the <MethodProtocol>, newProtocol, to the <ClassDescription>, class, if
	either the class already implements all of the methods, or alternatively if the user 
	agrees to the generation of stub methods. Answer whether the protocol was actually	
	added."

	"Determine if the class includes the protocol already - if it does, then early out"

	| missing |
	(class conformsToProtocol: newProtocol) ifTrue: [^false].
	missing := newProtocol selectors reject: [:s | class canUnderstand: s].
	missing notEmpty
		ifTrue: 
			[| stm |
			stm := String smalltalkWriteStream: 256.
			stm
				nextPutAll: class name;
				nextPutAll: ' does not currently implement or inherit the following selectors from';
				cr;
				nextPutAll: 'the protocol ';
				display: newProtocol;
				nextPut: $;;
				cr;
				cr.
			missing do: [:m | stm print: m] separatedBy: [stm space].
			stm
				cr;
				cr;
				nextPutAll: 'Stub implementations will be automatically generated for the missing selectors.';
				cr;
				nextPutAll: 'Do you still wish to add the protocol to the class?'.
			(MessageBox new
				owner: self view;
				confirm: stm contents) ifFalse: [^false]].
	newProtocol addClass: class.
	^true!

addToCommandRoute: route
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where
	to go next.
	Implementation Note: We want to make sure that the methods and classes presenter are always
	in the route, and that they appear before SmalltalkSystem but after the receiver (if not already
	in the route)."

	route 
		appendTarget: self;
		appendTarget: methodBrowserPresenter;
		appendTarget: classesPresenter;
		appendPresenter: self.!

allCategoriesOfMethod: aCompiledMethod
	"Answer a collection of all the categories that contain the <CompiledMethod> argument, 
	including any intermediate categories in the tree."

	| categoryTree categories |
	categories := IdentitySet new.
	categoryTree := categoriesPresenter model.
	aCompiledMethod categories do: [:each | categories addAll: (categoryTree withAllParents: each)].
	categories removeAll: categoryTree roots.
	^categories!

allCategory
	^categoriesPresenter model title!

applyOptions
	"Private - Apply the class options to the receiver"

	super applyOptions.
	definitionPresenter view wordWrap: self class wordWrapDefinition.
	self class defaultShowInheritedMethods 
		ifTrue: [self toggleShowInheritedMethods].
	self class defaultFilterObjectMethods 
		ifTrue: [self toggleFilterObjectMethods].
	self createPlugins.
!

browseContainingText
	"Prompt for a string and open a method browser displaying the
	methods containing that string."

	self model browseContainingTextIn: self searchEnvironment!

browseDefinitionsMatching: aMethodSearch in: aBrowserEnvironment
	| devsys |
	devsys := self systemModel.
	devsys
		browseMethodsInEnvironments: {devsys definitionsMatching: aMethodSearch in: aBrowserEnvironment.
				devsys definitionsMatching: aMethodSearch
					in: (aBrowserEnvironment forClassHierarchyOf: self actualClass)}!

browseHierarchy
	self systemModel browseHierarchy: self actualClass!

browseInstVarReferences
	"Browse methods that reference all of the selected instance variables of the selected class."

	self model 
		browseReferencesToInstVar: self variables first value
		inHierarchyOf: self actualClass
		within: self searchEnvironment!

browseIt
	"Open a browser on the selected category/protocol/variables.
	Note that we only receive this command it one of the filter panes is selected
	as class hierarchy, method browser, and workspace presenters all handle
	it themselves."

	self perform: self browseItCommand!

browseItCommand
	| focus |
	filterPresenter isNil ifTrue: [^nil].
	focus := View focus.
	focus == categoriesPresenter view
		ifTrue: [^#browseMethodCategory]
		ifFalse: 
			[focus == protocolsPresenter view
				ifTrue: [^#browseMethodProtocol]
				ifFalse: [focus == variablesPresenter view ifTrue: [^#browseInstVarReferences]]].
	^nil!

browseMessageDefinitionsIn: aBrowserEnvironment
	"Private - Prompt for a selector and open a method browser displaying all definitions of
	that selector in the specified <BrowserEnvironment>."

	(self systemModel promptForSelector: '' caption: 'Definitions of ...')
		ifNotNil: [:search | Cursor wait showWhile: [self browseDefinitionsMatching: search in: aBrowserEnvironment]]!

browseMessageReferencesIn: aBrowserEnvironment
	"Private - Prompt for a selector and open a method browser displaying the references to that
	selector from methods defined in the specified <BrowserEnvironment>."

	(self systemModel promptForSelector: '' caption: 'References to...')
		ifNotNil: [:search | Cursor wait showWhile: [self browseReferencesMatching: search in: aBrowserEnvironment]]!

browseMethodCategory
	"Private - Browse all the methods which are in the currently selected category."

	self model browseMethodCategories: self categories in: self searchEnvironment!

browseMethodsIn: aBrowserEnvironment 
	self systemModel browseMethodsIn: aBrowserEnvironment!

browseOverriddenMethod
	"Reposition the browser to the method which the currently selected method is overridding."

	| method |
	method := self method.
	self method: (method methodClass superclass lookupMethod: method selector)!

browseReferences
	"Context-sensitive browse references command (Shift+F12).
	Should only get here for browsing references to instance variables - browsing references to
	class and methods is handled by the <ClassHierarchyPresenter> and <MethodBrowser>
	sub-presenters, respectively."

	self browseInstVarReferences
!

browseReferencesMatching: aMethodSearch in: aBrowserEnvironment
	| devsys |
	devsys := self systemModel.
	devsys
		browseMethodsInEnvironments: {devsys referencesMatching: aMethodSearch in: aBrowserEnvironment.
				devsys referencesMatching: aMethodSearch
					in: (aBrowserEnvironment forClassHierarchyOf: self actualClass)}!

browserEnvironment
	^classesPresenter browserEnvironment!

browseSelectorsInProtocol
	"Private - Pop-up a multi-select <ChoicePrompter> displaying the selectors 
	implemented in the receiver and its superclasses, with all those which are
	part of the protocol selected."

	| protocol newSelectors oldSelectors added removed |
	protocol := self protocols first.
	oldSelectors := protocol selectors.
	(newSelectors := self model chooseSelectorsInProtocol: protocol forClass: self actualClass) notNil 
		ifFalse: [^self].
	added := newSelectors difference: oldSelectors.
	self model addSelectors: added toProtocol: protocol.
	removed := oldSelectors difference: newSelectors.
	self model removeSelectors: removed fromProtocol: protocol!

browseSystem
	"Open a new system browser on at the same point as the receiver."

	self systemModel browseSystem: self actualClass!

buildHistoryFutureMenu
	"Private - Answer a dynamically created future visit menu."

	^(self buildHistoryMenu: history upToEnd command: #historyForward:)
		text: 'Forward';
		yourself!

buildHistoryMenu: visits command: cmdSelector
	"Private - Answer a dynamically created past visit history menu."

	| popup class subMenu selectors |
	popup := Menu new.
	class := nil.
	visits keysAndValuesDo: 
			[:i :m |
			| mclass sel |
			mclass := m methodClass.
			mclass = class
				ifFalse: 
					[selectors := IdentitySet new.
					subMenu := popup addSubmenu: mclass name.
					class := mclass].
			sel := m selector.
			"We only want to add each method to the menu once"
			(selectors includes: sel)
				ifFalse: 
					[subMenu addCommand: (Message selector: cmdSelector argument: i) description: sel.
					selectors add: sel].
			subMenu setDefault: 1].
	popup setDefault: 1.
	^popup!

buildHistoryPastMenu
	"Private - Answer a dynamically created past visit history menu."

	^(self buildHistoryMenu: history past command: #historyBack:)
		text: 'Past';
		yourself!

buildPopupForCommand: aSymbol 
	"Private - Dynamically build an appropriate popup menu for aSymbol command."

	aSymbol == #historyBack ifTrue: [^self buildHistoryPastMenu].
	aSymbol == #historyForward ifTrue: [^self buildHistoryFutureMenu].
	^super buildPopupForCommand: aSymbol!

canSaveMethod
	"In order to be able to save a method in the browser there must be either a single editable
	method selected, or no selection."

	^self hasEditableMethodSelected or: [methodBrowserPresenter hasMethodsSelected not]!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

cardsPresenter
	^cardsPresenter!

categories
	"Private - Answer a Collection of all the method categories which are currently selected."

	| cat |
	cat := self category ifNil: [self allCategory].
	^cat == self allCategory ifTrue: [{cat}] ifFalse: [self hierarchyOfCategory: cat]!

categoriesEnvironment
	^self searchEnvironment forMethodCategories: self categories!

categoriesFilter
	^(self category isNil or: [self category == AllMethodsCategory current])
		ifTrue: [self classMethodFilter]
		ifFalse: [self categoriesMethodFilter]!

categoriesMethodFilter
	"Private - Answer a <monadicValuable> that, when passed a <CompiledMethod>, answers true if
	the method should be displayed in the receiver by warrant of the category that is selected"

	^
	[:eachMethod | 
	(self isMethodVisible: eachMethod) 
		and: [self categories anySatisfy: [:eachCategory | eachCategory includesMethod: eachMethod]]]!

category
	"Answer the currently selected category or nil if there isn't one."

	^categoriesPresenter selectionOrNil!

classDefinition
	"Private - Answer the definition for the currently selected class as a String"

	^definitionPresenter plainText!

classForNewMethod
	^self actualClass ifNil: 
			[self systemModel 
				chooseClass: nil asValue
				caption: 'Choose Class of New Method...'
				allowNil: false]!

classMethodFilter
	"Private - Answer a <monadicValuable> that, when passed a <CompiledMethod>, answers true if the
	method should be displayed in the receiver by warrant of the class that is selected."

	^[:m | (self isMethodVisible: m)]!

clearSelection
	"Private - Remove the selected object from the system"

	self perform: self deleteItCommand!

createAccessors
	"Private - Generate get and set accessors for the currently selected instance variables.
	When the Refactoring Browser is installed this uses the 'Create Instance Variable
	Accessors' refactoring (which is undoable), otherwise it uses the base Dolphin
	implementation (which is not undoable)."

	self model 
		createVariableAccessors: self variables
		classVariables: false
		within: self searchEnvironment!

createComponents
	"Private - Create the presenters contained by the receiver"

	| workspaceClass |
	super createComponents.
	methodBrowserPresenter := self add: self methodBrowserClass new name: 'methodBrowser'.
	methodBrowserPresenter methodsPresenter helpId: 10741.
	workspaceClass := self workspaceClass.
	definitionPresenter := self
				add: workspaceClass new
				name: 'definition'
				helpId: 10746.
	categoriesPresenter := self
				add: (TreePresenter on: (CategoryTreeModel new title: MethodCategory all))
				name: 'categories'
				helpId: 10740.
	modePresenter := self
				add: RadioButtonSetPresenter new
				name: 'mode'
				helpId: 10752.
	variablesPresenter := self add: (ListPresenter on: ListModel newEquality) name: 'variables'.
	protocolsPresenter := self
				add: ListPresenter new
				name: 'protocols'
				helpId: 10743.
	cardsPresenter := self add: Presenter new name: 'cards'.
	packageModel := ValueHolder new.
	statusModel := ValueHolder new!

createPlugins
	"Create the plugins used by the receiver"

	self class plugins do: 
			[:each | 
			| plugin |
			plugin := each createIn: cardsPresenter on: self.
			plugin view arrangement: plugin.
			self loadedPlugins add: plugin]!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self 
		when: #timerTick:
		send: #onTimerTick:
		to: self.
	classesPresenter
		when: #modeChanged
			send: #onClassModeChanged
			to: self;
		when: #selectionChanged
			send: #onClassSelected
			to: self;
		when: #selectionChanging:
			send: #onClassSelectionChanging:
			to: self.
	categoriesPresenter
		when: #selectionChanged
			send: #onCategorySelected
			to: self;
		when: #selectionChanging:
			send: #onFilterSelectionChanging:
			to: self;
		when: #drag:
			send: #onDragCategory:
			to: self;
		when: #dragCut:
			send: #onDragMethodsCut:
			to: self;
		when: #dragOver:
			send: #onDragOverCategory:
			to: self;
		when: #drop:
			send: #onDropOverCategory:
			to: self;
		when: #labelOf:editedTo:accept:
			send: #onCategory:renameTo:accept:
			to: self.
	modePresenter
		when: #valueChanged
			send: #onModeSelectionChanged
			to: self;
		when: #dragOver:
			send: #onDragOverMode:
			to: self;
		when: #drop:
			send: #onDropOverMode:
			to: self.
	methodBrowserPresenter
		when: #methodSelected
			send: #onMethodSelected
			to: self;
		when: #dragOver:
			send: #onDragOverMethod:
			to: self;
		when: #drop:
			send: #onDropOverMethods:
			to: self.
	methodBrowserPresenter selectableItems 
		when: #leftButtonDoubleClicked:
		send: #onMethodListDoubleClicked:
		to: self.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self.
	(self model)
		when: #methodCategorized:
			send: #onMethodCategorized:
			to: self;
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self;
		when: #classUpdated:
			send: #onClassUpdated:
			to: self;
		when: #classCategorized:
			send: #onClassCategorized:
			to: self;
		when: #protocolUpdated:
			send: #onProtocolUpdated:
			to: self;
		when: #protocolRemoved:
			send: #onProtocolRemoved:
			to: self.
	(self packageManager)
		when: #methodRepackaged:from:to:
			send: #onMethodRepackaged:from:to:
			to: self;
		when: #classRepackaged:from:to:
			send: #onClassRepackaged:from:to:
			to: self.
	protocolsPresenter
		when: #selectionChanged
			send: #onProtocolSelected
			to: self;
		when: #selectionChanging:
			send: #onFilterSelectionChanging:
			to: self;
		when: #actionPerformed
			send: #browseMethodProtocol
			to: self;
		when: #drag:
			send: #onDragProtocol:
			to: self;
		when: #dragOver:
			send: #onDragOverProtocol:
			to: self model;
		when: #drop:
			send: #onDropOverProtocol:
			to: self model;
		when: #labelOf:editedTo:accept:
			send: #onRenameMethodProtocol:to:accept:
			to: self.
	variablesPresenter
		when: #drag:
			send: #onDragVariableRefs:
			to: self;
		when: #dragCut:
			send: #onDragMethodsCut:
			to: self;
		when: #selectionChanged
			send: #onVariableSelected
			to: self;
		when: #selectionChanging:
			send: #onFilterSelectionChanging:
			to: self;
		when: #labelOf:editedTo:accept:
			send: #onRenameInstVar:to:accept:
			to: self;
		when: #labelOf:changedTo:
			send: #onRenameInstVar:to:
			to: self.
	cardsPresenter view 
		when: #currentCardChanged
		send: #onBrowserCardChanged
		to: self!

currentCard
	"Answer the current card presenter on view in the receiver"

	^self cardsPresenter view currentCard presenter!

customDrawCategoryTree: aNMTVCUSTOMDRAW 
	"Private - Custom drawing to implement the emphasis in the method category tree."

	| category |
	category := aNMTVCUSTOMDRAW item.
	category isNil ifTrue: [^self].
	self emphasiseCategoryItem: aNMTVCUSTOMDRAW isRelevant: (self methodCategories includes: category)!

customDrawProtocols: aNMLVCUSTOMDRAW 
	"Private - Custom drawing to implement the emphasis in the Method Protocol list."

	| protocol |
	protocol := aNMLVCUSTOMDRAW item.
	protocol isNil ifTrue: [^self].
	self emphasiseProtocolItem: aNMLVCUSTOMDRAW isRelevant: (self methodProtocols includes: protocol)!

customDrawSelector: anNMLVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in a class browser's method list's selector column."

	| method |
	method := anNMLVCUSTOMDRAW item.
	method isLoose ifTrue: [anNMLVCUSTOMDRAW forecolor: self class looseMethodColor].
	(self isEditableMethod: method)
		ifFalse: 
			[anNMLVCUSTOMDRAW forecolor: (anNMLVCUSTOMDRAW forecolor fadedBy: self class grayedMethodFadeFactor)].
	method isDeprecated ifTrue: [anNMLVCUSTOMDRAW font isStruckThrough: true].
	method isAbstract ifTrue: [anNMLVCUSTOMDRAW font isItalic: true]!

definitionCardName
	^'definition'!

deleteItCommand
	| focus |
	focus := View focus.
	focus == categoriesPresenter view ifTrue: [^#removeMethodCategory].
	focus == protocolsPresenter view ifTrue: [^#removeMethodProtocol].
	(self canRefactor and: [focus == variablesPresenter view]) ifTrue: [^#removeInstanceVariables].
	^nil!

dropMethods: aDragDropSession onto: aClass
	| changes isMove count |
	changes := Refactory.Browser.CompositeRefactoryChange new.
	isMove := aDragDropSession isMove.
	count := 0.
	aDragDropSession dragObjects do: 
			[:each |
			(each isFormatAvailable: #CompiledMethod)
				ifTrue: 
					[| method |
					method := each format: #CompiledMethod.
					((classesPresenter
						dropMethod: method
						onto: aClass
						changes: changes) and: 
								[count := count + 1.
								isMove])
						ifTrue: [changes removeMethod: method selector from: method methodClass]]].
	changes name: ('<1s> <2p> methods' expandMacrosWith: aDragDropSession operation with: count).
	"Prevent cut operation in the source"
	aDragDropSession resetOperation.
	classesPresenter performDropChanges: changes target: Object!

emphasiseCategoryItem: anNMTVCUSTOMDRAW isRelevant: aBoolean 
	"Apply emphasis to a category tree entry, depending on whether or not it is relevant to the current method selection.
	By default we implement this by emboldening the relevant categories, but one could also fade the irrelevant categories,
	or use italics or colour to distinguish."

	anNMTVCUSTOMDRAW font isBold: aBoolean!

emphasiseProtocolItem: anNMTVCUSTOMDRAW isRelevant: aBoolean 
	"Apply emphasis to a Method Protocol list entry, depending on whether or not it is relevant to the current method selection.
	By default we implement this by emboldening the relevant protocols, but one could also fade the irrelevant protocols,
	or use italics or colour to distinguish."

	anNMTVCUSTOMDRAW font isBold: aBoolean!

ensureDefinitionVisible
	definitionPresenter ensureVisible!

ensureSourceVisible
	self view topView isActive ifTrue: [methodBrowserPresenter ensureSourceVisible]!

hasClassSelected
	"Answer true if the receiver currently has a class selected
	in the classesPresenter"

	"#954: Note we used to use classesPresenter hasSelection here but this could cause
	a discrepancy between #hasClassSelected and #selectedClass if the class name has
	just been changed."

	^self selectedClass notNil!

hasEditableMethodSelected
	"Answer whether there is a single editable method selected."

	^self method ifNil: [false] ifNotNil: [:method | self isEditableMethod: method]!

hasEditableMethodsSelected
	| methods |
	methods := self selectedMethods.
	^methods notEmpty and: [methods allSatisfy: [:each | self isEditableMethod: each]]!

hasFuture
	^history hasFuture!

hasMethodSelected
	"Answer true if the receiver currently has a method selected in the methodsPresenter"

	^methodBrowserPresenter hasMethodSelected!

hasPast
	^history hasPast!

hierarchyOfCategory: aMethodCategory 
	^(categoriesPresenter model withAllChildren: aMethodCategory) reject: [:each | each isIntermediate]!

historyClear
	history clear!

historySkip: anInteger
	"Private - Move around in the history list by the specified <integer> delta (negative for
	backwards)."

	| method class currentMethod |
	self promptToSaveChanges ifFalse: [^self].
	history skip: anInteger.
	method := history current.
	class := method methodClass.
	self resetFor: class.
	currentMethod := class compiledMethodAt: method selector ifAbsent: [].
	currentMethod isNil
		ifTrue: 
			[self statusText: ('<1p> has been deleted' expandMacrosWith: method).
			Sound warningBeep.
			self actualClass: class]
		ifFalse: [self method: currentMethod]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	flags := 0.
	history := HistoryList new: self class historyListSize.
	loadedPlugins := OrderedCollection new.
	methodCategories := #()!

inspectCollection: aCollection
	(aCollection size = 1 ifTrue: [aCollection first] ifFalse: [aCollection]) inspect!

inspectInstanceVariables
	| vars |
	vars := self variables.
	self 
		inspectCollection: (vars isEmpty ifTrue: [variablesPresenter list asArray] ifFalse: [vars])!

inspectIt
	"Open a browser on the selected category/protocol/variables.
	Note that we only receive this command it one of the filter panes is selected
	as class hierarchy, method browser, and workspace presenters all handle
	it themselves."

	self perform: self inspectItCommand!

inspectItCommand
	filterPresenter notNil
		ifTrue: 
			[| focus |
			focus := View focus.
			focus == categoriesPresenter view
				ifTrue: [^#inspectMethodCategories]
				ifFalse: 
					[focus == protocolsPresenter view
						ifTrue: [^#inspectMethodProtocols]
						ifFalse: [focus == variablesPresenter view ifTrue: [^#browseInstVarReferences]]]].
	^nil!

inspectMethodCategories
	self inspectCollection: self categories!

inspectMethodProtocols
	| prots |
	prots := self protocols.
	self inspectCollection: (prots isEmpty 
				ifTrue: [protocolsPresenter list asArray]
				ifFalse: [prots])!

isDefinitionCardVisible
	^self currentCard view name = self definitionCardName!

isDisplayingCategories
	"Private - Answer whether the categories pane is currently active."

	^filterPresenter isNil or: [filterPresenter currentCard == categoriesPresenter view]!

isDisplayingProtocols
	"Private - Answer whether the protocols pane is currently active."

	^filterPresenter notNil and: [filterPresenter currentCard == protocolsPresenter view]!

isDisplayingVariables
	"Private - Answer whether the instance variables pane is currently active."

	^filterPresenter notNil and: [filterPresenter currentCard == variablesPresenter view]!

isEditableMethod: aCompiledMethod
	"Answer true if aCompiledMethod should be judged as being editable"

	^(self  isInheritedMethod: aCompiledMethod) not
!

isFilterObjectMethods
	"Answer whether the receiver is in 'filter <Object> methods' mode"

	^flags allMask: FilterObjectMethodsMask!

isInheritedMethod: aCompiledMethod 
	"Answer true if aCompiledMethod should be judged as being inherited (i.e. does not belong to the actual class)"

	^aCompiledMethod methodClass name ~= self actualClass name!

isInstanceMode
	"Private - Answer true if the receiver is in instance mode"

	^modePresenter value = #instanceMode
!

isInstanceMode: aBoolean 
	"Private - Set the receiver into class mode, i.e. displaying the class methods
	on the selected class."

	modePresenter value: (aBoolean ifTrue: [#instanceMode] ifFalse: [#classMode])!

isMethodFiltrate: aCompiledMethod
	"Private - Answer whether the <CompiledMethod> argument passes through the current method filter.
	It is assumed that the method is from the currently displayed hierarchy."

	self isFilterObjectMethods ifFalse: [^true].
	^((self isInstanceMode ifTrue: [Object] ifFalse: [Object class])
		includesBehavior: aCompiledMethod methodClass) not!

isMethodVisible: aCompiledMethod 
	| actualClass |
	actualClass := self actualClass.
	^aCompiledMethod methodClass == actualClass or: 
			[self isShowInheritedMethods and: 
					[(actualClass lookupMethod: aCompiledMethod selector) == aCompiledMethod 
						and: [self isMethodFiltrate: aCompiledMethod]]]!

isModified
	^methodBrowserPresenter isModified 
		or: [definitionPresenter isModified or: [self loadedPlugins anySatisfy: [:each | each isModified]]]!

isShowInheritedMethods
	"Answer whether the receiver is in 'show inherited methods' mode"

	^flags allMask: ShowInheritedMethodsMask!

isSourceCardVisible
	^self currentCard view name = self sourceCardName!

killVisitTimer
	self view killTimer: 1!

loadedPlugins
	^loadedPlugins!

method
	"Answer the method displayed by the receiver or nil if there is none"

	^methodBrowserPresenter selectedMethod!

method: method
	"Set the receiver to browse the <CompiledMethod>, method."

	^self method: method
		ifAbsent: 
			[MessageBox
				errorMsg: ('<1p> is not defined in <2p>' expandMacrosWith: method with: self browserEnvironment)]!

method: method ifAbsent: exceptionHandler 
	"Set's the receiver to browse the <CompiledMethod>, method,
	or, if the method is not found, evalutes the <niladicValuable>,
	exceptionHandler."

	| mclass |
	mclass := method methodClass.
	classesPresenter actualClass: mclass ifAbsent: [^exceptionHandler value].
	^methodBrowserPresenter selection: method
		ifAbsent: 
			["Not in list, so is it a valid method?"
			(mclass includesSelector: method selector) ifFalse: [^exceptionHandler value].
			"Try realigning filter pane to include method"
			self isDisplayingCategories 
				ifTrue: 
					["The method exists, but not in the selected category, so we try in the all category"
					categoriesPresenter selection: self allCategory]
				ifFalse: 
					[self isDisplayingProtocols 
						ifTrue: [protocolsPresenter resetSelection]
						ifFalse: [self isDisplayingVariables ifTrue: [variablesPresenter resetSelection]]].
			"Now try again"
			methodBrowserPresenter selection: method ifAbsent: exceptionHandler]!

methodCategories
	"Answer the categories, including intermediate categories, of which the currently selected method is a member."

	^methodCategories!

methodCategories: aCollection 
	(methodCategories noDifference: aCollection) ifTrue: [^self].
	methodCategories := aCollection.
	categoriesPresenter view invalidate!

methodProtocols
	"Answer the <MethodProtocol>s that the currently selected method contributes towards
	implementing in the currently selected class."

	^self method ifNil: [#()] ifNotNil: [:method | method protocols]!

methodProtocols: aCollection 
	protocolsPresenter view invalidate!

methodsMatching: aMonadicValuable
	^self actualClassChainMethods select: aMonadicValuable!

modifiedModel: aValueHolder 
	(self view viewNamed: 'modified' ifNone: []) ifNotNil: [:item | item model: aValueHolder]!

newMethod
	"Sets the receiver up for creating a new method"

	methodBrowserPresenter newMethod!

onBrowserCardChanged
	| currentCardName |
	currentCardName := self currentCard view name.
	(currentCardName = self sourceCardName 
		ifTrue: [methodBrowserPresenter sourcePresenter]
		ifFalse: [currentCardName = self definitionCardName ifTrue: [definitionPresenter]]) 
			ifNotNil: 
				[:workspace | 
				workspace updateErrorStatus.
				self modifiedModel: workspace modifiedModel]!

onCategory: aMethodCategory renameTo: aString accept: aValueHolder
	| newCategory newName |
	newName := String writeStream.
	(aMethodCategory subNames allButLast copyWith: aString) do: [:each | newName nextPutAll: each]
		separatedBy: [newName nextPut: aMethodCategory class separator].
	newName := newName contents.
	newCategory := aMethodCategory class name: newName.
	self renameMethodCategory: aMethodCategory to: newCategory.
	aValueHolder value: true!

onCategorySelected
	"Private - A new category has been selected."

	"Update the method browser to display the new methods"

	| method |
	(self isDisplayingCategories and: [self category notNil]) ifFalse: [^self].
	method := self method.
	self updateMethodsInCategory.
	self method == method 
		ifFalse: 
			[methodBrowserPresenter selection: method
				ifAbsent: 
					["Ignore"
					]].
	self updateCaption!

onClassCategorized: aClass
	"Private - A class within the receiver has been recategorized. 
	Update the caption to match."

	self selectedClass == aClass ifTrue: [
		self updateCaption]!

onClassModeChanged
	"Private - The user has switched between class and Instance modes, or vice versa,
	so the method filters list need to be refreshed appropriately."

	"This may have no effect, but sometimes the classes presenter will change mode, e.g. 
	 due to a history skip, so that our own instance/class mode tab is out of step."
	self isInstanceMode: classesPresenter isInstanceMode.

	self updateFilters.
	self updatePackage.
	self updateCaption!

onClassRepackaged: aClass from: source to: destination
	"Private - A class has been repackaged. If it is currently under scrutiny, refresh the displayed package."

	aClass == self selectedClass ifTrue: [
		self updatePackage]!

onClassSelected
	"Private - The class selected within the receiver has changed. 
	Refresh the method browser, etc."

	"If the selection change is due to a class deletion, for example, then there may be outstanding changes that
	 the user would like to preserve, though our only sensible option is to copy them to the clipboard"

	| definition selection |
	self promptToCopyChanges.
	selection := self selectedClass.
	definition := selection isNil
				ifTrue: 
					[methodBrowserPresenter
						filter: [:method | false];
						clear.
					String new]
				ifFalse: 
					[self isInstanceMode: classesPresenter isInstanceMode.
					selection definition].
	self updateFilters.
	self updatePackage.
	definitionPresenter
		text: definition;
		evaluationContext: selection.
	self updateSourceEnablement.
	self updateCaption.

	"If we have a plugin as the current card then let it decide whether to show the class definition pane"
	(self loadedPlugins includes: self currentCard)
		ifFalse: 
			[(self hasMethodSelected not and: [self isSourceCardVisible]) ifTrue: [self ensureDefinitionVisible]].
	self trigger: #classSelected!

onClassSelectionChanging: aSelectionChangingEvent
	"Private - A selection is about to change  within the receiver.
	Prompt to save any outstanding changes"

	self onPromptToSaveChanges: aSelectionChangingEvent!

onClassUpdated: aClass 
	"Private - A class within the receiver has changed. 
	Refresh the definition pane if it is the selected class,
	and refresh other panes if it is the actual class/metaclass being
	displayed."

	| class |
	class := self actualClass.
	(class isNil or: [(class instanceClass includesBehavior: aClass instanceClass) not]) 
		ifTrue: [^self].
	class instanceClass == aClass instanceClass 
		ifTrue: 
			[self 
				updateClass: 'definition'
				presenter: definitionPresenter
				source: aClass instanceClass definition].

	"If displaying the actual class or a superclass, then may need to refresh variables"
	(class includesBehavior: aClass) ifFalse: [^self].
	self updateVariables.
	self updateCaption!

onCloseRequested: boolValueHolder
	"Private - A request to close the view onto the receiver as occurred.
	Prompt to save any outstanding changed"

	boolValueHolder value: self promptToSaveChanges!

onDragCategory: aDragDropSession
	"Private - A drag of a category has been started. Enter details into the <DragDropSession>,
	session."

	| methods category |
	category := aDragDropSession suggestedSource.
	methods := self methodsMatching: (category == AllMethodsCategory current
						ifTrue: [self classMethodFilter]
						ifFalse: 
							[| categories |
							categories := self hierarchyOfCategory: category.
							
							[:eachMethod |
							(self isMethodVisible: eachMethod)
								and: [categories anySatisfy: [:eachCategory | eachCategory includesMethod: eachMethod]]]]).
	self systemModel beginDrag: aDragDropSession methods: methods!

onDragMethodsCut: aDragDropSession
	"Private - The <DragDropSession>, session, has just completed a successful move operation. 
	The receiver is now responsible for deleting the drag object from its origin."

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

onDragOverCategory: session
	"Private - The user is dragging over the category hierarchy pane.
	Set the operation of the <DragDropSession>, session,
	that would occur if a drop took place now of the objects in that session."

	(session isTargetSameAsSource not and: [session isFormatAvailable: #CompiledMethod])
		ifTrue: 
			[| target op |
			target := session suggestedTarget.
			op := session intendedOperation.
			(target notNil and: [target acceptsAdditions])
				ifTrue: 
					[session
						supportedOperations: #(#copy #move #link);
						operation: op.
					^self]].

	"Set the operation to nil to signify that we don't want the drop"
	session operation: nil!

onDragOverMethod: aDragDropSession
	"Private - The user is dragging over the method list pane.
	Set the operation of the <DragDropSession>, session,
	that would occur if a drop took place now of the objects in that session."

	aDragDropSession
		operation: ((aDragDropSession dragSource ~= aDragDropSession dropTarget
				and: [aDragDropSession isFormatAvailable: #CompiledMethod])
					ifTrue: [aDragDropSession intendedOperation])!

onDragOverMode: aDragDropSession
	"Private - The user is dragging over the instance/class mode selection tab.
	Set the operation of the <DragDropSession> argument that would occur 
	if a drop took place now of the objects in that session."

	| allowDrop |
	allowDrop := false.
	(aDragDropSession isFormatAvailable: #CompiledMethod)
		ifTrue: 
			[aDragDropSession dragSource topView == self view topView
				ifTrue: 
					["Drag was sourced from this class browser"
					allowDrop := aDragDropSession suggestedTarget ~= modePresenter value]]
		ifFalse: 
			["Drag sourced from another browser"
			allowDrop := true].
	aDragDropSession operation: (allowDrop ifTrue: [aDragDropSession intendedOperation])!

onDragProtocol: session
	"Private - A protocol drag has been started. Just extend the available formats
	to mention the availability of MethodProtocols."

	session dragObjects
		do: [:dragee | dragee format: #MethodProtocol data: (dragee format: #Object)]!

onDragVariableRefs: aDragDropSession 
	"Private - A drag of the methods referencing a particular variable has been started (useful
	when refactoring and pulling an instance variable up or pushing down). Enter details into
	the <DragDropSession>, session."

	self systemModel beginDrag: aDragDropSession methods: (self methodsMatching: self variablesFilter)!

onDropOverCategory: aDragDropSession
	"Private - The drag operation described by <DragDropSession>, session, would like to do a drop.
	Override this method to accept the dragObject(s)."

	| targetCategory |
	targetCategory := aDragDropSession suggestedTarget.
	targetCategory isNil
		ifTrue: 
			[Sound errorBeep.
			^false].
	aDragDropSession dragObjects do: 
			[:each |
			"See if the drop is a CompiledMethod"
			(each isFormatAvailable: #CompiledMethod)
				ifTrue: 
					[| method |
					method := each format: #CompiledMethod.

					"Check for a move to single category"
					aDragDropSession isMove
						ifTrue: 
							["Don't change the privacy unless the target is public/private"
							method
								categories: (targetCategory isPrivacy
											ifTrue: [{targetCategory}]
											ifFalse: [{targetCategory. method privacyCategory}]);
								storeCategories].

					"Check for a copy to additional category"
					aDragDropSession isCopy ifTrue: [self addMethod: method toCategory: targetCategory].

					"Check for a removal from target category"
					(aDragDropSession isLink and: [targetCategory includesMethod: method])
						ifTrue: [self removeMethod: method fromCategory: targetCategory]]].
	aDragDropSession isMove
		ifTrue: 
			["Operation must never be #move to avoid methods being removed"
			aDragDropSession operation: #copy].
	^true!

onDropOverMethods: aDragDropSession 
	"Private - The drag operation described by the <DragDropSession> would like 
	to do a drop of methods over the receiver's method list"

	self dropMethods: aDragDropSession onto: self actualClass!

onDropOverMode: aDragDropSession 
	"Private - The drag operation described by the <DragDropSession> would like 
	to do a drop of methods over the receiver's mode tab.
	If the drop fails then we must set the operation to nil in order that the drag-drop
	session can detect the failure (as this is an event handler the return value is ignored)."

	"See if the drop is a CompiledMethod"

	"The drop operation failed (probably due to a duplicate method)"

	| dropClass |
	dropClass := self selectedClass.
	aDragDropSession suggestedTarget = #classMode ifTrue: [dropClass := dropClass class].
	self dropMethods: aDragDropSession onto: dropClass!

onFilterCardChanged
	"Private - The method filter card has been changed. Update the method list
	and dynamic filter accordingly."

	self actualClass isNil ifTrue: [^self].
	self isDisplayingCategories 
		ifTrue: [self updateMethodsInCategory]
		ifFalse: [
			self isDisplayingProtocols 
				ifTrue: [self updateMethodsInProtocol]
				ifFalse: [
					self isDisplayingVariables 
						ifTrue: [self updateMethodsReferencingVariables]]].
	self updateCaption!

onFilterSelectionChanging: aSelectionChangingEvent
	"Private - The selection of class/instance mode, or in one of the method filters is changing. Note that
	this can only affect the method source pane, so there is no need to prompt to save changes
	to definition or comment panes."

	self onPromptToSaveMethodChanges: aSelectionChangingEvent!

onMethodAdded: aCompilationResult
	"Private - The development system has added CompiledMethod identified by aCompilationResult.
	Implementation Note: Some complexity arises if in 'show inherited methods'
	mode as the new method may supplant an inherited method that is currently
	being displayed. We must also ensure that the method's categories are correctly 
	displayed within the receiver's category presenter, if the method is visible."

	| method visible actualClass methodClass |
	method := aCompilationResult method.
	actualClass := self actualClass.
	methodClass := method methodClass.
	(self isShowInheritedMethods and: [actualClass includesBehavior: methodClass])
		ifTrue: 
			[| superclass selector |
			superclass := methodClass superclass.
			selector := method selector.
			((visible := (actualClass lookupMethod: selector) == method) and: [superclass notNil]) 
				ifTrue: 
					["The newly added method is the implementation, perhaps inherited, for the 
					currently selected class  so we must check to see if it supplants a previous 
					implementation, which we will need to remove from the list - note that we start 
					the search in the superclass of the method, just like a Smalltalk supersend."

					(superclass lookupMethod: selector) ifNotNil: [:overridden | 
						methodBrowserPresenter model remove: overridden ifAbsent: []]]]
		ifFalse: [visible := methodClass == actualClass].
	visible ifTrue: [self addCategoriesOfMethod: method]!

onMethodCategorized: aCompiledMethod 
	"Private - The development system has recategorized aCompiledMethod.
	Check to ensure that the method's categories are correctly displayed within
	the receiver's category presenter"

	| isDisplayingMethod |
	aCompiledMethod methodClass == self actualClass ifFalse: [^self].
	self addCategoriesOfMethod: aCompiledMethod.
	isDisplayingMethod := self method == aCompiledMethod.
	isDisplayingMethod ifTrue: [self methodCategories: (self allCategoriesOfMethod: aCompiledMethod)].
	self isDisplayingCategories 
		ifTrue: 
			[#todo.	"Remove this"
			isDisplayingMethod 
				ifTrue: 
					[(aCompiledMethod categories intersection: self categories) isEmpty 
						ifTrue: [methodBrowserPresenter onMethod: aCompiledMethod updatedTo: aCompiledMethod]]]
		ifFalse: [isDisplayingMethod ifTrue: [self updateCaption]]!

onMethodListDoubleClicked: aMouseEvent 
	| hittest method superMethod methodList |
	methodList := methodBrowserPresenter selectableItems view.
	hittest := methodList basicItemFromPoint: aMouseEvent position.
	"A hack to allow for old list boxes as the method list"
	hittest isInteger ifTrue: [^self].
	"Here we are assuming a certain set of columns in the method browser - also a hack. I think
	what we should probably do is associate a command with each column, and then fire that
	when the column is double clicked with full row select off."
	(hittest iItem < 0 or: [hittest iSubItem ~= 1]) ifTrue: [^self].
	method := methodBrowserPresenter selectableItems model at: hittest handle.
	method isOverride ifFalse: [^self].
	aMouseEvent lResult: 0.
	superMethod := method methodClass superclass lookupMethod: method selector.
	[self method: superMethod] postToMessageQueue!

onMethodRemoved: aCompiledMethod 
	"Private - The development system has removed aCompiledMethod."

	"Implementation Note: Some complexity arises if in 'show inherited methods'
	mode as the method may have been hiding a superclass implementation which
	we now need to add into the browser."

	| actualClass methodClass |
	self isShowInheritedMethods ifFalse: [^self].
	methodClass := aCompiledMethod methodClass.
	actualClass := self actualClass.
	(actualClass includesBehavior: methodClass) ifFalse: [^self].

	"A method has been removed in the selected class' inheritance chain - this may possibly
	 have exposed a method higher up the chain."
	(actualClass lookupMethod: aCompiledMethod selector) ifNotNil: 
			[:visibleMethod | 
			((methodClass inheritsFrom: visibleMethod methodClass) 
				and: [self isMethodFiltrate: visibleMethod]) 
					ifTrue: 
						[methodBrowserPresenter model add: visibleMethod.
						self addCategoriesOfMethod: visibleMethod]]!

onMethodRepackaged: method from: source to: destination
	"Private - The <Package>, updatee, has had its contents amended. 
	Update the package display in case either the selected class or method
	has been repackaged."

	self method == method ifTrue: [
		self updatePackage]!

onMethodSelected
	"Private - The method selected within the receiver has changed"

	| method categories protocols |
	self killVisitTimer.
	method := self method.
	method isNil 
		ifTrue: [protocols := categories := #()]
		ifFalse: 
			[categories := self allCategoriesOfMethod: method.
			protocols := method protocols.
			self setVisitTimer].
	self methodCategories: categories.
	self methodProtocols: protocols.
	self updateSourceEnablement.
	self updatePackage.
	self updateCaption.

	"If we have a plugin as the current card then let it decide whether to show the method source pane"
	(self loadedPlugins includes: self currentCard) ifFalse: [self ensureSourceVisible].
	self trigger: #methodSelected!

onModeSelectionChanged
	"Private - The browser has toggled from instance to class mode, or vice versa."

	"^classesPresenter isInstanceMode: modePresenter value = #instanceMode."

	| changingEvent |
	changingEvent := SelectionChangingEvent forSource: modePresenter view.
	changingEvent
		newSelection: modePresenter value;
		oldSelection: (classesPresenter isInstanceMode ifTrue: [#instanceMode] ifFalse: [#classMode]).
	self onPromptToSaveMethodChanges: changingEvent.
	changingEvent value
		ifTrue: [classesPresenter isInstanceMode: changingEvent newSelection = #instanceMode]
		ifFalse: [modePresenter noEventsDo: [modePresenter value: changingEvent oldSelection]]!

onPackageDoubleClicked: aPoint
	"Private - The receiver's package status item was double clicked at the specified point.
	Open the package browser on the package."

	| package |
	package := packageModel value.
	package isNil
		ifTrue: 
			[classesPresenter hasSelection ifTrue: [classesPresenter classPackage] ifFalse: [Sound errorBeep]]
		ifFalse: [Cursor wait showWhile: [packageModel value browse]]!

onPromptToSaveChanges: aSelectionChangingEvent
	"Private - Check to see if the source, definition or comment panes have been changed. 
	If so prompt to see if the changes should be retained and if they should then
	set the value of the out parameter, aBooleanValue, to false"

	^(self onPromptToSaveMethodChanges: aSelectionChangingEvent) 
		and: [self onPromptToSaveClassChanges: aSelectionChangingEvent]!

onPromptToSaveClassChanges: aSelectionChangingEvent 
	"Private - Check to see if the class definition or comment panes have been changed. 
	If so prompt to see if the changes should be retained and if they should then
	set the value of the out parameter, aBooleanValue, to false"

	^(definitionPresenter prompt: 'definition' toSaveChanges: aSelectionChangingEvent) and: 
			[self loadedPlugins allSatisfy: [:each | each promptToSaveClassChanges: aSelectionChangingEvent]]!

onPromptToSaveMethodChanges: aSelectionChangingEvent
	^methodBrowserPresenter onPromptToSaveChanges: aSelectionChangingEvent!

onProtocolRemoved: aMethodProtocol
	"Private - The <MethodProtocol>, aMethodProtocol, has been removed from the system.
	Update the protocols list."

	(protocolsPresenter model includes: aMethodProtocol) ifTrue: [
		protocolsPresenter model remove: aMethodProtocol]!

onProtocolSelected
	"Private - A new protocol has been selected."

	"Update the method browser to display the new methods"

	| method |
	self isDisplayingProtocols ifFalse: [^self].
	method := self method.
	self updateMethodsInProtocol.
	self method == method 
		ifFalse: 
			[methodBrowserPresenter selection: method
				ifAbsent: 
					["Ignore"
					]]!

onProtocolUpdated: aMethodProtocol 
	"Private - The <MethodProtocol>, aMethodProtocol, has been updated in some manner (normally
	by having classes/selectors added/removed), update the browser to reflect the change."

	| class |
	(class := self actualClass) isNil ifTrue: [^self].
	(class conformsToProtocol: aMethodProtocol) 
		ifTrue: 
			["Selected class conforms to the updated protocol, may need to refresh
			 protocol pane or methods list."
			| i |
			(i := protocolsPresenter model identityIndexOf: aMethodProtocol) isZero 
				ifTrue: 
					["Protocol has been added to our selected class, so we need
					 to add it in too."
					protocolsPresenter model add: aMethodProtocol]
				ifFalse: 
					["Protocol has been updated, and we already have it in our
					 list, we need to ensure our protocol list method browser
					 are up-to-date."
					protocolsPresenter model refreshAtIndex: i.
					self onProtocolSelected]]
		ifFalse: 
			["Selected class does not conform to the updated protocol. May need to
			 refresh the protocol pane if it did previously. If not present then we
			 obviously don't care about this protocol in this browser."
			(protocolsPresenter model includes: aMethodProtocol) 
				ifTrue: 
					["Protocol has apparently been removed from the selected
					 class (we have it in list, but class no longer conforms)."
					protocolsPresenter model remove: aMethodProtocol]].
	self method ifNotNil: [:method | self methodProtocols: method protocols]!

onRenameInstVar: anAssociation to: aString
	"Private - Action an in-place inst var rename that passed validation."

	"Implementation Note: Selection will be lost by #classUpdated: event, unless we explicitly maintain it"

	| selections |
	selections := variablesPresenter view selectionsByIndex.
	(self model
		renameInstanceVariable: anAssociation value
		to: aString
		in: anAssociation key
		within: Refactory.Browser.BrowserEnvironment new)
			ifNotNil: [variablesPresenter view selectionsByIndex: selections]!

onRenameInstVar: anAssociation to: aString accept: aValueHolder
	"Private - In-place inst var rename has been made by the user, validate it."

	aValueHolder
		value: (
			[self systemModel
				validateRenameInstVar: anAssociation value
				to: aString
				in: anAssociation key.
			true]
					on: Error
					do: 
						[:ex |
						MessageBox errorMsg: ex description
							caption: ('Rename <1d>.<2d> to <3s>...'
									expandMacrosWith: anAssociation value
									with: anAssociation key
									with: aString).
						false])!

onRenameMethodProtocol: aMethodProtocol to: aString accept: aValueHolder
	(self validateProtocol: aMethodProtocol renameTo: aString) 
		ifTrue: [aMethodProtocol rename: aString]!

onRepackaged: anObject
	"Private - The development system has re-packaged anObject.
	Check to ensure that the package is correctly displayed within
	the receiver if it is displaying this object"

	(self selectedClass==anObject or: [self method==anObject]) ifTrue: [
		self updatePackage]!

onStatusDoubleClicked: aPoint 
	"Private - The receiver's status item was double clicked at the specified point."

	self trigger: #statusActionPerformed!

onTimerTick: anInteger 
	anInteger == 1 ifFalse: [^self].
	self killVisitTimer.
	self recordMethodVisit!

onTipTextRequired: tool
	"Tool tip text is required for the <ToolbarItem>, tool."

	| cmd |
	cmd := tool command asSymbol.
	cmd == #clearSelection ifTrue: [cmd := self deleteItCommand].
	cmd == #removeMethodCategory
		ifTrue: [^'Remove category <2p> from <1p>' expandMacrosWith: self actualClass with: self category name].
	cmd == #removeInstanceVariables ifTrue: [^'Delete instance variables'].
	cmd == #removeMethodProtocol ifTrue: [^'Remove method protocol'].
	cmd == #browseHierarchy
		ifTrue: [^'Open Hierarchy Browser on <1p>' expandMacrosWith: self actualClass].
	cmd == #browseSystem ifTrue: [^'Open System Browser on <1p>' expandMacrosWith: self actualClass].
	#find == cmd ifTrue: [^'Find class'].
	cmd == #newClass ifTrue: [^'New subclass of <1p>' expandMacrosWith: self selectedClass].
	cmd == #newMethod
		ifTrue: 
			[| cat |
			cat := self category.
			^cat == self allCategory
				ifTrue: ['New unclassified method']
				ifFalse: ['New method in <1p>' expandMacrosWith: cat name]].
	(cmd == #historyBack and: [history hasPast])
		ifTrue: [^'Back to <1p>' expandMacrosWith: history previous].
	(cmd == #historyForward and: [history hasFuture])
		ifTrue: [^'Forward to <1p>' expandMacrosWith: history next].
	cmd := tool command asSymbol.
	cmd == #toggleShowInheritedMethods
		ifTrue: 
			[^self isShowInheritedMethods
				ifTrue: ['Don''t show inherited methods']
				ifFalse: ['Show inherited methods']].
	^super onTipTextRequired: tool!

onVariableSelected
	"Private - A new instance variable has been selected."

	"Update the method browser to display the new methods"

	| method |
	self isDisplayingVariables ifFalse: [^self].
	method := self method.
	self updateMethodsReferencingVariables.
	self updateCaption.
	self method == method 
		ifFalse: 
			[methodBrowserPresenter selection: method
				ifAbsent: 
					["Ignore"
					]]!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	| toolbar modifiedModel |
	super onViewOpened.
	methodBrowserPresenter beSorted: [:a :b | a selector <= b selector].
	(self view viewNamed: 'message' ifNone: []) 
		ifNotNil: 
			[:item | 
			item 
				when: #doubleClicked:
				send: #onStatusDoubleClicked:
				to: self.
			item model: self statusModel.
			methodBrowserPresenter errorModel: self statusModel.
			definitionPresenter errorModel: self statusModel].
	(self view viewNamed: 'packageOfSelection' ifNone: []) 
		ifNotNil: 
			[:item | 
			item 
				when: #doubleClicked:
				send: #onPackageDoubleClicked:
				to: self.
			item model: packageModel].
	(self view viewNamed: 'version' ifNone: []) 
		ifNotNil: [:item | item model: methodBrowserPresenter versionModel].
	modifiedModel := methodBrowserPresenter modifiedModel.
	self modifiedModel: modifiedModel.
	"Historically we have only flagged method changes in the caption."
	modifiedModel 
		when: #valueChanged
		send: #updateCaption
		to: self.
	toolbar := self view viewNamed: 'classBrowserTools'.
	toolbar presenterConnectionPoint 
		when: #dropDown:
		send: #onDropDown:
		to: self.

	"Really a CardContainer view, but we treat as if a presenter"
	filterPresenter := self view viewNamed: 'filters' ifNone: [].
	filterPresenter notNil 
		ifTrue: 
			[filterPresenter
				when: #currentCardChanged
					send: #onFilterCardChanged
					to: self;
				when: #currentCardChanging:
					send: #onFilterSelectionChanging:
					to: self].
	definitionPresenter ensureVisible!

packageForNewMethod
	"Private - Answer the <Package> into which newly defined methods should be saved, or 
	nil to use the default (the owning class' package)."

	^nil!

packageNames: aCollection
	"Set the receiver's package selection to include only those packages named in the argument.
	This may have no effect if the receiver does not support filtering by package."

	self packages: (aCollection collect: [:each | Package manager packageNamed: each])!

packages: aCollection 
	"Set the receiver's package selection to include only those packages in the argument.
	This may have no effect if the receiver does not support filtering by package."

	classesPresenter packages: aCollection asArray!

parseContext
	"Answer the class in who's context methods should be compiled."

	^self actualClass!

parseTree
	^methodBrowserPresenter parseTree!

printCaptionForClass: aClass on: aWriteStream 
	"Private - Answer a suitable caption for the selected method."

	self isDisplayingVariables 
		ifTrue: 
			[| variables |
			variables := self variables.
			variables notEmpty 
				ifTrue: 
					[aWriteStream nextPutAll: 'Methods in '.
					self printClassTitle: aClass on: aWriteStream.
					aWriteStream nextPutAll: ' which access '.
					variables do: 
							[:v | 
							aWriteStream
								print: v key;
								nextPut: $.;
								display: v value]
						separatedBy: [aWriteStream nextPutAll: ' or '].
					^self]].
	self printClassTitle: aClass on: aWriteStream.
	aWriteStream nextPutAll: ' ('.
	aClass instanceClass categories asSortedCollection 
		do: [:category | aWriteStream nextPutAll: category name]
		separatedBy: [aWriteStream nextPutAll: ', '].
	aWriteStream nextPut: $)!

printCaptionForMethod: aCompiledMethod on: aWriteStream
	aCompiledMethod displayOn: aWriteStream!

printClassTitle: anObject on: target 
	"Private - Print the 'title' of the currently selected class onto the <puttableStream>, target."

	target nextPutAll: anObject fullName
!

printShortCaptionForClass: aClass on: aWriteStream
	aClass isNil
		ifTrue: [self class displayOn: aWriteStream]
		ifFalse: [self printClassTitle: aClass on: aWriteStream]!

promptToCopyChanges
	"Private - If there are any changes, prompt the user as to whether they wish to copy them
	to the clipboard because a class selection change has occurred that is not preventable."

	^self onPromptToSaveChanges: (SelectionChangedEvent forSource: self)!

promptToSaveChanges
	"Private - If there are any changes, prompt the user as to whether they wish to save them,
	and answer a <Boolean> indicating the response."

	^self onPromptToSaveChanges: ((SelectionChangingEvent forSource: self)
				oldSelection: self selectedClass;
				yourself)!

protocols
	"Answer a Collection of all the method protocols which
	are currently selected."

	^protocolsPresenter hasView
		ifTrue: [protocolsPresenter selections]
		ifFalse: [#()]!

protocols: protocols 
	"Set the currently selected method protocols the <collection> of protocols"

	self hasClassSelected 
		ifTrue: 
			[protocolsPresenter
				selections: protocols;
				ensureVisible]!

protocolsMethodFilter
	"Private - Answer a <monadicValuable> that, when passed a <CompiledMethod>, answers true if the
	method should be displayed in the receiver by warrant of the protocol that is selected"

	^
	[:m | 
	(self isMethodVisible: m) 
		and: [self protocols anySatisfy: [:each | each includesSelector: m selector]]]!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>."

	| selector |
	selector := aCommandQuery commandSymbol.
	#accept == selector
		ifTrue: 
			[selector := self acceptItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#renameIt == selector
		ifTrue: 
			[selector := self renameItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#browseIt == selector
		ifTrue: 
			[selector := self browseItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#inspectIt == selector
		ifTrue: 
			[selector := self inspectItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#clearSelection == selector
		ifTrue: 
			[selector := self deleteItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	(#(#saveDefinition #browseMessageDefinitionsIn: #browseMessageReferencesIn:)
		identityIncludes: selector)
			ifTrue: 
				[aCommandQuery isEnabled: self hasClassSelected.
				^true].
	#toggleShowInheritedMethods == selector
		ifTrue: [aCommandQuery isChecked: self isShowInheritedMethods].
	#toggleFilterObjectMethods == selector
		ifTrue: 
			[aCommandQuery
				isChecked: self isFilterObjectMethods;
				isEnabled: self isShowInheritedMethods.
			^true].
	#toggleProtocolReadOnly == selector
		ifTrue: 
			[| prots |
			prots := self protocols.
			prots size == 1
				ifTrue: 
					[| prot |
					prot := prots first.
					aCommandQuery
						isChecked: prot isReadOnly;
						isEnabled: prot isANSI not]
				ifFalse: [aCommandQuery isEnabled: false].
			^true].
	(#(#browseSelectorsInProtocol #renameMethodProtocol) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: (self protocols size == 1 and: [self protocols first isReadOnly not]).
			^true].
	(#(#removeMethodProtocol #removeMethodsInProtocol) identityIncludes: selector)
		ifTrue: 
			[| prots |
			prots := self protocols.
			"Can only remove selected protocols if this is the first implementor in the superclass chain"
			aCommandQuery
				isEnabled: (prots notEmpty and: 
							[selector == #removeMethodsInProtocol or: [(prots difference: self actualClass protocols) isEmpty]]).
			^true].
	(#(#browseInstVarReferences #browseReferences) identityIncludes: selector)
		ifTrue: 
			[| vars |
			vars := self variables.
			aCommandQuery isEnabled: (vars notNil and: [vars size = 1]).
			^true].
	#browseOverriddenMethod == selector
		ifTrue: 
			[aCommandQuery isEnabled: (self hasMethodSelected and: [self method isOverride]).
			^true].
	#browseMethodProtocol == selector
		ifTrue: 
			[aCommandQuery isEnabled: self protocols notEmpty.
			^true].
	(#(#newMethod #browseHierarchy #addMethodProtocol #addMethodCategory #reformatAll)
		identityIncludes: selector)
			ifTrue: 
				[aCommandQuery isEnabled: self hasClassSelected.
				^true].
	#historyBack: == selector
		ifTrue: 
			[| dist |
			dist := aCommandQuery command arguments first.
			aCommandQuery isEnabled: history pastSize >= dist.
			^true].
	#historyForward: == selector
		ifTrue: 
			[| dist |
			dist := aCommandQuery command arguments first.
			aCommandQuery isEnabled: history futureSize >= dist.
			^true].
	selector == #historyForward
		ifTrue: 
			[self hasFuture
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {history next}
									locale: Locale smalltalk)]
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
						text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {history previous}
									locale: Locale smalltalk)]
				ifFalse: 
					[aCommandQuery
						isEnabled: false;
						text: 'Back'].
			^true].
	selector == #historyClear
		ifTrue: 
			[aCommandQuery isEnabled: self hasPast | self hasFuture.
			^true].
	#browseMethodCategory == selector
		ifTrue: 
			[| cat |
			cat := self category.
			aCommandQuery isEnabled: cat notNil.
			^true].
	(#(#removeMethodCategory #renameMethodCategory #renameMethodCategoryInPlace)
		identityIncludes: selector)
			ifTrue: 
				[| cat |
				cat := self category.
				"Virtual categories are permanent/calculated and cannot be removed"
				aCommandQuery isEnabled: (cat notNil and: [cat isVirtual not]).
				^true].
	#removeMethodsInCategory == selector
		ifTrue: 
			[| cat |
			aCommandQuery
				isEnabled: ((cat := self category) notNil and: [(cat methodsInBehavior: self actualClass) notEmpty]).
			^true].
	#createAccessors == selector
		ifTrue: 
			[aCommandQuery isEnabled: self variables notEmpty.
			^true].
	#renameInstanceVariable == selector
		ifTrue: 
			[aCommandQuery isEnabled: self variables size = 1.
			^true].
	^super queryCommand: aCommandQuery!

recordMethodVisit
	"Add to the visit history - note that the current item is at the top of the history list"

	| method |
	method := self method.
	method isNil ifTrue: [^self].
	(history isEmpty or: 
			[| cur |
			cur := history current.
			cur methodClass ~= method methodClass or: [cur selector ~= method selector]]) 
		ifTrue: 
			[history addLast: method.
			self invalidateUserInterface]
		ifFalse: [history current: method]!

reformatAll
	(MessageBox
		confirm: 'Are you sure you want to reformat all methods in the currently selected class?<n><n>(The operation is undoable)'
				expandMacros)
			ifFalse: [^self].
	self model reformatAllMethodsIn: classesPresenter selectionEnvironment!

removeMethod: aCompiledMethod fromCategory: aMethodCategory 
	"Private - Remove the <CompiledMethod>, method, from the <MethodCategory>,
	targetCategory, e.g. following a drag-link operation in the category pane."

	aMethodCategory removeMethod: aCompiledMethod.
	aCompiledMethod storeCategories!

removeMethod: method fromProtocol: target
	"Private - Remove the <CompiledMethod>, method, from the <MethodProtocol>,
	target, e.g. following a drag-link operation in the category pane.
	Implementation Note: We can't be sure if the user wishes to remove the selector 
	from the protocol or the protocol from class of the method, so we must ask. In
	any case this is a much more important operation than simple method recategorization
	so we need to warn the user anyway."

	| response |
	response := MessageBox new
				defaultButton: 3;
				confirmOrCancel: ('Are you sure that you would like to remove the selector <2p> from the protocol <1d>?<n>
Press Yes to remove <2p> from the list of selectors required by the <1d> protocol.
(May affect other conforming classes or the users of those classes)<n>
Press No to remove <1d> from the set of protocols to which <3p> conforms.
(May affect the users of <3p> or its subclasses)<n>
Press Cancel to abort the operation (recommended).'
							expandMacrosWith: target
							with: method selector
							with: method methodClass).
	response == #cancel ifTrue: [^self].
	response == #yes
		ifTrue: [target removeSelector: method selector ifAbsent: []]
		ifFalse: 
			[target removeClass: method methodClass.
			protocolsPresenter model remove: target]!

removeMethodCategory
	"Private - Remove the currently selected category without deleting any
	of the methods."

	| actualClass catModel |
	actualClass := self actualClass.
	(MessageBox
		confirm: ('Are you sure you would like to remove the method category ''<2d>'' and its sub-categories from <1p>?<n>(No methods will be deleted)'
				expandMacrosWith: actualClass
				with: self category))
			ifFalse: [^self].
	self categories do: [:category | category removeClass: actualClass].
	catModel := categoriesPresenter model.
	catModel remove: self category.
	categoriesPresenter selection: self allCategory!

removeMethodProtocol
	"Private - Remove the currently selected protocols from the class."

	self protocols do: [:p |
		self model removeClass: self actualClass fromProtocol: p ].
!

removeMethodsInCategory
	"Private - Remove all of the methods in the currently selected category. As this is rather
	drastic the user will be prompted."

	| classEnvironment categoryEnvironment |
	classEnvironment := self searchEnvironment forClasses: {self actualClass}.
	categoryEnvironment := classEnvironment forMethodCategories: self categories.
	categoryEnvironment label: ('methods of <1p> in the ''<2d>'' category and its subcategories'
				expandMacrosWith: classEnvironment
				with: self category).
	[self systemModel removeMethodsIn: categoryEnvironment within: self searchEnvironment]
		on: OperationAborted
		do: [:ex | self statusModel value: ex]!

removeMethodsInProtocol
	"Private - Remove all of the methods in the currently selected protocol.
	As this is pretty drastic we give the user a second chance."

	| actualClass |
	actualClass := self actualClass.
	self protocols do: 
			[:p |
			(MessageBox new
				defaultButton: 2;
				owner: self view;
				confirm: ('Are you sure you would like to remove the protocol <2d> and all of its methods from <1p>?'
							expandMacrosWith: actualClass
							with: p))
					ifTrue: [actualClass removeSelectors: ((p methodsInBehavior: actualClass) collect: [:m | m selector])]]!

removePlugin: aClassBrowserPlugin 
	self loadedPlugins remove: aClassBrowserPlugin.
	cardsPresenter remove: aClassBrowserPlugin!

renameInstanceVariable
	"Private - Initiate a rename of the  first selected instance variable."

	variablesPresenter view editSelectionLabel!

renameIt
	self perform: self renameItCommand!

renameItCommand
	"Private - Answer the appropriate rename command for the context sensitive 'Rename It' command, given
	the current focus in the receiver."

	| focus |
	focus := View focus.
	focus == categoriesPresenter view ifTrue: [^#renameMethodCategoryInPlace].
	focus == protocolsPresenter view ifTrue: [^#renameMethodProtocol].
	focus == variablesPresenter view ifTrue: [^#renameInstanceVariable].
	^nil!

renameMethodCategory
	"Private - Prompter for a new name for the current category, and rename it."

	| originalCategory newName actualClass |
	originalCategory := self category.
	actualClass := self actualClass.
	newName := (CategoryPrompter createOn: originalCategory asValue)
				list: MethodCategory allMethodCategories;
				caption: ('Rename  ''<1d>'' within <2p>' expandMacrosWith: originalCategory with: actualClass);
				allowIntermediates: originalCategory isIntermediate;
				showModal.
	self renameMethodCategory: originalCategory to: newName!

renameMethodCategory: aMethodCategory to: aString
	"Private - Rename the specified <MethodCategory>. This is complicated by the pseudo category hierarchy which
	is built up - if a branch category is renamed, then we need to rename all its sub-categories."

	| rootSubNames originalSubNames actualClass |
	(aString notNil and: [aString ~= aMethodCategory]) ifFalse: [^self].
	originalSubNames := aMethodCategory subNames.
	actualClass := self actualClass.
	rootSubNames := aString subNames.
	self categories do: 
			[:category |
			| methods subNames newSubNames name newCategory |
			subNames := category subNames.
			newSubNames := rootSubNames copy , (subNames copyFrom: originalSubNames size + 1).
			name := String new.
			newSubNames do: [:subName | name := name , subName]
				separatedBy: [name := name copyWith: MethodCategory separator].
			newCategory := MethodCategory name: name.

			"Ensure it is in the category tree"
			categoriesPresenter model addCategory: newCategory.
			methods := category methodsInBehavior: actualClass.
			category removeClass: actualClass.
			methodBrowserPresenter addMethods: methods toCategory: newCategory].
	self actualClass: actualClass.
	categoriesPresenter selection: aString
		ifAbsent: [categoriesPresenter selection: (IntermediateCategory name: aString name)].
	categoriesPresenter model remove: aMethodCategory!

renameMethodCategoryInPlace
	"Private - Initiate an in-place rename of the currently selected category node."

	categoriesPresenter selectableItems view editSelectionLabel!

renameMethodProtocol
	"Private - Rename the current method protocol."
	
	protocolsPresenter view editSelectionLabel!

resetFor: aClass 
	"Private - Reset the receiver to place it into a state required to display aClass"

	!

resetForFoundClass: class 
	"Private - Reset the receiver to place it into a state required to display aClass
	that has just been searched for"

	self resetFor: class!

saveDefinition
	"Private - Save the class definition currently in the definition window"

	"Compile the class definition"

	| wasModified |
	wasModified := definitionPresenter isModified.
	definitionPresenter isModified: false.
	#todo. "Use change objects so this is undoable/redoable."
	[definitionPresenter evaluateRange: (1 to: definitionPresenter textLength)
		ifFail: 
			[definitionPresenter isModified: wasModified.
			^self]] 
			on: Error
			do: 
				[:e | 
				definitionPresenter isModified: wasModified.
				e okCancel]!

saveNewMethod: aString
	"Private - Save the specified text as the method source of a new method in the current
	category or leave unclassified if no suitable category is selected."

	| method newMethod status |
	method := self method.
	newMethod := method isNil
				ifTrue: 
					[| cat class categories |
					cat := self category.
					categories := (cat notNil and: [cat acceptsAdditions])
								ifTrue: [{cat}]
								ifFalse: [self model defaultMethodCategories].
					class := self classForNewMethod.
					class isNil ifTrue: [^self].
					methodBrowserPresenter
						saveMethod: aString
						in: class
						categories: categories
						package: self packageForNewMethod]
				ifFalse: 
					[newMethod := methodBrowserPresenter
								saveMethod: aString
								in: method methodClass
								categories: method realCategories
								package: method owningPackage].
	"When a method is saved it may no longer match the filter. If this is the case we reselect method
	 causing the filter to be reset, preserving the status model value in case there were any compilation
	 warnings."
	(newMethod notNil and: [self method ~~ newMethod]) ifFalse: [^self].
	status := self statusModel value.
	self method: newMethod.
	self statusModel value: status!

saveStateOn: aWriteStream
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream nextPutAll: '[:aClassBrowser | '.
	self method
		ifNil: 
			[self hasClassSelected
				ifTrue: 
					['aClassBrowser actualClass: <1p>.' expandMacrosWithArguments: {self actualClass} on: aWriteStream.
					aWriteStream cr]]
		ifNotNil: 
			[:method |
			'aClassBrowser method: (<1p> compiledMethodAt: <2p>).'
				expandMacrosWithArguments: {method methodClass. method selector}
				on: aWriteStream.
			aWriteStream cr].
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aClassBrowser.'.
	aWriteStream nextPut: $]!

searchEnvironment
	^classesPresenter searchEnvironment!

searchForClass: aClass 
	self promptToSaveChanges ifFalse: [^self].
	self resetForFoundClass: aClass.
	self actualClass: aClass ifAbsent: [^super searchForClass: aClass]!

searchForMethod: aCompiledMethod 
	self promptToSaveChanges ifFalse: [^self].
	self method: aCompiledMethod ifAbsent: [super searchForMethod: aCompiledMethod]!

selectedClass
	"Private - Answer the class selected in the classes tree (or nil if there is no selection)."

	^classesPresenter selectionOrNil!

selectedMethod
	^methodBrowserPresenter selectedMethod!

selectedMethods
	^methodBrowserPresenter selections!

selectedMethods: aCollection
	methodBrowserPresenter selections: aCollection!

selectionEnvironment
	| env |
	env := self searchEnvironment.
	self actualClass 
		ifNotNil: 
			[:class | 
			| methods |
			methods := self selectedMethods.
			env := methods isEmpty 
						ifFalse: [env forClass: class selectors: (methods collect: [:each | each selector])]
						ifTrue: [classesPresenter selectionEnvironment]].
	^env!

selectMethod: aCompiledMethod 
	"Refine the browser's selection to be browsing the <CompiledMethod> argument."

	"Note that we check to see if aCompiledMethod is a valid method, this
	is because the hidden UndefinedObject>>doIt method may be supplied
	or some other problem with the method may have ensued. There is a chance
	this may hide some problems so beware."

	| selector class |
	class := aCompiledMethod methodClass.
	selector := aCompiledMethod selector.
	(class includesSelector: selector) 
		ifTrue: [self method: (class compiledMethodAt: selector)]
		ifFalse: [self actualClass: class]!

setInitialFocus
	self hasMethodSelected 
		ifTrue: [methodBrowserPresenter setInitialFocus]
		ifFalse: 
			[self hasClassSelected ifTrue: [classesPresenter setInitialFocus] ifFalse: [super setInitialFocus]]!

setMethodsFilter: aMonadicValuable
	methodBrowserPresenter
		list: (self methodsMatching: aMonadicValuable) asOrderedCollection;
		filter: aMonadicValuable!

setVisitTimer
	self view setTimer: 1 interval: self class historyDwellTime!

shortCaption
	| stream |
	stream := String smalltalkWriteStream: 32.
	self printShortCaptionForClass: self actualClass on: stream.
	self isModified ifTrue: [stream nextPut: $*].
	^stream contents!

slideyPinNames
	^#('filtersSlidey')!

sourceCardName
	^'source'!

statusModel
	^statusModel!

statusText: aString
	self statusModel value: (aString isNil ifFalse: [Notification new messageText: aString])!

toggleFilterObjectMethods
	"Toggle between showing <Object> methods or not"

	(flags := flags mask: FilterObjectMethodsMask set: self isFilterObjectMethods not).
	self onClassSelected!

toggleProtocolReadOnly
	"Toggle the currenty method protocol between read-only and updatable status."

	| prot |
	prot := self protocols first.
	prot isReadOnly: prot isReadOnly not!

toggleShowInheritedMethods
	"Toggle between showing inherited methods or not"

	(flags := flags mask: ShowInheritedMethodsMask set: self isShowInheritedMethods not).
	self onClassSelected!

updateCaption
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	| stream |
	stream := String smalltalkWriteStream: 64.
	self method
		ifNotNil: [:method | self printCaptionForMethod: method on: stream]
		ifNil: 
			[self actualClass
				ifNil: [stream display: self class]
				ifNotNil: [:class | self printCaptionForClass: class on: stream]].
	self isModified ifTrue: [stream nextPut: $*].
	self caption: stream contents!

updateCategories
	"Private - Update the tree of method categories, attempting to maintain
	the current selection."

	| class |
	class := self actualClass.
	class isNil
		ifTrue: [categoriesPresenter model clear]
		ifFalse: 
			[| last allCategory |
			last := self category.
			"Set up the category tree for the class"
			categoriesPresenter model list: self actualClassChainCategories asOrderedCollection.
			allCategory := self allCategory.
			categoriesPresenter expand: allCategory.
			(last isNil or: [(categoriesPresenter selection: last ifAbsent: []) ~= last])
				ifTrue: [categoriesPresenter selection: allCategory]]!

updateClass: aspectString presenter: aSmalltalkWorkspace source: sourceString
	| class event |
	class := self actualClass.
	event := (SelectionChangingEvent forSource: self)
				oldSelection: class;
				newSelection: class;
				yourself.
	(aSmalltalkWorkspace prompt: aspectString toSaveChanges: event)
		ifTrue: [aSmalltalkWorkspace text: sourceString]!

updateFilters
	"Private - Update the various filter lists displayed in the middle pane of the
	browser."

	self updateCategories; updateProtocols; updateVariables
!

updateMethodsInCategory
	"Private - Set the methods of the receivers methodBrowserPresenter so it
	only shows methods of the selected class and any selected categories."

	self setMethodsFilter: self categoriesFilter!

updateMethodsInProtocol
	"Private - Set the methods of the receivers methodBrowserPresenter so it
	only shows methods of the selected class and any selected protocols."

	| filter |
	filter := self protocols isEmpty 
				ifTrue: [self classMethodFilter]
				ifFalse: [self protocolsMethodFilter].
	self setMethodsFilter: filter!

updateMethodsReferencingVariables
	"Private - Set the methods of the receivers methodBrowserPresenter so it
	only shows methods of the selected class which reference any of the 
	selected instance variables."

	self setMethodsFilter: self variablesFilter!

updatePackage
	"Private - Update the currently displayed package to reflect the package which owns
	either the current method or class."

	| package |
	self hasMethodSelected ifTrue: [package := self method owningPackage].
	(package isNil and: [self hasClassSelected]) ifTrue: [
		package := self selectedClass owningPackage].
	packageModel value: package.
!

updateProtocols
	"Private - Update the list of protocols implemented by the class, attempting to maintain
	the current selection."

	| class |
	protocolsPresenter hasView ifFalse: [^self].
	(class := self actualClass) isNil
		ifTrue: [protocolsPresenter clear]
		ifFalse: [ | last |
			last := self protocols.
			protocolsPresenter model list: (class allProtocols asSortedCollection: [:a :b | a name < b name]).
			"If there was previously no selection, then the list view won't issue a selection change
			 event, so we must forcibly refresh the methods list"
			last isEmpty
				ifTrue: [self onProtocolSelected]
				ifFalse: [protocolsPresenter selections: last ifAbsent: []]]!

updateSourceEnablement
	methodBrowserPresenter enableSource: self canSaveMethod!

updateVariables
	"Private - Update the list of instance variables in this class and its superclasses."

	| class |
	variablesPresenter hasView ifFalse: [^self].
	(class := self actualClass) isNil 
		ifTrue: [variablesPresenter clear]
		ifFalse: 
			["Construct a list associating each class with each of its instance variables"
			| vars |
			vars := OrderedCollection new: 20.
			class withAllSuperclasses 
				reverseDo: [:eachClass | eachClass instVarNames do: [:eachInstVar | vars addLast: eachClass -> eachInstVar]].
			variablesPresenter model list = vars 
				ifFalse: 
					[| selectedVars |
					selectedVars := variablesPresenter selections.
					variablesPresenter model list: vars.
					selectedVars := selectedVars intersection: vars.
					selectedVars notEmpty 
						ifTrue: 
							[variablesPresenter selections: selectedVars.
							^self]].
			"If there will be no selection, or the variables list has not changed, then
			the list view won't issue a selection change event, so we must forcibly
			refresh the methods list"
			self onVariableSelected]!

validateProtocol: targetProtocol renameTo: newName
	"Private - Warn that renaming a protocol is not wise, especially if it already has conforming
	classes."

	| otherClasses msg |
	msg := String writeStream.
	(Object methodProtocolClass exists: newName)
		ifTrue: 
			[msg
				nextPutAll: 'You cannot rename ';
				display: targetProtocol;
				nextPutAll: ' to ';
				print: newName;
				nextPutAll: ' because a protocol with that name already exists'.
			MessageBox errorMsg: msg contents.
			^false].
	otherClasses := targetProtocol baseBehaviors
				remove: self actualClass ifAbsent: [];
				yourself.
	otherClasses isEmpty
		ifTrue: 
			[msg
				nextPutAll: 'The protocol ';
				display: targetProtocol;
				nextPutAll: ' is not currently implemented by any other class hierarchies.';
				cr;
				nextPutAll: 'Even so are you sure that you would like to rename it to ';
				print: newName;
				nextPut: $?]
		ifFalse: 
			[msg
				nextPutAll: 'The protocol ';
				display: targetProtocol;
				nextPutAll: ' is also implemented by unrelated or superclass hierarchies';
				cr;
				nextPutAll: 'with the following roots:';
				cr.
			otherClasses asSortedCollection do: 
					[:c |
					msg
						crtab;
						display: c].
			msg
				cr;
				cr;
				nextPutAll: 'If this protocol is renamed these classes or their clients may be adversely affected.';
				cr;
				nextPutAll: 'Are you sure that you would like to proceed (not recommended)?'].
	^MessageBox new
		defaultButton: 2;
		caption: 'Renaming protocol ' , targetProtocol displayString;
		confirm: msg contents!

variables
	"Private - Answer a <collection> of all the instance variables names
	which are currently selected."

	^variablesPresenter hasView 
		ifTrue: [variablesPresenter selections]
		ifFalse: [#()]!

variablesFilter
	^self variables isEmpty 
		ifTrue: [self classMethodFilter]
		ifFalse: [self variablesMethodFilter]!

variablesIndices
	"Private - Answer an <Array> of indices of the selected instance variable"

	| varNames |
	varNames := self actualClass allInstVarNames.
	^self variables collect: [:iv | varNames indexOf: iv value].
!

variablesMethodFilter
	"Private - Answer a <monadicValuable> that, when passed a <CompiledMethod>, answers true if the
	method should be displayed in the receiver by warrant of the variable that is selected"

	| indices |
	indices := self variablesIndices.
	^[:m | (self isMethodVisible: m) and: [m byteCodeDispatcher accessesInstVarAtAnyOf: indices]]! !
!Tools.ClassBrowserAbstract categoriesFor: #accept!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #acceptItCommand!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #actualClass!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #actualClass:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #actualClass:ifAbsent:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #actualClassChain!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #actualClassChainCategories!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #actualClassChainMethods!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #addCategoriesOfMethod:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #addMethod:toCategory:!operations!private! !
!Tools.ClassBrowserAbstract categoriesFor: #addMethodCategory!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #addMethodProtocol!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #addProtocol:to:!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #addToCommandRoute:!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #allCategoriesOfMethod:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #allCategory!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #applyOptions!operations!options!private! !
!Tools.ClassBrowserAbstract categoriesFor: #browseContainingText!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #browseDefinitionsMatching:in:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #browseHierarchy!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #browseInstVarReferences!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #browseIt!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #browseItCommand!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #browseMessageDefinitionsIn:!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #browseMessageReferencesIn:!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #browseMethodCategory!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #browseMethodsIn:!operations!public! !
!Tools.ClassBrowserAbstract categoriesFor: #browseOverriddenMethod!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #browseReferences!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #browseReferencesMatching:in:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #browserEnvironment!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #browseSelectorsInProtocol!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #browseSystem!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #buildHistoryFutureMenu!helpers!menus!private! !
!Tools.ClassBrowserAbstract categoriesFor: #buildHistoryMenu:command:!helpers!menus!private! !
!Tools.ClassBrowserAbstract categoriesFor: #buildHistoryPastMenu!helpers!menus!private! !
!Tools.ClassBrowserAbstract categoriesFor: #buildPopupForCommand:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #canSaveMethod!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #canSaveState!private!saved state! !
!Tools.ClassBrowserAbstract categoriesFor: #cardsPresenter!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #categories!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #categoriesEnvironment!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #categoriesFilter!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #categoriesMethodFilter!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #category!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #classDefinition!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #classForNewMethod!operations!private! !
!Tools.ClassBrowserAbstract categoriesFor: #classMethodFilter!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #clearSelection!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #createAccessors!commands!private!refactoring! !
!Tools.ClassBrowserAbstract categoriesFor: #createComponents!initializing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #createPlugins!initializing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #currentCard!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #customDrawCategoryTree:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #customDrawProtocols:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #customDrawSelector:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #definitionCardName!constants!private! !
!Tools.ClassBrowserAbstract categoriesFor: #deleteItCommand!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #dropMethods:onto:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #emphasiseCategoryItem:isRelevant:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #emphasiseProtocolItem:isRelevant:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #ensureDefinitionVisible!operations!private! !
!Tools.ClassBrowserAbstract categoriesFor: #ensureSourceVisible!operations!private! !
!Tools.ClassBrowserAbstract categoriesFor: #hasClassSelected!public!refactoring!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #hasEditableMethodSelected!public!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #hasEditableMethodsSelected!public!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #hasFuture!public!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #hasMethodSelected!public!refactoring!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #hasPast!public!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #hierarchyOfCategory:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #historyClear!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #historySkip:!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #initialize!initializing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #inspectCollection:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #inspectInstanceVariables!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #inspectIt!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #inspectItCommand!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #inspectMethodCategories!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #inspectMethodProtocols!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #isDefinitionCardVisible!private!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #isDisplayingCategories!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #isDisplayingProtocols!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #isDisplayingVariables!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #isEditableMethod:!modes!public! !
!Tools.ClassBrowserAbstract categoriesFor: #isFilterObjectMethods!public!refactoring!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #isInheritedMethod:!modes!public! !
!Tools.ClassBrowserAbstract categoriesFor: #isInstanceMode!modes!private! !
!Tools.ClassBrowserAbstract categoriesFor: #isInstanceMode:!modes!private! !
!Tools.ClassBrowserAbstract categoriesFor: #isMethodFiltrate:!private!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #isMethodVisible:!private!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #isModified!public!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #isShowInheritedMethods!public!refactoring!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #isSourceCardVisible!private!testing! !
!Tools.ClassBrowserAbstract categoriesFor: #killVisitTimer!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #loadedPlugins!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #method!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #method:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #method:ifAbsent:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #methodCategories!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #methodCategories:!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #methodProtocols!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #methodProtocols:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #methodsMatching:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #modifiedModel:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #newMethod!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #onBrowserCardChanged!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onCategory:renameTo:accept:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onCategorySelected!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onClassCategorized:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onClassModeChanged!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onClassRepackaged:from:to:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onClassSelected!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onClassSelectionChanging:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onClassUpdated:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onCloseRequested:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDragCategory:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDragMethodsCut:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDragOverCategory:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDragOverMethod:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDragOverMode:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDragProtocol:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDragVariableRefs:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDropOverCategory:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDropOverMethods:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onDropOverMode:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onFilterCardChanged!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onFilterSelectionChanging:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onMethodAdded:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onMethodCategorized:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onMethodListDoubleClicked:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onMethodRemoved:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onMethodRepackaged:from:to:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onMethodSelected!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onModeSelectionChanged!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onPackageDoubleClicked:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onPromptToSaveChanges:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onPromptToSaveClassChanges:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onPromptToSaveMethodChanges:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onProtocolRemoved:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onProtocolSelected!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onProtocolUpdated:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onRenameInstVar:to:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onRenameInstVar:to:accept:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onRenameMethodProtocol:to:accept:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onRepackaged:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onStatusDoubleClicked:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onTimerTick:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onTipTextRequired:!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onVariableSelected!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #onViewOpened!event handling!private! !
!Tools.ClassBrowserAbstract categoriesFor: #packageForNewMethod!operations!private! !
!Tools.ClassBrowserAbstract categoriesFor: #packageNames:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #packages:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #parseContext!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #parseTree!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #printCaptionForClass:on:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #printCaptionForMethod:on:!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #printClassTitle:on:!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #printShortCaptionForClass:on:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #promptToCopyChanges!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #promptToSaveChanges!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #protocols!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #protocols:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #protocolsMethodFilter!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #queryCommand:!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #recordMethodVisit!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #reformatAll!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #removeMethod:fromCategory:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #removeMethod:fromProtocol:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #removeMethodCategory!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #removeMethodProtocol!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #removeMethodsInCategory!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #removeMethodsInProtocol!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #removePlugin:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #renameInstanceVariable!commands!private!refactoring! !
!Tools.ClassBrowserAbstract categoriesFor: #renameIt!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #renameItCommand!constants!private! !
!Tools.ClassBrowserAbstract categoriesFor: #renameMethodCategory!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #renameMethodCategory:to:!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #renameMethodCategoryInPlace!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #renameMethodProtocol!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #resetFor:!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #resetForFoundClass:!commands!private! !
!Tools.ClassBrowserAbstract categoriesFor: #saveDefinition!operations!private! !
!Tools.ClassBrowserAbstract categoriesFor: #saveNewMethod:!operations!private! !
!Tools.ClassBrowserAbstract categoriesFor: #saveStateOn:!private!saved state! !
!Tools.ClassBrowserAbstract categoriesFor: #searchEnvironment!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #searchForClass:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #searchForMethod:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #selectedClass!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #selectedMethod!public! !
!Tools.ClassBrowserAbstract categoriesFor: #selectedMethods!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #selectedMethods:!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #selectionEnvironment!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #selectMethod:!browsing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #setInitialFocus!operations!public! !
!Tools.ClassBrowserAbstract categoriesFor: #setMethodsFilter:!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #setVisitTimer!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #shortCaption!accessing!public! !
!Tools.ClassBrowserAbstract categoriesFor: #slideyPinNames!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #sourceCardName!constants!private! !
!Tools.ClassBrowserAbstract categoriesFor: #statusModel!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #statusText:!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #toggleFilterObjectMethods!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #toggleProtocolReadOnly!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #toggleShowInheritedMethods!commands!public! !
!Tools.ClassBrowserAbstract categoriesFor: #updateCaption!public!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #updateCategories!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #updateClass:presenter:source:!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #updateFilters!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #updateMethodsInCategory!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #updateMethodsInProtocol!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #updateMethodsReferencingVariables!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #updatePackage!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #updateProtocols!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #updateSourceEnablement!helpers!private! !
!Tools.ClassBrowserAbstract categoriesFor: #updateVariables!private!updating! !
!Tools.ClassBrowserAbstract categoriesFor: #validateProtocol:renameTo:!operations!private! !
!Tools.ClassBrowserAbstract categoriesFor: #variables!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #variablesFilter!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #variablesIndices!accessing!private! !
!Tools.ClassBrowserAbstract categoriesFor: #variablesMethodFilter!accessing!private! !

Tools.ClassBrowserAbstract methodProtocol: #methodBrowserHost attributes: #(#readOnly) selectors: #(#hasEditableMethodSelected #isEditableMethod: #parseContext #saveNewMethod:)!

!Tools.ClassBrowserAbstract class methodsFor!

addPlugin: aClassBrowserPlugin 
	^self plugins add: aClassBrowserPlugin!

availablePluginClasses
	"Private - Answers a  collection of plugin classes to choose from"

	^(ClassCategory name: 'Browser-Plugins') classes!

classCommentIcon
	"Private - Answer the <Icon> to use for the class comment tab"

	^Icon fromId: 'ClassComment.ico'!

defaultAdditionalAccelerators
	| accels |
	accels := super defaultAdditionalAccelerators , #(#(#renameIt 'F2')).
	Smalltalk developmentSystem canRefactor
		ifTrue: [accels := accels , #(#(#pushUpMethods 'Shift+Ctrl+6') #(#pushDownMethods 'Shift+Ctrl+7'))].
	^accels!

defaultFilterObjectMethods
	"Answer true if instances of the receiver filter out <Object> methods by default."

	^defaultFilterObjectMethods!

defaultFilterObjectMethods: aBoolean 
	"Sets the default showing of filtering out of <Object> methods for instances of the receiver to aBoolean."

	defaultFilterObjectMethods := aBoolean!

defaultPluginsCollection
	"Private - Answers a  collection of plugin classes to choose from"

	| answer |
	answer := OrderedCollection new.
	#(#{ClassCommentPlugin} #{ClassDiagramPlugin} #{ResourceListPlugin} #{CodeMentorPlugin} #{CodeRewriterPlugin} #{UnitTestPlugin})
		do: [:each | each ifDefined: [:class | answer add: class]].
	^answer!

defaultShowInheritedMethods
	"Answer true if instances of the receiver show inherited methods by default."

	^defaultShowInheritedMethods!

defaultShowInheritedMethods: aBoolean 
	"Sets the default showing of inherited methods for instances of the receiver to aBoolean."

	defaultShowInheritedMethods := aBoolean!

grayedMethodFadeFactor
	^GrayedMethodFadeFactor!

grayedMethodFadeFactor: aNumber
	GrayedMethodFadeFactor := aNumber!

historyListSize
	^HistoryListSize ifNil: [self defaultHistoryListSize]!

historyListSize: anInteger 
	HistoryListSize := anInteger!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	self looseMethodColor: Color purple.
	self grayedMethodFadeFactor: 2.
	self historyListSize: nil.
	self historyDwellTime: nil.
	self wordWrapDefinition: true.
!

looseMethodColor
	"Answer the <Color> used to highlight loose methods."

	^LooseMethodColor!

looseMethodColor: aColor
	"Set the <Color> used to highlight loose methods."

	LooseMethodColor := aColor!

plugins
	"Answer the plugins installed by instances of the receiver"

	plugins isNil ifTrue: [self plugins: self defaultPluginsCollection].
	^OS.SystemMetrics current hasInternetExplorerControl
		ifTrue: [plugins]
		ifFalse: 
			["The CodeMentor plugin relies on the Internet Explorer control>"
			plugins reject: [:each | each name == #CodeMentorPlugin]]!

plugins: anOrderedCollection 
	"Sets the plugins installed by instances of the receiver"

	plugins := anOrderedCollection!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		add: (Aspect boolean: #wordWrapSource);
		add: (Aspect boolean: #wordWrapDefinition);
		add: (Aspect boolean: #defaultShowInheritedMethods);
		add: (Aspect boolean: #defaultFilterObjectMethods);
		add: ((Aspect color: #looseMethodColor)
					isNullable: false;
					yourself);
		add: ((Aspect integer: #grayedMethodFadeFactor)
					isNullable: false;
					yourself);
		add: ((Aspect sequenceableCollection: #plugins addFrom: self availablePluginClasses)
					beMutable;
					isNullable: true;
					yourself);
		add: (Aspect integer: #historyListSize);
		yourself!

removePlugin: aClassBrowserPlugin 
	^self plugins remove: aClassBrowserPlugin ifAbsent: []!

wordWrapDefinition
	"Answer true if instances of the receiver use definition word wrapping."

	^WordWrapDefinition!

wordWrapDefinition: aBoolean
	"Sets the definition word wrapping state for instances of the receiver to aBoolean."

	WordWrapDefinition := aBoolean!

wordWrapSource
	"Answer true if instances of the receiver use source word wrapping."

	^MethodBrowser wordWrap!

wordWrapSource: aBoolean
	"Sets the source word wrapping state for instances of the receiver to aBoolean."

	MethodBrowser wordWrap: aBoolean! !
!Tools.ClassBrowserAbstract class categoriesFor: #addPlugin:!initializing!private! !
!Tools.ClassBrowserAbstract class categoriesFor: #availablePluginClasses!helpers!private! !
!Tools.ClassBrowserAbstract class categoriesFor: #classCommentIcon!helpers!private! !
!Tools.ClassBrowserAbstract class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.ClassBrowserAbstract class categoriesFor: #defaultFilterObjectMethods!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #defaultFilterObjectMethods:!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #defaultPluginsCollection!helpers!private! !
!Tools.ClassBrowserAbstract class categoriesFor: #defaultShowInheritedMethods!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #defaultShowInheritedMethods:!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #grayedMethodFadeFactor!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #grayedMethodFadeFactor:!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #historyListSize!accessing!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #historyListSize:!accessing!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #initialize!initializing!private! !
!Tools.ClassBrowserAbstract class categoriesFor: #looseMethodColor!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #looseMethodColor:!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #plugins!accessing!public!wine fix! !
!Tools.ClassBrowserAbstract class categoriesFor: #plugins:!accessing!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #publishedAspects!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #removePlugin:!initializing!private! !
!Tools.ClassBrowserAbstract class categoriesFor: #wordWrapDefinition!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #wordWrapDefinition:!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #wordWrapSource!accessing!options!public! !
!Tools.ClassBrowserAbstract class categoriesFor: #wordWrapSource:!accessing!options!public! !

