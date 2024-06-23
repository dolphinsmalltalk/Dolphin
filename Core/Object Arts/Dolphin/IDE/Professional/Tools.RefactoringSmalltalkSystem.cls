"Filed out from Dolphin Smalltalk"!

Tools.ProfessionalSmalltalkSystem
	subclass: #'Tools.RefactoringSmalltalkSystem'
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

accessorsFor: nameString isClassVariable: aBoolean of: aClass within: aBrowserEnvironment
	| finder accessors |
	finder := CreateAccessorsForVariableRefactoring
				model: (RBModel onEnvironment: aBrowserEnvironment)
				variable: nameString
				class: aClass
				classVariable: aBoolean.
	accessors := OrderedCollection new.
	finder findGetterMethod ifNotNil: [:getter | accessors addLast: getter].
	finder findSetterMethod ifNotNil: [:setter | accessors addLast: setter].
	^accessors!

addClassVariable: aString to: aClass
	self
		executeVariableRefactoring: AddClassVariableRefactoring
		variables: {aClass -> aString}
		within: self browserEnvironment!

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

addImportToClasses: aCollectionOfClasses
	| import refactoringModel refactorings dialog |
	dialog := ChooseImportDialog create.
	import := dialog showModal.
	import ifNil: [^self].
	refactoringModel := RBModel new.
	refactorings := aCollectionOfClasses asArray
				select: [:each | ((refactoringModel classFor: each) importsNamespace: import) not]
				thenCollect: 
					[:each |
					AddImportRefactoring
						model: refactoringModel
						addImport: import
						to: each].
	refactoringModel name: (refactorings size = 1
				ifTrue: [refactorings first displayString]
				ifFalse: ['Import <1p> into <2d> classes' << {import. refactorings size}]).
	self performRefactorings: refactorings showChanges: dialog showChanges!

addInstanceVariable: aString to: aClass
	self
		executeVariableRefactoring: AddInstanceVariableRefactoring
		variables: {aClass -> aString}
		within: self browserEnvironment!

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
	| args argc newName suffix newArg selector model refactoring prompter |
	newName := ScopedMethodName fromMethod: aCompiledMethod.
	args := newName arguments.
	argc := args size.
	suffix := argc + 1.
	
	[newArg := 'arg' , suffix displayString.
	args includes: newArg] whileTrue: [suffix := suffix + 1].
	args addLast: newArg.
	selector := aCompiledMethod selector.
	newName selector: (argc == 0 ifTrue: [selector , ':'] ifFalse: [selector]).
	prompter := (aCollectionOfPackages isEmpty
				ifTrue: [RenameMethodDialog createOn: newName]
				ifFalse: 
					[newName addScope: (self browserEnvironment forPackages: aCollectionOfPackages) name: #'Package(s)'.
					MethodNameDialog create: 'Refactoring view' on: newName])
				allowParameterReordering: false;
				allowParameterRename: false;
				caption: 'Add Parameter to <1p><2? in Package(s)...>'
							<< {aCompiledMethod selector. aCollectionOfPackages notEmpty};
				yourself.
	newName := prompter showModal.
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
			[model name: refactoring displayString.
			refactoring shouldShowChanges: prompter showChanges.
			self performRefactoring: refactoring]!

addSharedVariable: aString to: aNamespace
	self changeManager performChange: (AddSharedVariableChange addSharedVariable: aString to: aNamespace )!

