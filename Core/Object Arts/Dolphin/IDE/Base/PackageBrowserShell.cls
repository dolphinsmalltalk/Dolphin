"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #PackageBrowserShell
	instanceVariableNames: 'packagesPresenter classesPresenter methodsPresenter methodRefactoringTool variablesPresenter resourcesPresenter currentCard commentPresenter cardsPresenter updateFlags scriptTextPresenter scriptNamesPresenter prerequisitesPresenter dependentsPresenter statusModel versionModel'
	classVariableNames: 'WordWrapComment'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''
	classConstants: {}!
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
			[| env |
			env := Smalltalk developmentSystem browserEnvironmentForClasses: classes.
			^#{EnvironmentBrowserShell} valueOrNil
				ifNil: 
					[MessageBox notify: 'This feature is only available in the Professional edition'
						caption: 'Cannot browse multiple classes'.
					nil]
				ifNotNil: 
					[:environmentBrowserClass |
					environmentBrowserClass show
						browserEnvironment: env;
						yourself]]!

browseClassReferences
	"Browse all the methods in the entire system which refer to the class selected in the
	receiver."

	self browseClassReferencesIn: self systemModel systemEnvironment!

browseClassReferencesIn: aBrowserEnvironment 
	#todo.	"Make this work for multiple class selections"
	self model browseClassReferences: self selectedClass in: aBrowserEnvironment!

