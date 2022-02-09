"Filed out from Dolphin Smalltalk"!

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

abortSignal
	"Private - Answer an <exceptionSelector> which can be used to trap abort signals raised during
	a refactoring operation."

	^Refactoring abortSignal!

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
				caption: ('Add Class Variable to <1p>…' expandMacrosWith: aClass).
	varName isNil ifFalse: [self addClassVariable: varName to: aClass]!

addFilteredMethod: aCompiledMethod forLintRule: aLintRule
	| filter |
	filter := BasicLintRule filterFor: aLintRule name.
	filter addClass: aCompiledMethod methodClass selector: aCompiledMethod selector.
	self trigger: #lintRuleFilterChanged: with: aLintRule!

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
				caption: ('Add Instance Variable to <1p>…' expandMacrosWith: aClass).
	varName isNil ifFalse: [self addInstanceVariable: varName to: aClass]!

addParameterToMethod: aCompiledMethod
	^self addParameterToMethod: aCompiledMethod inPackages: #()!

addParameterToMethod: aCompiledMethod inPackages: aCollectionOfPackages
	| args argc newName suffix newArg selector model refactoring |
	newName := ScopedMethodName fromMethod: aCompiledMethod.
	args := newName arguments.
	argc := args size.
	suffix := argc + 1.
	
	[newArg := 'arg' , suffix displayString.
	args includes: newArg] whileTrue: [suffix := suffix + 1].
	args addLast: newArg.
	selector := aCompiledMethod selector.
	newName selector: (argc == 0 ifTrue: [selector , ':'] ifFalse: [selector]).
	newName := ((aCollectionOfPackages isEmpty
				ifTrue: [RenameMethodDialog]
				ifFalse: 
					[newName addScope: (self systemEnvironment forPackages: aCollectionOfPackages) name: #'Package(s)'.
					MethodNameDialog])
					createOn: newName)
				allowParameterReordering: false;
				allowParameterRename: false;
				caption: 'Add Parameter to <1p><2? in Package(s)...>'
							<< {aCompiledMethod selector. aCollectionOfPackages notEmpty};
				showModal.
	newName isNil ifTrue: [^nil].
	model := RBModel onEnvironment: newName scope.
	"Reset the enviornment label to the default rather than one of the abbreviated labels used in the MethodNameDialog."
	model environment label: nil.
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: newName originalSelector
				in: newName methodClass
				newSelector: newName selectorSymbol
				initializer: 'nil'.
	^(self promptForInitializationExpression: refactoring)
		ifNotNil: 
			[self performRefactoring: 
					[model name: refactoring displayString.
					refactoring
						execute;
						yourself]]!

addSharedVariable: aString to: aNamespace
	self changeManager performChange: (AddSharedVariableChange addSharedVariable: aString to: aNamespace )!

