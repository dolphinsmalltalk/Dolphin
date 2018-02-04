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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 196934 1 ##(Smalltalk.RGB) 8 4294967295 nil 551 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140851532 131073 544 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 519 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 167 4 112 212 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 nil 544 610 640 8 4294902285 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 544 34 2 8 1140850688 131073 832 nil 721158 ##(Smalltalk.SystemColor) 31 nil 7 nil nil nil 832 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 738 63 1 738 991 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 8 #() 738 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 544 34 2 8 1140853580 131073 1200 nil 610 640 nil 519 nil nil nil 1200 610 640 8 4294902285 170 192 1152 170 192 34 8 33643 1115910 ##(Smalltalk.ToolbarIconButton) 33643 nil 1200 1 1180998 4 ##(Smalltalk.CommandDescription) #newPackage 8 'New Package' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'DocumentShell.ico' nil 395334 3 ##(Smalltalk.Bitmap) nil true nil nil nil nil 3 738 33 33 1 33645 1362 33645 nil 1200 1 1394 #openPackage 8 'Install Package' 1 1 1442 nil true 1488 8 'FileOpen.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 1522 nil true nil nil nil nil 3 738 33 33 1 33647 1362 33647 nil 1200 1 1394 #savePackageChanges 8 'Save Package Changes' 1 1 1442 nil true 1488 8 'FileSave.ico' 1664 1522 nil true nil nil nil nil 3 738 33 33 1 33649 1362 33649 nil 1200 1 1394 #browsePackageSources 8 'Open Source Browser' 1 1 1442 nil true 1488 8 'SourceManager.ico' 1664 1522 nil true nil nil nil nil 3 738 33 33 1 34 5 1376 1568 1728 1840 1050118 ##(Smalltalk.ToolbarSeparator) nil nil 1200 3 nil 1 170 176 34 8 1696 3 1808 5 1920 7 1536 1 nil 1 nil 738 33 33 738 45 45 nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 738 1053 1 738 201 51 1200 1026 #updateSizePosted 1152 1200 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 114 2 0 0 25 0 0 0] 8 #() 1168 nil 27 8 'fileTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 544 34 2 8 1140853612 131137 2256 nil 610 640 nil 519 nil nil nil 2256 610 640 8 4294902285 170 192 1152 170 192 34 2 33651 853766 ##(Smalltalk.ToolbarButton) 33651 nil 2256 17 1394 #viewModeSelect 8 'Views' 1 1 nil 1522 nil true 1488 8 'ViewBar.bmp' 1664 nil 7 738 129 33 3 34 1 2432 170 176 34 2 2480 1 nil 1 nil 738 33 33 738 45 45 nil nil 962 138 144 34 2 1026 #createAt:extent: 34 2 738 1253 1 738 77 51 2256 1026 #updateSizePosted 1152 2256 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 114 2 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 8 #() 1168 nil 27 8 'viewTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 544 34 2 8 1140850688 131073 2800 nil 898 31 nil 7 nil nil nil 2800 930 ##(Smalltalk.Toolbar) #resource_Image_tools nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 1 1 738 63 51 2800 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1152 1168 nil 27 8 'imageTools' 170 192 1152 8 #() 170 176 1152 nil 1 nil 738 33 33 738 45 45 nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 962 138 144 34 2 1026 #createAt:extent: 34 2 738 1 1 738 1389 51 544 1026 #updateSizePosted 1152 544 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 25 0 0 0] 34 4 2800 832 1200 2256 1168 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 3344 nil 610 640 nil 7 nil 658 nil true 690 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 738 193 193 nil 3344 nil 8 4294906851 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 3344 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3536 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 3632 7 257 nil nil 8 'version' 3538 1 -1 3344 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 34 1 3712 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3344 nil nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 1 883 738 1389 41 3344 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 182 2 0 0 205 1 0 0] 8 #() 1168 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3984 nil nil nil 7 nil nil nil 3984 1180166 ##(Smalltalk.ProportionalLayout) 170 176 1152 true 170 192 1152 nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 1 51 738 1389 833 3984 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 182 2 0 0 185 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3984 34 2 8 1140850688 131073 4272 nil nil nil 7 nil nil nil 4272 4050 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 4272 34 2 8 1140850688 131073 4384 nil nil nil 7 nil nil nil 4384 4050 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.CardContainer) 34 16 nil 4384 34 2 8 1140850688 131073 4528 nil 610 8 4278190080 nil 7 nil nil nil 4528 655878 ##(Smalltalk.CardLayout) 138 144 34 8 4498 8 'Scripts' 410 ##(Smalltalk.ContainerView) 34 15 nil 4528 34 2 8 1140850688 131073 4720 nil 610 4608 nil 5 nil nil nil 4720 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ScintillaView) 34 50 nil 4720 34 2 8 1176572228 1025 4864 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 610 4608 nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 16 984134 2 ##(Smalltalk.CommandMenuItem) 1 1394 #accept 8 '&Accept' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5010 nil true 34 9 5058 1 1394 #undo 8 '&Undo' 1 1 nil nil nil 5122 4097 5058 1 1394 #cutSelection 8 'Cu&t' 1 1 nil nil nil 5058 1 1394 #copySelection 8 '&Copy' 1 1 nil nil nil 5058 1 1394 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 5058 1 1394 #clearSelection 8 'De&lete' 1 1 nil nil nil 5058 1 1394 #reformatSource 8 'Re&format' 1 1 nil nil nil 5122 4097 5058 1 1394 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 5058 1 1394 #clear 8 'Clea&r' 1 1 nil nil nil 5122 4097 5058 1 1394 #browseIt 8 'Bro&wse It' 1 1 1442 nil true 1488 8 'ClassBrowserShell.ico' 1664 nil nil 5058 1 1394 #displayIt 8 '&Display It' 1 1 nil nil nil 5058 1 1394 #evaluateIt 8 'E&valuate It' 1 1 nil nil nil 5058 1 1394 #inspectIt 8 '&Inspect It' 1 1 1442 nil true 1488 8 'BasicInspector.ico' 1664 nil nil 5058 1 1394 #debugIt 8 'Deb&ug It' 1 1 1442 nil true 1488 8 'Debugger.ico' 1664 nil nil 5122 4097 5058 1 1394 #chooseEvaluationPools 8 '&Pools...' 1 1 nil nil nil 5058 1 1394 #inspectWorkspacePool 8 'Variab&les' 1 1 nil nil nil 5058 1 1394 #cloneNew 8 'Clo&ne' 1 1 nil nil nil 5122 4097 5010 nil true 34 3 5058 2097153 1394 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 5058 1 1394 #browseReferences 8 '&References...' 1 1 nil nil nil 5058 1 1394 #browseMessages 8 '&Messages...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 4864 nil 8 4294907129 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 6466 33554471 1 nil nil nil nil #callTip nil nil nil #normal 6434 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 40 6512 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 1152 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 4864 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1152 nil 170 176 1152 9215 nil nil nil nil 6466 33554447 nil nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 6400 nil nil nil nil 3 nil 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 4864 33423361 3 false #Warning nil nil nil nil nil nil #Error 6866 19 4864 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 6434 1029 nil 466 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 6434 1027 466 60239 466 31326207 1 nil nil nil nil #Warning nil nil nil #Error 6434 1031 466 335 466 31317503 1 nil nil nil nil #Error nil nil nil nil 962 138 144 34 9 1026 #createAt:extent: 34 2 738 21 21 738 793 685 4864 1026 #contextMenu: 34 1 5024 4864 1026 #modificationEventMask: 8 #(4607) 4864 1026 #caretPeriod: 8 #(530) 4864 1026 #wordWrap: 8 #(true) 4864 1026 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 4864 1 3 nil nil 5 nil 7362 3 4864 1 nil nil 67108863 5 nil 7362 5 4864 1 nil nil nil 5 nil 4864 1026 #canHScroll: 8 #(false) 4864 1026 #maxCompletionListHeight: 8 #(9) 4864 1026 #sciSetCodePage: 8 #(65001) 4864 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 150 1 0 0 96 1 0 0] 8 #() 1168 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 21 7602 #fixedParentRight -91 7602 #fixedParentTop 21 7602 #fixedParentBottom -19 410 ##(Smalltalk.TabView) 34 23 nil 4720 34 2 8 1140916866 1 7680 590662 2 ##(Smalltalk.ListModel) 138 144 1152 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 610 4608 nil 5 nil nil nil 7680 nil 8 4294907861 3618 0 nil 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] #key 7856 7 257 nil 3618 0 nil 7874 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] #icon #imageIndex 7952 7 257 nil 3744 nil nil nil nil nil #smallIcons 962 138 144 34 2 1026 #createAt:extent: 34 2 738 1 1 738 905 725 7680 1026 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7680 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 196 1 0 0 106 1 0 0] 8 #() 1168 nil 27 7570 7616 1 7632 1 7648 1 7664 1 170 192 34 4 4864 8 'scriptText' 7680 8 'scriptNames' nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 9 101 738 905 725 4720 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 34 2 4864 7680 1168 nil 27 4498 8 'Prerequisites' 410 ##(Smalltalk.ReferenceView) 34 14 nil 4528 34 2 8 1140850688 131073 8496 nil nil nil 5 nil nil nil 8496 930 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 9 101 738 905 725 8496 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 1152 1168 nil 27 4498 8 'Comment' 410 ##(Smalltalk.ScintillaView) 34 50 nil 4528 34 2 8 1176572228 1 8752 4930 nil false 4976 nil 466 30932991 nil 7 5010 nil true 34 12 5058 1 1394 #accept 8 '&Accept' 1 1 nil nil nil 5122 4097 5010 nil true 34 8 5058 1 1394 #undo 8 '&Undo' 1 1 nil nil nil 5122 4097 5058 1 1394 #cutSelection 8 'Cu&t' 1 1 nil nil nil 5058 1 1394 #copySelection 8 '&Copy' 1 1 nil nil nil 5058 1 1394 #pasteClipboard 8 '&Paste' 1 1 nil nil nil 5058 1 1394 #clearSelection 8 'De&lete' 1 1 nil nil nil 5122 4097 5058 1 1394 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 5058 1 1394 #clear 8 'Clea&r' 1 1 nil nil nil 5122 4097 5058 1 1394 #browseIt 8 'Bro&wse It' 1 1 5680 nil nil 5058 1 1394 #displayIt 8 '&Display It' 1 1 nil nil nil 5058 1 1394 #evaluateIt 8 'E&valuate It' 1 1 nil nil nil 5058 1 1394 #inspectIt 8 '&Inspect It' 1 1 5856 nil nil 5058 1 1394 #debugIt 5920 1 1 5936 nil nil 5122 4097 5010 nil true 34 2 5058 2097153 1394 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 5058 1 1394 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 8752 466 8454145 8 4294907129 6370 nil nil 9 nil 170 192 34 4 #callTip 6434 77 6480 6496 1 nil nil nil nil #callTip nil nil nil #normal 6434 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 40 9872 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 6626 1 nil nil nil 8752 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 1152 nil 170 176 1152 9215 nil nil nil nil 6688 nil nil 65 nil nil nil 6784 3 170 192 34 2 #container 9824 nil nil nil nil 1 nil 170 192 34 4 #Warning 6866 19 8752 33423361 3 false #Warning nil nil nil nil nil nil #Error 6866 17 8752 33554459 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 6434 1029 nil 466 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 6434 1027 466 60239 466 31326207 1 nil nil nil nil #Warning nil nil nil #Error 6434 1031 466 335 466 31317503 1 nil nil nil nil #Error nil nil nil nil 962 138 144 34 8 1026 #createAt:extent: 34 2 738 9 101 738 905 725 8752 1026 #contextMenu: 34 1 8848 8752 1026 #modificationEventMask: 8 #(4607) 8752 1026 #caretPeriod: 8 #(530) 8752 1026 #wordWrap: 8 #(true) 8752 1026 #margins: 34 1 34 3 7362 1 8752 1 3 nil nil 5 nil 7362 3 8752 1 nil nil 67108863 5 nil 7362 5 8752 1 nil nil nil 5 nil 8752 1026 #maxCompletionListHeight: 8 #(9) 8752 1026 #sciSetCodePage: 8 #(65001) 8752 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1168 nil 29 4498 8 'Dependents' 410 ##(Smalltalk.ReferenceView) 34 14 nil 4528 34 2 8 1140850688 131073 10752 nil nil nil 5 nil nil nil 10752 930 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 9 101 738 905 725 10752 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 1152 1168 nil 27 4498 8 'Loose Methods' 410 ##(Smalltalk.ListView) 34 30 nil 4528 34 2 8 1140920393 1 11008 7746 138 144 1152 nil 7808 610 4608 nil 29 5010 nil true 34 10 5058 2097153 1394 #browseMethods 8 'Browse <1d>' 1 1 nil nil nil 5058 1 1394 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 nil nil nil 5058 1 1394 #browseMessageReferences 8 'All Re&ferences' 1 1 nil nil nil 5058 1 1394 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 nil nil nil 5058 1 1394 #browseLocalMessageReferences 8 '&Local References' 1 1 nil nil nil 5122 4097 5058 1 1394 #removeLooseMethods 8 '&Remove from Package' 1 1 nil nil nil 5010 nil true 34 7 5058 1 1394 #renameMethod 8 'Re&name' 1 1 nil nil nil 5058 1 1394 #renameMethodReferences 8 'Rename Re&ferences' 1 1 nil nil nil 5122 4097 5058 1 1394 #safeRemoveMethods 8 '&Remove' 1 1 nil nil nil 5122 4097 5058 1 1394 #addParameterToMethod 8 'Add &Parameter...' 1 1 nil nil nil 5010 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 nil nil nil nil nil 5122 4097 5010 nil true 34 1 5058 1 1394 #browseLooseMethodEditions 8 'Browse &Editions' 1 1 nil nil nil 8 'C&hanges' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 11008 nil 8 4294902479 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3744 nil nil nil 738 65 65 nil nil 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Selector' 401 #left 3570 #selector 8 #() 3618 0 nil 7874 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] #selector 12048 7 513 nil nil nil 11008 ##(Smalltalk.IconicListAbstract) 1 nil 3618 0 nil 7874 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4498 #ClassBrowserAbstract ##(Smalltalk.ClassBrowserAbstract) #looseMethodColor #forecolor: 12128 7 257 nil 11970 8 'Class' 389 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3570 #methodClass 8 #() nil 11008 ##(Smalltalk.IconicListAbstract) 1 nil 3618 0 nil 7874 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx forecolor: Color black]' 8 #[32 105 17 45 159 178 106] 4498 #Color ##(Smalltalk.Color) #black #forecolor: 12288 7 257 nil 11970 8 'Package' 109 #left ##(Smalltalk.BasicListAbstract) 3618 0 nil 7874 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 12416 7 513 nil 3570 #owningPackage 8 #() nil 11008 nil 3 nil nil #report 1152 nil 131173 nil 8 #(nil) 962 138 144 34 3 1026 #createAt:extent: 34 2 738 9 101 738 905 725 11008 1026 #contextMenu: 34 1 11120 11008 1026 #text: 34 1 8 'Selector' 11008 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1168 nil 27 4498 8 'Globals' 410 ##(Smalltalk.ListView) 34 30 nil 4528 34 2 8 1140920393 1 12816 7746 138 144 1152 nil 7808 610 4608 nil 29 5010 nil true 34 6 5058 1 1394 #addGlobal 8 '&Add Uncommitted...' 1 1 nil nil nil 5058 1 1394 #removeGlobals 8 '&Remove from Package' 1 1 nil nil nil 5122 4097 5058 2097153 1394 #inspectGlobals 8 '&Inspect' 1 1 nil nil nil 5058 1 1394 #browseGlobalReferences 8 'All Re&ferences' 1 1 nil nil nil 5058 1 1394 #browseLocalGlobalReferences 8 '&Local References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 12816 nil 8 4294902479 ##(Smalltalk.BasicListAbstract) 3618 0 nil 7874 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 4498 #Smalltalk ##(Smalltalk) #icon #imageIndex 13248 7 257 nil 3744 nil nil nil 738 65 65 nil nil 138 144 34 4 11970 8 '' 41 #left 3618 0 nil 7874 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 13424 7 257 nil 3618 0 nil 7874 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 13536 7 513 nil 3618 0 nil 7874 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | [(Smalltalk at: x) isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 45 17 148 159 106 47 34 111 59 106 193 106] 13328 #isChanged 4498 #Error ##(Smalltalk.Error) #on:do: 13616 3618 0 nil 13632 39 257 nil 7 257 nil nil 12816 3618 0 nil 7874 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4498 #Package ##(Smalltalk.Package) #changedIcon #imageIndex 13728 7 257 nil 1 nil nil 11970 8 'Global' 301 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) nil nil 12816 3618 0 nil 7874 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 13328 #icon #imageIndex 13856 7 257 nil 1 nil nil 11970 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3618 0 nil 7874 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 13968 7 513 nil 3618 0 nil 7874 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | Package manager packageOfGlobalNamed: x]' 8 #[32 105 45 159 17 178 106] 13808 #manager #packageOfGlobalNamed: 14048 7 257 nil nil 12816 nil 1 nil nil 11970 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3618 0 nil 7874 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | | glob |
glob := Smalltalk at: x.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[34 105 45 17 148 70 144 30 178 120 18 161 106 33 106] 4498 #Smalltalk ##(Smalltalk) #sourceObject #conformsToProtocol: #fileOutName 8 '' 14160 7 65793 nil nil 12816 nil 1 nil nil #report 1152 nil 133221 nil 8 #(nil) 962 138 144 34 2 1026 #createAt:extent: 34 2 738 9 101 738 905 725 12816 1026 #contextMenu: 34 1 12928 12816 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1168 nil 27 4498 8 'Classes' 410 ##(Smalltalk.ListView) 34 30 nil 4528 34 2 8 1140920395 1 14512 7746 138 144 1152 nil 7808 610 4608 nil 29 5010 nil true 34 8 5058 2097153 1394 #browseClass 8 '&Browse' 1 1 1442 nil true 1488 8 'ClassBrowserShell.ico' 1664 nil nil 5058 1 1394 #browseClassReferences 8 'All Re&ferences' 1 1 nil nil nil 5058 1 1394 #browseLocalClassReferences 8 'L&ocal References' 1 1 nil nil nil 5122 4097 5058 1 1394 #addClass 8 '&Add Uncommitted..' 1 1 nil nil nil 5058 1 1394 #removeClasses 8 '&Remove from Package' 1 1 nil nil nil 5122 4097 5010 nil true 34 2 5058 1 1394 #browseClassEditions 8 'Browse Class &Editions' 1 1 nil nil nil 5058 1 1394 #compareClass 8 'Compare Class Edition...' 1 1 nil nil nil 8 'C&hanges' nil 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 14512 nil 8 4294902479 3570 #name 8 #() ##(Smalltalk.IconicListAbstract) 3744 nil nil nil 738 65 65 nil nil 138 144 34 4 11970 8 '' 41 #left 3618 0 nil 7874 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 13520 15248 7 257 nil 3618 0 nil 7874 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 15344 7 513 nil 3570 #isChanged 8 #() nil 14512 3618 0 nil 7874 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 13808 #changedIcon #imageIndex 15456 7 257 nil 1 nil nil 11970 8 'Name' 375 #left 3570 #name 8 #() ##(Smalltalk.SortedCollection) nil nil 14512 ##(Smalltalk.IconicListAbstract) 1 nil nil 11970 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3618 0 nil 7874 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 15632 7 513 nil 3570 #owningPackage 8 #() nil 14512 nil 1 nil nil 11970 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3618 0 nil 7874 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] #fileOutName 15776 7 257 nil nil 14512 nil 1 nil nil #list 1152 nil 133221 nil 34 4 nil nil 738 1 1 nil 962 138 144 34 2 1026 #createAt:extent: 34 2 738 9 101 738 905 725 14512 1026 #contextMenu: 34 1 14624 14512 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1168 nil 27 4498 8 'Resources' 410 ##(Smalltalk.ReferenceView) 34 14 nil 4528 34 2 8 1140850688 131073 16112 nil 610 8 4278190080 nil 5 5010 nil true 34 4 5058 2097153 1394 #editResource 8 '&Edit' 1 1 nil nil nil 5058 1 1394 #showResource 8 '&Show' 1 1 nil nil nil 5122 4097 5058 1 1394 #deleteResource 8 '&Delete' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 16112 930 ##(Smalltalk.ResourceListPresenter) #resource_Package_view nil 962 138 144 34 2 1026 #createAt:extent: 34 2 738 9 101 738 905 725 16112 1026 #contextMenu: 34 1 16208 16112 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 1152 1168 nil 27 8752 170 192 34 16 8496 8 'prerequisites' 10752 8 'dependents' 14512 8 'classes' 4720 8 'scripts' 11008 8 'methods' 16112 8 'resources' 12816 8 'globals' 8752 8 'comment' nil 410 ##(Smalltalk.TabView) 34 23 nil 4528 34 2 8 1140916736 1 16768 7746 138 144 34 8 8736 14496 10992 16096 12800 4704 8480 10736 nil 7808 898 31 nil 1 nil nil nil 16768 nil 8 4294907861 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3744 nil nil nil nil nil #noIcons 962 138 144 34 3 1026 #createAt:extent: 34 2 738 1 1 738 921 833 16768 1026 #basicSelectionsByIndex: 34 1 8 #(1) 16768 1026 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 16768 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 8 #() 1168 nil 27 962 138 144 34 1 1026 #createAt:extent: 34 2 738 1 1 738 921 833 4528 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 34 9 8752 14512 11008 16112 12816 4720 8496 10752 16768 1168 nil 27 5 false 170 192 34 2 4528 8 'ownedCards' nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 469 1 738 921 833 4384 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 34 1 4528 1168 nil 27 5 false 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 4272 34 2 8 1140850688 131073 17552 nil nil nil 7 nil nil nil 17552 930 ##(Smalltalk.PackageSelector) #resource_Default_view nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 1 1 738 459 833 17552 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 0 0 0 160 1 0 0] 1152 1168 nil 27 8 'packages' nil 962 138 144 34 1 1026 #createAt:extent: 34 2 738 1 1 738 1389 833 4272 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 34 3 17552 410 ##(Smalltalk.Splitter) 34 12 nil 4272 34 2 8 1140850688 1 17952 nil 610 4608 nil 519 nil nil nil 17952 962 138 144 34 1 1026 #createAt:extent: 34 2 738 459 1 738 11 833 17952 1106 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 229 0 0 0 0 0 0 0 234 0 0 0 160 1 0 0] 8 #() 1168 nil 27 4384 1168 nil 27 1168 nil 27 170 192 34 4 3344 8 'statusbar' 544 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 10 5010 nil true 34 30 5058 1 1394 #newPackage 8 '&New Package...' 9373 5 nil nil nil 5058 1 1394 #openPackage 8 '&Install Package...' 9375 5 nil nil nil 5058 1 1394 #removePackage 8 '&Uninstall Package' 1 5 nil nil nil 5122 4097 5010 nil true 34 2 5058 2097153 1394 #addClass 8 '&Class...' 1 1 nil nil nil 5058 1 1394 #addGlobal 8 '&Global...' 1 1 nil nil nil 8 'Add Unco&mmitted' nil 134217729 nil nil 33435 nil nil 5058 1 1394 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 nil nil nil 5058 1 1394 #synchronizeFilter 8 '&Goto Folder' 1 1 nil nil nil 5122 4097 5058 1 1394 #savePackages 8 '&Save Package' 1 1 1442 nil true 1488 8 'FileSave.ico' 1664 nil nil 5058 1 1394 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 5058 1 1394 #savePackageAs 8 'Save Package &As...' 1 1 nil nil nil 5122 4097 5058 1 1394 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 5058 1 1394 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 5122 4097 5058 1 1394 #loadPackageFromRepository 8 'Load Edition...' 1 1 nil nil nil 5058 1 1394 #importPackageFromFile 8 'Import to Repository...' 1 5 nil nil nil 5058 1 1394 #versionPackage 8 'Version...' 1 1 nil nil nil 5058 1 1394 #browsePackageEditions 8 'Browse Editions' 1 1 nil nil nil 5058 1 1394 #compareWithAnotherEdition 8 'Compare with...' 1 1 nil nil nil 5122 4097 5058 1 1394 #saveImage 8 'Sa&ve Image' 1 1 1442 nil true 1488 8 'Snapshot.ico' 1664 nil nil 5058 1 1394 #smalltalkExit 8 'E&xit Dolphin' 1 1 1442 nil true 1488 8 'PowerSwitch.ico' 1664 nil nil 5122 4097 5010 nil true 34 1 5058 2097153 1394 #browseTests 8 '&Browse' 1 1 nil nil nil 8 '&Tests' nil 1 1442 nil true 1488 8 'TestRunner.ico' nil nil 33467 nil nil 5010 nil true 34 4 5058 2097153 1394 #deploy 8 '&Deploy Executable...' 13445 1 nil nil nil 5058 1 1394 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 nil nil nil 5122 4097 5058 1 1394 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 nil nil nil 8 '&Deployment' nil 134217729 1442 nil true 1488 8 'ApplicationDeploymentWizard.ico' 1664 nil 33475 nil nil 5122 4097 5058 1 1394 #inspectPackage 8 'P&roperties' 1 1 nil nil nil 5122 4097 5058 1 1394 #exit 8 '&Close' 17639 1 1442 nil true 1488 8 'CloseWindow.ico' 1664 nil nil 8 '&File' nil 134217729 nil nil 33481 nil nil 5010 nil true 34 12 5058 1 1394 #undo 8 '&Undo' 9397 1 1442 nil true 1488 8 'EditUndo.ico' 1664 nil nil 5122 4097 5058 1 1394 #cutSelection 8 'Cu&t' 9393 1 1442 nil true 1488 8 'EditCut.ico' 1664 nil nil 5058 1 1394 #copySelection 8 '&Copy' 9351 1 1442 nil true 1488 8 'EditCopy.ico' 1664 nil nil 5058 1 1394 #pasteClipboard 8 '&Paste' 9389 1 1442 nil true 1488 8 'EditPaste.ico' 1664 nil nil 5058 1 1394 #editDelete 8 '&Delete' 1 1 1442 nil true 1488 8 'EditClear.ico' 1664 nil nil 5122 4097 5058 1 1394 #selectAll 8 'Select &All' 9347 1 nil nil nil 5122 4097 5058 1 1394 #editFind 8 '&Find...' 9357 1 1442 nil true 1488 47 786694 ##(Smalltalk.ShellLibrary) nil nil 5058 1 1394 #findNext 8 'Find &Next' 1253 1 1442 nil true 1488 8 'FindNext.ico' 1664 nil nil 5058 1 1394 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 33501 nil nil 5010 nil true 34 13 5058 1 1394 #browseIt 8 '&Browse It' 9349 1 1442 nil true 1488 8 'ClassBrowserShell.ico' 1664 nil nil 5058 1 1394 #displayIt 8 '&Display It' 9353 1 1442 nil true 1488 8 'DisplayIt.ico' 1664 nil nil 5058 1 1394 #evaluateIt 8 '&Evaluate It' 9355 1 1442 nil true 1488 8 'EvaluateIt.ico' 1664 nil nil 5058 1 1394 #inspectIt 8 '&Inspect It' 9363 1 1442 nil true 1488 8 'BasicInspector.ico' 1664 nil nil 5058 1 1394 #debugIt 8 'Deb&ug It' 1269 1 1442 nil true 1488 8 'Debugger.ico' 1664 nil nil 5058 1 1394 #fileItIn 8 '&File It In' 1 1 nil nil nil 5122 4097 5058 1 1394 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 5058 1 1394 #browseReferences 8 '&References...' 5367 1 nil nil nil 5122 4097 5058 1 1394 #accept 8 '&Accept' 9383 1 nil nil nil 5122 4097 5010 nil true 34 7 5058 1 1394 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 5058 1 1394 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 5058 1 1394 #toggleLineEndings 8 'Line &Endings' 1 1 nil nil nil 5058 1 1394 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 5058 1 1394 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 5058 1 1394 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 5058 1 1394 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 nil nil 33535 nil nil 8 '&Workspace' nil 134217729 nil nil 33537 nil nil 5010 nil true 34 4 5058 1 1394 #browseLocalMessageDefinitions 8 '&Definitions Of...' 1 1 nil nil nil 5058 1 1394 #browseLocalMessageReferences 8 '&References To...' 1 1 nil nil nil 5122 4097 5058 1 1394 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 33545 nil nil 5010 nil true 34 10 5058 1 1394 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 5058 2097153 1394 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 5122 4097 5058 1 1394 #checkOut 8 'Check Out &All' 1 1 nil nil nil 5058 1 1394 #checkOutChanges 8 '&Check Out Changes' 9367 1 nil nil nil 5058 1 1394 #checkIn 8 'Check &In' 9387 1 nil nil nil 5122 4097 5058 1 1394 #savePackageChanges 8 'Save C&hanges' 1 1 1442 nil true 1488 8 'FileSave.ico' 1664 nil nil 5122 4097 5058 1 1394 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' nil 134217729 nil nil 33561 nil nil 5010 nil true 34 10 5058 1 1394 #renameMethod 8 'Re&name Method...' 1 1 nil nil nil 5058 1 1394 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 5122 4097 5058 1 1394 #safeRemoveMethod 8 'Re&move Method...' 1 1 nil nil nil 5058 1 1394 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 5122 4097 5058 1 1394 #addParameter 8 'Add Method &Parameter...' 1 1 nil nil nil 5058 1 1394 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 nil nil nil 5122 4097 5058 1 1394 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 nil nil nil 8 'Refactorin&gs' #refactoringsMenu 134217729 nil nil 33577 nil nil 5010 nil true 34 3 5058 1 1394 #undoChange 8 '&Undo <1d>' 1 1 1442 nil true 1488 8 'EditUndo.ico' 1664 nil nil 5058 1 1394 #redoChange 8 '&Redo <1d>' 1 1 1442 nil true 1488 8 'EditRedo.ico' 1664 nil nil 5058 1 1394 #clearChangeHistory 8 'Clear Change &History' 1 1 nil nil nil 8 'H&istory' nil 134217729 nil nil 33585 nil nil 5010 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 33587 nil nil 5010 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 33589 nil nil 5010 nil true 34 15 5058 1 1394 #helpContents 8 '&Contents' 1025 1 1442 nil true 1488 49 20640 nil nil 5058 1 1394 #help 8 'On this &Tool' 1249 1 nil nil nil 5058 1 1394 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 5122 4097 5058 1 1394 #learnSmalltalk 8 'Learn Smalltalk' 1 1 nil nil nil 5122 4097 5058 1 1394 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 5058 1 1394 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 5058 1 1394 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 5122 4097 5058 1 1394 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 nil nil nil 5058 1 1394 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 5058 1 1394 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 5122 4097 5058 1 1394 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 1442 nil true 1488 8 '!!APPLICATION' 1664 nil nil 8 '&Help' nil 134217729 nil nil 33613 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 738 771 621 1 nil nil 962 138 144 34 3 1026 #createAt:extent: 34 2 738 3839 21 738 1421 1041 416 1026 #text: 34 1 8 'Package Browser' 416 1026 #updateMenuBar 1152 416 1106 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 69 10 0 0 18 2 0 0] 34 3 544 3984 3344 1168 nil 27 )!

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

