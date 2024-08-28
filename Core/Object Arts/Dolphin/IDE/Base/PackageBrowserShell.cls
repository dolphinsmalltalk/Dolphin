"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #PackageBrowserShell
	instanceVariableNames: 'packagesPresenter classesPresenter methodsPresenter methodRefactoringTool globalsPresenter resourcesPresenter currentCard commentPresenter cardsPresenter updateFlags scriptTextPresenter scriptNamesPresenter prerequisitesPresenter dependentsPresenter statusModel versionModel'
	classVariableNames: 'UpdateMap WordWrapComment'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

PackageBrowserShell guid: (GUID fromString: '{87b4c6c0-026e-11d3-9fd7-00a0cc3e4a32}')!

PackageBrowserShell comment: 'PackageBrowserShell is a <SmalltalkToolShell> that implements the Package Browser tool. This provides a user interface onto all the <Package>s held by the current <PackageManager>. 

Instance Variables:
	packagesPresenter		<ListPresenter> holding the list of currently loaded packages.
	classesPresenter		<ListPresenter> displaying the list of classes in the selected package.
	methodsPresenter		<ListPresenter> displaying the list of explicit methods in the selected package.
	globalsPresenter		<ListPresenter> displaying the list of globals in the selected package.
	resourcesPresenter		<ResourceListPresenter> displaying the list of resources in the selected package.
	scriptsPresenter		<ListPresenter> displaying a list of scripts for the selector package.
	sourceMode		<Symbol> indicating the current source mode, #class, #method, #global, #resource, #script.
	sourcePresenter		<SmalltalkWorkspace> displaying the source for the currently selected package object.
	commentPresenter		<SmalltalkWorkspace> displaying the package comment.
	inspectorPresenter		<PublishedAspectInspector> inspecting the selected package.
	cardPresenter		<CardContainer>. Package content cards.
	updatedFlags		<integer>. Flags indicating which of the source panes have been updated.
	namePresenter		<TextPresenter> displaying package name.
	pathPresenter		<TextPresenter> displaying package path.

Class Variables:
	OperationAborted 		<Signal> raised when a long running operation (e.g install/uninstall) is aborted by the user.
	UpdateMap 
	WordWrapComment		<boolean> indicating that the comment pane should word wrap.
'!

!PackageBrowserShell categoriesForClass!MVP-Presenters! !

!PackageBrowserShell methodsFor!

accept
	"Accept the changes to any of the panes in the receiver"

	currentCard = #comment ifTrue: [^self saveComment].
	currentCard = #scripts ifTrue: [currentCard == #scripts ifTrue: [^self saveScript]].
	Sound errorBeep!

addToCommandRoute: route 
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer self to have the command policy decide where to
	go next."

	"Implementation Note: We want to make sure that the packages presenter is always in the
	route, and that it appears before SmalltalkSystem but after the receiver (if not already in
	the route)."

	methodRefactoringTool notNil ifTrue: [route appendTarget: methodRefactoringTool].
	route
		appendTarget: self;
		appendTarget: packagesPresenter;
		appendPresenter: self!

applyOptions
	"Private - Apply the class options to the receiver"

	super applyOptions.
	commentPresenter view wordWrap: self class wordWrapComment.!

browseClass
	"Open a new class browser on the selected class(es). If a single class is selected, then the
	default class browser is opened with initial selection set to that class. If more than one
	class is selected then an <EnvironmentBrowserShell> is opened and configured to display
	those classes."

	| classes |
	classes := self selectedClasses.
	^classes size = 1 
		ifTrue: [classes anyOne browse]
		ifFalse: 
			[| env environmentBrowserClass |
			env := Smalltalk developmentSystem browserEnvironmentForClasses: classes.
			environmentBrowserClass := Smalltalk at: #EnvironmentBrowserShell
						ifAbsent: 
							[^MessageBox notify: 'This feature is only available in the Professional edition'
								caption: 'Cannot browse multiple classes'].
			^(environmentBrowserClass show)
				browserEnvironment: env;
				yourself]!

browseClassReferences
	"Browse all the methods in the entire system which refer to the class selected in the
	receiver."

	self browseClassReferencesIn: self systemModel systemEnvironment!

browseClassReferencesIn: aBrowserEnvironment 
	#todo.	"Make this work for multiple class selections"
	self model browseClassReferences: self selectedClass in: aBrowserEnvironment!

browseDefinitions
	^self browseMessageDefinitions!

browseGlobalReferences
	"Browse all the methods which refer to the global selected in
	the receiver."

	self model browseGlobalReferences: self global in: self systemModel systemEnvironment!

