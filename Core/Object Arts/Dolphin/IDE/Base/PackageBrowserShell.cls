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

	aSymbol == #viewModeSelect ifTrue: [^classesPresenter view buildViewsPopup].
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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1877912960 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Search_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 615 1 882 437 51 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 63 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 976 992 nil 27 8 'imageTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131073 1264 nil nil nil 519 nil nil nil 1264 608 8 1877912960 170 192 976 170 192 34 8 57511 1115206 1 ##(Smalltalk.ToolbarIconButton) 1264 1 1180998 4 ##(Smalltalk.CommandDescription) #savePackageChanges 8 'Save Package Changes' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileSave.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 57511 57509 1394 1264 1 1426 #openPackage 8 'Install Package' 1 1 1474 nil true 1520 8 'FileOpen.ico' 1568 57509 57507 1394 1264 1 1426 #newPackage 8 'New Package' 1 1 1474 nil true 1520 8 'NewPackage.ico' 1568 57507 57513 1394 1264 1 1426 #browsePackageSources 8 'Open Source Browser' 1 1 1474 nil true 1520 8 'SourceBrowser.ico' 1568 57513 34 5 1680 1600 1408 1760 1049158 1 ##(Smalltalk.ToolbarSeparator) 1264 1 nil nil 1 nil nil nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1051 1 882 201 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 113 2 0 0 25 0 0 0] 8 #() 992 nil 27 8 'fileTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853612 131137 2064 nil nil nil 519 nil nil nil 2064 608 8 1877912960 170 192 976 170 192 34 2 57515 1394 2064 273 1426 #viewModeSelect 8 'Views' 1 1 1474 nil true 1520 8 'ViewMode.ico' 1568 57515 34 1 2192 nil nil 1 nil nil nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1251 1 882 65 51 2064 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 113 2 0 0 0 0 0 0 145 2 0 0 25 0 0 0] 8 #() 992 nil 27 8 'viewTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2464 nil nil nil 7 nil nil nil 2464 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 2464 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 170 192 976 8 #() nil nil 1 nil 882 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1449 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 2 0 0 25 0 0 0] 34 5 1024 2464 672 1264 2064 992 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2944 nil 608 nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 882 193 193 nil 2944 nil 8 1877614448 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2944 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3152 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 3248 7 257 nil nil 8 'version' 3154 1 -1 2944 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' 34 1 3328 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2944 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 883 882 1449 41 2944 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 212 2 0 0 205 1 0 0] 8 #() 992 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3568 nil nil nil 7 nil nil nil 3568 1180166 ##(Smalltalk.ProportionalLayout) 170 176 976 true 170 192 976 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1449 833 3568 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 212 2 0 0 185 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 3856 nil nil nil 7 nil nil nil 3856 3634 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 3856 34 2 8 1140850688 131073 3968 nil nil nil 7 nil nil nil 3968 3634 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.CardContainer) 34 16 nil 3968 34 2 8 1140850688 131073 4112 nil nil nil 7 nil nil nil 4112 656710 1 ##(Smalltalk.CardLayout) 138 144 34 8 4082 590662 1 ##(Smalltalk.CardLabel) 8 'Classes' 834 #icon 8 #() ##(Smalltalk.Behavior) nil 410 ##(Smalltalk.ListView) 34 45 nil 4112 34 2 8 1140920395 1 4336 590662 2 ##(Smalltalk.ListModel) 138 144 976 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 608 nil 29 265030 4 ##(Smalltalk.Menu) nil true 34 6 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 1426 #browseClass 8 '&Browse' 1 1 1474 nil true 1520 8 'ClassBrowserShell.ico' 1568 nil nil 4530 1 1426 #browseClassReferences 8 'All Re&ferences' 1 1 nil nil nil 4530 1 1426 #browseLocalClassReferences 8 'L&ocal References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4530 1 1426 #addClass 8 '&Add Uncommitted..' 1 1 nil nil nil 4530 1 1426 #removeClasses 8 '&Remove from Package' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4336 nil 8 1877889248 3186 #name 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 3234 0 nil 1180966 ##(Smalltalk.CompiledExpression) 4 1 3232 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 4944 7 257 nil 882 65 65 nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 41 #left 3234 0 nil 4962 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 5136 7 257 nil 3234 0 nil 4962 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 5248 7 513 nil 3186 #isChanged 8 #() nil 4336 3234 0 nil 4962 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4082 #Package ##(Smalltalk.Package) #changedIcon #imageIndex 5360 7 257 nil 1 nil 3234 0 nil 4962 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx |
ctx item isNonInstantiable ifTrue: [ctx font isItalic: true]]' 8 #[34 105 226 0 159 122 226 2 58 179 106 60 106] #item #isNonInstantiable #font #isItalic: #ifTrue: 5456 7 257 nil 5090 8 'Name' 375 #left 3186 #name 8 #() 3186 #<= 8 #() nil nil 4336 ##(Smalltalk.IconicListAbstract) 1 nil 3234 0 nil 4962 4 1 3232 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 5632 7 257 nil 5090 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3234 0 nil 4962 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5744 7 513 nil 3186 #owningPackage 8 #() nil 4336 nil 1 nil nil 5090 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) 3186 #<= 8 #() 3234 0 nil 4962 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] #fileOutName 5920 7 257 nil nil 4336 nil 1 nil nil #list 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 9 97 882 945 729 4336 834 #contextMenu: 34 1 4496 4336 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 8 #() 992 nil 35 4082 4258 8 'Methods' 834 #icon 4320 3264 nil 410 ##(Smalltalk.ListView) 34 45 nil 4112 34 2 8 1140920393 1 6272 4402 138 144 976 nil 4464 608 nil 29 4482 nil true 34 8 4530 2097153 1426 #browseMethods 8 'Browse <1d>' 1 1 nil nil nil 4530 1 1426 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 nil nil nil 4530 1 1426 #browseMessageReferences 8 'All Re&ferences' 1 1 nil nil nil 4530 1 1426 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 nil nil nil 4530 1 1426 #browseLocalMessageReferences 8 '&Local References' 1 1 nil nil nil 4722 4097 4530 1 1426 #removeLooseMethods 8 '&Remove from Package' 1 1 nil nil nil 4482 nil true 34 7 4530 1 1426 #renameMethod 8 'Re&name' 1 1 nil nil nil 4530 1 1426 #renameMethodReferences 8 'Rename Re&ferences' 1 1 nil nil nil 4722 4097 4530 1 1426 #safeRemoveMethods 8 '&Remove' 1 1 nil nil nil 4722 4097 4530 1 1426 #addParameterToMethod 8 'Add &Parameter...' 1 1 nil nil nil 4482 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 6272 nil 8 1877889248 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4928 nil nil nil 882 65 65 nil nil 138 144 34 3 5090 8 'Selector' 401 #left 3186 #selector 8 #() 3234 0 nil 4962 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] #selector 7168 7 513 nil nil nil 6272 ##(Smalltalk.IconicListAbstract) 1 nil 3234 0 nil 4962 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4082 #ClassBrowserAbstract ##(Smalltalk.ClassBrowserAbstract) #looseMethodColor #forecolor: 7248 7 257 nil 5090 8 'Class' 389 #left ##(Smalltalk.BasicListAbstract) 3186 #<= 8 #() 3186 #methodClass 8 #() nil 6272 ##(Smalltalk.IconicListAbstract) 1 nil 3234 0 nil 4962 4 1 3232 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 7440 7 257 nil 5090 8 'Package' 149 #left ##(Smalltalk.BasicListAbstract) 3234 0 nil 4962 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 7552 7 513 nil 3186 #owningPackage 8 #() nil 6272 nil 3 nil nil #report 6000 nil 131173 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 9 97 882 945 729 6272 834 #contextMenu: 34 1 6368 6272 834 #text: 34 1 8 'Selector' 6272 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 8 #() 992 nil 35 4082 4258 8 'Resources' 834 #icon 4320 736 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4112 34 2 8 1140850688 131073 7968 nil nil nil 5 4482 nil true 34 4 4530 2097153 1426 #editResource 8 '&Edit' 1 1 1474 nil true 1520 8 'ViewComposer.ico' 1568 nil nil 4530 1 1426 #showResource 8 '&Show' 1 1 1474 nil true 1520 8 'TestView.ico' 1568 nil nil 4722 4097 4530 1 1426 #deleteResource 8 '&Delete' 1 1 1474 nil true 1520 8 'EditClear.ico' 1568 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 7968 738 ##(Smalltalk.ResourceListPresenter) #resource_Package_view nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 9 97 882 945 729 7968 834 #contextMenu: 34 1 8032 7968 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 976 992 nil 27 4082 4258 8 'Globals' nil nil 410 ##(Smalltalk.ListView) 34 45 nil 4112 34 2 8 1140920393 1 8576 4402 138 144 976 nil 4464 608 nil 29 4482 nil true 34 6 4530 1 1426 #addGlobal 8 '&Add Uncommitted...' 1 1 nil nil nil 4530 1 1426 #removeGlobals 8 '&Remove from Package' 1 1 nil nil nil 4722 4097 4530 2097153 1426 #inspectGlobals 8 '&Inspect' 1 1 1474 nil true 1520 8 'BasicInspector.ico' 1568 nil nil 4530 1 1426 #browseGlobalReferences 8 'All Re&ferences' 1 1 nil nil nil 4530 1 1426 #browseLocalGlobalReferences 8 '&Local References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 8576 nil 8 1877889248 ##(Smalltalk.BasicListAbstract) 3234 0 nil 4962 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 4082 #Smalltalk ##(Smalltalk) #icon #imageIndex 9024 7 257 nil 4928 nil nil nil 882 65 65 nil nil 138 144 34 4 5090 8 '' 41 #left 3234 0 nil 4962 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 5232 9200 7 257 nil 3234 0 nil 4962 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 9296 7 513 nil 3234 0 nil 4962 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | [(Smalltalk at: x) isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 45 17 148 159 106 47 34 111 59 106 193 106] 9104 #isChanged 4082 #Error ##(Smalltalk.Error) #on:do: 9376 3234 0 nil 9392 39 257 nil 7 257 nil nil 8576 3234 0 nil 4962 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 5440 #changedIcon #imageIndex 9488 7 257 nil 1 nil nil 5090 8 'Global' 301 #left ##(Smalltalk.BasicListAbstract) 3186 #<= 8 #() nil nil 8576 3234 0 nil 4962 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 9104 #icon #imageIndex 9632 7 257 nil 1 nil nil 5090 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3234 0 nil 4962 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 9744 7 513 nil 3234 0 nil 4962 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | Package manager packageOfGlobalNamed: x]' 8 #[32 105 45 159 17 178 106] 5440 #manager #packageOfGlobalNamed: 9824 7 257 nil nil 8576 nil 1 nil nil 5090 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) 3186 #<= 8 #() 3234 0 nil 4962 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | | glob |
glob := Smalltalk at: x.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[34 105 45 17 148 70 144 30 178 120 18 161 106 33 106] 4082 #Smalltalk ##(Smalltalk) #sourceObject #conformsToProtocol: #fileOutName 8 '' 9968 7 65793 nil nil 8576 nil 1 nil nil #report 6000 nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 9 97 882 945 729 8576 834 #contextMenu: 34 1 8672 8576 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 8 #() 992 nil 35 4082 4258 8 'Scripts' nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 4112 34 2 8 1140850688 131073 10320 nil nil nil 5 nil nil nil 10320 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.TabViewXP) 34 28 nil 10320 34 2 8 1140916866 1 10448 4402 138 144 976 nil 4464 608 nil 5 nil nil nil 10448 nil 8 1877659392 3234 0 nil 4962 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] #key 10560 7 257 nil 3234 0 nil 4962 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] #icon #imageIndex 10640 7 257 nil 4928 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 1 882 945 729 10448 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 10448 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 216 1 0 0 108 1 0 0] 8 #() 992 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 10946 #fixedParentRight 1 10946 #fixedParentTop 1 10946 #fixedParentBottom 1 410 ##(Smalltalk.ScintillaView) 34 50 nil 10320 34 2 8 1176572228 1025 11024 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 608 nil 21 4482 nil true 34 13 4530 1 1426 #accept 8 '&Accept' 1 1 nil nil nil 4722 4097 4482 nil true 34 11 4530 1 1426 #undo 8 '&Undo' 1 1 1474 nil true 1520 8 'EditUndo.ico' 1568 nil nil 4722 4097 4530 1 1426 #cutSelection 8 'Cu&t' 1 1 1474 nil true 1520 8 'EditCut.ico' 1568 nil nil 4530 1 1426 #copySelection 8 '&Copy' 1 1 1474 nil true 1520 8 'EditCopy.ico' 1568 nil nil 4530 1 1426 #pasteClipboard 8 '&Paste' 1 1 1474 nil true 1520 8 'EditPaste.ico' 1568 nil nil 4530 1 1426 #clearSelection 8 'De&lete' 1 1 1474 nil true 1520 8 'EditClear.ico' 1568 nil nil 4530 1 1426 #clear 8 'Clea&r' 1 1 1474 nil true 1520 8 'ClearDocument.ico' 1568 nil nil 4722 4097 4530 1 1426 #reformatSource 8 'Re&format' 1 1 nil nil nil 4722 4097 4530 1 1426 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4482 nil true 34 10 4530 1 1426 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4530 1 1426 #cloneNew 8 '&Clone' 1 1 1474 nil true 1520 8 'SmalltalkWorkspace.ico' 1568 nil nil 4722 4097 4530 1 1426 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4530 1 1426 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4530 1 1426 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4530 1 1426 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4530 1 1426 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4530 1 1426 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4530 1 1426 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 4722 4097 4530 1 1426 #browseIt 8 'Bro&wse It' 1 1 1474 nil true 1520 8 'ClassBrowserShell.ico' 1568 nil nil 4530 1 1426 #displayIt 8 '&Display It' 1 1 1474 nil true 1520 8 'DisplayIt.ico' 1568 nil nil 4530 1 1426 #printIt 8 '&Print It' 1 1 1474 nil true 1520 8 'PrintIt.ico' 1568 nil nil 4530 1 1426 #evaluateIt 8 'E&valuate It' 1 1 1474 nil true 1520 8 'EvaluateIt.ico' 1568 nil nil 4530 1 1426 #inspectIt 8 '&Inspect It' 1 1 1474 nil true 1520 8 'BasicInspector.ico' 1568 nil nil 4530 1 1426 #debugIt 8 'Deb&ug It' 1 1 1474 nil true 1520 8 'Debugger.ico' 1568 nil nil 4722 4097 4482 nil true 34 3 4530 2097153 1426 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 4530 1 1426 #browseReferences 8 '&References...' 1 1 nil nil nil 4530 1 1426 #browseMessages 8 '&Messages...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 11024 nil 8 1355169256 852486 ##(Smalltalk.NullConverter) nil nil 9 1725595473 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 594 #gray 594 #white 1 nil nil nil nil #callTip nil nil nil #normal 13298 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 976 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 11024 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 594 #silver nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 13264 nil nil nil nil 16 nil 170 192 34 4 #Warning 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 17 11024 594 #blue 3 false #Warning nil nil nil nil nil nil #Error 13698 19 11024 594 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 13298 1027 594 #darkGoldenrod 594 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 13298 1031 594 #firebrick 594 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 13298 1029 nil 594 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 770 138 144 34 9 834 #createAt:extent: 34 2 882 21 21 882 833 689 11024 834 #contextMenu: 34 1 11152 11024 834 #caretPeriod: 8 #(530) 11024 834 #wordWrap: 8 #(true) 11024 834 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 11024 1 3 nil nil 5 nil 14194 3 11024 1 nil nil 67108863 5 nil 14194 5 11024 1 nil nil nil 5 nil 11024 834 #canHScroll: 8 #(false) 11024 834 #targetRange: 34 1 525062 ##(Smalltalk.Interval) 1 -1 3 11024 834 #maxCompletionListHeight: 8 #(9) 11024 834 #edgeColumn: 8 #(1) 11024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 170 1 0 0 98 1 0 0] 8 #() 992 nil 31 10914 10960 21 10976 -91 10992 21 11008 -19 170 192 34 4 10448 8 'scriptNames' 11024 8 'scriptText' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 97 882 945 729 10320 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 34 2 11024 10448 992 nil 27 4082 4258 8 'Prerequisites' nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4112 34 2 8 1140850688 131073 14752 nil nil nil 5 nil nil nil 14752 738 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 97 882 945 729 14752 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 976 992 nil 27 4082 4258 8 'Dependents' nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4112 34 2 8 1140850688 131073 15024 nil nil nil 5 nil nil nil 15024 738 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 97 882 945 729 15024 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 976 992 nil 27 4082 4258 8 'Comment' nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 4112 34 2 8 1176572228 1 15296 11090 nil false 11136 nil 466 #commentWorkspace nil 7 4482 nil true 34 12 4530 1 1426 #accept 8 '&Accept' 1 1 nil nil nil 4722 4097 4482 nil true 34 10 4530 1 1426 #undo 8 '&Undo' 1 1 1474 nil true 1520 8 'EditUndo.ico' 1568 nil nil 4722 4097 4530 1 1426 #cutSelection 8 'Cu&t' 1 1 1474 nil true 1520 8 'EditCut.ico' 1568 nil nil 4530 1 1426 #copySelection 8 '&Copy' 1 1 1474 nil true 1520 8 'EditCopy.ico' 1568 nil nil 4530 1 1426 #pasteClipboard 8 '&Paste' 1 1 1474 nil true 1520 8 'EditPaste.ico' 1568 nil nil 4530 1 1426 #clearSelection 8 'De&lete' 1 1 1474 nil true 1520 8 'EditClear.ico' 1568 nil nil 4722 4097 4530 1 1426 #clear 8 'Clea&r' 1 1 1474 nil true 1520 8 'ClearDocument.ico' 1568 nil nil 4722 4097 4530 1 1426 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4722 4097 4530 1 1426 #browseIt 8 'Bro&wse It' 1 1 12560 nil nil 4530 1 1426 #displayIt 8 '&Display It' 1 1 1474 nil true 1520 8 'DisplayIt.ico' 1568 nil nil 4530 1 1426 #printIt 12704 1 1 12720 nil nil 4530 1 1426 #evaluateIt 8 'E&valuate It' 1 1 1474 nil true 1520 8 'EvaluateIt.ico' 1568 nil nil 4530 1 1426 #inspectIt 8 '&Inspect It' 1 1 12880 nil nil 4530 1 1426 #debugIt 12944 1 1 12960 nil nil 4722 4097 4482 nil true 34 2 4530 2097153 1426 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 4530 1 1426 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 15296 594 #seaGreen 8 1355169256 13234 nil nil 9 1725569265 170 192 34 50 #lineNumber 13298 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #link 13298 37 196934 1 ##(Smalltalk.RGB) 22282241 nil 33 nil nil nil nil #link nil nil nil #header5 13298 21 16738 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #normal 13298 1 nil 594 #window 1 nil nil nil nil #normal nil nil nil #preChar 13298 25 594 #black 16738 22404573 1 nil nil nil nil #preChar nil 1401 nil #indentGuide 13298 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #header1 13298 13 16738 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #codeBlock 13298 43 16738 17825793 16738 31317469 1 nil nil nil nil #codeBlock nil nil nil #blockQuote 13298 31 16738 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #callTip 13298 77 13328 13344 1 nil nil nil nil #callTip nil nil nil #code2 13298 41 16738 17825793 16738 31317469 1 nil nil nil nil #code2 nil nil nil #strong1 13298 5 16738 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #code 13298 39 16738 17825793 16738 31317469 1 nil nil nil nil #code nil nil nil #em1 13298 9 16738 26317 nil 9 nil nil nil nil #em1 nil nil nil #olistItem 13298 29 16738 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #header2 13298 15 16738 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #strong2 13298 7 16738 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #em2 13298 11 16738 26317 nil 9 nil nil nil nil #em2 nil nil nil #strikeOut 13298 33 16738 7768625 16738 20673875 1 nil nil nil nil #strikeOut nil nil nil #header6 13298 23 16738 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #ulistItem 13298 27 16738 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #horizontalRule 13298 35 16738 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #lineBegin 13298 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #header4 13298 19 16738 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #header3 13298 17 16738 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 13458 1 nil nil nil 15296 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 976 nil 170 176 976 nil nil nil nil nil 13520 nil nil 65 nil nil nil 13616 3 170 192 34 4 #container 170 192 34 4 #callTip 13298 77 13328 13344 1 nil nil nil nil #callTip nil nil nil #normal 13298 1 nil nil 1 nil nil nil nil #normal nil nil nil #markdown 16672 nil nil nil nil 208 nil 170 192 34 4 #Warning 13698 19 15296 13728 3 false #Warning nil nil nil nil nil nil #Error 13698 17 15296 13760 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 13298 1027 13824 13840 1 nil nil nil nil #Warning nil nil nil #Error 13298 1031 13872 13888 1 nil nil nil nil #Error nil nil nil #Notification 13298 1029 nil 13920 1 nil nil nil nil #Notification nil nil nil nil 770 138 144 34 12 834 #createAt:extent: 34 2 882 9 97 882 945 729 15296 834 #contextMenu: 34 1 15392 15296 834 #isDrawingBuffered: 8 #(false) 15296 834 #caretPeriod: 8 #(530) 15296 834 #wordWrap: 8 #(true) 15296 834 #margins: 34 1 34 3 14194 1 15296 1 3 nil nil 5 nil 14194 3 15296 1 nil nil 67108863 5 nil 14194 5 15296 1 nil nil nil 5 nil 15296 834 #targetRange: 34 1 14322 1 -1 3 15296 834 #maxCompletionListHeight: 8 #(9) 15296 834 #edgeColumn: 8 #(1) 15296 834 #setLexerLanguage: 8 #(#markdown) 15296 834 #sciSetTechnology: 8 #(1) 15296 834 #sciSetFontQuality: 8 #(3) 15296 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 8 #() 992 nil 31 15296 nil nil nil 170 192 34 16 4336 8 'classes' 15024 8 'dependents' 7968 8 'resources' 15296 8 'comment' 10320 8 'scripts' 14752 8 'prerequisites' 8576 8 'globals' 6272 8 'methods' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 4112 34 2 8 1140916736 1 18640 4402 138 144 34 8 15264 4272 6224 7920 8544 10288 14720 14992 nil 4464 nil nil 1 nil nil nil 18640 nil 8 1877659392 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4928 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 961 833 18640 834 #setSingleSelection: 8 #(1) 18640 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 18640 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 224 1 0 0 160 1 0 0] 8 #() 992 nil 27 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 961 833 4112 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 224 1 0 0 160 1 0 0] 34 9 15296 4336 6272 7968 8576 10320 14752 15024 18640 992 nil 27 5 false 170 192 34 2 4112 8 'ownedCards' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 489 1 882 961 833 3968 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 0 0 0 0 212 2 0 0 160 1 0 0] 34 1 4112 992 nil 27 5 false 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 3856 34 2 8 1140850688 131073 19392 nil nil nil 7 nil nil nil 19392 738 ##(Smalltalk.PackageSelector) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 479 833 19392 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 239 0 0 0 160 1 0 0] 976 992 nil 27 8 'packages' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1449 833 3856 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 2 0 0 160 1 0 0] 34 3 19392 410 ##(Smalltalk.Splitter) 34 12 nil 3856 34 2 8 1140850688 1 19792 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 19792 nil 1 #left nil nil nil 882 1 1 882 9 9 nil 19888 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 479 1 882 11 833 19792 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 239 0 0 0 0 0 0 0 244 0 0 0 160 1 0 0] 8 #() 992 nil 27 3968 992 nil 27 992 nil 27 170 192 34 4 528 8 'toolbar' 2944 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 10 4482 nil true 34 24 4530 1 1426 #newPackage 8 '&New Package...' 9373 5 1474 nil true 1520 8 'NewPackage.ico' 1568 nil nil 4530 1 1426 #openPackage 8 '&Install Package...' 9375 5 1474 nil true 1520 8 'FileOpen.ico' 1568 nil nil 4530 1 1426 #removePackage 8 '&Uninstall Package' 1 5 nil nil nil 4722 4097 4482 nil true 34 2 4530 2097153 1426 #addClass 8 '&Class...' 1 1 1474 nil true 1520 8 'Behavior.ico' 1568 nil nil 4530 1 1426 #addGlobal 8 '&Global...' 1 1 nil nil nil 8 'Add Unco&mmitted' nil 134217729 nil nil 57527 nil nil 4530 1 1426 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 nil nil nil 4530 1 1426 #synchronizeFilter 8 '&Goto Folder' 1 1 1474 nil true 1520 8 'GotoFolder.ico' 1568 nil nil 4722 4097 4530 1 1426 #savePackages 8 '&Save Package' 1 1 1474 nil true 1520 8 'FileSave.ico' 1568 nil nil 4530 1 1426 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 4530 1 1426 #savePackageAs 8 'Save Package &As...' 1 1 nil nil nil 4722 4097 4530 1 1426 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4530 1 1426 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4722 4097 4530 1 1426 #saveImage 8 'Sa&ve Image' 1 1 1474 nil true 1520 8 'Snapshot.ico' 1568 nil nil 4530 1 1426 #smalltalkExit 8 'E&xit Dolphin' 1 1 1474 nil true 1520 8 'PowerSwitch.ico' 1568 nil nil 4722 4097 4482 nil true 34 1 4530 2097153 1426 #browseTests 8 '&Browse' 1 1 nil nil nil 8 '&Tests' nil 1 1474 nil true 1520 8 'TestRunner.ico' nil nil 57549 nil nil 4482 nil true 34 4 4530 2097153 1426 #deploy 8 '&Deploy Executable...' 13445 1 nil nil nil 4530 1 1426 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 1474 nil true 1520 8 'EnvironmentBrowserShell.ico' 1568 nil nil 4722 4097 4530 1 1426 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 nil nil nil 8 '&Deployment' nil 134217729 1474 nil true 1520 8 'ApplicationDeploymentWizard.ico' 1568 nil 57557 nil nil 4722 4097 4530 1 1426 #inspectPackage 8 'P&roperties' 1 1 1474 nil true 1520 8 'BasicInspector.ico' 1568 nil nil 4722 4097 4530 1 1426 #exit 8 '&Close' 17639 1 12290 $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 57563 nil nil 4482 nil true 34 12 4530 1 1426 #undo 8 '&Undo' 9397 1 1474 nil true 1520 8 'EditUndo.ico' 1568 nil nil 4722 4097 4530 1 1426 #cutSelection 8 'Cu&t' 9393 1 1474 nil true 1520 8 'EditCut.ico' 1568 nil nil 4530 1 1426 #copySelection 8 '&Copy' 9351 1 1474 nil true 1520 8 'EditCopy.ico' 1568 nil nil 4530 1 1426 #pasteClipboard 8 '&Paste' 9389 1 1474 nil true 1520 8 'EditPaste.ico' 1568 nil nil 4530 1 1426 #editDelete 8 '&Delete' 1 1 1474 nil true 1520 8 'EditClear.ico' 1568 nil nil 4722 4097 4530 1 1426 #selectAll 8 'Select &All' 9347 1 nil nil nil 4722 4097 4530 1 1426 #editFind 8 '&Find...' 9357 1 1474 nil true 1520 47 786694 ##(Smalltalk.ShellLibrary) nil nil 4530 1 1426 #findNext 8 'Find &Next' 1253 1 1474 nil true 1520 8 'FindNext.ico' 1568 nil nil 4530 1 1426 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 57583 nil nil 4482 nil true 34 14 4530 1 1426 #browseIt 8 '&Browse It' 9349 1 1474 nil true 1520 8 'ClassBrowserShell.ico' 1568 nil nil 4530 1 1426 #displayIt 8 '&Display It' 9353 1 1474 nil true 1520 8 'DisplayIt.ico' 1568 nil nil 4530 1 1426 #printIt 8 '&Print It' 9377 1 1474 nil true 1520 8 'PrintIt.ico' 1568 nil nil 4530 1 1426 #evaluateIt 8 '&Evaluate It' 9355 1 1474 nil true 1520 8 'EvaluateIt.ico' 1568 nil nil 4530 1 1426 #inspectIt 8 '&Inspect It' 9363 1 1474 nil true 1520 8 'BasicInspector.ico' 1568 nil nil 4530 1 1426 #debugIt 8 'Deb&ug It' 1269 1 1474 nil true 1520 8 'Debugger.ico' 1568 nil nil 4530 1 1426 #fileItIn 8 '&File It In' 1 1 nil nil nil 4722 4097 4530 1 1426 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 4530 1 1426 #browseReferences 8 '&References...' 5367 1 nil nil nil 4722 4097 4530 1 1426 #accept 8 '&Accept' 9383 1 nil nil nil 4722 4097 4482 nil true 34 7 4530 1 1426 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4530 1 1426 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4530 1 1426 #toggleLineEndings 8 'Line &Endings' 1 1 12290 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4530 1 1426 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4530 1 1426 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4530 1 1426 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4530 1 1426 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 1474 nil true 1520 8 'Preferences.ico' 1568 nil 57619 nil nil 8 '&Workspace' nil 134217729 nil nil 57621 nil nil 4482 nil true 34 4 4530 1 1426 #browseLocalMessageDefinitions 8 '&Definitions Of...' 1 1 nil nil nil 4530 1 1426 #browseLocalMessageReferences 8 '&References To...' 1 1 nil nil nil 4722 4097 4530 1 1426 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 57629 nil nil 4482 nil true 34 10 4530 1 1426 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4530 2097153 1426 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4722 4097 4530 1 1426 #checkOut 8 'Check Out &All' 1 1 nil nil nil 4530 1 1426 #checkOutChanges 8 '&Check Out Changes' 9367 1 nil nil nil 4530 1 1426 #checkIn 8 'Check &In' 9387 1 nil nil nil 4722 4097 4530 1 1426 #savePackageChanges 8 'Save C&hanges' 1 1 1474 nil true 1520 8 'FileSave.ico' 1568 nil nil 4722 4097 4530 1 1426 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' nil 134217729 nil nil 57645 nil nil 4482 nil true 34 10 4530 1 1426 #renameMethod 8 'Re&name Method...' 1 1 nil nil nil 4530 1 1426 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 4722 4097 4530 1 1426 #safeRemoveMethod 8 'Re&move Method...' 1 1 nil nil nil 4530 1 1426 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 4722 4097 4530 1 1426 #addParameter 8 'Add Method &Parameter...' 1 1 nil nil nil 4530 1 1426 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 nil nil nil 4722 4097 4530 1 1426 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 nil nil nil 8 'Refactorin&gs' #refactoringsMenu 134217729 nil nil 57661 nil nil 4482 nil true 34 3 4530 1 1426 #undoChange 8 '&Undo <1d>' 1 1 1474 nil true 1520 8 'EditUndo.ico' 1568 nil nil 4530 1 1426 #redoChange 8 '&Redo <1d>' 1 1 1474 nil true 1520 8 'EditRedo.ico' 1568 nil nil 4530 1 1426 #clearChangeHistory 8 'Clear Change &History' 1 1 1474 nil true 1520 8 'MethodHistoryErase.ico' 1568 nil nil 8 'H&istory' nil 134217729 nil nil 57669 nil nil 4482 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 57671 nil nil 4482 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 57673 nil nil 4482 nil true 34 15 4530 1 1426 #helpContents 8 '&Contents' 1025 1 1474 nil true 1520 8 'Help.ico' 1568 nil nil 4530 1 1426 #help 8 'On this &Tool' 1249 1 nil nil nil 4530 1 1426 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4722 4097 4530 1 1426 #learnSmalltalk 8 'Learn Smalltalk' 1 1 12290 $\x1F393 nil 594 #orchid 13344 nil nil 1 nil nil nil nil 4722 4097 4530 1 1426 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4530 1 1426 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4530 1 1426 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4722 4097 4530 1 1426 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1474 nil true 1520 8 '!!APPLICATION' 1568 nil nil 4530 1 1426 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4530 1 1426 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4722 4097 4530 1 1426 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 12290 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 882 771 621 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 1481 1041 416 834 #text: 34 1 8 'Package Browser' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 227 14 0 0 18 2 0 0] 34 3 528 3568 2944 992 nil 27 )!

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