basicCreateSubclass: aClassDetails subclasses: aCollection
	"Private - Create a subclass a subclass with the specified details and subclasses. Answer the new class."

	"Implements the 'Create Subclass' class refactoring: 'This refactoring allows you to insert a
	new class into an existing hierarchy. For example, you can insert a new class between object
	and all of its subclasses by using the refactoring (although I wouldn't recommend it).'"

	| ref |
	ref := aClassDetails classReference.
	self performRefactoring: (AddClassRefactoring details: aClassDetails subclasses: aCollection).
	^ref valueOrNil!

basicRemoveMethods: aCollectionOfCompiledMethods within: aBrowserEnvironment showChanges: aBoolean
	| classes |
	classes := (aCollectionOfCompiledMethods collect: [:each | each methodClass]) asSet.
	classes size = 1
		ifTrue: 
			[self
				basicRemoveSelectors: (aCollectionOfCompiledMethods collect: [:each | each selector])
				from: classes anyOne
				within: aBrowserEnvironment
				showChanges: aBoolean]
		ifFalse: 
			[self
				basicRemoveMethodsIn: (aBrowserEnvironment forMethods: aCollectionOfCompiledMethods)
				within: aBrowserEnvironment
				showChanges: aBoolean]!

basicRemoveMethodsIn: methodsEnvironment within: searchEnvironment showChanges: aBoolean
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
	aBoolean ifTrue: [model browseChanges] ifFalse: [self changeManager performChange: model changes]!

basicRemoveSelectors: anArrayOfSelectors from: aClass within: aBrowserEnvironment showChanges: aBoolean
	| refactoring model |
	model := RBModel onEnvironment: aBrowserEnvironment.
	refactoring := RemoveMethodRefactoring
				model: model
				removeMethods: anArrayOfSelectors
				from: aClass.
	refactoring shouldShowChanges: aBoolean.
	model name: refactoring displayString.
	^self performRefactoring: refactoring!

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

canChangeClassNamespaces: aCollectionOfClasses
	aCollectionOfClasses isEmpty ifTrue: [^false].
	^aCollectionOfClasses allSatisfy: [:each | (ClassBuilder isFixedName: each) not]!

canRefactor
	"Answer whether the receiver is capable of performing refactorings."

	^true!

changeNamespaceOfClasses: aCollectionOfClasses
	| namespace chooser default prompt |
	aCollectionOfClasses size = 1
		ifTrue: 
			[| class |
			class := aCollectionOfClasses first.
			default := class environment.
			prompt := 'Choose new namespace for <1p>…' << class]
		ifFalse: [prompt := 'Choose new namespace for <1d> classes…' << aCollectionOfClasses size].
	chooser := (ChooseNamespaceDialog create: 'Refactoring view' on: default asValue)
				caption: prompt;
				yourself.
	namespace := chooser showModal.
	namespace ifNil: [^self].
	self
		moveClasses: aCollectionOfClasses
		toNamespace: namespace
		showChanges: chooser showChanges!

chooseMethodFromEnvironment: aBrowserEnvironment caption: aString
	^ChoicePrompter choices: (aBrowserEnvironment allMethods asSortedCollection: [:a :b | a <= b])
		caption: aString << aBrowserEnvironment!

chooseSelectorInEnvironment: aBrowserEnvironment caption: aString
	| selectors |
	selectors := Set new.
	aBrowserEnvironment classesAndSelectorsDo: [:eachClass :eachSelector | selectors add: eachSelector].
	selectors := selectors asSortedCollection.
	^ChoicePrompter choices: selectors caption: aString!

cloneClass: aClass as: newClassName under: superclass in: package
	^self performRefactoringAction: 
			[| newClass |
			(CopyClassRefactoring
				clone: aClass
				as: newClassName
				superclass: superclass) execute.
			newClass := newClassName asQualifiedReference value.
			newClass owningPackage: package.
			newClass]!

confirmRenameClass: aClass to: aString
	^MessageBox new
		headline: 'Rename <1s>?' << aClass unqualifiedName;
		text: '<1s> will be renamed to <2s>.<n><n>Any references in code will be updated, but not where the name appears in comments, literal strings, or argument names.'
					<< {aClass fullName. aString};
		customButtons: #(#(#yes '&Rename') #(#no 'Cancel'));
		isCancellable: true;
		checkboxText: self showChangesText;
		yourself!

convertTemporaryToInstanceVariable: aString in: aClass selector: aSelector
	"Implement the 'Convert to Instance Variable' code refactoring."

	self performRefactoring: (TemporaryToInstanceVariableRefactoring
				class: aClass
				selector: aSelector
				variable: aString)!

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
		ifNotNil: [:refactoring | self performRefactoring: refactoring]!

createInstanceVariableAccessors: aString in: aClass within: aBrowserEnvironment
	"Invoke the 'Create Variable Accessors' refactoring on an instance variable."

	self
		createVariableAccessors: {aClass -> aString}
		classVariables: false
		within: aBrowserEnvironment!

createNewClass: subclassName inPackage: aPackage
	| dialog |
	dialog := CreateSubclassDialog newSubclassOf: Object inPackage: aPackage.
	dialog subclassFullName: subclassName.
	dialog showModal.
	^dialog answer ifNotNil: [self createSubclass: dialog classDetails subclasses: dialog subclasses]!

createVariableAccessors: variableNamePairs classVariables: aBoolean within: aBrowserEnvironment
	"Generate get and set accessors for the specified class and variable name pairs."

	^self performRefactoringAction: 
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

emitKeywordSignatureFor: aSymbol withArgs: anArray in: aClass on: aPuttableStream
	| argNames instVars |
	argNames := OrderedCollection new.
	instVars := aClass allInstanceVariableNames.
	argNames addAll: instVars.
	aSymbol keywords with: anArray
		do: 
			[:keyword :arg |
			| x argName |
			aPuttableStream
				nextPutAll: keyword;
				space.
			argName := arg.
			x := 1.
			[argNames includes: argName] whileTrue: [argName := arg , (x := x + 1) printString].
			argNames add: argName.
			aPuttableStream
				nextPutAll: argName;
				space].
	^argNames copyFrom: instVars size + 1!

executeRefactoring: aBlock
	"Private - Evaluate the refactoring <niladicValuable>, aBlock, trapping any refactoring
	errors it raises and reporting to the user appropriately. If any unhandled error occurs, or
	the refactoring is aborted, then answer nil, otherwise answer the value from the block."

	^aBlock
		on: self refactoringError
		do: [:ex | self handleRefactoringException: ex]!

executeVariableRefactoring: refactoringClass variables: aCollectionOfPairs within: aBrowserEnvironment
	^self performRefactoringAction: 
			[| namespace refactoring caption |
			namespace := RBModel onEnvironment: aBrowserEnvironment.
			caption := String writeStream.
			caption
				nextPutAll: refactoringClass displayPrefix;
				space.
			aCollectionOfPairs do: 
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
	otherMenu := ctxMenu findCommand: #browseOther.
	otherMenu insertItem: (CommandMenuItem
				commandDescription: (CommandDescription command: #recompileDiffs description: 'Recompile &diffs'))
		after: #browseCompilationFailures!

extractMethod: anInterval from: aSymbol in: aBehavior
	"Create a method from the selection of source text in the range identified
	by the <Interval>, anInterval, of the method of the <Behavior>, aBehavior, 
	with <Symbol> selector, aSymbol. The user is prompted for the new method name.

	Implements the 'Extract Method' refactoring: 'Extracts the selected code as a separate 
	method. This refactoring determines what temporary variables are needed in the new method, 
	and prompts for a selector that takes these arguments.'"

	^self performRefactoring: (ExtractMethodRefactoring
				extract: anInterval
				from: aSymbol
				in: aBehavior)!

extractToComponent: anInterval from: aSelector in: aClass
	"Create a component from the selection of source text in the range identified
	by the <Interval>, anInterval, of the method of the <Behavior>, aClass, 
	with <Symbol> selector, aSelector. The user may be prompted to supply additional
	information.
	Implements the 'Extract to Component' refactoring."

	self performRefactoring: (ExtractMethodToComponentRefactoring
				extract: anInterval
				from: aSelector
				in: aClass)!

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
							errorString: ['<p> is already in use as a local variable' << tempName])
								& (RBCondition isValidTemporaryVariableName: tempName)
								& (RBCondition definesInstanceVariable: tempName in: aClass) not) validate];
				showHintWhenEmpty: false;
				showModal.
	newName isNil ifTrue: [^nil].
	^self performRefactoring: (ExtractToTemporaryRefactoring
				extract: anInterval
				to: newName
				from: aSelector
				in: aClass)!

generateStubFor: aSymbol inClass: aClass withArgs: aSequenceableCollection
	^(self
		compile: (self
				stubTextFor: aSymbol
				arguments: aSequenceableCollection
				inClass: aClass)
		in: aClass
		environment: nil
		categories: #()
		package: nil
		extraFlags: 0) method!

handleRefactoringException: aRefactoringException
	| text mb defaultCaption |
	text := aRefactoringException messageText.
	mb := MessageBox new
				text: text;
				iconStyle: aRefactoringException iconStyle;
				yourself.
	defaultCaption := 'Refactoring Error'.
	aRefactoringException isResumable
		ifTrue: 
			[mb
				caption: '<1d>…' << (aRefactoringException refactoring ?? defaultCaption);
				isCancellable.
			text last == $?
				ifTrue: [mb customButtons: #(#(#yes '&Yes') #(#no 'Cancel'))]
				ifFalse: [mb customButtons: #(#(#yes '&Proceed') #(#no 'Cancel'))].
			mb confirm ifTrue: [aRefactoringException resume]]
		ifFalse: 
			[mb
				caption: defaultCaption;
				headline: 'Unable to <1d>' << (aRefactoringException refactoring ?? 'perform refactoring').
			aRefactoringException hasTag
				ifTrue: [mb confirm ifTrue: [aRefactoringException tag value]]
				ifFalse: [mb warning].
			self abortSignal signal: '<1d> aborted' << (aRefactoringException refactoring ?? 'Refactoring')].
	^aRefactoringException return!

inlineAllSelfSendsOf: aCollectionOfMethods within: aBrowserEnvironment
	"Implement the 'Inline all Self Sends' method refactoring (on multiple methods): 'Inlines
	all senders within the class of the method. If there are no more senders after all inlines
	have been performed, then it will remove the method'"

	| namespace caption |
	namespace := RBModel onEnvironment: aBrowserEnvironment.
	caption := String writeStream.
	caption nextPutAll: 'Inline self sends of '.
	^self performRefactoringAction: 
			[| options |
			options := IdentityDictionary new.
			aCollectionOfMethods do: 
					[:each |
					| refactoring |
					refactoring := InlineAllSendersRefactoring
								model: namespace
								sendersOf: each selector
								in: each methodClass.
					refactoring options: options.
					refactoring primitiveExecute.
					caption display: each]
				separatedBy: [caption nextPutAll: ', '].
			namespace name: caption contents.
			(options lookup: #showChanges) value == true
				ifTrue: [namespace browseChanges]
				ifFalse: [self changeManager performChange: namespace changes].
			namespace]!

inlineMessage: aStMessageNode inMethod: aSelector of: aBehavior
	"Inline the message send whose source text is in the <Interval>, anInterval, of the method
	of the <Behavior>, aBehavior, with <Symbol> selector, aSymbol.

	Implements the 'Inline Message' refactoring: 'Inlines a message send. If there are multiple implementors 
	of the message, it will prompt for the implementation that should be inlined.'"

	| refactoring receiver |
	(aStMessageNode isMessage and: 
			[receiver := aStMessageNode receiver.
			receiver isSelfVariable or: [receiver isSuperVariable]])
		ifTrue: 
			[refactoring := InlineMethodRefactoring
						inline: aStMessageNode sourceInterval
						inMethod: aSelector
						forClass: aBehavior]
		ifFalse: 
			[refactoring := InlineMethodFromComponentRefactoring
						inline: aStMessageNode sourceInterval
						inMethod: aSelector
						forClass: aBehavior.
			(aStMessageNode isMessage and: 
					[receiver := aStMessageNode receiver.
					receiver isVariable and: [receiver isStaticVariable]])
				ifTrue: 
					[| binding |
					binding := receiver binding.
					(binding isClassBinding and: [binding value respondsTo: aStMessageNode selector])
						ifTrue: 
							[refactoring inlineClass: ((binding value classInModel: refactoring model) metaclass
										whoDefinesMethod: aStMessageNode selector)]]].
	self performRefactoring: refactoring!

inlineParameter: aString from: aSelector in: aClass
	"Implements the 'Inline Parameter' code refactoring: Remove a parameter from the method, and adds 
	an assignment at the beginning of the method. This can only be performed if all senders of the method have 
	the same value for the parameter'"

	^self performRefactoringAction: 
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

	self performRefactoring: (InlineTemporaryRefactoring
				inline: anInterval
				from: aSelector
				in: aClass)!

isOAD
	"Private - Is this an Object Arts Development version"

	isOAD isNil ifTrue: [isOAD := SessionManager current isOAD].
	^isOAD!

isOAD: aBoolean
	"Private - Set this an Object Arts Development version according to aBoolean"

	isOAD := aBoolean
!

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
				warning: '<1p> non-fatal errors occured while constructing the refactoring. Please see Transcript for further details.<n><n>If you contine with the refactoring then the erroneous methods will be ignored. The Refactoring is undoable.<n><n>Press OK to proceed, or Cancel to abort.'
						<< errorCount)
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

moveClasses: aCollectionOfClasses toNamespace: aNamespace showChanges: aBoolean
	| refactorings refactoringModel |
	"Enhance RenameClassRefactoring to support multiple renames. In the meantime perform as a sequence"
	refactoringModel := RBModel new.
	refactorings := aCollectionOfClasses asArray
				select: [:each | each ~~ aNamespace and: [each environment ~~ aNamespace]]
				thenCollect: 
					[:each |
					RenameClassRefactoring
						model: refactoringModel
						rename: each
						to: (aNamespace fullNameFor: each unqualifiedName)].
	refactoringModel name: (refactorings size = 1
				ifTrue: [refactorings first displayString]
				ifFalse: ['Move <2d> classes to <1p>' << {aNamespace. refactorings size}]).
	self performRefactorings: refactorings showChanges: aBoolean!

moveTempToInnerScope: anInterval in: aClass selector: aSelector
	"Implement the 'Move to Inner Scope' code refactoring: 'Moves a temporary variable definition 
	into the tightest scope that contains both the variable assignment and references.'"

	^self performRefactoringAction: 
			[(MoveVariableDefinitionRefactoring
				bindTight: anInterval
				in: aClass
				selector: aSelector) execute]!

moveToComponent: aSelector in: aClass variable: aString
	"Move the method with <Symbol> selector, aSelector, of the <Behavior>, aClass, 
	to another class (or classes) as defined by the variable named, aString.
	Implements the 'Move to Component' refactoring."

	self performRefactoring: (MoveMethodRefactoring
				selector: aSelector
				class: aClass
				variable: aString)!

newMethodNamePrompter: aRBMethodName caption: aString allowExisting: aBoolean
	^(RenameMethodDialog createOn: aRBMethodName)
		allowParameterRename: false;
		allowExistingSelector: aBoolean;
		caption: aString;
		yourself!

newMethodRefactoringToolFor: aMethodBrowser
	^MethodRefactoringTool forPresenter: aMethodBrowser!

nukeChangeHistory
	super nukeChangeHistory.
	RefactoringManager nuke!

performRefactoring: aRefactoring
	self performRefactoringAction: [aRefactoring primitiveExecute].
	aRefactoring shouldShowChanges
		ifTrue: [aRefactoring model browseChanges]
		ifFalse: [RefactoringManager instance addRefactoring: aRefactoring].
	^aRefactoring!

performRefactoringAction: aBlock
	"Private - Evaluate the refactoring <niladicValuable>, aBlock, trapping any refactoring
	errors it raises and reporting to the user appropriately. If any unhandled error occurs, or
	the refactoring is aborted, then answer nil, otherwise answer the value from the block."

	^aBlock on: self refactoringError do: [:ex | self handleRefactoringException: ex]!

performRefactorings: aCollectionOfRefactorings showChanges: aBoolean
	| count rbModel refactorings |
	count := aCollectionOfRefactorings size.
	count < 1
		ifTrue: 
			["Nothing to do"
			^self].
	refactorings := aCollectionOfRefactorings asArray.
	rbModel := refactorings last model.
	(ProgressDialog operation: 
			[:progress |
			
			[self performRefactoringAction: 
					[refactorings keysAndValuesDo: 
							[:index :each |
							"All the refactorings must have the same model"
							self assert: [each model == rbModel].
							progress text: each displayString.
							each primitiveExecute.
							progress value: index * 100 / count].
					aBoolean
						ifTrue: [[rbModel browseChanges] postToInputQueue]
						ifFalse: [RefactoringManager instance addRefactoring: refactorings last]]]
					on: self abortSignal
					do: [:ex | ex toTrace]])
		caption: rbModel name;
		showModal!

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

promptToRemoveMethods: aCollectionOfMethods inEnvironment: aBrowserEnvironment
	| mb multiple |
	mb := MessageBox new.
	multiple := aCollectionOfMethods size > 1.
	multiple
		ifTrue: 
			[| details |
			details := String smalltalkWriteStream.
			details
				nextPutAll: 'The following methods are the candidates for removal:';
				cr.
			aCollectionOfMethods asSortedCollection do: 
					[:each |
					details
						cr;
						nextPutAll: '    ';
						display: each].
			mb
				detailsText: details contents;
				text: 'The methods will be removed if they have no references in <1p> or are equivalent to the superclass implementations.'
							<< { aBrowserEnvironment }]
		ifFalse: 
			[mb
				text: '<1p> will be removed if it has no references in <2p> or is equivalent to the superclass implementation.'
						<< { aCollectionOfMethods first. aBrowserEnvironment }].
	mb
		headline: 'Remove method<1?s:> if unused/redundant?' << multiple;
		uniqueId: [self] method displayString , (multiple ifTrue: ['-multiple'] ifFalse: ['-single']);
		isSuppressible: true;
		isCancellable: true;
		customButtons: #(#(#yes '&Remove') #(#no 'Cancel'));
		confirm.
	^mb isConfirmed!

protectInstanceVariable: aString in: aClass
	"Implement the 'Protect/Concrete instance variable' class refactoring: 'Converts all variable 
	accessor sends to direct variable references. If the accessor is no longer used then it will be removed.'"

	self performRefactoring: (ProtectInstanceVariableRefactoring variable: aString class: aClass)!

protectInstanceVariables: pairs 
	"Invoke the 'Protect/Concrete Instance Variable' refactoring for each of the 
	class/inst. var. name pairs in the argument."

	pairs do: [:each | self protectInstanceVariable: each value in: each key]!

pullUpClassVariable: aString into: aClass 
	"Implement the 'Pull Up Class Variable' class refactoring."

	^self 
		pullUpClassVariable: aString
		into: aClass
		within: self browserEnvironment!

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
		within: self browserEnvironment!

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
		within: self browserEnvironment!

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
		within: self browserEnvironment!

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

	^self performRefactoringAction: 
			[| caption namespace byClass options |
			byClass := LookupTable new.
			aCollectionOfMethods
				do: [:each | (byClass at: each methodClass ifAbsentPut: [OrderedCollection new]) add: each selector].
			caption := String writeStream.
			caption
				nextPutAll: 'Push ';
				nextPutAll: (aBoolean ifTrue: ['up'] ifFalse: ['down']);
				space.
			namespace := RBModel new.
			options := IdentityDictionary new.
			(byClass associations asSortedArray: [:a :b | a key name <= b key name]) do: 
					[:each |
					| selectors class pushRefactoring |
					selectors := each value asSortedArray.
					class := each key.
					selectors do: [:eachSelector | caption print: eachSelector] separatedBy: [caption nextPut: $,].
					caption
						nextPutAll: ' from ';
						print: each key.
					pushRefactoring := aBoolean
								ifTrue: 
									[PushUpMethodRefactoring
										model: namespace
										pushUp: selectors
										from: class]
								ifFalse: 
									[PushDownMethodRefactoring
										model: namespace
										pushDown: selectors
										from: class].
					pushRefactoring options: options.
					pushRefactoring primitiveExecute]
				separatedBy: [caption nextPutAll: ', '].
			namespace name: caption contents.
			(options lookup: #showChanges) value == true
				ifTrue: [namespace browseChanges]
				ifFalse: [self changeManager performChange: namespace changes].
			namespace]!

pushUpMethods: aCollectionOfMethods 
	"Implement the 'Push Up' method refactoring (on multiple methods): 'Pushes a method up into
	the superclass. If the superclass is abstract and already defines the method, then the
	superclass' method will be copied down into the other subclasses (assuming they don't
	already define the method).'"

	^self pushMethods: aCollectionOfMethods up: true!

refactoringError
	"Private - Answer an <exceptionSelector> which can be used to trap exceptions raised during
	a refactoring operation."

	^RefactoringSignal!

refactoringToRenameVariable: nameString to: newNameString isClassVariable: aBoolean of: aClass within: aBrowserEnvironment
	| accessors refactoring |
	accessors := self
				accessorsFor: nameString
				isClassVariable: aBoolean
				of: aClass
				within: aBrowserEnvironment.
	accessors isEmpty
		ifTrue: 
			[refactoring := (aBoolean
						ifTrue: [RenameClassVariableRefactoring]
						ifFalse: [RenameInstanceVariableRefactoring])
							model: (RBModel onEnvironment: aBrowserEnvironment)
							rename: nameString
							to: newNameString
							in: aClass]
		ifFalse: 
			[| model dialog |
			dialog := RenameAccessorsDialog create
						caption: 'Rename <3?class:instance> variable <1p>.<2s> …' << {aClass. nameString. aBoolean};
						selectors: accessors;
						yourself.
			dialog showModal
				ifNil: 
					["Cancelled"
					^nil]
				ifNotNil: 
					[:scope |
					scope == #None
						ifTrue: 
							[refactoring := (aBoolean
										ifTrue: [RenameClassVariableRefactoring]
										ifFalse: [RenameInstanceVariableRefactoring])
											model: (RBModel onEnvironment: aBrowserEnvironment)
											rename: nameString
											to: newNameString
											in: aClass]
						ifFalse: 
							[| env |
							env := aBrowserEnvironment.
							scope == #Class
								ifTrue: [env := aBrowserEnvironment forClasses: {aClass instanceClass. aClass instanceClass class}].
							scope == #Hierarchy ifTrue: [env := aBrowserEnvironment forClassHierarchyFrom: aClass].
							scope == #'Package(s)'
								ifTrue: 
									[env := aBrowserEnvironment
												forPackages: (accessors collect: [:each | (aClass compiledMethodAt: each) owningPackage]) asSet].
							scope == #'Method(s)' ifTrue: [env := aBrowserEnvironment forClass: aClass selectors: accessors].
							model := RBModel onEnvironment: env.
							refactoring := (aBoolean
										ifTrue: [RenameClassVariableAndAccessorsRefactoring]
										ifFalse: [RenameInstanceVariableAndAccessorsRefactoring])
											model: model
											rename: nameString
											to: newNameString
											in: aClass]].
			dialog showChanges ifTrue: [refactoring shouldShowChanges: true]].
	refactoring model name: refactoring displayString.
	^refactoring!

removeClasses: aCollection
	"Removes aClass from the system using the 'Remove Class' refactoring, which won't remove
	the class if referenced, and which promotes all subclasses."

	| count single refactoring messageBox |
	count := aCollection size.
	count = 0 ifTrue: [^self].
	single := count = 1.
	messageBox := MessageBox new.
	(messageBox
		headline: (single
					ifTrue: ['Remove class <1s>?' << aCollection first fullName]
					ifFalse: ['Remove <1d> classes?' << count]);
		checkboxText: self showChangesText;
		confirm: 'The class<1?:es> will only be removed if <1?it has:they have> no references.' << single)
			ifFalse: [^false].
	refactoring := RemoveClassRefactoring classNames: (aCollection collect: [:each | each fullName]).
	messageBox isChecked ifTrue: [refactoring shouldShowChanges: true].
	self performRefactoring: refactoring.
	^true!

removeClassVariable: aString from: aClass within: aBrowserEnvironment
	self removeStaticVariables: {aClass -> aString} within: aBrowserEnvironment!

removeFilteredMethod: aCompiledMethod forLintRule: aLintRule
	| filter |
	filter := BasicLintRule filterFor: aLintRule name.
	filter removeClass: aCompiledMethod methodClass selector: aCompiledMethod selector.
	self trigger: #lintRuleFilterChanged: with: aLintRule!

removeImportFromClasses: aCollectionOfClasses
	| allImports import refactoringModel refactorings count dialog |
	allImports := Set new.
	aCollectionOfClasses do: [:each | allImports addAll: each imports].
	count := aCollectionOfClasses size.
	dialog := ChoicePrompter refactoringChoices: allImports asSortedCollection
				caption: 'Remove import from <d>...'
						<< (count = 1 ifTrue: [aCollectionOfClasses single unqualifiedName] ifFalse: ['<d> classes' << count]).
	dialog ifNil: [^self].
	import := dialog value.
	refactoringModel := RBModel new.
	refactorings := aCollectionOfClasses collect: 
					[:each |
					RemoveImportRefactoring
						model: refactoringModel
						removeImport: import
						from: each].
	refactoringModel name: (count = 1
				ifTrue: [refactorings single displayString]
				ifFalse: ['Remove Import <1p> from <2d> Classes' << { import. count }]).
	self performRefactorings: refactorings showChanges: dialog showChanges!

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

removeMethods: aCollectionOfMethods
	| classes env count |
	count := aCollectionOfMethods size.
	count = 0 ifTrue: [^self].
	env := self browserEnvironment.
	(self promptToRemoveMethods: aCollectionOfMethods inEnvironment: env) ifFalse: [^self].
	classes := (aCollectionOfMethods collect: [:each | each methodClass]) asSet.
	classes size > 1
		ifTrue: 
			[self
				basicRemoveMethodsIn: (env forMethods: aCollectionOfMethods)
				within: env
				showChanges: false]
		ifFalse: 
			[self
				basicRemoveSelectors: (aCollectionOfMethods collect: [:each | each selector])
				from: classes single
				within: env
				showChanges: false]!

removeMethodsDuplicatedInSuperclassOf: aClass
	"Private - Identify all methods of the <Behavior>, aClass, that have an equivalent definition in a superclass,
	list them for the user, and remove them depending on the response. Answers whether there were
	actually any duplicate methods, regardless of whether they were removed."

	| duplicated details messageBox |
	duplicated := self duplicateSuperclassMethodsOf: aClass.
	duplicated isEmpty ifTrue: [^false].
	details := String smalltalkWriteStream.
	details
		nextPutAll: 'The following duplicate methods will be removed:';
		cr.
	duplicated := duplicated asSortedArray: [:a :b | a printString < b printString].
	duplicated do: 
			[:each |
			details
				cr;
				nextPutAll: '    ';
				print: each].
	messageBox := MessageBox new
				headline: 'Remove duplicate methods in <1p>?' << aClass;
				checkboxText: self showChangesText;
				detailsText: details contents;
				customButtons: #(#(#yes '&Remove Duplicates') #(#no 'Cancel')) yourself.
	messageBox confirm
		ifTrue: 
			[| refactoring |
			refactoring := RemoveMethodRefactoring removeMethods: (duplicated collect: [:each | each selector])
						from: aClass.
			messageBox isChecked ifTrue: [refactoring shouldShowChanges: true].
			self performRefactoring: refactoring].
	^true!

removeParameter: aString from: aSelector in: aClass within: aBrowserEnvironment
	"Implements the Remove Parameter refactoring: 'Removes an unused parameter from 
	all implementors of the method, and removes it from the message sends.' The <readableString>,
	aString, identifies the name of the argument which is removed, not the selector keyword.
	Answer the new selector after removal of the parameter."

	| model refactoring |
	model := RBModel onEnvironment: aBrowserEnvironment.
	refactoring := RemoveParameterRefactoring
				model: model
				removeParameter: aString
				in: aClass
				selector: aSelector.
	model name: refactoring displayString.
	^self performRefactoring: refactoring!

removeStaticVariables: aCollectionOfAssociations within: aBrowserEnvironment
	"Invoke the 'Remove Static Variable' refactoring for each of the {class, var. name} pairs in
	the argument. Note that all variables are removed as an atomic unit, so if one cannot be
	removed the whole operation is aborted. The operation also creates only one undo/redo unit."

	^self
		executeVariableRefactoring: RemoveClassVariableRefactoring
		variables: aCollectionOfAssociations
		within: aBrowserEnvironment!

renameClass: aClass to: newClassName showChanges: aBoolean
	| refactoring |
	refactoring := RenameClassRefactoring rename: aClass to: newClassName.
	refactoring shouldShowChanges: aBoolean.
	^self performRefactoring: refactoring!

renameClassVariable: aString to: newName in: aClass within: aBrowserEnvironment
	self
		renameVariable: aString
		to: newName
		isClassVariable: true
		of: aClass
		within: aBrowserEnvironment!

renameInstanceVariable: aString to: newName in: aClass within: aBrowserEnvironment
	self
		renameVariable: aString
		to: newName
		isClassVariable: false
		of: aClass
		within: aBrowserEnvironment!

renameMethod: aCompiledMethod
	"Implement the 'Rename' method refactoring: 'Renames all implementors of a method, all senders, 
	and all symbols references. In addition to strict renaming, it also allows you to rearrange the parameters. 
	However, when rearranging the parameters, it cannot permute any symbols that are performed.'
	Answer the new refactoring, or nil if no rename actually took place."

	| prompter |
	prompter := self
				newMethodNamePrompter: (ScopedMethodName fromMethod: aCompiledMethod)
				caption: ('Rename <1p> …' expandMacrosWith: aCompiledMethod)
				allowExisting: false.
	^prompter showModal
		ifNotNil: 
			[:newName |
			self
				renameMethod: aCompiledMethod
				to: newName
				showChanges: prompter showChanges]!

renameMethod: aCompiledMethod to: aRBMethodName showChanges: aBoolean
	| model refactoring |
	model := RBModel onEnvironment: aRBMethodName scope.
	refactoring := RenameMethodRefactoring
				model: model
				renameMethod: aCompiledMethod selector
				in: aCompiledMethod methodClass
				to: aRBMethodName selector
				permutation: aRBMethodName permutation.
	refactoring shouldShowChanges: aBoolean.
	model name: refactoring displayString.
	^self performRefactoring: refactoring!

renameMethodReferences: aCompiledMethod
	"Implement the 'Rename' method refactoring: 'Renames all implementors of a method, all senders, 
	and all symbols references. In addition to strict renaming, it also allows you to rearrange the parameters. 
	However, when rearranging the parameters, it cannot permute any symbols that are performed.'
	Answer the refactoring, or nil if no rename actually took place."

	| prompter |
	prompter := self
				newMethodNamePrompter: (ScopedMethodName fromMethod: aCompiledMethod)
				caption: 'Rename References to <1p> …' << aCompiledMethod
				allowExisting: true.
	^prompter showModal
		ifNotNil: 
			[:newName |
			self
				renameMethodReferences: aCompiledMethod
				to: newName
				showChanges: prompter showChanges]!

renameMethodReferences: aCompiledMethod to: aRBMethodName showChanges: aBoolean
	| model refactoring |
	model := RBModel onEnvironment: aRBMethodName scope.
	refactoring := RenameMethodReferencesTransformation
				model: model
				renameMethod: aCompiledMethod selector
				in: aCompiledMethod methodClass
				to: aRBMethodName selector
				permutation: aRBMethodName permutation.
	refactoring shouldShowChanges: aBoolean.
	model name: refactoring displayString.
	^self performRefactoring: refactoring!

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
						prompt: ('Please enter the new name for <p>:' expandMacrosWith: oldName)
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
						showHintWhenEmpty: false;
						showModal.
			newName])
			ifNotNil: 
				[:newName |
				self performRefactoringAction: 
						[(RenameTemporaryRefactoring
							renameTemporaryFrom: aStVariableNode sourceInterval
							to: newName
							in: aClass
							selector: aSelector) execute]]!

renameVariable: oldNameString to: newNameString isClassVariable: aBoolean of: aClass within: aBrowserEnvironment
	^(self
		refactoringToRenameVariable: oldNameString
		to: newNameString
		isClassVariable: aBoolean
		of: aClass
		within: aBrowserEnvironment) ifNotNil: [:refactoring | self performRefactoring: refactoring]!

selectTargetVariableOf: aClass parseTree: aStMethodNode
	| variables default classes |
	variables := OrderedCollection new.
	"Method arguments"
	aStMethodNode isNil
		ifFalse: [aStMethodNode argumentNames asSortedArray do: [:each | variables addLast: nil -> each]].
	classes := aClass withAllSuperclasses.
	"Instance variables"
	classes
		do: [:eachClass | eachClass instanceVariableNames do: [:eachVar | variables addLast: eachClass -> eachVar]].
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

showChangesText
	^'Show proposed changes?'!

stubTextFor: aSymbol arguments: anArray inClass: aClass
	| source body argc |
	source := String smalltalkWriteStream: 128.
	body := '^Error notYetImplemented'.
	argc := anArray size.
	argc == 0
		ifTrue: 
			[source nextPutAll: aSymbol.
			(aClass allInstanceVariableNames includes: aSymbol asString)
				ifTrue: [body := '^<1s>' expandMacrosWith: aSymbol]]
		ifFalse: 
			[argc == 1
				ifTrue: 
					[aSymbol isInfix
						ifTrue: 
							[source
								nextPutAll: aSymbol;
								space;
								nextPutAll: anArray single name]
						ifFalse: 
							[| name |
							self
								emitKeywordSignatureFor: aSymbol
								withArgs: anArray
								in: aClass
								on: source.
							"If the selector without final colon matches an instance variable name, assume the method is an mutator for that inst var."
							name := aSymbol allButLast.
							(aClass allInstanceVariableNames includes: name)
								ifTrue: [body := '<1s> := <2s>' expandMacrosWith: name with: anArray first]]]
				ifFalse: 
					[self
						emitKeywordSignatureFor: aSymbol
						withArgs: anArray
						in: aClass
						on: source]].
	source
		crtab;
		nextPutAll: body.
	^source contents!

validateCreateSubclass: aClassDetails
	^(AddClassRefactoring details: aClassDetails subclasses: #()) preconditions validate!

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
				errorString: ['<1p> is already defined' expandMacrosWith: aString]))
			validate! !

