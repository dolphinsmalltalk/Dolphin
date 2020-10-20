"Filed out from Dolphin Smalltalk 7"!

Tools.ProfessionalSmalltalkSystem subclass: #'Tools.RefactoringSmalltalkSystem'
	instanceVariableNames: 'isOAD'
	classVariableNames: 'RefactoringSignal'
	imports: #(#{Refactory.Browser})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RefactoringSmalltalkSystem guid: (Core.GUID fromString: '{e3e901a0-a7d5-401c-8230-885e9236d3b4}')!
Tools.RefactoringSmalltalkSystem comment: 'RefactoringSmalltalkSystem extends SmalltalkSystem to support the refactorings available in the Refactoring Browser''s refactoring engine.
'!
!Tools.RefactoringSmalltalkSystem categoriesForClass!MVP-Models!System-Support! !
!Tools.RefactoringSmalltalkSystem methodsFor!

abstractClassVariable: aString in: aClass within: aBrowserEnvironment
	"Implement the 'Abstract Class Variable' class refactoring: 'Performs the create accessors refactoring 
	and then converts all direct variable to use the accessor methods.'"

	self abstractClassVariables: {aClass -> aString} within: aBrowserEnvironment!

abstractClassVariables: aCollectionOfAssociations within: aBrowserEnvironment
	"Invoke the 'Abstract Class Variable' refactoring for each of the {class, class. var. name}
	pairs in the argument. Note that all variables are abstracted as an atomic unit, so if an
	error occurs for one variable then the whole operation is aborted. The operation also
	creates only one undo/redo unit."

	^self
		executeVariableRefactoring: AbstractClassVariableRefactoring
		variables: aCollectionOfAssociations
		within: aBrowserEnvironment!

abstractInstanceVariable: aString in: aClass within: aBrowserEnvironment
	"Implement the 'Abstract Instance Variable' class refactoring: 'Performs the create
	accessors refactoring and then converts all direct variable to use the accessor methods.'"

	self abstractInstanceVariables: {aClass -> aString} within: aBrowserEnvironment!

abstractInstanceVariables: aCollectionOfAssociations within: aBrowserEnvironment
	"Invoke the 'Abstract Instance Variable' refactoring for each of the {class, inst. var.
	name} pairs in the argument. Note that all variables are abstracted as an atomic unit, so if
	an error occurs for one variable then the whole operation is aborted. The operation also
	creates only one undo/redo unit."

	^self
		executeVariableRefactoring: AbstractInstanceVariableRefactoring
		variables: aCollectionOfAssociations
		within: aBrowserEnvironment!

addClassVariable: aString to: aClass
	self
		executeVariableRefactoring: AddClassVariableRefactoring
		variables: {aClass -> aString}
		within: self systemEnvironment!

addClassVariableTo: aClass
	"Implements the Add Class Variable class refactoring."

	| varName |
	varName := self
				promptForClassVarName: ''
				in: aClass
				prompt: 'Please enter a name for the new variable:'
				caption: ('Add Class Variable to <1p>...' expandMacrosWith: aClass).
	varName isNil ifFalse: [self addClassVariable: varName to: aClass]!

addFilteredMethod: aCompiledMethod forLintRule: aLintRule
	| filter |
	filter := BasicLintRule filterFor: aLintRule name.
	filter addClass: aCompiledMethod methodClass selector: aCompiledMethod selector.
	self trigger: #lintRuleFilterChanged: with: aLintRule!

addGlobalVariable: aString
	self changeManager performChange: (Refactory.Browser.DolphinAddGlobalChange addGlobal: aString)!

addInstanceVariable: aString to: aClass
	self
		executeVariableRefactoring: AddInstanceVariableRefactoring
		variables: {aClass -> aString}
		within: self systemEnvironment!

addInstanceVariableTo: aClass
	"Implements the Add Instance Variable class refactoring."

	| varName |
	varName := self
				promptForInstVarName: ''
				in: aClass
				prompt: 'Please enter a name for the new variable:'
				caption: ('Add Instance Variable to <1p>...' expandMacrosWith: aClass).
	varName isNil ifFalse: [self addInstanceVariable: varName to: aClass]!

addParameterName: anRBMethodName initializer: initializer
	^self handleRefactoringException: 
			[| model refactoring |
			model := RBNamespace onEnvironment: anRBMethodName scope.
			refactoring := AddParameterRefactoring
						model: model
						addParameterToMethod: anRBMethodName originalSelector
						in: anRBMethodName methodClass
						newSelector: anRBMethodName selectorSymbol
						initializer: initializer.
			model name: refactoring displayString.
			refactoring
				execute;
				yourself]!

addParameterToMethod: aCompiledMethod 
	^self 
		addParameterToMethod: aCompiledMethod
		inPackages: #()
		caption: 'Add Parameter to <1p>>><2d>...'!

addParameterToMethod: aCompiledMethod inPackages: aCollectionOfPackages caption: aString
	| args argc newName caption suffix newArg selector initializer model refactoring |
	newName := RBScopedMethodName fromMethod: aCompiledMethod.
	args := newName arguments.
	argc := args size.
	suffix := argc + 1.
	
	[newArg := 'arg' , suffix displayString.
	args includes: newArg] whileTrue: [suffix := suffix + 1].
	args addLast: newArg.
	selector := aCompiledMethod selector.
	newName selector: (argc == 0 ifTrue: [selector , ':'] ifFalse: [selector]).
	caption := aString expandMacrosWith: aCompiledMethod methodClass name with: selector.
	newName := ((aCollectionOfPackages isEmpty
				ifTrue: [RenameMethodDialog]
				ifFalse: 
					[newName addScope: (self systemEnvironment forPackages: aCollectionOfPackages) name: #'Package(s)'.
					MethodNameDialog])
					createOn: newName)
				allowParameterReordering: false;
				allowParameterRename: false;
				caption: caption;
				showModal.
	newName isNil ifTrue: [^nil].
	model := RBNamespace onEnvironment: newName scope.
	initializer := 'nil'.

	"Prompt for an initializer until it either passes muster or the user cancels"
	
	[initializer := self
				promptForInitializationExpression: initializer
				in: aCompiledMethod methodClass
				caption: caption.
	(initializer isNil or: [initializer isEmpty]) ifTrue: [^nil].
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: newName originalSelector
				in: newName methodClass
				newSelector: newName selectorSymbol
				initializer: initializer.
	
	[refactoring verifyInitializationExpression.
	true] on: self refactoringError
			do: 
				[:ex |
				| errorString |
				errorString := 'Error in proposed initializer:<n><n><t><1d>' expandMacrosWith: ex.
				MessageBox errorMsg: errorString caption: caption.
				false]]
			whileFalse.
	^self handleRefactoringException: 
			[model name: refactoring displayString.
			refactoring
				execute;
				yourself]!

