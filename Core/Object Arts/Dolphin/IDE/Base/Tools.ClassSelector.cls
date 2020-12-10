"Filed out from Dolphin Smalltalk 7"!

UI.SelectableItemsPresenter subclass: #'Tools.ClassSelector'
	instanceVariableNames: 'flags classesPresenter searchEnvironment'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: 'commandQueryHandlers'
	classConstants: {
		'ClassModeMask' -> 16r1.
		'ShowFullNamesMask' -> 16r2
	}!
Tools.ClassSelector guid: (Core.GUID fromString: '{cb9d5680-134d-4c0b-9052-ad4536946a49}')!
Tools.ClassSelector isNonInstantiable: true!
Tools.ClassSelector comment: 'A ClassSelector is an abstract class used to implement the common behaviour for selecting a class from the Smalltalk class hierarchy. It also provides the ability to source and sink drag and drop operations. Dropping a class object onto another class in the tree will change the superclass of the dropped class. A drop of a <CompiledMethod> will copy or move the method to the class under the drop, maintaining its existing method categories. Class objects may also be dragged from a ClassHierarchySelector in a variety of formats: as <Class> objects, as <String> definitions, or as a chunk format definitions.

Note that a ClassSelector maintains whether it is in ''''class'''' (actually metaclass) or ''''instance'''' mode. A number of commands and operations supported by the receiver can be applied to either <Metaclass> or <Class> objects, and which is operated on is determined by the selection and the mode. See #actualClass and its references.

Instance Variables:
	flags		<integer>. Various flags.

Class Variables:
	ClassModeMask	<integer>. Masks flags inst. var. to determine if in class mode.'!
!Tools.ClassSelector categoriesForClass!MVP-Presenters! !
!Tools.ClassSelector methodsFor!

actualClass
	"Answer the actual class selected in the receiver after taking account
	of instance or class mode. Answer nil if there is no class selected."

	| selectedClass |
	selectedClass := self selectionOrNil.
	^selectedClass isNil ifFalse: [
		self isInstanceMode
			ifTrue: [selectedClass]
			ifFalse: [selectedClass class]]!

actualClass: class
	"Sets the actual class selected and determines the current mode"

	^self actualClass: class
		ifAbsent: 
			[MessageBox new
				owner: self view;
				errorMsg: class name , ' is not available for browsing']!

actualClass: aClass ifAbsent: exceptionHandler
	"Sets the actual class selected and determines the current mode."

	| class |
	aClass isNil ifTrue: [^self resetSelection].
	class := aClass instanceClass.
	self isInstanceMode: class == aClass.
	self selection: class ifAbsent: exceptionHandler!

browseChangedMethods
	"Browse the changed methods in the selected classes"

	self systemModel browseChangedMethodsOf: self selection!

browseClass
	self selection browse!

browseClassPackage
	"Open a package browser on the selected class' package."
	
	| pkg |
	pkg := self selection owningPackage.
	pkg isNil
		ifTrue: [self systemModel browsePackages]
		ifFalse: [pkg browse]!

browseClassReferences
	"Browse all the methods which refer to the class selected in
	the receiver."

	self systemModel browseClassReferences: self selection in: self searchEnvironment!

browseClassVariables
	"Browse one of the class variables of the selected class."

	self systemModel browseClassVariables: self selection!

browseHierarchy
	"Open a new class hierarchy browser on the hierarchy at the same point as the receiver."

	self systemModel browseHierarchy: self actualClass
!

browseInstanceVariables
	"Browse methods in the selected class and its subclasses that reference one of its variables."

	self systemModel browseInstanceVariables: self actualClass!

