"Filed out from Dolphin Smalltalk"!

UI.SelectableItemsPresenter
	subclass: #'Tools.ClassSelector'
	instanceVariableNames: 'classesPresenter searchEnvironment'
	classVariableNames: ''
	imports: #(#{Refactory.Browser private} #{XProgramming.SUnit private})
	classInstanceVariableNames: ''
	classConstants: { 'ClassModeMask' -> 16r1. 'ShowFullNamesMask' -> 16r2 }!
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
				owner: self view topView;
				errorMsg: '<1p> is not available for browsing' << class]!

actualClass: aClass ifAbsent: exceptionHandler
	"Sets the actual class selected and determines the current mode."

	| class |
	aClass isNil ifTrue: [^self resetSelection].
	class := aClass instanceClass.
	self isInstanceMode: class == aClass.
	self selection: class ifAbsent: exceptionHandler!

actualClasses
	"Answer the actual classes selected in the receiver after taking account	of instance or class mode. Answer an empty collection if there is no class selected."

	^self isInstanceMode
		ifTrue: [self selections]
		ifFalse: [self selections collect: [:each | each class]]!

browseChangedMethods
	"Browse the changed methods in the selected classes"

	<commandQuery: #hasSelection>
	self developmentSystem browseChangedMethodsOfClasses: self selections!

browseClass
	<commandQuery: #hasSingleSelection>
	self selection browse!

browseClassPackage
	"Open a package browser on the selected class' package."

	<commandQuery: #queryBrowseClassPackage:>
	| pkg |
	pkg := self selection owningPackage.
	pkg isNil ifTrue: [self developmentSystem browsePackages] ifFalse: [pkg browse]!

