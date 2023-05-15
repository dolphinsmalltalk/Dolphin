"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.PackageBrowserShell'
	instanceVariableNames: 'packagesPresenter classesPresenter methodsPresenter methodRefactoringTool variablesPresenter resourcesPresenter currentCard commentPresenter cardsPresenter updateFlags scriptTextPresenter scriptNamesPresenter prerequisitesPresenter dependentsPresenter statusModel'
	classVariableNames: 'WordWrapComment'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackageBrowserShell guid: (Core.GUID fromString: '{87b4c6c0-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.PackageBrowserShell comment: 'PackageBrowserShell is a <SmalltalkToolShell> that implements the Package Browser tool. This provides a user interface onto all the <Package>s held by the current <PackageManager>. 

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
!Tools.PackageBrowserShell categoriesForClass!MVP-Presenters! !
!Tools.PackageBrowserShell methodsFor!

acceptItCommand
	"Private - Answer the <Symbol> of the contextual command to save changes, depending on the subview with focus."

	currentCard == #comment ifTrue: [^#saveComment].
	currentCard == #scripts ifTrue: [^#saveScript].
	^nil!

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

	<commandQuery: #hasClassesSelected>
	| classes |
	classes := self selectedClasses.
	^classes size = 1
		ifTrue: [classes anyOne browse]
		ifFalse: [(self model browserEnvironment forClassesAndTheirMetaclasses: classes) browse]!

browseClassReferences
	"Browse all the methods in the entire system which refer to the class selected in the
	receiver."

	<commandQuery: #hasClassesSelected>
	self browseClassReferencesIn: self browserEnvironment!

browseClassReferencesIn: aBrowserEnvironment
	| class environments |
	class := self selectedClasses.
	environments := Array writeStream.
	class do: 
			[:each |
			environments
				nextPut: (aBrowserEnvironment referencesToVariable: each binding);
				nextPut: (aBrowserEnvironment referencesToClass: each)].
	self browseMethodsInEnvironments: environments contents!

browseDefinitionsCommand
	currentCard == #methods ifTrue: [^#browseMessageDefinitions].
	^nil!

browseHierarchyCommand
	^##(IdentityDictionary withAll: {
				#methods -> #browseHierarchyOfMethod.
				#classes -> #browseHierarchyOfClass.
				#variables -> #browseHierarchyOfVariable
			})
		lookup: currentCard!

browseHierarchyOfClass
	<commandQuery: #hasClassSelected>
	self developmentSystem browseHierarchy: self selectedClass!

browseHierarchyOfMethod
	<commandQuery: #hasMethodSelected>
	self developmentSystem browseClassHierarchyOfMethod: self selectedMethod!

