"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.Refactoring'
	instanceVariableNames: 'model options'
	classVariableNames: 'RefactoringOptions'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Refactoring guid: (Core.GUID fromString: '{fa372b47-a5ce-4ce3-b6dc-f4a2e26195b5}')!
Refactory.Browser.Refactoring isNonInstantiable: true!
Refactory.Browser.Refactoring comment: ''!
!Refactory.Browser.Refactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.Refactoring methodsFor!

associationForClassVariable: aName in: aClass ifAbsent: aBlock
	^aClass realClass classPool associationAt: aName ifAbsent: aBlock!

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

convertMethod: aRBMethod using: aParseTreeRewriter
	"Convert the parse tree for the specified method using the specified rewriter. If a change is made then compile it into the changeBuilder."

	| parseTree |
	parseTree := aRBMethod parseTree.
	parseTree isNil ifTrue: [^self].
	(aParseTreeRewriter executeTree: parseTree)
		ifTrue: [aRBMethod modelClass compileTree: aParseTreeRewriter tree]!

copyOptionsFrom: aDictionary
	| dict defaults |
	dict := self options.
	defaults := self class refactoringOptions.
	dict == defaults ifTrue: [^self options: aDictionary copy].
	dict
		keysAndValuesDo: [:key :value | value == (defaults at: key) ifTrue: [dict at: key put: (aDictionary at: key)]].
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

getOptionImplementorToInline: anOrderedCollection
	^self error: 'Option not implemented'!

getOptionInlineExpression: aString
	^self confirm: ('Do you want to inline "<1s>"? If not, it will be assigned as a temporary.'
				expandMacrosWith: aString)!

getOptionInlineOverridden: aSymbol of: aClass
	^self confirm: ('<1d>>><2p> is overridden.<n>Do you want to inline it anyway?'
				expandMacrosWith: aClass unqualifiedName
				with: aSymbol)!

getOptionInlineReordered: inlineRBMethod into: intoRBMethod
	^self
		confirm: ('To inline <1p> into <2p> we need to move some of its statements before the original message send.<n>This could change the order of execution, which can change the behavior.<n>Do you want to proceed?'
				expandMacrosWith: inlineRBMethod
				with: intoRBMethod)!

getOptionMethodName: anRBMethodName
	| mname |
	mname := UI.Prompter prompt: 'Enter the new method name (without the ''#'') '.
	^mname notNil 
		ifTrue: 
			[mname := mname asSymbol.
			anRBMethodName selector: mname]!

getOptionOpenBrowser: anRBEnvironment
	^anRBEnvironment openEditor!

getOptionPullUpNonSharedInstVar: aString
	^self
		confirm: 'Not all subclasses have an instance variable named <1p>.<n>Do you want pull up this variable anyway?'
				<< aString!

getOptionRemoveMethod: aSymbol referencedIn: aCollection
	(self
		confirm: ('The selector <1p> is referenced from <2d> other methods.<n><n>Would you like to browse references?'
				expandMacrosWith: aSymbol
				with: aCollection size))
			ifTrue: [self openBrowserOn: (self model environment referencesTo: aSymbol)].
	^false!

getOptionRemoveReferencedClass: aRBClass
	(self
		confirm: ('<1p> is referenced and cannot be removed safely.<n><n>Would you like to browse references?'
				expandMacrosWith: aRBClass))
			ifTrue: 
				[| searches |
				searches := self referenceSearchesForClass: aRBClass.
				self browseEnvironments: searches].
	^false!

getOptionRenameAllDefinitions: aCollection of: aSymbol
	^aCollection size <= 1 or: 
			[self confirm: ('This will modify all <1p> implementors. Proceed anyway?'
						expandMacrosWith: aCollection size)]!

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
				caption: 'Select class of new method…'.
	^classSelected notNil ifTrue: [{classSelected}] ifFalse: [nil]!

model
	#rbFix.	"Use #displayString instead of #printString for the name"
	^model isNil
		ifTrue: 
			[model := RBNamespace onEnvironment: self defaultEnvironment.
			model name: self displayString.
			model]
		ifFalse: [model]!