browseDefinitions
	^self browseMessageDefinitions!

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
	"focus == variablesPresenter view ifTrue: [^#browseVariables]."
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
	(self sharedVariable notNil and: [currentCard = #variables])
		ifTrue: [^self browseVariableReferences].
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

browseVariableReferences
	"Browse all the methods which refer to the shared variable selected in the receiver."

	self model browseSharedVariableReferences: self sharedVariable
		in: self systemModel systemEnvironment!

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
	methodRefactoringTool := self systemModel newMethodRefactoringToolFor: self.
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

	| class |
	class := anNMLVCUSTOMDRAW subItem.
	class isDeprecated ifTrue: [anNMLVCUSTOMDRAW font isStruckThrough: true].
	class isNonInstantiable ifTrue: [anNMLVCUSTOMDRAW font isItalic: true]!

defaultHelpId
	^10807!

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
	focus == variablesPresenter view ifTrue: [^#inspectSharedVariables].
	focus == resourcesPresenter view ifTrue: [^#inspectResources].
	^nil!

inspectMethods
	"Open an inspector on the currently selected methods."

	self inspectCollection: self selectedMethods!

inspectResources
	"Open an inspector on the currently selected resources."

	self inspectCollection: self resourceIdentifiers!

inspectSharedVariables
	"Open an inspector on the currently selected variables."

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

onDragVariable: aDragDropSession
	"Private - A Global drag has been started. Populate the <DragDropSession>, 
	session with the objects to be dragged."

	| dragObject |
	aDragDropSession dragObjects: nil.
	dragObject := aDragDropSession suggestedSource.
	aDragDropSession addDragObject: ((aDragDropSession newDragObject: dragObject)
				format: #VariableName data: dragObject;
				yourself).
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

onVariableRemoved: aVariableBinding
	"Private - The shared variable with the specified binding has been removed from the system.
	The variables pane must be kept up to date."

	currentCard == #variables
		ifTrue: [variablesPresenter model remove: aVariableBinding fullyQualifiedReference ifAbsent: []]
		ifFalse: [self markCardDirty: #variables]!

onVariableRenamed: aVariableBinding from: aBindingReference
	"Private - The shared variable with the specified binding has been renamed, the <Symbol>
	argument being its original name. The variables pane must be kept up to date."

	currentCard == #variables
		ifTrue: 
			[(variablesPresenter model remove: aBindingReference ifAbsent: []) notNil
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
			[aCommandQuery isEnabled: (self selectedClass notNil
						or: [self selectedMethod notNil or: [self sharedVariable notNil]]).
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
						expandMacrosWithArguments: {methods size = 1 ifTrue: [methods first] ifFalse: ['&Methods']}
						locale: Locale smalltalk).
			^true].
	#browseVariableReferences == selector
		ifTrue: 
			[aCommandQuery isEnabled: self sharedVariable notNil.
			^true].
	(#(#inspectSharedVariables #browseGlobals #removeVariables) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: self variableNames notEmpty.
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
	Smalltalk removeEventsTriggeredFor: self.
!

removeClasses
	"Private - Remove the currently selected classes from the package."

	self selectedClasses do: [:e | e owningPackage removeClass: e]!

removeLooseMethods
	"Private - Remove the currently selected method(s) from their packages.
	Note that the methods are not actually removed from the system (i.e.
	ownership is transferred to the package of their method class)."

	self selectedMethods do: [:each | each owningPackage removeMethod: each]!

removeVariables
	"Private - Remove the currently selected variables from their packages."

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

statusText: aString
	statusModel 
		value: (aString isNil ifFalse: [Notification new messageText: aString])!

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

	currentCard isNil ifTrue: [self cacheCurrentCard].
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
				isImmutable: true;
				yourself)!

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

updateVariables
	"Private - Update the Shared Variables list for this package."

	| bindingRefs |
	bindingRefs := OrderedCollection new.
	self packages do: [:each | bindingRefs addAll: each variableNames].
	variablesPresenter list: bindingRefs!

upgradeResources
	"Private - Uprade & resave the selected resources, by loading them into a ViewComposer."

	self resourceIdentifiers do: [:each | each reassign]!

variableNames
	^variablesPresenter selections! !
!PackageBrowserShell categoriesFor: #accept!commands!public! !
!PackageBrowserShell categoriesFor: #addToCommandRoute:!commands!public! !
!PackageBrowserShell categoriesFor: #applyOptions!operations!options!private! !
!PackageBrowserShell categoriesFor: #browseClass!commands!public! !
!PackageBrowserShell categoriesFor: #browseClassReferences!commands!public! !
!PackageBrowserShell categoriesFor: #browseClassReferencesIn:!helpers!private! !
!PackageBrowserShell categoriesFor: #browseDefinitions!commands!public! !
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
!PackageBrowserShell categoriesFor: #browseVariableReferences!commands!public! !
!PackageBrowserShell categoriesFor: #buildPopupForCommand:!event handling!private! !
!PackageBrowserShell categoriesFor: #cacheCurrentCard!event handling!private! !
!PackageBrowserShell categoriesFor: #canSaveState!private!saved state! !
!PackageBrowserShell categoriesFor: #clearCard:!private!updating! !
!PackageBrowserShell categoriesFor: #clearClasses!private!updating! !
!PackageBrowserShell categoriesFor: #clearComment!private!updating! !
!PackageBrowserShell categoriesFor: #clearDependents!private!updating! !
!PackageBrowserShell categoriesFor: #clearMethods!private!updating! !
!PackageBrowserShell categoriesFor: #clearPrerequisites!private!updating! !
!PackageBrowserShell categoriesFor: #clearResources!private!updating! !
!PackageBrowserShell categoriesFor: #clearScriptNames!private!updating! !
!PackageBrowserShell categoriesFor: #clearVariables!private!updating! !
!PackageBrowserShell categoriesFor: #createComponents!commands!initializing!private! !
!PackageBrowserShell categoriesFor: #createSchematicWiring!commands!initializing!private! !
!PackageBrowserShell categoriesFor: #customDrawClassList:!private! !
!PackageBrowserShell categoriesFor: #defaultHelpId!public! !
!PackageBrowserShell categoriesFor: #hasClassSelected!public!testing! !
!PackageBrowserShell categoriesFor: #hasEditableMethodSelected!public!testing! !
!PackageBrowserShell categoriesFor: #hasEditableMethodsSelected!public!testing! !
!PackageBrowserShell categoriesFor: #hasMethodSelected!public!testing! !
!PackageBrowserShell categoriesFor: #hasPackages!private!testing! !
!PackageBrowserShell categoriesFor: #hasPackageSelected!public!testing! !
!PackageBrowserShell categoriesFor: #initialize!initializing!private! !
!PackageBrowserShell categoriesFor: #inspectClasses!commands!public! !
!PackageBrowserShell categoriesFor: #inspectCollection:!helpers!private! !
!PackageBrowserShell categoriesFor: #inspectIt!commands!public! !
!PackageBrowserShell categoriesFor: #inspectItCommand!helpers!private! !
!PackageBrowserShell categoriesFor: #inspectMethods!commands!public! !
!PackageBrowserShell categoriesFor: #inspectResources!commands!public! !
!PackageBrowserShell categoriesFor: #inspectSharedVariables!commands!public! !
!PackageBrowserShell categoriesFor: #isCardUpToDate:!private!testing! !
!PackageBrowserShell categoriesFor: #markCardDirty:!helpers!private! !
!PackageBrowserShell categoriesFor: #objectRepackaged:from:to:card:list:!event handling!private! !
!PackageBrowserShell categoriesFor: #onCardChanged!event handling!private! !
!PackageBrowserShell categoriesFor: #onClassRemoved:!event handling!private! !
!PackageBrowserShell categoriesFor: #onClassRepackaged:from:to:!event handling!private! !
!PackageBrowserShell categoriesFor: #onCloseRequested:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragClasses:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragMethods:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragOver:type:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragResource:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDragVariable:!event handling!private! !
!PackageBrowserShell categoriesFor: #onDropOverPackage:!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodAdded:!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodRemoved:!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodRepackaged:from:to:!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodSelected!event handling!private! !
!PackageBrowserShell categoriesFor: #onMethodUpdated:!event handling!private! !
!PackageBrowserShell categoriesFor: #onPackageChanged:!event handling!private! !
!PackageBrowserShell categoriesFor: #onPackageSelected!event handling!private! !
!PackageBrowserShell categoriesFor: #onPackageSelectionChanging:!private! !
!PackageBrowserShell categoriesFor: #onScriptSelected!event handling!private! !
!PackageBrowserShell categoriesFor: #onVariableRemoved:!event handling!private! !
!PackageBrowserShell categoriesFor: #onVariableRenamed:from:!event handling!private! !
!PackageBrowserShell categoriesFor: #onVariableRepackaged:from:to:!event handling!private! !
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
!PackageBrowserShell categoriesFor: #removeLooseMethods!commands!private! !
!PackageBrowserShell categoriesFor: #removeVariables!commands!private! !
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
!PackageBrowserShell categoriesFor: #sharedVariable!accessing!public! !
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
!PackageBrowserShell categoriesFor: #updateMap!private!updating! !
!PackageBrowserShell categoriesFor: #updateMethods!private!updating! !
!PackageBrowserShell categoriesFor: #updateMethodVersion!event handling!private! !
!PackageBrowserShell categoriesFor: #updatePrerequisites!private!updating! !
!PackageBrowserShell categoriesFor: #updateResources!private!updating! !
!PackageBrowserShell categoriesFor: #updateScriptNames!private!updating! !
!PackageBrowserShell categoriesFor: #updateStatus!private!updating! !
!PackageBrowserShell categoriesFor: #updateVariables!private!updating! !
!PackageBrowserShell categoriesFor: #upgradeResources!commands!public! !
!PackageBrowserShell categoriesFor: #variableNames!accessing!public! !

!PackageBrowserShell class methodsFor!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that a user in the specified <Locale> would want to see."

	aPuttableStream nextPutAll: 'Package Browser'!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Register the receiver with SmalltalkSystem.

		self initialize.
	"

	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true.
	self wordWrapComment: true!

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1868903408 170 192 34 10 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853580 131073 672 nil nil nil 519 nil nil nil 672 608 8 1868903408 170 192 8 #() 170 192 34 8 38985 1115206 1 ##(Smalltalk.ToolbarIconButton) 672 1 1180998 4 ##(Smalltalk.CommandDescription) #browsePackageSources 8 'Open Source Browser' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'SourceBrowser.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 38985 38983 818 672 1 850 #savePackageChanges 8 'Save Package Changes' 1 1 898 nil true 944 8 'FileSave.ico' 992 38983 38981 818 672 1 850 #openPackage 8 'Install Package' 1 1 898 nil true 944 8 'FileOpen.ico' 992 38981 38979 818 672 1 850 #newPackage 8 'New Package' 1 1 898 nil true 944 8 'NewPackage.ico' 992 38979 34 5 1184 1104 1024 832 1049158 1 ##(Smalltalk.ToolbarSeparator) 672 1 nil nil 1 nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1051 1 1426 201 51 672 1378 #updateSizePosted 768 672 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 113 2 0 0 25 0 0 0] 8 #() 1426 193 193 nil 27 8 'fileTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1584 nil nil nil 7 nil nil nil 1584 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 63 1 1426 553 51 1584 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 768 1552 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1840 nil nil nil 7 nil nil nil 1840 1650 ##(Smalltalk.Toolbar) #resource_Image_tools nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 1 1 1426 63 51 1840 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 768 1552 nil 27 8 'imageTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2080 nil nil nil 7 nil nil nil 2080 1650 ##(Smalltalk.Toolbar) #resource_Search_tools nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 615 1 1426 437 51 2080 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 768 1552 nil 27 8 'searchTools' 410 ##(Smalltalk.Toolbar) 34 25 nil 528 34 2 8 1140853612 131137 2320 nil nil nil 519 nil nil nil 2320 608 8 1868903408 170 192 768 170 192 34 2 38987 818 2320 273 850 #viewModeSelect 8 'Views' 1 1 898 nil true 944 8 'ViewMode.ico' 992 38987 34 1 2448 nil nil 1 nil nil nil nil nil 1314 138 144 34 2 1378 #createAt:extent: 34 2 1426 1251 1 1426 65 51 2320 1378 #updateSizePosted 768 2320 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 113 2 0 0 0 0 0 0 145 2 0 0 25 0 0 0] 8 #() 1552 nil 27 8 'viewTools' 170 192 768 8 #() nil nil 1 nil 1426 33 33 nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 1314 138 144 34 2 1378 #createAt:extent: 34 2 1426 1 1 1426 1449 51 528 1378 #updateSizePosted 768 528 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 2 0 0 25 0 0 0] 34 5 1840 1584 2080 672 2320 1552 nil 27 410 ##(Smalltalk.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2992 nil 608 nil 7 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 1426 193 193 nil 2992 nil 8 1868692016 170 192 34 4 853766 ##(Smalltalk.StatusBarItem) 1 -1 2992 nil 459270 ##(Smalltalk.Message) #displayString 8 #() 787814 3 ##(Smalltalk.BlockClosure) 0 nil 918822 ##(Smalltalk.CompiledMethod) 2 3 3200 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 3296 7 257 nil nil 8 'version' 3202 1 -1 2992 nil ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) nil 8 'errors' 34 1 3376 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 2992 nil nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 1 883 1426 1449 41 2992 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 212 2 0 0 205 1 0 0] 8 #() 1552 nil 27 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3616 nil nil nil 7 nil nil nil 3616 1180166 ##(Smalltalk.ProportionalLayout) 170 176 768 true 170 192 768 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 1 51 1426 1449 833 3616 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 212 2 0 0 185 1 0 0] 34 1 410 ##(Smalltalk.ContainerView) 34 15 nil 3616 34 2 8 1140850688 131073 3904 nil nil nil 7 nil nil nil 3904 3682 170 176 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 3904 34 2 8 1140850688 131073 4016 nil nil nil 7 nil nil nil 4016 3682 138 ##(Smalltalk.Dictionary) 34 1 721414 ##(Smalltalk.Association) 410 ##(Smalltalk.CardContainer) 34 16 nil 4016 34 2 8 1140850688 131073 4160 nil nil nil 7 nil nil nil 4160 656710 1 ##(Smalltalk.CardLayout) 138 144 34 8 4130 590662 1 ##(Smalltalk.CardLabel) 8 'Classes' 1378 #icon 8 #() ##(Smalltalk.Behavior) nil 410 ##(Smalltalk.ListView) 34 30 nil 4160 34 2 8 1140920395 1 4384 590662 2 ##(Smalltalk.ListModel) 138 144 768 nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 608 nil 29 265030 4 ##(Smalltalk.Menu) nil true 34 6 984134 2 ##(Smalltalk.CommandMenuItem) 2097153 850 #browseClass 8 '&Browse' 1 1 898 nil true 944 8 'ClassBrowserShell.ico' 992 nil nil 4578 1 850 #browseClassReferences 8 'All Re&ferences' 1 1 nil nil nil 4578 1 850 #browseLocalClassReferences 8 'L&ocal References' 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 4578 1 850 #addClass 8 '&Add Uncommitted..' 1 1 nil nil nil 4578 1 850 #removeClasses 8 '&Remove from Package' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4384 nil 8 1868909856 3234 #name 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil 3282 0 nil 1180966 ##(Smalltalk.CompiledExpression) 4 1 3280 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 4992 7 257 nil 1426 65 65 nil nil 138 144 34 4 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 41 #left 3282 0 nil 5010 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 5184 7 257 nil 3282 0 nil 5010 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 5296 7 513 nil 3234 #isChanged 8 #() nil 4384 3282 0 nil 5010 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4130 #Package ##(Smalltalk.Package) #changedIcon #imageIndex 5408 7 257 nil 1 nil 3282 0 nil 5010 6 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx |
ctx item isNonInstantiable ifTrue: [ctx font isItalic: true]]' 8 #[34 105 226 0 159 122 226 2 58 179 106 60 106] #item #isNonInstantiable #font #isItalic: #ifTrue: 5504 7 257 nil 5138 8 'Name' 375 #left 3234 #name 8 #() 3234 #<= 8 #() nil nil 4384 ##(Smalltalk.IconicListAbstract) 1 nil 3282 0 nil 5010 4 1 3280 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 5680 7 257 nil 5138 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3282 0 nil 5010 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5792 7 513 nil 3234 #owningPackage 8 #() nil 4384 nil 1 nil nil 5138 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) 3234 #<= 8 #() 3282 0 nil 5010 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] #fileOutName 5968 7 257 nil nil 4384 nil 1 nil nil #list 768 nil 133221 nil 34 4 nil nil 1426 1 1 nil 1314 138 144 34 2 1378 #createAt:extent: 34 2 1426 9 97 1426 945 729 4384 1378 #contextMenu: 34 1 4544 4384 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 8 #() 1552 nil 27 4130 4306 8 'Methods' 1378 #icon 4368 3312 nil 410 ##(Smalltalk.ListView) 34 30 nil 4160 34 2 8 1140920393 1 6336 4450 138 144 768 nil 4512 608 nil 29 4530 nil true 34 8 4578 2097153 850 #browseMethods 8 'Browse <1d>' 1 1 nil nil nil 4578 1 850 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 nil nil nil 4578 1 850 #browseMessageReferences 8 'All Re&ferences' 1 1 nil nil nil 4578 1 850 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 nil nil nil 4578 1 850 #browseLocalMessageReferences 8 '&Local References' 1 1 nil nil nil 4770 4097 4578 1 850 #removeLooseMethods 8 '&Remove from Package' 1 1 nil nil nil 4530 nil true 34 7 4578 1 850 #renameMethod 8 'Re&name' 1 1 nil nil nil 4578 1 850 #renameMethodReferences 8 'Rename Re&ferences' 1 1 nil nil nil 4770 4097 4578 1 850 #safeRemoveMethods 8 '&Remove' 1 1 nil nil nil 4770 4097 4578 1 850 #addParameterToMethod 8 'Add &Parameter...' 1 1 nil nil nil 4530 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 6336 nil 8 1868909856 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4976 nil nil nil 1426 65 65 nil nil 138 144 34 3 5138 8 'Selector' 401 #left 3234 #selector 8 #() 3282 0 nil 5010 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] #selector 7232 7 513 nil nil nil 6336 ##(Smalltalk.IconicListAbstract) 1 nil 3282 0 nil 5010 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4130 #ClassBrowserAbstract ##(Smalltalk.ClassBrowserAbstract) #looseMethodColor #forecolor: 7312 7 257 nil 5138 8 'Class' 389 #left ##(Smalltalk.BasicListAbstract) 3234 #<= 8 #() 3234 #methodClass 8 #() nil 6336 ##(Smalltalk.IconicListAbstract) 1 nil 3282 0 nil 5010 4 1 3280 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 7504 7 257 nil 5138 8 'Package' 149 #left ##(Smalltalk.BasicListAbstract) 3282 0 nil 5010 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 7616 7 513 nil 3234 #owningPackage 8 #() nil 6336 nil 3 nil nil #report 768 nil 131173 nil 34 4 nil nil 1426 1 1 nil 1314 138 144 34 3 1378 #createAt:extent: 34 2 1426 9 97 1426 945 729 6336 1378 #contextMenu: 34 1 6432 6336 1378 #text: 34 1 8 'Selector' 6336 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 8 #() 1552 nil 27 4130 4306 8 'Resources' 1378 #icon 4368 1648 nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4160 34 2 8 1140850688 131073 8064 nil nil nil 5 4530 nil true 34 4 4578 2097153 850 #editResource 8 '&Edit' 1 1 898 nil true 944 8 'ViewComposer.ico' 992 nil nil 4578 1 850 #showResource 8 '&Show' 1 1 898 nil true 944 8 'TestView.ico' 992 nil nil 4770 4097 4578 1 850 #deleteResource 8 '&Delete' 1 1 898 nil true 944 8 'EditClear.ico' 992 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 8064 1650 ##(Smalltalk.ResourceListPresenter) #resource_Package_view nil 1314 138 144 34 2 1378 #createAt:extent: 34 2 1426 9 97 1426 945 729 8064 1378 #contextMenu: 34 1 8128 8064 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 768 1552 nil 27 4130 4306 8 'Scripts' nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 4160 34 2 8 1140850688 131073 8672 nil nil nil 5 nil nil nil 8672 852230 ##(Smalltalk.FramingLayout) 170 176 34 4 410 ##(Smalltalk.ScintillaView) 34 50 nil 8672 34 2 8 1176572228 1025 8800 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 608 nil 21 4530 nil true 34 13 4578 1 850 #accept 8 '&Accept' 1 1 nil nil nil 4770 4097 4530 nil true 34 11 4578 1 850 #undo 8 '&Undo' 1 1 898 nil true 944 8 'EditUndo.ico' 992 nil nil 4770 4097 4578 1 850 #cutSelection 8 'Cu&t' 1 1 898 nil true 944 8 'EditCut.ico' 992 nil nil 4578 1 850 #copySelection 8 '&Copy' 1 1 898 nil true 944 8 'EditCopy.ico' 992 nil nil 4578 1 850 #pasteClipboard 8 '&Paste' 1 1 898 nil true 944 8 'EditPaste.ico' 992 nil nil 4578 1 850 #clearSelection 8 'De&lete' 1 1 898 nil true 944 8 'EditClear.ico' 992 nil nil 4578 1 850 #clear 8 'Clea&r' 1 1 898 nil true 944 8 'ClearDocument.ico' 992 nil nil 4770 4097 4578 1 850 #reformatSource 8 'Re&format' 1 1 nil nil nil 4770 4097 4578 1 850 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4530 nil true 34 10 4578 1 850 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4578 1 850 #cloneNew 8 '&Clone' 1 1 898 nil true 944 8 'SmalltalkWorkspace.ico' 992 nil nil 4770 4097 4578 1 850 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4578 1 850 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4578 1 850 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4578 1 850 #toggleLineEndings 8 'Line &Endings' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4578 1 850 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4578 1 850 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4578 1 850 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 4770 4097 4578 1 850 #browseIt 8 'Bro&wse It' 1 1 898 nil true 944 8 'ClassBrowserShell.ico' 992 nil nil 4578 1 850 #displayIt 8 '&Display It' 1 1 898 nil true 944 8 'DisplayIt.ico' 992 nil nil 4578 1 850 #printIt 8 '&Print It' 1 1 898 nil true 944 8 'PrintIt.ico' 992 nil nil 4578 1 850 #evaluateIt 8 'E&valuate It' 1 1 898 nil true 944 8 'EvaluateIt.ico' 992 nil nil 4578 1 850 #inspectIt 8 '&Inspect It' 1 1 898 nil true 944 8 'BasicInspector.ico' 992 nil nil 4578 1 850 #debugIt 8 'Deb&ug It' 1 1 898 nil true 944 8 'Debugger.ico' 992 nil nil 4770 4097 4530 nil true 34 3 4578 2097153 850 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 4578 1 850 #browseReferences 8 '&References...' 1 1 nil nil nil 4578 1 850 #browseMessages 8 '&Messages...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 8800 nil 8 1404948927 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 594 #gray 594 #white 1 nil nil nil nil #callTip nil nil nil #normal 11074 1 nil nil 1 nil nil nil nil #normal nil nil nil 34 256 11136 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 11088 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 768 170 192 34 2 #default 1641542 2 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 8800 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 768 nil 170 176 768 9215 nil nil nil nil 594 #silver nil nil 65 nil nil 170 192 34 6 #literalBytes 8 '[]' #literalArray 8 '()' #specialCharacter 8 '()[]<>' 8 '' 3 170 192 34 2 #container 11040 nil nil nil nil 3 nil 170 192 34 4 #Error 1510470 3 ##(Smalltalk.ScintillaIndicatorStyle) 19 8800 594 #red 3 false #Error nil nil nil nil nil nil #Warning 11490 17 8800 594 #blue 3 false #Warning nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 11074 1027 594 #darkGoldenrod 594 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 11074 1031 594 #firebrick 594 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 11074 1029 nil 594 #gainsboro 1 nil nil nil nil #Notification nil nil nil nil 1314 138 144 34 9 1378 #createAt:extent: 34 2 1426 21 21 1426 833 689 8800 1378 #contextMenu: 34 1 8928 8800 1378 #textLimit: 8 #(1073741823) 8800 1378 #caretPeriod: 8 #(530) 8800 1378 #wordWrap: 8 #(true) 8800 1378 #margins: 34 1 34 3 985158 3 ##(Smalltalk.ScintillaMargin) 1 8800 1 3 nil nil 5 nil 12018 3 8800 1 nil nil 67108863 5 nil 12018 5 8800 1 nil nil nil 5 nil 8800 1378 #canHScroll: 8 #(false) 8800 1378 #maxCompletionListHeight: 8 #(9) 8800 1378 #edgeColumn: 8 #(1) 8800 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 170 1 0 0 98 1 0 0] 8 #() 1552 nil 29 1181766 2 ##(Smalltalk.FramingConstraints) 1180678 ##(Smalltalk.FramingCalculation) #fixedParentLeft 21 12258 #fixedParentRight -91 12258 #fixedParentTop 21 12258 #fixedParentBottom -19 410 ##(Smalltalk.TabViewXP) 34 28 nil 8672 34 2 8 1140916866 1 12336 4450 138 144 768 nil 4512 608 nil 5 nil nil nil 12336 nil 8 1869015712 3282 0 nil 5010 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] #key 12448 7 257 nil 3282 0 nil 5010 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] #icon #imageIndex 12528 7 257 nil 4976 nil nil nil nil nil #smallIcons nil nil nil nil nil 1314 138 144 34 2 1378 #createAt:extent: 34 2 1426 1 1 1426 945 729 12336 1378 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 12336 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 216 1 0 0 108 1 0 0] 8 #() 1552 nil 27 12226 12272 1 12288 1 12304 1 12320 1 170 192 34 4 8800 8 'scriptText' 12336 8 'scriptNames' nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 9 97 1426 945 729 8672 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 34 2 8800 12336 1552 nil 27 4130 4306 8 'Prerequisites' nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4160 34 2 8 1140850688 131073 13088 nil nil nil 5 nil nil nil 13088 1650 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 9 97 1426 945 729 13088 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 768 1552 nil 27 4130 4306 8 'Dependents' nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 4160 34 2 8 1140850688 131073 13360 nil nil nil 5 nil nil nil 13360 1650 ##(Smalltalk.PackageDependencyPresenter) #resource_Default_view nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 9 97 1426 945 729 13360 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 768 1552 nil 27 4130 4306 8 'Comment' nil nil 410 ##(Smalltalk.ScintillaView) 34 50 nil 4160 34 2 8 1176572228 1 13632 8866 nil false 8912 nil 466 #commentWorkspace nil 7 4530 nil true 34 12 4578 1 850 #accept 8 '&Accept' 1 1 nil nil nil 4770 4097 4530 nil true 34 10 4578 1 850 #undo 8 '&Undo' 1 1 898 nil true 944 8 'EditUndo.ico' 992 nil nil 4770 4097 4578 1 850 #cutSelection 8 'Cu&t' 1 1 898 nil true 944 8 'EditCut.ico' 992 nil nil 4578 1 850 #copySelection 8 '&Copy' 1 1 898 nil true 944 8 'EditCopy.ico' 992 nil nil 4578 1 850 #pasteClipboard 8 '&Paste' 1 1 898 nil true 944 8 'EditPaste.ico' 992 nil nil 4578 1 850 #clearSelection 8 'De&lete' 1 1 898 nil true 944 8 'EditClear.ico' 992 nil nil 4770 4097 4578 1 850 #clear 8 'Clea&r' 1 1 898 nil true 944 8 'ClearDocument.ico' 992 nil nil 4770 4097 4578 1 850 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4770 4097 4578 1 850 #browseIt 8 'Bro&wse It' 1 1 10336 nil nil 4578 1 850 #displayIt 8 '&Display It' 1 1 898 nil true 944 8 'DisplayIt.ico' 992 nil nil 4578 1 850 #printIt 10480 1 1 10496 nil nil 4578 1 850 #evaluateIt 8 'E&valuate It' 1 1 898 nil true 944 8 'EvaluateIt.ico' 992 nil nil 4578 1 850 #inspectIt 8 '&Inspect It' 1 1 10656 nil nil 4578 1 850 #debugIt 10720 1 1 10736 nil nil 4770 4097 4530 nil true 34 2 4578 2097153 850 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 4578 1 850 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 13632 594 #seaGreen 8 1404948927 11010 nil nil 9 nil 170 192 34 50 #indentGuide 11074 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #lineBegin 11074 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #horizontalRule 11074 35 196934 1 ##(Smalltalk.RGB) 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #codeBlock 11074 43 15090 17825793 15090 31317469 1 nil nil nil nil #codeBlock nil nil nil #strong2 11074 7 15090 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #em1 11074 9 15090 26317 nil 9 nil nil nil nil #em1 nil nil nil #olistItem 11074 29 15090 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #code2 11074 41 15090 17825793 15090 31317469 1 nil nil nil nil #code2 nil nil nil #lineNumber 11074 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #header3 11074 17 15090 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #em2 11074 11 15090 26317 nil 9 nil nil nil nil #em2 nil nil nil #header5 11074 21 15090 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #code 11074 39 15090 17825793 15090 31317469 1 nil nil nil nil #code nil nil nil #blockQuote 11074 31 15090 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #header1 11074 13 15090 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #ulistItem 11074 27 15090 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #strikeOut 11074 33 15090 7768625 15090 20673875 1 nil nil nil nil #strikeOut nil nil nil #header6 11074 23 15090 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil #strong1 11074 5 15090 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #header2 11074 15 15090 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #header4 11074 19 15090 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #normal 11074 1 nil 594 #window 1 nil nil nil nil #normal nil nil nil #callTip 11074 77 11104 11120 1 nil nil nil nil #callTip nil nil nil #link 11074 37 15090 22282241 nil 33 nil nil nil nil #link nil nil nil #preChar 11074 25 594 #black 15090 22404573 1 nil nil nil nil #preChar nil 1401 nil 34 256 15744 15056 15648 15168 15200 15360 15504 15680 15328 15712 15392 15616 15824 15536 15232 15472 15568 15072 15792 15424 15264 15120 nil nil nil nil nil nil nil nil nil nil nil 15312 nil nil nil 15040 15776 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1245510 1 ##(Smalltalk.NullScintillaStyler) #normal 170 192 34 2 #default 11250 1 nil nil nil 13632 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 768 nil 170 176 768 nil nil nil nil nil 11312 nil nil 65 nil nil nil 11408 3 170 192 34 4 #markdown 15008 #container 170 192 34 4 #callTip 11074 77 11104 11120 1 nil nil nil nil #callTip nil nil nil #normal 11074 1 nil nil 1 nil nil nil nil #normal nil nil nil nil nil nil nil 130003 nil 170 192 34 4 #Warning 11490 19 13632 11552 3 false #Warning nil nil nil nil nil nil #Error 11490 17 13632 11520 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Warning 11074 1027 11616 11632 1 nil nil nil nil #Warning nil nil nil #Error 11074 1031 11664 11680 1 nil nil nil nil #Error nil nil nil #Notification 11074 1029 nil 11712 1 nil nil nil nil #Notification nil nil nil nil 1314 138 144 34 12 1378 #createAt:extent: 34 2 1426 9 97 1426 945 729 13632 1378 #contextMenu: 34 1 13728 13632 1378 #textLimit: 8 #(1073741823) 13632 1378 #isDrawingBuffered: 8 #(false) 13632 1378 #caretPeriod: 8 #(530) 13632 1378 #wordWrap: 8 #(true) 13632 1378 #margins: 34 1 34 3 12018 1 13632 1 3 nil nil 5 nil 12018 3 13632 1 nil nil 67108863 5 nil 12018 5 13632 1 nil nil nil 5 nil 13632 1378 #maxCompletionListHeight: 8 #(9) 13632 1378 #edgeColumn: 8 #(1) 13632 1378 #setLexerLanguage: 8 #(#markdown) 13632 1378 #sciSetTechnology: 8 #(1) 13632 1378 #sciSetFontQuality: 8 #(3) 13632 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 8 #() 1552 nil 29 4130 4306 8 'Variables' nil nil 410 ##(Smalltalk.ListView) 34 30 nil 4160 34 2 8 1140920393 1 16864 4450 138 144 768 nil 4512 608 nil 29 4530 nil true 34 6 4578 1 850 #addGlobal 8 '&Add Uncommitted...' 1 1 nil nil nil 4578 1 850 #removeVariables 8 '&Remove from Package' 1 1 nil nil nil 4770 4097 4578 2097153 850 #inspectSharedVariables 8 '&Inspect' 1 1 898 nil true 944 8 'BasicInspector.ico' 992 nil nil 4578 1 850 #browseVariableReferences 8 'All Re&ferences' 1 1 nil nil nil 4578 1 850 #browseLocalGlobalReferences 8 '&Local References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 16864 nil 8 1868909856 ##(Smalltalk.BasicListAbstract) 3282 0 nil 5010 4 1 3280 8 'doIt' 8 '[:x | x asQualifiedReference value icon imageIndex]' 8 #[32 105 226 0 142 159 160 106] #asQualifiedReference #icon #imageIndex 17312 7 257 nil 4976 nil nil nil 1426 65 65 nil nil 138 144 34 4 5138 8 '' 41 #left 3282 0 nil 5010 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 5280 17472 7 257 nil 3282 0 nil 5010 3 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 17568 7 513 nil 3282 0 nil 5010 6 1 3280 8 'doIt' 8 '[:x | [x asQualifiedReference value isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 226 0 142 159 106 47 34 111 59 106 193 106] #asQualifiedReference #isChanged 983558 ##(Smalltalk.VariableBinding) #Error ##(Smalltalk.Error) #on:do: 17648 3282 0 nil 17664 39 257 nil 7 257 nil nil 16864 3282 0 nil 5010 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 5488 #changedIcon #imageIndex 17776 7 257 nil 1 nil nil 5138 8 'Name' 301 #left ##(Smalltalk.BasicListAbstract) 3234 #<= 8 #() nil nil 16864 3282 0 nil 5010 4 1 3280 8 'doIt' 8 '[:x | x valueOrNil icon imageIndex]' 8 #[32 105 226 0 159 160 106] #valueOrNil #icon #imageIndex 17920 7 257 nil 1 nil nil 5138 8 'Package' 201 #left ##(Smalltalk.BasicListAbstract) 3282 0 nil 5010 2 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 18032 7 513 nil 3282 0 nil 5010 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:x | Package manager packageOfVariableNamed: x]' 8 #[32 105 45 159 17 178 106] 5488 #manager #packageOfVariableNamed: 18112 7 257 nil nil 16864 nil 1 nil nil 5138 8 'File Out Name' 2001 #left ##(Smalltalk.BasicListAbstract) 3234 #<= 8 #() 3282 0 nil 5010 7 1 3280 8 'doIt' 8 '[:x | | glob |
glob := x valueOrNil.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[35 105 226 0 70 144 30 178 120 226 35 106 34 106] #valueOrNil #sourceObject #conformsToProtocol: #fileOutName #ifTrue:ifFalse: 8 '' 18256 7 65793 nil nil 16864 nil 1 nil nil #report 768 nil 133221 nil 34 4 nil nil 1426 1 1 nil 1314 138 144 34 2 1378 #createAt:extent: 34 2 1426 9 97 1426 945 729 16864 1378 #contextMenu: 34 1 16960 16864 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 220 1 0 0 156 1 0 0] 8 #() 1552 nil 27 13632 nil nil nil 170 192 34 16 8672 8 'scripts' 6336 8 'methods' 4384 8 'classes' 13632 8 'comment' 8064 8 'resources' 13088 8 'prerequisites' 13360 8 'dependents' 16864 8 'variables' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 4160 34 2 8 1140916736 1 18736 4450 138 144 34 8 13600 4320 6288 8016 16832 8640 13056 13328 nil 4512 nil nil 1 nil nil nil 18736 nil 8 1869015712 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 4976 nil nil nil nil nil #smallIcons nil nil nil nil nil 1314 138 144 34 3 1378 #createAt:extent: 34 2 1426 1 1 1426 961 833 18736 1378 #basicSelectionsByIndex: 34 1 8 #(1) 18736 1378 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 18736 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 224 1 0 0 160 1 0 0] 8 #() 1552 nil 27 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 1 1 1426 961 833 4160 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 224 1 0 0 160 1 0 0] 34 9 13632 4384 6336 8064 16864 8672 13088 13360 18736 1552 nil 27 5 false 170 192 34 2 4160 8 'ownedCards' nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 489 1 1426 961 833 4016 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 0 0 0 0 212 2 0 0 160 1 0 0] 34 1 4160 1552 nil 27 5 false 170 192 34 2 410 ##(Smalltalk.ReferenceView) 34 14 nil 3904 34 2 8 1140850688 131073 19504 nil nil nil 7 nil nil nil 19504 1650 ##(Smalltalk.PackageSelector) #resource_Default_view nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 1 1 1426 479 833 19504 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 239 0 0 0 160 1 0 0] 768 1552 nil 27 8 'packages' nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 1 1 1426 1449 833 3904 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 212 2 0 0 160 1 0 0] 34 3 19504 410 ##(Smalltalk.Splitter) 34 12 nil 3904 34 2 8 1140850688 1 19904 nil nil nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 19904 nil 1 #left nil nil nil 1426 1 1 1426 9 9 nil 20000 nil 1314 138 144 34 1 1378 #createAt:extent: 34 2 1426 479 1 1426 11 833 19904 1490 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 239 0 0 0 0 0 0 0 244 0 0 0 160 1 0 0] 8 #() 1552 nil 27 4016 1552 nil 27 1552 nil 27 170 192 34 4 528 8 'toolbar' 2992 8 'statusbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 10 4530 nil true 34 24 4578 1 850 #newPackage 8 '&New Package...' 9373 5 898 nil true 944 8 'NewPackage.ico' 992 nil nil 4578 1 850 #openPackage 8 '&Install Package...' 9375 5 898 nil true 944 8 'FileOpen.ico' 992 nil nil 4578 1 850 #removePackage 8 '&Uninstall Package' 1 5 nil nil nil 4770 4097 4530 nil true 34 2 4578 2097153 850 #addClass 8 '&Class...' 1 1 898 nil true 944 8 'Behavior.ico' 992 nil nil 4578 1 850 #addGlobal 8 '&Global...' 1 1 nil nil nil 8 'Add Unco&mmitted' nil 134217729 nil nil 38781 nil nil 4578 1 850 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 nil nil nil 4578 1 850 #synchronizeFilter 8 '&Goto Folder' 1 1 898 nil true 944 8 'GotoFolder.ico' 992 nil nil 4770 4097 4578 1 850 #savePackages 8 '&Save Package' 1 1 898 nil true 944 8 'FileSave.ico' 992 nil nil 4578 1 850 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 4578 1 850 #savePackageAs 8 'Save Package &As...' 1 1 nil nil nil 4770 4097 4578 1 850 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4578 1 850 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4770 4097 4578 1 850 #saveImage 8 'Sa&ve Image' 1 1 898 nil true 944 8 'Snapshot.ico' 992 nil nil 4578 1 850 #smalltalkExit 8 'E&xit Dolphin' 1 1 898 nil true 944 8 'PowerSwitch.ico' 992 nil nil 4770 4097 4530 nil true 34 1 4578 2097153 850 #browseTests 8 '&Browse' 1 1 nil nil nil 8 '&Tests' nil 1 898 nil true 944 8 'TestRunner.ico' nil nil 38803 nil nil 4530 nil true 34 4 4578 2097153 850 #deploy 8 '&Deploy Executable...' 13445 1 nil nil nil 4578 1 850 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 898 nil true 944 8 'EnvironmentBrowserShell.ico' 992 nil nil 4770 4097 4578 1 850 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 nil nil nil 8 '&Deployment' nil 134217729 898 nil true 944 8 'ApplicationDeploymentWizard.ico' 992 nil 38811 nil nil 4770 4097 4578 1 850 #inspectPackage 8 'P&roperties' 1 1 898 nil true 944 8 'BasicInspector.ico' 992 nil nil 4770 4097 4578 1 850 #exit 8 '&Close' 17639 1 10066 $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 38817 nil nil 4530 nil true 34 12 4578 1 850 #undo 8 '&Undo' 9397 1 898 nil true 944 8 'EditUndo.ico' 992 nil nil 4770 4097 4578 1 850 #cutSelection 8 'Cu&t' 9393 1 898 nil true 944 8 'EditCut.ico' 992 nil nil 4578 1 850 #copySelection 8 '&Copy' 9351 1 898 nil true 944 8 'EditCopy.ico' 992 nil nil 4578 1 850 #pasteClipboard 8 '&Paste' 9389 1 898 nil true 944 8 'EditPaste.ico' 992 nil nil 4578 1 850 #editDelete 8 '&Delete' 1 1 898 nil true 944 8 'EditClear.ico' 992 nil nil 4770 4097 4578 1 850 #selectAll 8 'Select &All' 9347 1 nil nil nil 4770 4097 4578 1 850 #editFind 8 '&Find...' 9357 1 898 nil true 944 47 786694 ##(Smalltalk.ShellLibrary) nil nil 4578 1 850 #findNext 8 'Find &Next' 1253 1 898 nil true 944 8 'FindNext.ico' 992 nil nil 4578 1 850 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 38837 nil nil 4530 nil true 34 14 4578 1 850 #browseIt 8 '&Browse It' 9349 1 898 nil true 944 8 'ClassBrowserShell.ico' 992 nil nil 4578 1 850 #displayIt 8 '&Display It' 9353 1 898 nil true 944 8 'DisplayIt.ico' 992 nil nil 4578 1 850 #printIt 8 '&Print It' 9377 1 898 nil true 944 8 'PrintIt.ico' 992 nil nil 4578 1 850 #evaluateIt 8 '&Evaluate It' 9355 1 898 nil true 944 8 'EvaluateIt.ico' 992 nil nil 4578 1 850 #inspectIt 8 '&Inspect It' 9363 1 898 nil true 944 8 'BasicInspector.ico' 992 nil nil 4578 1 850 #debugIt 8 'Deb&ug It' 1269 1 898 nil true 944 8 'Debugger.ico' 992 nil nil 4578 1 850 #fileItIn 8 '&File It In' 1 1 nil nil nil 4770 4097 4578 1 850 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 4578 1 850 #browseReferences 8 '&References...' 5367 1 nil nil nil 4770 4097 4578 1 850 #accept 8 '&Accept' 9383 1 nil nil nil 4770 4097 4530 nil true 34 7 4578 1 850 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4578 1 850 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4578 1 850 #toggleLineEndings 8 'Line &Endings' 1 1 10066 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4578 1 850 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4578 1 850 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4578 1 850 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4578 1 850 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 898 nil true 944 8 'Preferences.ico' 992 nil 38873 nil nil 8 '&Workspace' nil 134217729 nil nil 38875 nil nil 4530 nil true 34 4 4578 1 850 #browseLocalMessageDefinitions 8 '&Definitions Of...' 1 1 nil nil nil 4578 1 850 #browseLocalMessageReferences 8 '&References To...' 1 1 nil nil nil 4770 4097 4578 1 850 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 38883 nil nil 4530 nil true 34 10 4578 1 850 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4578 2097153 850 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4770 4097 4578 1 850 #checkOut 8 'Check Out &All' 1 1 nil nil nil 4578 1 850 #checkOutChanges 8 '&Check Out Changes' 9367 1 nil nil nil 4578 1 850 #checkIn 8 'Check &In' 9387 1 nil nil nil 4770 4097 4578 1 850 #savePackageChanges 8 'Save C&hanges' 1 1 898 nil true 944 8 'FileSave.ico' 992 nil nil 4770 4097 4578 1 850 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' nil 134217729 nil nil 38899 nil nil 4530 nil true 34 10 4578 1 850 #renameMethod 8 'Re&name Method...' 1 1 nil nil nil 4578 1 850 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 4770 4097 4578 1 850 #safeRemoveMethod 8 'Re&move Method...' 1 1 nil nil nil 4578 1 850 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 4770 4097 4578 1 850 #addParameter 8 'Add Method &Parameter...' 1 1 nil nil nil 4578 1 850 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 nil nil nil 4770 4097 4578 1 850 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 nil nil nil 8 'Refactorin&gs' #refactoringsMenu 134217729 nil nil 38915 nil nil 4530 nil true 34 3 4578 1 850 #undoChange 8 '&Undo <1d>' 1 1 898 nil true 944 8 'EditUndo.ico' 992 nil nil 4578 1 850 #redoChange 8 '&Redo <1d>' 1 1 898 nil true 944 8 'EditRedo.ico' 992 nil nil 4578 1 850 #clearChangeHistory 8 'Clear Change &History' 1 1 898 nil true 944 8 'MethodHistoryErase.ico' 992 nil nil 8 'H&istory' nil 134217729 nil nil 38923 nil nil 4530 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 38925 nil nil 4530 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 38927 nil nil 4530 nil true 34 15 4578 1 850 #helpContents 8 '&Contents' 1025 1 898 nil true 944 8 'Help.ico' 992 nil nil 4578 1 850 #help 8 'On this &Tool' 1249 1 nil nil nil 4578 1 850 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4770 4097 4578 1 850 #learnSmalltalk 8 'Learn Smalltalk' 1 1 10066 $\x1F393 nil 594 #orchid 11120 nil nil 1 nil nil nil nil 4770 4097 4578 1 850 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4578 1 850 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4578 1 850 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4770 4097 4578 1 850 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 898 nil true 944 8 '!!APPLICATION' 992 nil nil 4578 1 850 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4578 1 850 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4770 4097 4578 1 850 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 10066 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 38951 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 1426 771 621 1 nil nil 1314 138 144 34 3 1378 #createAt:extent: 34 2 1426 7039 21 1426 1481 1041 416 1378 #text: 34 1 8 'Package Browser' 416 1378 #updateMenuBar 768 416 1490 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 163 16 0 0 18 2 0 0] 34 3 528 3616 2992 1552 nil 27 )!

toolsFolderHelpId
	^10598!

wordWrapComment
	"Answer true if instances of the receiver use comment word wrapping."

	^WordWrapComment!

wordWrapComment: aBoolean
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrapComment := aBoolean! !
!PackageBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!PackageBrowserShell class categoriesFor: #icon!constants!public! !
!PackageBrowserShell class categoriesFor: #initialize!initializing!private! !
!PackageBrowserShell class categoriesFor: #publishedAspects!public! !
!PackageBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!PackageBrowserShell class categoriesFor: #toolsFolderHelpId!public! !
!PackageBrowserShell class categoriesFor: #wordWrapComment!accessing!options!public! !
!PackageBrowserShell class categoriesFor: #wordWrapComment:!accessing!options!public! !