browseHierarchyOfVariable
	<commandQuery: #hasLiveVariableSelected>
	| var |
	var := self sharedVariable binding.
	self developmentSystem
		browseHierarchy: (var isClassBinding ifTrue: [var value] ifFalse: [var environment])!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	| focus |
	focus := View focus.
	focus == packagesPresenter packagesPresenter view ifTrue: [^#browsePackages].
	focus == classesPresenter view ifTrue: [^#browseClass].
	focus == methodsPresenter view ifTrue: [^#browseMethods].
	focus == variablesPresenter view ifTrue: [^#browseVariableClass].
	^nil!

browseLocalClassReferences
	"Browse all the methods in the currently selected set of packages system which refer to the
	class selected in the receiver."

	self browseClassReferencesIn: self searchEnvironment!

browseLocalMessageDefinitions
	"Open a method browser displaying all implementors of the current selector in the currently
	selected packages."

	<commandQuery: #hasPackages>
	self browseMessageDefinitionsIn: self searchEnvironment!

browseLocalMessageReferences
	"Open a method browser displaying all references to the current selector in the currently
	selected packages."

	<commandQuery: #hasPackages>
	self browseMessageReferencesIn: self searchEnvironment!

browseLooseMethods: aCollection
	| env packageEnv |
	packageEnv := packagesPresenter selectionEnvironment.
	env := packageEnv forMethods: aCollection.
	env label: 'Loose methods from package(s): <1p>' << packageEnv.
	self model browseMethodsIn: env!

browseMessageDefinitions
	"Open a method browser displaying all implementors of the current selector in the system."

	<commandQuery: #hasMethodsSelected>
	self browseMessageDefinitionsIn: self browserEnvironment!

browseMessageDefinitionsIn: aBrowserEnvironment
	| methods |
	methods := self selectedMethods.
	methods isEmpty
		ifTrue: [self model browseMessageDefinitionsIn: aBrowserEnvironment]
		ifFalse: 
			[self browseMethodsInEnvironments: (methods
						collect: [:each | aBrowserEnvironment definitionsMatching: (MethodSearch newSelector: each selector)])]!

browseMessageReferences
	"Open a method browser displaying all references to the current selector in the entire system."

	<commandQuery: #hasMethodsSelected>
	self browseMessageReferencesIn: self browserEnvironment!

browseMessageReferencesIn: aBrowserEnvironment
	| methods |
	methods := self selectedMethods.
	methods isEmpty
		ifTrue: [self model browseMessageReferencesIn: aBrowserEnvironment]
		ifFalse: 
			[self browseMethodsInEnvironments: (methods
						collect: [:each | aBrowserEnvironment referencesToLiteral: each selector])]!

browseMethodClass
	"Open a default browser on the currently selected method."

	<commandQuery: #hasMethodSelected>
	^self selectedMethod browse!

browseMethods
	"Open a default browser on the currently selected method or methods."

	<commandQuery: #queryBrowseMethods:>
	| methods |
	methods := self selectedMethods.
	methods size == 1 ifTrue: [self browseMethodClass] ifFalse: [self browseLooseMethods: methods]!

browsePackages
	<commandQuery: #hasPackages>
	^packagesPresenter browsePackageSources!

browseReferencesCommand
	^##(IdentityDictionary withAll: {
				#methods -> #browseMessageReferences.
				#classes -> #browseClassReferences.
				#variables -> #browseVariableReferences
			})
		lookup: currentCard!

browseSystem
	"Open a system browser on the currently selected class or method,
	and with the same package selection."

	| pkgs method class browser |
	pkgs := self packages.
	pkgs isEmpty ifTrue: [^super browseSystem].
	browser := self developmentSystem browseSystemPackages: pkgs.
	browser isNil ifTrue: [^nil].
	(currentCard == #methods and: [(method := self selectedMethod) notNil]) 
		ifTrue: [browser selectMethod: method].
	(currentCard == #classes and: [(class := self selectedClass) notNil]) 
		ifTrue: [browser actualClass: class].
	^browser!

browseVariableClass
	"Open a default browser on the currently selected method."

	<commandQuery: #hasLiveVariableSelected>
	^self sharedVariable browse!

browseVariableReferences
	"Browse all the methods which refer to the shared variable selected in the receiver."

	<commandQuery: #hasVariableSelected>
	self model browseSharedVariableReferences: self sharedVariable in: self browserEnvironment!

buildPopupForCommand: aSymbol 
	"Private - Dynamically build an appropriate popup menu for aSymbol command."

	aSymbol == #viewModeSelect ifTrue: [^classesPresenter view buildViewsPopup].
	^super buildPopupForCommand: aSymbol!

cacheCurrentCard: aView
	currentCard := aView name asSymbol!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^true!

clearCard: aSymbol
	self perform: (self updateMap at: aSymbol) third!

clearClasses
	"Private - Clear the classes list."

	classesPresenter clear!

clearComment
	"Private - Clear down the comment presenter"

	commentPresenter clear!

clearDependents
	"Private - Clear the dependents tree."

	dependentsPresenter clear!

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

clearVariables
	"Private - Clear the Variables list."

	variablesPresenter clear!

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
	methodRefactoringTool := self developmentSystem newMethodRefactoringToolFor: self.
	variablesPresenter := (self
				add: ListPresenter new
				name: 'variables'
				helpId: 10814)
				beSorted: [:a :b | a displayString <= b displayString];
				yourself.
	variablesPresenter model searchPolicy: SearchPolicy equality.
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
				add: (workspaceClass new
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
	self model
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
		when: #variableRemoved:
			send: #onVariableRemoved:
			to: self;
		when: #variableRenamed:from:
			send: #onVariableRenamed:from:
			to: self.
	"Note that as we are using the ResourceListPresenter, which keeps in sync. by itself,
	 we don't need (or want) to hook any resource related events"
	self packageManager
		when: #classRepackaged:from:to:
			send: #onClassRepackaged:from:to:
			to: self;
		when: #methodRepackaged:from:to:
			send: #onMethodRepackaged:from:to:
			to: self;
		when: #variableRepackaged:from:to:
			send: #onVariableRepackaged:from:to:
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
			withArguments: #(nil #Class);
		when: #labelOf:editedTo:accept:
			send: #onClass:renameTo:accept:
			to: self.
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
			withArguments: #(nil #CompiledMethod).
	variablesPresenter
		when: #actionPerformed
			send: #inspectSharedVariables
			to: self;
		when: #drag:
			send: #onDragVariable:
			to: self;
		when: #drop:
			send: #onDropOverPackage:
			to: self;
		when: #dragEnter:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #VariableName);
		when: #dragOver:
			send: #onDragOver:type:
			to: self
			withArguments: #(nil #VariableName).
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

	self developmentSystem setCustomDrawAttributes: anNMLVCUSTOMDRAW forClass: anNMLVCUSTOMDRAW subItem!

defaultHelpId
	^10807!

hasClassesSelected
	^classesPresenter hasSelection!

hasClassSelected
	"Answer true if the receiver has a single (i.e. not multiple) class selected"

	^classesPresenter hasSingleSelection!

hasLiveVariableSelected
	| ref |
	ref := self sharedVariable.
	^ref notNil and: [ref isDefined]!

hasMethodSelected
	"Answer true if the receiver has a single (i.e. not multiple) method selected"

	^self selectedMethod notNil!

hasMethodsSelected
	^self selectedMethods notEmpty!

hasPackages
	"Private - Answer whether one or more packages are currently selected."

	^self packages notEmpty!

hasPackageSelected
	"Answer true if the receiver has a single (i.e. not multiple) package selected"

	^self singlePackage notNil!

hasResourcesSelected
	^self resourceIdentifiers notEmpty!

hasVariableSelected
	^self sharedVariable notNil!

hasVariablesSelected
	^self variableNames notEmpty!

initialize
	"Private - Initialize the state of the receiver"

	super initialize.
	updateFlags := 0.
	self caption: 'Package Browser'.
	statusModel := ValueHolder new!

inspectClasses
	"Open an inspector on the currently selected classes."

	<commandQuery: #hasClassesSelected>
	self inspectCollection: self selectedClasses!

inspectCollection: aCollection
	(aCollection size = 1 ifTrue: [aCollection first] ifFalse: [aCollection]) inspect!

inspectItCommand
	"Private - Answer the command that the context-sensitive 'Inspect-It' command would be linked
	to if sent to the receiver at this moment."

	| focus |
	focus := View focus.
	focus == packagesPresenter packagesPresenter view ifTrue: [^#inspectPackages].
	focus == classesPresenter view ifTrue: [^#inspectClasses].
	focus == methodsPresenter view ifTrue: [^#inspectMethods].
	focus == variablesPresenter view ifTrue: [^#inspectSharedVariables].
	focus == resourcesPresenter view ifTrue: [^#inspectResources].
	^nil!

inspectMethods
	"Open an inspector on the currently selected methods."

	<commandQuery: #hasMethodsSelected>
	self inspectCollection: self selectedMethods!

inspectResources
	"Open an inspector on the currently selected resources."

	self inspectCollection: self resourceIdentifiers!

inspectSharedVariables
	"Open an inspector on the currently selected variables."

	<commandQuery: #hasVariablesSelected>
	self inspectCollection: (self variableNames collect: [:each | each bindingOrNil])!

isCardUpToDate: aSymbol
	^updateFlags allMask: (self updateMap at: aSymbol) first!

markCardDirty: aSymbol
	| updateInfo |
	updateInfo := self updateMap at: aSymbol.
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

onCardChangedFrom: previousView to: currentView
	"Private - The source object card has been changed. Update the source pane
	accordingly."

	self cacheCurrentCard: currentView.
	(self isCardUpToDate: currentCard) ifFalse: [self updateCardNow: currentCard]!

onClassRemoved: aClass
	"Private - The <Behavior>, aClass, has been deleted. Update the receiver's
	cards as necessary to reflect the classes removal."

	currentCard == #classes
		ifTrue: [classesPresenter model remove: aClass ifAbsent: nil]
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

onDragMethods: aDragDropSession 
	"Private - A drag has been started. Drag the currently selected methods."

	self developmentSystem beginDrag: aDragDropSession methods: self selectedMethods!

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

onDragVariable: aDragDropSession
	"Private - A Global drag has been started. Populate the <DragDropSession>, 
	session with the objects to be dragged."

	aDragDropSession dragObjects: nil.
	variablesPresenter selections do: 
			[:each |
			aDragDropSession addDragObject: ((aDragDropSession newDragObject: each)
						format: #VariableName data: each;
						yourself)].
	aDragDropSession defaultOperation: #copy!

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
					(each isFormatAvailable: #VariableName)
						ifTrue: 
							[| bindingRef |
							bindingRef := each format: #VariableName.
							packageManager addVariableNamed: bindingRef asQualifiedReference to: targetPackage].
					(each isFormatAvailable: #Class)
						ifTrue: 
							[| class |
							class := each format: #Class.
							packageManager addClass: class to: targetPackage]]].

	"Operation must never be #move to avoid methods being removed"
	aDragDropSession operation: #copy.
	^true!

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
			methodsPresenter model remove: aCompiledMethod ifAbsent: nil]
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

onVariableRemoved: aVariableBinding
	"Private - The shared variable with the specified binding has been removed from the system.
	The variables pane must be kept up to date."

	currentCard == #variables
		ifTrue: [variablesPresenter model remove: aVariableBinding fullyQualifiedReference ifAbsent: nil]
		ifFalse: [self markCardDirty: #variables]!

onVariableRenamed: aVariableBinding from: aBindingReference
	"Private - The shared variable with the specified binding has been renamed, the <Symbol>
	argument being its original name. The variables pane must be kept up to date."

	currentCard == #variables
		ifTrue: 
			[(variablesPresenter model remove: aBindingReference ifAbsent: nil) notNil
				ifTrue: [variablesPresenter model add: aVariableBinding fullyQualifiedReference]]
		ifFalse: [self markCardDirty: #variables]!

onVariableRepackaged: aBindingReference from: oldPackage to: newPackage
	self
		objectRepackaged: aBindingReference
		from: oldPackage
		to: newPackage
		card: #variables
		list: variablesPresenter model!

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
	(self view viewNamed: 'errors' ifNone: nil)
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
		when: #currentCardChangedFrom:to:
		send: #onCardChangedFrom:to:
		to: self.	";
		when: #currentCardChanging: send: #onSelectionChanging: to: self"

	"Make sure the classes tab is visble"
	commentPresenter ensureVisible.
	self packageManager youShouldBeProcessingEvents!

openWorkspace
	"Create a new workspace window on a file"

	| workspaceClass |
	workspaceClass := self developmentSystem workspaceShellClass.
	^(FileOpenDialog new
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

queryBrowseMethods: aCommandQuery
	| methods |
	methods := self selectedMethods.
	aCommandQuery isEnabled: methods notEmpty.
	aCommandQuery text: (aCommandQuery description
				expandMacrosWithArguments: { methods size = 1 ifTrue: [methods first] ifFalse: ['&Methods'] }
				locale: Locale smalltalk)!

querySaveComment: aCommandQuery
	(packagesPresenter hasSinglePackage and: [commentPresenter isModified])
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isDefault: true]
		ifFalse: [aCommandQuery isEnabled: false]!

querySaveScript: aCommandQuery
	(packagesPresenter hasSinglePackage and: [scriptTextPresenter isModified])
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isDefault: true]
		ifFalse: [aCommandQuery isEnabled: false]!

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
	Smalltalk removeEventsTriggeredFor: self!

removeClasses
	"Private - Remove the currently selected classes from the package."

	<commandQuery: #hasClassesSelected>
	self selectedClasses do: [:e | e owningPackage removeClass: e]!

removeLooseMethods
	"Private - Remove the currently selected method(s) from their packages.
	Note that the methods are not actually removed from the system (i.e.
	ownership is transferred to the package of their method class)."

	<commandQuery: #hasMethodsSelected>
	self selectedMethods do: [:each | each owningPackage removeMethod: each]!

removeVariables
	"Private - Remove the currently selected variables from their packages."

	<commandQuery: #hasVariablesSelected>
	self variableNames do: [:each | Package manager addVariableNamed: each to: nil]!

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

	<commandQuery: #querySaveComment:>
	self singlePackage comment: commentPresenter plainText.
	commentPresenter isModified: false!

saveScript
	"Private - Save the script from the source text."

	<commandQuery: #querySaveScript:>
	self singlePackage scriptAt: self scriptName put: self scriptText.
	self updateScriptNames!

scriptName
	"Answer the currently selected script name."

	^(scriptNamesPresenter selectionIfNone: nil) ifNotNil: [:script | script key]!

scriptText
	"Private - Answer the text for the currently selected script as a String"

	^scriptTextPresenter plainText!

scriptText: text 
	"Private - Set the text of the receiver's scriptPresenter to the argument,
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

	^(self isCardUpToDate: #methods) ifTrue: [methodsPresenter selections] ifFalse: [#()]!

selectionEnvironment
	^packagesPresenter selectionEnvironment!

setInitialFocus
	packagesPresenter view tabFirst!

sharedVariable
	| bindingRefs |
	bindingRefs := self variableNames.
	^bindingRefs size = 1 ifTrue: [bindingRefs first]!

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

	self packages: {aPackage}!

source
	"Private - Answer the source for the currently selected method as a String"

	^scriptTextPresenter plainText!

statusModel
	^statusModel!

statusText: aString
	statusModel value: (aString isNil ifFalse: [Notification messageText: aString])!

updateCaption
	"Refresh the caption to reflect the currently selected packages in the receiver, if any."

	| pkgs count text |
	pkgs := self packages.
	count := pkgs size.
	text := String smalltalkWriteStream: 64.
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
	updateInfo := self updateMap at: aSymbol.
	self perform: updateInfo second.
	updateFlags := updateFlags maskSet: updateInfo first!

updateCards
	"Private - Update the source object cards for the currently selected package(s).
	Implementation Note: It takes quite a bit of effort to update some of the cards, so we only 
	truly update the one which is actually displayed. We do this by clearing all models,
	except for the current card (to avoid flicker), and reset the update flags so that
	panes get refreshed on demand as they are displayed. Then we refresh the current card."

	self updateMap
		keysDo: [:each | (each ~~ currentCard and: [self isCardUpToDate: each]) ifTrue: [self clearCard: each]].
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

	currentCard isNil ifTrue: [self cacheCurrentCard: cardsPresenter currentCard].
	self
		updateCards;
		updateCaption;
		updateStatus!

updateDependents
	dependentsPresenter packages: self packages!

updateMap
	^##(IdentityDictionary new
		at: #classes put: #(1 #updateClasses #clearClasses);
		at: #methods put: #(2 #updateMethods #clearMethods);
		at: #variables put: #(4 #updateVariables #clearVariables);
		at: #scripts put: #(8 #updateScriptNames #clearScriptNames);
		at: #resources put: #(16 #updateResources #clearResources);
		at: #prerequisites put: #(32 #updatePrerequisites #clearPrerequisites);
		at: #comment put: #(64 #updateComment #clearComment);
		at: #dependents put: #(128 #updateDependents #clearDependents);
		shrink;
		beImmutableObject;
		yourself)!

updateMethods
	"Private - Update the methods list for the selected package."

	| methods |
	methods := OrderedCollection new.
	self packages do: [:each | methods addAll: each methods].
	methodsPresenter list: methods!

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

updateVariables
	"Private - Update the Shared Variables list for this package."

	| bindingRefs |
	bindingRefs := OrderedCollection new.
	self packages do: [:each | bindingRefs addAll: each variableNames].
	variablesPresenter list: bindingRefs!

upgradeResources
	"Private - Uprade & resave the selected resources, by loading them into a ViewComposer."

	<commandQuery: #hasResourcesSelected>
	self resourceIdentifiers do: [:each | each reassign]!

variableNames
	^variablesPresenter selections! !
!Tools.PackageBrowserShell categoriesForMethods!
acceptItCommand!commands-mappings!private! !
addToCommandRoute:!commands-routing!public! !
applyOptions!operations!options!private! !
browseClass!commands-actions!public! !
browseClassReferences!commands-actions!public! !
browseClassReferencesIn:!helpers!private! !
browseDefinitionsCommand!commands-mappings!private! !
browseHierarchyCommand!commands-mappings!private! !
browseHierarchyOfClass!commands-actions!private! !
browseHierarchyOfMethod!commands-actions!private! !
browseHierarchyOfVariable!commands-actions!private! !
browseItCommand!helpers!private! !
browseLocalClassReferences!commands-actions!public! !
browseLocalMessageDefinitions!commands-actions!public! !
browseLocalMessageReferences!commands-actions!public! !
browseLooseMethods:!helpers!private! !
browseMessageDefinitions!commands-actions!public! !
browseMessageDefinitionsIn:!helpers!private! !
browseMessageReferences!commands-actions!public! !
browseMessageReferencesIn:!helpers!private! !
browseMethodClass!commands-actions!public! !
browseMethods!commands-actions!public! !
browsePackages!commands-actions!public! !
browseReferencesCommand!commands-mappings!private! !
browseSystem!commands-actions!public! !
browseVariableClass!commands-actions!public! !
browseVariableReferences!commands-actions!public! !
buildPopupForCommand:!event handling!private! !
cacheCurrentCard:!event handling!private! !
canSaveState!private!saved state! !
clearCard:!private!updating! !
clearClasses!private!updating! !
clearComment!private!updating! !
clearDependents!private!updating! !
clearMethods!private!updating! !
clearPrerequisites!private!updating! !
clearResources!private!updating! !
clearScriptNames!private!updating! !
clearVariables!private!updating! !
createComponents!commands-actions!private! !
createSchematicWiring!commands-actions!private! !
customDrawClassList:!private! !
defaultHelpId!public! !
hasClassesSelected!private!testing! !
hasClassSelected!public!testing! !
hasLiveVariableSelected!private!testing! !
hasMethodSelected!public!testing! !
hasMethodsSelected!public!testing! !
hasPackages!private!testing! !
hasPackageSelected!public!testing! !
hasResourcesSelected!private!testing! !
hasVariableSelected!private!testing! !
hasVariablesSelected!private!testing! !
initialize!initializing!private! !
inspectClasses!commands-actions!public! !
inspectCollection:!helpers!private! !
inspectItCommand!helpers!private! !
inspectMethods!commands-actions!public! !
inspectResources!commands-actions!public! !
inspectSharedVariables!commands-actions!public! !
isCardUpToDate:!private!testing! !
markCardDirty:!helpers!private! !
objectRepackaged:from:to:card:list:!event handling!private! !
onCardChangedFrom:to:!event handling!private! !
onClassRemoved:!event handling!private! !
onClassRepackaged:from:to:!event handling!private! !
onCloseRequested:!event handling!private! !
onDragClasses:!event handling!private! !
onDragMethods:!event handling!private! !
onDragOver:type:!event handling!private! !
onDragResource:!event handling!private! !
onDragVariable:!event handling!private! !
onDropOverPackage:!event handling!private! !
onMethodAdded:!event handling!private! !
onMethodRemoved:!event handling!private! !
onMethodRepackaged:from:to:!event handling!private! !
onMethodUpdated:!event handling!private! !
onPackageChanged:!event handling!private! !
onPackageSelected!event handling!private! !
onPackageSelectionChanging:!private! !
onScriptSelected!event handling!private! !
onVariableRemoved:!event handling!private! !
onVariableRenamed:from:!event handling!private! !
onVariableRepackaged:from:to:!event handling!private! !
onViewClosed!event handling!private! !
onViewOpened!event handling!private! !
openWorkspace!commands-actions!public! !
packages!accessing!public! !
packages:!accessing!public! !
promptToSaveChanges!helpers!private! !
promptToSaveChanges:!helpers!private! !
queryBrowseMethods:!commands-queries!private! !
querySaveComment:!commands-queries!private! !
querySaveScript:!commands-queries!private! !
refreshCard:!helpers!private! !
release!dependency!public! !
removeClasses!commands-actions!private! !
removeLooseMethods!commands-actions!private! !
removeVariables!commands-actions!private! !
resourceIdentifier!accessing!private! !
resourceIdentifiers!accessing!private! !
saveComment!commands-actions!private! !
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
sharedVariable!accessing!public! !
shortCaption!accessing!public! !
showPrerequisitesFor:!helpers!private! !
singlePackage!accessing!public! !
singlePackage:!accessing!public! !
source!accessing!private! !
statusModel!accessing!public! !
statusText:!accessing!private! !
updateCaption!public!updating! !
updateCardNow:!private!updating! !
updateCards!private!updating! !
updateClasses!private!updating! !
updateComment!private!updating! !
updateContents!private!updating! !
updateDependents!private!updating! !
updateMap!private!updating! !
updateMethods!private!updating! !
updatePrerequisites!private!updating! !
updateResources!private!updating! !
updateScriptNames!private!updating! !
updateStatus!private!updating! !
updateVariables!private!updating! !
upgradeResources!commands-actions!public! !
variableNames!accessing!public! !
!

!Tools.PackageBrowserShell class methodsFor!

defaultOptionFlags
	^##(CanUseIdeaSpaceMask | ReuseIfOpenMask)!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'Package Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Register the receiver with SmalltalkSystem.

		self initialize.
	"

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	WordWrapComment := true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	(aspects at: #reuseIfOpen) defaultValue: true.
	aspects add: self canUseIdeaSpaceAspect.
	aspects add: ((Aspect boolean: #wordWrapComment)
				defaultValue: true;
				yourself).
	^aspects!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 #{Graphics.ThemeColor} #toolBackground nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 410 #{UI.Toolbar} 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 #{Graphics.Color} #default 8 1793710320 170 192 34 10 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1140853580 131073 672 nil nil nil 519 nil nil nil 672 608 8 1793710320 170 192 8 #() nil nil nil 170 192 34 8 59555 1311814 1 #{UI.ToolbarIconButton} 672 1 1377606 4 #{UI.CommandDescription} #savePackageChanges 8 'Save Package Changes' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'FileSave.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil 59555 59553 818 672 1 850 #openPackage 8 'Install Package' 1 1 898 nil true 930 8 'FileOpen.ico' 992 65541 nil 59553 59551 818 672 1 850 #newPackage 8 'New Package' 1 1 898 nil true 930 8 'NewPackage.ico' 992 65541 nil 59551 59557 818 672 1 850 #browsePackageSources 8 'Open Source Browser' 1 1 898 nil true 930 8 'SourceBrowser.ico' 992 65541 nil 59557 34 5 1120 1024 832 1216 1245766 1 #{UI.ToolbarSeparator} 672 1 nil nil 1 nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1051 1 1458 201 51 672 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 113 2 0 0 25 0 0 0] 8 #() 1458 193 193 nil 29 8 'fileTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1600 nil nil nil 7 nil nil nil 1600 1376838 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_Smalltalk_tools nil 1362 34 1 1410 #createAt:extent: 34 2 1458 63 1 1458 553 51 1600 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 768 1568 nil 27 8 'smalltalkTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 1840 nil nil nil 7 nil nil nil 1840 1666 #{UI.Toolbar} #resource_Image_tools nil 1362 34 1 1410 #createAt:extent: 34 2 1458 1 1 1458 63 51 1840 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 768 1568 nil 27 8 'imageTools' 410 #{UI.Toolbar} 34 28 nil 528 34 2 8 1140853612 131137 2064 nil nil nil 519 nil nil nil 2064 608 8 1793710320 170 192 768 nil nil nil 170 192 34 2 59559 818 2064 273 850 #viewModeSelect 8 'Views' 1 1 898 nil true 930 8 'ViewMode.ico' 992 65541 nil 59559 34 1 2192 nil nil 1 nil nil nil nil nil 1362 34 1 1410 #createAt:extent: 34 2 1458 1251 1 1458 65 51 2064 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 113 2 0 0 0 0 0 0 145 2 0 0 25 0 0 0] 8 #() 1568 nil 29 8 'viewTools' 410 #{UI.ReferenceView} 34 14 nil 528 34 2 8 1140850688 131073 2464 nil nil nil 7 nil nil nil 2464 1666 #{UI.Toolbar} #resource_Search_tools nil 1362 34 1 1410 #createAt:extent: 34 2 1458 615 1 1458 437 51 2464 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 768 1568 nil 27 8 'searchTools' nil nil nil 170 192 768 8 #() nil nil 1 nil 1458 33 33 nil nil 852806 1 #{UI.FlowLayout} 1 1 1 1362 34 1 1410 #createAt:extent: 34 2 1458 1 1 1458 1479 51 528 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 227 2 0 0 25 0 0 0] 34 5 1840 1600 2464 672 2064 1568 nil 29 410 #{UI.StatusBar} 34 21 nil 416 34 2 8 1140850956 1 2912 nil 608 nil 7 nil 852998 #{Graphics.Font} nil true 655622 #{OS.LOGFONT} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 1458 193 193 nil 2912 nil 8 1793263632 170 192 34 2 1050438 1 #{UI.StatusBarItem} 8193 -1 2912 nil 786950 #{Core.Message} #displayString 8 #() 3154 #iconImageIndex 3184 nil 8 'errors' nil nil nil 34 1 3136 1311814 1 #{UI.StatusBarNullItem} 8705 1 2912 nil nil 1362 34 1 1410 #createAt:extent: 34 2 1458 1 883 1458 1479 41 2912 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 227 2 0 0 205 1 0 0] 8 #() 1568 nil 29 nil nil 410 #{UI.ContainerView} 34 15 nil 416 34 2 8 1140850688 131073 3424 nil nil nil 7 nil nil nil 3424 1376774 #{UI.ProportionalLayout} 170 176 768 true 170 192 768 nil 1362 34 1 1410 #createAt:extent: 34 2 1458 1 51 1458 1479 833 3424 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 227 2 0 0 185 1 0 0] 34 1 410 #{UI.ContainerView} 34 15 nil 3424 34 2 8 1140850688 131073 3696 nil nil nil 7 nil nil nil 3696 3490 170 176 34 2 410 #{UI.ContainerView} 34 15 nil 3696 34 2 8 1140850688 131073 3808 nil nil nil 7 nil nil nil 3808 3490 138 #{Core.Dictionary} 34 1 1049094 #{Core.Association} 410 #{UI.CardContainer} 34 16 nil 3808 34 2 8 1140850688 131073 3952 nil nil nil 7 nil nil nil 3952 853318 1 #{UI.CardLayout} 138 144 34 8 3922 787270 1 #{UI.CardLabel} 8 'Classes' 1410 #icon 8 #() #{Core.Behavior} nil 410 #{UI.ListView} 34 45 nil 3952 34 2 8 1140920395 1 4176 787270 2 #{UI.ListModel} 138 144 768 nil 1769478 #{Kernel.IdentitySearchPolicy} 608 nil 29 461638 4 #{UI.Menu} nil true 34 8 1180742 2 #{UI.CommandMenuItem} 2097153 850 #browseClass 8 '&Browse' 1 1 898 nil true 930 8 'ClassBrowserShell.ico' 992 65541 nil nil nil 4370 1 850 #browseClassReferences 8 'All Re&ferences' 1 1 nil nil nil 4370 1 850 #browseLocalClassReferences 8 'L&ocal References' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 4370 1 850 #addClass 8 '&Add Uncommitted..' 1 1 nil nil nil 4370 1 850 #removeClasses 8 'Re&move from Package' 1 1 nil nil nil 4578 4097 4322 nil true 34 4 4370 2097153 850 #renameClass 8 'Re&name…' 1 1 nil nil nil 4370 1 850 #changeClassNamespace 8 'C&hange Namespace…' 1 1 nil nil nil 4578 4097 4370 1 850 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 8 '&Refactorings' #classRefactoringsMenu 134217729 898 nil true 930 8 'Refactoring.ico' 992 65541 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4176 nil 8 1793684656 3154 #fullName 8 #() 3200 1639750 1 #{Graphics.IconImageManager} nil nil 1246566 3 #{Kernel.BlockClosure} 0 nil 1639718 #{Kernel.CompiledExpression} 4 1 5072 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 5088 7 257 nil 1458 65 65 nil nil 138 144 34 5 1117254 5 #{UI.ListViewColumn} 8 '' 41 #left 5074 0 nil 5106 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 5280 7 257 nil 5074 0 nil 5106 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 5392 7 513 nil 3154 #isChanged 8 #() nil 4176 5074 0 nil 5106 5 1 5072 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]] ' 8 #[32 105 17 121 45 159 160 106 60 106] 1442886 2 #{Kernel.VariableBinding} #Package #{Kernel.Package} #{Kernel} 1 #changedIcon #imageIndex 5504 #ifTrue: 7 257 nil 1 nil nil 5234 8 'Namespace' 301 #left 3154 #displayString 8 #() 5074 0 nil 5106 2 1 5072 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 226 0 226 32 130 106] #displayString 5680 7 513 nil 3154 #environment 8 #() nil 4176 3200 1 nil nil 5234 8 'Name' 375 #left 3154 #unqualifiedName 5024 3154 #<= 8 #() nil nil 4176 3200 1 nil 5074 0 nil 5106 4 1 5072 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 5872 7 257 nil 5234 #Package 201 #left 3168 5074 0 nil 5106 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5968 7 513 nil 3154 #owningPackage 8 #() nil 4176 nil 1 nil nil 5234 8 'File Out Name' 2001 #left 3168 3154 #<= 8 #() 3154 #fileOutName 8 #() nil 4176 nil 1 nil nil #list 8 #() nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1362 34 2 1410 #createAt:extent: 34 2 1458 9 97 1458 965 729 4176 1410 #contextMenu: 34 1 4336 4176 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 8 #() 1568 nil 35 3922 4098 8 'Methods' 1410 #icon 4160 #{Kernel.CompiledMethod} nil 410 #{UI.ListView} 34 45 nil 3952 34 2 8 1140920393 1 6432 4242 138 144 768 nil 4304 608 nil 29 4322 nil true 34 8 4370 2097153 850 #browseMethods 8 'Browse <1d>' 1 1 nil nil nil 4370 1 850 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 nil nil nil 4370 1 850 #browseMessageReferences 8 'All Re&ferences' 1 1 nil nil nil 4370 1 850 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 nil nil nil 4370 1 850 #browseLocalMessageReferences 8 '&Local References' 1 1 nil nil nil 4578 4097 4370 1 850 #removeLooseMethods 8 '&Remove from Package' 1 1 nil nil nil 4322 nil true 34 7 4370 1 850 #renameMethod 8 'Re&name' 1 1 nil nil nil 4370 1 850 #renameMethodReferences 8 'Rename Re&ferences' 1 1 nil nil nil 4578 4097 4370 1 850 #removeMethods 8 '&Remove' 1 1 nil nil nil 4578 4097 4370 1 850 #addParameterToMethod 8 'Add &Parameter…' 1 1 nil nil nil 4322 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 6432 nil 8 1793684656 3168 3200 5056 nil nil nil 1458 65 65 nil nil 138 144 34 4 5234 8 'Selector' 401 #left 3154 #selector 8 #() 5074 0 nil 5106 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] #selector 7328 7 513 nil nil nil 6432 3200 1 nil 5074 0 nil 5106 3 1 5072 8 'doIt' 8 '[:ctx | 
ctx forecolor: Tools.ClassBrowserAbstract.LooseMethodColor]' 8 #[31 105 17 45 177 106] 5586 8 'LooseMethodColor' 594 #purple #{Tools.ClassBrowserAbstract} 5 #forecolor: 7408 7 257 nil 5234 8 'Class' 389 #left 3154 #name 8 #() 3154 #<= 8 #() 3154 #methodClass 8 #() nil 6432 3200 1 nil 5074 0 nil 5106 4 1 5072 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 7664 7 257 nil 5234 8 'Namespace' 301 #left 3154 #printString 8 #() 5074 0 nil 5106 4 1 3152 8 'doIt' 8 '[:a :b | a isNil or: [
	b notNil and: [a printString <= b printString]]]' 8 #[32 105 17 223 2 58 106 18 222 6 226 2 226 34 130 106 59 106] #or: #and: #printString 7808 7 513 nil 3154 #environment 8 #() nil 6432 3200 1 nil nil 5234 #Package 149 #left 3168 5074 0 nil 5106 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 7936 7 513 nil 3154 #owningPackage 8 #() nil 6432 nil 3 nil nil #report 6176 nil 131173 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1362 34 3 1410 #createAt:extent: 34 2 1458 9 97 1458 965 729 6432 1410 #contextMenu: 34 1 6528 6432 1410 #text: 34 1 8 'Selector' 6432 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 8 #() 1568 nil 35 3922 4098 8 'Resources' 1410 #icon 4160 1664 nil 410 #{UI.ReferenceView} 34 14 nil 3952 34 2 8 1140850688 131073 8336 nil nil nil 5 4322 nil true 34 4 4370 2097153 850 #editResource 8 '&Edit' 1 1 898 nil true 930 8 'ViewComposer.ico' 992 65541 nil nil nil 4370 1 850 #showResource 8 '&Show' 1 1 898 nil true 930 8 'TestView.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #deleteResource 8 '&Delete' 1 1 898 nil true 930 8 'EditClear.ico' 992 65541 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 8336 1666 #{Tools.ResourceListPresenter} #resource_Package_view nil 1362 34 2 1410 #createAt:extent: 34 2 1458 9 97 1458 965 729 8336 1410 #contextMenu: 34 1 8400 8336 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 768 1568 nil 27 3922 4098 8 'Scripts' nil nil 410 #{UI.ContainerView} 34 15 nil 3952 34 2 8 1140850688 131073 8976 nil nil nil 5 nil nil nil 8976 1048838 #{UI.FramingLayout} 170 176 34 4 410 #{UI.TabViewXP} 34 28 nil 8976 34 2 8 1140916866 1 9104 4242 138 144 768 nil 4304 608 nil 5 nil nil nil 9104 nil 8 1793497968 3154 #key 8 #() 5074 0 nil 5106 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] #icon #imageIndex 9248 7 257 nil 5056 nil nil nil nil nil #smallIcons nil nil nil nil nil 1362 34 2 1410 #createAt:extent: 34 2 1458 1 1 1458 965 729 9104 1410 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9104 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 226 1 0 0 108 1 0 0] 8 #() 1568 nil 27 1378374 2 #{UI.FramingConstraints} 1377286 #{UI.FramingCalculation} #fixedParentLeft 1 9538 #fixedParentRight 1 9538 #fixedParentTop 1 9538 #fixedParentBottom 1 410 #{UI.Scintilla.ScintillaView} 34 52 nil 8976 34 2 8 1176572228 1025 9616 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 608 nil 21 4322 nil true 34 13 4370 1 850 #accept 8 '&Accept' 1 1 nil nil nil 4578 4097 4322 nil true 34 11 4370 1 850 #undo 8 '&Undo' 1 1 898 nil true 930 8 'EditUndo.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #cutSelection 8 'Cu&t' 1 1 898 nil true 930 8 'EditCut.ico' 992 65541 nil nil nil 4370 1 850 #copySelection 8 '&Copy' 1 1 898 nil true 930 8 'EditCopy.ico' 992 65541 nil nil nil 4370 1 850 #pasteClipboard 8 '&Paste' 1 1 898 nil true 930 8 'EditPaste.ico' 992 65541 nil nil nil 4370 1 850 #clearSelection 8 'De&lete' 1 1 898 nil true 930 8 'EditClear.ico' 992 65541 nil nil nil 4370 1 850 #clear 8 'Clea&r' 1 1 898 nil true 930 8 'ClearDocument.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #reformatSource 8 'Re&format' 1 1 nil nil nil 4578 4097 4370 1 850 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4322 nil true 34 10 4370 1 850 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4370 1 850 #cloneNew 8 '&Clone' 1 1 898 nil true 930 8 'SmalltalkWorkspace.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4370 1 850 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4370 1 850 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4370 1 850 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4370 1 850 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4370 1 850 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4370 1 850 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 4578 4097 4370 1 850 #browseIt 8 'Bro&wse It' 1 1 898 nil true 930 8 'ClassBrowserShell.ico' 992 65541 nil nil nil 4370 1 850 #displayIt 8 '&Display It' 1 1 898 nil true 930 8 'DisplayIt.ico' 992 65541 nil nil nil 4370 1 850 #printIt 8 '&Print It' 1 1 898 nil true 930 8 'PrintIt.ico' 992 65541 nil nil nil 4370 1 850 #evaluateIt 8 'E&valuate It' 1 1 898 nil true 930 8 'EvaluateIt.ico' 992 65541 nil nil nil 4370 1 850 #inspectIt 8 '&Inspect It' 1 1 898 nil true 930 8 'BasicInspector.ico' 992 65541 nil nil nil 4370 1 850 #debugIt 8 'Deb&ug It' 1 1 898 nil true 930 8 'Debugger.ico' 992 65541 nil nil nil 4578 4097 4322 nil true 34 3 4370 2097153 850 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 4370 1 850 #browseReferences 8 '&References…' 1 1 nil nil nil 4370 1 850 #browseMessages 8 '&Messages…' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 9616 nil 8 1389372803 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 4 #callTip 1444934 1 #{UI.Scintilla.TextStyle} 77 594 #gray 594 #white 1 nil nil nil nil #callTip nil nil nil #normal 12098 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 2032902 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 138 144 768 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 9616 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 768 nil 170 176 768 9215 nil nil 170 176 34 2 81 594 #windowText nil nil 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 12064 nil nil nil nil 16 nil 170 192 34 4 #Warning 1772614 4 #{UI.Scintilla.IndicatorStyle} 17 9616 594 #blue 3 3 #Warning nil nil nil nil nil nil #Error 12562 19 9616 594 #red 3 3 #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 12098 1027 594 #darkGoldenrod 594 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 12098 1031 594 #firebrick 594 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 12098 1029 nil 594 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil nil nil 1362 34 9 1410 #createAt:extent: 34 2 1458 21 21 1458 853 689 9616 1410 #contextMenu: 34 1 9744 9616 1410 #wordWrap: 8 #(true) 9616 1410 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 9616 1 3 nil nil 5 nil 13010 3 9616 1 nil nil 67108863 5 nil 13010 5 9616 1 nil nil nil 5 nil 9616 1410 #canHScroll: 8 #(false) 9616 1410 #maxCompletionListHeight: 8 #(9) 9616 1410 #sciSetTechnology: 8 #(1) 9616 1410 #sciSetFontQuality: 8 #(3) 9616 1410 #sciSetSelectionLayer: 8 #(1) 9616 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 180 1 0 0 98 1 0 0] 8 #() 1568 nil 35 9506 9552 21 9568 -91 9584 21 9600 -19 170 192 34 4 9104 8 'scriptNames' 9616 8 'scriptText' nil 1362 34 1 1410 #createAt:extent: 34 2 1458 9 97 1458 965 729 8976 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 34 2 9616 9104 1568 nil 27 3922 4098 8 'Prerequisites' nil nil 410 #{UI.ReferenceView} 34 14 nil 3952 34 2 8 1140850688 131073 13552 nil nil nil 5 nil nil nil 13552 1666 #{Tools.PackageDependencyPresenter} #resource_Default_view nil 1362 34 1 1410 #createAt:extent: 34 2 1458 9 97 1458 965 729 13552 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 768 1568 nil 27 3922 4098 8 'Dependents' nil nil 410 #{UI.ReferenceView} 34 14 nil 3952 34 2 8 1140850688 131073 13808 nil nil nil 5 nil nil nil 13808 1666 #{Tools.PackageDependencyPresenter} #resource_Default_view nil 1362 34 1 1410 #createAt:extent: 34 2 1458 9 97 1458 965 729 13808 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 768 1568 nil 27 3922 4098 8 'Comment' nil nil 410 #{UI.Scintilla.ScintillaView} 34 52 nil 3952 34 2 8 1176572228 1 14064 9682 nil false 9728 nil 466 #commentWorkspace nil 7 4322 nil true 34 12 4370 1 850 #accept 8 '&Accept' 1 1 nil nil nil 4578 4097 4322 nil true 34 10 4370 1 850 #undo 8 '&Undo' 1 1 898 nil true 930 8 'EditUndo.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #cutSelection 8 'Cu&t' 1 1 898 nil true 930 8 'EditCut.ico' 992 65541 nil nil nil 4370 1 850 #copySelection 8 '&Copy' 1 1 898 nil true 930 8 'EditCopy.ico' 992 65541 nil nil nil 4370 1 850 #pasteClipboard 8 '&Paste' 1 1 898 nil true 930 8 'EditPaste.ico' 992 65541 nil nil nil 4370 1 850 #clearSelection 8 'De&lete' 1 1 898 nil true 930 8 'EditClear.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #clear 8 'Clea&r' 1 1 898 nil true 930 8 'ClearDocument.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4578 4097 4370 1 850 #browseIt 8 'Bro&wse It' 1 1 11264 nil nil 4370 1 850 #displayIt 8 '&Display It' 1 1 898 nil true 930 8 'DisplayIt.ico' 992 65541 nil nil nil 4370 1 850 #printIt 11440 1 1 11456 nil nil 4370 1 850 #evaluateIt 8 'E&valuate It' 1 1 898 nil true 930 8 'EvaluateIt.ico' 992 65541 nil nil nil 4370 1 850 #inspectIt 8 '&Inspect It' 1 1 11648 nil nil 4370 1 850 #debugIt 11728 1 1 11744 nil nil 4578 4097 4322 nil true 34 2 4370 2097153 850 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 4370 1 850 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 14064 594 #seaGreen 8 1389372803 12034 nil nil 9 nil 170 192 34 50 #ulistItem 12098 27 786758 1 #{Graphics.RGB} 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #horizontalRule 12098 35 15618 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #olistItem 12098 29 15618 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #normal 12098 1 nil 594 #window 1 nil nil nil nil #normal nil nil nil #lineNumber 12098 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #preChar 12098 25 594 #black 15618 22404573 1 nil nil nil nil #preChar nil 1401 nil #lineBegin 12098 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #header3 12098 17 15618 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #header1 12098 13 15618 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #indentGuide 12098 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #link 12098 37 15618 22282241 nil 33 nil nil nil nil #link nil nil nil #header6 12098 23 15618 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #strong1 12098 5 15618 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #header5 12098 21 15618 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #blockQuote 12098 31 15618 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #strong2 12098 7 15618 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #codeBlock 12098 43 15618 17825793 15618 31317469 1 nil nil nil nil #codeBlock nil nil nil #strikeOut 12098 33 15618 7768625 15618 20673875 1 nil nil nil nil #strikeOut nil nil nil #em2 12098 11 15618 26317 nil 9 nil nil nil nil #em2 nil nil nil #em1 12098 9 15618 26317 nil 9 nil nil nil nil #em1 nil nil nil #header4 12098 19 15618 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #code 12098 39 15618 17825793 15618 31317469 1 nil nil nil nil #code nil nil nil #code2 12098 41 15618 17825793 15618 31317469 1 nil nil nil nil #code2 nil nil nil #callTip 12098 77 12128 12144 1 nil nil nil nil #callTip nil nil nil #header2 12098 15 15618 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil nil 1507654 1 #{UI.Scintilla.NullStyler} #normal 170 192 34 2 #default 12258 1 nil nil nil 14064 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 768 nil 170 176 768 nil nil nil 170 176 34 2 81 12352 nil nil 12384 nil 65 nil nil nil 12480 3 170 192 34 4 #markdown 15568 #container 170 192 34 4 #callTip 12098 77 12128 12144 1 nil nil nil nil #callTip nil nil nil #normal 12098 1 nil nil 1 nil nil nil nil #normal nil nil nil nil nil nil nil 208 nil 170 192 34 4 #Warning 12562 19 14064 12592 3 3 #Warning nil nil nil nil nil nil #Error 12562 17 14064 12624 3 3 #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 12098 1027 12688 12704 1 nil nil nil nil #Warning nil nil nil #Error 12098 1031 12736 12752 1 nil nil nil nil #Error nil nil nil #Notification 12098 1029 nil 12784 1 nil nil nil nil #Notification nil nil nil nil nil nil 1362 34 9 1410 #createAt:extent: 34 2 1458 9 97 1458 965 729 14064 1410 #contextMenu: 34 1 14160 14064 1410 #wordWrap: 8 #(true) 14064 1410 #margins: 34 1 34 3 13010 1 14064 1 3 nil nil 5 nil 13010 3 14064 1 nil nil 67108863 5 nil 13010 5 14064 1 nil nil nil 5 nil 14064 1410 #maxCompletionListHeight: 8 #(9) 14064 1410 #setLexerLanguage: 8 #(#markdown) 14064 1410 #sciSetTechnology: 8 #(1) 14064 1410 #sciSetFontQuality: 8 #(3) 14064 1410 #sciSetSelectionLayer: 8 #(1) 14064 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 8 #() 1568 nil 35 3922 4098 8 'Variables' nil nil 410 #{UI.ListView} 34 45 nil 3952 34 2 8 1140920393 1 17328 4242 138 144 768 nil 4304 608 nil 29 4322 nil true 34 6 4370 1 850 #addSharedVariable 8 '&Add Uncommitted…' 1 1 nil nil nil 4370 1 850 #removeVariables 8 '&Remove from Package' 1 1 nil nil nil 4578 4097 4370 2097153 850 #inspectSharedVariables 8 '&Inspect' 1 1 898 nil true 930 8 'BasicInspector.ico' 992 65541 nil nil nil 4370 1 850 #browseVariableReferences 8 'All Re&ferences' 1 1 nil nil nil 4370 1 850 #browseLocalGlobalReferences 8 '&Local References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 17328 nil 8 1793684656 3168 5074 0 nil 5106 4 1 5072 8 'doIt' 8 '[:x | x valueOrNil icon imageIndex]' 8 #[32 105 226 0 159 160 106] #valueOrNil #icon #imageIndex 17792 7 257 nil 5056 nil nil nil 1458 65 65 nil nil 138 144 34 5 5234 8 '' 41 #left 5074 0 nil 5106 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 5376 17952 7 257 nil 5074 0 nil 5106 3 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 18048 7 513 nil 5074 0 nil 5106 6 1 5072 8 'doIt' 8 '[:x | [x asQualifiedReference value isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 226 0 142 159 106 47 34 111 59 106 193 106] #asQualifiedReference #isChanged 5586 #Error #{Core.Error} #{Smalltalk} 1 #on:do: 18128 5074 0 nil 18144 39 257 nil 7 257 nil nil 17328 5074 0 nil 5106 5 1 5072 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]] ' 8 #[32 105 17 121 45 159 160 106 60 106] 5600 #changedIcon #imageIndex 18240 #ifTrue: 7 257 nil 1 nil nil 5234 8 'Name' 301 #left 3154 #unqualifiedName 8 #() 3154 #<= 8 #() nil nil 17328 5074 0 nil 5106 4 1 5072 8 'doIt' 8 '[:x | x valueOrNil icon imageIndex]' 8 #[32 105 226 0 159 160 106] #valueOrNil #icon #imageIndex 18416 7 257 nil 1 nil nil 5234 8 'Namespace' 301 #left 3154 #printString 8 #() 5074 0 nil 5106 4 1 3152 8 'doIt' 8 '[:a :b | a isNil or: [
	b notNil and: [a printString <= b printString]]]' 8 #[32 105 17 223 2 58 106 18 222 6 226 2 226 34 130 106 59 106] #or: #and: #printString 18560 7 513 nil 5074 0 nil 5106 4 1 5072 8 'doIt' 8 '[:each | each bindingOrNil ifNotNil: [:binding | binding environment]]' 8 #[32 105 226 0 100 222 2 70 159 106] #bindingOrNil #environment #ifNotNil: 18640 7 65793 nil nil 17328 nil 1 nil nil 5234 #Package 201 #left 3168 5074 0 nil 5106 2 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 18736 7 513 nil 5074 0 nil 5106 4 1 5072 8 'doIt' 8 '[:x | Package manager packageOfVariableNamed: x] ' 8 #[32 105 45 159 17 178 106] 5600 #manager #packageOfVariableNamed: 18816 7 257 nil nil 17328 nil 1 nil nil 5234 8 'File Out Name' 2001 #left 3168 3154 #<= 8 #() 5074 0 nil 5106 7 1 5072 8 'doIt' 8 '[:x | | glob |
glob := x valueOrNil.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[35 105 226 0 70 144 30 178 120 226 35 106 34 106] #valueOrNil #sourceObject #conformsToProtocol: #fileOutName #ifTrue:ifFalse: 8 '' 18960 7 65793 nil nil 17328 nil 1 nil nil #report 6176 nil 133221 nil 1 nil nil nil nil 1 nil nil nil nil nil nil nil nil nil nil 1362 34 2 1410 #createAt:extent: 34 2 1458 9 97 1458 965 729 17328 1410 #contextMenu: 34 1 17424 17328 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 8 #() 1568 nil 35 14064 nil nil nil 170 192 34 16 4176 8 'classes' 13552 8 'prerequisites' 14064 8 'comment' 13808 8 'dependents' 8336 8 'resources' 6432 8 'methods' 8976 8 'scripts' 17328 8 'variables' nil 410 #{UI.TabViewXP} 34 28 nil 3952 34 2 8 1140916736 1 19392 4242 138 144 34 8 14032 4112 6384 8288 17296 8944 13520 13776 nil 4304 nil nil 1 nil nil nil 19392 nil 8 1793497968 3168 3200 5056 nil nil nil nil nil #smallIcons nil nil nil nil nil 1362 34 3 1410 #createAt:extent: 34 2 1458 1 1 1458 981 833 19392 1410 #setSingleSelection: 8 #(1) 19392 1410 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 19392 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 234 1 0 0 160 1 0 0] 8 #() 1568 nil 27 1362 34 1 1410 #createAt:extent: 34 2 1458 1 1 1458 981 833 3952 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 234 1 0 0 160 1 0 0] 34 9 14064 4176 6432 8336 17328 8976 13552 13808 19392 1568 nil 27 5 false 170 192 34 2 3952 8 'ownedCards' nil 1362 34 1 1410 #createAt:extent: 34 2 1458 499 1 1458 981 833 3808 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 249 0 0 0 0 0 0 0 227 2 0 0 160 1 0 0] 34 1 3952 1568 nil 27 5 false 170 192 34 2 410 #{UI.ReferenceView} 34 14 nil 3696 34 2 8 1140850688 131073 20096 nil nil nil 7 nil nil nil 20096 1666 #{Tools.PackageSelector} #resource_Default_view nil 1362 34 1 1410 #createAt:extent: 34 2 1458 1 1 1458 489 833 20096 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 244 0 0 0 160 1 0 0] 768 1568 nil 27 8 'packages' nil 1362 34 1 1410 #createAt:extent: 34 2 1458 1 1 1458 1479 833 3696 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 227 2 0 0 160 1 0 0] 34 3 20096 410 #{UI.Splitter} 34 12 nil 3696 34 2 8 1140850688 1 20464 nil nil nil 519 nil nil nil 1707078 1 #{UI.DraggableViewInteractor} 20464 nil 1 #left nil nil nil 1458 1 1 1458 9 9 nil 20560 nil 1362 34 1 1410 #createAt:extent: 34 2 1458 489 1 1458 11 833 20464 1506 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 0 0 0 0 249 0 0 0 160 1 0 0] 8 #() 1568 nil 27 3808 1568 nil 27 1568 nil 27 170 192 34 4 528 8 'toolbar' 2912 8 'statusbar' nil 658246 4 #{UI.MenuBar} nil true 34 10 4322 nil true 34 24 4370 1 850 #newPackage 8 '&New Package…' 9373 5 898 nil true 930 8 'NewPackage.ico' 992 65541 nil nil nil 4370 1 850 #openPackage 8 '&Install Package…' 9375 5 898 nil true 930 8 'FileOpen.ico' 992 65541 nil nil nil 4370 1 850 #removePackage 8 '&Uninstall Package' 1 5 nil nil nil 4578 4097 4322 nil true 34 2 4370 2097153 850 #addClass 8 '&Class…' 1 1 898 nil true 930 8 'Behavior.ico' 992 65541 nil nil nil 4370 1 850 #addSharedVariable 8 '&Global…' 1 1 nil nil nil 8 'Add Unco&mmitted' nil 134217729 nil nil 59571 nil nil 4370 1 850 #chooseDefaultPackage 8 'Set as De&fault Package…' 1 1 nil nil nil 4370 1 850 #synchronizeFilter 8 '&Goto Folder' 1 1 898 nil true 930 8 'GotoFolder.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #savePackages 8 '&Save Package' 1 1 898 nil true 930 8 'FileSave.ico' 992 65541 nil nil nil 4370 1 850 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 4370 1 850 #savePackageAs 8 'Save Package &As…' 1 1 nil nil nil 4578 4097 4370 1 850 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4370 1 850 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4578 4097 4370 1 850 #saveImage 8 'Sa&ve Image' 1 1 898 nil true 930 8 'Snapshot.ico' 992 65541 nil nil nil 4370 1 850 #smalltalkExit 8 'E&xit Dolphin' 1 1 898 nil true 930 8 'PowerSwitch.ico' 992 65541 nil nil nil 4578 4097 4322 nil true 34 1 4370 2097153 850 #browseTests 8 '&Browse' 1 1 nil nil nil 8 '&Tests' nil 1 898 nil true 2163718 #{Graphics.ImageFromFileInitializer} 8 'TestRunner.ico' 2031622 #{Kernel.ImageRelativeFileLocator} 5 nil nil 59593 nil nil 4322 nil true 34 4 4370 2097153 850 #deploy 8 '&Deploy Executable…' 13445 1 nil nil nil 4370 1 850 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 898 nil true 930 8 'EnvironmentBrowserShell.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #saveBinaryPackage 8 'Deploy &Binary Package…' 1 1 nil nil nil 8 '&Deployment' nil 134217729 898 nil true 930 8 'ApplicationDeploymentWizard.ico' 992 65541 nil nil 59601 nil nil 4578 4097 4370 1 850 #inspectPackage 8 'P&roperties' 1 1 898 nil true 930 8 'BasicInspector.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #exit 8 '&Close' 17639 1 10994 $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 59607 nil nil 4322 nil true 34 12 4370 1 850 #undo 8 '&Undo' 9397 1 898 nil true 930 8 'EditUndo.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #cutSelection 8 'Cu&t' 9393 1 898 nil true 930 8 'EditCut.ico' 992 65541 nil nil nil 4370 1 850 #copySelection 8 '&Copy' 9351 1 898 nil true 930 8 'EditCopy.ico' 992 65541 nil nil nil 4370 1 850 #pasteClipboard 8 '&Paste' 9389 1 898 nil true 930 8 'EditPaste.ico' 992 65541 nil nil nil 4370 1 850 #editDelete 8 '&Delete' 1 1 898 nil true 930 8 'EditClear.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #selectAll 8 'Select &All' 9347 1 nil nil nil 4578 4097 4370 1 850 #editFind 8 '&Find…' 9357 1 898 nil true 2425862 #{Graphics.ImageFromResourceInitializer} 47 983302 #{OS.ShellLibrary} 65541 nil nil nil 4370 1 850 #findNext 8 'Find &Next' 1253 1 898 nil true 930 8 'FindNext.ico' 992 65541 nil nil nil 4370 1 850 #findReplace 8 '&Replace…' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 59627 nil nil 4322 nil true 34 14 4370 1 850 #browseIt 8 '&Browse It' 9349 1 898 nil true 930 8 'ClassBrowserShell.ico' 992 65541 nil nil nil 4370 1 850 #displayIt 8 '&Display It' 9353 1 898 nil true 930 8 'DisplayIt.ico' 992 65541 nil nil nil 4370 1 850 #printIt 8 '&Print It' 9377 1 898 nil true 930 8 'PrintIt.ico' 992 65541 nil nil nil 4370 1 850 #evaluateIt 8 '&Evaluate It' 9355 1 898 nil true 930 8 'EvaluateIt.ico' 992 65541 nil nil nil 4370 1 850 #inspectIt 8 '&Inspect It' 9363 1 898 nil true 930 8 'BasicInspector.ico' 992 65541 nil nil nil 4370 1 850 #debugIt 8 'Deb&ug It' 1269 1 898 nil true 930 8 'Debugger.ico' 992 65541 nil nil nil 4370 1 850 #fileItIn 8 '&File It In' 1 1 nil nil nil 4578 4097 4370 1 850 #browseDefinitions 8 'Defi&nitions…' 1271 1 nil nil nil 4370 1 850 #browseReferences 8 '&References…' 5367 1 nil nil nil 4578 4097 4370 1 850 #accept 8 '&Accept' 9383 1 nil nil nil 4578 4097 4322 nil true 34 7 4370 1 850 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4370 1 850 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4370 1 850 #toggleLineEndings 8 'Line &Endings' 1 1 10994 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4370 1 850 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4370 1 850 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4370 1 850 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4370 1 850 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 898 nil true 930 8 'Preferences.ico' 992 65541 nil nil 59663 nil nil 8 '&Workspace' nil 134217729 nil nil 59665 nil nil 4322 nil true 34 4 4370 1 850 #browseLocalMessageDefinitions 8 '&Definitions Of…' 1 1 nil nil nil 4370 1 850 #browseLocalMessageReferences 8 '&References To…' 1 1 nil nil nil 4578 4097 4370 1 850 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 59673 nil nil 4322 nil true 34 10 4370 1 850 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4370 2097153 850 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4578 4097 4370 1 850 #checkOut 8 'Check Out &All' 1 1 nil nil nil 4370 1 850 #checkOutChanges 8 '&Check Out Changes' 9367 1 nil nil nil 4370 1 850 #checkIn 8 'Check &In' 9387 1 nil nil nil 4578 4097 4370 1 850 #savePackageChanges 8 'Save C&hanges' 1 1 898 nil true 930 8 'FileSave.ico' 992 65541 nil nil nil 4578 4097 4370 1 850 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' nil 134217729 nil nil 59689 nil nil 4322 nil true 34 10 4370 1 850 #renameMethod 8 'Re&name Method…' 1 1 nil nil nil 4370 1 850 #renameMethodReferences 8 'Rename Re&ferences…' 1 1 nil nil nil 4578 4097 4370 1 850 #removeMethod 8 'Re&move Method…' 1 1 nil nil nil 4370 1 850 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 4578 4097 4370 1 850 #addParameter 8 'Add Method &Parameter…' 1 1 nil nil nil 4370 1 850 #removeParameter 8 'Remo&ve Method Parameter…' 1 1 nil nil nil 4578 4097 4370 1 850 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope…' 1 5 nil nil nil 8 'Refactorin&gs' #refactoringsMenu 134217729 nil nil 59705 nil nil 4322 nil true 34 3 4370 1 850 #undoChange 8 '&Undo <1d>' 1 1 898 nil true 930 8 'EditUndo.ico' 992 65541 nil nil nil 4370 1 850 #redoChange 8 '&Redo <1d>' 1 1 898 nil true 930 8 'EditRedo.ico' 992 65541 nil nil nil 4370 1 850 #clearChangeHistory 8 'Clear Change &History' 1 1 898 nil true 930 8 'MethodHistoryErase.ico' 992 65541 nil nil nil 8 'H&istory' nil 134217729 nil nil 59713 nil nil 4322 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 59715 nil nil 4322 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 59717 nil nil 4322 nil true 34 15 4370 1 850 #helpContents 8 '&Contents' 1025 1 898 nil true 930 8 'Help.ico' 992 65541 nil nil nil 4370 1 850 #help 8 'On this &Tool' 1249 1 nil nil nil 4370 1 850 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4578 4097 4370 1 850 #learnSmalltalk 8 'Learn Smalltalk' 1 1 10994 $\x1F393 nil 594 #orchid 12144 nil nil 1 nil nil nil nil 4578 4097 4370 1 850 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4370 1 850 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4370 1 850 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4578 4097 4370 1 850 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 898 nil true 930 8 '!!APPLICATION' 992 65541 nil nil nil 4370 1 850 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4370 1 850 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4578 4097 4370 1 850 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 10994 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 59741 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 1458 771 621 1 nil nil 1362 34 2 1410 #createAt:extent: 34 2 1458 12287 21 1458 1511 1041 416 1410 #text: 34 1 8 'Package Browser' 416 1506 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 242 26 0 0 18 2 0 0] 34 3 528 3424 2912 1568 nil 27)!

toolsFolderHelpId
	^10598!

wordWrapComment
	"Answer true if instances of the receiver use comment word wrapping."

	^WordWrapComment!

wordWrapComment: aBoolean
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrapComment == aBoolean ifTrue: [^self].
	WordWrapComment := aBoolean.
	self persistOptions! !
!Tools.PackageBrowserShell class categoriesForMethods!
defaultOptionFlags!constants!options!private! !
displayOn:!displaying!public! !
icon!constants!public! !
initialize!initializing!private! !
publishedAspects!public! !
resource_Default_view!public!resources-views! !
toolsFolderHelpId!public! !
wordWrapComment!accessing!options!public! !
wordWrapComment:!accessing!options!public! !
!