model: aRBNamespace 
	model := aRBNamespace!

onError: aBlock do: errorBlock 
	^aBlock on: self class preconditionSignal, self class abortSignal
		do: 
			[:ex | 
			errorBlock cull: ex.
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

refactoringAborted
	^self refactoringAborted: '<1d> aborted' << self!

refactoringAborted: aString
	#rbFix.	"Added so can trap user cancellation separately from actual errors and avoid annoying extra message box"
	^self class abortSignal signal: aString ?? 'Refactoring aborted'!

refactoringError: aString
	RefactoringError refactoring: self signal: aString!

refactoringError: aString with: aBlock
	#rbFix.	"Include a reference to the receiver in the exception for improved error reporting."
	RefactoringError
		refactoring: self
		signal: aString
		with: aBlock!

refactoringWarning: aString
	RefactoringWarning refactoring: self signal: aString!

referenceSearchesForClass: aRBClass
	| searches |
	searches := OrderedCollection new.
	aRBClass bindingOrNil
		ifNotNil: [:binding | searches add: (self model environment referencesTo: binding)].
	searches add: (self model environment referencesTo: aRBClass).
	^searches!

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
	^(self options at: #selectVariableToMoveTo)
		value: self
		value: aClass
		value: aSelector!

selectVariableTypesFrom: initialTypeCollection selected: selectedTypeCollection
	^(self options at: #variableTypes)
		value: self
		value: initialTypeCollection
		value: selectedTypeCollection!

setOption: aSymbol toUse: aBlock 
	| dict |
	dict := self options.
	dict == self class refactoringOptions ifTrue: [dict := dict copy].
	dict at: aSymbol put: aBlock.
	self options: dict!

shouldExtractAssignmentTo: aString
	^(self options at: #extractAssignment) value: self value: aString!

shouldPullUpNonSharedInstanceVariable: aString
	^(self options at: #pullUpNonSharedInstVar) value: self value: aString!

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
!Refactory.Browser.Refactoring categoriesForMethods!
associationForClassVariable:in:ifAbsent:!public!utilities! !
browseEnvironments:!public!requests! !
canReferenceVariable:in:!public!testing! !
changes!accessing!public! !
checkClass:selector:using:!public!support! !
checkInstanceVariableName:in:!public!utilities! !
checkMethodName:in:!public!utilities! !
checkPreconditions!preconditions!public! !
checkPreconditions:!preconditions!public! !
classObjectFor:!accessing!private! !
convertAllReferencesTo:using:!public!support! !
convertAllReferencesToClass:using:!public!support! !
convertClasses:select:using:!public!support! !
convertMethod:using:!public!support! !
copyOptionsFrom:!accessing!public! !
defaultEnvironment!public!transforming! !
execute!public!transforming! !
getOptionAlreadyDefined:selector:!options!public! !
getOptionBrowseEnvironments:!options!public! !
getOptionExtractAssignment:!options!public! !
getOptionImplementorToInline:!options!public! !
getOptionInlineExpression:!options!public! !
getOptionInlineOverridden:of:!preconditions!public! !
getOptionInlineReordered:into:!options!public! !
getOptionMethodName:!options!public! !
getOptionOpenBrowser:!options!public! !
getOptionPullUpNonSharedInstVar:!options!public! !
getOptionRemoveMethod:referencedIn:!options!public! !
getOptionRemoveReferencedClass:!options!public! !
getOptionRenameAllDefinitions:of:!options!public! !
getOptionSelfArgumentName!options!public! !
getOptionUseExistingMethod:!options!public! !
getOptionVariableToMoveToOf:in:!options!public! !
getOptionVariableTypes:selected:!options!public! !
model!public!transforming! !
model:!initialize/release!public! !
onError:do:!exceptions!private! !
openBrowserOn:!public!requests! !
options!accessing!public! !
options:!accessing!public! !
performComponentRefactoring:!public!transforming! !
poolVariableNamesFor:!public!utilities! !
preconditions!preconditions!public! !
primitiveExecute!operations!private! !
refactoringAborted!exceptions!private! !
refactoringAborted:!exceptions!private! !
refactoringError:!exceptions!private! !
refactoringError:with:!exceptions!private! !
refactoringWarning:!exceptions!private! !
referenceSearchesForClass:!helpers!private! !
requestMethodNameFor:!public!requests! !
requestSelfArgumentName!public!requests! !
safeMethodNameFor:basedOn:!public!utilities! !
selectVariableToMoveMethodTo:class:!public!requests! !
selectVariableTypesFrom:selected:!public!requests! !
setOption:toUse:!accessing!public! !
shouldExtractAssignmentTo:!public!requests! !
shouldPullUpNonSharedInstanceVariable:!preconditions!public! !
transform!public!transforming! !
uniqueMethodNameFor:!helpers!private! !
whichVariableNode:inInterval:name:!public!utilities! !
!

!Refactory.Browser.Refactoring class methodsFor!

abortSignal
	^OperationAborted!

initialize
	self initializeRefactoringOptions!

initializeRefactoringOptions
	"
		self initializeRefactoringOptions
	"

	RefactoringOptions := (IdentityDictionary
				withAll: {#methodName -> [:refactoring :methodName | refactoring getOptionMethodName: methodName].
						#selfArgumentName -> [:refactoring | refactoring getOptionSelfArgumentName].
						#selectVariableToMoveTo
							-> [:refactoring :class :selector | refactoring getOptionVariableToMoveToOf: class in: selector].
						#variableTypes
							-> [:refactoring :initial :selected | refactoring getOptionVariableTypes: initial selected: selected].
						#extractAssignment
							-> [:refactoring :varName | refactoring getOptionExtractAssignment: varName].
						#inlineExpression
							-> [:refactoring :expression | refactoring getOptionInlineExpression: expression].
						#alreadyDefined
							-> [:refactoring :class :selector | refactoring getOptionAlreadyDefined: class selector: selector].
						#useExistingMethod
							-> [:refactoring :selector | refactoring getOptionUseExistingMethod: selector].
						#openBrowser -> [:refactoring :env | refactoring getOptionOpenBrowser: env].
						#browseEnvironments
							-> [:refactoring :environments | refactoring getOptionBrowseEnvironments: environments].
						#removeReferencedClass
							-> [:refactoring :class | refactoring getOptionRemoveReferencedClass: class].
						#removeReferencedSelector
							-> [:refactoring :selector :references | refactoring getOptionRemoveMethod: selector referencedIn: references].
						#renameAllDefinitions
							-> [:refactoring :definitions :selector | refactoring getOptionRenameAllDefinitions: definitions of: selector].
						#inlineReordered
							-> [:refactoring :from :into | refactoring getOptionInlineReordered: from into: into].
						#pullUpNonSharedInstVar
							-> [:refactoring :varName | refactoring getOptionPullUpNonSharedInstVar: varName].
						#inlineOverridden
							-> [:refactoring :selector :class | refactoring getOptionInlineOverridden: selector of: class].
						#implementorToInline
							-> [:rcvr :implementors | rcvr getOptionImplementorToInline: implementors]})
				isImmutable: true;
				yourself!

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
	^RefactoringOptions!

setDefaultOption: aSymbol to: aBlock
	RefactoringOptions whileMutableDo: [RefactoringOptions at: aSymbol put: aBlock]!

uninitialize
	#rbFix. "Assist uninstallation of Dolphin package."
	RefactoringOptions := nil! !
!Refactory.Browser.Refactoring class categoriesForMethods!
abortSignal!accessing!public! !
initialize!initializing!public! !
initializeRefactoringOptions!accessing!public! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!public! !
preconditionSignal!accessing signal!public! !
refactoringOptions!accessing!public! !
setDefaultOption:to:!accessing!public! !
uninitialize!class hierarchy-removing!public! !
!