!Tools.RefactoringSmalltalkSystem categoriesForMethods!
abortSignal!constants!private! !
abstractClassVariable:in:within:!public!refactoring! !
abstractClassVariables:within:!public!refactoring! !
abstractInstanceVariable:in:within:!public!refactoring! !
abstractInstanceVariables:within:!public!refactoring! !
accessorsFor:isClassVariable:of:within:!private!refactoring! !
addClassVariable:to:!public!refactoring! !
addClassVariableTo:!public!refactoring! !
addFilteredMethod:forLintRule:!public!refactoring! !
addImportToClasses:!public! !
addInstanceVariable:to:!public!refactoring! !
addInstanceVariableTo:!public!refactoring! !
addParameterToMethod:!commands!public!refactoring! !
addParameterToMethod:inPackages:!public!refactoring! !
addSharedVariable:to:!commands!public! !
basicCreateSubclass:subclasses:!private!refactoring! !
basicRemoveMethods:within:showChanges:!private!refactoring! !
basicRemoveMethodsIn:within:showChanges:!private!refactoring! !
basicRemoveSelectors:from:within:showChanges:!private!refactoring! !
browseMethodsIn:!browsing!public! !
browseMethodsInEnvironments:!browsing!public! !
browseSelectors:caption:environment:!browsing!private! !
canChangeClassNamespaces:!enquiries!public! !
canRefactor!public!testing! !
changeNamespaceOfClasses:!operations!public! !
chooseMethodFromEnvironment:caption:!public! !
chooseSelectorInEnvironment:caption:!public! !
cloneClass:as:under:in:!private!refactoring! !
confirmRenameClass:to:!event handling!private! !
convertTemporaryToInstanceVariable:in:selector:!public!refactoring! !
convertToSibling:!public!refactoring! !
createInstanceVariableAccessors:in:within:!public!refactoring! !
createNewClass:inPackage:!public!refactoring! !
createVariableAccessors:classVariables:within:!public!refactoring! !
duplicateOf:in:!helpers!private! !
duplicateSuperclassMethodsOf:!enquiries!private! !
emitKeywordSignatureFor:withArgs:in:on:!private! !
executeRefactoring:!private!refactoring! !
executeVariableRefactoring:variables:within:!helpers!private!refactoring! !
extendMethodBrowserMenus:!browsing!private! !
extractMethod:from:in:!public!refactoring! !
extractToComponent:from:in:!public!refactoring! !
extractToTemporary:from:in:!public!refactoring! !
generateStubFor:inClass:withArgs:!private! !
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
moveClasses:toNamespace:showChanges:!commands!private!refactoring! !
moveTempToInnerScope:in:selector:!public!refactoring! !
moveToComponent:in:variable:!public!refactoring! !
newMethodNamePrompter:caption:allowExisting:!helpers!private!refactoring! !
newMethodRefactoringToolFor:!helpers!private!refactoring! !
nukeChangeHistory!private!refactoring! !
performRefactoring:!public!refactoring! !
performRefactoringAction:!private!refactoring! !
performRefactorings:showChanges:!private!refactoring! !
promptForInitializationExpression:!private!refactoring! !
promptToRemoveMethods:inEnvironment:!private!refactoring! !
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
refactoringError!constants!private! !
refactoringToRenameVariable:to:isClassVariable:of:within:!private!refactoring! !
removeClasses:!public!refactoring! !
removeClassVariable:from:within:!public!refactoring! !
removeFilteredMethod:forLintRule:!public!refactoring! !
removeImportFromClasses:!public! !
removeInstanceVariable:from:within:!public!refactoring! !
removeInstanceVariables:within:!public!refactoring! !
removeMethods:!public!refactoring! !
removeMethodsDuplicatedInSuperclassOf:!private!refactoring! !
removeParameter:from:in:within:!public!refactoring! !
removeStaticVariables:within:!public!refactoring! !
renameClass:to:showChanges:!public!refactoring! !
renameClassVariable:to:in:within:!private!refactoring! !
renameInstanceVariable:to:in:within:!private!refactoring! !
renameMethod:!public!refactoring! !
renameMethod:to:showChanges:!private!refactoring! !
renameMethodReferences:!public!refactoring! !
renameMethodReferences:to:showChanges:!private!refactoring! !
renameTemporary:to:in:selector:!public!refactoring! !
renameVariable:to:isClassVariable:of:within:!private!refactoring! !
selectTargetVariableOf:parseTree:!helpers!private!refactoring! !
showChangesText!constants!private! !
stubTextFor:arguments:inClass:!private! !
validateCreateSubclass:!helpers!private!refactoring! !
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
	RefactoringSignal := Refactoring preconditionSignal!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	MethodCategory removeCategory: '*-RB fixes'.
	self uninstallCurrent! !

!Tools.RefactoringSmalltalkSystem class categoriesForMethods!
initialize!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

