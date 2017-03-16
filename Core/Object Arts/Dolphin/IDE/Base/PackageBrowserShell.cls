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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851532 131073 560 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 167 4 112 212 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 0 560 642 672 8 4294903529 234 256 98 8 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 864 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 864 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Image_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 770 1 1 770 63 51 864 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 98 0 770 193 193 0 27 8 'imageTools' 410 880 98 14 0 560 98 2 8 1140850688 131073 1280 0 946 31 0 7 0 0 0 1280 978 576 8 #resource_Smalltalk_tools 0 1026 202 208 98 1 1090 1120 98 2 770 63 1 770 991 51 1280 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 1232 1248 0 27 8 'smalltalkTools' 410 576 98 25 0 560 98 2 8 1140853580 131073 1552 0 642 672 0 519 0 0 0 1552 642 672 8 4294903529 234 256 1232 234 256 98 8 32869 1115910 ##(Smalltalk.ToolbarIconButton) 32869 0 1552 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #browsePackageSources 8 'Open Source Browser' 1 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'SourceManager.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 395334 3 ##(Smalltalk.Bitmap) 0 16 0 0 0 0 3 770 33 33 1 32863 1714 32863 0 1552 1 1746 8 #newPackage 8 'New Package' 1 1 1810 0 16 1856 8 'DocumentShell.ico' 0 1938 0 16 0 0 0 0 3 770 33 33 1 32865 1714 32865 0 1552 1 1746 8 #openPackage 8 'Install Package' 1 1 1810 0 16 1856 8 'FileOpen.ico' 1904 1938 0 16 0 0 0 0 3 770 33 33 1 32867 1714 32867 0 1552 1 1746 8 #savePackageChanges 8 'Save Package Changes' 1 1 1810 0 16 1856 8 'FileSave.ico' 1904 1938 0 16 0 0 0 0 3 770 33 33 1 98 5 1984 2112 2240 1728 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 1552 3 0 1 234 240 98 8 2336 5 2080 1 2208 3 1952 7 0 1 0 770 33 33 770 45 45 0 0 1026 202 208 98 2 1090 1120 98 2 770 1053 1 770 201 51 1552 1090 8 #updateSizePosted 1232 1552 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 114 2 0 0 25 0 0 0] 98 0 1248 0 27 8 'fileTools' 410 576 98 25 0 560 98 2 8 1140853612 131137 2688 0 642 672 0 519 0 0 0 2688 642 672 8 4294903529 234 256 1232 234 256 98 2 32871 853766 ##(Smalltalk.ToolbarButton) 32871 0 2688 17 1746 8 #viewModeSelect 8 'Views' 1 1 0 1938 0 16 1856 8 'ViewBar.bmp' 1904 0 7 770 129 33 3 98 1 2864 234 240 98 2 2928 1 0 1 0 770 33 33 770 45 45 0 0 1026 202 208 98 2 1090 1120 98 2 770 1253 1 770 77 51 2688 1090 2608 1232 2688 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 114 2 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 98 0 1248 0 27 8 'viewTools' 234 256 1232 98 0 234 240 1232 0 1 0 770 33 33 770 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 1389 51 560 1090 2608 1232 560 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 25 0 0 0] 98 4 864 1280 1552 2688 1248 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 3536 0 642 672 0 7 0 690 0 16 722 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 770 193 193 0 3536 0 8 4294905391 234 256 98 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 3536 0 459270 ##(Smalltalk.Message) 8 #displayString 98 0 787814 3 ##(Smalltalk.BlockClosure) 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 3744 8 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] 8 #iconImageIndex 3856 7 257 0 0 8 'version' 3746 1 -1 3536 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 98 1 3968 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3536 0 0 1026 202 208 98 1 1090 1120 98 2 770 1 883 770 1389 41 3536 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 182 2 0 0 205 1 0 0] 98 0 1248 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 4272 0 0 0 7 0 0 0 4272 1180166 ##(Smalltalk.ProportionalLayout) 234 240 1232 16 234 256 1232 0 1026 202 208 98 1 1090 1120 98 2 770 1 51 770 1389 833 4272 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 182 2 0 0 185 1 0 0] 98 1 410 4288 98 15 0 4272 98 2 8 1140850688 131073 4576 0 0 0 7 0 0 0 4576 4354 234 240 98 2 410 4288 98 15 0 4576 98 2 8 1140850688 131073 4688 0 0 0 7 0 0 0 4688 4354 202 8 ##(Smalltalk.Dictionary) 98 1 721414 ##(Smalltalk.Association) 410 8 ##(Smalltalk.CardContainer) 98 16 0 4688 98 2 8 1140850688 131073 4848 0 642 8 4278190080 0 7 0 0 0 4848 655878 ##(Smalltalk.CardLayout) 202 208 98 8 4818 8 'Scripts' 410 4288 98 15 0 4848 98 2 8 1140850688 131073 5056 0 642 4944 0 5 0 0 0 5056 852230 ##(Smalltalk.FramingLayout) 234 240 98 4 410 8 ##(Smalltalk.ScintillaView) 98 50 0 5056 98 2 8 1176572228 1025 5200 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 642 4944 0 21 265030 4 ##(Smalltalk.Menu) 0 16 98 16 984134 2 ##(Smalltalk.CommandMenuItem) 1 1746 8 #accept 8 '&Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5362 0 16 98 9 5410 1 1746 8 #undo 8 '&Undo' 1 1 0 0 0 5490 4097 5410 1 1746 8 #cutSelection 8 'Cu&t' 1 1 0 0 0 5410 1 1746 8 #copySelection 8 '&Copy' 1 1 0 0 0 5410 1 1746 8 #pasteClipboard 8 '&Paste' 1 1 0 0 0 5410 1 1746 8 #clearSelection 8 'De&lete' 1 1 0 0 0 5410 1 1746 8 #reformatSource 8 'Re&format' 1 1 0 0 0 5490 4097 5410 1 1746 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 5410 1 1746 8 #clear 8 'Clea&r' 1 1 0 0 0 5490 4097 5410 1 1746 8 #browseIt 8 'Bro&wse It' 1 1 1810 0 16 1856 8 'ClassBrowserShell.ico' 1904 0 0 5410 1 1746 8 #displayIt 8 '&Display It' 1 1 0 0 0 5410 1 1746 8 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 5410 1 1746 8 #inspectIt 8 '&Inspect It' 1 1 1810 0 16 1856 8 'BasicInspector.ico' 1904 0 0 5410 1 1746 8 #debugIt 8 'Deb&ug It' 1 1 1810 0 16 1856 8 'Debugger.ico' 1904 0 0 5490 4097 5410 1 1746 8 #chooseEvaluationPools 8 '&Pools...' 1 1 0 0 0 5410 1 1746 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 5410 1 1746 8 #cloneNew 8 'Clo&ne' 1 1 0 0 0 5490 4097 5362 0 16 98 3 5410 2097153 1746 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 5410 1 1746 8 #browseReferences 8 '&References...' 1 1 0 0 0 5410 1 1746 8 #browseMessages 8 '&Messages...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 5200 0 8 4294905031 852486 ##(Smalltalk.NullConverter) 0 0 9 0 234 256 98 4 8 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 7104 0 0 0 8 #callTip 7122 77 786694 ##(Smalltalk.IndexedColor) 33554457 7186 33554471 1 0 0 0 0 7152 0 0 0 98 40 7136 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 0 0 32 202 208 1232 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 5200 8 #circle 0 0 0 0 0 0 202 208 1232 0 63 9215 0 0 0 0 7186 33554447 0 0 65 0 0 234 256 98 6 8 #specialCharacter 8 '()[]<>' 8 #literalBytes 8 '[]' 8 #literalArray 8 '()' 8 '' 3 234 256 98 2 8 #container 7072 0 0 0 0 3 0 234 256 98 4 8 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 5200 33423361 3 32 7648 0 0 0 0 0 0 8 #Error 7666 19 5200 33554459 3 32 7696 0 0 0 0 0 0 0 0 234 256 98 6 8 #Notification 7122 1029 0 482 31185883 1 0 0 0 0 7760 0 0 0 7696 7122 1031 482 335 482 31317503 1 0 0 0 0 7696 0 0 0 7648 7122 1027 482 60239 482 31326207 1 0 0 0 0 7648 0 0 0 0 1026 202 208 98 12 1090 1120 98 2 770 21 21 770 787 703 5200 1090 8 #contextMenu: 98 1 5376 5200 1090 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 5200 1090 8 #isTextModified: 98 1 32 5200 1090 8 #modificationEventMask: 98 1 9215 5200 1090 8 #secondaryCaretForecolor: 98 1 482 16711423 5200 1090 8 #caretPeriod: 98 1 1061 5200 1090 8 #wordWrap: 98 1 16 5200 1090 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 5200 1 3 32 1 5 8466 3 5200 1 1 32 67108863 5 8466 5 5200 1 1 32 1 5 5200 1090 8 #canHScroll: 98 1 32 5200 1090 8 #tabIndents: 98 1 16 5200 1090 8 #areAdditionalCaretsVisible: 98 1 16 5200 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 147 1 0 0 105 1 0 0] 98 0 1248 0 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) 8 #fixedParentLeft 21 8754 8 #fixedParentRight -91 8754 8 #fixedParentTop 21 8754 8 #fixedParentBottom -19 410 8 ##(Smalltalk.TabView) 98 23 0 5056 98 2 8 1140916866 1 8896 590662 2 ##(Smalltalk.ListModel) 202 208 1232 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 642 4944 0 5 0 0 0 8896 0 8 4294903943 3842 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 8 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] 8 #key 9088 7 257 0 3842 0 0 9106 3 1 9136 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] 8 #icon 8 #imageIndex 9216 7 257 0 4032 0 0 0 0 0 8 #smallIcons 1026 202 208 98 2 1090 1120 98 2 770 1 1 770 899 743 8896 1090 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 8896 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 193 1 0 0 115 1 0 0] 98 0 1248 0 27 8722 8768 1 8800 1 8832 1 8864 1 234 256 98 4 5200 8 'scriptText' 8896 8 'scriptNames' 0 1026 202 208 98 1 1090 1120 98 2 770 9 101 770 905 725 5056 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 98 2 5200 8896 1248 0 27 4818 8 'Prerequisites' 410 880 98 14 0 4848 98 2 8 1140850688 131073 9824 0 0 0 5 0 0 0 9824 978 8 ##(Smalltalk.PackageDependencyPresenter) 8 #resource_Default_view 0 1026 202 208 98 1 1090 1120 98 2 770 9 101 770 905 725 9824 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 1232 1248 0 27 4818 8 'Comment' 410 5216 98 50 0 4848 98 2 8 1176572228 1 10112 5282 0 32 5328 0 482 30932991 0 7 5362 0 16 98 12 5410 1 1746 5456 8 '&Accept' 1 1 0 0 0 5490 4097 5362 0 16 98 8 5410 1 1746 5584 8 '&Undo' 1 1 0 0 0 5490 4097 5410 1 1746 5664 8 'Cu&t' 1 1 0 0 0 5410 1 1746 5728 8 '&Copy' 1 1 0 0 0 5410 1 1746 5792 8 '&Paste' 1 1 0 0 0 5410 1 1746 5856 8 'De&lete' 1 1 0 0 0 5490 4097 5410 1 1746 6000 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 5410 1 1746 6080 8 'Clea&r' 1 1 0 0 0 5490 4097 5410 1 1746 6160 8 'Bro&wse It' 1 1 6192 0 0 5410 1 1746 6256 8 '&Display It' 1 1 0 0 0 5410 1 1746 6320 8 'E&valuate It' 1 1 0 0 0 5410 1 1746 6384 8 '&Inspect It' 1 1 6416 0 0 5410 1 1746 6480 6496 1 1 6512 0 0 5490 4097 5362 0 16 98 2 5410 2097153 1746 6832 8 'Defi&nitions...' 1 1 0 0 0 5410 1 1746 6896 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 10112 482 8454145 8 4294905031 7042 0 0 9 0 234 256 98 4 7104 7122 1 0 0 1 0 0 0 0 7104 0 0 0 7152 7122 77 7200 7216 1 0 0 0 0 7152 0 0 0 98 40 11216 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) 7104 234 256 98 2 7328 7346 1 0 0 0 10112 7376 0 0 0 0 0 0 202 208 1232 0 63 9215 0 0 0 0 7408 0 0 65 0 0 0 7552 3 234 256 98 2 7600 11184 0 0 0 0 1 0 234 256 98 4 7648 7666 19 10112 33423361 3 32 7648 0 0 0 0 0 0 7696 7666 17 10112 33554459 3 32 7696 0 0 0 0 0 0 0 0 234 256 98 6 7760 7122 1029 0 482 31185883 1 0 0 0 0 7760 0 0 0 7696 7122 1031 482 335 482 31317503 1 0 0 0 0 7696 0 0 0 7648 7122 1027 482 60239 482 31326207 1 0 0 0 0 7648 0 0 0 0 1026 202 208 98 11 1090 1120 98 2 770 9 101 770 905 725 10112 1090 8032 98 1 10208 10112 1090 8080 98 1 8114 3 1 3 10112 1090 8160 98 1 32 10112 1090 8208 98 1 9215 10112 1090 8256 98 1 482 16711423 10112 1090 8320 98 1 1061 10112 1090 8368 98 1 16 10112 1090 8416 98 1 98 3 8466 1 10112 1 3 32 1 5 8466 3 10112 1 1 32 67108863 5 8466 5 10112 1 1 32 1 5 10112 1090 8592 98 1 16 10112 1090 8640 98 1 16 10112 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 98 0 1248 0 29 4818 8 'Dependents' 410 880 98 14 0 4848 98 2 8 1140850688 131073 12224 0 0 0 5 0 0 0 12224 978 9904 9920 0 1026 202 208 98 1 1090 1120 98 2 770 9 101 770 905 725 12224 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 1232 1248 0 27 4818 8 'Loose Methods' 410 8 ##(Smalltalk.ListView) 98 30 0 4848 98 2 8 1140920393 1 12480 8978 202 208 1232 0 9040 642 4944 0 29 5362 0 16 98 10 5410 2097153 1746 8 #browseMethods 8 'Browse <1d>' 1 1 0 0 0 5410 1 1746 8 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 0 0 0 5410 1 1746 8 #browseMessageReferences 8 'All Re&ferences' 1 1 0 0 0 5410 1 1746 8 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 0 0 0 5410 1 1746 8 #browseLocalMessageReferences 8 '&Local References' 1 1 0 0 0 5490 4097 5410 1 1746 8 #removeLooseMethods 8 '&Remove from Package' 1 1 0 0 0 5362 0 16 98 7 5410 1 1746 8 #renameMethod 8 'Re&name' 1 1 0 0 0 5410 1 1746 8 #renameMethodReferences 8 'Rename Re&ferences' 1 1 0 0 0 5490 4097 5410 1 1746 8 #safeRemoveMethods 8 '&Remove' 1 1 0 0 0 5490 4097 5410 1 1746 8 #addParameterToMethod 8 'Add &Parameter...' 1 1 0 0 0 5362 0 16 98 0 8 'Remo&ve Parameter' 8 #removeParameterMenu 134217729 0 0 0 0 0 8 'Refactorin&gs' 8 #methodRefactoringsMenu 134217729 0 0 0 0 0 5490 4097 5362 0 16 98 1 5410 1 1746 8 #browseLooseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 8 'C&hanges' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 12480 0 8 4294909021 3984 4000 4032 0 0 0 770 65 65 0 0 202 208 98 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Selector' 401 8 #left 3778 8 #selector 98 0 3842 0 0 9106 2 1 9136 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] 13744 13776 7 513 0 0 0 12480 4000 1 0 3842 0 0 9106 4 1 9136 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4818 8 #ClassBrowserAbstract 8 ##(Smalltalk.ClassBrowserAbstract) 8 #looseMethodColor 8 #forecolor: 13856 7 257 0 13666 8 'Class' 389 13712 3984 8 ##(Smalltalk.SortedCollection) 3778 8 #methodClass 98 0 0 12480 4000 1 0 3842 0 0 9106 4 1 9136 8 'doIt' 8 '[:ctx | ctx forecolor: Color black]' 8 #[32 105 17 45 159 178 106] 4818 8 #Color 8 ##(Smalltalk.Color) 8 #black 14000 14112 7 257 0 13666 8 'Package' 109 13712 3984 3842 0 0 9106 2 1 9136 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 8 #name 14288 7 513 0 3778 8 #owningPackage 98 0 0 12480 0 3 0 0 8 #report 1232 0 131173 0 98 1 0 1026 202 208 98 3 1090 1120 98 2 770 9 101 770 905 725 12480 1090 8032 98 1 12608 12480 1090 8 #text: 98 1 8 'Selector' 12480 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 98 0 1248 0 27 4818 8 'Globals' 410 12496 98 30 0 4848 98 2 8 1140920393 1 14752 8978 202 208 1232 0 9040 642 4944 0 29 5362 0 16 98 6 5410 1 1746 8 #addGlobal 8 '&Add Uncommitted...' 1 1 0 0 0 5410 1 1746 8 #removeGlobals 8 '&Remove from Package' 1 1 0 0 0 5490 4097 5410 2097153 1746 8 #inspectGlobals 8 '&Inspect' 1 1 0 0 0 5410 1 1746 8 #browseGlobalReferences 8 'All Re&ferences' 1 1 0 0 0 5410 1 1746 8 #browseLocalGlobalReferences 8 '&Local References' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 14752 0 8 4294909021 3984 3842 0 0 9106 4 1 9136 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 4818 8 #Smalltalk 48 9296 9312 15264 7 257 0 4032 0 0 0 770 65 65 0 0 202 208 98 4 13666 8 '' 41 13712 3842 0 0 9106 3 1 9136 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 15456 7 257 0 3842 0 0 9106 3 1 9136 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] 8 #not 8 #& 15568 7 513 0 3842 0 0 9106 6 1 9136 8 'doIt' 8 '[:x | [(Smalltalk at: x) isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 45 17 148 159 106 47 34 111 59 106 193 106] 15344 8 #isChanged 4818 7696 8 ##(Smalltalk.Error) 8 #on:do: 15680 3842 0 0 15696 39 257 0 7 257 0 0 14752 3842 0 0 9106 4 1 9136 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4818 8 #Package 8 ##(Smalltalk.Package) 8 #changedIcon 9312 15840 7 257 0 1 0 0 13666 8 'Global' 301 13712 3984 14048 0 0 14752 3842 0 0 9106 4 1 9136 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 15344 9296 9312 16016 7 257 0 1 0 0 13666 8 'Package' 201 13712 3984 3842 0 0 9106 2 1 9136 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 14368 16128 7 513 0 3842 0 0 9106 4 1 9136 8 'doIt' 8 '[:x | Package manager packageOfGlobalNamed: x]' 8 #[32 105 45 159 17 178 106] 15920 8 #manager 8 #packageOfGlobalNamed: 16208 7 257 0 0 14752 0 1 0 0 13666 8 'File Out Name' 2001 13712 3984 14048 3842 0 0 9106 6 1 9136 8 'doIt' 8 '[:x | | glob |
glob := Smalltalk at: x.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[34 105 45 17 148 70 144 30 178 120 18 161 106 33 106] 4818 15360 48 8 #sourceObject 8 #conformsToProtocol: 8 #fileOutName 8 '' 16352 7 65793 0 0 14752 0 1 0 0 14432 1232 0 133221 0 98 1 0 1026 202 208 98 2 1090 1120 98 2 770 9 101 770 905 725 14752 1090 8032 98 1 14864 14752 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 98 0 1248 0 27 4818 8 'Classes' 410 12496 98 30 0 4848 98 2 8 1140920395 1 16752 8978 202 208 1232 0 9040 642 4944 0 29 5362 0 16 98 8 5410 2097153 1746 8 #browseClass 8 '&Browse' 1 1 1810 0 16 1856 8 'ClassBrowserShell.ico' 1904 0 0 5410 1 1746 8 #browseClassReferences 8 'All Re&ferences' 1 1 0 0 0 5410 1 1746 8 #browseLocalClassReferences 8 'L&ocal References' 1 1 0 0 0 5490 4097 5410 1 1746 8 #addClass 8 '&Add Uncommitted..' 1 1 0 0 0 5410 1 1746 8 #removeClasses 8 '&Remove from Package' 1 1 0 0 0 5490 4097 5362 0 16 98 2 5410 1 1746 8 #browseClassEditions 8 'Browse Class &Editions' 1 1 0 0 0 5410 1 1746 8 #compareClass 8 'Compare Class Edition...' 1 1 0 0 0 8 'C&hanges' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 16752 0 8 4294909021 3778 14368 98 0 4000 4032 0 0 0 770 65 65 0 0 202 208 98 4 13666 8 '' 41 13712 3842 0 0 9106 3 1 9136 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 15552 17600 7 257 0 3842 0 0 9106 3 1 9136 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] 15648 15664 17696 7 513 0 3778 15760 98 0 0 16752 3842 0 0 9106 4 1 9136 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 15920 15968 9312 17808 7 257 0 1 0 0 13666 8 'Name' 375 13712 3778 14368 98 0 14048 0 0 16752 4000 1 0 0 13666 8 'Package' 201 13712 3984 3842 0 0 9106 2 1 9136 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] 14368 17984 7 513 0 3778 14400 98 0 0 16752 0 1 0 0 13666 8 'File Out Name' 2001 13712 3984 14048 3842 0 0 9106 2 1 9136 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] 16480 18128 7 257 0 0 16752 0 1 0 0 8 #list 1232 0 133221 0 98 1 0 1026 202 208 98 2 1090 1120 98 2 770 9 101 770 905 725 16752 1090 8032 98 1 16864 16752 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 98 0 1248 0 27 4818 8 'Resources' 410 880 98 14 0 4848 98 2 8 1140850688 131073 18464 0 642 8 4278190080 0 5 5362 0 16 98 4 5410 2097153 1746 8 #editResource 8 '&Edit' 1 1 0 0 0 5410 1 1746 8 #showResource 8 '&Show' 1 1 0 0 0 5490 4097 5410 1 1746 8 #deleteResource 8 '&Delete' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 18464 978 8 ##(Smalltalk.ResourceListPresenter) 8 #resource_Package_view 0 1026 202 208 98 2 1090 1120 98 2 770 9 101 770 905 725 18464 1090 8032 98 1 18560 18464 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 1232 1248 0 27 10112 234 256 98 16 12224 8 'dependents' 5056 8 'scripts' 12480 8 'methods' 14752 8 'globals' 9824 8 'prerequisites' 18464 8 'resources' 10112 8 'comment' 16752 8 'classes' 0 410 8912 98 23 0 4848 98 2 8 1140916736 1 19200 8978 202 208 98 8 10096 16736 12464 18448 14736 5040 9808 12208 0 9040 946 31 0 1 0 0 0 19200 0 8 4294903943 3984 4000 4032 0 0 0 0 0 8 #noIcons 1026 202 208 98 3 1090 1120 98 2 770 1 1 770 921 833 19200 1090 8 #basicSelectionsByIndex: 98 1 98 1 3 19200 1090 9472 98 2 -1 1 19200 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 98 0 1248 0 27 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 921 833 4848 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 98 9 10112 16752 12480 18464 14752 5056 9824 12224 19200 1248 0 27 5 32 234 256 98 2 4848 8 'ownedCards' 0 1026 202 208 98 1 1090 1120 98 2 770 469 1 770 921 833 4688 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 98 1 4848 1248 0 27 5 32 234 256 98 2 410 880 98 14 0 4576 98 2 8 1140850688 131073 20016 0 0 0 7 0 0 0 20016 978 8 ##(Smalltalk.PackageSelector) 9920 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 459 833 20016 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 0 0 0 160 1 0 0] 1232 1248 0 27 8 'packages' 0 1026 202 208 98 1 1090 1120 98 2 770 1 1 770 1389 833 4576 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 98 3 20016 410 8 ##(Smalltalk.Splitter) 98 12 0 4576 98 2 8 1140850688 1 20432 0 642 4944 0 519 0 0 0 20432 1026 202 208 98 1 1090 1120 98 2 770 459 1 770 11 833 20432 1186 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 229 0 0 0 0 0 0 0 234 0 0 0 160 1 0 0] 98 0 1248 0 27 4688 1248 0 27 1248 0 27 234 256 98 4 560 8 'toolbar' 3536 8 'statusbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 10 5362 0 16 98 30 5410 1 1746 2016 8 '&New Package...' 9373 5 0 0 0 5410 1 1746 2144 8 '&Install Package...' 9375 5 0 0 0 5410 1 1746 8 #removePackage 8 '&Uninstall Package' 1 5 0 0 0 5490 4097 5362 0 16 98 2 5410 2097153 1746 17168 8 '&Class...' 1 1 0 0 0 5410 1 1746 14928 8 '&Global...' 1 1 0 0 0 8 'Add Unco&mmitted' 0 134217729 0 0 32903 0 0 5410 1 1746 8 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 0 0 0 5410 1 1746 8 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 5490 4097 5410 1 1746 8 #savePackages 8 '&Save Package' 1 1 1810 0 16 1856 8 'FileSave.ico' 1904 0 0 5410 1 1746 2272 8 'Save Package C&hanges' 1 1 0 0 0 5410 1 1746 8 #savePackageAs 8 'Save Package &As...' 1 1 0 0 0 5490 4097 5410 1 1746 8 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 0 0 0 5410 1 1746 1776 8 'Bro&wse PAX Sources' 1 1 0 0 0 5490 4097 5410 1 1746 8 #loadPackageFromRepository 8 'Load Edition...' 1 1 0 0 0 5410 1 1746 8 #importPackageFromFile 8 'Import to Repository...' 1 5 0 0 0 5410 1 1746 8 #versionPackage 8 'Version...' 1 1 0 0 0 5410 1 1746 8 #browsePackageEditions 8 'Browse Editions' 1 1 0 0 0 5410 1 1746 8 #compareWithAnotherEdition 8 'Compare with...' 1 1 0 0 0 5490 4097 5410 1 1746 8 #saveImage 8 'Sa&ve Image' 1 1 1810 0 16 1856 8 'Snapshot.ico' 1904 0 0 5410 1 1746 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 1810 0 16 1856 8 'PowerSwitch.ico' 1904 0 0 5490 4097 5362 0 16 98 1 5410 2097153 1746 8 #browseTests 8 '&Browse' 1 1 0 0 0 8 '&Tests' 0 1 1810 0 16 1856 8 'TestRunner.ico' 0 0 32935 0 0 5362 0 16 98 4 5410 2097153 1746 8 #deploy 8 '&Deploy Executable...' 13445 1 0 0 0 5410 1 1746 8 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 0 0 0 5490 4097 5410 1 1746 8 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 0 0 0 8 '&Deployment' 0 134217729 1810 0 16 1856 8 'ApplicationDeploymentWizard.ico' 1904 0 32943 0 0 5490 4097 5410 1 1746 8 #inspectPackage 8 'P&roperties' 1 1 0 0 0 5490 4097 5410 1 1746 8 #exit 8 '&Close' 17639 1 1810 0 16 1856 8 'CloseWindow.ico' 1904 0 0 8 '&File' 0 134217729 0 0 32949 0 0 5362 0 16 98 12 5410 1 1746 5584 8 '&Undo' 9397 1 1810 0 16 1856 8 'EditUndo.ico' 1904 0 0 5490 4097 5410 1 1746 5664 8 'Cu&t' 9393 1 1810 0 16 1856 8 'EditCut.ico' 1904 0 0 5410 1 1746 5728 8 '&Copy' 9351 1 1810 0 16 1856 8 'EditCopy.ico' 1904 0 0 5410 1 1746 5792 8 '&Paste' 9389 1 1810 0 16 1856 8 'EditPaste.ico' 1904 0 0 5410 1 1746 8 #editDelete 8 '&Delete' 1 1 1810 0 16 1856 8 'EditClear.ico' 1904 0 0 5490 4097 5410 1 1746 6000 8 'Select &All' 9347 1 0 0 0 5490 4097 5410 1 1746 8 #editFind 8 '&Find...' 9357 1 1810 0 16 1856 47 786694 ##(Smalltalk.ShellLibrary) 0 0 5410 1 1746 8 #findNext 8 'Find &Next' 1253 1 1810 0 16 1856 8 'FindNext.ico' 1904 0 0 5410 1 1746 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 32969 0 0 5362 0 16 98 13 5410 1 1746 6160 8 '&Browse It' 9349 1 1810 0 16 1856 8 'ClassBrowserShell.ico' 1904 0 0 5410 1 1746 6256 8 '&Display It' 9353 1 1810 0 16 1856 8 'DisplayIt.ico' 1904 0 0 5410 1 1746 6320 8 '&Evaluate It' 9355 1 1810 0 16 1856 8 'EvaluateIt.ico' 1904 0 0 5410 1 1746 6384 8 '&Inspect It' 9363 1 1810 0 16 1856 8 'BasicInspector.ico' 1904 0 0 5410 1 1746 6480 8 'Deb&ug It' 1269 1 1810 0 16 1856 8 'Debugger.ico' 1904 0 0 5410 1 1746 8 #fileItIn 8 '&File It In' 1 1 0 0 0 5490 4097 5410 1 1746 6832 8 'Defi&nitions...' 1271 1 0 0 0 5410 1 1746 6896 8 '&References...' 5367 1 0 0 0 5490 4097 5410 1 1746 5456 8 '&Accept' 9383 1 0 0 0 5490 4097 5362 0 16 98 7 5410 1 1746 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 5410 1 1746 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 5410 1 1746 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 5410 1 1746 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 5410 1 1746 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 5410 1 1746 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 5410 1 1746 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 33003 0 0 8 '&Workspace' 0 134217729 0 0 33005 0 0 5362 0 16 98 4 5410 1 1746 12864 8 '&Definitions Of...' 1 1 0 0 0 5410 1 1746 12928 8 '&References To...' 1 1 0 0 0 5490 4097 5410 1 1746 8 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 33013 0 0 5362 0 16 98 10 5410 1 1746 21552 8 'Use PAX S&ource Format' 1 1 0 0 0 5410 2097153 1746 1776 8 'Bro&wse PAX Sources' 1 1 0 0 0 5490 4097 5410 1 1746 8 #checkOut 8 'Check Out &All' 1 1 0 0 0 5410 1 1746 8 #checkOutChanges 8 '&Check Out Changes' 9367 1 0 0 0 5410 1 1746 8 #checkIn 8 'Check &In' 9387 1 0 0 0 5490 4097 5410 1 1746 2272 8 'Save C&hanges' 1 1 1810 0 16 1856 8 'FileSave.ico' 1904 0 0 5490 4097 5410 1 1746 8 #resetChangeFlags 8 'Clear Change &Markers' 1 1 0 0 0 8 'Sou&rce Control' 0 134217729 0 0 33029 0 0 5362 0 16 98 10 5410 1 1746 13104 8 'Re&name Method...' 1 1 0 0 0 5410 1 1746 13168 8 'Rename Re&ferences...' 1 1 0 0 0 5490 4097 5410 1 1746 8 #safeRemoveMethod 8 'Re&move Method...' 1 1 0 0 0 5410 1 1746 8 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 5490 4097 5410 1 1746 8 #addParameter 8 'Add Method &Parameter...' 1 1 0 0 0 5410 1 1746 8 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 0 0 0 5490 4097 5410 1 1746 8 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 0 0 0 8 'Refactorin&gs' 8 #refactoringsMenu 134217729 0 0 33045 0 0 5362 0 16 98 3 5410 1 1746 8 #undoChange 8 '&Undo <1d>' 1 1 1810 0 16 1856 8 'EditUndo.ico' 1904 0 0 5410 1 1746 8 #redoChange 8 '&Redo <1d>' 1 1 1810 0 16 1856 8 'EditRedo.ico' 1904 0 0 5410 1 1746 8 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 33053 0 0 5362 0 16 98 0 8 '&Tools' 8 #toolsMenu 134217729 0 0 33055 0 0 5362 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 33057 0 0 5362 0 16 98 15 5410 1 1746 8 #helpContents 8 '&Contents' 1025 1 1810 0 16 1856 49 23472 0 0 5410 1 1746 8 #help 8 'On this &Tool' 1249 1 0 0 0 5410 1 1746 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5490 4097 5410 1 1746 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5490 4097 5410 1 1746 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 5410 1 1746 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 5410 1 1746 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5490 4097 5410 1 1746 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 5410 1 1746 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 5410 1 1746 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5490 4097 5410 1 1746 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 1810 0 16 1856 8 '!!APPLICATION' 1904 0 0 8 '&Help' 0 134217729 0 0 33081 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 770 771 621 1 0 0 1026 202 208 98 3 1090 1120 98 2 770 3839 21 770 1421 1041 416 1090 14624 98 1 8 'Package Browser' 416 1090 8 #updateMenuBar 1232 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 69 10 0 0 18 2 0 0] 98 3 560 4272 3536 1248 0 27 )!

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

