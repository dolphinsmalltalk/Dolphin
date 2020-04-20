"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Refactoring
	instanceVariableNames: 'model options'
	classVariableNames: 'AbortSignal RefactoringOptions'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Refactoring guid: (GUID fromString: '{fa372b47-a5ce-4ce3-b6dc-f4a2e26195b5}')!
Refactoring isAbstract: true!
Refactoring comment: ''!
!Refactoring categoriesForClass!Refactory-Refactorings! !
!Refactoring methodsFor!

associationForClassVariable: aName in: aClass ifAbsent: aBlock 
	^aClass realClass classPool associationAt: aName asSymbol
		ifAbsent: [aClass realClass classPool associationAt: aName asString ifAbsent: aBlock]!

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
	self model allReferencesTo: aSymbol
		do: 
			[:method | 
			self 
				convertMethod: method selector
				for: method modelClass
				using: searchReplacer]!

convertAllReferencesToClass: aRBClass using: searchReplacer 
	self model allReferencesToClass: aRBClass
		do: 
			[:method | 
			self 
				convertMethod: method selector
				for: method modelClass
				using: searchReplacer]!

convertClasses: classSet select: aBlock using: searchReplacer 
	classSet do: 
			[:aClass | 
			(aBlock value: aClass) do: 
					[:selector | 
					self 
						convertMethod: selector
						for: aClass
						using: searchReplacer]]!

convertMethod: selector for: aClass using: searchReplacer 
	"Convert the parse tree for selector using the searchReplacer. If a
	change is made then compile it into the changeBuilder."

	| parseTree |
	parseTree := aClass parseTreeFor: selector.
	parseTree isNil ifTrue: [^self].
	(searchReplacer executeTree: parseTree) 
		ifTrue: [aClass compileTree: searchReplacer tree]!

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
	RefactoringManager instance addRefactoring: self 

!

getOptionAlreadyDefined: aClass selector: aSelection
	^self 
		confirm: ('<1p> is already defined in the <2p> hierarchy.<n>Extracting it to an existing selector may change behavior.<n><n>Do you wish to use <1p> anyway?' 
				expandMacrosWith: aSelection
				with: aClass)!

getOptionExtractAssignment: aString
	^self 
		confirm: ('Do you want to extract the assignment of <1s><n>at the end of selection?' 
				expandMacrosWith: aString)!

getOptionInlineExpression: aString
	^self 
		confirm: ('Do you want to inline "<1s>"? If not, it will be assigned as a temporary.' 
				expandMacrosWith: aString)!

getOptionMethodName: anRBMethodName
	| mname |
	mname := Prompter prompt: 'Enter the new method name (without the ''#'') '.
	^mname notNil 
		ifTrue: 
			[mname := mname asSymbol.
			anRBMethodName selector: mname]!

getOptionOpenBrowser: anRBEnvironment
	^anRBEnvironment openEditor!

getOptionSelfArgumentName
	^Prompter prompt: 'Enter name for argument to refer to "self" in extracted method'!

getOptionUseExistingMethod: aSelector
	^self confirm: ('Use existing method <1p> instead of creating a new method?' 
				expandMacrosWith: aSelector)!

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
	^ChoicePrompter choices: nameList caption: 'Select variable to move method into:'!

getOptionVariableTypes: types selected: selected
	| classSelected |
	selected.
	classSelected := ChoicePrompter choices: types asOrderedCollection
				caption: 'Select class of new method...'.
	^classSelected notNil ifTrue: [Array with: classSelected] ifFalse: [nil]!

model
	#rbFix. "Use #displayString instead of #printString for the name"
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
	aClass withAllSuperclasses do: 
			[:each |
			each allPoolDictionaryNames
				do: [:pool | pools addAll: (pool asQualifiedReference value keys collect: [:name | name asString])]].
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
	#rbFix. "Non-ANSI VisualWorks specific signal"
	"RefactoringError raiseSignal: aString"

	RefactoringError refactoring: self signal: aString!

refactoringError: aString with: aBlock 
	#rbFix. "Include a reference to the receiver in the exception for improved error reporting."
	RefactoringError refactoring: self signal: aString with: aBlock!

refactoringWarning: aString 
	#rbFix. "Use ANSI standard #signal:with: message, and include the Refactoring in the exception too"
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
	^(self options at: #selectVariableToMoveTo) valueWithArguments: (Array 
				with: self
				with: aClass
				with: aSelector)!

selectVariableTypesFrom: initialTypeCollection selected: selectedTypeCollection
	^(self options at: #variableTypes) valueWithArguments: (Array 
				with: self
				with: initialTypeCollection
				with: selectedTypeCollection)!

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
	^(self options at: #alreadyDefined) valueWithArguments: (Array 
				with: self
				with: aClass
				with: aSelector)!

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
	block := 
			[:aNode :answer | 
			(aNode intersectsInterval: anInterval) ifTrue: [aNode] ifFalse: [answer]].
	matcher
		matches: aName do: block;
		matchesArgument: aName do: block.
	^matcher executeTree: aParseTree initialAnswer: nil! !
