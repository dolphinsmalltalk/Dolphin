"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.PackageBrowserShell'
	instanceVariableNames: 'packagesPresenter classesPresenter methodsPresenter methodRefactoringTool variablesPresenter resourcesPresenter currentCard commentPresenter cardsPresenter updateFlags scriptTextPresenter scriptNamesPresenter prerequisitesPresenter dependentsPresenter statusModel versionModel'
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

accept
	"Accept the changes to any of the panes in the receiver"

	currentCard == #comment ifTrue: [^self saveComment].
	currentCard == #scripts ifTrue: [currentCard == #scripts ifTrue: [^self saveScript]].
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

	(self selectedMethod notNil and: [currentCard == #methods]) 
		ifTrue: [^self systemModel browseClassHierarchyOfMethod: self selectedMethod].
	(self selectedClass notNil and: [currentCard == #classes]) 
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
	(self selectedMethod notNil and: [currentCard == #methods]) ifTrue: [^self browseMessageReferences].
	(self selectedClass notNil and: [currentCard == #classes]) ifTrue: [^self browseClassReferences].
	(self sharedVariable notNil and: [currentCard == #variables])
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
	(currentCard == #methods and: [(method := self selectedMethod) notNil]) 
		ifTrue: [browser selectMethod: method].
	(currentCard == #classes and: [(class := self selectedClass) notNil]) 
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

	self systemModel setCustomDrawAttributes: anNMLVCUSTOMDRAW forClass: anNMLVCUSTOMDRAW subItem!

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
	statusModel := versionModel := ValueHolder new!

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
	^(UI.FileOpenDialog new
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
	Smalltalk removeEventsTriggeredFor: self!

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
	statusModel value: (aString isNil ifFalse: [Notification new messageText: aString])!

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
!Tools.PackageBrowserShell categoriesFor: #accept!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #addToCommandRoute:!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #applyOptions!operations!options!private! !
!Tools.PackageBrowserShell categoriesFor: #browseClass!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseClassReferences!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseClassReferencesIn:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #browseDefinitions!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseHierarchy!commands!private! !
!Tools.PackageBrowserShell categoriesFor: #browseIt!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseItCommand!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #browseLocalClassReferences!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseLocalMessageDefinitions!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseLocalMessageReferences!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseLooseMethods:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #browseMessageDefinitions!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseMessageDefinitionsIn:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #browseMessageReferences!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseMessageReferencesIn:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #browseMethodClass!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseMethods!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browsePackages!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseReferences!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseSystem!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #browseVariableReferences!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #buildPopupForCommand:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #cacheCurrentCard!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #canSaveState!private!saved state! !
!Tools.PackageBrowserShell categoriesFor: #clearCard:!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #clearClasses!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #clearComment!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #clearDependents!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #clearMethods!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #clearPrerequisites!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #clearResources!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #clearScriptNames!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #clearVariables!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #createComponents!commands!initializing!private! !
!Tools.PackageBrowserShell categoriesFor: #createSchematicWiring!commands!initializing!private! !
!Tools.PackageBrowserShell categoriesFor: #customDrawClassList:!private! !
!Tools.PackageBrowserShell categoriesFor: #defaultHelpId!public! !
!Tools.PackageBrowserShell categoriesFor: #hasClassSelected!public!testing! !
!Tools.PackageBrowserShell categoriesFor: #hasEditableMethodSelected!public!testing! !
!Tools.PackageBrowserShell categoriesFor: #hasEditableMethodsSelected!public!testing! !
!Tools.PackageBrowserShell categoriesFor: #hasMethodSelected!public!testing! !
!Tools.PackageBrowserShell categoriesFor: #hasPackages!private!testing! !
!Tools.PackageBrowserShell categoriesFor: #hasPackageSelected!public!testing! !
!Tools.PackageBrowserShell categoriesFor: #initialize!initializing!private! !
!Tools.PackageBrowserShell categoriesFor: #inspectClasses!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #inspectCollection:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #inspectIt!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #inspectItCommand!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #inspectMethods!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #inspectResources!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #inspectSharedVariables!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #isCardUpToDate:!private!testing! !
!Tools.PackageBrowserShell categoriesFor: #markCardDirty:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #objectRepackaged:from:to:card:list:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onCardChanged!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onClassRemoved:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onClassRepackaged:from:to:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onCloseRequested:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onDragClasses:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onDragMethods:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onDragOver:type:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onDragResource:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onDragVariable:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onDropOverPackage:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onMethodAdded:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onMethodRemoved:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onMethodRepackaged:from:to:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onMethodSelected!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onMethodUpdated:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onPackageChanged:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onPackageSelected!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onPackageSelectionChanging:!private! !
!Tools.PackageBrowserShell categoriesFor: #onScriptSelected!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onVariableRemoved:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onVariableRenamed:from:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onVariableRepackaged:from:to:!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onViewClosed!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #onViewOpened!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #openWorkspace!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #packages!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #packages:!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #promptToSaveChanges!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #promptToSaveChanges:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #queryCommand:!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #refreshCard:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #release!dependency!public! !
!Tools.PackageBrowserShell categoriesFor: #removeClasses!commands!private! !
!Tools.PackageBrowserShell categoriesFor: #removeLooseMethods!commands!private! !
!Tools.PackageBrowserShell categoriesFor: #removeVariables!commands!private! !
!Tools.PackageBrowserShell categoriesFor: #resourceIdentifier!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #resourceIdentifiers!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #saveComment!commands!private! !
!Tools.PackageBrowserShell categoriesFor: #saveScript!operations!private! !
!Tools.PackageBrowserShell categoriesFor: #scriptName!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #scriptText!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #scriptText:!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #searchEnvironment!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #selectedClass!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #selectedClasses!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #selectedMethod!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #selectedMethods!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #selectionEnvironment!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #setInitialFocus!operations!public! !
!Tools.PackageBrowserShell categoriesFor: #sharedVariable!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #shortCaption!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #showPrerequisitesFor:!helpers!private! !
!Tools.PackageBrowserShell categoriesFor: #singlePackage!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #singlePackage:!accessing!public! !
!Tools.PackageBrowserShell categoriesFor: #source!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #statusText:!accessing!private! !
!Tools.PackageBrowserShell categoriesFor: #updateCaption!public!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateCardNow:!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateCards!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateClasses!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateComment!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateContents!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateDependents!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateMap!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateMethods!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateMethodVersion!event handling!private! !
!Tools.PackageBrowserShell categoriesFor: #updatePrerequisites!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateResources!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateScriptNames!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateStatus!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #updateVariables!private!updating! !
!Tools.PackageBrowserShell categoriesFor: #upgradeResources!commands!public! !
!Tools.PackageBrowserShell categoriesFor: #variableNames!accessing!public! !

!Tools.PackageBrowserShell class methodsFor!

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

	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self reuseIfOpen: true.
	self canUseIdeaSpace: true.
	self wordWrapComment: true!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		add: (Aspect boolean: #canUseIdeaSpace);
		add: (Aspect boolean: #wordWrapComment);
		yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 517 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 10 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Image_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 882 63 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 410 ##(UI.Toolbar) 34 25 nil 528 34 2 8 1140853580 131073 1264 nil nil nil 519 nil nil nil 1264 608 8 1801306032 170 192 976 170 192 34 8 47655 1311814 1 ##(UI.ToolbarIconButton) 1264 1 1377606 4 ##(UI.CommandDescription) #browsePackageSources 8 'Open Source Browser' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'SourceBrowser.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 47655 47653 1394 1264 1 1426 #savePackageChanges 8 'Save Package Changes' 1 1 1474 nil true 1520 8 'FileSave.ico' 1568 47653 47651 1394 1264 1 1426 #openPackage 8 'Install Package' 1 1 1474 nil true 1520 8 'FileOpen.ico' 1568 47651 47649 1394 1264 1 1426 #newPackage 8 'New Package' 1 1 1474 nil true 1520 8 'NewPackage.ico' 1568 47649 34 5 1760 1680 1600 1408 1245766 1 ##(UI.ToolbarSeparator) 1264 1 nil nil 1 nil nil nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1051 1 882 201 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 113 2 0 0 25 0 0 0] 8 #() 992 nil 27 8 'fileTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 2064 nil nil nil 7 nil nil nil 2064 738 ##(UI.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 615 1 882 437 51 2064 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 976 992 nil 27 8 'searchTools' 410 ##(UI.Toolbar) 34 25 nil 528 34 2 8 1140853612 131137 2304 nil nil nil 519 nil nil nil 2304 608 8 1801306032 170 192 976 170 192 34 2 47657 1394 2304 273 1426 #viewModeSelect 8 'Views' 1 1 1474 nil true 1520 8 'ViewMode.ico' 1568 47657 34 1 2432 nil nil 1 nil nil nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1251 1 882 65 51 2304 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 113 2 0 0 0 0 0 0 145 2 0 0 25 0 0 0] 8 #() 992 nil 27 8 'viewTools' 170 192 976 8 #() nil nil 1 nil 882 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1479 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 227 2 0 0 25 0 0 0] 34 5 672 1024 2064 1264 2304 992 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140850956 1 2944 nil 608 nil 7 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 77 105 99 114 111 115 111 102 116 32 83 97 110 115 32 83 101 114 105 102 0 0 0 0 0 0 0 0 0 0 0 0] 882 193 193 nil 2944 nil 8 1801004784 170 192 34 4 1050374 ##(UI.StatusBarItem) 1 -1 2944 nil 786950 ##(Core.Message) #displayString 8 #() 1246566 3 ##(Kernel.BlockClosure) 0 nil 1377574 ##(Kernel.CompiledMethod) 2 3 3152 #defaultGetImageBlock 609947523 8 #[30 105 226 0 106] #iconImageIndex 3248 7 257 nil nil 8 'version' 3154 1 -1 2944 nil ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) nil 8 'errors' 34 1 3328 1311750 ##(UI.StatusBarNullItem) 513 1 2944 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 883 882 1479 41 2944 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 185 1 0 0 227 2 0 0 205 1 0 0] 8 #() 992 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 3568 nil nil nil 7 nil nil nil 3568 1376774 ##(UI.ProportionalLayout) 170 176 976 true 170 192 976 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 1479 833 3568 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 227 2 0 0 185 1 0 0] 34 1 410 ##(UI.ContainerView) 34 15 nil 3568 34 2 8 1140850688 131073 3856 nil nil nil 7 nil nil nil 3856 3634 170 176 34 2 410 ##(UI.ContainerView) 34 15 nil 3856 34 2 8 1140850688 131073 3968 nil nil nil 7 nil nil nil 3968 3634 138 ##(Core.Dictionary) 34 1 1049094 ##(Core.Association) 410 ##(UI.CardContainer) 34 16 nil 3968 34 2 8 1140850688 131073 4112 nil nil nil 7 nil nil nil 4112 853318 1 ##(UI.CardLayout) 138 144 34 8 4082 787270 1 ##(UI.CardLabel) 8 'Classes' 834 #icon 8 #() ##(Core.Behavior) nil 410 ##(UI.ListView) 34 45 nil 4112 34 2 8 1140920395 1 4336 787270 2 ##(UI.ListModel) 138 144 976 nil 1769478 ##(Kernel.IdentitySearchPolicy) 608 nil 29 461638 4 ##(UI.Menu) nil true 34 6 1180742 2 ##(UI.CommandMenuItem) 2097153 1426 #browseClass 8 '&Browse' 1 1 1474 nil true 1520 8 'ClassBrowserShell.ico' 1568 nil nil 4530 1 1426 #browseClassReferences 8 'All Re&ferences' 1 1 nil nil nil 4530 1 1426 #browseLocalClassReferences 8 'L&ocal References' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 4530 1 1426 #addClass 8 '&Add Uncommitted..' 1 1 nil nil nil 4530 1 1426 #removeClasses 8 '&Remove from Package' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4336 nil 8 1801282304 3186 #fullName 8 #() ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil 3234 0 nil 1639718 ##(Kernel.CompiledExpression) 4 1 3232 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 4944 7 257 nil 882 65 65 nil nil 138 144 34 5 1117254 5 ##(UI.ListViewColumn) 8 '' 41 #left 3234 0 nil 4962 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 8 '' 5136 7 257 nil 3234 0 nil 4962 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 5248 7 513 nil 3186 #isChanged 8 #() nil 4336 3234 0 nil 4962 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 4082 #Package ##(Kernel.Package) #changedIcon #imageIndex 5360 7 257 nil 1 nil nil 5090 8 'Namespace' 301 #left 3186 #displayString 8 #() 3234 0 nil 4962 2 1 3232 8 'doIt' 8 '[:a :b | a displayString <= b displayString]' 8 #[30 105 226 0 226 32 130 106] #displayString 5520 7 513 nil 3186 #environment 8 #() nil 4336 ##(UI.IconicListAbstract) 1 nil nil 5090 8 'Name' 375 #left 3186 #unqualifiedName 4896 3186 #<= 8 #() nil nil 4336 ##(UI.IconicListAbstract) 1 nil 3234 0 nil 4962 4 1 3232 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 5712 7 257 nil 5090 #Package 201 #left ##(UI.BasicListAbstract) 3234 0 nil 4962 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 5808 7 513 nil 3186 #owningPackage 8 #() nil 4336 nil 1 nil nil 5090 8 'File Out Name' 2001 #left ##(UI.BasicListAbstract) 3186 #<= 8 #() 3234 0 nil 4962 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x fileOutName]' 8 #[30 105 17 158 106] #fileOutName 5984 7 257 nil nil 4336 nil 1 nil nil #list 8 #() nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 9 97 882 965 729 4336 834 #contextMenu: 34 1 4496 4336 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 8 #() 992 nil 35 4082 4258 8 'Methods' 834 #icon 4320 3264 nil 410 ##(UI.ListView) 34 45 nil 4112 34 2 8 1140920393 1 6336 4402 138 144 976 nil 4464 608 nil 31 4482 nil true 34 8 4530 2097153 1426 #browseMethods 8 'Browse <1d>' 1 1 nil nil nil 4530 1 1426 #browseMessageDefinitions 8 'All Defi&nitions' 1 1 nil nil nil 4530 1 1426 #browseMessageReferences 8 'All Re&ferences' 1 1 nil nil nil 4530 1 1426 #browseLocalMessageDefinitions 8 'Local &Definitions' 1 1 nil nil nil 4530 1 1426 #browseLocalMessageReferences 8 '&Local References' 1 1 nil nil nil 4722 4097 4530 1 1426 #removeLooseMethods 8 '&Remove from Package' 1 1 nil nil nil 4482 nil true 34 7 4530 1 1426 #renameMethod 8 'Re&name' 1 1 nil nil nil 4530 1 1426 #renameMethodReferences 8 'Rename Re&ferences' 1 1 nil nil nil 4722 4097 4530 1 1426 #safeRemoveMethods 8 '&Remove' 1 1 nil nil nil 4722 4097 4530 1 1426 #addParameterToMethod 8 'Add &Parameter...' 1 1 nil nil nil 4482 nil true 8 #() 8 'Remo&ve Parameter' #removeParameterMenu 134217729 nil nil nil nil nil 8 'Refactorin&gs' #methodRefactoringsMenu 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 6336 nil 8 1801282304 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 4928 nil nil nil 882 65 65 nil nil 138 144 34 4 5090 8 'Selector' 401 #left 3186 #selector 8 #() 3234 0 nil 4962 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a selector < b selector]' 8 #[30 105 17 158 18 158 128 106] #selector 7232 7 513 nil nil nil 6336 ##(UI.IconicListAbstract) 1 nil 3234 0 nil 4962 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:ctx | 
ctx forecolor: ClassBrowserAbstract looseMethodColor]' 8 #[32 105 17 45 159 178 106] 4082 #'Tools.ClassBrowserAbstract' ##(Tools.ClassBrowserAbstract) #looseMethodColor #forecolor: 7312 7 257 nil 5090 8 'Class' 389 #left 3186 #name 8 #() 3186 #<= 8 #() 3186 #methodClass 8 #() nil 6336 ##(UI.IconicListAbstract) 1 nil 3234 0 nil 4962 4 1 3232 8 'doIt' 8 '[:ctx | ctx view parentPresenter customDrawClassList: ctx]' 8 #[32 105 226 0 159 17 178 106] #view #parentPresenter #customDrawClassList: 7536 7 257 nil 5090 8 'Namespace' 301 #left 3186 #printString 8 #() 3234 0 nil 4962 4 1 3184 8 'doIt' 8 '[:a :b | a isNil or: [
	b notNil and: [a printString <= b printString]]]' 8 #[32 105 17 223 2 58 106 18 222 6 226 2 226 34 130 106 59 106] #or: #and: #printString 7680 7 513 nil 3186 #environment 8 #() nil 6336 ##(UI.IconicListAbstract) 1 nil nil 5090 #Package 149 #left ##(UI.BasicListAbstract) 3234 0 nil 4962 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 7808 7 513 nil 3186 #owningPackage 8 #() nil 6336 nil 3 nil nil #report 6064 nil 131173 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 9 97 882 965 729 6336 834 #contextMenu: 34 1 6432 6336 834 #text: 34 1 8 'Selector' 6336 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 8 #() 992 nil 35 4082 4258 8 'Resources' 834 #icon 4320 736 nil 410 ##(UI.ReferenceView) 34 14 nil 4112 34 2 8 1140850688 131073 8224 nil nil nil 5 4482 nil true 34 4 4530 2097153 1426 #editResource 8 '&Edit' 1 1 1474 nil true 1520 8 'ViewComposer.ico' 1568 nil nil 4530 1 1426 #showResource 8 '&Show' 1 1 1474 nil true 1520 8 'TestView.ico' 1568 nil nil 4722 4097 4530 1 1426 #deleteResource 8 '&Delete' 1 1 1474 nil true 1520 8 'EditClear.ico' 1568 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 8224 738 ##(Tools.ResourceListPresenter) #resource_Package_view nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 9 97 882 965 729 8224 834 #contextMenu: 34 1 8288 8224 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 976 992 nil 27 4082 4258 8 'Scripts' nil nil 410 ##(UI.ContainerView) 34 15 nil 4112 34 2 8 1140850688 131073 8832 nil nil nil 5 nil nil nil 8832 1048838 ##(UI.FramingLayout) 170 176 34 4 410 ##(UI.Scintilla.ScintillaView) 34 50 nil 8832 34 2 8 1176572228 1025 8960 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 608 nil 21 4482 nil true 34 13 4530 1 1426 #accept 8 '&Accept' 1 1 nil nil nil 4722 4097 4482 nil true 34 11 4530 1 1426 #undo 8 '&Undo' 1 1 1474 nil true 1520 8 'EditUndo.ico' 1568 nil nil 4722 4097 4530 1 1426 #cutSelection 8 'Cu&t' 1 1 1474 nil true 1520 8 'EditCut.ico' 1568 nil nil 4530 1 1426 #copySelection 8 '&Copy' 1 1 1474 nil true 1520 8 'EditCopy.ico' 1568 nil nil 4530 1 1426 #pasteClipboard 8 '&Paste' 1 1 1474 nil true 1520 8 'EditPaste.ico' 1568 nil nil 4530 1 1426 #clearSelection 8 'De&lete' 1 1 1474 nil true 1520 8 'EditClear.ico' 1568 nil nil 4530 1 1426 #clear 8 'Clea&r' 1 1 1474 nil true 1520 8 'ClearDocument.ico' 1568 nil nil 4722 4097 4530 1 1426 #reformatSource 8 'Re&format' 1 1 nil nil nil 4722 4097 4530 1 1426 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4482 nil true 34 10 4530 1 1426 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 4530 1 1426 #cloneNew 8 '&Clone' 1 1 1474 nil true 1520 8 'SmalltalkWorkspace.ico' 1568 nil nil 4722 4097 4530 1 1426 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4530 1 1426 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4530 1 1426 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4530 1 1426 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 1 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4530 1 1426 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4530 1 1426 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4530 1 1426 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 4722 4097 4530 1 1426 #browseIt 8 'Bro&wse It' 1 1 1474 nil true 1520 8 'ClassBrowserShell.ico' 1568 nil nil 4530 1 1426 #displayIt 8 '&Display It' 1 1 1474 nil true 1520 8 'DisplayIt.ico' 1568 nil nil 4530 1 1426 #printIt 8 '&Print It' 1 1 1474 nil true 1520 8 'PrintIt.ico' 1568 nil nil 4530 1 1426 #evaluateIt 8 'E&valuate It' 1 1 1474 nil true 1520 8 'EvaluateIt.ico' 1568 nil nil 4530 1 1426 #inspectIt 8 '&Inspect It' 1 1 1474 nil true 1520 8 'BasicInspector.ico' 1568 nil nil 4530 1 1426 #debugIt 8 'Deb&ug It' 1 1 1474 nil true 1520 8 'Debugger.ico' 1568 nil nil 4722 4097 4482 nil true 34 3 4530 2097153 1426 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 4530 1 1426 #browseReferences 8 '&References...' 1 1 nil nil nil 4530 1 1426 #browseMessages 8 '&Messages...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 8960 nil 8 2031697384 1049094 ##(UI.NullConverter) nil nil 9 1848884529 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 11234 77 594 #gray 594 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 976 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 8960 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 976 nil 170 176 976 9215 nil nil nil nil 594 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 11200 nil nil nil nil 16 nil 170 192 34 4 #Warning 1772614 3 ##(UI.Scintilla.IndicatorStyle) 17 8960 594 #blue 3 false #Warning nil nil nil nil nil nil #Error 11634 19 8960 594 #red 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 11234 1029 nil 594 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 11234 1027 594 #darkGoldenrod 594 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 11234 1031 594 #firebrick 594 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 770 138 144 34 9 834 #createAt:extent: 34 2 882 21 21 882 833 689 8960 834 #contextMenu: 34 1 9088 8960 834 #caretPeriod: 8 #(530) 8960 834 #wordWrap: 8 #(true) 8960 834 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 8960 1 3 nil nil 5 nil 12130 3 8960 1 nil nil 67108863 5 nil 12130 5 8960 1 nil nil nil 5 nil 8960 834 #canHScroll: 8 #(false) 8960 834 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 8960 834 #maxCompletionListHeight: 8 #(9) 8960 834 #edgeColumn: 8 #(1) 8960 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 10 0 0 0 170 1 0 0 98 1 0 0] 8 #() 992 nil 31 1378374 2 ##(UI.FramingConstraints) 1377286 ##(UI.FramingCalculation) #fixedParentLeft 21 12434 #fixedParentRight -91 12434 #fixedParentTop 21 12434 #fixedParentBottom -19 410 ##(UI.TabViewXP) 34 28 nil 8832 34 2 8 1140916866 1 12512 4402 138 144 976 nil 4464 608 nil 5 nil nil nil 12512 nil 8 1801049728 3234 0 nil 4962 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x key]' 8 #[30 105 17 158 106] #key 12624 7 257 nil 3234 0 nil 4962 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x value icon imageIndex]' 8 #[31 105 17 142 158 159 106] #icon #imageIndex 12704 7 257 nil 4928 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 1 1 882 945 729 12512 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 12512 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 216 1 0 0 108 1 0 0] 8 #() 992 nil 27 12402 12448 1 12464 1 12480 1 12496 1 170 192 34 4 8960 8 'scriptText' 12512 8 'scriptNames' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 97 882 965 729 8832 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 34 2 8960 12512 992 nil 27 4082 4258 8 'Prerequisites' nil nil 410 ##(UI.ReferenceView) 34 14 nil 4112 34 2 8 1140850688 131073 13264 nil nil nil 5 nil nil nil 13264 738 ##(Tools.PackageDependencyPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 97 882 965 729 13264 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 976 992 nil 27 4082 4258 8 'Dependents' nil nil 410 ##(UI.ReferenceView) 34 14 nil 4112 34 2 8 1140850688 131073 13536 nil nil nil 5 nil nil nil 13536 738 ##(Tools.PackageDependencyPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 97 882 965 729 13536 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 976 992 nil 27 4082 4258 8 'Comment' nil nil 410 ##(UI.Scintilla.ScintillaView) 34 50 nil 4112 34 2 8 1176572228 1 13808 9026 nil false 9072 nil 466 #commentWorkspace nil 5 4482 nil true 34 12 4530 1 1426 #accept 8 '&Accept' 1 1 nil nil nil 4722 4097 4482 nil true 34 10 4530 1 1426 #undo 8 '&Undo' 1 1 1474 nil true 1520 8 'EditUndo.ico' 1568 nil nil 4722 4097 4530 1 1426 #cutSelection 8 'Cu&t' 1 1 1474 nil true 1520 8 'EditCut.ico' 1568 nil nil 4530 1 1426 #copySelection 8 '&Copy' 1 1 1474 nil true 1520 8 'EditCopy.ico' 1568 nil nil 4530 1 1426 #pasteClipboard 8 '&Paste' 1 1 1474 nil true 1520 8 'EditPaste.ico' 1568 nil nil 4530 1 1426 #clearSelection 8 'De&lete' 1 1 1474 nil true 1520 8 'EditClear.ico' 1568 nil nil 4722 4097 4530 1 1426 #clear 8 'Clea&r' 1 1 1474 nil true 1520 8 'ClearDocument.ico' 1568 nil nil 4722 4097 4530 1 1426 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4722 4097 4530 1 1426 #browseIt 8 'Bro&wse It' 1 1 10496 nil nil 4530 1 1426 #displayIt 8 '&Display It' 1 1 1474 nil true 1520 8 'DisplayIt.ico' 1568 nil nil 4530 1 1426 #printIt 10640 1 1 10656 nil nil 4530 1 1426 #evaluateIt 8 'E&valuate It' 1 1 1474 nil true 1520 8 'EvaluateIt.ico' 1568 nil nil 4530 1 1426 #inspectIt 8 '&Inspect It' 1 1 10816 nil nil 4530 1 1426 #debugIt 10880 1 1 10896 nil nil 4722 4097 4482 nil true 34 2 4530 2097153 1426 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 4530 1 1426 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 13808 594 #seaGreen 8 2031697384 11170 nil nil 9 1848871425 170 192 34 50 #callTip 11234 77 11280 11296 1 nil nil nil nil #callTip nil nil nil #strong1 11234 5 786758 1 ##(Graphics.RGB) 13404229 nil 1 nil nil nil nil #strong1 nil 1401 nil #olistItem 11234 29 15250 11184811 nil 1 nil nil nil nil #olistItem nil nil nil #header1 11234 13 15250 6887587 nil 1 nil nil nil nil #header1 nil 1401 nil #ulistItem 11234 27 15250 11184811 nil 1 nil nil nil nil #ulistItem nil nil nil #strikeOut 11234 33 15250 7768625 15250 20673875 1 nil nil nil nil #strikeOut nil nil nil #indentGuide 11234 75 nil nil 1 nil nil nil nil #indentGuide nil nil nil #code 11234 39 15250 17825793 15250 31317469 1 nil nil nil nil #code nil nil nil #header5 11234 21 15250 6887587 nil 1 nil nil nil nil #header5 nil 1401 nil #code2 11234 41 15250 17825793 15250 31317469 1 nil nil nil nil #code2 nil nil nil #em2 11234 11 15250 26317 nil 9 nil nil nil nil #em2 nil nil nil #strong2 11234 7 15250 13404229 nil 1 nil nil nil nil #strong2 nil 1401 nil #header2 11234 15 15250 6887587 nil 1 nil nil nil nil #header2 nil 1401 nil #header4 11234 19 15250 6887587 nil 1 nil nil nil nil #header4 nil 1401 nil #link 11234 37 15250 22282241 nil 33 nil nil nil nil #link nil nil nil #codeBlock 11234 43 15250 17825793 15250 31317469 1 nil nil nil nil #codeBlock nil nil nil #em1 11234 9 15250 26317 nil 9 nil nil nil nil #em1 nil nil nil #lineBegin 11234 3 nil nil 1 nil nil nil nil #lineBegin nil nil nil #header3 11234 17 15250 6887587 nil 1 nil nil nil nil #header3 nil 1401 nil #horizontalRule 11234 35 15250 11184811 nil 1 nil nil nil nil #horizontalRule nil 1401 nil #blockQuote 11234 31 15250 17825793 nil 1 nil nil nil nil #blockQuote nil nil nil #normal 11234 1 nil 594 #window 1 nil nil nil nil #normal nil nil nil #lineNumber 11234 67 nil nil 1 nil nil nil nil #lineNumber nil nil nil #preChar 11234 25 594 #black 15250 22404573 1 nil nil nil nil #preChar nil 1401 nil #header6 11234 23 15250 6887587 nil 1 nil nil nil nil #header6 nil 1401 nil nil 1507654 1 ##(UI.Scintilla.NullStyler) #normal 170 192 34 2 #default 11394 1 nil nil nil 13808 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 976 nil 170 176 976 nil nil nil nil nil 11456 nil nil 65 nil nil nil 11552 3 170 192 34 4 #markdown 15184 #container 170 192 34 4 #normal 11234 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 11234 77 11280 11296 1 nil nil nil nil #callTip nil nil nil nil nil nil nil 208 nil 170 192 34 4 #Warning 11634 19 13808 11664 3 false #Warning nil nil nil nil nil nil #Error 11634 17 13808 11696 3 false #Error nil nil nil nil nil nil nil nil 170 192 34 6 #Notification 11234 1029 nil 11760 1 nil nil nil nil #Notification nil nil nil #Warning 11234 1027 11792 11808 1 nil nil nil nil #Warning nil nil nil #Error 11234 1031 11840 11856 1 nil nil nil nil #Error nil nil nil nil 770 138 144 34 12 834 #createAt:extent: 34 2 882 9 97 882 965 729 13808 834 #contextMenu: 34 1 13904 13808 834 #isDrawingBuffered: 8 #(false) 13808 834 #caretPeriod: 8 #(530) 13808 834 #wordWrap: 8 #(true) 13808 834 #margins: 34 1 34 3 12130 1 13808 1 3 nil nil 5 nil 12130 3 13808 1 nil nil 67108863 5 nil 12130 5 13808 1 nil nil nil 5 nil 13808 834 #targetRange: 34 1 12258 1 -1 3 13808 834 #maxCompletionListHeight: 8 #(9) 13808 834 #edgeColumn: 8 #(1) 13808 834 #setLexerLanguage: 8 #(#markdown) 13808 834 #sciSetTechnology: 8 #(1) 13808 834 #sciSetFontQuality: 8 #(3) 13808 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 8 #() 992 nil 31 4082 4258 8 'Variables' nil nil 410 ##(UI.ListView) 34 45 nil 4112 34 2 8 1140920393 1 17040 4402 138 144 976 nil 4464 608 nil 29 4482 nil true 34 6 4530 1 1426 #addSharedVariable 8 '&Add Uncommitted...' 1 1 nil nil nil 4530 1 1426 #removeVariables 8 '&Remove from Package' 1 1 nil nil nil 4722 4097 4530 2097153 1426 #inspectSharedVariables 8 '&Inspect' 1 1 1474 nil true 1520 8 'BasicInspector.ico' 1568 nil nil 4530 1 1426 #browseVariableReferences 8 'All Re&ferences' 1 1 nil nil nil 4530 1 1426 #browseLocalGlobalReferences 8 '&Local References' 1 1 nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 17040 nil 8 1801282304 ##(UI.BasicListAbstract) 3234 0 nil 4962 4 1 3232 8 'doIt' 8 '[:x | x valueOrNil icon imageIndex]' 8 #[32 105 226 0 159 160 106] #valueOrNil #icon #imageIndex 17488 7 257 nil 4928 nil nil nil 882 65 65 nil nil 138 144 34 5 5090 8 '' 41 #left 3234 0 nil 4962 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [''Changed''] ifFalse: ['''']]' 8 #[31 105 17 119 29 106 30 106] 8 'Changed' 5232 17648 7 257 nil 3234 0 nil 4962 3 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x :y | x & y not]' 8 #[31 105 233 1 158 177 106] #not #& 17744 7 513 nil 3234 0 nil 4962 6 1 3232 8 'doIt' 8 '[:x | [x asQualifiedReference value isChanged] on: Error do: [:y | false]]' 8 #[33 105 17 252 0 0 0 2 5 0 226 0 142 159 106 47 34 111 59 106 193 106] #asQualifiedReference #isChanged 1442886 2 ##(Kernel.VariableBinding) #Error ##(Core.Error) ##(Smalltalk) 1 #on:do: 17824 3234 0 nil 17840 39 257 nil 7 257 nil nil 17040 3234 0 nil 4962 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | x ifTrue: [Package changedIcon imageIndex]]' 8 #[32 105 17 121 45 159 160 106 60 106] 5440 #changedIcon #imageIndex 17952 7 257 nil 1 nil nil 5090 8 'Name' 301 #left 3186 #unqualifiedName 8 #() 3186 #<= 8 #() nil nil 17040 3234 0 nil 4962 4 1 3232 8 'doIt' 8 '[:x | x valueOrNil icon imageIndex]' 8 #[32 105 226 0 159 160 106] #valueOrNil #icon #imageIndex 18128 7 257 nil 1 nil nil 5090 8 'Namespace' 301 #left 3186 #printString 8 #() 3234 0 nil 4962 4 1 3184 8 'doIt' 8 '[:a :b | a isNil or: [
	b notNil and: [a printString <= b printString]]]' 8 #[32 105 17 223 2 58 106 18 222 6 226 2 226 34 130 106 59 106] #or: #and: #printString 18272 7 513 nil 3234 0 nil 4962 4 1 3232 8 'doIt' 8 '[:each | each bindingOrNil ifNotNil: [:binding | binding environment]]' 8 #[32 105 226 0 100 222 2 70 159 106] #bindingOrNil #environment #ifNotNil: 18352 7 65793 nil nil 17040 nil 1 nil nil 5090 #Package 201 #left ##(UI.BasicListAbstract) 3234 0 nil 4962 2 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:a :b | a name < b name]' 8 #[30 105 17 158 18 158 128 106] #name 18448 7 513 nil 3234 0 nil 4962 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:x | Package manager packageOfVariableNamed: x]' 8 #[32 105 45 159 17 178 106] 5440 #manager #packageOfVariableNamed: 18528 7 257 nil nil 17040 nil 1 nil nil 5090 8 'File Out Name' 2001 #left ##(UI.BasicListAbstract) 3186 #<= 8 #() 3234 0 nil 4962 7 1 3232 8 'doIt' 8 '[:x | | glob |
glob := x valueOrNil.
(glob class conformsToProtocol: #sourceObject) ifTrue: [glob fileOutName] ifFalse: ['''']]' 8 #[35 105 226 0 70 144 30 178 120 226 35 106 34 106] #valueOrNil #sourceObject #conformsToProtocol: #fileOutName #ifTrue:ifFalse: 8 '' 18672 7 65793 nil nil 17040 nil 1 nil nil #report 6064 nil 133221 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 9 97 882 965 729 17040 834 #contextMenu: 34 1 17136 17040 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 48 0 0 0 230 1 0 0 156 1 0 0] 8 #() 992 nil 35 6336 nil nil nil 170 192 34 16 8224 8 'resources' 13264 8 'prerequisites' 4336 8 'classes' 13536 8 'dependents' 17040 8 'variables' 13808 8 'comment' 6336 8 'methods' 8832 8 'scripts' nil 410 ##(UI.TabViewXP) 34 28 nil 4112 34 2 8 1140916736 1 19120 4402 138 144 34 8 13776 4272 6288 8176 17008 8800 13232 13504 nil 4464 nil nil 1 nil nil nil 19120 nil 8 1801049728 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 4928 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 981 833 19120 834 #setSingleSelection: 8 #(3) 19120 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 19120 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 234 1 0 0 160 1 0 0] 8 #() 992 nil 27 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 981 833 4112 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 234 1 0 0 160 1 0 0] 34 9 13808 4336 6336 8224 17040 8832 13264 13536 19120 992 nil 27 5 false 170 192 34 2 4112 8 'ownedCards' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 499 1 882 981 833 3968 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 249 0 0 0 0 0 0 0 227 2 0 0 160 1 0 0] 34 1 4112 992 nil 27 5 false 170 192 34 2 410 ##(UI.ReferenceView) 34 14 nil 3856 34 2 8 1140850688 131073 19872 nil nil nil 7 nil nil nil 19872 738 ##(Tools.PackageSelector) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 489 833 19872 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 244 0 0 0 160 1 0 0] 976 992 nil 27 8 'packages' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1479 833 3856 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 227 2 0 0 160 1 0 0] 34 3 19872 410 ##(UI.Splitter) 34 12 nil 3856 34 2 8 1140850688 1 20272 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 20272 nil 1 #left nil nil nil 882 1 1 882 9 9 nil 20368 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 489 1 882 11 833 20272 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 244 0 0 0 0 0 0 0 249 0 0 0 160 1 0 0] 8 #() 992 nil 27 3968 992 nil 27 992 nil 27 170 192 34 4 528 8 'toolbar' 2944 8 'statusbar' nil 658246 4 ##(UI.MenuBar) nil true 34 10 4482 nil true 34 24 4530 1 1426 #newPackage 8 '&New Package...' 9373 5 1474 nil true 1520 8 'NewPackage.ico' 1568 nil nil 4530 1 1426 #openPackage 8 '&Install Package...' 9375 5 1474 nil true 1520 8 'FileOpen.ico' 1568 nil nil 4530 1 1426 #removePackage 8 '&Uninstall Package' 1 5 nil nil nil 4722 4097 4482 nil true 34 2 4530 2097153 1426 #addClass 8 '&Class...' 1 1 1474 nil true 1520 8 'Behavior.ico' 1568 nil nil 4530 1 1426 #addSharedVariable 8 '&Global...' 1 1 nil nil nil 8 'Add Unco&mmitted' nil 134217729 nil nil 47669 nil nil 4530 1 1426 #chooseDefaultPackage 8 'Set as De&fault Package...' 1 1 nil nil nil 4530 1 1426 #synchronizeFilter 8 '&Goto Folder' 1 1 1474 nil true 1520 8 'GotoFolder.ico' 1568 nil nil 4722 4097 4530 1 1426 #savePackages 8 '&Save Package' 1 1 1474 nil true 1520 8 'FileSave.ico' 1568 nil nil 4530 1 1426 #savePackageChanges 8 'Save Package C&hanges' 1 1 nil nil nil 4530 1 1426 #savePackageAs 8 'Save Package &As...' 1 1 nil nil nil 4722 4097 4530 1 1426 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4530 1 1426 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4722 4097 4530 1 1426 #saveImage 8 'Sa&ve Image' 1 1 1474 nil true 1520 8 'Snapshot.ico' 1568 nil nil 4530 1 1426 #smalltalkExit 8 'E&xit Dolphin' 1 1 1474 nil true 1520 8 'PowerSwitch.ico' 1568 nil nil 4722 4097 4482 nil true 34 1 4530 2097153 1426 #browseTests 8 '&Browse' 1 1 nil nil nil 8 '&Tests' nil 1 1474 nil true 1520 8 'TestRunner.ico' nil nil 47691 nil nil 4482 nil true 34 4 4530 2097153 1426 #deploy 8 '&Deploy Executable...' 13445 1 nil nil nil 4530 1 1426 #browseDeployed 8 'Bro&wse Executable Manifest' 1 1 1474 nil true 1520 8 'EnvironmentBrowserShell.ico' 1568 nil nil 4722 4097 4530 1 1426 #saveBinaryPackage 8 'Deploy &Binary Package...' 1 1 nil nil nil 8 '&Deployment' nil 134217729 1474 nil true 1520 8 'ApplicationDeploymentWizard.ico' 1568 nil 47699 nil nil 4722 4097 4530 1 1426 #inspectPackage 8 'P&roperties' 1 1 1474 nil true 1520 8 'BasicInspector.ico' 1568 nil nil 4722 4097 4530 1 1426 #exit 8 '&Close' 17639 1 10226 $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 47705 nil nil 4482 nil true 34 12 4530 1 1426 #undo 8 '&Undo' 9397 1 1474 nil true 1520 8 'EditUndo.ico' 1568 nil nil 4722 4097 4530 1 1426 #cutSelection 8 'Cu&t' 9393 1 1474 nil true 1520 8 'EditCut.ico' 1568 nil nil 4530 1 1426 #copySelection 8 '&Copy' 9351 1 1474 nil true 1520 8 'EditCopy.ico' 1568 nil nil 4530 1 1426 #pasteClipboard 8 '&Paste' 9389 1 1474 nil true 1520 8 'EditPaste.ico' 1568 nil nil 4530 1 1426 #editDelete 8 '&Delete' 1 1 1474 nil true 1520 8 'EditClear.ico' 1568 nil nil 4722 4097 4530 1 1426 #selectAll 8 'Select &All' 9347 1 nil nil nil 4722 4097 4530 1 1426 #editFind 8 '&Find...' 9357 1 1474 nil true 1520 47 983302 ##(OS.ShellLibrary) nil nil 4530 1 1426 #findNext 8 'Find &Next' 1253 1 1474 nil true 1520 8 'FindNext.ico' 1568 nil nil 4530 1 1426 #findReplace 8 '&Replace...' 9361 1 nil nil nil 8 '&Edit' nil 134217729 nil nil 47725 nil nil 4482 nil true 34 14 4530 1 1426 #browseIt 8 '&Browse It' 9349 1 1474 nil true 1520 8 'ClassBrowserShell.ico' 1568 nil nil 4530 1 1426 #displayIt 8 '&Display It' 9353 1 1474 nil true 1520 8 'DisplayIt.ico' 1568 nil nil 4530 1 1426 #printIt 8 '&Print It' 9377 1 1474 nil true 1520 8 'PrintIt.ico' 1568 nil nil 4530 1 1426 #evaluateIt 8 '&Evaluate It' 9355 1 1474 nil true 1520 8 'EvaluateIt.ico' 1568 nil nil 4530 1 1426 #inspectIt 8 '&Inspect It' 9363 1 1474 nil true 1520 8 'BasicInspector.ico' 1568 nil nil 4530 1 1426 #debugIt 8 'Deb&ug It' 1269 1 1474 nil true 1520 8 'Debugger.ico' 1568 nil nil 4530 1 1426 #fileItIn 8 '&File It In' 1 1 nil nil nil 4722 4097 4530 1 1426 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 4530 1 1426 #browseReferences 8 '&References...' 5367 1 nil nil nil 4722 4097 4530 1 1426 #accept 8 '&Accept' 9383 1 nil nil nil 4722 4097 4482 nil true 34 7 4530 1 1426 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4530 1 1426 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4530 1 1426 #toggleLineEndings 8 'Line &Endings' 1 1 10226 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4530 1 1426 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4530 1 1426 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4530 1 1426 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4530 1 1426 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 '&Options' nil 134217729 1474 nil true 1520 8 'Preferences.ico' 1568 nil 47761 nil nil 8 '&Workspace' nil 134217729 nil nil 47763 nil nil 4482 nil true 34 4 4530 1 1426 #browseLocalMessageDefinitions 8 '&Definitions Of...' 1 1 nil nil nil 4530 1 1426 #browseLocalMessageReferences 8 '&References To...' 1 1 nil nil nil 4722 4097 4530 1 1426 #browseUnimplemented 8 '&Unimplemented Messages' 1 1 nil nil nil 8 '&Browse' nil 134217729 nil nil 47771 nil nil 4482 nil true 34 10 4530 1 1426 #toggleUsingPAX 8 'Use PAX S&ource Format' 1 1 nil nil nil 4530 2097153 1426 #browsePackageSources 8 'Bro&wse PAX Sources' 1 1 nil nil nil 4722 4097 4530 1 1426 #checkOut 8 'Check Out &All' 1 1 nil nil nil 4530 1 1426 #checkOutChanges 8 '&Check Out Changes' 9367 1 nil nil nil 4530 1 1426 #checkIn 8 'Check &In' 9387 1 nil nil nil 4722 4097 4530 1 1426 #savePackageChanges 8 'Save C&hanges' 1 1 1474 nil true 1520 8 'FileSave.ico' 1568 nil nil 4722 4097 4530 1 1426 #resetChangeFlags 8 'Clear Change &Markers' 1 1 nil nil nil 8 'Sou&rce Control' nil 134217729 nil nil 47787 nil nil 4482 nil true 34 10 4530 1 1426 #renameMethod 8 'Re&name Method...' 1 1 nil nil nil 4530 1 1426 #renameMethodReferences 8 'Rename Re&ferences...' 1 1 nil nil nil 4722 4097 4530 1 1426 #safeRemoveMethod 8 'Re&move Method...' 1 1 nil nil nil 4530 1 1426 #removeDuplicateMethods 8 'Remove Dup&licate Methods' 1 1 nil nil nil 4722 4097 4530 1 1426 #addParameter 8 'Add Method &Parameter...' 1 1 nil nil nil 4530 1 1426 #removeParameter 8 'Remo&ve Method Parameter...' 1 1 nil nil nil 4722 4097 4530 1 1426 #moveAllTempsToInnerScope 8 'Move All &Temps To Inner Scope...' 1 5 nil nil nil 8 'Refactorin&gs' #refactoringsMenu 134217729 nil nil 47803 nil nil 4482 nil true 34 3 4530 1 1426 #undoChange 8 '&Undo <1d>' 1 1 1474 nil true 1520 8 'EditUndo.ico' 1568 nil nil 4530 1 1426 #redoChange 8 '&Redo <1d>' 1 1 1474 nil true 1520 8 'EditRedo.ico' 1568 nil nil 4530 1 1426 #clearChangeHistory 8 'Clear Change &History' 1 1 1474 nil true 1520 8 'MethodHistoryErase.ico' 1568 nil nil 8 'H&istory' nil 134217729 nil nil 47811 nil nil 4482 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 47813 nil nil 4482 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 47815 nil nil 4482 nil true 34 15 4530 1 1426 #helpContents 8 '&Contents' 1025 1 1474 nil true 1520 8 'Help.ico' 1568 nil nil 4530 1 1426 #help 8 'On this &Tool' 1249 1 nil nil nil 4530 1 1426 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4722 4097 4530 1 1426 #learnSmalltalk 8 'Learn Smalltalk' 1 1 10226 $\x1F393 nil 594 #orchid 11296 nil nil 1 nil nil nil nil 4722 4097 4530 1 1426 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4530 1 1426 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4530 1 1426 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4722 4097 4530 1 1426 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 1474 nil true 1520 8 '!!APPLICATION' 1568 nil nil 4530 1 1426 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4530 1 1426 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4722 4097 4530 1 1426 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 10226 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 47839 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil 882 771 621 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 1511 1041 416 834 #text: 34 1 8 'Package Browser' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 242 14 0 0 18 2 0 0] 34 3 528 3568 2944 992 nil 27 )!

toolsFolderHelpId
	^10598!

wordWrapComment
	"Answer true if instances of the receiver use comment word wrapping."

	^WordWrapComment!

wordWrapComment: aBoolean
	"Sets the comment word wrapping state for instances of the receiver to aBoolean."

	WordWrapComment := aBoolean! !
!Tools.PackageBrowserShell class categoriesFor: #displayOn:!displaying!public! !
!Tools.PackageBrowserShell class categoriesFor: #icon!constants!public! !
!Tools.PackageBrowserShell class categoriesFor: #initialize!initializing!private! !
!Tools.PackageBrowserShell class categoriesFor: #publishedAspects!public! !
!Tools.PackageBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.PackageBrowserShell class categoriesFor: #toolsFolderHelpId!public! !
!Tools.PackageBrowserShell class categoriesFor: #wordWrapComment!accessing!options!public! !
!Tools.PackageBrowserShell class categoriesFor: #wordWrapComment:!accessing!options!public! !

