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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 0 0 8 #(13565952 65536) 416 0 196934 1 ##(Smalltalk.RGB) 8 4294967295 0 519 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 0 416 34 2 8 1140851532 131073 544 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 519 0 263174 ##(Smalltalk.Font) 0 true 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 167 4 112 212 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 0 544 610 640 8 4294906655 170 192 34 8 410 ##(Smalltalk.Toolbar) 34 25 0 544 34 2 8 1140853580 131073 832 0 610 640 0 519 0 0 0 832 610 640 8 4294906655 170 192 8 #() 170 192 34 8 40043 1115910 ##(Smalltalk.ToolbarIconButton) 40043 0 832 1 1180998 4 ##(Smalltalk.CommandDescription) #newPackage 8 'New Package' 1 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'DocumentShell.ico' 0 395334 3 ##(Smalltalk.Bitmap) 0 true 0 0 0 0 3 738 33 33 1 40045 1010 40045 0 832 1 1042 #openPackage 8 'Install Package' 1 1 1090 0 true 1136 8 'FileOpen.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 1170 0 true 0 0 0 0 3 738 33 33 1 40047 1010 40047 0 832 1 1042 #savePackageChanges 8 'Save Package Changes' 1 1 1090 0 true 1136 8 'FileSave.ico' 1312 1170 0 true 0 0 0 0 3 738 33 33 1 40049 1010 40049 0 832 1 1042 #browsePackageSources 8 'Open Source Browser' 1 1 1090 0 true 1136 8 'SourceManager.ico' 1312 1170 0 true 0 0 0 0 3 738 33 33 1 34 5 1024 1216 1376 1488 1050118 ##(Smalltalk.ToolbarSeparator) 0 0 832 3 0 1 170 176 34 8 1344 3 1456 5 1568 7 1184 1 0 1 0 738 33 33 738 45 45 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 738 1053 1 738 201 51 832 1778 #updateSizePosted 960 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 14 2 0 0 0 0 0 0 114 2 0 0 25 0 0 0] 8 #() 738 193 193 0 27 8 'fileTools' 410 ##(Smalltalk.ReferenceView) 34 14 0 544 34 2 8 1140850688 131073 1968 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 0 0 1968 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 63 1 738 991 51 1968 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 960 1936 0 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 0 544 34 2 8 1140850688 131073 2256 0 2034 31 0 7 0 0 0 2256 2066 ##(Smalltalk.Toolbar) #resource_Image_tools 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 1 1 738 63 51 2256 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 960 1936 0 27 8 'imageTools' 410 ##(Smalltalk.Toolbar) 34 25 0 544 34 2 8 1140853612 131137 2512 0 610 640 0 519 0 0 0 2512 610 640 8 4294906655 170 192 960 170 192 34 2 40051 853766 ##(Smalltalk.ToolbarButton) 40051 0 2512 17 1042 #viewModeSelect 8 'Views' 1 1 0 1170 0 true 1136 8 'ViewBar.bmp' 1312 0 7 738 129 33 3 34 1 2688 170 176 34 2 2736 1 0 1 0 738 33 33 738 45 45 0 0 1714 138 144 34 2 1778 #createAt:extent: 34 2 738 1253 1 738 77 51 2512 1778 #updateSizePosted 960 2512 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 114 2 0 0 0 0 0 0 152 2 0 0 25 0 0 0] 8 #() 1936 0 27 8 'viewTools' 170 192 960 8 #() 170 176 960 0 1 0 738 33 33 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1714 138 144 34 2 1778 #createAt:extent: 34 2 738 1 1 738 1389 51 544 1778 #updateSizePosted 960 544 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 25 0 0 0] 34 4 2256 1968 832 2512 1936 0 27 410 ##(Smalltalk.StatusBar) 34 18 0 416 34 2 8 1140850956 1 3344 0 610 640 0 7 0 658 0 true 690 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 738 193 193 0 3344 0 8 4294903691 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 3344 0 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 0 918822 ##(Smalltalk.CompiledMethod) 2 3 3536 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 3632 7 257 0 0 8 'version' 3538 1 -1 3344 0 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 34 1 3712 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 3344 0 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 1 883 738 1389 41 3344 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 182 2 0 0 205 1 0 0] 8 #() 1936 0 27 0 0 410 ##(Smalltalk.ContainerView) 34 15 0 416 34 2 8 1140850688 131073 3984 0 0 0 7 0 0 0 3984 1180166 ##(Smalltalk.ProportionalLayout) 170 176 960 true 170 192 960 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 1 51 738 1389 833 3984 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 182 2 0 0 185 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 0 3984 34 2 8 1140850688 131073 4272 0 0 0 7 0 0 0 4272 4050 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 0 4272 34 2 8 1140850688 131073 4384 0 0 0 7 0 0 0 4384 4050 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.CardContainer) 34 16 0 4384 34 2 8 1140850688 131073 4528 0 610 8 4278190080 0 7 0 0 0 4528 655878 ##(Smalltalk.CardLayout) 138 144 34 8 4498 8 'Scripts' 410 ##(Smalltalk.ContainerView) 34 15 0 4528 34 2 8 1140850688 131073 4720 0 610 4608 0 5 0 0 0 4720 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.TabView) 34 23 0 4720 34 2 8 1140916866 1 4864 590662 2 ##(Smalltalk.ListModel) 138 144 960 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 610 4608 0 5 0 0 0 4864 0 8 4294903993 3618 0 0 1180966 ##(Smalltalk.CompiledExpression) 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] #key 5040 7 257 0 3618 0 0 5058 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] #icon #imageIndex 5136 7 257 0 3744 0 0 0 0 0 #smallIcons 1714 138 144 34 2 1778 #createAt:extent: 34 2 738 1 1 738 899 743 4864 1778 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 4864 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 193 1 0 0 115 1 0 0] 8 #() 1936 0 27 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 1 5442 #fixedParentRight 1 5442 #fixedParentTop 1 5442 #fixedParentBottom 1 410 ##(Smalltalk.ScintillaView) 34 50 0 4720 34 2 8 1176572228 1025 5520 721990 2 ##(Smalltalk.ValueHolder) 0 false 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 610 4608 0 21 265030 4 ##(Smalltalk.Menu) 0 true 34 16 984134 2 ##(Smalltalk.CommandMenuItem) 1 1042 #accept 8 '&Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 5666 0 true 34 9 5714 1 1042 #undo 8 '&Undo' 1 1 0 0 0 5778 4097 5714 1 1042 #cutSelection 8 'Cu&t' 1 1 0 0 0 5714 1 1042 #copySelection 8 '&Copy' 1 1 0 0 0 5714 1 1042 #pasteClipboard 8 '&Paste' 1 1 0 0 0 5714 1 1042 #clearSelection 8 'De&lete' 1 1 0 0 0 5714 1 1042 #reformatSource 8 'Re&format' 1 1 0 0 0 5778 4097 5714 1 1042 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 5714 1 1042 #clear 8 'Clea&r' 1 1 0 0 0 5778 4097 5714 1 1042 #browseIt 8 'Bro&wse It' 1 1 1090 0 true 1136 8 'ClassBrowserShell.ico' 1312 0 0 5714 1 1042 #displayIt 8 '&Display It' 1 1 0 0 0 5714 1 1042 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 5714 1 1042 #inspectIt 8 '&Inspect It' 1 1 1090 0 true 1136 8 'BasicInspector.ico' 1312 0 0 5714 1 1042 #debugIt 8 'Deb&ug It' 1 1 1090 0 true 1136 8 'Debugger.ico' 1312 0 0 5778 4097 5714 1 1042 #chooseEvaluationPools 8 '&Pools...' 1 1 0 0 0 5714 1 1042 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 5714 1 1042 #cloneNew 8 'Clo&ne' 1 1 0 0 0 5778 4097 5666 0 true 34 3 5714 2097153 1042 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 5714 1 1042 #browseReferences 8 '&References...' 1 1 0 0 0 5714 1 1042 #browseMessages 8 '&Messages...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 5520 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 7122 33554471 1 0 0 0 0 #callTip 0 0 0 #normal 7090 1 0 0 1 0 0 0 0 #normal 0 0 0 34 40 7168 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 0 0 false 138 144 960 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 5520 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 960 0 170 176 960 9215 0 0 0 0 7122 33554447 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 7056 0 0 0 0 3 0 170 192 34 4 #Warning 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 5520 33423361 3 false #Warning 0 0 0 0 0 0 #Error 7522 19 5520 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 7090 1029 0 466 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 7090 1027 466 60239 466 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 7090 1031 466 335 466 31317503 1 0 0 0 0 #Error 0 0 0 0 1714 138 144 34 7 1778 #createAt:extent: 34 2 738 21 21 738 787 703 5520 1778 #contextMenu: 34 1 5680 5520 1778 #modificationEventMask: 8 #(4607) 5520 1778 #caretPeriod: 8 #(530) 5520 1778 #wordWrap: 8 #(true) 5520 1778 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 5520 1 3 0 0 5 0 8018 3 5520 1 0 0 67108863 5 0 8018 5 5520 1 0 0 0 5 0 5520 1778 #canHScroll: 8 #(false) 5520 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 147 1 0 0 105 1 0 0] 8 #() 1936 0 29 5410 5456 21 5472 -91 5488 21 5504 -19 170 192 34 4 4864 8 'scriptNames' 5520 8 'scriptText' 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 9 101 738 905 725 4720 1874 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 34 2 5520 4864 1936 0 27 4498 8 'Prerequisites' 410 ##(Smalltalk.ReferenceView) 34 14 0 4528 34 2 8 1140850688 131073 8432 0 0 0 5 0 0 0 8432 2066 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 9 101 738 905 725 8432 1874 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 960 1936 0 27 4498 8 'Comment' 410 ##(Smalltalk.ScintillaView) 34 50 0 4528 34 2 8 1176572228 1 8688 5586 0 false 5632 0 466 30932991 0 7 5666 0 true 34 12 5714 1 1042 #accept 8 '&Accept' 1 1 0 0 0 5778 4097 5666 0 true 34 8 5714 1 1042 #undo 8 '&Undo' 1 1 0 0 0 5778 4097 5714 1 1042 #cutSelection 8 'Cu&t' 1 1 0 0 0 5714 1 1042 #copySelection 8 '&Copy' 1 1 0 0 0 5714 1 1042 #pasteClipboard 8 '&Paste' 1 1 0 0 0 5714 1 1042 #clearSelection 8 'De&lete' 1 1 0 0 0 5778 4097 5714 1 1042 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 5714 1 1042 #clear 8 'Clea&r' 1 1 0 0 0 5778 4097 5714 1 1042 #browseIt 8 'Bro&wse It' 1 1 6336 0 0 5714 1 1042 #displayIt 8 '&Display It' 1 1 0 0 0 5714 1 1042 #evaluateIt 8 'E&valuate It' 1 1 0 0 0 5714 1 1042 #inspectIt 8 '&Inspect It' 1 1 6512 0 0 5714 1 1042 #debugIt 6576 1 1 6592 0 0 5778 4097 5666 0 true 34 2 5714 2097153 1042 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 5714 1 1042 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 8688 466 8454145 8 4294906539 7026 0 0 9 0 170 192 34 4 #callTip 7090 77 7136 7152 1 0 0 0 0 #callTip 0 0 0 #normal 7090 1 0 0 1 0 0 0 0 #normal 0 0 0 34 40 9808 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 7282 1 0 0 0 8688 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 960 0 170 176 960 9215 0 0 0 0 7344 0 0 65 0 0 0 7440 3 170 192 34 2 #container 9760 0 0 0 0 1 0 170 192 34 4 #Warning 7522 19 8688 33423361 3 false #Warning 0 0 0 0 0 0 #Error 7522 17 8688 33554459 3 false #Error 0 0 0 0 0 0 0 0 170 192 34 6 #Notification 7090 1029 0 466 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 7090 1027 466 60239 466 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 7090 1031 466 335 466 31317503 1 0 0 0 0 #Error 0 0 0 0 1714 138 144 34 6 1778 #createAt:extent: 34 2 738 9 101 738 905 725 8688 1778 #contextMenu: 34 1 8784 8688 1778 #modificationEventMask: 8 #(4607) 8688 1778 #caretPeriod: 8 #(530) 8688 1778 #wordWrap: 8 #(true) 8688 1778 #margins: 34 1 34 3 8018 1 8688 1 3 0 0 5 0 8018 3 8688 1 0 0 67108863 5 0 8018 5 8688 1 0 0 0 5 0 8688 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1936 0 29 4498 8 'Dependents' 410 ##(Smalltalk.ReferenceView) 34 14 0 4528 34 2 8 1140850688 131073 10624 0 0 0 5 0 0 0 10624 2066 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 9 101 738 905 725 10624 1874 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 960 1936 0 27 4498 8 'Loose Methods' 410 ##(Smalltalk.ListView) 34 30 0 4528 34 2 8 1140920393 1 10880 4930 138 144 960 0 4992 610 4608 0 29 5666 0 true 34 10 5714 2097153 1042 #browseMethods 8 'Browse <1d>' 1 1 0 0 0 5714 1 1042 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 0 0 0 5714 1 1042 #browseMessageReferences 8 'All Re&ferences' 1 1 0 0 0 5714 1 1042 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 0 0 0 5714 1 1042 #browseLocalMessageReferences 8 '&Local References' 1 1 0 0 0 5778 4097 5714 1 1042 #removeLooseMethods 8 '&Remove from Package' 1 1 0 0 0 5666 0 true 34 7 5714 1 1042 #renameMethod 8 'Re&name' 1 1 0 0 0 5714 1 1042 #renameMethodReferences 8 'Rename Re&ferences' 1 1 0 0 0 5778 4097 5714 1 1042 #safeRemoveMethods 8 '&Remove' 1 1 0 0 0 5778 4097 5714 1 1042 #addParameterToMethod 8 'Add &Parameter...' 1 1 0 0 0 5666 0 true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 0 0 0 0 0 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 0 0 0 0 0 5778 4097 5666 0 true 34 1 5714 1 1042 #browseLooseMethodEditions 8 'Browse &Editions' 1 1 0 0 0 8 'C&hanges' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 10880 0 8 4294905883 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3744 0 0 0 738 65 65 0 0 138 144 34 3 920646 5 ##(Smalltalk.ListViewColumn) 8 'Selector' 401 #left 3570 #selector 8 #() 3618 0 0 5058 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] #selector 11920 7 513 0 0 0 10880 ##(Smalltalk.IconicListAbstract) 1 0 3618 0 0 5058 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4498 #ClassBrowserAbstract ##(Smalltalk.ClassBrowserAbstract) #looseMethodColor #forecolor: 12000 7 257 0 11842 8 'Class' 389 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3570 #methodClass 8 #() 0 10880 ##(Smalltalk.IconicListAbstract) 1 0 3618 0 0 5058 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | ctx forecolor: Color black]' 8 #[32 105 17 45 159 178 106] 4498 #Color ##(Smalltalk.Color) #black #forecolor: 12160 7 257 0 11842 8 'Package' 109 #left ##(Smalltalk.BasicListAbstract) 3618 0 0 5058 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 12288 7 513 0 3570 #owningPackage 8 #() 0 10880 0 3 0 0 #report 960 0 131173 0 8 #(nil) 1714 138 144 34 3 1778 #createAt:extent: 34 2 738 9 101 738 905 725 10880 1778 #contextMenu: 34 1 10992 10880 1778 #text: 34 1 8 'Selector' 10880 1874 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1936 0 27 4498 8 'Globals' 410 ##(Smalltalk.ListView) 34 30 0 4528 34 2 8 1140920393 1 12688 4930 138 144 960 0 4992 610 4608 0 29 5666 0 true 34 6 5714 1 1042 #addGlobal 8 '&Add Uncommitted...' 1 1 0 0 0 5714 1 1042 #removeGlobals 8 '&Remove from Package' 1 1 0 0 0 5778 4097 5714 2097153 1042 #inspectGlobals 8 '&Inspect' 1 1 0 0 0 5714 1 1042 #browseGlobalReferences 8 'All Re&ferences' 1 1 0 0 0 5714 1 1042 #browseLocalGlobalReferences 8 '&Local References' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 12688 0 8 4294905883 ##(Smalltalk.BasicListAbstract) 3618 0 0 5058 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 4498 #Smalltalk ##(Smalltalk) #icon #imageIndex 13120 7 257 0 3744 0 0 0 738 65 65 0 0 138 144 34 4 11842 8 '' 41 #left 3618 0 0 5058 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 13296 7 257 0 3618 0 0 5058 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 13408 7 513 0 3618 0 0 5058 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | [(Smalltalk at: x) isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 45 17 148 159 106 47 34 111 59 106 193 106] 13200 #isChanged 4498 #Error ##(Smalltalk.Error) #on:do: 13488 3618 0 0 13504 39 257 0 7 257 0 0 12688 3618 0 0 5058 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4498 #Package ##(Smalltalk.Package) #changedIcon #imageIndex 13600 7 257 0 1 0 0 11842 8 'Global' 301 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 0 0 12688 3618 0 0 5058 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | (Smalltalk at: x) icon imageIndex]' 8 #[32 105 45 17 148 159 160 106] 13200 #icon #imageIndex 13728 7 257 0 1 0 0 11842 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3618 0 0 5058 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 13840 7 513 0 3618 0 0 5058 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | Package manager packageOfGlobalNamed: x]' 8 #[32 105 45 159 17 178 106] 13680 #manager #packageOfGlobalNamed: 13920 7 257 0 0 12688 0 1 0 0 11842 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3618 0 0 5058 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | | glob |
glob := Smalltalk at: x.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[34 105 45 17 148 70 144 30 178 120 18 161 106 33 106] 4498 #Smalltalk ##(Smalltalk) #sourceObject #conformsToProtocol: #fileOutName 8 '' 14032 7 65793 0 0 12688 0 1 0 0 #report 960 0 133221 0 8 #(nil) 1714 138 144 34 2 1778 #createAt:extent: 34 2 738 9 101 738 905 725 12688 1778 #contextMenu: 34 1 12800 12688 1874 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1936 0 27 4498 8 'Classes' 410 ##(Smalltalk.ListView) 34 30 0 4528 34 2 8 1140920395 1 14384 4930 138 144 960 0 4992 610 4608 0 29 5666 0 true 34 8 5714 2097153 1042 #browseClass 8 '&Browse' 1 1 1090 0 true 1136 8 'ClassBrowserShell.ico' 1312 0 0 5714 1 1042 #browseClassReferences 8 'All Re&ferences' 1 1 0 0 0 5714 1 1042 #browseLocalClassReferences 8 'L&ocal References' 1 1 0 0 0 5778 4097 5714 1 1042 #addClass 8 '&Add Uncommitted..' 1 1 0 0 0 5714 1 1042 #removeClasses 8 '&Remove from Package' 1 1 0 0 0 5778 4097 5666 0 true 34 2 5714 1 1042 #browseClassEditions 8 'Browse Class &Editions' 1 1 0 0 0 5714 1 1042 #compareClass 8 'Compare Class Edition...' 1 1 0 0 0 8 'C&hanges' 0 134217729 0 0 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 14384 0 8 4294905883 3570 #name 8 #() ##(Smalltalk.IconicListAbstract) 3744 0 0 0 738 65 65 0 0 138 144 34 4 11842 8 '' 41 #left 3618 0 0 5058 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 13392 15120 7 257 0 3618 0 0 5058 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 15216 7 513 0 3570 #isChanged 8 #() 0 14384 3618 0 0 5058 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 13680 #changedIcon #imageIndex 15328 7 257 0 1 0 0 11842 8 'Name' 375 #left 3570 #name 8 #() ##(Smalltalk.SortedCollection) 0 0 14384 ##(Smalltalk.IconicListAbstract) 1 0 0 11842 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3618 0 0 5058 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 15504 7 513 0 3570 #owningPackage 8 #() 0 14384 0 1 0 0 11842 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) ##(Smalltalk.SortedCollection) 3618 0 0 5058 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] #fileOutName 15648 7 257 0 0 14384 0 1 0 0 #list 960 0 133221 0 8 #(nil) 1714 138 144 34 2 1778 #createAt:extent: 34 2 738 9 101 738 905 725 14384 1778 #contextMenu: 34 1 14496 14384 1874 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 8 #() 1936 0 27 4498 8 'Resources' 410 ##(Smalltalk.ReferenceView) 34 14 0 4528 34 2 8 1140850688 131073 15968 0 610 8 4278190080 0 5 5666 0 true 34 4 5714 2097153 1042 #editResource 8 '&Edit' 1 1 0 0 0 5714 1 1042 #showResource 8 '&Show' 1 1 0 0 0 5778 4097 5714 1 1042 #deleteResource 8 '&Delete' 1 1 0 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 15968 2066 ##(Smalltalk.ResourceListPresenter) #resource_Package_view 0 1714 138 144 34 2 1778 #createAt:extent: 34 2 738 9 101 738 905 725 15968 1778 #contextMenu: 34 1 16064 15968 1874 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 50 0 0 0 200 1 0 0 156 1 0 0] 960 1936 0 27 8688 170 192 34 16 10624 8 'dependents' 8432 8 'prerequisites' 15968 8 'resources' 8688 8 'comment' 14384 8 'classes' 4720 8 'scripts' 10880 8 'methods' 12688 8 'globals' 0 410 ##(Smalltalk.TabView) 34 23 0 4528 34 2 8 1140916736 1 16624 4930 138 144 34 8 8672 14368 10864 15952 12672 4704 8416 10608 0 4992 2034 31 0 1 0 0 0 16624 0 8 4294903993 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 3744 0 0 0 0 0 #noIcons 1714 138 144 34 3 1778 #createAt:extent: 34 2 738 1 1 738 921 833 16624 1778 #basicSelectionsByIndex: 34 1 8 #(1) 16624 1778 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 16624 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 8 #() 1936 0 27 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 1 1 738 921 833 4528 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 204 1 0 0 160 1 0 0] 34 9 8688 14384 10880 15968 12688 4720 8432 10624 16624 1936 0 27 5 false 170 192 34 2 4528 8 'ownedCards' 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 469 1 738 921 833 4384 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 34 1 4528 1936 0 27 5 false 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 0 4272 34 2 8 1140850688 131073 17408 0 0 0 7 0 0 0 17408 2066 ##(Smalltalk.PackageSelector) #resource_Default_view 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 1 1 738 459 833 17408 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 229 0 0 0 160 1 0 0] 960 1936 0 27 8 'packages' 0 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 1 1 738 1389 833 4272 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 182 2 0 0 160 1 0 0] 34 3 17408 410 ##(Smalltalk.Splitter) 34 12 0 4272 34 2 8 1140850688 1 17808 0 610 4608 0 519 0 0 0 17808 1714 138 144 34 1 1778 #createAt:extent: 34 2 738 459 1 738 11 833 17808 1874 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 229 0 0 0 0 0 0 0 234 0 0 0 160 1 0 0] 8 #() 1936 0 27 4384 1936 0 27 1936 0 27 170 192 34 4 3344 8 'statusbar' 544 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 true 34 10 5666 0 true 34 30 5714 1 1042 #newPackage 8 '&New Package...' 9373 5 0 0 0 5714 1 1042 #openPackage 8 '&Install Package...' 9375 5 0 0 0 5714 1 1042 #removePackage 8 '&Uninstall Package' 1 5 0 0 0 5778 4097 5666 0 true 34 2 5714 2097153 1042 #addClass 8 '&Class...' 1 1 0 0 0 5714 1 1042 #addGlobal 8 '&Global...' 1 1 0 0 0 8 'Add Unco&mmitted' 0 134217729 0 0 39835 0 0 5714 1 1042 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 0 0 0 5714 1 1042 #synchronizeFilter 8 '&Goto Folder' 1 1 0 0 0 5778 4097 5714 1 1042 #savePackages 8 '&Save Package' 1 1 1090 0 true 1136 8 'FileSave.ico' 1312 0 0 5714 1 1042 #savePackageChanges 8 'Save Package C&hanges' 1 1 0 0 0 5714 1 1042 #savePackageAs 8 'Save Package &As...' 1 1 0 0 0 5778 4097 5714 1 1042 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 0 0 0 5714 1 1042 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 0 0 0 5778 4097 5714 1 1042 #loadPackageFromRepository 8 'Load Edition...' 1 1 0 0 0 5714 1 1042 #importPackageFromFile 8 'Import to Repository...' 1 5 0 0 0 5714 1 1042 #versionPackage 8 'Version...' 1 1 0 0 0 5714 1 1042 #browsePackageEditions 8 'Browse Editions' 1 1 0 0 0 5714 1 1042 #compareWithAnotherEdition 8 'Compare with...' 1 1 0 0 0 5778 4097 5714 1 1042 #saveImage 8 'Sa&ve Image' 1 1 1090 0 true 1136 8 'Snapshot.ico' 1312 0 0 5714 1 1042 #smalltalkExit 8 'E&xit Dolphin' 1 1 1090 0 true 1136 8 'PowerSwitch.ico' 1312 0 0 5778 4097 5666 0 true 34 1 5714 2097153 1042 #browseTests 8 '&Browse' 1 1 0 0 0 8 '&Tests' 0 1 1090 0 true 1136 8 'TestRunner.ico' 0 0 39867 0 0 5666 0 true 34 4 5714 2097153 1042 #deploy 8 '&Deploy Executable...' 13445 1 0 0 0 5714 1 1042 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 0 0 0 5778 4097 5714 1 1042 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 0 0 0 8 '&Deployment' 0 134217729 1090 0 true 1136 8 'ApplicationDeploymentWizard.ico' 1312 0 39875 0 0 5778 4097 5714 1 1042 #inspectPackage 8 'P&roperties' 1 1 0 0 0 5778 4097 5714 1 1042 #exit 8 '&Close' 17639 1 1090 0 true 1136 8 'CloseWindow.ico' 1312 0 0 8 '&File' 0 134217729 0 0 39881 0 0 5666 0 true 34 12 5714 1 1042 #undo 8 '&Undo' 9397 1 1090 0 true 1136 8 'EditUndo.ico' 1312 0 0 5778 4097 5714 1 1042 #cutSelection 8 'Cu&t' 9393 1 1090 0 true 1136 8 'EditCut.ico' 1312 0 0 5714 1 1042 #copySelection 8 '&Copy' 9351 1 1090 0 true 1136 8 'EditCopy.ico' 1312 0 0 5714 1 1042 #pasteClipboard 8 '&Paste' 9389 1 1090 0 true 1136 8 'EditPaste.ico' 1312 0 0 5714 1 1042 #editDelete 8 '&Delete' 1 1 1090 0 true 1136 8 'EditClear.ico' 1312 0 0 5778 4097 5714 1 1042 #selectAll 8 'Select &All' 9347 1 0 0 0 5778 4097 5714 1 1042 #editFind 8 '&Find...' 9357 1 1090 0 true 1136 47 786694 ##(Smalltalk.ShellLibrary) 0 0 5714 1 1042 #findNext 8 'Find &Next' 1253 1 1090 0 true 1136 8 'FindNext.ico' 1312 0 0 5714 1 1042 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 39901 0 0 5666 0 true 34 13 5714 1 1042 #browseIt 8 '&Browse It' 9349 1 1090 0 true 1136 8 'ClassBrowserShell.ico' 1312 0 0 5714 1 1042 #displayIt 8 '&Display It' 9353 1 1090 0 true 1136 8 'DisplayIt.ico' 1312 0 0 5714 1 1042 #evaluateIt 8 '&Evaluate It' 9355 1 1090 0 true 1136 8 'EvaluateIt.ico' 1312 0 0 5714 1 1042 #inspectIt 8 '&Inspect It' 9363 1 1090 0 true 1136 8 'BasicInspector.ico' 1312 0 0 5714 1 1042 #debugIt 8 'Deb&ug It' 1269 1 1090 0 true 1136 8 'Debugger.ico' 1312 0 0 5714 1 1042 #fileItIn 8 '&File It In' 1 1 0 0 0 5778 4097 5714 1 1042 #browseDefinitions 8 'Defi&nitions...' 1271 1 0 0 0 5714 1 1042 #browseReferences 8 '&References...' 5367 1 0 0 0 5778 4097 5714 1 1042 #accept 8 '&Accept' 9383 1 0 0 0 5778 4097 5666 0 true 34 7 5714 1 1042 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 5714 1 1042 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 5714 1 1042 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 5714 1 1042 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 5714 1 1042 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 5714 1 1042 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 5714 1 1042 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 39935 0 0 8 '&Workspace' 0 134217729 0 0 39937 0 0 5666 0 true 34 4 5714 1 1042 #browseLocalMessageDefinitions 8 '&Definitions Of...' 1 1 0 0 0 5714 1 1042 #browseLocalMessageReferences 8 '&References To...' 1 1 0 0 0 5778 4097 5714 1 1042 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 0 0 0 8 '&Browse' 0 134217729 0 0 39945 0 0 5666 0 true 34 10 5714 1 1042 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 0 0 0 5714 2097153 1042 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 0 0 0 5778 4097 5714 1 1042 #checkOut 8 'Check Out &All' 1 1 0 0 0 5714 1 1042 #checkOutChanges 8 '&Check Out Changes' 9367 1 0 0 0 5714 1 1042 #checkIn 8 'Check &In' 9387 1 0 0 0 5778 4097 5714 1 1042 #savePackageChanges 8 'Save C&hanges' 1 1 1090 0 true 1136 8 'FileSave.ico' 1312 0 0 5778 4097 5714 1 1042 #resetChangeFlags 8 'Clear Change &Markers' 1 1 0 0 0 8 'Sou&rce Control' 0 134217729 0 0 39961 0 0 5666 0 true 34 10 5714 1 1042 #renameMethod 8 'Re&name Method...' 1 1 0 0 0 5714 1 1042 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 0 0 0 5778 4097 5714 1 1042 #safeRemoveMethod 8 'Re&move Method...' 1 1 0 0 0 5714 1 1042 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 0 0 0 5778 4097 5714 1 1042 #addParameter 8 'Add Method &Parameter...' 1 1 0 0 0 5714 1 1042 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 0 0 0 5778 4097 5714 1 1042 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 0 0 0 8 'Refactorin&gs' #refactoringsMenu 134217729 0 0 39977 0 0 5666 0 true 34 3 5714 1 1042 #undoChange 8 '&Undo <1d>' 1 1 1090 0 true 1136 8 'EditUndo.ico' 1312 0 0 5714 1 1042 #redoChange 8 '&Redo <1d>' 1 1 1090 0 true 1136 8 'EditRedo.ico' 1312 0 0 5714 1 1042 #clearChangeHistory 8 'Clear Change &History' 1 1 0 0 0 8 'H&istory' 0 134217729 0 0 39985 0 0 5666 0 true 8 #() 8 '&Tools' #toolsMenu 134217729 0 0 39987 0 0 5666 0 true 8 #() 8 'Wi&ndow' #windowMenu 134217729 0 0 39989 0 0 5666 0 true 34 15 5714 1 1042 #helpContents 8 '&Contents' 1025 1 1090 0 true 1136 49 20496 0 0 5714 1 1042 #help 8 'On this &Tool' 1249 1 0 0 0 5714 1 1042 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 5778 4097 5714 1 1042 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 5778 4097 5714 1 1042 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 5714 1 1042 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 5714 1 1042 #helpTutorials 8 'Tutorials' 1 1 0 0 0 5778 4097 5714 1 1042 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 5714 1 1042 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 5714 1 1042 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 5778 4097 5714 1 1042 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 1090 0 true 1136 8 '!!APPLICATION' 1312 0 0 8 '&Help' 0 134217729 0 0 40013 0 0 8 '' 0 134217729 0 0 0 0 0 0 0 0 1 0 0 0 738 771 621 1 0 0 1714 138 144 34 3 1778 #createAt:extent: 34 2 738 3839 21 738 1421 1041 416 1778 #text: 34 1 8 'Package Browser' 416 1778 #updateMenuBar 960 416 1874 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 69 10 0 0 18 2 0 0] 34 3 544 3984 3344 1936 0 27 )!

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

