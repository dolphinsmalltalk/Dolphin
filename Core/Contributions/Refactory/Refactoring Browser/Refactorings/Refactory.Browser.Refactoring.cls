"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Refactory.Browser.Refactoring'
	instanceVariableNames: 'model options'
	classVariableNames: 'RefactoringOptions'
	imports: #(#{Kernel})
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Refactoring guid: (Core.GUID fromString: '{fa372b47-a5ce-4ce3-b6dc-f4a2e26195b5}')!
Refactory.Browser.Refactoring isNonInstantiable: true!
Refactory.Browser.Refactoring comment: ''!
!Refactory.Browser.Refactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.Refactoring methodsFor!

associationForClassVariable: aName in: aClass ifAbsent: aBlock
	^aClass realClass classPool associationAt: aName ifAbsent: aBlock!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	^Smalltalk!

browseEnvironments: aCollectionOfBrowserEnvironments
	^(self lookupOption: #browseEnvironments) cull: self cull: aCollectionOfBrowserEnvironments!

canReferenceVariable: aString in: aClass
	(aClass definesVariable: aString) ifTrue: [^true].
	(self model includesStaticVariable: aString) ifTrue: [^true].
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

checkMethodName: aName
	^RBCondition checkMethodName: aName!

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
	(self model allReferencesTo: aSymbol)
		do: [:method | self convertMethod: method using: searchReplacer]!

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
	(aParseTreeRewriter executeTree: parseTree) ifFalse: [^self].
	model compileTree: aParseTreeRewriter tree forMethod: aRBMethod!

copyOptionsFrom: aDictionary
	aDictionary ifNil: [^self].
	self assert: [aDictionary ~~ RefactoringOptions].
	options ifNil: [^self options: aDictionary copy].
	"Copy over any options that are not already set locally for this refactoring"
	aDictionary keysAndValuesDo: [:eachKey :eachValue | options at: eachKey ifAbsentPutClean: [eachValue]]!

defaultEnvironment
	^BrowserEnvironment new!

execute
	self primitiveExecute.
	RefactoringManager instance addRefactoring: self!

getOptionAbstractVariables
	^self
		confirm: 'This method has direct variable references which will need to be converted to getter/setters.'!

getOptionAlreadyDefined: aClass selector: aSelection
	^self
		confirm: ('<1p> is already defined in the <2p> hierarchy.<n>Extracting to an existing selector may change behavior.<n><n>Do you wish to use <1p> anyway?'
				expandMacrosWith: aSelection
				with: aClass)!

getOptionBrowseEnvironments: aCollectionOfBrowserEnvironments
	^#{Tools.SmalltalkSystem} value current
		browseMethodsInEnvironments: aCollectionOfBrowserEnvironments!

getOptionConvertReadBeforeWritten: aString
	^self confirm: '<1s> is read before it is written. Are you sure you want to convert it to an instance variable?' << aString!

getOptionCopyDownSuperclassMethod: aSelector
	self
		confirm: 'Do you want to copy down the superclass method to the classes that don''t define <1p>?'
				<< aSelector!

getOptionExtractAssignment: aString
	^self confirm: ('Do you want to extract the assignment of <1s><n>at the end of selection?'
				expandMacrosWith: aString)!

getOptionIgnoreSymbolicClassReferences: aCollection
	^self
		confirm: 'The original class name is still referenced as a Symbol in <1d> methods. If you proceed these Symbols will not be renamed as it cannot be guaranteed that they are referring to the class name. It is recommended that you first browse all references to verify the use, and replace any that are real references to the class with literal BindingReferences.<n><n>Are you sure you want to proceed?'
				<< aCollection size!

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

getOptionMovePools: aCollection
	^self
		confirm: 'This method contains references to shared variables from namespaces that may need to be imported into the target.'!

getOptionNewMethodName: aRBMethodName classes: aCollection
	| mname |
	mname := self prompt: 'Enter the new method name (without the ''#'')'.
	^mname ifNotNil: [aRBMethodName selector: mname]!

getOptionOpenBrowser: anRBEnvironment
	^anRBEnvironment openEditor!

getOptionPullUpNonSharedInstVar: aString
	^self
		confirm: 'Not all subclasses have an instance variable named <1p>.<n>Do you want pull up this variable anyway?'
				<< aString!

getOptionPushUpRemoveDuplicates: aString in: aCollectionOfClasses
	^self confirm: 'Do you want to remove duplicate subclass methods?'!

getOptionRemoveClass: aRBClass referencedIn: aCollection
	(self
		confirm: '<1p> is referenced in <2d> methods and cannot be removed safely.<n><n>Would you like to browse references?'
				<< {aRBClass. aCollection size})
			ifTrue: [self openBrowserOn: (self model environment forMethods: aCollection)].
	^false!

getOptionRemoveDuplicatesWithSupersends: superMessages
	^superMessages allSatisfy: 
			[:each |
			self
				confirm: 'Although <1p> is equivalent to a superclass method,<n>it contains a super send so removing it might modify behavior.<n><n>Are you sure you want to remove it?'
						<< each]!

getOptionRemoveMethod: aSymbol referencedIn: aCollection
	(self
		confirm: ('The selector <1p> is referenced from <2d> other methods.<n><n>Would you like to browse references?'
				expandMacrosWith: aSymbol
				with: aCollection size))
			ifTrue: [self openBrowserOn: (self model environment referencesTo: aSymbol)].
	^false!

getOptionRemoveVariable: aVariableBinding referencedIn: aCollection
	| args |
	args := {aVariableBinding environment. aVariableBinding key. aCollection size}.
	(self
		confirm: 'The class variable <1p>.<2s> is referenced from <3d> methods.<n><n>Would you like to browse references?'
				<< args)
			ifTrue: 
				[self openBrowserOn: ((self model environment forMethods: aCollection)
							label: 'References to <1p>.<2s>' << args;
							yourself)].
	^false!

getOptionRenameAllDefinitions: aCollection of: aSymbol
	^aCollection size <= 1 or: 
			[self confirm: ('This will modify all <1p> implementors. Proceed anyway?'
						expandMacrosWith: aCollection size)]!

getOptionRenameReferencesTo: aSymbol
	^self
		confirm: 'Renaming method references may not preserve behaviour.<n><n>Are you sure you want to proceed?'
				expandMacros!

getOptionReplaceReferencesTo: oldSymbol with: newSymbol
	^self
		confirm: 'Renaming method references may not preserve behaviour.<n><n>Are you sure you want to proceed?'
				expandMacros!

getOptionSelfArgumentName
	^self prompt: 'Enter name for argument to refer to "self" in extracted method'!

getOptionUseExistingMethod: aSelector
	^self
		confirm: ('Use existing method <1p> instead of creating a new method?' expandMacrosWith: aSelector)!

getOptionVariableToMoveToOf: aClass in: aSelector
	| parseTree nameList |
	parseTree := aClass parseTreeFor: aSelector.
	parseTree isNil
		ifTrue: [parseTree := StMethodNode selector: #value body: (StSequenceNode statements: #())].
	nameList := OrderedCollection new.
	nameList
		add: '---- Arguments ----';
		addAll: parseTree argumentNames asSortedCollection;
		add: '---- Instance Variables ----'.
	nameList addAll: aClass allInstanceVariableNames asSortedCollection.
	^#{UI.ChoicePrompter} value choices: nameList caption: 'Select variable to move method into:'!

getOptionVariableTypes: choicesCollection selected: suggestionsCollection
	| classSelected |
	classSelected := self chooseFrom: choicesCollection caption: 'Select class of new method…'.
	^classSelected notNil ifTrue: [{classSelected}] ifFalse: [nil]!

lookupOption: aSymbol
	options ifNotNil: [(options lookup: aSymbol) ifNotNil: [:option | ^option]].
	^RefactoringOptions at: aSymbol!

model
	#rbFix.	"Use #displayString instead of #printString for the name"
	^model isNil
		ifTrue: 
			[model := RBModel onEnvironment: self defaultEnvironment.
			model name: self displayString.
			model]
		ifFalse: [model]!

model: aRBModel
	model := aRBModel!

onError: aBlock do: errorBlock 
	^aBlock on: self class preconditionSignal, self class abortSignal
		do: 
			[:ex | 
			errorBlock cull: ex.
			ex return: nil]!

openBrowserOn: anEnvironment
	^(self lookupOption: #openBrowser) cull: self cull: anEnvironment!

options
	^options ?? RefactoringOptions!

options: aDictionary 
	self assert: [aDictionary ~~ RefactoringOptions].
	options := aDictionary!

performComponentRefactoring: aRefactoring 
	aRefactoring copyOptionsFrom: options.
	aRefactoring primitiveExecute!

poolVariableNamesFor: aClass
	| names |
	names := Set new.
	aClass allImports
		do: [:import | import valueOrNil ifNotNil: [:pool | pool definedBindings do: [:var | names add: var key]]].
	^names!

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

requestNewMethodName: aMethodName forClasses: aCollection
	^(self lookupOption: #methodName)
		cull: self
		cull: aMethodName
		cull: aCollection!

requestSelfArgumentName
	^(self lookupOption: #selfArgumentName) cull: self!

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
	^(self lookupOption: #selectVariableToMoveTo)
		cull: self
		cull: aClass
		cull: aSelector!

selectVariableTypesFrom: initialTypeCollection selected: selectedTypeCollection
	^(self lookupOption: #variableTypes)
		cull: self
		cull: initialTypeCollection
		cull: selectedTypeCollection!

setOption: aSymbol toUse: aBlock
	(options ifNil: [options := IdentityDictionary new]) at: aSymbol put: aBlock!

shortestNameForStaticVariable: aStVariableNode
	"Private - Determine and answer the least qualified name for the specified variable reference that will still bind to the original variable with the current state of the refactoring model. This relies on the node in question having been passed through a semantic analyser before the model's state was updated for (e.g.) a rename, i.e. the AST needs to have been 'bound'."

	^self shortestNameToBind: aStVariableNode binding from: aStVariableNode!

shortestNameToBind: aRBVariableBinding from: aVariableNode
	"Private - Answer the least qualified name that will bind to the model static variable represented by the first argument, from the context of the parse node passed as the 2nd argument, against the current state of the refactoring model."

	| current pathString root scope |
	pathString := aRBVariableBinding unqualifiedName.
	current := aRBVariableBinding.
	root := model rootNamespace.
	scope := aVariableNode scope.
	
	[| var |
	var := scope resolveIdentifier: pathString.
	(var notNil and: [var binding == aRBVariableBinding]) ifTrue: [^pathString].
	(current := current environment) == root]
			whileFalse: [pathString := current unqualifiedName , BindingReference.PathSeparatorString , pathString].
	"Nothing but the fully-qualified name will do"
	^aRBVariableBinding fullName!

shouldExtractAssignmentTo: aString
	^(self lookupOption: #extractAssignment) cull: self cull: aString!

shouldPullUpNonSharedInstanceVariable: aString
	^(self lookupOption: #pullUpNonSharedInstVar) cull: self cull: aString!

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
baseEnvironment!constants!private! !
browseEnvironments:!public!requests! !
canReferenceVariable:in:!public!testing! !
changes!accessing!public! !
checkClass:selector:using:!public!support! !
checkInstanceVariableName:in:!public!utilities! !
checkMethodName:!public!utilities! !
checkPreconditions!preconditions!public! !
checkPreconditions:!preconditions!public! !
classObjectFor:!accessing!private! !
convertAllReferencesTo:using:!public!support! !
convertAllReferencesToClass:using:!public!support! !
convertClasses:select:using:!public!support! !
convertMethod:using:!public!support! !
copyOptionsFrom:!operations!public! !
defaultEnvironment!public!transforming! !
execute!public!transforming! !
getOptionAbstractVariables!options!public! !
getOptionAlreadyDefined:selector:!options!public! !
getOptionBrowseEnvironments:!options!public! !
getOptionConvertReadBeforeWritten:!options!public! !
getOptionCopyDownSuperclassMethod:!public! !
getOptionExtractAssignment:!options!public! !
getOptionIgnoreSymbolicClassReferences:!options!public! !
getOptionImplementorToInline:!options!public! !
getOptionInlineExpression:!options!public! !
getOptionInlineOverridden:of:!options!public! !
getOptionInlineReordered:into:!options!public! !
getOptionMovePools:!options!public! !
getOptionNewMethodName:classes:!options!public! !
getOptionOpenBrowser:!options!public! !
getOptionPullUpNonSharedInstVar:!options!public! !
getOptionPushUpRemoveDuplicates:in:!options!public! !
getOptionRemoveClass:referencedIn:!options!public! !
getOptionRemoveDuplicatesWithSupersends:!options!public! !
getOptionRemoveMethod:referencedIn:!options!public! !
getOptionRemoveVariable:referencedIn:!options!public! !
getOptionRenameAllDefinitions:of:!options!public! !
getOptionRenameReferencesTo:!options!public! !
getOptionReplaceReferencesTo:with:!options!public! !
getOptionSelfArgumentName!options!public! !
getOptionUseExistingMethod:!options!public! !
getOptionVariableToMoveToOf:in:!options!public! !
getOptionVariableTypes:selected:!options!public! !
lookupOption:!accessing!options!private! !
model!public!transforming! !
model:!initialize/release!public! !
onError:do:!exceptions!private! !
openBrowserOn:!public!requests! !
options!accessing!options!public! !
options:!accessing!options!public! !
performComponentRefactoring:!public!transforming! !
poolVariableNamesFor:!public!utilities! !
preconditions!preconditions!public! !
primitiveExecute!operations!private! !
refactoringAborted!exceptions!private! !
refactoringAborted:!exceptions!private! !
refactoringError:!exceptions!private! !
refactoringError:with:!exceptions!private! !
refactoringWarning:!public!requests! !
requestNewMethodName:forClasses:!public!requests! !
requestSelfArgumentName!public!requests! !
safeMethodNameFor:basedOn:!public!utilities! !
selectVariableToMoveMethodTo:class:!public!requests! !
selectVariableTypesFrom:selected:!public!requests! !
setOption:toUse:!accessing!options!public! !
shortestNameForStaticVariable:!private!utilities! !
shortestNameToBind:from:!private!utilities! !
shouldExtractAssignmentTo:!public!requests! !
shouldPullUpNonSharedInstanceVariable:!preconditions!public! !
transform!public!transforming! !
uniqueMethodNameFor:!helpers!private! !
whichVariableNode:inInterval:name:!public!utilities! !
!

!Refactory.Browser.Refactoring class methodsFor!

abortSignal
	^OperationAborted!

errorSignal
	^RefactoringError!

initialize
	self initializeRefactoringOptions!

initializeRefactoringOptions
	"
		self initializeRefactoringOptions
	"

	RefactoringOptions := (IdentityDictionary
				withAll: {#abstractVariables -> [:refactoring | refactoring getOptionAbstractVariables].
						#alreadyDefined
							-> [:refactoring :class :selector | refactoring getOptionAlreadyDefined: class selector: selector].
						#browseEnvironments
							-> [:refactoring :environments | refactoring getOptionBrowseEnvironments: environments].
						#copyDownSuperclassMethod
							-> [:refactoring :selector | refactoring getOptionCopyDownSuperclassMethod: selector].
						#extractAssignment
							-> [:refactoring :varName | refactoring getOptionExtractAssignment: varName].
						#ignoreSymbolicClassReferences
							-> [:refactoring :references | refactoring getOptionIgnoreSymbolicClassReferences: references].
						#implementorToInline
							-> [:rcvr :implementors | rcvr getOptionImplementorToInline: implementors].
						#inlineExpression
							-> [:refactoring :expression | refactoring getOptionInlineExpression: expression].
						#inlineOverridden
							-> [:refactoring :selector :class | refactoring getOptionInlineOverridden: selector of: class].
						#inlineReordered
							-> [:refactoring :from :into | refactoring getOptionInlineReordered: from into: into].
						#movePools -> [:refactoring :pools | refactoring getOptionMovePools: pools].
						#methodName
							-> [:refactoring :methodName :classes | refactoring getOptionNewMethodName: methodName classes: classes].
						#openBrowser -> [:refactoring :env | refactoring getOptionOpenBrowser: env].
						#pullUpNonSharedInstVar
							-> [:refactoring :varName | refactoring getOptionPullUpNonSharedInstVar: varName].
						#pushUpRemoveDuplicates
							-> [:refactoring :selector :classes | refactoring getOptionPushUpRemoveDuplicates: selector in: classes].
						#convertReadBeforeWritten
							-> [:refactoring :temp | refactoring getOptionConvertReadBeforeWritten: temp].
						#removeDuplicatesWithSupersends
							-> [:refactoring :messages | refactoring getOptionRemoveDuplicatesWithSupersends: messages].
						#removeReferencedClass
							-> [:refactoring :class :references | refactoring getOptionRemoveClass: class referencedIn: references].
						#removeReferencedSelector
							-> [:refactoring :selector :references | refactoring getOptionRemoveMethod: selector referencedIn: references].
						#removeReferencedVariable
							-> [:refactoring :var :references | refactoring getOptionRemoveVariable: var referencedIn: references].
						#renameAllDefinitions
							-> [:refactoring :definitions :selector | refactoring getOptionRenameAllDefinitions: definitions of: selector].
						#replaceReferences
							-> [:refactoring :oldSelector :newSelector | refactoring getOptionReplaceReferencesTo: oldSelector with: newSelector].
						#selectVariableToMoveTo
							-> [:refactoring :class :selector | refactoring getOptionVariableToMoveToOf: class in: selector].
						#selfArgumentName -> [:refactoring | refactoring getOptionSelfArgumentName].
						#useExistingMethod
							-> [:refactoring :selector | refactoring getOptionUseExistingMethod: selector].
						#variableTypes
							-> [:refactoring :initial :selected | refactoring getOptionVariableTypes: initial selected: selected]})
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
	^self errorSignal , RefactoringWarning!

refactoringOptions
	^RefactoringOptions!

setDefaultOption: aSymbol to: aBlock
	RefactoringOptions whileMutableDo: [RefactoringOptions at: aSymbol put: aBlock]!

uninitialize
	#rbFix. "Assist uninstallation of Dolphin package."
	RefactoringOptions := nil! !
!Refactory.Browser.Refactoring class categoriesForMethods!
abortSignal!constants!public! !
errorSignal!constants!public! !
initialize!initializing!public! !
initializeRefactoringOptions!accessing!public! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!public! !
preconditionSignal!accessing signal!public! !
refactoringOptions!accessing!public! !
setDefaultOption:to:!accessing!public! !
uninitialize!class hierarchy-removing!public! !
!