browseClassReferences
	"Browse all the methods which refer to the class selected in the receiver."

	<commandQuery: #queryBrowseClassReferences:>
	| env references |
	env := self searchEnvironment.
	references := Array writeStream: 2.
	self selections do: 
			[:class |
			references
				nextPut: (env referencesToVariable: class binding);
				nextPut: (env referencesToClass: class)].
	self routeCommand: (CommandDescription
				command: (Message selector: #browseMethodsInEnvironments: argument: references grabContents))!

browseClassVariables
	"Browse one of the class variables of the selected class."

	<commandQuery: #hasSingleSelection>
	self developmentSystem browseClassVariables: self selection!

browseHierarchy
	"Open a new class hierarchy browser on the hierarchy at the same point as the receiver."

	<commandQuery: #queryBrowseHierarchy:>
	self developmentSystem browseHierarchy: self actualClass!

browseInstanceVariables
	"Browse methods in the selected class and its subclasses that reference one of its variables."

	<commandQuery: #hasClassWithInstanceVariables>
	self developmentSystem browseInstanceVariables: self actualClass!

browseItCommand
	"Private - Answer the command that the context-sensitive 'Browse-It' command would be linked
	to if sent to the receiver at this moment."

	classesPresenter hasFocus ifTrue: [^#browseClass].
	^nil!

browseMenu
	<commandQuery: #hasSelection>
	!

browsePackages
	"Implement the context-sensitive browse packages command by browsing to the currently
	selected class' package."

	<commandQuery: #hasSingleSelection>
	self browseClassPackage!

browsePublishedAspects
	"Browse the published aspects for the current class. Copy the choice (if any) to the clipboard."

	<commandQuery: #hasClassWithPublishedAspects>
	| class pubs choice |
	class := self selection.
	pubs := class publishedAspectsOfInstances.
	pubs isEmpty ifTrue: [^MessageBox notify: '<1p> does not publish any aspects.' << class].
	choice := ChoicePrompter choices: pubs asSortedCollection caption: '<1p> published aspects' << class.
	choice notNil ifTrue: [choice name copyToClipboard].
	^choice!

browsePublishedEvents
	"Browse the published events that can be triggered by instances of the current class.
	Copy the chosen symbolic event name (if any) to the clipboard."

	<commandQuery: #hasClassWithPublishedEvents>
	| pubEvents choice class |
	class := self selection.
	pubEvents := class publishedEventsOfInstances asSortedCollection.
	pubEvents isEmpty ifTrue: [^MessageBox notify: '<1p> does not publish any events.' << class].
	choice := ChoicePrompter choices: pubEvents caption: '<1p> published events' << class.
	choice notNil ifTrue: [choice printString copyToClipboard].
	^choice!

browseReferences
	"Context-sensitive browse references command (Shift+F12)."

	<commandQuery: #queryBrowseClassReferences:>
	<acceleratorKey: 'Shift+F12'>
	self browseClassReferences!

browserEnvironment
	"Answer the <BrowserEnvironment> from which the receiver is displaying a list of classes."

	^BrowserEnvironment new!

browseSystem
	"Open a new system browser on at the same point as the receiver."

	<commandQuery: #hasSingleSelection>
	self developmentSystem browseSystem: self actualClass!

browseVariablesMenu
	<commandQuery: #hasSingleSelection>
	<menuPopulator: #buildAllVariablesMenu:>
	!

buildAbstractInstanceVariablesMenu: aMenu
	^self buildInstVarMenu: aMenu selectors: #(#abstractInstanceVariable:in: #abstractInstanceVariables)!

buildAbstractVariablesMenu: aMenu
	^self
		buildVariablesMenu: aMenu
		instVarSelectors: #(#abstractInstanceVariable:in:within: #abstractInstanceVariables)
		classVarSelectors: #(#abstractClassVariable:in:within: #abstractClassVariables)!

buildAllVariablesMenu: aMenu
	"Private - Build a dynamic pull-out menu which lists all of a class' existing 
	instance and class variable names so that one or other can be removed, renamed, 
	etc."

	| class instVars classVars |
	aMenu clear.
	class := self actualClass.
	instVars := OrderedCollection new.
	class
		withAllSuperclassesDo: [:eachClass | eachClass instanceVariableNames do: [:each | instVars add: eachClass -> each]].
	instVars size > self maximumVariableMenuEntries
		ifTrue: [aMenu addCommand: #browseInstanceVariables description: '&Instance Variable…']
		ifFalse: 
			[self
				populateVarMenu: aMenu
				class: class
				command: #browseReferencesToInstVar:inHierarchyOf:within:
				variables: instVars
				format: '<1s>.<2s>'
				abortable: false].
	class := class instanceClass.
	classVars := OrderedCollection new.
	class
		withAllSuperclassesDo: [:eachClass | eachClass classBindingNames do: [:each | classVars add: eachClass -> each]].
	(aMenu notEmpty and: [classVars notEmpty]) ifTrue: [aMenu addSeparator].
	classVars size > self maximumVariableMenuEntries
		ifTrue: [aMenu addCommand: #browseClassVariables description: '&Class Variable…']
		ifFalse: 
			[self
				populateVarMenu: aMenu
				class: class
				command: #browseReferencesToClassVar:of:within:
				variables: classVars
				format: '<1s>.<2s>'
				abortable: false]!

buildCreateInstanceVariableAccessorsMenu: aMenu
	^self buildInstVarMenu: aMenu
		selectors: #(#createInstanceVariableAccessors:in: #createInstanceVariableAccessors)!

buildCreateVariableAccessorsMenu: aMenu
	^self
		buildVariablesMenu: aMenu
		instVarSelectors: #(#createInstanceVariableAccessors:in:within: #createInstanceVariableAccessors)
		classVarSelectors: #(#createClassVariableAccessors:in:within: #createClassVariableAccessors)!

buildProtectInstanceVariablesMenu: aMenu
	^self buildInstVarMenu: aMenu selectors: #(#protectInstanceVariable:in: #protectInstanceVariables)!

buildPushDownVariablesMenu: aMenu
	^self
		buildVariablesMenu: aMenu
		instVarSelectors: #(#pushDownInstanceVariable:in:within: #pushDownInstanceVariables)
		classVarSelectors: #(#pushDownClassVariable:in:within: #pushDownClassVariables)!

buildRemoveVariablesMenu: aMenu
	^self
		buildVariablesMenu: aMenu
		instVarSelectors: #(#removeInstanceVariable:from:within: #removeInstanceVariables)
		classVarSelectors: #(#removeClassVariable:from:within: #removeClassVariables)!

buildRenameVariablesMenu: aMenu
	^self
		buildVariablesMenu: aMenu
		instVarSelectors: #(#renameInstanceVariable:in:within: #renameInstanceVariable)
		classVarSelectors: #(#renameClassVariable:in:within: #renameClassVariable)!

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
	^self developmentSystem canRefactor!

canRenameClass
	^self developmentSystem canRenameClass: self selectionOrNil!

categorizeClass
	"Invokes a dialog to categorize the current class"

	<commandQuery: #hasSingleSelection>
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
	"Note that this is deliberately _not_ part of the 'Dolphin Refactoring Browser' package because it is required by #createVariableAccessors:"

	| varNames class |
	varNames := (aBoolean
				ifTrue: 
					[class := self selection.
					class classBindingNames]
				ifFalse: 
					[class := self actualClass.
					class instanceVariableNames]) asSortedCollection.
	varNames := ChoicePrompter multipleChoices: varNames caption: aString.
	^varNames isNil ifFalse: [varNames collect: [:each | class -> each]]!

classHierarchyPresenter
	^classesPresenter!

classNamesSelector: aSymbol
	classesPresenter view getTextBlock: (Message selector: aSymbol)!

classPackage
	"Prompt for the user to repackage the selected class."

	<commandQuery: #hasDefinedClassSelected>
	| class newPkg oldPkg |
	class := self selection.
	oldPkg := class owningPackage.
	newPkg := PackagePrompter
				showModalOn: oldPkg asValue
				caption: 'Package of <1p>…' << class
				default: nil.
	(newPkg isNil or: [newPkg = oldPkg]) ifFalse: [self confirmMoveClass: class toPackage: newPkg]!

confirmMoveClass: aClass toPackage: aPackage
	"Private - Move aClass from its existing package to the receiver's current package if
	the user agrees."

	| classPackage packMan subclasses mb response |
	packMan := self developmentSystem packageManager.
	classPackage := packMan packageOfClass: aClass.
	subclasses := (aClass allSubclasses
				collect: [:s | Pair first: s second: (packMan packageOfClass: s)])
					select: [:a | a second isNil or: [a second == classPackage]].
	mb := MessageBox new.
	classPackage isNil
		ifTrue: [response := #yes	"Move all subclasses without package too"]
		ifFalse: 
			[| prompt |
			prompt := 'The class <1p> is currently owned by the <2p> package, and will be moved to the <3p> package.'
						<< { aClass. classPackage name. aPackage name }.
			subclasses isEmpty
				ifTrue: 
					[response := mb
								headline: 'Repackage <1p>?' << { aClass. aPackage name };
								customButtons: #(#(#yes '&Repackage') #(#no '&Don''t Repackage'));
								isCancellable: true;
								defaultButton: 2;
								confirm: prompt.
					response ifFalse: [^false]]
				ifFalse: 
					[response := mb
								headline: 'Repackage <1p> and subclasses?' << { aClass. aPackage name };
								customButtons: #(#(#yes '&Repackage All') #(#no 'Repackage Class &Only') #(#cancel '&Don''t Repackage'));
								text: prompt , ('<n><n>Would you like to move its subclasses in <1p>, or without a package, too?'
													<< { classPackage name. aPackage name });
								confirmOrCancel.
					response == #cancel ifTrue: [^false]]].
	packMan addClass: aClass to: aPackage.
	response == #yes
		ifTrue: 
			["Move the subclasses too"
			subclasses do: [:a | packMan addClass: a first to: aPackage]].
	^true!

copyClass
	<commandQuery: #hasSingleSelection>
	(self developmentSystem copyClass: self selection)
		ifNotNil: [:newClass | self actualClass: newClass]!

createInstanceVariableAccessors
	"Prompt to generate compiled 'get' and 'set' accessor methods for each of the immediate
	instance variables of the current class that are not currently endowed with both."

	<commandQuery: #hasClassWithInstanceVariables>
	<menuPopulator: #buildCreateInstanceVariableAccessorsMenu:>
	self createVariableAccessors: false!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	classesPresenter
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
	(self chooseVariables: aBoolean caption: 'Create Accessors for…') 
		ifNotNil: 
			[:varNames | 
			self developmentSystem 
				createVariableAccessors: varNames
				classVariables: aBoolean
				within: self searchEnvironment]!

deleteItCommand
	classesPresenter hasFocus ifTrue: [^#removeClass].
	^super deleteItCommand!

developmentSystem
	^SmalltalkSystem current!

dropClass: aSourceClass onto: aTargetClass changes: aCompositeRefactoryChange
	"Private - Handle the drop of aSourceClass on aTargetClass in the receiver"

	(aSourceClass == aTargetClass or: 
			[aSourceClass superclass == aTargetClass or: 
					[(MessageBox new
						headline: 'Move <1p> to be a subclass of <2p>?' << {aSourceClass. aTargetClass};
						confirm) not]])
		ifTrue: [^self].
	aCompositeRefactoryChange addChange: (MoveClassChange move: aSourceClass toSuperclass: aTargetClass)!

dropMethod: aCompiledMethod onto: aClass isMove: aBoolean changes: aCompositeRefactoryChange
	"Don't copy the method over itself, or over an existing method in the class only at user behest. Answer whether the method
	will be compiled in the new class."

	(aClass == aCompiledMethod methodClass or: 
			[(aClass includesSelector: aCompiledMethod selector) and: 
					[| args |
					args := {aCompiledMethod selector. aClass shortName}.
					(MessageBox new
						caption: '<2?Move:Copy> <1p>...' << {aCompiledMethod. aBoolean};
						headline: 'Overwrite <1p> in <2d>?' << args;
						customButtons: #(#(#yes '&Overwrite') #(#no '&Don''t Overwrite'));
						defaultButton: 2;
						iconStyle: #warning;
						confirm: 'The existing <2d>>><1p> method will be replaced.' << args) not]])
		ifTrue: [^false].
	"If the method was not compiled in the same environment as the class from which it was dragged, we preserve that namespace, 
	otherwise we compile it in the target class' namespace"
	aCompositeRefactoryChange addChange: (AddMethodChange
				compile: aCompiledMethod getSource
				in: aClass
				environment: aCompiledMethod customEnvironment
				categories: aCompiledMethod categories
				package: aCompiledMethod owningPackageIfLoose).
	^true!

editView: viewName
	"Open the ViewComposer on an existing view resource belonging to the
	selected class of the specified name."

	self developmentSystem openViewComposerOn: (ResourceIdentifier class: self selection name: viewName)!

fileInClass
	"Files in the selected class via the package that owns it"

	<commandQuery: #hasSingleSelection>
	self developmentSystem classFileIn: self selection!

fileOutClass
	"Files out the selected class via the package that owns it"

	<commandQuery: #hasSingleSelection>
	self developmentSystem classFileOut: self selection!

findClass
	"Prompts for a class name and finds it within the receiver. Will accept wild-
	carded class name from the user."

	(self developmentSystem promptForClassIn: self searchEnvironment)
		ifNotNil: 
			[:class |
			class notNil ifTrue: [self actualClass: class].
			self ensureSelectionVisible]!

flags
	^self subclassResponsibility!

flags: anInteger
	self subclassResponsibility!

hasClassSupportingViews
	| class |
	class := self selectionOrNil.
	^class notNil and: [(class includesBehavior: Presenter) or: [class includesBehavior: View]]!

hasClassWithInstanceVariables
	| class |
	class := self actualClass.
	^class notNil and: [class instanceVariableNames notEmpty]!

hasClassWithPublishedAspects
	| class |
	class := self selectionOrNil.
	^class notNil and: [class respondsTo: #publishedAspectsOfInstances]!

hasClassWithPublishedEvents
	| class |
	class := self selectionOrNil.
	^class notNil and: [class respondsTo: #publishedEventsOfInstances]!

hasClassWithStaticVariables
	| class |
	class := self actualClass.
	^class notNil and: [class instanceClass definedBindings notEmpty]!

hasClassWithVariablesSelected
	| class |
	class := self actualClass.
	^class notNil
		and: [class instanceVariableNames notEmpty or: [class instanceClass classBindingNames notEmpty]]!

hasDefinedClassSelected
	"Answer true if the receiver has exactly one selection"

	| class |
	class := self selectableItems selectionOrNil.
	^class notNil and: [class fullyQualifiedReference isDefined]!

hasViews
	| class |
	class := self selectionOrNil.
	^class notNil and: [class resourceIdentifiers notEmpty]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self flags: 0.
	searchEnvironment := BrowserEnvironment new!

initiateRename
	classesPresenter view editSelectionLabel!

inspectIt
	"Open an inspector on the currently selected class."

	<commandQuery: #hasSingleSelection>
	self selection inspect!

isInstanceMode
	"Answer whether the receiver is in instance mode."

	^self flags noMask: ClassModeMask!

isInstanceMode: aBoolean
	"Set whether the receiver is in instance mode.
	When in instance mode the receiver displays and operates on classes,
	when in class mode it displays and operates on metaclasses. This may or
	may not make any visual difference, but it affects the operation of certain
	commands."

	self isInstanceMode == aBoolean
		ifFalse: 
			[self flags: (self flags mask: ClassModeMask set: aBoolean not).
			self trigger: #modeChanged]!

isShowingFullNames
	"Answer whether the receiver is display full class names (including namespace) in it's class hierarchy tree."

	^self flags allMask: ShowFullNamesMask!

isShowingFullNames: aBoolean
	"Set  whether the receiver is display full class names (including namespace) in it's class hierarchy tree."

	self flags: (self flags mask: ShowFullNamesMask set: aBoolean)!

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

	<commandQuery: #hasClassSupportingViews>
	self developmentSystem openViewComposerOnNewViewFor: self selection!

onAboutToRenameClass: aLabelEditingEvent
	| class env |
	class := aLabelEditingEvent object.
	(self developmentSystem canRenameClass: class) ifFalse: [aLabelEditingEvent cancel: true].
	aLabelEditingEvent text: class fullName.
	class isVisiblyAbstract
		ifTrue: [aLabelEditingEvent font: (self view actualFont copy
						isItalic: true;
						yourself)].
	env := self browserEnvironment.
	(env includesClass: class)
		ifTrue: 
			[(env definesClass: class)
				ifFalse: [aLabelEditingEvent forecolor: ClassBrowserAbstract.LooseMethodColor]]
		ifFalse: 
			[aLabelEditingEvent
				forecolor: (Color windowText fadedBy: ClassBrowserAbstract.GrayedMethodFadeFactor)]!

onClass: aClass renameTo: aString accept: booleanValue
	"The user has initiated a rename of the class, aClass, by editing the label in the class
	tree. Ask the user to confirm the action, and if so queue a deferred action to perform the
	actual rename."

	"Implementation Notes: We don't set the booleanValue holder to true, because the rename may
	not work."

	| prompter |
	(aString isEmpty or: [aClass fullName = aString])
		ifTrue: 
			[booleanValue value: false.
			^self].
	prompter := self developmentSystem confirmRenameClass: aClass to: aString.
	prompter confirm ifFalse: [^self].
	"Queue deferred action as we can't delete the old item now while still in use (causes GPF in TreeView)"
	
	[self
		onRenameClass: aClass
		to: aString
		showChanges: prompter isChecked]
			postToMessageQueue!

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
	changes := CompositeRefactoryChange named: aDragDropSession operation asPhrase.
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
						isMove: isMove
						changes: changes) and: [isMove])
						ifTrue: [changes removeSelector: method selector from: method methodClass]].
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
				ifTrue: [self developmentSystem addClass: dropClass toProtocol: (each format: #MethodProtocol)]].
	aDragDropSession resetOperation.
	self performDropChanges: changes target: dropClass!

onRenameClass: aClass to: aString showChanges: aBoolean
	"The class, aClass, has been renamed by the user to, text, by editing the label
	in the classes presenter and subsequently confirmed. Ask the receiver's
	model to actually rename the class, converting any exception raised to a
	friendlier message box."

	
	[Cursor wait showWhile: 
			[self developmentSystem
				renameClass: aClass
				to: aString
				showChanges: aBoolean]]
			on: Refactoring abortSignal
			do: 
				[:ex |
				"Cancelled by user"
				self topShell statusModel value: ex]
			on: Error
			do: [:e | e okCancel]!

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
	[self developmentSystem changeManager performChange: change]
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
				headline: 'Compilation errors occurred';
				warning: ('<1p> dropped method(s) failed to compile in <2p>.<n><n>Check Transcript for details.'
							expandMacrosWith: errors
							with: aClass)]!

permitSelectionChange
	| proceed |
	proceed := SelectionChangingEvent forSource: self.
	self onSelectionChanging: proceed.
	^proceed value!

populatePushDownInstanceVariableMenu: aMenu
	^self buildInstVarMenu: aMenu selectors: #(#pushDownInstanceVariable:in: #pushDownInstanceVariables)!

populateVarMenu: aMenu class: class command: cmdSelector variables: aCollection format: aString abortable: aBoolean
	"Private - Populate a dynamic menu with commands which send
	the selector, cmdSelector, to the development system model with
	each of the items and the <ClassDescription>, class, as its 
	arguments. The items are used as the descriptions too."

	aCollection do: 
			[:each |
			| msg |
			msg := MessageSend
						receiver: self developmentSystem
						selector: cmdSelector
						arguments: { each value. class. self searchEnvironment }.
			(aMenu addCommand: msg
				description: (aString expandMacrosWithArguments: { each key name. each value }
						locale: Locale smalltalk))
				isModalCommand: true;
				isAbortable: aBoolean]!

populateViewsEditMenu: aMenu
	^self buildViewsMenu: aMenu command: #editView:!

populateViewsShowMenu: aMenu
	^self buildViewsMenu: aMenu command: #showPresenter:!

queryBrowseClassPackage: aCommandQuery
	(self selectionOrNil ifNotNil: [:class | class owningPackage name printString])
		ifNotNil: 
			[:pkg |
			aCommandQuery
				beEnabled;
				expandMenuTextWith: pkg]!

queryBrowseClassReferences: aCommandQuery
	| classes count |
	classes := self selections.
	count := classes size.
	count == 0 ifTrue: [^self].
	aCommandQuery
		beEnabled;
		expandMenuTextWith: (count = 1 ifTrue: [classes single] ifFalse: ['Classes'])!

queryBrowseHierarchy: aCommandQuery
	| class |
	class := self selectionOrNil.
	class isNil ifTrue: [^self].
	aCommandQuery
		isDefault: true;
		beEnabled;
		expandMenuTextWith: class!

queryNewClass: aCommandQuery
	aCommandQuery
		beEnabled;
		expandMenuTextWith: self selectionOrNil!

queryRemoveClass: aCommandQuery
	| classes |
	classes := self selections.
	classes isEmpty ifTrue: [^self].
	aCommandQuery
		beEnabled;
		expandMenuTextWith: (classes size = 1
					ifTrue: [classes single]
					ifFalse: ['<d> classes' << classes size])!

queryShowFullNames: aCommandQuery
	| fullNames |
	fullNames := self isShowingFullNames.
	aCommandQuery
		beEnabled;
		isChecked: fullNames;
		expandMenuTextWith: fullNames!

queryViewsShowMenu: aCommandQuery
	aCommandQuery
		isEnabled: self hasViews;
		isDefault: true!

removeClass
	"Removes the selected class(es) from the system. If refactoring is available, then the 'Remove Class' refactoring is employed."

	<commandQuery: #queryRemoveClass:>
	self permitSelectionChange ifTrue: [self developmentSystem removeClasses: self selections]!

renameClass
	"Private - Initiate in-place label edit for the selected class."

	<commandQuery: #canRenameClass>
	self initiateRename!

renameClassVariable
	"Private - Initiate the rename of a class variable. Note that the view may also implement this 
	command with a dynamic pull-out menu (of the same name)."

	<commandQuery: #hasClassWithStaticVariables>
	| classVar class |
	class := self selection.
	classVar := ChoicePrompter choices: class classBindingNames asSortedCollection
				caption: 'Rename Class Variable…'.
	classVar isNil ifFalse: [self developmentSystem renameClassVariable: classVar in: class]!

renameInstanceVariable
	"Private - Initiate the rename of an instance variable. Note that the view may also implement this 
	command with a dynamic pull-out menu (of the same name)."

	<commandQuery: #hasClassWithInstanceVariables>
	| instVar class |
	class := self actualClass.
	instVar := ChoicePrompter choices: class instanceVariableNames asSortedCollection
				caption: 'Rename Instance Variable…'.
	instVar isNil ifFalse: [self developmentSystem renameInstanceVariable: instVar in: class]!

renameVariables
	<commandQuery: #hasClassWithVariablesSelected>
	<menuPopulator: #buildRenameVariablesMenu:>
	Sound warningBeep!

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
	| classes |
	classes := self selections.
	^self browserEnvironment forClasses: classes , (classes collect: [:each | each class])!

setInitialFocus
	classesPresenter setFocus!

showPresenter: viewName
	"Show the selected presenter class in an existing view resource, of the <readableString> name,
	viewName, belonging to the selected class."

	self selection show: viewName
	!

toggleShowFullNames
	"Private - Enable/disable the display of class full names (i.e. with namespace qualifier) in the class hierarchy view. There is no good reason to do this in the class list, as this already has a Namespace column showing the qualifier."

	<commandQuery: #queryShowFullNames:>
	| fullNames |
	fullNames := self isShowingFullNames not.
	self isShowingFullNames: fullNames.
	self classNamesSelector: (fullNames ifTrue: [#fullName] ifFalse: [#unqualifiedName])!

viewsEditMenu
	<commandQuery: #hasViews>
	<menuPopulator: #populateViewsEditMenu:>
	!

viewsMenu
	<commandQuery: #hasClassSupportingViews>
	!

viewsShowMenu
	<commandQuery: #queryViewsShowMenu:>
	<menuPopulator: #populateViewsShowMenu:>
	! !
!Tools.ClassSelector categoriesForMethods!
actualClass!accessing!public! !
actualClass:!accessing!public! !
actualClass:ifAbsent:!accessing!public! !
actualClasses!accessing!public! !
browseChangedMethods!commands-actions!public! !
browseClass!commands-actions!public! !
browseClassPackage!commands-actions!public! !
browseClassReferences!commands-actions!public! !
browseClassVariables!commands-actions!public! !
browseHierarchy!commands-actions!public! !
browseInstanceVariables!commands-actions!public! !
browseItCommand!helpers!private! !
browseMenu!commands-menus!private! !
browsePackages!commands-actions!public! !
browsePublishedAspects!commands-actions!public! !
browsePublishedEvents!commands-actions!public! !
browseReferences!commands-actions!public! !
browserEnvironment!public! !
browseSystem!commands-actions!public! !
browseVariablesMenu!commands-menus!private! !
buildAbstractInstanceVariablesMenu:!public!refactoring! !
buildAbstractVariablesMenu:!public!refactoring! !
buildAllVariablesMenu:!menus!private! !
buildCreateInstanceVariableAccessorsMenu:!public!refactoring! !
buildCreateVariableAccessorsMenu:!public!refactoring! !
buildProtectInstanceVariablesMenu:!public!refactoring! !
buildPushDownVariablesMenu:!public!refactoring! !
buildRemoveVariablesMenu:!public!refactoring! !
buildRenameVariablesMenu:!public!refactoring! !
buildViewsMenu:command:!menus!private! !
canRefactor!public!refactoring!testing! !
canRenameClass!private!testing! !
categorizeClass!commands-actions!public! !
chooseVariables:caption:!helpers!private! !
classHierarchyPresenter!accessing!private! !
classNamesSelector:!accessing!private! !
classPackage!commands-actions!public! !
confirmMoveClass:toPackage:!operations!private! !
copyClass!commands-actions!private! !
createInstanceVariableAccessors!commands-actions!public!refactoring! !
createSchematicWiring!initializing!public! !
createVariableAccessors:!commands-actions!public!refactoring! !
deleteItCommand!commands-mappings!private! !
developmentSystem!commands-actions!private! !
dropClass:onto:changes:!operations!private! !
dropMethod:onto:isMove:changes:!helpers!private! !
editView:!commands-actions!public! !
fileInClass!commands-actions!public! !
fileOutClass!commands-actions!public! !
findClass!commands-actions!public! !
flags!accessing!private! !
flags:!accessing!private! !
hasClassSupportingViews!private!testing! !
hasClassWithInstanceVariables!private!testing! !
hasClassWithPublishedAspects!private!testing! !
hasClassWithPublishedEvents!private!testing! !
hasClassWithStaticVariables!private!testing! !
hasClassWithVariablesSelected!private!testing! !
hasDefinedClassSelected!public!selection! !
hasViews!private!testing! !
initialize!initializing!private! !
initiateRename!helpers!private! !
inspectIt!commands-actions!public! !
isInstanceMode!modes!public! !
isInstanceMode:!modes!public! !
isShowingFullNames!modes!public! !
isShowingFullNames:!modes!public! !
maximumVariableMenuEntries!menus!private! !
model:!accessing!public! !
newView!commands-actions!public! !
onAboutToRenameClass:!event handling!private! !
onClass:renameTo:accept:!event handling!public! !
onDrag:!event handling!private! !
onDragOver:!event handling!private! !
onDropOver:!event handling!private! !
onRenameClass:to:showChanges:!event handling!public! !
onSelectionChanged!event handling!public! !
onSelectionChanging:!event handling!public! !
packages:!accessing!public! !
performDropChanges:target:!helpers!private! !
permitSelectionChange!helpers!private! !
populatePushDownInstanceVariableMenu:!public!refactoring! !
populateVarMenu:class:command:variables:format:abortable:!menus!private! !
populateViewsEditMenu:!public! !
populateViewsShowMenu:!public! !
queryBrowseClassPackage:!commands-queries!private! !
queryBrowseClassReferences:!commands-queries!private! !
queryBrowseHierarchy:!commands-queries!private! !
queryNewClass:!commands-queries!private! !
queryRemoveClass:!commands-queries!private! !
queryShowFullNames:!commands-queries!private! !
queryViewsShowMenu:!commands-queries!private! !
removeClass!commands-actions!public! !
renameClass!commands-actions!private!refactoring! !
renameClassVariable!commands-actions!private!refactoring! !
renameInstanceVariable!commands-actions!private!refactoring! !
renameVariables!commands-actions!private! !
searchEnvironment!commands-actions!private! !
searchEnvironment:!public! !
selectableItems!accessing!private! !
selectionEnvironment!accessing!private! !
setInitialFocus!operations!public! !
showPresenter:!commands-actions!public! !
toggleShowFullNames!commands-actions!private!refactoring! !
viewsEditMenu!commands-actions!public! !
viewsMenu!commands-actions!public! !
viewsShowMenu!commands-actions!public! !
!