basicCreateSubclass: aSymbol of: aClass subclasses: aCollection
	"Private - Create a subclass a named subclass of the specified class. Answer the new class.
	Implements the 'Create Subclass' class refactoring: 'This refactoring allows you to insert a
	new class into an existing hierarchy. For example, you can insert a new class between object
	and all of its subclasses by using the refactoring (although I wouldn't recommend it).'"

	| categories |
	categories := aClass isNil ifTrue: [{ClassCategory unclassified}] ifFalse: [aClass categories].
	self performRefactoring: 
			[(AddClassRefactoring
				addClass: aSymbol
				superclass: aClass
				subclasses: aCollection
				category: categories first name) execute].
	^aSymbol asQualifiedReference valueOrNil!

basicRemoveMethods: aCollectionOfCompiledMethods within: aBrowserEnvironment
	| classes |
	classes := (aCollectionOfCompiledMethods collect: [:each | each methodClass]) asSet.
	classes size = 1
		ifTrue: 
			[self
				safeRemoveSelectors: (aCollectionOfCompiledMethods collect: [:each | each selector])
				from: classes anyOne
				inEnvironment: aBrowserEnvironment]
		ifFalse: 
			[self basicRemoveMethodsIn: (aBrowserEnvironment forMethods: aCollectionOfCompiledMethods)
				within: aBrowserEnvironment]!

basicRemoveMethodsIn: methodsEnvironment within: searchEnvironment
	| model errors confirmed |
	model := RBModel onEnvironment: searchEnvironment.
	model name: 'Safe Remove ' , methodsEnvironment label.
	errors := OrderedCollection new.
	confirmed := Set new.
	methodsEnvironment classesAndSelectorsDo: 
			[:eachClass :eachSelector |
			| refactoring |
			refactoring := RemoveMethodRefactoring
						model: model
						removeMethods: {eachSelector}
						from: eachClass.
			"We don't want to ask the user more than once to confirm that they want to remove a particular referenced selector"
			(confirmed includes: eachSelector)
				ifTrue: [refactoring setOption: #removeReferencedSelector toUse: [true]]
				ifFalse: [confirmed add: eachSelector].
			[refactoring primitiveExecute] on: self refactoringError
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
	^self performRefactoring: 
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

	self performRefactoring: 
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
				name: (aClass environment fullNameFor: 'Abstract' , aClass name)
				class: aClass
				subclasses: aClass subclasses))
		ifNotNil: 
			[:refactoring |
			self performRefactoring: 
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

	^self performRefactoring: 
			[| model name |
			model := RBModel onEnvironment: aBrowserEnvironment.
			name := String writeStream.
			name nextPutAll: 'Create accessors for '.
			variableNamePairs do: 
					[:each |
					| aClass variable |
					variable := each value.
					aClass := each key.
					name
						print: aClass;
						nextPut: $.;
						nextPutAll: variable.
					(CreateAccessorsForVariableRefactoring
						model: model
						variable: variable
						class: aClass
						classVariable: aBoolean) primitiveExecute]
				separatedBy: [name nextPut: $,].
			model name: name contents.
			self changeManager performChange: model changes.
			model]!

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
			nearest := supers detect: [:parent | parent includesSelector: each] ifNone: nil.
			nearest notNil
				ifTrue: 
					[| eachMethod |
					eachMethod := aClass compiledMethodAt: each.
					answer add: (self duplicateOf: eachMethod in: nearest)]].
	^answer!

executeVariableRefactoring: refactoringClass variables: aCollection within: aBrowserEnvironment
	^self performRefactoring: 
			[| namespace refactoring caption |
			namespace := RBModel onEnvironment: aBrowserEnvironment.
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

	^self performRefactoring: 
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

	self performRefactoring: 
			[(ExtractMethodToComponentRefactoring
				extract: anInterval
				from: aSelector
				in: aClass) execute]!

extractToTemporary: anInterval from: aSelector in: aClass
	"Extract the expression in the range, anInterval, of the source code of the method
	of the class, aClass, with selector, aSelector, to a new temporary with a name
	chosen by the user.
	Implements the 'Extract to Temporary' refactoring."

	| newName existing |
	existing := (aClass compiledMethodAt: aSelector) parseTreeNoError
				ifNil: [#()]
				ifNotNil: [:ast | ast allDefinedVariables].
	newName := (Prompter
				createOn: ''
				prompt: 'Please enter the name of the new temporary:'
				caption: 'Extract to Temporary…')
				validater: 
						[:tempName |
						((RBCondition withBlock: [(existing includes: tempName) not]
							errorString: ['<1p> is already in use as a local variable' << tempName])
								& (RBCondition isValidTemporaryVariableName: tempName for: aClass)
								& (RBCondition definesInstanceVariable: tempName in: aClass) not) validate];
				showHintWhenEmpty: false;
				showModal.
	newName isNil ifTrue: [^nil].
	^self performRefactoring: 
			[(ExtractToTemporaryRefactoring
				extract: anInterval
				to: newName
				from: aSelector
				in: aClass) execute]!

handleRefactoringException: aRefactoringException
	| text mb |
	text := aRefactoringException messageText.
	mb := MessageBox new
				text: text;
				iconStyle: aRefactoringException iconStyle;
				yourself.
	aRefactoringException isResumable
		ifTrue: 
			[mb
				caption: '<1d>…' << aRefactoringException refactoring;
				isCancellable.
			text last == $?
				ifTrue: [mb customButtons: #(#(#yes '&Yes') #(#no 'Cancel'))]
				ifFalse: [mb customButtons: #(#(#yes '&Proceed') #(#no 'Cancel'))].
			mb confirm ifTrue: [aRefactoringException resume]]
		ifFalse: 
			[mb
				caption: 'Refactoring Error';
				headline: 'Unable to <1d>' << aRefactoringException refactoring.
			aRefactoringException hasTag
				ifTrue: [mb confirm ifTrue: [aRefactoringException tag value]]
				ifFalse: [mb warning].
			self abortSignal signal: '<1d> aborted' << aRefactoringException refactoring].
	^aRefactoringException return!

inlineAllSelfSendsOf: aCollectionOfMethods within: aBrowserEnvironment
	"Implement the 'Inline all Self Sends' method refactoring (on multiple methods): 'Inlines
	all senders within the class of the method. If there are no more senders after all inlines
	have been performed, then it will remove the method'"

	| namespace caption |
	namespace := RBModel onEnvironment: aBrowserEnvironment.
	caption := String writeStream.
	caption nextPutAll: 'Inline self sends of '.
	^self performRefactoring: 
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

	self performRefactoring: 
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

	^self performRefactoring: 
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

	self performRefactoring: 
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

moveAllTempsToInnerScope: aBrowserEnvironment
	| model errorCount |
	model := RBModel onEnvironment: aBrowserEnvironment.
	errorCount := 0.
	
	[model
		allBehaviorsDo: [:eachClass | errorCount := errorCount + (self moveAllTempsToInnerScopeIn: eachClass)]]
			on: self abortSignal
			do: [:ex | ^self].
	model name: 'Move All Temps To Inner Scope'.
	errorCount > 0
		ifTrue: 
			[| mb |
			mb := MessageBox new.
			mb buttonStyle: #okCancel.
			mb headline: model name.
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
				environment: anRBClass environment
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
			on: self abortSignal
			do: 
				[:ex |
				"Most likely temp already bound as tightly as possible - ignore it"
				i := i + 1]]
			repeat!

moveTempToInnerScope: anInterval in: aClass selector: aSelector
	"Implement the 'Move to Inner Scope' code refactoring: 'Moves a temporary variable definition 
	into the tightest scope that contains both the variable assignment and references.'"

	^self performRefactoring: 
			[(MoveVariableDefinitionRefactoring
				bindTight: anInterval
				in: aClass
				selector: aSelector) execute]!

moveToComponent: aSelector in: aClass variable: aString
	"Move the method with <Symbol> selector, aSelector, of the <Behavior>, aClass, 
	to another class (or classes) as defined by the variable named, aString.
	Implements the 'Move to Component' refactoring."

	self performRefactoring: 
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

performRefactoring: aBlock
	"Private - Evaluate the refactoring <niladicValuable>, aBlock, trapping any refactoring
	errors it raises and reporting to the user appropriately. If any unhandled error occurs, or
	the refactoring is aborted, then answer nil, otherwise answer the value from the block."

	^aBlock
		on: self refactoringError
		do: [:ex | self handleRefactoringException: ex]!

promptForInitializationExpression: anAddParameterRefactoring
	^(Prompter
		createOn: anAddParameterRefactoring initializer
		prompt: 'Enter default value for new parameter:'
		caption: anAddParameterRefactoring displayString)
		validationDwell: 1 seconds;
		showHintWhenEmpty: false;
		validater: 
				[:source |
				| result |
				result := ValidationResult new.
				anAddParameterRefactoring initializer: source.
				[anAddParameterRefactoring verifyInitializationExpression] on: self refactoringError
					do: 
						[:ex |
						result
							caption: 'Invalid parameter value';
							value: false;
							hint: ex].
				result];
		showModal!

promptForMethodName: anRBMethodName caption: aString allowExisting: aBoolean
	^(RenameMethodDialog createOn: anRBMethodName)
		allowParameterRename: false;
		allowExistingSelector: aBoolean;
		caption: aString;
		showModal!

promptForMethodRename: aCompiledMethod caption: aString allowExisting: aBoolean
	^self
		promptForMethodName: (ScopedMethodName fromMethod: aCompiledMethod)
		caption: aString
		allowExisting: aBoolean!

protectInstanceVariable: aString in: aClass
	"Implement the 'Protect/Concrete instance variable' class refactoring: 'Converts all variable 
	accessor sends to direct variable references. If the accessor is no longer used then it will be removed.'"

	self
		performRefactoring: [(ProtectInstanceVariableRefactoring variable: aString class: aClass) execute]!

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

	^self performRefactoring: 
			[| caption namespace byClass |
			byClass := LookupTable new.
			aCollectionOfMethods
				do: [:each | (byClass at: each methodClass ifAbsentPut: [OrderedCollection new]) add: each selector].
			caption := String writeStream.
			caption
				nextPutAll: 'Push ';
				nextPutAll: (aBoolean ifTrue: ['up'] ifFalse: ['down']);
				space.
			namespace := RBModel new.
			(byClass associations asSortedArray: [:a :b | a key name <= b key name]) do: 
					[:each |
					| selectors class |
					selectors := each value asSortedArray.
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

refactoringError
	"Private - Answer an <exceptionSelector> which can be used to trap exceptions raised during
	a refactoring operation."

	^RefactoringSignal!

removeClass: aClass
	"Removes aClass from the system using the 'Remove Class' refactoring, which won't remove
	the class if referenced, and which promotes all subclasses."

	| oldClassName |
	oldClassName := aClass fullName.
	(MessageBox new
		uniqueId: [self] method;
		isSuppressible: true;
		headline: 'Remove class <1s>?' << oldClassName;
		confirm: 'The class will only be removed if it has no references.') ifFalse: [^false].
	self performRefactoring: [(RemoveClassRefactoring classNames: {aClass fullName}) execute].
	^true!

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

removeMethods: aCollectionOfCompiledMethods
	self basicRemoveMethods: aCollectionOfCompiledMethods within: self systemEnvironment!

removeMethodsDuplicatedInSuperclassOf: aClass
	"Private - Identify all methods of the <Behavior>, aClass, that have an equivalent definition in a superclass,
	list them for the user, and remove them depending on the response. Answers whether there were
	actually any duplicate methods, regardless of whether they were removed."

	| duplicated msg |
	duplicated := self duplicateSuperclassMethodsOf: aClass.
	duplicated isEmpty ifTrue: [^false].
	msg := String smalltalkWriteStream.
	msg
		nextPutAll: 'The following duplicate methods will be removed:';
		cr.
	duplicated := duplicated asSortedArray: [:a :b | a printString < b printString].
	duplicated do: 
			[:each |
			msg
				cr;
				nextPutAll: '    ';
				print: each].
	(MessageBox new
		headline: 'Remove duplicate methods in <1p>?' << aClass;
		isSuppressible: true;
		uniqueId: [self] method;
		confirm: msg contents)
			ifTrue: 
				[self performRefactoring: 
						[(RemoveMethodRefactoring removeMethods: (duplicated collect: [:each | each selector]) from: aClass)
							execute]].
	^true!

removeParameter: aString from: aSelector in: aClass environment: aBrowserEnvironment
	"Implements the Remove Parameter refactoring: 'Removes an unused parameter from 
	all implementors of the method, and removes it from the message sends.' The <readableString>,
	aString, identifies the name of the argument which is removed, not the selector keyword.
	Answer the new selector after removal of the parameter."

	^self performRefactoring: 
			[| model refactoring |
			model := RBModel onEnvironment: aBrowserEnvironment.
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

	self performRefactoring: [(RenameClassRefactoring rename: aClass to: newClassName) execute]!

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
				caption: ('Rename <1p> …' expandMacrosWith: aCompiledMethod)
				allowExisting: false.
	^newName isNil ifFalse: [self renameMethod: aCompiledMethod to: newName]!

renameMethod: aCompiledMethod to: anRBMethodName
	^self performRefactoring: 
			[| model refactoring |
			model := RBModel onEnvironment: anRBMethodName scope.
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
				caption: 'Rename References to <1p> …' << aCompiledMethod
				allowExisting: true.
	^newName notNil ifTrue: [self renameMethodReferences: aCompiledMethod to: newName]!

renameMethodReferences: aCompiledMethod to: anRBMethodName
	^self performRefactoring: 
			[| model refactoring |
			model := RBModel onEnvironment: anRBMethodName scope.
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
						caption: 'Rename Temporary…')
						validater: 
								[:name |
								| result |
								result := ValidationResult new.
								
								[result value: (self
											validateRenameTemp: aStVariableNode
											to: name
											in: aClass)]
										on: RefactoringError
										do: 
											[:ex |
											result
												caption: 'Invalid name';
												value: false;
												hint: ex.
											ex return: false]];
						showModal.
			newName])
			ifNotNil: 
				[:newName |
				self performRefactoring: 
						[(RenameTemporaryRefactoring
							renameTemporaryFrom: aStVariableNode sourceInterval
							to: newName
							in: aClass
							selector: aSelector) execute]]!

renameVariable: aString to: newName in: aClass classVariable: aBoolean within: aBrowserEnvironment
	^self performRefactoring: 
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
								ifFalse: [RenameInstanceVariableAndAccessorsRefactoring]].
			model := RBModel onEnvironment: env.
			refactoring := refactoringClass
						model: model
						rename: aString
						to: newName
						in: aClass.
			model name: refactoring displayString.
			refactoring execute.
			newName]!

safeRemoveSelectors: anArrayOfSelectors from: aClass inEnvironment: aBrowserEnvironment
	| mb |
	mb := MessageBox new.
	mb
		uniqueId: [self] method displayString;
		isSuppressible: true.
	anArrayOfSelectors size > 1
		ifTrue: 
			[| details |
			mb headline: 'Remove methods if unused/redundant?'.
			details := String smalltalkWriteStream.
			details
				nextPutAll: 'The following methods are the candidates for removal:';
				cr.
			anArrayOfSelectors asSortedCollection do: 
					[:each |
					details
						cr;
						nextPutAll: '    ';
						display: each].
			mb
				detailsText: details contents;
				text: 'The methods of <1p> will be removed if they have no references in <2p> or are equivalent to the superclass implementations.'
							<< {aClass. aBrowserEnvironment}]
		ifFalse: 
			[mb
				headline: 'Remove method if unused/redundant?';
				text: '<1p>>><2s> will be removed if it has no references in <3p> or is equivalent to the superclass implementation.'
							<< {aClass. anArrayOfSelectors first. aBrowserEnvironment}].
	(mb
		isCancellable: true;
		customButtons: #(#(#yes '&Remove') #(#no 'Cancel'));
		confirm) ifFalse: [^false].
	^self performRefactoring: 
			[| model refactoring |
			model := RBModel onEnvironment: aBrowserEnvironment.
			refactoring := RemoveMethodRefactoring
						model: model
						removeMethods: anArrayOfSelectors
						from: aClass.
			model name: refactoring displayString.
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
	dialog caption: ('Rename <3s> variable <1p>.<2s> …'
				expandMacrosWith: aClass
				with: aString
				with: (aBoolean ifTrue: ['class'] ifFalse: ['instance'])).
	dialog selectors: selectors.
	scope := dialog showModal.
	scope isNil ifTrue: [self abortSignal signal].
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
		ifFalse: [aStMethodNode argumentNames asSortedArray do: [:each | variables addLast: nil -> each]].
	classes := aClass withAllSuperclasses.
	"Instance variables"
	classes
		do: [:eachClass | eachClass instVarNames do: [:eachVar | variables addLast: eachClass -> eachVar]].
	"Class variables - excluding system defined"
	classes do: 
			[:eachClass |
			(eachClass classBindingNames reject: [:each | each first = $_]) asSortedArray
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
		caption: 'Choose target variable…')
		getTextBlock: [:each | each key ifNil: [each value] ifNotNil: [:eachClass | eachClass unqualifiedName , '.' , each value]];
		showModal) value!

validateNewClassVarName: aString for: aClass
	^(AddClassVariableRefactoring variable: aString class: aClass) preconditions validate
		caption: 'Invalid new class variable name <1p>' << aString;
		yourself!

validateNewInstanceVariableName: aString for: aClass
	^((AddInstanceVariableRefactoring variable: aString class: aClass) preconditions
		& (RBCondition definesTemporaryVariable: aString in: aClass) not) validate
		caption: 'Invalid new instance variable name <1p>' << aString;
		yourself!

validateRenameClass: aClass to: aString
	^((RenameClassRefactoring rename: aClass to: aString) preconditions
		& (RBCondition hierarchyOf: aClass definesVariable: aString) not) validate!

validateRenameClassVar: oldString to: newString in: aClass
	^(RenameClassVariableRefactoring
		rename: oldString
		to: newString
		in: aClass) preconditions
		validate!

validateRenameInstVar: oldString to: newString in: aClass
	"The RenameInstanceVariableRefactoring does not pick up the fact that a candidate inst var name is already in use as a temporary name in one of more of a classes methods until it is executed, so we add a condition for that."

	^((RenameInstanceVariableRefactoring
		rename: oldString
		to: newString
		in: aClass) preconditions
		& (RBCondition definesTemporaryVariable: newString in: aClass) not) validate!

validateRenameTemp: aStVariableNode to: aString in: aClass
	| definingNode |
	"The RenameTemporaryRefactoring does not pick up the fact that a candidate temp name is already in use until it is executed, so we add a condition for that"
	definingNode := aStVariableNode whoDefines: aStVariableNode name.
	^((RenameTemporaryRefactoring
		renameTemporaryFrom: aStVariableNode sourceInterval
		to: aString
		in: aClass
		selector: aStVariableNode methodNode selector) preconditions
		& (RBCondition withBlock: 
					[(definingNode whoDefines: aString) isNil
						and: [(definingNode allDefinedVariables includes: aString) not]]
				errorString: ('<1p> is already defined' expandMacrosWith: aString)))
			validate! !
!Tools.RefactoringSmalltalkSystem categoriesForMethods!
abortSignal!constants!private! !
abstractClassVariable:in:within:!public!refactoring! !
abstractClassVariables:within:!public!refactoring! !
abstractInstanceVariable:in:within:!public!refactoring! !
abstractInstanceVariables:within:!public!refactoring! !
addClassVariable:to:!public!refactoring! !
addClassVariableTo:!public!refactoring! !
addFilteredMethod:forLintRule:!public!refactoring! !
addInstanceVariable:to:!public!refactoring! !
addInstanceVariableTo:!public!refactoring! !
addParameterToMethod:!commands!public!refactoring! !
addParameterToMethod:inPackages:!public!refactoring! !
addSharedVariable:to:!commands!public! !
basicCreateSubclass:of:subclasses:!private!refactoring! !
basicRemoveMethods:within:!private!refactoring! !
basicRemoveMethodsIn:within:!private!refactoring! !
browseMethodsIn:!browsing!public! !
browseMethodsInEnvironments:!browsing!public! !
browseSelectors:caption:environment:!browsing!private! !
canRefactor!public!testing! !
chooseMethodFromEnvironment:caption:!public! !
chooseSelectorInEnvironment:caption:!public! !
cloneClass:as:under:in:!private!refactoring! !
convertTemporaryToInstanceVariable:in:selector:!public!refactoring! !
convertToSibling:!public!refactoring! !
createInstanceVariableAccessors:in:within:!public!refactoring! !
createVariableAccessors:classVariables:within:!public!refactoring! !
duplicateOf:in:!helpers!private! !
duplicateSuperclassMethodsOf:!enquiries!private! !
executeVariableRefactoring:variables:within:!helpers!private!refactoring! !
extendMethodBrowserMenus:!browsing!private! !
extractMethod:from:in:!public!refactoring! !
extractToComponent:from:in:!public!refactoring! !
extractToTemporary:from:in:!public!refactoring! !
handleRefactoringException:!private!refactoring! !
inlineAllSelfSendsOf:within:!public!refactoring! !
inlineMessage:inMethod:of:!public!refactoring! !
inlineParameter:from:in:!public!refactoring! !
inlineTemporary:from:in:!public!refactoring! !
isOAD!accessing!private!product! !
isOAD:!accessing!private!product! !
moveAllTempsToInnerScope:!public!refactoring! !
moveAllTempsToInnerScopeIn:!helpers!private!refactoring! !
moveAllTempsToInnerScopeIn:selector:!private!refactoring! !
moveTempToInnerScope:in:selector:!public!refactoring! !
moveToComponent:in:variable:!public!refactoring! !
newCodeRefactoringToolFor:!helpers!private!refactoring! !
newMethodRefactoringToolFor:!helpers!private!refactoring! !
nukeChangeHistory!private!refactoring! !
performRefactoring:!private!refactoring! !
promptForInitializationExpression:!private!refactoring! !
promptForMethodName:caption:allowExisting:!helpers!private!refactoring! !
promptForMethodRename:caption:allowExisting:!helpers!private!refactoring! !
protectInstanceVariable:in:!public!refactoring! !
protectInstanceVariables:!public!refactoring! !
pullUpClassVariable:into:!public!refactoring! !
pullUpClassVariable:into:within:!public!refactoring! !
pullUpInstanceVariable:into:!public!refactoring! !
pullUpInstanceVariable:into:within:!public!refactoring! !
pushDownClassVariable:in:!public!refactoring! !
pushDownClassVariable:in:within:!public!refactoring! !
pushDownInstanceVariable:in:!public!refactoring! !
pushDownInstanceVariable:in:within:!public!refactoring! !
pushDownInstanceVariables:!public!refactoring! !
pushDownMethods:!public!refactoring! !
pushMethods:up:!private!refactoring! !
pushUpMethods:!public!refactoring! !
queryCommand:!commands!private! !
refactoringError!constants!private! !
removeClass:!public!refactoring! !
removeClassVariable:from:within:!public!refactoring! !
removeClassVariables:within:!public!refactoring! !
removeFilteredMethod:forLintRule:!public!refactoring! !
removeInstanceVariable:from:within:!public!refactoring! !
removeInstanceVariables:within:!public!refactoring! !
removeMethods:!public!refactoring! !
removeMethodsDuplicatedInSuperclassOf:!private!refactoring! !
removeParameter:from:in:environment:!public!refactoring! !
renameClass:to:!public!refactoring! !
renameClassVariable:to:in:within:!private!refactoring! !
renameInstanceVariable:to:in:within:!private!refactoring! !
renameMethod:!public!refactoring! !
renameMethod:to:!public!refactoring! !
renameMethodReferences:!public!refactoring! !
renameMethodReferences:to:!private!refactoring! !
renameTemporary:to:in:selector:!public!refactoring! !
renameVariable:to:in:classVariable:within:!private!refactoring! !
safeRemoveSelectors:from:inEnvironment:!private!refactoring! !
scopeToRenameAccessorsFor:in:classVariable:within:!private!refactoring! !
selectTargetVariableOf:parseTree:!helpers!private!refactoring! !
validateNewClassVarName:for:!helpers!private!refactoring! !
validateNewInstanceVariableName:for:!enquiries!helpers!private!refactoring! !
validateRenameClass:to:!helpers!private! !
validateRenameClassVar:to:in:!helpers!private! !
validateRenameInstVar:to:in:!helpers!private! !
validateRenameTemp:to:in:!helpers!private!refactoring! !
!

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
!Tools.RefactoringSmalltalkSystem class categoriesForMethods!
initialize!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

