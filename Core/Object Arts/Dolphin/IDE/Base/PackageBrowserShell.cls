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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786950 ##(Smalltalk.DefaultColor) #toolBackground nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 167 4 112 212 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 nil 528 524550 ##(Smalltalk.ColorRef) 8 4278190080 8 1912794480 170 192 34 10 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853612 131137 800 nil nil nil 519 nil nil nil 800 706 736 8 1912794480 170 192 8 #() 170 192 34 2 10761 1246790 1 ##(Smalltalk.ToolbarBitmapButton) 800 17 1180998 4 ##(Smalltalk.CommandDescription) #viewModeSelect 8 'Views' 1 1 nil 10761 395334 3 ##(Smalltalk.Bitmap) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'ViewBar.bmp' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil 7 674 129 33 3 34 1 976 170 176 34 2 1056 1 nil 1 nil 674 33 33 674 45 45 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 674 1293 1 674 77 51 800 1330 #updateSizePosted 912 800 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 134 2 0 0 0 0 0 0 172 2 0 0 25 0 0 0] 8 #() 674 193 193 nil 27 8 'viewTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1520 nil nil nil 7 nil nil nil 1520 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 63 1 674 599 51 1520 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 74 1 0 0 25 0 0 0] 912 1488 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1776 nil nil nil 7 nil nil nil 1776 1586 ##(Smalltalk.Toolbar) #resource_Image_tools nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 1 674 63 51 1776 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 912 1488 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2016 nil nil nil 7 nil nil nil 2016 1586 ##(Smalltalk.Toolbar) #resource_Search_tools nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 661 1 674 433 51 2016 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 74 1 0 0 0 0 0 0 34 2 0 0 25 0 0 0] 912 1488 nil 27 8 'searchTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131073 2256 nil nil nil 519 nil nil nil 2256 706 736 8 1912794480 170 192 912 170 192 34 8 10759 1115206 1 ##(Smalltalk.ToolbarIconButton) 2256 1 994 #browsePackageSources 8 'Open Source Browser' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1088 8 'SourceManager.ico' 1136 10759 10753 2402 2256 1 994 #newPackage 8 'New Package' 1 1 2466 nil true 1088 8 'DocumentShell.ico' nil 10753 10755 2402 2256 1 994 #openPackage 8 'Install Package' 1 1 2466 nil true 1088 8 'FileOpen.ico' 1136 10755 10757 2402 2256 1 994 #savePackageChanges 8 'Save Package Changes' 1 1 2466 nil true 1088 8 'FileSave.ico' 1136 10757 34 5 2512 2592 2672 2416 1049158 1 ##(Smalltalk.ToolbarSeparator) 2256 1 170 176 34 8 1042 nil true nil nil nil nil 3 674 33 33 3 1042 nil true nil nil nil nil 3 674 33 33 5 1042 nil true nil nil nil nil 3 674 33 33 7 1042 nil true nil nil nil nil 3 674 33 33 1 nil 1 nil 674 33 33 674 45 45 nil nil 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 1093 1 674 201 51 2256 1330 #updateSizePosted 912 2256 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 34 2 0 0 0 0 0 0 134 2 0 0 25 0 0 0] 8 #() 1488 nil 27 8 'fileTools' 170 192 912 8 #() 170 176 912 nil 1 nil 674 33 33 674 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 1 1 674 1389 51 528 1330 #updateSizePosted 912 528 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 25 0 0 0] 34 5 1776 1520 2016 2256 800 1488 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 3472 nil 706 736 nil 7 nil 594 nil true 626 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 674 193 193 nil 3472 nil 8 1912526784 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 3472 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3664 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 3760 7 257 nil nil 8 'version' 3666 1 -1 3472 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1050182 1 ##(Smalltalk.IconImageManager) 8 'errors' 34 1 3840 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3472 nil nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 883 674 1389 41 3472 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 182 2 0 0 205 1 0 0] 8 #() 1488 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 4112 nil nil nil 7 nil nil nil 4112 1180166 ##(Smalltalk.ProportionalLayout) 170 176 912 true 170 192 912 nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 51 674 1389 833 4112 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 182 2 0 0 185 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 4112 34 2 8 1140850688 131073 4400 nil nil nil 7 nil nil nil 4400 4178 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 4400 34 2 8 1140850688 131073 4512 nil nil nil 7 nil nil nil 4512 4178 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.CardContainer) 34 16 nil 4512 34 2 8 1140850688 131073 4656 nil nil nil 7 nil nil nil 4656 655878 ##(Smalltalk.CardLayout) 138 144 34 8 4626 8 'Scripts' 410 ##(Smalltalk.ContainerView) 34 15 nil 4656 34 2 8 1140850688 131073 4816 nil nil nil 5 nil nil nil 4816 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.TabViewXP) 34 28 nil 4816 34 2 8 1140916866 1 4944 590662 2 ##(Smalltalk.ListModel) 138 144 912 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 706 8 4278190080 nil 5 nil nil nil 4944 nil 8 1912616880 3746 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] #key 5136 7 257 nil 3746 0 nil 5154 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] #icon #imageIndex 5232 7 257 nil 3872 nil nil nil nil nil #smallIcons nil nil nil nil nil 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 1 1 674 905 729 4944 1330 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4944 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 196 1 0 0 108 1 0 0] 8 #() 1488 nil 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 5538 #fixedParentRight 1 5538 #fixedParentTop 1 5538 #fixedParentBottom 1 410 ##(Smalltalk.ScintillaView) 34 50 nil 4816 34 2 8 1176572228 1025 5616 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 706 5104 nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 16 984134 2 ##(Smalltalk.CommandMenuItem) 1 994 #accept 8 '&Accept' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5762 nil true 34 9 5810 1 994 #undo 8 '&Undo' 1 1 nil nil nil 5874 4097 5810 1 994 #cutSelection 8 'Cu&t' 1 1 nil nil nil 5810 1 994 #copySelection 8 '&Copy' 1 1 nil nil nil 5810 1 994 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 5810 1 994 #clearSelection 8 'De&lete' 1 1 nil nil nil 5810 1 994 #reformatSource 8 'Re&format' 1 1 nil nil nil 5874 4097 5810 1 994 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 5810 1 994 #clear 8 'Clea&r' 1 1 nil nil nil 5874 4097 5810 1 994 #browseIt 8 'Bro&wse It' 1 1 2466 nil true 1088 8 'ClassBrowserShell.ico' 1136 nil nil 5810 1 994 #displayIt 8 '&Display It' 1 1 nil nil nil 5810 1 994 #evaluateIt 8 'E&valuate It' 1 1 nil nil nil 5810 1 994 #inspectIt 8 '&Inspect It' 1 1 2466 nil true 1088 8 'BasicInspector.ico' 1136 nil nil 5810 1 994 #debugIt 8 'Deb&ug It' 1 1 2466 nil true 1088 8 'Debugger.ico' 1136 nil nil 5874 4097 5810 1 994 #chooseEvaluationPools 8 '&Pools...' 1 1 nil nil nil 5810 1 994 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 5810 1 994 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 5874 4097 5762 nil true 34 3 5810 2097153 994 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 5810 1 994 #browseReferences 8 '&References...' 1 1 nil nil nil 5810 1 994 #browseMessages 8 '&Messages...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 5616 nil 8 1893518953 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7186 77 786694 ##(Smalltalk.IndexedColor) 33554457 7234 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 7200 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 912 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 5616 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 912 nil 170 176 912 9215 nil nil nil nil 7234 33554447 nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 7152 nil nil nil nil 3 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 5616 33423361 3 false #Warning nil nil nil nil nil nil #Error 7618 19 5616 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 7186 1027 196934 1 ##(Smalltalk.RGB) 60239 7714 31326207 1 nil nil nil nil #Warning nil nil nil #Error 7186 1031 7714 335 7714 31317503 1 nil nil nil nil #Error nil nil nil #Notification 7186 1029 nil 7714 31185883 1 nil nil nil nil #Notification nil nil nil nil 1266 138 144 34 9 1330 #createAt:extent: 34 2 674 21 21 674 793 689 5616 1330 #contextMenu: 34 1 5776 5616 1330 #textLimit: 8 #(1073741823) 5616 1330 #modificationEventMask: 8 #(4607) 5616 1330 #caretPeriod: 8 #(530) 5616 1330 #wordWrap: 8 #(true) 5616 1330 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 5616 1 3 nil nil 5 nil 8162 3 5616 1 nil nil 67108863 5 nil 8162 5 5616 1 nil nil nil 5 nil 5616 1330 #canHScroll: 8 #(false) 5616 1330 #maxCompletionListHeight: 8 #(9) 5616 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 150 1 0 0 98 1 0 0] 8 #() 1488 nil 29 5506 5552 21 5568 -91 5584 21 5600 -19 170 192 34 4 4944 8 'scriptNames' 5616 8 'scriptText' nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 9 97 674 905 729 4816 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 200 1 0 0 156 1 0 0] 34 2 5616 4944 1488 nil 27 4626 8 'Prerequisites' 410 ##(Smalltalk.ReferenceView) 34 14 nil 4656 34 2 8 1140850688 131073 8608 nil nil nil 5 nil nil nil 8608 1586 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 9 97 674 905 729 8608 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 200 1 0 0 156 1 0 0] 912 1488 nil 27 4626 8 'Comment' 410 ##(Smalltalk.ScintillaView) 34 50 nil 4656 34 2 8 1176572228 1 8864 5682 nil false 5728 nil 466 #commentWorkspace nil 7 5762 nil true 34 12 5810 1 994 #accept 8 '&Accept' 1 1 nil nil nil 5874 4097 5762 nil true 34 8 5810 1 994 #undo 8 '&Undo' 1 1 nil nil nil 5874 4097 5810 1 994 #cutSelection 8 'Cu&t' 1 1 nil nil nil 5810 1 994 #copySelection 8 '&Copy' 1 1 nil nil nil 5810 1 994 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 5810 1 994 #clearSelection 8 'De&lete' 1 1 nil nil nil 5874 4097 5810 1 994 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 5810 1 994 #clear 8 'Clea&r' 1 1 nil nil nil 5874 4097 5810 1 994 #browseIt 8 'Bro&wse It' 1 1 6432 nil nil 5810 1 994 #displayIt 8 '&Display It' 1 1 nil nil nil 5810 1 994 #evaluateIt 8 'E&valuate It' 1 1 nil nil nil 5810 1 994 #inspectIt 8 '&Inspect It' 1 1 6608 nil nil 5810 1 994 #debugIt 6672 1 1 6688 nil nil 5874 4097 5762 nil true 34 2 5810 2097153 994 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 5810 1 994 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 8864 7714 8454145 8 1893518953 7122 nil nil 9 nil 170 192 34 50 #lineBegin 7186 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #code2 7186 41 7714 17825793 7714 31317469 1 nil nil nil nil #code2 nil nil nil #preChar 7186 25 7234 33554433 7714 22404573 1 nil nil nil nil #preChar nil 1401 nil #em1 7186 9 7714 26317 nil 9 nil nil nil nil #em1 nil nil nil #blockQuote 7186 31 7714 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #header6 7186 23 7714 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #ulistItem 7186 27 7714 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #header3 7186 17 7714 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #strong2 7186 7 7714 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #header5 7186 21 7714 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #horizontalRule 7186 35 7714 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #em2 7186 11 7714 26317 nil 9 nil nil nil nil #em2 nil nil nil #normal 7186 1 nil 721158 ##(Smalltalk.SystemColor) 11 1 nil nil nil nil #normal nil nil nil #lineNumber 7186 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #header1 7186 13 7714 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #header2 7186 15 7714 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #strong1 7186 5 7714 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #indentGuide 7186 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #callTip 7186 77 7248 7264 1 nil nil nil nil #callTip nil nil nil #header4 7186 19 7714 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #code 7186 39 7714 17825793 7714 31317469 1 nil nil nil nil #code nil nil nil #codeBlock 7186 43 7714 17825793 7714 31317469 1 nil nil nil nil #codeBlock nil nil nil #olistItem 7186 29 7714 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #strikeOut 7186 33 7714 7768625 7714 20673875 1 nil nil nil nil #strikeOut nil nil nil #link 7186 37 7714 22282241 nil 33 nil nil nil nil #link nil nil nil 34 256 10368 9968 10496 10240 10080 10336 10432 10464 10208 10560 10272 10144 10032 10176 10688 10112 10720 10304 10768 10592 9984 10640 nil nil nil nil nil nil nil nil nil nil nil 10416 nil nil nil 10528 10544 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 7378 1 nil nil nil 8864 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 912 nil 170 176 912 9215 nil nil nil nil 7440 nil nil 65 nil nil nil 7536 3 170 192 34 2 #container 170 192 34 4 #normal 7186 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 7186 77 7248 7264 1 nil nil nil nil #callTip nil nil nil nil nil nil nil 130003 nil 170 192 34 4 #Warning 7618 19 8864 33423361 3 false #Warning nil nil nil nil nil nil #Error 7618 17 8864 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 7186 1027 7714 60239 7714 31326207 1 nil nil nil nil #Warning nil nil nil #Error 7186 1031 7714 335 7714 31317503 1 nil nil nil nil #Error nil nil nil #Notification 7186 1029 nil 7714 31185883 1 nil nil nil nil #Notification nil nil nil nil 1266 138 144 34 9 1330 #createAt:extent: 34 2 674 9 97 674 905 729 8864 1330 #contextMenu: 34 1 8960 8864 1330 #textLimit: 8 #(1073741823) 8864 1330 #modificationEventMask: 8 #(4607) 8864 1330 #caretPeriod: 8 #(530) 8864 1330 #wordWrap: 8 #(true) 8864 1330 #margins: 34 1 34 3 8162 1 8864 1 3 nil nil 5 nil 8162 3 8864 1 nil nil 67108863 5 nil 8162 5 8864 1 nil nil nil 5 nil 8864 1330 #maxCompletionListHeight: 8 #(9) 8864 1330 #setLexerLanguage: 8 #(#markdown) 8864 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1488 nil 29 4626 8 'Dependents' 410 ##(Smalltalk.ReferenceView) 34 14 nil 4656 34 2 8 1140850688 131073 11760 nil nil nil 5 nil nil nil 11760 1586 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 9 97 674 905 729 11760 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 200 1 0 0 156 1 0 0] 912 1488 nil 27 4626 8 'Loose Methods' 410 ##(Smalltalk.ListView) 34 30 nil 4656 34 2 8 1140920393 1 12016 5010 138 144 912 nil 5072 706 5104 nil 29 5762 nil true 34 10 5810 2097153 994 #browseMethods 8 'Browse <1d>' 1 1 nil nil nil 5810 1 994 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 nil nil nil 5810 1 994 #browseMessageReferences 8 'All Re&ferences' 1 1 nil nil nil 5810 1 994 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 nil nil nil 5810 1 994 #browseLocalMessageReferences 8 '&Local References' 1 1 nil nil nil 5874 4097 5810 1 994 #removeLooseMethods 8 '&Remove from Package' 1 1 nil nil nil 5762 nil true 34 7 5810 1 994 #renameMethod 8 'Re&name' 1 1 nil nil nil 5810 1 994 #renameMethodReferences 8 'Rename Re&ferences' 1 1 nil nil nil 5874 4097 5810 1 994 #safeRemoveMethods 8 '&Remove' 1 1 nil nil nil 5874 4097 5810 1 994 #addParameterToMethod 8 'Add &Parameter...' 1 1 nil nil nil 5762 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 nil nil nil nil nil 5874 4097 5762 nil true 34 1 5810 1 994 #browseLooseMethodEditions 8 'Browse &Editions' 1 1 nil nil nil 8 'C&hanges' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 12016 nil 8 1912800272 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3872 nil nil nil 674 65 65 nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Selector' 401 #left 3698 #selector 8 #() 3746 0 nil 5154 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] #selector 13056 7 513 nil nil nil 12016 ##(Smalltalk.IconicListAbstract) 1 nil 3746 0 nil 5154 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4626 #ClassBrowserAbstract ##(Smalltalk.ClassBrowserAbstract) #looseMethodColor #forecolor: 13136 7 257 nil 12978 8 'Class' 389 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3698 #methodClass 8 #() nil 12016 ##(Smalltalk.IconicListAbstract) 1 nil 3746 0 nil 5154 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx forecolor: Color black]' 8 #[32 105 17 45 159 178 106] 4626 #Color ##(Smalltalk.Color) #black #forecolor: 13296 7 257 nil 12978 8 'Package' 109 #left ##(Smalltalk.BasicListAbstract) 3746 0 nil 5154 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 13424 7 513 nil 3698 #owningPackage 8 #() nil 12016 nil 3 nil nil #report 912 nil 131173 nil 34 4 nil nil 674 1 1 nil 1266 138 144 34 3 1330 #createAt:extent: 34 2 674 9 97 674 905 729 12016 1330 #contextMenu: 34 1 12128 12016 1330 #text: 34 1 8 'Selector' 12016 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1488 nil 27 4626 8 'Globals' 410 ##(Smalltalk.ListView) 34 30 nil 4656 34 2 8 1140920393 1 13840 5010 138 144 912 nil 5072 706 5104 nil 29 5762 nil true 34 6 5810 1 994 #addGlobal 8 '&Add Uncommitted...' 1 1 nil nil nil 5810 1 994 #removeGlobals 8 '&Remove from Package' 1 1 nil nil nil 5874 4097 5810 2097153 994 #inspectGlobals 8 '&Inspect' 1 1 nil nil nil 5810 1 994 #browseGlobalReferences 8 'All Re&ferences' 1 1 nil nil nil 5810 1 994 #browseLocalGlobalReferences 8 '&Local References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 13840 nil 8 1912800272 ##(Smalltalk.BasicListAbstract) 3746 0 nil 5154 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 4626 #Smalltalk ##(Smalltalk) #icon #imageIndex 14272 7 257 nil 3872 nil nil nil 674 65 65 nil nil 138 144 34 4 12978 8 '' 41 #left 3746 0 nil 5154 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 14448 7 257 nil 3746 0 nil 5154 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 14560 7 513 nil 3746 0 nil 5154 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | [(Smalltalk at: x) isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 45 17 148 159 106 47 34 111 59 106 193 106] 14352 #isChanged 4626 #Error ##(Smalltalk.Error) #on:do: 14640 3746 0 nil 14656 39 257 nil 7 257 nil nil 13840 3746 0 nil 5154 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4626 #Package ##(Smalltalk.Package) #changedIcon #imageIndex 14752 7 257 nil 1 nil nil 12978 8 'Global' 301 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 13840 3746 0 nil 5154 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 14352 #icon #imageIndex 14880 7 257 nil 1 nil nil 12978 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3746 0 nil 5154 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 14992 7 513 nil 3746 0 nil 5154 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | Package manager packageOfGlobalNamed: x]' 8 #[32 105 45 159 17 178 106] 14832 #manager #packageOfGlobalNamed: 15072 7 257 nil nil 13840 nil 1 nil nil 12978 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3746 0 nil 5154 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | | glob |
glob := Smalltalk at: x.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[34 105 45 17 148 70 144 30 178 120 18 161 106 33 106] 4626 #Smalltalk ##(Smalltalk) #sourceObject #conformsToProtocol: #fileOutName 8 '' 15184 7 65793 nil nil 13840 nil 1 nil nil #report 912 nil 133221 nil 8 #(nil) 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 9 97 674 905 729 13840 1330 #contextMenu: 34 1 13952 13840 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1488 nil 27 4626 8 'Classes' 410 ##(Smalltalk.ListView) 34 30 nil 4656 34 2 8 1140920395 1 15536 5010 138 144 912 nil 5072 706 5104 nil 29 5762 nil true 34 8 5810 2097153 994 #browseClass 8 '&Browse' 1 1 2466 nil true 1088 8 'ClassBrowserShell.ico' 1136 nil nil 5810 1 994 #browseClassReferences 8 'All Re&ferences' 1 1 nil nil nil 5810 1 994 #browseLocalClassReferences 8 'L&ocal References' 1 1 nil nil nil 5874 4097 5810 1 994 #addClass 8 '&Add Uncommitted..' 1 1 nil nil nil 5810 1 994 #removeClasses 8 '&Remove from Package' 1 1 nil nil nil 5874 4097 5762 nil true 34 2 5810 1 994 #browseClassEditions 8 'Browse Class &Editions' 1 1 nil nil nil 5810 1 994 #compareClass 8 'Compare Class Edition...' 1 1 nil nil nil 8 'C&hanges' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 15536 nil 8 1912800272 3698 #name 8 #() ##(Smalltalk.IconicListAbstract) 3872 nil nil nil 674 65 65 nil nil 138 144 34 4 12978 8 '' 41 #left 3746 0 nil 5154 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 14544 16272 7 257 nil 3746 0 nil 5154 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 16368 7 513 nil 3698 #isChanged 8 #() nil 15536 3746 0 nil 5154 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 14832 #changedIcon #imageIndex 16480 7 257 nil 1 nil nil 12978 8 'Name' 375 #left 3698 #name 8 #() ##(Smalltalk.SortedCollection) nil nil 15536 ##(Smalltalk.IconicListAbstract) 1 nil nil 12978 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3746 0 nil 5154 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 16656 7 513 nil 3698 #owningPackage 8 #() nil 15536 nil 1 nil nil 12978 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3746 0 nil 5154 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] #fileOutName 16800 7 257 nil nil 15536 nil 1 nil nil #list 912 nil 133221 nil 34 4 nil nil 674 1 1 nil 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 9 97 674 905 729 15536 1330 #contextMenu: 34 1 15648 15536 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1488 nil 27 4626 8 'Resources' 410 ##(Smalltalk.ReferenceView) 34 14 nil 4656 34 2 8 1140850688 131073 17136 nil nil nil 5 5762 nil true 34 4 5810 2097153 994 #editResource 8 '&Edit' 1 1 nil nil nil 5810 1 994 #showResource 8 '&Show' 1 1 nil nil nil 5874 4097 5810 1 994 #deleteResource 8 '&Delete' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 17136 1586 ##(Smalltalk.ResourceListPresenter) #resource_Package_view nil 1266 138 144 34 2 1330 #createAt:extent: 34 2 674 9 97 674 905 729 17136 1330 #contextMenu: 34 1 17200 17136 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 200 1 0 0 156 1 0 0] 912 1488 nil 27 8864 170 192 34 16 8864 8 'comment' 11760 8 'dependents' 4816 8 'scripts' 17136 8 'resources' 15536 8 'classes' 8608 8 'prerequisites' 12016 8 'methods' 13840 8 'globals' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 4656 34 2 8 1140916736 1 17760 5010 138 144 34 8 8848 15520 12000 17120 13824 4800 8592 11744 nil 5072 nil nil 1 nil nil nil 17760 nil 8 1912616880 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3872 nil nil nil nil nil #noIcons nil nil nil nil nil 1266 138 144 34 3 1330 #createAt:extent: 34 2 674 1 1 674 921 833 17760 1330 #basicSelectionsByIndex: 34 1 8 #(1) 17760 1330 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 17760 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 8 #() 1488 nil 27 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 1 674 921 833 4656 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 34 9 8864 15536 12016 17136 13840 4816 8608 11760 17760 1488 nil 27 5 false 170 192 34 2 4656 8 'ownedCards' nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 469 1 674 921 833 4512 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 34 1 4656 1488 nil 27 5 false 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 4400 34 2 8 1140850688 131073 18528 nil nil nil 7 nil nil nil 18528 1586 ##(Smalltalk.PackageSelector) #resource_Default_view nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 1 674 459 833 18528 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 0 0 0 160 1 0 0] 912 1488 nil 27 8 'packages' nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 1 1 674 1389 833 4400 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 34 3 18528 410 ##(Smalltalk.Splitter) 34 12 nil 4400 34 2 8 1140850688 1 18928 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 18928 nil 1 #left nil nil nil 674 1 1 674 9 9 nil 19024 nil 1266 138 144 34 1 1330 #createAt:extent: 34 2 674 459 1 674 11 833 18928 1426 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 229 0 0 0 0 0 0 0 234 0 0 0 160 1 0 0] 8 #() 1488 nil 27 4512 1488 nil 27 1488 nil 27 170 192 34 4 3472 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 10 5762 nil true 34 30 5810 1 994 #newPackage 8 '&New Package...' 9373 5 nil nil nil 5810 1 994 #openPackage 8 '&Install Package...' 9375 5 nil nil nil 5810 1 994 #removePackage 8 '&Uninstall Package' 1 5 nil nil nil 5874 4097 5762 nil true 34 2 5810 2097153 994 #addClass 8 '&Class...' 1 1 nil nil nil 5810 1 994 #addGlobal 8 '&Global...' 1 1 nil nil nil 8 'Add Unco&mmitted' nil 134217729 nil nil 10545 nil nil 5810 1 994 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 nil nil nil 5810 1 994 #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 5874 4097 5810 1 994 #savePackages 8 '&Save Package' 1 1 2466 nil true 1088 8 'FileSave.ico' 1136 nil nil 5810 1 994 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 5810 1 994 #savePackageAs 8 'Save Package &As...' 1 1 nil nil nil 5874 4097 5810 1 994 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 5810 1 994 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 5874 4097 5810 1 994 #loadPackageFromRepository 8 'Load Edition...' 1 1 nil nil nil 5810 1 994 #importPackageFromFile 8 'Import to Repository...' 1 5 nil nil nil 5810 1 994 #versionPackage 8 'Version...' 1 1 nil nil nil 5810 1 994 #browsePackageEditions 8 'Browse Editions' 1 1 nil nil nil 5810 1 994 #compareWithAnotherEdition 8 'Compare with...' 1 1 nil nil nil 5874 4097 5810 1 994 #saveImage 8 'Sa&ve Image' 1 1 2466 nil true 1088 8 'Snapshot.ico' 1136 nil nil 5810 1 994 #smalltalkExit 8 'E&xit Dolphin' 1 1 2466 nil true 1088 8 'PowerSwitch.ico' 1136 nil nil 5874 4097 5762 nil true 34 1 5810 2097153 994 #browseTests 8 '&Browse' 1 1 nil nil nil 8 '&Tests' nil 1 2466 nil true 1088 8 'TestRunner.ico' nil nil 10577 nil nil 5762 nil true 34 4 5810 2097153 994 #deploy 8 '&Deploy Executable...' 13445 1 nil nil nil 5810 1 994 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 nil nil nil 5874 4097 5810 1 994 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 nil nil nil 8 '&Deployment' nil 134217729 2466 nil true 1088 8 'ApplicationDeploymentWizard.ico' 1136 nil 10585 nil nil 5874 4097 5810 1 994 #inspectPackage 8 'P&roperties' 1 1 nil nil nil 5874 4097 5810 1 994 #exit 8 '&Close' 17639 1 2466 nil true 1088 8 'CloseWindow.ico' 1136 nil nil 8 '&File' nil 134217729 nil nil 10591 nil nil 5762 nil true 34 12 5810 1 994 #undo 8 '&Undo' 9397 1 2466 nil true 1088 8 'EditUndo.ico' 1136 nil nil 5874 4097 5810 1 994 #cutSelection 8 'Cu&t' 9393 1 2466 nil true 1088 8 'EditCut.ico' 1136 nil nil 5810 1 994 #copySelection 8 '&Copy' 9351 1 2466 nil true 1088 8 'EditCopy.ico' 1136 nil nil 5810 1 994 #pasteClipboard 8 '&Paste' 9389 1 2466 nil true 1088 8 'EditPaste.ico' 1136 nil nil 5810 1 994 #editDelete 8 '&Delete' 1 1 2466 nil true 1088 8 'EditClear.ico' 1136 nil nil 5874 4097 5810 1 994 #selectAll 8 'Select &All' 9347 1 nil nil nil 5874 4097 5810 1 994 #editFind 8 '&Find...' 9357 1 2466 nil true 1088 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5810 1 994 #findNext 8 'Find &Next' 1253 1 2466 nil true 1088 8 'FindNext.ico' 1136 nil nil 5810 1 994 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 10611 nil nil 5762 nil true 34 13 5810 1 994 #browseIt 8 '&Browse It' 9349 1 2466 nil true 1088 8 'ClassBrowserShell.ico' 1136 nil nil 5810 1 994 #displayIt 8 '&Display It' 9353 1 2466 nil true 1088 8 'DisplayIt.ico' 1136 nil nil 5810 1 994 #evaluateIt 8 '&Evaluate It' 9355 1 2466 nil true 1088 8 'EvaluateIt.ico' 1136 nil nil 5810 1 994 #inspectIt 8 '&Inspect It' 9363 1 2466 nil true 1088 8 'BasicInspector.ico' 1136 nil nil 5810 1 994 #debugIt 8 'Deb&ug It' 1269 1 2466 nil true 1088 8 'Debugger.ico' 1136 nil nil 5810 1 994 #fileItIn 8 '&File It In' 1 1 nil nil nil 5874 4097 5810 1 994 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 5810 1 994 #browseReferences 8 '&References...' 5367 1 nil nil nil 5874 4097 5810 1 994 #accept 8 '&Accept' 9383 1 nil nil nil 5874 4097 5762 nil true 34 7 5810 1 994 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5810 1 994 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5810 1 994 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 5810 1 994 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5810 1 994 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5810 1 994 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5810 1 994 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 10645 nil nil 8 '&Workspace' nil 134217729 nil nil 10647 nil nil 5762 nil true 34 4 5810 1 994 #browseLocalMessageDefinitions 8 '&Definitions Of...' 1 1 nil nil nil 5810 1 994 #browseLocalMessageReferences 8 '&References To...' 1 1 nil nil nil 5874 4097 5810 1 994 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 10655 nil nil 5762 nil true 34 10 5810 1 994 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 5810 2097153 994 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 5874 4097 5810 1 994 #checkOut 8 'Check Out &All' 1 1 nil nil nil 5810 1 994 #checkOutChanges 8 '&Check Out Changes' 9367 1 nil nil nil 5810 1 994 #checkIn 8 'Check &In' 9387 1 nil nil nil 5874 4097 5810 1 994 #savePackageChanges 8 'Save C&hanges' 1 1 2466 nil true 1088 8 'FileSave.ico' 1136 nil nil 5874 4097 5810 1 994 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' nil 134217729 nil nil 10671 nil nil 5762 nil true 34 10 5810 1 994 #renameMethod 8 'Re&name Method...' 1 1 nil nil nil 5810 1 994 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5874 4097 5810 1 994 #safeRemoveMethod 8 'Re&move Method...' 1 1 nil nil nil 5810 1 994 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 5874 4097 5810 1 994 #addParameter 8 'Add Method &Parameter...' 1 1 nil nil nil 5810 1 994 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 nil nil nil 5874 4097 5810 1 994 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 nil nil nil 8 'Refactorin&gs' #refactoringsMenu 134217729 nil nil 10687 nil nil 5762 nil true 34 3 5810 1 994 #undoChange 8 '&Undo <1d>' 1 1 2466 nil true 1088 8 'EditUndo.ico' 1136 nil nil 5810 1 994 #redoChange 8 '&Redo <1d>' 1 1 2466 nil true 1088 8 'EditRedo.ico' 1136 nil nil 5810 1 994 #clearChangeHistory 8 'Clear Change &History' 1 1 nil nil nil 8 'H&istory' nil 134217729 nil nil 10695 nil nil 5762 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 10697 nil nil 5762 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 10699 nil nil 5762 nil true 34 15 5810 1 994 #helpContents 8 '&Contents' 1025 1 2466 nil true 1088 49 21664 nil nil 5810 1 994 #help 8 'On this &Tool' 1249 1 nil nil nil 5810 1 994 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5874 4097 5810 1 994 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 5874 4097 5810 1 994 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5810 1 994 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5810 1 994 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5874 4097 5810 1 994 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 5810 1 994 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5810 1 994 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5874 4097 5810 1 994 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 2466 nil true 1088 8 '!!APPLICATION' 1136 nil nil 8 '&Help' nil 134217729 nil nil 10723 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 674 771 621 1 nil nil 1266 138 144 34 3 1330 #createAt:extent: 34 2 674 3839 21 674 1421 1041 416 1330 #text: 34 1 8 'Package Browser' 416 1330 #updateMenuBar 912 416 1426 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 69 10 0 0 18 2 0 0] 34 3 528 4112 3472 1488 nil 27)!

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