browseIt
	"Browse the selected item in the pane with focus."

	self perform: self browseItCommand!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	classesPresenter hasFocus ifTrue: [^#browseClass].
	^nil!

browsePackages
	"Implement the context-sensitive browse packages command by browsing to the currently
	selected class' package."
	
	self browseClassPackage!

browsePublishedAspects
	"Browse the published aspects for the current class. Copy the choice (if any) to the clipboard."

	| class pubs choice |
	class := self selection.
	pubs := class publishedAspectsOfInstances.
	pubs isEmpty ifTrue: [^MessageBox notify: class displayString , ' does not publish any aspects.'].
	choice := ChoicePrompter choices: pubs asSortedCollection caption: class name , ' published aspects'.
	choice notNil ifTrue: [choice name copyToClipboard].
	^choice!

browsePublishedEvents
	"Browse the published events that can be triggered by instances of the current class.
	Copy the chosen symbolic event name (if any) to the clipboard."

	| pubEvents choice class name |
	class := self selection.
	pubEvents := class publishedEventsOfInstances asSortedCollection.
	name := class name.
	pubEvents isEmpty ifTrue: [^MessageBox notify: name , ' does not publish any events.'].
	choice := ChoicePrompter choices: pubEvents caption: name , ' published events'.
	choice notNil ifTrue: [choice printString copyToClipboard].
	^choice!

browseReferences
	"Context-sensitive browse references command (Shift+F12)."

	self browseClassReferences!

browserEnvironment
	"Answer the <BrowserEnvironment> from which the receiver is displaying a list of classes."

	^Refactory.Browser.BrowserEnvironment new!

browseSystem
	"Open a new system browser on at the same point as the receiver."

	self systemModel browseSystem: self actualClass
!

buildAllVariablesMenu: aMenu
	"Private - Build a dynamic pull-out menu which lists all of a class' existing 
	instance and class variable names so that one or other can be removed, renamed, 
	etc."

	| class instVars classVars |
	aMenu clear.
	class := self actualClass.
	instVars := OrderedCollection new.
	class
		withAllSuperclassesDo: [:eachClass | eachClass instVarNames do: [:each | instVars add: eachClass -> each]].
	instVars size > self maximumVariableMenuEntries
		ifTrue: [aMenu addCommand: #browseInstanceVariables description: '&Instance Variable...']
		ifFalse: 
			[self
				populateVarMenu: aMenu
				class: class
				command: #browseReferencesToInstVar:inHierarchyOf:within:
				variables: instVars
				format: '<1s>.<2s>'].
	class := class instanceClass.
	classVars := OrderedCollection new.
	class
		withAllSuperclassesDo: [:eachClass | eachClass classBindingNames do: [:each | classVars add: eachClass -> each]].
	(aMenu notEmpty and: [classVars notEmpty]) ifTrue: [aMenu addSeparator].
	classVars size > self maximumVariableMenuEntries
		ifTrue: [aMenu addCommand: #browseClassVariables description: '&Class Variable...']
		ifFalse: 
			[self
				populateVarMenu: aMenu
				class: class
				command: #browseReferencesToClassVar:of:within:
				variables: classVars
				format: '<1s>.<2s>']!

buildViewsMenu: aMenu command: selector
	"Private - Build a dynamic pull-out menu with all views of the current selection
	as the choices."

	| class |
	aMenu clear.
	class := self selection.
	class resourceIdentifiers asSortedCollection do: 
			[:each |
			| msg |
			msg := MessageSend
						receiver: self
						selector: selector
						argument: each name.
			aMenu addCommand: msg description: each name.
			class defaultView = each name ifTrue: [aMenu setDefault: aMenu items size]]!

canRefactor
	^self systemModel canRefactor!

categorizeClass
	"Invokes a dialog to categorize the current class"

	| chosenCategories aClass originalCategories categories |
	aClass := self selection.
	originalCategories := aClass categories.
	categories := aClass classCategoryClass allClassCategories asSortedCollection.
	chosenCategories := (ChoicePrompter
				create: 'Extensible multi-selection choice prompter'
				on: originalCategories
				multipleChoices: categories
				caption: 'Categorize ' , aClass name)
				newBlock: [:aString | Object classCategoryClass name: aString];
				showModal.
	(chosenCategories notNil and: [(chosenCategories symmetricDifference: originalCategories) notEmpty])
		ifTrue: [aClass categories: chosenCategories]!

chooseVariables: aBoolean caption: aString
	"Note that this is deliberately _not_ part of the 'Dolphin Refactoring Browse' package"

	| varNames class |
	varNames := (aBoolean
				ifTrue: 
					[class := self selection.
					class classBindingNames]
				ifFalse: 
					[class := self actualClass.
					class instVarNames]) asSortedCollection.
	varNames := ChoicePrompter multipleChoices: varNames caption: aString.
	^varNames isNil ifFalse: [varNames collect: [:each | class -> each]]!

classPackage
	"Prompt for the user to repackage the selected class."

	| class newPkg oldPkg |
	class := self selection.
	oldPkg := class owningPackage.
	newPkg := PackagePrompter
				showModalOn: oldPkg asValue
				caption: ('Package of <1p>...' expandMacrosWith: class)
				default: nil
				validationBlock: [:package | package notNil and: [class fullyQualifiedReference isDefined]].
	(newPkg isNil or: [newPkg = oldPkg]) ifFalse: [self queryMoveClass: class toPackage: newPkg]!

clearSelection
	"Private - Remove the selected object from the system"

	self perform: self deleteItCommand!

copyClass
	(self systemModel copyClass: self selection) ifNotNil: [:newClass | self actualClass: newClass]!

createInstanceVariableAccessors
	"Prompt to generate compiled 'get' and 'set' accessor methods for each of the immediate
	instance variables of the current class that are not currently endowed with both."

	self createVariableAccessors: false!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	(self selectableItems)
		when: #selectionChanged
			send: #onSelectionChanged
			to: self;
		when: #selectionChanging:
			send: #onSelectionChanging:
			to: self;
		when: #actionPerformed
			send: #onActionPerformed
			to: self;
		when: #labelOf:editedTo:accept:
			send: #onClass:renameTo:accept:
			to: self;
		when: #drag:
			send: #onDrag:
			to: self;
		when: #drop:
			send: #onDropOver:
			to: self;
		when: #dragEnter:
			send: #onDragOver:
			to: self;
		when: #dragOver:
			send: #onDragOver:
			to: self;
		when: #aboutToEditLabel:
			send: #onAboutToRenameClass:
			to: self

	"when: #dragCut: send: #onClassCut: to: self;"	"Nothing to do"!

createVariableAccessors: aBoolean 
	(self chooseVariables: aBoolean caption: 'Create Accessors for...') 
		ifNotNil: 
			[:varNames | 
			self systemModel 
				createVariableAccessors: varNames
				classVariables: aBoolean
				within: self searchEnvironment]!

deleteClassHierarchy
	"Private - Removes the selected class and any subclasses from the system, 
	regardless of whether it is referenced from any methods.
	Note: This is a general menu command available whenever a class is selected,
	not just when the class hierarchy presenter has focus."

	self permitSelectionChange 
		ifTrue: [self systemModel deleteClassHierarchy: self selection]!

deleteItCommand
	classesPresenter hasFocus ifTrue: [^#deleteClassHierarchy].
	^nil!

dropClass: aSourceClass onto: aTargetClass changes: aCompositeRefactoryChange
	"Private - Handle the drop of aSourceClass on aTargetClass in the receiver"

	(aSourceClass == aTargetClass or: 
			[aSourceClass superclass == aTargetClass or: 
					[(MessageBox
						confirm: ('Move class <1p> to be subclass of <2p>?' expandMacrosWith: aSourceClass with: aTargetClass))
							not]])
		ifTrue: [^self].
	aCompositeRefactoryChange
		addChange: (Refactory.Browser.DolphinMoveClassChange move: aSourceClass toSuperclass: aTargetClass)!

dropMethod: aCompiledMethod onto: aClass changes: aCompositeRefactoryChange
	"Don't copy the method over itself, or over an existing method in the class only at user behest. Answer whether the method
	will be compiled in the new class."

	(aClass == aCompiledMethod methodClass or: 
			[(aClass includesSelector: aCompiledMethod selector) and: 
					[(MessageBox confirm: ('The selector <1p> already exists in <2p><n><n>Do you wish to overwrite it?'
								expandMacrosWith: aCompiledMethod selector
								with: aClass))
						not]])
		ifTrue: [^false].
	aCompositeRefactoryChange addChange: (aCompositeRefactoryChange addMethodChangeClass
				compile: aCompiledMethod getSource
				in: aClass
				categories: aCompiledMethod categories
				package: aCompiledMethod owningPackageIfLoose).
	^true!

editView: viewName
	"Open the ViewComposer on an existing view resource belonging to the
	selected class of the specified name."

	self systemModel openViewComposerOn: (ResourceIdentifier class: self selection name: viewName)!

fileInClass
	"Files in the selected class via the package that owns it"

	self systemModel classFileIn: self selection!

fileOutClass
	"Files out the selected class via the package that owns it"

	self systemModel classFileOut: self selection
!

findClass
	"Prompts for a class name and finds it within the receiver. Will accept wild-
	carded class name from the user."

	(Smalltalk developmentSystem promptForClassIn: self searchEnvironment)
		ifNotNil: 
			[:class |
			class notNil ifTrue: [self actualClass: class].
			self ensureSelectionVisible]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	flags := 0.
	searchEnvironment := Refactory.Browser.BrowserEnvironment new!

inspectIt
	"Open an inspector on the currently selected class."

	self selection inspect!

isInstanceMode
	"Answer whether the receiver is in instance mode."

	^flags noMask: ClassModeMask!

isInstanceMode: aBoolean
	"Set whether the receiver is in instance mode.
	When in instance mode the receiver displays and operates on classes,
	when in class mode it displays and operates on metaclasses. This may or
	may not make any visual difference, but it affects the operation of certain
	commands."

	self isInstanceMode == aBoolean 
		ifFalse: 
			[flags := flags mask: ClassModeMask set: aBoolean not.
			self trigger: #modeChanged]!

isShowingFullNames
	"Answer whether the receiver is display full class names (including namespace) in it's class hierarchy tree."

	^flags allMask: ShowFullNamesMask!

isShowingFullNames: aBoolean
	"Set  whether the receiver is display full class names (including namespace) in it's class hierarchy tree."

	flags := flags mask: ShowFullNamesMask set: aBoolean!

maximumVariableMenuEntries
	"The maximum number of variables that should be listed in the variable refactoring menus
	before switching over to the use of a <ChoicePrompter>."

	^20!

model: aClassHierarchyModel 
	"Connects the receiver to aClassHierarchyModel."

	super model: aClassHierarchyModel.
	classesPresenter model: aClassHierarchyModel!

newView
	"Open the ViewComposer on an new default view resource for the
	selected class. If there are several possibilities allow the user to select
	the one to edit"

	self systemModel openViewComposerOnNewViewFor: self selection
	!

onAboutToDisplayMenu: aMenu 
	"The pop-up <Menu>, popup, is about to be displayed.
	This is our opportunity to update it, e.g. to add/remove items."

	| menuName |
	super onAboutToDisplayMenu: aMenu.
	menuName := aMenu name.
	menuName == #viewsEditMenu ifTrue: [^self buildViewsMenu: aMenu command: #editView:].
	menuName == #viewsShowMenu ifTrue: [^self buildViewsMenu: aMenu command: #showPresenter:].
	menuName == #browseVariablesMenu ifTrue: [^self buildAllVariablesMenu: aMenu].
	self canRefactor ifTrue: [^self populateRefactoringMenu: aMenu]!

onAboutToRenameClass: aLabelEditingEvent 
	aLabelEditingEvent text: aLabelEditingEvent object fullName!

onClass: aClass renamedTo: text
	"The class, aClass, has been renamed by the user to, text, by editing the label
	in the classes presenter and subsequently confirmed. Ask the receiver's
	model to actually rename the class, converting any exception raised to a
	friendlier message box."

	[Cursor wait showWhile: [self systemModel renameClass: aClass to: text]] on: Error
		do: [:e | e okCancel]!

onClass: aClass renameTo: text accept: booleanValue
	"The user has initiated a rename of the class, aClass, by editing the label in the class
	tree. Ask the user to confirm the action, and if so queue a deferred action to perform the
	actual rename."

	"Implementation Notes: We don't set the booleanValue holder to true, because the rename may
	not work."

	(text isEmpty or: [aClass fullName = text])
		ifTrue: 
			[booleanValue value: false.
			^self].
	(MessageBox confirm: ('Are you sure you would like to rename the class <1s> to <2s>?'
				expandMacrosWith: aClass fullName
				with: text))
		ifTrue: 
			["Queue deferred action as we can't delete the old item now while still in use (causes GPF in TreeView)"
			[self onClass: aClass renamedTo: text] postToMessageQueue]!

onDrag: session
	"Private - A class drag has been started. Populate the <DragDropSession>, 
	session, with the objects to be dragged."

	| dragDropObject dragClass |
	dragClass := session suggestedSource.
	dragDropObject := session newDragObject: dragClass.
	dragDropObject
		format: #Class data: dragClass;
		format: #String data: dragClass definition;
		format: #Chunk data: dragClass definitionChunk.
	session supportedOperations: #(#move #copy).
	session dragObjects: (OrderedCollection with: dragDropObject)!

onDragOver: session
	"Private - The user is dragging over the class hierarchy pane.
	Set the operation of the <DragDropSession>, session,
	that would occur if a drop took place now of the objects in that session."

	"Default the operation to nil to signal that we don't want the drop"

	| dropClass methods |
	session operation: nil.
	session isTargetSameAsSource ifTrue: [^self].
	dropClass := session suggestedTarget.
	dropClass isNil ifTrue: [^self].
	"Note that we don't want to permit a drop of a class' own methods over itself, as if a move they'll get deleted"
	methods := session dragObjects select: [:each | each isFormatAvailable: #CompiledMethod].
	(methods notEmpty and: 
			[methods allSatisfy: [:each | (each format: #CompiledMethod) methodClass instanceClass ~~ dropClass]])
		ifTrue: 
			[session
				supportedOperations: #(#move #copy);
				operation: session intendedOperation.
			^self].
	(session isFormatAvailable: #Class)
		ifTrue: 
			[session operation: #move.
			^self].
	(session isFormatAvailable: #MethodProtocol)
		ifTrue: 
			[session operation: #copy.
			^self]!

onDropOver: aDragDropSession
	"Private - The drag operation described by the <DragDropSession>, session, would like 
	to do a drop over the receiver's class pane."

	"Implementation Note: If the drop fails then we must set the operation to nil in order that 
	the DD session can detect the failure (as this is an event handler the return value is ignored)."

	| dropClass changes isMove |
	dropClass := aDragDropSession suggestedTarget.
	dropClass isNil
		ifTrue: 
			[Sound errorBeep.
			aDragDropSession operation: nil.
			^self].
	changes := Refactory.Browser.CompositeRefactoryChange named: aDragDropSession operation asPhrase.
	isMove := aDragDropSession isMove.
	aDragDropSession dragObjects do: 
			[:each |
			(each isFormatAvailable: #CompiledMethod)
				ifTrue: 
					[| method |
					method := each format: #CompiledMethod.
					"Note that when dropping over a class we keep class methods on the class side."
					((self
						dropMethod: method
						onto: (method isClassMethod ifTrue: [dropClass class] ifFalse: [dropClass])
						changes: changes) and: [isMove])
						ifTrue: [changes removeMethod: method selector from: method methodClass]].
			(each isFormatAvailable: #Class)
				ifTrue: 
					[| class |
					class := each format: #Class.
					isMove
						ifTrue: 
							[self
								dropClass: class
								onto: dropClass
								changes: changes]
						ifFalse: 
							[self
								cloneClass: class
								under: dropClass
								changes: changes]].
			(each isFormatAvailable: #MethodProtocol)
				ifTrue: [self systemModel addClass: dropClass toProtocol: (each format: #MethodProtocol)]].
	aDragDropSession resetOperation.
	self performDropChanges: changes target: Object!

onSelectionChanged
	"Sent by #onSelChange when the receiver's selection has changed.
	The default is to trigger an #selectionChanged event off the presenter"

	self trigger: #selectionChanged.
!

onSelectionChanging: aSelectionChangingEvent
	"Handler to indicate that the receiver's selection is about to change.
	To prevent the proposed change under certain circumstances a handler
	can set the value of aValueHolder to false."

	self trigger: #selectionChanging: with: aSelectionChangingEvent!

onTipTextRequired: tool
	"Private - Tool tip text is required for the <ToolbarItem>, tool."

	| cmd |
	cmd := tool command asSymbol.
	cmd == #clearSelection ifTrue: [^'Delete class ' , self selection name].
	cmd == #browseHierarchy ifTrue: [^'Open Hierarchy Browser on ' , self actualClass name].
	cmd == #browseSystem ifTrue: [^'Open System Browser on ' , self actualClass name].
	^super onTipTextRequired: tool!

packages: aPackageCollection
	"Set the selected packages, if a package selection is maintained."

!

performDropChanges: aCompositeRefactoryChange target: aClass
	| errors change changeCount |
	changeCount := aCompositeRefactoryChange changes size.
	changeCount = 0 ifTrue: [^self].
	change := changeCount = 1
				ifFalse: [aCompositeRefactoryChange]
				ifTrue: [aCompositeRefactoryChange changes first].
	errors := 0.
	[self systemModel changeManager performChange: change]
		on: Error
		do: [:ex | ex okToContinue]
		on: MethodCompileFailed
		do: 
			[:ex |
			errors := errors + 1.
			ex resumeWithStubMethod].
	errors > 0
		ifTrue: 
			[MessageBox new
				uniqueId: [self] method;
				isSuppressible: true;
				warning: ('<1p> dropped method(s) failed to compile in <2p>.<n><n>Check Transcript for details.'
							expandMacrosWith: errors
							with: aClass)]!

permitSelectionChange
	| proceed |
	proceed := SelectionChangingEvent forSource: self.
	self onSelectionChanging: proceed.
	^proceed value!

populateVarMenu: aMenu class: class command: cmdSelector variables: aCollection format: aString
	"Private - Populate a dynamic menu with commands which send
	the selector, cmdSelector, to the development system model with
	each of the items and the <ClassDescription>, class, as its 
	arguments. The items are used as the descriptions too."

	aCollection do: 
			[:each |
			| msg |
			msg := MessageSend
						receiver: self systemModel
						selector: cmdSelector
						arguments: {each value. class. self searchEnvironment}.
			(aMenu addCommand: msg
				description: (aString expandMacrosWithArguments: {each key name. each value} locale: Locale smalltalk))
					isModalCommand: true]!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery> argument."

	| selector class |
	selector := aCommandQuery commandSymbol.
	class := self selectionOrNil.
	#browseIt == selector
		ifTrue: 
			[selector := self browseItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	#clearSelection == selector
		ifTrue: 
			[selector := self deleteItCommand.
			selector isNil
				ifTrue: 
					[aCommandQuery isEnabled: false.
					^true]].
	selector == #browseHierarchy
		ifTrue: 
			[| name |
			class notNil
				ifTrue: 
					[name := class name.
					aCommandQuery
						isDefault: true;
						isEnabled: true]
				ifFalse: 
					[name := 'Class'.
					aCommandQuery isEnabled: false].
			aCommandQuery text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {name}
						locale: Locale smalltalk).
			^true].
	#browseSystem == selector
		ifTrue: 
			[aCommandQuery isEnabled: class notNil.
			^true].
	#browseClassPackage == selector
		ifTrue: 
			[| name pkg |
			(class isNil or: [(pkg := class owningPackage) isNil])
				ifTrue: 
					[aCommandQuery isEnabled: false.
					name := '']
				ifFalse: 
					[aCommandQuery isEnabled: true.
					name := pkg name printString].
			aCommandQuery text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {name}
						locale: Locale smalltalk).
			^true].
	(#(#browseClass #fileInClass #fileOutClass #checkInClass #checkOutClass #categorizeClass #clearSelection #deleteClassHierarchy #renameClass #inspectIt #browseMenu #browseHierarchy #browseReferences #browseClassReferences #browseClassVariables #browseInstanceVariables #browseAllMethods #browsePackages #classPackage #browseChangedMethods #browseVariablesMenu)
		identityIncludes: selector)
			ifTrue: 
				[aCommandQuery isEnabled: class notNil.
				^true].
	#browsePublishedEvents == selector
		ifTrue: 
			[aCommandQuery isEnabled: (class notNil and: [class respondsTo: #publishedEventsOfInstances]).
			^true].
	#browsePublishedAspects == selector
		ifTrue: 
			[aCommandQuery isEnabled: (class notNil and: [class respondsTo: #publishedAspectsOfInstances]).
			^true].
	#viewsMenu == selector
		ifTrue: 
			[aCommandQuery isEnabled: (class notNil
						and: [(class includesBehavior: Presenter) or: [class includesBehavior: View]]).
			^true].
	(#(#viewsEditMenu #viewsShowMenu) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: (class notNil and: [class resourceIdentifiers notEmpty]).
			#viewsShowMenu == selector ifTrue: [aCommandQuery isDefault: true].
			^true].
	(#(#browseInstanceVariables #createInstanceVariableAccessors) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: (class notNil and: [self actualClass instVarNames notEmpty]).
			^true].
	#browseTests == selector
		ifTrue: 
			[aCommandQuery
				isEnabled: (self testBrowserClass notNil and: 
							[class notNil and: 
									["This odd way of testing if the selected class is a kind of TestCase is 
									used to avoid creating a dependency on the SUnit package, so it can 
								be uninstalled if desired."
									class allSuperclasses anySatisfy: [:each | each name = #'XProgramming.SUnit.TestCase']]]).
			^true].
	#toggleShowFullNames == selector
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				isChecked: self isShowingFullNames.
			^true].
	^super queryCommand: aCommandQuery!

queryMoveClass: aClass toPackage: aPackage
	"Private - Move aClass from its existing package to the receivers current package if
	the user agrees."

	| classPackage response packMan subclasses |
	packMan := self systemModel packageManager.
	classPackage := packMan packageOfClass: aClass.
	subclasses := (aClass allSubclasses collect: [:s | {s. packMan packageOfClass: s}])
				select: [:a | a second isNil or: [a second == classPackage]].
	classPackage isNil
		ifTrue: [response := #yes	"Move all subclasses without package too"]
		ifFalse: 
			[| prompt |
			prompt := 'The class <1p> is currently owned by the <2p> package' expandMacrosWith: aClass
						with: classPackage name.
			subclasses isEmpty
				ifTrue: 
					[prompt := '<1s>.<n><n>Are you sure you would like to move it to <2p>?' expandMacrosWith: prompt
								with: aPackage name.
					response := MessageBox new
								caption: 'Moving class to new package...';
								defaultButton: 2;
								confirm: prompt.
					response ifFalse: [^false]]
				ifFalse: 
					[prompt := prompt
								, (', and will be moved to <2p>.

Would you like to move its subclasses in <1p>, or without a package, too?'
										expandMacrosWith: classPackage name
										with: aPackage name).
					(response := MessageBox new confirmOrCancel: prompt) == #cancel ifTrue: [^false]]].
	packMan addClass: aClass to: aPackage.
	response == #yes
		ifTrue: 
			["Move the subclasses too"
			subclasses do: [:a | packMan addClass: a first to: aPackage]].
	^true!

renameClass
	"Private - Initiate in-place label edit for the selected class."

	self selectableItems view editSelectionLabel!

renameClassVariable
	"Private - Initiate the rename of a class variable. Note that the view may also implement this 
	command with a dynamic pull-out menu (of the same name)."

	| classVar class |
	class := self selection.
	classVar := ChoicePrompter choices: class classBindingNames asSortedCollection
				caption: 'Rename Class Variable...'.
	classVar isNil ifFalse: [self systemModel renameClassVariable: classVar in: class]!

renameInstanceVariable
	"Private - Initiate the rename of an instance variable. Note that the view may also implement this 
	command with a dynamic pull-out menu (of the same name)."

	| instVar class |
	class := self actualClass.
	instVar := ChoicePrompter choices: class instVarNames asSortedCollection
				caption: 'Rename Instance Variable...'.
	instVar isNil ifFalse: [self systemModel renameInstanceVariable: instVar in: class]!

searchEnvironment
	^searchEnvironment!

searchEnvironment: aBrowserEnvironment 
	"Set the <BrowserEnvironment> used as the context for searches such as those for references to a class.
	By default this will be 'Smalltalk', which includes the whole system, so all searches will be global."

	searchEnvironment := aBrowserEnvironment!

selectableItems
	"Private - Answer the name of the <selectableItems> component that actually handles the selectable items in the receiver"
	
	^classesPresenter!

selectionEnvironment
	| class |
	class := self selectionOrNil.
	^self browserEnvironment forClasses: {class. class class}!

setInitialFocus
	self selectableItems setFocus!

showPresenter: viewName
	"Show the selected presenter class in an existing view resource, of the <readableString> name,
	viewName, belonging to the selected class."

	self selection show: viewName
	!

sourceControl
	^Package manager sourceControl!

systemModel
	"Private - Answer the development system model."

	^Smalltalk developmentSystem!

testBrowserClass
	^self systemModel testBrowserClass!

toggleShowFullNames
	self isShowingFullNames: self isShowingFullNames not.
	classesPresenter selectableItems view getTextBlock: (Message
				selector: (self isShowingFullNames ifTrue: [#fullName] ifFalse: [#unqualifiedName]))! !
!Tools.ClassSelector categoriesFor: #actualClass!accessing!public! !
!Tools.ClassSelector categoriesFor: #actualClass:!accessing!public! !
!Tools.ClassSelector categoriesFor: #actualClass:ifAbsent:!accessing!public! !
!Tools.ClassSelector categoriesFor: #browseChangedMethods!commands!public! !
!Tools.ClassSelector categoriesFor: #browseClass!commands!public! !
!Tools.ClassSelector categoriesFor: #browseClassPackage!commands!public! !
!Tools.ClassSelector categoriesFor: #browseClassReferences!commands!public! !
!Tools.ClassSelector categoriesFor: #browseClassVariables!commands!public! !
!Tools.ClassSelector categoriesFor: #browseHierarchy!commands!public! !
!Tools.ClassSelector categoriesFor: #browseInstanceVariables!commands!public! !
!Tools.ClassSelector categoriesFor: #browseIt!commands!public! !
!Tools.ClassSelector categoriesFor: #browseItCommand!helpers!private! !
!Tools.ClassSelector categoriesFor: #browsePackages!commands!public! !
!Tools.ClassSelector categoriesFor: #browsePublishedAspects!commands!public! !
!Tools.ClassSelector categoriesFor: #browsePublishedEvents!commands!public! !
!Tools.ClassSelector categoriesFor: #browseReferences!commands!public! !
!Tools.ClassSelector categoriesFor: #browserEnvironment!public! !
!Tools.ClassSelector categoriesFor: #browseSystem!commands!public! !
!Tools.ClassSelector categoriesFor: #buildAllVariablesMenu:!menus!private! !
!Tools.ClassSelector categoriesFor: #buildViewsMenu:command:!menus!private! !
!Tools.ClassSelector categoriesFor: #canRefactor!public!testing! !
!Tools.ClassSelector categoriesFor: #categorizeClass!commands!public! !
!Tools.ClassSelector categoriesFor: #chooseVariables:caption:!commands!private!refactoring! !
!Tools.ClassSelector categoriesFor: #classPackage!commands!public! !
!Tools.ClassSelector categoriesFor: #clearSelection!commands!private! !
!Tools.ClassSelector categoriesFor: #copyClass!commands!private! !
!Tools.ClassSelector categoriesFor: #createInstanceVariableAccessors!commands!public!refactoring! !
!Tools.ClassSelector categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.ClassSelector categoriesFor: #createVariableAccessors:!commands!public!refactoring! !
!Tools.ClassSelector categoriesFor: #deleteClassHierarchy!commands!private! !
!Tools.ClassSelector categoriesFor: #deleteItCommand!helpers!private! !
!Tools.ClassSelector categoriesFor: #dropClass:onto:changes:!operations!private! !
!Tools.ClassSelector categoriesFor: #dropMethod:onto:changes:!helpers!private! !
!Tools.ClassSelector categoriesFor: #editView:!commands!public! !
!Tools.ClassSelector categoriesFor: #fileInClass!commands!public! !
!Tools.ClassSelector categoriesFor: #fileOutClass!commands!public! !
!Tools.ClassSelector categoriesFor: #findClass!commands!public! !
!Tools.ClassSelector categoriesFor: #initialize!initializing!private! !
!Tools.ClassSelector categoriesFor: #inspectIt!commands!public! !
!Tools.ClassSelector categoriesFor: #isInstanceMode!modes!public! !
!Tools.ClassSelector categoriesFor: #isInstanceMode:!modes!public! !
!Tools.ClassSelector categoriesFor: #isShowingFullNames!modes!public! !
!Tools.ClassSelector categoriesFor: #isShowingFullNames:!modes!public! !
!Tools.ClassSelector categoriesFor: #maximumVariableMenuEntries!menus!private! !
!Tools.ClassSelector categoriesFor: #model:!accessing!public! !
!Tools.ClassSelector categoriesFor: #newView!commands!public! !
!Tools.ClassSelector categoriesFor: #onAboutToDisplayMenu:!event handling!menus!public! !
!Tools.ClassSelector categoriesFor: #onAboutToRenameClass:!event handling!private! !
!Tools.ClassSelector categoriesFor: #onClass:renamedTo:!event handling!public! !
!Tools.ClassSelector categoriesFor: #onClass:renameTo:accept:!event handling!public! !
!Tools.ClassSelector categoriesFor: #onDrag:!event handling!private! !
!Tools.ClassSelector categoriesFor: #onDragOver:!event handling!private! !
!Tools.ClassSelector categoriesFor: #onDropOver:!event handling!private! !
!Tools.ClassSelector categoriesFor: #onSelectionChanged!event handling!public! !
!Tools.ClassSelector categoriesFor: #onSelectionChanging:!event handling!public! !
!Tools.ClassSelector categoriesFor: #onTipTextRequired:!event handling!private! !
!Tools.ClassSelector categoriesFor: #packages:!accessing!public! !
!Tools.ClassSelector categoriesFor: #performDropChanges:target:!helpers!private! !
!Tools.ClassSelector categoriesFor: #permitSelectionChange!helpers!private! !
!Tools.ClassSelector categoriesFor: #populateVarMenu:class:command:variables:format:!menus!private! !
!Tools.ClassSelector categoriesFor: #queryCommand:!commands!private! !
!Tools.ClassSelector categoriesFor: #queryMoveClass:toPackage:!operations!private! !
!Tools.ClassSelector categoriesFor: #renameClass!commands!private!refactoring! !
!Tools.ClassSelector categoriesFor: #renameClassVariable!commands!private!refactoring! !
!Tools.ClassSelector categoriesFor: #renameInstanceVariable!commands!private!refactoring! !
!Tools.ClassSelector categoriesFor: #searchEnvironment!commands!private! !
!Tools.ClassSelector categoriesFor: #searchEnvironment:!public! !
!Tools.ClassSelector categoriesFor: #selectableItems!accessing!private! !
!Tools.ClassSelector categoriesFor: #selectionEnvironment!accessing!private! !
!Tools.ClassSelector categoriesFor: #setInitialFocus!operations!public! !
!Tools.ClassSelector categoriesFor: #showPresenter:!commands!public! !
!Tools.ClassSelector categoriesFor: #sourceControl!accessing!private! !
!Tools.ClassSelector categoriesFor: #systemModel!commands!private! !
!Tools.ClassSelector categoriesFor: #testBrowserClass!constants!private! !
!Tools.ClassSelector categoriesFor: #toggleShowFullNames!commands!private!refactoring! !

!Tools.ClassSelector class methodsFor!

getCommandQueryHandlers
	^commandQueryHandlers!

setCommandQueryHandlers: anArray 
	commandQueryHandlers := anArray! !
!Tools.ClassSelector class categoriesFor: #getCommandQueryHandlers!accessing!private! !
!Tools.ClassSelector class categoriesFor: #setCommandQueryHandlers:!accessing!private! !

