"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Refactory.Browser.Refactoring'
	instanceVariableNames: 'model options'
	classVariableNames: 'AbortSignal RefactoringOptions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Refactoring guid: (Core.GUID fromString: '{fa372b47-a5ce-4ce3-b6dc-f4a2e26195b5}')!
Refactory.Browser.Refactoring isNonInstantiable: true!
Refactory.Browser.Refactoring comment: ''!
!Refactory.Browser.Refactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.Refactoring methodsFor!

associationForClassVariable: aName in: aClass ifAbsent: aBlock 
	^aClass realClass classPool associationAt: aName asSymbol
		ifAbsent: [aClass realClass classPool associationAt: aName asString ifAbsent: aBlock]!

browseEnvironments: aCollectionOfBrowserEnvironments
	^(self options at: #browseEnvironments) value: self value: aCollectionOfBrowserEnvironments!

canReferenceVariable: aString in: aClass 
	(aClass definesVariable: aString) ifTrue: [^true].
	(self model includesGlobal: aString asSymbol) ifTrue: [^true].
	^(self poolVariableNamesFor: aClass) includes: aString!

changes
	^self model changes!

checkClass: aRBClass selector: aSelector using: aMatcher 
	| parseTree |
	parseTree := aRBClass parseTreeFor: aSelector.
	parseTree notNil ifTrue: [aMatcher executeTree: parseTree].
	^aMatcher answer!

checkInstanceVariableName: aName in: aClass 
	^RBCondition checkInstanceVariableName: aName in: aClass!

checkMethodName: aName in: aClass 
	^RBCondition checkMethodName: aName in: aClass!

checkPreconditions
	self checkPreconditions: self preconditions!

checkPreconditions: aCompositeRBCondition 
	aCompositeRBCondition check 
		ifFalse: 
			[| block |
			block := aCompositeRBCondition errorBlock.
			block notNil 
				ifTrue: [self refactoringError: aCompositeRBCondition errorString with: block]
				ifFalse: [self refactoringError: aCompositeRBCondition errorString]]!

classObjectFor: anObject 
	anObject isBehavior ifTrue: [^self model classFor: anObject].
	anObject isSymbol ifTrue: [^self model classNamed: anObject].
	^anObject!

convertAllReferencesTo: aSymbol using: searchReplacer
	self model allReferencesTo: aSymbol do: [:method | self convertMethod: method using: searchReplacer]!

convertAllReferencesToClass: aRBClass using: searchReplacer
	self model allReferencesToClass: aRBClass
		do: [:method | self convertMethod: method using: searchReplacer]!

convertClasses: classSet select: aBlock using: searchReplacer 
	classSet do: 
			[:aClass | 
			(aBlock value: aClass) do: 
					[:selector | 
					self 
						convertMethod: (aClass methodFor: selector)
						using: searchReplacer]]!

convertMethod: anRBMethod using: searchReplacer
	"Convert the parse tree for selector using the searchReplacer. If a change is made then compile it into the changeBuilder."

	| parseTree |
	parseTree := anRBMethod parseTree.
	parseTree isNil ifTrue: [^self].
	(searchReplacer executeTree: parseTree)
		ifTrue: [anRBMethod modelClass compileTree: searchReplacer tree]!

copyOptionsFrom: aDictionary 
	| dict |
	dict := self options.
	dict == self class refactoringOptions 
		ifTrue: [^self options: aDictionary copy].
	dict keysAndValuesDo: 
			[:key :value | 
			value == (self class refactoringOptions at: key) 
				ifTrue: [dict at: key put: (aDictionary at: key)]].
	self options: dict!

defaultEnvironment
	^BrowserEnvironment new!

execute
	self primitiveExecute.
	RefactoringManager instance addRefactoring: self!

getOptionAlreadyDefined: aClass selector: aSelection
	^self
		confirm: ('<1p> is already defined in the <2p> hierarchy.<n>Extracting it to an existing selector may change behavior.<n><n>Do you wish to use <1p> anyway?'
				expandMacrosWith: aSelection
				with: aClass)!

getOptionBrowseEnvironments: aCollectionOfBrowserEnvironments
	^Smalltalk developmentSystem browseMethodsInEnvironments: aCollectionOfBrowserEnvironments!

getOptionExtractAssignment: aString
	^self confirm: ('Do you want to extract the assignment of <1s><n>at the end of selection?'
				expandMacrosWith: aString)!

getOptionInlineExpression: aString
	^self confirm: ('Do you want to inline "<1s>"? If not, it will be assigned as a temporary.'
				expandMacrosWith: aString)!

getOptionMethodName: anRBMethodName
	| mname |
	mname := UI.Prompter prompt: 'Enter the new method name (without the ''#'') '.
	^mname notNil 
		ifTrue: 
			[mname := mname asSymbol.
			anRBMethodName selector: mname]!

getOptionOpenBrowser: anRBEnvironment
	^anRBEnvironment openEditor!

getOptionSelfArgumentName
	^UI.Prompter prompt: 'Enter name for argument to refer to "self" in extracted method'!

getOptionUseExistingMethod: aSelector
	^self
		confirm: ('Use existing method <1p> instead of creating a new method?' expandMacrosWith: aSelector)!

getOptionVariableToMoveToOf: aClass in: aSelector
	| parseTree nameList |
	parseTree := aClass parseTreeFor: aSelector.
	parseTree isNil
		ifTrue: [parseTree := RBMethodNode selector: #value body: (RBSequenceNode statements: #())].
	nameList := OrderedCollection new.
	nameList
		add: '---- Arguments ----';
		addAll: parseTree argumentNames asSortedCollection;
		add: '---- Instance Variables ----'.
	nameList addAll: aClass allInstanceVariableNames asSortedCollection.
	^UI.ChoicePrompter choices: nameList caption: 'Select variable to move method into:'!

getOptionVariableTypes: types selected: selected
	| classSelected |
	selected.
	classSelected := UI.ChoicePrompter choices: types asOrderedCollection
				caption: 'Select class of new method...'.
	^classSelected notNil ifTrue: [{classSelected}] ifFalse: [nil]!

model
	#rbFix.	"Use #displayString instead of #printString for the name"
	^model isNil
		ifTrue: 
			[model := (RBNamespace onEnvironment: self defaultEnvironment)
						name: self displayString;
						yourself]
		ifFalse: [model]!

model: aRBNamespace 
	model := aRBNamespace!

onError: aBlock do: errorBlock 
	^aBlock on: self class preconditionSignal
		do: 
			[:ex | 
			errorBlock value.
			ex return: nil]!

openBrowserOn: anEnvironment 
	^(self options at: #openBrowser) value: self value: anEnvironment!

options
	^options isNil ifTrue: [self class refactoringOptions] ifFalse: [options]!

options: aDictionary 
	options := aDictionary!

performComponentRefactoring: aRefactoring 
	aRefactoring copyOptionsFrom: self options.
	aRefactoring primitiveExecute!

poolVariableNamesFor: aClass
	| pools |
	pools := Set new.
	aClass withAllSuperclassesDo: 
			[:each |
			each allImports
				do: [:pool | pool asQualifiedReference value keys do: [:name | pools add: name asString]]].
	^pools!

preconditions
	self subclassResponsibility!

primitiveExecute
	self checkPreconditions.
	self transform!

refactoringAborted: aString
	#rbFix.	"Added so can trap user cancellation separately from actual errors and avoid annoying extra message box"
	^AbortSignal signal: aString!

refactoringError: aString
	#rbFix.	"Non-ANSI VisualWorks specific signal"
	"RefactoringError raiseSignal: aString"
	RefactoringError refactoring: self signal: aString!

refactoringError: aString with: aBlock
	#rbFix.	"Include a reference to the receiver in the exception for improved error reporting."
	RefactoringError
		refactoring: self
		signal: aString
		with: aBlock!

refactoringWarning: aString
	#rbFix.	"Use ANSI standard #signal:with: message, and include the Refactoring in the exception too"
	"RefactoringWarning raiseSignal: aString"
	RefactoringWarning refactoring: self signal: aString!

requestImplementorToInline: implementorsCollection 
	^(self options at: #implementorToInline) value: self
		value: implementorsCollection!

requestMethodNameFor: aMethodName 
	^(self options at: #methodName) value: self value: aMethodName!

requestSelfArgumentName
	^(self options at: #selfArgumentName) value: self!

safeMethodNameFor: aClass basedOn: aString 
	"Creates an unused method name containing aString"

	| baseString newString hasParam i |
	baseString := aString copy.
	baseString at: 1 put: baseString first asLowercase.
	newString := baseString.
	hasParam := newString last = $:.
	hasParam 
		ifTrue: [baseString := newString copyFrom: 1 to: newString size - 1].
	i := 0.
	[aClass hierarchyDefinesMethod: newString asSymbol] whileTrue: 
			[i := i + 1.
			newString := baseString , i printString 
						, (hasParam ifTrue: [':'] ifFalse: [''])].
	^newString asSymbol!

selectVariableToMoveMethodTo: aSelector class: aClass
	^(self options at: #selectVariableToMoveTo) valueWithArguments: {self. aClass. aSelector}!

selectVariableTypesFrom: initialTypeCollection selected: selectedTypeCollection
	^(self options at: #variableTypes)
		valueWithArguments: {self. initialTypeCollection. selectedTypeCollection}!

setOption: aSymbol toUse: aBlock 
	| dict |
	dict := self options.
	dict == self class refactoringOptions ifTrue: [dict := dict copy].
	dict at: aSymbol put: aBlock.
	self options: dict!

shouldExtractAssignmentTo: aString 
	^(self options at: #extractAssignment) value: self value: aString!

shouldInlineExpression: aString 
	^(self options at: #inlineExpression) value: self value: aString!

shouldOverride: aSelector in: aClass
	^(self options at: #alreadyDefined) valueWithArguments: {self. aClass. aSelector}!

shouldUseExistingMethod: aSelector 
	^(self options at: #useExistingMethod) value: self value: aSelector!

transform
	self subclassResponsibility!

uniqueMethodNameFor: anInteger
	| before after index name |
	before := 'a'.
	after := ''.
	anInteger timesRepeat: [after := after , 'z:'].
	index := 0.
	
	[name := before , index printString , after.
	(Symbol findInterned: name) notNil]
			whileTrue: [index := index + 1].
	^name asSymbol!

whichVariableNode: aParseTree inInterval: anInterval name: aName
	| matcher block |
	matcher := ParseTreeSearcher new.
	block := [:aNode :answer | (aNode intersectsInterval: anInterval) ifTrue: [aNode] ifFalse: [answer]].
	matcher
		matches: aName do: block;
		matchesArgument: aName do: block.
	^matcher executeTree: aParseTree initialAnswer: nil! !
!Refactory.Browser.Refactoring categoriesFor: #associationForClassVariable:in:ifAbsent:!public!utilities! !
!Refactory.Browser.Refactoring categoriesFor: #browseEnvironments:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #canReferenceVariable:in:!public!testing! !
!Refactory.Browser.Refactoring categoriesFor: #changes!accessing!public! !
!Refactory.Browser.Refactoring categoriesFor: #checkClass:selector:using:!public!support! !
!Refactory.Browser.Refactoring categoriesFor: #checkInstanceVariableName:in:!public!utilities! !
!Refactory.Browser.Refactoring categoriesFor: #checkMethodName:in:!public!utilities! !
!Refactory.Browser.Refactoring categoriesFor: #checkPreconditions!preconditions!public! !
!Refactory.Browser.Refactoring categoriesFor: #checkPreconditions:!preconditions!public! !
!Refactory.Browser.Refactoring categoriesFor: #classObjectFor:!accessing!private! !
!Refactory.Browser.Refactoring categoriesFor: #convertAllReferencesTo:using:!public!support! !
!Refactory.Browser.Refactoring categoriesFor: #convertAllReferencesToClass:using:!public!support! !
!Refactory.Browser.Refactoring categoriesFor: #convertClasses:select:using:!public!support! !
!Refactory.Browser.Refactoring categoriesFor: #convertMethod:using:!public!support! !
!Refactory.Browser.Refactoring categoriesFor: #copyOptionsFrom:!accessing!public! !
!Refactory.Browser.Refactoring categoriesFor: #defaultEnvironment!public!transforming! !
!Refactory.Browser.Refactoring categoriesFor: #execute!public!transforming! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionAlreadyDefined:selector:!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionBrowseEnvironments:!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionExtractAssignment:!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionInlineExpression:!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionMethodName:!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionOpenBrowser:!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionSelfArgumentName!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionUseExistingMethod:!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionVariableToMoveToOf:in:!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #getOptionVariableTypes:selected:!options!public! !
!Refactory.Browser.Refactoring categoriesFor: #model!public!transforming! !
!Refactory.Browser.Refactoring categoriesFor: #model:!initialize/release!public! !
!Refactory.Browser.Refactoring categoriesFor: #onError:do:!exceptions!private! !
!Refactory.Browser.Refactoring categoriesFor: #openBrowserOn:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #options!accessing!public! !
!Refactory.Browser.Refactoring categoriesFor: #options:!accessing!public! !
!Refactory.Browser.Refactoring categoriesFor: #performComponentRefactoring:!public!transforming! !
!Refactory.Browser.Refactoring categoriesFor: #poolVariableNamesFor:!public!utilities! !
!Refactory.Browser.Refactoring categoriesFor: #preconditions!preconditions!public! !
!Refactory.Browser.Refactoring categoriesFor: #primitiveExecute!operations!private! !
!Refactory.Browser.Refactoring categoriesFor: #refactoringAborted:!exceptions!private! !
!Refactory.Browser.Refactoring categoriesFor: #refactoringError:!exceptions!private! !
!Refactory.Browser.Refactoring categoriesFor: #refactoringError:with:!exceptions!private! !
!Refactory.Browser.Refactoring categoriesFor: #refactoringWarning:!exceptions!private! !
!Refactory.Browser.Refactoring categoriesFor: #requestImplementorToInline:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #requestMethodNameFor:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #requestSelfArgumentName!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #safeMethodNameFor:basedOn:!public!utilities! !
!Refactory.Browser.Refactoring categoriesFor: #selectVariableToMoveMethodTo:class:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #selectVariableTypesFrom:selected:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #setOption:toUse:!accessing!public! !
!Refactory.Browser.Refactoring categoriesFor: #shouldExtractAssignmentTo:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #shouldInlineExpression:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #shouldOverride:in:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #shouldUseExistingMethod:!public!requests! !
!Refactory.Browser.Refactoring categoriesFor: #transform!public!transforming! !
!Refactory.Browser.Refactoring categoriesFor: #uniqueMethodNameFor:!helpers!private! !
!Refactory.Browser.Refactoring categoriesFor: #whichVariableNode:inInterval:name:!public!utilities! !

!Refactory.Browser.Refactoring class methodsFor!

abortSignal
	^AbortSignal!

initialize
	AbortSignal := Signal description: 'Refactoring Aborted'!

initializeRefactoringOptions
	"
		self initializeRefactoringOptions
	"

	#rbFix.	"Updated for Dolphin UI and extracted blocks into Refactoring methods so can override"
	RefactoringOptions := IdentityDictionary new.
	self
		setDefaultOption: #methodName toMessage: #getOptionMethodName:;
		setDefaultOption: #selfArgumentName toMessage: #getOptionSelfArgumentName;
		setDefaultOption: #selectVariableToMoveTo toMessage: #getOptionVariableToMoveToOf:in:;
		setDefaultOption: #variableTypes toMessage: #getOptionVariableTypes:selected:;
		setDefaultOption: #extractAssignment toMessage: #getOptionExtractAssignment:;
		setDefaultOption: #inlineExpression toMessage: #getOptionInlineExpression:;
		setDefaultOption: #alreadyDefined toMessage: #getOptionAlreadyDefined:selector:;
		setDefaultOption: #useExistingMethod toMessage: #getOptionUseExistingMethod:;
		setDefaultOption: #openBrowser toMessage: #getOptionOpenBrowser:;
		setDefaultOption: #browseEnvironments toMessage: #getOptionBrowseEnvironments:!

new
	^(super new)
		initialize;
		yourself!

onPreStripImage
	#rbFix. "Assist dolphin's image stripping."
	self uninitialize!

preconditionSignal
	^RefactoringError , RefactoringWarning!

refactoringOptions
	RefactoringOptions isNil ifTrue: [self initializeRefactoringOptions].
	^RefactoringOptions!

setDefaultOption: aSymbol to: aBlock 
	self refactoringOptions at: aSymbol put: aBlock!

setDefaultOption: aSymbol toMessage: aSelector
	#rbFix.
	self setDefaultOption: aSymbol to: (Message selector: aSelector)!

uninitialize
	#rbFix. "Assist uninstallation of Dolphin package."
	RefactoringOptions := nil! !
!Refactory.Browser.Refactoring class categoriesFor: #abortSignal!accessing!public! !
!Refactory.Browser.Refactoring class categoriesFor: #initialize!public! !
!Refactory.Browser.Refactoring class categoriesFor: #initializeRefactoringOptions!accessing!public! !
!Refactory.Browser.Refactoring class categoriesFor: #new!instance creation!public! !
!Refactory.Browser.Refactoring class categoriesFor: #onPreStripImage!class hierarchy-removing!public! !
!Refactory.Browser.Refactoring class categoriesFor: #preconditionSignal!accessing signal!public! !
!Refactory.Browser.Refactoring class categoriesFor: #refactoringOptions!accessing!public! !
!Refactory.Browser.Refactoring class categoriesFor: #setDefaultOption:to:!accessing!public! !
!Refactory.Browser.Refactoring class categoriesFor: #setDefaultOption:toMessage:!accessing!public! !
!Refactory.Browser.Refactoring class categoriesFor: #uninitialize!class hierarchy-removing!public! !

