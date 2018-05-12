"Filed out from Dolphin Smalltalk 7"!

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
!PackageBrowserShell categoriesForClass!Development!MVP-Presenters! !
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
	"Apply the class options to the receiver"

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
	self applyOptions.

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
		initialDirectory: packagesPresenter selectedFolder;
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
	"The receiver has changed in such a way that the caption may need to be refreshed.
	Do this here"

	| text |
	text := 'Package Browser'.
	self hasPackages 
		ifTrue: 
			[text := self singlePackage 
						ifNil: ['Multiple Packages']
						ifNotNil: [:package | '<1d> <2d>' expandMacrosWith: package with: package packageVersion]].
	self caption: text!

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

	commentPresenter view forecolor: Color darkGreen.
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
!PackageBrowserShell categoriesFor: #accept!commands!public! !
!PackageBrowserShell categoriesFor: #addToCommandRoute:!commands!public! !
!PackageBrowserShell categoriesFor: #applyOptions!operations!options!public! !
!PackageBrowserShell categoriesFor: #browseClass!commands!public! !
!PackageBrowserShell categoriesFor: #browseClassReferences!commands!public! !
!PackageBrowserShell categoriesFor: #browseClassReferencesIn:!helpers!private! !
!PackageBrowserShell categoriesFor: #browseDefinitions!commands!public! !
!PackageBrowserShell categoriesFor: #browseGlobalReferences!commands!public! !
!PackageBrowserShell categoriesFor: #browseHierarchy!commands!private! !
!PackageBrowserShell categoriesFor: #browseIt!commands!public! !
!PackageBrowserShell categoriesFor: #browseItCommand!helpers!private! !
!PackageBrowserShell categoriesFor: #browseLocalClassReferences!commands!public! !
!PackageBrowserShell categoriesFor: #browseLocalMessageDefinitions!commands!public! !
!PackageBrowserShell categoriesFor: #browseLocalMessageReferences!commands!public! !
!PackageBrowserShell categoriesFor: #browseLooseMethods:!helpers!private! !
!PackageBrowserShell categoriesFor: #browseMessageDefinitions!commands!public! !
!PackageBrowserShell categoriesFor: #browseMessageDefinitionsIn:!helpers!private! !
!PackageBrowserShell categoriesFor: #browseMessageReferences!commands!public! !
!PackageBrowserShell categoriesFor: #browseMessageReferencesIn:!helpers!private! !
!PackageBrowserShell categoriesFor: #browseMethodClass!commands!public! !
!PackageBrowserShell categoriesFor: #browseMethods!commands!public! !
!PackageBrowserShell categoriesFor: #browsePackages!commands!public! !
!PackageBrowserShell categoriesFor: #browseReferences!commands!public! !
!PackageBrowserShell categoriesFor: #browseSystem!commands!public! !
!PackageBrowserShell categoriesFor: #buildPopupForCommand:!event handling!private! !
!PackageBrowserShell categoriesFor: #cacheCurrentCard!event handling!private! !
!PackageBrowserShell categoriesFor: #canSaveState!private!saved state! !
!PackageBrowserShell categoriesFor: #clearCard:!private!updating! !
!PackageBrowserShell categoriesFor: #clearClasses!private!updating! !
!PackageBrowserShell categoriesFor: #clearComment!private!updating! !
!PackageBrowserShell categoriesFor: #clearDependents!private!updating! !
!PackageBrowserShell categoriesFor: #clearGlobals!private!updating! !
!PackageBrowserShell categoriesFor: #clearMethods!private!updating! !
!PackageBrowserShell categoriesFor: #clearPrerequisites!private!updating! !
!PackageBrowserShell categoriesFor: #clearResources!private!updating! !
!PackageBrowserShell categoriesFor: #clearScriptNames!private!updating! !
!PackageBrowserShell categoriesFor: #createComponents!commands!initializing!private! !
!PackageBrowserShell categoriesFor: #createSchematicWiring!commands!initializing!private! !
!PackageBrowserShell categoriesFor: #defaultHelpId!public! !
!PackageBrowserShell categoriesFor: #global!accessing!public! !
!PackageBrowserShell categoriesFor: #globalNames!accessing!public! !
!PackageBrowserShell categoriesFor: #globals!accessing!public! !
!PackageBrowserShell categoriesFor: #hasClassSelected!public!testing! !
!PackageBrowserShell categoriesFor: #hasEditableMethodSelected!public!testing! !
!PackageBrowserShell categoriesFor: #hasEditableMethodsSelected!public!testing! !
!PackageBrowserShell categoriesFor: #hasMethodSelected!public!testing! !
!PackageBrowserShell categoriesFor: #hasPackages!private!testing! !
!PackageBrowserShell categoriesFor: #hasPackageSelected!public!testing! !
!PackageBrowserShell categoriesFor: #initialize!initializing!private! !
!PackageBrowserShell categoriesFor: #inspectClasses!commands!public! !
!PackageBrowserShell categoriesFor: #inspectCollection:!helpers!private! !
!PackageBrowserShell categoriesFor: #inspectGlobals!commands!public! !
!PackageBrowserShell categoriesFor: #inspectIt!commands!public! !
!PackageBrowserShell categoriesFor: #inspectItCommand!helpers!private! !
!PackageBrowserShell categoriesFor: #inspectMethods!commands!public! !
!PackageBrowserShell categoriesFor: #inspectResources!commands!public! !
!PackageBrowserShell categoriesFor: #isCardUpToDate:!private!testing! !
!PackageBrowserShell categoriesFor: #markCardDirty:!helpers!private! !
!PackageBrowserShell categoriesFor: #objectRepackaged:from:to:card:list:!event handling!private! !
!PackageBrowserShell categoriesFor: #onCardChanged!event handling!private! !
!PackageBrowserShell categoriesFor: #onClassRemoved:!event handling!private! !
!PackageBrowserShell categoriesFor: #onClassRepackaged:from:to:!event handling!private! !
!PackageBrowserShell categoriesFor: #onCloseRequested:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragClasses:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragGlobal:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragMethods:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragOver:type:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragResource:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDropOverPackage:!event handling!private! !
!PackageBrowserShell categoriesFor: #onGlobalRemoved:!event handling!private! !
!PackageBrowserShell categoriesFor: #onGlobalRenamed:from:!event handling!private! !
!PackageBrowserShell categoriesFor: #onGlobalRepackaged:from:to:!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodAdded:!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodRemoved:!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodRepackaged:from:to:!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodSelected!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodUpdated:!event handling!private! !
!PackageBrowserShell categoriesFor: #onPackageChanged:!event handling!private! !
!PackageBrowserShell categoriesFor: #onPackageSelected!event handling!private! !
!PackageBrowserShell categoriesFor: #onPackageSelectionChanging:!private! !
!PackageBrowserShell categoriesFor: #onScriptSelected!event handling!private! !
!PackageBrowserShell categoriesFor: #onViewClosed!event handling!private! !
!PackageBrowserShell categoriesFor: #onViewOpened!event handling!private! !
!PackageBrowserShell categoriesFor: #openWorkspace!commands!public! !
!PackageBrowserShell categoriesFor: #packages!accessing!public! !
!PackageBrowserShell categoriesFor: #packages:!accessing!public! !
!PackageBrowserShell categoriesFor: #promptToSaveChanges!helpers!private! !
!PackageBrowserShell categoriesFor: #promptToSaveChanges:!helpers!private! !
!PackageBrowserShell categoriesFor: #queryCommand:!commands!public! !
!PackageBrowserShell categoriesFor: #refreshCard:!helpers!private! !
!PackageBrowserShell categoriesFor: #release!dependency!public! !
!PackageBrowserShell categoriesFor: #removeClasses!commands!private! !
!PackageBrowserShell categoriesFor: #removeGlobals!commands!private! !
!PackageBrowserShell categoriesFor: #removeLooseMethods!commands!private! !
!PackageBrowserShell categoriesFor: #resourceIdentifier!accessing!private! !
!PackageBrowserShell categoriesFor: #resourceIdentifiers!accessing!private! !
!PackageBrowserShell categoriesFor: #saveComment!commands!private! !
!PackageBrowserShell categoriesFor: #saveScript!operations!private! !
!PackageBrowserShell categoriesFor: #scriptName!accessing!private! !
!PackageBrowserShell categoriesFor: #scriptText!accessing!private! !
!PackageBrowserShell categoriesFor: #scriptText:!accessing!private! !
!PackageBrowserShell categoriesFor: #searchEnvironment!accessing!private! !
!PackageBrowserShell categoriesFor: #selectedClass!accessing!public! !
!PackageBrowserShell categoriesFor: #selectedClasses!accessing!public! !
!PackageBrowserShell categoriesFor: #selectedMethod!accessing!public! !
!PackageBrowserShell categoriesFor: #selectedMethods!accessing!public! !
!PackageBrowserShell categoriesFor: #selectionEnvironment!accessing!private! !
!PackageBrowserShell categoriesFor: #setInitialFocus!operations!public! !
!PackageBrowserShell categoriesFor: #shortCaption!accessing!public! !
!PackageBrowserShell categoriesFor: #showPrerequisitesFor:!helpers!private! !
!PackageBrowserShell categoriesFor: #singlePackage!accessing!public! !
!PackageBrowserShell categoriesFor: #singlePackage:!accessing!public! !
!PackageBrowserShell categoriesFor: #source!accessing!private! !
!PackageBrowserShell categoriesFor: #statusText:!accessing!private! !
!PackageBrowserShell categoriesFor: #updateCaption!public!updating! !
!PackageBrowserShell categoriesFor: #updateCardNow:!private!updating! !
!PackageBrowserShell categoriesFor: #updateCards!private!updating! !
!PackageBrowserShell categoriesFor: #updateClasses!private!updating! !
!PackageBrowserShell categoriesFor: #updateComment!private!updating! !
!PackageBrowserShell categoriesFor: #updateContents!private!updating! !
!PackageBrowserShell categoriesFor: #updateDependents!private!updating! !
!PackageBrowserShell categoriesFor: #updateGlobals!private!updating! !
!PackageBrowserShell categoriesFor: #updateMethods!private!updating! !
!PackageBrowserShell categoriesFor: #updateMethodVersion!event handling!private! !
!PackageBrowserShell categoriesFor: #updatePrerequisites!private!updating! !
!PackageBrowserShell categoriesFor: #updateResources!private!updating! !
!PackageBrowserShell categoriesFor: #updateScriptNames!private!updating! !
!PackageBrowserShell categoriesFor: #updateStatus!private!updating! !
!PackageBrowserShell categoriesFor: #upgradeResources!commands!public! !