basicCreateSubclass: aSymbol of: aClass subclasses: aCollection
	"Private - Create a subclass a named subclass of the specified class. Answer the new class.
	Implements the 'Create Subclass' class refactoring: 'This refactoring allows you to insert a
	new class into an existing hierarchy. For example, you can insert a new class between object
	and all of its subclasses by using the refactoring (although I wouldn't recommend it).'"

	| categories |
	categories := aClass isNil ifTrue: [{ClassCategory unclassified}] ifFalse: [aClass categories].
	self handleRefactoringException: 
			[(AddClassRefactoring
				addClass: aSymbol
				superclass: aClass
				subclasses: aCollection
				category: categories first name) execute].
	^aSymbol asQualifiedReference valueOrNil!

browseMethodsIn: aBrowserEnvironment
	| browser |
	browser := super browseMethodsIn: aBrowserEnvironment.
	self isOAD ifTrue: [self extendMethodBrowserMenus: browser].
	^browser!

browseMethodsInEnvironments: aCollectionOfBrowserEnvironment
	| browser |
	browser := super browseMethodsInEnvironments: aCollectionOfBrowserEnvironment.
	self isOAD ifTrue: [self extendMethodBrowserMenus: browser].
	^browser!

browseSelectors: aCollection caption: aString environment: aBrowserEnvironment
	| browser |
	browser := MethodExplorerShell create.
	browser
		caption: aString;
		searchEnvironment: aBrowserEnvironment.
	aCollection
		do: [:each | browser addSearch: (self referencesTo: each in: aBrowserEnvironment) under: nil].
	^browser
		show;
		yourself!

canRefactor
	"Answer whether the receiver is capable of performing refactorings."

	^true!

chooseMethodFromEnvironment: aBrowserEnvironment caption: aString
	^ChoicePrompter
		choices: (aBrowserEnvironment allMethods asSortedCollection: [:a :b | a printString <= b printString])
		caption: aString!

chooseSelectorInEnvironment: aBrowserEnvironment caption: aString
	| selectors |
	selectors := Set new.
	aBrowserEnvironment classesAndSelectorsDo: [:eachClass :eachSelector | selectors add: eachSelector].
	selectors := selectors asSortedCollection.
	^ChoicePrompter choices: selectors caption: aString!

cloneClass: aClass as: newClassName under: superclass in: package
	^self handleRefactoringException: 
			[| newClass |
			(CopyClassRefactoring
				clone: aClass
				as: newClassName
				superclass: superclass) execute.
			newClass := newClassName asQualifiedReference value.
			newClass owningPackage: package.
			newClass]!

convertTemporaryToInstanceVariable: aString in: aClass selector: aSelector
	"Implement the 'Convert to Instance Variable' code refactoring."

	self handleRefactoringException: 
			[(TemporaryToInstanceVariableRefactoring
				class: aClass
				selector: aSelector
				variable: aString) execute]!

convertToSibling: aClass
	"Implement the 'Convert to Sibling' class refactoring: 'Converts a concrete superclass to be
	a sibling of its subclasses. This is accomplished by adding a new class that is a superclass
	of the superclass and its subclasses. This new class will contain all the common methods
	between the superclass and its subclasses. Those methods that have been redefined in the
	subclasses will be defined as #subclassResponsibility methods in the new class."

	(ConvertToSiblingDialog showModalOn: (ChildrenToSiblingsRefactoring
				name: 'Abstract' , aClass name
				class: aClass
				subclasses: aClass subclasses))
		ifNotNil: 
			[:refactoring |
			self handleRefactoringException: 
					[refactoring execute.
					refactoring className asQualifiedReference
						ifDefined: [:newSuperclass | newSuperclass owningPackage: aClass owningPackage]]]!

createInstanceVariableAccessors: aString in: aClass within: aBrowserEnvironment
	"Invoke the 'Create Variable Accessors' refactoring on an instance variable."

	self
		createVariableAccessors: {aClass -> aString}
		classVariables: false
		within: aBrowserEnvironment!

createVariableAccessors: variableNamePairs classVariables: aBoolean within: aBrowserEnvironment
	"Generate get and set accessors for the specified class and variable name pairs."

	| namespace name |
	namespace := RBNamespace onEnvironment: aBrowserEnvironment.
	name := String writeStream.
	name nextPutAll: 'Create accessors for '.
	^self handleRefactoringException: 
			[variableNamePairs do: 
					[:each |
					| aClass variable |
					variable := each value.
					aClass := each key.
					name
						print: aClass;
						nextPut: $.;
						nextPutAll: variable.
					(CreateAccessorsForVariableRefactoring
						model: namespace
						variable: variable
						class: aClass
						classVariable: aBoolean) primitiveExecute]
				separatedBy: [name nextPut: $,].
			namespace name: name contents.
			self changeManager performChange: namespace changes.
			namespace]!

duplicateOf: aCompiledMethod in: superClass
	| superTree superMethod myTree |
	superMethod := superClass compiledMethodAt: aCompiledMethod selector.
	myTree := aCompiledMethod parseTreeNoError.
	superTree := superMethod parseTreeNoError.
	^(myTree notNil and: 
			[superTree notNil and: 
					[(superTree equalTo: myTree exceptForVariables: #()) and: 
							[(aCompiledMethod literals
								reject: [:each | (each isKindOf: BlockClosure) and: [each method == aCompiledMethod]])
									= (superMethod literals
											reject: [:each | (each isKindOf: BlockClosure) and: [each method == superMethod]])
									and: 
										[superMethod isLoose not or: 
												[| package superPackage |
												package := aCompiledMethod owningPackage.
												superPackage := superMethod owningPackage.
												package == superPackage or: [package allPrerequisites includes: superPackage]]]]]])
		ifTrue: [superMethod]!

duplicateSuperclassMethodsOf: aClass
	"Private - Answers the <collection> of <CompiledMethod>s of the superclasses of 
	<Behavior>, aClass, that are duplicated in aClass. I.e., finds the methods of aClass, 
	which are equivalently defined in a superclass (not necessarily the immediate superclass)."

	| supers answer |
	supers := aClass allSuperclasses.
	answer := IdentitySet new.
	supers isEmpty ifTrue: [^answer].
	aClass selectors do: 
			[:each |
			| nearest |
			nearest := supers detect: [:parent | parent includesSelector: each] ifNone: [].
			nearest notNil
				ifTrue: 
					[| eachMethod |
					eachMethod := aClass compiledMethodAt: each.
					answer add: (self duplicateOf: eachMethod in: nearest)]].
	^answer!

executeVariableRefactoring: refactoringClass variables: aCollection within: aBrowserEnvironment
	^self handleRefactoringException: 
			[| namespace refactoring caption |
			namespace := RBNamespace onEnvironment: aBrowserEnvironment.
			caption := String writeStream.
			caption
				nextPutAll: refactoringClass displayPrefix;
				space.
			aCollection do: 
					[:each |
					| class variable |
					variable := each value.
					class := each key.
					caption
						print: class;
						nextPut: $.;
						display: variable.
					refactoring := refactoringClass
								model: namespace
								variable: variable
								class: class.
					namespace name: refactoring displayString.
					refactoring primitiveExecute]
				separatedBy: [caption nextPut: $,].
			namespace name: caption contents.
			self changeManager performChange: namespace changes.
			namespace]!

extendMethodBrowserMenus: browser
	| ctxMenu otherMenu |
	ctxMenu := (browser view viewNamed: 'methodlist') presenterConnectionPoint contextMenu.
	otherMenu := ctxMenu find: 'Browse other'.
	otherMenu
		insertItem: (CommandMenuItem commandDescription: (ClosedCommandDescription
						command: (Message selector: #recompileDiffs)
						description: 'Recompile &diffs'
						queryBlock: [:query | query isEnabled: browser hasMethodSelected]
						receiver: browser))
				yourself
		after: #browseCompilationFailures!

extractMethod: anInterval from: aSymbol in: aBehavior
	"Create a method from the selection of source text in the range identified
	by the <Interval>, anInterval, of the method of the <Behavior>, aBehavior, 
	with <Symbol> selector, aSymbol. The user is prompted for the new method name.

	Implements the 'Extract Method' refactoring: 'Extracts the selected code as a separate 
	method. This refactoring determines what temporary variables are needed in the new method, 
	and prompts for a selector that takes these arguments.'"

	^self handleRefactoringException: 
			[(ExtractMethodRefactoring
				extract: anInterval
				from: aSymbol
				in: aBehavior) execute]!

extractToComponent: anInterval from: aSelector in: aClass
	"Create a component from the selection of source text in the range identified
	by the <Interval>, anInterval, of the method of the <Behavior>, aClass, 
	with <Symbol> selector, aSelector. The user may be prompted to supply additional
	information.
	Implements the 'Extract to Component' refactoring."

	self handleRefactoringException: 
			[(ExtractMethodToComponentRefactoring
				extract: anInterval
				from: aSelector
				in: aClass) execute]!

extractToTemporary: anInterval from: aSelector in: aClass
	"Extract the expression in the range, anInterval, of the source code of the method
	of the class, aClass, with selector, aSelector, to a new temporary with a name
	chosen by the user.
	Implements the 'Extract to Temporary' refactoring."

	| newName method existing |
	method := aClass compiledMethodAt: aSelector.
	existing := method parseTreeNoError ifNil: [#()] ifNotNil: [:ast | ast allDefinedVariables].
	newName := (Prompter
				createOn: ''
				prompt: 'Please enter the name of the new temporary:'
				caption: 'Extract to Temporary...')
				validationBlock: 
						[:name |
						(existing includes: name) not and: 
								[((RBCondition isValidTemporaryVariableName: name for: aClass)
									& (RBCondition definesInstanceVariable: name in: aClass) not) check]];
				showModal.
	newName isNil ifTrue: [^nil].
	^self handleRefactoringException: 
			[(ExtractToTemporaryRefactoring
				extract: anInterval
				to: newName
				from: aSelector
				in: aClass) execute]!

handleRefactoringError: ex
	| text caption |
	text := ex messageText.
	caption := '<1d>...' expandMacrosWith: ex refactoring.
	ex isResumable
		ifTrue: 
			[(MessageBox confirm: (text last == $?
						ifTrue: [ex messageText]
						ifFalse: ['<1s><n><n>Do you want to proceed?' expandMacrosWith: ex messageText])
				caption: caption) ifTrue: [ex resume]]
		ifFalse: 
			[ex hasTag
				ifTrue: [(MessageBox confirm: text caption: caption) ifTrue: [ex tag value]]
				ifFalse: [MessageBox warning: text caption: caption]].
	^ex return!

handleRefactoringException: aBlock
	"Private - Evaluate the refactoring <niladicValuable>, aBlock, trapping any refactoring
	errors it raises and reporting to the user appropriately. If any unhandled error occurs, or
	the refactoring is aborted, then answer nil, otherwise answer the value from the block."

	^aBlock
		on: self refactoringError
		do: [:ex | self handleRefactoringError: ex]
		on: self refactoringAborted
		do: 
			[:ex |
			"Translate to a Notification that will be displayed on Transcript, or in browser status bar"
			Sound warningBeep.
			Notification signal: ex messageText.
			nil]!

inlineAllSelfSendsOf: aCollectionOfMethods within: aBrowserEnvironment
	"Implement the 'Inline all Self Sends' method refactoring (on multiple methods): 'Inlines
	all senders within the class of the method. If there are no more senders after all inlines
	have been performed, then it will remove the method'"

	| namespace caption |
	namespace := RBNamespace onEnvironment: aBrowserEnvironment.
	caption := String writeStream.
	caption nextPutAll: 'Inline self sends of '.
	^self handleRefactoringException: 
			[aCollectionOfMethods do: 
					[:each |
					(InlineAllSendersRefactoring
						model: namespace
						sendersOf: each selector
						in: each methodClass) primitiveExecute.
					caption display: each]
				separatedBy: [caption nextPutAll: ', '].
			namespace name: caption contents.
			self changeManager performChange: namespace changes.
			namespace]!

inlineMessage: anStMessageNode inMethod: aSelector of: aBehavior
	"Inline the message send whose source text is in the <Interval>, anInterval, of the method
	of the <Behavior>, aBehavior, with <Symbol> selector, aSymbol.

	Implements the 'Inline Message' refactoring: 'Inlines a message send. If there are multiple implementors 
	of the message, it will prompt for the implementation that should be inlined.'"

	self handleRefactoringException: 
			[(((anStMessageNode isMessage and: 
					[| receiver |
					receiver := anStMessageNode receiver.
					receiver isSelfVariable or: [receiver isSuperVariable]])
				ifTrue: [InlineMethodRefactoring]
				ifFalse: [InlineMethodFromComponentRefactoring])
					inline: anStMessageNode sourceInterval
					inMethod: aSelector
					forClass: aBehavior) execute]!

inlineParameter: aString from: aSelector in: aClass
	"Implements the 'Inline Parameter' code refactoring: Remove a parameter from the method, and adds 
	an assignment at the beginning of the method. This can only be performed if all senders of the method have 
	the same value for the parameter'"

	^self handleRefactoringException: 
			[(InlineParameterRefactoring
				inlineParameter: aString
				in: aClass
				selector: aSelector)
				execute;
				yourself]!

inlineTemporary: anInterval from: aSelector in: aClass
	"Extract the expression in the range, anInterval, of the source code of the method
	of the class, aClass, with selector, aSelector, to a new temporary with a name
	chosen by the user.
	Implements the 'Inline Temporary' refactoring."

	self handleRefactoringException: 
			[(InlineTemporaryRefactoring
				inline: anInterval
				from: aSelector
				in: aClass) execute]!

isOAD
	"Private - Is this an Object Arts Development version"

	isOAD isNil ifTrue: [isOAD := SessionManager current isOAD].
	^isOAD!

isOAD: aBoolean
	"Private - Set this an Object Arts Development version according to aBoolean"

	isOAD := aBoolean!

isValidClassVarName: aString for: aClass 
	^(RBCondition isValidClassVarName: aString asString for: aClass) check!

isValidInstanceVariableName: aString for: aClass
	^((RBCondition isValidInstanceVariableName: aString for: aClass)
		& (RBCondition hierarchyOf: aClass definesVariable: aString) not
			& (RBCondition isGlobal: aString in: (RBNamespace onEnvironment: self systemEnvironment)) not)
			check!

moveAllTempsToInnerScope: aBrowserEnvironment
	| model errorCount |
	model := RBNamespace onEnvironment: aBrowserEnvironment.
	errorCount := 0.
	
	[model
		allClassesDo: [:eachClass | errorCount := errorCount + (self moveAllTempsToInnerScopeIn: eachClass)]]
			on: self refactoringAborted
			do: [:ex | ^self].
	model name: 'Move All Temps To Inner Scope'.
	errorCount > 0
		ifTrue: 
			[| mb |
			mb := MessageBox new.
			mb buttonStyle: #okCancel.
			mb caption: model name.
			(mb
				warning: ('<1p> non-fatal errors occured while constructing the refactoring. Please see Transcript for further details.<n><n>If you contine with the refactoring then the erroneous methods will be ignored. The Refactoring is undoable.<n><n>Press OK to proceed, or Cancel to abort.'
						expandMacrosWith: errorCount))
					== #cancel ifTrue: [^self]].
	self changeManager performChange: model changes!

moveAllTempsToInnerScopeIn: anRBClass 
	| change allChanges tempChanges errorCount env |
	change := anRBClass model changes.
	allChanges := change changes.
	tempChanges := OrderedCollection new.
	change changes: tempChanges.
	errorCount := 0.
	env := anRBClass model environment.
	anRBClass selectors do: 
			[:eachSelector | 
			(env includesSelector: eachSelector in: anRBClass) 
				ifTrue: 
					[errorCount := errorCount + (self moveAllTempsToInnerScopeIn: anRBClass selector: eachSelector).
					tempChanges notEmpty 
						ifTrue: 
							[allChanges add: tempChanges last.
							tempChanges removeAll]]].
	change changes: allChanges.
	^errorCount!

moveAllTempsToInnerScopeIn: anRBClass selector: aSelector
	| i errorCount notifyError |
	i := 1.
	errorCount := 0.
	notifyError := 
			[:action :description |
			Notification signal: ('Error <1d> <2p>>><3p>: <4s>'
						expandMacrosWith: action
						with: anRBClass
						with: aSelector
						with: description)].
	
	[| nextTemp parseTree temps |
	parseTree := Parser
				parseMethod: (anRBClass sourceCodeFor: aSelector)
				in: anRBClass realClass
				onError: 
					[:message :pos |
					notifyError value: 'parsing' value: message.
					^errorCount + 1].
	temps := parseTree allTemporaryVariableNodes.
	nextTemp := temps at: i ifAbsent: [^errorCount].
	
	[(MoveVariableDefinitionRefactoring
		model: anRBClass model
		bindTight: nextTemp sourceInterval
		in: anRBClass
		selector: aSelector) primitiveExecute]
			on: self refactoringError
			do: 
				[:ex |
				errorCount := errorCount + 1.
				i := i + 1.
				notifyError value: 'refactoring' value: ex description.
				ex return]
			on: self refactoringAborted
			do: 
				[:ex |
				"Most likely temp already bound as tightly as possible - ignore it"
				i := i + 1]]
			repeat!

moveTempToInnerScope: anInterval in: aClass selector: aSelector
	"Implement the 'Move to Inner Scope' code refactoring: 'Moves a temporary variable definition 
	into the tightest scope that contains both the variable assignment and references.'"

	^self handleRefactoringException: 
			[(MoveVariableDefinitionRefactoring
				bindTight: anInterval
				in: aClass
				selector: aSelector) execute]!

moveToComponent: aSelector in: aClass variable: aString
	"Move the method with <Symbol> selector, aSelector, of the <Behavior>, aClass, 
	to another class (or classes) as defined by the variable named, aString.
	Implements the 'Move to Component' refactoring."

	self handleRefactoringException: 
			[(MoveMethodRefactoring
				selector: aSelector
				class: aClass
				variable: aString) execute]!

newCodeRefactoringToolFor: aMethodWorkspace
	^CodeRefactoringTool forPresenter: aMethodWorkspace!

newMethodRefactoringToolFor: aMethodBrowser
	^MethodRefactoringTool forPresenter: aMethodBrowser!

nukeChangeHistory
	super nukeChangeHistory.
	RefactoringManager nuke!

promptForInitializationExpression: aString in: aClass caption: captionString
	| initializer |
	initializer := (Prompter
				createOn: aString
				prompt: 'Enter default value for new parameter:'
				caption: captionString)
				validationBlock: 
						[:source |
						| tree |
						"name ~= nameString and: 
								[(existing includes: name) not 
									and: [(RBCondition isValidTemporaryVariableName: name for: class) check]]"
						tree := Parser parseExpressionNoError: source in: aClass.
						tree notNil and: [tree isValue]];
				showModal.
	^initializer!

promptForMethodName: anRBMethodName caption: aString allowExisting: aBoolean
	^(RenameMethodDialog createOn: anRBMethodName)
		allowParameterRename: false;
		allowExistingSelector: aBoolean;
		caption: aString;
		showModal!

promptForMethodRename: aCompiledMethod caption: aString allowExisting: aBoolean
	^self
		promptForMethodName: (RBScopedMethodName fromMethod: aCompiledMethod)
		caption: aString
		allowExisting: aBoolean!

promptForNewClassName: promptString caption: captionString
	^(Prompter
		createOn: String new
		prompt: promptString
		caption: captionString)
		validationBlock: 
				[:candidateName |
				candidateName notEmpty and: 
						[(ClassBuilder isValidClassName: candidateName)
							and: [(self environment includesKey: candidateName asSymbol) not]]];
		showModal!

protectInstanceVariable: aString in: aClass
	"Implement the 'Protect/Concrete instance variable' class refactoring: 'Converts all variable 
	accessor sends to direct variable references. If the accessor is no longer used then it will be removed.'"

	self handleRefactoringException: 
			[(ProtectInstanceVariableRefactoring variable: aString class: aClass) execute]!

protectInstanceVariables: pairs 
	"Invoke the 'Protect/Concrete Instance Variable' refactoring for each of the 
	class/inst. var. name pairs in the argument."

	pairs do: [:each | self protectInstanceVariable: each value in: each key]!

pullUpClassVariable: aString into: aClass 
	"Implement the 'Pull Up Class Variable' class refactoring."

	^self 
		pullUpClassVariable: aString
		into: aClass
		within: self systemEnvironment!

pullUpClassVariable: aString into: aClass within: aBrowserEnvironment
	"Implement the 'Pull Up Class Variable' class refactoring: 'Move a variable definition
	 up from a subclass.'"

	^self
		executeVariableRefactoring: PullUpClassVariableRefactoring
		variables: {aClass -> aString}
		within: aBrowserEnvironment!

pullUpInstanceVariable: aString into: aClass 
	"Implement the 'Pull Up Instance Variable' class refactoring."

	self 
		pullUpInstanceVariable: aString
		into: aClass
		within: self systemEnvironment!

pullUpInstanceVariable: aString into: aClass within: aBrowserEnvironment
	"Implement the 'Pull Up Instance Variable' class refactoring: 'Move a variable definition
	 from a subclass of the currently selected class into the currently selected class.'"

	^self
		executeVariableRefactoring: PullUpInstanceVariableRefactoring
		variables: {aClass -> aString}
		within: aBrowserEnvironment!

pushDownClassVariable: aString in: aClass 
	"Implement the 'Push Down Class Variable' class refactoring within the scope of the global
	system environment."

	self 
		pushDownClassVariable: aString
		in: aClass
		within: self systemEnvironment!

pushDownClassVariable: aString in: aClass within: aBrowserEnvironment
	"Implement the 'Push Down Class Variable' class refactoring within the scope of the
	specified <BrowserEnvironment>: 'Moves a variable definition from the currently selected
	class to only those subclasses that use the variable (removing the variable if no subclass
	has a reference to the variable). Class variables can be pushed down into at most one
	subclass, otherwise, it would be necessary to split the one class variable into two and
	possibly break the code as a result. The refactoring is only allowed, if the specified
	environment contains no references to the variable."

	^self
		executeVariableRefactoring: PushDownClassVariableRefactoring
		variables: {aClass -> aString}
		within: aBrowserEnvironment!

pushDownInstanceVariable: aString in: aClass 
	"Implement the 'Push Down Instance Variable' class refactoring within the scope of the global
	environment."

	self 
		pushDownInstanceVariable: aString
		in: aClass
		within: self systemEnvironment!

pushDownInstanceVariable: aString in: aClass within: aBrowserEnvironment
	"Implement the 'Push Down Instance Variable' class refactoring: 'Moves a variable definition
	from the currently selected class to only those subclasses that use the variable (removing
	the variable if no subclass has a reference to the variable). This will only be allowed, if
	the selected class contains no references to the variable. As will the other variable
	refactorings, this refactoring will not work with instVarAt:'s."

	^self
		executeVariableRefactoring: PushDownInstanceVariableRefactoring
		variables: {aClass -> aString}
		within: aBrowserEnvironment!

pushDownInstanceVariables: aCollectionOfAssociations 
	"Invoke the 'Push Down Instance Variable' refactoring for each of the 
	{class, inst. var. name} pairs in the argument."

	aCollectionOfAssociations do: [:each | self pushDownInstanceVariable: each value in: each key]!

pushDownMethods: aCollectionOfMethods 
	"Implement the 'Push Down' method refactoring (on multiple methods): 'Pushes a method down
	into all subclasses that don't implement the method. This can only be allowed if the class
	is abstract'"

	^self pushMethods: aCollectionOfMethods up: false!

pushMethods: aCollectionOfMethods up: aBoolean
	"Private - Implement a multi-method push up or push down refactoring as an atomic unit."

	^self handleRefactoringException: 
			[| caption namespace byClass |
			byClass := LookupTable new.
			aCollectionOfMethods
				do: [:each | (byClass at: each methodClass ifAbsentPut: [OrderedCollection new]) add: each selector].
			caption := String writeStream.
			caption
				nextPutAll: 'Push ';
				nextPutAll: (aBoolean ifTrue: ['up'] ifFalse: ['down']);
				space.
			namespace := RBNamespace new.
			(byClass associations asSortedCollection: [:a :b | a key name <= b key name]) do: 
					[:each |
					| selectors class |
					selectors := each value asSortedCollection asArray.
					class := each key.
					selectors do: [:eachSelector | caption print: eachSelector] separatedBy: [caption nextPut: $,].
					caption
						nextPutAll: ' from ';
						print: each key.
					(aBoolean
						ifTrue: 
							[PushUpMethodRefactoring
								model: namespace
								pushUp: selectors
								from: class]
						ifFalse: 
							[PushDownMethodRefactoring
								model: namespace
								pushDown: selectors
								from: class])
							primitiveExecute]
				separatedBy: [caption nextPutAll: ', '].
			namespace name: caption contents.
			self changeManager performChange: namespace changes.
			namespace]!

pushUpMethods: aCollectionOfMethods 
	"Implement the 'Push Up' method refactoring (on multiple methods): 'Pushes a method up into
	the superclass. If the superclass is abstract and already defines the method, then the
	superclass' method will be copied down into the other subclasses (assuming they don't
	already define the method).'"

	^self pushMethods: aCollectionOfMethods up: true!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver into the <CommandQuery>
	argument."

	| cmd |
	cmd := aCommandQuery commandSymbol.
	#refactoringsMenu == cmd 
		ifTrue: 
			[aCommandQuery isEnabled: true.
			^true].
	^super queryCommand: aCommandQuery!

refactoringAborted
	"Private - Answer an <exceptionSelector> which can be used to trap abort signals raised during
	a refactoring operation."

	^Refactoring abortSignal!

refactoringError
	"Private - Answer an <exceptionSelector> which can be used to trap exceptions raised during
	a refactoring operation."

	^RefactoringSignal!

removeClassVariable: aString from: aClass within: aBrowserEnvironment
	self removeClassVariables: {aClass -> aString} within: aBrowserEnvironment!

removeClassVariables: aCollectionOfAssociations within: aBrowserEnvironment
	"Invoke the 'Remove Class Variable' refactoring for each of the {class, var. name} pairs in
	the argument. Note that all variables are removed as an atomic unit, so if one cannot be
	removed the whole operation is aborted. The operation also creates only one undo/redo unit."

	^self
		executeVariableRefactoring: RemoveClassVariableRefactoring
		variables: aCollectionOfAssociations
		within: aBrowserEnvironment!

removeFilteredMethod: aCompiledMethod forLintRule: aLintRule
	| filter |
	filter := BasicLintRule filterFor: aLintRule name.
	filter removeClass: aCompiledMethod methodClass selector: aCompiledMethod selector.
	self trigger: #lintRuleFilterChanged: with: aLintRule!

removeInstanceVariable: aString from: aClass within: aBrowserEnvironment
	^self removeInstanceVariables: {aClass -> aString} within: aBrowserEnvironment!

removeInstanceVariables: aCollectionOfAssociations within: aBrowserEnvironment
	"Invoke the 'Remove Instance Variable' refactoring for each of the {class, inst. var. name}
	pairs in the argument. Note that all variables are removed as an atomic unit, so if one
	cannot be removed the whole operation is aborted. The operation also creates only one
	undo/redo unit."

	^self
		executeVariableRefactoring: RemoveInstanceVariableRefactoring
		variables: aCollectionOfAssociations
		within: aBrowserEnvironment!

removeMethodsDuplicatedInSuperclassOf: aClass
	"Private - Identify all methods of the <Behavior>, aClass, that have an equivalent definition in a superclass,
	list them for the user, and remove them depending on the response. Answers whether there were
	actually any duplicate methods, regardless of whether they were removed."

	| duplicated msg |
	duplicated := self duplicateSuperclassMethodsOf: aClass.
	duplicated isEmpty ifTrue: [^false].
	msg := String smalltalkWriteStream.
	'<1p> duplicates the following methods of its superclass(es):' expandMacrosWithArguments: {aClass}
		on: msg.
	msg cr.
	duplicated := duplicated asSortedCollection: [:a :b | a printString < b printString].
	duplicated do: 
			[:each |
			msg
				crtab;
				print: each].
	msg
		cr;
		cr.
	'Would you like to remove the duplicates from <1p>?' expandMacrosWithArguments: {aClass} on: msg.
	(MessageBox new
		caption: 'Remove Duplicate Methods...';
		isSuppressible: true;
		uniqueId: #removeMethodsDuplicatedInSuperclassOf:;
		confirm: msg contents)
			ifTrue: 
				[self handleRefactoringException: 
						[(RemoveMethodRefactoring removeMethods: (duplicated collect: [:each | each selector]) from: aClass)
							execute]].
	^true!

removeMethodsIn: methodsEnvironment within: searchEnvironment
	MessageBox new
		caption: 'Remove Methods...';
		defaultButton: 2;
		confirm: ('Are you sure you would like to remove <1p>?

Press Yes to remove all methods regardless of whether they are referenced.
Press No to remove only those methods that are unreferenced.
Press Cancel to abort the operation.'
					expandMacrosWith: methodsEnvironment)
			onYes: [self removeMethodsIn: methodsEnvironment]
			onNo: [self safeRemoveMethodsIn: methodsEnvironment within: searchEnvironment]
			onCancel: []!

removeParameter: aString from: aSelector in: aClass environment: aBrowserEnvironment
	"Implements the Remove Parameter refactoring: 'Removes an unused parameter from 
	all implementors of the method, and removes it from the message sends.' The <readableString>,
	aString, identifies the name of the argument which is removed, not the selector keyword.
	Answer the new selector after removal of the parameter."

	^self handleRefactoringException: 
			[| model refactoring |
			model := RBNamespace onEnvironment: aBrowserEnvironment.
			refactoring := RemoveParameterRefactoring
						model: model
						removeParameter: aString
						in: aClass
						selector: aSelector.
			model name: refactoring displayString.
			refactoring
				execute;
				yourself]!

renameClass: aClass to: newClassName
	"Rename aClass to newClassName. Also list all of the methods which reference
	the class. Their source must be modified to include the newClassName."

	self handleRefactoringException: [(RenameClassRefactoring rename: aClass to: newClassName) execute]!

renameClassVariable: aString to: newName in: aClass within: aBrowserEnvironment 
	self 
		renameVariable: aString
		to: newName
		in: aClass
		classVariable: true
		within: aBrowserEnvironment!

renameInstanceVariable: aString to: newName in: aClass within: aBrowserEnvironment 
	self 
		renameVariable: aString
		to: newName
		in: aClass
		classVariable: false
		within: aBrowserEnvironment!

renameMethod: aCompiledMethod
	"Implement the 'Rename' method refactoring: 'Renames all implementors of a method, all senders, 
	and all symbols references. In addition to strict renaming, it also allows you to rearrange the parameters. 
	However, when rearranging the parameters, it cannot permute any symbols that are performed.'
	Answer the new selector, or nil if no rename actually took place."

	| newName |
	newName := self
				promptForMethodRename: aCompiledMethod
				caption: ('Rename <1p> ...' expandMacrosWith: aCompiledMethod)
				allowExisting: false.
	^newName isNil ifFalse: [self renameMethod: aCompiledMethod to: newName]!

renameMethod: aCompiledMethod to: anRBMethodName
	^self handleRefactoringException: 
			[| model refactoring |
			model := RBNamespace onEnvironment: anRBMethodName scope.
			refactoring := RenameMethodRefactoring
						model: model
						renameMethod: aCompiledMethod selector
						in: aCompiledMethod methodClass
						to: anRBMethodName selector
						permutation: anRBMethodName permutation.
			model name: refactoring displayString.
			refactoring
				execute;
				yourself]!

renameMethodReferences: aCompiledMethod
	"Implement the 'Rename' method refactoring: 'Renames all implementors of a method, all senders, 
	and all symbols references. In addition to strict renaming, it also allows you to rearrange the parameters. 
	However, when rearranging the parameters, it cannot permute any symbols that are performed.'
	Answer the new selector, or nil if no rename actually took place."

	| newName |
	newName := self
				promptForMethodRename: aCompiledMethod
				caption: ('Rename References to <1p> ...' expandMacrosWith: aCompiledMethod)
				allowExisting: true.
	^newName notNil ifTrue: [self renameMethodReferences: aCompiledMethod to: newName]!

renameMethodReferences: aCompiledMethod to: anRBMethodName
	^self handleRefactoringException: 
			[| model refactoring |
			model := RBNamespace onEnvironment: anRBMethodName scope.
			refactoring := RenameMethodReferencesRefactoring
						model: model
						renameMethod: aCompiledMethod selector
						in: aCompiledMethod methodClass
						to: anRBMethodName selector
						permutation: anRBMethodName permutation.
			model name: refactoring displayString.
			refactoring
				execute;
				yourself]!

renameTemporary: aStVariableNode to: aString in: aClass selector: aSelector
	"Rename the temporary variable in the range, anInterval, of the source code of the method of
	the class, aClass, with selector, aSelector, to aString, or if aString is nil a new
	temporary variable name chosen by the user. Implements the 'Rename Temporary' refactoring."

	| oldName |
	oldName := aStVariableNode name.
	(aString
		ifNil: 
			[| newName |
			newName := (Prompter
						createOn: oldName
						prompt: ('Please enter the new name for <1p>:' expandMacrosWith: oldName)
						caption: 'Rename Temporary...')
						validationBlock: 
								[:name |
								
								[self
									validateRenameTemp: aStVariableNode
									to: name
									in: aClass.
								true]
										on: RefactoringError
										do: [:ex | ex return: false]];
						showModal.
			newName])
			ifNotNil: 
				[:newName |
				self handleRefactoringException: 
						[(RenameTemporaryRefactoring
							renameTemporaryFrom: aStVariableNode sourceInterval
							to: newName
							in: aClass
							selector: aSelector) execute]]!

renameVariable: aString to: newName in: aClass classVariable: aBoolean within: aBrowserEnvironment
	^self handleRefactoringException: 
			[| refactoringClass env model refactoring |
			"Drop through"
			env := self
						scopeToRenameAccessorsFor: aString
						in: aClass
						classVariable: aBoolean
						within: aBrowserEnvironment.
			refactoringClass := env isNil
						ifTrue: 
							[env := aBrowserEnvironment.
							aBoolean ifTrue: [RenameClassVariableRefactoring] ifFalse: [RenameInstanceVariableRefactoring]]
						ifFalse: 
							[aBoolean
								ifTrue: [RenameClassVariableAndAccessorsRefactoring]
								ifFalse: [Refactory.Browser.RenameInstanceVariableAndAccessorsRefactoring]].
			model := RBNamespace onEnvironment: env.
			refactoring := refactoringClass
						model: model
						rename: aString
						to: newName
						in: aClass.
			model name: refactoring displayString.
			refactoring execute.
			newName]!

safeRemoveClass: aClass
	"Removes aClass from the system using the 'Remove Class' refactoring, which won't remove
	the class if referenced, and which promotes all subclasses."

	| oldClassName |
	oldClassName := aClass fullName.
	(MessageBox new
		uniqueId: [self] method displayString;
		isSuppressible: true;
		caption: 'Safe Remove Class...';
		confirm: ('Remove class <1p>?' expandMacrosWith: oldClassName)) ifFalse: [^false].
	self handleRefactoringException: [(RemoveClassRefactoring classNames: {aClass fullName}) execute].
	^true!

safeRemoveMethod: aCompiledMethod
	"Implement the 'Remove Method' method refactoring."

	self
		safeRemoveSelectors: {aCompiledMethod selector}
		from: aCompiledMethod methodClass
		inEnvironment: self systemEnvironment!

safeRemoveMethods: aCollectionOfCompiledMethods
	self safeRemoveMethods: aCollectionOfCompiledMethods within: self systemEnvironment!

safeRemoveMethods: aCollectionOfCompiledMethods within: aBrowserEnvironment 
	| classes |
	classes := (aCollectionOfCompiledMethods collect: [:each | each methodClass]) asSet.
	classes size = 1 
		ifTrue: 
			[self 
				safeRemoveSelectors: (aCollectionOfCompiledMethods collect: [:each | each selector])
				from: classes anyOne
				inEnvironment: aBrowserEnvironment]
		ifFalse: 
			[self safeRemoveMethodsIn: (aBrowserEnvironment forMethods: aCollectionOfCompiledMethods)
				within: aBrowserEnvironment]!

safeRemoveMethodsIn: methodsEnvironment within: searchEnvironment
	| model errors |
	model := RBNamespace onEnvironment: searchEnvironment.
	model name: 'Safe Remove ' , methodsEnvironment label.
	errors := OrderedCollection new.
	methodsEnvironment classesAndSelectorsDo: 
			[:eachClass :eachSelector |
			
			[(RemoveMethodRefactoring
				model: model
				removeMethods: {eachSelector}
				from: eachClass) primitiveExecute]
					on: self refactoringError
					do: 
						[:ex |
						errors addLast: ex.
						ex return]].
	errors notEmpty
		ifTrue: 
			[| prompt mb |
			prompt := String writeStream.
			prompt
				display: errors size;
				nextPutAll: ' non-fatal error(s) occured while constructing the refactoring:';
				cr.
			errors do: 
					[:each |
					prompt
						crtab;
						nextPutAll: each description readStream nextLine].
			prompt
				cr;
				cr;
				nextPutAll: 'If you contine with the refactoring then the erroneous methods will be ignored. The Refactoring is undoable.';
				cr;
				cr;
				nextPutAll: 'Press OK to proceed, or Cancel to abort'.
			mb := MessageBox new.
			mb buttonStyle: #okCancel.
			mb caption: model name.
			(mb warning: prompt contents) == #cancel ifTrue: [^self]].
	self changeManager performChange: model changes!

safeRemoveSelectors: anArrayOfSelectors from: aClass inEnvironment: aBrowserEnvironment
	| prompt mb |
	mb := MessageBox new.
	mb
		uniqueId: [self] method displayString;
		isSuppressible: true.
	anArrayOfSelectors size = 1
		ifTrue: 
			[mb caption: 'Safe Remove Method...'.
			prompt := 'Remove <1p>>><2p> (if it has no references or is equivalent to the superclass implementation)?'
						expandMacrosWith: aClass
						with: anArrayOfSelectors first]
		ifFalse: 
			[mb caption: 'Safe Remove Methods...'.
			prompt := String smalltalkWriteStream.
			'The following methods of <1p> will be removed if they have no references or are equivalent to the superclass implementation:'
				expandMacrosWithArguments: {aClass}
				on: prompt.
			prompt cr.
			anArrayOfSelectors do: 
					[:each |
					prompt
						crtab;
						print: each].
			prompt
				cr;
				cr;
				nextPutAll: 'Are you sure you want to do this?'.
			prompt := prompt contents].
	(mb confirm: prompt) ifFalse: [^false].
	^self handleRefactoringException: 
			[| model1 refactoring |
			model1 := RBNamespace onEnvironment: aBrowserEnvironment.
			refactoring := RemoveMethodRefactoring
						model: model1
						removeMethods: anArrayOfSelectors
						from: aClass.
			model1 name: refactoring displayString.
			refactoring
				execute;
				yourself]!

scopeToRenameAccessorsFor: aString in: aClass classVariable: aBoolean within: aBrowserEnvironment
	| finder dialog selectors scope |
	finder := CreateAccessorsForVariableRefactoring
				variable: aString
				class: aClass
				classVariable: aBoolean.
	selectors := OrderedCollection new.
	finder findGetterMethod ifNotNil: [:getter | selectors addLast: getter].
	finder findSetterMethod ifNotNil: [:setter | selectors addLast: setter].
	selectors isEmpty ifTrue: [^nil].
	dialog := RenameAccessorsDialog create.
	dialog caption: ('Rename <3s> variable <1p>.<2s> ...'
				expandMacrosWith: aClass
				with: aString
				with: (aBoolean ifTrue: ['class'] ifFalse: ['instance'])).
	dialog selectors: selectors.
	scope := dialog showModal.
	scope isNil ifTrue: [self refactoringAborted signal].
	scope == #Class
		ifTrue: [^aBrowserEnvironment forClasses: {aClass instanceClass. aClass instanceClass class}].
	scope == #Hierarchy ifTrue: [^aBrowserEnvironment forClassHierarchyFrom: aClass].
	scope == #'Package(s)'
		ifTrue: 
			[^aBrowserEnvironment
				forPackages: (selectors collect: [:each | (aClass compiledMethodAt: each) owningPackage])].
	scope == #'Method(s)' ifTrue: [^aBrowserEnvironment forClass: aClass selectors: selectors].
	scope == #Global ifTrue: [^aBrowserEnvironment].
	^nil!

selectTargetVariableOf: aClass parseTree: aStMethodNode
	| variables default classes |
	variables := OrderedCollection new.
	"Method arguments"
	aStMethodNode isNil
		ifFalse: [aStMethodNode argumentNames asSortedCollection do: [:each | variables addLast: nil -> each]].
	classes := aClass withAllSuperclasses.
	"Instance variables"
	classes
		do: [:eachClass | eachClass instVarNames do: [:eachVar | variables addLast: eachClass -> eachVar]].
	"Class variables - excluding system defined"
	classes do: 
			[:eachClass |
			(eachClass classBindingNames reject: [:each | each first = $_]) asSortedCollection
				do: [:eachVar | variables addLast: eachClass -> eachVar]].
	"Non-class Globals referenced in the method"
	aStMethodNode isNil
		ifFalse: 
			[| referencedGlobals |
			referencedGlobals := SortedCollection new.
			Smalltalk allClassesDo: 
					[:each |
					#namespaceToDo.	"This isn't adequate - we need to collect up all the variables names, then attempt to bind them in the method class to find class refs"
					((aStMethodNode references: each unqualifiedName) or: [aStMethodNode references: each fullName])
						ifTrue: [referencedGlobals add: each fullName]].
			referencedGlobals do: [:each | variables addLast: nil -> each]].
	default := variables notEmpty ifTrue: [variables first].
	^((ChoicePrompter
		createOn: default asValue
		choices: variables
		caption: 'Choose target variable...')
		getTextBlock: [:each | each key ifNil: [each value] ifNotNil: [:eachClass | eachClass name , '.' , each value]];
		showModal) ifNotNil: [:choice | choice value]!

validateRenameClass: aClass to: aString
	| refactoring |
	refactoring := RenameClassRefactoring rename: aClass to: aString.
	refactoring checkPreconditions.
	(aClass hierarchyDefinesVariable: aString)
		ifTrue: 
			[refactoring
				refactoringError: ('<1p> is already defined in hierarchy of <2p>' expandMacrosWith: aString
						with: aClass)]!

validateRenameClassVar: oldString to: newString in: aClass
	(RenameClassVariableRefactoring
		rename: oldString
		to: newString
		in: aClass) checkPreconditions!

validateRenameInstVar: oldString to: newString in: aClass
	| refactoring conditions |
	refactoring := RenameInstanceVariableRefactoring
				rename: oldString
				to: newString
				in: aClass.
	conditions := refactoring preconditions
				& (RBCondition definesTemporaryVariable: newString in: aClass) not.
	refactoring checkPreconditions: conditions!

validateRenameTemp: aStVariableNode to: aString in: aClass
	| refactoring definingNode |
	refactoring := RenameTemporaryRefactoring
				renameTemporaryFrom: aStVariableNode sourceInterval
				to: aString
				in: aClass
				selector: aStVariableNode methodNode selector.
	"Find the scope definining the existing temp"
	definingNode := aStVariableNode whoDefines: aStVariableNode name.
	((definingNode whoDefines: aString) notNil or: [definingNode allDefinedVariables includes: aString])
		ifTrue: [refactoring refactoringError: ('<1p> is already defined' expandMacrosWith: aString)].
	refactoring checkPreconditions! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #abstractClassVariable:in:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #abstractClassVariables:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #abstractInstanceVariable:in:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #abstractInstanceVariables:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addClassVariable:to:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addClassVariableTo:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addFilteredMethod:forLintRule:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addGlobalVariable:!public! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addInstanceVariable:to:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addInstanceVariableTo:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addParameterName:initializer:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addParameterToMethod:!commands!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #addParameterToMethod:inPackages:caption:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #basicCreateSubclass:of:subclasses:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #browseMethodsIn:!browsing!public! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #browseMethodsInEnvironments:!browsing!public! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #browseSelectors:caption:environment:!browsing!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #canRefactor!public!testing! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #chooseMethodFromEnvironment:caption:!public! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #chooseSelectorInEnvironment:caption:!public! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #cloneClass:as:under:in:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #convertTemporaryToInstanceVariable:in:selector:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #convertToSibling:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #createInstanceVariableAccessors:in:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #createVariableAccessors:classVariables:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #duplicateOf:in:!helpers!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #duplicateSuperclassMethodsOf:!enquiries!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #executeVariableRefactoring:variables:within:!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #extendMethodBrowserMenus:!browsing!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #extractMethod:from:in:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #extractToComponent:from:in:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #extractToTemporary:from:in:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #handleRefactoringError:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #handleRefactoringException:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #inlineAllSelfSendsOf:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #inlineMessage:inMethod:of:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #inlineParameter:from:in:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #inlineTemporary:from:in:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #isOAD!accessing!private!product! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #isOAD:!accessing!private!product! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #isValidClassVarName:for:!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #isValidInstanceVariableName:for:!enquiries!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #moveAllTempsToInnerScope:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #moveAllTempsToInnerScopeIn:!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #moveAllTempsToInnerScopeIn:selector:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #moveTempToInnerScope:in:selector:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #moveToComponent:in:variable:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #newCodeRefactoringToolFor:!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #newMethodRefactoringToolFor:!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #nukeChangeHistory!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #promptForInitializationExpression:in:caption:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #promptForMethodName:caption:allowExisting:!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #promptForMethodRename:caption:allowExisting:!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #promptForNewClassName:caption:!helpers!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #protectInstanceVariable:in:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #protectInstanceVariables:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pullUpClassVariable:into:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pullUpClassVariable:into:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pullUpInstanceVariable:into:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pullUpInstanceVariable:into:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pushDownClassVariable:in:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pushDownClassVariable:in:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pushDownInstanceVariable:in:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pushDownInstanceVariable:in:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pushDownInstanceVariables:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pushDownMethods:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pushMethods:up:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #pushUpMethods:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #queryCommand:!commands!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #refactoringAborted!constants!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #refactoringError!constants!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #removeClassVariable:from:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #removeClassVariables:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #removeFilteredMethod:forLintRule:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #removeInstanceVariable:from:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #removeInstanceVariables:within:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #removeMethodsDuplicatedInSuperclassOf:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #removeMethodsIn:within:!commands!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #removeParameter:from:in:environment:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameClass:to:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameClassVariable:to:in:within:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameInstanceVariable:to:in:within:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameMethod:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameMethod:to:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameMethodReferences:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameMethodReferences:to:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameTemporary:to:in:selector:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #renameVariable:to:in:classVariable:within:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #safeRemoveClass:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #safeRemoveMethod:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #safeRemoveMethods:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #safeRemoveMethods:within:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #safeRemoveMethodsIn:within:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #safeRemoveSelectors:from:inEnvironment:!public!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #scopeToRenameAccessorsFor:in:classVariable:within:!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #selectTargetVariableOf:parseTree:!helpers!private!refactoring! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #validateRenameClass:to:!helpers!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #validateRenameClassVar:to:in:!helpers!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #validateRenameInstVar:to:in:!helpers!private! !
!Tools.RefactoringSmalltalkSystem categoriesFor: #validateRenameTemp:to:in:!helpers!private!refactoring! !

!Tools.RefactoringSmalltalkSystem class methodsFor!

initialize
	"Private - Initialize the receiver on load (take over as the development system model)."

	self installCurrent.
	RefactoringSignal := Refactoring preconditionSignal.
	#(#{SmalltalkToolShell} #{ClassSelector} #{PackageSelector})
		do: [:each | each value addCommandQueryHandler: #queryRefactoringCommand:]!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	#(#{SmalltalkToolShell} #{ClassSelector} #{PackageSelector})
		do: [:each | each value removeCommandQueryHandler: #queryRefactoringCommand:].
	MethodCategory removeCategory: '*-RB fixes'.
	self uninstallCurrent! !
!Tools.RefactoringSmalltalkSystem class categoriesFor: #initialize!class hierarchy-removing!private! !
!Tools.RefactoringSmalltalkSystem class categoriesFor: #uninitialize!class hierarchy-removing!private! !