!Refactoring categoriesFor: #associationForClassVariable:in:ifAbsent:!public!utilities! !
!Refactoring categoriesFor: #canReferenceVariable:in:!public!testing! !
!Refactoring categoriesFor: #changes!accessing!public! !
!Refactoring categoriesFor: #checkClass:selector:using:!public!support! !
!Refactoring categoriesFor: #checkInstanceVariableName:in:!public!utilities! !
!Refactoring categoriesFor: #checkMethodName:in:!public!utilities! !
!Refactoring categoriesFor: #checkPreconditions!preconditions!public! !
!Refactoring categoriesFor: #checkPreconditions:!preconditions!public! !
!Refactoring categoriesFor: #classObjectFor:!accessing!private! !
!Refactoring categoriesFor: #convertAllReferencesTo:using:!public!support! !
!Refactoring categoriesFor: #convertAllReferencesToClass:using:!public!support! !
!Refactoring categoriesFor: #convertClasses:select:using:!public!support! !
!Refactoring categoriesFor: #convertMethod:for:using:!public!support! !
!Refactoring categoriesFor: #copyOptionsFrom:!accessing!public! !
!Refactoring categoriesFor: #defaultEnvironment!public!transforming! !
!Refactoring categoriesFor: #execute!public!transforming! !
!Refactoring categoriesFor: #getOptionAlreadyDefined:selector:!options!public! !
!Refactoring categoriesFor: #getOptionExtractAssignment:!options!public! !
!Refactoring categoriesFor: #getOptionInlineExpression:!options!public! !
!Refactoring categoriesFor: #getOptionMethodName:!options!public! !
!Refactoring categoriesFor: #getOptionOpenBrowser:!options!public! !
!Refactoring categoriesFor: #getOptionSelfArgumentName!options!public! !
!Refactoring categoriesFor: #getOptionUseExistingMethod:!options!public! !
!Refactoring categoriesFor: #getOptionVariableToMoveToOf:in:!options!public! !
!Refactoring categoriesFor: #getOptionVariableTypes:selected:!options!public! !
!Refactoring categoriesFor: #model!public!transforming! !
!Refactoring categoriesFor: #model:!initialize/release!public! !
!Refactoring categoriesFor: #onError:do:!exceptions!private! !
!Refactoring categoriesFor: #openBrowserOn:!public!requests! !
!Refactoring categoriesFor: #options!accessing!public! !
!Refactoring categoriesFor: #options:!accessing!public! !
!Refactoring categoriesFor: #performComponentRefactoring:!public!transforming! !
!Refactoring categoriesFor: #poolVariableNamesFor:!public!utilities! !
!Refactoring categoriesFor: #preconditions!preconditions!public! !
!Refactoring categoriesFor: #primitiveExecute!operations!private! !
!Refactoring categoriesFor: #refactoringAborted:!exceptions!private! !
!Refactoring categoriesFor: #refactoringError:!exceptions!private! !
!Refactoring categoriesFor: #refactoringError:with:!exceptions!private! !
!Refactoring categoriesFor: #refactoringWarning:!exceptions!private! !
!Refactoring categoriesFor: #requestImplementorToInline:!public!requests! !
!Refactoring categoriesFor: #requestMethodNameFor:!public!requests! !
!Refactoring categoriesFor: #requestSelfArgumentName!public!requests! !
!Refactoring categoriesFor: #safeMethodNameFor:basedOn:!public!utilities! !
!Refactoring categoriesFor: #selectVariableToMoveMethodTo:class:!public!requests! !
!Refactoring categoriesFor: #selectVariableTypesFrom:selected:!public!requests! !
!Refactoring categoriesFor: #setOption:toUse:!accessing!public! !
!Refactoring categoriesFor: #shouldExtractAssignmentTo:!public!requests! !
!Refactoring categoriesFor: #shouldInlineExpression:!public!requests! !
!Refactoring categoriesFor: #shouldOverride:in:!public!requests! !
!Refactoring categoriesFor: #shouldUseExistingMethod:!public!requests! !
!Refactoring categoriesFor: #transform!public!transforming! !
!Refactoring categoriesFor: #uniqueMethodNameFor:!helpers!private! !
!Refactoring categoriesFor: #whichVariableNode:inInterval:name:!public!utilities! !

!Refactoring class methodsFor!

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
		setDefaultOption: #openBrowser toMessage: #getOptionOpenBrowser:!

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
!Refactoring class categoriesFor: #abortSignal!accessing!public! !
!Refactoring class categoriesFor: #initialize!public! !
!Refactoring class categoriesFor: #initializeRefactoringOptions!accessing!public! !
!Refactoring class categoriesFor: #new!instance creation!public! !
!Refactoring class categoriesFor: #onPreStripImage!class hierarchy-removing!public! !
!Refactoring class categoriesFor: #preconditionSignal!accessing signal!public! !
!Refactoring class categoriesFor: #refactoringOptions!accessing!public! !
!Refactoring class categoriesFor: #setDefaultOption:to:!accessing!public! !
!Refactoring class categoriesFor: #setDefaultOption:toMessage:!accessing!public! !
!Refactoring class categoriesFor: #uninitialize!class hierarchy-removing!public! !