browseHierarchy
	"Private - Open a hierarchy browser on the currently selected class or method."

	(self selectedMethod notNil and: [currentCard = #methods]) 
		ifTrue: [^self systemModel browseClassHierarchyOfMethod: self selectedMethod].
	(self selectedClass notNil and: [currentCard = #classes]) 
		ifTrue: [^self systemModel browseHierarchy: self selectedClass].
	self systemModel browseHierarchy!

browseIt
	"Open a default browser on the currently selected class or method."

	self perform: self browseItCommand!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	| focus |
	focus := View focus.
	focus == packagesPresenter packagesPresenter view ifTrue: [^#browsePackages].
	focus == classesPresenter view ifTrue: [^#browseClass].
	focus == methodsPresenter view ifTrue: [^#browseMethods].
	"focus == globalsPresenter view ifTrue: [^#browseGlobals]."
	^nil!

browseLocalClassReferences
	"Browse all the methods in the currently selected set of packages system which refer to the
	class selected in the receiver."

	self browseClassReferencesIn: self searchEnvironment!

browseLocalMessageDefinitions
	"Open a method browser displaying all implementors of the current selector in the currently
	selected packages."

	self browseMessageDefinitionsIn: self searchEnvironment!

browseLocalMessageReferences
	"Open a method browser displaying all references to the current selector in the currently
	selected packages."

	self browseMessageReferencesIn: self searchEnvironment!

browseLooseMethods: aCollection 
	| env packageEnv |
	packageEnv := packagesPresenter selectionEnvironment.
	env := packageEnv forMethods: aCollection.
	env label: 'Loose methods from package(s): ' , packageEnv printString.
	self model browseMethodsIn: env!

browseMessageDefinitions
	"Open a method browser displaying all implementors of the current selector in the entire
	system."

	self browseMessageDefinitionsIn: self systemModel systemEnvironment!

browseMessageDefinitionsIn: aBrowserEnvironment 
	self selectedMethod 
		ifNil: [self model browseMessageDefinitionsIn: aBrowserEnvironment]
		ifNotNil: [:method | self model browseDefinitionsOfSelector: method selector in: aBrowserEnvironment]!

browseMessageReferences
	"Open a method browser displaying all references to the current selector in the entire system."

	self browseMessageReferencesIn: self systemModel systemEnvironment!

browseMessageReferencesIn: aBrowserEnvironment 
	self selectedMethod 
		ifNil: [self model browseMessageReferencesIn: aBrowserEnvironment]
		ifNotNil: [:method | self model browseReferencesToLiteral: method selector in: aBrowserEnvironment]!

browseMethodClass
	"Open a default browser on the currently selected method."

	^self selectedMethod browse!

browseMethods
	"Open a default browser on the currently selected method or methods."

	| methods |
	methods := self selectedMethods.
	methods size == 1 ifTrue: [self browseMethodClass] ifFalse: [self browseLooseMethods: methods]!

browsePackages
	^packagesPresenter browsePackageSources!

browseReferences
	(self selectedMethod notNil and: [currentCard = #methods]) ifTrue: [^self browseMessageReferences].
	(self selectedClass notNil and: [currentCard = #classes]) ifTrue: [^self browseClassReferences].
	(self global notNil and: [currentCard = #globals]) ifTrue: [^self browseGlobalReferences].
	Sound warningBeep!

browseSystem
	"Open a system browser on the currently selected class or method,
	and with the same package selection."

	| pkgs method class browser |
	pkgs := self packages.
	pkgs isEmpty ifTrue: [^super browseSystem].
	browser := self systemModel browseSystemPackages: pkgs.
	browser isNil ifTrue: [^nil].
	(currentCard = #methods and: [(method := self selectedMethod) notNil]) 
		ifTrue: [browser selectMethod: method].
	(currentCard = #classes and: [(class := self selectedClass) notNil]) 
		ifTrue: [browser actualClass: class].
	^browser!

buildPopupForCommand: aSymbol
	"Private - Dynamically build an appropriate popup menu for aSymbol command."

	aSymbol == #viewModeSelect
		ifTrue: 
			[| focus |
			"Dolphin 8 integrates the population of pop-up menus with a new declarative command querying mechanism, and there is no need for any of this horribleness, but in D7 we'll live with the type switch"
			focus := View focus.
			^(focus isKindOf: IconicListAbstract) ifTrue: [focus buildViewsPopup] ifFalse: [Menu new]].
	^super buildPopupForCommand: aSymbol!

cacheCurrentCard
	currentCard := cardsPresenter currentCard name asSymbol!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

clearCard: aSymbol
	self perform: (UpdateMap at: aSymbol) third!

clearClasses
	"Private - Clear the classes list."

	classesPresenter clear!

clearComment
	"Private - Clear down the comment presenter"

	commentPresenter clear!

clearDependents
	"Private - Clear the dependents tree."

	dependentsPresenter clear!

clearGlobals
	"Private - Clear the Globals list."

	globalsPresenter clear!

clearMethods
	"Private - Clear the methods list."

	methodsPresenter clear!

clearPrerequisites
	"Private - Clear the prerequisites list."

	prerequisitesPresenter clear!

clearResources
	"Private - Clear the resources list."

	resourcesPresenter clear!

clearScriptNames
	"Private - Clear the scripts list."

	scriptNamesPresenter clear.
	self onScriptSelected!

createComponents
	"Private - Create the presenters contained by the receiver"

	| workspaceClass |
	super createComponents.
	packagesPresenter := self 
				add: PackageSelector new
				name: 'packages'
				helpId: 10755.
	classesPresenter := (self 
				add: ListPresenter new
				name: 'classes'
				helpId: 10811) beSorted.
	methodsPresenter := self 
				add: (ListPresenter on: ListModel new)
				name: 'methods'
				helpId: 10812.
	methodsPresenter beSorted: [:x :y | x selector <= y selector].
	methodRefactoringTool := self systemModel newMethodRefactoringToolFor: self.
	globalsPresenter := (self 
				add: ListPresenter new
				name: 'globals'
				helpId: 10814) beSorted.
	resourcesPresenter := self 
				add: ResourceListPresenter new
				name: 'resources'
				helpId: 10813.
	scriptNamesPresenter := self 
				add: ListPresenter new
				name: 'scriptNames'
				helpId: 10815.
	workspaceClass := self workspaceClass.
	commentPresenter := self 
				add: ((workspaceClass new)
						textStyles: ClassCommentPlugin textStyles;
						yourself)
				name: 'comment'
				helpId: 10808.
	scriptTextPresenter := self 
				add: workspaceClass new
				name: 'scriptText'
				helpId: 10815.
	prerequisitesPresenter := self 
				add: PackagePrerequisites new
				name: 'prerequisites'
				helpId: 10816.
	dependentsPresenter := self 
				add: PackageDependents new
				name: 'dependents'
				helpId: 10817!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self.
	"We don't listen for #classAdded: events, as we pick up the addition of new classes to
	 a package through the PackageManager's #classRepackaged:from:to: event"
	(self model)
		when: #classRemoved:
			send: #onClassRemoved:
			to: self;
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodUpdated:
			send: #onMethodUpdated:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self;
		when: #globalRemoved:
			send: #onGlobalRemoved:
			to: self;
		when: #globalRenamed:from:
			send: #onGlobalRenamed:from:
			to: self.
	"Note that as we are using the ResourceListPresenter, which keeps in sync. by itself,
	 we don't need (or want) to hook any resource related events"
	(self packageManager)
		when: #classRepackaged:from:to:
			send: #onClassRepackaged:from:to:
			to: self;
		when: #methodRepackaged:from:to:
			send: #onMethodRepackaged:from:to:
			to: self;
		when: #globalRepackaged:from:to:
			send: #onGlobalRepackaged:from:to:
			to: self;
		when: #packageChanged:
			send: #onPackageChanged:
			to: self.
	packagesPresenter 
		when: #selectionChanging:
			send: #onPackageSelectionChanging:
			to: self;
		when: #selectionChanged
		send: #onPackageSelected
		to: self.
	classesPresenter
		when: #actionPerformed
			send: #browseClass
			to: self;
		when: #drag:
			send: #onDragClasses:
			to: self;
		when: #drop:
			send: #onDropOverPackage:
			to: self;
		when: #dragEnter:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #Class);
		when: #dragOver:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #Class).
	methodsPresenter
		when: #actionPerformed
			send: #browseIt
			to: self;
		when: #drag:
			send: #onDragMethods:
			to: self;
		when: #drop:
			send: #onDropOverPackage:
			to: self;
		when: #dragEnter:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #CompiledMethod);
		when: #dragOver:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #CompiledMethod);
		when: #selectionChanged
			send: #onMethodSelected
			to: self.
	globalsPresenter
		when: #actionPerformed
			send: #inspectGlobals
			to: self;
		when: #drag:
			send: #onDragGlobal:
			to: self;
		when: #drop:
			send: #onDropOverPackage:
			to: self;
		when: #dragEnter:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #GlobalSymbol);
		when: #dragOver:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #GlobalSymbol).
	resourcesPresenter
		when: #drag:
			send: #onDragResource:
			to: self;
		when: #drop:
			send: #onDropOverPackage:
			to: self;
		when: #dragEnter:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #ResourceIdentifier);
		when: #dragOver:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #ResourceIdentifier).
	scriptNamesPresenter 
		when: #selectionChanged
		send: #onScriptSelected
		to: self!

customDrawClassList: anNMLVCUSTOMDRAW
	"Private - Custom drawing to implement the emphasis in the classes list tree."

	| class |
	class := anNMLVCUSTOMDRAW subItem.
	class isDeprecated ifTrue: [anNMLVCUSTOMDRAW font isStruckThrough: true].
	class isNonInstantiable ifTrue: [anNMLVCUSTOMDRAW font isItalic: true]!

defaultHelpId
	^10807!

global
	| globals |
	globals := self globals.
	^globals size = 1 ifTrue: [globals first]!

globalNames
	^globalsPresenter selections!

globals
	^self globalNames collect: [:each | self class environment associationAt: each]!

hasClassSelected
	"Answer true if the receiver has a single (i.e. not multiple) class selected"

	^self selectedClass notNil!

hasEditableMethodSelected
	^self selectedMethod notNil!

hasEditableMethodsSelected
	^self selectedMethods notEmpty!

hasMethodSelected
	"Answer true if the receiver has a single (i.e. not multiple) method selected"

	^self selectedMethod notNil!

hasPackages
	"Private - Answer whether one or more packages are currently selected."

	^self packages notEmpty!

hasPackageSelected
	"Answer true if the receiver has a single (i.e. not multiple) package selected"

	^self singlePackage notNil!

initialize
	"Private - Initialize the state of the receiver"

	super initialize.
	updateFlags := 0.
	self caption: 'Package Browser'.
	statusModel := versionModel := ValueHolder new.
!

inspectClasses
	"Open an inspector on the currently selected classes."

	self inspectCollection: self selectedClasses!

inspectCollection: aCollection
	(aCollection size = 1 ifTrue: [aCollection first] ifFalse: [aCollection]) inspect!

inspectGlobals
	"Open an inspector on the currently selected globals."

	self inspectCollection: self globals!

inspectIt
	"Open a browser on the selected category/protocol/variables.
	Note that we only receive this command it one of the filter panes is selected
	as class hierarchy, method browser, and workspace presenters all handle
	it themselves."

	self perform: self inspectItCommand!

inspectItCommand
	"Private - Answer the command that the context-sensitive 'Inspect-It' command would be linked
	to if sent to the receiver at this moment."

	| focus |
	focus := View focus.
	focus == packagesPresenter packagesPresenter view ifTrue: [^#inspectPackages].
	focus == classesPresenter view ifTrue: [^#inspectClasses].
	focus == methodsPresenter view ifTrue: [^#inspectMethods].
	focus == globalsPresenter view ifTrue: [^#inspectGlobals].
	focus == resourcesPresenter view ifTrue: [^#inspectResources].
	^nil.!

inspectMethods
	"Open an inspector on the currently selected methods."

	self inspectCollection: self selectedMethods!

inspectResources
	"Open an inspector on the currently selected resources."

	self inspectCollection: self resourceIdentifiers!

isCardUpToDate: aSymbol
	^updateFlags allMask: (UpdateMap at: aSymbol) first!

markCardDirty: aSymbol
	| updateInfo |
	updateInfo := UpdateMap at: aSymbol.
	updateFlags := updateFlags maskClear: updateInfo first.
	self perform: updateInfo third!

objectRepackaged: anObject from: oldPackage to: newPackage card: cardSymbol list: aListModel
	| packages displayingNewPackage |
	currentCard == cardSymbol ifFalse: [^self markCardDirty: cardSymbol].
	packages := self packages.
	displayingNewPackage := packages includes: newPackage.
	(packages includes: oldPackage) 
		ifTrue: 
			[displayingNewPackage 
				ifTrue: [aListModel refresh: anObject]
				ifFalse: [aListModel remove: anObject]]
		ifFalse: [displayingNewPackage ifTrue: [aListModel add: anObject]]!

onCardChanged
	"Private - The source object card has been changed. Update the source pane
	accordingly."

	self cacheCurrentCard.
	(self isCardUpToDate: currentCard) ifFalse: [self updateCardNow: currentCard].
	currentCard == #methods ifFalse: [versionModel value: nil]!

onClassRemoved: aClass
	"Private - The <Behavior>, aClass, has been deleted. Update the receiver's
	cards as necessary to reflect the classes removal."

	currentCard == #classes 
		ifTrue: [classesPresenter model remove: aClass ifAbsent: []]
		ifFalse: [self markCardDirty: #classes].
	currentCard == #methods 
		ifTrue: 
			[(methodsPresenter list select: [:each | each methodClass == aClass]) 
				do: [:each | methodsPresenter model remove: each]]
		ifFalse: [self markCardDirty: #methods]!

onClassRepackaged: aClass from: oldPackage to: newPackage
	"The class, aClass, has been repackaged, moving it from the <Package> or nil, oldPackage
	to the <Package>, or nil, newPackage. Note that we only bother attempting any
	kind of update if the classes card is actually displayed. If not we just mark the classes
	card as dirty to reduce overhead."

	self
		objectRepackaged: aClass
		from: oldPackage
		to: newPackage
		card: #classes
		list: classesPresenter model.
	#(#methods #resources) do: [:each | self refreshCard: each]!

onCloseRequested: boolValueHolder
	"Private - A request to close the view onto the receiver as occurred.
	Prompt to save any outstanding changed"

	boolValueHolder value: self promptToSaveChanges!

onDragClasses: session 
	"Private - A drag of one or more classes has been started. Populate the 
	<DragDropSession>, session, with the objects to be dragged."

	| ddObjects |
	ddObjects := self selectedClasses collect: 
					[:e | 
					(session newDragObject: e)
						format: #Class data: e;
						format: #String data: e definition;
						format: #Chunk data: e definitionChunk;
						yourself].
	session dragObjects: ddObjects!

onDragGlobal: aDragDropSession 
	"Private - A Global drag has been started. Populate the <DragDropSession>, 
	session with the objects to be dragged."

	| dragGlobal |
	aDragDropSession dragObjects: nil.
	dragGlobal := aDragDropSession suggestedSource.
	aDragDropSession 
		addDragObject: ((aDragDropSession newDragObject: dragGlobal)
				format: #GlobalSymbol data: dragGlobal;
				yourself).
	aDragDropSession defaultOperation: #copy!

onDragMethods: aDragDropSession 
	"Private - A drag has been started. Drag the currently selected methods."

	self systemModel beginDrag: aDragDropSession methods: self selectedMethods!

onDragOver: session type: format 
	"Private - A drag session is passing over one of the receiver's panes.
	Update the <DragDropSession>, session, with the drop operation supported
	(if any)."

	session operation: nil.
	(session isFormatAvailable: format) 
		ifTrue: 
			[self singlePackage 
				ifNotNil: 
					[:package | 
					session
						suggestedTarget: package;
						operation: #move.
					^true]].
	^false!

onDragResource: aDragDropSession 
	"Private - A drag has been initiated of a resource, populate the <DragDropSession>, session,
	accordingly."

	| resId ddObject |
	resId := aDragDropSession suggestedSource.
	ddObject := aDragDropSession newDragObject: resId resource copy.
	ddObject format: #ResourceIdentifier data: resId.
	aDragDropSession
		dragObjects: (OrderedCollection with: ddObject);
		defaultOperation: #copy!

onDropOverPackage: aDragDropSession 
	"Private - The drag operation described by session would like to do a drop.
	Override this method to accept the dragObject(s)."

	| targetPackage packageManager |
	targetPackage := aDragDropSession suggestedTarget.
	targetPackage isNil 
		ifTrue: 
			[Sound errorBeep.
			^false].
	packageManager := Package manager.
	Cursor wait showWhile: 
			[aDragDropSession dragObjects do: 
					[:each | 
					"See if the drop is a CompiledMethod"
					(each isFormatAvailable: #CompiledMethod) 
						ifTrue: 
							[| method |
							method := each format: #CompiledMethod.
							packageManager addMethod: method to: targetPackage].
					(each isFormatAvailable: #ResourceIdentifier) 
						ifTrue: 
							[| resource |
							resource := each format: #ResourceIdentifier.
							packageManager addResourceIdentifier: resource to: targetPackage].
					(each isFormatAvailable: #GlobalSymbol) 
						ifTrue: 
							[| global |
							global := each format: #GlobalSymbol.
							packageManager addGlobalNamed: global to: targetPackage].
					(each isFormatAvailable: #Class) 
						ifTrue: 
							[| class |
							class := each format: #Class.
							packageManager addClass: class to: targetPackage]]].

	"Operation must never be #move to avoid methods being removed"
	aDragDropSession operation: #copy.
	^true!

onGlobalRemoved: anAssociation
	"Private - The global with the specified binding has been removed from the system.
	The globals pane must be kept up to date."

	currentCard == #globals 
		ifTrue: [globalsPresenter model remove: anAssociation key ifAbsent: []]
		ifFalse: [self markCardDirty: #globals]!

onGlobalRenamed: anAssociation from: aSymbol
	"Private - The global with the specified binding has been renamed, the <Symbol>
	argument being its original name. The globals pane must be kept up to date."

	currentCard == #globals 
		ifTrue: 
			[(globalsPresenter model remove: aSymbol ifAbsent: []) notNil 
				ifTrue: [globalsPresenter model add: anAssociation key]]
		ifFalse: [self markCardDirty: #globals]!

onGlobalRepackaged: aSymbol from: oldPackage to: newPackage
	self 
		objectRepackaged: aSymbol
		from: oldPackage
		to: newPackage
		card: #globals
		list: globalsPresenter model!

onMethodAdded: aCompilationResult
	currentCard == #methods 
		ifTrue: 
			[| method |
			method := aCompilationResult method.
			(method isLoose and: [self packages includes: method owningPackage]) 
				ifTrue: [methodsPresenter model add: method]]
		ifFalse: [self markCardDirty: #methods]!

onMethodRemoved: aCompiledMethod
	currentCard == #methods 
		ifTrue: 
			["By this time, the package's may have been updated, so we may not be able to tell
			 if the method was originally loose, therefore we must just attempt to remove it regardless."

			methodsPresenter model remove: aCompiledMethod ifAbsent: []]
		ifFalse: [self markCardDirty: #methods]!

onMethodRepackaged: aCompiledMethod from: oldPackage to: newPackage 
	| packages displayingNewPackage |
	currentCard == #methods ifFalse: [^self markCardDirty: #methods].
	packages := self packages.
	displayingNewPackage := packages includes: newPackage.
	(packages includes: oldPackage) 
		ifTrue: 
			[| wasLoose |
			wasLoose := methodsPresenter model indexOf: aCompiledMethod.
			(displayingNewPackage and: [aCompiledMethod isLoose]) 
				ifTrue: 
					[wasLoose ~= 0 
						ifTrue: [methodsPresenter model refreshAtIndex: wasLoose]
						ifFalse: [methodsPresenter model add: aCompiledMethod]]
				ifFalse: [wasLoose ~= 0 ifTrue: [methodsPresenter model removeAtIndex: wasLoose]]]
		ifFalse: 
			[(displayingNewPackage and: [aCompiledMethod isLoose]) 
				ifTrue: [methodsPresenter model add: aCompiledMethod]]!

onMethodSelected
	self updateMethodVersion!

onMethodUpdated: aCompilationResult 
	"Private - A method has been updated in the system. Ensure that the methods presenter
	is updated if necessary."

	currentCard == #methods 
		ifTrue: 
			[| method oldMethod |
			method := aCompilationResult method.
			oldMethod := aCompilationResult oldMethod.
			(methodsPresenter list identityIncludes: oldMethod) 
				ifTrue: 
					[| sel |
					sel := self selectedMethods copyReplacing: oldMethod withObject: method.
					(methodsPresenter model)
						remove: oldMethod;
						add: method.
					sel notEmpty ifTrue: [methodsPresenter selections: sel]]]
		ifFalse: [self markCardDirty: #methods]!

onPackageChanged: aPackage
	"Private - The specified <Package> has moved from changed to not-changed state, or vice versa.
	Repaint the current card to ensure that any change markers are added/removed."

	cardsPresenter currentCard invalidate.
	self updateCaption!

onPackageSelected
	"Private - A package has been selected. Update the receiver's display
	to show the package contents."

	self updateContents!

onPackageSelectionChanging: aSelectionChangingEvent 
	self promptToSaveChanges: aSelectionChangingEvent!

onScriptSelected
	"Private - A script has been selected. Fill and show the source view with a
	definition of the script."

	| script |
	currentCard == #scripts ifFalse: [^self].
	script := self scriptName.
	script notNil 
		ifTrue: 
			[| pkg |
			pkg := self singlePackage.
			self scriptText: (pkg scriptAt: script).
			scriptTextPresenter ensureVisible]
		ifFalse: [self scriptText: '']!

onViewClosed
	"Private - Sent by the receiver's view when it has been closed.
	Disconnect from any events triggered by the devlopment system"

	super onViewClosed.
	self release
!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	| toolbar |
	super onViewOpened.
	(self view viewNamed: 'errors' ifNone: []) 
		ifNotNil: 
			[:item | 
			item model: statusModel.
			scriptTextPresenter errorModel: statusModel].

	"Enable view mode pulldown"
	toolbar := self view viewNamed: 'viewTools'.
	toolbar presenterConnectionPoint 
		when: #dropDown:
		send: #onDropDown:
		to: self.

	"Really a CardContainer view, but we treat as if a presenter"
	cardsPresenter := self view viewNamed: 'ownedCards'.
	cardsPresenter 
		when: #currentCardChanged
		send: #onCardChanged
		to: self.	";
		when: #currentCardChanging: send: #onSelectionChanging: to: self"

	"Make sure the classes tab is visble"
	commentPresenter ensureVisible.
	self packageManager youShouldBeProcessingEvents!

openWorkspace
	"Create a new workspace window on a file"

	| workspaceClass |
	workspaceClass := Smalltalk developmentSystem workspaceShellClass.
	^((FileOpenDialog new)
		fileTypes: workspaceClass fileTypes;
		defaultExtension: workspaceClass defaultFileExtension;
		initialDirectory: (packagesPresenter selectedFolder ifNil: [SessionManager current imageBase]);
		showModal) 
			ifNotNil: 
				[:path | 
				(workspaceClass filename: path)
					show;
					yourself]!

packages
	"Answer the collection of currently selected packages"

	^packagesPresenter selections!

packages: aPackageCollection
	"Set the selected packages."

	packagesPresenter
		selections: aPackageCollection asArray;
		ensureSelectionVisible;
		synchronizeFilter!

promptToSaveChanges
	^self promptToSaveChanges: (SelectionChangingEvent forSource: self)!

promptToSaveChanges: aSelectionChangingEvent 
	^(commentPresenter prompt: 'comment' toSaveChanges: aSelectionChangingEvent) 
		and: [scriptTextPresenter prompt: 'script' toSaveChanges: aSelectionChangingEvent]!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| selector |
	selector := aCommandQuery commandSymbol.
	selector == #browseIt 
		ifTrue: 
			[selector := self browseItCommand.
			selector isNil 
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	selector == #inspectIt 
		ifTrue: 
			[selector := self inspectItCommand.
			selector isNil 
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	selector == #browsePackages 
		ifTrue: 
			[aCommandQuery isEnabled: ((packagesPresenter respondsTo: selector) and: [self packages notEmpty]).
			^true].
	(#(#browseLocalMessageReferences #browseLocalMessageDefinitions) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: self packages notEmpty.
			^true].
	(#(#browseHierarchy #browseReferences) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (self selectedClass notNil or: [self selectedMethod notNil or: [self global notNil]]).
			^true].
	(#(#browseMethodClass #browseMessageDefinitions #browseMessageReferences #browseDefinitions) 
		identityIncludes: selector) 
			ifTrue: 
				[aCommandQuery isEnabled: (self selectedMethod notNil and: [currentCard == #methods]).
				^true].
	(#(#browseClass #browseClassReferences) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: self selectedClasses notEmpty.
			^true].
	#accept == selector 
		ifTrue: 
			[packagesPresenter hasSinglePackage 
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						isDefault: true]
				ifFalse: [aCommandQuery isEnabled: false].
			^true].
	(#(#removeClasses #inspectClasses) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: self selectedClasses notEmpty.
			^true].
	(#(#removeLooseMethods #inspectMethods) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: self selectedMethods notEmpty.
			^true].
	#browseMethods == selector 
		ifTrue: 
			[| methods |
			methods := self selectedMethods.
			aCommandQuery isEnabled: methods notEmpty.
			aCommandQuery text: (aCommandQuery description 
						expandMacrosWith: (methods size = 1 ifTrue: [methods first] ifFalse: ['&Methods'])).
			^true].
	#browseGlobalReferences == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self global notNil.
			^true].
	(#(#inspectGlobals #browseGlobals #removeGlobals) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: self globalNames notEmpty.
			^true].
	selector == #upgradeResources 
		ifTrue: 
			[aCommandQuery isEnabled: self resourceIdentifiers notEmpty.
			^true].
	^super queryCommand: aCommandQuery!

refreshCard: aSymbol
	currentCard == aSymbol 
		ifTrue: [self updateCardNow: aSymbol]
		ifFalse: [self markCardDirty: aSymbol]!

release
	"Remove references to objects that may refer back to the receiver. 
	Remove the event registrations we have lodged with the package manager and
	system dictionary."

	super release.
	self packageManager removeEventsTriggeredFor: self.
	self class environment removeEventsTriggeredFor: self.
!

removeClasses
	"Private - Remove the currently selected classes from the package."

	self selectedClasses do: [:e | e owningPackage removeClass: e]!

removeGlobals
	"Private - Remove the currently selected global from its package."

	self globalNames do: [:each | Package manager addGlobalNamed: each to: nil]!

removeLooseMethods
	"Private - Remove the currently selected method(s) from their packages.
	Note that the methods are not actually removed from the system (i.e.
	ownership is transferred to the package of their method class)."

	self selectedMethods do: [:each | each owningPackage removeMethod: each]!

resourceIdentifier
	"Private - Answer the currently selected <ResourceIdentifier>, or nil if there not exactly one selection."

	| rids |
	rids := self resourceIdentifiers.
	^rids size = 1 ifTrue: [rids first]!

resourceIdentifiers
	"Private - Answer a <Collection> of the <ResourceIdentifier>s in the package which are currently
	selected."

	^resourcesPresenter selections!

saveComment
	"Private - Save the comment from the source text."

	self singlePackage comment: commentPresenter plainText.
	commentPresenter isModified: false!

saveScript
	"Private - Save the script from the source text."

	self singlePackage scriptAt: self scriptName put: self scriptText.
	self updateScriptNames.
!

scriptName
	"Answer the currently selected script name."

	^(scriptNamesPresenter selectionIfNone: []) ifNotNil: [:script | script key]!

scriptText
	"Private - Answer the text for the currently selected script as a String"

	^scriptTextPresenter plainText!

scriptText: text 
	"Private - Set the text of the receivers scriptPresenter to the argument,
	text (either plain or rich text)."

	scriptTextPresenter text: text
!

searchEnvironment
	"Private - Answer the environment used to scope local searches. This will include only those
	packages which are currently selected."

	^self selectionEnvironment!

selectedClass
	"Answer the currently selected class if there is exactly one selection, otherwise answer nil."

	| classes |
	classes := self selectedClasses.
	^classes size == 1 ifTrue: [classes first]!

selectedClasses
	"Answer the currently selected class, or an empty collection if none."

	^classesPresenter selections!

selectedMethod
	| methods |
	methods := self selectedMethods.
	^methods size == 1 ifTrue: [methods first]!

selectedMethods
	"Answer a <collection> of the currently selected loose methods."

	^methodsPresenter selections!

selectionEnvironment
	^packagesPresenter selectionEnvironment!

setInitialFocus
	packagesPresenter view tabFirst!

shortCaption
	^'Packages'!

showPrerequisitesFor: aPackage
	"Private - Set the receiver to display aPackage and show the Prerequisites card for this"

	self singlePackage: aPackage.
	prerequisitesPresenter ensureVisible!

singlePackage
	"Answer the single selected package."

	^packagesPresenter singlePackage
!

singlePackage: aPackage
	"Set the receiver to be displaying a single package, aPackage"

	self packages: (Array with: aPackage)!

source
	"Private - Answer the source for the currently selected method as a String"

	^scriptTextPresenter plainText!

statusText: aString
	statusModel 
		value: (aString isNil ifFalse: [Notification new messageText: aString])!

updateCaption
	"Refresh the caption to reflect the currently selected packages in the receiver, if any."

	| pkgs count text |
	pkgs := self packages.
	count := pkgs size.
	text := String writeStream: 64.
	count == 0
		ifTrue: [text display: self class]
		ifFalse: 
			[| package version |
			package := pkgs first.
			text display: package.
			version := package packageVersion.
			(version notNil and: [version notEmpty])
				ifTrue: 
					[text
						space;
						display: package packageVersion].
			count == 1 ifFalse: [text nextPutAll: ', and other packages']].
	self caption: text contents!

updateCardNow: aSymbol
	| updateInfo |
	updateInfo := UpdateMap at: aSymbol.
	self perform: updateInfo second.
	updateFlags := updateFlags maskSet: updateInfo first!

updateCards
	"Private - Update the source object cards for the currently selected package(s).
	Implementation Note: It takes quite a bit of effort to update some of the cards, so we only 
	truly update the one which is actually displayed. We do this by clearing all models,
	except for the current card (to avoid flicker), and reset the update flags so that
	panes get refreshed on demand as they are displayed. Then we refresh the current card."

	UpdateMap keysDo: 
			[:each | 
			(each ~~ currentCard and: [self isCardUpToDate: each]) ifTrue: [self clearCard: each]].
	updateFlags := 0.
	self updateCardNow: currentCard!

updateClasses
	"Private - Update the classes list for this package."

	| classes |
	classes := OrderedCollection new: 64.
	self packages 
		do: [:each | each classesDo: [:eachClass | classes addLast: eachClass]].
	classesPresenter list: classes!

updateComment
	"Private - Update the comment for a single package."

	self singlePackage 
		ifNil: 
			[commentPresenter text: ''.
			commentPresenter view disable]
		ifNotNil: 
			[:package | 
			commentPresenter text: package comment.
			"#642: Note must enable after setting text, or view may not display scrollbar correctly"
			commentPresenter view enable]!

updateContents
	"Private - Fill the contents presenters based on the currently selected package."

	currentCard isNil ifTrue: [self cacheCurrentCard].
	self
		updateCards;
		updateCaption;
		updateStatus!

updateDependents
	dependentsPresenter packages: self packages!

updateGlobals
	"Private - Update the Globals list for this package."

	| globals |
	globals := OrderedCollection new.
	self packages do: [:each | globals addAll: each globalNames].
	globalsPresenter list: globals!

updateMethods
	"Private - Update the methods list for the selected package."

	| methods |
	methods := OrderedCollection new.
	self packages do: [:each | methods addAll: each methods].
	methodsPresenter list: methods!

updateMethodVersion
	| sccs |
	sccs := self sourceControl.
	sccs isConnected ifFalse: [^self].
	
	[| info |
	info := self selectedMethod isNil ifFalse: [sccs getVersionInfoFor: self selectedMethod].
	versionModel value: info]
			forkAt: Processor userBackgroundPriority!

updatePrerequisites
	"Private - Update the prerequisites list for this package."
	
	prerequisitesPresenter packages: self packages

!

updateResources
	"Private - Update the resources list for this package."

	Package manager looseMethods.
	resourcesPresenter showResourcesOwnedByPackages: self packages!

updateScriptNames
	"Private - Update the scripts list for a single package."

	| scriptSelected |
	scriptSelected := scriptNamesPresenter selectionByIndex.
	scriptNamesPresenter clear.
	self singlePackage 
		ifNil: [scriptTextPresenter view isEnabled: false]
		ifNotNil: 
			[:package | 
			#(#preinstall #postinstall #preuninstall #postuninstall) 
				do: [:each | scriptNamesPresenter model add: each -> (package scriptAt: each) notEmpty].
			scriptNamesPresenter 
				selectionByIndex: (scriptSelected = 0 ifTrue: [1] ifFalse: [scriptSelected]).
			scriptTextPresenter view isEnabled: true]!

updateStatus
	"Private - The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	self statusText: (self singlePackage ifNotNil: [:package | package packageFileName])!

upgradeResources
	"Private - Uprade & resave the selected resources, by loading them into a ViewComposer."

	self resourceIdentifiers do: [:each | each reassign]! !

!PackageBrowserShell categoriesForMethods!
accept!commands!public! !
addToCommandRoute:!commands!public! !
applyOptions!operations!options!private! !
browseClass!commands!public! !
browseClassReferences!commands!public! !
browseClassReferencesIn:!helpers!private! !
browseDefinitions!commands!public! !
browseGlobalReferences!commands!public! !
browseHierarchy!commands!private! !
browseIt!commands!public! !
browseItCommand!helpers!private! !
browseLocalClassReferences!commands!public! !
browseLocalMessageDefinitions!commands!public! !
browseLocalMessageReferences!commands!public! !
browseLooseMethods:!helpers!private! !
browseMessageDefinitions!commands!public! !
browseMessageDefinitionsIn:!helpers!private! !
browseMessageReferences!commands!public! !
browseMessageReferencesIn:!helpers!private! !
browseMethodClass!commands!public! !
browseMethods!commands!public! !
browsePackages!commands!public! !
browseReferences!commands!public! !
browseSystem!commands!public! !
buildPopupForCommand:!event handling!private! !
cacheCurrentCard!event handling!private! !
canSaveState!private!saved state! !
clearCard:!private!updating! !
clearClasses!private!updating! !
clearComment!private!updating! !
clearDependents!private!updating! !
clearGlobals!private!updating! !
clearMethods!private!updating! !
clearPrerequisites!private!updating! !
clearResources!private!updating! !
clearScriptNames!private!updating! !
createComponents!commands!initializing!private! !
createSchematicWiring!commands!initializing!private! !
customDrawClassList:!private! !
defaultHelpId!public! !
global!accessing!public! !
globalNames!accessing!public! !
globals!accessing!public! !
hasClassSelected!public!testing! !
hasEditableMethodSelected!public!testing! !
hasEditableMethodsSelected!public!testing! !
hasMethodSelected!public!testing! !
hasPackages!private!testing! !
hasPackageSelected!public!testing! !
initialize!initializing!private! !
inspectClasses!commands!public! !
inspectCollection:!helpers!private! !
inspectGlobals!commands!public! !
inspectIt!commands!public! !
inspectItCommand!helpers!private! !
inspectMethods!commands!public! !
inspectResources!commands!public! !
isCardUpToDate:!private!testing! !
markCardDirty:!helpers!private! !
objectRepackaged:from:to:card:list:!event handling!private! !
onCardChanged!event handling!private! !
onClassRemoved:!event handling!private! !
onClassRepackaged:from:to:!event handling!private! !
onCloseRequested:!event handling!private! !
onDragClasses:!event handling!private! !
onDragGlobal:!event handling!private! !
onDragMethods:!event handling!private! !
onDragOver:type:!event handling!private! !
onDragResource:!event handling!private! !
onDropOverPackage:!event handling!private! !
onGlobalRemoved:!event handling!private! !
onGlobalRenamed:from:!event handling!private! !
onGlobalRepackaged:from:to:!event handling!private! !
onMethodAdded:!event handling!private! !
onMethodRemoved:!event handling!private! !
onMethodRepackaged:from:to:!event handling!private! !
onMethodSelected!event handling!private! !
onMethodUpdated:!event handling!private! !
onPackageChanged:!event handling!private! !
onPackageSelected!event handling!private! !
onPackageSelectionChanging:!private! !
onScriptSelected!event handling!private! !
onViewClosed!event handling!private! !
onViewOpened!event handling!private! !
openWorkspace!commands!public! !
packages!accessing!public! !
packages:!accessing!public! !
promptToSaveChanges!helpers!private! !
promptToSaveChanges:!helpers!private! !
queryCommand:!commands!public! !
refreshCard:!helpers!private! !
release!dependency!public! !
removeClasses!commands!private! !
removeGlobals!commands!private! !
removeLooseMethods!commands!private! !
resourceIdentifier!accessing!private! !
resourceIdentifiers!accessing!private! !
saveComment!commands!private! !
saveScript!operations!private! !
scriptName!accessing!private! !
scriptText!accessing!private! !
scriptText:!accessing!private! !
searchEnvironment!accessing!private! !
selectedClass!accessing!public! !
selectedClasses!accessing!public! !
selectedMethod!accessing!public! !
selectedMethods!accessing!public! !
selectionEnvironment!accessing!private! !
setInitialFocus!operations!public! !
shortCaption!accessing!public! !
showPrerequisitesFor:!helpers!private! !
singlePackage!accessing!public! !
singlePackage:!accessing!public! !
source!accessing!private! !
statusText:!accessing!private! !
updateCaption!public!updating! !
updateCardNow:!private!updating! !
updateCards!private!updating! !
updateClasses!private!updating! !
updateComment!private!updating! !
updateContents!private!updating! !
updateDependents!private!updating! !
updateGlobals!private!updating! !
updateMethods!private!updating! !
updateMethodVersion!event handling!private! !
updatePrerequisites!private!updating! !
updateResources!private!updating! !
updateScriptNames!private!updating! !
updateStatus!private!updating! !
upgradeResources!commands!public! !
!

!PackageBrowserShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Package Browser'
!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Register the receiver with SmalltalkSystem.

		self initialize.
	"

	(Smalltalk developmentSystem)
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true.
	self wordWrapComment: true.
	UpdateMap := (IdentityDictionary new)
				at: #classes put: #(1 #updateClasses #clearClasses);
				at: #methods put: #(2 #updateMethods #clearMethods);
				at: #globals put: #(4 #updateGlobals #clearGlobals);
				at: #scripts put: #(8 #updateScriptNames #clearScriptNames);
				at: #resources put: #(16 #updateResources #clearResources);
				at: #prerequisites put: #(32 #updatePrerequisites #clearPrerequisites);
				at: #comment put: #(64 #updateComment #clearComment);
				at: #dependents put: #(128 #updateDependents #clearDependents);
				shrink;
				yourself!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: (Aspect boolean: #canUseIdeaSpace);
		add: (Aspect boolean: #wordWrapComment);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1795812352 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 704 8 '' 672 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 7 nil nil nil 1040 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1072 8 '' 1040 3 976 994 193 193 nil 27 8 'imageTools' 410 ##(Smalltalk.Toolbar) 34 28 nil 528 34 2 8 1140853612 131137 1296 nil nil nil 519 nil nil nil 1296 608 8 1795812352 170 192 976 nil nil nil 170 192 34 2 12373 1115718 2 ##(Smalltalk.ToolbarIconButton) 1296 273 1180998 4 ##(Smalltalk.CommandDescription) #viewModeSelect 8 'Views' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ViewMode.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 12373 nil nil 34 1 1440 nil nil 9 1 nil nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[111 2 0 0 0 0 0 0 143 2 0 0 25 0 0 0] 193 1328 8 '' 1296 3 8 #() 994 193 193 nil 31 8 'viewTools' 410 ##(Smalltalk.Toolbar) 34 28 nil 528 34 2 8 1140853580 131073 1840 nil nil nil 519 nil nil nil 1840 608 8 1795812352 170 192 976 nil nil nil 170 192 34 8 12371 1426 1840 1 1458 #browsePackageSources 8 'Open Source Browser' 1 1 1506 nil true 1552 8 'SourceBrowser.ico' 1600 12371 nil nil 12369 1426 1840 1 1458 #savePackageChanges 8 'Save Package Changes' 1 1 1506 nil true 1552 8 'FileSave.ico' 1600 12369 nil nil 12367 1426 1840 1 1458 #openPackage 8 'Install Package' 1 1 1506 nil true 1552 8 'FileOpen.ico' 1600 12367 nil nil 12365 1426 1840 1 1458 #newPackage 8 'New Package' 1 1 1506 nil true 1552 8 'NewPackage.ico' 1600 12365 nil nil 34 5 2208 2128 2048 1968 1049158 1 ##(Smalltalk.ToolbarSeparator) 1840 1 nil nil 9 1 nil nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[11 2 0 0 0 0 0 0 111 2 0 0 25 0 0 0] 193 1872 8 '' 1840 3 8 #() 994 193 193 nil 31 8 'fileTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2528 nil nil nil 7 nil nil nil 2528 738 ##(Smalltalk.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 2560 8 '' 2528 3 976 994 193 193 nil 27 8 'searchTools' nil nil nil 170 192 976 8 #() nil nil 9 1311 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 212 2 0 0 25 0 0 0] 193 560 8 '' 528 3 34 5 1040 672 2528 1840 1296 994 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140850956 1 3024 nil 608 nil 7 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 77 0 105 0 99 0 114 0 111 0 115 0 111 0 102 0 116 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 3024 nil 8 1795505344 170 192 34 4 853830 1 ##(Smalltalk.StatusBarItem) 8193 -1 3024 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' 3218 8193 -1 3024 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3216 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 3344 7 257 nil nil 8 'version' nil nil nil 34 1 3232 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 3024 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 185 1 0 0 212 2 0 0 205 1 0 0] 193 3056 8 '' 3024 3 8 #() 994 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3648 nil nil nil 7 nil nil nil 3648 1180166 ##(Smalltalk.ProportionalLayout) 170 176 976 true 170 192 976 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 25 0 0 0 212 2 0 0 185 1 0 0] 193 3680 8 '' 3648 3 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3648 34 2 8 1140850688 131073 3936 nil nil nil 7 nil nil nil 3936 3714 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 3936 34 2 8 1140850688 131073 4048 nil nil nil 7 nil nil nil 4048 3714 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.CardContainer) 34 16 nil 4048 34 2 8 1140850688 131073 4192 nil nil nil 7 nil nil nil 4192 656710 1 ##(Smalltalk.CardLayout) 138 144 34 8 4162 590662 1 ##(Smalltalk.CardLabel) 8 'Classes' 834 #icon 8 #() ##(Smalltalk.Behavior) nil 410 ##(Smalltalk.ListView) 34 45 nil 4192 34 2 8 1140920395 1 4416 590662 2 ##(Smalltalk.ListModel) 138 144 976 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 608 nil 29 265030 4 ##(Smalltalk.Menu) nil true 34 6 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1458 #browseClass 8 '&Browse' 1 1 1506 nil true 1552 8 'ClassBrowserShell.ico' 1600 nil nil 4610 1 1458 #browseClassReferences 8 'All Re&ferences' 1 1 nil nil nil 4610 1 1458 #browseLocalClassReferences 8 'L&ocal References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4610 1 1458 #addClass 8 '&Add Uncommitted..' 1 1 nil nil nil 4610 1 1458 #removeClasses 8 '&Remove from Package' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4416 nil 8 1795768528 3282 #name 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 3330 0 nil 1180966 ##(Smalltalk.CompiledExpression) 4 1 3328 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 5024 7 257 nil 994 65 65 nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 41 #left 3330 0 nil 5042 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 5216 7 257 nil 3330 0 nil 5042 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 5328 7 513 nil 3282 #isChanged 8 #() nil 4416 3330 0 nil 5042 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4162 #Package ##(Smalltalk.Package) #changedIcon #imageIndex 5440 7 257 nil 1 nil 3330 0 nil 5042 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx |
ctx item isNonInstantiable ifTrue: [ctx font isItalic: true]]' 8 #[34 105 226 0 159 122 226 2 58 179 106 60 106] #item #isNonInstantiable #font #isItalic: #ifTrue: 5536 7 257 nil 5170 8 'Name' 375 #left 3282 #name 8 #() 3282 #<= 8 #() nil nil 4416 ##(Smalltalk.IconicListAbstract) 1 nil 3330 0 nil 5042 4 1 3328 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 5712 7 257 nil 5170 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3330 0 nil 5042 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5824 7 513 nil 3282 #owningPackage 8 #() nil 4416 nil 1 nil nil 5170 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) 3282 #<= 8 #() 3330 0 nil 5042 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] #fileOutName 6000 7 257 nil nil 4416 nil 1 nil nil #list 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 44 0 0 0 220 1 0 0 156 1 0 0] 193 4448 8 '' 4416 834 #contextMenu: 34 1 4576 4416 1 8 #() 994 193 193 nil 35 4162 4338 8 'Methods' 834 #icon 4400 3360 nil 410 ##(Smalltalk.ListView) 34 45 nil 4192 34 2 8 1140920393 1 6368 4482 138 144 976 nil 4544 608 nil 29 4562 nil true 34 8 4610 2097153 1458 #browseMethods 8 'Browse <1d>' 1 1 nil nil nil 4610 1 1458 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 nil nil nil 4610 1 1458 #browseMessageReferences 8 'All Re&ferences' 1 1 nil nil nil 4610 1 1458 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 nil nil nil 4610 1 1458 #browseLocalMessageReferences 8 '&Local References' 1 1 nil nil nil 4802 4097 4610 1 1458 #removeLooseMethods 8 '&Remove from Package' 1 1 nil nil nil 4562 nil true 34 7 4610 1 1458 #renameMethod 8 'Re&name' 1 1 nil nil nil 4610 1 1458 #renameMethodReferences 8 'Rename Re&ferences' 1 1 nil nil nil 4802 4097 4610 1 1458 #safeRemoveMethods 8 '&Remove' 1 1 nil nil nil 4802 4097 4610 1 1458 #addParameterToMethod 8 'Add &Parameter...' 1 1 nil nil nil 4562 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 6368 nil 8 1795768528 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 5008 nil nil nil 994 65 65 nil nil 138 144 34 3 5170 8 'Selector' 401 #left 3282 #selector 8 #() 3330 0 nil 5042 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] #selector 7264 7 513 nil nil nil 6368 ##(Smalltalk.IconicListAbstract) 1 nil 3330 0 nil 5042 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4162 #ClassBrowserAbstract ##(Smalltalk.ClassBrowserAbstract) #looseMethodColor #forecolor: 7344 7 257 nil 5170 8 'Class' 389 #left ##(Smalltalk.BasicListAbstract) 3282 #<= 8 #() 3282 #methodClass 8 #() nil 6368 ##(Smalltalk.IconicListAbstract) 1 nil 3330 0 nil 5042 4 1 3328 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 7536 7 257 nil 5170 8 'Package' 157 #left ##(Smalltalk.BasicListAbstract) 3330 0 nil 5042 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 7648 7 513 nil 3282 #owningPackage 8 #() nil 6368 nil 3 nil nil #report 6080 nil 131173 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 44 0 0 0 220 1 0 0 156 1 0 0] 193 6400 8 'Selector' 6368 834 #contextMenu: 34 1 6464 6368 1 8 #() 994 193 193 nil 35 4162 4338 8 'Resources' 834 #icon 4400 736 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4192 34 2 8 1140850688 131073 8032 nil nil nil 5 4562 nil true 34 4 4610 2097153 1458 #editResource 8 '&Edit' 1 1 1506 nil true 1552 8 'ViewComposer.ico' 1600 nil nil 4610 1 1458 #showResource 8 '&Show' 1 1 1506 nil true 1552 8 'TestView.ico' 1600 nil nil 4802 4097 4610 1 1458 #deleteResource 8 '&Delete' 1 1 1506 nil true 1552 8 'EditClear.ico' 1600 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 8032 738 ##(Smalltalk.ResourceListPresenter) #resource_Package_view nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 44 0 0 0 220 1 0 0 156 1 0 0] 193 8064 8 '' 8032 834 #contextMenu: 34 1 8096 8032 1 976 994 193 193 nil 27 4162 4338 8 'Globals' nil nil 410 ##(Smalltalk.ListView) 34 45 nil 4192 34 2 8 1140920393 1 8656 4482 138 144 976 nil 4544 608 nil 29 4562 nil true 34 6 4610 1 1458 #addGlobal 8 '&Add Uncommitted...' 1 1 nil nil nil 4610 1 1458 #removeGlobals 8 '&Remove from Package' 1 1 nil nil nil 4802 4097 4610 2097153 1458 #inspectGlobals 8 '&Inspect' 1 1 1506 nil true 1552 8 'BasicInspector.ico' 1600 nil nil 4610 1 1458 #browseGlobalReferences 8 'All Re&ferences' 1 1 nil nil nil 4610 1 1458 #browseLocalGlobalReferences 8 '&Local References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 8656 nil 8 1795768528 ##(Smalltalk.BasicListAbstract) 3330 0 nil 5042 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 4162 #Smalltalk ##(Smalltalk) #icon #imageIndex 9104 7 257 nil 5008 nil nil nil 994 65 65 nil nil 138 144 34 4 5170 8 '' 41 #left 3330 0 nil 5042 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 5312 9280 7 257 nil 3330 0 nil 5042 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 9376 7 513 nil 3330 0 nil 5042 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | [(Smalltalk at: x) isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 45 17 148 159 106 47 34 111 59 106 193 106] 9184 #isChanged 4162 #Error ##(Smalltalk.Error) #on:do: 9456 3330 0 nil 9472 39 257 nil 7 257 nil nil 8656 3330 0 nil 5042 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 5520 #changedIcon #imageIndex 9568 7 257 nil 1 nil nil 5170 8 'Global' 301 #left ##(Smalltalk.BasicListAbstract) 3282 #<= 8 #() nil nil 8656 3330 0 nil 5042 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 9184 #icon #imageIndex 9712 7 257 nil 1 nil nil 5170 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3330 0 nil 5042 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 9824 7 513 nil 3330 0 nil 5042 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | Package manager packageOfGlobalNamed: x]' 8 #[32 105 45 159 17 178 106] 5520 #manager #packageOfGlobalNamed: 9904 7 257 nil nil 8656 nil 1 nil nil 5170 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) 3282 #<= 8 #() 3330 0 nil 5042 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | | glob |
glob := Smalltalk at: x.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[34 105 45 17 148 70 144 30 178 120 18 161 106 33 106] 4162 #Smalltalk ##(Smalltalk) #sourceObject #conformsToProtocol: #fileOutName 8 '' 10048 7 65793 nil nil 8656 nil 1 nil nil #report 6080 nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 44 0 0 0 220 1 0 0 156 1 0 0] 193 8688 8 '' 8656 834 #contextMenu: 34 1 8752 8656 1 8 #() 994 193 193 nil 35 4162 4338 8 'Scripts' nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 4192 34 2 8 1140850688 131073 10416 nil nil nil 5 nil nil nil 10416 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ScintillaView) 34 65 nil 10416 34 2 8 1176572228 1025 10544 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 608 nil 21 4562 nil true 34 13 4610 1 1458 #accept 8 '&Accept' 1 1 nil nil nil 4802 4097 4562 nil true 34 11 4610 1 1458 #undo 8 '&Undo' 1 1 1506 nil true 1552 8 'EditUndo.ico' 1600 nil nil 4802 4097 4610 1 1458 #cutSelection 8 'Cu&t' 1 1 1506 nil true 1552 8 'EditCut.ico' 1600 nil nil 4610 1 1458 #copySelection 8 '&Copy' 1 1 1506 nil true 1552 8 'EditCopy.ico' 1600 nil nil 4610 1 1458 #pasteClipboard 8 '&Paste' 1 1 1506 nil true 1552 8 'EditPaste.ico' 1600 nil nil 4610 1 1458 #clearSelection 8 'De&lete' 1 1 1506 nil true 1552 8 'EditClear.ico' 1600 nil nil 4610 1 1458 #clear 8 'Clea&r' 1 1 1506 nil true 1552 8 'ClearDocument.ico' 1600 nil nil 4802 4097 4610 1 1458 #reformatSource 8 'Re&format' 1 1 nil nil nil 4802 4097 4610 1 1458 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4562 nil true 34 10 4610 1 1458 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4610 1 1458 #cloneNew 8 '&Clone' 1 1 1506 nil true 1552 8 'SmalltalkWorkspace.ico' 1600 nil nil 4802 4097 4610 1 1458 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4610 1 1458 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4610 1 1458 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4610 1 1458 #toggleLineEndings 8 'Line &Endings' 1 1 788806 2 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4610 1 1458 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4610 1 1458 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4610 1 1458 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 4802 4097 4610 1 1458 #browseIt 8 'Bro&wse It' 1 1 1506 nil true 1552 8 'ClassBrowserShell.ico' 1600 nil nil 4610 1 1458 #displayIt 8 '&Display It' 1 1 1506 nil true 1552 8 'DisplayIt.ico' 1600 nil nil 4610 1 1458 #printIt 8 '&Print It' 1 1 1506 nil true 1552 8 'PrintIt.ico' 1600 nil nil 4610 1 1458 #evaluateIt 8 'E&valuate It' 1 1 1506 nil true 1552 8 'EvaluateIt.ico' 1600 nil nil 4610 1 1458 #inspectIt 8 '&Inspect It' 1 1 1506 nil true 1552 8 'BasicInspector.ico' 1600 nil nil 4610 1 1458 #debugIt 8 'Deb&ug It' 1 1 1506 nil true 1552 8 'Debugger.ico' 1600 nil nil 4802 4097 4562 nil true 34 3 4610 2097153 1458 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 4610 1 1458 #browseReferences 8 '&References...' 1 1 nil nil nil 4610 1 1458 #browseMessages 8 '&Messages...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 10544 nil 8 1537949160 852486 ##(Smalltalk.NullConverter) nil nil 9 1418429905 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 594 #gray 594 #white 1 nil nil nil nil #callTip nil nil nil #normal 12818 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 976 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 10544 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 594 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 12784 nil nil nil nil 16 nil 170 192 34 4 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 17 10544 594 #blue 3 false #Warning nil nil nil nil nil nil #Error 13218 19 10544 594 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 12818 1027 594 #darkGoldenrod 594 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 12818 1031 594 #firebrick 594 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 12818 1029 nil 594 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 9 834 #createWindow: 34 1 882 914 8 #[10 0 0 0 10 0 0 0 170 1 0 0 98 1 0 0] 193 10576 nil 10544 834 #contextMenu: 34 1 10672 10544 834 #caretPeriod: 8 #(530) 10544 834 #wordWrap: 8 #(true) 10544 834 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 10544 1 3 nil nil 5 nil 13730 3 10544 1 nil nil 67108863 5 nil 13730 5 10544 1 nil nil nil 5 nil 10544 834 #canHScroll: 8 #(false) 10544 834 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 10544 834 #maxCompletionListHeight: 8 #(9) 10544 834 #edgeColumn: 8 #(1) 10544 3 8 #() 994 193 193 nil 33 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 21 14018 #fixedParentRight -91 14018 #fixedParentTop 21 14018 #fixedParentBottom -19 410 ##(Smalltalk.TabViewXP) 34 28 nil 10416 34 2 8 1140916866 1 14096 4482 138 144 976 nil 4544 608 nil 5 nil nil nil 14096 nil 8 1795364496 3330 0 nil 5042 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] #key 14208 7 257 nil 3330 0 nil 5042 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] #icon #imageIndex 14288 7 257 nil 5008 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 216 1 0 0 108 1 0 0] 193 14128 8 '' 14096 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 14096 3 8 #() 994 193 193 nil 27 13986 14032 1 14048 1 14064 1 14080 1 170 192 34 4 10544 8 'scriptText' 14096 8 'scriptNames' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 44 0 0 0 220 1 0 0 156 1 0 0] 193 10448 8 '' 10416 1 34 2 10544 14096 994 193 193 nil 27 4162 4338 8 'Prerequisites' nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4192 34 2 8 1140850688 131073 14880 nil nil nil 5 nil nil nil 14880 738 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 44 0 0 0 220 1 0 0 156 1 0 0] 193 14912 8 '' 14880 1 976 994 193 193 nil 27 4162 4338 8 'Dependents' nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4192 34 2 8 1140850688 131073 15168 nil nil nil 5 nil nil nil 15168 738 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 44 0 0 0 220 1 0 0 156 1 0 0] 193 15200 8 '' 15168 1 976 994 193 193 nil 27 4162 4338 8 'Comment' nil nil 410 ##(Smalltalk.ScintillaView) 34 65 nil 4192 34 2 8 1176572228 1 15456 10610 nil false 10656 nil 466 #commentWorkspace nil 7 4562 nil true 34 12 4610 1 1458 #accept 8 '&Accept' 1 1 nil nil nil 4802 4097 4562 nil true 34 10 4610 1 1458 #undo 8 '&Undo' 1 1 1506 nil true 1552 8 'EditUndo.ico' 1600 nil nil 4802 4097 4610 1 1458 #cutSelection 8 'Cu&t' 1 1 1506 nil true 1552 8 'EditCut.ico' 1600 nil nil 4610 1 1458 #copySelection 8 '&Copy' 1 1 1506 nil true 1552 8 'EditCopy.ico' 1600 nil nil 4610 1 1458 #pasteClipboard 8 '&Paste' 1 1 1506 nil true 1552 8 'EditPaste.ico' 1600 nil nil 4610 1 1458 #clearSelection 8 'De&lete' 1 1 1506 nil true 1552 8 'EditClear.ico' 1600 nil nil 4802 4097 4610 1 1458 #clear 8 'Clea&r' 1 1 1506 nil true 1552 8 'ClearDocument.ico' 1600 nil nil 4802 4097 4610 1 1458 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4802 4097 4610 1 1458 #browseIt 8 'Bro&wse It' 1 1 12080 nil nil 4610 1 1458 #displayIt 8 '&Display It' 1 1 1506 nil true 1552 8 'DisplayIt.ico' 1600 nil nil 4610 1 1458 #printIt 12224 1 1 12240 nil nil 4610 1 1458 #evaluateIt 8 'E&valuate It' 1 1 1506 nil true 1552 8 'EvaluateIt.ico' 1600 nil nil 4610 1 1458 #inspectIt 8 '&Inspect It' 1 1 12400 nil nil 4610 1 1458 #debugIt 12464 1 1 12480 nil nil 4802 4097 4562 nil true 34 2 4610 2097153 1458 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 4610 1 1458 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 15456 594 #seaGreen 8 1537949160 12754 nil nil 9 1419660433 170 192 34 50 #header1 12818 13 196934 1 ##(Smalltalk.RGB) 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #horizontalRule 12818 35 16882 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #olistItem 12818 29 16882 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #indentGuide 12818 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 12818 77 12848 12864 1 nil nil nil nil #callTip nil nil nil #ulistItem 12818 27 16882 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #strikeOut 12818 33 16882 7768625 16882 20673875 1 nil nil nil nil #strikeOut nil nil nil #preChar 12818 25 594 #black 16882 22404573 1 nil nil nil nil #preChar nil 1401 nil #code 12818 39 16882 17825793 16882 31317469 1 nil nil nil nil #code nil nil nil #strong1 12818 5 16882 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #codeBlock 12818 43 16882 17825793 16882 31317469 1 nil nil nil nil #codeBlock nil nil nil #header3 12818 17 16882 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #lineBegin 12818 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #header4 12818 19 16882 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #lineNumber 12818 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #blockQuote 12818 31 16882 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #em2 12818 11 16882 26317 nil 9 nil nil nil nil #em2 nil nil nil #strong2 12818 7 16882 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #header2 12818 15 16882 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #header6 12818 23 16882 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #link 12818 37 16882 22282241 nil 33 nil nil nil nil #link nil nil nil #normal 12818 1 nil 594 #window 1 nil nil nil nil #normal nil nil nil #code2 12818 41 16882 17825793 16882 31317469 1 nil nil nil nil #code2 nil nil nil #header5 12818 21 16882 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #em1 12818 9 16882 26317 nil 9 nil nil nil nil #em1 nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 12978 1 nil nil nil 15456 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 nil nil nil nil nil 13040 nil nil 65 nil nil nil 13136 3 170 192 34 4 #markdown 16832 #container 170 192 34 4 #callTip 12818 77 12848 12864 1 nil nil nil nil #callTip nil nil nil #normal 12818 1 nil nil 1 nil nil nil nil #normal nil nil nil nil nil nil nil 208 nil 170 192 34 4 #Warning 13218 19 15456 13248 3 false #Warning nil nil nil nil nil nil #Error 13218 17 15456 13280 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 12818 1027 13344 13360 1 nil nil nil nil #Warning nil nil nil #Error 12818 1031 13392 13408 1 nil nil nil nil #Error nil nil nil #Notification 12818 1029 nil 13440 1 nil nil nil nil #Notification nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 12 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 44 0 0 0 220 1 0 0 156 1 0 0] 193 15488 nil 15456 834 #contextMenu: 34 1 15552 15456 834 #isDrawingBuffered: 8 #(false) 15456 834 #caretPeriod: 8 #(530) 15456 834 #wordWrap: 8 #(true) 15456 834 #margins: 34 1 34 3 13730 1 15456 1 3 nil nil 5 nil 13730 3 15456 1 nil nil 67108863 5 nil 13730 5 15456 1 nil nil nil 5 nil 15456 834 #targetRange: 34 1 13858 1 -1 3 15456 834 #maxCompletionListHeight: 8 #(9) 15456 834 #edgeColumn: 8 #(1) 15456 834 #setLexerLanguage: 8 #(#markdown) 15456 834 #sciSetTechnology: 8 #(1) 15456 834 #sciSetFontQuality: 8 #(3) 15456 3 8 #() 994 193 193 nil 33 15456 nil nil nil 170 192 34 16 15456 8 'comment' 15168 8 'dependents' 6368 8 'methods' 4416 8 'classes' 8656 8 'globals' 14880 8 'prerequisites' 8032 8 'resources' 10416 8 'scripts' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 4192 34 2 8 1140916736 1 18800 4482 138 144 34 8 15424 4352 6320 7984 8624 10384 14848 15136 nil 4544 nil nil 1 nil nil nil 18800 nil 8 1795364496 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 5008 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 224 1 0 0 160 1 0 0] 193 18832 8 '' 18800 834 #setSingleSelection: 8 #(1) 18800 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 18800 3 8 #() 994 193 193 nil 27 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 224 1 0 0 160 1 0 0] 193 4224 8 '' 4192 3 34 9 15456 4416 6368 8032 8656 10416 14880 15168 18800 994 193 193 nil 27 5 false 170 192 34 2 4192 8 'ownedCards' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[244 0 0 0 0 0 0 0 212 2 0 0 160 1 0 0] 193 4080 8 '' 4048 3 34 1 4192 994 193 193 nil 27 5 false 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 3936 34 2 8 1140850688 131073 19600 nil nil nil 7 nil nil nil 19600 738 ##(Smalltalk.PackageSelector) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 239 0 0 0 160 1 0 0] 193 19632 8 '' 19600 3 976 994 193 193 nil 27 8 'packages' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 212 2 0 0 160 1 0 0] 193 3968 8 '' 3936 3 34 3 19600 410 ##(Smalltalk.Splitter) 34 12 nil 3936 34 2 8 1140850688 1 20016 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 20016 nil 1 #left nil nil nil 994 1 1 994 9 9 nil 20112 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[239 0 0 0 0 0 0 0 244 0 0 0 160 1 0 0] 193 20048 8 '' 20016 3 8 #() 994 193 193 nil 27 4048 994 193 193 nil 27 994 193 193 nil 27 170 192 34 4 3024 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 10 4562 nil true 34 24 4610 1 1458 #newPackage 8 '&New Package...' 9373 5 1506 nil true 1552 8 'NewPackage.ico' 1600 nil nil 4610 1 1458 #openPackage 8 '&Install Package...' 9375 5 1506 nil true 1552 8 'FileOpen.ico' 1600 nil nil 4610 1 1458 #removePackage 8 '&Uninstall Package' 1 5 nil nil nil 4802 4097 4562 nil true 34 2 4610 2097153 1458 #addClass 8 '&Class...' 1 1 1506 nil true 1552 8 'Behavior.ico' 1600 nil nil 4610 1 1458 #addGlobal 8 '&Global...' 1 1 nil nil nil 8 'Add Unco&mmitted' nil 134217729 nil nil 12385 nil nil 4610 1 1458 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 nil nil nil 4610 1 1458 #synchronizeFilter 8 '&Goto Folder' 1 1 1506 nil true 1552 8 'GotoFolder.ico' 1600 nil nil 4802 4097 4610 1 1458 #savePackages 8 '&Save Package' 1 1 1506 nil true 1552 8 'FileSave.ico' 1600 nil nil 4610 1 1458 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 4610 1 1458 #savePackageAs 8 'Save Package &As...' 1 1 nil nil nil 4802 4097 4610 1 1458 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4610 1 1458 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4802 4097 4610 1 1458 #saveImage 8 'Sa&ve Image' 1 1 1506 nil true 1552 8 'Snapshot.ico' 1600 nil nil 4610 1 1458 #smalltalkExit 8 'E&xit Dolphin' 1 1 1506 nil true 1552 8 'PowerSwitch.ico' 1600 nil nil 4802 4097 4562 nil true 34 1 4610 2097153 1458 #browseTests 8 '&Browse' 1 1 nil nil nil 8 '&Tests' nil 1 1506 nil true 1552 8 'TestRunner.ico' nil nil 12407 nil nil 4562 nil true 34 4 4610 2097153 1458 #deploy 8 '&Deploy Executable...' 13445 1 nil nil nil 4610 1 1458 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 1506 nil true 1552 8 'EnvironmentBrowserShell.ico' 1600 nil nil 4802 4097 4610 1 1458 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 nil nil nil 8 '&Deployment' nil 134217729 1506 nil true 1552 8 'ApplicationDeploymentWizard.ico' 1600 nil 12415 nil nil 4802 4097 4610 1 1458 #inspectPackage 8 'P&roperties' 1 1 1506 nil true 1552 8 'BasicInspector.ico' 1600 nil nil 4802 4097 4610 1 1458 #exit 8 '&Close' 17639 1 11810 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 12421 nil nil 4562 nil true 34 12 4610 1 1458 #undo 8 '&Undo' 9397 1 1506 nil true 1552 8 'EditUndo.ico' 1600 nil nil 4802 4097 4610 1 1458 #cutSelection 8 'Cu&t' 9393 1 1506 nil true 1552 8 'EditCut.ico' 1600 nil nil 4610 1 1458 #copySelection 8 '&Copy' 9351 1 1506 nil true 1552 8 'EditCopy.ico' 1600 nil nil 4610 1 1458 #pasteClipboard 8 '&Paste' 9389 1 1506 nil true 1552 8 'EditPaste.ico' 1600 nil nil 4610 1 1458 #editDelete 8 '&Delete' 1 1 1506 nil true 1552 8 'EditClear.ico' 1600 nil nil 4802 4097 4610 1 1458 #selectAll 8 'Select &All' 9347 1 nil nil nil 4802 4097 4610 1 1458 #editFind 8 '&Find...' 9357 1 1506 nil true 1552 47 786694 ##(Smalltalk.ShellLibrary) nil nil 4610 1 1458 #findNext 8 'Find &Next' 1253 1 1506 nil true 1552 8 'FindNext.ico' 1600 nil nil 4610 1 1458 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 12441 nil nil 4562 nil true 34 14 4610 1 1458 #browseIt 8 '&Browse It' 9349 1 1506 nil true 1552 8 'ClassBrowserShell.ico' 1600 nil nil 4610 1 1458 #displayIt 8 '&Display It' 9353 1 1506 nil true 1552 8 'DisplayIt.ico' 1600 nil nil 4610 1 1458 #printIt 8 '&Print It' 9377 1 1506 nil true 1552 8 'PrintIt.ico' 1600 nil nil 4610 1 1458 #evaluateIt 8 '&Evaluate It' 9355 1 1506 nil true 1552 8 'EvaluateIt.ico' 1600 nil nil 4610 1 1458 #inspectIt 8 '&Inspect It' 9363 1 1506 nil true 1552 8 'BasicInspector.ico' 1600 nil nil 4610 1 1458 #debugIt 8 'Deb&ug It' 1269 1 1506 nil true 1552 8 'Debugger.ico' 1600 nil nil 4610 1 1458 #fileItIn 8 '&File It In' 1 1 nil nil nil 4802 4097 4610 1 1458 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 4610 1 1458 #browseReferences 8 '&References...' 5367 1 nil nil nil 4802 4097 4610 1 1458 #accept 8 '&Accept' 9383 1 nil nil nil 4802 4097 4562 nil true 34 7 4610 1 1458 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4610 1 1458 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4610 1 1458 #toggleLineEndings 8 'Line &Endings' 1 1 11810 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4610 1 1458 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4610 1 1458 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4610 1 1458 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4610 1 1458 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 1506 nil true 1552 8 'Preferences.ico' 1600 nil 12477 nil nil 8 '&Workspace' nil 134217729 nil nil 12479 nil nil 4562 nil true 34 4 4610 1 1458 #browseLocalMessageDefinitions 8 '&Definitions Of...' 1 1 nil nil nil 4610 1 1458 #browseLocalMessageReferences 8 '&References To...' 1 1 nil nil nil 4802 4097 4610 1 1458 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 12487 nil nil 4562 nil true 34 10 4610 1 1458 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4610 2097153 1458 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4802 4097 4610 1 1458 #checkOut 8 'Check Out &All' 1 1 nil nil nil 4610 1 1458 #checkOutChanges 8 '&Check Out Changes' 9367 1 nil nil nil 4610 1 1458 #checkIn 8 'Check &In' 9387 1 nil nil nil 4802 4097 4610 1 1458 #savePackageChanges 8 'Save C&hanges' 1 1 1506 nil true 1552 8 'FileSave.ico' 1600 nil nil 4802 4097 4610 1 1458 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' nil 134217729 nil nil 12503 nil nil 4562 nil true 34 10 4610 1 1458 #renameMethod 8 'Re&name Method...' 1 1 nil nil nil 4610 1 1458 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 4802 4097 4610 1 1458 #safeRemoveMethod 8 'Re&move Method...' 1 1 nil nil nil 4610 1 1458 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 4802 4097 4610 1 1458 #addParameter 8 'Add Method &Parameter...' 1 1 nil nil nil 4610 1 1458 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 nil nil nil 4802 4097 4610 1 1458 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 nil nil nil 8 'Refactorin&gs' #refactoringsMenu 134217729 nil nil 12519 nil nil 4562 nil true 34 3 4610 1 1458 #undoChange 8 '&Undo <1d>' 1 1 1506 nil true 1552 8 'EditUndo.ico' 1600 nil nil 4610 1 1458 #redoChange 8 '&Redo <1d>' 1 1 1506 nil true 1552 8 'EditRedo.ico' 1600 nil nil 4610 1 1458 #clearChangeHistory 8 'Clear Change &History' 1 1 1506 nil true 1552 8 'MethodHistoryErase.ico' 1600 nil nil 8 'H&istory' nil 134217729 nil nil 12527 nil nil 4562 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 12529 nil nil 4562 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 12531 nil nil 4562 nil true 34 15 4610 1 1458 #helpContents 8 '&Contents' 1025 1 1506 nil true 1552 8 'Help.ico' 1600 nil nil 4610 1 1458 #help 8 'On this &Tool' 1249 1 nil nil nil 4610 1 1458 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4802 4097 4610 1 1458 #learnSmalltalk 8 'Learn Smalltalk' 1 1 11810 $🎓 nil 594 #orchid 12864 nil nil 1 nil nil nil nil 4802 4097 4610 1 1458 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4610 1 1458 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4610 1 1458 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4802 4097 4610 1 1458 #dolphinHomePage 8 'Dolphin Homepage' 1 1 1506 nil true 1552 8 '!!APPLICATION' 1600 nil nil 4610 1 1458 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4610 1 1458 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4802 4097 4610 1 1458 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 11810 $🐬 nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 12555 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 994 771 621 1 nil 193 770 138 144 34 1 834 #createWindow: 34 1 882 590342 ##(Smalltalk.Rectangle) 994 6143 21 994 7623 1061 193 448 8 'Package Browser' 416 1 34 3 528 3648 3024 994 193 193 nil 27 )!

toolsFolderHelpId
	^10598!

wordWrapComment
	"Answer true if instances of the receiver use comment word wrapping."

	^WordWrapComment!

wordWrapComment: aBoolean
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrapComment := aBoolean! !

!PackageBrowserShell class categoriesForMethods!
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!public! !
wordWrapComment!accessing!options!public! !
wordWrapComment:!accessing!options!public! !
!