!PackageBrowserShell class methodsFor!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'Package Browser'
!

icon
	"Answers an Icon that can be used to represent this class"

	^Package icon!

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
		add: (Aspect boolean: #reuseIfOpen);
		add: (Aspect boolean: #canUseIdeaSpace);
		add: (Aspect boolean: #wordWrapComment);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 196934 1 ##(Smalltalk.RGB) 8 4294967295 nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140851532 131073 544 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 167 4 112 212 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 nil 544 610 640 8 1883438848 170 192 34 8 410 ##(Smalltalk.Toolbar) 34 25 nil 544 34 2 8 1140853612 131137 832 nil 610 640 nil 519 nil nil nil 832 610 640 8 1883438848 170 192 8 #() 170 192 34 2 65363 853766 ##(Smalltalk.ToolbarButton) 65363 nil 832 17 1180998 4 ##(Smalltalk.CommandDescription) #viewModeSelect 18 5 86 105 101 119 115 1 1 nil 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 18 11 86 105 101 119 66 97 114 46 98 109 112 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 18 14 100 111 108 112 104 105 110 100 114 55 46 100 108 108 nil nil 7 738 129 33 3 34 1 1024 170 176 34 2 1104 1 nil 1 nil 738 33 33 738 45 45 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 738 1253 1 738 77 51 832 1378 #updateSizePosted 960 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 114 2 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 8 #() 738 193 193 nil 27 18 9 118 105 101 119 84 111 111 108 115 410 ##(Smalltalk.Toolbar) 34 25 nil 544 34 2 8 1140853580 131073 1568 nil 610 640 nil 519 nil nil nil 1568 610 640 8 1883438848 170 192 960 170 192 34 8 65355 1115910 ##(Smalltalk.ToolbarIconButton) 65355 nil 1568 1 1042 #newPackage 18 11 78 101 119 32 80 97 99 107 97 103 101 1 1 263494 3 ##(Smalltalk.Icon) nil true 1136 18 17 68 111 99 117 109 101 110 116 83 104 101 108 108 46 105 99 111 nil 1090 nil true nil nil nil nil 3 738 33 33 1 65357 1730 65357 nil 1568 1 1042 #openPackage 18 15 73 110 115 116 97 108 108 32 80 97 99 107 97 103 101 1 1 1794 nil true 1136 18 12 70 105 108 101 79 112 101 110 46 105 99 111 1184 1090 nil true nil nil nil nil 3 738 33 33 1 65359 1730 65359 nil 1568 1 1042 #savePackageChanges 18 20 83 97 118 101 32 80 97 99 107 97 103 101 32 67 104 97 110 103 101 115 1 1 1794 nil true 1136 18 12 70 105 108 101 83 97 118 101 46 105 99 111 1184 1090 nil true nil nil nil nil 3 738 33 33 1 65361 1730 65361 nil 1568 1 1042 #browsePackageSources 18 19 79 112 101 110 32 83 111 117 114 99 101 32 66 114 111 119 115 101 114 1 1 1794 nil true 1136 18 17 83 111 117 114 99 101 77 97 110 97 103 101 114 46 105 99 111 1184 1090 nil true nil nil nil nil 3 738 33 33 1 34 5 1744 1872 1984 2096 1050118 ##(Smalltalk.ToolbarSeparator) nil nil 1568 3 nil 1 170 176 34 8 1952 3 2064 5 2176 7 1840 1 nil 1 nil 738 33 33 738 45 45 nil nil 1314 138 144 34 2 1378 #createAt:extent: 34 2 738 1053 1 738 201 51 1568 1378 #updateSizePosted 960 1568 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 114 2 0 0 25 0 0 0] 8 #() 1536 nil 27 18 9 102 105 108 101 84 111 111 108 115 410 ##(Smalltalk.ReferenceView) 34 14 nil 544 34 2 8 1140850688 131073 2512 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 2512 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 63 1 738 991 51 2512 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 960 1536 nil 27 18 14 115 109 97 108 108 116 97 108 107 84 111 111 108 115 410 ##(Smalltalk.ReferenceView) 34 14 nil 544 34 2 8 1140850688 131073 2800 nil 2578 31 nil 7 nil nil nil 2800 2610 ##(Smalltalk.Toolbar) #resource_Image_tools nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 1 1 738 63 51 2800 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 960 1536 nil 27 18 10 105 109 97 103 101 84 111 111 108 115 170 192 960 8 #() 170 176 960 nil 1 nil 738 33 33 738 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1314 138 144 34 2 1378 #createAt:extent: 34 2 738 1 1 738 1389 51 544 1378 #updateSizePosted 960 544 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 25 0 0 0] 34 4 2800 2512 1568 832 1536 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 3344 nil 610 640 nil 7 nil 658 nil true 690 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 738 193 193 nil 3344 nil 8 1883301568 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 3344 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3536 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 3632 7 257 nil nil 18 7 118 101 114 115 105 111 110 3538 1 -1 3344 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 18 6 101 114 114 111 114 115 34 1 3712 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3344 nil nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 1 883 738 1389 41 3344 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 182 2 0 0 205 1 0 0] 8 #() 1536 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3984 nil nil nil 7 nil nil nil 3984 1180166 ##(Smalltalk.ProportionalLayout) 170 176 960 true 170 192 960 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 1 51 738 1389 833 3984 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 182 2 0 0 185 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3984 34 2 8 1140850688 131073 4272 nil nil nil 7 nil nil nil 4272 4050 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 4272 34 2 8 1140850688 131073 4384 nil nil nil 7 nil nil nil 4384 4050 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.CardContainer) 34 16 nil 4384 34 2 8 1140850688 131073 4528 nil 610 8 4278190080 nil 7 nil nil nil 4528 655878 ##(Smalltalk.CardLayout) 138 144 34 8 4498 18 7 83 99 114 105 112 116 115 410 ##(Smalltalk.ContainerView) 34 15 nil 4528 34 2 8 1140850688 131073 4720 nil 610 4608 nil 5 nil nil nil 4720 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.TabView) 34 23 nil 4720 34 2 8 1140916866 1 4864 590662 2 ##(Smalltalk.ListModel) 138 144 960 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 610 4608 nil 5 nil nil nil 4864 nil 8 1883225328 3618 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 12 91 58 120 32 124 32 120 32 107 101 121 93 8 #[30 105 17 158 106] #key 5040 7 257 nil 3618 0 nil 5058 3 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 30 91 58 120 32 124 32 120 32 118 97 108 117 101 32 105 99 111 110 32 105 109 97 103 101 73 110 100 101 120 93 8 #[31 105 17 142 158 159 106] #icon #imageIndex 5136 7 257 nil 3744 nil nil nil nil nil #smallIcons 1314 138 144 34 2 1378 #createAt:extent: 34 2 738 1 1 738 899 743 4864 1378 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4864 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 193 1 0 0 115 1 0 0] 8 #() 1536 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 5442 #fixedParentRight 1 5442 #fixedParentTop 1 5442 #fixedParentBottom 1 410 ##(Smalltalk.ScintillaView) 34 50 nil 4720 34 2 8 1176572228 1025 5520 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 610 4608 nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 16 984134 2 ##(Smalltalk.CommandMenuItem) 1 1042 #accept 18 7 38 65 99 99 101 112 116 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5666 nil true 34 9 5714 1 1042 #undo 18 5 38 85 110 100 111 1 1 nil nil nil 5778 4097 5714 1 1042 #cutSelection 18 4 67 117 38 116 1 1 nil nil nil 5714 1 1042 #copySelection 18 5 38 67 111 112 121 1 1 nil nil nil 5714 1 1042 #pasteClipboard 18 6 38 80 97 115 116 101 1 1 nil nil nil 5714 1 1042 #clearSelection 18 7 68 101 38 108 101 116 101 1 1 nil nil nil 5714 1 1042 #reformatSource 18 9 82 101 38 102 111 114 109 97 116 1 1 nil nil nil 5778 4097 5714 1 1042 #selectAll 18 11 38 83 101 108 101 99 116 32 65 108 108 1 1 nil nil nil 18 5 38 69 100 105 116 nil 134217729 nil nil nil nil nil 5714 1 1042 #clear 18 6 67 108 101 97 38 114 1 1 nil nil nil 5778 4097 5714 1 1042 #browseIt 18 10 66 114 111 38 119 115 101 32 73 116 1 1 1794 nil true 1136 18 21 67 108 97 115 115 66 114 111 119 115 101 114 83 104 101 108 108 46 105 99 111 1184 nil nil 5714 1 1042 #displayIt 18 11 38 68 105 115 112 108 97 121 32 73 116 1 1 nil nil nil 5714 1 1042 #evaluateIt 18 12 69 38 118 97 108 117 97 116 101 32 73 116 1 1 nil nil nil 5714 1 1042 #inspectIt 18 11 38 73 110 115 112 101 99 116 32 73 116 1 1 1794 nil true 1136 18 18 66 97 115 105 99 73 110 115 112 101 99 116 111 114 46 105 99 111 1184 nil nil 5714 1 1042 #debugIt 18 9 68 101 98 38 117 103 32 73 116 1 1 1794 nil true 1136 18 12 68 101 98 117 103 103 101 114 46 105 99 111 1184 nil nil 5778 4097 5714 1 1042 #chooseEvaluationPools 18 9 38 80 111 111 108 115 46 46 46 1 1 nil nil nil 5714 1 1042 #inspectWorkspacePool 18 10 86 97 114 105 97 98 38 108 101 115 1 1 nil nil nil 5714 1 1042 #cloneNew 18 6 67 108 111 38 110 101 1 1 nil nil nil 5778 4097 5666 nil true 34 3 5714 2097153 1042 #browseDefinitions 18 15 68 101 102 105 38 110 105 116 105 111 110 115 46 46 46 1 1 nil nil nil 5714 1 1042 #browseReferences 18 14 38 82 101 102 101 114 101 110 99 101 115 46 46 46 1 1 nil nil nil 5714 1 1042 #browseMessages 18 12 38 77 101 115 115 97 103 101 115 46 46 46 1 1 nil nil nil 18 7 38 66 114 111 119 115 101 nil 134217729 nil nil nil nil nil 18 10 38 87 111 114 107 115 112 97 99 101 nil 134217729 nil nil nil nil nil nil nil 5520 nil 1469676409 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7074 77 786694 ##(Smalltalk.IndexedColor) 33554457 7122 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 7088 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 960 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 5520 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 960 nil 170 176 960 9215 nil nil nil nil 7122 33554447 nil nil 65 nil nil 170 192 34 6 #literalBytes 18 2 91 93 #specialCharacter 18 6 40 41 91 93 60 62 #literalArray 18 2 40 41 18 0 3 170 192 34 2 #container 7040 nil nil nil nil 3 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 5520 33423361 3 false #Warning nil nil nil nil nil nil #Error 7506 19 5520 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 7074 1029 nil 466 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 7074 1027 466 60239 466 31326207 1 nil nil nil nil #Warning nil nil nil #Error 7074 1031 466 335 466 31317503 1 nil nil nil nil #Error nil nil nil nil 1314 138 144 34 8 1378 #createAt:extent: 34 2 738 21 21 738 787 703 5520 1378 #contextMenu: 34 1 5680 5520 1378 #modificationEventMask: 8 #(4607) 5520 1378 #caretPeriod: 8 #(530) 5520 1378 #wordWrap: 8 #(true) 5520 1378 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 5520 1 3 nil nil 5 nil 8002 3 5520 1 nil nil 67108863 5 nil 8002 5 5520 1 nil nil nil 5 nil 5520 1378 #canHScroll: 8 #(false) 5520 1378 #maxCompletionListHeight: 8 #(9) 5520 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 147 1 0 0 105 1 0 0] 8 #() 1536 nil 29 5410 5456 21 5472 -91 5488 21 5504 -19 170 192 34 4 4864 18 11 115 99 114 105 112 116 78 97 109 101 115 5520 18 10 115 99 114 105 112 116 84 101 120 116 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 9 89 738 905 737 4720 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 200 1 0 0 156 1 0 0] 34 2 5520 4864 1536 nil 27 4498 18 13 80 114 101 114 101 113 117 105 115 105 116 101 115 410 ##(Smalltalk.ReferenceView) 34 14 nil 4528 34 2 8 1140850688 131073 8448 nil nil nil 5 nil nil nil 8448 2610 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 9 89 738 905 737 8448 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 200 1 0 0 156 1 0 0] 960 1536 nil 27 4498 18 7 67 111 109 109 101 110 116 410 ##(Smalltalk.ScintillaView) 34 50 nil 4528 34 2 8 1176572228 1 8704 5586 nil false 5632 nil 466 30932991 nil 7 5666 nil true 34 12 5714 1 1042 #accept 18 7 38 65 99 99 101 112 116 1 1 nil nil nil 5778 4097 5666 nil true 34 8 5714 1 1042 #undo 18 5 38 85 110 100 111 1 1 nil nil nil 5778 4097 5714 1 1042 #cutSelection 18 4 67 117 38 116 1 1 nil nil nil 5714 1 1042 #copySelection 18 5 38 67 111 112 121 1 1 nil nil nil 5714 1 1042 #pasteClipboard 18 6 38 80 97 115 116 101 1 1 nil nil nil 5714 1 1042 #clearSelection 18 7 68 101 38 108 101 116 101 1 1 nil nil nil 5778 4097 5714 1 1042 #selectAll 18 11 38 83 101 108 101 99 116 32 65 108 108 1 1 nil nil nil 18 5 38 69 100 105 116 nil 134217729 nil nil nil nil nil 5714 1 1042 #clear 18 6 67 108 101 97 38 114 1 1 nil nil nil 5778 4097 5714 1 1042 #browseIt 18 10 66 114 111 38 119 115 101 32 73 116 1 1 6336 nil nil 5714 1 1042 #displayIt 18 11 38 68 105 115 112 108 97 121 32 73 116 1 1 nil nil nil 5714 1 1042 #evaluateIt 18 12 69 38 118 97 108 117 97 116 101 32 73 116 1 1 nil nil nil 5714 1 1042 #inspectIt 18 11 38 73 110 115 112 101 99 116 32 73 116 1 1 6512 nil nil 5714 1 1042 #debugIt 6576 1 1 6592 nil nil 5778 4097 5666 nil true 34 2 5714 2097153 1042 #browseDefinitions 18 15 68 101 102 105 38 110 105 116 105 111 110 115 46 46 46 1 1 nil nil nil 5714 1 1042 #browseReferences 18 14 38 82 101 102 101 114 101 110 99 101 115 46 46 46 1 1 nil nil nil 18 7 38 66 114 111 119 115 101 nil 134217729 nil nil nil nil nil 18 10 38 87 111 114 107 115 112 97 99 101 nil 134217729 nil nil nil nil nil nil nil 8704 466 8454145 1469676409 7010 nil nil 9 nil 170 192 34 4 #normal 7074 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7074 77 7136 7152 1 nil nil nil nil #callTip nil nil nil 34 40 9792 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 7266 1 nil nil nil 8704 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 960 nil 170 176 960 9215 nil nil nil nil 7328 nil nil 65 nil nil nil 7424 3 170 192 34 2 #container 9760 nil nil nil nil 1 nil 170 192 34 4 #Warning 7506 19 8704 33423361 3 false #Warning nil nil nil nil nil nil #Error 7506 17 8704 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 7074 1029 nil 466 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 7074 1027 466 60239 466 31326207 1 nil nil nil nil #Warning nil nil nil #Error 7074 1031 466 335 466 31317503 1 nil nil nil nil #Error nil nil nil nil 1314 138 144 34 8 1378 #createAt:extent: 34 2 738 9 89 738 905 737 8704 1378 #contextMenu: 34 1 8800 8704 1378 #modificationEventMask: 8 #(4607) 8704 1378 #caretPeriod: 8 #(530) 8704 1378 #wordWrap: 8 #(true) 8704 1378 #margins: 34 1 34 3 8002 1 8704 1 3 nil nil 5 nil 8002 3 8704 1 nil nil 67108863 5 nil 8002 5 8704 1 nil nil nil 5 nil 8704 1378 #maxCompletionListHeight: 8 #(9) 8704 1378 #sciSetCodePage: 8 #(65001) 8704 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1536 nil 29 4498 18 10 68 101 112 101 110 100 101 110 116 115 410 ##(Smalltalk.ReferenceView) 34 14 nil 4528 34 2 8 1140850688 131073 10688 nil nil nil 5 nil nil nil 10688 2610 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 9 89 738 905 737 10688 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 200 1 0 0 156 1 0 0] 960 1536 nil 27 4498 18 13 76 111 111 115 101 32 77 101 116 104 111 100 115 410 ##(Smalltalk.ListView) 34 30 nil 4528 34 2 8 1140920393 1 10944 4930 138 144 960 nil 4992 610 4608 nil 29 5666 nil true 34 10 5714 2097153 1042 #browseMethods 18 11 66 114 111 119 115 101 32 60 49 100 62 1 1 nil nil nil 5714 1 1042 #browseMessageDefinitions 18 16 65 108 108 32 68 101 102 105 38 110 105 116 105 111 110 115 1 1 nil nil nil 5714 1 1042 #browseMessageReferences 18 15 65 108 108 32 82 101 38 102 101 114 101 110 99 101 115 1 1 nil nil nil 5714 1 1042 #browseLocalMessageDefinitions 18 18 76 111 99 97 108 32 38 68 101 102 105 110 105 116 105 111 110 115 1 1 nil nil nil 5714 1 1042 #browseLocalMessageReferences 18 17 38 76 111 99 97 108 32 82 101 102 101 114 101 110 99 101 115 1 1 nil nil nil 5778 4097 5714 1 1042 #removeLooseMethods 18 20 38 82 101 109 111 118 101 32 102 114 111 109 32 80 97 99 107 97 103 101 1 1 nil nil nil 5666 nil true 34 7 5714 1 1042 #renameMethod 18 7 82 101 38 110 97 109 101 1 1 nil nil nil 5714 1 1042 #renameMethodReferences 18 18 82 101 110 97 109 101 32 82 101 38 102 101 114 101 110 99 101 115 1 1 nil nil nil 5778 4097 5714 1 1042 #safeRemoveMethods 18 7 38 82 101 109 111 118 101 1 1 nil nil nil 5778 4097 5714 1 1042 #addParameterToMethod 18 17 65 100 100 32 38 80 97 114 97 109 101 116 101 114 46 46 46 1 1 nil nil nil 5666 nil true 8 #() 18 17 82 101 109 111 38 118 101 32 80 97 114 97 109 101 116 101 114 #removeParameterMenu 134217729 nil nil nil nil nil 18 13 82 101 102 97 99 116 111 114 105 110 38 103 115 #methodRefactoringsMenu 134217729 nil nil nil nil nil 5778 4097 5666 nil true 34 1 5714 1 1042 #browseLooseMethodEditions 18 16 66 114 111 119 115 101 32 38 69 100 105 116 105 111 110 115 1 1 nil nil nil 18 8 67 38 104 97 110 103 101 115 nil 134217729 nil nil nil nil nil 18 0 nil 134217729 nil nil nil nil nil nil nil 10944 nil 8 1883516016 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3744 nil nil nil 738 65 65 nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 18 8 83 101 108 101 99 116 111 114 401 #left 3570 #selector 8 #() 3618 0 nil 5058 2 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 33 91 58 97 32 58 98 32 124 32 97 32 115 101 108 101 99 116 111 114 32 60 32 98 32 115 101 108 101 99 116 111 114 93 8 #[30 105 17 158 18 158 128 106] #selector 11984 7 513 nil nil nil 10944 ##(Smalltalk.IconicListAbstract) 1 nil 3618 0 nil 5058 4 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 63 91 58 99 116 120 32 124 32 13 10 99 116 120 32 102 111 114 101 99 111 108 111 114 58 32 67 108 97 115 115 66 114 111 119 115 101 114 65 98 115 116 114 97 99 116 32 108 111 111 115 101 77 101 116 104 111 100 67 111 108 111 114 93 8 #[32 105 17 45 159 178 106] 4498 #ClassBrowserAbstract ##(Smalltalk.ClassBrowserAbstract) #looseMethodColor #forecolor: 12064 7 257 nil 11906 18 5 67 108 97 115 115 389 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3570 #methodClass 8 #() nil 10944 ##(Smalltalk.IconicListAbstract) 1 nil 3618 0 nil 5058 4 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 35 91 58 99 116 120 32 124 32 99 116 120 32 102 111 114 101 99 111 108 111 114 58 32 67 111 108 111 114 32 98 108 97 99 107 93 8 #[32 105 17 45 159 178 106] 4498 #Color ##(Smalltalk.Color) #black #forecolor: 12224 7 257 nil 11906 18 7 80 97 99 107 97 103 101 109 #left ##(Smalltalk.BasicListAbstract) 3618 0 nil 5058 2 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 25 91 58 97 32 58 98 32 124 32 97 32 110 97 109 101 32 60 32 98 32 110 97 109 101 93 8 #[30 105 17 158 18 158 128 106] #name 12352 7 513 nil 3570 #owningPackage 8 #() nil 10944 nil 3 nil nil #report 960 nil 131173 nil 8 #(nil) 1314 138 144 34 3 1378 #createAt:extent: 34 2 738 9 89 738 905 737 10944 1378 #contextMenu: 34 1 11056 10944 1378 #text: 34 1 721014 1 ##(Smalltalk.Utf16String) 8 83 101 108 101 99 116 111 114 10944 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1536 nil 27 4498 18 7 71 108 111 98 97 108 115 410 ##(Smalltalk.ListView) 34 30 nil 4528 34 2 8 1140920393 1 12768 4930 138 144 960 nil 4992 610 4608 nil 29 5666 nil true 34 6 5714 1 1042 #addGlobal 18 19 38 65 100 100 32 85 110 99 111 109 109 105 116 116 101 100 46 46 46 1 1 nil nil nil 5714 1 1042 #removeGlobals 18 20 38 82 101 109 111 118 101 32 102 114 111 109 32 80 97 99 107 97 103 101 1 1 nil nil nil 5778 4097 5714 2097153 1042 #inspectGlobals 18 8 38 73 110 115 112 101 99 116 1 1 nil nil nil 5714 1 1042 #browseGlobalReferences 18 15 65 108 108 32 82 101 38 102 101 114 101 110 99 101 115 1 1 nil nil nil 5714 1 1042 #browseLocalGlobalReferences 18 17 38 76 111 99 97 108 32 82 101 102 101 114 101 110 99 101 115 1 1 nil nil nil 18 0 nil 134217729 nil nil nil nil nil nil nil 12768 nil 8 1883516016 ##(Smalltalk.BasicListAbstract) 3618 0 nil 5058 4 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 40 91 58 120 32 124 32 40 83 109 97 108 108 116 97 108 107 32 97 116 58 32 120 41 32 105 99 111 110 32 105 109 97 103 101 73 110 100 101 120 93 8 #[32 105 45 17 148 159 160 106] 4498 #Smalltalk ##(Smalltalk) #icon #imageIndex 13200 7 257 nil 3744 nil nil nil 738 65 65 nil nil 138 144 34 4 11906 18 0 41 #left 3618 0 nil 5058 3 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 42 91 58 120 32 124 32 120 32 105 102 84 114 117 101 58 32 91 39 67 104 97 110 103 101 100 39 93 32 105 102 70 97 108 115 101 58 32 91 39 39 93 93 8 #[31 105 17 119 29 106 30 106] 18 7 67 104 97 110 103 101 100 18 0 13376 7 257 nil 3618 0 nil 5058 3 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 19 91 58 120 32 58 121 32 124 32 120 32 38 32 121 32 110 111 116 93 8 #[31 105 233 1 158 177 106] #not #& 13488 7 513 nil 3618 0 nil 5058 6 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 63 91 58 120 32 124 32 91 40 83 109 97 108 108 116 97 108 107 32 97 116 58 32 120 41 32 105 115 67 104 97 110 103 101 100 93 32 111 110 58 32 69 114 114 111 114 32 100 111 58 32 91 58 121 32 124 32 102 97 108 115 101 93 93 8 #[33 105 17 252 0 0 0 2 5 0 45 17 148 159 106 47 34 111 59 106 193 106] 13280 #isChanged 4498 #Error ##(Smalltalk.Error) #on:do: 13568 3618 0 nil 13584 39 257 nil 7 257 nil nil 12768 3618 0 nil 5058 4 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 49 91 58 120 32 124 32 120 32 105 102 84 114 117 101 58 32 91 80 97 99 107 97 103 101 32 99 104 97 110 103 101 100 73 99 111 110 32 105 109 97 103 101 73 110 100 101 120 93 93 8 #[32 105 17 121 45 159 160 106 60 106] 4498 #Package ##(Smalltalk.Package) #changedIcon #imageIndex 13680 7 257 nil 1 nil nil 11906 18 6 71 108 111 98 97 108 301 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 12768 3618 0 nil 5058 4 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 40 91 58 120 32 124 32 40 83 109 97 108 108 116 97 108 107 32 97 116 58 32 120 41 32 105 99 111 110 32 105 109 97 103 101 73 110 100 101 120 93 8 #[32 105 45 17 148 159 160 106] 13280 #icon #imageIndex 13808 7 257 nil 1 nil nil 11906 18 7 80 97 99 107 97 103 101 201 #left ##(Smalltalk.BasicListAbstract) 3618 0 nil 5058 2 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 25 91 58 97 32 58 98 32 124 32 97 32 110 97 109 101 32 60 32 98 32 110 97 109 101 93 8 #[30 105 17 158 18 158 128 106] #name 13920 7 513 nil 3618 0 nil 5058 4 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 46 91 58 120 32 124 32 80 97 99 107 97 103 101 32 109 97 110 97 103 101 114 32 112 97 99 107 97 103 101 79 102 71 108 111 98 97 108 78 97 109 101 100 58 32 120 93 8 #[32 105 45 159 17 178 106] 13760 #manager #packageOfGlobalNamed: 14000 7 257 nil nil 12768 nil 1 nil nil 11906 18 13 70 105 108 101 32 79 117 116 32 78 97 109 101 2001 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3618 0 nil 5058 6 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 130 91 58 120 32 124 32 124 32 103 108 111 98 32 124 13 10 103 108 111 98 32 58 61 32 83 109 97 108 108 116 97 108 107 32 97 116 58 32 120 46 13 10 40 103 108 111 98 32 99 108 97 115 115 32 99 111 110 102 111 114 109 115 84 111 80 114 111 116 111 99 111 108 58 32 35 115 111 117 114 99 101 79 98 106 101 99 116 41 32 105 102 84 114 117 101 58 32 91 103 108 111 98 32 102 105 108 101 79 117 116 78 97 109 101 93 32 105 102 70 97 108 115 101 58 32 91 39 39 93 93 8 #[34 105 45 17 148 70 144 30 178 120 18 161 106 33 106] 4498 #Smalltalk ##(Smalltalk) #sourceObject #conformsToProtocol: #fileOutName 18 0 14112 7 65793 nil nil 12768 nil 1 nil nil #report 960 nil 133221 nil 8 #(nil) 1314 138 144 34 2 1378 #createAt:extent: 34 2 738 9 89 738 905 737 12768 1378 #contextMenu: 34 1 12880 12768 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1536 nil 27 4498 18 7 67 108 97 115 115 101 115 410 ##(Smalltalk.ListView) 34 30 nil 4528 34 2 8 1140920395 1 14464 4930 138 144 960 nil 4992 610 4608 nil 29 5666 nil true 34 8 5714 2097153 1042 #browseClass 18 7 38 66 114 111 119 115 101 1 1 1794 nil true 1136 18 21 67 108 97 115 115 66 114 111 119 115 101 114 83 104 101 108 108 46 105 99 111 1184 nil nil 5714 1 1042 #browseClassReferences 18 15 65 108 108 32 82 101 38 102 101 114 101 110 99 101 115 1 1 nil nil nil 5714 1 1042 #browseLocalClassReferences 18 17 76 38 111 99 97 108 32 82 101 102 101 114 101 110 99 101 115 1 1 nil nil nil 5778 4097 5714 1 1042 #addClass 18 18 38 65 100 100 32 85 110 99 111 109 109 105 116 116 101 100 46 46 1 1 nil nil nil 5714 1 1042 #removeClasses 18 20 38 82 101 109 111 118 101 32 102 114 111 109 32 80 97 99 107 97 103 101 1 1 nil nil nil 5778 4097 5666 nil true 34 2 5714 1 1042 #browseClassEditions 18 22 66 114 111 119 115 101 32 67 108 97 115 115 32 38 69 100 105 116 105 111 110 115 1 1 nil nil nil 5714 1 1042 #compareClass 18 24 67 111 109 112 97 114 101 32 67 108 97 115 115 32 69 100 105 116 105 111 110 46 46 46 1 1 nil nil nil 18 8 67 38 104 97 110 103 101 115 nil 134217729 nil nil nil nil nil 18 0 nil 134217729 nil nil nil nil nil nil nil 14464 nil 8 1883516016 3570 #name 8 #() ##(Smalltalk.IconicListAbstract) 3744 nil nil nil 738 65 65 nil nil 138 144 34 4 11906 18 0 41 #left 3618 0 nil 5058 3 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 42 91 58 120 32 124 32 120 32 105 102 84 114 117 101 58 32 91 39 67 104 97 110 103 101 100 39 93 32 105 102 70 97 108 115 101 58 32 91 39 39 93 93 8 #[31 105 17 119 29 106 30 106] 18 7 67 104 97 110 103 101 100 13472 15200 7 257 nil 3618 0 nil 5058 3 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 19 91 58 120 32 58 121 32 124 32 120 32 38 32 121 32 110 111 116 93 8 #[31 105 233 1 158 177 106] #not #& 15296 7 513 nil 3570 #isChanged 8 #() nil 14464 3618 0 nil 5058 4 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 49 91 58 120 32 124 32 120 32 105 102 84 114 117 101 58 32 91 80 97 99 107 97 103 101 32 99 104 97 110 103 101 100 73 99 111 110 32 105 109 97 103 101 73 110 100 101 120 93 93 8 #[32 105 17 121 45 159 160 106 60 106] 13760 #changedIcon #imageIndex 15408 7 257 nil 1 nil nil 11906 18 4 78 97 109 101 375 #left 3570 #name 8 #() ##(Smalltalk.SortedCollection) nil nil 14464 ##(Smalltalk.IconicListAbstract) 1 nil nil 11906 18 7 80 97 99 107 97 103 101 201 #left ##(Smalltalk.BasicListAbstract) 3618 0 nil 5058 2 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 25 91 58 97 32 58 98 32 124 32 97 32 110 97 109 101 32 60 32 98 32 110 97 109 101 93 8 #[30 105 17 158 18 158 128 106] #name 15584 7 513 nil 3570 #owningPackage 8 #() nil 14464 nil 1 nil nil 11906 18 13 70 105 108 101 32 79 117 116 32 78 97 109 101 2001 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3618 0 nil 5058 2 1 ##(Smalltalk.UndefinedObject) 18 4 100 111 73 116 18 20 91 58 120 32 124 32 120 32 102 105 108 101 79 117 116 78 97 109 101 93 8 #[30 105 17 158 106] #fileOutName 15728 7 257 nil nil 14464 nil 1 nil nil #list 960 nil 133221 nil 8 #(nil) 1314 138 144 34 2 1378 #createAt:extent: 34 2 738 9 89 738 905 737 14464 1378 #contextMenu: 34 1 14576 14464 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1536 nil 27 4498 18 9 82 101 115 111 117 114 99 101 115 410 ##(Smalltalk.ReferenceView) 34 14 nil 4528 34 2 8 1140850688 131073 16048 nil 610 8 4278190080 nil 5 5666 nil true 34 4 5714 2097153 1042 #editResource 18 5 38 69 100 105 116 1 1 nil nil nil 5714 1 1042 #showResource 18 5 38 83 104 111 119 1 1 nil nil nil 5778 4097 5714 1 1042 #deleteResource 18 7 38 68 101 108 101 116 101 1 1 nil nil nil 18 0 nil 134217729 nil nil nil nil nil nil nil 16048 2610 ##(Smalltalk.ResourceListPresenter) #resource_Package_view nil 1314 138 144 34 2 1378 #createAt:extent: 34 2 738 9 89 738 905 737 16048 1378 #contextMenu: 34 1 16144 16048 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 44 0 0 0 200 1 0 0 156 1 0 0] 960 1536 nil 27 8704 170 192 34 16 8704 18 7 99 111 109 109 101 110 116 10944 18 7 109 101 116 104 111 100 115 12768 18 7 103 108 111 98 97 108 115 16048 18 9 114 101 115 111 117 114 99 101 115 14464 18 7 99 108 97 115 115 101 115 8448 18 13 112 114 101 114 101 113 117 105 115 105 116 101 115 10688 18 10 100 101 112 101 110 100 101 110 116 115 4720 18 7 115 99 114 105 112 116 115 nil 410 ##(Smalltalk.TabView) 34 23 nil 4528 34 2 8 1140916736 1 16704 4930 138 144 34 8 8688 14448 10928 16032 12752 4704 8432 10672 nil 4992 2578 31 nil 1 nil nil nil 16704 nil 8 1883225328 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3744 nil nil nil nil nil #noIcons 1314 138 144 34 3 1378 #createAt:extent: 34 2 738 1 1 738 921 833 16704 1378 #basicSelectionsByIndex: 34 1 8 #(1) 16704 1378 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 16704 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 8 #() 1536 nil 27 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 1 1 738 921 833 4528 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 34 9 8704 14464 10944 16048 12768 4720 8448 10688 16704 1536 nil 27 5 false 170 192 34 2 4528 18 10 111 119 110 101 100 67 97 114 100 115 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 469 1 738 921 833 4384 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 34 1 4528 1536 nil 27 5 false 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 4272 34 2 8 1140850688 131073 17488 nil nil nil 7 nil nil nil 17488 2610 ##(Smalltalk.PackageSelector) #resource_Default_view nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 1 1 738 459 833 17488 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 0 0 0 160 1 0 0] 960 1536 nil 27 18 8 112 97 99 107 97 103 101 115 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 1 1 738 1389 833 4272 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 34 3 17488 410 ##(Smalltalk.Splitter) 34 12 nil 4272 34 2 8 1140850688 1 17888 nil 610 4608 nil 519 nil nil nil 17888 1314 138 144 34 1 1378 #createAt:extent: 34 2 738 459 1 738 11 833 17888 1474 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 229 0 0 0 0 0 0 0 234 0 0 0 160 1 0 0] 8 #() 1536 nil 27 4384 1536 nil 27 1536 nil 27 170 192 34 4 544 18 7 116 111 111 108 98 97 114 3344 18 9 115 116 97 116 117 115 98 97 114 nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 10 5666 nil true 34 30 5714 1 1042 #newPackage 18 15 38 78 101 119 32 80 97 99 107 97 103 101 46 46 46 9373 5 nil nil nil 5714 1 1042 #openPackage 18 19 38 73 110 115 116 97 108 108 32 80 97 99 107 97 103 101 46 46 46 9375 5 nil nil nil 5714 1 1042 #removePackage 18 18 38 85 110 105 110 115 116 97 108 108 32 80 97 99 107 97 103 101 1 5 nil nil nil 5778 4097 5666 nil true 34 2 5714 2097153 1042 #addClass 18 9 38 67 108 97 115 115 46 46 46 1 1 nil nil nil 5714 1 1042 #addGlobal 18 10 38 71 108 111 98 97 108 46 46 46 1 1 nil nil nil 18 16 65 100 100 32 85 110 99 111 38 109 109 105 116 116 101 100 nil 134217729 nil nil 65147 nil nil 5714 1 1042 #chooseDefaultPackage 18 26 83 101 116 32 97 115 32 68 101 38 102 97 117 108 116 32 80 97 99 107 97 103 101 46 46 46 1 1 nil nil nil 5714 1 1042 #synchronizeFilter 18 12 38 71 111 116 111 32 70 111 108 100 101 114 1 1 nil nil nil 5778 4097 5714 1 1042 #savePackages 18 13 38 83 97 118 101 32 80 97 99 107 97 103 101 1 1 1794 nil true 1136 18 12 70 105 108 101 83 97 118 101 46 105 99 111 1184 nil nil 5714 1 1042 #savePackageChanges 18 21 83 97 118 101 32 80 97 99 107 97 103 101 32 67 38 104 97 110 103 101 115 1 1 nil nil nil 5714 1 1042 #savePackageAs 18 19 83 97 118 101 32 80 97 99 107 97 103 101 32 38 65 115 46 46 46 1 1 nil nil nil 5778 4097 5714 1 1042 #toggleUsingPAX 18 22 85 115 101 32 80 65 88 32 83 38 111 117 114 99 101 32 70 111 114 109 97 116 1 1 nil nil nil 5714 1 1042 #browsePackageSources 18 19 66 114 111 38 119 115 101 32 80 65 88 32 83 111 117 114 99 101 115 1 1 nil nil nil 5778 4097 5714 1 1042 #loadPackageFromRepository 18 15 76 111 97 100 32 69 100 105 116 105 111 110 46 46 46 1 1 nil nil nil 5714 1 1042 #importPackageFromFile 18 23 73 109 112 111 114 116 32 116 111 32 82 101 112 111 115 105 116 111 114 121 46 46 46 1 5 nil nil nil 5714 1 1042 #versionPackage 18 10 86 101 114 115 105 111 110 46 46 46 1 1 nil nil nil 5714 1 1042 #browsePackageEditions 18 15 66 114 111 119 115 101 32 69 100 105 116 105 111 110 115 1 1 nil nil nil 5714 1 1042 #compareWithAnotherEdition 18 15 67 111 109 112 97 114 101 32 119 105 116 104 46 46 46 1 1 nil nil nil 5778 4097 5714 1 1042 #saveImage 18 11 83 97 38 118 101 32 73 109 97 103 101 1 1 1794 nil true 1136 18 12 83 110 97 112 115 104 111 116 46 105 99 111 1184 nil nil 5714 1 1042 #smalltalkExit 18 13 69 38 120 105 116 32 68 111 108 112 104 105 110 1 1 1794 nil true 1136 18 15 80 111 119 101 114 83 119 105 116 99 104 46 105 99 111 1184 nil nil 5778 4097 5666 nil true 34 1 5714 2097153 1042 #browseTests 18 7 38 66 114 111 119 115 101 1 1 nil nil nil 18 6 38 84 101 115 116 115 nil 1 1794 nil true 1136 18 14 84 101 115 116 82 117 110 110 101 114 46 105 99 111 nil nil 65179 nil nil 5666 nil true 34 4 5714 2097153 1042 #deploy 18 21 38 68 101 112 108 111 121 32 69 120 101 99 117 116 97 98 108 101 46 46 46 13445 1 nil nil nil 5714 1 1042 #browseDeployed 18 27 66 114 111 38 119 115 101 32 69 120 101 99 117 116 97 98 108 101 32 77 97 110 105 102 101 115 116 1 1 nil nil nil 5778 4097 5714 1 1042 #saveBinaryPackage 18 25 68 101 112 108 111 121 32 38 66 105 110 97 114 121 32 80 97 99 107 97 103 101 46 46 46 1 1 nil nil nil 18 11 38 68 101 112 108 111 121 109 101 110 116 nil 134217729 1794 nil true 1136 18 31 65 112 112 108 105 99 97 116 105 111 110 68 101 112 108 111 121 109 101 110 116 87 105 122 97 114 100 46 105 99 111 1184 nil 65187 nil nil 5778 4097 5714 1 1042 #inspectPackage 18 11 80 38 114 111 112 101 114 116 105 101 115 1 1 nil nil nil 5778 4097 5714 1 1042 #exit 18 6 38 67 108 111 115 101 17639 1 1794 nil true 1136 18 15 67 108 111 115 101 87 105 110 100 111 119 46 105 99 111 1184 nil nil 18 5 38 70 105 108 101 nil 134217729 nil nil 65193 nil nil 5666 nil true 34 12 5714 1 1042 #undo 18 5 38 85 110 100 111 9397 1 1794 nil true 1136 18 12 69 100 105 116 85 110 100 111 46 105 99 111 1184 nil nil 5778 4097 5714 1 1042 #cutSelection 18 4 67 117 38 116 9393 1 1794 nil true 1136 18 11 69 100 105 116 67 117 116 46 105 99 111 1184 nil nil 5714 1 1042 #copySelection 18 5 38 67 111 112 121 9351 1 1794 nil true 1136 18 12 69 100 105 116 67 111 112 121 46 105 99 111 1184 nil nil 5714 1 1042 #pasteClipboard 18 6 38 80 97 115 116 101 9389 1 1794 nil true 1136 18 13 69 100 105 116 80 97 115 116 101 46 105 99 111 1184 nil nil 5714 1 1042 #editDelete 18 7 38 68 101 108 101 116 101 1 1 1794 nil true 1136 18 13 69 100 105 116 67 108 101 97 114 46 105 99 111 1184 nil nil 5778 4097 5714 1 1042 #selectAll 18 11 83 101 108 101 99 116 32 38 65 108 108 9347 1 nil nil nil 5778 4097 5714 1 1042 #editFind 18 8 38 70 105 110 100 46 46 46 9357 1 1794 nil true 1136 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5714 1 1042 #findNext 18 10 70 105 110 100 32 38 78 101 120 116 1253 1 1794 nil true 1136 18 12 70 105 110 100 78 101 120 116 46 105 99 111 1184 nil nil 5714 1 1042 #findReplace 18 11 38 82 101 112 108 97 99 101 46 46 46 9361 1 nil nil nil 18 5 38 69 100 105 116 nil 134217729 nil nil 65213 nil nil 5666 nil true 34 13 5714 1 1042 #browseIt 18 10 38 66 114 111 119 115 101 32 73 116 9349 1 1794 nil true 1136 18 21 67 108 97 115 115 66 114 111 119 115 101 114 83 104 101 108 108 46 105 99 111 1184 nil nil 5714 1 1042 #displayIt 18 11 38 68 105 115 112 108 97 121 32 73 116 9353 1 1794 nil true 1136 18 13 68 105 115 112 108 97 121 73 116 46 105 99 111 1184 nil nil 5714 1 1042 #evaluateIt 18 12 38 69 118 97 108 117 97 116 101 32 73 116 9355 1 1794 nil true 1136 18 14 69 118 97 108 117 97 116 101 73 116 46 105 99 111 1184 nil nil 5714 1 1042 #inspectIt 18 11 38 73 110 115 112 101 99 116 32 73 116 9363 1 1794 nil true 1136 18 18 66 97 115 105 99 73 110 115 112 101 99 116 111 114 46 105 99 111 1184 nil nil 5714 1 1042 #debugIt 18 9 68 101 98 38 117 103 32 73 116 1269 1 1794 nil true 1136 18 12 68 101 98 117 103 103 101 114 46 105 99 111 1184 nil nil 5714 1 1042 #fileItIn 18 11 38 70 105 108 101 32 73 116 32 73 110 1 1 nil nil nil 5778 4097 5714 1 1042 #browseDefinitions 18 15 68 101 102 105 38 110 105 116 105 111 110 115 46 46 46 1271 1 nil nil nil 5714 1 1042 #browseReferences 18 14 38 82 101 102 101 114 101 110 99 101 115 46 46 46 5367 1 nil nil nil 5778 4097 5714 1 1042 #accept 18 7 38 65 99 99 101 112 116 9383 1 nil nil nil 5778 4097 5666 nil true 34 7 5714 1 1042 #toggleAutoCompletion 18 14 38 65 117 116 111 45 99 111 109 112 108 101 116 101 1 1 nil nil nil 5714 1 1042 #toggleIndentationGuides 18 19 73 110 100 101 110 116 97 116 105 111 110 32 38 71 117 105 100 101 115 1 1 nil nil nil 5714 1 1042 #toggleLineEndings 18 13 76 105 110 101 32 38 69 110 100 105 110 103 115 1 1 nil nil nil 5714 1 1042 #toggleLineNumbers 18 13 76 105 110 101 32 78 38 117 109 98 101 114 115 1 1 nil nil nil 5714 1 1042 #toggleStyling 18 16 38 83 121 110 116 97 120 32 67 111 108 111 114 105 110 103 1 1 nil nil nil 5714 1 1042 #toggleWhitespace 18 11 87 38 104 105 116 101 115 112 97 99 101 1 1 nil nil nil 5714 1 1042 #toggleWordWrap 18 10 38 87 111 114 100 32 87 114 97 112 1 1 nil nil nil 18 8 38 79 112 116 105 111 110 115 nil 134217729 nil nil 65247 nil nil 18 10 38 87 111 114 107 115 112 97 99 101 nil 134217729 nil nil 65249 nil nil 5666 nil true 34 4 5714 1 1042 #browseLocalMessageDefinitions 18 18 38 68 101 102 105 110 105 116 105 111 110 115 32 79 102 46 46 46 1 1 nil nil nil 5714 1 1042 #browseLocalMessageReferences 18 17 38 82 101 102 101 114 101 110 99 101 115 32 84 111 46 46 46 1 1 nil nil nil 5778 4097 5714 1 1042 #browseUnimplemented 18 23 38 85 110 105 109 112 108 101 109 101 110 116 101 100 32 77 101 115 115 97 103 101 115 1 1 nil nil nil 18 7 38 66 114 111 119 115 101 nil 134217729 nil nil 65257 nil nil 5666 nil true 34 10 5714 1 1042 #toggleUsingPAX 18 22 85 115 101 32 80 65 88 32 83 38 111 117 114 99 101 32 70 111 114 109 97 116 1 1 nil nil nil 5714 2097153 1042 #browsePackageSources 18 19 66 114 111 38 119 115 101 32 80 65 88 32 83 111 117 114 99 101 115 1 1 nil nil nil 5778 4097 5714 1 1042 #checkOut 18 14 67 104 101 99 107 32 79 117 116 32 38 65 108 108 1 1 nil nil nil 5714 1 1042 #checkOutChanges 18 18 38 67 104 101 99 107 32 79 117 116 32 67 104 97 110 103 101 115 9367 1 nil nil nil 5714 1 1042 #checkIn 18 9 67 104 101 99 107 32 38 73 110 9387 1 nil nil nil 5778 4097 5714 1 1042 #savePackageChanges 18 13 83 97 118 101 32 67 38 104 97 110 103 101 115 1 1 1794 nil true 1136 18 12 70 105 108 101 83 97 118 101 46 105 99 111 1184 nil nil 5778 4097 5714 1 1042 #resetChangeFlags 18 21 67 108 101 97 114 32 67 104 97 110 103 101 32 38 77 97 114 107 101 114 115 1 1 nil nil nil 18 15 83 111 117 38 114 99 101 32 67 111 110 116 114 111 108 nil 134217729 nil nil 65273 nil nil 5666 nil true 34 10 5714 1 1042 #renameMethod 18 17 82 101 38 110 97 109 101 32 77 101 116 104 111 100 46 46 46 1 1 nil nil nil 5714 1 1042 #renameMethodReferences 18 21 82 101 110 97 109 101 32 82 101 38 102 101 114 101 110 99 101 115 46 46 46 1 1 nil nil nil 5778 4097 5714 1 1042 #safeRemoveMethod 18 17 82 101 38 109 111 118 101 32 77 101 116 104 111 100 46 46 46 1 1 nil nil nil 5714 1 1042 #removeDuplicateMethods 18 25 82 101 109 111 118 101 32 68 117 112 38 108 105 99 97 116 101 32 77 101 116 104 111 100 115 1 1 nil nil nil 5778 4097 5714 1 1042 #addParameter 18 24 65 100 100 32 77 101 116 104 111 100 32 38 80 97 114 97 109 101 116 101 114 46 46 46 1 1 nil nil nil 5714 1 1042 #removeParameter 18 27 82 101 109 111 38 118 101 32 77 101 116 104 111 100 32 80 97 114 97 109 101 116 101 114 46 46 46 1 1 nil nil nil 5778 4097 5714 1 1042 #moveAllTempsToInnerScope 18 33 77 111 118 101 32 65 108 108 32 38 84 101 109 112 115 32 84 111 32 73 110 110 101 114 32 83 99 111 112 101 46 46 46 1 5 nil nil nil 18 13 82 101 102 97 99 116 111 114 105 110 38 103 115 #refactoringsMenu 134217729 nil nil 65289 nil nil 5666 nil true 34 3 5714 1 1042 #undoChange 18 10 38 85 110 100 111 32 60 49 100 62 1 1 1794 nil true 1136 18 12 69 100 105 116 85 110 100 111 46 105 99 111 1184 nil nil 5714 1 1042 #redoChange 18 10 38 82 101 100 111 32 60 49 100 62 1 1 1794 nil true 1136 18 12 69 100 105 116 82 101 100 111 46 105 99 111 1184 nil nil 5714 1 1042 #clearChangeHistory 18 21 67 108 101 97 114 32 67 104 97 110 103 101 32 38 72 105 115 116 111 114 121 1 1 nil nil nil 18 8 72 38 105 115 116 111 114 121 nil 134217729 nil nil 65297 nil nil 5666 nil true 8 #() 18 6 38 84 111 111 108 115 #toolsMenu 134217729 nil nil 65299 nil nil 5666 nil true 8 #() 18 7 87 105 38 110 100 111 119 #windowMenu 134217729 nil nil 65301 nil nil 5666 nil true 34 15 5714 1 1042 #helpContents 18 9 38 67 111 110 116 101 110 116 115 1025 1 1794 nil true 1136 49 20576 nil nil 5714 1 1042 #help 18 13 79 110 32 116 104 105 115 32 38 84 111 111 108 1249 1 nil nil nil 5714 1 1042 #helpWhatsThis 18 12 87 104 97 116 39 115 32 84 104 105 115 63 5345 1 nil nil nil 5778 4097 5714 1 1042 #learnSmalltalk 18 15 76 101 97 114 110 32 83 109 97 108 108 116 97 108 107 1 1 nil nil nil 5778 4097 5714 1 1042 #helpWhatsNew 18 11 87 104 97 116 39 115 32 38 78 101 119 1 1 nil nil nil 5714 1 1042 #helpGuidedTour 18 12 38 71 117 105 100 101 100 32 84 111 117 114 1 1 nil nil nil 5714 1 1042 #helpTutorials 18 9 84 117 116 111 114 105 97 108 115 1 1 nil nil nil 5778 4097 5714 1 1042 #objectArtsHomePage 18 20 79 98 106 101 99 116 32 65 114 116 115 32 72 111 109 101 112 97 103 101 1 1 nil nil nil 5714 1 1042 #dolphinNewsgroup 18 23 68 111 108 112 104 105 110 32 78 101 119 115 103 114 111 117 112 47 70 111 114 117 109 1 1 nil nil nil 5714 1 1042 #dolphinWikiWeb 18 15 68 111 108 112 104 105 110 32 87 105 107 105 87 101 98 1 1 nil nil nil 5778 4097 5714 1 1042 #aboutDolphin 18 24 38 65 98 111 117 116 32 68 111 108 112 104 105 110 32 83 109 97 108 108 116 97 108 107 1 1 1794 nil true 1136 18 12 33 65 80 80 76 73 67 65 84 73 79 78 1184 nil nil 18 5 38 72 101 108 112 nil 134217729 nil nil 65325 nil nil 18 0 nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 738 771 621 1 nil nil 1314 138 144 34 3 1378 #createAt:extent: 34 2 738 3839 21 738 1421 1041 416 1378 #text: 34 1 12658 15 80 97 99 107 97 103 101 32 66 114 111 119 115 101 114 416 1378 #updateMenuBar 960 416 1474 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 69 10 0 0 18 2 0 0] 34 3 544 3984 3344 1536 nil 27 )!

toolsFolderHelpId
	^10598!

uninitialize
	"Private - Uninitialize the receiver prior to remove from the system.
		self uninitialize
	"

	Smalltalk developmentSystem
		removeSystemFolderIconNamed: self toolDescription;
		unregisterTool: self!

wordWrapComment
	"Answer true if instances of the receiver use comment word wrapping."

	^WordWrapComment!

wordWrapComment: aBoolean
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrapComment := aBoolean! !
!PackageBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!PackageBrowserShell class categoriesFor: #icon!constants!public! !
!PackageBrowserShell class categoriesFor: #initialize!initializing!private! !
!PackageBrowserShell class categoriesFor: #publishedAspects!development!public! !
!PackageBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!PackageBrowserShell class categoriesFor: #toolsFolderHelpId!public! !
!PackageBrowserShell class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!PackageBrowserShell class categoriesFor: #wordWrapComment!accessing!options!public! !
!PackageBrowserShell class categoriesFor: #wordWrapComment:!accessing!options!public! !

